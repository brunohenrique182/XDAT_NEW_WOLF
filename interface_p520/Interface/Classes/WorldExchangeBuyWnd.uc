class WorldExchangeBuyWnd extends UICommonAPI
	dependson(UIPacket);

const INSERT_ONCE_LIST_NUM = 10;
const LOAD_ONCE_LIST_NUM = 100;
const REFRESHLIMIT = 1000;
const REFRESHLIMITMIN = 500;
const MAIN_TAB_CLASSIC_MAX = 5;
const MAIN_TAB_LIVE_MAX = 7;

enum ItemMainType
{
	Adena,                          // 0
	Equipment,                      // 1
	Artifact,                       // 2
	Enchant,                        // 3
	Consumable,                     // 4
	EtcType,                        // 5
	COLLECTION                      // 6
};

enum ItemSubtype
{
	Weapon,                         // 0
	Armor,                          // 1
	Accessary,                      // 2
	EtcEquipment,                   // 3
	ArtifactB1,                     // 4
	ArtifactC1,                     // 5
	ArtifactD1,                     // 6
	ArtifactA1,                     // 7
	ENCHANTSCROLL,                  // 8
	BlessEnchantScroll,             // 9
	MultiEnchantScroll,             // 10
	AncientEnchantScroll,           // 11
	Spiritshot,                     // 12
	Soulshot,                       // 13
	Buff,                           // 14
	VariationStone,                 // 15
	dye,                            // 16
	SoulCrystal,                    // 17
	SkillBook,                      // 18
	EtcEnchant,                     // 19
	PotionAndEtcScroll,             // 20
	ticket,                         // 21
	Craft,                          // 22
	IncEnchantProp,                 // 23
	Adena,                          // 24
	EtcSubtype                      // 25
};

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

enum HEADER_TYPE
{
	ItemName,                       // 0
	ItemNum,                        // 1
	totalprice,                     // 2
	perPrice                        // 3
};

struct categoryStruct
{
	var int subSelectedIndex;
	var array<int> subCategoryStringArray;
	var array<int> subCategoryKeyArray;
};

var int RESTARTPOINTITEM_LCOIN;
var INT64 ADENA_BASIC_UNIT;
var INT64 ADENA_MIN;
var INT64 ADENA_MAX;
var int refreshMinCount;
var int lastLoadedPage;
var int nMaxPage;
var bool bRQ_C_EX_WORLD_EXCHANGE_ITEM_LIST;
var array<UIPacket._WorldExchangeItemData> _itemDatas;
var L2UITimerObject tObjectListAdd;
var L2UITimerObject tObjectListRefreshDefaultDelay;
var UIControlTextInput uicontrolTextInputScr;
var RichListCtrlHandle List_RichList;
var RichListCtrlHandle List_RichListAdena;
var WindowHandle itemBuyDialog_Wnd;
var WindowHandle ItemBuyPopUp_Wnd;
var WindowHandle ItemBuyResultPopUp_Wnd;
var WindowHandle FindDisable_Wnd;
var string lastFindString;
var array<int> ItemList;
var bool bFirst;
var int scrollPos;
var int requestedScrollPos;
var UIControlGroupButtonAssets TopGroupButtonAsset;
var UIControlGroupButtonAssets SubGroupButtonAsset;
var CheckBoxHandle compareTooltipCheckBox;
var INT64 nWEIndex;
var int ShowHeaderIndex;
var int ShowHeaderIndexAdena;
var array<categoryStruct> categoryArray;
//var delegate<OnSortCompareByName> __OnSortCompareByName__Delegate;

static function WorldExchangeBuyWnd Inst()
{
	return WorldExchangeBuyWnd(GetScript("WorldExchangeBUyWNd"));
}

event OnRegisterEvent()
{
	RegisterEvent(40);
	RegisterEvent(EV_PacketID(1020));
	RegisterEvent(EV_PacketID(1022));
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	initGroupButton();
	OnLoadEachServer();
	itemBuyDialog_Wnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemBuyDialog_Wnd"));
	ItemBuyPopUp_Wnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemBuyDialog_Wnd.ItemBuyPopUp_Wnd"));
	ItemBuyResultPopUp_Wnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemBuyDialog_Wnd.ItemBuyResultPopUp_Wnd"));
	FindDisable_Wnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".FindDisable_Wnd"));
	FindDisable_Wnd.ShowWindow();
	ShowBuyResultPopup();
	List_RichList = GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".List_RichList"));
	List_RichList.SetSelectedSelTooltip(false);
	List_RichList.SetAppearTooltipAtMouseX(true);
	List_RichList.SetSortable(false);
	List_RichListAdena = GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".List_RichListAdena"));
	List_RichListAdena.SetSelectedSelTooltip(false);
	List_RichListAdena.SetAppearTooltipAtMouseX(true);
	List_RichListAdena.SetSortable(false);
	uicontrolTextInputScr = Class'Interface.UIControlTextInput'.static.InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemFind_Wnd.TextInput")));
	uicontrolTextInputScr.DelegateESCKey = DelegateESCKey;
	uicontrolTextInputScr.DelegateOnChangeEdited = DelegateOnChangeEdited;
	uicontrolTextInputScr.DelegateOnCompleteEditBox = DelegateOnCompleteEditBox;
	uicontrolTextInputScr.DelegateOnClear = DelegateOnClear;
	uicontrolTextInputScr.SetDefaultString(GetSystemString(2507));
	uicontrolTextInputScr.SetEdtiable(true);
	uicontrolTextInputScr.SetDisable(true);
	InitTimerObject();
	compareTooltipCheckBox = GetCheckBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CompareTooltip_CheckBox"));
	InitCompareTooltipCheckBox();
	SetSortType(EWEST_PRICE_PER_PIECE_ASCE);
	List_RichList.SetAscend(0, true);
	List_RichList.ShowSortIcon(0);
	return;
}

function InitCompareTooltipCheckBox()
{
	local int compareTooltipEnable;

	if(!GetINIBool("WorldExchangeBuyWnd", "a", compareTooltipEnable, "WindowsInfo.ini"))
	{
		compareTooltipEnable = 1;
		SetINIBool("WorldExchangeBuyWnd", "a", bool(compareTooltipEnable), "WindowsInfo.ini");
	}
	compareTooltipCheckBox.SetCheck(bool(compareTooltipEnable));
	SetShowCompareTooltipOnWorldExchange(bool(compareTooltipEnable));
	return;
}

function InitTimerObject()
{
	local int Time, Count;

	Count = (100 / 10);
	Time = (1000 / Count);
	tObjectListAdd = Class'Interface.L2UITimer'.static.Inst()._MakeTimerObject(Time, Count);
	tObjectListAdd._DelegateOnTime = TInsertRecordOnTime;
	tObjectListAdd._DelegateOnEnd = TInserDelayCheck;
	refreshMinCount = (500 / Time);
	return;
}

