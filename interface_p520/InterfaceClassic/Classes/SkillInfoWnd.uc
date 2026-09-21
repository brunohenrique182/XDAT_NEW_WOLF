class SkillInfoWnd extends UICommonAPI
	dependson(UIPacket);

const SKILL_MIN_LEVEL = 1;
const ITEM_ID_SP = 15624;
const ITEM_ID_ADENA = 57;

struct FindCostItemInfo
{
	var int SystemMsgID;
	var int MultisellID;
	var int findCategory;
	var INT64 ConsumeAdena;
	var int ConsumeItemID;
	var string findName;
};

var WindowHandle Me;
var WindowHandle dialogContainerWnd;
var WindowHandle learnDialogWnd;
var WindowHandle errorDialogWnd;
var WindowHandle needItemLearnNoticeWnd;
var ButtonHandle learnBtn;
var ButtonHandle EnchantBtn;
var ButtonHandle enchantExtractBtn;
var ButtonHandle levelPrevBtn;
var ButtonHandle levelNextBtn;
var ButtonHandle refreshBtn;
var TextureHandle levelPrevAnimTex;
var TextureHandle levelNextAnimTex;
var ItemWindowHandle skillItemWnd;
var TextBoxHandle skillNameTextBox;
var TextBoxHandle skillLevelTextBox;
var TextBoxHandle skillEnchantLvTextBox;
var TextBoxHandle skillLvStatusTextBox;
var TextBoxHandle needItemEmptyTextBox;
var HtmlHandle descHtml;
var RichListCtrlHandle needItemRichList;
var UIControlNeedItemList needItemScript;
var SkillWnd.skillSlotInfo _skillSlotInfo;
var array<SkillAcquireData> _skillAcquireData;
var array<int> _blockSkills;
var int _currentLevel;
var int _maxLevel;
var int _canLearnLevel;
var INT64 _haveSP;
var FindCostItemInfo _findCostItemInfo;
var bool _isWaitingLearnResponse;

static function SkillInfoWnd Inst()
{
	return SkillInfoWnd(GetScript("SkillInfoWnd"));
}

function Initialize()
{
	InitControls();
	return;
}

function InitControls()
{
	local string ownerFullPath;
	local WindowHandle needItemWnd;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	skillItemWnd = GetItemWindowHandle((ownerFullPath $ ".SkillItem_ItemWindow"));
	skillNameTextBox = GetTextBoxHandle((ownerFullPath $ ".SkillName_Txt"));
	skillLevelTextBox = GetTextBoxHandle((ownerFullPath $ ".SkillLevel_Txt"));
	skillLvStatusTextBox = GetTextBoxHandle((ownerFullPath $ ".SkillLevelStatus_Txt"));
	skillEnchantLvTextBox = GetTextBoxHandle((ownerFullPath $ ".SkillEnchantNum_Txt"));
	levelPrevBtn = GetButtonHandle((ownerFullPath $ ".Left_Btn"));
	levelNextBtn = GetButtonHandle((ownerFullPath $ ".Right_Btn"));
	descHtml = GetHtmlHandle((ownerFullPath $ ".SkillDescription_Txt"));
	learnBtn = GetButtonHandle((ownerFullPath $ ".Dialog_Learn_Btn"));
	EnchantBtn = GetButtonHandle((ownerFullPath $ ".Dialog_Enchant_Btn"));
	enchantExtractBtn = GetButtonHandle((ownerFullPath $ ".Dialog_EnchantExtract_Btn"));
	levelPrevAnimTex = GetTextureHandle((ownerFullPath $ ".LeftBtn_Ani"));
	levelNextAnimTex = GetTextureHandle((ownerFullPath $ ".RightBtn_Ani"));
	dialogContainerWnd = GetWindowHandle((ownerFullPath $ ".Popup_Wnd"));
	learnDialogWnd = GetWindowHandle((dialogContainerWnd.m_WindowNameWithFullPath $ ".SkillLearnPopup_Wnd"));
	errorDialogWnd = GetWindowHandle((dialogContainerWnd.m_WindowNameWithFullPath $ ".Error_Wnd"));
	needItemWnd = GetWindowHandle((ownerFullPath $ ".Cost_Wnd"));
	needItemWnd.SetScript("UIControlNeedItemList");
	needItemScript = UIControlNeedItemList(needItemWnd.GetScript());
	needItemRichList = GetRichListCtrlHandle((needItemWnd.m_WindowNameWithFullPath $ ".Cost_RichListCtrl"));
	needItemScript.SetRichListControler(needItemRichList);
	needItemRichList.SetSelectedSelTooltip(false);
	needItemRichList.SetAppearTooltipAtMouseX(true);
	needItemRichList.SetTooltipType("SkillLearnCostListTooltip");
	needItemScript.DelegateOnClickButton = OnCostListButtonClicked;
	refreshBtn = GetButtonHandle((needItemWnd.m_WindowNameWithFullPath $ ".Refresh_Btn"));
	needItemEmptyTextBox = GetTextBoxHandle((needItemWnd.m_WindowNameWithFullPath $ ".Empty_Txt"));
	needItemLearnNoticeWnd = GetWindowHandle((needItemWnd.m_WindowNameWithFullPath $ ".Shortcut_Wnd"));
	needItemLearnNoticeWnd.HideWindow();
	HideLevelNaviBtnAnimTex();
	return;
}

