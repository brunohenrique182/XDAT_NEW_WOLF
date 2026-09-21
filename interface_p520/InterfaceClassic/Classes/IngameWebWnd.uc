class IngameWebWnd extends UICommonAPI;

const Time_ID_Delay = 102234;
const LINEAGE2_WEB_ID = 32;
const TIMER_ID_WEB_SESSION = 8989;
const INGAMEWEB_SECTION_CLASSIC = "IngameWeb_Classic";
const INGAMEWEB_SECTION_LIVE = "IngameWeb_Live";
const REFRESH_WEB_SESSION_TIME = 2400000;

var string m_Windowname;
var WindowHandle m_hIngameWebWnd;
var WebBrowserHandle m_hBrowserViewer;
var WebBrowserHandle m_hBrowserForSessionRefresh;
var bool m_bCheckFinishPageForSession;
var string m_strRequestURL;
var string lastShowCategory;
var string Key;

function OnLoad()
{
	SetClosingOnESC();
	m_hIngameWebWnd = GetWindowHandle(m_Windowname);
	m_hBrowserViewer = GetWebBrowserHandle((m_Windowname $ ".WebBrowser"));
	m_hBrowserForSessionRefresh = GetWebBrowserHandle((m_Windowname $ ".WebBrowserForSession"));
	m_hBrowserForSessionRefresh.HideWindow();
	m_bCheckFinishPageForSession = false;
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(5750);
	RegisterEvent(10120);
	RegisterEvent(10140);
	RegisterEvent(5751);
	RegisterEvent(5753);
	RegisterEvent(9750);
	RegisterEvent(2900);
	return;
}

function OnSetFocus(WindowHandle a_WindowHandle, bool bFocused)
{
	if(((a_WindowHandle.GetWindowName() == m_Windowname) && (bFocused == true)))
	{
		if(!m_hBrowserViewer.IsFocused())
		{
			m_hBrowserViewer.SetFocus();
		}
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 5750:
			OnWebBrowser_FinishedLoading(param);
			break;
		case 10120:
			if(!getInstanceUIData().getIsArenaServer())
			{
				NavigatePage(param);
			}
			break;
		case 10140:
			m_hIngameWebWnd.HideWindow();
			break;
		case 5751:
			OnWebBrowser_ReceivedTitle(param);
			m_hIngameWebWnd.SetFocus();
			break;
		case 5753:
			SetWindowType(param);
			break;
		case 40:
			lastShowCategory = "";
			break;
		case 9750:
			if(getInstanceUIData().GetIsClassicServer())
			{
			}
			break;
		case 2900:
			CheckWindowLoc();
			break;
		default:
			break;
	}
	return;
}

function HandleOpenCategory(string Category)
{
	local string strURL;

	if(GetUrlPageAtL2INI(Category, strURL))
	{
		lastShowCategory = Category;
		NavigateUrlPage(strURL);
	}
	return;
}

function SetWindowType(string param)
{
	local int nW, nH;

	ParseString(param, "key", Key);
	SideBar(GetScript("SideBar")).ToggleByWindowName("NShopWnd", (Key == "l2nshop"));
	nW = 971;
	nH = 817;
	m_hIngameWebWnd.SetWindowSize((nW + 21), (nH + 49));
	m_hBrowserViewer.SetWindowSize(nW, nH);
	m_hBrowserForSessionRefresh.SetWindowSize(nW, nH);
	return;
}

function NavigatePage(string param)
{
	local string Category, Message;
	local WindowHandle TempWnd;

	ParseString(param, "Category", Category);
	ParseString(param, "Message", Message);
	if((Category == "url"))
	{
		NavigateUrlPage(Message);
	}
	else if((Category == "test_url"))
	{
		NavigateUrlPageWithoutNPToken(Message);
	}
	else if((Category == "check_session"))
	{
		TestCheckSession();
	}
	else if((Category == "bbs"))
	{
		TempWnd = GetWindowHandle("BoardWnd");
		if(TempWnd.IsShowWindow())
		{
			TempWnd.HideWindow();
		}
		else
		{
			ExecuteEvent(1190);
		}
	}
	else
	{
		if(((lastShowCategory == Category) && IsShowWindow("InGameWebWnd")))
		{
			HideWindow("InGameWebWnd");
			return;
		}
		HandleOpenCategory(Category);
	}
	return;
}

