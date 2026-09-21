class ShopWnd extends UICommonAPI;

const DIALOG_TOP_TO_BOTTOM = 111;
const DIALOG_BOTTOM_TO_TOP = 222;
const DIALOG_PREVIEW = 333;
const REFUND_ITEM = 444;

enum ShopType
{
	ShopNone,                       // 0
	ShopBuy,                        // 1
	ShopSell,                       // 2
	ShopPreview,                    // 3
	ShopRefund                      // 4
};

enum TYPE_DIR
{
	non,                            // 0
	toTop,                          // 1
	toBottom                        // 2
};

struct taxInfoByCastle
{
	var int castleID;
	var int taxRate;
};

struct itemsStruct
{
	var array<ItemInfo> iItems;
};

var int m_merchantID;
var int m_npcID;
var bool m_isCompleteTransaction;
var INT64 m_currentPrice;
var INT64 m_UserAdena;
var string m_Windowname;
var int m_maxInventoryCount;
var int m_curInventoryCount;
var int m_numPossibleSlotCount;
var ShopType m_LastShopType;
var ShopType m_shopType;
var WindowHandle Me;
var TabHandle m_TransactionTabHandle;
var TabHandle m_PreviewTabHandle;
var ItemWindowHandle m_BuyTopListHandle;
var ItemWindowHandle m_SellTopListHandle;
var ItemWindowHandle m_RefundTopListHandle;
var ItemWindowHandle m_BuyBottomListHandle;
var ItemWindowHandle m_SellBottomListHandle;
var ItemWindowHandle m_RefundBottomListHandle;
var ItemWindowHandle m_PreviewTopListHandle;
var ItemWindowHandle m_PreviewBottomListHandle;
var TextureHandle m_TexTransactionBGLine;
var TextureHandle m_TexPreviewBGLine;
var TextureHandle m_TexRefundSlotBG;
var TextureHandle m_TexBuySellSlotBG;
var TextureHandle m_TexPreviewSlotBG;
var TextBoxHandle m_PriceConstTextBoxHandle;
var TextBoxHandle m_PriceTextBoxHandle;
var TextBoxHandle m_AdenaTextBoxHandle;
var TextBoxHandle m_BottomTextBoxHandle;
var TextBoxHandle m_TopTextBoxHandle;
var TextBoxHandle m_ShopWndItemCountHandle;
var ButtonHandle m_OkButtonHandle;
var ButtonHandle m_CancelButtonHandle;
var WindowHandle m_itemEnchantWndHandle;
var ItemEnchantWnd m_itemEnchantWndScript;
var TextBoxHandle m_TaxText;
var TextBoxHandle m_TaxConstText;
var array<taxInfoByCastle> taxInfos;
var ButtonHandle m_SwapItemBtn;
var ButtonHandle m_SwapListBtn;
var RichListCtrlHandle topRichListCtrl;
var WindowHandle listWnd;
var UIControlTextInput uicontrolTextInputScr;
var bool isListView;
var array<itemsStruct> iInfos;

event OnRegisterEvent()
{
	RegisterEvent(2090);
	RegisterEvent(2070);
	RegisterEvent(2080);
	RegisterEvent(2081);
	RegisterEvent(2082);
	return;
}

event OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	getInstanceInventoryViewer().showWindowByParentWindow(GetWindowHandle(getCurrentWindowName(string(self))));
	SetEnableWindow(true);
	m_hOwnerWnd.EnableTick();
	return;
}

event OnTick()
{
	FocusToList();
	return;
}

event OnSetFocus(WindowHandle focusedWnd, bool bFocused)
{
	if((bFocused == false))
	{
		return;
	}
	if(GetWindowHandle("InventoryViewer").IsShowWindow())
	{
		GetWindowHandle("InventoryViewer").BringToFront();
	}
	super.OnSetFocus(focusedWnd, bFocused);
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	m_SwapItemBtn = GetButtonHandle((m_Windowname $ ".SwapItemBtn"));
	m_SwapListBtn = GetButtonHandle((m_Windowname $ ".SwapListBtn"));
	m_TransactionTabHandle = GetTabHandle((m_Windowname $ ".TransactionSelectTab"));
	m_PreviewTabHandle = GetTabHandle((m_Windowname $ ".PreviewSelectTab"));
	m_BuyTopListHandle = GetItemWindowHandle((m_Windowname $ ".BuyTopList"));
	m_SellTopListHandle = GetItemWindowHandle((m_Windowname $ ".SellTopList"));
	m_RefundTopListHandle = GetItemWindowHandle((m_Windowname $ ".RefundTopList"));
	m_BuyTopListHandle.SetTooltipType("InventoryPrice1HideEnchantStackable");
	m_SellTopListHandle.SetTooltipType("InventoryPrice2");
	m_RefundTopListHandle.SetTooltipType("InventoryPrice1");
	m_BuyBottomListHandle = GetItemWindowHandle((m_Windowname $ ".BuyBottomList"));
	m_SellBottomListHandle = GetItemWindowHandle((m_Windowname $ ".SellBottomList"));
	m_RefundBottomListHandle = GetItemWindowHandle((m_Windowname $ ".RefundBottomList"));
	m_BuyBottomListHandle.SetTooltipType("InventoryStackableUnitPrice");
	m_SellBottomListHandle.SetTooltipType("InventoryStackableUnitPrice");
	m_RefundBottomListHandle.SetTooltipType("InventoryPrice1");
	m_PreviewTopListHandle = GetItemWindowHandle((m_Windowname $ ".PreviewTopList"));
	m_PreviewBottomListHandle = GetItemWindowHandle((m_Windowname $ ".PreviewBottomList"));
	m_TexTransactionBGLine = GetTextureHandle((m_Windowname $ ".TransactionSelectTabBgLine"));
	m_TexPreviewBGLine = GetTextureHandle((m_Windowname $ ".Sell_TexTabBgLine"));
	m_TexRefundSlotBG = GetTextureHandle((m_Windowname $ ".RefundItemListBg"));
	m_TexBuySellSlotBG = GetTextureHandle((m_Windowname $ ".Buy_TopSlotListBg"));
	m_TexPreviewSlotBG = GetTextureHandle((m_Windowname $ ".Sell_TopSlotListBg"));
	m_PriceConstTextBoxHandle = GetTextBoxHandle((m_Windowname $ ".PriceConstText"));
	m_PriceTextBoxHandle = GetTextBoxHandle((m_Windowname $ ".PriceText"));
	m_AdenaTextBoxHandle = GetTextBoxHandle((m_Windowname $ ".AdenaText"));
	m_BottomTextBoxHandle = GetTextBoxHandle((m_Windowname $ ".BottomText"));
	m_TopTextBoxHandle = GetTextBoxHandle((m_Windowname $ ".TopText"));
	m_ShopWndItemCountHandle = GetTextBoxHandle((m_Windowname $ ".ItemCount"));
	m_OkButtonHandle = GetButtonHandle((m_Windowname $ ".OKButton"));
	m_CancelButtonHandle = GetButtonHandle((m_Windowname $ ".CancelButton"));
	m_isCompleteTransaction = false;
	m_LastShopType = ShopNone;
	m_itemEnchantWndHandle = GetWindowHandle("ItemEnchantWnd");
	m_itemEnchantWndScript = ItemEnchantWnd(GetScript("ItemEnchantWnd"));
	m_TaxConstText = GetTextBoxHandle((m_Windowname $ ".TaxConstText"));
	if(IsAdenServer())
	{
		m_TaxConstText.SetText((GetSystemString(1608) @ ":"));
		m_TaxText = GetTextBoxHandle((m_Windowname $ ".TaxText"));
		m_TaxText.SetText("0%");
	}
	else
	{
		m_TaxConstText.HideWindow();
	}
	listWnd = GetWindowHandle((m_Windowname $ ".list_Wnd"));
	listWnd.HideWindow();
	topRichListCtrl = GetRichListCtrlHandle((m_Windowname $ ".list_Wnd.topRichListCtrl"));
	topRichListCtrl.SetSelectedSelTooltip(false);
	topRichListCtrl.SetAppearTooltipAtMouseX(true);
	topRichListCtrl.SetEnableItemRecordDrag(true);
	uicontrolTextInputScr = Class'Interface.UIControlTextInput'.static.InitScript(GetWindowHandle((m_Windowname $ ".FindText")));
	uicontrolTextInputScr.DelegateESCKey = DelegateESCKey;
	uicontrolTextInputScr.DelegateOnChangeEdited = DelegateOnChangeEdited;
	uicontrolTextInputScr.DelegateOnCompleteEditBox = DelegateOnCompleteEditBox;
	uicontrolTextInputScr.SetDisable(false);
	uicontrolTextInputScr.SetEdtiable(true);
	uicontrolTextInputScr.SetDefaultString(GetSystemString(2507));
	iInfos.Length = 4;
	m_shopType = ShopNone;
	return;
}

