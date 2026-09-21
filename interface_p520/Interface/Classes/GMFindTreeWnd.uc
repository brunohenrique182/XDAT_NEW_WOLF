class GMFindTreeWnd extends UICommonAPI;

const ASK_SUMMON_NUMBER = 10000;
const SHOWLISTNUM_ONTICK_10 = 10;
const SHOWLISTNUM_ONTICK_500 = 3000;

enum EListType
{
	LISTTYPE_ITEM,                  // 0
	LISTTYPE_NPC,                   // 1
	LISTTYPE_QUEST,                 // 2
	LISTTYPE_SKILL,                 // 3
	LISTTYPE_CLASS,                 // 4
	LISTTYPE_SYSTEMSTRING,          // 5
	LISTTYPE_SYSTEMMESSAGE          // 6
};

var WindowHandle Me;
var string m_Windowname;
var bool bShow;
var ListCtrlHandle m_hFindTreeList;
var ComboBoxHandle m_hComboBox;
var ButtonHandle m_hBtnSummon;
var ButtonHandle m_hbtnDetailInfo;
var CheckBoxHandle m_checkbox64size;
var CheckBoxHandle m_ChkBoxLv1;
var TextBoxHandle m_hTbFoundResultCnt;
var TextBoxHandle m_hTbTotal;
var UIControlTextInput uicontrolFindTextInputScr;
var UIControlTextInput uicontrolExecptionTextInputScr;
var UIControlNumberInput SummonNumberTextInputScr;
var WindowHandle m_GMFindTreeWndItem;
var WindowHandle m_GMFindTreeWndSkill;
var int findOnTickCurrentID;
var int OnTickNum;
var int findOnTickNum;
var int showListNum_OnTick;
var int lastSkillClassiD;
var int SkillLevel;
var bool bFindStop;
var EListType curListType;

event OnRegisterEvent()
{
	RegisterEvent(1710);
	RegisterEvent(1720);
	return;
}

function SetCheckBoxs()
{
	local int B;

	GetINIBool(m_hOwnerWnd.m_WindowNameWithFullPath, "ChkBox64", B, "l2.ini");
	m_checkbox64size.SetCheck((B == 1));
	GetINIBool(m_hOwnerWnd.m_WindowNameWithFullPath, "ChkBoxLv1", B, "l2.ini");
	m_ChkBoxLv1.SetCheck((B == 1));
	SetWindowSize();
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	Me = GetWindowHandle(m_Windowname);
	m_hFindTreeList = GetListCtrlHandle((m_Windowname $ ".ListFindWnd"));
	m_checkbox64size = GetCheckBoxHandle((m_Windowname $ ".ChkBox64"));
	m_ChkBoxLv1 = GetCheckBoxHandle((m_Windowname $ ".ChkBoxLv1"));
	SetCheckBoxs();
	m_hTbFoundResultCnt = GetTextBoxHandle((m_Windowname $ ".tbFoundResultCnt"));
	m_hTbTotal = GetTextBoxHandle((m_Windowname $ ".tbTotal"));
	m_hComboBox = GetComboBoxHandle((m_Windowname $ ".ComboBox"));
	m_hBtnSummon = GetButtonHandle((m_Windowname $ ".btnSummon"));
	m_hbtnDetailInfo = GetButtonHandle((m_Windowname $ ".btnDetailInfo"));
	m_hFindTreeList.SetSelectedSelTooltip(false);
	m_hFindTreeList.SetAppearTooltipAtMouseX(true);
	bShow = false;
	FillOutComboBoxHandle();
	m_GMFindTreeWndItem = GetWindowHandle("GMFindTreeWndItem");
	m_GMFindTreeWndSkill = GetWindowHandle("GMFindTreeWndSkill");
	InitUIControlTextInput();
	ClearOnTickInfos();
	showListNum_OnTick = 10;
	return;
}

function InitUIControlTextInput()
{
	uicontrolFindTextInputScr = Class'Interface.UIControlTextInput'.static.InitScript(GetWindowHandle((m_Windowname $ ".FindTextInput")));
	uicontrolFindTextInputScr.SetDefaultString(GetSystemString(2507));
	uicontrolFindTextInputScr.DelegateESCKey = DelegateESCKey;
	uicontrolFindTextInputScr.DelegateOnCompleteEditBox = DelegateOnCompleteEditBox;
	uicontrolFindTextInputScr.DelegateOnClear = DelegateOnClearEditBox;
	uicontrolFindTextInputScr.DelegateOnChangeEdited = DelegateOnEditEditBox;
	uicontrolFindTextInputScr.DelegateOnKeyUP = DelegateOnKeyUP;
	uicontrolFindTextInputScr.SetEdtiable(true);
	uicontrolExecptionTextInputScr = Class'Interface.UIControlTextInput'.static.InitScript(GetWindowHandle((m_Windowname $ ".execptionTextInput")));
	uicontrolExecptionTextInputScr.SetDefaultString("제외단어");  // EN?: Excluded Words
	uicontrolExecptionTextInputScr.DelegateESCKey = DelegateESCKey;
	uicontrolExecptionTextInputScr.DelegateOnCompleteEditBox = DelegateOnCompleteEditBox;
	uicontrolExecptionTextInputScr.DelegateOnClear = DelegateOnClearEditBox;
	uicontrolExecptionTextInputScr.DelegateOnChangeEdited = DelegateOnEditEditBox;
	uicontrolExecptionTextInputScr.DelegateOnKeyUP = DelegateOnKeyUP;
	uicontrolExecptionTextInputScr.SetEdtiable(true);
	return;
}

function FillOutComboBoxHandle()
{
	m_hComboBox.Clear();
	m_hComboBox.AddStringWithReserved(GetSystemString(691), 0);
	m_hComboBox.AddStringWithReserved(GetSystemString(690), 1);
	m_hComboBox.AddStringWithReserved(GetSystemString(699), 2);
	m_hComboBox.AddStringWithReserved(GetSystemString(692), 3);
	m_hComboBox.AddStringWithReserved(GetSystemString(2290), 4);
	m_hComboBox.AddStringWithReserved("SystemString", 5);
	m_hComboBox.AddStringWithReserved("SystemMessage", 6);
	return;
}

