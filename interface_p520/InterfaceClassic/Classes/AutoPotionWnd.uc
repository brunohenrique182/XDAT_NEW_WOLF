class AutoPotionWnd extends UICommonAPI;

const AutoHPPotionSlotID = 277;

var WindowHandle Me;
var string m_Windowname;
var ShortcutWnd ShortcutWndScript;
var AutoPotionSubWnd AutoPotionSubWndScript;
var YetiPCModeChangeWnd YetiPCModeChangeWndScript;
var ButtonHandle hSettingButton;
var ButtonHandle vSettingButton;
var int currentSlotClassID;
var int currentSettingHpPercent;
var bool bActiveAutoPotionSlot;

function OnRegisterEvent()
{
	RegisterEvent(9750);
	RegisterEvent(40);
	RegisterEvent(630);
	RegisterEvent(650);
	RegisterEvent(694);
	RegisterEvent(11170);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Me = GetWindowHandle("AutoPotionWnd");
	hSettingButton = GetButtonHandle("AutoPotionWnd.AutoPotionWnd_HorWnd.HP_PotionWnd_HorWnd.setting_Btn");
	vSettingButton = GetButtonHandle("AutoPotionWnd.AutoPotionWnd_VerWnd.HP_PotionWnd_VerWnd.setting_Btn");
	ShortcutWndScript = ShortcutWnd(GetScript("ShortcutWnd"));
	AutoPotionSubWndScript = AutoPotionSubWnd(GetScript("AutoPotionSubWnd"));
	YetiPCModeChangeWndScript = YetiPCModeChangeWnd(GetScript("YetiPCModeChangeWnd"));
	return;
}

function HandleShortcutPageUpdateAll()
{
	Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("AutoPotionWnd.AutoPotionWnd_HorWnd.HP_PotionSlot", 277);
	Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("AutoPotionWnd.AutoPotionWnd_VerWnd.HP_PotionSlot", 277);
	setPotionStateCustomTooltip();
	return;
}

function HandleShortcutClear(string param)
{
	local int nShortcutID;

	ParseInt(param, "ShortcutID", nShortcutID);
	if((nShortcutID == 277))
	{
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear("AutoPotionWnd.AutoPotionWnd_HorWnd.HP_PotionWnd_HorWnd.HP_PotionSlot");
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear("AutoPotionWnd.AutoPotionWnd_VerWnd.HP_PotionWnd_VerWnd.HP_PotionSlot");
		currentSlotClassID = 0;
		setPotionStateCustomTooltip();
		bActiveAutoPotionSlot = false;
	}
	return;
}

function HandleShortcutUpdate(string param)
{
	local int nShortcutID, nClassID;

	ParseInt(param, "ShortcutID", nShortcutID);
	ParseInt(param, "ClassID", nClassID);
	if((nShortcutID == 277))
	{
		currentSlotClassID = nClassID;
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("AutoPotionWnd.AutoPotionWnd_HorWnd.HP_PotionWnd_HorWnd.HP_PotionSlot", nShortcutID);
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("AutoPotionWnd.AutoPotionWnd_VerWnd.HP_PotionWnd_VerWnd.HP_PotionSlot", nShortcutID);
		setPotionStateCustomTooltip();
		if((nClassID <= 0))
		{
			bActiveAutoPotionSlot = false;
		}
		if((nClassID > 0))
		{
			AutoPotionSubWndScript.ExSetSelectPostion(nClassID);
		}
	}
	return;
}

function int getCurrentSlotClassID()
{
	return currentSlotClassID;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 9750:
			bActiveAutoPotionSlot = false;
			HandleShortcutPageUpdateAll();
			break;
		case 630:
			HandleShortcutUpdate(param);
			break;
		case 650:
			HandleShortcutClear(param);
			break;
		case 694:
			ShortcutAutomaticUseActivatedHandler(param);
			break;
		case 11170:
			setPotionStateCustomTooltip();
			break;
		case 40:
			currentSlotClassID = 0;
			bActiveAutoPotionSlot = false;
			windowPositionAutoMove();
			break;
		default:
			break;
	}
	return;
}

function ShortcutAutomaticUseActivatedHandler(string param)
{
	local int nShortcutID, nAutomaticUseActivated;

	ParseInt(param, "ShortcutID", nShortcutID);
	ParseInt(param, "AutomaticUseActivated", nAutomaticUseActivated);
	if((nShortcutID == 277))
	{
		if((nAutomaticUseActivated > 0))
		{
			bActiveAutoPotionSlot = true;
		}
		else
		{
			bActiveAutoPotionSlot = false;
		}
	}
	return;
}

