class ToDoListWnd extends UICommonAPI;

const TIMER_ID = 99900;
const TIMER_DELAY = 1000;
const TIMER_CLICK = 99901;
const TIMER_DELAYC = 3000;

enum ETabType
{
	Mission0,                       // 0
	Mission1,                       // 1
	Mission2,                       // 2
	MissionLevel,                   // 3
	Max                             // 4
};

struct ToDoListInfo
{
	var LVDataRecord Record;
	var int sort0;
	var int sort1;
};

var WindowHandle Me;
var CheckBoxHandle AllLevelCheckBox;
var WindowHandle ToDoList_Wnd;
var ListCtrlHandle ToDoList_ListCtrl;
var WindowHandle DetailInfo_Wnd;
var TextBoxHandle DetailInfoTitle_Text;
var TextBoxHandle MissionName_Text;
var TextureHandle IconLock_texture;
var TextBoxHandle MissionDateName_Text;
var TextureHandle Divider_Texture;
var TextureHandle DetailInfoMissionGroupbox_texture;
var TextureHandle DetailInfoMissionGroupboxDeco_texture;
var TextureHandle scrollGroupBox_Texture;
var TextureHandle DailyMissionListWndGroupBox_Texture;
var TextureHandle DailyMissionInfoWndGroupBox_Texture;
var ButtonHandle refreshBtn;
var ButtonHandle rewardBtn;
var WindowHandle CompleteWnd_scrollarea;
var TextBoxHandle CompleteDescriotion_Text;
var WindowHandle TimedWnd_scrollarea;
var TextBoxHandle TimedDescriotion_Text;
var WindowHandle RewardInfoWnd_scrollarea;
var ButtonHandle LocalfindBtn_BTN;
var ItemWindowHandle DailyRewardItem;
var StatusBarHandle Completegage_statusbar;
var WindowHandle areaScroll;
var WindowHandle toDoListContainer;
var WindowHandle missionLevelContainer;
var ToDoListTabMissionLevel missionLevelScript;
var TabHandle MissionCategoryTab;
var int selectRewardID;
var int selectServerID;
var string rewardDesc;
var string rewardPeriod;
var Color R;
var Color Y;
var Color B;
var int saveIndex;
var int DayRemainTime;
var int WeekRemainTime;
var int MonthRemainTime;
var int ServerDay;
var array<ToDoListInfo> todoArray0;
var array<ToDoListInfo> todoArray1;
var array<ToDoListInfo> todoArray2;
var array<ToDoListInfo> todoArray3;
var int nResetPeriod;
var array<int> rewards;
var array<ETabType> tabList;
var ETabType currentCategory;
var int rewardRsCount;
//var delegate<OnSortCompare> __OnSortCompare__Delegate;
//var delegate<OnSortCompare1> __OnSortCompare1__Delegate;

