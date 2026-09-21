class YetiPCModeChangeWnd extends UICommonAPI;

var WindowHandle Me;
var ButtonHandle YetiPCChange_Btn;
var Shortcut ShortcutScript;
var ShortcutWnd ShortcutWndScript;
var AutoPotionWnd AutoPotionWndScript;
var AutoUseItemWnd AutoUseItemWndScript;
var bool bActiveYetiMode;

function OnRegisterEvent()
{
	RegisterEvent(40);
	return;
}

function OnLoad()
{
	Initialize();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("YetiPCModeChangeWnd");
	YetiPCChange_Btn = GetButtonHandle("YetiPCModeChangeWnd.YetiPCChange_Btn");
	ShortcutScript = Shortcut(GetScript("Shortcut"));
	ShortcutWndScript = ShortcutWnd(GetScript("ShortcutWnd"));
	AutoPotionWndScript = AutoPotionWnd(GetScript("AutoPotionWnd"));
	AutoUseItemWndScript = AutoUseItemWnd(GetScript("AutoUseItemWnd"));
	bActiveYetiMode = false;
	return;
}

function bool isYetiMode()
{
	return bActiveYetiMode;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 40:
			bActiveYetiMode = false;
			break;
		default:
			break;
	}
	return;
}

function setYetiMode(bool bUseYetiMode)
{
	ShortcutScript.HandleCloseAllWindow();
	if(bUseYetiMode)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemString(13096));
		bActiveYetiMode = true;
		if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("RadarMapWnd"))
		{
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow("RadarMapWnd");
		}
		if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("ShortcutWnd"))
		{
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ShortcutWnd");
		}
		if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("AutoPotionWnd"))
		{
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow("AutoPotionWnd");
		}
		if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("Menu"))
		{
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow("Menu");
		}
		if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("NoticeWnd"))
		{
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow("NoticeWnd");
		}
		ShortcutScript.HandleForceShowChatWindow(false);
		if(getInstanceUIData().GetIsLiveServer())
		{
			AutoUseItemWndScript.showHideForYeti(false);
		}
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("YetiPCModeChangeWnd");
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("YetiQuickSlotWnd");
	}
	else
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemString(13097));
		bActiveYetiMode = false;
		if(!Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("RadarMapWnd"))
		{
			Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("RadarMapWnd");
		}
		if(!Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("ShortcutWnd"))
		{
			Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("ShortcutWnd");
		}
		if(!Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("AutoPotionWnd"))
		{
			Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("AutoPotionWnd");
		}
		if(!Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("Menu"))
		{
			Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("Menu");
		}
		if(!Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("NoticeWnd"))
		{
			Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("NoticeWnd");
		}
		AutoPotionWndScript.windowPositionAutoMove();
		ShortcutScript.HandleForceShowChatWindow(true);
		if(getInstanceUIData().GetIsLiveServer())
		{
			AutoUseItemWndScript.showHideForYeti(true);
		}
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("YetiPCModeChangeWnd");
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("YetiQuickSlotWnd");
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "YetiPCChange_Btn":
			OnYetiPCChange_BtnClick();
			break;
		default:
			break;
	}
	return;
}

function OnYetiPCChange_BtnClick()
{
	setYetiMode(false);
	return;
}
