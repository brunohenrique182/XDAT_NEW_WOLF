class GiftInventoryWnd extends UICommonAPI
	dependson(UIPacket);

var WindowHandle Me;
var WindowHandle GiftInventoryConfirmWnd;
var TextureHandle Result_ItemWnd;
var TextBoxHandle ItemName_TextBox;
var TextBoxHandle Discription_TextBox;
var ButtonHandle OK_Button;
var ButtonHandle Cancel_Button;
var AnimTextureHandle RecieveBtnAni;
var TextureHandle GiftTabNew_tex;
var ButtonHandle HelpHtmlBtn;
var WindowHandle DisableWndList;
var TextBoxHandle GiftInventory_Empty;
var WindowHandle DisableWndAll;
var ButtonHandle ProductTab_Btn;
var ButtonHandle GiftTab_Btn;
var TextureHandle GiftInventory_Divider2;
var TextBoxHandle GiftItemListTitle;
var TextBoxHandle GiftItemListTotal;
var RichListCtrlHandle GiftItemList_Lc;
var TextBoxHandle GiftItemDetailInfoTitle;
var TextBoxHandle GiftBuyInfo;
var TextureHandle GiftItem_Msg;
var TextureHandle GiftItem;
var TextureHandle GiftItemSlotBg;
var TextBoxHandle GiftItemText;
var HtmlHandle GiftItemDiscription;
var TextBoxHandle GiftItemDetailListTitle;
var TextBoxHandle GiftItemDetailListCounter;
var TextBoxHandle GiftItemDesc_txt;
var RichListCtrlHandle GiftItemDetailListTitle_Lc;
var ButtonHandle RecieveBtn;
var ButtonHandle RefuseBtn;
var ButtonHandle CloseBtn;
var L2Util util;
var L2UITween l2UITweenScript;
var bool bReceiveAsk;
var int selectedProductListIndex;
var array<UIPacket._SGiftInfo> giftGoodsItemArray;
//var delegate<SortByRemainTimeSec> __SortByRemainTimeSec__Delegate;

function OnRegisterEvent()
{
	RegisterEvent((100000 + 1054));
	RegisterEvent((100000 + 1055));
	RegisterEvent((100000 + 1056));
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
	Me = GetWindowHandle("GiftInventoryWnd");
	GiftInventoryConfirmWnd = GetWindowHandle("GiftInventoryWnd.GiftInventoryConfirmWnd");
	Result_ItemWnd = GetTextureHandle("GiftInventoryWnd.GiftInventoryConfirmWnd.Result_ItemWnd");
	ItemName_TextBox = GetTextBoxHandle("GiftInventoryWnd.GiftInventoryConfirmWnd.ItemName_TextBox");
	Discription_TextBox = GetTextBoxHandle("GiftInventoryWnd.GiftInventoryConfirmWnd.Discription_TextBox");
	OK_Button = GetButtonHandle("GiftInventoryWnd.GiftInventoryConfirmWnd.OK_Button");
	Cancel_Button = GetButtonHandle("GiftInventoryWnd.GiftInventoryConfirmWnd.Cancel_Button");
	RecieveBtnAni = GetAnimTextureHandle("GiftInventoryWnd.RecieveBtnAni");
	GiftTabNew_tex = GetTextureHandle("GiftInventoryWnd.GiftTabNew_tex");
	HelpHtmlBtn = GetButtonHandle("GiftInventoryWnd.HelpHtmlBtn");
	DisableWndList = GetWindowHandle("GiftInventoryWnd.DisableWndList");
	GiftInventory_Empty = GetTextBoxHandle("GiftInventoryWnd.DisableWndList.GiftInventory_Empty");
	DisableWndAll = GetWindowHandle("GiftInventoryWnd.DisableWndAll");
	ProductTab_Btn = GetButtonHandle("GiftInventoryWnd.ProductTab_Btn");
	GiftTab_Btn = GetButtonHandle("GiftInventoryWnd.GiftTab_Btn");
	GiftItemListTitle = GetTextBoxHandle("GiftInventoryWnd.GiftItemListTitle");
	GiftItemListTotal = GetTextBoxHandle("GiftInventoryWnd.GiftItemListTotal");
	GiftItemList_Lc = GetRichListCtrlHandle("GiftInventoryWnd.GiftItemList_Lc");
	GiftItemDetailInfoTitle = GetTextBoxHandle("GiftInventoryWnd.GiftItemDetailInfoTitle");
	GiftBuyInfo = GetTextBoxHandle("GiftInventoryWnd.GiftBuyInfo");
	GiftItem_Msg = GetTextureHandle("GiftInventoryWnd.GiftItem_Msg");
	GiftItem = GetTextureHandle("GiftInventoryWnd.GiftItem");
	GiftItemText = GetTextBoxHandle("GiftInventoryWnd.GiftItemText");
	GiftItemDiscription = GetHtmlHandle("GiftInventoryWnd.GiftItemDiscription");
	GiftItemDetailListTitle = GetTextBoxHandle("GiftInventoryWnd.GiftItemDetailListTitle");
	GiftItemDetailListCounter = GetTextBoxHandle("GiftInventoryWnd.GiftItemDetailListCounter");
	GiftItemDesc_txt = GetTextBoxHandle("GiftInventoryWnd.GiftItemDesc_txt");
	GiftItemDetailListTitle_Lc = GetRichListCtrlHandle("GiftInventoryWnd.GiftItemDetailListTitle_Lc");
	RecieveBtn = GetButtonHandle("GiftInventoryWnd.RecieveBtn");
	RefuseBtn = GetButtonHandle("GiftInventoryWnd.RefuseBtn");
	CloseBtn = GetButtonHandle("GiftInventoryWnd.CloseBtn");
	return;
}

