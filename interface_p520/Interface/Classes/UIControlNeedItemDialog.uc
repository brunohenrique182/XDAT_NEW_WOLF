class UIControlNeedItemDialog extends UIControlBasicDialog;

var string m_Windowname;
var WindowHandle Me;
var RichListCtrlHandle NeedItemRichListCtrl;
var WindowHandle DisableWindow;
var L2Util util;
var bool bEnoughItems;
var int nDialogKey;

function SetWindow(string WindowName, optional string DisableWindowName)
{
	util = L2Util(GetScript("L2Util"));
	if((DisableWindowName != ""))
	{
		DisableWindow = GetWindowHandle(DisableWindowName);
	}
	m_Windowname = WindowName;
	Me = GetWindowHandle(m_Windowname);
	OKButton = GetButtonHandle((m_Windowname $ ".OkButton"));
	CancleButton = GetButtonHandle((m_Windowname $ ".CancleButton"));
	DescriptionTextBox = GetTextBoxHandle((m_Windowname $ ".DescriptionTextBox"));
	DescriptionHtmlCtrl = GetHtmlHandle((m_Windowname $ ".DescriptionHtmlCtrl"));
	NeedItemRichListCtrl = GetRichListCtrlHandle((m_Windowname $ ".NeedItemRichListCtrl"));
	return;
}

function OnShow()
{
	NeedItemRichListCtrl.DeleteAllItem();
	OKButton.DisableWindow();
	return;
}

function OnHide()
{
	return;
}

function Show()
{
	if(!isNullWindow(DisableWindow))
	{
		DisableWindow.ShowWindow();
	}
	Me.ShowWindow();
	Me.SetFocus();
	return;
}

function Hide()
{
	if(!isNullWindow(DisableWindow))
	{
		DisableWindow.HideWindow();
	}
	Me.HideWindow();
	return;
}

event OnLoad()
{
	NeedItemRichListCtrl.SetUseStripeBackTexture(false);
	NeedItemRichListCtrl.SetSelectedSelTooltip(false);
	NeedItemRichListCtrl.SetAppearTooltipAtMouseX(true);
	NeedItemRichListCtrl.SetSelectable(false);
	return;
}

function RichListCtrlRowData MakeRowDataStatusResetNeedItemInfo(ItemInfo iInfo, INT64 Amount, INT64 inventoryItemCount)
{
	local RichListCtrlRowData rowData;
	local Color itemNumColor;
	local string toolTipParam;

	rowData.cellDataList.Length = 1;
	ItemInfoToParam(iInfo, toolTipParam);
	rowData.szReserved = toolTipParam;
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, 0, 1);
	AddRichListCtrlItem(rowData.cellDataList[0].drawitems, iInfo, 32, 32, -34, 1);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, GetItemNameAll(iInfo), util.BrightWhite, false, 5, 0);
	if((inventoryItemCount < Amount))
	{
		bEnoughItems = false;
		itemNumColor = GetColor(255, 0, 0, 255);
	}
	else
	{
		itemNumColor = GetColor(0, 176, 255, 255);
	}
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, ("x" $ MakeCostStringINT64(Amount)), util.White, true, 40, 5);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, ((" (" $ MakeCostStringINT64(inventoryItemCount)) $ ")"), itemNumColor, false);
	return rowData;
}

function RichListCtrlRowData MakeRowDataStatusResetNeedItem(int ClassID, INT64 Amount)
{
	local RichListCtrlRowData rowData;
	local Color itemNumColor;
	local string toolTipParam;
	local ItemID cID;
	local InventoryWnd inventoryWndScript;
	local INT64 ItemCount;
	local ItemInfo Info;

	rowData.cellDataList.Length = 1;
	cID.ClassID = ClassID;
	Info = GetItemInfoByClassID(ClassID);
	ItemInfoToParam(Info, toolTipParam);
	rowData.szReserved = toolTipParam;
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, 0, 1);
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems, Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(cID), 32, 32, -34, 1);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, Class'NWindow.UIDATA_ITEM'.static.GetItemName(cID), util.BrightWhite, false, 5, 0);
	inventoryWndScript = InventoryWnd(GetScript("InventoryWnd"));
	ItemCount = inventoryWndScript.getItemCountByClassID(ClassID);
	if((ItemCount < Amount))
	{
		bEnoughItems = false;
		itemNumColor = GetColor(255, 0, 0, 255);
	}
	else
	{
		itemNumColor = GetColor(0, 176, 255, 255);
	}
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, ("x" $ MakeCostStringINT64(Amount)), util.White, true, 40, 5);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, ((" (" $ MakeCostStringINT64(ItemCount)) $ ")"), itemNumColor, false);
	return rowData;
}

function StartNeedItemList()
{
	bEnoughItems = true;
	NeedItemRichListCtrl.DeleteAllItem();
	return;
}

function AddNeedItem(int nClassID, INT64 ItemCount)
{
	NeedItemRichListCtrl.InsertRecord(MakeRowDataStatusResetNeedItem(nClassID, ItemCount));
	return;
}

function AddNeeItemInfo(ItemInfo iInfo, INT64 Amount, INT64 inventoryItemCount)
{
	NeedItemRichListCtrl.InsertRecord(MakeRowDataStatusResetNeedItemInfo(iInfo, Amount, inventoryItemCount));
	return;
}

function EndNeedItemList()
{
	if(bEnoughItems)
	{
		OKButton.EnableWindow();
	}
	else
	{
		OKButton.DisableWindow();
	}
	return;
}