event OnShow()
{
	SetWindowSize();
	return;
}

event OnHide()
{
	m_GMFindTreeWndItem.HideWindow();
	m_GMFindTreeWndSkill.HideWindow();
	Me.DisableTick();
	return;
}

event OnComboBoxItemSelected(string strID, int IndexID)
{
	local string EditBoxString;

	EditBoxString = uicontrolFindTextInputScr.GetString();
	switch(strID)
	{
		case "ComboBox":
			ShowList(EditBoxString, EListType(IndexID));
			break;
		default:
			break;
	}
	return;
}

event OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
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

event OnDBClickListCtrlRecord(string ListCtrlID)
{
	Summon(INT64(1));
	return;
}

event OnClickListCtrlRecord(string strID)
{
	local LVDataRecord Record;

	m_hBtnSummon.EnableWindow();
	if((int(curListType) == 0))
	{
		if(GetSelectedListCtrlItem(Record))
		{
			GMFindTreeWndItem(GetScript("GMFindTreeWndItem")).SetItemID(int(Record.LVDataList[1].szData));
		}
	}
	if(((int(curListType) == 0) || (int(curListType) == 3)))
	{
		if(GetSelectedListCtrlItem(Record))
		{
			GetMeItemWindow("Texture64ItemWnd").Clear();
			GetMeItemWindow("Texture48ItemWnd").Clear();
			GetMeItemWindow("Texture32ItemWnd").Clear();
			GetMeItemWindow("Texture24ItemWnd").Clear();
			GetMeItemWindow("Texture16ItemWnd").Clear();
			if((int(curListType) == 0))
			{
				GetMeItemWindow("Texture64ItemWnd").AddItem(GetItemInfoByClassID(int(Record.nReserved1)));
				GetMeItemWindow("Texture48ItemWnd").AddItem(GetItemInfoByClassID(int(Record.nReserved1)));
				GetMeItemWindow("Texture32ItemWnd").AddItem(GetItemInfoByClassID(int(Record.nReserved1)));
				GetMeItemWindow("Texture24ItemWnd").AddItem(GetItemInfoByClassID(int(Record.nReserved1)));
				GetMeItemWindow("Texture16ItemWnd").AddItem(GetItemInfoByClassID(int(Record.nReserved1)));
			}
			else if((int(curListType) == 3))
			{
				GetMeItemWindow("Texture64ItemWnd").AddItem(getSkillToItemInfo(GetSkillInfoByValue(int(Record.nReserved1), Record.LVDataList[1].nReserved1, 0)));
				GetMeItemWindow("Texture48ItemWnd").AddItem(getSkillToItemInfo(GetSkillInfoByValue(int(Record.nReserved1), Record.LVDataList[1].nReserved1, 0)));
				GetMeItemWindow("Texture32ItemWnd").AddItem(getSkillToItemInfo(GetSkillInfoByValue(int(Record.nReserved1), Record.LVDataList[1].nReserved1, 0)));
				GetMeItemWindow("Texture24ItemWnd").AddItem(getSkillToItemInfo(GetSkillInfoByValue(int(Record.nReserved1), Record.LVDataList[1].nReserved1, 0)));
				GetMeItemWindow("Texture16ItemWnd").AddItem(getSkillToItemInfo(GetSkillInfoByValue(int(Record.nReserved1), Record.LVDataList[1].nReserved1, 0)));
			}
			Debug(("record.nReserved1" @ string(Record.nReserved1)));
			Debug(("record.LVDataList[1].nReserved1 " @ string(Record.LVDataList[1].nReserved1)));
			Debug(Record.LVDataList[0].szTexture);
		}
	}
	return;
}

event OnRClickListCtrlRecord(string strID)
{
	m_hBtnSummon.EnableWindow();
	switch(curListType)
	{
		case LISTTYPE_SKILL:
			HandleShowSkillDetail();
			break;
		default:
			HandleBtnSummon();
			break;
	}
	return;
}

function HandleShowSkillDetail()
{
	local LVDataRecord Record;

	if(!GetSelectedListCtrlItem(Record))
	{
		return;
	}
	UISkillToolWnd(GetScript("UISkillToolWnd"))._Show(Record.LVDataList[1].szData);
	return;
}

event OnClickCheckBox(string strID)
{
	SetINIBool(m_hOwnerWnd.m_WindowNameWithFullPath, strID, GetCheckBoxHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ strID)).IsChecked(), "l2.ini");
	switch(strID)
	{
		case "ChkBox64":
			SetWindowSize();
			break;
		case "unLimitCheckBox":
			showListNum_OnTick = 10;
			break;
		case "ChkBoxLv1":
			FindByListTypeWithClear();
			showListNum_OnTick = 3000;
			break;
		default:
			break;
	}
	return;
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnSummon":
			HandleBtnSummon();
			break;
		case "btnFind":
			FindByListTypeWithClear();
			showListNum_OnTick = 3000;
			break;
		case "btnDetailInfo":
			ToggleItemDescWNd();
			break;
		default:
			break;
	}
	return;
}

event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

event OnTick()
{
	Me.DisableTick();
	OnTickNum++;
	FindByListType();
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
	local LVDataRecord overRec;

	itemDescWndScr = ItemDescWnd(GetScript("ItemDescWnd"));
	if(!itemDescWndScr.m_hOwnerWnd.IsShowWindow())
	{
		return;
	}
	m_hFindTreeList.GetRec(Index, overRec);
	switch(curListType)
	{
		case LISTTYPE_ITEM:
			itemDescWndScr.setWindowTitleByString(GetSystemString(564));
			break;
		case LISTTYPE_SKILL:
			itemDescWndScr.setWindowTitleByString(GetSystemString(14159));
			break;
		case LISTTYPE_NPC:
			itemDescWndScr.setWindowTitleByString((GetSystemString(2573) @ GetSystemString(491)));
			break;
		default:
			break;
	}
	HtmlString = GetHtmlDetailInfo(Index);
	HtmlString = (HtmlMakeTitleNDesc("ID", overRec.LVDataList[1].szData) $ HtmlString);
	HtmlString = MakeHtmlTable(HtmlString);
	HtmlString = ((GethtmlDetailInfoTitle(Index) $ "</br>") $ HtmlString);
	itemDescWndScr._LoadHtmlFromString(htmlSetHtmlStart(HtmlString));
	return;
}

