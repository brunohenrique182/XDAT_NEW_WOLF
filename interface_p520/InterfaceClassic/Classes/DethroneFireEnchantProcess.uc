class DethroneFireEnchantProcess extends UICommonAPI
	dependson(UIPacket);

const ENCHANTING_TIME = 1000;

var WindowHandle Me;
var RichListCtrlHandle NeedItem_RichList;
var RichListCtrlHandle Reward_RichList;
var TextBoxHandle SelectTypeWithLv_text;
var HtmlHandle Desc_htmlCtrl;
var ButtonHandle Init_Btn;
var ButtonHandle Enchant_Btn;
var ButtonHandle Upgrade_Btn;
var ButtonHandle Back_Btn;
var ButtonHandle AutoNumStepChange_Btn;
var CheckBoxHandle AutoCheckBox;
var CheckBoxHandle NumStepCheckBox;
var StatusBarHandle Proficiency_StatusBar;
var EffectViewportWndHandle effectViewport;
var EffectViewportWndHandle effectViewportResult;
var EffectViewportWndHandle effectViewportItemResult;
var UIControlNeedItemList needItemRichListScript;
var TextBoxHandle EnchantButtonLimit_Text;
var TextBoxHandle InitButtonLimit_Text;
var TextBoxHandle EnchantButton_Text;
var TextBoxHandle InitButton_Text;
var TextureHandle IntTextBg_tex;
var TextureHandle EnchantTextBg_tex;
var TextBoxHandle StatusBar_Text;
var TextBoxHandle EnchantPer_Text;
var TextBoxHandle AutoNumStep_Text;
var TextureHandle Cover_tex;
var TextBoxHandle Cover_Desc02_text;
var DethroneFireEnchantWnd DethroneFireEnchantWndScript;
var DethroneFireEnchantDetailStats DethroneFireEnchantDetailStatsScript;
var DethroneFireEnchantChart DethroneFireEnchantChartScript;
var L2UITimerObject timeObject;
var L2UITimerObject enchantTimeObject;
var ItemWindowHandle Icon_Item;
var int nCurHP;
var INT64 nSP;
var int spIndex;
var int hpIndex;
var FireAbilityLevelupInfoUIData levelUPData;
var UIPacket._EAOF_Element OpenUI_PacketElement;
var FireAbilityUIData UIData;
var bool isEnchanting;
var int nAutoStepNum;
var bool bResultNumStepCheckValue;
var bool bResultAutoCheckValue;

function OnRegisterEvent()
{
	RegisterEvent((100000 + 1092));
	RegisterEvent((100000 + 1093));
	RegisterEvent((100000 + 1094));
	RegisterEvent(180);
	RegisterEvent(191);
	RegisterEvent(17);
	return;
}

function OnShow()
{
	initCheckBox();
	return;
}

function InitNeedItemControl()
{
	needItemRichListScript = new Class'InterfaceClassic.UIControlNeedItemList';
	needItemRichListScript.SetRichListControler(GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".NeedItem_RichList")));
	GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".NeedItem_RichList")).SetTooltipType("UIControlNeedItemList");
	needItemRichListScript.DelegateOnUpdateItem = DelegateOnUpdateItem;
	return;
}

