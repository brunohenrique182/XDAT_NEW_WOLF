class MysteriousMansionRoomListWnd extends UICommonAPI;

const TIMER_ID = 148;
const TIMER_DELAY = 3000;

struct roomDataStruct
{
	var int Id;
	var string HouseName;
	var int State;
	var int Count;
};

var string m_Windowname;
var WindowHandle Me;
var ListCtrlHandle ListCtrl;
var ButtonHandle RefreshButton;

function OnRegisterEvent()
{
	RegisterEvent(9390);
	RegisterEvent(9391);
	RegisterEvent(9392);
	return;
}

function OnLoad()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	SetClosingOnESC();
	ListCtrl = GetListCtrlHandle((m_Windowname $ ".RoomList_ListCtrl"));
	ListCtrl.SetColumnMinimumWidth(true);
	RefreshButton = GetButtonHandle((m_Windowname $ ".refresh_Button"));
	return;
}

function OnEvent(int Event_ID, string a_Param)
{
	switch(Event_ID)
	{
		case 9390:
			ListCtrl.DeleteAllItem();
			break;
		case 9391:
			HandleRoomList(a_Param);
			break;
		case 9392:
			GetWindowHandle(m_Windowname).ShowWindow();
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
		RequestObservingCuriousHouse(int(Record.nReserved1));
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

function HandleRefresh()
{
	RefreshButton.DisableWindow();
	Me.SetTimer(148, 3000);
	RequestObservingListCuriousHouse();
	return;
}

function HandleRoomList(string a_Param)
{
	local roomDataStruct roomData;
	local LVDataRecord Record;

	ParseInt(a_Param, "ID", roomData.Id);
	ParseString(a_Param, "HouseName", roomData.HouseName);
	ParseInt(a_Param, "State", roomData.State);
	ParseInt(a_Param, "Count", roomData.Count);
	if((roomData.Count <= 0))
	{
		return;
	}
	Record.LVDataList.Length = 4;
	Record.nReserved1 = INT64(roomData.Id);
	Record.LVDataList[0].szData = string((ListCtrl.GetRecordCount() + 1));
	Record.LVDataList[0].textAlignment = TA_Center;
	Record.LVDataList[1].szData = (GetSystemString(2806) $ roomData.HouseName);
	Record.LVDataList[1].textAlignment = TA_Center;
	if((roomData.State == 0))
	{
		Record.LVDataList[2].szData = GetSystemString(1718);
	}
	else
	{
		Record.LVDataList[2].szData = GetSystemString(1719);
	}
	Record.LVDataList[2].textAlignment = TA_Center;
	Record.LVDataList[3].szData = string(roomData.Count);
	Record.LVDataList[3].textAlignment = TA_Center;
	ListCtrl.InsertRecord(Record);
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}
