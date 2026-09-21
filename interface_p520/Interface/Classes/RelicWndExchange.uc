class RelicWndExchange extends UICommonAPI
	dependson(UIPacket);

const TIMER_ID_RELIC_EXCHANGE_DELAY = 1;
const TIMER_DELAY_RELIC_EXCHANGE = 60000;

enum ERelicExchangeDialogType
{
	DIALOG_NONE,                    // 0
	EXCHANGE,                       // 1
	confirm,                        // 2
	Result,                         // 3
	Max                             // 4
};

var WindowHandle Me;
var WindowHandle dialogContainerWnd;
var WindowHandle relicTradeBgWnd;
var WindowHandle tradeTryWnd;
var WindowHandle relicCostWnd;
var WindowHandle tradeBtnWnd;
var WindowHandle relicDecideBgWnd;
var WindowHandle tradeResultWnd;
var WindowHandle listEmptyWnd;
var RichListCtrlHandle exchangeRichList;
var EffectViewportWndHandle dialogResultEffect;
var RelicWndSlot leftSlot;
var RelicWndSlot rightSlot;
var RelicWndSlot resultSlot;
var ButtonHandle dialogConfirmBtn;
var ButtonHandle dialogCancelBtn;
var TextBoxHandle countTextBox;
var TextBoxHandle dialogChangeCntTextBox;
var TextBoxHandle dialogResultNameTextBox;
var TextBoxHandle dialogResultTextBox;
var TextBoxHandle dialogRelicNameTextBox;
var UIControlNeedItem needItemScript;
var Rect btnWndRect;
var array<RelicWnd.RelicExchangeInfo> _exchangeInfos;
var RelicWnd.RelicExchangeInfo _selectedExchangeInfo;
var ERelicExchangeDialogType _dialogType;

static function RelicWndExchange Inst()
{
	return RelicWndExchange(GetScript("RelicWndExchange"));
}

function Initialize()
{
	InitControls();
	return;
}

function InitControls()
{
	local string ownerFullPath;
	local WindowHandle needItemWnd;
	local Rect parentRect;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	exchangeRichList = GetRichListCtrlHandle((ownerFullPath $ ".ExchangeList_ListCtrl"));
	dialogContainerWnd = GetWindowHandle((ownerFullPath $ ".RelicExchangePopupWnd"));
	relicTradeBgWnd = GetWindowHandle((dialogContainerWnd.m_WindowNameWithFullPath $ ".RelicTradeBgWnd"));
	tradeTryWnd = GetWindowHandle((dialogContainerWnd.m_WindowNameWithFullPath $ ".TradeTryWnd"));
	relicDecideBgWnd = GetWindowHandle((dialogContainerWnd.m_WindowNameWithFullPath $ ".RelicDecideBgWnd"));
	tradeResultWnd = GetWindowHandle((dialogContainerWnd.m_WindowNameWithFullPath $ ".TradeResultWnd"));
	relicCostWnd = GetWindowHandle((dialogContainerWnd.m_WindowNameWithFullPath $ ".RelicCostWnd"));
	tradeBtnWnd = GetWindowHandle((dialogContainerWnd.m_WindowNameWithFullPath $ ".TradeBtnWnd"));
	countTextBox = GetTextBoxHandle((ownerFullPath $ ".ListHeaderCoverWnd.RelicCount_txt"));
	listEmptyWnd = GetWindowHandle((ownerFullPath $ ".ListEmptyWnd"));
	exchangeRichList.SetTooltipType("SimpleRichListTooltip");
	exchangeRichList.SetSelectable(false);
	exchangeRichList.SetSelectedSelTooltip(false);
	exchangeRichList.SetUseStripeBackTexture(false);
	leftSlot = new Class'Interface.RelicWndSlot';
	leftSlot.Init(GetWindowHandle((tradeTryWnd.m_WindowNameWithFullPath $ ".RelicTrySlot00")));
	rightSlot = new Class'Interface.RelicWndSlot';
	rightSlot.Init(GetWindowHandle((tradeTryWnd.m_WindowNameWithFullPath $ ".RelicTrySlot01")));
	resultSlot = new Class'Interface.RelicWndSlot';
	resultSlot.Init(GetWindowHandle((tradeTryWnd.m_WindowNameWithFullPath $ ".RelicSlot_Result")));
	dialogConfirmBtn = GetButtonHandle((tradeBtnWnd.m_WindowNameWithFullPath $ ".TradeOk_Btn"));
	dialogCancelBtn = GetButtonHandle((tradeBtnWnd.m_WindowNameWithFullPath $ ".TradeCancle_Btn"));
	dialogChangeCntTextBox = GetTextBoxHandle((relicCostWnd.m_WindowNameWithFullPath $ ".TradeCount_txt"));
	dialogResultNameTextBox = GetTextBoxHandle((tradeResultWnd.m_WindowNameWithFullPath $ ".TradeResultRelicName_txt"));
	dialogResultTextBox = GetTextBoxHandle((tradeResultWnd.m_WindowNameWithFullPath $ ".RelicTradeResult_txt"));
	dialogResultEffect = GetEffectViewportWndHandle((tradeResultWnd.m_WindowNameWithFullPath $ ".TradeResultEffectViewport"));
	dialogRelicNameTextBox = GetTextBoxHandle((tradeBtnWnd.m_WindowNameWithFullPath $ ".ExchangeRelicName_txt"));
	needItemWnd = GetWindowHandle((relicCostWnd.m_WindowNameWithFullPath $ ".NeedItem"));
	needItemWnd.SetScript("UIControlNeedItem");
	needItemScript = UIControlNeedItem(needItemWnd.GetScript());
	needItemScript.Init(("RelicWnd." $ needItemWnd.m_WindowNameWithFullPath));
	needItemScript.DelegateItemUpdate = DelegateNeedItemOnUpdateItem;
	Class'Interface.RelicWnd'.static.Inst().DelegateChangeRelicExchangeList = OnChangeRelicExchangeList;
	parentRect = m_hOwnerWnd.GetRect();
	btnWndRect = tradeBtnWnd.GetRect();
	btnWndRect.nX = (btnWndRect.nX - parentRect.nX);
	btnWndRect.nY = (btnWndRect.nY - parentRect.nY);
	dialogContainerWnd.HideWindow();
	return;
}

