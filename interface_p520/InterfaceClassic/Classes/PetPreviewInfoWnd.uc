class PetPreviewInfoWnd extends UICommonAPI;

const SKILL_MIN_LEVEL = 1;

var WindowHandle Me;
var ButtonHandle levelPrevBtn;
var ButtonHandle levelNextBtn;
var TextureHandle levelPrevAnimTex;
var TextureHandle levelNextAnimTex;
var ItemWindowHandle skillItemWnd;
var TextBoxHandle skillNameTextBox;
var TextBoxHandle skillLevelTextBox;
var TextBoxHandle skillLvStatusTextBox;
var TextBoxHandle needItemEmptyTextBox;
var HtmlHandle descHtml;
var RichListCtrlHandle needItemRichList;
var UIControlNeedItemList needItemScript;
var PetSkillSlotInfo__PetPreviewWnd _skillSlotInfo;
var int _currentLevel;
var int _canLearnLevel;
var PetPreviewWnd.PetPreviewInfo _petPreviewInfo;

static function PetPreviewInfoWnd Inst()
{
	return PetPreviewInfoWnd(GetScript("PetPreviewInfoWnd"));
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
	levelPrevBtn = GetButtonHandle((ownerFullPath $ ".Left_Btn"));
	levelNextBtn = GetButtonHandle((ownerFullPath $ ".Right_Btn"));
	descHtml = GetHtmlHandle((ownerFullPath $ ".SkillDescription_Txt"));
	levelPrevAnimTex = GetTextureHandle((ownerFullPath $ ".LeftBtn_Ani"));
	levelNextAnimTex = GetTextureHandle((ownerFullPath $ ".RightBtn_Ani"));
	needItemWnd = GetWindowHandle((ownerFullPath $ ".Cost_Wnd"));
	needItemWnd.SetScript("UIControlNeedItemList");
	needItemScript = UIControlNeedItemList(needItemWnd.GetScript());
	needItemRichList = GetRichListCtrlHandle((needItemWnd.m_WindowNameWithFullPath $ ".Cost_RichListCtrl"));
	needItemScript.SetRichListControler(needItemRichList);
	needItemRichList.SetSelectedSelTooltip(false);
	needItemRichList.SetAppearTooltipAtMouseX(true);
	needItemRichList.SetTooltipType("PetSkillLearnCostListTooltip");
	needItemScript.SetHideMyNum(true);
	needItemEmptyTextBox = GetTextBoxHandle((needItemWnd.m_WindowNameWithFullPath $ ".Empty_Txt"));
	HideLevelNaviBtnAnimTex();
	return;
}

function OpenWindow(PetSkillSlotInfo__PetPreviewWnd skillSlotInfo)
{
	SetInfo(skillSlotInfo);
	Me.ShowWindow();
	return;
}

function SetInfo(PetSkillSlotInfo__PetPreviewWnd skillSlotInfo)
{
	local PetAcquireSkillInfo acquireData;

	_skillSlotInfo = skillSlotInfo;
	_currentLevel = skillSlotInfo.SkillInfo.SkillLevel;
	_canLearnLevel = -1;
	_petPreviewInfo = Class'InterfaceClassic.PetPreviewWnd'.static.Inst()._petPreviewInfo;
	if((_skillSlotInfo.learned == false))
	{
		Class'NWindow.PetAPI'.static.GetPetAcquireSkillInfo(_petPreviewInfo.PetID, skillSlotInfo.originalSkillId, skillSlotInfo.SkillInfo.SkillLevel, acquireData);
		if(((_petPreviewInfo.PetLevel >= acquireData.NeedPetLevel) && (_petPreviewInfo.petEnvolveStep >= acquireData.NeedPetEvolveStep)))
		{
			_canLearnLevel = skillSlotInfo.SkillInfo.SkillLevel;
		}
	}
	else if((skillSlotInfo.MaxLevel > skillSlotInfo.SkillInfo.SkillLevel))
	{
		Class'NWindow.PetAPI'.static.GetPetAcquireSkillInfo(_petPreviewInfo.PetID, skillSlotInfo.originalSkillId, (skillSlotInfo.SkillInfo.SkillLevel + 1), acquireData);
		if(((_petPreviewInfo.PetLevel >= acquireData.NeedPetLevel) && (_petPreviewInfo.petEnvolveStep >= acquireData.NeedPetEvolveStep)))
		{
			_canLearnLevel = (skillSlotInfo.SkillInfo.SkillLevel + 1);
		}
	}
	UpdateUIControls();
	return;
}

