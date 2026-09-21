class MovieCaptureWnd_Expand extends UICommonAPI;

const TIMER_ID_COUNTUP = 7069;
const TIMER_DELAY = 1000;

var WindowHandle Me;
var ButtonHandle cBtn;
var WindowHandle m_Wnd;
var TextBoxHandle Timer;
var int secInt;

function OnLoad()
{
	if((1 == 0))
	{
	}
	else
	{
		Timer = TextBoxHandle(GetHandle("MovieCapturewnd_Expand.timer"));
	}
	Initialize();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("MovieCaptureWnd_Expand");
	m_Wnd = GetWindowHandle("MovieCaptureWnd");
	cBtn = GetButtonHandle("MovieCapturewnd_Expand.cBtn");
	Timer = GetTextBoxHandle("MovieCapturewnd_Expand.timer");
	return;
}

function OnTimer(int TimerID)
{
	if((TimerID == 7069))
	{
		secInt++;
	}
	setTimeTxt();
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "cBtn":
			MovieCaptureToggle();
			break;
		default:
			break;
	}
	return;
}

function string itoStr(int tmpNum)
{
	local string tmpStr;

	if((tmpNum < 10))
	{
		tmpStr = ("0" $ string(tmpNum));
	}
	else
	{
		tmpStr = string(tmpNum);
	}
	return tmpStr;
}

function setTimeTxt()
{
	Timer.SetText(((((itoStr(int((float(((secInt / 60) / 60)) % 60.0000000))) $ " : ") $ itoStr(int((float((secInt / 60)) % 60.0000000)))) $ " : ") $ itoStr(int((float(secInt) % 60.0000000)))));
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(5420);
	RegisterEvent(5430);
	RegisterEvent(5440);
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 5420:
			secInt = 0;
			setTimeTxt();
			Me.SetTimer(7069, 1000);
			break;
		case 5430:
			Me.KillTimer(7069);
			break;
		case 5440:
			Me.KillTimer(7069);
			break;
		default:
			break;
	}
	return;
}
