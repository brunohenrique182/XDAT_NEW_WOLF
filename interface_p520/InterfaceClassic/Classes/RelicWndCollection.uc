class RelicWndCollection extends UICommonAPI;

const RELIC_COLLECTION_MAX_ROW = 6;

enum ERelicCollectionCategory
{
	RCC_ALL,                        // 0
	RCC_ATTACK,                     // 1
	RCC_DEFENSE,                    // 2
	RCC_SUPPORT,                    // 3
	RCC_STAT,                       // 4
	RCC_MAX                         // 5
};

struct RelicCollectionCompleteInfo
{
	var int completeListNum;
	var int completeSlotNum;
	var int totalListNum;
	var int totalSlotNum;
	var array<int> completeCollectionIds;
};

var WindowHandle Me;
var WindowHandle searchWnd;
var WindowHandle detailDialogContainer;
var WindowHandle emptyListWnd;
var UIControlTilelist scrollTileList;
var UIControlGroupButtonAssets tabGroupButton;
var array<RelicWndCollectionObject> rendererObjectList;
var UIControlTextInput searchTextInput;
var ButtonHandle completePerBtn;
var ButtonHandle relicPerBtn;
var TextBoxHandle completeCntTextBox;
var TextBoxHandle completeTotalCntTextBox;
var TextBoxHandle relicCntTextBox;
var TextBoxHandle relicTotalCntTextBox;
var StatusRoundHandle completePerGauge;
var StatusRoundHandle relicPerGauge;
var array<RelicWnd.RelicCollectionInfo> _collectionInfos;
var RelicCollectionCompleteInfo _completeInfo;
//var delegate<OnSortByName> __OnSortByName__Delegate;

