class WorldExchangeRegiWnd extends UICommonAPI
	dependson(UIPacket);

const ADENA_CLASSID = 57;
const INSERT_ONCE_LIST_NUM = 10;
const LOAD_ONCE_LIST_NUM = 100;
const REFRESHLIMIT = 1000;
const REFRESHLIMITMIN = 500;
const LIVE_MIN_TOTAL_PRICE = 10;

enum E_WORLD_EXCHANGE_SORT_TYPE
{
	EWEST_NONE,                     // 0
	EWEST_ITEM_NAME,                // 1
	EWEST_ENCHANT_ASCE,             // 2
	EWEST_ENCHANT_DESC,             // 3
	EWEST_PRICE_ASCE,               // 4
	EWEST_PRICE_DESC,               // 5
	EWEST_AMOUNT_ASCE,              // 6
	EWEST_AMOUNT_DESC,              // 7
	EWEST_PRICE_PER_PIECE_ASCE,     // 8
	EWEST_PRICE_PER_PIECE_DESC      // 9
};

var int mAXRegiItemNum;
var INT64 MAXITEMNUM;
var int LCOIN_CLASSID;
var int refreshMinCount;
var int lastLoadedPage;
var int nMaxPage;
var bool bRQ_C_EX_WORLD_EXCHANGE_ITEM_LIST;
var bool bRQ_C_EX_WORLD_EXCHANGE_AVERAGE_PRICE;
var array<UIPacket._WorldExchangeItemData> _itemDatas;
var WindowHandle FindDisable_Wnd;
var WindowHandle WindowDisable_Wnd;
var L2UITimerObject tObject;
var L2UITimerObject tObjectListAdd;
var RichListCtrlHandle ExchangeFind_RichList;
var ItemInfo sellItemInfo;
var ItemInfo readySellItemInfo;
var int scrollPos;
var int _regieditemNum;
var int sortHeaderIndex;
var float nAveragePrice;
var UIControlNumberInput itemSell_NumberInputScr;
var UIControlNumberInput bundlePrice_NumberInputScr;
var WorldExchangeRegiWndItemHistoryTabWnd historyScr;

static function WorldExchangeRegiWnd Inst()
{
	return WorldExchangeRegiWnd(GetScript("WorldExchangeRegiWnd"));
}

event OnRegisterEvent()
{
	RegisterEvent(40);
	RegisterEvent(EV_PacketID(1020));
	RegisterEvent(EV_PacketID(1021));
	RegisterEvent(EV_PacketID(1058));
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	OnLoadEachServer();
	SetMaxRegiItemDefault();
	ExchangeFind_RichList = GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ExchangeFind_RichList"));
	ExchangeFind_RichList.SetSelectedSelTooltip(false);
	ExchangeFind_RichList.SetAppearTooltipAtMouseX(true);
	ExchangeFind_RichList.SetSortable(false);
	itemSell_NumberInputScr = Class'Interface.UIControlNumberInput'.static.InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.ItemSell_NumberInput")));
	bundlePrice_NumberInputScr = Class'Interface.UIControlNumberInput'.static.InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.BundlePrice_NumberInput")));
	bundlePrice_NumberInputScr._SetMinCountCanBuy(INT64(0));
	itemSell_NumberInputScr.DelegateGetCountCanBuy = DelegateGetCanSellItemNum;
	bundlePrice_NumberInputScr.DelegateGetCountCanBuy = GetCanLcoinPriceItemNum;
	itemSell_NumberInputScr.DelegateOnClickInput = HandleOnItemCountEditBtonClicked;
	bundlePrice_NumberInputScr.DelegateOnClickInput = HandleOnPriceCountEditBtonClicked;
	itemSell_NumberInputScr._SetUseCaculator(true);
	bundlePrice_NumberInputScr._SetUseCaculator(true);
	itemSell_NumberInputScr._SetForceDisable(true);
	bundlePrice_NumberInputScr._SetForceDisable(true);
	itemSell_NumberInputScr.DelegateESCKey = OnReceivedCloseUI;
	bundlePrice_NumberInputScr.DelegateESCKey = OnReceivedCloseUI;
	itemSell_NumberInputScr.delegateOnItemCountEdited = HandleOnitemCountEdited;
	bundlePrice_NumberInputScr.delegateOnItemCountEdited = HandleOnPriceCountEdited;
	bundlePrice_NumberInputScr.DelegateOnOverInput = HandleOnOverInput;
	AddItemListenerSimple(57, 0, 57).DelegateOnUpdateItem = HandleMyItemChanged;
	AddItemListenerSimple(LCOIN_CLASSID, 0, LCOIN_CLASSID).DelegateOnUpdateItem = HandleMyItemChanged;
	tObject = Class'Interface.L2UITimer'.static.Inst()._MakeTimerObject(1000);
	tObject._DelegateOnEnd = SetEnableRefresh;
	SetTimerObject();
	SetScriptHistory();
	FindDisable_Wnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.FindDisable_Wnd"));
	FindDisable_Wnd.ShowWindow();
	WindowDisable_Wnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".WindowDisable_Wnd"));
	Get_MyAdenaCount_Txt().SetText(("0" @ GetSystemString(469)));
	Get_MyLcoinCount_Txt().SetText(("0" @ GetSystemString(3931)));
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.SellTime_txt")).SetText("-");
	SetSortType(EWEST_PRICE_PER_PIECE_ASCE);
	return;
}

function SetTimerObject()
{
	local int Time, Count;

	Count = (100 / 10);
	Time = (1000 / Count);
	tObjectListAdd = Class'Interface.L2UITimer'.static.Inst()._MakeTimerObject(Time, Count);
	tObjectListAdd._DelegateOnStart = TInsertRecord;
	tObjectListAdd._DelegateOnTime = TInsertRecordOnTime;
	tObjectListAdd._DelegateOnEnd = TInserDelayCheck;
	refreshMinCount = (500 / Time);
	return;
}

function SetScriptHistory()
{
	local WindowHandle historyWnd;

	historyWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemHistoryTabWnd"));
	historyWnd.SetScript("WorldExchangeRegiWndItemHistoryTabWnd");
	historyScr = WorldExchangeRegiWndItemHistoryTabWnd(historyWnd.GetScript());
	historyScr.m_hOwnerWnd = historyWnd;
	return;
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case 40:
			SetMaxRegiItemDefault();
			break;
		case EV_PacketID(1020):
			RT_S_EX_WORLD_EXCHANGE_ITEM_LIST();
			break;
		case EV_PacketID(1021):
			RT_S_EX_WORLD_EXCHANGE_REGI_ITEM();
			break;
		case EV_PacketID(1058):
			RT_S_EX_WORLD_EXCHANGE_AVERAGE_PRICE();
			break;
		default:
			break;
	}
	return;
}

event OnScrollMove(string strID, int pos)
{
	switch(strID)
	{
		case "ExchangeFind_RichList":
			HandleScrollMove(pos);
			break;
		default:
			break;
	}
	return;
}

