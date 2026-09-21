class ToDoListClanWnd extends UICommonAPI;

const TIMER_CLICK = 99901;
const TIMER_DELAYC = 3000;
const STATE_COMPLETE = 0;
const STATE_BLOCK = 1;
const STATE_PROCESS = 2;
const STATE_REWARD = 3;
const TAB_NORMAL = 1;
const TAB_DEEPENING = 2;
const TAB_ACHIEVEMENTS = 3;
const TAB_EVENT = 4;

struct ToDoListClanData
{
	var int MissionID;
	var int progressCount;
	var int curState;
	var int Category;
	var bool isEventPeroid;
	var int nRepeatSortValue;
	var int nTypeSortValue;
};

var WindowHandle Me;
var CheckBoxHandle AllLevelCheckBox;
var ListCtrlHandle ToDoList_ListCtrl;
var TextBoxHandle MissionName_Text;
var TextureHandle IconLock_texture;
var TextBoxHandle MissionDateName_Text;
var ButtonHandle refreshBtn;
var ButtonHandle EssentialBtn;
var ButtonHandle rewardBtn;
var WindowHandle CompleteWnd_scrollarea;
var TextBoxHandle CompleteDescriotion_Text;
var WindowHandle ConditionWnd_scrollarea;
var TextBoxHandle ConditionDescriotion_Text;
var WindowHandle RewardInfoWnd_scrollarea;
var ItemWindowHandle DailyRewardItem;
var StatusBarHandle Completegage_statusbar;
var WindowHandle areaScroll;
var TextBoxHandle ClanFameInput_Text;
var TextBoxHandle PrivateFameInput_Text;
var TextBoxHandle WeekMissionNum_Text;
var TextBoxHandle WeekMission_Text;
var ButtonHandle HelpButton;
var TabHandle ToDoListClan_TabCtrl;
var WindowHandle toDoDisable_Wnd;
var WindowHandle todoComplete_Wnd;
var int curRewardCount;
var int maxRewardCount;
var int lastClickIndex;
var int currentTabIndex;
var array<ToDoListClanData> toDoClanArray;
var int serverStartTime;
var int serverTimeZone;
var int numOfEventList;
var int numOfRewardList;
var int clientStartSec;
var array<int> rewards;
var int typeCount;

function Initialize()
{
	Me = GetWindowHandle("ToDoListClanWnd");
	AllLevelCheckBox = GetCheckBoxHandle("ToDoListClanWnd.AllLevelCheckBox");
	ToDoList_ListCtrl = GetListCtrlHandle("ToDoListClanWnd.ToDoList_Wnd.ToDoList_ListCtrl");
	MissionName_Text = GetTextBoxHandle("ToDoListClanWnd.DetailInfo_Wnd.MissionName_Text");
	IconLock_texture = GetTextureHandle("ToDoListClanWnd.DetailInfo_Wnd.IconLock_texture");
	MissionDateName_Text = GetTextBoxHandle("ToDoListClanWnd.DetailInfo_Wnd.MissionDateName_Text");
	refreshBtn = GetButtonHandle("ToDoListClanWnd.RefreshBtn");
	EssentialBtn = GetButtonHandle("ToDoListClanWnd.EssentialBtn");
	areaScroll = GetWindowHandle("ToDoListClanWnd.DetailInfo_Wnd.DetailInfo_ScrollArea");
	RewardInfoWnd_scrollarea = GetWindowHandle("ToDoListClanWnd.DetailInfo_Wnd.DetailInfo_ScrollArea.RewardInfoWnd_scrollarea");
	rewardBtn = GetButtonHandle("ToDoListClanWnd.DetailInfo_Wnd.DetailInfo_ScrollArea.RewardInfoWnd_scrollarea.RewardBtn");
	DailyRewardItem = GetItemWindowHandle("ToDoListClanWnd.DetailInfo_Wnd.DetailInfo_ScrollArea.RewardInfoWnd_scrollarea.DailyRewardItem");
	CompleteDescriotion_Text = GetTextBoxHandle("ToDoListClanWnd.DetailInfo_Wnd.DetailInfo_ScrollArea.CompleteWnd_scrollarea.CompleteDescriotion_Text");
	CompleteWnd_scrollarea = GetWindowHandle("ToDoListClanWnd.DetailInfo_Wnd.DetailInfo_ScrollArea.CompleteWnd_scrollarea");
	Completegage_statusbar = GetStatusBarHandle("ToDoListClanWnd.DetailInfo_Wnd.DetailInfo_ScrollArea.CompleteWnd_scrollarea.Completegage_statusbar");
	ConditionDescriotion_Text = GetTextBoxHandle("ToDoListClanWnd.DetailInfo_Wnd.DetailInfo_ScrollArea.ConditionWnd_scrollarea.ConditionDescriotion_Text");
	ConditionWnd_scrollarea = GetWindowHandle("ToDoListClanWnd.DetailInfo_Wnd.DetailInfo_ScrollArea.ConditionWnd_scrollarea");
	WeekMissionNum_Text = GetTextBoxHandle("ToDoListClanWnd.WeekMissionNum_Text");
	WeekMission_Text = GetTextBoxHandle("ToDoListClanWnd.WeekMission_Text");
	HelpButton = GetButtonHandle("ToDoListClanWnd.HelpButton");
	ClanFameInput_Text = GetTextBoxHandle("ToDoListClanWnd.DetailInfo_Wnd.RewardInfoWnd_scrollarea.ClanFameInput_Text");
	PrivateFameInput_Text = GetTextBoxHandle("ToDoListClanWnd.DetailInfo_Wnd.RewardInfoWnd_scrollarea.PrivateFameInput_Text");
	ToDoListClan_TabCtrl = GetTabHandle("ToDoListClanWnd.ToDoListClan_TabCtrl");
	toDoDisable_Wnd = GetWindowHandle("ToDoListClanWnd.TodoDisable_Wnd");
	todoComplete_Wnd = GetWindowHandle("ToDoListClanWnd.TodoComplete_Wnd");
	numOfEventList = 0;
	rewards.Length = 4;
	ClearRewardList();
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(10440);
	RegisterEvent(10441);
	RegisterEvent(40);
	RegisterEvent(10230);
	return;
}