static function RelicWndCollection Inst()
{
	return RelicWndCollection(GetScript("RelicWndCollection"));
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
	local WindowHandle tabGroupButtonWindow, topWindow, completeInfoWnd, relicInfoWnd;
	local RelicWndCollectionObject slotObject;
	local WindowHandle itemRendererWnd;
	local TextBoxHandle completeTitleTextBox, relicTitleTextBox;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	topWindow = GetWindowHandle((ownerFullPath $ ".RelicWndCollectionTop_Wnd"));
	searchWnd = GetWindowHandle((topWindow.m_WindowNameWithFullPath $ ".ItemFind_Wnd"));
	completeInfoWnd = GetWindowHandle((topWindow.m_WindowNameWithFullPath $ ".ProgressCollectionComplete_wnd"));
	relicInfoWnd = GetWindowHandle((topWindow.m_WindowNameWithFullPath $ ".ProgressRegister_wnd"));
	completePerBtn = GetButtonHandle((completeInfoWnd.m_WindowNameWithFullPath $ ".CollectionRound_btn"));
	completeCntTextBox = GetTextBoxHandle((completeInfoWnd.m_WindowNameWithFullPath $ ".CompletedNum_txt"));
	completeTotalCntTextBox = GetTextBoxHandle((completeInfoWnd.m_WindowNameWithFullPath $ ".TotalNum_txt"));
	relicPerBtn = GetButtonHandle((relicInfoWnd.m_WindowNameWithFullPath $ ".CollectionRound_btn"));
	relicCntTextBox = GetTextBoxHandle((relicInfoWnd.m_WindowNameWithFullPath $ ".CompletedNum_txt"));
	relicTotalCntTextBox = GetTextBoxHandle((relicInfoWnd.m_WindowNameWithFullPath $ ".TotalNum_txt"));
	completeTitleTextBox = GetTextBoxHandle((completeInfoWnd.m_WindowNameWithFullPath $ ".CollectCompleteTitle_txt"));
	relicTitleTextBox = GetTextBoxHandle((relicInfoWnd.m_WindowNameWithFullPath $ ".CollectCompleteTitle_txt"));
	completePerGauge = GetStatusRoundHandle((completeInfoWnd.m_WindowNameWithFullPath $ ".Collection_gauge"));
	relicPerGauge = GetStatusRoundHandle((relicInfoWnd.m_WindowNameWithFullPath $ ".Collection_gauge"));
	tabGroupButtonWindow = GetWindowHandle((ownerFullPath $ ".SubUIControlGroupButtonAsset"));
	tabGroupButton = Class'InterfaceClassic.UIControlGroupButtonAssets'.static._InitScript(tabGroupButtonWindow);
	detailDialogContainer = GetWindowHandle((ownerFullPath $ ".CollectionDisableWnd"));
	tabGroupButton._SetStartInfo("L2UI_ct1.RankingWnd.RankingWnd_SubTabButton", "L2UI_ct1.RankingWnd.RankingWnd_SubTabButton_Down", "L2UI_ct1.RankingWnd.RankingWnd_SubTabButton_Over", true);
	tabGroupButton._GetGroupButtonsInstance().DelegateOnClickButton = OnTabGroupBtnClicked;
	scrollTileList = Class'InterfaceClassic.UIControlTilelist'.static.InitScript(GetWindowHandle((ownerFullPath $ ".CollectionList_Wnd")), 1, 6, true);
	scrollTileList.DelegateOnItemRenderer = OnChangedTileListRenderer;
	emptyListWnd = GetWindowHandle((ownerFullPath $ ".CollectionList_Wnd.FindListEmptyWnd"));
	rendererObjectList.Length = 0;
	i = 0;
	while((i < 6))
	{
		itemRendererWnd = GetWindowHandle(scrollTileList._GetRendererPath(i));
		slotObject = new Class'InterfaceClassic.RelicWndCollectionObject';
		slotObject.Init(itemRendererWnd);
		rendererObjectList[rendererObjectList.Length] = slotObject;
		i++;
	}
	searchTextInput = Class'InterfaceClassic.UIControlTextInput'.static.InitScript(GetWindowHandle((("RelicWnd." $ searchWnd.m_WindowNameWithFullPath) $ ".TextInput")));
	searchTextInput.DelegateOnClear = OnSearchTextInputClear;
	searchTextInput.DelegateOnCompleteEditBox = OnSearchTextInputCompleted;
	searchTextInput.SetDisable(false);
	searchTextInput.SetEdtiable(true);
	searchTextInput.SetDefaultString(GetSystemString(14588));
	completeTitleTextBox.SetText(GetSystemString(14505));
	relicTitleTextBox.SetText(GetSystemString(14506));
	detailDialogContainer.HideWindow();
	tabGroupButton._GetGroupButtonsInstance()._setTopOrder(0, true);
	InitTabGroupButton();
	return;
}

function InitTabGroupButton()
{
	local int i, btnIndex;

	tabGroupButton._GetGroupButtonsInstance()._setShowButtonNum(5);
	tabGroupButton._GetGroupButtonsInstance()._fixedWidth(114, 6);
	i = 0;
	while((i < 5))
	{
		tabGroupButton._GetGroupButtonsInstance()._setButtonText(btnIndex, GetCategoryNameStr(ERelicCollectionCategory(i)));
		tabGroupButton._GetGroupButtonsInstance()._setButtonValue(btnIndex, i);
		btnIndex++;
		i++;
	}
	return;
}

function OnChangedTileListRenderer(string itemRendererID, int rendererIndex, int Position)
{
	local RelicWndCollectionObject rendererObject;

	rendererObject = rendererObjectList[rendererIndex];
	if((Position < _collectionInfos.Length))
	{
		rendererObject.SetInfo(_collectionInfos[Position], searchTextInput.GetString());
	}
	else
	{
		rendererObject.ResetInfo();
	}
	return;
}

