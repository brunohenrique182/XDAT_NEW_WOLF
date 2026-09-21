class HennaEngraveWndLive extends UICommonAPI
	dependson(UIPacket);

const FeeItemID = 80762;
const ENCHANT_MOTION_TIME = 400;
const ENCHANT_DELAY_TIME = 300;

var WindowHandle Me;
var WindowHandle disableWnd;
var WindowHandle ResetWnd;
var ButtonHandle PopupReset_btn;
var ButtonHandle ResetOk_btn;
var ButtonHandle ResetCancle_btn;
var WindowHandle HiddenEnchantWnd;
var ButtonHandle HiddenEnchant_btn;
var TextBoxHandle HiddenEnchantTitle_txt;
var ButtonHandle HiddenEnchantClose01_btn;
var ButtonHandle HiddenEnchantClose02_btn;
var TextBoxHandle HiddenEnchantDesc01_txt;
var TextBoxHandle HiddenEnchantDesc02_txt;
var ItemWindowHandle HiddenEnchant_itemwindow;
var EffectViewportWndHandle HiddenEnchantEffectViewport;
var WindowHandle EnchantWnd;
var TextBoxHandle EnchantDesc01_txt;
var TextBoxHandle EnchantLeftEchantNum_txt;
var ButtonHandle popupEnchant_btn;
var ButtonHandle popupAutoEnchant_btn;
var ButtonHandle Enchant_Btn;
var ButtonHandle AutoEnchantClose_btn;
var ButtonHandle EnchantStop_btn;
var TextBoxHandle EnchantTitle_txt;
var ButtonHandle EnchantClose_btn;
var TextBoxHandle EnchantDesc02_txt;
var ItemWindowHandle Enchant_itemwindow;
var EffectViewportWndHandle EnchantEffectViewport;
var StatusBarHandle EngraveEffectStatus;
var ButtonHandle EngraveEffect_btn;
var ButtonHandle HiddenSkill_btn;
var ButtonHandle SkillList_btn;
var ItemWindowHandle HiddenSkill_itemwindow;
var ItemWindowHandle HennaSkill_itemwindow;
var TextBoxHandle HennaSkillDesc01Num_txt;
var TextBoxHandle HennaSkillDesc02Num_txt;
var EffectViewportWndHandle HiddenSkillEnableEffectViewport;
var RichListCtrlHandle NeedItemListWnd;
var UIControlNeedItemList NeedItemListWndScript;
var UIControlNeedItemList ResetNeedItemRichListCtrlScript;
var UIControlNeedItemList ResetPayBackItemRichListCtrlScript;
var UIControlNeedItemList HiddenEnchantNeedItemListCtrlScript;
var UIControlNeedItemList EnchantNeedItemRichListCtrlScript;
var UIControlGroupButtons sideGroupButtons;
var UIControlGroupButtons topGroupButtons;
var HennaGaugeWnd HennaGaugeWndScript;
var HennaGaugeWnd HennaGaugeWndPopupScript;
var UIPacket._S_EX_DYEEFFECT_LIST PACKET_DYEEFFECT_LIST;
var string m_Windowname;
var string currentSkillProbStr;
var string currentHiddenSkillProbStr;
var L2UITimerObject timeObjectHiddenEnchantingDelay;
var L2UITimerObject timeObjectEnchantingDelay;
var L2UITimerObject timeObjectAutoEnchantDelay;
var L2UITimerObject timeObjectInventoryDelay;
var bool bIsEnchanting;
var bool bIsHiddenEnchanting;
var bool bAutoEnchant;
var int nRemainTryEnchant;
var bool pressAutoEnchantStop;
var bool bBeforeSuccessEnchant;
var INT64 feeItemNum;
var float feePer;
var int nCurrentLevel;

function OnRegisterEvent()
{
	RegisterEvent(180);
	RegisterEvent(2600);
	RegisterEvent(2610);
	RegisterEvent((100000 + 1184));
	RegisterEvent((100000 + 1185));
	RegisterEvent((100000 + 1186));
	RegisterEvent((100000 + 1187));
	RegisterEvent((100000 + 1188));
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	Load();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("HennaEngraveWndLive");
	disableWnd = GetWindowHandle("HennaEngraveWndLive.DisableWnd");
	ResetWnd = GetWindowHandle("HennaEngraveWndLive.DisableWnd.ResetWnd");
	ResetOk_btn = GetButtonHandle("HennaEngraveWndLive.DisableWnd.ResetWnd.ResetOk_btn");
	ResetCancle_btn = GetButtonHandle("HennaEngraveWndLive.DisableWnd.ResetWnd.ResetCancle_btn");
	HiddenEnchantWnd = GetWindowHandle("HennaEngraveWndLive.DisableWnd.HiddenEnchantWnd");
	HiddenEnchantTitle_txt = GetTextBoxHandle("HennaEngraveWndLive.DisableWnd.HiddenEnchantWnd.HiddenEnchantTitle_txt");
	HiddenEnchant_btn = GetButtonHandle("HennaEngraveWndLive.DisableWnd.HiddenEnchantWnd.HiddenEnchant_btn");
	HiddenEnchantClose01_btn = GetButtonHandle("HennaEngraveWndLive.DisableWnd.HiddenEnchantWnd.HiddenEnchantClose01_btn");
	HiddenEnchantClose02_btn = GetButtonHandle("HennaEngraveWndLive.DisableWnd.HiddenEnchantWnd.HiddenEnchantClose02_btn");
	HiddenEnchantDesc01_txt = GetTextBoxHandle("HennaEngraveWndLive.DisableWnd.HiddenEnchantWnd.HiddenEnchantDesc01_txt");
	HiddenEnchantDesc02_txt = GetTextBoxHandle("HennaEngraveWndLive.DisableWnd.HiddenEnchantWnd.HiddenEnchantDesc02_txt");
	HiddenEnchant_itemwindow = GetItemWindowHandle("HennaEngraveWndLive.DisableWnd.HiddenEnchantWnd.HiddenEnchant_itemwindow");
	HiddenEnchantEffectViewport = GetEffectViewportWndHandle("HennaEngraveWndLive.DisableWnd.HiddenEnchantWnd.HiddenEnchantEffectViewport");
	EnchantWnd = GetWindowHandle("HennaEngraveWndLive.DisableWnd.EnchantWnd");
	EnchantDesc01_txt = GetTextBoxHandle("HennaEngraveWndLive.DisableWnd.EnchantWnd.EnchantDesc01_txt");
	EnchantDesc02_txt = GetTextBoxHandle("HennaEngraveWndLive.DisableWnd.EnchantWnd.EnchantDesc02_txt");
	EnchantLeftEchantNum_txt = GetTextBoxHandle("HennaEngraveWndLive.DisableWnd.EnchantWnd.EnchantLeftEchantNum_txt");
	Enchant_Btn = GetButtonHandle("HennaEngraveWndLive.DisableWnd.EnchantWnd.Enchant_btn");
	EnchantTitle_txt = GetTextBoxHandle("HennaEngraveWndLive.DisableWnd.EnchantWnd.EnchantTitle_txt");
	AutoEnchantClose_btn = GetButtonHandle("HennaEngraveWndLive.DisableWnd.EnchantWnd.AutoEnchantClose_btn");
	EnchantStop_btn = GetButtonHandle("HennaEngraveWndLive.DisableWnd.EnchantWnd.EnchantStop_btn");
	EnchantClose_btn = GetButtonHandle("HennaEngraveWndLive.DisableWnd.EnchantWnd.EnchantClose_btn");
	popupEnchant_btn = GetButtonHandle("HennaEngraveWndLive.popupEnchant_btn");
	popupAutoEnchant_btn = GetButtonHandle("HennaEngraveWndLive.popupAutoEnchant_btn");
	PopupReset_btn = GetButtonHandle("HennaEngraveWndLive.PopupReset_btn");
	Enchant_itemwindow = GetItemWindowHandle("HennaEngraveWndLive.DisableWnd.EnchantWnd.Enchant_itemwindow");
	EnchantEffectViewport = GetEffectViewportWndHandle("HennaEngraveWndLive.DisableWnd.EnchantWnd.EnchantEffectViewport");
	EngraveEffectStatus = GetStatusBarHandle("HennaEngraveWndLive.EngraveEffectStatus");
	EngraveEffect_btn = GetButtonHandle("HennaEngraveWndLive.EngraveEffect_btn");
	HiddenSkill_btn = GetButtonHandle("HennaEngraveWndLive.HiddenSkill_btn");
	SkillList_btn = GetButtonHandle("HennaEngraveWndLive.SkillList_btn");
	HiddenSkill_itemwindow = GetItemWindowHandle("HennaEngraveWndLive.HiddenSkill_itemwindow");
	HennaSkill_itemwindow = GetItemWindowHandle("HennaEngraveWndLive.HennaSkill_itemwindow");
	HennaSkillDesc01Num_txt = GetTextBoxHandle("HennaEngraveWndLive.HennaSkillDesc01Num_txt");
	HennaSkillDesc02Num_txt = GetTextBoxHandle("HennaEngraveWndLive.HennaSkillDesc02Num_txt");
	HiddenSkillEnableEffectViewport = GetEffectViewportWndHandle("HennaEngraveWndLive.HiddenSkillEnableEffectViewport");
	timeObjectHiddenEnchantingDelay = Class'Interface.L2UITimer'.static.Inst()._MakeTimerObject(400, 1);
	timeObjectHiddenEnchantingDelay._DelegateOnTime = onTimeObjectHiddenEnchantingDelay;
	timeObjectEnchantingDelay = Class'Interface.L2UITimer'.static.Inst()._MakeTimerObject(400, 1);
	timeObjectEnchantingDelay._DelegateOnTime = onTimeObjectEnchantingDelay;
	timeObjectAutoEnchantDelay = Class'Interface.L2UITimer'.static.Inst()._MakeTimerObject(300, 1);
	timeObjectAutoEnchantDelay._DelegateOnTime = onTimeObjectAutoEnchantDelay;
	timeObjectInventoryDelay = Class'Interface.L2UITimer'.static.Inst()._MakeTimerObject(1, 1);
	timeObjectInventoryDelay._DelegateOnTime = onTimeObjectInventoryDelay;
	HiddenEnchant_itemwindow.SetDisableTex("L2UI_CT1.ItemWindow.ItemWindow_IconDisable");
	Enchant_itemwindow.SetDisableTex("L2UI_CT1.ItemWindow.ItemWindow_IconDisable");
	HiddenSkill_itemwindow.SetDisableTex("L2UI_CT1.ItemWindow.ItemWindow_IconDisable");
	HennaSkill_itemwindow.SetDisableTex("L2UI_CT1.ItemWindow.ItemWindow_IconDisable");
	GetItemWindowHandle("HennaEngraveWndLive.Category00_wnd.Category00HennaSkill_itemwindow").SetDisableTex("L2UI_CT1.ItemWindow.ItemWindow_IconDisable");
	GetItemWindowHandle("HennaEngraveWndLive.Category01_wnd.Category01HennaSkill_itemwindow").SetDisableTex("L2UI_CT1.ItemWindow.ItemWindow_IconDisable");
	GetItemWindowHandle("HennaEngraveWndLive.Category02_wnd.Category02HennaSkill_itemwindow").SetDisableTex("L2UI_CT1.ItemWindow.ItemWindow_IconDisable");
	GetItemWindowHandle("HennaEngraveWndLive.Category00_wnd.Category00HiddenSkill_itemwindow").SetDisableTex("L2UI_CT1.ItemWindow.ItemWindow_IconDisable");
	GetItemWindowHandle("HennaEngraveWndLive.Category01_wnd.Category01HiddenSkill_itemwindow").SetDisableTex("L2UI_CT1.ItemWindow.ItemWindow_IconDisable");
	GetItemWindowHandle("HennaEngraveWndLive.Category02_wnd.Category02HiddenSkill_itemwindow").SetDisableTex("L2UI_CT1.ItemWindow.ItemWindow_IconDisable");
	disableWnd.HideWindow();
	ResetWnd.HideWindow();
	EnchantWnd.HideWindow();
	HiddenEnchantWnd.HideWindow();
	return;
}