function string GethtmlDetailInfoTitle(int Index)
{
	local LVDataRecord overRec;

	m_hFindTreeList.GetRec(Index, overRec);
	switch(curListType)
	{
		case LISTTYPE_ITEM:
			return HtmlItemnFullName(int(overRec.LVDataList[1].szData));
		case LISTTYPE_SKILL:
			return HtmlQuestnameTableAdd(overRec.LVDataList[0].szData);
		case LISTTYPE_NPC:
			return HtmlQuestnameTableAdd(overRec.LVDataList[0].szData);
		default:
			return "";
	}
}

function string GetHtmlDetaiInfoItem(int Index)
{
	local string HtmlString;
	local LVDataRecord overRec;
	local ItemInfo iInfo;
	local array<int> IDs;

	m_hFindTreeList.GetRec(Index, overRec);
	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(int(overRec.LVDataList[1].szData)), iInfo);
	AddHtmlString(HtmlString, HtmlMakeTitleNDesc("Item type", string(iInfo.ItemType)));
	AddHtmlString(HtmlString, HtmlMakeTitleNDesc("Slot bit type", string(iInfo.SlotBitType)));
	AddHtmlString(HtmlString, HtmlMakeTitleNDesc("Consume type", string(iInfo.ConsumeType)));
	AddHtmlString(HtmlString, HtmlMakeTitleNDesc("Weapon type", string(iInfo.WeaponType)));
	AddHtmlString(HtmlString, HtmlMakeTitleNDesc("Collection use", string(CollectionSystem(GetScript("collectionSystem")).API_GetCollectionIdByItemId(IDs, iInfo.Id.ClassID))));
	AddHtmlString(HtmlString, HtmlMakeTitleNDesc("Item skill", "ItemData - server"));
	AddHtmlString(HtmlString, HtmlMakeTitleNDesc("Item option", "ItemData - server"));
	return HtmlString;
}

function string _GetHtmlDetaiInfoSkill(int SkillID, int skillLv, int skillSubLv)
{
	local string HtmlString;
	local SkillInfo sInfo;

	GetSkillInfo(SkillID, skillLv, skillSubLv, sInfo);
	AddHtmlString(HtmlString, HtmlMakeTitleNDesc("Level", string(sInfo.SkillLevel)));
	AddHtmlString(HtmlString, HtmlMakeTitleNDesc("Operate type", string(sInfo.OperateType)));
	AddHtmlString(HtmlString, HtmlMakeTitleNDesc("Target type", string(sInfo.TargetType)));
	AddHtmlString(HtmlString, HtmlMakeTitleNDesc("Affect scope", string(sInfo.AffectScope)));
	AddHtmlString(HtmlString, HtmlMakeTitleNDesc("Operate cond", "SkillData - server"));
	AddHtmlString(HtmlString, HtmlMakeTitleNDesc("Abnormal type", "SkillData - server"));
	return HtmlString;
}

function string GetHtmlDetaiInfoSkill(int Index)
{
	local LVDataRecord overRec;

	m_hFindTreeList.GetRec(Index, overRec);
	return _GetHtmlDetaiInfoSkill(int(overRec.nReserved1), int(overRec.nReserved2), 0);
}

function string GetHtmlDetailInfoNPC(int Index)
{
	local string HtmlString;
	local LVDataRecord overRec;
	local UserInfo uInfo;

	m_hFindTreeList.GetRec(Index, overRec);
	GetUserInfo(int(overRec.LVDataList[1].szData), uInfo);
	AddHtmlString(HtmlString, HtmlMakeTitleNDesc("Clan", "NPCData - server"));
	AddHtmlString(HtmlString, HtmlMakeTitleNDesc("Clan hep range", "NPCData - server"));
	AddHtmlString(HtmlString, HtmlMakeTitleNDesc("Npc ai", "NPCData - server"));
	return HtmlString;
}

function string GetHtmlDetailInfo(int Index)
{
	local string HtmlString;

	switch(curListType)
	{
		case LISTTYPE_ITEM:
			return GetHtmlDetaiInfoItem(Index);
		case LISTTYPE_SKILL:
			return GetHtmlDetaiInfoSkill(Index);
		case LISTTYPE_NPC:
			return GetHtmlDetailInfoNPC(Index);
		default:
			return HtmlString;
	}
}

function AddHtmlString(out string HtmlString, string AddString)
{
	if((AddString == ""))
	{
		return;
	}
	HtmlString = (HtmlString $ AddString);
	return;
}

function string _HtmlQuestnameTableAdd(string Title)
{
	return HtmlQuestnameTableAdd(Title);
}

function string HtmlQuestnameTableAdd(string Title)
{
	local string hex;

	hex = Class'Interface.L2UIColor'.static.Inst()._Color2ZeroX(Class'Interface.L2UIColor'.static.Inst().Sandrift);
	return (((("<table width=290 cellpadding=0 border=0 cellspacing=0><tr><td width=26><img src = \"L2UI_CT1.Minimap.Minimap_OpenGuideWnd\" width=26 height=26></td><td width=254 align=left valign=bottom><font color=\"" $ hex) $ "\" name=GameDefault>") $ Title) $ "</font></td></tr></table>");
}

