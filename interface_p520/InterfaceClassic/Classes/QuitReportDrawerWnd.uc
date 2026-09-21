class QuitReportDrawerWnd extends UICommonAPI;

struct StackableItemIndexData
{
	var int Index;
	var int ClassID;
};

var WindowHandle Me;
var ListCtrlHandle itemListCtrl;
var ButtonHandle CloseBtn;
var int itemIndex;
var L2Util util;
var InventoryWnd inventoryWndScript;
var QuitReportWnd QuitReportWndScript;
var array<StackableItemIndexData> stackableItemIndexes;

function Init()
{
	itemIndex = 99999;
	stackableItemIndexes.Length = 0;
	itemListCtrl.DeleteAllItem();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("QuitReportDrawerWnd");
	itemListCtrl = GetListCtrlHandle("QuitReportDrawerWnd.InstanceDungeon_ListCtrl");
	CloseBtn = GetButtonHandle("QuitReportDrawerWnd.EnsoulInfoBtn");
	util = L2Util(GetScript("L2Util"));
	inventoryWndScript = InventoryWnd(GetScript("inventoryWnd"));
	QuitReportWndScript = QuitReportWnd(GetScript("QuitReportWnd"));
	itemListCtrl.SetSelectedSelTooltip(false);
	itemListCtrl.SetAppearTooltipAtMouseX(true);
	itemListCtrl.SetUseSelectionTexture(false);
	Init();
	return;
}

event OnClickHeaderCtrl(string strID, int Index)
{
	ResetStackableItemIndexesOnSort();
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

event OnShow()
{
	UpdateList();
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "EnsoulInfoBtn":
			OnEnsoulInfoBtnClick();
			break;
		default:
			break;
	}
	return;
}

event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}

function UpdateList()
{
	QuitReportWndScript.UpdateUserInfoHandler();
	return;
}

function externalAddItem(ItemInfo addItemInfo)
{
	if(IsStackableItem(addItemInfo.ConsumeType))
	{
		SumStackableItem(addItemInfo);
	}
	else
	{
		AddItem(addItemInfo);
	}
	if(Me.IsShowWindow())
	{
		UpdateList();
	}
	return;
}

function SumStackableItem(ItemInfo addItemInfo)
{
	local int Index;
	local ItemInfo beforeItemInfo;
	local StackableItemIndexData stackableItemIndex;

	inventoryWndScript.GetInventoryItemInfo(addItemInfo.Id, beforeItemInfo, true);
	if((beforeItemInfo.ItemNum < addItemInfo.ItemNum))
	{
		addItemInfo.ItemNum = (GetStackableItemCount(addItemInfo.Id.ClassID) + (addItemInfo.ItemNum - beforeItemInfo.ItemNum));
		Index = GetStackableIndexList(addItemInfo.Id.ClassID);
		if((Index > -1))
		{
			AddItem(addItemInfo, Index, true);
		}
		else
		{
			stackableItemIndex.Index = GetTotalItemCount();
			stackableItemIndex.ClassID = addItemInfo.Id.ClassID;
			stackableItemIndexes[stackableItemIndexes.Length] = stackableItemIndex;
			AddItem(addItemInfo);
		}
	}
	return;
}

