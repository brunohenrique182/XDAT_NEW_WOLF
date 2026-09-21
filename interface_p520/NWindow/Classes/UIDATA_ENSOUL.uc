class UIDATA_ENSOUL extends UIDataManager;

native static function int GetEnsoulSlotCount(UIEventManager.ItemID Id, int slotType);

native static function bool GetEnsoulOptionInfo(int OptionID, out string optionInfo);

native static function bool GetEnsoulStoneInfo(UIEventManager.ItemID Id, out string ensoulStoneInfo);

native static function bool GetEnsoulFeeInfoByItemId(int ItemID, bool bIsRefee, int SlotIndex, out string ensoulFeeInfo);

native static function bool GetEnsoulExtractionFeeInfoByItemId(int ItemID, out string ensoulFeeInfo);

native static function int GetEnsoulStoneType(int ItemID);