function Load()
{
	util = L2Util(GetScript("L2Util"));
	l2UITweenScript = L2UITween(GetScript("l2UITween"));
	GiftItemList_Lc.SetSelectedSelTooltip(false);
	GiftItemList_Lc.SetAppearTooltipAtMouseX(true);
	GiftItemDetailListTitle_Lc.SetSelectedSelTooltip(false);
	GiftItemDetailListTitle_Lc.SetAppearTooltipAtMouseX(true);
	selectedProductListIndex = -1;
	return;
}

function refresh()
{
	GiftTabNew_tex.HideWindow();
	setItemDesc(0, "", "");
	GiftItemList_Lc.DeleteAllItem();
	GiftItemDetailListTitle_Lc.DeleteAllItem();
	askRecieve(false);
	askConfirm(false);
	API_C_EX_GOODS_GIFT_LIST_INFO();
	return;
}

function OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	refresh();
	return;
}

function OnHide()
{
	askRecieve(false);
	askConfirm(false);
	selectedProductListIndex = -1;
	return;
}

function OnClickListCtrlRecord(string strID)
{
	local int idx, i, Size, nClassID, nCount;
	local RichListCtrlRowData rowData;

	if((strID == "GiftItemList_Lc"))
	{
		idx = GiftItemList_Lc.GetSelectedIndex();
		GiftItemList_Lc.GetRec(idx, rowData);
		setItemDesc(int(rowData.nReserved2), rowData.cellDataList[1].HiddenStringForSorting, rowData.cellDataList[1].szReserved);
		ParseInt(rowData.szReserved, "size", Size);
		GiftItemDetailListTitle_Lc.DeleteAllItem();
		i = 0;
		while((i < Size))
		{
			ParseInt(rowData.szReserved, ("nClassId_" $ string(i)), nClassID);
			ParseInt(rowData.szReserved, ("nCount_" $ string(i)), nCount);
			addProductBoxInsideItemList(GetItemID(nClassID), GetItemInfoByClassID(nClassID).Name, nClassID, nCount);
			i++;
		}
		selectedProductListIndex = idx;
		askRecieve(true);
	}
	return;
}

function askRecieve(bool bShow)
{
	local int idx;

	if(bShow)
	{
		idx = GiftItemList_Lc.GetSelectedIndex();
		if((idx <= -1))
		{
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(326));
			return;
		}
		GiftItemDesc_txt.ShowWindow();
		RecieveBtn.ShowWindow();
		RefuseBtn.ShowWindow();
	}
	else
	{
		GiftItemDesc_txt.HideWindow();
		RecieveBtn.HideWindow();
		RefuseBtn.HideWindow();
		RecieveBtnAni.HideWindow();
	}
	return;
}

