class TeleportWnd extends UICommonAPI
	dependson(UIPacket);

const TELEPORT_FAVORITES_MAX = 50;
const RECOMMEND_TOWN_PRIORITY = 100;

enum ETeleportListType
{
	Normal,                         // 0
	Favorites,                      // 1
	Special,                        // 2
	Searching                       // 3
};

enum ETeleportFavoritesSortType
{
	Latest,                         // 0
	Oldest,                         // 1
	NameAscending,                  // 2
	NameDescending,                 // 3
	LevelAscending,                 // 4
	LevelDescending,                // 5
	Max                             // 6
};




struct TeleportUIStateInfo
{
	var ETeleportFavoritesSortType sortType;
	var ETeleportListType listType;
	var ETeleportListType recentlyListType;
	var string searchStr;
	var bool isRecommendType;
};

var array<TeleportInfo> _teleportTotalList;
var array<TeleportTownInfo> _teleportTownList;
var array<TeleportTownInfo> _teleportRcTownList;
var array<TeleportInfo> _specialTeleportList;
var array<int> _favoritesTeleportIds;
var TeleportUIStateInfo _teleportUIStateInfo;
var int _tempTeleportId;
var int _priceRacio;
var WindowHandle Me;
var WindowHandle searchWnd;
var WindowHandle modalWnd;
var WindowHandle specialTypeContiner;
var WindowHandle normalTypeContainer;
var WindowHandle favoritesTypeContainer;
var WindowHandle searchingTypeContainer;
var WindowHandle listDisableContainer;
var TextBoxHandle listDisableTextBox;
var ButtonHandle searchBtn;
var ButtonHandle favoritesTabBtn;
var ButtonHandle specialTabBtn;
var ButtonHandle teleportBtn;
var ButtonHandle favoritesSortBtn;
var RichListCtrlHandle townRichList;
var RichListCtrlHandle dominionRichList;
var UIControlDialogAssets teleportDialog;
var UIControlTextInput searchTextInput;
var UIControlGroupButtonAssets rcTabGroupButton;
//var delegate<OnSortSearchingList> __OnSortSearchingList__Delegate;
//var delegate<OnSortByNameAscending> __OnSortByNameAscending__Delegate;
//var delegate<OnSortByNameDescending> __OnSortByNameDescending__Delegate;
//var delegate<OnSortByLevelAscending> __OnSortByLevelAscending__Delegate;
//var delegate<OnSortByLevelDescending> __OnSortByLevelDescending__Delegate;

static function TeleportWnd Inst()
{
	return TeleportWnd(GetScript("TeleportWnd"));
}

function Initialize()
{
	InitTelpoListData();
	InitControls();
	return;
}

function InitControls()
{
	local string ownerFullPath;
	local WindowHandle listContainer, tabGroupButtonWindow;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	listContainer = GetWindowHandle((ownerFullPath $ ".Teleport_wnd"));
	searchWnd = GetWindowHandle((listContainer.m_WindowNameWithFullPath $ ".ItemFind_Wnd"));
	modalWnd = GetWindowHandle((ownerFullPath $ ".WindowDisable_Wnd"));
	teleportDialog = Class'InterfaceClassic.UIControlDialogAssets'.static.InitScript(GetWindowHandle((modalWnd.m_WindowNameWithFullPath $ ".UIControlDialogAsset")));
	teleportDialog.SetDisableWindow(modalWnd);
	favoritesTabBtn = GetButtonHandle((listContainer.m_WindowNameWithFullPath $ ".FavoritesView_Btn"));
	specialTabBtn = GetButtonHandle((listContainer.m_WindowNameWithFullPath $ ".SpecialView_Btn"));
	searchBtn = GetButtonHandle((listContainer.m_WindowNameWithFullPath $ ".BtnFind"));
	teleportBtn = GetButtonHandle((listContainer.m_WindowNameWithFullPath $ ".Teleport_Btn"));
	favoritesSortBtn = GetButtonHandle((listContainer.m_WindowNameWithFullPath $ ".FavoritesViewBG_GroupBoxWnd.FavoritesSort_btn"));
	townRichList = GetRichListCtrlHandle((listContainer.m_WindowNameWithFullPath $ ".TownZone_ListCtrl"));
	dominionRichList = GetRichListCtrlHandle((listContainer.m_WindowNameWithFullPath $ ".HuntingZone_ListCtrl"));
	townRichList.SetTooltipType("TeleportWndListTooltip");
	dominionRichList.SetTooltipType("TeleportWndListTooltip");
	townRichList.SetSelectedSelTooltip(false);
	townRichList.SetAppearTooltipAtMouseX(true);
	dominionRichList.SetSelectedSelTooltip(false);
	dominionRichList.SetAppearTooltipAtMouseX(true);
	dominionRichList.SetUseStripeBackTexture(false);
	listDisableContainer = GetWindowHandle((listContainer.m_WindowNameWithFullPath $ ".FindDisable_Wnd"));
	listDisableTextBox = GetTextBoxHandle((listDisableContainer.m_WindowNameWithFullPath $ ".Disable_Text"));
	specialTypeContiner = GetWindowHandle((listContainer.m_WindowNameWithFullPath $ ".SpecialViewBG_GroupBoxWnd"));
	normalTypeContainer = GetWindowHandle((listContainer.m_WindowNameWithFullPath $ ".HuntingViewBG_GroupBoxWnd"));
	favoritesTypeContainer = GetWindowHandle((listContainer.m_WindowNameWithFullPath $ ".FavoritesViewBG_GroupBoxWnd"));
	searchingTypeContainer = GetWindowHandle((listContainer.m_WindowNameWithFullPath $ ".FindViewBG_GroupBoxWnd"));
	searchTextInput = Class'InterfaceClassic.UIControlTextInput'.static.InitScript(GetWindowHandle((searchWnd.m_WindowNameWithFullPath $ ".TextInput")));
	searchTextInput.DelegateOnClear = OnSearchTextInputClear;
	searchTextInput.DelegateOnCompleteEditBox = OnSearchTextInputCompleted;
	searchTextInput.SetDisable(false);
	searchTextInput.SetEdtiable(true);
	searchTextInput.SetDefaultString(GetSystemString(2507));
	tabGroupButtonWindow = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".TabButtonAsset"));
	rcTabGroupButton = Class'InterfaceClassic.UIControlGroupButtonAssets'.static._InitScript(tabGroupButtonWindow);
	rcTabGroupButton._SetStartInfo("L2UI_NewTex.WindowTab.Tab_Opacity_Unselected", "L2UI_NewTex.WindowTab.Tab_Opacity_Selected", "L2UI_NewTex.WindowTab.Tab_Opacity_Unselected_Over", true);
	rcTabGroupButton._GetGroupButtonsInstance().DelegateOnClickButton = OnTabGroupBtnClicked;
	rcTabGroupButton._GetGroupButtonsInstance()._setShowButtonNum(2);
	rcTabGroupButton._GetGroupButtonsInstance()._fixedWidth(160, 0);
	rcTabGroupButton._GetGroupButtonsInstance()._setButtonText(0, GetSystemString(1312));
	rcTabGroupButton._GetGroupButtonsInstance()._setButtonValue(0, 0);
	rcTabGroupButton._GetGroupButtonsInstance()._setButtonText(1, GetSystemString(3544));
	rcTabGroupButton._GetGroupButtonsInstance()._setTopOrder(0, true);
	_teleportUIStateInfo.isRecommendType = false;
	townRichList.SetEnableInteractionPass(false);
	dominionRichList.SetEnableInteractionPass(false);
	return;
}