function string HtmlItemnFullName(int ClassID)
{
	local int W;
	local ItemInfo iInfo;
	local string HTML, textureHtml;

	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(ClassID), iInfo);
	if((iInfo.Enchanted > 0))
	{
		HTML = (GetEnchantedHtml(iInfo.Enchanted) $ " ");
	}
	if(iInfo.IsBlessedItem)
	{
		HTML = ((HTML $ GetNameHtmlBress()) $ " ");
	}
	HTML = (HTML $ GetNameHtml(iInfo));
	if((Len(iInfo.AdditionalName) > 0))
	{
		HTML = (HTML @ GetNameHtmlAddionalName(iInfo.AdditionalName));
	}
	HTML = HtmlAddTableTD(HTML, "left", "bottom", 0, 22);
	textureHtml = GetNameHtmlGradeIcon(iInfo.CrystalType, W);
	if((textureHtml != ""))
	{
		HTML = (HTML $ HtmlAddTableTD((" " $ textureHtml), "right", "bottom", (W + 5), 24, "", true));
	}
	return (("<table width=0 cellpadding=0 border=0 cellspacing=0><tr><td width=26><img src = \"L2UI_CT1.Minimap.Minimap_OpenGuideWnd\" width=26 height=26></td>" $ HTML) $ "</tr></table>");
}

function string _MakeHtmlTable(string HTML)
{
	return MakeHtmlTable(HTML);
}

function string MakeHtmlTable(string HTML)
{
	return (("<table width=294 border=0 cellpadding=1 cellspacing=2 background=L2UI_CT1.GroupBox.GroupBox_DF>" $ HTML) $ "</table>");
}

function string _HtmlMakeTitleNDesc(string Title, string Desc)
{
	return HtmlMakeTitleNDesc(Title, Desc);
}

function string HtmlMakeTitleNDesc(string Title, string Desc)
{
	return (((("<tr><td width=140 align=right>" $ Title) $ "</td><td width=1></td><td width=150 align=left>") $ htmlfontAdd((" " $ Desc), Class'Interface.L2UIColor'.static.Inst()._Color2ZeroX(Class'Interface.L2UIColor'.static.Inst().Sandrift))) $ "</td></tr>");
}

function string htmlfontAdd(string strText, optional string FontColor)
{
	local string targetHtml;

	if((FontColor == ""))
	{
		FontColor = "d3c5ae";
	}
	targetHtml = ((((("<font color=\"" $ FontColor) $ "\"") $ ">") $ strText) $ "</font>");
	return targetHtml;
}

function DelegateOnKeyUP(Interactions.EInputKey nKey)
{
	switch(nKey)
	{
		case IK_Enter:
			FindByListTypeWithClear();
			showListNum_OnTick = 3000;
			break;
		default:
			break;
	}
	return;
}

function DelegateESCKey()
{
	OnReceivedCloseUI();
	return;
}

function DelegateOnCompleteEditBox(string Text)
{
	FindByListTypeWithClear();
	return;
}

function DelegateOnClearEditBox()
{
	DelegateOnEditEditBox("");
	return;
}

function DelegateOnEditEditBox(string Text)
{
	showListNum_OnTick = 10;
	ClearOnTickInfos();
	ClearList();
	FindByListType();
	return;
}

function ShowSubWindow()
{
	m_ChkBoxLv1.HideWindow();
	switch(curListType)
	{
		case LISTTYPE_ITEM:
			m_GMFindTreeWndItem.ShowWindow();
			m_GMFindTreeWndSkill.HideWindow();
			m_hbtnDetailInfo.EnableWindow();
			break;
		case LISTTYPE_SKILL:
			m_GMFindTreeWndItem.HideWindow();
			m_GMFindTreeWndSkill.ShowWindow();
			m_hbtnDetailInfo.EnableWindow();
			m_ChkBoxLv1.ShowWindow();
			break;
		case LISTTYPE_NPC:
			m_GMFindTreeWndItem.HideWindow();
			m_GMFindTreeWndSkill.HideWindow();
			m_hbtnDetailInfo.EnableWindow();
			break;
		default:
			m_GMFindTreeWndItem.HideWindow();
			m_GMFindTreeWndSkill.HideWindow();
			m_hbtnDetailInfo.DisableWindow();
			break;
	}
	return;
}

function ShowList(string findString, EListType listType)
{
	curListType = listType;
	if((uicontrolFindTextInputScr.GetString() != findString))
	{
		uicontrolFindTextInputScr.SetString(findString);
		return;
	}
	m_hComboBox.SetSelectedNum(int(curListType));
	FindByListTypeWithClear();
	if((findString != ""))
	{
		showListNum_OnTick = 3000;
	}
	ShowSubWindow();
	Me.ShowWindow();
	Me.SetFocus();
	return;
}

function _Toggle(string findString, EListType listType)
{
	if(((int(curListType) == int(listType)) && Me.IsShowWindow()))
	{
		Me.HideWindow();
		return;
	}
	curListType = listType;
	uicontrolFindTextInputScr.SetString(findString);
	m_hComboBox.SetSelectedNum(int(curListType));
	FindByListTypeWithClear();
	if((findString != ""))
	{
		showListNum_OnTick = 3000;
	}
	ShowSubWindow();
	Me.ShowWindow();
	Me.SetFocus();
	return;
}

function FindByListTypeWithClear()
{
	bFindStop = false;
	Me.DisableTick();
	ClearOnTickInfos();
	showListNum_OnTick = 10;
	ClearList();
	FindByListType();
	return;
}

function bool FindByListType()
{
	local string findString;
	local bool isEnd;

	findString = uicontrolFindTextInputScr.GetString();
	switch(curListType)
	{
		case LISTTYPE_ITEM:
			isEnd = FindAllItem(findString);
			break;
		case LISTTYPE_QUEST:
			if(getInstanceUIData().GetIsClassicServer())
			{
				isEnd = FindAllNQuest(findString);
			}
			else
			{
				isEnd = FindAllQuest(findString);
			}
			break;
		case LISTTYPE_NPC:
			isEnd = FindAllNPC(findString);
			break;
		case LISTTYPE_SKILL:
			isEnd = FindAllSkill(findString);
			break;
		case LISTTYPE_CLASS:
			isEnd = FindAllCLASS(findString);
			break;
		case LISTTYPE_SYSTEMSTRING:
			isEnd = FindAllSystemString(findString);
			break;
		case LISTTYPE_SYSTEMMESSAGE:
			isEnd = FindAllSystemMessage(findString);
			break;
		default:
			break;
	}
	if(isEnd)
	{
		SetListNum();
	}
	else if(IsFindStop())
	{
		SetListFindingStop();
	}
	else
	{
		SetListFindingNum();
	}
	return isEnd;
}

