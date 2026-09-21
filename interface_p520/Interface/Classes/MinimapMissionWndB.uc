class MinimapMissionWndB extends UICommonAPI;

const QuestStatus_None = 0;
const QuestStatus_Doing = 1;
const QuestStatus_Done = 2;

enum ERAID_BOSS_SPAWN_INFO
{
	ERBSI_DEAD,                     // 0
	ERBSI_READY,                    // 1
	ERBSI_BATTLE,                   // 2
	ERBSI_MAX                       // 3
};

struct MapListInfo
{
	var string sortingKey;
	var int Index;
};

struct QuestRecommandData
{
	var int categoryId;
	var int Priority;
	var int QuestID;
};

struct QuestCategoryArrayData
{
	var int categoryId;
	var array<QuestRecommandData> questRecommandData_Array;
};

var WindowHandle Me;
var TextBoxHandle TxtMission_Title;
var WindowHandle MissionTab;
var ButtonHandle BTN_Huntingzone;
var ButtonHandle BTN_Inzone;
var ButtonHandle BTN_Raid;
var ListCtrlHandle Mission_ListCtrl;
var WindowHandle LocalInfoTab;
var ListCtrlHandle LocalInfo_ListCtrl;
var TabHandle TabCtrl;
var MinimapWnd miniMapWndScript;
var ListCtrlHandle QuestInfo_ListCtrl;
var ButtonHandle BTN_AllQuest;
var TextureHandle QuestTooltip;
var bool bShowHuntingZone;
var bool bShowInzone;
var bool bShowRaid;
var LVDataRecord lastSelectListRecord;
var int nClassID;
var string m_Windowname;
//var delegate<OnSortCompare> __OnSortCompare__Delegate;
//var delegate<OnSortCompareForRaid> __OnSortCompareForRaid__Delegate;
//var delegate<OnSortCompareQuestPriority> __OnSortCompareQuestPriority__Delegate;

function OnRegisterEvent()
{
	RegisterEvent(40);
	RegisterEvent(5860);
	RegisterEvent(10181);
	return;
}

function OnLoad()
{
	Initialize();
	Load();
	SetClosingOnESC();
	return;
}

function Initialize()
{
	Me = GetWindowHandle(m_Windowname);
	TxtMission_Title = GetTextBoxHandle((m_Windowname $ ".TxtMission_Title"));
	MissionTab = GetWindowHandle((m_Windowname $ ".MissionTab"));
	BTN_Huntingzone = GetButtonHandle((m_Windowname $ ".MissionTab.BTN_Huntingzone"));
	BTN_Inzone = GetButtonHandle((m_Windowname $ ".MissionTab.BTN_Inzone"));
	BTN_Raid = GetButtonHandle((m_Windowname $ ".MissionTab.BTN_Raid"));
	Mission_ListCtrl = GetListCtrlHandle((m_Windowname $ ".MissionTab.Mission_ListCtrl"));
	LocalInfoTab = GetWindowHandle((m_Windowname $ ".LocalInfoTab"));
	LocalInfo_ListCtrl = GetListCtrlHandle((m_Windowname $ ".LocalInfoTab.LocalInfo_ListCtrl"));
	TabCtrl = GetTabHandle((m_Windowname $ ".TabCtrl"));
	QuestInfo_ListCtrl = GetListCtrlHandle((m_Windowname $ ".QuestInfoTab.QuestInfo_ListCtrl"));
	BTN_AllQuest = GetButtonHandle((m_Windowname $ ".QuestInfoTab.BTN_AllQuest"));
	QuestTooltip = GetTextureHandle((m_Windowname $ ".QuestInfoTab.QuestTooltip"));
	miniMapWndScript = MinimapWnd(GetScript("MinimapWnd"));
	return;
}

function OnShow()
{
	updateOptionSave();
	refresh();
	Me.SetFocus();
	return;
}

function OnHide()
{
	getInstanceL2Util().HideGFxMiniMapSelectedPin(PIN_YELLOW);
	return;
}

function Load()
{
	Init();
	QuestInfo_ListCtrl.SetSelectedSelTooltip(false);
	QuestInfo_ListCtrl.SetAppearTooltipAtMouseX(true);
	InitQuestTooltip();
	return;
}

function Init()
{
	bShowRaid = true;
	bShowInzone = true;
	bShowHuntingZone = true;
	LocalInfo_ListCtrl.DeleteAllItem();
	Mission_ListCtrl.DeleteAllItem();
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "BTN_Raid":
		case "BTN_Inzone":
		case "BTN_Huntingzone":
			toggleButtonClick(Name);
			break;
		case "BTN_AllQuest":
			if(GetWindowHandle("QuestListWnd").IsShowWindow())
			{
				GetWindowHandle("QuestListWnd").HideWindow();
			}
			else
			{
				ShowQuestInfoWindow();
			}
			break;
		case "minCloseButton":
			Me.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
	switch(ListCtrlID)
	{
		case "Mission_ListCtrl":
			HandleDBClickedRaid();
			break;
		default:
			break;
	}
	return;
}

function HandleDBClickedRaid()
{
	local LVDataRecord Record;
	local int NpcID;

	Mission_ListCtrl.GetSelectedRec(Record);
	ParseInt(Record.LVDataList[0].szReserved, "npcID", NpcID);
	if((NpcID > 0))
	{
		CallGFxFunction("MiniMapGFxWnd", "ShowRaidTeleportDialog", string(NpcID));
	}
	return;
}

function toggleButtonClick(string buttonName)
{
	switch(buttonName)
	{
		case "BTN_Raid":
			bShowRaid = !bShowRaid;
			SetINIBool("MinimapMissionWnd", "a", bShowRaid, "WindowsInfo.ini");
			break;
		case "BTN_Inzone":
			bShowInzone = !bShowInzone;
			SetINIBool("MinimapMissionWnd", "e", bShowInzone, "WindowsInfo.ini");
			break;
		case "BTN_Huntingzone":
			bShowHuntingZone = !bShowHuntingZone;
			SetINIBool("MinimapMissionWnd", "p", bShowHuntingZone, "WindowsInfo.ini");
			break;
		default:
			break;
	}
	CallGFxFunction("MiniMapGFxWnd", "showHideCommend", "");
	Debug("열때-버튼");  // EN: on open - button
	refresh();
	return;
}

