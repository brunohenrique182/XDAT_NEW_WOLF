class ClanDrawerWnd extends UICommonAPI;

const DIALOG_AskLossClanWar = 90009;
const DIALOG_AskClanWarCancel = 487;
const c_maxranklimit = 100;
const changelineval1 = 23;
const DISABLE_ALPHA = 100;
const ACADEMY_INDEX = 7;

var string m_state;
var int m_clanType;
var int m_clanWarListPage;
var int m_currentEditGradeID;
var string m_currentName;
var string m_myName;
var int m_currentMaster;
var string currentMasterName;
var string currentLossWarClanName;
var string m_Windowname;
var string m_ClanPledgeBonusDrawerWndName;
var ListCtrlHandle m_hClanDrawerWndClan1_AssignApprenticeList;
var ListCtrlHandle m_hClanDrawerWndClan8_DeclaredListCtrl;
var ListCtrlHandle m_hClanDrawerWndClan8_GotDeclaredListCtrl;
var ListCtrlHandle m_hClanDrawerWndClan5_AuthListCtrl;
var ListCtrlHandle m_hClanDrawerWndClan5_AuthListCtrl2;
var int ClanClickedID;
var WindowHandle Clan3_OrgIcon[8];
var TextureHandle Clan3_OrgHighLight[8];
var FileRegisterWnd fileRegisterWndHandle;

function OnRegisterEvent()
{
	RegisterEvent(350);
	RegisterEvent(360);
	RegisterEvent(370);
	RegisterEvent(380);
	RegisterEvent(430);
	RegisterEvent(460);
	RegisterEvent(490);
	RegisterEvent(500);
	RegisterEvent(160);
	RegisterEvent(470);
	RegisterEvent(1710);
	RegisterEvent(1720);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	InitHandle();
	InitializeGradeComboBox();
	HideAll();
	m_clanWarListPage = -1;
	ClanClickedID = -1;
	m_hClanDrawerWndClan1_AssignApprenticeList = GetListCtrlHandle((m_Windowname $ ".Clan1_AssignApprenticeList"));
	m_hClanDrawerWndClan8_DeclaredListCtrl = GetListCtrlHandle((m_Windowname $ ".Clan8_DeclaredListCtrl"));
	m_hClanDrawerWndClan8_GotDeclaredListCtrl = GetListCtrlHandle((m_Windowname $ ".Clan8_DeclaredListCtrl"));
	m_hClanDrawerWndClan5_AuthListCtrl = GetListCtrlHandle((m_Windowname $ ".Clan5_AuthListCtrl"));
	m_hClanDrawerWndClan5_AuthListCtrl2 = GetListCtrlHandle((m_Windowname $ ".Clan5_AuthListCtrl2"));
	fileRegisterWndHandle = FileRegisterWnd(GetScript("FileRegisterWnd"));
	return;
}

function InitHandle()
{
	local int i;

	i = 0;
	while((i < 8))
	{
		Clan3_OrgIcon[i] = GetWindowHandle(((m_Windowname $ ".Clan3_OrgIcon") $ string((i + 1))));
		Clan3_OrgHighLight[i] = GetTextureHandle((((m_Windowname $ ".Clan3_OrgIconWnd") $ string((i + 1))) $ ".texIconHighlight"));
		if((i == 7))
		{
			Clan3_OrgIcon[i].DisableWindow();
			Clan3_OrgIcon[i].SetAlpha(100);
		}
		Clan3_OrgHighLight[i].HideWindow();
		++i;
	}
	return;
}

function OnShow()
{
	local ClanWnd Script;

	Script = ClanWnd(GetScript("ClanWnd"));
	if(GetWindowHandle(m_ClanPledgeBonusDrawerWndName).IsShowWindow())
	{
		GetWindowHandle(m_ClanPledgeBonusDrawerWndName).HideWindow();
	}
	Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".Clan1_ChangeMemberNameBtn"));
	Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".Clan1_ChangeMemberGradeBtn"));
	Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".Clan1_AssignApprenticeBtn"));
	Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".Clan1_DeleteApprenticeBtn"));
	Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_ChangeBanishBtn"));
	if((Script.m_bClanMaster == 0))
	{
		if((Script.m_bNickName == 0))
		{
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_ChangeMemberNameBtn"));
		}
		if((Script.m_bGrade == 0))
		{
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_ChangeMemberGradeBtn"));
		}
		if((Script.m_bManageMaster == 0))
		{
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_AssignApprenticeBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_DeleteApprenticeBtn"));
		}
		if((Script.m_bOustMember == 0))
		{
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_ChangeBanishBtn"));
		}
	}
	switchingWarCancelButton();
	return;
}

function Clear()
{
	m_state = "";
	m_clanType = -1;
	m_clanWarListPage = -1;
	m_currentEditGradeID = -1;
	m_currentName = "";
	return;
}

function SetStateAndShow(string State)
{
	local int i;
	local string string1, string2, string3, string4;

	m_state = State;
	Debug(("SetStateAndShow" @ string(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("ClanDrawerWnd"))));
	if(!Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("ClanDrawerWnd"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("ClanDrawerWnd");
	}
	HideAll();
	if((m_state == "ClanMemberInfoState"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((m_Windowname $ ".ClanMemberInfoWnd"));
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".Clan1_ChangeMemberNameWnd"));
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".Clan1_ChangeMemberGradeNameWnd"));
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".Clan1_AssignApprenticeWnd"));
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".Clan1_ChangeMemberKnightHoodWnd"));
	}
	else if((m_state == "ClanMemberAuthState"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((m_Windowname $ ".ClanMemberAuthWnd"));
		i = 0;
		while((i <= 10))
		{
			if((i < 10))
			{
				Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(((m_Windowname $ ".Clan2_Check10") $ string(i)), true);
				++i;
				continue;
			}
			Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(((m_Windowname $ ".Clan2_Check1") $ string(i)), true);
			++i;
		}
		i = 0;
		while((i <= 5))
		{
			Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(((m_Windowname $ ".Clan2_Check20") $ string(i)), true);
			++i;
		}
		i = 0;
		while((i <= 8))
		{
			Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(((m_Windowname $ ".Clan2_Check30") $ string(i)), true);
			++i;
		}
	}
	else if((m_state == "ClanInfoState"))
	{
		InitializeClanInfoWnd();
		Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear((m_Windowname $ ".ClanSkillWnd"));
		Class'NWindow.UIDATA_CLAN'.static.RequestClanSkillList();
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((m_Windowname $ ".ClanInfoWnd"));
	}
	else if((m_state == "ClanAuthManageWndState"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((m_Windowname $ ".ClanAuthManageWnd"));
	}
	else if((m_state == "ClanEmblemManageWndState"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((m_Windowname $ ".ClanEmblemManageWnd"));
		string1 = Left(GetSystemMessage(211), 23);
		string2 = Right(GetSystemMessage(211), (Len(GetSystemMessage(211)) - 23));
		string3 = Left(GetSystemMessage(1478), 23);
		string4 = Right(GetSystemMessage(1478), (Len(GetSystemMessage(1478)) - 23));
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".Clan7_ManageEmb1Text1"), string1);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".Clan7_ManageEmb1Text2"), string2);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".Clan7_ManageEmb2Text1"), string3);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".Clan7_ManageEmb2Text2"), string4);
	}
	else if((m_state == "ClanWarManagementWndState"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((m_Windowname $ ".ClanWarManagementWnd"));
	}
	else if((m_state == "ClanAuthEditWndState"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((m_Windowname $ ".ClanAuthEditWnd"));
	}
	else if((m_state == "ClanHeroWndState"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((m_Windowname $ ".ClanHeroWnd"));
	}
	return;
}

function HideAll()
{
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".ClanMemberInfoWnd"));
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".ClanMemberAuthWnd"));
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".ClanInfoWnd"));
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".ClanPenaltyWnd"));
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".ClanWarManagementWnd"));
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".ClanAuthManageWnd"));
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".ClanAuthEditWnd"));
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".ClanEmblemManageWnd"));
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".ClanHeroWnd"));
	return;
}

