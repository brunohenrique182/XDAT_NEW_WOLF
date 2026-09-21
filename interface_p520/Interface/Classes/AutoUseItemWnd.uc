class AutoUseItemWnd extends UICommonAPI;

const MAX_ShortcutPerPage = 12;
const AUTO_ITEM_SHORTCUT_PAGE = 22;

var WindowHandle Me;
var AutoUseItemWndMin AutoUseItemWndMinScript;
var YetiQuickSlotWnd YetiQuickSlotwndScript;
var int nMinimal;
var AnimTextureHandle ToggleEffect_Anim;
var AutoUseItemInventory AutoUseItemInventoryScript;
var UIMapInt64Object ActiveSlotArrayMap;
var UIMapInt64Object ItemInfoSlotArrayMap;
var bool bActivateAll;
var AnimTextureHandle AutoTarget_ToggleMacro_Anim;
var ButtonHandle shotD_Target_BTN;
var ButtonHandle Next_Target_BTN;
var ButtonHandle TargetPickupToggle_BTN;
var ButtonHandle TargetMannerToggle_BTN;
var WindowHandle TargetStatusWndScript;
var WindowHandle AutoTargetAllON_Win;
var ButtonHandle MacroSelectBtn_01;
var ButtonHandle MacroSelectBtn_02;
var AnimTextureHandle AutoTargetAllON_ToggleEffect_Anim;
var bool autotarget_bShortTarget;
var bool autotarget_bUseAutoTarget;
var bool autotarget_bIsPickupOn;
var UIEventManager.EAutoNextTargetMode autotarget_nTargetMode;
var int autotarget_nHPPotionPercent;
var bool autotarget_bIsMannerModeOn;
var int nMacroSlotSelect;

event OnRegisterEvent()
{
	RegisterEvent(9750);
	RegisterEvent(40);
	RegisterEvent(150);
	RegisterEvent(694);
	RegisterEvent(630);
	RegisterEvent(650);
	RegisterEvent(11170);
	RegisterEvent(11030);
	RegisterEvent(5720);
	RegisterEvent(11152);
	RegisterEvent(11620);
	return;
}

event OnLoad()
{
	Initialize();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("AutoUseItemWnd");
	ToggleEffect_Anim = GetAnimTextureHandle("AutoUseItemWnd.AutoAllON_Win.ToggleEffect_Anim");
	AutoUseItemInventoryScript = AutoUseItemInventory(GetScript("AutoUseItemInventory"));
	AutoUseItemWndMinScript = AutoUseItemWndMin(GetScript("AutoUseItemWndMin"));
	YetiQuickSlotwndScript = YetiQuickSlotWnd(GetScript("YetiQuickSlotwnd"));
	AutoTarget_ToggleMacro_Anim = GetAnimTextureHandle("AutoUseItemWnd.AutoTargetWnd.ToggleMacro_Anim");
	shotD_Target_BTN = GetButtonHandle("AutoUseItemWnd.AutoTargetWnd.shotD_Target_BTN");
	Next_Target_BTN = GetButtonHandle("AutoUseItemWnd.AutoTargetWnd.Next_Target_BTN");
	MacroSelectBtn_01 = GetButtonHandle("AutoUseItemWnd.AutoTargetWnd.MacroSelectBtn_01");
	MacroSelectBtn_02 = GetButtonHandle("AutoUseItemWnd.AutoTargetWnd.MacroSelectBtn_02");
	TargetPickupToggle_BTN = GetButtonHandle("AutoUseItemWnd.AutoTargetWnd.TargetPickupToggle_BTN");
	TargetMannerToggle_BTN = GetButtonHandle("AutoUseItemWnd.AutoTargetWnd.TargetMannerToggle_BTN");
	TargetStatusWndScript = GetWindowHandle("TargetStatusWnd");
	AutoTargetAllON_Win = GetWindowHandle("AutoUseItemWnd.AutoTargetWnd.AutoTargetAllON_Win");
	AutoTargetAllON_ToggleEffect_Anim = GetAnimTextureHandle("AutoUseItemWnd.AutoTargetWnd.AutoTargetAllON_Win.ToggleEffect_Anim");
	ActiveSlotArrayMap = new Class'Interface.UIMapInt64Object';
	ItemInfoSlotArrayMap = new Class'Interface.UIMapInt64Object';
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
	AutotargetOnShow();
	Autotarget_UpdateAutoTargetState();
	Autotarget_SetCusomTooltip();
	Autotarget_updatePickupButton();
	Autotarget_PickupSetCusomTooltip();
	Autotarget_updateMannerModeButton();
	Autotarget_MannerModeSetCusomTooltip();
	return;
}

