class HennaEnchantWnd extends UICommonAPI
	dependson(UIPacket);

const TIME_ID = 1010101;
const TIME_BAR_ID = 1010102;
const STEP_MAX = 30;
const ENCHANTINGAUTO_TIME = 500;

var L2UITimerObject timeObjectInventoryDelay;
var bool bPressCancelAutoEnchant;
var WindowHandle Me;
var EffectViewportWndHandle WndBG_EffectViewport;
var WindowHandle EnchantStatus_wnd;
var TextBoxHandle MyEnchantNum_text;
var TextBoxHandle HennaLV_txt;
var TextBoxHandle EffectNameSelect_txt;
var ButtonHandle EffectNameSelect_BTN;
var TextBoxHandle EffectNameSelectNum_txt;
var TextBoxHandle MyEnchant_PrvLv_txt;
var TextBoxHandle MyEnchant_NextLv_txt;
var StatusBarHandle MyEnchant_statusbar;
var TextBoxHandle StatusNumber_txt;
var ButtonHandle Enchant_Btn;
var ButtonHandle Reset_Btn;
var RichListCtrlHandle NeedItemRichListCtrl;
var TextBoxHandle EnchantCountTitle_txt;
var TextBoxHandle EnchantCount_txt;
var WindowHandle NeedItemSelectDialog_wnd;
var RichListCtrlHandle NeedItemSelect_ListCtrl;
var ButtonHandle ProbabilityTootip_Btn;
var UIControlPageNavi pageNavi;
var UIControlNeedItemList NeedItemList;
var UIControlNeedItemList needItemDialogList;
var UIControlNeedItemList needItemDialogList2;
var UIControlNeedItemList selectNeedItemList;
var UIControlGroupButtons groupButtons;
var EffectViewportWndHandle UnLockResultEffectViewport;
var CheckBoxHandle Auto_CheckBox;
var UIPacket._S_EX_NEW_HENNA_LIST henna_list_packet;
var string m_Windowname;
var int timeResultCount;
var int nLastRandomNum;
var int currentSelectSlot;
var DyePotentialFeeUIData dyePotentialFeeData;
var array<DyePotentialUIData> potentialDataArray;
var int barAniStep;
var int barAniCount;
var string currentEffectPath;
var array<int> currentActiveSteps;
var int selectNeedItemClassID;
var int selectNeedItemIndex;
var array<DyePotentialUpgradeItemInfo> saveNeedUpgradeItemInfos;
var WindowHandle disableWnd;
var WindowHandle UnlockDisableWnd;
var WindowHandle UIControlDialogAsset;
var WindowHandle UnlockPopup;
var UIControlNeedItemSelectMultiItems NeedItemMultiItems;
var bool bPublicInitSelectNeedItemState;
var array<int> initPotenSelectArray;
var int currentOpenSlotStep;
var array<UIPacket._ItemInfo> beforeVReqOpenSlotCostItemList;
var int beforeSelectedOpenSlotCostClassID;

static function HennaEnchantWnd Inst()
{
	return HennaEnchantWnd(GetScript("HennaEnchantWnd"));
}

function OnRegisterEvent()
{
	RegisterEvent((100000 + 982));
	RegisterEvent((100000 + 986));
	RegisterEvent((100000 + 985));
	RegisterEvent((100000 + 1106));
	RegisterEvent((100000 + 1178));
	RegisterEvent((100000 + 1179));
	RegisterEvent(11582);
	RegisterEvent(40);
	RegisterEvent(9750);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

function Initialize()
{
	local int i;

	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	WndBG_EffectViewport = GetEffectViewportWndHandle((m_Windowname $ ".WndBG_EffectViewport"));
	EnchantStatus_wnd = GetWindowHandle((m_Windowname $ ".EnchantStatus_wnd"));
	MyEnchantNum_text = GetTextBoxHandle((m_Windowname $ ".MyEnchantNum_text"));
	HennaLV_txt = GetTextBoxHandle((m_Windowname $ ".EnchantStatus_wnd.HennaLV_txt"));
	EffectNameSelect_txt = GetTextBoxHandle((m_Windowname $ ".EffectNameSelect_txt"));
	EffectNameSelect_BTN = GetButtonHandle((m_Windowname $ ".EffectNameSelect_BTN"));
	EffectNameSelectNum_txt = GetTextBoxHandle((m_Windowname $ ".EffectNameSelectNum_txt"));
	MyEnchant_PrvLv_txt = GetTextBoxHandle((m_Windowname $ ".MyEnchant_PrvLv_txt"));
	MyEnchant_NextLv_txt = GetTextBoxHandle((m_Windowname $ ".MyEnchant_NextLv_txt"));
	MyEnchant_statusbar = GetStatusBarHandle((m_Windowname $ ".MyEnchant_statusbar"));
	StatusNumber_txt = GetTextBoxHandle((m_Windowname $ ".StatusNumber_txt"));
	Enchant_Btn = GetButtonHandle((m_Windowname $ ".Enchant_BTN"));
	Reset_Btn = GetButtonHandle((m_Windowname $ ".Reset_btn"));
	NeedItemRichListCtrl = GetRichListCtrlHandle((m_Windowname $ ".NeedItemRichListCtrl"));
	EnchantCountTitle_txt = GetTextBoxHandle((m_Windowname $ ".EnchantCountTitle_txt"));
	EnchantCount_txt = GetTextBoxHandle((m_Windowname $ ".EnchantCount_txt"));
	NeedItemSelectDialog_wnd = GetWindowHandle((m_Windowname $ ".NeedItemSelectDialog_wnd"));
	NeedItemSelect_ListCtrl = GetRichListCtrlHandle((m_Windowname $ ".NeedItemSelectDialog_wnd.NeedItemSelect_ListCtrl"));
	ProbabilityTootip_Btn = GetButtonHandle((m_Windowname $ ".ProbabilityTootip_Btn"));
	UnLockResultEffectViewport = GetEffectViewportWndHandle((m_Windowname $ ".UnLockResultEffectViewport"));
	Auto_CheckBox = GetCheckBoxHandle((m_Windowname $ ".EnchantDialog_wnd.Auto_CheckBox"));
	GetWindowHandle((m_Windowname $ ".EnchantDialog_wnd")).HideWindow();
	Auto_CheckBox.SetCheck(false);
	MyEnchant_PrvLv_txt.SetText("");
	MyEnchant_NextLv_txt.SetText("");
	initUIControlGroupButtons();
	initUIControlNeedItemList();
	InitPageNavi();
	GetTextBoxHandle((m_Windowname $ ".ColorYellow_Txt")).SetTooltipType("text");
	GetTextBoxHandle((m_Windowname $ ".ColorBrown_Txt")).SetTooltipType("text");
	GetTextBoxHandle((m_Windowname $ ".ColorBlue_Txt")).SetTooltipType("text");
	GetTextBoxHandle((m_Windowname $ ".ColorYellow_Txt")).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13920), 250));
	GetTextBoxHandle((m_Windowname $ ".ColorBrown_Txt")).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13921), 250));
	GetTextBoxHandle((m_Windowname $ ".ColorBlue_Txt")).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13922), 250));
	disableWnd = GetWindowHandle((m_Windowname $ ".DisableWnd"));
	UIControlDialogAsset = GetWindowHandle((m_Windowname $ ".DisableWnd.UIControlDialogAsset"));
	UnlockDisableWnd = GetWindowHandle((m_Windowname $ ".UnlockDisableWnd"));
	UnlockPopup = GetWindowHandle((m_Windowname $ ".UnlockPopup"));
	NeedItemMultiItems = Class'InterfaceClassic.UIControlNeedItemSelectMultiItems'.static._InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".UnlockDisableWnd.NeedItem_wnd.NeedItemMultiItems")));
	NeedItemMultiItems = UIControlNeedItemSelectMultiItems(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".UnlockDisableWnd.NeedItem_wnd.NeedItemMultiItems")).GetScript());
	NeedItemMultiItems._ConnectPopup(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".UnlockDisableWnd.NeedItem_wnd.UIControlNeedItemSelectMultiItemPopup")));
	NeedItemMultiItems.DelegateSelectedItemOnClick = delegateItemSelectOnClick;
	NeedItemMultiItems.DelegateOnUpdateItem = HandleOnUpdateItemNormal;
	timeObjectInventoryDelay = Class'InterfaceClassic.L2UITimer'.static.Inst()._MakeTimerObject(500, 1);
	timeObjectInventoryDelay._DelegateOnTime = OnTimeDelayInventory;
	initDialogAssetes();
	bPressCancelAutoEnchant = false;
	initPotenSelectArray.Length = 4;
	initPotenSelectArray[0] = 0;
	initPotenSelectArray[1] = 0;
	initPotenSelectArray[2] = 0;
	initPotenSelectArray[3] = 0;
	i = 1;
	while((i <= 30))
	{
		GetWindowHandle(((m_Windowname $ ".EnchantStep_Wnd.Step") $ string(i))).HideWindow();
		i++;
	}
	return;
}

function delegateItemSelectOnClick(int SelectedIndex, int selectedClassID, INT64 selectedAmount)
{
	beforeSelectedOpenSlotCostClassID = selectedClassID;
	if(NeedItemMultiItems._GetCanBuy())
	{
		GetMeButton("UnlockDisableWnd.UnlockPopup.BreakthroughPopup_OK_Btn").EnableWindow();
	}
	else
	{
		GetMeButton("UnlockDisableWnd.UnlockPopup.BreakthroughPopup_OK_Btn").DisableWindow();
	}
	return;
}

function HandleOnUpdateItemNormal()
{
	return;
}

