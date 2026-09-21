class UIEditor_PropertyController extends UICommonAPI;

var WindowHandle Me;
var WindowHandle m_CurPropertyWnd;
var PropertyControllerHandle ctlProperty;
var WindowHandle areaScroll;

function OnRegisterEvent()
{
	RegisterEvent(2920);
	RegisterEvent(2930);
	RegisterEvent(2950);
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
		Me = GetHandle("UIEditor_PropertyController");
		ctlProperty = PropertyControllerHandle(GetHandle("UIEditor_PropertyController.ctlProperty"));
		areaScroll = GetHandle("UIEditor_PropertyController.areaScroll");
	}
	else
	{
		Me = GetWindowHandle("UIEditor_PropertyController");
		ctlProperty = GetPropertyControllerHandle("UIEditor_PropertyController.ctlProperty");
		areaScroll = GetWindowHandle("UIEditor_PropertyController.areaScroll");
	}
	return;
}

function InitControlItem()
{
	setWindowTitleByString("UIEditor - PropertyManager");
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
	else if((Event_ID == 2950))
	{
		HandleEditorUpdateProperty(param);
	}
	return;
}

function OnPropertyControllerResize(PropertyControllerHandle a_PropertyHandle, int a_Height)
{
	if((areaScroll != none))
	{
		areaScroll.SetScrollHeight(a_Height);
	}
	return;
}

function Clear()
{
	m_CurPropertyWnd = none;
	ctlProperty.Clear();
	areaScroll.SetScrollPosition(0);
	return;
}

function HandleTrackerAttach(string param)
{
	local WindowHandle TrackerWnd;

	TrackerWnd = GetTrackerAttachedWindow();
	if((TrackerWnd == none))
	{
		return;
	}
	if((TrackerWnd != m_CurPropertyWnd))
	{
		m_CurPropertyWnd = TrackerWnd;
		ctlProperty.SetProperty(TrackerWnd.GetControlType(), m_CurPropertyWnd);
		areaScroll.SetScrollHeight(ctlProperty.GetPropertyHeight());
		areaScroll.SetScrollPosition(0);
	}
	return;
}

function HandleTrackerDetach()
{
	Clear();
	return;
}

function HandleEditorUpdateProperty(string param)
{
	local string ControlName;
	local int CloneID;
	local string GroupName;
	local WindowHandle hWnd;

	ParseString(param, "ControlName", ControlName);
	if((Len(ControlName) < 1))
	{
		return;
	}
	ParseInt(param, "CloneID", CloneID);
	hWnd = FindHandle(ControlName, none, CloneID);
	if((hWnd != m_CurPropertyWnd))
	{
		return;
	}
	ParseString(param, "GroupName", GroupName);
	ctlProperty.UpdatePropertyGroup(GroupName);
	return;
}
