class DieLimitTimeWnd extends UICommonAPI
	dependson(UIPacket);

var WindowHandle Me;
var string m_Windowname;
var L2UITimerObject uiTimer;
var int TimerNum;
var TextBoxHandle DieLimitTime_txt;

event OnRegisterEvent()
{
	RegisterEvent(1440);
	RegisterEvent(11250);
	RegisterEvent((100000 + 1029));
	RegisterEvent((100000 + 1072));
	return;
}

event OnLoad()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	DieLimitTime_txt = GetTextBoxHandle((m_Windowname $ ".DieLimitTime_txt"));
	uiTimer = Class'InterfaceClassic.L2UITimer'.static.Inst()._MakeTimerObject();
	uiTimer._DelegateOnTime = HandleOnTime;
	uiTimer._DelegateOnEnd = HandleOnTimeEnd;
	return;
}

event OnEvent(int Event_ID, string param)
{
	if((Event_ID == (100000 + 1029)))
	{
		Handle_S_EX_TIME_RESTRICT_FIELD_DIE_LIMT_TIME();
	}
	if((Event_ID == (100000 + 1072)))
	{
		Handle_S_EX_FIELD_DIE_LIMT_TIME();
	}
	else if(((Event_ID == 1440) || (Event_ID == 11250)))
	{
		Me.HideWindow();
		uiTimer._Stop();
	}
	return;
}

function Handle_S_EX_FIELD_DIE_LIMT_TIME()
{
	local UIPacket._S_EX_FIELD_DIE_LIMT_TIME packet;
	local int times;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_FIELD_DIE_LIMT_TIME(packet))
	{
		return;
	}
	Debug(("_S_EX_FIELD_DIE_LIMT_TIME, nDieLimitTime : " @ string(packet.nDieLimitTime)));
	times = packet.nDieLimitTime;
	TimerNum = times;
	DieLimitTime_txt.SetText(getInstanceL2Util().TimeNumberToString(TimerNum));
	Me.ShowWindow();
	uiTimer._maxCount = times;
	uiTimer._Play();
	return;
}

function Handle_S_EX_TIME_RESTRICT_FIELD_DIE_LIMT_TIME()
{
	local UIPacket._S_EX_TIME_RESTRICT_FIELD_DIE_LIMT_TIME packet;
	local int times;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_TIME_RESTRICT_FIELD_DIE_LIMT_TIME(packet))
	{
		return;
	}
	times = packet.nDieLimitTime;
	TimerNum = times;
	DieLimitTime_txt.SetText(getInstanceL2Util().TimeNumberToString(TimerNum));
	Me.ShowWindow();
	uiTimer._maxCount = times;
	uiTimer._Play();
	return;
}

function HandleOnTime(int t)
{
	TimerNum = (TimerNum - 1);
	DieLimitTime_txt.SetText(getInstanceL2Util().TimeNumberToString(TimerNum));
	return;
}

function HandleOnTimeEnd()
{
	Me.HideWindow();
	uiTimer._Stop();
	return;
}

function ShowHide(string Name)
{
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow(Name))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow(Name);
	}
	else
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(Name);
		Class'NWindow.UIAPI_WINDOW'.static.SetFocus(Name);
	}
	return;
}

event OnHide()
{
	GetWindowHandle("RestartMenuWndOption").HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="DieLimitTimeWnd"
}