event OnClickHeaderCtrl(string strID, int Index)
{
	if(bRQ_C_EX_WORLD_EXCHANGE_ITEM_LIST)
	{
		return;
	}
	if(!SetSortByHeaderIndex(Index))
	{
		return;
	}
	RQWorldExchangeItemList(uicontrolTextInputScr.GetString());
	RQ_C_EX_WORLD_EXCHANGE_ITEM_LIST();
	return;
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case 40:
			break;
		case EV_PacketID(1020):
			RT_S_EX_WORLD_EXCHANGE_ITEM_LIST();
			break;
		case EV_PacketID(1022):
			RT_S_EX_WORLD_EXCHANGE_BUY_ITEM();
			break;
		default:
			break;
	}
	return;
}

event OnShow()
{
	if(!CheckOpenCondition())
	{
		m_hOwnerWnd.HideWindow();
		return;
	}
	if(!bFirst)
	{
		TopGroupButtonAsset._GetGroupButtonsInstance()._setTopOrder(0);
		SetGroupButtonCategorySub(0);
		SubGroupButtonAsset._GetGroupButtonsInstance()._setTopOrder(0);
		TopGroupButtonAsset._GetGroupButtonsInstance()._SetDisable(TopGroupButtonAsset._GetGroupButtonsInstance()._FindButtonIndexByValue(6));
		GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".TabIcon04_Tex")).SetAlpha(100, 0.5000000);
		bFirst = true;
	}
	Class'Interface.WorldExchangeRegiWnd'.static.Inst()._Hide();
	HideBuyDialog();
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	if(bRQ_C_EX_WORLD_EXCHANGE_ITEM_LIST)
	{
		tObjectListAdd._Reset();
	}
	if(getInstanceUIData().GetIsLiveServer())
	{
		SideBar(GetScript("SideBar")).ToggleByWindowName(getCurrentWindowName(string(self)), true);
	}
	return;
}

event OnHide()
{
	if(DialogIsMine())
	{
		Class'Interface.DialogBox'.static.Inst().HideDialog();
	}
	if(getInstanceUIData().GetIsLiveServer())
	{
		SideBar(GetScript("SideBar")).ToggleByWindowName(getCurrentWindowName(string(self)), false);
	}
	return;
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "WndClose_BTN":
			_Hide();
			break;
		case "Refresh_btn":
			HandleBtnRefresh();
			break;
		case "BtnFind":
			HandleBtnFind();
			break;
		case "MoveWnd_Btn":
			HandleBtnSwap();
			break;
		case "Cancel_Btn":
			HideBuyDialog();
			break;
		case "Ok_Btn":
			RQ_C_EX_WORLD_EXCHANGE_BUY_ITEM();
			HideBuyDialog();
			break;
		case "OkResult_Btn":
			HideBuyDialog();
			break;
		default:
			ChckBtnName(strID);
			break;
	}
	return;
}

event OnDBClickListCtrlRecord(string ListCtrlID)
{
	local RichListCtrlRowData rowData;

	GetCurrentRichlistCtrlHandle().GetSelectedRec(rowData);
	SetShowBuyDialogWindow(int(rowData.nReserved1));
	return;
}

event OnScrollMove(string strID, int pos)
{
	switch(strID)
	{
		case "List_RichList":
		case "List_RichLIstAdena":
			HandleScrollMove(pos);
			break;
		default:
			break;
	}
	return;
}

event OnCilckCheckBoxWithHandle(CheckBoxHandle a_CheckBoxHandle)
{
	if((a_CheckBoxHandle == compareTooltipCheckBox))
	{
		SetINIBool("WorldExchangeBuyWnd", "a", compareTooltipCheckBox.IsChecked(), "WindowsInfo.ini");
		SetShowCompareTooltipOnWorldExchange(compareTooltipCheckBox.IsChecked());
	}
	return;
}

function initGroupButton()
{
	TopGroupButtonAsset = Class'Interface.UIControlGroupButtonAssets'.static._InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".UIControlGroupButtonAsset1")));
	TopGroupButtonAsset._SetStartInfo("L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Center_Unselected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Center_Selected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Center_Unselected_Over", true);
	SubGroupButtonAsset = Class'Interface.UIControlGroupButtonAssets'.static._InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SubUIControlGroupButtonAsset")));
	SubGroupButtonAsset._SetStartInfo("L2UI_ct1.RankingWnd.RankingWnd_SubTabButton", "L2UI_ct1.RankingWnd.RankingWnd_SubTabButton_Down", "L2UI_ct1.RankingWnd.RankingWnd_SubTabButton_Over", true);
	TopGroupButtonAsset._GetGroupButtonsInstance().DelegateOnClickButton = DelegateOnClickButtonTop;
	SubGroupButtonAsset._GetGroupButtonsInstance().DelegateOnClickButton = DelegateOnClickButtonSub;
	return;
}

function SetMainCategoryButtons()
{
	local UIControlGroupButtons mainGroupBtnScr;

	mainGroupBtnScr = TopGroupButtonAsset._GetGroupButtonsInstance();
	mainGroupBtnScr._setButtonText(0, GetSystemString(469));
	mainGroupBtnScr._setButtonValue(0, 0);
	mainGroupBtnScr._setButtonText(1, GetSystemString(116));
	mainGroupBtnScr._setButtonValue(1, 1);
	mainGroupBtnScr._setButtonText(2, GetSystemString(2066));
	mainGroupBtnScr._setButtonValue(2, 3);
	mainGroupBtnScr._setButtonText(3, GetSystemString(13891));
	mainGroupBtnScr._setButtonValue(3, 4);
	mainGroupBtnScr._setButtonText(4, GetSystemString(13476));
	mainGroupBtnScr._setButtonValue(4, 6);
	mainGroupBtnScr._setShowButtonNum(5);
	mainGroupBtnScr._setAutoWidth(958, 0);
	mainGroupBtnScr._setButtonTexture(mainGroupBtnScr._FindButtonIndexByValue(6), "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Right_Unselected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Right_Selected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Right_Unselected_Over");
	GetMeTexture("TabIcon01_Tex").ShowWindow();
	GetMeTexture("TabIcon02_Tex").ShowWindow();
	GetMeTexture("TabIcon03_Tex").ShowWindow();
	GetMeTexture("TabIcon04_Tex").ShowWindow();
	GetMeTexture("TabIcon05_Tex").ShowWindow();
	GetMeTexture("TabIcon06_Tex").HideWindow();
	GetMeTexture("TabIcon07_Tex").HideWindow();
	GetMeTexture("TabIcon01_Tex").SetTexture("L2UI.WorldExchangeWnd.WorldExchange_Adena");
	GetMeTexture("TabIcon02_Tex").SetTexture("L2UI.WorldExchangeWnd.WorldExchange_EquipIcon");
	GetMeTexture("TabIcon03_Tex").SetTexture("L2UI.WorldExchangeWnd.WorldExchange_EnchantIcon");
	GetMeTexture("TabIcon04_Tex").SetTexture("L2UI.WorldExchangeWnd.WorldExchange_EtcIcon");
	GetMeTexture("TabIcon05_Tex").SetTexture("L2UI.WorldExchangeWnd.WorldExchange_CollectionIcon");
	GetMeTexture("TabIcon06_Tex").SetTexture("");
	GetMeTexture("TabIcon07_Tex").SetTexture("");
	mainGroupBtnScr._setTextureLoc(0, GetMeTexture("TabIcon01_Tex"), 8, 6, "left");
	mainGroupBtnScr._setTextureLoc(1, GetMeTexture("TabIcon02_Tex"), 8, 6, "left");
	mainGroupBtnScr._setTextureLoc(2, GetMeTexture("TabIcon03_Tex"), 8, 6, "left");
	mainGroupBtnScr._setTextureLoc(3, GetMeTexture("TabIcon04_Tex"), 8, 6, "left");
	mainGroupBtnScr._setTextureLoc(4, GetMeTexture("TabIcon05_Tex"), 8, 6, "left");
	mainGroupBtnScr._setTextureLoc(4, GetMeTexture("TabIconRibbon_Tex"), 0, 0, "left");
	return;
}

