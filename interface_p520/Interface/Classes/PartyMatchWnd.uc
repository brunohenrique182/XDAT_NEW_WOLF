class PartyMatchWnd extends PartyMatchWndCommon;

const MAXMEMBER = 12;

var string m_Windowname;
var WindowHandle Me;
var ListCtrlHandle PartyMatchListCtrl;
var ComboBoxHandle LevelFilterComboBox;
var ButtonHandle prevBtn;
var ButtonHandle nextBtn;
var ButtonHandle AutoJoinBtn;
var ButtonHandle refreshBtn;
var WindowHandle PartyMatchMakeRoomWnd;
var WindowHandle PartyMatchWaitListWnd;
var WindowHandle PartyMatchOutWaitListWnd;
var EditBoxHandle PartyMatchOutWaitListWnd_MinLevel;
var EditBoxHandle PartyMatchOutWaitListWnd_MaxLevel;
var WindowHandle disableWnd;
var WindowHandle PartyMatchHistory_Wnd;
var ListCtrlHandle WaitList_ListCtrl;
var TextBoxHandle ActivityPartyTitle_Text;
var TextBoxHandle ActivityParty_Text;
var TextBoxHandle ActivityPartyMemberTitle_Text;
var TextBoxHandle ActivityPartyMember_Text;
var ComboBoxHandle JobFilterComboBox;
var EditBoxHandle PartyMatchOutWaitListWnd_Name;
var int CompletelyQuitPartyMatching;
var bool bOpenStateLobby;
var int CUR_PAGE;
var ListCtrlHandle UnionMatchListCtrl;
var ButtonHandle UnionPrevBtn;
var ButtonHandle UnionNextBtn;
var ButtonHandle UnionRefreshBtn;
var WindowHandle UnionMatchMakeRoomWnd;
var int CUR_PAGE_UNION;
var bool IsInParty;

function InitHandle()
{
	Me = m_hOwnerWnd;
	PartyMatchListCtrl = GetListCtrlHandle("PartyMatchWnd.PartyMatchListCtrl");
	UnionMatchListCtrl = GetListCtrlHandle("PartyMatchWnd.UnionMatchListCtrl");
	LevelFilterComboBox = GetComboBoxHandle("PartyMatchWnd.LevelFilterComboBox");
	prevBtn = GetButtonHandle("PartyMatchWnd.PrevBtn");
	nextBtn = GetButtonHandle("PartyMatchWnd.NextBtn");
	AutoJoinBtn = GetButtonHandle("PartyMatchWnd.AutoJoinBtn");
	refreshBtn = GetButtonHandle("PartyMatchWnd.RefreshBtn");
	PartyMatchMakeRoomWnd = GetWindowHandle("PartyMatchMakeRoomWnd");
	PartyMatchWaitListWnd = GetWindowHandle("PartyMatchWaitListWnd");
	PartyMatchOutWaitListWnd = GetWindowHandle("PartyMatchOutWaitListWnd");
	PartyMatchOutWaitListWnd_MinLevel = GetEditBoxHandle("PartyMatchOutWaitListWnd.MinLevel");
	PartyMatchOutWaitListWnd_MaxLevel = GetEditBoxHandle("PartyMatchOutWaitListWnd.MaxLevel");
	JobFilterComboBox = GetComboBoxHandle("PartyMatchOutWaitListWnd.Job");
	PartyMatchOutWaitListWnd_Name = GetEditBoxHandle("PartyMatchOutWaitListWnd.Name");
	UnionPrevBtn = GetButtonHandle("PartyMatchWnd.UnionPrevBtn");
	UnionNextBtn = GetButtonHandle("PartyMatchWnd.UnionNextBtn");
	UnionRefreshBtn = GetButtonHandle("PartyMatchWnd.UnionRefreshBtn");
	UnionMatchMakeRoomWnd = GetWindowHandle("UnionMatchMakeRoomWnd");
	disableWnd = GetWindowHandle("PartyMatchWnd.DisableWnd");
	PartyMatchHistory_Wnd = GetWindowHandle("PartyMatchWnd.PartyMatchHistory_Wnd");
	WaitList_ListCtrl = GetListCtrlHandle("PartyMatchWnd.PartyMatchHistory_Wnd.WaitList_ListCtrl");
	ActivityPartyTitle_Text = GetTextBoxHandle("PartyMatchWnd.ActivityPartyTitle_Text");
	ActivityParty_Text = GetTextBoxHandle("PartyMatchWnd.ActivityParty_Text");
	ActivityPartyMemberTitle_Text = GetTextBoxHandle("PartyMatchWnd.ActivityPartyMemberTitle_Text");
	ActivityPartyMember_Text = GetTextBoxHandle("PartyMatchWnd.ActivityPartyMember_Text");
	disableWnd.DisableWindow();
	return;
}