function OpenWindow(SkillWnd.skillSlotInfo skillSlotInfo, optional bool isShowSkillLearnPage)
{
	CloseDialog();
	SetInfo(skillSlotInfo, isShowSkillLearnPage);
	Me.ShowWindow();
	return;
}

function SetInfo(SkillWnd.skillSlotInfo skillSlotInfo, optional bool isShowSkillLearnPage)
{
	local UserInfo UserInfo;
	local SkillAcquireData acquireData;

	_isWaitingLearnResponse = false;
	_skillSlotInfo = skillSlotInfo;
	_currentLevel = skillSlotInfo.SkillInfo.SkillLevel;
	_blockSkills.Length = 0;
	if(GetPlayerInfo(UserInfo))
	{
		_haveSP = UserInfo.nSP;
		_canLearnLevel = -1;
		_maxLevel = GetSkillAcquireList(UserInfo.nSubClass, skillSlotInfo.SkillInfo.SkillID, _skillAcquireData, _blockSkills);
		if((_maxLevel == 0))
		{
			_maxLevel = _currentLevel;
		}
		if((_skillSlotInfo.learned == false))
		{
			acquireData = GetSkillAcquireData(skillSlotInfo.SkillInfo.SkillLevel);
			if((int(acquireData.GetLevel) <= UserInfo.nLevel))
			{
				_canLearnLevel = skillSlotInfo.SkillInfo.SkillLevel;
			}
		}
		else if((_maxLevel > skillSlotInfo.SkillInfo.SkillLevel))
		{
			acquireData = GetSkillAcquireData((skillSlotInfo.SkillInfo.SkillLevel + 1));
			if((int(acquireData.GetLevel) <= UserInfo.nLevel))
			{
				_canLearnLevel = (skillSlotInfo.SkillInfo.SkillLevel + 1);
			}
		}
	}
	if((isShowSkillLearnPage == true))
	{
		if((_canLearnLevel > 0))
		{
			_currentLevel = _canLearnLevel;
		}
	}
	UpdateUIControls();
	return;
}

function ResetFindCostItemInfo()
{
	local FindCostItemInfo defaultInfo;

	_findCostItemInfo = defaultInfo;
	return;
}

function SetCurrentSkillLevel(int targetSkill)
{
	_currentLevel = targetSkill;
	UpdateUIControls();
	return;
}

function SkillAcquireData GetSkillAcquireData(int Level)
{
	local SkillAcquireData acquireData;
	local int Index;

	Index = (Level - 1);
	if(((Index >= 0) && (Index < _skillAcquireData.Length)))
	{
		acquireData = _skillAcquireData[Index];
	}
	return acquireData;
}

function int GetCurrentSkillId()
{
	if(Me.IsShowWindow())
	{
		return _skillSlotInfo.SkillInfo.SkillID;
	}
	else
	{
		return 0;
	}
}

