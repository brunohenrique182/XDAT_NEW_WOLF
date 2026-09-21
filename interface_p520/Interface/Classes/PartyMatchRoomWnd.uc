class PartyMatchRoomWnd extends PartyMatchWndCommon;

var array<byte> _emptyByteArray;

const TIMER_ANNOUNCE_DELAY = 30000;
const TIMER_ID_ANNOUNCE = 1;

var int RoomNumber;
var int CurPartyMemberCount;
var int MaxPartyMemberCount;
var int MinLevel;
var int MaxLevel;
var int LootingMethodID;
var int MyMembershipType;
var string RoomTitle;
var bool m_bPartyMatchRoomStart;
var bool m_bRequestExitPartyRoom;
var WindowHandle Me;
var string m_Windowname;
var ListCtrlHandle m_hPartyMatchRoomWndPartyMemberListCtrl;
var ButtonHandle partyAnnounceBtn;
var TextBoxHandle partyAnnounceBtnText;

function OnRegisterEvent()
{
	RegisterEvent(40);
	RegisterEvent(1550);
	RegisterEvent(1560);
	RegisterEvent(1580);
	RegisterEvent(1590);
	RegisterEvent(1600);
	RegisterEvent(1630);
	return;
}

function OnLoad()
{
	Me = GetWindowHandle(m_Windowname);
	m_bPartyMatchRoomStart = false;
	m_bRequestExitPartyRoom = false;
	m_hPartyMatchRoomWndPartyMemberListCtrl = GetListCtrlHandle((m_Windowname $ ".PartyMemberListCtrl"));
	MyMembershipType = -1;
	partyAnnounceBtn = GetButtonHandle((m_Windowname $ ".PartyPrButton"));
	partyAnnounceBtnText = GetTextBoxHandle((m_Windowname $ ".PartyPrBtn_txt"));
	if(getInstanceUIData().GetIsLiveServer())
	{
		partyAnnounceBtn.HideWindow();
		partyAnnounceBtnText.HideWindow();
	}
	else
	{
		partyAnnounceBtn.ShowWindow();
		partyAnnounceBtnText.ShowWindow();
	}
	return;
}

function OnSendPacketWhenHiding()
{
	local PartyMatchWnd Script;

	Script = PartyMatchWnd(GetScript("PartyMatchWnd"));
	if((Script != none))
	{
		Script.CompletelyQuitPartyMatching = 1;
		Script.SetWaitListWnd(false);
		Script.ShowHideWaitListWnd();
	}
	ExitPartyRoom();
	return;
}

function OnEnterState(name a_CurrentStateName)
{
	if(m_bPartyMatchRoomStart)
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("PartyMatchRoomWnd");
		Class'NWindow.UIAPI_WINDOW'.static.SetFocus("PartyMatchRoomWnd");
	}
	return;
}

function OnEvent(int a_EventID, string param)
{
	switch(a_EventID)
	{
		case 1630:
			if(Class'NWindow.UIAPI_WINDOW'.static.IsMinimizedWindow("PartyMatchRoomWnd"))
			{
				Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("PartyMatchRoomWnd");
			}
			Class'NWindow.UIAPI_WINDOW'.static.SetFocus("PartyMatchRoomWnd");
			break;
		case 1550:
			HandlePartyMatchRoomStart(param);
			break;
		case 1560:
			HandlePartyMatchRoomClose();
			break;
		case 1580:
			HandlePartyMatchRoomMember(param);
			break;
		case 1590:
			HandlePartyMatchRoomMemberUpdate(param);
			break;
		case 1600:
			HandlePartyMatchChatMessage(param);
			break;
		case 40:
			HandleRestart();
			break;
		default:
			break;
	}
	return;
}

function HandleRestart()
{
	m_bPartyMatchRoomStart = false;
	return;
}

function ExitPartyRoom()
{
	m_bRequestExitPartyRoom = true;
	switch(MyMembershipType)
	{
		case 0:
		case 2:
			Class'NWindow.PartyMatchAPI'.static.RequestWithdrawPartyRoom(RoomNumber);
			break;
		case 1:
			Class'NWindow.PartyMatchAPI'.static.RequestDismissPartyRoom(RoomNumber);
			break;
		default:
			break;
	}
	MyMembershipType = -1;
	return;
}

