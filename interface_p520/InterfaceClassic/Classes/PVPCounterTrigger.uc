class PVPCounterTrigger extends UIScript;

var WindowHandle Me;
var ButtonHandle Btn_PVPWnd;
var WindowHandle PVPDetailedWnd;

function OnRegisterEvent()
{
	return;
}

function OnLoad()
{
	InitializeCOD();
	Me.HideWindow();
	return;
}

function InitializeCOD()
{
	Me = GetWindowHandle("PVPCounterTrigger");
	Btn_PVPWnd = GetButtonHandle("PVPCounterTrigger.Btn_PVPWnd");
	PVPDetailedWnd = GetWindowHandle("PVPDetailedWnd");
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 3370:
			HandlePVPMatchRecord(a_Param);
			break;
		default:
			break;
	}
	return;
}

function HandlePVPMatchRecord(string param)
{
	local int CurrentState;

	ParseInt(param, "CurrentState", CurrentState);
	switch(CurrentState)
	{
		case 0:
			Me.ShowWindow();
			break;
		case 2:
			Me.HideWindow();
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
		case "Btn_PVPWnd":
			PVPDetailedWnd.ShowWindow();
			RequestPVPMatchRecord();
			break;
		default:
			break;
	}
	return;
}