function initAll()
{
	initSlotArray();
	HandleShortcutPageUpdateAll();
	bActivateAll = false;
	YetiQuickSlotwndScript.setPlayAutoTargetActiveAnim();
	checkMinimal();
	return;
}

function checkMinimal()
{
	Me.ShowWindow();
	GetINIBool("AutoUseItemWnd", "l", nMinimal, "windowsInfo.ini");
	if((nMinimal > 0))
	{
		OnClickButton("WinMin_Button");
	}
	return;
}

function showHideForYeti(bool bShow)
{
	if(bShow)
	{
		if((nMinimal > 0))
		{
			OnClickButton("WinMin_Button");
		}
		else
		{
			Me.ShowWindow();
		}
	}
	else
	{
		Me.HideWindow();
		GetWindowHandle("AutoUseItemWndMin").HideWindow();
	}
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
		case 9750:
			initAll();
			break;
		case 150:
			checkMinimal();
			break;
		case 40:
			initSlotArray();
			bActivateAll = false;
			nMinimal = 0;
			Autotarget_Init();
			break;
		case 694:
			ShortcutAutomaticUseActivatedHandler(param);
			YetiQuickSlotwndScript.setPlayAutoTargetActiveAnim();
			break;
		case 630:
			HandleShortcutUpdate(param);
			break;
		case 650:
			initAll();
			Autotarget_Init();
			Autotarget_UpdateShortCutElement();
			break;
		case 11170:
			Debug(("EV_AutoplaySetting" @ param));
			AutoplaySettingHandler(param);
			break;
		case 11030:
		case 5720:
			NextTargetModeHandler();
			break;
		case 11152:
			if(autotarget_bUseAutoTarget)
			{
				requestAutoPlay(false);
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

function NextTargetModeHandler()
{
	local UIEventManager.EAutoNextTargetMode nTargetMode;

	nTargetMode = GetNextTargetModeOption();
	if((int(autotarget_nTargetMode) != int(nTargetMode)))
	{
		if(autotarget_bUseAutoTarget)
		{
			requestAutoPlay(autotarget_bUseAutoTarget);
		}
	}
	Autotarget_NextTargetSetCusomTooltip();
	return;
}

function AutoplaySettingHandler(string param)
{
	local int nIsAutoPlayOn, nNextTargetMode, nIsNearTargetMode, nIsPickupOn, nHPPotionPercent, nIsMannerModeOn, nMacroIndex;

	ParseInt(param, "IsPickupOn", nIsPickupOn);
	ParseInt(param, "IsAutoPlayOn", nIsAutoPlayOn);
	ParseInt(param, "NextTargetMode", nNextTargetMode);
	ParseInt(param, "IsNearTargetMode", nIsNearTargetMode);
	ParseInt(param, "HPPotionPercent", nHPPotionPercent);
	ParseInt(param, "IsMannerModeOn", nIsMannerModeOn);
	ParseInt(param, "MacroIndex", nMacroIndex);
	autotarget_bUseAutoTarget = numToBool(nIsAutoPlayOn);
	autotarget_bShortTarget = numToBool(nIsNearTargetMode);
	autotarget_bIsPickupOn = numToBool(nIsPickupOn);
	autotarget_bIsMannerModeOn = numToBool(nIsMannerModeOn);
	autotarget_nHPPotionPercent = nHPPotionPercent;
	nMacroSlotSelect = nMacroIndex;
	Autotarget_UpdateAutoTargetState();
	return;
}

function HandleShortcutClear(string param)
{
	local int nShortcutID;

	ParseInt(param, "ShortcutID", nShortcutID);
	if(((nShortcutID >= (22 * 12)) && (nShortcutID <= ((22 * 12) + 12))))
	{
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear(((("AutoUseItemWnd.ItemGroup_Wnd" $ ".AutoUseItem") $ string(((nShortcutID - (22 * 12)) + 1))) $ "_ShortcutItem"));
	}
	else if(((nShortcutID >= 288) && (nShortcutID <= 293)))
	{
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear(((("AutoUseItemWnd.ItemGroup_Wnd" $ ".AutoUseItem") $ string((nShortcutID - 275))) $ "_ShortcutItem"));
	}
	return;
}

function HandleShortcutUpdate(string param)
{
	local int nShortcutID, nClassID;

	ParseInt(param, "ShortcutID", nShortcutID);
	ParseInt(param, "ClassID", nClassID);
	if((((nShortcutID >= (22 * 12)) && (nShortcutID <= (((22 * 12) + 12) - 1))) || ((nShortcutID >= 288) && (nShortcutID <= 293))))
	{
		if((nClassID <= -1))
		{
			ItemInfoSlotArrayMap.Add(INT64(nShortcutID), INT64(0));
		}
		else
		{
			ItemInfoSlotArrayMap.Add(INT64(nShortcutID), INT64(nClassID));
		}
		if(((nShortcutID >= 288) && (nShortcutID <= 293)))
		{
			Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(((("AutoUseItemWnd.ItemGroup_Wnd" $ ".AutoUseItem") $ string((nShortcutID - 275))) $ "_ShortcutItem"), nShortcutID);
		}
		else
		{
			Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(((("AutoUseItemWnd.ItemGroup_Wnd" $ ".AutoUseItem") $ string(((nShortcutID - (22 * 12)) + 1))) $ "_ShortcutItem"), nShortcutID);
		}
		if((nClassID <= 0))
		{
			ActiveSlotArrayMap.Add(INT64(nShortcutID), INT64(0));
		}
		setCheckActivateAll();
		setPlayActiveAnim();
		YetiQuickSlotwndScript.setPlayAutoTargetActiveAnim();
	}
	else if((nShortcutID == 276))
	{
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("AutoUseItemWnd.AutoTargetWnd.Macro1ShortcutItem", 276);
	}
	else if((nShortcutID == 279))
	{
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("AutoUseItemWnd.AutoTargetWnd.Macro2ShortcutItem", 279);
	}
	if((autotarget_bUseAutoTarget && ((nShortcutID == 276) || (nShortcutID == 279))))
	{
		requestAutoPlay(false);
	}
	return;
}

function initSlotArray()
{
	local int i;

	ActiveSlotArrayMap.RemoveAll();
	ItemInfoSlotArrayMap.RemoveAll();
	i = 0;
	while((i < 12))
	{
		ItemInfoSlotArrayMap.Add(INT64((264 + i)), INT64(0));
		i++;
	}
	i = 0;
	while((i < 6))
	{
		ItemInfoSlotArrayMap.Add(INT64((288 + i)), INT64(0));
		i++;
	}
	return;
}

function ShortcutAutomaticUseActivatedHandler(string param)
{
	local int nShortcutID, nAutomaticUseActivated;

	ParseInt(param, "ShortcutID", nShortcutID);
	ParseInt(param, "AutomaticUseActivated", nAutomaticUseActivated);
	if((((nShortcutID >= (22 * 12)) && (nShortcutID <= ((22 * 12) + 12))) || ((nShortcutID >= 288) && (nShortcutID <= 293))))
	{
		ActiveSlotArrayMap.Add(INT64(nShortcutID), INT64(nAutomaticUseActivated));
		setCheckActivateAll();
		setPlayActiveAnim();
		AutoUseItemWndMinScript.setPlayActiveAnim();
		YetiQuickSlotwndScript.setPlayAutoTargetActiveAnim();
	}
	return;
}

function int getEmptySlotNum()
{
	return int(ItemInfoSlotArrayMap.FindKeyByData(INT64(0)));
}

function setCheckActivateAll()
{
	local int i;
	local array<INT64> arr;

	arr = ActiveSlotArrayMap.ContainAll();
	i = 0;
	while((i < arr.Length))
	{
		if((arr[i] > INT64(0)))
		{
			bActivateAll = true;
			return;
		}
		i++;
	}
	bActivateAll = false;
	return;
}

function setPlayActiveAnim()
{
	if(!Me.IsShowWindow())
	{
		return;
	}
	if(bActivateAll)
	{
		ToggleEffect_Anim.ShowWindow();
		ToggleEffect_Anim.SetLoopCount(99999);
		ToggleEffect_Anim.Stop();
		ToggleEffect_Anim.Play();
		GetWindowHandle("AutoUseItemWnd.AutoAllON_Win").ShowWindow();
		GetWindowHandle("AutoUseItemWnd.AutoAllOFF_Win").HideWindow();
	}
	else
	{
		ToggleEffect_Anim.HideWindow();
		ToggleEffect_Anim.Stop();
		GetWindowHandle("AutoUseItemWnd.AutoAllON_Win").HideWindow();
		GetWindowHandle("AutoUseItemWnd.AutoAllOFF_Win").ShowWindow();
	}
	return;
}

function bool getActivateAll()
{
	return bActivateAll;
}

function HandleShortcutPageUpdateAll()
{
	local int i, nShortcutID;

	nShortcutID = (22 * 12);
	i = 1;
	while((i <= 12))
	{
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(((("AutoUseItemWnd.ItemGroup_Wnd" $ ".AutoUseItem") $ string(i)) $ "_ShortcutItem"), nShortcutID);
		nShortcutID++;
		++i;
	}
	nShortcutID = 275;
	i = 13;
	while((i <= 18))
	{
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(((("AutoUseItemWnd.ItemGroup_Wnd" $ ".AutoUseItem") $ string(i)) $ "_ShortcutItem"), (nShortcutID + i));
		i++;
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "Inventory_Button":
			onInventory_ButtonClick();
			break;
		case "AutoAll_BTN":
			Class'NWindow.ShortcutWndAPI'.static.RequestAutomaticUseItemActivateAll(!bActivateAll);
			break;
		case "WinMin_Button":
			nMinimal = 1;
			SetINIBool("AutoUseItemWnd", "l", numToBool(nMinimal), "windowsInfo.ini");
			Me.HideWindow();
			ShowWindowWithFocus("AutoUseItemWndMin");
			getInstanceL2Util().syncWindowLoc("AutoUseItemWnd", "AutoUseItemWndMin", 115, 98);
			getInstanceL2Util().fixWindowLocOverResolution("AutoUseItemWndMin");
			break;
		case "MacroWnd_Button":
			ExecuteEvent(1230);
			break;
		case "ShotD_Target_BTN":
			Autotarget_OnSwap_Target_BTNClick();
			if(autotarget_bUseAutoTarget)
			{
				requestAutoPlay(autotarget_bUseAutoTarget);
			}
			break;
		case "TargetPickupToggle_BTN":
			Autotarget_TargetPickupToggle_BTNClick();
			if(autotarget_bUseAutoTarget)
			{
				requestAutoPlay(autotarget_bUseAutoTarget);
			}
			break;
		case "TargetMannerToggle_BTN":
			Autotarget_TargetMannerToggle_BTNClick();
			if(autotarget_bUseAutoTarget)
			{
				requestAutoPlay(autotarget_bUseAutoTarget);
			}
			break;
		case "AutoTargetAll_BTN":
			requestAutoPlay(!autotarget_bUseAutoTarget);
			break;
		case "Next_Target_BTN":
			Autotarget_OnNext_Target_BTNClick();
			break;
		case "MacroSelectBtn_01":
		case "MacroSelectBtn_02":
			MacroSelectBtn_Click(Name);
			SetMacroSlotSelect();
			if(((Name == "MacroSelectBtn_01") || (Name == "MacroSelectBtn_02")))
			{
				Debug("-_-");
				requestAutoPlay(false);
			}
			break;
		default:
			break;
	}
	return;
}

function MacroSelectBtn_Click(string Name)
{
	if((Name == "MacroSelectBtn_01"))
	{
		GetMeWindow("AutoTargetWnd.Macro1ShortcutItem").ShowWindow();
		GetMeWindow("AutoTargetWnd.Macro2ShortcutItem").HideWindow();
		SetINIInt("AutoUseItemWnd", "v", 0, "windowsInfo.ini");
		nMacroSlotSelect = 0;
	}
	else
	{
		GetMeWindow("AutoTargetWnd.Macro1ShortcutItem").HideWindow();
		GetMeWindow("AutoTargetWnd.Macro2ShortcutItem").ShowWindow();
		SetINIInt("AutoUseItemWnd", "v", 1, "windowsInfo.ini");
		nMacroSlotSelect = 1;
	}
	return;
}

function Autotarget_OnNext_Target_BTNClick()
{
	local string strParam;
	local int targetMode;

	strParam = "";
	switch(GetOptionInt("CommunIcation", "NextTargetMode"))
	{
		case 0:
			targetMode = 1;
			break;
		case 1:
			targetMode = 2;
			break;
		case 2:
			targetMode = 3;
			break;
		case 3:
			targetMode = 0;
			break;
		default:
			break;
	}
	SetOptionInt("Communication", "NextTargetMode", targetMode);
	ParamAdd(strParam, "NextTargetMode", string(targetMode));
	ExecuteEvent(11030, strParam);
	Autotarget_NextTargetSetCusomTooltip();
	return;
}

function Autotarget_NextTargetSetCusomTooltip()
{
	local int N;
	local Color b0, b1, b2, b3;
	local array<DrawItemInfo> drawListArr;
	local string toolString;

	b0 = getInstanceL2Util().Gray;
	b1 = getInstanceL2Util().Gray;
	b2 = getInstanceL2Util().Gray;
	b3 = getInstanceL2Util().Gray;
	Next_Target_BTN.ClearTooltip();
	Next_Target_BTN.SetTooltipType("text");
	N = GetOptionInt("Communication", "NextTargetMode");
	if((N == 0))
	{
		b0 = getInstanceL2Util().Yellow;
	}
	else if((N == 1))
	{
		b1 = getInstanceL2Util().Yellow;
	}
	else if((N == 2))
	{
		b2 = getInstanceL2Util().Yellow;
	}
	else if((N == 3))
	{
		b3 = getInstanceL2Util().Yellow;
	}
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(3862), b0, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(3863), b1, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(3864), b2, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(3865), b3, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	toolString = MenuEntireWnd(GetScript("MenuEntireWnd")).setMainShortcutString(MenuEntireWnd(GetScript("MenuEntireWnd")).getAssignedKeyGroup(), "NextTargetModeChange");
	drawListArr[drawListArr.Length] = addDrawItemText(toolString, getInstanceL2Util().White, "", true, true);
	Next_Target_BTN.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
	return;
}

function onInventory_ButtonClick()
{
	if(GetWindowHandle("AutoUseItemInventory").IsShowWindow())
	{
		GetWindowHandle("AutoUseItemInventory").HideWindow();
	}
	else
	{
		AutoUseItemInventoryScript.showWindowByParentWindow(Me);
	}
	return;
}

function forceShowInven()
{
	AutoUseItemInventoryScript.showWindowByParentWindow(Me);
	return;
}

function OnHide()
{
	if(GetWindowHandle("AutoUseItemInventory").IsShowWindow())
	{
		GetWindowHandle("AutoUseItemInventory").HideWindow();
	}
	return;
}

function AutotargetOnShow()
{
	local int nLongTarget, nIsPickupOn, nIsMannerModeOn;

	if(getInstanceUIData().GetIsClassicServer())
	{
		Me.HideWindow();
		return;
	}
	if(!GetINIBool("AutoUseItemWnd", "a", nLongTarget, "windowsInfo.ini"))
	{
		nLongTarget = 1;
		SetINIBool("AutoUseItemWnd", "a", numToBool(nLongTarget), "windowsInfo.ini");
	}
	if(!GetINIBool("AutoUseItemWnd", "e", nIsPickupOn, "windowsInfo.ini"))
	{
		nIsPickupOn = 1;
		SetINIBool("AutoUseItemWnd", "e", numToBool(nIsPickupOn), "windowsInfo.ini");
	}
	if(!GetINIBool("AutoUseItemWnd", "p", nIsMannerModeOn, "windowsInfo.ini"))
	{
		nIsMannerModeOn = 1;
		SetINIBool("AutoUseItemWnd", "p", numToBool(nIsMannerModeOn), "windowsInfo.ini");
	}
	GetINIInt("AutoUseItemWnd", "v", nMacroSlotSelect, "windowsInfo.ini");
	autotarget_bIsPickupOn = numToBool(nIsPickupOn);
	autotarget_bShortTarget = !numToBool(nLongTarget);
	autotarget_bIsMannerModeOn = numToBool(nIsMannerModeOn);
	Autotarget_updateShowHideNextTargetButton();
	Autotarget_SetCusomTooltip();
	Autotarget_NextTargetSetCusomTooltip();
	SetMacroSlotSelect();
	return;
}

function SetMacroSlotSelect()
{
	if((nMacroSlotSelect == 0))
	{
		MacroSelectBtn_01.SetTexture("L2UI_CT1.AutoShotItemWnd.MacroSelectBtn", "L2UI_CT1.AutoShotItemWnd.MacroSelectBTN_normal", "L2UI_CT1.AutoShotItemWnd.MacroSelectBTN_over");
		MacroSelectBtn_02.SetTexture("L2UI_CT1.AutoShotItemWnd.MacroSelectBTN_normal", "L2UI_CT1.AutoShotItemWnd.MacroSelectBTN_normal", "L2UI_CT1.AutoShotItemWnd.MacroSelectBTN_over");
		MacroSelectBtn_Click("MacroSelectBtn_01");
	}
	else
	{
		MacroSelectBtn_01.SetTexture("L2UI_CT1.AutoShotItemWnd.MacroSelectBTN_normal", "L2UI_CT1.AutoShotItemWnd.MacroSelectBTN_normal", "L2UI_CT1.AutoShotItemWnd.MacroSelectBTN_over");
		MacroSelectBtn_02.SetTexture("L2UI_CT1.AutoShotItemWnd.MacroSelectBtn", "L2UI_CT1.AutoShotItemWnd.MacroSelectBTN_normal", "L2UI_CT1.AutoShotItemWnd.MacroSelectBTN_over");
		MacroSelectBtn_Click("MacroSelectBtn_02");
	}
	return;
}

function Autotarget_Init()
{
	autotarget_bUseAutoTarget = false;
	return;
}

function Autotarget_UpdateShortCutElement()
{
	Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("AutoUseItemWnd.AutoTargetWnd.Macro1ShortcutItem", 276);
	Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("AutoUseItemWnd.AutoTargetWnd.Macro2ShortcutItem", 279);
	return;
}

function executeTarget()
{
	if(autotarget_bShortTarget)
	{
		ExecuteCommand("/targetnext");
	}
	else
	{
		ExecuteCommand("/targetnext2");
	}
	return;
}

function Autotarget_SetCusomTooltip()
{
	local Color b0, b1;
	local array<DrawItemInfo> drawListArr;

	b0 = getInstanceL2Util().Gray;
	b1 = getInstanceL2Util().Gray;
	shotD_Target_BTN.ClearTooltip();
	shotD_Target_BTN.SetTooltipType("text");
	if(autotarget_bShortTarget)
	{
		b0 = getInstanceL2Util().Yellow;
	}
	else
	{
		b1 = getInstanceL2Util().Yellow;
	}
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(3956), b0, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(3957), b1, "", true, true);
	shotD_Target_BTN.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
	return;
}

function Autotarget_PickupSetCusomTooltip()
{
	local Color b0, b1;
	local array<DrawItemInfo> drawListArr;

	b0 = getInstanceL2Util().Gray;
	b1 = getInstanceL2Util().Gray;
	TargetPickupToggle_BTN.ClearTooltip();
	TargetPickupToggle_BTN.SetTooltipType("text");
	if(autotarget_bIsPickupOn)
	{
		b0 = getInstanceL2Util().Yellow;
	}
	else
	{
		b1 = getInstanceL2Util().Yellow;
	}
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(3993), b0, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(3992), b1, "", true, true);
	TargetPickupToggle_BTN.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
	return;
}

