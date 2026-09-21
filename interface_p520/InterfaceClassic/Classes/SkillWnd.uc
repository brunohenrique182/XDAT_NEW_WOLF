class SkillWnd extends UICommonAPI;

const SKILL_GROUP_NUM_MAX = 15;
const ITEM_SKILL_ICON_TYPE = 6615;
const TIMER_SHORTCUT_UPDATE_ID = 1;
const TIMER_SHORTCUT_UPDATEDELAY = 100;
const ITEM_ID_INVENTORY_EXPAND = 1372;
const ENCHANT_TYPE_UINT = 1000;


struct SkillNoticeNumInfo
{
	var int activeLearnNum;
	var int passiveLearnNum;
	var int activeEnchantNum;
	var int passiveEnchantNum;
};


var array<SkillGroupInfo> _characterSKillActiveGroups;
var array<SkillGroupInfo> _characterSKillPassiveGroups;
var array<SkillGroupInfo> _itemSkillGroups;
var array<SkillGroupInfo> _canLearnSKillGroups;
var array<SkillGroupInfo> _canEnchantSkillGroups;
var array<SkillGroupInfo> _canEnchantExtractSkillGroups;
var array<skillSlotInfo> _totalSkillInfos;
var array<skillSlotInfo> _characterSkillInfos;
var array<skillSlotInfo> _itemSkillInfos;
var bool _isWaitingSkillListResponse;
var int _selectedTabIndex;
var int _playerLevel;
var array<int> _shortcutSKillList;
var skillSlotInfo _invenExpandSkillInfo;
var bool _isWaitingInvenExpandSkillResponse;
var SkillNoticeNumInfo _skillNoticeNumInfo;
var int _selectedCharacterTab;
var int _selectedEnchantTab;
var WindowHandle Me;
var array<SkillWndGroupItem> skillGroupItemList;
var WindowHandle skillScrollArea;
var WindowHandle learnNoticeNumWnd;
var WindowHandle tabGroupWnd;
var WindowHandle subTapGroupWnd;
var TextBoxHandle skillEmptyTextBox;
var TextBoxHandle itemSkillTitle;
var TextBoxHandle learnNoticeNumTextBox;
var UIControlGroupButtonAssets tabGroupButton;
var UIControlGroupButtonAssets subTapGroupButton;
var TabHandle subTabHandle;
var ButtonHandle spExtractBtn;
//var delegate<OnSortByOrder> __OnSortByOrder__Delegate;

static function SkillWnd Inst()
{
	return SkillWnd(GetScript("SkillWnd"));
}

function Initialize()
{
	InitControls();
	return;
}

function InitControls()
{
	local int i;
	local string ownerFullPath;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	skillScrollArea = GetWindowHandle((ownerFullPath $ ".SkillMain_Wnd.Skill_Wnd.Skill.SkillScroll"));
	skillEmptyTextBox = GetTextBoxHandle((ownerFullPath $ ".SkillMain_Wnd.Skill_Wnd.Empty_Txt"));
	itemSkillTitle = GetTextBoxHandle((ownerFullPath $ ".SkillMain_Wnd.SkillHeader_Txt"));
	spExtractBtn = GetButtonHandle((ownerFullPath $ ".SkillMain_Wnd.SPExtract_Btn"));
	learnNoticeNumWnd = GetWindowHandle((ownerFullPath $ ".SkillMain_Wnd.TabNum1_Wnd"));
	learnNoticeNumTextBox = GetTextBoxHandle((learnNoticeNumWnd.m_WindowNameWithFullPath $ ".Num_Txt"));
	tabGroupWnd = GetWindowHandle((ownerFullPath $ ".TopGroupButtonAsset"));
	tabGroupButton = Class'InterfaceClassic.UIControlGroupButtonAssets'.static._InitScript(tabGroupWnd);
	tabGroupButton._SetStartInfo("L2UI_NewTex.WindowTab.FlatBrown_Tab_One_Unselected", "L2UI_NewTex.WindowTab.FlatBrown_Tab_One_Unselected", "L2UI_NewTex.WindowTab.FlatBrown_Tab_One_Unselected", true);
	tabGroupButton._GetGroupButtonsInstance().DelegateOnClickButton = OnTabGroupBtnClicked;
	tabGroupButton._GetGroupButtonsInstance()._setButtonTexture(0, "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Left_Unselected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Left_Selected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Left_Unselected_Over");
	tabGroupButton._GetGroupButtonsInstance()._setButtonTexture(1, "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Center_Unselected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Center_Selected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Center_Unselected_Over");
	tabGroupButton._GetGroupButtonsInstance()._setButtonTexture(2, "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Right_Unselected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Right_Selected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Right_Unselected_Over");
	tabGroupButton._GetGroupButtonsInstance()._setButtonText(0, GetSystemString(2321));
	tabGroupButton._GetGroupButtonsInstance()._setButtonValue(0, 0);
	tabGroupButton._GetGroupButtonsInstance()._setButtonText(1, GetSystemString(117));
	tabGroupButton._GetGroupButtonsInstance()._setButtonValue(1, 1);
	tabGroupButton._GetGroupButtonsInstance()._setButtonText(2, GetSystemString(1579));
	tabGroupButton._GetGroupButtonsInstance()._setButtonValue(2, 2);
	tabGroupButton._GetGroupButtonsInstance()._setShowButtonNum(3);
	tabGroupButton._GetGroupButtonsInstance()._setAutoWidth(524, 0);
	subTapGroupWnd = GetWindowHandle((ownerFullPath $ ".SkillMain_Wnd.SubGroupButtonAsset"));
	subTapGroupButton = Class'InterfaceClassic.UIControlGroupButtonAssets'.static._InitScript(subTapGroupWnd);
	subTapGroupButton._SetStartInfo("L2UI_NewTex.WindowTab.Tab_Opacity_Unselected", "L2UI_NewTex.WindowTab.Tab_Opacity_Selected", "L2UI_NewTex.WindowTab.Tab_Opacity_Unselected_Over", true);
	subTapGroupButton._GetGroupButtonsInstance().DelegateOnClickButton = OnSubTabGroupBtnClicked;
	i = 0;
	while((i < 15))
	{
		AddGroupItemControl(skillGroupItemList, "Skill", i, skillScrollArea);
		i++;
	}
	return;
}