event OnLoad()
{
	Initialize();
	setResultEmpty();
	RegisterState(getCurrentWindowName(string(self)), "GamingState");
	SetClosingOnESC();
	loadOptionToDo();
	refreshByTabIndexChage(1);
	HelpButton.SetTooltipCustomType(getCustomToolTip(GetSystemString(3688)));
	return;
}

event OnShow()
{
	Me.SetTimer(99901, 3000);
	refreshBtn.DisableWindow();
	Me.SetFocus();
	handleListEmpty();
	API_RequestPledgeMissionInfo();
	return;
}

event OnClickCheckBox(string strID)
{
	switch(strID)
	{
		case "AllLevelCheckBox":
			SetOptionToDo();
			refreshData();
			break;
		default:
			break;
	}
	return;
}

event OnTimer(int TimerID)
{
	if((TimerID == 99901))
	{
		refreshBtn.EnableWindow();
		Me.KillTimer(99901);
	}
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "RefreshBtn":
			Me.SetTimer(99901, 3000);
			refreshBtn.DisableWindow();
			API_RequestPledgeMissionInfo();
			break;
		case "EssentialBtn":
			Me.HideWindow();
			break;
		case "RewardBtn":
			requestReward();
			break;
		case "ToDoListClan_TabCtrl0":
			refreshByTabIndexChage(1);
			break;
		case "ToDoListClan_TabCtrl1":
			refreshByTabIndexChage(2);
			break;
		case "ToDoListClan_TabCtrl2":
			refreshByTabIndexChage(3);
			break;
		case "ToDoListClan_TabCtrl3":
			refreshByTabIndexChage(4);
			break;
		case "WndHelp_Button":
			ExecuteEvent(1210, "152");
			break;
		default:
			break;
	}
	return;
}

event OnEvent(int a_EventID, string param)
{
	switch(a_EventID)
	{
		case 10440:
			handlePledgeMissionInfo(param);
			break;
		case 10441:
			handlePledgeMissionRewardCount(param);
			break;
		case 40:
			ToDoList_ListCtrl.DeleteAllItem();
			toDoClanArray.Length = 0;
			numOfEventList = 0;
			clientStartSec = 0;
			lastClickIndex = -1;
			typeCount = 0;
			ClearRewardList();
			break;
		case 10230:
			setCurrentserverTime(param);
			break;
		default:
			break;
	}
	return;
}

function bool SortByDelegate(ToDoListClanData A, ToDoListClanData B)
{
	if((boolToNum((A.curState == 3)) != boolToNum((B.curState == 3))))
	{
		return (boolToNum((A.curState == 3)) < boolToNum((B.curState == 3)));
	}
	if((A.nRepeatSortValue != B.nRepeatSortValue))
	{
		return (A.nRepeatSortValue < B.nRepeatSortValue);
	}
	if((A.nTypeSortValue != B.nTypeSortValue))
	{
		return (A.nTypeSortValue > B.nTypeSortValue);
	}
	return false;
}

event OnClickListCtrlRecord(string ListCtrlID)
{
	local LVDataRecord Record;
	local PledgeMissionUIData pledgeMissionUIDataOut;

	if((ToDoList_ListCtrl.GetSelectedIndex() >= 0))
	{
		ToDoList_ListCtrl.GetSelectedRec(Record);
		GetPledgeMissionData(int(Record.szReserved), pledgeMissionUIDataOut);
		setResultTitle(Record.LVDataList[1].szData, pledgeMissionUIDataOut.nRepeat, toDoClanArray[int(Record.nReserved1)].curState);
		setResultReward(pledgeMissionUIDataOut.RewardItems, pledgeMissionUIDataOut.RewardPledgeNameValue, pledgeMissionUIDataOut.RewardPVPPoint, toDoClanArray[int(Record.nReserved1)].curState);
		setResultConditions(pledgeMissionUIDataOut.Condition);
		setResultGoalCondition(pledgeMissionUIDataOut.GoalDesc, toDoClanArray[int(Record.nReserved1)].progressCount, pledgeMissionUIDataOut.GoalCount);
		areaScroll.SetScrollPosition(0);
		areaScroll.SetScrollHeight(((RewardInfoWnd_scrollarea.GetRect().nHeight + ConditionWnd_scrollarea.GetRect().nHeight) + CompleteWnd_scrollarea.GetRect().nHeight));
	}
	return;
}

