class WorldSiegeLauncherWnd extends UICommonAPI;

static function WorldSiegeLauncherWnd Inst()
{
	return WorldSiegeLauncherWnd(GetScript("WorldSiegeLauncherWnd"));
}

event OnClickButton(string btnName)
{
	switch(btnName)
	{
		case "WorldSiegeLauncher_btn":
			if(Class'InterfaceClassic.WorldSiegeRankingWnd'.static.Inst().m_hOwnerWnd.IsShowWindow())
			{
				Class'InterfaceClassic.WorldSiegeRankingWnd'.static.Inst().m_hOwnerWnd.HideWindow();
			}
			else
			{
				Class'InterfaceClassic.WorldSiegeRankingWnd'.static.Inst().m_hOwnerWnd.ShowWindow();
			}
			break;
		case "WorldSiegeLauncher2_btn":
			if(Class'InterfaceClassic.WorldSiegeBoardWnd'.static.Inst().m_hOwnerWnd.IsShowWindow())
			{
				Class'InterfaceClassic.WorldSiegeBoardWnd'.static.Inst().m_hOwnerWnd.HideWindow();
			}
			else
			{
				Class'InterfaceClassic.WorldSiegeBoardWnd'.static.Inst().m_hOwnerWnd.ShowWindow();
			}
			break;
		default:
			break;
	}
	return;
}
