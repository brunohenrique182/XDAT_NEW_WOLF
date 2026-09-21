class Menu extends UICommonAPI;

const MAX_BUTTON_NUM = 12;
const UTXPATH = "L2UI_NewTex.MenuWnd.icon_Menu_";

var WindowHandle Me;
var array<int> menuListToolip;
var array<UIConstants.MenuButtonSlotStruct> menuList;
var MenuEntireWnd MenuEntireWndScript;
var bool bExpandMenuShow;

function OnRegisterEvent()
{
	RegisterEvent(150);
	return;
}

function OnLoad()
{
	Initialize();
	return;
}

function Initialize()
{
	MenuEntireWndScript = MenuEntireWnd(GetScript("MenuEntireWnd"));
	Me = GetWindowHandle("Menu");
	return;
}

function Load()
{
	ShowWindowWithFocus("Menu");
	return;
}

function OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	local string Num, win;

	if(("SystemMenuWnd" == a_ButtonHandle.GetWindowName()))
	{
		win = a_ButtonHandle.GetWindowName();
	}
	else if(("ExpandMenuButton" == a_ButtonHandle.GetWindowName()))
	{
		win = a_ButtonHandle.GetWindowName();
	}
	else
	{
		Debug(("a_buttonHandle" @ a_ButtonHandle.GetParentWindowName()));
		Num = Right(a_ButtonHandle.GetParentWindowName(), 2);
		win = menuList[(menuList.Length - (int(Num) + 1))].MenuName;
	}
	Debug(("win" @ win));
	switch(win)
	{
		case "SystemMenuWnd":
			clickSystemMenu();
			break;
		case "ExpandMenuButton":
			ShowHideMenus(!bExpandMenuShow);
			break;
		default:
			MenuEntireWndScript.onMenuClick(win);
			break;
	}
	return;
}

event OnEnterState(name a_CurrentStateName)
{
	Load();
	setBTN();
	return;
}

function setBTN()
{
	local string ToolTipString, BtnTex, bZoomMenu;
	local int i;

	menuList = MenuEntireWndScript.getCheckboxChecked();
	ToolTipString = MenuEntireWnd(GetScript("MenuEntireWnd")).setMainShortcutString(MenuEntireWnd(GetScript("MenuEntireWnd")).getAssignedKeyGroup(), "SystemMenuWnd");
	GetMeButton("MainMenuWnd.SystemMenuWnd").SetTooltipCustomType(MakeTooltipMultiText(GetSystemString(193), getInstanceL2Util().White, "", false, ToolTipString, getInstanceL2Util().White, "", true, , , ));
	i = 0;
	while((i < 12))
	{
		GetMeWindow(("BTNWnd_" $ fillZero(i))).HideWindow();
		i++;
	}
	i = 0;
	while((i < menuList.Length))
	{
		ToolTipString = MenuEntireWnd(GetScript("MenuEntireWnd")).setMainShortcutString(MenuEntireWnd(GetScript("MenuEntireWnd")).getAssignedKeyGroup(), menuList[(menuList.Length - (i + 1))].MenuName);
		GetMeButton((("BTNWnd_" $ fillZero(i)) $ ".MenuButton")).ClearTooltip();
		GetMeButton((("BTNWnd_" $ fillZero(i)) $ ".MenuButton")).SetTooltipCustomType(MakeTooltipMultiText(menuList[(menuList.Length - (i + 1))].buttonText, getInstanceL2Util().White, "", false, ToolTipString, getInstanceL2Util().White, "", true, , , ));
		BtnTex = MenuEntireWndScript.getMenuIconTexture(menuList[(menuList.Length - (i + 1))].MenuName);
		GetMeButton((("BTNWnd_" $ fillZero(i)) $ ".MenuButton")).SetTexture(BtnTex, (BtnTex $ "_Down"), (BtnTex $ "_Over"));
		GetMeWindow(("BTNWnd_" $ fillZero(i))).ShowWindow();
		GetMeWindow(("BTNWnd_" $ fillZero(i))).ClearAnchor();
		GetMeWindow(("BTNWnd_" $ fillZero(i))).SetAnchor("", "BottomRight", "", (-(i * 39) - 60), -36);
		i++;
	}
	if((menuList.Length == 0))
	{
		GetMeButton("ExpandMenuButton").HideWindow();
	}
	else
	{
		GetMeButton("ExpandMenuButton").ShowWindow();
	}
	GetINIString("MenuEntireWnd", "b", bZoomMenu, "WindowsInfo.ini");
	ShowHideMenus(numToBool(int(bZoomMenu)));
	return;
}

function clickSystemMenu()
{
	local string strParam;

	ParamAdd(strParam, "Name", "SystemMenuWnd");
	ParamAdd(strParam, "SystemMenuWndFocus", "1");
	ExecuteEvent(3080, strParam);
	return;
}

function ShowHideMenus(bool bShow)
{
	local int i;

	bExpandMenuShow = bShow;
	if(bShow)
	{
		i = 0;
		while((i < 12))
		{
			GetMeWindow(("BTNWnd_" $ fillZero(i))).HideWindow();
			i++;
		}
		i = 0;
		while((i < menuList.Length))
		{
			GetMeWindow(("BTNWnd_" $ fillZero(i))).ShowWindow();
			i++;
		}
		GetMeButton("ExpandMenuButton").SetTexture("L2UI_NewTex.MenuWnd.MainMenu_-Btn_Normal", "L2UI_NewTex.MenuWnd.MainMenu_-Btn_Down", "L2UI_NewTex.MenuWnd.MainMenu_-Btn_Over");
	}
	else
	{
		i = 0;
		while((i < 12))
		{
			GetMeWindow(("BTNWnd_" $ fillZero(i))).HideWindow();
			i++;
		}
		GetMeButton("ExpandMenuButton").SetTexture("L2UI_NewTex.MenuWnd.MainMenu_+Btn_Normal", "L2UI_NewTex.MenuWnd.MainMenu_+Btn_Down", "L2UI_NewTex.MenuWnd.MainMenu_+Btn_Over");
	}
	SetINIString("MenuEntireWnd", "b", string(boolToNum(bShow)), "WindowsInfo.ini");
	return;
}

function string fillZero(int Num)
{
	if((Num <= 9))
	{
		return ("0" $ string(Num));
	}
	return string(Num);
}
