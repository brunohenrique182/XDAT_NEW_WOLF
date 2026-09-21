class CleftCurTriggerWnd extends UIScript;

var WindowHandle Me;
var ButtonHandle CleftCurTriggerBtn;
var WindowHandle CleftCurWnd;

function OnRegisterEvent()
{
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
		Initialize();
	}
	else
	{
		InitializeCOD();
	}
	Me.HideWindow();
	return;
}

function Initialize()
{
	Me = GetHandle("CleftCurTriggerWnd");
	CleftCurTriggerBtn = ButtonHandle(GetHandle("CleftCurTriggerWnd.CleftCurTriggerBtn"));
	CleftCurWnd = GetHandle("CleftCurWnd");
	return;
}

function InitializeCOD()
{
	Me = GetWindowHandle("CleftCurTriggerWnd");
	CleftCurTriggerBtn = GetButtonHandle("CleftCurTriggerWnd.CleftCurTriggerBtn");
	CleftCurWnd = GetWindowHandle("CleftCurWnd");
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 3740:
			Me.ShowWindow();
			break;
		case 3750:
			Me.ShowWindow();
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "CleftCurTriggerBtn":
			CleftCurWnd.ShowWindow();
			break;
		default:
			break;
	}
	return;
}
