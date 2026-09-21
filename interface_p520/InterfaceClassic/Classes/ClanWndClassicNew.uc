class ClanWndClassicNew extends UICommonAPI
	dependson(UIPacket);

const c_maxranklimit = 100;
const MAX_CHAR_LENGTH = 3000;
const DIALOG_ASK_JOIN = 98899;

enum CONTEXT_MENU_INDEX
{
	ClanPenaltyBtn,                 // 0
	ClanAuthEditBtn,                // 1
	ClanTitleManageBtn              // 2
};

enum TAB_TYPE
{
	SUBINFOCONTINER,                // 0
	PLEDGEBONUS,                    // 1
	BENEFIT                         // 2
};

var WindowHandle Me;
var int m_clanID;
var string m_clanName;
var int m_clanRank;
var int m_clanNameValue;
var int m_clanLevel;
var int m_bMoreInfo;
var int m_currentShowIndex;
var int G_IamNobless;
var bool G_IamHero;
var int G_ClanMember;
var string m_Windowname;
var string m_DrawerWindowName;
var string m_ClanPledgeBonusDrawerWndName;
var int m_myClanType;
var string m_myName;
var string m_myClanName;
var int m_indexNum;
var int m_bClanMaster;
var int m_bJoin;
var int m_bNickName;
var int m_bCrest;
var int m_bGrade;
var int m_bManageMaster;
var int m_bOustMember;
var TextBoxHandle TxtClanWar_Title;
var string m_CurrentclanMasterName;
var string m_CurrentclanMasterReal;
var int m_CurrentNHType;
var array<ClanInfo> m_memberList;
var int pledgeDelayTimerCount;
var PledgeLevelData pledgeLevelDataStru;
var int pledgeExp;
var WindowHandle ClanNoticeDialogBoxWnd;
var WindowHandle ClanNoiceDialogViewWnd;
var MultiEditBoxHandle dialogTextEditBox;
var CheckBoxHandle dialogTextCheck;
var ClanSubMenuManageContainer clanSubMenuManageContainerScr;
var ClanSubInfoContainer clanSubInfoContainerScr;
var ClanSubInfoContainerPledgeBonus clanSubInfoContainerPledgeBonusScr;
var ClanSubInfoContainerBenefit clanSubInfoContainerBenefitScr;

function InitHandleCOD()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	TxtClanWar_Title = GetTextBoxHandle((m_DrawerWindowName $ ".ClanWarManagementWnd.TxtClanWar_Title"));
	ClanNoticeDialogBoxWnd = GetWindowHandle((m_Windowname $ ".ClanNoiceDialogBoxWnd"));
	ClanNoiceDialogViewWnd = GetWindowHandle((m_Windowname $ ".ClanNoiceDialogViewWnd"));
	dialogTextEditBox = GetMultiEditBoxHandle((m_Windowname $ ".ClanNoiceDialogBoxWnd.Dialogtext_EditBox"));
	dialogTextCheck = GetCheckBoxHandle((m_Windowname $ ".ClanNoiceDialogBoxWnd.Dialogtext_Check100"));
	return;
}

function Load()
{
	pledgeDelayTimerCount = 0;
	return;
}

function Clear()
{
	local int i;

	Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_DrawerWindowName);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanNameText"), "");
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanMasterNameText"), "");
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanAgitText"), GetSystemString(27));
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_Windowname $ ".ClanLevelText"), 0);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanRankingInfo_Wnd.Clan3_ClanRanking"), "");
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanRankingInfo_Wnd.Clan3_ClanNum"), "0/0");
	GetHtmlHandle((m_Windowname $ ".ClanNoiceDialogViewWnd.ClanNotice_txt")).Clear();
	GetHtmlHandle((m_Windowname $ ".ClanNotice_txt")).Clear();
	m_clanID = 0;
	m_clanName = "";
	m_clanRank = 0;
	m_clanNameValue = 0;
	m_clanLevel = 0;
	m_bMoreInfo = 0;
	m_currentShowIndex = 0;
	m_bClanMaster = 0;
	m_bJoin = 0;
	m_bNickName = 0;
	m_bCrest = 0;
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

