class ShopDailyLcoinWnd extends UICommonAPI;

const DIALOG_ASK_PRICE = 10111;
const MAX_CATEGORY = 6;
const TIMER_CLICK = 99902;
const TIMER_DELAYC = 3000;
const TIMER_FOCUS = 99903;
const TIMER_FOCUS_DELAY = 100;
const MAXITEMNUM = 99999;

struct LimitShopItemInfo
{
	var int ItemClassID;
	var int ReseetType;
	var int ConditionLevel;
	var int MaxItemAmount;
	var int COSTITEMNUM;
	var array<int> costItemID;
	var array<INT64> CostItemAmount;
	var array<INT64> CostItemSaleAmount;
	var array<float> CostItemSaleRate;
	var INT64 SellCostAdena;
	var INT64 SellCostCoin;
	var int RemainItemAmount;
	var int SellCategory;
	var int EventType;
	var int EventRemainSec;
	var int SlotNum;
};

struct SelectedCategoryInfo
{
	var int ItemClassID;
	var int SlotNum;
};

var WindowHandle Me;
var CheckBoxHandle ListOption_CheckBox;
var ItemWindowHandle NeededItem_Item1Num_Item;
var TextBoxHandle NeededItem_Item1_Title;
var TextBoxHandle NeededItem_Item1Num_text;
var TextBoxHandle NeededItem_Item1MyNum_text;
var ItemWindowHandle NeededItem_Item2Num_Item;
var TextBoxHandle NeededItem_Item2_Title;
var TextBoxHandle NeededItem_Item2Num_text;
var TextBoxHandle NeededItem_Item2MyNum_text;
var ItemWindowHandle NeededItem_Item3Num_Item;
var TextBoxHandle NeededItem_Item3_Title;
var TextBoxHandle NeededItem_Item3Num_text;
var TextBoxHandle NeededItem_Item3MyNum_text;
var TextureHandle CostItem01_Sale;
var TextureHandle CostItem02_Sale;
var TextureHandle CostItem03_Sale;
var TextBoxHandle CostItem01Sale_TextBox;
var TextBoxHandle CostItem02Sale_TextBox;
var TextBoxHandle CostItem03Sale_TextBox;
var EditBoxHandle ItemCount_EditBox;
var ButtonHandle Reset_Btn;
var ButtonHandle Buy_Btn;
var ButtonHandle MultiSell_Up_Button;
var ButtonHandle MultiSell_Down_Button;
var ButtonHandle MultiSell_Input_Button;
var ButtonHandle FrameHelp_BTN;
var WindowHandle disableWnd;
var ButtonHandle Refresh_Button;
var TextBoxHandle ItemNum_TextBox;
var WindowHandle ShopDailyConfirm_ResultWnd;
var WindowHandle ShopDailySuccess_ResultWnd;
var WindowHandle ShopDailyFails_ResultWnd;
var TabHandle LcoinShopList_Tab;
var TextureHandle tabbgLine;
var string m_Windowname;
var int shopIndexCurrent;
var INT64 bloodCoinCount;
var int currentShopCategory;
var int PcCafePoint;
var array<SelectedCategoryInfo> selectedCategoryInfoArray;
var array<LimitShopItemInfo> itemListArray;
var L2Util util;

function Initialize()
{
	local int i;

	Me = GetWindowHandle(m_Windowname);
	ListOption_CheckBox = GetCheckBoxHandle((m_Windowname $ ".List_Wnd.ListOption_CheckBox"));
	NeededItem_Item1Num_Item = GetItemWindowHandle((m_Windowname $ ".ItemInfo_Wnd.CostItem01_ItemWindow"));
	NeededItem_Item1_Title = GetTextBoxHandle((m_Windowname $ ".ItemInfo_Wnd.CostItem01Title_TextBox"));
	NeededItem_Item1Num_text = GetTextBoxHandle((m_Windowname $ ".ItemInfo_Wnd.CostItem01NumTitle_TextBox"));
	NeededItem_Item1MyNum_text = GetTextBoxHandle((m_Windowname $ ".ItemInfo_Wnd.CostItem01MyNumTitle_TextBox"));
	NeededItem_Item2Num_Item = GetItemWindowHandle((m_Windowname $ ".ItemInfo_Wnd.CostItem02_ItemWindow"));
	NeededItem_Item2_Title = GetTextBoxHandle((m_Windowname $ ".ItemInfo_Wnd.CostItem02Title_TextBox"));
	NeededItem_Item2Num_text = GetTextBoxHandle((m_Windowname $ ".ItemInfo_Wnd.CostItem02NumTitle_TextBox"));
	NeededItem_Item2MyNum_text = GetTextBoxHandle((m_Windowname $ ".ItemInfo_Wnd.CostItem02MyNumTitle_TextBox"));
	NeededItem_Item3Num_Item = GetItemWindowHandle((m_Windowname $ ".ItemInfo_Wnd.CostItem03_ItemWindow"));
	NeededItem_Item3_Title = GetTextBoxHandle((m_Windowname $ ".ItemInfo_Wnd.CostItem03Title_TextBox"));
	NeededItem_Item3Num_text = GetTextBoxHandle((m_Windowname $ ".ItemInfo_Wnd.CostItem03NumTitle_TextBox"));
	NeededItem_Item3MyNum_text = GetTextBoxHandle((m_Windowname $ ".ItemInfo_Wnd.CostItem03MyNumTitle_TextBox"));
	CostItem01Sale_TextBox = GetTextBoxHandle((m_Windowname $ ".ItemInfo_Wnd.CostItem01Sale_TextBox"));
	CostItem02Sale_TextBox = GetTextBoxHandle((m_Windowname $ ".ItemInfo_Wnd.CostItem01Sale_TextBox"));
	CostItem03Sale_TextBox = GetTextBoxHandle((m_Windowname $ ".ItemInfo_Wnd.CostItem01Sale_TextBox"));
	ItemCount_EditBox = GetEditBoxHandle((m_Windowname $ ".ItemInfo_Wnd.ItemCount_EditBox"));
	Reset_Btn = GetButtonHandle((m_Windowname $ ".ItemInfo_Wnd.Reset_Btn"));
	Buy_Btn = GetButtonHandle((m_Windowname $ ".ItemInfo_Wnd.Buy_Btn"));
	MultiSell_Up_Button = GetButtonHandle((m_Windowname $ ".ItemInfo_Wnd.MultiSell_Up_Button"));
	MultiSell_Down_Button = GetButtonHandle((m_Windowname $ ".ItemInfo_Wnd.MultiSell_Down_Button"));
	MultiSell_Input_Button = GetButtonHandle((m_Windowname $ ".ItemInfo_Wnd.MultiSell_Input_Button"));
	FrameHelp_BTN = GetButtonHandle((m_Windowname $ ".ItemInfo_Wnd.FrameHelp_BTN"));
	disableWnd = GetWindowHandle((m_Windowname $ ".DisableWnd"));
	Refresh_Button = GetButtonHandle((m_Windowname $ ".ListRefesh_Btn"));
	ShopDailyConfirm_ResultWnd = GetWindowHandle((m_Windowname $ ".ShopDailyConfirm_ResultWnd"));
	ItemNum_TextBox = GetTextBoxHandle((m_Windowname $ ".ShopDailyConfirm_ResultWnd.ItemNum_TextBox"));
	ShopDailySuccess_ResultWnd = GetWindowHandle((m_Windowname $ ".ShopDailySuccess_ResultWnd"));
	ShopDailyFails_ResultWnd = GetWindowHandle((m_Windowname $ ".ShopDailyFails_ResultWnd"));
	LcoinShopList_Tab = GetTabHandle((m_Windowname $ ".ItemInfo_Wnd.LcoinShopList_Tab"));
	tabbgLine = GetTextureHandle((m_Windowname $ ".ItemInfo_Wnd.tabbgLine"));
	util = L2Util(GetScript("L2Util"));
	i = 1;
	while((i < 6))
	{
		getListCtrlByCategory(i).SetSelectedSelTooltip(false);
		getListCtrlByCategory(i).SetAppearTooltipAtMouseX(true);
		i++;
	}
	FormChangeByServerType();
	return;
}

