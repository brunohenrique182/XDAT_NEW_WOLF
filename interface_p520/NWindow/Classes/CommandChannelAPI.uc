class CommandChannelAPI extends Object;

native static function RequestCommandChannelInfo();

native static function RequestCommandChannelBanParty(string PartyMasterName);

native static function RequestCommandChannelWithdraw();

native static function RequestCommandChannelPartyMembersInfo(int MasterID);
