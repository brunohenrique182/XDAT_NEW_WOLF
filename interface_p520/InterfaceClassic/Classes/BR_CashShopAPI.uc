class BR_CashShopAPI extends UICommonAPI;

const CASHSHOPPAYMENTTYPE_CASH = 0;
const CASHSHOPPAYMENTTYPE_ADENA = 1;
const CASHSHOPPAYMENTTYPE_EVENTCOIN = 2;
const ITEM_INFO_WIDTH = 256;
const DRAWPANEL_ITEM_INFO_WIDTH = 208;
const DAY_SUN = 0x00000001;
const DAY_MON = 0x00000002;
const DAY_TUE = 0x00000004;
const DAY_WED = 0x00000008;
const DAY_THU = 0x00000010;
const DAY_FRI = 0x00000020;
const DAY_SAT = 0x00000040;

enum EPreItemPanelType
{
	PIPT_EVENT,                     // 0
	PIPT_SALE,                      // 1
	PIPT_NEW,                       // 2
	PIPT_STAR,                      // 3
	PIPT_MAX                        // 4
};

var DrawItemInfo m_kDrawInfoClear;
var array<string> m_UI_prime_panel_Main;
var array<string> m_UI_prime_panel_Item;
var bool m_bCoinToMoney;
var bool m_bPresent;
var float m_fCoinMoneyValue;
var array<ProductInfo> m_ProductList;
var array<ProductInfo> m_RecentList;
var array<ProductInfo> m_BasketList;
var bool m_bOpenBuyWnd;

function OnRegisterEvent()
{
	RegisterEvent(9020);
	RegisterEvent(9023);
	RegisterEvent(9025);
	RegisterEvent(9021);
	RegisterEvent(9026);
	RegisterEvent(9028);
	RegisterEvent(9027);
	RegisterEvent(9013);
	return;
}

function OnLoad()
{
	m_bCoinToMoney = IsBr_CashShopCoinToMoney();
	if(m_bCoinToMoney)
	{
		m_fCoinMoneyValue = GetBr_CashShopCoinToMoneyValue();
	}
	m_bPresent = IsBr_CashShopPresent();
	if(((int(GetLanguage()) == 4) && IsInEvaServer()))
	{
		m_bPresent = false;
	}
	m_ProductList.Length = 0;
	m_RecentList.Length = 0;
	m_BasketList.Length = 0;
	m_bOpenBuyWnd = false;
	m_UI_prime_panel_Main.Length = ConvertPreItemPanelType(PIPT_MAX);
	m_UI_prime_panel_Item.Length = ConvertPreItemPanelType(PIPT_MAX);
	m_UI_prime_panel_Main[ConvertPreItemPanelType(PIPT_EVENT)] = "BranchSys3.ui.g_ui_prime_panel_event";
	m_UI_prime_panel_Main[ConvertPreItemPanelType(PIPT_SALE)] = "BranchSys3.ui.g_ui_prime_panel_sale";
	m_UI_prime_panel_Main[ConvertPreItemPanelType(PIPT_NEW)] = "BranchSys3.ui.g_ui_prime_panel_new";
	m_UI_prime_panel_Main[ConvertPreItemPanelType(PIPT_STAR)] = "BranchSys3.ui.g_ui_prime_panel_best";
	m_UI_prime_panel_Item[ConvertPreItemPanelType(PIPT_EVENT)] = "BranchSys3.ui.g_ui_prime_panel_event_s";
	m_UI_prime_panel_Item[ConvertPreItemPanelType(PIPT_SALE)] = "BranchSys3.ui.g_ui_prime_panel_sale_s";
	m_UI_prime_panel_Item[ConvertPreItemPanelType(PIPT_NEW)] = "BranchSys3.ui.g_ui_prime_panel_new_s";
	m_UI_prime_panel_Item[ConvertPreItemPanelType(PIPT_STAR)] = "BranchSys3.ui.g_ui_prime_panel_best_s";
	return;
}

function bool GetOpenBuyWnd()
{
	return m_bOpenBuyWnd;
}

function SetOpenBuyWnd(bool Open)
{
	m_bOpenBuyWnd = Open;
	return;
}

function ClearItemList(int allclear)
{
	if((allclear > 0))
	{
		m_ProductList.Length = 0;
	}
	return;
}

function ClearBasketItemList()
{
	local int i;

	m_BasketList.Length = 0;
	i = 0;
	while((i < m_ProductList.Length))
	{
		m_ProductList[i].bMyShopBasketEnable = false;
		i++;
	}
	return;
}

function ClearRecentList()
{
	m_RecentList.Length = 0;
	return;
}

function OnEvent(int Event_ID, string param)
{
	local int iResult, iProductType;

	switch(Event_ID)
	{
		case 9020:
			AddProductItem(BRCSP_PRODUCT, param);
			break;
		case 9023:
			AddProductItemData(BRCSP_PRODUCT, param);
			break;
		case 9025:
			AddProductItem(BRCSP_RECENT, param);
			break;
		case 9026:
			AddProductItem(BRCSP_BASKET, param);
			break;
		case 9027:
			AddProductItemData(BRCSP_RECENT, param);
			break;
		case 9028:
			AddProductItemData(BRCSP_BASKET, param);
			break;
		case 9021:
			ParseInt(param, "Option", iResult);
			ParseInt(param, "ProductType", iProductType);
			if((iProductType == 0))
			{
				ClearItemList(1);
			}
			else if((iProductType == 1))
			{
				ClearRecentList();
			}
			else if((iProductType == 2))
			{
				ClearBasketItemList();
			}
			break;
		default:
			break;
	}
	return;
}

function array<ProductInfo> GetBasketProductList()
{
	return m_BasketList;
}

function array<ProductInfo> GetRecentProductList()
{
	return m_RecentList;
}

function int ProductListCount()
{
	return m_ProductList.Length;
}

function ProductInfo ArrayProductItem(int Index)
{
	return m_ProductList[Index];
}

function bool UpdateBasketProductItem(ButtonHandle a_ButtonHandle, int ProductID, bool BasketCheck)
{
	local int SelectedProductID;

	SetBasketProductItem(ProductID, BasketCheck);
	SelectedProductID = a_ButtonHandle.GetButtonValue();
	if((SelectedProductID < 0))
	{
		return false;
	}
	if((SelectedProductID == ProductID))
	{
		UpdateBasketProductWindow(a_ButtonHandle, BasketCheck);
		return true;
	}
	return false;
}

function DeleteBasketProductItem(int ProductID)
{
	local int i;

	i = 0;
	while((i < m_BasketList.Length))
	{
		if((m_BasketList[i].iProductID == ProductID))
		{
			m_BasketList.Remove(i, 1);
			SetBasketProductItem(ProductID, false);
			break;
		}
		i++;
	}
	return;
}

function SetBasketProductItemData()
{
	local int i;
	local ProductInfo ProductItem;

	i = 0;
	while((i < m_ProductList.Length))
	{
		ProductItem = GetBasketProductItem(m_ProductList[i].iProductID);
		if((ProductItem.iProductID > 0))
		{
			m_ProductList[i].bMyShopBasketEnable = true;
		}
		i++;
	}
	return;
}

function SetBasketProductItem(int Id, bool Enable)
{
	local int i;

	i = 0;
	while((i < m_ProductList.Length))
	{
		if((m_ProductList[i].iProductID == Id))
		{
			m_ProductList[i].bMyShopBasketEnable = Enable;
		}
		i++;
	}
	return;
}

function AddMyShopBasketProductItem(int Id)
{
	local int iCurrentIndex;
	local ProductInfo ProductItem;

	ProductItem = GetBasketProductItem(Id);
	if((ProductItem.iProductID < 0))
	{
		ProductItem = GetProductItem(Id);
		iCurrentIndex = m_BasketList.Length;
		m_BasketList.Length = (iCurrentIndex + 1);
		m_BasketList[iCurrentIndex] = ProductItem;
	}
	Debug(("m_BasketList Count" $ string(m_BasketList.Length)));
	return;
}

function ProductInfo GetProductItem(int Id)
{
	local int i;
	local ProductInfo ProductItem;

	ProductItem.iProductID = -1;
	i = 0;
	while((i < m_ProductList.Length))
	{
		if((m_ProductList[i].iProductID == Id))
		{
			return m_ProductList[i];
		}
		i++;
	}
	return ProductItem;
}

function ProductInfo GetBasketProductItem(int Id)
{
	local int i;
	local ProductInfo ProductItem;

	ProductItem.iProductID = -1;
	i = 0;
	while((i < m_BasketList.Length))
	{
		if((m_BasketList[i].iProductID == Id))
		{
			return m_BasketList[i];
		}
		i++;
	}
	return ProductItem;
}