function UpdateExchangeList()
{
	local int i, recordCnt, deleteIndex, textWidth, textHeight, RemainTime;
	local RichListCtrlRowData rowData;
	local L2Util util;
	local RelicWnd.RelicExchangeInfo exchangeInfo;
	local RelicsMainUIData relicUIData;
	local RelicsPlayUIData relicPlayData;
	local ItemInfo relicItemInfo;
	local bool exchangeExpired;
	local string remainTimeStr, costIconName;
	local L2ItemAmount costInfo;
	local int costIconWidth, costIconHeight;

	_exchangeInfos = Class'Interface.RelicWnd'.static.Inst().GetRelicExchangeInfos();
	rowData.cellDataList.Length = 5;
	deleteIndex = 0;
	util = L2Util(GetScript("L2Util"));
	recordCnt = exchangeRichList.GetRecordCount();
	i = 0;
	while((i < Max(_exchangeInfos.Length, recordCnt)))
	{
		if((i < _exchangeInfos.Length))
		{
			exchangeInfo = _exchangeInfos[i];
			GetRelicsMainData(exchangeInfo.Info.nRelicsID, relicUIData);
			relicItemInfo = GetItemInfoByClassID(relicUIData.ItemID);
			GetRelicsPlayData(ERPDT_Change, relicUIData.Grade, relicPlayData);
			exchangeExpired = false;
			RemainTime = (exchangeInfo.Info.nEndTime - Class'Interface.UIData'.static.Inst().GetCurrentRealLocalTimeSec());
			if(((exchangeInfo.Info.nRemainCount == 0) || (RemainTime <= 0)))
			{
				exchangeExpired = true;
				remainTimeStr = GetSystemString(14560);
			}
			else
			{
				remainTimeStr = util.getTimeStringBySec3(RemainTime);
			}
			rowData.cellDataList[0].drawitems.Length = 0;
			rowData.cellDataList[1].drawitems.Length = 0;
			rowData.cellDataList[2].drawitems.Length = 0;
			rowData.cellDataList[3].drawitems.Length = 0;
			rowData.cellDataList[4].drawitems.Length = 0;
			rowData.nReserved1 = INT64(exchangeInfo.Info.nIndex);
			rowData.nReserved2 = INT64(exchangeInfo.Info.nRelicsID);
			addRichListCtrlTexture(rowData.cellDataList[0].drawitems, GetGradeBGTextureStr(ERelicGrade(relicUIData.Grade)), 192, 112);
			addRichListCtrlTexture(rowData.cellDataList[0].drawitems, relicItemInfo.IconName, 44, 44, (33 - 192), 33);
			AddRichListCtrlString(rowData.cellDataList[0].drawitems, relicItemInfo.Name, util.GetRelicTextColor(ERelicGrade(relicUIData.Grade)), false, 22, 12, "hs11");
			AddRichListCtrlButton(rowData.cellDataList[1].drawitems, ("listProbBtn_" $ string(i)), 0, 0, "L2UI_NewTex.RelicWnd.TradeListBtn_N", "L2UI_NewTex.RelicWnd.TradeListBtn_D", "L2UI_NewTex.RelicWnd.TradeListBtn_O", 30, 30, 30, 30, 1, GetSystemString(14513));
			AddRichListCtrlString(rowData.cellDataList[1].drawitems, ((string(exchangeInfo.Info.nRemainCount) $ "/") $ string(exchangeInfo.Info.nMaxCount)), util.White, false, 20, 8);
			if((relicPlayData.CostItems.Length > (exchangeInfo.Info.nMaxCount - exchangeInfo.Info.nRemainCount)))
			{
				costInfo = relicPlayData.CostItems[(exchangeInfo.Info.nMaxCount - exchangeInfo.Info.nRemainCount)];
			}
			else
			{
				costInfo.ItemClassID = relicPlayData.CostItems[0].ItemClassID;
				costInfo.ItemAmount = 0;
			}
			GetCostIconByID(costInfo.ItemClassID, costIconName, costIconWidth, costIconHeight);
			addRichListCtrlTexture(rowData.cellDataList[2].drawitems, costIconName, costIconWidth, costIconHeight);
			AddRichListCtrlString(rowData.cellDataList[2].drawitems, MakeCostString(string(costInfo.ItemAmount)), util.ColorGold, false);
			AddRichListCtrlString(rowData.cellDataList[3].drawitems, remainTimeStr, util.White, true);
			GetTextSizeDefault(GetSystemString(14512), textWidth, textHeight);
			if(exchangeExpired)
			{
				addRichListCtrlTexture(rowData.cellDataList[4].drawitems, "L2UI_NewTex.Button.SimpleBtn_Disable", 108, 30);
				AddRichListCtrlString(rowData.cellDataList[4].drawitems, GetSystemString(14512), util.Gray, false, (-(108 + textWidth) / 2), ((30 - textHeight) / 2));
			}
			else
			{
				AddRichListCtrlButton(rowData.cellDataList[4].drawitems, ("listExchangeBtn_" $ string(i)), 0, 0, "L2UI_NewTex.Button.SimpleBtnBrown_DF", "L2UI_NewTex.Button.SimpleBtnBrown_Down", "L2UI_NewTex.Button.SimpleBtnBrown_Over", 108, 30, 108, 30);
				AddRichListCtrlString(rowData.cellDataList[4].drawitems, GetSystemString(14512), util.White, false, (-(108 + textWidth) / 2), ((30 - textHeight) / 2));
			}
			AddRichListCtrlString(rowData.cellDataList[4].drawitems, "", util.White, true, 0, 20);
			AddRichListCtrlButton(rowData.cellDataList[4].drawitems, ("listConfirmBtn_" $ string(i)), 0, 0, "L2UI_NewTex.Button.SimpleBtnBlue_DF", "L2UI_NewTex.Button.SimpleBtnBlue_Down", "L2UI_NewTex.Button.SimpleBtnBlue_Over", 108, 30, 108, 30);
			GetTextSizeDefault(GetSystemString(14493), textWidth, textHeight);
			AddRichListCtrlString(rowData.cellDataList[4].drawitems, GetSystemString(14493), util.White, false, (-(108 + textWidth) / 2), ((30 - textHeight) / 2));
			if((i < recordCnt))
			{
				exchangeRichList.ModifyRecord(i, rowData);
			}
			else
			{
				exchangeRichList.InsertRecord(rowData);
			}
			i++;
			continue;
		}
		exchangeRichList.DeleteRecord(((recordCnt - deleteIndex) - 1));
		deleteIndex++;
		i++;
	}
	countTextBox.SetText(((string(_exchangeInfos.Length) $ "/") $ string(Class'Interface.RelicWnd'.static.Inst().GetRelicUIInfo().exchangeMaxNum)));
	if((_exchangeInfos.Length > 0))
	{
		listEmptyWnd.HideWindow();
	}
	else
	{
		listEmptyWnd.ShowWindow();
	}
	return;
}