function SetIsInParty(bool B)
{
	IsInParty = B;
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(1540);
	RegisterEvent(1570);
	RegisterEvent(1550);
	RegisterEvent(4010);
	RegisterEvent(4020);
	RegisterEvent(4870);
	RegisterEvent(40);
	RegisterEvent(1551);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	InitHandle();
	Init();
	return;
}

function Init()
{
	CompletelyQuitPartyMatching = 0;
	bOpenStateLobby = false;
	CUR_PAGE = 0;
	CUR_PAGE_UNION = 0;
	IsInParty = false;
	LevelFilterComboBox.SetSelectedNum(1);
	return;
}

function OnShow()
{
	PlayConsoleSound(IFST_WINDOW_OPEN);
	PartyMatchHistory_Wnd.HideWindow();
	DisableCurrentWindow(false);
	PartyMatchListCtrl.ShowScrollBar(false);
	UnionMatchListCtrl.DeleteAllItem();
	if(!getInstanceUIData().getIsArenaServer())
	{
		Me.SetTimer(1, 1000);
	}
	if(true)
	{
		Class'Interface.BottomBar'.static.Inst().SetPartyOnOffState(true, false);
	}
	else
	{
		CallGFxFunction("ExpBar", "PartyMatchWndGFxEvent", "state=onShow windowName=PartyMatchWnd");
	}
	return;
}

function OnTimer(int TimerID)
{
	if((TimerID == 1))
	{
		RequestUnionRoomList(1);
		Me.KillTimer(1);
	}
	return;
}

function OnSendPacketWhenHiding()
{
	Class'NWindow.PartyMatchAPI'.static.RequestExitPartyMatchingWaitingRoom();
	return;
}

function OnHide()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	PartyMatchMakeRoomWnd.HideWindow();
	PartyMatchHistory_Wnd.HideWindow();
	DisableCurrentWindow(false);
	if(true)
	{
		Class'Interface.BottomBar'.static.Inst().SetPartyOnOffState(false, false);
	}
	else
	{
		CallGFxFunction("ExpBar", "PartyMatchWndGFxEvent", "state=onHide");
	}
	return;
}

function OnEvent(int a_EventID, string param)
{
	local PartyMatchMakeRoomWnd Script;

	switch(a_EventID)
	{
		case 1540:
			if((CompletelyQuitPartyMatching == 1))
			{
				Class'NWindow.PartyMatchAPI'.static.RequestExitPartyMatchingWaitingRoom();
				Me.HideWindow();
				Script = PartyMatchMakeRoomWnd(GetScript("PartyMatchMakeRoomWnd"));
				Script.OnCancelButtonClick();
				CompletelyQuitPartyMatching = 0;
				SetWaitListWnd(false);
			}
			else
			{
				UpdateWaitListWnd();
				if((Me.IsShowWindow() == false))
				{
					Me.ShowWindow();
					PartyMatchListCtrl.ShowScrollBar(false);
				}
				Me.SetFocus();
			}
			break;
		case 1570:
			HandlePartyMatchList(param);
			break;
		case 1550:
			Me.HideWindow();
			break;
		case 4010:
			HandleListMpccWaitingStart(param);
			break;
		case 4020:
			HandleListMpccWaitingRoomInfo(param);
			break;
		case 4870:
			HandlePartyToggle();
			break;
		case 40:
			SetIsInParty(false);
			bOpenStateLobby = false;
			break;
		case 1551:
			updatePartyMatchingRoomHistory(param);
			break;
		default:
			break;
	}
	return;
}