function AddProductItem(UIEventManager.EBR_CashShopProduct Type, string param)
{
	local int iID, Category, paymenttype, itempaneltype, showtab, Price;
	local string ItemName, IconName, Desc, mainsubject;
	local int start_sale, end_sale, salepercent, MinLevel, MaxLevel, minbirthday, maxbirthday, restrictionday, availablecount, day_week, start_hour, start_min, end_hour, end_min, stock, max_stock, iCurrentIndex;
	local ProductInfo ProductItem;

	ParseInt(param, "ID", iID);
	ParseInt(param, "Category", Category);
	ParseInt(param, "PaymentType", paymenttype);
	ParseInt(param, "ShowTab", showtab);
	ParseInt(param, "Price", Price);
	ParseInt(param, "ItemPanelType", itempaneltype);
	ParseString(param, "ItemName", ItemName);
	ParseString(param, "IconName", IconName);
	ParseInt(param, "StartSale", start_sale);
	ParseInt(param, "EndSale", end_sale);
	ParseInt(param, "DayWeek", day_week);
	ParseInt(param, "StartHour", start_hour);
	ParseInt(param, "StartMin", start_min);
	ParseInt(param, "EndHour", end_hour);
	ParseInt(param, "EndMin", end_min);
	ParseInt(param, "Stock", stock);
	ParseInt(param, "MaxStock", max_stock);
	ParseInt(param, "SalePercent", salepercent);
	ParseInt(param, "MinLevel", MinLevel);
	ParseInt(param, "MaxLevel", MaxLevel);
	ParseInt(param, "MinBirthday", minbirthday);
	ParseInt(param, "MaxBirthday", maxbirthday);
	ParseInt(param, "RestrictionDay", restrictionday);
	ParseInt(param, "AvailableCount", availablecount);
	ParseString(param, "Desc", Desc);
	ProductItem.iProductID = iID;
	ProductItem.iCategory = Category;
	ProductItem.iPaymentType = paymenttype;
	ProductItem.iShowTab = showtab;
	ProductItem.iPanel_Type = itempaneltype;
	ProductItem.iSale_Percent = salepercent;
	ProductItem.iPrice = Price;
	ProductItem.strName = ItemName;
	ProductItem.strIconName = IconName;
	ProductItem.iStartSale = start_sale;
	ProductItem.iEndSale = end_sale;
	ProductItem.iDayWeek = day_week;
	ProductItem.iStartHour = start_hour;
	ProductItem.iStartMin = start_min;
	ProductItem.iEndHour = end_hour;
	ProductItem.iEndMin = end_min;
	ProductItem.iStock = stock;
	ProductItem.iMaxStock = max_stock;
	ProductItem.bMyShopBasketEnable = false;
	ProductItem.iMinLevel = MinLevel;
	ProductItem.iMaxLevel = MaxLevel;
	ProductItem.iMinBirthday = minbirthday;
	ProductItem.iMaxBirthday = maxbirthday;
	ProductItem.iRestrictionDay = restrictionday;
	ProductItem.iAvailableCount = availablecount;
	ProductItem.bLimited = false;
	if(((!((((start_hour == 0) && (start_min == 0)) && (end_hour == 23)) && (end_min == 59)) || (day_week != 127)) || (BR_GetDayType(end_sale, 0) < 2037)))
	{
		ProductItem.bLimited = true;
	}
	ProductItem.bEnable = false;
	ProductItem.strDesc = Desc;
	if((int(Type) == 0))
	{
		ParseString(param, "MainSubject", mainsubject);
		ProductItem.strMainSubject = mainsubject;
		iCurrentIndex = m_ProductList.Length;
		m_ProductList.Length = (iCurrentIndex + 1);
		m_ProductList[iCurrentIndex] = ProductItem;
	}
	else if((int(Type) == 1))
	{
		iCurrentIndex = m_RecentList.Length;
		m_RecentList.Length = (iCurrentIndex + 1);
		m_RecentList[iCurrentIndex] = ProductItem;
	}
	else if((int(Type) == 2))
	{
		ProductItem.bMyShopBasketEnable = true;
		iCurrentIndex = m_BasketList.Length;
		m_BasketList.Length = (iCurrentIndex + 1);
		m_BasketList[iCurrentIndex] = ProductItem;
	}
	return;
}

function AddProductItemData(UIEventManager.EBR_CashShopProduct Type, string param)
{
	local int iID, iAmount, Weight, TRADE;
	local string Desc;
	local int iCurrentIndex, iitemIndex;
	local ProductItem item;

	ParseInt(param, "ID", iID);
	ParseInt(param, "Amount", iAmount);
	ParseInt(param, "Weight", Weight);
	ParseInt(param, "Trade", TRADE);
	ParseString(param, "Desc", Desc);
	item.iItemID = iID;
	item.iAmount = iAmount;
	item.iWeight = Weight;
	item.iTradable = TRADE;
	item.strDesc = Desc;
	if((int(Type) == 0))
	{
		iCurrentIndex = (m_ProductList.Length - 1);
		iitemIndex = m_ProductList[iCurrentIndex].itemarray.Length;
		m_ProductList[iCurrentIndex].itemarray.Length = (iitemIndex + 1);
		m_ProductList[iCurrentIndex].itemarray[iitemIndex] = item;
	}
	else if((int(Type) == 1))
	{
		iCurrentIndex = (m_RecentList.Length - 1);
		iitemIndex = m_RecentList[iCurrentIndex].itemarray.Length;
		m_RecentList[iCurrentIndex].itemarray.Length = (iitemIndex + 1);
		m_RecentList[iCurrentIndex].itemarray[iitemIndex] = item;
	}
	else if((int(Type) == 2))
	{
		iCurrentIndex = (m_BasketList.Length - 1);
		iitemIndex = m_BasketList[iCurrentIndex].itemarray.Length;
		m_BasketList[iCurrentIndex].itemarray.Length = (iitemIndex + 1);
		m_BasketList[iCurrentIndex].itemarray[iitemIndex] = item;
	}
	return;
}

function OnBtnBuyClick(int ProductID)
{
	local string strParam;
	local ProductInfo ProductItem;

	ProductItem = GetProductItem(ProductID);
	if((ProductItem.iProductID > 0))
	{
		ParamAdd(strParam, "ID", string(ProductID));
		ParamAdd(strParam, "Price", string(ProductItem.iPrice));
		ParamAdd(strParam, "PaymentType", string(ProductItem.iPaymentType));
		ParamAdd(strParam, "ItemName", ProductItem.strName);
		ParamAdd(strParam, "IconName", ProductItem.strIconName);
		if(m_bCoinToMoney)
		{
			ParamAdd(strParam, "CoinToMoney", string(1));
			ParamAdd(strParam, "CoinToMoneyValue", string(m_fCoinMoneyValue));
		}
		else
		{
			ParamAdd(strParam, "CoinToMoney", string(0));
		}
		ExecuteEvent(9070, strParam);
	}
	return;
}

function OnBtnPresentClick(int ProductID)
{
	local string strParam;
	local ProductInfo ProductItem;

	ProductItem = GetProductItem(ProductID);
	if((ProductItem.iProductID > 0))
	{
		ParamAdd(strParam, "ID", string(ProductID));
		ParamAdd(strParam, "Price", string(ProductItem.iPrice));
		ParamAdd(strParam, "ItemName", ProductItem.strName);
		ParamAdd(strParam, "IconName", ProductItem.strIconName);
		if(m_bCoinToMoney)
		{
			ParamAdd(strParam, "CoinToMoney", string(1));
			ParamAdd(strParam, "CoinToMoneyValue", string(m_fCoinMoneyValue));
		}
		else
		{
			ParamAdd(strParam, "CoinToMoney", string(0));
		}
		ExecuteEvent(9072, strParam);
	}
	return;
}

function InitMainProductWindow(WindowHandle ItemWnd)
{
	local ButtonHandle btnCashItemIcon, btnGo;
	local TextureHandle TexPanel, TexSoldOut;
	local TextBoxHandle TextCount;

	TexPanel = TextureHandle(ItemWnd.GetChildWindow("TexPanel"));
	TexPanel.HideWindow();
	btnGo = ButtonHandle(ItemWnd.GetChildWindow("BtnGo"));
	btnGo.HideWindow();
	btnCashItemIcon = ButtonHandle(ItemWnd.GetChildWindow("EventCashItem"));
	if((btnCashItemIcon != none))
	{
		btnCashItemIcon.HideWindow();
	}
	TexSoldOut = TextureHandle(ItemWnd.GetChildWindow("TexSoldOut"));
	TextCount = TextBoxHandle(ItemWnd.GetChildWindow("TextCount"));
	TextCount.HideWindow();
	TexSoldOut.HideWindow();
	return;
}

function SetMainProductWindow(WindowHandle ItemWnd, ProductInfo Info)
{
	local ButtonHandle btnCashItemIcon, btnGo;
	local TextureHandle TexPanel, TexSoldOut;
	local TextBoxHandle TextCount;
	local DrawPanelHandle drawPanel;
	local TextBoxHandle descdrawpanel;
	local DrawItemInfo kDrawInfo;
	local string strCount, strTemp;

	TexPanel = TextureHandle(ItemWnd.GetChildWindow("TexPanel"));
	if(((Info.iPanel_Type > 0) && (Info.iPanel_Type <= ConvertPreItemPanelType(PIPT_MAX))))
	{
		TexPanel.SetTexture(m_UI_prime_panel_Main[(Info.iPanel_Type - 1)]);
		TexPanel.ShowWindow();
	}
	else
	{
		TexPanel.HideWindow();
	}
	drawPanel = DrawPanelHandle(ItemWnd.GetChildWindow("CashItemDrawPanel"));
	drawPanel.Clear();
	if((drawPanel == none))
	{
		return;
	}
	btnGo = ButtonHandle(ItemWnd.GetChildWindow("BtnGo"));
	btnGo.SetButtonValue(Info.iProductID);
	btnGo.ShowWindow();
	btnCashItemIcon = ButtonHandle(ItemWnd.GetChildWindow("EventCashItem"));
	if((btnCashItemIcon != none))
	{
		btnCashItemIcon.ShowWindow();
		btnCashItemIcon.SetTexture(Info.strIconName, Info.strIconName, Info.strIconName);
		btnCashItemIcon.ClearTooltip();
		SetTooltipProductInfo(btnCashItemIcon, Info);
		btnCashItemIcon.SetTooltipCalculateSize(256);
	}
	MakeDrawPanelInfo_Desc(kDrawInfo, Info.strName, 227, 197, 80, 200);
	drawPanel.InsertDrawItem(kDrawInfo);
	strTemp = SetPaymentType(Info.iPaymentType, Info.iPrice);
	MakeDrawInfo_Text(kDrawInfo, strTemp, 220, 220, 220);
	kDrawInfo.bLineBreak = true;
	kDrawInfo.nOffSetY = 6;
	drawPanel.InsertDrawItem(kDrawInfo);
	SeTimeLimitInfo(drawPanel, Info);
	drawPanel.SetMiddleAlign(true, 200);
	descdrawpanel = TextBoxHandle(ItemWnd.GetChildWindow("TextCashItemDescDrawPanel"));
	descdrawpanel.SetText(Info.strMainSubject);
	TexSoldOut = TextureHandle(ItemWnd.GetChildWindow("TexSoldOut"));
	TextCount = TextBoxHandle(ItemWnd.GetChildWindow("TextCount"));
	if((Info.iStock < 0))
	{
		TextCount.HideWindow();
		TexSoldOut.HideWindow();
	}
	else if((Info.iStock == 0))
	{
		TexSoldOut.ShowWindow();
		TextCount.ShowWindow();
		strCount = ((GetSystemString(5027) $ " : ") $ string(0));
		TextCount.SetText(strCount);
	}
	else
	{
		TextCount.ShowWindow();
		strCount = ((GetSystemString(5027) $ " : ") $ string(Info.iStock));
		TextCount.SetText(strCount);
		TexSoldOut.HideWindow();
	}
	return;
}

