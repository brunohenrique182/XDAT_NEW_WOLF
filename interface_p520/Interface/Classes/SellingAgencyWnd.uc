class SellingAgencyWnd extends UICommonAPI;

const TIMER_SEARCH_ID = 2001001;
const TIMER_CATEGORYTREE_SEARCH_ID = 2001002;
const TIMER_RE_SEARCH_ID = 2001003;
const TIMER_SEARCH_DELAY = 700;
const TIMER_Re_SEARCH_DELAY = 350;
const SEARCH_FAIL_REASON_DELAY = -1;
const DIALOG_STACKABLE_ITEM_ACCOMPANY_TO_INVEN = 200000;
const DIALOG_STACKABLE_ITEM_INVEN_TO_ACCOMPANY = 200001;
const DIALOG_RECEIVE_ADENA = 200002;
const DIALOG_NOTIFY_SEND_POST = 200003;
const DIALOG_ONLY_NOTICE = 200004;
const DIALOG_ASK_PRICE = 200005;
const DIALOG_ASK_REGISTITEM = 200006;
const DIALOG_ASK_BUY = 200007;
const DIALOG_ASK_DELETE = 200008;
const DIALOG_FREEUSER_ONREGISTE = 200009;
const COMMISSION_MIN_PRICE = 10000;
const COMMISSION_REGISTER_MIN_PRICE = 1000;
const COMMISSION_REGISTER_MIN_PRICE_30 = 700;
const MAX_SELLINGITEM_NUM = 10;
const MAX_SELLING_AMOUNT = 99999;

var WindowHandle Me;
var WindowHandle disableWnd;
var TabHandle TabCtrl;
var TextureHandle TabLineBg;
var TextureHandle tabBg;
var WindowHandle SellingListWnd;
var WindowHandle DescriptionMsgWnd;
var TextBoxHandle DescriptionMsg;
var TextBoxHandle Type_Title;
var ComboBoxHandle Type_Combobox;
var TextBoxHandle Grade_Title;
var ComboBoxHandle Grade_Combobox;
var TextBoxHandle SearchWord_Title;
var EditBoxHandle SearchWord_Editbox;
var ButtonHandle searchBtn;
var ButtonHandle resetBtn;
var TextureHandle SearchGroupBox;
var TextBoxHandle Sort_Title;
var TreeHandle SortListTree;
var TextureHandle SortGroupbox;
var WindowHandle HelpHtmlWnd;
var TextBoxHandle HelpHtmlWnd_Title;
var HtmlHandle HtmlViewer;
var WindowHandle SellingItemListWnd;
var TextBoxHandle SellingItemList_Title;
var TextBoxHandle SellingItemNumber;
var ListCtrlHandle SellingItemListCtrl;
var TextureHandle SellingItemListCtrlDeco;
var TextureHandle SellingItemListGroupbox;
var TextureHandle SellingItemListCtrlGroupboxDivider;
var ButtonHandle refreshBtn;
var ButtonHandle BuyBtn;
var WindowHandle MyListWnd;
var TextBoxHandle MyList_Title;
var TextBoxHandle MySellingItemList_Title;
var TextBoxHandle MySellingItemNumber;
var ListCtrlHandle MySellingItemListCtrl;
var TextureHandle MySellingItemListCtrlDeco;
var ButtonHandle SellCancelBtn;
var ButtonHandle SellBtn;
var TextureHandle MySellingItemListGroupbox;
var WindowHandle SellingItemRegistrationWnd;
var TextBoxHandle SellingItemRegistrationWind_Title;
var TextBoxHandle SellingPossibItem_Title;
var ItemWindowHandle MySellingPossibItem;
var TextureHandle MySellingPossibItembg;
var TextureHandle MySellingPossibItemGroupbox;
var TextBoxHandle MySellingItem_Title;
var ItemWindowHandle MySellingItemIcon;
var TextureHandle MySellingItemSlotBg;
var NameCtrlHandle MySellingItemName;
var TextureHandle MySellingItemPropertyIcon_01;
var TextureHandle MySellingItemPropertyIcon_02;
var TextureHandle MySellingItemPropertyIcon_03;
var TextureHandle MySellingItemPropertyIcon_04;
var TextBoxHandle MySellingItemPropertyValue_01;
var TextBoxHandle MySellingItemPropertyValue_02;
var TextBoxHandle MySellingItemPropertyValue_03;
var TextBoxHandle MySellingItemPropertyValue_04;
var TextureHandle MySellingItemGroupbox;
var TextBoxHandle MySellingItemUnitPrice_Title;
var ButtonHandle MySellingItemUnitPriceEditBtn;
var TextureHandle MySellingItemUnitPriceAdenaIcon;
var EditBoxHandle MySellingItemUnitPriceEdit;
var TextBoxHandle MySellingItemUnitPrice_ReadingText;
var TextBoxHandle MySellingItemAmount_Title;
var TextBoxHandle MySellingItemAmount;
var TextureHandle GroupboxDivider_01;
var TextBoxHandle MySellingItemRegistPeriod_Title;
var ComboBoxHandle MySellingItemRegistPeriodComboBox;
var TextureHandle GroupboxDivider_02;
var TextBoxHandle MySellingItemTotalPrice_Title;
var TextureHandle MySellingItemTotalPriceAdenaIcon;
var TextBoxHandle MySellingItemTotalPrice;
var TextBoxHandle MySellingItemTotalPrice_ReadingText;
var TextureHandle GroupboxDivider_03;
var TextBoxHandle MySellingItemCharge_Title;
var ButtonHandle MySellingItemChargeEditBtn;
var TextureHandle MySellingItemChargeAdenaIcon;
var TextBoxHandle MySellingItemSellCharge;
var TextBoxHandle MySellingItemCharge;
var TextureHandle MySellingItemChargeTextBoxBg;
var TextureHandle GroupboxDivider_04;
var ButtonHandle RegistBtn;
var ButtonHandle CancelBtn;
var TextureHandle MySellingItemInfoGroupbox;
var TextBoxHandle MyAdena;
var TextBoxHandle MyAdena2;
var WindowHandle m_inventoryWnd;
var int maxSellingItemNum;
var string saveTreePath;
var bool disableCurrentWindowFlag;
var L2Util util;
var array<string> titleNameArray;
var array<string> categoryTypeNameArray;
var array<string> item1Array;
var array<string> item2Array;
var array<string> item3Array;
var array<string> item4Array;
var array<string> item5Array;
var array<string> item6Array;
var array<CommissionPremiumItemInfo> sellPremiumitemArray;
var string treeParam;
var string openTreeParam;
var string currentTreeNodeSelected;
var string beforeTreeNodeSelected;
var bool beforeTreeNodeSelectedFlag;
var string beforeTreeNodeCalled;
var int nCurrentTypeCombo;
var int nCurrentGradeCombo;
var ItemInfo saveTempItemInfo;
var int nSaveTempItemIndex;
var int nItemCheckState;
var int listCommissionStatus;
var string startItemWIndowName;
var int deleteIndexMySellingItemListCtrl;
var INT64 beforeAmount;
var INT64 beforePrePrice;
var int beforePeriod;
var int beforeDiscountType;
var Rect MySellingItemListCtrlRect;
var bool allItemCountFlag;
var ItemInfo beforeDropItemInfo;
var string commissionStr;
var string commissionSellCompleteStr;

function OnRegisterEvent()
{
	RegisterEvent(5490);
	RegisterEvent(5498);
	RegisterEvent(5499);
	RegisterEvent(5510);
	RegisterEvent(5520);
	RegisterEvent(5492);
	RegisterEvent(5495);
	RegisterEvent(5540);
	RegisterEvent(5550);
	RegisterEvent(5500);
	RegisterEvent(5570);
	RegisterEvent(5560);
	RegisterEvent(5535);
	RegisterEvent(5571);
	RegisterEvent(1710);
	RegisterEvent(1720);
	RegisterEvent(40);
	RegisterEvent(5572);
	return;
}

function OnShow()
{
	PlayConsoleSound(IFST_WINDOW_OPEN);
	util.ItemRelationWindowHide("SellingAgencyWnd");
	updateRecordItemCount();
	ResetUI();
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	util = L2Util(GetScript("L2Util"));
	Initialize();
	categoryTreeInit();
	return;
}

function ResetUI()
{
	if(IsBuilderPC())
	{
		maxSellingItemNum = 99999;
	}
	else
	{
		maxSellingItemNum = 10;
	}
	sellPremiumitemArray.Length = 0;
	DisableCurrentWindow(false);
	TabCtrl.SetTopOrder(0, false);
	SellingItemListCtrl.DeleteAllItem();
	MySellingItemListCtrl.DeleteAllItem();
	Type_Combobox.SetSelectedNum(0);
	Grade_Combobox.SetSelectedNum(0);
	SearchWord_Editbox.SetString("");
	MySellingItemNumber.SetText("");
	MySellingPossibItem.Clear();
	MySellingItemIcon.Clear();
	comboInit();
	initRegistItemForm();
	clickTreeState("root.list1");
	updateAdenaText();
	MySellingItemListCtrl.EnablePageBrowser(false);
	return;
}

