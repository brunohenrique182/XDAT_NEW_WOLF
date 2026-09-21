class CampaignAlarmWnd extends UICommonAPI;

const MAX_COUNT = 6;
const TIMER_ID = 501;
const TIMER_DELAY = 5000;

var WindowHandle Me;
var ButtonHandle CampaignInfoButton;
var TextBoxHandle CampaignTitle;
var TextBoxHandle TimeTitle;
var TextBoxHandle Time;
var ButtonHandle Resultbtn;
var TextureHandle Divider;
var BarHandle GoalGage1;
var BarHandle GoalGage2;
var BarHandle GoalGage3;
var BarHandle GoalGage4;
var BarHandle GoalGage5;
var BarHandle GoalGage6;
var array<BarHandle> arrStatus;
var TextBoxHandle GoalTitle1;
var TextBoxHandle GoalTitle2;
var TextBoxHandle GoalTitle3;
var TextBoxHandle GoalTitle4;
var TextBoxHandle GoalTitle5;
var TextBoxHandle GoalTitle6;
var array<TextBoxHandle> arrGoalTitle;
var bool bAccpept;
var int Mid;
var int mSTEP;
var int Mstate;
var L2Util util;

function OnRegisterEvent()
{
	RegisterEvent(5210);
	RegisterEvent(5230);
	RegisterEvent(5250);
	RegisterEvent(40);
	return;
}

function OnLoad()
{
	Me = GetWindowHandle("CampaignAlarmWnd");
	Resultbtn = GetButtonHandle("CampaignAlarmWnd.Resultbtn");
	Divider = GetTextureHandle("CampaignAlarmWnd.Divider");
	CampaignTitle = GetTextBoxHandle("CampaignAlarmWnd.CampaignTitle");
	TimeTitle = GetTextBoxHandle("CampaignAlarmWnd.TimeTitle");
	Time = GetTextBoxHandle("CampaignAlarmWnd.Time");
	GoalGage1 = GetBarHandle("CampaignAlarmWnd.GoalGage1");
	GoalGage2 = GetBarHandle("CampaignAlarmWnd.GoalGage2");
	GoalGage3 = GetBarHandle("CampaignAlarmWnd.GoalGage3");
	GoalGage4 = GetBarHandle("CampaignAlarmWnd.GoalGage4");
	GoalGage5 = GetBarHandle("CampaignAlarmWnd.GoalGage5");
	GoalGage6 = GetBarHandle("CampaignAlarmWnd.GoalGage6");
	GoalTitle1 = GetTextBoxHandle("CampaignAlarmWnd.GoalTitle1");
	GoalTitle2 = GetTextBoxHandle("CampaignAlarmWnd.GoalTitle2");
	GoalTitle3 = GetTextBoxHandle("CampaignAlarmWnd.GoalTitle3");
	GoalTitle4 = GetTextBoxHandle("CampaignAlarmWnd.GoalTitle4");
	GoalTitle5 = GetTextBoxHandle("CampaignAlarmWnd.GoalTitle5");
	GoalTitle6 = GetTextBoxHandle("CampaignAlarmWnd.GoalTitle6");
	util = L2Util(GetScript("L2Util"));
	arrStatus.Length = 6;
	arrGoalTitle.Length = 6;
	arrStatus[0] = GoalGage1;
	arrStatus[1] = GoalGage2;
	arrStatus[2] = GoalGage3;
	arrStatus[3] = GoalGage4;
	arrStatus[4] = GoalGage5;
	arrStatus[5] = GoalGage6;
	arrGoalTitle[0] = GoalTitle1;
	arrGoalTitle[1] = GoalTitle2;
	arrGoalTitle[2] = GoalTitle3;
	arrGoalTitle[3] = GoalTitle4;
	arrGoalTitle[4] = GoalTitle5;
	arrGoalTitle[5] = GoalTitle6;
	OnRegisterEvent();
	return;
}

function OnClickButton(string strID)
{
	if((strID == "CampaignInfoButton"))
	{
		RequestDynamicContentHtml(Mid, mSTEP);
	}
	else if((strID == "Resultbtn"))
	{
		RequestDynamicContentHtml(Mid, mSTEP);
	}
	else if((strID == "CloseButton"))
	{
		Me.HideWindow();
	}
	return;
}

function OnTimer(int TimerID)
{
	if((TimerID == 501))
	{
		RequestDynamicQuestProgressInfo(Mid, mSTEP);
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 5210:
			CampaignArrived(param);
			break;
		case 5230:
			CampaignProgressInfo(param);
			break;
		case 5250:
			CampaignFinish(param);
			break;
		case 40:
			initCampaign();
			break;
		default:
			break;
	}
	return;
}