function SetMainCategoryButtonsLive()
{
	local UIControlGroupButtons mainGroupBtnScr;

	mainGroupBtnScr = TopGroupButtonAsset._GetGroupButtonsInstance();
	if(((int(GetLanguage()) == 8) || (int(GetLanguage()) == 9)))
	{
		mainGroupBtnScr._setButtonText(0, GetSystemString(5216));
	}
	else
	{
		mainGroupBtnScr._setButtonText(0, GetSystemString(469));
	}
	mainGroupBtnScr._setButtonValue(0, 0);
	mainGroupBtnScr._setButtonText(1, GetSystemString(116));
	mainGroupBtnScr._setButtonValue(1, 1);
	mainGroupBtnScr._setButtonText(2, GetSystemString(3877));
	mainGroupBtnScr._setButtonValue(2, 2);
	mainGroupBtnScr._setButtonText(3, GetSystemString(1532));
	mainGroupBtnScr._setButtonValue(3, 3);
	mainGroupBtnScr._setButtonText(4, GetSystemString(3935));
	mainGroupBtnScr._setButtonValue(4, 4);
	mainGroupBtnScr._setButtonText(5, GetSystemString(49));
	mainGroupBtnScr._setButtonValue(5, 5);
	mainGroupBtnScr._setButtonText(6, GetSystemString(13476));
	mainGroupBtnScr._setButtonValue(6, 6);
	mainGroupBtnScr._setShowButtonNum(7);
	mainGroupBtnScr._setAutoWidth(958, 0);
	GetMeTexture("TabIcon01_Tex").ShowWindow();
	GetMeTexture("TabIcon02_Tex").ShowWindow();
	GetMeTexture("TabIcon03_Tex").ShowWindow();
	GetMeTexture("TabIcon04_Tex").ShowWindow();
	GetMeTexture("TabIcon05_Tex").ShowWindow();
	GetMeTexture("TabIcon06_Tex").ShowWindow();
	GetMeTexture("TabIcon07_Tex").ShowWindow();
	GetMeTexture("TabIcon01_Tex").SetTexture("L2UI.WorldExchangeWnd.WorldExchange_Adena");
	GetMeTexture("TabIcon02_Tex").SetTexture("L2UI.WorldExchangeWnd.WorldExchange_EquipIcon");
	GetMeTexture("TabIcon03_Tex").SetTexture("L2UI.WorldExchangeWnd.WorldExchange_Artefact");
	GetMeTexture("TabIcon04_Tex").SetTexture("L2UI.WorldExchangeWnd.WorldExchange_Scroll");
	GetMeTexture("TabIcon05_Tex").SetTexture("L2UI.WorldExchangeWnd.WorldExchange_Consumable");
	GetMeTexture("TabIcon06_Tex").SetTexture("L2UI.WorldExchangeWnd.WorldExchange_EtcIcon");
	GetMeTexture("TabIcon07_Tex").SetTexture("L2UI.WorldExchangeWnd.WorldExchange_CollectionIcon");
	mainGroupBtnScr._setTextureLoc(0, GetMeTexture("TabIcon01_Tex"), 8, 6, "left");
	mainGroupBtnScr._setTextureLoc(1, GetMeTexture("TabIcon02_Tex"), 8, 6, "left");
	mainGroupBtnScr._setTextureLoc(2, GetMeTexture("TabIcon03_Tex"), 8, 6, "left");
	mainGroupBtnScr._setTextureLoc(3, GetMeTexture("TabIcon04_Tex"), 8, 6, "left");
	mainGroupBtnScr._setTextureLoc(4, GetMeTexture("TabIcon05_Tex"), 8, 6, "left");
	mainGroupBtnScr._setTextureLoc(5, GetMeTexture("TabIcon06_Tex"), 8, 6, "left");
	mainGroupBtnScr._setTextureLoc(6, GetMeTexture("TabIcon07_Tex"), 8, 6, "left");
	mainGroupBtnScr._setTextureLoc(6, GetMeTexture("TabIconRibbon_Tex"), 0, 0, "left");
	mainGroupBtnScr._setButtonTexture(mainGroupBtnScr._FindButtonIndexByValue(6), "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Right_Unselected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Right_Selected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Right_Unselected_Over");
	return;
}

function AddSubCategoryData(int mainIndex, int Key, int stringNum)
{
	local int SubIndex;
	local categoryStruct Data;

	Data = categoryArray[mainIndex];
	SubIndex = Data.subCategoryKeyArray.Length;
	Data.subCategoryKeyArray[SubIndex] = Key;
	Data.subCategoryStringArray[SubIndex] = stringNum;
	categoryArray[mainIndex] = Data;
	return;
}

function SetSubCategoryData()
{
	AddSubCategoryData(0, 24, 144);
	AddSubCategoryData(1, 0, 2520);
	AddSubCategoryData(1, 1, 2532);
	AddSubCategoryData(1, 2, 2537);
	AddSubCategoryData(1, 3, 49);
	AddSubCategoryData(2, 0, 0);
	AddSubCategoryData(3, 8, 1532);
	AddSubCategoryData(3, 17, 2554);
	AddSubCategoryData(3, 15, 2553);
	AddSubCategoryData(3, 16, 25);
	AddSubCategoryData(3, 18, 2558);
	AddSubCategoryData(3, 19, 49);
	AddSubCategoryData(2, 0, 0);
	AddSubCategoryData(4, 20, 13848);
	AddSubCategoryData(4, 21, 5834);
	AddSubCategoryData(4, 22, 13892);
	AddSubCategoryData(4, 25, 49);
	AddSubCategoryData(5, 0, 0);
	AddSubCategoryData(6, 1, 116);
	AddSubCategoryData(6, 3, 13846);
	AddSubCategoryData(6, 5, 49);
	return;
}

