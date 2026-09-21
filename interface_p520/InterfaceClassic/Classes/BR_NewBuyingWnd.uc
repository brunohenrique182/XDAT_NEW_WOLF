class BR_NewBuyingWnd extends UICommonAPI;

const CASHSHOPPAYMENTTYPE_CASH = 0;
const CASHSHOPPAYMENTTYPE_ADENA = 1;
const CASHSHOPPAYMENTTYPE_EVENTCOIN = 2;
const FEE_OFFSET_Y_EQUIP = -18;
const DIALOG_RESULT_SUCCESS = 301;
const DIALOG_RESULT_FAILURE = 302;
const DIALOG_PRODUCT_QUANTITY = 351;
const ITEM_INFO_WIDTH = 256;
const ITEM_INFO_LEFT_MARGIN = 10;
const ITEM_INFO_BLANK_HEIGHT = 10;
const MAX_BUY_COUNT = 99;

var bool m_bDrawBg;
var bool m_bInConfirm;
var int m_iProductID;
var int m_iPrice;
var int m_iAmount;
var int m_iPaymentType;
var string m_strName;
var string m_strIconName;
var INT64 m_iGamePoint;
var INT64 m_iAdena;
var INT64 m_iEventCoin;
var bool m_bCoinToMoney;
var float m_fCoinMoneyValue;
var WindowHandle Me;
var TextBoxHandle TextCurCash;
var TextBoxHandle TextBalance;
var TextBoxHandle TextPrice;
var WindowHandle ScrollItemInfo;
var ButtonHandle btnCancel;
var ButtonHandle BtnBuy;
var ButtonHandle BtnCharge;
var TextureHandle TexPriceInfoBG;
var TextureHandle TexItemInfoBG;
var TextBoxHandle StaticCurCash;
var TextBoxHandle StaticWarning;
var DrawPanelHandle m_hDrawPanel;
var EditBoxHandle EditBuyCount;
var ButtonHandle BtnChange;
var int m_iCurrentHeight;
var DrawItemInfo m_kDrawInfoClear;
var BR_CashShopAPI m_CashShopAPI;

function OnLoad()
{
	RegisterState("BR_NewBuyingWnd", "TRAININGROOMSTATE");
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	m_bInConfirm = false;
	m_iAmount = 1;
	InitHandle();
	BtnChange.HideWindow();
	m_CashShopAPI = BR_CashShopAPI(GetScript("BR_CashShopAPI"));
	return;
}