function SetmyClanInfo()
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
	RegisterEvent(9426);
	RegisterEvent(20192);
	RegisterEvent((100000 + 888));
	RegisterEvent(1710);
	RegisterEvent(40);
	RegisterEvent(9750);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	InitHandleCOD();
	Load();
	m_memberList.Length = 8;
	m_currentShowIndex = 0;
	m_bMoreInfo = 0;
	Clear();
	GetStatusBarHandle((m_Windowname $ ".ClanLevel_StatusBar")).SetDecimalPlace(4);
	InitUIControlDialogAsset();
	return;
}

event OnShow()
{
	GetWindowHandle(m_DrawerWindowName).SetFocus();
	SetmyClanInfo();
	resetBtnShowHide();
	ShowList(m_myClanType);
	clanSubInfoContainerScr.ClanMemberList_ListCtrl.SetSelectedIndex(m_indexNum, true);
	if((m_myClanType == -1))
	{
		clanSubInfoContainerScr.ClanMemberList_ListCtrl.SetSelectedIndex((m_indexNum - 1), true);
	}
	clanSubInfoContainerScr.API_C_EX_PLEDGE_CONTRIBUTION_LIST();
	switch(GetTopIndex())
	{
		case 0:
			clanSubInfoContainerScr.HandleOnShow();
			break;
		case 1:
			clanSubInfoContainerPledgeBonusScr.HandleOnShow();
			break;
		default:
			break;
	}
	API_C_EX_PLEDGE_V3_INFO();
	return;
}

event OnHide()
{
	if(DialogIsMine())
	{
		Class'InterfaceClassic.DialogBox'.static.Inst().HideDialog();
	}
	return;
}

event OnEnterState(name a_CurrentStateName)
{
	if(getInstanceL2Util().isClanV2())
	{
		return;
	}
	SetmyClanInfo();
	ClearList();
	Clear();
	ClearCurrentNum();
	Class'NWindow.UIDATA_CLAN'.static.RequestClanInfo();
	return;
}

event OnClickButton(string strID)
{
	if((strID == "ClanNotice_Button"))
	{
		ClanNoticeDialogBoxWnd.ShowWindow();
		ClanNoticeDialogBoxWnd.SetFocus();
	}
	else if((strID == "ClanNotice_Read_Button"))
	{
		ClanNoiceDialogViewWnd.ShowWindow();
		ClanNoiceDialogViewWnd.SetFocus();
	}
	else if((strID == "Dialogtext_Btn"))
	{
		API_C_EX_PLEDGE_V3_SET_ANNOUNCE();
		ClanNoticeDialogBoxWnd.HideWindow();
	}
	else if((strID == "Dialogtext_CancelBtn"))
	{
		ClanNoticeDialogBoxWnd.HideWindow();
	}
	else if((strID == "DialogtextView_Btn"))
	{
		ClanNoiceDialogViewWnd.HideWindow();
	}
	else if((strID == "ClanAskJoinBtn"))
	{
		askJoin();
	}
	else if((strID == "PledgeBonusWnd_Btn"))
	{
		if(IsShowWindow(m_ClanPledgeBonusDrawerWndName))
		{
			GetWindowHandle(m_ClanPledgeBonusDrawerWndName).HideWindow();
		}
		else
		{
			PledgeBonusOpen();
		}
	}
	else if((strID == "ClanBoardBtn"))
	{
		ShowBBS();
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
	else if((strID == "ClanMissionBtn"))
	{
		ToDoListWnd(GetScript("ToDoListWnd")).ToggleByClanMission();
	}
	else if((strID == "WindowHelp_BTN"))
	{
		Class'InterfaceClassic.HelpWnd'.static.ShowHelp(147);
	}
	else if((strID == "ClanShopBtn"))
	{
		HandleShowHideClanShopWnd();
	}
	else
	{
		HandleBtnClick(strID);
	}
	return;
}

event OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	if((a_WindowHandle == GetWindowHandle((m_Windowname $ ".ClanManagementBtn"))))
	{
		ShowContextMenu(X, Y);
	}
	return;
}

