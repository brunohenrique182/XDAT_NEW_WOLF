class UISkillToolWnd extends UICommonAPI;

const FINDING_NUM_ONTICK = 1000;

var UIControlTextInput uicontrolFindTextInputScr;
var UIControlTextInput uicontrolExecptionTextInputScr;
var RichListCtrlHandle skillListCtrl;
var int lastSkillClassiD;
var int lastSkillLevel;
var int lastSubSkillInfo;
var bool bFinding;
var ComboBoxHandle SkillOperateTypeComboBox;
var ComboBoxHandle SkillGradeComboBox;
var ComboBoxHandle SkillIconTypeComboBox;
var TextBoxHandle m_hTbTotal;
var TextBoxHandle m_hTbFoundResultCnt;
var CheckBoxHandle m_chkEnchantOnly;
var CheckBoxHandle m_chkEnchanHide;
var CheckBoxHandle m_chkLevelHide;
var CheckBoxHandle m_chkUseSkillAPI;
var int findOnTickNum;
var array<int> iconTypes;
var int lastIconTypeReserved;
var bool bNewIconType;
var bool bFindStop;
//var delegate<DelegateSortIconType> __DelegateSortIconType__Delegate;

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

function SetCheckBoxs()
{
	local int B;

	GetINIBool(m_hOwnerWnd.m_WindowNameWithFullPath, "chkEnchantOnly", B, "l2.ini");
	m_chkEnchantOnly.SetCheck((B == 1));
	GetINIBool(m_hOwnerWnd.m_WindowNameWithFullPath, "chkEnchanHide", B, "l2.ini");
	m_chkEnchanHide.SetCheck((B == 1));
	GetINIBool(m_hOwnerWnd.m_WindowNameWithFullPath, "chkLevelHide", B, "l2.ini");
	m_chkLevelHide.SetCheck((B == 1));
	return;
}

function Initialize()
{
	InitUIControlTextInput();
	skillListCtrl = GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SkillListCtrl"));
	SkillOperateTypeComboBox = GetComboBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SkillOperateTypeComboBox"));
	SkillOperateTypeComboBox.AddStringWithReserved("OperateType", -1);
	m_chkEnchantOnly = GetCheckBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".chkEnchantOnly"));
	m_chkEnchanHide = GetCheckBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".chkEnchanHide"));
	m_chkLevelHide = GetCheckBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".chkLevelHide"));
	m_chkUseSkillAPI = GetCheckBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".chkUseSkillAPI"));
	SetCheckBoxs();
	SkillOperateTypeComboBox.AddStringWithReserved("0", 0);
	SkillOperateTypeComboBox.AddStringWithReserved("1", 1);
	SkillOperateTypeComboBox.AddStringWithReserved("2", 2);
	SkillOperateTypeComboBox.AddStringWithReserved("3", 3);
	SkillOperateTypeComboBox.AddStringWithReserved("4", 4);
	SkillOperateTypeComboBox.AddStringWithReserved("5", 5);
	SkillOperateTypeComboBox.AddStringWithReserved("6", 6);
	SkillIconTypeComboBox = GetComboBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SkillIconTypeComboBox"));
	SkillIconTypeComboBox.AddStringWithReserved("IconType", -1);
	SkillGradeComboBox = GetComboBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SkillGradeComboBox"));
	SkillGradeComboBox.AddStringWithReserved("Grade", -1);
	SkillGradeComboBox.AddStringWithReserved("0", 0);
	SkillGradeComboBox.AddStringWithReserved("1", 1);
	SkillGradeComboBox.AddStringWithReserved("2", 2);
	SkillGradeComboBox.AddStringWithReserved("3", 3);
	SkillGradeComboBox.AddStringWithReserved("4", 4);
	SkillGradeComboBox.AddStringWithReserved("5", 5);
	SkillGradeComboBox.AddStringWithReserved("6", 6);
	m_hTbTotal = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tbTotal"));
	m_hTbFoundResultCnt = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tbFoundResultCnt"));
	skillListCtrl.SetSelectedSelTooltip(false);
	skillListCtrl.SetAppearTooltipAtMouseX(true);
	m_chkUseSkillAPI.SetTooltipText("리스트 우클릭 시 use_skill 빌드커맨드 대신 ExecuteSkill API 를 사용하게 합니다");  // EN?: Use ExecuteSkill API instead of use_skill build command when right-clicking the list
	return;
}

