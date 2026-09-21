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
			if(Class'Interface.WorldSiegeRankingWnd'.static.Inst().m_hOwnerWnd.IsShowWindow())
			{
				Class'Interface.WorldSiegeRankingWnd'.static.Inst().m_hOwnerWnd.HideWindow();
			}
			else
			{
				Class'Interface.WorldSiegeRankingWnd'.static.Inst().m_hOwnerWnd.ShowWindow();
			}
			break;
		case "WorldSiegeLauncher2_btn":
			if(Class'Interface.WorldSiegeBoardWnd'.static.Inst().m_hOwnerWnd.IsShowWindow())
			{
				Class'Interface.WorldSiegeBoardWnd'.static.Inst().m_hOwnerWnd.HideWindow();
			}
			else
			{
				Class'Interface.WorldSiegeBoardWnd'.static.Inst().m_hOwnerWnd.ShowWindow();
			}
			break;
		default:
			break;
	}
	return;
}
