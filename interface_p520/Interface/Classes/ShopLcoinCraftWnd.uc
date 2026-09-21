class ShopLcoinCraftWnd extends UICommonAPI
	dependson(UIPacket);

var array<int> _emptyIntArray;

const MAX_CARD = 5;
const MAX_CATEGORY = 18;
const ShopIndex = 4;
const TIMER_CLICK = 99902;
const TIMER_DELAYC = 3000;
const TIMER_FOCUS = 99903;
const TIMER_FOCUS_DELAY = 100;
const TWEEN_ID_ANI_GaugeCharge = 1;
const TWEEN_ID_ANI_Shake_END = 2;
const TWEEN_SHAKE_DELAY = 1020;
const TWEEN_ANI_REFRESH = 2000;
const TWEEN_ANI_CARD_ALPHA = 500;
const TWEEN_ID_CARD_ALPHA = 1000;
const TIMER_ID_HIT = 1;
const DIALOG_ASK_PRICE = 10111;
const COSTITEMNUM = 5;
const DWAFT_ID = 19673;
const DWAFT_dist = 400;
const DWAFT_offsetX = -8;
const DWAFT_offsetY = -3;
const DWAFT_ROTATION = 33000;
const titleString = "$title$";
const REQUIRE_SKILL_MAX = 10;
const SUCCESSION_ITEM_FILTER_ID = 3;
const TIMER_ID_AUTO_CRAFT_DELAY = 2;
const TIMER_AUTO_CRAFT_DELAY = 1020;
const AUTO_CRAFT_COUNT_MAX = 99999;
const NEED_ITEM_EXPAND_BTN_NAME = "expandBtn";
const NEED_ITEM_INVEN_SELECT_BTN_NAME = "invenSelectBtn";

enum StateCraft
{
	Normal,                         // 0
	Buy,                            // 1
	process,                        // 2
	confirm,                        // 3
	Result,                         // 4
	autoCraft                       // 5
};



struct PLShopItemDataStruct
{
	var int Index;
	var int nSlotNum;
	var int nItemClassID;
	var int nRemainItemAmount;
	var int nRemainSec;
	var int filterType;
	var int ProductRank;
	var int Category;
	var int CategorySub;
	var int probList[5];
	var int nStartTime;
	var array<PurchaseLimitCraftCostItemInfo> displayCostItems;
};

struct SuccessionInfo
{
	var int successionItemSId;
	var int materialItemSId;
	var array<PurchaseLimitCraftBuyItemInfo> successionFee;
	var array<PurchaseLimitCraftCostItemInfo> CostItems;
	var bool isResultScene;
	var int itemOption1;
	var int itemOption2;
	var int itemOption3;
	var int ProductID;
	var bool isKeepOption;
	var int ProductItemEnchant;
};

struct FindItemInfo
{
	var bool isWaitingResponse;
	var string findName;
	var int Category;
};


struct CraftCostSlotInfo
{
	var array<PurchaseLimitCraftCostItemInfo> costItemList;
	var PurchaseLimitCraftCostItemInfo selectedCostItem;
	var ItemInfo userSelectItemInfo;
};

struct CurrentCostItemInfo
{
	var int SlotNum;
	var array<CraftCostSlotInfo> costSlotInfos;
	var array<PurchaseLimitCraftCostItemInfo> displayCostItems;
};

struct CategorySubStruct
{
	var array<int> categorySubs;
};

var UIControlGroupButtonAssets tabGroupButton;
var UIControlGroupButtonAssets filterGroupButton;
var WindowHandle successionWndContainer;
var WindowHandle successionWnd;
var WindowHandle itemRegisterContainer;
var UIControlNeedItemList successionNeedItemScript;
var ItemWindowHandle successionCostItemWnd;
var TextBoxHandle successionPossibleTextBox;
var TextBoxHandle successionFeeDescTextBox;
var ButtonHandle buyWndConfirmBtn;
var WindowHandle CraftItemWnd;
var CheckBoxHandle passAnimationCheck;
var WindowHandle buy_Wnd;
var WindowHandle CraftResult01_CostItem_Wnd;
var WindowHandle CraftResult02_Gauge_Wnd;
var WindowHandle CraftResult03_Description_Wnd;
var WindowHandle disableWnd;
var CharacterViewportWindowHandle m_ObjectViewport;
var EffectViewportWndHandle EffectViewport00;
var TextureHandle CraftGaugeWndGauge_tex;
var TextBoxHandle Description_Text;
var TextBoxHandle CanNotFindText;
var EditBoxHandle ItemCount_EditBox;
var ButtonHandle Reset_Btn;
var ButtonHandle MultiSell_Up_Button;
var ButtonHandle MultiSell_Down_Button;
var ButtonHandle MultiSell_Input_Button;
var ButtonHandle Max_Btn;
var ButtonHandle Refresh_Button;
var ButtonHandle Craft_Btn;
var ButtonHandle AutoCraft_Btn;
var WindowHandle ShopDailyFails_ResultWnd;
var EditBoxHandle EditBoxFind;
var TextBoxHandle craftDescTextBox;
var TextBoxHandle autoCraftCntTitleTextBox;
var TextBoxHandle autoCraftCntTextBox;
var TextBoxHandle autoCraftInfoTextBox;
var TextBoxHandle limitTypeTextBox;
var TextBoxHandle limitNumTextBox;
var TextBoxHandle limitHelpTextBox;
var WindowHandle autoCraftInfoContainer;
var TextBoxHandle craftTimeTextBox;
var ButtonHandle autoCraftMinimizeBtn;
var TextureHandle craftTimeTex;
var TextureHandle limitTypeIconTex;
var array<TextureHandle> tabRibbonTexArray;
var int currentTabIndex;
var StateCraft CurrentState;
var array<PLShopItemDataStruct> pLShopItemDataList;
var array<int> selectedByCategoryList;
var array<int> selectedFilterTabList;
var array<int> currentFilterTypes;
var int aniLoop;
var Rect gaugeRect;
var Rect craftItemWndRect;
var SuccessionInfo _successionInfo;
var FindItemInfo _findItemInfo;
var AutoCraftInfo _autoCraftInfo;
var CurrentCostItemInfo _currentCostItemInfo;
var int invenCount;
var int invenMax;
var UIControlNeedItemListCraft needItemScript;
var UIControlNeedItemListCraft confirmNeedItemScript;
var array<CategorySubStruct> categorySubDatas;
var ItemWindowHandle LiveNeedSkill_ItemWnd;
var TextBoxHandle LiveNeedSkillTitle_Txt;
var L2UITween l2UITweenScript;
var L2Util util;
var ShopLcoinCraftNeedItemSelectPopup needItemSelectPopupScript;
//var delegate<OnSortCompareCategory> __OnSortCompareCategory__Delegate;
//var delegate<SortItemOptionDelegate> __SortItemOptionDelegate__Delegate;

function Initialize()
{
	local int i;
	local WindowHandle tabGroupButtonWindow, filterGroupButtonWindow;

	CraftItemWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd"));
	buy_Wnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Buy_Wnd"));
	CraftResult01_CostItem_Wnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult01_CostItem_Wnd"));
	CraftResult02_Gauge_Wnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult02_Gauge_Wnd"));
	CraftResult03_Description_Wnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult03_Description_Wnd"));
	Description_Text = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult03_Description_Wnd.Description_text"));
	disableWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd"));
	Craft_Btn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.Craft_Btn"));
	m_ObjectViewport = GetCharacterViewportWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.ObjectViewport"));
	m_ObjectViewport.SetUISound(true);
	CraftGaugeWndGauge_tex = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult02_Gauge_Wnd.CraftGaugeWndGauge_tex"));
	gaugeRect = CraftGaugeWndGauge_tex.GetRect();
	EditBoxFind = GetEditBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EditBoxFind"));
	MultiSell_Up_Button = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult01_CostItem_Wnd.MultiSell_Up_Button"));
	MultiSell_Down_Button = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult01_CostItem_Wnd.MultiSell_Down_Button"));
	MultiSell_Input_Button = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult01_CostItem_Wnd.MultiSell_Input_Button"));
	ItemCount_EditBox = GetEditBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult01_CostItem_Wnd.ItemCount_EditBox"));
	Reset_Btn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult01_CostItem_Wnd.Reset_Btn"));
	Max_Btn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult01_CostItem_Wnd.Max_Btn"));
	Refresh_Button = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".BtnListRefresh"));
	CanNotFindText = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CanNotFindText"));
	util = L2Util(GetScript("L2Util"));
	l2UITweenScript = L2UITween(GetScript("L2UITween"));
	ShopDailyFails_ResultWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ShopDailyFails_ResultWnd"));
	EffectViewport00 = GetEffectViewportWndHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EffectViewport00"));
	tabGroupButtonWindow = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".LcoinShopList_Tab"));
	tabGroupButton = Class'Interface.UIControlGroupButtonAssets'.static._InitScript(tabGroupButtonWindow);
	filterGroupButtonWindow = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".LcoinCraftList_Wnd.LcoinShopList_SubCategoryBtn"));
	filterGroupButton = Class'Interface.UIControlGroupButtonAssets'.static._InitScript(filterGroupButtonWindow);
	successionPossibleTextBox = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.BlessCraftTilte_txt"));
	successionFeeDescTextBox = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftResult01_CostItem_Wnd.CostItemDescrip_TextBox"));
	buyWndConfirmBtn = GetButtonHandle((buy_Wnd.m_WindowNameWithFullPath $ ".BuyWndCraft_Btn"));
	AutoCraft_Btn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.AutoCraft_Btn"));
	craftDescTextBox = GetTextBoxHandle((CraftResult01_CostItem_Wnd.m_WindowNameWithFullPath $ ".Description_text"));
	autoCraftInfoContainer = GetWindowHandle((CraftResult01_CostItem_Wnd.m_WindowNameWithFullPath $ ".AutoCraftDiscription_Wnd"));
	autoCraftCntTitleTextBox = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftProgress_Text"));
	autoCraftCntTextBox = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftProgressNum_Text"));
	autoCraftInfoTextBox = GetTextBoxHandle((autoCraftInfoContainer.m_WindowNameWithFullPath $ ".Description_text"));
	autoCraftMinimizeBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.Minimize_btn"));
	craftTimeTextBox = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftTime_Text"));
	craftTimeTex = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.IconTimed_texture"));
	limitTypeIconTex = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.RestrictTypeIcon_tex"));
	limitTypeTextBox = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.RestrictType_Text"));
	limitNumTextBox = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.RestrictTypeNum_Text"));
	limitHelpTextBox = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.ConditionHelp_Text"));
	tabGroupButton._SetStartInfo("L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Center_Unselected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Center_Selected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Center_Unselected_Over", true);
	tabGroupButton._GetGroupButtonsInstance().DelegateOnClickButton = OnTabGroupBtnClicked;
	filterGroupButton._SetStartInfo("", "", "", true);
	filterGroupButton._GetGroupButtonsInstance().DelegateOnClickButton = OnFilterGroupBtnClicked;
	tabRibbonTexArray.Length = 0;
	i = 0;
	while((i < 18))
	{
		getListCtrlByCategory(i).SetSelectedSelTooltip(false);
		getListCtrlByCategory(i).SetAppearTooltipAtMouseX(true);
		getListCtrlByCategory(i).SetTooltipType("ShopLcoinCraftTooltip");
		tabRibbonTexArray[i] = GetTextureHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".TabRibbon_tex") $ string(i)));
		i++;
	}
	categorySubDatas.Length = 18;
	MakeAllItemCategorySubList();
	InitSuccessionControl();
	InitNeedItemControl();
	InitNeedItemSelectPopupControl();
	passAnimationCheck = GetCheckBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CheckBox"));
	if(GetOptionBool("UI", "PurchaseLimitCraftAnimShow"))
	{
		passAnimationCheck.SetCheck(true);
	}
	LiveNeedSkill_ItemWnd = GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.LiveNeedSkill_ItemWnd"));
	LiveNeedSkillTitle_Txt = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.LiveNeedSkillTitle_Txt"));
	return;
}

function InitSuccessionControl()
{
	local WindowHandle needItemWnd;
	local RichListCtrlHandle needItemRichList;

	successionWndContainer = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Bless_Wnd"));
	successionWnd = GetWindowHandle((successionWndContainer.m_WindowNameWithFullPath $ ".BlessItemConfirmWnd"));
	itemRegisterContainer = GetWindowHandle((successionWnd.m_WindowNameWithFullPath $ ".ItemRegistrationWnd"));
	successionCostItemWnd = GetItemWindowHandle((itemRegisterContainer.m_WindowNameWithFullPath $ ".SucceedItemWnd"));
	needItemWnd = GetWindowHandle((successionWnd.m_WindowNameWithFullPath $ ".NeedItem_RichlistWnd"));
	needItemWnd.SetScript("UIControlNeedItemList");
	successionNeedItemScript = UIControlNeedItemList(needItemWnd.GetScript());
	needItemRichList = GetRichListCtrlHandle((successionWnd.m_WindowNameWithFullPath $ ".RichListCtrl"));
	successionNeedItemScript.SetFormType(NAMESIDE);
	successionNeedItemScript.SetRichListControler(needItemRichList);
	successionNeedItemScript.SetColumnCount(2);
	needItemRichList.SetTooltipType("UIControlNeedItemList");
	return;
}

function InitNeedItemControl()
{
	local WindowHandle needItemWnd, confirmItemWnd;

	needItemWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult01_CostItem_Wnd.NeedItem_RichlistWnd"));
	needItemWnd.SetScript("UIControlNeedItemListCraft");
	needItemScript = UIControlNeedItemListCraft(needItemWnd.GetScript());
	needItemScript.SetRichListControler(GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult01_CostItem_Wnd.NeedItem_RichlistWnd.RichListCtrl")));
	needItemScript.DelegateOnClickButton = OnNeedItemListButtonClicked;
	GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult01_CostItem_Wnd.NeedItem_RichlistWnd.RichListCtrl")).SetTooltipType("UIControlNeedItemList");
	needItemScript.SetColumnCount(2);
	confirmItemWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Buy_Wnd.BuyItemRichListCtrl"));
	confirmItemWnd.SetScript("UIControlNeedItemListCraft");
	confirmNeedItemScript = UIControlNeedItemListCraft(confirmItemWnd.GetScript());
	confirmNeedItemScript.SetRichListControler(GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Buy_Wnd.BuyItemRichListCtrl.RichListCtrl")));
	return;
}

function InitNeedItemSelectPopupControl()
{
	local WindowHandle needItemSelectWnd;

	needItemSelectWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.NeedItemSelectWnd"));
	needItemSelectWnd.SetScript("ShopLcoinCraftNeedItemSelectPopup");
	needItemSelectPopupScript = ShopLcoinCraftNeedItemSelectPopup(needItemSelectWnd.GetScript());
	needItemSelectPopupScript.InitWnd(needItemSelectWnd);
	needItemSelectPopupScript.DelegateOnNeedtemClick = OnNeedItemSelectPopupClicked;
	return;
}

function Rq_C_EX_PURCHASE_LIMIT_CRAFT_ITEM(int nSlotNum, int nItemAmount, optional int successionItemSId, optional int materialItemSId)
{
	local array<byte> stream;
	local array<int> serverIds;
	local UIPacket._C_EX_PURCHASE_LIMIT_CRAFT_ITEM packet;

	packet.nSlotNum = nSlotNum;
	packet.nItemAmount = nItemAmount;
	packet.nSuccessionItemSID = successionItemSId;
	packet.nMaterialItemSID = materialItemSId;
	serverIds = GetRequestServerIds();
	if((serverIds.Length == 5))
	{
		packet.nCost1SID = serverIds[0];
		packet.nCost2SID = serverIds[1];
		packet.nCost3SID = serverIds[2];
		packet.nCost4SID = serverIds[3];
		packet.nCost5SID = serverIds[4];
	}
	else
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13686));
		return;
	}
	Debug(((((((((("Rq_C_EX_PURCHASE_LIMIT_CRAFT_ITEM" @ string(packet.nCost1SID)) @ string(packet.nCost2SID)) @ string(packet.nCost3SID)) @ string(packet.nCost4SID)) @ string(packet.nCost5SID)) @ string(nSlotNum)) @ string(nItemAmount)) @ string(successionItemSId)) @ string(materialItemSId)));
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_PURCHASE_LIMIT_CRAFT_ITEM(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(930, stream);
	return;
}

function API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST()
{
	local array<byte> stream;
	local UIPacket._C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST packet;

	packet.cShopIndex = 4;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(563, stream);
	return;
}

function bool API_GetPurchaseLimitCraftData(int nProductID, out PurchaseLimitCraftUIData Data)
{
	return GetPurchaseLimitCraftData(4, nProductID, Data);
}

function RqPurchaseLimitShopItemBuy()
{
	if((((_successionInfo.isKeepOption == true) && (_successionInfo.successionItemSId > 0)) && (_successionInfo.materialItemSId > 0)))
	{
		Rq_C_EX_PURCHASE_LIMIT_CRAFT_ITEM(_currentCostItemInfo.SlotNum, int(ItemCount_EditBox.GetString()), _successionInfo.successionItemSId, _successionInfo.materialItemSId);
	}
	else
	{
		Rq_C_EX_PURCHASE_LIMIT_CRAFT_ITEM(_currentCostItemInfo.SlotNum, int(ItemCount_EditBox.GetString()));
	}
	return;
}

function RqPurchaseLimitShopItemBuyByAutoCraft()
{
	if(((_autoCraftInfo.useAutoCraft == true) && (int(_autoCraftInfo.uiState) == 1)))
	{
		Rq_C_EX_PURCHASE_LIMIT_CRAFT_ITEM(_autoCraftInfo.craftSlotNum, 1);
	}
	return;
}

event OnRegisterEvent()
{
	RegisterEvent((100000 + 1210));
	RegisterEvent(11064);
	RegisterEvent(1710);
	RegisterEvent(1720);
	RegisterEvent(180);
	RegisterEvent(9750);
	RegisterEvent(9570);
	RegisterEvent(2070);
	RegisterEvent(40);
	return;
}

event OnLoad()
{
	Initialize();
	SetClosingOnESC();
	currentTabIndex = 0;
	SetFilterGroupBtnByCategory(0);
	initSelectedItemIDArray();
	InitDefaultShakeRect();
	return;
}