function AddGroupItemControl(out array<SkillWndGroupItem> componentList, string componentName, int Index, WindowHandle parentWnd)
{
	local WindowHandle targetWindowHandle;
	local SkillWndGroupItem targetControl;

	targetWindowHandle = GetWindowHandle((((parentWnd.m_WindowNameWithFullPath $ ".") $ componentName) $ string(Index)));
	targetWindowHandle.SetScript("SkillWndGroupItem");
	targetControl = SkillWndGroupItem(targetWindowHandle.GetScript());
	targetControl.Init(targetWindowHandle);
	targetControl.DelegateOnSkillInfoClicked = OnSkillSlotInfoClicked;
	componentList[componentList.Length] = targetControl;
	return;
}

function ResetSkillNoticeNumInfo()
{
	local SkillNoticeNumInfo defaultNumInfo;

	_skillNoticeNumInfo = defaultNumInfo;
	return;
}

function ResetSkillGroupInfo()
{
	_characterSKillActiveGroups.Length = 0;
	_characterSKillPassiveGroups.Length = 0;
	_itemSkillGroups.Length = 0;
	_canLearnSKillGroups.Length = 0;
	_canEnchantSkillGroups.Length = 0;
	return;
}

function ResetInfo()
{
	ResetSkillGroupInfo();
	_totalSkillInfos.Length = 0;
	return;
}

function UpdateShortcutSkillInfo()
{
	_shortcutSKillList.Length = 0;
	Class'NWindow.ShortcutWndAPI'.static.GetSkillListFromShortcutItems(_shortcutSKillList);
	return;
}

function UpdateShortcutInfoWithTimer()
{
	Me.KillTimer(1);
	Me.SetTimer(1, 100);
	return;
}

function UpdateSkillInfos()
{
	local int i;
	local skillSlotInfo slotInfo;
	local array<skillSlotInfo> itemSkills, characterActiveSkills, characterPassiveSkills, canLearnSKills, canEnchantSkills, canEnchantExtractSkills;

	ResetSkillNoticeNumInfo();
	i = 0;
	while((i < _totalSkillInfos.Length))
	{
		slotInfo = _totalSkillInfos[i];
		if((slotInfo.learned == true))
		{
			slotInfo.isShortCut = CheckShortcutRegistered(slotInfo.SkillInfo.SkillID);
		}
		else
		{
			slotInfo.isShortCut = false;
		}
		if(slotInfo.isItemTypeSkill)
		{
			itemSkills[itemSkills.Length] = slotInfo;
			i++;
			continue;
		}
		if(slotInfo.isCanLevelUp)
		{
			canLearnSKills[canLearnSKills.Length] = slotInfo;
		}
		if(slotInfo.isCanEnchant)
		{
			canEnchantSkills[canEnchantSkills.Length] = slotInfo;
		}
		if(slotInfo.isCanEnchantExtract)
		{
			canEnchantExtractSkills[canEnchantExtractSkills.Length] = slotInfo;
		}
		if(slotInfo.isActiveSkill)
		{
			if(slotInfo.isCanLevelUp)
			{
				_skillNoticeNumInfo.activeLearnNum++;
			}
			if(slotInfo.isCanEnchant)
			{
				_skillNoticeNumInfo.activeEnchantNum++;
			}
			characterActiveSkills[characterActiveSkills.Length] = slotInfo;
			i++;
			continue;
		}
		if(slotInfo.isCanLevelUp)
		{
			_skillNoticeNumInfo.passiveLearnNum++;
		}
		if(slotInfo.isCanEnchant)
		{
			_skillNoticeNumInfo.passiveEnchantNum++;
		}
		characterPassiveSkills[characterPassiveSkills.Length] = slotInfo;
		i++;
	}
	MakeSkillGroupInfos(characterActiveSkills, _characterSKillActiveGroups);
	MakeSkillGroupInfos(characterPassiveSkills, _characterSKillPassiveGroups);
	MakeSkillGroupInfos(itemSkills, _itemSkillGroups);
	MakeSkillGroupInfos(canLearnSKills, _canLearnSKillGroups);
	MakeSkillGroupInfos(canEnchantSkills, _canEnchantSkillGroups);
	MakeSkillGroupInfos(canEnchantExtractSkills, _canEnchantExtractSkillGroups);
	return;
}