event OnShow()
{
	SetMyInfos();
	historyScr.RQ_C_EX_WORLD_EXCHANGE_SETTLE_LIST();
	CheckWorldExchangeRegiSubWnd();
	Class'Interface.WorldExchangeBuyWnd'.static.Inst()._Hide();
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	DelItemInfo();
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemRegiDialog_Wnd.Dialog_Wnd.TaxRateTitle_txt")).SetText((((GetSystemString(1608) $ ":") @ string(API_GetWorldExchangeData().SellFee)) $ "%"));
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.TaxRateTitle_txt")).SetText((((GetSystemString(1608) $ ":") @ string(API_GetWorldExchangeData().SellFee)) $ "%"));
	if(bRQ_C_EX_WORLD_EXCHANGE_ITEM_LIST)
	{
		tObjectListAdd._Reset();
		tObject._Reset();
	}
	SetHideSellDialogWindow();
	if(getInstanceUIData().GetIsLiveServer())
	{
		SideBar(GetScript("SideBar")).ToggleByWindowName("WorldExchangeBuyWnd", true);
	}
	return;
}

event OnHide()
{
	if((DialogIsMine() && Class'Interface.DialogBox'.static.Inst().m_hOwnerWnd.IsShowWindow()))
	{
		DialogHide();
	}
	if(getInstanceUIData().GetIsLiveServer())
	{
		SideBar(GetScript("SideBar")).ToggleByWindowName("WorldExchangeBuyWnd", false);
	}
	return;
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "GetReward_Btn":
			HandleGetRewardBtn();
			break;
		case "WndClose_BTN":
			_Hide();
			break;
		case "Refresh_btn":
			HandleRefresh();
			break;
		case "MoveWnd_Btn":
			handleSwap();
			break;
		case "Cancel_Btn":
			SetHideSellDialogWindow();
			break;
		case "Ok_Btn":
			HandleClickOK_Btn();
			break;
		case "Cancel_Ok_Btn":
			HandleCancelOK();
			break;
		case "Cancel_Cancel_Btn":
			HandleCancelCancel();
			break;
		case "RegiList_Tab0":
		case "RegiList_Tab1":
			CheckWorldExchangeRegiSubWnd();
			break;
		default:
			break;
	}
	return;
}

event OnDBClickItemWithHandle(ItemWindowHandle a_hItemWindow, int a_Index)
{
	local ItemInfo iInfo;

	if((a_hItemWindow.GetParentWindowName() == "Dialog_Wnd"))
	{
		return;
	}
	a_hItemWindow.GetItem(a_Index, iInfo);
	ItemDrop(iInfo);
	return;
}

event OnRClickItemWithHandle(ItemWindowHandle a_hItemWindow, int a_Index)
{
	local ItemInfo iInfo;

	if((a_hItemWindow.GetParentWindowName() == "Dialog_Wnd"))
	{
		return;
	}
	a_hItemWindow.GetItem(a_Index, iInfo);
	ItemDrop(iInfo);
	return;
}

event OnDropItemSource(string strTarget, ItemInfo Info)
{
	if(bRQ_C_EX_WORLD_EXCHANGE_ITEM_LIST)
	{
		return;
	}
	if((strTarget == "Item_ItemWnd"))
	{
		return;
	}
	if((Info.DragSrcName != "Item_ItemWnd"))
	{
		return;
	}
	ItemDrop(Info);
	return;
}

function ItemDrop(ItemInfo Info)
{
	if(((Class'NWindow.InputAPI'.static.IsAltPressed() || !IsStackableItem(Info.ConsumeType)) || (Info.ItemNum == INT64(1))))
	{
		DelItemInfo();
	}
	else if(IsAdena(Info.Id))
	{
		Class'Interface.DialogBox'.static.Inst().SetDefaultAction(EDefaultOK);
		DialogShow(DialogModalType_Modalless, DialogType_NumberPadAdena, MakeFullSystemMsg(GetSystemMessage(1833), sellItemInfo.Name, ""));
		Class'Interface.DialogBox'.static.Inst().AnchorToOwner();
		Class'Interface.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOKSource;
		DialogSetInputlimit(Min64(sellItemInfo.ItemNum, Class'Interface.WorldExchangeBuyWnd'.static.Inst().ADENA_MAX));
		DialogSetParamInt64(Min64(sellItemInfo.ItemNum, Class'Interface.WorldExchangeBuyWnd'.static.Inst().ADENA_MAX));
	}
	else
	{
		Class'Interface.DialogBox'.static.Inst().SetDefaultAction(EDefaultOK);
		DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(1833), sellItemInfo.Name, ""));
		Class'Interface.DialogBox'.static.Inst().AnchorToOwner();
		Class'Interface.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOKSource;
		DialogSetInputlimit(sellItemInfo.ItemNum);
		DialogSetParamInt64(sellItemInfo.ItemNum);
	}
	return;
}

event OnDropItem(string strTarget, ItemInfo iInfo, int X, int Y)
{
	if(bRQ_C_EX_WORLD_EXCHANGE_ITEM_LIST)
	{
		return;
	}
	if((_regieditemNum == mAXRegiItemNum))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13688));
		return;
	}
	if((iInfo.DragSrcName != "itemEnchantSubWndItemWnd"))
	{
		return;
	}
	if(((Class'NWindow.InputAPI'.static.IsAltPressed() || !IsStackableItem(iInfo.ConsumeType)) || (iInfo.ItemNum == INT64(1))))
	{
		SetSortType(EWEST_PRICE_PER_PIECE_ASCE);
		sellItemInfo = iInfo;
		sellItemInfo.ItemNum = GetSellItemInfoNum(iInfo.Id.ServerID);
		SetItemInfo();
		RQ_C_EX_WORLD_EXCHANGE_AVERAGE_PRICE();
	}
	else
	{
		readySellItemInfo = iInfo;
		Class'Interface.DialogBox'.static.Inst().SetDefaultAction(EDefaultOK);
		if(IsAdena(iInfo.Id))
		{
			if((iInfo.ItemNum < Class'Interface.WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT))
			{
				getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13750));
				return;
			}
			DialogShow(DialogModalType_Modalless, DialogType_NumberPadAdena, GetSystemString(14193));
			DialogSetInputlimit(Min64(iInfo.ItemNum, Class'Interface.WorldExchangeBuyWnd'.static.Inst().ADENA_MAX));
			DialogSetParamInt64(Min64(iInfo.ItemNum, Class'Interface.WorldExchangeBuyWnd'.static.Inst().ADENA_MAX));
		}
		else
		{
			DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), iInfo.Name, ""));
			DialogSetInputlimit(Min64(MAXITEMNUM, iInfo.ItemNum));
			DialogSetParamInt64(Min64(MAXITEMNUM, iInfo.ItemNum));
		}
		Class'Interface.DialogBox'.static.Inst().AnchorToOwner();
		Class'Interface.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOKDrop;
	}
	return;
}

