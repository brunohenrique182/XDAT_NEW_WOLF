class ShopLcoinCraftNeedItemSelectPopup extends UICommonAPI;

struct CraftNeedItemInfo
{
	var PurchaseLimitCraftCostItemInfo costInfo;
	var ItemInfo ItemInfo;
	var bool canBuy;
	var INT64 invenCount;
};

var WindowHandle Me;
var WindowHandle richListWndContainer;
var WindowHandle itemWndContainer;
var UIControlNeedItemListCraft needItemScript;
var RichListCtrlHandle needItemRichList;
var ItemWindowHandle ItemWnd;
var ButtonHandle backBtn;
var array<CraftNeedItemInfo> _needItems;
var PurchaseLimitCraftCostItemInfo _userSelectCostInfo;
var int _buyNum;
var int _index;
//var delegate<DelegateOnNeedtemClick> __DelegateOnNeedtemClick__Delegate;
//var delegate<OnSortCanBuy> __OnSortCanBuy__Delegate;

delegate DelegateOnNeedtemClick(int Index, PurchaseLimitCraftCostItemInfo costInfo, ItemInfo InvenItemInfo)
{
	return;
}

function InitWnd(WindowHandle wnd)
{
	local string ownerFullPath;

	m_hOwnerWnd = wnd;
	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	backBtn = GetButtonHandle((ownerFullPath $ ".Close_Btn"));
	itemWndContainer = GetWindowHandle((ownerFullPath $ ".NeedItem_InventoryWnd"));
	ItemWnd = GetItemWindowHandle((itemWndContainer.m_WindowNameWithFullPath $ ".NeedItemItemWnd"));
	backBtn = GetButtonHandle((ownerFullPath $ ".Back_Btn"));
	richListWndContainer = GetWindowHandle((ownerFullPath $ ".NeedItem_RichListCtrlWnd"));
	richListWndContainer.SetScript("UIControlNeedItemListCraft");
	needItemScript = UIControlNeedItemListCraft(richListWndContainer.GetScript());
	needItemRichList = GetRichListCtrlHandle((richListWndContainer.m_WindowNameWithFullPath $ ".NeedItem_RichListCtrl"));
	needItemScript.SetRichListControler(needItemRichList);
	needItemRichList.SetUseStripeBackTexture(true);
	needItemRichList.SetSelectedSelTooltip(false);
	needItemRichList.SetAppearTooltipAtMouseX(true);
	needItemRichList.SetSelectable(true);
	needItemRichList.SetUseSelectionTexture(true);
	needItemRichList.SetTooltipType("UIControlNeedItemList");
	needItemScript.DelegateClickListCtrlRecord = OnNeedItemListClick;
	return;
}

function SetNeedItems(array<PurchaseLimitCraftCostItemInfo> needItems, int buyNum)
{
	local int i;
	local CraftNeedItemInfo needItemInfo;
	local ItemInfo tempItemInfo;
	local PurchaseLimitCraftCostItemInfo costItemInfo;

	_needItems.Length = 0;
	_buyNum = buyNum;
	i = 0;
	while((i < needItems.Length))
	{
		costItemInfo = needItems[i];
		if((costItemInfo.ItemClassID == -800))
		{
			tempItemInfo.Name = GetSystemString(2492);
			tempItemInfo.IconName = "icon.etc_sayha_point_01";
			tempItemInfo.Enchanted = 0;
			tempItemInfo.ItemType = -1;
			tempItemInfo.Id.ClassID = 0;
			tempItemInfo.IsBlessedItem = false;
			tempItemInfo.ItemNum = costItemInfo.Count;
		}
		else
		{
			tempItemInfo = GetItemInfoByClassID(costItemInfo.ItemClassID);
			tempItemInfo.Enchanted = int(costItemInfo.Enchant);
			tempItemInfo.IsBlessedItem = costItemInfo.IsBlessedItem;
			tempItemInfo.ItemNum = costItemInfo.Count;
		}
		needItemInfo.ItemInfo = tempItemInfo;
		needItemInfo.costInfo = costItemInfo;
		needItemInfo.invenCount = getInstanceL2Util().GetCraftInventoryHaveNum(costItemInfo.ItemClassID, int(costItemInfo.Enchant), costItemInfo.IsBlessedItem);
		if(((tempItemInfo.ItemNum * INT64(buyNum)) <= needItemInfo.invenCount))
		{
			needItemInfo.canBuy = true;
		}
		else
		{
			needItemInfo.canBuy = false;
		}
		_needItems[i] = needItemInfo;
		i++;
	}
	// _needItems.Sort(OnSortCanBuy);   // array.Sort() unsupported by this compiler
	UpdateNeedItemList();
	return;
}

