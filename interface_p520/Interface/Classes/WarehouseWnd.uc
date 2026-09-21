class WarehouseWnd extends UICommonAPI;

const KEEPING_PRICE = 30;
const KEEPING_PRICE_LCOIN = 100;
const DEFAULT_MAX_COUNT = 200;
const DIALOG_TOP_TO_BOTTOM = 111;
const DIALOG_BOTTOM_TO_TOP = 222;

enum WarehouseCategory
{
	WC_None,                        // 0
	WC_Private,                     // 1
	WC_Clan,                        // 2
	WC_Castle,                      // 3
	WC_Etc                          // 4
};

enum WarehouseType
{
	WT_Deposit,                     // 0
	WT_Withdraw                     // 1
};

var WarehouseCategory m_category;
var WarehouseType m_type;
var int m_maxPrivateCount;
var int m_maxInventoryCount;
var int m_curWarehouseCount;
var int m_curInventoryCount;
var int m_numPossibleSlotCount;
var string m_Windowname;
var ItemWindowHandle m_topList;
var ItemWindowHandle m_bottomList;
var WindowHandle m_dialogWnd;
var string coinString;
var array<int> hasStackableItemArray;
var WindowHandle disableWnd;
var INT64 KeepingNeedLCoin;
var WindowHandle UIControlDialogAsset;

function addHasStackableItemArray(int ClassID)
{
	if((findHasStackableItemArray(ClassID) == -1))
	{
		hasStackableItemArray[hasStackableItemArray.Length] = ClassID;
	}
	return;
}

function int findHasStackableItemArray(int ClassID)
{
	local int i, returnV;

	returnV = -1;
	i = 0;
	while((i < hasStackableItemArray.Length))
	{
		if((hasStackableItemArray[i] == ClassID))
		{
			returnV = i;
			break;
		}
		i++;
	}
	return returnV;
}

function removeHasStackableItemArray(int ClassID)
{
	local int Index;

	Index = findHasStackableItemArray(ClassID);
	if((Index != -1))
	{
		hasStackableItemArray.Remove(Index, 1);
	}
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(2100);
	RegisterEvent(2110);
	RegisterEvent(2111);
	RegisterEvent(2070);
	RegisterEvent(1710);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	InitHandle();
	return;
}

function OnShow()
{
	hasStackableItemArray.Remove(0, hasStackableItemArray.Length);
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	OnClickCancelDialog();
	PlayConsoleSound(IFST_WINDOW_OPEN);
	return;
}

function OnHide()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	hasStackableItemArray.Remove(0, hasStackableItemArray.Length);
	return;
}

function InitHandle()
{
	if((1 == 0))
	{
		m_dialogWnd = GetHandle("DialogBox");
		m_topList = ItemWindowHandle(GetHandle((m_Windowname $ ".TopList")));
		m_bottomList = ItemWindowHandle(GetHandle((m_Windowname $ ".BottomList")));
	}
	else
	{
		m_dialogWnd = GetWindowHandle("DialogBox");
		m_topList = GetItemWindowHandle((m_Windowname $ ".TopList"));
		m_bottomList = GetItemWindowHandle((m_Windowname $ ".BottomList"));
	}
	disableWnd = GetWindowHandle((m_Windowname $ ".DisableWnd"));
	UIControlDialogAsset = GetWindowHandle((m_Windowname $ ".DisableWnd.UIControlDialogAsset"));
	initDialogAssetes();
	m_topList.SetScrollBarPosition(0, 17, 0);
	return;
}