function UpdateBasketProductWindow(ButtonHandle childBtnBasket, bool bMyShopBasketEnable)
{
	if(bMyShopBasketEnable)
	{
		childBtnBasket.SetTexture("BranchSys3.UI.button_favorite_on", "BranchSys3.UI.button_favorite_on", "BranchSys3.UI.button_favorite_on");
	}
	else
	{
		childBtnBasket.SetTexture("BranchSys3.UI.button_favorite_off", "BranchSys3.UI.button_favorite_off", "BranchSys3.UI.button_favorite_off");
	}
	return;
}

function SetViewProductWindow(WindowHandle ItemWnd, ProductInfo Info, bool bMyShop, bool visableBasket)
{
	local ButtonHandle btnCashItemIcon, childBtnBuy, childBtnPresent, childBtnBasket;
	local TextureHandle TexPanel, TexSoldOut;
	local DrawPanelHandle drawPanel;
	local DrawItemInfo kDrawInfo;
	local TextBoxHandle TextCount, TextPoint;
	local string strCount, strTemp;

	drawPanel = DrawPanelHandle(ItemWnd.GetChildWindow("CashItemDrawPanel"));
	drawPanel.Clear();
	if((drawPanel == none))
	{
		return;
	}
	TexPanel = TextureHandle(ItemWnd.GetChildWindow("TexPanel"));
	if(((Info.iPanel_Type > 0) && (Info.iPanel_Type <= ConvertPreItemPanelType(PIPT_MAX))))
	{
		TexPanel.SetTexture(m_UI_prime_panel_Item[(Info.iPanel_Type - 1)]);
		TexPanel.ShowWindow();
	}
	else
	{
		TexPanel.HideWindow();
	}
	childBtnBuy = ButtonHandle(ItemWnd.GetChildWindow("BtnBuy"));
	childBtnBuy.SetButtonValue(Info.iProductID);
	childBtnPresent = ButtonHandle(ItemWnd.GetChildWindow("BtnPresent"));
	childBtnPresent.SetButtonValue(Info.iProductID);
	childBtnPresent.SetEnable(m_bPresent);
	if(bMyShop)
	{
		childBtnBasket = ButtonHandle(ItemWnd.GetChildWindow("BtnDelete"));
	}
	else
	{
		childBtnBasket = ButtonHandle(ItemWnd.GetChildWindow("BtnBasket"));
	}
	childBtnBasket.SetButtonValue(Info.iProductID);
	btnCashItemIcon = ButtonHandle(ItemWnd.GetChildWindow("CashItemIcon"));
	if((btnCashItemIcon != none))
	{
		btnCashItemIcon.SetTexture(Info.strIconName, Info.strIconName, Info.strIconName);
		btnCashItemIcon.ClearTooltip();
		SetTooltipProductInfo(btnCashItemIcon, Info);
		btnCashItemIcon.SetTooltipCalculateSize(256);
	}
	MakeDrawPanelInfo_Desc(kDrawInfo, Info.strName, 220, 220, 220, 208);
	kDrawInfo.nOffSetY = 5;
	drawPanel.InsertDrawItem(kDrawInfo);
	TextPoint = TextBoxHandle(ItemWnd.GetChildWindow("TextPoint"));
	strTemp = SetPaymentType(Info.iPaymentType, Info.iPrice);
	TextPoint.SetText(strTemp);
	TexSoldOut = TextureHandle(ItemWnd.GetChildWindow("TexSoldOut"));
	TextCount = TextBoxHandle(ItemWnd.GetChildWindow("TextCount"));
	if((Info.iStock < 0))
	{
		TextCount.HideWindow();
		TexSoldOut.HideWindow();
		childBtnBuy.ShowWindow();
		childBtnPresent.ShowWindow();
		childBtnBasket.ShowWindow();
	}
	else if((Info.iStock == 0))
	{
		TexSoldOut.ShowWindow();
		TextCount.ShowWindow();
		strCount = ((GetSystemString(5027) $ " : ") $ string(0));
		TextCount.SetText(strCount);
		childBtnBuy.HideWindow();
		childBtnPresent.HideWindow();
		childBtnBasket.HideWindow();
	}
	else
	{
		TextCount.ShowWindow();
		strCount = ((GetSystemString(5027) $ " : ") $ string(Info.iStock));
		TextCount.SetText(strCount);
		TexSoldOut.HideWindow();
		childBtnBuy.ShowWindow();
		childBtnPresent.ShowWindow();
		childBtnBasket.ShowWindow();
	}
	if(visableBasket)
	{
		childBtnBasket.ShowWindow();
		if((bMyShop == false))
		{
			UpdateBasketProductWindow(childBtnBasket, Info.bMyShopBasketEnable);
		}
	}
	else
	{
		childBtnBasket.HideWindow();
	}
	SeTimeLimitInfo(drawPanel, Info);
	if(((Info.iPaymentType == 0) && (Info.iAvailableCount <= 0)))
	{
		childBtnPresent.SetEnable(true);
	}
	else
	{
		childBtnPresent.SetEnable(false);
	}
	if(((int(GetLanguage()) == 4) && IsInEvaServer()))
	{
		childBtnPresent.DisableWindow();
	}
	return;
}