function askConfirm(bool bShow, optional bool bReceive)
{
	local RichListCtrlRowData rowData;
	local int idx;

	if(bShow)
	{
		idx = GiftItemList_Lc.GetSelectedIndex();
		if((idx <= -1))
		{
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(326));
			return;
		}
		DisableWndAll.ShowWindow();
		DisableWndAll.SetFocus();
		GiftInventoryConfirmWnd.ShowWindow();
		GiftInventoryConfirmWnd.SetFocus();
		bReceiveAsk = bReceive;
		if(bReceive)
		{
			Discription_TextBox.SetText(GetSystemMessage(13732));
		}
		else
		{
			Discription_TextBox.SetText(GetSystemMessage(13733));
		}
		GiftItemList_Lc.GetSelectedRec(rowData);
		ItemName_TextBox.SetText(rowData.cellDataList[1].HiddenStringForSorting);
		Result_ItemWnd.SetTexture(GetGoodsIconName(int(rowData.nReserved2)));
	}
	else
	{
		DisableWndAll.HideWindow();
		GiftInventoryConfirmWnd.HideWindow();
	}
	return;
}

function setItemDesc(int goodsIconID, string goodsName, string goodsDesc)
{
	if((goodsIconID == 0))
	{
		GiftItem.SetTexture("");
	}
	else
	{
		GiftItem.SetTexture(GetGoodsIconName(goodsIconID));
	}
	GiftItemText.SetText(goodsName);
	GiftItemDiscription.LoadHtmlFromString(htmlSetHtmlStart(htmlAddText(goodsDesc, "GameDefault", "afb9cd")));
	return;
}

function addProductItemList(INT64 nPurchaseId, INT64 nGoodsDeliveryRequestId, int nCount, int nIconId, string giftName, string senderName, string giftDesc, int nRemainTimeSec, string itemListParam)
{
	local RichListCtrlRowData rowData;

	rowData.cellDataList.Length = 3;
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, senderName, GTColor().White, false, 2, 4);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, (((giftName $ " (") $ string(nCount)) $ ")"), GTColor().White, false, 2, 4);
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, util.getTimeStringBySec3(nRemainTimeSec), GTColor().White, false, 0, 4);
	rowData.cellDataList[0].HiddenStringForSorting = senderName;
	rowData.cellDataList[1].HiddenStringForSorting = giftName;
	rowData.cellDataList[2].HiddenStringForSorting = util.makeZeroString(10, INT64(nRemainTimeSec));
	rowData.cellDataList[1].szReserved = giftDesc;
	rowData.szReserved = itemListParam;
	rowData.nReserved1 = nPurchaseId;
	rowData.nReserved2 = INT64(nIconId);
	rowData.nReserved3 = nGoodsDeliveryRequestId;
	GiftItemList_Lc.InsertRecord(rowData);
	return;
}

function addProductBoxInsideItemList(ItemID cID, string goodsName, int gameItemClassID, int ItemNum)
{
	local RichListCtrlRowData rowData;
	local ItemInfo tmItemInfo;

	rowData.cellDataList.Length = 1;
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems, Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(cID), 32, 32, 5);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, (((goodsName $ " (") $ string(ItemNum)) $ ")"), GTColor().White, false, 5, 10);
	tmItemInfo = GetItemInfoByClassID(gameItemClassID);
	if((ItemNum > 0))
	{
		tmItemInfo.ItemNum = INT64(ItemNum);
	}
	ItemInfoToParam(tmItemInfo, rowData.szReserved);
	GiftItemDetailListTitle_Lc.InsertRecord(rowData);
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "OK_Button":
			OnOK_ButtonClick();
			break;
		case "Cancel_Button":
			OnCancel_ButtonClick();
			break;
		case "ProductTab_Btn":
			OnProductTab_BtnClick();
			break;
		case "RecieveBtn":
			OnRecieveBtnClick();
			break;
		case "RefuseBtn":
			OnRefuseBtnClick();
			break;
		case "CloseBtn":
			OnCloseBtnClick();
			break;
		default:
			break;
	}
	return;
}