function DelegateOnChangeEdited(string Text)
{
	SetItemsWithFindString();
	return;
}

function DelegateOnCompleteEditBox(string Text)
{
	return;
}

function DelegateESCKey()
{
	FocusToList();
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 2080:
			HandleOpenWindow(param);
			break;
		case 2090:
			HandleAddItem(param);
			break;
		case 2081:
			HandleEndTransactionList(param);
			break;
		case 2070:
			HandleSetMaxCount(param);
			break;
		case 2082:
			HandleOnAddCastleTaxRateList(param);
		default:
			break;
	}
	return;
}

event OnClickButton(string ControlName)
{
	if((ControlName == "SwapItemBtn"))
	{
		SwapList();
	}
	if((ControlName == "SwapListBtn"))
	{
		SwapList();
	}
	else if((ControlName == "OKButton"))
	{
		SetEnableWindow(true);
		HandleOKButton();
	}
	else if((ControlName == "CancelButton"))
	{
		SetEnableWindow(true);
		HideWindow(m_Windowname);
	}
	else if((ControlName == "TransactionSelectTab0"))
	{
		SwapShopType(ShopBuy);
	}
	else if((ControlName == "TransactionSelectTab1"))
	{
		SwapShopType(ShopSell);
	}
	else if((ControlName == "TransactionSelectTab2"))
	{
		SwapShopType(ShopRefund);
	}
	else if((ControlName == "InventoryViewerCall_Button"))
	{
		getInstanceInventoryViewer().showWindowByParentWindow(GetWindowHandle(getCurrentWindowName(string(self))), true);
	}
	return;
}

event OnRClickItem(string strID, int Index)
{
	OnDBClickItem(strID, Index);
	return;
}

event OnDBClickItem(string ControlName, int Index)
{
	local ItemInfo iInfo;

	if(((((ControlName == "BuyTopList") || (ControlName == "RefundTopList")) || (ControlName == "SellTopList")) || (ControlName == "PreviewTopList")))
	{
		GetCurrentTopListHandle().GetSelectedItem(iInfo);
		StartMoveItemTopToBottom(iInfo, (Class'NWindow.InputAPI'.static.IsAltPressed() && (int(m_shopType) == 2)));
	}
	else if(((((ControlName == "RefundBottomList") || (ControlName == "PreviewBottomList")) || (ControlName == "BuyBottomList")) || (ControlName == "SellBottomList")))
	{
		GetCurrentBottomListHandle().GetSelectedItem(iInfo);
		StartMoveItemBottomToTop(iInfo, (Class'NWindow.InputAPI'.static.IsAltPressed() && ((int(m_shopType) == 1) || (int(m_shopType) == 2))));
	}
	return;
}

event OnDropItem(string strID, ItemInfo Info, int X, int Y)
{
	switch(GetDir(strID, Info))
	{
		case toTop:
			StartMoveItemBottomToTop(Info);
			break;
		case toBottom:
			StartMoveItemTopToBottom(Info);
			break;
		default:
			break;
	}
	return;
}

event OnDBClickListCtrlRecord(string ListCtrlID)
{
	local int Index;
	local ItemInfo iInfo;

	Index = topRichListCtrl.GetSelectedIndex();
	GetCurrentTopListHandle().GetItem(Index, iInfo);
	StartMoveItemTopToBottom(iInfo, (Class'NWindow.InputAPI'.static.IsAltPressed() && (int(m_shopType) == 2)));
	return;
}

event OnRClickListCtrlRecord(string ListCtrlID)
{
	OnDBClickListCtrlRecord(ListCtrlID);
	return;
}

event OnHide()
{
	m_LastShopType = ShopNone;
	if((int(m_shopType) != 3))
	{
		RequestBuySellUIClose();
	}
	if(DialogIsMine())
	{
		DialogHide();
	}
	Clear();
	m_isCompleteTransaction = false;
	m_itemEnchantWndScript.SetIsShopping(false);
	if(GetWindowHandle("InventoryViewer").IsShowWindow())
	{
		GetWindowHandle("InventoryViewer").HideWindow();
	}
	uicontrolTextInputScr.Clear();
	return;
}

function StartMoveItemBottomToTop(ItemInfo iInfo, optional bool bAllItem)
{
	local int Index;

	Index = FindItemIndexBot(iInfo.Id);
	if((Index < 0))
	{
		return;
	}
	MoveItemBottomToTop(Index, ((iInfo.AllItemCount > INT64(0)) || bAllItem));
	return;
}

function StartMoveItemTopToBottom(ItemInfo iInfo, optional bool bAllItem)
{
	local int Index;
	local INT64 ItemNum;

	Index = FindItemIndexTop(iInfo.Id);
	if((Index < 0))
	{
		return;
	}
	ItemNum = iInfo.ItemNum;
	switch(m_shopType)
	{
		case ShopRefund:
			ItemNum = INT64(1);
		case ShopBuy:
			if((GetCurrentBottomListHandle().GetItemNum() >= m_numPossibleSlotCount))
			{
				if((!IsStackableItem(iInfo.ConsumeType) || (FindItemIndexBot(iInfo.Id) == -1)))
				{
					AddSystemMessage(3675);
					return;
				}
			}
			if((ItemNum == INT64(0)))
			{
				ItemNum = INT64(1);
			}
			if((iInfo.Price > INT64(0)))
			{
				if((CheckUserAdena(iInfo) < ItemNum))
				{
					getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(279));
					return;
				}
			}
			break;
		default:
			break;
	}
	MoveItemTopToBottom(Index, ((iInfo.AllItemCount > INT64(0)) || bAllItem));
	return;
}

function INT64 CheckUserAdena(ItemInfo iInfo)
{
	local INT64 canBuyPrice;

	canBuyPrice = (m_UserAdena - m_currentPrice);
	return (canBuyPrice / iInfo.Price);
}