function SeTimeLimitInfo(DrawPanelHandle wnd, ProductInfo kProductInfo)
{
	local string strTemp;
	local DrawItemInfo kDrawInfo;
	local int bTimeLimit;

	if((kProductInfo.iProductID >= 0))
	{
		kDrawInfo.bLineBreak = true;
		kDrawInfo.nOffSetY = 2;
		bTimeLimit = 0;
		if(!((((kProductInfo.iStartHour == 0) && (kProductInfo.iStartMin == 0)) && (kProductInfo.iEndHour == 23)) && (kProductInfo.iEndMin == 59)))
		{
			bTimeLimit = 1;
		}
		if(((kProductInfo.iRestrictionDay >= 1) && (kProductInfo.iAvailableCount >= 1)))
		{
			strTemp = MakeFullSystemMsg(GetSystemMessage(6164), string(kProductInfo.iRestrictionDay), string(kProductInfo.iAvailableCount));
			MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
			kDrawInfo.bLineBreak = true;
			kDrawInfo.nOffSetY = 2;
			wnd.InsertDrawItem(kDrawInfo);
		}
		else if(((kProductInfo.iRestrictionDay < 0) && (kProductInfo.iAvailableCount >= 1)))
		{
			strTemp = MakeFullSystemMsg(GetSystemMessage(6165), string(kProductInfo.iAvailableCount), "");
			MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
			kDrawInfo.bLineBreak = true;
			kDrawInfo.nOffSetY = 2;
			wnd.InsertDrawItem(kDrawInfo);
		}
		else if(((kProductInfo.iMinBirthday > 0) || (kProductInfo.iMaxBirthday > 0)))
		{
			strTemp = GetSystemString(5149);
			MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
			kDrawInfo.bLineBreak = true;
			kDrawInfo.nOffSetY = 2;
			wnd.InsertDrawItem(kDrawInfo);
		}
		else if(((kProductInfo.iMinLevel > 0) || (kProductInfo.iMaxLevel > 0)))
		{
			if(((kProductInfo.iMinLevel > 0) && (kProductInfo.iMaxLevel > kProductInfo.iMinLevel)))
			{
				strTemp = ((((((("" $ string(kProductInfo.iMinLevel)) $ "") $ GetSystemString(537)) $ " ~ ") $ string(kProductInfo.iMaxLevel)) $ "") $ GetSystemString(537));
				MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
				kDrawInfo.bLineBreak = true;
				kDrawInfo.nOffSetY = 2;
				wnd.InsertDrawItem(kDrawInfo);
			}
			else if((kProductInfo.iMinLevel == kProductInfo.iMaxLevel))
			{
				strTemp = ((("" $ string(kProductInfo.iMinLevel)) $ "") $ GetSystemString(537));
				MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
				kDrawInfo.bLineBreak = true;
				kDrawInfo.nOffSetY = 2;
				wnd.InsertDrawItem(kDrawInfo);
			}
			else if((kProductInfo.iMinLevel > 0))
			{
				strTemp = MakeFullSystemMsg(GetSystemMessage(6170), string(kProductInfo.iMinLevel), "");
				MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
				kDrawInfo.bLineBreak = true;
				kDrawInfo.nOffSetY = 2;
				wnd.InsertDrawItem(kDrawInfo);
			}
			else if((kProductInfo.iMaxLevel > 0))
			{
				strTemp = MakeFullSystemMsg(GetSystemMessage(6171), string(kProductInfo.iMaxLevel), "");
				MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
				kDrawInfo.bLineBreak = true;
				kDrawInfo.nOffSetY = 2;
				wnd.InsertDrawItem(kDrawInfo);
			}
		}
		else if((bTimeLimit != 0))
		{
			strTemp = ((((((((((("" $ ZERO_STR(kProductInfo.iStartHour)) $ string(kProductInfo.iStartHour)) $ ":") $ ZERO_STR(kProductInfo.iStartMin)) $ string(kProductInfo.iStartMin)) $ "~") $ ZERO_STR(kProductInfo.iEndHour)) $ string(kProductInfo.iEndHour)) $ ":") $ ZERO_STR(kProductInfo.iEndMin)) $ string(kProductInfo.iEndMin));
			MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
			kDrawInfo.bLineBreak = true;
			kDrawInfo.nOffSetY = 2;
			wnd.InsertDrawItem(kDrawInfo);
		}
		else if((kProductInfo.iDayWeek != 127))
		{
			strTemp = (((("" $ ConvertBRCashShopDayWeek(kProductInfo.iDayWeek)) $ " ") $ GetSystemString(5142)) $ "");
			MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
			kDrawInfo.bLineBreak = true;
			kDrawInfo.nOffSetY = 2;
			wnd.InsertDrawItem(kDrawInfo);
		}
		else if((BR_GetDayType(kProductInfo.iEndSale, 0) < 2037))
		{
			strTemp = ((("" $ BR_ConvertTimeToStr(kProductInfo.iStartSale, 2)) $ "~") $ BR_ConvertTimeToStr(kProductInfo.iEndSale, 2));
			MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
			kDrawInfo.bLineBreak = true;
			kDrawInfo.nOffSetY = 2;
			wnd.InsertDrawItem(kDrawInfo);
		}
		else if((kProductInfo.iStock > 0))
		{
			if((int(GetLanguage()) == 8))
			{
				strTemp = ((("" $ GetSystemString(3282)) $ ": ") $ string(kProductInfo.iMaxStock));
			}
			else if((int(GetLanguage()) == 9))
			{
				strTemp = ((("" $ GetSystemString(5131)) $ ": ") $ string(kProductInfo.iMaxStock));
			}
			else
			{
				strTemp = ((("" $ string(kProductInfo.iMaxStock)) $ "") $ GetSystemString(5131));
			}
			MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
			kDrawInfo.bLineBreak = true;
			kDrawInfo.nOffSetY = 2;
			wnd.InsertDrawItem(kDrawInfo);
		}
		else if((kProductInfo.iSale_Percent > 0))
		{
			strTemp = ((("" $ string(kProductInfo.iSale_Percent)) $ "") $ GetSystemString(5132));
			MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
			kDrawInfo.bLineBreak = true;
			kDrawInfo.nOffSetY = 2;
			wnd.InsertDrawItem(kDrawInfo);
		}
	}
	return;
}

function SetTooltipProductInfo(WindowHandle wnd, ProductInfo kProductInfo)
{
	local string strTemp;
	local DrawItemInfo kDrawInfo;
	local int LimitedMarginY, bTimeLimit, i;

	MakeDrawTooltipInfo_Desc(kDrawInfo, kProductInfo.strName, 227, 197, 80);
	wnd.InsertTooltipDrawItem(kDrawInfo);
	if((kProductInfo.iProductID >= 0))
	{
		LimitedMarginY = 6;
		bTimeLimit = 0;
		if(!((((kProductInfo.iStartHour == 0) && (kProductInfo.iStartMin == 0)) && (kProductInfo.iEndHour == 23)) && (kProductInfo.iEndMin == 59)))
		{
			bTimeLimit = 1;
		}
		if((kProductInfo.iMaxStock > 0))
		{
			if(((int(GetLanguage()) == 8) || (int(GetLanguage()) == 9)))
			{
				strTemp = ((((("[" $ GetSystemString(5133)) $ "] ") $ GetSystemString(5027)) $ ": ") $ string(kProductInfo.iStock));
				MakeDrawPanelInfo_Desc(kDrawInfo, strTemp, 199, 47, 44, 256);
			}
			else
			{
				strTemp = ((((((((("[" $ GetSystemString(5133)) $ "] ") $ string(kProductInfo.iMaxStock)) $ "") $ GetSystemString(5131)) $ " ") $ GetSystemString(5027)) $ ": ") $ string(kProductInfo.iStock));
				MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
			}
			kDrawInfo.bLineBreak = true;
			kDrawInfo.nOffSetY = LimitedMarginY;
			wnd.InsertTooltipDrawItem(kDrawInfo);
			LimitedMarginY = 0;
		}
		if(((kProductInfo.iRestrictionDay >= 1) && (kProductInfo.iAvailableCount >= 1)))
		{
			strTemp = ((("[" $ GetSystemString(5150)) $ "] \\n") $ MakeFullSystemMsg(GetSystemMessage(6164), string(kProductInfo.iRestrictionDay), string(kProductInfo.iAvailableCount)));
			MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
			kDrawInfo.bLineBreak = true;
			kDrawInfo.nOffSetY = LimitedMarginY;
			wnd.InsertTooltipDrawItem(kDrawInfo);
		}
		if(((kProductInfo.iRestrictionDay < 0) && (kProductInfo.iAvailableCount >= 1)))
		{
			strTemp = ((("[" $ GetSystemString(5150)) $ "] ") $ MakeFullSystemMsg(GetSystemMessage(6165), string(kProductInfo.iAvailableCount), ""));
			MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
			kDrawInfo.bLineBreak = true;
			kDrawInfo.nOffSetY = LimitedMarginY;
			wnd.InsertTooltipDrawItem(kDrawInfo);
		}
		if(((kProductInfo.iMinBirthday > 0) || (kProductInfo.iMaxBirthday > 0)))
		{
			if(((kProductInfo.iMinBirthday > 0) && (kProductInfo.iMaxBirthday > 0)))
			{
				strTemp = ((("[" $ GetSystemString(5149)) $ "] ") $ BR_ConvertTimeToStr(kProductInfo.iMinBirthday, 1));
				MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
				kDrawInfo.bLineBreak = true;
				kDrawInfo.nOffSetY = LimitedMarginY;
				LimitedMarginY = 0;
				wnd.InsertTooltipDrawItem(kDrawInfo);
				strTemp = ("             ~ " $ BR_ConvertTimeToStr(kProductInfo.iMaxBirthday, 1));
				MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
				kDrawInfo.bLineBreak = true;
				kDrawInfo.nOffSetY = LimitedMarginY;
				LimitedMarginY = 0;
				wnd.InsertTooltipDrawItem(kDrawInfo);
			}
			else if((kProductInfo.iMinBirthday > 0))
			{
				strTemp = ((((("[" $ GetSystemString(5149)) $ "] ") $ BR_ConvertTimeToStr(kProductInfo.iMinBirthday, 1)) $ " ") $ GetSystemString(5153));
				MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
				kDrawInfo.bLineBreak = true;
				kDrawInfo.nOffSetY = LimitedMarginY;
				LimitedMarginY = 0;
				wnd.InsertTooltipDrawItem(kDrawInfo);
			}
			else if((kProductInfo.iMaxBirthday > 0))
			{
				strTemp = ((((("[" $ GetSystemString(5149)) $ "] ") $ BR_ConvertTimeToStr(kProductInfo.iMaxBirthday, 1)) $ " ") $ GetSystemString(1037));
				MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
				kDrawInfo.bLineBreak = true;
				kDrawInfo.nOffSetY = LimitedMarginY;
				LimitedMarginY = 0;
				wnd.InsertTooltipDrawItem(kDrawInfo);
			}
		}
		if(((kProductInfo.iMinLevel > 0) || (kProductInfo.iMaxLevel > 0)))
		{
			if(((kProductInfo.iMinLevel > 0) && (kProductInfo.iMaxLevel > kProductInfo.iMinLevel)))
			{
				strTemp = ((((((((("[" $ GetSystemString(5145)) $ "] ") $ string(kProductInfo.iMinLevel)) $ "") $ GetSystemString(537)) $ "~ ") $ string(kProductInfo.iMaxLevel)) $ "") $ GetSystemString(537));
				MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
				kDrawInfo.bLineBreak = true;
				kDrawInfo.nOffSetY = LimitedMarginY;
				wnd.InsertTooltipDrawItem(kDrawInfo);
			}
			else if((kProductInfo.iMinLevel == kProductInfo.iMaxLevel))
			{
				strTemp = ((((("[" $ GetSystemString(5145)) $ "] ") $ string(kProductInfo.iMinLevel)) $ "") $ GetSystemString(537));
				MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
				kDrawInfo.bLineBreak = true;
				kDrawInfo.nOffSetY = LimitedMarginY;
				wnd.InsertTooltipDrawItem(kDrawInfo);
			}
			else if((kProductInfo.iMinLevel > 0))
			{
				strTemp = ((("[" $ GetSystemString(5145)) $ "] ") $ MakeFullSystemMsg(GetSystemMessage(6170), string(kProductInfo.iMinLevel), ""));
				MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
				kDrawInfo.bLineBreak = true;
				kDrawInfo.nOffSetY = LimitedMarginY;
				wnd.InsertTooltipDrawItem(kDrawInfo);
			}
			else if((kProductInfo.iMaxLevel > 0))
			{
				strTemp = ((("[" $ GetSystemString(5145)) $ "] ") $ MakeFullSystemMsg(GetSystemMessage(6171), string(kProductInfo.iMaxLevel), ""));
				MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
				kDrawInfo.bLineBreak = true;
				kDrawInfo.nOffSetY = LimitedMarginY;
				wnd.InsertTooltipDrawItem(kDrawInfo);
			}
		}
		if((bTimeLimit != 0))
		{
			strTemp = ((((((((((((("[" $ GetSystemString(5029)) $ "] ") $ ZERO_STR(kProductInfo.iStartHour)) $ string(kProductInfo.iStartHour)) $ ":") $ ZERO_STR(kProductInfo.iStartMin)) $ string(kProductInfo.iStartMin)) $ "~") $ ZERO_STR(kProductInfo.iEndHour)) $ string(kProductInfo.iEndHour)) $ ":") $ ZERO_STR(kProductInfo.iEndMin)) $ string(kProductInfo.iEndMin));
			MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
			kDrawInfo.bLineBreak = true;
			kDrawInfo.nOffSetY = LimitedMarginY;
			wnd.InsertTooltipDrawItem(kDrawInfo);
			LimitedMarginY = 0;
		}
		if((kProductInfo.iDayWeek != 127))
		{
			strTemp = ((("[" $ GetSystemString(5028)) $ "] ") $ ConvertBRCashShopDayWeek(kProductInfo.iDayWeek));
			MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
			kDrawInfo.bLineBreak = true;
			kDrawInfo.nOffSetY = LimitedMarginY;
			wnd.InsertTooltipDrawItem(kDrawInfo);
			LimitedMarginY = 0;
		}
		if((kProductInfo.iSale_Percent > 0))
		{
			strTemp = ((((("[" $ GetSystemString(5141)) $ "] ") $ string(kProductInfo.iSale_Percent)) $ "") $ GetSystemString(5132));
			MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
			kDrawInfo.bLineBreak = true;
			kDrawInfo.nOffSetY = LimitedMarginY;
			wnd.InsertTooltipDrawItem(kDrawInfo);
		}
		if((BR_GetDayType(kProductInfo.iEndSale, 0) < 2037))
		{
			strTemp = ((("[" $ GetSystemString(5035)) $ "] ") $ BR_ConvertTimeToStr(kProductInfo.iStartSale, bTimeLimit));
			MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
			kDrawInfo.bLineBreak = true;
			kDrawInfo.nOffSetY = LimitedMarginY;
			LimitedMarginY = 0;
			wnd.InsertTooltipDrawItem(kDrawInfo);
			strTemp = ("             ~ " $ BR_ConvertTimeToStr(kProductInfo.iEndSale, bTimeLimit));
			MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
			kDrawInfo.bLineBreak = true;
			kDrawInfo.nOffSetY = LimitedMarginY;
			LimitedMarginY = 0;
			wnd.InsertTooltipDrawItem(kDrawInfo);
		}
	}
	if((Len(kProductInfo.strDesc) > 0))
	{
		MakeDrawTooltipInfo_Desc(kDrawInfo, kProductInfo.strDesc, 220, 220, 220);
		kDrawInfo.nOffSetY = 12;
		wnd.InsertTooltipDrawItem(kDrawInfo);
	}
	if((kProductInfo.itemarray.Length <= 1))
	{
		i = 0;
		while((i < kProductInfo.itemarray.Length))
		{
			SetTooltipProductItemInfo(wnd, kProductInfo.itemarray[i]);
			i++;
		}
	}
	else
	{
		SetTooltipProductItem(wnd, kProductInfo);
		MakeDrawPanelInfo_Desc(kDrawInfo, GetSystemMessage(6118), 228, 218, 188, 256);
		kDrawInfo.nOffSetY = 6;
		wnd.InsertTooltipDrawItem(kDrawInfo);
	}
	return;
}

