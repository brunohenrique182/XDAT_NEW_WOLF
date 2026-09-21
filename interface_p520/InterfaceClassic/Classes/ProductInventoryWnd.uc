class ProductInventoryWnd extends UICommonAPI;

struct GoodsItem
{
	var int goodsType;
	var string goodsName;
	var int goodsCondition;
	var int goodsIconID;
	var int goodsIsGift;
	var int seqID;
	var INT64 goodsID;
	var INT64 goodsDeliveryDate;
	var string goodsIconTexture;
	var string sortingKey;
};

var WindowHandle Me;
var ButtonHandle HelpHtmlBtn;
var TextBoxHandle ProductItemListTitle;
var RichListCtrlHandle ProductItemList_Lc;
var TextBoxHandle ProductItemDetailListTitle;
var TextBoxHandle ProductItemDetailListCounter;
var RichListCtrlHandle ProductItemDetailListTitle_Lc;
var TextureHandle ProductItem;
var TextBoxHandle ProductItemText;
var HtmlHandle ProductItemDiscription;
var ButtonHandle RecieveBtn;
var ButtonHandle CloseBtn;
var AnimTextureHandle ProductItem_Msg;
var AnimTextureHandle RecieveBtnAni;
var WindowHandle ProductInventoryConfirmWnd;
var WindowHandle DisableWndAll;
var WindowHandle DisableWndList;
var TextBoxHandle ProductBuyInfo;
var TextBoxHandle ProductItemListTotal;
var int selectItemNum;
var int selectedGoodsCondition;
var int selectedProductListIndex;
var string selectedProductItemName;
var string selectedProductItemIcon;
var L2Util util;
var array<GoodsItem> GoodsItemArray;
var int lastResultGoodsItemNum;
//var delegate<OnSortCompare> __OnSortCompare__Delegate;
//var delegate<OnSortCompareNoDate> __OnSortCompareNoDate__Delegate;

function OnRegisterEvent()
{
	RegisterEvent(5601);
	RegisterEvent(5604);
	RegisterEvent(5602);
	RegisterEvent(1710);
	RegisterEvent(1720);
	return;
}

function OnShow()
{
	Debug(">> OnShow 상품 인벤토리 열기");  // EN: >> OnShow open product inventory
	PlayConsoleSound(IFST_WINDOW_OPEN);
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	refresh();
	return;
}

function refresh()
{
	initUI();
	if((ProductItemList_Lc.GetRecordCount() > 0))
	{
		ProductItemList_Lc.DeleteAllItem();
	}
	ProductItem_Msg.Stop();
	ProductItem_Msg.HideWindow();
	Debug("OnShow API CALL ---> RequestGoodsInventoryItemList()");
	RequestGoodsInventoryItemList();
	return;
}

function OnHide()
{
	initUI();
	PlayConsoleSound(IFST_WINDOW_CLOSE);
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
	Me = GetWindowHandle("ProductInventoryWnd");
	HelpHtmlBtn = GetButtonHandle("ProductInventoryWnd.HelpHtmlBtn");
	ProductItemListTitle = GetTextBoxHandle("ProductInventoryWnd.ProductItemListTitle");
	ProductItemList_Lc = GetRichListCtrlHandle("ProductInventoryWnd.ProductItemList_Lc");
	ProductItem = GetTextureHandle("ProductInventoryWnd.ProductItem");
	ProductItemText = GetTextBoxHandle("ProductInventoryWnd.ProductItemText");
	ProductItemDiscription = GetHtmlHandle("ProductInventoryWnd.ProductItemDiscription");
	ProductItemDetailListTitle = GetTextBoxHandle("ProductInventoryWnd.ProductItemDetailListTitle");
	ProductItemDetailListCounter = GetTextBoxHandle("ProductInventoryWnd.ProductItemDetailListCounter");
	ProductItemListTotal = GetTextBoxHandle("ProductInventoryWnd.ProductItemListTotal");
	ProductBuyInfo = GetTextBoxHandle("ProductInventoryWnd.ProductBuyInfo");
	ProductItemDetailListTitle_Lc = GetRichListCtrlHandle("ProductInventoryWnd.ProductItemDetailListTitle_Lc");
	RecieveBtn = GetButtonHandle("ProductInventoryWnd.RecieveBtn");
	CloseBtn = GetButtonHandle("ProductInventoryWnd.CloseBtn");
	ProductItem_Msg = GetAnimTextureHandle("ProductInventoryWnd.ProductItem_Msg");
	RecieveBtnAni = GetAnimTextureHandle("ProductInventoryWnd.RecieveBtnAni");
	ProductInventoryConfirmWnd = GetWindowHandle("ProductInventoryWnd.ProductInventoryConfirmWnd");
	DisableWndAll = GetWindowHandle("ProductInventoryWnd.DisableWndAll");
	DisableWndList = GetWindowHandle("ProductInventoryWnd.DisableWndList");
	return;
}