function updatePartyMatchingRoomHistory(string param)
{
	local int i, Count;
	local string masterName, roomName;
	local LVDataRecord Record;

	Debug(("파티 히스토리 " @ param));  // EN: party history
	WaitList_ListCtrl.DeleteAllItem();
	Record.LVDataList.Length = 2;
	ParseInt(param, "Count", Count);
	i = 0;
	while((i < Count))
	{
		roomName = "";
		masterName = "";
		ParseString(param, ("MasterName_" $ string(i)), masterName);
		ParseString(param, ("RoomName_" $ string(i)), roomName);
		Record.LVDataList[0].szData = roomName;
		Record.LVDataList[1].szData = masterName;
		WaitList_ListCtrl.InsertRecord(Record);
		i++;
	}
	return;
}

function OnMinimize()
{
	if(true)
	{
		Class'Interface.BottomBar'.static.Inst().SetPartyOnOffState(false, true);
	}
	else
	{
		CallGFxFunction("ExpBar", "PartyMatchWndGFxEvent", "state=onMinimize");
	}
	return;
}

function HandlePartyToggle()
{
	local WindowHandle TaskWnd, TaskWnd2;
	local PartyMatchRoomWnd p2_script;

	TaskWnd = GetWindowHandle("PartyMatchWnd");
	TaskWnd2 = GetWindowHandle("PartyMatchRoomWnd");
	p2_script = PartyMatchRoomWnd(GetScript("PartyMatchRoomWnd"));
	if(TaskWnd.IsShowWindow())
	{
		ClosePartyMatchingWnd();
	}
	else if(TaskWnd2.IsShowWindow())
	{
		TaskWnd2.HideWindow();
		p2_script.OnSendPacketWhenHiding();
	}
	else if(Class'NWindow.UIAPI_WINDOW'.static.IsMinimizedWindow("PartyMatchRoomWnd"))
	{
		TaskWnd2.ShowWindow();
	}
	else
	{
		RequestPartyRoomListLocal(1);
	}
	return;
}

function ClosePartyMatchingWnd()
{
	local WindowHandle TaskWnd;
	local PartyMatchWnd p_script;

	p_script = PartyMatchWnd(GetScript("PartyMatchWnd"));
	TaskWnd = GetWindowHandle("PartyMatchWnd");
	TaskWnd.HideWindow();
	p_script.OnSendPacketWhenHiding();
	return;
}

function OnButtonTimer(bool bExpired)
{
	if(bExpired)
	{
		prevBtn.EnableWindow();
		nextBtn.EnableWindow();
		AutoJoinBtn.EnableWindow();
		refreshBtn.EnableWindow();
	}
	else
	{
		prevBtn.DisableWindow();
		nextBtn.DisableWindow();
		AutoJoinBtn.DisableWindow();
		refreshBtn.DisableWindow();
	}
	return;
}