event OnClickHeaderCtrl(string strID, int Index)
{
	if(bRQ_C_EX_WORLD_EXCHANGE_ITEM_LIST)
	{
		return;
	}
	SetSortByHeaderIndex(Index);
	RQ_C_EX_WORLD_EXCHANGE_ITEM_LIST();
	return;
}

function WorldExchangeUIData API_GetWorldExchangeData()
{
	return GetWorldExchangeData();
}

function int API_GetServerPrivateStoreSearchItemSubType(int a_ClassID)
{
	return GetServerPrivateStoreSearchItemSubType(a_ClassID);
}

function RQ_C_EX_WORLD_EXCHANGE_ITEM_LIST(optional int Page)
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLD_EXCHANGE_ITEM_LIST packet;

	if(bRQ_C_EX_WORLD_EXCHANGE_ITEM_LIST)
	{
		return;
	}
	if((_itemDatas.Length > 0))
	{
		return;
	}
	if((Page > 0))
	{
		if((nMaxPage < Page))
		{
			return;
		}
	}
	if(IsAdena(sellItemInfo.Id))
	{
		ExchangeFind_RichList.SetColumnString(2, 14192);
		bundlePrice_NumberInputScr.SetCount(bundlePrice_NumberInputScr.GetCount());
	}
	else
	{
		ExchangeFind_RichList.SetColumnString(2, 2511);
	}
	SetDisablbRefresh();
	lastLoadedPage = Page;
	packet.nCategory = API_GetServerPrivateStoreSearchItemSubType(sellItemInfo.Id.ClassID);
	packet.cSortType = GetSortType();
	packet.nPage = Page;
	packet.vItemIDList[0] = sellItemInfo.Id.ClassID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_WORLD_EXCHANGE_ITEM_LIST(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(784, stream);
	return;
}

function RT_S_EX_WORLD_EXCHANGE_ITEM_LIST()
{
	local UIPacket._S_EX_WORLD_EXCHANGE_ITEM_LIST packet;

	if(!m_hOwnerWnd.IsShowWindow())
	{
		return;
	}
	if(!Class'Interface.UIPacket'.static.Decode_S_EX_WORLD_EXCHANGE_ITEM_LIST(packet))
	{
		return;
	}
	Debug(("Handle_S_EX_WORLD_EXCHANGE_ITEM_LIST" @ string(_itemDatas.Length)));
	if((lastLoadedPage == 0))
	{
		_itemDatas.Length = 0;
		ExchangeFind_RichList.DeleteAllItem();
		FindDisable_Wnd.ShowWindow();
		nMaxPage = 0;
	}
	if((packet.vItemDataList.Length == 100))
	{
		nMaxPage++;
	}
	else
	{
		nMaxPage = lastLoadedPage;
	}
	Handle_S_EX_WORLD_EXCHANGE_ITEM_LIST(packet);
	return;
}

function Handle_S_EX_WORLD_EXCHANGE_ITEM_LIST(UIPacket._S_EX_WORLD_EXCHANGE_ITEM_LIST packet)
{
	local int i;

	tObjectListAdd._Reset();
	if((packet.vItemDataList.Length == 0))
	{
		SetEnableRefresh();
		return;
	}
	FindDisable_Wnd.HideWindow();
	i = 0;
	while((i < packet.vItemDataList.Length))
	{
		_itemDatas[_itemDatas.Length] = packet.vItemDataList[i];
		i++;
	}
	return;
}

function RQ_C_EX_WORLD_EXCHANGE_REGI_ITEM()
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLD_EXCHANGE_REGI_ITEM packet;

	packet.nItemSid = sellItemInfo.Id.ServerID;
	packet.nAmount = itemSell_NumberInputScr.GetCount();
	packet.nPrice = bundlePrice_NumberInputScr.GetCount();
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_WORLD_EXCHANGE_REGI_ITEM(stream, packet))
	{
		return;
	}
	Debug(((("RQ_C_EX_WORLD_EXCHANGE_REGI_ITEM" @ string(packet.nItemSid)) @ string(packet.nAmount)) @ string(packet.nPrice)));
	Class'Interface.UIPacket'.static.RequestUIPacket(785, stream);
	return;
}

function RT_S_EX_WORLD_EXCHANGE_REGI_ITEM()
{
	local UIPacket._S_EX_WORLD_EXCHANGE_REGI_ITEM packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_WORLD_EXCHANGE_REGI_ITEM(packet))
	{
		return;
	}
	if((packet.cSuccess == 1))
	{
		DelItemInfo();
		historyScr.RQ_C_EX_WORLD_EXCHANGE_SETTLE_LIST();
	}
	else
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4334));
	}
	return;
}

function RQ_C_EX_WORLD_EXCHANGE_AVERAGE_PRICE()
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLD_EXCHANGE_AVERAGE_PRICE packet;

	if(getInstanceUIData().GetIsClassicServer())
	{
		nAveragePrice = 0.0000000;
		packet.nItemID = sellItemInfo.Id.ClassID;
		if(!Class'Interface.UIPacket'.static.Encode_C_EX_WORLD_EXCHANGE_AVERAGE_PRICE(stream, packet))
		{
			return;
		}
		Debug(("RQ_C_EX_WORLD_EXCHANGE_AVERAGE_PRICE" @ string(packet.nItemID)));
		Class'Interface.UIPacket'.static.RequestUIPacket(812, stream);
		bRQ_C_EX_WORLD_EXCHANGE_AVERAGE_PRICE = true;
	}
	return;
}

function RT_S_EX_WORLD_EXCHANGE_AVERAGE_PRICE()
{
	local UIPacket._S_EX_WORLD_EXCHANGE_AVERAGE_PRICE packet;

	bRQ_C_EX_WORLD_EXCHANGE_AVERAGE_PRICE = false;
	if(!Class'Interface.UIPacket'.static.Decode_S_EX_WORLD_EXCHANGE_AVERAGE_PRICE(packet))
	{
		return;
	}
	Debug(((("RT_S_EX_WORLD_EXCHANGE_AVERAGE_PRICE" @ string(packet.nItemID)) @ string(sellItemInfo.Id.ClassID)) @ string(packet.nAveragePrice)));
	if((packet.nItemID == sellItemInfo.Id.ClassID))
	{
		nAveragePrice = (float(packet.nAveragePrice) / 100.0000000);
	}
	return;
}

function _ShowDisableWIndow()
{
	WindowDisable_Wnd.ShowWindow();
	WindowDisable_Wnd.SetFocus();
	return;
}

function _HideDisableWindow()
{
	WindowDisable_Wnd.HideWindow();
	return;
}

function SetDisablbRefresh()
{
	bRQ_C_EX_WORLD_EXCHANGE_ITEM_LIST = true;
	_ShowDisableWIndow();
	tObject._Reset();
	return;
}

