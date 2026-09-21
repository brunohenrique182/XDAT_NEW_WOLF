class DethroneFireEnchantWnd extends UICommonAPI
	dependson(UIPacket);

var array<byte> _emptyByteArray;

var WindowHandle Me;
var ButtonHandle WindowHelp_BTN;
var WindowHandle disableWnd;
var WindowHandle UIControlDialogAsset;
var ButtonHandle FireButton;
var RichListCtrlHandle NeedItem_RichList;
var DethroneFireEnchantDetailStats DethroneFireEnchantDetailStatsScript;
var DethroneFireEnchantProcess DethroneFireEnchantProcessScript;
var DethroneFireEnchantChart DethroneFireEnchantChartScript;
var EffectViewportWndHandle EffectViewport02;
var UIControlNumberInputSteper numberInputStepper;
var UIControlNeedItemList needItemRichListScript;
var UIPacket._S_EX_ENHANCED_ABILITY_OF_FIRE_OPEN_UI OpenUI_Packet;
var UIPacket._EAOF_Element OpenUI_PacketElement;
var array<FireAbilityUIData> UIData;
var array<FireAbilityComboEffectUIData> effectUIData;
var int spIndex;
var int hpIndex;

function OnRegisterEvent()
{
	RegisterEvent(9750);
	RegisterEvent((100000 + 1091));
	RegisterEvent(180);
	RegisterEvent(191);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	initDialogAssetes();
	InitNeedItemControl();
	InitUIControlNumberInputSteper();
	UIData.Length = 0;
	return;
}

function Initialize()
{
	Me = GetWindowHandle("DethroneFireEnchantWnd");
	WindowHelp_BTN = GetButtonHandle("DethroneFireEnchantWnd.WindowHelp_BTN");
	disableWnd = GetWindowHandle("DethroneFireEnchantWnd.DisableWnd");
	UIControlDialogAsset = GetWindowHandle("DethroneFireEnchantWnd.DisableWnd.UIControlDialogAsset");
	FireButton = GetButtonHandle("DethroneFireEnchantWnd.FireButton");
	NeedItem_RichList = GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.AutoNumStepPopup.NeedItem_RichList"));
	DethroneFireEnchantChartScript = DethroneFireEnchantChart(GetScript("DethroneFireEnchantWnd.DethroneFireEnchantChart"));
	DethroneFireEnchantDetailStatsScript = DethroneFireEnchantDetailStats(GetScript("DethroneFireEnchantWnd.DethroneFireEnchantDetailStats"));
	DethroneFireEnchantProcessScript = DethroneFireEnchantProcess(GetScript("DethroneFireEnchantWnd.DethroneFireEnchantProcess"));
	EffectViewport02 = GetEffectViewportWndHandle("DethroneFireEnchantWnd.EffectViewport02");
	GetWindowHandle("DethroneFireEnchantDetailStats").ShowWindow();
	GetWindowHandle("DethroneFireEnchantProcess").HideWindow();
	GetButtonHandle("DethroneFireEnchantWnd.MainShop_Button").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14313), 250));
	return;
}

function OnShow()
{
	if((UIData.Length <= 0))
	{
		UIData.Length = 5;
		Class'NWindow.UIDataManager'.static.GetFireAbilityData(EFAT_PRIMAL_FIRE, UIData[0]);
		Class'NWindow.UIDataManager'.static.GetFireAbilityData(EFAT_PRIMAL_LIFE, UIData[1]);
		Class'NWindow.UIDataManager'.static.GetFireAbilityData(EFAT_PIECE_OF_FIRE, UIData[2]);
		Class'NWindow.UIDataManager'.static.GetFireAbilityData(EFAT_TOTEM_OF_FIRE, UIData[3]);
		Class'NWindow.UIDataManager'.static.GetFireAbilityData(EFAT_FIGHTING_SPIRIT, UIData[4]);
		Class'NWindow.UIDataManager'.static.GetFireAbilityComboEffectData(effectUIData);
		Debug("- 디스론 능력강화 Load Data - ");  // EN?: - Disron Enhancement Load Data -
	}
	Debug(("onShow 디스론 인챈트 메인 창" @ string(DethroneFireEnchantChartScript.groupButtons._getSelectButtonIndex())));  // EN?: onShow Disron Enchant Main Window
	if((DethroneFireEnchantChartScript.groupButtons._getSelectButtonIndex() <= -1))
	{
		GetWindowHandle("DethroneFireEnchantDetailStats").ShowWindow();
		GetWindowHandle("DethroneFireEnchantProcess").HideWindow();
		DethroneFireEnchantChartScript.SetTopOrder(0);
	}
	refresh();
	DethroneFireEnchantChartScript.enableAll(true);
	return;
}