function InitHandle()
{
	if((1 == 0))
	{
		Me = GetHandle("BR_NewBuyingWnd");
		TextCurCash = TextBoxHandle(GetHandle("BR_NewBuyingWnd.TextCurCash"));
		TextBalance = TextBoxHandle(GetHandle("BR_NewBuyingWnd.TextBalance"));
		TextPrice = TextBoxHandle(GetHandle("BR_NewBuyingWnd.TextPrice"));
		EditBuyCount = EditBoxHandle(GetHandle("BR_NewBuyingWnd.EditBuyCount"));
		BtnChange = ButtonHandle(GetHandle("BR_NewBuyingWnd.BtnChange"));
		ScrollItemInfo = GetHandle("BR_NewBuyingWnd.ScrollItemInfo");
		btnCancel = ButtonHandle(GetHandle("BR_NewBuyingWnd.BtnCancel"));
		BtnBuy = ButtonHandle(GetHandle("BR_NewBuyingWnd.BtnBuy"));
		BtnCharge = ButtonHandle(GetHandle("BR_NewBuyingWnd.BtnCharge"));
		TexPriceInfoBG = TextureHandle(GetHandle("BR_NewBuyingWnd.TexPriceInfoBG"));
		TexItemInfoBG = TextureHandle(GetHandle("BR_NewBuyingWnd.TexItemInfoBG"));
		StaticCurCash = TextBoxHandle(GetHandle("BR_NewBuyingWnd.StaticCurCash"));
		StaticWarning = TextBoxHandle(GetHandle("BR_NewBuyingWnd.StaticWarning"));
	}
	else
	{
		Me = GetWindowHandle("BR_NewBuyingWnd");
		EditBuyCount = GetEditBoxHandle("BR_NewBuyingWnd.EditBuyCount");
		BtnChange = GetButtonHandle("BR_NewBuyingWnd.BtnChange");
		TextCurCash = GetTextBoxHandle("BR_NewBuyingWnd.TextCurCash");
		TextBalance = GetTextBoxHandle("BR_NewBuyingWnd.TextBalance");
		TextPrice = GetTextBoxHandle("BR_NewBuyingWnd.TextPrice");
		ScrollItemInfo = GetWindowHandle("BR_NewBuyingWnd.ScrollItemInfo");
		btnCancel = GetButtonHandle("BR_NewBuyingWnd.BtnCancel");
		BtnBuy = GetButtonHandle("BR_NewBuyingWnd.BtnBuy");
		BtnCharge = GetButtonHandle("BR_NewBuyingWnd.BtnCharge");
		TexPriceInfoBG = GetTextureHandle("BR_NewBuyingWnd.TexPriceInfoBG");
		TexItemInfoBG = GetTextureHandle("BR_NewBuyingWnd.TexItemInfoBG");
		StaticCurCash = GetTextBoxHandle("BR_NewBuyingWnd.StaticCurCash");
		StaticWarning = GetTextBoxHandle("BR_NewBuyingWnd.StaticWarning");
	}
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(9030);
	RegisterEvent(9040);
	RegisterEvent(9070);
	RegisterEvent(9071);
	RegisterEvent(9050);
	RegisterEvent(9051);
	RegisterEvent(9060);
	RegisterEvent(1710);
	return;
}