function onTimeObjectInventoryDelay(int Count)
{
	RefreshMainScreen(false);
	if(((bBeforeSuccessEnchant == false) && (pressAutoEnchantStop == false)))
	{
		if(bAutoEnchant)
		{
			runAutoEnchant();
		}
	}
	return;
}

function onTimeObjectAutoEnchantDelay(int Count)
{
	OnEnchant_BtnClick();
	return;
}

function onTimeObjectHiddenEnchantingDelay(int Count)
{
	local int nCategory, ntop;

	nCategory = sideGroupButtons._getSelectedButtonValue();
	ntop = topGroupButtons._getSelectedButtonValue();
	HiddenEnchant_btn.DisableWindow();
	HiddenEnchantEffectViewport.SpawnEffect("");
	API_C_EX_DYEEFFECT_ACQUIRE_HIDDENSKILL(nCategory, ntop);
	return;
}

function onTimeObjectEnchantingDelay(int Count)
{
	local int nCategory, ntop;

	nCategory = sideGroupButtons._getSelectedButtonValue();
	ntop = topGroupButtons._getSelectedButtonValue();
	Enchant_Btn.DisableWindow();
	EnchantEffectViewport.SpawnEffect("");
	API_C_EX_DYEEFFECT_ENCHANT_NORMALSKILL(nCategory, ntop);
	return;
}

function setTabSkill(int nButtonIndex, bool bHiddenSkillAlram, ItemInfo HennaSkillItemInfo, ItemInfo HiddenSkillItemInfo)
{
	GetItemWindowHandle((((("HennaEngraveWndLive.Category0" $ string(nButtonIndex)) $ "_wnd.Category0") $ string(nButtonIndex)) $ "HennaSkill_itemwindow")).Clear();
	if((HennaSkillItemInfo.Id.ClassID > 0))
	{
		GetItemWindowHandle((((("HennaEngraveWndLive.Category0" $ string(nButtonIndex)) $ "_wnd.Category0") $ string(nButtonIndex)) $ "HennaSkill_itemwindow")).AddItem(HennaSkillItemInfo);
	}
	GetItemWindowHandle((((("HennaEngraveWndLive.Category0" $ string(nButtonIndex)) $ "_wnd.Category0") $ string(nButtonIndex)) $ "HiddenSkill_itemwindow")).Clear();
	if((HiddenSkillItemInfo.Id.ClassID > 0))
	{
		GetTextureHandle((((("HennaEngraveWndLive.Category0" $ string(nButtonIndex)) $ "_wnd.Category0") $ string(nButtonIndex)) $ "HiddenSkillDisale_tex")).HideWindow();
		GetItemWindowHandle((((("HennaEngraveWndLive.Category0" $ string(nButtonIndex)) $ "_wnd.Category0") $ string(nButtonIndex)) $ "HiddenSkill_itemwindow")).AddItem(HiddenSkillItemInfo);
	}
	else
	{
		GetTextureHandle((((("HennaEngraveWndLive.Category0" $ string(nButtonIndex)) $ "_wnd.Category0") $ string(nButtonIndex)) $ "HiddenSkillDisale_tex")).ShowWindow();
	}
	if(bHiddenSkillAlram)
	{
		GetTextureHandle((((("HennaEngraveWndLive.Category0" $ string(nButtonIndex)) $ "_wnd.Category0") $ string(nButtonIndex)) $ "HiddenSkillAni_tex")).ShowWindow();
	}
	else
	{
		GetTextureHandle((((("HennaEngraveWndLive.Category0" $ string(nButtonIndex)) $ "_wnd.Category0") $ string(nButtonIndex)) $ "HiddenSkillAni_tex")).HideWindow();
	}
	return;
}

function Load()
{
	initUIControlGroupButtons();
	InitNeedItemList();
	HennaGaugeWndScript = Class'Interface.HennaGaugeWnd'.static._InitScript(GetMeWindow("GaugeWnd"));
	HennaGaugeWndScript.initPiece();
	HennaGaugeWndPopupScript = Class'Interface.HennaGaugeWnd'.static._InitScript(GetWindowHandle("DisableWnd.EnchantWnd.EnchantGaugeWnd"));
	HennaGaugeWndPopupScript.initPiece();
	RefreshleftCategoryMenu();
	return;
}

function RefreshleftCategoryMenu()
{
	local int i, N;
	local DyeEffectUIData oDyeEffectUIData;
	local bool bMenuShow;

	i = 1;
	while((i <= 10))
	{
		N = 1;
		while((N <= 3))
		{
			bMenuShow = Class'NWindow.UIDATA_HENNA'.static.GetDyeEffectUIData(byte(i), byte(N), 1, oDyeEffectUIData);
			if(bMenuShow)
			{
				GetMeButton(("SideBtn0" $ string((i - 1)))).ShowWindow();
				GetMeButton(("SideBtn0" $ string((i - 1)))).SetNameText(getCategoryName(i));
				N++;
				continue;
			}
			break;
			N++;
		}
		if((bMenuShow == false))
		{
			GetMeButton(("SideBtn0" $ string((i - 1)))).HideWindow();
		}
		i++;
	}
	return;
}

function OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	disableWnd.HideWindow();
	ResetWnd.HideWindow();
	EnchantWnd.HideWindow();
	HiddenEnchantWnd.HideWindow();
	SetFeeItem();
	SideBar(GetScript("SideBar")).ToggleByWindowName(getCurrentWindowName(string(self)), true);
	API_C_EX_DYEEFFECT_LIST();
	return;
}

function OnHide()
{
	if(GetWindowHandle("HennaSkillListWndLive").IsShowWindow())
	{
		GetWindowHandle("HennaSkillListWndLive").HideWindow();
	}
	SideBar(GetScript("SideBar")).ToggleByWindowName(getCurrentWindowName(string(self)), false);
	timeObjectAutoEnchantDelay._Stop();
	timeObjectEnchantingDelay._Stop();
	timeObjectHiddenEnchantingDelay._Stop();
	timeObjectInventoryDelay._Stop();
	HennaGaugeWndScript.setHiddenSkill(0, false);
	HennaGaugeWndScript.setHiddenSkill(1, false);
	HennaGaugeWndScript.setHiddenSkill(2, false);
	HennaGaugeWndPopupScript.setHiddenSkill(0, false);
	HennaGaugeWndPopupScript.setHiddenSkill(1, false);
	HennaGaugeWndPopupScript.setHiddenSkill(2, false);
	HennaGaugeWndScript.initPiece();
	HennaGaugeWndPopupScript.initPiece();
	bIsEnchanting = false;
	bAutoEnchant = false;
	bBeforeSuccessEnchant = false;
	pressAutoEnchantStop = false;
	PACKET_DYEEFFECT_LIST.vDyeEffectInfoList.Length = 0;
	return;
}

