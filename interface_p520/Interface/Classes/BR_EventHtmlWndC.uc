class BR_EventHtmlWndC extends UICommonAPI;

var WindowHandle Me;
var HtmlHandle HtmlViewer;

function OnRegisterEvent()
{
	RegisterEvent(9113);
	return;
}

function OnLoad()
{
	Initialize();
	Load();
	return;
}

function Initialize()
{
	if((1 == 0))
	{
		Me = GetHandle("BR_EventHtmlWndC");
		HtmlViewer = HtmlHandle(GetHandle("BR_EventHtmlWndC.HtmlViewer3"));
	}
	else
	{
		Me = GetWindowHandle("BR_EventHtmlWndC");
		HtmlViewer = GetHtmlHandle("BR_EventHtmlWndC.HtmlViewer3");
	}
	return;
}

function Load()
{
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 9113))
	{
		ShowEventHtml(param);
	}
	return;
}

function ShowEventHtml(string param)
{
	local string strPath, strTitle;

	ParseString(param, "FilePath", strPath);
	ParseString(param, "Title", strTitle);
	if((Len(strPath) > 0))
	{
		HtmlViewer.LoadHtml(strPath);
	}
	setWindowTitleByString(strTitle);
	return;
}
