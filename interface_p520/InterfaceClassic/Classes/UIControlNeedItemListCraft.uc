class UIControlNeedItemListCraft extends UIControlNeedItemList;

//var delegate<DelegateClickListCtrlRecord> __DelegateClickListCtrlRecord__Delegate;

delegate DelegateClickListCtrlRecord(int Index)
{
	return;
}

function int AddCraftNeedItemInfo(ItemInfo iInfo, INT64 needAmount, INT64 currAmount, optional string expandBtnName, optional bool showInvenIcon, optional bool showUserSelectBG, optional bool IsDisable)
{
	InsertRecordNCheckScrollBar(MakeRowDataCraftNeedItemInfo(iInfo, needAmount, currAmount, expandBtnName, showInvenIcon, showUserSelectBG, IsDisable));
	return _totalIndex;
}

function bool MakeCraftNeedItemDrawItem(ItemInfo iInfo, INT64 Amount, INT64 inventoryItemCount, out array<RichListCtrlDrawItem> drawitems, optional string expandBtnName, optional bool showInvenIcon, optional bool IsDisable)
{
	local INT64 totalNeednum;
	local Color itemNumColor;
	local array<string> btnStrArr;

	addRichListCtrlTexture(drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, 0, 1);
	AddRichListCtrlItem(drawitems, iInfo, 32, 32, -34, 1);
	if(showInvenIcon)
	{
		addRichListCtrlTexture(drawitems, "L2UI_EPIC.LCoinShopWnd.SpecialCraftInvenIcon", 10, 9, -32, 1);
	}
	else
	{
		addRichListCtrlTexture(drawitems, "L2UI_ct1.Button.emptyBtn", 10, 9, -32, 1);
	}
	if(IsDisable)
	{
		AddRichListCtrlString(drawitems, GetItemNameAll(iInfo, true), getInstanceL2Util().Gray, false, 28, 1);
	}
	else
	{
		AddRichListCtrlString(drawitems, GetItemNameAll(iInfo, true), getInstanceL2Util().BrightWhite, false, 28, 1);
	}
	totalNeednum = (Amount * _buyNum);
	AddRichListCtrlString(drawitems, iInfo.AdditionalName, getInstanceL2Util().Yellow03, false, 5, 0);
	if((iInfo.AdditionalName == ""))
	{
		AddRichListCtrlString(drawitems, ("x" $ MakeCostStringINT64(totalNeednum)), getInstanceL2Util().White, true, 40, 5);
	}
	else
	{
		AddRichListCtrlString(drawitems, ("x" $ MakeCostStringINT64(totalNeednum)), getInstanceL2Util().White, true, 40, 1);
	}
	if(!_bHideMyNum)
	{
		if((inventoryItemCount >= totalNeednum))
		{
			itemNumColor = GetColor(0, 176, 255, 255);
		}
		else
		{
			itemNumColor = GetColor(255, 0, 0, 255);
		}
		AddRichListCtrlString(drawitems, ((" (" $ MakeCostStringINT64(inventoryItemCount)) $ ")"), itemNumColor, false);
	}
	if((expandBtnName != ""))
	{
		Split(expandBtnName, "_", btnStrArr);
		if((btnStrArr[0] == "expandBtn"))
		{
			AddRichListCtrlString(drawitems, "", itemNumColor, true, 298, -24);
			AddRichListCtrlButton(drawitems, expandBtnName, 0, 0, "L2UI_EPIC.LCoinShopWnd.SpecialCraftListBtn_N", "L2UI_EPIC.LCoinShopWnd.SpecialCraftListBtn_D", "L2UI_EPIC.LCoinShopWnd.SpecialCraftListBtn_O", 24, 24, 24, 24);
		}
		if((btnStrArr[0] == "invenSelectBtn"))
		{
			AddRichListCtrlString(drawitems, "", itemNumColor, true, 298, -24);
			AddRichListCtrlButton(drawitems, expandBtnName, 0, 0, "L2UI_EPIC.LCoinShopWnd.SpecialCraftInvenBtn_N", "L2UI_EPIC.LCoinShopWnd.SpecialCraftInvenBtn_D", "L2UI_EPIC.LCoinShopWnd.SpecialCraftInvenBtn_O", 24, 24, 24, 24);
		}
	}
	return true;
}