function SetTooltipProductItem(WindowHandle wnd, ProductInfo kProductInfo)
{
	local int i;
	local ItemInfo kItemInfo;
	local DrawItemInfo kDrawInfo;
	local ProductItem item;

	MakeDrawInfo_Image(kDrawInfo, kProductInfo.strIconName, 32, 32);
	kDrawInfo.nOffSetY = 12;
	kDrawInfo.bLineBreak = true;
	wnd.InsertTooltipDrawItem(kDrawInfo);
	MakeDrawTooltipInfo_Desc(kDrawInfo, kProductInfo.strName, 227, 197, 80);
	kDrawInfo.bLineBreak = false;
	kDrawInfo.nOffSetY = 16;
	kDrawInfo.nOffSetX = 6;
	wnd.InsertTooltipDrawItem(kDrawInfo);
	MakeDrawInfo_Text(kDrawInfo, GetSystemString(5064), 220, 220, 128);
	kDrawInfo.bLineBreak = true;
	kDrawInfo.nOffSetY = 12;
	wnd.InsertTooltipDrawItem(kDrawInfo);
	i = 0;
	while((i < kProductInfo.itemarray.Length))
	{
		item = kProductInfo.itemarray[i];
		Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(item.iItemID), kItemInfo);
		MakeDrawTooltipInfo_Desc(kDrawInfo, kItemInfo.Name, 200, 200, 200);
		kDrawInfo.bLineBreak = true;
		kDrawInfo.nOffSetX = 16;
		kDrawInfo.nOffSetY = 2;
		kDrawInfo.t_MaxWidth = (256 - 16);
		wnd.InsertTooltipDrawItem(kDrawInfo);
		i++;
	}
	return;
}

function SetTooltipProductItemInfo(WindowHandle wnd, ProductItem item)
{
	local string strWeight, strTrade, strTemp, strNum;
	local ItemInfo kItemInfo;
	local DrawItemInfo kDrawInfo;
	local bool IsPremium;
	local int nHeight, nWidth;
	local Color NameColor;

	NameColor.R = 200;
	NameColor.G = 200;
	NameColor.B = 200;
	NameColor.A = 255;
	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(item.iItemID), kItemInfo);
	MakeDrawInfo_Image(kDrawInfo, kItemInfo.IconName, 32, 32);
	kDrawInfo.nOffSetY = 12;
	kDrawInfo.bLineBreak = true;
	wnd.InsertTooltipDrawItem(kDrawInfo);
	if((kItemInfo.IsBRPremium == 2))
	{
		IsPremium = MakeCashItemIcon(kDrawInfo);
		if((IsPremium == true))
		{
			kDrawInfo.nOffSetX = 6;
			kDrawInfo.nOffSetY = 16;
			wnd.InsertTooltipDrawItem(kDrawInfo);
		}
	}
	if((Len(kItemInfo.AdditionalName) > 0))
	{
		strTemp = ((("" $ kItemInfo.Name) $ " ") $ kItemInfo.AdditionalName);
	}
	else
	{
		strTemp = kItemInfo.Name;
	}
	MakeDrawTooltipInfo_Desc(kDrawInfo, strTemp, 227, 197, 80);
	kDrawInfo.bLineBreak = false;
	kDrawInfo.nOffSetY = 16;
	if((IsPremium == false))
	{
		kDrawInfo.nOffSetX = 6;
	}
	wnd.InsertTooltipDrawItem(kDrawInfo);
	if((item.iAmount > 1))
	{
		strNum = ((GetSystemString(192) $ " : ") $ string(item.iAmount));
		MakeDrawInfo_Text(kDrawInfo, strNum, 200, 200, 200);
		kDrawInfo.nOffSetY = 6;
		kDrawInfo.bLineBreak = true;
		wnd.InsertTooltipDrawItem(kDrawInfo);
	}
	strWeight = (((((GetSystemString(52) $ " : ") $ string(item.iWeight)) $ " (") $ GetSystemString(468)) $ ")");
	MakeDrawInfo_Text(kDrawInfo, strWeight, 200, 200, 200);
	if((item.iAmount <= 1))
	{
		kDrawInfo.nOffSetY = 6;
	}
	kDrawInfo.bLineBreak = true;
	wnd.InsertTooltipDrawItem(kDrawInfo);
	if((item.iTradable == 0))
	{
		strTrade = GetSystemString(1491);
		MakeDrawInfo_Text(kDrawInfo, strTrade, 200, 200, 200);
		kDrawInfo.bLineBreak = true;
		wnd.InsertTooltipDrawItem(kDrawInfo);
	}
	if((Len(item.strDesc) > 0))
	{
		MakeDrawTooltipInfo_Desc(kDrawInfo, item.strDesc, 220, 220, 220);
		kDrawInfo.nOffSetY = 12;
		wnd.InsertTooltipDrawItem(kDrawInfo);
	}
	return;
}