function MakeSkillGroupInfos(array<skillSlotInfo> skillInfos, out array<SkillGroupInfo> outSkillGroupInfos)
{
	local int i, IconType;
	local skillSlotInfo tempInfo;
	local SkillGroupInfo tempGroupInfo, defaultGroupInfo;
	local array<SkillGroupInfo> tempGroupInfos, finalGroupInfos;
	local array<skillSlotInfo> tempSkillArray;

	i = 0;
	while((i < skillInfos.Length))
	{
		tempInfo = skillInfos[i];
		IconType = tempInfo.SkillInfo.IconType;
		if((IconType < tempGroupInfos.Length))
		{
			tempGroupInfo = tempGroupInfos[IconType];
		}
		else
		{
			tempGroupInfo = defaultGroupInfo;
		}
		tempGroupInfo.Skills.Length = (tempGroupInfo.Skills.Length + 1);
		tempGroupInfo.Skills[(tempGroupInfo.Skills.Length - 1)] = tempInfo;
		tempGroupInfos[IconType] = tempGroupInfo;
		i++;
	}
	i = 0;
	while((i < tempGroupInfos.Length))
	{
		tempGroupInfo = tempGroupInfos[i];
		if((tempGroupInfo.Skills.Length > 0))
		{
			tempSkillArray = tempGroupInfo.Skills;
			// tempSkillArray.Sort(OnSortByOrder);   // array.Sort() unsupported by this compiler
			tempGroupInfo.Skills = tempSkillArray;
			tempGroupInfo.GroupType = i;
			finalGroupInfos[finalGroupInfos.Length] = tempGroupInfo;
		}
		i++;
	}
	outSkillGroupInfos = finalGroupInfos;
	return;
}

function CustomTooltip GetSkillNoticeNumTooltipInfo(int activeNum, int passiveNum)
{
	local array<DrawItemInfo> drawListArr;

	if((activeNum > 0))
	{
		drawListArr[drawListArr.Length] = addDrawItemText((GetSystemString(120) $ ": "), getInstanceL2Util().ColorGray, "", false, true, 4);
		drawListArr[drawListArr.Length] = addDrawItemText(string(activeNum), getInstanceL2Util().ColorGold, "", false, false, 0);
	}
	if((passiveNum > 0))
	{
		if((activeNum > 0))
		{
			drawListArr[drawListArr.Length] = addDrawItemBlank(4);
			drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(30);
			drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		}
		drawListArr[drawListArr.Length] = addDrawItemText((GetSystemString(121) $ ": "), getInstanceL2Util().ColorGray, "", false, true, 4);
		drawListArr[drawListArr.Length] = addDrawItemText(string(passiveNum), getInstanceL2Util().ColorGold, "", false, false, 0);
	}
	return MakeTooltipMultiTextByArray(drawListArr);
}