function FormChangeByServerType()
{
	if(!getInstanceUIData().GetIsClassicServer())
	{
		FrameHelp_BTN.HideWindow();
		LcoinShopList_Tab.RemoveTabControl(4);
		LcoinShopList_Tab.RemoveTabControl(3);
		LcoinShopList_Tab.RemoveTabControl(2);
		LcoinShopList_Tab.RemoveTabControl(1);
		LcoinShopList_Tab.SetButtonName(0, GetSystemString(144));
		tabbgLine.SetWindowSize(718, 23);
	}
	else if(IsAdenServer())
	{
		tabbgLine.SetWindowSize(270, 23);
		LcoinShopList_Tab.SetTabControlTexture(0, "L2UI_ct1.tab.Tab_DF_Tab_LimitLarge_Unselected", "L2UI_ct1.tab.Tab_DF_Tab_LimitLarge_Selected", "L2UI_ct1.tab.Tab_DF_Tab_LimitLarge_Unselected_Over");
		LcoinShopList_Tab.SetButtonName(0, GetSystemString(13196));
		LcoinShopList_Tab.SetButtonName(1, GetSystemString(116));
		LcoinShopList_Tab.SetButtonName(2, GetSystemString(3963));
		LcoinShopList_Tab.SetButtonName(3, GetSystemString(5006));
		LcoinShopList_Tab.SetButtonName(4, GetSystemString(49));
	}
	else
	{
		LcoinShopList_Tab.RemoveTabControl(4);
		tabbgLine.SetWindowSize(382, 23);
		LcoinShopList_Tab.SetTabControlTexture(0, "L2UI_ct1.tab.Tab_DF_Tab_Unselected", "L2UI_ct1.tab.Tab_DF_Tab_Selected", "L2UI_ct1.tab.Tab_DF_Tab_Unselected_Over");
		LcoinShopList_Tab.SetButtonName(0, GetSystemString(116));
		LcoinShopList_Tab.SetButtonName(1, GetSystemString(3963));
		LcoinShopList_Tab.SetButtonName(2, GetSystemString(5006));
		LcoinShopList_Tab.SetButtonName(3, GetSystemString(49));
	}
	return;
}

function ListCtrlHandle getListCtrlByCategory(int nCategory)
{
	return GetListCtrlHandle(((m_Windowname $ ".List_Wnd.List_ListCtrl") $ string(nCategory)));
}

function API_RequestPurchaseLimitShopItemBuy(int nSlotNum, int nItemAmount)
{
	RequestPurchaseLimitShopItemBuy(shopIndexCurrent, nSlotNum, nItemAmount);
	return;
}

function API_RequestPurchaseLimitShopItemList()
{
	RequestPurchaseLimitShopItemList(shopIndexCurrent);
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(11061);
	RegisterEvent(11062);
	RegisterEvent(11063);
	RegisterEvent(11064);
	RegisterEvent(1710);
	RegisterEvent(1720);
	RegisterEvent(11060);
	RegisterEvent(9570);
	RegisterEvent(180);
	RegisterEvent(1910);
	return;
}

function OnLoad()
{
	Initialize();
	SetClosingOnESC();
	currentShopCategory = 1;
	initSelectedItemIDArray();
	return;
}

function initSelectedItemIDArray()
{
	local SelectedCategoryInfo nullItemInfo;

	selectedCategoryInfoArray[0] = nullItemInfo;
	selectedCategoryInfoArray[1] = nullItemInfo;
	selectedCategoryInfoArray[2] = nullItemInfo;
	selectedCategoryInfoArray[3] = nullItemInfo;
	selectedCategoryInfoArray[4] = nullItemInfo;
	selectedCategoryInfoArray[5] = nullItemInfo;
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 11061:
			ParseInt(param, "ShopIndex", shopIndexCurrent);
			ClearAll();
			break;
		case 11062:
			if(!IsMyShopIndex(param))
			{
				return;
			}
			HandleItemList(param);
			break;
		case 11063:
			if(!IsMyShopIndex(param))
			{
				return;
			}
			ItemListInfoEnd();
			break;
		case 11064:
			if(!IsMyShopIndex(param))
			{
				return;
			}
			HandleBuyResult(param);
			break;
		case 11060:
			break;
		case 9570:
			break;
		case 180:
			if(Me.IsShowWindow())
			{
				HandleUserInfo();
			}
			break;
		case 1710:
			HandleDialogOK(true);
			break;
		case 1720:
			HandleDialogOK(false);
			break;
		case 1910:
			pcCafePointInfoHandler(param);
			break;
		default:
			break;
	}
	return;
}

function pcCafePointInfoHandler(string param)
{
	ParseInt(param, "TotalPoint", PcCafePoint);
	return;
}

function OnClickButton(string Name)
{
	local string strID;

	switch(Name)
	{
		case "Buy_Btn":
			OnBuy_ButtonClick();
			break;
		case "ListRefesh_Btn":
			OnRefresh_ButtonClick();
			break;
		case "OK_Button":
			OnOK_ButtonClick();
			break;
		case "Cancel_Button":
			OnCancel_ButtonClick();
			break;
		case "Success_Button":
			OnSuccess_ButtonClick();
			break;
		case "Fail_Button":
			OnFail_ButtonClick();
			break;
		case "MultiSell_Input_Button":
			OnPriceEditBtnHandler();
			break;
		case "MultiSell_Up_Button":
			OnMultiSell_Up_ButtonClick();
			break;
		case "MultiSell_Down_Button":
			OnMultiSell_Down_ButtonClick();
			break;
		case "Reset_Btn":
			SetItemCountEditBox(1);
			break;
		case "FrameHelp_BTN":
			OnClickHelp();
			break;
		default:
			break;
	}
	if((Left(Name, Len("LcoinShopList_Tab")) == "LcoinShopList_Tab"))
	{
		strID = Mid(Name, Len("LcoinShopList_Tab"));
		currentShopCategory = (int(strID) + 1);
		showCategoryList(currentShopCategory);
	}
	return;
}