function Initialize()
{
	Me = GetWindowHandle("SellingAgencyWnd");
	disableWnd = GetWindowHandle("SellingAgencyWnd.DisableWnd");
	TabCtrl = GetTabHandle("SellingAgencyWnd.TabCtrl");
	TabLineBg = GetTextureHandle("SellingAgencyWnd.TabLineBg");
	tabBg = GetTextureHandle("SellingAgencyWnd.TabBg");
	SellingListWnd = GetWindowHandle("SellingAgencyWnd.SellingListWnd");
	DescriptionMsgWnd = GetWindowHandle("SellingAgencyWnd.SellingListWnd.DescriptionMsgWnd");
	DescriptionMsg = GetTextBoxHandle("SellingAgencyWnd.SellingListWnd.DescriptionMsgWnd.DescriptionMsg");
	Type_Title = GetTextBoxHandle("SellingAgencyWnd.SellingListWnd.Type_Title");
	Type_Combobox = GetComboBoxHandle("SellingAgencyWnd.SellingListWnd.Type_Combobox");
	Grade_Title = GetTextBoxHandle("SellingAgencyWnd.SellingListWnd.Grade_Title");
	Grade_Combobox = GetComboBoxHandle("SellingAgencyWnd.SellingListWnd.Grade_Combobox");
	SearchWord_Title = GetTextBoxHandle("SellingAgencyWnd.SellingListWnd.SearchWord_Title");
	SearchWord_Editbox = GetEditBoxHandle("SellingAgencyWnd.SellingListWnd.SearchWord_Editbox");
	searchBtn = GetButtonHandle("SellingAgencyWnd.SellingListWnd.SearchBtn");
	resetBtn = GetButtonHandle("SellingAgencyWnd.SellingListWnd.ResetBtn");
	SearchGroupBox = GetTextureHandle("SellingAgencyWnd.SellingListWnd.SearchGroupBox");
	Sort_Title = GetTextBoxHandle("SellingAgencyWnd.SellingListWnd.Sort_Title");
	MyAdena = GetTextBoxHandle("SellingAgencyWnd.SellingListWnd.MyAdena");
	MyAdena2 = GetTextBoxHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MyAdena2");
	SortListTree = GetTreeHandle("SellingAgencyWnd.SellingListWnd.SortListTree");
	SortGroupbox = GetTextureHandle("SellingAgencyWnd.SellingListWnd.SortGroupbox");
	HelpHtmlWnd = GetWindowHandle("SellingAgencyWnd.SellingListWnd.HelpHtmlWndSelling");
	HelpHtmlWnd_Title = GetTextBoxHandle("SellingAgencyWnd.SellingListWnd.HelpHtmlWndSelling.HelpHtmlWnd_Title");
	HtmlViewer = GetHtmlHandle("SellingAgencyWnd.SellingListWnd.HelpHtmlWndSelling.HtmlViewer");
	SellingItemListWnd = GetWindowHandle("SellingAgencyWnd.SellingListWnd.SellingItemListWnd");
	SellingItemList_Title = GetTextBoxHandle("SellingAgencyWnd.SellingListWnd.SellingItemListWnd.SellingItemList_Title");
	SellingItemNumber = GetTextBoxHandle("SellingAgencyWnd.SellingListWnd.SellingItemListWnd.SellingItemNumber");
	SellingItemListCtrl = GetListCtrlHandle("SellingAgencyWnd.SellingListWnd.SellingItemListWnd.SellingItemListCtrl");
	SellingItemListCtrlDeco = GetTextureHandle("SellingAgencyWnd.SellingListWnd.SellingItemListWnd.SellingItemListCtrlDeco");
	SellingItemListGroupbox = GetTextureHandle("SellingAgencyWnd.SellingListWnd.SellingItemListWnd.SellingItemListGroupbox");
	SellingItemListCtrlGroupboxDivider = GetTextureHandle("SellingAgencyWnd.MyListWnd.SellingItemListCtrlGroupboxDivider");
	refreshBtn = GetButtonHandle("SellingAgencyWnd.SellingListWnd.RefreshBtn");
	BuyBtn = GetButtonHandle("SellingAgencyWnd.SellingListWnd.BuyBtn");
	MyListWnd = GetWindowHandle("SellingAgencyWnd.MyListWnd");
	MyList_Title = GetTextBoxHandle("SellingAgencyWnd.MyListWnd.MyList_Title");
	MySellingItemList_Title = GetTextBoxHandle("SellingAgencyWnd.MyListWnd.MySellingItemList_Title");
	MySellingItemNumber = GetTextBoxHandle("SellingAgencyWnd.MyListWnd.MySellingItemNumber");
	MySellingItemListCtrl = GetListCtrlHandle("SellingAgencyWnd.MyListWnd.MySellingItemListCtrl");
	MySellingItemListCtrlDeco = GetTextureHandle("SellingAgencyWnd.MyListWnd.MySellingItemListCtrlDeco");
	SellCancelBtn = GetButtonHandle("SellingAgencyWnd.MyListWnd.SellCancelBtn");
	SellBtn = GetButtonHandle("SellingAgencyWnd.MyListWnd.SellBtn");
	MySellingItemListGroupbox = GetTextureHandle("SellingAgencyWnd.MyListWnd.MySellingItemListGroupbox");
	SellingItemRegistrationWnd = GetWindowHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd");
	SellingItemRegistrationWind_Title = GetTextBoxHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.SellingItemRegistrationWind_Title");
	SellingPossibItem_Title = GetTextBoxHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.SellingPossibItem_Title");
	MySellingPossibItem = GetItemWindowHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingPossibItem");
	MySellingPossibItembg = GetTextureHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingPossibItembg");
	MySellingPossibItemGroupbox = GetTextureHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingPossibItemGroupbox");
	MySellingItem_Title = GetTextBoxHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItem_Title");
	MySellingItemIcon = GetItemWindowHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemIcon");
	MySellingItemSlotBg = GetTextureHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemSlotBg");
	MySellingItemName = GetNameCtrlHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemName");
	MySellingItemPropertyIcon_01 = GetTextureHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemPropertyIcon_01");
	MySellingItemPropertyIcon_02 = GetTextureHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemPropertyIcon_02");
	MySellingItemPropertyIcon_03 = GetTextureHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemPropertyIcon_03");
	MySellingItemPropertyIcon_04 = GetTextureHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemPropertyIcon_04");
	MySellingItemPropertyValue_01 = GetTextBoxHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemPropertyValue_01");
	MySellingItemPropertyValue_02 = GetTextBoxHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemPropertyValue_02");
	MySellingItemPropertyValue_03 = GetTextBoxHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemPropertyValue_03");
	MySellingItemPropertyValue_04 = GetTextBoxHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemPropertyValue_04");
	MySellingItemGroupbox = GetTextureHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemGroupbox");
	MySellingItemUnitPrice_Title = GetTextBoxHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemUnitPrice_Title");
	MySellingItemUnitPriceEditBtn = GetButtonHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemUnitPriceEditBtn");
	MySellingItemUnitPriceAdenaIcon = GetTextureHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemUnitPriceAdenaIcon");
	MySellingItemUnitPriceEdit = GetEditBoxHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemUnitPriceEdit");
	MySellingItemUnitPrice_ReadingText = GetTextBoxHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemUnitPrice_ReadingText");
	MySellingItemAmount_Title = GetTextBoxHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemAmount_Title");
	MySellingItemAmount = GetTextBoxHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemAmount");
	GroupboxDivider_01 = GetTextureHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.GroupboxDivider_01");
	MySellingItemRegistPeriod_Title = GetTextBoxHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemRegistPeriod_Title");
	MySellingItemRegistPeriodComboBox = GetComboBoxHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemRegistPeriodComboBox");
	GroupboxDivider_02 = GetTextureHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.GroupboxDivider_02");
	MySellingItemTotalPrice_Title = GetTextBoxHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemTotalPrice_Title");
	MySellingItemTotalPriceAdenaIcon = GetTextureHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemTotalPriceAdenaIcon");
	MySellingItemTotalPrice = GetTextBoxHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemTotalPrice");
	MySellingItemTotalPrice_ReadingText = GetTextBoxHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemTotalPrice_ReadingText");
	GroupboxDivider_03 = GetTextureHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.GroupboxDivider_03");
	MySellingItemCharge_Title = GetTextBoxHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemCharge_Title");
	MySellingItemChargeEditBtn = GetButtonHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemChargeEditBtn");
	MySellingItemChargeAdenaIcon = GetTextureHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemChargeAdenaIcon");
	MySellingItemCharge = GetTextBoxHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemCharge");
	MySellingItemSellCharge = GetTextBoxHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemSellCharge");
	MySellingItemChargeTextBoxBg = GetTextureHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemChargeTextBoxBg");
	GroupboxDivider_04 = GetTextureHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.GroupboxDivider_04");
	RegistBtn = GetButtonHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.RegistBtn");
	CancelBtn = GetButtonHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.CancelBtn");
	MySellingItemInfoGroupbox = GetTextureHandle("SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemInfoGroupbox");
	m_inventoryWnd = GetWindowHandle("InventoryWnd");
	MySellingItemListCtrlRect = MySellingItemListCtrl.GetRect();
	SellingItemListCtrl.SetSelectedSelTooltip(false);
	SellingItemListCtrl.SetAppearTooltipAtMouseX(true);
	MySellingItemListCtrl.SetSelectedSelTooltip(false);
	MySellingItemListCtrl.SetAppearTooltipAtMouseX(true);
	return;
}

function updateAdenaText()
{
	local string Adenastring;

	Adenastring = MakeCostString(string(GetAdena()));
	MyAdena.SetText(Adenastring);
	MyAdena.SetTooltipString(ConvertNumToText(string(GetAdena())));
	MyAdena2.SetText(Adenastring);
	MyAdena2.SetTooltipString(ConvertNumToText(string(GetAdena())));
	return;
}

function comboInit()
{
	Type_Combobox.Clear();
	Type_Combobox.SYS_AddString(144);
	Type_Combobox.SYS_AddString(2611);
	Type_Combobox.SYS_AddString(2621);
	Type_Combobox.SetSelectedNum(0);
	Grade_Combobox.Clear();
	Grade_Combobox.SYS_AddString(144);
	Grade_Combobox.SYS_AddString(2622);
	Grade_Combobox.SYS_AddString(2613);
	Grade_Combobox.SYS_AddString(2614);
	Grade_Combobox.SYS_AddString(2615);
	Grade_Combobox.SYS_AddString(2616);
	Grade_Combobox.SYS_AddString(2617);
	Grade_Combobox.SYS_AddString(2682);
	Grade_Combobox.SYS_AddString(2618);
	Grade_Combobox.SYS_AddString(2619);
	Grade_Combobox.SYS_AddString(2620);
	Grade_Combobox.SYS_AddString(3919);
	Grade_Combobox.SYS_AddString(14477);
	Grade_Combobox.SetSelectedNum(0);
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 5490:
			updateAdenaText();
			itemCommissionWndShowHandler(param);
			break;
		case 5498:
			Debug("판매대행 유로아이템 리셋");  // EN: sales agency Euro item reset
			updateAdenaText();
			SellingPremiumItemRegisterReset(param);
			break;
		case 5499:
			Debug(("판매대행 유로아이템" @ param));  // EN: sales agency Euro item
			updateAdenaText();
			SellingPremiumItemRegisterAdd(param);
			break;
		case 5510:
			updateAdenaText();
			startListHandler(param);
			break;
		case 5520:
			updateAdenaText();
			addElementAtList(param);
			break;
		case 5492:
			updateAdenaText();
			itemCommissionWndListStartHandler(param);
			break;
		case 5495:
			updateAdenaText();
			registrableItemAdd(param);
			break;
		case 5500:
			updateAdenaText();
			itemCommissionWndResponseInfoHandler(param);
			break;
		case 5570:
			updateAdenaText();
			itemCommissionWndRegisterResultHandler(param);
			break;
		case 5560:
			updateAdenaText();
			ItemCommissionWndDeleteResultHandler(param);
			break;
		case 5540:
			updateAdenaText();
			askDialogBuyItem(param);
			break;
		case 5550:
			updateAdenaText();
			ItemCommmissionWndBuyResultHandler(param);
			break;
		case 5571:
			OnReceivedCloseUI();
			break;
		case 5535:
			updateAdenaText();
			itemCommissionWndSearchFailHandler(param);
			break;
		case 1710:
			updateAdenaText();
			HandleDialogOK();
			break;
		case 1720:
			updateAdenaText();
			HandleDialogCancel();
			break;
		case 40:
			break;
		case 5572:
			DialogSetID(200009);
			DialogSetDefaultOK();
			DialogShow(DialogModalType_Modal, DialogType_OK, GetSystemMessage(4049));
			break;
		default:
			break;
	}
	return;
}

function OnHide()
{
	if(DialogIsMine())
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		DialogHide();
	}
	callRequestCommissionCancel();
	ResetUI();
	return;
}

function itemCommissionWndShowHandler(string param)
{
	local int Result;

	ParseInt(param, "Result", Result);
	if((Result == 1))
	{
		ResetUI();
		Me.ShowWindow();
	}
	return;
}

function itemCommissionWndListStartHandler(string param)
{
	local int Cnt;

	ParseInt(param, "cnt", Cnt);
	if((Cnt <= 0))
	{
		if(SellingListWnd.IsShowWindow())
		{
			DescriptionMsgWnd.ShowWindow();
			DescriptionMsg.SetText(GetSystemMessage(3369));
		}
	}
	MySellingPossibItem.Clear();
	MySellingItemIcon.Clear();
	updateSellRegisterForm();
	return;
}

function itemCommissionWndSearchFailHandler(string param)
{
	local int failReason;

	ParseInt(param, "ErrorMsg", failReason);
	if((TabCtrl.GetTopIndex() == 1))
	{
		MySellingItemListCtrl.DeleteAllItem();
	}
	if((failReason == -1))
	{
		startReSearchDelay();
		return;
	}
	if((currentTreeNodeSelected != "root.list0"))
	{
		SellingItemListCtrl.DeleteAllItem();
		DescriptionMsgWnd.ShowWindow();
		MySellingItemNumber.SetText((((("(" $ string(MySellingItemListCtrl.GetRecordCount())) $ "/") $ string(maxSellingItemNum)) $ ")"));
		if((SearchWord_Editbox.GetString() == ""))
		{
			DescriptionMsg.SetText(GetSystemMessage(3372));
		}
		else
		{
			DescriptionMsg.SetText(MakeFullSystemMsg(GetSystemMessage(3502), SearchWord_Editbox.GetString()));
		}
		SellingItemNumber.SetText((("(" $ string(SellingItemListCtrl.GetRecordCount())) $ ")"));
	}
	return;
}

function ItemCommmissionWndBuyResultHandler(string param)
{
	local int Result, Enchant, ClassID;
	local ItemID mItemID;
	local INT64 Amount;
	local ItemInfo targetItemInfo;

	ParseInt(param, "Result", Result);
	ParseInt(param, "Enchant", Enchant);
	ParseINT64(param, "Amount", Amount);
	ParseInt(param, "ClassId", ClassID);
	mItemID.ClassID = ClassID;
	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(mItemID, targetItemInfo);
	if((Result == 1))
	{
		targetItemInfo.Enchanted = Enchant;
		targetItemInfo.AllItemCount = Amount;
		AddSystemMessageString(MakeFullSystemMsg(GetSystemMessage(3530), getItemNameForSellingAgency(targetItemInfo), string(Amount)));
	}
	Me.EnableWindow();
	sellListSearch();
	return;
}

