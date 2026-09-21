class BlockEnterWnd extends UICommonAPI;

const TeamRed_ID = 1;
const TeamBlue_ID = 0;
const TIMER_ID = 1026;
const TIMER_DELAY = 1000;
const DIALOG_ID_VOTE_REQUEST = 0;

var WindowHandle Me;
var TextBoxHandle TeamRed;
var TextBoxHandle TeamBlue;
var TextBoxHandle TeamRedTotal;
var TextBoxHandle TeamBlueTotal;
var TextBoxHandle RemainSecTitle;
var TextBoxHandle RemainSec;
var TextBoxHandle TeamRedTotalTitle;
var TextBoxHandle TeamBlueTotalTitle;
var ListCtrlHandle TeamRedList;
var ListCtrlHandle TeamBlueList;
var TextureHandle CountGroupBox;
var TextureHandle TeamRedListGroupBox;
var TextureHandle TeamBlueListGroupBox;
var TextureHandle TeamRedListBDECO;
var TextureHandle TeamBlueListBDECO;
var ButtonHandle btnExit;
var int RoomNumber;
var int RemainStartSec;
var bool ShowTime;

function OnRegisterEvent()
{
	RegisterEvent(3830);
	RegisterEvent(3840);
	RegisterEvent(3850);
	RegisterEvent(3860);
	RegisterEvent(3820);
	RegisterEvent(3870);
	RegisterEvent(3880);
	RegisterEvent(1710);
	RegisterEvent(1720);
	return;
}

function OnLoad()
{
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	if((1 == 0))
	{
		Initialize();
	}
	else
	{
		InitializeCOD();
	}
	RoomNumber = 0;
	RemainStartSec = 10;
	ResetUI();
	return;
}

function OnShow()
{
	local Color A, B;

	B.R = 114;
	B.G = 173;
	B.B = 255;
	A.R = 254;
	A.G = 114;
	A.B = 66;
	TeamRed.SetTextColor(A);
	TeamBlue.SetTextColor(B);
	Me.SetTimer(1026, 1000);
	setWindowTitleByString((string((RoomNumber + 1)) $ GetSystemString(2016)));
	ShowTime = false;
	return;
}

function OnHide()
{
	Me.KillTimer(1026);
	Class'NWindow.TeamMatchAPI'.static.RequestExBlockGameEnter(RoomNumber, -1);
	ResetUI();
	return;
}

function Initialize()
{
	Me = GetHandle("BlockEnterWnd");
	TeamRed = TextBoxHandle(GetHandle("TeamRed"));
	TeamBlue = TextBoxHandle(GetHandle("TeamBlue"));
	TeamRedTotal = TextBoxHandle(GetHandle("TeamRedTotal"));
	TeamBlueTotal = TextBoxHandle(GetHandle("TeamBlueTotal"));
	RemainSecTitle = TextBoxHandle(GetHandle("RemainSecTitle"));
	RemainSec = TextBoxHandle(GetHandle("RemainSec"));
	TeamRedTotalTitle = TextBoxHandle(GetHandle("TeamRedTotalTitle"));
	TeamBlueTotalTitle = TextBoxHandle(GetHandle("TeamBlueTotalTitle"));
	TeamRedList = ListCtrlHandle(GetHandle("TeamRedList"));
	TeamBlueList = ListCtrlHandle(GetHandle("TeamBlueList"));
	CountGroupBox = TextureHandle(GetHandle("CountGroupBox"));
	TeamRedListGroupBox = TextureHandle(GetHandle("TeamRedListGroupBox"));
	TeamBlueListGroupBox = TextureHandle(GetHandle("TeamBlueListGroupBox"));
	TeamRedListBDECO = TextureHandle(GetHandle("TeamRedListBDECO"));
	TeamBlueListBDECO = TextureHandle(GetHandle("TeamBlueListBDECO"));
	btnExit = ButtonHandle(GetHandle("btnExit"));
	return;
}