function OnOK_ButtonClick()
{
	local RichListCtrlRowData rowData;

	GiftItemList_Lc.GetSelectedRec(rowData);
	if(bReceiveAsk)
	{
		API_C_EX_GOODS_GIFT_ACCEPT(rowData.nReserved1, rowData.nReserved3);
	}
	else
	{
		API_C_EX_GOODS_GIFT_REFUSET(rowData.nReserved1, rowData.nReserved3);
	}
	askConfirm(false);
	return;
}

function OnCancel_ButtonClick()
{
	askConfirm(false);
	return;
}

function OnProductTab_BtnClick()
{
	Me.HideWindow();
	getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "ProductInventoryWnd");
	ShowWindow("ProductInventoryWnd");
	return;
}

function OnRecieveBtnClick()
{
	askConfirm(true, true);
	return;
}

function OnRefuseBtnClick()
{
	askConfirm(true, false);
	return;
}

function OnCloseBtnClick()
{
	Me.HideWindow();
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_PacketID(1054):
			ParsePacket_S_EX_GOODS_GIFT_LIST_INFO();
			break;
		case EV_PacketID(1055):
			ParsePacket_S_EX_GOODS_GIFT_ACCEPT_RESULT();
			break;
		case EV_PacketID(1056):
			ParsePacket_S_EX_GOODS_GIFT_REFUSE_RESULT();
			break;
		default:
			break;
	}
	return;
}

function ParsePacket_S_EX_GOODS_GIFT_LIST_INFO()
{
	local UIPacket._S_EX_GOODS_GIFT_LIST_INFO packet;
	local int i, N;
	local string itemListParam;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_GOODS_GIFT_LIST_INFO(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_GOODS_GIFT_LIST_INFO :  ");
	Debug(("packet.nTotalPage" @ string(packet.nTotalPage)));
	Debug(("packet.nCurrentPage" @ string(packet.nCurrentPage)));
	Debug(("packet.giftList.length" @ string(packet.giftList.Length)));
	Debug(("packet.cResult" @ string(packet.cResult)));
	if(((packet.cResult == 1) || (packet.cResult == 2)))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(184));
		AddSystemMessage(184);
		Me.HideWindow();
		return;
	}
	if((packet.nCurrentPage == 1))
	{
		GiftItemList_Lc.DeleteAllItem();
		giftGoodsItemArray.Length = 0;
	}
	if((((packet.giftList.Length == 0) && (packet.nTotalPage == 1)) && (packet.nCurrentPage == 1)))
	{
		DisableWndList.ShowWindow();
		DisableWndList.SetFocus();
		setItemDesc(0, "", "");
		GiftItemListTotal.SetText(((GetSystemString(2512) $ " : ") $ string(GiftItemList_Lc.GetRecordCount())));
		GiftItemDetailListTitle_Lc.DeleteAllItem();
		askConfirm(false);
		askRecieve(false);
		NoticeWnd(GetScript("NoticeWnd"))._RemoveNoticButtonGift();
		return;
	}
	else
	{
		DisableWndList.HideWindow();
	}
	i = 0;
	while((i < packet.giftList.Length))
	{
		giftGoodsItemArray[giftGoodsItemArray.Length] = packet.giftList[i];
		i++;
	}
	if((packet.nTotalPage == packet.nCurrentPage))
	{
		i = 0;
		while((i < giftGoodsItemArray.Length))
		{
			itemListParam = "";
			ParamAdd(itemListParam, "size", string(giftGoodsItemArray[i].ItemList.Length));
			N = 0;
			while((N < giftGoodsItemArray[i].ItemList.Length))
			{
				ParamAdd(itemListParam, ("nClassId_" $ string(N)), string(giftGoodsItemArray[i].ItemList[N].nClassID));
				ParamAdd(itemListParam, ("nCount_" $ string(N)), string(giftGoodsItemArray[i].ItemList[N].nCount));
				N++;
			}
			addProductItemList(giftGoodsItemArray[i].nPurchaseId, giftGoodsItemArray[i].nGoodsDeliveryRequestId, giftGoodsItemArray[i].nCount, giftGoodsItemArray[i].nIconId, giftGoodsItemArray[i].wstrGiftName, giftGoodsItemArray[i].wstrSenderName, giftGoodsItemArray[i].wstrGiftDesc, giftGoodsItemArray[i].nRemainTimeSec, itemListParam);
			i++;
		}
		if((selectedProductListIndex == -1))
		{
			selectedProductListIndex = 0;
		}
		else if((selectedProductListIndex >= GiftItemList_Lc.GetRecordCount()))
		{
			selectedProductListIndex = (GiftItemList_Lc.GetRecordCount() - 1);
		}
		GiftItemList_Lc.SetSelectedIndex(selectedProductListIndex, true);
		OnClickListCtrlRecord("GiftItemList_Lc");
		GiftItemListTotal.SetText(((GetSystemString(2512) $ " : ") $ string(GiftItemList_Lc.GetRecordCount())));
	}
	return;
}

