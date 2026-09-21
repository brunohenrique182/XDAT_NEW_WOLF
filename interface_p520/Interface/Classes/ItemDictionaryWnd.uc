class ItemDictionaryWnd extends UICommonAPI;

enum EMainCategoryType
{
	MCT_All,                        // 0
	MCT_Weapon,                     // 1
	MCT_Armor,                      // 2
	MCT_Acc,                        // 3
	MCT_Etc                         // 4
};

enum ESubCategoryType
{
	SCT_All                         // 0
};

struct ItemDictInfo
{
	var int ItemID;
	var ItemInfo Info;
	var int Grade;
	var int maxEnchantLv;
};

struct ItemDrawInfo
{
	var ItemDictInfo dictInfo;
	var int enchantLevel;
	var bool Blessed;
};

var array<ItemDictInfo> _itemDictTotalInfos;
var array<ItemDictInfo> _itemDictInfos;
var bool _initData;
var ItemDrawInfo _itemDrawInfo;
var WindowHandle Me;
var WindowHandle searchWnd;
var UIControlGroupButtonAssets mainCategoryButtonAsset;
var UIControlTextInput searchTextInput;
var RichListCtrlHandle itemListRichList;
var DrawPanelHandle itemInfoDrawPanel;
var ButtonHandle prevLevelBtn;
var ButtonHandle nextLevelBtn;
var ButtonHandle blessCheckBox;
var WindowHandle drawScrollArea;
var WindowHandle drawContainerWnd;
//var delegate<OnItemListSort> __OnItemListSort__Delegate;

static function ItemDictionaryWnd Inst()
{
	return ItemDictionaryWnd(GetScript("ItemDictionaryWnd"));
}

function Initialize()
{
	InitAllData();
	InitControls();
	return;
}

function InitControls()
{
	local string ownerFullPath;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	itemListRichList = GetRichListCtrlHandle((ownerFullPath $ ".Item_ListCtrl"));
	itemListRichList.SetSelectedSelTooltip(false);
	itemListRichList.SetAppearTooltipAtMouseX(true);
	prevLevelBtn = GetButtonHandle((ownerFullPath $ ".prevLevelBtn"));
	nextLevelBtn = GetButtonHandle((ownerFullPath $ ".nextLevelBtn"));
	blessCheckBox = GetButtonHandle((ownerFullPath $ ".blessCheckBox"));
	drawScrollArea = GetWindowHandle((ownerFullPath $ ".ScrollArea"));
	drawContainerWnd = GetWindowHandle((drawScrollArea.m_WindowNameWithFullPath $ ".itemRenderer"));
	itemInfoDrawPanel = GetDrawPanelHandle((drawContainerWnd.m_WindowNameWithFullPath $ ".ItemInfoDrawPanel"));
	searchWnd = GetWindowHandle((ownerFullPath $ ".ItemFind_Wnd"));
	searchTextInput = Class'Interface.UIControlTextInput'.static.InitScript(GetWindowHandle((searchWnd.m_WindowNameWithFullPath $ ".TextInput")));
	searchTextInput.DelegateOnClear = OnSearchTextInputClear;
	searchTextInput.DelegateOnCompleteEditBox = OnSearchTextInputCompleted;
	searchTextInput.SetDisable(false);
	searchTextInput.SetEdtiable(true);
	searchTextInput.SetDefaultString(GetSystemString(1310));
	mainCategoryButtonAsset = Class'Interface.UIControlGroupButtonAssets'.static._InitScript(GetWindowHandle((ownerFullPath $ ".UIControlGroupButtonAsset1")));
	return;
}

function InitAllData()
{
	return;
}