function SetEnableRefresh()
{
	bRQ_C_EX_WORLD_EXCHANGE_ITEM_LIST = false;
	WindowDisable_Wnd.HideWindow();
	return;
}

function SetItemInfo()
{
	local ItemWindowHandle Item_ItemWnd;

	Item_ItemWnd = GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.Item_ItemWnd"));
	Item_ItemWnd.Clear();
	sellItemInfo.bShowCount = IsStackableItem(sellItemInfo.ConsumeType);
	Item_ItemWnd.AddItem(sellItemInfo);
	if(IsAdena(sellItemInfo.Id))
	{
		itemSell_NumberInputScr._SetMinCountCanBuy(Class'Interface.WorldExchangeBuyWnd'.static.Inst().ADENA_MIN);
		itemSell_NumberInputScr._SetPlusBasicUnit(Class'Interface.WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT);
	}
	else
	{
		itemSell_NumberInputScr._SetMinCountCanBuy(INT64(1));
		itemSell_NumberInputScr._SetPlusBasicUnit(INT64(1));
	}
	Debug(("sellItemInfo.itemNum" @ string(sellItemInfo.ItemNum)));
	itemSell_NumberInputScr.SetCount(sellItemInfo.ItemNum);
	itemSell_NumberInputScr._SetForceDisable(false);
	bundlePrice_NumberInputScr._SetForceDisable(false);
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Refresh_btn")).EnableWindow();
	RQ_C_EX_WORLD_EXCHANGE_ITEM_LIST(0);
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.SellTime_txt")).SetText(GetSystemString(14084));
	return;
}

function DelItemInfo()
{
	local ItemInfo emptyInfo;

	GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.Item_ItemWnd")).Clear();
	itemSell_NumberInputScr._SetForceDisable(true);
	bundlePrice_NumberInputScr._SetForceDisable(true);
	if((itemSell_NumberInputScr.GetCount() != INT64(0)))
	{
		itemSell_NumberInputScr.SetCount(INT64(0));
	}
	if((bundlePrice_NumberInputScr.GetCount() != INT64(0)))
	{
		bundlePrice_NumberInputScr.SetCount(INT64(0));
	}
	Get_UnitPriceCount_Txt().SetText("0");
	Get_RegiFeePiceCount_Txt().SetText(("0" @ GetSystemString(469)));
	Get_RegiFeePiceCount_TxtUnit_Txt().SetText("");
	Get_SellFeePiceCount_Txt().SetText(("0" @ GetSystemString(3931)));
	Get_UnitPriceCount_Txt().SetText("0");
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.GetReward_Btn")).DisableWindow();
	sellItemInfo = emptyInfo;
	lastLoadedPage = 0;
	ExchangeFind_RichList.DeleteAllItem();
	FindDisable_Wnd.ShowWindow();
	tObjectListAdd._Stop();
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Refresh_btn")).DisableWindow();
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.SellTime_txt")).SetText("-");
	return;
}

function INT64 DelegateGetCanSellItemNum()
{
	return GetSellItemInfoNum(sellItemInfo.Id.ServerID);
}

function INT64 GetSellItemInfoNum(int sererID)
{
	local ItemInfo iInfo;

	if(Class'NWindow.UIDATA_INVENTORY'.static.FindItem(sellItemInfo.Id.ServerID, iInfo))
	{
		if(IsAdena(iInfo.Id))
		{
			return Min64(iInfo.ItemNum, Class'Interface.WorldExchangeBuyWnd'.static.Inst().ADENA_MAX);
		}
		else
		{
			return Min64(iInfo.ItemNum, MAXITEMNUM);
		}
	}
	return INT64(0);
}

function INT64 GetCanLcoinPriceItemNum()
{
	local INT64 Adena;
	local WorldExchangeUIData tmpWorldExchangeUIData;

	tmpWorldExchangeUIData = API_GetWorldExchangeData();
	Adena = GetAdena();
	if(IsAdena(sellItemInfo.Id))
	{
		Adena = (Adena - itemSell_NumberInputScr.GetCount());
	}
	return (Adena / INT64(tmpWorldExchangeUIData.RegistFee));
}

function INT64 GetCommitionRegist()
{
	local WorldExchangeUIData tmpWorldExchangeUIData;

	tmpWorldExchangeUIData = API_GetWorldExchangeData();
	return (bundlePrice_NumberInputScr.GetCount() * INT64(tmpWorldExchangeUIData.RegistFee));
}

function int GetCommitionSell()
{
	local WorldExchangeUIData tmpWorldExchangeUIData;
	local float SellFee;

	tmpWorldExchangeUIData = API_GetWorldExchangeData();
	SellFee = float(int((float(bundlePrice_NumberInputScr.GetCount()) * (float(tmpWorldExchangeUIData.SellFee) / 100.0000000))));
	Debug(("SellFee->" @ string(int((float(bundlePrice_NumberInputScr.GetCount()) * (float(tmpWorldExchangeUIData.SellFee) / 100.0000000))))));
	Debug(("SellFee" @ string(SellFee)));
	if(getInstanceUIData().GetIsLiveServer())
	{
		if((GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.Item_ItemWnd")).GetItemNum() > 0))
		{
			if((SellFee < 1.0000000))
			{
				SellFee = 1.0000000;
			}
		}
	}
	return Min(tmpWorldExchangeUIData.MaxSellFee, int(SellFee));
}

function _GetSellItemInfo(out ItemInfo ItemInfo)
{
	ItemInfo = sellItemInfo;
	return;
}

function HandleScrollMove(optional int pos)
{
	scrollPos = pos;
	if(bRQ_C_EX_WORLD_EXCHANGE_ITEM_LIST)
	{
		return;
	}
	if((pos == (ExchangeFind_RichList.GetRecordCount() - ExchangeFind_RichList.GetShowRow())))
	{
		RQ_C_EX_WORLD_EXCHANGE_ITEM_LIST((lastLoadedPage + 1));
	}
	return;
}

function TInsertRecordOnTime(int Count)
{
	TInsertRecord();
	return;
}

function TInsertRecord()
{
	local int i, Cnt;
	local RichListCtrlRowData rowData;

	if((_itemDatas.Length == 0))
	{
		if((tObjectListAdd._curCount >= refreshMinCount))
		{
			tObjectListAdd._Stop();
			tObject._Stop();
			TInserDelayCheck();
			SetEnableRefresh();
		}
		return;
	}
	Cnt = Min(10, _itemDatas.Length);
	if(IsAdena(sellItemInfo.Id))
	{
		i = 0;
		while((i < Cnt))
		{
			if(Class'Interface.WorldExchangeBuyWnd'.static.Inst()._MakeRowDataAdena(_itemDatas[i], rowData))
			{
				ExchangeFind_RichList.InsertRecord(rowData);
			}
			i++;
		}
	}
	else
	{
		i = 0;
		while((i < Cnt))
		{
			if(MakeRowData(_itemDatas[i], rowData))
			{
				ExchangeFind_RichList.InsertRecord(rowData);
			}
			i++;
		}
	}
	_itemDatas.Remove(0, Cnt);
	return;
}

function TInserDelayCheck()
{
	HandleScrollMove(scrollPos);
	return;
}

function bool MakeRowData(UIPacket._WorldExchangeItemData _itemData, out RichListCtrlRowData outRowData)
{
	local RichListCtrlRowData rowData;
	local ItemInfo iInfo;
	local string strcom, itemParam;
	local float unitPrice;

	rowData.cellDataList.Length = 3;
	if((_itemData.nItemClassID < 1))
	{
		return false;
	}
	if(!Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(_itemData.nItemClassID), iInfo))
	{
		return false;
	}
	rowData.nReserved1 = _itemData.nWEIndex;
	rowData.nReserved2 = INT64(ExchangeFind_RichList.GetRecordCount());
	iInfo.ItemNum = _itemData.nAmount;
	iInfo.bShowCount = IsStackableItem(iInfo.ConsumeType);
	iInfo.Enchanted = _itemData.nEnchant;
	iInfo.RefineryOp1 = _itemData.nVariationOpt1;
	iInfo.RefineryOp2 = _itemData.nVariationOpt2;
	iInfo.RefineryOp3 = _itemData.nVariationOpt3;
	iInfo.AttackAttributeType = _itemData.nBaseAttributeAttackType;
	iInfo.AttackAttributeValue = _itemData.nBaseAttributeAttackValue;
	iInfo.DefenseAttributeValueFire = _itemData.nBaseAttributeDefendValue[0];
	iInfo.DefenseAttributeValueWater = _itemData.nBaseAttributeDefendValue[1];
	iInfo.DefenseAttributeValueWind = _itemData.nBaseAttributeDefendValue[2];
	iInfo.DefenseAttributeValueEarth = _itemData.nBaseAttributeDefendValue[3];
	iInfo.DefenseAttributeValueHoly = _itemData.nBaseAttributeDefendValue[4];
	iInfo.DefenseAttributeValueUnholy = _itemData.nBaseAttributeDefendValue[5];
	iInfo.LookChangeItemID = _itemData.nShapeShiftingClassId;
	iInfo.LookChangeItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(_itemData.nShapeShiftingClassId));
	if((_itemData.nShapeShiftingClassId > 0))
	{
		iInfo.LookChangeIconPanel = "BranchSys3.Icon.pannel_lookChange";
	}
	iInfo.EnsoulOption[(1 - 1)].OptionArray[0] = _itemData.nEsoulOption[0];
	iInfo.EnsoulOption[(1 - 1)].OptionArray[1] = _itemData.nEsoulOption[1];
	iInfo.EnsoulOption[(2 - 1)].OptionArray[0] = _itemData.nEsoulOption[2];
	iInfo.IsBlessedItem = (_itemData.nBlessOption == 1);
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "l2ui_ct1.ItemWindow_DF_SlotBox_Default", 36, 36, 0, 1);
	AddRichListCtrlItem(rowData.cellDataList[0].drawitems, iInfo, 32, 32, -34, 2);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, GetItemNameAll(iInfo), GTColor().White, false, 4, 2);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, ("x" $ string(_itemData.nAmount)), GTColor().White, true, 39, 3);
	iInfo.Price = _itemData.nPrice;
	strcom = MakeCostStringINT64(iInfo.Price);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, GetSystemString(3931), GetColor(147, 136, 112, 255), false, 18, 0);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, strcom, GetNumericColor(strcom), false, 5, 0);
	unitPrice = (float(iInfo.Price) / float(iInfo.ItemNum));
	strcom = MakeCostStringINT64((iInfo.Price / iInfo.ItemNum));
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, ("." $ Class'Interface.WorldExchangeBuyWnd'.static.Inst().GetDecimalNnmStr(unitPrice)), GetColor(123, 123, 123, 255), false, 0, 0, "hs7");
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, strcom, GetNumericColor(strcom), false, 0, -1);
	ItemInfoToParam(iInfo, itemParam);
	rowData.szReserved = itemParam;
	outRowData = rowData;
	return true;
}