function string GetParameterForNPSession(string strURL, out array<WebRequestParam> arrParams)
{
	local UserInfo UserInfo;
	local int serverNo, lineage2WebID;
	local string strExtraParam;
	local int nStrIndex, nArrayIndex;
	local string strKey, strValue;

	nStrIndex = InStr(strURL, "?");
	if((nStrIndex > 0))
	{
		strExtraParam = Mid(strURL, (nStrIndex + 1));
		strURL = Left(strURL, nStrIndex);
	}
	lineage2WebID = 32;
	serverNo = GetServerNo();
	GetPlayerInfo(UserInfo);
	nArrayIndex = arrParams.Length;
	arrParams.Insert(nArrayIndex, 1);
	arrParams[nArrayIndex].strKey = "target";
	arrParams[nArrayIndex].strValue = string(lineage2WebID);
	nArrayIndex++;
	arrParams.Insert(nArrayIndex, 1);
	arrParams[nArrayIndex].strKey = "server_id";
	arrParams[nArrayIndex].strValue = string(serverNo);
	nArrayIndex++;
	arrParams.Insert(nArrayIndex, 1);
	arrParams[nArrayIndex].bNeedUrlEncode = true;
	arrParams[nArrayIndex].strKey = "char_name";
	arrParams[nArrayIndex].strValue = UserInfo.Name;
	nArrayIndex++;
	if((Len(strExtraParam) > 0))
	{
		nStrIndex = InStr(strExtraParam, "=");
		while((nStrIndex > 0))
		{
			strKey = Left(strExtraParam, nStrIndex);
			strExtraParam = Mid(strExtraParam, (nStrIndex + 1));
			nStrIndex = InStr(strExtraParam, "&");
			if((nStrIndex > 0))
			{
				strValue = Left(strExtraParam, nStrIndex);
				strExtraParam = Mid(strExtraParam, (nStrIndex + 1));
			}
			else
			{
				strValue = strExtraParam;
			}
			arrParams.Insert(nArrayIndex, 1);
			arrParams[nArrayIndex].strKey = strKey;
			arrParams[nArrayIndex].strValue = strValue;
			nArrayIndex++;
			nStrIndex = InStr(strExtraParam, "=");
		}
	}
	return strURL;
}

function CloseAnotherWebWnd()
{
	return;
}

function bool GetUrlPageAtL2INI(string Category, out string outURL)
{
	local string strSection;

	if(getInstanceUIData().GetIsClassicServer())
	{
		strSection = "IngameWeb_Classic";
	}
	else
	{
		strSection = "IngameWeb_Live";
	}
	if(GetINIString(strSection, Category, outURL, "l2.ini"))
	{
		return true;
	}
	return false;
}

function NavigateUrlPage(string strURL)
{
	local string strNpLoginWebURL;
	local WebRequestInfo requestInfo;

	if(IsPlayerOnWorldRaidServer())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
		return;
	}
	m_hIngameWebWnd.ShowWindow();
	m_hIngameWebWnd.SetFocus();
	if(GetINIString("URL", "NPLoginWebURL", strNpLoginWebURL, "l2.ini"))
	{
		CloseAnotherWebWnd();
		m_bCheckFinishPageForSession = true;
		m_hIngameWebWnd.KillTimer(8989);
		requestInfo.eMethodType = EWMT_GET;
		requestInfo.strRequestUrl = GetParameterForNPSession(strURL, requestInfo.arrRequestParams);
		requestInfo.strNPAuthTokenLoginUrl = (strNpLoginWebURL $ "/sso");
		requestInfo.arrHeaderParams.Length = 1;
		requestInfo.arrHeaderParams[0].strKey = "User-Agent";
		requestInfo.arrHeaderParams[0].strValue = "Lineage2";
		m_hBrowserViewer.Navigate(requestInfo);
		m_strRequestURL = strURL;
	}
	return;
}