function updateOptionSave()
{
	local int nHunt, nInzone, nRaid, nFirstRun;

	GetINIBool("MinimapMissionWnd", "l", nFirstRun, "WindowsInfo.ini");
	GetINIBool("MinimapMissionWnd", "a", nRaid, "WindowsInfo.ini");
	GetINIBool("MinimapMissionWnd", "e", nInzone, "WindowsInfo.ini");
	GetINIBool("MinimapMissionWnd", "p", nHunt, "WindowsInfo.ini");
	if((nFirstRun == 0))
	{
		bShowRaid = true;
		bShowInzone = true;
		bShowHuntingZone = true;
		SetINIBool("MinimapMissionWnd", "a", bShowRaid, "WindowsInfo.ini");
		SetINIBool("MinimapMissionWnd", "e", bShowInzone, "WindowsInfo.ini");
		SetINIBool("MinimapMissionWnd", "p", bShowHuntingZone, "WindowsInfo.ini");
		SetINIBool("MinimapMissionWnd", "l", true, "WindowsInfo.ini");
	}
	else
	{
		bShowRaid = numToBool(nRaid);
		bShowInzone = numToBool(nInzone);
		bShowHuntingZone = numToBool(nHunt);
	}
	return;
}

function updateToggleButton()
{
	if(bShowRaid)
	{
		BTN_Raid.SetTexture("L2UI_CT1.Button.Button_DF_Small", "L2UI_CT1.Button.Button_DF_Small", "L2UI_CT1.Button.Button_DF_Small_Over");
	}
	else
	{
		BTN_Raid.SetTexture("L2UI_CT1.Button.Button_DF_Small_Toggle", "L2UI_CT1.Button.Button_DF_Small_Toggle_Down", "L2UI_CT1.Button.Button_DF_Small_Toggle_Over");
	}
	if(bShowHuntingZone)
	{
		BTN_Huntingzone.SetTexture("L2UI_CT1.Button.Button_DF_Small", "L2UI_CT1.Button.Button_DF_Small", "L2UI_CT1.Button.Button_DF_Small_Over");
	}
	else
	{
		BTN_Huntingzone.SetTexture("L2UI_CT1.Button.Button_DF_Small_Toggle", "L2UI_CT1.Button.Button_DF_Small_Toggle_Down", "L2UI_CT1.Button.Button_DF_Small_Toggle_Over");
	}
	if(getInstanceUIData().GetIsClassicServer())
	{
		bShowInzone = false;
		BTN_Inzone.HideWindow();
		GetTextureHandle((m_Windowname $ ".MissionTab.BTNICON_Inzone_Tex")).HideWindow();
		BTN_Raid.ClearAnchor();
		BTN_Raid.SetAnchor((m_Windowname $ ".MissionTab.BTN_Huntingzone"), "TopLeft", "TopLeft", 107, 0);
		GetTextureHandle((m_Windowname $ ".MissionTab.BTNICON_Raid_Tex")).ClearAnchor();
		GetTextureHandle((m_Windowname $ ".MissionTab.BTNICON_Raid_Tex")).SetAnchor((m_Windowname $ ".MissionTab.BTN_Raid"), "TopLeft", "TopLeft", 6, 5);
	}
	else
	{
		BTN_Raid.ClearAnchor();
		BTN_Raid.SetAnchor((m_Windowname $ ".MissionTab.BTN_Huntingzone"), "TopLeft", "TopLeft", 254, 0);
		GetTextureHandle((m_Windowname $ ".MissionTab.BTNICON_Raid_Tex")).ClearAnchor();
		GetTextureHandle((m_Windowname $ ".MissionTab.BTNICON_Raid_Tex")).SetAnchor((m_Windowname $ ".MissionTab.BTN_Raid"), "TopLeft", "TopLeft", 6, 5);
		BTN_Inzone.ShowWindow();
		GetTextureHandle((m_Windowname $ ".MissionTab.BTNICON_Inzone_Tex")).ShowWindow();
		if(bShowInzone)
		{
			BTN_Inzone.SetTexture("L2UI_CT1.Button.Button_DF_Small", "L2UI_CT1.Button.Button_DF_Small", "L2UI_CT1.Button.Button_DF_Small_Over");
		}
		else
		{
			BTN_Inzone.SetTexture("L2UI_CT1.Button.Button_DF_Small_Toggle", "L2UI_CT1.Button.Button_DF_Small_Toggle_Down", "L2UI_CT1.Button.Button_DF_Small_Toggle_Over");
		}
	}
	return;
}

function bool isShowRaid()
{
	return bShowRaid;
}

function bool isShowInzone()
{
	return bShowInzone;
}

function bool isShowHuntingZone()
{
	return bShowHuntingZone;
}

function refresh()
{
	updateToggleButton();
	addMissionList();
	addLocalList();
	if((IsAdenServer() || getInstanceUIData().GetIsLiveServer()))
	{
		TabCtrl.RemoveTabControl(2);
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".TabLineBg")).SetWindowSize(138, 23);
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".TabLineBg")).SetAnchor(((m_Windowname $ ".") $ TabCtrl.GetWindowName()), "TopLeft", "TopLeft", 218, 0);
	}
	else
	{
		addQuestList();
	}
	return;
}

function bool tryLevelCheckForHuntingZone(int UserLevel, int MinLevel, int MaxLevel)
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		return tryLevelCheck(UserLevel, MinLevel, MaxLevel);
	}
	else if(((UserLevel >= (MinLevel - 10)) && (UserLevel <= (MaxLevel + 10))))
	{
		return true;
	}
	return false;
}

function bool IsValidataHuntingzoneData(HuntingZoneUIData huntingZoneData)
{
	if((huntingZoneData.strName != ""))
	{
		return true;
	}
	if((((huntingZoneData.nSearchZoneID == 0) && (huntingZoneData.nRegionID == 0)) && (huntingZoneData.nInstantZoneID == 0)))
	{
		return false;
	}
}