function ShowLearnDialog()
{
	local int i;
	local ItemWindowHandle skillItemWnd;
	local TextBoxHandle skillNameTextBox, currentLvTextBox, nextLvTextBox, firstLearnTextBox;
	local TextureHandle arrowTex;
	local ItemInfo skillItemInfo;
	local RichListCtrlHandle deleteSkillRichList;
	local RichListCtrlRowData rowData;
	local L2Util util;
	local SkillInfo tempSkillInfo;
	local WindowHandle blockSkillEmptyWnd;
	local string currentSkillName, nextSkillName;

	util = L2Util(GetScript("L2Util"));
	skillItemWnd = GetItemWindowHandle((learnDialogWnd.m_WindowNameWithFullPath $ ".SkillItem_ItemWindow"));
	skillNameTextBox = GetTextBoxHandle((learnDialogWnd.m_WindowNameWithFullPath $ ".SkillName_Txt"));
	currentLvTextBox = GetTextBoxHandle((learnDialogWnd.m_WindowNameWithFullPath $ ".PrvLevelNum_Txt"));
	nextLvTextBox = GetTextBoxHandle((learnDialogWnd.m_WindowNameWithFullPath $ ".NextLevelNum_Txt"));
	deleteSkillRichList = GetRichListCtrlHandle((learnDialogWnd.m_WindowNameWithFullPath $ ".DeleteSkill_RichListCtrl"));
	firstLearnTextBox = GetTextBoxHandle((learnDialogWnd.m_WindowNameWithFullPath $ ".First_Txt"));
	arrowTex = GetTextureHandle((learnDialogWnd.m_WindowNameWithFullPath $ ".Arrow_Tex"));
	blockSkillEmptyWnd = GetWindowHandle((learnDialogWnd.m_WindowNameWithFullPath $ ".NoDeleteSkill_Wnd"));
	deleteSkillRichList.SetSelectedSelTooltip(false);
	deleteSkillRichList.SetSelectable(false);
	deleteSkillRichList.SetTooltipType("UIControlNeedItemList");
	currentSkillName = _skillSlotInfo.skillItemInfo.Name;
	if((_skillSlotInfo.SkillInfo.LevelHide == false))
	{
		currentSkillName = (currentSkillName @ Class'InterfaceClassic.SkillEnchantWnd'.static.Inst().GetSkillLevelStr(_skillSlotInfo.SkillInfo.SkillLevel));
	}
	skillNameTextBox.SetText(currentSkillName);
	if((_skillSlotInfo.learned == false))
	{
		firstLearnTextBox.ShowWindow();
		arrowTex.HideWindow();
		currentLvTextBox.HideWindow();
		nextLvTextBox.HideWindow();
		skillNameTextBox.ShowWindow();
	}
	else
	{
		GetSkillInfo(_skillSlotInfo.SkillInfo.SkillID, (_skillSlotInfo.SkillInfo.SkillLevel + 1), 0, tempSkillInfo);
		nextSkillName = tempSkillInfo.SkillName;
		if((_skillSlotInfo.SkillInfo.LevelHide == false))
		{
			nextSkillName = (nextSkillName @ Class'InterfaceClassic.SkillEnchantWnd'.static.Inst().GetSkillLevelStr((_skillSlotInfo.SkillInfo.SkillLevel + 1)));
		}
		currentLvTextBox.SetText(currentSkillName);
		nextLvTextBox.SetText(nextSkillName);
		firstLearnTextBox.HideWindow();
		arrowTex.ShowWindow();
		currentLvTextBox.ShowWindow();
		nextLvTextBox.ShowWindow();
		skillNameTextBox.HideWindow();
	}
	skillItemInfo.IconName = _skillSlotInfo.skillItemInfo.IconName;
	if(!skillItemWnd.SetItem(0, skillItemInfo))
	{
		skillItemWnd.AddItem(skillItemInfo);
	}
	rowData.cellDataList.Length = 1;
	deleteSkillRichList.DeleteAllItem();
	if(((_blockSkills.Length > 0) && (_skillSlotInfo.learned == false)))
	{
		i = 0;
		while((i < _blockSkills.Length))
		{
			GetSkillInfo(_blockSkills[i], 1, 0, tempSkillInfo);
			util.GetSkill2ItemInfo(tempSkillInfo, skillItemInfo);
			rowData.cellDataList[0].drawitems.Length = 0;
			AddRichListCtrlSkill(rowData.cellDataList[0].drawitems, skillItemInfo);
			AddRichListCtrlString(rowData.cellDataList[0].drawitems, skillItemInfo.Name, util.White, false, 10, 8);
			deleteSkillRichList.InsertRecord(rowData);
			i++;
		}
		blockSkillEmptyWnd.HideWindow();
	}
	else
	{
		blockSkillEmptyWnd.ShowWindow();
	}
	if((((blockSkillEmptyWnd.IsShowWindow() == false) || (_findCostItemInfo.ConsumeAdena > INT64(0))) || (_findCostItemInfo.ConsumeItemID > 0)))
	{
		learnDialogWnd.ShowWindow();
		dialogContainerWnd.ShowWindow();
	}
	else
	{
		RequestLearnSkill();
	}
	return;
}

function ShowErrorDialog(int errorStrId)
{
	local string errorDesc;
	local TextBoxHandle descTextBox;

	descTextBox = GetTextBoxHandle((errorDialogWnd.m_WindowNameWithFullPath $ ".Description_Txt"));
	if((errorStrId == 0))
	{
		errorDesc = GetSystemMessage(4559);
	}
	else
	{
		errorDesc = GetSystemMessage(errorStrId);
	}
	descTextBox.SetText(errorDesc);
	errorDialogWnd.ShowWindow();
	dialogContainerWnd.ShowWindow();
	return;
}

function CloseDialog()
{
	learnDialogWnd.HideWindow();
	errorDialogWnd.HideWindow();
	dialogContainerWnd.HideWindow();
	return;
}

function HideLevelNaviBtnAnimTex()
{
	levelPrevAnimTex.HideWindow();
	levelNextAnimTex.HideWindow();
	return;
}

function string AddHtmlNewLine(string sourceStr, string addStr)
{
	if((addStr == ""))
	{
		return sourceStr;
	}
	return ((sourceStr $ "<br1>") $ addStr);
}

function string AddHtmlSkillStatInfo(string sourceStr, int statNameId, string statValue, optional bool notUseValueColor)
{
	local string statStr, valueStr;

	if(notUseValueColor)
	{
		valueStr = statValue;
	}
	else
	{
		valueStr = htmlAddText(statValue, "", "b09b79");
	}
	statStr = ((htmlAddText(GetSystemString(statNameId), "", "a3a3a3") $ ":") @ valueStr);
	return AddHtmlNewLine(sourceStr, statStr);
}

function string AddHtmlDescCrossLine(string sourceStr)
{
	if((sourceStr == ""))
	{
		return "";
	}
	return (sourceStr $ "<br1><img src = \"L2ui_ch3.tooltip_line\" width = 380 height = 1><br>");
}