function InitTelpoListData()
{
	local TeleportTownInfo tempTownInfo;
	local TeleportInfo tempTownTelInfo, tempDominionTelInfo;
	local TeleportListAPI.TeleportListData TeleportInfo;
	local int i, j, teleportListNum;

	_teleportTownList.Length = 0;
	_teleportRcTownList.Length = 0;
	teleportListNum = Class'NWindow.TeleportListAPI'.static.GetTeleportListDataCount();
	i = 0;
	while((i < teleportListNum))
	{
		TeleportInfo = Class'NWindow.TeleportListAPI'.static.GetTeleportListDataByIndex(i);
		if((TeleportInfo.Priority >= 0))
		{
			_teleportTotalList[_teleportTotalList.Length] = MakeTeleportInfo(TeleportInfo);
		}
		i++;
	}
	i = 0;
	while((i < _teleportTotalList.Length))
	{
		tempTownTelInfo = _teleportTotalList[i];
		if((tempTownTelInfo.isTown == true))
		{
			tempTownInfo.townInfo = tempTownTelInfo;
			tempTownInfo.dominions.Length = 0;
			j = 0;
			while((j < _teleportTotalList.Length))
			{
				tempDominionTelInfo = _teleportTotalList[j];
				if((tempDominionTelInfo.isTown == false))
				{
					if((((tempTownTelInfo.RcZoneID > 0) && (tempDominionTelInfo.RcZoneID == tempTownTelInfo.RcZoneID)) || ((tempTownTelInfo.TownID > 0) && (tempDominionTelInfo.TownID == tempTownTelInfo.TownID))))
					{
						tempTownInfo.dominions[tempTownInfo.dominions.Length] = tempDominionTelInfo;
					}
				}
				j++;
			}
			if(tempTownTelInfo.isRcTown)
			{
				_teleportRcTownList[_teleportRcTownList.Length] = tempTownInfo;
				i++;
				continue;
			}
			_teleportTownList[_teleportTownList.Length] = tempTownInfo;
		}
		i++;
	}
	i = 0;
	while((i < _teleportRcTownList.Length))
	{
		tempTownInfo = _teleportRcTownList[i];
		// tempTownInfo.dominions.Sort(OnSortByLevelDescending);   // array.Sort() unsupported by this compiler
		_teleportRcTownList[i] = tempTownInfo;
		i++;
	}
	return;
}

function UpdateTeleportTagInfos()
{
	UpdateTeleportTagInfo(_teleportTownList);
	UpdateTeleportTagInfo(_teleportRcTownList);
	return;
}

function UpdateTeleportTagInfo(out array<TeleportTownInfo> townList)
{
	local int i, j;
	local ETeleportListTagType tempTagType, townTagType;
	local TeleportTownInfo tempTownInfo;
	local TeleportInfo dominionInfo;
	local int localTimeSec;

	localTimeSec = Class'InterfaceClassic.UIData'.static.Inst().GetCurrentRealLocalTimeSec();
	i = 0;
	while((i < townList.Length))
	{
		tempTownInfo = townList[i];
		townTagType = TLTT_DEFAULT;
		j = 0;
		while((j < tempTownInfo.dominions.Length))
		{
			dominionInfo = tempTownInfo.dominions[j];
			tempTagType = GetValidTeleportTag(dominionInfo, localTimeSec);
			dominionInfo.showTagType = tempTagType;
			tempTownInfo.dominions[j] = dominionInfo;
			if((int(tempTagType) > int(townTagType)))
			{
				townTagType = tempTagType;
			}
			j++;
		}
		tempTagType = GetValidTeleportTag(tempTownInfo.townInfo, localTimeSec);
		if((int(tempTagType) == 0))
		{
			tempTagType = townTagType;
		}
		else if((int(tempTagType) < int(townTagType)))
		{
			tempTagType = townTagType;
		}
		tempTownInfo.townInfo.showTagType = tempTagType;
		townList[i] = tempTownInfo;
		i++;
	}
	return;
}

function ETeleportListTagType GetValidTeleportTag(TeleportInfo Info, int localTimeSec)
{
	if(((Info.TagStartTime <= localTimeSec) && (Info.TagEndTime >= localTimeSec)))
	{
		return Info.tagType;
	}
	return TLTT_DEFAULT;
}

function UpdateSpecialTeleportList()
{
	local int i, classTransferDegree;
	local TeleportInfo tempTeleportInfo;
	local UserInfo UserInfo;

	_specialTeleportList.Length = 0;
	if((GetPlayerInfo(UserInfo) == false))
	{
		return;
	}
	classTransferDegree = GetClassTransferDegree(UserInfo.nClassID);
	searchTextInput.inputTextBox.ClearAdditionalSearchList(SLT_ADDITIONAL_LIST);
	i = 0;
	while((i < _teleportTotalList.Length))
	{
		tempTeleportInfo = _teleportTotalList[i];
		if(tempTeleportInfo.isRcTown)
		{
			i++;
			continue;
		}
		if(tempTeleportInfo.isSpecial)
		{
			if(((classTransferDegree >= tempTeleportInfo.UsableTransferDegree) && (UserInfo.nLevel >= tempTeleportInfo.UsableLevel)))
			{
				_specialTeleportList[_specialTeleportList.Length] = tempTeleportInfo;
				searchTextInput.inputTextBox.AddNameToAdditionalSearchList(tempTeleportInfo.Name, SLT_ADDITIONAL_LIST);
			}
			i++;
			continue;
		}
		searchTextInput.inputTextBox.AddNameToAdditionalSearchList(tempTeleportInfo.Name, SLT_ADDITIONAL_LIST);
		i++;
	}
	if((_specialTeleportList.Length > 0))
	{
		specialTabBtn.ShowWindow();
		townRichList.AdjustShowRow(12);
		townRichList.SetContentsHeight(31);
		townRichList.SetWindowSize(202, 372);
	}
	else
	{
		specialTabBtn.HideWindow();
		townRichList.AdjustShowRow(13);
		townRichList.SetContentsHeight(32);
		townRichList.SetWindowSize(202, 412);
	}
	return;
}

function UpdateFavoritesButtonLabel()
{
	local string favoritesStr, countStr;

	favoritesStr = GetSystemString(379);
	countStr = (((("(" $ string(_favoritesTeleportIds.Length)) $ "/") $ string(50)) $ ")");
	favoritesTabBtn.SetNameText((favoritesStr @ countStr));
	return;
}