function initDialogAssetes()
{
	local UIControlDialogAssets popupExpandScript;

	popupExpandScript = Class'InterfaceClassic.UIControlDialogAssets'.static.InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.UIControlDialogAsset")));
	disableWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd"));
	popupExpandScript.SetDisableWindow(disableWnd);
	Class'NWindow.UIAPI_WINDOW'.static.SetAlwaysOnTop((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd"), true);
	return;
}

function UIControlDialogAssets GetDialogAssetScript()
{
	local WindowHandle popExpandWnd;

	popExpandWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.UIControlDialogAsset"));
	return UIControlDialogAssets(popExpandWnd.GetScript());
}

function ShowDialogAskPublicCountInit()
{
	local string addMessage;

	DialogHide();
	if((henna_list_packet.nResetMaxCount == -1))
	{
		addMessage = "";
	}
	else
	{
		addMessage = ((((("<br><br>" $ GetSystemString(14479)) $ " ") $ string((henna_list_packet.nResetMaxCount - henna_list_packet.nResetCount))) $ "/") $ string(henna_list_packet.nResetMaxCount));
	}
	GetDialogAssetScript().SetDialogDescHtml(htmlSetHtmlStart((htmlAddText(GetSystemString(14480), "hs10", getColorHexString(GTColor().White)) $ htmlAddText(addMessage, "", getColorHexString(GTColor().Green)))));
	GetDialogAssetScript().SetUseNeedItem(true);
	GetDialogAssetScript().StartNeedItemList(1);
	GetDialogAssetScript().AddNeedItemClassID(henna_list_packet.resetCostList[selectNeedItemIndex].nItemClassID, henna_list_packet.resetCostList[selectNeedItemIndex].nAmount);
	GetDialogAssetScript().SetItemNum(1);
	GetDialogAssetScript().Show();
	GetDialogAssetScript().DelegateOnClickBuy = onClickDialog;
	GetDialogAssetScript().DelegateOnCancel = OnClickCancelDialog;
	return;
}

function onClickDialog()
{
	GetDialogAssetScript().Hide();
	API_C_EX_NEW_HENNA_POTEN_ENCHANT_RESET(selectNeedItemClassID);
	return;
}

function OnClickCancelDialog()
{
	GetDialogAssetScript().Hide();
	return;
}

function OnTimeDelayInventory(int Count)
{
	Debug(("OnTimeDelayInventory" @ string(Count)));
	OnEnchant_BtnClick();
	if(((GetButtonHandle((m_Windowname $ ".EnchantDialog_wnd.EnchantApply_btn")).IsEnableWindow() && Auto_CheckBox.IsChecked()) && (bPressCancelAutoEnchant == false)))
	{
		OnEnchantApply_btnClick();
	}
	else
	{
		bPressCancelAutoEnchant = true;
	}
	return;
}

function SetCurrentActiveSteps()
{
	local int i, SlotIndex, dyeItemlevel, nLastAdd;

	SlotIndex = 0;
	while((SlotIndex < henna_list_packet.hennaInfoList.Length))
	{
		dyeItemlevel = henna_list_packet.hennaInfoList[SlotIndex].nOpenedSlotStep;
		if((henna_list_packet.hennaInfoList[SlotIndex].nEnchantStep == 30))
		{
			if((henna_list_packet.hennaInfoList[SlotIndex].nEnchantExp >= getDyePotentialExp(henna_list_packet.hennaInfoList[SlotIndex].nEnchantStep).Exp))
			{
				nLastAdd = 1;
			}
		}
		currentActiveSteps[SlotIndex] = 0;
		i = 0;
		while((i < ((henna_list_packet.hennaInfoList[SlotIndex].nEnchantStep - 1) + nLastAdd)))
		{
			if((dyeItemlevel > i))
			{
				currentActiveSteps[SlotIndex] = (i + 1);
			}
			i++;
		}
		SlotIndex++;
	}
	return;
}

function showStep(int Page)
{
	local int i, dyeItemlevel, currentStepMaxExp, slotExp, currentSlotExp;
	local StatusBaseHandle Handle;
	local int nLastAdd;

	Handle = MyEnchant_statusbar.GetSelfScript();
	dyeItemlevel = henna_list_packet.hennaInfoList[currentSelectSlot].nOpenedSlotStep;
	currentSlotExp = (getDyePotentialAccrueExp((henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantStep - 1)) + henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantExp);
	slotExp = getDyePotentialAccrueExp(dyeItemlevel);
	i = 1;
	while((i <= 30))
	{
		GetWindowHandle(((m_Windowname $ ".EnchantStep_Wnd.Step") $ string(i))).HideWindow();
		GetStatusRoundHandle((((m_Windowname $ ".EnchantStep_Wnd.Step") $ string(i)) $ ".EnchantApply_StatusRound")).ClearPoint();
		GetAnimTextureHandle((((m_Windowname $ ".EnchantStep_Wnd.Step") $ string(i)) $ ".UnLock_Ani")).HideWindow();
		GetTextureHandle((((m_Windowname $ ".EnchantStep_Wnd.Step") $ string(i)) $ ".HennaStepOpen_tex")).HideWindow();
		GetTextureHandle((((m_Windowname $ ".EnchantStep_Wnd.Step") $ string(i)) $ ".DyeBenefit_tex")).HideWindow();
		GetWindowHandle(((m_Windowname $ ".EnchantStep_Wnd.Step") $ string(i))).SetTooltipType("text");
		GetWindowHandle(((m_Windowname $ ".EnchantStep_Wnd.Step") $ string(i))).SetTooltipCustomType(getMainSlotCustomTooltip(i));
		i++;
	}
	i = (((Page - 1) * 10) + 1);
	while((i <= (Page * 10)))
	{
		GetWindowHandle(((m_Windowname $ ".EnchantStep_Wnd.Step") $ string(i))).ShowWindow();
		i++;
	}
	if((henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantStep == 30))
	{
		if((henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantExp >= getDyePotentialExp(henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantStep).Exp))
		{
			nLastAdd = 1;
		}
	}
	currentActiveSteps[currentSelectSlot] = 0;
	i = 0;
	while((i < ((henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantStep - 1) + nLastAdd)))
	{
		if((dyeItemlevel > i))
		{
			GetStatusRoundHandle((((m_Windowname $ ".EnchantStep_Wnd.Step") $ string((i + 1))) $ ".EnchantApply_StatusRound")).SetGaugeColor(1, GTColor().Yellow);
			GetTextureHandle((((m_Windowname $ ".EnchantStep_Wnd.Step") $ string((i + 1))) $ ".DyeBenefit_tex")).ShowWindow();
			currentActiveSteps[currentSelectSlot] = (i + 1);
		}
		else
		{
			GetStatusRoundHandle((((m_Windowname $ ".EnchantStep_Wnd.Step") $ string((i + 1))) $ ".EnchantApply_StatusRound")).SetGaugeColor(1, GTColor().Orange);
		}
		GetStatusRoundHandle((((m_Windowname $ ".EnchantStep_Wnd.Step") $ string((i + 1))) $ ".EnchantApply_StatusRound")).SetPoint(INT64(1), INT64(1));
		i++;
	}
	i = (i - nLastAdd);
	currentStepMaxExp = getDyePotentialExp(henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantStep).Exp;
	if((currentSlotExp > slotExp))
	{
		GetStatusRoundHandle((((m_Windowname $ ".EnchantStep_Wnd.Step") $ string((i + 1))) $ ".EnchantApply_StatusRound")).SetGaugeColor(1, GTColor().Orange);
	}
	else
	{
		GetStatusRoundHandle((((m_Windowname $ ".EnchantStep_Wnd.Step") $ string((i + 1))) $ ".EnchantApply_StatusRound")).SetGaugeColor(1, GTColor().Yellow);
	}
	GetStatusRoundHandle((((m_Windowname $ ".EnchantStep_Wnd.Step") $ string((i + 1))) $ ".EnchantApply_StatusRound")).SetPoint(INT64(henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantExp), INT64(currentStepMaxExp));
	if((henna_list_packet.hennaInfoList[currentSelectSlot].nOpenedSlotStep > 0))
	{
		if((henna_list_packet.hennaInfoList[currentSelectSlot].nOpenedSlotStep < 30))
		{
			AnimTexturePlay(GetAnimTextureHandle((((m_Windowname $ ".EnchantStep_Wnd.Step") $ string((henna_list_packet.hennaInfoList[currentSelectSlot].nOpenedSlotStep + 1))) $ ".UnLock_Ani")), true, 9999999);
		}
	}
	i = 0;
	while((i < dyeItemlevel))
	{
		GetTextureHandle((((m_Windowname $ ".EnchantStep_Wnd.Step") $ string((i + 1))) $ ".HennaStepOpen_tex")).ShowWindow();
		i++;
	}
	return;
}

function initUIControlGroupButtons()
{
	groupButtons = new Class'InterfaceClassic.UIControlGroupButtons';
	groupButtons._SetStartInfo("L2UI_EPIC.HennaClassicWnd.CategoryBgBtn", "L2UI_EPIC.HennaClassicWnd.CategoryBgBtn_Down", "L2UI_EPIC.HennaClassicWnd.CategoryBgBtn_Over", false);
	groupButtons._addButtonController(GetButtonHandle((m_Windowname $ ".Category01_wnd.Category_BTN")));
	groupButtons._addButtonController(GetButtonHandle((m_Windowname $ ".Category02_wnd.Category_BTN")));
	groupButtons._addButtonController(GetButtonHandle((m_Windowname $ ".Category03_wnd.Category_BTN")));
	groupButtons._addButtonController(GetButtonHandle((m_Windowname $ ".Category04_wnd.Category_BTN")));
	groupButtons.DelegateOnClickButton = groupButtonOnClickButton;
	GetButtonHandle((m_Windowname $ ".Category01_wnd.Category_BTN")).SetTooltipType("text");
	GetButtonHandle((m_Windowname $ ".Category02_wnd.Category_BTN")).SetTooltipType("text");
	GetButtonHandle((m_Windowname $ ".Category03_wnd.Category_BTN")).SetTooltipType("text");
	GetButtonHandle((m_Windowname $ ".Category04_wnd.Category_BTN")).SetTooltipType("text");
	return;
}

function initUIControlNeedItemList()
{
	NeedItemList = new Class'InterfaceClassic.UIControlNeedItemList';
	NeedItemList.SetRichListControler(GetRichListCtrlHandle((m_Windowname $ ".NeedItemRichListCtrl")));
	NeedItemList.StartNeedItemList(1);
	NeedItemList.SetHideMyNum(false);
	needItemDialogList = new Class'InterfaceClassic.UIControlNeedItemList';
	needItemDialogList.SetRichListControler(GetRichListCtrlHandle((m_Windowname $ ".EnchantDialog_wnd.Dialog_NeedItemRichListCtrl")));
	needItemDialogList.StartNeedItemList(1);
	needItemDialogList2 = new Class'InterfaceClassic.UIControlNeedItemList';
	needItemDialogList2.SetRichListControler(GetRichListCtrlHandle((m_Windowname $ ".EnchantDialog_wnd.Dialog_NeedItemRichListCtrl2")));
	needItemDialogList2.StartNeedItemList(1);
	selectNeedItemList = new Class'InterfaceClassic.UIControlNeedItemList';
	selectNeedItemList.SetRichListControler(GetRichListCtrlHandle((m_Windowname $ ".NeedItemSelectDialog_wnd.NeedItemSelect_ListCtrl")));
	selectNeedItemList.StartNeedItemList(2);
	NeedItemSelect_ListCtrl.SetSelectable(true);
	return;
}

function InitPageNavi()
{
	local WindowHandle PageNaviControl;

	PageNaviControl = GetWindowHandle((m_Windowname $ ".PageNavi_Control"));
	PageNaviControl.SetScript("UIControlPageNavi");
	pageNavi = UIControlPageNavi(PageNaviControl.GetScript());
	pageNavi.Init((m_Windowname $ ".PageNavi_Control"));
	pageNavi.DelegeOnChangePage = pageChanged;
	return;
}

function pageChanged(int Page)
{
	showStep(Page);
	GetTextureHandle((m_Windowname $ ".EnchantStep_Wnd.PageLine01_tex")).HideWindow();
	GetTextureHandle((m_Windowname $ ".EnchantStep_Wnd.PageLine02_tex")).HideWindow();
	GetTextureHandle((m_Windowname $ ".EnchantStep_Wnd.PageLine03_tex")).HideWindow();
	GetTextureHandle((((m_Windowname $ ".EnchantStep_Wnd.PageLine0") $ string(Page)) $ "_tex")).ShowWindow();
	return;
}

function groupButtonOnClickButton(string parentWindowName, string strName, int i)
{
	local DyePotentialUIData dyePotentialData;
	local int dyeItemlevel;
	local SkillInfo SkillInfo;
	local int currentStepMaxExp, nShowPageNum, currentSlotExp, slotExp;
	local string beforeBarStr;
	local StatusBaseHandle Handle;
	local int N, M;
	local bool bNeedItemChange;
	local int SelectedIndex;
	local array<string> effectNames;

	if((strName == "Category_BTN"))
	{
		beforeSelectedOpenSlotCostClassID = 0;
		beforeVReqOpenSlotCostItemList.Length = 0;
	}
	Handle = MyEnchant_statusbar.GetSelfScript();
	currentSelectSlot = i;
	_GetEffectStrings(currentSelectSlot, effectNames, SelectedIndex);
	if((SelectedIndex == -1))
	{
		Class'NWindow.UIDATA_HENNA'.static.GetDyePotentialDataList((currentSelectSlot + 1), potentialDataArray);
		if(Me.IsShowWindow())
		{
			if((initPotenSelectArray[currentSelectSlot] == 0))
			{
				initPotenSelectArray[currentSelectSlot] = 1;
				API_C_EX_NEW_HENNA_POTEN_SELECT((currentSelectSlot + 1), potentialDataArray[0].DyePotentialID);
			}
		}
	}
	MyEnchantNum_text.SetText(MakeFullSystemMsg(GetSystemMessage(5203), string(getDyePotentialLastLevel())));
	dyeItemlevel = henna_list_packet.hennaInfoList[i].nOpenedSlotStep;
	Class'NWindow.UIDATA_HENNA'.static.GetDyePotentialData(henna_list_packet.hennaInfoList[i].nPotenID, dyePotentialData);
	if((henna_list_packet.hennaInfoList[i].nPotenID > 0))
	{
		if((henna_list_packet.hennaInfoList[i].nActiveStep > 0))
		{
			GetTextBoxHandle((m_Windowname $ ".EffectNameSelect_txt")).SetTextColor(GTColor().Yellow);
			GetTextBoxHandle((m_Windowname $ ".EffectNameSelectNum_txt")).SetTextColor(GTColor().Yellow);
			GetSkillInfo(dyePotentialData.SkillID, henna_list_packet.hennaInfoList[i].nActiveStep, 0, SkillInfo);
			GetTextBoxHandle((m_Windowname $ ".EffectNameSelect_txt")).SetText(dyePotentialData.EffectName);
			GetTextBoxHandle((m_Windowname $ ".EffectNameSelectNum_txt")).SetText(SkillInfo.SkillDesc);
		}
		else
		{
			GetTextBoxHandle((m_Windowname $ ".EffectNameSelect_txt")).SetTextColor(GTColor().White);
			GetTextBoxHandle((m_Windowname $ ".EffectNameSelectNum_txt")).SetTextColor(GTColor().White);
			GetTextBoxHandle((m_Windowname $ ".EffectNameSelect_txt")).SetText(dyePotentialData.EffectName);
			GetTextBoxHandle((m_Windowname $ ".EffectNameSelectNum_txt")).SetText("+0");
		}
	}
	else
	{
		GetTextBoxHandle((m_Windowname $ ".EffectNameSelect_txt")).SetTextColor(GTColor().White);
		GetTextBoxHandle((m_Windowname $ ".EffectNameSelectNum_txt")).SetTextColor(GTColor().White);
		GetTextBoxHandle((m_Windowname $ ".EffectNameSelect_txt")).SetText(GetSystemString(13887));
		GetTextBoxHandle((m_Windowname $ ".EffectNameSelectNum_txt")).SetText("");
	}
	MyEnchant_PrvLv_txt.SetText(MakeFullSystemMsg(GetSystemMessage(5203), string((henna_list_packet.hennaInfoList[i].nEnchantStep - 1))));
	beforeBarStr = MyEnchant_NextLv_txt.GetText();
	if((henna_list_packet.hennaInfoList[i].nEnchantStep < getDyePotentialLastLevel()))
	{
		MyEnchant_NextLv_txt.SetText(MakeFullSystemMsg(GetSystemMessage(5203), string(henna_list_packet.hennaInfoList[i].nEnchantStep)));
	}
	else
	{
		MyEnchant_NextLv_txt.SetText("Max");
	}
	if((parentWindowName == "resultOK"))
	{
		if(((beforeBarStr != MyEnchant_NextLv_txt.GetText()) && (beforeBarStr != "")))
		{
			L2UITween(GetScript("l2UITween")).StartShake((m_Windowname $ ".MyEnchant_PrvLv_txt"), 6, 1000, small, 0);
			L2UITween(GetScript("l2UITween")).StartShake((m_Windowname $ ".MyEnchant_NextLv_txt"), 6, 1000, small, 0);
		}
	}
	currentStepMaxExp = getDyePotentialExp(henna_list_packet.hennaInfoList[i].nEnchantStep).Exp;
	MyEnchant_statusbar.SetPoint(INT64(henna_list_packet.hennaInfoList[i].nEnchantExp), INT64(currentStepMaxExp));
	StatusNumber_txt.SetText(((string(henna_list_packet.hennaInfoList[i].nEnchantExp) $ "/") $ string(currentStepMaxExp)));
	Enchant_Btn.EnableWindow();
	currentSlotExp = (getDyePotentialAccrueExp((henna_list_packet.hennaInfoList[i].nEnchantStep - 1)) + henna_list_packet.hennaInfoList[i].nEnchantExp);
	slotExp = getDyePotentialAccrueExp(dyeItemlevel);
	GetTextBoxHandle((m_Windowname $ ".MYDyeNum_txt")).SetText(((string(currentSlotExp) $ "/") $ string(getDyePotentialTotalExp())));
	HennaLV_txt.SetText(MakeFullSystemMsg(GetSystemMessage(5203), string(henna_list_packet.hennaInfoList[i].nActiveStep)));
	dyePotentialFeeData = getFeeDataProcess();
	ProbabilityTootip_Btn.SetTooltipType("text");
	ProbabilityTootip_Btn.SetTooltipCustomType(getTooltipCustomSuccessPercent());
	if(isPrivateSlotEnchantState())
	{
		EnchantCountTitle_txt.SetText(MakeFullSystemMsg(GetSystemMessage(13752), string((i + 1))));
		EnchantCountTitle_txt.SetTextColor(GTColor().Green3);
	}
	else
	{
		EnchantCountTitle_txt.SetText(GetSystemString(14205));
		EnchantCountTitle_txt.SetTextColor(GTColor().White);
	}
	if(((henna_list_packet.nDailyCount == 0) && (dyePotentialFeeData.DailyCount == 0)))
	{
		EnchantCount_txt.SetText(GetSystemString(858));
		EnchantCount_txt.SetTextColor(GTColor().Yellow);
	}
	else
	{
		GetMeButton("EnchantbtnHelp").SetTooltipCustomType(getTooltipCustomQuestionMark());
		if(isPrivateSlotEnchantState())
		{
			if((henna_list_packet.hennaInfoList[currentSelectSlot].nDailyCount == 0))
			{
				EnchantCount_txt.SetTextColor(GTColor().Red);
			}
			else
			{
				EnchantCount_txt.SetTextColor(GTColor().Yellow);
			}
			EnchantCount_txt.SetText(((string(henna_list_packet.hennaInfoList[currentSelectSlot].nDailyCount) $ "/") $ string(dyePotentialFeeData.DailyCount)));
		}
		else
		{
			if((henna_list_packet.nDailyCount == 0))
			{
				EnchantCount_txt.SetTextColor(GTColor().Red);
			}
			else
			{
				EnchantCount_txt.SetTextColor(GTColor().Yellow);
			}
			EnchantCount_txt.SetText(((string(henna_list_packet.nDailyCount) $ "/") $ string(dyePotentialFeeData.DailyCount)));
		}
	}
	if((isPrivateSlotEnchantState() || (henna_list_packet.nDailyCount > 0)))
	{
		bPublicInitSelectNeedItemState = false;
		Enchant_Btn.ShowWindow();
		Reset_Btn.HideWindow();
		GetMeTextBox("NeedItemTitle_txt").HideWindow();
		GetRichListCtrlHandle((m_Windowname $ ".NeedItemRichListCtrl")).HideWindow();
		GetTextureHandle((m_Windowname $ ".NeedItemTitleBG_tex")).HideWindow();
		if((dyePotentialFeeData.UpgradeItemInfos.Length == 1))
		{
			NeedItemList.CleariObjects();
			NeedItemList.CleariObjects();
			NeedItemList.AddNeedItemClassID(dyePotentialFeeData.UpgradeItemInfos[0].ItemClassID, INT64(dyePotentialFeeData.UpgradeItemInfos[0].ItemCount));
			NeedItemList.SetBuyNum(INT64(1));
			needItemDialogList.CleariObjects();
			needItemDialogList.AddNeedItemClassID(dyePotentialFeeData.UpgradeItemInfos[0].ItemClassID, INT64(dyePotentialFeeData.UpgradeItemInfos[0].ItemCount));
			needItemDialogList.SetBuyNum(INT64(1));
			needItemDialogList2.CleariObjects();
			needItemDialogList2.AddNeedItemClassID(57, INT64(dyePotentialFeeData.Commission));
			needItemDialogList2.SetBuyNum(INT64(1));
			selectNeedItemClassID = dyePotentialFeeData.UpgradeItemInfos[0].ItemClassID;
			saveNeedUpgradeItemInfos = dyePotentialFeeData.UpgradeItemInfos;
			Enchant_Btn.EnableWindow();
			GetWindowHandle((m_Windowname $ ".NeedItemSelectWnd")).HideWindow();
			GetButtonHandle((m_Windowname $ ".NeedItemSelectArrow_btn")).HideWindow();
			NeedItemSelectDialog_wnd.HideWindow();
		}
		else
		{
			selectNeedItemList.CleariObjects();
			GetMeWindow("NeedItemSelectDialog_wnd").SetWindowSize(284, ((40 * dyePotentialFeeData.UpgradeItemInfos.Length) + 12));
			selectNeedItemList.StartNeedItemList(dyePotentialFeeData.UpgradeItemInfos.Length);
			NeedItemSelect_ListCtrl.AdjustShowRow(dyePotentialFeeData.UpgradeItemInfos.Length);
			NeedItemSelect_ListCtrl.SetWindowSize(280, (40 * dyePotentialFeeData.UpgradeItemInfos.Length));
			M = 0;
			while((M < dyePotentialFeeData.UpgradeItemInfos.Length))
			{
				selectNeedItemList.AddNeedItemClassID(dyePotentialFeeData.UpgradeItemInfos[M].ItemClassID, INT64(dyePotentialFeeData.UpgradeItemInfos[M].ItemCount));
				M++;
			}
			selectNeedItemList.SetBuyNum(INT64(1));
			if((isPrivateSlotEnchantState() && (parentWindowName != "resultOK")))
			{
				N = 0;
				while((N < saveNeedUpgradeItemInfos.Length))
				{
					saveNeedUpgradeItemInfos[N].ItemClassID = 0;
					N++;
				}
				selectNeedItemIndex = -1;
			}
			bNeedItemChange = false;
			N = 0;
			while((N < saveNeedUpgradeItemInfos.Length))
			{
				if((saveNeedUpgradeItemInfos.Length == dyePotentialFeeData.UpgradeItemInfos.Length))
				{
					if(((saveNeedUpgradeItemInfos[N].ItemClassID != dyePotentialFeeData.UpgradeItemInfos[N].ItemClassID) || (saveNeedUpgradeItemInfos[N].ItemCount != dyePotentialFeeData.UpgradeItemInfos[N].ItemCount)))
					{
						bNeedItemChange = true;
						break;
					}
					N++;
					continue;
				}
				bNeedItemChange = true;
				break;
				N++;
			}
			if((henna_list_packet.cSendType > 0))
			{
				bNeedItemChange = true;
				henna_list_packet.cSendType = 0;
			}
			if((bNeedItemChange == false))
			{
				NeedItemSelectDialog_wnd.HideWindow();
				GetWindowHandle((m_Windowname $ ".NeedItemSelectWnd")).HideWindow();
				Enchant_Btn.EnableWindow();
			}
			else
			{
				NeedItemSelectDialog_wnd.ShowWindow();
				GetWindowHandle((m_Windowname $ ".NeedItemSelectWnd")).ShowWindow();
				Enchant_Btn.DisableWindow();
				NeedItemList.CleariObjects();
				needItemDialogList.CleariObjects();
				selectNeedItemClassID = -1;
				selectNeedItemIndex = -1;
				timeObjectInventoryDelay._Stop();
				Auto_CheckBox.SetCheck(false);
			}
			if((selectNeedItemIndex > -1))
			{
				NeedItemSelect_ListCtrl.SetSelectedIndex(selectNeedItemIndex, false);
				Enchant_Btn.EnableWindow();
			}
			else
			{
				NeedItemSelectDialog_wnd.ShowWindow();
				GetWindowHandle((m_Windowname $ ".NeedItemSelectWnd")).ShowWindow();
				Enchant_Btn.DisableWindow();
			}
			saveNeedUpgradeItemInfos = dyePotentialFeeData.UpgradeItemInfos;
			GetButtonHandle((m_Windowname $ ".NeedItemSelectArrow_btn")).ShowWindow();
		}
	}
	else
	{
		bPublicInitSelectNeedItemState = true;
		Enchant_Btn.HideWindow();
		Reset_Btn.ShowWindow();
		Reset_Btn.SetTooltipCustomType(getCustomTooltipInitRest());
		GetMeTextBox("NeedItemTitle_txt").SetText(GetSystemString(14482));
		GetMeTextBox("NeedItemTitle_txt").ShowWindow();
		GetRichListCtrlHandle((m_Windowname $ ".NeedItemRichListCtrl")).ShowWindow();
		GetTextureHandle((m_Windowname $ ".NeedItemTitleBG_tex")).ShowWindow();
		if((henna_list_packet.resetCostList.Length == 1))
		{
			NeedItemList.CleariObjects();
			NeedItemList.AddNeedItemClassID(henna_list_packet.resetCostList[0].nItemClassID, henna_list_packet.resetCostList[0].nAmount);
			NeedItemList.SetBuyNum(INT64(1));
			selectNeedItemClassID = henna_list_packet.resetCostList[0].nItemClassID;
			GetWindowHandle((m_Windowname $ ".NeedItemSelectWnd")).HideWindow();
			GetButtonHandle((m_Windowname $ ".NeedItemSelectArrow_btn")).HideWindow();
			NeedItemSelectDialog_wnd.HideWindow();
			selectNeedItemIndex = 0;
			if((NeedItemList.GetCanBuy() && ((henna_list_packet.nResetMaxCount == -1) || ((henna_list_packet.nResetMaxCount - henna_list_packet.nResetCount) > 0))))
			{
				Reset_Btn.EnableWindow();
			}
			else
			{
				Reset_Btn.DisableWindow();
			}
		}
		else
		{
			selectNeedItemList.CleariObjects();
			GetMeWindow("NeedItemSelectDialog_wnd").SetWindowSize(284, ((40 * henna_list_packet.resetCostList.Length) + 12));
			selectNeedItemList.StartNeedItemList(henna_list_packet.resetCostList.Length);
			NeedItemSelect_ListCtrl.AdjustShowRow(henna_list_packet.resetCostList.Length);
			NeedItemSelect_ListCtrl.SetWindowSize(280, (40 * henna_list_packet.resetCostList.Length));
			M = 0;
			while((M < henna_list_packet.resetCostList.Length))
			{
				selectNeedItemList.AddNeedItemClassID(henna_list_packet.resetCostList[M].nItemClassID, henna_list_packet.resetCostList[M].nAmount);
				M++;
			}
			GetWindowHandle((m_Windowname $ ".NeedItemSelectWnd")).ShowWindow();
			NeedItemSelectDialog_wnd.ShowWindow();
			selectNeedItemList.SetBuyNum(INT64(1));
			NeedItemList.CleariObjects();
			Reset_Btn.DisableWindow();
			GetButtonHandle((m_Windowname $ ".NeedItemSelectArrow_btn")).ShowWindow();
		}
	}
	if((currentSlotExp > slotExp))
	{
		if((currentSlotExp >= getDyePotentialTotalExp()))
		{
			Enchant_Btn.DisableWindow();
			StatusNumber_txt.SetText("MAX");
			MyEnchant_statusbar.SetGaugeColor(6, GetColor(75, 45, 35, 255));
			MyEnchant_statusbar.SetGaugeColor(7, GetColor(75, 45, 35, 255));
			MyEnchant_statusbar.SetGaugeColor(8, GetColor(75, 45, 35, 255));
		}
		else
		{
			MyEnchant_statusbar.SetGaugeColor(6, GTColor().Orange);
			MyEnchant_statusbar.SetGaugeColor(7, GTColor().Orange);
			MyEnchant_statusbar.SetGaugeColor(8, GTColor().Orange);
		}
	}
	else if((currentSlotExp == getDyePotentialTotalExp()))
	{
		MyEnchant_statusbar.SetGaugeColor(6, GetColor(115, 160, 45, 255));
		MyEnchant_statusbar.SetGaugeColor(7, GetColor(115, 160, 45, 255));
		MyEnchant_statusbar.SetGaugeColor(8, GetColor(115, 160, 45, 255));
		Enchant_Btn.DisableWindow();
		StatusNumber_txt.SetText("MAX");
	}
	else
	{
		MyEnchant_statusbar.SetGaugeColor(6, GetColor(236, 178, 63, 255));
		MyEnchant_statusbar.SetGaugeColor(7, GetColor(236, 178, 63, 255));
		MyEnchant_statusbar.SetGaugeColor(8, GetColor(236, 178, 63, 255));
	}
	pageNavi.SetTotalPage((((getDyePotentialLastLevel() - 1) / 10) + 1));
	nShowPageNum = (((henna_list_packet.hennaInfoList[i].nEnchantStep - 1) / 10) + 1);
	if((parentWindowName == "BreakthroughPopup_OK_Btn"))
	{
		pageChanged(pageNavi.currPage);
	}
	else
	{
		pageNavi.Go(nShowPageNum);
		pageChanged(nShowPageNum);
	}
	return;
}

function CustomTooltip getCustomTooltipInitRest()
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13913), getInstanceL2Util().White, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13914), getInstanceL2Util().White, "", true, true);
	if((henna_list_packet.nResetMaxCount == -1))
	{
		drawListArr[drawListArr.Length] = addDrawItemText(MakeFullSystemMsg(GetSystemMessage(13883), string(henna_list_packet.nResetCount)), getInstanceL2Util().Green, "", true, true);
	}
	else if(((henna_list_packet.nResetMaxCount - henna_list_packet.nResetCount) == 0))
	{
		drawListArr[drawListArr.Length] = addDrawItemText((((((GetSystemString(14479) $ " (") $ string((henna_list_packet.nResetMaxCount - henna_list_packet.nResetCount))) $ "/") $ string(henna_list_packet.nResetMaxCount)) $ ")"), getInstanceL2Util().Red, "", true, true);
	}
	else
	{
		drawListArr[drawListArr.Length] = addDrawItemText((((((GetSystemString(14479) $ " (") $ string((henna_list_packet.nResetMaxCount - henna_list_packet.nResetCount))) $ "/") $ string(henna_list_packet.nResetMaxCount)) $ ")"), getInstanceL2Util().Green, "", true, true);
	}
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 130;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;
}