function API_RequestPledgeMissionInfo()
{
	typeCount = 0;
	Debug("--> RequestPledgeMissionInfo()");
	RequestPledgeMissionInfo();
	return;
}

function setCurrentserverTime(string param)
{
	ParseInt(param, "ServerTime", serverStartTime);
	ParseInt(param, "ServerTimeZone", serverTimeZone);
	clientStartSec = int(GetAppSeconds());
	return;
}

function bool isEventPeroid(PledgeMissionCondition Condition)
{
	local L2UITime L2UITime;
	local int curDate, CurTime, serverTime;

	if((Condition.StartDate == 0))
	{
		return true;
	}
	serverTime = (int(((float(serverStartTime) + GetAppSeconds()) - float(clientStartSec))) - serverTimeZone);
	GetTimeStructGMT(serverTime, L2UITime);
	curDate = (((int((float(L2UITime.nYear) % 100.0000000)) * 10000) + (L2UITime.nMonth * 100)) + L2UITime.nDay);
	CurTime = ((L2UITime.nHour * 100) + L2UITime.nMin);
	if(((Condition.StartDate > 0) && (Condition.EndDate > 0)))
	{
		if(((curDate < Condition.StartDate) || (curDate > Condition.EndDate)))
		{
			return false;
		}
		if(((curDate == Condition.StartDate) && (CurTime < Condition.StartTime)))
		{
			return false;
		}
		if(((curDate == Condition.EndDate) && (CurTime >= Condition.EndTime)))
		{
			return false;
		}
	}
	return true;
}

function handleEventMissionNum(int idx, bool isEventPeroid)
{
	if((idx != -1))
	{
		if((isEventPeroid != toDoClanArray[idx].isEventPeroid))
		{
			if(isEventPeroid)
			{
				numOfEventList++;
			}
			else
			{
				numOfEventList--;
			}
		}
	}
	else if(isEventPeroid)
	{
		numOfEventList++;
	}
	ToDoListClan_TabCtrl.SetDisable(3, (numOfEventList == 0));
	return;
}

function handleCompletedMissionNum(int idx, bool isRwardState, bool isEventPeroid, int Category)
{
	local NoticeWnd Script;
	local string param;
	local int oldNumOfRewardList;

	oldNumOfRewardList = numOfRewardList;
	if((idx != -1))
	{
		if(((toDoClanArray[idx].isEventPeroid != isEventPeroid) || (isRwardState != (toDoClanArray[idx].curState == 3))))
		{
			if((isRwardState && isEventPeroid))
			{
				numOfRewardList++;
				rewards[(Category - 1)]++;
				SetTabCompletedNum((Category - 1));
			}
			else
			{
				numOfRewardList--;
				rewards[(Category - 1)]--;
				SetTabCompletedNum((Category - 1));
			}
		}
	}
	else if((isRwardState && isEventPeroid))
	{
		numOfRewardList++;
		rewards[(Category - 1)]++;
		SetTabCompletedNum((Category - 1));
	}
	if((oldNumOfRewardList == numOfRewardList))
	{
		return;
	}
	Script = NoticeWnd(GetScript("NoticeWnd"));
	if((numOfRewardList == 0))
	{
		Script.removeNoticeButton(18);
	}
	else
	{
		param = "";
		ParamAdd(param, "rewardCount", string(numOfRewardList));
		Script.createNoticeButtonWithParam(18, 3670, param);
	}
	return;
}

function SetTabCompletedNum(int tabindex)
{
	local int completedNum;
	local string TextureName;

	if((tabindex < rewards.Length))
	{
		completedNum = rewards[tabindex];
	}
	if((completedNum < 0))
	{
		completedNum = 0;
	}
	if((completedNum > 9))
	{
		TextureName = ("L2UI_CT1.Tab.TabNoticeCount_09" $ "Plus");
	}
	else if((completedNum != 0))
	{
		TextureName = ("L2UI_CT1.Tab.TabNoticeCount_0" $ string(completedNum));
	}
	ToDoListClan_TabCtrl.SetButtonOffsetTex(tabindex, TextureName, 76, -7);
	return;
}

