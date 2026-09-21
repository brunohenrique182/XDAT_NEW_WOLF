class PetitionFeedBackWnd extends UICommonAPI;

const MAX_FEEDBACK_STRING_LENGTH = 512;
const FEEBACKRATE_VeryGood = 0;
const FEEBACKRATE_Good = 1;
const FEEBACKRATE_Normal = 2;
const FEEBACKRATE_Bad = 3;
const FEEBACKRATE_VeryBad = 4;

function OnLoad()
{
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	return;
}

function OnHide()
{
	ExecuteEvent(1940, "Enable=0");
	return;
}

function OnClickButton(string a_ControlID)
{
	switch(a_ControlID)
	{
		case "OKButton":
			OnClickOKButton();
			break;
		default:
			break;
	}
	return;
}

function OnClickOKButton()
{
	local string SelectedRadioButtonName;
	local int FeedbackRate;
	local string FeedbackMessage;

	SelectedRadioButtonName = Class'NWindow.UIAPI_WINDOW'.static.GetSelectedRadioButtonName("PetitionFeedBackWnd", 1);
	switch(SelectedRadioButtonName)
	{
		case "VeryGood":
			FeedbackRate = 0;
			break;
		case "Good":
			FeedbackRate = 1;
			break;
		case "Normal":
			FeedbackRate = 2;
			break;
		case "Bad":
			FeedbackRate = 3;
			break;
		case "VeryBad":
			FeedbackRate = 4;
			break;
		default:
			break;
	}
	FeedbackMessage = Class'NWindow.UIAPI_MULTIEDITBOX'.static.GetString("PetitionFeedBackWnd.MultiEdit");
	if((Len(FeedbackMessage) > 512))
	{
		AddSystemMessageString(FeedbackMessage);
	}
	Class'NWindow.PetitionAPI'.static.RequestPetitionFeedBack(FeedbackRate, FeedbackMessage);
	HideWindow("PetitionFeedBackWnd");
	return;
}