function HandleDialogOKSource()
{
	local INT64 ItemNum;

	ItemNum = MAX64(INT64(0), INT64(DialogGetString()));
	sellItemInfo.ItemNum = (sellItemInfo.ItemNum - MAX64(Min64(ItemNum, sellItemInfo.ItemNum), INT64(0)));
	if((sellItemInfo.ItemNum == INT64(0)))
	{
		DelItemInfo();
	}
	else
	{
		SetItemInfo();
	}
	return;
}

function HandleDialogOKDrop()
{
	local INT64 ItemNum;

	ItemNum = MAX64(INT64(0), INT64(DialogGetString()));
	if((ItemNum == INT64(0)))
	{
		return;
	}
	if((sellItemInfo.Id == readySellItemInfo.Id))
	{
		sellItemInfo.ItemNum = (sellItemInfo.ItemNum + ItemNum);
	}
	else
	{
		SetSortType(EWEST_PRICE_PER_PIECE_ASCE);
		readySellItemInfo.ItemNum = ItemNum;
		sellItemInfo = readySellItemInfo;
		RQ_C_EX_WORLD_EXCHANGE_AVERAGE_PRICE();
	}
	SetItemInfo();
	return;
}

function HandleDialogOkEdit()
{
	local INT64 ItemNum;

	ItemNum = MAX64(INT64(0), INT64(DialogGetString()));
	if((ItemNum == INT64(0)))
	{
		return;
	}
	sellItemInfo.ItemNum = ItemNum;
	SetItemInfo();
	return;
}

function HandleDialogOKPrice()
{
	local INT64 ItemNum;

	ItemNum = MAX64(INT64(0), INT64(DialogGetString()));
	if((ItemNum == INT64(0)))
	{
		return;
	}
	bundlePrice_NumberInputScr.SetCount(ItemNum);
	return;
}

function HandleGetRewardBtn()
{
	SetSellPopupInfos();
	return;
}