function HandlePartyMatchList(string param)
{
	local int Count, i;
	local LVDataRecord Record;
	local int Number;
	local string PartyRoomName, PartyLeader;
	local int MinLevel, MaxLevel, MinMemberCnt, maxMemberCnt, j, MemberCnt, MemberClassID;
	local string memberName;
	local LVData data1;
	local int totalPartyMemberCount, totalPartyCount;

	ParseInt(param, "TotalPartyCount", totalPartyCount);
	ParseInt(param, "TotalPartyMemberCount", totalPartyMemberCount);
	ActivityParty_Text.SetText(MakeFullSystemMsg(GetSystemMessage(1983), string(totalPartyCount)));
	ActivityPartyMember_Text.SetText(MakeFullSystemMsg(GetSystemMessage(3305), string(totalPartyMemberCount)));
	PartyMatchListCtrl.DeleteAllItem();
	Record.LVDataList.Length = (7 + (12 / 2));
	ParseInt(param, "PageNum", CUR_PAGE);
	ParseInt(param, "RoomCount", Count);
	i = 0;
	while((i < Count))
	{
		ParseInt(param, ("RoomNum_" $ string(i)), Number);
		ParseString(param, ("Leader_" $ string(i)), PartyLeader);
		ParseInt(param, ("MinLevel_" $ string(i)), MinLevel);
		ParseInt(param, ("MaxLevel_" $ string(i)), MaxLevel);
		ParseInt(param, ("CurMember_" $ string(i)), MinMemberCnt);
		ParseInt(param, ("MaxMember_" $ string(i)), maxMemberCnt);
		if(!getInstanceUIData().GetIsClassicServer())
		{
			if((MaxLevel == getInstanceUIData().MAXLV))
			{
				MaxLevel = 199;
			}
			if((MinLevel == getInstanceUIData().MAXLV))
			{
				MinLevel = 199;
			}
		}
		ParseString(param, ("RoomName_" $ string(i)), PartyRoomName);
		ParseInt(param, ("MemberCnt_" $ string(i)), MemberCnt);
		Record.LVDataList[0].szData = string(Number);
		Record.LVDataList[1].szData = PartyLeader;
		Record.LVDataList[2].szData = PartyRoomName;
		Record.LVDataList[3].szData = ((string(MinLevel) $ "-") $ string(MaxLevel));
		Record.LVDataList[4].szData = ((string(MinMemberCnt) $ "/") $ string(maxMemberCnt));
		Record.LVDataList[5].szData = string(MemberCnt);
		j = 0;
		while((j < MemberCnt))
		{
			ParseString(param, ((("MemberName_" $ string(i)) $ "_") $ string(j)), memberName);
			ParseInt(param, ((("MemberClassID_" $ string(i)) $ "_") $ string(j)), MemberClassID);
			data1.nReserved1 = MemberClassID;
			data1.szData = memberName;
			Record.LVDataList[(7 + j)] = data1;
			++j;
		}
		PartyMatchListCtrl.InsertRecord(Record);
		++i;
	}
	return;
}

function DisableCurrentWindow(bool bFlag)
{
	disableWnd.DisableWindow();
	if(bFlag)
	{
		disableWnd.ShowWindow();
	}
	else
	{
		disableWnd.HideWindow();
	}
	return;
}

function OnClickButton(string a_strButtonName)
{
	switch(a_strButtonName)
	{
		case "RefreshBtn":
			OnRefreshBtnClick();
			break;
		case "PrevBtn":
			OnPrevBtnClick();
			break;
		case "NextBtn":
			OnNextBtnClick();
			break;
		case "MakeRoomBtn":
			OnMakeRoomBtnClick();
			break;
		case "AutoJoinBtn":
			OnAutoJoinBtnClick();
			break;
		case "WaitListButton":
			OnWaitListButton();
			break;
		case "UnionRefreshBtn":
			OnUnionRefreshBtn();
			break;
		case "UnionPrevBtn":
			OnUnionPrevBtn();
			break;
		case "UnionNextBtn":
			OnUnionNextBtn();
			break;
		case "PartyMatchHistory_Btn":
			if(GetWindowHandle("PartyMatchWaitListWnd").IsShowWindow())
			{
				SetWaitListWnd(false);
				ShowHideWaitListWnd();
			}
			DisableCurrentWindow(true);
			PartyMatchHistory_Wnd.ShowWindow();
			PartyMatchHistory_Wnd.SetFocus();
			Debug("Call --> RequestPartyMatchingHistory()");
			Class'NWindow.PartyMatchAPI'.static.RequestPartyMatchingHistory();
			break;
		case "CloseButton":
		case "Close_Btn":
			PartyMatchHistory_Wnd.HideWindow();
			DisableCurrentWindow(false);
			break;
		case "Refresh_Btn":
			Debug("Call --> RequestPartyMatchingHistory()");
			Class'NWindow.PartyMatchAPI'.static.RequestPartyMatchingHistory();
			break;
		default:
			break;
	}
	return;
}