function SetSubCategoryDataLive()
{
	AddSubCategoryData(0, 24, 144);
	AddSubCategoryData(1, 0, 2520);
	AddSubCategoryData(1, 1, 2532);
	AddSubCategoryData(1, 2, 2537);
	AddSubCategoryData(2, 4, 3891);
	AddSubCategoryData(2, 5, 3892);
	AddSubCategoryData(2, 6, 3893);
	AddSubCategoryData(2, 7, 3894);
	AddSubCategoryData(3, 8, 2611);
	AddSubCategoryData(3, 9, 13841);
	AddSubCategoryData(3, 10, 13842);
	AddSubCategoryData(3, 11, 13843);
	AddSubCategoryData(4, 12, 2545);
	AddSubCategoryData(4, 13, 2544);
	AddSubCategoryData(4, 14, 13318);
	AddSubCategoryData(5, 15, 3349);
	AddSubCategoryData(5, 16, 25);
	AddSubCategoryData(5, 23, 13844);
	AddSubCategoryData(5, 25, 49);
	return;
}

function SetGroupButtonCategorySub(int mainIndex)
{
	local int i, Len;
	local UIControlGroupButtons subGroupBtnScr;

	subGroupBtnScr = SubGroupButtonAsset._GetGroupButtonsInstance();
	Len = categoryArray[mainIndex].subCategoryStringArray.Length;
	subGroupBtnScr._setShowButtonNum(Len);
	subGroupBtnScr._fixedWidth(110, 5);
	i = 0;
	while((i < Len))
	{
		subGroupBtnScr._setButtonText(i, GetSystemString(categoryArray[mainIndex].subCategoryStringArray[i]));
		subGroupBtnScr._setButtonValue(i, categoryArray[mainIndex].subCategoryKeyArray[i]);
		i++;
	}
	subGroupBtnScr._setTopOrder(categoryArray[mainIndex].subSelectedIndex);
	return;
}

function DelegateOnClickButtonSub(string parentWndName, string strName, int SubIndex)
{
	local int topButtonGroupIndex;

	topButtonGroupIndex = GetCurrentMainType();
	categoryArray[topButtonGroupIndex].subSelectedIndex = SubIndex;
	RQ_C_EX_WORLD_EXCHANGE_ITEM_LIST();
	return;
}

function TransformAdena()
{
	if((GetCurrentMainType() == 0))
	{
		List_RichList.HideWindow();
		List_RichListAdena.ShowWindow();
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemFind_Wnd")).HideWindow();
		SetSortType(EWEST_PRICE_PER_PIECE_ASCE);
		compareTooltipCheckBox.HideWindow();
	}
	else
	{
		List_RichList.ShowWindow();
		List_RichListAdena.HideWindow();
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemFind_Wnd")).ShowWindow();
		compareTooltipCheckBox.ShowWindow();
	}
	return;
}

function DelegateOnClickButtonTop(string parentWndName, string strName, int mainIndex)
{
	local int topButtonGroupIndex;

	topButtonGroupIndex = GetCurrentMainType();
	TransformAdena();
	SetGroupButtonCategorySub(topButtonGroupIndex);
	return;
}

function HandleClear()
{
	lastFindString = "";
	ItemList.Length = 0;
	RQ_C_EX_WORLD_EXCHANGE_ITEM_LIST();
	return;
}

function DelegateESCKey()
{
	OnReceivedCloseUI();
	return;
}

function DelegateOnClear()
{
	HandleClear();
	return;
}

function DelegateOnChangeEdited(string Text)
{
	if((lastFindString == Text))
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemFind_Wnd.BtnFind")).DisableWindow();
	}
	else
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemFind_Wnd.BtnFind")).EnableWindow();
	}
	return;
}

function bool CheckFindString(string Text, out array<int> _itemList)
{
	if((Text == ""))
	{
		return true;
	}
	API_GetStringMatchingItemList(Text, " ", SMIF_WorldExchangeItem, GetCurrentRichlistCtrlHandle().IsAscending(0), _itemList);
	return (_itemList.Length > 0);
}

function DelegateOnCompleteEditBox(string Text)
{
	SetSortType(EWEST_PRICE_PER_PIECE_ASCE);
	RQWorldExchangeItemList(Text);
	return;
}

function RQWorldExchangeItemList(string Text)
{
	local array<int> _itemList;

	if(!CheckFindString(Text, _itemList))
	{
		Class'Interface.L2Util'.static.Inst().showGfxScreenMessage(((("&#34;" $ Text) $ "&#34;") $ GetSystemMessage(4356)));
		return;
	}
	if((_itemList.Length > 300))
	{
		Class'Interface.L2Util'.static.Inst().showGfxScreenMessage(GetSystemMessage(13767));
		return;
	}
	lastFindString = Text;
	ItemList = _itemList;
	RQ_C_EX_WORLD_EXCHANGE_ITEM_LIST();
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

function HandleBtnSwap()
{
	_Hide();
	Class'Interface.WorldExchangeRegiWnd'.static.Inst()._Show();
	getInstanceL2Util().syncWindowLoc(m_hOwnerWnd.m_WindowNameWithFullPath, "WorldExchangeRegiWnd");
	return;
}

function HandleBtnRefresh()
{
	RQ_C_EX_WORLD_EXCHANGE_ITEM_LIST();
	return;
}

function HandleBtnFind()
{
	SetSortType(EWEST_PRICE_PER_PIECE_ASCE);
	RQWorldExchangeItemList(uicontrolTextInputScr.GetString());
	return;
}

function HandleScrollMove(optional int pos)
{
	scrollPos = pos;
	if(bRQ_C_EX_WORLD_EXCHANGE_ITEM_LIST)
	{
		return;
	}
	Debug(((((("HandleScrollMove" @ string(pos)) @ string(GetCurrentRichlistCtrlHandle().GetRecordCount())) @ string(GetCurrentRichlistCtrlHandle().GetShowRow())) @ string(lastLoadedPage)) @ string(nMaxPage)));
	if((pos == (GetCurrentRichlistCtrlHandle().GetRecordCount() - GetCurrentRichlistCtrlHandle().GetShowRow())))
	{
		RQ_C_EX_WORLD_EXCHANGE_ITEM_LIST((lastLoadedPage + 1));
	}
	return;
}

function SetDisablbRefresh()
{
	local int i;

	bRQ_C_EX_WORLD_EXCHANGE_ITEM_LIST = true;
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Refresh_btn")).DisableWindow();
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemFind_Wnd.BtnFind")).DisableWindow();
	uicontrolTextInputScr.SetDisable(true);
	TopGroupButtonAsset._SetDisable();
	SubGroupButtonAsset._SetDisable();
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".MoveWnd_Btn")).DisableWindow();
	i = 1;
	while((i <= TopGroupButtonAsset._GetGroupButtonsInstance()._getShowButtonNum()))
	{
		if(((TopGroupButtonAsset._GetGroupButtonsInstance()._getSelectButtonIndex() + 1) != i))
		{
			GetTextureHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".TabIcon0") $ string(i)) $ "_Tex")).SetAlpha(100, 0.5000000);
			i++;
			continue;
		}
		GetTextureHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".TabIcon0") $ string(i)) $ "_Tex")).SetAlpha(180, 0.5000000);
		i++;
	}
	tObjectListAdd._Reset();
	return;
}

