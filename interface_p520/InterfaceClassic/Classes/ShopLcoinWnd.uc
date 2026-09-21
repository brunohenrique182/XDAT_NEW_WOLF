class ShopLcoinWnd extends UICommonAPI
	dependson(UIPacket);

const DIALOG_ASK_PRICE = 10111;
const MAX_CATEGORY = 16;
const HOME_CATEGORY_INDEX = 0;
const ShopIndex = 3;
const COSTITEMNUM = 3;
const TIMER_CLICK = 99902;
const TIMER_DELAYC = 3000;
const TIMER_FOCUS = 99903;
const TIMER_FOCUS_DELAY = 100;
const MAXITEMNUM = 1000000;
const TAB_MAX = 9;
const NUMIN_PAGE_BIG = 2;
const NUMIN_PAGE_SMALL = 4;
const BUY_WND_SIZE_W_NORMAL = 418;
const BUY_wND_SIZE_H_NORMAL = 324;
const BUY_WND_SIZE_W_RELAY = 418;
const BUY_wND_SIZE_H_RELAY = 412;

struct PLShopItemDataStruct
{
	var int Index;
	var int nSlotNum;
	var int nItemClassID;
	var int nCostItemId[3];
	var INT64 nCostItemAmount[3];
	var int nRemainItemAmount;
	var int nRemainSec;
	var int nRemainServerItemAmount;
	var int sCircleNum;
	var bool isRelay;
};

var WindowHandle Me;
var string m_Windowname;
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
var EditBoxHandle ItemCount_EditBox;
var ButtonHandle Reset_Btn;
var ButtonHandle Buy_Btn;
var ButtonHandle MultiSell_Up_Button;
var ButtonHandle MultiSell_Down_Button;
var ButtonHandle MultiSell_Input_Button;
var WindowHandle ItemInfo_Wnd;
var WindowHandle buy_Wnd;
var WindowHandle disableWnd;
var WindowHandle DisableWndStep2;
var ButtonHandle Refresh_Button;
var TextBoxHandle ItemNum_TextBox;
var WindowHandle ShopDailyConfirm_ResultWnd;
var WindowHandle ShopDailySuccess_ResultWnd;
var WindowHandle ShopDailyFails_ResultWnd;
var TextBoxHandle ReceiveListNumberBig;
var TextBoxHandle ReceiveListNumberSmall;
var ButtonHandle BtnBuyLast;
var HtmlHandle HtmlViewer;
var WebBrowserHandle BannerWebHandle;
var WebBrowserHandle BannerDialogWebHandle;
var ButtonHandle BannerBtn;
var TextureHandle bannerTexture;
var LCoinShopBannerUIData bannerData;
var EditBoxHandle EditBoxFind;
var WindowHandle BannerLink;
var EffectViewportWndHandle Result_EffectViewport;
var WindowHandle BuyRelay_Wnd;
var ButtonHandle BuyItemInfoBtn;
var TextureHandle BuyItemInfoBtnIcon;
var int currentSelectHomeIndex;
var array<PLShopItemDataStruct> pLShopItemDataList;
var array<PLShopItemDataStruct> pLShopItemDataListTemp;
var array<int> homeMainList;
var array<int> homeSubList;
var int currentHomeMainPage;
var int currentHomeSubPage;
var bool isShowRelayBuyWnd;
var StoreURLData _bannerURLInfo;
var UIControlGroupButtonAssets tabGroupButton;
var L2Util util;

function Initialize()
{
	local int i;

	Me = GetWindowHandle(m_Windowname);
	ItemInfo_Wnd = GetWindowHandle((m_Windowname $ ".ItemInfo_Wnd"));
	buy_Wnd = GetWindowHandle((m_Windowname $ ".Buy_Wnd"));
	ListOption_CheckBox = GetCheckBoxHandle((m_Windowname $ ".List_Wnd.ListOption_CheckBox"));
	ItemCount_EditBox = GetEditBoxHandle((m_Windowname $ ".Buy_Wnd.ItemCount_EditBox"));
	EditBoxFind = GetEditBoxHandle((m_Windowname $ ".List_Wnd.EditBoxFind"));
	Reset_Btn = GetButtonHandle((m_Windowname $ ".Buy_Wnd.Reset_Btn"));
	MultiSell_Up_Button = GetButtonHandle((m_Windowname $ ".Buy_Wnd.MultiSell_Up_Button"));
	MultiSell_Down_Button = GetButtonHandle((m_Windowname $ ".Buy_Wnd.MultiSell_Down_Button"));
	MultiSell_Input_Button = GetButtonHandle((m_Windowname $ ".Buy_Wnd.MultiSell_Input_Button"));
	disableWnd = GetWindowHandle((m_Windowname $ ".DisableWnd"));
	DisableWndStep2 = GetWindowHandle((m_Windowname $ ".Buy_Wnd.DisableWndStep2"));
	Refresh_Button = GetButtonHandle((m_Windowname $ ".ListRefresh_Btn"));
	ShopDailyConfirm_ResultWnd = GetWindowHandle((m_Windowname $ ".ShopDailyConfirm_ResultWnd"));
	ItemNum_TextBox = GetTextBoxHandle((m_Windowname $ ".ShopDailyConfirm_ResultWnd.ItemNum_TextBox"));
	ShopDailySuccess_ResultWnd = GetWindowHandle((m_Windowname $ ".ShopDailySuccess_ResultWnd"));
	ShopDailyFails_ResultWnd = GetWindowHandle((m_Windowname $ ".ShopDailyFails_ResultWnd"));
	ReceiveListNumberBig = GetTextBoxHandle((m_Windowname $ ".Home_Wnd.ReceiveListNumberBig"));
	ReceiveListNumberSmall = GetTextBoxHandle((m_Windowname $ ".Home_Wnd.ReceiveListNumberSmall"));
	BtnBuyLast = GetButtonHandle((m_Windowname $ ".Buy_Wnd.BtnBuyLast"));
	HtmlViewer = GetHtmlHandle((m_Windowname $ ".ItemInfo_Wnd.HtmlViewer"));
	bannerTexture = GetTextureHandle((m_Windowname $ ".Home_Wnd.Banner"));
	BannerLink = GetWindowHandle((m_Windowname $ ".BannerLink"));
	BannerWebHandle = GetWebBrowserHandle((m_Windowname $ ".Home_Wnd.Banner_WebBrowser"));
	BannerDialogWebHandle = GetWebBrowserHandle((m_Windowname $ ".BannerLink.BannerLink_WebBrowser"));
	BannerBtn = GetButtonHandle((m_Windowname $ ".Home_Wnd.BtnBanner"));
	Result_EffectViewport = GetEffectViewportWndHandle((m_Windowname $ ".Result_EffectViewport"));
	BuyRelay_Wnd = GetWindowHandle((m_Windowname $ ".Buy_Wnd.BuyRelay_Wnd"));
	BuyItemInfoBtn = GetButtonHandle((m_Windowname $ ".Buy_Wnd.BuyItemInfo_Btn"));
	BuyItemInfoBtn.HideWindow();
	BuyItemInfoBtnIcon = GetTextureHandle((m_Windowname $ ".Buy_Wnd.BtnInfoIcon_Texture"));
	BuyItemInfoBtnIcon.HideWindow();
	InitTabGroupButtons();
	util = L2Util(GetScript("L2Util"));
	i = (0 + 1);
	while((i < 16))
	{
		getListCtrlByCategory(i).SetSelectedSelTooltip(false);
		getListCtrlByCategory(i).SetAppearTooltipAtMouseX(true);
		i++;
	}
	return;
}

function InitTabGroupButtons()
{
	local WindowHandle tabGroupButtonWindow;

	tabGroupButtonWindow = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".LcoinShopList_Tab"));
	tabGroupButton = Class'InterfaceClassic.UIControlGroupButtonAssets'.static._InitScript(tabGroupButtonWindow);
	tabGroupButton._SetStartInfo("L2UI_EPIC.LCoinShopWnd.LCoinShopWndTabBTN_Middle_Unselected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWndTabBTN_Middle_Select", "L2UI_EPIC.LCoinShopWnd.LCoinShopWndTabBTN_Middle_Unselected_Over", true);
	tabGroupButton._GetGroupButtonsInstance().DelegateOnClickButton = OnTabGroupBtnClicked;
	return;
}

function SetTabForm()
{
	local int i;
	local array<PurchaseLimitCraftCategoryUIData> categoryDataArray;
	local PurchaseLimitCraftCategoryUIData categoryData;
	local Color TextColor;
	local TextureHandle RibbonTexture;

	GetPurchaseLimitCraftCategoryDataAll(categoryDataArray, false);
	i = 0;
	while((i < 9))
	{
		GetRibbonTexture(i).HideWindow();
		i++;
	}
	tabGroupButton._GetGroupButtonsInstance()._setButtonTexture(0, "L2UI_EPIC.LCoinShopWnd.LCoinShopWndTabBTN_Left_Unselected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWndTabBTN_Left_Select", "L2UI_EPIC.LCoinShopWnd.LCoinShopWndTabBTN_Left_Unselected_Over");
	i = 1;
	while((i < (categoryDataArray.Length - 1)))
	{
		tabGroupButton._GetGroupButtonsInstance()._setButtonTexture(i, "L2UI_EPIC.LCoinShopWnd.LCoinShopWndTabBTN_Middle_Unselected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWndTabBTN_Middle_Select", "L2UI_EPIC.LCoinShopWnd.LCoinShopWndTabBTN_Middle_Unselected_Over");
		i++;
	}
	tabGroupButton._GetGroupButtonsInstance()._setButtonTexture((categoryDataArray.Length - 1), "L2UI_EPIC.LCoinShopWnd.LCoinShopWndTabBTN_RightBasic_Unselected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWndTabBTN_RightBasic_Select", "L2UI_EPIC.LCoinShopWnd.LCoinShopWndTabBTN_RightBasic_Unselected_Over");
	tabGroupButton._GetGroupButtonsInstance()._setShowButtonNum(categoryDataArray.Length);
	tabGroupButton._GetGroupButtonsInstance()._setAutoWidth(987, 0);
	i = 0;
	while((i < categoryDataArray.Length))
	{
		categoryData = categoryDataArray[i];
		TextColor = GetCategoryTextColor(categoryData.StringColor);
		tabGroupButton._GetGroupButtonsInstance()._setButtonText(i, GetNpcString(categoryData.SysStringId));
		tabGroupButton._GetGroupButtonsInstance()._setButtonValue(i, categoryData.Category);
		tabGroupButton._GetGroupButtonsInstance()._setButtonTextDefaultColor(i, TextColor, TextColor);
		if(((categoryData.RibbonTexture != "") && (i < categoryDataArray.Length)))
		{
			RibbonTexture = GetRibbonTexture(i);
			RibbonTexture.SetTexture(categoryData.RibbonTexture);
			tabGroupButton._GetGroupButtonsInstance()._setTextureLoc(i, RibbonTexture, 0, 3);
			RibbonTexture.ShowWindow();
		}
		i++;
	}
	tabGroupButton._GetGroupButtonsInstance()._setTextureLoc(0, GetTextureHandle((m_Windowname $ ".Tab_HomeIcon")), 0, 14, "center");
	tabGroupButton._GetGroupButtonsInstance()._setEnableAll();
	tabGroupButton._GetGroupButtonsInstance()._setTopOrder(0);
	return;
}