function RichListCtrlRowData MakeRowDataCraftNeedItemInfo(ItemInfo iInfo, INT64 needAmount, INT64 currAmount, optional string expandBtnName, optional bool showInvenIcon, optional bool showUserSelectBG, optional bool IsDisable)
{
	local RichListCtrlRowData rowData;
	local string toolTipParam;
	local array<RichListCtrlDrawItem> drawitems;
	local int Row, Col;

	_totalIndex++;
	rowData.cellDataList.Length = GetColCount();
	ItemInfoToParam(iInfo, toolTipParam);
	rowData.szReserved = toolTipParam;
	if((GetColCount() > 1))
	{
		GetRowNCol(_totalIndex, Row, Col);
		if((Col > 0))
		{
			NeedItemRichListCtrl.GetRec(Row, rowData);
		}
	}
	MakeCraftNeedItemDrawItem(iInfo, needAmount, currAmount, drawitems, expandBtnName, showInvenIcon, IsDisable);
	if(showUserSelectBG)
	{
		rowData.sOverlayTex = "L2UI_EPIC.LCoinShopWnd.BlessItemListBG";
	}
	rowData.cellDataList[Col].drawitems = drawitems;
	_needAmounts[_totalIndex] = needAmount;
	_currAmounts[_totalIndex] = currAmount;
	_currAmountsAnimation[_totalIndex] = currAmount;
	_needItemClassIds[_totalIndex] = iInfo.Id.ClassID;
	return rowData;
}

function ModifyCurrentAmount(int Index, INT64 currentAmount)
{
	local RichListCtrlRowData rowData;
	local INT64 totalNeednum;
	local bool bEnoughItems;
	local array<RichListCtrlDrawItem> drawitems;
	local RichListCtrlDrawItem drawItemNeedItem, drawItemCurrentItem;
	local Color itemNumColor;
	local int Row, Col;

	GetRowNCol(Index, Row, Col);
	if((NeedItemRichListCtrl.GetRecordCount() <= Row))
	{
		return;
	}
	NeedItemRichListCtrl.GetRec(Row, rowData);
	if((rowData.cellDataList.Length <= Col))
	{
		return;
	}
	drawitems = rowData.cellDataList[Col].drawitems;
	drawItemNeedItem = drawitems[5];
	_currAmounts[Index] = currentAmount;
	if(!bUseAnimation)
	{
		_currAmountsAnimation[Index] = currentAmount;
	}
	totalNeednum = (_needAmounts[Index] * _buyNum);
	bEnoughItems = (_currAmounts[Index] >= totalNeednum);
	drawItemNeedItem.strInfo.strData = ("x" $ MakeCostStringINT64(totalNeednum));
	rowData.cellDataList[Col].drawitems[5] = drawItemNeedItem;
	if(!_bHideMyNum)
	{
		if(bEnoughItems)
		{
			itemNumColor = GetColor(0, 176, 255, 255);
		}
		else
		{
			itemNumColor = GetColor(255, 0, 0, 255);
		}
		drawItemCurrentItem = drawitems[6];
		drawItemCurrentItem.strInfo.strData = ((" (" $ MakeCostStringINT64(_currAmountsAnimation[Index])) $ ")");
		drawItemCurrentItem.strInfo.strColor = itemNumColor;
		rowData.cellDataList[Col].drawitems[6] = drawItemCurrentItem;
	}
	rowData.sOverlayTex = GetOverlayTexName(_needItemClassIds[Index]);
	NeedItemRichListCtrl.ModifyRecord(Row, rowData);
	return;
}

event OnClickListCtrlRecord(string strID)
{
	local int SelectedIndex;

	SelectedIndex = NeedItemRichListCtrl.GetSelectedIndex();
	DelegateClickListCtrlRecord(SelectedIndex);
	return;
}