function OnClickButton(string strID)
{
	local LVDataRecord Record;
	local int temp1, nClanIdx, i;
	local ClanWnd Script;
	local array<string> fileextarr;

	Script = ClanWnd(GetScript("ClanWnd"));
	if((strID == "Clan1_AskJoinPartyBtn"))
	{
		RequestInviteParty(Class'NWindow.UIAPI_TEXTBOX'.static.GetText((m_Windowname $ ".Clan1_CurrentSelectedMemberName")));
	}
	else if((strID == "Clan1_ChangeMemberNameBtn"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((m_Windowname $ ".Clan1_ChangeMemberNameWnd"));
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".Clan1_ChangeMemberGradeNameWnd"));
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".Clan1_AssignApprenticeWnd"));
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".Clan1_ChangeMemberKnightHoodWnd"));
		Class'NWindow.UIAPI_EDITBOX'.static.SetString((m_Windowname $ ".Clan1_ChangeNameTextEditbox"), "");
	}
	else if((strID == "Clan1_ChangeMemberGradeBtn"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((m_Windowname $ ".Clan1_ChangeMemberGradeNameWnd"));
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".Clan1_ChangeMemberNameWnd"));
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".Clan1_ChangeMemberKnightHoodWnd"));
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".Clan1_AssignApprenticeWnd"));
	}
	else if((strID == "Clan1_ChangeBanishBtn"))
	{
		HideClanWindow();
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".Clan1_ChangeMemberNameWnd"));
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".Clan1_ChangeMemberGradeNameWnd"));
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".Clan1_AssignApprenticeWnd"));
		RequestClanExpelMember(m_clanType, Class'NWindow.UIAPI_TEXTBOX'.static.GetText((m_Windowname $ ".Clan1_CurrentSelectedMemberName")));
	}
	else if((strID == "Clan1_AssignApprenticeBtn"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((m_Windowname $ ".Clan1_AssignApprenticeWnd"));
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".Clan1_ChangeMemberNameWnd"));
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".Clan1_ChangeMemberKnightHoodWnd"));
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".Clan1_ChangeMemberGradeNameWnd"));
		InitializeAcademyList();
	}
	else if((strID == "Clan1_ChangeMemberKHOpen"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((m_Windowname $ ".Clan1_ChangeMemberKnightHoodWnd"));
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".Clan1_AssignApprenticeWnd"));
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".Clan1_ChangeMemberNameWnd"));
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".Clan1_ChangeMemberGradeNameWnd"));
		KnighthoodCombobox();
	}
	else if((strID == "Clan1_DeleteApprenticeBtn"))
	{
		RequestClanDeletePupil(Class'NWindow.UIAPI_TEXTBOX'.static.GetText((m_Windowname $ ".Clan1_CurrentSelectedMemberName")), Class'NWindow.UIAPI_TEXTBOX'.static.GetText((m_Windowname $ ".Clan1_CurrentSelectedApprentice")));
		RecallCurrentMemberInfo();
	}
	else if((strID == "Clan1_OKBtn"))
	{
		HideClanWindow();
	}
	else if((strID == "Clan1_ChangeNameAssignBtn"))
	{
		RequestClanChangeNickName(Class'NWindow.UIAPI_TEXTBOX'.static.GetText((m_Windowname $ ".Clan1_CurrentSelectedMemberName")), Class'NWindow.UIAPI_EDITBOX'.static.GetString((m_Windowname $ ".Clan1_ChangeNameTextEditbox")));
		Class'NWindow.UIAPI_EDITBOX'.static.SetString((m_Windowname $ ".Clan1_ChangeNameTextEditbox"), "");
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".Clan1_ChangeMemberNameWnd"));
		RecallCurrentMemberInfo();
	}
	else if((strID == "Clan1_ChangeNameDeleteBtn"))
	{
		RequestClanChangeNickName(Class'NWindow.UIAPI_TEXTBOX'.static.GetText((m_Windowname $ ".Clan1_CurrentSelectedMemberName")), "");
		Class'NWindow.UIAPI_EDITBOX'.static.SetString((m_Windowname $ ".Clan1_ChangeNameTextEditbox"), "");
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".Clan1_ChangeMemberNameWnd"));
		RecallCurrentMemberInfo();
	}
	else if((strID == "Clan1_ChangeMemberGradeAssignBtn"))
	{
		if((Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum((m_Windowname $ ".Clan1_MemberGradeList")) < 5))
		{
			RequestClanChangeGrade(Class'NWindow.UIAPI_TEXTBOX'.static.GetText((m_Windowname $ ".Clan1_CurrentSelectedMemberName")), (Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum((m_Windowname $ ".Clan1_MemberGradeList")) + 1));
		}
		else
		{
			RequestClanChangeGrade(Class'NWindow.UIAPI_TEXTBOX'.static.GetText((m_Windowname $ ".Clan1_CurrentSelectedMemberName")), getCurrentGradebyClanType());
		}
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".Clan1_ChangeMemberGradeNameWnd"));
		RecallCurrentMemberInfo();
	}
	else if((strID == "Clan1_ApprenticeAssignBtn"))
	{
		i = Class'NWindow.UIAPI_LISTCTRL'.static.GetSelectedIndex((m_Windowname $ ".Clan1_AssignApprenticeList"));
		if(((i >= 0) && (m_currentName != "")))
		{
			m_hClanDrawerWndClan1_AssignApprenticeList.GetRec(i, Record);
			RequestClanAssignPupil(m_currentName, Record.LVDataList[0].szData);
		}
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".Clan1_AssignApprenticeWnd"));
	}
	else if((strID == "Clan1_ChangeMemberKnightHoodBtn"))
	{
		proc_swapmember();
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".Clan1_ChangeMemberKnightHoodWnd"));
	}
	else if((strID == "Clan1_Cancel1"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".Clan1_ChangeMemberNameWnd"));
	}
	else if((strID == "Clan1_Cancel2"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".Clan1_ChangeMemberGradeNameWnd"));
	}
	else if((strID == "Clan1_Cancel3"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".Clan1_AssignApprenticeWnd"));
	}
	else if((strID == "Clan1_Cancel4"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".Clan1_ChangeMemberKnightHoodWnd"));
	}
	else if((strID == "Clan7_RegEmbBtn"))
	{
		if((Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("FileRegisterWnd") == false))
		{
			fileextarr.Length = 1;
			fileextarr[0] = "bmp";
			ClearFileRegisterWndFileExt();
			AddFileRegisterWndFileExt(GetSystemString(2811), fileextarr);
			FileRegisterWndShow(FH_PLEDGE_CREST_UPLOAD);
		}
	}
	else if((strID == "Clan7_RmEmbBtn"))
	{
		RequestClanUnregisterCrest();
	}
	else if((strID == "Clan7_RegEmb2Btn"))
	{
		if((Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("FileRegisterWnd") == false))
		{
			fileextarr.Length = 2;
			fileextarr[0] = "tga";
			fileextarr[1] = "bmp";
			ClearFileRegisterWndFileExt();
			AddFileRegisterWndFileExt(GetSystemString(2233), fileextarr);
			FileRegisterWndShow(FH_PLEDGE_EMBLEM_UPLOAD);
		}
	}
	else if((strID == "Clan7_RmEmb2Btn"))
	{
		RequestClanUnregisterEmblem();
	}
	else if((strID == "Clan8_CancelWar1Btn"))
	{
		Class'Interface.UICommonAPI'.static.DialogSetID(487);
		Class'Interface.UICommonAPI'.static.DialogSetDefaultCancle();
		DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3883), ""));
	}
	else if((strID == "Clan8_DeclareWar1Btn"))
	{
		HandleDeclareWar();
	}
	else if((strID == "Clan8_CancelWar2Btn"))
	{
		HandleCancelWar2();
	}
	else if((strID == "Clan8_ViewMoreBtn"))
	{
		RequestClanWarList(++m_clanWarListPage, 1);
	}
	else if((strID == "Clan8_LoseBtn"))
	{
		HandleDeclareLoseWar();
	}
	else if((strID == "Clan2_OKBtn"))
	{
		HideClanWindow();
	}
	else if((strID == "Clan3_OKBtn"))
	{
		HideClanWindow();
	}
	else if((strID == "Clan4_OKBtn"))
	{
		HideClanWindow();
	}
	else if((strID == "Clan5_OKBtn"))
	{
		HideClanWindow();
	}
	else if((strID == "Clan7_OKBtn"))
	{
		HideClanWindow();
	}
	else if((strID == "ClanWar_OKBtn"))
	{
		HideClanWindow();
	}
	else if((strID == "Clan5_ManageBtn"))
	{
		EditAuthGrade();
	}
	else if((strID == "Clan5_ManageBtn2"))
	{
		EditAuthGrade2();
	}
	else if((strID == "Clan6_ApplyBtn"))
	{
		ApplyEditGrade();
		SetStateAndShow("ClanAuthManageWndState");
	}
	else if((strID == "Clan6_CancelBtn"))
	{
		SetStateAndShow("ClanAuthManageWndState");
	}
	else if((strID == "ClanWarTabCtrl0"))
	{
		RequestClanWarList(0, 0);
	}
	else if((strID == "ClanWarTabCtrl1"))
	{
		RequestClanWarList(m_clanWarListPage, 1);
	}
	else if((strID == "Clan1_ChangeNameAssignNobBtn"))
	{
		RequestClanChangeNickName(Script.m_myName, Class'NWindow.UIAPI_EDITBOX'.static.GetString((m_Windowname $ ".Clan1_ChangeNobNameTextEditbox")));
		Class'NWindow.UIAPI_EDITBOX'.static.SetString((m_Windowname $ ".Clan1_ChangeNobNameTextEditbox"), "");
	}
	else if((strID == "Clan1_NobCancel1"))
	{
		HideClanWindow();
	}
	else if((strID == "Clan1_ChangeNameDeleteNobBtn"))
	{
		RequestClanChangeNickName(Script.m_myName, "");
	}
	else if((Left(strID, 12) == "Clan3_OrgIco"))
	{
		temp1 = int(Right(strID, 1));
		if((temp1 == 8))
		{
			return;
		}
		if(((temp1 > 0) && (temp1 < (8 + 2))))
		{
			if(((ClanClickedID < 0) || (temp1 != ClanClickedID)))
			{
				Clan3_OrgHighLight[(temp1 - 1)].ShowWindow();
				if((ClanClickedID != -1))
				{
					Clan3_OrgHighLight[(ClanClickedID - 1)].HideWindow();
				}
				nClanIdx = GetClanTypeFromIndex((temp1 - 1));
				Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear((m_Windowname $ ".ClanSkillWnd"));
				Class'NWindow.UIDATA_CLAN'.static.RequestClanSkillList();
				Class'NWindow.UIDATA_CLAN'.static.RequestSubClanSkillList(nClanIdx);
				ClanClickedID = temp1;
			}
			else if((temp1 == ClanClickedID))
			{
				Clan3_OrgHighLight[(temp1 - 1)].HideWindow();
				Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear((m_Windowname $ ".ClanSkillWnd"));
				Class'NWindow.UIDATA_CLAN'.static.RequestClanSkillList();
				ClanClickedID = -1;
			}
		}
	}
	else if((strID == "Clan8_RefreshBtn"))
	{
		RequestClanWarList(0, 0);
	}
	return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
	local int i;
	local LVDataRecord Record;

	if((ListCtrlID == "Clan5_AuthListCtrl"))
	{
		EditAuthGrade();
	}
	if((ListCtrlID == "Clan5_AuthListCtrl2"))
	{
		EditAuthGrade2();
	}
	if((ListCtrlID == "Clan1_AssignApprenticeList"))
	{
		i = Class'NWindow.UIAPI_LISTCTRL'.static.GetSelectedIndex((m_Windowname $ ".Clan1_AssignApprenticeList"));
		if(((i >= 0) && (m_currentName != "")))
		{
			m_hClanDrawerWndClan1_AssignApprenticeList.GetRec(i, Record);
			RequestClanAssignPupil(m_currentName, Record.LVDataList[0].szData);
		}
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".Clan1_AssignApprenticeWnd"));
	}
	return;
}

