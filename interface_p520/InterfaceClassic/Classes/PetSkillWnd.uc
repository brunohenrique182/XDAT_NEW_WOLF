class PetSkillWnd extends UICommonAPI;

const SKILL_GROUP_NUM_MAX = 10;
const ITEM_SKILL_ICON_TYPE = 6615;
const TIMER_SHORTCUT_UPDATE_ID = 1;
const TIMER_SHORTCUT_UPDATEDELAY = 100;



var WindowHandle Me;
var array<PetSkillWndGroupItem> skillGroupItemList;
var WindowHandle skillScrollArea;
var WindowHandle tabGroupWnd;
var WindowHandle skillNumWnd;
var TextBoxHandle skillEmptyTextBox;
var TextBoxHandle skillNumTextBox;
var UIControlGroupButtonAssets tabGroupButton;
var array<PetSkillGroupInfo__PetSkillWnd> _skillGroups;
var array<PetSkillGroupInfo__PetSkillWnd> _itemSkillGroups;
var array<PetSkillGroupInfo__PetSkillWnd> _canLearnSKillGroups;
var array<PetSkillSlotInfo__PetSkillWnd> _actionSkillInfos;
var array<PetSkillSlotInfo__PetSkillWnd> _totalSkillInfos;
var bool _isWaitingSkillListResponse;
var int _selectedTabIndex;
var array<int> _shortcutSKillList;
var array<int> _shortcutActionList;
var int _skillNoticeNum;
var PetWndClassic petWndClassicScript;
//var delegate<OnSortByOrder> __OnSortByOrder__Delegate;

static function PetSkillWnd Inst()
{
	return PetSkillWnd(GetScript("PetSkillWnd"));
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
	petWndClassicScript = PetWndClassic(GetScript("PetWndClassic"));
	skillScrollArea = GetWindowHandle((ownerFullPath $ ".SkillMain_Wnd.Skill_Wnd.Skill.SkillScroll"));
	skillEmptyTextBox = GetTextBoxHandle((ownerFullPath $ ".SkillMain_Wnd.Skill_Wnd.Empty_Txt"));
	skillNumWnd = GetWindowHandle((ownerFullPath $ ".TabNum1_Wnd"));
	skillNumTextBox = GetTextBoxHandle((ownerFullPath $ ".TabNum1_Wnd.Num_Txt"));
	tabGroupWnd = GetWindowHandle((ownerFullPath $ ".TopGroupButtonAsset"));
	tabGroupButton = Class'InterfaceClassic.UIControlGroupButtonAssets'.static._InitScript(tabGroupWnd);
	tabGroupButton._SetStartInfo("L2UI_NewTex.WindowTab.FlatBrown_Tab_One_Unselected", "L2UI_NewTex.WindowTab.FlatBrown_Tab_One_Unselected", "L2UI_NewTex.WindowTab.FlatBrown_Tab_One_Unselected", true);
	tabGroupButton._GetGroupButtonsInstance().DelegateOnClickButton = OnTabGroupBtnClicked;
	tabGroupButton._GetGroupButtonsInstance()._setButtonTexture(0, "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Left_Unselected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Left_Selected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Left_Unselected_Over");
	tabGroupButton._GetGroupButtonsInstance()._setButtonTexture(1, "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Center_Unselected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Center_Selected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Center_Unselected_Over");
	tabGroupButton._GetGroupButtonsInstance()._setButtonTexture(2, "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Right_Unselected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Right_Selected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Right_Unselected_Over");
	tabGroupButton._GetGroupButtonsInstance()._setButtonText(0, GetSystemString(506));
	tabGroupButton._GetGroupButtonsInstance()._setButtonValue(0, 0);
	tabGroupButton._GetGroupButtonsInstance()._setButtonText(1, GetSystemString(117));
	tabGroupButton._GetGroupButtonsInstance()._setButtonValue(1, 1);
	tabGroupButton._GetGroupButtonsInstance()._setButtonText(2, GetSystemString(14371));
	tabGroupButton._GetGroupButtonsInstance()._setButtonValue(2, 2);
	tabGroupButton._GetGroupButtonsInstance()._setShowButtonNum(3);
	tabGroupButton._GetGroupButtonsInstance()._setAutoWidth(403, 0);
	i = 0;
	while((i < 10))
	{
		AddGroupItemControl(skillGroupItemList, "Skill", i, skillScrollArea);
		i++;
	}
	return;
}

