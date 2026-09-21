class RecommendBonusWnd extends UICommonAPI;

const NAVIT_TIMER_ID_TOOLTIP = 7000;
const NAVIT_TIMER_ID_ICON = 7001;
const NAVIT_TIMER_ID_GAUGE = 7002;
const NAVIT_TIMER_DELAY_TOOLTIP = 1000;
const NAVIT_TIMER_DELAY_ICON = 500;
const NAVIT_TIMER_DELAY_GAUGE = 500;
const NAVIT_MAX_POINT = 7200;
const NAVIT_MAX_TIME = 14400;
const ANIM_MIN_ALPHA = 39;
const ANIM_MAX_ALPHA = 197;
const ANIM_SPEEDFLOAT = 0.40f;
const TIMER_ID = 1050;
const TIMER_DELAY = 1000;

var WindowHandle Navit_Tooltip_Icon;
var WindowHandle Navit_Tooltip_Gauge;
var TextureHandle Navit_Tex_Glow;
var TextureHandle Navit_Tex_Icon;
var TextureHandle Navit_Tex_Gauge;
var bool m_bNavit;
var int m_Navit_Level;
var int m_NavitEffectRemainSec;
var int m_NavitIConFactor;
var int m_NavitGaugeFactor;
var WindowHandle Me;
var RecommendBonusHelpHtmlWnd RecommendBonusHelpHtmlWndScript;
var ButtonHandle helpHtmlPopupButton;
var ButtonHandle recommendBonusWndCloseButton;
var TextBoxHandle bonusExpTextBox2;
var TextBoxHandle bonusTimeLimitTextBox2;
var int currentRemainTimeValue;
var bool m_bIsNewVoteEvent;
var bool m_bIsFirstNewVoteEventMessage;

function OnRegisterEvent()
{
	RegisterEvent(4940);
	RegisterEvent(5100);
	RegisterEvent(5110);
	RegisterEvent(5120);
	return;
}

function OnTimer(int TimerID)
{
	if((TimerID == 1050))
	{
		currentRemainTimeValue = (currentRemainTimeValue - 1);
		UpdateTime(currentRemainTimeValue);
	}
	else if((TimerID == 7000))
	{
		TimerNavitToolTip();
	}
	else if((TimerID == 7001))
	{
		TimerNavitIconBlink();
	}
	else if((TimerID == 7002))
	{
		TimerNavitGaugeBlink();
	}
	return;
}

function OnLoad()
{
	OnRegisterEvent();
	Me = GetWindowHandle("RecommendBonusWnd");
	recommendBonusWndCloseButton = GetButtonHandle("RecommendBonusWnd.recommendBonusWndCloseButton");
	helpHtmlPopupButton = GetButtonHandle("RecommendBonusWnd.helpHtmlPopupButton");
	bonusExpTextBox2 = GetTextBoxHandle("RecommendBonusWnd.NavitBless_Txt_Prog_Sys");
	bonusTimeLimitTextBox2 = GetTextBoxHandle("RecommendBonusWnd.NavitBless_Txt_Time_Sys");
	RecommendBonusHelpHtmlWndScript = RecommendBonusHelpHtmlWnd(GetScript("RecommendBonusHelpHtmlWnd"));
	Navit_Tooltip_Icon = GetWindowHandle("RecommendBonusWnd.NavitAdv_Tooltip_Icon");
	Navit_Tooltip_Gauge = GetWindowHandle("RecommendBonusWnd.NavitAdv_Tooltip_Gauge");
	Navit_Tex_Glow = GetTextureHandle("RecommendBonusWnd.NavitAdv_Tex_Glow");
	Navit_Tex_Icon = GetTextureHandle("RecommendBonusWnd.NavitAdv_Tex_Icon");
	Navit_Tex_Gauge = GetTextureHandle("RecommendBonusWnd.NavitAdv_Tex_Gauge");
	Navit_Tex_Glow.SetAlpha(0);
	m_bIsNewVoteEvent = false;
	m_bIsFirstNewVoteEventMessage = false;
	return;
}

function OnShow()
{
	return;
}

function OnClickButton(string a_ButtonID)
{
	switch(a_ButtonID)
	{
		case "VitalBonus_Btn_helpHtml":
			OnReCommendBonusHelpClick();
			break;
		case "VitalBonus_Btn_Close":
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
		case 4940:
			getDataByServer(a_Param);
			break;
		case 5100:
			HandleNavitPointInfo(a_Param);
			break;
		case 5110:
			HandleNavitEffect(a_Param);
			break;
		case 5120:
			HandleNavitTimeChange(a_Param);
			break;
		default:
			break;
	}
	return;
}