function SetEnableRefresh()
{
	local int i;

	bRQ_C_EX_WORLD_EXCHANGE_ITEM_LIST = false;
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Refresh_btn")).EnableWindow();
	if((lastFindString != uicontrolTextInputScr.GetString()))
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemFind_Wnd.BtnFind")).EnableWindow();
	}
	uicontrolTextInputScr.SetDisable(false);
	TopGroupButtonAsset._SetEnable();
	SubGroupButtonAsset._SetEnable();
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".MoveWnd_Btn")).EnableWindow();
	i = 1;
	while((i <= TopGroupButtonAsset._GetGroupButtonsInstance()._getShowButtonNum()))
	{
		GetTextureHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".TabIcon0") $ string(i)) $ "_Tex")).SetAlpha(255, 0.5000000);
		i++;
	}
	return;
}

function bool IsAscending(int HeaderIndex)
{
	return GetCurrentRichlistCtrlHandle().IsAscending(HeaderIndex);
}

function bool IsAscendingCurrent()
{
	return IsAscending(GetCurrentHeaderIndex());
}

function HEADER_TYPE GetCurrentHeaderType()
{
	return GetHeaderType(GetCurrentHeaderIndex());
}

function int GetCurrentHeaderIndex()
{
	if((GetCurrentMainType() == 0))
	{
		return ShowHeaderIndexAdena;
	}
	else
	{
		return ShowHeaderIndex;
	}
}

function HEADER_TYPE GetHeaderType(int HeaderIndex)
{
	if((GetCurrentMainType() == 0))
	{
		switch(HeaderIndex)
		{
			case 0:
				return ItemName;
			case 1:
				return totalprice;
			case 2:
				return perPrice;
			default:
				break;
		}
	}
	else
	{
		return HEADER_TYPE(HeaderIndex);
	}
}

function int GetHeaderIndex(HEADER_TYPE Type)
{
	if((GetCurrentMainType() == 0))
	{
		switch(Type)
		{
			case ItemName:
				return 0;
			case totalprice:
				return 1;
			case perPrice:
				return 2;
			default:
				break;
		}
	}
	else
	{
		return int(Type);
	}
}

function int GetCurrentSortType()
{
	switch(GetCurrentHeaderType())
	{
		case ItemName:
			if(IsAscendingCurrent())
			{
				return 2;
			}
			else
			{
				return 3;
			}
		case ItemNum:
			if(IsAscendingCurrent())
			{
				return 6;
			}
			else
			{
				return 7;
			}
		case totalprice:
			if(IsAscendingCurrent())
			{
				return 4;
			}
			else
			{
				return 5;
			}
		case perPrice:
			if(IsAscendingCurrent())
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

function bool SetSortByHeaderIndex(int HeaderIndex)
{
	local bool bAscending;

	if((GetCurrentHeaderIndex() == HeaderIndex))
	{
		bAscending = IsAscending(HeaderIndex);
	}
	switch(GetHeaderType(HeaderIndex))
	{
		case ItemName:
			if(bAscending)
			{
				SetSortType(EWEST_ENCHANT_DESC);
			}
			else
			{
				SetSortType(EWEST_ENCHANT_ASCE);
			}
			break;
		case ItemNum:
			if(bAscending)
			{
				SetSortType(EWEST_AMOUNT_DESC);
			}
			else
			{
				SetSortType(EWEST_AMOUNT_ASCE);
			}
			break;
		case totalprice:
			if(bAscending)
			{
				SetSortType(EWEST_PRICE_DESC);
			}
			else
			{
				SetSortType(EWEST_PRICE_ASCE);
			}
			break;
		case perPrice:
			if(bAscending)
			{
				SetSortType(EWEST_PRICE_PER_PIECE_DESC);
			}
			else
			{
				SetSortType(EWEST_PRICE_PER_PIECE_ASCE);
			}
			break;
		default:
			return false;
	}
	return true;
}

function SetSortType(E_WORLD_EXCHANGE_SORT_TYPE sortType)
{
	local bool bAscend;
	local int HeaderIndex;
	local HEADER_TYPE headerTYpe;
	local RichListCtrlHandle List;

	switch(sortType)
	{
		case EWEST_ENCHANT_ASCE:
			headerTYpe = ItemName;
			bAscend = true;
			break;
		case EWEST_ENCHANT_DESC:
			headerTYpe = ItemName;
			bAscend = false;
			break;
		case EWEST_AMOUNT_ASCE:
			headerTYpe = ItemNum;
			bAscend = true;
			break;
		case EWEST_AMOUNT_DESC:
			headerTYpe = ItemNum;
			bAscend = false;
			break;
		case EWEST_PRICE_ASCE:
			headerTYpe = totalprice;
			bAscend = true;
			break;
		case EWEST_PRICE_DESC:
			headerTYpe = totalprice;
			bAscend = false;
			break;
		case EWEST_PRICE_PER_PIECE_ASCE:
			headerTYpe = perPrice;
			bAscend = true;
			break;
		case EWEST_PRICE_PER_PIECE_DESC:
			headerTYpe = perPrice;
			bAscend = false;
			break;
		default:
			headerTYpe = ItemName;
			bAscend = true;
			break;
	}
	HeaderIndex = GetHeaderIndex(headerTYpe);
	if((GetCurrentMainType() == 0))
	{
		List = List_RichListAdena;
		ShowHeaderIndexAdena = HeaderIndex;
	}
	else
	{
		List = List_RichList;
		ShowHeaderIndex = HeaderIndex;
	}
	Debug(((("SetSortType" @ string(HeaderIndex)) @ string(headerTYpe)) @ List.GetWindowName()));
	List.SetAscend(HeaderIndex, bAscend);
	List.ShowSortIcon(HeaderIndex);
	return;
}

function RichListCtrlHandle GetCurrentRichlistCtrlHandle()
{
	if((GetCurrentMainType() == 0))
	{
		return List_RichListAdena;
	}
	else
	{
		return List_RichList;
	}
}

delegate int OnSortCompareByName(int classIDA, int classIDB)
{
	if((Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(classIDA)) < Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(classIDB))))
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

function WorldExchangeUIData API_GetWorldExchangeData()
{
	return GetWorldExchangeData();
}

function int API_GetServerNo()
{
	return GetServerNo();
}

function API_GetStringMatchingItemList(string a_str, string a_delim, UIEventManager.EStringMatchingItemFilter a_filter, bool a_bAscend, out array<int> o_ItemList)
{
	Class'NWindow.UIDATA_ITEM'.static.GetStringMatchingItemList(a_str, a_delim, a_filter, a_bAscend, o_ItemList);
	return;
}

function RQ_C_EX_WORLD_EXCHANGE_ITEM_LIST(optional int Page)
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLD_EXCHANGE_ITEM_LIST packet;

	if(bRQ_C_EX_WORLD_EXCHANGE_ITEM_LIST)
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
	requestedScrollPos = scrollPos;
	if((_itemDatas.Length > 0))
	{
		return;
	}
	uicontrolTextInputScr.SetString(lastFindString);
	SetDisablbRefresh();
	lastLoadedPage = Page;
	packet.nCategory = GetCurrentSubType();
	packet.cSortType = GetCurrentSortType();
	packet.nPage = Page;
	if((packet.nCategory != 24))
	{
		packet.vItemIDList = ItemList;
	}
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

	Debug(("구입 리스트가 들어 왔나? RT_S_EX_WORLD_EXCHANGE_ITEM_LIST " @ string(lastLoadedPage)));  // EN?: Is the purchase list in? RT_S_EX_world_exchange_item_list
	if(!m_hOwnerWnd.IsShowWindow())
	{
		return;
	}
	if(!Class'Interface.UIPacket'.static.Decode_S_EX_WORLD_EXCHANGE_ITEM_LIST(packet))
	{
		return;
	}
	if((lastLoadedPage == 0))
	{
		_itemDatas.Length = 0;
		GetCurrentRichlistCtrlHandle().DeleteAllItem();
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

	Debug(("Handle_S_EX_WORLD_EXCHANGE_ITEM_LIST" @ string(packet.vItemDataList.Length)));
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
			TInserDelayCheck();
		}
		return;
	}
	Cnt = Min(10, _itemDatas.Length);
	if((GetCurrentMainType() == 0))
	{
		i = 0;
		while((i < Cnt))
		{
			if(_MakeRowDataAdena(_itemDatas[i], rowData))
			{
				List_RichListAdena.InsertRecord(rowData);
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
				List_RichList.InsertRecord(rowData);
			}
			i++;
		}
	}
	_itemDatas.Remove(0, Cnt);
	return;
}