function ItemCommissionWndDeleteResultHandler(string param)
{
	local int Result;

	ParseInt(param, "Result", Result);
	if((Result == 1))
	{
	}
	if((listCommissionStatus == 2))
	{
		MySellingItemNumber.SetText((((("(" $ string(MySellingItemListCtrl.GetRecordCount())) $ "/") $ string(maxSellingItemNum)) $ ")"));
	}
	else
	{
		SellingItemNumber.SetText((("(" $ string(SellingItemListCtrl.GetRecordCount())) $ ")"));
	}
	clickTabButton("TabCtrl1");
	return;
}

function startListHandler(string param)
{
	local int moreThanMax, listType, continuousList;

	DescriptionMsgWnd.HideWindow();
	DescriptionMsg.SetText("");
	ParseInt(param, "MoreThanMax", moreThanMax);
	ParseInt(param, "ListType", listType);
	ParseInt(param, "ContinuousList", continuousList);
	if((moreThanMax != 0))
	{
		AddSystemMessage(3489);
	}
	listCommissionStatus = listType;
	if((continuousList == 0))
	{
		switch(listType)
		{
			case 1:
				SellingItemListCtrl.DeleteAllItem();
				break;
			case 2:
				MySellingItemListCtrl.DeleteAllItem();
				break;
			case 3:
				SellingItemListCtrl.DeleteAllItem();
				break;
			case 4:
				break;
			default:
				Debug(("ListStart Error:" @ param));
		}
	}
	return;
}

function itemCommissionWndResponseInfoHandler(string param)
{
	local int Result, ClassID, Period;
	local INT64 prePrice, Amount;
	local ItemInfo initInfo;

	ParseInt(param, "Result", Result);
	ParseInt(param, "ClassID", ClassID);
	ParseInt(param, "Period", Period);
	ParseINT64(param, "Amount", Amount);
	ParseINT64(param, "prePrice", prePrice);
	if((startItemWIndowName == "MySellingItemIcon"))
	{
		MoveItemTopToBottom(nSaveTempItemIndex, false);
	}
	else if((startItemWIndowName == "MySellingPossibItem"))
	{
		MoveItemBottomToTop(nSaveTempItemIndex, false);
	}
	if((Result == 1))
	{
		if((beforeDropItemInfo.AllItemCount > INT64(0)))
		{
			if((beforeDropItemInfo.ItemNum > INT64(99999)))
			{
				DialogSetString(string(99999));
			}
			else
			{
				DialogSetString(string(beforeDropItemInfo.ItemNum));
			}
		}
		else if((Amount >= INT64(1)))
		{
			DialogSetString(string(Amount));
		}
		if((((beforeDropItemInfo.ItemNum > INT64(1)) || (Amount > INT64(1))) || IsStackableItem(beforeDropItemInfo.ConsumeType)))
		{
		}
		else
		{
			MySellingItemUnitPriceEdit.SetFocus();
		}
		if((Period >= 0))
		{
			MySellingItemRegistPeriodComboBox.SetSelectedNum(Period);
		}
		if((prePrice > INT64(0)))
		{
			MySellingItemUnitPriceEdit.SetString(string(prePrice));
		}
		beforeAmount = Amount;
		beforePeriod = Period;
		beforePrePrice = prePrice;
		updateSellRegisterForm();
	}
	else
	{
		startItemWIndowName = "";
	}
	beforeDropItemInfo = initInfo;
	return;
}

function itemCommissionWndRegisterResultHandler(string param)
{
	local int Result, Ok;

	ParseInt(param, "Result", Result);
	ParseInt(param, "Ok", Ok);
	if(((Result == 1) || (Ok == 1)))
	{
	}
	OnClickButton("TabCtrl1");
	return;
}

function registrableItemAdd(string param)
{
	local ItemInfo Info;

	ParamToItemInfo(param, Info);
	MySellingPossibItem.AddItem(Info);
	return;
}

function OnDBClickItem(string ControlName, int Index)
{
	local ItemInfo Info;

	if((ControlName == "MySellingPossibItem"))
	{
		MySellingPossibItem.GetItem(Index, Info);
		nSaveTempItemIndex = Index;
		saveTempItemInfo = Info;
		beforeDropItemInfo = Info;
		startItemWIndowName = "MySellingItemIcon";
		callRequestCommissionInfo(Info);
	}
	else if((ControlName == "MySellingItemIcon"))
	{
		MySellingItemIcon.GetItem(Index, Info);
		if((Index >= 0))
		{
			MoveItemBottomToTop(Index, false);
		}
	}
	return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
	if((ListCtrlID == "SellingItemListCtrl"))
	{
		OnBuyBtnClick();
	}
	if((ListCtrlID == "MySellingItemListCtrl"))
	{
		OnSellCancelBtnClick();
	}
	return;
}

function OnDropItem(string strID, ItemInfo Info, int X, int Y)
{
	local int Index;
	local ItemInfo initInfo;

	Debug(((("OnDropItem strID " $ strID) $ ", src=") $ Info.DragSrcName));
	Index = -1;
	if((Info.DragSrcName == "MySellingPossibItem"))
	{
		if((strID == "MySellingPossibItem"))
		{
			return;
		}
		Index = MySellingPossibItem.FindItem(Info.Id);
		nSaveTempItemIndex = Index;
		saveTempItemInfo = Info;
		startItemWIndowName = "MySellingItemIcon";
		beforeDropItemInfo = Info;
		callRequestCommissionInfo(Info);
	}
	else if((Info.DragSrcName == "MySellingItemIcon"))
	{
		beforeDropItemInfo = initInfo;
		Index = MySellingItemIcon.FindItem(Info.Id);
		if((Index >= 0))
		{
			MoveItemBottomToTop(Index, (Info.AllItemCount > INT64(0)));
		}
	}
	return;
}

function MoveItemTopToBottom(int Index, bool bAllItem)
{
	local ItemInfo Info, topInfo;
	local int topIndex;

	if(MySellingPossibItem.GetItem(Index, Info))
	{
		if(((!bAllItem && IsStackableItem(Info.ConsumeType)) && (Info.ItemNum >= INT64(1))))
		{
			DisableCurrentWindow(true);
			DialogSetID(200001);
			DialogSetEditBoxMaxLength(6);
			DialogSetReservedItemID(Info.Id);
			DialogSetParamInt64(Info.ItemNum);
			DialogSetDefaultOK();
			DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(3496), Info.Name, ""));
		}
		else
		{
			if(((MySellingItemIcon.FindItem(Info.Id) == -1) && (MySellingItemIcon.GetItemNum() > 0)))
			{
				MoveItemBottomToTop(0, true);
			}
			MySellingPossibItem.DeleteItem(Index);
			topIndex = MySellingItemIcon.FindItem(Info.Id);
			if(((topIndex >= 0) && IsStackableItem(Info.ConsumeType)))
			{
				MySellingItemIcon.GetItem(topIndex, topInfo);
				(topInfo.ItemNum += Info.ItemNum);
				MySellingItemIcon.SetItem(topIndex, topInfo);
			}
			else
			{
				MySellingItemIcon.AddItem(Info);
			}
			updateAttributeRegistItemForm(Info);
		}
	}
	updateSellRegisterForm();
	return;
}

function MoveItemBottomToTop(int Index, bool bAllItem)
{
	local ItemInfo Info, topInfo;
	local int topIndex;

	if(MySellingItemIcon.GetItem(Index, Info))
	{
		if(((!bAllItem && IsStackableItem(Info.ConsumeType)) && (Info.ItemNum > INT64(1))))
		{
			DisableCurrentWindow(true);
			DialogSetID(200000);
			DialogSetEditBoxMaxLength(6);
			DialogSetReservedItemID(Info.Id);
			DialogSetParamInt64(Info.ItemNum);
			DialogSetDefaultOK();
			DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(3496), Info.Name, ""));
		}
		else
		{
			MySellingItemIcon.DeleteItem(Index);
			topIndex = MySellingPossibItem.FindItem(Info.Id);
			if(((topIndex >= 0) && IsStackableItem(Info.ConsumeType)))
			{
				MySellingPossibItem.GetItem(topIndex, topInfo);
				(topInfo.ItemNum += Info.ItemNum);
				MySellingPossibItem.SetItem(topIndex, topInfo);
			}
			else
			{
				MySellingPossibItem.AddItem(Info);
			}
		}
	}
	updateSellRegisterForm();
	return;
}

function HandleDialogOK()
{
	local int Id, bottomIndex, topIndex;
	local ItemInfo bottomInfo, topInfo;
	local ItemID scID;
	local ItemInfo scInfo;
	local INT64 inputNum;

	if(DialogIsMine())
	{
		Id = DialogGetID();
		inputNum = INT64(DialogGetString());
		scID = DialogGetReservedItemID();
		DialogGetReservedItemInfo(scInfo);
		if(((Id == 200001) && (inputNum > INT64(0))))
		{
			MoveItemBottomToTop(0, true);
			topIndex = MySellingPossibItem.FindItem(scID);
			if((topIndex >= 0))
			{
				MySellingPossibItem.GetItem(topIndex, topInfo);
				bottomIndex = MySellingItemIcon.FindItem(scID);
				MySellingItemIcon.GetItem(bottomIndex, bottomInfo);
				if((MySellingItemIcon.GetItemNum() > 0))
				{
					MoveItemBottomToTop(0, true);
				}
				bottomInfo = topInfo;
				bottomInfo.ItemNum = Min64(inputNum, topInfo.ItemNum);
				bottomInfo.Price = DialogGetReservedInt2();
				MySellingItemIcon.AddItem(bottomInfo);
				(topInfo.ItemNum -= inputNum);
				if((topInfo.ItemNum <= INT64(0)))
				{
					MySellingPossibItem.DeleteItem(topIndex);
				}
				else
				{
					MySellingPossibItem.SetItem(topIndex, topInfo);
				}
			}
			if((beforePeriod >= 0))
			{
				MySellingItemRegistPeriodComboBox.SetSelectedNum(beforePeriod);
			}
			if((beforePrePrice > INT64(0)))
			{
				MySellingItemUnitPriceEdit.SetString(string(beforePrePrice));
			}
			updateSellRegisterForm();
		}
		else if(((Id == 200000) && (inputNum > INT64(0))))
		{
			bottomIndex = MySellingItemIcon.FindItem(scID);
			if((bottomIndex >= 0))
			{
				MySellingItemIcon.GetItem(bottomIndex, bottomInfo);
				topIndex = MySellingPossibItem.FindItem(scID);
				if(((topIndex >= 0) && IsStackableItem(bottomInfo.ConsumeType)))
				{
					MySellingPossibItem.GetItem(topIndex, topInfo);
					(topInfo.ItemNum += Min64(inputNum, bottomInfo.ItemNum));
					MySellingPossibItem.SetItem(topIndex, topInfo);
				}
				else
				{
					topInfo = bottomInfo;
					topInfo.ItemNum = Min64(inputNum, bottomInfo.ItemNum);
					MySellingPossibItem.AddItem(topInfo);
				}
				(bottomInfo.ItemNum -= inputNum);
				if((bottomInfo.ItemNum > INT64(0)))
				{
					MySellingItemIcon.SetItem(bottomIndex, bottomInfo);
				}
				else
				{
					MySellingItemIcon.DeleteItem(bottomIndex);
				}
			}
			updateSellRegisterForm();
		}
		else if((Id == 200005))
		{
			MySellingItemUnitPriceEdit.SetString(string(inputNum));
		}
		else if((Id == 200006))
		{
			callRequestCommissionRegister();
		}
		else if((Id == 200007))
		{
			callRequestCommissionBuyItem();
		}
		else if((Id == 200008))
		{
			callRequestCommissionDelete();
		}
		else if((Id == 200009))
		{
			TabCtrl.SetTopOrder(0, false);
		}
		updateSellRegisterForm();
	}
	DisableCurrentWindow(false);
	return;
}

function HandleDialogCancel()
{
	if(DialogIsMine())
	{
	}
	DisableCurrentWindow(false);
	return;
}

