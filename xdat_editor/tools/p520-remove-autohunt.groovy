/*
 * Wolf Waker / p520 - remove Auto Hunt / Auto Target from Interface.xdat
 *
 * Run from the XDAT Editor "Script" tab after opening the ORIGINAL Interface.xdat
 * with "Wolf Waker / p520 (experimental)" selected.
 *
 * The script mutates only the in-memory XDAT. Use File -> Save As afterwards.
 * Never overwrite the original during validation.
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

def requireTopWindow = { String name ->
    def matches = xdat.windows.findAll { it.name == name }
    if (matches.size() != 1) {
        throw new IllegalStateException(
            "Expected exactly one top-level window '${name}', found ${matches.size()}."
        )
    }
    matches[0]
}

def removeDirectChild = { parent, String childName ->
    def matches = parent.children.findAll { it.name == childName }
    if (matches.size() != 1) {
        throw new IllegalStateException(
            "Expected exactly one direct child '${parent.name}.${childName}', found ${matches.size()}."
        )
    }
    parent.children.removeAll(matches)
    report["child:${parent.name}.${childName}"] += matches.size()
}

// Resolve every required parent before mutating anything.
def automaticPlay = requireTopWindow("AutomaticPlay")
def yetiQuickSlot = requireTopWindow("YetiQuickSlotWnd")
def autoUseItem = requireTopWindow("AutoUseItemWnd")
def autoUseItemMin = requireTopWindow("AutoUseItemWndMin")

// Validate every required child before the first mutation.
[
    [yetiQuickSlot, "AutoHunt_All_Btn"],
    [yetiQuickSlot, "ToggleEffect_Anim"],
    [yetiQuickSlot, "Check_AutoTargetIcon"],
    [autoUseItem, "AutoTargetWnd"],
    [autoUseItemMin, "AutoTargetWndMin_window"]
].each { pair ->
    def parent = pair[0]
    def childName = pair[1]
    def count = parent.children.count { it.name == childName }
    if (count != 1) {
        throw new IllegalStateException(
            "Preflight failed: expected exactly one '${parent.name}.${childName}', found ${count}. " +
            "No changes were applied."
        )
    }
}

println "=== p520 Auto Hunt full-removal preflight OK ==="
println "Top-level windows before: ${xdat.windows.size()}"
println "Shortcut profiles before : ${xdat.shortcuts.size()}"
println "WndDefPos before          : ${xdat.wndDefPos.size()}"
println ""

// 1) Remove the complete AutomaticPlay window and subtree.
xdat.windows.remove(automaticPlay)
report["top:AutomaticPlay"] = 1

// 2) Remove Yeti master Auto Hunt controls.
removeDirectChild(yetiQuickSlot, "AutoHunt_All_Btn")
removeDirectChild(yetiQuickSlot, "ToggleEffect_Anim")
removeDirectChild(yetiQuickSlot, "Check_AutoTargetIcon")

// Keep these intentionally:
//   Check_AutopotionIcon
//   Check_AutoUseItemIcon
//   AutoPotionWnd
//   AutoUseItemWnd item slots

// 3) Remove the complete Live Auto Target subtree.
removeDirectChild(autoUseItem, "AutoTargetWnd")

// 4) Remove the minimized Auto Target subtree.
removeDirectChild(autoUseItemMin, "AutoTargetWndMin_window")

// 5) Remove default-position metadata for the deleted top-level window.
def wndDefBefore = xdat.wndDefPos.size()
xdat.wndDefPos.removeAll { it.wnd == "AutomaticPlay" }
report["wndDefPos:AutomaticPlay"] = wndDefBefore - xdat.wndDefPos.size()

// 6) Remove key bindings / special bindings that invoke AutoPlay.
int shortcutItemsRemoved = 0
int shortcutSpecialItemsRemoved = 0
xdat.shortcuts.each { shortcut ->
    def itemBefore = shortcut.shortcutItems.size()
    shortcut.shortcutItems.removeAll { it.command == "AutoPlay" }
    shortcutItemsRemoved += itemBefore - shortcut.shortcutItems.size()

    def specialBefore = shortcut.shortcutSpecialItems.size()
    shortcut.shortcutSpecialItems.removeAll { it.command == "AutoPlay" }
    shortcutSpecialItemsRemoved += specialBefore - shortcut.shortcutSpecialItems.size()
}
report["shortcutItem:AutoPlay"] = shortcutItemsRemoved
report["shortcutSpecialItem:AutoPlay"] = shortcutSpecialItemsRemoved

println "=== Removed ==="
report.each { key, value ->
    println String.format("%-55s %d", key, value)
}

// Post-conditions.
assert xdat.windows.count { it.name == "AutomaticPlay" } == 0
assert yetiQuickSlot.children.count { it.name == "AutoHunt_All_Btn" } == 0
assert yetiQuickSlot.children.count { it.name == "ToggleEffect_Anim" } == 0
assert yetiQuickSlot.children.count { it.name == "Check_AutoTargetIcon" } == 0
assert autoUseItem.children.count { it.name == "AutoTargetWnd" } == 0
assert autoUseItemMin.children.count { it.name == "AutoTargetWndMin_window" } == 0
assert xdat.wndDefPos.count { it.wnd == "AutomaticPlay" } == 0
assert xdat.shortcuts.sum { s -> s.shortcutItems.count { it.command == "AutoPlay" } } == 0
assert xdat.shortcuts.sum { s -> s.shortcutSpecialItems.count { it.command == "AutoPlay" } } == 0

println ""
println "=== Post-check OK ==="
println "Top-level windows after : ${xdat.windows.size()}"
println "Shortcut profiles after : ${xdat.shortcuts.size()}"
println "WndDefPos after          : ${xdat.wndDefPos.size()}"
println ""
println "Auto Hunt / Auto Target layout objects are gone."
println "Now use File -> Save As and save as Interface_NoAutoHunt_FULL.xdat."