function InitUIControlTextInput()
{
	uicontrolFindTextInputScr = Class'InterfaceClassic.UIControlTextInput'.static.InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".FindTextInput")));
	uicontrolFindTextInputScr.SetDefaultString(GetSystemString(2507));
	uicontrolFindTextInputScr.DelegateESCKey = DelegateESCKey;
	uicontrolFindTextInputScr.DelegateOnCompleteEditBox = DelegateOnCompleteEditBox;
	uicontrolFindTextInputScr.DelegateOnClear = DelegateOnClear;
	uicontrolFindTextInputScr.SetEdtiable(true);
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".FindTextInput")).SetFocus();
	uicontrolExecptionTextInputScr = Class'InterfaceClassic.UIControlTextInput'.static.InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".execptionTextInput")));
	uicontrolExecptionTextInputScr.SetDefaultString("제외단어");  // EN?: Excluded Words
	uicontrolExecptionTextInputScr.DelegateESCKey = DelegateESCKey;
	uicontrolExecptionTextInputScr.DelegateOnCompleteEditBox = DelegateOnCompleteEditBox;
	uicontrolExecptionTextInputScr.DelegateOnClear = DelegateOnClear;
	uicontrolExecptionTextInputScr.SetEdtiable(true);
	return;
}

function DelegateESCKey()
{
	OnReceivedCloseUI();
	return;
}

function DelegateOnCompleteEditBox(string Text)
{
	NewFinding();
	return;
}

function DelegateOnClear()
{
	NewFinding();
	return;
}

event OnComboBoxItemSelected(string sName, int Index)
{
	NewFinding();
	return;
}

event OnShow()
{
	setWindowTitleByString("UIPowerTools [ SkillSearchTool ]");
	m_hOwnerWnd.SetFocus();
	SetListNum();
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "searchSkillBtn":
			NewFinding();
			break;
		default:
			break;
	}
	return;
}

event OnClickCheckBox(string strID)
{
	SetINIBool(m_hOwnerWnd.m_WindowNameWithFullPath, strID, GetCheckBoxHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ strID)).IsChecked(), "l2.ini");
	NewFinding();
	return;
}

event OnTick()
{
	MeDisableTick();
	FindAllSkill();
	return;
}

event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	m_hOwnerWnd.HideWindow();
	return;
}

event OnDBClickListCtrlRecord(string ListCtrlID)
{
	local RichListCtrlRowData rowData;

	skillListCtrl.GetSelectedRec(rowData);
	ExecuteCommand(((("//setskill" @ string(rowData.nReserved1)) @ string(rowData.nReserved2)) @ string(rowData.nReserved3)));
	return;
}

event OnRClickListCtrlRecord(string strID)
{
	local RichListCtrlRowData rowData;
	local UserInfo User;
	local string TargetName, ShowMsg;

	if(GetTargetInfo(User))
	{
		TargetName = User.Name;
	}
	else
	{
		TargetName = GetSystemString(27);
	}
	skillListCtrl.GetSelectedRec(rowData);
	ShowMsg = ((((((GetSystemString(14391) @ ":") @ rowData.cellDataList[0].szData) $ ",") @ GetSystemString(13624)) @ ":") @ TargetName);
	Class'InterfaceClassic.L2Util'.static.Inst().showGfxScreenMessage(ShowMsg);
	if(m_chkUseSkillAPI.IsChecked())
	{
		Class'NWindow.UIDATA_PAWNVIEWER'.static.ExecuteSkill(int(rowData.nReserved1), int(rowData.nReserved2), int(rowData.nReserved3));
	}
	else
	{
		ExecuteCommand(((("//use_skill" @ string(rowData.nReserved1)) @ string(rowData.nReserved2)) @ string(rowData.nReserved3)));
	}
	OnDBClickListCtrlRecord(strID);
	return;
}