function MoveItemTopToBottom(int Index, bool bAllItem)
{
	local int bottomIndex;
	local ItemInfo Info, bottomInfo;

	if((Index < 0))
	{
		return;
	}
	if((int(m_shopType) == 1))
	{
		m_BuyTopListHandle.GetItem(Index, Info);
	}
	else if((int(m_shopType) == 2))
	{
		m_SellTopListHandle.GetItem(Index, Info);
	}
	else if((int(m_shopType) == 4))
	{
		m_RefundTopListHandle.GetItem(Index, Info);
	}
	else if((int(m_shopType) == 3))
	{
		m_PreviewTopListHandle.GetItem(Index, Info);
	}
	if((((!bAllItem && IsStackableItem(Info.ConsumeType)) && (Info.ItemNum != INT64(1))) && (int(m_shopType) != 4)))
	{
		SetEnableWindow(false);
		DialogSetID(111);
		DialogSetReservedItemID(Info.Id);
		DialogSetReservedItemInfo(Info);
		DialogSetReservedInt(GetCurrentAddedWeight());
		DialogSetDefaultOK();
		switch(m_shopType)
		{
			case ShopBuy:
				if((Info.Weight > 0))
				{
					DialogShow(DialogModalType_Modalless, DialogType_NumberPad2, MakeFullSystemMsg(GetSystemMessage(72), Info.Name, ""));
				}
				else
				{
					DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), Info.Name, ""));
				}
				DialogSetInputlimit(CheckUserAdena(Info));
				DialogSetParamInt64(INT64(0));
				Class'Interface.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
				Class'Interface.DialogBox'.static.Inst().DelegateOnCancel = HandleDialogCancel;
				break;
			case ShopSell:
				DialogSetParamInt64(Info.ItemNum);
				DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), Info.Name, ""));
				DialogSetInputlimit(Info.ItemNum);
				Class'Interface.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
				Class'Interface.DialogBox'.static.Inst().DelegateOnCancel = HandleDialogCancel;
				break;
			case ShopPreview:
				DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), Info.Name, ""));
				Class'Interface.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
				Class'Interface.DialogBox'.static.Inst().DelegateOnCancel = HandleDialogCancel;
				break;
			default:
				DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), Info.Name, ""));
				Class'Interface.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
				Class'Interface.DialogBox'.static.Inst().DelegateOnCancel = HandleDialogCancel;
				break;
		}
	}
	else
	{
		Info.bShowCount = false;
		if((int(m_shopType) == 1))
		{
			if((Info.ItemNum == INT64(0)))
			{
				Info.ItemNum = INT64(1);
			}
			m_BuyBottomListHandle.AddItem(Info);
			Class'NWindow.UIAPI_INVENWEIGHT'.static.AddWeight((m_Windowname $ ".InvenWeight"), (INT64(Info.Weight) * Info.ItemNum));
		}
		else if((int(m_shopType) == 2))
		{
			bottomIndex = m_SellBottomListHandle.FindItem(Info.Id);
			if(((bottomIndex >= 0) && IsStackableItem(Info.ConsumeType)))
			{
				m_SellBottomListHandle.GetItem(bottomIndex, bottomInfo);
				(bottomInfo.ItemNum += Info.ItemNum);
				m_SellBottomListHandle.SetItem(bottomIndex, bottomInfo);
			}
			else
			{
				m_SellBottomListHandle.AddItem(Info);
			}
			Class'NWindow.UIAPI_INVENWEIGHT'.static.ReduceWeight((m_Windowname $ ".InvenWeight"), (INT64(Info.Weight) * Info.ItemNum));
			m_SellTopListHandle.DeleteItem(Index);
			topRichListCtrl.DeleteRecord(Index);
		}
		else if((int(m_shopType) == 4))
		{
			Info.Reserved = 444;
			m_RefundTopListHandle.DeleteItem(Index);
			topRichListCtrl.DeleteRecord(Index);
			m_RefundBottomListHandle.AddItem(Info);
			Class'NWindow.UIAPI_INVENWEIGHT'.static.AddWeight((m_Windowname $ ".InvenWeight"), (INT64(Info.Weight) * Info.ItemNum));
		}
		else if((int(m_shopType) == 3))
		{
			bottomIndex = m_PreviewBottomListHandle.FindItem(Info.Id);
			Info.ItemNum = INT64(1);
			m_PreviewBottomListHandle.AddItem(Info);
		}
		if((Info.Reserved != 444))
		{
			AddPrice((Info.Price * Info.ItemNum));
		}
		else
		{
			AddPrice(Info.Price);
		}
	}
	UpdateItemCount();
	return;
}

function int GetCurrentAddedWeight()
{
	local int i, totalWeight;
	local ItemInfo iInfo;
	local ItemWindowHandle currentBottomList;

	currentBottomList = GetCurrentBottomListHandle();
	i = 0;
	while((i < currentBottomList.GetItemNum()))
	{
		currentBottomList.GetItem(i, iInfo);
		totalWeight = (totalWeight + (iInfo.Weight * int(iInfo.ItemNum)));
		i++;
	}
	return totalWeight;
}

function MoveItemBottomToTop(int Index, bool bAllItem)
{
	local ItemInfo Info, info2;
	local int topIndex;

	if((Index < 0))
	{
		return;
	}
	if((int(m_shopType) == 1))
	{
		m_BuyBottomListHandle.GetItem(Index, Info);
	}
	else if((int(m_shopType) == 2))
	{
		m_SellBottomListHandle.GetItem(Index, Info);
	}
	else if((int(m_shopType) == 4))
	{
		m_RefundBottomListHandle.GetItem(Index, Info);
	}
	else if((int(m_shopType) == 3))
	{
		m_PreviewBottomListHandle.GetItem(Index, Info);
	}
	if((((!bAllItem && IsStackableItem(Info.ConsumeType)) && (Info.ItemNum != INT64(1))) && (Info.Reserved != 444)))
	{
		SetEnableWindow(false);
		DialogSetID(222);
		DialogSetDefaultOK();
		DialogSetReservedItemID(Info.Id);
		DialogSetReservedItemInfo(Info);
		DialogSetParamInt64(Info.ItemNum);
		DialogSetDefaultOK();
		DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), Info.Name, ""));
		DialogSetInputlimit(Info.ItemNum);
		Class'Interface.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
		Class'Interface.DialogBox'.static.Inst().DelegateOnCancel = HandleDialogCancel;
	}
	else
	{
		if((int(m_shopType) == 1))
		{
			m_BuyBottomListHandle.DeleteItem(Index);
			Class'NWindow.UIAPI_INVENWEIGHT'.static.ReduceWeight((m_Windowname $ ".InvenWeight"), (INT64(Info.Weight) * Info.ItemNum));
		}
		else if((int(m_shopType) == 2))
		{
			m_SellBottomListHandle.DeleteItem(Index);
			topIndex = m_SellTopListHandle.FindItem(Info.Id);
			if((topIndex == -1))
			{
				m_SellTopListHandle.AddItem(Info);
				topRichListCtrl.InsertRecord(makeRecord(Info));
			}
			else
			{
				m_SellTopListHandle.GetItem(topIndex, info2);
				(info2.ItemNum += Info.ItemNum);
				m_SellTopListHandle.SetItem(topIndex, info2);
				ModifyItemNumRecord(topIndex, info2.ItemNum);
			}
			Class'NWindow.UIAPI_INVENWEIGHT'.static.AddWeight((m_Windowname $ ".InvenWeight"), (INT64(Info.Weight) * Info.ItemNum));
		}
		else if((int(m_shopType) == 4))
		{
			m_RefundBottomListHandle.DeleteItem(Index);
			if((Info.Reserved == 444))
			{
				m_RefundTopListHandle.AddItem(Info);
				topRichListCtrl.InsertRecord(makeRecord(Info));
			}
			Class'NWindow.UIAPI_INVENWEIGHT'.static.ReduceWeight((m_Windowname $ ".InvenWeight"), (INT64(Info.Weight) * Info.ItemNum));
		}
		else if((int(m_shopType) == 3))
		{
			m_PreviewBottomListHandle.DeleteItem(Index);
		}
		if((Info.Reserved != 444))
		{
			AddPrice((-Info.Price * Info.ItemNum));
		}
		else
		{
			AddPrice(-Info.Price);
		}
	}
	UpdateItemCount();
	return;
}