function ResetInfo()
{
	_exchangeInfos.Length = 0;
	needItemScript.RemoveInventoryObject();
	return;
}

function GetCostIconByID(int cID, out string IconName, out int iconWidth, out int iconHeight)
{
	local string Name;
	local int Width, Height;

	if((cID == 57))
	{
		Name = "L2UI_CT1.Icon.Icon_DF_Common_Adena";
		Width = 20;
		Height = 15;
	}
	else if((cID == 48472))
	{
		Name = "L2UI_EPIC.LCoinShopWnd.bm_einhasad_coin";
		Width = 18;
		Height = 18;
	}
	else
	{
		Name = GetItemInfoByClassID(cID).IconName;
		Width = 18;
		Height = 18;
	}
	IconName = Name;
	iconWidth = Width;
	iconHeight = Height;
	return;
}

function OnChangeRelicExchangeList()
{
	UpdateExchangeList();
	return;
}

function ShowExchangeDialog()
{
	local RelicsPlayUIData relicPlayData;
	local L2ItemAmount costInfo;
	local RelicWnd.RelicInfo RelicInfo;

	RelicInfo = Class'Interface.RelicWnd'.static.Inst().GetRelicInfo(_selectedExchangeInfo.Info.nRelicsID);
	RelicInfo.Level = 0;
	GetRelicsPlayData(ERPDT_Change, RelicInfo.Data.Grade, relicPlayData);
	if((relicPlayData.CostItems.Length > (_selectedExchangeInfo.Info.nMaxCount - _selectedExchangeInfo.Info.nRemainCount)))
	{
		costInfo = relicPlayData.CostItems[(_selectedExchangeInfo.Info.nMaxCount - _selectedExchangeInfo.Info.nRemainCount)];
	}
	else
	{
		costInfo.ItemClassID = 0;
		costInfo.ItemAmount = 0;
	}
	needItemScript.setId(GetItemID(costInfo.ItemClassID));
	needItemScript.SetNumNeed(INT64(costInfo.ItemAmount));
	relicTradeBgWnd.ShowWindow();
	tradeTryWnd.ShowWindow();
	relicCostWnd.ShowWindow();
	relicDecideBgWnd.HideWindow();
	tradeResultWnd.HideWindow();
	HideProbDialog();
	leftSlot.SetInfo(RelicInfo, true);
	rightSlot.SetInfo(RelicInfo, true, true);
	dialogChangeCntTextBox.SetText(((string(_selectedExchangeInfo.Info.nRemainCount) $ "/") $ string(_selectedExchangeInfo.Info.nMaxCount)));
	dialogResultTextBox.SetText(GetSystemString(14514));
	dialogRelicNameTextBox.SetText(GetItemInfoByClassID(RelicInfo.Data.ItemID).Name);
	dialogRelicNameTextBox.SetTextColor(getInstanceL2Util().GetRelicTextColor(ERelicGrade(RelicInfo.Data.Grade)));
	if(needItemScript.canBuy())
	{
		dialogConfirmBtn.SetEnable(true);
	}
	else
	{
		dialogConfirmBtn.SetEnable(false);
	}
	dialogCancelBtn.SetButtonName(141);
	dialogCancelBtn.SetEnable(true);
	dialogContainerWnd.ShowWindow();
	tradeBtnWnd.MoveC(btnWndRect.nX, btnWndRect.nY);
	_dialogType = EXCHANGE;
	return;
}

