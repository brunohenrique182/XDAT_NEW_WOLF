class OlympiadControlWnd extends UIScript;

var WindowHandle Me;
var ButtonHandle btnRecord;
var ButtonHandle btnGuide;
var ButtonHandle btnOtherGame;
var ButtonHandle btnStop;
var WindowHandle OlympiadGuideWnd;

function OnLoad()
{
	Initialize();
	Load();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("OlympiadControlWnd");
	btnRecord = GetButtonHandle("OlympiadControlWnd.btnRecord");
	btnGuide = GetButtonHandle("OlympiadControlWnd.btnGuide");
	btnOtherGame = GetButtonHandle("OlympiadControlWnd.btnOtherGame");
	btnStop = GetButtonHandle("OlympiadControlWnd.btnStop");
	OlympiadGuideWnd = GetWindowHandle("OlympiadGuideWnd");
	return;
}

function Load()
{
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
	local OlympiadGuideWnd Script;

	switch(strID)
	{
		case "btnStop":
			Class'NWindow.OlympiadAPI'.static.RequestOlympiadObserverEnd();
			break;
		case "btnOtherGame":
			Class'NWindow.OlympiadAPI'.static.RequestOlympiadMatchList();
			break;
		case "btnRecord":
			ToggleReplayRec();
			break;
		case "btnGuide":
			Script = OlympiadGuideWnd(GetScript("OlympiadGuideWnd"));
			Script.OpenCloseGuide();
			break;
		default:
			break;
	}
	return;
}
