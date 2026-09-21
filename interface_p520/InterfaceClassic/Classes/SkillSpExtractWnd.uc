class SkillSpExtractWnd extends UICommonAPI
	dependson(UIPacket);

const ITEM_ID_SP_EXTRACT = 101571;
const ITEM_ID_SP = 15624;

struct SpExtractInfo
{
	var ItemInfo spExtractItemInfo;
	var ItemInfo spItemInfo;
	var INT64 haveSp;
	var UIPacket._S_EX_SP_EXTRACT_INFO Info;
};

var SpExtractInfo _spExctractInfo;
var WindowHandle Me;
var ItemWindowHandle ItemWnd;
var ItemWindowHandle resultItemWnd;
var ItemWindowHandle resultCritLeftItemWnd;
var ItemWindowHandle resultCritRightItemWnd;
var TextBoxHandle criticalTextBox;
var TextBoxHandle itemNumTextBox;
var TextBoxHandle rateTextBox;
var TextBoxHandle itemNameTextBox;
var TextBoxHandle itemRateTextBox;
var TextBoxHandle dailyCntTextBox;
var TextBoxHandle dialogRateTextBox;
var TextBoxHandle resultItemNameTextBox;
var TextBoxHandle resultItemNumTextBox;
var TextBoxHandle resultDailyCntTextBox;
var TextBoxHandle resultDescTextBox;
var TextBoxHandle resultCritDailyCntTextBox;
var TextBoxHandle resultCritLeftItemNumTextBox;
var TextBoxHandle resultCritLeftItemNameTextBox;
var TextBoxHandle resultCritRightItemNumTextBox;
var TextBoxHandle resultCritRightItemNameTextBox;
var TextBoxHandle errorDescTextBox;
var ButtonHandle dailyInfoBtn;
var ButtonHandle criticalInfoBtn;
var ButtonHandle BuyBtn;
var ButtonHandle CloseBtn;
var WindowHandle dialogContainerWnd;
var WindowHandle confirmDialogWnd;
var WindowHandle resultDialogWnd;
var WindowHandle resultCriticalWnd;
var WindowHandle errorDialogWnd;
var UIControlNeedItemList needItemScript;
var UIControlNeedItemList dialogNeedItemScript;
var EffectViewportWndHandle ResultEffectViewport;

static function SkillSpExtractWnd Inst()
{
	return SkillSpExtractWnd(GetScript("SkillSpExtractWnd"));
}

function Initialize()
{
	InitControls();
	return;
}