function OnComboBoxItemSelected(string comboName, int Index)
{
	switch(comboName)
	{
		case "Type_Combobox":
			OnSearchBtnClick();
			break;
		case "Grade_Combobox":
			OnSearchBtnClick();
			break;
		case "MySellingItemRegistPeriodComboBox":
			updateSellRegisterForm();
		default:
			break;
	}
	return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
	local LVDataRecord Record;
	local string param;
	local int nSelect;

	nSelect = SellingItemListCtrl.GetSelectedIndex();
	if((nSelect >= 0))
	{
		SellingItemListCtrl.GetSelectedRec(Record);
		param = Record.szReserved;
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "SearchBtn":
			OnSearchBtnClick();
			break;
		case "ResetBtn":
			OnResetBtnClick();
			break;
		case "RefreshBtn":
			OnRefreshBtnClick();
			break;
		case "BuyBtn":
			OnBuyBtnClick();
			break;
		case "SellBtn":
			SellingItemRegistrationWndShow();
			break;
		case "SellCancelBtn":
			OnSellCancelBtnClick();
			break;
		case "MySellingItemUnitPriceEditBtn":
			OnMySellingItemUnitPriceEditBtnClick();
			break;
		case "RegistBtn":
			askDialogRegisterItem();
			break;
		case "CancelBtn":
			callRequestCommissionCancel();
			break;
		case "TabCtrl0":
		case "TabCtrl1":
			updateAdenaText();
			clickTabButton(Name);
			break;
		default:
			break;
	}
	clickTreeState(Name);
	return;
}

function clickTabButton(string TabName)
{
	switch(TabName)
	{
		case "TabCtrl0":
			OnSearchBtnClick();
			break;
		case "TabCtrl1":
			callRequestCommissionCancel();
			SellingItemRegistrationWndShow();
			Class'NWindow.ConsignmentSaleAPI'.static.RequestCommissionRegisteredItem();
			DisableCurrentWindow(false);
			break;
		default:
			break;
	}
	return;
}

function OnSearchBtnClick()
{
	if(((currentTreeNodeSelected != "root.list0") && (disableCurrentWindowFlag == false)))
	{
		if((currentTreeNodeSelected == "root.list1"))
		{
			SellingItemListWnd.ShowWindow();
			HelpHtmlWnd.HideWindow();
			if((SearchWord_Editbox.GetString() == ""))
			{
				SellingItemListCtrl.DeleteAllItem();
				DescriptionMsgWnd.ShowWindow();
				DescriptionMsg.SetText(GetSystemMessage(3444));
				SellingItemNumber.SetText("");
			}
			else
			{
				SellingItemListWnd.ShowWindow();
				SellingItemNumber.SetText("");
				sellListSearch();
			}
		}
		else
		{
			sellListSearch();
		}
	}
	SearchWord_Editbox.SetFocus();
	return;
}

function OnResetBtnClick()
{
	SearchWord_Editbox.SetString("");
	Type_Combobox.SetSelectedNum(0);
	Grade_Combobox.SetSelectedNum(0);
	OnSearchBtnClick();
	return;
}

function OnRefreshBtnClick()
{
	sellListSearch();
	return;
}

function OnBuyBtnClick()
{
	local int nSelect;

	nSelect = SellingItemListCtrl.GetSelectedIndex();
	if((nSelect >= 0))
	{
		callRequestCommissionBuyInfo();
	}
	else
	{
		AddSystemMessage(3443);
	}
	return;
}

function OnSellCancelBtnClick()
{
	local int nSelect;

	nSelect = MySellingItemListCtrl.GetSelectedIndex();
	if((nSelect >= 0))
	{
		askDialogDeleteItem();
	}
	else
	{
		AddSystemMessage(3443);
	}
	return;
}

function OnMySellingItemUnitPriceEditBtnClick()
{
	local ItemInfo Info;

	if((MySellingItemIcon.GetItemNum() > 0))
	{
		MySellingItemIcon.GetItem(0, Info);
		DialogSetID(200005);
		DialogSetReservedItemID(Info.Id);
		DialogSetEditType("number");
		DialogSetParamInt64(INT64(-1));
		DialogSetDefaultOK();
		DialogShow(DialogModalType_Modalless, DialogType_NumberPad, GetSystemMessage(322));
		DisableCurrentWindow(true);
	}
	return;
}

function callRequestCommissionBuyInfo()
{
	local LVDataRecord Record;
	local INT64 CommissionDBId, commissionItemType;
	local string param;
	local int nSelect;

	nSelect = SellingItemListCtrl.GetSelectedIndex();
	if((nSelect >= 0))
	{
		SellingItemListCtrl.GetSelectedRec(Record);
		param = Record.szReserved;
		ParseINT64(param, "CommissionItemType", commissionItemType);
		ParseINT64(param, "CommissionDBId", CommissionDBId);
		Class'NWindow.ConsignmentSaleAPI'.static.RequestCommissionBuyInfo(CommissionDBId, int(commissionItemType));
	}
	return;
}

function callRequestCommissionBuyItem()
{
	local LVDataRecord Record;
	local INT64 commissionItemType, CommissionDBId;
	local string param;
	local int nSelect;

	nSelect = SellingItemListCtrl.GetSelectedIndex();
	if((nSelect >= 0))
	{
		SellingItemListCtrl.GetSelectedRec(Record);
		param = Record.szReserved;
		ParseINT64(param, "CommissionDBId", CommissionDBId);
		ParseINT64(param, "CommissionItemType", commissionItemType);
		Class'NWindow.ConsignmentSaleAPI'.static.RequestCommissionBuyItem(CommissionDBId, int(commissionItemType));
	}
	return;
}

function callRequestCommissionInfo(ItemInfo Info)
{
	Class'NWindow.ConsignmentSaleAPI'.static.RequestCommissionInfo(Info.Id.ServerID);
	return;
}

function callRequestCommissionRegister()
{
	local int sellpremiumitemID;
	local CommissionPremiumItemInfo sellPremiumIteminfo;
	local ItemInfo Info;
	local INT64 PricePerUnit, Amount;
	local int nPeriod;

	if((MySellingItemIcon.GetItemNum() > 0))
	{
		MySellingItemIcon.GetItem(0, Info);
		PricePerUnit = INT64(MySellingItemUnitPriceEdit.GetString());
		Amount = Info.ItemNum;
		nPeriod = MySellingItemRegistPeriodComboBox.GetSelectedNum();
		if((nPeriod > 3))
		{
			sellPremiumIteminfo = sellPremiumitemArray[(nPeriod - 4)];
			sellpremiumitemID = sellPremiumIteminfo.commissionItemId;
		}
		else
		{
			sellpremiumitemID = 0;
		}
		Class'NWindow.ConsignmentSaleAPI'.static.RequestCommissionRegister(Info.Id.ServerID, Info.Name, PricePerUnit, Amount, nPeriod, sellpremiumitemID);
	}
	return;
}

function callRequestCommissionCancel()
{
	if((MySellingItemIcon.GetItemNum() > 0))
	{
		Class'NWindow.ConsignmentSaleAPI'.static.RequestCommissionCancel();
	}
	return;
}

function callRequestCommissionDelete()
{
	local INT64 CommissionDBId;
	local int PeriodType, commissionItemType;
	local LVDataRecord Record;
	local string param;
	local int nSelect;

	nSelect = MySellingItemListCtrl.GetSelectedIndex();
	if((nSelect >= 0))
	{
		MySellingItemListCtrl.GetSelectedRec(Record);
		param = Record.szReserved;
		ParseINT64(param, "CommissionDBId", CommissionDBId);
		ParseInt(param, "CommissionItemType", commissionItemType);
		ParseInt(param, "PeriodType", PeriodType);
		Class'NWindow.ConsignmentSaleAPI'.static.RequestCommissionDelete(CommissionDBId, commissionItemType, PeriodType);
	}
	return;
}

function askDialogBuyItem(string param)
{
	local LVDataRecord Record;
	local INT64 CommissionDBId, commissionItemType, commissionPrice, Amount;
	local int nSelect, ConsumeType;
	local string ItemName;

	nSelect = SellingItemListCtrl.GetSelectedIndex();
	if((nSelect >= 0))
	{
		SellingItemListCtrl.GetSelectedRec(Record);
		ParseString(param, "name", ItemName);
		ParseINT64(param, "CommissionItemType", commissionItemType);
		ParseINT64(param, "CommissionDBId", CommissionDBId);
		ParseINT64(param, "CommissionPrice", commissionPrice);
		ParseInt(param, "ConsumeType", ConsumeType);
		ItemName = Record.LVDataList[0].szData;
		Amount = INT64(Record.LVDataList[2].szData);
		DialogSetID(200007);
		if(IsStackableItem(ConsumeType))
		{
			DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3425), deleteRightSpeceString(ItemName), string(Amount), ConvertNumToText(string(commissionPrice)), ConvertNumToText(string((commissionPrice * Amount)))));
		}
		else
		{
			DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3424), deleteRightSpeceString(ItemName), ConvertNumToText(string(commissionPrice))));
		}
		DisableCurrentWindow(true);
	}
	return;
}

function askDialogRegisterItem()
{
	local ItemInfo Info;
	local INT64 PricePerUnit, Amount;

	if(((MySellingItemIcon.GetItemNum() > 0) && (int(MySellingItemUnitPriceEdit.GetString()) > 0)))
	{
		MySellingItemIcon.GetItem(0, Info);
		PricePerUnit = INT64(MySellingItemUnitPriceEdit.GetString());
		Amount = Info.ItemNum;
		DialogSetID(200006);
		if(IsStackableItem(Info.ConsumeType))
		{
			DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3422), deleteRightSpeceString(Info.Name), string(Amount), ConvertNumToText(string(PricePerUnit)), ConvertNumToText(string((Amount * PricePerUnit))), ConvertNumToText(commissionStr)));
		}
		else
		{
			DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3421), deleteRightSpeceString(getItemNameForSellingAgency(Info)), ConvertNumToText(string(PricePerUnit)), ConvertNumToText(commissionStr)));
		}
		DisableCurrentWindow(true);
	}
	updateSellRegisterForm();
	return;
}

function askDialogDeleteItem()
{
	local LVDataRecord Record;
	local int nSelect, ConsumeType;
	local string param, ItemName;
	local INT64 ItemNum, commissionPrice;
	local int PeriodType;

	nSelect = MySellingItemListCtrl.GetSelectedIndex();
	if((nSelect >= 0))
	{
		MySellingItemListCtrl.GetRec(nSelect, Record);
		param = Record.szReserved;
		ParseInt(param, "ConsumeType", ConsumeType);
		ParseInt(param, "PeriodType", PeriodType);
		ParseINT64(param, "CommissionPrice", commissionPrice);
		ParseINT64(param, "itemNum", ItemNum);
		ItemName = Record.LVDataList[0].szData;
		DialogSetID(200008);
		if(IsStackableItem(ConsumeType))
		{
			DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3429), deleteRightSpeceString(ItemName), string(ItemNum), ConvertNumToText(string(commissionPrice)), ConvertNumToText(string((commissionPrice * ItemNum))), ConvertNumToText(getCommisionNum(ItemNum, commissionPrice, PeriodType))));
		}
		else
		{
			DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3428), deleteRightSpeceString(ItemName), ConvertNumToText(string(commissionPrice)), ConvertNumToText(getCommisionNum(INT64(1), commissionPrice, PeriodType))));
		}
		DisableCurrentWindow(true);
	}
	return;
}

function MySellingItemListCtrlExtend(bool bOpen)
{
	if(bOpen)
	{
		SellBtn.EnableWindow();
		SellCancelBtn.EnableWindow();
		MySellingItemListCtrl.SetWindowSize((MySellingItemListCtrlRect.nWidth + 248), MySellingItemListCtrlRect.nHeight);
		MySellingItemListCtrl.SetColumnWidth(0, ((220 + 200) - 1));
		MySellingItemListCtrl.SetColumnWidth(4, (74 + 47));
		MySellingItemListCtrlDeco.SetWindowSize((522 + 247), 19);
		MySellingItemListGroupbox.SetWindowSize((524 + 247), 459);
		SellingItemListCtrlGroupboxDivider.SetWindowSize(771, 1);
		SellingItemRegistrationWnd.HideWindow();
	}
	else
	{
		SellBtn.DisableWindow();
		SellCancelBtn.DisableWindow();
		MySellingItemListCtrl.SetWindowSize(MySellingItemListCtrlRect.nWidth, MySellingItemListCtrlRect.nHeight);
		MySellingItemListCtrl.SetColumnWidth(0, (220 - 10));
		MySellingItemListCtrl.SetColumnWidth(4, 84);
		MySellingItemListCtrlDeco.SetWindowSize(522, 19);
		MySellingItemListGroupbox.SetWindowSize(524, 459);
		SellingItemListCtrlGroupboxDivider.SetWindowSize(523, 1);
		SellingItemRegistrationWnd.ShowWindow();
	}
	return;
}