function OnReCommendBonusHelpClick()
{
	local string strParam;

	if(IsShowWindow("RecommendBonusHelpHtmlWnd"))
	{
		HideWindow("RecommendBonusHelpHtmlWnd");
	}
	else
	{
		Class'NWindow.UIAPI_WINDOW'.static.SetFocus("RecommendBonusHelpHtmlWnd");
		ParamAdd(strParam, "FilePath", (GetLocalizedL2TextPathNameUC() $ "event_2010_bless001.htm"));
		ExecuteEvent(4941);
	}
	return;
}

function OnEnterState(name a_CurrentStateName)
{
	if(m_bIsNewVoteEvent)
	{
		Me.ShowWindow();
	}
	else
	{
		Me.HideWindow();
	}
	return;
}

function OnExitState(name a_CurrentStateName)
{
	Me.HideWindow();
	return;
}

function getDataByServer(string param)
{
	local int VoteCount, BonusCount, leftBonusTime, bonusRate, isOverTime;

	ParseInt(param, "voteCount", VoteCount);
	ParseInt(param, "bonusCount", BonusCount);
	ParseInt(param, "leftBonusTime", leftBonusTime);
	ParseInt(param, "bonusRate", bonusRate);
	ParseInt(param, "isOverTime", isOverTime);
	if(!m_bIsFirstNewVoteEventMessage)
	{
		if(!m_bIsNewVoteEvent)
		{
			Me.ShowWindow();
			m_bIsNewVoteEvent = true;
		}
		m_bIsFirstNewVoteEventMessage = true;
	}
	Me.KillTimer(1050);
	UpdateTime(leftBonusTime);
	if((((isOverTime == 1) || ((leftBonusTime > 0) && (isOverTime == 10))) || (isOverTime == 11)))
	{
		bonusTimeLimitTextBox2.SetText(GetSystemString(2275));
		bonusExpTextBox2.SetText((string(bonusRate) $ "%"));
	}
	else if((0 < leftBonusTime))
	{
		bonusExpTextBox2.SetText((string(bonusRate) $ "%"));
		currentRemainTimeValue = leftBonusTime;
		Me.SetTimer(1050, 1000);
	}
	else
	{
		bonusExpTextBox2.SetText("0%");
	}
	return;
}

function visibleToggleWnd()
{
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("RecommendBonusWnd"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("RecommendBonusWnd");
	}
	else
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("RecommendBonusWnd");
	}
	return;
}

function UpdateTime(int iRemainSecond)
{
	local int temp1, m_timeHour, m_timeMin, m_timeSec;

	temp1 = (iRemainSecond / 60);
	m_timeHour = (temp1 / 60);
	m_timeMin = int((float(temp1) % 60.0000000));
	m_timeSec = int((float(iRemainSecond) % 60.0000000));
	if((m_timeHour > 0))
	{
		if((m_timeHour < 10))
		{
			bonusTimeLimitTextBox2.SetText(("0" $ string(m_timeHour)));
		}
		else
		{
			bonusTimeLimitTextBox2.SetText(string(m_timeHour));
		}
	}
	else
	{
		bonusTimeLimitTextBox2.SetText("00");
	}
	bonusTimeLimitTextBox2.SetText((bonusTimeLimitTextBox2.GetText() $ ":"));
	if((m_timeMin > 0))
	{
		if((m_timeMin < 10))
		{
			bonusTimeLimitTextBox2.SetText(((bonusTimeLimitTextBox2.GetText() $ "0") $ string(m_timeMin)));
		}
		else
		{
			bonusTimeLimitTextBox2.SetText((bonusTimeLimitTextBox2.GetText() $ string(m_timeMin)));
		}
	}
	else
	{
		bonusTimeLimitTextBox2.SetText((bonusTimeLimitTextBox2.GetText() $ "00"));
	}
	if((((m_timeHour <= 0) && (m_timeMin <= 0)) && (m_timeSec <= 0)))
	{
		Me.KillTimer(1050);
	}
	if((iRemainSecond <= 0))
	{
		bonusExpTextBox2.SetText("0%");
		bonusTimeLimitTextBox2.SetText(GetSystemString(908));
	}
	return;
}

function HandleNavitPointInfo(string a_Param)
{
	local int point, Level, Percent;

	ParseInt(a_Param, "NavitPoint", point);
	Level = (point / (7200 / 12));
	Percent = ((point * 100.0000000) / 7200);
	if((Percent > 100))
	{
		Percent = 100;
	}
	if(!m_bNavit)
	{
		NavitGaugeChange(Level, false);
		Navit_Tooltip_Gauge.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(3271), (string(Percent) $ "%"), "")));
	}
	return;
}

