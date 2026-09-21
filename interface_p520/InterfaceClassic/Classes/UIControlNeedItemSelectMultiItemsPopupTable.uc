class UIControlNeedItemSelectMultiItemsPopupTable extends UICommonAPI;

var RichListCtrlHandle List_ListCtrl;
var WindowHandle ownerWnd;
var int Step;

static function UIControlNeedItemSelectMultiItemsPopupTable _Inst()
{
	return UIControlNeedItemSelectMultiItemsPopupTable(GetScript("UIControlNeedItemSelectMultiItemsPopupTable"));
}

event OnLoad()
{
	List_ListCtrl = GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".List_ListCtrl"));
	List_ListCtrl.SetUseStripeBackTexture(false);
	List_ListCtrl.SetSelectedSelTooltip(false);
	Tests();
	return;
}

event OnShow()
{
	m_hOwnerWnd.SetFocus();
	return;
}

function SetAnchorOwner()
{
	local int X, Y, W, h;
	local Rect rectWnd;
	local int currentScreenWidth, currentScreenHeight;

	rectWnd = ownerWnd.GetRect();
	m_hOwnerWnd.GetWindowSize(W, h);
	GetCurrentResolution(currentScreenWidth, currentScreenHeight);
	if(((rectWnd.nY - h) < 0))
	{
		Y = 0;
		if(((rectWnd.nX + W) > currentScreenWidth))
		{
			X = (rectWnd.nX - W);
		}
		else
		{
			X = (rectWnd.nX + rectWnd.nWidth);
		}
	}
	else
	{
		Y = (rectWnd.nY - h);
		if(((rectWnd.nX + W) > currentScreenWidth))
		{
			X = (currentScreenWidth - W);
		}
		else if((rectWnd.nX < 0))
		{
			X = 0;
		}
		else
		{
			X = rectWnd.nX;
		}
	}
	m_hOwnerWnd.MoveTo(X, Y);
	return;
}

function Show()
{
	local int W, h;

	m_hOwnerWnd.GetWindowSize(W, h);
	m_hOwnerWnd.SetWindowSize(W, (69 + (40 * List_ListCtrl.GetRecordCount())));
	SetAnchorOwner();
	m_hOwnerWnd.ShowWindow();
	return;
}

function RichListCtrlRowData MakeRowData(L2ItemAmount item, optional int tryNum, optional string stepName)
{
	local ItemInfo iInfo;
	local RichListCtrlRowData rowData;

	rowData.cellDataList.Length = 3;
	if((stepName != ""))
	{
		rowData.sOverlayTex = "L2UI_NewTex.NeedItemSelect.Divider";
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, stepName);
	}
	if((tryNum == -1))
	{
		AddRichListCtrlString(rowData.cellDataList[1].drawitems, GetSystemString(858));
	}
	else if((tryNum > 0))
	{
		AddRichListCtrlString(rowData.cellDataList[1].drawitems, string(tryNum));
	}
	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(item.ItemClassID), iInfo);
	AddRichListCtrlItem(rowData.cellDataList[2].drawitems, iInfo);
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, (" x" $ MakeCostString(string(item.ItemAmount))), GetColor(255, 255, 255, 255), false, 0, 8);
	return rowData;
}

function _ShowWithOwner(WindowHandle wOwnerWnd)
{
	ownerWnd = wOwnerWnd;
	Show();
	return;
}

function _Hide()
{
	m_hOwnerWnd.HideWindow();
	return;
}

function _Clear()
{
	Step = 0;
	List_ListCtrl.DeleteAllItem();
	return;
}

function _AddStep(array<L2ItemAmount> Items, int tryNum, optional string stepName)
{
	local int i;

	Step++;
	if((stepName == ""))
	{
		stepName = (string(Step) $ GetSystemString(14680));
	}
	List_ListCtrl.InsertRecord(MakeRowData(Items[i], tryNum, stepName));
	i = 1;
	while((i < Items.Length))
	{
		List_ListCtrl.InsertRecord(MakeRowData(Items[i]));
		i++;
	}
	return;
}

function API_GetClientCursorPos(out int X, out int Y)
{
	GetClientCursorPos(X, Y);
	return;
}

function Tests()
{
	local int i;
	local L2ItemAmount itemAmout;
	local array<L2ItemAmount> Items;

	List_ListCtrl.DeleteAllItem();
	Items.Length = 5;
	i = 0;
	while((i < Items.Length))
	{
		itemAmout.ItemClassID = 57;
		itemAmout.ItemAmount = (i * 5);
		Items[i] = itemAmout;
		i++;
	}
	_AddStep(Items, Items.Length, "1스텝");  // EN?: 1 step
	_AddStep(Items, Items.Length, "2스텝");  // EN?: 2 steps
	return;
}
