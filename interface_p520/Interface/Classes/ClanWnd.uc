class ClanWnd extends UICommonAPI;

const DIALOG_StartPledgeWar = 90006;
const DIALOG_AskPledgeWar = 90010;
const TIMER_ID = 20001;
const TIMER_DELAY = 200;

var WindowHandle Me;
var ClanDrawerWnd ClanDrawerWndScript;
var int m_clanID;
var string m_clanName;
var int m_clanRank;
var int m_clanLevel;
var int m_clanNameValue;
var int m_bMoreInfo;
var int m_currentShowIndex;
var int G_CurrentRecord;
var string G_CurrentSzData;
var bool G_CurrentAlias;
var int G_IamNobless;
var bool G_IamHero;
var int G_ClanMember;
var string m_Windowname;
var string m_DrawerWindowName;
var int m_myClanType;
var string m_myName;
var string m_myClanName;
var int m_indexNum;
var bool m_currentactivestatus1;
var bool m_currentactivestatus2;
var bool m_currentactivestatus3;
var bool m_currentactivestatus4;
var bool m_currentactivestatus5;
var bool m_currentactivestatus6;
var bool m_currentactivestatus7;
var bool m_currentactivestatus8;
var int m_bClanMaster;
var int m_bJoin;
var int m_bNickName;
var int m_bCrest;
var int m_bWar;
var int m_bGrade;
var int m_bManageMaster;
var int m_bOustMember;
var TextBoxHandle TxtClanWar_Title;
var ListCtrlHandle m_hClanMemberList;
var string m_CurrentclanMasterName;
var string m_CurrentclanMasterReal;
var int m_CurrentNHType;
var array<ClanInfo> m_memberList;
var string withWarPledgeNameStr;
var int pledgeDelayTimerCount;
var bool bShowOnlyOnlineUser;

function getmyClanInfo()
{
	local UserInfo UserInfo;

	if(GetPlayerInfo(UserInfo))
	{
		m_myName = UserInfo.Name;
		m_myClanType = findmyClanData(m_myName);
		G_IamNobless = UserInfo.nNobless;
		G_IamHero = UserInfo.bHero;
		G_ClanMember = UserInfo.nClanID;
	}
	return;
}

function int findmyClanData(string C_Name)
{
	local int i, j, clannum;

	i = 0;
	while((i < m_memberList.Length))
	{
		j = 0;
		while((j < m_memberList[i].m_array.Length))
		{
			if((m_memberList[i].m_array[j].sName == C_Name))
			{
				clannum = m_memberList[i].m_array[j].clanType;
			}
			++j;
		}
		++i;
	}
	return clannum;
}

function OnLoad()
{
	SetClosingOnESC();
	InitHandleCOD();
	Load();
	m_memberList.Length = 8;
	m_currentShowIndex = 0;
	m_bMoreInfo = 0;
	G_CurrentAlias = false;
	Clear();
	m_currentactivestatus1 = false;
	m_currentactivestatus2 = false;
	m_currentactivestatus3 = false;
	m_currentactivestatus4 = false;
	m_currentactivestatus5 = false;
	m_currentactivestatus6 = false;
	m_currentactivestatus7 = false;
	m_hClanMemberList = GetListCtrlHandle((m_Windowname $ ".ClanMemberList"));
	ClanDrawerWndScript = ClanDrawerWnd(GetScript("ClanDrawerWnd"));
	bShowOnlyOnlineUser = false;
	return;
}

function InitHandleCOD()
{
	Me = GetWindowHandle(m_Windowname);
	TxtClanWar_Title = GetTextBoxHandle((m_DrawerWindowName $ ".ClanWarManagementWnd.TxtClanWar_Title"));
	return;
}

function Load()
{
	pledgeDelayTimerCount = 0;
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(320);
	RegisterEvent(330);
	RegisterEvent(420);
	RegisterEvent(400);
	RegisterEvent(440);
	RegisterEvent(410);
	RegisterEvent(450);
	RegisterEvent(150);
	RegisterEvent(160);
	RegisterEvent(340);
	RegisterEvent(480);
	RegisterEvent(3580);
	RegisterEvent(5180);
	RegisterEvent(9426);
	RegisterEvent(20192);
	RegisterEvent(1710);
	RegisterEvent(1720);
	return;
}

function int GetClanTypeFromIndex(int Index)
{
	local int Type;

	if((Index == 0))
	{
		Type = 0;
	}
	if((Index == 1))
	{
		Type = 100;
	}
	if((Index == 2))
	{
		Type = 200;
	}
	if((Index == 3))
	{
		Type = 1001;
	}
	if((Index == 4))
	{
		Type = 1002;
	}
	if((Index == 5))
	{
		Type = 2001;
	}
	if((Index == 6))
	{
		Type = 2002;
	}
	if((Index == 7))
	{
		Type = -1;
	}
	return Type;
}

function string GetClanTypeNameFromIndex(int Index)
{
	local string Type;

	if((Index == 0))
	{
		Type = GetSystemString(1399);
	}
	if((Index == 100))
	{
		Type = GetSystemString(1400);
	}
	if((Index == 200))
	{
		Type = GetSystemString(1401);
	}
	if((Index == 1001))
	{
		Type = GetSystemString(1402);
	}
	if((Index == 1002))
	{
		Type = GetSystemString(1403);
	}
	if((Index == 2001))
	{
		Type = GetSystemString(1404);
	}
	if((Index == 2002))
	{
		Type = GetSystemString(1405);
	}
	if((Index == -1))
	{
		Type = GetSystemString(1452);
	}
	return Type;
}

