class UIDATA_MACRO extends UIDataManager;

native static function bool GetMacroInfo(UIEventManager.ItemID cID, out UIEventManager.MacroInfo Info);

native static function int GetMacroCount();

native static function UIEventManager.ItemID GetUseSkillID(string Command);

native static function GetMacroCommandList(UIEventManager.ItemID cID, out array<string> Commands);

native static function GetMacroSkillIDList(UIEventManager.ItemID cID, out array<UIEventManager.ItemID> SkillIDs);

native static function int GetMacroPresetIDs(out array<int> IDs);

native static function bool GetMacroPresetInfo(int presetID, out UIEventManager.MacroPresetInfo Info);