function InitDefaultShakeRect()
{
	local Rect parentWndRect;

	parentWndRect = m_hOwnerWnd.GetRect();
	craftItemWndRect = CraftItemWnd.GetRect();
	craftItemWndRect.nX = (craftItemWndRect.nX - parentWndRect.nX);
	craftItemWndRect.nY = (craftItemWndRect.nY - parentWndRect.nY);
	return;
}

function SetForm()
{
	local int i;
	local array<PurchaseLimitCraftCategoryUIData> categoryDataArray;
	local PurchaseLimitCraftCategoryUIData categoryData;
	local Color TextColor;

	GetPurchaseLimitCraftCategoryDataAll(categoryDataArray, true);
	i = 0;
	while((i < tabRibbonTexArray.Length))
	{
		tabRibbonTexArray[i].HideWindow();
		i++;
	}
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
		if(((categoryData.RibbonTexture != "") && (i < tabRibbonTexArray.Length)))
		{
			tabRibbonTexArray[i].SetTexture(categoryData.RibbonTexture);
			tabGroupButton._GetGroupButtonsInstance()._setTextureLoc(i, tabRibbonTexArray[i], 0, 3);
			tabRibbonTexArray[i].ShowWindow();
		}
		i++;
	}
	tabGroupButton._GetGroupButtonsInstance()._setEnableAll();
	tabGroupButton._GetGroupButtonsInstance()._setTopOrder(0);
	return;
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

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case (100000 + 1210):
			if(((int(_autoCraftInfo.uiState) != 1) && (int(_autoCraftInfo.uiState) != 2)))
			{
				ClearAll();
			}
			HandleS_EX_PURCHASE_LIMIT_CRAFT_ITEM_LIST();
			break;
		case 11064:
			if(!IsMyShopIndex(param))
			{
				return;
			}
			HandleBuyResult(param);
			break;
		case 180:
			if(m_hOwnerWnd.IsShowWindow())
			{
				HandleUserInfo();
				SetCurrentCostItems(true);
			}
			break;
		case 9750:
			SetForm();
			initSelectedItemIDArray();
			SetDwaft();
			break;
		case 1710:
			HandleDialogOK(true);
			break;
		case 1720:
			HandleDialogOK(false);
			break;
		case 9570:
			ParseInt(param, "InvenCount", invenCount);
			HandleInvenCount();
			HandleInvenWeight();
			break;
		case 2070:
			ParseInt(param, "Inventory", invenMax);
			HandleInvenCount();
			break;
		case 40:
			ClearItemCategorySubList();
			MakeAllItemCategorySubList();
			break;
		default:
			break;
	}
	return;
}

event OnClickCheckBox(string strID)
{
	switch(strID)
	{
		case "CheckBox":
			SetOptionBool("UI", "PurchaseLimitCraftAnimShow", passAnimationCheck.IsChecked());
			break;
		default:
			break;
	}
	return;
}

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	if((EditBoxFind.IsFocused() && EditBoxFind.IsEnableWindow()))
	{
		if((int(nKey) == 13))
		{
			ClearAll();
			HandleItemNewList(-1);
		}
	}
	return false;
}

function HandleOnClickBuyWndCraft_Btn()
{
	if((_autoCraftInfo.useAutoCraft == true))
	{
		SetState(autoCraft);
		return;
	}
	if(passAnimationCheck.IsChecked())
	{
		AnimationCardToBack();
		SetState(confirm);
	}
	else
	{
		SetState(process);
	}
	return;
}

event OnClickButton(string Name)
{
	needItemSelectPopupScript.CloseWnd();
	switch(Name)
	{
		case "AutoCraft_Btn":
			_autoCraftInfo.useAutoCraft = true;
			_autoCraftInfo.Type = ACLimitedItem;
			HandleCraftBtn();
			break;
		case "Minimize_btn":
			SetAutoCraftMinimize(true);
			break;
		case "Craft_Btn":
			if((((int(_autoCraftInfo.uiState) != 1) && (GetSelectedProductData().AutomaticType == 2)) && (int(ItemCount_EditBox.GetString()) > 1)))
			{
				_autoCraftInfo.useAutoCraft = true;
				_autoCraftInfo.Type = ACFixedCount;
				_autoCraftInfo.currentCount = 0;
				_autoCraftInfo.maxCount = int(ItemCount_EditBox.GetString());
			}
			HandleCraftBtn();
			break;
		case "BtnClose":
		case "BuyWndCancel_Btn":
			SetState(Normal);
			break;
		case "BuyWndCraft_Btn":
			HandleOnClickBuyWndCraft_Btn();
			break;
		case "BtnClearEditBox":
			EditBoxFind.Clear();
		case "BtnFind":
			ClearAll();
			HandleItemNewList(-1);
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
			SetItemCountEditBox(INT64(1));
			break;
		case "FrameHelp_BTN":
			OnClickHelp();
			break;
		case "BtnListRefresh":
			OnRefresh_ButtonClick();
			break;
		case "Max_Btn":
			SetItemCountEditBox(GetCountCanBuyByIndex(GetCurrentSelectedIndex(), true, true));
			break;
		case "Fail_Button":
			if((int(_autoCraftInfo.uiState) == 2))
			{
				ShopDailyFails_ResultWnd.HideWindow();
			}
			else
			{
				SetState(Normal);
			}
			break;
		case "Registration_Btn":
			OnSuccessionRegistBtnClicked();
			break;
		case "OK_Btn":
			OnSuccecssionConfirmBtnClicked();
			break;
		case "Cancel_Btn":
			OnSuccecssionCancelBtnClicked();
			break;
		default:
			break;
	}
	return;
}

event OnClickListCtrlRecord(string ListCtrlID)
{
	local ItemInfo Info;
	local RichListCtrlRowData Record;
	local PLShopItemDataStruct ItemData;
	local PurchaseLimitCraftUIData productData;
	local int selectedIdx;

	Record = GetSelectedRecord();
	ItemData = pLShopItemDataList[int(Record.nReserved1)];
	selectedIdx = getListCtrlByCategory(currentTabIndex).GetSelectedIndex();
	Info = GetItemInfoByClassID(ItemData.nItemClassID);
	API_GetPurchaseLimitCraftData(ItemData.nSlotNum, productData);
	_successionInfo.isKeepOption = productData.KeepOption;
	_successionInfo.successionFee = productData.KeepOptionFee;
	_successionInfo.ProductItemEnchant = productData.ProductItemEnchant;
	_successionInfo.ProductID = ItemData.nSlotNum;
	_successionInfo.CostItems = ItemData.displayCostItems;
	if((productData.KeepOption == true))
	{
		successionPossibleTextBox.ShowWindow();
		if((productData.KeepOptionFee.Length > 0))
		{
			successionFeeDescTextBox.ShowWindow();
		}
		else
		{
			successionFeeDescTextBox.HideWindow();
		}
	}
	else
	{
		successionPossibleTextBox.HideWindow();
		successionFeeDescTextBox.HideWindow();
	}
	if((Info.Id.ClassID > 0))
	{
		selectedByCategoryList[currentTabIndex] = ItemData.Index;
		CanNotFindText.HideWindow();
		CraftItemWnd.ShowWindow();
		SetBuyItems();
		SetCurrentLimitType();
		SetCurrentLimitTimeType();
		SetCurrentCostItemInfo();
		SetCurrentCostItems();
		SetCurrentNeedSkills();
		SetItemCountEditBox(INT64(1));
		UpdateAutoCraftBtn();
	}
	needItemSelectPopupScript.CloseWnd();
	return;
}

event OnChangeEditBox(string strID)
{
	switch(strID)
	{
		case "ItemCount_EditBox":
			HandleEditBox();
			SetItemCountEditBox(INT64(int(ItemCount_EditBox.GetString())));
			break;
		default:
			break;
	}
	return;
}

event OnShow()
{
	m_hOwnerWnd.SetVisibility(true);
	if(GetWindowHandle("PrivateShopWndReport").IsShowWindow())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4217));
		m_hOwnerWnd.HideWindow();
		return;
	}
	ResetSuccessionInfo();
	HideSuccessionDialog();
	HideNeedItemSelectPopup();
	HandleNotSelected();
	getInstanceL2Util().ItemRelationWindowHide(m_hOwnerWnd.m_WindowNameWithFullPath);
	m_hOwnerWnd.SetFocus();
	API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST();
	SetState(Normal);
	SetDwaft();
	SideBar(GetScript("SideBar")).ToggleByWindowName(m_hOwnerWnd.m_WindowNameWithFullPath, true);
	return;
}

event OnHide()
{
	if(DialogIsMine())
	{
		DialogHide();
	}
	AnimationStop();
	ResetFindItemInfo();
	ResetAutoCraftInfo();
	SideBar(GetScript("SideBar")).ToggleByWindowName(m_hOwnerWnd.m_WindowNameWithFullPath, false);
	successionNeedItemScript.CleariObjects();
	needItemScript.CleariObjects();
	confirmNeedItemScript.CleariObjects();
	m_hOwnerWnd.SetVisibility(true);
	CloseAutoCraftMinimizeWnd();
	return;
}

event OnCallUCFunction(string funcName, string param)
{
	switch(funcName)
	{
		case "tweenEnd":
			AnimationComplete(int(param));
			break;
		case "shakeEnd":
			ShakeComplete(int(param));
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
			m_hOwnerWnd.KillTimer(99902);
			break;
		case 99903:
			getListCtrlByCategory(currentTabIndex).SetFocus();
			HandleSelectOnChangeListCondition();
			m_hOwnerWnd.KillTimer(99903);
			break;
		case 1:
			AnimationNext();
			break;
		case 2:
			KillAutoCraftTimer();
			CheckAndRequestAutoCraft();
			break;
		default:
			break;
	}
	return;
}

function HandleDialogOK(bool bOK)
{
	if(!DialogIsMine())
	{
		return;
	}
	switch(DialogGetID())
	{
		case 10111:
			disableWnd.HideWindow();
			if(bOK)
			{
				SetItemCountEditBox(INT64(int(DialogGetString())));
			}
			break;
		default:
			break;
	}
	return;
}

function HandleCraftBtn()
{
	local array<int> serverIds;

	serverIds = GetRequestServerIds();
	Debug(((((((((("REQUEST SID 0:" @ string(serverIds[0])) @ "/ 1:") @ string(serverIds[1])) @ "/ 2:") @ string(serverIds[2])) @ "/ 3:") @ string(serverIds[3])) @ "/ 4:") @ string(serverIds[4])));
	if((_autoCraftInfo.useAutoCraft == true))
	{
		if((int(_autoCraftInfo.uiState) == 1))
		{
			if((_autoCraftInfo.currentCount == 0))
			{
				SetState(Normal);
				SetControlerBtns();
			}
			else
			{
				ResultAutoCraft();
			}
			return;
		}
		else if((int(_autoCraftInfo.uiState) == 2))
		{
			SetState(Normal);
			API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST();
			SetControlerBtns();
			return;
		}
	}
	switch(CurrentState)
	{
		case Normal:
			SetState(Buy);
			break;
		case Buy:
			break;
		case process:
			SetState(Normal);
			break;
		case confirm:
			Craft_Btn.DisableWindow();
			AutoCraft_Btn.DisableWindow();
			if((getInstanceUIData().GetIsClassicServer() && (passAnimationCheck.IsChecked() == true)))
			{
				RqPurchaseLimitShopItemBuy();
			}
			else
			{
				MakeResultShakeObject();
			}
			break;
		case Result:
			API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST();
			SetState(Normal);
			break;
		default:
			break;
	}
	return;
}

function OnRefresh_ButtonClick()
{
	API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST();
	m_hOwnerWnd.SetTimer(99902, 3000);
	Refresh_Button.DisableWindow();
	return;
}

function OnPriceEditBtnHandler()
{
	disableWnd.ShowWindow();
	disableWnd.SetFocus();
	DialogSetID(10111);
	DialogSetEditBoxMaxLength(6);
	DialogSetCancelD(10111);
	DialogSetParamInt64(GetCountCanBuyByIndex(GetCurrentSelectedIndex(), true, true));
	DialogSetEditType("number");
	DialogSetDefaultOK();
	DialogShow(DialogModalType_Modalless, DialogType_NumberPad, GetSystemMessage(4362));
	return;
}

function OnMultiSell_Up_ButtonClick()
{
	SetItemCountEditBox(INT64((int(ItemCount_EditBox.GetString()) + 1)));
	return;
}

function OnMultiSell_Down_ButtonClick()
{
	SetItemCountEditBox(INT64((int(ItemCount_EditBox.GetString()) - 1)));
	return;
}

function OnClickHelp()
{
	Class'Interface.HelpWnd'.static.ShowHelp(67);
	return;
}

function ClearAll()
{
	local int i;

	i = 0;
	while((i < 18))
	{
		getListCtrlByCategory(i).DeleteAllItem();
		i++;
	}
	return;
}

function HandleS_EX_PURCHASE_LIMIT_CRAFT_ITEM_LIST()
{
	local UIPacket._S_EX_PURCHASE_LIMIT_CRAFT_ITEM_LIST packet;
	local int i, j, tempIndex;
	local PLShopItemDataStruct pLShopItemData, tempItemData;
	local PurchaseLimitCraftUIData productData;
	local L2Util util;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_PURCHASE_LIMIT_CRAFT_ITEM_LIST(packet))
	{
		return;
	}
	if(((int(_autoCraftInfo.uiState) == 1) || (int(_autoCraftInfo.uiState) == 2)))
	{
		i = 0;
		while((i < packet.vItemList.Length))
		{
			if((packet.vItemList[i].nSlotNum == _autoCraftInfo.craftSlotNum))
			{
				tempIndex = GetCurrentSelectedIndex();
				if((tempIndex < pLShopItemDataList.Length))
				{
					tempItemData = pLShopItemDataList[tempIndex];
					if((tempItemData.nSlotNum == _autoCraftInfo.craftSlotNum))
					{
						tempItemData.nRemainItemAmount = packet.vItemList[i].nRemainItemAmount;
						tempItemData.nRemainSec = packet.vItemList[i].nRemainSec;
						tempItemData.nStartTime = packet.vItemList[i].nStartTime;
						pLShopItemDataList[tempIndex] = tempItemData;
						SetCurrentLimitType();
						SetCurrentLimitTimeType();
					}
				}
				return;
			}
			i++;
		}
		return;
	}
	if((packet.cPage == 1))
	{
		pLShopItemDataList.Length = 0;
	}
	util = getInstanceL2Util();
	i = 0;
	while((i < packet.vItemList.Length))
	{
		API_GetPurchaseLimitCraftData(packet.vItemList[i].nSlotNum, productData);
		pLShopItemData.nSlotNum = packet.vItemList[i].nSlotNum;
		pLShopItemData.nItemClassID = packet.vItemList[i].nItemClassID;
		pLShopItemData.Category = productData.Category;
		pLShopItemData.CategorySub = productData.CategorySub;
		j = 0;
		while((j < 5))
		{
			pLShopItemData.probList[j] = packet.vItemList[i].probList[j];
			j++;
		}
		pLShopItemData.nRemainItemAmount = packet.vItemList[i].nRemainItemAmount;
		pLShopItemData.nRemainSec = packet.vItemList[i].nRemainSec;
		pLShopItemData.nStartTime = packet.vItemList[i].nStartTime;
		pLShopItemDataList[pLShopItemDataList.Length] = pLShopItemData;
		i++;
	}
	if((packet.cPage < packet.cMaxPage))
	{
		return;
	}
	// pLShopItemDataList.Sort(OnSortCompareCategory);   // array.Sort() unsupported by this compiler
	i = 0;
	while((i < pLShopItemDataList.Length))
	{
		pLShopItemDataList[i].Index = i;
		i++;
	}
	MakeItemCategorySubList();
	HandleItemNewList(-1);
	SetFilterGroupBtnByCategory(currentTabIndex);
	CheckFindItem();
	return;
}

function PurchaseLimitCraftCostItemInfo GetDisplayCostItem(array<PurchaseLimitCraftCostItemInfo> CostItems)
{
	local int i;
	local PurchaseLimitCraftCostItemInfo tmpCostInfo;
	local int ItemClassID, Enchant;
	local bool IsBlessedItem;

	if((CostItems.Length == 0))
	{
		return tmpCostInfo;
	}
	if((CostItems.Length == 1))
	{
		tmpCostInfo = CostItems[0];
		return tmpCostInfo;
	}
	i = 0;
	while((i < CostItems.Length))
	{
		tmpCostInfo = CostItems[i];
		ItemClassID = tmpCostInfo.ItemClassID;
		Enchant = int(tmpCostInfo.Enchant);
		IsBlessedItem = tmpCostInfo.IsBlessedItem;
		if((getInstanceL2Util().GetCraftInventoryHaveNum(ItemClassID, Enchant, IsBlessedItem) >= tmpCostInfo.Count))
		{
			return tmpCostInfo;
		}
		i++;
	}
	return CostItems[0];
}

function HandleItemNewList(int Category, optional int startIndex)
{
	local int i;
	local RichListCtrlRowData Record;
	local PurchaseLimitCraftUIData productData;
	local bool canBuy;
	local array<bool> useCategories;
	local int lastCategorySub, lastCategory;
	local PLShopItemDataStruct shopItemData;
	local array<PurchaseLimitCraftCostItemInfo> tmpCostItemList, displayCostItemList;

	useCategories.Length = 18;
	lastCategory = -1;
	i = startIndex;
	while((i < pLShopItemDataList.Length))
	{
		shopItemData = pLShopItemDataList[i];
		API_GetPurchaseLimitCraftData(shopItemData.nSlotNum, productData);
		if(((Category != -1) && (Category != productData.Category)))
		{
			i++;
			continue;
		}
		if((lastCategory != productData.Category))
		{
			lastCategory = productData.Category;
			lastCategorySub = -1;
		}
		useCategories[productData.Category] = true;
		if((shopItemData.displayCostItems.Length == 0))
		{
			tmpCostItemList = productData.CostItemSlot1;
			displayCostItemList[0] = GetDisplayCostItem(tmpCostItemList);
			tmpCostItemList = productData.CostItemSlot2;
			displayCostItemList[1] = GetDisplayCostItem(tmpCostItemList);
			tmpCostItemList = productData.CostItemSlot3;
			displayCostItemList[2] = GetDisplayCostItem(tmpCostItemList);
			tmpCostItemList = productData.CostItemSlot4;
			displayCostItemList[3] = GetDisplayCostItem(tmpCostItemList);
			tmpCostItemList = productData.CostItemSlot5;
			displayCostItemList[4] = GetDisplayCostItem(tmpCostItemList);
			shopItemData.displayCostItems = displayCostItemList;
		}
		shopItemData = ArrangingPeeItem(shopItemData);
		pLShopItemDataList[i] = shopItemData;
		canBuy = (GetCountCanBuyByIndex(shopItemData.Index) > INT64(0));
		if(((SelectedCategorySub(productData.Category) != 0) && (SelectedCategorySub(productData.Category) != productData.CategorySub)))
		{
			i++;
			continue;
		}
		if((lastCategorySub != productData.CategorySub))
		{
			lastCategorySub = productData.CategorySub;
			getListCtrlByCategory(productData.Category).InsertRecord(MakeTitleRecord(i, productData.CategorySub));
		}
		if((FindMatchString(productData.ProductName, EditBoxFind.GetString()) == -1))
		{
			i++;
			continue;
		}
		Record = makeRecord(i, canBuy);
		getListCtrlByCategory(productData.Category).InsertRecord(Record);
		i++;
	}
	SetEmptyCategories(useCategories);
	HandleSelectOnChangeListCondition();
	return;
}

