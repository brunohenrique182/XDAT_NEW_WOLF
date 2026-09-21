class BR_NewPresentBuyingWnd extends UICommonAPI;

const FEE_OFFSET_Y_EQUIP = -18;
const DIALOG_RESULT_SUCCESS = 303;
const DIALOG_RESULT_FAILURE = 304;
const DIALOG_PRODUCT_QUANTITY = 351;
const ITEM_INFO_WIDTH = 256;
const ITEM_INFO_LEFT_MARGIN = 10;
const ITEM_INFO_BLANK_HEIGHT = 10;
const MAX_BUY_COUNT = 99;
const DIALOG_ONLY_NOTICE = 5555;
const DIALOG_NOTIFY_SEND_PRESENTBUY = 4444;
const MAX_CHAR_LENGTH = 24;
const MAX_TITLE_LENGTH = 60;
const MAX_CONTENTS_LENGTH = 1000;

var bool m_bDrawBg;
var bool m_bInConfirm;
var bool bOpenCashShopReceiverListWnd;
var int m_iProductID;
var int m_iPrice;
var int m_iAmount;
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
var ButtonHandle btnCancel;
var ButtonHandle BtnBuy;
var ButtonHandle BtnCharge;
var ButtonHandle BtnChange;
var TextureHandle TexPriceInfoBG;
var TextureHandle TexItemInfoBG;
var WindowHandle BR_NewCashShopReceiverListWnd;
var EditBoxHandle ReceiverID;
var MultiEditBoxHandle PresentPostContents;
var EditBoxHandle EditBuyCount;
var WindowHandle ScrollItemInfo;
var int m_iCurrentHeight;
var DrawItemInfo m_kDrawInfoClear;
var DrawPanelHandle m_hDrawPanel;
var BR_CashShopAPI m_CashShopAPI;

function OnLoad()
{
	RegisterState("BR_NewPresentBuyingWnd", "TRAININGROOMSTATE");
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	m_bInConfirm = false;
	bOpenCashShopReceiverListWnd = false;
	m_iAmount = 1;
	InitHandle();
	BtnChange.HideWindow();
	m_CashShopAPI = BR_CashShopAPI(GetScript("BR_CashShopAPI"));
	ClearAll();
	return;
}

function InitHandle()
{
	if((1 == 0))
	{
		Me = GetHandle("BR_NewPresentBuyingWnd");
		EditBuyCount = EditBoxHandle(GetHandle("BR_NewPresentBuyingWnd.EditBuyCount"));
		BtnChange = ButtonHandle(GetHandle("BR_NewPresentBuyingWnd.BtnChange"));
		BR_NewCashShopReceiverListWnd = GetHandle("BR_NewCashShopReceiverListWnd");
		TextCurCash = TextBoxHandle(GetHandle("BR_NewPresentBuyingWnd.TextCurCash"));
		TextBalance = TextBoxHandle(GetHandle("BR_NewPresentBuyingWnd.TextBalance"));
		TextPrice = TextBoxHandle(GetHandle("BR_NewPresentBuyingWnd.TextPrice"));
		btnCancel = ButtonHandle(GetHandle("BR_NewPresentBuyingWnd.BtnCancel"));
		BtnBuy = ButtonHandle(GetHandle("BR_NewPresentBuyingWnd.BtnBuy"));
		BtnCharge = ButtonHandle(GetHandle("BR_NewPresentBuyingWnd.BtnCharge"));
		TexPriceInfoBG = TextureHandle(GetHandle("BR_NewPresentBuyingWnd.TexPriceInfoBG"));
		TexItemInfoBG = TextureHandle(GetHandle("BR_NewPresentBuyingWnd.TexItemInfoBG"));
		ReceiverID = EditBoxHandle(GetHandle("BR_NewPresentBuyingWnd.ReceiverID"));
		PresentPostContents = MultiEditBoxHandle(GetHandle("BR_NewPresentBuyingWnd.PresentPostContents"));
		ScrollItemInfo = GetHandle("BR_NewPresentBuyingWnd.ScrollItemInfo");
	}
	else
	{
		Me = GetWindowHandle("BR_NewPresentBuyingWnd");
		EditBuyCount = GetEditBoxHandle("BR_NewPresentBuyingWnd.EditBuyCount");
		BtnChange = GetButtonHandle("BR_NewPresentBuyingWnd.BtnChange");
		BR_NewCashShopReceiverListWnd = GetWindowHandle("BR_NewCashShopReceiverListWnd");
		TextCurCash = GetTextBoxHandle("BR_NewPresentBuyingWnd.TextCurCash");
		TextBalance = GetTextBoxHandle("BR_NewPresentBuyingWnd.TextBalance");
		TextPrice = GetTextBoxHandle("BR_NewPresentBuyingWnd.TextPrice");
		btnCancel = GetButtonHandle("BR_NewPresentBuyingWnd.BtnCancel");
		BtnBuy = GetButtonHandle("BR_NewPresentBuyingWnd.BtnBuy");
		BtnCharge = GetButtonHandle("BR_NewPresentBuyingWnd.BtnCharge");
		TexPriceInfoBG = GetTextureHandle("BR_NewPresentBuyingWnd.TexPriceInfoBG");
		TexItemInfoBG = GetTextureHandle("BR_NewPresentBuyingWnd.TexItemInfoBG");
		ReceiverID = GetEditBoxHandle("BR_NewPresentBuyingWnd.ReceiverID");
		PresentPostContents = GetMultiEditBoxHandle("BR_NewPresentBuyingWnd.PresentPostContents");
		ScrollItemInfo = GetWindowHandle("BR_NewPresentBuyingWnd.ScrollItemInfo");
	}
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(9031);
	RegisterEvent(9041);
	RegisterEvent(9072);
	RegisterEvent(9073);
	RegisterEvent(9050);
	RegisterEvent(9051);
	RegisterEvent(9061);
	RegisterEvent(1710);
	return;
}