function HandleOpenWindow(string param)
{
	local string Type;
	local INT64 Adena;
	local string Adenastring;

	ParseString(param, "type", Type);
	if((Type == "buy"))
	{
		Clear();
		ParseInt(param, "merchant", m_merchantID);
		ParseINT64(param, "adena", Adena);
		Adenastring = MakeCostString(string(Adena));
		m_AdenaTextBoxHandle.SetText(Adenastring);
		m_AdenaTextBoxHandle.SetTooltipString(ConvertNumToText(string(Adena)));
		ParseInt(param, "nInventoryItemCount", m_curInventoryCount);
		ShowWindow(m_Windowname);
		Class'NWindow.UIAPI_WINDOW'.static.SetFocus(m_Windowname);
		SwapShopType(ShopBuy);
		m_UserAdena = Adena;
	}
	else if((Type == "sell"))
	{
		ParseInt(param, "nInventoryItemCount", m_curInventoryCount);
		SwapShopType(ShopSell);
	}
	else if((Type == "refund"))
	{
		ParseInt(param, "nInventoryItemCount", m_curInventoryCount);
		SwapShopType(ShopRefund);
	}
	else if((Type == "preview"))
	{
		Clear();
		ParseInt(param, "merchant", m_merchantID);
		ParseINT64(param, "adena", Adena);
		Adenastring = MakeCostString(string(Adena));
		m_AdenaTextBoxHandle.SetText(Adenastring);
		m_AdenaTextBoxHandle.SetTooltipString(ConvertNumToText(string(Adena)));
		ShowWindow(m_Windowname);
		Class'NWindow.UIAPI_WINDOW'.static.SetFocus(m_Windowname);
		SwapShopType(ShopPreview);
		ParseInt(param, "npc", m_npcID);
	}
	else
	{
		m_shopType = ShopNone;
	}
	iInfos[(int(m_shopType) - 1)].iItems.Length = 0;
	if(m_itemEnchantWndHandle.IsShowWindow())
	{
		m_itemEnchantWndScript.OnClickButton("ExitBtn");
	}
	m_itemEnchantWndScript.SetIsShopping(true);
	taxInfos.Length = 0;
	return;
}

function HandleAddItem(string param)
{
	local int Len, infosIndex;
	local ItemInfo iInfo;

	ParamToItemInfo(param, iInfo);
	if(isCollectionItem(iInfo))
	{
		iInfo.ForeTexture = "L2UI_EPIC.Icon.IconPanel_coll";
	}
	if(((int(m_shopType) == 1) && (iInfo.ItemNum > INT64(0))))
	{
		iInfo.bShowCount = true;
	}
	infosIndex = (int(m_shopType) - 1);
	Len = iInfos[infosIndex].iItems.Length;
	iInfos[infosIndex].iItems[Len] = iInfo;
	if((FindMatchString(GetItemNameAll(iInfo), uicontrolTextInputScr.GetString()) == -1))
	{
		return;
	}
	GetCurrentTopListHandle().AddItem(iInfo);
	topRichListCtrl.InsertRecord(makeRecord(iInfo));
	return;
}

function SetItemsWithFindString()
{
	local int i, j;
	local ItemWindowHandle iHandle, iHandleBottom;
	local array<ItemInfo> Items, topItems;
	local ItemInfo iInfo, bottomItem;
	local int Index;
	local ShopType tmpShopType;

	j = 1;
	while((j <= 4))
	{
		tmpShopType = ToShopType(j);
		iHandle = GetTopListHandleByShopType(tmpShopType);
		iHandle.Clear();
		iHandleBottom = GetBottomListHandleByShopType(tmpShopType);
		Items = iInfos[(j - 1)].iItems;
		topItems.Length = 0;
		i = 0;
		while((i < Items.Length))
		{
			iInfo = Items[i];
			if((uicontrolTextInputScr.GetString() != ""))
			{
				if((FindMatchString(GetItemNameAll(iInfo), uicontrolTextInputScr.GetString()) == -1))
				{
					i++;
					continue;
				}
			}
			if(((int(tmpShopType) == 2) || (int(tmpShopType) == 3)))
			{
				Index = iHandleBottom.FindItem(iInfo.Id);
				if((Index > -1))
				{
					iHandleBottom.GetItem(Index, bottomItem);
					iInfo.ItemNum = (iInfo.ItemNum - bottomItem.ItemNum);
					if((iInfo.ItemNum == INT64(0)))
					{
						i++;
						continue;
					}
				}
			}
			topItems[topItems.Length] = iInfo;
			i++;
		}
		i = 0;
		while((i < topItems.Length))
		{
			iHandle.AddItem(topItems[i]);
			i++;
		}
		if((int(tmpShopType) == int(m_shopType)))
		{
			topRichListCtrl.DeleteAllItem();
			i = 0;
			while((i < topItems.Length))
			{
				topRichListCtrl.InsertRecord(makeRecord(topItems[i]));
				i++;
			}
		}
		j++;
	}
	return;
}

function HandleDialogCancel()
{
	Debug("HandleDialogCancel shop");
	SetEnableWindow(true);
	return;
}