function InitNeedItemList()
{
	NeedItemListWndScript = new Class'Interface.UIControlNeedItemList';
	NeedItemListWndScript.SetRichListControler(GetMeRichListCtrl("NeedItemListWnd.Cost_RichListCtrl"));
	EnchantNeedItemRichListCtrlScript = new Class'Interface.UIControlNeedItemList';
	EnchantNeedItemRichListCtrlScript.SetRichListControler(GetMeRichListCtrl("DisableWnd.EnchantWnd.EnchantNeedItemRichListCtrl"));
	ResetNeedItemRichListCtrlScript = new Class'Interface.UIControlNeedItemList';
	ResetNeedItemRichListCtrlScript.SetRichListControler(GetMeRichListCtrl("DisableWnd.ResetWnd.ResetNeedItemRichListCtrl"));
	ResetPayBackItemRichListCtrlScript = new Class'Interface.UIControlNeedItemList';
	ResetPayBackItemRichListCtrlScript.SetRichListControler(GetMeRichListCtrl("DisableWnd.ResetWnd.ResetPayBackItemRichListCtrl"));
	ResetPayBackItemRichListCtrlScript.SetHideMyNum(true);
	HiddenEnchantNeedItemListCtrlScript = new Class'Interface.UIControlNeedItemList';
	HiddenEnchantNeedItemListCtrlScript.SetRichListControler(GetMeRichListCtrl("DisableWnd.HiddenEnchantWnd.HiddenEnchantNeedItemListCtrl"));
	return;
}

function checkCanEnableButton()
{
	if((NeedItemListWndScript.GetCanBuy() && (nRemainTryEnchant > 0)))
	{
		Enchant_Btn.EnableWindow();
		popupEnchant_btn.EnableWindow();
		popupAutoEnchant_btn.EnableWindow();
	}
	else
	{
		Enchant_Btn.DisableWindow();
		popupEnchant_btn.DisableWindow();
		popupAutoEnchant_btn.DisableWindow();
		EnchantDesc02_txt.SetText(GetSystemString(3356));
	}
	if(HiddenEnchantNeedItemListCtrlScript.GetCanBuy())
	{
		HiddenEnchant_btn.EnableWindow();
	}
	else
	{
		HiddenEnchant_btn.DisableWindow();
	}
	if((nRemainTryEnchant == Class'NWindow.UIDATA_HENNA'.static.GetMaxTryDyeEnchant()))
	{
		PopupReset_btn.DisableWindow();
	}
	else
	{
		PopupReset_btn.EnableWindow();
	}
	return;
}

function initUIControlGroupButtons()
{
	sideGroupButtons = new Class'Interface.UIControlGroupButtons';
	sideGroupButtons._SetStartInfo("L2UI_CT1.Button.emptyBtn", "L2UI_NewTex.HennaWnd.HennaListBtn_Over", "L2UI_NewTex.HennaWnd.HennaListBtn_Down", true);
	sideGroupButtons._addButtonController(GetButtonHandle((m_Windowname $ ".SideBtn00")));
	sideGroupButtons._addButtonController(GetButtonHandle((m_Windowname $ ".SideBtn01")));
	sideGroupButtons._addButtonController(GetButtonHandle((m_Windowname $ ".SideBtn02")));
	sideGroupButtons._addButtonController(GetButtonHandle((m_Windowname $ ".SideBtn03")));
	sideGroupButtons._addButtonController(GetButtonHandle((m_Windowname $ ".SideBtn04")));
	sideGroupButtons._addButtonController(GetButtonHandle((m_Windowname $ ".SideBtn05")));
	sideGroupButtons._addButtonController(GetButtonHandle((m_Windowname $ ".SideBtn06")));
	sideGroupButtons._addButtonController(GetButtonHandle((m_Windowname $ ".SideBtn07")));
	sideGroupButtons._addButtonController(GetButtonHandle((m_Windowname $ ".SideBtn08")));
	sideGroupButtons._addButtonController(GetButtonHandle((m_Windowname $ ".SideBtn09")));
	sideGroupButtons._setButtonValue(0, 1);
	sideGroupButtons._setButtonValue(1, 2);
	sideGroupButtons._setButtonValue(2, 3);
	sideGroupButtons._setButtonValue(3, 4);
	sideGroupButtons._setButtonValue(4, 5);
	sideGroupButtons._setButtonValue(5, 6);
	sideGroupButtons._setButtonValue(6, 7);
	sideGroupButtons._setButtonValue(7, 8);
	sideGroupButtons._setButtonValue(8, 9);
	sideGroupButtons._setButtonValue(9, 10);
	sideGroupButtons.DelegateOnClickButton = sideGroupButtonOnClickButton;
	GetButtonHandle((m_Windowname $ ".SideBtn00")).SetTooltipType("text");
	GetButtonHandle((m_Windowname $ ".SideBtn01")).SetTooltipType("text");
	GetButtonHandle((m_Windowname $ ".SideBtn02")).SetTooltipType("text");
	GetButtonHandle((m_Windowname $ ".SideBtn03")).SetTooltipType("text");
	GetButtonHandle((m_Windowname $ ".SideBtn04")).SetTooltipType("text");
	GetButtonHandle((m_Windowname $ ".SideBtn05")).SetTooltipType("text");
	GetButtonHandle((m_Windowname $ ".SideBtn06")).SetTooltipType("text");
	GetButtonHandle((m_Windowname $ ".SideBtn07")).SetTooltipType("text");
	GetButtonHandle((m_Windowname $ ".SideBtn08")).SetTooltipType("text");
	GetButtonHandle((m_Windowname $ ".SideBtn09")).SetTooltipType("text");
	topGroupButtons = new Class'Interface.UIControlGroupButtons';
	topGroupButtons._SetStartInfo("L2UI_CT1.Button.emptyBtn", "L2UI_CT1.Button.emptyBtn", "L2UI_CT1.Button.emptyBtn", false);
	topGroupButtons._addButtonController(GetButtonHandle((m_Windowname $ ".Category00_wnd.Category00_btn")));
	topGroupButtons._addButtonController(GetButtonHandle((m_Windowname $ ".Category01_wnd.Category01_btn")));
	topGroupButtons._addButtonController(GetButtonHandle((m_Windowname $ ".Category02_wnd.Category02_btn")));
	topGroupButtons._setButtonValue(0, 1);
	topGroupButtons._setButtonValue(1, 2);
	topGroupButtons._setButtonValue(2, 3);
	topGroupButtons.DelegateOnClickButton = topGroupButtonOnClickButton;
	GetButtonHandle((m_Windowname $ ".Category00_wnd.Category00_btn")).SetTooltipType("text");
	GetButtonHandle((m_Windowname $ ".Category01_wnd.Category01_btn")).SetTooltipType("text");
	GetButtonHandle((m_Windowname $ ".Category02_wnd.Category02_btn")).SetTooltipType("text");
	return;
}

function sideGroupButtonOnClickButton(string parentWindowName, string strName, int i)
{
	if((topGroupButtons._getSelectButtonIndex() != 0))
	{
		topGroupButtons._setTopOrder(0);
	}
	else
	{
		RefreshMainScreen(true, true);
	}
	return;
}

function topGroupButtonOnClickButton(string parentWindowName, string strName, int i)
{
	GetMeTexture("Category00_wnd.Category00_tex").SetTexture("L2UI_NewTex.HennaWnd.TabBtn_Unselected");
	GetMeTexture("Category01_wnd.Category01_tex").SetTexture("L2UI_NewTex.HennaWnd.TabBtn_Unselected");
	GetMeTexture("Category02_wnd.Category02_tex").SetTexture("L2UI_NewTex.HennaWnd.TabBtn_Unselected");
	GetMeTexture((((("Category0" $ string(i)) $ "_wnd.Category0") $ string(i)) $ "_tex")).SetTexture("L2UI_NewTex.HennaWnd.TabBtn_Selected");
	RefreshMainScreen(true, true);
	return;
}

event OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	sideGroupButtons._selectButtonHandle(a_ButtonHandle);
	topGroupButtons._selectButtonHandle(a_ButtonHandle);
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "HiddenSkill_btn":
			OnHiddenSkill_btnClick();
			break;
		case "HiddenEnchant_btn":
			OnHiddenEnchant_btnClick();
			break;
		case "HiddenEnchantClose01_btn":
			OnHiddenEnchantClose01_btnClick();
			break;
		case "HiddenEnchantClose02_btn":
			OnHiddenEnchantClose02_btnClick();
			break;
		case "PopupEnchant_btn":
			OnPopupEnchant_btnClick();
			break;
		case "PopupAutoEnchant_btn":
			OnPopupAutoEnchant_btnClick();
			break;
		case "EngraveEffect_btn":
			OnEngraveEffect_btnClick();
			break;
		case "SkillList_btn":
			OnSkillList_btnClick();
			break;
		case "PopupReset_btn":
			OnPopupReset_btnClick();
			break;
		case "ResetOk_btn":
			OnResetOk_btnClick();
			break;
		case "ResetCancle_btn":
			OnResetCancle_btnClick();
			break;
		case "Enchant_btn":
			OnEnchant_BtnClick();
			break;
		case "EnchantStop_btn":
			OnEnchantStop_btnClick();
			break;
		case "EnchantClose_btn":
			OnEnchantClose_btnClick();
			break;
		case "AutoEnchantClose_btn":
			OnAutoEnchantClose_btnClick();
			break;
		default:
			break;
	}
	return;
}

