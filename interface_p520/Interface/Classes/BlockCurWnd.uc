class BlockCurWnd extends UICommonAPI;

const TeamRed_ID = 1;
const TeamBlue_ID = 0;

var WindowHandle Me;
var TextBoxHandle TeamRedPoint;
var TextBoxHandle TeamBluePoint;
var TextBoxHandle TeamRed;
var TextBoxHandle TeamBlue;
var TextBoxHandle RemainSecTitle;
var TextBoxHandle RemainSec;
var TextBoxHandle TeamRedTotal;
var TextBoxHandle TeamBlueTotal;
var ListCtrlHandle TeamRedList;
var ListCtrlHandle TeamBlueList;
var ButtonHandle btnClose;
var TextureHandle TeamRedResult;
var TextureHandle TeamBlueResult;
var TextureHandle TeamBlueWin;
var TextureHandle TeamRedListGroupBox;
var TextureHandle TeamBlueListGroupBox;
var TextureHandle CountGroupBox;
var TextureHandle TeamRedListDeco;
var TextureHandle TeamBlueListDeco;
var int TotalCountA;
var int TotalCountB;
var int RoomNumber;
var WindowHandle BlockCounter;

function OnRegisterEvent()
{
	RegisterEvent(3890);
	RegisterEvent(3900);
	RegisterEvent(3910);
	RegisterEvent(3830);
	RegisterEvent(3840);
	RegisterEvent(3850);
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
	Me.HideWindow();
	RoomNumber = 0;
	ResetUI();
	return;
}

function OnShow()
{
	return;
}

function Initialize()
{
	Me = GetHandle("BlockCurWnd");
	TeamRedPoint = TextBoxHandle(GetHandle("TeamRedPoint"));
	TeamBluePoint = TextBoxHandle(GetHandle("TeamBluePoint"));
	TeamRed = TextBoxHandle(GetHandle("TeamRed"));
	TeamBlue = TextBoxHandle(GetHandle("TeamBlue"));
	RemainSecTitle = TextBoxHandle(GetHandle("RemainSecTitle"));
	RemainSec = TextBoxHandle(GetHandle("RemainSec"));
	TeamRedList = ListCtrlHandle(GetHandle("TeamRedList"));
	TeamBlueList = ListCtrlHandle(GetHandle("TeamBlueList"));
	btnClose = ButtonHandle(GetHandle("btnClose"));
	TeamRedResult = TextureHandle(GetHandle("TeamRedResult"));
	TeamBlueResult = TextureHandle(GetHandle("TeamBlueResult"));
	TeamBlueWin = TextureHandle(GetHandle("TeamBlueWin"));
	TeamRedListGroupBox = TextureHandle(GetHandle("TeamRedListGroupBox"));
	TeamBlueListGroupBox = TextureHandle(GetHandle("TeamBlueListGroupBox"));
	TeamRedListDeco = TextureHandle(GetHandle("TeamRedListDeco"));
	TeamBlueListDeco = TextureHandle(GetHandle("TeamBlueListDeco"));
	BlockCounter = GetHandle("BlockCounter");
	return;
}

function InitializeCOD()
{
	Me = GetWindowHandle("BlockCurWnd.BlockCurWnd");
	TeamRedPoint = GetTextBoxHandle("BlockCurWnd.TeamRedPoint");
	TeamBluePoint = GetTextBoxHandle("BlockCurWnd.TeamBluePoint");
	TeamRed = GetTextBoxHandle("BlockCurWnd.TeamRed");
	TeamBlue = GetTextBoxHandle("BlockCurWnd.TeamBlue");
	RemainSecTitle = GetTextBoxHandle("BlockCurWnd.RemainSecTitle");
	RemainSec = GetTextBoxHandle("BlockCurWnd.RemainSec");
	TeamRedList = GetListCtrlHandle("BlockCurWnd.TeamRedList");
	TeamBlueList = GetListCtrlHandle("BlockCurWnd.TeamBlueList");
	btnClose = GetButtonHandle("BlockCurWnd.btnClose");
	TeamRedResult = GetTextureHandle("BlockCurWnd.TeamRedResult");
	TeamBlueResult = GetTextureHandle("BlockCurWnd.TeamBlueResult");
	TeamBlueWin = GetTextureHandle("BlockCurWnd.TeamBlueWin");
	TeamRedListGroupBox = GetTextureHandle("BlockCurWnd.TeamRedListGroupBox");
	TeamBlueListGroupBox = GetTextureHandle("BlockCurWnd.TeamBlueListGroupBox");
	TeamRedListDeco = GetTextureHandle("BlockCurWnd.TeamRedListDeco");
	TeamBlueListDeco = GetTextureHandle("BlockCurWnd.TeamBlueListDeco");
	BlockCounter = GetWindowHandle("BlockCounter");
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 3890:
			HandleBlockStateTeam(a_Param);
			break;
		case 3900:
			HandleBlockStatePlayer(a_Param);
			break;
		case 3910:
			HandleBlockStateResult(a_Param);
			break;
		case 3830:
			HandleBlockListStart(a_Param);
			break;
		case 3840:
			HandleBlockListAdd(a_Param);
			break;
		case 3850:
			HandleBlockListRemove(a_Param);
			break;
		default:
			break;
	}
	return;
}