event OnEvent(int a_EventID, string a_Param)
{
	if(getInstanceL2Util().isClanV2())
	{
		return;
	}
	switch(a_EventID)
	{
		case 40:
			ClearAll();
			break;
		case 160:
			ClearList();
			Clear();
			ClearCurrentNum();
			break;
		case 320:
			HandleClanInfo(a_Param);
			break;
		case 330:
			HandleClanInfoUpdate(a_Param);
			break;
		case 480:
			HandleSubClanUpdated(a_Param);
			break;
		case 420:
			ClearList();
			Clear();
			ClearCurrentNum();
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
		case 340:
			HandleClanMyAuth(a_Param);
			break;
		case (100000 + 888):
			Handle_S_EX_PLEDGE_V3_INFO();
			break;
		case 20192:
			if(getInstanceUIData().GetIsClassicServer())
			{
				ClearList();
				deleteAllBActive();
			}
			break;
		case 1710:
			HandleDialogOK();
			break;
		case 9750:
			clanSubInfoContainerPledgeBonusScr.ShowDonaDisableWnd(true);
			clanSubInfoContainerBenefitScr.SetRecords();
			break;
		default:
			break;
	}
	return;
}

function bool API_GetPledgeLevelData(int PledgeLevel, out PledgeLevelData Data)
{
	return GetPledgeLevelData(PledgeLevel, Data);
}

function API_C_EX_PLEDGE_V3_SET_ANNOUNCE()
{
	local array<byte> stream;
	local UIPacket._C_EX_PLEDGE_V3_SET_ANNOUNCE packet;
	local string noticeStrings;

	noticeStrings = dialogTextEditBox.GetString();
	packet.sAnnounceContent = noticeStrings;
	if(dialogTextCheck.IsChecked())
	{
		packet.bShowAnnounce = 1;
	}
	else
	{
		packet.bShowAnnounce = 0;
	}
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_PLEDGE_V3_SET_ANNOUNCE(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(670, stream);
	return;
}

function API_C_EX_PLEDGE_V3_INFO()
{
	local array<byte> stream;
	local UIPacket._C_EX_PLEDGE_V3_INFO packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_PLEDGE_V3_INFO(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(665, stream);
	return;
}

function Handle_S_EX_PLEDGE_V3_INFO()
{
	local UIPacket._S_EX_PLEDGE_V3_INFO packet;
	local string announceContent;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_PLEDGE_V3_INFO(packet))
	{
		return;
	}
	m_clanRank = packet.nPledgeRank;
	pledgeExp = packet.nPledgeExp;
	SetPledgeLevelExp();
	SetClanRankStr();
	dialogTextEditBox.SetString(packet.sAnnounceContent);
	announceContent = packet.sAnnounceContent;
	announceContent = Substitute(announceContent, (((Chr(13) $ Chr(10)) $ Chr(13)) $ Chr(10)), "<Br1><Br>", false);
	announceContent = Substitute(announceContent, (Chr(13) $ Chr(10)), "<Br1>", false);
	announceContent = htmlSetHtmlStart(announceContent);
	GetHtmlHandle((m_Windowname $ ".ClanNoiceDialogViewWnd.ClanNotice_txt")).LoadHtmlFromString(announceContent);
	GetHtmlHandle((m_Windowname $ ".ClanNotice_txt")).LoadHtmlFromString(announceContent);
	clanSubMenuManageContainerScr.m_hOwnerWnd.SetFocus();
	dialogTextCheck.SetCheck(bool(packet.bShowAnnounce));
	return;
}

function GetHtmlString(string sAnnounceContent)
{
	local HtmlHandle resultText;
	local string resultString, htmlAdd;
	local Rect rectWnd;

	resultText = GetHtmlHandle((m_Windowname $ ".resultTxt_textbox"));
	resultString = GetSystemString(846);
	resultString = htmlAddText(resultString, "hs16", "DCDCDC");
	rectWnd = resultText.GetRect();
	htmlAdd = HtmlAddTableTD(resultString, "center", "center", rectWnd.nWidth, 0, "", true);
	HtmlSetTableTR(htmlAdd);
	htmlAdd = (((((("<table width=" $ string(rectWnd.nWidth)) $ " height=") $ string(rectWnd.nHeight)) $ ">") $ htmlAdd) $ "</table>");
	resultText.LoadHtmlFromString(htmlSetHtmlStart(htmlAdd));
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

function resetBtnShowHide()
{
	IsNoblessToChangeMemberNameBtnEnabled();
	Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanUnionBtn"));
	if((m_clanID == 0))
	{
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanMemAuthBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanBoardBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanAskJoinBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".ClanQuitBtn"));
	}
	else
	{
		switch(m_clanLevel)
		{
			case 0:
				Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanMemAuthBtn"));
				Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanBoardBtn"));
				Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanAskJoinBtn"));
				Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".ClanQuitBtn"));
				Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeBanishBtn"));
				Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeBtn"));
				break;
			case 1:
				Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanMemAuthBtn"));
				Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanBoardBtn"));
				Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanAskJoinBtn"));
				Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".ClanQuitBtn"));
				Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeBanishBtn"));
				Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeBtn"));
				break;
			case 2:
				Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanMemAuthBtn"));
				Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanBoardBtn"));
				Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanAskJoinBtn"));
				Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".ClanQuitBtn"));
				Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeBanishBtn"));
				Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeBtn"));
				break;
			case 3:
				Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanMemAuthBtn"));
				Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanBoardBtn"));
				Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanAskJoinBtn"));
				Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".ClanQuitBtn"));
				Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameBtn"));
				Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeBanishBtn"));
				Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeBtn"));
				break;
			case 4:
				Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanMemAuthBtn"));
				Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanBoardBtn"));
				Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanAskJoinBtn"));
				Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".ClanQuitBtn"));
				Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameBtn"));
				Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeBanishBtn"));
				Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeBtn"));
				break;
			case 5:
				Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanMemAuthBtn"));
				Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanBoardBtn"));
				Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanAskJoinBtn"));
				Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".ClanQuitBtn"));
				Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeBanishBtn"));
				Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameBtn"));
				Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeBtn"));
				break;
			default:
				if((m_clanLevel > 5))
				{
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanMemAuthBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanBoardBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanAskJoinBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".ClanQuitBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeBanishBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameBtn"));
					Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeBtn"));
				}
				break;
		}
		NoticeAuthByClanMaster((m_bClanMaster > 0));
		if((m_bClanMaster > 0))
		{
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".ClanQuitBtn"));
		}
		else
		{
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeBanishBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeBtn"));
			if((m_bJoin == 0))
			{
				Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanAskJoinBtn"));
			}
		}
		clanSubMenuManageContainerScr.CheckandCompareMyNameandDisableThings();
	}
	IsWorldRaidServer();
	return;
}