function OnPopupEnchant_btnClick()
{
	bAutoEnchant = false;
	disableWnd.ShowWindow();
	ResetWnd.HideWindow();
	HiddenEnchantWnd.HideWindow();
	EnchantWnd.ShowWindow();
	timeObjectEnchantingDelay._Stop();
	Enchant_Btn.ShowWindow();
	Enchant_Btn.SetButtonName(5005);
	EnchantStop_btn.HideWindow();
	EnchantClose_btn.ShowWindow();
	AutoEnchantClose_btn.HideWindow();
	EnchantDesc02_txt.SetText(GetSystemString(14794));
	EnchantEffectViewport.SpawnEffect("");
	return;
}

function OnEnchant_BtnClick()
{
	if(bAutoEnchant)
	{
		if(bIsEnchanting)
		{
			bIsEnchanting = false;
			timeObjectEnchantingDelay._Stop();
			timeObjectAutoEnchantDelay._Stop();
			pressAutoEnchantStop = true;
			EnchantEffectViewport.SpawnEffect("");
			Enchant_Btn.ShowWindow();
			EnchantClose_btn.ShowWindow();
			EnchantStop_btn.HideWindow();
			EnchantDesc02_txt.SetText(GetSystemString(14798));
		}
		else
		{
			pressAutoEnchantStop = false;
			bIsEnchanting = true;
			EnchantEffectViewport.SpawnEffect("LineageEffect2.ui_spirit_lvup");
			PlaySound("InterfaceSound.MagicLamp_Start");
			timeObjectEnchantingDelay._Stop();
			timeObjectEnchantingDelay._Play();
			Enchant_Btn.HideWindow();
			EnchantClose_btn.HideWindow();
			EnchantStop_btn.ShowWindow();
			EnchantDesc02_txt.SetText(GetSystemString(14797));
		}
	}
	else if(bIsEnchanting)
	{
		bIsEnchanting = false;
		timeObjectEnchantingDelay._Stop();
		EnchantEffectViewport.SpawnEffect("");
		EnchantDesc02_txt.SetText(GetSystemString(14794));
		Enchant_Btn.SetButtonName(5005);
	}
	else
	{
		bIsEnchanting = true;
		EnchantEffectViewport.SpawnEffect("LineageEffect2.ui_spirit_lvup");
		PlaySound("InterfaceSound.MagicLamp_Start");
		timeObjectEnchantingDelay._Stop();
		timeObjectEnchantingDelay._Play();
		Enchant_Btn.SetButtonName(7049);
		EnchantDesc02_txt.SetText(GetSystemString(7035));
	}
	return;
}

function OnAutoEnchantClose_btnClick()
{
	OnEnchantClose_btnClick();
	return;
}

function OnEnchantClose_btnClick()
{
	bAutoEnchant = false;
	bIsEnchanting = false;
	pressAutoEnchantStop = false;
	timeObjectEnchantingDelay._Stop();
	timeObjectAutoEnchantDelay._Stop();
	EnchantEffectViewport.SpawnEffect("");
	disableWnd.HideWindow();
	ResetWnd.HideWindow();
	EnchantWnd.HideWindow();
	HiddenEnchantWnd.HideWindow();
	checkCanEnableButton();
	return;
}

function OnEnchantStop_btnClick()
{
	OnEnchant_BtnClick();
	return;
}

function OnHiddenSkill_btnClick()
{
	disableWnd.ShowWindow();
	ResetWnd.HideWindow();
	EnchantWnd.HideWindow();
	HiddenEnchantWnd.ShowWindow();
	bIsHiddenEnchanting = false;
	HiddenEnchant_btn.ShowWindow();
	HiddenEnchant_btn.SetButtonName(5005);
	HiddenEnchantDesc02_txt.SetText(GetSystemString(14794));
	timeObjectHiddenEnchantingDelay._Stop();
	if(HiddenEnchantNeedItemListCtrlScript.GetCanBuy())
	{
		HiddenEnchant_btn.EnableWindow();
	}
	else
	{
		HiddenEnchant_btn.DisableWindow();
	}
	HiddenEnchantClose01_btn.ShowWindow();
	HiddenEnchantClose02_btn.HideWindow();
	HiddenEnchantEffectViewport.SpawnEffect("");
	return;
}

function OnHiddenEnchant_btnClick()
{
	if(bIsHiddenEnchanting)
	{
		timeObjectHiddenEnchantingDelay._Stop();
		HiddenEnchantEffectViewport.SpawnEffect("");
		HiddenEnchant_btn.SetButtonName(5005);
		HiddenEnchant_btn.EnableWindow();
		bIsHiddenEnchanting = false;
	}
	else
	{
		timeObjectHiddenEnchantingDelay._Stop();
		timeObjectHiddenEnchantingDelay._Play();
		HiddenEnchant_btn.SetButtonName(7049);
		HiddenEnchantEffectViewport.SpawnEffect("LineageEffect.d_chainheal_ta");
		PlaySound("InterfaceSound.MagicLamp_Start");
		bIsHiddenEnchanting = true;
	}
	return;
}

function OnHiddenEnchantClose01_btnClick()
{
	disableWnd.HideWindow();
	ResetWnd.HideWindow();
	EnchantWnd.HideWindow();
	HiddenEnchantWnd.HideWindow();
	bIsHiddenEnchanting = false;
	timeObjectHiddenEnchantingDelay._Stop();
	HiddenEnchantEffectViewport.SpawnEffect("");
	checkCanEnableButton();
	return;
}

function OnHiddenEnchantClose02_btnClick()
{
	OnHiddenEnchantClose01_btnClick();
	return;
}

function OnPopupAutoEnchant_btnClick()
{
	bAutoEnchant = true;
	disableWnd.ShowWindow();
	ResetWnd.HideWindow();
	HiddenEnchantWnd.HideWindow();
	EnchantWnd.ShowWindow();
	timeObjectEnchantingDelay._Stop();
	Enchant_Btn.ShowWindow();
	Enchant_Btn.SetButtonName(14790);
	EnchantEffectViewport.SpawnEffect("");
	EnchantStop_btn.HideWindow();
	EnchantClose_btn.ShowWindow();
	AutoEnchantClose_btn.HideWindow();
	EnchantDesc02_txt.SetText(GetSystemString(14798));
	return;
}

function OnEngraveEffect_btnClick()
{
	local array<ItemInfo> infos;

	Class'NWindow.UIDATA_INVENTORY'.static.FindItemByClassID(80762, infos);
	if((infos.Length > 0))
	{
		RequestUseItem(infos[0].Id);
	}
	return;
}

function OnSkillList_btnClick()
{
	local int nCategory, ntop;

	toggleWindow("HennaSkillListWndLive", true, true);
	if(GetWindowHandle("HennaSkillListWndLive").IsShowWindow())
	{
		nCategory = sideGroupButtons._getSelectedButtonValue();
		ntop = topGroupButtons._getSelectedButtonValue();
		HennaSkillListWndLive(GetScript("HennaSkillListWndLive")).refresh(nCategory, ntop, nCurrentLevel);
	}
	return;
}

function OnPopupReset_btnClick()
{
	disableWnd.ShowWindow();
	ResetWnd.ShowWindow();
	EnchantWnd.HideWindow();
	HiddenEnchantWnd.HideWindow();
	if(ResetNeedItemRichListCtrlScript.GetCanBuy())
	{
		ResetOk_btn.EnableWindow();
	}
	else
	{
		ResetOk_btn.DisableWindow();
	}
	return;
}

function OnResetOk_btnClick()
{
	local int nCategory, ntop;

	if(((GetCanInventoryWeight() && GetCanInventoryNumLimit()) || (GetMeRichListCtrl("DisableWnd.ResetWnd.ResetPayBackItemRichListCtrl").IsShowWindow() == false)))
	{
		nCategory = sideGroupButtons._getSelectedButtonValue();
		ntop = topGroupButtons._getSelectedButtonValue();
		SetDisable(true);
		API_C_EX_DYEEFFECT_ENCHANT_RESET(nCategory, ntop);
	}
	else
	{
		AddSystemMessageMakeFullSystemMsg(14059);
	}
	return;
}

function OnResetCancle_btnClick()
{
	disableWnd.HideWindow();
	ResetWnd.HideWindow();
	EnchantWnd.HideWindow();
	HiddenEnchantWnd.HideWindow();
	checkCanEnableButton();
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 150:
			break;
		case 180:
			if(getInstanceUIData().GetIsLiveServer())
			{
				SetUserInfo();
			}
			break;
		case 2600:
		case 2610:
			if(GetWindowHandle("HennaEngraveWndLive").IsShowWindow())
			{
				handleinventoryUpdateResult(param);
			}
			break;
		case (100000 + 1184):
			ParsePacket_S_EX_DYEEFFECT_LIST();
			break;
		case (100000 + 1185):
			ParsePacket_S_EX_DYEEFFECT_ENCHANT_PROB_INFO();
			break;
		case (100000 + 1186):
			ParsePacket_S_EX_DYEEFFECT_ENCHANT_NORMALSKILL();
			break;
		case (100000 + 1187):
			ParsePacket_S_EX_DYEEFFECT_ACQUIRE_HIDDENSKILL();
			break;
		case (100000 + 1188):
			ParsePacket_S_EX_DYEEFFECT_ENCHANT_RESET();
			break;
		default:
			break;
	}
	return;
}