function UpdateItemList()
{
	local int i, recordCnt, deleteIndex;
	local ItemDictInfo tmpItemDictInfo;
	local RichListCtrlRowData rowData;
	local L2Util util;
	local ToolTip toolTipScript;

	rowData.cellDataList.Length = 4;
	recordCnt = itemListRichList.GetRecordCount();
	util = getInstanceL2Util();
	toolTipScript = ToolTip(GetScript("Tooltip"));
	UpdateItemInfos();
	i = 0;
	while((i < Max(_itemDictInfos.Length, recordCnt)))
	{
		if((i < _itemDictInfos.Length))
		{
			tmpItemDictInfo = _itemDictInfos[i];
			rowData.cellDataList[0].drawitems.Length = 0;
			rowData.cellDataList[1].drawitems.Length = 0;
			rowData.cellDataList[2].drawitems.Length = 0;
			rowData.cellDataList[3].drawitems.Length = 0;
			rowData.nReserved1 = INT64(i);
			AddRichListCtrlItem(rowData.cellDataList[0].drawitems, tmpItemDictInfo.Info, 32, 32);
			AddRichListCtrlString(rowData.cellDataList[1].drawitems, tmpItemDictInfo.Info.Name, util.GetItemTextColor(tmpItemDictInfo.Grade), false, 4);
			if((Len(tmpItemDictInfo.Info.AdditionalName) > 0))
			{
				AddRichListCtrlString(rowData.cellDataList[1].drawitems, tmpItemDictInfo.Info.AdditionalName, GetColor(255, 217, 105, 255), false, 6);
			}
			AddRichListCtrlString(rowData.cellDataList[2].drawitems, toolTipScript.getSlotTypeWithItemTypeString(tmpItemDictInfo.Info));
			if((i < recordCnt))
			{
				itemListRichList.ModifyRecord(i, rowData);
			}
			else
			{
				itemListRichList.InsertRecord(rowData);
			}
			i++;
			continue;
		}
		itemListRichList.DeleteRecord(((recordCnt - deleteIndex) - 1));
		deleteIndex++;
		i++;
	}
	if((itemListRichList.GetRecordCount() > 0))
	{
		itemListRichList.SetSelectedIndex(0, true);
		OnClickItemList();
	}
	return;
}

function ShowItemInfo(ItemDrawInfo drawInfo)
{
	local int nX, nY;
	local ItemInfo ItemInfo;
	local bool isPossibleBless;
	local ToolTip toolTipScript;
	local CustomTooltip itemTooltip;
	local string itemInfoParam;

	toolTipScript = ToolTip(GetScript("Tooltip"));
	ItemInfo = GetItemInfoByClassID(drawInfo.dictInfo.ItemID);
	ItemInfo.Enchanted = drawInfo.enchantLevel;
	ItemInfo.IsBlessedItem = drawInfo.Blessed;
	Debug(((("itemInfo.SlotBitType" @ string(ItemInfo.SlotBitType)) @ string(ItemInfo.EtcItemType)) @ string(ItemInfo.ItemType)));
	if((ItemInfo.SlotBitType == INT64(16)))
	{
		ItemInfo.SlotBitType = (INT64(16) + INT64(32));
	}
	ItemInfoToParam(ItemInfo, itemInfoParam);
	itemTooltip = toolTipScript.ReturnCustomTooltip_ITEM(("SourceType=1 TooltipType=Inventory IsCompareItem=0 UseSimpleTooltip=0 IsSelectMode=0 " $ itemInfoParam));
	if((ItemInfo.EnchantBlessGroupID > 0))
	{
		isPossibleBless = true;
	}
	blessCheckBox.SetEnable(isPossibleBless);
	DrawPanelArrayFixedWidth(itemInfoDrawPanel, itemTooltip.DrawList, true, 403);
	itemInfoDrawPanel.PreCheckPanelSize(nX, nY);
	GetWindowHandle("UIButtonTestWnd.ScrollArea.itemRenderer").SetWindowSize(403, nY);
	itemInfoDrawPanel.SetWindowSize(403, nY);
	drawScrollArea.SetScrollHeight(nY);
	return;
}