function OnShow()
{
	if(true)
	{
		Class'Interface.BottomBar'.static.Inst().SetPartyOnOffState(true, false);
	}
	else
	{
		CallGFxFunction("ExpBar", "PartyMatchWndGFxEvent", "state=onShow windowName=PartyMatchRoomWnd");
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

function HandlePartyMatchRoomStart(string param)
{
	local Rect rectWnd;
	local PartyMatchWnd Script;

	Script = PartyMatchWnd(GetScript("PartyMatchWnd"));
	Script.SetIsInParty(true);
	ParseInt(param, "RoomNum", RoomNumber);
	ParseInt(param, "MaxMember", MaxPartyMemberCount);
	ParseInt(param, "MinLevel", MinLevel);
	ParseInt(param, "MaxLevel", MaxLevel);
	ParseInt(param, "LootingMethodID", LootingMethodID);
	ParseString(param, "RoomName", RoomTitle);
	UpdateData();
	lootingMethodUpdate();
	m_bPartyMatchRoomStart = true;
	Class'NWindow.UIAPI_TEXTLISTBOX'.static.Clear("PartyMatchRoomWnd.PartyRoomChatWindow");
	if(Class'NWindow.UIAPI_WINDOW'.static.IsMinimizedWindow("PartyMatchRoomWnd"))
	{
		if(true)
		{
			Class'Interface.BottomBar'.static.Inst().SetPartyAlarmOn(true);
		}
		else
		{
			CallGFxFunction("ExpBar", "PartyMatchWndGFxEvent", "state=highlightOn");
		}
	}
	else
	{
		rectWnd = Class'NWindow.UIAPI_WINDOW'.static.GetRect("PartyMatchWnd");
		Class'NWindow.UIAPI_WINDOW'.static.MoveTo("PartyMatchRoomWnd", rectWnd.nX, rectWnd.nY);
		UpdateWaitListWnd();
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("PartyMatchRoomWnd");
		Class'NWindow.UIAPI_WINDOW'.static.SetFocus("PartyMatchRoomWnd");
	}
	return;
}

function UpdateWaitListWnd()
{
	local string strName;
	local int roleIndex;
	local PartyMatchWnd Script;

	Script = PartyMatchWnd(GetScript("PartyMatchWnd"));
	if((Script != none))
	{
		if(Script.IsShowWaitListWnd())
		{
			strName = Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchWaitListWnd.Name");
			roleIndex = GetComboBoxHandle("PartyMatchWaitListWnd.Job").GetSelectedNum();
			RequestPartyMatchWaitList(1, MinLevel, MaxLevel, roleIndex, strName);
		}
	}
	return;
}

function OnHide()
{
	if(true)
	{
		Class'Interface.BottomBar'.static.Inst().SetPartyOnOffState(false, false);
	}
	else
	{
		CallGFxFunction("ExpBar", "PartyMatchWndGFxEvent", "state=onHide");
	}
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("PartyMatchMakeRoomWnd");
	return;
}

function HandlePartyMatchRoomClose()
{
	local PartyMatchWnd Script;
	local PartyMatchMakeRoomWnd script2;
	local PartyWnd Script3;

	Script = PartyMatchWnd(GetScript("PartyMatchWnd"));
	Script.SetIsInParty(false);
	Script3 = PartyWnd(GetScript("PartyWnd"));
	Script3.m_AmIRoomMaster = false;
	m_bPartyMatchRoomStart = false;
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("PartyMatchRoomWnd");
	if(m_bRequestExitPartyRoom)
	{
		Script = PartyMatchWnd(GetScript("PartyMatchWnd"));
		if((Script != none))
		{
			Script.OnRefreshBtnClick();
		}
		script2 = PartyMatchMakeRoomWnd(GetScript("PartyMatchMakeRoomWnd"));
		if((script2 != none))
		{
			script2.OnCancelButtonClick();
		}
	}
	m_bRequestExitPartyRoom = false;
	return;
}

function SetPartyAnnounceBtnEnable(bool enabled)
{
	partyAnnounceBtn.SetEnable(enabled);
	if(enabled)
	{
		partyAnnounceBtnText.SetTextColor(GetColor(255, 255, 187, 255));
	}
	else
	{
		partyAnnounceBtnText.SetTextColor(GetColor(80, 80, 80, 255));
	}
	return;
}

function UpdateMyMembershipType()
{
	local PartyWnd Script;
	local PartyMatchWaitListWnd script2;

	Script = PartyWnd(GetScript("PartyWnd"));
	script2 = PartyMatchWaitListWnd(GetScript("PartyMatchWaitListWnd"));
	KillAnnounceDelayTimer();
	switch(MyMembershipType)
	{
		case 0:
		case 2:
			Class'NWindow.UIAPI_BUTTON'.static.DisableWindow("PartyMatchRoomWnd.RoomSettingButton");
			Class'NWindow.UIAPI_BUTTON'.static.DisableWindow("PartyMatchRoomWnd.BanButton");
			Class'NWindow.UIAPI_BUTTON'.static.DisableWindow("PartyMatchRoomWnd.InviteButton");
			Class'NWindow.UIAPI_BUTTON'.static.EnableWindow("PartyMatchRoomWnd.ExitButton");
			SetPartyAnnounceBtnEnable(false);
			break;
		case 1:
			Script.m_AmIRoomMaster = true;
			Class'NWindow.UIAPI_BUTTON'.static.EnableWindow("PartyMatchRoomWnd.RoomSettingButton");
			Class'NWindow.UIAPI_BUTTON'.static.EnableWindow("PartyMatchRoomWnd.BanButton");
			Class'NWindow.UIAPI_BUTTON'.static.EnableWindow("PartyMatchRoomWnd.InviteButton");
			Class'NWindow.UIAPI_BUTTON'.static.EnableWindow("PartyMatchRoomWnd.ExitButton");
			SetPartyAnnounceBtnEnable(true);
			break;
		default:
			break;
	}
	script2.UpdateMyMembershipType(MyMembershipType);
	return;
}

function HandlePartyMatchRoomMember(string param)
{
	local int i, ClassID, Level, MemberID;
	local string memberName;
	local int MembershipType;
	local PartyMatchWaitListWnd Script;
	local int RestrictZoneCnt;
	local string RestrictZoneID;
	local int temp, j;

	Script = PartyMatchWaitListWnd(GetScript("PartyMatchWaitListWnd"));
	ParseInt(param, "MyMembershipType", MyMembershipType);
	UpdateMyMembershipType();
	Class'NWindow.UIAPI_LISTCTRL'.static.DeleteAllItem("PartyMatchRoomWnd.PartyMemberListCtrl");
	ParseInt(param, "MemberCount", CurPartyMemberCount);
	i = 0;
	while((i < CurPartyMemberCount))
	{
		ParseInt(param, ("MemberID_" $ string(i)), MemberID);
		ParseString(param, ("MemberName_" $ string(i)), memberName);
		ParseInt(param, ("ClassID_" $ string(i)), ClassID);
		ParseInt(param, ("Level_" $ string(i)), Level);
		ParseInt(param, ("MembershipType_" $ string(i)), MembershipType);
		ParseInt(param, ("RestrictZoneCnt_" $ string(i)), RestrictZoneCnt);
		if((RestrictZoneCnt == 0))
		{
			RestrictZoneID = "";
		}
		j = 0;
		while((j < RestrictZoneCnt))
		{
			ParseInt(param, ((("RestrictZoneID_" $ string(i)) $ "_") $ string(j)), temp);
			if((j != 0))
			{
				RestrictZoneID = ((RestrictZoneID $ ",") $ GetInZoneNameWithZoneID(temp));
				j++;
				continue;
			}
			RestrictZoneID = GetInZoneNameWithZoneID(temp);
			j++;
		}
		AddMember(MemberID, memberName, ClassID, Level, MembershipType, RestrictZoneID);
		++i;
	}
	UpdateData();
	if(Class'NWindow.UIAPI_WINDOW'.static.IsMinimizedWindow("PartyMatchRoomWnd"))
	{
		if(true)
		{
			Class'Interface.BottomBar'.static.Inst().SetPartyAlarmOn(true);
		}
		else
		{
			CallGFxFunction("ExpBar", "PartyMatchWndGFxEvent", "state=highlightOn");
		}
	}
	if((Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("PartyMatchRoomWnd.PartyMatchWaitListWnd") == true))
	{
		Script.OnRefreshButtonClick();
	}
	return;
}

function AddMember(int a_MemberID, string a_MemberName, int a_ClassID, int a_Level, int a_MembershipType, string a_RestrictZoneID)
{
	local LVDataRecord Record;

	Record.LVDataList.Length = 5;
	Record.LVDataList[0].nReserved1 = a_MemberID;
	Record.LVDataList[0].szData = a_MemberName;
	Record.LVDataList[1].szData = string(a_ClassID);
	Record.LVDataList[1].szTexture = GetClassRoleIconName(a_ClassID);
	Record.LVDataList[1].nTextureWidth = 11;
	Record.LVDataList[1].nTextureHeight = 11;
	Record.LVDataList[2].szData = GetAmbiguousLevelString(a_Level, true);
	switch(a_MembershipType)
	{
		case 0:
			Record.LVDataList[3].szData = GetSystemString(1061);
			break;
		case 1:
			Record.LVDataList[3].szData = GetSystemString(1062);
			break;
		case 2:
			Record.LVDataList[3].szData = GetSystemString(1063);
			break;
		default:
			break;
	}
	Record.LVDataList[4].szData = a_RestrictZoneID;
	Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord("PartyMatchRoomWnd.PartyMemberListCtrl", Record);
	return;
}

function RemoveMember(int a_MemberID)
{
	local int RecordCount, i;
	local LVDataRecord Record;

	RecordCount = m_hPartyMatchRoomWndPartyMemberListCtrl.GetRecordCount();
	i = 0;
	while((i < RecordCount))
	{
		m_hPartyMatchRoomWndPartyMemberListCtrl.GetRec(i, Record);
		if((Record.LVDataList[0].nReserved1 == a_MemberID))
		{
			m_hPartyMatchRoomWndPartyMemberListCtrl.DeleteRecord(i);
			break;
		}
		++i;
	}
	return;
}

function HandlePartyMatchRoomMemberUpdate(string param)
{
	local int UpdateType, MemberID;
	local string memberName;
	local int ClassID, Level, MembershipType;
	local UserInfo PlayerInfo;
	local PartyMatchWaitListWnd Script;
	local int RestrictZoneCnt;
	local string RestrictZoneID;
	local int temp, i;

	Script = PartyMatchWaitListWnd(GetScript("PartyMatchWaitListWnd"));
	ParseInt(param, "UpdateType", UpdateType);
	ParseInt(param, "MemberID", MemberID);
	switch(UpdateType)
	{
		case 0:
			ParseString(param, "MemberName", memberName);
			ParseInt(param, "ClassID", ClassID);
			ParseInt(param, "Level", Level);
			ParseInt(param, "MembershipType", MembershipType);
			ParseInt(param, "RestrictZoneCnt", RestrictZoneCnt);
			if((RestrictZoneCnt == 0))
			{
				RestrictZoneID = "";
			}
			i = 0;
			while((i < RestrictZoneCnt))
			{
				ParseInt(param, ("RestrictZoneID_" $ string(i)), temp);
				if((i != 0))
				{
					RestrictZoneID = ((RestrictZoneID $ ",") $ GetInZoneNameWithZoneID(temp));
					i++;
					continue;
				}
				RestrictZoneID = GetInZoneNameWithZoneID(temp);
				i++;
			}
			AddMember(MemberID, memberName, ClassID, Level, MembershipType, RestrictZoneID);
			CurPartyMemberCount = (CurPartyMemberCount + 1);
			break;
		case 1:
			ParseString(param, "MemberName", memberName);
			ParseInt(param, "ClassID", ClassID);
			ParseInt(param, "Level", Level);
			ParseInt(param, "MembershipType", MembershipType);
			ParseInt(param, "RestrictZoneCnt", RestrictZoneCnt);
			if((RestrictZoneCnt == 0))
			{
				RestrictZoneID = "";
			}
			i = 0;
			while((i < RestrictZoneCnt))
			{
				ParseInt(param, ("RestrictZoneID_" $ string(i)), temp);
				if((i != 0))
				{
					RestrictZoneID = ((RestrictZoneID $ ",") $ GetInZoneNameWithZoneID(temp));
					i++;
					continue;
				}
				RestrictZoneID = GetInZoneNameWithZoneID(temp);
				i++;
			}
			RemoveMember(MemberID);
			CurPartyMemberCount = (CurPartyMemberCount - 1);
			AddMember(MemberID, memberName, ClassID, Level, MembershipType, RestrictZoneID);
			CurPartyMemberCount = (CurPartyMemberCount + 1);
			break;
		case 2:
			RemoveMember(MemberID);
			CurPartyMemberCount = (CurPartyMemberCount - 1);
			break;
		default:
			break;
	}
	if(GetPlayerInfo(PlayerInfo))
	{
		if((PlayerInfo.nID == MemberID))
		{
			MyMembershipType = MembershipType;
			UpdateMyMembershipType();
		}
	}
	if(Class'NWindow.UIAPI_WINDOW'.static.IsMinimizedWindow("PartyMatchRoomWnd"))
	{
		if(true)
		{
			Class'Interface.BottomBar'.static.Inst().SetPartyAlarmOn(true);
		}
		else
		{
			CallGFxFunction("ExpBar", "PartyMatchWndGFxEvent", "state=highlightOn");
		}
	}
	UpdateData();
	if((Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("PartyMatchRoomWnd.PartyMatchWaitListWnd") == true))
	{
		Script.OnRefreshButtonClick();
	}
	return;
}

function HandlePartyMatchChatMessage(string param)
{
	local Color ChatColor;
	local string chatMessage;
	local int tmpType;

	ParseString(param, "Msg", chatMessage);
	ParseInt(param, "SayType", tmpType);
	ChatColor = GetChatColorByType(tmpType);
	Class'NWindow.UIAPI_TEXTLISTBOX'.static.AddString("PartyMatchRoomWnd.PartyRoomChatWindow", chatMessage, ChatColor);
	if(Class'NWindow.UIAPI_WINDOW'.static.IsMinimizedWindow("PartyMatchRoomWnd"))
	{
		PlaySound("ItemSound3.Sys_party_matching");
		if(true)
		{
			Class'Interface.BottomBar'.static.Inst().SetPartyAlarmOn(true);
		}
		else
		{
			CallGFxFunction("ExpBar", "PartyMatchWndGFxEvent", "state=highlightOn");
		}
	}
	return;
}

function UpdateData()
{
	local int minNum, maxNum;
	local PartyMatchMakeRoomWnd partyMatchMakeRoomWndHandle;

	partyMatchMakeRoomWndHandle = PartyMatchMakeRoomWnd(GetScript("PartyMatchMakeRoomWnd"));
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PartyMatchRoomWnd.RoomNumber", string(RoomNumber));
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PartyMatchRoomWnd.RoomTitle", RoomTitle);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PartyMatchRoomWnd.PartyMemberCount", ((string(CurPartyMemberCount) $ "/") $ string(MaxPartyMemberCount)));
	if(getInstanceUIData().GetIsClassicServer())
	{
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PartyMatchRoomWnd.LevelLimit", ((string(MinLevel) $ "-") $ string(MaxLevel)));
	}
	else
	{
		switch(MyMembershipType)
		{
			case 0:
			case 2:
				if((MinLevel >= getInstanceUIData().MAXLV))
				{
					MinLevel = 199;
				}
				if((MaxLevel >= getInstanceUIData().MAXLV))
				{
					MaxLevel = 199;
				}
				Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PartyMatchRoomWnd.LevelLimit", ((string(MinLevel) $ "-") $ string(MaxLevel)));
				partyMatchMakeRoomWndHandle.SetMaxLevel(MaxLevel);
				partyMatchMakeRoomWndHandle.SetMinLevel(MinLevel);
				break;
			case 1:
				if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("PartyMatchMakeRoomWnd"))
				{
					return;
				}
				minNum = int(Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchMakeRoomWnd.MinLevelEditBox"));
				maxNum = int(Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchMakeRoomWnd.MaxLevelEditBox"));
				if((minNum == 0))
				{
					minNum = 1;
				}
				if((maxNum == 0))
				{
					maxNum = 1;
				}
				if((minNum > maxNum))
				{
					maxNum = minNum;
				}
				Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PartyMatchRoomWnd.LevelLimit", ((string(minNum) $ "-") $ string(maxNum)));
				break;
			default:
				break;
		}
	}
	return;
}

function lootingMethodUpdate()
{
	local L2Util util;

	util = L2Util(GetScript("L2Util"));
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PartyMatchRoomWnd.LootingMethod", util.getLootingString(LootingMethodID));
	return;
}

function StartAnnounceDelayTimer()
{
	Me.SetTimer(1, 30000);
	SetPartyAnnounceBtnEnable(false);
	return;
}

function KillAnnounceDelayTimer()
{
	Me.KillTimer(1);
	SetPartyAnnounceBtnEnable(true);
	return;
}

function RequestPartyRoomAnnounce()
{
	if((getInstanceUIData().GetIsLiveServer() == false))
	{
		if((ChatWnd(GetScript("chatWnd")).CheckWorldFilterEnabled() == false))
		{
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(14659));
		}
		Class'Interface.UIPacket'.static.RequestUIPacket(931, _emptyByteArray);
		StartAnnounceDelayTimer();
	}
	return;
}

event OnTimer(int TimerID)
{
	if((TimerID == 1))
	{
		KillAnnounceDelayTimer();
	}
	return;
}

function OnClickButton(string a_strButtonName)
{
	switch(a_strButtonName)
	{
		case "WaitListButton":
			OnWaitListButtonClick();
			break;
		case "RoomSettingButton":
			OnRoomSettingButtonClick();
			break;
		case "BanButton":
			OnBanButtonClick();
			break;
		case "InviteButton":
			OnInviteButtonClick();
			break;
		case "ExitButton":
			OnExitButtonClick();
			break;
		case "PartyPrButton":
			RequestPartyRoomAnnounce();
			break;
		default:
			break;
	}
	return;
}

function OnWaitListButtonClick()
{
	local PartyMatchWnd Script;

	Script = PartyMatchWnd(GetScript("PartyMatchWnd"));
	if((Script != none))
	{
		Script.ToggleWaitListWnd();
		UpdateWaitListWnd();
	}
	return;
}

function OnRoomSettingButtonClick()
{
	local PartyMatchMakeRoomWnd Script;
	local int minNum, maxNum;

	Script = PartyMatchMakeRoomWnd(GetScript("PartyMatchMakeRoomWnd"));
	if((Script != none))
	{
		Script.InviteState = SETTINGCHANGE;
		Script.SetRoomNumber(RoomNumber);
		Script.SetTitle(RoomTitle);
		Script.InitMaxMemberCountComboBox();
		Script.SetMaxPartyMemberCount(MaxPartyMemberCount);
		if(getInstanceUIData().GetIsClassicServer())
		{
			Script.SetMinLevel(MinLevel);
			Script.SetMaxLevel(MaxLevel);
		}
		else
		{
			minNum = int(Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchMakeRoomWnd.MinLevelEditBox"));
			maxNum = int(Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchMakeRoomWnd.MaxLevelEditBox"));
			if((minNum == 0))
			{
				minNum = 1;
			}
			if((maxNum == 0))
			{
				maxNum = 1;
			}
			if((minNum > maxNum))
			{
				maxNum = minNum;
			}
			Script.SetMinLevel(minNum);
			Script.SetMaxLevel(maxNum);
		}
	}
	Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("PartyMatchMakeRoomWnd");
	Class'NWindow.UIAPI_WINDOW'.static.SetFocus("PartyMatchMakeRoomWnd");
	return;
}

function OnBanButtonClick()
{
	local LVDataRecord Record;

	m_hPartyMatchRoomWndPartyMemberListCtrl.GetSelectedRec(Record);
	Class'NWindow.PartyMatchAPI'.static.RequestBanFromPartyRoom(Record.LVDataList[0].nReserved1);
	return;
}

function OnInviteButtonClick()
{
	local LVDataRecord Record;

	m_hPartyMatchRoomWndPartyMemberListCtrl.GetSelectedRec(Record);
	RequestInviteParty(Record.LVDataList[0].szData);
	return;
}

function OnExitButtonClick()
{
	ExitPartyRoom();
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("PartyMatchRoomWnd");
	return;
}

function OnCompleteEditBox(string strID)
{
	local string ChatMsg;

	if((strID == "PartyRoomChatEditBox"))
	{
		ChatMsg = Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchRoomWnd.PartyRoomChatEditBox");
		ProcessPartyMatchChatMessage(SPT_PARTY_ROOM_CHAT, ChatMsg);
		Class'NWindow.UIAPI_EDITBOX'.static.SetString("PartyMatchRoomWnd.PartyRoomChatEditBox", "");
	}
	return;
}

function OnChatMarkedEditBox(string strID)
{
	local Color ChatColor;

	if((strID == "PartyRoomChatEditBox"))
	{
		ChatColor.R = 176;
		ChatColor.G = 155;
		ChatColor.B = 121;
		ChatColor.A = 255;
		Class'NWindow.UIAPI_TEXTLISTBOX'.static.AddString("PartyMatchRoomWnd.PartyRoomChatWindow", GetSystemMessage(966), ChatColor);
	}
	return;
}

defaultproperties
{
	m_Windowname="PartyMatchRoomWnd"
}