function OnShow()
{
	local int i;
	local Rect comboboxMainClanWndRect;

	comboboxMainClanWndRect = GetComboBoxHandle("ClanWnd.ComboboxMainClanWnd").GetRect();
	if(IsUsePledgeBonus())
	{
		GetTextBoxHandle("ClanWnd.ClanCurrentNum").MoveTo((comboboxMainClanWndRect.nX + 184), (comboboxMainClanWndRect.nY + 3));
		GetTextureHandle("ClanWnd.PledgeflagIcon_Texture").ShowWindow();
		GetButtonHandle("ClanWnd.PledgeBonusWnd_Btn").ShowWindow();
		if(bShowOnlyOnlineUser)
		{
			GetButtonHandle("ClanWnd.PledgePCOnline_Btn").ShowWindow();
			GetButtonHandle("ClanWnd.PledgePCOffline_Btn").HideWindow();
		}
		else
		{
			GetButtonHandle("ClanWnd.PledgePCOnline_Btn").HideWindow();
			GetButtonHandle("ClanWnd.PledgePCOffline_Btn").ShowWindow();
		}
		m_hClanMemberList.SetColumnString(3, 5850);
		if(!ClanPledgeBonusDrawerWnd(GetScript("ClanPledgeBonusDrawerWnd")).getHasPledgeBonusList())
		{
			PledgeBonusRewardList();
		}
		PledgeBonusOpen();
	}
	else
	{
		GetTextBoxHandle("ClanWnd.ClanCurrentNum").MoveTo((comboboxMainClanWndRect.nX + 202), (comboboxMainClanWndRect.nY + 3));
		m_hClanMemberList.SetColumnString(3, 346);
		GetButtonHandle("ClanWnd.PledgePCOnline_Btn").HideWindow();
		GetButtonHandle("ClanWnd.PledgePCOffline_Btn").HideWindow();
		GetTextureHandle("ClanWnd.PledgeflagIcon_Texture").HideWindow();
		GetButtonHandle("ClanWnd.PledgeBonusWnd_Btn").HideWindow();
	}
	getmyClanInfo();
	RefreshCombobox();
	resetBtnShowHide();
	NoblessMenuValidate();
	i = 10;
	while((i >= 0))
	{
		if((Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved((m_Windowname $ ".ComboboxMainClanWnd"), i) == m_myClanType))
		{
			Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum((m_Windowname $ ".ComboboxMainClanWnd"), i);
		}
		--i;
	}
	ShowList(m_myClanType);
	Class'NWindow.UIAPI_LISTCTRL'.static.SetSelectedIndex((m_Windowname $ ".ClanMemberList"), m_indexNum, true);
	if((m_myClanType == -1))
	{
		Class'NWindow.UIAPI_LISTCTRL'.static.SetSelectedIndex((m_Windowname $ ".ClanMemberList"), (m_indexNum - 1), true);
	}
	return;
}

function NoblessMenuValidate()
{
	if((G_ClanMember == 0))
	{
		if(((G_IamHero == true) || (G_IamNobless > 0)))
		{
			Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((m_Windowname $ ".HeroBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".ClanMemInfoBtn"));
		}
		else
		{
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".HeroBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((m_Windowname $ ".ClanMemInfoBtn"));
		}
	}
	else
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".HeroBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((m_Windowname $ ".ClanMemInfoBtn"));
	}
	return;
}

function OnHide()
{
	return;
}

function OnEnterState(name a_CurrentStateName)
{
	return;
	if(getInstanceL2Util().isClanV2())
	{
		return;
	}
	getmyClanInfo();
	NoblessMenuValidate();
	Clear();
	Class'NWindow.UIDATA_CLAN'.static.RequestClanInfo();
	return;
}

function OnClickButton(string strID)
{
	local ClanDrawerWnd Script;
	local LVDataRecord Record;
	local string strParam;

	Record.LVDataList.Length = 10;
	Debug(("strID" @ strID));
	Script = ClanDrawerWnd(GetScript("ClanDrawerWnd"));
	if((strID == "ClanMemInfoBtn"))
	{
		if((m_currentactivestatus1 == false))
		{
			ResetOpeningVariables();
			m_currentactivestatus1 = true;
			if(GetSelectedListCtrlItem(Record))
			{
				RequestClanMemberInfo(int(Record.nReserved1), Record.LVDataList[0].szData);
				G_CurrentRecord = int(Record.nReserved1);
				G_CurrentSzData = Record.LVDataList[0].szData;
				if((Record.LVDataList[3].szData == "0"))
				{
					G_CurrentAlias = true;
				}
				else
				{
					G_CurrentAlias = false;
				}
				Script.SetStateAndShow("ClanMemberInfoState");
			}
		}
		else
		{
			m_currentactivestatus1 = false;
			Script.HideClanWindow();
		}
	}
	else if((strID == "ClanMemAuthBtn"))
	{
		if((m_currentactivestatus2 == false))
		{
			ResetOpeningVariables();
			m_currentactivestatus2 = true;
			if(GetSelectedListCtrlItem(Record))
			{
				RequestClanMemberAuth(int(Record.nReserved1), Record.LVDataList[0].szData);
				Script.SetStateAndShow("ClanMemberAuthState");
			}
		}
		else
		{
			m_currentactivestatus2 = false;
			Script.HideClanWindow();
		}
	}
	else if((strID == "ClanBoardBtn"))
	{
		ParamAdd(strParam, "Index", "3");
		ExecuteEvent(1190, strParam);
	}
	else if((strID == "ClanInfoBtn"))
	{
		if((m_currentactivestatus3 == false))
		{
			ResetOpeningVariables();
			m_currentactivestatus3 = true;
			Script.SetStateAndShow("ClanInfoState");
		}
		else
		{
			m_currentactivestatus3 = false;
			Script.HideClanWindow();
		}
	}
	else if((strID == "ClanPenaltyBtn"))
	{
		ExecuteCommandFromAction("pledgepenalty");
	}
	else if((strID == "ClanQuitBtn"))
	{
		RequestClanLeave(m_clanName, m_myClanType);
	}
	else if((strID == "ClanWarInfoBtn"))
	{
		if((m_currentactivestatus5 == false))
		{
			ResetOpeningVariables();
			m_currentactivestatus5 = true;
			Script.m_clanWarListPage = -1;
			RequestClanWarList(0, 0);
			Script.SetStateAndShow("ClanWarManagementWndState");
		}
		else
		{
			m_currentactivestatus5 = false;
			Script.HideClanWindow();
		}
	}
	else if((strID == "ClanWarDeclareBtn"))
	{
		RequestClanDeclareWar();
	}
	else if((strID == "ClanUnionBtn"))
	{
		if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("ClanSearch"))
		{
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ClanSearch");
		}
		else
		{
			Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("ClanSearch");
		}
	}
	else if((strID == "ClanAskJoinBtn"))
	{
		askJoin();
	}
	else if((strID == "ClanAuthEditBtn"))
	{
		if((m_currentactivestatus6 == false))
		{
			ResetOpeningVariables();
			m_currentactivestatus6 = true;
			RequestClanGradeList();
			Script.SetStateAndShow("ClanAuthManageWndState");
		}
		else
		{
			m_currentactivestatus6 = false;
			Script.HideClanWindow();
		}
	}
	else if((strID == "ClanTitleManageBtn"))
	{
		if((m_currentactivestatus7 == false))
		{
			ResetOpeningVariables();
			m_currentactivestatus7 = true;
			Script.SetStateAndShow("ClanEmblemManageWndState");
		}
		else
		{
			m_currentactivestatus7 = false;
			Script.HideClanWindow();
		}
	}
	else if((strID == "HeroBtn"))
	{
		if((m_currentactivestatus8 == false))
		{
			m_currentactivestatus8 = true;
			Script.SetStateAndShow("ClanHeroWndState");
		}
		else
		{
			m_currentactivestatus8 = false;
			Script.HideClanWindow();
		}
	}
	else if((strID == "PledgeBonusWnd_Btn"))
	{
		if(IsShowWindow("ClanPledgeBonusDrawerWnd"))
		{
			GetWindowHandle("ClanPledgeBonusDrawerWnd").HideWindow();
		}
		else
		{
			PledgeBonusOpen();
		}
	}
	else if(((strID == "PledgePCOnline_Btn") || (strID == "PledgePCOffline_Btn")))
	{
		if(IsOnlyOnline())
		{
			GetButtonHandle("ClanWnd.PledgePCOnline_Btn").HideWindow();
			GetButtonHandle("ClanWnd.PledgePCOffline_Btn").ShowWindow();
			bShowOnlyOnlineUser = false;
		}
		else
		{
			GetButtonHandle("ClanWnd.PledgePCOnline_Btn").ShowWindow();
			GetButtonHandle("ClanWnd.PledgePCOffline_Btn").HideWindow();
			bShowOnlyOnlineUser = true;
		}
		ShowList(Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved((m_Windowname $ ".ComboboxMainClanWnd"), Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum((m_Windowname $ ".ComboboxMainClanWnd"))));
	}
	return;
}