function OnLoad()
{
	Initialize();
	InitNeedItemControl();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("DethroneFireEnchantProcess");
	SelectTypeWithLv_text = GetTextBoxHandle("DethroneFireEnchantProcess.SelectTypeWithLv_text");
	NeedItem_RichList = GetRichListCtrlHandle("DethroneFireEnchantProcess.NeedItem_RichList");
	Reward_RichList = GetRichListCtrlHandle("DethroneFireEnchantProcess.Reward_RichList");
	Desc_htmlCtrl = GetHtmlHandle("DethroneFireEnchantProcess.Desc_htmlCtrl");
	Init_Btn = GetButtonHandle("DethroneFireEnchantProcess.Init_Btn");
	Enchant_Btn = GetButtonHandle("DethroneFireEnchantProcess.Enchant_Btn");
	Upgrade_Btn = GetButtonHandle("DethroneFireEnchantProcess.Upgrade_Btn");
	Back_Btn = GetButtonHandle("DethroneFireEnchantProcess.Back_Btn");
	AutoNumStepChange_Btn = GetButtonHandle("DethroneFireEnchantProcess.AutoNumStepChange_Btn");
	if((int(GetLanguage()) == 2))
	{
		AutoNumStepChange_Btn.SetButtonName(1468);
	}
	effectViewport = GetEffectViewportWndHandle("DethroneFireEnchantProcess.effectViewport");
	effectViewportResult = GetEffectViewportWndHandle("DethroneFireEnchantProcess.effectViewportResult");
	effectViewportItemResult = GetEffectViewportWndHandle("DethroneFireEnchantProcess.effectViewportItemResult");
	Proficiency_StatusBar = GetStatusBarHandle("DethroneFireEnchantProcess.Proficiency_StatusBar");
	EnchantButton_Text = GetTextBoxHandle("DethroneFireEnchantProcess.EnchantButton_Text");
	EnchantButtonLimit_Text = GetTextBoxHandle("DethroneFireEnchantProcess.EnchantButtonLimit_Text");
	InitButton_Text = GetTextBoxHandle("DethroneFireEnchantProcess.InitButton_Text");
	if(((int(GetLanguage()) == 8) || (int(GetLanguage()) == 9)))
	{
		InitButton_Text.SetText(GetSystemString(1727));
	}
	EnchantPer_Text = GetTextBoxHandle("DethroneFireEnchantProcess.EnchantPer_Text");
	AutoNumStep_Text = GetTextBoxHandle("DethroneFireEnchantProcess.AutoNumStep_Text");
	InitButtonLimit_Text = GetTextBoxHandle("DethroneFireEnchantProcess.InitButtonLimit_Text");
	AutoCheckBox = GetCheckBoxHandle("DethroneFireEnchantProcess.AutoCheckBox");
	NumStepCheckBox = GetCheckBoxHandle("DethroneFireEnchantProcess.NumStepCheckBox");
	StatusBar_Text = GetTextBoxHandle("DethroneFireEnchantProcess.StatusBar_Text");
	Cover_tex = GetTextureHandle("DethroneFireEnchantProcess.Cover_tex");
	Cover_Desc02_text = GetTextBoxHandle("DethroneFireEnchantProcess.Desc02_text");
	IntTextBg_tex = GetTextureHandle("DethroneFireEnchantProcess.IntTextBg_tex");
	EnchantTextBg_tex = GetTextureHandle("DethroneFireEnchantProcess.EnchantTextBg_tex");
	Icon_Item = GetItemWindowHandle("DethroneFireEnchantProcess.Icon_Item");
	DethroneFireEnchantWndScript = DethroneFireEnchantWnd(GetScript("DethroneFireEnchantWnd"));
	DethroneFireEnchantChartScript = DethroneFireEnchantChart(GetScript("DethroneFireEnchantWnd.DethroneFireEnchantChart"));
	DethroneFireEnchantDetailStatsScript = DethroneFireEnchantDetailStats(GetScript("DethroneFireEnchantWnd.DethroneFireEnchantDetailStats"));
	Reward_RichList.SetSelectable(false);
	Reward_RichList.SetSelectedSelTooltip(false);
	Reward_RichList.SetUseStripeBackTexture(false);
	Reward_RichList.SetAppearTooltipAtMouseX(true);
	Reward_RichList.SetTooltipType("SellItemList");
	enchantTimeObject = Class'InterfaceClassic.L2UITimer'.static.Inst()._MakeTimerObject(1, 1);
	enchantTimeObject._DelegateOnTime = delayAutoCall;
	timeObject = Class'InterfaceClassic.L2UITimer'.static.Inst()._MakeTimerObject(1000, 1);
	timeObject._DelegateOnTime = OnTime;
	Enchant_Btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14427), 250));
	return;
}