function handlePledgeMissionInfo(string param)
{
	local int idx, listIndex;
	local ToDoListClanData tmpToDoListClanDataOut;
	local PledgeMissionUIData tmpPledgeMissionUIData;
	local int tmpSortValue;

	ParseInt(param, "MissionID", tmpToDoListClanDataOut.MissionID);
	ParseInt(param, "ProgressCount", tmpToDoListClanDataOut.progressCount);
	ParseInt(param, "CurState", tmpToDoListClanDataOut.curState);
	if(!GetPledgeMissionData(tmpToDoListClanDataOut.MissionID, tmpPledgeMissionUIData))
	{
		return;
	}
	switch(tmpPledgeMissionUIData.nRepeat)
	{
		case 3:
			tmpToDoListClanDataOut.nRepeatSortValue = 3;
			break;
		case 2:
			tmpToDoListClanDataOut.nRepeatSortValue = 2;
			break;
		case 1:
			tmpToDoListClanDataOut.nRepeatSortValue = 0;
			break;
		case 0:
			tmpToDoListClanDataOut.nRepeatSortValue = 1;
			break;
		default:
			break;
	}
	tmpToDoListClanDataOut.Category = tmpPledgeMissionUIData.Category;
	tmpToDoListClanDataOut.isEventPeroid = isEventPeroid(tmpPledgeMissionUIData.Condition);
	idx = FindIdx(tmpToDoListClanDataOut.MissionID);
	handleEventMissionNum(idx, tmpToDoListClanDataOut.isEventPeroid);
	handleCompletedMissionNum(idx, (tmpToDoListClanDataOut.curState == 3), tmpToDoListClanDataOut.isEventPeroid, tmpPledgeMissionUIData.Category);
	if((idx == -1))
	{
		typeCount++;
		tmpToDoListClanDataOut.nTypeSortValue = typeCount;
		idx = toDoClanArray.Length;
		toDoClanArray.Length = (toDoClanArray.Length + 1);
		toDoClanArray[idx] = tmpToDoListClanDataOut;
		if((tmpPledgeMissionUIData.Category == currentTabIndex))
		{
			refreshData();
			return;
		}
	}
	else
	{
		tmpSortValue = toDoClanArray[idx].nTypeSortValue;
		tmpToDoListClanDataOut.nTypeSortValue = tmpSortValue;
		toDoClanArray[idx] = tmpToDoListClanDataOut;
		if((tmpPledgeMissionUIData.Category == currentTabIndex))
		{
			listIndex = FindListIndex(idx);
			if((listIndex == -1))
			{
				listinsert(idx);
			}
			else if(((tmpPledgeMissionUIData.Category == 4) && !tmpToDoListClanDataOut.isEventPeroid))
			{
				listDelete(listIndex);
			}
			else
			{
				switch(toDoClanArray[idx].curState)
				{
					case 1:
						if(AllLevelCheckBox.IsChecked())
						{
							listModify(listIndex, idx);
						}
						else
						{
							listDelete(listIndex);
						}
						break;
					case 0:
						listDelete(listIndex);
						break;
					default:
						listModify(listIndex, idx);
						break;
				}
			}
			autoSelectList();
		}
		refreshData();
	}
	return;
}

function handleListEmpty()
{
	if((((currentTabIndex == 1) && (curRewardCount == maxRewardCount)) && (maxRewardCount > 0)))
	{
		toDoDisable_Wnd.HideWindow();
		todoComplete_Wnd.ShowWindow();
		ToDoList_ListCtrl.DeleteAllItem();
	}
	else if((ToDoList_ListCtrl.GetRecordCount() == 0))
	{
		toDoDisable_Wnd.ShowWindow();
		todoComplete_Wnd.HideWindow();
	}
	else
	{
		toDoDisable_Wnd.HideWindow();
		todoComplete_Wnd.HideWindow();
	}
	return;
}

function listinsert(int idx)
{
	local PledgeMissionUIData missionUIData;

	GetPledgeMissionData(toDoClanArray[idx].MissionID, missionUIData);
	if((toDoClanArray[idx].curState != 0))
	{
		if((AllLevelCheckBox.IsChecked() || (toDoClanArray[idx].curState != 1)))
		{
			if(((toDoClanArray[idx].Category != 4) || toDoClanArray[idx].isEventPeroid))
			{
				if(((currentTabIndex != 1) || (curRewardCount != maxRewardCount)))
				{
					ToDoList_ListCtrl.InsertRecord(makeMissionRecord(idx));
				}
			}
		}
	}
	else if(((AllLevelCheckBox.IsChecked() && ((int(missionUIData.nRepeat) == 2) || (int(missionUIData.nRepeat) == 3))) && (toDoClanArray[idx].curState == 0)))
	{
		if((AllLevelCheckBox.IsChecked() || (toDoClanArray[idx].curState != 1)))
		{
			if(((toDoClanArray[idx].Category != 4) || toDoClanArray[idx].isEventPeroid))
			{
				if(((currentTabIndex != 1) || (curRewardCount != maxRewardCount)))
				{
					ToDoList_ListCtrl.InsertRecord(makeMissionRecord(idx));
				}
			}
		}
	}
	return;
}

function listDelete(int listIndex)
{
	setResultEmpty();
	ToDoList_ListCtrl.DeleteRecord(listIndex);
	return;
}

function listModify(int listIndex, int idx)
{
	ToDoList_ListCtrl.ModifyRecord(listIndex, makeMissionRecord(idx));
	if((listIndex == ToDoList_ListCtrl.GetSelectedIndex()))
	{
		OnClickListCtrlRecord("");
	}
	return;
}