function OnClickHelp()
{
	local string strParam;

	if(getInstanceUIData().GetIsClassicServer())
	{
		ParamAdd(strParam, "FilePath", (GetLocalizedL2TextPathNameUC() $ "lcoinshop_helper001.htm"));
		ExecuteEvent(1210, strParam);
	}
	return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
	if(Buy_Btn.IsEnableWindow())
	{
		OnBuy_ButtonClick();
	}
	return;
}

function showCategoryList(int nCategory)
{
	local int i;

	i = 1;
	while((i < 6))
	{
		if((i == nCategory))
		{
			getListCtrlByCategory(i).ShowWindow();
			i++;
			continue;
		}
		getListCtrlByCategory(i).HideWindow();
		i++;
	}
	OnClickListCtrlRecord("List_ListCtrl");
	return;
}

function OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case 99902:
			Refresh_Button.EnableWindow();
			Me.KillTimer(99902);
		case 99903:
			getListCtrlByCategory(currentShopCategory).SetFocus();
			Me.KillTimer(99903);
			break;
		default:
			break;
	}
	return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
	local ItemInfo Info;
	local UserInfo infoPlayer;
	local LVDataRecord Record;

	Record = GetSelectedRecord();
	getListCtrlByCategory(currentShopCategory).GetSelectedRec(Record);
	GetPlayerInfo(infoPlayer);
	Info = GetItemInfoByRecord(Record);
	Class'NWindow.UIAPI_MULTISELLITEMINFO'.static.Clear((m_Windowname $ ".ItemInfo_MultiSell"));
	if((Info.Id.ClassID > -1))
	{
		selectedCategoryInfoArray[currentShopCategory].ItemClassID = Info.Id.ClassID;
		selectedCategoryInfoArray[currentShopCategory].SlotNum = GetSlotNumByRecord(Record);
		Class'NWindow.UIAPI_MULTISELLITEMINFO'.static.SetItemInfo((m_Windowname $ ".ItemInfo_MultiSell"), 0, Info);
		SetItemCountEditBox(1);
	}
	else
	{
		SetItemCountEditBox(0);
	}
	Me.KillTimer(99903);
	Me.SetTimer(99903, 100);
	return;
}

function OnClickCheckBox(string strID)
{
	switch(strID)
	{
		case "ListOption_CheckBox":
			ItemListInfoEnd();
			break;
		default:
			break;
	}
	return;
}

function OnChangeEditBox(string strID)
{
	switch(strID)
	{
		case "ItemCount_EditBox":
			HandleEditBox();
			SetItemCountEditBox(int(ItemCount_EditBox.GetString()));
			break;
		default:
			break;
	}
	return;
}

function OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	return;
}

function OnRefresh_ButtonClick()
{
	API_RequestPurchaseLimitShopItemList();
	Me.SetTimer(99902, 3000);
	Refresh_Button.DisableWindow();
	return;
}

function OnPriceEditBtnHandler()
{
	disableWnd.ShowWindow();
	disableWnd.SetFocus();
	DialogSetID(10111);
	DialogSetEditBoxMaxLength(6);
	DialogSetCancelD(10111);
	DialogSetEditType("number");
	DialogSetDefaultOK();
	DialogShow(DialogModalType_Modalless, DialogType_NumberPad, GetSystemMessage(4362));
	return;
}

function OnBuy_ButtonClick()
{
	disableWnd.ShowWindow();
	disableWnd.SetFocus();
	SetBuyConfirmWnd();
	ShopDailyConfirm_ResultWnd.ShowWindow();
	ItemCount_EditBox.HideWindow();
	return;
}

function OnOK_ButtonClick()
{
	local LVDataRecord Record;

	Record = GetSelectedRecord();
	API_RequestPurchaseLimitShopItemBuy(GetSlotNumByRecord(Record), int(ItemCount_EditBox.GetString()));
	ShopDailyConfirm_ResultWnd.HideWindow();
	return;
}

function OnCancel_ButtonClick()
{
	disableWnd.HideWindow();
	ItemCount_EditBox.ShowWindow();
	ShopDailyConfirm_ResultWnd.HideWindow();
	return;
}

function OnSuccess_ButtonClick()
{
	disableWnd.HideWindow();
	ShopDailySuccess_ResultWnd.HideWindow();
	ItemCount_EditBox.ShowWindow();
	API_RequestPurchaseLimitShopItemList();
	return;
}

function OnFail_ButtonClick()
{
	disableWnd.HideWindow();
	ShopDailyFails_ResultWnd.HideWindow();
	ItemCount_EditBox.ShowWindow();
	API_RequestPurchaseLimitShopItemList();
	return;
}

function OnMultiSell_Up_ButtonClick()
{
	SetItemCountEditBox((int(ItemCount_EditBox.GetString()) + 1));
	return;
}

function OnMultiSell_Down_ButtonClick()
{
	SetItemCountEditBox((int(ItemCount_EditBox.GetString()) - 1));
	return;
}

function ClearAll()
{
	local int i;

	itemListArray.Remove(0, itemListArray.Length);
	i = 1;
	while((i < 6))
	{
		getListCtrlByCategory(i).DeleteAllItem();
		i++;
	}
	ShopDailyConfirm_ResultWnd.HideWindow();
	ShopDailySuccess_ResultWnd.HideWindow();
	ShopDailyFails_ResultWnd.HideWindow();
	disableWnd.HideWindow();
	ItemCount_EditBox.ShowWindow();
	return;
}

function HandleUserInfo()
{
	local LVDataRecord Record;
	local int minNum;

	if(getInstanceUIData().IsLevelUP())
	{
		ModifyRecords();
		Record = GetSelectedRecord();
		minNum = int(ItemCount_EditBox.GetString());
		if((minNum == 0))
		{
			if(CanBuyByRecord(Record))
			{
				ItemCount_EditBox.SetString("1");
				return;
			}
		}
		SetControlerBtns();
	}
	return;
}

function ModifyRecords()
{
	local int i, Index;
	local LVDataRecord Record;

	i = 0;
	while((i < itemListArray.Length))
	{
		Record = makeRecord(itemListArray[i]);
		Index = FindItemIndex(getListCtrlIndexSellCategory(itemListArray[i].SellCategory), itemListArray[i].SlotNum);
		if((Index != -1))
		{
			getListCtrlByCategory(getListCtrlIndexSellCategory(itemListArray[i].SellCategory)).ModifyRecord(Index, Record);
		}
		i++;
	}
	return;
}

function int getListCtrlIndexSellCategory(int nSellCategory)
{
	switch(nSellCategory)
	{
		case 1:
			return 1;
			break;
		case 2:
			return 2;
			break;
		case 3:
			return 3;
			break;
		case 4:
			return 4;
			break;
		default:
			return nSellCategory;
			break;
	}
	return -1;
}

function bool CanBuyByRecord(LVDataRecord Record)
{
	return (GetCountCanBuy(Record) > 0);
}

function INT64 GetNeedAdena(LVDataRecord Record)
{
	local LVDataRecord nullRecord;

	if((Record == nullRecord))
	{
		return INT64(0);
	}
	return Record.nReserved1;
}