function refresh()
{
	local int cType, i;
	local UserInfo Info;
	local Rect rectWnd;

	OpenUI_PacketElement = DethroneFireEnchantWndScript.getSelectedPacketDataElement();
	cType = DethroneFireEnchantChartScript.getSelectedCType();
	Debug(("인챈트 처리창 refresh" @ string(cType)));  // EN?: Enchant processing window refresh
	Icon_Item.Clear();
	Icon_Item.AddItem(getCTypeIconItemInfo(cType));
	UIData = DethroneFireEnchantWndScript.getSeletedUIData();
	levelUPData = DethroneFireEnchantWndScript.getSelectedUIDataByLevel(OpenUI_PacketElement.nLevel);
	if((levelUPData.ExpUpSuccessRate == 0.0000000))
	{
		EnchantPer_Text.SetText(" - ");
	}
	else
	{
		EnchantPer_Text.SetText((string0100Per(levelUPData.ExpUpSuccessRate) $ "%"));
	}
	AutoNumStepChange_Btn.DisableWindow();
	needItemRichListScript.CleariObjects();
	needItemRichListScript.StartNeedItemList(levelUPData.ExpUpCostItem.Length);
	spIndex = -1;
	hpIndex = -1;
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
		needItemRichListScript.AddNeedItemClassID(levelUPData.ExpUpCostItem[i].ItemClassID, INT64(levelUPData.ExpUpCostItem[i].ItemAmount));
		i++;
	}
	needItemRichListScript.SetBuyNum(INT64(1));
	EnchantButtonLimit_Text.SetText(((string(OpenUI_PacketElement.nExpUpCount) $ "/") $ string(UIData.DailyExpUpCount)));
	InitButtonLimit_Text.SetText(((string(OpenUI_PacketElement.nInitCount) $ "/") $ string(UIData.DailyInitCount)));
	setBar();
	if((cType == 0))
	{
		Back_Btn.EnableWindow();
		Init_Btn.DisableWindow();
		AutoCheckBox.SetCheck(false);
		NumStepCheckBox.SetCheck(false);
		AutoCheckBox.DisableWindow();
		NumStepCheckBox.DisableWindow();
		AutoNumStepChange_Btn.DisableWindow();
		Enchant_Btn.DisableWindow();
		Cover_tex.ShowWindow();
		Cover_Desc02_text.ShowWindow();
		rectWnd = Me.GetRect();
		Upgrade_Btn.MoveTo((rectWnd.nX + 112), (rectWnd.nY + 515));
		Init_Btn.HideWindow();
		Enchant_Btn.HideWindow();
		InitButton_Text.HideWindow();
		InitButtonLimit_Text.HideWindow();
		EnchantButton_Text.HideWindow();
		EnchantButtonLimit_Text.HideWindow();
		IntTextBg_tex.HideWindow();
		EnchantTextBg_tex.HideWindow();
	}
	else
	{
		setEnableUI(true);
		Cover_tex.HideWindow();
		Cover_Desc02_text.HideWindow();
		rectWnd = Me.GetRect();
		Upgrade_Btn.MoveTo((rectWnd.nX + 239), (rectWnd.nY + 515));
		Init_Btn.ShowWindow();
		Enchant_Btn.ShowWindow();
		InitButton_Text.ShowWindow();
		InitButtonLimit_Text.ShowWindow();
		EnchantButton_Text.ShowWindow();
		EnchantButtonLimit_Text.ShowWindow();
		IntTextBg_tex.ShowWindow();
		EnchantTextBg_tex.ShowWindow();
	}
	Desc_htmlCtrl.LoadHtmlFromString(htmlSetHtmlStart(GetSystemString(getDescStringByCType(cType))), false);
	return;
}

function CheckEnableButton()
{
	local int cType;

	cType = DethroneFireEnchantChartScript.getSelectedCType();
	UIData = DethroneFireEnchantWndScript.getSeletedUIData();
	OpenUI_PacketElement = DethroneFireEnchantWndScript.getSelectedPacketDataElement();
	levelUPData = DethroneFireEnchantWndScript.getSelectedUIDataByLevel(OpenUI_PacketElement.nLevel);
	if(((OpenUI_PacketElement.nEXP >= levelUPData.Exp) && (UIData.MaxLevel > OpenUI_PacketElement.nLevel)))
	{
		Upgrade_Btn.EnableWindow();
		Upgrade_Btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14399)));
	}
	else
	{
		if((UIData.MaxLevel <= OpenUI_PacketElement.nLevel))
		{
			Upgrade_Btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14416)));
		}
		else
		{
			Upgrade_Btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14399)));
		}
		Upgrade_Btn.DisableWindow();
	}
	if(((OpenUI_PacketElement.nExpUpCount > 0) && needItemRichListScript.GetCanBuy()))
	{
		if((cType == 0))
		{
			Enchant_Btn.DisableWindow();
		}
		else
		{
			Enchant_Btn.EnableWindow();
			if((isEnchanting == false))
			{
				AutoCheckBox.EnableWindow();
				NumStepCheckBox.EnableWindow();
			}
		}
	}
	else
	{
		Enchant_Btn.DisableWindow();
		AutoCheckBox.DisableWindow();
		NumStepCheckBox.DisableWindow();
		initCheckBox();
	}
	if(((OpenUI_PacketElement.nExpUpCount <= 0) && (OpenUI_PacketElement.nInitCount > 0)))
	{
		Init_Btn.EnableWindow();
	}
	else
	{
		Init_Btn.DisableWindow();
	}
	return;
}

