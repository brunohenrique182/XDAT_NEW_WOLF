class PremiumManagerWnd extends UICommonAPI;

var string m_Windowname;
var WindowHandle m_hPremiumManagerWnd;
var HtmlHandle m_hHtmlViewer;
var bool m_bRecievedCloseUI;
var bool m_bNpcZoomMode;

function OnRegisterEvent()
{
	RegisterEvent(11131);
	RegisterEvent(3280);
	RegisterEvent(11130);
	RegisterEvent(3321);
	RegisterEvent(150);
	RegisterEvent(160);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	m_hPremiumManagerWnd = GetWindowHandle(m_Windowname);
	m_hHtmlViewer = GetHtmlHandle((m_Windowname $ ".HtmlViewer"));
	return;
}

function OnShow()
{
	getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "QuestHTMLWnd,PremiumManagerWnd");
	if(GetWindowHandle("MultiSellWnd").IsShowWindow())
	{
		GetWindowHandle("MultiSellWnd").HideWindow();
	}
	SideBar(GetScript("SideBar")).ToggleByWindowName(m_Windowname, m_hPremiumManagerWnd.IsShowWindow());
	SideBar(GetScript("SideBar")).ToggleByWindowName("EinhasdWnd", m_hPremiumManagerWnd.IsShowWindow());
	return;
}

function OnHide()
{
	ProcClosePremiumManagerWnd();
	getInstanceL2Util().syncWindowLocAuto("QuestHTMLWnd,PremiumManagerWnd");
	SideBar(GetScript("SideBar")).ToggleByWindowName(m_Windowname, m_hPremiumManagerWnd.IsShowWindow());
	SideBar(GetScript("SideBar")).ToggleByWindowName("EinhasdWnd", m_hPremiumManagerWnd.IsShowWindow());
	return;
}

function OnEvent(int Event_ID, string param)
{
	local int bVitaminManager;

	switch(Event_ID)
	{
		case 11131:
			ShowPremiumManagerWnd();
			break;
		case 3280:
			HideNPCDialogWnd();
			break;
		case 11130:
			GetINIBool("Localize", "UseVitaminMgrLive", bVitaminManager, "L2.ini");
			if(((bVitaminManager == 0) && getInstanceUIData().GetIsLiveServer()))
			{
				m_hPremiumManagerWnd.SetWindowTitle(GetSystemString(13535));
			}
			else
			{
				m_hPremiumManagerWnd.SetWindowTitle(GetSystemString(3949));
			}
			HandleLoadHtmlFromString(param);
			break;
		case 3321:
			m_hPremiumManagerWnd.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function OnHtmlMsgHideWindow(HtmlHandle a_HtmlHandle)
{
	if((a_HtmlHandle == m_hHtmlViewer))
	{
		HideNPCDialogWnd();
	}
	return;
}

function HandleLoadHtmlFromString(string param)
{
	local string HtmlString;

	ParseString(param, "HTMLString", HtmlString);
	m_hHtmlViewer.LoadHtmlFromString(HtmlString);
	return;
}

function PressCloseButton()
{
	if(m_bNpcZoomMode)
	{
		m_bRecievedCloseUI = true;
	}
	return;
}

function OnClickButton(string Name)
{
	PressCloseButton();
	return;
}

function BeginNpcZoomMode()
{
	m_bRecievedCloseUI = false;
	m_bNpcZoomMode = true;
	return;
}

function EndNpcZoomMode()
{
	ProcClosePremiumManagerWnd();
	m_bRecievedCloseUI = false;
	m_bNpcZoomMode = false;
	return;
}

function OnExitState(name a_CurrentStateName)
{
	if((a_CurrentStateName == 'NpcZoomCameraState'))
	{
		EndNpcZoomMode();
	}
	return;
}

function OnEnterState(name a_CurrentStateName)
{
	if((a_CurrentStateName == 'NpcZoomCameraState'))
	{
		BeginNpcZoomMode();
	}
	return;
}

function ShowPremiumManagerWnd()
{
	ExecuteEvent(3324);
	m_hPremiumManagerWnd.ShowWindow();
	m_hPremiumManagerWnd.SetFocus();
	return;
}

function HideNPCDialogWnd()
{
	m_hPremiumManagerWnd.HideWindow();
	return;
}

function ProcClosePremiumManagerWnd()
{
	if((m_bRecievedCloseUI && m_bNpcZoomMode))
	{
		m_bRecievedCloseUI = false;
		RequestFinishNPCZoomCamera();
	}
	return;
}

function OnReceivedCloseUI()
{
	m_Windowname = "PremiumManagerWnd";
	PressCloseButton();
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("PremiumManagerWnd").HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="PremiumManagerWnd"
}