function bool ChkOver500()
{
	local bool isOver;

	isOver = (findOnTickNum >= ((OnTickNum + 1) * showListNum_OnTick));
	findOnTickNum++;
	return isOver;
}

function SetListNum()
{
	m_hTbTotal.SetText(GetSystemString(14135));
	m_hTbFoundResultCnt.SetText(string(m_hFindTreeList.GetRecordCount()));
	GetWindowHandle((m_Windowname $ ".AutoAllArrowOn_texture")).HideWindow();
	GetWindowHandle((m_Windowname $ ".findingIcon")).HideWindow();
	return;
}

function SetListFindingNum()
{
	m_hTbTotal.SetText(GetSystemString(3513));
	m_hTbFoundResultCnt.SetText(string((findOnTickNum - 1)));
	if((showListNum_OnTick == 10))
	{
		GetWindowHandle((m_Windowname $ ".AutoAllArrowOn_texture")).HideWindow();
	}
	else
	{
		GetWindowHandle((m_Windowname $ ".AutoAllArrowOn_texture")).ShowWindow();
	}
	GetWindowHandle((m_Windowname $ ".findingIcon")).ShowWindow();
	return;
}

function SetListFindingStop()
{
	m_hTbTotal.SetText("검색 중지");  // EN?: Stop Scan
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".findingIcon")).HideWindow();
	GetWindowHandle((m_Windowname $ ".findingIcon")).HideWindow();
	GetWindowHandle((m_Windowname $ ".AutoAllArrowOn_texture")).HideWindow();
	return;
}

function bool FindAllCLASS(string a_Param)
{
	local int classIndex;
	local string fullNameString;

	if((findOnTickCurrentID != 0))
	{
		classIndex = findOnTickCurrentID;
	}
	classIndex = classIndex;
	while((classIndex < 500))
	{
		if(ChkOver500())
		{
			findOnTickCurrentID = classIndex;
			Me.EnableTick();
			return false;
		}
		fullNameString = GetSystemString(Class'NWindow.UIDataManager'.static.GetClassnameSysstringIndexByClassIndex(classIndex));
		if((fullNameString == ""))
		{
			classIndex++;
			continue;
		}
		InsertRecordFindTreeList(fullNameString, a_Param, classIndex, GetClassRoleIconName(classIndex));
		classIndex++;
	}
	findOnTickCurrentID = -1;
	return true;
}

function bool FindAllSystemString(string a_Param)
{
	local int i;
	local string fullNameString;

	if((findOnTickCurrentID != 0))
	{
		i = findOnTickCurrentID;
	}
	i = i;
	while((i < 20000))
	{
		if(ChkOver500())
		{
			findOnTickCurrentID = i;
			Me.EnableTick();
			return false;
		}
		fullNameString = GetSystemString(i);
		if((fullNameString == ""))
		{
			i++;
			continue;
		}
		InsertRecordFindTreeList(fullNameString, a_Param, i, "", ((5000 <= i) && (i <= 11000)));
		i++;
	}
	findOnTickCurrentID = -1;
	return true;
}

function bool FindAllSystemMessage(string a_Param)
{
	local int i;
	local string fullNameString;

	if((findOnTickCurrentID != 0))
	{
		i = findOnTickCurrentID;
	}
	i = i;
	while((i < 20000))
	{
		if(ChkOver500())
		{
			findOnTickCurrentID = i;
			Me.EnableTick();
			return false;
		}
		fullNameString = GetSystemMessage(i);
		if((fullNameString == ""))
		{
			i++;
			continue;
		}
		InsertRecordFindTreeList(fullNameString, a_Param, i, "", ((6000 <= i) && (i <= 11000)));
		i++;
	}
	return true;
	findOnTickCurrentID = -1;
}

function bool FindAllNQuest(string a_Param)
{
	local int qid;
	local string Type;
	local NQuestUIData questUIData;

	if((findOnTickCurrentID == 0))
	{
		qid = Class'NWindow.UIDATA_QUEST'.static.GetNFirstID();
	}
	else
	{
		qid = findOnTickCurrentID;
	}
	qid = qid;
	while((-1 != qid))
	{
		if(!API_GetNQuestData(qid, questUIData))
		{
			qid = Class'NWindow.UIDATA_QUEST'.static.GetNNextID();
			continue;
		}
		if(ChkOver500())
		{
			findOnTickCurrentID = qid;
			Me.EnableTick();
			return false;
		}
		switch(questUIData.Type)
		{
			case NQT_ONETIME:
				Type = GetSystemString(862);
				break;
			case NQT_DAILY:
				Type = GetSystemString(2788);
				break;
			case NQT_WEEKLY:
				Type = GetSystemString(14389);
				break;
			case NQT_REPEAT:
				Type = GetSystemString(861);
				break;
			default:
				break;
		}
		InsertRecordFindTreeList((((questUIData.Name @ "(") $ Type) $ ")"), a_Param, questUIData.Id, GetMainTypeTexture(questUIData));
		qid = Class'NWindow.UIDATA_QUEST'.static.GetNNextID();
	}
	findOnTickCurrentID = -1;
	return true;
}

function string GetMainTypeTexture(NQuestUIData questUIData)
{
	if((questUIData.Id < 20001))
	{
		return "L2UI_NEWTEX.QUESTWND.QICON_MAIN";
	}
	else if((questUIData.Id < 30001))
	{
		return "L2UI_NEWTEX.QUESTWND.QICON_SUB";
	}
	return "L2UI_NEWTEX.QUESTWND.QICON_ESPECIAL";
}