function initDialogAssetes()
{
	local UIControlDialogAssets popupExpandScript;

	popupExpandScript = Class'Interface.UIControlDialogAssets'.static.InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.UIControlDialogAsset")));
	disableWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd"));
	popupExpandScript.SetDisableWindow(disableWnd);
	Class'NWindow.UIAPI_WINDOW'.static.SetAlwaysOnTop((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd"), false);
	return;
}

function UIControlDialogAssets GetDialogAssetScript()
{
	local WindowHandle popExpandWnd;

	popExpandWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.UIControlDialogAsset"));
	return UIControlDialogAssets(popExpandWnd.GetScript());
}

function ShowDialogAskGetLcoin()
{
	GetDialogAssetScript().SetDialogDesc(GetSystemString(14740));
	GetDialogAssetScript().SetUseNeedItem(true);
	GetDialogAssetScript().StartNeedItemList(1);
	GetDialogAssetScript().AddNeedItemClassID(91663, KeepingNeedLCoin);
	GetDialogAssetScript().SetItemNum(1);
	GetDialogAssetScript().Show();
	GetDialogAssetScript().DelegateOnClickBuy = onClickDialog;
	GetDialogAssetScript().DelegateOnCancel = OnClickCancelDialog;
	return;
}

function onClickDialog()
{
	HandleOKButton();
	GetDialogAssetScript().Hide();
	return;
}

function OnClickCancelDialog()
{
	GetDialogAssetScript().Hide();
	return;
}

function Clear()
{
	m_type = WT_Deposit;
	m_category = WC_None;
	m_topList.Clear();
	m_bottomList.Clear();
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".PriceText"), "0");
	Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString((m_Windowname $ ".PriceText"), "");
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".AdenaText"), "0");
	Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString((m_Windowname $ ".AdenaText"), "");
	Class'NWindow.UIAPI_INVENWEIGHT'.static.ZeroWeight("WarehouseWnd.InvenWeight");
	KeepingNeedLCoin = INT64(0);
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 2100:
			HandleOpenWindow(param);
			break;
		case 2110:
			HandleAddItem(param);
			break;
		case 2111:
			HandleDeleteItem(param);
			break;
		case 2070:
			HandleSetMaxCount(param);
			break;
		case 1710:
			HandleDialogOK();
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string ControlName)
{
	if((ControlName == "OKButton"))
	{
		if(((((int(m_type) == 0) && IsAdenServer()) && (int(m_category) == 2)) && (m_bottomList.GetItemNum() > 0)))
		{
			ShowDialogAskGetLcoin();
		}
		else
		{
			HandleOKButton();
		}
	}
	else if((ControlName == "CancelButton"))
	{
		Clear();
		HideWindow(m_Windowname);
	}
	else if((ControlName == "SortButton"))
	{
		getInstanceL2Util().SortItem(m_topList);
	}
	return;
}

function bool HasStackableItemCheck(int Category, int ItemClassID)
{
	local bool bReturn;

	bReturn = false;
	if((int(m_type) == 0))
	{
		bReturn = HasStackableItemInWareHouse(Category, ItemClassID);
		Debug(((("HasStackableItemInWareHouse " @ string(Category)) @ " , ") @ string(ItemClassID)));
	}
	else
	{
		bReturn = HasStackableItemInInventory(Category, ItemClassID);
		Debug(((("HasStackableItemInInventory " @ string(Category)) @ " , ") @ string(ItemClassID)));
	}
	return bReturn;
}

function OnDBClickItem(string ControlName, int Index)
{
	local ItemInfo Info;
	local int nItemCount;

	if((ControlName == "TopList"))
	{
		if((Index >= 0))
		{
			m_topList.GetSelectedItem(Info);
			Debug(("hasStackableItemArray.Length" @ string(hasStackableItemArray.Length)));
			if((m_bottomList.GetItemNum() > 0))
			{
				nItemCount = (m_bottomList.GetItemNum() - hasStackableItemArray.Length);
			}
			else
			{
				nItemCount = 0;
			}
			if(((m_numPossibleSlotCount > nItemCount) || ((HasStackableItemCheck(int(m_category), Info.Id.ClassID) && IsStackableItem(Info.ConsumeType)) && (m_numPossibleSlotCount >= nItemCount))))
			{
				MoveItemTopToBottom(Index, Class'NWindow.InputAPI'.static.IsAltPressed());
			}
			else if((int(m_type) == 0))
			{
				AddSystemMessage(3674);
			}
			else
			{
				AddSystemMessage(3675);
			}
		}
	}
	else if((ControlName == "BottomList"))
	{
		MoveItemBottomToTop(Index, Class'NWindow.InputAPI'.static.IsAltPressed());
	}
	return;
}