event OnRegisterEvent()
{
	RegisterEvent((100000 + 849));
	RegisterEvent(11064);
	RegisterEvent(1710);
	RegisterEvent(1720);
	RegisterEvent(180);
	RegisterEvent(150);
	RegisterEvent(40);
	RegisterEvent(9750);
	return;
}

event OnLoad()
{
	Initialize();
	SetClosingOnESC();
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case (100000 + 849):
			ClearShop();
			HandleS_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST_NEW();
			break;
		case 11064:
			if(!IsMyShopIndex(param))
			{
				return;
			}
			HandleBuyResult(param);
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
		case 150:
			SetTabForm();
			EditBoxFind.Clear();
			HandleFormByLanguage();
			break;
		case 40:
			HandleRestart(param);
			break;
		case 9750:
			SetBanner();
			break;
		default:
			break;
	}
	return;
}

event OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case 99902:
			Refresh_Button.EnableWindow();
			Me.KillTimer(99902);
		case 99903:
			if((GetCurrentCategory() != 0))
			{
				getListCtrlByCategory(GetCurrentCategory()).SetFocus();
			}
			Me.KillTimer(99903);
			break;
		default:
			break;
	}
	return;
}

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	if(EditBoxFind.IsFocused())
	{
		if((int(nKey) == 13))
		{
			if((disableWnd.IsShowWindow() == false))
			{
				ClearAll();
				ShopDailyFails_ResultWnd.HideWindow();
				HandleItemNewList();
			}
		}
	}
	return false;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "BtnBuyLast":
			SetBuyConfirmWnd();
			DisableWndStep2.ShowWindow();
			DisableWndStep2.SetFocus();
			ShopDailyConfirm_ResultWnd.ShowWindow();
			ShopDailyConfirm_ResultWnd.SetFocus();
			if(DialogIsMine())
			{
				DialogHide();
			}
			break;
		case "BtnCancelBtn":
		case "BtnClose":
			disableWnd.HideWindow();
			buy_Wnd.HideWindow();
			if(DialogIsMine())
			{
				DialogHide();
			}
			break;
		case "BtnBuyInfo":
			OnBuy_ButtonClick();
			break;
		case "ListRefresh_Btn":
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
		case "ReceiveListPrevBtn":
			HandleCurrentHomeMainPage((currentHomeMainPage - 1));
			break;
		case "ReceiveListNextBtn":
			HandleCurrentHomeMainPage((currentHomeMainPage + 1));
			break;
		case "ReceiveListPrevBtnSmall":
			HandleCurrentHomeSubPage((currentHomeSubPage - 1));
			break;
		case "ReceiveListNextBtnSmall":
			HandleCurrentHomeSubPage((currentHomeSubPage + 1));
			break;
		case "BtnClearEditBox":
			EditBoxFind.Clear();
		case "BtnFind":
			ClearAll();
			ShopDailyFails_ResultWnd.HideWindow();
			disableWnd.HideWindow();
			HandleItemNewList();
			break;
		case "BannerClose":
		case "BannerTopClose_Btn":
			disableWnd.HideWindow();
			BannerLink.HideWindow();
			ReloadBannerDialogWebHandle();
			break;
		case "BtnBanner":
			ShowBannerDialog();
			break;
		case "ItemInfoClose":
		case "BtnCloseInfo":
			disableWnd.HideWindow();
			ItemInfo_Wnd.HideWindow();
			break;
		case "BuyItemInfo_Btn":
			OnInfo_ButtonClick();
		default:
			HandleBtnClick(Name);
			break;
	}
	return;
}

event OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	local string WindowName, strID;

	switch(a_ButtonHandle.GetWindowName())
	{
		case "BtnBuy":
			WindowName = a_ButtonHandle.GetParentWindowHandle().GetWindowName();
			if(GetStringIDFromBtnName(WindowName, "Item_Big", strID))
			{
				currentSelectHomeIndex = homeMainList[(int(strID) + (2 * currentHomeMainPage))];
			}
			else if(GetStringIDFromBtnName(WindowName, "Item_Small", strID))
			{
				currentSelectHomeIndex = homeSubList[(int(strID) + (4 * currentHomeSubPage))];
			}
			OnBuy_ButtonClick();
			break;
		case "BtnInfo":
			WindowName = a_ButtonHandle.GetParentWindowHandle().GetWindowName();
			if(GetStringIDFromBtnName(WindowName, "Item_Big", strID))
			{
				currentSelectHomeIndex = homeMainList[(int(strID) + (2 * currentHomeMainPage))];
			}
			else if(GetStringIDFromBtnName(WindowName, "Item_Small", strID))
			{
				currentSelectHomeIndex = homeSubList[(int(strID) + (4 * currentHomeSubPage))];
			}
			OnInfo_ButtonClick();
			break;
		default:
			break;
	}
	return;
}

event OnReceivedCloseUI()
{
	if(BannerLink.IsShowWindow())
	{
		BannerLink.HideWindow();
		disableWnd.HideWindow();
		ReloadBannerDialogWebHandle();
	}
	else if(ShopDailyConfirm_ResultWnd.IsShowWindow())
	{
		ItemCount_EditBox.ShowWindow();
		DisableWndStep2.HideWindow();
		ShopDailyConfirm_ResultWnd.HideWindow();
	}
	else if(ShopDailySuccess_ResultWnd.IsShowWindow())
	{
		ShopDailySuccess_ResultWnd.HideWindow();
		DisableWndStep2.HideWindow();
		buy_Wnd.HideWindow();
		disableWnd.HideWindow();
	}
	else if(ShopDailyFails_ResultWnd.IsShowWindow())
	{
		ShopDailyFails_ResultWnd.HideWindow();
		buy_Wnd.HideWindow();
		disableWnd.HideWindow();
		DisableWndStep2.HideWindow();
	}
	else if(ItemInfo_Wnd.IsShowWindow())
	{
		ItemInfo_Wnd.HideWindow();
		disableWnd.HideWindow();
	}
	else if(buy_Wnd.IsShowWindow())
	{
		buy_Wnd.HideWindow();
		disableWnd.HideWindow();
	}
	else
	{
		GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	}
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	return;
}

event OnDBClickListCtrlRecord(string ListCtrlID)
{
	OnBuy_ButtonClick();
	return;
}

event OnClickCheckBox(string strID)
{
	switch(strID)
	{
		case "ListOption_CheckBox":
			ClearAll();
			ShopDailyFails_ResultWnd.HideWindow();
			disableWnd.HideWindow();
			HandleItemNewList();
			break;
		default:
			break;
	}
	return;
}

event OnChangeEditBox(string strID)
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

event OnHide()
{
	Result_EffectViewport.SpawnEffect("");
	if(DialogIsMine())
	{
		DialogHide();
	}
	isShowRelayBuyWnd = false;
	SetBanner();
	return;
}

event OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	tabGroupButton._GetGroupButtonsInstance()._setTopOrder(0);
	API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST();
	BannerWebHandle.ShowWindow();
	disableWnd.HideWindow();
	ItemInfo_Wnd.HideWindow();
	buy_Wnd.HideWindow();
	BannerLink.HideWindow();
	DisableWndStep2.HideWindow();
	ShopDailyConfirm_ResultWnd.HideWindow();
	ShopDailySuccess_ResultWnd.HideWindow();
	ShopDailyFails_ResultWnd.HideWindow();
	EditBoxFind.DisableWindow();
	m_hOwnerWnd.SetFocus();
	EditBoxFind.EnableWindow();
	return;
}

function OnInfo_ButtonClick()
{
	disableWnd.ShowWindow();
	disableWnd.SetFocus();
	GetButtonHandle((m_Windowname $ ".ItemInfo_Wnd.BtnBuyInfo")).SetButtonName(2517);
	ShowInfoWnd();
	HtmlViewer.SetFocus();
	return;
}

function OnTabGroupBtnClicked(string parentWndName, string strName, int Index)
{
	ShowCurrentCategoryList();
	return;
}

function OnClickHelp()
{
	ExecuteEvent(1210, "8");
	return;
}

function ShowCurrentCategoryList()
{
	local int i, nCategory;
	local RichListCtrlHandle empthRichListCtrl, RichListCtrl;

	nCategory = GetCurrentCategory();
	i = (0 + 1);
	while((i < 16))
	{
		RichListCtrl = getListCtrlByCategory(i);
		if((RichListCtrl != empthRichListCtrl))
		{
			if((i == nCategory))
			{
				RichListCtrl.ShowWindow();
				HandleFindResult();
				Me.KillTimer(99903);
				Me.SetTimer(99903, 100);
				i++;
				continue;
			}
			RichListCtrl.HideWindow();
		}
		i++;
	}
	if((nCategory == 0))
	{
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Home_Wnd")).ShowWindow();
	}
	else
	{
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Home_Wnd")).HideWindow();
	}
	return;
}

function HandleFindResult()
{
	if((((GetCurrentCategory() != 0) && (getListCtrlByCategory(GetCurrentCategory()).GetRecordCount() == 0)) && (EditBoxFind.GetString() != "")))
	{
		GetTextBoxHandle((m_Windowname $ ".List_Wnd.CanNotFindText")).ShowWindow();
		GetTextBoxHandle((m_Windowname $ ".List_Wnd.CanNotFindText")).SetText(MakeFullSystemMsg(GetSystemMessage(4356), EditBoxFind.GetString()));
	}
	else
	{
		GetTextBoxHandle((m_Windowname $ ".List_Wnd.CanNotFindText")).HideWindow();
	}
	return;
}

function HandleBtnClick(string btnName)
{
	local string strID;

	if(GetStringIDFromBtnName(btnName, "btnBuy", strID))
	{
		OnBuy_ButtonClick();
	}
	else if(GetStringIDFromBtnName(btnName, "btnInfo", strID))
	{
		OnInfo_ButtonClick();
	}
	else
	{
		Debug((btnName @ "Clicked"));
	}
	return;
}

function OnRefresh_ButtonClick()
{
	ClearAll();
	API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST();
	Me.SetTimer(99902, 3000);
	Refresh_Button.DisableWindow();
	return;
}

function OnPriceEditBtnHandler()
{
	disableWnd.ShowWindow();
	disableWnd.SetFocus();
	DialogSetID(10111);
	DialogSetEditBoxMaxLength(9);
	DialogSetCancelD(10111);
	DialogSetEditType("number");
	DialogSetParamInt64(INT64(GetCountCanBuyByIndex(GetCurrentSelectedIndex())));
	DialogSetDefaultOK();
	DialogShow(DialogModalType_Modalless, DialogType_NumberPad, GetSystemMessage(4362));
	DialogSetInputlimit(INT64(GetCountCanBuyByIndex(GetCurrentSelectedIndex())));
	return;
}

function OnBuy_ButtonClick()
{
	disableWnd.ShowWindow();
	disableWnd.SetFocus();
	ShowBuyWnd();
	return;
}

