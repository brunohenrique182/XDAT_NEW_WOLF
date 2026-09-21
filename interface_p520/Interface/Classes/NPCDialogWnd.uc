class NPCDialogWnd extends UICommonAPI;

var string m_Windowname;
var WindowHandle m_hNPCDialogWnd;
var HtmlHandle m_hHtmlViewer;
var bool m_bRecievedCloseUI;
var bool m_bNpcZoomMode;

event OnRegisterEvent()
{
	RegisterEvent(3270);
	RegisterEvent(3280);
	RegisterEvent(3290);
	RegisterEvent(3321);
	RegisterEvent(150);
	RegisterEvent(160);
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	m_hNPCDialogWnd = GetWindowHandle(m_Windowname);
	m_hHtmlViewer = GetHtmlHandle((m_Windowname $ ".HtmlViewer"));
	return;
}

event OnShow()
{
	getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "QuestHTMLWnd,NPCDialogWnd");
	if(GetWindowHandle("MultiSellWnd").IsShowWindow())
	{
		GetWindowHandle("MultiSellWnd").HideWindow();
	}
	return;
}

event OnHide()
{
	ProcCloseNPCDialogWnd();
	getInstanceL2Util().syncWindowLocAuto("QuestHTMLWnd,NPCDialogWnd");
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 3270:
			ShowNPCDialogWnd();
			break;
		case 3280:
			HideNPCDialogWnd();
			break;
		case 3290:
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

event OnExitState(name a_CurrentStateName)
{
	if((a_CurrentStateName == 'NpcZoomCameraState'))
	{
		EndNpcZoomMode();
	}
	return;
}

event OnEnterState(name a_CurrentStateName)
{
	if((a_CurrentStateName == 'NpcZoomCameraState'))
	{
		BeginNpcZoomMode();
	}
	return;
}

event OnClickButton(string Name)
{
	PressCloseButton();
	return;
}

event OnHtmlMsgHideWindow(HtmlHandle a_HtmlHandle)
{
	if((a_HtmlHandle == m_hHtmlViewer))
	{
		HideNPCDialogWnd();
	}
	return;
}

function HandleLoadHtmlFromString(string param)
{
	local string tmpHtmlString;

	ParseString(param, "HTMLString", tmpHtmlString);
	m_hHtmlViewer.LoadHtmlFromString(tmpHtmlString);
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
	GetWindowHandle("NPCDialogWnd").HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="NPCDialogWnd"
}