function TeleportInfo MakeTeleportInfo(TeleportListAPI.TeleportListData teleportData)
{
	local TeleportInfo Result;

	Result.Name = teleportData.Name;
	Result.Id = teleportData.Id;
	Result.TownID = teleportData.TownID;
	Result.RcZoneID = teleportData.RcZoneID;
	Result.DominionID = teleportData.DominionID;
	Result.locX = teleportData.locX;
	Result.locY = teleportData.locY;
	Result.Level = teleportData.Level;
	Result.Price = teleportData.Price;
	Result.UsableLevel = teleportData.UsableLevel;
	Result.UsableTransferDegree = teleportData.UsableTransferDegree;
	Result.tagType = ETeleportListTagType(teleportData.Tag);
	Result.TagStartTime = teleportData.TagStartTime;
	Result.TagEndTime = teleportData.TagEndTime;
	if((((teleportData.Priority == 1) || (teleportData.Priority == 2)) || (teleportData.Priority == 100)))
	{
		Result.isTown = true;
	}
	else
	{
		Result.isTown = false;
	}
	if((teleportData.Priority == 100))
	{
		Result.TownID = 0;
		Result.isRcTown = true;
	}
	else
	{
		Result.isRcTown = false;
	}
	if(((teleportData.UsableTransferDegree != 0) || (teleportData.UsableLevel != 0)))
	{
		Result.isSpecial = true;
	}
	else
	{
		Result.isSpecial = false;
	}
	if((teleportData.ServerRange == 1))
	{
		Result.isWorldServer = true;
	}
	else
	{
		Result.isWorldServer = false;
	}
	return Result;
}

function INT64 GetTeleportCost(INT64 cost, int UsableLevel, int UsableTransferDegree)
{
	local INT64 teleportCost;
	local bool isSpecialTeleport, isFreeLevel;

	isFreeLevel = Class'InterfaceClassic.UIData'.static.Inst().IsTeleportFreeLevel();
	if((_priceRacio > 0))
	{
		teleportCost = ((cost * INT64((100 - _priceRacio))) / INT64(100));
	}
	else
	{
		teleportCost = cost;
	}
	isSpecialTeleport = ((UsableLevel > 0) || (UsableTransferDegree > 0));
	if((int(GetLanguage()) == 0))
	{
		if(((isSpecialTeleport == false) && (isFreeLevel == true)))
		{
			teleportCost = INT64(0);
		}
	}
	else if((isFreeLevel == true))
	{
		teleportCost = INT64(0);
	}
	return teleportCost;
}

