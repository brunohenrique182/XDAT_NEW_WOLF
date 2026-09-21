class ClanSubMenuManageContainer extends UICommonAPI;

const DIALOG_AskClanEnemyCancel = 487;
const c_maxranklimit = 100;
const changelineval1 = 23;
const DISABLE_ALPHA = 100;
const ACADEMY_INDEX = 7;
const NUMOFOPTIONS_SYSTEM = 10;
const NUMOFOPTIONS_AGIT = 5;
const NUMOFOPTIONS_CASTLE = 8;
const PP_PLEDGE_ENEMY = 24;
const POWERS_LENGTH = 32;

enum TYPE_SUBMENU_STATE
{
	non,                            // 0
	ClanMemberInfoState,            // 1
	ClanMemberAuthState,            // 2
	ClanAuthManageWndState,         // 3
	ClanEmblemManageWndState,       // 4
	ClanAuthEditWndState            // 5
};

var string m_Windowname;
var WindowHandle Me;
var ClanWndClassicNew clanWndClassicScript;
var int m_clanType;
var int m_currentEditGradeID;
var string m_currentName;
var string m_myName;
var int m_currentMaster;
var string m_WindowName_ClanMemberInfoWnd;
var string m_WindowName_ClanMemberAuthWnd;
var string m_WindowName_ClanAuthManageWnd;
var string m_WindowName_ClanAuthEditWnd;
var string m_WindowName_ClanEmblemManageWnd;
var ListCtrlHandle m_hClanDrawerWndClan8_DeclaredListCtrl;
var ListCtrlHandle m_hClanDrawerWndClan5_AuthListCtrl;
var FileRegisterWnd fileRegisterWndHandle;
var TYPE_SUBMENU_STATE CurrentState;
var UIControlTilelist scrollTesterV;
var bool isInitScrollPanel;

function InitDefaultSetting()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	m_Windowname = Class'InterfaceClassic.L2Util'.static.GetFullPath(Me);
	clanWndClassicScript = ClanWndClassicNew(GetScript("ClanWndClassicNew"));
	clanWndClassicScript.clanSubMenuManageContainerScr = self;
	return;
}

function InitScrollPanel()
{
	if(isInitScrollPanel)
	{
		return;
	}
	scrollTesterV = Class'InterfaceClassic.UIControlTilelist'.static.InitScript(GetWindowHandle((m_WindowName_ClanEmblemManageWnd $ ".ScrollAreaWndV")), 5, 11, true);
	scrollTesterV.DelegateOnItemRenderer = HandleDelegateOnItemRenderer;
	scrollTesterV.DelegateOnRendererClick = HandleDelegateOnRenderClickV;
	scrollTesterV._SetTileListItemNumTotal(55);
	scrollTesterV._Refresh();
	isInitScrollPanel = true;
	return;
}

function InitHandle()
{
	m_WindowName_ClanMemberInfoWnd = (m_Windowname $ ".ClanMemberInfoWnd");
	m_WindowName_ClanMemberAuthWnd = (m_Windowname $ ".ClanMemberAuthWnd");
	m_WindowName_ClanAuthManageWnd = (m_Windowname $ ".ClanAuthManageWnd");
	m_WindowName_ClanAuthEditWnd = (m_Windowname $ ".ClanAuthEditWnd");
	m_WindowName_ClanEmblemManageWnd = (m_Windowname $ ".ClanEmblemManageWnd");
	fileRegisterWndHandle = FileRegisterWnd(GetScript("FileRegisterWnd"));
	m_hClanDrawerWndClan5_AuthListCtrl = GetListCtrlHandle((m_WindowName_ClanAuthManageWnd $ ".Clan5_AuthListCtrl"));
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check105"));
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check108"));
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check109"));
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check110"));
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check302"));
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check307"));
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check105"));
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check108"));
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check109"));
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check110"));
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check302"));
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check307"));
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(350);
	RegisterEvent(360);
	RegisterEvent(370);
	RegisterEvent(380);
	RegisterEvent(430);
	RegisterEvent(160);
	return;
}