function Autotarget_MannerModeSetCusomTooltip()
{
	local Color b0, b1;
	local array<DrawItemInfo> drawListArr;

	b0 = getInstanceL2Util().Gray;
	b1 = getInstanceL2Util().Gray;
	TargetMannerToggle_BTN.ClearTooltip();
	TargetMannerToggle_BTN.SetTooltipType("text");
	if(autotarget_bIsMannerModeOn)
	{
		b0 = getInstanceL2Util().Yellow;
	}
	else
	{
		b1 = getInstanceL2Util().Yellow;
	}
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13080), b0, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13081), b1, "", true, true);
	TargetMannerToggle_BTN.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
	return;
}

function OnRButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	switch(a_WindowHandle.GetWindowName())
	{
		case "AutoTargetAll_BTN":
			requestAutoPlay(!autotarget_bUseAutoTarget);
			break;
		case "AutoAll_BTN":
			OnClickButton(a_WindowHandle.GetWindowName());
			break;
		default:
			break;
	}
	return;
}

function bool getUseAutoTarget()
{
	return autotarget_bUseAutoTarget;
}

function Autotarget_OnSwap_Target_BTNClick()
{
	autotarget_bShortTarget = !autotarget_bShortTarget;
	SetINIBool("AutoUseItemWnd", "a", !autotarget_bShortTarget, "windowsInfo.ini");
	if(autotarget_bShortTarget)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemString(3956));
	}
	else
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemString(3957));
	}
	Autotarget_updateShowHideNextTargetButton();
	Autotarget_SetCusomTooltip();
	return;
}