function OnClickButton(string Name)
{
	if(m_bInConfirm)
	{
		return;
	}
	switch(Name)
	{
		case "BtnCancel":
			OnbtnCancelClick();
			break;
		case "BtnBuy":
			OnBtnBuyClick();
			break;
		case "BtnCharge":
			OnBtnChargeClick();
			break;
		case "BtnChange":
			break;
		default:
			break;
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	local int iResult, iCoinToMoney, iID;
	local string Desc, ItemName;
	local int Price, Weight, iAmount;
	local string IconName;
	local int TRADE;

	switch(Event_ID)
	{
		case 9050:
			ParseINT64(param, "GamePoint", m_iGamePoint);
			if((m_bInConfirm == false))
			{
				CalculateBalance();
			}
			break;
		case 9051:
			ParseINT64(param, "Adena", m_iAdena);
			ParseINT64(param, "EventCoin", m_iEventCoin);
			break;
		case 9060:
			ParseInt(param, "Result", iResult);
			ResultBuy(iResult, m_iGamePoint);
			break;
		case 9070:
			Debug(("EV_BR_SHOW_CONFIRM : " $ param));
			ParseInt(param, "ID", m_iProductID);
			ParseInt(param, "Price", m_iPrice);
			ParseInt(param, "PaymentType", m_iPaymentType);
			ParseString(param, "ItemName", m_strName);
			ParseString(param, "IconName", m_strIconName);
			ParseInt(param, "CoinToMoney", iCoinToMoney);
			if((iCoinToMoney == 0))
			{
				m_bCoinToMoney = false;
			}
			else
			{
				m_bCoinToMoney = true;
				ParseFloat(param, "CoinToMoneyValue", m_fCoinMoneyValue);
			}
			ShowBuyWindow(true);
			m_bInConfirm = false;
			ClearItemInfo();
			CalculateBalance();
			RequestBR_ProductInfo(m_iProductID, false);
			break;
		case 9030:
			ParseInt(param, "ID", iID);
			ParseInt(param, "Price", Price);
			ParseString(param, "ItemName", ItemName);
			ParseString(param, "Desc", Desc);
			ClearItemInfo();
			m_CashShopAPI.SetNewProductInfo(m_hDrawPanel, iID, Price, ItemName, Desc);
			break;
		case 9040:
			ParseInt(param, "ID", iID);
			ParseInt(param, "Amount", iAmount);
			ParseString(param, "ItemName", ItemName);
			ParseString(param, "IconName", IconName);
			ParseString(param, "Desc", Desc);
			ParseInt(param, "Weight", Weight);
			ParseInt(param, "Trade", TRADE);
			m_CashShopAPI.AddEachProductInfo(m_hDrawPanel, iID, iAmount, ItemName, IconName, Desc, Weight, TRADE);
			ResetScrollHeight();
			break;
		case 1710:
			if(HandleDialogOK())
			{
				return;
			}
			ShowBuyWindow(false);
			m_bInConfirm = false;
			break;
		case 1720:
			m_bInConfirm = false;
			break;
		default:
			break;
	}
	return;
}

function bool HandleDialogOK()
{
	local int Id, Num;

	if(DialogIsMine())
	{
		Id = DialogGetID();
		Debug(("HandleDialogOK  " $ string(Id)));
		if((Id == 351))
		{
			Num = int(DialogGetString());
			if((Num > 0))
			{
				if((Num > 99))
				{
					Num = 99;
				}
				m_iAmount = Num;
				EditBuyCount.SetString(string(m_iAmount));
			}
			CalculateBalance();
		}
		else if(((Id == 302) || (Id == 301)))
		{
			ShowBuyWindow(false);
			m_bInConfirm = false;
			RequestBR_ProductList(BRCSP_PRODUCT);
			RequestBR_ProductList(BRCSP_BASKET);
			RequestBR_ProductList(BRCSP_RECENT);
		}
	}
	else
	{
		return false;
	}
	return true;
}

function OnHide()
{
	DialogHide();
	ExecuteEvent(9071);
	PlaySound("InterfaceSound.inventory_close_01");
	m_bInConfirm = false;
	return;
}

function OnShow()
{
	CalculateBalance();
	return;
}

function OnChangeEditBox(string strID)
{
	local string strCount;

	if((strID == "EditBuyCount"))
	{
		strCount = EditBuyCount.GetString();
		m_iAmount = int(strCount);
		if((m_iAmount > 99))
		{
			m_iAmount = 99;
			EditBuyCount.SetString(string(m_iAmount));
		}
		CalculateBalance();
	}
	return;
}

function OnbtnCancelClick()
{
	ShowBuyWindow(false);
	m_bInConfirm = false;
	ClearItemInfo();
	return;
}

function OnBtnBuyClick()
{
	if(((m_iProductID > 0) && (m_iAmount > 0)))
	{
		m_bInConfirm = true;
		RequestBR_BuyProduct(m_iProductID, m_iAmount);
	}
	return;
}

function OnBtnInputQuantity()
{
	local ProductInfo ProductItem;

	ProductItem = m_CashShopAPI.GetProductItem(m_iProductID);
	if((ProductItem.iProductID > 0))
	{
		DialogSetID(351);
		DialogSetDefaultOK();
		DialogSetParamInt64(INT64(99));
		DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(570), ProductItem.strName, ""));
	}
	return;
}

function OnBtnChargeClick()
{
	if(IsUseSteam())
	{
		CashShopCoinChargeForSteam();
	}
	else
	{
		ShowCashChargeWebSite();
	}
	RequestBR_GamePoint();
	return;
}