function Load()
{
	util = L2Util(GetScript("L2Util"));
	ProductItemList_Lc.SetSelectedSelTooltip(false);
	ProductItemList_Lc.SetAppearTooltipAtMouseX(true);
	ProductItemDetailListTitle_Lc.SetSelectedSelTooltip(false);
	ProductItemDetailListTitle_Lc.SetAppearTooltipAtMouseX(true);
	return;
}

function initUI()
{
	ShowDisableWnd(false);
	ProductItemList_Lc.DeleteAllItem();
	ProductItemDetailListTitle_Lc.DeleteAllItem();
	ProductItemText.SetText("");
	ProductBuyInfo.SetText("");
	ProductItemDiscription.Clear();
	ProductItemDiscription.HideWindow();
	ProductItem_Msg.Stop();
	ProductItem_Msg.HideWindow();
	ProductItem.HideWindow();
	ProductItemDetailListCounter.SetText("");
	selectedProductItemName = "";
	selectedProductItemIcon = "";
	selectedProductListIndex = -1;
	selectedGoodsCondition = -1;
	lastResultGoodsItemNum = 0;
	RecieveBtn.DisableWindow();
	RecieveBtnAni.Stop();
	RecieveBtnAni.Pause();
	ProductInventoryConfirmWnd.HideWindow();
	ProductItemListTotal.SetText(((GetSystemString(2512) $ " : ") $ "0"));
	return;
}

function OnEvent(int Event_ID, string param)
{
	if(!Me.IsShowWindow())
	{
		return;
	}
	switch(Event_ID)
	{
		case 5601:
			OnGoodsInventoryItemList(param);
			Debug(("--- EV_GoodsInventoryItemList : " @ param));
			break;
		case 5604:
			OnGoodsInventoryResult(param);
			Debug(("--- EV_GoodsInventoryResult : " @ param));
			break;
		case 5602:
			OnGoodsInventroyItemDesc(param);
			break;
		case 1710:
			break;
		case 1720:
			break;
		default:
			break;
	}
	return;
}