function addMissionList()
{
	local array<MapListInfo> nHuntingArray, nInzoneArray;
	local UserInfo pUserInfo;
	local HuntingZoneUIData huntingZoneData;

	GetPlayerInfo(pUserInfo);
	Mission_ListCtrl.DeleteAllItem();
	nHuntingArray.Remove(0, nHuntingArray.Length);
	nInzoneArray.Remove(0, nInzoneArray.Length);
	huntingZoneData = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetFirstHuntingZoneData();
	while(IsValidataHuntingzoneData(huntingZoneData))
	{
		if((((huntingZoneData.nType == 1) || (huntingZoneData.nType == 2)) || (huntingZoneData.nType == 10)))
		{
			if(bShowHuntingZone)
			{
				if((tryLevelCheckForHuntingZone(pUserInfo.nLevel, huntingZoneData.nMinLevel, huntingZoneData.nMaxLevel) == false))
				{
					huntingZoneData = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetNextHuntingZoneData();
					continue;
				}
				nHuntingArray.Insert(nHuntingArray.Length, 1);
				nHuntingArray[(nHuntingArray.Length - 1)].Index = huntingZoneData.nID;
				nHuntingArray[(nHuntingArray.Length - 1)].sortingKey = getInstanceL2Util().makeZeroString(4, INT64(huntingZoneData.nMinLevel));
				// nHuntingArray.Sort(OnSortCompare);   // array.Sort() unsupported by this compiler
			}
			huntingZoneData = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetNextHuntingZoneData();
			continue;
		}
		if((((huntingZoneData.nType == 3) || (huntingZoneData.nType == 4)) || (huntingZoneData.nType == 12)))
		{
			if(bShowInzone)
			{
				if((tryLevelCheck(pUserInfo.nLevel, huntingZoneData.nMinLevel, huntingZoneData.nMaxLevel) == false))
				{
					huntingZoneData = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetNextHuntingZoneData();
					continue;
				}
				nInzoneArray.Insert(nInzoneArray.Length, 1);
				nInzoneArray[(nInzoneArray.Length - 1)].Index = huntingZoneData.nID;
				nInzoneArray[(nInzoneArray.Length - 1)].sortingKey = getInstanceL2Util().makeZeroString(4, INT64(huntingZoneData.nMinLevel));
				// nInzoneArray.Sort(OnSortCompare);   // array.Sort() unsupported by this compiler
			}
		}
		huntingZoneData = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetNextHuntingZoneData();
	}
	makeMapList(Mission_ListCtrl, nHuntingArray, GetSystemString(1296), true, "L2UI_CT1.Minimap.Mission_huntingzone", false);
	makeMapList(Mission_ListCtrl, nInzoneArray, GetSystemString(2668), true, "L2UI_CT1.Minimap.Mission_inzone", true);
	if(bShowInzone)
	{
		RequestInzoneWaitingTime(false);
	}
	if(bShowRaid)
	{
		makeRaidList();
	}
	missionListBeforeSelect();
	return;
}

function missionListBeforeSelect()
{
	local int i, nInstantZoneID, Index, nFactionID, NpcID, selectedInstantZoneID, SelectedIndex, selectedNFactionID, selectedNpcID;
	local LVDataRecord Record;

	i = 0;
	while((i < Mission_ListCtrl.GetRecordCount()))
	{
		Mission_ListCtrl.GetRec(i, Record);
		if((Record.LVDataList.Length == 0))
		{
			i++;
			continue;
		}
		ParseInt(Record.LVDataList[0].szReserved, "instantZoneID", nInstantZoneID);
		ParseInt(Record.LVDataList[0].szReserved, "nFactionID", nFactionID);
		ParseInt(Record.LVDataList[0].szReserved, "index", Index);
		ParseInt(Record.LVDataList[0].szReserved, "npcID", NpcID);
		if((lastSelectListRecord.LVDataList.Length == 0))
		{
			i++;
			continue;
		}
		ParseInt(lastSelectListRecord.LVDataList[0].szReserved, "instantZoneID", selectedInstantZoneID);
		ParseInt(lastSelectListRecord.LVDataList[0].szReserved, "nFactionID", selectedNFactionID);
		ParseInt(lastSelectListRecord.LVDataList[0].szReserved, "index", SelectedIndex);
		ParseInt(lastSelectListRecord.LVDataList[0].szReserved, "npcID", selectedNpcID);
		if(((((nInstantZoneID + nFactionID) + Index) + NpcID) <= 0))
		{
			i++;
			continue;
		}
		if(((((nInstantZoneID == selectedInstantZoneID) && (selectedNFactionID == nFactionID)) && (SelectedIndex == Index)) || ((selectedNpcID == NpcID) && (selectedNpcID > 0))))
		{
			Mission_ListCtrl.SetSelectedIndex(i, true);
			break;
		}
		i++;
	}
	return;
}

function MakeMapListCastle(ListCtrlHandle List, array<MapListInfo> targetMapListInfo, string headerString, bool bLevelLimitView, string headerIcon, optional bool bInstanceZoneID)
{
	local int N, i;
	local string addStr, backStr, szReserved, IconName;
	local HuntingZoneUIData huntingZoneData;
	local LVData lData;

	N = 0;
	while((N < targetMapListInfo.Length))
	{
		addStr = "";
		szReserved = "";
		i = targetMapListInfo[N].Index;
		Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(i, huntingZoneData);
		if((N == 0))
		{
			addListItemHead(List, (((headerString $ " (") $ string(targetMapListInfo.Length)) $ ")"), headerIcon);
		}
		ParamAdd(szReserved, "index", string(i));
		if(bInstanceZoneID)
		{
			ParamAdd(szReserved, "instantZoneID", string(huntingZoneData.nInstantZoneID));
		}
		if(bLevelLimitView)
		{
			addStr = getLevelRangeString(i);
		}
		backStr = "";
		if(((huntingZoneData.nInstantZoneID == 0) && (bInstanceZoneID == true)))
		{
			backStr = (("(" $ GetSystemString(3554)) $ ")");
		}
		lData = makeListLvDataText(((addStr $ huntingZoneData.strName) $ backStr), getInstanceL2Util().Gold, huntingZoneData.nWorldLoc, szReserved);
		IconName = getInstanceL2Util().GetCastleIconName(GetCastleIDByHuttingZoneID(i));
		Debug(IconName);
		if((IconName != ""))
		{
			lData.hasIcon = true;
			lData.nTextureWidth = 15;
			lData.nTextureHeight = 15;
			lData.nTextureU = 15;
			lData.nTextureV = 15;
			lData.szTexture = IconName;
		}
		addListItem(List, lData);
		N++;
	}
	return;
}