function UpdateSkillTabControls()
{
	if((_selectedTabIndex == 0))
	{
		subTapGroupButton._GetGroupButtonsInstance()._setShowButtonNum(3);
		subTapGroupButton._GetGroupButtonsInstance()._fixedWidth(168, 0);
		subTapGroupButton._GetGroupButtonsInstance()._setButtonText(0, GetSystemString(120));
		subTapGroupButton._GetGroupButtonsInstance()._setButtonText(1, GetSystemString(121));
		subTapGroupButton._GetGroupButtonsInstance()._setButtonText(2, GetSystemString(14371));
		subTapGroupButton._GetGroupButtonsInstance()._setTopOrder(_selectedCharacterTab, true);
		subTapGroupWnd.ShowWindow();
		itemSkillTitle.HideWindow();
		if(((_skillNoticeNumInfo.activeLearnNum > 0) || (_skillNoticeNumInfo.passiveLearnNum > 0)))
		{
			learnNoticeNumTextBox.SetText(string((_skillNoticeNumInfo.activeLearnNum + _skillNoticeNumInfo.passiveLearnNum)));
			learnNoticeNumWnd.SetTooltipCustomType(GetSkillNoticeNumTooltipInfo(_skillNoticeNumInfo.activeLearnNum, _skillNoticeNumInfo.passiveLearnNum));
			learnNoticeNumWnd.ShowWindow();
		}
		else
		{
			learnNoticeNumWnd.HideWindow();
		}
	}
	else if((_selectedTabIndex == 1))
	{
		itemSkillTitle.SetText(GetSystemString(14393));
		subTapGroupWnd.HideWindow();
		itemSkillTitle.ShowWindow();
		learnNoticeNumWnd.HideWindow();
	}
	else
	{
		subTapGroupButton._GetGroupButtonsInstance()._setShowButtonNum(2);
		subTapGroupButton._GetGroupButtonsInstance()._fixedWidth(168, 0);
		subTapGroupButton._GetGroupButtonsInstance()._setButtonText(0, GetSystemString(14409));
		subTapGroupButton._GetGroupButtonsInstance()._setButtonText(1, GetSystemString(14653));
		subTapGroupButton._GetGroupButtonsInstance()._setTopOrder(_selectedEnchantTab, true);
		subTapGroupWnd.ShowWindow();
		itemSkillTitle.HideWindow();
		learnNoticeNumWnd.HideWindow();
	}
	return;
}

function UpdateSkillGroupControls()
{
	local int i, wndHeight;
	local SkillWndGroupItem groupItem;
	local array<SkillGroupInfo> skillGroupInfos;

	UpdateSkillTabControls();
	skillEmptyTextBox.HideWindow();
	spExtractBtn.HideWindow();
	if((_selectedTabIndex == 0))
	{
		if((subTapGroupButton._GetGroupButtonsInstance()._getSelectButtonIndex() == 0))
		{
			skillGroupInfos = _characterSKillActiveGroups;
		}
		else if((subTapGroupButton._GetGroupButtonsInstance()._getSelectButtonIndex() == 1))
		{
			skillGroupInfos = _characterSKillPassiveGroups;
		}
		else if((subTapGroupButton._GetGroupButtonsInstance()._getSelectButtonIndex() == 2))
		{
			skillGroupInfos = _canLearnSKillGroups;
		}
	}
	else if((_selectedTabIndex == 1))
	{
		skillGroupInfos = _itemSkillGroups;
	}
	else if((_selectedTabIndex == 2))
	{
		if((subTapGroupButton._GetGroupButtonsInstance()._getSelectButtonIndex() == 0))
		{
			skillGroupInfos = _canEnchantSkillGroups;
		}
		else if((subTapGroupButton._GetGroupButtonsInstance()._getSelectButtonIndex() == 1))
		{
			skillGroupInfos = _canEnchantExtractSkillGroups;
		}
		spExtractBtn.ShowWindow();
	}
	i = 0;
	while((i < skillGroupItemList.Length))
	{
		groupItem = skillGroupItemList[i];
		if((i >= skillGroupInfos.Length))
		{
			groupItem.SetDisable(true);
			i++;
			continue;
		}
		groupItem.SetGroupInfo(skillGroupInfos[i]);
		groupItem.SetDisable(false);
		wndHeight = (wndHeight + groupItem.Me.GetRect().nHeight);
		if((i > 0))
		{
			groupItem.Me.SetAnchor(skillGroupItemList[(i - 1)].Me.m_WindowNameWithFullPath, "BottomCenter", "TopCenter", 0, 0);
		}
		groupItem.Me.ClearAnchor();
		i++;
	}
	if((skillGroupInfos.Length == 0))
	{
		skillEmptyTextBox.ShowWindow();
	}
	skillScrollArea.SetScrollHeight(wndHeight);
	return;
}

function UpdateUIControls()
{
	if((Me.IsShowWindow() == false))
	{
		return;
	}
	UpdateSkillGroupControls();
	return;
}

function CloseSkillInfoWnd()
{
	Class'InterfaceClassic.SkillInfoWnd'.static.Inst().Me.HideWindow();
	return;
}

