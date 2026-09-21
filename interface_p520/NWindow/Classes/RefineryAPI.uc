class RefineryAPI extends UIEventManager;

native static function ConfirmTargetItem(UIEventManager.ItemID sID);

native static function ConfirmRefinerItem(UIEventManager.ItemID a_TargetItemID, UIEventManager.ItemID a_RefinerItemID);

native static function ConfirmGemStone(UIEventManager.ItemID a_TargetItemID, UIEventManager.ItemID a_RefinerItemID, UIEventManager.ItemID a_GemStoneID, INT64 a_GemStoneCount);

native static function ConfirmCancelItem(UIEventManager.ItemID a_CancelItemID);

native static function RequestRefineCancel(UIEventManager.ItemID a_CancelItemID);

native static function int GetItemListFromInven(int TargetItemClassID, out array<UIEventManager.ItemInfo> Items);

native static function int GetTargetItemListFromInven(out array<UIEventManager.ItemInfo> Items);

native static function bool GetRefineryFee(int TargetItemClassID, int RefinerClassID, int FeeItemPercent, int FeeAdenaPercent, out int FeeItemID, out int FeeItemCount, out INT64 FeeAdena, out int CancelFee);

native static function bool GetOptionDesc(int TargetItemClassID, int RefinerClassID, out string OptionDesc1, out string OptionDesc2, out string OptionDesc3);

native static function bool GetOptionDescByOptionID(int OptionID, out string OptionDesc1, out string OptionDesc2, out string OptionDesc3);

native static function byte GetThemeColorLevel(byte optionQuality1, byte optionQuality2, byte optionQuality3);

native static function byte GetEffectLevel(byte optionQuality1, byte optionQuality2, byte optionQuality3);