function bool IsOnlyOnline()
{
	return GetButtonHandle("ClanWnd.PledgePCOnline_Btn").IsShowWindow();
}

function IsWorldRaidServer()
{
	if((IsPlayerOnWorldRaidServer() == true))
	{
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanMemInfoBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanMemAuthBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanBoardBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanInfoBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanPenaltyBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanQuitBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanWarInfoBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanWarDeclareBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanUnionBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanAskJoinBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanAuthEditBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanTitleManageBtn"));
	}
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	return;
	if(getInstanceL2Util().isClanV2())
	{
		return;
	}
	switch(a_EventID)
	{
		case 420:
			Clear();
			break;
		case 160:
			Clear();
			break;
		case 320:
			HandleClanInfo(a_Param);
			break;
		case 410:
			HandleAddClanMemberMultiple(a_Param);
			break;
		case 440:
			HandleMemberInfoUpdate(a_Param);
			break;
		case 400:
			HandleAddClanMember(a_Param);
			break;
		case 450:
			HandleDeleteMember(a_Param);
			break;
		case 330:
			HandleClanInfoUpdate(a_Param);
			break;
		case 480:
			HandleSubClanUpdated(a_Param);
			break;
		case 340:
			HandleClanMyAuth(a_Param);
			break;
		case 5180:
			HandleEV_RequestStartPledgeWar(a_Param);
			break;
		case 20192:
			Debug("초기화 됨. EV_PledgeBonusMarkReset");  // EN: has been reset. EV_PledgeBonusMarkReset
			ClearList();
			deleteAllBActive();
			ShowList(Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved((m_Windowname $ ".ComboboxMainClanWnd"), Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum((m_Windowname $ ".ComboboxMainClanWnd"))));
			break;
		case 1710:
			HandleDialogOK();
			break;
		default:
			break;
	}
	return;
}

function deleteAllBActive()
{
	local int N, i;

	i = 0;
	while((i < m_memberList.Length))
	{
		N = 0;
		while((N < m_memberList[i].m_array.Length))
		{
			m_memberList[i].m_array[N].bActive = 0;
			N++;
		}
		i++;
	}
	return;
}

function OnComboBoxItemSelected(string sName, int Index)
{
	ClearList();
	ShowList(Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved((m_Windowname $ ".ComboboxMainClanWnd"), Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum((m_Windowname $ ".ComboboxMainClanWnd"))));
	return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
	local ClanDrawerWnd Script;
	local LVDataRecord Record;

	Record.LVDataList.Length = 10;
	Script = ClanDrawerWnd(GetScript("ClanDrawerWnd"));
	if((ListCtrlID == "ClanMemberList"))
	{
		if((m_currentactivestatus1 == true))
		{
			ResetOpeningVariables();
			m_currentactivestatus1 = true;
			if(GetSelectedListCtrlItem(Record))
			{
				RequestClanMemberInfo(int(Record.nReserved1), Record.LVDataList[0].szData);
				G_CurrentRecord = int(Record.nReserved1);
				G_CurrentSzData = Record.LVDataList[0].szData;
				if((Record.LVDataList[3].szData == "0"))
				{
					G_CurrentAlias = true;
				}
				else
				{
					G_CurrentAlias = false;
				}
				Script.SetStateAndShow("ClanMemberInfoState");
			}
		}
		if((m_currentactivestatus2 == true))
		{
			ResetOpeningVariables();
			m_currentactivestatus2 = true;
			if(GetSelectedListCtrlItem(Record))
			{
				RequestClanMemberAuth(int(Record.nReserved1), Record.LVDataList[0].szData);
				Script.SetStateAndShow("ClanMemberAuthState");
			}
		}
	}
	return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
	local ClanDrawerWnd Script;
	local LVDataRecord Record;

	Record.LVDataList.Length = 10;
	Script = ClanDrawerWnd(GetScript("ClanDrawerWnd"));
	if((ListCtrlID == "ClanMemberList"))
	{
		if((m_currentactivestatus1 == false))
		{
			ResetOpeningVariables();
			m_currentactivestatus1 = true;
			if(GetSelectedListCtrlItem(Record))
			{
				RequestClanMemberInfo(int(Record.nReserved1), Record.LVDataList[0].szData);
				G_CurrentRecord = int(Record.nReserved1);
				G_CurrentSzData = Record.LVDataList[0].szData;
				if((Record.LVDataList[3].szData == "0"))
				{
					G_CurrentAlias = true;
				}
				else
				{
					G_CurrentAlias = false;
				}
				Script.SetStateAndShow("ClanMemberInfoState");
			}
		}
		else
		{
			ResetOpeningVariables();
			m_currentactivestatus1 = true;
			if(GetSelectedListCtrlItem(Record))
			{
				RequestClanMemberInfo(int(Record.nReserved1), Record.LVDataList[0].szData);
				G_CurrentRecord = int(Record.nReserved1);
				G_CurrentSzData = Record.LVDataList[0].szData;
				Script.SetStateAndShow("ClanMemberInfoState");
			}
		}
	}
	return;
}