function _BubbleSort(out array<ToDoListClanData> arr)
{
	local int i, j;
	local ToDoListClanData temp;

	i = 0;
	while((i < arr.Length))
	{
		j = 0;
		while((j < (arr.Length - i)))
		{
			if((j < (arr.Length - 1)))
			{
				if(SortByDelegate(arr[j], arr[(j + 1)]))
				{
					temp = arr[j];
					arr[j] = arr[(j + 1)];
					arr[(j + 1)] = temp;
				}
			}
			++j;
		}
		++i;
	}
	return;
}

function refreshData()
{
	local int i;

	ToDoList_ListCtrl.DeleteAllItem();
	_BubbleSort(toDoClanArray);
	i = 0;
	while((i < toDoClanArray.Length))
	{
		if((toDoClanArray[i].Category == currentTabIndex))
		{
			listinsert(i);
		}
		i++;
	}
	handleListEmpty();
	autoSelectList();
	return;
}

function autoSelectList()
{
	if((lastClickIndex > -1))
	{
		ToDoList_ListCtrl.SetSelectedIndex(lastClickIndex, true);
		OnClickListCtrlRecord("");
	}
	return;
}

function handlePledgeMissionRewardCount(string param)
{
	ParseInt(param, "CurRewardCount", curRewardCount);
	ParseInt(param, "MaxRewardCount", maxRewardCount);
	WeekMissionNum_Text.SetText((((("(" $ string(curRewardCount)) $ "/") $ string(maxRewardCount)) $ ")"));
	handleListEmpty();
	return;
}

function LVDataRecord makeMissionRecord(int idx)
{
	local LVDataRecord Record;
	local PledgeMissionUIData missionUIData;

	Debug("makeMissionRecord");
	if(!GetPledgeMissionData(toDoClanArray[idx].MissionID, missionUIData))
	{
		return Record;
	}
	Record.LVDataList.Length = 3;
	Record.LVDataList[0].bUseTextColor = true;
	Record.LVDataList[1].bUseTextColor = true;
	Record.LVDataList[2].bUseTextColor = true;
	Record.LVDataList[0].TextColor = getRepeatTextColor(missionUIData.nRepeat);
	if((int(missionUIData.nRepeat) == 0))
	{
		Record.LVDataList[0].szData = GetSystemString(1792);
	}
	else if((int(missionUIData.nRepeat) == 1))
	{
		Record.LVDataList[0].szData = GetSystemString(1793);
	}
	else if((int(missionUIData.nRepeat) == 2))
	{
		Record.LVDataList[0].szData = GetSystemString(3579);
	}
	else if((int(missionUIData.nRepeat) == 3))
	{
		Record.LVDataList[0].szData = GetSystemString(3580);
	}
	Record.LVDataList[1].TextColor = getInstanceL2Util().BrightWhite;
	if(getIsEventMission(toDoClanArray[idx].MissionID))
	{
		Record.LVDataList[1].hasIcon = true;
		Record.LVDataList[1].szTexture = "L2UI_CT1.Clan.ClanMission_x2Icon";
		Record.LVDataList[1].IconPosX = 8;
		Record.LVDataList[1].nTextureWidth = 24;
		Record.LVDataList[1].nTextureHeight = 24;
		Record.LVDataList[1].nTextureU = 24;
		Record.LVDataList[1].nTextureV = 24;
		Record.LVDataList[1].HiddenStringForSorting = ("0" $ missionUIData.MissionName);
	}
	else
	{
		Record.LVDataList[1].HiddenStringForSorting = ("1" $ missionUIData.MissionName);
	}
	Record.LVDataList[1].szData = missionUIData.MissionName;
	Record.LVDataList[1].textAlignment = TA_Left;
	switch(toDoClanArray[idx].curState)
	{
		case 3:
			Record.LVDataList[2].TextColor = getInstanceL2Util().Yellow;
			Record.LVDataList[2].szData = GetSystemString(3586);
			Record.LVDataList[2].HiddenStringForSorting = "0";
			break;
		case 2:
			Record.bUseStatusBar = true;
			Record.nStatusBarIndex = 2;
			Record.LVDataList[2].nStatusBarCurrentCount = toDoClanArray[idx].progressCount;
			Record.LVDataList[2].nStatusBarMaxCount = missionUIData.GoalCount;
			Record.strStatusBarForeLeftTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Left3";
			Record.strStatusBarForeCenterTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Center3";
			Record.strStatusBarForeRightTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Right3";
			Record.strStatusBarBackLeftTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_bg_Left3";
			Record.strStatusBarBackCenterTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_bg_Center3";
			Record.strStatusBarBackRightTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_bg_Right3";
			Record.nStatusBarWidth = 110;
			Record.nStatusBarHeight = 12;
			Record.LVDataList[2].HiddenStringForSorting = "1";
			break;
		case 1:
			Record.LVDataList[2].hasIcon = true;
			Record.LVDataList[2].nTextureWidth = 14;
			Record.LVDataList[2].nTextureHeight = 14;
			Record.LVDataList[2].nTextureU = 14;
			Record.LVDataList[2].nTextureV = 14;
			Record.LVDataList[2].szTexture = "L2UI_CT1.DailyMissionWnd_IconLock";
			Record.LVDataList[2].IconPosX = 28;
			Record.LVDataList[2].FirstLineOffsetX = 5;
			Record.LVDataList[2].TextColor = GTColor().Red3;
			Record.LVDataList[2].szData = GetSystemString(3682);
			Record.LVDataList[2].HiddenStringForSorting = "2";
			break;
		case 0:
			Record.LVDataList[2].hasIcon = true;
			Record.LVDataList[2].nTextureWidth = 14;
			Record.LVDataList[2].nTextureHeight = 14;
			Record.LVDataList[2].nTextureU = 14;
			Record.LVDataList[2].nTextureV = 14;
			Record.LVDataList[2].szTexture = "L2UI_CT1.DailyMissionWnd_IconLock";
			Record.LVDataList[2].IconPosX = 28;
			Record.LVDataList[2].FirstLineOffsetX = 5;
			Record.LVDataList[2].TextColor = GTColor().Red3;
			Record.LVDataList[2].szData = GetSystemString(3682);
			Record.LVDataList[2].HiddenStringForSorting = "2";
			break;
		default:
			break;
	}
	Record.LVDataList[0].textAlignment = TA_Center;
	Record.LVDataList[2].textAlignment = TA_Center;
	Record.szReserved = string(missionUIData.MissionID);
	Record.nReserved1 = INT64(idx);
	return Record;
}