function DyePotentialFeeUIData getFeeDataProcess()
{
	return getFeeData(henna_list_packet.nDailyStep, henna_list_packet.nDailyCount, (currentSelectSlot + 1), (henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantStep - 1), henna_list_packet.hennaInfoList[currentSelectSlot].nDailyStep);
}

function DyePotentialFeeUIData getFeeData(int nPublicDailyStep, int nPublicDailyCount, int nSlot, int DyePotentialLevel, int nSlotDailyStep)
{
	local DyePotentialFeeUIData rDyePotentialFeeData;

	Class'NWindow.UIDATA_HENNA'.static.GetDyePotentialFeeData(nPublicDailyStep, rDyePotentialFeeData);
	return rDyePotentialFeeData;
}

function OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	if(GetWindowHandle((m_Windowname $ ".EnchantDialog_wnd")).IsShowWindow())
	{
		GetWindowHandle((m_Windowname $ ".EnchantDialog_wnd")).HideWindow();
	}
	HennaMenuWnd(GetScript("HennaMenuWnd")).API_C_EX_NEW_HENNA_LIST();
	WndBG_EffectViewport.SpawnEffect("LineageEffect2.ave_white_trans_deco");
	disableWnd.ShowWindow();
	return;
}

function OnHide()
{
	WndBG_EffectViewport.SpawnEffect("");
	if(GetWindowHandle((m_Windowname $ ".EnchantDialog_wnd.DisableWnd.UIControlDialogAsset")).IsShowWindow())
	{
		GetDialogAssetScript().Hide();
	}
	if(GetMeWindow("UnlockDisableWnd").IsShowWindow())
	{
		OnClickButton("BreakthroughPopup_Cancel_Btn");
	}
	timeObjectInventoryDelay._Stop();
	bPressCancelAutoEnchant = false;
	beforeSelectedOpenSlotCostClassID = 0;
	beforeVReqOpenSlotCostItemList.Length = 0;
	return;
}