function setBar()
{
	local UIPacket._EAOF_Element OpenUI_PacketElement;
	local float Per;

	OpenUI_PacketElement = DethroneFireEnchantWndScript.getSelectedPacketDataElement();
	SelectTypeWithLv_text.SetText(((getCTypeTitleSting(DethroneFireEnchantChartScript.getSelectedCType()) @ "Lv.") $ string(OpenUI_PacketElement.nLevel)));
	levelUPData = DethroneFireEnchantWndScript.getSelectedUIDataByLevel(OpenUI_PacketElement.nLevel);
	Proficiency_StatusBar.SetPoint(INT64(OpenUI_PacketElement.nEXP), INT64(levelUPData.Exp));
	Per = float(ConvertFloatToString(((float(OpenUI_PacketElement.nEXP) / float(levelUPData.Exp)) * 100.0000000), 2, false));
	StatusBar_Text.SetText((string0100Per(Per) $ "/100"));
	return;
}

function int getDescStringByCType(int cType)
{
	local int stringNum;

	switch(cType)
	{
		case 0:
			stringNum = 14340;
			break;
		case 1:
			stringNum = 14336;
			break;
		case 2:
			stringNum = 14339;
			break;
		case 3:
			stringNum = 14338;
			break;
		case 4:
			stringNum = 14337;
			break;
		default:
			break;
	}
	return stringNum;
}

function OnClickCheckBox(string strID)
{
	if((strID == "NumStepCheckBox"))
	{
		AutoCheckBox.SetCheck(false);
		if((NumStepCheckBox.IsChecked() == false))
		{
			setAutoStepNum(0);
			AutoNumStepChange_Btn.DisableWindow();
		}
		else if((nAutoStepNum == 0))
		{
			DethroneFireEnchantWndScript.ShowAutoNumStepPopup();
		}
		else
		{
			AutoNumStepChange_Btn.EnableWindow();
		}
	}
	else if((strID == "AutoCheckBox"))
	{
		NumStepCheckBox.SetCheck(false);
		setAutoStepNum(0);
		AutoNumStepChange_Btn.DisableWindow();
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "Init_Btn":
			OnInit_BtnClick();
			break;
		case "Enchant_Btn":
			OnEnchant_BtnClick();
			break;
		case "Upgrade_Btn":
			OnUpgrade_BtnClick();
			break;
		case "Back_Btn":
			OnBack_BtnClick();
			break;
		case "AutoNumStepChange_Btn":
			DethroneFireEnchantWndScript.ShowAutoNumStepPopup();
			break;
		default:
			break;
	}
	return;
}

function OnInit_BtnClick()
{
	DethroneFireEnchantWndScript.ShowDialogAsk(1);
	return;
}

function InitHide()
{
	timeObject._Stop();
	enchantTimeObject._Stop();
	isEnchanting = false;
	EnchantButton_Text.SetText(GetSystemString(5005));
	return;
}