function OnGoodsInventoryItemList(string param)
{
	local int i, goodsTotal, goodsCount;
	local string goodsName;
	local int goodsType, goodsIconID, goodsIsGift;
	local INT64 goodsID, goodsDeliveryDate;
	local int goodsCondition;
	local string goodsIconTexture;
	local ItemID cID;
	local bool bNoSelect;
	local array<GoodsItem> noDateGoodsItemArray;

	if((GoodsItemArray.Length > 0))
	{
		GoodsItemArray.Remove(0, GoodsItemArray.Length);
	}
	ParseInt(param, "goodsTotal", goodsTotal);
	ParseInt(param, "goodsCount", goodsCount);
	ProductItemListTotal.SetText(((GetSystemString(2512) $ " : ") $ string(goodsTotal)));
	if((ProductItemList_Lc.GetRecordCount() > 0))
	{
		ProductItemList_Lc.DeleteAllItem();
	}
	if((goodsCount <= 0))
	{
		initUI();
		NoticeWnd(GetScript("NoticeWnd"))._RemoveNoticButtonProductInventory();
		return;
	}
	i = 0;
	while((i < goodsCount))
	{
		ParseInt(param, ("goodsType_" $ string(i)), goodsType);
		ParseInt(param, ("goodsIconID_" $ string(i)), goodsIconID);
		ParseInt(param, ("goodsCondition_" $ string(i)), goodsCondition);
		ParseInt(param, ("goodsIsGift_" $ string(i)), goodsIsGift);
		ParseINT64(param, ("goodsID_" $ string(i)), goodsID);
		ParseINT64(param, ("goodsDeliveryDate_" $ string(i)), goodsDeliveryDate);
		ParseString(param, ("goodsName_" $ string(i)), goodsName);
		goodsName = makeShortStringByPixel(goodsName, 290, "..");
		if((goodsType == 0))
		{
			cID = GetItemID(goodsIconID);
			goodsIconTexture = Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(cID);
		}
		else
		{
			goodsIconTexture = GetGoodsIconName(goodsIconID);
		}
		if((goodsDeliveryDate > INT64(0)))
		{
			GoodsItemArray.Insert(GoodsItemArray.Length, 1);
			GoodsItemArray[(GoodsItemArray.Length - 1)].goodsName = goodsName;
			GoodsItemArray[(GoodsItemArray.Length - 1)].goodsType = goodsType;
			GoodsItemArray[(GoodsItemArray.Length - 1)].goodsIconID = goodsIconID;
			GoodsItemArray[(GoodsItemArray.Length - 1)].goodsCondition = goodsCondition;
			GoodsItemArray[(GoodsItemArray.Length - 1)].goodsIsGift = goodsIsGift;
			GoodsItemArray[(GoodsItemArray.Length - 1)].goodsID = goodsID;
			GoodsItemArray[(GoodsItemArray.Length - 1)].goodsDeliveryDate = goodsDeliveryDate;
			GoodsItemArray[(GoodsItemArray.Length - 1)].goodsIconTexture = goodsIconTexture;
			GoodsItemArray[(GoodsItemArray.Length - 1)].seqID = i;
			i++;
			continue;
		}
		noDateGoodsItemArray.Insert(noDateGoodsItemArray.Length, 1);
		noDateGoodsItemArray[(noDateGoodsItemArray.Length - 1)].goodsName = goodsName;
		noDateGoodsItemArray[(noDateGoodsItemArray.Length - 1)].goodsType = goodsType;
		noDateGoodsItemArray[(noDateGoodsItemArray.Length - 1)].goodsIconID = goodsIconID;
		noDateGoodsItemArray[(noDateGoodsItemArray.Length - 1)].goodsCondition = goodsCondition;
		noDateGoodsItemArray[(noDateGoodsItemArray.Length - 1)].goodsIsGift = goodsIsGift;
		noDateGoodsItemArray[(noDateGoodsItemArray.Length - 1)].goodsID = goodsID;
		noDateGoodsItemArray[(noDateGoodsItemArray.Length - 1)].goodsDeliveryDate = goodsDeliveryDate;
		noDateGoodsItemArray[(noDateGoodsItemArray.Length - 1)].goodsIconTexture = goodsIconTexture;
		noDateGoodsItemArray[(noDateGoodsItemArray.Length - 1)].seqID = i;
		i++;
	}
	if((GoodsItemArray.Length > 0))
	{
		// GoodsItemArray.Sort(OnSortCompare);   // array.Sort() unsupported by this compiler
	}
	if((noDateGoodsItemArray.Length > 0))
	{
		// noDateGoodsItemArray.Sort(OnSortCompareNoDate);   // array.Sort() unsupported by this compiler
	}
	i = 0;
	while((i < noDateGoodsItemArray.Length))
	{
		GoodsItemArray[GoodsItemArray.Length] = noDateGoodsItemArray[i];
		i++;
	}
	i = 0;
	while((i < GoodsItemArray.Length))
	{
		addProductItemList(GoodsItemArray[i].goodsType, GoodsItemArray[i].goodsIconID, GoodsItemArray[i].goodsCondition, GoodsItemArray[i].goodsIsGift, GoodsItemArray[i].goodsIconTexture, GoodsItemArray[i].goodsName, GoodsItemArray[i].seqID);
		i++;
	}
	if((goodsCount > 0))
	{
		Debug(("GoodsItemArray : " @ string(GoodsItemArray.Length)));
		Debug(("ProductItemList_Lc.GetRecordCount()" @ string(ProductItemList_Lc.GetRecordCount())));
		if((selectedProductListIndex == -1))
		{
			selectedProductListIndex = 0;
		}
		else if((selectedProductListIndex >= ProductItemList_Lc.GetRecordCount()))
		{
			if((lastResultGoodsItemNum <= ProductItemList_Lc.GetRecordCount()))
			{
				selectedProductListIndex = (ProductItemList_Lc.GetRecordCount() - 1);
				Debug(("아이템 수량이 넘은 경우:" @ string(selectedProductListIndex)));  // EN: when the item quantity is exceeded:
			}
			else
			{
				bNoSelect = true;
				Debug(("비정상적인 값 오는 경우 lastResultGoodsItemNum :" @ string(lastResultGoodsItemNum)));  // EN: when an abnormal value arrives lastResultGoodsItemNum :
			}
		}
		if((bNoSelect == false))
		{
			ProductItemList_Lc.SetSelectedIndex(selectedProductListIndex, true);
			RequestGoodsInventoryItemDesc(getSelectedItemSeqNum());
			Debug((("API CALL ---> RequestGoodsInventoryItemDesc( " @ string(getSelectedItemSeqNum())) @ ")"));
			Debug(("selectedProductListIndex" @ string(selectedProductListIndex)));
		}
		hideDisableWnd();
	}
	else
	{
		ShowDisableWnd(false);
	}
	return;
}