function OpenWnd(array<PurchaseLimitCraftCostItemInfo> needItems, int Index, int buyNum, int posX, int posY)
{
	if(Me.IsShowWindow())
	{
		if((_index == Index))
		{
			Me.HideWindow();
			return;
		}
	}
	_index = Index;
	SetNeedItems(needItems, buyNum);
	Me.MoveC(posX, posY);
	if(((_needItems.Length == 1) && (_needItems[0].costInfo.bUserSelect == true)))
	{
		if((_needItems[0].canBuy == true))
		{
			SetUserSelectItemInfo(_needItems[0].costInfo);
			SetUserSelectMode(true, true);
		}
		else
		{
			return;
		}
	}
	else
	{
		SetUserSelectMode(false);
	}
	needItemRichList.SetSelectedIndex(0, true);
	needItemRichList.SetSelectedIndex(-1, false);
	Me.ShowWindow();
	return;
}

function CloseWnd()
{
	Me.HideWindow();
	ResetInfos();
	return;
}

delegate int OnSortCanBuy(CraftNeedItemInfo A, CraftNeedItemInfo B)
{
	if((int(A.canBuy) < int(B.canBuy)))
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

function UpdateNeedItemList()
{
	local int i;
	local INT64 ItemNum;
	local CraftNeedItemInfo needItemInfo;
	local bool isShowInvenIcon;

	needItemScript.StartNeedItemList(6);
	needItemScript.SetBuyNum(INT64(_buyNum));
	i = 0;
	while((i < _needItems.Length))
	{
		needItemInfo = _needItems[i];
		if(needItemInfo.canBuy)
		{
			needItemInfo.ItemInfo.ForeTexture = "";
		}
		else
		{
			needItemInfo.ItemInfo.ForeTexture = "L2UI_CT1.WindowDisable_BG";
		}
		if((needItemInfo.costInfo.bUserSelect && (needItemInfo.invenCount > INT64(1))))
		{
			isShowInvenIcon = true;
		}
		else
		{
			isShowInvenIcon = false;
		}
		ItemNum = needItemInfo.ItemInfo.ItemNum;
		needItemScript.AddCraftNeedItemInfo(needItemInfo.ItemInfo, ItemNum, needItemInfo.invenCount, "", false, isShowInvenIcon, !needItemInfo.canBuy);
		i++;
	}
	return;
}

function SetUserSelectMode(bool userSelectMode, optional bool onlyUserSelect)
{
	if(userSelectMode)
	{
		itemWndContainer.ShowWindow();
		richListWndContainer.HideWindow();
		if(onlyUserSelect)
		{
			backBtn.HideWindow();
		}
		else
		{
			backBtn.ShowWindow();
		}
	}
	else
	{
		itemWndContainer.HideWindow();
		richListWndContainer.ShowWindow();
		backBtn.HideWindow();
	}
	return;
}

function SetUserSelectItemInfo(PurchaseLimitCraftCostItemInfo costItemInfo)
{
	local int i;
	local array<ItemInfo> invenItems;
	local ItemInfo invenItem;

	_userSelectCostInfo = costItemInfo;
	ItemWnd.Clear();
	Class'NWindow.UIDATA_INVENTORY'.static.GetSpecificItemByScriptFilter(5, costItemInfo.ItemClassID, int(costItemInfo.Enchant), costItemInfo.IsBlessedItem, invenItems);
	i = 0;
	while((i < invenItems.Length))
	{
		invenItem = invenItems[i];
		ItemWnd.AddItem(invenItem);
		i++;
	}
	return;
}

function ResetInfos()
{
	_needItems.Length = 0;
	_buyNum = 0;
	_index = -1;
	needItemScript.CleariObjects();
	ItemWnd.Clear();
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "Back_btn":
			SetUserSelectMode(false);
			break;
		case "Close_btn":
			CloseWnd();
			break;
		default:
			break;
	}
	return;
}

event OnNeedItemListClick(int SelectedIndex)
{
	local CraftNeedItemInfo needItemInfo;
	local array<ItemInfo> ItemInfos;

	if((_needItems.Length < SelectedIndex))
	{
		return;
	}
	needItemInfo = _needItems[SelectedIndex];
	if((needItemInfo.canBuy == false))
	{
		needItemRichList.SetSelectedIndex(-1, false);
		return;
	}
	else if((needItemInfo.costInfo.bUserSelect == true))
	{
		if((needItemInfo.invenCount == INT64(1)))
		{
			Class'NWindow.UIDATA_INVENTORY'.static.GetSpecificItemByScriptFilter(5, needItemInfo.costInfo.ItemClassID, int(needItemInfo.costInfo.Enchant), needItemInfo.costInfo.IsBlessedItem, ItemInfos);
			if((ItemInfos.Length > 0))
			{
				DelegateOnNeedtemClick(_index, needItemInfo.costInfo, ItemInfos[0]);
			}
			CloseWnd();
		}
		else
		{
			SetUserSelectMode(true);
			SetUserSelectItemInfo(needItemInfo.costInfo);
		}
	}
	else
	{
		DelegateOnNeedtemClick(_index, needItemInfo.costInfo, needItemInfo.ItemInfo);
		CloseWnd();
	}
	return;
}

event OnClickItem(string strID, int Index)
{
	local ItemInfo costItemInfo;

	ItemWnd.GetItem(Index, costItemInfo);
	DelegateOnNeedtemClick(_index, _userSelectCostInfo, costItemInfo);
	CloseWnd();
	return;
}

event OnRClickItem(string strID, int Index)
{
	OnClickItem(strID, Index);
	return;
}