function ShowExchangeResultDialog(UIPacket._S_EX_RELICS_EXCHANGE packet)
{
	local RelicsPlayUIData relicPlayData;
	local L2ItemAmount costInfo;
	local RelicWnd.RelicInfo RelicInfo;

	if((packet.cResult != 1))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4334));
		HideModalAndDialog();
		return;
	}
	_selectedExchangeInfo.Info.nIndex = packet.nIndex;
	_selectedExchangeInfo.Info.nRelicsID = packet.nRelicsID;
	_selectedExchangeInfo.Info.nRemainCount = packet.nRemainCount;
	_selectedExchangeInfo.Info.nMaxCount = packet.nMaxCount;
	RelicInfo = Class'Interface.RelicWnd'.static.Inst().GetRelicInfo(_selectedExchangeInfo.Info.nRelicsID);
	RelicInfo.Level = 0;
	GetRelicsPlayData(ERPDT_Change, RelicInfo.Data.Grade, relicPlayData);
	if((relicPlayData.CostItems.Length > (_selectedExchangeInfo.Info.nMaxCount - _selectedExchangeInfo.Info.nRemainCount)))
	{
		costInfo = relicPlayData.CostItems[(_selectedExchangeInfo.Info.nMaxCount - _selectedExchangeInfo.Info.nRemainCount)];
	}
	else
	{
		costInfo = relicPlayData.CostItems[0];
		costInfo.ItemAmount = 0;
	}
	needItemScript.setId(GetItemID(costInfo.ItemClassID));
	needItemScript.SetNumNeed(INT64(costInfo.ItemAmount));
	resultSlot.SetInfo(RelicInfo, true);
	dialogChangeCntTextBox.SetText(((string(_selectedExchangeInfo.Info.nRemainCount) $ "/") $ string(_selectedExchangeInfo.Info.nMaxCount)));
	dialogResultNameTextBox.SetText(GetItemInfoByClassID(RelicInfo.Data.ItemID).Name);
	dialogResultNameTextBox.SetTextColor(getInstanceL2Util().GetRelicTextColor(ERelicGrade(RelicInfo.Data.Grade)));
	relicTradeBgWnd.ShowWindow();
	tradeTryWnd.HideWindow();
	relicCostWnd.ShowWindow();
	relicDecideBgWnd.HideWindow();
	tradeResultWnd.ShowWindow();
	dialogContainerWnd.ShowWindow();
	HideProbDialog();
	dialogConfirmBtn.SetEnable(true);
	dialogCancelBtn.SetEnable(true);
	dialogCancelBtn.SetButtonName(14172);
	dialogResultTextBox.SetText(GetSystemString(14586));
	if((_selectedExchangeInfo.Info.nRemainCount == 0))
	{
		dialogResultTextBox.SetText(GetSystemString(14559));
		dialogCancelBtn.SetEnable(false);
	}
	dialogResultEffect.SpawnEffect("LineageEffect2.ui_relic_card_high");
	PlaySound("InterfaceSound.ui_synthesis_success");
	tradeBtnWnd.MoveC(btnWndRect.nX, btnWndRect.nY);
	_dialogType = Result;
	return;
}

