class GMClanWnd extends ClanWnd;

var bool bShow;

function OnRegisterEvent()
{
	RegisterEvent(2380);
	RegisterEvent(2390);
	RegisterEvent(2400);
	return;
}

function Load()
{
	bShow = false;
	Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanMemInfoBtn");
	Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanMemAuthBtn");
	Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanBoardBtn");
	Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanInfoBtn");
	Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanPenaltyBtn");
	Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanQuitBtn");
	Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanWarInfoBtn");
	Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanWarDeclareBtn");
	Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanWarCancleBtn");
	Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanAskJoinBtn");
	Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanAuthEditBtn");
	Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanTitleManageBtn");
	return;
}

function OnShow()
{
	return;
}

function OnHide()
{
	return;
}

function ShowClan(string a_Param)
{
	if((a_Param == ""))
	{
		return;
	}
	if(bShow)
	{
		Clear();
		m_hOwnerWnd.HideWindow();
		bShow = false;
	}
	else
	{
		HandleGMObservingClan("");
		Class'NWindow.GMAPI'.static.RequestGMCommand(GMCOMMAND_ClanInfo, a_Param);
		bShow = true;
	}
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 2380:
			HandleGMObservingClan(a_Param);
			break;
		case 2390:
			HandleGMObservingClanMemberStart();
			break;
		case 2400:
			HandleGMObservingClanMember(a_Param);
			break;
		default:
			break;
	}
	return;
}

function HandleGMObservingClan(string a_Param)
{
	m_hOwnerWnd.ShowWindow();
	m_hOwnerWnd.SetFocus();
	Clear();
	HandleClanInfo(a_Param);
	return;
}

function HandleGMObservingClanMemberStart()
{
	return;
}

function HandleGMObservingClanMember(string a_Param)
{
	HandleAddClanMember(a_Param);
	return;
}

defaultproperties
{
	m_Windowname="GMClanWnd"
}