function SetEmptyCategories(array<bool> useCategories)
{
	local int i;

	i = 0;
	while((i < useCategories.Length))
	{
		if(useCategories[i])
		{
		}
		i++;
	}
	return;
}

function HandleSelectOnChangeListCondition()
{
	local int currentSelectedIndex, listIndex, currentSlotNum;

	if(HandleFindResult())
	{
		return;
	}
	CanNotFindText.HideWindow();
	CraftItemWnd.ShowWindow();
	currentSelectedIndex = GetCurrentSelectedIndex();
	if((currentSelectedIndex != -1))
	{
		currentSlotNum = pLShopItemDataList[currentSelectedIndex].nSlotNum;
		if((currentSlotNum != -1))
		{
			listIndex = GetCurrentListIndexBySlotNum(currentSlotNum);
		}
		if((listIndex != -1))
		{
			getListCtrlByCategory(currentTabIndex).SetSelectedIndex(listIndex, true);
			OnClickListCtrlRecord("");
			return;
		}
	}
	HandleNotSelected();
	return;
}

function string MakeTooltipString(PLShopItemDataStruct ItemData, PurchaseLimitCraftUIData productData)
{
	local int i;
	local string param;
	local int Count;

	param = "";
	i = 0;
	while((i < ItemData.displayCostItems.Length))
	{
		if((ItemData.displayCostItems[i].ItemClassID > 0))
		{
			ParamAdd(param, ("costItemID" $ string(i)), string(ItemData.displayCostItems[i].ItemClassID));
			ParamAdd(param, ("costItemAmout" $ string(i)), string(ItemData.displayCostItems[i].Count));
			ParamAdd(param, ("costItemEnchant" $ string(i)), string(ItemData.displayCostItems[i].Enchant));
			ParamAdd(param, ("costItemBlessed" $ string(i)), string(int(ItemData.displayCostItems[i].IsBlessedItem)));
			Count++;
		}
		i++;
	}
	ParamAdd(param, "countCost", string(Count));
	ParamAdd(param, "itemCount", string(productData.BuyItems.Length));
	i = 0;
	while((i < productData.BuyItems.Length))
	{
		ParamAdd(param, ("buyItem" $ string(i)), string(productData.BuyItems[i].ItemClassID));
		ParamAdd(param, ("buyItemCount" $ string(i)), string(productData.BuyItems[i].Count));
		ParamAdd(param, ("buyItemEnchant" $ string(i)), string(productData.BuyItems[i].Enchant));
		i++;
	}
	return param;
}

function RichListCtrlRowData MakeTitleRecord(int startIndex, int CategorySub)
{
	local RichListCtrlRowData Record;

	Record.cellDataList.Length = 1;
	AddRichListCtrlString(Record.cellDataList[0].drawitems, GetNpcString(CategorySub), getInstanceL2Util().Yellow, false, 10, 0, "hs11");
	Record.szReserved = "$title$";
	Record.nReserved1 = INT64(startIndex);
	Record.sOverlayTex = "L2UI_EPIC.LCoinShopWnd.CraftListInHeader";
	Record.OverlayTexU = 256;
	Record.OverlayTexV = 50;
	return Record;
}

function RichListCtrlRowData makeRecord(int Index, bool canBuy)
{
	local RichListCtrlRowData Record;
	local string fullNameString;
	local ItemInfo Info;
	local UserInfo PlayerInfo;
	local PLShopItemDataStruct ItemData;
	local PurchaseLimitCraftUIData productData;
	local Color tmpTextColor;
	local int textWidth, textHeight;

	ItemData = pLShopItemDataList[Index];
	API_GetPurchaseLimitCraftData(ItemData.nSlotNum, productData);
	GetPlayerInfo(PlayerInfo);
	Info = GetItemInfoByClassID(ItemData.nItemClassID);
	fullNameString = GetItemNameAll(Info);
	Record.szReserved = MakeTooltipString(ItemData, productData);
	Record.cellDataList.Length = 1;
	Record.nReserved1 = INT64(Index);
	Record.cellDataList[0].nReserved1 = ItemData.nItemClassID;
	Record.cellDataList[0].nReserved3 = ItemData.nSlotNum;
	Record.cellDataList[0].szData = fullNameString;
	if((int(productData.MarkType) == 0))
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, Info.IconName, 32, 32, 10, 0);
	}
	else
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, Info.IconName, 32, 32, 10, 26);
	}
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
	Class'Interface.L2Util'.static.GetEllipsisString(productData.ProductName, 190);
	GetTextSizeDefault(productData.ProductName, textWidth, textHeight);
	if((int(productData.MarkType) == 0))
	{
		AddRichListCtrlString(Record.cellDataList[0].drawitems, productData.ProductName, tmpTextColor, false, 5, 10);
	}
	else
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, GetMarkIconByType(productData.MarkType), 64, 64, -42, -9);
		AddRichListCtrlString(Record.cellDataList[0].drawitems, productData.ProductName, tmpTextColor, false, -17, 16);
	}
	if(((isLimitBuyType(productData) == true) && (ItemData.nRemainItemAmount <= 0)))
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, "L2UI_EPIC.LCoinShopWnd.LCoinShopCraft_SoldoutIcon", 100, 50, (-textWidth + 30), -textHeight, 128, 64);
	}
	return Record;
}

function HandleInvenCount()
{
	if(m_hOwnerWnd.IsShowWindow())
	{
		SetCurrentCostItems(true);
		SetCurrentNeedSkills();
		OnChangeEditBox("ItemCount_EditBox");
	}
	return;
}

function HandleInvenWeight()
{
	if(!GetCanInventoryWeight())
	{
		if((int(CurrentState) == 0))
		{
			SetBuyButtonTooltip();
			Craft_Btn.DisableWindow();
			AutoCraft_Btn.DisableWindow();
		}
	}
	return;
}

function HandleUserInfo()
{
	if(getInstanceUIData().IsLevelUP())
	{
		m_hOwnerWnd.HideWindow();
	}
	return;
}

function bool CanBuyByRecord(RichListCtrlRowData Record)
{
	return (GetCountCanBuy(Record) > INT64(0));
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
	return Record.cellDataList[0].nReserved3;
}

function INT64 GetCountCanBuy(RichListCtrlRowData Record)
{
	return GetCountCanBuyByIndex(int(Record.nReserved1));
}

function bool GetCanInventoryWeight()
{
	local UserInfo uInfo;
	local float Per;

	if(GetPlayerInfo(uInfo))
	{
		Per = (float(uInfo.nCarringWeight) / float(uInfo.nCarryWeight));
		return (Per <= 0.8000000);
	}
	return false;
}

function int GetCanBUyByInvenEmpty(int Index)
{
	local PurchaseLimitCraftUIData productData;

	API_GetPurchaseLimitCraftData(pLShopItemDataList[Index].nSlotNum, productData);
	if(GetIsStackableItemByIndex(Index))
	{
		if((GetInventoryEmpty() >= productData.BuyItems.Length))
		{
			if((productData.AutomaticType == 2))
			{
				return 99999;
			}
			else
			{
				return productData.MaxBuyCount;
			}
		}
	}
	return GetInventoryEmpty();
}

function int GetInventoryEmpty()
{
	return (invenMax - invenCount);
}

function bool GetIsStackableItemByIndex(int Index)
{
	local int i;
	local ItemInfo Info;
	local PurchaseLimitCraftUIData productData;

	API_GetPurchaseLimitCraftData(pLShopItemDataList[Index].nSlotNum, productData);
	i = 0;
	while((i < productData.BuyItems.Length))
	{
		Info = GetItemInfoByClassID(productData.BuyItems[i].ItemClassID);
		if(!IsStackableItem(Info.ConsumeType))
		{
			return false;
		}
		i++;
	}
	return true;
}

function INT64 GetCountCanBuyByIndex(int Index, optional bool chkInventory, optional bool isCurrentItem)
{
	local INT64 Count;
	local PurchaseLimitCraftUIData productData;
	local PLShopItemDataStruct shopItemData;

	shopItemData = pLShopItemDataList[Index];
	API_GetPurchaseLimitCraftData(shopItemData.nSlotNum, productData);
	if(!CheckLevelCondition(Index))
	{
		return INT64(0);
	}
	if(!CheckNeedSkill(Index))
	{
		return INT64(0);
	}
	if((productData.AutomaticType == 2))
	{
		Count = INT64(99999);
	}
	else
	{
		Count = INT64(productData.MaxBuyCount);
	}
	if(chkInventory)
	{
		Count = Min64(Count, INT64(GetCanBUyByInvenEmpty(Index)));
	}
	Count = Min64(INT64(GetItemLimitAmount(Index)), Count);
	if(isCurrentItem)
	{
		Count = Min64(GetMinAmoutByCostItemNum(shopItemData.nSlotNum, _currentCostItemInfo.displayCostItems), Count);
	}
	else
	{
		Count = Min64(GetMinAmoutByCostItemNum(shopItemData.nSlotNum, shopItemData.displayCostItems), Count);
	}
	return Count;
}

function bool CheckLevelCondition(int Index)
{
	local UserInfo Info;
	local PLShopItemDataStruct ItemData;
	local PurchaseLimitCraftUIData productData;

	ItemData = pLShopItemDataList[Index];
	API_GetPurchaseLimitCraftData(ItemData.nSlotNum, productData);
	if(!GetPlayerInfo(Info))
	{
		return false;
	}
	if(((Info.nLevel > productData.LevelMax) || (Info.nLevel < productData.LevelMin)))
	{
		return false;
	}
	return true;
}

function int GetItemLimitAmount(int Index)
{
	local PurchaseLimitCraftUIData productData;

	API_GetPurchaseLimitCraftData(pLShopItemDataList[Index].nSlotNum, productData);
	if(((productData.LimitCountMax == 0) && (isLimitBuyType(productData) == false)))
	{
		if((productData.AutomaticType == 2))
		{
			return 99999;
		}
		else
		{
			return productData.MaxBuyCount;
		}
	}
	else
	{
		return pLShopItemDataList[Index].nRemainItemAmount;
	}
}

function INT64 GetMinAmoutByCostItemNum(int SlotNum, array<PurchaseLimitCraftCostItemInfo> CostItems)
{
	local INT64 Count;
	local int i;
	local PurchaseLimitCraftUIData productData;
	local INT64 haveItem;

	API_GetPurchaseLimitCraftData(SlotNum, productData);
	if((productData.AutomaticType == 2))
	{
		Count = INT64(99999);
	}
	else
	{
		Count = INT64(productData.MaxBuyCount);
	}
	i = 0;
	while((i < CostItems.Length))
	{
		if((CostItems[i].ItemClassID != 0))
		{
			if((CostItems[i].ItemClassID == -800))
			{
				haveItem = getInstanceUIData().GetCurrentVitalityPoint();
			}
			else
			{
				haveItem = GetHaveItem(i, CostItems, productData.KeepOption);
			}
			Count = Min64(Count, (haveItem / GetCostItemAmount(i, CostItems)));
		}
		i++;
	}
	return Count;
}

function int GetCurrMinLv()
{
	local PLShopItemDataStruct ItemData;
	local PurchaseLimitCraftUIData productData;

	ItemData = pLShopItemDataList[GetCurrentSelectedIndex()];
	API_GetPurchaseLimitCraftData(ItemData.nSlotNum, productData);
	return productData.LevelMin;
}

function int GetCurrMaxLv()
{
	local PLShopItemDataStruct ItemData;
	local PurchaseLimitCraftUIData productData;

	ItemData = pLShopItemDataList[GetCurrentSelectedIndex()];
	API_GetPurchaseLimitCraftData(ItemData.nSlotNum, productData);
	return productData.LevelMax;
}

function int GetCurrentMaxItemNum()
{
	return GetSelectedProductData().MaxBuyCount;
}

function HandleOnClickFilterButton(int Index)
{
	if((selectedFilterTabList[currentTabIndex] == Index))
	{
		return;
	}
	selectedFilterTabList[currentTabIndex] = Index;
	getListCtrlByCategory(currentTabIndex).DeleteAllItem();
	HandleItemNewList(currentTabIndex);
	return;
}

event OnTabGroupBtnClicked(string parentWndName, string strName, int Index)
{
	currentTabIndex = tabGroupButton._GetGroupButtonsInstance()._getButtonValue(Index);
	SetProductListVisible(currentTabIndex);
	SetFilterGroupBtnByCategory(currentTabIndex);
	m_hOwnerWnd.KillTimer(99903);
	m_hOwnerWnd.SetTimer(99903, 100);
	return;
}

event OnFilterGroupBtnClicked(string parentWndName, string strName, int Index)
{
	HandleOnClickFilterButton(Index);
	m_hOwnerWnd.KillTimer(99903);
	m_hOwnerWnd.SetTimer(99903, 100);
	return;
}

function SetProductListVisible(int Index)
{
	local int i;
	local RichListCtrlHandle ListCtrl;

	i = 0;
	while((i < 18))
	{
		ListCtrl = getListCtrlByCategory(i);
		if((i == Index))
		{
			ListCtrl.ShowWindow();
			i++;
			continue;
		}
		ListCtrl.HideWindow();
		i++;
	}
	return;
}

function SetBuyItems()
{
	local int i;
	local ItemInfo Info;
	local PLShopItemDataStruct shopItemData;
	local PurchaseLimitCraftUIData productData;

	shopItemData = GetSelectedItemData();
	Info = GetItemInfoByClassID(shopItemData.nItemClassID);
	productData = GetSelectedProductData();
	i = 0;
	while((i < productData.BuyItems.Length))
	{
		Info = GetItemInfoByClassID(productData.BuyItems[i].ItemClassID);
		Info.RefineryOp1 = 0;
		Info.RefineryOp2 = 0;
		Info.RefineryOp3 = 0;
		Info.Enchanted = productData.BuyItems[i].Enchant;
		GetTexturehandleCraftCardBack(i).HideWindow();
		GetTexturehandleCraftSlot(i).ShowWindow();
		GetTexturehandleCraftSlot(i).Clear();
		GetTexturehandleCraftSlot(i).AddItem(Info);
		GetTexturehandleCraftCardBG(i).SetTexture(GetGradeTextureByRank(productData.BuyItems[i].ProductRank));
		GetTextBoxhandleCraftItemNum(i).SetText((GetSystemString(2503) @ MakeCostString(string(productData.BuyItems[i].Count))));
		if((i < 5))
		{
			GetCraftProbabilityTextBox(i).SetText(Class'Interface.L2Util'.static.Inst().MakeDecimalPointString(string(shopItemData.probList[i]), 5, true, true));
		}
		GetTexturehandleCraftCardNum(i).HideWindow();
		GetAutoCraftCardDisableTexture(i).HideWindow();
		GetCard(i).ShowWindow();
		if(productData.BuyItems[i].IsLimitBuy)
		{
			GetTextureHandleLimitIcon(i).SetTexture(GetItemMarkIconByLimitType(productData.LimitType));
			GetTextureHandleLimitIcon(i).ShowWindow();
			i++;
			continue;
		}
		GetTextureHandleLimitIcon(i).HideWindow();
		i++;
	}
	AlignCards(productData.BuyItems.Length);
	i = i;
	while((i < 5))
	{
		GetTexturehandleCraftCardBack(i).ShowWindow();
		GetTexturehandleCraftSlot(i).HideWindow();
		GetTexturehandleCraftCardBack(i).SetAlpha(255);
		GetTexturehandleCraftCardNum(i).HideWindow();
		GetAutoCraftCardDisableTexture(i).HideWindow();
		GetCard(i).HideWindow();
		i++;
	}
	if((productData.AutomaticType != 0))
	{
		Class'Interface.ShopLcoinCraftMinimizeWnd'.static.Inst().SetItemSlots(productData);
	}
	return;
}

function UpdateSuccessionResultBuyItems()
{
	local int i;
	local ItemInfo Info;
	local PurchaseLimitCraftUIData productData;

	Info = GetItemInfoCurrentSelected();
	productData = GetSelectedProductData();
	i = 0;
	while((i < productData.BuyItems.Length))
	{
		Info = GetItemInfoByClassID(productData.BuyItems[i].ItemClassID);
		Info.RefineryOp1 = 0;
		Info.RefineryOp2 = 0;
		Info.RefineryOp3 = 0;
		Info.Enchanted = productData.BuyItems[i].Enchant;
		if((_successionInfo.isKeepOption == true))
		{
			Info.RefineryOp1 = _successionInfo.itemOption1;
			Info.RefineryOp2 = _successionInfo.itemOption2;
			Info.RefineryOp3 = _successionInfo.itemOption3;
		}
		GetTexturehandleCraftSlot(i).Clear();
		GetTexturehandleCraftSlot(i).AddItem(Info);
		i++;
	}
	return;
}

function AlignCards(int Num)
{
	local int i, StartX, gab, gabW;

	gab = 138;
	gabW = (((5 - Num) * 138) / 2);
	StartX = (30 + gabW);
	i = 0;
	while((i < Num))
	{
		GetCard(i).MoveC((StartX + (gab * i)), 215);
		i++;
	}
	return;
}

function HandleBuyResult(string param)
{
	local int Result;

	ParseInt(param, "Result", Result);
	if(_autoCraftInfo.useAutoCraft)
	{
		NtAutoCraftResult(param);
		return;
	}
	switch(Result)
	{
		case 0:
			SetSuccessWnd(param);
			break;
		case 7:
		case 8:
			API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST();
			SetFailWnd(3646);
			break;
		case 6:
		case 1:
		case 2:
		case 3:
		case 4:
		case 5:
		case 11:
		default:
			API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST();
			SetFailWnd(4334);
			break;
	}
	return;
}