function INT64 GetNeedCoin(LVDataRecord Record)
{
	local LVDataRecord nullRecord;

	if((Record == nullRecord))
	{
		return INT64(0);
	}
	return Record.nReserved2;
}

function int GetNeedLevel(LVDataRecord Record)
{
	local LVDataRecord nullRecord;

	if((Record == nullRecord))
	{
		return 0;
	}
	return Record.LVDataList[1].nReserved1;
}

function int GetCurrentAmount(LVDataRecord Record)
{
	local LVDataRecord nullRecord;

	if((Record == nullRecord))
	{
		return 0;
	}
	if((Record.LVDataList[2].nReserved2 == 0))
	{
		return 99999;
	}
	return Record.LVDataList[2].nReserved1;
}

function ItemInfo GetItemInfoByRecord(LVDataRecord Record)
{
	local ItemInfo Info;

	ParamToItemInfo(Record.szReserved, Info);
	return Info;
}

function int GetSlotNumByRecord(LVDataRecord Record)
{
	return Record.LVDataList[2].nReserved3;
}

function int GetCountCanBuy(LVDataRecord Record)
{
	local int Count;
	local array<int> arrID;
	local array<INT64> arrAmount;

	Count = 0;
	if((Record.nReserved1 != INT64(0)))
	{
		Count++;
		arrID.Insert(arrID.Length, 1);
		arrID[0] = Record.LVDataList[3].nReserved1;
		arrAmount.Insert(arrID.Length, 1);
		arrAmount[0] = Record.nReserved1;
	}
	if((Record.nReserved2 != INT64(0)))
	{
		Count++;
		arrID.Insert(arrID.Length, 1);
		arrID[1] = Record.LVDataList[3].nReserved2;
		arrAmount.Insert(arrID.Length, 1);
		arrAmount[1] = Record.nReserved2;
	}
	if((Record.nReserved3 != INT64(0)))
	{
		Count++;
		arrID.Insert(arrID.Length, 1);
		arrID[2] = Record.LVDataList[3].nReserved3;
		arrAmount.Insert(arrID.Length, 1);
		arrAmount[2] = Record.nReserved3;
	}
	return GetCountCanBuyBuStruct(Record.LVDataList[1].nReserved1, Count, arrID, arrAmount, GetCurrentAmount(Record));
}

function int GetCountCanBuyBuStruct(int needLevel, int COSTITEMNUM, array<int> costItemID, array<INT64> CostItemAmount, int Amount)
{
	local UserInfo Info;
	local int i;

	if(!GetPlayerInfo(Info))
	{
		return 0;
	}
	if((Info.nLevel < needLevel))
	{
		return 0;
	}
	if((Amount == 0))
	{
		return 0;
	}
	i = 0;
	while((i < COSTITEMNUM))
	{
		if((costItemID[i] == 0))
		{
			i++;
			continue;
		}
		switch(costItemID[i])
		{
			case -100:
				Amount = Min(Amount, GetCountCanByAmount(CostItemAmount[i], INT64(PcCafePoint)));
				break;
			default:
				Amount = Min(Amount, GetCountCanByAmount(CostItemAmount[i], GetInventoryItemCount(GetItemID(costItemID[i]))));
				break;
		}
		i++;
	}
	return Amount;
}

function int GetCountCanByAmount(INT64 CostItemAmount, INT64 currentItemAmount)
{
	return int((currentItemAmount / CostItemAmount));
}

function HandleItemList(string param)
{
	local LimitShopItemInfo _limitShopItemInfo;
	local int i;

	ParseInt(param, "ItemClassID", _limitShopItemInfo.ItemClassID);
	ParseInt(param, "ReseetType", _limitShopItemInfo.ReseetType);
	ParseInt(param, "ConditionLevel", _limitShopItemInfo.ConditionLevel);
	ParseInt(param, "MaxItemAmount", _limitShopItemInfo.MaxItemAmount);
	ParseInt(param, "CostItemNum", _limitShopItemInfo.COSTITEMNUM);
	ParseInt(param, "SlotNum", _limitShopItemInfo.SlotNum);
	_limitShopItemInfo.costItemID.Length = _limitShopItemInfo.COSTITEMNUM;
	_limitShopItemInfo.CostItemAmount.Length = _limitShopItemInfo.COSTITEMNUM;
	_limitShopItemInfo.CostItemSaleAmount.Length = _limitShopItemInfo.COSTITEMNUM;
	_limitShopItemInfo.CostItemSaleRate.Length = _limitShopItemInfo.COSTITEMNUM;
	i = 0;
	while((i < _limitShopItemInfo.COSTITEMNUM))
	{
		ParseInt(param, ("CostItemId_" $ string(i)), _limitShopItemInfo.costItemID[i]);
		ParseINT64(param, ("CostItemAmount_" $ string(i)), _limitShopItemInfo.CostItemAmount[i]);
		ParseINT64(param, ("CostItemSaleAmount_" $ string(i)), _limitShopItemInfo.CostItemSaleAmount[i]);
		ParseFloat(param, ("CostItemSaleRate_" $ string(i)), _limitShopItemInfo.CostItemSaleRate[i]);
		i++;
	}
	ParseInt(param, "RemainItemAmount", _limitShopItemInfo.RemainItemAmount);
	ParseInt(param, "SellCategory", _limitShopItemInfo.SellCategory);
	ParseInt(param, "EventType", _limitShopItemInfo.EventType);
	ParseInt(param, "EventRemainSec", _limitShopItemInfo.EventRemainSec);
	itemListArray.Insert(itemListArray.Length, 1);
	itemListArray[(itemListArray.Length - 1)] = _limitShopItemInfo;
	return;
}