event OnRollOverListCtrlRecord(string strID, int Index)
{
	HandleSetDescWindow(Index);
	return;
}

function HandleSetDescWindow(int Index)
{
	local ItemDescWnd itemDescWndScr;
	local string HtmlString;
	local RichListCtrlRowData overRec;
	local GMFindTreeWnd gMFindTreeWndScr;

	gMFindTreeWndScr = GMFindTreeWnd(GetScript("GMFindTreeWnd"));
	itemDescWndScr = ItemDescWnd(GetScript("ItemDescWnd"));
	itemDescWndScr.setWindowTitleByString(GetSystemString(14159));
	if(!itemDescWndScr.m_hOwnerWnd.IsShowWindow())
	{
		return;
	}
	skillListCtrl.GetRec(Index, overRec);
	HtmlString = gMFindTreeWndScr._GetHtmlDetaiInfoSkill(int(overRec.nReserved1), int(overRec.nReserved2), int(overRec.nReserved3));
	HtmlString = (gMFindTreeWndScr._HtmlMakeTitleNDesc("ID", string(overRec.nReserved1)) $ HtmlString);
	HtmlString = gMFindTreeWndScr._MakeHtmlTable(HtmlString);
	HtmlString = ((gMFindTreeWndScr._HtmlQuestnameTableAdd(overRec.cellDataList[0].szData) $ "</br>") $ HtmlString);
	itemDescWndScr._LoadHtmlFromString(htmlSetHtmlStart(HtmlString));
	return;
}

function _Show(string findString)
{
	m_hOwnerWnd.ShowWindow();
	uicontrolFindTextInputScr.SetString(findString);
	NewFinding();
	return;
}

function _Toggle()
{
	if(m_hOwnerWnd.IsShowWindow())
	{
		m_hOwnerWnd.HideWindow();
	}
	else
	{
		m_hOwnerWnd.ShowWindow();
	}
	return;
}

function InsertSubLevelInfos(array<int> subLevelInfos)
{
	local int i;

	i = 1;
	while((i < subLevelInfos.Length))
	{
		lastSubSkillInfo = subLevelInfos[i];
		Class'NWindow.UIDATA_SKILL'.static.GetNextID();
		if(!m_chkEnchanHide.IsChecked())
		{
			InsertRecordFindTreeList();
		}
		findOnTickNum++;
		i++;
	}
	lastSubSkillInfo = 0;
	return;
}

function _SetFindStop()
{
	bFindStop = true;
	return;
}

function bool IsFindStop()
{
	if(bFindStop)
	{
		bFindStop = false;
		return true;
	}
	return false;
}

function bool FindAllSkill()
{
	local ItemID cID;
	local int i, findingNum;
	local array<int> subLevelInfos;

	if(IsFindStop())
	{
		SetListFindingStop();
		return false;
	}
	GMFindTreeWnd(GetScript("GMFindTreeWnd"))._SetFindStop();
	if(!bFinding)
	{
		cID = Class'NWindow.UIDATA_SKILL'.static.GetFirstID();
		lastSkillClassiD = cID.ClassID;
		lastSkillLevel = 1;
		InsertRecordFindTreeList();
	}
	else
	{
		cID.ClassID = lastSkillClassiD;
	}
	bFinding = true;
	if(IsL2NetLoginState())
	{
		findingNum = 1000;
	}
	else
	{
		findingNum = Class'NWindow.UIDATA_SKILL'.static.GetDataCount();
	}
	i = 0;
	while((i < findingNum))
	{
		findOnTickNum++;
		if((GetSkillSubLevelList(lastSkillClassiD, lastSkillLevel, subLevelInfos) > 1))
		{
			InsertSubLevelInfos(subLevelInfos);
		}
		cID = Class'NWindow.UIDATA_SKILL'.static.GetNextID();
		if(!IsValidItemID(cID))
		{
			lastSkillClassiD = -1;
			bFinding = false;
			SetListNum();
			return false;
		}
		if((lastSkillClassiD != cID.ClassID))
		{
			lastSkillLevel = 1;
		}
		else
		{
			lastSkillLevel++;
		}
		lastSkillClassiD = cID.ClassID;
		InsertRecordFindTreeList();
		i++;
	}
	MeEnabmeTick();
	SetListFindingNum();
	return true;
}

