class ZoneTitleWnd extends UICommonAPI;

const StartZoneNameX = 100;
const StartZoneNameY = 80;
const TIMER_ID = 0;
const TIMER_DELAY = 4000;

var string m_Windowname;
var WindowHandle m_hZoneTitleWnd;
var TextBoxHandle m_hTbZoneNameBack;
var TextBoxHandle m_hTbZoneNameFront;
var TextBoxHandle serverGroupTextBox;
var TextBoxHandle serverGroupTextBoxBack;

event OnRegisterEvent()
{
	RegisterEvent(2420);
	return;
}

event OnLoad()
{
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	if((1 == 0))
	{
		m_hZoneTitleWnd = GetHandle(m_Windowname);
		m_hTbZoneNameBack = TextBoxHandle(GetHandle((m_Windowname $ ".textZoneNameBack")));
		m_hTbZoneNameFront = TextBoxHandle(GetHandle((m_Windowname $ ".textZoneNameFront")));
		serverGroupTextBoxBack = TextBoxHandle(GetHandle((m_Windowname $ ".textWorldZoneNameBack")));
		serverGroupTextBox = TextBoxHandle(GetHandle((m_Windowname $ ".textWorldZoneName")));
	}
	else
	{
		m_hZoneTitleWnd = GetWindowHandle(m_Windowname);
		m_hTbZoneNameBack = GetTextBoxHandle((m_Windowname $ ".textZoneNameBack"));
		m_hTbZoneNameFront = GetTextBoxHandle((m_Windowname $ ".textZoneNameFront"));
		serverGroupTextBoxBack = GetTextBoxHandle((m_Windowname $ ".textWorldZoneNameBack"));
		serverGroupTextBox = GetTextBoxHandle((m_Windowname $ ".textWorldZoneName"));
	}
	return;
}

event OnEvent(int Event_ID, string param)
{
	local string zoneName, SubZoneName1, SubZoneName2, ServerGroupParam;

	switch(Event_ID)
	{
		case 2420:
			if((GetOptionBool("ScreenInfo", "ShowZoneTitle") == true))
			{
				ParseString(param, "ZoneName", zoneName);
				ParseString(param, "SubZoneName1", SubZoneName1);
				ParseString(param, "SubZoneName2", SubZoneName2);
				ParseString(param, "ServerGroupNames", ServerGroupParam);
				BeginShowZoneName(zoneName, GetServerGroupText(ServerGroupParam), SubZoneName1, SubZoneName2);
			}
			break;
		default:
			break;
	}
	return;
}

function BeginShowZoneName(string zoneName, string ServerGroupStr, string SubZoneName1, string SubZoneName2)
{
	local int textWidth, textHeight, ScreenWidth, ScreenHeight;

	m_hTbZoneNameBack.SetText(zoneName);
	m_hTbZoneNameFront.SetText(zoneName);
	serverGroupTextBox.SetText(ServerGroupStr);
	serverGroupTextBoxBack.SetText(ServerGroupStr);
	GetTextSize(zoneName, "ZoneTitle", textWidth, textHeight);
	GetCurrentResolution(ScreenWidth, ScreenHeight);
	m_hZoneTitleWnd.SetWindowSize((textWidth + 100), 200);
	m_hZoneTitleWnd.MoveTo((((ScreenWidth / 2) - (textWidth / 2)) - 100), ((ScreenHeight / 5) - 80));
	m_hZoneTitleWnd.ShowWindow();
	m_hZoneTitleWnd.SetTimer(0, 4000);
	return;
}

function string GetServerGroupText(string ServerGroupParam)
{
	if(((ServerGroupParam == "") || (IsAdenServer() == false)))
	{
		return "";
	}
	super.ReplaceText(ServerGroupParam, ";", " ");
	return ServerGroupParam;
}

event OnTimer(int TimerID)
{
	m_hZoneTitleWnd.KillTimer(TimerID);
	m_hZoneTitleWnd.HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="ZoneTitleWnd"
}