function OnClickItem(string ControlName, int Index)
{
	if((ControlName == "TopList"))
	{
		if((DialogIsMine() && m_dialogWnd.IsShowWindow()))
		{
			DialogHide();
			m_dialogWnd.HideWindow();
		}
	}
	return;
}

function OnDropItem(string strID, ItemInfo Info, int X, int Y)
{
	local int Index, nItemCount;

	Debug(("OnDropItem.Enchanted : " @ string(Info.Enchanted)));
	if(((strID == "TopList") && (Info.DragSrcName == "BottomList")))
	{
		Index = m_bottomList.FindItemWithAllProperty(Info);
		if((Index >= 0))
		{
			MoveItemBottomToTop(Index, (Info.AllItemCount > INT64(0)));
		}
	}
	else if(((strID == "BottomList") && (Info.DragSrcName == "TopList")))
	{
		Index = m_topList.FindItemWithAllProperty(Info);
		if((m_bottomList.GetItemNum() > 0))
		{
			nItemCount = (m_bottomList.GetItemNum() - hasStackableItemArray.Length);
		}
		else
		{
			nItemCount = 0;
		}
		if((Index >= 0))
		{
			if(((m_numPossibleSlotCount > nItemCount) || ((HasStackableItemCheck(int(m_category), Info.Id.ClassID) && IsStackableItem(Info.ConsumeType)) && (m_numPossibleSlotCount >= nItemCount))))
			{
				MoveItemTopToBottom(Index, (Info.AllItemCount > INT64(0)));
			}
			else if((int(m_type) == 0))
			{
				AddSystemMessage(3674);
			}
			else
			{
				AddSystemMessage(3675);
			}
		}
	}
	return;
}

function MoveItemTopToBottom(int Index, bool bAllItem)
{
	local ItemInfo topInfo, bottomInfo;
	local int bottomIndex;

	if(m_topList.GetItem(Index, topInfo))
	{
		if(((!bAllItem && IsStackableItem(topInfo.ConsumeType)) && (topInfo.ItemNum > INT64(1))))
		{
			DialogSetID(111);
			DialogSetReservedItemID(topInfo.Id);
			DialogSetParamInt64(topInfo.ItemNum);
			DialogSetDefaultOK();
			DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), topInfo.Name, ""));
			DialogSetInputlimit(topInfo.ItemNum);
		}
		else
		{
			bottomIndex = m_bottomList.FindItem(topInfo.Id);
			if(((bottomIndex != -1) && IsStackableItem(topInfo.ConsumeType)))
			{
				m_bottomList.GetItem(bottomIndex, bottomInfo);
				(bottomInfo.ItemNum += topInfo.ItemNum);
				m_bottomList.SetItem(bottomIndex, bottomInfo);
			}
			else
			{
				m_bottomList.AddItem(topInfo);
			}
			m_topList.DeleteItem(Index);
			if((int(m_type) == 1))
			{
				Class'NWindow.UIAPI_INVENWEIGHT'.static.AddWeight("WarehouseWnd.InvenWeight", (topInfo.ItemNum * INT64(topInfo.Weight)));
			}
			else if((int(m_type) == 0))
			{
				Class'NWindow.UIAPI_INVENWEIGHT'.static.ReduceWeight("WarehouseWnd.InvenWeight", (topInfo.ItemNum * INT64(topInfo.Weight)));
			}
			if(HasStackableItemCheck(int(m_category), topInfo.Id.ClassID))
			{
				addHasStackableItemArray(topInfo.Id.ClassID);
			}
			AdjustPrice();
			AdjustCount();
		}
	}
	return;
}