function LVDataRecord makeRecord(LimitShopItemInfo _limitShopItemInfo)
{
	local LVDataRecord Record;
	local string fullNameString, toolTipParam;
	local ItemInfo Info;
	local bool bConditionLevel, bConditionAmount;
	local UserInfo PlayerInfo;
	local int i;
	local Color colorItemName, colorLevel, colorAmount;

	GetPlayerInfo(PlayerInfo);
	bConditionLevel = (_limitShopItemInfo.ConditionLevel <= PlayerInfo.nLevel);
	bConditionAmount = (_limitShopItemInfo.RemainItemAmount > 0);
	Info = GetItemInfoByClassID(_limitShopItemInfo.ItemClassID);
	fullNameString = GetItemNameAll(Info);
	ItemInfoToParam(Info, toolTipParam);
	Record.szReserved = toolTipParam;
	Record.nReserved1 = _limitShopItemInfo.CostItemAmount[0];
	Record.nReserved2 = _limitShopItemInfo.CostItemAmount[1];
	Record.nReserved3 = _limitShopItemInfo.CostItemAmount[2];
	Record.LVDataList.Length = 5;
	Record.LVDataList[3].nReserved1 = _limitShopItemInfo.costItemID[0];
	Record.LVDataList[3].nReserved2 = _limitShopItemInfo.costItemID[1];
	Record.LVDataList[3].nReserved3 = _limitShopItemInfo.costItemID[2];
	Record.LVDataList[0].nReserved1 = _limitShopItemInfo.ItemClassID;
	Record.LVDataList[1].nReserved1 = _limitShopItemInfo.ConditionLevel;
	Record.LVDataList[2].nReserved1 = _limitShopItemInfo.RemainItemAmount;
	Record.LVDataList[2].nReserved2 = _limitShopItemInfo.ReseetType;
	Record.LVDataList[2].nReserved3 = _limitShopItemInfo.SlotNum;
	Record.LVDataList[0].szData = fullNameString;
	Record.LVDataList[0].hasIcon = true;
	Record.LVDataList[0].nTextureWidth = 32;
	Record.LVDataList[0].nTextureHeight = 32;
	Record.LVDataList[0].nTextureU = 32;
	Record.LVDataList[0].nTextureV = 32;
	Record.LVDataList[0].szTexture = Info.IconName;
	Record.LVDataList[0].IconPosX = 10;
	Record.LVDataList[0].FirstLineOffsetX = 6;
	Record.LVDataList[0].iconBackTexName = "l2ui_ct1.ItemWindow_DF_SlotBox_Default";
	Record.LVDataList[0].backTexOffsetXFromIconPosX = -2;
	Record.LVDataList[0].backTexOffsetYFromIconPosY = -1;
	Record.LVDataList[0].backTexWidth = 36;
	Record.LVDataList[0].backTexHeight = 36;
	Record.LVDataList[0].backTexUL = 36;
	Record.LVDataList[0].backTexVL = 36;
	Record.LVDataList[0].iconPanelName = Info.IconPanel;
	Record.LVDataList[0].panelOffsetXFromIconPosX = 0;
	Record.LVDataList[0].panelOffsetYFromIconPosY = 0;
	Record.LVDataList[0].panelWidth = 32;
	Record.LVDataList[0].panelHeight = 32;
	Record.LVDataList[0].panelUL = 32;
	Record.LVDataList[0].panelVL = 32;
	if((Info.Enchanted > 0))
	{
		Record.LVDataList[0].arrTexture.Length = 3;
		lvTextureAddItemEnchantedTexture(Info.Enchanted, Record.LVDataList[0].arrTexture[0], Record.LVDataList[0].arrTexture[1], Record.LVDataList[0].arrTexture[2], 9, 11);
	}
	i = 0;
	while((i < _limitShopItemInfo.COSTITEMNUM))
	{
		if((_limitShopItemInfo.CostItemSaleRate[i] > 0.0000000))
		{
			lvTextureAdd(Record.LVDataList[0].arrTexture[(Record.LVDataList[0].arrTexture.Length - 1)], "L2UI_CT1.ShopWnd.ShopDailyLcoinWnd_SaleIcon_02", 0, -1, 39, 39);
		}
		i++;
	}
	if((_limitShopItemInfo.EventType != 0))
	{
		Record.LVDataList[0].arrTexture.Insert(Record.LVDataList[0].arrTexture.Length, 1);
		if((_limitShopItemInfo.EventType == 1))
		{
			lvTextureAdd(Record.LVDataList[0].arrTexture[(Record.LVDataList[0].arrTexture.Length - 1)], "L2UI_CT1.ShopWnd.ShopDailyLcoinWnd_EventIcon_02", 0, -1, 39, 39);
			i = 0;
			while((i < _limitShopItemInfo.COSTITEMNUM))
			{
				if((_limitShopItemInfo.CostItemSaleRate[i] > 0.0000000))
				{
					lvTextureAdd(Record.LVDataList[0].arrTexture[(Record.LVDataList[0].arrTexture.Length - 1)], "L2UI_CT1.ShopWnd.ShopDailyLcoinWnd_EventSaleIcon_02", 0, -1, 39, 39);
				}
				i++;
			}
		}
	}
	Record.LVDataList[1].textAlignment = TA_Center;
	if((_limitShopItemInfo.ConditionLevel <= 1))
	{
		Record.LVDataList[1].szData = "-";
	}
	else
	{
		Record.LVDataList[1].szData = (string(_limitShopItemInfo.ConditionLevel) @ GetSystemString(859));
	}
	if((_limitShopItemInfo.ReseetType == 0))
	{
		Record.LVDataList[2].arrTexture.Length = 1;
		lvTextureAdd(Record.LVDataList[2].arrTexture[0], "L2UI_CT1.ShopDailyWnd.ShopDailyWnd_Icon_Infinity", 38, 4, 16, 16);
	}
	else
	{
		Record.LVDataList[2].textAlignment = TA_Center;
		Record.LVDataList[2].szData = ((string(_limitShopItemInfo.RemainItemAmount) $ "/") $ string(_limitShopItemInfo.MaxItemAmount));
	}
	Record.LVDataList[3].textAlignment = TA_Center;
	if((_limitShopItemInfo.EventRemainSec == 0))
	{
		Record.LVDataList[3].szData = GetSystemString(3979);
	}
	else
	{
		Record.LVDataList[3].szData = util.getTimeStringBySec3(_limitShopItemInfo.EventRemainSec);
	}
	Record.LVDataList[0].bUseTextColor = true;
	Record.LVDataList[1].bUseTextColor = true;
	Record.LVDataList[2].bUseTextColor = true;
	Record.LVDataList[3].bUseTextColor = true;
	if((GetCountCanBuyBuStruct(_limitShopItemInfo.ConditionLevel, _limitShopItemInfo.COSTITEMNUM, _limitShopItemInfo.costItemID, _limitShopItemInfo.CostItemAmount, _limitShopItemInfo.RemainItemAmount) > 0))
	{
		colorItemName.R = 225;
		colorItemName.G = 225;
		colorItemName.B = 225;
		colorItemName.A = 255;
	}
	else
	{
		Record.LVDataList[0].foreTextureName = "L2UI_CT1.ItemWindow.ItemWindow_IconDisable";
		colorItemName.R = 182;
		colorItemName.G = 182;
		colorItemName.B = 182;
		colorItemName.A = 255;
	}
	if(bConditionLevel)
	{
		colorLevel.R = 187;
		colorLevel.G = 170;
		colorLevel.B = 136;
		colorLevel.A = 255;
	}
	else
	{
		colorLevel.R = 182;
		colorLevel.G = 182;
		colorLevel.B = 182;
		colorLevel.A = 255;
	}
	if(bConditionAmount)
	{
		colorAmount.R = 255;
		colorAmount.G = 255;
		colorAmount.B = 255;
		colorAmount.A = 255;
	}
	else
	{
		colorAmount.R = 255;
		colorAmount.G = 204;
		colorAmount.B = 0;
		colorAmount.A = 255;
	}
	Record.LVDataList[0].TextColor = colorItemName;
	Record.LVDataList[1].TextColor = colorLevel;
	Record.LVDataList[2].TextColor = colorAmount;
	Record.LVDataList[3].TextColor = colorItemName;
	return Record;
}