function ShowConfirmDialog()
{
	local RelicsPlayUIData relicPlayData;
	local RelicWnd.RelicInfo RelicInfo;

	RelicInfo = Class'Interface.RelicWnd'.static.Inst().GetRelicInfo(_selectedExchangeInfo.Info.nRelicsID);
	RelicInfo.Level = 0;
	GetRelicsPlayData(ERPDT_Change, RelicInfo.Data.Grade, relicPlayData);
	resultSlot.SetInfo(RelicInfo, true);
	dialogResultNameTextBox.SetText(GetItemInfoByClassID(RelicInfo.Data.ItemID).Name);
	dialogResultNameTextBox.SetTextColor(getInstanceL2Util().GetRelicTextColor(ERelicGrade(RelicInfo.Data.Grade)));
	relicTradeBgWnd.HideWindow();
	tradeTryWnd.HideWindow();
	relicCostWnd.HideWindow();
	relicDecideBgWnd.ShowWindow();
	tradeResultWnd.ShowWindow();
	dialogContainerWnd.ShowWindow();
	HideProbDialog();
	dialogConfirmBtn.SetEnable(true);
	dialogCancelBtn.SetEnable(true);
	dialogCancelBtn.SetButtonName(141);
	dialogResultTextBox.SetText(GetSystemString(14587));
	tradeBtnWnd.MoveC(btnWndRect.nX, (btnWndRect.nY - 90));
	_dialogType = confirm;
	return;
}