function HandleDialogOK()
{
	local int Id, Index, topIndex;
	local INT64 Num, MAXITEMNUM;
	local ItemInfo Info, topInfo;
	local string param;
	local ItemID cID;

	Debug("HandleDialogOK shop");
	SetEnableWindow(true);
	if(DialogIsMine())
	{
		Id = DialogGetID();
		Num = INT64(DialogGetString());
		cID = DialogGetReservedItemID();
		if(((Id == 111) && (Num > INT64(0))))
		{
			topIndex = FindItemIndexTop(cID);
			if((topIndex >= 0))
			{
				if((int(m_shopType) == 1))
				{
					m_BuyTopListHandle.GetItem(topIndex, topInfo);
					MAXITEMNUM = Class'Interface.DialogBox'.static.Inst().inputLimit;
					if((Num > MAXITEMNUM))
					{
						Num = MAXITEMNUM;
					}
					Index = m_BuyBottomListHandle.FindItem(cID);
					if((Index >= 0))
					{
						m_BuyBottomListHandle.GetItem(Index, Info);
						(Info.ItemNum += Num);
						m_BuyBottomListHandle.SetItem(Index, Info);
						AddPrice((Num * Info.Price));
					}
					else
					{
						Info = topInfo;
						Info.ItemNum = Num;
						Info.bShowCount = false;
						m_BuyBottomListHandle.AddItem(Info);
						AddPrice((Num * Info.Price));
					}
					Class'NWindow.UIAPI_INVENWEIGHT'.static.AddWeight((m_Windowname $ ".InvenWeight"), (INT64(Info.Weight) * Num));
				}
				else if((int(m_shopType) == 2))
				{
					m_SellTopListHandle.GetItem(topIndex, topInfo);
					if((topInfo.ItemNum < Num))
					{
						Num = topInfo.ItemNum;
					}
					Index = m_SellBottomListHandle.FindItem(cID);
					if((Index >= 0))
					{
						m_SellBottomListHandle.GetItem(Index, Info);
						(Info.ItemNum += Num);
						m_SellBottomListHandle.SetItem(Index, Info);
						AddPrice((Num * Info.Price));
					}
					else
					{
						Info = topInfo;
						Info.ItemNum = Num;
						Info.bShowCount = false;
						m_SellBottomListHandle.AddItem(Info);
						AddPrice((Num * Info.Price));
					}
					(topInfo.ItemNum -= Num);
					if((topInfo.ItemNum <= INT64(0)))
					{
						m_SellTopListHandle.DeleteItem(topIndex);
						topRichListCtrl.DeleteRecord(topIndex);
					}
					else
					{
						m_SellTopListHandle.SetItem(topIndex, topInfo);
						ModifyItemNumRecord(topIndex, topInfo.ItemNum);
					}
					Class'NWindow.UIAPI_INVENWEIGHT'.static.ReduceWeight((m_Windowname $ ".InvenWeight"), (INT64(Info.Weight) * Num));
				}
				else if((int(m_shopType) == 3))
				{
					m_PreviewTopListHandle.GetItem(topIndex, topInfo);
					Index = m_PreviewBottomListHandle.FindItem(cID);
					if((Index >= 0))
					{
						m_PreviewBottomListHandle.GetItem(Index, Info);
						(Info.ItemNum += Num);
						m_PreviewBottomListHandle.SetItem(Index, Info);
						AddPrice((Num * Info.Price));
					}
					else
					{
						Info = topInfo;
						Info.ItemNum = Num;
						Info.bShowCount = false;
						m_PreviewBottomListHandle.AddItem(Info);
						AddPrice((Num * Info.Price));
					}
				}
			}
		}
		else if(((Id == 222) && (Num > INT64(0))))
		{
			if((int(m_shopType) == 1))
			{
				Index = m_BuyBottomListHandle.GetSelectedNum();
			}
			else if((int(m_shopType) == 2))
			{
				Index = m_SellBottomListHandle.GetSelectedNum();
			}
			else if((int(m_shopType) == 4))
			{
				Index = m_RefundBottomListHandle.GetSelectedNum();
			}
			else if((int(m_shopType) == 3))
			{
				Index = m_PreviewBottomListHandle.GetSelectedNum();
			}
			if((Index >= 0))
			{
				if((int(m_shopType) == 1))
				{
					m_BuyBottomListHandle.GetItem(Index, Info);
					(Info.ItemNum -= Num);
					if((Info.ItemNum > INT64(0)))
					{
						m_BuyBottomListHandle.SetItem(Index, Info);
					}
					else
					{
						m_BuyBottomListHandle.DeleteItem(Index);
					}
					Class'NWindow.UIAPI_INVENWEIGHT'.static.ReduceWeight((m_Windowname $ ".InvenWeight"), (INT64(Info.Weight) * Num));
					if((Info.ItemNum <= INT64(0)))
					{
						Num = (Info.ItemNum + Num);
					}
					AddPrice((-Num * Info.Price));
				}
				else if((int(m_shopType) == 2))
				{
					m_SellBottomListHandle.GetItem(Index, Info);
					if((Info.ItemNum < Num))
					{
						Num = Info.ItemNum;
					}
					(Info.ItemNum -= Num);
					if((Info.ItemNum > INT64(0)))
					{
						m_SellBottomListHandle.SetItem(Index, Info);
					}
					else
					{
						m_SellBottomListHandle.DeleteItem(Index);
					}
					topIndex = m_SellTopListHandle.FindItem(cID);
					if(((topIndex >= 0) && IsStackableItem(Info.ConsumeType)))
					{
						m_SellTopListHandle.GetItem(topIndex, topInfo);
						(topInfo.ItemNum += Num);
						m_SellTopListHandle.SetItem(topIndex, topInfo);
						ModifyItemNumRecord(topIndex, topInfo.ItemNum);
					}
					else
					{
						Info.ItemNum = Num;
						m_SellTopListHandle.AddItem(Info);
						topRichListCtrl.InsertRecord(makeRecord(Info));
					}
					if((Info.ItemNum <= INT64(0)))
					{
						Num = (Info.ItemNum + Num);
					}
					AddPrice((-Num * Info.Price));
					Class'NWindow.UIAPI_INVENWEIGHT'.static.AddWeight((m_Windowname $ ".InvenWeight"), (INT64(Info.Weight) * Num));
				}
				else if((int(m_shopType) == 3))
				{
					m_PreviewBottomListHandle.GetItem(Index, Info);
					(Info.ItemNum -= Num);
					if((Info.ItemNum > INT64(0)))
					{
						m_PreviewBottomListHandle.SetItem(Index, Info);
					}
					else
					{
						m_PreviewBottomListHandle.DeleteItem(Index);
					}
					if((Info.ItemNum <= INT64(0)))
					{
						Num = (Info.ItemNum + Num);
					}
					AddPrice((-Num * Info.Price));
				}
			}
		}
		else if((Id == 333))
		{
			Num = INT64(m_PreviewBottomListHandle.GetItemNum());
			if((Num > INT64(0)))
			{
				ParamAdd(param, "merchant", string(m_merchantID));
				ParamAdd(param, "npc", string(m_npcID));
				ParamAdd(param, "num", string(Num));
				Index = 0;
				while((INT64(Index) < Num))
				{
					m_PreviewBottomListHandle.GetItem(Index, Info);
					ParamAddItemIDWithIndex(param, Info.Id, Index);
					++Index;
				}
				RequestPreviewItem(param);
				HideWindow(m_Windowname);
			}
		}
		UpdateItemCount();
	}
	return;
}

function HandleEndTransactionList(string param)
{
	local int WindowOpenType;

	ParseInt(param, "type", WindowOpenType);
	if((int(m_LastShopType) == 2))
	{
		m_TransactionTabHandle.SetTopOrder(1, false);
		ClearPriceWeightInfo();
		ClearBottomBuyList();
		SwapShopType(ShopSell);
	}
	else if((int(m_LastShopType) == 4))
	{
		m_TransactionTabHandle.SetTopOrder(2, false);
		ClearPriceWeightInfo();
		ClearBottomBuyList();
		SwapShopType(ShopRefund);
	}
	else
	{
		SwapShopType(ShopBuy);
	}
	if((WindowOpenType == 0))
	{
		m_TransactionTabHandle.SetTopOrder(0, false);
		ClearPriceWeightInfo();
		ClearBottomBuyList();
		SwapShopType(ShopBuy);
	}
	else if((WindowOpenType == 2))
	{
		DialogShow(DialogModalType_Modal, DialogType_OK, GetSystemMessage(279));
		Class'Interface.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
		Class'Interface.DialogBox'.static.Inst().DelegateOnCancel = HandleDialogCancel;
		m_isCompleteTransaction = false;
	}
	else if((WindowOpenType == 3))
	{
		DialogShow(DialogModalType_Modal, DialogType_OK, GetSystemMessage(352));
		Class'Interface.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
		Class'Interface.DialogBox'.static.Inst().DelegateOnCancel = HandleDialogCancel;
		m_isCompleteTransaction = false;
	}
	else if(((WindowOpenType == 1) && m_isCompleteTransaction))
	{
		AddSystemMessage(3092);
		m_isCompleteTransaction = false;
		HideWindow(m_Windowname);
	}
	else
	{
		m_isCompleteTransaction = false;
	}
	return;
}

function HandleSetMaxCount(string param)
{
	ParseInt(param, "Inventory", m_maxInventoryCount);
	return;
}

function HandleOnAddCastleTaxRateList(string param)
{
	local int i, totalTax;
	local taxInfoByCastle taxInfo;
	local CustomTooltip mCustomTooltip;

	ParseInt(param, "CastleID", taxInfo.castleID);
	ParseInt(param, "taxRate", taxInfo.taxRate);
	taxInfos.Length = (taxInfos.Length + 1);
	taxInfos[(taxInfos.Length - 1)] = taxInfo;
	i = 0;
	while((i < taxInfos.Length))
	{
		totalTax = (totalTax + taxInfos[i].taxRate);
		i++;
	}
	m_TaxText.SetText((string(totalTax) $ "%"));
	mCustomTooltip = TaxInfoTooltip();
	m_TaxText.SetTooltipCustomType(mCustomTooltip);
	m_TaxConstText.SetTooltipCustomType(mCustomTooltip);
	return;
}

