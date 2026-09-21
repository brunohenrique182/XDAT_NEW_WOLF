class OlympiadArenaListWnd extends UICommonAPI;

const TIMER_ID = 148;
const TIMER_DELAY = 3000;

struct playerDataStruct
{
	var int Num;
	var int arenaType;
	var int arenaState;
	var string player1Name;
	var string player2Name;
};

var string m_Windowname;
var WindowHandle Me;
var ListCtrlHandle ListCtrl;
var ButtonHandle RefreshButton;

function OnRegisterEvent()
{
	RegisterEvent(5080);
	return;
}

function OnLoad()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	SetClosingOnESC();
	ListCtrl = GetListCtrlHandle((m_Windowname $ ".OlympiadArenaList_ListCtrl"));
	ListCtrl.SetColumnMinimumWidth(true);
	RefreshButton = GetButtonHandle((m_Windowname $ ".refresh_Button"));
	return;
}

function OnEvent(int Event_ID, string a_Param)
{
	switch(Event_ID)
	{
		case 5080:
			HandleRoomLists(a_Param);
			Me.SetFocus();
			break;
		default:
			break;
	}
	return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
	local LVDataRecord Record;

	if((ListCtrl.GetSelectedIndex() >= 0))
	{
		ListCtrl.GetSelectedRec(Record);
		Debug(("onDBClick" @ string(Record.nReserved1)));
		Class'NWindow.OlympiadAPI'.static.RequestExOlympiadWatchGame(int(Record.nReserved1));
	}
	return;
}

function OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case 148:
			RefreshButton.EnableWindow();
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "close_Button":
			GetWindowHandle(m_Windowname).HideWindow();
			break;
		case "refresh_Button":
			HandleRefresh();
			break;
		default:
			break;
	}
	return;
}

function OnHide()
{
	ListCtrl.DeleteAllItem();
	return;
}

function HandleRefresh()
{
	ListCtrl.DeleteAllItem();
	Class'NWindow.OlympiadAPI'.static.RequestOlympiadMatchList();
	RefreshButton.DisableWindow();
	Me.SetTimer(148, 3000);
	return;
}

function HandleRoomLists(string a_Param)
{
	local playerDataStruct playerData;
	local int gameNum, i, bRemain;

	ListCtrl.DeleteAllItem();
	ParseInt(a_Param, "gameNum", gameNum);
	ParseInt(a_Param, "bRemain", bRemain);
	i = 0;
	while((i < gameNum))
	{
		ParseInt(a_Param, ("num_" $ string(i)), playerData.Num);
		ParseInt(a_Param, ("arenaType_" $ string(i)), playerData.arenaType);
		ParseInt(a_Param, ("arenaState_" $ string(i)), playerData.arenaState);
		ParseString(a_Param, ("player1Name_" $ string(i)), playerData.player1Name);
		ParseString(a_Param, ("player2Name_" $ string(i)), playerData.player2Name);
		HandleRoomList(playerData);
		i++;
	}
	if((bRemain == 0))
	{
		Me.ShowWindow();
	}
	return;
}

function HandleRoomList(playerDataStruct playerData)
{
	local LVDataRecord Record;

	Record.LVDataList.Length = 5;
	Record.nReserved1 = INT64((playerData.Num + 1));
	Record.LVDataList[0].szData = string(Record.nReserved1);
	Record.LVDataList[0].textAlignment = TA_Center;
	if((playerData.arenaType < 3))
	{
		Record.LVDataList[1].szData = GetSystemString((2283 - playerData.arenaType));
	}
	else
	{
		Record.LVDataList[1].szData = "";
	}
	Record.LVDataList[1].textAlignment = TA_Center;
	if((playerData.arenaState == 0))
	{
		Record.LVDataList[2].szData = GetSystemString(906);
	}
	else
	{
		Record.LVDataList[2].szData = GetSystemString((1717 + playerData.arenaState));
	}
	Record.LVDataList[2].textAlignment = TA_Center;
	Record.LVDataList[3].bUseTextColor = true;
	Record.LVDataList[3].szData = playerData.player1Name;
	Record.LVDataList[3].textAlignment = TA_Center;
	Record.LVDataList[3].TextColor.R = 238;
	Record.LVDataList[3].TextColor.G = 119;
	Record.LVDataList[3].TextColor.B = 119;
	Record.LVDataList[4].bUseTextColor = true;
	Record.LVDataList[4].szData = playerData.player2Name;
	Record.LVDataList[4].textAlignment = TA_Center;
	Record.LVDataList[4].TextColor.R = 102;
	Record.LVDataList[4].TextColor.G = 170;
	Record.LVDataList[4].TextColor.B = 238;
	ListCtrl.InsertRecord(Record);
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}
