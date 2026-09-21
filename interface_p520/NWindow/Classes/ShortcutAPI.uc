class ShortcutAPI extends UIEventManager;

native static function bool AssignSpecialKey(UIEventManager.ShortcutCommandItem Command);

native static function bool AssignCommand(string GroupName, UIEventManager.ShortcutCommandItem Command);

native static function GetGroupCommandList(string GroupName, out array<UIEventManager.ShortcutCommandItem> Commands);

native static function GetGroupList(out array<string> groups);

native static function GetActiveGroupList(out array<string> groups);

native static function GetAssignedKeyFromCommand(string GroupName, string Command, out UIEventManager.ShortcutCommandItem commandItem);

native static function LockShortcut();

native static function UnlockShortcut();

native static function Save();

native static function RequestList();

native static function bool RequestShortcutScriptData(int Id, out UIEventManager.ShortcutScriptData Data);

native static function ActivateGroup(string GroupName);

native static function DeactivateGroup(string GroupName);

native static function DeactivateAll();

native static function RestoreDefault();

native static function Clear();

native static function ExecuteShortcutCommand(string Command);