function InitControls()
{
	local string ownerFullPath;
	local WindowHandle needItemWnd, dialogNeedItemWnd;
	local RichListCtrlHandle needItemRichList, dialogNeedItemRichList;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	ItemWnd = GetItemWindowHandle((ownerFullPath $ ".SpExtract_ItemWnd"));
	criticalTextBox = GetTextBoxHandle((ownerFullPath $ ".Critical_Txt"));
	itemNumTextBox = GetTextBoxHandle((ownerFullPath $ ".SpExtractNum_Txt"));
	itemNameTextBox = GetTextBoxHandle((ownerFullPath $ ".SpExtractTitle_Txt"));
	itemRateTextBox = GetTextBoxHandle((ownerFullPath $ ".Probability_Txt"));
	dailyCntTextBox = GetTextBoxHandle((ownerFullPath $ ".DailyCount_Txt"));
	dailyInfoBtn = GetButtonHandle((ownerFullPath $ ".Help01_Btn"));
	criticalInfoBtn = GetButtonHandle((ownerFullPath $ ".Help02_Btn"));
	BuyBtn = GetButtonHandle((ownerFullPath $ ".Ok_Btn"));
	CloseBtn = GetButtonHandle((ownerFullPath $ ".Cancel_Btn"));
	dialogContainerWnd = GetWindowHandle((ownerFullPath $ ".Dialog_Wnd"));
	confirmDialogWnd = GetWindowHandle((dialogContainerWnd.m_WindowNameWithFullPath $ ".Production_Wnd"));
	resultDialogWnd = GetWindowHandle((dialogContainerWnd.m_WindowNameWithFullPath $ ".Result_Wnd"));
	dialogRateTextBox = GetTextBoxHandle((confirmDialogWnd.m_WindowNameWithFullPath $ ".Probabaility_Txt"));
	resultItemWnd = GetItemWindowHandle((resultDialogWnd.m_WindowNameWithFullPath $ ".SpExtract_ItemWnd"));
	resultItemNameTextBox = GetTextBoxHandle((resultDialogWnd.m_WindowNameWithFullPath $ ".SpExtractTitle_Txt"));
	resultItemNumTextBox = GetTextBoxHandle((resultDialogWnd.m_WindowNameWithFullPath $ ".SpExtractNum_Txt"));
	resultDailyCntTextBox = GetTextBoxHandle((resultDialogWnd.m_WindowNameWithFullPath $ ".DailyCount_Txt"));
	resultDescTextBox = GetTextBoxHandle((resultDialogWnd.m_WindowNameWithFullPath $ ".Result_Txt"));
	resultCriticalWnd = GetWindowHandle((resultDialogWnd.m_WindowNameWithFullPath $ ".Critical_Wnd"));
	resultCritDailyCntTextBox = GetTextBoxHandle((resultCriticalWnd.m_WindowNameWithFullPath $ ".DailyCount_Txt"));
	resultCritLeftItemNumTextBox = GetTextBoxHandle((resultCriticalWnd.m_WindowNameWithFullPath $ ".SpExtractNum1_Txt"));
	resultCritLeftItemNameTextBox = GetTextBoxHandle((resultCriticalWnd.m_WindowNameWithFullPath $ ".SpExtractTitle1_Txt"));
	resultCritLeftItemWnd = GetItemWindowHandle((resultCriticalWnd.m_WindowNameWithFullPath $ ".SpExtract1_ItemWnd"));
	resultCritRightItemNumTextBox = GetTextBoxHandle((resultCriticalWnd.m_WindowNameWithFullPath $ ".SpExtractNum2_Txt"));
	resultCritRightItemNameTextBox = GetTextBoxHandle((resultCriticalWnd.m_WindowNameWithFullPath $ ".SpExtractTitle2_Txt"));
	resultCritRightItemWnd = GetItemWindowHandle((resultCriticalWnd.m_WindowNameWithFullPath $ ".SpExtract2_ItemWnd"));
	ResultEffectViewport = GetEffectViewportWndHandle((resultDialogWnd.m_WindowNameWithFullPath $ ".EnchantEffectViewport"));
	errorDialogWnd = GetWindowHandle((dialogContainerWnd.m_WindowNameWithFullPath $ ".Error_Wnd"));
	errorDescTextBox = GetTextBoxHandle((errorDialogWnd.m_WindowNameWithFullPath $ ".Description_Txt"));
	needItemWnd = GetWindowHandle((ownerFullPath $ ".Cost_Wnd"));
	needItemWnd.SetScript("UIControlNeedItemList");
	needItemScript = UIControlNeedItemList(needItemWnd.GetScript());
	needItemRichList = GetRichListCtrlHandle((needItemWnd.m_WindowNameWithFullPath $ ".Cost_RichList"));
	needItemScript.SetRichListControler(needItemRichList);
	needItemScript.DelegateOnUpdateItem = OnNeedItemUpdate;
	dialogNeedItemWnd = GetWindowHandle((confirmDialogWnd.m_WindowNameWithFullPath $ ".ProductionItemList_Wnd"));
	dialogNeedItemWnd.SetScript("UIControlNeedItemList");
	dialogNeedItemScript = UIControlNeedItemList(dialogNeedItemWnd.GetScript());
	dialogNeedItemRichList = GetRichListCtrlHandle((dialogNeedItemWnd.m_WindowNameWithFullPath $ ".ProductionItemList_RichList"));
	dialogNeedItemScript.SetRichListControler(dialogNeedItemRichList);
	return;
}

function ResetInfo()
{
	local SpExtractInfo defaultInfo;

	_spExctractInfo = defaultInfo;
	_spExctractInfo.Info.nRate = 100;
	_spExctractInfo.Info.nCriticalRate = 0;
	return;
}

function ShowConfirmDialog()
{
	UpdateConfirmDialogControls();
	confirmDialogWnd.ShowWindow();
	dialogContainerWnd.ShowWindow();
	return;
}