function SetSuccessWnd(string param)
{
	local int i, ItemCount, itemIndex, ItemAmount, itemRankMax;
	local PurchaseLimitCraftUIData productData;

	ParseInt(param, "ItemCount", ItemCount);
	productData = GetSelectedProductData();
	i = 0;
	while((i < ItemCount))
	{
		ParseInt(param, ("itemIndex_" $ string(i)), itemIndex);
		itemRankMax = Max(itemRankMax, productData.BuyItems[itemIndex].ProductRank);
		ParseInt(param, ("ItemAmount_" $ string(i)), ItemAmount);
		GetTexturehandleCraftCardNum(itemIndex).ShowWindow();
		GetTexturehandleCraftCardNum(itemIndex).SetText(("x" $ string(ItemAmount)));
		AnimationCardToFront(itemIndex);
		i++;
	}
	switch(itemRankMax)
	{
		case 0:
			EffectViewport00.SetCameraDistance(500.0000000);
			playEffectViewPort("LineageEffect2.ui_upgrade_succ");
			PlaySound("ItemSound3.enchant_success");
			break;
		case 1:
			EffectViewport00.SetCameraDistance(360.0000000);
			playEffectViewPort("LineageEffect2.ui_upgrade_succ");
			PlaySound("ItemSound3.enchant_success");
			break;
		case 2:
			EffectViewport00.SetCameraDistance(600.0000000);
			playEffectViewPort("LineageEffect.d_firework_b");
			PlaySound("ItemSound2.C3_Firework_explosion");
			break;
		case 3:
		case 4:
			EffectViewport00.SetCameraDistance(730.0000000);
			playEffectViewPort("LineageEffect_br.br_e_firebox_fire_b");
			PlaySound("SkillSound14.d_firework_a");
			break;
		default:
			break;
	}
	SetState(Result);
	return;
}

function SetFailWnd(int msgIndex, optional bool isSystemStr)
{
	local TextBoxHandle Discription_TextBox;

	Discription_TextBox = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ShopDailyFails_ResultWnd.Discription_TextBox"));
	if((isSystemStr == true))
	{
		Discription_TextBox.SetText(GetSystemString(msgIndex));
	}
	else
	{
		Discription_TextBox.SetText(GetSystemMessage(msgIndex));
	}
	ShopDailyFails_ResultWnd.ShowWindow();
	ShopDailyFails_ResultWnd.SetFocus();
	if((int(_autoCraftInfo.uiState) == 2))
	{
		Class'Interface.ShopLcoinCraftMinimizeWnd'.static.Inst().SetFailMessage(msgIndex, isSystemStr);
	}
	return;
}

function SetCurrentLimitType()
{
	local PurchaseLimitCraftUIData productData;
	local PLShopItemDataStruct ItemData;
	local bool IsLimitBuy;
	local string tooltipStr;

	productData = GetSelectedProductData();
	ItemData = GetSelectedItemData();
	IsLimitBuy = isLimitBuyType(productData);
	limitTypeIconTex.SetTexture(GetLimitTypeIcon(productData.LimitType));
	if((int(productData.LimitType) == 0))
	{
		limitTypeIconTex.HideWindow();
		limitTypeTextBox.HideWindow();
		limitNumTextBox.HideWindow();
		limitHelpTextBox.HideWindow();
	}
	else
	{
		limitTypeIconTex.ShowWindow();
		limitNumTextBox.ShowWindow();
		limitTypeTextBox.ShowWindow();
		tooltipStr = GetBuyTypeStringBuyLimit(productData.LimitType, productData.ResetType, IsLimitBuy);
		if((tooltipStr == ""))
		{
			limitHelpTextBox.HideWindow();
		}
		else
		{
			limitHelpTextBox.SetText(tooltipStr);
			limitHelpTextBox.ShowWindow();
		}
	}
	limitTypeTextBox.SetText(GetLimitTypeIconString(productData.LimitType, productData.ResetType, IsLimitBuy));
	if((productData.LimitCountMax != 0))
	{
		if(IsLimitBuy)
		{
			limitNumTextBox.SetText(string(ItemData.nRemainItemAmount));
		}
		else
		{
			limitNumTextBox.SetText(((string(ItemData.nRemainItemAmount) $ "/") $ string(productData.LimitCountMax)));
		}
	}
	else
	{
		limitNumTextBox.SetText("");
	}
	return;
}

function SetCurrentLimitTimeType()
{
	local PLShopItemDataStruct ItemData;

	ItemData = GetSelectedItemData();
	if((ItemData.nRemainSec > 0))
	{
		craftTimeTextBox.SetText(util.getTimeStringBySec3(ItemData.nRemainSec));
		craftTimeTextBox.ShowWindow();
		craftTimeTex.ShowWindow();
	}
	else
	{
		craftTimeTextBox.HideWindow();
		craftTimeTex.HideWindow();
	}
	return;
}

function INT64 GetHaveItem(int i, array<PurchaseLimitCraftCostItemInfo> CostItems, optional bool isKeepOption)
{
	local array<ItemInfo> haveItemInfos;
	local int j;
	local ItemInfo Info;
	local int haveItem, inputedNum;
	local PurchaseLimitCraftCostItemInfo CostItem;

	Info = GetItemInfoByClassID(CostItems[i].ItemClassID);
	if(!IsStackableItem(Info.ConsumeType))
	{
		CostItem = CostItems[i];
		if(isKeepOption)
		{
			Class'NWindow.UIDATA_INVENTORY'.static.GetSpecificItemByScriptFilter(3, CostItem.ItemClassID, int(CostItem.Enchant), CostItem.IsBlessedItem, haveItemInfos);
		}
		else
		{
			Class'NWindow.UIDATA_INVENTORY'.static.GetSpecificItemByScriptFilter(5, CostItem.ItemClassID, int(CostItem.Enchant), CostItem.IsBlessedItem, haveItemInfos);
		}
		haveItem = haveItemInfos.Length;
		j = 0;
		while((j < i))
		{
			if((((CostItems[i].ItemClassID == CostItems[j].ItemClassID) && (int(CostItems[i].Enchant) == int(CostItems[j].Enchant))) && (CostItems[i].IsBlessedItem == CostItems[j].IsBlessedItem)))
			{
				inputedNum = int(ItemCount_EditBox.GetString());
				if((inputedNum == 0))
				{
					inputedNum = 1;
				}
				haveItem = Max(0, (haveItem - (inputedNum * int(CostItems[j].Count))));
			}
			j++;
		}
	}
	else
	{
		return GetInventoryItemCount(Info.Id);
	}
	return INT64(haveItem);
}

function INT64 GetCostItemAmount(int i, array<PurchaseLimitCraftCostItemInfo> CostItems)
{
	local int j;
	local INT64 nCostItemAmount;

	nCostItemAmount = CostItems[i].Count;
	j = (i + 1);
	while((j < CostItems.Length))
	{
		if((((CostItems[i].ItemClassID == CostItems[j].ItemClassID) && (int(CostItems[i].Enchant) == int(CostItems[j].Enchant))) && (CostItems[i].IsBlessedItem == CostItems[j].IsBlessedItem)))
		{
			(nCostItemAmount += CostItems[j].Count);
		}
		j++;
	}
	return nCostItemAmount;
}

function PLShopItemDataStruct ArrangingPeeItem(PLShopItemDataStruct ItemData)
{
	local int i, j;
	local array<PurchaseLimitCraftCostItemInfo> tmpCostInfos;

	tmpCostInfos = ItemData.displayCostItems;
	i = 0;
	while((i < ItemData.displayCostItems.Length))
	{
		if((tmpCostInfos[i].ItemClassID == 0))
		{
			i++;
			continue;
		}
		j = (i + 1);
		while((j < ItemData.displayCostItems.Length))
		{
			if((((tmpCostInfos[i].ItemClassID == tmpCostInfos[j].ItemClassID) && (int(tmpCostInfos[i].Enchant) == int(tmpCostInfos[j].Enchant))) && (tmpCostInfos[i].IsBlessedItem == tmpCostInfos[j].IsBlessedItem)))
			{
				(tmpCostInfos[i].Count += tmpCostInfos[j].Count);
				tmpCostInfos.Remove(j, 1);
				tmpCostInfos.Length = (tmpCostInfos.Length + 1);
				tmpCostInfos[(tmpCostInfos.Length - 1)].ItemClassID = 0;
			}
			j++;
		}
		i++;
	}
	ItemData.displayCostItems = tmpCostInfos;
	return ItemData;
}

function ItemInfo GetDefaultUserSelectCostItemInfo(int ClassID, int Enchanted, bool isBlessed, optional array<int> skipServerIds)
{
	local array<ItemInfo> haveItems;
	local ItemInfo haveItemInfo;
	local int i, j, Len;
	local bool isSkip;

	if((ClassID < 0))
	{
		haveItemInfo.Id.ServerID = ClassID;
		return haveItemInfo;
	}
	Len = Class'NWindow.UIDATA_INVENTORY'.static.GetItemByScriptFilter(5, haveItems);
	i = 0;
	while((i < Len))
	{
		haveItemInfo = haveItems[i];
		isSkip = false;
		j = 0;
		while((j < skipServerIds.Length))
		{
			if((skipServerIds[j] == haveItemInfo.Id.ServerID))
			{
				isSkip = true;
				break;
			}
			j++;
		}
		if(((((isSkip == false) && (haveItemInfo.Id.ClassID == ClassID)) && ((Enchanted == 255) || (haveItemInfo.Enchanted == Enchanted))) && (haveItemInfo.IsBlessedItem == isBlessed)))
		{
			if((isDamagedItem(haveItemInfo) == false))
			{
				return haveItemInfo;
			}
		}
		i++;
	}
	haveItemInfo = GetItemInfoByClassID(ClassID);
	haveItemInfo.Enchanted = Enchanted;
	haveItemInfo.IsBlessedItem = isBlessed;
	return haveItemInfo;
}

function SetCurrentCostItemInfo()
{
	local int i;
	local CurrentCostItemInfo defaultInfo;
	local array<CraftCostSlotInfo> tmpCostSlotInfos;
	local CraftCostSlotInfo tmpCostSlotInfo;
	local PLShopItemDataStruct ItemData;
	local PurchaseLimitCraftUIData productData;

	ItemData = GetSelectedItemData();
	API_GetPurchaseLimitCraftData(ItemData.nSlotNum, productData);
	if((_currentCostItemInfo.SlotNum != ItemData.nSlotNum))
	{
		_currentCostItemInfo = defaultInfo;
		_currentCostItemInfo.SlotNum = ItemData.nSlotNum;
		_currentCostItemInfo.displayCostItems = ItemData.displayCostItems;
		tmpCostSlotInfo.costItemList = productData.CostItemSlot1;
		tmpCostSlotInfos[0] = tmpCostSlotInfo;
		tmpCostSlotInfo.costItemList = productData.CostItemSlot2;
		tmpCostSlotInfos[1] = tmpCostSlotInfo;
		tmpCostSlotInfo.costItemList = productData.CostItemSlot3;
		tmpCostSlotInfos[2] = tmpCostSlotInfo;
		tmpCostSlotInfo.costItemList = productData.CostItemSlot4;
		tmpCostSlotInfos[3] = tmpCostSlotInfo;
		tmpCostSlotInfo.costItemList = productData.CostItemSlot5;
		tmpCostSlotInfos[4] = tmpCostSlotInfo;
		_currentCostItemInfo.costSlotInfos = tmpCostSlotInfos;
	}
	tmpCostSlotInfos = _currentCostItemInfo.costSlotInfos;
	i = 0;
	while((i < tmpCostSlotInfos.Length))
	{
		tmpCostSlotInfo = tmpCostSlotInfos[i];
		if((i < _currentCostItemInfo.displayCostItems.Length))
		{
			tmpCostSlotInfo.selectedCostItem = _currentCostItemInfo.displayCostItems[i];
			if((tmpCostSlotInfo.selectedCostItem.bUserSelect == true))
			{
				tmpCostSlotInfo.userSelectItemInfo = GetDefaultUserSelectCostItemInfo(tmpCostSlotInfo.selectedCostItem.ItemClassID, int(tmpCostSlotInfo.selectedCostItem.Enchant), tmpCostSlotInfo.selectedCostItem.IsBlessedItem, _emptyIntArray);
			}
		}
		tmpCostSlotInfos[i] = tmpCostSlotInfo;
		i++;
	}
	_currentCostItemInfo.costSlotInfos = tmpCostSlotInfos;
	return;
}

function UpdateCurrentCostItemInfo(int costIndex, PurchaseLimitCraftCostItemInfo selectedCostItemInfo, ItemInfo selectedItemInfo)
{
	local CraftCostSlotInfo tmpCostSlotInfo;

	if((_currentCostItemInfo.displayCostItems.Length > costIndex))
	{
		_currentCostItemInfo.displayCostItems[costIndex] = selectedCostItemInfo;
	}
	if((_currentCostItemInfo.costSlotInfos.Length > costIndex))
	{
		tmpCostSlotInfo = _currentCostItemInfo.costSlotInfos[costIndex];
		tmpCostSlotInfo.selectedCostItem = selectedCostItemInfo;
		tmpCostSlotInfo.userSelectItemInfo = selectedItemInfo;
		_currentCostItemInfo.costSlotInfos[costIndex] = tmpCostSlotInfo;
	}
	return;
}

function array<int> GetRequestServerIds()
{
	local int i;
	local CraftCostSlotInfo costSlotInfo;
	local PurchaseLimitCraftCostItemInfo costItemInfo;
	local array<int> serverIds;

	i = 0;
	while((i < _currentCostItemInfo.costSlotInfos.Length))
	{
		costSlotInfo = _currentCostItemInfo.costSlotInfos[i];
		if((costSlotInfo.costItemList.Length == 0))
		{
			serverIds[i] = 0;
			i++;
			continue;
		}
		if(((costSlotInfo.selectedCostItem.bUserSelect == true) && (costSlotInfo.userSelectItemInfo.Id.ServerID != 0)))
		{
			serverIds[i] = costSlotInfo.userSelectItemInfo.Id.ServerID;
			i++;
			continue;
		}
		if((costSlotInfo.costItemList.Length == 1))
		{
			costItemInfo = costSlotInfo.costItemList[0];
		}
		else
		{
			costItemInfo = costSlotInfo.selectedCostItem;
		}
		serverIds[i] = GetDefaultUserSelectCostItemInfo(costItemInfo.ItemClassID, int(costItemInfo.Enchant), costItemInfo.IsBlessedItem, serverIds).Id.ServerID;
		i++;
	}
	return serverIds;
}

function SetCurrentCostItems(optional bool modifyList)
{
	local PLShopItemDataStruct ItemData;
	local PurchaseLimitCraftUIData productData;
	local PurchaseLimitCraftCostItemInfo costItemInfo;
	local array<PurchaseLimitCraftCostItemInfo> costItemInfos;
	local int i, editBoxCount;
	local INT64 haveItem;
	local ItemInfo Info, nullItem;
	local int buyNum;
	local string btnName;
	local bool isShowInvenIcon;

	ItemData = GetSelectedItemData();
	API_GetPurchaseLimitCraftData(ItemData.nSlotNum, productData);
	editBoxCount = int(ItemCount_EditBox.GetString());
	costItemInfos = _currentCostItemInfo.displayCostItems;
	if((modifyList == false))
	{
		needItemScript.StartNeedItemList(2);
	}
	confirmNeedItemScript.StartNeedItemList(5);
	i = 0;
	while((i < costItemInfos.Length))
	{
		costItemInfo = costItemInfos[i];
		if(((costItemInfo.ItemClassID > 0) || (costItemInfo.ItemClassID == -800)))
		{
			if((costItemInfo.ItemClassID == -800))
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
				Info = GetItemInfoByClassID(costItemInfo.ItemClassID);
			}
			if((int(costItemInfo.Enchant) > 0))
			{
				Info.Enchanted = int(costItemInfo.Enchant);
			}
			if((int(costItemInfo.Enchant) == 255))
			{
				Info.Enchanted = 0;
			}
			Class'Interface.L2Util'.static.GetEllipsisStringWithAdd(Info.Name, Info.AdditionalName, 290);
			Info.IsBlessedItem = costItemInfo.IsBlessedItem;
			if((costItemInfo.ItemClassID == -800))
			{
				haveItem = getInstanceUIData().GetCurrentVitalityPoint();
			}
			else
			{
				haveItem = GetHaveItem(i, costItemInfos, productData.KeepOption);
			}
			if((modifyList == true))
			{
				needItemScript.ModifyNeeItemInfo(Info, costItemInfo.Count, haveItem);
			}
			else
			{
				btnName = "";
				isShowInvenIcon = false;
				if((i < _currentCostItemInfo.costSlotInfos.Length))
				{
					if(((costItemInfo.bUserSelect == true) && (_currentCostItemInfo.costSlotInfos[i].userSelectItemInfo.Id.ServerID != 0)))
					{
						isShowInvenIcon = true;
						Info = _currentCostItemInfo.costSlotInfos[i].userSelectItemInfo;
					}
					if((_currentCostItemInfo.costSlotInfos[i].costItemList.Length > 1))
					{
						btnName = (("expandBtn" $ "_") $ string(i));
					}
					else if(((costItemInfo.bUserSelect == true) && (haveItem > INT64(1))))
					{
						btnName = (("invenSelectBtn" $ "_") $ string(i));
					}
				}
				needItemScript.AddCraftNeedItemInfo(Info, costItemInfo.Count, haveItem, btnName, isShowInvenIcon);
			}
			confirmNeedItemScript.AddCraftNeedItemInfo(Info, costItemInfo.Count, haveItem, "", isShowInvenIcon);
		}
		i++;
	}
	buyNum = Max(editBoxCount, 1);
	needItemScript.SetBuyNum(INT64(buyNum));
	confirmNeedItemScript.SetBuyNum(INT64(buyNum));
	if((((_successionInfo.isKeepOption == true) && (_successionInfo.successionItemSId > 0)) && (_successionInfo.materialItemSId > 0)))
	{
		if(((_successionInfo.successionFee.Length > 0) && ((_successionInfo.itemOption1 > 0) || (_successionInfo.itemOption2 > 0))))
		{
			i = 0;
			while((i < _successionInfo.successionFee.Length))
			{
				confirmNeedItemScript.AddNeedItemClassID(_successionInfo.successionFee[i].ItemClassID, INT64(_successionInfo.successionFee[i].Count));
				i++;
			}
			buyWndConfirmBtn.SetEnable(confirmNeedItemScript.GetCanBuy());
		}
		else
		{
			buyWndConfirmBtn.SetEnable(true);
		}
	}
	else
	{
		buyWndConfirmBtn.SetEnable(true);
	}
	return;
}

