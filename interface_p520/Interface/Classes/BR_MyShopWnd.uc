class BR_MyShopWnd extends UICommonAPI;

const DIALOG_PRODUCT_QUANTITY = 351;
const DIALOG_CLOSED_SHOP = 352;
const DIALOG_BASKET_ALL_CLEAR = 353;
const ITEM_INFO_WIDTH = 256;
const PAGE_MAX = 5;

var int m_iCurrentHeight;
var DrawItemInfo m_kDrawInfoClear;
var array<ProductInfo> m_CurrentProductList;
var int m_nCurrentTabPage;
var int m_iCurrentTabTotalPage;
var bool m_bCoinToMoney;
var float m_fCoinMoneyValue;
var int m_iCurrentTab;
var WindowHandle Me;
var TabHandle TabCategory;
var array<WindowHandle> BR_MyShop_Item;
var ButtonHandle BtnClear;
var TextBoxHandle TextViewPageNum;
var BR_CashShopAPI m_CashShopAPI;

function OnRegisterEvent()
{
	RegisterEvent(9032);
	RegisterEvent(9033);
	RegisterEvent(9021);
	RegisterEvent(9013);
	RegisterEvent(9014);
	RegisterEvent(1710);
	return;
}

function OnLoad()
{
	RegisterState("BR_MyShopWnd", "TRAININGROOMSTATE");
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	InitHandle();
	Initialize();
	return;
}

function InitHandle()
{
	if((1 == 0))
	{
		Me = GetHandle("BR_MyShopWnd");
		BtnClear = ButtonHandle(GetHandle("BR_MyShopWnd.BtnClear"));
		TabCategory = TabHandle(GetHandle("BR_MyShopWnd.TabCategory"));
		BR_MyShop_Item.Length = 5;
		BR_MyShop_Item[0] = GetHandle("BR_MyShopWnd.CashItemData_1");
		BR_MyShop_Item[1] = GetHandle("BR_MyShopWnd.CashItemData_2");
		BR_MyShop_Item[2] = GetHandle("BR_MyShopWnd.CashItemData_3");
		BR_MyShop_Item[3] = GetHandle("BR_MyShopWnd.CashItemData_4");
		BR_MyShop_Item[4] = GetHandle("BR_MyShopWnd.CashItemData_5");
		TextViewPageNum = TextBoxHandle(GetHandle("BR_MyShopWnd.TextViewPageNum"));
	}
	else
	{
		Me = GetWindowHandle("BR_MyShopWnd");
		BtnClear = GetButtonHandle("BR_MyShopWnd.BtnClear");
		TabCategory = GetTabHandle("BR_MyShopWnd.TabCategory");
		BR_MyShop_Item.Length = 5;
		BR_MyShop_Item[0] = GetWindowHandle("BR_MyShopWnd.CashItemData_1");
		BR_MyShop_Item[1] = GetWindowHandle("BR_MyShopWnd.CashItemData_2");
		BR_MyShop_Item[2] = GetWindowHandle("BR_MyShopWnd.CashItemData_3");
		BR_MyShop_Item[3] = GetWindowHandle("BR_MyShopWnd.CashItemData_4");
		BR_MyShop_Item[4] = GetWindowHandle("BR_MyShopWnd.CashItemData_5");
		TextViewPageNum = GetTextBoxHandle("BR_MyShopWnd.TextViewPageNum");
	}
	return;
}

function Initialize()
{
	m_iCurrentTab = 0;
	m_bCoinToMoney = IsBr_CashShopCoinToMoney();
	if(m_bCoinToMoney)
	{
		m_fCoinMoneyValue = GetBr_CashShopCoinToMoneyValue();
	}
	m_CurrentProductList.Length = 0;
	m_nCurrentTabPage = 0;
	m_iCurrentTabTotalPage = 0;
	TabCategory.SetButtonName(2, "");
	TabCategory.SetDisable(2, true);
	TabCategory.SetButtonDisableTexture(2, "L2UI_CT1.tab.Tab_DF_Bg_line");
	m_CashShopAPI = BR_CashShopAPI(GetScript("BR_CashShopAPI"));
	return;
}

function selectedInit()
{
	m_CashShopAPI.ClearBasketItemList();
	m_CashShopAPI.ClearRecentList();
	RequestBR_ProductList(BRCSP_RECENT);
	RequestBR_ProductList(BRCSP_BASKET);
	return;
}

