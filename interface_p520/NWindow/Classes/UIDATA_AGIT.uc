class UIDATA_AGIT extends UIDataManager;

native static function GetAllDecoNPCInfo(out array<UIEventManager.AgitDecoNPCData> AgitDecoNPCDataList, out array<UIEventManager.AgitDecoNPCTypeList> NpcTypeList, int Grade, array<int> Domains);

native static function bool GetDecoNPCInfo(int DecoNpcId, out UIEventManager.AgitDecoNPCData DecoData);

native static function RequestOpenDecoNPC(int AgitID);

native static function RequestCheckAvailability(int AgitID, int SlotNum, int DecoNpcId);
