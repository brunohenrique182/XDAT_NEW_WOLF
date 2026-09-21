class PartyMatchAPI extends Object;

native static function RequestOpenPartyMatch();

native static function RequestPartyRoomList(int a_Page, int a_LocationFilter, int a_LevelFilter);

native static function RequestJoinPartyRoom(int a_RoomNumber);

native static function RequestJoinPartyRoomAuto(int a_Page, int a_LocationFilter, int a_LevelFilter);

native static function RequestManagePartyRoom(int a_RoomNumber, int a_MaxPartyMemberCount, int a_MinLevel, int a_MaxLevel, string a_RoomTitle);

native static function RequestDismissPartyRoom(int a_RoomNumber);

native static function RequestWithdrawPartyRoom(int a_RoomNumber);

native static function RequestBanFromPartyRoom(int a_MemberID);

native static function RequestPartyMatchWaitList(int a_Page, int a_MinLevel, int a_MaxLevel, int ClassRole);

native static function RequestExitPartyMatchingWaitingRoom();

native static function RequestAskJoinPartyRoom(string a_name);

native static function RequestPartyMatchingHistory();

native static function RequestListMpccWaiting(int Page, int Location, int LevelFilter);

native static function RequestManageMpccRoom(int RoomNum, int MaxMemberCount, int MinLevelLimit, int MaxLevelLimit, int PartyRoutingType, string Title);

native static function RequestJoinMpccRoom(int RoomNum, int Location);

native static function RequestOustFromMpccRoom(int Id);

native static function RequestDismissMpccRoom();

native static function RequestWithdrawMpccRoom();

native static function RequestMpccPartymasterList();