function TInserDelayCheck()
{
	Debug("타이머 종료");  // EN?: End timer
	SetEnableRefresh();
	if((requestedScrollPos != scrollPos))
	{
		HandleScrollMove(scrollPos);
	}
	return;
}

function RQ_C_EX_WORLD_EXCHANGE_BUY_ITEM()
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLD_EXCHANGE_BUY_ITEM packet;

	packet.nWEIndex = nWEIndex;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_WORLD_EXCHANGE_BUY_ITEM(stream, packet))
	{
		return;
	}
	Debug("RQ_C_EX_WORLD_EXCHANGE_BUY_ITEM");
	Class'Interface.UIPacket'.static.RequestUIPacket(786, stream);
	return;
}

function RT_S_EX_WORLD_EXCHANGE_BUY_ITEM()
{
	local UIPacket._S_EX_WORLD_EXCHANGE_BUY_ITEM packet;

	Debug("RT_S_EX_WORLD_EXCHANGE_BUY_ITEM");
	if(!Class'Interface.UIPacket'.static.Decode_S_EX_WORLD_EXCHANGE_BUY_ITEM(packet))
	{
		return;
	}
	Debug(((string(packet.nItemClassID) @ string(packet.nAmount)) @ string(packet.cSuccess)));
	switch(packet.cSuccess)
	{
		case 1:
			ShowBuyResultPopup();
			break;
		case 0:
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13681));
			break;
		case -1:
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13687));
			break;
		default:
			break;
	}
	return;
}

function int GetCurrentMainType()
{
	local int topSelectedIndex;

	topSelectedIndex = TopGroupButtonAsset._GetGroupButtonsInstance()._getSelectButtonIndex();
	return TopGroupButtonAsset._GetGroupButtonsInstance()._getButtonValue(topSelectedIndex);
}

function int GetCurrentSubType()
{
	local int subSelectedIndex;

	subSelectedIndex = SubGroupButtonAsset._GetGroupButtonsInstance()._getSelectButtonIndex();
	return SubGroupButtonAsset._GetGroupButtonsInstance()._getButtonValue(subSelectedIndex);
}

function string _MakeAdenaString(INT64 Adena)
{
	local INT64 hundredMillion, tenMillion;

	if((((int(GetLanguage()) == 1) || (int(GetLanguage()) == 8)) || (int(GetLanguage()) == 9)))
	{
		return (MakeCostString(string(Adena)) @ GetSystemString(469));
	}
	hundredMillion = (Adena / INT64(100000000));
	tenMillion = ((Adena - (hundredMillion * INT64(100000000))) / INT64(10000000));
	if(((hundredMillion == INT64(0)) && (tenMillion == INT64(0))))
	{
		return "";
	}
	if((tenMillion == INT64(0)))
	{
		return ((string(hundredMillion) $ GetSystemString(14189)) @ GetSystemString(469));
	}
	else if((hundredMillion == INT64(0)))
	{
		return ((string(tenMillion) $ GetSystemString(14188)) @ GetSystemString(469));
	}
	return ((((string(hundredMillion) $ GetSystemString(14189)) @ string(tenMillion)) $ GetSystemString(14188)) @ GetSystemString(469));
}

function bool _MakeAdenaitemInfo(out ItemInfo iInfo)
{
	if(!IsAdena(iInfo.Id))
	{
		return false;
	}
	if((iInfo.ItemNum < INT64(100000000)))
	{
		iInfo.IconName = "L2UI.WorldExchangeWnd.Icon_Adena";
	}
	else if((iInfo.ItemNum < INT64(1000000000)))
	{
		iInfo.IconName = "L2UI.WorldExchangeWnd.Icon_AdenaBag";
	}
	else if((iInfo.ItemNum < 6056184812580896770))
	{
		iInfo.IconName = "L2UI.WorldExchangeWnd.Icon_AdenaBox";
	}
	else
	{
		iInfo.IconName = "L2UI.WorldExchangeWnd.Icon_AdenaBox2";
	}
	return true;
}