function setResultEmpty()
{
	local array<PledgeMissionRewardItem> emptyRewardItems;
	local PledgeMissionCondition emptyCondition;

	MissionName_Text.SetText("");
	MissionDateName_Text.SetText("");
	IconLock_texture.HideWindow();
	setResultReward(emptyRewardItems, 0, 0, 1);
	setResultConditions(emptyCondition);
	setResultGoalCondition("", 0, 0);
	areaScroll.SetScrollPosition(0);
	areaScroll.SetScrollHeight(((RewardInfoWnd_scrollarea.GetRect().nHeight + ConditionWnd_scrollarea.GetRect().nHeight) + CompleteWnd_scrollarea.GetRect().nHeight));
	return;
}

function setResultGoalCondition(string GoalDesc, int progressCount, int GoalCount)
{
	local int resultHeight;

	resultHeight = setTextFieldHight(CompleteDescriotion_Text, GoalDesc);
	CompleteWnd_scrollarea.SetWindowSize(266, ((resultHeight + 53) + 7));
	Completegage_statusbar.SetPoint(INT64(progressCount), INT64(GoalCount));
	return;
}

function string setResultMakeJob(bool JobMain, bool JobDual, bool JobSub, string conditionString)
{
	local string classString;

	if(JobMain)
	{
		classString = GetSystemString(2340);
	}
	if(JobDual)
	{
		if((classString != ""))
		{
			classString = (classString $ ", ");
		}
		classString = (classString $ GetSystemString(2737));
	}
	if(JobSub)
	{
		if((classString != ""))
		{
			classString = (classString $ ", ");
		}
		classString = (classString $ GetSystemString(2339));
	}
	if((classString != ""))
	{
		addConditionSring(classString, conditionString);
	}
	return conditionString;
}

function string setResultMakeLevelString(int MinLevel, int MaxLevel, string conditionString)
{
	local string levelString;

	if((MinLevel > 0))
	{
		levelString = (string(MinLevel) @ GetSystemString(859));
	}
	if((MaxLevel > 0))
	{
		if((levelString != ""))
		{
			levelString = (levelString $ " ~ ");
		}
		levelString = ((levelString $ string(MaxLevel)) @ GetSystemString(3692));
	}
	if((levelString != ""))
	{
		addConditionSring(((GetSystemString(2321) @ GetSystemString(537)) @ levelString), conditionString);
	}
	return conditionString;
}

function string setResultMakeDateString(int date)
{
	local string yearStr, monthStr, dayStr, zeroString;

	zeroString = getInstanceL2Util().makeZeroString(6, INT64(date));
	yearStr = Mid(zeroString, 0, 2);
	monthStr = Mid(zeroString, 2, 2);
	dayStr = Mid(zeroString, 4, 2);
	return MakeFullSystemMsg(GetSystemMessage(4467), yearStr, monthStr, dayStr);
}

function string setResultMakeTimeString(int Time)
{
	local string zeroString;

	if((Time == 0))
	{
		return "";
	}
	zeroString = getInstanceL2Util().makeZeroString(4, INT64(Time));
	return (((" " $ Mid(zeroString, 0, 2)) $ ":") $ Mid(zeroString, 2, 4));
}