function int GetTeleportFavoritesListIndex(int TeleportID)
{
	local int i, favoritesId;

	i = 0;
	while((i < _favoritesTeleportIds.Length))
	{
		favoritesId = _favoritesTeleportIds[i];
		if((favoritesId == TeleportID))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function bool IsTeleportFavorites(int TeleportID)
{
	if((GetTeleportFavoritesListIndex(TeleportID) >= 0))
	{
		return true;
	}
	return false;
}

function AddTeleportFavorites(int TeleportID)
{
	if((IsTeleportFavorites(TeleportID) == false))
	{
		_favoritesTeleportIds[_favoritesTeleportIds.Length] = TeleportID;
	}
	return;
}

function RemoveTeleportFavorites(int TeleportID)
{
	local int Index;

	Index = GetTeleportFavoritesListIndex(TeleportID);
	if((Index >= 0))
	{
		_favoritesTeleportIds.Remove(Index, 1);
	}
	return;
}

function UpdateTownListControls()
{
	local TeleportInfo tempTeleportInfo;
	local array<TeleportTownInfo> validTownList;
	local RichListCtrlRowData rowData;
	local Color NameColor;
	local L2Util util;
	local int i, recordCnt, deleteIndex;
	local bool isFavorites;

	rowData.cellDataList.Length = 3;
	recordCnt = townRichList.GetRecordCount();
	util = L2Util(GetScript("L2Util"));
	NameColor = util.ColorGold;
	deleteIndex = 0;
	if((_teleportUIStateInfo.isRecommendType == true))
	{
		townRichList.SetColumnWidth(1, 178);
		townRichList.SetColumnWidth(2, 0);
		validTownList = _teleportRcTownList;
	}
	else
	{
		townRichList.SetColumnWidth(1, 145);
		townRichList.SetColumnWidth(2, 33);
		validTownList = _teleportTownList;
	}
	i = 0;
	while((i < Max(validTownList.Length, recordCnt)))
	{
		if((i < validTownList.Length))
		{
			tempTeleportInfo = validTownList[i].townInfo;
			rowData.cellDataList[0].drawitems.Length = 0;
			rowData.cellDataList[1].drawitems.Length = 0;
			rowData.cellDataList[2].drawitems.Length = 0;
			rowData.nReserved1 = INT64(tempTeleportInfo.Id);
			rowData.nReserved2 = INT64(tempTeleportInfo.TownID);
			isFavorites = IsTeleportFavorites(tempTeleportInfo.Id);
			rowData.nReserved3 = INT64(int(isFavorites));
			rowData.szReserved = string(tempTeleportInfo.RcZoneID);
			addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_CT1.HtmlWnd.BTN_Icon_Teleport", 12, 12, 4);
			if((int(tempTeleportInfo.showTagType) != 0))
			{
				addRichListCtrlTexture(rowData.cellDataList[1].drawitems, GetTagSmallTexture(tempTeleportInfo.showTagType), 15, 14, 0);
				AddRichListCtrlString(rowData.cellDataList[1].drawitems, tempTeleportInfo.Name, NameColor, false, 4);
			}
			else
			{
				AddRichListCtrlString(rowData.cellDataList[1].drawitems, tempTeleportInfo.Name, NameColor, false);
			}
			if((tempTeleportInfo.isRcTown == false))
			{
				if(isFavorites)
				{
					AddRichListCtrlButton(rowData.cellDataList[2].drawitems, ("listFavoritesBtn_" @ string(tempTeleportInfo.Id)), 0, 0, "L2UI_NewTex.TeleportWnd.TeleportMap_FavoriteBtn_On", "L2UI_NewTex.TeleportWnd.TeleportMap_FavoriteBtn_On", "L2UI_NewTex.TeleportWnd.TeleportMap_FavoriteBtn_On", 19, 18, 19, 18, int(isFavorites));
				}
				else
				{
					AddRichListCtrlButton(rowData.cellDataList[2].drawitems, ("listFavoritesBtn_" @ string(tempTeleportInfo.Id)), 0, 0, "L2UI_NewTex.TeleportWnd.TeleportMap_FavoriteBtn_Off", "L2UI_NewTex.TeleportWnd.TeleportMap_FavoriteBtn_Off", "L2UI_NewTex.TeleportWnd.TeleportMap_FavoriteBtn_Off", 19, 18, 19, 18, int(isFavorites));
				}
			}
			if((i < recordCnt))
			{
				townRichList.ModifyRecord(i, rowData);
			}
			else
			{
				townRichList.InsertRecord(rowData);
			}
			i++;
			continue;
		}
		townRichList.DeleteRecord(((recordCnt - deleteIndex) - 1));
		deleteIndex++;
		i++;
	}
	return;
}

function UpdateDominionListControls()
{
	local int selectedTownIndex, TownID, RcZoneID, i;
	local array<TeleportInfo> dominionList;
	local array<TeleportTownInfo> validTownList;
	local RichListCtrlRowData selectedData, rowData;
	local TeleportInfo tempTeleportInfo;
	local int recordCnt, deleteIndex, iconOffsetY, costStrWidth, costStrHeight;
	local L2Util util;
	local string zoneIconPath, costIconPath, levelStr, costStr;
	local Color NameColor;
	local bool isFavorites;

	selectedTownIndex = townRichList.GetSelectedIndex();
	util = L2Util(GetScript("L2Util"));
	if((int(_teleportUIStateInfo.listType) == 0))
	{
		listDisableTextBox.SetText(GetSystemString(14186));
		if((selectedTownIndex >= 0))
		{
			townRichList.GetSelectedRec(selectedData);
			TownID = int(selectedData.nReserved2);
			RcZoneID = int(selectedData.szReserved);
			if((RcZoneID > 0))
			{
				validTownList = _teleportRcTownList;
			}
			else
			{
				validTownList = _teleportTownList;
			}
			i = 0;
			while((i < validTownList.Length))
			{
				if((RcZoneID > 0))
				{
					if((validTownList[i].townInfo.RcZoneID == RcZoneID))
					{
						dominionList = validTownList[i].dominions;
						break;
					}
					i++;
					continue;
				}
				if((validTownList[i].townInfo.TownID == TownID))
				{
					dominionList = validTownList[i].dominions;
					break;
				}
				i++;
			}
		}
	}
	else if((int(_teleportUIStateInfo.listType) == 2))
	{
		dominionList = _specialTeleportList;
	}
	else if((int(_teleportUIStateInfo.listType) == 1))
	{
		listDisableTextBox.SetText(GetSystemString(14185));
		dominionList = GetTeleportFavoritesList(_teleportUIStateInfo.sortType);
	}
	else if((int(_teleportUIStateInfo.listType) == 3))
	{
		listDisableTextBox.SetText(GetSystemString(14184));
		dominionList = GetTeleportSearchingList(_teleportUIStateInfo.searchStr);
	}
	rowData.cellDataList.Length = 3;
	recordCnt = dominionRichList.GetRecordCount();
	deleteIndex = 0;
	i = 0;
	while((i < Max(dominionList.Length, recordCnt)))
	{
		if((i < dominionList.Length))
		{
			tempTeleportInfo = dominionList[i];
			rowData.cellDataList[0].drawitems.Length = 0;
			rowData.cellDataList[1].drawitems.Length = 0;
			rowData.cellDataList[2].drawitems.Length = 0;
			rowData.nReserved1 = INT64(tempTeleportInfo.Id);
			rowData.nReserved2 = INT64(tempTeleportInfo.DominionID);
			isFavorites = IsTeleportFavorites(tempTeleportInfo.Id);
			rowData.nReserved3 = INT64(int(isFavorites));
			rowData.szReserved = string(tempTeleportInfo.RcZoneID);
			NameColor = util.White;
			iconOffsetY = -14;
			if(tempTeleportInfo.isSpecial)
			{
				zoneIconPath = "L2UI_NewTex.TeleportWnd.TeleporMap_LVHuntingIcon_Normal";
				NameColor = util.VIOLET01;
			}
			else if(tempTeleportInfo.isWorldServer)
			{
				zoneIconPath = "L2UI_NewTex.TeleportWnd.Teleport_World";
			}
			else if(tempTeleportInfo.isTown)
			{
				zoneIconPath = "L2UI_CT1.HtmlWnd.BTN_Icon_Teleport";
				iconOffsetY = -17;
			}
			else
			{
				zoneIconPath = "L2UI_NewTex.TeleportWnd.TeleporMap_HuntingIcon_Normal";
			}
			if((tempTeleportInfo.Price[0].Id == 57))
			{
				costIconPath = "L2UI_CT1.Icon.Icon_DF_Common_Adena";
			}
			else
			{
				costIconPath = "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Icon_Lcoin";
			}
			if((tempTeleportInfo.Level > 0))
			{
				levelStr = ("Lv" @ string(tempTeleportInfo.Level));
			}
			else
			{
				levelStr = "";
			}
			costStr = MakeCostStringINT64(GetTeleportCost(tempTeleportInfo.Price[0].Amount, tempTeleportInfo.UsableLevel, tempTeleportInfo.UsableTransferDegree));
			GetTextSizeDefault(costStr, costStrWidth, costStrHeight);
			addRichListCtrlTexture(rowData.cellDataList[0].drawitems, zoneIconPath, 12, 12, 2, iconOffsetY);
			if((int(tempTeleportInfo.showTagType) != 0))
			{
				addRichListCtrlTexture(rowData.cellDataList[1].drawitems, GetTagSmallTexture(tempTeleportInfo.showTagType), 15, 14, 0, 4);
				AddRichListCtrlString(rowData.cellDataList[1].drawitems, tempTeleportInfo.Name, NameColor, false, 4, 0);
			}
			else
			{
				AddRichListCtrlString(rowData.cellDataList[1].drawitems, tempTeleportInfo.Name, NameColor, false, 0, 4);
			}
			AddRichListCtrlString(rowData.cellDataList[1].drawitems, "", util.White, true);
			addRichListCtrlTexture(rowData.cellDataList[1].drawitems, costIconPath, 20, 15, 222, 6);
			AddRichListCtrlString(rowData.cellDataList[1].drawitems, costStr, util.ColorGold, true, (218 - costStrWidth), -15);
			AddRichListCtrlString(rowData.cellDataList[1].drawitems, levelStr, util.ColorGold, true, 6, -14);
			if(isFavorites)
			{
				AddRichListCtrlButton(rowData.cellDataList[2].drawitems, ("listFavoritesBtn_" @ string(tempTeleportInfo.Id)), 0, 0, "L2UI_NewTex.TeleportWnd.TeleportMap_FavoriteBtn_On", "L2UI_NewTex.TeleportWnd.TeleportMap_FavoriteBtn_On", "L2UI_NewTex.TeleportWnd.TeleportMap_FavoriteBtn_On", 19, 18, 19, 18, int(isFavorites));
			}
			else
			{
				AddRichListCtrlButton(rowData.cellDataList[2].drawitems, ("listFavoritesBtn_" @ string(tempTeleportInfo.Id)), 0, 0, "L2UI_NewTex.TeleportWnd.TeleportMap_FavoriteBtn_Off", "L2UI_NewTex.TeleportWnd.TeleportMap_FavoriteBtn_Off", "L2UI_NewTex.TeleportWnd.TeleportMap_FavoriteBtn_Off", 19, 18, 19, 18, int(isFavorites));
			}
			if((i < recordCnt))
			{
				dominionRichList.ModifyRecord(i, rowData);
			}
			else
			{
				dominionRichList.InsertRecord(rowData);
			}
			i++;
			continue;
		}
		dominionRichList.DeleteRecord(((recordCnt - deleteIndex) - 1));
		deleteIndex++;
		i++;
	}
	if((dominionList.Length == 0))
	{
		listDisableContainer.ShowWindow();
	}
	else
	{
		listDisableContainer.HideWindow();
	}
	return;
}

function SetCurrentZoneListSelected(optional bool setNormaTab)
{
	local int townListIndex, dominionListIndex;
	local string teleportName;

	teleportName = GetCurrentZoneName();
	GetListIndexByZoneName(teleportName, townListIndex, dominionListIndex, _teleportUIStateInfo.isRecommendType);
	if(((setNormaTab == true) || ((int(_teleportUIStateInfo.listType) == 2) && (_specialTeleportList.Length == 0))))
	{
		SetListUIState(Normal);
	}
	townRichList.SetSelectedIndex(Max(townListIndex, 0), true);
	UpdateDominionListControls();
	if((int(_teleportUIStateInfo.listType) == 0))
	{
		dominionRichList.SetSelectedIndex(dominionListIndex, true);
	}
	UpdateMapTownZoneIcons();
	UpdateMapDominionZoneIcons();
	return;
}

function ScrollToTopDominionList()
{
	dominionRichList.SetSelectedIndex(0, true);
	dominionRichList.SetSelectedIndex(-1, false);
	return;
}

function ScrollToTopTownList()
{
	townRichList.SetSelectedIndex(0, true);
	townRichList.SetSelectedIndex(-1, false);
	return;
}

function UpdateListControls()
{
	UpdateFavoritesButtonLabel();
	UpdateTownListControls();
	UpdateDominionListControls();
	return;
}

function UpdateUIContols()
{
	UpdateListControls();
	UpdateMapTownZoneIcons();
	UpdateMapDominionZoneIcons();
	return;
}

function UpdateMapTownZoneIcons()
{
	Class'InterfaceClassic.TeleportWndMap'.static.Inst().UpdateTownZoneIcons(_teleportUIStateInfo.isRecommendType);
	return;
}

function UpdateMapDominionZoneIcons()
{
	Class'InterfaceClassic.TeleportWndMap'.static.Inst().UpdateDominionZoneIcons();
	return;
}

function UnselectTownList()
{
	townRichList.SetSelectedIndex(-1, false);
	return;
}

function UnselectDominionList()
{
	dominionRichList.SetSelectedIndex(-1, false);
	return;
}

delegate int OnSortSearchingList(TeleportInfo A, TeleportInfo B)
{
	if((A.isTown != B.isTown))
	{
		if(((A.isTown == true) && (B.isTown == false)))
		{
			return 0;
		}
		else
		{
			return -1;
		}
	}
	if((A.isSpecial != B.isSpecial))
	{
		if(((A.isSpecial == false) && (B.isSpecial == true)))
		{
			return 0;
		}
		else
		{
			return -1;
		}
	}
	if((A.Name > B.Name))
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

delegate int OnSortByNameAscending(TeleportInfo A, TeleportInfo B)
{
	if((A.Name > B.Name))
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

delegate int OnSortByNameDescending(TeleportInfo A, TeleportInfo B)
{
	if((A.Name < B.Name))
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

delegate int OnSortByLevelAscending(TeleportInfo A, TeleportInfo B)
{
	if((A.Level != B.Level))
	{
		if((A.Level > B.Level))
		{
			return 0;
		}
		else
		{
			return -1;
		}
	}
	if((A.Name > B.Name))
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

delegate int OnSortByLevelDescending(TeleportInfo A, TeleportInfo B)
{
	if((A.Level != B.Level))
	{
		if((A.Level < B.Level))
		{
			return 0;
		}
		else
		{
			return -1;
		}
	}
	if((A.Name > B.Name))
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

function array<TeleportInfo> GetTeleportFavoritesList(ETeleportFavoritesSortType sortType)
{
	local int i;
	local array<TeleportInfo> favoritesList;

	if((int(sortType) == 0))
	{
		i = (_favoritesTeleportIds.Length - 1);
		while((i >= 0))
		{
			favoritesList[favoritesList.Length] = GetTeleportInfo(_favoritesTeleportIds[i], true);
			i--;
		}
		return favoritesList;
	}
	else
	{
		i = 0;
		while((i < _favoritesTeleportIds.Length))
		{
			favoritesList[favoritesList.Length] = GetTeleportInfo(_favoritesTeleportIds[i], true);
			i++;
		}
		if((int(sortType) == 1))
		{
			return favoritesList;
		}
	}
	if((int(sortType) == 2))
	{
		// favoritesList.Sort(OnSortByNameAscending);   // array.Sort() unsupported by this compiler
	}
	else if((int(sortType) == 3))
	{
		// favoritesList.Sort(OnSortByNameDescending);   // array.Sort() unsupported by this compiler
	}
	else if((int(sortType) == 4))
	{
		// favoritesList.Sort(OnSortByLevelAscending);   // array.Sort() unsupported by this compiler
	}
	else if((int(sortType) == 5))
	{
		// favoritesList.Sort(OnSortByLevelDescending);   // array.Sort() unsupported by this compiler
	}
	return favoritesList;
}

function array<TeleportInfo> GetTeleportSearchingList(string searchStr)
{
	local int i;
	local array<TeleportInfo> searchingList;
	local TeleportInfo tempTeleportInfo;
	local bool isShowSpecialTeleport;

	if((_specialTeleportList.Length > 0))
	{
		isShowSpecialTeleport = true;
	}
	i = 0;
	while((i < _teleportTotalList.Length))
	{
		tempTeleportInfo = _teleportTotalList[i];
		if(((isShowSpecialTeleport == false) && tempTeleportInfo.isSpecial))
		{
			i++;
			continue;
		}
		if(tempTeleportInfo.isRcTown)
		{
			i++;
			continue;
		}
		if(StringMatching(tempTeleportInfo.Name, searchStr, " "))
		{
			searchingList[searchingList.Length] = tempTeleportInfo;
		}
		i++;
	}
	// searchingList.Sort(OnSortSearchingList);   // array.Sort() unsupported by this compiler
	return searchingList;
}

function array<TeleportTownInfo> GetTeleportTownList()
{
	return _teleportTownList;
}

function TeleportInfo GetTeleportInfo(int TeleportID, optional bool withTagInfo)
{
	local int i;
	local TeleportInfo Info;

	i = 0;
	while((i < _teleportTotalList.Length))
	{
		Info = _teleportTotalList[i];
		if((Info.Id == TeleportID))
		{
			if(withTagInfo)
			{
				Info.showTagType = GetValidTeleportTag(Info, Class'InterfaceClassic.UIData'.static.Inst().GetCurrentRealLocalTimeSec());
			}
			return Info;
		}
		i++;
	}
	return Info;
}

function TeleportTownInfo GetTownInfo(int TownID)
{
	local int i;
	local TeleportTownInfo Info;

	i = 0;
	while((i < _teleportTownList.Length))
	{
		Info = _teleportTownList[i];
		if((Info.townInfo.TownID == TownID))
		{
			return Info;
		}
		i++;
	}
	return Info;
}

function TeleportTownInfo GetRcTownInfo(int RcZoneID)
{
	local int i;
	local TeleportTownInfo Info;

	i = 0;
	while((i < _teleportRcTownList.Length))
	{
		Info = _teleportRcTownList[i];
		if((Info.townInfo.RcZoneID == RcZoneID))
		{
			return Info;
		}
		i++;
	}
	return Info;
}

function int GetSelectedTownID()
{
	local RichListCtrlRowData selectedData;

	if((townRichList.GetSelectedIndex() >= 0))
	{
		townRichList.GetSelectedRec(selectedData);
		return int(selectedData.nReserved2);
	}
	return -1;
}

function int GetSelectedRcZoneID()
{
	local RichListCtrlRowData selectedData;

	if((townRichList.GetSelectedIndex() >= 0))
	{
		townRichList.GetSelectedRec(selectedData);
		return int(selectedData.szReserved);
	}
	return -1;
}

function int GetSelectedDominionTeleportID()
{
	local RichListCtrlRowData selectedData;

	if((dominionRichList.GetSelectedIndex() >= 0))
	{
		dominionRichList.GetSelectedRec(selectedData);
		return int(selectedData.nReserved1);
	}
	return -1;
}

function bool GetListIndexByZoneName(string teleportName, out int outTownIndex, out int outDominionIndex, optional bool isRecommendShow)
{
	local int townIndex, dominionIndex;
	local array<TeleportTownInfo> validTownList;
	local TeleportTownInfo townInfo;

	if(isRecommendShow)
	{
		validTownList = _teleportRcTownList;
	}
	else
	{
		validTownList = _teleportTownList;
	}
	townIndex = 0;
	while((townIndex < validTownList.Length))
	{
		townInfo = validTownList[townIndex];
		if((townInfo.townInfo.Name == teleportName))
		{
			outTownIndex = townIndex;
			outDominionIndex = -1;
			return true;
			townIndex++;
			continue;
		}
		dominionIndex = 0;
		while((dominionIndex < townInfo.dominions.Length))
		{
			if((townInfo.dominions[dominionIndex].Name == teleportName))
			{
				outTownIndex = townIndex;
				outDominionIndex = dominionIndex;
				return true;
			}
			dominionIndex++;
		}
		townIndex++;
	}
	outTownIndex = -1;
	outDominionIndex = -1;
	return false;
}

function int GetSelectedTeleportID()
{
	local RichListCtrlRowData selectedData;
	local int SelectedIndex;

	SelectedIndex = dominionRichList.GetSelectedIndex();
	if(((SelectedIndex >= 0) && (SelectedIndex < dominionRichList.GetRecordCount())))
	{
		dominionRichList.GetSelectedRec(selectedData);
		return int(selectedData.nReserved1);
	}
	else if((townRichList.GetSelectedIndex() >= 0))
	{
		townRichList.GetSelectedRec(selectedData);
		if((selectedData.nReserved2 == INT64(0)))
		{
			return -1;
		}
		return int(selectedData.nReserved1);
	}
	return -1;
}

function string GetTagSmallTexture(ETeleportListTagType tagType)
{
	if((int(tagType) == 1))
	{
		return "L2UI_NewTex.TeleportWnd.MapTag_miniNew";
	}
	else if((int(tagType) == 2))
	{
		return "L2UI_NewTex.TeleportWnd.MapTag_miniEvent";
	}
	return "";
}

function ShowTeleportDialog(INT64 TeleportID)
{
	local string Desc, teleportName;
	local TeleportInfo targetTeleport;
	local INT64 teleportCost;

	_tempTeleportId = int(TeleportID);
	targetTeleport = GetTeleportInfo(_tempTeleportId);
	if((targetTeleport.Id == 0))
	{
		Debug("ShowTeleportDialog() invalid teleportId");
		return;
	}
	if((targetTeleport.Level > 0))
	{
		teleportName = (((("(" $ targetTeleport.Name) $ " Lv ") $ string(targetTeleport.Level)) $ ")");
	}
	else
	{
		teleportName = (("(" $ targetTeleport.Name) $ ")");
	}
	Desc = ((GetSystemMessage(5239) $ "\\n\\n") $ teleportName);
	teleportDialog.SetDialogDesc(Desc, , , , 34);
	teleportDialog.SetUseNeedItem(true);
	teleportDialog.StartNeedItemList(1);
	teleportCost = GetTeleportCost(targetTeleport.Price[0].Amount, targetTeleport.UsableLevel, targetTeleport.UsableTransferDegree);
	if((targetTeleport.Price.Length > 0))
	{
		teleportDialog.AddNeedItemClassID(targetTeleport.Price[0].Id, teleportCost);
	}
	teleportDialog.SetItemNum(1);
	teleportDialog.Show();
	teleportDialog.DelegateOnClickBuy = OnTeleportDialogConfirm;
	teleportDialog.DelegateOnCancel = OnTeleportDialogCancel;
	return;
}

function SetTownRichListScroll(bool bIncrease)
{
	if(bIncrease)
	{
		townRichList.IncreaseStartRow(1);
	}
	else
	{
		townRichList.DecreaseStartRow(1);
	}
	return;
}

function SetDominionRichListScroll(bool bIncrease)
{
	if(bIncrease)
	{
		dominionRichList.IncreaseStartRow(1);
	}
	else
	{
		dominionRichList.DecreaseStartRow(1);
	}
	return;
}

function SetListUIState(ETeleportListType listType)
{
	if(((int(_teleportUIStateInfo.listType) == 3) && (int(listType) != 3)))
	{
		_teleportUIStateInfo.searchStr = "";
		searchTextInput.Clear();
	}
	if(((int(listType) == 2) && (_specialTeleportList.Length == 0)))
	{
		_teleportUIStateInfo.listType = Normal;
	}
	else
	{
		_teleportUIStateInfo.listType = listType;
	}
	favoritesTabBtn.SetEnable(true);
	specialTabBtn.SetEnable(true);
	specialTypeContiner.HideWindow();
	normalTypeContainer.HideWindow();
	favoritesTypeContainer.HideWindow();
	searchingTypeContainer.HideWindow();
	switch(_teleportUIStateInfo.listType)
	{
		case Favorites:
			favoritesTabBtn.SetEnable(false);
			favoritesTypeContainer.ShowWindow();
			break;
		case Special:
			specialTabBtn.SetEnable(false);
			specialTypeContiner.ShowWindow();
			break;
		case Normal:
			normalTypeContainer.ShowWindow();
			break;
		case Searching:
			searchingTypeContainer.ShowWindow();
			break;
		default:
			break;
	}
	return;
}

function SetFavoritesSortBtnState(ETeleportFavoritesSortType sortType)
{
	local CustomTooltip toolTipInfo;
	local array<DrawItemInfo> drawListArr;
	local Color colorLatest, colorOldest, colorNameAscending, colorNameDescending, colorLevelAscending, colorLevelDescending;
	local L2Util util;
	local Color defaultTextColor;

	util = L2Util(GetScript("L2Util"));
	defaultTextColor.R = 153;
	defaultTextColor.G = 153;
	defaultTextColor.B = 153;
	defaultTextColor.A = 255;
	_teleportUIStateInfo.sortType = sortType;
	colorLatest = defaultTextColor;
	colorOldest = defaultTextColor;
	colorNameAscending = defaultTextColor;
	colorNameDescending = defaultTextColor;
	colorLevelAscending = defaultTextColor;
	colorLevelDescending = defaultTextColor;
	switch(sortType)
	{
		case Latest:
			favoritesSortBtn.SetTexture("L2UI_NewTex.TeleportWnd.ascendingorder_time", "L2UI_NewTex.TeleportWnd.ascendingorder_time", "L2UI_NewTex.TeleportWnd.ascendingorder_time_O");
			colorLatest = util.Yellow;
			break;
		case Oldest:
			favoritesSortBtn.SetTexture("L2UI_NewTex.TeleportWnd.descendingorder_time", "L2UI_NewTex.TeleportWnd.descendingorder_time", "L2UI_NewTex.TeleportWnd.descendingorder_time_O");
			colorOldest = util.Yellow;
			break;
		case NameAscending:
			favoritesSortBtn.SetTexture("L2UI_NewTex.TeleportWnd.ascendingorder", "L2UI_NewTex.TeleportWnd.ascendingorder", "L2UI_NewTex.TeleportWnd.ascendingorder_O");
			colorNameAscending = util.Yellow;
			break;
		case NameDescending:
			favoritesSortBtn.SetTexture("L2UI_NewTex.TeleportWnd.descendingorder", "L2UI_NewTex.TeleportWnd.descendingorder", "L2UI_NewTex.TeleportWnd.descendingorder_O");
			colorNameDescending = util.Yellow;
			break;
		case LevelAscending:
			favoritesSortBtn.SetTexture("L2UI_NewTex.TeleportWnd.ascendingorder_Lv", "L2UI_NewTex.TeleportWnd.ascendingorder_Lv", "L2UI_NewTex.TeleportWnd.ascendingorder_Lv_O");
			colorLevelAscending = util.Yellow;
			break;
		case LevelDescending:
			favoritesSortBtn.SetTexture("L2UI_NewTex.TeleportWnd.descendingorder_Lv", "L2UI_NewTex.TeleportWnd.descendingorder_Lv", "L2UI_NewTex.TeleportWnd.descendingorder_Lv_O");
			colorLevelDescending = util.Yellow;
			break;
		default:
			break;
	}
	drawListArr[drawListArr.Length] = addDrawItemTextureCustom("L2UI_NewTex.TeleportWnd.Tooltip_ascendingorder_time", true, true, 0, 2, 14, 14);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14139), colorLatest, "", false, true, 5, 2);
	drawListArr[drawListArr.Length] = addDrawItemTextureCustom("L2UI_NewTex.TeleportWnd.Tooltip_descendingorder_time", true, true, 0, 2, 14, 14);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14140), colorOldest, "", false, true, 5, 2);
	drawListArr[drawListArr.Length] = addDrawItemTextureCustom("L2UI_NewTex.TeleportWnd.Tooltip_ascendingorder", true, true, 0, 2, 14, 14);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14141), colorNameAscending, "", false, true, 5, 2);
	drawListArr[drawListArr.Length] = addDrawItemTextureCustom("L2UI_NewTex.TeleportWnd.Tooltip_descendingorder", true, true, 0, 2, 14, 14);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14142), colorNameDescending, "", false, true, 5, 2);
	drawListArr[drawListArr.Length] = addDrawItemTextureCustom("L2UI_NewTex.TeleportWnd.Tooltip_ascendingorder_Lv", true, true, 0, 2, 14, 14);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14199), colorLevelAscending, "", false, true, 5, 2);
	drawListArr[drawListArr.Length] = addDrawItemTextureCustom("L2UI_NewTex.TeleportWnd.Tooltip_descendingorder_Lv", true, true, 0, 2, 14, 14);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14200), colorLevelDescending, "", false, true, 5, 2);
	toolTipInfo = MakeTooltipMultiTextByArray(drawListArr);
	favoritesSortBtn.SetTooltipCustomType(toolTipInfo);
	return;
}

