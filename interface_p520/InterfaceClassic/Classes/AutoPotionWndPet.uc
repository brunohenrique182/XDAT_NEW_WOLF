class AutoPotionWndPet extends UICommonAPI;

const AUTO_HP_PET_POTION_SHORTCUT_NUM = 278;

var WindowHandle Me;
var string m_Windowname;
var string m_ParentName;
var AutoPotionSubWndPet AutoPotionSubWndPetScript;
var ButtonHandle SettingButton;
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
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	m_ParentName = Me.GetParentWindowName();
	SettingButton = GetButtonHandle((m_Windowname $ ".setting_Btn"));
	AutoPotionSubWndPetScript = AutoPotionSubWndPet(GetScript((m_ParentName $ ".AutoPotionSubWndPet")));
	return;
}

function HandleShortcutPageUpdateAll()
{
	Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut((m_Windowname $ ".HP_PotionSlot"), 278);
	setPotionStateCustomTooltip();
	return;
}

function HandleShortcutClear(string param)
{
	local int nShortcutID;

	ParseInt(param, "ShortcutID", nShortcutID);
	if((nShortcutID == 278))
	{
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear((m_Windowname $ ".HP_PotionSlot"));
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
	if((nShortcutID == 278))
	{
		currentSlotClassID = nClassID;
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut((m_Windowname $ ".HP_PotionSlot"), nShortcutID);
		setPotionStateCustomTooltip();
		if((nClassID <= 0))
		{
			bActiveAutoPotionSlot = false;
		}
		if((nClassID > 0))
		{
			AutoPotionSubWndPetScript.ExSetSelectPostion(nClassID);
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
	if((nShortcutID == 278))
	{
		ParseInt(param, "AutomaticUseActivated", nAutomaticUseActivated);
		bActiveAutoPotionSlot = (nAutomaticUseActivated > 0);
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
		SettingButton.SetTooltipCustomType(getUsePotionCustomTooltip());
	}
	else
	{
		SettingButton.SetTooltipCustomType(getPotionDescCustomTooltip());
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
	if(AutoPotionSubWndPetScript.Me.IsShowWindow())
	{
		AutoPotionSubWndPetScript.Me.HideWindow();
	}
	else
	{
		AutoPotionSubWndPetScript.Me.ShowWindow();
		AutoPotionSubWndPetScript.Me.SetFocus();
	}
	return;
}

function int getAutoPotionSlotIDPet()
{
	return 278;
}