function SwapShopType(ShopType Type)
{
	if((int(m_shopType) == int(Type)))
	{
		return;
	}
	m_shopType = Type;
	ClearPriceWeightInfo();
	m_TexBuySellSlotBG.HideWindow();
	m_TexPreviewSlotBG.HideWindow();
	m_TexRefundSlotBG.HideWindow();
	m_BuyTopListHandle.HideWindow();
	m_SellTopListHandle.HideWindow();
	m_RefundTopListHandle.HideWindow();
	m_BuyBottomListHandle.HideWindow();
	m_SellBottomListHandle.HideWindow();
	m_RefundBottomListHandle.HideWindow();
	m_TexTransactionBGLine.ShowWindow();
	m_TexPreviewBGLine.HideWindow();
	m_TransactionTabHandle.ShowWindow();
	m_PreviewTabHandle.HideWindow();
	m_PreviewTopListHandle.HideWindow();
	m_PreviewBottomListHandle.HideWindow();
	switch(Type)
	{
		case ShopBuy:
			m_BuyTopListHandle.ShowWindow();
			ClearBottomBuyList();
			m_TexBuySellSlotBG.ShowWindow();
			m_BuyBottomListHandle.ShowWindow();
			m_TopTextBoxHandle.SetText(GetSystemString(2323));
			m_BottomTextBoxHandle.SetText(GetSystemString(139));
			m_PriceConstTextBoxHandle.SetText(GetSystemString(142));
			m_OkButtonHandle.SetNameText(GetSystemString(1434));
			topRichListCtrl.SetTooltipType("InventoryPrice1HideEnchantStackable");
			break;
		case ShopSell:
			m_SellTopListHandle.ShowWindow();
			ClearBottomSellList();
			m_TexBuySellSlotBG.ShowWindow();
			m_SellBottomListHandle.ShowWindow();
			m_TopTextBoxHandle.SetText(GetSystemString(138));
			m_BottomTextBoxHandle.SetText(GetSystemString(137));
			m_PriceConstTextBoxHandle.SetText(GetSystemString(143));
			m_OkButtonHandle.SetNameText(GetSystemString(1157));
			topRichListCtrl.SetTooltipType("InventoryPrice2");
			break;
		case ShopRefund:
			m_RefundTopListHandle.ShowWindow();
			ClearBottomRefundList();
			m_TexRefundSlotBG.ShowWindow();
			m_RefundBottomListHandle.ShowWindow();
			m_TopTextBoxHandle.SetText(GetSystemString(2324));
			m_BottomTextBoxHandle.SetText(GetSystemString(2205));
			m_PriceConstTextBoxHandle.SetText(GetSystemString(2206));
			m_OkButtonHandle.SetNameText(GetSystemString(2028));
			topRichListCtrl.SetTooltipType("InventoryPrice1");
			break;
		case ShopPreview:
			m_PreviewTopListHandle.ShowWindow();
			m_TexPreviewSlotBG.ShowWindow();
			m_TexTransactionBGLine.HideWindow();
			m_TexPreviewBGLine.ShowWindow();
			m_TransactionTabHandle.HideWindow();
			m_PreviewTabHandle.ShowWindow();
			m_PreviewBottomListHandle.ShowWindow();
			m_TopTextBoxHandle.SetText(GetSystemString(2323));
			m_BottomTextBoxHandle.SetText(GetSystemString(812));
			m_PriceConstTextBoxHandle.SetText(GetSystemString(813));
			m_OkButtonHandle.SetNameText(GetSystemString(1337));
			break;
		default:
			break;
	}
	topRichListCtrl.DeleteAllItem();
	SetListItems();
	UpdateItemCount();
	m_shopType = Type;
	FocusToList();
	return;
}

function ClearBottomBuyList()
{
	local int Index, bottomIndex;
	local ItemInfo deleteItemInfo;

	bottomIndex = m_BuyBottomListHandle.GetItemNum();
	if((bottomIndex != 0))
	{
		Index = 0;
		while((Index < bottomIndex))
		{
			m_BuyBottomListHandle.GetItem(Index, deleteItemInfo);
			++Index;
		}
	}
	getInstanceL2Util().SortItem(m_SellTopListHandle);
	m_BuyBottomListHandle.Clear();
	return;
}

function ClearBottomSellList()
{
	local int Index, bottomIndex, topIndex;
	local ItemInfo deleteItemInfo, addItemInfo;

	bottomIndex = m_SellBottomListHandle.GetItemNum();
	if((bottomIndex != 0))
	{
		Index = 0;
		while((Index < bottomIndex))
		{
			m_SellBottomListHandle.GetItem(Index, deleteItemInfo);
			if(IsStackableItem(deleteItemInfo.ConsumeType))
			{
				topIndex = m_SellTopListHandle.FindItem(deleteItemInfo.Id);
				m_SellTopListHandle.GetItem(topIndex, addItemInfo);
				if((topIndex >= 0))
				{
					(addItemInfo.ItemNum += deleteItemInfo.ItemNum);
					m_SellTopListHandle.SetItem(topIndex, addItemInfo);
				}
				else
				{
					m_SellTopListHandle.AddItem(deleteItemInfo);
				}
				++Index;
				continue;
			}
			m_SellTopListHandle.AddItem(deleteItemInfo);
			++Index;
		}
	}
	m_SellBottomListHandle.Clear();
	return;
}

function ClearBottomRefundList()
{
	local int Index, bottomIndex;
	local ItemInfo deleteItemInfo;

	bottomIndex = m_RefundBottomListHandle.GetItemNum();
	if((bottomIndex != 0))
	{
		Index = 0;
		while((Index < bottomIndex))
		{
			m_RefundBottomListHandle.GetItem(Index, deleteItemInfo);
			m_RefundTopListHandle.AddItem(deleteItemInfo);
			++Index;
		}
	}
	m_RefundBottomListHandle.Clear();
	return;
}

function ClearPriceWeightInfo()
{
	m_currentPrice = INT64(0);
	m_PriceTextBoxHandle.SetText("0");
	m_PriceTextBoxHandle.SetTooltipString("");
	Class'NWindow.UIAPI_INVENWEIGHT'.static.ZeroWeight((m_Windowname $ ".InvenWeight"));
	return;
}

function Clear()
{
	m_shopType = ShopNone;
	m_merchantID = -1;
	m_npcID = -1;
	topRichListCtrl.DeleteAllItem();
	m_BuyTopListHandle.Clear();
	m_SellTopListHandle.Clear();
	m_RefundTopListHandle.Clear();
	m_BuyBottomListHandle.Clear();
	m_SellBottomListHandle.Clear();
	m_RefundBottomListHandle.Clear();
	m_PreviewTopListHandle.Clear();
	m_PreviewBottomListHandle.Clear();
	ClearPriceWeightInfo();
	m_AdenaTextBoxHandle.SetText("0");
	m_AdenaTextBoxHandle.SetTooltipString("");
	m_TransactionTabHandle.InitTabCtrl();
	taxInfos.Length = 0;
	return;
}

function SwapList()
{
	if(m_SwapItemBtn.IsShowWindow())
	{
		m_SwapItemBtn.HideWindow();
		m_SwapListBtn.ShowWindow();
		listWnd.ShowWindow();
		topRichListCtrl.SetFocus();
		isListView = true;
	}
	else
	{
		m_SwapItemBtn.ShowWindow();
		m_SwapListBtn.HideWindow();
		listWnd.HideWindow();
		GetCurrentTopListHandle().SetFocus();
		isListView = false;
	}
	return;
}

function SetListItems()
{
	local int i;
	local ItemWindowHandle tmpItemHandle;
	local ItemInfo iInfo;

	topRichListCtrl.DeleteAllItem();
	switch(m_shopType)
	{
		case ShopBuy:
			tmpItemHandle = m_BuyTopListHandle;
			break;
		case ShopSell:
			tmpItemHandle = m_SellTopListHandle;
			break;
		case ShopRefund:
			tmpItemHandle = m_RefundTopListHandle;
			break;
		case ShopPreview:
			tmpItemHandle = m_PreviewTopListHandle;
			break;
		default:
			break;
	}
	i = 0;
	while((i < tmpItemHandle.GetItemNum()))
	{
		tmpItemHandle.GetItem(i, iInfo);
		topRichListCtrl.InsertRecord(makeRecord(iInfo));
		i++;
	}
	return;
}

