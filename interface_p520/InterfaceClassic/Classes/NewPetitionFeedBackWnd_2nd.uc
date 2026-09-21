class NewPetitionFeedBackWnd_2nd extends UICommonAPI;

const MAX_FEEDBACK_STRING_LENGTH = 512;

var MultiEditBoxHandle m_hFeedbackMsgBox;
var int m_selectedRadioButton;
var WindowHandle Me;

function OnRegisterEvent()
{
	return;
}

function OnLoad()
{
	OnRegisterEvent();
	m_hFeedbackMsgBox = GetMultiEditBoxHandle("NewPetitionFeedBackWnd_2nd.MultiEdit");
	m_selectedRadioButton = 0;
	Me = GetWindowHandle("NewPetitionFeedBackWnd_2nd");
	return;
}

function OnShow()
{
	Me.ShowWindow();
	Me.SetFocus();
	return;
}

function OnHide()
{
	Clear();
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
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

function Clear()
{
	m_hFeedbackMsgBox.SetString("");
	return;
}

function OnClickOKButton()
{
	local string SelectedRadioButtonName, SelectedRadioButtonContents, FeedbackMessage;

	SelectedRadioButtonName = Class'NWindow.UIAPI_WINDOW'.static.GetSelectedRadioButtonName("NewPetitionFeedBackWnd_2nd", 1);
	switch(SelectedRadioButtonName)
	{
		case "Unkind":
			SelectedRadioButtonContents = GetSystemString(2025);
			break;
		case "Inaccurate":
			SelectedRadioButtonContents = GetSystemString(2026);
			break;
		case "LateAnswer":
			SelectedRadioButtonContents = GetSystemString(2027);
			break;
		default:
			break;
	}
	FeedbackMessage = Class'NWindow.UIAPI_MULTIEDITBOX'.static.GetString("NewPetitionFeedBackWnd_2nd.MultiEdit");
	FeedbackMessage = (SelectedRadioButtonContents $ FeedbackMessage);
	if((Len(FeedbackMessage) > 512))
	{
		AddSystemMessageString(FeedbackMessage);
	}
	Class'NWindow.PetitionAPI'.static.RequestPetitionFeedBack(m_selectedRadioButton, FeedbackMessage);
	m_hFeedbackMsgBox.SetString("");
	HideWindow("NewPetitionFeedBackWnd_2nd");
	return;
}

function SetSelectedRadioButton(int Select)
{
	m_selectedRadioButton = Select;
	return;
}