function CheckFavoritesBtn(string btnName)
{
	local array<string> names;

	Split(btnName, "_", names);
	if((names[0] == "listFavoritesBtn"))
	{
		OnListFavoritesBtnClicked(int(names[1]));
	}
	return;
}

function StartTeleportSearching()
{
	local string searchStr;

	searchStr = searchTextInput.GetString();
	if((searchStr == ""))
	{
		return;
	}
	_teleportUIStateInfo.searchStr = searchStr;
	if((int(_teleportUIStateInfo.listType) != 3))
	{
		_teleportUIStateInfo.recentlyListType = _teleportUIStateInfo.listType;
	}
	SetListUIState(Searching);
	UpdateDominionListControls();
	ScrollToTopDominionList();
	return;
}

function ResetTelerportSearching()
{
	searchTextInput.Clear();
	_teleportUIStateInfo.searchStr = "";
	if(((int(_teleportUIStateInfo.recentlyListType) == 0) && (townRichList.GetSelectedIndex() == -1)))
	{
		SetCurrentZoneListSelected();
	}
	else
	{
		SetListUIState(_teleportUIStateInfo.recentlyListType);
	}
	UpdateDominionListControls();
	return;
}

function Rq_EV_XML_TeleportFavoritesList()
{
	local array<byte> stream;

	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(644, stream);
	return;
}