function OnEnchant_BtnClick()
{
	timeObject._Stop();
	if(isEnchanting)
	{
		isEnchanting = false;
		EnchantButton_Text.SetText(GetSystemString(5005));
		Desc_htmlCtrl.LoadHtmlFromString(htmlSetHtmlStart(GetSystemString(getDescStringByCType(DethroneFireEnchantChartScript.getSelectedCType()))), false);
		setEnableUI(true);
		DethroneFireEnchantChartScript.enableAll(true);
		effectViewport.SpawnEffect("");
	}
	else
	{
		timeObject._Play();
		setEnableUI(false);
		isEnchanting = true;
		EnchantButton_Text.SetText(GetSystemString(5198));
		Desc_htmlCtrl.LoadHtmlFromString(htmlSetHtmlStart(GetSystemString(14341)), false);
		effectViewport.SetScale(1.0000000);
		effectViewport.SetCameraDistance(250.0000000);
		effectViewport.SpawnEffect("LineageEffect2.ui_Enchant_start");
		DethroneFireEnchantChartScript.enableAll(false);
	}
	return;
}

function OnEnchant_Auto()
{
	timeObject._Stop();
	Debug("자동 인챈트 진행..");  // EN?: Automatic enchantment progress..
	timeObject._Play();
	setEnableUI(false);
	isEnchanting = true;
	EnchantButton_Text.SetText(GetSystemString(5198));
	Desc_htmlCtrl.LoadHtmlFromString(htmlSetHtmlStart(GetSystemString(14341)), false);
	effectViewport.SetScale(1.0000000);
	effectViewport.SetCameraDistance(250.0000000);
	effectViewport.SpawnEffect("LineageEffect2.ui_Enchant_start");
	DethroneFireEnchantChartScript.enableAll(false);
	return;
}

function OnTime(int Count)
{
	Debug("시간 됨");  // EN?: Timed
	isEnchanting = false;
	if(((AutoCheckBox.IsChecked() == false) && (NumStepCheckBox.IsChecked() == false)))
	{
		Debug("복원");  // EN?: Restore
		EnchantButton_Text.SetText(GetSystemString(5005));
		DethroneFireEnchantChartScript.enableAll(true);
		Desc_htmlCtrl.LoadHtmlFromString(htmlSetHtmlStart(GetSystemString(getDescStringByCType(DethroneFireEnchantChartScript.getSelectedCType()))), false);
	}
	DethroneFireEnchantWndScript.API_C_EX_ENHANCED_ABILITY_OF_FIRE_EXP_UP(DethroneFireEnchantChartScript.getSelectedCType());
	return;
}

function OnUpgrade_BtnClick()
{
	DethroneFireEnchantWndScript.ShowDialogAsk(2);
	return;
}

function OnBack_BtnClick()
{
	deleteRewardItems();
	GetWindowHandle("DethroneFireEnchantDetailStats").ShowWindow();
	Me.HideWindow();
	DethroneFireEnchantDetailStatsScript.refresh();
	return;
}

function setEnableUI(bool bEnable)
{
	if(bEnable)
	{
		Back_Btn.EnableWindow();
		CheckEnableButton();
		if(NumStepCheckBox.IsChecked())
		{
			AutoNumStepChange_Btn.EnableWindow();
		}
		else
		{
			AutoNumStepChange_Btn.DisableWindow();
		}
	}
	else
	{
		Upgrade_Btn.DisableWindow();
		Back_Btn.DisableWindow();
		Init_Btn.DisableWindow();
		AutoCheckBox.DisableWindow();
		NumStepCheckBox.DisableWindow();
		AutoNumStepChange_Btn.DisableWindow();
	}
	return;
}

function setAutoStepNum(int AutoStepNum, optional bool bSetCheck)
{
	nAutoStepNum = AutoStepNum;
	AutoNumStep_Text.SetText(string(nAutoStepNum));
	if(bSetCheck)
	{
		AutoCheckBox.SetCheck(false);
		NumStepCheckBox.SetCheck(true);
		AutoNumStepChange_Btn.EnableWindow();
	}
	return;
}

function int getAutoStepNum()
{
	return nAutoStepNum;
}

function initCheckBox()
{
	setAutoStepNum(0);
	setCancelAutoStepNum();
	AutoCheckBox.SetCheck(false);
	return;
}