function makeMapList(ListCtrlHandle List, array<MapListInfo> targetMapListInfo, string headerString, bool bLevelLimitView, string headerIcon, optional bool bInstanceZoneID)
{
	local int N, i;
	local string addStr, backStr, szReserved;
	local HuntingZoneUIData huntingZoneData;
	local LVData lData;

	N = 0;
	while((N < targetMapListInfo.Length))
	{
		addStr = "";
		szReserved = "";
		i = targetMapListInfo[N].Index;
		Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(i, huntingZoneData);
		if((N == 0))
		{
			addListItemHead(List, (((headerString $ " (") $ string(targetMapListInfo.Length)) $ ")"), headerIcon);
		}
		ParamAdd(szReserved, "index", string(i));
		if(bInstanceZoneID)
		{
			ParamAdd(szReserved, "instantZoneID", string(huntingZoneData.nInstantZoneID));
		}
		if(bLevelLimitView)
		{
			addStr = getLevelRangeString(i);
		}
		backStr = "";
		if(((huntingZoneData.nInstantZoneID == 0) && (bInstanceZoneID == true)))
		{
			backStr = (("(" $ GetSystemString(3554)) $ ")");
		}
		lData = makeListLvDataText(((addStr $ huntingZoneData.strName) $ backStr), getInstanceL2Util().Gold, huntingZoneData.nWorldLoc, szReserved);
		if(getInstanceUIData().GetIsLiveServer())
		{
			if((huntingZoneData.nType == 1))
			{
				lData.hasIcon = true;
				lData.nTextureWidth = 15;
				lData.nTextureHeight = 11;
				lData.nTextureU = 15;
				lData.nTextureV = 11;
				lData.szTexture = "L2UI_CH3.QuestWnd.QuestWndInfoIcon_6";
			}
			else if((huntingZoneData.nType == 10))
			{
				lData.hasIcon = true;
				lData.nTextureWidth = 15;
				lData.nTextureHeight = 11;
				lData.nTextureU = 15;
				lData.nTextureV = 11;
				lData.szTexture = "L2UI_CH3.QuestWnd.QuestWndInfoIcon_7";
			}
			else if((huntingZoneData.nType == 2))
			{
				lData.hasIcon = true;
				lData.nTextureWidth = 15;
				lData.nTextureHeight = 11;
				lData.nTextureU = 15;
				lData.nTextureV = 11;
				lData.szTexture = "L2UI_CH3.QuestWnd.QuestWndInfoIcon_8";
			}
		}
		addListItem(List, lData);
		N++;
	}
	return;
}

function addLocalList()
{
	local array<MapListInfo> nCastlevilleArray, nFortressArray, nAgitCountArray, nHuntingZoneArray, nFactionArray;
	local HuntingZoneUIData huntingZoneData;

	if((LocalInfo_ListCtrl.GetRecordCount() <= 0))
	{
		LocalInfo_ListCtrl.DeleteAllItem();
		nCastlevilleArray.Remove(0, nCastlevilleArray.Length);
		nFortressArray.Remove(0, nFortressArray.Length);
		nAgitCountArray.Remove(0, nAgitCountArray.Length);
		nHuntingZoneArray.Remove(0, nHuntingZoneArray.Length);
		nFactionArray.Remove(0, nFactionArray.Length);
		huntingZoneData = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetFirstHuntingZoneData();
		while(IsValidataHuntingzoneData(huntingZoneData))
		{
			if((huntingZoneData.nType == 8))
			{
				nCastlevilleArray.Insert(nCastlevilleArray.Length, 1);
				nCastlevilleArray[(nCastlevilleArray.Length - 1)].Index = huntingZoneData.nID;
				nCastlevilleArray[(nCastlevilleArray.Length - 1)].sortingKey = huntingZoneData.strName;
				// nCastlevilleArray.Sort(OnSortCompare);   // array.Sort() unsupported by this compiler
				huntingZoneData = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetNextHuntingZoneData();
				continue;
			}
			if((huntingZoneData.nType == 9))
			{
				nFortressArray.Insert(nFortressArray.Length, 1);
				nFortressArray[(nFortressArray.Length - 1)].Index = huntingZoneData.nID;
				nFortressArray[(nFortressArray.Length - 1)].sortingKey = huntingZoneData.strName;
				// nFortressArray.Sort(OnSortCompare);   // array.Sort() unsupported by this compiler
				huntingZoneData = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetNextHuntingZoneData();
				continue;
			}
			if((huntingZoneData.nType == 5))
			{
				nAgitCountArray.Insert(nAgitCountArray.Length, 1);
				nAgitCountArray[(nAgitCountArray.Length - 1)].Index = huntingZoneData.nID;
				nAgitCountArray[(nAgitCountArray.Length - 1)].sortingKey = huntingZoneData.strName;
				// nAgitCountArray.Sort(OnSortCompare);   // array.Sort() unsupported by this compiler
				huntingZoneData = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetNextHuntingZoneData();
				continue;
			}
			if((((huntingZoneData.nType == 1) || (huntingZoneData.nType == 2)) || (huntingZoneData.nType == 10)))
			{
				nHuntingZoneArray.Insert(nHuntingZoneArray.Length, 1);
				nHuntingZoneArray[(nHuntingZoneArray.Length - 1)].Index = huntingZoneData.nID;
				nHuntingZoneArray[(nHuntingZoneArray.Length - 1)].sortingKey = getInstanceL2Util().makeZeroString(4, INT64(huntingZoneData.nMinLevel));
				// nHuntingZoneArray.Sort(OnSortCompare);   // array.Sort() unsupported by this compiler
			}
			huntingZoneData = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetNextHuntingZoneData();
		}
		MakeMapListCastle(LocalInfo_ListCtrl, nCastlevilleArray, GetSystemString(3529), false, "L2UI_CT1.EmptyBtn");
		makeMapList(LocalInfo_ListCtrl, nFortressArray, GetSystemString(1605), false, "L2UI_CT1.EmptyBtn");
		makeMapList(LocalInfo_ListCtrl, nAgitCountArray, GetSystemString(1616), false, "L2UI_CT1.EmptyBtn");
		makeMapList(LocalInfo_ListCtrl, nHuntingZoneArray, GetSystemString(1296), true, "L2UI_CT1.EmptyBtn");
	}
	return;
}

function makeFactionList()
{
	local array<L2UserFactionUIInfo> factionInfoListArray;
	local UserInfo pUserInfo;
	local int i;
	local string szReserved;
	local L2FactionUIData FactionData;
	local MinimapRegionIconData IconData;
	local Vector Loc;

	GetPlayerInfo(pUserInfo);
	GetUserFactionInfoList(pUserInfo.nID, factionInfoListArray);
	i = 0;
	while((i < factionInfoListArray.Length))
	{
		GetFactionData(factionInfoListArray[i].nFactionID, FactionData);
		if(GetMinimapRegionIconData(FactionData.nRegionID, IconData))
		{
			Loc.X = float(IconData.nWorldLocX);
			Loc.Y = float(IconData.nWorldLocY);
			Loc.Z = float(IconData.nWorldLocZ);
		}
		if((i == 0))
		{
			addListItemHead(LocalInfo_ListCtrl, (((GetSystemString(3443) $ " (") $ string(factionInfoListArray.Length)) $ ")"), "L2UI_CT1.EmptyBtn");
		}
		szReserved = "";
		ParamAdd(szReserved, "nFactionID", string(FactionData.nFactionID));
		addListItem(LocalInfo_ListCtrl, makeListLvDataText(FactionData.strFactionName, getInstanceL2Util().Gold, Loc, szReserved));
		i++;
	}
	return;
}

