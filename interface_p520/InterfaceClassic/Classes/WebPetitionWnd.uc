class WebPetitionWnd extends UICommonAPI;

var string m_Windowname;
var WindowHandle m_hPetitionWnd;
var WebBrowserHandle m_hBrowserViewer;
var EditBoxHandle ChatEditBox;

function OnRegisterEvent()
{
	RegisterEvent(9450);
	RegisterEvent(9451);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	m_hPetitionWnd = GetWindowHandle(m_Windowname);
	m_hBrowserViewer = GetWebBrowserHandle((m_Windowname $ ".WebBrowser"));
	ChatEditBox = GetEditBoxHandle("ChatWnd.ChatEditBox");
	return;
}

function OnShow()
{
	m_hBrowserViewer.ShowWindow();
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("IngameWebWnd"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("IngameWebWnd");
	}
	return;
}

function OnHide()
{
	m_hBrowserViewer.HideWindow();
	return;
}

function NavigateToPetitionPage()
{
	local string UserName;
	local int serverNo;
	local string lineage2PetitionURL, strNpLoginWebURL;
	local WebRequestInfo requestInfo;

	if(GetINIString("URL", "L2InGameBrowserPetitionURL", lineage2PetitionURL, "l2.ini"))
	{
		if(GetINIString("URL", "NPLoginWebURL", strNpLoginWebURL, "l2.ini"))
		{
			serverNo = GetServerNo();
			UserName = GetPlayerRealName();
			requestInfo.eMethodType = EWMT_GET;
			requestInfo.strRequestUrl = lineage2PetitionURL;
			requestInfo.strNPAuthTokenLoginUrl = (strNpLoginWebURL $ "/sso");
			requestInfo.arrRequestParams.Length = 6;
			requestInfo.arrRequestParams[0].strKey = "service";
			requestInfo.arrRequestParams[0].strValue = "lin2";
			requestInfo.arrRequestParams[1].strKey = "locale";
			requestInfo.arrRequestParams[1].strValue = "ko-KR";
			requestInfo.arrRequestParams[2].strKey = "sdk";
			requestInfo.arrRequestParams[2].strValue = "Lineage2Ingame";
			requestInfo.arrRequestParams[3].strKey = "hideTopBar";
			requestInfo.arrRequestParams[3].strValue = "true";
			requestInfo.arrRequestParams[4].bNeedUrlEncode = true;
			requestInfo.arrRequestParams[4].strKey = "characterName";
			requestInfo.arrRequestParams[4].strValue = UserName;
			requestInfo.arrRequestParams[5].strKey = "serverNo";
			requestInfo.arrRequestParams[5].strValue = string(serverNo);
			m_hBrowserViewer.Navigate(requestInfo);
		}
	}
	return;
}

function HandleShowWebPetitionMainPage()
{
	ChatEditBox.ReleaseFocus();
	m_hPetitionWnd.ShowWindow();
	m_hPetitionWnd.SetFocus();
	NavigateToPetitionPage();
	return;
}

function HandleShowWebPetitionListPage()
{
	m_hPetitionWnd.ShowWindow();
	m_hPetitionWnd.SetFocus();
	NavigateToPetitionPage();
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 9450:
			HandleShowWebPetitionMainPage();
			break;
		case 9451:
			HandleShowWebPetitionListPage();
			break;
		default:
			break;
	}
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("WebPetitionWnd").HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="WebPetitionWnd"
}