function SetCurrentSkillLevel(int targetSkill)
{
	_currentLevel = targetSkill;
	UpdateUIControls();
	return;
}

function int GetCurrentSkillId()
{
	if(Me.IsShowWindow())
	{
		return _skillSlotInfo.originalSkillId;
	}
	else
	{
		return 0;
	}
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
	return (sourceStr $ "<br1><img src = \"L2ui_ch3.tooltip_line\" width = 320 height = 1><br>");
}

function string ConvertHtmlDesc(SkillInfo SkillInfo, PetSkillSlotInfo__PetPreviewWnd skillSlotInfo, PetAcquireSkillInfo acquireData)
{
	local string htmlStr, skillInfoA, skillInfoB, skillInfoC, SkillDesc, tempStr, evolveName;
	local L2Util util;
	local int ConsumeItemCount, consumeClassID;

	util = L2Util(GetScript("L2Util"));
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
	if((acquireData.NeedPetLevel > 0))
	{
		if((acquireData.NeedPetLevel > _petPreviewInfo.PetLevel))
		{
			skillInfoA = AddHtmlSkillStatInfo(skillInfoA, 88, htmlAddText(string(acquireData.NeedPetLevel), "", "FF0000"), true);
		}
		else
		{
			skillInfoA = AddHtmlSkillStatInfo(skillInfoA, 88, htmlAddText(string(acquireData.NeedPetLevel), ""), true);
		}
	}
	if((acquireData.NeedPetEvolveStep > 0))
	{
		evolveName = GetSystemString(getInstanceL2Util().GetPetEvolveStepStringId(EPetType(Class'NWindow.PetAPI'.static.GetPetType(_petPreviewInfo.PetID)), acquireData.NeedPetEvolveStep));
		if((acquireData.NeedPetEvolveStep > _petPreviewInfo.petEnvolveStep))
		{
			skillInfoA = AddHtmlSkillStatInfo(skillInfoA, 14808, htmlAddText(evolveName, "", "FF0000"), true);
		}
		else
		{
			skillInfoA = AddHtmlSkillStatInfo(skillInfoA, 14808, htmlAddText(evolveName, ""), true);
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
		skillInfoC = AddHtmlSkillStatInfo(skillInfoC, 14376, util.GetTimeStringBySec5(SkillInfo.ReuseDelay));
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
	local SkillInfo validSkillInfo;
	local PetAcquireSkillInfo acquireInfo;

	Class'NWindow.PetAPI'.static.GetPetAcquireSkillInfo(_petPreviewInfo.PetID, _skillSlotInfo.originalSkillId, _currentLevel, acquireInfo);
	if((_skillSlotInfo.replaceSkillId > 0))
	{
		GetSkillInfo(_skillSlotInfo.replaceSkillId, _currentLevel, 0, validSkillInfo);
	}
	else
	{
		GetSkillInfo(_skillSlotInfo.originalSkillId, _currentLevel, 0, validSkillInfo);
	}
	skillNameTextBox.SetText(validSkillInfo.SkillName);
	if((validSkillInfo.LevelHide == true))
	{
		skillLevelTextBox.SetText("");
	}
	else
	{
		skillLevelTextBox.SetText(GetSkillLevelStr(_currentLevel));
	}
	descHtml.LoadHtmlFromString(ConvertHtmlDesc(validSkillInfo, _skillSlotInfo, acquireInfo));
	skillItemInfo.IconName = validSkillInfo.TexName;
	if((_currentLevel == _canLearnLevel))
	{
		skillLvStatusTextBox.SetText((("(" $ GetSystemString(14371)) $ ")"));
		skillLvStatusTextBox.SetFontColor(GetColor(119, 255, 153, 255));
	}
	else if(((_petPreviewInfo.PetLevel < acquireInfo.NeedPetLevel) || (_petPreviewInfo.petEnvolveStep < acquireInfo.NeedPetEvolveStep)))
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
	if((_skillSlotInfo.SkillInfo.LevelHide == true))
	{
		levelPrevBtn.SetEnable(false);
		levelNextBtn.SetEnable(false);
	}
	else if((_skillSlotInfo.MaxLevel == 1))
	{
		levelPrevBtn.SetEnable(false);
		levelNextBtn.SetEnable(false);
	}
	else if((_currentLevel == _skillSlotInfo.MaxLevel))
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
	local PetAcquireSkillInfo acquireData;
	local RequestItem NeedItem;
	local RichListCtrlRowData rowData;
	local int i, needItemListIndex;
	local bool learned;
	local INT64 consumePriorityInvenCnt, consumeInvenCnt;
	local bool needLearnBtnTooltip;

	needItemListIndex = -1;
	needItemScript.StartNeedItemList(2);
	if(((_skillSlotInfo.learned == true) && (_currentLevel <= _skillSlotInfo.SkillInfo.SkillLevel)))
	{
		learned = true;
	}
	if((_currentLevel <= _skillSlotInfo.MaxLevel))
	{
		if((learned == false))
		{
			Class'NWindow.PetAPI'.static.GetPetAcquireSkillInfo(_petPreviewInfo.PetID, _skillSlotInfo.originalSkillId, _currentLevel, acquireData);
			if((acquireData.PrioritizedItems.Length == 2))
			{
				consumePriorityInvenCnt = GetInventoryItemCount(GetItemID(acquireData.PrioritizedItems[0].Id));
				consumeInvenCnt = GetInventoryItemCount(GetItemID(acquireData.PrioritizedItems[1].Id));
				needItemScript.AddNeeItemInfo(GetItemInfoByClassID(acquireData.PrioritizedItems[1].Id), acquireData.PrioritizedItems[1].Amount, (consumePriorityInvenCnt + consumeInvenCnt));
				needItemRichList.GetRec((needItemRichList.GetRecordCount() - 1), rowData);
				rowData.nReserved1 = INT64(acquireData.PrioritizedItems[0].Id);
				rowData.nReserved2 = INT64(acquireData.PrioritizedItems[1].Id);
				needItemRichList.ModifyRecord((needItemRichList.GetRecordCount() - 1), rowData);
				needLearnBtnTooltip = true;
			}
			i = 0;
			while((i < acquireData.NeedItem.Length))
			{
				NeedItem = acquireData.NeedItem[i];
				needItemScript.AddNeedItemClassID(NeedItem.Id, NeedItem.Amount);
				i++;
			}
		}
	}
	if((needItemRichList.GetRecordCount() > 0))
	{
		needItemEmptyTextBox.HideWindow();
	}
	else if((learned == true))
	{
		needItemEmptyTextBox.SetText(GetSystemString(14392));
		needItemEmptyTextBox.ShowWindow();
	}
	else
	{
		if((_skillSlotInfo.MinLevel > _currentLevel))
		{
			needItemEmptyTextBox.SetText(GetSystemString(14810));
		}
		else
		{
			needItemEmptyTextBox.SetText(GetSystemString(13466));
		}
		needItemEmptyTextBox.ShowWindow();
	}
	needItemScript.SetBuyNum(INT64(1));
	return;
}

function UpdateUIControls()
{
	UpdateSkillInfoControls();
	UpdateCostInfoControls();
	return;
}

function string GetSkillLevelStr(int Level)
{
	if((Level <= 0))
	{
		return "";
	}
	return ("Lv." $ string(Level));
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
		if((TargetLevel != _skillSlotInfo.MaxLevel))
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

event OnSkillLearnPageMoveClicked()
{
	if(((_canLearnLevel > 0) && (_canLearnLevel <= _skillSlotInfo.MaxLevel)))
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
	return;
}

event OnHide()
{
	needItemScript.CleariObjects();
	return;
}

event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	Me.HideWindow();
	return;
}