function string ConvertHtmlDesc(SkillInfo SkillInfo, SkillWnd.skillSlotInfo skillSlotInfo, SkillAcquireData acquireData)
{
	local string htmlStr, skillInfoA, skillInfoB, skillInfoC, SkillDesc, tempStr;
	local UserInfo UserInfo;
	local L2Util util;
	local int ConsumeItemCount, consumeClassID;

	util = L2Util(GetScript("L2Util"));
	GetPlayerInfo(UserInfo);
	SkillDesc = SkillInfo.SkillDesc;
	SkillDesc = Substitute(SkillDesc, "<", "&lt;", false);
	SkillDesc = Substitute(SkillDesc, ">", "&gt;", false);
	SkillDesc = Substitute(SkillDesc, "&lt;font", "<font", false);
	SkillDesc = Substitute(SkillDesc, "\"&gt;", "\">", false);
	SkillDesc = Substitute(SkillDesc, "&lt;/font&gt;", "</font>", false);
	SkillDesc = Substitute(SkillDesc, "\\n\\n", "<br>", false);
	SkillDesc = Substitute(SkillDesc, "\\n", "<br1>", false);
	SkillDesc = AddHtmlDescCrossLine(SkillDesc);
	htmlStr = AddHtmlNewLine(htmlStr, ("<br>" $ SkillDesc));
	skillInfoA = AddHtmlSkillStatInfo(skillInfoA, 14374, getSkillTypeString(SkillInfo.IconType));
	if((int(acquireData.GetLevel) > 0))
	{
		if((int(acquireData.GetLevel) > UserInfo.nLevel))
		{
			skillInfoA = AddHtmlSkillStatInfo(skillInfoA, 14375, htmlAddText(string(acquireData.GetLevel), "", "FF0000"), true);
		}
		else
		{
			skillInfoA = AddHtmlSkillStatInfo(skillInfoA, 14375, htmlAddText(string(acquireData.GetLevel), ""), true);
		}
	}
	skillInfoA = AddHtmlDescCrossLine(skillInfoA);
	htmlStr = AddHtmlNewLine(htmlStr, skillInfoA);
	if((SkillInfo.MpConsume > 0))
	{
		skillInfoB = AddHtmlSkillStatInfo(skillInfoB, 7503, string(SkillInfo.MpConsume));
	}
	if((SkillInfo.HpConsume > 0))
	{
		skillInfoB = AddHtmlSkillStatInfo(skillInfoB, 7504, string(SkillInfo.HpConsume));
	}
	if((SkillInfo.DpConsume > 0))
	{
		skillInfoB = AddHtmlSkillStatInfo(skillInfoB, 13578, string(SkillInfo.DpConsume));
	}
	if((SkillInfo.EnergyConsume > 0))
	{
		skillInfoB = AddHtmlSkillStatInfo(skillInfoB, 13579, string(SkillInfo.EnergyConsume));
	}
	Class'NWindow.UIDATA_SKILL'.static.GetMSCondItem(SkillInfo.SkillID, SkillInfo.SkillLevel, SkillInfo.SkillSubLevel, consumeClassID, ConsumeItemCount);
	if((consumeClassID > 0))
	{
		skillInfoB = AddHtmlSkillStatInfo(skillInfoB, 13580, MakeFullSystemMsg(GetSystemMessage(1983), ((Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(consumeClassID)) $ " ") $ string(ConsumeItemCount))));
	}
	skillInfoB = AddHtmlDescCrossLine(skillInfoB);
	htmlStr = AddHtmlNewLine(htmlStr, skillInfoB);
	if(((SkillInfo.CastRange >= 0) && (SkillInfo.CastRange < 1300)))
	{
		skillInfoC = AddHtmlSkillStatInfo(skillInfoC, 321, string(SkillInfo.CastRange));
	}
	if((skillSlotInfo.isActiveSkill && (SkillInfo.CoolTime > 0.0000000)))
	{
		skillInfoC = AddHtmlSkillStatInfo(skillInfoC, 2377, util.MakeTimeString(SkillInfo.HitTime, SkillInfo.CoolTime));
	}
	if((skillSlotInfo.isActiveSkill && (SkillInfo.ReuseDelay > 0.0000000)))
	{
		skillInfoC = AddHtmlSkillStatInfo(skillInfoC, 14376, util.MakeTimeString(SkillInfo.ReuseDelay));
	}
	if((SkillInfo.AbnormalTime > 0))
	{
		skillInfoC = AddHtmlSkillStatInfo(skillInfoC, 13582, util.GetTimeStringBySec5(float(SkillInfo.AbnormalTime)));
	}
	tempStr = getSkillTargetTypeString(SkillInfo.TargetType);
	if((tempStr != ""))
	{
		skillInfoC = AddHtmlSkillStatInfo(skillInfoC, 13584, tempStr);
	}
	tempStr = getSkillAffectTypeString(SkillInfo.AffectScope);
	if((tempStr != ""))
	{
		skillInfoC = AddHtmlSkillStatInfo(skillInfoC, 13585, tempStr);
	}
	tempStr = getSkillEquipNameStr(SkillInfo.SkillID, SkillInfo.SkillLevel, SkillInfo.SkillSubLevel);
	if((tempStr != ""))
	{
		skillInfoC = AddHtmlSkillStatInfo(skillInfoC, 13586, tempStr);
	}
	htmlStr = AddHtmlNewLine(htmlStr, skillInfoC);
	htmlStr = htmlSetHtmlStart(htmlStr);
	return htmlStr;
}