function makeRaidList()
{
	local UserInfo pUserInfo;
	local int i, raidCount;
	local array<int> raidNpcIDArray;
	local string addStr;
	local array<UIConstants.RaidUIData> raidUIDataArray;
	local UIConstants.RaidUIData raidData;
	local array<int> raidDataKeyList;
	local string szReserved;
	local int raidMin, raidMax;

	GetPlayerInfo(pUserInfo);
	Class'NWindow.UIDATA_RAID'.static.GetRaidDataKeyList(raidDataKeyList);
	if(IsBloodyServer())
	{
		raidMin = 2000;
		raidMax = 2500;
	}
	else
	{
		raidMin = 0;
		raidMax = 2000;
	}
	i = 0;
	while((i < raidDataKeyList.Length))
	{
		raidData = getRaidDataByIndex(raidDataKeyList[i]);
		addStr = "";
		if((((raidData.nWorldLoc.X == 0.0000000) && (raidData.nWorldLoc.Y == 0.0000000)) && (raidData.nWorldLoc.Z == 0.0000000)))
		{
			i++;
			continue;
		}
		if((tryLevelCheck(pUserInfo.nLevel, raidData.nMinLevel, raidData.nMaxLevel) == false))
		{
			i++;
			continue;
		}
		raidData.sortingKey = getInstanceL2Util().makeZeroString(4, INT64(raidData.nRaidMonsterLevel));
		raidUIDataArray[raidUIDataArray.Length] = raidData;
		i++;
	}
	// raidUIDataArray.Sort(OnSortCompareForRaid);   // array.Sort() unsupported by this compiler
	i = 0;
	while((i < raidUIDataArray.Length))
	{
		if((raidCount == 0))
		{
			addListItemHead(Mission_ListCtrl, (((GetSystemString(1297) $ " (") $ string(raidUIDataArray.Length)) $ ")"), "L2UI_CT1.Minimap.Mission_raid");
		}
		raidCount++;
		raidData = raidUIDataArray[i];
		szReserved = "";
		ParamAdd(szReserved, "npcID", string(raidData.nRaidMonsterID));
		ParamAdd(szReserved, "index", string(raidData.Id));
		addStr = (("[Lv." $ string(raidData.nRaidMonsterLevel)) $ "] ");
		ParamAdd(szReserved, "addStr", addStr);
		raidNpcIDArray[raidNpcIDArray.Length] = raidData.nRaidMonsterID;
		addListItem(Mission_ListCtrl, makeListLvDataText(((((addStr $ raidData.raidMonsterName) $ " (") $ GetSystemString(1718)) $ ")"), getInstanceL2Util().ColorGray, raidData.nWorldLoc, szReserved));
		i++;
	}
	if((raidNpcIDArray.Length > 0))
	{
		Class'NWindow.MiniMapAPI'.static.RequestRaidBossSpawnInfo(raidNpcIDArray);
	}
	return;
}

function addListItem(ListCtrlHandle List, LVData lData)
{
	local LVDataRecord Record;

	Record.LVDataList.Length = 1;
	Record.LVDataList[0] = lData;
	List.InsertRecord(Record);
	return;
}

function addListItemHead(ListCtrlHandle List, string textStr, string IconName)
{
	local LVDataRecord Record;

	Record.LVDataList.Length = 1;
	Record.LVDataList[0].hasIcon = true;
	Record.LVDataList[0].szData = (" " $ textStr);
	Record.LVDataList[0].nTextureWidth = 15;
	Record.LVDataList[0].nTextureHeight = 15;
	Record.LVDataList[0].nTextureU = 15;
	Record.LVDataList[0].nTextureV = 15;
	Record.LVDataList[0].szTexture = IconName;
	Record.LVDataList[0].iconBackTexName = "L2UI_CT1.List_HeadLineFrame";
	Record.LVDataList[0].backTexOffsetXFromIconPosX = -6;
	Record.LVDataList[0].backTexOffsetYFromIconPosY = 0;
	Record.LVDataList[0].backTexWidth = 354;
	Record.LVDataList[0].backTexHeight = 19;
	Record.LVDataList[0].backTexUL = 32;
	Record.LVDataList[0].backTexVL = 19;
	List.InsertRecord(Record);
	return;
}

function ShowQuestTarget()
{
	local int idx, QuestID, NpcID;
	local string strTargetName, questName;
	local Vector vTargetPos;
	local LVDataRecord Record;

	idx = QuestInfo_ListCtrl.GetSelectedIndex();
	if((idx > -1))
	{
		QuestInfo_ListCtrl.GetRec(idx, Record);
		QuestID = int(Record.nReserved1);
	}
	if((QuestID > 0))
	{
		questName = Class'NWindow.UIDATA_QUEST'.static.GetQuestName(QuestID, 1);
		NpcID = Class'NWindow.UIDATA_QUEST'.static.GetStartNPCID(QuestID, 1);
		strTargetName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(NpcID);
		vTargetPos = Class'NWindow.UIDATA_QUEST'.static.GetStartNPCLoc(QuestID, 1);
		if((((vTargetPos.X == 0.0000000) && (vTargetPos.Y == 0.0000000)) && (vTargetPos.Z == 0.0000000)))
		{
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(5205));
			getInstanceL2Util().HideGFxMiniMapSelectedPin(PIN_YELLOW);
		}
		if((Len(strTargetName) > 0))
		{
			getInstanceL2Util().ShowGFxMiniMapSelectedPin(PIN_YELLOW, vTargetPos, strTargetName, questName);
		}
	}
	return;
}

