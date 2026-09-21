class AutoUseItemWndMin extends UICommonAPI;

var WindowHandle Me;
var AnimTextureHandle ToggleEffect_Anim;
var AutoUseItemWnd AutoUseItemWndScript;
var AnimTextureHandle AutoTargetToggleEffect_Anim;

event OnRegisterEvent()
{
	RegisterEvent(3410);
	RegisterEvent(11620);
	return;
}

event OnShow()
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		Me.HideWindow();
		return;
	}
	setPlayActiveAnim();
	setPlayAutoTargetActiveAnim();
	return;
}

event OnLoad()
{
	Initialize();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("AutoUseItemWndMin");
	ToggleEffect_Anim = GetAnimTextureHandle("AutoUseItemWndMin.AutoAllON_Win.ToggleEffect_Anim");
	AutoTargetToggleEffect_Anim = GetAnimTextureHandle("AutoUseItemWndMin.AutoTargetWndMin_window.AutoTargetAllON_Win.ToggleEffect_Anim");
	AutoUseItemWndScript = AutoUseItemWnd(GetScript("AutoUseItemWnd"));
	return;
}

event OnEvent(int Event_ID, string param)
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		return;
	}
	switch(Event_ID)
	{
		case 3410:
			if((param == "COLLECTIONSTATE"))
			{
				if((AutoUseItemWnd(GetScript("AutoUseItemWnd")).nMinimal == 1))
				{
					getInstanceL2Util().syncWindowLoc("AutoUseItemWndMin", "AutoUseItemWnd", -115, -98);
				}
			}
			break;
		case 11620:
			HandleUpdatePlayerAutoAttacking();
			break;
		default:
			break;
	}
	return;
}

event OnRButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	OnClickButton(a_WindowHandle.GetWindowName());
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "AutoAll_BTN":
			AutoUseItemWndScript.OnClickButton("AutoAll_BTN");
			break;
		case "Inventory_Button":
			AutoUseItemWndScript.forceShowInven();
		case "WinExpandButton_Button":
			SetINIBool("AutoUseItemWnd", "l", false, "windowsInfo.ini");
			AutoUseItemWnd(GetScript("AutoUseItemWnd")).nMinimal = 0;
			Me.HideWindow();
			ShowWindowWithFocus("AutoUseItemWnd");
			getInstanceL2Util().syncWindowLoc("AutoUseItemWndMin", "AutoUseItemWnd", -115, -98);
			getInstanceL2Util().fixWindowLocOverResolution("AutoUseItemWnd");
			break;
		case "MacroWnd_Button":
			ExecuteEvent(1230);
			SetINIBool("AutoUseItemWnd", "l", false, "windowsInfo.ini");
			Me.HideWindow();
			OnClickButton("WinExpandButton_Button");
			break;
		case "AutoTarget_AutoAll_BTN":
			AutoUseItemWndScript.OnClickButton("AutoTargetAll_BTN");
			break;
		default:
			break;
	}
	return;
}

function setPlayActiveAnim()
{
	if(!Me.IsShowWindow())
	{
		return;
	}
	if(AutoUseItemWndScript.getActivateAll())
	{
		AnimTexturePlay(ToggleEffect_Anim, true);
		GetWindowHandle("AutoUseItemWndMin.AutoAllON_Win").ShowWindow();
		GetWindowHandle("AutoUseItemWndMin.AutoAllOFF_Win").HideWindow();
	}
	else
	{
		AnimTextureStop(ToggleEffect_Anim, true);
		GetWindowHandle("AutoUseItemWndMin.AutoAllON_Win").HideWindow();
		GetWindowHandle("AutoUseItemWndMin.AutoAllOFF_Win").ShowWindow();
	}
	return;
}

function setPlayAutoTargetActiveAnim()
{
	if(!Me.IsShowWindow())
	{
		return;
	}
	if(AutoUseItemWndScript.getUseAutoTarget())
	{
		AnimTexturePlay(AutoTargetToggleEffect_Anim, true);
		GetWindowHandle("AutoUseItemWndMin.AutoTargetWndMin_window.AutoTargetAllON_Win").ShowWindow();
		GetWindowHandle("AutoUseItemWndMin.AutoTargetWndMin_window.AutoTargetAllOFF_Win").HideWindow();
	}
	else
	{
		AnimTextureStop(AutoTargetToggleEffect_Anim, true);
		GetWindowHandle("AutoUseItemWndMin.AutoTargetWndMin_window.AutoTargetAllON_Win").HideWindow();
		GetWindowHandle("AutoUseItemWndMin.AutoTargetWndMin_window.AutoTargetAllOFF_Win").ShowWindow();
	}
	return;
}

function setShortcutTooltip(string tooltipStr)
{
	GetButtonHandle("AutoUseItemWndMin.AutoTargetWndMin_window.AutoTarget_AutoAll_BTN").SetTooltipCustomType(MakeTooltipMultiText(GetSystemString(2165), getInstanceL2Util().White, , true, tooltipStr, getInstanceL2Util().BWhite, , true));
	return;
}

function HandleUpdatePlayerAutoAttacking()
{
	Debug(("HandleUpdatePlayerAutoAttacking" @ string(API_IsAutoAttacking())));
	if(API_IsAutoAttacking())
	{
		GetTextureHandle("AutoUseItemWndMin.AutoTargetWndMin_window.AutoTargetAllON_Win.AutoAllIcon_On_texture").SetTexture("L2UI_CT1.AutoShotItemWnd.AutoTargetFight_On");
		GetTextureHandle("AutoUseItemWndMin.AutoTargetWndMin_window.AutoTargetAllOFF_Win.AutoAllIcon_Off_texture").SetTexture("L2UI_CT1.AutoShotItemWnd.AutoTargetFight_Off");
	}
	else
	{
		GetTextureHandle("AutoUseItemWndMin.AutoTargetWndMin_window.AutoTargetAllON_Win.AutoAllIcon_On_texture").SetTexture("L2UI_CT1.AutoShotItemWnd.AutoTargetAllIcon_On");
		GetTextureHandle("AutoUseItemWndMin.AutoTargetWndMin_window.AutoTargetAllOFF_Win.AutoAllIcon_Off_texture").SetTexture("L2UI_CT1.AutoShotItemWnd.AutoTargetAllIcon_Off");
	}
	return;
}

function bool API_IsAutoAttacking()
{
	return Class'NWindow.UIDATA_PLAYER'.static.IsAutoAttacking();
}
