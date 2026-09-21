class MysteriousMansionResultWnd extends UICommonAPI;

const TIMER_ID = 148;
const TIMER_DELAY = 20000;

struct ResultDataStruct
{
	var string UserName;
	var int ClassID;
	var int LifeTimeInSec;
	var int KillCnt;
};

var string m_Windowname;
var WindowHandle Me;
var ListCtrlHandle ListCtrl;
var string userFakeName;

function OnRegisterEvent()
{
	RegisterEvent(9370);
	RegisterEvent(9380);
	RegisterEvent(9381);
	RegisterEvent(9382);
	RegisterEvent(9341);
	return;
}

function OnLoad()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	SetClosingOnESC();
	ListCtrl = GetListCtrlHandle((m_Windowname $ ".Result_ListCtrl"));
	ListCtrl.SetColumnMinimumWidth(true);
	return;
}

function OnEvent(int Event_ID, string a_Param)
{
	switch(Event_ID)
	{
		case 9341:
			HandleMemberList(a_Param);
			break;
		case 9370:
			HandleResultIsVictory(a_Param);
			break;
		case 9380:
			ListCtrl.DeleteAllItem();
			break;
		case 9381:
			HandleResultList(a_Param);
			break;
		case 9382:
			Me.ShowWindow();
			break;
		default:
			break;
	}
	return;
}

function OnShow()
{
	Me.SetTimer(148, 20000);
	return;
}

function OnHide()
{
	Me.KillTimer(148);
	return;
}

function OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case 148:
			Me.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string strID)
{
	Me.HideWindow();
	return;
}

function HandleMemberList(string a_Param)
{
	local UserInfo UserInfo;
	local int ServerID;

	ParseInt(a_Param, "ServerID", ServerID);
	if(GetPlayerInfo(UserInfo))
	{
		if((UserInfo.nID == ServerID))
		{
			ParseString(a_Param, "UserName", userFakeName);
		}
	}
	return;
}

function HandleResultIsVictory(string a_Param)
{
	local int isVictory;

	ParseInt(a_Param, "isVictory", isVictory);
	switch(isVictory)
	{
		case 0:
			GetTextBoxHandle((m_Windowname $ ".resultTxt")).SetText(GetSystemString(846));
			break;
		case 1:
			GetTextBoxHandle((m_Windowname $ ".resultTxt")).SetText(GetSystemString(828));
			break;
		case 2:
			GetTextBoxHandle((m_Windowname $ ".resultTxt")).SetText(GetSystemString(2356));
			break;
		default:
			break;
	}
	return;
}

function HandleResultList(string a_Param)
{
	local UserInfo UserInfo;
	local ResultDataStruct resultData;
	local LVDataRecord Record;

	ParseString(a_Param, "UserName", resultData.UserName);
	ParseInt(a_Param, "ClassID", resultData.ClassID);
	ParseInt(a_Param, "LifeTimeInSec", resultData.LifeTimeInSec);
	ParseInt(a_Param, "KillCnt", resultData.KillCnt);
	if((userFakeName == resultData.UserName))
	{
		if(GetPlayerInfo(UserInfo))
		{
			resultData.UserName = UserInfo.Name;
		}
		GetTextBoxHandle((m_Windowname $ ".ResultMyName_Text")).SetText(resultData.UserName);
		GetTextBoxHandle((m_Windowname $ ".ResultMyClass_Text")).SetText(GetClassType(resultData.ClassID));
		GetTextBoxHandle((m_Windowname $ ".ResultMyTime_Text")).SetText((string(resultData.LifeTimeInSec) @ GetSystemString(2001)));
		GetTextBoxHandle((m_Windowname $ ".ResultMyKill_Text")).SetText(string(resultData.KillCnt));
	}
	Record.LVDataList.Length = 4;
	Record.LVDataList[0].szData = resultData.UserName;
	Record.LVDataList[1].szData = GetClassType(resultData.ClassID);
	Record.LVDataList[2].szData = string(resultData.KillCnt);
	Record.LVDataList[2].textAlignment = TA_Center;
	Record.LVDataList[3].szData = (string(resultData.LifeTimeInSec) @ GetSystemString(2001));
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