function OnClickListCtrlRecord(string strID)
{
	local int idx, nInstantZoneID, nFactionID, Index, NpcID;
	local LVDataRecord Record;
	local HuntingZoneUIData huntingZoneData;
	local MinimapRegionIconData IconData;
	local L2FactionUIData FactionData;
	local Vector Loc;
	local bool notToTown;

	if((strID == "Mission_ListCtrl"))
	{
		idx = Mission_ListCtrl.GetSelectedIndex();
		Mission_ListCtrl.GetRec(idx, Record);
	}
	else if((strID == "LocalInfo_ListCtrl"))
	{
		idx = LocalInfo_ListCtrl.GetSelectedIndex();
		LocalInfo_ListCtrl.GetRec(idx, Record);
	}
	else if((strID == "QuestInfo_ListCtrl"))
	{
		ShowQuestTarget();
		return;
	}
	Loc.X = float(Record.LVDataList[0].nReserved1);
	Loc.Y = float(Record.LVDataList[0].nReserved2);
	Loc.Z = float(Record.LVDataList[0].nReserved3);
	ParseInt(Record.LVDataList[0].szReserved, "instantZoneID", nInstantZoneID);
	ParseInt(Record.LVDataList[0].szReserved, "index", Index);
	ParseInt(Record.LVDataList[0].szReserved, "nFactionID", nFactionID);
	ParseInt(Record.LVDataList[0].szReserved, "npcID", NpcID);
	lastSelectListRecord = Record;
	if((NpcID > 0))
	{
		Loc.X = float(Record.LVDataList[0].nReserved1);
		Loc.Y = float(Record.LVDataList[0].nReserved2);
		Loc.Z = float(Record.LVDataList[0].nReserved3);
		notToTown = true;
	}
	else if((Index > 0))
	{
		Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(Index, huntingZoneData);
		GetMinimapRegionIconData(huntingZoneData.nRegionID, IconData);
		if((huntingZoneData.nRegionID > 0))
		{
			Loc.X = float(IconData.nWorldLocX);
			Loc.Y = float(IconData.nWorldLocY);
			Loc.Z = float(IconData.nWorldLocZ);
		}
		else
		{
			Loc = huntingZoneData.nWorldLoc;
		}
	}
	else if((nFactionID > 0))
	{
		GetFactionData(nFactionID, FactionData);
		if(GetMinimapRegionIconData(FactionData.nRegionID, IconData))
		{
			Loc.X = float(IconData.nWorldLocX);
			Loc.Y = float(IconData.nWorldLocY);
			Loc.Z = float(IconData.nWorldLocZ);
		}
	}
	if((isVectorZero(Loc) == false))
	{
		ChaseMiniPosition(Loc, IconData, notToTown);
	}
	if((strID == "Mission_ListCtrl"))
	{
		Mission_ListCtrl.SetFocus();
	}
	else if((strID == "LocalInfo_ListCtrl"))
	{
		LocalInfo_ListCtrl.SetFocus();
	}
	return;
}

function ChaseMiniPosition(Vector Loc, optional MinimapRegionIconData IconData, optional bool notToTown)
{
	local int OffsetX, OffsetY;

	OffsetX = ((IconData.nWidth / 2) + IconData.nIconOffsetX);
	OffsetY = ((IconData.nHeight / 2) + IconData.nIconOffsetY);
	getInstanceL2Util().ShowHighLightMapIcon(Loc, OffsetX, OffsetY, notToTown);
	return;
}

function LVData makeListLvDataText(string textStr, Color pColor, Vector Loc, optional string szReserved)
{
	local LVData lData;

	lData.bUseTextColor = true;
	lData.TextColor = pColor;
	lData.szData = textStr;
	lData.nReserved1 = int(Loc.X);
	lData.nReserved2 = int(Loc.Y);
	lData.nReserved3 = int(Loc.Z);
	lData.szReserved = szReserved;
	return lData;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 40))
	{
		Init();
	}
	else if((Event_ID == 10181))
	{
		UpdateRaidNpc(param);
	}
	else if((Event_ID == 5860))
	{
		handleInzoneWaitingInfo(param);
	}
	return;
}

function handleInzoneWaitingInfo(string param)
{
	local int sizeOfBlockedInzone, blockedInzoneID, i, M, nInstantZoneID, Index, nDataSystemMessage, nShowWindow;
	local string addStr;
	local LVDataRecord Record;

	ParseInt(param, "ShowWindow", nShowWindow);
	ParseInt(param, "sizeOfBlockedInzone", sizeOfBlockedInzone);
	if((nShowWindow <= 0))
	{
		i = 0;
		while((i < sizeOfBlockedInzone))
		{
			ParseInt(param, ("blockedInzoneID_" $ string(i)), blockedInzoneID);
			M = 0;
			while((M < Mission_ListCtrl.GetRecordCount()))
			{
				Mission_ListCtrl.GetRec(M, Record);
				if((Record.LVDataList[0].szReserved != ""))
				{
					ParseInt(Record.LVDataList[0].szReserved, "instantZoneID", nInstantZoneID);
					ParseInt(Record.LVDataList[0].szReserved, "index", Index);
					if((nInstantZoneID == blockedInzoneID))
					{
						addStr = getLevelRangeString(Index);
						Record.LVDataList[0].bUseTextColor = true;
						Record.LVDataList[0].TextColor = getInstanceL2Util().ColorGray;
						Record.LVDataList[0].szData = ((((addStr $ GetInZoneNameWithZoneID(nInstantZoneID)) $ " (") $ GetSystemString(5099)) $ ")");
						Mission_ListCtrl.ModifyRecord(M, Record);
						break;
					}
				}
				M++;
			}
			i++;
		}
		M = 0;
		while((M < Mission_ListCtrl.GetRecordCount()))
		{
			Mission_ListCtrl.GetRec(M, Record);
			if((Record.LVDataList[0].szReserved != ""))
			{
				Index = 0;
				nInstantZoneID = 0;
				ParseInt(Record.LVDataList[0].szReserved, "instantZoneID", nInstantZoneID);
				ParseInt(Record.LVDataList[0].szReserved, "index", Index);
				if((nInstantZoneID > 0))
				{
					if((((nInstantZoneID == 265) || (nInstantZoneID == 266)) && (((nDataSystemMessage == 4432) || (nDataSystemMessage == 4434)) || (nDataSystemMessage == 4435))))
					{
						addStr = getLevelRangeString(Index);
						Record.LVDataList[0].bUseTextColor = true;
						Record.LVDataList[0].TextColor = getInstanceL2Util().ColorGray;
						Record.LVDataList[0].szData = ((((addStr $ GetInZoneNameWithZoneID(nInstantZoneID)) $ " (") $ GetSystemString(5099)) $ ")");
						Mission_ListCtrl.ModifyRecord(M, Record);
					}
				}
			}
			M++;
		}
	}
	return;
}

function UpdateRaidNpc(string param)
{
	local int npcCount, i, NpcID, npcStatus;

	ParseInt(param, "NpcCount", npcCount);
	i = 0;
	while((i < npcCount))
	{
		ParseInt(param, ("NpcId_" $ string(i)), NpcID);
		ParseInt(param, ("NpcStatus_" $ string(i)), npcStatus);
		if((NpcID > 0))
		{
			UpdateRaidListRecord(NpcID, npcStatus);
		}
		i++;
	}
	return;
}