delegate int OnSortCompare(GoodsItem A, GoodsItem B)
{
	if((A.goodsDeliveryDate < B.goodsDeliveryDate))
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

delegate int OnSortCompareNoDate(GoodsItem A, GoodsItem B)
{
	if((A.goodsID < B.goodsID))
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

function addProductItemList(int goodsType, int goodsIconID, int goodsCondition, int goodsIsGift, string goodsIconTexture, string goodsName, int seqID)
{
	local RichListCtrlRowData rowData;

	rowData.cellDataList.Length = 2;
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems, goodsIconTexture, 32, 32, 5);
	if((goodsCondition == 1))
	{
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, goodsName, util.White, false, 5, 10);
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, goodsName, util.White, false, 5, 10);
	}
	if((goodsIsGift > 0))
	{
		addRichListCtrlTexture(rowData.cellDataList[1].drawitems, "L2UI_CT1.ProductInventory.ProductInventory_GiftIcon", 16, 16);
	}
	rowData.nReserved1 = INT64(seqID);
	ProductItemList_Lc.InsertRecord(rowData);
	return;
}

function OnGoodsInventroyItemDesc(string param)
{
	local int i, Index, goodsType, goodsIconID;
	local string goodsName;
	local int goodsCondition;
	local string goodsDesc;
	local int goodsGift;
	local string goodsSender, goodsSenderMessage, goodsDate;
	local int gameItemCount, gameItemClassID, gameItemQuantity;
	local string goodsNameShort;
	local ItemID cID;
	local string pIconTexture;

	ParseInt(param, "index", Index);
	Debug(("리스트 선택 정보 index :" @ string(Index)));  // EN: list selection info index :
	if((Index == -1))
	{
		selectedProductItemName = "";
		selectedProductItemIcon = "";
		selectedGoodsCondition = -1;
		return;
	}
	selectItemNum = Index;
	ParseInt(param, "gameItemCount", gameItemCount);
	ParseInt(param, "goodsType", goodsType);
	ParseInt(param, "goodsIconID", goodsIconID);
	ParseInt(param, "goodsCondition", goodsCondition);
	ParseInt(param, "goodsGift", goodsGift);
	goodsCondition = 0;
	ParseString(param, "goodsName", goodsName);
	ParseString(param, "goodsDesc", goodsDesc);
	ParseString(param, "goodsDate", goodsDate);
	ParseString(param, "goodsSender", goodsSender);
	ParseString(param, "goodsSenderMessage", goodsSenderMessage);
	ProductItemDetailListTitle_Lc.DeleteAllItem();
	if((goodsType == 0))
	{
		pIconTexture = Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(GetItemID(goodsIconID));
	}
	else
	{
		pIconTexture = GetGoodsIconName(goodsIconID);
	}
	ProductItem.ShowWindow();
	ProductItem.SetTexture(pIconTexture);
	goodsNameShort = makeShortStringByPixel(goodsName, 300, "..");
	ProductItemText.SetText(goodsNameShort);
	if((goodsName != goodsNameShort))
	{
		ProductItemText.SetTooltipType("text");
		ProductItemText.SetTooltipText(goodsName);
	}
	else
	{
		ProductItemText.ClearTooltip();
	}
	if((goodsCondition == 1))
	{
		ProductItemText.SetTextColor(util.White);
	}
	else
	{
		ProductItemText.SetTextColor(util.White);
	}
	selectedGoodsCondition = goodsCondition;
	if((Len(goodsDesc) > 0))
	{
		ProductItemDiscription.ShowWindow();
		ProductItemDiscription.LoadHtmlFromString(htmlSetHtmlStart(htmlAddText(goodsDesc, "GameDefault", "afb9cd")));
	}
	else
	{
		ProductItemDiscription.HideWindow();
	}
	if((Len(goodsSender) > 0))
	{
		ProductItem_Msg.ShowWindow();
		ProductItem_Msg.SetLoopCount(999999);
		ProductItem_Msg.Stop();
		ProductItem_Msg.Play();
		ProductItem_Msg.SetTooltipCustomType(MakeTooltipMultiText((("[" $ GetSystemString(2473)) $ "]"), util.White, "", true, (GetSystemString(1740) $ goodsSender), util.Gold, "", true, goodsSenderMessage, util.ColorDesc, "", true, 200));
	}
	else
	{
		ProductItem_Msg.Stop();
		ProductItem_Msg.Pause();
		ProductItem_Msg.HideWindow();
	}
	ProductBuyInfo.SetText("");
	i = 0;
	while((i < gameItemCount))
	{
		ParseInt(param, ("gameItemClassID_" $ string(i)), gameItemClassID);
		ParseInt(param, ("gameItemQuantity_" $ string(i)), gameItemQuantity);
		cID = GetItemID(gameItemClassID);
		addProductBoxInsideItemList(cID, Class'NWindow.UIDATA_ITEM'.static.GetItemName(cID), i, gameItemClassID, gameItemQuantity);
		i++;
	}
	selectedProductItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(cID);
	selectedProductItemIcon = pIconTexture;
	ProductItemDetailListCounter.SetText((("(" $ string(gameItemCount)) $ ")"));
	ProductItemList_Lc.SetFocus();
	RecieveBtn.EnableWindow();
	return;
}

