class PartyMatchOutWaitListWnd extends PartyMatchWndCommon;

const minLv = 1;

var int entire_page;
var int current_page;
var int MinLevel;
var int MaxLevel;
var string m_Windowname;
var ListCtrlHandle m_hPartyMatchOutWaitListWndWaitListCtrl;
var ComboBoxHandle JobFilterComboBox;
var string strName;
var int Job;
var ButtonHandle searchBtn;

function OnRegisterEvent()
{
	RegisterEvent(1610);
	RegisterEvent(1620);
	RegisterEvent(40);
	RegisterEvent(8000);
	RegisterEvent(9750);
	return;
}

function OnLoad()
{
	local int MAX_LEVEL;

	entire_page = 1;
	current_page = 1;
	Class'NWindow.UIAPI_EDITBOX'.static.SetString("PartyMatchOutWaitListWnd.MinLevel", "1");
	if(getInstanceUIData().GetIsClassicServer())
	{
		MAX_LEVEL = getInstanceUIData().MAXLV;
	}
	else
	{
		MAX_LEVEL = 199;
	}
	Class'NWindow.UIAPI_EDITBOX'.static.SetString("PartyMatchOutWaitListWnd.MaxLevel", string(MAX_LEVEL));
	m_hPartyMatchOutWaitListWndWaitListCtrl = GetListCtrlHandle((m_Windowname $ ".WaitListCtrl"));
	searchBtn = GetButtonHandle("PartyMatchOutWaitListWnd.btn_Search");
	JobFilterComboBox = GetComboBoxHandle("PartyMatchOutWaitListWnd.Job");
	return;
}

function setRoleStringJobCombox()
{
	local int i;

	JobFilterComboBox.Clear();
	JobFilterComboBox.AddStringWithReserved(GetSystemString(1046), 0);
	if(getInstanceUIData().GetIsLiveServer())
	{
		i = 1;
		while((i <= 9))
		{
			JobFilterComboBox.AddStringWithReserved(GetClassRoleNameByRole(int(byte(i))), i);
			i++;
		}
	}
	return;
}

function OnShow()
{
	current_page = 1;
	Class'NWindow.UIAPI_EDITBOX'.static.SetFocus("PartyMatchOutWaitListWnd.MaxLevel");
	return;
}

function OnEvent(int a_EventID, string param)
{
	local int MAX_LEVEL;

	switch(a_EventID)
	{
		case 9750:
			setRoleStringJobCombox();
			break;
		case 1610:
			HandlePartyMatchWaitListStart(param);
			break;
		case 1620:
			HandlePartyMatchWaitList(param);
			break;
		case 40:
			HandleRestart();
			break;
		case 8000:
			if(getInstanceUIData().GetIsClassicServer())
			{
				MAX_LEVEL = GetMaxLevel();
			}
			else
			{
				MAX_LEVEL = 199;
			}
			Class'NWindow.UIAPI_EDITBOX'.static.SetString("PartyMatchOutWaitListWnd.MaxLevel", string(MAX_LEVEL));
			break;
		default:
			break;
	}
	return;
}

function HandleRestart()
{
	Class'NWindow.UIAPI_EDITBOX'.static.SetString("PartyMatchOutWaitListWnd.Name", "");
	return;
}

function HandlePartyMatchWaitListStart(string param)
{
	local int AllCount, Count;
	local string totalPages, currentPage, page_info;

	ParseInt(param, "AllCount", AllCount);
	ParseInt(param, "Count", Count);
	totalPages = string(((AllCount / 64) + 1));
	entire_page = ((AllCount / 64) + 1);
	currentPage = string(current_page);
	page_info = ((currentPage $ "/") $ totalPages);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PartyMatchOutWaitListWnd.MemberCount", page_info);
	Class'NWindow.UIAPI_LISTCTRL'.static.DeleteAllItem("PartyMatchOutWaitListWnd.WaitListCtrl");
	CheckButtonAlive();
	return;
}

function HandlePartyMatchWaitList(string param)
{
	local string Name;
	local int ClassID, Level;
	local LVDataRecord Record;
	local int RestrictZoneCnt;
	local string RestrictZoneID;
	local int temp, i;

	RestrictZoneID = "";
	ParseString(param, "Name", Name);
	ParseInt(param, "ClassID", ClassID);
	ParseInt(param, "Level", Level);
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
	Record.LVDataList.Length = 5;
	Record.LVDataList[0].szData = Name;
	Record.LVDataList[1].szTexture = GetClassRoleIconName(ClassID);
	Record.LVDataList[1].nTextureWidth = 11;
	Record.LVDataList[1].nTextureHeight = 11;
	Record.LVDataList[1].szData = string(ClassID);
	Record.LVDataList[1].HiddenStringForSorting = string(GetClassRoleType(ClassID));
	Record.LVDataList[2].szData = GetAmbiguousLevelString(Level, false);
	Record.LVDataList[3].szData = RestrictZoneID;
	Debug((("classID, Record.LVDataList[1].szTexture " @ string(ClassID)) @ Record.LVDataList[1].szTexture));
	Record.nReserved1 = INT64(Level);
	Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord("PartyMatchOutWaitListWnd.WaitListCtrl", Record);
	return;
}

function OnClickButton(string a_strButtonName)
{
	switch(a_strButtonName)
	{
		case "RefreshButton":
			OnRefreshButtonClick();
			break;
		case "WhisperButton":
			OnWhisperButtonClick();
			break;
		case "PartyInviteButton":
			OnInviteButtonClick();
			break;
		case "CloseButton":
			OnCloseButtonClick();
			break;
		case "btn_Search":
			OnSearchBtnClick();
			break;
		case "prev_btn":
			OnPrevbuttonClick();
			break;
		case "next_btn":
			OnNextbuttonClick();
			break;
		case "btn_Reset":
			OnResetButtonClick();
		default:
			break;
	}
	return;
}