function ParsePacket_S_EX_DYEEFFECT_LIST()
{
	local int i;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_DYEEFFECT_LIST(PACKET_DYEEFFECT_LIST))
	{
		return;
	}
	Debug(("---> S_EX_DYEEFFECT_LIST" @ string(PACKET_DYEEFFECT_LIST.vDyeEffectInfoList.Length)));
	if((PACKET_DYEEFFECT_LIST.vDyeEffectInfoList.Length > 0))
	{
		i = 0;
		while((i < PACKET_DYEEFFECT_LIST.vDyeEffectInfoList.Length))
		{
			Debug("-------------------category-------------------------------");
			Debug(("nCategory" @ string(PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[i].nCategory)));
			Debug(("nSlotID" @ string(PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[i].nSlotID)));
			Debug(("nSlotLevel" @ string(PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[i].nSlotLevel)));
			Debug(("nSkillID" @ string(PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[i].nSkillID)));
			Debug(("nSkillLevel" @ string(PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[i].nSkillLevel)));
			Debug(("nHiddenSkillID" @ string(PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[i].nHiddenSkillID)));
			Debug(("nHiddenSkillLevel" @ string(PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[i].nHiddenSkillLevel)));
			Debug(("nChallengeCount" @ string(PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[i].nChallengeCount)));
			i++;
		}
	}
	sideGroupButtons._setTopOrder(0, true);
	topGroupButtons._setTopOrderForce(0);
	return;
}

function RefreshMainScreen(bool bRequestProb, optional bool bClickMenu)
{
	local array<SkillDefaultInfo> oSkills, oHiddenSkills;
	local int i, nHiddenSkillCount, nDyeLevel;
	local DyeEffectUIData oDyeEffectUIData, oCurrentDyeEffectUIData;
	local bool bShowHiddenSkill, bSkillIconDislable, bHiddenSkillCheck;
	local int nCategory, ntop;
	local ItemInfo skilItemInfo, hiddenSkilItemInfo;
	local int addHiddenSkillID, addHiddenSkillLevel;
	local bool bEnableHiddenSkill, bEnableHiddenSkillSkin, bAnim;
	local int nTabRemainTryEnchant;

	nCategory = sideGroupButtons._getSelectedButtonValue();
	ntop = topGroupButtons._getSelectedButtonValue();
	Class'NWindow.UIDATA_HENNA'.static.GetDyeEffectSkillList(byte(nCategory), byte(ntop), oSkills, oHiddenSkills);
	Debug("============ RefreshMainScreen ================");
	HennaGaugeWndScript.setHiddenSkill(0, false);
	HennaGaugeWndScript.setHiddenSkill(1, false);
	HennaGaugeWndScript.setHiddenSkill(2, false);
	HennaGaugeWndPopupScript.setHiddenSkill(0, false);
	HennaGaugeWndPopupScript.setHiddenSkill(1, false);
	HennaGaugeWndPopupScript.setHiddenSkill(2, false);
	if((PACKET_DYEEFFECT_LIST.vDyeEffectInfoList.Length > 0))
	{
		i = 0;
		while((i < PACKET_DYEEFFECT_LIST.vDyeEffectInfoList.Length))
		{
			if(((PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[i].nCategory == nCategory) && (PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[i].nSlotID == ntop)))
			{
				nDyeLevel = PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[i].nSlotLevel;
				nRemainTryEnchant = PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[i].nChallengeCount;
				if(((getFirstHiddenSkillIndex(nCategory, ntop) <= nDyeLevel) && !bClickMenu))
				{
					bEnableHiddenSkill = true;
				}
				if((getFirstHiddenSkillIndex(nCategory, ntop) <= nDyeLevel))
				{
					bEnableHiddenSkillSkin = true;
				}
				if((bBeforeSuccessEnchant && (bClickMenu == false)))
				{
					bAnim = true;
				}
				else
				{
					bAnim = false;
				}
				HennaGaugeWndScript.setFillPiece((nDyeLevel - 1), bEnableHiddenSkillSkin, bEnableHiddenSkill, bAnim);
				HennaGaugeWndPopupScript.setFillPiece((nDyeLevel - 1), bEnableHiddenSkillSkin, bEnableHiddenSkill, bAnim);
				break;
			}
			i++;
		}
		if((nDyeLevel == 0))
		{
			HennaGaugeWndScript.setFillPiece(-1, false, false, false);
			HennaGaugeWndPopupScript.setFillPiece(-1, false, false, false);
			nRemainTryEnchant = getRemainTryNum(nCategory, ntop);
		}
	}
	else
	{
		HennaGaugeWndScript.setFillPiece(-1, false, false, false);
		HennaGaugeWndPopupScript.setFillPiece(-1, false, false, false);
		nRemainTryEnchant = Class'NWindow.UIDATA_HENNA'.static.GetMaxTryDyeEnchant();
	}
	nCurrentLevel = nDyeLevel;
	i = 0;
	while((i < 30))
	{
		if((oHiddenSkills[i].SkillID > 0))
		{
			if((bHiddenSkillCheck == false))
			{
				bHiddenSkillCheck = true;
				if((nDyeLevel == 0))
				{
					hiddenSkilItemInfo = getSkillToItemInfo(GetSkillInfoByValue(oHiddenSkills[i].SkillID, oHiddenSkills[i].SkillLevel, 0));
					hiddenSkilItemInfo.bDisabled = 1;
				}
				else if(((oHiddenSkills[(nDyeLevel - 1)].SkillID > 0) && (oHiddenSkills[(nDyeLevel - 1)].SkillLevel > 0)))
				{
					hiddenSkilItemInfo = getSkillToItemInfo(GetSkillInfoByValue(oHiddenSkills[(nDyeLevel - 1)].SkillID, oHiddenSkills[(nDyeLevel - 1)].SkillLevel, 0));
				}
				else
				{
					hiddenSkilItemInfo = getSkillToItemInfo(GetSkillInfoByValue(oHiddenSkills[i].SkillID, oHiddenSkills[i].SkillLevel, 0));
					hiddenSkilItemInfo.bDisabled = 1;
				}
			}
			if(((addHiddenSkillID != oHiddenSkills[i].SkillID) || (addHiddenSkillLevel != oHiddenSkills[i].SkillLevel)))
			{
				addHiddenSkillID = oHiddenSkills[i].SkillID;
				addHiddenSkillLevel = oHiddenSkills[i].SkillLevel;
				HennaGaugeWndScript.setHiddenSkill(nHiddenSkillCount, true, oHiddenSkills[i].SkillID, oHiddenSkills[i].SkillLevel, i);
				HennaGaugeWndPopupScript.setHiddenSkill(nHiddenSkillCount, true, oHiddenSkills[i].SkillID, oHiddenSkills[i].SkillLevel, i);
				nHiddenSkillCount++;
			}
		}
		i++;
	}
	HiddenSkill_itemwindow.Clear();
	HiddenSkill_itemwindow.AddItem(hiddenSkilItemInfo);
	HiddenEnchantTitle_txt.SetText(((hiddenSkilItemInfo.Name $ " Lv") $ string(hiddenSkilItemInfo.Level)));
	HiddenEnchant_itemwindow.Clear();
	HiddenEnchant_itemwindow.AddItem(hiddenSkilItemInfo);
	if((nDyeLevel == 0))
	{
		nDyeLevel = 1;
		bSkillIconDislable = true;
	}
	Class'NWindow.UIDATA_HENNA'.static.GetDyeEffectUIData(byte(nCategory), byte(ntop), byte(nDyeLevel), oCurrentDyeEffectUIData);
	if((((nRemainTryEnchant == 0) && (oCurrentDyeEffectUIData.HiddenSkill.SkillID > 0)) && (getSuccessHiddenSkillAtPacket(nCategory, ntop) == false)))
	{
		HiddenSkill_btn.EnableWindow();
		HiddenEnchantNeedItemListCtrlScript.StartNeedItemList(1);
		HiddenEnchantNeedItemListCtrlScript.AddNeedItemClassID(oCurrentDyeEffectUIData.HiddenNeedItem.ItemClassID, INT64(oCurrentDyeEffectUIData.HiddenNeedItem.ItemAmount));
		HiddenEnchantNeedItemListCtrlScript.SetBuyNum(INT64(1));
		HiddenSkillEnableEffectViewport.SpawnEffect("LineageEffect2.ave_white_trans_deco");
	}
	else
	{
		HiddenSkill_btn.DisableWindow();
		HiddenSkillEnableEffectViewport.SpawnEffect("");
	}
	i = 0;
	while((i < 3))
	{
		nDyeLevel = getNDyeLevelAtPacket(nCategory, (i + 1));
		nTabRemainTryEnchant = getNChallengeCountAtPacket(nCategory, (i + 1));
		bSkillIconDislable = false;
		if((nDyeLevel == 0))
		{
			nDyeLevel = 1;
			bSkillIconDislable = true;
		}
		Class'NWindow.UIDATA_HENNA'.static.GetDyeEffectUIData(byte(nCategory), byte((i + 1)), byte(nDyeLevel), oDyeEffectUIData);
		skilItemInfo = getSkillToItemInfo(GetSkillInfoByValue(oDyeEffectUIData.Skill.SkillID, oDyeEffectUIData.Skill.SkillLevel, 0));
		if(bSkillIconDislable)
		{
			skilItemInfo.bDisabled = 1;
		}
		hiddenSkilItemInfo = getSkillToItemInfo(GetSkillInfoByValue(oDyeEffectUIData.HiddenSkill.SkillID, oDyeEffectUIData.HiddenSkill.SkillLevel, 0));
		bShowHiddenSkill = (oDyeEffectUIData.HiddenSkill.SkillID > 0);
		if((getSuccessHiddenSkillAtPacket(nCategory, (i + 1)) && bShowHiddenSkill))
		{
			bShowHiddenSkill = false;
		}
		else
		{
			hiddenSkilItemInfo.bDisabled = 1;
			if((nTabRemainTryEnchant > 0))
			{
				bShowHiddenSkill = false;
			}
		}
		setTabSkill(i, bShowHiddenSkill, skilItemInfo, hiddenSkilItemInfo);
		GetButtonHandle((((((m_Windowname $ ".Category0") $ string(i)) $ "_wnd.Category0") $ string(i)) $ "_btn")).SetTooltipCustomType(getTopTabCustomTooltip(nDyeLevel, getFirstHiddenSkillIndex(nCategory, (i + 1)), getRemainTryNum(nCategory, (i + 1)), getSuccessHiddenSkillAtPacket(nCategory, (i + 1))));
		if((ntop == (i + 1)))
		{
			HennaSkill_itemwindow.Clear();
			HennaSkill_itemwindow.AddItem(skilItemInfo);
			if((skilItemInfo.bDisabled == 1))
			{
				GetMeTexture("HennaSkillFrameAni_tex").HideWindow();
			}
			else
			{
				GetMeTexture("HennaSkillFrameAni_tex").ShowWindow();
			}
			Enchant_itemwindow.Clear();
			Enchant_itemwindow.AddItem(skilItemInfo);
			Enchant_itemwindow.UpdatePointedNum();
			EnchantTitle_txt.SetText(((skilItemInfo.Name $ " Lv") $ string(skilItemInfo.Level)));
		}
		i++;
	}
	HennaSkillDesc02Num_txt.SetText(((string(nRemainTryEnchant) $ " / ") $ string(Class'NWindow.UIDATA_HENNA'.static.GetMaxTryDyeEnchant())));
	EnchantLeftEchantNum_txt.SetText(((string(nRemainTryEnchant) $ " / ") $ string(Class'NWindow.UIDATA_HENNA'.static.GetMaxTryDyeEnchant())));
	if((nRemainTryEnchant == 0))
	{
		HennaSkillDesc02Num_txt.SetTextColor(GTColor().Red);
		EnchantLeftEchantNum_txt.SetTextColor(GTColor().Red);
	}
	else
	{
		HennaSkillDesc02Num_txt.SetTextColor(GetColor(187, 170, 136, 255));
		EnchantLeftEchantNum_txt.SetTextColor(GetColor(187, 170, 136, 255));
	}
	nDyeLevel = getNDyeLevelAtPacket(nCategory, ntop);
	nDyeLevel = (nDyeLevel + 1);
	if((nDyeLevel > Class'NWindow.UIDATA_HENNA'.static.GetMaxTryDyeEnchant()))
	{
		nDyeLevel = Class'NWindow.UIDATA_HENNA'.static.GetMaxTryDyeEnchant();
	}
	Class'NWindow.UIDATA_HENNA'.static.GetDyeEffectUIData(byte(nCategory), byte(ntop), byte(nDyeLevel), oDyeEffectUIData);
	NeedItemListWndScript.StartNeedItemList(1);
	NeedItemListWndScript.AddNeedItemClassID(oDyeEffectUIData.NeedItem.ItemClassID, INT64(oDyeEffectUIData.NeedItem.ItemAmount));
	NeedItemListWndScript.SetBuyNum(INT64(1));
	EnchantNeedItemRichListCtrlScript.StartNeedItemList(1);
	EnchantNeedItemRichListCtrlScript.AddNeedItemClassID(oDyeEffectUIData.NeedItem.ItemClassID, INT64(oDyeEffectUIData.NeedItem.ItemAmount));
	EnchantNeedItemRichListCtrlScript.SetBuyNum(INT64(1));
	ResetNeedItemRichListCtrlScript.StartNeedItemList(1);
	ResetNeedItemRichListCtrlScript.AddNeedItemClassID(oDyeEffectUIData.CancelNeedItem.ItemClassID, INT64(oDyeEffectUIData.CancelNeedItem.ItemAmount));
	ResetNeedItemRichListCtrlScript.SetBuyNum(INT64(1));
	if((oDyeEffectUIData.CancelReturnItem.ItemClassID > 0))
	{
		GetMeRichListCtrl("DisableWnd.ResetWnd.ResetPayBackItemRichListCtrl").ShowWindow();
		ResetPayBackItemRichListCtrlScript.StartNeedItemList(1);
		ResetPayBackItemRichListCtrlScript.AddNeedItemClassID(oDyeEffectUIData.CancelReturnItem.ItemClassID, INT64(oDyeEffectUIData.CancelReturnItem.ItemAmount));
		ResetPayBackItemRichListCtrlScript.SetBuyNum(INT64(1));
	}
	else
	{
		GetMeRichListCtrl("DisableWnd.ResetWnd.ResetPayBackItemRichListCtrl").HideWindow();
	}
	checkCanEnableButton();
	if(GetWindowHandle("HennaSkillListWndLive").IsShowWindow())
	{
		HennaSkillListWndLive(GetScript("HennaSkillListWndLive")).refresh(nCategory, ntop, nCurrentLevel);
	}
	if(bRequestProb)
	{
		API_C_EX_DYEEFFECT_ENCHANT_PROB_INFO(nCategory, ntop);
	}
	if(GetWindowHandle("HennaSkillListWndLive").IsShowWindow())
	{
		HennaSkillListWndLive(GetScript("HennaSkillListWndLive")).refresh(nCategory, ntop, nCurrentLevel);
	}
	return;
}