function initCampaign()
{
	bAccpept = false;
	Me.KillTimer(501);
	return;
}

function CampaignArrived(string param)
{
	local int Id, Step;

	initCampaign();
	ParseInt(param, "ID", Id);
	ParseInt(param, "STEP", Step);
	Mid = Id;
	mSTEP = Step;
	Mstate = 0;
	return;
}

function CampaignProgressInfo(string param)
{
	local int i, Id, Step, State, GoalCnt, ParticipantsCnt, RemainTimeInSec, CurValue, GoalValue;
	local DynamicContentInfo Info;
	local NoticeWnd notice;

	if((bAccpept == false))
	{
		notice = NoticeWnd(GetScript("NoticeWnd"));
		notice.ClearCampaignBtn();
		Me.ShowWindow();
		bAccpept = true;
		Me.SetTimer(501, 5000);
	}
	ParseInt(param, "ID", Id);
	ParseInt(param, "STEP", Step);
	ParseInt(param, "STATE", State);
	ParseInt(param, "GoalCnt", GoalCnt);
	ParseInt(param, "ParticipantsCnt", ParticipantsCnt);
	ParseInt(param, "RemainTimeInSec", RemainTimeInSec);
	Mid = Id;
	mSTEP = Step;
	Mstate = State;
	GetDynamicContentInfo(Id, Step, Info);
	Time.SetText(util.TimeNumberToHangulHourMin(RemainTimeInSec));
	SetWindowSize(GoalCnt, State);
	setWindowShow(GoalCnt, Info);
	i = 0;
	while((i < GoalCnt))
	{
		ParseInt(param, ("CurValue_" $ string(i)), CurValue);
		ParseInt(param, ("GoalValue_" $ string(i)), GoalValue);
		arrStatus[i].SetValue(GoalValue, CurValue);
		i++;
	}
	return;
}

function CampaignFinish(string param)
{
	local int Id, Step;

	ParseInt(param, "ID", Id);
	ParseInt(param, "STEP", Step);
	Mid = Id;
	mSTEP = Step;
	Mstate = 0;
	getInstanceNoticeWnd().hideNoticeButton_CAMPAIGN();
	Me.HideWindow();
	initCampaign();
	return;
}

function SetWindowSize(int Count, int State)
{
	local int Size, h;

	switch(State)
	{
		case 1:
			Size = 93;
			h = (Size + (33 * (Count - 1)));
			TimeTitle.SetText(GetSystemString(1108));
			Resultbtn.HideWindow();
			Divider.HideWindow();
			break;
		case 2:
			Size = 125;
			h = (Size + (33 * (Count - 1)));
			TimeTitle.SetText(GetSystemString(2423));
			Resultbtn.SetButtonName(2279);
			Resultbtn.ShowWindow();
			Divider.ShowWindow();
			break;
		case 3:
			Size = 125;
			h = (Size + (33 * (Count - 1)));
			TimeTitle.SetText(GetSystemString(2423));
			Resultbtn.SetButtonName(2426);
			Resultbtn.ShowWindow();
			Divider.ShowWindow();
			break;
		case 4:
			Size = 125;
			h = (Size + (33 * (Count - 1)));
			TimeTitle.SetText(GetSystemString(2424));
			Resultbtn.SetButtonName(2425);
			Resultbtn.ShowWindow();
			Divider.ShowWindow();
			break;
		default:
			break;
	}
	Me.SetWindowSize(213, h);
	return;
}

function setWindowShow(int Count, DynamicContentInfo Info)
{
	local int i;

	CampaignTitle.SetText(Info.Name);
	CampaignTitle.SetTextEllipsisWidth(160);
	CampaignTitle.SetTooltipString(Info.ToolTip);
	i = 0;
	while((i < 6))
	{
		if((i < Count))
		{
			arrGoalTitle[i].ShowWindow();
			arrGoalTitle[i].SetText(("- " $ Info.GoalDescription[i]));
			arrStatus[i].ShowWindow();
			i++;
			continue;
		}
		arrGoalTitle[i].HideWindow();
		arrStatus[i].HideWindow();
		i++;
	}
	return;
}

function RaderButtonClick()
{
	if((Mstate == 0))
	{
		RequestDynamicContentHtml(Mid, mSTEP);
	}
	else if(!Me.IsShowWindow())
	{
		Me.ShowWindow();
	}
	else
	{
		Me.HideWindow();
	}
	return;
}

function int getCampaignState()
{
	return Mstate;
}