function OnEvent(int Event_ID, string param)
{
	local int iResult, ProductID;

	switch(Event_ID)
	{
		case 9032:
			HandleAddBasketProduct(param);
			break;
		case 9013:
			if((m_iCurrentTab == 1))
			{
				OnTabList(m_CashShopAPI.GetRecentProductList(), true);
			}
			break;
		case 9014:
			if((m_iCurrentTab == 0))
			{
				OnTabList(m_CashShopAPI.GetBasketProductList(), false);
			}
			break;
		case 9021:
			ParseInt(param, "Option", iResult);
			if((iResult == -1))
			{
				PrepareProductList(iResult);
			}
			break;
		case 9033:
			ParseInt(param, "ID", ProductID);
			RequestBR_DeleteBasketProductInfo(ProductID);
			m_CashShopAPI.DeleteBasketProductItem(ProductID);
			if((m_iCurrentTab == 0))
			{
				OnTabList(m_CashShopAPI.GetBasketProductList(), false);
			}
			break;
		case 1710:
			HandleDialogOK();
			break;
		default:
			break;
	}
	return;
}

function OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	local int SelectedProductID;
	local string btnName;

	if((a_ButtonHandle == none))
	{
		return;
	}
	if(m_CashShopAPI.GetOpenBuyWnd())
	{
		return;
	}
	btnName = a_ButtonHandle.GetWindowName();
	SelectedProductID = a_ButtonHandle.GetButtonValue();
	if((SelectedProductID < 0))
	{
		return;
	}
	switch(btnName)
	{
		case "BtnBuy":
			Debug(("OnClickButtonWithHandle BtnBuy" $ string(SelectedProductID)));
			m_CashShopAPI.OnBtnBuyClick(SelectedProductID);
			break;
		case "BtnPresent":
			Debug(("OnClickButtonWithHandle BtnPresent" $ string(SelectedProductID)));
			m_CashShopAPI.OnBtnPresentClick(SelectedProductID);
			break;
		case "BtnDelete":
			Debug(("OnClickButtonWithHandle BtnDelete" $ string(SelectedProductID)));
			OnBtnDeleteClick(SelectedProductID);
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "BtnClear":
			OnBtnClear();
			Debug("BtnClear");
			break;
		case "BtnViewPreEnd":
			if((m_nCurrentTabPage > 1))
			{
				m_nCurrentTabPage = 1;
				SetViewProductList();
			}
			Debug("BtnViewPreEnd");
			break;
		case "BtnViewPre":
			if((m_nCurrentTabPage > 1))
			{
				m_nCurrentTabPage = (m_nCurrentTabPage - 1);
				SetViewProductList();
			}
			Debug("BtnViewPre");
			break;
		case "BtnViewNext":
			if((m_nCurrentTabPage < m_iCurrentTabTotalPage))
			{
				m_nCurrentTabPage = (m_nCurrentTabPage + 1);
				SetViewProductList();
			}
			Debug("BtnViewNext");
			break;
		case "BtnViewNextEnd":
			if((m_nCurrentTabPage != m_iCurrentTabTotalPage))
			{
				m_nCurrentTabPage = m_iCurrentTabTotalPage;
				SetViewProductList();
			}
			Debug("BtnViewNextEnd");
			break;
		case "TabCategory0":
			OnTabList(m_CashShopAPI.GetBasketProductList(), false);
			break;
		case "TabCategory1":
			OnTabList(m_CashShopAPI.GetRecentProductList(), true);
			break;
		default:
			break;
	}
	return;
}

function ClearItemList()
{
	local int i;

	m_CurrentProductList.Length = 0;
	i = 0;
	while((i < 5))
	{
		BR_MyShop_Item[i].HideWindow();
		i++;
	}
	return;
}

function HandleAddBasketProduct(string param)
{
	local int ProductID;

	ParseInt(param, "ID", ProductID);
	m_CashShopAPI.AddMyShopBasketProductItem(ProductID);
	RequestBR_AddBasketProductInfo(ProductID);
	if(Me.IsShowWindow())
	{
		if((m_iCurrentTab == 0))
		{
			OnTabList(m_CashShopAPI.GetBasketProductList(), false);
		}
	}
	return;
}