function RecallCurrentMemberInfo()
{
	local ClanWnd Script;

	Script = ClanWnd(GetScript("ClanWnd"));
	RequestClanMemberInfo(Script.G_CurrentRecord, Script.G_CurrentSzData);
	SetStateAndShow("ClanMemberInfoState");
	return;
}

function OnClickCheckBox(string CheckBoxID)
{
	local string CheckboxNum, CheckboxName;
	local bool CheckedStat;
	local int i;

	CheckboxName = Left(CheckBoxID, 12);
	if((CheckboxName == "Clan6_Check1"))
	{
		CheckboxNum = Right(CheckBoxID, 2);
		if((CheckboxNum == "00"))
		{
			CheckedStat = Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked((m_Windowname $ ".Clan6_Check100"));
			switch(CheckedStat)
			{
				case true:
					i = 0;
					while((i <= 10))
					{
						if((i < 10))
						{
							Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(((m_Windowname $ ".Clan6_Check10") $ string(i)), true);
							++i;
							continue;
						}
						Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(((m_Windowname $ ".Clan6_Check1") $ string(i)), true);
						++i;
					}
					break;
				case false:
					i = 0;
					while((i <= 10))
					{
						if((i < 10))
						{
							Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(((m_Windowname $ ".Clan6_Check10") $ string(i)), false);
							++i;
							continue;
						}
						Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(((m_Windowname $ ".Clan6_Check1") $ string(i)), false);
						++i;
					}
					break;
				default:
					break;
			}
		}
		else if((count_all_check("1", 10) == true))
		{
			Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_Windowname $ ".Clan6_Check100"), true);
		}
		else
		{
			Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_Windowname $ ".Clan6_Check100"), false);
		}
	}
	if((CheckboxName == "Clan6_Check2"))
	{
		CheckboxNum = Right(CheckBoxID, 2);
		if((CheckboxNum == "00"))
		{
			CheckedStat = Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked((m_Windowname $ ".Clan6_Check200"));
			switch(CheckedStat)
			{
				case true:
					i = 0;
					while((i <= 5))
					{
						Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(((m_Windowname $ ".Clan6_Check20") $ string(i)), true);
						++i;
					}
					break;
				case false:
					i = 0;
					while((i <= 5))
					{
						Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(((m_Windowname $ ".Clan6_Check20") $ string(i)), false);
						++i;
					}
					break;
				default:
					break;
			}
		}
		else if((count_all_check("2", 8) == true))
		{
			Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_Windowname $ ".Clan6_Check200"), true);
		}
		else
		{
			Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_Windowname $ ".Clan6_Check200"), false);
		}
	}
	if((CheckboxName == "Clan6_Check3"))
	{
		CheckboxNum = Right(CheckBoxID, 2);
		if((CheckboxNum == "00"))
		{
			CheckedStat = Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked((m_Windowname $ ".Clan6_Check300"));
			switch(CheckedStat)
			{
				case true:
					i = 0;
					while((i <= 9))
					{
						Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(((m_Windowname $ ".Clan6_Check30") $ string(i)), true);
						++i;
					}
					break;
				case false:
					i = 0;
					while((i <= 9))
					{
						Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(((m_Windowname $ ".Clan6_Check30") $ string(i)), false);
						++i;
					}
					break;
				default:
					break;
			}
		}
		else if((count_all_check("3", 9) == true))
		{
			Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_Windowname $ ".Clan6_Check300"), true);
		}
		else
		{
			Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_Windowname $ ".Clan6_Check300"), false);
		}
	}
	return;
}

function bool count_all_check(string numString, int totalNum)
{
	local bool checkall, currentcheck;
	local int i;

	checkall = false;
	i = 1;
	while((i <= totalNum))
	{
		if((i < 10))
		{
			currentcheck = Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked(((((m_Windowname $ ".Clan6_Check") $ numString) $ "0") $ string(i)));
		}
		else
		{
			currentcheck = Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked((((m_Windowname $ ".Clan6_Check") $ numString) $ string(i)));
		}
		if((currentcheck == true))
		{
			checkall = true;
		}
		++i;
	}
	return checkall;
}

function bool count_all_check2(string numString, int totalNum)
{
	local bool checkall, currentcheck;
	local int i;

	checkall = false;
	i = 1;
	while((i <= totalNum))
	{
		if((i < 10))
		{
			currentcheck = Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked(((((m_Windowname $ ".Clan2_Check") $ numString) $ "0") $ string(i)));
		}
		else
		{
			currentcheck = Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked((((m_Windowname $ ".Clan2_Check") $ numString) $ string(i)));
		}
		if((currentcheck == true))
		{
			checkall = true;
		}
		++i;
	}
	return checkall;
}

function OnEvent(int a_EventID, string a_Param)
{
	if(getInstanceL2Util().isClanV2())
	{
		return;
	}
	switch(a_EventID)
	{
		case 350:
			HandleClanAuthGradeList(a_Param);
			break;
		case 460:
			HandleClanWarList(a_Param);
			break;
		case 360:
			HandleCrestChange(a_Param);
		case 430:
			HandleClanMemberInfo(a_Param);
			break;
		case 490:
			HandleSkillList(a_Param);
			break;
		case 500:
			HandleSkillList(a_Param);
			break;
		case 370:
			HandleClanAuth(a_Param);
			break;
		case 380:
			HandleClanAuthMember(a_Param);
			break;
		case 160:
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ClanDrawerWnd");
			break;
		case 470:
			HandleClearWarList(a_Param);
			break;
		case 1710:
			HandleDialogOK();
			break;
		case 1720:
			break;
		default:
			break;
	}
	return;
}