function AddGroupItemControl(out array<PetSkillWndGroupItem> componentList, string componentName, int Index, WindowHandle parentWnd)
{
	local WindowHandle targetWindowHandle;
	local PetSkillWndGroupItem targetControl;

	targetWindowHandle = GetWindowHandle((((parentWnd.m_WindowNameWithFullPath $ ".") $ componentName) $ string(Index)));
	targetWindowHandle.SetScript("PetSkillWndGroupItem");
	targetControl = PetSkillWndGroupItem(targetWindowHandle.GetScript());
	targetControl.Init(targetWindowHandle);
	targetControl.DelegateOnSkillInfoClicked = OnPetSkillSlotInfoClicked;
	componentList[componentList.Length] = targetControl;
	return;
}

function ResetSkillNoticeNumInfo()
{
	_skillNoticeNum = 0;
	return;
}

function UpdateSkillNoticeNum()
{
	if((_skillNoticeNum > 0))
	{
		skillNumTextBox.SetText(string(_skillNoticeNum));
		skillNumWnd.ShowWindow();
	}
	else
	{
		skillNumWnd.HideWindow();
	}
	petWndClassicScript.SetSkillNumControl(_skillNoticeNum);
	return;
}

function ResetSkillGroupInfo()
{
	_totalSkillInfos.Length = 0;
	_skillGroups.Length = 0;
	_itemSkillGroups.Length = 0;
	_canLearnSKillGroups.Length = 0;
	return;
}

function ResetActionGroupInfo()
{
	_actionSkillInfos.Length = 0;
	return;
}

function ResetInfo()
{
	ResetSkillGroupInfo();
	ResetActionGroupInfo();
	_totalSkillInfos.Length = 0;
	return;
}

function UpdateShortcutSkillInfo()
{
	_shortcutSKillList.Length = 0;
	_shortcutActionList.Length = 0;
	Class'NWindow.ShortcutWndAPI'.static.GetSkillAndActionListFromShortcutItems(_shortcutSKillList, _shortcutActionList);
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
	local PetSkillSlotInfo__PetSkillWnd slotInfo;
	local array<PetSkillSlotInfo__PetSkillWnd> petSkills, itemSkills, canLearnSKills;

	if((Me.IsShowWindow() == false))
	{
		return;
	}
	i = 0;
	while((i < _totalSkillInfos.Length))
	{
		slotInfo = _totalSkillInfos[i];
		if((slotInfo.learned == true))
		{
			slotInfo.isShortCut = CheckShortcutSkillRegistered(slotInfo.SkillInfo.SkillID);
		}
		else
		{
			slotInfo.isShortCut = false;
		}
		if(slotInfo.isCanLevelUp)
		{
			canLearnSKills[canLearnSKills.Length] = slotInfo;
		}
		if((slotInfo.isItemTypeSkill == true))
		{
			itemSkills[itemSkills.Length] = slotInfo;
			i++;
			continue;
		}
		petSkills[petSkills.Length] = slotInfo;
		i++;
	}
	i = 0;
	while((i < _actionSkillInfos.Length))
	{
		slotInfo = _actionSkillInfos[i];
		slotInfo.isShortCut = CheckShortcutActionRegistered(slotInfo.skillItemInfo.Id.ClassID);
		_actionSkillInfos[i] = slotInfo;
		i++;
	}
	MakePetSkillGroupInfos(petSkills, _skillGroups);
	MakePetSkillGroupInfos(itemSkills, _itemSkillGroups);
	MakePetSkillGroupInfos(canLearnSKills, _canLearnSKillGroups);
	return;
}

function MakePetSkillGroupInfos(array<PetSkillSlotInfo__PetSkillWnd> skillInfos, out array<PetSkillGroupInfo__PetSkillWnd> outPetSkillGroupInfos)
{
	local int i, IconType;
	local PetSkillSlotInfo__PetSkillWnd tempInfo;
	local PetSkillGroupInfo__PetSkillWnd tempGroupInfo, defaultGroupInfo;
	local array<PetSkillGroupInfo__PetSkillWnd> tempGroupInfos, finalGroupInfos;
	local array<PetSkillSlotInfo__PetSkillWnd> tempSkillArray;

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
	outPetSkillGroupInfos = finalGroupInfos;
	return;
}

function UpdateSkillTabControls()
{
	return;
}