function HandleDialogOK()
{
	local int Id, Num;
	local WindowHandle m_BuyWnd;

	if(DialogIsMine())
	{
		Id = DialogGetID();
		Num = int(DialogGetString());
		if((Id == 353))
		{
			if((m_iCurrentTab == 0))
			{
				RequestBR_DeleteBasketProductInfo(0);
				m_CashShopAPI.ClearBasketItemList();
				OnTabList(m_CashShopAPI.GetBasketProductList(), false);
				ExecuteEvent(9035);
			}
		}
		else if((Id == 352))
		{
			m_BuyWnd = GetWindowHandle("BR_BuyingWnd");
			if(m_BuyWnd.IsShowWindow())
			{
				m_BuyWnd.HideWindow();
			}
			if(m_hOwnerWnd.IsShowWindow())
			{
				m_hOwnerWnd.HideWindow();
			}
		}
	}
	return;
}

function PrepareProductList(int iOption)
{
	local WindowHandle m_NewBuyWnd;

	ClearItemList();
	if((iOption == -1))
	{
		m_NewBuyWnd = GetWindowHandle("BR_NewBuyingWnd");
		if((m_hOwnerWnd.IsShowWindow() || m_NewBuyWnd.IsShowWindow()))
		{
			DialogSetID(352);
			DialogSetDefaultOK();
			DialogShow(DialogModalType_Modal, DialogType_Warning, MakeFullSystemMsg(GetSystemMessage(1474), GetSystemString(5021)));
		}
	}
	return;
}

function OnTabList(array<ProductInfo> productList, bool Desc)
{
	local int currentindex, i, TotalPage;

	ClearItemList();
	m_iCurrentTab = TabCategory.GetTopIndex();
	Debug(("OnTabList" $ string(productList.Length)));
	i = 0;
	while((i < productList.Length))
	{
		m_CurrentProductList.Length = (m_CurrentProductList.Length + 1);
		currentindex = (m_CurrentProductList.Length - 1);
		m_CurrentProductList[currentindex] = productList[i];
		i++;
	}
	Debug(("OnTabList CurrentProductList" $ string(m_CurrentProductList.Length)));
	if((productList.Length <= 0))
	{
		m_nCurrentTabPage = 1;
		m_iCurrentTabTotalPage = 1;
	}
	else
	{
		TotalPage = int((float(m_CurrentProductList.Length) % 5.0000000));
		if((TotalPage > 0))
		{
			m_iCurrentTabTotalPage = ((m_CurrentProductList.Length / 5) + 1);
		}
		else
		{
			m_iCurrentTabTotalPage = (m_CurrentProductList.Length / 5);
		}
		m_nCurrentTabPage = 1;
	}
	if((m_iCurrentTab == 1))
	{
		BtnClear.HideWindow();
	}
	else
	{
		BtnClear.ShowWindow();
	}
	SetViewProductList();
	return;
}

function SetViewProductList()
{
	local int i, j;
	local ProductInfo Info;
	local bool visableDelete;

	if((m_iCurrentTab == 1))
	{
		visableDelete = false;
	}
	else
	{
		visableDelete = true;
	}
	Debug(("OnTabList m_iCurrentTab" $ string(m_iCurrentTab)));
	j = 0;
	i = ((m_nCurrentTabPage - 1) * 5);
	while((i < (m_nCurrentTabPage * 5)))
	{
		BR_MyShop_Item[j].HideWindow();
		if((i < m_CurrentProductList.Length))
		{
			Info = m_CurrentProductList[i];
			m_CashShopAPI.SetViewProductWindow(BR_MyShop_Item[j], Info, true, visableDelete);
			BR_MyShop_Item[j].ShowWindow();
		}
		j++;
		i++;
	}
	TextViewPageNum.SetText(((("" $ string(m_nCurrentTabPage)) $ "/") $ string(m_iCurrentTabTotalPage)));
	return;
}

function OnBtnClear()
{
	if(m_CashShopAPI.GetOpenBuyWnd())
	{
		return;
	}
	DialogSetID(353);
	DialogSetDefaultOK();
	DialogShow(DialogModalType_Modal, DialogType_Warning, GetSystemMessage(6115));
	return;
}

function OnBtnDeleteClick(int ProductID)
{
	local string strParam;

	m_CashShopAPI.DeleteBasketProductItem(ProductID);
	RequestBR_DeleteBasketProductInfo(ProductID);
	ParamAdd(strParam, "ID", string(ProductID));
	ExecuteEvent(9034, strParam);
	if((m_iCurrentTab == 0))
	{
		if(Me.IsShowWindow())
		{
			OnTabList(m_CashShopAPI.GetBasketProductList(), false);
		}
	}
	return;
}