function resetBtnShowHide()
{
	local ClanDrawerWnd Script;

	Script = ClanDrawerWnd(GetScript("ClanDrawerWnd"));
	NoblessMenuValidate();
	IsNoblessToChangeMemberNameBtnEnabled();
	Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanUnionBtn"));
	if((m_clanID == 0))
	{
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanMemInfoBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanMemAuthBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanBoardBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanInfoBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanQuitBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanWarInfoBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanWarDeclareBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanAskJoinBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanAuthEditBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanTitleManageBtn"));
	}
	else
	{
		if((m_clanLevel > 5))
		{
			Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanMemInfoBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanMemAuthBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanBoardBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanInfoBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanPenaltyBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanQuitBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanWarInfoBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanWarDeclareBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanAskJoinBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanAuthEditBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanTitleManageBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberNameBtn");
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeBanishBtn");
			Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberGradeBtn");
			Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_AssignApprenticeBtn");
			Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_DeleteApprenticeBtn");
		}
		else
		{
			switch(m_clanLevel)
			{
				case 0:
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanMemInfoBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanMemAuthBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanBoardBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanInfoBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanPenaltyBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanQuitBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanWarInfoBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanWarDeclareBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanAskJoinBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanAuthEditBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanTitleManageBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeBanishBtn");
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeMemberGradeBtn");
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_AssignApprenticeBtn");
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_DeleteApprenticeBtn");
					break;
				case 1:
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanMemInfoBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanMemAuthBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanBoardBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanInfoBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanPenaltyBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanQuitBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanWarInfoBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanWarDeclareBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanAskJoinBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanAuthEditBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanTitleManageBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeBanishBtn");
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberGradeBtn");
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_AssignApprenticeBtn");
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_DeleteApprenticeBtn");
					break;
				case 2:
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanMemInfoBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanMemAuthBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanBoardBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanInfoBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanPenaltyBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanQuitBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanWarInfoBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanWarDeclareBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanAskJoinBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanAuthEditBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanTitleManageBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeBanishBtn");
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberGradeBtn");
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_AssignApprenticeBtn");
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_DeleteApprenticeBtn");
					break;
				case 3:
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanMemInfoBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanMemAuthBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanBoardBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanInfoBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanPenaltyBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanQuitBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanWarInfoBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanWarDeclareBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanAskJoinBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanAuthEditBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanTitleManageBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberNameBtn");
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeBanishBtn");
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberGradeBtn");
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_AssignApprenticeBtn");
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_DeleteApprenticeBtn");
					break;
				case 4:
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanMemInfoBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanMemAuthBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanBoardBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanInfoBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanPenaltyBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanQuitBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanWarInfoBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanWarDeclareBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanAskJoinBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanAuthEditBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanTitleManageBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberNameBtn");
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeBanishBtn");
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberGradeBtn");
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_AssignApprenticeBtn");
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_DeleteApprenticeBtn");
					break;
				case 5:
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanMemInfoBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanMemAuthBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanBoardBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanInfoBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanPenaltyBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanQuitBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanWarInfoBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanWarDeclareBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanAskJoinBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanAuthEditBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanTitleManageBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberNameBtn");
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeBanishBtn");
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberGradeBtn");
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_AssignApprenticeBtn");
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_DeleteApprenticeBtn");
					break;
				default:
					break;
			}
		}
		if((m_bClanMaster > 0))
		{
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanQuitBtn"));
			if((m_clanLevel > 2))
			{
				Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanTitleManageBtn"));
			}
			Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanAuthEditBtn"));
		}
		else
		{
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeMemberNameBtn");
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeBanishBtn");
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeMemberGradeBtn");
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_AssignApprenticeBtn");
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_DeleteApprenticeBtn");
			if((m_bJoin == 0))
			{
				Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanAskJoinBtn"));
			}
			if((m_bCrest == 0))
			{
				Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanTitleManageBtn"));
			}
			else if((m_clanLevel > 2))
			{
				Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanTitleManageBtn"));
			}
			if((m_bWar == 0))
			{
				Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanWarDeclareBtn"));
			}
		}
		Script.CheckandCompareMyNameandDisableThings();
	}
	IsWorldRaidServer();
	NoblessMenuValidate();
	return;
}

function IsNoblessToChangeMemberNameBtnEnabled()
{
	if(((G_IamHero == true) || (G_IamNobless > 0)))
	{
		Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_DrawerWindowName $ ".Clan1_ChangeMemberNameBtn"));
	}
	else
	{
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_DrawerWindowName $ ".Clan1_ChangeMemberNameBtn"));
	}
	return;
}

function Clear()
{
	local ClanDrawerWnd Script;
	local int i;

	ClearList();
	Script = ClanDrawerWnd(GetScript("ClanDrawerWnd"));
	Script.Clear();
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_DrawerWindowName);
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("InviteClanPopWnd");
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanNameText"), "");
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanMasterNameText"), "");
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanAgitText"), GetSystemString(27));
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanStatusText"), "");
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_Windowname $ ".ClanLevelText"), 0);
	Class'NWindow.UIAPI_COMBOBOX'.static.Clear((m_Windowname $ ".ComboboxMainClanWnd"));
	m_clanID = 0;
	m_clanName = "";
	m_clanRank = 0;
	m_clanLevel = 0;
	m_clanNameValue = 0;
	m_bMoreInfo = 0;
	m_currentShowIndex = 0;
	m_bClanMaster = 0;
	m_bJoin = 0;
	m_bNickName = 0;
	m_bCrest = 0;
	m_bWar = 0;
	m_bGrade = 0;
	m_bManageMaster = 0;
	m_bOustMember = 0;
	i = 0;
	while((i < 8))
	{
		m_memberList[i].m_array.Remove(0, m_memberList[i].m_array.Length);
		m_memberList[i].m_sName = "";
		m_memberList[i].m_sMasterName = "";
		++i;
	}
	return;
}

function HandleEV_RequestStartPledgeWar(string param)
{
	ParseString(param, "PledgeName", withWarPledgeNameStr);
	ResetOpeningVariables();
	ClanDrawerWndScript.m_clanWarListPage = -1;
	RequestClanWarList(0, 0);
	m_currentactivestatus5 = false;
	ClanDrawerWndScript.HideClanWindow();
	pledgeDelayTimerCount = 0;
	Me.KillTimer(20001);
	Me.SetTimer(20001, 200);
	return;
}

function OnTimer(int TimerID)
{
	if((pledgeDelayTimerCount > 0))
	{
		if((TimerID == 20001))
		{
			Me.KillTimer(20001);
			DialogSetID(90010);
			if(ClanDrawerWndScript.searchClanWarDeclare(withWarPledgeNameStr))
			{
				DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3524), withWarPledgeNameStr));
			}
			else
			{
				DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3306), withWarPledgeNameStr));
			}
		}
	}
	pledgeDelayTimerCount++;
	return;
}

function HandleDialogOK()
{
	local int dialogID;

	if(DialogIsMine())
	{
		dialogID = DialogGetID();
		if((dialogID == 90010))
		{
			if((withWarPledgeNameStr != ""))
			{
				RequestPledgeWar(withWarPledgeNameStr);
			}
			withWarPledgeNameStr = "";
		}
	}
	return;
}