function NoticeAuthByClanMaster(bool isClanMaster)
{
	if((m_clanID <= 0))
	{
		GetButtonHandle((m_Windowname $ ".ClanNotice_Button")).HideWindow();
		GetButtonHandle((m_Windowname $ ".ClanNotice_Read_Button")).HideWindow();
	}
	else if(isClanMaster)
	{
		GetButtonHandle((m_Windowname $ ".ClanNotice_Button")).ShowWindow();
		GetButtonHandle((m_Windowname $ ".ClanNotice_Read_Button")).HideWindow();
	}
	else
	{
		GetButtonHandle((m_Windowname $ ".ClanNotice_Button")).HideWindow();
		GetButtonHandle((m_Windowname $ ".ClanNotice_Read_Button")).ShowWindow();
	}
	return;
}

function IsNoblessToChangeMemberNameBtnEnabled()
{
	if(((G_IamHero == true) || (G_IamNobless > 0)))
	{
		Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameBtn"));
	}
	else
	{
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameBtn"));
	}
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
	SetPledgeNumGeneral();
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
	SetPledgeNumGeneral();
	return;
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

function ClearList()
{
	clanSubInfoContainerScr.ClearList();
	return;
}

function ClearCurrentNum()
{
	clanSubInfoContainerScr.ClearCurrentNum();
	return;
}

function ClearAll()
{
	ClearList();
	Clear();
	ClearCurrentNum();
	clanSubInfoContainerScr.Clan8_DeclaredListCtrl.DeleteAllItem();
	clanSubInfoContainerScr.ClanSkillList_ListCtrl.DeleteAllItem();
	clanSubInfoContainerBenefitScr.ClearList();
	clanSubInfoContainerPledgeBonusScr.SetRemainCount(0);
	return;
}

function ShowList(int clanType)
{
	local int Index;

	Index = GetIndexFromType(clanType);
	m_currentShowIndex = Index;
	ClearList();
	clanSubInfoContainerScr.AddToList(Index);
	return;
}

function HandleMemberInfoUpdate(string a_Param)
{
	local ClanMemberInfo Info;
	local int i, j, Count;
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
	ParseInt(a_Param, "MemberActive", Info.bActive);
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
					Class'NWindow.UIAPI_TEXTBOX'.static.SetText((clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_CurrentSelectedMemberGrade"), "");
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
	if((bHaveMasterChanged && Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow((m_DrawerWindowName $ ".ClanMemberInfoWnd"))))
	{
		if((clanSubMenuManageContainerScr.m_currentName == Info.sName))
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
		if((clanSubMenuManageContainerScr.m_currentName == Info.sName))
		{
			RequestClanMemberInfo(Info.clanType, Info.sName);
		}
	}
	return;
}

function HandleClanInfo(string a_Param)
{
	local string clanMasterName, ClanName;
	local int crestID, SkillLevel, bGuilty, allianceID;
	local string allianceName;
	local int AllianceCrestID, clanType, clanRank, clanNameValue, clanID;

	ParseInt(a_Param, "ClanID", clanID);
	ParseInt(a_Param, "ClanType", clanType);
	m_CurrentNHType = clanType;
	ParseString(a_Param, "ClanName", ClanName);
	ParseString(a_Param, "ClanMasterName", clanMasterName);
	ParseInt(a_Param, "CrestID", crestID);
	ParseInt(a_Param, "SkillLevel", SkillLevel);
	ParseInt(a_Param, "ClanRank", clanRank);
	ParseInt(a_Param, "ClanNameValue", clanNameValue);
	ParseInt(a_Param, "Guilty", bGuilty);
	ParseInt(a_Param, "AllianceID", allianceID);
	ParseString(a_Param, "AllianceName", allianceName);
	ParseInt(a_Param, "AllianceCrestID", AllianceCrestID);
	if((clanType == 0))
	{
		m_clanName = ClanName;
		m_clanRank = clanRank;
		m_clanNameValue = clanNameValue;
		m_clanLevel = SkillLevel;
		m_clanID = clanID;
		m_CurrentclanMasterReal = clanMasterName;
		SetClanName();
		SetClanmasterName();
		SetClanLevel();
		SetClanRankStr();
		SetAgitInfo(a_Param);
		SetPledgeLevelData();
		SetPledgeNumGeneral();
		SetPledgeLevelExp();
		HandleBenefitTooltip();
	}
	m_memberList[GetIndexFromType(clanType)].m_sName = ClanName;
	m_memberList[GetIndexFromType(clanType)].m_sMasterName = clanMasterName;
	SetmyClanInfo();
	return;
}

function HandleBenefitTooltip()
{
	local CustomTooltip t;
	local PledgeLevelData Data;

	getInstanceL2Util().setCustomTooltip(t);
	getInstanceL2Util().ToopTipMinWidth(10);
	GetPledgeLevelData(m_clanLevel, Data);
	getInstanceL2Util().ToopTipInsertColorText(Data.MeritDesc, true, true, getInstanceL2Util().Yellow);
	if(GetPledgeLevelData((m_clanLevel + 1), Data))
	{
		getInstanceL2Util().TooltipInsertItemBlank(0);
		getInstanceL2Util().TooltipInsertItemLine();
		getInstanceL2Util().TooltipInsertItemBlank(5);
		getInstanceL2Util().ToopTipInsertColorText(Data.MeritDesc, true, true, getInstanceL2Util().White);
	}
	getInstanceL2Util().TooltipInsertItemBlank(0);
	getInstanceL2Util().TooltipInsertItemLine();
	getInstanceL2Util().TooltipInsertItemBlank(5);
	getInstanceL2Util().ToopTipInsertColorText(GetSystemString(13473), true, true, getInstanceL2Util().Blue);
	GetButtonHandle((m_Windowname $ ".ClanManagementBtn")).SetTooltipCustomType(getInstanceL2Util().getCustomToolTip());
	return;
}

function HandleClanInfoUpdate(string a_Param)
{
	local int PledgeCrestID, bGuilty, allianceID;
	local string sAllianceName;
	local int AllianceCrestID, LargePledgeCrestID;

	ParseInt(a_Param, "ClanID", m_clanID);
	ParseInt(a_Param, "CrestID", PledgeCrestID);
	ParseInt(a_Param, "SkillLevel", m_clanLevel);
	ParseInt(a_Param, "ClanRank", m_clanRank);
	ParseInt(a_Param, "ClanNameValue", m_clanNameValue);
	ParseInt(a_Param, "Guilty", bGuilty);
	ParseInt(a_Param, "AllianceID", allianceID);
	ParseString(a_Param, "AllianceName", sAllianceName);
	ParseInt(a_Param, "AllianceCrestID", AllianceCrestID);
	ParseInt(a_Param, "LargeCrestID", LargePledgeCrestID);
	SetClanLevel();
	SetPledgeLevelData();
	SetPledgeNumGeneral();
	SetPledgeLevelExp();
	SetClanRankStr();
	HandleBenefitTooltip();
	SetAgitInfo(a_Param);
	resetBtnShowHide();
	SetmyClanInfo();
	API_C_EX_PLEDGE_V3_INFO();
	return;
}

function HandleSubClanUpdated(string a_Param)
{
	local int Id, Type;
	local string sName, sMasterName;

	ParseInt(a_Param, "ClanID", Id);
	ParseInt(a_Param, "ClanType", Type);
	ParseString(a_Param, "ClanName", sName);
	ParseString(a_Param, "MasterName", sMasterName);
	m_memberList[GetIndexFromType(Type)].m_sName = sName;
	m_memberList[GetIndexFromType(Type)].m_sMasterName = sMasterName;
	return;
}

function AskJoinByName(string UserName)
{
	DialogSetID(98899);
	DialogBox(GetScript("DialogBox")).SetReservedString(UserName);
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(13310), UserName));
	return;
}

function askJoin()
{
	local UserInfo User;

	if(GetTargetInfo(User))
	{
		if((User.nID > 0))
		{
			AskJoinByName(User.Name);
		}
	}
	else
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(7257));
	}
	return;
}