function InitializeCOD()
{
	Me = GetWindowHandle("BlockEnterWnd");
	TeamRed = GetTextBoxHandle("BlockEnterWnd.TeamRed");
	TeamBlue = GetTextBoxHandle("BlockEnterWnd.TeamBlue");
	TeamRedTotal = GetTextBoxHandle("BlockEnterWnd.TeamRedTotal");
	TeamBlueTotal = GetTextBoxHandle("BlockEnterWnd.TeamBlueTotal");
	RemainSecTitle = GetTextBoxHandle("BlockEnterWnd.RemainSecTitle");
	RemainSec = GetTextBoxHandle("BlockEnterWnd.RemainSec");
	TeamRedTotalTitle = GetTextBoxHandle("BlockEnterWnd.TeamRedTotalTitle");
	TeamBlueTotalTitle = GetTextBoxHandle("BlockEnterWnd.TeamBlueTotalTitle");
	TeamRedList = GetListCtrlHandle("BlockEnterWnd.TeamRedList");
	TeamBlueList = GetListCtrlHandle("BlockEnterWnd.TeamBlueList");
	CountGroupBox = GetTextureHandle("BlockEnterWnd.CountGroupBox");
	TeamRedListGroupBox = GetTextureHandle("BlockEnterWnd.TeamRedListGroupBox");
	TeamBlueListGroupBox = GetTextureHandle("BlockEnterWnd.TeamBlueListGroupBox");
	TeamRedListBDECO = GetTextureHandle("BlockEnterWnd.TeamRedListBDECO");
	TeamBlueListBDECO = GetTextureHandle("BlockEnterWnd.TeamBlueListBDECO");
	btnExit = GetButtonHandle("btnExit");
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 3830:
			HandleBlockListStart(param);
			break;
		case 3840:
			HandleBlockListAdd(param);
			break;
		case 3850:
			HandleBlockListRemove(param);
			break;
		case 3860:
			HandleBlockListClose();
			break;
		case 3820:
			HandleBlockRemainTime(param);
			break;
		case 3870:
			HandleStartVote();
			break;
		case 3880:
			ShowTime = true;
			break;
		case 1710:
			HandleDialogOK();
			break;
		case 1720:
			HandleDialogCancel();
			break;
		default:
			break;
	}
	return;
}

function ResetUI()
{
	TeamRedList.DeleteAllItem();
	TeamRedTotal.SetText("0");
	TeamBlueList.DeleteAllItem();
	TeamBlueTotal.SetText("0");
	return;
}

function HandleBlockListStart(string param)
{
	ParseInt(param, "RoomNumber", RoomNumber);
	if(!Me.IsShowWindow())
	{
		Me.ShowWindow();
		Me.SetFocus();
	}
	ResetUI();
	return;
}

function HandleBlockListAdd(string param)
{
	local int TeamID, PlayerID;
	local string PlayerName;
	local LVData data1, data2;
	local LVDataRecord Record1, Record2;

	ParseInt(param, "TeamID", TeamID);
	ParseInt(param, "PlayerID", PlayerID);
	ParseString(param, "PlayerName", PlayerName);
	if((TeamID == 1))
	{
		data1.nReserved1 = TeamID;
		data1.nReserved2 = PlayerID;
		data1.szData = PlayerName;
		Record1.LVDataList[0] = data1;
		TeamRedList.InsertRecord(Record1);
		TeamRedTotal.SetText(string(TeamRedList.GetRecordCount()));
	}
	else if((TeamID == 0))
	{
		data2.nReserved1 = TeamID;
		data2.nReserved2 = PlayerID;
		data2.szData = PlayerName;
		Record2.LVDataList[0] = data2;
		TeamBlueList.InsertRecord(Record2);
		TeamBlueTotal.SetText(string(TeamBlueList.GetRecordCount()));
	}
	return;
}