function SetSellPopupInfos()
{
	local string popupPath;

	popupPath = (m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemRegiDialog_Wnd");
	GetWindowHandle(popupPath).ShowWindow();
	GetItemWindowHandle((popupPath $ ".Dialog_Wnd.Item_ItemWnd")).Clear();
	if(IsAdena(sellItemInfo.Id))
	{
		GetTextBoxHandle((popupPath $ ".ItemName_Txt")).SetTextColor(GetNumericColor(string(sellItemInfo.ItemNum)));
		GetTextBoxHandle((popupPath $ ".ItemName_Txt")).SetText((MakeCostStringINT64(sellItemInfo.ItemNum) @ GetSystemString(469)));
		GetTextBoxHandle((popupPath $ ".ItemNum_Txt")).SetText("x1");
		GetTextBoxHandle((popupPath $ ".UnitPriceTitle_Txt")).SetText(GetSystemString(14192));
	}
	else
	{
		GetTextBoxHandle((popupPath $ ".ItemName_Txt")).SetTextColor(GetColor(153, 153, 153, 255));
		GetTextBoxHandle((popupPath $ ".Dialog_Wnd.ItemName_Txt")).SetText(GetItemNameAll(sellItemInfo));
		GetTextBoxHandle((popupPath $ ".Dialog_Wnd.ItemNum_Txt")).SetText(("x" $ MakeCostStringINT64(sellItemInfo.ItemNum)));
		GetTextBoxHandle((popupPath $ ".UnitPriceTitle_Txt")).SetText(GetSystemString(14088));
	}
	GetItemWindowHandle((popupPath $ ".Dialog_Wnd.Item_ItemWnd")).AddItem(sellItemInfo);
	GetTextBoxHandle((popupPath $ ".Dialog_Wnd.TotalPiceCount_txt")).SetText((MakeCostString(string(bundlePrice_NumberInputScr.GetCount())) @ GetSystemString(3931)));
	GetTextBoxHandle((popupPath $ ".Dialog_Wnd.TotalPiceCount_txt")).SetTextColor(GetColor(255, 255, 255, 255));
	GetTextBoxHandle((popupPath $ ".Dialog_Wnd.RegiFeePiceCount_txt")).SetText(Get_RegiFeePiceCount_Txt().GetText());
	GetTextBoxHandle((popupPath $ ".Dialog_Wnd.SellFeePiceCount_txt")).SetText(Get_SellFeePiceCount_Txt().GetText());
	GetTextBoxHandle((popupPath $ ".Dialog_Wnd.UnitPriceCount_txt")).SetText(Get_UnitPriceCount_Txt().GetText());
	GetTextBoxHandle((popupPath $ ".Dialog_Wnd.UnitPricePrimeNumber_txt")).SetText(Get_UnitPricePrimeNumber_txt().GetText());
	return;
}

function SetHideSellDialogWindow()
{
	local string popupPath;

	TweenCancel();
	popupPath = (m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemRegiDialog_Wnd");
	GetWindowHandle(popupPath).HideWindow();
	return;
}

function _Show()
{
	m_hOwnerWnd.ShowWindow();
	m_hOwnerWnd.SetFocus();
	return;
}

function _Hide()
{
	m_hOwnerWnd.HideWindow();
	return;
}

function handleSwap()
{
	Debug("HandleSwap");
	Class'Interface.WorldExchangeBuyWnd'.static.Inst()._Show();
	getInstanceL2Util().syncWindowLoc(m_hOwnerWnd.m_WindowNameWithFullPath, "WorldExchangeBuyWnd");
	return;
}

function HandleRefresh()
{
	RQ_C_EX_WORLD_EXCHANGE_ITEM_LIST();
	return;
}

function CheckWorldExchangeRegiSubWnd()
{
	if((GetTabHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiList_Tab")).GetTopIndex() == 0))
	{
		Class'Interface.WorldExchangeRegiSubWnd'.static.Inst()._Show();
	}
	else
	{
		Class'Interface.WorldExchangeRegiSubWnd'.static.Inst()._Hide();
	}
	return;
}

function SetMyInfos()
{
	local array<ItemInfo> iInfos;

	Get_MyAdenaCount_Txt().SetText((MakeCostString(string(GetAdena())) @ GetSystemString(469)));
	if((Class'NWindow.UIDATA_INVENTORY'.static.FindItemByClassID(LCOIN_CLASSID, iInfos) > 0))
	{
		Get_MyLcoinCount_Txt().SetText((MakeCostString(string(iInfos[0].ItemNum)) @ GetSystemString(3931)));
	}
	else
	{
		Get_MyLcoinCount_Txt().SetText(("0" @ GetSystemString(3931)));
	}
	return;
}

function HandleMyItemChanged(optional array<ItemInfo> iInfos, optional int Index)
{
	SetMyInfos();
	return;
}

function HandleOnitemCountEdited(INT64 changedNum)
{
	local ItemWindowHandle Item_ItemWnd;
	local string commitionRegist;

	commitionRegist = string(GetCommitionRegist());
	Debug(("itemSell_NumberInputScr.GetCount()" @ string(itemSell_NumberInputScr.GetCount())));
	sellItemInfo.ItemNum = itemSell_NumberInputScr.GetCount();
	Item_ItemWnd = GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.Item_ItemWnd"));
	Item_ItemWnd.SetItem(0, sellItemInfo);
	Class'Interface.WorldExchangeRegiSubWnd'.static.Inst()._ResetSellItem();
	_SetUnity(bundlePrice_NumberInputScr.GetCount(), itemSell_NumberInputScr.GetCount());
	Get_RegiFeePiceCount_Txt().SetText((MakeCostString(commitionRegist) @ GetSystemString(469)));
	Get_RegiFeePiceCount_TxtUnit_Txt().SetText(ConvertNumToText(commitionRegist));
	Get_RegiFeePiceCount_TxtUnit_Txt().SetTextColor(GetNumericColor(commitionRegist));
	if(IsAdena(sellItemInfo.Id))
	{
		itemSell_NumberInputScr._SetEditBoxFontColor(GetNumericColor(string(sellItemInfo.ItemNum)));
		itemSell_NumberInputScr._SetEditBoxDisable(true);
		bundlePrice_NumberInputScr.SetCount(bundlePrice_NumberInputScr.GetCount());
	}
	else
	{
		itemSell_NumberInputScr._SetEditBoxFontColor(getInstanceL2Util().BrightWhite);
		itemSell_NumberInputScr._SetEditBoxDisable(false);
	}
	CheckGetRewardBtn();
	return;
}

function HandleOnPriceCountEdited(INT64 changedNum)
{
	local string commitionRegist;

	commitionRegist = string(GetCommitionRegist());
	_SetUnity(bundlePrice_NumberInputScr.GetCount(), itemSell_NumberInputScr.GetCount());
	Get_RegiFeePiceCount_Txt().SetText((MakeCostString(commitionRegist) @ GetSystemString(469)));
	Get_RegiFeePiceCount_TxtUnit_Txt().SetText(ConvertNumToText(commitionRegist));
	Get_RegiFeePiceCount_TxtUnit_Txt().SetTextColor(GetNumericColor(commitionRegist));
	Get_SellFeePiceCount_Txt().SetText((MakeCostString(string(GetCommitionSell())) @ GetSystemString(3931)));
	CheckGetRewardBtn();
	return;
}

function HandleOnOverInput()
{
	getInstanceL2Util().showGfxScreenMessage(GetSystemString(13448));
	return;
}

function HandleOnItemCountEditBtonClicked()
{
	local INT64 maxItemNum64;

	maxItemNum64 = GetSellItemInfoNum(readySellItemInfo.Id.ServerID);
	if(IsAdena(sellItemInfo.Id))
	{
		DialogShow(DialogModalType_Modalless, DialogType_NumberPadAdena, GetSystemString(14193));
	}
	else
	{
		DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), sellItemInfo.Name, ""));
	}
	DialogSetInputlimit(maxItemNum64);
	DialogSetParamInt64(maxItemNum64);
	Class'Interface.DialogBox'.static.Inst().AnchorToOwner();
	Class'Interface.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOkEdit;
	return;
}

function HandleOnPriceCountEditBtonClicked()
{
	DialogShow(DialogModalType_Modalless, DialogType_NumberPad, GetSystemMessage(322));
	DialogSetInputlimit(GetCanLcoinPriceItemNum());
	DialogSetParamInt64(5221615900385345559);
	Class'Interface.DialogBox'.static.Inst().AnchorToOwner();
	Class'Interface.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOKPrice;
	return;
}

function CheckGetRewardBtn()
{
	if(getInstanceUIData().GetIsLiveServer())
	{
		if((bundlePrice_NumberInputScr.GetCount() < INT64(10)))
		{
			GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.GetReward_Btn")).DisableWindow();
		}
		else
		{
			GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.GetReward_Btn")).EnableWindow();
		}
	}
	else if(((itemSell_NumberInputScr.GetCount() == INT64(0)) || (GetCommitionSell() == 0)))
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.GetReward_Btn")).DisableWindow();
	}
	else
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.GetReward_Btn")).EnableWindow();
	}
	return;
}