function HandleDialogOK()
{
	local string UserName;

	if(!DialogIsMine())
	{
		return;
	}
	switch(DialogGetID())
	{
		case 98899:
			UserName = DialogBox(GetScript("DialogBox")).GetReservedString();
			RequestClanAskJoinByName(UserName, 0);
			break;
		default:
			break;
	}
	return;
}

function HandleShowHideClanShopWnd()
{
	local WindowHandle ClanShopWndClassicHandle;

	ClanShopWndClassicHandle = GetWindowHandle("ClanShopWndClassic");
	if(ClanShopWndClassicHandle.IsShowWindow())
	{
		ClanShopWndClassicHandle.HideWindow();
	}
	else
	{
		ClanShopWndClassicHandle.ShowWindow();
		ClanShopWndClassicHandle.SetFocus();
	}
	return;
}

function HandleClanMyAuth(string a_Param)
{
	ParseInt(a_Param, "ClanMaster", m_bClanMaster);
	ParseInt(a_Param, "Join", m_bJoin);
	ParseInt(a_Param, "NickName", m_bNickName);
	ParseInt(a_Param, "ClanCrest", m_bCrest);
	ParseInt(a_Param, "Grade", m_bGrade);
	ParseInt(a_Param, "ManageMaster", m_bManageMaster);
	ParseInt(a_Param, "OustMember", m_bOustMember);
	resetBtnShowHide();
	return;
}