function ShowResultDialog(UIPacket._S_EX_SP_EXTRACT_ITEM packet)
{
	local ItemInfo ResultItemInfo, criticalItemInfo;
	local int resultItemCnt;
	local string resultDesc;

	resultCriticalWnd.HideWindow();
	if((packet.cResult == 0))
	{
		ResultItemInfo = GetItemInfoByClassID(_spExctractInfo.Info.nItemID);
		resultItemCnt = _spExctractInfo.Info.nExtractCount;
		ShowResultEffect(true);
		if((int(packet.bCritical) == 1))
		{
			resultDesc = GetSystemString(14308);
			criticalItemInfo = GetItemInfoByClassID(_spExctractInfo.Info.criticalItem.nItemClassID);
			if(!resultCritLeftItemWnd.SetItem(0, ResultItemInfo))
			{
				resultCritLeftItemWnd.AddItem(ResultItemInfo);
			}
			if(!resultCritRightItemWnd.SetItem(0, criticalItemInfo))
			{
				resultCritRightItemWnd.AddItem(criticalItemInfo);
			}
			resultCritLeftItemNameTextBox.SetText(ResultItemInfo.Name);
			resultCritLeftItemNumTextBox.SetText((GetSystemString(2503) @ string(resultItemCnt)));
			resultCritRightItemNameTextBox.SetText(criticalItemInfo.Name);
			resultCritRightItemNumTextBox.SetText((GetSystemString(2503) @ string(_spExctractInfo.Info.criticalItem.nAmount)));
			resultCriticalWnd.ShowWindow();
		}
		else
		{
			resultDesc = GetSystemString(13277);
		}
		Class'InterfaceClassic.SkillEnchantWnd'.static.Inst().ResetChargeInvenAndUpdate();
	}
	else if((packet.cResult == 1))
	{
		ResultItemInfo = GetItemInfoByClassID(_spExctractInfo.Info.failedItem.nItemClassID);
		resultItemCnt = int(_spExctractInfo.Info.failedItem.nAmount);
		resultDesc = GetSystemString(14309);
		ShowResultEffect(false);
	}
	if(!resultItemWnd.SetItem(0, ResultItemInfo))
	{
		resultItemWnd.AddItem(ResultItemInfo);
	}
	resultItemNameTextBox.SetText(ResultItemInfo.Name);
	resultItemNumTextBox.SetText((GetSystemString(2503) @ string(resultItemCnt)));
	resultDescTextBox.SetText(resultDesc);
	resultDialogWnd.ShowWindow();
	dialogContainerWnd.ShowWindow();
	return;
}

function ShowErrorDialog(UIPacket._S_EX_SP_EXTRACT_ITEM packet)
{
	if((packet.cResult == 3))
	{
		errorDescTextBox.SetText(GetSystemMessage(3675));
	}
	else
	{
		errorDescTextBox.SetText(GetSystemMessage(4559));
	}
	errorDialogWnd.ShowWindow();
	dialogContainerWnd.ShowWindow();
	return;
}

function ShowResultEffect(bool IsSuccess)
{
	if((Me.IsShowWindow() == false))
	{
		return;
	}
	if(IsSuccess)
	{
		ResultEffectViewport.ShowWindow();
		ResultEffectViewport.SetScale(0.8000000);
		ResultEffectViewport.SetCameraDistance(200.0000000);
		ResultEffectViewport.SetCameraPitch(0);
		ResultEffectViewport.SetCameraYaw(0);
		ResultEffectViewport.SpawnEffect("LineageEffect2.ui_upgrade_succ");
		PlaySound("Itemsound3.ui_enchant_success_sfx");
	}
	else
	{
		ResultEffectViewport.ShowWindow();
		ResultEffectViewport.SetScale(0.8000000);
		ResultEffectViewport.SetCameraDistance(200.0000000);
		ResultEffectViewport.SetCameraPitch(0);
		ResultEffectViewport.SetCameraYaw(0);
		ResultEffectViewport.SpawnEffect("LineageEffect2.ui_upgrade_fail");
		PlaySound("Itemsound3.ui_enchant_fail_sfx");
	}
	return;
}

function CloseDialog()
{
	dialogContainerWnd.HideWindow();
	resultDialogWnd.HideWindow();
	confirmDialogWnd.HideWindow();
	errorDialogWnd.HideWindow();
	return;
}