function int FindRecordIndex(ItemInfo iInfo, out RichListCtrlRowData Record)
{
	local int Count, i;
	local RichListCtrlRowData rec;

	Count = topRichListCtrl.GetRecordCount();
	i = 0;
	while((i < Count))
	{
		topRichListCtrl.GetRec(i, rec);
		if((rec.nReserved1 == INT64(iInfo.Id.ClassID)))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function RichListCtrlRowData makeRecord(ItemInfo iInfo)
{
	local RichListCtrlRowData Record;
	local string toolTipParam, strAdena, strAdenaComma;
	local Color AdenaColor;
	local string ItemName, AdditionalName, allName;
	local int wMax, additionalY;

	if((iInfo.ItemNum == INT64(0)))
	{
		iInfo.ItemNum = INT64(1);
	}
	Record.cellDataList.Length = 1;
	ItemInfoToParam(iInfo, toolTipParam);
	Record.szReserved = toolTipParam;
	Record.nReserved1 = INT64(iInfo.Id.ClassID);
	Record.nReserved2 = iInfo.ItemNum;
	AddRichListCtrlItem(Record.cellDataList[0].drawitems, iInfo, 0, 0, 3, -1);
	ItemName = GetItemNameAll(iInfo, true);
	AdditionalName = iInfo.AdditionalName;
	wMax = 170;
	allName = ItemName;
	additionalY = 4;
	if((AdditionalName != ""))
	{
		allName = ((allName @ "") @ AdditionalName);
		additionalY = 0;
	}
	Class'Interface.L2Util'.static.GetEllipsisString(allName, wMax);
	AddRichListCtrlString(Record.cellDataList[0].drawitems, Left(allName, Len(ItemName)), getInstanceL2Util().BrightWhite, false, 3, 3);
	AddRichListCtrlString(Record.cellDataList[0].drawitems, Right(allName, (Len(allName) - Len(ItemName))), getInstanceL2Util().Yellow03, false, 0, additionalY);
	strAdena = string(iInfo.Price);
	strAdenaComma = MakeCostString(strAdena);
	AdenaColor = GetNumericColor(strAdenaComma);
	switch(m_shopType)
	{
		case ShopBuy:
			AddRichListCtrlString(Record.cellDataList[0].drawitems, "", AdenaColor, true, 37, 1);
			addRichListCtrlTexture(Record.cellDataList[0].drawitems, "L2UI_CT1.Icon.Icon_DF_Common_Adena", 16, 12);
			AddRichListCtrlString(Record.cellDataList[0].drawitems, strAdenaComma, AdenaColor, false, 3);
			break;
		case ShopSell:
			AddRichListCtrlString(Record.cellDataList[0].drawitems, ("x" $ string(Record.nReserved2)), getInstanceL2Util().ColorGold, true, 39, 1);
			break;
		case ShopRefund:
			AddRichListCtrlString(Record.cellDataList[0].drawitems, ("x" $ string(Record.nReserved2)), getInstanceL2Util().ColorGold, true, 39, 1);
			break;
		case ShopPreview:
			break;
		default:
			break;
	}
	Record.ForceRefreshTooltip = true;
	return Record;
}

function ModifyItemNumRecord(int Index, INT64 ItemNum)
{
	local ItemInfo iInfo;
	local RichListCtrlRowData rec;
	local string toolTipParam;

	topRichListCtrl.GetRec(Index, rec);
	ParamToItemInfo(rec.szReserved, iInfo);
	iInfo.ItemNum = ItemNum;
	ItemInfoToParam(iInfo, toolTipParam);
	rec.szReserved = toolTipParam;
	rec.nReserved2 = ItemNum;
	rec.cellDataList[0].drawitems[0].ItemInfo.ItemInfo = iInfo;
	rec.cellDataList[0].drawitems[3].strInfo.strData = ("x" $ string(ItemNum));
	topRichListCtrl.ModifyRecord(Index, rec);
	return;
}

function HandleOKButton()
{
	local string param;
	local int topCount, bottomCount, topIndex, bottomIndex;
	local ItemInfo topInfo, bottomInfo;
	local INT64 limitedItemCount;

	if(m_isCompleteTransaction)
	{
		return;
	}
	m_LastShopType = m_shopType;
	if((int(m_shopType) == 1))
	{
		topCount = m_BuyTopListHandle.GetItemNum();
		topIndex = 0;
		while((topIndex < topCount))
		{
			m_BuyTopListHandle.GetItem(topIndex, topInfo);
			if((topInfo.ItemNum > INT64(0)))
			{
				limitedItemCount = INT64(0);
				bottomCount = m_BuyBottomListHandle.GetItemNum();
				bottomIndex = 0;
				while((bottomIndex < bottomCount))
				{
					m_BuyBottomListHandle.GetItem(bottomIndex, bottomInfo);
					if(IsSameClassID(bottomInfo.Id, topInfo.Id))
					{
						(limitedItemCount += bottomInfo.ItemNum);
					}
					++bottomIndex;
				}
				if((limitedItemCount > topInfo.ItemNum))
				{
					DialogShow(DialogModalType_Modalless, DialogType_Warning, GetSystemMessage(1338));
					Class'Interface.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
					Class'Interface.DialogBox'.static.Inst().DelegateOnCancel = HandleDialogCancel;
					return;
				}
			}
			++topIndex;
		}
		if((m_currentPrice > m_UserAdena))
		{
			DialogShow(DialogModalType_Modal, DialogType_OK, GetSystemMessage(279));
			Class'Interface.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
			Class'Interface.DialogBox'.static.Inst().DelegateOnCancel = HandleDialogCancel;
			m_isCompleteTransaction = false;
			return;
		}
	}
	if((int(m_shopType) == 1))
	{
		bottomCount = m_BuyBottomListHandle.GetItemNum();
		if((bottomCount > 0))
		{
			ParamAdd(param, "merchant", string(m_merchantID));
			ParamAdd(param, "num", string(bottomCount));
			bottomIndex = 0;
			while((bottomIndex < bottomCount))
			{
				m_BuyBottomListHandle.GetItem(bottomIndex, bottomInfo);
				ParamAdd(param, ("ClassID_" $ string(bottomIndex)), string(bottomInfo.Id.ClassID));
				ParamAdd(param, ("Count_" $ string(bottomIndex)), string(bottomInfo.ItemNum));
				++bottomIndex;
			}
			RequestBuyItem(param);
			m_isCompleteTransaction = true;
		}
	}
	else if((int(m_shopType) == 2))
	{
		bottomCount = m_SellBottomListHandle.GetItemNum();
		if((bottomCount > 0))
		{
			ParamAdd(param, "merchant", string(m_merchantID));
			ParamAdd(param, "num", string(bottomCount));
			bottomIndex = 0;
			while((bottomIndex < bottomCount))
			{
				m_SellBottomListHandle.GetItem(bottomIndex, bottomInfo);
				ParamAddItemIDWithIndex(param, bottomInfo.Id, bottomIndex);
				ParamAdd(param, ("Count_" $ string(bottomIndex)), string(bottomInfo.ItemNum));
				++bottomIndex;
			}
			RequestSellItem(param);
			m_isCompleteTransaction = true;
		}
	}
	else if((int(m_shopType) == 4))
	{
		bottomCount = m_RefundBottomListHandle.GetItemNum();
		if((bottomCount > 0))
		{
			ParamAdd(param, "merchant", string(m_merchantID));
			ParamAdd(param, "num", string(bottomCount));
			bottomIndex = 0;
			while((bottomIndex < bottomCount))
			{
				m_RefundBottomListHandle.GetItem(bottomIndex, bottomInfo);
				ParamAdd(param, ("index_" $ string(bottomIndex)), string(bottomInfo.Id.ServerID));
				++bottomIndex;
			}
			if((m_currentPrice > m_UserAdena))
			{
				DialogShow(DialogModalType_Modal, DialogType_OK, GetSystemMessage(279));
				Class'Interface.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
				Class'Interface.DialogBox'.static.Inst().DelegateOnCancel = HandleDialogCancel;
				m_isCompleteTransaction = false;
				return;
			}
			RequestRefundItem(param);
			m_isCompleteTransaction = true;
		}
	}
	else if((int(m_shopType) == 3))
	{
		bottomCount = m_PreviewBottomListHandle.GetItemNum();
		if((bottomCount > 0))
		{
			DialogSetID(333);
			DialogShow(DialogModalType_Modalless, DialogType_Warning, GetSystemMessage(1157));
			Class'Interface.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
		}
	}
	return;
}

function FocusToList()
{
	if(isListView)
	{
		topRichListCtrl.SetFocus();
	}
	else
	{
		GetCurrentTopListHandle().SetFocus();
	}
	m_hOwnerWnd.DisableTick();
	return;
}

function CustomTooltip TaxInfoTooltip()
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;
	local int i, castleNum;

	i = 0;
	while((i < taxInfos.Length))
	{
		castleNum = (i * 2);
		drawListArr[castleNum] = addDrawItemText((GetCastleName(taxInfos[i].castleID) $ " : "), getInstanceL2Util().White, "", true, true);
		drawListArr[(castleNum + 1)] = addDrawItemText((string(taxInfos[i].taxRate) $ "%"), getInstanceL2Util().Yellow, "", false, true);
		i++;
	}
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	return mCustomTooltip;
}

function AddPrice(INT64 Price)
{
	local string Adena;

	m_currentPrice = (m_currentPrice + Price);
	Adena = MakeCostStringINT64(m_currentPrice);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".PriceText"), Adena);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString((m_Windowname $ ".PriceText"), ConvertNumToText(string(m_currentPrice)));
	return;
}