function ClearRequirmentBuySkills()
{
	local int i;
	local ItemInfo clearInfo;

	LiveNeedSkill_ItemWnd.Clear();
	clearInfo.IconName = "L2ui_ct1.emptyBtn";
	i = 0;
	while((i < 10))
	{
		LiveNeedSkill_ItemWnd.AddItem(clearInfo);
		i++;
	}
	return;
}

function SetCurrentNeedSkills()
{
	local PurchaseLimitCraftUIData craftUIData;
	local int i, Index;
	local ItemInfo iInfo;

	ClearRequirmentBuySkills();
	craftUIData = GetSelectedProductData();
	if((craftUIData.RequirementBuySkills.Length > 0))
	{
		i = 0;
		while((i < craftUIData.RequirementBuySkills.Length))
		{
			iInfo = GetSkillItemInfo(craftUIData.RequirementBuySkills[i]);
			Index = int((float(((i / 5) * 5)) + (4.0000000 - (float(i) % 5.0000000))));
			LiveNeedSkill_ItemWnd.SetItem(Index, iInfo);
			i++;
		}
		LiveNeedSkillTitle_Txt.ShowWindow();
	}
	else
	{
		LiveNeedSkillTitle_Txt.HideWindow();
	}
	return;
}

function ItemInfo GetSkillItemInfo(int SkillID)
{
	local SkillInfo sInfo;
	local ItemInfo iInfo;

	GetSkillInfo(SkillID, 1, 0, sInfo);
	Class'Interface.L2Util'.static.Inst().GetSkill2ItemInfo(sInfo, iInfo);
	iInfo.bDisabled = (1 - Class'NWindow.UIDATA_SKILL'.static.SkillIsNewOrUp(iInfo.Id));
	return iInfo;
}

function bool CheckNeedSkill(int Index)
{
	local PurchaseLimitCraftUIData craftUIData;
	local PLShopItemDataStruct ItemData;
	local ItemInfo iInfo;
	local int i;

	ItemData = pLShopItemDataList[Index];
	API_GetPurchaseLimitCraftData(ItemData.nSlotNum, craftUIData);
	i = 0;
	while((i < craftUIData.RequirementBuySkills.Length))
	{
		iInfo = GetSkillItemInfo(craftUIData.RequirementBuySkills[i]);
		if((iInfo.bDisabled == 1))
		{
			return false;
		}
		i++;
	}
	return true;
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

function SetItemCountEditBox(INT64 Num)
{
	local INT64 buyNum;

	if((GetCurrentSelectedIndex() == -1))
	{
		Num = INT64(0);
	}
	else if((Num < INT64(1)))
	{
		Num = INT64(0);
	}
	Num = Min64(GetCountCanBuyByIndex(GetCurrentSelectedIndex(), true, true), Num);
	if((Num != INT64(int(ItemCount_EditBox.GetString()))))
	{
		ItemCount_EditBox.SetString(string(Num));
	}
	buyNum = MAX64(Num, INT64(1));
	needItemScript.SetBuyNum(buyNum);
	confirmNeedItemScript.SetBuyNum(buyNum);
	SetControlerBtns();
	return;
}

function SetControlerBtns()
{
	local INT64 Count, canBuyCount;
	local PurchaseLimitCraftUIData productData;

	productData = GetSelectedProductData();
	canBuyCount = GetCountCanBuyByIndex(GetCurrentSelectedIndex(), true, true);
	Count = INT64(ItemCount_EditBox.GetString());
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult01_CostItem_Wnd.NeedItem_RichlistWnd.RichListCtrl.DisableWndNeedItem")).HideWindow();
	if(((canBuyCount > INT64(0)) && ((isLimitBuyType(productData) == false) || (GetItemLimitAmount(GetCurrentSelectedIndex()) > 0))))
	{
		if((canBuyCount == INT64(1)))
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
			Max_Btn.DisableWindow();
		}
		else
		{
			MultiSell_Up_Button.EnableWindow();
			Max_Btn.EnableWindow();
		}
		if((Count <= INT64(1)))
		{
			Reset_Btn.DisableWindow();
			MultiSell_Down_Button.DisableWindow();
		}
		else
		{
			Reset_Btn.EnableWindow();
			MultiSell_Down_Button.EnableWindow();
		}
		if(((Count > INT64(0)) && GetCanInventoryWeight()))
		{
			Craft_Btn.EnableWindow();
			AutoCraft_Btn.EnableWindow();
		}
		else if(((int(CurrentState) != 4) && (int(_autoCraftInfo.uiState) != 2)))
		{
			Craft_Btn.DisableWindow();
			AutoCraft_Btn.DisableWindow();
		}
	}
	else
	{
		if(((isLimitBuyType(productData) == true) && (GetItemLimitAmount(GetCurrentSelectedIndex()) == 0)))
		{
			GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult01_CostItem_Wnd.NeedItem_RichlistWnd.RichListCtrl.DisableWndNeedItem")).ShowWindow();
		}
		MultiSell_Up_Button.DisableWindow();
		MultiSell_Down_Button.DisableWindow();
		MultiSell_Input_Button.DisableWindow();
		ItemCount_EditBox.DisableWindow();
		Reset_Btn.DisableWindow();
		Max_Btn.DisableWindow();
		if(((int(CurrentState) != 4) && (int(_autoCraftInfo.uiState) != 2)))
		{
			Craft_Btn.DisableWindow();
			AutoCraft_Btn.DisableWindow();
		}
	}
	SetBuyButtonTooltip();
	return;
}

function SetBuyButtonTooltip()
{
	local CustomTooltip t;

	util.setCustomTooltip(t);
	util.ToopTipMinWidth(10);
	if((GetCurrentSelectedIndex() == -1))
	{
		Craft_Btn.SetTooltipCustomType(util.getCustomToolTip());
		AutoCraft_Btn.SetTooltipCustomType(util.getCustomToolTip());
		return;
	}
	if(!GetCanInventoryWeight())
	{
		util.ToopTipInsertText(GetSystemString(13713), true, true, COLOR_RED);
	}
	if((GetCanBUyByInvenEmpty(GetCurrentSelectedIndex()) == 0))
	{
		util.ToopTipInsertText(GetSystemString(7177), true, true, COLOR_RED);
	}
	if(!CheckNeedSkill(GetCurrentSelectedIndex()))
	{
		util.ToopTipInsertText(GetSystemString(13896), true, true, COLOR_RED);
	}
	if(!CheckLevelCondition(GetCurrentSelectedIndex()))
	{
		util.ToopTipInsertText(ShopLcoinWnd(GetScript("ShopLcoinWnd")).GetLevelString(GetCurrMinLv(), GetCurrMaxLv()), true, true, COLOR_RED);
	}
	if((GetItemLimitAmount(GetCurrentSelectedIndex()) == 0))
	{
		util.ToopTipInsertText((GetSystemString(3725) $ " "), true, true, COLOR_GRAY);
		util.ToopTipInsertText("0", true, false, COLOR_RED);
	}
	if((GetMinAmoutByCostItemNum(GetSelectedItemData().nSlotNum, GetSelectedItemData().displayCostItems) == INT64(0)))
	{
		util.ToopTipInsertText(GetSystemMessage(701), true, true, COLOR_RED);
	}
	if(((isLimitBuyType(GetSelectedProductData()) == true) && (GetItemLimitAmount(GetCurrentSelectedIndex()) == 0)))
	{
		util.ToopTipInsertText(GetSystemString(13796), true, true, COLOR_RED);
		DisalbeCardAll();
	}
	else
	{
		EnableCardAll();
	}
	Craft_Btn.SetTooltipCustomType(util.getCustomToolTip());
	AutoCraft_Btn.SetTooltipCustomType(util.getCustomToolTip());
	return;
}

function RichListCtrlHandle getListCtrlByCategory(int nCategory)
{
	return GetRichListCtrlHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".LcoinCraftList_Wnd.List_ListCtrl") $ string(nCategory)));
}

function ButtonHandle GetFilterButton(int nFilterType)
{
	return GetButtonHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".categorySelect_Wnd") $ string(nFilterType)) $ ".Select_Checkbox"));
}

function int GetRichListItemNum(RichListCtrlHandle ctrl)
{
	local int i, ItemNum;
	local RichListCtrlRowData rec;

	i = 0;
	while((i < ctrl.GetRecordCount()))
	{
		ctrl.GetRec(i, rec);
		if((rec.szReserved != "$title$"))
		{
			ItemNum++;
		}
		i++;
	}
	return ItemNum;
}

function WindowHandle GetCard(int Num)
{
	return GetWindowHandle(GetCardWndPath(Num));
}

function TextureHandle GetTexturehandleCraftCardBG(int Num)
{
	return GetTextureHandle((GetCardWndPath(Num) $ ".CraftCardBG_tex"));
}

function TextureHandle GetTexturehandleCraftCardBack(int Num)
{
	return GetTextureHandle((GetCardWndPath(Num) $ ".CraftCardBack_tex"));
}

function ItemWindowHandle GetTexturehandleCraftSlot(int Num)
{
	return GetItemWindowHandle((GetCardWndPath(Num) $ ".CraftSlot_ItemWnd"));
}

function TextBoxHandle GetTextBoxhandleCraftItemNum(int Num)
{
	return GetTextBoxHandle((GetCardWndPath(Num) $ ".CraftNum_textbox"));
}

function TextBoxHandle GetTexturehandleCraftCardNum(int Num)
{
	return GetTextBoxHandle((GetCardWndPath(Num) $ ".ResultNum_textbox"));
}

function TextureHandle GetTextureHandleLimitIcon(int Num)
{
	return GetTextureHandle((GetCardWndPath(Num) $ ".LimitedRibbon_Tex"));
}

function TextureHandle GetTextureHandleDiable(int Num)
{
	return GetTextureHandle((GetCardWndPath(Num) $ ".RandomSlotDisable_tex"));
}

