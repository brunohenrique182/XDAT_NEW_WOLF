class TutorialViewerWnd extends UICommonAPI;

var HtmlHandle m_hTutorialViewerWndHtmlTutorialViewer;

function OnRegisterEvent()
{
	RegisterEvent(2430);
	RegisterEvent(2440);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	m_hTutorialViewerWndHtmlTutorialViewer = GetHtmlHandle("TutorialViewerWnd.HtmlTutorialViewer");
	return;
}

function OnShow()
{
	PlayConsoleSound(IFST_WINDOW_OPEN);
	return;
}

function string getTitleString(string HtmlString)
{
	local int N;
	local string Str;

	N = InStr(HtmlString, "</title>");
	Str = Left(HtmlString, N);
	Str = Mid(Str, (InStr(Str, "<title>") + Len("<title>")), Len(Str));
	return Str;
}

function OnEvent(int Event_ID, string param)
{
	local string HtmlString;
	local int ViewerType;

	switch(Event_ID)
	{
		case 2430:
			ParseString(param, "HtmlString", HtmlString);
			ParseInt(param, "ViewerType", ViewerType);
			if((ViewerType == 1))
			{
				m_hTutorialViewerWndHtmlTutorialViewer.SetWindowTitle(GetSystemString(448));
				m_hTutorialViewerWndHtmlTutorialViewer.LoadHtmlFromString(HtmlString);
				ShowWindowWithFocus("TutorialViewerWnd");
			}
			break;
		case 2440:
			HideWindow("TutorialViewerWnd");
			break;
		default:
			break;
	}
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("TutorialViewerWnd").HideWindow();
	return;
}
