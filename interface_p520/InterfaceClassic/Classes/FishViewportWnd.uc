class FishViewportWnd extends UICommonAPI;

const EFFECT_TIMER_ID = 2;
const EFFECT_TIMER_DELAY = 1000;
const STATUS_TIMER_ID = 3;
const STATUS_TIMER_DELAY = 0;
const REELING_TIMER_ID = 5;
const PUMPING_TIMER_ID = 4;
const PUMPING_TIMER_DELAY = 80;
const FAKE_TIMER_ID = 7;

var string m_Windowname;
var WindowHandle m_hFishViewportWnd;
var WindowHandle m_hPumpingIcon;
var TextBoxHandle m_hPumpingText;
var WindowHandle m_hReelingIcon;
var TextBoxHandle m_hReelingText;
var WindowHandle m_hFishHPBarEffect;
var BarHandle m_hFishHPBar;
var BarHandle m_hFishHPBarFake;
var TextBoxHandle m_hTbSec;
var WindowHandle m_hTexClock;
var WindowHandle m_hWndStatus;
var TextBoxHandle m_hTbStatus;
var TextBoxHandle m_hTbDeltaHP;
var WindowHandle m_hFakeIcon;
var int m_OriginalFishHP;
var int m_OriginalFishTime;
var int m_CurrentFishHP;
var int m_PumpintTimerCount;
var int m_FakeTimerCount;
var int m_FishLevel;
var string m_FishState;

function OnRegisterEvent()
{
	return;
}

function OnLoad()
{
	InitHandleCOD();
	HideHPBarNEtc();
	m_hFishHPBarEffect.HideWindow();
	m_OriginalFishHP = 0;
	m_FishState = "stanby";
	RegisterState("FishViewportWnd", "GamingState");
	return;
}

function InitHandleCOD()
{
	m_hPumpingIcon = GetWindowHandle((m_Windowname $ ".texPumping"));
	m_hPumpingText = TextBoxHandle(GetWindowHandle((m_Windowname $ ".txtPumping")));
	m_hReelingIcon = GetWindowHandle((m_Windowname $ ".texReeling"));
	m_hReelingText = TextBoxHandle(GetWindowHandle((m_Windowname $ ".txtReeling")));
	m_hFishHPBar = GetBarHandle((m_Windowname $ ".barFishHp"));
	m_hFishHPBarFake = GetBarHandle((m_Windowname $ ".barFishHpFake"));
	m_hFishHPBarEffect = GetWindowHandle((m_Windowname $ ".wndEffect"));
	m_hFishViewportWnd = GetWindowHandle(m_Windowname);
	m_hTbSec = GetTextBoxHandle((m_Windowname $ ".txtVarSec"));
	m_hTexClock = GetWindowHandle((m_Windowname $ ".texClock"));
	m_hWndStatus = GetWindowHandle((m_Windowname $ ".wndStatus"));
	m_hTbStatus = GetTextBoxHandle((m_Windowname $ ".wndStatus.txtVarStatus"));
	m_hTbDeltaHP = GetTextBoxHandle((m_Windowname $ ".wndStatus.txtVarDeltaHP"));
	m_hFakeIcon = GetWindowHandle((m_Windowname $ ".texFakeIcon"));
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		default:
			return;
	}
}

function ShowHPBarNEtc(int ShowType, int Guts)
{
	m_hFishHPBar.ShowWindow();
	m_hTexClock.ShowWindow();
	m_hTbSec.ShowWindow();
	if((ShowType == 4))
	{
		m_hPumpingIcon.HideWindow();
		m_hPumpingText.HideWindow();
		m_hReelingIcon.HideWindow();
		m_hReelingText.HideWindow();
	}
	else if((m_FishLevel == 0))
	{
		if((Guts == 0))
		{
			m_hPumpingIcon.ShowWindow();
			m_hPumpingText.ShowWindow();
			m_hReelingIcon.HideWindow();
			m_hReelingText.HideWindow();
			if((m_FishState != "pumping"))
			{
				m_hPumpingIcon.SetTimer(4, 80);
				m_FishState = "pumping";
			}
		}
		else
		{
			m_hPumpingIcon.HideWindow();
			m_hPumpingText.HideWindow();
			m_hReelingIcon.ShowWindow();
			m_hReelingText.ShowWindow();
			if((m_FishState != "reeling"))
			{
				m_hReelingIcon.SetTimer(5, 80);
				m_FishState = "reeling";
			}
		}
	}
	return;
}