function UpdateRaidListRecord(int NpcID, int npcStatus)
{
	local LVDataRecord Record;
	local int i, currentNpcID, Index;
	local string addStr;
	local Color Color;
	local string fullStr;

	i = 0;
	while((i < Mission_ListCtrl.GetRecordCount()))
	{
		Mission_ListCtrl.GetRec(i, Record);
		if((Record.LVDataList[0].szReserved != ""))
		{
			ParseInt(Record.LVDataList[0].szReserved, "npcID", currentNpcID);
			ParseInt(Record.LVDataList[0].szReserved, "index", Index);
			ParseString(Record.LVDataList[0].szReserved, "addStr", addStr);
			if((currentNpcID == NpcID))
			{
				Record.LVDataList[0].bUseTextColor = true;
				switch(npcStatus)
				{
					case 0:
						Color = getInstanceL2Util().ColorGray;
						fullStr = ((((addStr $ Class'NWindow.UIDATA_NPC'.static.GetNPCName(NpcID)) $ " (") $ GetSystemString(1718)) $ ")");
						break;
					case 1:
						Color = getInstanceL2Util().Gold;
						fullStr = (addStr $ Class'NWindow.UIDATA_NPC'.static.GetNPCName(NpcID));
						break;
					case 2:
						Color = GetColor(255, 102, 102, 255);
						fullStr = ((((addStr $ Class'NWindow.UIDATA_NPC'.static.GetNPCName(NpcID)) $ " (") $ GetSystemString(13157)) $ ")");
						break;
					default:
						break;
				}
				Record.LVDataList[0].TextColor = Color;
				Record.LVDataList[0].szData = fullStr;
				Mission_ListCtrl.ModifyRecord(i, Record);
				break;
			}
		}
		i++;
	}
	return;
}

function string getLevelRangeString(int i)
{
	local string addStr;
	local HuntingZoneUIData huntingZoneData;

	Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(i, huntingZoneData);
	if(((huntingZoneData.nMinLevel != 0) && (huntingZoneData.nMinLevel != 0)))
	{
		addStr = (((((("[" $ GetSystemString(88)) $ ".") $ string(huntingZoneData.nMinLevel)) $ "~") $ string(huntingZoneData.nMaxLevel)) $ "] ");
	}
	if(getInstanceUIData().GetIsLiveServer())
	{
		addStr = (((("[" $ GetSystemString(88)) $ ".") $ string(huntingZoneData.nMinLevel)) $ "] ");
	}
	return addStr;
}