function MoveItemBottomToTop(int Index, bool bAllItem)
{
	local ItemInfo bottomInfo, topInfo;
	local int topIndex;

	if(m_bottomList.GetItem(Index, bottomInfo))
	{
		if(((!bAllItem && IsStackableItem(bottomInfo.ConsumeType)) && (bottomInfo.ItemNum > INT64(1))))
		{
			DialogSetID(222);
			DialogSetReservedItemID(bottomInfo.Id);
			DialogSetParamInt64(bottomInfo.ItemNum);
			DialogSetDefaultOK();
			DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), bottomInfo.Name, ""));
			DialogSetInputlimit(bottomInfo.ItemNum);
		}
		else
		{
			topIndex = m_topList.FindItem(bottomInfo.Id);
			if(((topIndex != -1) && IsStackableItem(bottomInfo.ConsumeType)))
			{
				m_topList.GetItem(topIndex, topInfo);
				(topInfo.ItemNum += bottomInfo.ItemNum);
				m_topList.SetItem(topIndex, topInfo);
			}
			else
			{
				m_topList.AddItem(bottomInfo);
			}
			m_bottomList.DeleteItem(Index);
			if((int(m_type) == 1))
			{
				Class'NWindow.UIAPI_INVENWEIGHT'.static.ReduceWeight("WarehouseWnd.InvenWeight", (bottomInfo.ItemNum * INT64(bottomInfo.Weight)));
			}
			else if((int(m_type) == 0))
			{
				Class'NWindow.UIAPI_INVENWEIGHT'.static.AddWeight("WarehouseWnd.InvenWeight", (bottomInfo.ItemNum * INT64(bottomInfo.Weight)));
			}
			if((findHasStackableItemArray(bottomInfo.Id.ClassID) != -1))
			{
				removeHasStackableItemArray(bottomInfo.Id.ClassID);
			}
			AdjustPrice();
			AdjustCount();
		}
	}
	return;
}

function HandleDialogOK()
{
	local int Id, Index, topIndex;
	local INT64 Num;
	local ItemInfo Info, topInfo;
	local ItemID cID;

	if(DialogIsMine())
	{
		Id = DialogGetID();
		Num = INT64(DialogGetString());
		cID = DialogGetReservedItemID();
		if(((Id == 111) && (Num > INT64(0))))
		{
			topIndex = m_topList.FindItem(cID);
			if((topIndex >= 0))
			{
				m_topList.GetItem(topIndex, topInfo);
				Num = Min64(Num, topInfo.ItemNum);
				Index = m_bottomList.FindItem(cID);
				if((Index >= 0))
				{
					m_bottomList.GetItem(Index, Info);
					(Info.ItemNum += Num);
					m_bottomList.SetItem(Index, Info);
				}
				else
				{
					Info = topInfo;
					Info.ItemNum = Num;
					Info.bShowCount = false;
					m_bottomList.AddItem(Info);
				}
				if((int(m_type) == 1))
				{
					Class'NWindow.UIAPI_INVENWEIGHT'.static.AddWeight("WarehouseWnd.InvenWeight", (Num * INT64(Info.Weight)));
				}
				else if((int(m_type) == 0))
				{
					Class'NWindow.UIAPI_INVENWEIGHT'.static.ReduceWeight("WarehouseWnd.InvenWeight", (Num * INT64(Info.Weight)));
				}
				(topInfo.ItemNum -= Num);
				if((topInfo.ItemNum <= INT64(0)))
				{
					m_topList.DeleteItem(topIndex);
				}
				else
				{
					m_topList.SetItem(topIndex, topInfo);
				}
				if(HasStackableItemCheck(int(m_category), topInfo.Id.ClassID))
				{
					addHasStackableItemArray(topInfo.Id.ClassID);
				}
			}
		}
		else if(((Id == 222) && (Num > INT64(0))))
		{
			Index = m_bottomList.FindItem(cID);
			if((Index >= 0))
			{
				m_bottomList.GetItem(Index, Info);
				Num = Min64(Num, Info.ItemNum);
				(Info.ItemNum -= Num);
				if((Info.ItemNum > INT64(0)))
				{
					m_bottomList.SetItem(Index, Info);
				}
				else
				{
					if((findHasStackableItemArray(Info.Id.ClassID) != -1))
					{
						removeHasStackableItemArray(Info.Id.ClassID);
					}
					m_bottomList.DeleteItem(Index);
				}
				topIndex = m_topList.FindItem(cID);
				if(((topIndex >= 0) && IsStackableItem(Info.ConsumeType)))
				{
					m_topList.GetItem(topIndex, topInfo);
					(topInfo.ItemNum += Num);
					m_topList.SetItem(topIndex, topInfo);
				}
				else
				{
					Info.ItemNum = Num;
					m_topList.AddItem(Info);
				}
				if((int(m_type) == 1))
				{
					Class'NWindow.UIAPI_INVENWEIGHT'.static.ReduceWeight("WarehouseWnd.InvenWeight", (Num * INT64(Info.Weight)));
				}
				else if((int(m_type) == 0))
				{
					Class'NWindow.UIAPI_INVENWEIGHT'.static.AddWeight("WarehouseWnd.InvenWeight", (Num * INT64(Info.Weight)));
				}
			}
		}
		AdjustPrice();
		AdjustCount();
	}
	return;
}