function ShowInfoWnd()
{
	local ItemInfo Info, nullItem;
	local int SelectedIndex;
	local PLShopItemDataStruct ItemData;
	local LCoinShopProductUIData productData;

	SelectedIndex = GetCurrentSelectedIndex();
	ItemData = pLShopItemDataList[SelectedIndex];
	API_GetLCoinShopProductData(ItemData.nSlotNum, productData);
	Info = GetItemInfoCurrentSelected();
	if((Info != nullItem))
	{
		GetItemWindowHandle((m_Windowname $ ".ItemInfo_Wnd.Item01_ItemWindow")).Clear();
		GetItemWindowHandle((m_Windowname $ ".ItemInfo_Wnd.Item01_ItemWindow")).AddItem(Info);
		GetTextBoxHandle((m_Windowname $ ".ItemInfo_Wnd.Item01Title_TextBox")).SetText(GetProductNameByIndex(SelectedIndex));
		GetTextBoxHandle((m_Windowname $ ".ItemInfo_Wnd.Item01NumTitle_TextBox")).SetText((("(" $ string(productData.BuyItems[ItemData.sCircleNum].Count)) $ ")"));
		HtmlViewer.LoadHtml(("..\\L2text_Classic\\product\\" $ productData.ProductHtm));
		if((ItemData.nCostItemId[0] == -100))
		{
			Info = nullItem;
			Info.Name = GetSystemString(1277);
			Info.IconName = GetPcCafeItemIconPackageName();
			Info.Enchanted = 0;
			Info.ItemType = -1;
			Info.Id.ClassID = 0;
		}
		else if((ItemData.nCostItemId[0] == -800))
		{
			Info = nullItem;
			Info.Name = GetSystemString(2492);
			Info.IconName = "icon.etc_sayha_point_01";
			Info.Enchanted = 0;
			Info.ItemType = -1;
			Info.Id.ClassID = 0;
		}
		else
		{
			Info = GetItemInfoByClassID(ItemData.nCostItemId[0]);
		}
		GetItemWindowHandle((m_Windowname $ ".ItemInfo_Wnd.CostItem01_ItemWindow")).Clear();
		GetItemWindowHandle((m_Windowname $ ".ItemInfo_Wnd.CostItem01_ItemWindow")).AddItem(Info);
		GetTextBoxHandle((m_Windowname $ ".ItemInfo_Wnd.CostItem01Title_TextBox")).SetText(Info.Name);
		GetTextBoxHandle((m_Windowname $ ".ItemInfo_Wnd.CostItem01NumTitle_TextBox")).SetText(("x" $ MakeCostStringINT64(ItemData.nCostItemAmount[0])));
		GetTextureHandle((m_Windowname $ ".ItemInfo_Wnd.Item01Restriction_Texture")).SetTexture(GetLimitTypeIcon(productData.LimitType));
		if((int(productData.LimitType) == 0))
		{
			GetButtonHandle((m_Windowname $ ".ItemInfo_Wnd.btn_conditionHelp")).HideWindow();
			GetTextureHandle((m_Windowname $ ".ItemInfo_Wnd.Item01Restriction_Texture")).HideWindow();
			GetTextBoxHandle((m_Windowname $ ".ItemInfo_Wnd.Item01Restriction_TextBox")).SetAnchor((m_Windowname $ ".ItemInfo_Wnd"), "TopLeft", "TopLeft", 39, 83);
		}
		else
		{
			GetTextureHandle((m_Windowname $ ".ItemInfo_Wnd.Item01Restriction_Texture")).ShowWindow();
			if((GetBuyTypeStringBuyLimit(productData.LimitType, productData.ResetType) == ""))
			{
				GetButtonHandle((m_Windowname $ ".ItemInfo_Wnd.btn_conditionHelp")).HideWindow();
				GetTextBoxHandle((m_Windowname $ ".ItemInfo_Wnd.Item01Restriction_TextBox")).SetAnchor((m_Windowname $ ".ItemInfo_Wnd"), "TopLeft", "TopLeft", 39, 83);
			}
			else
			{
				GetButtonHandle((m_Windowname $ ".ItemInfo_Wnd.btn_conditionHelp")).ShowWindow();
				GetTextBoxHandle((m_Windowname $ ".ItemInfo_Wnd.Item01Restriction_TextBox")).SetAnchor((m_Windowname $ ".ItemInfo_Wnd"), "TopLeft", "TopLeft", 56, 83);
				GetButtonHandle((m_Windowname $ ".ItemInfo_Wnd.btn_conditionHelp")).SetTooltipCustomType(MakeTooltipSimpleText(GetBuyTypeStringBuyLimit(productData.LimitType, productData.ResetType)));
			}
		}
		GetTextBoxHandle((m_Windowname $ ".ItemInfo_Wnd.Item01Restriction_TextBox")).SetText(GetLimitTypeIconString(productData.LimitType, productData.ResetType));
		ItemInfo_Wnd.ShowWindow();
		buy_Wnd.HideWindow();
	}
	return;
}

function ShowBuyWnd()
{
	local ItemInfo Info, nullItem;
	local int SelectedIndex;
	local PLShopItemDataStruct ItemData;
	local LCoinShopProductUIData productData;
	local TextBoxHandle levelLimitConditionText;

	SelectedIndex = GetCurrentSelectedIndex();
	ItemData = pLShopItemDataList[SelectedIndex];
	API_GetLCoinShopProductData(ItemData.nSlotNum, productData);
	Info = GetItemInfoCurrentSelected();
	if((Info != nullItem))
	{
		GetItemWindowHandle((m_Windowname $ ".buy_Wnd.BuyItemInfo_Wnd.Item01_ItemWindow")).Clear();
		GetItemWindowHandle((m_Windowname $ ".buy_Wnd.BuyItemInfo_Wnd.Item01_ItemWindow")).AddItem(Info);
		GetTextBoxHandle((m_Windowname $ ".buy_Wnd.BuyItemInfo_Wnd.Item01Title_TextBox")).SetText(GetProductNameByIndex(SelectedIndex));
		GetTextBoxHandle((m_Windowname $ ".buy_Wnd.BuyItemInfo_Wnd.Item01NumTitle_TextBox")).SetText((("(" $ string(productData.BuyItems[ItemData.sCircleNum].Count)) $ ")"));
		if((ItemData.nCostItemId[0] == -100))
		{
			Info = nullItem;
			Info.Name = GetSystemString(1277);
			Info.IconName = GetPcCafeItemIconPackageName();
			Info.Enchanted = 0;
			Info.ItemType = -1;
			Info.Id.ClassID = 0;
		}
		else if((ItemData.nCostItemId[0] == -800))
		{
			Info = nullItem;
			Info.Name = GetSystemString(2492);
			Info.IconName = "Icon.etc_sayha_point_01";
			Info.Enchanted = 0;
			Info.ItemType = -1;
			Info.Id.ClassID = 0;
		}
		else
		{
			Info = GetItemInfoByClassID(ItemData.nCostItemId[0]);
		}
		GetItemWindowHandle((m_Windowname $ ".buy_Wnd.BuyCost_Wnd.CostItem01_ItemWindow")).Clear();
		GetItemWindowHandle((m_Windowname $ ".buy_Wnd.BuyCost_Wnd.CostItem01_ItemWindow")).AddItem(Info);
		GetTextBoxHandle((m_Windowname $ ".buy_Wnd.BuyCost_Wnd.CostItem01Title_TextBox")).SetText(Info.Name);
		SetItemCountEditBox(1);
		GetTextureHandle((m_Windowname $ ".buy_Wnd.BuyItemInfo_Wnd.Item01Restriction_Texture")).SetTexture(GetLimitTypeIcon(productData.LimitType));
		if((int(productData.LimitType) == 0))
		{
			GetButtonHandle((m_Windowname $ ".buy_Wnd.BuyItemInfo_Wnd.btn_conditionHelp")).HideWindow();
			GetTextureHandle((m_Windowname $ ".buy_Wnd.BuyItemInfo_Wnd.Item01Restriction_Texture")).HideWindow();
			GetTextBoxHandle((m_Windowname $ ".buy_Wnd.BuyItemInfo_Wnd.Item01Restriction_TextBox")).SetAnchor((m_Windowname $ ".buy_Wnd.BuyItemInfo_Wnd.BuyItemInfoBg_Texture"), "TopLeft", "TopLeft", 29, 53);
		}
		else
		{
			GetTextureHandle((m_Windowname $ ".buy_Wnd.BuyItemInfo_Wnd.Item01Restriction_Texture")).ShowWindow();
			if((GetBuyTypeStringBuyLimit(productData.LimitType, productData.ResetType) == ""))
			{
				GetButtonHandle((m_Windowname $ ".buy_Wnd.BuyItemInfo_Wnd.btn_conditionHelp")).HideWindow();
				GetTextBoxHandle((m_Windowname $ ".buy_Wnd.BuyItemInfo_Wnd.Item01Restriction_TextBox")).SetAnchor((m_Windowname $ ".buy_Wnd.BuyItemInfo_Wnd.BuyItemInfoBg_Texture"), "TopLeft", "TopLeft", 29, 53);
			}
			else
			{
				GetButtonHandle((m_Windowname $ ".buy_Wnd.BuyItemInfo_Wnd.btn_conditionHelp")).ShowWindow();
				GetTextBoxHandle((m_Windowname $ ".buy_Wnd.BuyItemInfo_Wnd.Item01Restriction_TextBox")).SetAnchor((m_Windowname $ ".buy_Wnd.BuyItemInfo_Wnd.BuyItemInfoBg_Texture"), "TopLeft", "TopLeft", 45, 53);
				GetButtonHandle((m_Windowname $ ".buy_Wnd.BuyItemInfo_Wnd.btn_conditionHelp")).SetTooltipCustomType(MakeTooltipSimpleText(GetBuyTypeStringBuyLimit(productData.LimitType, productData.ResetType)));
			}
		}
		GetTextBoxHandle((m_Windowname $ ".buy_Wnd.BuyItemInfo_Wnd.Item01Restriction_TextBox")).SetText(GetLimitTypeIconString(productData.LimitType, productData.ResetType));
		ItemCount_EditBox.ShowWindow();
		levelLimitConditionText = GetTextBoxHandle((m_Windowname $ ".Buy_Wnd.LvLimit_TextBox.LvLimit_TextBox"));
		levelLimitConditionText.SetText(((GetSystemString(13255) @ ":") @ GetLevelString(productData.BuyItems[ItemData.sCircleNum].LevelMin, productData.BuyItems[ItemData.sCircleNum].LevelMax)));
		if(CheckLevelCondition(GetCurrentSelectedIndex()))
		{
			levelLimitConditionText.SetTextColor(getInstanceL2Util().Blue);
		}
		else
		{
			levelLimitConditionText.SetTextColor(getInstanceL2Util().DRed);
		}
		if(ItemData.isRelay)
		{
			ShowRelayItem(productData.BuyItems, ItemData.sCircleNum);
		}
		else
		{
			HideRelayItem();
		}
		buy_Wnd.ShowWindow();
		ItemInfo_Wnd.HideWindow();
	}
	return;
}

function ShowBannerDialog()
{
	BannerLink.ShowWindow();
	disableWnd.ShowWindow();
	disableWnd.SetFocus();
	return;
}

function ReloadBannerDialogWebHandle()
{
	local WebRequestInfo requestInfo;

	if((BannerDialogWebHandle.GetUrl() != _bannerURLInfo.PopupURL))
	{
		BannerDialogWebHandle.HideWindow();
		BannerDialogWebHandle.ShowWindow();
		requestInfo.eMethodType = EWMT_GET;
		requestInfo.strRequestUrl = _bannerURLInfo.PopupURL;
		BannerDialogWebHandle.Navigate(requestInfo);
	}
	return;
}