function OnWaitListButton()
{
	ToggleWaitListWnd();
	UpdateWaitListWnd();
	return;
}

function OnRefreshBtnClick()
{
	RequestPartyRoomListLocal(1);
	return;
}

function OnPrevBtnClick()
{
	local int WantedPageNum;

	if((1 >= CUR_PAGE))
	{
		WantedPageNum = 1;
	}
	else
	{
		WantedPageNum = (CUR_PAGE - 1);
	}
	RequestPartyRoomListLocal(WantedPageNum);
	return;
}

function OnNextBtnClick()
{
	RequestPartyRoomListLocal((CUR_PAGE + 1));
	return;
}

function RequestPartyRoomListLocal(int a_Page)
{
	Class'NWindow.PartyMatchAPI'.static.RequestPartyRoomList(a_Page, GetLocationFilter(), GetLevelFilter());
	return;
}

function OnMakeRoomBtnClick()
{
	local PartyMatchMakeRoomWnd Script;
	local UserInfo PlayerInfo;
	local int MAX_LEVEL;

	if(getInstanceUIData().GetIsClassicServer())
	{
		MAX_LEVEL = getInstanceUIData().MAXLV;
	}
	else
	{
		MAX_LEVEL = 199;
	}
	Script = PartyMatchMakeRoomWnd(GetScript("PartyMatchMakeRoomWnd"));
	if((Script != none))
	{
		Script.SetRoomNumber(0);
		Script.SetTitle(GetSystemMessage(1398));
		Script.InitMaxMemberCountComboBox();
		if(GetPlayerInfo(PlayerInfo))
		{
			if(((PlayerInfo.nLevel - 5) > 0))
			{
				Script.SetMinLevel((PlayerInfo.nLevel - 5));
			}
			else
			{
				Script.SetMinLevel(1);
			}
			if(((PlayerInfo.nLevel + 5) <= MAX_LEVEL))
			{
				Script.SetMaxLevel((PlayerInfo.nLevel + 5));
			}
			else
			{
				Script.SetMaxLevel(MAX_LEVEL);
			}
		}
	}
	Script.InviteState = MAKEROOM;
	PartyMatchMakeRoomWnd.ShowWindow();
	PartyMatchMakeRoomWnd.SetFocus();
	return;
}

function OnDBClickListCtrlRecord(string a_ListCtrlName)
{
	local int SelectedRecordIndex;
	local LVDataRecord Record;

	if((a_ListCtrlName == "PartyMatchListCtrl"))
	{
		SelectedRecordIndex = PartyMatchListCtrl.GetSelectedIndex();
		PartyMatchListCtrl.GetRec(SelectedRecordIndex, Record);
		Class'NWindow.PartyMatchAPI'.static.RequestJoinPartyRoom(int(Record.LVDataList[0].szData));
	}
	else if((a_ListCtrlName == "UnionMatchListCtrl"))
	{
		SelectedRecordIndex = UnionMatchListCtrl.GetSelectedIndex();
		UnionMatchListCtrl.GetRec(SelectedRecordIndex, Record);
		Class'NWindow.PartyMatchAPI'.static.RequestJoinMpccRoom(int(Record.LVDataList[0].szData), 0);
	}
	return;
	return;
}

function OnAutoJoinBtnClick()
{
	Class'NWindow.PartyMatchAPI'.static.RequestJoinPartyRoomAuto(CUR_PAGE, GetLocationFilter(), GetLevelFilter());
	return;
}

function int GetLocationFilter()
{
	return -1;
}