function bool FindAllQuest(string a_Param)
{
	local int Id;
	local string fullNameString, IconName;
	local int QuestType;

	if((findOnTickCurrentID == 0))
	{
		Id = Class'NWindow.UIDATA_QUEST'.static.GetFirstID();
	}
	else
	{
		Id = findOnTickCurrentID;
	}
	Id = Id;
	while((-1 != Id))
	{
		if(ChkOver500())
		{
			findOnTickCurrentID = Id;
			Me.EnableTick();
			return false;
		}
		fullNameString = Class'NWindow.UIDATA_QUEST'.static.GetQuestName(Id);
		QuestType = Class'NWindow.UIDATA_QUEST'.static.GetQuestType(Id, 1);
		switch(QuestType)
		{
			case 0:
			case 2:
				IconName = "L2UI_CH3.QUESTWND.QuestWndInfoIcon_1";
				break;
			case 1:
			case 3:
				IconName = "L2UI_CH3.QUESTWND.QuestWndInfoIcon_2";
				break;
			case 4:
			case 5:
				IconName = "L2UI_CH3.QUESTWND.QuestWndInfoIcon_3";
				break;
			default:
				break;
		}
		InsertRecordFindTreeList(fullNameString, a_Param, Id, IconName);
		Id = Class'NWindow.UIDATA_QUEST'.static.GetNextID();
	}
	findOnTickCurrentID = -1;
	return true;
}

function bool FindAllSkill(string a_Param)
{
	local ItemID cID;
	local string fullNameString, IconName;
	local array<int> subLevelInfos;
	local bool canSkillEnchant;

	m_hFindTreeList.SetTooltipType("Skill");
	if(bFindStop)
	{
		return false;
	}
	else
	{
		UISkillToolWnd(GetScript("UISkillToolWnd"))._SetFindStop();
	}
	if((findOnTickCurrentID == 0))
	{
		cID = Class'NWindow.UIDATA_SKILL'.static.GetFirstID();
	}
	else
	{
		cID.ClassID = findOnTickCurrentID;
	}
	cID = cID;
	while(IsValidItemID(cID))
	{
		if((lastSkillClassiD != cID.ClassID))
		{
			lastSkillClassiD = cID.ClassID;
			SkillLevel = 1;
		}
		if(ChkOver500())
		{
			findOnTickCurrentID = cID.ClassID;
			Me.EnableTick();
			return false;
		}
		fullNameString = Class'NWindow.UIDATA_SKILL'.static.GetName(cID, SkillLevel, 0);
		IconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(cID, SkillLevel, 0);
		IconName = Caps(IconName);
		canSkillEnchant = (GetSkillSubLevelList(lastSkillClassiD, SkillLevel, subLevelInfos) > 1);
		InsertRecordFindTreeList(fullNameString, a_Param, lastSkillClassiD, IconName, canSkillEnchant);
		SkillLevel++;
		if(canSkillEnchant)
		{
			SkillNextIDByEnchantLevel(subLevelInfos.Length);
		}
		cID = Class'NWindow.UIDATA_SKILL'.static.GetNextID();
	}
	findOnTickCurrentID = -1;
	lastSkillClassiD = -1;
	return true;
}

function SkillNextIDByEnchantLevel(int subSkillNum)
{
	local int i;

	i = 1;
	while((i < subSkillNum))
	{
		lastSkillClassiD = Class'NWindow.UIDATA_SKILL'.static.GetNextID().ClassID;
		i++;
	}
	return;
}

function bool FindAllNPC(string a_Param)
{
	local int Id;
	local string fullNameString, nickname;

	m_hFindTreeList.SetTooltipType("SellItemList");
	if((findOnTickCurrentID == 0))
	{
		Id = Class'NWindow.UIDATA_NPC'.static.GetFirstID();
	}
	else
	{
		Id = findOnTickCurrentID;
	}
	Id = Id;
	while((-1 != Id))
	{
		if(ChkOver500())
		{
			findOnTickCurrentID = Id;
			Me.EnableTick();
			return false;
		}
		fullNameString = Class'NWindow.UIDATA_NPC'.static.GetNPCName(Id);
		nickname = Class'NWindow.UIDATA_NPC'.static.GetNPCNickName(Id);
		if((nickname != ""))
		{
			fullNameString = (((fullNameString @ "(") $ nickname) $ ")");
		}
		InsertRecordFindTreeList(fullNameString, a_Param, (Id + 1000000), "");
		Id = Class'NWindow.UIDATA_NPC'.static.GetNextID();
	}
	findOnTickCurrentID = -1;
	return true;
}

function bool FindAllItem(string a_Param)
{
	local ItemID cID;
	local string fullNameString, AdditionalName;
	local int itemNameClass;
	local string IconName;

	m_hFindTreeList.SetTooltipType("SellItemList");
	if((findOnTickCurrentID == 0))
	{
		cID = Class'NWindow.UIDATA_ITEM'.static.GetFirstID();
	}
	else
	{
		cID.ClassID = findOnTickCurrentID;
	}
	cID = cID;
	while(IsValidItemID(cID))
	{
		if(ChkOver500())
		{
			findOnTickCurrentID = cID.ClassID;
			Me.EnableTick();
			return false;
		}
		fullNameString = Class'NWindow.UIDATA_ITEM'.static.GetItemName(cID);
		itemNameClass = Class'NWindow.UIDATA_ITEM'.static.GetItemNameClass(cID);
		AdditionalName = Class'NWindow.UIDATA_ITEM'.static.GetItemAdditionalName(cID);
		IconName = Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(cID);
		IconName = Caps(IconName);
		if((itemNameClass == 0))
		{
			fullNameString = MakeFullSystemMsg(GetSystemMessage(2332), fullNameString);
		}
		else if((itemNameClass == 2))
		{
			fullNameString = MakeFullSystemMsg(GetSystemMessage(2331), fullNameString);
		}
		if((Len(AdditionalName) > 0))
		{
			fullNameString = (((fullNameString $ "(") $ AdditionalName) $ ")");
		}
		InsertRecordFindTreeList(fullNameString, a_Param, cID.ClassID, IconName);
		cID = Class'NWindow.UIDATA_ITEM'.static.GetNextID();
	}
	findOnTickCurrentID = -1;
	return true;
}