function ClearAll()
{
	ReceiverID.SetString("");
	ReceiverID.SetMaxLength(24);
	PresentPostContents.SetString("");
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
		case "CharacterReceiverListBtn":
			OnReceiverListButton();
			break;
		case "CharacterNameResetBtn":
			OnReceiverIDReset();
			break;
		case "BtnChange":
			break;
		default:
			break;
	}
	return;
}

function OnReceiverIDReset()
{
	ReceiverID.SetString("");
	return;
}

function PostListUpdate()
{
	Class'NWindow.PostWndAPI'.static.RequestFriendList();
	Class'NWindow.PostWndAPI'.static.RequestPledgeMemberList();
	Class'NWindow.PostWndAPI'.static.RequestPostFriendList();
	return;
}

function SetBoolCashShopReceiverList(bool B)
{
	local BR_NewCashShopReceiverListWnd Script;

	bOpenCashShopReceiverListWnd = B;
	if((bOpenCashShopReceiverListWnd == false))
	{
		Script = BR_NewCashShopReceiverListWnd(GetScript("BR_NewCashShopReceiverListWnd"));
		Script.selectedInit();
		BR_NewCashShopReceiverListWnd.HideWindow();
	}
	return;
}

function OnReceiverListButton()
{
	local BR_NewCashShopReceiverListWnd Script;

	Script = BR_NewCashShopReceiverListWnd(GetScript("BR_NewCashShopReceiverListWnd"));
	bOpenCashShopReceiverListWnd = !bOpenCashShopReceiverListWnd;
	Debug(("OnNewReceiverListButton OpenCashShopReceiverListWnd " $ string(bOpenCashShopReceiverListWnd)));
	if(bOpenCashShopReceiverListWnd)
	{
		BR_NewCashShopReceiverListWnd.ShowWindow();
		PostListUpdate();
	}
	else
	{
		Script.selectedInit();
		BR_NewCashShopReceiverListWnd.HideWindow();
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
		case 9061:
			ParseInt(param, "Result", iResult);
			ResultBuy(iResult, m_iGamePoint);
			break;
		case 9072:
			Debug(("EV_BR_PRESENT_SHOW_CONFIRM : " $ param));
			ParseInt(param, "ID", m_iProductID);
			ParseInt(param, "Price", m_iPrice);
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
			ShowPresentBuyWindow(true);
			m_bInConfirm = false;
			ClearItemInfo();
			RequestBR_ProductInfo(m_iProductID, true);
			ClearAll();
			CalculateBalance();
			break;
		case 9031:
			ParseInt(param, "ID", iID);
			ParseInt(param, "Price", Price);
			ParseString(param, "ItemName", ItemName);
			ParseString(param, "Desc", Desc);
			ClearItemInfo();
			m_CashShopAPI.SetNewProductInfo(m_hDrawPanel, iID, Price, ItemName, Desc);
			break;
		case 9041:
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
			ShowPresentBuyWindow(false);
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
				EditBuyCount.SetString(("" $ string(m_iAmount)));
			}
		}
		else if((Id == 4444))
		{
			m_bInConfirm = true;
			RequestBR_PresentBuyProduct(m_iProductID, m_iAmount, ReceiverID.GetString(), PresentPostContents.GetString());
			return true;
		}
		else if(((Id == 304) || (Id == 303)))
		{
			ShowPresentBuyWindow(false);
			m_bInConfirm = false;
			RequestBR_ProductList(BRCSP_PRODUCT);
			RequestBR_ProductList(BRCSP_BASKET);
			RequestBR_ProductList(BRCSP_RECENT);
		}
	}
	return false;
}

function OnHide()
{
	DialogHide();
	ExecuteEvent(9073);
	PlaySound("InterfaceSound.inventory_close_01");
	m_bInConfirm = false;
	return;
}

function OnShow()
{
	CalculateBalance();
	ReceiverID.SetFocus();
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

function OnbtnCancelClick()
{
	ShowPresentBuyWindow(false);
	m_bInConfirm = false;
	return;
}

function OnBtnBuyClick()
{
	if((Len(PresentPostContents.GetString()) > 1000))
	{
		DialogHide();
		DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3076));
		DialogSetID(5555);
	}
	else if((Len(ReceiverID.GetString()) > 24))
	{
		DialogHide();
		DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3074));
		DialogSetID(5555);
	}
	else if(((m_iProductID > 0) && (m_iAmount > 0)))
	{
		DialogHide();
		DialogShow(DialogModalType_Modal, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(6064), ReceiverID.GetString()));
		DialogSetID(4444);
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
	return;
}

function ResultBuy(int iResult, INT64 iGamePoint)
{
	local string sysmeg;

	if((iResult == 1))
	{
		m_iGamePoint = iGamePoint;
		CalculateBalance();
		DialogSetID(303);
		DialogSetDefaultOK();
		DialogShow(DialogModalType_Modal, DialogType_OK, GetSystemMessage(6071));
	}
	else
	{
		sysmeg = m_CashShopAPI.ErrorResultBuy(iResult);
		DialogSetID(304);
		DialogSetDefaultOK();
		DialogShow(DialogModalType_Modal, DialogType_OK, sysmeg);
	}
	return;
}

function ShowPresentBuyWindow(bool bShow)
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
		SetBoolCashShopReceiverList(false);
	}
	return;
}

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	if((int(nKey) == 9))
	{
		if(ReceiverID.IsFocused())
		{
			PresentPostContents.SetFocus();
		}
	}
	return false;
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
	EditBuyCount.SetString(("" $ string(m_iAmount)));
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