function UpdateSkillInfoControls()
{
	local ItemInfo skillItemInfo;
	local int validSkillSubLevel, validEnchantLevel;
	local SkillInfo validSkillInfo;
	local SkillAcquireData acquireData;
	local UserInfo UserInfo;

	GetPlayerInfo(UserInfo);
	acquireData = GetSkillAcquireData(_currentLevel);
	if((_skillSlotInfo.SkillInfo.SkillLevel <= _currentLevel))
	{
		validSkillSubLevel = _skillSlotInfo.SkillInfo.SkillSubLevel;
		validEnchantLevel = _skillSlotInfo.enchantLevel;
	}
	else
	{
		validSkillSubLevel = 0;
		validEnchantLevel = 0;
	}
	if((_skillSlotInfo.replaceSkillId >= 0))
	{
		GetSkillInfo(_skillSlotInfo.replaceSkillId, _currentLevel, validSkillSubLevel, validSkillInfo);
	}
	else
	{
		GetSkillInfo(_skillSlotInfo.SkillInfo.SkillID, _currentLevel, validSkillSubLevel, validSkillInfo);
	}
	skillEnchantLvTextBox.SetText(Class'InterfaceClassic.SkillEnchantWnd'.static.Inst().GetEnchantLvName(validEnchantLevel));
	if((skillEnchantLvTextBox.GetText() == ""))
	{
		skillEnchantLvTextBox.SetWindowSize(0, skillEnchantLvTextBox.GetRect().nHeight);
	}
	else
	{
		skillEnchantLvTextBox.SetText((skillEnchantLvTextBox.GetText() $ " "));
	}
	skillNameTextBox.SetText(validSkillInfo.SkillName);
	if((validSkillInfo.LevelHide == true))
	{
		skillLevelTextBox.SetText("");
	}
	else
	{
		skillLevelTextBox.SetText(Class'InterfaceClassic.SkillEnchantWnd'.static.Inst().GetSkillLevelStr(_currentLevel));
	}
	descHtml.LoadHtmlFromString(ConvertHtmlDesc(validSkillInfo, _skillSlotInfo, acquireData));
	skillItemInfo.IconName = validSkillInfo.TexName;
	if((_currentLevel == _canLearnLevel))
	{
		skillLvStatusTextBox.SetText((("(" $ GetSystemString(14371)) $ ")"));
		skillLvStatusTextBox.SetFontColor(GetColor(119, 255, 153, 255));
	}
	else if((int(acquireData.GetLevel) > UserInfo.nLevel))
	{
		skillItemInfo.bDisabled = 1;
		skillLvStatusTextBox.SetText("");
	}
	else if(((validSkillInfo.LevelHide == false) && (_currentLevel == _skillSlotInfo.SkillInfo.SkillLevel)))
	{
		skillLvStatusTextBox.SetText((("(" $ GetSystemString(14370)) $ ")"));
		skillLvStatusTextBox.SetFontColor(GetColor(170, 153, 119, 255));
	}
	else
	{
		skillLvStatusTextBox.SetText("");
	}
	if(!skillItemWnd.SetItem(0, skillItemInfo))
	{
		skillItemWnd.AddItem(skillItemInfo);
	}
	HideLevelNaviBtnAnimTex();
	if(Class'InterfaceClassic.SkillWnd'.static.Inst().IsEnchantExtractTabSelected())
	{
		enchantExtractBtn.ShowWindow();
		learnBtn.HideWindow();
		EnchantBtn.HideWindow();
		if(_skillSlotInfo.isCanEnchantExtract)
		{
			enchantExtractBtn.SetEnable(true);
		}
		else
		{
			enchantExtractBtn.SetEnable(false);
		}
	}
	else
	{
		learnBtn.ShowWindow();
		enchantExtractBtn.HideWindow();
		if((_skillSlotInfo.isEnchantSkill == true))
		{
			learnBtn.SetAnchor("SkillInfoWnd", "BottomCenter", "BottomRight", -2, -5);
			EnchantBtn.ShowWindow();
			EnchantBtn.SetEnable(true);
		}
		else
		{
			learnBtn.SetAnchor("SkillInfoWnd", "BottomCenter", "BottomRight", 70, -5);
			EnchantBtn.HideWindow();
			EnchantBtn.SetEnable(false);
		}
	}
	if((_maxLevel == 1))
	{
		levelPrevBtn.SetEnable(false);
		levelNextBtn.SetEnable(false);
	}
	else if((_currentLevel == _maxLevel))
	{
		levelPrevBtn.SetEnable(true);
		levelNextBtn.SetEnable(false);
	}
	else if((_currentLevel == 1))
	{
		levelPrevBtn.SetEnable(false);
		levelNextBtn.SetEnable(true);
	}
	else
	{
		levelPrevBtn.SetEnable(true);
		levelNextBtn.SetEnable(true);
	}
	if((_canLearnLevel > 0))
	{
		if((_currentLevel < _canLearnLevel))
		{
			levelNextAnimTex.ShowWindow();
		}
		else if((_currentLevel > _canLearnLevel))
		{
			levelPrevAnimTex.ShowWindow();
		}
	}
	return;
}

