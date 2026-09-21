class UIDATA_HUNTINGZONE extends UIDataManager;

native static function bool IsValidData(int Id);

native static function string GetHuntingZoneName(int Id);

native static function int GetHuntingZoneType(int Id);

native static function int GetMinLevel(int Id);

native static function int GetMaxLevel(int Id);

native static function Vector GetHuntingZoneLoc(int Id);

native static function int GetHuntingZone(int Id);

native static function string GetHuntingDescription(int Id);

native static function GetHuntingZoneData(int nID, out UIEventManager.HuntingZoneUIData huntingZoneData);

native static function UIEventManager.HuntingZoneUIData GetFirstHuntingZoneData();

native static function UIEventManager.HuntingZoneUIData GetNextHuntingZoneData();