function OnOK_ButtonClick()
{
	API_RequestPurchaseLimitShopItemBuy(pLShopItemDataList[GetCurrentSelectedIndex()].nSlotNum, int(ItemCount_EditBox.GetString()));
	DisableWndStep2.HideWindow();
	ShopDailyConfirm_ResultWnd.HideWindow();
	return;
}

function OnCancel_ButtonClick()
{
	ItemCount_EditBox.ShowWindow();
	DisableWndStep2.HideWindow();
	ShopDailyConfirm_ResultWnd.HideWindow();
	return;
}

function OnSuccess_ButtonClick()
{
	disableWnd.HideWindow();
	buy_Wnd.HideWindow();
	DisableWndStep2.HideWindow();
	ShopDailySuccess_ResultWnd.HideWindow();
	ItemCount_EditBox.ShowWindow();
	API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST();
	isShowRelayBuyWnd = pLShopItemDataList[GetCurrentSelectedIndex()].isRelay;
	return;
}

function OnFail_ButtonClick()
{
	DisableWndStep2.HideWindow();
	buy_Wnd.HideWindow();
	ShopDailySuccess_ResultWnd.HideWindow();
	ShopDailyFails_ResultWnd.HideWindow();
	disableWnd.HideWindow();
	ItemCount_EditBox.ShowWindow();
	API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST();
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

function SetBanner()
{
	local WebRequestInfo requestInfo;
	local array<StoreURLData> arrBannerData;

	GetStoreURLData(arrBannerData);
	if((true || (arrBannerData.Length <= 0)))
	{
		Debug("NOT BANNER GameEngine.URL DATA : GetStoreURLData Array Length 0");
		BannerBtn.HideWindow();
		return;
	}
	_bannerURLInfo = arrBannerData[Rand(arrBannerData.Length)];
	requestInfo.eMethodType = EWMT_GET;
	requestInfo.strRequestUrl = _bannerURLInfo.BannerURL;
	BannerWebHandle.Navigate(requestInfo);
	if((Len(_bannerURLInfo.PopupURL) > 0))
	{
		requestInfo.strRequestUrl = _bannerURLInfo.PopupURL;
		BannerDialogWebHandle.HideWindow();
		BannerDialogWebHandle.ShowWindow();
		BannerDialogWebHandle.Navigate(requestInfo);
		BannerBtn.ShowWindow();
	}
	else
	{
		BannerBtn.HideWindow();
	}
	return;
}

function API_RequestPurchaseLimitShopItemBuy(int nSlotNum, int nItemAmount)
{
	RequestPurchaseLimitShopItemBuy(3, nSlotNum, nItemAmount);
	return;
}

function API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST()
{
	local array<byte> stream;
	local UIPacket._C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST packet;

	packet.cShopIndex = 3;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(563, stream);
	return;
}

function API_GetLCoinShopBannerData(out array<LCoinShopBannerUIData> arrBannerData)
{
	GetLCoinShopBannerData(arrBannerData);
	return;
}

function API_GetLCoinShopProductData(int ProductID, out LCoinShopProductUIData productData)
{
	GetLCoinShopProductData(ProductID, productData);
	return;
}

function ClearAll()
{
	ClearList();
	ClearShop();
	return;
}

function ClearList()
{
	local int i;

	i = (0 + 1);
	while((i < 16))
	{
		getListCtrlByCategory(i).DeleteAllItem();
		i++;
	}
	return;
}

function ClearShop()
{
	DisableWndStep2.HideWindow();
	ShopDailyConfirm_ResultWnd.HideWindow();
	ShopDailySuccess_ResultWnd.HideWindow();
	ItemCount_EditBox.ShowWindow();
	return;
}

function HandleUserInfo()
{
	if(getInstanceUIData().IsLevelUP())
	{
		Me.HideWindow();
	}
	return;
}

function bool CanBuyByRecord(RichListCtrlRowData Record)
{
	return (GetCountCanBuy(Record) > 0);
}

function ItemInfo GetItemInfoByRecord(RichListCtrlRowData Record)
{
	return GetItemInfoByIndex(int(Record.nReserved1));
}

function ItemInfo GetItemInfoByIndex(int Index)
{
	return GetItemInfoByClassID(pLShopItemDataList[Index].nItemClassID);
}

function ItemInfo GetItemInfoCurrentSelected()
{
	return GetItemInfoByIndex(GetCurrentSelectedIndex());
}

function int GetSlotNumByRecord(RichListCtrlRowData Record)
{
	return Record.cellDataList[2].nReserved3;
}

function int GetCountCanBuy(RichListCtrlRowData Record)
{
	return GetCountCanBuyByIndex(int(Record.nReserved1));
}

function int GetCountCanBuyByIndex(int Index)
{
	local int Count;

	if(!CheckLevelCondition(Index))
	{
		return 0;
	}
	Count = GetItemLimitAmount(Index);
	Count = Min(GetMinAmoutByCostItemNum(Index), Count);
	if(pLShopItemDataList[Index].isRelay)
	{
		Count = Min(1, Count);
	}
	return Count;
}

function bool CheckLevelCondition(int Index)
{
	local UserInfo Info;
	local PLShopItemDataStruct ItemData;
	local LCoinShopProductUIData productData;

	ItemData = pLShopItemDataList[Index];
	API_GetLCoinShopProductData(ItemData.nSlotNum, productData);
	if(!GetPlayerInfo(Info))
	{
		return false;
	}
	if(((Info.nLevel > productData.BuyItems[ItemData.sCircleNum].LevelMax) || (Info.nLevel < productData.BuyItems[ItemData.sCircleNum].LevelMin)))
	{
		return false;
	}
	return true;
}

function int GetItemLimitAmount(int Index)
{
	local LCoinShopProductUIData productData;

	API_GetLCoinShopProductData(pLShopItemDataList[Index].nSlotNum, productData);
	if((int(productData.LimitType) == 0))
	{
		return 1000000;
	}
	else
	{
		return pLShopItemDataList[Index].nRemainItemAmount;
	}
}

function int GetMinAmoutByCostItemNum(int Index)
{
	local int i, costItemID;
	local INT64 Count, CostItemAmount;
	local PLShopItemDataStruct ItemData;

	ItemData = pLShopItemDataList[Index];
	Count = INT64(1000000);
	i = 0;
	while((i < 3))
	{
		costItemID = ItemData.nCostItemId[i];
		CostItemAmount = ItemData.nCostItemAmount[i];
		if((costItemID > 0))
		{
			Count = Min64(Count, (GetInventoryItemCount(GetItemID(costItemID)) / CostItemAmount));
			i++;
			continue;
		}
		if(((costItemID < 0) && (costItemID == -100)))
		{
			Count = Min64(Count, (INT64(getInstanceUIData().GetCurrentPcCafePoint()) / CostItemAmount));
			i++;
			continue;
		}
		if(((costItemID < 0) && (costItemID == -800)))
		{
			Count = Min64(Count, (getInstanceUIData().GetCurrentVitalityPoint() / CostItemAmount));
		}
		i++;
	}
	return int(Count);
}

function SetHomeMainItem(int Index, int homeListIndex)
{
	local ItemInfo Info;
	local PLShopItemDataStruct ItemData;
	local LCoinShopProductUIData productData;

	if((homeMainList.Length <= homeListIndex))
	{
		GetHomeMainByIndex(Index).HideWindow();
		return;
	}
	GetHomeMainByIndex(Index).ShowWindow();
	ItemData = pLShopItemDataList[homeMainList[homeListIndex]];
	API_GetLCoinShopProductData(ItemData.nSlotNum, productData);
	Info = GetItemInfoByClassID(ItemData.nItemClassID);
	GetHomeMainItemByIndex(Index).Clear();
	GetHomeMainItemByIndex(Index).AddItem(Info);
	if((int(productData.MarkType) == 0))
	{
		GetHomeMainSaleType(Index).HideWindow();
	}
	else
	{
		GetHomeMainSaleType(Index).SetTexture(GetMarkIconByType(productData.MarkType));
		GetHomeMainSaleType(Index).ShowWindow();
	}
	if((int(GetLanguage()) == 0))
	{
		GetHomeMainText(Index, 0).SetText(productData.HeadLine);
	}
	else if(((float(Index) % 2.0000000) == 0.0000000))
	{
		GetHomeMainText(Index, 0).SetText(GetSystemString(5923));
	}
	else
	{
		GetHomeMainText(Index, 0).SetText(GetSystemString(5924));
	}
	GetHomeMainText(Index, 1).SetText(GetProductNameByIndex(homeMainList[homeListIndex]));
	if((ItemData.nRemainSec > 0))
	{
		GetHomeMainText(Index, 3).SetText(util.getTimeStringBySec3(ItemData.nRemainSec));
	}
	else
	{
		GetHomeMainText(Index, 3).SetText(GetSystemString(3979));
	}
	if((productData.LimitCountMax == 0))
	{
		GetHomeMainText(Index, 4).SetText(GetSystemString(13270));
	}
	else
	{
		GetHomeMainText(Index, 4).SetText((((string(ItemData.nRemainItemAmount) $ "/") $ string(productData.LimitCountMax)) @ GetBuyTypeStringBuyRefresh(productData.ResetType)));
		GetHomeMainText(Index, 4).SetTextColor(GetColor(255, 255, 255, 255));
	}
	GetHomeMainIconType(Index).SetTexture(GetMoneyIconByID(ItemData.nCostItemId[0]));
	GetHomeMainText(Index, 8).SetText(GetLevelString(productData.BuyItems[ItemData.sCircleNum].LevelMin, productData.BuyItems[ItemData.sCircleNum].LevelMax));
	GetHomeMainText(Index, 7).SetText(MakeCostStringINT64(ItemData.nCostItemAmount[0]));
	return;
}

function string GetLevelString(int MinLevel, int MaxLevel)
{
	if(((MinLevel == 1) && (MaxLevel == 999)))
	{
		return "-";
	}
	if((MinLevel == 1))
	{
		return (string(MaxLevel) @ GetSystemString(5182));
	}
	if((MaxLevel == 999))
	{
		return (string(MinLevel) @ GetSystemString(859));
	}
	return ((((string(MinLevel) @ GetSystemString(859)) @ "~") @ string(MaxLevel)) @ GetSystemString(13266));
}

function SetHomeSubItem(int Index, int homeListIndex)
{
	local ItemInfo Info;
	local PLShopItemDataStruct ItemData;
	local LCoinShopProductUIData productData;
	local string itemNameStr;

	if((homeSubList.Length <= homeListIndex))
	{
		GetHomeSubByIndex(Index).HideWindow();
		return;
	}
	GetHomeSubByIndex(Index).ShowWindow();
	ItemData = pLShopItemDataList[homeSubList[homeListIndex]];
	API_GetLCoinShopProductData(ItemData.nSlotNum, productData);
	Info = GetItemInfoByClassID(ItemData.nItemClassID);
	GetHomeSubItemByIndex(Index).Clear();
	GetHomeSubItemByIndex(Index).AddItem(Info);
	if((int(productData.MarkType) == 0))
	{
		GetHomeSubSaleType(Index).HideWindow();
	}
	else
	{
		GetHomeSubSaleType(Index).SetTexture(GetMarkIconByType(productData.MarkType));
		GetHomeSubSaleType(Index).ShowWindow();
	}
	itemNameStr = GetProductNameByIndex(homeSubList[homeListIndex]);
	Class'InterfaceClassic.L2Util'.static.GetEllipsisString(itemNameStr, 224);
	GetHomeSubText(Index, 0).SetText(itemNameStr);
	GetHomeSubText(Index, 1).SetText(GetLevelString(productData.BuyItems[ItemData.sCircleNum].LevelMin, productData.BuyItems[ItemData.sCircleNum].LevelMax));
	if((ItemData.nRemainSec > 0))
	{
		GetHomeSubText(Index, 2).SetText(util.getTimeStringBySec3(ItemData.nRemainSec));
	}
	else
	{
		GetHomeSubText(Index, 2).SetText(GetSystemString(3979));
	}
	if((productData.LimitCountMax == 0))
	{
		GetHomeSubText(Index, 4).SetText(GetSystemString(13270));
	}
	else
	{
		GetHomeSubText(Index, 4).SetText((((string(ItemData.nRemainItemAmount) $ "/") $ string(productData.LimitCountMax)) @ GetBuyTypeStringBuyRefresh(productData.ResetType)));
		GetHomeSubText(Index, 4).SetTextColor(GetColor(255, 255, 255, 255));
	}
	GetHomeSubIconType(Index).SetTexture(GetMoneyIconByID(ItemData.nCostItemId[0]));
	GetHomeSubText(Index, 3).SetText(MakeCostStringINT64(ItemData.nCostItemAmount[0]));
	return;
}

function HandleCurrentHomeMainPage(int PageNum)
{
	local int i, maxPage;

	maxPage = (homeMainList.Length / 2);
	if(((float(homeMainList.Length) % 2.0000000) > 0.0000000))
	{
		maxPage++;
	}
	if((PageNum >= maxPage))
	{
		PageNum = 0;
	}
	else if((PageNum < 0))
	{
		PageNum = (maxPage - 1);
	}
	i = 0;
	while((i < 2))
	{
		SetHomeMainItem(i, ((PageNum * 2) + i));
		i++;
	}
	currentHomeMainPage = PageNum;
	ReceiveListNumberBig.SetText(((string((currentHomeMainPage + 1)) $ "/") $ string(maxPage)));
	return;
}

function HandleCurrentHomeSubPage(int PageNum)
{
	local int i, maxPage;

	maxPage = (homeSubList.Length / 4);
	if(((float(homeSubList.Length) % 4.0000000) > 0.0000000))
	{
		maxPage++;
	}
	if((PageNum >= maxPage))
	{
		PageNum = 0;
	}
	else if((PageNum < 0))
	{
		PageNum = (maxPage - 1);
	}
	i = 0;
	while((i < 4))
	{
		SetHomeSubItem(i, ((PageNum * 4) + i));
		i++;
	}
	currentHomeSubPage = PageNum;
	ReceiveListNumberSmall.SetText(((string((currentHomeSubPage + 1)) $ "/") $ string(maxPage)));
	return;
}

function HandleS_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST_NEW()
{
	local UIPacket._S_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST_NEW packet;
	local int i, j;
	local PLShopItemDataStruct pLShopItemData;
	local LCoinShopProductUIData productData;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST_NEW(packet))
	{
		return;
	}
	if((packet.cShopIndex != 3))
	{
		return;
	}
	if((packet.cPage == 1))
	{
		pLShopItemDataListTemp.Length = 0;
	}
	i = 0;
	while((i < packet.vItemList.Length))
	{
		pLShopItemData.Index = i;
		pLShopItemData.nSlotNum = packet.vItemList[i].nSlotNum;
		pLShopItemData.nItemClassID = packet.vItemList[i].nItemClassID;
		j = 0;
		while((j < 3))
		{
			pLShopItemData.nCostItemId[j] = packet.vItemList[i].nCostItemId[j];
			j++;
		}
		j = 0;
		while((j < 3))
		{
			pLShopItemData.nCostItemAmount[j] = packet.vItemList[i].nCostItemAmount[j];
			j++;
		}
		pLShopItemData.nRemainItemAmount = packet.vItemList[i].nRemainItemAmount;
		pLShopItemData.nRemainSec = packet.vItemList[i].nRemainSec;
		pLShopItemData.nRemainServerItemAmount = packet.vItemList[i].nRemainServerItemAmount;
		pLShopItemData.sCircleNum = packet.vItemList[i].sCircleNum;
		API_GetLCoinShopProductData(packet.vItemList[i].nSlotNum, productData);
		pLShopItemData.isRelay = (int(productData.MarkType) == 6);
		pLShopItemDataListTemp[pLShopItemDataListTemp.Length] = pLShopItemData;
		i++;
	}
	if((packet.cPage < packet.cMaxPage))
	{
		return;
	}
	if(CheckNewList())
	{
		ClearList();
	}
	pLShopItemDataList = pLShopItemDataListTemp;
	pLShopItemDataListTemp.Length = 0;
	HandleItemNewList();
	if(isShowRelayBuyWnd)
	{
		isShowRelayBuyWnd = false;
		ShowBuyWnd();
	}
	return;
}