function ParsePacket_S_EX_DYEEFFECT_ENCHANT_PROB_INFO()
{
	local UIPacket._S_EX_DYEEFFECT_ENCHANT_PROB_INFO packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_DYEEFFECT_ENCHANT_PROB_INFO(packet))
	{
		return;
	}
	Debug((((("---> S_EX_DYEEFFECT_ENCHANT_PROB_INFO" @ string(packet.nCategory)) @ string(packet.nSlotID)) @ string(packet.nNormalSkillProb)) @ string(packet.nHiddenSkillProb)));
	currentSkillProbStr = string(packet.nNormalSkillProb);
	currentHiddenSkillProbStr = string(packet.nHiddenSkillProb);
	HennaSkillDesc01Num_txt.SetText((currentSkillProbStr $ "%"));
	EnchantDesc01_txt.SetText(((GetSystemString(14623) $ currentSkillProbStr) $ "%"));
	HiddenEnchantDesc01_txt.SetText(((GetSystemString(14623) $ currentHiddenSkillProbStr) $ "%"));
	if((bAutoEnchant && (pressAutoEnchantStop == false)))
	{
		runAutoEnchant();
	}
	return;
}

function runAutoEnchant()
{
	if((NeedItemListWndScript.GetCanBuy() && (nRemainTryEnchant > 0)))
	{
		timeObjectAutoEnchantDelay._Stop();
		timeObjectAutoEnchantDelay._Play();
	}
	else
	{
		timeObjectAutoEnchantDelay._Stop();
		timeObjectEnchantingDelay._Stop();
		bAutoEnchant = false;
		EnchantDesc02_txt.SetText(GetSystemString(14799));
		EnchantStop_btn.HideWindow();
		AutoEnchantClose_btn.ShowWindow();
	}
	return;
}

function ParsePacket_S_EX_DYEEFFECT_ENCHANT_NORMALSKILL()
{
	local UIPacket._S_EX_DYEEFFECT_ENCHANT_NORMALSKILL packet;
	local UIPacket._DyeEffectInfo oDyeEffectInfo;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_DYEEFFECT_ENCHANT_NORMALSKILL(packet))
	{
		return;
	}
	Debug(((((((("---> S_EX_DYEEFFECT_ENCHANT_NORMALSKILL" @ string(packet.nResult)) @ string(packet.nCategory)) @ string(packet.nSlotID)) @ string(packet.nSlotLevel)) @ string(packet.nSkillID)) @ string(packet.nSkillLevel)) @ string(packet.nChallengeCount)));
	oDyeEffectInfo.nCategory = packet.nCategory;
	oDyeEffectInfo.nSlotID = packet.nSlotID;
	oDyeEffectInfo.nSlotLevel = packet.nSlotLevel;
	oDyeEffectInfo.nSkillID = packet.nSkillID;
	oDyeEffectInfo.nSkillLevel = packet.nSkillLevel;
	oDyeEffectInfo.nChallengeCount = packet.nChallengeCount;
	nRemainTryEnchant = packet.nChallengeCount;
	addPacketArrayDyeEffectInfo(oDyeEffectInfo);
	timeObjectEnchantingDelay._Stop();
	bIsEnchanting = false;
	if((packet.nResult > 0))
	{
		EnchantEffectViewport.SpawnEffect("LineageEffect.d_ar_attractcubic_ta");
		PlaySound("ItemSound3.enchant_success");
		API_C_EX_DYEEFFECT_ENCHANT_PROB_INFO(packet.nCategory, packet.nSlotID);
		bBeforeSuccessEnchant = true;
		getInstanceL2Util().showGfxScreenMessage(GetSystemString(13820));
	}
	else
	{
		EnchantEffectViewport.SpawnEffect("LineageEffect2.ui_upgrade_fail");
		PlaySound("ItemSound3.enchant_fail");
		bBeforeSuccessEnchant = false;
		getInstanceL2Util().showGfxScreenMessage(GetSystemString(13821));
	}
	if((bAutoEnchant == false))
	{
		EnchantDesc02_txt.SetText(GetSystemString(2336));
		Enchant_Btn.SetButtonName(5005);
	}
	timeObjectInventoryDelay._Stop();
	timeObjectInventoryDelay._Play();
	return;
}

