class BirthdayAlarmWnd extends UICommonAPI;

var WindowHandle Me;
var TextureHandle BirthDayItem;
var TextBoxHandle itemAlarmTxt;
var ButtonHandle btnOk;

function OnRegisterEvent()
{
	RegisterEvent(3560);
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
	return;
}

function OnShow()
{
	return;
}

function Initialize()
{
	Me = GetHandle("BirthdayAlarmWnd");
	BirthDayItem = TextureHandle(GetHandle("BirthDayItem"));
	itemAlarmTxt = TextBoxHandle(GetHandle("itemAlarmTxt"));
	btnOk = ButtonHandle(GetHandle("btnOK"));
	return;
}

function InitializeCOD()
{
	Me = GetWindowHandle("BirthdayAlarmWnd");
	BirthDayItem = GetTextureHandle("BirthdayAlarmWnd.BirthDayItem");
	itemAlarmTxt = GetTextBoxHandle("BirthdayAlarmWnd.itemAlarmTxt");
	btnOk = GetButtonHandle("BirthdayAlarmWnd.btnOK");
	return;
}

function Load()
{
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 3890:
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
		case "btnOK":
			Me.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function OnExitState(name a_CurrentStateName)
{
	Me.HideWindow();
	return;
}