event OnClickListCtrlRecord(string strID)
{
	local DyePotentialFeeUIData dyePotentialFeeData;

	if(bPublicInitSelectNeedItemState)
	{
		Debug((("strID" @ strID) @ string(NeedItemSelect_ListCtrl.GetSelectedIndex())));
		selectNeedItemIndex = NeedItemSelect_ListCtrl.GetSelectedIndex();
		NeedItemList.CleariObjects();
		NeedItemList.AddNeedItemClassID(henna_list_packet.resetCostList[selectNeedItemIndex].nItemClassID, henna_list_packet.resetCostList[selectNeedItemIndex].nAmount);
		NeedItemList.SetBuyNum(INT64(1));
		selectNeedItemClassID = henna_list_packet.resetCostList[selectNeedItemIndex].nItemClassID;
		NeedItemSelectDialog_wnd.HideWindow();
		GetWindowHandle((m_Windowname $ ".NeedItemSelectWnd")).HideWindow();
		getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(13874), GetItemNameAll(GetItemInfoByClassID(selectNeedItemClassID))));
		if((NeedItemList.GetCanBuy() && ((henna_list_packet.nResetMaxCount == -1) || ((henna_list_packet.nResetMaxCount - henna_list_packet.nResetCount) > 0))))
		{
			Reset_Btn.EnableWindow();
		}
		else
		{
			Reset_Btn.DisableWindow();
		}
	}
	else
	{
		dyePotentialFeeData = getFeeDataProcess();
		selectNeedItemIndex = NeedItemSelect_ListCtrl.GetSelectedIndex();
		NeedItemList.CleariObjects();
		NeedItemList.AddNeedItemClassID(dyePotentialFeeData.UpgradeItemInfos[selectNeedItemIndex].ItemClassID, INT64(dyePotentialFeeData.UpgradeItemInfos[selectNeedItemIndex].ItemCount));
		NeedItemList.SetBuyNum(INT64(1));
		needItemDialogList.CleariObjects();
		needItemDialogList.AddNeedItemClassID(dyePotentialFeeData.UpgradeItemInfos[selectNeedItemIndex].ItemClassID, INT64(dyePotentialFeeData.UpgradeItemInfos[selectNeedItemIndex].ItemCount));
		needItemDialogList.SetBuyNum(INT64(1));
		selectNeedItemClassID = dyePotentialFeeData.UpgradeItemInfos[selectNeedItemIndex].ItemClassID;
		NeedItemSelectDialog_wnd.HideWindow();
		getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(13658), GetItemNameAll(GetItemInfoByClassID(selectNeedItemClassID))));
		if((StatusNumber_txt.GetText() != "MAX"))
		{
			Enchant_Btn.EnableWindow();
		}
		GetWindowHandle((m_Windowname $ ".NeedItemSelectWnd")).HideWindow();
	}
	return;
}

event OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	groupButtons._selectButtonHandle(a_ButtonHandle);
	if((a_ButtonHandle.GetWindowName() == "UnLock_Btn"))
	{
		OnUnLock_BtnClick(a_ButtonHandle);
	}
	return;
}

function OnUnLock_BtnClick(ButtonHandle a_ButtonHandle)
{
	local int Index;

	if((Left(a_ButtonHandle.GetParentWindowName(), 4) == "Step"))
	{
		Index = int(Mid(a_ButtonHandle.GetParentWindowName(), 4, Len(a_ButtonHandle.GetParentWindowName())));
		if(((henna_list_packet.hennaInfoList[currentSelectSlot].nOpenedSlotStep + 1) == Index))
		{
			API_C_EX_NEW_HENNA_POTEN_OPENSLOT_PROB_INFO(Index);
		}
	}
	return;
}

function CloseUI()
{
	Me.HideWindow();
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "Enchant_BTN":
			OnEnchant_BtnClick();
			GetWindowHandle((m_Windowname $ ".EnchantDialog_wnd")).SetFocus();
			break;
		case "Reset_btn":
			ShowDialogAskPublicCountInit();
			break;
		case "HelpWnd_Btn":
			Debug("ShowHelp -> 69");
			Class'InterfaceClassic.HelpWnd'.static.ShowHelp(69);
			break;
		case "HennaClose_BTN":
			CloseUI();
			break;
		case "EnchantCheck_btn":
			OnEnchantCheck_btnClick();
			break;
		case "EnchantApply_btn":
			OnEnchantApply_btnClick();
			break;
		case "EnchantCancel_btn":
			bPressCancelAutoEnchant = true;
			Me.KillTimer(1010101);
			Me.KillTimer(1010102);
			timeObjectInventoryDelay._Stop();
			OnEnchantCheck_btnClick();
			break;
		case "NeedItemSelectArrow_btn":
			onToggleSelectNeedItem();
			break;
		case "ProbabilityTootip_Btn":
		case "EnchantbtnHelp":
			Class'InterfaceClassic.HelpWnd'.static.ShowHelp(69, 3);
			break;
		case "BreakthroughPopup_Cancel_Btn":
			GetMeWindow("UnlockDisableWnd").HideWindow();
			GetMeWindow("UnlockDisableWnd.UnlockPopup").HideWindow();
			break;
		case "BreakthroughPopup_Ok_Btn":
			Debug("ok 돌파");  // EN?: ok breakthrough
			API_C_EX_NEW_HENNA_POTEN_OPENSLOT(currentSelectSlot, currentOpenSlotStep, NeedItemMultiItems._GetMyClassID());
			break;
		default:
			break;
	}
	return;
}