function HideHPBarNEtc()
{
	m_hFishHPBar.HideWindow();
	m_hFishHPBarFake.HideWindow();
	m_hTexClock.HideWindow();
	m_hTbSec.HideWindow();
	m_hPumpingIcon.HideWindow();
	m_hPumpingText.HideWindow();
	m_hReelingIcon.HideWindow();
	m_hReelingText.HideWindow();
	return;
}

function HandleInitFishStatus(string param)
{
	ParseInt(param, "OriginalFishHP", m_OriginalFishHP);
	ParseInt(param, "OriginalFishTime", m_OriginalFishTime);
	ParseInt(param, "FishLevel", m_FishLevel);
	m_CurrentFishHP = m_OriginalFishHP;
	return;
}

function HandleSetFishStatus(string param)
{
	local int FishHP, TimeCount, DeltaHP, ShowType, Guts, effect, Penalty, Fake;

	ParseInt(param, "CurrentFishHP", FishHP);
	ParseInt(param, "TimeCount", TimeCount);
	ParseInt(param, "ShowType", ShowType);
	ParseInt(param, "Effect", effect);
	ParseInt(param, "Guts", Guts);
	ParseInt(param, "Penalty", Penalty);
	ParseInt(param, "Fake", Fake);
	DeltaHP = (FishHP - m_CurrentFishHP);
	if((ShowType != 4))
	{
		m_CurrentFishHP = FishHP;
		m_hFishHPBar.SetValue((m_OriginalFishHP * 2), FishHP);
		m_hFishHPBarFake.SetValue((m_OriginalFishHP * 2), FishHP);
		m_hTbSec.SetText(string(TimeCount));
	}
	ShowHPBarNEtc(ShowType, Guts);
	if((!m_hFishHPBar.IsShowWindow() && ((m_OriginalFishTime - TimeCount) >= 3)))
	{
		ShowHPBarNEtc(ShowType, Guts);
	}
	if((ShowType == 3))
	{
		ShowFishString(1261, 0);
	}
	else if((ShowType == 4))
	{
		ShowFishString(1264, 0);
	}
	if((m_hFishHPBar.IsShowWindow() || m_hFishHPBarFake.IsShowWindow()))
	{
		if((effect != 0))
		{
			showeffect();
		}
		if((ShowType == 1))
		{
			if((DeltaHP < 0))
			{
				if((Penalty > 0))
				{
					ShowFishStringWithPenalty(1672, DeltaHP, Penalty);
				}
				else
				{
					ShowFishString(1256, DeltaHP);
				}
			}
			else
			{
				ShowFishString(1258, DeltaHP);
			}
		}
		else if((ShowType == 2))
		{
			if((DeltaHP < 0))
			{
				if((Penalty > 0))
				{
					ShowFishStringWithPenalty(1671, DeltaHP, Penalty);
				}
				else
				{
					ShowFishString(1257, DeltaHP);
				}
			}
			else
			{
				ShowFishString(1259, DeltaHP);
			}
		}
		if((Fake != 0))
		{
			m_hFishHPBarFake.ShowWindow();
			m_hFishHPBar.HideWindow();
			m_hFakeIcon.HideWindow();
			if((m_FishLevel == 0))
			{
				m_hFakeIcon.SetTimer(7, 80);
				m_hFakeIcon.ShowWindow();
			}
			else
			{
				m_hFakeIcon.HideWindow();
			}
		}
		else
		{
			m_hFishHPBarFake.HideWindow();
			m_hFishHPBar.ShowWindow();
			m_hFakeIcon.HideWindow();
		}
	}
	return;
}

function showeffect()
{
	m_hFishHPBarEffect.ShowWindow();
	m_hFishHPBarEffect.SetTimer(2, 1000);
	return;
}