function ClearFinding()
{
	findOnTickNum = -1;
	lastSkillClassiD = -1;
	bFindStop = false;
	bFinding = false;
	skillListCtrl.DeleteAllItem();
	return;
}

function InsertRecordFindTreeList()
{
	local string modifiedString;
	local RichListCtrlRowData rowData;
	local string findString, fullNameString, IconName;
	local SkillInfo sInfo;
	local ItemID cID;

	cID.ClassID = lastSkillClassiD;
	fullNameString = Class'NWindow.UIDATA_SKILL'.static.GetName(cID, lastSkillLevel, lastSubSkillInfo);
	IconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(cID, lastSkillLevel, lastSubSkillInfo);
	IconName = Caps(IconName);
	GetSkillInfo(cID.ClassID, lastSkillLevel, lastSubSkillInfo, sInfo);
	modifiedString = Substitute(fullNameString, " ", "", false);
	if((API_StringMatching(modifiedString, uicontrolExecptionTextInputScr.GetString()) != -1))
	{
		return;
	}
	findString = uicontrolFindTextInputScr.GetString();
	if((((findString != "") && (findString != string(cID.ClassID))) && (API_StringMatching(modifiedString, findString) == -1)))
	{
		return;
	}
	if((SkillOperateTypeComboBox.GetSelectedNum() > 0))
	{
		if((SkillOperateTypeComboBox.GetReserved(SkillOperateTypeComboBox.GetSelectedNum()) != sInfo.OperateType))
		{
			return;
		}
	}
	if((SkillOperateTypeComboBox.GetSelectedNum() > 0))
	{
		if((SkillOperateTypeComboBox.GetReserved(SkillOperateTypeComboBox.GetSelectedNum()) != sInfo.OperateType))
		{
			return;
		}
	}
	if((SkillGradeComboBox.GetSelectedNum() > 0))
	{
		if((SkillGradeComboBox.GetReserved(SkillGradeComboBox.GetSelectedNum()) != sInfo.Grade))
		{
			return;
		}
	}
	if((SkillIconTypeComboBox.GetSelectedNum() > 0))
	{
		if((SkillIconTypeComboBox.GetReserved(SkillIconTypeComboBox.GetSelectedNum()) != sInfo.IconType))
		{
			return;
		}
	}
	if(m_chkEnchantOnly.IsChecked())
	{
		if((lastSubSkillInfo == 0))
		{
			return;
		}
	}
	if(m_chkLevelHide.IsChecked())
	{
		if((lastSkillLevel > 1))
		{
			return;
		}
	}
	AddIconType(sInfo.IconType);
	rowData.cellDataList.Length = 4;
	AddRichListCtrlSkillBySkillInfo(rowData.cellDataList[0].drawitems, sInfo, 32, 32, 10);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, fullNameString, Class'InterfaceClassic.L2Util'.static.Inst().White, false, 5, 9);
	if(getInstanceUIData().GetIsClassicServer())
	{
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, "Lv", Class'InterfaceClassic.L2Util'.static.Inst().Yellow, false, 5);
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, string(lastSkillLevel), Class'InterfaceClassic.L2Util'.static.Inst().Yellow, false, 2);
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, "Lv", Class'InterfaceClassic.L2Util'.static.Inst().Gray, false, 5);
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, string(lastSkillLevel), Class'InterfaceClassic.L2Util'.static.Inst().Gold, false, 2);
	}
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, string(lastSkillLevel), Class'InterfaceClassic.L2Util'.static.Inst().White, false, 10);
	if((lastSubSkillInfo > 0))
	{
		AddRichListCtrlString(rowData.cellDataList[2].drawitems, string(lastSubSkillInfo), Class'InterfaceClassic.L2UIColor'.static.Inst().VIOLET01, false, 10);
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[2].drawitems, string(lastSubSkillInfo), Class'InterfaceClassic.L2Util'.static.Inst().Gray, false, 10);
	}
	AddRichListCtrlString(rowData.cellDataList[3].drawitems, string(lastSkillClassiD), Class'InterfaceClassic.L2UIColor'.static.Inst().White, false);
	rowData.cellDataList[1].nReserved1 = lastSkillLevel;
	rowData.nReserved1 = INT64(cID.ClassID);
	rowData.cellDataList[0].szData = fullNameString;
	rowData.cellDataList[1].szData = string(cID.ClassID);
	rowData.nReserved1 = INT64(lastSkillClassiD);
	rowData.nReserved2 = INT64(lastSkillLevel);
	rowData.nReserved3 = INT64(lastSubSkillInfo);
	skillListCtrl.InsertRecord(rowData);
	return;
}