function onToggleSelectNeedItem()
{
	if(NeedItemSelectDialog_wnd.IsShowWindow())
	{
		NeedItemSelectDialog_wnd.HideWindow();
	}
	else
	{
		NeedItemSelectDialog_wnd.ShowWindow();
	}
	return;
}

event OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	switch(a_WindowHandle)
	{
		case EffectNameSelect_BTN:
			_ShowContextMenu(currentSelectSlot, X, Y);
			break;
		default:
			break;
	}
	return;
}

function _ShowContextMenu(int nCurrentSelectSlot, int X, int Y)
{
	local UIControlContextMenu ContextMenu;
	local int i, SelectedIndex;
	local array<string> effectNames;

	currentSelectSlot = nCurrentSelectSlot;
	Class'NWindow.UIDATA_HENNA'.static.GetDyePotentialDataList((nCurrentSelectSlot + 1), potentialDataArray);
	_GetEffectStrings(nCurrentSelectSlot, effectNames, SelectedIndex);
	ContextMenu = Class'InterfaceClassic.UIControlContextMenu'.static.GetInstance();
	ContextMenu.Clear();
	ContextMenu.DelegateOnClickContextMenu = HandleOnClickContextMenu;
	i = 0;
	while((i < effectNames.Length))
	{
		if((SelectedIndex == i))
		{
			ContextMenu.MenuNew((((effectNames[i] $ " <") $ GetSystemString(218)) $ ">"), i, GTColor().Yellow);
			i++;
			continue;
		}
		ContextMenu.MenuNew(effectNames[i], i, GTColor().White);
		i++;
	}
	ContextMenu.Show(X, Y, string(self));
	return;
}

function _GetEffectStrings(int SlotIndex, out array<string> effectNames, out int selectedNum)
{
	local int i;
	local SkillInfo SkillInfo, currentSkillInfo;
	local string effectNumStr;
	local DyePotentialUIData dyePotentialData;
	local array<DyePotentialUIData> _potentialDataArray;

	Class'NWindow.UIDATA_HENNA'.static.GetDyePotentialDataList((SlotIndex + 1), _potentialDataArray);
	selectedNum = -1;
	i = 0;
	while((i < _potentialDataArray.Length))
	{
		Class'NWindow.UIDATA_HENNA'.static.GetDyePotentialData(henna_list_packet.hennaInfoList[SlotIndex].nPotenID, dyePotentialData);
		GetSkillInfo(_potentialDataArray[i].SkillID, currentActiveSteps[SlotIndex], 0, currentSkillInfo);
		if((currentActiveSteps[SlotIndex] > 0))
		{
			effectNumStr = currentSkillInfo.SkillDesc;
		}
		else
		{
			effectNumStr = "+0";
		}
		GetSkillInfo(_potentialDataArray[i].SkillID, _potentialDataArray[i].MaxSkillLevel, 0, SkillInfo);
		if((dyePotentialData.EffectName == _potentialDataArray[i].EffectName))
		{
			selectedNum = i;
		}
		effectNames[effectNames.Length] = (((_potentialDataArray[i].EffectName @ effectNumStr) $ " / Max:") @ SkillInfo.SkillDesc);
		i++;
	}
	return;
}

function HandleOnClickContextMenu(int Index)
{
	API_C_EX_NEW_HENNA_POTEN_SELECT((currentSelectSlot + 1), potentialDataArray[Index].DyePotentialID);
	return;
}

function OnEnchant_BtnClick()
{
	local DyePotentialFeeUIData dyePotentialFeeData;

	Me.KillTimer(1010101);
	Me.KillTimer(1010102);
	barAniStep = 0;
	barAniCount = 0;
	Auto_CheckBox.EnableWindow();
	bPressCancelAutoEnchant = false;
	playEffect("");
	GetStatusRoundHandle((m_Windowname $ ".EnchantDialog_wnd.LV_StatusRound")).ShowWindow();
	GetStatusRoundHandle((m_Windowname $ ".EnchantDialog_wnd.Enchant_StatusRound")).ShowWindow();
	GetStatusRoundHandle((m_Windowname $ ".EnchantDialog_wnd.EnchantApply_StatusRound")).ShowWindow();
	GetStatusRoundHandle((m_Windowname $ ".EnchantDialog_wnd.LV_StatusRound")).SetPoint(INT64(0), INT64(100));
	GetStatusRoundHandle((m_Windowname $ ".EnchantDialog_wnd.Enchant_StatusRound")).SetPoint(INT64(0), INT64(100));
	GetStatusRoundHandle((m_Windowname $ ".EnchantDialog_wnd.EnchantApply_StatusRound")).SetPoint(INT64(0), INT64(100));
	GetButtonHandle((m_Windowname $ ".EnchantDialog_wnd.EnchantCheck_btn")).HideWindow();
	GetButtonHandle((m_Windowname $ ".EnchantDialog_wnd.EnchantApply_btn")).ShowWindow();
	GetButtonHandle((m_Windowname $ ".EnchantDialog_wnd.EnchantCancel_btn")).ShowWindow();
	GetWindowHandle((m_Windowname $ ".EnchantDialog_wnd.Result_wnd")).HideWindow();
	GetWindowHandle((m_Windowname $ ".EnchantDialog_wnd")).ShowWindow();
	GetTextureHandle((m_Windowname $ ".EnchantDialog_wnd.DiceSwap00")).HideWindow();
	GetTextBoxHandle((m_Windowname $ ".EnchantDialog_wnd.DialogDscrp_txt")).SetText(GetSystemString(13824));
	dyePotentialFeeData = getFeeDataProcess();
	if(isPrivateSlotEnchantState())
	{
		GetTextBoxHandle((m_Windowname $ ".EnchantDialog_wnd.DialogEnchantCountTitle_txt")).SetText(MakeFullSystemMsg(GetSystemMessage(13752), string((currentSelectSlot + 1))));
		GetTextBoxHandle((m_Windowname $ ".EnchantDialog_wnd.DialogEnchantCountTitle_txt")).SetTextColor(GTColor().Green3);
		if((henna_list_packet.hennaInfoList[currentSelectSlot].nDailyCount > 0))
		{
			GetTextBoxHandle((m_Windowname $ ".EnchantDialog_wnd.DialogEnchantCount_txt")).SetTextColor(GTColor().Yellow);
		}
		else
		{
			GetTextBoxHandle((m_Windowname $ ".EnchantDialog_wnd.DialogEnchantCount_txt")).SetTextColor(GTColor().Red);
		}
		GetTextBoxHandle((m_Windowname $ ".EnchantDialog_wnd.DialogEnchantCount_txt")).SetText(((string(henna_list_packet.hennaInfoList[currentSelectSlot].nDailyCount) $ "/") $ string(dyePotentialFeeData.DailyCount)));
	}
	else
	{
		GetTextBoxHandle((m_Windowname $ ".EnchantDialog_wnd.DialogEnchantCountTitle_txt")).SetText(GetSystemString(14205));
		GetTextBoxHandle((m_Windowname $ ".EnchantDialog_wnd.DialogEnchantCountTitle_txt")).SetTextColor(GTColor().BrightWhite);
		if(((henna_list_packet.nDailyCount == 0) && (dyePotentialFeeData.DailyCount == 0)))
		{
			GetTextBoxHandle((m_Windowname $ ".EnchantDialog_wnd.DialogEnchantCount_txt")).SetText(GetSystemString(858));
			GetTextBoxHandle((m_Windowname $ ".EnchantDialog_wnd.DialogEnchantCount_txt")).SetTextColor(GTColor().Yellow);
		}
		else
		{
			GetTextBoxHandle((m_Windowname $ ".EnchantDialog_wnd.DialogEnchantCount_txt")).SetText(((string(henna_list_packet.nDailyCount) $ "/") $ string(dyePotentialFeeData.DailyCount)));
			if((henna_list_packet.nDailyCount > 0))
			{
				GetTextBoxHandle((m_Windowname $ ".EnchantDialog_wnd.DialogEnchantCount_txt")).SetTextColor(GTColor().Yellow);
			}
			else
			{
				GetTextBoxHandle((m_Windowname $ ".EnchantDialog_wnd.DialogEnchantCount_txt")).SetTextColor(GTColor().Red);
			}
		}
	}
	if((((henna_list_packet.nDailyCount == 0) && (henna_list_packet.hennaInfoList[currentSelectSlot].nDailyCount == 0)) || ((henna_list_packet.nDailyCount == 0) && (henna_list_packet.hennaInfoList[currentSelectSlot].nDailyStep == 0))))
	{
		GetTextBoxHandle((m_Windowname $ ".EnchantDialog_wnd.DailyEnchantInfo01_Txt")).ShowWindow();
		GetTextBoxHandle((m_Windowname $ ".EnchantDialog_wnd.DailyEnchantInfo02_Txt")).ShowWindow();
		GetRichListCtrlHandle((m_Windowname $ ".EnchantDialog_wnd.Dialog_NeedItemRichListCtrl")).HideWindow();
		GetRichListCtrlHandle((m_Windowname $ ".EnchantDialog_wnd.Dialog_NeedItemRichListCtrl2")).HideWindow();
		GetTextureHandle((m_Windowname $ ".EnchantDialog_wnd.DialogNeedItmeBG01_tex")).HideWindow();
		GetTextureHandle((m_Windowname $ ".EnchantDialog_wnd.DialogNeedItmeBG02_tex")).HideWindow();
	}
	else
	{
		GetTextBoxHandle((m_Windowname $ ".EnchantDialog_wnd.DailyEnchantInfo01_Txt")).HideWindow();
		GetTextBoxHandle((m_Windowname $ ".EnchantDialog_wnd.DailyEnchantInfo02_Txt")).HideWindow();
		GetRichListCtrlHandle((m_Windowname $ ".EnchantDialog_wnd.Dialog_NeedItemRichListCtrl")).ShowWindow();
		GetRichListCtrlHandle((m_Windowname $ ".EnchantDialog_wnd.Dialog_NeedItemRichListCtrl2")).ShowWindow();
		GetTextureHandle((m_Windowname $ ".EnchantDialog_wnd.DialogNeedItmeBG01_tex")).ShowWindow();
		GetTextureHandle((m_Windowname $ ".EnchantDialog_wnd.DialogNeedItmeBG02_tex")).ShowWindow();
	}
	if(((needItemDialogList.GetCanBuy() && needItemDialogList2.GetCanBuy()) && (((henna_list_packet.nDailyCount > 0) || (henna_list_packet.hennaInfoList[currentSelectSlot].nDailyCount > 0)) || (dyePotentialFeeData.DailyCount == 0))))
	{
		GetButtonHandle((m_Windowname $ ".EnchantDialog_wnd.EnchantApply_btn")).EnableWindow();
	}
	else
	{
		GetButtonHandle((m_Windowname $ ".EnchantDialog_wnd.EnchantApply_btn")).DisableWindow();
	}
	GetStatusRoundHandle((m_Windowname $ ".EnchantDialog_wnd.StepGauge.EnchantApply_StatusRound")).SetPoint(INT64(henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantExp), INT64(getDyePotentialExp(henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantStep).Exp));
	GetStatusRoundHandle((m_Windowname $ ".EnchantDialog_wnd.StepGauge.EnchantApply_StatusRound")).SetTooltipType("text");
	GetStatusRoundHandle((m_Windowname $ ".EnchantDialog_wnd.StepGauge.EnchantApply_StatusRound")).SetTooltipCustomType(MakeTooltipSimpleColorText(((string(henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantExp) $ "/") $ string(getDyePotentialExp(henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantStep).Exp)), GTColor().BWhite));
	GetTextBoxHandle((m_Windowname $ ".EnchantDialog_wnd.ProgressCount_txt")).SetText(MakeFullSystemMsg(GetSystemMessage(5203), string((henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantStep - 1))));
	return;
}

