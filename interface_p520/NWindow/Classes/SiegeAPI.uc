class SiegeAPI extends Object;

native static function RequestCastleSiegeAttackerList(int castleID);

native static function RequestCastleSiegeDefenderList(int castleID);

native static function RequestJoinCastleSiege(int castleID, int IsAttacker, int IsRegister);

native static function RequestConfirmCastleSiegeWaitingList(int castleID, int clanID, int IsRegister);

native static function RequestSetCastleSiegeTime(int castleID, int TimeID);

native static function RequestMCWCastleInfo(int castleID);

native static function RequestMCWCastleSiegeInfo(int castleID);

native static function RequestMCWCastleSiegeAttackerList(int castleID);

native static function RequestMCWCastleSiegeDefenderList(int castleID);

native static function RequestPledgeMercenaryMemberList(int castleID, int PledgeID);

native static function RequestPledgeMercenaryRecruitInfoSet(int castleID, int Type, int IsMercenaryRecruit, INT64 MercenaryReward);

native static function RequestPledgeMercenaryMemberJoin(int castleID, int Type, int UserID, int PledgeID);