function HandleDialogOK()
{
	local int dialogID;

	if(!DialogIsMine())
	{
		return;
	}
	dialogID = DialogGetID();
	if((dialogID == 90009))
	{
		RequestClanWarList(0, 0);
		SetStateAndShow("ClanWarManagementWndState");
		RequestSurrenderPledgeWar(currentLossWarClanName);
	}
	else if((dialogID == 487))
	{
		HandleCancelWar1();
	}
	switchingWarCancelButton();
	return;
}

function HandleClanAuthGradeList(string a_Param)
{
	local int Count, Id, members, i;
	local LVDataRecord Record;
	local LVData Data;

	Record.LVDataList.Length = 2;
	Class'NWindow.UIAPI_LISTCTRL'.static.DeleteAllItem((m_Windowname $ ".Clan5_AuthListCtrl"));
	Class'NWindow.UIAPI_LISTCTRL'.static.DeleteAllItem((m_Windowname $ ".Clan5_AuthListCtrl2"));
	ParseInt(a_Param, "Count", Count);
	i = 0;
	while((i < 5))
	{
		ParseInt(a_Param, ("GradeID" $ string(i)), Id);
		ParseInt(a_Param, ("GradeMemberCount" $ string(i)), members);
		Data.szData = GetStringByGradeID(Id);
		Record.LVDataList[0] = Data;
		Data.szData = string(members);
		Record.LVDataList[1] = Data;
		Record.nReserved1 = INT64(Id);
		Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord((m_Windowname $ ".Clan5_AuthListCtrl"), Record);
		++i;
	}
	i = 5;
	while((i < 9))
	{
		ParseInt(a_Param, ("GradeID" $ string(i)), Id);
		ParseInt(a_Param, ("GradeMemberCount" $ string(i)), members);
		Data.szData = GetStringByGradeID(Id);
		Record.LVDataList[0] = Data;
		Data.szData = string(members);
		Record.LVDataList[1] = Data;
		Record.nReserved1 = INT64(Id);
		Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord((m_Windowname $ ".Clan5_AuthListCtrl2"), Record);
		++i;
	}
	Class'NWindow.UIAPI_LISTCTRL'.static.SetSelectedIndex((m_Windowname $ ".Clan5_AuthListCtrl"), 0, true);
	Class'NWindow.UIAPI_LISTCTRL'.static.SetSelectedIndex((m_Windowname $ ".Clan5_AuthListCtrl2"), 0, true);
	return;
}

function HandleClanWarList(string a_Param)
{
	local LVDataRecord Record;
	local int Page;
	local string sClanName;
	local int State, progressTimeInSec;
	local Color colorValue;
	local int totalWarSec, point, pointDiff, leftKillCountOfEnemyToWar;

	ParseInt(a_Param, "Page", Page);
	ParseString(a_Param, "ClanName", sClanName);
	ParseInt(a_Param, "State", State);
	ParseInt(a_Param, "ProgressTimeInSec", progressTimeInSec);
	ParseInt(a_Param, "Point", point);
	ParseInt(a_Param, "PointDiff", pointDiff);
	ParseInt(a_Param, "LeftKillCountOfEnemyToWar", leftKillCountOfEnemyToWar);
	totalWarSec = (((60 * 60) * 24) * 7);
	colorValue.R = 220;
	colorValue.G = 220;
	colorValue.B = 220;
	Record.LVDataList.Length = 7;
	Record.LVDataList[0].bUseTextColor = true;
	Record.LVDataList[0].szData = sClanName;
	Record.LVDataList[0].TextColor = colorValue;
	Record.LVDataList[1].bUseTextColor = true;
	Record.LVDataList[1].szData = getWarStateString(State);
	Record.LVDataList[1].TextColor = colorValue;
	Record.LVDataList[1].nReserved1 = State;
	Record.LVDataList[2].nReserved1 = getWarType(point);
	Record.LVDataList[2].szData = "";
	Record.LVDataList[2].szTexture = getWarSituationTexture(point);
	Record.LVDataList[2].nTextureWidth = 11;
	Record.LVDataList[2].nTextureHeight = 11;
	Record.LVDataList[3].bUseTextColor = true;
	Record.LVDataList[3].szData = string(point);
	Record.LVDataList[3].TextColor = colorValue;
	Record.LVDataList[3].nReserved1 = point;
	Record.LVDataList[4].nReserved1 = pointDiff;
	Record.LVDataList[5].nReserved1 = leftKillCountOfEnemyToWar;
	Record.LVDataList[6].nReserved1 = (totalWarSec - progressTimeInSec);
	m_clanWarListPage = Page;
	m_hClanDrawerWndClan8_DeclaredListCtrl.SetHeaderAlignment(0, TA_Center);
	m_hClanDrawerWndClan8_DeclaredListCtrl.SetHeaderAlignment(1, TA_Center);
	m_hClanDrawerWndClan8_DeclaredListCtrl.SetHeaderAlignment(2, TA_Center);
	m_hClanDrawerWndClan8_DeclaredListCtrl.SetHeaderAlignment(3, TA_Center);
	Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord((m_Windowname $ ".Clan8_DeclaredListCtrl"), Record);
	switchingWarCancelButton();
	return;
}

function switchingWarCancelButton()
{
	local int Len;

	Len = m_hClanDrawerWndClan8_DeclaredListCtrl.GetRecordCount();
	if((Len > 0))
	{
		Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".Clan8_CancelWar1Btn"));
	}
	else
	{
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan8_CancelWar1Btn"));
	}
	return;
}

function string getWarStateString(int State)
{
	if((State == 0))
	{
		return GetSystemString(2349);
	}
	else if((State == 1))
	{
		return GetSystemString(2350);
	}
	else if((State == 2))
	{
		return GetSystemString(340);
	}
	else if((State == 3))
	{
		return GetSystemString(828);
	}
	else if((State == 4))
	{
		return GetSystemString(2356);
	}
	else if((State == 5))
	{
		return GetSystemString(846);
	}
	return "Error";
}

function string getWarSituationString(int pointDiff)
{
	local string returnStr;

	returnStr = "(";
	switch(getWarType(pointDiff))
	{
		case 0:
			returnStr = (returnStr $ GetSystemString(2355));
			break;
		case 1:
			returnStr = (returnStr $ GetSystemString(2354));
			break;
		case 2:
			returnStr = (returnStr $ GetSystemString(2353));
			break;
		case 3:
			returnStr = (returnStr $ GetSystemString(2352));
			break;
		case 4:
			returnStr = (returnStr $ GetSystemString(2351));
			break;
		default:
			break;
	}
	returnStr = (returnStr $ ")");
	return returnStr;
}

function string getWarSituationTexture(int pointDiff)
{
	local string returnStr;

	switch(getWarType(pointDiff))
	{
		case 0:
			returnStr = "L2ui_ct1.clan_DF_warlist_arrow5";
			break;
		case 1:
			returnStr = "L2ui_ct1.clan_DF_warlist_arrow4";
			break;
		case 2:
			returnStr = "L2ui_ct1.clan_DF_warlist_arrow3";
			break;
		case 3:
			returnStr = "L2ui_ct1.clan_DF_warlist_arrow2";
			break;
		case 4:
			returnStr = "L2ui_ct1.clan_DF_warlist_arrow1";
			break;
		default:
			break;
	}
	return returnStr;
}

function int getWarType(int Value)
{
	local int Num;

	if((Value <= -50))
	{
		Num = 0;
	}
	else if(((Value > -50) && (Value <= -20)))
	{
		Num = 1;
	}
	else if(((Value > -20) && (Value <= 19)))
	{
		Num = 2;
	}
	else if(((Value > 19) && (Value <= 49)))
	{
		Num = 3;
	}
	else if((Value >= 50))
	{
		Num = 4;
	}
	return Num;
}

