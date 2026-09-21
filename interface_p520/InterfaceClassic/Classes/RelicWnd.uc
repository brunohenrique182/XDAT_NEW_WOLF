class RelicWnd extends UICommonAPI
	dependson(UIPacket);

const COMBINE_MAX_STUFF = 4;
const COMBINE_MAX_GROUP = 11;
const UPGRADE_MAX_STUFF = 4;
const RELIC_GRADE_MAX = 7;







var array<RelicInfo> _relicInfos;
var array<RelicCollectionInfo> _relicCollectionInfos;
var RelicCombineInfo _relicCombineInfo;
var RelicUpgradeInfo _relicUpgradeInfo;
var RelicUIInfo _relicUIInfo;
var WindowHandle Me;
var UIControlGroupButtonAssets tabGroupButtonAsset;
var RelicWndList relicListScript;
var RelicWndInfo relicInfoScript;
var RelicWndUpgrade relicUpgradeScript;
var RelicWndCombine relicCombineScript;
var RelicWndCollection relicCollectionScript;
var RelicCombineProbWnd relicCombineProbScript;
var RelicWndShop relicWndShopScript;
//var delegate<DelegateChangeCombineStuffList> __DelegateChangeCombineStuffList__Delegate;
//var delegate<DelegateChangeCombineStuff> __DelegateChangeCombineStuff__Delegate;
//var delegate<DelegateChangeUpgradeStuffList> __DelegateChangeUpgradeStuffList__Delegate;
//var delegate<DelegateChangeUpgradeStuff> __DelegateChangeUpgradeStuff__Delegate;
//var delegate<DelegateChangeRelicList> __DelegateChangeRelicList__Delegate;
//var delegate<DelegateChangeNewState> __DelegateChangeNewState__Delegate;

delegate DelegateChangeCombineStuffList()
{
	return;
}

delegate DelegateChangeCombineStuff()
{
	return;
}

delegate DelegateChangeUpgradeStuffList()
{
	return;
}

delegate DelegateChangeUpgradeStuff()
{
	return;
}

delegate DelegateChangeRelicList()
{
	return;
}

delegate DelegateChangeNewState()
{
	return;
}

static function RelicWnd Inst()
{
	return RelicWnd(GetScript("RelicWnd"));
}

function Initialize()
{
	InitRelicAllData();
	InitControls();
	return;
}