function SetNewProductInfo(DrawPanelHandle wnd, int iID, int Price, string ItemName, string Desc)
{
	local ProductInfo kProductInfo;
	local string strTemp;
	local DrawItemInfo kDrawInfo;
	local int LimitedMarginY, bTimeLimit;

	MakeDrawPanelInfo_Desc(kDrawInfo, ItemName, 227, 197, 80, 256);
	wnd.InsertDrawItem(kDrawInfo);
	kProductInfo = GetProductItem(iID);
	strTemp = SetPaymentTypeDetail(kProductInfo.iPaymentType, Price);
	MakeDrawInfo_Text(kDrawInfo, strTemp, 220, 220, 220);
	kDrawInfo.bLineBreak = true;
	kDrawInfo.nOffSetY = 6;
	wnd.InsertDrawItem(kDrawInfo);
	if((kProductInfo.iProductID >= 0))
	{
		LimitedMarginY = 6;
		bTimeLimit = 0;
		if(!((((kProductInfo.iStartHour == 0) && (kProductInfo.iStartMin == 0)) && (kProductInfo.iEndHour == 23)) && (kProductInfo.iEndMin == 59)))
		{
			bTimeLimit = 1;
		}
		if((kProductInfo.iMaxStock > 0))
		{
			if(((int(GetLanguage()) == 8) || (int(GetLanguage()) == 9)))
			{
				strTemp = ((((("[" $ GetSystemString(5133)) $ "] ") $ GetSystemString(5027)) $ ": ") $ string(kProductInfo.iStock));
				MakeDrawPanelInfo_Desc(kDrawInfo, strTemp, 199, 47, 44, 256);
			}
			else
			{
				strTemp = ((((((((("[" $ GetSystemString(5133)) $ "] ") $ string(kProductInfo.iMaxStock)) $ "") $ GetSystemString(5131)) $ " ") $ GetSystemString(5027)) $ ": ") $ string(kProductInfo.iStock));
				MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
			}
			kDrawInfo.bLineBreak = true;
			kDrawInfo.nOffSetY = LimitedMarginY;
			wnd.InsertDrawItem(kDrawInfo);
			LimitedMarginY = 0;
		}
		if(((kProductInfo.iRestrictionDay >= 1) && (kProductInfo.iAvailableCount >= 1)))
		{
			strTemp = ((("[" $ GetSystemString(5150)) $ "] \\n") $ MakeFullSystemMsg(GetSystemMessage(6164), string(kProductInfo.iRestrictionDay), string(kProductInfo.iAvailableCount)));
			MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
			kDrawInfo.bLineBreak = true;
			kDrawInfo.nOffSetY = LimitedMarginY;
			wnd.InsertDrawItem(kDrawInfo);
		}
		if(((kProductInfo.iRestrictionDay < 0) && (kProductInfo.iAvailableCount >= 1)))
		{
			strTemp = ((("[" $ GetSystemString(5150)) $ "] ") $ MakeFullSystemMsg(GetSystemMessage(6165), string(kProductInfo.iAvailableCount), ""));
			MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
			kDrawInfo.bLineBreak = true;
			kDrawInfo.nOffSetY = LimitedMarginY;
			wnd.InsertDrawItem(kDrawInfo);
		}
		if(((kProductInfo.iMinBirthday > 0) || (kProductInfo.iMaxBirthday > 0)))
		{
			if(((kProductInfo.iMinBirthday > 0) && (kProductInfo.iMaxBirthday > 0)))
			{
				strTemp = ((("[" $ GetSystemString(5149)) $ "] ") $ BR_ConvertTimeToStr(kProductInfo.iMinBirthday, 1));
				MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
				kDrawInfo.bLineBreak = true;
				kDrawInfo.nOffSetY = LimitedMarginY;
				LimitedMarginY = 0;
				wnd.InsertDrawItem(kDrawInfo);
				strTemp = ("             ~ " $ BR_ConvertTimeToStr(kProductInfo.iMaxBirthday, 1));
				MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
				kDrawInfo.bLineBreak = true;
				kDrawInfo.nOffSetY = LimitedMarginY;
				LimitedMarginY = 0;
				wnd.InsertDrawItem(kDrawInfo);
			}
			else if((kProductInfo.iMinBirthday > 0))
			{
				strTemp = ((((("[" $ GetSystemString(5149)) $ "] ") $ BR_ConvertTimeToStr(kProductInfo.iMinBirthday, 1)) $ " ") $ GetSystemString(5153));
				MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
				kDrawInfo.bLineBreak = true;
				kDrawInfo.nOffSetY = LimitedMarginY;
				LimitedMarginY = 0;
				wnd.InsertDrawItem(kDrawInfo);
			}
			else if((kProductInfo.iMaxBirthday > 0))
			{
				strTemp = ((((("[" $ GetSystemString(5149)) $ "] ") $ BR_ConvertTimeToStr(kProductInfo.iMaxBirthday, 1)) $ " ") $ GetSystemString(1037));
				MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
				kDrawInfo.bLineBreak = true;
				kDrawInfo.nOffSetY = LimitedMarginY;
				LimitedMarginY = 0;
				wnd.InsertDrawItem(kDrawInfo);
			}
		}
		if(((kProductInfo.iMinLevel > 0) || (kProductInfo.iMaxLevel > 0)))
		{
			if(((kProductInfo.iMinLevel > 0) && (kProductInfo.iMaxLevel > kProductInfo.iMinLevel)))
			{
				strTemp = ((((((((("[" $ GetSystemString(5145)) $ "] ") $ string(kProductInfo.iMinLevel)) $ "") $ GetSystemString(537)) $ "~ ") $ string(kProductInfo.iMaxLevel)) $ "") $ GetSystemString(537));
				MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
				kDrawInfo.bLineBreak = true;
				kDrawInfo.nOffSetY = LimitedMarginY;
				wnd.InsertDrawItem(kDrawInfo);
			}
			else if((kProductInfo.iMinLevel == kProductInfo.iMaxLevel))
			{
				strTemp = ((((("[" $ GetSystemString(5145)) $ "] ") $ string(kProductInfo.iMinLevel)) $ "") $ GetSystemString(537));
				MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
				kDrawInfo.bLineBreak = true;
				kDrawInfo.nOffSetY = LimitedMarginY;
				wnd.InsertDrawItem(kDrawInfo);
			}
			else if((kProductInfo.iMinLevel > 0))
			{
				strTemp = ((("[" $ GetSystemString(5145)) $ "] ") $ MakeFullSystemMsg(GetSystemMessage(6170), string(kProductInfo.iMinLevel), ""));
				MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
				kDrawInfo.bLineBreak = true;
				kDrawInfo.nOffSetY = LimitedMarginY;
				wnd.InsertDrawItem(kDrawInfo);
			}
			else if((kProductInfo.iMaxLevel > 0))
			{
				strTemp = ((("[" $ GetSystemString(5145)) $ "] ") $ MakeFullSystemMsg(GetSystemMessage(6171), string(kProductInfo.iMaxLevel), ""));
				MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
				kDrawInfo.bLineBreak = true;
				kDrawInfo.nOffSetY = LimitedMarginY;
				wnd.InsertDrawItem(kDrawInfo);
			}
		}
		if((bTimeLimit != 0))
		{
			strTemp = ((((((((((((("[" $ GetSystemString(5029)) $ "] ") $ ZERO_STR(kProductInfo.iStartHour)) $ string(kProductInfo.iStartHour)) $ ":") $ ZERO_STR(kProductInfo.iStartMin)) $ string(kProductInfo.iStartMin)) $ "~") $ ZERO_STR(kProductInfo.iEndHour)) $ string(kProductInfo.iEndHour)) $ ":") $ ZERO_STR(kProductInfo.iEndMin)) $ string(kProductInfo.iEndMin));
			MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
			kDrawInfo.bLineBreak = true;
			kDrawInfo.nOffSetY = LimitedMarginY;
			wnd.InsertDrawItem(kDrawInfo);
			LimitedMarginY = 0;
		}
		if((kProductInfo.iDayWeek != 127))
		{
			strTemp = ((("[" $ GetSystemString(5028)) $ "] ") $ ConvertBRCashShopDayWeek(kProductInfo.iDayWeek));
			MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
			kDrawInfo.bLineBreak = true;
			kDrawInfo.nOffSetY = LimitedMarginY;
			wnd.InsertDrawItem(kDrawInfo);
			LimitedMarginY = 0;
		}
		if((kProductInfo.iSale_Percent > 0))
		{
			strTemp = ((((("[" $ GetSystemString(5141)) $ "] ") $ string(kProductInfo.iSale_Percent)) $ "") $ GetSystemString(5132));
			MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
			kDrawInfo.bLineBreak = true;
			kDrawInfo.nOffSetY = LimitedMarginY;
			wnd.InsertDrawItem(kDrawInfo);
		}
		if((BR_GetDayType(kProductInfo.iEndSale, 0) < 2037))
		{
			strTemp = ((("[" $ GetSystemString(5035)) $ "] ") $ BR_ConvertTimeToStr(kProductInfo.iStartSale, bTimeLimit));
			MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
			kDrawInfo.bLineBreak = true;
			kDrawInfo.nOffSetY = LimitedMarginY;
			LimitedMarginY = 0;
			wnd.InsertDrawItem(kDrawInfo);
			strTemp = ("             ~ " $ BR_ConvertTimeToStr(kProductInfo.iEndSale, bTimeLimit));
			MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
			kDrawInfo.bLineBreak = true;
			kDrawInfo.nOffSetY = LimitedMarginY;
			LimitedMarginY = 0;
			wnd.InsertDrawItem(kDrawInfo);
		}
	}
	if((Len(Desc) > 0))
	{
		MakeDrawPanelInfo_Desc(kDrawInfo, Desc, 220, 220, 220, 256);
		kDrawInfo.nOffSetY = 12;
		wnd.InsertDrawItem(kDrawInfo);
	}
	return;
}