event OnLoad()
{
	InitDefaultSetting();
	InitHandle();
	InitializeGradeComboBox();
	InitClanEmbleManageWndState();
	InitScrollPanel();
	HideAll();
	return;
}

function Clear()
{
	CurrentState = non;
	m_clanType = -1;
	m_currentEditGradeID = -1;
	m_currentName = "";
	return;
}

event OnHide()
{
	if(DialogIsMineCheck())
	{
		Class'InterfaceClassic.DialogBox'.static.Inst().HideDialog();
	}
	FileRegisterWndHide();
	Clear();
	return;
}

event OnShow()
{
	Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameBtn"));
	Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeBtn"));
	Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeBanishBtn"));
	if((clanWndClassicScript.m_bClanMaster == 0))
	{
		if((clanWndClassicScript.m_bNickName == 0))
		{
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameBtn"));
		}
		if((clanWndClassicScript.m_bGrade == 0))
		{
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeBtn"));
		}
		if((clanWndClassicScript.m_bOustMember == 0))
		{
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeBanishBtn"));
		}
	}
	return;
}

event OnDBClickListCtrlRecord(string ListCtrlID)
{
	switch(ListCtrlID)
	{
		case "Clan5_AuthListCtrl":
			EditAuthGrade();
			break;
		default:
			break;
	}
	return;
}