function SetListNum()
{
	m_hTbTotal.SetText(GetSystemString(14135));
	m_hTbFoundResultCnt.SetText(string(skillListCtrl.GetRecordCount()));
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".findingIcon")).HideWindow();
	InsertIconTypes();
	return;
}

function SetListFindingNum()
{
	m_hTbTotal.SetText(GetSystemString(3513));
	m_hTbFoundResultCnt.SetText(string(findOnTickNum));
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".findingIcon")).ShowWindow();
	return;
}

function SetListFindingStop()
{
	m_hTbTotal.SetText("검색 중지");  // EN?: Stop Scan
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".findingIcon")).HideWindow();
	return;
}

function AddIconType(int IconType)
{
	local int i;

	i = 0;
	while((i < iconTypes.Length))
	{
		if((iconTypes[i] == IconType))
		{
			return;
		}
		i++;
	}
	bNewIconType = true;
	iconTypes[iconTypes.Length] = IconType;
	return;
}

function InsertIconTypes()
{
	local int i;

	if(!bNewIconType)
	{
		bNewIconType = false;
		return;
	}
	// iconTypes.Sort(DelegateSortIconType);   // array.Sort() unsupported by this compiler
	SkillIconTypeComboBox.Clear();
	SkillIconTypeComboBox.AddStringWithReserved("IconType", -1);
	i = 0;
	while((i < iconTypes.Length))
	{
		SkillIconTypeComboBox.AddStringWithReserved(getSkillTypeString(iconTypes[i]), iconTypes[i]);
		i++;
	}
	i = 0;
	while((i < iconTypes.Length))
	{
		if((lastIconTypeReserved == SkillIconTypeComboBox.GetReserved(i)))
		{
			SkillIconTypeComboBox.SetSelectedNum(i);
			return;
		}
		i++;
	}
	return;
}

delegate int DelegateSortIconType(int A, int B)
{
	if((A > B))
	{
		return -1;
	}
	return 0;
}

function NewFinding()
{
	lastIconTypeReserved = SkillIconTypeComboBox.GetReserved(SkillIconTypeComboBox.GetSelectedNum());
	ClearFinding();
	FindAllSkill();
	return;
}

function MeDisableTick()
{
	m_hOwnerWnd.DisableTick();
	return;
}

function MeEnabmeTick()
{
	m_hOwnerWnd.EnableTick();
	return;
}

function int API_StringMatching(string Str, string a_Param)
{
	if(StringMatching(Str, a_Param, " "))
	{
		return 1;
	}
	return -1;
}