function HandleClanMemberInfo(string a_Param)
{
	local string nickname;
	local int gradeID;
	local string organization, masterName;
	local ClanWnd Script;
	local string organizationtext;

	Script = ClanWnd(GetScript("ClanWnd"));
	ParseInt(a_Param, "ClanType", m_clanType);
	ParseString(a_Param, "Name", m_currentName);
	ParseString(a_Param, "NickName", nickname);
	ParseInt(a_Param, "GradeID", gradeID);
	ParseString(a_Param, "OrderName", organization);
	ParseString(a_Param, "MasterName", masterName);
	currentMasterName = masterName;
	if((masterName == ""))
	{
		masterName = GetSystemString(27);
	}
	organizationtext = ((getClanOrderString(m_clanType) @ "-") @ organization);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".Clan1_CurrentSelectedMemberName"), m_currentName);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".Clan1_CurrentSelectedMemberSName"), nickname);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".Clan1_CurrentSelectedMemberGrade"), GetStringByGradeID(gradeID));
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".Clan1_CurrentSelectedMemberOrderName"), organizationtext);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".Clan1_CurrentSelectedApprentice"), masterName);
	if((Script.m_CurrentclanMasterReal == m_currentName))
	{
		if((Script.m_currentShowIndex == 0))
		{
			Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".Clan1_CurrentSelectedMemberGrade"), GetSystemString(342));
		}
	}
	if((m_clanType == -1))
	{
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_AssignApprenticeBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_DeleteApprenticeBtn"));
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".Clan1_CurrentSelectedApprenticeTitle"), GetSystemString(1332));
	}
	else
	{
		Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".Clan1_AssignApprenticeBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".Clan1_DeleteApprenticeBtn"));
		if((currentMasterName != ""))
		{
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_AssignApprenticeBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".Clan1_DeleteApprenticeBtn"));
		}
		else
		{
			Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".Clan1_AssignApprenticeBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_DeleteApprenticeBtn"));
		}
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".Clan1_CurrentSelectedApprenticeTitle"), GetSystemString(1431));
	}
	Script.resetBtnShowHide();
	CheckandCompareMyNameandDisableThings();
	return;
}

function CheckandCompareMyNameandDisableThings()
{
	local ClanWnd Script;
	local UserInfo UserInfo;

	GetPlayerInfo(UserInfo);
	m_myName = UserInfo.Name;
	Script = ClanWnd(GetScript("ClanWnd"));
	if((Script.m_bClanMaster > 0))
	{
		Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".Clan1_ChangeBanishBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".Clan1_ChangeMemberKHOpen"));
		if((currentMasterName != ""))
		{
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_AssignApprenticeBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".Clan1_DeleteApprenticeBtn"));
			if((Script.G_CurrentAlias == true))
			{
				Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_DeleteApprenticeBtn"));
			}
		}
		else
		{
			Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".Clan1_AssignApprenticeBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_DeleteApprenticeBtn"));
		}
	}
	else
	{
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_ChangeMemberGradeBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_ChangeBanishBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_ChangeMemberKHOpen"));
		Proc_AuthValidation();
		if((Script.GetClanTypeFromIndex(Script.m_currentShowIndex) < Script.m_myClanType))
		{
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_ChangeBanishBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_ChangeMemberGradeBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_AssignApprenticeBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_DeleteApprenticeBtn"));
			if((m_clanType == -1))
			{
			}
			else
			{
				Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_ChangeMemberNameBtn"));
			}
		}
		if((Script.m_myClanType > 1))
		{
			if((Script.GetClanTypeFromIndex(Script.m_currentShowIndex) != 0))
			{
				if(((Script.m_myClanType - Script.GetClanTypeFromIndex(Script.m_currentShowIndex)) == 1))
				{
					Proc_AuthValidation();
				}
				if(((Script.m_myClanType - Script.GetClanTypeFromIndex(Script.m_currentShowIndex)) == 1000))
				{
					Proc_AuthValidation();
				}
				if(((Script.m_myClanType - Script.GetClanTypeFromIndex(Script.m_currentShowIndex)) == 100))
				{
					Proc_AuthValidation();
				}
				if(((Script.m_myClanType - Script.GetClanTypeFromIndex(Script.m_currentShowIndex)) == 999))
				{
					Proc_AuthValidation();
				}
				if(((Script.m_myClanType - Script.GetClanTypeFromIndex(Script.m_currentShowIndex)) == 1001))
				{
					Proc_AuthValidation();
				}
			}
		}
		if((Script.G_CurrentAlias == true))
		{
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_ChangeBanishBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_ChangeMemberNameBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_ChangeMemberGradeBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_AssignApprenticeBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_DeleteApprenticeBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_ChangeMemberKHOpen"));
		}
		if((Script.m_CurrentclanMasterReal == m_currentName))
		{
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_ChangeMemberGradeBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_ChangeBanishBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_AssignApprenticeBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_DeleteApprenticeBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_ChangeMemberNameBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_ChangeMemberKHOpen"));
		}
	}
	if((m_currentName == m_myName))
	{
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_ChangeMemberGradeBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_ChangeBanishBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_ChangeMemberKHOpen"));
	}
	if((m_clanType == -1))
	{
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_ChangeMemberGradeBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_AssignApprenticeBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_DeleteApprenticeBtn"));
	}
	return;
}

function Proc_AuthValidation()
{
	local ClanWnd Script;

	Script = ClanWnd(GetScript("ClanWnd"));
	if((Script.m_bNickName == 0))
	{
		if(((Script.G_IamHero == true) || (Script.G_IamNobless > 0)))
		{
			Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".Clan1_ChangeMemberNameBtn"));
		}
		else
		{
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_ChangeMemberNameBtn"));
		}
	}
	else
	{
		Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".Clan1_ChangeMemberNameBtn"));
	}
	if((Script.m_bGrade == 0))
	{
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_ChangeMemberGradeBtn"));
	}
	else
	{
		Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".Clan1_ChangeMemberGradeBtn"));
	}
	if((Script.m_bManageMaster == 0))
	{
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_AssignApprenticeBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_DeleteApprenticeBtn"));
	}
	else if((currentMasterName != ""))
	{
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_AssignApprenticeBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".Clan1_DeleteApprenticeBtn"));
	}
	else
	{
		Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".Clan1_AssignApprenticeBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_DeleteApprenticeBtn"));
	}
	if((Script.m_bOustMember == 0))
	{
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_ChangeBanishBtn"));
	}
	else
	{
		Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".Clan1_ChangeBanishBtn"));
	}
	return;
}

function HandleCrestChange(string param)
{
	local ClanWnd Script;

	if((m_state == "ClanEmblemManageWndState"))
	{
		Script = ClanWnd(GetScript("ClanWnd"));
		Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTextureWithClanCrest((m_Windowname $ ".ClanCrestTextureCtrl"), Script.m_clanID);
	}
	return;
}

function HandleSkillList(string a_Param)
{
	local int Count, i, Level, findItemID;
	local string AgitText;
	local ItemID cID;

	ParseInt(a_Param, "Count", Count);
	i = 0;
	while((i < Count))
	{
		ParseItemIDWithIndex(a_Param, cID, i);
		ParseInt(a_Param, ("SkillLevel_" $ string(i)), Level);
		findItemID = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem((m_Windowname $ ".ClanSkillWnd"), cID);
		AgitText = Class'NWindow.UIAPI_TEXTBOX'.static.GetText("ClanWnd.ClanAgitText");
		AddSkill(cID, Level);
		++i;
	}
	return;
}

function HandleDeclareLoseWar()
{
	local LVDataRecord Record;
	local int Index;

	Index = Class'NWindow.UIAPI_LISTCTRL'.static.GetSelectedIndex((m_Windowname $ ".Clan8_DeclaredListCtrl"));
	if((Index >= 0))
	{
		m_hClanDrawerWndClan8_DeclaredListCtrl.GetRec(Index, Record);
		currentLossWarClanName = Record.LVDataList[0].szData;
		DialogSetID(90009);
		DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3409), Record.LVDataList[0].szData));
	}
	return;
}

function bool searchClanWarDeclare(string ClanName)
{
	local LVDataRecord Record;
	local int i, maxRec;
	local bool bCheck;

	bCheck = false;
	maxRec = m_hClanDrawerWndClan8_DeclaredListCtrl.GetRecordCount();
	i = 0;
	while((i < maxRec))
	{
		m_hClanDrawerWndClan8_DeclaredListCtrl.GetRec(i, Record);
		if((Record.LVDataList[0].szData == ClanName))
		{
			if((Record.LVDataList[1].nReserved1 == 1))
			{
				bCheck = true;
				break;
			}
		}
		i++;
	}
	return bCheck;
}

