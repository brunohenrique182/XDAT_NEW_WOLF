class PetSkillInfoWnd extends UICommonAPI
	dependson(UIPacket);

const SKILL_MIN_LEVEL = 1;

var WindowHandle Me;
var WindowHandle dialogContainerWnd;
var WindowHandle learnDialogWnd;
var WindowHandle errorDialogWnd;
var WindowHandle needItemLearnNoticeWnd;
var ButtonHandle learnBtn;
var ButtonHandle levelPrevBtn;
var ButtonHandle levelNextBtn;
var ButtonHandle refreshBtn;
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
var PetSkillSlotInfo__PetSkillWnd _skillSlotInfo;
var int _currentLevel;
var int _canLearnLevel;
var bool _isWaitingLearnResponse;

static function PetSkillInfoWnd Inst()
{
	return PetSkillInfoWnd(GetScript("PetSkillInfoWnd"));
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
	learnBtn = GetButtonHandle((ownerFullPath $ ".Dialog_Learn_Btn"));
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
	needItemScript.DelegateOnClickButton = OnCostListButtonClicked;
	needItemRichList.SetTooltipType("PetSkillLearnCostListTooltip");
	refreshBtn = GetButtonHandle((needItemWnd.m_WindowNameWithFullPath $ ".Refresh_Btn"));
	needItemEmptyTextBox = GetTextBoxHandle((needItemWnd.m_WindowNameWithFullPath $ ".Empty_Txt"));
	needItemLearnNoticeWnd = GetWindowHandle((needItemWnd.m_WindowNameWithFullPath $ ".Shortcut_Wnd"));
	needItemLearnNoticeWnd.HideWindow();
	HideLevelNaviBtnAnimTex();
	return;
}

function OpenWindow(PetSkillSlotInfo__PetSkillWnd skillSlotInfo, optional bool isShowSkillLearnPage)
{
	CloseDialog();
	Debug("PetSkillInfoWnd OpenWindow");
	SetInfo(skillSlotInfo, isShowSkillLearnPage);
	Me.ShowWindow();
	return;
}

function SetInfo(PetSkillSlotInfo__PetSkillWnd skillSlotInfo, optional bool isShowSkillLearnPage)
{
	local PetAcquireSkillInfo acquireData;
	local PetInfo PetInfo;

	_isWaitingLearnResponse = false;
	_skillSlotInfo = skillSlotInfo;
	_currentLevel = skillSlotInfo.SkillInfo.SkillLevel;
	_canLearnLevel = -1;
	if((GetPetInfo(PetInfo) && (skillSlotInfo.isItemTypeSkill == false)))
	{
		if((_skillSlotInfo.learned == false))
		{
			Class'NWindow.PetAPI'.static.GetPetAcquireSkillInfo(PetInfo.nPetID, skillSlotInfo.SkillInfo.SkillID, skillSlotInfo.SkillInfo.SkillLevel, acquireData);
			if(((PetInfo.nLevel >= acquireData.NeedPetLevel) && (PetInfo.nEvolutionStep >= acquireData.NeedPetEvolveStep)))
			{
				_canLearnLevel = skillSlotInfo.SkillInfo.SkillLevel;
			}
		}
		else if((skillSlotInfo.MaxLevel > skillSlotInfo.SkillInfo.SkillLevel))
		{
			Class'NWindow.PetAPI'.static.GetPetAcquireSkillInfo(PetInfo.nPetID, skillSlotInfo.SkillInfo.SkillID, (skillSlotInfo.SkillInfo.SkillLevel + 1), acquireData);
			if(((PetInfo.nLevel >= acquireData.NeedPetLevel) && (PetInfo.nEvolutionStep >= acquireData.NeedPetEvolveStep)))
			{
				_canLearnLevel = (skillSlotInfo.SkillInfo.SkillLevel + 1);
			}
		}
	}
	Debug((((((("SetInfo" @ string(_canLearnLevel)) @ string(_skillSlotInfo.learned)) @ string(_skillSlotInfo.isCanLevelUp)) @ string(skillSlotInfo.SkillInfo.SkillLevel)) @ string(acquireData.NeedPetLevel)) @ string(acquireData.NeedPetEvolveStep)));
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
		return _skillSlotInfo.SkillInfo.SkillID;
	}
	else
	{
		return 0;
	}
}

