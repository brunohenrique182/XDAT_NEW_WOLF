class ItemDescWnd extends UICommonAPI;

var WindowHandle m_hItemDescWnd;
var HtmlHandle m_hHtmlViewer;

event OnRegisterEvent()
{
	RegisterEvent(3300);
	RegisterEvent(3310);
	RegisterEvent(3320);
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	m_hItemDescWnd = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath);
	m_hHtmlViewer = GetHtmlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HtmlViewer"));
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 3300:
			m_hItemDescWnd.ShowWindow();
			m_hItemDescWnd.SetFocus();
			break;
		case 3310:
			HandleLoadHtmlFromString(param);
			break;
		case 3320:
			HandleWindowTitle(param);
			break;
		default:
			break;
	}
	return;
}

event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath).HideWindow();
	return;
}

function ShowHelp(string strPath)
{
	if((Len(strPath) > 0))
	{
		m_hHtmlViewer.LoadHtml(strPath);
		m_hItemDescWnd.ShowWindow();
		m_hItemDescWnd.SetFocus();
	}
	return;
}

function _LoadHtmlFromString(string HtmlString)
{
	m_hHtmlViewer.LoadHtmlFromString(HtmlString);
	return;
}

function HandleWindowTitle(string param)
{
	local string Title;

	ParseString(param, "Title", Title);
	setWindowTitleByString(Title);
	return;
}

function HandleLoadHtmlFromString(string param)
{
	local string HtmlString;

	ParseString(param, "HTMLString", HtmlString);
	_LoadHtmlFromString(HtmlString);
	return;
}