function setCancelAutoStepNum()
{
	if((nAutoStepNum == 0))
	{
		NumStepCheckBox.SetCheck(false);
		setAutoStepNum(0);
		AutoNumStepChange_Btn.DisableWindow();
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_PacketID(1092):
			ParsePacket_S_EX_ENHANCED_ABILITY_OF_FIRE_INIT();
			break;
		case EV_PacketID(1093):
			ParsePacket_S_EX_ENHANCED_ABILITY_OF_FIRE_EXP_UP();
			break;
		case EV_PacketID(1094):
			ParsePacket_S_EX_ENHANCED_ABILITY_OF_FIRE_LEVEL_UP();
			break;
		case 191:
			HandleUpdateHP();
			break;
		case 180:
			HandleUpdateUserInfo();
			break;
		case 17:
			ParseInt(param, "msec", timeObject._time);
			if((timeObject._time <= 100))
			{
				timeObject._time = 100;
			}
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
			DelegateOnUpdateItem();
		}
	}
	return;
}

function DelegateOnUpdateItem()
{
	if((GetWindowHandle("DethroneFireEnchantWnd").IsShowWindow() == false))
	{
		return;
	}
	CheckEnableButton();
	return;
}

function ParsePacket_S_EX_ENHANCED_ABILITY_OF_FIRE_INIT()
{
	local UIPacket._S_EX_ENHANCED_ABILITY_OF_FIRE_INIT packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_ENHANCED_ABILITY_OF_FIRE_INIT(packet))
	{
		return;
	}
	Debug((((" -->  Decode_S_EX_ENHANCED_ABILITY_OF_FIRE_INIT :  " @ string(packet.cType)) @ string(packet.cResult)) @ string(packet.nInitCount)));
	if((packet.cResult > 0))
	{
		DethroneFireEnchantWndScript.updatePacketDataElement_nInitCount(packet.cType, packet.nInitCount, UIData.DailyExpUpCount);
		refresh();
	}
	else
	{
		Debug("초기화 오류 입니다. ");  // EN?: Initialization error.
		GetWindowHandle("DethroneFireEnchantWnd").HideWindow();
	}
	return;
}

function ParsePacket_S_EX_ENHANCED_ABILITY_OF_FIRE_EXP_UP()
{
	local UIPacket._S_EX_ENHANCED_ABILITY_OF_FIRE_EXP_UP packet;
	local int i;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_ENHANCED_ABILITY_OF_FIRE_EXP_UP(packet))
	{
		return;
	}
	Debug(((((" -->  Decode_S_EX_ENHANCED_ABILITY_OF_FIRE_EXP_UP :  " @ string(packet.cType)) @ string(packet.cResult)) @ string(packet.nEXP)) @ string(packet.nExpUpCount)));
	DethroneFireEnchantWndScript.updatePacketDataElement(packet.cType, packet.nEXP, packet.nExpUpCount);
	refresh();
	DethroneFireEnchantChartScript.refresh();
	bResultAutoCheckValue = AutoCheckBox.IsChecked();
	bResultNumStepCheckValue = NumStepCheckBox.IsChecked();
	if((packet.cResult > 0))
	{
		Debug(("=획득 아이템=> packet.rewards.length" @ string(packet.rewards.Length)));  // EN?: = Items acquired = > packet.rewards.length
		if((packet.rewards.Length > 0))
		{
			effectViewportItemResult.SpawnEffect("LineageEffect2.ui_screen_message_flow");
		}
		i = 0;
		while((i < packet.rewards.Length))
		{
			Debug(("nItemClassId" @ string(packet.rewards[i].nItemClassID)));
			Debug(("nAmount" @ string(packet.rewards[i].nAmount)));
			setRec(packet.rewards[i].nItemClassID, packet.rewards[i].nAmount);
			i++;
		}
		effectViewportResult.SetScale(0.5700000);
		effectViewportResult.SetCameraDistance(250.0000000);
		effectViewportResult.SpawnEffect("LineageEffect2.ui_wi_mrfire");
		PlaySound("ItemSound3.enchant_success");
		Class'InterfaceClassic.L2UITween'.static.Inst()._AddTweenTwinlkle(StatusBar_Text, 2.0000000, 0.5000000, 500.0000000);
		DethroneFireEnchantChartScript.Shake();
		enchantTimeObject._Stop();
		enchantTimeObject._Play();
		getInstanceL2Util().showGfxScreenMessage(GetSystemString(3885));
	}
	else if((packet.cResult == 0))
	{
		effectViewportResult.SetScale(1.0000000);
		effectViewportResult.SetCameraDistance(250.0000000);
		effectViewportResult.SpawnEffect("LineageEffect2.ui_upgrade_fail");
		PlaySound("ItemSound3.enchant_fail");
		DethroneFireEnchantChartScript.Shake();
		enchantTimeObject._Stop();
		enchantTimeObject._Play();
		getInstanceL2Util().showGfxScreenMessage(GetSystemString(3886));
	}
	else if((packet.cResult == -2))
	{
		AddSystemMessage(13830);
		initCheckBox();
		EnchantButton_Text.SetText(GetSystemString(5005));
		DethroneFireEnchantChartScript.enableAll(true);
	}
	else
	{
		GetWindowHandle("DethroneFireEnchantWnd").HideWindow();
		Debug("디스론 능력 인챈트 중 알 수 없는 오류 입니다.");  // EN?: Unknown error during the enchantment of the Disron ability.
	}
	return;
}