function HandleOpenWindow(string param)
{
	local string Type;
	local int tmpInt, ItemCount;
	local string Adenastring;
	local WindowHandle m_inventoryWnd;
	local INT64 money;

	if((1 == 0))
	{
		m_inventoryWnd = GetHandle("InventoryWnd");
	}
	else
	{
		m_inventoryWnd = GetWindowHandle("InventoryWnd");
	}
	Clear();
	ParseString(param, "type", Type);
	ParseInt(param, "category", tmpInt);
	m_category = WarehouseCategory(tmpInt);
	ParseINT64(param, "money", money);
	ParseInt(param, "itemCount", ItemCount);
	Debug(("HandleOpenWindow" @ param));
	switch(m_category)
	{
		case WC_Private:
			setWindowTitleBySysStringNum(1216);
			break;
		case WC_Clan:
			setWindowTitleBySysStringNum(1217);
			break;
		case WC_Castle:
			setWindowTitleBySysStringNum(1218);
			break;
		case WC_Etc:
			setWindowTitleBySysStringNum(131);
			break;
		default:
			break;
	}
	coinString = setIconChange();
	if((Type == "deposit"))
	{
		m_type = WT_Deposit;
		m_curWarehouseCount = ItemCount;
	}
	else if((Type == "withdraw"))
	{
		m_type = WT_Withdraw;
		m_curInventoryCount = ItemCount;
	}
	Adenastring = MakeCostString(string(money));
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".AdenaText"), Adenastring);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString((m_Windowname $ ".AdenaText"), (ConvertNumToTextNoAdena(string(money)) @ coinString));
	ShowWindow(m_Windowname);
	Class'NWindow.UIAPI_WINDOW'.static.SetFocus(m_Windowname);
	if((int(m_type) == 0))
	{
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".TopText"), GetSystemString(138));
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".BottomText"), GetSystemString(132));
	}
	else if((int(m_type) == 1))
	{
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".TopText"), GetSystemString(132));
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".BottomText"), GetSystemString(133));
	}
	AdjustCount();
	ShowWindow((m_Windowname $ ".BottomCountText"));
	return;
}

function string setIconChange()
{
	local string coinStr;

	if((IsAdenServer() && (int(m_category) == 2)))
	{
		GetMeTexture("AdenaIcon").SetTexture("L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Icon_Lcoin");
		GetMeTexture("PriceAdenaIcon").SetTexture("L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Icon_Lcoin");
		GetMeTextBox("AdenaConstText").SetText(GetSystemString(14082));
		coinStr = GetSystemString(3931);
	}
	else
	{
		GetMeTextBox("AdenaConstText").SetText(GetSystemString(134));
		GetMeTexture("AdenaIcon").SetTexture("L2UI_CT1.Icon_DF_Common_Adena");
		GetMeTexture("PriceAdenaIcon").SetTexture("L2UI_CT1.Icon_DF_Common_Adena");
		coinStr = GetSystemString(469);
	}
	return coinStr;
}