function string getDayString(array<int> AvailableDays)
{
	local int i, Len, nCount;
	local string dayStr;

	Len = AvailableDays.Length;
	if((Len > 0))
	{
		i = 0;
		while((i < Len))
		{
			if((AvailableDays[i] > 0))
			{
				nCount++;
				switch(AvailableDays[i])
				{
					case 1:
						if((dayStr != ""))
						{
							dayStr = (dayStr $ ",");
						}
						dayStr = (dayStr $ GetSystemString(5134));
						break;
					case 2:
						if((dayStr != ""))
						{
							dayStr = (dayStr $ ",");
						}
						dayStr = (dayStr $ GetSystemString(5135));
						break;
					case 3:
						if((dayStr != ""))
						{
							dayStr = (dayStr $ ",");
						}
						dayStr = (dayStr $ GetSystemString(5136));
						break;
					case 4:
						if((dayStr != ""))
						{
							dayStr = (dayStr $ ",");
						}
						dayStr = (dayStr $ GetSystemString(5137));
						break;
					case 5:
						if((dayStr != ""))
						{
							dayStr = (dayStr $ ",");
						}
						dayStr = (dayStr $ GetSystemString(5138));
						break;
					case 6:
						if((dayStr != ""))
						{
							dayStr = (dayStr $ ",");
						}
						dayStr = (dayStr $ GetSystemString(5139));
						break;
					default:
						break;
				}
			}
			i++;
		}
		if((AvailableDays[0] == 0))
		{
			nCount++;
			if((dayStr != ""))
			{
				dayStr = (dayStr $ ",");
			}
			dayStr = (dayStr $ GetSystemString(5140));
		}
	}
	if(((nCount > 6) || (nCount == 0)))
	{
		dayStr = GetSystemString(3613);
	}
	dayStr = (("[" $ dayStr) $ "]");
	return dayStr;
}

function requestReward()
{
	local LVDataRecord Record;

	lastClickIndex = ToDoList_ListCtrl.GetSelectedIndex();
	if((ToDoList_ListCtrl.GetSelectedIndex() >= 0))
	{
		ToDoList_ListCtrl.GetSelectedRec(Record);
		RequestPledgeMissionReward(int(Record.szReserved));
	}
	return;
}

function setResultConditions(PledgeMissionCondition Condition)
{
	local int resultHeight;
	local string conditionString;

	if((Condition.PledgeLevel > 0))
	{
		addConditionSring(MakeFullSystemMsg(GetSystemMessage(4546), string(Condition.PledgeLevel)), conditionString);
	}
	if((Condition.PledgeMasteryName != ""))
	{
		addConditionSring(Condition.PledgeMasteryName, conditionString);
	}
	conditionString = setResultMakeLevelString(Condition.MinLevel, Condition.MaxLevel, conditionString);
	conditionString = setResultMakeJob(Condition.JobMain, Condition.JobDual, Condition.JobSub, conditionString);
	if((Condition.PreMissionID > 0))
	{
		addConditionSring(((("\"" $ getMissionNameByID(Condition.PreMissionID)) $ "\"") @ GetSystemString(898)), conditionString);
	}
	if((Condition.StartDate != 0))
	{
		addConditionSring(GetSystemString(2099), conditionString);
		if((Condition.StartTime != 0))
		{
			conditionString = (conditionString $ "\\n   ");
		}
		else
		{
			conditionString = (conditionString $ " : ");
		}
		conditionString = (((((conditionString $ setResultMakeDateString(Condition.StartDate)) $ setResultMakeTimeString(Condition.StartTime)) @ "~") @ setResultMakeDateString(Condition.EndDate)) $ setResultMakeTimeString(Condition.EndTime));
	}
	if((Condition.ActivateTime != 0))
	{
		addConditionSring((GetSystemString(3605) $ " :"), conditionString);
		conditionString = (((conditionString $ setResultMakeTimeString(Condition.ActivateTime)) @ "~") $ setResultMakeTimeString(Condition.DeactivateTime));
	}
	if((Condition.AvailableDays.Length > 0))
	{
		addConditionSring(((GetSystemString(3693) $ " : ") $ getDayString(Condition.AvailableDays)), conditionString);
	}
	resultHeight = setTextFieldHight(ConditionDescriotion_Text, conditionString);
	ConditionWnd_scrollarea.SetWindowSize(266, (resultHeight + 30));
	return;
}

function string getMissionNameByID(int MissionID)
{
	local PledgeMissionUIData pledgeMissionUIDataOut;

	GetPledgeMissionData(MissionID, pledgeMissionUIDataOut);
	return pledgeMissionUIDataOut.MissionName;
}

function addConditionSring(string Str, out string conditionString)
{
	local string Dot;

	if((int(GetLanguage()) == 0))
	{
		Dot = "·";
	}
	else
	{
		Dot = "-";
	}
	if((conditionString != ""))
	{
		conditionString = (conditionString $ "\\n");
	}
	conditionString = ((conditionString $ Dot) $ Str);
	return;
}

function ClearRewardList()
{
	local int i;

	numOfRewardList = 0;
	i = 0;
	while((i < rewards.Length))
	{
		rewards[i] = 0;
		i++;
	}
	return;
}

function setResultReward(array<PledgeMissionRewardItem> RewardItems, int RewardPledgeNameValue, int RewardPVPPoint, int curState)
{
	local int i;

	DailyRewardItem.Clear();
	i = 0;
	while((i < RewardItems.Length))
	{
		setResultRewardItems(RewardItems[i]);
		i++;
	}
	ClanFameInput_Text.SetText(MakeCostString(string(RewardPledgeNameValue)));
	PrivateFameInput_Text.SetText(MakeCostString(string(RewardPVPPoint)));
	if((curState == 3))
	{
		rewardBtn.SetButtonName(2279);
		rewardBtn.EnableWindow();
	}
	else
	{
		rewardBtn.SetButtonName(3604);
		rewardBtn.DisableWindow();
	}
	return;
}