function AddItem(ItemInfo Info, optional int modifyIndex, optional bool bModifyList)
{
	local LVDataRecord Record;
	local string param, AdditionalName, fullNameString, itemNumEasyRead;
	local int itemNameClass;

	if((Info.Id.ClassID == 57))
	{
		return;
	}
	itemIndex--;
	fullNameString = Info.Name;
	itemNameClass = Class'NWindow.UIDATA_ITEM'.static.GetItemNameClass(Info.Id);
	AdditionalName = Class'NWindow.UIDATA_ITEM'.static.GetItemAdditionalName(Info.Id);
	if((itemNameClass == 0))
	{
		fullNameString = MakeFullSystemMsg(GetSystemMessage(2332), fullNameString);
	}
	else if((itemNameClass == 2))
	{
		fullNameString = MakeFullSystemMsg(GetSystemMessage(2331), fullNameString);
	}
	if((Len(AdditionalName) > 0))
	{
		fullNameString = (((fullNameString $ "(") $ AdditionalName) $ ")");
	}
	ItemInfoToParam(Info, param);
	Record.szReserved = param;
	Record.nReserved1 = INT64(Info.Id.ClassID);
	Record.nReserved2 = Info.ItemNum;
	if(IsStackableItem(Info.ConsumeType))
	{
		Record.nReserved3 = INT64(1);
	}
	Record.LVDataList.Length = 4;
	Record.LVDataList[0].szData = fullNameString;
	Record.LVDataList[0].hasIcon = true;
	Record.LVDataList[0].nTextureWidth = 32;
	Record.LVDataList[0].nTextureHeight = 32;
	Record.LVDataList[0].nTextureU = 32;
	Record.LVDataList[0].nTextureV = 32;
	Record.LVDataList[0].szTexture = Info.IconName;
	Record.LVDataList[0].IconPosX = 10;
	Record.LVDataList[0].FirstLineOffsetX = 6;
	Record.LVDataList[0].HiddenStringForSorting = string(itemIndex);
	itemIndex--;
	Record.LVDataList[0].iconBackTexName = "l2ui_ct1.ItemWindow_DF_SlotBox_Default";
	Record.LVDataList[0].backTexOffsetXFromIconPosX = -2;
	Record.LVDataList[0].backTexOffsetYFromIconPosY = -1;
	Record.LVDataList[0].backTexWidth = 36;
	Record.LVDataList[0].backTexHeight = 36;
	Record.LVDataList[0].backTexUL = 36;
	Record.LVDataList[0].backTexVL = 36;
	Record.LVDataList[0].iconPanelName = Info.IconPanel;
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
	if(IsStackableItem(Info.ConsumeType))
	{
		if((Info.ItemNum > INT64(9999)))
		{
			itemNumEasyRead = "9999+";
		}
		else
		{
			itemNumEasyRead = string(Info.ItemNum);
		}
		Record.LVDataList[1].szData = itemNumEasyRead;
		Record.LVDataList[1].textAlignment = TA_Center;
		Record.LVDataList[1].HiddenStringForSorting = util.makeZeroString(13, Info.ItemNum);
	}
	else
	{
		Record.LVDataList[1].HiddenStringForSorting = util.makeZeroString(13, Info.ItemNum);
	}
	if(bModifyList)
	{
		itemListCtrl.ModifyRecord(modifyIndex, Record);
	}
	else
	{
		itemListCtrl.InsertRecord(Record);
	}
	return;
}

function OnEnsoulInfoBtnClick()
{
	QuitReportWndScript.setDrawerButtonState(true);
	Me.HideWindow();
	return;
}

function ResetStackableItemIndexesOnSort()
{
	local int i;
	local LVDataRecord Record;
	local StackableItemIndexData stackableItemIndex;

	stackableItemIndexes.Length = 0;
	i = 0;
	while((i < GetTotalItemCount()))
	{
		itemListCtrl.GetRec(i, Record);
		if((Record.nReserved3 == INT64(1)))
		{
			stackableItemIndex.ClassID = int(Record.nReserved1);
			stackableItemIndex.Index = i;
			stackableItemIndexes[stackableItemIndexes.Length] = stackableItemIndex;
		}
		i++;
	}
	return;
}

function int GetTotalItemCount()
{
	return itemListCtrl.GetRecordCount();
}

function int GetStackableIndexList(int ClassID)
{
	local int i;

	i = 0;
	while((i < stackableItemIndexes.Length))
	{
		if((stackableItemIndexes[i].ClassID == ClassID))
		{
			return stackableItemIndexes[i].Index;
		}
		i++;
	}
	return -1;
}

function INT64 GetStackableItemCount(int ClassID)
{
	local int Index;
	local LVDataRecord Record;

	Index = GetStackableIndexList(ClassID);
	if((Index > -1))
	{
		itemListCtrl.GetRec(Index, Record);
		return Record.nReserved2;
	}
	return INT64(0);
}