function LVDataRecord InsertIconData(LVDataRecord Record, string IconName)
{
	local int nTextureWH, nTextureUV;
	local ItemInfo Info;

	Record.LVDataList[0].hasIcon = true;
	switch(curListType)
	{
		case LISTTYPE_ITEM:
			nTextureWH = 32;
			if(m_checkbox64size.IsChecked())
			{
				nTextureUV = 64;
			}
			else
			{
				nTextureUV = 32;
			}
			Info = GetItemInfoByClassID(int(Record.nReserved1));
			if((Info.IconPanel != ""))
			{
				Record.LVDataList[0].panelWidth = nTextureWH;
				Record.LVDataList[0].panelHeight = nTextureWH;
				Record.LVDataList[0].panelUL = nTextureUV;
				Record.LVDataList[0].panelVL = nTextureUV;
				Record.LVDataList[0].panelOffsetXFromIconPosX = 0;
				Record.LVDataList[0].panelOffsetYFromIconPosY = 0;
				Record.LVDataList[0].iconPanelName = Info.IconPanel;
			}
			break;
		case LISTTYPE_SKILL:
			nTextureWH = 32;
			if(m_checkbox64size.IsChecked())
			{
				nTextureUV = 64;
			}
			else
			{
				nTextureUV = 32;
			}
			break;
		case LISTTYPE_CLASS:
			nTextureWH = 32;
			nTextureUV = 16;
			break;
		case LISTTYPE_QUEST:
			nTextureWH = 32;
			nTextureUV = 16;
			break;
		default:
			nTextureWH = 32;
			nTextureUV = 16;
			break;
	}
	Record.LVDataList[0].nTextureWidth = nTextureWH;
	Record.LVDataList[0].nTextureHeight = nTextureWH;
	Record.LVDataList[0].nTextureU = nTextureUV;
	Record.LVDataList[0].nTextureV = nTextureUV;
	Record.LVDataList[0].szTexture = IconName;
	Record.LVDataList[0].IconPosX = 2;
	Record.LVDataList[0].FirstLineOffsetX = 2;
	return Record;
}

function int InsertRecordFindTreeList(string fullNameString, string a_Param, int Id, string IconName, optional bool canSkillEnchant)
{
	local string modifiedString, itemParam;
	local LVDataRecord Record;
	local int IconType, skillIconType;
	local string iconTypeString;
	local ItemID localItemId;
	local int Length;
	local string groupTypeString;
	local int GroupType, skillGroupType;

	modifiedString = Substitute(fullNameString, " ", "", false);
	if((FindMatchString(modifiedString, uicontrolExecptionTextInputScr.GetString()) != -1))
	{
		return 0;
	}
	if(!(((FindMatchString(modifiedString, a_Param) != -1) || (a_Param == "")) || (a_Param == string(Id))))
	{
		return 0;
	}
	Record.LVDataList.Length = 2;
	Record.LVDataList[0].bUseTextColor = true;
	Record.LVDataList[0].TextColor = GetColor(176, 153, 121, 255);
	switch(curListType)
	{
		case LISTTYPE_ITEM:
			Class'NWindow.UIDATA_ITEM'.static.GetItemInfoString(Id, itemParam);
			Record.szReserved = itemParam;
			Record.nReserved1 = INT64(Id);
			break;
		case LISTTYPE_SKILL:
			if(m_ChkBoxLv1.IsChecked())
			{
				if((SkillLevel > 1))
				{
					return 0;
				}
			}
			iconTypeString = GMFindTreeWndSkill(m_GMFindTreeWndSkill.GetScript()).m_ebIconType.GetString();
			Length = Len(iconTypeString);
			if((Length > 0))
			{
				IconType = int(iconTypeString);
				localItemId.ClassID = Id;
				skillIconType = Class'NWindow.UIDATA_SKILL'.static.GetIconType(localItemId, SkillLevel, 0);
				if((IconType != skillIconType))
				{
					return m_hFindTreeList.GetRecordCount();
				}
			}
			groupTypeString = GMFindTreeWndSkill(m_GMFindTreeWndSkill.GetScript()).m_ebGroupType.GetString();
			if((Len(groupTypeString) > 0))
			{
				GroupType = int(groupTypeString);
				localItemId.ClassID = Id;
				skillGroupType = Class'NWindow.UIDATA_SKILL'.static.GetGroupType(localItemId, SkillLevel, 0);
				if((GroupType != skillGroupType))
				{
					return m_hFindTreeList.GetRecordCount();
				}
			}
			Record.nReserved1 = INT64(Id);
			Record.LVDataList[1].nReserved1 = SkillLevel;
			fullNameString = ((fullNameString @ "Lv") $ string(Record.LVDataList[1].nReserved1));
			Record.nReserved1 = INT64(Id);
			Record.nReserved2 = INT64(SkillLevel);
			Record.nReserved3 = INT64(0);
			break;
		case LISTTYPE_NPC:
			break;
		default:
			break;
	}
	if((IconName != ""))
	{
		Record = InsertIconData(Record, IconName);
	}
	Record.LVDataList[0].szData = fullNameString;
	Record.LVDataList[1].szData = string(Id);
	Record.LVDataList[1].bUseTextColor = canSkillEnchant;
	Record.LVDataList[1].TextColor = Class'Interface.L2UIColor'.static.Inst().VIOLET01;
	m_hFindTreeList.InsertRecord(Record);
	return m_hFindTreeList.GetRecordCount();
}

function SummonItemCheck(INT64 Cnt)
{
	local LVDataRecord Record;
	local ItemInfo iInfo;

	if(!GetSelectedListCtrlItem(Record))
	{
		return;
	}
	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(int(Record.LVDataList[1].szData)), iInfo);
	if((int(byte(iInfo.EtcItemType)) == 7))
	{
		ProcessChatMessage((("//summon2" @ string(Cnt)) @ Record.LVDataList[1].szData));
	}
	else
	{
		ProcessChatMessage((("//summon" @ Record.LVDataList[1].szData) @ string(Cnt)));
	}
	return;
}

function UseSkillFunc()
{
	local LVDataRecord Record;

	if(!GetSelectedListCtrlItem(Record))
	{
		return;
	}
	ProcessChatMessage(((("//use_skill" @ Record.LVDataList[1].szData) @ string(Record.LVDataList[1].nReserved1)) @ string(0)));
	return;
}