function bool _MakeRowDataAdena(UIPacket._WorldExchangeItemData _itemData, out RichListCtrlRowData outRowData)
{
	local RichListCtrlRowData rowData;
	local ItemInfo iInfo;
	local string strcom, itemParam;
	local float unitPrice;

	rowData.cellDataList.Length = 4;
	if((_itemData.nItemClassID < 1))
	{
		return false;
	}
	rowData.nReserved1 = _itemData.nWEIndex;
	iInfo = GetItemInfoByClassID(57);
	iInfo.ItemNum = _itemData.nAmount;
	iInfo.Price = _itemData.nPrice;
	strcom = MakeCostStringINT64(iInfo.Price);
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "l2ui_ct1.ItemWindow_DF_SlotBox_Default", 36, 36, 0, 1);
	_MakeAdenaitemInfo(iInfo);
	AddRichListCtrlItem(rowData.cellDataList[0].drawitems, iInfo, 32, 32, -34, 2);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, _MakeAdenaString(iInfo.ItemNum), GetNumericColor(string(iInfo.ItemNum)), false, 5, 7, "hs10");
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, GetSystemString(3931), GetColor(147, 136, 112, 255), false, 18, 0);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, strcom, GetNumericColor(strcom), false, 5, 0);
	unitPrice = (float(iInfo.Price) / (float(iInfo.ItemNum) / float(ADENA_BASIC_UNIT)));
	strcom = MakeCostStringINT64((iInfo.Price / (iInfo.ItemNum / ADENA_BASIC_UNIT)));
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, ("." $ GetDecimalNnmStr(unitPrice)), GetColor(123, 123, 123, 255), false, 0, 1, "hs7");
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, strcom, GetNumericColor(strcom), false, 0, -2);
	AddRichListCtrlButton(rowData.cellDataList[3].drawitems, ("btnBuy_" $ string(_itemData.nWEIndex)), 0, 0, "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Buy_Button", "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Buy_Button_Down", "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Buy_Button_Over", 32, 32, 32, 32);
	ItemInfoToParam(iInfo, itemParam);
	rowData.szReserved = itemParam;
	outRowData = rowData;
	return true;
}

function bool MakeRowData(UIPacket._WorldExchangeItemData _itemData, out RichListCtrlRowData outRowData)
{
	local RichListCtrlRowData rowData;
	local ItemInfo iInfo;
	local string strcom, itemParam;
	local float unitPrice;

	rowData.cellDataList.Length = 5;
	if((_itemData.nItemClassID < 1))
	{
		return false;
	}
	if(!Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(_itemData.nItemClassID), iInfo))
	{
		return false;
	}
	rowData.nReserved1 = _itemData.nWEIndex;
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
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, GetItemNameAll(iInfo), GTColor().White, false, 4, 9);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, string(_itemData.nAmount), GTColor().White, false);
	iInfo.Price = _itemData.nPrice;
	strcom = MakeCostStringINT64(iInfo.Price);
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, GetSystemString(3931), GetColor(147, 136, 112, 255), false, 18, 0);
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, strcom, GetNumericColor(strcom), false, 5, 0);
	unitPrice = (float(iInfo.Price) / float(iInfo.ItemNum));
	strcom = MakeCostStringINT64((iInfo.Price / iInfo.ItemNum));
	AddRichListCtrlString(rowData.cellDataList[3].drawitems, ("." $ GetDecimalNnmStr(unitPrice)), GetColor(123, 123, 123, 255), false, 0, 1, "hs7");
	AddRichListCtrlString(rowData.cellDataList[3].drawitems, strcom, GetNumericColor(strcom), false, 0, -2);
	AddRichListCtrlButton(rowData.cellDataList[4].drawitems, ("btnBuy_" $ string(_itemData.nWEIndex)), 0, 0, "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Buy_Button", "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Buy_Button_Down", "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Buy_Button_Over", 32, 32, 32, 32);
	ItemInfoToParam(iInfo, itemParam);
	rowData.szReserved = itemParam;
	outRowData = rowData;
	return true;
}

function bool CheckOpenCondition()
{
	if(IsPlayerOnWorldRaidServer())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
		return false;
	}
	if(!ChkUseableLevel())
	{
		getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(113), GetSystemString(14063)));
		return false;
	}
	if(!ChkUseableServerID())
	{
		getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(113), GetSystemString(14063)));
		return false;
	}
	if(GetWindowHandle("PrivateShopWndReport").IsShowWindow())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4217));
		return false;
	}
	return true;
}

function bool ChkUseableServerID()
{
	local int i;
	local array<int> UseableServerIDs;

	UseableServerIDs = API_GetWorldExchangeData().UseableServerIDs;
	i = 0;
	while((i < UseableServerIDs.Length))
	{
		if(IsInServerGroup(UseableServerIDs[i]))
		{
			return true;
		}
		i++;
	}
	return false;
}

function bool ChkUseableLevel()
{
	local UserInfo uInfo;

	if(!GetPlayerInfo(uInfo))
	{
		return false;
	}
	return (uInfo.nLevel >= API_GetWorldExchangeData().UseableLevel);
}

function ChckBtnName(string btnName)
{
	local array<string> names;

	Split(btnName, "_", names);
	if((names[0] == "btnBuy"))
	{
		SetShowBuyDialogWindow(int(names[1]));
	}
	return;
}