function InitControls()
{
	local string ownerFullPath;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	tabGroupButtonAsset = Class'InterfaceClassic.UIControlGroupButtonAssets'.static._InitScript(GetWindowHandle((ownerFullPath $ ".UIControlGroupButtonAsset1")));
	relicListScript = RelicWndList(GetScript((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RelicWndList")));
	relicInfoScript = RelicWndInfo(GetScript((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RelicWndInfo")));
	relicUpgradeScript = RelicWndUpgrade(GetScript((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RelicWndUpgrade")));
	relicCombineScript = RelicWndCombine(GetScript((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RelicWndCombine")));
	relicCollectionScript = RelicWndCollection(GetScript((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RelicWndCollection")));
	relicCombineProbScript = RelicCombineProbWnd(GetScript("RelicCombineProbWnd"));
	relicWndShopScript = RelicWndShop(GetScript((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RelicWndShop")));
	DelegateChangeNewState = OnChangeTabNewState;
	InitTabControls();
	return;
}

function InitTabControls()
{
	local int i;

	tabGroupButtonAsset._SetStartInfo("L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Center_Unselected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Center_Selected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Center_Unselected_Over", true);
	tabGroupButtonAsset._GetGroupButtonsInstance().DelegateOnClickButton = OnTabGroupBtnClicked;
	tabGroupButtonAsset._GetGroupButtonsInstance()._setButtonTexture(0, "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Left_Unselected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Left_Selected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Left_Unselected_Over");
	tabGroupButtonAsset._GetGroupButtonsInstance()._setButtonTexture((5 - 1), "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Right_Unselected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Right_Selected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Right_Unselected_Over");
	tabGroupButtonAsset._GetGroupButtonsInstance()._setShowButtonNum(5);
	tabGroupButtonAsset._GetGroupButtonsInstance()._setAutoWidth(995, 0);
	i = 0;
	while((i < 5))
	{
		tabGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(i, GetRelicUIStateString(ERelicUIState(i)));
		tabGroupButtonAsset._DotTextureColorModify(i, GetColor(255, 200, 0, 255));
		tabGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(i, i);
		i++;
	}
	return;
}

function InitRelicAllData()
{
	ResetRelicUIInfo();
	ResetCombineInfo();
	ResetUpgradeInfo();
	InitRelicListData();
	InitRelicCollectionData();
	DelegateChangeNewState();
	return;
}

function InitRelicListData()
{
	local int i;
	local array<RelicsMainUIData> relicDataArray;
	local RelicsMainUIData tmpRelicData;
	local RelicInfo tmpRelicInfo;

	_relicInfos.Length = 0;
	GetRelicsMainDataAll(relicDataArray);
	i = 0;
	while((i < relicDataArray.Length))
	{
		tmpRelicData = relicDataArray[i];
		tmpRelicInfo.Data = tmpRelicData;
		tmpRelicInfo.relicId = tmpRelicData.RelicsID;
		_relicInfos[i] = tmpRelicInfo;
		i++;
	}
	return;
}

function InitRelicCollectionData()
{
	local int i;
	local array<RelicsCollectionUIData> collectionDataArray;
	local RelicsCollectionUIData tmpRelicData;
	local RelicCollectionInfo tmpCollectionInfo;

	_relicCollectionInfos.Length = 0;
	GetRelicsCollectionDataAll(collectionDataArray);
	i = 0;
	while((i < collectionDataArray.Length))
	{
		tmpRelicData = collectionDataArray[i];
		tmpCollectionInfo.Data = tmpRelicData;
		tmpCollectionInfo.CollectionID = tmpRelicData.CollectionID;
		_relicCollectionInfos[i] = tmpCollectionInfo;
		i++;
	}
	return;
}

function ResetRelicUIInfo()
{
	local RelicUIInfo defaultInfo;

	_relicUIInfo = defaultInfo;
	return;
}

function ResetCombineInfo()
{
	local RelicCombineInfo defaultInfo;

	_relicCombineInfo = defaultInfo;
	return;
}

function ResetUpgradeInfo()
{
	local RelicUpgradeInfo defaultInfo;

	_relicUpgradeInfo = defaultInfo;
	return;
}

function SetForm(ERelicUIState uiState)
{
	switch(uiState)
	{
		case List:
			relicListScript.Me.ShowWindow();
			relicInfoScript.Me.ShowWindow();
			relicUpgradeScript.Me.HideWindow();
			relicCombineScript.Me.HideWindow();
			relicCollectionScript.Me.HideWindow();
			relicWndShopScript.m_hOwnerWnd.HideWindow();
			DelegateChangeRelicList();
			relicListScript.SetUseSelect(true);
			relicListScript.SetSelected(0, true);
			relicListScript.SetDefaultInfo();
			break;
		case SHOP:
			relicListScript.Me.HideWindow();
			relicInfoScript.Me.HideWindow();
			relicUpgradeScript.Me.HideWindow();
			relicCombineScript.Me.HideWindow();
			relicCollectionScript.Me.HideWindow();
			relicWndShopScript.m_hOwnerWnd.ShowWindow();
			break;
		case UPGRADE:
			relicListScript.Me.ShowWindow();
			relicInfoScript.Me.HideWindow();
			relicUpgradeScript.Me.ShowWindow();
			relicCombineScript.Me.HideWindow();
			relicCollectionScript.Me.HideWindow();
			relicWndShopScript.m_hOwnerWnd.HideWindow();
			ResetUpgradeInfo();
			DelegateChangeUpgradeStuff();
			DelegateChangeUpgradeStuffList();
			relicListScript.SetUseSelect(false);
			break;
		case COMBINE:
			relicListScript.Me.ShowWindow();
			relicInfoScript.Me.HideWindow();
			relicUpgradeScript.Me.HideWindow();
			relicCombineScript.Me.ShowWindow();
			relicCollectionScript.Me.HideWindow();
			relicWndShopScript.m_hOwnerWnd.HideWindow();
			ResetCombineInfo();
			relicCombineScript.HideModalAndDialog();
			DelegateChangeCombineStuff();
			DelegateChangeCombineStuffList();
			relicListScript.SetUseSelect(false);
			break;
		case COLLECTION:
			relicListScript.Me.HideWindow();
			relicInfoScript.Me.HideWindow();
			relicUpgradeScript.Me.HideWindow();
			relicCombineScript.Me.HideWindow();
			relicCollectionScript.Me.ShowWindow();
			relicWndShopScript.m_hOwnerWnd.HideWindow();
			relicCollectionScript.HideDetailInfoDialog();
			relicCollectionScript.UpdateCollectionList();
			break;
		default:
			break;
	}
	return;
}

function array<RelicInfo> GetRelicInfos()
{
	return _relicInfos;
}

function SkillInfo GetActiveRelicSkill()
{
	local int activeRelicId;
	local RelicInfo RelicInfo;
	local SkillInfo relicSkillInfo;
	local SkillDefaultInfo SkillDefaultInfo;

	activeRelicId = GetActiveRelicId();
	if((activeRelicId > 0))
	{
		RelicInfo = GetRelicInfo(activeRelicId);
		if((RelicInfo.Level < RelicInfo.Data.Skills.Length))
		{
			SkillDefaultInfo = RelicInfo.Data.Skills[RelicInfo.Level];
			GetSkillInfo(SkillDefaultInfo.SkillID, SkillDefaultInfo.SkillLevel, 0, relicSkillInfo);
		}
	}
	return relicSkillInfo;
}

function array<RelicInfo> GetRelicInfosByGrade(UIConstants.ERelicGrade Grade)
{
	local array<RelicInfo> relicInfos;
	local int i;

	i = 0;
	while((i < _relicInfos.Length))
	{
		if((_relicInfos[i].Data.Grade == int(Grade)))
		{
			relicInfos[relicInfos.Length] = _relicInfos[i];
		}
		i++;
	}
	return relicInfos;
}

function RelicInfo GetRelicInfo(int relicId)
{
	local RelicInfo Info;
	local int i;

	i = 0;
	while((i < _relicInfos.Length))
	{
		if((_relicInfos[i].Data.RelicsID == relicId))
		{
			return _relicInfos[i];
		}
		i++;
	}
	return Info;
}

function RelicUIInfo GetRelicUIInfo()
{
	return _relicUIInfo;
}

function array<RelicCollectionInfo> GetRelicCollectionInfos()
{
	return _relicCollectionInfos;
}

function RelicCombineInfo GetCombineInfo()
{
	return _relicCombineInfo;
}

function RelicUpgradeInfo GetUpgradeInfo()
{
	return _relicUpgradeInfo;
}

function int GetActiveRelicId()
{
	return 0;
}

function string GetRelicUIStateString(ERelicUIState uiState)
{
	switch(uiState)
	{
		case List:
			return GetSystemString(14491);
		case UPGRADE:
			return GetSystemString(2066);
		case COMBINE:
			return GetSystemString(3189);
		case SHOP:
			return GetSystemString(1543);
		case COLLECTION:
			return GetSystemString(14492);
		default:
			return "";
	}
}

function string GetCollectionStatValueStr(RelicsCollectionOption Option)
{
	local string statValueStr;

	if((int(Option.OptionType) > 0))
	{
		if((Option.OptionValue > 0.0000000))
		{
			statValueStr = ("+" $ getInstanceL2Util().CutFloatDecimalPlaces(Option.OptionValue, 1));
		}
		else if((Option.OptionValue < 0.0000000))
		{
			statValueStr = ("-" $ getInstanceL2Util().CutFloatDecimalPlaces(-Option.OptionValue, 1));
		}
	}
	else if((Option.OptionValue > 0.0000000))
	{
		statValueStr = ("+" $ string(int(Option.OptionValue)));
	}
	else
	{
		statValueStr = string(int(Option.OptionValue));
	}
	return statValueStr;
}

function string GetCollectionStatNameStr(RelicsCollectionOption Option)
{
	local string statNameStr;

	statNameStr = Option.OptionName;
	if(((statNameStr == "Str") || (statNameStr == "Int")))
	{
		statNameStr = Caps(statNameStr);
	}
	return statNameStr;
}

function string GetCollectionStatStr(array<RelicsCollectionOption> Options)
{
	local string statStr;
	local RelicsCollectionOption tmpOption;
	local int i;

	i = 0;
	while((i < Options.Length))
	{
		tmpOption = Options[i];
		statStr = ((statStr $ GetCollectionStatNameStr(tmpOption)) @ GetCollectionStatValueStr(tmpOption));
		if((i != (Options.Length - 1)))
		{
			statStr = (statStr $ ", ");
		}
		i++;
	}
	return statStr;
}

function string GetHtmlSkillStr(SkillDefaultInfo defaultInfo)
{
	local SkillInfo relicSkillInfo;
	local string htmlStr, SkillDesc;

	GetSkillInfo(defaultInfo.SkillID, defaultInfo.SkillLevel, 0, relicSkillInfo);
	SkillDesc = relicSkillInfo.SkillDesc;
	SkillDesc = Substitute(SkillDesc, "<", "&lt;", false);
	SkillDesc = Substitute(SkillDesc, ">", "&gt;", false);
	SkillDesc = Substitute(SkillDesc, "&lt;font", "<font", false);
	SkillDesc = Substitute(SkillDesc, "\"&gt;", "\">", false);
	SkillDesc = Substitute(SkillDesc, "&lt;/font&gt;", "</font>", false);
	SkillDesc = Substitute(SkillDesc, "\\n\\n", "<br>", false);
	SkillDesc = Substitute(SkillDesc, "\\n", "<br1>", false);
	htmlStr = htmlAddText(relicSkillInfo.SkillName, "", "ffdd66");
	htmlStr = ((htmlStr $ "<br1>") $ SkillDesc);
	htmlStr = htmlSetHtmlStart(htmlStr);
	return htmlStr;
}

function UpdateRelicActiveInfos()
{
	local int i, j;
	local bool foundActiveRelic;
	local array<RelicInfo> activeRelics;
	local RelicInfo tmpRelicInfo;

	i = 0;
	while((i < _relicInfos.Length))
	{
		tmpRelicInfo = _relicInfos[i];
		if(tmpRelicInfo.isEnabled)
		{
			CalculateActiveInfos(tmpRelicInfo, activeRelics);
		}
		i++;
	}
	i = 0;
	while((i < _relicInfos.Length))
	{
		tmpRelicInfo = _relicInfos[i];
		foundActiveRelic = false;
		j = 0;
		while((j < activeRelics.Length))
		{
			if((tmpRelicInfo.relicId == activeRelics[j].relicId))
			{
				foundActiveRelic = true;
				break;
			}
			j++;
		}
		if(foundActiveRelic)
		{
			tmpRelicInfo.IsActive = true;
		}
		else
		{
			tmpRelicInfo.IsActive = false;
		}
		_relicInfos[i] = tmpRelicInfo;
		i++;
	}
	return;
}

function UpdateRelicInfos(array<UIPacket._RelicsInfo> relicList, bool Init)
{
	local int i;
	local UIPacket._RelicsInfo tmpInfo;
	local bool oldNewState;

	oldNewState = _relicUIInfo.isListNew;
	i = 0;
	while((i < relicList.Length))
	{
		tmpInfo = relicList[i];
		FindAndUpdateRelicInfo(tmpInfo.nRelicsID, tmpInfo.nLevel, tmpInfo.nCount, Init);
		i++;
	}
	if(_relicUIInfo.isListNew)
	{
		UpdateRelicActiveInfos();
	}
	if((oldNewState != _relicUIInfo.isListNew))
	{
		DelegateChangeNewState();
	}
	if((Init == false))
	{
		DelegateChangeRelicList();
	}
	return;
}

function UpdateCollectionInfos(array<UIPacket._RelicsCollection> collectionList, bool Init)
{
	local int i;
	local UIPacket._RelicsCollection tmpInfo;
	local bool oldNewState;

	oldNewState = _relicUIInfo.isCollectionNew;
	i = 0;
	while((i < collectionList.Length))
	{
		tmpInfo = collectionList[i];
		FindAndUpdateCollectionInfo(collectionList[i], Init);
		i++;
	}
	if((oldNewState != _relicUIInfo.isCollectionNew))
	{
		DelegateChangeNewState();
	}
	if((Init == false))
	{
	}
	return;
}

function CalculateActiveInfos(RelicInfo Info, out array<RelicInfo> activeRelic)
{
	local int i;
	local RelicInfo activeInfo;
	local int SkillID;
	local bool added;

	SkillID = Info.Data.Skills[0].SkillID;
	i = 0;
	while((i < activeRelic.Length))
	{
		activeInfo = activeRelic[i];
		if((activeInfo.Data.Skills[0].SkillID == SkillID))
		{
			added = true;
			if((activeInfo.Data.Grade < Info.Data.Grade))
			{
				activeRelic[i] = Info;
				return;
			}
		}
		i++;
	}
	if((added == false))
	{
		activeRelic[activeRelic.Length] = Info;
	}
	return;
}

function FindAndUpdateRelicInfo(int relicId, int Level, int Count, bool Init)
{
	local int i;
	local RelicInfo tmpInfo;

	i = 0;
	while((i < _relicInfos.Length))
	{
		tmpInfo = _relicInfos[i];
		if((tmpInfo.relicId == relicId))
		{
			if(((Init == false) && (tmpInfo.isEnabled == false)))
			{
				tmpInfo.IsNew = true;
				_relicUIInfo.isListNew = true;
			}
			tmpInfo.Level = Level;
			tmpInfo.Count = INT64(Count);
			tmpInfo.isEnabled = true;
			_relicInfos[i] = tmpInfo;
			return;
		}
		i++;
	}
	return;
}

function FindAndUpdateCollectionInfo(UIPacket._RelicsCollection CollectionInfo, bool Init)
{
	local int i;
	local RelicCollectionInfo tmpInfo;

	i = 0;
	while((i < _relicCollectionInfos.Length))
	{
		tmpInfo = _relicCollectionInfos[i];
		if((tmpInfo.CollectionID == CollectionInfo.nCollectionID))
		{
			if((((Init == false) && (tmpInfo.isComplete == false)) && (int(CollectionInfo.bComplete) == 1)))
			{
				tmpInfo.IsNew = true;
				_relicUIInfo.isCollectionNew = true;
			}
			tmpInfo.relicsList = CollectionInfo.relicsList;
			tmpInfo.isComplete = bool(CollectionInfo.bComplete);
			_relicCollectionInfos[i] = tmpInfo;
			return;
		}
		i++;
	}
	return;
}

function UpdateTabAlarmState()
{
	local int i;

	i = 0;
	while((i < 5))
	{
		if((((int(byte(i)) == 0) && _relicUIInfo.isListNew) || ((int(byte(i)) == 4) && _relicUIInfo.isCollectionNew)))
		{
			tabGroupButtonAsset._DotTextureShow(i, true);
			i++;
			continue;
		}
		tabGroupButtonAsset._DotTextureShow(i, false);
		i++;
	}
	return;
}

function ClearRelicInfosNewState()
{
	local int i;
	local RelicInfo tmpInfo;

	i = 0;
	while((i < _relicInfos.Length))
	{
		tmpInfo = _relicInfos[i];
		tmpInfo.IsNew = false;
		_relicInfos[i] = tmpInfo;
		i++;
	}
	_relicUIInfo.isListNew = false;
	return;
}

function ClearCollectionInfosNewState()
{
	local int i;
	local RelicCollectionInfo tmpInfo;

	i = 0;
	while((i < _relicCollectionInfos.Length))
	{
		tmpInfo = _relicCollectionInfos[i];
		tmpInfo.IsNew = false;
		_relicCollectionInfos[i] = tmpInfo;
		i++;
	}
	_relicUIInfo.isCollectionNew = false;
	return;
}

function RegisterUpgradeStuff(int relicId, optional bool useEvent)
{
	local RelicsMainUIData stuffData;

	GetRelicsMainData(relicId, stuffData);
	if((_relicUpgradeInfo.targetRelicId == 0))
	{
		return;
	}
	if((_relicUpgradeInfo.stuffArray.Length >= 4))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13918));
		return;
	}
	if((_relicUpgradeInfo.RelicInfo.Data.Grade != stuffData.Grade))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13919));
		return;
	}
	_relicUpgradeInfo.stuffArray[_relicUpgradeInfo.stuffArray.Length] = relicId;
	if(useEvent)
	{
		DelegateChangeUpgradeStuff();
		DelegateChangeUpgradeStuffList();
	}
	return;
}

function UnegisterUpgradeStuff(int relicId)
{
	return;
}

function bool RegisterCombineStuff(int relicId, optional bool useEvent)
{
	local int maxStuff, stuffCnt;
	local RelicsMainUIData relicData;

	maxStuff = (4 * 11);
	stuffCnt = _relicCombineInfo.stuffTotalArray.Length;
	GetRelicsMainData(relicId, relicData);
	if((stuffCnt >= maxStuff))
	{
		return false;
	}
	if((stuffCnt == 0))
	{
		_relicCombineInfo.Grade = ERelicGrade(relicData.Grade);
	}
	else if((int(_relicCombineInfo.Grade) != int(byte(relicData.Grade))))
	{
		return false;
	}
	_relicCombineInfo.stuffTotalArray[_relicCombineInfo.stuffTotalArray.Length] = relicId;
	if(useEvent)
	{
		DelegateChangeCombineStuff();
		DelegateChangeCombineStuffList();
	}
	return true;
}

function UnregisterCombineStuff(int relicId)
{
	return;
}

function int GetRegisteredCombineStuffCount(int relicId)
{
	local int i, stuffCnt;

	i = 0;
	while((i < _relicCombineInfo.stuffTotalArray.Length))
	{
		if((_relicCombineInfo.stuffTotalArray[i] == relicId))
		{
			stuffCnt++;
		}
		i++;
	}
	return stuffCnt;
}

function int GetRegisteredUpgradeStuffCount(int relicId)
{
	local int i, stuffCnt;

	i = 0;
	while((i < _relicUpgradeInfo.stuffArray.Length))
	{
		if((_relicUpgradeInfo.stuffArray[i] == relicId))
		{
			stuffCnt++;
		}
		i++;
	}
	return stuffCnt;
}

function AutoRegisterCombineStuffs()
{
	local int i;
	local array<int> stuffList;
	local UIConstants.ERelicGrade targetGrade;

	targetGrade = relicListScript.GetSelectedTabGrade();
	if((int(targetGrade) == 0))
	{
		i = 1;
		while((i <= 7))
		{
			stuffList = GetStuffListByGrade(ERelicGrade(i));
			stuffList.Length = ((stuffList.Length / 4) * 4);
			if((stuffList.Length >= 4))
			{
				targetGrade = ERelicGrade(i);
				relicListScript.SetTabSelected(targetGrade);
				break;
			}
			i++;
		}
	}
	else
	{
		stuffList = GetStuffListByGrade(targetGrade);
		stuffList.Length = ((stuffList.Length / 4) * 4);
	}
	if((stuffList.Length == 0))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13917));
		return;
	}
	ResetCombineInfo();
	i = 0;
	while((i < stuffList.Length))
	{
		if((RegisterCombineStuff(stuffList[i]) == false))
		{
			break;
		}
		i++;
	}
	DelegateChangeCombineStuff();
	DelegateChangeCombineStuffList();
	return;
}

function ResetUpgradeTargetRelic()
{
	ResetUpgradeInfo();
	DelegateChangeUpgradeStuff();
	DelegateChangeUpgradeStuffList();
	return;
}

function ResetUpgradeStuffList()
{
	_relicUpgradeInfo.stuffArray.Length = 0;
	DelegateChangeUpgradeStuff();
	DelegateChangeUpgradeStuffList();
	return;
}

function ShowCollectionCompleteMessage(int CollectionID)
{
	local string statStr, paramStr;
	local RelicsCollectionUIData CollectionData;

	if((GetRelicsCollectionData(CollectionID, CollectionData) == false))
	{
		return;
	}
	statStr = GetCollectionStatStr(CollectionData.Options);
	ParamAdd(paramStr, "Type", string(0));
	ParamAdd(paramStr, "param1", CollectionData.CollectionName);
	AddSystemMessageParam(paramStr);
	paramStr = "";
	ParamAdd(paramStr, "Type", string(0));
	ParamAdd(paramStr, "param1", statStr);
	AddSystemMessageParam(paramStr);
	EndSystemMessageParam(13893, false);
	return;
}

function array<int> GetStuffListByGrade(UIConstants.ERelicGrade Grade)
{
	local int i, j, maxStuffCnt;
	local array<int> stuffList;
	local RelicInfo tmpRelicInfo;

	maxStuffCnt = (4 * 11);
	if((GetRelicsUncombinableGrade() == int(Grade)))
	{
		return stuffList;
	}
	i = 0;
	while((i < _relicInfos.Length))
	{
		tmpRelicInfo = _relicInfos[i];
		if(((tmpRelicInfo.Count > INT64(0)) && (tmpRelicInfo.Data.Grade == int(Grade))))
		{
			j = 0;
			while((INT64(j) < Min64(INT64(maxStuffCnt), tmpRelicInfo.Count)))
			{
				stuffList[stuffList.Length] = tmpRelicInfo.relicId;
				j++;
			}
		}
		if((stuffList.Length > maxStuffCnt))
		{
			return stuffList;
		}
		i++;
	}
	return stuffList;
}

function SetTabGroupButtonSelected(ERelicUIState uiState)
{
	_relicUIInfo.uiState = uiState;
	tabGroupButtonAsset._GetGroupButtonsInstance()._setTopOrder(int(uiState));
	return;
}

function OnSelectTileList(RelicInfo Info)
{
	if((Me.IsShowWindow() == false))
	{
		return;
	}
	if((int(_relicUIInfo.uiState) == 0))
	{
		relicInfoScript.SetInfo(Info);
	}
	return;
}

function OnClickTileList(RelicInfo Info)
{
	if((int(_relicUIInfo.uiState) == 2))
	{
		if((Info.isStuffDisable == false))
		{
			if((int(relicListScript.GetSelectedTabGrade()) != int(byte(Info.Data.Grade))))
			{
				relicListScript.SetTabSelected(ERelicGrade(Info.Data.Grade));
			}
			if(((_relicCombineInfo.stuffTotalArray.Length != 0) && (int(byte(Info.Data.Grade)) != int(_relicCombineInfo.Grade))))
			{
				ResetCombineInfo();
			}
			RegisterCombineStuff(Info.relicId, true);
		}
	}
	else if((int(_relicUIInfo.uiState) == 3))
	{
		if((Info.isStuffDisable == false))
		{
			if((_relicUpgradeInfo.targetRelicId == 0))
			{
				if((Info.Level >= (Info.Data.Skills.Length - 1)))
				{
					getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13203));
					return;
				}
				_relicUpgradeInfo.targetRelicId = Info.relicId;
				_relicUpgradeInfo.RelicInfo = Info;
				relicListScript.SetTabSelected(ERelicGrade(Info.Data.Grade));
				DelegateChangeUpgradeStuff();
				DelegateChangeUpgradeStuffList();
			}
			else
			{
				if(relicUpgradeScript.IsShowResultWnd())
				{
					return;
				}
				RegisterUpgradeStuff(Info.relicId, true);
			}
		}
	}
	return;
}

function bool IsOpenWindow()
{
	return Me.IsShowWindow();
}

function OpenWindow()
{
	CheckAndShowVisible();
	Me.ShowWindow();
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("RelicSummonWnd"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("RelicSummonWnd");
	}
	return;
}

function CloseWindow()
{
	Me.HideWindow();
	return;
}

function CheckAndShowVisible()
{
	if((Me.IsShowWindow() && (Me.IsVisibility() == false)))
	{
		Me.SetVisibility(true);
	}
	return;
}

function CheckAndHideVisible()
{
	if((Me.IsShowWindow() && (Me.IsVisibility() == true)))
	{
		Me.SetVisibility(false);
	}
	return;
}

function bool IsShowAndVisible()
{
	if((Me.IsShowWindow() && Me.IsVisibility()))
	{
		return true;
	}
	return false;
}

function bool CheckAndCloseDialog()
{
	if((int(_relicUIInfo.uiState) == 4))
	{
		if(relicCollectionScript.IsShowDialog())
		{
			relicCollectionScript.HideDetailInfoDialog();
			return true;
		}
	}
	return false;
}

function UpdateInventoryAndShortcutTooltip()
{
	InventoryWnd(GetScript("InventoryWnd")).clearEquipItemTooltip();
	ShortcutWnd(GetScript("ShortcutWnd")).ClearAllShortcutItemTooltip();
	return;
}

function RequestRelicCombine()
{
	local array<int> stuffList;

	if(((int(_relicCombineInfo.Grade) != 0) && (_relicCombineInfo.stuffTotalArray.Length >= 4)))
	{
		stuffList = _relicCombineInfo.stuffTotalArray;
		stuffList.Length = ((stuffList.Length / 4) * 4);
		Rq_C_EX_RELICS_COMBINATION(int(_relicCombineInfo.Grade), stuffList);
		ResetCombineInfo();
		DelegateChangeCombineStuff();
	}
	return;
}

function RequestRelicUpgrade()
{
	if((((_relicUpgradeInfo.targetRelicId != 0) && (_relicUpgradeInfo.stuffArray.Length > 0)) && (_relicUpgradeInfo.stuffArray.Length <= 4)))
	{
		Rq_C_EX_RELICS_UPGRADE(_relicUpgradeInfo.RelicInfo.relicId, _relicUpgradeInfo.RelicInfo.Level, _relicUpgradeInfo.stuffArray);
	}
	return;
}

function Rq_C_EX_RELICS_OPEN_UI()
{
	local array<byte> stream;
	local UIPacket._C_EX_RELICS_OPEN_UI packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_RELICS_OPEN_UI(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(855, stream);
	return;
}

function Rq_C_EX_RELICS_CLOSE_UI()
{
	local array<byte> stream;
	local UIPacket._C_EX_RELICS_CLOSE_UI packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_RELICS_CLOSE_UI(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(856, stream);
	return;
}

function Rq_C_EX_RELICS_UPGRADE(int relicId, int relicLevel, array<int> stuffList)
{
	local array<byte> stream;
	local UIPacket._C_EX_RELICS_UPGRADE packet;

	packet.nRelicsID = relicId;
	packet.nLevel = relicLevel;
	packet.stuffList = stuffList;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_RELICS_UPGRADE(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(862, stream);
	return;
}

function Rq_C_EX_RELICS_COMBINATION(int relicGrade, array<int> stuffList)
{
	local array<byte> stream;
	local UIPacket._C_EX_RELICS_COMBINATION packet;

	packet.nGrade = relicGrade;
	packet.stuffList = stuffList;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_RELICS_COMBINATION(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(863, stream);
	return;
}

function Nt_S_EX_RELICS_LIST()
{
	local UIPacket._S_EX_RELICS_LIST packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_RELICS_LIST(packet))
	{
		return;
	}
	UpdateRelicInfos(packet.relicsList, true);
	UpdateRelicActiveInfos();
	return;
}

function Nt_S_EX_RELICS_UPDATE_LIST()
{
	local UIPacket._S_EX_RELICS_UPDATE_LIST packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_RELICS_UPDATE_LIST(packet))
	{
		return;
	}
	UpdateRelicInfos(packet.relicsList, false);
	return;
}

function Rs_S_EX_RELICS_COMBINATION()
{
	local UIPacket._S_EX_RELICS_COMBINATION packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_RELICS_COMBINATION(packet))
	{
		return;
	}
	if((packet.cResult == 0))
	{
		DelegateChangeCombineStuffList();
	}
	return;
}

function Rs_S_EX_RELICS_UPGRADE()
{
	local UIPacket._S_EX_RELICS_UPGRADE packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_RELICS_UPGRADE(packet))
	{
		return;
	}
	if((_relicUpgradeInfo.RelicInfo.relicId == packet.nRelicsID))
	{
		_relicUpgradeInfo.RelicInfo.Level = packet.nLevel;
	}
	ResetUpgradeStuffList();
	relicUpgradeScript.setResult(packet.cResult, packet.nLevel, packet.nRelicsID);
	if(((packet.cResult == 1) && (GetActiveRelicId() == packet.nRelicsID)))
	{
		UpdateInventoryAndShortcutTooltip();
	}
	return;
}

function Nt_S_EX_RELICS_COLLECTION_INFO()
{
	local UIPacket._S_EX_RELICS_COLLECTION_INFO packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_RELICS_COLLECTION_INFO(packet))
	{
		return;
	}
	UpdateCollectionInfos(packet.collectionList, true);
	return;
}

function Nt_S_EX_RELICS_COLLECTION_UPDATE()
{
	local UIPacket._S_EX_RELICS_COLLECTION_UPDATE packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_RELICS_COLLECTION_UPDATE(packet))
	{
		return;
	}
	UpdateCollectionInfos(packet.collectionList, false);
	return;
}

function Nt_S_EX_RELICS_ANNOUNCE()
{
	local UIPacket._S_EX_RELICS_ANNOUNCE packet;
	local string UserName, msgStr, paramStr, ChatMsg;
	local int SystemMsgID, chatSystemMsgId;
	local RelicsMainUIData relicUIData;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_RELICS_ANNOUNCE(packet))
	{
		return;
	}
	UserName = ConvertWorldIDToStr(packet.sUserName);
	GetRelicsMainData(packet.nRelicsID, relicUIData);
	if((UserName != ""))
	{
		SystemMsgID = 13891;
		chatSystemMsgId = 13889;
	}
	else
	{
		UserName = GetSystemString(13198);
		SystemMsgID = 13892;
		chatSystemMsgId = 13890;
	}
	msgStr = MakeFullSystemMsg(GetSystemMessage(SystemMsgID), UserName);
	Class'InterfaceClassic.OnscreenEffectViewPortWnd'.static.Inst()._playEffectViewWithText(1.0000000, 1999.0000000, "", 0, 0, 0, -10, 0, 5000, 500, msgStr, L2Util(GetScript("L2Util")).White, GetItemInfoByClassID(relicUIData.ItemID), , true, ERelicGrade(relicUIData.Grade));
	ParamAdd(paramStr, "Type", string(0));
	ParamAdd(paramStr, "param1", UserName);
	AddSystemMessageParam(paramStr);
	paramStr = "";
	ParamAdd(paramStr, "Type", string(0));
	ParamAdd(paramStr, "param1", getInstanceL2Util().GetDollNameWithGrade(GetItemInfoByClassID(relicUIData.ItemID).Name, ERelicGrade(relicUIData.Grade)));
	AddSystemMessageParam(paramStr);
	ChatMsg = EndSystemMessageParam(chatSystemMsgId, true);
	AddSystemMessageString(ChatMsg);
	return;
}

function Nt_S_EX_RELICS_COLLECTION_COMPLETE_ANNOUNCE()
{
	local UIPacket._S_EX_RELICS_COLLECTION_COMPLETE_ANNOUNCE packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_RELICS_COLLECTION_COMPLETE_ANNOUNCE(packet))
	{
		return;
	}
	ShowCollectionCompleteMessage(packet.nCollectionID);
	return;
}

function Nt_S_EX_ALL_RESET_RELICS()
{
	local UIPacket._S_EX_ALL_RESET_RELICS packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_ALL_RESET_RELICS(packet))
	{
		return;
	}
	InitRelicAllData();
	Me.HideWindow();
	return;
}

event OnTabGroupBtnClicked(string parentWndName, string strName, int Index)
{
	local ERelicUIState CurrentState;

	CurrentState = _relicUIInfo.uiState;
	_relicUIInfo.uiState = ERelicUIState(tabGroupButtonAsset._GetGroupButtonsInstance()._getButtonValue(Index));
	if(((int(CurrentState) == 0) && (int(_relicUIInfo.uiState) != 0)))
	{
		if(_relicUIInfo.isListNew)
		{
			ClearRelicInfosNewState();
			DelegateChangeNewState();
		}
		relicInfoScript.ResetInfo();
	}
	if(((int(CurrentState) == 4) && (int(_relicUIInfo.uiState) != 4)))
	{
		if(_relicUIInfo.isCollectionNew)
		{
			ClearCollectionInfosNewState();
			DelegateChangeNewState();
		}
	}
	if(((int(CurrentState) == 3) && (int(_relicUIInfo.uiState) != 3)))
	{
		relicUpgradeScript.HideModalAndDialog();
	}
	if(((int(CurrentState) == 2) && (int(_relicUIInfo.uiState) != 2)))
	{
		relicCombineScript.HideModalAndDialog();
	}
	SetForm(_relicUIInfo.uiState);
	return;
}

event OnChangeTabNewState()
{
	UpdateTabAlarmState();
	return;
}

event OnClickButton(string buttonStr)
{
	switch(buttonStr)
	{
		case "WindowHelp_BTN":
			Class'InterfaceClassic.HelpWnd'.static.ShowHelp(75);
			break;
		default:
			break;
	}
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(40);
	RegisterEvent(EV_PacketID(1114));
	RegisterEvent(EV_PacketID(1135));
	RegisterEvent(EV_PacketID(1120));
	RegisterEvent(EV_PacketID(1119));
	RegisterEvent(EV_PacketID(1121));
	RegisterEvent(EV_PacketID(1122));
	RegisterEvent(EV_PacketID(1113));
	RegisterEvent(EV_PacketID(1138));
	RegisterEvent(EV_PacketID(1137));
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
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("RelicSummonWnd"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("RelicSummonWnd");
		if((Me.IsVisibility() == false))
		{
			Me.SetVisibility(true);
			return;
		}
	}
	m_hOwnerWnd.SetVisibility(true);
	_relicUIInfo.uiState = List;
	relicListScript.SetDefaultTab();
	relicInfoScript.SetViewportSpawnNPC();
	tabGroupButtonAsset._GetGroupButtonsInstance()._setTopOrder(int(_relicUIInfo.uiState), true);
	SetForm(_relicUIInfo.uiState);
	relicListScript.SetDefaultInfo();
	Rq_C_EX_RELICS_OPEN_UI();
	return;
}

event OnHide()
{
	Rq_C_EX_RELICS_CLOSE_UI();
	if(_relicUIInfo.isListNew)
	{
		ClearRelicInfosNewState();
	}
	if(_relicUIInfo.isCollectionNew)
	{
		ClearCollectionInfosNewState();
	}
	ResetCombineInfo();
	ResetUpgradeInfo();
	relicUpgradeScript.ResetInfo();
	relicUpgradeScript.HideModalAndDialog();
	relicCombineScript.HideModalAndDialog();
	relicCombineScript.ResetInfo();
	relicListScript.SetSelected(-1);
	relicInfoScript.ResetInfo();
	relicInfoScript.ResetSpawnEffect();
	DelegateChangeNewState();
	m_hOwnerWnd.SetVisibility(true);
	return;
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case 40:
			InitRelicAllData();
			break;
		case EV_PacketID(1114):
			Nt_S_EX_RELICS_LIST();
			break;
		case EV_PacketID(1135):
			Nt_S_EX_RELICS_UPDATE_LIST();
			break;
		case EV_PacketID(1120):
			Rs_S_EX_RELICS_COMBINATION();
			break;
		case EV_PacketID(1119):
			Rs_S_EX_RELICS_UPGRADE();
			break;
		case EV_PacketID(1121):
			Nt_S_EX_RELICS_COLLECTION_INFO();
			break;
		case EV_PacketID(1122):
			Nt_S_EX_RELICS_COLLECTION_UPDATE();
			break;
		case EV_PacketID(1113):
			Nt_S_EX_RELICS_ANNOUNCE();
			break;
		case EV_PacketID(1138):
			Nt_S_EX_RELICS_COLLECTION_COMPLETE_ANNOUNCE();
			break;
		case EV_PacketID(1137):
			Nt_S_EX_ALL_RESET_RELICS();
			break;
		default:
			break;
	}
	return;
}

event OnReceivedCloseUI()
{
	if((Me.IsVisibility() == false))
	{
		return;
	}
	if((CheckAndCloseDialog() == false))
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		Me.HideWindow();
	}
	return;
}
