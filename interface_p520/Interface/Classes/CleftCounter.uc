class CleftCounter extends UIScript;

const TIMER_ID = 1023;
const TIMER_DELAY = 1000;
const TeamA_ID = 0;
const TeamB_ID = 1;

var WindowHandle Me;
var TextBoxHandle TeamACount;
var TextBoxHandle TeamBCount;
var TextBoxHandle TimerCount;
var TextBoxHandle TimerCountTitle;
var TextBoxHandle CountCenter;
var int Min;
var int Sec;
var string MinStr;
var string SecStr;

function OnRegisterEvent()
{
	RegisterEvent(3740);
	RegisterEvent(3750);
	RegisterEvent(3760);
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
	return;
}

function Initialize()
{
	Me = GetHandle("CleftCounter");
	TeamACount = TextBoxHandle(GetHandle("TeamACount"));
	TeamBCount = TextBoxHandle(GetHandle("TeamBCount"));
	TimerCount = TextBoxHandle(GetHandle("TimerCount"));
	TimerCountTitle = TextBoxHandle(GetHandle("TimerCountTitle"));
	CountCenter = TextBoxHandle(GetHandle("CountCenter"));
	return;
}

function InitializeCOD()
{
	Me = GetWindowHandle("CleftCounter");
	TeamACount = GetTextBoxHandle("CleftCounter.TeamACount");
	TeamBCount = GetTextBoxHandle("CleftCounter.TeamBCount");
	TimerCount = GetTextBoxHandle("CleftCounter.TimerCount");
	TimerCountTitle = GetTextBoxHandle("CleftCounter.TimerCountTitle");
	CountCenter = GetTextBoxHandle("CleftCounter.CountCenter");
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 3740:
			HandleCleftStateTeam(a_Param);
			break;
		case 3750:
			HandleCleftStatePlayer(a_Param);
			break;
		case 3760:
			HandleHide();
			break;
		default:
			break;
	}
	return;
}

function OnHide()
{
	Me.KillTimer(1023);
	return;
}

function OnShow()
{
	Me.SetTimer(1023, 1000);
	return;
}

function HandleCleftStateTeam(string param)
{
	local int TeamID, TeamPoint, RemainSec;

	ParseInt(param, "TeamID", TeamID);
	ParseInt(param, "TeamPoint", TeamPoint);
	ParseInt(param, "RemainSec", RemainSec);
	TimerReset(RemainSec);
	DrawTimerCount();
	if((TeamID == 0))
	{
		TeamACount.SetText(string(TeamPoint));
	}
	else if((TeamID == 1))
	{
		TeamBCount.SetText(string(TeamPoint));
	}
	return;
}

function HandleCleftStatePlayer(string param)
{
	local int RemainSec;

	ParseInt(param, "RemainSec", RemainSec);
	TimerReset(RemainSec);
	DrawTimerCount();
	return;
}

function OnClickButton(string Name)
{
	return;
}

function OnTimer(int TimerID)
{
	if((TimerID == 1023))
	{
		if(((Min == 1) && (Sec == 0)))
		{
			AddSystemMessage(2420);
		}
		if(((Min == 0) && (Sec == 10)))
		{
			AddSystemMessage(2421);
		}
		if(((Min == 0) && (Sec < 9)))
		{
			TimerCount.HideWindow();
			TimerCountTitle.HideWindow();
			UpdateTimerCount();
		}
		else
		{
			TimerCount.ShowWindow();
			TimerCountTitle.ShowWindow();
			DrawTimerCount();
			UpdateTimerCount();
		}
	}
	return;
}

function DrawTimerCount()
{
	MinStr = string(Min);
	SecStr = string(Sec);
	if((Min < 10))
	{
		MinStr = ("0" $ MinStr);
	}
	if((Sec < 10))
	{
		SecStr = ("0" $ SecStr);
	}
	TimerCount.SetText(((MinStr $ ":") $ SecStr));
	return;
}

function UpdateTimerCount()
{
	if((Sec == 0))
	{
		Sec = 59;
		Min = (Min - 1);
	}
	else
	{
		Sec = (Sec - 1);
	}
	return;
}

function TimerReset(int RemainTime)
{
	Min = (RemainTime / 60);
	Sec = int((float(RemainTime) % 60.0000000));
	return;
}

function ResetCurrentStat()
{
	TeamACount.SetText("0");
	TeamBCount.SetText("0");
	return;
}

function HandleHide()
{
	Me.HideWindow();
	return;
}
