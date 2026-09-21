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
package acmi.l2.clientmod.xdat.propertyeditor;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.scene.control.CheckBox;
import org.controlsfx.control.PropertySheet;
import org.controlsfx.property.editor.AbstractPropertyEditor;

public class BooleanPropertyEditor extends AbstractPropertyEditor<Boolean, CheckBox> {
    private ObjectProperty<Boolean> value;
    private boolean updatingEditor;

    public BooleanPropertyEditor(PropertySheet.Item property) {
        super(property, createCheckBox());
    }

    private static CheckBox createCheckBox() {
        CheckBox checkBox = new CheckBox();
        checkBox.setAllowIndeterminate(true);
        return checkBox;
    }

    @Override
    protected ObservableValue<Boolean> getObservableValue() {
        if (value == null) {
            value = new SimpleObjectProperty<>();

            ChangeListener<Boolean> editorListener = (observable, oldValue, newValue) -> updateValueFromEditor();
            getEditor().indeterminateProperty().addListener(editorListener);
            getEditor().selectedProperty().addListener(editorListener);
        }

        return value;
    }

    private void updateValueFromEditor() {
        if (updatingEditor)
            return;

        value.set(getEditor().isIndeterminate() ? null : getEditor().isSelected());
    }

    @Override
    public void setValue(Boolean newValue) {
        /*
         * ControlsFX calls setValue while synchronizing the editor with the
         * PropertySheet item. Changing selected/indeterminate fires two separate
         * checkbox notifications; with a direct binding those transient states can
         * be written back into the XDAT object (for example null/-1 -> true/1).
         *
         * Suppress checkbox-to-model propagation while applying the programmatic
         * value, then publish the final tri-state value exactly once.
         */
        updatingEditor = true;
        try {
            if (newValue == null) {
                getEditor().setSelected(false);
                getEditor().setIndeterminate(true);
            } else {
                getEditor().setSelected(newValue);
                getEditor().setIndeterminate(false);
            }
        } finally {
            updatingEditor = false;
        }

        if (value == null)
            value = new SimpleObjectProperty<>();
        value.set(newValue);
    }
}
