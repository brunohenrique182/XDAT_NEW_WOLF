class ActionWnd extends UICommonAPI;

var bool m_bShow;
var WindowHandle Me;
var WindowHandle tabContainerWnd;
var WindowHandle actionContainerWnd;

function InitControls()
{
	local string ownerFullPath;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	tabContainerWnd = GetWindowHandle((ownerFullPath $ ".Tab_Wnd"));
	actionContainerWnd = GetWindowHandle((ownerFullPath $ ".ActionItem_Wnd"));
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(1311);
	RegisterEvent(1300);
	RegisterEvent(1310);
	RegisterEvent(1900);
	RegisterEvent(8000);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	m_bShow = false;
	InitControls();
	HideScrollBar();
	return;
}

function OnShow()
{
	Class'NWindow.ActionAPI'.static.RequestActionList();
	m_bShow = true;
	if((IsUseRenewalSkillWnd() == true))
	{
		Me.SetWindowTitle(GetSystemString(127));
		tabContainerWnd.HideWindow();
		actionContainerWnd.SetAnchor("ActionWnd", "TopLeft", "TopLeft", 0, 46);
		Me.SetWindowSize(300, (584 - 140));
	}
	else
	{
		Me.SetWindowTitle(GetSystemString(14230));
		tabContainerWnd.ShowWindow();
		actionContainerWnd.SetAnchor("ActionWnd", "TopLeft", "TopLeft", 0, 85);
		GetWindowHandle("MagicSkillWnd").HideWindow();
		getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "MagicSkillWnd");
		GetWindowHandle("ActionWnd").SetFocus();
	}
	return;
}

function OnHide()
{
	m_bShow = false;
	if((IsUseRenewalSkillWnd() == false))
	{
		getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "MagicSkillWnd");
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 1300))
	{
		HandleActionListStart();
	}
	else if((Event_ID == 1310))
	{
		HandleActionList(param);
	}
	else if((Event_ID == 1900))
	{
		HandleLanguageChanged();
	}
	else if((Event_ID == 1311))
	{
		HandleActionListNew();
	}
	else if((Event_ID == 8000))
	{
		checkClassicForm();
	}
	return;
}

function checkClassicForm()
{
	local int containerPosY;
	local WindowHandle Me;
	local TextBoxHandle txtMark;
	local TextureHandle SlotMark_01, SlotMark_02;
	local ItemWindowHandle ActionMarkItem;
	local TextBoxHandle txtSocial;
	local TextureHandle SlotSocial_01, SlotSocial_02;
	local ItemWindowHandle ActionSocialItem;

	containerPosY = 85;
	txtSocial = GetTextBoxHandle((actionContainerWnd.m_WindowNameWithFullPath $ ".txtSocial"));
	SlotSocial_01 = GetTextureHandle((actionContainerWnd.m_WindowNameWithFullPath $ ".SlotSocial_01"));
	SlotSocial_02 = GetTextureHandle((actionContainerWnd.m_WindowNameWithFullPath $ ".SlotSocial_02"));
	ActionSocialItem = GetItemWindowHandle((actionContainerWnd.m_WindowNameWithFullPath $ ".ActionSocialItem"));
	txtMark = GetTextBoxHandle((actionContainerWnd.m_WindowNameWithFullPath $ ".txtMark"));
	SlotMark_01 = GetTextureHandle((actionContainerWnd.m_WindowNameWithFullPath $ ".SlotMark_01"));
	SlotMark_02 = GetTextureHandle((actionContainerWnd.m_WindowNameWithFullPath $ ".SlotMark_02"));
	ActionMarkItem = GetItemWindowHandle((actionContainerWnd.m_WindowNameWithFullPath $ ".ActionMarkItem"));
	if(IsAdenServer())
	{
		SlotMark_01.HideWindow();
		SlotMark_02.HideWindow();
		txtMark.HideWindow();
		ActionMarkItem.HideWindow();
		txtSocial.SetAnchor(actionContainerWnd.m_WindowNameWithFullPath, "TopLeft", "TopLeft", 15, (353 - containerPosY));
		SlotSocial_01.SetAnchor(actionContainerWnd.m_WindowNameWithFullPath, "TopLeft", "TopLeft", 6, (371 - containerPosY));
		SlotSocial_02.SetAnchor(actionContainerWnd.m_WindowNameWithFullPath, "TopLeft", "TopLeft", 258, (371 - containerPosY));
		ActionSocialItem.SetAnchor(actionContainerWnd.m_WindowNameWithFullPath, "TopLeft", "TopLeft", 7, (371 - containerPosY));
		Me.SetWindowSize(300, 575);
	}
	else
	{
		SlotMark_01.ShowWindow();
		SlotMark_02.ShowWindow();
		txtMark.ShowWindow();
		ActionMarkItem.ShowWindow();
		txtSocial.SetAnchor(actionContainerWnd.m_WindowNameWithFullPath, "TopLeft", "TopLeft", 15, (445 - containerPosY));
		SlotSocial_01.SetAnchor(actionContainerWnd.m_WindowNameWithFullPath, "TopLeft", "TopLeft", 6, (463 - containerPosY));
		SlotSocial_02.SetAnchor(actionContainerWnd.m_WindowNameWithFullPath, "TopLeft", "TopLeft", 258, (463 - containerPosY));
		ActionSocialItem.SetAnchor(actionContainerWnd.m_WindowNameWithFullPath, "TopLeft", "TopLeft", 7, (463 - containerPosY));
		Me.SetWindowSize(300, 575);
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "WindowHelp_BTN":
			ExecuteEvent(1210, "6");
			break;
		case "SkillTap_Btn":
			GetWindowHandle("MagicSkillWnd").ShowWindow();
			break;
		default:
			break;
	}
	return;
}