function IsWorldRaidServer()
{
	if(((IsPlayerOnWorldRaidServer() == true) && !IsAdenServer()))
	{
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanMemAuthBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanBoardBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".ClanQuitBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanUnionBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanAskJoinBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanTitleManageBtn"));
	}
	return;
}

function bool GetSelectedListCtrlItem(out RichListCtrlRowData Record)
{
	local int Index;

	Index = clanSubInfoContainerScr.ClanMemberList_ListCtrl.GetSelectedIndex();
	if((Index >= 0))
	{
		clanSubInfoContainerScr.ClanMemberList_ListCtrl.GetRec(Index, Record);
		return true;
	}
	return false;
}

function HandleBtnClick(string btnName)
{
	local string strID;

	if(GetStringIDFromBtnName(btnName, "ClanSubInfo_Tab", strID))
	{
		switch(strID)
		{
			case "0":
				clanSubInfoContainerScr.Me.ShowWindow();
				clanSubInfoContainerPledgeBonusScr.Me.HideWindow();
				clanSubInfoContainerBenefitScr.Me.HideWindow();
				break;
			case "1":
				clanSubInfoContainerScr._Hide();
				clanSubInfoContainerPledgeBonusScr.Me.ShowWindow();
				clanSubInfoContainerBenefitScr.Me.HideWindow();
				break;
			case "2":
				clanSubInfoContainerScr._Hide();
				clanSubInfoContainerPledgeBonusScr.Me.HideWindow();
				clanSubInfoContainerBenefitScr.Me.ShowWindow();
				break;
			default:
				break;
		}
	}
	return;
}