delegate int OnSortByOrder(skillSlotInfo A, skillSlotInfo B)
{
	if((A.GroupType != B.GroupType))
	{
		if((A.GroupType < B.GroupType))
		{
			return 0;
		}
		else
		{
			return -1;
		}
	}
	if((A.learned != B.learned))
	{
		if(((A.learned == true) && (B.learned == false)))
		{
			return 0;
		}
		else
		{
			return -1;
		}
	}
	if((A.OrderID != B.OrderID))
	{
		if((A.OrderID < B.OrderID))
		{
			return 0;
		}
		else
		{
			return -1;
		}
	}
	if((A.SkillInfo.SkillID < B.SkillInfo.SkillID))
	{
		return 0;
	}
	else
	{
		return -1;
	}
}

function bool IsActiveTypeSkill(int OperateType)
{
	return !IsPassiveTypeSkill(OperateType);
}

function bool IsPassiveTypeSkill(int OperateType)
{
	if((OperateType == 2))
	{
		return true;
	}
	return false;
}

function bool isItemTypeSkill(int IconType)
{
	if((IconType >= 6615))
	{
		return true;
	}
	return false;
}

function bool CheckShortcutRegistered(int SkillID)
{
	local int i;

	i = 0;
	while((i < _shortcutSKillList.Length))
	{
		if((_shortcutSKillList[i] == SkillID))
		{
			return true;
		}
		i++;
	}
	return false;
}

function bool FindSkillSlotInfo(int SkillID, out skillSlotInfo slotInfo)
{
	local int i;

	if((SkillID == 0))
	{
		return false;
	}
	i = 0;
	while((i < _totalSkillInfos.Length))
	{
		if((_totalSkillInfos[i].SkillInfo.SkillID == SkillID))
		{
			slotInfo = _totalSkillInfos[i];
			return true;
		}
		i++;
	}
	return false;
}

function ShowAndInvenExpandSkillInfo()
{
	if((_invenExpandSkillInfo.SkillInfo.SkillID == 0))
	{
		return;
	}
	tabGroupButton._GetGroupButtonsInstance()._setTopOrder(0);
	subTapGroupButton._GetGroupButtonsInstance()._setTopOrder(2);
	_selectedCharacterTab = 2;
	Me.ShowWindow();
	Class'InterfaceClassic.SkillInfoWnd'.static.Inst().OpenWindow(_invenExpandSkillInfo, true);
	return;
}

function bool IsCanLevelUpInvenExpandSkill()
{
	if((_invenExpandSkillInfo.SkillInfo.SkillID == 0))
	{
		return false;
	}
	return _invenExpandSkillInfo.isCanLevelUp;
}

function SetSelectedTabIndex(int Index)
{
	_selectedTabIndex = Index;
	skillScrollArea.SetScrollPosition(0);
	UpdateUIControls();
	return;
}

function int ConvertEnchantLevel(int SubLevel)
{
	local int enchantLevel;

	enchantLevel = SubLevel;
	if((SubLevel >= 1000))
	{
		enchantLevel = int((float(SubLevel) % 1000.0000000));
	}
	return enchantLevel;
}

function bool IsEnchantExtractTabSelected()
{
	if(((_selectedTabIndex == 2) && (_selectedEnchantTab == 1)))
	{
		return true;
	}
	return false;
}

function Rs_EV_SkillListStart(string param)
{
	local UserInfo UserInfo;

	GetPlayerInfo(UserInfo);
	_playerLevel = UserInfo.nLevel;
	ResetInfo();
	_isWaitingSkillListResponse = true;
	_invenExpandSkillInfo.SkillInfo.SkillID = 0;
	return;
}