function UpdateCostInfoControls()
{
	local SkillAcquireData acquireData;
	local ItemInfo needItemInfo;
	local UserInfo UserInfo;
	local int levelIndex, needItemListIndex;
	local bool learned;
	local string texturePath;
	local RichListCtrlRowData rowData;
	local INT64 consumePriorityInvenCnt, consumeInvenCnt;
	local bool needLearnBtnTooltip;

	needItemScript.StartNeedItemList(2);
	levelIndex = (_currentLevel - 1);
	needItemListIndex = -1;
	ResetFindCostItemInfo();
	if(((_skillSlotInfo.learned == true) && (_currentLevel <= _skillSlotInfo.SkillInfo.SkillLevel)))
	{
		learned = true;
	}
	if(((levelIndex >= 0) && (levelIndex < _skillAcquireData.Length)))
	{
		acquireData = _skillAcquireData[levelIndex];
		if((learned == false))
		{
			_findCostItemInfo.MultisellID = acquireData.MultisellGroupID;
			_findCostItemInfo.SystemMsgID = acquireData.SystemMsgID;
			if((acquireData.ConsumeSP > INT64(0)))
			{
				GetPlayerInfo(UserInfo);
				needItemInfo = GetItemInfoByClassID(15624);
				needItemScript.AddNeedPoint(needItemInfo.Name, needItemInfo.IconName, acquireData.ConsumeSP, _haveSP);
			}
			if((acquireData.ConsumeAdena > INT64(0)))
			{
				needItemScript.AddNeedItemClassID(57, acquireData.ConsumeAdena);
				_findCostItemInfo.ConsumeAdena = acquireData.ConsumeAdena;
			}
			if(((acquireData.ConsumeItemID > 0) && (acquireData.ConsumeItemCount > 0)))
			{
				_findCostItemInfo.findName = GetItemInfoByClassID(acquireData.ConsumeItemID).Name;
				_findCostItemInfo.findCategory = int(acquireData.CategoryIndex);
				_findCostItemInfo.ConsumeItemID = acquireData.ConsumeItemID;
				if(((acquireData.ConsumePriorityItemID > 0) && (acquireData.ConsumePriorityItemCount > 0)))
				{
					needLearnBtnTooltip = true;
					consumePriorityInvenCnt = GetInventoryItemCount(GetItemID(acquireData.ConsumePriorityItemID));
					consumeInvenCnt = GetInventoryItemCount(GetItemID(acquireData.ConsumeItemID));
					needItemScript.AddNeeItemInfo(GetItemInfoByClassID(acquireData.ConsumeItemID), INT64(acquireData.ConsumeItemCount), (consumePriorityInvenCnt + consumeInvenCnt));
				}
				else
				{
					needItemScript.AddNeedItemClassID(acquireData.ConsumeItemID, INT64(acquireData.ConsumeItemCount));
				}
				needItemListIndex = (needItemRichList.GetRecordCount() - 1);
			}
		}
	}
	needItemLearnNoticeWnd.HideWindow();
	if((needItemRichList.GetRecordCount() > 0))
	{
		needItemEmptyTextBox.HideWindow();
	}
	else if((learned == true))
	{
		if((_canLearnLevel > 0))
		{
			needItemLearnNoticeWnd.ShowWindow();
			needItemEmptyTextBox.HideWindow();
		}
		else
		{
			needItemEmptyTextBox.SetText(GetSystemString(14392));
			needItemEmptyTextBox.ShowWindow();
		}
	}
	else
	{
		needItemEmptyTextBox.SetText(GetSystemString(13466));
		needItemEmptyTextBox.ShowWindow();
	}
	if((needItemListIndex >= 0))
	{
		needItemRichList.GetRec(needItemListIndex, rowData);
		rowData.nReserved1 = INT64(acquireData.ConsumePriorityItemID);
		rowData.nReserved2 = INT64(acquireData.ConsumeItemID);
		rowData.nReserved3 = INT64(acquireData.SystemMsgID);
		if(((((((acquireData.SystemMsgID == 0) || (acquireData.SystemMsgID == 13857)) || (acquireData.SystemMsgID == 13858)) || (acquireData.SystemMsgID == 13859)) || (acquireData.SystemMsgID == 13860)) || (acquireData.SystemMsgID == 13902)))
		{
			AddRichListCtrlString(rowData.cellDataList[0].drawitems, "", , true);
			AddRichListCtrlButton(rowData.cellDataList[0].drawitems, "skillCostItemBackBtn", -20, -40, "L2UI_CT1.EmptyBtn", "L2UI_NewTex.Button.List_Down", "L2UI_NewTex.Button.List_Over", 400, 40, 322, 40, -1);
			texturePath = "L2UI_NewTex.SkillWnd.Icon_Magnifier";
		}
		else
		{
			texturePath = "L2UI_NewTex.SkillWnd.Icon_Help";
		}
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, "", , true);
		addRichListCtrlTexture(rowData.cellDataList[0].drawitems, texturePath, 20, 20, 354, -28, 20, 20);
		if(((acquireData.ConsumePriorityItemID > 0) && (acquireData.ConsumePriorityItemCount > 0)))
		{
			AddRichListCtrlString(rowData.cellDataList[0].drawitems, "", , true);
			addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_NewTex.SkillWnd.Icon_Substitution", 20, 20, 330, -20, 20, 20);
		}
		needItemRichList.DeleteRecord(needItemListIndex);
		needItemRichList.InsertRecord(rowData);
	}
	needItemScript.SetBuyNum(INT64(1));
	if((_currentLevel == _canLearnLevel))
	{
		if((needItemRichList.GetRecordCount() > 0))
		{
			if((needItemScript.GetMaxNumCanBuy() > INT64(0)))
			{
				learnBtn.SetEnable(true);
			}
			else
			{
				learnBtn.SetEnable(false);
			}
		}
		else
		{
			learnBtn.SetEnable(true);
		}
	}
	else
	{
		learnBtn.SetEnable(false);
	}
	if(needLearnBtnTooltip)
	{
		learnBtn.SetTooltipType("Text");
		learnBtn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14402)));
	}
	else
	{
		learnBtn.ClearTooltip();
	}
	return;
}