function string GetCardWndPath(int Num)
{
	return ((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.RandomSlotGroup_Wnd") $ string(Num));
}

function TextBoxHandle GetCraftProbabilityTextBox(int Num)
{
	return GetTextBoxHandle((GetCardWndPath(Num) $ ".CraftProbability_textbox"));
}

function AnimTextureHandle GetAutoCraftCardAnimTexture(int Num)
{
	return GetAnimTextureHandle((GetCardWndPath(Num) $ ".Card_Ani"));
}

function TextureHandle GetAutoCraftCardDisableTexture(int Num)
{
	return GetTextureHandle((GetCardWndPath(Num) $ ".AutoCraft_CardCover_Tex"));
}

function bool IsMyShopIndex(string param)
{
	local int sshopIndex;

	ParseInt(param, "ShopIndex", sshopIndex);
	return (4 == sshopIndex);
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

function bool HandleFindResult()
{
	if(((EditBoxFind.GetString() != "") && (GetRichListItemNum(getListCtrlByCategory(currentTabIndex)) == 0)))
	{
		GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CanNotFindText")).ShowWindow();
		GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CanNotFindText")).SetText(MakeFullSystemMsg(GetSystemMessage(4356), EditBoxFind.GetString()));
		CraftItemWnd.HideWindow();
		Craft_Btn.DisableWindow();
		AutoCraft_Btn.DisableWindow();
		return true;
	}
	else
	{
		GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CanNotFindText")).HideWindow();
		CraftItemWnd.ShowWindow();
		return false;
	}
	return false;
}

function HandleNotSelected()
{
	local string findStr;

	findStr = EditBoxFind.GetString();
	if(((findStr == "") || ((findStr != "") && (GetCurrentListSelectedIndex() == -1))))
	{
		CanNotFindText.ShowWindow();
		CanNotFindText.SetText(GetSystemMessage(13186));
		CraftItemWnd.HideWindow();
	}
	Craft_Btn.DisableWindow();
	AutoCraft_Btn.DisableWindow();
	return;
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

function PurchaseLimitCraftUIData GetSelectedProductData()
{
	local PLShopItemDataStruct ItemData;
	local PurchaseLimitCraftUIData productData;
	local int SelectedIndex;

	SelectedIndex = GetCurrentSelectedIndex();
	if(((SelectedIndex < 0) || (pLShopItemDataList.Length <= SelectedIndex)))
	{
		return productData;
	}
	ItemData = pLShopItemDataList[SelectedIndex];
	API_GetPurchaseLimitCraftData(ItemData.nSlotNum, productData);
	return productData;
}

function int GetProductCategoryByIndex(int Index)
{
	local PLShopItemDataStruct ItemData;
	local PurchaseLimitCraftUIData productData;

	if((Index == -1))
	{
		Index = GetCurrentSelectedIndex();
	}
	ItemData = pLShopItemDataList[Index];
	API_GetPurchaseLimitCraftData(ItemData.nSlotNum, productData);
	return productData.Category;
}

function int GetCurrentSelectedIndex()
{
	return selectedByCategoryList[currentTabIndex];
}

function PLShopItemDataStruct GetSelectedItemData()
{
	local PLShopItemDataStruct defaultData;
	local int SelectedIndex;

	SelectedIndex = GetCurrentSelectedIndex();
	if(((SelectedIndex < 0) || (pLShopItemDataList.Length <= SelectedIndex)))
	{
		return defaultData;
	}
	return pLShopItemDataList[SelectedIndex];
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
		case PLSHOP_LIMIT_WORLD_ACCOUNT:
			return "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Icon_Account";
			break;
		case PLSHOP_LIMIT_SERVER:
			return "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Icon_BasicServer";
			break;
		default:
			break;
	}
	return "";
}

function string GetLimitTypeIconString(UIEventManager.PLSHOP_LIMIT_TYPE Type, UIEventManager.PLSHOP_RESET_TYPE type2, bool isLimitBuyType)
{
	if(isLimitBuyType)
	{
		switch(Type)
		{
			case PLSHOP_LIMIT_NONE:
				return GetSystemString(539);
				break;
			case PLSHOP_LIMIT_CHARACTER:
				return GetSystemMessage(13904);
				break;
			case PLSHOP_LIMIT_ACCOUNT:
			case PLSHOP_LIMIT_WORLD_ACCOUNT:
				return GetSystemMessage(13905);
				break;
			case PLSHOP_LIMIT_SERVER:
				return GetSystemMessage(13866);
				break;
			default:
				break;
		}
	}
	else
	{
		switch(Type)
		{
			case PLSHOP_LIMIT_NONE:
				return GetSystemString(539);
				break;
			case PLSHOP_LIMIT_CHARACTER:
				if((int(type2) == 0))
				{
					return GetSystemString(13299);
				}
				else if((int(type2) == 1))
				{
					return GetSystemString(13298);
				}
				else if((int(type2) == 4))
				{
					return GetSystemString(13298);
				}
				else if((int(type2) == 2))
				{
					return GetSystemString(13879);
				}
				else if((int(type2) == 3))
				{
					return GetSystemString(13881);
				}
				break;
			case PLSHOP_LIMIT_ACCOUNT:
			case PLSHOP_LIMIT_WORLD_ACCOUNT:
				if((int(type2) == 0))
				{
					return GetSystemString(13301);
				}
				else if((int(type2) == 1))
				{
					return GetSystemString(13300);
				}
				else if((int(type2) == 4))
				{
					return GetSystemString(13300);
				}
				else if((int(type2) == 2))
				{
					return GetSystemString(13878);
				}
				else if((int(type2) == 3))
				{
					return GetSystemString(13880);
				}
				break;
			case PLSHOP_LIMIT_SERVER:
				if((int(type2) == 0))
				{
					return GetSystemString(14536);
				}
				else if((int(type2) == 1))
				{
					return GetSystemString(14537);
				}
				else if((int(type2) == 4))
				{
					return GetSystemString(14537);
				}
				else if((int(type2) == 2))
				{
					return GetSystemString(14538);
				}
				else if((int(type2) == 3))
				{
					return GetSystemString(14539);
				}
				break;
			default:
				break;
		}
	}
	return "";
}

function string GetBuyTypeStringBuyLimit(UIEventManager.PLSHOP_LIMIT_TYPE Type, UIEventManager.PLSHOP_RESET_TYPE type2, bool isLimitBuyType)
{
	local PLShopItemDataStruct ItemData;

	ItemData = GetSelectedItemData();
	switch(Type)
	{
		case PLSHOP_LIMIT_NONE:
			return "";
			break;
		case PLSHOP_LIMIT_CHARACTER:
		case PLSHOP_LIMIT_ACCOUNT:
		case PLSHOP_LIMIT_WORLD_ACCOUNT:
		case PLSHOP_LIMIT_SERVER:
			if((ItemData.nStartTime > 0))
			{
				return GetLcoinCraftResetString(ItemData.nStartTime, type2);
			}
			else
			{
				return GetSystemString(13873);
			}
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
			return "L2UI_EPIC.LCoinShopWnd.LCoinShopCraft_ListRibbonLIMITED";
			break;
		case LCoinShopMark_New:
			return "L2UI_EPIC.LCoinShopICON_ribbonNEW";
			break;
		case LCoinShopMark_Character:
			return "L2UI_EPIC.LCoinShopWnd.LCoinShopCraft_ListRibbonLIMITEDBlue";
			break;
		case LCoinShopMark_Account:
			return "L2UI_EPIC.LCoinShopWnd.LCoinShopCraft_ListRibbonLIMITEDYellow";
			break;
		case LCoinShopMark_Server:
			return "L2UI_EPIC.LCoinShopWnd.LCoinShopCraft_ListRibbonLIMITEDRed";
			break;
		default:
			break;
	}
	return "";
}

function string GetItemMarkIconByLimitType(UIEventManager.PLSHOP_LIMIT_TYPE LimitType)
{
	switch(LimitType)
	{
		case PLSHOP_LIMIT_CHARACTER:
			return "L2UI_EPIC.LCoinShopWnd.LCoinShopCraft_SlotRibbonLIMITEDBlue";
			break;
		case PLSHOP_LIMIT_ACCOUNT:
		case PLSHOP_LIMIT_WORLD_ACCOUNT:
			return "L2UI_EPIC.LCoinShopWnd.LCoinShopCraft_SlotRibbonLIMITEDYellow";
			break;
		case PLSHOP_LIMIT_SERVER:
			return "L2UI_EPIC.LCoinShopWnd.LCoinShopCraft_SlotRibbonLIMITEDRed";
			break;
		default:
			break;
	}
}

function RichListCtrlRowData GetSelectedRecord()
{
	local RichListCtrlRowData Record, nullRecord;
	local int SlotNum, listIndex;

	if((GetCurrentListSelectedIndex() == -1))
	{
		SlotNum = pLShopItemDataList[GetCurrentSelectedIndex()].nSlotNum;
		if((SlotNum > -1))
		{
			listIndex = GetCurrentListIndexBySlotNum(SlotNum);
			if((listIndex == -1))
			{
				return nullRecord;
			}
			getListCtrlByCategory(currentTabIndex).GetRec(listIndex, Record);
		}
	}
	else
	{
		getListCtrlByCategory(currentTabIndex).GetSelectedRec(Record);
	}
	return Record;
}

function int GetCurrentListIndexBySlotNum(int SlotNum)
{
	return FindListIndex(currentTabIndex, SlotNum);
}

function int FindListIndex(int Category, int SlotNum)
{
	local int i;
	local RichListCtrlRowData Record;

	i = 0;
	while((i < getListCtrlByCategory(Category).GetRecordCount()))
	{
		getListCtrlByCategory(Category).GetRec(i, Record);
		if((SlotNum == GetSlotNumByRecord(Record)))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function string GetGradeTextureByRank(int ProductRank)
{
	switch(ProductRank)
	{
		case 0:
			return "L2UI_EPIC.LCoinShopWnd.LCoinShopCraftCard_01";
			break;
		case 1:
			return "L2UI_EPIC.LCoinShopWnd.LCoinShopCraftCard_02";
			break;
		case 2:
			return "L2UI_EPIC.LCoinShopWnd.LCoinShopCraftCard_03";
			break;
		case 3:
			return "L2UI_EPIC.LCoinShopWnd.LCoinShopCraftCard_04";
			break;
		case 4:
			return "L2UI_EPIC.LCoinShopWnd.LCoinShopCraftCard_05";
			break;
		default:
			break;
	}
	return "";
}

function int GetCurrentListSelectedIndex()
{
	return getListCtrlByCategory(currentTabIndex).GetSelectedIndex();
}

function SetFilterGroupBtnByCategory(int nCategory)
{
	local int i;

	currentFilterTypes.Length = 0;
	currentFilterTypes = GetCategorySubList(nCategory);
	i = 0;
	while((i < currentFilterTypes.Length))
	{
		filterGroupButton._GetGroupButtonsInstance()._setButtonText(i, GetFilterString(i));
		i++;
	}
	filterGroupButton._GetGroupButtonsInstance()._setShowButtonNum(currentFilterTypes.Length);
	filterGroupButton._GetGroupButtonsInstance()._setMultilineButtonCenterByAsset(132, 23, 7, currentFilterTypes.Length, 4, 4);
	if((selectedFilterTabList.Length > currentTabIndex))
	{
		filterGroupButton._GetGroupButtonsInstance()._setTopOrder(selectedFilterTabList[currentTabIndex]);
	}
	return;
}

function string GetFilterString(int Index)
{
	if((Index == 0))
	{
		return GetSystemString(144);
	}
	return GetNpcString(currentFilterTypes[Index]);
}

function SelectFilterButton(int nFilterType, bool bSelect)
{
	if(bSelect)
	{
		GetFilterButton(nFilterType).SetTexture("l2ui_ct1.RankingWnd_SubTabButton_Down", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Down");
	}
	else
	{
		GetFilterButton(nFilterType).SetTexture("l2ui_ct1.RankingWnd_SubTabButton", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Over");
	}
	return;
}

function int SelectedCategorySub(int Category)
{
	if((categorySubDatas.Length <= 0))
	{
		return 0;
	}
	if((selectedFilterTabList.Length <= 0))
	{
		return 0;
	}
	return GetCategorySubList(Category)[selectedFilterTabList[Category]];
}

function MakeItemCategorySubList()
{
	local int i;
	local PurchaseLimitCraftUIData productData;

	i = 0;
	while((i < pLShopItemDataList.Length))
	{
		API_GetPurchaseLimitCraftData(pLShopItemDataList[i].nSlotNum, productData);
		SetSubCategory(productData.Category, productData.CategorySub);
		i++;
	}
	return;
}

function MakeAllItemCategorySubList()
{
	local int i;

	i = 0;
	while((i < 18))
	{
		SetSubCategory(i, 0);
		i++;
	}
	return;
}

function ClearItemCategorySubList()
{
	local int i;

	i = 0;
	while((i < categorySubDatas.Length))
	{
		categorySubDatas[i].categorySubs.Length = 0;
		i++;
	}
	return;
}

function array<int> GetCategorySubList(int Category)
{
	return categorySubDatas[Category].categorySubs;
}

function SetSubCategory(int Category, int CategorySub)
{
	local int Index, Len;

	Index = GetCategorySubIndex(Category, CategorySub);
	if((Index == -1))
	{
		Len = categorySubDatas[Category].categorySubs.Length;
		categorySubDatas[Category].categorySubs[Len] = CategorySub;
	}
	return;
}

function int GetCategorySubIndex(int Category, int CategorySub)
{
	local int i;

	i = 0;
	while((i < categorySubDatas[Category].categorySubs.Length))
	{
		if((categorySubDatas[Category].categorySubs[i] == CategorySub))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function DisalbeCardAll()
{
	local int i;

	i = 0;
	while((i < 5))
	{
		GetTextureHandleDiable(i).ShowWindow();
		i++;
	}
	return;
}

function EnableCardAll()
{
	local int i;

	i = 0;
	while((i < 5))
	{
		GetTextureHandleDiable(i).HideWindow();
		i++;
	}
	return;
}

function AnimationComplete(int Id)
{
	if((int(CurrentState) != 2))
	{
		return;
	}
	switch(Id)
	{
		case 1:
			AnimationEnd();
			break;
		default:
			break;
	}
	return;
}

function ShakeComplete(int Id)
{
	if((int(CurrentState) != 3))
	{
		return;
	}
	switch(Id)
	{
		case 2:
			RqPurchaseLimitShopItemBuy();
			break;
		default:
			break;
	}
	return;
}

function AnimationStart()
{
	aniLoop = 0;
	AnimationNext();
	CraftGaugeWndGauge_tex.SetWindowSize(0, gaugeRect.nHeight);
	MakeChargeObject();
	AnimationCardToBack();
	m_hOwnerWnd.KillTimer(1);
	m_hOwnerWnd.SetTimer(1, 2000);
	return;
}

function float GetSizePer()
{
	local float Per;

	switch(aniLoop)
	{
		case 0:
			Per = 0.2000000;
			break;
		case 1:
			Per = 0.6000000;
			break;
		case 2:
			Per = 1.0000000;
			break;
		default:
			break;
	}
	return Per;
}

function AnimationNext()
{
	local int randNum;

	MakeShakeObject();
	randNum = Rand(10);
	if((randNum < 2))
	{
		m_ObjectViewport.PlayAnimation(2);
	}
	else
	{
		m_ObjectViewport.PlayAnimation(1);
	}
	aniLoop++;
	return;
}

function MakeShakeObject()
{
	local float Size;

	Size = (50.0000000 * GetSizePer());
	l2UITweenScript.StartShake(CraftItemWnd.GetWindowName(), int(Size), 200, small, 1020);
	return;
}

function MakeResultShakeObject()
{
	local L2UITween.ShakeObject shakeObjectData;

	shakeObjectData.Owner = m_hOwnerWnd.m_WindowNameWithFullPath;
	shakeObjectData.Id = 2;
	shakeObjectData.shakeSize = 10.0000000;
	shakeObjectData.Direction = big;
	shakeObjectData.Target = CraftItemWnd;
	shakeObjectData.Duration = 2000.0000000;
	l2UITweenScript.StartShakeObject(shakeObjectData);
	return;
}

function MakeChargeObject()
{
	local L2UITween.TweenObject tweenObjectData;

	tweenObjectData.Owner = m_hOwnerWnd.m_WindowNameWithFullPath;
	tweenObjectData.Id = 1;
	tweenObjectData.Target = CraftGaugeWndGauge_tex;
	tweenObjectData.Duration = ((2000.0000000 * 2.0000000) + 1020.0000000);
	tweenObjectData.SizeX = float(gaugeRect.nWidth);
	tweenObjectData.ease = IN_STRONG;
	l2UITweenScript.AddTweenObject(tweenObjectData);
	return;
}

function AnimationStop()
{
	local int i;
	local PurchaseLimitCraftUIData productData;

	m_ObjectViewport.PlayAnimation(-1);
	l2UITweenScript.StopTween(m_hOwnerWnd.m_WindowNameWithFullPath, 1);
	l2UITweenScript.StopShake(m_hOwnerWnd.m_WindowNameWithFullPath, 2);
	CraftItemWnd.MoveC(craftItemWndRect.nX, craftItemWndRect.nY);
	productData = GetSelectedProductData();
	i = 0;
	while((i < productData.BuyItems.Length))
	{
		l2UITweenScript.StopTween(m_hOwnerWnd.m_WindowNameWithFullPath, (1000 + i));
		i++;
	}
	m_hOwnerWnd.KillTimer(1);
	return;
}

function AnimationEnd()
{
	AnimationStop();
	SetState(confirm);
	return;
}

function AnimationCardToBack()
{
	local int i;
	local L2UITween.TweenObject tweenObjectData;
	local TextureHandle cardBackTexture;
	local PurchaseLimitCraftUIData productData;

	productData = GetSelectedProductData();
	i = 0;
	while((i < productData.BuyItems.Length))
	{
		cardBackTexture = GetTexturehandleCraftCardBack(i);
		GetTexturehandleCraftSlot(i).HideWindow();
		tweenObjectData.Owner = m_hOwnerWnd.m_WindowNameWithFullPath;
		tweenObjectData.Id = (1000 + i);
		tweenObjectData.Target = cardBackTexture;
		tweenObjectData.Duration = 500.0000000;
		tweenObjectData.Delay = ((500.0000000 * float(i)) / 5.0000000);
		tweenObjectData.ease = OUT_STRONG;
		tweenObjectData.Alpha = 255.0000000;
		cardBackTexture.SetAlpha(0);
		cardBackTexture.ShowWindow();
		l2UITweenScript.AddTweenObject(tweenObjectData);
		i++;
	}
	return;
}

function AnimationCardToFront(int i)
{
	local L2UITween.TweenObject tweenObjectData;

	tweenObjectData.Owner = m_hOwnerWnd.m_WindowNameWithFullPath;
	tweenObjectData.Id = (1000 + i);
	tweenObjectData.Target = GetTexturehandleCraftCardBack(i);
	GetTexturehandleCraftSlot(i).ShowWindow();
	tweenObjectData.Duration = 500.0000000;
	tweenObjectData.Delay = ((500.0000000 * float(i)) / 5.0000000);
	tweenObjectData.ease = OUT_STRONG;
	tweenObjectData.Alpha = -255.0000000;
	l2UITweenScript.AddTweenObject(tweenObjectData);
	return;
}

function playEffectViewPort(string effectPath)
{
	EffectViewport00.SpawnEffect(effectPath);
	return;
}

function SetState(StateCraft State)
{
	CurrentState = State;
	m_hOwnerWnd.KillTimer(1);
	switch(State)
	{
		case Normal:
			EditBoxFind.EnableWindow();
			playEffectViewPort("");
			disableWnd.HideWindow();
			ShowBuyWnd(false);
			CraftResult01_CostItem_Wnd.ShowWindow();
			CraftResult02_Gauge_Wnd.HideWindow();
			CraftResult03_Description_Wnd.HideWindow();
			AnimationStop();
			SetBuyItems();
			Craft_Btn.SetButtonName(645);
			Craft_Btn.EnableWindow();
			AutoCraft_Btn.EnableWindow();
			ShopDailyFails_ResultWnd.HideWindow();
			passAnimationCheck.ShowWindow();
			craftDescTextBox.ShowWindow();
			ResetAutoCraftInfo();
			CloseAutoCraftMinimizeWnd();
			break;
		case Buy:
			EditBoxFind.DisableWindow();
			ShowBuyWnd(true);
			CraftResult01_CostItem_Wnd.ShowWindow();
			CraftResult02_Gauge_Wnd.HideWindow();
			CraftResult03_Description_Wnd.HideWindow();
			AnimationStop();
			Craft_Btn.SetButtonName(645);
			passAnimationCheck.ShowWindow();
			break;
		case process:
			EditBoxFind.DisableWindow();
			disableWnd.ShowWindow();
			disableWnd.SetFocus();
			ShowBuyWnd(false);
			CraftResult01_CostItem_Wnd.HideWindow();
			CraftResult02_Gauge_Wnd.ShowWindow();
			CraftResult03_Description_Wnd.HideWindow();
			AnimationStop();
			AnimationStart();
			Craft_Btn.SetButtonName(141);
			passAnimationCheck.HideWindow();
			break;
		case confirm:
			EditBoxFind.DisableWindow();
			EffectViewport00.SetCameraDistance(530.0000000);
			PlaySound("ItemSound2.smelting.smelting_finalA");
			disableWnd.ShowWindow();
			disableWnd.SetFocus();
			ShowBuyWnd(false);
			CraftResult01_CostItem_Wnd.HideWindow();
			CraftResult02_Gauge_Wnd.HideWindow();
			CraftResult03_Description_Wnd.ShowWindow();
			Craft_Btn.SetButtonName(140);
			Description_Text.SetText(GetSystemString(13295));
			passAnimationCheck.HideWindow();
			break;
		case Result:
			EditBoxFind.DisableWindow();
			if((_successionInfo.isKeepOption == true))
			{
				UpdateSuccessionResultBuyItems();
			}
			disableWnd.ShowWindow();
			disableWnd.SetFocus();
			ShowBuyWnd(false);
			CraftResult01_CostItem_Wnd.HideWindow();
			CraftResult02_Gauge_Wnd.HideWindow();
			CraftResult03_Description_Wnd.ShowWindow();
			Craft_Btn.SetButtonName(3135);
			Craft_Btn.EnableWindow();
			Description_Text.SetText(GetSystemString(13296));
			passAnimationCheck.HideWindow();
			break;
		case autoCraft:
			StartAutoCraft();
			break;
		default:
			break;
	}
	UpdateAutoCraftBtn();
	UpdateAutoCraftInfoControls();
	return;
}

function initSelectedItemIDArray()
{
	local int i;

	i = 0;
	while((i < 18))
	{
		selectedByCategoryList[i] = -1;
		selectedFilterTabList[i] = 0;
		i++;
	}
	return;
}

function SetDwaft()
{
	m_ObjectViewport.SetCameraDistance(400);
	m_ObjectViewport.SetCharacterOffsetX(-8);
	m_ObjectViewport.SetCharacterOffsetY(-3);
	m_ObjectViewport.SetNPCInfo(19673);
	m_ObjectViewport.SetCurrentRotation(33000);
	m_ObjectViewport.ShowNPC(0.1000000);
	m_ObjectViewport.SpawnNPC();
	m_ObjectViewport.ShowWindow();
	return;
}

function OnReceivedCloseUI()
{
	if((int(_autoCraftInfo.uiState) == 1))
	{
		if(Class'Interface.ShopLcoinCraftMinimizeWnd'.static.Inst().Me.IsShowWindow())
		{
			Class'Interface.ShopLcoinCraftMinimizeWnd'.static.Inst()._isUserCancel = true;
		}
		ResultAutoCraft();
		return;
	}
	if((int(CurrentState) != 0))
	{
		SetState(Normal);
		if((m_hOwnerWnd.IsVisibility() == false))
		{
			m_hOwnerWnd.SetVisibility(true);
		}
		return;
	}
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	return;
}

delegate int OnSortCompareCategory(PLShopItemDataStruct A, PLShopItemDataStruct B)
{
	if((A.CategorySub != B.CategorySub))
	{
		if((A.CategorySub > B.CategorySub))
		{
			return -1;
		}
		else
		{
			return 0;
		}
	}
	if((A.Category > B.Category))
	{
		return -1;
	}
	else
	{
		return 0;
	}
	return 0;
}

function bool isLimitBuyType(PurchaseLimitCraftUIData craftUIData)
{
	if((craftUIData.BuyItems.Length > 0))
	{
		return craftUIData.BuyItems[0].IsLimitBuy;
	}
	return false;
}

function ShowBuyWnd(bool isShow)
{
	if((_successionInfo.isKeepOption == true))
	{
		if(isShow)
		{
			if(DialogIsMine())
			{
				DialogHide();
			}
			ShowSuccessionDialog();
		}
		else
		{
			buy_Wnd.HideWindow();
			HideSuccessionDialog();
		}
	}
	else if(isShow)
	{
		if(DialogIsMine())
		{
			DialogHide();
		}
		UpdateBuyWndControls();
		SetCurrentCostItems();
		buy_Wnd.ShowWindow();
		buy_Wnd.SetFocus();
	}
	else
	{
		buy_Wnd.HideWindow();
	}
	return;
}

function ResetSuccessionDialogInfo()
{
	_successionInfo.successionItemSId = 0;
	_successionInfo.materialItemSId = 0;
	_successionInfo.itemOption1 = 0;
	_successionInfo.itemOption2 = 0;
	_successionInfo.isResultScene = false;
	return;
}

function ResetSuccessionInfo()
{
	ResetSuccessionDialogInfo();
	_successionInfo.ProductID = 0;
	_successionInfo.isKeepOption = false;
	_successionInfo.CostItems.Length = 0;
	_successionInfo.successionFee.Length = 0;
	_successionInfo.ProductItemEnchant = 0;
	return;
}

function ResetAutoCraftInfo()
{
	local AutoCraftInfo defaultInfo;

	_autoCraftInfo = defaultInfo;
	KillAutoCraftTimer();
	return;
}

function UpdateSuccessionInvenWnd()
{
	local int i, COSTITEMNUM;
	local ItemInfo tempInfo;
	local array<ItemInfo> ItemInfos, resultInfos;
	local PurchaseLimitCraftCostItemInfo targetCostItem;

	successionCostItemWnd.Clear();
	COSTITEMNUM = GetSuccessionCostItemNum();
	if((COSTITEMNUM == 0))
	{
		return;
	}
	else if((COSTITEMNUM == 1))
	{
		targetCostItem = _successionInfo.CostItems[0];
	}
	else if((COSTITEMNUM == 2))
	{
		if((_successionInfo.successionItemSId == 0))
		{
			targetCostItem = _successionInfo.CostItems[0];
		}
		else
		{
			targetCostItem = _successionInfo.CostItems[1];
		}
	}
	tempInfo = GetItemInfoByClassID(targetCostItem.ItemClassID);
	if(IsStackableItem(tempInfo.ConsumeType))
	{
		targetCostItem.Enchant = 0;
	}
	Class'NWindow.UIDATA_INVENTORY'.static.GetItemByScriptFilter(3, ItemInfos);
	i = 0;
	while((i < ItemInfos.Length))
	{
		tempInfo = ItemInfos[i];
		if((tempInfo.Id.ClassID == targetCostItem.ItemClassID))
		{
			if(((_successionInfo.successionItemSId == tempInfo.Id.ServerID) || (_successionInfo.materialItemSId == tempInfo.Id.ServerID)))
			{
				i++;
				continue;
			}
			if(((int(targetCostItem.Enchant) > 0) && (int(targetCostItem.Enchant) != tempInfo.Enchanted)))
			{
				i++;
				continue;
			}
			tempInfo.bShowCount = false;
			tempInfo.bDisabled = 0;
			resultInfos[resultInfos.Length] = tempInfo;
		}
		i++;
	}
	// resultInfos.Sort(SortItemOptionDelegate);   // array.Sort() unsupported by this compiler
	i = 0;
	while((i < resultInfos.Length))
	{
		successionCostItemWnd.AddItem(resultInfos[i]);
		i++;
	}
	return;
}

function UpdateSuccessionDialogControls()
{
	local ItemWindowHandle successionItemSlot, materialItemSlot;
	local TextBoxHandle registerTextBox, successionOptionTextBox, materialOptionTextBox, successionItemLabel, materialItemLabel;
	local ButtonHandle registerBtn;
	local ItemInfo successionItemInfo, materialItemInfo, slotItemInfo;
	local TextureHandle successionOptionTexture, materialOptionTexture, successionItemSpecialOpTex, materialItemSpecialOpTex;
	local WindowHandle needItemDisableWnd;
	local AnimTextureHandle successionSlotAnimTex, materialSlotAnimTex;
	local L2Util util;
	local string ItemName;
	local bool needUpdateSlot;
	local int i;

	if((_successionInfo.isKeepOption == false))
	{
		Debug("not succession product item");
		return;
	}
	util = L2Util(GetScript("L2Util"));
	successionItemSlot = GetItemWindowHandle((successionWnd.m_WindowNameWithFullPath $ ".Succeed_Item"));
	materialItemSlot = GetItemWindowHandle((successionWnd.m_WindowNameWithFullPath $ ".SucceedMaterial_Item"));
	registerTextBox = GetTextBoxHandle((itemRegisterContainer.m_WindowNameWithFullPath $ ".RegistrationTitle_txt"));
	registerBtn = GetButtonHandle((itemRegisterContainer.m_WindowNameWithFullPath $ ".Registration_Btn"));
	successionOptionTextBox = GetTextBoxHandle((successionWnd.m_WindowNameWithFullPath $ ".Succeed_txtOptions"));
	materialOptionTextBox = GetTextBoxHandle((successionWnd.m_WindowNameWithFullPath $ ".SucceedMaterial_txtOptions"));
	successionOptionTexture = GetTextureHandle((successionWnd.m_WindowNameWithFullPath $ ".Succeed_optionGradeTexture"));
	materialOptionTexture = GetTextureHandle((successionWnd.m_WindowNameWithFullPath $ ".SucceedMaterial_optionGradeTexture"));
	needItemDisableWnd = GetWindowHandle((successionWnd.m_WindowNameWithFullPath $ ".NeedItem_RichlistWnd.DisableWndNeedItem"));
	successionSlotAnimTex = GetAnimTextureHandle((successionWnd.m_WindowNameWithFullPath $ ".SuccedSlotani_Tex"));
	materialSlotAnimTex = GetAnimTextureHandle((successionWnd.m_WindowNameWithFullPath $ ".MaterialSlotani_Tex"));
	successionItemLabel = GetTextBoxHandle((successionWnd.m_WindowNameWithFullPath $ ".ItemName_Succeed_txt"));
	materialItemLabel = GetTextBoxHandle((successionWnd.m_WindowNameWithFullPath $ ".ItemName_Material_txt"));
	successionItemSpecialOpTex = GetTextureHandle((successionWnd.m_WindowNameWithFullPath $ ".SpecialOptionEffect_Left"));
	materialItemSpecialOpTex = GetTextureHandle((successionWnd.m_WindowNameWithFullPath $ ".SpecialOptionEffect_Right"));
	if((_successionInfo.isResultScene == false))
	{
		if(((_successionInfo.successionItemSId > 0) && Class'NWindow.UIDATA_INVENTORY'.static.FindItem(_successionInfo.successionItemSId, successionItemInfo)))
		{
			needUpdateSlot = true;
			if(successionItemSlot.GetItem(0, slotItemInfo))
			{
				if((slotItemInfo.Id.ServerID == _successionInfo.successionItemSId))
				{
					needUpdateSlot = false;
				}
			}
			if((needUpdateSlot == true))
			{
				successionSlotAnimTex.Stop();
				successionSlotAnimTex.Play();
				ItemName = GetItemNameAll(successionItemInfo);
				util.GetEllipsisString(ItemName, 210);
				successionItemLabel.SetText(ItemName);
				if(!successionItemSlot.SetItem(0, successionItemInfo))
				{
					successionItemSlot.AddItem(successionItemInfo);
				}
			}
		}
		else
		{
			successionItemSlot.Clear();
			successionItemLabel.SetText("");
		}
		if(((_successionInfo.materialItemSId > 0) && Class'NWindow.UIDATA_INVENTORY'.static.FindItem(_successionInfo.materialItemSId, materialItemInfo)))
		{
			needUpdateSlot = true;
			if(materialItemSlot.GetItem(0, slotItemInfo))
			{
				if((slotItemInfo.Id.ServerID == _successionInfo.materialItemSId))
				{
					needUpdateSlot = false;
				}
			}
			if((needUpdateSlot == true))
			{
				materialSlotAnimTex.Stop();
				materialSlotAnimTex.Play();
				ItemName = GetItemNameAll(materialItemInfo);
				materialItemLabel.SetText(ItemName);
				util.GetEllipsisString(ItemName, 210);
				if(!materialItemSlot.SetItem(0, materialItemInfo))
				{
					materialItemSlot.AddItem(materialItemInfo);
				}
			}
		}
		else
		{
			materialItemSlot.Clear();
			materialItemLabel.SetText("");
		}
		itemRegisterContainer.ShowWindow();
		UpdateSuccessionInvenWnd();
		if(((_successionInfo.successionItemSId > 0) && (_successionInfo.materialItemSId > 0)))
		{
			registerBtn.SetEnable(true);
		}
		else
		{
			registerBtn.SetEnable(false);
		}
		if((_successionInfo.successionItemSId == 0))
		{
			registerTextBox.SetText(GetSystemString(14149));
		}
		else if((_successionInfo.materialItemSId == 0))
		{
			registerTextBox.SetText(GetSystemString(14150));
		}
		else
		{
			registerTextBox.SetText(GetSystemString(14151));
		}
	}
	else
	{
		itemRegisterContainer.HideWindow();
		Class'NWindow.UIDATA_INVENTORY'.static.FindItem(_successionInfo.successionItemSId, successionItemInfo);
		Class'NWindow.UIDATA_INVENTORY'.static.FindItem(_successionInfo.materialItemSId, materialItemInfo);
		_successionInfo.itemOption1 = successionItemInfo.RefineryOp1;
		_successionInfo.itemOption2 = successionItemInfo.RefineryOp2;
		_successionInfo.itemOption3 = successionItemInfo.RefineryOp3;
		SetItemOptionControl(successionItemInfo.RefineryOp1, successionItemInfo.RefineryOp2, successionItemInfo.RefineryOp3, successionOptionTextBox, successionOptionTexture, successionItemSpecialOpTex);
		SetItemOptionControl(materialItemInfo.RefineryOp1, materialItemInfo.RefineryOp2, materialItemInfo.RefineryOp3, materialOptionTextBox, materialOptionTexture, materialItemSpecialOpTex);
		if(((successionItemInfo.RefineryOp1 != 0) || (successionItemInfo.RefineryOp2 != 0)))
		{
			if((_successionInfo.successionFee.Length > 0))
			{
				successionNeedItemScript.StartNeedItemList(2);
				i = 0;
				while((i < _successionInfo.successionFee.Length))
				{
					if((_successionInfo.successionFee[i].ItemClassID > 0))
					{
						successionNeedItemScript.AddNeedItemClassID(_successionInfo.successionFee[i].ItemClassID, INT64(_successionInfo.successionFee[i].Count));
					}
					i++;
				}
				successionNeedItemScript.SetBuyNum(INT64(1));
				needItemDisableWnd.HideWindow();
			}
			else
			{
				successionNeedItemScript.CleariObjects();
				needItemDisableWnd.ShowWindow();
			}
		}
		else
		{
			successionNeedItemScript.CleariObjects();
			needItemDisableWnd.ShowWindow();
		}
	}
	return;
}

function string MakeHtmlTable(string Str)
{
	local string validStr, htmlStr;

	validStr = Str;
	validStr = Substitute(validStr, "\\n\\n", "<br>", false);
	validStr = Substitute(validStr, "\\n", "<br1>", false);
	htmlStr = HtmlAddTableTD(validStr, "center", "center", 334, 50, "", true);
	HtmlSetTableTR(htmlStr);
	htmlSetTable(htmlStr, 0, 334, 50, "", 0, 0);
	return htmlSetHtmlStart(htmlStr);
}

function bool IsIncludeUserSelectCostItem()
{
	local int i;

	i = 0;
	while((i < _currentCostItemInfo.costSlotInfos.Length))
	{
		if((_currentCostItemInfo.costSlotInfos[i].selectedCostItem.bUserSelect == true))
		{
			return true;
		}
		i++;
	}
	return false;
}

function UpdateBuyWndControls()
{
	local TextureHandle buyWndBackTexture, optionTexture, specialOpTex;
	local WindowHandle buyWndOptionContainer;
	local TextBoxHandle optionTextBox;
	local HtmlHandle htmlTextBox;
	local bool isSucceedOption;

	buyWndBackTexture = GetTextureHandle((buy_Wnd.m_WindowNameWithFullPath $ ".BuyWndBG"));
	buyWndOptionContainer = GetWindowHandle((buy_Wnd.m_WindowNameWithFullPath $ ".RefineryOption_wnd"));
	htmlTextBox = GetHtmlHandle((buy_Wnd.m_WindowNameWithFullPath $ ".description_TextBox"));
	optionTextBox = GetTextBoxHandle((buyWndOptionContainer.m_WindowNameWithFullPath $ ".txtOptions"));
	optionTexture = GetTextureHandle((buyWndOptionContainer.m_WindowNameWithFullPath $ ".optionGradeTexture"));
	specialOpTex = GetTextureHandle((buyWndOptionContainer.m_WindowNameWithFullPath $ ".SpecialOptionEffect_BuyWnd"));
	isSucceedOption = false;
	if(((_successionInfo.isKeepOption && (_successionInfo.successionItemSId > 0)) && (_successionInfo.materialItemSId > 0)))
	{
		if(((_successionInfo.itemOption1 > 0) || (_successionInfo.itemOption2 > 0)))
		{
			isSucceedOption = true;
		}
	}
	if((isSucceedOption == true))
	{
		SetItemOptionControl(_successionInfo.itemOption1, _successionInfo.itemOption2, _successionInfo.itemOption3, optionTextBox, optionTexture, specialOpTex);
		buyWndOptionContainer.ShowWindow();
		buyWndBackTexture.SetTextureSize(362, 476);
		buyWndBackTexture.SetWindowSize(362, 476);
		htmlTextBox.LoadHtmlFromString(MakeHtmlTable(htmlAddText(GetSystemString(13276), "")));
		buyWndConfirmBtn.SetButtonName(645);
	}
	else
	{
		buyWndOptionContainer.HideWindow();
		buyWndBackTexture.SetTextureSize(362, 346);
		buyWndBackTexture.SetWindowSize(362, 346);
		if(IsIncludeUserSelectCostItem())
		{
			htmlTextBox.LoadHtmlFromString(MakeHtmlTable(((htmlAddText(GetSystemString(14964), "", getColorHexString(GTColor().Red)) $ "<br1>") $ htmlAddText(GetSystemString(13276), ""))));
		}
		else
		{
			htmlTextBox.LoadHtmlFromString(MakeHtmlTable(htmlAddText(GetSystemString(13276), "")));
		}
		buyWndConfirmBtn.SetButtonName(645);
	}
	if((_autoCraftInfo.useAutoCraft == true))
	{
		if((int(_autoCraftInfo.Type) == 1))
		{
			buyWndConfirmBtn.SetButtonName(14449);
			if((isLimitBuyType(GetSelectedProductData()) == true))
			{
				htmlTextBox.LoadHtmlFromString(MakeHtmlTable(htmlAddText(GetSystemString(14451), "")));
			}
			else
			{
				htmlTextBox.LoadHtmlFromString(MakeHtmlTable(htmlAddText(GetSystemString(14456), "")));
			}
		}
		else if((int(_autoCraftInfo.Type) == 2))
		{
			htmlTextBox.LoadHtmlFromString(MakeHtmlTable(htmlAddText(GetSystemString(14450), "")));
		}
	}
	return;
}

function RegisterSuccessionMaterialItem(bool isMaterial, int itemSId)
{
	if(((_successionInfo.isKeepOption != true) || (_successionInfo.isResultScene != false)))
	{
		return;
	}
	if((isMaterial == true))
	{
		if((_successionInfo.successionItemSId == 0))
		{
			_successionInfo.successionItemSId = itemSId;
		}
		else
		{
			_successionInfo.materialItemSId = itemSId;
		}
	}
	else
	{
		_successionInfo.successionItemSId = itemSId;
		_successionInfo.materialItemSId = 0;
	}
	UpdateSuccessionDialogControls();
	return;
}

function UnregisterSuccessionMaterialItem(bool isMaterial)
{
	if(((_successionInfo.isKeepOption != true) || (_successionInfo.isResultScene != false)))
	{
		return;
	}
	if((isMaterial == true))
	{
		_successionInfo.materialItemSId = 0;
	}
	else
	{
		_successionInfo.successionItemSId = 0;
		_successionInfo.materialItemSId = 0;
	}
	UpdateSuccessionDialogControls();
	return;
}

function ShowSuccessionDialog()
{
	ResetSuccessionDialogInfo();
	UpdateSuccessionDialogControls();
	successionWndContainer.ShowWindow();
	successionWnd.SetFocus();
	return;
}

function HideSuccessionDialog()
{
	successionWndContainer.HideWindow();
	return;
}

function ShowNeedItemSelectPopup(int Index)
{
	local array<PurchaseLimitCraftCostItemInfo> costItemInfos;
	local int MouseX, MouseY, posX, posY, buyNum;
	local PurchaseLimitCraftUIData craftUIData;
	local Vector pos;

	GetClientCursorPos(MouseX, MouseY);
	Global2Local(m_hOwnerWnd, MouseX, MouseY, posX, posY);
	posX = (posX - 584);
	posY = (posY - 570);
	craftUIData = GetSelectedProductData();
	switch(Index)
	{
		case 0:
			costItemInfos = craftUIData.CostItemSlot1;
			break;
		case 1:
			costItemInfos = craftUIData.CostItemSlot2;
			break;
		case 2:
			costItemInfos = craftUIData.CostItemSlot3;
			break;
		case 3:
			costItemInfos = craftUIData.CostItemSlot4;
			break;
		case 4:
			costItemInfos = craftUIData.CostItemSlot5;
			break;
		default:
			break;
	}
	buyNum = Max(int(ItemCount_EditBox.GetString()), 1);
	pos.X = float(posX);
	pos.Y = float(posY);
	pos = GetNeedItemSlelectPopupPos(pos);
	needItemSelectPopupScript.OpenWnd(costItemInfos, Index, buyNum, int(pos.X), int(pos.Y));
	return;
}

function Vector GetNeedItemSlelectPopupPos(Vector pos)
{
	local Vector closestPos, tmpPos;
	local float closestDistance, currentDistance;
	local int i;
	local array<Vector> defaultPositions;

	tmpPos.X = 18.0000000;
	tmpPos.Y = 64.0000000;
	defaultPositions[0] = tmpPos;
	tmpPos.X = 353.0000000;
	tmpPos.Y = 64.0000000;
	defaultPositions[1] = tmpPos;
	tmpPos.X = 18.0000000;
	tmpPos.Y = 104.0000000;
	defaultPositions[2] = tmpPos;
	tmpPos.X = 353.0000000;
	tmpPos.Y = 104.0000000;
	defaultPositions[3] = tmpPos;
	if((defaultPositions.Length == 0))
	{
		return pos;
	}
	closestPos = defaultPositions[0];
	closestDistance = VSize((pos - closestPos));
	i = 1;
	while((i < defaultPositions.Length))
	{
		currentDistance = VSize((pos - defaultPositions[i]));
		if((currentDistance < closestDistance))
		{
			closestDistance = currentDistance;
			closestPos = defaultPositions[i];
		}
		i++;
	}
	return closestPos;
}

function HideNeedItemSelectPopup()
{
	needItemSelectPopupScript.CloseWnd();
	return;
}

function SetItemOptionControl(int RefineryOp1, int RefineryOp2, int RefineryOp3, TextBoxHandle textBox, TextureHandle Texture, TextureHandle specialOpTex)
{
	local string strDesc1, strDesc2, strDesc3, descAll;
	local int ColorR, ColorG, ColorB, Quality;

	descAll = "";
	if(((RefineryOp1 != 0) || (RefineryOp2 != 0)))
	{
		Quality = GetRefineryGradeQuality(RefineryOp1, RefineryOp2, RefineryOp3);
		Texture.SetTexture(GetGradeTextureByQuality(Quality));
		if((Quality <= 0))
		{
			Texture.HideWindow();
		}
		else
		{
			Texture.ShowWindow();
		}
		ToolTip(GetScript("Tooltip")).GetRefineryColor(Quality, ColorR, ColorG, ColorB);
		if((RefineryOp1 != 0))
		{
			strDesc1 = "";
			strDesc2 = "";
			strDesc3 = "";
			if(Class'NWindow.UIDATA_REFINERYOPTION'.static.GetOptionDescription(RefineryOp1, strDesc1, strDesc2, strDesc3))
			{
				AddDesc(strDesc1, descAll);
				AddDesc(strDesc2, descAll);
				AddDesc(strDesc3, descAll);
			}
		}
		if((RefineryOp2 != 0))
		{
			strDesc1 = "";
			strDesc2 = "";
			strDesc3 = "";
			if(Class'NWindow.UIDATA_REFINERYOPTION'.static.GetOptionDescription(RefineryOp2, strDesc1, strDesc2, strDesc3))
			{
				AddDesc(strDesc1, descAll);
				AddDesc(strDesc2, descAll);
				AddDesc(strDesc3, descAll);
			}
		}
		if((RefineryOp3 != 0))
		{
			strDesc1 = "";
			strDesc2 = "";
			strDesc3 = "";
			if(Class'NWindow.UIDATA_REFINERYOPTION'.static.GetOptionDescription(RefineryOp3, strDesc1, strDesc2, strDesc3))
			{
				AddDesc(strDesc1, descAll);
				AddDesc(strDesc2, descAll);
				AddDesc(strDesc3, descAll);
			}
		}
		if((GetRefineryEffectLevel(RefineryOp1, RefineryOp2, RefineryOp3) != 0))
		{
			specialOpTex.ShowWindow();
		}
		else
		{
			specialOpTex.HideWindow();
		}
		textBox.SetTextColor(GetColor(ColorR, ColorG, ColorB, 255));
		textBox.SetText(descAll);
		if((descAll != ""))
		{
			Texture.ShowWindow();
		}
	}
	else
	{
		textBox.SetText(GetSystemString(14165));
		Texture.HideWindow();
		specialOpTex.HideWindow();
	}
	return;
}

function ShowAndFindItem(string findName, int Category)
{
	_findItemInfo.isWaitingResponse = true;
	_findItemInfo.findName = findName;
	_findItemInfo.Category = Category;
	if(m_hOwnerWnd.IsShowWindow())
	{
		OnShow();
	}
	else
	{
		m_hOwnerWnd.ShowWindow();
	}
	return;
}

function CheckFindItem()
{
	if((((_findItemInfo.isWaitingResponse == false) || (_findItemInfo.findName == "")) || (_findItemInfo.Category < 0)))
	{
		return;
	}
	tabGroupButton._GetGroupButtonsInstance()._setTopOrder(_findItemInfo.Category);
	EditBoxFind.SetString(_findItemInfo.findName);
	ClearAll();
	HandleItemNewList(-1);
	ResetFindItemInfo();
	return;
}

function ResetFindItemInfo()
{
	local FindItemInfo defaultInfo;

	_findItemInfo = defaultInfo;
	return;
}

function AddDesc(string Desc, out string descAll)
{
	if((Desc == ""))
	{
		return;
	}
	if((descAll != ""))
	{
		descAll = ((descAll $ "\\n") $ Desc);
	}
	else
	{
		descAll = Desc;
	}
	return;
}

function int GetSuccessionCostItemNum()
{
	local int i, COSTITEMNUM;

	i = 0;
	while((i < _successionInfo.CostItems.Length))
	{
		if((_successionInfo.CostItems[i].ItemClassID != 0))
		{
			COSTITEMNUM++;
		}
		i++;
	}
	return COSTITEMNUM;
}

function string GetGradeTextureByQuality(int Quality)
{
	switch(Quality)
	{
		case 1:
			return "L2UI_EPIC.RefineryWnd.RefineryWnd_Frame_Yellow";
			break;
		case 2:
			return "L2UI_EPIC.RefineryWnd.RefineryWnd_Frame_Blue";
			break;
		case 3:
			return "L2UI_EPIC.RefineryWnd.RefineryWnd_Frame_purple";
			break;
		case 4:
			return "L2UI_EPIC.RefineryWnd.RefineryWnd_Frame_Red";
			break;
		default:
			return "L2UI_EPIC.RefineryWnd.RefineryWnd_Frame_Red";
			break;
	}
}

event OnSuccessionRegistBtnClicked()
{
	if((((_successionInfo.isResultScene == false) && (_successionInfo.successionItemSId != 0)) && (_successionInfo.materialItemSId != 0)))
	{
		_successionInfo.isResultScene = true;
	}
	else
	{
		_successionInfo.isResultScene = false;
	}
	UpdateSuccessionDialogControls();
	return;
}

event OnSuccecssionConfirmBtnClicked()
{
	HideSuccessionDialog();
	SetCurrentCostItems();
	UpdateBuyWndControls();
	buy_Wnd.ShowWindow();
	return;
}

event OnSuccecssionCancelBtnClicked()
{
	_successionInfo.isResultScene = false;
	UpdateSuccessionDialogControls();
	return;
}

event OnDBClickItem(string strID, int Index)
{
	local ItemInfo targetItemInfo;

	if((Index < 0))
	{
		return;
	}
	if((strID == "SucceedItemWnd"))
	{
		successionCostItemWnd.GetItem(Index, targetItemInfo);
		RegisterSuccessionMaterialItem(true, targetItemInfo.Id.ServerID);
	}
	else if((strID == "Succeed_Item"))
	{
		UnregisterSuccessionMaterialItem(false);
	}
	else if((strID == "SucceedMaterial_Item"))
	{
		UnregisterSuccessionMaterialItem(true);
	}
	return;
}

event OnDropItemSource(string strTarget, ItemInfo Info)
{
	if((strTarget == "Console"))
	{
		if((Info.DragSrcName == "Succeed_Item"))
		{
			UnregisterSuccessionMaterialItem(false);
		}
		else if((Info.DragSrcName == "SucceedMaterial_Item"))
		{
			UnregisterSuccessionMaterialItem(true);
		}
	}
	return;
}

event OnDropItem(string strID, ItemInfo Info, int X, int Y)
{
	if((Info.ShortcutType == 4))
	{
		return;
	}
	if((Info.DragSrcName != "SucceedItemWnd"))
	{
		return;
	}
	if((strID == "Succeed_Item"))
	{
		RegisterSuccessionMaterialItem(false, Info.Id.ServerID);
	}
	else if((strID == "SucceedMaterial_Item"))
	{
		RegisterSuccessionMaterialItem(true, Info.Id.ServerID);
	}
	return;
}

event OnRClickItem(string strID, int Index)
{
	OnDBClickItem(strID, Index);
	return;
}

event OnNeedItemListButtonClicked(string btnName)
{
	local array<string> names;

	Split(btnName, "_", names);
	if(((names[0] == "expandBtn") || (names[0] == "invenSelectBtn")))
	{
		ShowNeedItemSelectPopup(int(names[1]));
	}
	return;
}

event OnNeedItemSelectPopupClicked(int Index, PurchaseLimitCraftCostItemInfo costInfo, ItemInfo inventItemInfo)
{
	UpdateCurrentCostItemInfo(Index, costInfo, inventItemInfo);
	SetCurrentCostItems();
	SetControlerBtns();
	return;
}

delegate int SortItemOptionDelegate(ItemInfo A, ItemInfo B)
{
	if((A.RefineryOp2 < B.RefineryOp2))
	{
		return -1;
	}
	return 0;
}

function StartAutoCraft()
{
	if(((_autoCraftInfo.useAutoCraft == true) && (int(_autoCraftInfo.uiState) == 0)))
	{
		_autoCraftInfo.uiState = ACProcess;
		_autoCraftInfo.craftSlotNum = pLShopItemDataList[GetCurrentSelectedIndex()].nSlotNum;
		EditBoxFind.DisableWindow();
		disableWnd.ShowWindow();
		disableWnd.SetFocus();
		ShowBuyWnd(false);
		CraftResult01_CostItem_Wnd.ShowWindow();
		CraftResult02_Gauge_Wnd.HideWindow();
		CraftResult03_Description_Wnd.HideWindow();
		AnimationStop();
		Craft_Btn.SetButtonName(141);
		passAnimationCheck.HideWindow();
		ShowAutoCraftBtn(false);
		craftDescTextBox.HideWindow();
		SetItemCountEditBox(INT64(1));
		AutoCraftCardToBack();
		StartAutoCraftTimer();
	}
	else
	{
		SetState(Normal);
	}
	return;
}

function ResultAutoCraft()
{
	KillAutoCraftTimer();
	if(((_autoCraftInfo.useAutoCraft == true) && (int(_autoCraftInfo.uiState) == 1)))
	{
		_autoCraftInfo.uiState = ACResult;
		EditBoxFind.DisableWindow();
		disableWnd.ShowWindow();
		disableWnd.SetFocus();
		ShowBuyWnd(false);
		CraftResult01_CostItem_Wnd.HideWindow();
		CraftResult02_Gauge_Wnd.HideWindow();
		CraftResult03_Description_Wnd.ShowWindow();
		Craft_Btn.SetButtonName(140);
		Craft_Btn.EnableWindow();
		Description_Text.SetText(GetSystemString(13296));
		passAnimationCheck.HideWindow();
		ShowAutoCraftBtn(false);
		autoCraftMinimizeBtn.HideWindow();
	}
	else
	{
		SetState(Normal);
	}
	Class'Interface.ShopLcoinCraftMinimizeWnd'.static.Inst().UpdateAutoCraftInfo(_autoCraftInfo);
	return;
}

function ResetAutoCraft()
{
	ResetFindItemInfo();
	return;
}

function StartAutoCraftTimer()
{
	if(m_hOwnerWnd.IsVisibility())
	{
		m_ObjectViewport.PlayAnimation(1);
	}
	if(true)
	{
		Class'Interface.ShopLcoinCraftMinimizeWnd'.static.Inst().StartCraftProgressBar();
	}
	KillAutoCraftTimer();
	m_hOwnerWnd.SetTimer(2, 1020);
	return;
}

function KillAutoCraftTimer()
{
	m_hOwnerWnd.KillTimer(2);
	return;
}

function AutoCraftCardToBack()
{
	local int i;
	local PurchaseLimitCraftUIData productData;

	productData = GetSelectedProductData();
	i = 0;
	while((i < productData.BuyItems.Length))
	{
		GetAutoCraftCardDisableTexture(i).ShowWindow();
		i++;
	}
	return;
}

function ShowAutoCraftBtn(bool isShow)
{
	if(isShow)
	{
		AutoCraft_Btn.ShowWindow();
		Craft_Btn.SetWindowSize(150, 36);
		Craft_Btn.MoveC(480, 748);
	}
	else
	{
		AutoCraft_Btn.HideWindow();
		Craft_Btn.SetWindowSize(215, 36);
		Craft_Btn.MoveC(520, 748);
	}
	return;
}

function UpdateAutoCraftBtn()
{
	if(((GetSelectedProductData().AutomaticType == 1) && ((int(CurrentState) == 0) || (int(CurrentState) == 1))))
	{
		ShowAutoCraftBtn(true);
	}
	else
	{
		ShowAutoCraftBtn(false);
	}
	return;
}

function UpdateAutoCraftInfoControls()
{
	local int autoCraftType;
	local PurchaseLimitCraftUIData productData;

	productData = GetSelectedProductData();
	autoCraftType = productData.AutomaticType;
	if((int(_autoCraftInfo.uiState) == 1))
	{
		if((autoCraftType == 1))
		{
			if((isLimitBuyType(productData) == true))
			{
				autoCraftInfoTextBox.SetText(GetSystemString(14452));
			}
			else
			{
				autoCraftInfoTextBox.SetText(GetSystemString(14457));
			}
		}
		else if((autoCraftType == 2))
		{
			autoCraftInfoTextBox.SetText(GetSystemString(14453));
		}
		autoCraftInfoContainer.ShowWindow();
		if(true)
		{
			autoCraftMinimizeBtn.ShowWindow();
		}
	}
	else
	{
		autoCraftInfoContainer.HideWindow();
		autoCraftMinimizeBtn.HideWindow();
	}
	if(((int(_autoCraftInfo.uiState) == 1) || (int(_autoCraftInfo.uiState) == 2)))
	{
		if((autoCraftType == 1))
		{
			autoCraftCntTitleTextBox.SetText(GetSystemMessage(13861));
			autoCraftCntTextBox.SetText(string(_autoCraftInfo.currentCount));
		}
		else if((autoCraftType == 2))
		{
			autoCraftCntTitleTextBox.SetText(GetSystemMessage(13861));
			autoCraftCntTextBox.SetText(((string(_autoCraftInfo.currentCount) $ "/") $ string(_autoCraftInfo.maxCount)));
		}
		autoCraftCntTitleTextBox.ShowWindow();
		autoCraftCntTextBox.ShowWindow();
	}
	else
	{
		autoCraftCntTitleTextBox.HideWindow();
		autoCraftCntTextBox.HideWindow();
	}
	Class'Interface.ShopLcoinCraftMinimizeWnd'.static.Inst().UpdateAutoCraftInfo(_autoCraftInfo);
	return;
}

function CheckAndRequestAutoCraft()
{
	local INT64 canBuyCount;
	local int SelectedIndex;

	SelectedIndex = GetCurrentSelectedIndex();
	canBuyCount = GetCountCanBuyByIndex(SelectedIndex, true, true);
	if((GetCanInventoryWeight() == false))
	{
		ResultAutoCraft();
		SetFailWnd(3646);
		return;
	}
	if((GetCanBUyByInvenEmpty(SelectedIndex) == 0))
	{
		ResultAutoCraft();
		SetFailWnd(3646);
		return;
	}
	if((canBuyCount == INT64(0)))
	{
		ResultAutoCraft();
		SetFailWnd(13863);
		return;
	}
	if(((_autoCraftInfo.useAutoCraft == true) && (int(_autoCraftInfo.uiState) == 1)))
	{
		RqPurchaseLimitShopItemBuyByAutoCraft();
	}
	return;
}

function CheckAndContinueAutoCraft(string param)
{
	local int i, ItemCount, itemIndex, ItemAmount, itemRankMax, tempCraftNum;
	local bool isLimitedItemCraft;
	local PurchaseLimitCraftUIData productData;

	ParseInt(param, "ItemCount", ItemCount);
	productData = GetSelectedProductData();
	_autoCraftInfo.currentCount++;
	i = 0;
	while((i < ItemCount))
	{
		ParseInt(param, ("itemIndex_" $ string(i)), itemIndex);
		itemRankMax = Max(itemRankMax, productData.BuyItems[itemIndex].ProductRank);
		ParseInt(param, ("ItemAmount_" $ string(i)), ItemAmount);
		if((itemIndex < 5))
		{
			tempCraftNum = _autoCraftInfo.craftNumArray[itemIndex];
			tempCraftNum = (tempCraftNum + ItemAmount);
			_autoCraftInfo.craftNumArray[itemIndex] = tempCraftNum;
			GetTexturehandleCraftCardNum(itemIndex).ShowWindow();
			GetAutoCraftCardDisableTexture(itemIndex).HideWindow();
			if(m_hOwnerWnd.IsVisibility())
			{
				GetAutoCraftCardAnimTexture(itemIndex).Play();
			}
			GetTexturehandleCraftCardNum(itemIndex).SetText(("x" $ string(tempCraftNum)));
			Class'Interface.ShopLcoinCraftMinimizeWnd'.static.Inst().UpdateBuySlot(itemIndex, tempCraftNum);
		}
		if((int(_autoCraftInfo.Type) == 1))
		{
			if((isLimitBuyType(productData) == true))
			{
				if(((itemIndex < productData.BuyItems.Length) && (ItemAmount > 0)))
				{
					if(productData.BuyItems[itemIndex].IsLimitBuy)
					{
						isLimitedItemCraft = true;
					}
				}
			}
			else if(((itemIndex == 0) && (ItemAmount > 0)))
			{
				isLimitedItemCraft = true;
			}
		}
		AnimationCardToFront(itemIndex);
		i++;
	}
	if(true)
	{
		switch(itemRankMax)
		{
			case 0:
				EffectViewport00.SetCameraDistance(500.0000000);
				playEffectViewPort("LineageEffect2.ui_upgrade_succ");
				PlaySound("ItemSound3.enchant_success");
				break;
			case 1:
				EffectViewport00.SetCameraDistance(360.0000000);
				playEffectViewPort("LineageEffect2.ui_upgrade_succ");
				PlaySound("ItemSound3.enchant_success");
				break;
			case 2:
				EffectViewport00.SetCameraDistance(600.0000000);
				playEffectViewPort("LineageEffect.d_firework_b");
				PlaySound("ItemSound2.C3_Firework_explosion");
				break;
			case 3:
			case 4:
				EffectViewport00.SetCameraDistance(730.0000000);
				playEffectViewPort("LineageEffect_br.br_e_firebox_fire_b");
				PlaySound("SkillSound14.d_firework_a");
				break;
			default:
				break;
		}
	}
	UpdateAutoCraftInfoControls();
	if(((int(_autoCraftInfo.Type) == 1) && (isLimitedItemCraft == true)))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13865));
		ResultAutoCraft();
		return;
	}
	if(((int(_autoCraftInfo.Type) == 2) && (_autoCraftInfo.maxCount <= _autoCraftInfo.currentCount)))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13865));
		ResultAutoCraft();
		return;
	}
	StartAutoCraftTimer();
	return;
}

function SetAutoCraftMinimize(bool isMinimize)
{
	if(isMinimize)
	{
		m_hOwnerWnd.SetVisibility(false);
		Class'Interface.ShopLcoinCraftMinimizeWnd'.static.Inst().OpenWindow();
	}
	else
	{
		m_hOwnerWnd.SetVisibility(true);
		CloseAutoCraftMinimizeWnd();
	}
	return;
}

function CloseAutoCraftMinimizeWnd()
{
	if(true)
	{
		Class'Interface.ShopLcoinCraftMinimizeWnd'.static.Inst().CloseWindow();
	}
	return;
}

function NtAutoCraftResult(string param)
{
	local int Result;

	ParseInt(param, "Result", Result);
	switch(Result)
	{
		case 0:
			CheckAndContinueAutoCraft(param);
			API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST();
			break;
		case 7:
		case 8:
			ResultAutoCraft();
			API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST();
			SetFailWnd(3646);
			break;
		case 6:
			ResultAutoCraft();
			API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST();
			SetFailWnd(13864);
			break;
		case 2:
			ResultAutoCraft();
			API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST();
			SetFailWnd(13863);
			break;
		case 5:
			ResultAutoCraft();
			API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST();
			SetFailWnd(6020);
			break;
		case 1:
		case 3:
		case 4:
		case 11:
		default:
			ResultAutoCraft();
			API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST();
			SetFailWnd(4334);
			break;
	}
	return;
}