function Rs_EV_SkillList(string param)
{
	local int ClassID, Level, SubLevel, isCanEnchant, ReuseDelayShareGroupID, SkillDisabled, OrderID, GroupType, replaceSkillId;
	local skillSlotInfo skillSlotInfo;
	local SkillInfo SkillInfo, replaceSkillInfo;
	local string strCommand;
	local array<int> subLevelInfos;

	ParseInt(param, "ClassID", ClassID);
	ParseInt(param, "Level", Level);
	ParseInt(param, "SubLevel", SubLevel);
	ParseInt(param, "CanEnchant", isCanEnchant);
	ParseInt(param, "ReuseDelayShareGroupID", ReuseDelayShareGroupID);
	ParseInt(param, "iSkillDisabled", SkillDisabled);
	ParseInt(param, "OrderID", OrderID);
	ParseInt(param, "GroupType", GroupType);
	ParseInt(param, "ReplaceSkillID", replaceSkillId);
	ParseString(param, "Command", strCommand);
	if(!GetSkillInfo(ClassID, Level, SubLevel, SkillInfo))
	{
		return;
	}
	skillSlotInfo.SkillInfo = SkillInfo;
	skillSlotInfo.learned = true;
	skillSlotInfo.isCanEnchant = bool(isCanEnchant);
	skillSlotInfo.isEnchantSkill = bool(isCanEnchant);
	Class'InterfaceClassic.L2Util'.static.GetSkill2ItemInfo(SkillInfo, skillSlotInfo.skillItemInfo);
	skillSlotInfo.skillItemInfo.ReuseDelayShareGroupID = ReuseDelayShareGroupID;
	skillSlotInfo.skillItemInfo.iSkillDisabled = SkillDisabled;
	skillSlotInfo.skillItemInfo.MacroCommand = strCommand;
	skillSlotInfo.enchantLevel = ConvertEnchantLevel(SubLevel);
	skillSlotInfo.OrderID = OrderID;
	skillSlotInfo.GroupType = GroupType;
	skillSlotInfo.isItemTypeSkill = isItemTypeSkill(SkillInfo.IconType);
	skillSlotInfo.isActiveSkill = IsActiveTypeSkill(SkillInfo.OperateType);
	skillSlotInfo.replaceSkillId = replaceSkillId;
	if(IsExtractSkill(SkillInfo.SkillID))
	{
		skillSlotInfo.isCanEnchantExtract = true;
	}
	else
	{
		skillSlotInfo.isCanEnchantExtract = false;
	}
	if(((replaceSkillId >= 0) && GetSkillInfo(replaceSkillId, Level, SubLevel, replaceSkillInfo)))
	{
		skillSlotInfo.SkillInfo.Grade = replaceSkillInfo.Grade;
		skillSlotInfo.skillItemInfo.Grade = byte(replaceSkillInfo.Grade);
		skillSlotInfo.SkillInfo.IconType = replaceSkillInfo.IconType;
		skillSlotInfo.isItemTypeSkill = isItemTypeSkill(replaceSkillInfo.IconType);
	}
	if((isCanEnchant == 1))
	{
		if((GetSkillSubLevelList(ClassID, Level, subLevelInfos) > 0))
		{
			if((SubLevel == subLevelInfos[(subLevelInfos.Length - 1)]))
			{
				skillSlotInfo.isCanEnchant = false;
			}
		}
	}
	if((1372 == ClassID))
	{
		_invenExpandSkillInfo = skillSlotInfo;
	}
	_totalSkillInfos[_totalSkillInfos.Length] = skillSlotInfo;
	return;
}

function Rs_EV_SkillListEnd(string param)
{
	return;
}

function Rs_EV_SkillLearningTabAddSkillBegin(string param)
{
	return;
}

function UpdateSkillDisableState()
{
	local int i;

	if((Me.IsShowWindow() == false))
	{
		return;
	}
	i = 0;
	while((i < skillGroupItemList.Length))
	{
		skillGroupItemList[i].UpdateSkillDisableState();
		i++;
	}
	return;
}

function UpdateSkillInfoWnd()
{
	if(Class'InterfaceClassic.SkillInfoWnd'.static.Inst().Me.IsShowWindow())
	{
		Class'InterfaceClassic.SkillInfoWnd'.static.Inst().UpdateSkillInfoControls();
	}
	return;
}

function Rs_EV_SkillLearningTabAddSkillItem(string param)
{
	local int i, ClassID, Level, SubLevel, OrderID, GroupType, requiredLevel;
	local skillSlotInfo skillSlotInfo, tmpSkillSlotInfo;
	local SkillInfo SkillInfo;

	ParseInt(param, "ID", ClassID);
	ParseInt(param, "Level", Level);
	ParseInt(param, "SubLevel", SubLevel);
	ParseInt(param, "OrderID", OrderID);
	ParseInt(param, "RequiredLevel", requiredLevel);
	ParseInt(param, "GroupType", GroupType);
	if((_isWaitingSkillListResponse == false))
	{
		return;
	}
	if(!GetSkillInfo(ClassID, Level, SubLevel, SkillInfo))
	{
		return;
	}
	i = 0;
	while((i < _totalSkillInfos.Length))
	{
		tmpSkillSlotInfo = _totalSkillInfos[i];
		if((tmpSkillSlotInfo.SkillInfo.SkillID == ClassID))
		{
			if((requiredLevel <= _playerLevel))
			{
				tmpSkillSlotInfo.isCanLevelUp = true;
				_totalSkillInfos[i] = tmpSkillSlotInfo;
			}
			if((1372 == ClassID))
			{
				_invenExpandSkillInfo = tmpSkillSlotInfo;
			}
			return;
		}
		i++;
	}
	if(((SkillInfo.SkillLevel > 1) && (1372 != ClassID)))
	{
		return;
	}
	if((requiredLevel <= _playerLevel))
	{
		skillSlotInfo.isCanLevelUp = true;
	}
	else
	{
		skillSlotInfo.isCanLevelUp = false;
	}
	skillSlotInfo.SkillInfo = SkillInfo;
	skillSlotInfo.learned = false;
	skillSlotInfo.isCanEnchant = false;
	skillSlotInfo.isEnchantSkill = false;
	Class'InterfaceClassic.L2Util'.static.GetSkill2ItemInfo(SkillInfo, skillSlotInfo.skillItemInfo);
	skillSlotInfo.enchantLevel = ConvertEnchantLevel(SubLevel);
	skillSlotInfo.OrderID = OrderID;
	skillSlotInfo.GroupType = GroupType;
	skillSlotInfo.isShortCut = false;
	skillSlotInfo.isItemTypeSkill = isItemTypeSkill(SkillInfo.IconType);
	skillSlotInfo.isActiveSkill = IsActiveTypeSkill(SkillInfo.OperateType);
	skillSlotInfo.replaceSkillId = -1;
	if((1372 == ClassID))
	{
		_invenExpandSkillInfo = skillSlotInfo;
	}
	if((SkillInfo.SkillLevel > 1))
	{
		return;
	}
	_totalSkillInfos[_totalSkillInfos.Length] = skillSlotInfo;
	return;
}