function HandleBlockListRemove(string param)
{
	local int TeamID, PlayerID, Count;
	local LVDataRecord Record1, Record2;

	ParseInt(param, "TeamID", TeamID);
	ParseInt(param, "PlayerID", PlayerID);
	if((TeamID == 1))
	{
		Count = 0;
		while((Count < TeamRedList.GetRecordCount()))
		{
			TeamRedList.GetRec(Count, Record1);
			if((PlayerID == Record1.LVDataList[0].nReserved2))
			{
				if((Count >= 0))
				{
					TeamRedList.DeleteRecord(Count);
					TeamRedTotal.SetText(string(TeamRedList.GetRecordCount()));
				}
				break;
			}
			Count++;
		}
	}
	if((TeamID == 0))
	{
		Count = 0;
		while((Count < TeamBlueList.GetRecordCount()))
		{
			TeamBlueList.GetRec(Count, Record2);
			if((PlayerID == Record2.LVDataList[0].nReserved2))
			{
				if((Count >= 0))
				{
					TeamBlueList.DeleteRecord(Count);
					TeamBlueTotal.SetText(string(TeamBlueList.GetRecordCount()));
				}
				break;
			}
			Count++;
		}
	}
	return;
}

function HandleBlockListClose()
{
	local string InSecStr;

	InSecStr = " ";
	RemainSec.SetText(InSecStr);
	Me.HideWindow();
	ResetUI();
	ShowTime = false;
	return;
}

function HandleBlockRemainTime(string param)
{
	ParseInt(param, "RemainTime", RemainStartSec);
	return;
}

function OnLButtonUp(WindowHandle WindowHandle, int X, int Y)
{
	switch(WindowHandle)
	{
		case TeamBlueList:
			Class'NWindow.TeamMatchAPI'.static.RequestExBlockGameEnter(RoomNumber, 0);
			break;
		case TeamRedList:
			Class'NWindow.TeamMatchAPI'.static.RequestExBlockGameEnter(RoomNumber, 1);
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string ButtonID)
{
	switch(ButtonID)
	{
		case "btnExit":
			if(Me.IsShowWindow())
			{
				Me.HideWindow();
			}
			Class'NWindow.TeamMatchAPI'.static.RequestExBlockGameEnter(RoomNumber, -1);
			break;
		default:
			break;
	}
	return;
}

function OnTimer(int TimerID)
{
	if((TimerID == 1026))
	{
		if(ShowTime)
		{
			if((RemainStartSec > 0))
			{
				RemainStartSec--;
				UpdateTimerCount();
			}
		}
	}
	return;
}

function HandleStartVote()
{
	if(IsShowWindow("DialogBox"))
	{
		Class'NWindow.TeamMatchAPI'.static.RequestExBlockGameVote(RoomNumber, 0);
		return;
	}
	DialogSetID(0);
	DialogSetCancelD(0);
	DialogSetParamInt64(INT64((10 * 1000)));
	DialogSetDefaultOK();
	DialogShow(DialogModalType_Modalless, DialogType_Progress, GetSystemMessage(2467));
	return;
}

function HandleDialogOK()
{
	if(DialogIsMine())
	{
		if((DialogGetID() == 0))
		{
			Class'NWindow.TeamMatchAPI'.static.RequestExBlockGameVote(RoomNumber, 1);
		}
	}
	return;
}

function HandleDialogCancel()
{
	if(DialogIsMine())
	{
		if(DialogCheckCancelByID(0))
		{
			Class'NWindow.TeamMatchAPI'.static.RequestExBlockGameVote(RoomNumber, 0);
		}
	}
	return;
}

function UpdateTimerCount()
{
	local string SecStr;

	SecStr = string(RemainStartSec);
	if((RemainStartSec < 10))
	{
		SecStr = (("0" $ SecStr) $ GetSystemString(2001));
	}
	RemainSec.SetText(SecStr);
	return;
}
