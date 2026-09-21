class SelectDeliverWnd extends UICommonAPI;

function OnRegisterEvent()
{
	RegisterEvent(2140);
	RegisterEvent(2150);
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
	switch(Event_ID)
	{
		case 2140:
			Class'NWindow.UIAPI_COMBOBOX'.static.Clear("SelectDeliverWnd.SelectDeliverCombo");
			ShowWindow("SelectDeliverWnd");
			Class'NWindow.UIAPI_WINDOW'.static.SetFocus("SelectDeliverWnd");
			break;
		case 2150:
			HandleAddName(param);
			break;
		default:
			break;
	}
	return;
}

function HandleAddName(string param)
{
	local string Name;
	local int Id;

	ParseString(param, "name", Name);
	ParseInt(param, "id", Id);
	Class'NWindow.UIAPI_COMBOBOX'.static.AddStringWithReserved("SelectDeliverWnd.SelectDeliverCombo", Name, Id);
	return;
}

function OnClickButton(string ControlName)
{
	if((ControlName == "OKButton"))
	{
		HandleOKButtonClick();
	}
	else if((ControlName == "CancelButton"))
	{
		HideWindow("SelectDeliverWnd");
	}
	return;
}

function HandleOKButtonClick()
{
	local int Selected, reservedID;

	Selected = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum("SelectDeliverWnd.SelectDeliverCombo");
	if((Selected >= 0))
	{
		reservedID = Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved("SelectDeliverWnd.SelectDeliverCombo", Selected);
		RequestPackageSendableItemList(reservedID);
	}
	HideWindow("SelectDeliverWnd");
	return;
}