function ShowFishString(int strID, int DeltaHP)
{
	local Color Col;

	if((DeltaHP > 0))
	{
		Col.R = 255;
		Col.G = 0;
		Col.B = 0;
	}
	else
	{
		Col.R = 220;
		Col.G = 220;
		Col.B = 220;
	}
	m_hTbStatus.SetTextColor(Col);
	m_hTbDeltaHP.SetTextColor(Col);
	m_hTbStatus.SetText(GetSystemString(strID));
	if((DeltaHP != 0))
	{
		m_hTbDeltaHP.SetText(string(DeltaHP));
	}
	else
	{
		m_hTbDeltaHP.SetText("");
	}
	m_hWndStatus.ShowWindow();
	m_hWndStatus.SetTimer(3, 0);
	return;
}

function ShowFishStringWithPenalty(int strID, int DeltaHP, int Penalty)
{
	local Color Col;

	Col.R = 255;
	Col.G = 0;
	Col.B = 0;
	m_hTbStatus.SetTextColor(Col);
	m_hTbDeltaHP.SetTextColor(Col);
	m_hTbStatus.SetText(GetSystemMessageWithParamNumber(strID, Penalty));
	if((DeltaHP != 0))
	{
		m_hTbDeltaHP.SetText(string(DeltaHP));
	}
	else
	{
		m_hTbDeltaHP.SetText("");
	}
	m_hWndStatus.ShowWindow();
	m_hWndStatus.SetTimer(3, 0);
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnRanking":
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
		case 7:
			++m_FakeTimerCount;
			if(((float(m_FakeTimerCount) % 2.0000000) == 0.0000000))
			{
				m_hFakeIcon.ShowWindow();
			}
			else if(((float(m_FakeTimerCount) % 2.0000000) == 1.0000000))
			{
				m_hFakeIcon.HideWindow();
			}
			if((m_FakeTimerCount > 2))
			{
				m_hFakeIcon.KillTimer(7);
				m_hFakeIcon.ShowWindow();
				m_FakeTimerCount = 0;
			}
			break;
			break;
		case 2:
			m_hFishHPBarEffect.KillTimer(TimerID);
			m_hFishHPBarEffect.HideWindow();
			break;
		case 3:
			m_hWndStatus.KillTimer(TimerID);
			m_hWndStatus.HideWindow();
			break;
		case 4:
			++m_PumpintTimerCount;
			if(((float(m_PumpintTimerCount) % 2.0000000) == 0.0000000))
			{
				m_hPumpingIcon.ShowWindow();
				m_hPumpingText.ShowWindow();
				m_hReelingIcon.HideWindow();
				m_hReelingText.HideWindow();
			}
			else if(((float(m_PumpintTimerCount) % 2.0000000) == 1.0000000))
			{
				m_hPumpingIcon.HideWindow();
				m_hPumpingText.HideWindow();
				m_hReelingIcon.HideWindow();
				m_hReelingText.HideWindow();
			}
			if((m_PumpintTimerCount > 2))
			{
				m_hPumpingIcon.KillTimer(4);
				m_PumpintTimerCount = 0;
				m_hPumpingIcon.ShowWindow();
				m_hPumpingText.ShowWindow();
			}
			break;
		case 5:
			++m_PumpintTimerCount;
			if(((float(m_PumpintTimerCount) % 2.0000000) == 0.0000000))
			{
				m_hReelingIcon.ShowWindow();
				m_hReelingText.ShowWindow();
				m_hPumpingIcon.HideWindow();
				m_hPumpingText.HideWindow();
			}
			else if(((float(m_PumpintTimerCount) % 2.0000000) == 1.0000000))
			{
				m_hReelingIcon.HideWindow();
				m_hReelingText.HideWindow();
				m_hPumpingIcon.HideWindow();
				m_hPumpingText.HideWindow();
			}
			if((m_PumpintTimerCount > 2))
			{
				m_hReelingIcon.KillTimer(5);
				m_PumpintTimerCount = 0;
				m_hReelingIcon.ShowWindow();
				m_hReelingText.ShowWindow();
			}
			break;
		default:
			break;
	}
	return;
}

function ClearTimer(int TimerID)
{
	if((TimerID == 4))
	{
		m_hPumpingIcon.ShowWindow();
		m_hPumpingText.ShowWindow();
		m_FishState = "pumping";
	}
	if((TimerID == 5))
	{
		m_hReelingIcon.ShowWindow();
		m_hReelingText.ShowWindow();
		m_FishState = "reeling";
	}
	return;
}

defaultproperties
{
	m_Windowname="FishViewportWnd"
}