function OnEnchantApply_btnClick()
{
	GetButtonHandle((m_Windowname $ ".EnchantDialog_wnd.EnchantApply_btn")).DisableWindow();
	GetTextureHandle((m_Windowname $ ".EnchantDialog_wnd.DiceSwap00")).ShowWindow();
	GetTextBoxHandle((m_Windowname $ ".EnchantDialog_wnd.DialogDscrp_txt")).SetText(GetSystemString(13823));
	GetRichListCtrlHandle((m_Windowname $ ".EnchantDialog_wnd.Dialog_NeedItemRichListCtrl")).HideWindow();
	GetRichListCtrlHandle((m_Windowname $ ".EnchantDialog_wnd.Dialog_NeedItemRichListCtrl2")).HideWindow();
	GetTextureHandle((m_Windowname $ ".EnchantDialog_wnd.DialogNeedItmeBG01_tex")).HideWindow();
	GetTextureHandle((m_Windowname $ ".EnchantDialog_wnd.DialogNeedItmeBG02_tex")).HideWindow();
	Auto_CheckBox.DisableWindow();
	timeResultCount = 0;
	Me.SetTimer(1010101, 50);
	Me.SetTimer(1010102, 10);
	playEffect("LineageEffect2.ave_white_trans_deco");
	PlaySound("InterfaceSound.MagicLamp_Start");
	return;
}

function playEffect(string effectPath)
{
	currentEffectPath = effectPath;
	GetEffectViewportWndHandle((m_Windowname $ ".Result_EffectViewport")).SpawnEffect(effectPath);
	return;
}

function OnTimer(int TimerID)
{
	local int R;

	if((TimerID == 1010101))
	{
		timeResultCount++;
		R = getRandomRange();
		if((nLastRandomNum == R))
		{
			R = getRandomRange();
		}
		GetTextureHandle((m_Windowname $ ".EnchantDialog_wnd.DiceSwap00")).SetTexture(("L2UI_NewTex.etc.Hn_Num" $ string(R)));
		nLastRandomNum = R;
		if((timeResultCount > 3))
		{
			API_C_EX_NEW_HENNA_POTEN_ENCHANT((currentSelectSlot + 1), selectNeedItemClassID);
			Me.KillTimer(TimerID);
		}
	}
	if((TimerID == 1010102))
	{
		barAniCount = (barAniCount + 1);
		GetStatusRoundHandle((m_Windowname $ ".EnchantDialog_wnd.EnchantApply_StatusRound")).SetPoint(INT64(barAniCount), INT64(20));
		GetStatusRoundHandle((m_Windowname $ ".EnchantDialog_wnd.LV_StatusRound")).SetPoint(INT64(barAniCount), INT64(20));
		if((barAniCount >= 20))
		{
			barAniStep = 0;
			barAniCount = 0;
			Me.KillTimer(TimerID);
		}
	}
	return;
}

function int getRandomRange()
{
	local int R, Len;

	Len = dyePotentialFeeData.EnchantExps.Length;
	R = Rand(Len);
	return dyePotentialFeeData.EnchantExps[R].Exp;
}

function OnEnchantCheck_btnClick()
{
	OnEnchantCancel_btnClick();
	setLeftSlotButtonRefresh();
	groupButtonOnClickButton("resultOK", "", currentSelectSlot);
	return;
}

function OnEnchantCancel_btnClick()
{
	GetWindowHandle((m_Windowname $ ".EnchantDialog_wnd")).HideWindow();
	GetTextureHandle((m_Windowname $ ".EnchantDialog_wnd.DiceSwap00")).HideWindow();
	if((currentEffectPath == "LineageEffect2.ave_white_trans_deco"))
	{
		playEffect("");
	}
	Me.KillTimer(1010101);
	Me.KillTimer(1010102);
	return;
}

function OnEvent(int a_EventID, string param)
{
	switch(a_EventID)
	{
		case (100000 + 982):
			ParsePacket_S_EX_NEW_HENNA_LIST();
			break;
		case (100000 + 986):
			ParsePacket_S_EX_NEW_HENNA_POTEN_ENCHANT();
			break;
		case (100000 + 985):
			ParsePacket_S_EX_NEW_HENNA_POTEN_SELECT();
			break;
		case (100000 + 1106):
			parsepacket_s_ex_new_henna_poten_enchant_reset();
			break;
		case (100000 + 1178):
			ParsePacket_S_EX_NEW_HENNA_POTEN_OPENSLOT_PROB_INFO();
			break;
		case (100000 + 1179):
			ParsePacket_S_EX_NEW_HENNA_POTEN_OPENSLOT();
			break;
		case 11582:
			if(!IsPotentialServer())
			{
				return;
			}
			Me.ShowWindow();
			Me.SetFocus();
			break;
		case 40:
		case 9750:
			MyEnchant_PrvLv_txt.SetText("");
			MyEnchant_NextLv_txt.SetText("");
			selectNeedItemClassID = -1;
			selectNeedItemIndex = -1;
			saveNeedUpgradeItemInfos.Length = 0;
			initPotenSelectArray[0] = 0;
			initPotenSelectArray[1] = 0;
			initPotenSelectArray[2] = 0;
			initPotenSelectArray[3] = 0;
			break;
		default:
			break;
	}
	return;
}

function ParsePacket_S_EX_NEW_HENNA_POTEN_OPENSLOT_PROB_INFO()
{
	local UIPacket._S_EX_NEW_HENNA_POTEN_OPENSLOT_PROB_INFO packet;
	local int i;
	local bool bBeforeNoSameCostItem;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_NEW_HENNA_POTEN_OPENSLOT_PROB_INFO(packet))
	{
		return;
	}
	Debug((("---> S_EX_NEW_HENNA_POTEN_OPENSLOT_PROB_INFO" @ string(packet.nReqOpenSlotStep)) @ string(packet.nReqOpenSlotProb)));
	if(((packet.nReqOpenSlotProb == 10000) && (packet.vReqOpenSlotCostItemList.Length == 0)))
	{
		API_C_EX_NEW_HENNA_POTEN_OPENSLOT(currentSelectSlot, packet.nReqOpenSlotStep, 0);
	}
	else
	{
		currentOpenSlotStep = packet.nReqOpenSlotStep;
		GetMeWindow("UnlockDisableWnd").ShowWindow();
		GetMeWindow("UnlockDisableWnd.UnlockPopup").ShowWindow();
		GetMeWindow("UnlockDisableWnd.UnlockPopup").SetFocus();
		GetMeTextBox("UnlockDisableWnd.UnlockPopup.Probability_txt").SetText((GetSystemString(14623) $ getInstanceL2Util().MakeDecimalPointString(string(packet.nReqOpenSlotProb), 2, true, true)));
		Debug(("packet.vReqOpenSlotCostItemList.length" @ string(packet.vReqOpenSlotCostItemList.Length)));
		NeedItemMultiItems._StartSelectItems(packet.vReqOpenSlotCostItemList.Length);
		i = 0;
		while((i < packet.vReqOpenSlotCostItemList.Length))
		{
			Debug((("vReqOpenSlotCostItemList i " @ string(packet.vReqOpenSlotCostItemList[i].nItemClassID)) @ string(packet.vReqOpenSlotCostItemList[i].nAmount)));
			NeedItemMultiItems._AddSelectItemClassID(packet.vReqOpenSlotCostItemList[i].nItemClassID, packet.vReqOpenSlotCostItemList[i].nAmount);
			Debug((("beforeVReqOpenSlotCostItemList[i]" @ string(beforeVReqOpenSlotCostItemList[i].nItemClassID)) @ string(beforeVReqOpenSlotCostItemList[i].nAmount)));
			Debug((("vReqOpenSlotCostItemList[i]" @ string(packet.vReqOpenSlotCostItemList[i].nItemClassID)) @ string(packet.vReqOpenSlotCostItemList[i].nAmount)));
			if((beforeVReqOpenSlotCostItemList.Length == packet.vReqOpenSlotCostItemList.Length))
			{
				if(((beforeVReqOpenSlotCostItemList[i].nItemClassID == packet.vReqOpenSlotCostItemList[i].nItemClassID) && (beforeVReqOpenSlotCostItemList[i].nAmount == packet.vReqOpenSlotCostItemList[i].nAmount)))
				{
				}
				else
				{
					bBeforeNoSameCostItem = true;
				}
				i++;
				continue;
			}
			bBeforeNoSameCostItem = true;
			i++;
		}
		NeedItemMultiItems._EndSelectItems();
		if(NeedItemMultiItems._GetCanBuy())
		{
			GetMeButton("UnlockDisableWnd.UnlockPopup.BreakthroughPopup_OK_Btn").EnableWindow();
		}
		else
		{
			GetMeButton("UnlockDisableWnd.UnlockPopup.BreakthroughPopup_OK_Btn").DisableWindow();
		}
		beforeVReqOpenSlotCostItemList = packet.vReqOpenSlotCostItemList;
	}
	return;
}

function ParsePacket_S_EX_NEW_HENNA_POTEN_OPENSLOT()
{
	local UIPacket._S_EX_NEW_HENNA_POTEN_OPENSLOT packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_NEW_HENNA_POTEN_OPENSLOT(packet))
	{
		return;
	}
	Debug((((("---> S_EX_NEW_HENNA_POTEN_OPENSLOT" @ string(packet.nResult)) @ string(packet.nSlotID)) @ string(packet.nOpenedSlotStep)) @ string(packet.nActiveStep)));
	henna_list_packet.hennaInfoList[(packet.nSlotID - 1)].nOpenedSlotStep = packet.nOpenedSlotStep;
	henna_list_packet.hennaInfoList[(packet.nSlotID - 1)].nActiveStep = packet.nActiveStep;
	setLeftSlotButtonRefresh();
	groupButtonOnClickButton("BreakthroughPopup_OK_Btn", "", currentSelectSlot);
	GetMeWindow("UnlockDisableWnd").HideWindow();
	GetMeWindow("UnlockDisableWnd.UnlockPopup").HideWindow();
	if((packet.nResult > 0))
	{
		UnLockResultEffectViewport.SetScale(2.0000000);
		UnLockResultEffectViewport.SpawnEffect("LineageEffect2.ui_Enchant_great_success");
		PlaySound("Itemsound3.ui_enchant_great_success");
		AddSystemMessage(14046);
		beforeSelectedOpenSlotCostClassID = 0;
		beforeVReqOpenSlotCostItemList.Length = 0;
	}
	else
	{
		UnLockResultEffectViewport.SetScale(1.0000000);
		UnLockResultEffectViewport.SpawnEffect("LineageEffect2.ui_upgrade_fail");
		PlaySound("Itemsound3.ui_enchant_fail_sfx");
		AddSystemMessage(14047);
	}
	return;
}

function parsepacket_s_ex_new_henna_poten_enchant_reset()
{
	local UIPacket._S_EX_NEW_HENNA_POTEN_ENCHANT_RESET packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_NEW_HENNA_POTEN_ENCHANT_RESET(packet))
	{
		return;
	}
	Debug(("---> s_ex_new_henna_poten_enchant_reset" @ string(packet.cSuccess)));
	if((packet.cSuccess > 0))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13871));
		L2UITween(GetScript("l2UITween")).StartShake("HennaEnchantWnd", 6, 1000, small, 0, 112);
	}
	else
	{
		Debug("---> 잠재력 초기화 오류 발생, 창 닫음");  // EN?: --- > Potential reset error, window closed
		Me.HideWindow();
	}
	return;
}

function ParsePacket_S_EX_NEW_HENNA_POTEN_SELECT()
{
	local UIPacket._S_EX_NEW_HENNA_POTEN_SELECT packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_NEW_HENNA_POTEN_SELECT(packet))
	{
		return;
	}
	Debug((((("---> S_EX_NEW_HENNA_POTEN_SELECT" @ string(packet.cSlotID)) @ string(packet.nPotenID)) @ string(packet.nActiveStep)) @ string(packet.cSuccess)));
	if((packet.cSuccess > 0))
	{
		henna_list_packet.hennaInfoList[currentSelectSlot].nPotenID = packet.nPotenID;
		henna_list_packet.hennaInfoList[currentSelectSlot].nActiveStep = packet.nActiveStep;
		setLeftSlotButtonRefresh();
		groupButtonOnClickButton("", "", currentSelectSlot);
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13453));
	}
	InventoryWnd(GetScript("InventoryWnd"))._Handle_S_EX_NEW_HENNA_POTEN_SELECT(packet);
	return;
}

