class BR_EventHtmlWndB extends UICommonAPI;

var WindowHandle Me;
var HtmlHandle HtmlViewer;

function OnRegisterEvent()
{
	RegisterEvent(9112);
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
		Me = GetHandle("BR_EventHtmlWndB");
		HtmlViewer = HtmlHandle(GetHandle("BR_EventHtmlWndB.HtmlViewer2"));
	}
	else
	{
		Me = GetWindowHandle("BR_EventHtmlWndB");
		HtmlViewer = GetHtmlHandle("BR_EventHtmlWndB.HtmlViewer2");
	}
	return;
}

function Load()
{
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 9112))
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