function int GetLevelFilter()
{
	return LevelFilterComboBox.GetSelectedNum();
}

function SetWaitListWnd(bool bShow)
{
	bOpenStateLobby = bShow;
	return;
}

function ShowHideWaitListWnd()
{
	if(bOpenStateLobby)
	{
		PartyMatchOutWaitListWnd.ShowWindow();
		PartyMatchWaitListWnd.ShowWindow();
	}
	else
	{
		PartyMatchOutWaitListWnd.HideWindow();
		PartyMatchWaitListWnd.HideWindow();
	}
	return;
}

function UpdateWaitListWnd()
{
	local int MinLevel, MaxLevel;
	local string strName;

	if(IsShowWaitListWnd())
	{
		MinLevel = int(PartyMatchOutWaitListWnd_MinLevel.GetString());
		MaxLevel = int(PartyMatchOutWaitListWnd_MaxLevel.GetString());
		strName = PartyMatchOutWaitListWnd_Name.GetString();
		RequestPartyMatchWaitList(1, MinLevel, MaxLevel, JobFilterComboBox.GetSelectedNum(), strName);
	}
	return;
}

function ToggleWaitListWnd()
{
	bOpenStateLobby = !bOpenStateLobby;
	ShowHideWaitListWnd();
	return;
}

function bool IsShowWaitListWnd()
{
	return bOpenStateLobby;
}

function HandleListMpccWaitingStart(string param)
{
	local int ListCount;

	ParseInt(param, "Page", CUR_PAGE_UNION);
	ParseInt(param, "listCount", ListCount);
	UnionMatchListCtrl.DeleteAllItem();
	if((CUR_PAGE_UNION > 1))
	{
		UnionPrevBtn.EnableWindow();
	}
	if((ListCount > 0))
	{
		UnionNextBtn.EnableWindow();
	}
	return;
}

function HandleListMpccWaitingRoomInfo(string param)
{
	local LVDataRecord Record;
	local int RoomNum;
	local string Title, masterName;
	local int MinLevelLimit, MaxLevelLimit, CurrentJoinMemberCnt, MaxMemberLimit;

	Record.LVDataList.Length = 5;
	ParseInt(param, "RoomNum", RoomNum);
	ParseString(param, "Title", Title);
	ParseString(param, "MasterName", masterName);
	ParseInt(param, "MinLevelLimit", MinLevelLimit);
	ParseInt(param, "MaxLevelLimit", MaxLevelLimit);
	ParseInt(param, "CurrentJoinMemberCnt", CurrentJoinMemberCnt);
	ParseInt(param, "MaxMemberLimit", MaxMemberLimit);
	Record.LVDataList[0].szData = string(RoomNum);
	Record.LVDataList[1].szData = Title;
	Record.LVDataList[2].szData = masterName;
	Record.LVDataList[3].szData = ((string(MinLevelLimit) $ "-") $ string(MaxLevelLimit));
	Record.LVDataList[4].szData = ((string(CurrentJoinMemberCnt) $ "/") $ string(MaxMemberLimit));
	UnionMatchListCtrl.InsertRecord(Record);
	return;
}

function OnUnionRefreshBtn()
{
	RequestUnionRoomList(1);
	return;
}

function OnUnionPrevBtn()
{
	local int WantedPageNum;

	if((1 >= CUR_PAGE_UNION))
	{
		WantedPageNum = 1;
	}
	else
	{
		WantedPageNum = (CUR_PAGE_UNION - 1);
	}
	RequestUnionRoomList(WantedPageNum);
	return;
}

function OnUnionNextBtn()
{
	RequestUnionRoomList((CUR_PAGE_UNION + 1));
	return;
}

function RequestUnionRoomList(int a_Page)
{
	UnionPrevBtn.DisableWindow();
	UnionNextBtn.DisableWindow();
	Class'NWindow.PartyMatchAPI'.static.RequestListMpccWaiting(a_Page, GetLocationFilter(), GetLevelFilter());
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="PartyMatchWnd"
}