function OnHide()
{
	EffectViewport02.SpawnEffect("");
	DethroneFireEnchantProcessScript.InitHide();
	DethroneFireEnchantProcessScript.deleteRewardItems();
	DethroneFireEnchantProcessScript.initCheckBox();
	DethroneFireEnchantProcessScript.setCancelAutoStepNum();
	OnClickButton("cancelAutoNumStepPopUp_Btn");
	return;
}

function playResultEffectViewPort(string effectPath)
{
	if((effectPath == "LineageEffect2.ui_upgrade_succ"))
	{
		PlaySound("Itemsound3.ui_enchant_success");
	}
	EffectViewport02.SetFocus();
	EffectViewport02.SpawnEffect(effectPath);
	return;
}

function dataParse()
{
	local int i, N, M;

	i = 0;
	while((i < 5))
	{
		Debug(("UIData[i].type " @ string(UIData[i].Type)));
		Debug(("UIData[i].DailyExpUpCount " @ string(UIData[i].DailyExpUpCount)));
		Debug(("UIData[i].DailyInitCount " @ string(UIData[i].DailyInitCount)));
		Debug(("UIData[i].DailyInitCost len:" @ string(UIData[i].DailyInitCost.Length)));
		N = 0;
		while((N < UIData[i].DailyInitCost.Length))
		{
			Debug(("UIData[i].DailyInitCost itemClassID:" @ string(UIData[i].DailyInitCost[N].ItemClassID)));
			Debug(("UIData[i].DailyInitCost ItemAmount:" @ string(UIData[i].DailyInitCost[N].ItemAmount)));
			N++;
		}
		Debug(("UIData[i].MaxLevel" @ string(UIData[i].MaxLevel)));
		Debug(("UIData[i].LevelupInfo len" @ string(UIData[i].LevelupInfo.Length)));
		N = 0;
		while((N < UIData[i].LevelupInfo.Length))
		{
			Debug(("UIData[i].LevelupInfo Level " @ string(UIData[i].LevelupInfo[N].Level)));
			Debug(("UIData[i].LevelupInfo Exp" @ string(UIData[i].LevelupInfo[N].Exp)));
			M = 0;
			while((M < UIData[i].LevelupInfo[N].ExpUpCostItem.Length))
			{
				Debug(("UIData[i].LevelupInfo ExpUpCostItem - ItemClassID" @ string(UIData[i].LevelupInfo[N].ExpUpCostItem[M].ItemClassID)));
				Debug(("UIData[i].LevelupInfo ExpUpCostItem - ItemAmount" @ string(UIData[i].LevelupInfo[N].ExpUpCostItem[M].ItemAmount)));
				M++;
			}
			Debug(("UIData[i].LevelupInfo ExpUpSuccessRate" @ string(UIData[i].LevelupInfo[N].ExpUpSuccessRate)));
			Debug(("UIData[i].LevelupInfo[n].LevelUpCost.length" @ string(UIData[i].LevelupInfo[N].LevelUpCost.Length)));
			M = 0;
			while((M < UIData[i].LevelupInfo[N].LevelUpCost.Length))
			{
				Debug(("UIData[i].LevelupInfo LevelUpCost - ItemClassID" @ string(UIData[i].LevelupInfo[N].LevelUpCost[M].ItemClassID)));
				Debug(("UIData[i].LevelupInfo LevelUpCost - ItemAmount" @ string(UIData[i].LevelupInfo[N].LevelUpCost[M].ItemAmount)));
				M++;
			}
			Debug(("UIData[i].LevelupInfo[n].SkillEffect.length" @ string(UIData[i].LevelupInfo[N].SkillEffect.Length)));
			M = 0;
			while((M < UIData[i].LevelupInfo[N].SkillEffect.Length))
			{
				Debug(("UIData[i].LevelupInfo SkillEffect" @ UIData[i].LevelupInfo[N].SkillEffect[M]));
				M++;
			}
			N++;
		}
		i++;
	}
	return;
}

