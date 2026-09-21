class QuitReportDrawerInstantZoneWnd extends UICommonAPI;

struct StackableItemIndexData
{
	var int Index;
	var int ClassID;
};

var WindowHandle Me;
var ListCtrlHandle itemListCtrl;
var ButtonHandle CloseBtn;
var int itemIndex;
var array<ItemInfo> getItemInfoArray;
var L2Util util;
var InventoryWnd inventoryWndScript;
var QuitReportInstantZoneWnd QuitReportWndScript;
var array<StackableItemIndexData> stackableItemIndexes;

function Initialize()
{
	Me = GetWindowHandle("QuitReportDrawerInstantZoneWnd");
	itemListCtrl = GetListCtrlHandle("QuitReportDrawerInstantZoneWnd.InstanceDungeon_ListCtrl");
	CloseBtn = GetButtonHandle("QuitReportDrawerInstantZoneWnd.EnsoulInfoBtn");
	util = L2Util(GetScript("L2Util"));
	inventoryWndScript = InventoryWnd(GetScript("inventoryWnd"));
	QuitReportWndScript = QuitReportInstantZoneWnd(GetScript("QuitReportInstantZoneWnd"));
	itemListCtrl.SetSelectedSelTooltip(false);
	itemListCtrl.SetAppearTooltipAtMouseX(true);
	Init();
	return;
}

function Init()
{
	if((getItemInfoArray.Length > 0))
	{
		getItemInfoArray.Remove(0, getItemInfoArray.Length);
	}
	stackableItemIndexes.Length = 0;
	itemIndex = 99999;
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
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

function externalAddItem(ItemInfo addItemInfo)
{
	if(!QuitReportWndScript.bGainStart)
	{
		return;
	}
	if(IsStackableItem(addItemInfo.ConsumeType))
	{
		SumStackableItem(addItemInfo);
	}
	else
	{
		getItemInfoArray.Length = (getItemInfoArray.Length + 1);
		getItemInfoArray[(getItemInfoArray.Length - 1)] = addItemInfo;
	}
	return;
}

function int GetTotalItemCount()
{
	local int adenItem, itemLen, i;

	adenItem = 0;
	itemLen = getItemInfoArray.Length;
	i = 0;
	while((i < itemLen))
	{
		if((getItemInfoArray.Length > 0))
		{
			if((getItemInfoArray[i].Id.ClassID == 57))
			{
				adenItem = -1;
				break;
			}
		}
		i++;
	}
	return (getItemInfoArray.Length + adenItem);
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

function SumStackableItem(ItemInfo addItemInfo)
{
	local int Index;
	local ItemInfo beforeItemInfo;
	local StackableItemIndexData stackableItemIndexe;

	Index = GetStackableIndexList(addItemInfo.Id.ClassID);
	if((Index > -1))
	{
		inventoryWndScript.GetInventoryItemInfo(addItemInfo.Id, beforeItemInfo, true);
		if((beforeItemInfo.ItemNum < addItemInfo.ItemNum))
		{
			getItemInfoArray[Index].ItemNum = (getItemInfoArray[Index].ItemNum + (addItemInfo.ItemNum - beforeItemInfo.ItemNum));
		}
	}
	else
	{
		inventoryWndScript.GetInventoryItemInfo(addItemInfo.Id, beforeItemInfo, true);
		if((beforeItemInfo.ItemNum < addItemInfo.ItemNum))
		{
			if((getItemInfoArray.Length > 0))
			{
				addItemInfo.ItemNum = (getItemInfoArray[Index].ItemNum + (addItemInfo.ItemNum - beforeItemInfo.ItemNum));
			}
			else
			{
				addItemInfo.ItemNum = (addItemInfo.ItemNum - beforeItemInfo.ItemNum);
			}
			stackableItemIndexe.ClassID = addItemInfo.Id.ClassID;
			stackableItemIndexe.Index = getItemInfoArray.Length;
			stackableItemIndexes[stackableItemIndexes.Length] = stackableItemIndexe;
			getItemInfoArray.Length = (getItemInfoArray.Length + 1);
			getItemInfoArray[(getItemInfoArray.Length - 1)] = addItemInfo;
		}
	}
	return;
}

function UpdateList()
{
	local int i;

	itemListCtrl.DeleteAllItem();
	if((getItemInfoArray.Length > 0))
	{
		i = (getItemInfoArray.Length - 1);
		while((i > -1))
		{
			if((getItemInfoArray[i].Id.ClassID != 57))
			{
				AddItem(getItemInfoArray[i]);
			}
			i--;
		}
	}
	return;
}

function AddItem(ItemInfo Info)
{
	local LVDataRecord Record;
	local string param, AdditionalName, fullNameString, itemNumEasyRead;
	local int itemNameClass;

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
	}
	itemListCtrl.InsertRecord(Record);
	return;
}

function OnEnsoulInfoBtnClick()
{
	QuitReportWndScript.setDrawerButtonState(true);
	Me.HideWindow();
	return;
}