function UpdateCollectionList(optional bool needListReset)
{
	local int oldListNum;

	oldListNum = _collectionInfos.Length;
	_collectionInfos = Class'InterfaceClassic.RelicWnd'.static.Inst().GetRelicCollectionInfos();
	UpdateCollectionInfos();
	UpdateCompleteInfoControls();
	if(((needListReset == true) || (oldListNum != _collectionInfos.Length)))
	{
		scrollTileList._SetTileListItemNumTotal(_collectionInfos.Length);
	}
	scrollTileList._Refresh();
	if((_collectionInfos.Length == 0))
	{
		emptyListWnd.ShowWindow();
	}
	else
	{
		emptyListWnd.HideWindow();
	}
	return;
}

function UpdateCollectionInfos()
{
	local array<RelicWnd.RelicCollectionInfo> tmpCollectionInfos;
	local RelicWnd.RelicCollectionInfo tmpCollectionInfo;
	local ERelicCollectionCategory selectedCategory;
	local int i, completeListNum, completeSlotNum, totalListNum, totalSlotNum;
	local string searchStr;
	local array<int> completeCollectionIds;

	searchStr = searchTextInput.GetString();
	selectedCategory = GetSelectedCategory();
	totalListNum = _collectionInfos.Length;
	i = 0;
	while((i < _collectionInfos.Length))
	{
		tmpCollectionInfo = _collectionInfos[i];
		if((tmpCollectionInfo.isComplete == true))
		{
			completeCollectionIds[completeCollectionIds.Length] = tmpCollectionInfo.CollectionID;
			completeListNum++;
		}
		completeSlotNum = (completeSlotNum + tmpCollectionInfo.relicsList.Length);
		totalSlotNum = (totalSlotNum + tmpCollectionInfo.Data.NeedRelics.Length);
		if((int(selectedCategory) != 0))
		{
			if((tmpCollectionInfo.Data.Category != int(selectedCategory)))
			{
				i++;
				continue;
			}
		}
		if(((searchStr != "") && (IsRelicNameMatch(searchStr, tmpCollectionInfo) == false)))
		{
			i++;
			continue;
		}
		tmpCollectionInfos[tmpCollectionInfos.Length] = tmpCollectionInfo;
		i++;
	}
	_collectionInfos = tmpCollectionInfos;
	_completeInfo.completeListNum = completeListNum;
	_completeInfo.completeSlotNum = completeSlotNum;
	_completeInfo.totalListNum = totalListNum;
	_completeInfo.totalSlotNum = totalSlotNum;
	_completeInfo.completeCollectionIds = completeCollectionIds;
	return;
}

function UpdateCollectionCompleteInfo()
{
	local int i, completeListNum, completeSlotNum, totalListNum, totalSlotNum;
	local array<RelicWnd.RelicCollectionInfo> collectionInfos;
	local RelicWnd.RelicCollectionInfo tmpInfo;

	collectionInfos = Class'InterfaceClassic.RelicWnd'.static.Inst().GetRelicCollectionInfos();
	totalListNum = collectionInfos.Length;
	i = 0;
	while((i < collectionInfos.Length))
	{
		tmpInfo = collectionInfos[i];
		if((tmpInfo.isComplete == true))
		{
			completeListNum++;
		}
		completeSlotNum = (completeSlotNum + tmpInfo.relicsList.Length);
		totalSlotNum = (totalSlotNum + tmpInfo.Data.NeedRelics.Length);
		i++;
	}
	return;
}

function UpdateCompleteInfoControls()
{
	completePerBtn.SetNameText((string(int(((float(_completeInfo.completeListNum) / float(_completeInfo.totalListNum)) * 100.0000000))) $ "%"));
	relicPerBtn.SetNameText((string(int(((float(_completeInfo.completeSlotNum) / float(_completeInfo.totalSlotNum)) * 100.0000000))) $ "%"));
	completePerGauge.SetPoint(INT64(_completeInfo.completeListNum), INT64(_completeInfo.totalListNum));
	relicPerGauge.SetPoint(INT64(_completeInfo.completeSlotNum), INT64(_completeInfo.totalSlotNum));
	completeCntTextBox.SetText(string(_completeInfo.completeListNum));
	relicCntTextBox.SetText(string(_completeInfo.completeSlotNum));
	completeTotalCntTextBox.SetText(("/" $ string(_completeInfo.totalListNum)));
	relicTotalCntTextBox.SetText(("/" $ string(_completeInfo.totalSlotNum)));
	return;
}