function AddEachProductInfo(DrawPanelHandle wnd, int iID, int iAmount, string ItemName, string IconName, string Desc, int Weight, int TRADE)
{
	local string strWeight, strTrade, strTemp, strNum;
	local ItemInfo kItemInfo;
	local DrawItemInfo kDrawInfo;
	local bool IsPremium;
	local int nHeight, nWidth;
	local Color NameColor;
	local int i;

	NameColor.R = 200;
	NameColor.G = 200;
	NameColor.B = 200;
	NameColor.A = 255;
	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(iID), kItemInfo);
	MakeDrawInfo_Image(kDrawInfo, IconName, 32, 32);
	kDrawInfo.nOffSetY = 12;
	kDrawInfo.bLineBreak = true;
	wnd.InsertDrawItem(kDrawInfo);
	if((kItemInfo.IsBRPremium == 2))
	{
		IsPremium = MakeCashItemIcon(kDrawInfo);
		if((IsPremium == true))
		{
			kDrawInfo.nOffSetX = 6;
			kDrawInfo.nOffSetY = 16;
			wnd.InsertDrawItem(kDrawInfo);
		}
	}
	if((Len(kItemInfo.AdditionalName) > 0))
	{
		strTemp = ((("" $ ItemName) $ " ") $ kItemInfo.AdditionalName);
	}
	else
	{
		strTemp = ItemName;
	}
	MakeDrawPanelInfo_Desc(kDrawInfo, strTemp, 227, 197, 80, 256);
	kDrawInfo.bLineBreak = false;
	kDrawInfo.nOffSetY = 16;
	if((IsPremium == false))
	{
		kDrawInfo.nOffSetX = 6;
	}
	wnd.InsertDrawItem(kDrawInfo);
	if((iAmount > 1))
	{
		strNum = ((GetSystemString(192) $ " : ") $ string(iAmount));
		MakeDrawInfo_Text(kDrawInfo, strNum, 200, 200, 200);
		kDrawInfo.nOffSetY = 6;
		kDrawInfo.bLineBreak = true;
		wnd.InsertDrawItem(kDrawInfo);
	}
	strWeight = (((((GetSystemString(52) $ " : ") $ string(Weight)) $ " (") $ GetSystemString(468)) $ ")");
	MakeDrawInfo_Text(kDrawInfo, strWeight, 200, 200, 200);
	if((iAmount <= 1))
	{
		kDrawInfo.nOffSetY = 6;
	}
	kDrawInfo.bLineBreak = true;
	wnd.InsertDrawItem(kDrawInfo);
	if((TRADE == 0))
	{
		strTrade = GetSystemString(1491);
		MakeDrawInfo_Text(kDrawInfo, strTrade, 200, 200, 200);
		kDrawInfo.bLineBreak = true;
		wnd.InsertDrawItem(kDrawInfo);
	}
	if((Len(Desc) > 0))
	{
		MakeDrawPanelInfo_Desc(kDrawInfo, Desc, 220, 220, 220, 256);
		kDrawInfo.nOffSetY = 12;
		wnd.InsertDrawItem(kDrawInfo);
	}
	if((kItemInfo.IncludeItem[0] > 0))
	{
		MakeDrawInfo_Text(kDrawInfo, GetSystemString(5064), 220, 220, 128);
		kDrawInfo.bLineBreak = true;
		kDrawInfo.nOffSetY = 12;
		wnd.InsertDrawItem(kDrawInfo);
		i = 0;
		while(((kItemInfo.IncludeItem[i] > 0) && (i < 10)))
		{
			MakeDrawInfo_TextLink(kDrawInfo, kItemInfo.IncludeItem[i], 200, 200, 200);
			kDrawInfo.bLineBreak = true;
			kDrawInfo.nOffSetX = 16;
			kDrawInfo.nOffSetY = 2;
			kDrawInfo.t_MaxWidth = (256 - 16);
			wnd.InsertDrawItem(kDrawInfo);
			Debug(("========id : " $ string(kItemInfo.IncludeItem[i])));
			i = (i + 1);
		}
	}
	return;
}

function bool MakeCashItemIcon(out DrawItemInfo Info)
{
	local string TextureName;

	Info = m_kDrawInfoClear;
	TextureName = GetPrimeItemSymbolName();
	if((Len(TextureName) > 0))
	{
		Info.eType = DIT_TEXTURE;
		Info.nOffSetX = 0;
		Info.nOffSetY = 0;
		Info.u_nTextureWidth = 16;
		Info.u_nTextureHeight = 16;
		Info.u_nTextureUWidth = 16;
		Info.u_nTextureUHeight = 16;
		Info.u_strTexture = TextureName;
		return true;
	}
	return false;
}

function MakeText(out DrawItemInfo Info, string Str)
{
	Info = m_kDrawInfoClear;
	Info.eType = DIT_TEXT;
	Info.t_bDrawOneLine = true;
	Info.t_color.R = 255;
	Info.t_color.G = 255;
	Info.t_color.B = 255;
	Info.t_color.A = 255;
	Info.t_strText = Str;
	return;
}

function MakeDrawInfo_Text(out DrawItemInfo Info, string Str, int R, int G, int B)
{
	Info = m_kDrawInfoClear;
	Info.eType = DIT_TEXT;
	Info.t_bDrawOneLine = true;
	Info.t_color.R = byte(R);
	Info.t_color.G = byte(G);
	Info.t_color.B = byte(B);
	Info.t_color.A = 255;
	Info.t_strText = Str;
	return;
}

function MakeDrawTooltipInfo_Desc(out DrawItemInfo Info, string Str, int R, int G, int B)
{
	local array<TextSectionInfo> TextInfos;
	local string FullText;

	Info = m_kDrawInfoClear;
	GetItemTextSectionInfos(Str, FullText, TextInfos);
	if((TextInfos.Length > 0))
	{
		Str = FullText;
		Info.t_SectionList = TextInfos;
	}
	Info.eType = DIT_TEXT;
	Info.bLineBreak = true;
	Info.t_bDrawOneLine = false;
	Info.t_MaxWidth = 256;
	Info.t_color.R = byte(R);
	Info.t_color.G = byte(G);
	Info.t_color.B = byte(B);
	Info.t_color.A = 255;
	Info.t_strText = Str;
	return;
}

function MakeDrawPanelInfo_Desc(out DrawItemInfo Info, string Str, int R, int G, int B, int MaxWidth)
{
	local array<TextSectionInfo> TextInfos;
	local string FullText;

	Info = m_kDrawInfoClear;
	GetItemTextSectionInfos(Str, FullText, TextInfos);
	if((TextInfos.Length > 0))
	{
		Str = FullText;
		Info.t_SectionList = TextInfos;
	}
	Info.eType = DIT_TEXT;
	Info.bLineBreak = true;
	Info.t_bDrawOneLine = false;
	Info.t_MaxWidth = MaxWidth;
	Info.t_color.R = byte(R);
	Info.t_color.G = byte(G);
	Info.t_color.B = byte(B);
	Info.t_color.A = 255;
	Info.t_strText = Str;
	return;
}

function bool MakeDrawInfo_Image(out DrawItemInfo Info, string TextureName, int Width, int Height)
{
	Info = m_kDrawInfoClear;
	if((Len(TextureName) > 0))
	{
		Info.eType = DIT_TEXTURE;
		Info.nOffSetX = 0;
		Info.nOffSetY = 0;
		Info.u_nTextureWidth = Width;
		Info.u_nTextureHeight = Height;
		Info.u_nTextureUWidth = Width;
		Info.u_nTextureUHeight = Height;
		Info.u_strTexture = TextureName;
		return true;
	}
	return false;
}

function MakeDrawInfo_Blank(out DrawItemInfo Info, int Height)
{
	Info = m_kDrawInfoClear;
	Info.eType = DIT_BLANK;
	Info.b_nHeight = Height;
	return;
}

function MakeDrawInfo_TextLink(out DrawItemInfo Info, int Id, int R, int G, int B)
{
	Info = m_kDrawInfoClear;
	Info.eType = DIT_TEXTLINK;
	Info.t_ID = Id;
	Info.t_color.R = byte(R);
	Info.t_color.G = byte(G);
	Info.t_color.B = byte(B);
	Info.t_color.A = 255;
	Info.t_strText = "";
	return;
}

function string ZERO_STR(int Num)
{
	if((Num < 10))
	{
		return "0";
	}
	else
	{
		return "";
	}
}

function int ConvertPreItemPanelType(EPreItemPanelType Type)
{
	if((int(Type) == 0))
	{
		return 0;
	}
	else if((int(Type) == 1))
	{
		return 1;
	}
	else if((int(Type) == 2))
	{
		return 2;
	}
	else if((int(Type) == 3))
	{
		return 3;
	}
	else if((int(Type) == 4))
	{
		return 4;
	}
	return 0;
}

function ProductItemSort(UIEventManager.EBR_CashShopProduct ProductType, int eSortType, bool bSortDesc)
{
	local int iCount;

	if((int(ProductType) == 0))
	{
		iCount = (m_ProductList.Length - 1);
	}
	else if((int(ProductType) == 1))
	{
		iCount = (m_RecentList.Length - 1);
	}
	else if((int(ProductType) == 2))
	{
		iCount = (m_BasketList.Length - 1);
	}
	if((eSortType == 0))
	{
		quicksortIndex(ProductType, 0, iCount, bSortDesc);
		NewProductItemSort(bSortDesc);
	}
	else if((eSortType == 1))
	{
		quicksortIndex(ProductType, 0, iCount, false);
		quicksortPrice(ProductType, 0, iCount, bSortDesc);
	}
	else if((eSortType == 2))
	{
		quickSortChar(ProductType, 0, iCount, bSortDesc);
	}
	return;
}