function Rs_EV_SkillLearningTabAddSkillEnd(string param)
{
	if((_isWaitingSkillListResponse == true))
	{
		ResetSkillGroupInfo();
		UpdateSkillInfos();
		UpdateUIControls();
	}
	_isWaitingSkillListResponse = false;
	_isWaitingInvenExpandSkillResponse = false;
	InventoryWnd(GetScript("InventoryWnd")).UpdateInvenExpandSkillBtn();
	return;
}

function Nt_EV_ApplySkillAvailability(string param)
{
	local int i, preSkillDisable, newSKillDisable;
	local skillSlotInfo slotInfo;
	local bool needUpdateUIControls;

	if((Me.IsShowWindow() == false))
	{
		return;
	}
	i = 0;
	while((i < _totalSkillInfos.Length))
	{
		slotInfo = _totalSkillInfos[i];
		preSkillDisable = slotInfo.skillItemInfo.iSkillDisabled;
		newSKillDisable = GetSkillAvailability(slotInfo.SkillInfo.SkillID, slotInfo.SkillInfo.SkillLevel, slotInfo.SkillInfo.SkillSubLevel);
		if((preSkillDisable != newSKillDisable))
		{
			needUpdateUIControls = true;
			slotInfo.skillItemInfo.iSkillDisabled = newSKillDisable;
			_totalSkillInfos[i] = slotInfo;
		}
		i++;
	}
	if((needUpdateUIControls == true))
	{
		UpdateSkillDisableState();
	}
	return;
}

function Rs_EV_NotifySubjob(string param)
{
	return;
}

function Rs_EV_CreatedSubjob(string param)
{
	return;
}

function Rs_EV_ChangedSubjob(string param)
{
	return;
}

function Rs_EV_UpdateUserInfo(string param)
{
	local UserInfo UserInfo;

	GetPlayerInfo(UserInfo);
	_playerLevel = UserInfo.nLevel;
	return;
}

function Nt_EV_ShortcutSkillListUpdate(string param)
{
	if((Me.IsShowWindow() == false))
	{
		return;
	}
	UpdateShortcutInfoWithTimer();
	return;
}

function Nt_EV_GamingStateExit()
{
	Me.HideWindow();
	return;
}

event OnRegisterEvent()
{
	if((IsUseRenewalSkillWnd() == false))
	{
		return;
	}
	RegisterEvent(1280);
	RegisterEvent(1290);
	RegisterEvent(1291);
	RegisterEvent(2055);
	RegisterEvent(2056);
	RegisterEvent(2057);
	RegisterEvent(5360);
	RegisterEvent(5310);
	RegisterEvent(5311);
	RegisterEvent(5312);
	RegisterEvent(180);
	RegisterEvent(631);
	RegisterEvent(160);
	RegisterEvent(150);
	RegisterEvent(40);
	return;
}

