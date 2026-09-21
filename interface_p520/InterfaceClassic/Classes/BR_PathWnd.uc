class BR_PathWnd extends UICommonAPI;

const N_MAX_WEB_RES_X = 1024;
const N_MAX_WEB_RES_Y = 1024;
const N_BUTTON_HEAD_AREA_BUFFER = 75;

var string m_Windowname;
var WindowHandle m_hPathWnd;
var WebBrowserHandle m_hBrowserViewer;
var EditBoxHandle ChatEditBox;
var bool m_firstOpen;

function OnRegisterEvent()
{
	RegisterEvent(10010);
	RegisterEvent(10011);
	RegisterEvent(10012);
	RegisterEvent(2900);
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
		m_hPathWnd = GetHandle(m_Windowname);
		m_hBrowserViewer = WebBrowserHandle(GetHandle((m_Windowname $ ".WebBrowser")));
	}
	else
	{
		m_hPathWnd = GetWindowHandle(m_Windowname);
		m_hBrowserViewer = GetWebBrowserHandle((m_Windowname $ ".WebBrowser"));
	}
	m_firstOpen = false;
	return;
}

function OnShow()
{
	m_hBrowserViewer.ShowWindow();
	return;
}

function OnHide()
{
	m_hBrowserViewer.HideWindow();
	return;
}

function NavigateToPathPage(string additionalURL)
{
	local string lineage2PathMapURL;
	local WebRequestInfo requestInfo;

	requestInfo.eMethodType = EWMT_POST;
	if((additionalURL == "main"))
	{
		if(GetINIString("URL", "L2InGameBrowserPathMapURL", lineage2PathMapURL, "l2.ini"))
		{
			requestInfo.strRequestUrl = lineage2PathMapURL;
		}
	}
	else
	{
		requestInfo.strRequestUrl = additionalURL;
	}
	m_hBrowserViewer.Navigate(requestInfo);
	return;
}

function HandleShowWebPathMapMainPage(string param)
{
	local string URL;

	ParseString(param, "Message", URL);
	if((URL == ""))
	{
		URL = "main";
	}
	if((m_firstOpen == false))
	{
		m_firstOpen = true;
		CheckResolution();
	}
	ChatEditBox.ReleaseFocus();
	m_hPathWnd.ShowWindow();
	m_hPathWnd.SetFocus();
	NavigateToPathPage(URL);
	return;
}

function HandleShowWebPathMapListPage()
{
	m_hPathWnd.ShowWindow();
	m_hPathWnd.SetFocus();
	NavigateToPathPage("list");
	return;
}

function HandleShowWebPathAlarm(string param)
{
	local int PathToAwakeningAlarmType, PathToAwakeningAlarmValue;

	PathToAwakeningAlarmType = 0;
	PathToAwakeningAlarmValue = 0;
	m_hPathWnd.ShowWindow();
	m_hPathWnd.SetFocus();
	ParseInt(param, "Type", PathToAwakeningAlarmType);
	ParseInt(param, "Value", PathToAwakeningAlarmValue);
	Debug((((" ShowWebPathAlarm Type" @ string(PathToAwakeningAlarmType)) @ "Value") @ string(PathToAwakeningAlarmValue)));
	NavigateToPathPage("list");
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 10010:
			HandleShowWebPathMapMainPage(param);
			break;
		case 10011:
			HandleShowWebPathMapListPage();
			break;
		case 10012:
			HandleShowWebPathAlarm(param);
			break;
		case 2900:
			HandleResolutionChanged(param);
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "HomeButton":
			NavigateToPathPage("main");
			break;
		case "PrevButton":
			break;
		case "NextButton":
			break;
		default:
			break;
	}
	return;
}

function HandleResolutionChanged(string aParam)
{
	local int NewWidth, NewHeight;

	ParseInt(aParam, "NewWidth", NewWidth);
	ParseInt(aParam, "NewHeight", NewHeight);
	if(((NewWidth <= 0) || (NewHeight <= 0)))
	{
		return;
	}
	ResetWebSize(NewWidth, NewHeight);
	return;
}

function CheckResolution()
{
	local int CurrentMaxWidth, CurrentMaxHeight;

	GetCurrentResolution(CurrentMaxWidth, CurrentMaxHeight);
	ResetWebSize(CurrentMaxWidth, CurrentMaxHeight);
	return;
}

function ResetWebSize(int currentWidth, int currentHeight)
{
	local int adjustedwidth, adjustedheight, MainMapWidth, MainMapHeight;

	MainMapWidth = currentWidth;
	MainMapHeight = currentHeight;
	adjustedwidth = (currentWidth - 19);
	adjustedheight = ((currentHeight - 75) - 5);
	if((currentWidth > 1024))
	{
		adjustedwidth = (1024 - 19);
		MainMapWidth = 1024;
	}
	if((currentHeight > 1024))
	{
		adjustedheight = (1024 - 75);
		MainMapHeight = 1024;
	}
	m_hPathWnd.SetWindowSize((MainMapWidth + 2), (MainMapHeight - 2));
	m_hBrowserViewer.SetWindowSize((adjustedwidth + 2), (adjustedheight - 2));
	return;
}

defaultproperties
{
	m_Windowname="BR_PathWnd"
}