function Initialize()
{
	Me = GetWindowHandle("ToDoListWnd");
	AllLevelCheckBox = GetCheckBoxHandle("ToDoListWnd.AllLevelCheckBox");
	missionLevelScript = ToDoListTabMissionLevel(GetScript((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ToDoListTabMissionLevel")));
	toDoListContainer = GetWindowHandle("ToDoListWnd.ToDoListContainer");
	ToDoList_Wnd = GetWindowHandle("ToDoListWnd.ToDoListContainer.ToDoList_Wnd");
	ToDoList_ListCtrl = GetListCtrlHandle("ToDoListWnd.ToDoListContainer.ToDoList_Wnd.ToDoList_ListCtrl");
	DetailInfo_Wnd = GetWindowHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd");
	DetailInfoTitle_Text = GetTextBoxHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.DetailInfoTitle_Text");
	MissionName_Text = GetTextBoxHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.MissionName_Text");
	IconLock_texture = GetTextureHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.IconLock_texture");
	MissionDateName_Text = GetTextBoxHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.MissionDateName_Text");
	Divider_Texture = GetTextureHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.divider_texture");
	DetailInfoMissionGroupbox_texture = GetTextureHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.DetailInfoMissionGroupbox_texture");
	DetailInfoMissionGroupboxDeco_texture = GetTextureHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.DetailInfoMissionGroupboxDeco_texture");
	scrollGroupBox_Texture = GetTextureHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.scrollGroupBox_Texture");
	DailyMissionListWndGroupBox_Texture = GetTextureHandle("ToDoListWnd.ToDoListContainer.DailyMissionListWndGroupBox_Texture");
	DailyMissionInfoWndGroupBox_Texture = GetTextureHandle("ToDoListWnd.ToDoListContainer.DailyMissionInfoWndGroupBox_Texture");
	refreshBtn = GetButtonHandle("ToDoListWnd.RefreshBtn");
	areaScroll = GetWindowHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.DetailInfo_ScrollArea");
	RewardInfoWnd_scrollarea = GetWindowHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.DetailInfo_ScrollArea.RewardInfoWnd_scrollarea");
	rewardBtn = GetButtonHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.DetailInfo_ScrollArea.RewardInfoWnd_scrollarea.RewardBtn");
	DailyRewardItem = GetItemWindowHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.DetailInfo_ScrollArea.RewardInfoWnd_scrollarea.DailyRewardItem");
	CompleteDescriotion_Text = GetTextBoxHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.DetailInfo_ScrollArea.CompleteWnd_scrollarea.CompleteDescriotion_Text");
	CompleteWnd_scrollarea = GetWindowHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.DetailInfo_ScrollArea.CompleteWnd_scrollarea");
	LocalfindBtn_BTN = GetButtonHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.DetailInfo_ScrollArea.CompleteWnd_scrollarea.LocalfindBtn_BTN");
	Completegage_statusbar = GetStatusBarHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.DetailInfo_ScrollArea.CompleteWnd_scrollarea.Completegage_statusbar");
	TimedDescriotion_Text = GetTextBoxHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.DetailInfo_ScrollArea.TimedWnd_scrollarea.TimedDescriotion_Text");
	TimedWnd_scrollarea = GetWindowHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.DetailInfo_ScrollArea.TimedWnd_scrollarea");
	MissionCategoryTab = GetTabHandle("TodoListWnd.ToDoList_Wnd.ToDoListTab");
	R.R = 255;
	R.G = 153;
	R.B = 153;
	Y.R = 255;
	Y.G = 255;
	Y.B = 187;
	B.R = 136;
	B.G = 255;
	B.B = 255;
	saveIndex = 0;
	rewards.Length = 0;
	InitTabGorup();
	return;
}

function InitTabGorup()
{
	tabList.Length = 0;
	if(IsEnableMissionLevel())
	{
		tabList[tabList.Length] = MissionLevel;
		MissionCategoryTab.SetButtonName(0, GetSystemString(14038));
		MissionCategoryTab.SetButtonName(1, GetSystemString(3579));
		MissionCategoryTab.SetButtonName(2, GetSystemString(14037));
		MissionCategoryTab.SetButtonName(3, GetSystemString(1792));
	}
	else
	{
		MissionCategoryTab.RemoveTabControl((4 - 1));
		MissionCategoryTab.SetButtonName(0, GetSystemString(3579));
		MissionCategoryTab.SetButtonName(1, GetSystemString(14037));
		MissionCategoryTab.SetButtonName(2, GetSystemString(1792));
	}
	tabList[tabList.Length] = Mission0;
	tabList[tabList.Length] = Mission1;
	tabList[tabList.Length] = Mission2;
	currentCategory = ETabType(tabList[0]);
	return;
}

function bool IsEnableMissionLevel()
{
	return true;
}

function _SetMissionLevelRewardNum(int rewardNum)
{
	if(IsEnableMissionLevel())
	{
		rewards[3] = rewardNum;
		SetTabCompletedNum(0, rewardNum);
	}
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(20160);
	RegisterEvent(20170);
	RegisterEvent(20171);
	RegisterEvent(20172);
	RegisterEvent(20173);
	RegisterEvent(20174);
	RegisterEvent(20175);
	return;
}

event OnShow()
{
	loadOptionToDo();
	refreshList();
	if(IsEnableMissionLevel())
	{
		rewardRsCount = -1;
		missionLevelScript.OnParentShow();
	}
	Me.SetFocus();
	return;
}

event OnHide()
{
	getInstanceL2Util().DelGFxMiniMapArea(Me.GetWindowName());
	if(IsEnableMissionLevel())
	{
		missionLevelScript.OnParentHide();
	}
	return;
}

event OnDefaultPosition()
{
	return;
}

event OnLoad()
{
	RegisterState(getCurrentWindowName(string(self)), "GamingState");
	RegisterState(getCurrentWindowName(string(self)), "ARENAGAMINGSTATE");
	SetClosingOnESC();
	Initialize();
	return;
}

event OnEvent(int a_EventID, string param)
{
	switch(a_EventID)
	{
		case 20160:
			openProcess(param);
			break;
		case 20170:
			OneDayRewardListStart(param);
			break;
		case 20171:
			OneDayRewardList(param);
			break;
		case 20172:
			OneDayRewardListEnd(param);
			break;
		case 20173:
			DailyRewardItem.Clear();
			break;
		case 20174:
			OneDayRewardItemList(param);
			break;
		case 20175:
			break;
		default:
			break;
	}
	return;
}

event OnClickCheckBox(string strID)
{
	switch(strID)
	{
		case "AllLevelCheckBox":
			SetOptionToDo();
			refreshList();
			break;
		default:
			break;
	}
	return;
}

event OnClickButton(string StringID)
{
	local int clickedTabIndex;

	switch(StringID)
	{
		case "RefreshBtn":
			Me.SetTimer(99901, 3000);
			refreshBtn.DisableWindow();
			if(IsEnableMissionLevel())
			{
				if((int(currentCategory) == 3))
				{
					missionLevelScript._RequestRewardList();
					rewardRsCount = -1;
				}
				refreshList();
			}
			else
			{
				refreshList();
			}
			break;
		case "Btn":
			Me.HideWindow();
			break;
		case "RewardBtn":
			RequestOneDayRewardReceive(selectServerID);
			break;
		case "LocalfindBtn_BTN":
			LocalfindBtnClick();
			break;
		case "ToDoListTab0":
		case "ToDoListTab1":
		case "ToDoListTab2":
		case "ToDoListTab3":
		case "ToDoListTab4":
			clickedTabIndex = int(Right(StringID, 1));
			ToDoList_ListCtrl.DeleteAllItem();
			if((clickedTabIndex < tabList.Length))
			{
				currentCategory = ETabType(tabList[clickedTabIndex]);
			}
			OneDayRewardListEnd("");
			break;
		default:
			break;
	}
	return;
}

event OnClickListCtrlRecord(string ListCtrlID)
{
	local int rewardID, ServerID, currentCount, maxCount;
	local LVDataRecord Record;
	local string param, rewardBool;
	local int ResetPeriod, ShowQuestRange;
	local string bLock, CheckType, CheckTypeStr;

	saveIndex = ToDoList_ListCtrl.GetSelectedIndex();
	if((saveIndex >= 0))
	{
		ToDoList_ListCtrl.GetSelectedRec(Record);
		param = Record.szReserved;
		ParseInt(param, "ResetPeriod", ResetPeriod);
		ParseInt(param, "rewardID", rewardID);
		ParseInt(param, "serverID", ServerID);
		ParseInt(param, "ShowQuestRange", ShowQuestRange);
		ParseInt(param, "CurrentCount", currentCount);
		ParseInt(param, "MaxCount", maxCount);
		ParseString(param, "rewardBool", rewardBool);
		ParseString(param, "Block", bLock);
		ParseString(param, "CheckType", CheckType);
		selectRewardID = rewardID;
		selectServerID = ServerID;
		if((int(CheckType) == 0))
		{
			CheckTypeStr = (" - " @ GetSystemString(2321));
		}
		else if((int(CheckType) == 1))
		{
			CheckTypeStr = (" - " @ GetSystemString(13248));
		}
		else if((int(CheckType) == 2))
		{
			CheckTypeStr = (" - " @ GetSystemString(14590));
		}
		MissionName_Text.SetText(Record.LVDataList[1].szData);
		MissionDateName_Text.SetTextColor(SetTextColor(ResetPeriod));
		switch(ResetPeriod)
		{
			case 1:
				MissionDateName_Text.SetText((GetSystemString(3583) @ CheckTypeStr));
				break;
			case 2:
				MissionDateName_Text.SetText((GetSystemString(3584) @ CheckTypeStr));
				break;
			case 3:
				MissionDateName_Text.SetText((GetSystemString(3585) @ CheckTypeStr));
				break;
			case 4:
				MissionDateName_Text.SetText((GetSystemString(3582) @ CheckTypeStr));
				break;
			default:
				break;
		}
		RequestOneDayRewardItemList(rewardID);
		rewardDesc = RequestOneDayRewardDesc(rewardID);
		if((rewardBool == "t"))
		{
			rewardBtn.SetButtonName(2279);
			rewardBtn.EnableWindow();
		}
		else
		{
			rewardBtn.SetButtonName(3604);
			rewardBtn.DisableWindow();
		}
		if((ShowQuestRange == 0))
		{
			LocalfindBtn_BTN.DisableWindow();
			LocalfindBtn_BTN.HideWindow();
		}
		else
		{
			LocalfindBtn_BTN.ShowWindow();
			LocalfindBtn_BTN.EnableWindow();
		}
		if((bLock == "True"))
		{
			IconLock_texture.ShowWindow();
		}
		else
		{
			IconLock_texture.HideWindow();
		}
		Completegage_statusbar.SetPoint(INT64(currentCount), INT64(maxCount));
		rewardInfo();
	}
	return;
}

event OnTimer(int TimerID)
{
	if((TimerID == 99900))
	{
		DayRemainTime--;
		WeekRemainTime--;
		MonthRemainTime--;
		TimedDescriotion_Text.SetText(timeToString());
	}
	else if((TimerID == 99901))
	{
		refreshBtn.EnableWindow();
		Me.KillTimer(99901);
	}
	return;
}

function OneDayRewardListStart(string param)
{
	todoArray0.Remove(0, todoArray0.Length);
	todoArray1.Remove(0, todoArray1.Length);
	todoArray2.Remove(0, todoArray2.Length);
	todoArray3.Remove(0, todoArray3.Length);
	ParseInt(param, "DayRemainTime", DayRemainTime);
	ParseInt(param, "WeekRemainTime", WeekRemainTime);
	ParseInt(param, "MonthRemainTime", MonthRemainTime);
	ParseInt(param, "ServerDay", ServerDay);
	rewards[0] = 0;
	rewards[1] = 0;
	rewards[2] = 0;
	ToDoList_ListCtrl.DeleteAllItem();
	Me.KillTimer(99900);
	Me.SetTimer(99900, 1000);
	rewardRsCount++;
	return;
}

function OneDayRewardList(string param)
{
	local int CanConditionDay, CanConditionDayCount, CanConditionLvMin, CanConditionLvMax, rewardID, ServerID, rewardStatus, currentCount, maxCount, NewEvent, ShowQuestRange, ResetPeriod;
	local string rewardName;
	local int Category, CheckType, ServerRange, i;
	local UserInfo PlayerInfo;
	local int nSort;
	local LVDataRecord Record;
	local bool bLock;
	local string rewardBool;
	local int nWidth, nHeight;
	local array<string> Icons;

	bLock = false;
	nSort = 0;
	rewardBool = "f";
	GetPlayerInfo(PlayerInfo);
	ParseInt(param, "CanConditionDayCount", CanConditionDayCount);
	ParseInt(param, "rewardID", rewardID);
	ParseInt(param, "serverID", ServerID);
	ParseInt(param, "rewardStatus", rewardStatus);
	ParseInt(param, "NewEvent", NewEvent);
	ParseInt(param, "CurrentCount", currentCount);
	ParseInt(param, "MaxCount", maxCount);
	ParseInt(param, "ResetPeriod", ResetPeriod);
	ParseInt(param, "CanConditionLvMin", CanConditionLvMin);
	ParseInt(param, "CanConditionLvMax", CanConditionLvMax);
	ParseInt(param, "ShowQuestRange", ShowQuestRange);
	ParseString(param, "rewardName", rewardName);
	ParseInt(param, "Category", Category);
	ParseInt(param, "CheckType", CheckType);
	ParseInt(param, "ServerRange", ServerRange);
	if((CanConditionLvMax == 0))
	{
		CanConditionLvMax = 999;
	}
	if(((PlayerInfo.nLevel < CanConditionLvMin) || (PlayerInfo.nLevel > CanConditionLvMax)))
	{
		bLock = true;
	}
	if((CanConditionDayCount != 0))
	{
		i = 0;
		while((i < CanConditionDayCount))
		{
			ParseInt(param, ("CanConditionDay" $ string(i)), CanConditionDay);
			if((ServerDay == CanConditionDay))
			{
				bLock = false;
				break;
				i++;
				continue;
			}
			bLock = true;
			i++;
		}
	}
	Record.LVDataList.Length = 3;
	Record.LVDataList[0].bUseTextColor = true;
	Record.LVDataList[1].bUseTextColor = true;
	Record.LVDataList[2].bUseTextColor = true;
	Record.LVDataList[0].TextColor = SetTextColor(ResetPeriod);
	switch(ResetPeriod)
	{
		case 1:
			Record.LVDataList[0].szData = GetSystemString(3579);
			break;
		case 2:
			Record.LVDataList[0].szData = GetSystemString(3580);
			break;
		case 3:
			Record.LVDataList[0].szData = GetSystemString(3581);
			break;
		case 4:
			Record.LVDataList[0].szData = GetSystemString(1792);
			break;
		default:
			break;
	}
	Record.LVDataList[1].TextColor = getInstanceL2Util().BrightWhite;
	switch(rewardStatus)
	{
		case 1:
			Record.LVDataList[2].TextColor = getInstanceL2Util().Yellow;
			Record.LVDataList[2].szData = GetSystemString(3586);
			rewardBool = "t";
			nSort = 1;
			rewards[Category]++;
			break;
		case 2:
			if(bLock)
			{
				nSort = 3;
				Record.LVDataList[2].hasIcon = true;
				Record.LVDataList[2].nTextureWidth = 14;
				Record.LVDataList[2].nTextureHeight = 14;
				Record.LVDataList[2].nTextureU = 14;
				Record.LVDataList[2].nTextureV = 14;
				Record.LVDataList[2].szTexture = "L2UI_CT1.DailyMissionWnd_IconLock";
				Record.LVDataList[2].IconPosX = 46;
				Record.LVDataList[2].FirstLineOffsetX = 5;
				Record.LVDataList[2].TextColor = R;
				Record.LVDataList[2].szData = GetSystemString(3587);
			}
			else
			{
				nSort = 2;
				Record.bUseStatusBar = true;
				Record.nStatusBarIndex = 2;
				Record.LVDataList[Record.nStatusBarIndex].nStatusBarCurrentCount = currentCount;
				Record.LVDataList[Record.nStatusBarIndex].nStatusBarMaxCount = maxCount;
				Record.strStatusBarForeLeftTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Left3";
				Record.strStatusBarForeCenterTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Center3";
				Record.strStatusBarForeRightTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Right3";
				Record.strStatusBarBackLeftTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_bg_Left3";
				Record.strStatusBarBackCenterTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_bg_Center3";
				Record.strStatusBarBackRightTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_bg_Right3";
				Record.nStatusBarWidth = 110;
				Record.nStatusBarHeight = 12;
			}
			break;
		case 3:
			nSort = 4;
			Record.LVDataList[1].TextColor = getInstanceL2Util().Gray;
			Record.LVDataList[2].TextColor = getInstanceL2Util().Gray;
			Record.LVDataList[2].szData = GetSystemString(898);
			break;
		default:
			break;
	}
	if((NewEvent == 1))
	{
		Icons[Icons.Length] = "L2UI_CT1.DailyMissionWnd_IconNewt";
	}
	else if((NewEvent == 2))
	{
		Icons[Icons.Length] = "L2UI_CT1.DailyMissionWnd_IconEvent";
	}
	if((ServerRange == 1))
	{
		Icons[Icons.Length] = "L2UI_EPIC.Icon.IconWorld";
	}
	if((Icons.Length > 0))
	{
		GetTextSizeDefault(rewardName, nWidth, nHeight);
		Record.LVDataList[1].arrTexture.Length = Icons.Length;
		i = 0;
		while((i < Icons.Length))
		{
			lvTextureAdd(Record.LVDataList[1].arrTexture[i], Icons[i], ((nWidth + 12) + (39 * i)), 0, 41, 19);
			i++;
		}
	}
	Record.LVDataList[1].szData = rewardName;
	Record.LVDataList[1].textAlignment = TA_Left;
	Record.LVDataList[0].textAlignment = TA_Center;
	Record.LVDataList[2].textAlignment = TA_Center;
	ParamAdd(param, "rewardBool", rewardBool);
	ParamAdd(param, "Block", string(bLock));
	ParamAdd(param, "CheckType", string(CheckType));
	Record.szReserved = param;
	Record.nReserved1 = INT64(rewardID);
	Record.nReserved2 = INT64(ServerID);
	SetToDolistByCategroy(Category, Record, nSort, NewEvent);
	return;
}

function OneDayRewardListEnd(string param)
{
	local int i;
	local array<ToDoListInfo> tmpToDoListInfo;

	if((int(currentCategory) == 3))
	{
		if((IsEnableMissionLevel() && (param == "")))
		{
			if((rewardRsCount > 0))
			{
				RequestMissionLevelRewardList();
			}
		}
		ShowMissionLevelPanel(true);
	}
	else
	{
		ShowMissionLevelPanel(false);
	}
	tmpToDoListInfo = GetCurrentToDoListByCategroy(int(currentCategory));
	// tmpToDoListInfo.Sort(OnSortCompare1);   // array.Sort() unsupported by this compiler
	// tmpToDoListInfo.Sort(OnSortCompare);   // array.Sort() unsupported by this compiler
	i = 0;
	while((i < tmpToDoListInfo.Length))
	{
		if(AllLevelCheckBox.IsChecked())
		{
			ToDoList_ListCtrl.InsertRecord(tmpToDoListInfo[i].Record);
			i++;
			continue;
		}
		if((tmpToDoListInfo[i].sort0 != 3))
		{
			ToDoList_ListCtrl.InsertRecord(tmpToDoListInfo[i].Record);
		}
		i++;
	}
	SetSelectListCtrl();
	OnClickListCtrlRecord("DailyRewardListCtrl");
	i = 0;
	while((i < tabList.Length))
	{
		if((tabList.Length > i))
		{
			if((rewards.Length > int(tabList[i])))
			{
				SetTabCompletedNum(i, rewards[int(tabList[i])]);
				i++;
				continue;
			}
			SetTabCompletedNum(i, 0);
		}
		i++;
	}
	return;
}

function SetSelectListCtrl()
{
	if((ToDoList_ListCtrl.GetRecordCount() < 1))
	{
		ToDoList_ListCtrl.SetSelectedIndex(saveIndex, false);
		saveIndex = -1;
		setResultEmpty();
	}
	else if((saveIndex < ToDoList_ListCtrl.GetRecordCount()))
	{
		if((saveIndex < 0))
		{
			saveIndex = 0;
		}
		ToDoList_ListCtrl.SetSelectedIndex(saveIndex, true);
	}
	else
	{
		saveIndex = 0;
		ToDoList_ListCtrl.SetSelectedIndex(saveIndex, true);
	}
	return;
}

function int selectIndexPeriod()
{
	local LVDataRecord Record;
	local string param;

	ToDoList_ListCtrl.GetSelectedRec(Record);
	if((Record.szReserved != ""))
	{
		param = Record.szReserved;
		ParseInt(param, "ResetPeriod", nResetPeriod);
	}
	return nResetPeriod;
}

function refreshList()
{
	RequestTodoListOneDayReward();
	return;
}

function RequestMissionLevelRewardList()
{
	if(IsEnableMissionLevel())
	{
		rewardRsCount = 0;
		missionLevelScript._RequestRewardList();
	}
	return;
}

function LocalfindBtnClick()
{
	local LVDataRecord Record;
	local Vector XYZ;
	local float X, Y, Z;
	local string param;
	local Color areaColor;

	ToDoList_ListCtrl.GetRec(saveIndex, Record);
	param = Record.szReserved;
	ParseFloat(param, "TargetX", X);
	ParseFloat(param, "TargetY", Y);
	ParseFloat(param, "TargetZ", Z);
	XYZ.X = float(int(X));
	XYZ.Y = float(int(Y));
	XYZ.Z = float(int(Z));
	areaColor.R = 129;
	areaColor.G = 243;
	areaColor.B = 254;
	areaColor.A = 90;
	getInstanceL2Util().AddGFxMiniMapArea(Me.GetWindowName(), XYZ, areaColor, 2);
	getInstanceL2Util().ShowHighLightMapIcon(XYZ, 0, 0);
	return;
}

function rewardInfo()
{
	local int resultHeight;

	selectIndexPeriod();
	resultHeight = setTextFieldHight(TimedDescriotion_Text, timeToString());
	TimedWnd_scrollarea.SetWindowSize(302, (resultHeight + 30));
	resultHeight = setTextFieldHight(CompleteDescriotion_Text, rewardDesc);
	CompleteWnd_scrollarea.SetWindowSize(302, (resultHeight + 53));
	areaScroll.SetScrollPosition(0);
	areaScroll.SetScrollHeight(((RewardInfoWnd_scrollarea.GetRect().nHeight + TimedWnd_scrollarea.GetRect().nHeight) + CompleteWnd_scrollarea.GetRect().nHeight));
	return;
}

function OneDayRewardItemList(string param)
{
	local ItemInfo ItemInfo;
	local ItemID ItemID;
	local int ItemCount;

	ParseItemID(param, ItemID);
	ParseInt(param, "itemCount", ItemCount);
	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(ItemID, ItemInfo);
	ItemInfo.ItemNum = INT64(ItemCount);
	DailyRewardItem.AddItem(ItemInfo);
	return;
}

function setResultEmpty()
{
	MissionName_Text.SetText("");
	MissionDateName_Text.SetText("");
	DailyRewardItem.Clear();
	rewardBtn.SetButtonName(3604);
	rewardBtn.DisableWindow();
	LocalfindBtn_BTN.DisableWindow();
	LocalfindBtn_BTN.HideWindow();
	IconLock_texture.HideWindow();
	rewardDesc = "";
	Completegage_statusbar.SetPoint(INT64(0), INT64(0));
	Me.KillTimer(99900);
	rewardInfo();
	TimedDescriotion_Text.SetText("");
	return;
}

function SetOptionToDo()
{
	local bool bChecked;

	bChecked = AllLevelCheckBox.IsChecked();
	SetOptionBool("UI", "TodoList", bChecked);
	return;
}

function loadOptionToDo()
{
	local bool bChecked;

	bChecked = GetOptionBool("UI", "TodoList");
	AllLevelCheckBox.SetCheck(bChecked);
	return;
}

function array<ToDoListInfo> GetCurrentToDoListByCategroy(int categroy)
{
	switch(categroy)
	{
		case 0:
			return todoArray0;
			break;
		case 1:
			return todoArray1;
			break;
		case 2:
			return todoArray2;
			break;
		case 3:
			return todoArray3;
			break;
		default:
			break;
	}
}

function SetToDolistByCategroy(int categroy, LVDataRecord Record, int nSort, int NewEvent)
{
	local ToDoListInfo tmpToDoListInfo;

	tmpToDoListInfo.Record = Record;
	tmpToDoListInfo.sort0 = nSort;
	tmpToDoListInfo.sort1 = NewEvent;
	switch(categroy)
	{
		case 0:
			todoArray0[todoArray0.Length] = tmpToDoListInfo;
			break;
		case 1:
			todoArray1[todoArray1.Length] = tmpToDoListInfo;
			break;
		case 2:
			todoArray2[todoArray2.Length] = tmpToDoListInfo;
			break;
		case 3:
			todoArray3[todoArray3.Length] = tmpToDoListInfo;
			break;
		default:
			break;
	}
	return;
}

function int setTextFieldHight(TextBoxHandle txtWnd, string Text)
{
	local int nWidth, nHeight, DEFAULTHEIGHT, i, descHeight;
	local string sNextStringWithWidth;

	txtWnd.SetText(Text);
	GetTextSizeDefault(Text, nWidth, DEFAULTHEIGHT);
	CompleteDescriotion_Text.GetWindowSize(nWidth, nHeight);
	i = 2;
	sNextStringWithWidth = DivideStringWithWidth(Text, nWidth);
	while((sNextStringWithWidth != ""))
	{
		sNextStringWithWidth = NextStringWithWidth(nWidth);
		i++;
	}
	descHeight = (i * (DEFAULTHEIGHT + 1));
	txtWnd.SetWindowSize(nWidth, descHeight);
	return descHeight;
}

function string timeToString()
{
	local string Str;

	switch(selectIndexPeriod())
	{
		case 1:
			Str = getTimeStringBySec(DayRemainTime);
			break;
		case 2:
			Str = getTimeStringBySec(WeekRemainTime);
			break;
		case 3:
			Str = getTimeStringBySec(MonthRemainTime);
			break;
		case 4:
			Str = GetSystemString(1792);
			break;
		default:
			break;
	}
	return Str;
}

function string getTimeStringBySec(int Sec)
{
	local int timeTemp, timeTemp0, timeTemp1;
	local string returnStr;

	returnStr = "";
	timeTemp = (((Sec / 60) / 60) / 24);
	timeTemp0 = ((Sec / 60) / 60);
	timeTemp1 = (Sec / 60);
	if((timeTemp > 0))
	{
		returnStr = MakeFullSystemMsg(GetSystemMessage(4466), string(timeTemp), string(int((float(((Sec / 60) / 60)) % 24.0000000))), string(int((float((Sec / 60)) % 60.0000000))));
	}
	else if((timeTemp0 > 0))
	{
		returnStr = MakeFullSystemMsg(GetSystemMessage(3304), string(timeTemp0), string(int((float((Sec / 60)) % 60.0000000))));
	}
	else if((timeTemp1 > 0))
	{
		returnStr = MakeFullSystemMsg(GetSystemMessage(3390), string(timeTemp1));
	}
	else
	{
		returnStr = MakeFullSystemMsg(GetSystemMessage(4360), string(1));
	}
	return returnStr;
}

function Color SetTextColor(int N)
{
	local Color returnColor;

	switch(N)
	{
		case 1:
			returnColor = Y;
			break;
		case 2:
			returnColor = R;
			break;
		case 3:
			returnColor = B;
			break;
		case 4:
			returnColor = Y;
			break;
		default:
			break;
	}
	return returnColor;
}

delegate int OnSortCompare(ToDoListInfo A, ToDoListInfo B)
{
	if((A.sort0 > B.sort0))
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

delegate int OnSortCompare1(ToDoListInfo A, ToDoListInfo B)
{
	if((A.sort1 < B.sort1))
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

function SetTabCompletedNum(int tabindex, int completedNum)
{
	local string TextureName;

	if((completedNum > 9))
	{
		TextureName = ("L2UI_CT1.Tab.TabNoticeCount_09" $ "Plus");
	}
	else if((completedNum != 0))
	{
		TextureName = ("L2UI_CT1.Tab.TabNoticeCount_0" $ string(completedNum));
	}
	MissionCategoryTab.SetButtonOffsetTex(tabindex, TextureName, 180, -7);
	return;
}

function openProcess(string a_Param)
{
	local UserInfo myInfo;
	local int nforceOpen;

	if(!GetPlayerInfo(myInfo))
	{
		return;
	}
	ParseInt(a_Param, "forceOpen", nforceOpen);
	if(((myInfo.nLevel > 1) || (nforceOpen == 1)))
	{
		getInstanceL2Util().toggleWindow("ToDoListWnd", true);
	}
	return;
}

function ToggleByClanMission()
{
	if(Me.IsShowWindow())
	{
		Me.HideWindow();
		return;
	}
	Me.ShowWindow();
	return;
}

function ShowMissionLevelPanel(bool isShow)
{
	if((isShow == true))
	{
		missionLevelScript.m_hOwnerWnd.ShowWindow();
		missionLevelScript.m_hOwnerWnd.SetFocus();
		toDoListContainer.HideWindow();
		AllLevelCheckBox.HideWindow();
	}
	else
	{
		missionLevelScript.m_hOwnerWnd.HideWindow();
		missionLevelScript.CheckAndHideLevelJumpDialog();
		toDoListContainer.ShowWindow();
		AllLevelCheckBox.ShowWindow();
	}
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}