function bool CheckNewList()
{
	local int i;

	if((pLShopItemDataListTemp.Length != pLShopItemDataList.Length))
	{
		return true;
	}
	i = 0;
	while((i < pLShopItemDataListTemp.Length))
	{
		if((pLShopItemDataListTemp[i].nSlotNum != pLShopItemDataList[i].nSlotNum))
		{
			return true;
		}
		i++;
	}
	return false;
}

function HandleItemNewList()
{
	local int i, Index;
	local RichListCtrlRowData Record;
	local LCoinShopProductUIData productData;
	local bool canBuy;
	local RichListCtrlHandle richList;

	homeMainList.Length = 0;
	homeSubList.Length = 0;
	i = 0;
	while((i < pLShopItemDataList.Length))
	{
		API_GetLCoinShopProductData(pLShopItemDataList[i].nSlotNum, productData);
		switch(productData.ProductType)
		{
			case 0:
				break;
			case 1:
				homeMainList[homeMainList.Length] = i;
				break;
			case 2:
				homeSubList[homeSubList.Length] = i;
				break;
			default:
				break;
		}
		canBuy = (GetCountCanBuyByIndex(pLShopItemDataList[i].Index) > 0);
		if(ListOption_CheckBox.IsChecked())
		{
			if(!canBuy)
			{
				i++;
				continue;
			}
		}
		if(!bFindMatchString(productData))
		{
			i++;
			continue;
		}
		Record = makeRecord(i);
		richList = getListCtrlByCategory((productData.Category + 1));
		Index = GetListIndex(richList, Record);
		if((Index > -1))
		{
			richList.ModifyRecord(Index, Record);
			i++;
			continue;
		}
		richList.InsertRecord(Record);
		i++;
	}
	HandleCurrentHomeMainPage(currentHomeMainPage);
	HandleCurrentHomeSubPage(currentHomeSubPage);
	HandleFindResult();
	return;
}