function NewProductItemSort(bool bSortDesc)
{
	local int i, Size;
	local array<ProductInfo> NewProductList, TempProductList;

	i = 0;
	while((i < m_ProductList.Length))
	{
		if(((m_ProductList[i].iPanel_Type - 1) == ConvertPreItemPanelType(PIPT_NEW)))
		{
			Size = (NewProductList.Length + 1);
			NewProductList[(Size - 1)] = m_ProductList[i];
			i++;
			continue;
		}
		Size = (TempProductList.Length + 1);
		TempProductList[(Size - 1)] = m_ProductList[i];
		i++;
	}
	if(bSortDesc)
	{
		if((NewProductList.Length > 0))
		{
			m_ProductList.Length = 0;
			i = 0;
			while((i < NewProductList.Length))
			{
				Size = (m_ProductList.Length + 1);
				m_ProductList[(Size - 1)] = NewProductList[i];
				i++;
			}
			i = 0;
			while((i < TempProductList.Length))
			{
				Size = (m_ProductList.Length + 1);
				m_ProductList[(Size - 1)] = TempProductList[i];
				i++;
			}
		}
	}
	else if((NewProductList.Length > 0))
	{
		m_ProductList.Length = 0;
		i = 0;
		while((i < TempProductList.Length))
		{
			Size = (m_ProductList.Length + 1);
			m_ProductList[(Size - 1)] = TempProductList[i];
			i++;
		}
		i = 0;
		while((i < NewProductList.Length))
		{
			Size = (m_ProductList.Length + 1);
			m_ProductList[(Size - 1)] = NewProductList[i];
			i++;
		}
	}
	return;
}

function swap(UIEventManager.EBR_CashShopProduct ProductType, int i, int j)
{
	local ProductInfo ProductItem;

	if((int(ProductType) == 0))
	{
		ProductItem = m_ProductList[i];
		m_ProductList[i] = m_ProductList[j];
		m_ProductList[j] = ProductItem;
	}
	else if((int(ProductType) == 1))
	{
		ProductItem = m_RecentList[i];
		m_RecentList[i] = m_RecentList[j];
		m_RecentList[j] = ProductItem;
	}
	else if((int(ProductType) == 2))
	{
		ProductItem = m_BasketList[i];
		m_BasketList[i] = m_BasketList[j];
		m_BasketList[j] = ProductItem;
	}
	return;
}

function int partitionIndex(UIEventManager.EBR_CashShopProduct ProductType, int Low, int High, bool Desc)
{
	local int pivot, i, j;
	local ProductInfo ProductItem;

	ProductItem = ArraySortProductItem(ProductType, Low);
	pivot = ProductItem.iProductID;
	j = Low;
	i = (Low + 1);
	while((i <= High))
	{
		if(Desc)
		{
			if((ArraySortProductItem(ProductType, i).iProductID > pivot))
			{
				j++;
				swap(ProductType, i, j);
			}
			i++;
			continue;
		}
		if((ArraySortProductItem(ProductType, i).iProductID < pivot))
		{
			j++;
			swap(ProductType, i, j);
		}
		i++;
	}
	swap(ProductType, Low, j);
	return j;
}

function quicksortIndex(UIEventManager.EBR_CashShopProduct ProductType, int Left, int Right, bool Desc)
{
	local int q;

	if(((Right - Left) == 0))
	{
		return;
	}
	else if((Left < Right))
	{
		q = partitionIndex(ProductType, Left, Right, Desc);
		quicksortIndex(ProductType, Left, (q - 1), Desc);
		quicksortIndex(ProductType, (q + 1), Right, Desc);
	}
	return;
}

function int partitionPrice(UIEventManager.EBR_CashShopProduct ProductType, int Low, int High, bool Desc)
{
	local int pivot, i, j;
	local ProductInfo ProductItem;

	ProductItem = ArraySortProductItem(ProductType, Low);
	pivot = ProductItem.iPrice;
	j = Low;
	i = (Low + 1);
	while((i <= High))
	{
		if(Desc)
		{
			if((ArraySortProductItem(ProductType, i).iPrice > pivot))
			{
				j++;
				swap(ProductType, i, j);
			}
			i++;
			continue;
		}
		if((ArraySortProductItem(ProductType, i).iPrice < pivot))
		{
			j++;
			swap(ProductType, i, j);
		}
		i++;
	}
	swap(ProductType, Low, j);
	return j;
}

function quicksortPrice(UIEventManager.EBR_CashShopProduct ProductType, int Left, int Right, bool Desc)
{
	local int q;

	if(((Right - Left) == 0))
	{
		return;
	}
	else if((Left < Right))
	{
		q = partitionPrice(ProductType, Left, Right, Desc);
		quicksortPrice(ProductType, Left, (q - 1), Desc);
		quicksortPrice(ProductType, (q + 1), Right, Desc);
	}
	return;
}

function int partitionChar(UIEventManager.EBR_CashShopProduct ProductType, int Low, int High, bool Desc)
{
	local string pivot, temp;
	local int i, j;
	local ProductInfo ProductItem;

	ProductItem = ArraySortProductItem(ProductType, Low);
	pivot = Caps(ProductItem.strName);
	j = Low;
	i = (Low + 1);
	while((i <= High))
	{
		temp = Caps(ArraySortProductItem(ProductType, i).strName);
		if(Desc)
		{
			if((temp > pivot))
			{
				j++;
				swap(ProductType, i, j);
			}
			i++;
			continue;
		}
		if((temp < pivot))
		{
			j++;
			swap(ProductType, i, j);
		}
		i++;
	}
	swap(ProductType, Low, j);
	return j;
}

function quickSortChar(UIEventManager.EBR_CashShopProduct ProductType, int Left, int Right, bool Desc)
{
	local int q;

	if(((Right - Left) == 0))
	{
		return;
	}
	else if((Left < Right))
	{
		q = partitionChar(ProductType, Left, Right, Desc);
		quickSortChar(ProductType, Left, (q - 1), Desc);
		quickSortChar(ProductType, (q + 1), Right, Desc);
	}
	return;
}

function ProductInfo ArraySortProductItem(UIEventManager.EBR_CashShopProduct ProductType, int i)
{
	local ProductInfo ProductItem;

	if((int(ProductType) == 0))
	{
		ProductItem = m_ProductList[i];
	}
	else if((int(ProductType) == 1))
	{
		ProductItem = m_RecentList[i];
	}
	else if((int(ProductType) == 2))
	{
		ProductItem = m_BasketList[i];
	}
	return ProductItem;
}

function string SetPaymentTypeDetail(int iPaymentType, int iPrice)
{
	local string strTemp;
	local float priceMoney;

	if((iPaymentType == 0))
	{
		if(m_bCoinToMoney)
		{
			priceMoney = (float(iPrice) * m_fCoinMoneyValue);
			strTemp = ((((GetSystemString(190) $ " : ") $ string(priceMoney)) $ " ") $ GetSystemString(5012));
		}
		else
		{
			strTemp = ((((GetSystemString(190) $ " : ") $ string(iPrice)) $ " ") $ GetSystemString(5012));
		}
	}
	else if((iPaymentType == 1))
	{
		strTemp = ((((GetSystemString(190) $ " : ") $ string(iPrice)) $ " ") $ GetSystemString(469));
	}
	else if((iPaymentType == 2))
	{
		strTemp = ((((GetSystemString(190) $ " : ") $ string(iPrice)) $ " ") $ GetSystemString(5179));
	}
	return strTemp;
}

function string SetPaymentType(int iPaymentType, int iPrice)
{
	local string strTemp;
	local float priceMoney;

	if((iPaymentType == 0))
	{
		if(m_bCoinToMoney)
		{
			priceMoney = (float(iPrice) * m_fCoinMoneyValue);
			strTemp = ((string(priceMoney) $ " ") $ GetSystemString(5012));
		}
		else
		{
			strTemp = ((string(iPrice) $ " ") $ GetSystemString(5012));
		}
	}
	else if((iPaymentType == 1))
	{
		strTemp = ((string(iPrice) $ " ") $ GetSystemString(469));
	}
	else if((iPaymentType == 2))
	{
		strTemp = ((string(iPrice) $ " ") $ GetSystemString(5179));
	}
	return strTemp;
}

function string ErrorResultBuy(int iResult)
{
	local string sysmeg;

	switch(iResult)
	{
		case -7:
		case -8:
			sysmeg = GetSystemMessage(6003);
			break;
		case -1:
			sysmeg = GetSystemMessage(6005);
			break;
		case -2:
		case -5:
			sysmeg = GetSystemMessage(6008);
			break;
		case -4:
			sysmeg = GetSystemMessage(6006);
			break;
		case -9:
		case -11:
			sysmeg = GetSystemMessage(6007);
			break;
		case -10:
			sysmeg = GetSystemMessage(6009);
			break;
		case -12:
			sysmeg = GetSystemMessage(6019);
			break;
		case -13:
			sysmeg = GetSystemMessage(6020);
			break;
		case -14:
			sysmeg = GetSystemMessage(350);
			break;
		case -17:
			sysmeg = GetSystemMessage(3002);
			break;
		case -18:
			sysmeg = GetSystemMessage(3019);
			break;
		case -19:
			sysmeg = GetSystemMessage(2968);
			break;
		case -20:
			sysmeg = GetSystemMessage(3077);
			break;
		case -21:
			sysmeg = GetSystemMessage(3082);
			break;
		case -22:
			sysmeg = GetSystemMessage(6070);
			break;
		case -23:
			sysmeg = GetSystemMessage(6098);
			break;
		case -24:
			sysmeg = GetSystemMessage(6129);
			break;
		case -25:
			sysmeg = GetSystemMessage(279);
			break;
		case -26:
			sysmeg = GetSystemMessage(6144);
			break;
		case -27:
			sysmeg = GetSystemMessage(6155);
			break;
		case -28:
			sysmeg = GetSystemMessage(6823);
			break;
		case -3:
			sysmeg = GetSystemMessage(351);
			break;
		case -6:
		default:
			sysmeg = ((GetSystemMessage(6002) $ " errorcode:") $ string(iResult));
			break;
	}
	return sysmeg;
}