function HandleClanInfo(string a_Param)
{
	local string clanMasterName, ClanName;
	local int crestID, SkillLevel, castleID, AgitType, AgitID, fotressID, Status, bGuilty, allianceID;
	local string allianceName;
	local int AllianceCrestID, bInWar, clanType, clanRank, clanNameValue, clanID;

	ParseInt(a_Param, "ClanID", clanID);
	ParseInt(a_Param, "ClanType", clanType);
	m_CurrentNHType = clanType;
	ParseString(a_Param, "ClanName", ClanName);
	ParseString(a_Param, "ClanMasterName", clanMasterName);
	m_CurrentclanMasterName = clanMasterName;
	if((clanType == 0))
	{
		m_CurrentclanMasterReal = clanMasterName;
	}
	ParseInt(a_Param, "CrestID", crestID);
	ParseInt(a_Param, "SkillLevel", SkillLevel);
	ParseInt(a_Param, "CastleID", castleID);
	ParseInt(a_Param, "AgitType", AgitType);
	ParseInt(a_Param, "AgitID", AgitID);
	ParseInt(a_Param, "FortressID", fotressID);
	ParseInt(a_Param, "ClanRank", clanRank);
	ParseInt(a_Param, "ClanNameValue", clanNameValue);
	ParseInt(a_Param, "Status", Status);
	ParseInt(a_Param, "Guilty", bGuilty);
	ParseInt(a_Param, "AllianceID", allianceID);
	ParseString(a_Param, "AllianceName", allianceName);
	ParseInt(a_Param, "AllianceCrestID", AllianceCrestID);
	ParseInt(a_Param, "InWar", bInWar);
	if((clanType == 0))
	{
		m_clanName = ClanName;
		m_clanRank = clanRank;
		m_clanNameValue = clanNameValue;
		m_clanLevel = SkillLevel;
		m_clanID = clanID;
	}
	m_memberList[GetIndexFromType(clanType)].m_sName = ClanName;
	m_memberList[GetIndexFromType(clanType)].m_sMasterName = clanMasterName;
	if((clanType == 0))
	{
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanNameText"), ClanName);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanMasterNameText"), m_CurrentclanMasterReal);
		if((AgitID > 0))
		{
			if((AgitType == 0))
			{
				Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanAgitText"), GetCastleName(AgitID));
			}
			else if((AgitType == 1))
			{
				Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanAgitText"), GetInZoneNameWithZoneID(AgitID));
			}
		}
		else if((castleID > 0))
		{
			Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanAgitText"), GetCastleName(castleID));
		}
		else if((fotressID > 0))
		{
			Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanAgitText"), GetCastleName(fotressID));
		}
		else
		{
			Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanAgitText"), GetSystemString(27));
		}
		if((Status == 3))
		{
			Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanStatusText"), GetSystemString(341));
		}
		else if((bInWar == 0))
		{
			Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanStatusText"), GetSystemString(894));
		}
		else
		{
			Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanStatusText"), GetSystemString(340));
		}
		Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_Windowname $ ".ClanLevelText"), SkillLevel);
	}
	RefreshCombobox();
	getmyClanInfo();
	return;
}

function HandleClanInfoUpdate(string a_Param)
{
	local int PledgeCrestID, castleID, AgitType, AgitID, fotressID, Status, bGuilty, allianceID;
	local string sAllianceName;
	local int AllianceCrestID, InWar, LargePledgeCrestID;
	local ClanDrawerWnd Script;

	ParseInt(a_Param, "ClanID", m_clanID);
	ParseInt(a_Param, "CrestID", PledgeCrestID);
	ParseInt(a_Param, "SkillLevel", m_clanLevel);
	ParseInt(a_Param, "CastleID", castleID);
	ParseInt(a_Param, "AgitType", AgitType);
	ParseInt(a_Param, "AgitID", AgitID);
	ParseInt(a_Param, "FortressID", fotressID);
	ParseInt(a_Param, "ClanRank", m_clanRank);
	ParseInt(a_Param, "ClanNameValue", m_clanNameValue);
	ParseInt(a_Param, "Status", Status);
	ParseInt(a_Param, "Guilty", bGuilty);
	ParseInt(a_Param, "AllianceID", allianceID);
	ParseString(a_Param, "AllianceName", sAllianceName);
	ParseInt(a_Param, "AllianceCrestID", AllianceCrestID);
	ParseInt(a_Param, "InWar", InWar);
	ParseInt(a_Param, "LargeCrestID", LargePledgeCrestID);
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("ClanDrawerWnd.ClanInfoWnd"))
	{
		Script = ClanDrawerWnd(GetScript("ClanDrawerWnd"));
		Script.InitializeClanInfoWnd();
	}
	if((AgitID > 0))
	{
		if((AgitType == 0))
		{
			Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanAgitText"), GetCastleName(AgitID));
		}
		else if((AgitType == 1))
		{
			Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanAgitText"), GetInZoneNameWithZoneID(AgitID));
		}
	}
	else if((castleID > 0))
	{
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanAgitText"), GetCastleName(castleID));
	}
	else if((fotressID > 0))
	{
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanAgitText"), GetCastleName(fotressID));
	}
	else
	{
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanAgitText"), GetSystemString(27));
	}
	if((Status == 3))
	{
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanStatusText"), GetSystemString(341));
	}
	else if((InWar == 0))
	{
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanStatusText"), GetSystemString(894));
	}
	else
	{
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanStatusText"), GetSystemString(340));
	}
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_Windowname $ ".ClanLevelText"), m_clanLevel);
	resetBtnShowHide();
	getmyClanInfo();
	return;
}

function HandleAddClanMemberMultiple(string a_Param)
{
	local ClanMemberInfo Info;
	local int Count, Index;

	ParseInt(a_Param, "ClanType", Info.clanType);
	Index = GetIndexFromType(Info.clanType);
	ParseString(a_Param, "Name", Info.sName);
	ParseInt(a_Param, "Level", Info.Level);
	ParseInt(a_Param, "Class", Info.ClassID);
	ParseInt(a_Param, "Gender", Info.gender);
	ParseInt(a_Param, "Race", Info.Race);
	ParseInt(a_Param, "ID", Info.Id);
	ParseInt(a_Param, "HaveMaster", Info.bHaveMaster);
	if(IsUsePledgeBonus())
	{
		ParseInt(a_Param, "MemberActive", Info.bActive);
	}
	Count = m_memberList[Index].m_array.Length;
	m_memberList[Index].m_array.Length = (Count + 1);
	m_memberList[Index].m_array[Count] = Info;
	if((Index == m_currentShowIndex))
	{
		ShowList(Info.clanType);
	}
	return;
}

function ClearList()
{
	Class'NWindow.UIAPI_LISTCTRL'.static.DeleteAllItem((m_Windowname $ ".ClanMemberList"));
	return;
}

function ShowList(int clanType)
{
	local int Index;

	Index = GetIndexFromType(clanType);
	m_currentShowIndex = Index;
	ClearList();
	AddToList(Index);
	return;
}

function int getClanKnighthoodMasterInfo(string NameVal)
{
	local int i, ReturnVal;

	i = 0;
	while((i < m_memberList[0].m_array.Length))
	{
		if((m_memberList[0].m_array[i].sName == NameVal))
		{
			ReturnVal = i;
		}
		++i;
	}
	return ReturnVal;
}