function _SetShowCancelDialog(string itemReservedString)
{
	local ItemInfo iInfo;
	local string CancelSaleDialogPath;

	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CancelSaleDialog_Wnd")).ShowWindow();
	CancelSaleDialogPath = (m_hOwnerWnd.m_WindowNameWithFullPath $ ".CancelSaleDialog_Wnd.CancelSalePopUp_Wnd");
	ParamToItemInfo(itemReservedString, iInfo);
	GetTextBoxHandle((CancelSaleDialogPath $ ".ItemName_Txt")).SetText(GetItemNameAll(iInfo));
	GetItemWindowHandle((CancelSaleDialogPath $ ".Result_ItemWnd")).Clear();
	GetItemWindowHandle((CancelSaleDialogPath $ ".Result_ItemWnd")).AddItem(iInfo);
	return;
}

function _SetMaxRegiItemNum(int maxNum)
{
	mAXRegiItemNum = maxNum;
	_SetCurrentRigedItemNum(_regieditemNum);
	return;
}

function _SetCurrentRigedItemNum(int Num)
{
	_regieditemNum = Num;
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.RegiItemNumTxt_Apply")).SetText(string(Num));
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.RegiItemNumTxt_Total")).SetText(("/" $ string(mAXRegiItemNum)));
	if((Num == mAXRegiItemNum))
	{
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.ItemFullDisable_Wnd")).ShowWindow();
	}
	else
	{
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.ItemFullDisable_Wnd")).HideWindow();
	}
	return;
}