delegate int SortByRemainTimeSec(UIPacket._SGiftInfo a1, UIPacket._SGiftInfo a2)
{
	if((a1.nRemainTimeSec < a2.nRemainTimeSec))
	{
		return -1;
	}
	return 0;
}

function ParsePacket_S_EX_GOODS_GIFT_ACCEPT_RESULT()
{
	local UIPacket._S_EX_GOODS_GIFT_ACCEPT_RESULT packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_GOODS_GIFT_ACCEPT_RESULT(packet))
	{
		return;
	}
	Debug("--> ParsePacket_S_EX_GOODS_GIFT_ACCEPT_RESULT");
	Debug(("packet.nPurchaseId" @ string(packet.nPurchaseId)));
	Debug(("packet.bSuccess" @ string(packet.bSuccess)));
	if((int(packet.bSuccess) > 0))
	{
		GiftTabNew_tex.ShowWindow();
		l2UITweenScript.StartShake("GiftInventoryWnd.GiftTabNew_tex", 6, 1500, small, 0);
		AddSystemMessage(13746);
	}
	API_C_EX_GOODS_GIFT_LIST_INFO();
	return;
}

function ParsePacket_S_EX_GOODS_GIFT_REFUSE_RESULT()
{
	local UIPacket._S_EX_GOODS_GIFT_REFUSE_RESULT packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_GOODS_GIFT_REFUSE_RESULT(packet))
	{
		return;
	}
	Debug("--> ParsePacket_S_EX_GOODS_GIFT_REFUSE_RESULT");
	Debug(("packet.bSuccess" @ string(packet.bSuccess)));
	Debug(("packet.nPurchaseId" @ string(packet.nPurchaseId)));
	if((int(packet.bSuccess) > 0))
	{
		AddSystemMessage(13734);
	}
	API_C_EX_GOODS_GIFT_LIST_INFO();
	return;
}

function API_C_EX_GOODS_GIFT_LIST_INFO()
{
	local array<byte> stream;

	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(809, stream);
	Debug("API Call --> C_EX_GOODS_GIFT_LIST_INFO");
	return;
}

function API_C_EX_GOODS_GIFT_ACCEPT(INT64 nPurchaseId, INT64 nGoodsDeliveryRequestId)
{
	local array<byte> stream;
	local UIPacket._C_EX_GOODS_GIFT_ACCEPT packet;

	packet.nPurchaseId = nPurchaseId;
	packet.nGoodsDeliveryRequestId = nGoodsDeliveryRequestId;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_GOODS_GIFT_ACCEPT(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(810, stream);
	Debug((("API Call --> C_EX_GOODS_GIFT_ACCEPT " @ string(nPurchaseId)) @ string(nGoodsDeliveryRequestId)));
	return;
}

function API_C_EX_GOODS_GIFT_REFUSET(INT64 nPurchaseId, INT64 nGoodsDeliveryRequestId)
{
	local array<byte> stream;
	local UIPacket._C_EX_GOODS_GIFT_REFUSE packet;

	packet.nPurchaseId = nPurchaseId;
	packet.nGoodsDeliveryRequestId = nGoodsDeliveryRequestId;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_GOODS_GIFT_REFUSE(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(811, stream);
	Debug((("API Call --> C_EX_GOODS_GIFT_REFUSE " @ string(nPurchaseId)) @ string(nGoodsDeliveryRequestId)));
	return;
}

function OnReceivedCloseUI()
{
	if(GiftInventoryConfirmWnd.IsShowWindow())
	{
		askConfirm(false);
	}
	else
	{
		CloseUI();
	}
	return;
}