function int GetListIndex(RichListCtrlHandle richList, RichListCtrlRowData newRowData)
{
	local int i;
	local RichListCtrlRowData rowData;

	i = 0;
	while((i < richList.GetRecordCount()))
	{
		richList.GetRec(i, rowData);
		if((rowData.nReserved1 == newRowData.nReserved1))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function bool bFindMatchString(LCoinShopProductUIData productData)
{
	local int j;

	j = 0;
	while((j < productData.BuyItems.Length))
	{
		if((FindMatchString(productData.BuyItems[j].ProductName, EditBoxFind.GetString()) == 1))
		{
			return true;
		}
		j++;
	}
	return false;
}

function RichListCtrlRowData makeRecord(int Index)
{
	local RichListCtrlRowData Record;
	local string fullNameString, toolTipParam;
	local ItemInfo Info;
	local UserInfo PlayerInfo;
	local INT64 tmpCostNum;
	local PLShopItemDataStruct ItemData;
	local LCoinShopProductUIData productData;
	local Color tmpTextColor;
	local bool bBreakLine, canBuy;

	ItemData = pLShopItemDataList[Index];
	API_GetLCoinShopProductData(ItemData.nSlotNum, productData);
	canBuy = (GetItemLimitAmount(Index) > 0);
	GetPlayerInfo(PlayerInfo);
	Info = GetItemInfoByClassID(ItemData.nItemClassID);
	fullNameString = GetItemNameAll(Info);
	ItemInfoToParam(Info, toolTipParam);
	Record.szReserved = toolTipParam;
	Record.cellDataList.Length = 6;
	Record.nReserved1 = INT64(Index);
	Record.cellDataList[0].nReserved1 = ItemData.nItemClassID;
	Record.cellDataList[2].nReserved3 = ItemData.nSlotNum;
	Record.cellDataList[0].szData = fullNameString;
	addRichListCtrlTexture(Record.cellDataList[0].drawitems, Info.IconName, 32, 32, 10, 6);
	if((Info.IconPanel != ""))
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, Info.IconPanel, 32, 32, -32, 0);
	}
	if(!canBuy)
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, "L2UI_CT1.ItemWindow.ItemWindow_IconDisable", 32, 32, -32, 0);
	}
	if(canBuy)
	{
		tmpTextColor = GetColor(170, 153, 119, 255);
	}
	else
	{
		tmpTextColor = util.DarkGray;
	}
	if((int(productData.MarkType) == 0))
	{
		AddRichListCtrlString(Record.cellDataList[0].drawitems, GetProductNameByIndex(Index), tmpTextColor, false, 5, 2);
	}
	else
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, GetMarkIconByType(productData.MarkType), 64, 64, -42, -6);
		if(ItemData.isRelay)
		{
			Record.sOverlayTex = "L2UI_EPIC.LCoinShopWnd.ListBg_RelayItem";
			Record.OverlayTexU = 957;
			Record.OverlayTexV = 50;
		}
		AddRichListCtrlString(Record.cellDataList[0].drawitems, GetProductNameByIndex(Index), tmpTextColor, false, -16, 8);
	}
	AddRichListCtrlString(Record.cellDataList[0].drawitems, (("(" $ string(productData.BuyItems[ItemData.sCircleNum].Count)) $ ")"), tmpTextColor, true, 47, 0);
	if(canBuy)
	{
		tmpTextColor = GetColor(254, 215, 160, 255);
	}
	else
	{
		tmpTextColor = util.DarkGray;
	}
	if((productData.BuyItems[ItemData.sCircleNum].LevelMin != 1))
	{
		AddRichListCtrlString(Record.cellDataList[1].drawitems, (string(productData.BuyItems[ItemData.sCircleNum].LevelMin) @ GetSystemString(859)), tmpTextColor, false, 10, -2);
		bBreakLine = true;
	}
	if((productData.BuyItems[ItemData.sCircleNum].LevelMax != 999))
	{
		AddRichListCtrlString(Record.cellDataList[1].drawitems, (GetSystemString(13268) @ string(productData.BuyItems[ItemData.sCircleNum].LevelMax)), tmpTextColor, bBreakLine, 10, -2);
	}
	if(((productData.BuyItems[ItemData.sCircleNum].LevelMin == 1) && (productData.BuyItems[ItemData.sCircleNum].LevelMax == 999)))
	{
		AddRichListCtrlString(Record.cellDataList[1].drawitems, "-", tmpTextColor, false, 10, 0);
	}
	if(canBuy)
	{
		tmpTextColor = util.White;
	}
	else
	{
		tmpTextColor = util.DarkGray;
	}
	if((ItemData.nRemainSec > 0))
	{
		AddRichListCtrlString(Record.cellDataList[2].drawitems, util.getTimeStringBySec3(ItemData.nRemainSec), tmpTextColor, false, 0, 0);
	}
	else
	{
		addRichListCtrlTexture(Record.cellDataList[2].drawitems, "L2UI_CT1.ShopDailyWnd.ShopDailyWnd_Icon_Infinity", 16, 8, 0, 0);
	}
	if((productData.LimitCountMax > 0))
	{
		AddRichListCtrlString(Record.cellDataList[3].drawitems, (((string(ItemData.nRemainItemAmount) $ "/") $ string(productData.LimitCountMax)) @ GetBuyTypeStringBuyRefresh(productData.ResetType)), tmpTextColor, false, 0, 0);
	}
	else
	{
		addRichListCtrlTexture(Record.cellDataList[3].drawitems, "L2UI_CT1.ShopDailyWnd.ShopDailyWnd_Icon_Infinity", 16, 8, 0, 0);
	}
	if((int(GetLanguage()) == 0))
	{
		AddRichListCtrlButton(Record.cellDataList[4].drawitems, ("btnInfo" $ string(Index)), 20, 0, "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Info_Button", "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Info_Button_Down", "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Info_Button_Over", 32, 32, 32, 32);
	}
	AddRichListCtrlButton(Record.cellDataList[4].drawitems, ("btnBuy" $ string(Index)), 37, 0, "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Buy_Button", "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Buy_Button_Down", "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Buy_Button_Over", 32, 32, 32, 32);
	tmpCostNum = GetAdenaNum(ItemData);
	if((tmpCostNum != INT64(-1)))
	{
		AddRichListCtrlString(Record.cellDataList[4].drawitems, MakeCostStringINT64(tmpCostNum), tmpTextColor, false, 40, 10);
		AddRichListCtrlString(Record.cellDataList[4].drawitems, "", tmpTextColor, true, 0, 0);
		addRichListCtrlTexture(Record.cellDataList[4].drawitems, "L2UI_NewTex.LCoinShopWnd.bm_adena_Big", 30, 30, 220, -24);
	}
	else
	{
		tmpCostNum = GetEinhasadCoinNum(ItemData);
		if((tmpCostNum != INT64(-1)))
		{
			AddRichListCtrlString(Record.cellDataList[4].drawitems, MakeCostStringINT64(tmpCostNum), tmpTextColor, false, 40, 10);
			AddRichListCtrlString(Record.cellDataList[4].drawitems, "", tmpTextColor, true, 0, 0);
			addRichListCtrlTexture(Record.cellDataList[4].drawitems, "L2UI_NewTex.LCoinShopWnd.bm_einhasad_coin_Big", 30, 30, 220, -21);
		}
		tmpCostNum = GetLcoinNum(ItemData);
		if((tmpCostNum != INT64(-1)))
		{
			AddRichListCtrlString(Record.cellDataList[4].drawitems, MakeCostStringINT64(tmpCostNum), tmpTextColor, false, 40, 10);
			AddRichListCtrlString(Record.cellDataList[4].drawitems, "", tmpTextColor, true, 0, 0);
			addRichListCtrlTexture(Record.cellDataList[4].drawitems, "L2UI_NewTex.LCoinShopWnd.bm_Lcoin", 30, 30, 220, -21);
		}
		tmpCostNum = GetPCCafePointNum(ItemData);
		if((tmpCostNum != INT64(-1)))
		{
			AddRichListCtrlString(Record.cellDataList[4].drawitems, MakeCostStringINT64(tmpCostNum), tmpTextColor, false, 40, 10);
			AddRichListCtrlString(Record.cellDataList[4].drawitems, "", tmpTextColor, true, 0, 0);
			addRichListCtrlTexture(Record.cellDataList[4].drawitems, GetPcCafeItemIconPackageName(true), 30, 30, 220, -21);
		}
		tmpCostNum = GetVitalPointNum(ItemData);
		if((tmpCostNum != INT64(-1)))
		{
			AddRichListCtrlString(Record.cellDataList[4].drawitems, MakeCostStringINT64(tmpCostNum), tmpTextColor, false, 40, 10);
			AddRichListCtrlString(Record.cellDataList[4].drawitems, "", tmpTextColor, true, 0, 0);
			addRichListCtrlTexture(Record.cellDataList[4].drawitems, "L2UI_NewTex.LCoinShopWnd.bm_Sayhas", 30, 30, 220, -21);
		}
		tmpCostNum = GetAcoinNum(ItemData);
		if((tmpCostNum != INT64(-1)))
		{
			AddRichListCtrlString(Record.cellDataList[4].drawitems, MakeCostStringINT64(tmpCostNum), tmpTextColor, false, 40, 10);
			AddRichListCtrlString(Record.cellDataList[4].drawitems, "", tmpTextColor, true, 0, 0);
			addRichListCtrlTexture(Record.cellDataList[4].drawitems, "L2UI_NewTex.LCoinShopWnd.bm_Acoin", 30, 30, 220, -21);
		}
		tmpCostNum = GetChaoticEtherNum(ItemData);
		if((tmpCostNum != INT64(-1)))
		{
			AddRichListCtrlString(Record.cellDataList[4].drawitems, MakeCostStringINT64(tmpCostNum), tmpTextColor, false, 40, 10);
			AddRichListCtrlString(Record.cellDataList[4].drawitems, "", tmpTextColor, true, 0, 0);
			addRichListCtrlTexture(Record.cellDataList[4].drawitems, "L2UI_NewTex.LCoinShopWnd.bm_chaotic_ether_Big", 30, 30, 220, -21);
		}
	}
	return Record;
}

function SetControlerBtns()
{
	local int Count, canBuyCount;

	canBuyCount = GetCountCanBuyByIndex(GetCurrentSelectedIndex());
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
		if((Count > 0))
		{
			BtnBuyLast.EnableWindow();
		}
		else
		{
			BtnBuyLast.DisableWindow();
		}
	}
	else
	{
		MultiSell_Up_Button.DisableWindow();
		MultiSell_Down_Button.DisableWindow();
		MultiSell_Input_Button.DisableWindow();
		ItemCount_EditBox.DisableWindow();
		BtnBuyLast.DisableWindow();
	}
	SetBuyButtonTooltip();
	return;
}

function SetItemCountEditBox(int Num)
{
	if((GetCurrentSelectedIndex() == -1))
	{
		Num = 0;
	}
	else if((Num < 1))
	{
		Num = 0;
	}
	Num = Min(GetCountCanBuyByIndex(GetCurrentSelectedIndex()), Num);
	if((Num != int(ItemCount_EditBox.GetString())))
	{
		ItemCount_EditBox.SetString(string(Num));
	}
	SetBuyCostText(Num);
	SetControlerBtns();
	return;
}

function SetBuyCostText(int Count)
{
	local INT64 COSTITEMNUM, haveItem;

	if((pLShopItemDataList[GetCurrentSelectedIndex()].nCostItemId[0] == -100))
	{
		haveItem = INT64(getInstanceUIData().GetCurrentPcCafePoint());
	}
	else if((pLShopItemDataList[GetCurrentSelectedIndex()].nCostItemId[0] == -800))
	{
		haveItem = getInstanceUIData().GetCurrentVitalityPoint();
	}
	else
	{
		haveItem = GetInventoryItemCount(GetItemID(pLShopItemDataList[GetCurrentSelectedIndex()].nCostItemId[0]));
	}
	COSTITEMNUM = (pLShopItemDataList[GetCurrentSelectedIndex()].nCostItemAmount[0] * INT64(Max(Count, 1)));
	if((haveItem >= COSTITEMNUM))
	{
		GetTextBoxHandle((m_Windowname $ ".Buy_Wnd.CostItem01MyNumTitle_TextBox")).SetTextColor(util.BLUE01);
	}
	else
	{
		GetTextBoxHandle((m_Windowname $ ".Buy_Wnd.CostItem01MyNumTitle_TextBox")).SetTextColor(util.DRed);
	}
	GetTextBoxHandle((m_Windowname $ ".Buy_Wnd.CostItem01NumTitle_TextBox")).SetText(("x" $ MakeCostStringINT64(COSTITEMNUM)));
	GetTextBoxHandle((m_Windowname $ ".Buy_Wnd.CostItem01MyNumTitle_TextBox")).SetText((("(" $ MakeCostStringINT64(haveItem)) $ ")"));
	return;
}

function SetBuyButtonTooltip()
{
	local CustomTooltip t;

	util.setCustomTooltip(t);
	util.ToopTipMinWidth(10);
	if((GetCurrentSelectedIndex() == -1))
	{
		BtnBuyLast.SetTooltipCustomType(util.getCustomToolTip());
		return;
	}
	if(!CheckLevelCondition(GetCurrentSelectedIndex()))
	{
		util.ToopTipInsertText(GetSystemString(1030), true, true, COLOR_RED);
	}
	if((GetItemLimitAmount(GetCurrentSelectedIndex()) == 0))
	{
		util.ToopTipInsertText((GetSystemString(3725) $ " "), true, true, COLOR_GRAY);
		util.ToopTipInsertText("0", true, false, COLOR_RED);
	}
	if((GetMinAmoutByCostItemNum(GetCurrentSelectedIndex()) == 0))
	{
		util.ToopTipInsertText(GetSystemMessage(701), true, true, COLOR_RED);
	}
	BtnBuyLast.SetTooltipCustomType(util.getCustomToolTip());
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
	if((bOK == false))
	{
		return;
	}
	switch(DialogGetID())
	{
		case 10111:
			SetItemCountEditBox(int(DialogGetString()));
			if((buy_Wnd.IsShowWindow() == false))
			{
				disableWnd.HideWindow();
			}
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
	local PLShopItemDataStruct ItemData;
	local LCoinShopProductUIData productData;

	ItemData = pLShopItemDataList[GetCurrentSelectedIndex()];
	API_GetLCoinShopProductData(ItemData.nSlotNum, productData);
	Info = GetItemInfoCurrentSelected();
	Result_ItemWnd = GetItemWindowHandle((m_Windowname $ ".ShopDailyConfirm_ResultWnd.Result_ItemWnd"));
	ItemName_TextBox = GetTextBoxHandle((m_Windowname $ ".ShopDailyConfirm_ResultWnd.ItemName_TextBox"));
	GetTextBoxHandle((m_Windowname $ ".ShopDailyConfirm_ResultWnd.BCTitle_TextBox")).SetText(Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(ItemData.nCostItemId[0])));
	Result_ItemWnd.Clear();
	Result_ItemWnd.AddItem(Info);
	ItemName_TextBox.SetText((((GetProductNameByIndex(GetCurrentSelectedIndex()) $ "(") $ string(productData.BuyItems[ItemData.sCircleNum].Count)) $ ")"));
	textBoxShortStringWithTooltip(ItemName_TextBox, true);
	ItemName_TextBox1 = GetTextBoxHandle((m_Windowname $ ".ShopDailyConfirm_ResultWnd.BCTitle_TextBox"));
	ItemName_TextBox1.SetText(GetTextBoxHandle((m_Windowname $ ".buy_Wnd.CostItem01Title_TextBox")).GetText());
	BCNum_TextBox = GetTextBoxHandle((m_Windowname $ ".ShopDailyConfirm_ResultWnd.BCNum_TextBox"));
	BCNum_TextBox.SetText(GetTextBoxHandle((m_Windowname $ ".buy_Wnd.CostItem01NumTitle_TextBox")).GetText());
	ItemName_TextBox2 = GetTextBoxHandle((m_Windowname $ ".ShopDailyConfirm_ResultWnd.AdenaTitle_TextBox"));
	ItemName_TextBox2.SetText(NeededItem_Item2_Title.GetText());
	AdenaNum_TextBox = GetTextBoxHandle((m_Windowname $ ".ShopDailyConfirm_ResultWnd.AdenaNum_TextBox"));
	AdenaNum_TextBox.SetText(NeededItem_Item2Num_text.GetText());
	ItemName_TextBox3 = GetTextBoxHandle((m_Windowname $ ".ShopDailyConfirm_ResultWnd.CostTitle_TextBox"));
	ItemName_TextBox3.SetText(NeededItem_Item3_Title.GetText());
	CostNum_TextBox = GetTextBoxHandle((m_Windowname $ ".ShopDailyConfirm_ResultWnd.CostNum_TextBox"));
	CostNum_TextBox.SetText(NeededItem_Item3Num_text.GetText());
	ItemNum_TextBox.SetText(("x" $ ItemCount_EditBox.GetString()));
	ItemCount_EditBox.HideWindow();
	return;
}

