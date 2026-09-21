class GMAPI extends UIEventManager;

native static function BeginGMChangeServer(int a_ServerID, Vector a_PlayerLocation);

native static function RequestGMCommand(UIEventManager.EGMCommandType a_GMCommandType, optional string a_Param);

native static function bool GetObservingUserInfo(out UIEventManager.UserInfo a_ObservingUserInfo);

native static function RequestSnoopEnd(int a_SnoopID);