function Summon(INT64 Cnt)
{
	local LVDataRecord Record;

	if(GetSelectedListCtrlItem(Record))
	{
		if((Record.LVDataList[1].szData != ""))
		{
			switch(curListType)
			{
				case LISTTYPE_ITEM:
					SummonItemCheck(Cnt);
					break;
				case LISTTYPE_NPC:
					ProcessChatMessage((("//summon" @ Record.LVDataList[1].szData) @ string(Cnt)));
					break;
				case LISTTYPE_SKILL:
					ProcessChatMessage(((("//setskill" @ Record.LVDataList[1].szData) @ string(Record.LVDataList[1].nReserved1)) @ string(0)));
					break;
				case LISTTYPE_CLASS:
					ProcessChatMessage(("//setclass" @ Record.LVDataList[1].szData));
					break;
				case LISTTYPE_QUEST:
					if(getInstanceUIData().GetIsClassicServer())
					{
						UIQuestToolWnd(GetScript("UIQuestToolWnd"))._ShowNQuestContextMenu(int(Record.LVDataList[1].szData));
					}
					else
					{
						ProcessChatMessage((("//setquest" @ Record.LVDataList[1].szData) @ string(0)));
					}
					break;
				case LISTTYPE_SYSTEMSTRING:
					ClipboardCopy(Record.LVDataList[0].szData);
					ProcessChatMessage(("///ss" @ Record.LVDataList[1].szData));
					break;
				case LISTTYPE_SYSTEMMESSAGE:
					ClipboardCopy(Record.LVDataList[0].szData);
					ProcessChatMessage(("///sm" @ Record.LVDataList[1].szData));
					break;
				default:
					break;
			}
		}
	}
	return;
}

function ToggleItemDescWNd()
{
	local WindowHandle wnd;

	wnd = GetWindowHandle("ItemDescWnd");
	if(wnd.IsShowWindow())
	{
		GetWindowHandle("ItemDescWnd").HideWindow();
	}
	else
	{
		HandleSetDescWindow(m_hFindTreeList.GetSelectedIndex());
		GetWindowHandle("ItemDescWnd").ShowWindow();
	}
	return;
}

function HandleBtnSummon()
{
	switch(curListType)
	{
		case LISTTYPE_ITEM:
			openDialogNumpad(INT64(1));
			break;
		case LISTTYPE_QUEST:
			Summon(INT64(1));
			break;
		case LISTTYPE_NPC:
			openDialogNumpad(INT64(1));
			break;
		case LISTTYPE_SKILL:
			UseSkillFunc();
			break;
		case LISTTYPE_SYSTEMSTRING:
			Summon(INT64(1));
			break;
		case LISTTYPE_SYSTEMMESSAGE:
			Summon(INT64(1));
			break;
		default:
			break;
	}
	return;
}

function bool GetSelectedListCtrlItem(out LVDataRecord Record)
{
	local int Index;

	Index = m_hFindTreeList.GetSelectedIndex();
	if((Index >= 0))
	{
		m_hFindTreeList.GetRec(Index, Record);
		return true;
	}
	return false;
}

function ClearList()
{
	m_hFindTreeList.DeleteAllItem();
	m_hFindTreeList.ClearTooltip();
	m_hFindTreeList.SetTooltipType("");
	m_hBtnSummon.DisableWindow();
	return;
}

function ClearOnTickInfos()
{
	OnTickNum = 0;
	findOnTickNum = 0;
	findOnTickCurrentID = 0;
	return;
}

function HandleDialogOK()
{
	local INT64 inputNum;
	local int Id;

	if(!DialogIsMine())
	{
		return;
	}
	Id = Class'Interface.UICommonAPI'.static.DialogGetID();
	if((Id == 10000))
	{
		inputNum = INT64(Class'Interface.UICommonAPI'.static.DialogGetString());
		Summon(inputNum);
	}
	return;
}

function openDialogNumpad(INT64 Num)
{
	local LVDataRecord selectedRec;
	local string dialogMsg;
	local ItemInfo iInfo;

	m_hFindTreeList.GetSelectedRec(selectedRec);
	Class'Interface.UICommonAPI'.static.DialogSetID(10000);
	Class'Interface.UICommonAPI'.static.DialogSetEditType("number");
	Class'Interface.UICommonAPI'.static.DialogSetParamInt64(Num);
	Class'Interface.UICommonAPI'.static.DialogSetDefaultOK();
	dialogMsg = selectedRec.LVDataList[0].szData;
	if((int(curListType) == 0))
	{
		Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(int(selectedRec.LVDataList[1].szData)), iInfo);
		if((int(byte(iInfo.EtcItemType)) == 7))
		{
			dialogMsg = (selectedRec.LVDataList[0].szData $ "\\n\\n - 레벨");  // EN?: \\ n\\ n - Level
		}
	}
	DialogShow(DialogModalType_Modalless, DialogType_NumberPad, dialogMsg);
	return;
}

function int FindMatchString(string modifiedString, string a_Param)
{
	local string delim;

	delim = " ";
	if(StringMatching(modifiedString, a_Param, delim))
	{
		return 1;
	}
	else
	{
		return -1;
	}
	return 1;
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

function SetWindowSize()
{
	if(m_checkbox64size.IsChecked())
	{
		Me.SetWindowSize(369, 666);
		GetMeItemWindow("Texture64ItemWnd").ShowWindow();
		GetMeItemWindow("Texture48ItemWnd").ShowWindow();
		GetMeItemWindow("Texture32ItemWnd").ShowWindow();
		GetMeItemWindow("Texture24ItemWnd").ShowWindow();
		GetMeItemWindow("Texture16ItemWnd").ShowWindow();
	}
	else
	{
		Me.SetWindowSize(369, 586);
		GetMeItemWindow("Texture64ItemWnd").HideWindow();
		GetMeItemWindow("Texture48ItemWnd").HideWindow();
		GetMeItemWindow("Texture32ItemWnd").HideWindow();
		GetMeItemWindow("Texture24ItemWnd").HideWindow();
		GetMeItemWindow("Texture16ItemWnd").HideWindow();
	}
	return;
}

function bool API_GetNQuestData(int a_QuestID, out NQuestUIData o_data)
{
	return GetNQuestData(a_QuestID, o_data);
}

defaultproperties
{
	m_Windowname="GMFindTreeWnd"
}