function HandleBuyResult(string param)
{
	local int Result;

	ParseInt(param, "Result", Result);
	disableWnd.SetFocus();
	DisableWndStep2.ShowWindow();
	DisableWndStep2.SetFocus();
	switch(Result)
	{
		case 0:
			SetSuccessWnd(param);
			break;
		case 7:
			SetFailWnd(3675);
			break;
		case 1:
		case 2:
		case 3:
		case 4:
		case 5:
		case 6:
		case 11:
		default:
			SetFailWnd(4334);
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
	Info = GetItemInfoByIndex(GetCurrentSelectedIndex());
	Result_ItemWnd.AddItem(Info);
	ItemName_TextBox.SetText(((GetItemNameAll(Info) @ "x") $ ItemCount_EditBox.GetString()));
	Discription_TextBox.SetText(GetSystemMessage(4570));
	ShopDailySuccess_ResultWnd.ShowWindow();
	ShopDailySuccess_ResultWnd.SetFocus();
	return;
}

function SetFailWnd(int msgIndex)
{
	local TextBoxHandle Discription_TextBox;

	Discription_TextBox = GetTextBoxHandle((m_Windowname $ ".ShopDailyFails_ResultWnd.Discription_TextBox"));
	Discription_TextBox.SetText(GetSystemMessage(msgIndex));
	DisableWndStep2.ShowWindow();
	DisableWndStep2.SetFocus();
	ShopDailyFails_ResultWnd.ShowWindow();
	ShopDailyFails_ResultWnd.SetFocus();
	return;
}

function bool IsMyShopIndex(string param)
{
	local int sshopIndex;

	ParseInt(param, "ShopIndex", sshopIndex);
	return (3 == sshopIndex);
}

function int GetCurrentCategory()
{
	return tabGroupButton._GetGroupButtonsInstance()._getSelectedButtonValue();
}

function string GetProductNameByIndex(int Index)
{
	local string fullNameString;
	local PLShopItemDataStruct ItemData;
	local LCoinShopProductUIData productData;

	ItemData = pLShopItemDataList[Index];
	API_GetLCoinShopProductData(ItemData.nSlotNum, productData);
	fullNameString = productData.BuyItems[ItemData.sCircleNum].ProductName;
	if(ItemData.isRelay)
	{
		return (((fullNameString @ "/") @ string((ItemData.sCircleNum + 1))) $ GetSystemString(2980));
	}
	return fullNameString;
}

function int GetProductCategoryByIndex(int Index)
{
	local PLShopItemDataStruct ItemData;
	local LCoinShopProductUIData productData;

	if((Index == -1))
	{
		Index = GetCurrentSelectedIndex();
	}
	ItemData = pLShopItemDataList[Index];
	API_GetLCoinShopProductData(ItemData.nSlotNum, productData);
	return productData.Category;
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

function int GetCurrentSelectedIndex()
{
	local RichListCtrlHandle ListCtrl;
	local RichListCtrlRowData Record;

	if((GetCurrentCategory() == 0))
	{
		return currentSelectHomeIndex;
	}
	ListCtrl = getListCtrlByCategory(GetCurrentCategory());
	ListCtrl.GetSelectedRec(Record);
	return int(Record.nReserved1);
}

function bool GetStringIDFromBtnName(string btnName, string someString, out string strID)
{
	if(!CheckBtnName(btnName, someString))
	{
		return false;
	}
	strID = Mid(btnName, Len(someString));
	return true;
}

function bool CheckBtnName(string btnName, string someString)
{
	return (Left(btnName, Len(someString)) == someString);
}

function string GetItemTextureNameByClassID(int ClassID)
{
	local ItemID cID;

	cID.ClassID = ClassID;
	return Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(cID);
}

function INT64 GetAdenaNum(PLShopItemDataStruct ItemData)
{
	local int i;

	i = 0;
	while((i < 3))
	{
		if((ItemData.nCostItemId[i] == 57))
		{
			return ItemData.nCostItemAmount[i];
		}
		i++;
	}
	return INT64(-1);
}

function INT64 GetEinhasadCoinNum(PLShopItemDataStruct ItemData)
{
	local int i;

	i = 0;
	while((i < 3))
	{
		if((ItemData.nCostItemId[i] == 48472))
		{
			return ItemData.nCostItemAmount[i];
		}
		i++;
	}
	return INT64(-1);
}

function INT64 GetLcoinNum(PLShopItemDataStruct ItemData)
{
	local int i;

	i = 0;
	while((i < 3))
	{
		if((ItemData.nCostItemId[i] == 91663))
		{
			return ItemData.nCostItemAmount[i];
		}
		i++;
	}
	return INT64(-1);
}

function INT64 GetPCCafePointNum(PLShopItemDataStruct ItemData)
{
	local int i;

	i = 0;
	while((i < 3))
	{
		if((ItemData.nCostItemId[i] == -100))
		{
			return ItemData.nCostItemAmount[i];
		}
		i++;
	}
	return INT64(-1);
}

function INT64 GetVitalPointNum(PLShopItemDataStruct ItemData)
{
	local int i;

	i = 0;
	while((i < 3))
	{
		if((ItemData.nCostItemId[i] == -800))
		{
			return ItemData.nCostItemAmount[i];
		}
		i++;
	}
	return INT64(-1);
}

function INT64 GetAcoinNum(PLShopItemDataStruct ItemData)
{
	local int i;

	i = 0;
	while((i < 3))
	{
		if((ItemData.nCostItemId[i] == 97145))
		{
			return ItemData.nCostItemAmount[i];
		}
		i++;
	}
	return INT64(-1);
}

function INT64 GetChaoticEtherNum(PLShopItemDataStruct ItemData)
{
	local int i;

	i = 0;
	while((i < 3))
	{
		if((ItemData.nCostItemId[i] == 83182))
		{
			return ItemData.nCostItemAmount[i];
		}
		i++;
	}
	return INT64(-1);
}

function string GetLimitTypeIcon(UIEventManager.PLSHOP_LIMIT_TYPE Type)
{
	switch(Type)
	{
		case PLSHOP_LIMIT_NONE:
			return "L2UI_CT1.ShopDailyWnd.ShopDailyWnd_Icon_Infinity";
			break;
		case PLSHOP_LIMIT_CHARACTER:
			return "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Icon_Character";
			break;
		case PLSHOP_LIMIT_ACCOUNT:
			return "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Icon_Account";
			break;
		default:
			break;
	}
	return "";
}

function string GetLimitTypeIconString(UIEventManager.PLSHOP_LIMIT_TYPE Type, UIEventManager.PLSHOP_RESET_TYPE type2)
{
	switch(Type)
	{
		case PLSHOP_LIMIT_NONE:
			return GetSystemString(539);
			break;
		case PLSHOP_LIMIT_CHARACTER:
			if((int(type2) == 0))
			{
				return GetSystemString(13260);
			}
			else if((int(type2) == 1))
			{
				return GetSystemString(13259);
			}
			else if((int(type2) == 2))
			{
				return GetSystemString(13869);
			}
			else if((int(type2) == 3))
			{
				return GetSystemString(13871);
			}
			break;
		case PLSHOP_LIMIT_ACCOUNT:
			if((int(type2) == 0))
			{
				return GetSystemString(13262);
			}
			else if((int(type2) == 1))
			{
				return GetSystemString(13261);
			}
			else if((int(type2) == 2))
			{
				return GetSystemString(13868);
			}
			else if((int(type2) == 3))
			{
				return GetSystemString(13870);
			}
			break;
		default:
			break;
	}
	return "";
}

function string GetBuyTypeStringBuyLimit(UIEventManager.PLSHOP_LIMIT_TYPE Type, UIEventManager.PLSHOP_RESET_TYPE type2)
{
	switch(Type)
	{
		case PLSHOP_LIMIT_NONE:
			return "";
			break;
		case PLSHOP_LIMIT_CHARACTER:
		case PLSHOP_LIMIT_ACCOUNT:
			if((int(type2) == 0))
			{
				return "";
			}
			else if((int(type2) == 1))
			{
				return GetSystemString(13872);
			}
			else if((int(type2) == 2))
			{
				return GetSystemString(13873);
			}
			else if((int(type2) == 3))
			{
				return GetSystemString(13874);
			}
			break;
		default:
			break;
	}
	return "";
}

function string GetBuyTypeStringBuyRefresh(UIEventManager.PLSHOP_RESET_TYPE Type)
{
	switch(Type)
	{
		case PLSHOP_RESET_ALWAYS:
			return (("(" $ GetSystemString(5142)) $ ")");
			break;
		case PLSHOP_RESET_ONEDAY:
			return ((("(" $ "1") $ GetSystemString(1109)) $ ")");
			break;
		case PLSHOP_RESET_ONEWEEK:
			return (("(" $ GetSystemString(13866)) $ ")");
			break;
		case PLSHOP_RESET_ONEMONTH:
			return (("(" $ GetSystemString(13867)) $ ")");
			break;
		default:
			break;
	}
	return "";
}

function string GetMarkIconByType(UIEventManager.ELCoinShopMarkType MarkType)
{
	switch(MarkType)
	{
		case LCoinShopMark_None:
			return "";
			break;
		case LCoinShopMark_Event:
			return "L2UI_CT1.ShopWnd.ShopDailyLcoinWnd_EventIcon_02";
			break;
		case LCoinShopMark_Sale:
			return "L2UI_CT1.ShopWnd.ShopDailyLcoinWnd_SaleIcon_02";
			break;
		case LCoinShopMark_Best:
			return "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_BestIcon";
			break;
		case LCoinShopMark_Limited:
			return "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_LimitedIcon";
			break;
		case LCoinShopMark_New:
			return "L2UI_EPIC.LCoinShopICON_ribbonNEW";
			break;
		default:
			return "L2UI_EPIC.LCoinShopWnd.RelayIcon";
			break;
	}
	return "";
}

function string GetMoneyIconByID(int cID)
{
	switch(cID)
	{
		case 57:
			return "L2UI_NewTex.LCoinShopWnd.bm_adena_Big";
		case 91663:
			return "L2UI_NewTex.LCoinShopWnd.bm_Lcoin";
		case -100:
			return GetPcCafeItemIconPackageName(true);
		case -800:
			return "L2UI_NewTex.LCoinShopWnd.bm_Sayhas";
		case 97145:
			return "L2UI_NewTex.LCoinShopWnd.bm_Acoin";
		case 83182:
			return "L2UI_NewTex.LCoinShopWnd.bm_chaotic_ether_Big";
		case 48472:
			return "L2UI_NewTex.LCoinShopWnd.bm_einhasad_coin_Big";
		default:
	}
}

function Color GetCategoryTextColor(string colorStr)
{
	switch(colorStr)
	{
		case "yellow":
			return GetColor(255, 204, 0, 255);
		default:
			return GetColor(230, 220, 190, 255);
	}
}

function TextureHandle GetRibbonTexture(int Index)
{
	return GetTextureHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".TabRibbon_tex") $ string(Index)));
}

