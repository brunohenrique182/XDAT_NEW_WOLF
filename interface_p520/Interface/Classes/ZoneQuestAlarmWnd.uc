class ZoneQuestAlarmWnd extends UICommonAPI;

const MAX_COUNT = 6;
const TIMER_ID = 502;
const TIMER_DELAY = 5000;

var WindowHandle Me;
var ButtonHandle ZoneQuestInfoButton;
var TextBoxHandle ZoneQuestTitle;
var TextBoxHandle TimeTitle;
var TextBoxHandle Time;
var TextBoxHandle ParticipantsCounter;
var ButtonHandle Situationbtn;
var ButtonHandle rewardBtn;
var ButtonHandle Resultbtn;
var TextureHandle Divider;
var StatusBarHandle GoalGage1;
var StatusBarHandle GoalGage2;
var StatusBarHandle GoalGage3;
var StatusBarHandle GoalGage4;
var StatusBarHandle GoalGage5;
var StatusBarHandle GoalGage6;
var array<StatusBarHandle> arrStatus;
var TextBoxHandle GoalTitle1;
var TextBoxHandle GoalTitle2;
var TextBoxHandle GoalTitle3;
var TextBoxHandle GoalTitle4;
var TextBoxHandle GoalTitle5;
var TextBoxHandle GoalTitle6;
var array<TextBoxHandle> arrGoalTitle;
var int Mid;
var int mSTEP;
var int Mstate;
var bool bAccpept;
var L2Util util;

function OnRegisterEvent()
{
	RegisterEvent(5220);
	RegisterEvent(5240);
	RegisterEvent(5260);
	RegisterEvent(40);
	return;
}

function OnLoad()
{
	OnRegisterEvent();
	Me = GetWindowHandle("ZoneQuestAlarmWnd");
	Situationbtn = GetButtonHandle("ZoneQuestAlarmWnd.Situationbtn");
	rewardBtn = GetButtonHandle("ZoneQuestAlarmWnd.Rewardbtn");
	Resultbtn = GetButtonHandle("ZoneQuestAlarmWnd.Resultbtn");
	Divider = GetTextureHandle("ZoneQuestAlarmWnd.Divider");
	ZoneQuestTitle = GetTextBoxHandle("ZoneQuestAlarmWnd.ZoneQuestTitle");
	TimeTitle = GetTextBoxHandle("ZoneQuestAlarmWnd.TimeTitle");
	Time = GetTextBoxHandle("ZoneQuestAlarmWnd.Time");
	ParticipantsCounter = GetTextBoxHandle("ZoneQuestAlarmWnd.ParticipantsCounter");
	GoalGage1 = GetStatusBarHandle("ZoneQuestAlarmWnd.GoalGage1");
	GoalGage2 = GetStatusBarHandle("ZoneQuestAlarmWnd.GoalGage2");
	GoalGage3 = GetStatusBarHandle("ZoneQuestAlarmWnd.GoalGage3");
	GoalGage4 = GetStatusBarHandle("ZoneQuestAlarmWnd.GoalGage4");
	GoalGage5 = GetStatusBarHandle("ZoneQuestAlarmWnd.GoalGage5");
	GoalGage6 = GetStatusBarHandle("ZoneQuestAlarmWnd.GoalGage6");
	GoalTitle1 = GetTextBoxHandle("ZoneQuestAlarmWnd.GoalTitle1");
	GoalTitle2 = GetTextBoxHandle("ZoneQuestAlarmWnd.GoalTitle2");
	GoalTitle3 = GetTextBoxHandle("ZoneQuestAlarmWnd.GoalTitle3");
	GoalTitle4 = GetTextBoxHandle("ZoneQuestAlarmWnd.GoalTitle4");
	GoalTitle5 = GetTextBoxHandle("ZoneQuestAlarmWnd.GoalTitle5");
	GoalTitle6 = GetTextBoxHandle("ZoneQuestAlarmWnd.GoalTitle6");
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
	return;
}

function OnShow()
{
	RequestDynamicQuestProgressInfo(Mid, mSTEP);
	return;
}