function ItemListInfoEnd()
{
	local int i, N;

	i = 1;
	while((i < 6))
	{
		getListCtrlByCategory(i).DeleteAllItem();
		i++;
	}
	i = 0;
	while((i < itemListArray.Length))
	{
		if(ListOption_CheckBox.IsChecked())
		{
			if((GetCountCanBuyBuStruct(itemListArray[i].ConditionLevel, itemListArray[i].COSTITEMNUM, itemListArray[i].costItemID, itemListArray[i].CostItemAmount, itemListArray[i].RemainItemAmount) > 0))
			{
				getListCtrlByCategory(getListCtrlIndexSellCategory(itemListArray[i].SellCategory)).InsertRecord(makeRecord(itemListArray[i]));
			}
			i++;
			continue;
		}
		getListCtrlByCategory(getListCtrlIndexSellCategory(itemListArray[i].SellCategory)).InsertRecord(makeRecord(itemListArray[i]));
		i++;
	}
	i = 1;
	while((i < 6))
	{
		N = FindItemIndex(i, selectedCategoryInfoArray[i].SlotNum);
		if((N > 0))
		{
			getListCtrlByCategory(i).SetSelectedIndex(N, true);
			i++;
			continue;
		}
		if((getListCtrlByCategory(i).GetRecordCount() > 0))
		{
			getListCtrlByCategory(i).SetSelectedIndex(0, true);
		}
		i++;
	}
	showCategoryList(currentShopCategory);
	ShowWindowWithFocus(m_Windowname);
	OnClickListCtrlRecord("List_ListCtrl");
	return;
}

function SetControlerBtns()
{
	local int Count, canBuyCount;
	local LVDataRecord Record;
	local ItemInfo Info;

	Record = GetSelectedRecord();
	canBuyCount = GetCountCanBuy(Record);
	Count = int(ItemCount_EditBox.GetString());
	if((canBuyCount > 0))
	{
		if((canBuyCount == 1))
		{
			MultiSell_Input_Button.DisableWindow();
			ItemCount_EditBox.DisableWindow();
		}
		else
		{
			MultiSell_Input_Button.EnableWindow();
			ItemCount_EditBox.EnableWindow();
		}
		if((canBuyCount == Count))
		{
			MultiSell_Up_Button.DisableWindow();
		}
		else
		{
			MultiSell_Up_Button.EnableWindow();
		}
		if((Count <= 1))
		{
			Reset_Btn.DisableWindow();
			MultiSell_Down_Button.DisableWindow();
		}
		else
		{
			Reset_Btn.EnableWindow();
			MultiSell_Down_Button.EnableWindow();
		}
		Info = GetItemInfoByRecord(Record);
		if((IsStackableItem(Info.ConsumeType) == false))
		{
			MultiSell_Up_Button.DisableWindow();
			Reset_Btn.DisableWindow();
			MultiSell_Down_Button.DisableWindow();
			ItemCount_EditBox.DisableWindow();
			MultiSell_Input_Button.DisableWindow();
		}
		if((Count > 0))
		{
			Buy_Btn.EnableWindow();
		}
		else
		{
			Buy_Btn.DisableWindow();
		}
	}
	else
	{
		MultiSell_Up_Button.DisableWindow();
		MultiSell_Down_Button.DisableWindow();
		MultiSell_Input_Button.DisableWindow();
		ItemCount_EditBox.DisableWindow();
		Reset_Btn.DisableWindow();
		Buy_Btn.DisableWindow();
	}
	SetBuyButtonTooltio();
	return;
}

function SetItemCountEditBox(int Num)
{
	local LVDataRecord Record, nullRecord;
	local int N;

	Record = GetSelectedRecord();
	if((Record == nullRecord))
	{
		Num = 0;
	}
	else if((Num < 1))
	{
		Num = 0;
	}
	Num = Min(GetCountCanBuy(Record), Num);
	if((Num != int(ItemCount_EditBox.GetString())))
	{
		ItemCount_EditBox.SetString(string(Num));
	}
	N = FindItemIndexArray(GetSlotNumByRecord(Record));
	SetBuyCostText(itemListArray[N], Num);
	SetControlerBtns();
	return;
}