function Rq_C_EX_TELEPORT_FAVORITES_UI_TOGGLE(bool isOn)
{
	local array<byte> stream;
	local UIPacket._C_EX_TELEPORT_FAVORITES_UI_TOGGLE packet;

	packet.bOn = byte(isOn);
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_TELEPORT_FAVORITES_UI_TOGGLE(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(645, stream);
	return;
}

function Rq_C_EX_TELEPORT_FAVORITES_ADD_DEL(bool bAdd, int TeleportID)
{
	local array<byte> stream;
	local UIPacket._C_EX_TELEPORT_FAVORITES_ADD_DEL packet;

	packet.bAddOrDel = byte(bAdd);
	packet.nZoneID = TeleportID;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_TELEPORT_FAVORITES_ADD_DEL(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(646, stream);
	return;
}

function RQ_C_EX_Teleport_UI()
{
	local array<byte> stream;

	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(808, stream);
	return;
}

function Rs_EV_XML_TeleportFavoritesList(string param)
{
	local int i, isFavoritesTabOn, favoritesMaxCnt, tempBookmardId;

	ParseInt(param, "bUIOn", isFavoritesTabOn);
	ParseInt(param, "ZoneCount", favoritesMaxCnt);
	if(((bool(isFavoritesTabOn) == true) && (int(_teleportUIStateInfo.listType) != 3)))
	{
		SetListUIState(Favorites);
		UnselectDominionList();
	}
	_favoritesTeleportIds.Length = 0;
	i = 0;
	while((i < favoritesMaxCnt))
	{
		ParseInt(param, ("ZoneID_" $ string(i)), tempBookmardId);
		_favoritesTeleportIds[_favoritesTeleportIds.Length] = tempBookmardId;
		i++;
	}
	UpdateListControls();
	return;
}

function Rs_S_EX_TELEPORT_UI()
{
	local UIPacket._S_EX_TELEPORT_UI packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_TELEPORT_UI(packet))
	{
		return;
	}
	if((_priceRacio != packet.nPriceRatio))
	{
		_priceRacio = packet.nPriceRatio;
		UpdateUIContols();
	}
	return;
}

event OnTabGroupBtnClicked(string parentWndName, string strName, int Index)
{
	if((Index == 1))
	{
		_teleportUIStateInfo.isRecommendType = true;
	}
	else
	{
		_teleportUIStateInfo.isRecommendType = false;
	}
	UpdateUIContols();
	ScrollToTopTownList();
	SetCurrentZoneListSelected();
	Class'InterfaceClassic.TeleportWndMap'.static.Inst().HideMapIconTooltip();
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(20200);
	RegisterEvent(11451);
	RegisterEvent(EV_PacketID(1052));
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

event OnEvent(int a_EventID, string param)
{
	if((true == false))
	{
		return;
	}
	switch(a_EventID)
	{
		case 20200:
			Me.ShowWindow();
			break;
		case 11451:
			Rs_EV_XML_TeleportFavoritesList(param);
			break;
		case EV_PacketID(1052):
			Rs_S_EX_TELEPORT_UI();
			break;
		default:
			break;
	}
	return;
}

event OnShow()
{
	if(Class'NWindow.UIDATA_PLAYER'.static.IsInPrison())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13773));
		Me.HideWindow();
		return;
	}
	searchTextInput.Clear();
	UpdateTeleportTagInfos();
	SetListUIState(_teleportUIStateInfo.listType);
	UpdateSpecialTeleportList();
	UpdateUIContols();
	Class'InterfaceClassic.TeleportWndMap'.static.Inst().UpdateCurrentZoneInfo();
	Class'InterfaceClassic.TeleportWndMap'.static.Inst().StartPlayerPositionTimer();
	Class'InterfaceClassic.TeleportWndMap'.static.Inst().PlayMapIconAnimation();
	SetCurrentZoneListSelected();
	SetFavoritesSortBtnState(ETeleportFavoritesSortType(GetOptionInt("UI", "TeleportFavoritesSortType")));
	Rq_EV_XML_TeleportFavoritesList();
	if(true)
	{
		RQ_C_EX_Teleport_UI();
	}
	Me.SetFocus();
	townRichList.SetFocus();
	return;
}