function bool GetStringIDFromBtnName(string btnName, string someString, out string strID)
{
	if(!CheckBtnName(btnName, someString))
	{
		return false;
	}
	strID = Mid(btnName, Len(someString));
	return true;
}

function bool CheckBtnName(string btnName, string someString)
{
	return (Left(btnName, Len(someString)) == someString);
}

function ShowBBS()
{
	local string strParam;

	strParam = "";
	ParamAdd(strParam, "Index", "3");
	ExecuteEvent(1190, strParam);
	return;
}

function SetClanName()
{
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanNameText"), m_clanName);
	return;
}

function SetClanmasterName()
{
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanMasterNameText"), m_CurrentclanMasterReal);
	return;
}

function SetClanLevel()
{
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_Windowname $ ".ClanLevelText"), m_clanLevel);
	return;
}

function SetAgitInfo(string a_Param)
{
	local int AgitID, AgitType, castleID, fotressID;

	ParseInt(a_Param, "AgitID", AgitID);
	ParseInt(a_Param, "AgitType", AgitType);
	ParseInt(a_Param, "CastleID", castleID);
	ParseInt(a_Param, "FortressID", fotressID);
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
	return;
}

function SetClanRankStr()
{
	local string ClanRankStr;

	if((m_clanID > 0))
	{
		if(IsPlayerOnWorldRaidServer())
		{
			ClanRankStr = "-";
		}
		else
		{
			ClanRankStr = GetSystemString(1374);
		}
		if(((m_clanRank > 0) && (m_clanRank <= 100)))
		{
			ClanRankStr = (string(m_clanRank) @ GetSystemString(1375));
		}
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanRankingInfo_Wnd.Clan3_ClanRanking"), ClanRankStr);
	}
	else
	{
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanRankingInfo_Wnd.Clan3_ClanRanking"), "");
	}
	return;
}