function SetRelicShortcutState(string relicName)
{
	tabGroupButton._GetGroupButtonsInstance()._setTopOrder(0, false);
	searchTextInput.SetString(relicName);
	return;
}

function bool IsRelicNameMatch(string searchStr, RelicWnd.RelicCollectionInfo CollectionInfo)
{
	local int i;
	local string relicName;
	local RelicsMainUIData relicUIData;
	local L2Util util;

	util = getInstanceL2Util();
	i = 0;
	while((i < CollectionInfo.Data.NeedRelics.Length))
	{
		GetRelicsMainData(CollectionInfo.Data.NeedRelics[i].RelicsID, relicUIData);
		relicName = util.GetDollNameWithGrade(GetItemInfoByClassID(relicUIData.ItemID).Name, ERelicGrade(relicUIData.Grade));
		if(StringMatching(relicName, searchStr, " "))
		{
			return true;
		}
		i++;
	}
	return false;
}

function ShowDetailInfoDialog()
{
	local TextBoxHandle completePerTextBox, relicPerTextBox, completeCntTextBox, relicCntTextBox, completeTotalCntTextBox, relicTotalCntTextBox, completeTitleTextBox, relicTitleTextBox;
	local StatusRoundHandle completePerGauge, relicPerGauge;
	local WindowHandle completeInfoWnd, relicInfoWnd;
	local RichListCtrlHandle statRichList;
	local int i;
	local L2Util util;
	local RichListCtrlRowData rowData;
	local array<RelicsCollectionOption> statOptions;
	local RelicsCollectionOption tmpOption;

	util = L2Util(GetScript("L2Util"));
	completeInfoWnd = GetWindowHandle((detailDialogContainer.m_WindowNameWithFullPath $ ".RelicCollectionDetailWnd.ProgressCollectionComplete_wnd"));
	relicInfoWnd = GetWindowHandle((detailDialogContainer.m_WindowNameWithFullPath $ ".RelicCollectionDetailWnd.ProgressRegister_wnd"));
	statRichList = GetRichListCtrlHandle((detailDialogContainer.m_WindowNameWithFullPath $ ".RelicCollectionDetailWnd.CollectionStat_RichList"));
	statRichList.SetSelectable(false);
	completePerTextBox = GetTextBoxHandle((completeInfoWnd.m_WindowNameWithFullPath $ ".Percentage00_txt"));
	completeCntTextBox = GetTextBoxHandle((completeInfoWnd.m_WindowNameWithFullPath $ ".CompletedNum_txt"));
	completeTotalCntTextBox = GetTextBoxHandle((completeInfoWnd.m_WindowNameWithFullPath $ ".TotalNum_txt"));
	relicPerTextBox = GetTextBoxHandle((relicInfoWnd.m_WindowNameWithFullPath $ ".Percentage00_txt"));
	relicCntTextBox = GetTextBoxHandle((relicInfoWnd.m_WindowNameWithFullPath $ ".CompletedNum_txt"));
	relicTotalCntTextBox = GetTextBoxHandle((relicInfoWnd.m_WindowNameWithFullPath $ ".TotalNum_txt"));
	completeTitleTextBox = GetTextBoxHandle((completeInfoWnd.m_WindowNameWithFullPath $ ".CollectCompleteTitle_txt"));
	relicTitleTextBox = GetTextBoxHandle((relicInfoWnd.m_WindowNameWithFullPath $ ".CollectCompleteTitle_txt"));
	completePerGauge = GetStatusRoundHandle((completeInfoWnd.m_WindowNameWithFullPath $ ".Collection_gauge"));
	relicPerGauge = GetStatusRoundHandle((relicInfoWnd.m_WindowNameWithFullPath $ ".Collection_gauge"));
	completePerTextBox.SetText((string(int(((float(_completeInfo.completeListNum) / float(_completeInfo.totalListNum)) * 100.0000000))) $ "%"));
	relicPerTextBox.SetText((string(int(((float(_completeInfo.completeSlotNum) / float(_completeInfo.totalSlotNum)) * 100.0000000))) $ "%"));
	completePerGauge.SetPoint(INT64(_completeInfo.completeListNum), INT64(_completeInfo.totalListNum));
	relicPerGauge.SetPoint(INT64(_completeInfo.completeSlotNum), INT64(_completeInfo.totalSlotNum));
	completeCntTextBox.SetText(string(_completeInfo.completeListNum));
	relicCntTextBox.SetText(string(_completeInfo.completeSlotNum));
	completeTotalCntTextBox.SetText(("/" $ string(_completeInfo.totalListNum)));
	relicTotalCntTextBox.SetText(("/" $ string(_completeInfo.totalSlotNum)));
	completeTitleTextBox.SetText(GetSystemString(14505));
	relicTitleTextBox.SetText(GetSystemString(14506));
	GetRelicsCollectionCumulativeOptions(_completeInfo.completeCollectionIds, statOptions);
	statRichList.DeleteAllItem();
	// statOptions.Sort(OnSortByName);   // array.Sort() unsupported by this compiler
	rowData.cellDataList.Length = 2;
	i = 0;
	while((i < statOptions.Length))
	{
		tmpOption = statOptions[i];
		rowData.cellDataList[0].drawitems.Length = 0;
		rowData.cellDataList[1].drawitems.Length = 0;
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, Class'InterfaceClassic.RelicWnd'.static.Inst().GetCollectionStatNameStr(tmpOption), util.ColorGold, false, 10);
		AddRichListCtrlString(rowData.cellDataList[1].drawitems, Class'InterfaceClassic.RelicWnd'.static.Inst().GetCollectionStatValueStr(tmpOption), util.White, false, 22);
		statRichList.InsertRecord(rowData);
		i++;
	}
	detailDialogContainer.ShowWindow();
	return;
}

