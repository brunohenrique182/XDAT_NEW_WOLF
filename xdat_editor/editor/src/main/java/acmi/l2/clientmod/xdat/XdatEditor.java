/*
 * Copyright (c) 2016 acmi
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package acmi.l2.clientmod.xdat;

import acmi.l2.clientmod.util.IOEntity;
import acmi.l2.clientmod.xdat.history.UndoManager;
import javafx.application.Application;
import javafx.application.Platform;
import javafx.beans.InvalidationListener;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.ReadOnlyBooleanProperty;
import javafx.beans.property.ReadOnlyBooleanWrapper;
import javafx.beans.property.SimpleObjectProperty;
import javafx.fxml.FXMLLoader;
import javafx.geometry.Rectangle2D;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.stage.Screen;
import javafx.stage.Stage;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLClassLoader;
import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.ResourceBundle;
import java.util.Set;
import java.util.concurrent.Callable;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;
import java.util.function.Consumer;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;
import java.util.jar.Manifest;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.prefs.Preferences;

public class XdatEditor extends Application {
    private static final Logger log = Logger.getLogger(XdatEditor.class.getName());

    private ResourceBundle interfaceResources = loadResourceBundle();

    private Stage stage;

    private Controller controller;

    private final ObjectProperty<Class<? extends IOEntity>> xdatClass = new SimpleObjectProperty<>();
    private final ObjectProperty<IOEntity> xdatObject = new SimpleObjectProperty<>();

    private String applicationVersion;

    private volatile ClassLoader schemaClassLoader = getClass().getClassLoader();
    private final Set<String> registeredSchemaClasses = new HashSet<>();
    private static final Pattern EXTERNAL_XDAT_CLASS =
            Pattern.compile("^((?:p\\d+)|(?:ct[^/]+)|(?:god[^/]+)|(?:etoa[^/]+))/XDAT\\.class$");

    private History history = new History();
    private UndoManager undoManager = new UndoManager();

    private final ReadOnlyBooleanWrapper working = new ReadOnlyBooleanWrapper();

    private Executor executor = Executors.newSingleThreadExecutor(r -> {
        Thread thread = new Thread(r);
        thread.setDaemon(true);
        return thread;
    });

    public Stage getStage() {
        return stage;
    }

    public Class<? extends IOEntity> getXdatClass() {
        return xdatClass.getValue();
    }

    public ObjectProperty<Class<? extends IOEntity>> xdatClassProperty() {
        return xdatClass;
    }

    public void setXdatClass(Class<? extends IOEntity> xdatClass) {
        this.xdatClass.setValue(xdatClass);
    }

    public IOEntity getXdatObject() {
        return xdatObject.get();
    }

    public ObjectProperty<IOEntity> xdatObjectProperty() {
        return xdatObject;
    }

    public void setXdatObject(IOEntity xdatObject) {
        this.xdatObject.set(xdatObject);
    }

    public History getHistory() {
        return history;
    }

    public UndoManager getUndoManager() {
        return undoManager;
    }

    public String getApplicationVersion() {
        return applicationVersion;
    }

    public ClassLoader getSchemaClassLoader() {
        return schemaClassLoader;
    }

    public ReadOnlyBooleanProperty workingProperty() {
        return working.getReadOnlyProperty();
    }

    @Override
    public void start(Stage primaryStage) throws Exception {
        this.stage = primaryStage;

        FXMLLoader loader = new FXMLLoader(getClass().getResource("main.fxml"), interfaceResources);
        loader.setClassLoader(getClass().getClassLoader());
        loader.setControllerFactory(param -> new Controller(XdatEditor.this));
        Parent root = loader.load();
        controller = loader.getController();

        primaryStage.setTitle("XDAT Editor");
        Scene scene = new Scene(root);
        applyInitialTheme(scene);
        primaryStage.setScene(scene);
        primaryStage.setWidth(Double.parseDouble(windowPrefs().get("width", String.valueOf(primaryStage.getWidth()))));
        primaryStage.setHeight(Double.parseDouble(windowPrefs().get("height", String.valueOf(primaryStage.getHeight()))));
        if (windowPrefs().getBoolean("maximized", primaryStage.isMaximized())) {
            primaryStage.setMaximized(true);
        } else {
            Rectangle2D bounds = new Rectangle2D(
                    Double.parseDouble(windowPrefs().get("x", String.valueOf(primaryStage.getX()))),
                    Double.parseDouble(windowPrefs().get("y", String.valueOf(primaryStage.getY()))),
                    primaryStage.getWidth(),
                    primaryStage.getHeight());
            if (Screen.getScreens()
                    .stream()
                    .map(Screen::getVisualBounds)
                    .anyMatch(r -> r.intersects(bounds))) {
                primaryStage.setX(bounds.getMinX());
                primaryStage.setY(bounds.getMinY());
            }
        }
        primaryStage.show();

        Platform.runLater(() -> {
            InvalidationListener listener = observable -> {
                if (primaryStage.isMaximized()) {
                    windowPrefs().putBoolean("maximized", true);
                } else {
                    windowPrefs().putBoolean("maximized", false);
                    windowPrefs().put("x", String.valueOf(Math.round(primaryStage.getX())));
                    windowPrefs().put("y", String.valueOf(Math.round(primaryStage.getY())));
                    windowPrefs().put("width", String.valueOf(Math.round(primaryStage.getWidth())));
                    windowPrefs().put("height", String.valueOf(Math.round(primaryStage.getHeight())));
                }
            };
            primaryStage.xProperty().addListener(listener);
            primaryStage.yProperty().addListener(listener);
            primaryStage.widthProperty().addListener(listener);
            primaryStage.heightProperty().addListener(listener);
        });
        Platform.runLater(this::postShow);
    }

    private void applyInitialTheme(Scene scene) {
        String theme = getPrefs().get("theme", "dark");
        String cssPath;
        if ("light".equals(theme)) {
            cssPath = getClass().getResource("light-theme.css").toExternalForm();
        } else {
            cssPath = getClass().getResource("dark-theme.css").toExternalForm();
        }
        scene.getStylesheets().add(cssPath);
    }

    private void postShow() {
        applicationVersion = "unknown";

        try {
            applicationVersion = readAppVersion();
        } catch (FileNotFoundException ignore) {
        } catch (IOException | URISyntaxException e) {
            log.log(Level.WARNING, "version info load error", e);
        }

        loadSchema();
    }

    private String readAppVersion() throws IOException, URISyntaxException {
        try (JarFile jarFile = new JarFile(Paths.get(getClass().getProtectionDomain().getCodeSource().getLocation().toURI()).toFile())) {
            Manifest manifest = jarFile.getManifest();
            return manifest.getMainAttributes().getValue("Version");
        }
    }

    private void loadSchema() {
        loadBuiltInSchema();
        loadExternalSchemas();
    }

    private void loadBuiltInSchema() {
        String versionsFilePath = "/versions.csv";
        InputStream stream = getClass().getResourceAsStream(versionsFilePath);
        if (stream == null) {
            String msg = versionsFilePath + " not found";
            log.warning(msg);
            Dialogs.showException(Alert.AlertType.WARNING, msg, msg, null);
            return;
        }

        try (InputStream input = stream) {
            registerVersions(input, false, "built-in");
        } catch (Exception e) {
            String msg = versionsFilePath + " read error";
            log.log(Level.WARNING, msg, e);
            Dialogs.showException(Alert.AlertType.WARNING, msg, e.getMessage(), e);
        }
    }

    private void loadExternalSchemas() {
        Path pluginDir = Paths.get(System.getProperty("user.dir"), "schema-plugins");

        try {
            Files.createDirectories(pluginDir);

            List<Path> jars = new ArrayList<>();
            try (java.util.stream.Stream<Path> stream = Files.list(pluginDir)) {
                stream.filter(path -> Files.isRegularFile(path))
                        .filter(path -> path.getFileName().toString().toLowerCase(Locale.ROOT).endsWith(".jar"))
                        .sorted()
                        .forEach(jars::add);
            }

            if (jars.isEmpty()) {
                log.info("No external schema plugins found in " + pluginDir.toAbsolutePath());
                return;
            }

            URL[] urls = new URL[jars.size()];
            for (int i = 0; i < jars.size(); i++) {
                urls[i] = jars.get(i).toUri().toURL();
            }

            URLClassLoader externalLoader = new URLClassLoader(urls, getClass().getClassLoader());
            schemaClassLoader = externalLoader;

            for (Path jarPath : jars) {
                loadExternalSchemaJar(jarPath);
            }
        } catch (Exception e) {
            String msg = "External schema load error";
            log.log(Level.WARNING, msg, e);
            Dialogs.showException(Alert.AlertType.WARNING, msg, e.getMessage(), e);
        }
    }

    private void loadExternalSchemaJar(Path jarPath) {
        int before = registeredSchemaClasses.size();

        try (JarFile jar = new JarFile(jarPath.toFile())) {
            JarEntry versionsEntry = jar.getJarEntry("versions.csv");
            if (versionsEntry != null) {
                try (InputStream input = jar.getInputStream(versionsEntry)) {
                    registerVersions(input, true, jarPath.getFileName().toString());
                }
            }

            java.util.Enumeration<JarEntry> entries = jar.entries();
            while (entries.hasMoreElements()) {
                JarEntry entry = entries.nextElement();
                Matcher matcher = EXTERNAL_XDAT_CLASS.matcher(entry.getName());
                if (!matcher.matches()) {
                    continue;
                }

                String protocolPackage = matcher.group(1);
                String className = protocolPackage + ".XDAT";
                if (registeredSchemaClasses.add(className)) {
                    controller.registerVersion(
                            "Protocol " + protocolPackage + " [external]",
                            className);
                }
            }

            int added = registeredSchemaClasses.size() - before;
            log.info("External schema plugin " + jarPath.getFileName() + ": " + added + " version(s) registered");
        } catch (Exception e) {
            log.log(Level.WARNING, "Couldn't load external schema plugin " + jarPath, e);
        }
    }

    private void registerVersions(InputStream input, boolean external, String source) throws IOException {
        try (CSVParser parser = new CSVParser(
                new InputStreamReader(input, java.nio.charset.StandardCharsets.UTF_8),
                CSVFormat.DEFAULT)) {
            for (CSVRecord record : parser.getRecords()) {
                if (record.size() < 2) {
                    continue;
                }

                String name = record.get(0).trim();
                String className = record.get(1).trim();

                if (!registeredSchemaClasses.add(className)) {
                    continue;
                }

                controller.registerVersion(
                        external ? name + " [external]" : name,
                        className);
                log.info("Registered XDAT schema " + className + " from " + source);
            }
        }
    }

    public void execute(Callable<Void> r, Consumer<Throwable> exceptionConsumer) {
        execute(r, exceptionConsumer, null);
    }

    public void execute(Callable<Void> r, Consumer<Throwable> exceptionConsumer, Runnable finallyCallback) {
        executor.execute(() -> {
            Platform.runLater(() -> working.set(true));
            try {
                r.call();
            } catch (Throwable e) {
                if (exceptionConsumer != null)
                    exceptionConsumer.accept(e);
            } finally {
                try {
                    if (finallyCallback != null)
                        finallyCallback.run();
                } finally {
                    Platform.runLater(() -> working.set(false));
                }
            }
        });
    }

    public static Preferences getPrefs() {
        return Preferences.userRoot().node("l2clientmod").node("xdat_editor");
    }

    private static Preferences windowPrefs() {
        return getPrefs().node("window");
    }

    private ResourceBundle loadResourceBundle() {
        String language = getPrefs().get("language", "en");
        Locale locale;

        switch (language) {
            case "pt_BR":
                locale = Locale.of("pt", "BR");
                break;
            case "es_AR":
                locale = Locale.of("es", "AR");
                break;
            case "ru":
                locale = Locale.of("ru");
                break;
            default:
                locale = Locale.ENGLISH;
        }

        return ResourceBundle.getBundle("acmi.l2.clientmod.xdat.interface", locale, getClass().getClassLoader());
    }
}
