class HelpHtmlWnd extends UICommonAPI;

var bool m_bShow;
var string m_Windowname;
var HtmlHandle m_hHelpHtmlWndHtmlViewer;

function OnRegisterEvent()
{
	RegisterEvent(1210);
	RegisterEvent(1220);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	RegisterState("HelpHtmlWnd", "GamingState");
	RegisterState("HelpHtmlWnd", "LoginState");
	m_hHelpHtmlWndHtmlViewer = GetHtmlHandle("HelpHtmlWnd.HtmlViewer");
	m_bShow = false;
	return;
}

function OnShow()
{
	m_bShow = true;
	return;
}

function OnHide()
{
	m_bShow = false;
	return;
}

function OnEvent(int Event_ID, string param)
{
	local string strPath;

	ParseString(param, "FilePath", strPath);
	if((GetGameStateName() != "SERVERLISTSTATE"))
	{
		if((((((strPath != (GetLocalizedL2TextPathNameUC() $ "ev_eventcollector001.htm")) && (strPath != (GetLocalizedL2TextPathNameUC() $ "g_attendance_help001.htm"))) && (strPath != (GetLocalizedL2TextPathNameUC() $ "g_l2pass_help.htm"))) && (strPath != (GetLocalizedL2TextPathNameUC() $ "g_uniquegacha_japan001.htm"))) && !getInstanceUIData().GetIsClassicServer()))
		{
			return;
		}
	}
	if((Event_ID == 1210))
	{
		HandleShowHelp(param);
	}
	else if((Event_ID == 1220))
	{
		HandleLoadHelpHtml(param);
	}
	return;
}

function HandleShowHelp(string param)
{
	local string strPath;

	if(m_bShow)
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("HelpHtmlWnd");
	}
	else
	{
		ParseString(param, "FilePath", strPath);
		if((Len(strPath) > 0))
		{
			if((strPath == (GetLocalizedL2TextPathNameUC() $ "server_help.htm")))
			{
				Class'NWindow.UIAPI_WINDOW'.static.SetAlwaysOnTop("HelpHtmlWnd", true);
			}
			else
			{
				Class'NWindow.UIAPI_WINDOW'.static.SetAlwaysOnTop("HelpHtmlWnd", false);
			}
			m_hHelpHtmlWndHtmlViewer.LoadHtml(strPath);
			PlayConsoleSound(IFST_WINDOW_OPEN);
			Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("HelpHtmlWnd");
			Class'NWindow.UIAPI_WINDOW'.static.SetFocus("HelpHtmlWnd");
		}
	}
	return;
}

function exShowHelp(string strPath)
{
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("HelpHtmlWnd"))
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("HelpHtmlWnd");
	}
	else if((Len(strPath) > 0))
	{
		m_hHelpHtmlWndHtmlViewer.LoadHtml(strPath);
		PlayConsoleSound(IFST_WINDOW_OPEN);
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("HelpHtmlWnd");
		Class'NWindow.UIAPI_WINDOW'.static.SetFocus("HelpHtmlWnd");
	}
	return;
}

function HandleLoadHelpHtml(string param)
{
	local string strHtml;

	ParseString(param, "HtmlString", strHtml);
	if((Len(strHtml) > 0))
	{
		m_hHelpHtmlWndHtmlViewer.LoadHtmlFromString(strHtml);
	}
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="HelpHtmlWnd"
}