delegate int OnSortByName(RelicsCollectionOption A, RelicsCollectionOption B)
{
	if((A.OptionName > B.OptionName))
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

function HideDetailInfoDialog()
{
	detailDialogContainer.HideWindow();
	return;
}

function bool IsShowDialog()
{
	return detailDialogContainer.IsShowWindow();
}

function string GetCategoryNameStr(ERelicCollectionCategory Category)
{
	switch(Category)
	{
		case RCC_ALL:
			return GetSystemString(13284);
		case RCC_ATTACK:
			return GetSystemString(13477);
		case RCC_DEFENSE:
			return GetSystemString(13478);
		case RCC_SUPPORT:
			return GetSystemString(13479);
		case RCC_STAT:
			return GetSystemString(13480);
		default:
			return "";
	}
}

function ERelicCollectionCategory GetSelectedCategory()
{
	return ERelicCollectionCategory(tabGroupButton._GetGroupButtonsInstance()._getSelectedButtonValue());
}

event OnSearchBtnClicked()
{
	UpdateCollectionList();
	return;
}

event OnSearchTextInputClear()
{
	UpdateCollectionList();
	return;
}

event OnSearchTextInputCompleted(string Text)
{
	UpdateCollectionList();
	return;
}

event OnTabGroupBtnClicked(string parentWndName, string strName, int Index)
{
	UpdateCollectionList();
	return;
}

event OnClickButton(string btnName)
{
	if((btnName == "CollectionRound_btn"))
	{
		ShowDetailInfoDialog();
	}
	else if((btnName == "Close_Btn"))
	{
		HideDetailInfoDialog();
	}
	return;
}

event OnLoad()
{
	Initialize();
	return;
}