function RichListCtrlHandle getListCtrlByCategory(int nCategory)
{
	return GetRichListCtrlHandle(((m_Windowname $ ".List_Wnd.List_ListCtrl") $ string(nCategory)));
}

function WindowHandle GetHomeMainByIndex(int Index)
{
	return GetWindowHandle(((m_Windowname $ ".Home_Wnd.Item_Big") $ string(Index)));
}

function ItemWindowHandle GetHomeMainItemByIndex(int Index)
{
	return GetItemWindowHandle((((m_Windowname $ ".Home_Wnd.Item_Big") $ string(Index)) $ ".item"));
}

function TextBoxHandle GetHomeMainText(int Index, int Num)
{
	return GetTextBoxHandle(((((m_Windowname $ ".Home_Wnd.Item_Big") $ string(Index)) $ ".text") $ string(Num)));
}

function TextureHandle GetHomeMainSaleType(int Index)
{
	return GetTextureHandle((((m_Windowname $ ".Home_Wnd.Item_Big") $ string(Index)) $ ".Sale"));
}

function TextureHandle GetHomeMainIconType(int Index)
{
	return GetTextureHandle((((m_Windowname $ ".Home_Wnd.Item_Big") $ string(Index)) $ ".IconMoney01"));
}

function ButtonHandle GetHomeMainBtnInfoByIndex(int Index)
{
	return GetButtonHandle((((m_Windowname $ ".Home_Wnd.Item_Big") $ string(Index)) $ ".BtnInfo"));
}

function ButtonHandle GetHomeMainBtnBuyByIndex(int Index)
{
	return GetButtonHandle((((m_Windowname $ ".Home_Wnd.Item_Big") $ string(Index)) $ ".BtnBuy"));
}

function TextureHandle GetHomeMainIconInfoByIndex(int Index)
{
	return GetTextureHandle((((m_Windowname $ ".Home_Wnd.Item_Big") $ string(Index)) $ ".IconInfo"));
}

function TextureHandle GetHomeMainIconBuyByIndex(int Index)
{
	return GetTextureHandle((((m_Windowname $ ".Home_Wnd.Item_Big") $ string(Index)) $ ".IconBuy"));
}

function WindowHandle GetHomeSubByIndex(int Index)
{
	return GetWindowHandle(((m_Windowname $ ".Home_Wnd.Item_Small") $ string(Index)));
}

function ItemWindowHandle GetHomeSubItemByIndex(int Index)
{
	return GetItemWindowHandle((((m_Windowname $ ".Home_Wnd.Item_Small") $ string(Index)) $ ".item"));
}

function TextBoxHandle GetHomeSubText(int Index, int Num)
{
	return GetTextBoxHandle(((((m_Windowname $ ".Home_Wnd.Item_Small") $ string(Index)) $ ".text") $ string(Num)));
}

function TextureHandle GetHomeSubSaleType(int Index)
{
	return GetTextureHandle((((m_Windowname $ ".Home_Wnd.Item_Small") $ string(Index)) $ ".Sale"));
}

function TextureHandle GetHomeSubIconType(int Index)
{
	return GetTextureHandle((((m_Windowname $ ".Home_Wnd.Item_Small") $ string(Index)) $ ".Icon3"));
}

function ButtonHandle GetHomeSubBtnInfoByIndex(int Index)
{
	return GetButtonHandle((((m_Windowname $ ".Home_Wnd.Item_Small") $ string(Index)) $ ".BtnInfo"));
}

function ButtonHandle GetHomeSubBtnBuyByIndex(int Index)
{
	return GetButtonHandle((((m_Windowname $ ".Home_Wnd.Item_Small") $ string(Index)) $ ".BtnBuy"));
}

function TextureHandle GetHomeSubIconInfoByIndex(int Index)
{
	return GetTextureHandle((((m_Windowname $ ".Home_Wnd.Item_Small") $ string(Index)) $ ".IconInfo"));
}

function TextureHandle GetHomeSubIconBuyByIndex(int Index)
{
	return GetTextureHandle((((m_Windowname $ ".Home_Wnd.Item_Small") $ string(Index)) $ ".IconBuy"));
}

function HideRelayItem()
{
	local ButtonHandle successBtn;

	buy_Wnd.SetWindowSize(418, 324);
	GetButtonHandle((m_Windowname $ ".ShopDailySuccess_ResultWnd.Fail_Button")).HideWindow();
	successBtn = GetButtonHandle((m_Windowname $ ".ShopDailySuccess_ResultWnd.Success_Button"));
	successBtn.SetAnchor((m_Windowname $ ".ShopDailySuccess_ResultWnd"), "BottomCenter", "BottomCenter", 0, -10);
	successBtn.SetButtonName(140);
	BuyRelay_Wnd.HideWindow();
	return;
}

function ShowRelayItem(array<LCoinShopBuyItemInfo> BuyItems, int nCircle)
{
	local string Path;
	local ItemWindowHandle iWnd0, iWnd1, iWnd2;
	local ButtonHandle successBtn;

	GetButtonHandle((m_Windowname $ ".ShopDailySuccess_ResultWnd.Fail_Button")).ShowWindow();
	successBtn = GetButtonHandle((m_Windowname $ ".ShopDailySuccess_ResultWnd.Success_Button"));
	successBtn.SetAnchor((m_Windowname $ ".ShopDailySuccess_ResultWnd"), "BottomCenter", "BottomRight", -3, -10);
	successBtn.SetButtonName(3135);
	Path = (m_Windowname $ ".Buy_Wnd.BuyRelay_Wnd.");
	iWnd0 = GetItemWindowHandle((Path $ "RelayItem01_ItemWindow"));
	iWnd1 = GetItemWindowHandle((Path $ "RelayItem02_ItemWindow"));
	iWnd2 = GetItemWindowHandle((Path $ "RelayItem03_ItemWindow"));
	iWnd0.Clear();
	iWnd1.Clear();
	iWnd2.Clear();
	if((nCircle > 0))
	{
		iWnd0.AddItem(GetItemInfoLCoinShopBuyItemInfo(BuyItems[(nCircle - 1)]));
		GetWindowHandle((Path $ "BuyRelayArrow01_Tex")).ShowWindow();
		iWnd0.ShowWindow();
		GetTextureHandle((Path $ "RelayItem01SlotBg_Texture")).ShowWindow();
	}
	else
	{
		GetWindowHandle((Path $ "BuyRelayArrow01_Tex")).HideWindow();
		iWnd0.HideWindow();
		GetTextureHandle((Path $ "RelayItem01SlotBg_Texture")).HideWindow();
	}
	if((nCircle > -1))
	{
		iWnd1.AddItem(GetItemInfoLCoinShopBuyItemInfo(BuyItems[nCircle]));
		if((GetCountCanBuyByIndex(pLShopItemDataList[GetCurrentSelectedIndex()].Index) > 0))
		{
			GetWindowHandle((Path $ "RelayItem02SlotFrame_Texture")).ShowWindow();
		}
		else
		{
			GetWindowHandle((Path $ "RelayItem02SlotFrame_Texture")).HideWindow();
		}
	}
	if((nCircle < (BuyItems.Length - 1)))
	{
		iWnd2.AddItem(GetItemInfoLCoinShopBuyItemInfo(BuyItems[(nCircle + 1)]));
		GetWindowHandle((Path $ "RelayItem03SlotLock_Texture")).HideWindow();
		GetWindowHandle((Path $ "BuyRelayArrow02_Tex")).ShowWindow();
		iWnd2.ShowWindow();
		GetTextureHandle((Path $ "RelayItem03SlotBg_Texture")).ShowWindow();
	}
	else
	{
		GetWindowHandle((Path $ "RelayItem03SlotLock_Texture")).HideWindow();
		GetWindowHandle((Path $ "BuyRelayArrow02_Tex")).HideWindow();
		iWnd2.HideWindow();
		GetTextureHandle((Path $ "RelayItem03SlotBg_Texture")).HideWindow();
	}
	GetTextBoxHandle((Path $ "BuyRelayItemNum01_Txt")).SetText(string((nCircle + 1)));
	GetTextBoxHandle((Path $ "BuyRelayItemNum02_Txt")).SetText(string(BuyItems.Length));
	buy_Wnd.SetWindowSize(418, 418);
	BuyRelay_Wnd.ShowWindow();
	return;
}

function ItemInfo GetItemInfoLCoinShopBuyItemInfo(LCoinShopBuyItemInfo buyItem)
{
	local ItemInfo iInfo;

	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(buyItem.ItemClassID), iInfo);
	iInfo.ItemNum = INT64(buyItem.Count);
	iInfo.bShowCount = IsStackableItem(iInfo.ConsumeType);
	return iInfo;
}

function HandleRestart(string param)
{
	local int nQuitRestrictField;

	ClearAll();
	ParseInt(param, "QuitRestrictField", nQuitRestrictField);
	if((nQuitRestrictField == 0))
	{
		BannerWebHandle.HideWindow();
		BannerWebHandle.ShowWindow();
	}
	return;
}

function HandleFormByLanguage()
{
	local int i;
	local string anchorName;

	if((int(GetLanguage()) == 0))
	{
		return;
	}
	i = 0;
	while((i < 2))
	{
		GetHomeMainBtnInfoByIndex(i).HideWindow();
		GetHomeMainIconInfoByIndex(i).HideWindow();
		anchorName = ((m_Windowname $ ".Home_Wnd.") $ GetHomeMainBtnBuyByIndex(i).GetParentWindowName());
		GetHomeMainBtnBuyByIndex(i).SetAnchor(anchorName, "BottomCenter", "BottomCenter", 0, -10);
		GetHomeMainIconBuyByIndex(i).SetAnchor(anchorName, "BottomCenter", "BottomCenter", 0, -16);
		i++;
	}
	i = 0;
	while((i < 4))
	{
		GetHomeSubBtnInfoByIndex(i).HideWindow();
		GetHomeSubIconInfoByIndex(i).HideWindow();
		anchorName = ((m_Windowname $ ".Home_Wnd.") $ GetHomeSubBtnBuyByIndex(i).GetParentWindowName());
		GetHomeSubBtnBuyByIndex(i).SetAnchor(anchorName, "BottomCenter", "BottomCenter", 0, -10);
		GetHomeSubIconBuyByIndex(i).SetAnchor(anchorName, "BottomCenter", "BottomCenter", 0, -16);
		i++;
	}
	return;
}

defaultproperties
{
	m_Windowname="ShopLcoinWnd"
}