function OnClickButton(string strID)
{
	if((strID == "ZoneQuestInfoButton"))
	{
		RequestDynamicContentHtml(Mid, mSTEP);
	}
	else if((strID == "Situationbtn"))
	{
		if(((Mstate == 1) || (Mstate == 3)))
		{
			ShowWindow("ZoneQuestSituationWnd");
			RequestDynamicQuestScoreInfo(Mid, mSTEP);
		}
		else
		{
			RequestDynamicContentHtml(Mid, mSTEP);
		}
	}
	else if((strID == "Resultbtn"))
	{
		ShowWindow("ZoneQuestSituationWnd");
		RequestDynamicQuestScoreInfo(Mid, mSTEP);
	}
	else if((strID == "Rewardbtn"))
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
	if((TimerID == 502))
	{
		RequestDynamicQuestProgressInfo(Mid, mSTEP);
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 5220:
			ZoneQuestArrived(param);
			break;
		case 5240:
			ZoneQuestProgressInfo(param);
			break;
		case 5260:
			ZoneQuestFinish(param);
			break;
		case 40:
			initZoneQuest();
			break;
		default:
			break;
	}
	return;
}

function initZoneQuest()
{
	bAccpept = false;
	Me.KillTimer(502);
	return;
}

function ZoneQuestArrived(string param)
{
	local int Id, Step;

	initZoneQuest();
	ParseInt(param, "ID", Id);
	ParseInt(param, "STEP", Step);
	Mid = Id;
	mSTEP = Step;
	Mstate = 0;
	return;
}

function ZoneQuestProgressInfo(string param)
{
	local int i, Id, Step, State, GoalCnt, ParticipantsCnt, RemainTimeInSec, CurValue, GoalValue;
	local DynamicContentInfo Info;
	local ZoneQuestSituationWnd Script;

	Script = ZoneQuestSituationWnd(GetScript("ZoneQuestSituationWnd"));
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
	ParticipantsCounter.SetText((string(ParticipantsCnt) $ GetSystemString(1013)));
	Script.showTimeCounter(util.TimeNumberToHangulHourMin(RemainTimeInSec), (string(ParticipantsCnt) $ GetSystemString(1013)));
	SetWindowSize(GoalCnt, State);
	setWindowShow(GoalCnt, Info);
	i = 0;
	while((i < GoalCnt))
	{
		ParseInt(param, ("CurValue_" $ string(i)), CurValue);
		ParseInt(param, ("GoalValue_" $ string(i)), GoalValue);
		arrStatus[i].SetPoint(INT64(CurValue), INT64(GoalValue));
		i++;
	}
	RequestDynamicQuestScoreInfo(Mid, mSTEP);
	return;
}

function ZoneQuestFinish(string param)
{
	local int Id, Step;

	initZoneQuest();
	ParseInt(param, "ID", Id);
	ParseInt(param, "STEP", Step);
	Mid = Id;
	mSTEP = Step;
	Mstate = 0;
	getInstanceNoticeWnd().hideNoticeButton_ZONE();
	Me.HideWindow();
	return;
}

function SetWindowSize(int Count, int State)
{
	local int Size, h;

	Size = 139;
	h = (Size + (33 * (Count - 1)));
	switch(State)
	{
		case 1:
			TimeTitle.SetText(GetSystemString(1108));
			Situationbtn.SetButtonName(2437);
			Situationbtn.ShowWindow();
			Resultbtn.HideWindow();
			rewardBtn.HideWindow();
			break;
		case 2:
			TimeTitle.SetText(GetSystemString(2423));
			Situationbtn.HideWindow();
			Resultbtn.ShowWindow();
			rewardBtn.ShowWindow();
			break;
		case 3:
			TimeTitle.SetText(GetSystemString(2423));
			Situationbtn.SetButtonName(2426);
			Situationbtn.ShowWindow();
			Resultbtn.SetButtonName(2426);
			Resultbtn.HideWindow();
			rewardBtn.HideWindow();
			break;
		case 4:
			TimeTitle.SetText(GetSystemString(2424));
			Situationbtn.SetButtonName(2438);
			Situationbtn.ShowWindow();
			Resultbtn.HideWindow();
			rewardBtn.HideWindow();
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

	ZoneQuestTitle.SetText(Info.Name);
	ZoneQuestTitle.SetTextEllipsisWidth(160);
	ZoneQuestTitle.SetTooltipString(Info.ToolTip);
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
	local NoticeWnd notice;

	notice = NoticeWnd(GetScript("NoticeWnd"));
	notice.ClearZoneQuestBtn();
	if((Mstate == 0))
	{
		RequestDynamicContentHtml(Mid, mSTEP);
	}
	else
	{
		if(!Me.IsShowWindow())
		{
			Me.ShowWindow();
		}
		else
		{
			Me.HideWindow();
		}
		if((bAccpept == false))
		{
			bAccpept = true;
			Me.SetTimer(502, 5000);
		}
	}
	return;
}

function int getZoneQuestID()
{
	return Mid;
}

function int getZoneQuestSTEP()
{
	return mSTEP;
}

function int getZoneQuestState()
{
	return Mstate;
}