event OnEvent(int EventID, string param)
{
	if((IsUseRenewalSkillWnd() == false))
	{
		return;
	}
	if((EventID == 150))
	{
		if((_invenExpandSkillInfo.SkillInfo.SkillID == 0))
		{
			_isWaitingInvenExpandSkillResponse = true;
		}
	}
	if((EventID == 40))
	{
		_invenExpandSkillInfo.SkillInfo.SkillID = 0;
	}
	if(((Me.IsShowWindow() == false) && (_isWaitingInvenExpandSkillResponse == false)))
	{
		return;
	}
	switch(EventID)
	{
		case 1280:
			Rs_EV_SkillListStart(param);
			break;
		case 1290:
			Rs_EV_SkillList(param);
			break;
		case 1291:
			Rs_EV_SkillListEnd(param);
			break;
		case 2055:
			Rs_EV_SkillLearningTabAddSkillBegin(param);
			break;
		case 2056:
			Rs_EV_SkillLearningTabAddSkillItem(param);
			break;
		case 2057:
			Rs_EV_SkillLearningTabAddSkillEnd(param);
			break;
		case 5360:
			Nt_EV_ApplySkillAvailability(param);
			break;
		case 5310:
			Rs_EV_NotifySubjob(param);
			break;
		case 5311:
			Rs_EV_CreatedSubjob(param);
			break;
		case 5312:
			Rs_EV_ChangedSubjob(param);
			break;
		case 180:
			Rs_EV_UpdateUserInfo(param);
			break;
		case 631:
			Nt_EV_ShortcutSkillListUpdate(param);
			break;
		case 160:
			Nt_EV_GamingStateExit();
			break;
		default:
			break;
	}
	return;
}

event OnClickButton(string btnName)
{
	switch(btnName)
	{
		case "HelpBtn":
			Class'InterfaceClassic.HelpWnd'.static.ShowHelp(15, 1);
			break;
		case "SPExtract_Btn":
			toggleWindow("SkillSpExtractWnd", true, true);
			break;
		default:
			break;
	}
	return;
}

event OnSkillSlotInfoClicked(skillSlotInfo skillSlotInfo)
{
	local bool isShowSkillLearnPage;

	if(((_selectedTabIndex == 2) || ((_selectedTabIndex == 0) && (subTapGroupButton._GetGroupButtonsInstance()._getSelectButtonIndex() == 2))))
	{
		isShowSkillLearnPage = true;
	}
	Class'InterfaceClassic.SkillInfoWnd'.static.Inst().OpenWindow(skillSlotInfo, isShowSkillLearnPage);
	return;
}

event OnTabGroupBtnClicked(string parentWndName, string strName, int Index)
{
	SetSelectedTabIndex(Index);
	UpdateSkillInfoWnd();
	return;
}

event OnSubTabGroupBtnClicked(string parentWndName, string strName, int Index)
{
	if((_selectedTabIndex == 0))
	{
		_selectedCharacterTab = Index;
	}
	else if((_selectedTabIndex == 2))
	{
		_selectedEnchantTab = Index;
	}
	UpdateSkillInfoWnd();
	UpdateUIControls();
	skillScrollArea.SetScrollPosition(0);
	return;
}

function OnTimer(int TimerID)
{
	if((TimerID == 1))
	{
		UpdateShortcutSkillInfo();
		UpdateSkillInfos();
		UpdateSkillGroupControls();
		Me.KillTimer(1);
	}
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

event OnShow()
{
	if((GetGameStateName() != "GAMINGSTATE"))
	{
		Me.HideWindow();
		return;
	}
	if(Class'InterfaceClassic.SkillEnchantExtractWnd'.static.Inst().Me.IsShowWindow())
	{
		Class'InterfaceClassic.SkillEnchantExtractWnd'.static.Inst().Me.HideWindow();
	}
	Class'InterfaceClassic.SkillEnchantWnd'.static.Inst().Me.HideWindow();
	Me.SetFocus();
	if((MagicSkillWnd(GetScript("MagicSkillWnd"))._isSkillLearnNotice == true))
	{
		_selectedTabIndex = 0;
		subTapGroupButton._GetGroupButtonsInstance()._setTopOrder(2);
		_selectedCharacterTab = 2;
		MagicSkillWnd(GetScript("MagicSkillWnd"))._isSkillLearnNotice = false;
	}
	tabGroupButton._GetGroupButtonsInstance()._setTopOrder(_selectedTabIndex, true);
	UpdateShortcutSkillInfo();
	RequestSkillList();
	UpdateUIControls();
	skillEmptyTextBox.HideWindow();
	return;
}

event OnHide()
{
	Class'InterfaceClassic.SkillInfoWnd'.static.Inst().Me.HideWindow();
	Class'InterfaceClassic.SkillInfoWnd'.static.Inst().OnHide();
	_shortcutSKillList.Length = 0;
	Me.KillTimer(1);
	_isWaitingSkillListResponse = false;
	ResetInfo();
	return;
}

event OnReceivedCloseUI()
{
	if(Class'InterfaceClassic.SkillInfoWnd'.static.Inst().Me.IsShowWindow())
	{
		Class'InterfaceClassic.SkillInfoWnd'.static.Inst().OnReceivedCloseUI();
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		Me.HideWindow();
	}
	return;
}