function HandleCancelWar1()
{
	local LVDataRecord Record;
	local int Index;

	Index = Class'NWindow.UIAPI_LISTCTRL'.static.GetSelectedIndex((m_Windowname $ ".Clan8_DeclaredListCtrl"));
	if((Index >= 0))
	{
		m_hClanDrawerWndClan8_DeclaredListCtrl.GetRec(Index, Record);
		RequestClanWithdrawWarWithClanName(Record.LVDataList[0].szData);
		RequestClanWarList(0, 0);
		SetStateAndShow("ClanWarManagementWndState");
	}
	return;
}

function HandleDeclareWar()
{
	local LVDataRecord Record;
	local int Index;

	Index = m_hClanDrawerWndClan8_GotDeclaredListCtrl.GetSelectedIndex();
	if((Index >= 0))
	{
		m_hClanDrawerWndClan8_GotDeclaredListCtrl.GetRec(Index, Record);
		RequestClanDeclareWarWithClanName(Record.LVDataList[0].szData);
		RequestClanWarList(m_clanWarListPage, 1);
	}
	return;
}

function HandleCancelWar2()
{
	local LVDataRecord Record;
	local int Index;

	Index = m_hClanDrawerWndClan8_GotDeclaredListCtrl.GetSelectedIndex();
	if((Index >= 0))
	{
		m_hClanDrawerWndClan8_GotDeclaredListCtrl.GetRec(Index, Record);
		RequestClanWithdrawWarWithClanName(Record.LVDataList[0].szData);
		RequestClanWarList(m_clanWarListPage, 1);
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((m_Windowname $ ".ClanWarManagementWnd"));
	}
	return;
}

function HandleClanAuth(string a_Param)
{
	local int gradeID, Command;
	local array<int> powers;
	local int i, Index;

	ParseInt(a_Param, "GradeID", gradeID);
	ParseInt(a_Param, "Command", Command);
	powers.Length = 32;
	i = 0;
	while((i < 32))
	{
		ParseInt(a_Param, ("PowerValue" $ string(i)), powers[i]);
		++i;
	}
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".Clan6_CurrentSelectedRankName"), (GetStringByGradeID(gradeID) $ GetSystemString(1376)));
	Index = 1;
	i = 1;
	while((i <= 10))
	{
		if((i < 10))
		{
			Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(((m_Windowname $ ".Clan6_Check10") $ string(i)), bool(powers[Index++]));
			++i;
			continue;
		}
		Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(((m_Windowname $ ".Clan6_Check1") $ string(i)), bool(powers[Index++]));
		++i;
	}
	i = 1;
	while((i <= 5))
	{
		Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(((m_Windowname $ ".Clan6_Check20") $ string(i)), bool(powers[Index++]));
		++i;
	}
	i = 1;
	while((i <= 8))
	{
		Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(((m_Windowname $ ".Clan6_Check30") $ string(i)), bool(powers[Index++]));
		++i;
	}
	if((count_all_check("1", 10) == true))
	{
		Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_Windowname $ ".Clan6_Check100"), true);
	}
	else
	{
		Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_Windowname $ ".Clan6_Check100"), false);
	}
	if((count_all_check("2", 5) == true))
	{
		Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_Windowname $ ".Clan6_Check200"), true);
	}
	else
	{
		Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_Windowname $ ".Clan6_Check200"), false);
	}
	if((count_all_check("3", 8) == true))
	{
		Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_Windowname $ ".Clan6_Check300"), true);
	}
	else
	{
		Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_Windowname $ ".Clan6_Check300"), false);
	}
	if((gradeID == 9))
	{
		disableAcademyAuth();
	}
	else
	{
		resetAcademyAuth();
	}
	return;
}

function HandleClanAuthMember(string a_Param)
{
	local ClanWnd Script;
	local int gradeID;
	local string sName;
	local array<int> powers;
	local int i, Index;

	Script = ClanWnd(GetScript("ClanWnd"));
	ParseInt(a_Param, "Grade", gradeID);
	ParseString(a_Param, "Name", sName);
	powers.Length = 32;
	i = 0;
	while((i < 32))
	{
		ParseInt(a_Param, ("PowerValue" $ string(i)), powers[i]);
		++i;
	}
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".Clan2_CurrentSelectedMemberName"), ((sName @ "-") @ GetStringByGradeID(gradeID)));
	Index = 1;
	i = 1;
	while((i <= 10))
	{
		if((i < 10))
		{
			Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(((m_Windowname $ ".Clan2_Check10") $ string(i)), bool(powers[Index++]));
			++i;
			continue;
		}
		Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(((m_Windowname $ ".Clan2_Check1") $ string(i)), bool(powers[Index++]));
		++i;
	}
	i = 1;
	while((i <= 5))
	{
		Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(((m_Windowname $ ".Clan2_Check20") $ string(i)), bool(powers[Index++]));
		++i;
	}
	i = 1;
	while((i <= 8))
	{
		Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(((m_Windowname $ ".Clan2_Check30") $ string(i)), bool(powers[Index++]));
		++i;
	}
	if((count_all_check2("1", 10) == true))
	{
		Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_Windowname $ ".Clan2_Check100"), true);
	}
	else
	{
		Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_Windowname $ ".Clan2_Check100"), false);
	}
	if((count_all_check2("2", 5) == true))
	{
		Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_Windowname $ ".Clan2_Check200"), true);
	}
	else
	{
		Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_Windowname $ ".Clan2_Check200"), false);
	}
	if((count_all_check2("3", 8) == true))
	{
		Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_Windowname $ ".Clan2_Check300"), true);
	}
	else
	{
		Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_Windowname $ ".Clan2_Check300"), false);
	}
	if((Script.m_myName == sName))
	{
		if((Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked((m_Windowname $ ".Clan2_Check101")) == true))
		{
			Script.m_bJoin = 1;
		}
		else
		{
			Script.m_bJoin = 0;
		}
		if((Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked((m_Windowname $ ".Clan2_Check107")) == true))
		{
			Script.m_bCrest = 1;
		}
		else
		{
			Script.m_bCrest = 0;
		}
		if((Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked((m_Windowname $ ".Clan2_Check105")) == true))
		{
			Script.m_bWar = 1;
		}
		else
		{
			Script.m_bWar = 0;
		}
		Script.resetBtnShowHide();
	}
	if((Script.m_CurrentclanMasterReal == sName))
	{
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".Clan2_CurrentSelectedMemberName"), ((sName @ "-") @ GetSystemString(342)));
		i = 0;
		while((i <= 10))
		{
			if((i < 10))
			{
				Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(((m_Windowname $ ".Clan2_Check10") $ string(i)), true);
				++i;
				continue;
			}
			Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(((m_Windowname $ ".Clan2_Check1") $ string(i)), true);
			++i;
		}
		i = 0;
		while((i <= 5))
		{
			Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(((m_Windowname $ ".Clan2_Check20") $ string(i)), true);
			++i;
		}
		i = 0;
		while((i <= 8))
		{
			Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(((m_Windowname $ ".Clan2_Check30") $ string(i)), true);
			++i;
		}
	}
	return;
}

function HandleClearWarList(string a_Param)
{
	Class'NWindow.UIAPI_LISTCTRL'.static.DeleteAllItem((m_Windowname $ ".Clan8_DeclaredListCtrl"));
	switchingWarCancelButton();
	return;
}

function string GetStringByGradeID(int gradeID)
{
	local int stringIndex;

	stringIndex = -1;
	if((gradeID == 1))
	{
		stringIndex = 1406;
	}
	else if((gradeID == 2))
	{
		stringIndex = 1407;
	}
	else if((gradeID == 3))
	{
		stringIndex = 1408;
	}
	else if((gradeID == 4))
	{
		stringIndex = 1409;
	}
	else if((gradeID == 5))
	{
		stringIndex = 1410;
	}
	else if((gradeID == 6))
	{
		stringIndex = 1411;
	}
	else if((gradeID == 7))
	{
		stringIndex = 1412;
	}
	else if((gradeID == 8))
	{
		stringIndex = 1413;
	}
	else if((gradeID == 9))
	{
		stringIndex = 1414;
	}
	if((stringIndex != -1))
	{
		return GetSystemString(stringIndex);
	}
	else
	{
		return "";
	}
}

