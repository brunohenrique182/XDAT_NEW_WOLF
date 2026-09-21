class EventMatchAPI extends UIEventManager;

native static function bool GetEventMatchData(out UIEventManager.EventMatchData a_EventMatchData);

native static function int GetScore(int a_TeamID);

native static function string GetTeamName(int a_TeamID);

native static function int GetPartyMemberCount(int a_TeamID);

native static function bool GetUserData(int a_TeamID, int a_UserID, out UIEventManager.EventMatchUserData a_UserData);

native static function SetSelectedUser(int a_TeamID, int a_UserID);

native static function RequestEventMatchObserverEnd(int MatchID);
