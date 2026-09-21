class PersonalConnectionAPI extends UIDataManager;

native static function RequestAddFriend(string Name);

native static function RequestRemoveFriend(string Name);

native static function RequestFriendInfoList();

native static function RequestFriendDetailInfo(string Name);

native static function RequestUpdateFriendMemo(string Name, string memo);

native static function RequestAddBlock(string Name);

native static function RequestRemoveBlock(string Name);

native static function RequestBlockInfoList();

native static function RequestBlockDetailInfo(string Name);

native static function RequestUpdateBlockMemo(string Name, string memo);

native static function RequestInzonePartyInfoHistory();

native static function RequestPledgeMemberList();

native static function int GetFriendServerID(string Name);

native static function RequestFriendChat(string Name);

native static function RequestMenteeAdd(string MenteeName);

native static function ConfirmMenteeAdd(string MentorName, int Ok);

native static function RequestMentorList();

native static function RequestMentorCancel(int ImMentor, string TargetName);

native static function RequestPvpbookList();

native static function RequestPvpbookKillerLocation(string KillerName);

native static function RequestPvpbookTeleportToKiller(string KillerName);

native static function GetPvpbookRequiredItem(string ActionType, int Sequence, out int ItemClassID, out INT64 ItemAmount);

native static function int GetPvpbookMaxCount(string ActionType);
