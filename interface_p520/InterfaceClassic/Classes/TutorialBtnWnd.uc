class TutorialBtnWnd extends UICommonAPI;

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
	return;
}

function OnEvent(int Event_ID, string param)
{
	local int iEffectNumber;

	ParseInt(param, "QuestionID", iEffectNumber);
	switch(Event_ID)
	{
		case 1510:
			ShowWindowWithFocus("TutorialBtnWnd");
			Class'NWindow.UIAPI_EFFECTBUTTON'.static.BeginEffect("TutorialBtnWnd.btnTutorial", iEffectNumber);
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
		case "btnTutorial":
			HideWindow("TutorialBtnWnd");
			break;
		default:
			break;
	}
	return;
}