function setRec(int ClassID, INT64 Amount)
{
	local RichListCtrlRowData Record;
	local bool bModify;
	local int i;

	i = 0;
	while((i < Reward_RichList.GetRecordCount()))
	{
		Reward_RichList.GetRec(i, Record);
		if((INT64(ClassID) == Record.nReserved1))
		{
			Reward_RichList.ModifyRecord(i, makeRecord(int(Record.nReserved1), (Record.nReserved2 + Amount)));
			bModify = true;
			break;
		}
		i++;
	}
	if((bModify == false))
	{
		Reward_RichList.InsertRecord(makeRecord(ClassID, Amount));
	}
	return;
}

function RichListCtrlRowData makeRecord(int ClassID, INT64 Amount)
{
	local RichListCtrlRowData Record;
	local ItemInfo iInfo;
	local string toolTipParam;

	Record.cellDataList.Length = 1;
	iInfo = GetItemInfoByClassID(ClassID);
	ItemInfoToParam(iInfo, toolTipParam);
	Record.szReserved = toolTipParam;
	Record.nReserved1 = INT64(ClassID);
	Record.nReserved2 = Amount;
	addRichListCtrlTexture(Record.cellDataList[0].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, 0, 1);
	AddRichListCtrlItem(Record.cellDataList[0].drawitems, iInfo, 32, 32, -34, 1);
	AddRichListCtrlString(Record.cellDataList[0].drawitems, GetItemNameAll(iInfo, true), getInstanceL2Util().BrightWhite, false, 5, 0);
	AddRichListCtrlString(Record.cellDataList[0].drawitems, iInfo.AdditionalName, getInstanceL2Util().Yellow03, false, 5, 0);
	AddRichListCtrlString(Record.cellDataList[0].drawitems, ("x" $ MakeCostStringINT64(Amount)), getInstanceL2Util().White, true, 40, 5);
	return Record;
}

function deleteRewardItems()
{
	Reward_RichList.DeleteAllItem();
	return;
}

function delayAutoCall(int Count)
{
	OpenUI_PacketElement = DethroneFireEnchantWndScript.getSelectedPacketDataElement();
	Debug(("OpenUI_PacketElement.nExpUpCount" @ string(OpenUI_PacketElement.nExpUpCount)));
	Debug(("needItemRichListScript.GetCanBuy()" @ string(needItemRichListScript.GetCanBuy())));
	Debug(("AutoCheckBox.IsChecked()" @ string(AutoCheckBox.IsChecked())));
	Debug(("bResultAutoCheckValue" @ string(bResultAutoCheckValue)));
	if(bResultAutoCheckValue)
	{
		if(((AutoCheckBox.IsChecked() && (OpenUI_PacketElement.nExpUpCount > 0)) && needItemRichListScript.GetCanBuy()))
		{
			OnEnchant_Auto();
		}
		else
		{
			initCheckBox();
			EnchantButton_Text.SetText(GetSystemString(5005));
			DethroneFireEnchantChartScript.enableAll(true);
		}
	}
	else if(bResultNumStepCheckValue)
	{
		nAutoStepNum--;
		if((((NumStepCheckBox.IsChecked() && (OpenUI_PacketElement.nExpUpCount > 0)) && needItemRichListScript.GetCanBuy()) && (nAutoStepNum > 0)))
		{
			setAutoStepNum(nAutoStepNum);
			OnEnchant_Auto();
		}
		else
		{
			setAutoStepNum(nAutoStepNum);
			initCheckBox();
			EnchantButton_Text.SetText(GetSystemString(5005));
			setEnableUI(true);
			DethroneFireEnchantChartScript.enableAll(true);
		}
	}
	else
	{
		initCheckBox();
		EnchantButton_Text.SetText(GetSystemString(5005));
		DethroneFireEnchantChartScript.enableAll(true);
	}
	return;
}