function ShowLearnDialog()
{
	local ItemWindowHandle skillItemWnd;
	local TextBoxHandle skillNameTextBox, currentLvTextBox, nextLvTextBox, firstLearnTextBox;
	local TextureHandle arrowTex;
	local ItemInfo skillItemInfo;
	local RichListCtrlRowData rowData;
	local PetInfo PetInfo;
	local L2Util util;
	local SkillInfo tempSkillInfo;
	local WindowHandle blockSkillEmptyWnd;
	local string currentSkillName, nextSkillName;
	local PetAcquireSkillInfo acquireInfo;

	util = L2Util(GetScript("L2Util"));
	GetPetInfo(PetInfo);
	Class'NWindow.PetAPI'.static.GetPetAcquireSkillInfo(PetInfo.nPetID, _skillSlotInfo.SkillInfo.SkillID, _currentLevel, acquireInfo);
	skillItemWnd = GetItemWindowHandle((learnDialogWnd.m_WindowNameWithFullPath $ ".SkillItem_ItemWindow"));
	skillNameTextBox = GetTextBoxHandle((learnDialogWnd.m_WindowNameWithFullPath $ ".SkillName_Txt"));
	currentLvTextBox = GetTextBoxHandle((learnDialogWnd.m_WindowNameWithFullPath $ ".PrvLevelNum_Txt"));
	nextLvTextBox = GetTextBoxHandle((learnDialogWnd.m_WindowNameWithFullPath $ ".NextLevelNum_Txt"));
	firstLearnTextBox = GetTextBoxHandle((learnDialogWnd.m_WindowNameWithFullPath $ ".First_Txt"));
	arrowTex = GetTextureHandle((learnDialogWnd.m_WindowNameWithFullPath $ ".Arrow_Tex"));
	blockSkillEmptyWnd = GetWindowHandle((learnDialogWnd.m_WindowNameWithFullPath $ ".NoDeleteSkill_Wnd"));
	currentSkillName = _skillSlotInfo.skillItemInfo.Name;
	if((_skillSlotInfo.SkillInfo.LevelHide == false))
	{
		currentSkillName = (currentSkillName @ GetSkillLevelStr(_skillSlotInfo.SkillInfo.SkillLevel));
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
		currentLvTextBox.SetText(GetSkillLevelStr(_skillSlotInfo.SkillInfo.SkillLevel));
		nextLvTextBox.SetText(GetSkillLevelStr((_skillSlotInfo.SkillInfo.SkillLevel + 1)));
		GetSkillInfo(_skillSlotInfo.SkillInfo.SkillID, (_skillSlotInfo.SkillInfo.SkillLevel + 1), 0, tempSkillInfo);
		nextSkillName = tempSkillInfo.SkillName;
		if((_skillSlotInfo.SkillInfo.LevelHide == false))
		{
			nextSkillName = (nextSkillName @ GetSkillLevelStr((_skillSlotInfo.SkillInfo.SkillLevel + 1)));
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
	Debug((((("ShowLearnDialog :" @ string(acquireInfo.NeedItem.Length)) @ string(acquireInfo.PrioritizedItems.Length)) @ string(acquireInfo.NeedItem.Length)) @ string(acquireInfo.NeedItem[0].Id)));
	if((((acquireInfo.NeedItem.Length == 0) && (acquireInfo.PrioritizedItems.Length == 0)) || (((acquireInfo.PrioritizedItems.Length == 0) && (acquireInfo.NeedItem.Length == 1)) && (acquireInfo.NeedItem[0].Id == 57))))
	{
		RequestLearnSkill();
	}
	else
	{
		learnDialogWnd.ShowWindow();
		dialogContainerWnd.ShowWindow();
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
	return (sourceStr $ "<br1><img src = \"L2ui_ch3.tooltip_line\" width = 320 height = 1><br>");
}

function string ConvertHtmlDesc(SkillInfo SkillInfo, PetSkillSlotInfo__PetSkillWnd skillSlotInfo, PetAcquireSkillInfo acquireData)
{
	local string htmlStr, skillInfoA, skillInfoB, skillInfoC, SkillDesc, tempStr, evolveName;
	local PetInfo PetInfo;
	local L2Util util;
	local int ConsumeItemCount, consumeClassID;

	util = L2Util(GetScript("L2Util"));
	GetPetInfo(PetInfo);
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
		if((acquireData.NeedPetLevel > PetInfo.nLevel))
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
		evolveName = GetSystemString(getInstanceL2Util().GetPetEvolveStepStringId(EPetType(PetInfo.nPetType), acquireData.NeedPetEvolveStep));
		if((acquireData.NeedPetEvolveStep > PetInfo.nEvolutionStep))
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
	local PetInfo PetInfo;
	local PetAcquireSkillInfo acquireInfo;

	GetPetInfo(PetInfo);
	Class'NWindow.PetAPI'.static.GetPetAcquireSkillInfo(PetInfo.nPetID, _skillSlotInfo.SkillInfo.SkillID, _currentLevel, acquireInfo);
	if((_skillSlotInfo.replaceSkillId > 0))
	{
		GetSkillInfo(_skillSlotInfo.replaceSkillId, _currentLevel, 0, validSkillInfo);
	}
	else
	{
		GetSkillInfo(_skillSlotInfo.SkillInfo.SkillID, _currentLevel, 0, validSkillInfo);
	}
	Class'Interface.L2Util'.static.GetEllipsisString(validSkillInfo.SkillName, 140);
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
	else if(((PetInfo.nLevel < acquireInfo.NeedPetLevel) || (PetInfo.nEvolutionStep < acquireInfo.NeedPetEvolveStep)))
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
	if(((_skillSlotInfo.isItemTypeSkill == true) || (_skillSlotInfo.SkillInfo.LevelHide == true)))
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
	local PetInfo PetInfo;
	local RichListCtrlRowData rowData;
	local int i, needItemListIndex;
	local bool learned;
	local INT64 consumePriorityInvenCnt, consumeInvenCnt;
	local bool needLearnBtnTooltip;

	needItemListIndex = -1;
	GetPetInfo(PetInfo);
	needItemScript.StartNeedItemList(2);
	if(((_skillSlotInfo.learned == true) && (_currentLevel <= _skillSlotInfo.SkillInfo.SkillLevel)))
	{
		learned = true;
	}
	if((_currentLevel <= _skillSlotInfo.MaxLevel))
	{
		if((learned == false))
		{
			Class'NWindow.PetAPI'.static.GetPetAcquireSkillInfo(PetInfo.nPetID, _skillSlotInfo.SkillInfo.SkillID, _currentLevel, acquireData);
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
	learnBtn.SetTooltipType("Text");
	if(needLearnBtnTooltip)
	{
		learnBtn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14402)));
	}
	else
	{
		learnBtn.SetTooltipCustomType(MakeTooltipSimpleText(""));
	}
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

function RequestLearnSkill()
{
	if(((_skillSlotInfo.SkillInfo.SkillID > 0) && (_canLearnLevel > 0)))
	{
		Debug((("RequestLearnSkill" @ string(_skillSlotInfo.SkillInfo.SkillID)) @ string(_canLearnLevel)));
		Rq_C_EX_ACQUIRE_PET_SKILL(_skillSlotInfo.SkillInfo.SkillID, _canLearnLevel);
		_isWaitingLearnResponse = true;
	}
	return;
}

function Rq_C_EX_ACQUIRE_PET_SKILL(int SkillID, int skillLv)
{
	local array<byte> stream;
	local UIPacket._C_EX_ACQUIRE_PET_SKILL packet;

	packet.nSkillID = SkillID;
	packet.nSkillLv = skillLv;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_ACQUIRE_PET_SKILL(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(664, stream);
	return;
}

function Nt_S_EX_ACQUIRE_PET_SKILL_RESULT()
{
	local string skillNameStr;
	local UIPacket._S_EX_ACQUIRE_PET_SKILL_RESULT packet;
	local SkillInfo tmpSkillInfo;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_ACQUIRE_PET_SKILL_RESULT(packet))
	{
		return;
	}
	Debug(((("Nt_S_EX_ACQUIRE_PET_SKILL_RESULT" @ string(packet.cResult)) @ string(packet.nSkillLv)) @ string(packet.nSkillID)));
	if((packet.nSkillID != _skillSlotInfo.SkillInfo.SkillID))
	{
		Me.HideWindow();
	}
	if((packet.cResult == 0))
	{
		_skillSlotInfo.SkillInfo.SkillLevel = packet.nSkillLv;
		_skillSlotInfo.learned = true;
		SetInfo(_skillSlotInfo);
		OnPageNavigateBtnClicked(true);
		GetSkillInfo(packet.nSkillID, packet.nSkillLv, 0, tmpSkillInfo);
		if(tmpSkillInfo.LevelHide)
		{
			skillNameStr = tmpSkillInfo.SkillName;
		}
		else
		{
			skillNameStr = (tmpSkillInfo.SkillName @ GetSkillLevelStr(packet.nSkillLv));
		}
		getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(13299), skillNameStr));
	}
	else
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4334));
	}
	_isWaitingLearnResponse = false;
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(1180));
	RegisterEvent(180);
	return;
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case EV_PacketID(1180):
			Nt_S_EX_ACQUIRE_PET_SKILL_RESULT();
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
