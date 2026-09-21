class QuestTutorialWnd extends UICommonAPI;

var HtmlHandle m_hQuestTutorialViewerWndHtmlQuestTutorialViewer;
var int Index;

function OnRegisterEvent()
{
	RegisterEvent(2430);
	RegisterEvent(2440);
	RegisterEvent(2431);
	return;
}

function OnLoad()
{
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	m_hQuestTutorialViewerWndHtmlQuestTutorialViewer = GetHtmlHandle("QuestTutorialWnd.HtmlViewer");
	return;
}

function OnClickButton(string a_ButtonID)
{
	switch(a_ButtonID)
	{
		case "CloseBtn":
			HandleCloseBtn();
			break;
		default:
			break;
	}
	return;
}

function HandleCloseBtn()
{
	HideWindow("QuestTutorialWnd");
	return;
}

function OnEvent(int Event_ID, string param)
{
	local string HtmlFile;
	local int ViewerType;

	switch(Event_ID)
	{
		case 2431:
			ParseString(param, "HtmlFile", HtmlFile);
			ParseInt(param, "ViewerType", ViewerType);
			if((ViewerType == 2))
			{
				m_hQuestTutorialViewerWndHtmlQuestTutorialViewer.LoadHtml(HtmlFile);
				ShowWindowWithFocus("QuestTutorialWnd");
			}
			break;
		case 2440:
			HideWindow("QuestTutorialWnd");
			break;
		default:
			break;
	}
	return;
}

event bool OnKeyDown(WindowHandle a_WindowHandle, Interactions.EInputKey Key)
{
	if((int(Key) == 27))
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		GetWindowHandle("QuestTutorialWnd").HideWindow();
	}
	return false;
}