function OnClickItem(string strID, int Index)
{
	local ItemInfo infItem;

	if(((strID == "ActionBasicItem") && (Index > -1)))
	{
		if(!Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem((actionContainerWnd.m_WindowNameWithFullPath $ ".ActionBasicItem"), Index, infItem))
		{
			return;
		}
		Class'NWindow.UIAPI_ITEMWINDOW'.static.SetItem((actionContainerWnd.m_WindowNameWithFullPath $ ".ActionBasicItem"), Index, infItem);
	}
	else if(((strID == "ActionPartyItem") && (Index > -1)))
	{
		if(!Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem((actionContainerWnd.m_WindowNameWithFullPath $ ".ActionPartyItem"), Index, infItem))
		{
			return;
		}
	}
	else if(((strID == "ActionMarkItem") && (Index > -1)))
	{
		if(!Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem((actionContainerWnd.m_WindowNameWithFullPath $ ".ActionMarkItem"), Index, infItem))
		{
			return;
		}
	}
	else if(((strID == "ActionSocialItem") && (Index > -1)))
	{
		if(!Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem((actionContainerWnd.m_WindowNameWithFullPath $ ".ActionSocialItem"), Index, infItem))
		{
			return;
		}
	}
	DoAction(infItem.Id);
	return;
}

function HideScrollBar()
{
	Class'NWindow.UIAPI_ITEMWINDOW'.static.ShowScrollBar((actionContainerWnd.m_WindowNameWithFullPath $ ".ActionBasicItem"), false);
	Class'NWindow.UIAPI_ITEMWINDOW'.static.ShowScrollBar((actionContainerWnd.m_WindowNameWithFullPath $ ".ActionPartyItem"), false);
	Class'NWindow.UIAPI_ITEMWINDOW'.static.ShowScrollBar((actionContainerWnd.m_WindowNameWithFullPath $ ".ActionMarkItem"), false);
	Class'NWindow.UIAPI_ITEMWINDOW'.static.ShowScrollBar((actionContainerWnd.m_WindowNameWithFullPath $ ".ActionSocialItem"), false);
	return;
}

function HandleLanguageChanged()
{
	Class'NWindow.ActionAPI'.static.RequestActionList();
	return;
}

function HandleActionListStart()
{
	Clear();
	return;
}

function Clear()
{
	Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear((actionContainerWnd.m_WindowNameWithFullPath $ ".ActionBasicItem"));
	Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear((actionContainerWnd.m_WindowNameWithFullPath $ ".ActionPartyItem"));
	Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear((actionContainerWnd.m_WindowNameWithFullPath $ ".ActionMarkItem"));
	Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear((actionContainerWnd.m_WindowNameWithFullPath $ ".ActionSocialItem"));
	return;
}

function HandleActionList(string param)
{
	local string wndname;
	local int tmp;
	local UIEventManager.EActionCategory Type;
	local string strActionName, strIconName, strIconNameEx1, strDescription, strCommand;
	local ItemInfo infItem;

	ParseItemID(param, infItem.Id);
	ParseInt(param, "Type", tmp);
	ParseString(param, "Name", strActionName);
	ParseString(param, "IconName", strIconName);
	ParseString(param, "IconNameEx1", strIconNameEx1);
	ParseString(param, "Description", strDescription);
	ParseString(param, "Command", strCommand);
	infItem.Name = strActionName;
	infItem.IconName = strIconName;
	infItem.IconNameEx1 = strIconNameEx1;
	infItem.Description = strDescription;
	infItem.ShortcutType = 3;
	infItem.MacroCommand = strCommand;
	Type = EActionCategory(tmp);
	if((int(Type) == 1))
	{
		wndname = "ActionBasicItem";
	}
	else if((int(Type) == 2))
	{
		wndname = "ActionPartyItem";
	}
	else if((int(Type) == 3))
	{
		wndname = "ActionMarkItem";
	}
	else if((int(Type) == 4))
	{
		wndname = "ActionSocialItem";
	}
	else
	{
		return;
	}
	Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem(((actionContainerWnd.m_WindowNameWithFullPath $ ".") $ wndname), infItem);
	return;
}

function HandleActionListNew()
{
	Class'NWindow.ActionAPI'.static.RequestActionList();
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("ActionWnd").HideWindow();
	return;
}
