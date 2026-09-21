class NewPetitionFeedBackResultWnd extends UICommonAPI;

var WindowHandle Me;
var TextBoxHandle m_hResultTextBoxHandle;

event OnRegisterEvent()
{
	return;
}

event OnLoad()
{
	Me = GetWindowHandle("NewPetitionFeedBackResultWnd");
	m_hResultTextBoxHandle = GetTextBoxHandle("NewPetitionFeedBackResultWnd.PetitionFeedBackResultText");
	Me.ShowWindow();
	Me.SetFocus();
	m_hResultTextBoxHandle.SetText(GetSystemMessage(3004));
	return;
}

event OnShow()
{
	Me.SetFocus();
	return;
}

event OnEvent(int a_EventID, string a_Param)
{
	return;
}

event OnClickButton(string a_ControlID)
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
	return;
}

event OnClickOKButton()
{
	Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("NewPetitionFeedBackWnd_2nd");
	HideWindow("NewPetitionFeedBackResultWnd");
	return;
}