function HandleNavitEffect(string a_Param)
{
	ParseInt(a_Param, "RemainSeconds", m_NavitEffectRemainSec);
	if((m_NavitEffectRemainSec > 0))
	{
		m_bNavit = true;
		NavitGaugeChange(12, true);
		Me.KillTimer(7000);
		Me.SetTimer(7000, 1000);
		m_NavitIConFactor = 0;
		Me.KillTimer(7001);
		Me.SetTimer(7001, 500);
	}
	else
	{
		m_bNavit = false;
		NavitGaugeChange(m_Navit_Level, true);
		Me.KillTimer(7000);
		Me.KillTimer(7001);
		Navit_Tex_Glow.SetAlpha(0, 0.4000000);
	}
	return;
}

function HandleNavitTimeChange(string a_Param)
{
	local int bStart, navitTime;
	local string ToolTip;

	ParseInt(a_Param, "bStart", bStart);
	ParseInt(a_Param, "navitTime", navitTime);
	if((navitTime > 14400))
	{
		ToolTip = MakeFullSystemMsg(GetSystemMessage(3277), GetSystemString(908), "");
		Navit_Tex_Icon.SetTexture("BranchSys2.ui.Br_NavitIcon_B");
	}
	else if((bStart == 1))
	{
		ToolTip = MakeFullSystemMsg(GetSystemMessage(3277), NavitUpdateTime((14400 - navitTime)), "");
		Navit_Tex_Icon.SetTexture("BranchSys2.ui.Br_NavitIcon_N");
	}
	else
	{
		ToolTip = MakeFullSystemMsg(GetSystemMessage(3277), GetSystemString(2320), "");
		Navit_Tex_Icon.SetTexture("BranchSys2.ui.Br_NavitIcon_B");
	}
	Navit_Tooltip_Icon.SetTooltipCustomType(MakeTooltipSimpleText(ToolTip));
	return;
}

function TimerNavitIconBlink()
{
	if(((float(m_NavitIConFactor) % 2.0000000) == 0.0000000))
	{
		Navit_Tex_Glow.SetAlpha(39, 0.4000000);
	}
	else
	{
		Navit_Tex_Glow.SetAlpha(197, 0.4000000);
	}
	m_NavitIConFactor = (m_NavitIConFactor + 1);
	return;
}

function TimerNavitGaugeBlink()
{
	if(((float(m_NavitGaugeFactor) % 2.0000000) == 0.0000000))
	{
		Navit_Tex_Gauge.SetAlpha(39, 0.4000000);
	}
	else
	{
		Navit_Tex_Gauge.SetAlpha(197, 0.4000000);
	}
	if((m_NavitGaugeFactor > 16))
	{
		Me.KillTimer(7002);
		Navit_Tex_Gauge.SetAlpha(255, 0.4000000);
	}
	m_NavitGaugeFactor = (m_NavitGaugeFactor + 1);
	return;
}

function TimerNavitToolTip()
{
	if((m_NavitEffectRemainSec > 0))
	{
		m_NavitEffectRemainSec = (m_NavitEffectRemainSec - 1);
	}
	Navit_Tooltip_Gauge.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(3270), string(m_NavitEffectRemainSec), "")));
	return;
}

function string NavitUpdateTime(int RemainSec)
{
	local int Hour, Min, tmpSec;
	local string strTime;

	if((RemainSec > 0))
	{
		tmpSec = (RemainSec / 60);
		Min = int((float(tmpSec) % 60.0000000));
		Hour = (tmpSec / 60);
		if((Hour < 10))
		{
			strTime = ("0" $ string(Hour));
		}
		else
		{
			strTime = string(Hour);
		}
		strTime = (strTime $ ":");
		if((Min < 10))
		{
			strTime = ((strTime $ "0") $ string(Min));
		}
		else
		{
			strTime = (strTime $ string(Min));
		}
	}
	else
	{
		strTime = "00:00";
	}
	return strTime;
}

function NavitGaugeChange(int Level, bool forceChange)
{
	local string TexName;

	TexName = ("BranchSys2.ui.Br_NavitPoint_" $ string(Level));
	if(((forceChange == true) || (m_Navit_Level != Level)))
	{
		Navit_Tex_Gauge.SetTexture(TexName);
		if(((Level != 0) && (Level != 12)))
		{
			m_NavitGaugeFactor = 0;
			Me.KillTimer(7002);
			Me.SetTimer(7002, 500);
		}
	}
	m_Navit_Level = Level;
	return;
}

defaultproperties
{
	m_Navit_Level=-1
}