function Autotarget_TargetMannerToggle_BTNClick()
{
	autotarget_bIsMannerModeOn = !autotarget_bIsMannerModeOn;
	SetINIBool("AutoUseItemWnd", "p", autotarget_bIsMannerModeOn, "windowsInfo.ini");
	if(autotarget_bIsMannerModeOn)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemString(13080));
	}
	else
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemString(13081));
	}
	Autotarget_updateMannerModeButton();
	Autotarget_MannerModeSetCusomTooltip();
	return;
}

function Autotarget_TargetPickupToggle_BTNClick()
{
	autotarget_bIsPickupOn = !autotarget_bIsPickupOn;
	SetINIBool("AutoUseItemWnd", "e", autotarget_bIsPickupOn, "windowsInfo.ini");
	if(autotarget_bIsPickupOn)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemString(3993));
	}
	else
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemString(3992));
	}
	Autotarget_updatePickupButton();
	Autotarget_PickupSetCusomTooltip();
	return;
}

function Autotarget_updateShowHideNextTargetButton()
{
	if(autotarget_bShortTarget)
	{
		shotD_Target_BTN.SetTexture("l2UI_CT1.AutoShotItemWnd.TargetBTN_ShotD_Normal", "l2UI_CT1.AutoShotItemWnd.TargetBTN_ShotD_Down", "l2UI_CT1.AutoShotItemWnd.TargetBTN_ShotD_Over");
	}
	else
	{
		shotD_Target_BTN.SetTexture("l2UI_CT1.AutoShotItemWnd.TargetBTN_LongD_Normal", "l2UI_CT1.AutoShotItemWnd.TargetBTN_LongD_Down", "l2UI_CT1.AutoShotItemWnd.TargetBTN_LongD_Over");
	}
	return;
}