function CheckAndInitItemData()
{
	local ItemDictInfo ItemDictInfo;
	local ItemID ItemID;
	local ItemInfo ItemInfo;

	if(((_itemDictTotalInfos.Length > 0) || (_initData == true)))
	{
		return;
	}
	ItemID = Class'NWindow.UIDATA_ITEM'.static.GetFirstID();
	ItemID = ItemID;
	while(IsValidItemID(ItemID))
	{
		ItemInfo = GetItemInfoByClassID(ItemID.ClassID);
		ItemDictInfo.Grade = Class'NWindow.UIDATA_ITEM'.static.GetItemNameClass(ItemID);
		ItemDictInfo.Info = ItemInfo;
		ItemDictInfo.ItemID = ItemID.ClassID;
		_itemDictTotalInfos[_itemDictTotalInfos.Length] = ItemDictInfo;
		ItemID = Class'NWindow.UIDATA_ITEM'.static.GetNextID();
	}
	Debug(("CheckAndInitItemData : " @ string(_itemDictTotalInfos.Length)));
	_initData = true;
	return;
}

function UpdateItemInfos()
{
	local int i;
	local array<ItemDictInfo> tempItemInfos;
	local string searchStr;

	tempItemInfos = _itemDictTotalInfos;
	searchStr = searchTextInput.GetString();
	if((searchStr != ""))
	{
		_itemDictInfos.Length = 0;
		i = 0;
		while((i < tempItemInfos.Length))
		{
			if(StringMatching(tempItemInfos[i].Info.Name, searchStr, " "))
			{
				_itemDictInfos[_itemDictInfos.Length] = tempItemInfos[i];
			}
			i++;
		}
	}
	else
	{
		_itemDictInfos = tempItemInfos;
	}
	return;
}

delegate int OnItemListSort(ItemDictInfo A, ItemDictInfo B)
{
	if((A.Grade != B.Grade))
	{
		if((A.Grade > B.Grade))
		{
			return 0;
		}
		else
		{
			return -1;
		}
	}
	return 0;
}

function OnClickItemList()
{
	local RichListCtrlRowData rowData;
	local int SelectedIndex;

	itemListRichList.GetSelectedRec(rowData);
	SelectedIndex = int(rowData.nReserved1);
	if((_itemDictInfos.Length > SelectedIndex))
	{
		_itemDrawInfo.dictInfo = _itemDictInfos[SelectedIndex];
		_itemDrawInfo.enchantLevel = 0;
		_itemDrawInfo.Blessed = false;
		ShowItemInfo(_itemDrawInfo);
	}
	return;
}

event OnSearchTextInputClear()
{
	UpdateItemList();
	return;
}

event OnSearchTextInputCompleted(string Text)
{
	UpdateItemList();
	return;
}

event OnClickListCtrlRecord(string strID)
{
	switch(strID)
	{
		case "Item_ListCtrl":
			OnClickItemList();
			break;
		default:
			break;
	}
	return;
}

event OnClickButton(string btnName)
{
	if((btnName == "prevLevelBtn"))
	{
		_itemDrawInfo.enchantLevel = (_itemDrawInfo.enchantLevel - 1);
		ShowItemInfo(_itemDrawInfo);
	}
	else if((btnName == "nextLevelBtn"))
	{
		_itemDrawInfo.enchantLevel = (_itemDrawInfo.enchantLevel + 1);
		ShowItemInfo(_itemDrawInfo);
	}
	else if((btnName == "blessCheckBox"))
	{
		_itemDrawInfo.Blessed = !_itemDrawInfo.Blessed;
		ShowItemInfo(_itemDrawInfo);
	}
	return;
}

event OnShow()
{
	CheckAndInitItemData();
	UpdateItemList();
	return;
}

event OnLoad()
{
	Initialize();
	return;
}

event OnReceivedCloseUI()
{
	if((Me.IsVisibility() == false))
	{
		return;
	}
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	Me.HideWindow();
	return;
}
