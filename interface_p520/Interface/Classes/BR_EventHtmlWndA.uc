class BR_EventHtmlWndA extends UICommonAPI;

var WindowHandle Me;
var HtmlHandle HtmlViewer;

function OnRegisterEvent()
{
	RegisterEvent(9111);
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
		Me = GetHandle("BR_EventHtmlWndA");
		HtmlViewer = HtmlHandle(GetHandle("BR_EventHtmlWndA.HtmlViewer1"));
	}
	else
	{
		Me = GetWindowHandle("BR_EventHtmlWndA");
		HtmlViewer = GetHtmlHandle("BR_EventHtmlWndA.HtmlViewer1");
	}
	return;
}

function Load()
{
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 9111))
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