function UpdateItemInfoControls()
{
	local string tooltipStr;
	local ItemInfo criticalItemInfo;

	itemNameTextBox.SetText(_spExctractInfo.spExtractItemInfo.Name);
	itemNumTextBox.SetText((GetSystemString(2503) @ string(_spExctractInfo.Info.nExtractCount)));
	dailyCntTextBox.SetText((((GetSystemString(14305) @ string(_spExctractInfo.Info.nRemainCount)) $ "/") $ string(_spExctractInfo.Info.nMaxDailyCount)));
	if(!ItemWnd.SetItem(0, _spExctractInfo.spExtractItemInfo))
	{
		ItemWnd.AddItem(_spExctractInfo.spExtractItemInfo);
	}
	if((_spExctractInfo.Info.nRate >= 100))
	{
		itemRateTextBox.HideWindow();
	}
	else
	{
		itemRateTextBox.SetText((((GetSystemString(13938) @ ":") @ string(_spExctractInfo.Info.nRate)) $ "%"));
		itemRateTextBox.ShowWindow();
	}
	if((_spExctractInfo.Info.nCriticalRate <= 0))
	{
		criticalTextBox.HideWindow();
		criticalInfoBtn.HideWindow();
	}
	else
	{
		criticalTextBox.SetText(MakeFullSystemMsg(GetSystemMessage(13807), string(_spExctractInfo.Info.nCriticalRate)));
		criticalTextBox.ShowWindow();
		criticalItemInfo = GetItemInfoByClassID(_spExctractInfo.Info.criticalItem.nItemClassID);
		tooltipStr = ((MakeFullSystemMsg(GetSystemMessage(13814), criticalItemInfo.Name) @ "x") $ string(_spExctractInfo.Info.criticalItem.nAmount));
		criticalInfoBtn.SetTooltipCustomType(MakeTooltipSimpleText(tooltipStr));
		criticalInfoBtn.ShowWindow();
	}
	tooltipStr = ((MakeFullSystemMsg(GetSystemMessage(13813), string(_spExctractInfo.Info.nMaxDailyCount)) $ "\\n") $ GetSystemString(13872));
	dailyInfoBtn.SetTooltipCustomType(MakeTooltipSimpleText(tooltipStr));
	return;
}

function UpdateCostInfoControls()
{
	local ItemInfo needSpItemInfo;
	local UIPacket._ItemInfo needAddItemInfo;

	needItemScript.StartNeedItemList(2);
	needItemScript.SetBuyNum(INT64(1));
	needSpItemInfo = _spExctractInfo.spItemInfo;
	needAddItemInfo = _spExctractInfo.Info.commissionItem;
	needItemScript.AddNeedPoint(needSpItemInfo.Name, needSpItemInfo.IconName, _spExctractInfo.Info.nNeedSP, _spExctractInfo.haveSp);
	if(((needAddItemInfo.nItemClassID > 0) && (needAddItemInfo.nAmount > INT64(0))))
	{
		needItemScript.AddNeedItemClassID(needAddItemInfo.nItemClassID, needAddItemInfo.nAmount);
	}
	UpdateBuyBtnState();
	return;
}

function UpdateBuyBtnState()
{
	if((needItemScript.GetCanBuy() && (_spExctractInfo.Info.nRemainCount != 0)))
	{
		BuyBtn.SetEnable(true);
	}
	else
	{
		BuyBtn.SetEnable(false);
	}
	return;
}

function UpdateConfirmDialogControls()
{
	local ItemInfo needSpItemInfo;
	local UIPacket._ItemInfo needAddItemInfo;

	if((_spExctractInfo.Info.nRate >= 100))
	{
		dialogRateTextBox.HideWindow();
	}
	else
	{
		dialogRateTextBox.SetText((((GetSystemString(13938) @ ":") @ string(_spExctractInfo.Info.nRate)) $ "%"));
		dialogRateTextBox.ShowWindow();
	}
	dialogNeedItemScript.StartNeedItemList(2);
	dialogNeedItemScript.SetBuyNum(INT64(1));
	needSpItemInfo = _spExctractInfo.spItemInfo;
	needAddItemInfo = _spExctractInfo.Info.commissionItem;
	dialogNeedItemScript.AddNeedPoint(needSpItemInfo.Name, needSpItemInfo.IconName, _spExctractInfo.Info.nNeedSP, _spExctractInfo.haveSp);
	if(((needAddItemInfo.nItemClassID > 0) && (needAddItemInfo.nAmount > INT64(0))))
	{
		dialogNeedItemScript.AddNeedItemClassID(needAddItemInfo.nItemClassID, needAddItemInfo.nAmount);
	}
	return;
}

function UpdateResultDialogControls()
{
	local string dailyCntStr;

	dailyCntStr = (((GetSystemString(14305) @ string(_spExctractInfo.Info.nRemainCount)) $ "/") $ string(_spExctractInfo.Info.nMaxDailyCount));
	resultDailyCntTextBox.SetText(dailyCntStr);
	resultCritDailyCntTextBox.SetText(dailyCntStr);
	return;
}