function refresh()
{
	DethroneFireEnchantChartScript.groupButtons._setEnableAll();
	DethroneFireEnchantChartScript.refresh();
	if(GetWindowHandle("DethroneFireEnchantWnd.DethroneFireEnchantDetailStats").IsShowWindow())
	{
		Debug("메인창: 기본효과, 추가 효과 폼 갱신");  // EN?: Main Window: Basic Effects, Additional Effects Form Renewal
		DethroneFireEnchantDetailStatsScript.refresh();
	}
	else
	{
		Debug("메인창 인챈트 폼 갱신");  // EN?: Main Window Enchant Form Renewal
		DethroneFireEnchantProcessScript.refresh();
		DethroneFireEnchantProcessScript.initCheckBox();
	}
	return;
}

function InitNeedItemControl()
{
	needItemRichListScript = new Class'Interface.UIControlNeedItemList';
	needItemRichListScript.SetRichListControler(GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.AutoNumStepPopup.NeedItem_RichList")));
	GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.AutoNumStepPopup.NeedItem_RichList")).SetTooltipType("UIControlNeedItemList");
	return;
}

function DelegateOnUpdateItem()
{
	if((GetWindowHandle("DethroneFireEnchantWnd").IsShowWindow() == false))
	{
		return;
	}
	if(((needItemRichListScript.GetMaxNumCanBuy() > INT64(0)) && (OpenUI_PacketElement.nExpUpCount > 0)))
	{
	}
	return;
}

function InitUIControlNumberInputSteper()
{
	numberInputStepper = Class'Interface.UIControlNumberInputSteper'.static.InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.AutoNumStepPopup.NumberInputSteper")));
	numberInputStepper.DelegateOnChangeEditBox = ChangeTargetEnchant;
	numberInputStepper.DelegateESCKey = onEscPopup;
	numberInputStepper.m_hOwnerWnd.ShowWindow();
	numberInputStepper._SetDisable(false);
	numberInputStepper._setMaxLength(4);
	return;
}

function ChangeTargetEnchant(UIControlNumberInputSteper Target)
{
	local INT64 inputNum;

	Debug(("-_- " @ string(Target._getEditNum())));
	inputNum = INT64(Min(Target._getEditNum(), int(needItemRichListScript.GetMaxNumCanBuy())));
	Debug(("needItemRichListScript.GetMaxNumCanBuy() " @ string(needItemRichListScript.GetMaxNumCanBuy())));
	Debug(("inputNum" @ string(inputNum)));
	if((inputNum <= INT64(0)))
	{
		needItemRichListScript.SetBuyNum(INT64(1));
	}
	else
	{
		needItemRichListScript.SetBuyNum(inputNum);
	}
	if((inputNum > INT64(0)))
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.AutoNumStepPopup.okAutoNumStepPopUp_Btn")).EnableWindow();
	}
	else
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.AutoNumStepPopup.okAutoNumStepPopUp_Btn")).DisableWindow();
	}
	return;
}