function ShowContextMenu(int X, int Y)
{
	local UIControlContextMenu ContextMenu;
	local bool isClanMaster, bCanCrest;

	ContextMenu = Class'InterfaceClassic.UIControlContextMenu'.static.GetInstance();
	ContextMenu.Clear();
	ContextMenu.DelegateOnClickContextMenu = HandleOnClickContextMenu;
	ContextMenu.MenuNew(GetSystemString(1446), 0);
	ContextMenu.MenuAddIcon("L2UI_EPIC.ClanWnd.ClanWnd_Icon_penalty");
	isClanMaster = (m_bClanMaster > 0);
	bCanCrest = ((m_clanLevel > 0) && (isClanMaster || (m_bCrest != 0)));
	if((isClanMaster || bCanCrest))
	{
		ContextMenu.MenuLineAdd();
		if(isClanMaster)
		{
			ContextMenu.MenuNew(GetSystemString(668), 1);
			ContextMenu.MenuAddIcon("L2UI_EPIC.ClanWnd.ClanWnd_Icon_Authority");
		}
		if(bCanCrest)
		{
			ContextMenu.MenuNew(GetSystemString(3663), 2);
			ContextMenu.MenuAddIcon("L2UI_EPIC.ClanWnd.ClanWnd_Icon_Emblem");
		}
	}
	GetButtonHandle((m_Windowname $ ".ClanManagementBtn")).ClearTooltip();
	ContextMenu.DelegateOnHide = HandleBenefitTooltip;
	ContextMenu.Show((X - 5), (Y - 5), string(self));
	return;
}

function HandleOnClickContextMenu(int Index)
{
	switch(Index)
	{
		case 0:
			ExecuteCommandFromAction("pledgepenalty");
			break;
		case 1:
			if(clanSubMenuManageContainerScr.ToggleWindowByType(ClanAuthManageWndState))
			{
				RequestClanGradeList();
			}
			break;
		case 2:
			clanSubMenuManageContainerScr.ToggleWindowByType(ClanEmblemManageWndState);
			break;
		default:
			break;
	}
	return;
}

function SetPledgeLevelData()
{
	local PledgeLevelData tmpPledgeLvelData;

	if(!API_GetPledgeLevelData(m_clanLevel, tmpPledgeLvelData))
	{
		return;
	}
	pledgeLevelDataStru = tmpPledgeLvelData;
	clanSubInfoContainerBenefitScr.SetRecords();
	clanSubInfoContainerPledgeBonusScr.API_C_EX_PLEDGE_DONATION_INFO();
	return;
}

function SetPledgeNumGeneral()
{
	if((m_clanID > 0))
	{
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanRankingInfo_Wnd.Clan3_ClanNum"), ((string(m_memberList[0].m_array.Length) $ "/") $ string(pledgeLevelDataStru.NumGeneral)));
	}
	else
	{
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".ClanRankingInfo_Wnd.Clan3_ClanNum"), "0/0");
	}
	return;
}

function SetPledgeLevelExp()
{
	local StatusBarHandle clanLevel_StatusBar;
	local PledgeLevelData prevPledgeLevelData;
	local int NeedPledgeExp, currentPledgeExp;

	NeedPledgeExp = pledgeLevelDataStru.NeedPledgeExp;
	currentPledgeExp = pledgeExp;
	if((m_clanLevel >= 1))
	{
		if(API_GetPledgeLevelData((m_clanLevel - 1), prevPledgeLevelData))
		{
			currentPledgeExp = (pledgeExp - prevPledgeLevelData.NeedPledgeExp);
			NeedPledgeExp = (NeedPledgeExp - prevPledgeLevelData.NeedPledgeExp);
		}
	}
	clanLevel_StatusBar = GetStatusBarHandle((m_Windowname $ ".ClanLevel_StatusBar"));
	clanLevel_StatusBar.SetPointExpPercentRate((float(currentPledgeExp) / float(NeedPledgeExp)));
	clanLevel_StatusBar.SetTooltipText(((string(currentPledgeExp) $ "/") $ string(NeedPledgeExp)));
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

function int GetTopIndex()
{
	return GetTabHandle((m_Windowname $ ".ClanSubInfo_Tab")).GetTopIndex();
}

function InitUIControlDialogAsset()
{
	local WindowHandle poopExpandWnd;

	poopExpandWnd = GetWindowHandle((m_Windowname $ ".UIControlDialogAsset"));
	Class'InterfaceClassic.UIControlDialogAssets'.static.InitScript(poopExpandWnd);
	return;
}

function UIControlDialogAssets GetPopupScript()
{
	return UIControlDialogAssets(GetWindowHandle((m_Windowname $ ".UIControlDialogAsset")).GetScript());
}

event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

defaultproperties
{
	m_DrawerWindowName="ClanSubMenuManageContainer"
}