function Autotarget_updatePickupButton()
{
	if(autotarget_bIsPickupOn)
	{
		TargetPickupToggle_BTN.SetTexture("L2UI_CT1.AutoShotItemWnd.GetBTNON_Normal", "L2UI_CT1.AutoShotItemWnd.GetBTNON_Down", "L2UI_CT1.AutoShotItemWnd.GetBTNON_Over");
	}
	else
	{
		TargetPickupToggle_BTN.SetTexture("L2UI_CT1.AutoShotItemWnd.GetBTNOff_Normal", "L2UI_CT1.AutoShotItemWnd.GetBTNOff_down", "L2UI_CT1.AutoShotItemWnd.GetBTNOff_Over");
	}
	return;
}

function Autotarget_updateMannerModeButton()
{
	if(autotarget_bIsMannerModeOn)
	{
		TargetMannerToggle_BTN.SetTexture("L2UI_CT1.AutoShotItemWnd.MannerBTNON_Normal", "L2UI_CT1.AutoShotItemWnd.MannerBTNON_down", "L2UI_CT1.AutoShotItemWnd.MannerBTNON_over");
	}
	else
	{
		TargetMannerToggle_BTN.SetTexture("L2UI_CT1.AutoShotItemWnd.MannerBTNOff_Normal", "L2UI_CT1.AutoShotItemWnd.MannerBTNOff_down", "L2UI_CT1.AutoShotItemWnd.MannerBTNOff_over");
	}
	return;
}

