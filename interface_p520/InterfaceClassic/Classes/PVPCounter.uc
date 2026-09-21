class PVPCounter extends UIScript;

const TIMER_ID = 1023;
const TIMER_DELAY = 1000;

var WindowHandle Me;
var TextBoxHandle CountA;
var TextBoxHandle CountB;
var TextBoxHandle TimerCount;
var TextBoxHandle TimerCountDetail;
var TextBoxHandle TimerCountTitle;
var TextBoxHandle TimerCountTitleDetail;
var int Min;
var int Sec;
var string MinStr;
var string SecStr;
var string m_Windowname;

function OnRegisterEvent()
{
	RegisterEvent(3370);
	RegisterEvent(3380);
	RegisterEvent(3390);
	return;
}

function OnLoad()
{
	OnRegisterEvent();
	InitializeCOD();
	Me.HideWindow();
	return;
}

function InitializeCOD()
{
	Me = GetWindowHandle(m_Windowname);
	CountA = GetTextBoxHandle((m_Windowname $ ".CountA"));
	CountB = GetTextBoxHandle((m_Windowname $ ".CountB"));
	TimerCount = GetTextBoxHandle((m_Windowname $ ".TimerCount"));
	TimerCountDetail = GetTextBoxHandle("PVPDetailedWnd.TimerCount");
	TimerCountTitle = GetTextBoxHandle("PVPDetailedWnd.TimerCountTitle");
	TimerCountTitleDetail = GetTextBoxHandle("PVPDetailedWnd.TimerCountTitle");
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 3370:
			HandlePVPMatchRecord(a_Param);
			break;
		case 3380:
			HandlePVPMatchRecordEachUserInfo(a_Param);
			break;
		case 3390:
			HandlePVPMatchUserDie(a_Param);
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
	local Color A, B;

	A.R = 114;
	A.G = 173;
	A.B = 255;
	B.R = 254;
	B.G = 151;
	B.B = 66;
	CountA.SetTextColor(A);
	CountB.SetTextColor(B);
	return;
}

function HandlePVPMatchRecord(string param)
{
	local int CurrentState, BlueTeamTotalKillCnt, RedTeamTotalKillCnt;

	ParseInt(param, "CurrentState", CurrentState);
	ParseInt(param, "BlueTeamTotalKillCnt", BlueTeamTotalKillCnt);
	ParseInt(param, "RedTeamTotalKillCnt", RedTeamTotalKillCnt);
	switch(CurrentState)
	{
		case 0:
			TimerReset();
			ResetCurrentStat();
			Me.ShowWindow();
			Me.SetTimer(1023, 1000);
			break;
		case 1:
			UpdateCurrentStat(BlueTeamTotalKillCnt, RedTeamTotalKillCnt);
			break;
		case 2:
			Me.HideWindow();
			ResetWnd();
			break;
		default:
			break;
	}
	return;
}

function HandlePVPMatchRecordEachUserInfo(string param)
{
	local int Team;
	local string PlayerName;
	local int KillCnt, DeathCnt;

	ParseInt(param, "Team", Team);
	ParseInt(param, "KillCnt", KillCnt);
	ParseInt(param, "DeathCnt", DeathCnt);
	ParseString(param, "PlayerName", PlayerName);
	return;
}

function HandlePVPMatchUserDie(string param)
{
	local int BlueTeamKillCnt, RedTeamKillCnt;

	ParseInt(param, "BlueTeamKillCnt", BlueTeamKillCnt);
	ParseInt(param, "RedTeamKillCnt", RedTeamKillCnt);
	UpdateCurrentStat(BlueTeamKillCnt, RedTeamKillCnt);
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
		if(((Min == 0) && (Sec < 9)))
		{
			TimerCount.HideWindow();
			TimerCountDetail.HideWindow();
			TimerCountTitle.HideWindow();
			TimerCountDetail.HideWindow();
			Me.KillTimer(1023);
		}
		else
		{
			TimerCount.ShowWindow();
			TimerCountDetail.ShowWindow();
			TimerCountTitle.ShowWindow();
			TimerCountDetail.ShowWindow();
			UpdateTimerCount();
		}
	}
	return;
}

function UpdateTimerCount()
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
	TimerCountDetail.SetText(((MinStr $ ":") $ SecStr));
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

function ResetWnd()
{
	TimerCount.ShowWindow();
	TimerCount.SetText("");
	TimerReset();
	ResetCurrentStat();
	return;
}

function TimerReset()
{
	Min = 10;
	Sec = 0;
	MinStr = string(Min);
	SecStr = string(Sec);
	TimerCount.SetText(((MinStr $ ":") $ SecStr));
	return;
}

function UpdateCurrentStat(int BlueCountInt, int RedCountInt)
{
	CountA.SetText(string(BlueCountInt));
	CountB.SetText(string(RedCountInt));
	return;
}

function ResetCurrentStat()
{
	CountA.SetText("0");
	CountB.SetText("0");
	return;
}

defaultproperties
{
	m_Windowname="PVPCounter"
}
