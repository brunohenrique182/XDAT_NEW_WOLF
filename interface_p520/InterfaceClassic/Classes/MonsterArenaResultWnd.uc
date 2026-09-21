class MonsterArenaResultWnd extends UICommonAPI;

const TIMER_ID = 1490;
const TIMER_DELAY = 10000;

var WindowHandle Me;
var TextBoxHandle txtPlayMode;
var TextBoxHandle txtStage;
var TextBoxHandle txtStageScore;
var TextBoxHandle txtTotalScore;
var ButtonHandle btnClose;

function OnRegisterEvent()
{
	RegisterEvent(10130);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("MonsterArenaResultWnd");
	txtPlayMode = GetTextBoxHandle("MonsterArenaResultWnd.PlayReportWnd.txtPlayMode");
	txtStage = GetTextBoxHandle("MonsterArenaResultWnd.PlayReportWnd.txtStage");
	txtStageScore = GetTextBoxHandle("MonsterArenaResultWnd.PlayReportWnd.txtStageScore");
	txtTotalScore = GetTextBoxHandle("MonsterArenaResultWnd.PlayReportWnd.txtTotalScore");
	btnClose = GetButtonHandle("MonsterArenaResultWnd.BtnClose");
	return;
}

function OnShow()
{
	Me.SetTimer(1490, 10000);
	return;
}

function OnTimer(int TimerID)
{
	if((TimerID == 1490))
	{
		Me.HideWindow();
		Me.KillTimer(1490);
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "BtnClose":
			Me.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 10130:
			insertParam(a_Param);
			break;
		default:
			break;
	}
	return;
}

function insertParam(string a_Param)
{
	local int InstantZoneID, StageNum, CurStageScore, TotalStageScore;

	ParseInt(a_Param, "InstantZoneID", InstantZoneID);
	ParseInt(a_Param, "StageNum", StageNum);
	ParseInt(a_Param, "CurStageScore", CurStageScore);
	ParseInt(a_Param, "TotalStageScore", TotalStageScore);
	txtPlayMode.SetText(GetInZoneNameWithZoneID(InstantZoneID));
	txtStage.SetText((GetSystemString(3483) @ string(StageNum)));
	txtStageScore.SetText(MakeCostString(string(CurStageScore)));
	txtTotalScore.SetText(MakeCostString(string(TotalStageScore)));
	Me.ShowWindow();
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}