function int getFirstHiddenSkillIndex(int nCategory, int ntop)
{
	local int i;
	local array<SkillDefaultInfo> oSkills, oHiddenSkills;

	Class'NWindow.UIDATA_HENNA'.static.GetDyeEffectSkillList(byte(nCategory), byte(ntop), oSkills, oHiddenSkills);
	i = 0;
	while((i < 30))
	{
		if(((oHiddenSkills[i].SkillID > 0) && (oHiddenSkills[i].SkillLevel > 0)))
		{
			return (i + 1);
		}
		i++;
	}
	return -1;
}

function int getRemainTryNum(int nCategory, int ntop)
{
	local int i;

	if((PACKET_DYEEFFECT_LIST.vDyeEffectInfoList.Length > 0))
	{
		i = 0;
		while((i < PACKET_DYEEFFECT_LIST.vDyeEffectInfoList.Length))
		{
			if(((PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[i].nCategory == nCategory) && (PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[i].nSlotID == ntop)))
			{
				return PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[i].nChallengeCount;
			}
			i++;
		}
	}
	return Class'NWindow.UIDATA_HENNA'.static.GetMaxTryDyeEnchant();
}

function int getNDyeLevelAtPacket(int nCategory, int ntop)
{
	local int i, nDyeLevel;

	if((PACKET_DYEEFFECT_LIST.vDyeEffectInfoList.Length > 0))
	{
		i = 0;
		while((i < PACKET_DYEEFFECT_LIST.vDyeEffectInfoList.Length))
		{
			if(((PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[i].nCategory == nCategory) && (PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[i].nSlotID == ntop)))
			{
				nDyeLevel = PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[i].nSlotLevel;
			}
			i++;
		}
	}
	return nDyeLevel;
}

function int getNChallengeCountAtPacket(int nCategory, int ntop)
{
	local int i;

	if((PACKET_DYEEFFECT_LIST.vDyeEffectInfoList.Length > 0))
	{
		i = 0;
		while((i < PACKET_DYEEFFECT_LIST.vDyeEffectInfoList.Length))
		{
			if(((PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[i].nCategory == nCategory) && (PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[i].nSlotID == ntop)))
			{
				return PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[i].nChallengeCount;
			}
			i++;
		}
	}
	return Class'NWindow.UIDATA_HENNA'.static.GetMaxTryDyeEnchant();
}

function bool getSuccessHiddenSkillAtPacket(int nCategory, int ntop)
{
	local int i;

	if((PACKET_DYEEFFECT_LIST.vDyeEffectInfoList.Length > 0))
	{
		i = 0;
		while((i < PACKET_DYEEFFECT_LIST.vDyeEffectInfoList.Length))
		{
			if(((PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[i].nCategory == nCategory) && (PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[i].nSlotID == ntop)))
			{
				if(((PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[i].nHiddenSkillID > 0) && (PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[i].nHiddenSkillLevel > 0)))
				{
					return true;
				}
			}
			i++;
		}
	}
	return false;
}

function deletePacketArrayDyeEffectInfo(int nCategory, int nSlotID)
{
	local int i;

	i = 0;
	while((i < PACKET_DYEEFFECT_LIST.vDyeEffectInfoList.Length))
	{
		if(((nCategory == PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[i].nCategory) && (nSlotID == PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[i].nSlotID)))
		{
			PACKET_DYEEFFECT_LIST.vDyeEffectInfoList.Remove(i, 1);
		}
		i++;
	}
	return;
}

function addPacketArrayDyeEffectInfoAtHiddenSkill(int nCategory, int nSlotID, int nHiddenSkillID, int nHiddenSkillLevel)
{
	local int i;

	i = 0;
	while((i < PACKET_DYEEFFECT_LIST.vDyeEffectInfoList.Length))
	{
		if(((nCategory == PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[i].nCategory) && (nSlotID == PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[i].nSlotID)))
		{
			PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[i].nHiddenSkillID = nHiddenSkillID;
			PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[i].nHiddenSkillLevel = nHiddenSkillLevel;
			break;
		}
		i++;
	}
	return;
}

function addPacketArrayDyeEffectInfo(UIPacket._DyeEffectInfo oDyeEffectInfo)
{
	local int i;
	local bool bAdd;

	bAdd = true;
	i = 0;
	while((i < PACKET_DYEEFFECT_LIST.vDyeEffectInfoList.Length))
	{
		if(((oDyeEffectInfo.nCategory == PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[i].nCategory) && (oDyeEffectInfo.nSlotID == PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[i].nSlotID)))
		{
			PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[i] = oDyeEffectInfo;
			bAdd = false;
			break;
		}
		i++;
	}
	if(bAdd)
	{
		PACKET_DYEEFFECT_LIST.vDyeEffectInfoList[PACKET_DYEEFFECT_LIST.vDyeEffectInfoList.Length] = oDyeEffectInfo;
	}
	return;
}

function ParsePacket_S_EX_DYEEFFECT_ACQUIRE_HIDDENSKILL()
{
	local UIPacket._S_EX_DYEEFFECT_ACQUIRE_HIDDENSKILL packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_DYEEFFECT_ACQUIRE_HIDDENSKILL(packet))
	{
		return;
	}
	Debug(((((("---> S_EX_DYEEFFECT_ACQUIRE_HIDDENSKILL" @ string(packet.nResult)) @ string(packet.nCategory)) @ string(packet.nSlotID)) @ string(packet.nHiddenSkillID)) @ string(packet.nHiddenSkillLevel)));
	if((packet.nResult > 0))
	{
		HiddenEnchantEffectViewport.SpawnEffect("LineageEffect.d_firework_a");
		PlaySound("ItemSound2.C3_Firework_explosion");
		HiddenEnchantClose01_btn.HideWindow();
		HiddenEnchantClose02_btn.ShowWindow();
		HiddenEnchant_btn.HideWindow();
		HiddenEnchantDesc02_txt.SetText(GetSystemString(3356));
		addPacketArrayDyeEffectInfoAtHiddenSkill(packet.nCategory, packet.nSlotID, packet.nHiddenSkillID, packet.nHiddenSkillLevel);
	}
	else
	{
		HiddenEnchantEffectViewport.SpawnEffect("LineageEffect2.ui_upgrade_fail");
		PlaySound("ItemSound3.enchant_fail");
		HiddenEnchant_btn.SetButtonName(5005);
		HiddenEnchant_btn.EnableWindow();
		HiddenEnchantClose01_btn.ShowWindow();
		HiddenEnchantClose02_btn.HideWindow();
		HiddenEnchant_btn.ShowWindow();
		HiddenEnchantDesc02_txt.SetText(GetSystemString(14794));
		getInstanceL2Util().showGfxScreenMessage(GetSystemString(13821));
	}
	bIsHiddenEnchanting = false;
	timeObjectInventoryDelay._Stop();
	timeObjectInventoryDelay._Play();
	return;
}

function ParsePacket_S_EX_DYEEFFECT_ENCHANT_RESET()
{
	local UIPacket._S_EX_DYEEFFECT_ENCHANT_RESET packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_DYEEFFECT_ENCHANT_RESET(packet))
	{
		return;
	}
	Debug(((("---> S_EX_DYEEFFECT_ENCHANT_RESET" @ string(packet.nResult)) @ string(packet.nCategory)) @ string(packet.nSlotID)));
	if((packet.nResult > 0))
	{
		deletePacketArrayDyeEffectInfo(packet.nCategory, packet.nSlotID);
		OnResetCancle_btnClick();
		RefreshMainScreen(true);
	}
	else
	{
		Me.HideWindow();
		AddSystemMessage(13873);
	}
	return;
}