function SetBuyCostText(LimitShopItemInfo arr, int Count)
{
	local int i;
	local ItemInfo ItemInfo;
	local INT64 haveItem;
	local string itemstring;

	if((Count == 0))
	{
		Count = 1;
	}
	i = 0;
	while((i < 3))
	{
		GetItemWindowHandle((((m_Windowname $ ".ItemInfo_Wnd.CostItem0") $ string((i + 1))) $ "_ItemWindow")).Clear();
		ItemInfo = GetItemInfoByClassID(arr.costItemID[i]);
		if((arr.costItemID[i] == -100))
		{
			haveItem = INT64(PcCafePoint);
			ItemInfo.Name = GetSystemString(1277);
			ItemInfo.IconName = GetPcCafeItemIconPackageName();
			ItemInfo.Enchanted = 0;
			ItemInfo.ItemType = -1;
			ItemInfo.Id.ClassID = 0;
			if((haveItem >= (arr.CostItemAmount[i] * INT64(Count))))
			{
				GetTextBoxHandle((((m_Windowname $ ".ItemInfo_Wnd.CostItem0") $ string((i + 1))) $ "MyNumTitle_TextBox")).SetTextColor(util.BLUE01);
			}
			else
			{
				GetTextBoxHandle((((m_Windowname $ ".ItemInfo_Wnd.CostItem0") $ string((i + 1))) $ "MyNumTitle_TextBox")).SetTextColor(util.DRed);
			}
			if((arr.CostItemSaleRate[i] != 0.0000000))
			{
				itemstring = ((("(" $ util.cutFloat(arr.CostItemSaleRate[i])) $ GetSystemString(3994)) $ ")");
				GetTextBoxHandle((((m_Windowname $ ".ItemInfo_Wnd.CostItem0") $ string((i + 1))) $ "Sale_TextBox")).SetText(itemstring);
				GetTextureHandle((((m_Windowname $ ".ItemInfo_Wnd.CostItem0") $ string((i + 1))) $ "_Sale")).ShowWindow();
				GetTextureHandle((((m_Windowname $ ".ItemInfo_Wnd.CostItem0") $ string((i + 1))) $ "_Sale")).SetTooltipCustomType(MakeTooltipSimpleText(((GetSystemString(3995) $ " : ") $ MakeCostString(string(arr.CostItemAmount[i])))));
			}
			else
			{
				GetTextBoxHandle((((m_Windowname $ ".ItemInfo_Wnd.CostItem0") $ string((i + 1))) $ "Sale_TextBox")).SetText("");
				GetTextureHandle((((m_Windowname $ ".ItemInfo_Wnd.CostItem0") $ string((i + 1))) $ "_Sale")).HideWindow();
			}
			GetTextBoxHandle((((m_Windowname $ ".ItemInfo_Wnd.CostItem0") $ string((i + 1))) $ "Title_TextBox")).SetText(ItemInfo.Name);
			GetTextBoxHandle((((m_Windowname $ ".ItemInfo_Wnd.CostItem0") $ string((i + 1))) $ "NumTitle_TextBox")).SetText(("x" @ MakeCostString(string((arr.CostItemSaleAmount[i] * INT64(Count))))));
			GetItemWindowHandle((((m_Windowname $ ".ItemInfo_Wnd.CostItem0") $ string((i + 1))) $ "_ItemWindow")).AddItem(ItemInfo);
			GetTextureHandle((((m_Windowname $ ".ItemInfo_Wnd.CostItem0") $ string((i + 1))) $ "SlotBg_Texture")).ShowWindow();
			GetTextBoxHandle((((m_Windowname $ ".ItemInfo_Wnd.CostItem0") $ string((i + 1))) $ "MyNumTitle_TextBox")).SetText((("(" $ MakeCostString(string(haveItem))) $ ")"));
			i++;
			continue;
		}
		if((arr.costItemID[i] != 0))
		{
			haveItem = GetInventoryItemCount(GetItemID(arr.costItemID[i]));
			if((haveItem >= (arr.CostItemAmount[i] * INT64(Count))))
			{
				GetTextBoxHandle((((m_Windowname $ ".ItemInfo_Wnd.CostItem0") $ string((i + 1))) $ "MyNumTitle_TextBox")).SetTextColor(util.BLUE01);
			}
			else
			{
				GetTextBoxHandle((((m_Windowname $ ".ItemInfo_Wnd.CostItem0") $ string((i + 1))) $ "MyNumTitle_TextBox")).SetTextColor(util.DRed);
			}
			if((arr.CostItemSaleRate[i] != 0.0000000))
			{
				itemstring = ((("(" $ util.cutFloat(arr.CostItemSaleRate[i])) $ GetSystemString(3994)) $ ")");
				GetTextBoxHandle((((m_Windowname $ ".ItemInfo_Wnd.CostItem0") $ string((i + 1))) $ "Sale_TextBox")).SetText(itemstring);
				GetTextureHandle((((m_Windowname $ ".ItemInfo_Wnd.CostItem0") $ string((i + 1))) $ "_Sale")).ShowWindow();
				GetTextureHandle((((m_Windowname $ ".ItemInfo_Wnd.CostItem0") $ string((i + 1))) $ "_Sale")).SetTooltipCustomType(MakeTooltipSimpleText(((GetSystemString(3995) $ " : ") $ MakeCostString(string(arr.CostItemAmount[i])))));
			}
			else
			{
				GetTextBoxHandle((((m_Windowname $ ".ItemInfo_Wnd.CostItem0") $ string((i + 1))) $ "Sale_TextBox")).SetText("");
				GetTextureHandle((((m_Windowname $ ".ItemInfo_Wnd.CostItem0") $ string((i + 1))) $ "_Sale")).HideWindow();
			}
			GetTextBoxHandle((((m_Windowname $ ".ItemInfo_Wnd.CostItem0") $ string((i + 1))) $ "Title_TextBox")).SetText(ItemInfo.Name);
			GetTextBoxHandle((((m_Windowname $ ".ItemInfo_Wnd.CostItem0") $ string((i + 1))) $ "NumTitle_TextBox")).SetText(("x" @ MakeCostString(string((arr.CostItemSaleAmount[i] * INT64(Count))))));
			GetItemWindowHandle((((m_Windowname $ ".ItemInfo_Wnd.CostItem0") $ string((i + 1))) $ "_ItemWindow")).AddItem(ItemInfo);
			GetTextureHandle((((m_Windowname $ ".ItemInfo_Wnd.CostItem0") $ string((i + 1))) $ "SlotBg_Texture")).ShowWindow();
			GetTextBoxHandle((((m_Windowname $ ".ItemInfo_Wnd.CostItem0") $ string((i + 1))) $ "MyNumTitle_TextBox")).SetText((("(" $ MakeCostString(string(haveItem))) $ ")"));
			i++;
			continue;
		}
		GetTextBoxHandle((((m_Windowname $ ".ItemInfo_Wnd.CostItem0") $ string((i + 1))) $ "Sale_TextBox")).SetText("");
		GetTextBoxHandle((((m_Windowname $ ".ItemInfo_Wnd.CostItem0") $ string((i + 1))) $ "Title_TextBox")).SetText("");
		GetTextBoxHandle((((m_Windowname $ ".ItemInfo_Wnd.CostItem0") $ string((i + 1))) $ "NumTitle_TextBox")).SetText("");
		GetTextureHandle((((m_Windowname $ ".ItemInfo_Wnd.CostItem0") $ string((i + 1))) $ "SlotBg_Texture")).HideWindow();
		GetTextBoxHandle((((m_Windowname $ ".ItemInfo_Wnd.CostItem0") $ string((i + 1))) $ "MyNumTitle_TextBox"));
		GetTextBoxHandle((((m_Windowname $ ".ItemInfo_Wnd.CostItem0") $ string((i + 1))) $ "MyNumTitle_TextBox")).SetText("");
		GetTextureHandle((((m_Windowname $ ".ItemInfo_Wnd.CostItem0") $ string((i + 1))) $ "_Sale")).HideWindow();
		i++;
	}
	return;
}

function SetBuyButtonTooltio()
{
	local LVDataRecord Record, nummRecord;
	local UserInfo Info;
	local int i, N;
	local ItemInfo ItemInfo;
	local LimitShopItemInfo arr;
	local CustomTooltip t;
	local INT64 haveItem;

	util.setCustomTooltip(t);
	util.ToopTipMinWidth(10);
	if(!GetPlayerInfo(Info))
	{
		return;
	}
	Record = GetSelectedRecord();
	if((Record == nummRecord))
	{
		Buy_Btn.SetTooltipCustomType(util.getCustomToolTip());
		return;
	}
	N = FindItemIndexArray(GetSlotNumByRecord(Record));
	arr = itemListArray[N];
	if(((GetNeedLevel(Record) > Info.nLevel) && (GetNeedLevel(Record) > 0)))
	{
		util.ToopTipInsertText(GetSystemString(1030), true, true, COLOR_RED);
	}
	if((GetCurrentAmount(Record) == 0))
	{
		util.ToopTipInsertText((GetSystemString(3725) $ " "), true, true, COLOR_GRAY);
		util.ToopTipInsertText("0", true, false, COLOR_RED);
	}
	i = 0;
	while((i < 3))
	{
		if((arr.costItemID[i] == -100))
		{
			ItemInfo.Name = GetSystemString(1277);
			ItemInfo.IconName = GetPcCafeItemIconPackageName();
			haveItem = INT64(PcCafePoint);
		}
		else
		{
			ItemInfo = GetItemInfoByClassID(arr.costItemID[i]);
			haveItem = GetInventoryItemCount(GetItemID(arr.costItemID[i]));
		}
		if((haveItem < arr.CostItemAmount[i]))
		{
			util.ToopTipInsertText((ItemInfo.Name $ " "), true, true, COLOR_GRAY);
			util.ToopTipInsertText((MakeCostString(string((arr.CostItemAmount[i] - haveItem))) @ GetSystemString(3752)), true, false, COLOR_RED);
		}
		i++;
	}
	Buy_Btn.SetTooltipCustomType(util.getCustomToolTip());
	return;
}