function initDialogAssetes()
{
	local UIControlDialogAssets popupExpandScript;

	popupExpandScript = Class'Interface.UIControlDialogAssets'.static.InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.UIControlDialogAsset")));
	disableWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd"));
	popupExpandScript.SetDisableWindow(disableWnd);
	Class'NWindow.UIAPI_WINDOW'.static.SetAlwaysOnTop((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd"), false);
	return;
}

function UIControlDialogAssets GetDialogAssetScript()
{
	local WindowHandle poopExpandWnd;

	poopExpandWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.UIControlDialogAsset"));
	return UIControlDialogAssets(poopExpandWnd.GetScript());
}

function ShowAutoNumStepPopup()
{
	disableWnd.ShowWindow();
	disableWnd.SetFocus();
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.AutoNumStepPopup")).ShowWindow();
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.AutoNumStepPopup")).SetFocus();
	GetEditBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.AutoNumStepPopup.NumberInputSteper.ItemCount_EditBox")).ShowWindow();
	setNeedItemCount();
	return;
}

function ShowDialogAsk(int dialogID)
{
	local string Message;
	local int N;
	local FireAbilityLevelupInfoUIData levelUPData;

	GetDialogAssetScript().SetDialogID(dialogID);
	if((dialogID == 1))
	{
		Message = GetSystemMessage(13810);
		GetDialogAssetScript().SetUseNeedItem(true);
		GetDialogAssetScript().StartNeedItemList(getSeletedUIData().DailyInitCost.Length);
		N = 0;
		while((N < getSeletedUIData().DailyInitCost.Length))
		{
			GetDialogAssetScript().AddNeedItemClassID(getSeletedUIData().DailyInitCost[N].ItemClassID, INT64(getSeletedUIData().DailyInitCost[N].ItemAmount));
			N++;
		}
	}
	else if((dialogID == 2))
	{
		levelUPData = getSelectedUIDataByLevel(getSelectedPacketDataElement().nLevel);
		Message = GetSystemMessage(13811);
		GetDialogAssetScript().SetUseNeedItem(true);
		GetDialogAssetScript().StartNeedItemList(levelUPData.LevelUpCost.Length);
		N = 0;
		while((N < levelUPData.LevelUpCost.Length))
		{
			GetDialogAssetScript().AddNeedItemClassID(levelUPData.LevelUpCost[N].ItemClassID, INT64(levelUPData.LevelUpCost[N].ItemAmount));
			N++;
		}
	}
	GetDialogAssetScript().SetDialogDesc(Message);
	GetDialogAssetScript().SetItemNum(1);
	GetDialogAssetScript().Show();
	GetDialogAssetScript().DelegateOnClickBuy = onClickDialog;
	GetDialogAssetScript().DelegateOnCancel = OnClickCancelDialog;
	return;
}

function onClickDialog()
{
	Debug(("GetDialogAssetScript().GetDialogID: " @ string(GetDialogAssetScript().GetDialogID())));
	GetDialogAssetScript().Hide();
	if((GetDialogAssetScript().GetDialogID() == 1))
	{
		API_C_EX_ENHANCED_ABILITY_OF_FIRE_INIT(DethroneFireEnchantChartScript.getSelectedCType());
	}
	else
	{
		API_C_EX_ENHANCED_ABILITY_OF_FIRE_LEVEL_UP(DethroneFireEnchantChartScript.getSelectedCType());
	}
	return;
}

function OnClickCancelDialog()
{
	GetDialogAssetScript().Hide();
	return;
}

function OnClickButton(string Name)
{
	Debug(("Name" @ Name));
	switch(Name)
	{
		case "WindowHelp_BTN":
			OnWindowHelp_BTNClick();
			break;
		case "FireButton":
			OnFireButtonClick();
			break;
		case "okAutoNumStepPopUp_Btn":
			disableWnd.HideWindow();
			GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.AutoNumStepPopup")).HideWindow();
			DethroneFireEnchantProcessScript.setAutoStepNum(numberInputStepper._getEditNum(), true);
			break;
		case "cancelAutoNumStepPopUp_Btn":
			disableWnd.HideWindow();
			GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.AutoNumStepPopup")).HideWindow();
			DethroneFireEnchantProcessScript.setCancelAutoStepNum();
			break;
		case "MainShop_Button":
			toggleWindow("DethroneShopWnd", true, true);
			break;
		default:
			break;
	}
	return;
}

function setNeedItemCount()
{
	local FireAbilityLevelupInfoUIData levelUPData;
	local int i;
	local UserInfo Info;

	levelUPData = getSelectedUIDataByLevel(getSelectedPacketDataElement().nLevel);
	OpenUI_PacketElement = getSelectedPacketDataElement();
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.AutoNumStepPopup.EnchantCount_Text")).SetText(string(OpenUI_PacketElement.nExpUpCount));
	needItemRichListScript.CleariObjects();
	needItemRichListScript.StartNeedItemList(levelUPData.ExpUpCostItem.Length);
	spIndex = -1;
	hpIndex = -1;
	Debug(("숫자 입력 팝업창, 필요 아이템 수 " @ string(levelUPData.ExpUpCostItem.Length)));  // EN?: Number pop-up window, number of items required
	i = 0;
	while((i < levelUPData.ExpUpCostItem.Length))
	{
		if((levelUPData.ExpUpCostItem[i].ItemClassID == 82621))
		{
			GetPlayerInfo(Info);
			hpIndex = needItemRichListScript.AddNeeItemInfo(GetItemInfoByClassID(82621), INT64(levelUPData.ExpUpCostItem[i].ItemAmount), Info.nCurHP);
			i++;
			continue;
		}
		if((levelUPData.ExpUpCostItem[i].ItemClassID == 82500))
		{
			GetPlayerInfo(Info);
			spIndex = needItemRichListScript.AddNeeItemInfo(GetItemInfoByClassID(82500), INT64(levelUPData.ExpUpCostItem[i].ItemAmount), Info.nSP);
			i++;
			continue;
		}
		needItemRichListScript.AddNeeItemInfo(GetItemInfoByClassID(levelUPData.ExpUpCostItem[i].ItemClassID), INT64(levelUPData.ExpUpCostItem[i].ItemAmount), getInventoryItemNumByClassID(levelUPData.ExpUpCostItem[i].ItemClassID));
		i++;
	}
	needItemRichListScript.SetBuyNum(INT64(1));
	numberInputStepper._setRangeMinMaxNum(1, Min(OpenUI_PacketElement.nExpUpCount, int(needItemRichListScript.GetMaxNumCanBuy())));
	numberInputStepper._setEditNum(Max(DethroneFireEnchantProcessScript.getAutoStepNum(), 1));
	return;
}

function OnWindowHelp_BTNClick()
{
	Class'Interface.HelpWnd'.static.ShowHelp(63, 5);
	return;
}

function OnFireButtonClick()
{
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 9750:
			break;
		case EV_PacketID(1091):
			Debug("S_EX_ENHANCED_ABILITY_OF_FIRE_OPEN_UI");
			ParsePacket_S_EX_ENHANCED_ABILITY_OF_FIRE_OPEN_UI();
			break;
		case 191:
			break;
		case 180:
			break;
		default:
			break;
	}
	return;
}

function HandleUpdateUserInfo()
{
	local UserInfo UserInfo;

	if(GetWindowHandle("DethroneFireEnchantWnd").IsShowWindow())
	{
		GetPlayerInfo(UserInfo);
		if(((NeedItem_RichList.GetRecordCount() > 0) && (spIndex > -1)))
		{
			needItemRichListScript.ModifyCurrentAmount(spIndex, UserInfo.nSP);
			if(((needItemRichListScript.GetMaxNumCanBuy() > INT64(0)) && (OpenUI_PacketElement.nExpUpCount > 0)))
			{
				numberInputStepper._setRangeMinMaxNum(1, Min(OpenUI_PacketElement.nExpUpCount, int(needItemRichListScript.GetMaxNumCanBuy())));
			}
			else
			{
				numberInputStepper._setEditNum(0);
			}
			DelegateOnUpdateItem();
		}
	}
	return;
}

function HandleUpdateHP()
{
	local UserInfo UserInfo;

	if(GetWindowHandle("DethroneFireEnchantWnd").IsShowWindow())
	{
		GetPlayerInfo(UserInfo);
		if(((NeedItem_RichList.GetRecordCount() > 0) && (hpIndex > -1)))
		{
			needItemRichListScript.ModifyCurrentAmount(hpIndex, UserInfo.nCurHP);
			if(((needItemRichListScript.GetMaxNumCanBuy() > INT64(0)) && (OpenUI_PacketElement.nExpUpCount > 0)))
			{
				numberInputStepper._setRangeMinMaxNum(1, Min(OpenUI_PacketElement.nExpUpCount, int(needItemRichListScript.GetMaxNumCanBuy())));
			}
			else
			{
				numberInputStepper._setEditNum(0);
			}
			DelegateOnUpdateItem();
		}
	}
	return;
}

function ParsePacket_S_EX_ENHANCED_ABILITY_OF_FIRE_OPEN_UI()
{
	if(!Class'Interface.UIPacket'.static.Decode_S_EX_ENHANCED_ABILITY_OF_FIRE_OPEN_UI(OpenUI_Packet))
	{
		return;
	}
	Debug((" -->  Decode_S_EX_ENHANCED_ABILITY_OF_FIRE_OPEN_UI :  " @ string(OpenUI_Packet.nSetEffectLevel)));
	if((Me.IsShowWindow() == false))
	{
		Me.ShowWindow();
		Me.SetFocus();
	}
	else
	{
		refresh();
	}
	return;
}

function int getSetEffectLevel()
{
	return OpenUI_Packet.nSetEffectLevel;
}

function UIPacket._EAOF_Element getPacketDataElement(int cType)
{
	return OpenUI_Packet.elements[cType];
}

function UIPacket._EAOF_Element getSelectedPacketDataElement()
{
	return OpenUI_Packet.elements[DethroneFireEnchantChartScript.getSelectedCType()];
}

function updatePacketDataElement(int cType, int nEXP, int nExpUpCount)
{
	OpenUI_Packet.elements[cType].nEXP = nEXP;
	OpenUI_Packet.elements[cType].nExpUpCount = nExpUpCount;
	return;
}

function updatePacketDataElement_nInitCount(int cType, int nInitCount, int nExpUpCount)
{
	OpenUI_Packet.elements[cType].nInitCount = nInitCount;
	OpenUI_Packet.elements[cType].nExpUpCount = nExpUpCount;
	return;
}

function updatePacketDataElement_nLevel(int cType, int nLevel)
{
	OpenUI_Packet.elements[cType].nLevel = nLevel;
	OpenUI_Packet.elements[cType].nEXP = 0;
	return;
}

function FireAbilityUIData getUIData(int cType)
{
	return UIData[cType];
}

function FireAbilityUIData getSeletedUIData()
{
	return UIData[DethroneFireEnchantChartScript.getSelectedCType()];
}

function FireAbilityLevelupInfoUIData getUIDataByLevel(int cType, int nLevel)
{
	local int i;
	local FireAbilityLevelupInfoUIData temp;

	i = 0;
	while((i < UIData[cType].LevelupInfo.Length))
	{
		if((UIData[cType].LevelupInfo[i].Level == nLevel))
		{
			return UIData[cType].LevelupInfo[i];
		}
		i++;
	}
	Debug("경고 : getUIDataByLevel level 이 이상하다. ");  // EN?: Warning: getUIDataByLevel level is abnormal.
	return temp;
}

function FireAbilityLevelupInfoUIData getSelectedUIDataByLevel(int nLevel)
{
	local int i;
	local FireAbilityLevelupInfoUIData temp;

	i = 0;
	while((i < UIData[DethroneFireEnchantChartScript.getSelectedCType()].LevelupInfo.Length))
	{
		if((UIData[DethroneFireEnchantChartScript.getSelectedCType()].LevelupInfo[i].Level == nLevel))
		{
			return UIData[DethroneFireEnchantChartScript.getSelectedCType()].LevelupInfo[i];
		}
		i++;
	}
	Debug("경고 : getSelectedUIDataByLevel level 이 이상하다. ");  // EN?: Warning: getSelectedUIDataByLevel level is abnormal.
	return temp;
}

function array<FireAbilityComboEffectUIData> getEffectUIData()
{
	return effectUIData;
}

function FireAbilityComboEffectUIData getEffectUIDataByLevel(int nLevel)
{
	local int i;
	local FireAbilityComboEffectUIData temp;

	i = 0;
	while((i < effectUIData.Length))
	{
		if((effectUIData[i].Level == nLevel))
		{
			return effectUIData[i];
		}
		i++;
	}
	Debug("경고 : getEffectUIData level 이 이상하다. ");  // EN?: Warning: getEffectUIData level is abnormal.
	return temp;
}

function API_C_EX_ENHANCED_ABILITY_OF_FIRE_INIT(int cType)
{
	local array<byte> stream;
	local UIPacket._C_EX_ENHANCED_ABILITY_OF_FIRE_INIT packet;

	packet.cType = cType;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_ENHANCED_ABILITY_OF_FIRE_INIT(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(841, stream);
	Debug(("----> Api Call : C_EX_ENHANCED_ABILITY_OF_FIRE_INIT " @ string(cType)));
	return;
}

function API_C_EX_ENHANCED_ABILITY_OF_FIRE_EXP_UP(int cType)
{
	local array<byte> stream;
	local UIPacket._C_EX_ENHANCED_ABILITY_OF_FIRE_EXP_UP packet;

	packet.cType = cType;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_ENHANCED_ABILITY_OF_FIRE_EXP_UP(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(842, stream);
	Debug(("----> Api Call : C_EX_ENHANCED_ABILITY_OF_FIRE_EXP_UP " @ string(cType)));
	return;
}

function API_C_EX_ENHANCED_ABILITY_OF_FIRE_LEVEL_UP(int cType)
{
	local array<byte> stream;
	local UIPacket._C_EX_ENHANCED_ABILITY_OF_FIRE_LEVEL_UP packet;

	packet.cType = cType;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_ENHANCED_ABILITY_OF_FIRE_LEVEL_UP(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(843, stream);
	Debug(("----> Api Call : C_EX_ENHANCED_ABILITY_OF_FIRE_LEVEL_UP " @ string(cType)));
	return;
}

function API_C_EX_ENHANCED_ABILITY_OF_FIRE_OPEN_UI()
{
	Class'Interface.UIPacket'.static.RequestUIPacket(840, _emptyByteArray);
	Debug("----> Api Call : C_EX_ENHANCED_ABILITY_OF_FIRE_OPEN_UI");
	return;
}

function API_C_EX_HOLY_FIRE_OPEN_UI()
{
	Class'Interface.UIPacket'.static.RequestUIPacket(844, _emptyByteArray);
	Debug("----> Api Call : C_EX_HOLY_FIRE_OPEN_UI");
	return;
}

function onEscPopup()
{
	if(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.AutoNumStepPopup")).IsShowWindow())
	{
		GetEditBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.AutoNumStepPopup.NumberInputSteper.ItemCount_EditBox")).HideWindow();
	}
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	if(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.AutoNumStepPopup")).IsShowWindow())
	{
		OnClickButton("cancelAutoNumStepPopUp_Btn");
	}
	else
	{
		GetWindowHandle("DethroneFireEnchantWnd").HideWindow();
	}
	return;
}