delegate int OnSortCompare(MapListInfo A, MapListInfo B)
{
	if((A.sortingKey > B.sortingKey))
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

delegate int OnSortCompareForRaid(UIConstants.RaidUIData A, UIConstants.RaidUIData B)
{
	if((A.sortingKey > B.sortingKey))
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

function addQuestList()
{
	local UserInfo myInfo;

	GetPlayerInfo(myInfo);
	nClassID = myInfo.nSubClass;
	findRecommandQuest();
	return;
}

function Color questStateColor(int nState)
{
	if((nState == 2))
	{
		return GetColor(182, 182, 182, 255);
	}
	else if((nState == 1))
	{
		return GetColor(255, 221, 102, 255);
	}
	return GetColor(170, 153, 119, 255);
}

function insertListQuestInfo(int QuestID)
{
	local string questName;
	local int QuestType;
	local string levelText, questCompleteStr;
	local int MinLevel, MaxLevel, QuestState;
	local bool bQuestDoing;
	local LVDataRecord Record;

	questName = Class'NWindow.UIDATA_QUEST'.static.GetQuestName(QuestID);
	QuestType = Class'NWindow.UIDATA_QUEST'.static.GetQuestType(QuestID, 1);
	bQuestDoing = Class'NWindow.UIDATA_QUEST'.static.IsDoingQuest(QuestID);
	if(Class'NWindow.UIDATA_QUEST'.static.IsClearedQuest(QuestID))
	{
		if((bQuestDoing && ((QuestType == 0) || (QuestType == 2))))
		{
			QuestState = 0;
		}
		else
		{
			QuestState = 2;
			questCompleteStr = (("[" $ GetSystemString(898)) $ "] ");
		}
	}
	else if(bQuestDoing)
	{
		QuestState = 1;
		questCompleteStr = (("[" $ GetSystemString(829)) $ "] ");
	}
	else
	{
		QuestState = 0;
	}
	MinLevel = Class'NWindow.UIDATA_QUEST'.static.GetMinLevel(QuestID, 1);
	MaxLevel = Class'NWindow.UIDATA_QUEST'.static.GetMaxLevel(QuestID, 1);
	if(((MaxLevel > 0) && (MinLevel > 0)))
	{
		levelText = ((string(MinLevel) $ "~") $ string(MaxLevel));
	}
	else if((MinLevel > 0))
	{
		levelText = ((string(MinLevel) $ " ") $ GetSystemString(859));
	}
	else
	{
		levelText = GetSystemString(866);
	}
	Record.LVDataList.Length = 3;
	Record.LVDataList[0].szData = (questCompleteStr $ questName);
	Record.LVDataList[0].bUseTextColor = true;
	Record.LVDataList[0].TextColor = questStateColor(QuestState);
	Record.LVDataList[1].szData = levelText;
	Record.LVDataList[1].bUseTextColor = true;
	Record.LVDataList[1].TextColor = questStateColor(QuestState);
	Record.LVDataList[2].nTextureWidth = 16;
	Record.LVDataList[2].nTextureHeight = 16;
	switch(QuestType)
	{
		case 0:
		case 2:
			Record.LVDataList[2].szTexture = "L2UI_CH3.QUESTWND.QuestWndInfoIcon_1";
			Record.LVDataList[2].szData = GetSystemString(861);
			break;
		case 1:
		case 3:
			Record.LVDataList[2].szTexture = "L2UI_CH3.QUESTWND.QuestWndInfoIcon_2";
			Record.LVDataList[2].szData = GetSystemString(862);
			break;
		case 4:
		case 5:
			Record.LVDataList[2].szTexture = "L2UI_CH3.QUESTWND.QuestWndInfoIcon_3";
			Record.LVDataList[2].szData = GetSystemString(2788);
			break;
		default:
			break;
	}
	Record.LVDataList[2].nReserved1 = QuestType;
	ParamAdd(Record.szReserved, "QuestName", questName);
	ParamAdd(Record.szReserved, "LevelText", levelText);
	ParamAdd(Record.szReserved, "QuestTypeText", Record.LVDataList[2].szData);
	Record.nReserved1 = INT64(QuestID);
	QuestInfo_ListCtrl.InsertRecord(Record);
	return;
}

function QuestRecommandData getQuestRecommandData(int QuestID, int categoryId, int Priority)
{
	local QuestRecommandData QuestRecommandData;

	QuestRecommandData.QuestID = QuestID;
	QuestRecommandData.Priority = Priority;
	QuestRecommandData.categoryId = categoryId;
	return QuestRecommandData;
}

function findRecommandQuest()
{
	local int QuestType, QuestID, questCategoryID, questPriority, MinLevel;
	local UserInfo UserInfo;
	local bool bClearedQuest;
	local QuestRecommandData questData;
	local array<QuestCategoryArrayData> categoryArr;
	local int i, M;

	GetPlayerInfo(UserInfo);
	QuestInfo_ListCtrl.DeleteAllItem();
	QuestID = Class'NWindow.UIDATA_QUEST'.static.GetFirstID();
	while((-1 != QuestID))
	{
		QuestType = Class'NWindow.UIDATA_QUEST'.static.GetQuestType(QuestID, 1);
		questCategoryID = Class'NWindow.UIDATA_QUEST'.static.GetQuestCategoryID(QuestID, 1);
		questPriority = Class'NWindow.UIDATA_QUEST'.static.GetQuestPriority(QuestID, 1);
		MinLevel = Class'NWindow.UIDATA_QUEST'.static.GetMinLevel(QuestID, 1);
		questData.categoryId = questCategoryID;
		questData.Priority = questPriority;
		questData.QuestID = QuestID;
		if((questPriority == 0))
		{
			QuestID = Class'NWindow.UIDATA_QUEST'.static.GetNextID();
			continue;
		}
		else if((questPriority == -1))
		{
			if((UserInfo.nLevel >= MinLevel))
			{
				questPriority = 100;
			}
			else
			{
				continue;
			}
		}
		else if((questPriority > 0))
		{
			if((MinLevel != 0))
			{
				if(((UserInfo.nLevel >= MinLevel) && (UserInfo.nLevel <= (MinLevel + 5))))
				{
				}
				else
				{
					continue;
				}
			}
		}
		if((Class'NWindow.UIDATA_QUEST'.static.IsAcceptableQuest(QuestID) == false))
		{
			if((Class'NWindow.UIDATA_QUEST'.static.IsDoingQuest(QuestID) == false))
			{
				QuestID = Class'NWindow.UIDATA_QUEST'.static.GetNextID();
				continue;
			}
		}
		bClearedQuest = Class'NWindow.UIDATA_QUEST'.static.IsClearedQuest(QuestID);
		if(bClearedQuest)
		{
			if(((QuestType == 1) || (QuestType == 3)))
			{
				QuestID = Class'NWindow.UIDATA_QUEST'.static.GetNextID();
				continue;
			}
		}
		addCategoryArrQuestID(categoryArr, questData);
		QuestID = Class'NWindow.UIDATA_QUEST'.static.GetNextID();
	}
	i = 0;
	while((i < categoryArr.Length))
	{
		if((categoryArr[i].questRecommandData_Array.Length > 1))
		{
			// categoryArr[i].questRecommandData_Array.Sort(OnSortCompareQuestPriority);   // array.Sort() unsupported by this compiler
		}
		if((categoryArr[i].questRecommandData_Array.Length > 0))
		{
			M = 0;
			while((M < categoryArr[i].questRecommandData_Array.Length))
			{
				if((categoryArr[i].questRecommandData_Array[0].Priority == categoryArr[i].questRecommandData_Array[M].Priority))
				{
					insertListQuestInfo(categoryArr[i].questRecommandData_Array[M].QuestID);
				}
				M++;
			}
		}
		i++;
	}
	return;
}

function addCategoryArrQuestID(out array<QuestCategoryArrayData> categoryArr, QuestRecommandData questData)
{
	local int i;
	local QuestCategoryArrayData newCategoryArrData;

	i = 0;
	while((i < categoryArr.Length))
	{
		if((categoryArr[i].categoryId == questData.categoryId))
		{
			categoryArr[i].questRecommandData_Array[categoryArr[i].questRecommandData_Array.Length] = questData;
			return;
		}
		i++;
	}
	newCategoryArrData.categoryId = questData.categoryId;
	newCategoryArrData.questRecommandData_Array[newCategoryArrData.questRecommandData_Array.Length] = questData;
	categoryArr[categoryArr.Length] = newCategoryArrData;
	return;
}

delegate int OnSortCompareQuestPriority(QuestRecommandData A, QuestRecommandData B)
{
	if((A.Priority < B.Priority))
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

function InitQuestTooltip()
{
	local CustomTooltip toolTipInfo;

	if(getInstanceUIData().GetIsLiveServer())
	{
		toolTipInfo.DrawList.Length = 6;
		toolTipInfo.DrawList[0].eType = DIT_TEXTURE;
		toolTipInfo.DrawList[0].u_nTextureWidth = 16;
		toolTipInfo.DrawList[0].u_nTextureHeight = 16;
		toolTipInfo.DrawList[0].u_strTexture = "L2UI_CH3.QuestWnd.QuestWndInfoIcon_6";
		toolTipInfo.DrawList[1].eType = DIT_TEXT;
		toolTipInfo.DrawList[1].nOffSetX = 2;
		toolTipInfo.DrawList[1].t_bDrawOneLine = true;
		toolTipInfo.DrawList[1].t_strText = GetSystemString(3517);
		toolTipInfo.DrawList[4].eType = DIT_TEXTURE;
		toolTipInfo.DrawList[4].nOffSetY = 2;
		toolTipInfo.DrawList[4].u_nTextureWidth = 16;
		toolTipInfo.DrawList[4].u_nTextureHeight = 16;
		toolTipInfo.DrawList[4].u_strTexture = "L2UI_CH3.QuestWnd.QuestWndInfoIcon_8";
		toolTipInfo.DrawList[4].bLineBreak = true;
		toolTipInfo.DrawList[5].eType = DIT_TEXT;
		toolTipInfo.DrawList[5].nOffSetY = 2;
		toolTipInfo.DrawList[5].nOffSetX = 2;
		toolTipInfo.DrawList[5].t_bDrawOneLine = true;
		toolTipInfo.DrawList[5].t_strText = GetSystemString(3518);
		QuestTooltip.SetTooltipCustomType(toolTipInfo);
	}
	else
	{
		QuestTooltip.HideWindow();
	}
	return;
}

function int GetCastleIDByRegionID(int nRegionID)
{
	local int castleID, regionID;

	castleID = 0;
	while((castleID < 20))
	{
		regionID = GetCastleRegionID(castleID);
		if((regionID != 0))
		{
			if((regionID == nRegionID))
			{
				return castleID;
			}
		}
		castleID++;
	}
	return -1;
}

function int GetRegionIDByHuttingZoneID(int huttingZoneID)
{
	local HuntingZoneUIData huntingZoneData;

	Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(huttingZoneID, huntingZoneData);
	return huntingZoneData.nRegionID;
}

function int GetCastleIDByHuttingZoneID(int huttingZoneID)
{
	return GetCastleIDByRegionID(GetRegionIDByHuttingZoneID(huttingZoneID));
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="MinimapMissionWndB"
}