function setResultRewardItems(PledgeMissionRewardItem rewardItem)
{
	local ItemInfo ItemInfo;
	local ItemID ItemID;

	ItemID.ClassID = rewardItem.ItemClassID;
	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(ItemID, ItemInfo);
	ItemInfo.ItemNum = INT64(rewardItem.ItemCount);
	DailyRewardItem.AddItem(ItemInfo);
	return;
}

function setResultTitle(string Title, byte nRepeat, int curState)
{
	MissionName_Text.SetText(Title);
	MissionDateName_Text.SetTextColor(getRepeatTextColor(nRepeat));
	if((int(nRepeat) == 0))
	{
		MissionDateName_Text.SetText(GetSystemString(3678));
	}
	else if((int(nRepeat) == 1))
	{
		MissionDateName_Text.SetText(GetSystemString(3679));
	}
	else if((int(nRepeat) == 2))
	{
		MissionDateName_Text.SetText(GetSystemString(3583));
	}
	else if((int(nRepeat) == 3))
	{
		MissionDateName_Text.SetText(GetSystemString(3584));
	}
	if((curState == 1))
	{
		IconLock_texture.ShowWindow();
	}
	else
	{
		IconLock_texture.HideWindow();
	}
	return;
}

function int FindIdx(int MissionID)
{
	local int i;

	i = 0;
	while((i < toDoClanArray.Length))
	{
		if((toDoClanArray[i].MissionID == MissionID))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function int FindListIndex(int idx)
{
	local int i;
	local LVDataRecord Record;

	i = 0;
	while((i < ToDoList_ListCtrl.GetRecordCount()))
	{
		ToDoList_ListCtrl.GetRec(i, Record);
		if((Record.nReserved1 == INT64(idx)))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function refreshByTabIndexChage(int tabindex)
{
	if((currentTabIndex != tabindex))
	{
		currentTabIndex = tabindex;
		setResultEmpty();
		refreshData();
		if((currentTabIndex == 1))
		{
			WeekMissionNum_Text.ShowWindow();
			WeekMission_Text.ShowWindow();
			HelpButton.ShowWindow();
		}
		else
		{
			WeekMissionNum_Text.HideWindow();
			WeekMission_Text.HideWindow();
			HelpButton.HideWindow();
		}
	}
	return;
}

function Color getRepeatTextColor(byte nRepeat)
{
	if((int(nRepeat) == 0))
	{
		return GTColor().LemonChiffon;
	}
	else if((int(nRepeat) == 1))
	{
		return GTColor().VIOLET01;
	}
	else if((int(nRepeat) == 2))
	{
		return GTColor().GoldenGlow;
	}
	return GTColor().MonaLisa;
}

function int setTextFieldHight(TextBoxHandle txtWnd, string Text)
{
	local int nWidth, nHeight, DEFAULTHEIGHT, i, descHeight;
	local string sNextStringWithWidth;

	txtWnd.SetText(Text);
	GetTextSizeDefault(Text, nWidth, DEFAULTHEIGHT);
	CompleteDescriotion_Text.GetWindowSize(nWidth, nHeight);
	i = 4;
	sNextStringWithWidth = DivideStringWithWidth(txtWnd.GetText(), nWidth);
	while((sNextStringWithWidth != ""))
	{
		sNextStringWithWidth = NextStringWithWidth(nWidth);
		i++;
	}
	descHeight = (i * (DEFAULTHEIGHT + 1));
	txtWnd.SetWindowSize(nWidth, descHeight);
	return descHeight;
}

function CustomTooltip getCustomToolTip(string Text)
{
	local CustomTooltip ToolTip;
	local DrawItemInfo Info;

	ToolTip.MinimumWidth = 144;
	ToolTip.DrawList.Length = 1;
	Info.eType = DIT_TEXT;
	Info.t_bDrawOneLine = true;
	Info.t_color.R = 178;
	Info.t_color.G = 190;
	Info.t_color.B = 207;
	Info.t_color.A = 255;
	Info.t_strText = Text;
	ToolTip.DrawList[0] = Info;
	return ToolTip;
}

function SetOptionToDo()
{
	local bool bChecked;

	bChecked = AllLevelCheckBox.IsChecked();
	SetOptionBool("UI", "TodoListClan", bChecked);
	return;
}

function loadOptionToDo()
{
	local bool bChecked;

	bChecked = GetOptionBool("UI", "TodoListClan");
	AllLevelCheckBox.SetCheck(bChecked);
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}

function bool getIsEventMission(int Id)
{
	return false;
	switch(Id)
	{
		case 1001:
		case 1003:
		case 1004:
		case 1005:
		case 1007:
		case 1014:
		case 1015:
		case 1016:
		case 1017:
		case 2001:
		case 2002:
		case 2003:
		case 2004:
		case 2006:
		case 2016:
			return true;
		default:
			return false;
	}
}