function UpdateUIControls()
{
	UpdateItemInfoControls();
	UpdateCostInfoControls();
	UpdateResultDialogControls();
	return;
}

function Rq_C_EX_SP_EXTRACT_INFO()
{
	local array<byte> stream;
	local UIPacket._C_EX_SP_EXTRACT_INFO packet;

	packet.nItemID = 101571;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_SP_EXTRACT_INFO(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(825, stream);
	return;
}

function Rq_C_EX_SP_EXTRACT_ITEM()
{
	local array<byte> stream;
	local UIPacket._C_EX_SP_EXTRACT_ITEM packet;

	packet.nItemID = 101571;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_SP_EXTRACT_ITEM(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(826, stream);
	return;
}

function Rs_S_EX_SP_EXTRACT_INFO()
{
	local UIPacket._S_EX_SP_EXTRACT_INFO packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_SP_EXTRACT_INFO(packet))
	{
		return;
	}
	_spExctractInfo.Info = packet;
	UpdateUIControls();
	Debug(((((((("Rs_S_EX_SP_EXTRACT_INFO" @ string(packet.nItemID)) @ string(packet.nNeedSP)) @ string(packet.nRate)) @ string(packet.nCriticalRate)) @ string(packet.nRemainCount)) @ string(packet.nMaxDailyCount)) @ string(packet.commissionItem.nAmount)));
	return;
}

function Rs_S_EX_SP_EXTRACT_ITEM()
{
	local UIPacket._S_EX_SP_EXTRACT_ITEM packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_SP_EXTRACT_ITEM(packet))
	{
		return;
	}
	Debug(((("Rs_S_EX_SP_EXTRACT_ITEM" @ string(packet.cResult)) @ string(packet.nItemID)) @ string(packet.bCritical)));
	Rq_C_EX_SP_EXTRACT_INFO();
	if((packet.cResult < 2))
	{
		ShowResultDialog(packet);
	}
	else
	{
		ShowErrorDialog(packet);
	}
	return;
}

function Nt_EV_UpdateUserInfo()
{
	local UserInfo UserInfo;

	GetPlayerInfo(UserInfo);
	if((_spExctractInfo.haveSp != UserInfo.nSP))
	{
		_spExctractInfo.haveSp = UserInfo.nSP;
		UpdateCostInfoControls();
	}
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(1076));
	RegisterEvent(EV_PacketID(1077));
	RegisterEvent(180);
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case EV_PacketID(1076):
			Rs_S_EX_SP_EXTRACT_INFO();
			break;
		case EV_PacketID(1077):
			Rs_S_EX_SP_EXTRACT_ITEM();
			break;
		case 180:
			Nt_EV_UpdateUserInfo();
			break;
		default:
			break;
	}
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "Ok_Btn":
			ShowConfirmDialog();
			break;
		case "Cancel_Btn":
			Me.HideWindow();
			break;
		case "Dialog_Ok_Btn":
			Rq_C_EX_SP_EXTRACT_ITEM();
			CloseDialog();
			break;
		case "Dialog_Cancel_Btn":
			CloseDialog();
			break;
		case "Result_Ok_Btn":
			CloseDialog();
			break;
		case "ErrorDialog_Ok_Btn":
			CloseDialog();
			break;
		default:
			break;
	}
	return;
}

event OnNeedItemUpdate()
{
	if(Me.IsShowWindow())
	{
		UpdateBuyBtnState();
	}
	return;
}

event OnShow()
{
	local UserInfo UserInfo;

	Me.SetFocus();
	ResultEffectViewport.HideWindow();
	GetPlayerInfo(UserInfo);
	_spExctractInfo.haveSp = UserInfo.nSP;
	_spExctractInfo.spExtractItemInfo = GetItemInfoByClassID(101571);
	_spExctractInfo.spItemInfo = GetItemInfoByClassID(15624);
	CloseDialog();
	UpdateUIControls();
	Rq_C_EX_SP_EXTRACT_INFO();
	return;
}

event OnHide()
{
	CloseDialog();
	ResetInfo();
	needItemScript.CleariObjects();
	dialogNeedItemScript.CleariObjects();
	return;
}

event OnReceivedCloseUI()
{
	if(dialogContainerWnd.IsShowWindow())
	{
		CloseDialog();
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		Me.HideWindow();
	}
	return;
}
