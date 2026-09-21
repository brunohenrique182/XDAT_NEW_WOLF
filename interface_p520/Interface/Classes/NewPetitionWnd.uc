class NewPetitionWnd extends UICommonAPI;

var WindowHandle Me;
var TextBoxHandle m_hTitleEditBox;
var MultiEditBoxHandle m_hContentsEditBox;
var int m_categoryId;

function OnRegisterEvent()
{
	return;
}

function OnLoad()
{
	OnRegisterEvent();
	Me = GetWindowHandle("NewPetitionWnd");
	m_hTitleEditBox = GetTextBoxHandle("NewPetitionWnd.PetitionGuideText");
	m_hContentsEditBox = GetMultiEditBoxHandle("NewPetitionWnd.PetitionMultiEdit");
	Me.ShowWindow();
	Me.SetFocus();
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
		case "FeedBackButton":
			OnClickOKButton();
			break;
		case "CancelButton":
			OnClickCancelButton();
			break;
		default:
			break;
	}
	return;
}

function Clear()
{
	m_hContentsEditBox.SetString("");
	return;
}

function OnClickOKButton()
{
	local int ContentsMessageLen;
	local string ContentsMessage, param;
	local PetitionWnd PetitionWndScript;

	ContentsMessageLen = 0;
	ContentsMessage = m_hContentsEditBox.GetString();
	ContentsMessageLen = Len(ContentsMessage);
	if((15 > ContentsMessageLen))
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, GetSystemMessage(2991));
	}
	else if((800 <= ContentsMessageLen))
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, GetSystemMessage(971));
	}
	else
	{
		Class'NWindow.PetitionAPI'.static.RequestPetition(ContentsMessage, m_categoryId);
		Clear();
		HideWindow("NewPetitionWnd");
		PetitionWndScript = PetitionWnd(GetScript("PetitionWnd"));
		if((none != PetitionWndScript))
		{
			PetitionWndScript.Clear();
			ParamAdd(param, "Message", ((GetSystemString(708) $ " : ") $ ContentsMessage));
			ParamAdd(param, "ColorR", "220");
			ParamAdd(param, "ColorG", "220");
			ParamAdd(param, "ColorB", "220");
			ParamAdd(param, "ColorA", "255");
			PetitionWndScript.HandlePetitionChatMessage(param);
		}
	}
	return;
}

function OnClickCancelButton()
{
	Clear();
	Me.HideWindow();
	return;
}

function SetCategoryId(int categoryId)
{
	m_categoryId = categoryId;
	return;
}

event bool OnKeyDown(WindowHandle a_WindowHandle, Interactions.EInputKey Key)
{
	if((int(Key) == 27))
	{
		OnClickCancelButton();
	}
	return false;
}