function ParsePacket_S_EX_ENHANCED_ABILITY_OF_FIRE_LEVEL_UP()
{
	local UIPacket._S_EX_ENHANCED_ABILITY_OF_FIRE_LEVEL_UP packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_ENHANCED_ABILITY_OF_FIRE_LEVEL_UP(packet))
	{
		return;
	}
	Debug((((" -->  Decode_S_EX_ENHANCED_ABILITY_OF_FIRE_LEVEL_UP :  " @ string(packet.cType)) @ string(packet.cResult)) @ string(packet.nLevel)));
	DethroneFireEnchantWndScript.updatePacketDataElement_nLevel(packet.cType, packet.nLevel);
	if((packet.cResult > 0))
	{
		Debug("디스론 승급 성공");  // EN?: Successfully promoted to Disron
		refresh();
		DethroneFireEnchantChartScript.refresh();
		DethroneFireEnchantWndScript.playResultEffectViewPort("LineageEffect2.ui_Enchant_success");
		AddSystemMessage(13832);
		Class'InterfaceClassic.L2UITween'.static.Inst()._AddTweenTwinlkle(SelectTypeWithLv_text, 2.0000000, 0.5000000, 1000.0000000);
	}
	else if((packet.cResult == 0))
	{
		GetWindowHandle("DethroneFireEnchantWnd").HideWindow();
		Debug("디스론 승급 실패");  // EN?: Disron Promotion Failed
	}
	else
	{
		GetWindowHandle("DethroneFireEnchantWnd").HideWindow();
		Debug("디스론 승급 중 알 수 없는 오류 입니다.");  // EN?: Unknown error while promoting Disron.
	}
	return;
}

function OnReceivedCloseUI()
{
	Debug("esc");
	DethroneFireEnchantWndScript.OnReceivedCloseUI();
	return;
}

function ItemInfo getCTypeIconItemInfo(int cType)
{
	local ItemInfo Info;

	switch(cType)
	{
		case 0:
			Info.IconName = "Icon.skill_i.s_dethrone_fire_source_1";
			break;
		case 1:
			Info.IconName = "Icon.skill_i.s_dethrone_fire_life_1";
			break;
		case 2:
			Info.IconName = "Icon.skill_i.s_dethrone_fire_piece_1";
			break;
		case 3:
			Info.IconName = "Icon.skill_i.s_dethrone_fire_totem_1";
			break;
		case 4:
			Info.IconName = "Icon.skill_i.s_dethrone_fire_combat_1";
			break;
		default:
			break;
	}
	return Info;
}

function string getCTypeTitleSting(int cType)
{
	local string RValue;

	switch(cType)
	{
		case 0:
			RValue = GetSystemString(14320);
			break;
		case 1:
			RValue = GetSystemString(14323);
			break;
		case 2:
			RValue = GetSystemString(14324);
			break;
		case 3:
			RValue = GetSystemString(14322);
			break;
		case 4:
			RValue = GetSystemString(14321);
			break;
		default:
			break;
	}
	return RValue;
}

function InsertRecord(RichListCtrlRowData rowDataNew, int Index)
{
	local int i, lastIndex;
	local RichListCtrlRowData rowData;

	if((Reward_RichList.GetRecordCount() == 0))
	{
		Reward_RichList.InsertRecord(rowDataNew);
	}
	else
	{
		lastIndex = (Reward_RichList.GetRecordCount() - 1);
		Reward_RichList.GetRec(lastIndex, rowData);
		Reward_RichList.InsertRecord(rowData);
		i = lastIndex;
		while((i > Index))
		{
			Reward_RichList.GetRec((i - 1), rowData);
			Reward_RichList.ModifyRecord(i, rowData);
			i--;
		}
		Reward_RichList.ModifyRecord(Index, rowDataNew);
	}
	return;
}
