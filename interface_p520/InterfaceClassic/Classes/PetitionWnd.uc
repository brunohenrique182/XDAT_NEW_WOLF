class PetitionWnd extends UICommonAPI;

var ChatWindowHandle petitionchat;

function OnRegisterEvent()
{
	RegisterEvent(1920);
	RegisterEvent(1930);
	RegisterEvent(1940);
	return;
}

function OnLoad()
{
	local ListBoxHandle temp;

	if((1 == 0))
	{
		OnRegisterEvent();
	}
	SetFeedBackEnable(false);
	petitionchat = GetChatWindowHandle("PetitionWnd.PetitionChatWindow");
	petitionchat.SetScrollBarPosition(368, 0, 0);
	temp = GetListBoxHandle("PetitionWnd.PetitionChatWindow");
	temp.SetDrawOffset(3, 3);
	temp.SetMaxRow(200);
	return;
}

function OnHide()
{
	SetFeedBackEnable(false);
	return;
}

function SetFeedBackEnable(bool a_IsEnabled)
{
	if(a_IsEnabled)
	{
		Class'NWindow.UIAPI_BUTTON'.static.EnableWindow("PetitionWnd.FeedBackButton");
	}
	else
	{
		Class'NWindow.UIAPI_BUTTON'.static.DisableWindow("PetitionWnd.FeedBackButton");
	}
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 1920:
			HandleShowPetitionWnd();
			break;
		case 1930:
			HandlePetitionChatMessage(a_Param);
			break;
		case 1940:
			HandleEnablePetitionFeedback(a_Param);
			break;
		default:
			break;
	}
	return;
}

function OnCompleteEditBox(string strID)
{
	local string Message;

	switch(strID)
	{
		case "PetitionChatEditBox":
			Message = Class'NWindow.UIAPI_EDITBOX'.static.GetString("PetitionWnd.PetitionChatEditBox");
			ProcessPetitionChatMessage(Message);
			break;
		default:
			break;
	}
	Class'NWindow.UIAPI_EDITBOX'.static.Clear("PetitionWnd.PetitionChatEditBox");
	return;
}

function HandleShowPetitionWnd()
{
	if(m_hOwnerWnd.IsMinimizedWindow())
	{
		m_hOwnerWnd.NotifyAlarm();
	}
	else
	{
		ShowWindow("PetitionWnd");
		m_hOwnerWnd.SetFocus();
	}
	return;
}

function HandlePetitionChatMessage(string a_Param)
{
	local string chatMessage;
	local Color ChatColor;
	local int tmpType;

	if((ParseString(a_Param, "Message", chatMessage) && ParseInt(a_Param, "SayType", tmpType)))
	{
		Debug(chatMessage);
		ChatColor = GetChatColorByType(tmpType);
		Debug(string(petitionchat));
		petitionchat.AddString(chatMessage, ChatColor);
	}
	return;
}

function HandleEnablePetitionFeedback(string a_Param)
{
	local int Enable;

	if(ParseInt(a_Param, "Enable", Enable))
	{
		if((1 == Enable))
		{
			SetFeedBackEnable(true);
		}
		else
		{
			SetFeedBackEnable(false);
		}
	}
	return;
}

function OnClickButton(string a_ControlID)
{
	switch(a_ControlID)
	{
		case "FeedBackButton":
			OnClickFeedBackButton();
			break;
		case "CancelButton":
			OnClickCancelButton();
			break;
		default:
			break;
	}
	return;
}

function OnClickFeedBackButton()
{
	local UIScript.PetitionMethod useNewPetition;

	useNewPetition = PetitionMethod(GetPetitionMethod());
	if((int(useNewPetition) == 1))
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("NewPetitionFeedBackWnd");
	}
	else
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("PetitionFeedBackWnd");
	}
	return;
}

function OnClickCancelButton()
{
	SetFeedBackEnable(false);
	Class'NWindow.PetitionAPI'.static.RequestPetitionCancel();
	return;
}

function Clear()
{
	local ChatWindowHandle temp;

	temp = GetChatWindowHandle("PetitionWnd.PetitionChatWindow");
	temp.Clear();
	return;
}