function InitializeAcademyList()
{
	local ClanWnd Script;
	local int i;
	local LVDataRecord Record;

	Record.LVDataList.Length = 3;
	Script = ClanWnd(GetScript("ClanWnd"));
	InitializeClan1_AssignApprenticeList();
	i = 0;
	while((i < Script.m_memberList[Script.GetIndexFromType(-1)].m_array.Length))
	{
		if((Script.m_memberList[Script.GetIndexFromType(-1)].m_array[i].bHaveMaster == 0))
		{
			Record.LVDataList[0].szData = Script.m_memberList[Script.GetIndexFromType(-1)].m_array[i].sName;
			Record.LVDataList[1].szData = string(Script.m_memberList[Script.GetIndexFromType(-1)].m_array[i].Level);
			Record.nReserved1 = INT64(Script.m_memberList[Script.GetIndexFromType(-1)].m_array[i].clanType);
			Record.LVDataList[2].szData = string(Script.m_memberList[Script.GetIndexFromType(-1)].m_array[i].ClassID);
			Record.LVDataList[2].szTexture = GetClassRoleIconName(Script.m_memberList[Script.GetIndexFromType(-1)].m_array[i].ClassID);
			Record.LVDataList[2].nTextureWidth = 11;
			Record.LVDataList[2].nTextureHeight = 11;
			Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord((m_Windowname $ ".Clan1_AssignApprenticeList"), Record);
		}
		++i;
	}
	return;
}

function InitializeClan1_AssignApprenticeList()
{
	Class'NWindow.UIAPI_LISTCTRL'.static.DeleteAllItem((m_Windowname $ ".Clan1_AssignApprenticeList"));
	return;
}

function InitializeClanInfoWnd()
{
	local Color Blue, Red, DarkYellow;
	local ClanWnd Script;
	local SkillTrainClanTreeWnd script2;
	local int i;
	local string ClanNameVal, ClanRankStr, ToolTip;
	local int clanType;

	Blue.R = 126;
	Blue.G = 158;
	Blue.B = 245;
	Red.R = 200;
	Red.G = 50;
	Red.B = 80;
	DarkYellow.R = 175;
	DarkYellow.G = 152;
	DarkYellow.B = 120;
	Script = ClanWnd(GetScript("ClanWnd"));
	script2 = SkillTrainClanTreeWnd(GetScript("SkillTrainClanTreeWnd"));
	ClanNameVal = (string(Script.m_clanNameValue) @ GetSystemString(1442));
	if(((ClanClickedID > 0) && Clan3_OrgHighLight[(ClanClickedID - 1)].IsShowWindow()))
	{
		Clan3_OrgHighLight[(ClanClickedID - 1)].HideWindow();
	}
	ClanClickedID = -1;
	reset_clan_org();
	if((Script.m_clanRank == 0))
	{
		ClanRankStr = GetSystemString(1374);
	}
	else if((Script.m_clanRank <= 100))
	{
		ClanRankStr = (string(Script.m_clanRank) @ GetSystemString(1375));
	}
	else
	{
		ClanRankStr = GetSystemString(1374);
	}
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".Clan3_ClanName"), Script.m_clanName);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".Clan3_ClanPoint"), ClanNameVal);
	if((Script.m_clanNameValue == 0))
	{
		Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor((m_Windowname $ ".Clan3_ClanPoint"), DarkYellow);
	}
	else if((Script.m_clanNameValue < 0))
	{
		Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor((m_Windowname $ ".Clan3_ClanPoint"), Red);
	}
	else if((Script.m_clanNameValue > 0))
	{
		Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor((m_Windowname $ ".Clan3_ClanPoint"), Blue);
	}
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".Clan3_ClanRanking"), ClanRankStr);
	i = 0;
	while((i < 8))
	{
		if((Script.m_memberList[i].m_sName != ""))
		{
			clanType = Script.GetClanTypeFromIndex(i);
			if((clanType == 0))
			{
				ToolTip = ((((Script.m_memberList[i].m_sName $ "\\n") $ GetSystemString(342)) $ " : ") $ Script.m_memberList[i].m_sMasterName);
			}
			if((clanType == -1))
			{
				ToolTip = Script.m_memberList[i].m_sName;
			}
			if(((clanType == 100) || (clanType == 200)))
			{
				ToolTip = ((((Script.m_memberList[i].m_sName $ "\\n") $ GetSystemString(1438)) $ " : ") $ Script.m_memberList[i].m_sMasterName);
			}
			if(((((clanType == 1001) || (clanType == 1002)) || (clanType == 2001)) || (clanType == 2002)))
			{
				ToolTip = ((((Script.m_memberList[i].m_sName $ "\\n") $ GetSystemString(1433)) $ " : ") $ Script.m_memberList[i].m_sMasterName);
			}
			if((ToolTip != ""))
			{
				Clan3_OrgIcon[i].ShowWindow();
				Clan3_OrgIcon[i].EnableWindow();
				Clan3_OrgIcon[i].SetTooltipCustomType(SetTooltip(ToolTip));
				script2.Clan_OrgIcon[i].ShowWindow();
				script2.Clan_OrgIcon[i].SetTooltipCustomType(SetTooltip(ToolTip));
			}
		}
		++i;
	}
	return;
}

function InitializeGradeComboBox()
{
	local int i;

	Class'NWindow.UIAPI_COMBOBOX'.static.Clear((m_Windowname $ ".Clan1_MemberGradeList"));
	i = 1;
	while((i < 6))
	{
		Class'NWindow.UIAPI_COMBOBOX'.static.AddString((m_Windowname $ ".Clan1_MemberGradeList"), GetStringByGradeID(i));
		++i;
	}
	Class'NWindow.UIAPI_COMBOBOX'.static.AddString((m_Windowname $ ".Clan1_MemberGradeList"), GetSystemString(1451));
	return;
}

function KnighthoodCombobox()
{
	local ClanWnd Script;
	local int i;

	Script = ClanWnd(GetScript("ClanWnd"));
	Class'NWindow.UIAPI_COMBOBOX'.static.Clear((m_Windowname $ ".Clan1_targetknighthoodcombobox"));
	Class'NWindow.UIAPI_COMBOBOX'.static.Clear((m_Windowname $ ".Clan1_targetknighthoodmember"));
	Class'NWindow.UIAPI_COMBOBOX'.static.AddStringWithReserved((m_Windowname $ ".Clan1_targetknighthoodcombobox"), GetSystemString(1465), 0);
	Class'NWindow.UIAPI_COMBOBOX'.static.AddStringWithReserved((m_Windowname $ ".Clan1_targetknighthoodmember"), GetSystemString(1466), 0);
	Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_targetknighthoodmember"));
	Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".Clan1_ChangeMemberKnightHoodBtn"));
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".Clan1_ChangeMemberKnightHoodTXT1"), MakeFullSystemMsg(GetSystemMessage(1906), m_currentName, ""));
	i = 0;
	while((i < 8))
	{
		if((Script.m_memberList[i].m_sName != ""))
		{
			if((Script.GetClanTypeFromIndex(i) != -1))
			{
				Class'NWindow.UIAPI_COMBOBOX'.static.AddStringWithReserved((m_Windowname $ ".Clan1_targetknighthoodcombobox"), Script.m_memberList[i].m_sName, i);
			}
		}
		++i;
	}
	Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum((m_Windowname $ ".Clan1_targetknighthoodcombobox"), 0);
	return;
}

function swapTargetSelect(int clanNo)
{
	local ClanWnd Script;
	local int i;

	Script = ClanWnd(GetScript("ClanWnd"));
	Class'NWindow.UIAPI_COMBOBOX'.static.Clear((m_Windowname $ ".Clan1_targetknighthoodmember"));
	Class'NWindow.UIAPI_COMBOBOX'.static.AddStringWithReserved((m_Windowname $ ".Clan1_targetknighthoodmember"), GetSystemString(1466), 0);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".Clan1_ChangeMemberKnightHoodTXT1"), MakeFullSystemMsg(GetSystemMessage(1907), m_currentName, ""));
	i = 0;
	while((i <= Script.m_memberList[clanNo].m_array.Length))
	{
		if((Script.m_memberList[clanNo].m_array[i].sName != Script.m_CurrentclanMasterReal))
		{
			Class'NWindow.UIAPI_COMBOBOX'.static.AddStringWithReserved((m_Windowname $ ".Clan1_targetknighthoodmember"), Script.m_memberList[clanNo].m_array[i].sName, Script.m_memberList[clanNo].m_array[i].clanType);
		}
		++i;
	}
	Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum((m_Windowname $ ".Clan1_targetknighthoodmember"), 0);
	return;
}