function OnRefreshButtonClick()
{
	MinLevel = int(Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchOutWaitListWnd.MinLevel"));
	MaxLevel = int(Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchOutWaitListWnd.MaxLevel"));
	Job = JobFilterComboBox.GetSelectedNum();
	strName = Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchOutWaitListWnd.Name");
	RequestPartyMatchWaitList(current_page, MinLevel, MaxLevel, Job, strName);
	return;
}

function OnNextbuttonClick()
{
	current_page = (current_page + 1);
	RequestPartyMatchWaitList(current_page, MinLevel, MaxLevel, Job, strName);
	return;
}

function OnPrevbuttonClick()
{
	current_page = (current_page - 1);
	RequestPartyMatchWaitList(current_page, MinLevel, MaxLevel, Job, strName);
	return;
}

function OnSearchBtnClick()
{
	MinLevel = int(Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchOutWaitListWnd.MinLevel"));
	MaxLevel = int(Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchOutWaitListWnd.MaxLevel"));
	Job = JobFilterComboBox.GetSelectedNum();
	strName = Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchOutWaitListWnd.Name");
	current_page = 1;
	RequestPartyMatchWaitList(current_page, MinLevel, MaxLevel, Job, strName);
	return;
}

function OnWhisperButtonClick()
{
	local LVDataRecord Record;
	local string szData1;

	m_hPartyMatchOutWaitListWndWaitListCtrl.GetSelectedRec(Record);
	szData1 = Record.LVDataList[0].szData;
	if((szData1 != ""))
	{
		SetChatMessage((("\"" $ szData1) $ " "));
	}
	return;
}

function OnInviteButtonClick()
{
	local LVDataRecord Record;

	m_hPartyMatchOutWaitListWndWaitListCtrl.GetSelectedRec(Record);
	MakeRoomFirst(int(Record.nReserved1), Record.LVDataList[0].szData);
	return;
}

function OnCloseButtonClick()
{
	local PartyMatchWnd Script;

	Script = PartyMatchWnd(GetScript("PartyMatchWnd"));
	if((Script != none))
	{
		Script.SetWaitListWnd(false);
		Script.ShowHideWaitListWnd();
	}
	return;
}

function OnDBClickListCtrlRecord(string a_ListCtrlName)
{
	local LVDataRecord Record;

	if((a_ListCtrlName != "WaitListCtrl"))
	{
		return;
	}
	m_hPartyMatchOutWaitListWndWaitListCtrl.GetSelectedRec(Record);
	SetChatMessage((("\"" $ Record.LVDataList[0].szData) $ " "));
	return;
}

function OnResetButtonClick()
{
	local int MAX_LEVEL;

	Class'NWindow.UIAPI_EDITBOX'.static.SetString("PartyMatchOutWaitListWnd.MinLevel", string(1));
	if(getInstanceUIData().GetIsClassicServer())
	{
		MAX_LEVEL = getInstanceUIData().MAXLV;
	}
	else
	{
		MAX_LEVEL = 199;
	}
	Class'NWindow.UIAPI_EDITBOX'.static.SetString("PartyMatchOutWaitListWnd.MaxLevel", string(MAX_LEVEL));
	JobFilterComboBox.SetSelectedNum(0);
	Class'NWindow.UIAPI_EDITBOX'.static.SetString("PartyMatchOutWaitListWnd.Name", "");
	MinLevel = 1;
	MaxLevel = getInstanceUIData().MAXLV;
	Job = 0;
	strName = "";
	return;
}

function OnButtonTimer(bool bExpired)
{
	return;
}

function MakeRoomFirst(int TargetLevel, string InviteTargetName)
{
	local PartyMatchMakeRoomWnd Script;
	local UserInfo PlayerInfo;
	local int LevelMin, LevelMax, MAX_LEVEL;

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
		Script.InviteState = INVITE_MAKEROOM;
		Script.InvitedName = InviteTargetName;
		Script.SetRoomNumber(0);
		Script.SetTitle(GetSystemMessage(1398));
		Script.InitMaxMemberCountComboBox();
		if(GetPlayerInfo(PlayerInfo))
		{
			if((TargetLevel < PlayerInfo.nLevel))
			{
				LevelMin = TargetLevel;
				LevelMax = PlayerInfo.nLevel;
			}
			else
			{
				LevelMin = PlayerInfo.nLevel;
				LevelMax = TargetLevel;
			}
			if(((LevelMin - 5) > 0))
			{
				Script.SetMinLevel((LevelMin - 5));
			}
			else
			{
				Script.SetMinLevel(1);
			}
			if(((LevelMax + 5) <= MAX_LEVEL))
			{
				Script.SetMaxLevel((LevelMax + 5));
			}
			else
			{
				Script.SetMaxLevel(MAX_LEVEL);
			}
		}
	}
	Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("PartyMatchMakeRoomWnd");
	Class'NWindow.UIAPI_WINDOW'.static.SetFocus("PartyMatchMakeRoomWnd");
	return;
}

function CheckButtonAlive()
{
	Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("PartyMatchOutWaitListWnd.prev_btn");
	Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("PartyMatchOutWaitListWnd.next_btn");
	if((current_page == 1))
	{
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("PartyMatchOutWaitListWnd.prev_btn");
	}
	if((current_page == entire_page))
	{
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("PartyMatchOutWaitListWnd.next_btn");
	}
	return;
}

defaultproperties
{
	m_Windowname="PartyMatchOutWaitListWnd"
}
