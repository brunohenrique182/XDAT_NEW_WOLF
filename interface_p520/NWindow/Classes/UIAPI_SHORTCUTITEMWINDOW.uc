class UIAPI_SHORTCUTITEMWINDOW extends UIAPI_WINDOW;

native static function UpdateShortcut(string a_strWindowID, int a_nShortcutID);

native static function Clear(string a_strWindowID);

native static function AddShortcutItem(UIEventManager.ItemInfo a_itemInfo, int a_nShortcutID);

native static function bool GetShortcutItem(out UIEventManager.ItemInfo a_itemInfo, int a_nShortcutID);