function ShowProbDialog(RelicWnd.RelicExchangeInfo Info)
{
	Class'Interface.RelicWnd'.static.Inst().relicExchangeProbScript.ShowInfo(Info);
	return;
}

function HideProbDialog()
{
	Class'Interface.RelicWnd'.static.Inst().relicExchangeProbScript.Me.HideWindow();
	return;
}

function HideModalAndDialog()
{
	HideDialog();
	HideProbDialog();
	return;
}

function HideDialog()
{
	dialogContainerWnd.HideWindow();
	_dialogType = DIALOG_NONE;
	return;
}

function bool IsShowDialog()
{
	return dialogContainerWnd.IsShowWindow();
}

function StartRemainTimer()
{
	KillRemainTimer();
	Me.SetTimer(1, 60000);
	return;
}

function KillRemainTimer()
{
	Me.KillTimer(1);
	return;
}

function CheckAndClickListBtn(string btnName)
{
	local array<string> names;

	Split(btnName, "_", names);
	if((names[0] == "listExchangeBtn"))
	{
		OnListExchangeBtnClicked(int(names[1]));
		return;
	}
	if((names[0] == "listConfirmBtn"))
	{
		OnListConfirmBtnClicked(int(names[1]));
		return;
	}
	if((names[0] == "listProbBtn"))
	{
		OnListProbBtnClicked(int(names[1]));
		return;
	}
	return;
}

function SetSelectedExchangeInfo(int Index)
{
	if((Index < _exchangeInfos.Length))
	{
		_selectedExchangeInfo = _exchangeInfos[Index];
	}
	return;
}

function SetScrollToTop()
{
	exchangeRichList.SetSelectedIndex(0, true);
	exchangeRichList.SetSelectedIndex(-1, false);
	return;
}

function string GetGradeBGTextureStr(UIConstants.ERelicGrade Grade)
{
	switch(Grade)
	{
		case RG_C:
			return "L2UI_NewTex.RelicWnd.TradeGradeBg_C";
		case RG_B:
			return "L2UI_NewTex.RelicWnd.TradeGradeBg_B";
		case RG_A:
			return "L2UI_NewTex.RelicWnd.TradeGradeBg_A";
		default:
			return "";
	}
}

function DelegateNeedItemOnUpdateItem(UIControlNeedItem Script)
{
	return;
}

event OnClickButton(string Name)
{
	if((Name == "TradeOk_Btn"))
	{
		if((int(_dialogType) == 1))
		{
			Class'Interface.RelicWnd'.static.Inst().Rq_C_EX_RELICS_EXCHANGE(_selectedExchangeInfo.Info.nIndex, _selectedExchangeInfo.Info.nRelicsID);
			dialogConfirmBtn.SetEnable(false);
			dialogCancelBtn.SetEnable(false);
		}
		else if((int(_dialogType) == 2))
		{
			Class'Interface.RelicWnd'.static.Inst().Rq_C_EX_RELICS_EXCHANGE_CONFIRM(_selectedExchangeInfo.Info.nIndex, _selectedExchangeInfo.Info.nRelicsID);
			HideDialog();
		}
		else if((int(_dialogType) == 3))
		{
			HideDialog();
		}
	}
	else if((Name == "TradeCancle_Btn"))
	{
		if((int(_dialogType) == 3))
		{
			ShowExchangeDialog();
		}
		else
		{
			HideDialog();
		}
	}
	else
	{
		CheckAndClickListBtn(Name);
	}
	return;
}

event OnTimer(int TimerID)
{
	if((TimerID == 1))
	{
		UpdateExchangeList();
	}
	return;
}

event OnListExchangeBtnClicked(int Index)
{
	SetSelectedExchangeInfo(Index);
	ShowExchangeDialog();
	return;
}

event OnListConfirmBtnClicked(int Index)
{
	SetSelectedExchangeInfo(Index);
	ShowConfirmDialog();
	return;
}

event OnListProbBtnClicked(int Index)
{
	SetSelectedExchangeInfo(Index);
	ShowProbDialog(_selectedExchangeInfo);
	return;
}

event OnLoad()
{
	Initialize();
	return;
}
