class MysteriousMansionControlWnd extends UIScript;

var WindowHandle Me;
var ButtonHandle btnRecord;
var ButtonHandle btnGuide;
var ButtonHandle btnOtherGame;
var ButtonHandle btnStop;
var WindowHandle OlympiadGuideWnd;

function OnLoad()
{
	Initialize();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("MysteriousMansionControlWnd");
	btnRecord = GetButtonHandle("MysteriousMansionControlWnd.btnRecord");
	btnGuide = GetButtonHandle("MysteriousMansionControlWnd.btnGuide");
	btnOtherGame = GetButtonHandle("MysteriousMansionControlWnd.btnOtherGame");
	btnStop = GetButtonHandle("MysteriousMansionControlWnd.btnStop");
	OlympiadGuideWnd = GetWindowHandle("OlympiadGuideWnd");
	return;
}

function OnShow()
{
	local OlympiadGuideWnd Script;

	Script = OlympiadGuideWnd(GetScript("OlympiadGuideWnd"));
	Script.MysteriousMansionShow();
	return;
}

function OnHide()
{
	local OlympiadGuideWnd Script;

	Script = OlympiadGuideWnd(GetScript("OlympiadGuideWnd"));
	Script.MysteriousMansionHide();
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(5020);
	RegisterEvent(5021);
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 5020:
			btnRecord.SetButtonName(2301);
			break;
		case 5021:
			btnRecord.SetButtonName(2300);
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnStop":
			RequestLeaveObservingCuriousHouse();
			break;
		case "btnOtherGame":
			RequestObservingListCuriousHouse();
			break;
		case "btnRecord":
			ToggleReplayRec();
			break;
		case "btnGuide":
			showGuidWnd();
			break;
		default:
			break;
	}
	return;
}

function showGuidWnd()
{
	local OlympiadGuideWnd Script;

	Script = OlympiadGuideWnd(GetScript("OlympiadGuideWnd"));
	Script.OpenCloseGuide();
	return;
}