function Autotarget_UpdateAutoTargetState()
{
	if(autotarget_bUseAutoTarget)
	{
		AnimTexturePlay(AutoTarget_ToggleMacro_Anim, true);
		AnimTexturePlay(AutoTargetAllON_ToggleEffect_Anim, true);
		GetWindowHandle("AutoUseItemWnd.AutoTargetWnd.AutoTargetAllON_Win").ShowWindow();
		GetWindowHandle("AutoUseItemWnd.AutoTargetWnd.AutoTargetAllOFF_Win").HideWindow();
	}
	else
	{
		AnimTextureStop(AutoTarget_ToggleMacro_Anim, true);
		AnimTextureStop(AutoTargetAllON_ToggleEffect_Anim, true);
		GetWindowHandle("AutoUseItemWnd.AutoTargetWnd.AutoTargetAllON_Win").HideWindow();
		GetWindowHandle("AutoUseItemWnd.AutoTargetWnd.AutoTargetAllOFF_Win").ShowWindow();
	}
	AutoUseItemWndMinScript.setPlayAutoTargetActiveAnim();
	YetiQuickSlotwndScript.setPlayAutoTargetActiveAnim();
	return;
}

function requestAutoPlay(bool bUseAutoTarget, optional int nHPPotionPercent)
{
	local AutoplaySettingData pAutoplaySettingData;

	autotarget_nTargetMode = GetNextTargetModeOption();
	pAutoplaySettingData.IsAutoPlayOn = bUseAutoTarget;
	pAutoplaySettingData.IsPickupOn = autotarget_bIsPickupOn;
	pAutoplaySettingData.NextTargetMode = EAutoNextTargetMode(autotarget_nTargetMode);
	pAutoplaySettingData.IsNearTargetMode = autotarget_bShortTarget;
	pAutoplaySettingData.IsMannerModeOn = autotarget_bIsMannerModeOn;
	pAutoplaySettingData.MacroIndex = byte(nMacroSlotSelect);
	if((nHPPotionPercent > 0))
	{
		pAutoplaySettingData.HPPotionPercent = nHPPotionPercent;
	}
	else
	{
		pAutoplaySettingData.HPPotionPercent = autotarget_nHPPotionPercent;
	}
	Debug("------------------------------------------------------------------");
	Debug("API -각성-- UpdateAutoplaySetting()");  // EN?: API - Awakening-- UpdateAutoplaySetting ()
	Debug(("bUseAutoTarget               : " @ string(bUseAutoTarget)));
	Debug(("autotarget_bIsPickupOn       : " @ string(autotarget_bIsPickupOn)));
	Debug(("autotarget_bIsMannerModeOn    : " @ string(autotarget_bIsMannerModeOn)));
	Debug(("autotarget_nTargetMode       : " @ string(autotarget_nTargetMode)));
	Debug(("autotarget_bShortTarget      : " @ string(autotarget_bShortTarget)));
	Debug(("MacroIndex  : " @ string(nMacroSlotSelect)));
	Debug(("autotarget_nHPPotionPercent  : " @ string(pAutoplaySettingData.HPPotionPercent)));
	UpdateAutoplaySetting(pAutoplaySettingData);
	return;
}