function ParsePacket_S_EX_NEW_HENNA_POTEN_ENCHANT()
{
	local UIPacket._S_EX_NEW_HENNA_POTEN_ENCHANT packet;
	local int resultExp, currentStepMaxExp, tempExp;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_NEW_HENNA_POTEN_ENCHANT(packet))
	{
		return;
	}
	Debug(((((((((("---> S_EX_NEW_HENNA_POTEN_ENCHANT" @ string(packet.cSlotID)) @ string(packet.nActiveStep)) @ string(packet.nEnchantStep)) @ string(packet.nEnchantExp)) @ string(packet.nDailyStep)) @ string(packet.nDailyCount)) @ string(packet.cSuccess)) @ string(packet.nSlotDailyStep)) @ string(packet.nSlotDailyCount)));
	Debug(("currentSelectSlot" @ string(currentSelectSlot)));
	Me.KillTimer(1010101);
	Me.KillTimer(1010102);
	currentActiveSteps.Length = henna_list_packet.hennaInfoList.Length;
	if((henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantStep == packet.nEnchantStep))
	{
		resultExp = (packet.nEnchantExp - henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantExp);
	}
	else
	{
		currentStepMaxExp = getDyePotentialExp(henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantStep).Exp;
		tempExp = (currentStepMaxExp - henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantExp);
		resultExp = (tempExp + packet.nEnchantExp);
		InventoryWnd(GetScript("InventoryWnd"))._ResetbRequestHennaOnShow();
	}
	henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantStep = packet.nEnchantStep;
	henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantExp = packet.nEnchantExp;
	henna_list_packet.hennaInfoList[currentSelectSlot].nActiveStep = packet.nActiveStep;
	Debug(("강화 값" @ string(henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantStep)));  // EN?: Enhancement value
	henna_list_packet.hennaInfoList[currentSelectSlot].nDailyStep = packet.nSlotDailyStep;
	henna_list_packet.hennaInfoList[currentSelectSlot].nDailyCount = packet.nSlotDailyCount;
	henna_list_packet.nDailyStep = packet.nDailyStep;
	henna_list_packet.nDailyCount = packet.nDailyCount;
	GetStatusRoundHandle((m_Windowname $ ".EnchantDialog_wnd.LV_StatusRound")).HideWindow();
	GetStatusRoundHandle((m_Windowname $ ".EnchantDialog_wnd.Enchant_StatusRound")).HideWindow();
	GetStatusRoundHandle((m_Windowname $ ".EnchantDialog_wnd.EnchantApply_StatusRound")).HideWindow();
	GetWindowHandle((m_Windowname $ ".EnchantDialog_wnd.Result_wnd")).ShowWindow();
	GetTextBoxHandle((m_Windowname $ ".EnchantDialog_wnd.Result_wnd.ResultValueEffect_txt")).SetText(((GetSystemString(13822) $ "+") $ string(resultExp)));
	GetTextureHandle((m_Windowname $ ".EnchantDialog_wnd.DiceSwap00")).SetTexture(("L2UI_NewTex.etc.Hn_Num" $ string(resultExp)));
	GetTextBoxHandle((m_Windowname $ ".EnchantDialog_wnd.DialogDscrp_txt")).SetText("");
	if((packet.cSuccess > 0))
	{
		if((resultExp <= 0))
		{
			GetTextBoxHandle((m_Windowname $ ".EnchantDialog_wnd.Result_wnd.ResultValue_txt")).SetText(GetSystemString(13821));
			playEffect("LineageEffect2.ui_upgrade_fail");
			PlaySound("ItemSound3.enchant_fail");
		}
		else if((dyePotentialFeeData.EnchantExps[(dyePotentialFeeData.EnchantExps.Length - 1)].Exp == resultExp))
		{
			GetTextBoxHandle((m_Windowname $ ".EnchantDialog_wnd.Result_wnd.ResultValue_txt")).SetText(GetSystemString(13819));
			playEffect("LineageEffect.d_firework_b");
			PlaySound("ItemSound2.C3_Firework_explosion");
		}
		else
		{
			GetTextBoxHandle((m_Windowname $ ".EnchantDialog_wnd.Result_wnd.ResultValue_txt")).SetText(GetSystemString(13820));
			playEffect("LineageEffect2.ui_upgrade_succ");
			PlaySound("ItemSound3.enchant_success");
		}
		GetStatusRoundHandle((m_Windowname $ ".EnchantDialog_wnd.StepGauge.EnchantApply_StatusRound")).SetPoint(INT64(henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantExp), INT64(getDyePotentialExp(henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantStep).Exp));
		GetStatusRoundHandle((m_Windowname $ ".EnchantDialog_wnd.StepGauge.EnchantApply_StatusRound")).SetTooltipType("text");
		GetStatusRoundHandle((m_Windowname $ ".EnchantDialog_wnd.StepGauge.EnchantApply_StatusRound")).SetTooltipCustomType(MakeTooltipSimpleColorText(((string(henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantExp) $ "/") $ string(getDyePotentialExp(henna_list_packet.hennaInfoList[currentSelectSlot].nEnchantStep).Exp)), GTColor().BWhite));
		Debug(("강화 시도---------------" @ string(Auto_CheckBox.IsChecked())));  // EN?: Enhancement Attempt---------------
		if(((Auto_CheckBox.IsChecked() && (bPressCancelAutoEnchant == false)) && (henna_list_packet.nDailyCount > 0)))
		{
			timeObjectInventoryDelay._Stop();
			timeObjectInventoryDelay._Play();
			GetButtonHandle((m_Windowname $ ".EnchantDialog_wnd.EnchantCheck_btn")).HideWindow();
			GetButtonHandle((m_Windowname $ ".EnchantDialog_wnd.EnchantApply_btn")).ShowWindow();
			GetButtonHandle((m_Windowname $ ".EnchantDialog_wnd.EnchantCancel_btn")).ShowWindow();
		}
		else
		{
			timeObjectInventoryDelay._Stop();
			GetButtonHandle((m_Windowname $ ".EnchantDialog_wnd.EnchantCheck_btn")).ShowWindow();
			GetButtonHandle((m_Windowname $ ".EnchantDialog_wnd.EnchantApply_btn")).HideWindow();
			GetButtonHandle((m_Windowname $ ".EnchantDialog_wnd.EnchantCancel_btn")).HideWindow();
		}
		dyePotentialFeeData = getFeeDataProcess();
		if(((henna_list_packet.nDailyCount == 0) && (dyePotentialFeeData.DailyCount == 0)))
		{
			GetTextBoxHandle((m_Windowname $ ".EnchantDialog_wnd.DialogEnchantCount_txt")).SetText(GetSystemString(858));
			GetTextBoxHandle((m_Windowname $ ".EnchantDialog_wnd.DialogEnchantCount_txt")).SetTextColor(GTColor().Yellow);
		}
		else
		{
			GetTextBoxHandle((m_Windowname $ ".EnchantDialog_wnd.DialogEnchantCount_txt")).SetText(((string(henna_list_packet.nDailyCount) $ "/") $ string(dyePotentialFeeData.DailyCount)));
			if((henna_list_packet.nDailyCount > 0))
			{
				GetTextBoxHandle((m_Windowname $ ".EnchantDialog_wnd.DialogEnchantCount_txt")).SetTextColor(GTColor().Yellow);
			}
			else
			{
				GetTextBoxHandle((m_Windowname $ ".EnchantDialog_wnd.DialogEnchantCount_txt")).SetTextColor(GTColor().Red);
			}
		}
	}
	else
	{
		if(Auto_CheckBox.IsChecked())
		{
			timeObjectInventoryDelay._Stop();
		}
		OnEnchantCheck_btnClick();
		Me.HideWindow();
	}
	return;
}

function ParsePacket_S_EX_NEW_HENNA_LIST()
{
	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_NEW_HENNA_LIST(henna_list_packet))
	{
		return;
	}
	SetCurrentActiveSteps();
	InventoryWnd(GetScript("InventoryWnd"))._Handle_S_EX_NEW_HENNA_LIST(henna_list_packet);
	if(!Me.IsShowWindow())
	{
		return;
	}
	disableWnd.HideWindow();
	Debug("--> 패킷 업데이트 : ParsePacket_S_EX_NEW_HENNA_LIST");  // EN?: -- > packet update: ParsePacket_S_EX_new_Henna_list
	setLeftSlotButtonRefresh();
	if((henna_list_packet.cSendType > 0))
	{
		Debug(("==> 공용 단계 초기화 완료 " @ string(henna_list_packet.cSendType)));  // EN?: = = > Public phase reset complete
		OnEnchantCancel_btnClick();
		groupButtonOnClickButton("", "", currentSelectSlot);
	}
	else
	{
		groupButtons._setTopOrder(0);
	}
	return;
}

function CustomTooltip getTooltipCustomQuestionMark()
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;

	if(isPrivateSlotEnchantState())
	{
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14207), getInstanceL2Util().BrightWhite, "", true, false);
	}
	else
	{
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14206), getInstanceL2Util().BrightWhite, "", true, false);
	}
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip();
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13916), getInstanceL2Util().BrightWhite, "", true, false);
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 200;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;
}

function CustomTooltip getMainSlotCustomTooltip(int Level)
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;
	local SkillInfo SkillInfo;
	local DyePotentialUIData dyePotentialData;

	Class'NWindow.UIDATA_HENNA'.static.GetDyePotentialData(henna_list_packet.hennaInfoList[currentSelectSlot].nPotenID, dyePotentialData);
	GetSkillInfo(dyePotentialData.SkillID, Level, 0, SkillInfo);
	drawListArr[drawListArr.Length] = addDrawItemText((GetSystemString(13889) @ string(getDyePotentialAccrueExp(Level))), getInstanceL2Util().Green, "", true, true);
	if((Len(SkillInfo.SkillDesc) > 0))
	{
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		if((henna_list_packet.hennaInfoList[currentSelectSlot].nActiveStep >= Level))
		{
			drawListArr[drawListArr.Length] = addDrawItemText((("<" $ GetSystemString(13491)) $ ">"), getInstanceL2Util().Yellow, "", true, true);
			drawListArr[drawListArr.Length] = addDrawItemText((dyePotentialData.EffectName @ SkillInfo.SkillDesc), getInstanceL2Util().Yellow, "", true, true);
		}
		else
		{
			drawListArr[drawListArr.Length] = addDrawItemText((("<" $ GetSystemString(13491)) $ ">"), getInstanceL2Util().Gray, "", true, true);
			drawListArr[drawListArr.Length] = addDrawItemText((dyePotentialData.EffectName @ SkillInfo.SkillDesc), getInstanceL2Util().Gray, "", true, true);
		}
	}
	if((henna_list_packet.hennaInfoList[currentSelectSlot].nOpenedSlotStep < 30))
	{
		if((Level == (henna_list_packet.hennaInfoList[currentSelectSlot].nOpenedSlotStep + 1)))
		{
			drawListArr[drawListArr.Length] = addDrawItemBlank(4);
			drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
			drawListArr[drawListArr.Length] = addDrawItemBlank(4);
			drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14838), getInstanceL2Util().Yellow, "hs11", true, true);
		}
	}
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 130;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;
}

