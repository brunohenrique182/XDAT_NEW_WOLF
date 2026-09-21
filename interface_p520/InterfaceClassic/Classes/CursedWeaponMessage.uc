class CursedWeaponMessage extends UICommonAPI;

const TimeID = 102222;
const DELAY_NUM = 10000;

var WindowHandle Me;
var TextBoxHandle Message_Txt;

function OnRegisterEvent()
{
	RegisterEvent(11120);
	RegisterEvent(40);
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
	Me = GetWindowHandle("CursedWeaponMessage");
	Message_Txt = GetTextBoxHandle("CursedWeaponMessage.Message_Txt");
	return;
}

function Load()
{
	return;
}

function OnTimer(int nTimeID)
{
	if((102222 == nTimeID))
	{
		Me.KillTimer(102222);
		Me.HideWindow();
	}
	return;
}

function OnShow()
{
	Me.KillTimer(102222);
	Me.SetTimer(102222, 10000);
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 11120:
			Me.ShowWindow();
			break;
		case 40:
			Me.KillTimer(102222);
			Me.HideWindow();
			break;
		default:
			break;
	}
	return;
}