function SellingItemRegistrationWndShow()
{
	SellingItemRegistrationWnd.ShowWindow();
	Class'NWindow.ConsignmentSaleAPI'.static.RequestCommissionRegistrableItemList();
	MySellingItemIcon.Clear();
	MySellingItemRegistPeriodComboBox.Clear();
	MySellingItemRegistPeriodComboBox.AddString(MakeFullSystemMsg(GetSystemMessage(3418), "1"));
	MySellingItemRegistPeriodComboBox.AddString(MakeFullSystemMsg(GetSystemMessage(3418), "3"));
	MySellingItemRegistPeriodComboBox.AddString(MakeFullSystemMsg(GetSystemMessage(3418), "5"));
	MySellingItemRegistPeriodComboBox.AddString(MakeFullSystemMsg(GetSystemMessage(3418), "7"));
	MySellingItemRegistPeriodComboBox.SetSelectedNum(3);
	Class'NWindow.ConsignmentSaleAPI'.static.RequestCommissionSellingPremiumItemList();
	initRegistItemForm();
	return;
}

function SellingPremiumItemRegisterReset(string param)
{
	sellPremiumitemArray.Length = 0;
	return;
}

function SellingPremiumItemRegisterAdd(string param)
{
	local CommissionPremiumItemInfo Info;

	ParseInt(param, "ID", Info.commissionItemId);
	ParseString(param, "Name", Info.commissionItemName);
	ParseInt(param, "Period", Info.commissionPeriod);
	ParseInt(param, "Expired", Info.commissionExpired);
	ParseInt(param, "Discount", Info.commissionDiscountInfo);
	ParseInt(param, "DiscountType", Info.commissionDiscountInfoType);
	sellPremiumitemArray.Length = (sellPremiumitemArray.Length + 1);
	sellPremiumitemArray[(sellPremiumitemArray.Length - 1)] = Info;
	MySellingItemRegistPeriodComboBox.AddString(Info.commissionItemName);
	return;
}

function MySellingItemRegistPeriodComboBoxSelectNum(int Period, int DiscountType)
{
	local int i, check;

	Debug(("SelectNum: Period" @ string(Period)));
	Debug(("SelectNum: DiscountType" @ string(DiscountType)));
	check = 0;
	if(((Period >= 3) && (DiscountType >= 0)))
	{
		i = 0;
		while((i < sellPremiumitemArray.Length))
		{
			if(((sellPremiumitemArray[i].commissionPeriod == Period) && (sellPremiumitemArray[i].commissionDiscountInfoType == DiscountType)))
			{
				Debug("SelectNum: OK");
				MySellingItemRegistPeriodComboBox.SetSelectedNum((4 + i));
				check = 1;
				break;
			}
			i++;
		}
		if((check == 0))
		{
			Debug("SelectNum: FALE");
			MySellingItemRegistPeriodComboBox.SetSelectedNum(3);
		}
	}
	else
	{
		Debug("SelectNum: FALE");
		MySellingItemRegistPeriodComboBox.SetSelectedNum(Period);
	}
	return;
}

function clickTreeState(string Name)
{
	local array<string> nodeArray;
	local string tempStr;

	if((Left(Name, 4) == "root"))
	{
		tempStr = Right(Name, 13);
		tempStr = Left(tempStr, 12);
		currentTreeNodeSelected = Name;
		Split(Name, ".", nodeArray);
		if((SortListTree.GetExpandedNode(Name) != ""))
		{
			beforeTreeNodeSelectedFlag = false;
		}
		if((beforeTreeNodeSelected == Name))
		{
			beforeTreeNodeSelectedFlag = !beforeTreeNodeSelectedFlag;
		}
		else if((SortListTree.GetExpandedNode(Name) != ""))
		{
			beforeTreeNodeSelectedFlag = false;
		}
		else
		{
			beforeTreeNodeSelectedFlag = true;
		}
		setTreeNode(beforeTreeNodeSelected, false);
		beforeTreeNodeSelected = Name;
		setTreeNode(Name, true);
		if(disableCurrentWindowFlag)
		{
			saveTreePath = Name;
			return;
		}
		else
		{
			saveTreePath = "";
		}
		if((Name == "root.list0"))
		{
			openHtmlHelp();
			SellingItemListWnd.HideWindow();
			DescriptionMsgWnd.HideWindow();
			DescriptionMsg.SetText("");
			SellingItemNumber.SetText("");
		}
		else if((Name == "root.list1"))
		{
			HelpHtmlWnd.HideWindow();
			SellingItemListWnd.ShowWindow();
			if((SearchWord_Editbox.GetString() == ""))
			{
				SellingItemListCtrl.DeleteAllItem();
				DescriptionMsgWnd.ShowWindow();
				DescriptionMsg.SetText(GetSystemMessage(3444));
				SellingItemNumber.SetText("");
			}
			else
			{
				SellingItemListWnd.ShowWindow();
				SellingItemNumber.SetText("");
				sellListSearch();
			}
			if(Me.IsShowWindow())
			{
				SearchWord_Editbox.SetFocus();
			}
		}
		else
		{
			HelpHtmlWnd.HideWindow();
			SellingItemListWnd.ShowWindow();
			sellListSearch();
			SearchWord_Editbox.SetFocus();
		}
	}
	return;
}

function sellListSearch()
{
	local array<string> nodeArray;
	local string Name, SearchString, tempStr;
	local int depth, DepthType, NameClass, Grade;

	tempStr = Right(currentTreeNodeSelected, 13);
	tempStr = Left(tempStr, 12);
	SellingItemListCtrl.DeleteAllItem();
	DescriptionMsgWnd.ShowWindow();
	DescriptionMsg.SetText(GetSystemMessage(3107));
	Name = currentTreeNodeSelected;
	if(((Left(Name, 4) == "root") && ("root.list0" != Name)))
	{
		Split(Name, ".", nodeArray);
		depth = (nodeArray.Length - 2);
		DepthType = 0;
		if((depth <= 0))
		{
			DepthType = 0;
		}
		else if((depth == 1))
		{
			DepthType = int(Right(Name, 1));
		}
		else if((depth == 2))
		{
			DepthType = getDepthTypeNum(int(Right(nodeArray[2], 1)), int(Mid(nodeArray[3], 4)));
		}
		NameClass = GetItemType();
		Grade = getSerachGrade();
		SearchString = SearchWord_Editbox.GetString();
		Class'NWindow.ConsignmentSaleAPI'.static.RequestCommissionList(depth, DepthType, NameClass, Grade, SearchString);
		beforeTreeNodeCalled = currentTreeNodeSelected;
		if((tempStr == "categoryType"))
		{
			startCategoryTreeSearchDelay();
		}
		else
		{
			startSearchDelay();
		}
	}
	return;
}

function int getDepthTypeNum(int DepthType, int TargetIndex)
{
	local int nReturn;

	nReturn = -1;
	switch(DepthType)
	{
		case 0:
			nReturn = (1 + TargetIndex);
			break;
		case 1:
			nReturn = (19 + TargetIndex);
			break;
		case 2:
			nReturn = (29 + TargetIndex);
			break;
		case 3:
			nReturn = (35 + TargetIndex);
			break;
		case 4:
			nReturn = (42 + TargetIndex);
			break;
		case 5:
			nReturn = (44 + TargetIndex);
			break;
		default:
			break;
	}
	if((DepthType == 2))
	{
		if((nReturn == 34))
		{
			return 62;
		}
		else if((nReturn == 35))
		{
			return 34;
		}
		else if((nReturn == 36))
		{
			return 63;
		}
		else if((nReturn == 37))
		{
			return 64;
		}
	}
	return nReturn;
}

function int getSerachGrade()
{
	local int gradeindex;

	gradeindex = (Grade_Combobox.GetSelectedNum() - 1);
	if((gradeindex < 7))
	{
		return gradeindex;
	}
	return (gradeindex + 1);
}

function int GetItemType()
{
	return (Type_Combobox.GetSelectedNum() - 1);
}

function setTreeNode(string nodeStr, bool bOpen)
{
	local array<string> nodeArray;
	local string targetNodeStr;
	local int i;

	Split(nodeStr, ".", nodeArray);
	targetNodeStr = "";
	i = 0;
	while((i < nodeArray.Length))
	{
		targetNodeStr = (targetNodeStr $ nodeArray[i]);
		if((bOpen == false))
		{
			SortListTree.SetExpandedNode(targetNodeStr, false);
		}
		else if((i == (nodeArray.Length - 1)))
		{
			switch(Left(nodeArray[i], 4))
			{
				case "list":
				case "cate":
					SortListTree.SetExpandedNode(targetNodeStr, beforeTreeNodeSelectedFlag);
					break;
				default:
					SortListTree.SetExpandedNode(targetNodeStr, true);
			}
		}
		else
		{
			SortListTree.SetExpandedNode(targetNodeStr, true);
		}
		targetNodeStr = (targetNodeStr $ ".");
		i++;
	}
	return;
}