function HandleClickOK_Btn()
{
	local float perPrice;

	perPrice = (float(bundlePrice_NumberInputScr.GetCount()) / float(itemSell_NumberInputScr.GetCount()));
	if(IsAdena(sellItemInfo.Id))
	{
		perPrice = (perPrice * float(Class'Interface.WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT));
	}
	if(getInstanceUIData().GetIsClassicServer())
	{
		if(bRQ_C_EX_WORLD_EXCHANGE_AVERAGE_PRICE)
		{
			return;
		}
		Debug((("HandleClickOK_Btn" @ string(perPrice)) @ string((nAveragePrice * 0.9000000))));
		if((perPrice < (nAveragePrice * 0.9000000)))
		{
			Class'Interface.DialogBox'.static.Inst().SetDefaultAction(EDefaultCancel);
			DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemString(14204));
			Class'Interface.DialogBox'.static.Inst().AnchorToOwner(-7, 144);
			Class'Interface.DialogBox'.static.Inst().DelegateOnOK = HandleOK;
			Class'Interface.DialogBox'.static.Inst().DelegateOnCancel = SetHideSellDialogWindow;
			TweenAdd();
		}
		else
		{
			HandleOK();
		}
	}
	else
	{
		HandleOK();
	}
	return;
}

function TweenAdd()
{
	Class'Interface.L2UITween'.static.Inst()._AddTweenTwinlkle(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemRegiDialog_Wnd.Dialog_Wnd.UnitPriceCount_txt")), -1.0000000);
	Class'Interface.L2UITween'.static.Inst()._AddTweenTwinlkle(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemRegiDialog_Wnd.Dialog_Wnd.UnitPricePrimeNumber_txt")), -1.0000000);
	return;
}

function TweenCancel()
{
	Debug("TweenCancel 취소 ~~~ ");  // EN?: Cancel TweenCancel ~ ~ ~
	Class'Interface.L2UITween'.static.Inst()._KillTwinkleWithWnd(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemRegiDialog_Wnd.Dialog_Wnd.UnitPriceCount_txt")));
	Class'Interface.L2UITween'.static.Inst()._KillTwinkleWithWnd(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemRegiDialog_Wnd.Dialog_Wnd.UnitPricePrimeNumber_txt")));
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemRegiDialog_Wnd.Dialog_Wnd.UnitPriceCount_txt")).SetAlpha(255);
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemRegiDialog_Wnd.Dialog_Wnd.UnitPricePrimeNumber_txt")).SetAlpha(255);
	return;
}

function HandleOK()
{
	SetHideSellDialogWindow();
	RQ_C_EX_WORLD_EXCHANGE_REGI_ITEM();
	return;
}

function HandleCancelOK()
{
	historyScr._RQ_C_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT();
	return;
}

function HandleCancelCancel()
{
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CancelSaleDialog_Wnd")).HideWindow();
	return;
}

function bool IsShowHistory()
{
	local TabHandle regilistTab;

	regilistTab = GetTabHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiList_Tab"));
	return (m_hOwnerWnd.IsShowWindow() && (regilistTab.GetTopIndex() == 1));
}

function _CheckOnClickNoticeBtn()
{
	local TabHandle regilistTab;

	regilistTab = GetTabHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiList_Tab"));
	if(IsShowHistory())
	{
		m_hOwnerWnd.HideWindow();
	}
	else
	{
		_Show();
		regilistTab.SetTopOrder(1, true);
	}
	CheckWorldExchangeRegiSubWnd();
	return;
}

function int GetSortType()
{
	switch(sortHeaderIndex)
	{
		case 0:
			if(ExchangeFind_RichList.IsAscending(sortHeaderIndex))
			{
				return 2;
			}
			else
			{
				return 3;
			}
		case 1:
			if(ExchangeFind_RichList.IsAscending(sortHeaderIndex))
			{
				return 4;
			}
			else
			{
				return 5;
			}
		case 2:
			if(ExchangeFind_RichList.IsAscending(sortHeaderIndex))
			{
				return 8;
			}
			else
			{
				return 9;
			}
		default:
			return 2;
	}
}

function SetSortByHeaderIndex(int Index)
{
	Debug(("SetSortByHeaderIndex" @ string(Index)));
	switch(Index)
	{
		case 0:
			if(ExchangeFind_RichList.IsAscending(Index))
			{
				SetSortType(EWEST_ENCHANT_DESC);
			}
			else
			{
				SetSortType(EWEST_ENCHANT_ASCE);
			}
			break;
		case 1:
			if(ExchangeFind_RichList.IsAscending(Index))
			{
				SetSortType(EWEST_PRICE_DESC);
			}
			else
			{
				SetSortType(EWEST_PRICE_ASCE);
			}
			break;
		case 2:
			if(ExchangeFind_RichList.IsAscending(Index))
			{
				SetSortType(EWEST_PRICE_PER_PIECE_DESC);
			}
			else
			{
				SetSortType(EWEST_PRICE_PER_PIECE_ASCE);
			}
			break;
		default:
			SetSortType(EWEST_ENCHANT_ASCE);
			break;
	}
	return;
}

function SetSortType(E_WORLD_EXCHANGE_SORT_TYPE sortType)
{
	local bool bAscend;

	Debug(("SetSortType" @ string(sortType)));
	switch(sortType)
	{
		case EWEST_ENCHANT_ASCE:
			sortHeaderIndex = 0;
			bAscend = true;
			break;
		case EWEST_ENCHANT_DESC:
			sortHeaderIndex = 0;
			bAscend = false;
			break;
		case EWEST_PRICE_ASCE:
			sortHeaderIndex = 1;
			bAscend = true;
			break;
		case EWEST_PRICE_DESC:
			sortHeaderIndex = 1;
			bAscend = false;
			break;
		case EWEST_PRICE_PER_PIECE_ASCE:
			sortHeaderIndex = 2;
			bAscend = true;
			break;
		case EWEST_PRICE_PER_PIECE_DESC:
			sortHeaderIndex = 2;
			bAscend = false;
			break;
		default:
			sortHeaderIndex = 0;
			bAscend = true;
			break;
	}
	ExchangeFind_RichList.SetAscend(sortHeaderIndex, bAscend);
	ExchangeFind_RichList.ShowSortIcon(sortHeaderIndex);
	return;
}

function SetMaxRegiItemDefault()
{
	mAXRegiItemNum = 10;
	return;
}

function _SetUnity(INT64 bundlePrice, INT64 ItemNum)
{
	local float unitPrice;
	local string strcom;

	if(IsAdena(sellItemInfo.Id))
	{
		ItemNum = (ItemNum / Class'Interface.WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT);
		GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.UnitPriceTitle_Txt")).SetText(GetSystemString(14192));
	}
	else
	{
		GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.UnitPriceTitle_Txt")).SetText(GetSystemString(14088));
	}
	unitPrice = (float(bundlePrice) / float(ItemNum));
	strcom = MakeCostStringINT64((bundlePrice / ItemNum));
	Get_UnitPriceCount_Txt().SetText(strcom);
	if((bundlePrice == INT64(0)))
	{
		Get_UnitPricePrimeNumber_txt().SetText(".00");
	}
	else
	{
		Get_UnitPricePrimeNumber_txt().SetText(("." $ Class'Interface.WorldExchangeBuyWnd'.static.Inst().GetDecimalNnmStr(unitPrice)));
	}
	return;
}

function TextBoxHandle Get_UnitPriceCount_Txt()
{
	return GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.UnitPriceCount_Txt"));
}

function TextBoxHandle Get_UnitPricePrimeNumber_txt()
{
	return GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.UnitPricePrimeNumber_txt"));
}

function TextBoxHandle Get_RegiFeePiceCount_Txt()
{
	return GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.RegiFeePiceCount_Txt"));
}

function TextBoxHandle Get_RegiFeePiceCount_TxtUnit_Txt()
{
	return GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.RegiFeePiceCount_TxtUnit_Txt"));
}

function TextBoxHandle Get_SellFeePiceCount_Txt()
{
	return GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.SellFeePiceCount_Txt"));
}

function TextBoxHandle Get_MyAdenaCount_Txt()
{
	return GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.MyAdenaCount_Txt"));
}

function TextBoxHandle Get_MyLcoinCount_Txt()
{
	return GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.MyLcoinCount_Txt"));
}

function OnLoadEachServer()
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		MAXITEMNUM = INT64(1000);
		LCOIN_CLASSID = 91663;
		GetMeTexture("ItemRegiDialog_Wnd.Dialog_Wnd.TotalPiceIcon_Tex").SetTexture("L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Icon_Lcoin");
		GetMeTexture("ItemRegiDialog_Wnd.Dialog_Wnd.SellFeeIcon_Tex").SetTexture("L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Icon_Lcoin");
		GetMeTexture("RegiTabWnd.ItemRegi_Wnd.BundlePrice_NumberInput.BundlePriceIcon_Tex").SetTexture("L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Icon_Lcoin");
		GetMeTexture("RegiTabWnd.ItemRegi_Wnd.SellIcon_Tex").SetTexture("L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Icon_Lcoin");
		GetMeTexture("RegiTabWnd.ItemRegi_Wnd.MyLcoinIcon_Tex").SetTexture("L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Icon_Lcoin");
	}
	else
	{
		MAXITEMNUM = INT64(99999);
		LCOIN_CLASSID = 48472;
		GetMeTexture("ItemRegiDialog_Wnd.Dialog_Wnd.TotalPiceIcon_Tex").SetTexture("L2UI_EPIC.LCoinShopWnd.bm_einhasad_coin");
		GetMeTexture("ItemRegiDialog_Wnd.Dialog_Wnd.SellFeeIcon_Tex").SetTexture("L2UI_EPIC.LCoinShopWnd.bm_einhasad_coin");
		GetMeTexture("RegiTabWnd.ItemRegi_Wnd.BundlePrice_NumberInput.BundlePriceIcon_Tex").SetTexture("L2UI_EPIC.LCoinShopWnd.bm_einhasad_coin");
		GetMeTexture("RegiTabWnd.ItemRegi_Wnd.SellIcon_Tex").SetTexture("L2UI_EPIC.LCoinShopWnd.bm_einhasad_coin");
		GetMeTexture("RegiTabWnd.ItemRegi_Wnd.MyLcoinIcon_Tex").SetTexture("L2UI_EPIC.LCoinShopWnd.bm_einhasad_coin");
	}
	return;
}

event OnReceivedCloseUI()
{
	local string popupPath;

	popupPath = (m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemRegiDialog_Wnd");
	if(GetWindowHandle(popupPath).IsShowWindow())
	{
		SetHideSellDialogWindow();
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		_Hide();
	}
	return;
}