function UpdateSkillGroupControls()
{
	local int i, wndHeight;
	local PetSkillWndGroupItem groupItem;
	local array<PetSkillGroupInfo__PetSkillWnd> skillGroupInfos;
	local PetSkillGroupInfo__PetSkillWnd actionGroup;

	skillEmptyTextBox.HideWindow();
	if((_selectedTabIndex == 0))
	{
		skillGroupInfos = _skillGroups;
		actionGroup.GroupType = -1;
		actionGroup.Skills = _actionSkillInfos;
		skillGroupInfos[skillGroupInfos.Length] = actionGroup;
	}
	else if((_selectedTabIndex == 1))
	{
		skillGroupInfos = _itemSkillGroups;
	}
	else if((_selectedTabIndex == 2))
	{
		skillGroupInfos = _canLearnSKillGroups;
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
	if(Class'InterfaceClassic.PetSkillInfoWnd'.static.Inst().Me.IsShowWindow())
	{
		Class'InterfaceClassic.PetSkillInfoWnd'.static.Inst().UpdateSkillInfoControls();
	}
	return;
}

delegate int OnSortByOrder(PetSkillSlotInfo__PetSkillWnd A, PetSkillSlotInfo__PetSkillWnd B)
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
	if((A.SkillInfo.SkillID != B.SkillInfo.SkillID))
	{
		if((A.SkillInfo.SkillID < B.SkillInfo.SkillID))
		{
			return 0;
		}
		else
		{
			return -1;
		}
	}
	return 0;
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

function bool CheckShortcutSkillRegistered(int SkillID)
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

function bool CheckShortcutActionRegistered(int ActionID)
{
	local int i;

	i = 0;
	while((i < _shortcutActionList.Length))
	{
		if((_shortcutActionList[i] == ActionID))
		{
			return true;
		}
		i++;
	}
	return false;
}

function SetSelectedTabIndex(int Index)
{
	_selectedTabIndex = Index;
	skillScrollArea.SetScrollPosition(0);
	UpdateUIControls();
	return;
}

function Rs_EV_PetSkillList(string param)
{
	local int i, j, Count, ClassID, Level, ReuseDelayShareGroupID, MinLevel, MaxLevel, replaceSkillId;
	local SkillInfo SkillInfo, replaceSkillInfo;
	local PetSkillSlotInfo__PetSkillWnd skillSlotInfo;
	local array<PetAcquireSkillInfo> acquireSkillList;
	local PetAcquireSkillInfo acquireSkillInfo;
	local PetInfo PetInfo;
	local bool isFound;

	ParseInt(param, "Count", Count);
	ResetSkillGroupInfo();
	ResetSkillNoticeNumInfo();
	GetPetInfo(PetInfo);
	i = 0;
	while((i < Count))
	{
		ParseInt(param, ("ClassID_" $ string(i)), ClassID);
		ParseInt(param, ("Level_" $ string(i)), Level);
		ParseInt(param, ("ReuseDelayShareGroupID_" $ string(i)), ReuseDelayShareGroupID);
		ParseInt(param, ("ReplaceID_" $ string(i)), replaceSkillId);
		ParseInt(param, ("MinLevel_" $ string(i)), MinLevel);
		ParseInt(param, ("MaxLevel_" $ string(i)), MaxLevel);
		if(!GetSkillInfo(ClassID, Level, 0, SkillInfo))
		{
			i++;
			continue;
		}
		if((SkillInfo.MagicType == 8))
		{
			i++;
			continue;
		}
		skillSlotInfo.SkillInfo = SkillInfo;
		skillSlotInfo.learned = true;
		Class'InterfaceClassic.L2Util'.static.GetSkill2ItemInfo(SkillInfo, skillSlotInfo.skillItemInfo);
		skillSlotInfo.skillItemInfo.ReuseDelayShareGroupID = ReuseDelayShareGroupID;
		skillSlotInfo.OrderID = SkillInfo.OrderID;
		skillSlotInfo.GroupType = SkillInfo.GroupType;
		skillSlotInfo.isItemTypeSkill = isItemTypeSkill(SkillInfo.IconType);
		skillSlotInfo.replaceSkillId = replaceSkillId;
		skillSlotInfo.MinLevel = MinLevel;
		skillSlotInfo.isCanLevelUp = false;
		skillSlotInfo.MaxLevel = MaxLevel;
		skillSlotInfo.skillItemInfo.iSkillDisabled = GetSkillAvailability(ClassID, Level, 0);
		if(((replaceSkillId > 0) && GetSkillInfo(replaceSkillId, Level, 0, replaceSkillInfo)))
		{
			skillSlotInfo.OrderID = replaceSkillInfo.OrderID;
			skillSlotInfo.GroupType = replaceSkillInfo.GroupType;
		}
		skillSlotInfo.isActiveSkill = IsActiveTypeSkill(SkillInfo.OperateType);
		if((SkillInfo.IconType == 8))
		{
			skillSlotInfo.skillItemInfo.ShortcutType = 7;
		}
		_totalSkillInfos[_totalSkillInfos.Length] = skillSlotInfo;
		i++;
	}
	Class'NWindow.PetAPI'.static.GetPetAcquireSkillList(PetInfo.nPetID, PetInfo.nLevel, PetInfo.nEvolutionStep, acquireSkillList);
	i = 0;
	while((i < acquireSkillList.Length))
	{
		acquireSkillInfo = acquireSkillList[i];
		if(!GetSkillInfo(acquireSkillInfo.SkillID, acquireSkillInfo.SkillLevel, 0, SkillInfo))
		{
			i++;
			continue;
		}
		isFound = false;
		j = 0;
		while((j < _totalSkillInfos.Length))
		{
			skillSlotInfo = _totalSkillInfos[j];
			if((skillSlotInfo.SkillInfo.SkillID == acquireSkillInfo.SkillID))
			{
				if(((PetInfo.nLevel >= acquireSkillInfo.NeedPetLevel) && (PetInfo.nEvolutionStep >= acquireSkillInfo.NeedPetEvolveStep)))
				{
					skillSlotInfo.isCanLevelUp = true;
					_skillNoticeNum++;
					_totalSkillInfos[j] = skillSlotInfo;
				}
				isFound = true;
				break;
			}
			j++;
		}
		if((isFound == false))
		{
			skillSlotInfo.SkillInfo = SkillInfo;
			skillSlotInfo.learned = false;
			Class'InterfaceClassic.L2Util'.static.GetSkill2ItemInfo(SkillInfo, skillSlotInfo.skillItemInfo);
			skillSlotInfo.OrderID = SkillInfo.OrderID;
			skillSlotInfo.GroupType = SkillInfo.GroupType;
			skillSlotInfo.MinLevel = acquireSkillInfo.SkillMinLevel;
			skillSlotInfo.MaxLevel = acquireSkillInfo.SkillMaxLevel;
			skillSlotInfo.isShortCut = false;
			skillSlotInfo.isItemTypeSkill = isItemTypeSkill(SkillInfo.IconType);
			skillSlotInfo.isActiveSkill = IsActiveTypeSkill(SkillInfo.OperateType);
			skillSlotInfo.replaceSkillId = -1;
			if(((PetInfo.nLevel >= acquireSkillInfo.NeedPetLevel) && (PetInfo.nEvolutionStep >= acquireSkillInfo.NeedPetEvolveStep)))
			{
				skillSlotInfo.isCanLevelUp = true;
				_skillNoticeNum++;
			}
			else
			{
				skillSlotInfo.isCanLevelUp = false;
			}
			_totalSkillInfos[_totalSkillInfos.Length] = skillSlotInfo;
		}
		i++;
	}
	UpdateSkillInfos();
	UpdateUIControls();
	UpdateSkillGroupControls();
	UpdateSkillNoticeNum();
	return;
}

function RequestPetActionList()
{
	Class'NWindow.ActionAPI'.static.RequestPetActionList();
	return;
}

function Nt_EV_PetWndShow(string param)
{
	Debug(("Nt_EV_PetWndShow" @ param));
	return;
}

function Nt_EV_PetStatusClose(string param)
{
	Debug(("Nt_EV_PetStatusClose" @ param));
	Me.HideWindow();
	return;
}

function Nt_EV_ActionListNew(string param)
{
	RequestPetActionList();
	return;
}

function Rs_EV_ActionPetListStart(string param)
{
	ResetActionGroupInfo();
	return;
}

function Rs_EV_ActionPetList(string param)
{
	local int nUsePetSkill;
	local PetSkillSlotInfo__PetSkillWnd slotInfo;
	local ItemInfo infItem;

	ParseItemID(param, infItem.Id);
	ParseString(param, "Name", infItem.Name);
	ParseString(param, "IconName", infItem.IconName);
	ParseString(param, "Description", infItem.Description);
	ParseString(param, "Command", infItem.MacroCommand);
	ParseInt(param, "UsePetSkill", nUsePetSkill);
	infItem.ShortcutType = 3;
	slotInfo.skillItemInfo = infItem;
	slotInfo.isActiveSkill = true;
	slotInfo.isAction = true;
	slotInfo.isCanLevelUp = false;
	slotInfo.learned = true;
	if((nUsePetSkill == 0))
	{
		_actionSkillInfos[_actionSkillInfos.Length] = slotInfo;
	}
	return;
}

function Rs_EV_ActionPetListEnd(string param)
{
	Debug(("Rs_EV_ActionPetListEnd" @ param));
	UpdateSkillInfos();
	UpdateSkillGroupControls();
	return;
}

function Nt_EV_ApplyPetSkillAvailability(string param)
{
	local int i, preSkillDisable, newSKillDisable;
	local PetSkillSlotInfo__PetSkillWnd slotInfo;
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
		UpdateSkillInfos();
		UpdateSkillDisableState();
	}
	return;
}