function addProductBoxInsideItemList(ItemID cID, string goodsName, int Index, int gameItemClassID, int ItemNum)
{
	local RichListCtrlRowData rowData;
	local ItemInfo tmItemInfo;

	rowData.cellDataList.Length = 1;
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems, Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(cID), 32, 32, 5);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, (((goodsName $ " (") $ string(ItemNum)) $ ")"), util.White, false, 5, 10);
	tmItemInfo = GetItemInfoByClassID(gameItemClassID);
	if((ItemNum > 0))
	{
		tmItemInfo.ItemNum = INT64(ItemNum);
	}
	ItemInfoToParam(tmItemInfo, rowData.szReserved);
	ProductItemDetailListTitle_Lc.InsertRecord(rowData);
	return;
}

function OnGoodsInventoryResult(string param)
{
	local int Result;

	ParseInt(param, "Result", Result);
	if(ProductInventoryConfirmWnd.IsShowWindow())
	{
		ProductInventoryConfirmWnd.HideWindow();
	}
	if(((Result == 1) || (Result == -7)))
	{
		return;
	}
	else if((Result == 2))
	{
		lastResultGoodsItemNum = (GoodsItemArray.Length - 1);
		AddSystemMessage(3412);
		RequestGoodsInventoryItemList();
		Debug("API CALL ---> RequestGoodsInventoryItemList()");
		ShowDisableWnd(true);
		return;
	}
	Debug(("result --> selectedProductListIndex" @ string(selectedProductListIndex)));
	if((Result < 0))
	{
		if((Result == -1))
		{
			DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3377));
		}
		else if((Result == -2))
		{
			DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3385));
		}
		else if((Result == -3))
		{
			DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3386));
		}
		else if((Result == -4))
		{
			DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3411));
		}
		else if((Result == -5))
		{
			DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3413));
		}
		else if((Result == -6))
		{
			DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3417));
		}
		else if((Result == -8))
		{
			DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(5213));
		}
		else if((Result == -9))
		{
			DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(5212));
		}
		else if((Result == -101))
		{
			DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3378));
		}
		else if((Result == -102))
		{
			DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3410));
		}
		else if((Result == -103))
		{
			DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3379));
		}
		else if((Result == -104))
		{
		}
		else if((Result == -105))
		{
			DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3381));
		}
		else if((Result == -106))
		{
			DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3382));
		}
		else if((Result == -107))
		{
			DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3383));
		}
		else if((Result == -108))
		{
			DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3384));
		}
		Me.HideWindow();
	}
	return;
}