function requestAutoPlayForAutoPotion(int nHPPotionPercent)
{
	requestAutoPlay(autotarget_bUseAutoTarget, nHPPotionPercent);
	return;
}

function setShortcutTooltip(string tooltipStr)
{
	GetButtonHandle("AutoUseItemWnd.AutoTargetWnd.AutoTargetAll_BTN").SetTooltipCustomType(MakeTooltipMultiText(GetSystemString(2165), getInstanceL2Util().White, , true, tooltipStr, getInstanceL2Util().BWhite, , true));
	return;
}

function HandleUpdatePlayerAutoAttacking()
{
	if(API_IsAutoAttacking())
	{
		GetTextureHandle("AutoUseItemWnd.AutoTargetWnd.AutoTargetAllON_Win.AutoAllIcon_On_texture").SetTexture("L2UI_CT1.AutoShotItemWnd.AutoTargetFight_On");
		GetTextureHandle("AutoUseItemWnd.AutoTargetWnd.AutoTargetAllOFF_Win.AutoAllIcon_Off_texture").SetTexture("L2UI_CT1.AutoShotItemWnd.AutoTargetFight_Off");
	}
	else
	{
		GetTextureHandle("AutoUseItemWnd.AutoTargetWnd.AutoTargetAllON_Win.AutoAllIcon_On_texture").SetTexture("L2UI_CT1.AutoShotItemWnd.AutoTargetAllIcon_On");
		GetTextureHandle("AutoUseItemWnd.AutoTargetWnd.AutoTargetAllOFF_Win.AutoAllIcon_Off_texture").SetTexture("L2UI_CT1.AutoShotItemWnd.AutoTargetAllIcon_Off");
	}
	return;
}

function bool API_IsAutoAttacking()
{
	return Class'NWindow.UIDATA_PLAYER'.static.IsAutoAttacking();
}