function HandleBlockListStart(string param)
{
	ParseInt(param, "RoomNumber", RoomNumber);
	ResetUI();
	return;
}

function HandleBlockStateTeam(string param)
{
	local int TeamID, TeamScore, RemainSec;

	BlockCounter.ShowWindow();
	ParseInt(param, "TeamID", TeamID);
	ParseInt(param, "TeamScore", TeamScore);
	ParseInt(param, "RemainSec", RemainSec);
	if((TeamID == 1))
	{
		TeamRedPoint.SetText(string(TeamScore));
	}
	if((TeamID == 0))
	{
		TeamBluePoint.SetText(string(TeamScore));
	}
	return;
}

function HandleBlockStatePlayer(string param)
{
	local int TeamID, PlayerID, PlayerScore, RemainSec, Count;
	local string PlayerName;
	local LVDataRecord Record1, Record2;

	BlockCounter.ShowWindow();
	ParseInt(param, "TeamID", TeamID);
	ParseInt(param, "PlayerID", PlayerID);
	ParseInt(param, "PlayerScore", PlayerScore);
	ParseInt(param, "RemainSec", RemainSec);
	if((TeamID == 1))
	{
		PlayerName = Class'NWindow.UIDATA_USER'.static.GetUserName(PlayerID);
		Count = 0;
		while((Count < TeamRedList.GetRecordCount()))
		{
			TeamRedList.GetRec(Count, Record1);
			if((PlayerID == Record1.LVDataList[0].nReserved2))
			{
				Record1.LVDataList[0].szData = PlayerName;
				Record1.LVDataList[1].szData = string(PlayerScore);
				TeamRedList.ModifyRecord(Count, Record1);
				break;
			}
			Count++;
		}
	}
	else if((TeamID == 0))
	{
		PlayerName = Class'NWindow.UIDATA_USER'.static.GetUserName(PlayerID);
		Count = 0;
		while((Count < TeamBlueList.GetRecordCount()))
		{
			TeamBlueList.GetRec(Count, Record2);
			if((PlayerID == Record2.LVDataList[0].nReserved2))
			{
				Record2.LVDataList[0].szData = PlayerName;
				Record2.LVDataList[1].szData = string(PlayerScore);
				TeamBlueList.ModifyRecord(Count, Record2);
				break;
			}
			Count++;
		}
	}
	return;
}

function HandleBlockStateResult(string param)
{
	local int WinTeamId;

	getInstanceNoticeWnd().hideNoticeButton_PVPBLOCKCHECKER();
	BlockCounter.HideWindow();
	ParseInt(param, "WinTeamId", WinTeamId);
	if((WinTeamId == 1))
	{
		Me.ShowWindow();
		TeamRedResult.SetTexture("L2UI_CT1.PVP_DF_Result_Win");
		TeamBlueResult.SetTexture("L2UI_CT1.PVP_DF_Result_Lose");
		TeamRedResult.ShowWindow();
		TeamBlueResult.ShowWindow();
	}
	else if((WinTeamId == 0))
	{
		Me.ShowWindow();
		TeamRedResult.SetTexture("L2UI_CT1.PVP_DF_Result_Lose");
		TeamBlueResult.SetTexture("L2UI_CT1.PVP_DF_Result_Win");
		TeamRedResult.ShowWindow();
		TeamBlueWin.ShowWindow();
	}
	return;
}

function HandleBlockListAdd(string param)
{
	local int TeamID, PlayerID;
	local string PlayerName;
	local int Index;
	local LVData data1, data2;
	local LVDataRecord Record1, Record2;

	ParseInt(param, "TeamID", TeamID);
	ParseInt(param, "PlayerID", PlayerID);
	ParseString(param, "PlayerName", PlayerName);
	if((TeamID == 1))
	{
		Index = TeamRedList.GetRecordCount();
		data1.nReserved1 = TeamID;
		data1.nReserved2 = PlayerID;
		data1.nReserved3 = Index;
		data1.szData = PlayerName;
		data2.szData = "0";
		Record1.LVDataList.Length = 2;
		Record1.LVDataList[0] = data1;
		Record1.LVDataList[1] = data2;
		TeamRedList.InsertRecord(Record1);
		TeamRedTotal.SetText(string(TeamRedList.GetRecordCount()));
	}
	else if((TeamID == 0))
	{
		Index = TeamBlueList.GetRecordCount();
		data1.nReserved1 = TeamID;
		data1.nReserved2 = PlayerID;
		data1.nReserved3 = Index;
		data1.szData = PlayerName;
		data2.szData = "0";
		Record1.LVDataList.Length = 2;
		Record2.LVDataList[0] = data1;
		Record2.LVDataList[1] = data2;
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

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "btnClose":
			Me.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function ResetUI()
{
	TeamRedList.DeleteAllItem();
	TeamBlueList.DeleteAllItem();
	TeamRedResult.HideWindow();
	TeamBlueResult.HideWindow();
	TeamBlueWin.HideWindow();
	return;
}