function SetShowBuyDialogWindow(int _nWEIndex)
{
	local string popupPath;
	local RichListCtrlRowData rowData;
	local ItemInfo iInfo;
	local INT64 lcoinCount;
	local float unitPrice;

	popupPath = ItemBuyPopUp_Wnd.m_WindowNameWithFullPath;
	GetCurrentRichlistCtrlHandle().GetSelectedRec(rowData);
	if((rowData.nReserved1 != INT64(_nWEIndex)))
	{
		return;
	}
	ParamToItemInfo(rowData.szReserved, iInfo);
	GetItemWindowHandle((popupPath $ ".Item_ItemWnd")).Clear();
	if(IsAdena(iInfo.Id))
	{
		GetTextBoxHandle((popupPath $ ".ItemName_Txt")).SetTextColor(GetNumericColor(string(iInfo.ItemNum)));
		GetTextBoxHandle((popupPath $ ".ItemName_Txt")).SetText(_MakeAdenaString(iInfo.ItemNum));
		GetTextBoxHandle((popupPath $ ".ItemNum_Txt")).SetText("x1");
		unitPrice = (float(iInfo.Price) / float((iInfo.ItemNum / ADENA_BASIC_UNIT)));
		GetTextBoxHandle((popupPath $ ".UnitPriceTitle_Txt")).SetText(GetSystemString(14192));
	}
	else
	{
		GetTextBoxHandle((popupPath $ ".ItemName_Txt")).SetTextColor(GetColor(153, 153, 153, 255));
		GetTextBoxHandle((popupPath $ ".ItemName_Txt")).SetText(GetItemNameAll(iInfo));
		GetTextBoxHandle((popupPath $ ".ItemNum_Txt")).SetText(("x" $ string(iInfo.ItemNum)));
		unitPrice = (float(iInfo.Price) / float(iInfo.ItemNum));
		GetTextBoxHandle((popupPath $ ".UnitPriceTitle_Txt")).SetText(GetSystemString(14088));
	}
	Debug(("iInfo.IconPanel" @ iInfo.IconPanel));
	Debug(("iInfo.IconPanel2" @ iInfo.IconPanel2));
	GetItemWindowHandle((popupPath $ ".Item_ItemWnd")).AddItem(iInfo);
	GetTextBoxHandle((popupPath $ ".UnitPriceCount_txt")).SetText(MakeUintString(unitPrice));
	GetTextBoxHandle((popupPath $ ".TotalPiceCount_txt")).SetText(MakeCostString(string(iInfo.Price)));
	if(getInstanceUIData().GetIsLiveServer())
	{
		lcoinCount = GetInventoryItemCount(GetItemID(48472));
	}
	else
	{
		lcoinCount = GetInventoryItemCount(GetItemID(91663));
	}
	GetTextBoxHandle((popupPath $ ".MyLcoinPiceCount_txt")).SetText(MakeCostString(string(lcoinCount)));
	if((lcoinCount < iInfo.Price))
	{
		GetButtonHandle((popupPath $ ".Ok_Btn")).DisableWindow();
		GetTextBoxHandle((popupPath $ ".MyLcoinPiceCount_txt")).SetTextColor(GTColor().Red);
	}
	else
	{
		GetButtonHandle((popupPath $ ".Ok_Btn")).EnableWindow();
		GetTextBoxHandle((popupPath $ ".MyLcoinPiceCount_txt")).SetTextColor(GTColor().BLUE01);
		nWEIndex = INT64(_nWEIndex);
	}
	ShowBuyDialog();
	return;
}

function string GetDecimalNnmStr(float Num)
{
	local string floatString;
	local array<string> nums;

	if(getInstanceUIData().GetIsLiveServer())
	{
		if((Num <= 0.0100000))
		{
			Num = 0.0100000;
		}
	}
	floatString = ConvertFloatToString(Num, 2, false);
	Split(floatString, ".", nums);
	return nums[1];
}

function string GetInt64NumStr(float Num)
{
	local array<string> nums;

	Split(string(Num), ".", nums);
	return nums[0];
}

function string MakeUintString(float unitPrice)
{
	local string int64numStr, unitPricStr;

	int64numStr = MakeCostString(GetInt64NumStr(unitPrice));
	unitPricStr = GetDecimalNnmStr(unitPrice);
	return ((int64numStr $ ".") $ unitPricStr);
}

function ShowBuyDialog()
{
	itemBuyDialog_Wnd.ShowWindow();
	ItemBuyPopUp_Wnd.ShowWindow();
	ItemBuyResultPopUp_Wnd.HideWindow();
	uicontrolTextInputScr.SetDisable(true);
	return;
}

function showDisable()
{
	itemBuyDialog_Wnd.ShowWindow();
	ItemBuyPopUp_Wnd.HideWindow();
	ItemBuyResultPopUp_Wnd.HideWindow();
	uicontrolTextInputScr.SetDisable(true);
	return;
}

function ShowBuyResultPopup()
{
	local int SelectedIndex;
	local string popupPath;
	local ItemWindowHandle Result_ItemWnd;
	local RichListCtrlRowData rowData;
	local ItemInfo iInfo;
	local RichListCtrlHandle List;

	List = GetCurrentRichlistCtrlHandle();
	SelectedIndex = List.GetSelectedIndex();
	List.GetSelectedRec(rowData);
	ParamToItemInfo(rowData.szReserved, iInfo);
	List.DeleteRecord(SelectedIndex);
	popupPath = (m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemBuyDialog_Wnd.ItemBuyResultPopUp_Wnd");
	Result_ItemWnd = GetItemWindowHandle((popupPath $ ".Result_ItemWnd"));
	Result_ItemWnd.Clear();
	Result_ItemWnd.AddItem(iInfo);
	if((IsAdena(iInfo.Id) && (((int(GetLanguage()) == 1) || (int(GetLanguage()) == 8)) || (int(GetLanguage()) == 9))))
	{
		GetTextBoxHandle((popupPath $ ".ItemName_Txt")).SetText(_MakeAdenaString(iInfo.ItemNum));
	}
	else
	{
		GetTextBoxHandle((popupPath $ ".ItemName_Txt")).SetText((((GetItemNameAll(iInfo) @ "(") $ string(iInfo.ItemNum)) $ ")"));
	}
	itemBuyDialog_Wnd.ShowWindow();
	ItemBuyPopUp_Wnd.HideWindow();
	ItemBuyResultPopUp_Wnd.ShowWindow();
	uicontrolTextInputScr.SetDisable(true);
	return;
}

function HideBuyDialog()
{
	itemBuyDialog_Wnd.HideWindow();
	uicontrolTextInputScr.SetDisable(false);
	return;
}

function HideDisable()
{
	itemBuyDialog_Wnd.HideWindow();
	uicontrolTextInputScr.SetDisable(false);
	return;
}

function bool _IsNewServer()
{
	return IsInEvaServer();
}

function OnLoadEachServer()
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		ADENA_BASIC_UNIT = INT64(10000000);
		ADENA_MIN = INT64(10000000);
		ADENA_MAX = INT64(1000000000);
		RESTARTPOINTITEM_LCOIN = 48472;
		GetMeTexture("ItemBuyDialog_Wnd.ItemBuyPopUp_Wnd.TotalPiceIcon_Tex").SetTexture("L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Icon_Lcoin");
		GetMeTexture("ItemBuyDialog_Wnd.ItemBuyPopUp_Wnd.MyLcoinIcon_Tex").SetTexture("L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Icon_Lcoin");
		SetMainCategoryButtons();
		SetSubCategoryData();
	}
	else
	{
		ADENA_BASIC_UNIT = INT64(100000000);
		ADENA_MIN = INT64(100000000);
		ADENA_MAX = 6056184812580896770;
		RESTARTPOINTITEM_LCOIN = 91663;
		GetMeTexture("ItemBuyDialog_Wnd.ItemBuyPopUp_Wnd.TotalPiceIcon_Tex").SetTexture("L2UI_EPIC.LCoinShopWnd.bm_einhasad_coin");
		GetMeTexture("ItemBuyDialog_Wnd.ItemBuyPopUp_Wnd.MyLcoinIcon_Tex").SetTexture("L2UI_EPIC.LCoinShopWnd.bm_einhasad_coin");
		SetMainCategoryButtonsLive();
		SetSubCategoryDataLive();
	}
	return;
}

event OnReceivedCloseUI()
{
	if(itemBuyDialog_Wnd.IsShowWindow())
	{
		HideBuyDialog();
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		_Hide();
	}
	return;
}