event OnHide()
{
	Class'InterfaceClassic.TeleportWndMap'.static.Inst().KillPlayerPositionTimer();
	Class'InterfaceClassic.TeleportWndMap'.static.Inst().StopMapIconAnimation();
	teleportDialog.Hide();
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "FavoritesView_Btn":
			OnBookMarkTabBtnClicked();
			break;
		case "SpecialView_Btn":
			OnSpecialTabBtnClicked();
			break;
		case "BtnFind":
			OnSearchBtnClicked();
			break;
		case "Teleport_Btn":
			OnTeleportBtnClicked();
			break;
		case "FavoritesSort_btn":
			OnFavoritesSortBtnClicked();
			break;
		case "TownZoneArrowUP_Btn":
			SetTownRichListScroll(false);
			break;
		case "TownZoneArrowDown_Btn":
			SetTownRichListScroll(true);
			break;
		case "HuntingZoneArrowUP_Btn":
			SetDominionRichListScroll(false);
			break;
		case "HuntingZoneArrowDown_Btn":
			SetDominionRichListScroll(true);
			break;
		default:
			CheckFavoritesBtn(Name);
			break;
	}
	return;
}

event OnClickListCtrlRecord(string strID)
{
	switch(strID)
	{
		case "TownZone_ListCtrl":
			if((int(_teleportUIStateInfo.listType) == 1))
			{
				Rq_C_EX_TELEPORT_FAVORITES_UI_TOGGLE(false);
			}
			SetListUIState(Normal);
			UpdateDominionListControls();
			ScrollToTopDominionList();
			UpdateMapDominionZoneIcons();
			break;
		case "HuntingZone_ListCtrl":
			UpdateMapDominionZoneIcons();
			break;
		default:
			break;
	}
	return;
}