function API_C_EX_DYEEFFECT_LIST()
{
	local array<byte> stream;
	local UIPacket._C_EX_DYEEFFECT_LIST packet;

	if(!Class'Interface.UIPacket'.static.Encode_C_EX_DYEEFFECT_LIST(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(907, stream);
	Debug("Api Call -----> C_EX_DYEEFFECT_LIST");
	return;
}

function API_C_EX_DYEEFFECT_ENCHANT_PROB_INFO(int nCategory, int nSlotID)
{
	local array<byte> stream;
	local UIPacket._C_EX_DYEEFFECT_ENCHANT_PROB_INFO packet;

	packet.nCategory = nCategory;
	packet.nSlotID = nSlotID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_DYEEFFECT_ENCHANT_PROB_INFO(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(908, stream);
	Debug((("Api Call -----> C_EX_DYEEFFECT_ENCHANT_PROB_INFO" @ string(packet.nCategory)) @ string(packet.nSlotID)));
	return;
}

function API_C_EX_DYEEFFECT_ENCHANT_NORMALSKILL(int nCategory, int nSlotID)
{
	local array<byte> stream;
	local UIPacket._C_EX_DYEEFFECT_ENCHANT_NORMALSKILL packet;

	packet.nCategory = nCategory;
	packet.nSlotID = nSlotID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_DYEEFFECT_ENCHANT_NORMALSKILL(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(909, stream);
	Debug((("Api Call -----> C_EX_DYEEFFECT_ENCHANT_NORMALSKILL" @ string(packet.nCategory)) @ string(packet.nSlotID)));
	return;
}

function API_C_EX_DYEEFFECT_ENCHANT_RESET(int nCategory, int nSlotID)
{
	local array<byte> stream;
	local UIPacket._C_EX_DYEEFFECT_ENCHANT_RESET packet;

	packet.nCategory = nCategory;
	packet.nSlotID = nSlotID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_DYEEFFECT_ENCHANT_RESET(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(911, stream);
	Debug((("Api Call -----> C_EX_DYEEFFECT_ENCHANT_RESET" @ string(packet.nCategory)) @ string(packet.nSlotID)));
	return;
}

function API_C_EX_DYEEFFECT_ACQUIRE_HIDDENSKILL(int nCategory, int nSlotID)
{
	local array<byte> stream;
	local UIPacket._C_EX_DYEEFFECT_ACQUIRE_HIDDENSKILL packet;

	packet.nCategory = nCategory;
	packet.nSlotID = nSlotID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_DYEEFFECT_ACQUIRE_HIDDENSKILL(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(910, stream);
	Debug((("Api Call -----> C_EX_DYEEFFECT_ACQUIRE_HIDDENSKILL" @ string(packet.nCategory)) @ string(packet.nSlotID)));
	return;
}

function SetFeeItem()
{
	local array<ItemInfo> infos;
	local ItemInfo Info;

	Class'NWindow.UIDATA_INVENTORY'.static.FindItemByClassID(80762, infos);
	if((infos.Length > 0))
	{
		Info = infos[0];
	}
	else
	{
		Info = GetItemInfoByClassID(80762);
	}
	Info.bDisabled = 0;
	GetMeItemWindow("EngraveEffectItemSlot").Clear();
	GetMeItemWindow("EngraveEffectItemSlot").AddItem(Info);
	GetMeItemWindow("EngraveEffectItemSlot").SetItem(0, Info);
	SetUserInfo();
	return;
}

function handleinventoryUpdateResult(string param)
{
	local ItemInfo updatedItemInfo, FeeItem;
	local string Type;

	ParamToItemInfo(param, updatedItemInfo);
	ParseString(param, "type", Type);
	if((updatedItemInfo.Id.ClassID == 80762))
	{
		if((Type == "delete"))
		{
			updatedItemInfo.ItemNum = INT64(0);
		}
		FeeItem = updatedItemInfo;
		FeeItem.bDisabled = 0;
		GetMeItemWindow("EngraveEffectItemSlot").Clear();
		GetMeItemWindow("EngraveEffectItemSlot").AddItem(FeeItem);
		SetUserInfo();
	}
	return;
}

function CustomTooltip getTopTabCustomTooltip(optional int nDyeLevel, optional int nFirstHiddenSkillIndex, optional int nRemainTryNum, optional bool bSuccessHiddenSkill)
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;
	local int nRemainMaxEnchant, nStep;

	nRemainMaxEnchant = Class'NWindow.UIDATA_HENNA'.static.GetMaxTryDyeEnchant();
	if((((nDyeLevel >= nFirstHiddenSkillIndex) && (0 == nRemainTryNum)) && (bSuccessHiddenSkill == false)))
	{
		nStep = 3;
	}
	else if(((nDyeLevel < nFirstHiddenSkillIndex) && (0 == nRemainTryNum)))
	{
		nStep = 2;
	}
	else if(bSuccessHiddenSkill)
	{
		nStep = 4;
	}
	else
	{
		nStep = 1;
	}
	if((nStep == 1))
	{
		drawListArr[drawListArr.Length] = addDrawItemText(MakeFullSystemMsg(GetSystemMessage(14033), string(nFirstHiddenSkillIndex)), getInstanceL2Util().BrightWhite, "", false, true);
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14793), GTColor().BrightWhite, "", true, true);
		drawListArr[drawListArr.Length] = addDrawItemText((((" " $ string(nRemainTryNum)) $ "/") $ string(nRemainMaxEnchant)), GTColor().Orange2, "", false, true);
	}
	else if((nStep == 2))
	{
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemMessage(14054), getInstanceL2Util().BrightWhite, "", true, true);
	}
	else if((nStep == 3))
	{
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemMessage(14055), getInstanceL2Util().BrightWhite, "", true, true);
	}
	else if((nStep == 4))
	{
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemMessage(14056), getInstanceL2Util().BrightWhite, "", true, true);
	}
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 10;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;
}

function CustomTooltip getSideBarCustomTooltip(int nDyeChargeAmount, int nMaxDyeChargeAmount)
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(3185), getInstanceL2Util().BrightWhite, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText((GetSystemString(14844) $ " : "), getInstanceL2Util().BrightWhite, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText((cutZeroDecimalStr(ConvertFloatToString(((float(nDyeChargeAmount) / float(nMaxDyeChargeAmount)) * 100.0000000), 2, false)) $ "%"), GTColor().Orange2, "", false, true);
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 10;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;
}

function CustomTooltip getDyeChargeCustomTooltip(int nDyeChargeAmount, int nMaxDyeChargeAmount)
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText((GetSystemString(14844) $ " : "), getInstanceL2Util().BrightWhite, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText((cutZeroDecimalStr(ConvertFloatToString(((float(nDyeChargeAmount) / float(nMaxDyeChargeAmount)) * 100.0000000), 2, false)) $ "%"), GTColor().Orange2, "", false, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14841), getInstanceL2Util().ColorDesc, "", true, true);
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 10;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;
}

function SetUserInfo()
{
	local UserInfo Info;
	local int maxDyeChargeAmount;
	local ItemInfo FeeItem;

	GetPlayerInfo(Info);
	maxDyeChargeAmount = Class'NWindow.UIDATA_HENNA'.static.GetMaxDyeChargeAmount();
	Class'Interface.SideBar'.static.Inst().GetWindowByIndex(8).SetTooltipCustomType(getSideBarCustomTooltip(Info.nDyeChargeAmount, maxDyeChargeAmount));
	EngraveEffect_btn.SetTooltipCustomType(getDyeChargeCustomTooltip(Info.nDyeChargeAmount, maxDyeChargeAmount));
	if(!IsShowWindow(m_Windowname))
	{
		return;
	}
	feePer = float(ConvertFloatToString(((float(Info.nDyeChargeAmount) / float(maxDyeChargeAmount)) * 100.0000000), 2, false));
	EngraveEffectStatus.SetPoint(INT64(Info.nDyeChargeAmount), INT64(maxDyeChargeAmount));
	if((GetMeItemWindow("EngraveEffectItemSlot").GetItemNum() > 0))
	{
		GetMeItemWindow("EngraveEffectItemSlot").GetItem(0, FeeItem);
		feeItemNum = FeeItem.ItemNum;
	}
	if((feeItemNum == INT64(0)))
	{
		EngraveEffect_btn.DisableWindow();
	}
	else
	{
		EngraveEffect_btn.EnableWindow();
	}
	return;
}

function bool GetCanInventoryWeight()
{
	local UserInfo uInfo;
	local float Per;

	if(GetPlayerInfo(uInfo))
	{
		Per = (float(uInfo.nCarringWeight) / float(uInfo.nCarryWeight));
		return (Per <= 0.9000000);
	}
	return false;
}

function bool GetCanInventoryNumLimit()
{
	local array<ItemInfo> allItem, EquipItem;
	local int nLimit;

	Class'NWindow.UIDATA_INVENTORY'.static.GetAllInvenItem(allItem);
	Class'NWindow.UIDATA_INVENTORY'.static.GetAllEquipItem(EquipItem);
	Debug(("allItem" @ string(allItem.Length)));
	Debug(("equipItem" @ string(EquipItem.Length)));
	Debug(("90% 구하기 " @ string(((InventoryWnd(GetScript("InventoryWnd")).GetMyInventoryLimit() * 90) / 100))));  // EN?: Save 90%
	nLimit = ((InventoryWnd(GetScript("InventoryWnd")).GetMyInventoryLimit() * 90) / 100);
	Debug(("nLimit" @ string(nLimit)));
	if(((allItem.Length + EquipItem.Length) < nLimit))
	{
		return true;
	}
	return false;
}

function OnReceivedCloseUI()
{
	if((bAutoEnchant && EnchantStop_btn.IsShowWindow()))
	{
		OnEnchant_BtnClick();
	}
	else if(((bIsHiddenEnchanting && HiddenEnchant_btn.IsEnableWindow()) && HiddenEnchantWnd.IsShowWindow()))
	{
		Debug("OnHiddenEnchant_btnClick");
		OnHiddenEnchant_btnClick();
	}
	else if(HiddenEnchantWnd.IsShowWindow())
	{
		OnHiddenEnchantClose01_btnClick();
		Debug("HiddenEnchantWnd.IsShowWindow()");
	}
	else if(ResetWnd.IsShowWindow())
	{
		Debug("OnResetCancle_btnClick()");
		OnResetCancle_btnClick();
	}
	else if(((EnchantWnd.IsShowWindow() && bIsEnchanting) && Enchant_Btn.IsEnableWindow()))
	{
		OnEnchant_BtnClick();
		Debug("OnEnchant_btnClick");
	}
	else if(EnchantWnd.IsShowWindow())
	{
		OnEnchantClose_btnClick();
		Debug("OnEnchantClose_btnClick");
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	}
	return;
}

function SetDisable(bool bDisable)
{
	if(bDisable)
	{
		disableWnd.ShowWindow();
	}
	else
	{
		disableWnd.HideWindow();
	}
	ResetWnd.HideWindow();
	EnchantWnd.HideWindow();
	HiddenEnchantWnd.HideWindow();
	return;
}

function string getCategoryName(int nCategory)
{
	switch(nCategory)
	{
		case 1:
			return GetNpcString(1804203);
		case 2:
			return GetNpcString(1804204);
		case 3:
			return GetNpcString(1804205);
		case 4:
			return GetNpcString(1804206);
		case 5:
			return GetNpcString(1804207);
		case 6:
			return GetNpcString(1804208);
		case 7:
			return GetNpcString(1804209);
		case 8:
			return GetNpcString(1804210);
		case 9:
			return GetNpcString(1804211);
		case 10:
			return GetNpcString(1804212);
		default:
			return "";
	}
}

defaultproperties
{
	m_Windowname="HennaEngraveWndLive"
}