function addElementAtList(string param)
{
	local ItemInfo Info;
	local ListCtrlHandle targetList;
	local LVDataRecord Record;
	local int k, itemAttributeCount;
	local string ItemName, IconName, IconPanel, AdditionalName, LookChangeiconPanelName;
	local INT64 commissionPrice, CommissionDBId, commissionItemType;
	local int expireTime, PeriodType, ItemNum, ItemType, CrystalType, Enchanted, ConsumeType, EtcItemType, AttackAttributeType, AttackAttributeValue, DefenseAttributeValueFire, DefenseAttributeValueWater, DefenseAttributeValueWind, DefenseAttributeValueEarth, DefenseAttributeValueHoly, DefenseAttributeValueUnholy;
	local Color TextColor;

	itemAttributeCount = 0;
	if((listCommissionStatus == 2))
	{
		targetList = MySellingItemListCtrl;
	}
	else
	{
		targetList = SellingItemListCtrl;
	}
	ParseString(param, "iconName", IconName);
	ParseString(param, "name", ItemName);
	ParseString(param, "iconPanel", IconPanel);
	ParseString(param, "LookChangeIconPanel", LookChangeiconPanelName);
	ParseString(param, "additionalName", AdditionalName);
	ParseINT64(param, "CommissionPrice", commissionPrice);
	ParseINT64(param, "CommissionDBId", CommissionDBId);
	ParseINT64(param, "CommissionItemType", commissionItemType);
	ParseInt(param, "ExpireTime", expireTime);
	ParseInt(param, "PeriodType", PeriodType);
	ParseInt(param, "itemNum", ItemNum);
	ParseInt(param, "itemType", ItemType);
	ParseInt(param, "EtcItemType", EtcItemType);
	ParseInt(param, "crystalType", CrystalType);
	ParseInt(param, "enchanted", Enchanted);
	ParseInt(param, "consumeType", ConsumeType);
	ParseInt(param, "AttackAttributeType", AttackAttributeType);
	ParseInt(param, "AttackAttributeValue", AttackAttributeValue);
	ParseInt(param, "DefenseAttributeValueFire", DefenseAttributeValueFire);
	ParseInt(param, "DefenseAttributeValueWater", DefenseAttributeValueWater);
	ParseInt(param, "DefenseAttributeValueWind", DefenseAttributeValueWind);
	ParseInt(param, "DefenseAttributeValueEarth", DefenseAttributeValueEarth);
	ParseInt(param, "DefenseAttributeValueHoly", DefenseAttributeValueHoly);
	ParseInt(param, "DefenseAttributeValueUnholy", DefenseAttributeValueUnholy);
	Record.szReserved = param;
	Record.LVDataList.Length = 7;
	Info.Name = ItemName;
	Info.AdditionalName = AdditionalName;
	Info.Enchanted = Enchanted;
	Info.EtcItemType = EtcItemType;
	addEnsoulInfoToItemInfoByParamString(param, Info);
	Record.LVDataList[0].szData = getItemNameForSellingAgency(Info);
	Record.LVDataList[0].hasIcon = true;
	Record.LVDataList[0].nTextureWidth = 32;
	Record.LVDataList[0].nTextureHeight = 32;
	Record.LVDataList[0].nTextureU = 32;
	Record.LVDataList[0].nTextureV = 32;
	Record.LVDataList[0].szTexture = IconName;
	Record.LVDataList[0].IconPosX = 10;
	Record.LVDataList[0].FirstLineOffsetX = 6;
	Record.LVDataList[0].HiddenStringForSorting = (ItemName $ util.makeZeroString(3, INT64(Enchanted)));
	Record.LVDataList[0].iconBackTexName = "l2ui_ct1.ItemWindow_DF_SlotBox_Default";
	Record.LVDataList[0].backTexOffsetXFromIconPosX = -2;
	Record.LVDataList[0].backTexOffsetYFromIconPosY = -1;
	Record.LVDataList[0].backTexWidth = 36;
	Record.LVDataList[0].backTexHeight = 36;
	Record.LVDataList[0].backTexUL = 36;
	Record.LVDataList[0].backTexVL = 36;
	Record.LVDataList[0].iconPanelName = IconPanel;
	Record.LVDataList[0].LookChangeiconPanelName = LookChangeiconPanelName;
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
	Record.LVDataList[0].AttrIconTexArray.Length = 4;
	Record.LVDataList[0].AttrColor.R = 200;
	Record.LVDataList[0].AttrColor.G = 200;
	Record.LVDataList[0].AttrColor.B = 200;
	k = 0;
	while((k < 4))
	{
		Record.LVDataList[0].AttrIconTexArray[k].X = 0;
		Record.LVDataList[0].AttrIconTexArray[k].Y = 2;
		Record.LVDataList[0].AttrIconTexArray[k].Width = 14;
		Record.LVDataList[0].AttrIconTexArray[k].Height = 14;
		Record.LVDataList[0].AttrIconTexArray[k].U = 0;
		Record.LVDataList[0].AttrIconTexArray[k].V = 0;
		Record.LVDataList[0].AttrIconTexArray[k].UL = 14;
		Record.LVDataList[0].AttrIconTexArray[k].VL = 14;
		++k;
	}
	Record.LVDataList[0].AttrIconTexArray[0].objTex = GetTexture("L2UI_CT1.EmptyBtn");
	Record.LVDataList[0].AttrStat[3] = "";
	if((AttackAttributeType >= 0))
	{
		Record.LVDataList[0].AttrIconTexArray[0].objTex = GetTexture(attributeTypeToTextureString(AttackAttributeType, ItemType));
		Record.LVDataList[0].AttrStat[0] = string(AttackAttributeValue);
		itemAttributeCount++;
	}
	else if(((((((DefenseAttributeValueUnholy + DefenseAttributeValueHoly) + DefenseAttributeValueEarth) + DefenseAttributeValueWind) + DefenseAttributeValueWater) + DefenseAttributeValueFire) > 0))
	{
		if(((DefenseAttributeValueWater > 0) && (itemAttributeCount < 3)))
		{
			Record.LVDataList[0].AttrIconTexArray[itemAttributeCount].objTex = GetTexture(attributeTypeToTextureString(1, ItemType));
			Record.LVDataList[0].AttrStat[itemAttributeCount] = string(DefenseAttributeValueWater);
			itemAttributeCount++;
		}
		if(((DefenseAttributeValueFire > 0) && (itemAttributeCount < 3)))
		{
			Record.LVDataList[0].AttrIconTexArray[itemAttributeCount].objTex = GetTexture(attributeTypeToTextureString(0, ItemType));
			Record.LVDataList[0].AttrStat[itemAttributeCount] = string(DefenseAttributeValueFire);
			itemAttributeCount++;
		}
		if(((DefenseAttributeValueWind > 0) && (itemAttributeCount < 3)))
		{
			Record.LVDataList[0].AttrIconTexArray[itemAttributeCount].objTex = GetTexture(attributeTypeToTextureString(2, ItemType));
			Record.LVDataList[0].AttrStat[itemAttributeCount] = string(DefenseAttributeValueWind);
			itemAttributeCount++;
		}
		if(((DefenseAttributeValueEarth > 0) && (itemAttributeCount < 3)))
		{
			Record.LVDataList[0].AttrIconTexArray[itemAttributeCount].objTex = GetTexture(attributeTypeToTextureString(3, ItemType));
			Record.LVDataList[0].AttrStat[itemAttributeCount] = string(DefenseAttributeValueEarth);
			itemAttributeCount++;
		}
		if(((DefenseAttributeValueHoly > 0) && (itemAttributeCount < 3)))
		{
			Record.LVDataList[0].AttrIconTexArray[itemAttributeCount].objTex = GetTexture(attributeTypeToTextureString(4, ItemType));
			Record.LVDataList[0].AttrStat[itemAttributeCount] = string(DefenseAttributeValueHoly);
			itemAttributeCount++;
		}
		if(((DefenseAttributeValueUnholy > 0) && (itemAttributeCount < 3)))
		{
			Record.LVDataList[0].AttrIconTexArray[itemAttributeCount].objTex = GetTexture(attributeTypeToTextureString(5, ItemType));
			Record.LVDataList[0].AttrStat[itemAttributeCount] = string(DefenseAttributeValueUnholy);
			itemAttributeCount++;
		}
		itemAttributeCount = 0;
		if((DefenseAttributeValueWater > 0))
		{
			itemAttributeCount++;
		}
		if((DefenseAttributeValueFire > 0))
		{
			itemAttributeCount++;
		}
		if((DefenseAttributeValueWind > 0))
		{
			itemAttributeCount++;
		}
		if((DefenseAttributeValueEarth > 0))
		{
			itemAttributeCount++;
		}
		if((DefenseAttributeValueHoly > 0))
		{
			itemAttributeCount++;
		}
		if((DefenseAttributeValueUnholy > 0))
		{
			itemAttributeCount++;
		}
		if((itemAttributeCount > 3))
		{
			Record.LVDataList[0].AttrIconTexArray[3].objTex = GetTexture("l2ui_ct1.SellingAgencyWnd_df_ItemPropertyIcon_add");
			Record.LVDataList[0].AttrStat[3] = GetSystemString(2672);
		}
	}
	if((itemAttributeCount > 0))
	{
		Record.LVDataList[0].AttrIconTexArray[0].X = 0;
		Record.LVDataList[0].AttrIconTexArray[1].X = 30;
		Record.LVDataList[0].AttrIconTexArray[2].X = 30;
		Record.LVDataList[0].AttrIconTexArray[3].X = 30;
	}
	if((((ItemType == 0) || (ItemType == 2)) || (ItemType == 1)))
	{
		Record.LVDataList[1].szData = util.getItemGradeSystemString(CrystalType);
	}
	else if((CrystalType != 0))
	{
		Record.LVDataList[1].szData = util.getItemGradeSystemString(CrystalType);
	}
	else
	{
		Record.LVDataList[1].szData = "-";
	}
	Record.LVDataList[1].HiddenStringForSorting = util.makeZeroString(6, INT64(CrystalType));
	Record.LVDataList[1].textAlignment = TA_Center;
	Record.LVDataList[2].szData = string(ItemNum);
	Record.LVDataList[2].HiddenStringForSorting = util.makeZeroString(6, INT64(ItemNum));
	Record.LVDataList[2].textAlignment = TA_Center;
	Record.LVDataList[3].bUseTextColor = true;
	TextColor = GetNumericColor(MakeCostString(string(commissionPrice)));
	Record.LVDataList[3].TextColor = TextColor;
	Record.LVDataList[3].szData = ConvertNumToTextNoAdena(string(commissionPrice));
	Record.LVDataList[3].HiddenStringForSorting = util.makeZeroString(20, commissionPrice);
	if(IsStackableItem(ConsumeType))
	{
		Record.LVDataList[3].hasIcon = true;
		Record.LVDataList[3].AttrColor.R = 200;
		Record.LVDataList[3].AttrColor.G = 200;
		Record.LVDataList[3].AttrColor.B = 200;
		Record.LVDataList[3].AttrStat[0] = MakeFullSystemMsg(GetSystemMessage(3657), ConvertNumToTextNoAdena(string((commissionPrice * INT64(ItemNum)))));
	}
	Record.LVDataList[3].textAlignment = TA_Right;
	Record.LVDataList[4].szData = ConvertTimeToString(float(expireTime));
	Record.LVDataList[4].textAlignment = TA_Right;
	Record.LVDataList[4].HiddenStringForSorting = util.makeZeroString(20, INT64(expireTime));
	targetList.InsertRecord(Record);
	if((listCommissionStatus == 2))
	{
		MySellingItemNumber.SetText((((("(" $ string(MySellingItemListCtrl.GetRecordCount())) $ "/") $ string(maxSellingItemNum)) $ ")"));
	}
	else
	{
		SellingItemNumber.SetText((("(" $ string(SellingItemListCtrl.GetRecordCount())) $ ")"));
	}
	updateRecordItemCount();
	return;
}

function categoryTreeInit()
{
	local string treeName, ROOTNAME;
	local int maxtitle, titleCount, categoryTypeCount, itemTypeCount;
	local string listName, ItemName;
	local CustomTooltip t;
	local bool bDrawBgTree1;

	treeParam = "";
	beforeTreeNodeSelected = "";
	beforeTreeNodeSelectedFlag = false;
	bDrawBgTree1 = false;
	util.setSystemStringArrayByNumStr("145,144", titleNameArray);
	util.setSystemStringArrayByNumStr("2520,2532,2537,5006,2547,49", categoryTypeNameArray);
	util.setSystemStringArrayByNumStr("2521,2522,45,1648,2523,1650,2524,1970,2525,2526,2527,2528,2529,48,1649,2530,46,2531", item1Array);
	util.setSystemStringArrayByNumStr("2533,2534,2535,2536,37,40,231,1987,28,234", item2Array);
	util.setSystemStringArrayByNumStr("239,237,238,2538,2539,3638,1024,3187,3877", item3Array);
	util.setSystemStringArrayByNumStr("2540,2541,2542,2543,2544,2545,2546", item4Array);
	util.setSystemStringArrayByNumStr("2548,2549", item5Array);
	util.setSystemStringArrayByNumStr("2550,2551,2552,2553,2554,2555,2556,2557,2558,2559,2560,2561,2562,2563,25,2564", item6Array);
	treeName = "SellingAgencyWnd.SellingListWnd.SortListTree";
	ROOTNAME = "root";
	SortListTree.Clear();
	maxtitle = 5;
	ParamAdd(treeParam, (("tree" $ "_") $ "length"), string(titleNameArray.Length));
	util.TreeInsertRootNode(treeName, ROOTNAME, "", 0, 4);
	titleCount = 0;
	while((titleCount < titleNameArray.Length))
	{
		listName = ("list" $ string(titleCount));
		if((titleCount == 0))
		{
			util.TreeInsertExpandBtnNode(treeName, listName, ROOTNAME, 14, 14, "L2UI_CT1.SellingAgencyWnd_df_HelpBtn", "L2UI_CT1.SellingAgencyWnd_df_HelpBtn_Over", "L2UI_CT1.SellingAgencyWnd_df_HelpBtn", "L2UI_CT1.SellingAgencyWnd_df_HelpBtn_Over", 0, -2);
			currentTreeNodeSelected = ((ROOTNAME $ ".") $ listName);
		}
		else
		{
			util.TreeInsertExpandBtnNode(treeName, listName, ROOTNAME);
		}
		listName = ((ROOTNAME $ ".") $ listName);
		ParamAdd(treeParam, ("tree" $ string(titleCount)), listName);
		util.TreeInsertTextNodeItem(treeName, listName, titleNameArray[titleCount], 5, 0, COLOR_DEFAULT, true);
		if((titleCount == 1))
		{
			ParamAdd(treeParam, ((("tree" $ string(titleCount)) $ "_") $ "length"), string(categoryTypeNameArray.Length));
			categoryTypeCount = 0;
			while((categoryTypeCount < categoryTypeNameArray.Length))
			{
				util.TreeInsertExpandBtnNode(treeName, ("categoryType" $ string(categoryTypeCount)), (((ROOTNAME $ ".") $ "list") $ string(titleCount)), , , , , , , 15);
				listName = ((((((ROOTNAME $ ".") $ "list") $ string(titleCount)) $ ".") $ "categoryType") $ string(categoryTypeCount));
				ParamAdd(treeParam, ((("tree" $ string(titleCount)) $ "_") $ string(categoryTypeCount)), listName);
				ParamAdd(treeParam, ((((("tree" $ string(titleCount)) $ "_") $ string(categoryTypeCount)) $ "_") $ "length"), string(getSystemStringArray(categoryTypeCount).Length));
				util.TreeInsertTextNodeItem(treeName, listName, categoryTypeNameArray[categoryTypeCount], 5, 0, COLOR_DEFAULT, true);
				itemTypeCount = 0;
				while((itemTypeCount < getSystemStringArray(categoryTypeCount).Length))
				{
					ItemName = TreeInsertItemTooltipNodeWithTexBackHighlight(treeName, ("item" $ string(itemTypeCount)), listName, 10, 0, 15, 0, 1, 15, t);
					ParamAdd(treeParam, ((((("tree" $ string(titleCount)) $ "_") $ string(categoryTypeCount)) $ "_") $ string(itemTypeCount)), ItemName);
					if(bDrawBgTree1)
					{
						util.TreeInsertTextureNodeItem(treeName, ItemName, "L2UI_CH3.etc.textbackline", 160, 15, 10, , , );
					}
					else
					{
						util.TreeInsertTextureNodeItem(treeName, ItemName, "L2UI_CT1.EmptyBtn", 161, 15, 10);
					}
					bDrawBgTree1 = !bDrawBgTree1;
					util.TreeInsertTextNodeItem(treeName, ItemName, getSystemStringArray(categoryTypeCount)[itemTypeCount], -159, 0, COLOR_DEFAULT, true);
					itemTypeCount++;
				}
				categoryTypeCount++;
			}
		}
		titleCount++;
	}
	return;
}