function OnClickButton(string Name)
{
	local int itemSelectNum;

	switch(Name)
	{
		case "HelpHtmlBtn":
			if(GetWindowHandle("ProductInventoryHelpHtmlWnd").IsShowWindow())
			{
				GetWindowHandle("ProductInventoryHelpHtmlWnd").HideWindow();
			}
			else
			{
				ProductInventoryHelpHtmlWnd(GetScript("ProductInventoryHelpHtmlWnd")).ShowHelp("..\\L2text\\product_inventory_help00.htm");
			}
			break;
		case "RecieveBtn":
			OnRecieveBtnClick();
			break;
		case "CloseBtn":
			OnCloseBtnClick();
			break;
		case "OK_Button":
			itemSelectNum = getSelectedItemSeqNum();
			if((itemSelectNum > -1))
			{
				RequestUseGoodsInventoryItem(itemSelectNum);
				Debug((("API CALL ---> RequestUseGoodsInventoryItem( " @ string(itemSelectNum)) @ ")"));
				ProductInventoryConfirmWnd.HideWindow();
				ShowDisableWnd(true);
			}
			break;
		case "Cancel_Button":
			ProductInventoryConfirmWnd.HideWindow();
			hideDisableWnd();
			break;
		case "GiftTab_Btn":
			Me.HideWindow();
			getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "GiftInventoryWnd");
			ShowWindow("GiftInventoryWnd");
			break;
		default:
			break;
	}
	return;
}

function int getSelectedItemSeqNum()
{
	local int idx;
	local RichListCtrlRowData rowData;

	idx = ProductItemList_Lc.GetSelectedIndex();
	if((idx <= -1))
	{
		return -1;
	}
	ProductItemList_Lc.GetRec(idx, rowData);
	return int(rowData.nReserved1);
}

function OnRecieveBtnClick()
{
	local int itemSelectNum;

	if((selectedProductListIndex != -1))
	{
		if((false && (selectedGoodsCondition == 1)))
		{
			GetTextureHandle("ProductInventoryWnd.ProductInventoryConfirmWnd.Result_ItemWnd").SetTexture(selectedProductItemIcon);
			GetTextBoxHandle("ProductInventoryWnd.ProductInventoryConfirmWnd.ItemName_TextBox").SetText(selectedProductItemName);
			ShowDisableWnd(true);
			ProductInventoryConfirmWnd.SetFocus();
			ProductInventoryConfirmWnd.ShowWindow();
		}
		else
		{
			RecieveBtnAni.Stop();
			RecieveBtnAni.SetLoopCount(1);
			RecieveBtnAni.Play();
			itemSelectNum = getSelectedItemSeqNum();
			if((itemSelectNum > -1))
			{
				RequestUseGoodsInventoryItem(itemSelectNum);
				Debug((("API CALL ---> RequestUseGoodsInventoryItem( " @ string(itemSelectNum)) @ ")"));
				ProductInventoryConfirmWnd.HideWindow();
				ShowDisableWnd(true);
			}
		}
	}
	return;
}

function OnCloseBtnClick()
{
	Me.HideWindow();
	return;
}

function OnClickListCtrlRecord(string strID)
{
	local int idx;
	local RichListCtrlRowData rowData;

	Debug(("strID : " @ strID));
	if((strID == "ProductItemList_Lc"))
	{
		idx = ProductItemList_Lc.GetSelectedIndex();
		if((idx <= -1))
		{
			return;
		}
		if((selectedProductListIndex == idx))
		{
			return;
		}
		ProductItemList_Lc.GetRec(idx, rowData);
		if((rowData.nReserved1 > INT64(-1)))
		{
			selectedProductListIndex = idx;
			RequestGoodsInventoryItemDesc(int(rowData.nReserved1));
		}
		Debug((("API CALL ---> RequestGoodsInventoryItemDesc(" @ string(rowData.nReserved1)) @ ")"));
	}
	return;
}

function ShowDisableWnd(bool bAllDisableType)
{
	if(bAllDisableType)
	{
		DisableWndAll.ShowWindow();
		DisableWndAll.SetFocus();
		DisableWndList.HideWindow();
	}
	else
	{
		DisableWndAll.HideWindow();
		DisableWndList.ShowWindow();
		DisableWndList.SetFocus();
	}
	return;
}

function hideDisableWnd()
{
	DisableWndAll.HideWindow();
	DisableWndList.HideWindow();
	return;
}

function OnReceivedCloseUI()
{
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}