function AddToList(int idx)
{
	local Color White, Yellow, Blue, BrightWhite, Gold;
	local int i, OnLineNum;
	local LVDataRecord Record;

	BrightWhite.R = 255;
	BrightWhite.G = 255;
	BrightWhite.B = 255;
	White.R = 200;
	White.G = 200;
	White.B = 200;
	Yellow.R = 235;
	Yellow.G = 205;
	Yellow.B = 0;
	Blue.R = 102;
	Blue.G = 150;
	Blue.B = 253;
	Gold.R = 176;
	Gold.G = 153;
	Gold.B = 121;
	OnLineNum = 0;
	Record.LVDataList.Length = 4;
	if((GetClanTypeFromIndex(m_currentShowIndex) <= 0))
	{
	}
	else
	{
		if((m_memberList[m_currentShowIndex].m_sMasterName == ""))
		{
			i = getClanKnighthoodMasterInfo(m_memberList[m_currentShowIndex].m_sMasterName);
			Record.LVDataList[0].bUseTextColor = true;
			Record.LVDataList[0].szData = GetSystemString(1445);
			Record.LVDataList[0].TextColor = Gold;
			Record.LVDataList[1].szData = "";
			Record.LVDataList[2].szData = "";
			Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord((m_Windowname $ ".ClanMemberList"), Record);
		}
		else if(IsUsePledgeBonus())
		{
			i = getClanKnighthoodMasterInfo(m_memberList[m_currentShowIndex].m_sMasterName);
			if(IsOnlyOnline())
			{
				if((m_memberList[0].m_array[i].Id <= 0))
				{
					return;
				}
			}
			Record.LVDataList[0].bUseTextColor = true;
			Record.LVDataList[0].szData = m_memberList[m_currentShowIndex].m_sMasterName;
			if((m_memberList[0].m_array[i].bHaveMaster == 0))
			{
				Record.LVDataList[0].TextColor = White;
			}
			else
			{
				Record.LVDataList[0].TextColor = Yellow;
			}
			Record.LVDataList[1].bUseTextColor = true;
			if((m_memberList[0].m_array[i].sName == m_myName))
			{
				Record.LVDataList[0].TextColor = Yellow;
				Record.LVDataList[1].TextColor = Yellow;
			}
			else if((m_memberList[0].m_array[i].Id > 0))
			{
				Record.LVDataList[0].TextColor = BrightWhite;
				Record.LVDataList[1].TextColor = BrightWhite;
			}
			else
			{
				Record.LVDataList[0].TextColor = White;
				Record.LVDataList[1].TextColor = White;
			}
			Record.LVDataList[1].szData = string(m_memberList[0].m_array[i].Level);
			Record.LVDataList[2].szData = string(m_memberList[0].m_array[i].ClassID);
			Record.LVDataList[2].szTexture = GetClassRoleIconName(m_memberList[0].m_array[i].ClassID);
			Record.LVDataList[2].HiddenStringForSorting = string(GetClassRoleType(m_memberList[0].m_array[i].ClassID));
			Record.LVDataList[2].nTextureWidth = 11;
			Record.LVDataList[2].nTextureHeight = 11;
			Record.LVDataList[3].nTextureWidth = 31;
			Record.LVDataList[3].nTextureHeight = 11;
			Record.nReserved1 = INT64(0);
			if((m_memberList[0].m_array[i].Id > 0))
			{
				OnLineNum = OnLineNum++;
			}
			if((m_memberList[0].m_array[i].bActive == 1))
			{
				Record.LVDataList[3].nTextureWidth = 16;
				Record.LVDataList[3].nTextureHeight = 16;
				Record.LVDataList[3].szData = "1";
				Record.LVDataList[3].szTexture = "L2UI_CT1.PledgeBonusWnd.PledgeflagIcon";
			}
			else if((m_memberList[0].m_array[i].bActive == 2))
			{
				Record.LVDataList[3].nTextureWidth = 26;
				Record.LVDataList[3].nTextureHeight = 9;
				Record.LVDataList[3].szData = "2";
				Record.LVDataList[3].szTexture = "L2UI_CT1.pledgeBonusWnd.New";
			}
			else
			{
				Record.LVDataList[3].szData = "";
				Record.LVDataList[3].szTexture = "";
			}
			Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord((m_Windowname $ ".ClanMemberList"), Record);
		}
		else
		{
			i = getClanKnighthoodMasterInfo(m_memberList[m_currentShowIndex].m_sMasterName);
			Record.LVDataList[0].bUseTextColor = true;
			Record.LVDataList[0].szData = m_memberList[m_currentShowIndex].m_sMasterName;
			Record.LVDataList[0].TextColor = Gold;
			Record.LVDataList[1].bUseTextColor = true;
			Record.LVDataList[1].TextColor = White;
			Record.LVDataList[1].szData = string(m_memberList[0].m_array[i].Level);
			Record.LVDataList[2].szData = string(m_memberList[0].m_array[i].ClassID);
			Record.LVDataList[2].szTexture = GetClassRoleIconName(m_memberList[0].m_array[i].ClassID);
			Record.LVDataList[2].HiddenStringForSorting = string(GetClassRoleType(m_memberList[0].m_array[i].ClassID));
			Record.LVDataList[2].nTextureWidth = 11;
			Record.LVDataList[2].nTextureHeight = 11;
			Record.LVDataList[3].nTextureWidth = 31;
			Record.LVDataList[3].nTextureHeight = 11;
			Record.nReserved1 = INT64(0);
			if((m_memberList[0].m_array[i].Id > 0))
			{
				Record.LVDataList[3].szData = "0";
				Record.LVDataList[3].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logon";
				OnLineNum = OnLineNum++;
			}
			else
			{
				Record.LVDataList[3].szData = "0";
				Record.LVDataList[3].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logoff";
			}
			Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord((m_Windowname $ ".ClanMemberList"), Record);
		}
		i = 0;
	}
	i = 0;
	while((i < m_memberList[idx].m_array.Length))
	{
		if(IsUsePledgeBonus())
		{
			if(IsOnlyOnline())
			{
				if((m_memberList[idx].m_array[i].Id <= 0))
				{
					++i;
					continue;
				}
			}
		}
		Record.LVDataList[0].bUseTextColor = true;
		Record.LVDataList[0].szData = m_memberList[idx].m_array[i].sName;
		if((m_memberList[idx].m_array[i].bHaveMaster == 0))
		{
			Record.LVDataList[0].TextColor = White;
		}
		else
		{
			Record.LVDataList[0].TextColor = Yellow;
		}
		if((m_memberList[idx].m_array[i].sName == m_myName))
		{
			Record.LVDataList[0].TextColor = BrightWhite;
			Record.LVDataList[1].TextColor = BrightWhite;
			if((GetClanTypeFromIndex(m_currentShowIndex) == 0))
			{
				m_indexNum = i;
			}
			else
			{
				m_indexNum = (i + 1);
			}
		}
		Record.LVDataList[1].bUseTextColor = true;
		if(IsUsePledgeBonus())
		{
			if((m_memberList[idx].m_array[i].sName == m_myName))
			{
				Record.LVDataList[0].TextColor = Yellow;
				Record.LVDataList[1].TextColor = Yellow;
			}
			else if((m_memberList[idx].m_array[i].Id > 0))
			{
				Record.LVDataList[0].TextColor = BrightWhite;
				Record.LVDataList[1].TextColor = BrightWhite;
			}
			else
			{
				Record.LVDataList[0].TextColor = White;
				Record.LVDataList[1].TextColor = White;
			}
		}
		else if((m_memberList[idx].m_array[i].sName == m_myName))
		{
			Record.LVDataList[1].TextColor = BrightWhite;
		}
		else
		{
			Record.LVDataList[1].TextColor = White;
		}
		Record.LVDataList[1].szData = string(m_memberList[idx].m_array[i].Level);
		Record.LVDataList[2].szData = string(m_memberList[idx].m_array[i].ClassID);
		Record.LVDataList[2].szTexture = GetClassRoleIconName(m_memberList[idx].m_array[i].ClassID);
		Record.LVDataList[2].HiddenStringForSorting = string(GetClassRoleType(m_memberList[idx].m_array[i].ClassID));
		Record.LVDataList[2].nTextureWidth = 11;
		Record.LVDataList[2].nTextureHeight = 11;
		Record.LVDataList[3].nTextureWidth = 31;
		Record.LVDataList[3].nTextureHeight = 11;
		Record.nReserved1 = INT64(m_memberList[idx].m_array[i].clanType);
		if(IsUsePledgeBonus())
		{
			if((m_memberList[idx].m_array[i].Id > 0))
			{
				OnLineNum = OnLineNum++;
			}
			if((m_memberList[idx].m_array[i].bActive == 1))
			{
				Record.LVDataList[3].nTextureWidth = 16;
				Record.LVDataList[3].nTextureHeight = 16;
				Record.LVDataList[3].szData = "1";
				Record.LVDataList[3].szTexture = "L2UI_CT1.PledgeBonusWnd.PledgeflagIcon";
			}
			else if((m_memberList[idx].m_array[i].bActive == 2))
			{
				Record.LVDataList[3].nTextureWidth = 26;
				Record.LVDataList[3].nTextureHeight = 9;
				Record.LVDataList[3].szData = "2";
				Record.LVDataList[3].szTexture = "L2UI_CT1.pledgeBonusWnd.New";
			}
			else
			{
				Record.LVDataList[3].szData = "";
				Record.LVDataList[3].szTexture = "";
			}
		}
		else if((m_memberList[idx].m_array[i].Id > 0))
		{
			Record.LVDataList[3].szData = "1";
			Record.LVDataList[3].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logon";
			OnLineNum = OnLineNum++;
		}
		else
		{
			Record.LVDataList[3].szData = "2";
			Record.LVDataList[3].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logoff";
		}
		Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord((m_Windowname $ ".ClanMemberList"), Record);
		++i;
	}
	if((GetClanTypeFromIndex(m_currentShowIndex) <= 0))
	{
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanCurrentNum"), (((("(" $ string(OnLineNum)) $ "/") $ string(m_memberList[idx].m_array.Length)) $ ")"));
	}
	else
	{
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanCurrentNum"), (((("(" $ string(OnLineNum)) $ "/") $ string((m_memberList[idx].m_array.Length + 1))) $ ")"));
	}
	return;
}