function CustomTooltip GetPotentialButtonCustomTooltip(int SlotNum, string EffectName, string effectNum)
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;
	local int MinimumWidth;

	if((henna_list_packet.hennaInfoList[SlotNum].cActive <= 0))
	{
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14594), getInstanceL2Util().Yellow, "", true, false);
		MinimumWidth = 200;
	}
	else
	{
		drawListArr[drawListArr.Length] = addDrawItemText(MakeFullSystemMsg(GetSystemMessage(14044), string((SlotNum + 1))), getInstanceL2Util().BrightWhite, "hs12", true, true);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = addDrawItemText(MakeFullSystemMsg(GetSystemMessage(5203), string(henna_list_packet.hennaInfoList[SlotNum].nActiveStep)), getInstanceL2Util().BrightWhite, "hs12", true, true);
		MinimumWidth = 50;
		if((EffectName != ""))
		{
			drawListArr[drawListArr.Length] = addDrawItemBlank(4);
			drawListArr[drawListArr.Length] = addDrawItemText((EffectName @ effectNum), getInstanceL2Util().BrightWhite, "", true, true);
		}
	}
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = MinimumWidth;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;
}

function CustomTooltip getTooltipCustomSuccessPercent()
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;
	local int Len, i;
	local string expStr;

	dyePotentialFeeData = getFeeDataProcess();
	Len = dyePotentialFeeData.EnchantExps.Length;
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13909), getInstanceL2Util().BrightWhite, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	i = i;
	while((i < Len))
	{
		if((dyePotentialFeeData.EnchantExps[i].Exp == 0))
		{
			expStr = string(dyePotentialFeeData.EnchantExps[i].Exp);
		}
		else
		{
			expStr = ("+" $ string(dyePotentialFeeData.EnchantExps[i].Exp));
		}
		drawListArr[drawListArr.Length] = addDrawItemText((expStr $ " : "), getInstanceL2Util().BrightWhite, "", true, false);
		drawListArr[drawListArr.Length] = addDrawItemText((string(dyePotentialFeeData.EnchantExps[i].Prob) $ "%"), getInstanceL2Util().Yellow, "", false, false);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		i++;
	}
	drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13916), getInstanceL2Util().BrightWhite, "", true, false);
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 130;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;
}

function bool isPrivateSlotEnchantState()
{
	local DyePotentialFeeUIData rDyePotentialFeeData;

	rDyePotentialFeeData = getFeeDataProcess();
	if(((((((henna_list_packet.nDailyCount == 0) && (henna_list_packet.hennaInfoList[currentSelectSlot].nDailyStep != 0)) && (rDyePotentialFeeData.DailyCount != 0)) && ((henna_list_packet.nResetMaxCount - henna_list_packet.nResetCount) == 0)) && (henna_list_packet.nResetMaxCount != -1)) && (henna_list_packet.nResetMaxCount == 0)))
	{
		return true;
	}
	return false;
}

function setLeftSlotButtonRefresh()
{
	local DyePotentialUIData dyePotentialData;
	local int i;
	local SkillInfo SkillInfo;
	local string effectNameStr, effectNumStr;

	i = 0;
	while((i < henna_list_packet.hennaInfoList.Length))
	{
		if((henna_list_packet.hennaInfoList[i].cActive > 0))
		{
			if((henna_list_packet.hennaInfoList[i].nActiveStep > 0))
			{
				GetTextureHandle((((m_Windowname $ ".Category0") $ string((i + 1))) $ "_wnd.Empty_Tex")).SetTexture("L2UI_EPIC.HennaClassicWnd.imprintDeco_Small");
			}
			else
			{
				GetTextureHandle((((m_Windowname $ ".Category0") $ string((i + 1))) $ "_wnd.Empty_Tex")).SetTexture("L2UI_EPIC.HennaClassicWnd.imprintDeco_Small2");
			}
			groupButtons._SetEnable(i);
		}
		else
		{
			GetTextureHandle((((m_Windowname $ ".Category0") $ string((i + 1))) $ "_wnd.Empty_Tex")).SetTexture("L2UI_EPIC.HennaClassicWnd.imprintDeco_Lock");
			groupButtons._SetDisable(i);
		}
		setCircleBarRefresh(i, GetStatusRoundHandle((((m_Windowname $ ".Category0") $ string((i + 1))) $ "_wnd.LV_StatusRound")), GetStatusRoundHandle((((m_Windowname $ ".Category0") $ string((i + 1))) $ "_wnd.Enchant_StatusRound")), GetStatusRoundHandle((((m_Windowname $ ".Category0") $ string((i + 1))) $ "_wnd.EnchantApply_StatusRound")));
		if((henna_list_packet.hennaInfoList[i].nPotenID > 0))
		{
			Class'NWindow.UIDATA_HENNA'.static.GetDyePotentialData(henna_list_packet.hennaInfoList[i].nPotenID, dyePotentialData);
			effectNameStr = dyePotentialData.EffectName;
			GetSkillInfo(dyePotentialData.SkillID, henna_list_packet.hennaInfoList[i].nActiveStep, 0, SkillInfo);
			if((henna_list_packet.hennaInfoList[i].nActiveStep > 0))
			{
				effectNumStr = SkillInfo.SkillDesc;
			}
			else
			{
				effectNumStr = "+0";
			}
		}
		else
		{
			effectNameStr = "";
			effectNumStr = "";
		}
		GetButtonHandle((((m_Windowname $ ".Category0") $ string((i + 1))) $ "_wnd.Category_BTN")).SetTooltipCustomType(GetPotentialButtonCustomTooltip(i, effectNameStr, effectNumStr));
		i++;
	}
	return;
}

function setCircleBarRefresh(int i, StatusRoundHandle LV_StatusRound, StatusRoundHandle Enchant_StatusRound, StatusRoundHandle EnchantApply_StatusRound)
{
	local int dyeItemlevel, slotExp, currentSlotExp;

	dyeItemlevel = henna_list_packet.hennaInfoList[i].nOpenedSlotStep;
	LV_StatusRound.SetPoint(INT64(getDyePotentialAccrueExp(dyeItemlevel)), INT64(getDyePotentialTotalExp()));
	currentSlotExp = (getDyePotentialAccrueExp((henna_list_packet.hennaInfoList[i].nEnchantStep - 1)) + henna_list_packet.hennaInfoList[i].nEnchantExp);
	slotExp = getDyePotentialAccrueExp(dyeItemlevel);
	if((currentSlotExp > slotExp))
	{
		EnchantApply_StatusRound.SetPoint(INT64(slotExp), INT64(getDyePotentialTotalExp()));
	}
	else
	{
		EnchantApply_StatusRound.SetPoint(INT64(currentSlotExp), INT64(getDyePotentialTotalExp()));
	}
	Enchant_StatusRound.SetPoint(INT64(currentSlotExp), INT64(getDyePotentialTotalExp()));
	return;
}

function int getDyePotentialAccrueExp(int nPotentialExpStep)
{
	local array<DyePotentialExpUIData> dyePotentialExpArray;
	local int i, sumExp;

	Class'NWindow.UIDATA_HENNA'.static.GetDyePotentialExpDataList(dyePotentialExpArray);
	i = 0;
	while((i < dyePotentialExpArray.Length))
	{
		if((dyePotentialExpArray[i].DyePotentialLevel <= nPotentialExpStep))
		{
			sumExp = (dyePotentialExpArray[i].Exp + sumExp);
		}
		i++;
	}
	return sumExp;
}

function DyePotentialExpUIData getDyePotentialExp(int nPotentialExpStep)
{
	local array<DyePotentialExpUIData> dyePotentialExpArray;
	local int i;

	Class'NWindow.UIDATA_HENNA'.static.GetDyePotentialExpDataList(dyePotentialExpArray);
	i = 0;
	while((i < dyePotentialExpArray.Length))
	{
		if((dyePotentialExpArray[i].DyePotentialLevel == nPotentialExpStep))
		{
			return dyePotentialExpArray[i];
		}
		i++;
	}
	return dyePotentialExpArray[nPotentialExpStep];
}

function int getDyePotentialTotalExp()
{
	local array<DyePotentialExpUIData> dyePotentialExpArray;
	local int totalExp, i;

	Class'NWindow.UIDATA_HENNA'.static.GetDyePotentialExpDataList(dyePotentialExpArray);
	i = 0;
	while((i < dyePotentialExpArray.Length))
	{
		totalExp = (totalExp + dyePotentialExpArray[i].Exp);
		i++;
	}
	return totalExp;
}

function int getDyePotentialLastLevel()
{
	local array<DyePotentialExpUIData> dyePotentialExpArray;

	Class'NWindow.UIDATA_HENNA'.static.GetDyePotentialExpDataList(dyePotentialExpArray);
	return dyePotentialExpArray[(dyePotentialExpArray.Length - 1)].DyePotentialLevel;
}

function API_C_EX_NEW_HENNA_POTEN_SELECT(int nSlotID, int nPotenID)
{
	local array<byte> stream;
	local UIPacket._C_EX_NEW_HENNA_POTEN_SELECT packet;

	packet.cSlotID = nSlotID;
	packet.nPotenID = nPotenID;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_NEW_HENNA_POTEN_SELECT(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(749, stream);
	Debug((("Api Call -----> C_EX_NEW_HENNA_POTEN_SELECT" @ string(packet.cSlotID)) @ string(packet.nPotenID)));
	return;
}

function API_C_EX_NEW_HENNA_POTEN_ENCHANT(int nSlotID, int costItemID)
{
	local array<byte> stream;
	local UIPacket._C_EX_NEW_HENNA_POTEN_ENCHANT packet;

	packet.cSlotID = nSlotID;
	packet.costItemID = costItemID;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_NEW_HENNA_POTEN_ENCHANT(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(750, stream);
	Debug((("Api Call -----> C_EX_NEW_HENNA_POTEN_ENCHANT" @ string(packet.cSlotID)) @ string(packet.costItemID)));
	return;
}

function API_C_EX_NEW_HENNA_POTEN_OPENSLOT(int nSlotID, int nReqOpenSlotStep, int nCostItemClassID)
{
	local array<byte> stream;
	local UIPacket._C_EX_NEW_HENNA_POTEN_OPENSLOT packet;

	packet.nSlotID = (nSlotID + 1);
	packet.nReqOpenSlotStep = nReqOpenSlotStep;
	packet.nCostItemClassID = nCostItemClassID;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_NEW_HENNA_POTEN_OPENSLOT(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(906, stream);
	Debug(((("Api Call -----> C_EX_NEW_HENNA_POTEN_OPENSLOT" @ string(packet.nSlotID)) @ string(packet.nReqOpenSlotStep)) @ string(packet.nCostItemClassID)));
	InventoryWnd(GetScript("InventoryWnd"))._ResetbRequestHennaOnShow();
	return;
}

function API_C_EX_NEW_HENNA_POTEN_OPENSLOT_PROB_INFO(int nReqOpenSlotStep)
{
	local array<byte> stream;
	local UIPacket._C_EX_NEW_HENNA_POTEN_OPENSLOT_PROB_INFO packet;

	packet.nReqOpenSlotStep = nReqOpenSlotStep;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_NEW_HENNA_POTEN_OPENSLOT_PROB_INFO(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(905, stream);
	Debug(("Api Call -----> C_EX_NEW_HENNA_POTEN_OPENSLOT_PROB_INFO" @ string(packet.nReqOpenSlotStep)));
	return;
}

function API_C_EX_NEW_HENNA_POTEN_ENCHANT_RESET(int costItemID)
{
	local array<byte> stream;
	local UIPacket._C_EX_NEW_HENNA_POTEN_ENCHANT_RESET packet;

	packet.nCostItemId = costItemID;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_NEW_HENNA_POTEN_ENCHANT_RESET(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(850, stream);
	Debug(("Api Call -----> C_EX_NEW_HENNA_POTEN_ENCHANT_RESET" @ string(packet.nCostItemId)));
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	if((GetWindowHandle((m_Windowname $ ".EnchantDialog_wnd")).IsShowWindow() && Auto_CheckBox.IsChecked()))
	{
		bPressCancelAutoEnchant = true;
		Debug(("ESC 누름!!!" @ string(bPressCancelAutoEnchant)));  // EN?: Press ESC!!!
		OnClickButton("EnchantCancel_btn");
	}
	else if(GetWindowHandle((m_Windowname $ ".EnchantDialog_wnd")).IsShowWindow())
	{
		OnEnchantCheck_btnClick();
	}
	else if(GetWindowHandle((m_Windowname $ ".UnlockDisableWnd")).IsShowWindow())
	{
		OnClickButton("BreakthroughPopup_Cancel_Btn");
	}
	else
	{
		CloseUI();
	}
	return;
}
