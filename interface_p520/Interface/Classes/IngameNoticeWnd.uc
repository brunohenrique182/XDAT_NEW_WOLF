class IngameNoticeWnd extends UICommonAPI;

var string m_Windowname;
var WindowHandle m_hIngameNoticeWnd;
var WebBrowserHandle m_hBrowserViewer;

function OnLoad()
{
	SetClosingOnESC();
	m_hIngameNoticeWnd = GetWindowHandle(m_Windowname);
	m_hBrowserViewer = GetWebBrowserHandle((m_Windowname $ ".WebBrowser"));
	return;
}

function OnShow()
{
	m_hBrowserViewer.ShowWindow();
	if((m_hBrowserViewer.GetUrl() == ""))
	{
		MainMenuShow();
	}
	return;
}

function OnHide()
{
	m_hBrowserViewer.HideWindow();
	return;
}

function OnRegisterEvent()
{
	return;
}

function NavigateToPetitionPage()
{
	local UserInfo UserInfo;
	local int serverNo;
	local string lineage2NoticeURL;
	local WebRequestInfo requestInfo;

	serverNo = GetServerNo();
	GetPlayerInfo(UserInfo);
	if(GetINIString("URL", "L2InGameBrowserNoticeURL", lineage2NoticeURL, "l2.ini"))
	{
		requestInfo.eMethodType = EWMT_POST;
		requestInfo.strRequestUrl = lineage2NoticeURL;
		requestInfo.arrRequestParams.Length = 2;
		requestInfo.arrRequestParams[0].strKey = "server_id";
		requestInfo.arrRequestParams[0].strValue = string(serverNo);
		requestInfo.arrRequestParams[1].strKey = "char_name";
		requestInfo.arrRequestParams[1].strValue = UserInfo.Name;
		m_hBrowserViewer.Navigate(requestInfo);
	}
	return;
}

function MainMenuShow()
{
	local UserInfo UserInfo;
	local int serverNo;
	local string lineage2NoticeURL;
	local WebRequestInfo requestInfo;

	serverNo = GetServerNo();
	GetPlayerInfo(UserInfo);
	if(GetINIString("URL", "L2InGameBrowserNoticeURL", lineage2NoticeURL, "l2.ini"))
	{
		requestInfo.eMethodType = EWMT_POST;
		requestInfo.strRequestUrl = lineage2NoticeURL;
		requestInfo.arrRequestParams.Length = 2;
		requestInfo.arrRequestParams[0].strKey = "server_id";
		requestInfo.arrRequestParams[0].strValue = string(serverNo);
		requestInfo.arrRequestParams[1].strKey = "char_name";
		requestInfo.arrRequestParams[1].strValue = UserInfo.Name;
		m_hBrowserViewer.Navigate(requestInfo);
	}
	return;
}

function IsOpenWnd(string param)
{
	local string URL;
	local UserInfo UserInfo;
	local int serverNo;
	local string cookieKey;

	ParseString(param, "url", URL);
	if((URL == m_hBrowserViewer.GetUrl()))
	{
		if((m_hIngameNoticeWnd.IsShowWindow() == true))
		{
			m_hBrowserViewer.ExecuteJavaScript("getNoticeOpenStatus();");
		}
		else
		{
			serverNo = GetServerNo();
			GetPlayerInfo(UserInfo);
			cookieKey = (((UserInfo.Name $ "_") $ string(serverNo)) $ "_not_notice_again");
			if((m_hBrowserViewer.GetCookie(URL, cookieKey) == ""))
			{
				m_hBrowserViewer.ExecuteJavaScript("getNoticeOpenStatus();");
			}
			else
			{
				m_hBrowserViewer.HideWindow();
			}
		}
	}
	return;
}

function OpenWnd(string param)
{
	local string strStatus;

	ParseString(param, "Status", strStatus);
	if((strStatus == "Y"))
	{
		m_hIngameNoticeWnd.ShowWindow();
		m_hIngameNoticeWnd.SetFocus();
	}
	else
	{
		m_hBrowserViewer.HideWindow();
		m_hIngameNoticeWnd.HideWindow();
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 5750:
			IsOpenWnd(param);
			break;
		case 9750:
			NavigateToPetitionPage();
			break;
		case 5752:
			OpenWnd(param);
			break;
		default:
			break;
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
	m_Windowname="IngameNoticeWnd"
}
