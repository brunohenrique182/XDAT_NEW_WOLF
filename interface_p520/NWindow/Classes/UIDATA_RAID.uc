class UIDATA_RAID extends UIDataManager;

native static function bool IsValidData(int Id);

native static function int GetRaidMonsterID(int RaidID);

native static function int GetRaidMonsterLevel(int RaidID);

native static function int GetRaidMonsterZone(int RaidID);

native static function string GetRaidDescription(int RaidID);

native static function Vector GetRaidLoc(int Id);

native static function GetRaidRecommendLevel(int RaidID, out int nMinLevel, out int nMaxLevel);

native static function GetRaidDataKeyList(out array<int> arrKeyList);
