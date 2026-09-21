/*
 * Wolf Waker / p520 - remove the complete Auto Hunt / Auto Use Supplies panel.
 *
 * Run this script on BOTH ORIGINAL files:
 *   1) Interface.xdat
 *   2) InterfaceClassic.xdat
 *
 * Open each file with "Wolf Waker / p520 (experimental)", run this from the
 * Script tab, then use File -> Save As. Never overwrite the originals while
 * validating.
 *
 * This version intentionally removes the entire AutoUseItem panel because the
 * p520 layout embeds the visible "Auto-hunting" block inside AutoUseItemWnd.
 *
 * Auto Potion windows are intentionally NOT removed here.
 */

if (xdat == null) {
    throw new IllegalStateException("No XDAT is open.")
}

if (xdat.getClass().getPackage().getName() != "p520") {
    throw new IllegalStateException(
        "This script requires the p520 schema. Current package: " +
        xdat.getClass().getPackage().getName()
    )
}

def report = [:].withDefault { 0 }

// Complete top-level UI pieces that must no longer exist.
// AutoUseItemWnd is the parent that renders BOTH:
//   - Auto-use supplies
//   - Auto-hunting
def topLevelRemove = [
    "AutomaticPlay",
    "AutoUseItemWnd",
    "AutoUseItemWndMin",
    "AutoUseItemInventory"
] as Set

// Controls that can still expose/open the deleted automation UI.
def childRemove = [
    "AutoHunt_All_Btn",
    "ToggleEffect_Anim",
    "Check_AutoTargetIcon",
    "Check_AutoUseItemIcon",
    "AutoTargetWnd",
    "AutoTargetWndMin_window"
] as Set

// Metadata for deleted top-level windows.
def wndDefRemove = topLevelRemove

// Commands that can invoke the deleted automation UI.
def isAutomationCommand = { command ->
    if (command == null) {
        return false
    }
    def value = command.toString().toLowerCase()
    value.contains("autoplay") ||
        value.contains("autohunt") ||
        value.contains("autouseitem")
}

// Defensive duplicate check. A duplicate top-level window means we do not know
// which object the client considers canonical, so stop instead of guessing.
topLevelRemove.each { name ->
    def count = xdat.windows.count { it.name == name }
    if (count > 1) {
        throw new IllegalStateException(
            "Preflight failed: expected at most one top-level window '${name}', found ${count}. " +
            "No changes were applied."
        )
    }
}

println "=== p520 complete automation-panel removal ==="
println "Top-level windows before: ${xdat.windows.size()}"
println "Shortcut profiles before : ${xdat.shortcuts.size()}"
println "WndDefPos before          : ${xdat.wndDefPos.size()}"
println ""

// 1) Remove the complete top-level automation windows.
// Missing entries are allowed so the script is safe to run on a partially
// cleaned file.
topLevelRemove.each { name ->
    def before = xdat.windows.size()
    xdat.windows.removeAll { it.name == name }
    report["top:${name}"] = before - xdat.windows.size()
}

// 2) Remove launch/status controls that may live outside those windows.
// YetiQuickSlotWnd is the important surviving parent in p520.
def purgeChildren
purgeChildren = { node, String path ->
    def childProperty = node.metaClass.hasProperty(node, "children")
    if (childProperty == null || node.children == null) {
        return
    }

    def removed = node.children.findAll { childRemove.contains(it.name) }
    removed.each { child ->
        report["child:${path}.${child.name}"] += 1
    }
    node.children.removeAll(removed)

    // Recurse into the surviving tree so the script does not depend on a child
    // being direct in a particular p520 build.
    node.children.each { child ->
        purgeChildren(child, path + "." + child.name)
    }
}

xdat.windows.each { window ->
    purgeChildren(window, window.name)
}

// 3) Remove default-position metadata for deleted windows.
def wndDefBefore = xdat.wndDefPos.size()
xdat.wndDefPos.removeAll { wndDefRemove.contains(it.wnd) }
report["wndDefPos:automation"] = wndDefBefore - xdat.wndDefPos.size()

// 4) Remove shortcuts/special shortcuts that can invoke Auto Hunt / Auto Use.
int shortcutItemsRemoved = 0
int shortcutSpecialItemsRemoved = 0
xdat.shortcuts.each { shortcut ->
    def itemBefore = shortcut.shortcutItems.size()
    shortcut.shortcutItems.removeAll { isAutomationCommand(it.command) }
    shortcutItemsRemoved += itemBefore - shortcut.shortcutItems.size()

    def specialBefore = shortcut.shortcutSpecialItems.size()
    shortcut.shortcutSpecialItems.removeAll { isAutomationCommand(it.command) }
    shortcutSpecialItemsRemoved += specialBefore - shortcut.shortcutSpecialItems.size()
}
report["shortcutItem:automation"] = shortcutItemsRemoved
report["shortcutSpecialItem:automation"] = shortcutSpecialItemsRemoved

println "=== Removed ==="
report.each { key, value ->
    println String.format("%-60s %d", key, value)
}

// 5) Post-check the complete surviving tree.
def forbiddenNames = (topLevelRemove + childRemove) as Set
def leftovers = []

def scanTree
scanTree = { node, String path ->
    if (forbiddenNames.contains(node.name)) {
        leftovers << path
    }

    def childProperty = node.metaClass.hasProperty(node, "children")
    if (childProperty != null && node.children != null) {
        node.children.each { child ->
            scanTree(child, path + "." + child.name)
        }
    }
}

xdat.windows.each { window ->
    scanTree(window, window.name)
}

if (!leftovers.isEmpty()) {
    throw new IllegalStateException(
        "Post-check failed. Automation layout objects still exist:\n  " +
        leftovers.join("\n  ")
    )
}

def wndDefLeftovers = xdat.wndDefPos.findAll { wndDefRemove.contains(it.wnd) }
if (!wndDefLeftovers.isEmpty()) {
    throw new IllegalStateException(
        "Post-check failed: deleted automation windows still have WndDefPos metadata."
    )
}

int shortcutLeftovers = 0
xdat.shortcuts.each { shortcut ->
    shortcutLeftovers += shortcut.shortcutItems.count { isAutomationCommand(it.command) }
    shortcutLeftovers += shortcut.shortcutSpecialItems.count { isAutomationCommand(it.command) }
}
if (shortcutLeftovers != 0) {
    throw new IllegalStateException(
        "Post-check failed: ${shortcutLeftovers} automation shortcut binding(s) remain."
    )
}

println ""
println "=== Post-check OK ==="
println "Top-level windows after : ${xdat.windows.size()}"
println "Shortcut profiles after : ${xdat.shortcuts.size()}"
println "WndDefPos after          : ${xdat.wndDefPos.size()}"
println ""
println "Removed completely:"
println "  AutomaticPlay"
println "  AutoUseItemWnd          (Auto-use supplies + embedded Auto-hunting)"
println "  AutoUseItemWndMin"
println "  AutoUseItemInventory"
println "  Yeti Auto Hunt / Auto Use launch controls"
println ""
println "Preserved intentionally:"
println "  AutoPotionWnd and AutoPotion* windows"
println "  AutoShotItemWnd and unrelated automatic item systems"
println ""
println "Use File -> Save As."
println "Suggested names:"
println "  Interface.xdat        -> Interface_NoAutomation_FULL.xdat"
println "  InterfaceClassic.xdat -> InterfaceClassic_NoAutomation_FULL.xdat"
println ""
println "IMPORTANT: run this version on BOTH ORIGINAL XDATs before installing."