function Nt_EV_LanguageChanged()
{
	Debug("Nt_EV_LanguageChanged");
	return;
}

function Nt_EV_ShortcutSkillListUpdate()
{
	if((Me.IsShowWindow() == false))
	{
		return;
	}
	Debug("Nt_EV_ShortcutSkillListUpdate");
	UpdateShortcutInfoWithTimer();
	return;
}

event OnRegisterEvent()
{
	if((IsUseRenewalSkillWnd() == false))
	{
		return;
	}
	RegisterEvent(1010);
	RegisterEvent(1130);
	RegisterEvent(1311);
	RegisterEvent(1320);
	RegisterEvent(1330);
	RegisterEvent(1321);
	RegisterEvent(11480);
	RegisterEvent(1900);
	RegisterEvent(631);
	RegisterEvent(632);
	RegisterEvent(5365);
	return;
}

event OnEvent(int EventID, string param)
{
	if((IsUseRenewalSkillWnd() == false))
	{
		return;
	}
	switch(EventID)
	{
		case 1010:
			Nt_EV_PetWndShow(param);
			break;
		case 1130:
			Nt_EV_PetStatusClose(param);
			break;
		case 1311:
			Nt_EV_ActionListNew(param);
			break;
		case 1320:
			Rs_EV_ActionPetListStart(param);
			break;
		case 1330:
			Rs_EV_ActionPetList(param);
			break;
		case 11480:
			Rs_EV_PetSkillList(param);
			break;
		case 1900:
			Nt_EV_LanguageChanged();
			break;
		case 631:
		case 632:
			Nt_EV_ShortcutSkillListUpdate();
			break;
		case 5365:
			Nt_EV_ApplyPetSkillAvailability(param);
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

event OnPetSkillSlotInfoClicked(PetSkillSlotInfo__PetSkillWnd skillSlotInfo)
{
	local bool isShowSkillLearnPage;

	if((_selectedTabIndex == 2))
	{
		isShowSkillLearnPage = true;
	}
	Class'InterfaceClassic.PetSkillInfoWnd'.static.Inst().OpenWindow(skillSlotInfo, isShowSkillLearnPage);
	return;
}

event OnTabGroupBtnClicked(string parentWndName, string strName, int Index)
{
	SetSelectedTabIndex(Index);
	UpdateSkillInfoWnd();
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
	Me.SetFocus();
	tabGroupButton._GetGroupButtonsInstance()._setTopOrder(_selectedTabIndex, true);
	UpdateShortcutSkillInfo();
	RequestPetActionList();
	UpdateSkillInfos();
	UpdateUIControls();
	Nt_EV_ApplyPetSkillAvailability("");
	return;
}

event OnHide()
{
	Class'InterfaceClassic.PetSkillInfoWnd'.static.Inst().Me.HideWindow();
	Class'InterfaceClassic.PetSkillInfoWnd'.static.Inst().OnHide();
	_shortcutSKillList.Length = 0;
	_shortcutActionList.Length = 0;
	Me.KillTimer(1);
	_isWaitingSkillListResponse = false;
	return;
}

event OnReceivedCloseUI()
{
	if(Class'InterfaceClassic.PetSkillInfoWnd'.static.Inst().Me.IsShowWindow())
	{
		Class'InterfaceClassic.PetSkillInfoWnd'.static.Inst().OnReceivedCloseUI();
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		Me.HideWindow();
	}
	return;
}