function CalculateBalance()
{
	local INT64 iTotalPrice, iBalance;

	iTotalPrice = INT64((m_iPrice * m_iAmount));
	if((m_iPaymentType == 0))
	{
		iBalance = (m_iGamePoint - iTotalPrice);
		if(m_bCoinToMoney)
		{
			TextPrice.SetText(((("" $ string((float(iTotalPrice) * m_fCoinMoneyValue))) $ " ") $ GetSystemString(5012)));
			TextCurCash.SetText(((("" $ string((float(m_iGamePoint) * m_fCoinMoneyValue))) $ " ") $ GetSystemString(5012)));
			TextBalance.SetText(((("" $ string((float(iBalance) * m_fCoinMoneyValue))) $ " ") $ GetSystemString(5012)));
		}
		else
		{
			TextPrice.SetText(((("" $ string(iTotalPrice)) $ " ") $ GetSystemString(5012)));
			TextCurCash.SetText(((("" $ string(m_iGamePoint)) $ " ") $ GetSystemString(5012)));
			TextBalance.SetText(((("" $ string(iBalance)) $ " ") $ GetSystemString(5012)));
		}
		StaticCurCash.SetText(GetSystemString(5014));
		StaticWarning.ShowWindow();
		BtnCharge.ShowWindow();
		btnCancel.MoveC(104, 376);
		BtnBuy.MoveC(6, 376);
	}
	else if((m_iPaymentType == 1))
	{
		iBalance = (m_iAdena - iTotalPrice);
		TextPrice.SetText(((("" $ string(iTotalPrice)) $ " ") $ GetSystemString(469)));
		TextCurCash.SetText(((("" $ string(m_iAdena)) $ " ") $ GetSystemString(469)));
		TextBalance.SetText(((("" $ string(iBalance)) $ " ") $ GetSystemString(469)));
		StaticWarning.HideWindow();
		StaticCurCash.SetText(GetSystemString(3001));
		BtnCharge.HideWindow();
		btnCancel.MoveC(154, 376);
		BtnBuy.MoveC(56, 376);
	}
	else if((m_iPaymentType == 2))
	{
		iBalance = (m_iEventCoin - iTotalPrice);
		TextPrice.SetText(((("" $ string(iTotalPrice)) $ " ") $ GetSystemString(5179)));
		TextCurCash.SetText(((("" $ string(m_iEventCoin)) $ " ") $ GetSystemString(5179)));
		TextBalance.SetText(((("" $ string(iBalance)) $ " ") $ GetSystemString(5179)));
		StaticWarning.HideWindow();
		StaticCurCash.SetText(GetSystemString(5180));
		BtnCharge.HideWindow();
		btnCancel.MoveC(154, 376);
		BtnBuy.MoveC(56, 376);
	}
	return;
}

function ResultBuy(int iResult, INT64 iGamePoint)
{
	local string sysmeg;

	if((iResult == 1))
	{
		m_iGamePoint = iGamePoint;
		CalculateBalance();
		DialogSetID(301);
		DialogSetDefaultOK();
		DialogShow(DialogModalType_Modal, DialogType_OK, GetSystemMessage(6001));
	}
	else
	{
		sysmeg = m_CashShopAPI.ErrorResultBuy(iResult);
		DialogSetID(302);
		DialogSetDefaultOK();
		DialogShow(DialogModalType_Modal, DialogType_OK, sysmeg);
	}
	return;
}

function ShowBuyWindow(bool bShow)
{
	m_bDrawBg = true;
	if((bShow == true))
	{
		Me.ShowWindow();
		Me.SetFocus();
		RequestBR_GamePoint();
		PlaySound("InterfaceSound.inventory_open_01");
	}
	else
	{
		Me.HideWindow();
	}
	return;
}

function ClearItemInfo()
{
	if((m_hDrawPanel == none))
	{
		m_hDrawPanel = DrawPanelHandle(ScrollItemInfo.AddChildWnd(XCT_DrawPanel));
		m_hDrawPanel.SetWindowSize(256, 168);
		m_hDrawPanel.Move(10, 10);
		m_hDrawPanel.SetBackTexture("");
	}
	m_hDrawPanel.Clear();
	m_iCurrentHeight = 0;
	ResetScrollHeight();
	m_iAmount = 1;
	EditBuyCount.SetString(string(m_iAmount));
	return;
}

function ResetScrollHeight()
{
	local int iWidth, iHeight;

	m_hDrawPanel.PreCheckPanelSize(iWidth, iHeight);
	m_hDrawPanel.SetWindowSize(256, (iHeight + 16));
	m_iCurrentHeight = iHeight;
	ScrollItemInfo.SetScrollHeight((m_iCurrentHeight + 30));
	ScrollItemInfo.SetScrollPosition(0);
	return;
}