function string TreeInsertItemTooltipNodeWithTexBackHighlight(string treeName, string NodeName, string parentname, int nTexExpandedOffSetX, int nTexExpandedOffSetY, int nTexExpandedHeight, int nTexExpandedRightWidth, int nTexExpandedLeftUWidth, int nTexExpandedLeftUHeight, CustomTooltip tooltipText, optional string strTexExpandedLeft, optional int OffsetX, optional int OffsetY)
{
	local XMLTreeNodeInfo infNode;

	if((strTexExpandedLeft == ""))
	{
		strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";
	}
	infNode.strName = NodeName;
	infNode.ToolTip = tooltipText;
	infNode.nOffSetX = OffsetX;
	infNode.nOffSetY = OffsetY;
	infNode.bFollowCursor = true;
	infNode.nTexExpandedOffSetX = nTexExpandedOffSetX;
	infNode.nTexExpandedOffSetY = nTexExpandedOffSetY;
	infNode.nTexExpandedHeight = nTexExpandedHeight;
	infNode.nTexExpandedRightWidth = nTexExpandedRightWidth;
	infNode.nTexExpandedLeftUWidth = nTexExpandedLeftUWidth;
	infNode.nTexExpandedLeftUHeight = nTexExpandedLeftUHeight;
	infNode.strTexExpandedLeft = strTexExpandedLeft;
	infNode.bDrawBackground = 1;
	infNode.bTexBackHighlight = 0;
	infNode.nTexBackHighlightHeight = 14;
	infNode.nTexBackWidth = 160;
	infNode.nTexBackUWidth = 160;
	infNode.nTexBackOffSetX = 10;
	infNode.nTexBackOffSetY = -1;
	infNode.nTexBackOffSetBottom = 1;
	return Class'NWindow.UIAPI_TREECTRL'.static.InsertNode(treeName, parentname, infNode);
}

function updateRecordItemCount()
{
	if((MySellingItemListCtrl.GetRecordCount() >= maxSellingItemNum))
	{
		MySellingPossibItem.DisableWindow();
	}
	else
	{
		MySellingPossibItem.EnableWindow();
	}
	return;
}

function allCloseTreeNode()
{
	local int i, M, N, array1Count, array2Count, array3Count, max1, max2, max3;
	local string Target;
	local array<string> node1Array, node2Array, node3Array;

	array1Count = 0;
	array2Count = 0;
	array3Count = 0;
	ParseInt(treeParam, "tree_length", max1);
	i = 0;
	while((i < max1))
	{
		ParseInt(treeParam, (("tree" $ string(i)) $ "_length"), max2);
		ParseString(treeParam, ("tree" $ string(i)), Target);
		node1Array[array1Count] = Target;
		array1Count++;
		M = 0;
		while((M < max2))
		{
			ParseInt(treeParam, ((((("tree" $ string(i)) $ "_") $ string(M)) $ "_") $ "length"), max3);
			ParseString(treeParam, ((("tree" $ string(i)) $ "_") $ string(M)), Target);
			node2Array[array2Count] = Target;
			array2Count++;
			N = 0;
			while((N < max3))
			{
				ParseString(treeParam, ((((("tree" $ string(i)) $ "_") $ string(M)) $ "_") $ string(N)), Target);
				node3Array[array3Count] = Target;
				array3Count++;
				N++;
			}
			M++;
		}
		i++;
	}
	i = 0;
	while((i < node3Array.Length))
	{
		SortListTree.SetExpandedNode(node3Array[i], false);
		i++;
	}
	i = 0;
	while((i < node2Array.Length))
	{
		SortListTree.SetExpandedNode(node2Array[i], false);
		i++;
	}
	i = 0;
	while((i < node1Array.Length))
	{
		SortListTree.SetExpandedNode(node1Array[i], false);
		i++;
	}
	return;
}

function openHtmlHelp()
{
	if(!HelpHtmlWnd.IsShowWindow())
	{
		HelpHtmlWnd.ShowWindow();
		HtmlViewer.LoadHtml((GetLocalizedL2TextPathNameUC() $ "help_consignment.htm"));
	}
	return;
}

function array<string> getSystemStringArray(int Type)
{
	local array<string> tempArray;

	switch(Type)
	{
		case 0:
			return item1Array;
			break;
		case 1:
			return item2Array;
			break;
		case 2:
			return item3Array;
			break;
		case 3:
			return item4Array;
			break;
		case 4:
			return item5Array;
			break;
		case 5:
			return item6Array;
			break;
		default:
			Debug(("Error SellingAgencyWnd : 트리 메뉴 구성 정보가 잘못 되었습니다. type: " @ string(Type)));  // EN: Error SellingAgencyWnd : the tree menu configuration is wrong. type:
			return tempArray;
	}
}

function bool compareNode(string node1, string node2, int indexDepth)
{
	local bool bReturn;
	local array<string> node1Array, node2Array;

	bReturn = false;
	Split(node1, ".", node1Array);
	Split(node2, ".", node2Array);
	if((isArrayStringCheckIndexOver(node1Array, indexDepth) && isArrayStringCheckIndexOver(node2Array, indexDepth)))
	{
		if((node1Array[indexDepth] == node2Array[indexDepth]))
		{
			bReturn = true;
		}
	}
	return bReturn;
}

function bool isArrayStringCheckIndexOver(out array<string> tempArray, int Index)
{
	if((tempArray.Length <= Index))
	{
		return false;
	}
	else
	{
		return true;
	}
}

function initRegistItemForm()
{
	if((MySellingItemIcon.GetItemNum() <= 0))
	{
		MySellingItemUnitPriceEdit.DisableWindow();
		MySellingItemUnitPriceEditBtn.DisableWindow();
		MySellingItemAmount.SetText("");
	}
	MySellingItemName.SetName("", NCT_Normal, TA_Left);
	getAttributeTextureHandle(1).SetTexture("L2UI_CT1.EmptyBtn");
	getAttributeTextureHandle(2).SetTexture("L2UI_CT1.EmptyBtn");
	getAttributeTextureHandle(3).SetTexture("L2UI_CT1.EmptyBtn");
	getAttributeTextureHandle(4).HideWindow();
	MySellingItemPropertyValue_01.SetText("");
	MySellingItemPropertyValue_02.SetText("");
	MySellingItemPropertyValue_03.SetText("");
	MySellingItemPropertyValue_04.HideWindow();
	MySellingItemUnitPriceEdit.SetString("");
	MySellingItemUnitPrice_ReadingText.SetText("");
	MySellingItemTotalPrice_ReadingText.SetText("");
	MySellingItemTotalPrice.SetText("");
	MySellingItemRegistPeriodComboBox.SetSelectedNum(3);
	MySellingItemRegistPeriodComboBox.DisableWindow();
	MySellingItemCharge.SetText("");
	MySellingItemSellCharge.SetText("");
	MySellingItemCharge.SetTooltipCustomType(commissionRateToolTip("", GetSystemString(2514), GetSystemString(2777)));
	MySellingItemSellCharge.SetTooltipCustomType(commissionRateToolTip("", GetSystemString(2776), GetSystemString(2778)));
	RegistBtn.DisableWindow();
	return;
}

function updateSellRegisterForm()
{
	local ItemInfo Info;
	local INT64 Commission, commissionSellComplete;
	local string TextValue;
	local Color tColor;

	tColor.R = 200;
	tColor.G = 200;
	tColor.B = 200;
	tColor.A = 255;
	if((MySellingItemIcon.GetItemNum() > 0))
	{
		MySellingItemUnitPriceEdit.EnableWindow();
		MySellingItemUnitPriceEditBtn.EnableWindow();
		MySellingItemRegistPeriodComboBox.EnableWindow();
		MySellingItemIcon.GetItem(0, Info);
		TextValue = MySellingItemUnitPriceEdit.GetString();
		if((TextValue == ""))
		{
			TextValue = "0";
		}
		if((INT64(TextValue) > INT64(0)))
		{
			RegistBtn.EnableWindow();
		}
		else
		{
			RegistBtn.DisableWindow();
		}
		MySellingItemUnitPrice_ReadingText.SetText(ConvertNumToTextNoAdena(TextValue));
		MySellingItemTotalPrice.SetText(MakeCostString(string((Info.ItemNum * INT64(TextValue)))));
		MySellingItemTotalPrice_ReadingText.SetText(ConvertNumToTextNoAdena(string((Info.ItemNum * INT64(TextValue)))));
		Commission = ((Info.ItemNum * INT64(TextValue)) * INT64(getComboPeriod(MySellingItemRegistPeriodComboBox.GetSelectedNum())));
		Commission = ((Commission * INT64(1)) / INT64(10000));
		commissionStr = string(Commission);
		commissionSellComplete = ((Info.ItemNum * INT64(TextValue)) * INT64(getComboPeriod(MySellingItemRegistPeriodComboBox.GetSelectedNum())));
		commissionSellComplete = ((commissionSellComplete * INT64(5)) / INT64(1000));
		commissionSellCompleteStr = string(commissionSellComplete);
		if((Commission < INT64(10000)))
		{
			Commission = INT64(1000);
			commissionStr = string(Commission);
		}
		if((commissionSellComplete < INT64(10000)))
		{
			commissionSellComplete = INT64(1000);
			commissionSellCompleteStr = string(commissionSellComplete);
		}
		MySellingItemCharge.SetText(MakeCostString(commissionStr));
		MySellingItemCharge.SetTooltipCustomType(commissionRateToolTip(((ConvertNumToTextNoAdena(commissionStr) $ " ") $ GetSystemString(469)), GetSystemString(2514), GetSystemString(2777)));
		MySellingItemSellCharge.SetText(MakeCostString(commissionSellCompleteStr));
		MySellingItemSellCharge.SetTooltipCustomType(commissionRateToolTip(((ConvertNumToTextNoAdena(commissionSellCompleteStr) $ " ") $ GetSystemString(469)), GetSystemString(2776), GetSystemString(2778)));
		MySellingItemName.SetNameWithColor(getItemNameForSellingAgency(Info), NCT_Normal, TA_Left, tColor);
		MySellingItemAmount.SetText(string(Info.ItemNum));
	}
	else
	{
		MySellingItemIcon.Clear();
		initRegistItemForm();
	}
	return;
}