event OnDBClickListCtrlRecord(string strID)
{
	local RichListCtrlRowData selectedData;

	switch(strID)
	{
		case "TownZone_ListCtrl":
			townRichList.GetSelectedRec(selectedData);
			if((selectedData.nReserved2 > INT64(0)))
			{
				ShowTeleportDialog(selectedData.nReserved1);
			}
			else
			{
				getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13743));
			}
			break;
		case "HuntingZone_ListCtrl":
			dominionRichList.GetSelectedRec(selectedData);
			ShowTeleportDialog(selectedData.nReserved1);
			break;
		default:
			break;
	}
	return;
}

event OnRollOverListCtrlRecord(string strID, int Index)
{
	local RichListCtrlRowData targetData;

	switch(strID)
	{
		case "TownZone_ListCtrl":
			if((Index >= 0))
			{
				townRichList.GetRec(Index, targetData);
				Class'InterfaceClassic.TeleportWndMap'.static.Inst().ShowMapIconTooltip(int(targetData.nReserved1));
			}
			else
			{
				Class'InterfaceClassic.TeleportWndMap'.static.Inst().HideMapIconTooltip();
			}
			break;
		case "HuntingZone_ListCtrl":
			if((Index >= 0))
			{
				dominionRichList.GetRec(Index, targetData);
				Class'InterfaceClassic.TeleportWndMap'.static.Inst().ShowMapIconTooltip(int(targetData.nReserved1));
			}
			else
			{
				Class'InterfaceClassic.TeleportWndMap'.static.Inst().HideMapIconTooltip();
			}
			break;
		default:
			break;
	}
	return;
}

event OnMouseOut(WindowHandle WindowHandle)
{
	if(((WindowHandle == townRichList) || (WindowHandle == dominionRichList)))
	{
		Class'InterfaceClassic.TeleportWndMap'.static.Inst().HideMapIconTooltip();
	}
	return;
}

event OnBookMarkTabBtnClicked()
{
	if((int(_teleportUIStateInfo.listType) != 1))
	{
		Rq_C_EX_TELEPORT_FAVORITES_UI_TOGGLE(true);
	}
	SetListUIState(Favorites);
	UnselectTownList();
	ScrollToTopDominionList();
	UpdateDominionListControls();
	UpdateMapDominionZoneIcons();
	return;
}

event OnSpecialTabBtnClicked()
{
	if((int(_teleportUIStateInfo.listType) == 1))
	{
		Rq_C_EX_TELEPORT_FAVORITES_UI_TOGGLE(false);
	}
	SetListUIState(Special);
	UnselectTownList();
	ScrollToTopDominionList();
	UpdateDominionListControls();
	UpdateMapDominionZoneIcons();
	return;
}

event OnTeleportBtnClicked()
{
	local int selectedTeleportID;

	selectedTeleportID = GetSelectedTeleportID();
	if((selectedTeleportID >= 0))
	{
		ShowTeleportDialog(INT64(selectedTeleportID));
	}
	else
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13743));
	}
	return;
}

event OnFavoritesSortBtnClicked()
{
	local ETeleportFavoritesSortType nextSortType;

	nextSortType = _teleportUIStateInfo.sortType;
	nextSortType = ETeleportFavoritesSortType((int(nextSortType) + 1));
	if((int(nextSortType) >= 6))
	{
		nextSortType = Latest;
	}
	SetFavoritesSortBtnState(nextSortType);
	SetOptionInt("UI", "TeleportFavoritesSortType", int(nextSortType));
	UpdateDominionListControls();
	return;
}

event OnSearchBtnClicked()
{
	StartTeleportSearching();
	return;
}

event OnSearchTextInputClear()
{
	ResetTelerportSearching();
	return;
}

event OnSearchTextInputCompleted(string Text)
{
	StartTeleportSearching();
	return;
}

event OnListFavoritesBtnClicked(int TeleportID)
{
	local bool isFavorites;

	isFavorites = IsTeleportFavorites(TeleportID);
	if((!isFavorites && (_favoritesTeleportIds.Length >= 50)))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13194));
		return;
	}
	if((IsPlayerOnWorldRaidServer() == false))
	{
		if(isFavorites)
		{
			RemoveTeleportFavorites(TeleportID);
		}
		else
		{
			AddTeleportFavorites(TeleportID);
		}
		UpdateListControls();
	}
	Rq_C_EX_TELEPORT_FAVORITES_ADD_DEL(!isFavorites, TeleportID);
	return;
}

event OnTeleportDialogCancel()
{
	teleportDialog.Hide();
	_tempTeleportId = 0;
	return;
}

event OnTeleportDialogConfirm()
{
	local UserInfo UserInfo;

	if((GetPlayerInfo(UserInfo) == false))
	{
		return;
	}
	if((UserInfo.nCurHP == INT64(0)))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(5243));
		teleportDialog.Hide();
		return;
	}
	Class'NWindow.TeleportListAPI'.static.RequestTeleport(_tempTeleportId);
	teleportDialog.Hide();
	Me.HideWindow();
	_tempTeleportId = 0;
	return;
}

event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	Me.HideWindow();
	return;
}