function HandleAddItem(string param)
{
	local ItemInfo Info;

	ParamToItemInfo(param, Info);
	if(isCollectionItem(Info))
	{
		Info.ForeTexture = "L2UI_EPIC.Icon.IconPanel_coll";
	}
	m_topList.AddItem(Info);
	AdjustCount();
	return;
}

function HandleDeleteItem(string param)
{
	local int Index;
	local ItemInfo Info;

	ParamToItemInfo(param, Info);
	Index = m_topList.FindItem(Info.Id);
	if((Index != -1))
	{
		m_topList.DeleteItem(Index);
	}
	Index = m_bottomList.FindItem(Info.Id);
	if((Index != -1))
	{
		m_bottomList.DeleteItem(Index);
	}
	AdjustCount();
	return;
}

function AdjustPrice()
{
	local string needNum;
	local int Count;

	if((int(m_type) == 0))
	{
		Count = m_bottomList.GetItemNum();
		if((IsAdenServer() && (int(m_category) == 2)))
		{
			KeepingNeedLCoin = INT64((Count * 100));
			needNum = MakeCostString(string((Count * 100)));
		}
		else
		{
			needNum = MakeCostString(string((Count * 30)));
		}
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".PriceText"), needNum);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString((m_Windowname $ ".PriceText"), (ConvertNumToTextNoAdena(needNum) @ coinString));
	}
	return;
}

function AdjustCount()
{
	local int Num, maxNum, numPossibleSlot;

	if((int(m_category) == 1))
	{
		maxNum = m_maxPrivateCount;
	}
	else
	{
		maxNum = 200;
	}
	if((int(m_type) == 0))
	{
		Num = m_bottomList.GetItemNum();
		numPossibleSlot = (maxNum - m_curWarehouseCount);
		if((numPossibleSlot < 0))
		{
			numPossibleSlot = 0;
		}
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".BottomCountText"), (((("(" $ string((Num - hasStackableItemArray.Length))) $ "/") $ string(numPossibleSlot)) $ ")"));
	}
	else if((int(m_type) == 1))
	{
		Num = m_bottomList.GetItemNum();
		numPossibleSlot = (m_maxInventoryCount - m_curInventoryCount);
		if((numPossibleSlot < 0))
		{
			numPossibleSlot = 0;
		}
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".BottomCountText"), (((("(" $ string((Num - hasStackableItemArray.Length))) $ "/") $ string(numPossibleSlot)) $ ")"));
	}
	m_numPossibleSlotCount = numPossibleSlot;
	return;
}

function HandleOKButton()
{
	local string param;
	local int bottomCount, bottomIndex;
	local ItemInfo bottomInfo;

	bottomCount = m_bottomList.GetItemNum();
	if((int(m_type) == 0))
	{
		ParamAdd(param, "num", string(bottomCount));
		bottomIndex = 0;
		while((bottomIndex < bottomCount))
		{
			m_bottomList.GetItem(bottomIndex, bottomInfo);
			ParamAdd(param, ("dbID" $ string(bottomIndex)), string(bottomInfo.Reserved));
			ParamAdd(param, ("count" $ string(bottomIndex)), string(bottomInfo.ItemNum));
			++bottomIndex;
		}
		RequestWarehouseDeposit(param);
	}
	else if((int(m_type) == 1))
	{
		ParamAdd(param, "num", string(bottomCount));
		bottomIndex = 0;
		while((bottomIndex < bottomCount))
		{
			m_bottomList.GetItem(bottomIndex, bottomInfo);
			ParamAdd(param, ("dbID" $ string(bottomIndex)), string(bottomInfo.Reserved));
			ParamAdd(param, ("count" $ string(bottomIndex)), string(bottomInfo.ItemNum));
			++bottomIndex;
		}
		RequestWarehouseWithdraw(param);
	}
	HideWindow(m_Windowname);
	return;
}

function HandleSetMaxCount(string param)
{
	ParseInt(param, "warehousePrivate", m_maxPrivateCount);
	ParseInt(param, "Inventory", m_maxInventoryCount);
	return;
}

function OnReceivedCloseUI()
{
	GetWindowHandle("WarehouseWnd").HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="WarehouseWnd"
}
