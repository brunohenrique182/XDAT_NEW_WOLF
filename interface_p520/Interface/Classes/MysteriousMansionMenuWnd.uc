class MysteriousMansionMenuWnd extends UICommonAPI;

const DIALOG_LEAVE_MYSTERIOUSMANSION = 99001;

var bool bChecked2;
var bool bChecked3;
var bool bChecked4;
var bool bChecked5;

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
		OnRegisterEvent();
	}
	return;
}

function Load()
{
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(1710);
	RegisterEvent(1720);
	RegisterEvent(9320);
	RegisterEvent(9330);
	RegisterEvent(40);
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 9320:
			handleCuriousHouseEnter();
			break;
		case 9330:
			handleCuriousHouseLeave();
			break;
		case 1710:
			HandleDialogOK();
			break;
		case 1720:
			break;
		default:
			break;
	}
	return;
}

function handleCuriousHouseEnter()
{
	SetShow("MysteriousMansionMenuWnd");
	setHide("RadarMapWnd");
	setHide("Menu");
	bChecked2 = GetOptionBool("ScreenInfo", "GroupName");
	bChecked3 = GetOptionBool("ScreenInfo", "PledgeMemberName");
	bChecked4 = GetOptionBool("ScreenInfo", "PartyMemberName");
	bChecked5 = GetOptionBool("ScreenInfo", "OtherPCName");
	SetOptionBool("ScreenInfo", "GroupName", true);
	SetOptionBool("ScreenInfo", "PledgeMemberName", true);
	SetOptionBool("ScreenInfo", "PartyMemberName", true);
	SetOptionBool("ScreenInfo", "OtherPCName", true);
	return;
}

function handleCuriousHouseLeave()
{
	setHide("MysteriousMansionMenuWnd");
	SetShow("RadarMapWnd");
	SetShow("Menu");
	SetOptionBool("ScreenInfo", "GroupName", bChecked2);
	SetOptionBool("ScreenInfo", "PledgeMemberName", bChecked3);
	SetOptionBool("ScreenInfo", "PartyMemberName", bChecked4);
	SetOptionBool("ScreenInfo", "OtherPCName", bChecked5);
	return;
}

function SetShow(string WindowName)
{
	if(!Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow(WindowName))
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(WindowName);
	}
	return;
}

function setHide(string WindowName)
{
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow(WindowName))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow(WindowName);
	}
	return;
}

function HandleDialogOK()
{
	if(DialogIsMine())
	{
		if((DialogGetID() == 99001))
		{
			RequestLeaveCuriousHouse();
		}
	}
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnQuit":
			DialogSetID(99001);
			DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(3756));
			DialogMoveToCursor();
			break;
		default:
			break;
	}
	return;
}