event OnClickButton(string strID)
{
	if((strID == "ClanMemAuthBtn"))
	{
		if(ToggleWindowByType(ClanMemberAuthState))
		{
			SetState(ClanMemberAuthState);
		}
	}
	else if((strID == "Clan1_ChangeMemberNameBtn"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameWnd"));
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeNameWnd"));
		Class'NWindow.UIAPI_EDITBOX'.static.SetString((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameWnd.Clan1_ChangeNameTextEditbox"), "");
	}
	else if((strID == "Clan1_ChangeMemberGradeBtn"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeNameWnd"));
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameWnd"));
	}
	else if((strID == "Clan1_ChangeBanishBtn"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameWnd"));
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeNameWnd"));
		RequestClanExpelMember(m_clanType, Class'NWindow.UIAPI_TEXTBOX'.static.GetText((m_WindowName_ClanMemberInfoWnd $ ".Clan1_CurrentSelectedMemberName")));
	}
	else if((strID == "Clan1_ChangeNameAssignBtn"))
	{
		RequestClanChangeNickName(Class'NWindow.UIAPI_TEXTBOX'.static.GetText((m_WindowName_ClanMemberInfoWnd $ ".Clan1_CurrentSelectedMemberName")), Class'NWindow.UIAPI_EDITBOX'.static.GetString((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameWnd.Clan1_ChangeNameTextEditbox")));
		Class'NWindow.UIAPI_EDITBOX'.static.SetString((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameWnd.Clan1_ChangeNameTextEditbox"), "");
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameWnd"));
		RecallCurrentMemberInfo();
	}
	else if((strID == "Clan1_ChangeNameDeleteBtn"))
	{
		RequestClanChangeNickName(Class'NWindow.UIAPI_TEXTBOX'.static.GetText((m_WindowName_ClanMemberInfoWnd $ ".Clan1_CurrentSelectedMemberName")), "");
		Class'NWindow.UIAPI_EDITBOX'.static.SetString((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameWnd.Clan1_ChangeNameTextEditbox"), "");
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameWnd"));
		RecallCurrentMemberInfo();
	}
	else if((strID == "Clan1_ChangeMemberGradeAssignBtn"))
	{
		if((Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeNameWnd.Clan1_MemberGradeList")) < 5))
		{
			RequestClanChangeGrade(Class'NWindow.UIAPI_TEXTBOX'.static.GetText((m_WindowName_ClanMemberInfoWnd $ ".Clan1_CurrentSelectedMemberName")), (Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeNameWnd.Clan1_MemberGradeList")) + 1));
		}
		else
		{
			RequestClanChangeGrade(Class'NWindow.UIAPI_TEXTBOX'.static.GetText((m_WindowName_ClanMemberInfoWnd $ ".Clan1_CurrentSelectedMemberName")), getCurrentGradebyClanType());
		}
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeNameWnd"));
		RecallCurrentMemberInfo();
	}
	else if((strID == "Clan1_Cancel1"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameWnd"));
	}
	else if((strID == "Clan1_Cancel2"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeNameWnd"));
	}
	else if((strID == "Clan7_RegEmbBtn"))
	{
		HandleBtnClickClan7_RegEmbBtn();
	}
	else if((strID == "Clan7_RmEmbBtn"))
	{
		API_RequestClanUnregisterCrestByPledgeID();
		scrollTesterV._SetSelect(-1);
		if(DialogIsMineCheck())
		{
			Class'InterfaceClassic.DialogBox'.static.Inst().HideDialog();
		}
		FileRegisterWndHide();
	}
	else if((strID == "Clan1_OKBtn"))
	{
		HideClanWindow();
	}
	else if((strID == "Clan2_OKBtn"))
	{
		SetState(ClanMemberInfoState);
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
	else if((strID == "ClanEnemy_OKBtn"))
	{
		HideClanWindow();
	}
	else if((strID == "Clan5_ManageBtn"))
	{
		EditAuthGrade();
	}
	else if((strID == "Clan6_ApplyBtn"))
	{
		ApplyEditGrade();
		SetState(ClanAuthManageWndState);
	}
	else if((strID == "Clan6_CancelBtn"))
	{
		SetState(ClanAuthManageWndState);
	}
	else if((strID == "Clan1_NobCancel1"))
	{
		HideClanWindow();
	}
	else if((strID == "Clan1_ChangeNameDeleteNobBtn"))
	{
		RequestClanChangeNickName(clanWndClassicScript.m_myName, "");
	}
	else if((strID == "ClanQuitBtn"))
	{
		RequestClanLeave(clanWndClassicScript.m_clanName, clanWndClassicScript.m_myClanType);
	}
	return;
}

event OnClickCheckBox(string CheckBoxID)
{
	HandleOnClickCheckBoxClanAuthEditWnd(CheckBoxID);
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
		case 350:
			HandleClanAuthGradeList(a_Param);
			break;
		case 360:
			HandleCrestChange(a_Param);
		case 430:
			HandleClanMemberInfo(a_Param);
			break;
		case 370:
			HandleClanAuth(a_Param);
			break;
		case 380:
			HandleClanAuthMember(a_Param);
			break;
		case 160:
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_Windowname);
			break;
		default:
			break;
	}
	return;
}

event OnSetFocus(WindowHandle wndHandle, bool bFocused)
{
	m_hOwnerWnd.GetParentWindowHandle().GetScript().OnSetFocus(wndHandle, bFocused);
	return;
}

function SetState(TYPE_SUBMENU_STATE Type)
{
	HideAll();
	switch(Type)
	{
		case ClanMemberInfoState:
			SetState_ClanMemberInfoState();
			break;
		case ClanMemberAuthState:
			SetState_ClanMemberAuthState();
			break;
		case ClanAuthManageWndState:
			SetState_ClanAuthManageWndState();
			break;
		case ClanEmblemManageWndState:
			SetState_ClanEmblemManageWndState();
			break;
		case ClanAuthEditWndState:
			SetState_ClanAuthEditWndState();
			break;
		case non:
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_Windowname);
			break;
		default:
			break;
	}
	CurrentState = Type;
	if((int(CurrentState) != 0))
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_Windowname);
	}
	Me.SetFocus();
	return;
}

function SetState_ClanMemberInfoState()
{
	clanWndClassicScript.clanSubInfoContainerScr.RequestCurrentSelectedClanMemberInfo();
	Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((m_Windowname $ ".ClanMemberInfoWnd"));
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameWnd"));
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeNameWnd"));
	return;
}

function SetState_ClanMemberAuthState()
{
	local int i;

	clanWndClassicScript.clanSubInfoContainerScr.RequestCurrentSelectedClanMemberAuth();
	Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName_ClanMemberAuthWnd);
	i = 0;
	while((i <= 10))
	{
		Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(((m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check1") $ Int2Str2(i)), true);
		++i;
	}
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(((m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check1") $ Int2Str2(24)), true);
	i = 0;
	while((i <= 5))
	{
		Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(((m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check20") $ string(i)), true);
		++i;
	}
	i = 0;
	while((i <= 8))
	{
		Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(((m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check30") $ string(i)), true);
		++i;
	}
	return;
}

function SetState_ClanAuthManageWndState()
{
	Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName_ClanAuthManageWnd);
	return;
}

function SetState_ClanEmblemManageWndState()
{
	Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName_ClanEmblemManageWnd);
	InitScrollPanel();
	scrollTesterV._SetSelect(-1);
	return;
}

function SetState_ClanAuthEditWndState()
{
	Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName_ClanAuthEditWnd);
	return;
}

function InitClanEmbleManageWndState()
{
	local string string1, string2;

	string1 = Left(GetSystemMessage(211), 23);
	string2 = Right(GetSystemMessage(211), (Len(GetSystemMessage(211)) - 23));
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_WindowName_ClanEmblemManageWnd $ ".Clan7_ManageEmb1Text1"), string1);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_WindowName_ClanEmblemManageWnd $ ".Clan7_ManageEmb1Text2"), string2);
	return;
}

function HandleCrestChange(string param)
{
	if((int(CurrentState) == 4))
	{
		Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTextureWithClanCrest((m_Windowname $ ".ClanCrestTextureCtrl"), clanWndClassicScript.m_clanID);
	}
	return;
}

function HandleBtnClickClan7_RegEmbBtn()
{
	local array<string> fileextarr;

	if((Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("FileRegisterWnd") == false))
	{
		fileextarr.Length = 1;
		fileextarr[0] = "bmp";
		ClearFileRegisterWndFileExt();
		AddFileRegisterWndFileExt(GetSystemString(2811), fileextarr);
		FileRegisterWndShow(FH_PLEDGE_CREST_UPLOAD);
		if(DialogIsMineCheck())
		{
			Class'InterfaceClassic.DialogBox'.static.Inst().HideDialog();
		}
		scrollTesterV._SetSelect(-1);
	}
	else
	{
		FileRegisterWndHide();
	}
	return;
}

function int GetSelectedPresetEmblemID()
{
	local array<PledgeCrestPresetUIData> presetDatas;
	local int Id;

	API_GetPledgeCrestPresetData(presetDatas);
	Id = presetDatas[scrollTesterV._GetSelectedIndex()].Id;
	if((Id == 0))
	{
		return ((2000000 + scrollTesterV._GetSelectedIndex()) + 1);
	}
	return presetDatas[scrollTesterV._GetSelectedIndex()].Id;
}

function string GetCrestTexName(int itemIndex)
{
	local array<PledgeCrestPresetUIData> presetDatas;
	local string TexName;

	API_GetPledgeCrestPresetData(presetDatas);
	if((itemIndex < presetDatas.Length))
	{
		TexName = presetDatas[itemIndex].CrestTexName;
	}
	if((TexName == ""))
	{
		TexName = ("L2UI_EPIC.ClanWnd.Preset" $ string((itemIndex + 1)));
	}
	return TexName;
}

function HandleDelegateOnItemRenderer(string itemRendererID, int rendererIndex, int itemIndex)
{
	if((itemIndex >= scrollTesterV._GetItemNumTotal()))
	{
		GetTextureHandle((itemRendererID $ ".emblem")).HideWindow();
	}
	else
	{
		GetTextureHandle((itemRendererID $ ".emblem")).ShowWindow();
		GetTextureHandle((itemRendererID $ ".emblem")).SetTexture(GetCrestTexName(itemIndex));
		GetTextureHandle((itemRendererID $ ".emblem")).SetUV(0, 4);
	}
	return;
}

function HandleDelegateOnRenderClickV(string BTNID, int rendererIndex, int itemIndex)
{
	FileRegisterWndHide();
	DialogSetID(77668899);
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(13802));
	Class'InterfaceClassic.DialogBox'.static.Inst().AnchorToOwner(-320, -4);
	Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
	Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnHide = HandleDialogHide;
	Class'InterfaceClassic.DialogBox'.static.Inst().SetReservedInt(GetSelectedPresetEmblemID());
	return;
}

function HandleDialogHide()
{
	Debug(" ------ HandleDialogHide ");
	scrollTesterV._SetSelect(-1);
	return;
}

function HandleDialogOK()
{
	Debug(("OKOKOK" @ string(Class'InterfaceClassic.DialogBox'.static.Inst().GetReservedInt())));
	API_RequestClanRegisterCrestPreset(Class'InterfaceClassic.DialogBox'.static.Inst().GetReservedInt());
	return;
}

function HandleClanAuthGradeList(string a_Param)
{
	local int Count, Id, members, i;
	local LVDataRecord Record;
	local LVData Data;

	Record.LVDataList.Length = 2;
	m_hClanDrawerWndClan5_AuthListCtrl.DeleteAllItem();
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
		m_hClanDrawerWndClan5_AuthListCtrl.InsertRecord(Record);
		++i;
	}
	m_hClanDrawerWndClan5_AuthListCtrl.SetSelectedIndex(0, true);
	return;
}

function HandleOnClickCheckBoxClanAuthEditWnd(string CheckBoxID)
{
	local bool checkState;
	local int i;
	local string CheckboxName, CheckboxNum, checkBoxGroupNum;
	local int totalNum;

	CheckboxName = Left(CheckBoxID, 12);
	CheckboxNum = Right(CheckBoxID, 2);
	checkBoxGroupNum = Right(CheckboxName, 1);
	switch(checkBoxGroupNum)
	{
		case "1":
			totalNum = 10;
			break;
		case "2":
			totalNum = 5;
			break;
		case "3":
			totalNum = 8;
			break;
		default:
			break;
	}
	if((CheckboxNum == "00"))
	{
		checkState = Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked(((m_WindowName_ClanAuthEditWnd $ ".") $ CheckBoxID));
		i = 0;
		while((i <= totalNum))
		{
			Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((((m_WindowName_ClanAuthEditWnd $ ".") $ CheckboxName) $ Int2Str2(i)), checkState);
			++i;
		}
		if((checkBoxGroupNum == "1"))
		{
			Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((((m_WindowName_ClanAuthEditWnd $ ".") $ CheckboxName) $ Int2Str2(24)), checkState);
		}
	}
	else
	{
		Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((((m_WindowName_ClanAuthEditWnd $ ".") $ CheckboxName) $ "00"), count_all_check(checkBoxGroupNum, totalNum, 6));
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
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_WindowName_ClanAuthEditWnd $ ".Clan6_CurrentSelectedRankName"), (GetStringByGradeID(gradeID) $ GetSystemString(1376)));
	Index = 1;
	i = 1;
	while((i <= 10))
	{
		Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check1") $ Int2Str2(i)), bool(powers[Index++]));
		++i;
	}
	Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check1") $ Int2Str2(24)), bool(powers[24]));
	i = 1;
	while((i <= 5))
	{
		Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check20") $ string(i)), bool(powers[Index++]));
		++i;
	}
	i = 1;
	while((i <= 8))
	{
		Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check30") $ string(i)), bool(powers[Index++]));
		++i;
	}
	Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check100"), count_all_check("1", 10, 6));
	Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check200"), count_all_check("2", 5, 6));
	Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check300"), count_all_check("3", 8, 6));
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

function disableAcademyAuth()
{
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check100"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check101"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check102"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check106"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check104"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check105"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check107"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check124"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check200"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check203"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check204"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check205"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check300"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check303"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check305"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check306"), true);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check308"), true);
	return;
}

function resetAcademyAuth()
{
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check100"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check101"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check102"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check106"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check104"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check105"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check107"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check124"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check200"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check203"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check204"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check205"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check300"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check303"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check305"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check306"), false);
	Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check308"), false);
	return;
}

function RecallCurrentMemberInfo()
{
	SetState(ClanMemberInfoState);
	return;
}

function HandleClanMemberInfo(string a_Param)
{
	local string nickname;
	local int gradeID, nNickColor;
	local CustomTooltip cTooltip;

	ParseInt(a_Param, "ClanType", m_clanType);
	ParseString(a_Param, "Name", m_currentName);
	ParseString(a_Param, "NickName", nickname);
	ParseInt(a_Param, "GradeID", gradeID);
	ParseInt(a_Param, "NickColor", nNickColor);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_WindowName_ClanMemberInfoWnd $ ".Clan1_CurrentSelectedMemberName"), m_currentName);
	GetTextBoxHandle((m_WindowName_ClanMemberInfoWnd $ ".Clan1_CurrentSelectedMemberSName")).SetFormatString(nickname);
	GetTextBoxHandle((m_WindowName_ClanMemberInfoWnd $ ".Clan1_CurrentSelectedMemberSName")).SetTextColor(getInstanceL2Util().IntToColor(nNickColor));
	addToolTipDrawList(cTooltip, addDrawItemFormatText(nickname, getInstanceL2Util().IntToColor(nNickColor), ""));
	GetTextBoxHandle((m_WindowName_ClanMemberInfoWnd $ ".Clan1_CurrentSelectedMemberSName")).SetTooltipCustomType(cTooltip);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_WindowName_ClanMemberInfoWnd $ ".Clan1_CurrentSelectedMemberGrade"), GetStringByGradeID(gradeID));
	if((clanWndClassicScript.m_CurrentclanMasterReal == m_currentName))
	{
		if((clanWndClassicScript.m_currentShowIndex == 0))
		{
			Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_WindowName_ClanMemberInfoWnd $ ".Clan1_CurrentSelectedMemberGrade"), GetSystemString(342));
		}
	}
	clanWndClassicScript.resetBtnShowHide();
	CheckandCompareMyNameandDisableThings();
	return;
}

function CheckandCompareMyNameandDisableThings()
{
	local UserInfo UserInfo;

	GetPlayerInfo(UserInfo);
	m_myName = UserInfo.Name;
	if((clanWndClassicScript.m_bClanMaster > 0))
	{
		Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeBanishBtn"));
	}
	else
	{
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeBanishBtn"));
		Proc_AuthValidation();
		if((clanWndClassicScript.GetClanTypeFromIndex(clanWndClassicScript.m_currentShowIndex) < clanWndClassicScript.m_myClanType))
		{
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeBanishBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeBtn"));
			if((m_clanType != -1))
			{
				Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameBtn"));
			}
		}
		if((clanWndClassicScript.m_myClanType > 1))
		{
			if((clanWndClassicScript.GetClanTypeFromIndex(clanWndClassicScript.m_currentShowIndex) != 0))
			{
				if(((clanWndClassicScript.m_myClanType - clanWndClassicScript.GetClanTypeFromIndex(clanWndClassicScript.m_currentShowIndex)) == 1))
				{
					Proc_AuthValidation();
				}
				if(((clanWndClassicScript.m_myClanType - clanWndClassicScript.GetClanTypeFromIndex(clanWndClassicScript.m_currentShowIndex)) == 1000))
				{
					Proc_AuthValidation();
				}
				if(((clanWndClassicScript.m_myClanType - clanWndClassicScript.GetClanTypeFromIndex(clanWndClassicScript.m_currentShowIndex)) == 100))
				{
					Proc_AuthValidation();
				}
				if(((clanWndClassicScript.m_myClanType - clanWndClassicScript.GetClanTypeFromIndex(clanWndClassicScript.m_currentShowIndex)) == 999))
				{
					Proc_AuthValidation();
				}
				if(((clanWndClassicScript.m_myClanType - clanWndClassicScript.GetClanTypeFromIndex(clanWndClassicScript.m_currentShowIndex)) == 1001))
				{
					Proc_AuthValidation();
				}
			}
		}
		if((clanWndClassicScript.m_CurrentclanMasterReal == m_currentName))
		{
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeBanishBtn"));
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameBtn"));
		}
	}
	if((m_currentName == m_myName))
	{
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeBtn"));
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeBanishBtn"));
	}
	if((m_clanType == -1))
	{
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeBtn"));
	}
	return;
}

function Proc_AuthValidation()
{
	if((clanWndClassicScript.m_bNickName == 0))
	{
		if(((clanWndClassicScript.G_IamHero == true) || (clanWndClassicScript.G_IamNobless > 0)))
		{
			Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameBtn"));
		}
		else
		{
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameBtn"));
		}
	}
	else
	{
		Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameBtn"));
	}
	if((clanWndClassicScript.m_bGrade == 0))
	{
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeBtn"));
	}
	else
	{
		Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeBtn"));
	}
	if((clanWndClassicScript.m_bOustMember == 0))
	{
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeBanishBtn"));
	}
	else
	{
		Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeBanishBtn"));
	}
	return;
}

function InitializeGradeComboBox()
{
	local int i;

	Class'NWindow.UIAPI_COMBOBOX'.static.Clear((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeNameWnd.Clan1_MemberGradeList"));
	i = 1;
	while((i < 6))
	{
		Class'NWindow.UIAPI_COMBOBOX'.static.AddString((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeNameWnd.Clan1_MemberGradeList"), GetStringByGradeID(i));
		++i;
	}
	Class'NWindow.UIAPI_COMBOBOX'.static.AddString((m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeNameWnd.Clan1_MemberGradeList"), GetSystemString(1451));
	return;
}

function HandleClanAuthMember(string a_Param)
{
	local int gradeID;
	local string sName;
	local array<int> powers;
	local int i, Index;

	ParseInt(a_Param, "Grade", gradeID);
	ParseString(a_Param, "Name", sName);
	if((clanWndClassicScript.m_CurrentclanMasterReal == sName))
	{
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_WindowName_ClanMemberAuthWnd $ ".Clan2_CurrentSelectedMemberName"), ((sName @ "-") @ GetSystemString(342)));
		i = 0;
		while((i <= 10))
		{
			Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(((m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check1") $ Int2Str2(i)), true);
			++i;
		}
		Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(((m_WindowName_ClanAuthEditWnd $ ".Clan2_Check1") $ Int2Str2(24)), true);
		i = 0;
		while((i <= 5))
		{
			Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(((m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check20") $ string(i)), true);
			++i;
		}
		i = 0;
		while((i <= 8))
		{
			Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(((m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check30") $ string(i)), true);
			++i;
		}
	}
	else
	{
		powers.Length = 32;
		i = 0;
		while((i < 32))
		{
			ParseInt(a_Param, ("PowerValue" $ string(i)), powers[i]);
			++i;
		}
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_WindowName_ClanMemberAuthWnd $ ".Clan2_CurrentSelectedMemberName"), ((sName @ "-") @ GetStringByGradeID(gradeID)));
		Index = 1;
		i = 1;
		while((i <= 10))
		{
			Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(((m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check1") $ Int2Str2(i)), bool(powers[Index++]));
			++i;
		}
		Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(((m_WindowName_ClanAuthEditWnd $ ".Clan2_Check1") $ Int2Str2(24)), bool(powers[24]));
		i = 1;
		while((i <= 5))
		{
			Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(((m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check20") $ string(i)), bool(powers[Index++]));
			++i;
		}
		i = 1;
		while((i <= 8))
		{
			Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(((m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check30") $ string(i)), bool(powers[Index++]));
			++i;
		}
	}
	Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check100"), count_all_check("1", 10, 2));
	Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check200"), count_all_check("2", 5, 2));
	Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check300"), count_all_check("3", 8, 2));
	if((clanWndClassicScript.m_myName == sName))
	{
		if((Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked((m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check101")) == true))
		{
			clanWndClassicScript.m_bJoin = 1;
		}
		else
		{
			clanWndClassicScript.m_bJoin = 0;
		}
		if((Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked((m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check107")) == true))
		{
			clanWndClassicScript.m_bCrest = 1;
		}
		else
		{
			clanWndClassicScript.m_bCrest = 0;
		}
		clanWndClassicScript.resetBtnShowHide();
	}
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
		if(Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked(((m_WindowName_ClanMemberAuthWnd $ ".Clan6_Check1") $ Int2Str2(i))))
		{
			powers[Index] = 1;
		}
		++Index;
		++i;
	}
	if(Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked(((m_WindowName_ClanAuthEditWnd $ ".Clan6_Check1") $ Int2Str2(24))))
	{
		powers[24] = 1;
	}
	i = 1;
	while((i <= 5))
	{
		if(Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked(((m_WindowName_ClanMemberAuthWnd $ ".Clan6_Check20") $ string(i))))
		{
			powers[Index] = 1;
		}
		++Index;
		++i;
	}
	i = 1;
	while((i <= 8))
	{
		if(Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked(((m_WindowName_ClanMemberAuthWnd $ ".Clan6_Check30") $ string(i))))
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
		SetState(ClanAuthEditWndState);
	}
	else
	{
		SetState(ClanAuthManageWndState);
	}
	return;
}

function string GetEllipsisString(string Str, int MaxWidth)
{
	local string fixedString;
	local int nWidth, nHeight, textWidth;

	textWidth = MaxWidth;
	GetTextSizeDefault((Str $ "..."), nWidth, nHeight);
	if((nWidth < textWidth))
	{
		return Str;
	}
	fixedString = DivideStringWithWidth(Str, textWidth);
	if((fixedString != Str))
	{
		fixedString = (fixedString $ "...");
	}
	return fixedString;
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

function bool count_all_check(string numString, int totalNum, int contentID)
{
	local int i;
	local string WindowName, CheckBoxPath;

	switch(contentID)
	{
		case 2:
			WindowName = m_WindowName_ClanMemberAuthWnd;
			break;
		case 6:
			WindowName = m_WindowName_ClanAuthEditWnd;
			break;
		default:
			break;
	}
	i = 1;
	while((i <= totalNum))
	{
		CheckBoxPath = (((((WindowName $ ".Clan") $ string(contentID)) $ "_Check") $ numString) $ Int2Str2(i));
		if(!GetWindowHandle(CheckBoxPath).IsShowWindow())
		{
			++i;
			continue;
		}
		if(Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked(CheckBoxPath))
		{
			return true;
		}
		++i;
	}
	if((numString == "1"))
	{
		CheckBoxPath = (((((WindowName $ ".Clan") $ string(contentID)) $ "_Check") $ numString) $ Int2Str2(24));
		if(Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked(CheckBoxPath))
		{
			return true;
		}
	}
	return false;
}

function HideClanWindow()
{
	SetState(non);
	return;
}

function HideAll()
{
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName_ClanMemberAuthWnd);
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName_ClanMemberInfoWnd);
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName_ClanAuthManageWnd);
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName_ClanAuthEditWnd);
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName_ClanEmblemManageWnd);
	return;
}

function string Int2Str2(int i)
{
	if((i < 10))
	{
		return ("0" $ string(i));
	}
	return string(i);
}

function bool ToggleWindowByType(TYPE_SUBMENU_STATE Type)
{
	local bool isWindowShow;

	if(!ChkDrawerState(Type))
	{
		SetState(Type);
		isWindowShow = true;
	}
	else
	{
		SetState(non);
		isWindowShow = false;
	}
	return isWindowShow;
}

function bool ChkDrawerState(TYPE_SUBMENU_STATE Type)
{
	return (int(CurrentState) == int(Type));
}

function API_GetPledgeCrestPresetData(out array<PledgeCrestPresetUIData> o_arrData)
{
	GetPledgeCrestPresetData(o_arrData);
	return;
}

function API_RequestClanRegisterCrestPreset(int presetID)
{
	RequestClanRegisterCrestPreset(presetID);
	return;
}

function API_RequestClanUnregisterCrestByPledgeID()
{
	RequestClanUnregisterCrestByPledgeID(clanWndClassicScript.m_clanID);
	return;
}

function bool DialogIsMineCheck()
{
	if(DialogIsMine())
	{
		return true;
	}
}