function bool GetSelectedListCtrlItem(out LVDataRecord Record)
{
	local int Index;

	Index = m_hClanMemberList.GetSelectedIndex();
	if((Index >= 0))
	{
		m_hClanMemberList.GetRec(Index, Record);
		return true;
	}
	return false;
}

function HandleMemberInfoUpdate(string a_Param)
{
	local ClanMemberInfo Info;
	local int i, j, Count;
	local ClanDrawerWnd Script;
	local bool bHaveMasterChanged, bMemberChanged;
	local int process_length, process_clanindex;

	bHaveMasterChanged = false;
	bMemberChanged = false;
	ParseString(a_Param, "Name", Info.sName);
	ParseInt(a_Param, "Level", Info.Level);
	ParseInt(a_Param, "Class", Info.ClassID);
	ParseInt(a_Param, "Gender", Info.gender);
	ParseInt(a_Param, "Race", Info.Race);
	ParseInt(a_Param, "ID", Info.Id);
	ParseInt(a_Param, "ClanType", Info.clanType);
	ParseInt(a_Param, "HaveMaster", Info.bHaveMaster);
	if(IsUsePledgeBonus())
	{
		ParseInt(a_Param, "MemberActive", Info.bActive);
	}
	i = 0;
	while((i < 8))
	{
		Count = m_memberList[i].m_array.Length;
		j = 0;
		while((j < Count))
		{
			if((m_memberList[i].m_array[j].sName == Info.sName))
			{
				if((m_memberList[i].m_array[j].bHaveMaster != Info.bHaveMaster))
				{
					bHaveMasterChanged = true;
					m_memberList[i].m_array[j] = Info;
				}
				if((m_memberList[i].m_array[j].clanType != Info.clanType))
				{
					bMemberChanged = true;
					m_memberList[i].m_array.Remove(j, 1);
					process_clanindex = GetIndexFromType(Info.clanType);
					process_length = m_memberList[process_clanindex].m_array.Length;
					m_memberList[process_clanindex].m_array.Insert(process_length, 1);
					m_memberList[process_clanindex].m_array[process_length].sName = Info.sName;
					m_memberList[process_clanindex].m_array[process_length].clanType = Info.clanType;
					m_memberList[process_clanindex].m_array[process_length].Level = Info.Level;
					m_memberList[process_clanindex].m_array[process_length].ClassID = Info.ClassID;
					m_memberList[process_clanindex].m_array[process_length].gender = Info.gender;
					m_memberList[process_clanindex].m_array[process_length].Race = Info.Race;
					m_memberList[process_clanindex].m_array[process_length].Id = Info.Id;
					m_memberList[process_clanindex].m_array[process_length].bHaveMaster = Info.bHaveMaster;
					Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_DrawerWindowName $ ".Clan1_CurrentSelectedMemberGrade"), "");
					ShowList(Info.clanType);
				}
				else
				{
					m_memberList[i].m_array[j] = Info;
					ShowList(Info.clanType);
				}
				break;
			}
			++j;
		}
		if((j < Count))
		{
			break;
		}
		++i;
	}
	Script = ClanDrawerWnd(GetScript("ClanDrawerWnd"));
	if((bHaveMasterChanged && Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow((m_DrawerWindowName $ ".ClanMemberInfoWnd"))))
	{
		if((Script.m_currentName == Info.sName))
		{
			RequestClanMemberInfo(Info.clanType, Info.sName);
		}
		if((GetIndexFromType(Info.clanType) == m_currentShowIndex))
		{
			ShowList(Info.clanType);
		}
		ShowList(m_currentShowIndex);
	}
	if((bMemberChanged && Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow((m_DrawerWindowName $ ".ClanMemberInfoWnd"))))
	{
		ClearList();
		ShowList(Info.clanType);
		RefreshCombobox1(Info.clanType);
		if((Script.m_currentName == Info.sName))
		{
			RequestClanMemberInfo(Info.clanType, Info.sName);
		}
	}
	return;
}

