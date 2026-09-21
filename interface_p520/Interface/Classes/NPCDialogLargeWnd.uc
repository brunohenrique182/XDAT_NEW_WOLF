class NPCDialogLargeWnd extends UICommonAPI;

var string m_Windowname;
var WindowHandle m_hNPCDialogWnd;
var HtmlHandle m_hHtmlViewer;
var bool m_bRecievedCloseUI;
var bool m_bNpcZoomMode;

function OnRegisterEvent()
{
	RegisterEvent(3271);
	RegisterEvent(3281);
	RegisterEvent(3291);
	RegisterEvent(150);
	RegisterEvent(160);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	if((1 == 0))
	{
		m_hNPCDialogWnd = GetHandle(m_Windowname);
		m_hHtmlViewer = HtmlHandle(GetHandle((m_Windowname $ ".HtmlViewer")));
	}
	else
	{
		m_hNPCDialogWnd = GetWindowHandle(m_Windowname);
		m_hHtmlViewer = GetHtmlHandle((m_Windowname $ ".HtmlViewer"));
	}
	return;
}

function OnShow()
{
	getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "QuestHTMLWnd,NPCDialogWnd");
	if(GetWindowHandle("MultiSellWnd").IsShowWindow())
	{
		GetWindowHandle("MultiSellWnd").HideWindow();
	}
	return;
}

function OnHide()
{
	ProcCloseNPCDialogWnd();
	getInstanceL2Util().syncWindowLocAuto("QuestHTMLWnd,NPCDialogWnd");
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 3271:
			ShowNPCDialogWnd();
			break;
		case 3281:
			HideNPCDialogWnd();
			break;
		case 3291:
			setWindowTitleByString(GetSystemString(444));
			HandleLoadHtmlFromString(param);
			break;
		case 3321:
			m_hNPCDialogWnd.HideWindow();
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
	ProcCloseNPCDialogWnd();
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

function ShowNPCDialogWnd()
{
	ExecuteEvent(3324);
	m_hNPCDialogWnd.ShowWindow();
	m_hNPCDialogWnd.SetFocus();
	return;
}

function HideNPCDialogWnd()
{
	m_hNPCDialogWnd.HideWindow();
	return;
}

function ProcCloseNPCDialogWnd()
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
	PressCloseButton();
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("NPCDialogLargeWnd").HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="NPCDialogLargeWnd"
}