function proc_swapmember()
{
	local int currentindexnew1, currentindexnew2;
	local string currentstring1, currentstring2;
	local int Type, clantype1;
	local ClanWnd Script;

	Script = ClanWnd(GetScript("ClanWnd"));
	currentindexnew1 = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum((m_Windowname $ ".Clan1_targetknighthoodcombobox"));
	currentstring1 = Class'NWindow.UIAPI_COMBOBOX'.static.GetString((m_Windowname $ ".Clan1_targetknighthoodcombobox"), currentindexnew1);
	clantype1 = Script.GetClanTypeFromIndex(Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved((m_Windowname $ ".Clan1_targetknighthoodcombobox"), currentindexnew1));
	currentindexnew2 = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum((m_Windowname $ ".Clan1_targetknighthoodmember"));
	currentstring2 = Class'NWindow.UIAPI_COMBOBOX'.static.GetString((m_Windowname $ ".Clan1_targetknighthoodmember"), currentindexnew2);
	if((currentindexnew2 == 0))
	{
		Type = 0;
	}
	else
	{
		Type = 1;
	}
	if((Type == 1))
	{
		RequestClanReorganizeMember(1, m_currentName, clantype1, currentstring2);
	}
	else if((Type == 0))
	{
		RequestClanReorganizeMember(0, m_currentName, clantype1, "");
	}
	return;
}

function OnComboBoxItemSelected(string strID, int Index)
{
	local int selectval;

	if((strID == "Clan1_targetknighthoodcombobox"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".Clan1_targetknighthoodmember"));
		Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".Clan1_ChangeMemberKnightHoodBtn"));
		selectval = Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved((m_Windowname $ ".Clan1_targetknighthoodcombobox"), Index);
		swapTargetSelect(selectval);
	}
	return;
}

function HideClanWindow()
{
	local ClanWnd Script;

	Script = ClanWnd(GetScript("ClanWnd"));
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ClanDrawerWnd");
	Script.ResetOpeningVariables();
	switchingWarCancelButton();
	return;
}

function ApplyEditGrade()
{
	local array<int> powers;
	local int i, Index;

	powers.Length = 32;
	powers[0] = 0;
	Index = 1;
	i = 1;
	while((i <= 10))
	{
		if((i < 10))
		{
			if(Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked(((m_Windowname $ ".Clan6_Check10") $ string(i))))
			{
				powers[Index] = 1;
			}
		}
		else if(Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked(((m_Windowname $ ".Clan6_Check1") $ string(i))))
		{
			powers[Index] = 1;
		}
		++Index;
		++i;
	}
	i = 1;
	while((i <= 5))
	{
		if(Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked(((m_Windowname $ ".Clan6_Check20") $ string(i))))
		{
			powers[Index] = 1;
		}
		++Index;
		++i;
	}
	i = 1;
	while((i <= 8))
	{
		if(Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked(((m_Windowname $ ".Clan6_Check30") $ string(i))))
		{
			powers[Index] = 1;
		}
		++Index;
		++i;
	}
	RequestEditClanAuth(m_currentEditGradeID, powers);
	return;
}

function EditAuthGrade()
{
	local int Index;
	local LVDataRecord Record;

	Index = m_hClanDrawerWndClan5_AuthListCtrl.GetSelectedIndex();
	if((Index >= 0))
	{
		m_hClanDrawerWndClan5_AuthListCtrl.GetRec(Index, Record);
		RequestClanAuth(int(Record.nReserved1));
		m_currentEditGradeID = int(Record.nReserved1);
		SetStateAndShow("ClanAuthEditWndState");
	}
	else
	{
		SetStateAndShow("ClanAuthManageWndState");
	}
	return;
}

function EditAuthGrade2()
{
	local int Index;
	local LVDataRecord Record;

	Index = m_hClanDrawerWndClan5_AuthListCtrl2.GetSelectedIndex();
	if((Index >= 0))
	{
		m_hClanDrawerWndClan5_AuthListCtrl2.GetRec(Index, Record);
		RequestClanAuth(int(Record.nReserved1));
		m_currentEditGradeID = int(Record.nReserved1);
		SetStateAndShow("ClanAuthEditWndState");
	}
	else
	{
		SetStateAndShow("ClanAuthManageWndState");
	}
	return;
}

function AddSkill(ItemID cID, int Level)
{
	local ItemInfo Info;

	Info.Id = cID;
	Info.Level = Level;
	Info.Name = Class'NWindow.UIDATA_SKILL'.static.GetName(Info.Id, Info.Level, Info.SubLevel);
	Info.IconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(Info.Id, Info.Level, Info.SubLevel);
	Info.Description = Class'NWindow.UIDATA_SKILL'.static.GetDescription(Info.Id, Info.Level, Info.SubLevel);
	Info.AdditionalName = Class'NWindow.UIDATA_SKILL'.static.GetEnchantName(Info.Id, Info.Level, Info.SubLevel);
	Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem((m_Windowname $ ".ClanSkillWnd"), Info);
	return;
}

function ReplaceSkill(int Index, ItemID cID, int Level)
{
	local ItemInfo Info;

	Info.Id = cID;
	Info.Level = Level;
	Info.Name = Class'NWindow.UIDATA_SKILL'.static.GetName(Info.Id, Info.Level, Info.SubLevel);
	Info.IconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(Info.Id, Info.Level, Info.SubLevel);
	Info.Description = Class'NWindow.UIDATA_SKILL'.static.GetDescription(Info.Id, Info.Level, Info.SubLevel);
	Info.AdditionalName = Class'NWindow.UIDATA_SKILL'.static.GetEnchantName(Info.Id, Info.Level, Info.SubLevel);
	Class'NWindow.UIAPI_ITEMWINDOW'.static.SetItem((m_Windowname $ ".ClanSkillWnd"), Index, Info);
	return;
}

function string getClanOrderString(int gradeID)
{
	local int stringIndex;

	stringIndex = -1;
	if((gradeID == 0))
	{
		stringIndex = 1399;
	}
	else if((gradeID == 100))
	{
		stringIndex = 1400;
	}
	else if((gradeID == 200))
	{
		stringIndex = 1401;
	}
	else if((gradeID == 1001))
	{
		stringIndex = 1402;
	}
	else if((gradeID == 1002))
	{
		stringIndex = 1403;
	}
	else if((gradeID == 2001))
	{
		stringIndex = 1404;
	}
	else if((gradeID == 2002))
	{
		stringIndex = 1405;
	}
	else if((gradeID == -1))
	{
		stringIndex = 1419;
	}
	if((stringIndex != -1))
	{
		return GetSystemString(stringIndex);
	}
	else
	{
		return "";
	}
}

function reset_clan_org()
{
	local int i;

	i = 0;
	while((i < 8))
	{
		Clan3_OrgIcon[i].HideWindow();
		Clan3_OrgIcon[i].DisableWindow();
		Clan3_OrgIcon[i].SetTooltipCustomType(SetTooltip(""));
		++i;
	}
	return;
}

function disableAcademyAuth()
{
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check100"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check101"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check102"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check106"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check104"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check105"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check107"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check108"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check109"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check110"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check200"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check203"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check204"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check205"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check300"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check303"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check302"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check305"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check306"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check307"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check308"), true);
	return;
}

function resetAcademyAuth()
{
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check100"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check101"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check102"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check106"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check104"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check105"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check107"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check108"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check109"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check110"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check200"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check203"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check204"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check205"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check300"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check303"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check302"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check305"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check306"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check307"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_Windowname $ ".Clan6_Check308"), false);
	return;
}

function int getCurrentGradebyClanType()
{
	local int GradeNum;

	switch(m_clanType)
	{
		case 0:
			GradeNum = 6;
			break;
		case 100:
			GradeNum = 7;
			break;
		case 200:
			GradeNum = 7;
			break;
		case 1001:
			GradeNum = 8;
			break;
		case 1002:
			GradeNum = 8;
			break;
		case 2001:
			GradeNum = 8;
			break;
		case 2002:
			GradeNum = 8;
			break;
		case -1:
			GradeNum = 9;
			break;
		default:
			break;
	}
	return GradeNum;
}

function CustomTooltip SetTooltip(string Text)
{
	local CustomTooltip ToolTip;
	local DrawItemInfo Info;

	ToolTip.MinimumWidth = 144;
	ToolTip.DrawList.Length = 1;
	Info.eType = DIT_TEXT;
	Info.t_color.R = 178;
	Info.t_color.G = 190;
	Info.t_color.B = 207;
	Info.t_color.A = 255;
	Info.t_strText = Text;
	ToolTip.DrawList[0] = Info;
	return ToolTip;
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

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="ClanDrawerWnd"
	m_ClanPledgeBonusDrawerWndName="ClanPledgeBonusDrawerWnd"
}