function RefreshCombobox1(int ClanT)
{
	local int i;

	i = 0;
	while((i < 10))
	{
		if((Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved((m_Windowname $ ".ComboboxMainClanWnd"), i) == ClanT))
		{
			Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum((m_Windowname $ ".ComboboxMainClanWnd"), i);
		}
		++i;
	}
	return;
}

function HandleAddClanMember(string a_Param)
{
	local int Count;
	local ClanMemberInfo Info;

	ParseString(a_Param, "Name", Info.sName);
	ParseInt(a_Param, "Level", Info.Level);
	ParseInt(a_Param, "Class", Info.ClassID);
	ParseInt(a_Param, "Gender", Info.gender);
	ParseInt(a_Param, "Race", Info.Race);
	ParseInt(a_Param, "ID", Info.Id);
	ParseInt(a_Param, "ClanType", Info.clanType);
	if(IsUsePledgeBonus())
	{
		ParseInt(a_Param, "MemberActive", Info.bActive);
	}
	Info.bHaveMaster = 0;
	Count = m_memberList[GetIndexFromType(Info.clanType)].m_array.Length;
	m_memberList[GetIndexFromType(Info.clanType)].m_array.Length = (Count + 1);
	m_memberList[GetIndexFromType(Info.clanType)].m_array[Count] = Info;
	if((GetIndexFromType(Info.clanType) == m_currentShowIndex))
	{
		ShowList(Info.clanType);
	}
	return;
}

function int GetIndexFromType(int Type)
{
	local int i;

	i = -1;
	if((Type == 0))
	{
		i = 0;
	}
	else if((Type == 100))
	{
		i = 1;
	}
	else if((Type == 200))
	{
		i = 2;
	}
	else if((Type == 1001))
	{
		i = 3;
	}
	else if((Type == 1002))
	{
		i = 4;
	}
	else if((Type == 2001))
	{
		i = 5;
	}
	else if((Type == 2002))
	{
		i = 6;
	}
	else if((Type == -1))
	{
		i = 7;
	}
	return i;
}

function HandleDeleteMember(string a_Param)
{
	local int i, j, k, Count;
	local string sName;

	ParseString(a_Param, "Name", sName);
	i = 0;
	while((i < 8))
	{
		Count = m_memberList[i].m_array.Length;
		j = 0;
		while((j < Count))
		{
			if((m_memberList[i].m_array[j].sName == sName))
			{
				k = j;
				while((k < (Count - 1)))
				{
					m_memberList[i].m_array[k] = m_memberList[i].m_array[(k + 1)];
					++k;
				}
				m_memberList[i].m_array.Length = (Count - 1);
				break;
			}
			++j;
		}
		if((j < Count))
		{
			break;
		}
		++i;
	}
	if((i == m_currentShowIndex))
	{
		ShowList(i);
	}
	return;
}

function RefreshCombobox()
{
	local int i, Index, newIndex, addedCount;

	Index = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum((m_Windowname $ ".ComboboxMainClanWnd"));
	Class'NWindow.UIAPI_COMBOBOX'.static.Clear((m_Windowname $ ".ComboboxMainClanWnd"));
	addedCount = -1;
	i = 0;
	while((i < 8))
	{
		if((m_memberList[i].m_sName != ""))
		{
			Class'NWindow.UIAPI_COMBOBOX'.static.AddStringWithReserved((m_Windowname $ ".ComboboxMainClanWnd"), ((GetClanTypeNameFromIndex(GetClanTypeFromIndex(i)) @ "-") @ m_memberList[i].m_sName), GetClanTypeFromIndex(i));
			++addedCount;
			if((i == m_currentShowIndex))
			{
				newIndex = addedCount;
			}
		}
		++i;
	}
	i = 0;
	while((i < 10))
	{
		if((Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved((m_Windowname $ ".ComboboxMainClanWnd"), i) == m_myClanType))
		{
			Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum((m_Windowname $ ".ComboboxMainClanWnd"), i);
		}
		++i;
	}
	return;
}

function HandleSubClanUpdated(string a_Param)
{
	local int Id, Type;
	local string sName, sMasterName;
	local ClanDrawerWnd Script;

	ParseInt(a_Param, "ClanID", Id);
	ParseInt(a_Param, "ClanType", Type);
	ParseString(a_Param, "ClanName", sName);
	ParseString(a_Param, "MasterName", sMasterName);
	m_memberList[GetIndexFromType(Type)].m_sName = sName;
	m_memberList[GetIndexFromType(Type)].m_sMasterName = sMasterName;
	RefreshCombobox();
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow((m_DrawerWindowName $ ".ClanInfoWnd")))
	{
		Script = ClanDrawerWnd(GetScript("ClanDrawerWnd"));
		Script.InitializeClanInfoWnd();
	}
	return;
}

function askJoin()
{
	local UserInfo User;
	local InviteClanPopWnd InviteClanPopWndScript;

	if(GetTargetInfo(User))
	{
		if((User.nID > 0))
		{
			InviteClanPopWndScript = InviteClanPopWnd(GetScript("InviteClanPopWnd"));
			InviteClanPopWndScript.showByClanWnd();
		}
	}
	return;
}

function HandleClanMyAuth(string a_Param)
{
	ParseInt(a_Param, "ClanMaster", m_bClanMaster);
	ParseInt(a_Param, "Join", m_bJoin);
	ParseInt(a_Param, "NickName", m_bNickName);
	ParseInt(a_Param, "ClanCrest", m_bCrest);
	ParseInt(a_Param, "War", m_bWar);
	ParseInt(a_Param, "Grade", m_bGrade);
	ParseInt(a_Param, "ManageMaster", m_bManageMaster);
	ParseInt(a_Param, "OustMember", m_bOustMember);
	resetBtnShowHide();
	return;
}

function ResetOpeningVariables()
{
	m_currentactivestatus1 = false;
	m_currentactivestatus2 = false;
	m_currentactivestatus3 = false;
	m_currentactivestatus4 = false;
	m_currentactivestatus5 = false;
	m_currentactivestatus6 = false;
	m_currentactivestatus7 = false;
	m_currentactivestatus8 = false;
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="ClanWnd"
	m_DrawerWindowName="ClanDrawerWnd"
}
