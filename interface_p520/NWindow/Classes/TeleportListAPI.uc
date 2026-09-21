class TeleportListAPI extends UIEventManager;

enum ETeleportListTagType
{
	TLTT_DEFAULT,                   // 0
	TLTT_NEW,                       // 1
	TLTT_EVENT,                     // 2
	TLTT_MAX                        // 3
};

struct TeleportListData
{
	var string Name;
	var int Id;
	var int TownID;
	var int DominionID;
	var int locX;
	var int locY;
	var int Type;
	var int Level;
	var int Priority;
	var array<UIEventManager.RequestItem> Price;
	var int UsableLevel;
	var int UsableTransferDegree;
	var int ServerRange;
	var int TagStartTime;
	var int TagEndTime;
	var ETeleportListTagType Tag;
	var int RcZoneID;
};

native static function int GetCurrentZoneKey();

native static function TeleportListData GetTeleportListaDataWithZoneKey(int nZoneKey);

native static function Vector ModifyExceptionLocation(int locX, int locY, int locZ);

native static function TeleportListData GetFirstTeleportListData();

native static function TeleportListData GetNextTeleportListData();

native static function int GetDominionList(out array<int> IDList, out array<string> NameList);

native static function RequestTeleport(int nTeleportID);

native static function RequestTeleportFavoritesList();

native static function GetTeleportListData(int a_TeleportID, out TeleportListData o_data);

native static function int GetTeleportListDataCount();

native static function TeleportListData GetTeleportListDataByIndex(int Index);