function NavigateUrlPageWithoutNPToken(string strURL)
{
	local WebRequestInfo requestInfo;

	m_hIngameWebWnd.ShowWindow();
	requestInfo.eMethodType = EWMT_GET;
	requestInfo.strRequestUrl = strURL;
	requestInfo.arrHeaderParams.Length = 1;
	requestInfo.arrHeaderParams[0].strKey = "User-Agent";
	requestInfo.arrHeaderParams[0].strValue = "Lineage2";
	m_hBrowserViewer.Navigate(requestInfo);
	m_strRequestURL = strURL;
	return;
}

function bool TestCheckSession()
{
	local WebRequestInfo requestInfo;

	requestInfo.eMethodType = EWMT_GET;
	requestInfo.strRequestUrl = "http://dev.mlogin.plaync.com/test/ingamesso";
	m_hBrowserViewer.Navigate(requestInfo);
	return true;
}

function bool RefreshWebSession()
{
	local string strNpLoginWebURL;
	local WebRequestInfo requestInfo;

	if(GetINIString("URL", "NPLoginWebURL", strNpLoginWebURL, "l2.ini"))
	{
		requestInfo.eMethodType = EWMT_GET;
		requestInfo.strRequestUrl = (strNpLoginWebURL $ "/check");
		requestInfo.arrRequestParams.Length = 1;
		requestInfo.arrRequestParams[0].strKey = "return_url";
		requestInfo.arrRequestParams[0].strValue = "about:blank";
		requestInfo.arrHeaderParams.Length = 1;
		requestInfo.arrHeaderParams[0].strKey = "Accept";
		requestInfo.arrHeaderParams[0].strValue = "application/json";
		m_hBrowserForSessionRefresh.Navigate(requestInfo);
	}
	return true;
}

function OnHide()
{
	m_hIngameWebWnd.KillTimer(8989);
	m_bCheckFinishPageForSession = false;
	lastShowCategory = "";
	m_hBrowserViewer.HideWindow();
	m_hBrowserForSessionRefresh.HideWindow();
	SideBar(GetScript("SideBar")).ToggleByWindowName("NShopWnd", false);
	return;
}

function OnTimer(int TimerID)
{
	if((TimerID == 8989))
	{
		RefreshWebSession();
		m_hIngameWebWnd.KillTimer(8989);
		m_hIngameWebWnd.SetTimer(8989, 2400000);
	}
	return;
}

function OnWebBrowser_FinishedLoading(string param)
{
	local string URL, strNpLoginWebURL;
	local int Index;

	ParseString(param, "url", URL);
	if((m_bCheckFinishPageForSession && GetINIString("URL", "NPLoginWebURL", strNpLoginWebURL, "l2.ini")))
	{
		Index = InStr(URL, m_strRequestURL);
		if((Index >= 0))
		{
			m_hIngameWebWnd.KillTimer(8989);
			m_hIngameWebWnd.SetTimer(8989, 2400000);
			m_bCheckFinishPageForSession = false;
		}
	}
	return;
}

function OnWebBrowser_ReceivedTitle(string param)
{
	local string WindowName, Title;

	ParseString(param, "WindowName", WindowName);
	ParseString(param, "Title", Title);
	if(((InStr(WindowName, "IngameWebWnd") >= 0) && (Len(Title) > 0)))
	{
		setWindowTitleByString(Title);
	}
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

function OnShow()
{
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("WebPetitionWnd"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("WebPetitionWnd");
	}
	m_hBrowserViewer.ShowWindow();
	CheckWindowLoc();
	return;
}

function OnDefaultPosition()
{
	CheckWindowLoc();
	return;
}

function CheckWindowLoc()
{
	local Rect R;

	R = GetWindowHandle("IngameWebWnd").GetRect();
	if(((getInstanceUIData().GetScreenWidth() != 0) && (getInstanceUIData().GetScreenHeight() != 0)))
	{
		if(((R.nX + R.nWidth) > getInstanceUIData().GetScreenWidth()))
		{
			R.nX = (getInstanceUIData().GetScreenWidth() - R.nWidth);
		}
		if((R.nY < 0))
		{
			R.nY = 0;
		}
		GetWindowHandle("IngameWebWnd").MoveC(R.nX, R.nY);
	}
	return;
}

defaultproperties
{
	m_Windowname="IngameWebWnd"
}