function UpdateUIControls()
{
	UpdateSkillInfoControls();
	UpdateCostInfoControls();
	return;
}

function UpdateFromSkillWndInfo(int SkillID)
{
	local SkillWnd.skillSlotInfo slotInfo;

	if((SkillID == 0))
	{
		return;
	}
	if(Class'InterfaceClassic.SkillWnd'.static.Inst().FindSkillSlotInfo(SkillID, slotInfo))
	{
		SetInfo(slotInfo);
	}
	return;
}

function RequestLearnSkill()
{
	if(((_skillSlotInfo.SkillInfo.SkillID > 0) && (_canLearnLevel > 0)))
	{
		Debug(((("RequestLearnSkill" @ string(_skillSlotInfo.SkillInfo.SkillID)) @ string(_canLearnLevel)) @ string(_skillSlotInfo.SkillInfo.SkillSubLevel)));
		RequestAcquireSkill(_skillSlotInfo.SkillInfo.SkillID, _canLearnLevel, _skillSlotInfo.SkillInfo.SkillSubLevel, 0);
		_isWaitingLearnResponse = true;
	}
	return;
}

function Rq_C_EX_MULTI_SELL_LIST(int MultisellID)
{
	local array<byte> stream;
	local UIPacket._C_EX_MULTI_SELL_LIST packet;

	packet.nGroupID = MultisellID;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_MULTI_SELL_LIST(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(624, stream);
	return;
}

function Nt_S_EX_ACQUIRE_SKILL_RESULT()
{
	local string skillNameStr;
	local UIPacket._S_EX_ACQUIRE_SKILL_RESULT packet;
	local SkillInfo tmpSkillInfo;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_ACQUIRE_SKILL_RESULT(packet))
	{
		return;
	}
	Debug((((("Nt_S_EX_ACQUIRE_SKILL_RESULT" @ string(packet.cResult)) @ string(packet.nLevel)) @ string(packet.nSkillID)) @ string(packet.nSysMsg)));
	if((packet.nSkillID != _skillSlotInfo.SkillInfo.SkillID))
	{
		Me.HideWindow();
	}
	if((packet.cResult == 0))
	{
		_skillSlotInfo.SkillInfo.SkillLevel = packet.nLevel;
		_skillSlotInfo.learned = true;
		SetInfo(_skillSlotInfo);
		OnPageNavigateBtnClicked(true);
		GetSkillInfo(_skillSlotInfo.SkillInfo.SkillID, packet.nLevel, 0, tmpSkillInfo);
		if(tmpSkillInfo.LevelHide)
		{
			skillNameStr = tmpSkillInfo.SkillName;
		}
		else
		{
			skillNameStr = (tmpSkillInfo.SkillName @ Class'InterfaceClassic.SkillEnchantWnd'.static.Inst().GetSkillLevelStr(packet.nLevel));
		}
		getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(13817), skillNameStr));
	}
	else
	{
		ShowErrorDialog(packet.nSysMsg);
	}
	_isWaitingLearnResponse = false;
	return;
}

