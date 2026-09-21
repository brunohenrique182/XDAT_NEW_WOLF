class UIEditor_DocumentInfo extends UICommonAPI;

var WindowHandle Me;
var EditBoxHandle txtCommentInput;
var string m_xmlnsInput;
var string m_xsiInput;
var string m_schemaLocationInput;
var WindowHandle m_CurTopWnd;

function OnRegisterEvent()
{
	RegisterEvent(2920);
	RegisterEvent(2930);
	return;
}

function OnLoad()
{
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	InitHandle();
	InitControlItem();
	return;
}

function InitHandle()
{
	if((1 == 0))
	{
		Me = GetHandle("UIEditor_DocumentInfo");
		txtCommentInput = EditBoxHandle(GetHandle("UIEditor_DocumentInfo.txtCommentInput"));
	}
	else
	{
		Me = GetWindowHandle("UIEditor_DocumentInfo");
		txtCommentInput = GetEditBoxHandle("UIEditor_DocumentInfo.txtCommentInput");
	}
	return;
}

function InitControlItem()
{
	setWindowTitleByString("UIEditor - DocumentInfo");
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 2920))
	{
		HandleTrackerAttach(param);
	}
	else if((Event_ID == 2930))
	{
		HandleTrackerDetach();
	}
	return;
}

function OnCompleteEditBox(string strID)
{
	switch(strID)
	{
		case "txtCommentInput":
			UpdateDocumentInfo();
			break;
		default:
			break;
	}
	return;
}

function HandleTrackerAttach(string param)
{
	local WindowHandle TrackerWnd, topWnd;
	local string Comment, NameSpace, XSI, SchemaLocation;

	TrackerWnd = GetTrackerAttachedWindow();
	if((TrackerWnd == none))
	{
		return;
	}
	Clear();
	topWnd = TrackerWnd.GetTopFrameWnd();
	if((topWnd == none))
	{
		return;
	}
	if((topWnd == m_CurTopWnd))
	{
		return;
	}
	m_CurTopWnd = topWnd;
	topWnd.GetXMLDocumentInfo(Comment, NameSpace, XSI, SchemaLocation);
	txtCommentInput.AddString(Comment);
	m_xmlnsInput = NameSpace;
	m_xsiInput = XSI;
	m_schemaLocationInput = SchemaLocation;
	return;
}

function UpdateDocumentInfo()
{
	m_CurTopWnd.SetXMLDocumentInfo(txtCommentInput.GetString(), m_xmlnsInput, m_xsiInput, m_schemaLocationInput);
	return;
}

function HandleTrackerDetach()
{
	Clear();
	return;
}

function Clear()
{
	m_CurTopWnd = none;
	txtCommentInput.Clear();
	m_xmlnsInput = "";
	m_xsiInput = "";
	m_schemaLocationInput = "";
	return;
}
