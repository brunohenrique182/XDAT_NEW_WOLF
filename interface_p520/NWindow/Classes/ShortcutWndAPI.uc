class ShortcutWndAPI extends UIEventManager;

native static function SetShortcutPage(int a_ShortcutPage);

native static function ExecuteShortcutBySlot(int Slot);

native static function RequestAutomaticUseItemActivateAll(bool bActivate);

native static function RequestAutomaticUseItemActivate(int Slot, bool bActivate);

native static function SetAutoUseMacro(int Slot, bool AutoUse);

native static function RequestRegisterShortcut(int a_slot, UIEventManager.ItemInfo a_itemInfo);

native static function int GetSkillListFromShortcutItems(out array<int> o_SkillList);

native static function GetSkillAndActionListFromShortcutItems(out array<int> o_SkillList, out array<int> o_ActionList);

native static function bool GetAutomaticUseActivated(int a_ClassID);