function CustomTooltip commissionRateToolTip(string adenaStr, string Title, string Desc)
{
	local CustomTooltip t;

	util.setCustomTooltip(t);
	util.ToopTipMinWidth(300);
	util.ToopTipInsertText(((Title $ " : ") $ adenaStr), true, false, COLOR_DEFAULT);
	util.TooltipInsertItemBlank(2);
	util.TooltipInsertItemLine();
	util.TooltipInsertItemBlank(4);
	util.ToopTipInsertText(Desc, false, false);
	return util.getCustomToolTip();
}

function updateAttributeRegistItemForm(ItemInfo Info)
{
	local int itemAttributeCount, ItemType;
	local Color tColor;

	tColor.R = 200;
	tColor.G = 200;
	tColor.B = 200;
	tColor.A = 255;
	ItemType = Info.ItemType;
	if((MySellingItemIcon.GetItemNum() > 0))
	{
		MySellingItemIcon.GetItem(0, Info);
		MySellingItemName.SetNameWithColor(getItemNameForSellingAgency(Info), NCT_Normal, TA_Left, tColor);
	}
	else
	{
		MySellingItemName.SetNameWithColor("", NCT_Normal, TA_Left, tColor);
	}
	itemAttributeCount = 0;
	getAttributeTextureHandle(1).SetTexture("L2UI_CT1.EmptyBtn");
	getAttributeTextureHandle(2).SetTexture("L2UI_CT1.EmptyBtn");
	getAttributeTextureHandle(3).SetTexture("L2UI_CT1.EmptyBtn");
	MySellingItemPropertyValue_01.SetText("");
	MySellingItemPropertyValue_02.SetText("");
	MySellingItemPropertyValue_03.SetText("");
	if((Info.AttackAttributeType >= 0))
	{
		getAttributeTextureHandle(1).SetTexture(attributeTypeToTextureString(Info.AttackAttributeType, ItemType));
		getAttributeTextBoxHandle(1).SetText(string(Info.AttackAttributeValue));
	}
	else
	{
		if(((Info.DefenseAttributeValueWater > 0) && (itemAttributeCount < 3)))
		{
			itemAttributeCount++;
			getAttributeTextureHandle(itemAttributeCount).SetTexture(attributeTypeToTextureString(1, ItemType));
			getAttributeTextBoxHandle(itemAttributeCount).SetText(string(Info.DefenseAttributeValueWater));
		}
		if(((Info.DefenseAttributeValueFire > 0) && (itemAttributeCount < 3)))
		{
			itemAttributeCount++;
			getAttributeTextureHandle(itemAttributeCount).SetTexture(attributeTypeToTextureString(0, ItemType));
			getAttributeTextBoxHandle(itemAttributeCount).SetText(string(Info.DefenseAttributeValueFire));
		}
		if(((Info.DefenseAttributeValueWind > 0) && (itemAttributeCount < 3)))
		{
			itemAttributeCount++;
			getAttributeTextureHandle(itemAttributeCount).SetTexture(attributeTypeToTextureString(2, ItemType));
			getAttributeTextBoxHandle(itemAttributeCount).SetText(string(Info.DefenseAttributeValueWind));
		}
		if(((Info.DefenseAttributeValueEarth > 0) && (itemAttributeCount < 3)))
		{
			itemAttributeCount++;
			getAttributeTextureHandle(itemAttributeCount).SetTexture(attributeTypeToTextureString(3, ItemType));
			getAttributeTextBoxHandle(itemAttributeCount).SetText(string(Info.DefenseAttributeValueEarth));
		}
		if(((Info.DefenseAttributeValueHoly > 0) && (itemAttributeCount < 3)))
		{
			itemAttributeCount++;
			getAttributeTextureHandle(itemAttributeCount).SetTexture(attributeTypeToTextureString(4, ItemType));
			getAttributeTextBoxHandle(itemAttributeCount).SetText(string(Info.DefenseAttributeValueHoly));
		}
		if(((Info.DefenseAttributeValueUnholy > 0) && (itemAttributeCount < 3)))
		{
			itemAttributeCount++;
			getAttributeTextureHandle(itemAttributeCount).SetTexture(attributeTypeToTextureString(5, ItemType));
			getAttributeTextBoxHandle(itemAttributeCount).SetText(string(Info.DefenseAttributeValueUnholy));
		}
		itemAttributeCount = 0;
		if((Info.DefenseAttributeValueWater > 0))
		{
			itemAttributeCount++;
		}
		if((Info.DefenseAttributeValueFire > 0))
		{
			itemAttributeCount++;
		}
		if((Info.DefenseAttributeValueWind > 0))
		{
			itemAttributeCount++;
		}
		if((Info.DefenseAttributeValueEarth > 0))
		{
			itemAttributeCount++;
		}
		if((Info.DefenseAttributeValueHoly > 0))
		{
			itemAttributeCount++;
		}
		if((Info.DefenseAttributeValueUnholy > 0))
		{
			itemAttributeCount++;
		}
		if((itemAttributeCount > 3))
		{
			getAttributeTextureHandle(4).ShowWindow();
			getAttributeTextBoxHandle(4).ShowWindow();
		}
	}
	return;
}

function TextureHandle getAttributeTextureHandle(int Num)
{
	local TextureHandle tempTextureHandle;

	switch(Num)
	{
		case 1:
			tempTextureHandle = MySellingItemPropertyIcon_01;
			break;
		case 2:
			tempTextureHandle = MySellingItemPropertyIcon_02;
			break;
		case 3:
			tempTextureHandle = MySellingItemPropertyIcon_03;
			break;
		case 4:
			tempTextureHandle = MySellingItemPropertyIcon_04;
			break;
		default:
			break;
	}
	return tempTextureHandle;
}

function TextBoxHandle getAttributeTextBoxHandle(int Num)
{
	local TextBoxHandle tempTextBoxHandle;

	switch(Num)
	{
		case 1:
			tempTextBoxHandle = MySellingItemPropertyValue_01;
			break;
		case 2:
			tempTextBoxHandle = MySellingItemPropertyValue_02;
			break;
		case 3:
			tempTextBoxHandle = MySellingItemPropertyValue_03;
			break;
		case 4:
			tempTextBoxHandle = MySellingItemPropertyValue_04;
			break;
		default:
			break;
	}
	return tempTextBoxHandle;
}

function int getComboPeriod(int Index)
{
	local int returnDay;

	switch(Index)
	{
		case 0:
			returnDay = 1;
			break;
		case 1:
			returnDay = 3;
			break;
		case 2:
			returnDay = 5;
			break;
		case 3:
			returnDay = 7;
			break;
		default:
			break;
	}
	return returnDay;
}

function startSearchDelay()
{
	Me.SetTimer(2001001, 700);
	DisableCurrentWindow(true);
	disableCurrentWindowFlag = true;
	return;
}

function startCategoryTreeSearchDelay()
{
	Me.SetTimer(2001002, 700);
	DisableCurrentWindow(true);
	disableCurrentWindowFlag = true;
	return;
}

function startReSearchDelay()
{
	Me.SetTimer(2001003, 700);
	DisableCurrentWindow(true);
	disableCurrentWindowFlag = true;
	return;
}

function OnTimer(int TimerID)
{
	if((TimerID == 2001002))
	{
		Me.KillTimer(2001002);
		DisableCurrentWindow(false);
	}
	else if((TimerID == 2001001))
	{
		Me.KillTimer(2001001);
	}
	if(((TimerID == 2001001) || (TimerID == 2001002)))
	{
		DisableCurrentWindow(false);
		disableCurrentWindowFlag = false;
		if((saveTreePath != ""))
		{
			if((beforeTreeNodeCalled != saveTreePath))
			{
				clickTreeState(saveTreePath);
			}
			saveTreePath = "";
		}
	}
	if((TimerID == 2001003))
	{
		DisableCurrentWindow(false);
		disableCurrentWindowFlag = false;
		Me.KillTimer(2001003);
		sellListSearch();
	}
	return;
}

function DisableCurrentWindow(bool bFlag)
{
	if(bFlag)
	{
		disableWnd.EnableWindow();
		disableWnd.ShowWindow();
	}
	else
	{
		disableWnd.DisableWindow();
		disableWnd.HideWindow();
	}
	return;
}

function string attributeTypeToTextureString(int attType, int ItemType)
{
	local string returnStr;

	if((ItemType == 0))
	{
		switch(attType)
		{
			case 0:
				returnStr = "l2ui_ct1.SellingAgencyWnd_df_ItemPropertyIcon_Fire";
				break;
			case 1:
				returnStr = "l2ui_ct1.SellingAgencyWnd_df_ItemPropertyIcon_Water";
				break;
			case 2:
				returnStr = "l2ui_ct1.SellingAgencyWnd_df_ItemPropertyIcon_Wind";
				break;
			case 3:
				returnStr = "l2ui_ct1.SellingAgencyWnd_df_ItemPropertyIcon_Earth";
				break;
			case 4:
				returnStr = "l2ui_ct1.SellingAgencyWnd_df_ItemPropertyIcon_Divine";
				break;
			case 5:
				returnStr = "l2ui_ct1.SellingAgencyWnd_df_ItemPropertyIcon_Dark";
				break;
			default:
				returnStr = "L2UI_CT1.EmptyBtn";
		}
	}
	else
	{
		switch(attType)
		{
			case 0:
				returnStr = "l2ui_ct1.SellingAgencyWnd_df_ItemPropertyIcon_Water";
				break;
			case 1:
				returnStr = "l2ui_ct1.SellingAgencyWnd_df_ItemPropertyIcon_Fire";
				break;
			case 2:
				returnStr = "l2ui_ct1.SellingAgencyWnd_df_ItemPropertyIcon_Earth";
				break;
			case 3:
				returnStr = "l2ui_ct1.SellingAgencyWnd_df_ItemPropertyIcon_Wind";
				break;
			case 4:
				returnStr = "l2ui_ct1.SellingAgencyWnd_df_ItemPropertyIcon_Dark";
				break;
			case 5:
				returnStr = "l2ui_ct1.SellingAgencyWnd_df_ItemPropertyIcon_Divine";
				break;
			default:
				returnStr = "L2UI_CT1.EmptyBtn";
		}
	}
	return returnStr;
}

function string getItemNameForSellingAgency(ItemInfo mItemInfo)
{
	local UIEventManager.EEtcItemType EEtcItemType;
	local string itemNameString;

	itemNameString = "";
	EEtcItemType = EEtcItemType(mItemInfo.EtcItemType);
	if((int(EEtcItemType) == 7))
	{
		itemNameString = ((("Lv" $ string(mItemInfo.Enchanted)) $ " ") $ mItemInfo.Name);
	}
	else
	{
		itemNameString = GetItemNameAll(mItemInfo);
	}
	return itemNameString;
}

function string deleteRightSpeceString(string tempStr)
{
	local int i;

	if((Len(tempStr) == 0))
	{
		return tempStr;
	}
	i = Len(tempStr);
	while(((Mid(tempStr, (i - 1), 1) == " ") || (Mid(tempStr, i, 1) == "t")))
	{
		--i;
		tempStr = Left(tempStr, i);
	}
	return tempStr;
}

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	local string mainKey;

	if(MySellingItemUnitPriceEdit.IsFocused())
	{
		updateSellRegisterForm();
	}
	else if(SearchWord_Editbox.IsFocused())
	{
		mainKey = Class'NWindow.InputAPI'.static.GetKeyString(nKey);
		if((mainKey == "ENTER"))
		{
			if(!disableCurrentWindowFlag)
			{
				OnSearchBtnClick();
			}
		}
	}
	return false;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("SellingAgencyWnd").HideWindow();
	return;
}

function string getCommisionNum(INT64 ItemNum, INT64 Price, int PeriodType)
{
	local INT64 _commission;

	_commission = ((ItemNum * Price) * INT64(getComboPeriod(PeriodType)));
	_commission = ((_commission * INT64(1)) / INT64(10000));
	if((_commission < INT64(10000)))
	{
		_commission = INT64(1000);
	}
	return string(_commission);
}
