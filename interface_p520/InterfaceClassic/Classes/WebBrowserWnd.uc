class WebBrowserWnd extends UICommonAPI;

var string m_Windowname;
var WindowHandle m_hWebBrowserWnd;
var WebBrowserHandle m_hBrowserViewer;
var string m_callBackFunction;

function OnRegisterEvent()
{
	RegisterEvent(5740);
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
		m_hWebBrowserWnd = GetHandle(m_Windowname);
		m_hBrowserViewer = WebBrowserHandle(GetHandle((m_Windowname $ ".WebBrowser")));
	}
	else
	{
		m_hWebBrowserWnd = GetWindowHandle(m_Windowname);
		m_hBrowserViewer = GetWebBrowserHandle((m_Windowname $ ".WebBrowser"));
	}
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

function ShowFileRegisterWnd(string param)
{
	ParseString(param, "CallBack", m_callBackFunction);
	FileRegisterWndShow(FH_WEBBROWSER_FILE_UPLOAD);
	return;
}

function UploadFileFullPath(string Path)
{
	local string Command;

	Command = (((m_callBackFunction $ "('") $ Path) $ "')");
	m_hBrowserViewer.ExecuteJavaScript(Command);
	FileRegisterWndHide();
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 5740:
			ShowFileRegisterWnd(param);
			break;
		default:
			break;
	}
	return;
}

defaultproperties
{
	m_Windowname="WebBrowserWnd"
}