function bool getActiveAutoPotionSlot()
{
	return bActiveAutoPotionSlot;
}

function setPotionStateCustomTooltip()
{
	if((currentSlotClassID > 0))
	{
		hSettingButton.SetTooltipCustomType(getUsePotionCustomTooltip());
		vSettingButton.SetTooltipCustomType(getUsePotionCustomTooltip());
	}
	else
	{
		hSettingButton.SetTooltipCustomType(getPotionDescCustomTooltip());
		vSettingButton.SetTooltipCustomType(getPotionDescCustomTooltip());
	}
	return;
}

function CustomTooltip getUsePotionCustomTooltip()
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13008), getInstanceL2Util().BrightWhite, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = addDrawItemText(MakeFullSystemMsg(GetSystemMessage(5292), string(currentSettingHpPercent)), getInstanceL2Util().DRed, "", true, true);
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 130;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;
}

function CustomTooltip getPotionDescCustomTooltip()
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13008), getInstanceL2Util().BrightWhite, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemMessage(5291), getInstanceL2Util().ColorDesc, "", true, false);
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 130;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "setting_Btn":
			Onsetting_BtnClick();
			break;
		default:
			break;
	}
	return;
}

function Onsetting_BtnClick()
{
	if(GetWindowHandle("AutoPotionSubWnd").IsShowWindow())
	{
		GetWindowHandle("AutoPotionSubWnd").HideWindow();
	}
	else
	{
		if(IsVertical())
		{
			GetWindowHandle("AutoPotionSubWnd").SetAnchor((m_Windowname $ ".AutoPotionWnd_VerWnd"), "TopLeft", "TopRight", 100, 0);
		}
		else
		{
			GetWindowHandle("AutoPotionSubWnd").SetAnchor((m_Windowname $ ".AutoPotionWnd_HorWnd"), "TopLeft", "BottomLeft", 15, 80);
		}
		GetWindowHandle("AutoPotionSubWnd").ShowWindow();
		GetWindowHandle("AutoPotionSubWnd").SetFocus();
	}
	return;
}

function string getShortcutIndexStr()
{
	local int nIndex;
	local string RValue;

	nIndex = ShortcutWndScript.getExpandNum();
	if((nIndex <= 0))
	{
		RValue = "";
	}
	else
	{
		RValue = ("_" $ string(nIndex));
	}
	return RValue;
}

function bool IsVertical()
{
	return ShortcutWndScript.IsVertical();
}

function bool isShowPetOrSummonSlot()
{
	return (AutoShotItemWnd(GetScript("AutoShotItemWnd")).bSummonException() || Class'NWindow.UIDATA_PET'.static.IsHavePet());
}

function int getAutoPotionSlotID()
{
	return 277;
}

function windowPositionAutoMove()
{
	local int addPosPetSlot;

	if((GetGameStateName() != "GAMINGSTATE"))
	{
		return;
	}
	if(YetiPCModeChangeWndScript.isYetiMode())
	{
		GetWindowHandle("AutoPotionSubWnd").HideWindow();
		GetWindowHandle((m_Windowname $ ".AutoPotionWnd_VerWnd")).HideWindow();
		GetWindowHandle((m_Windowname $ ".AutoPotionWnd_HorWnd")).HideWindow();
		return;
	}
	GetWindowHandle(m_Windowname).ClearAnchor();
	GetWindowHandle((m_Windowname $ ".AutoPotionWnd_VerWnd")).HideWindow();
	GetWindowHandle((m_Windowname $ ".AutoPotionWnd_HorWnd")).HideWindow();
	if(isShowPetOrSummonSlot())
	{
		addPosPetSlot = (addPosPetSlot + 100);
	}
	if(IsVertical())
	{
		GetWindowHandle(m_Windowname).SetAnchor(("ShortcutWnd.ShortcutWndVertical" $ getShortcutIndexStr()), "TopLeft", "TopRight", -1, (129 + addPosPetSlot));
		GetWindowHandle((m_Windowname $ ".AutoPotionWnd_VerWnd")).ShowWindow();
	}
	else
	{
		GetWindowHandle(m_Windowname).SetAnchor(("ShortcutWnd.ShortcutWndHorizontal" $ getShortcutIndexStr()), "TopLeft", "BottomLeft", (129 + addPosPetSlot), -1);
		GetWindowHandle((m_Windowname $ ".AutoPotionWnd_HorWnd")).ShowWindow();
	}
	return;
}

defaultproperties
{
	m_Windowname="AutoPotionWnd"
}