function SetEnableWindow(bool flag)
{
	if(flag)
	{
		Me.EnableWindow();
	}
	else
	{
		Me.DisableWindow();
	}
	return;
}

function UpdateItemCount()
{
	local int iTradeListCount;

	m_numPossibleSlotCount = 0;
	if((int(m_shopType) == 1))
	{
		iTradeListCount = m_BuyBottomListHandle.GetItemNum();
		m_numPossibleSlotCount = (m_maxInventoryCount - m_curInventoryCount);
		m_ShopWndItemCountHandle.SetText((((("(" $ string(iTradeListCount)) $ "/") $ string(m_numPossibleSlotCount)) $ ")"));
	}
	else if((int(m_shopType) == 2))
	{
		iTradeListCount = m_SellBottomListHandle.GetItemNum();
		m_numPossibleSlotCount = (m_maxInventoryCount - m_curInventoryCount);
		m_ShopWndItemCountHandle.SetText((("(" $ string(iTradeListCount)) $ ")"));
	}
	else if((int(m_shopType) == 4))
	{
		iTradeListCount = m_RefundBottomListHandle.GetItemNum();
		m_numPossibleSlotCount = (m_maxInventoryCount - m_curInventoryCount);
		m_ShopWndItemCountHandle.SetText((((("(" $ string(iTradeListCount)) $ "/") $ string(m_numPossibleSlotCount)) $ ")"));
	}
	else if((int(m_shopType) == 3))
	{
		iTradeListCount = m_PreviewBottomListHandle.GetItemNum();
		m_ShopWndItemCountHandle.SetText((("(" $ string(iTradeListCount)) $ ")"));
	}
	return;
}

function ItemWindowHandle GetCurrentTopListHandle()
{
	return GetTopListHandleByShopType(m_shopType);
}

function ItemWindowHandle GetTopListHandleByShopType(ShopType sType)
{
	switch(sType)
	{
		case ShopRefund:
			return m_RefundTopListHandle;
		case ShopPreview:
			return m_PreviewTopListHandle;
		case ShopSell:
			return m_SellTopListHandle;
		case ShopBuy:
			return m_BuyTopListHandle;
		default:
			return none;
	}
}

function ItemWindowHandle GetBottomListHandleByShopType(ShopType sType)
{
	switch(sType)
	{
		case ShopRefund:
			return m_RefundBottomListHandle;
		case ShopPreview:
			return m_PreviewBottomListHandle;
		case ShopSell:
			return m_SellBottomListHandle;
		case ShopBuy:
			return m_BuyBottomListHandle;
		default:
			return none;
	}
}

function ItemWindowHandle GetCurrentBottomListHandle()
{
	return GetBottomListHandleByShopType(m_shopType);
}

function int FindMatchString(string targetString, string toFindString)
{
	local string delim;

	if((toFindString == ""))
	{
		return 1;
	}
	delim = " ";
	if(StringMatching(targetString, toFindString, delim))
	{
		return 1;
	}
	else
	{
		return -1;
	}
	return 1;
}

function ShopType ToShopType(int i)
{
	switch(i)
	{
		case 0:
			return ShopNone;
		case 1:
			return ShopBuy;
		case 2:
			return ShopSell;
		case 3:
			return ShopPreview;
		case 4:
			return ShopRefund;
		default:
			return ShopNone;
	}
}

function int FindItemIndexTop(ItemID cID)
{
	switch(m_shopType)
	{
		case ShopBuy:
			return m_BuyTopListHandle.FindItem(cID);
		case ShopSell:
			return m_SellTopListHandle.FindItem(cID);
		case ShopRefund:
			return m_RefundTopListHandle.FindItem(cID);
		case ShopPreview:
			return m_PreviewTopListHandle.FindItem(cID);
		default:
			return -1;
	}
}

function int FindItemIndexBot(ItemID cID)
{
	switch(m_shopType)
	{
		case ShopBuy:
			return m_BuyBottomListHandle.FindItem(cID);
		case ShopSell:
			return m_SellBottomListHandle.FindItem(cID);
		case ShopRefund:
			return m_RefundBottomListHandle.FindItem(cID);
		case ShopPreview:
			return m_PreviewBottomListHandle.FindItem(cID);
		default:
			return -1;
	}
}

function TYPE_DIR GetDir(string dropTarget, ItemInfo iInfo)
{
	if((((dropTarget == "topRichListCtrl") || (dropTarget == "BuyTopList")) && (iInfo.DragSrcName == "BuyBottomList")))
	{
		return toTop;
	}
	if((((dropTarget == "topRichListCtrl") || (dropTarget == "SellTopList")) && (iInfo.DragSrcName == "SellBottomList")))
	{
		return toTop;
	}
	if((((dropTarget == "topRichListCtrl") || (dropTarget == "RefundTopList")) && (iInfo.DragSrcName == "RefundBottomList")))
	{
		return toTop;
	}
	if((((dropTarget == "topRichListCtrl") || (dropTarget == "PreviewTopList")) && (iInfo.DragSrcName == "PreviewBottomList")))
	{
		return toTop;
	}
	if((((iInfo.DragSrcName == "topRichListCtrl") || (iInfo.DragSrcName == "BuyTopList")) && (dropTarget == "BuyBottomList")))
	{
		return toBottom;
	}
	if((((iInfo.DragSrcName == "topRichListCtrl") || (iInfo.DragSrcName == "SellTopList")) && (dropTarget == "SellBottomList")))
	{
		return toBottom;
	}
	if((((iInfo.DragSrcName == "topRichListCtrl") || (iInfo.DragSrcName == "RefundTopList")) && (dropTarget == "RefundBottomList")))
	{
		return toBottom;
	}
	if((((iInfo.DragSrcName == "topRichListCtrl") || (iInfo.DragSrcName == "PreviewTopList")) && (dropTarget == "PreviewBottomList")))
	{
		return toBottom;
	}
	return non;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="ShopWnd"
}