function Nt_EV_UpdateUserInfo()
{
	local UserInfo UserInfo;

	GetPlayerInfo(UserInfo);
	if((_haveSP != UserInfo.nSP))
	{
		_haveSP = UserInfo.nSP;
		if((Me.IsShowWindow() && (_skillSlotInfo.SkillInfo.SkillID > 0)))
		{
			UpdateCostInfoControls();
		}
	}
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(1090));
	RegisterEvent(180);
	return;
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case EV_PacketID(1090):
			Nt_S_EX_ACQUIRE_SKILL_RESULT();
			break;
		case 180:
			Nt_EV_UpdateUserInfo();
			break;
		default:
			break;
	}
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "Left_Btn":
			OnPageNavigateBtnClicked(false);
			break;
		case "Right_Btn":
			OnPageNavigateBtnClicked(true);
			break;
		case "Dialog_Learn_Btn":
			if((_isWaitingLearnResponse == false))
			{
				ShowLearnDialog();
			}
			break;
		case "Dialog_Enchant_Btn":
			getInstanceL2Util().syncWindowLoc("SkillWnd", "SkillEnchantWnd");
			Class'InterfaceClassic.SkillEnchantWnd'.static.Inst().OpenWindow(_skillSlotInfo.SkillInfo.SkillID, _skillSlotInfo.SkillInfo.SkillLevel, _skillSlotInfo.SkillInfo.SkillSubLevel, _skillSlotInfo.replaceSkillId);
			break;
		case "Dialog_EnchantExtract_Btn":
			getInstanceL2Util().syncWindowLoc("SkillWnd", "SkillEnchantExtractWnd", 100, 30);
			Class'InterfaceClassic.SkillEnchantExtractWnd'.static.Inst().OpenWindow(_skillSlotInfo.SkillInfo.SkillID, _skillSlotInfo.SkillInfo.SkillLevel, _skillSlotInfo.SkillInfo.SkillSubLevel, 0, _skillSlotInfo.replaceSkillId, 0, true);
			break;
		case "LearnDialog_Ok_Btn":
			RequestLearnSkill();
			CloseDialog();
			break;
		case "LearnDialog_Cancel_Btn":
			CloseDialog();
			break;
		case "ErrorDialog_Ok_Btn":
			CloseDialog();
			break;
		default:
			break;
	}
	return;
}

event OnCostListButtonClicked(string btnName)
{
	switch(btnName)
	{
		case "skillCostItemFindBtn":
		case "skillCostItemBackBtn":
			OnSkillCostItemFindBtnClicked();
			break;
		case "Refresh_Btn":
			UpdateCostInfoControls();
			break;
		case "GoNow_Btn":
			OnSkillLearnPageMoveClicked();
			break;
		default:
			break;
	}
	return;
}

event OnPageNavigateBtnClicked(bool isNext)
{
	local int TargetLevel;

	TargetLevel = _currentLevel;
	if(isNext)
	{
		if((TargetLevel != _maxLevel))
		{
			TargetLevel++;
		}
	}
	else if((TargetLevel != 1))
	{
		TargetLevel--;
	}
	SetCurrentSkillLevel(TargetLevel);
	return;
}

event OnSkillCostItemFindBtnClicked()
{
	local string findName;

	if(((_findCostItemInfo.findCategory > 0) && ((((_findCostItemInfo.SystemMsgID == 13857) || (_findCostItemInfo.SystemMsgID == 13858)) || (_findCostItemInfo.SystemMsgID == 13859)) || (_findCostItemInfo.SystemMsgID == 13860))))
	{
		if((_findCostItemInfo.SystemMsgID == 13857))
		{
			findName = GetItemInfoByClassID(97175).Name;
		}
		else if((_findCostItemInfo.SystemMsgID == 13858))
		{
			findName = GetItemInfoByClassID(97176).Name;
		}
		else if((_findCostItemInfo.SystemMsgID == 13859))
		{
			findName = GetItemInfoByClassID(97177).Name;
		}
		else if((_findCostItemInfo.SystemMsgID == 13860))
		{
			findName = GetItemInfoByClassID(97178).Name;
		}
		ShopLcoinCraftWnd(GetScript("ShopLcoinCraftWnd")).ShowAndFindItem(findName, (_findCostItemInfo.findCategory - 1));
		return;
	}
	if(((_findCostItemInfo.SystemMsgID > 0) && (_findCostItemInfo.SystemMsgID != 13902)))
	{
		return;
	}
	if((_findCostItemInfo.MultisellID > 0))
	{
		Rq_C_EX_MULTI_SELL_LIST(_findCostItemInfo.MultisellID);
		return;
	}
	if((_findCostItemInfo.findCategory > 0))
	{
		ShopLcoinCraftWnd(GetScript("ShopLcoinCraftWnd")).ShowAndFindItem(_findCostItemInfo.findName, (_findCostItemInfo.findCategory - 1));
	}
	return;
}

event OnSkillLearnPageMoveClicked()
{
	if(((_canLearnLevel > 0) && (_canLearnLevel <= _maxLevel)))
	{
		SetCurrentSkillLevel(_canLearnLevel);
	}
	return;
}

event OnLoad()
{
	Initialize();
	return;
}

event OnShow()
{
	CloseDialog();
	return;
}

event OnHide()
{
	needItemScript.CleariObjects();
	_isWaitingLearnResponse = false;
	return;
}

event OnReceivedCloseUI()
{
	if(dialogContainerWnd.IsShowWindow())
	{
		CloseDialog();
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		Me.HideWindow();
	}
	return;
}