function HandleEditBox()
{
	local string EditBoxString;

	EditBoxString = ItemCount_EditBox.GetString();
	if(((Left(EditBoxString, 1) == "0") && (Len(EditBoxString) > 1)))
	{
		ItemCount_EditBox.SetString(Right(EditBoxString, (Len(EditBoxString) - 1)));
	}
	return;
}

function HandleDialogOK(bool bOK)
{
	if(!DialogIsMine())
	{
		return;
	}
	switch(DialogGetID())
	{
		case 10111:
			disableWnd.HideWindow();
			SetItemCountEditBox(int(DialogGetString()));
			break;
		default:
			break;
	}
	return;
}

function SetBuyConfirmWnd()
{
	local ItemInfo Info;
	local ItemWindowHandle Result_ItemWnd;
	local TextBoxHandle ItemName_TextBox, BCNum_TextBox, AdenaNum_TextBox, CostNum_TextBox, ItemName_TextBox1, ItemName_TextBox2, ItemName_TextBox3;
	local LVDataRecord Record;

	Record = GetSelectedRecord();
	Info = GetItemInfoByRecord(Record);
	Result_ItemWnd = GetItemWindowHandle((m_Windowname $ ".ShopDailyConfirm_ResultWnd.Result_ItemWnd"));
	ItemName_TextBox = GetTextBoxHandle((m_Windowname $ ".ShopDailyConfirm_ResultWnd.ItemName_TextBox"));
	if(getInstanceUIData().GetIsClassicServer())
	{
		GetTextBoxHandle((m_Windowname $ ".ShopDailyConfirm_ResultWnd.BCTitle_TextBox")).SetText(GetSystemString(3931));
	}
	else
	{
		GetTextBoxHandle((m_Windowname $ ".ShopDailyConfirm_ResultWnd.BCTitle_TextBox")).SetText(GetSystemString(3915));
	}
	Result_ItemWnd.Clear();
	Result_ItemWnd.AddItem(Info);
	ItemName_TextBox.SetText(Record.LVDataList[0].szData);
	textBoxShortStringWithTooltip(ItemName_TextBox, true);
	ItemName_TextBox1 = GetTextBoxHandle((m_Windowname $ ".ShopDailyConfirm_ResultWnd.BCTitle_TextBox"));
	ItemName_TextBox1.SetText(NeededItem_Item1_Title.GetText());
	BCNum_TextBox = GetTextBoxHandle((m_Windowname $ ".ShopDailyConfirm_ResultWnd.BCNum_TextBox"));
	BCNum_TextBox.SetText(NeededItem_Item1Num_text.GetText());
	ItemName_TextBox2 = GetTextBoxHandle((m_Windowname $ ".ShopDailyConfirm_ResultWnd.AdenaTitle_TextBox"));
	ItemName_TextBox2.SetText(NeededItem_Item2_Title.GetText());
	AdenaNum_TextBox = GetTextBoxHandle((m_Windowname $ ".ShopDailyConfirm_ResultWnd.AdenaNum_TextBox"));
	AdenaNum_TextBox.SetText(NeededItem_Item2Num_text.GetText());
	ItemName_TextBox3 = GetTextBoxHandle((m_Windowname $ ".ShopDailyConfirm_ResultWnd.CostTitle_TextBox"));
	ItemName_TextBox3.SetText(NeededItem_Item3_Title.GetText());
	CostNum_TextBox = GetTextBoxHandle((m_Windowname $ ".ShopDailyConfirm_ResultWnd.CostNum_TextBox"));
	CostNum_TextBox.SetText(NeededItem_Item3Num_text.GetText());
	ItemNum_TextBox.SetText(("x" $ ItemCount_EditBox.GetString()));
	return;
}

function HandleBuyResult(string param)
{
	local int Result;

	ParseInt(param, "Result", Result);
	Debug(("HandleBuyResult: " @ param));
	switch(Result)
	{
		case 0:
			SetSuccessWnd(param);
			break;
		case 10:
			SetFailWnd(13180);
			break;
		case 1:
		case 2:
		case 3:
		case 4:
		case 5:
			SetFailWnd(4334);
			break;
		default:
			break;
	}
	return;
}

function SetSuccessWnd(string param)
{
	local ItemWindowHandle Result_ItemWnd;
	local TextBoxHandle ItemName_TextBox, Discription_TextBox;
	local int ItemClassID;
	local ItemInfo Info;

	ParseInt(param, "ItemClassId_0", ItemClassID);
	Result_ItemWnd = GetItemWindowHandle((m_Windowname $ ".ShopDailySuccess_ResultWnd.Result_ItemWnd"));
	ItemName_TextBox = GetTextBoxHandle((m_Windowname $ ".ShopDailySuccess_ResultWnd.ItemName_TextBox"));
	Discription_TextBox = GetTextBoxHandle((m_Windowname $ ".ShopDailySuccess_ResultWnd.Discription_TextBox"));
	Result_ItemWnd.Clear();
	Info = GetItemInfoByClassID(selectedCategoryInfoArray[currentShopCategory].ItemClassID);
	Result_ItemWnd.AddItem(Info);
	ItemName_TextBox.SetText(((GetItemNameAll(Info) @ "x") $ ItemCount_EditBox.GetString()));
	Discription_TextBox.SetText(GetSystemMessage(4570));
	ShopDailySuccess_ResultWnd.ShowWindow();
	return;
}

function SetFailWnd(int SystemMsg)
{
	local TextBoxHandle Discription_TextBox;

	Discription_TextBox = GetTextBoxHandle((m_Windowname $ ".ShopDailyFails_ResultWnd.Discription_TextBox"));
	Discription_TextBox.SetText(GetSystemMessage(SystemMsg));
	ShopDailyFails_ResultWnd.ShowWindow();
	return;
}

function bool IsMyShopIndex(string param)
{
	local int ShopIndex;

	ParseInt(param, "ShopIndex", ShopIndex);
	return (shopIndexCurrent == ShopIndex);
}

function int FindItemIndex(int Category, int SlotNum)
{
	local int i;
	local LVDataRecord Record;

	i = 0;
	while((i < getListCtrlByCategory(Category).GetRecordCount()))
	{
		getListCtrlByCategory(Category).GetRec(i, Record);
		if((SlotNum == GetSlotNumByRecord(Record)))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function int FindItemIndexArray(int SlotNum)
{
	local int i;

	i = 0;
	while((i < itemListArray.Length))
	{
		if((SlotNum == itemListArray[i].SlotNum))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function LVDataRecord GetSelectedRecord()
{
	local LVDataRecord Record, nullRecord;

	getListCtrlByCategory(currentShopCategory).GetSelectedRec(Record);
	if((Record == nullRecord))
	{
		if((selectedCategoryInfoArray[currentShopCategory].SlotNum > -1))
		{
			getListCtrlByCategory(currentShopCategory).GetRec(FindItemIndex(currentShopCategory, selectedCategoryInfoArray[currentShopCategory].SlotNum), Record);
		}
	}
	return Record;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="ShopDailyLcoinWnd"
}
