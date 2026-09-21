class UIControlNeedItemList extends UICommonAPI;

const needItemIndex = 4;
const CURRENTITEMINDEX = 5;
const ANIMATIONTIMELIMIT_DEFULT = 10;
const AMIMATIONTIME_RATE_DEFAULT = 0.05f;
const AMIMATIONTIME_COOLTIME = 20;

enum FORM_TYPE
{
	Normal,                         // 0
	NAMESIDE,                       // 1
	NORMALSIDESMALL,                // 2
	NORMALNEEDSMALLLINEBREAK,       // 3
	NORMALNEEDSMALLFONT             // 4
};

struct AniData
{
	var int Index;
	var int currentNum;
	var int targetNum;
	var int tickNum;
	var int Time;
};

var RichListCtrlHandle NeedItemRichListCtrl;
var array<L2UIInventoryObjectSimple> iObjects;
var L2UITimerObject timerObj;
var array<int> indexes;
var INT64 _buyNum;
var array<INT64> _needAmounts;
var array<INT64> _currAmounts;
var array<int> _needItemClassIds;
var array<INT64> _currAmountsAnimation;
var bool bUseAnimation;
var bool bUseDefaultBackground;
var float animationTImeLimit;
var float animationremainTime;
var float animationRate;
var INT64 lastAppMilliSeconds;
var FORM_TYPE _form;
var int _showRowNum;
var bool _bHideMyNum;
var int _columnCount;
var int _totalIndex;
var bool bShowOnLine;
//var delegate<DelegateOnUpdateItem> __DelegateOnUpdateItem__Delegate;
//var delegate<DelegateOnClickButton> __DelegateOnClickButton__Delegate;

static function UIControlNeedItemList InitScript(WindowHandle wnd, optional int ListNum, optional int columCount, optional bool isHideMyNum, optional FORM_TYPE newformType)
{
	local UIControlNeedItemList scr;

	wnd.SetScript("UIControlNeedItemList");
	scr = UIControlNeedItemList(wnd.GetScript());
	scr.InitWnd(wnd, ListNum, columCount, isHideMyNum, newformType);
	return scr;
}

function InitWnd(WindowHandle wnd, optional int ListNum, optional int columCount, optional bool isHideMyNum, optional FORM_TYPE newformType)
{
	local RichListCtrlHandle richList;

	m_hOwnerWnd = wnd;
	richList = GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".NeedItemRichListCtrl"));
	SetRichListControler(richList);
	if((ListNum > 0))
	{
		StartNeedItemList(ListNum);
	}
	if((columCount > 0))
	{
		SetColumnCount(columCount);
	}
	if((GetColCount() > 1))
	{
		richList.SetTooltipType("UIControlNeedItemList");
	}
	SetHideMyNum(isHideMyNum);
	SetFormType(newformType);
	return;
}

delegate DelegateOnUpdateItem()
{
	return;
}

delegate DelegateOnClickButton(string btnName)
{
	return;
}

function _SetUseDefaultBackground(bool bUse)
{
	local int i;
	local array<RichListCtrlRowData> rowdatas;

	if((bUseDefaultBackground == bUse))
	{
		return;
	}
	bUseDefaultBackground = bUse;
	rowdatas.Length = NeedItemRichListCtrl.GetRecordCount();
	i = 0;
	while((i < rowdatas.Length))
	{
		NeedItemRichListCtrl.GetRec(i, rowdatas[i]);
		rowdatas[i].sOverlayTex = GetOverlayTexName(_needItemClassIds[i]);
		NeedItemRichListCtrl.ModifyRecord(i, rowdatas[i]);
		i++;
	}
	return;
}

function string GetOverlayTexName(int ClassID)
{
	if(!bUseDefaultBackground)
	{
		return "";
	}
	return _GetOverlayTexName(ClassID);
}

function SetRichListControler(RichListCtrlHandle richList)
{
	_columnCount = 1;
	NeedItemRichListCtrl = richList;
	NeedItemRichListCtrl.SetUseStripeBackTexture(false);
	NeedItemRichListCtrl.SetSelectedSelTooltip(false);
	NeedItemRichListCtrl.SetAppearTooltipAtMouseX(true);
	_SetSelectable(false);
	NeedItemRichListCtrl.SetTooltipType("SellItemList");
	NeedItemRichListCtrl.SetUseHorizontalScrollBar(false);
	return;
}

function _SetSelectable(bool bSelect)
{
	NeedItemRichListCtrl.SetSelectable(bSelect);
	return;
}

function refresh()
{
	local int i;

	i = 0;
	while((i <= _totalIndex))
	{
		if((_currAmounts.Length <= i))
		{
			break;
		}
		ModifyCurrentAmount(i, _currAmounts[i]);
		i++;
	}
	DelegateOnUpdateItem();
	return;
}

function SetBuyNum(INT64 Num)
{
	_buyNum = Num;
	refresh();
	return;
}

function bool GetCanBuy()
{
	return (_buyNum <= GetMaxNumCanBuy());
}

function INT64 GetMaxNumCanBuy()
{
	local int i, Len;
	local INT64 maxCount, currentMaxCount;

	Len = _needAmounts.Length;
	if((Len == 0))
	{
		return INT64(0);
	}
	maxCount = GetMaxNumByIndex(0);
	i = 1;
	while((i < Len))
	{
		if((maxCount == INT64(0)))
		{
			return INT64(0);
		}
		currentMaxCount = GetMaxNumByIndex(i);
		if((currentMaxCount < maxCount))
		{
			maxCount = currentMaxCount;
		}
		i++;
	}
	return maxCount;
}

function INT64 GetMaxNumByIndex(int Index)
{
	if((_needAmounts[Index] == INT64(0)))
	{
		return INT64(999999);
	}
	return (_currAmounts[Index] / _needAmounts[Index]);
}

function int GetRowNum()
{
	return _showRowNum;
}

function bool GetItemClassID(int Index, out int ClassID)
{
	if((iObjects.Length > Index))
	{
		ClassID = iObjects[Index].iID.ClassID;
		return true;
	}
	return false;
}

function bool GetItemNeedAmount(int Index, out INT64 Amount)
{
	if((iObjects.Length > Index))
	{
		Amount = _needAmounts[Index];
		return true;
	}
	return false;
}

function _SetAnimationRate(optional float Rate)
{
	if((Rate == 0.0000000))
	{
		animationRate = 0.0500000;
	}
	else
	{
		animationRate = Rate;
	}
	return;
}

function _SetUseAnimation(bool bUse, optional float TimeLimit, optional float Rate)
{
	if((bUseAnimation == bUse))
	{
		return;
	}
	bUseAnimation = bUse;
	if(bUseAnimation)
	{
		if((TimeLimit == 0.0000000))
		{
			animationTImeLimit = 10.0000000;
		}
		else
		{
			animationTImeLimit = TimeLimit;
		}
		_SetAnimationRate(Rate);
		timerObj = Class'InterfaceClassic.L2UITimer'.static.Inst()._MakeTimerObject(20, -1);
		timerObj._DelegateOnStart = AnimationOnTImeStart;
		timerObj._DelegateOnTime = AnimationOnTime;
		timerObj._DelegateOnEnd = AnimationOnTImeEnd;
	}
	else
	{
		timerObj._Kill();
	}
	return;
}

function array<int> _GetNeedItemClassIDs()
{
	return _needItemClassIds;
}

function array<INT64> _GetNeedAmounts()
{
	return _needAmounts;
}

function AnimationOnTImeStart()
{
	if(!m_hOwnerWnd.GetTopFrameWnd().IsShowWindow())
	{
		timerObj._Stop();
		AnimationOnTImeEnd();
		return;
	}
	animationremainTime = animationTImeLimit;
	SetLastAppMilliSeconds();
	return;
}

function AnimationOnTime(int Count)
{
	local int i, Len;
	local INT64 gab;

	(animationremainTime -= (float(GetDeltaMilliTime()) / 1000.0000000));
	if((animationremainTime <= 0.0000000))
	{
		timerObj._Stop();
		AnimationOnTImeEnd();
		return;
	}
	SetLastAppMilliSeconds();
	i = 0;
	while((i < _currAmountsAnimation.Length))
	{
		gab = (_currAmounts[i] - _currAmountsAnimation[i]);
		if((((gab * animationRate) < INT64(1)) && ((gab * animationRate) > INT64(-1))))
		{
			_currAmountsAnimation[i] = (_currAmountsAnimation[i] + gab);
			Len++;
			i++;
			continue;
		}
		_currAmountsAnimation[i] = (_currAmountsAnimation[i] + (gab * animationRate));
		i++;
	}
	if((Len == _currAmountsAnimation.Length))
	{
		timerObj._Stop();
		AnimationOnTImeEnd();
		return;
	}
	refresh();
	return;
}

function AnimationOnTImeEnd()
{
	local int i;

	i = 0;
	while((i < _currAmountsAnimation.Length))
	{
		_currAmountsAnimation[i] = _currAmounts[i];
		i++;
	}
	refresh();
	return;
}

function SetLastAppMilliSeconds()
{
	lastAppMilliSeconds = GetAppMilliSeconds();
	return;
}

function INT64 GetDeltaMilliTime()
{
	return (GetAppMilliSeconds() - lastAppMilliSeconds);
}

function _CheckRowCountWithItemNum(int ItemNum)
{
	local int W, h, i;

	NeedItemRichListCtrl.GetWindowSize(W, h);
	bShowOnLine = (ItemNum <= _showRowNum);
	if(bShowOnLine)
	{
		NeedItemRichListCtrl.SetColumnWidth(0, W);
		i = 1;
		while((i < _columnCount))
		{
			NeedItemRichListCtrl.SetColumnWidth(i, 0);
			i++;
		}
	}
	else
	{
		i = 0;
		while((i < _columnCount))
		{
			NeedItemRichListCtrl.SetColumnWidth(i, (W / _columnCount));
			i++;
		}
	}
	return;
}

function StartNeedItemList(int showRowNum)
{
	_showRowNum = showRowNum;
	CleariObjects();
	if(bUseAnimation)
	{
		timerObj._Stop();
	}
	return;
}

function CleariObjects()
{
	local int i;

	bShowOnLine = false;
	_totalIndex = -1;
	_needAmounts.Length = 0;
	_currAmounts.Length = 0;
	_needItemClassIds.Length = 0;
	_currAmountsAnimation.Length = 0;
	NeedItemRichListCtrl.DeleteAllItem();
	i = 0;
	while((i < iObjects.Length))
	{
		RemObjectSimpleByObject(iObjects[i]);
		i++;
	}
	iObjects.Length = 0;
	return;
}

function int AddNeedPoint(string Name, string TextureName, INT64 needAmount, INT64 currentAmount)
{
	InsertRecordNCheckScrollBar(MakePointRecord(Name, TextureName, needAmount, currentAmount));
	return _totalIndex;
}

function AddNeedItemClassID(int nClassID, INT64 needAmount)
{
	local int Len;
	local INT64 currAmount;

	currAmount = getItemCountByClassID(nClassID);
	InsertRecordNCheckScrollBar(MakeRowDataByClassID(nClassID, needAmount, currAmount));
	Len = iObjects.Length;
	iObjects[Len] = AddItemListenerSimple(nClassID, 0, _totalIndex);
	iObjects[Len].DelegateOnUpdateItem = HandleItemSimpleUpdateListner;
	return;
}

function int AddNeeItemInfo(ItemInfo iInfo, INT64 needAmount, INT64 currAmount)
{
	InsertRecordNCheckScrollBar(MakeRowDataNeedItemInfo(iInfo, needAmount, currAmount));
	return _totalIndex;
}

function ModifyNeeItemInfo(ItemInfo iInfo, INT64 needAmount, INT64 currAmount)
{
	local int i;

	i = 0;
	while((i <= _totalIndex))
	{
		if((((_currAmounts.Length > i) && (_needItemClassIds.Length > i)) && (_needItemClassIds[i] == iInfo.Id.ClassID)))
		{
			if((_currAmounts[i] != currAmount))
			{
				ModifyCurrentAmount(i, currAmount);
			}
		}
		i++;
	}
	return;
}

function SetColumnCount(int columnCount)
{
	_columnCount = columnCount;
	return;
}

function SetHideMyNum(bool bHide)
{
	_bHideMyNum = bHide;
	refresh();
	return;
}

function SetFormType(FORM_TYPE newformType)
{
	_form = newformType;
	return;
}

function bool MakeNeedItemDrawItem(ItemInfo iInfo, INT64 Amount, INT64 inventoryItemCount, out array<RichListCtrlDrawItem> drawitems)
{
	local INT64 totalNeednum;
	local Color itemNumColor;
	local int LISTWIDTH, nWidth, NameWidth, addNameWidth, FullNameWidth, nHeight, TempOffset;
	local string Name, AddName, FullName, fixedString;
	local L2Util l2utilScr;
	local string tempStr;

	l2utilScr = getInstanceL2Util();
	LISTWIDTH = NeedItemRichListCtrl.GetMaxColumnWidth();
	if((int(_form) == 2))
	{
		LISTWIDTH = ((LISTWIDTH - 24) - 20);
	}
	else
	{
		LISTWIDTH = ((LISTWIDTH - 36) - 20);
	}
	Name = GetItemNameAll(iInfo, true);
	AddName = iInfo.AdditionalName;
	FullName = (Name $ AddName);
	l2utilScr.GetTextSizeDefault(Name, NameWidth, nHeight);
	l2utilScr.GetTextSizeDefault(AddName, addNameWidth, nHeight);
	l2utilScr.GetTextSizeDefault(FullName, FullNameWidth, nHeight);
	l2utilScr.GetTextSizeDefault("...", nWidth, nHeight);
	if((FullNameWidth > LISTWIDTH))
	{
		if((Len(AddName) < 1))
		{
			tempStr = DivideStringWithWidth(Name, (LISTWIDTH - nWidth));
			if((tempStr != Name))
			{
				Name = (tempStr $ "...");
			}
		}
		else if((NameWidth > LISTWIDTH))
		{
			AddName = "";
			tempStr = DivideStringWithWidth(Name, (LISTWIDTH - nWidth));
			if((tempStr != Name))
			{
				Name = (tempStr $ "...");
			}
		}
		else
		{
			TempOffset = ((LISTWIDTH - nWidth) - NameWidth);
			if((TempOffset < 1))
			{
				AddName = "...";
			}
			else
			{
				tempStr = DivideStringWithWidth(AddName, TempOffset);
				if((tempStr != AddName))
				{
					AddName = (tempStr $ "...");
				}
			}
		}
	}
	if((int(_form) == 2))
	{
		addRichListCtrlTexture(drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 24, 24, 0, 3);
		AddRichListCtrlItem(drawitems, iInfo, 20, 20, -22, 1);
		AddRichListCtrlString(drawitems, Name, getInstanceL2Util().BrightWhite, false, 5, 3);
	}
	else if((int(_form) == 3))
	{
		addRichListCtrlTexture(drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, 0, 1);
		AddRichListCtrlItem(drawitems, iInfo, 32, 32, -34, 1);
		AddRichListCtrlString(drawitems, Name, getInstanceL2Util().BrightWhite, false, 5, -3);
	}
	else if((int(_form) == 4))
	{
		addRichListCtrlTexture(drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, 0, 1);
		AddRichListCtrlItem(drawitems, iInfo, 32, 32, -34, 1);
		AddRichListCtrlString(drawitems, Name, getInstanceL2Util().BrightWhite, false, 5, 2);
	}
	else
	{
		addRichListCtrlTexture(drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, 0, 1);
		AddRichListCtrlItem(drawitems, iInfo, 32, 32, -34, 1);
		AddRichListCtrlString(drawitems, Name, getInstanceL2Util().BrightWhite, false, 5, 2);
	}
	totalNeednum = (Amount * _buyNum);
	switch(_form)
	{
		case Normal:
			AddRichListCtrlString(drawitems, AddName, getInstanceL2Util().Yellow03, false, 5, 0);
			if((iInfo.AdditionalName == ""))
			{
				AddRichListCtrlString(drawitems, ("x" $ MakeCostStringINT64(totalNeednum)), getInstanceL2Util().White, true, 40, 5);
			}
			else
			{
				AddRichListCtrlString(drawitems, ("x" $ MakeCostStringINT64(totalNeednum)), getInstanceL2Util().White, true, 40, 0);
			}
			break;
		case NAMESIDE:
		case NORMALSIDESMALL:
			AddRichListCtrlString(drawitems, AddName, getInstanceL2Util().Yellow03, false, 0, 0);
			AddRichListCtrlString(drawitems, ("x" $ MakeCostStringINT64(totalNeednum)), getInstanceL2Util().White, false, 5);
			break;
		case NORMALNEEDSMALLLINEBREAK:
			AddRichListCtrlString(drawitems, iInfo.AdditionalName, getInstanceL2Util().Yellow03, false, 5, 0);
			if((iInfo.AdditionalName == ""))
			{
				AddRichListCtrlString(drawitems, ("x" $ MakeCostStringINT64(totalNeednum)), getInstanceL2Util().White, true, 40, 2, "HS9");
			}
			else
			{
				AddRichListCtrlString(drawitems, ("x" $ MakeCostStringINT64(totalNeednum)), getInstanceL2Util().White, true, 40, -3, "HS9");
			}
			break;
		case NORMALNEEDSMALLFONT:
			AddRichListCtrlString(drawitems, iInfo.AdditionalName, getInstanceL2Util().Yellow03, false, 5, 0);
			if((iInfo.AdditionalName == ""))
			{
				AddRichListCtrlString(drawitems, ("x" $ MakeCostStringINT64(totalNeednum)), getInstanceL2Util().White, true, 40, 5, "HS9");
			}
			else
			{
				AddRichListCtrlString(drawitems, ("x" $ MakeCostStringINT64(totalNeednum)), getInstanceL2Util().White, true, 40, 0, "HS9");
			}
			break;
		default:
			break;
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
		switch(_form)
		{
			case NAMESIDE:
				AddRichListCtrlString(drawitems, ((" (" $ MakeCostStringINT64(inventoryItemCount)) $ ")"), itemNumColor, true, 36, 0);
				break;
			case Normal:
			case NORMALSIDESMALL:
				AddRichListCtrlString(drawitems, ((" (" $ MakeCostStringINT64(inventoryItemCount)) $ ")"), itemNumColor, false);
				break;
			case NORMALNEEDSMALLLINEBREAK:
				AddRichListCtrlString(drawitems, ((" (" $ MakeCostStringINT64(inventoryItemCount)) $ ")"), itemNumColor, true, 36, -2, "HS9");
				break;
			case NORMALNEEDSMALLFONT:
				AddRichListCtrlString(drawitems, ((" (" $ MakeCostStringINT64(inventoryItemCount)) $ ")"), itemNumColor, false, 0, 0, "HS9");
				break;
			default:
				break;
		}
	}
	return true;
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
	drawItemNeedItem = drawitems[4];
	_currAmounts[Index] = currentAmount;
	if(!bUseAnimation)
	{
		_currAmountsAnimation[Index] = currentAmount;
	}
	totalNeednum = (_needAmounts[Index] * _buyNum);
	bEnoughItems = (_currAmounts[Index] >= totalNeednum);
	drawItemNeedItem.strInfo.strData = ("x" $ MakeCostStringINT64(totalNeednum));
	rowData.cellDataList[Col].drawitems[4] = drawItemNeedItem;
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
		drawItemCurrentItem = drawitems[5];
		drawItemCurrentItem.strInfo.strData = ((" (" $ MakeCostStringINT64(_currAmountsAnimation[Index])) $ ")");
		drawItemCurrentItem.strInfo.strColor = itemNumColor;
		rowData.cellDataList[Col].drawitems[5] = drawItemCurrentItem;
	}
	rowData.sOverlayTex = GetOverlayTexName(_needItemClassIds[Index]);
	NeedItemRichListCtrl.ModifyRecord(Row, rowData);
	return;
}

function ModifyNeedItemInfoByIndex(int Index, ItemInfo iInfo, int needAmount, int currAmount)
{
	local RichListCtrlRowData rowData;
	local int Row, Col;
	local array<RichListCtrlDrawItem> drawitems;
	local int i;

	GetRowNCol(Index, Row, Col);
	if((NeedItemRichListCtrl.GetRecordCount() <= Row))
	{
		return;
	}
	_needAmounts[Index] = INT64(needAmount);
	_currAmounts[Index] = INT64(currAmount);
	_currAmountsAnimation[Index] = INT64(currAmount);
	_needItemClassIds[Index] = iInfo.Id.ClassID;
	NeedItemRichListCtrl.GetRec(Row, rowData);
	MakeNeedItemDrawItem(iInfo, INT64(needAmount), INT64(currAmount), drawitems);
	rowData.cellDataList[Col].drawitems = drawitems;
	NeedItemRichListCtrl.ModifyRecord(Row, rowData);
	i = 0;
	while((i < iObjects.Length))
	{
		if((iObjects[i].Index == Index))
		{
			RemObjectSimpleByObject(iObjects[i]);
			iObjects.Remove(i, 1);
			break;
		}
		i++;
	}
	return;
}

function ModifyNeedItemInfoByIndexUseSimpleObject(int Index, ItemInfo iInfo, int needAmount, int currAmount)
{
	local RichListCtrlRowData rowData;
	local int Row, Col;
	local array<RichListCtrlDrawItem> drawitems;
	local int i, Len;
	local bool bSimpleObject;

	GetRowNCol(Index, Row, Col);
	if((NeedItemRichListCtrl.GetRecordCount() <= Row))
	{
		return;
	}
	_needAmounts[Index] = INT64(needAmount);
	_currAmounts[Index] = INT64(currAmount);
	_currAmountsAnimation[Index] = INT64(currAmount);
	_needItemClassIds[Index] = iInfo.Id.ClassID;
	NeedItemRichListCtrl.GetRec(Row, rowData);
	MakeNeedItemDrawItem(iInfo, INT64(needAmount), INT64(currAmount), drawitems);
	rowData.cellDataList[Col].drawitems = drawitems;
	NeedItemRichListCtrl.ModifyRecord(Row, rowData);
	i = 0;
	while((i < iObjects.Length))
	{
		if((iObjects[i].Index == Index))
		{
			RemObjectSimpleByObject(iObjects[i]);
			iObjects[i] = AddItemListenerSimple(iInfo.Id.ClassID, 0, Index);
			iObjects[i].DelegateOnUpdateItem = HandleItemSimpleUpdateListner;
			bSimpleObject = true;
			break;
		}
		i++;
	}
	if((bSimpleObject == false))
	{
		Len = iObjects.Length;
		iObjects[Len] = AddItemListenerSimple(iInfo.Id.ClassID, 0, Index);
		iObjects[Len].DelegateOnUpdateItem = HandleItemSimpleUpdateListner;
	}
	return;
}

function RichListCtrlRowData MakeRowDataByClassID(int ClassID, INT64 needAmount, INT64 currAmount)
{
	local ItemInfo Info;

	Info = GetItemInfoByClassID(ClassID);
	return MakeRowDataNeedItemInfo(Info, needAmount, currAmount);
}

function RichListCtrlRowData MakePointRecord(string Name, string TextureName, INT64 needAmount, INT64 currentAmount)
{
	local ItemInfo iInfo;

	iInfo = GetItemInfoByClassID(57);
	iInfo.IconName = TextureName;
	iInfo.Name = Name;
	return MakeRowDataNeedItemInfo(iInfo, needAmount, currentAmount);
}

function _AddCellData(int Row, RichListCtrlCellData cellData)
{
	local RichListCtrlRowData rowData;
	local int addCellNum;

	NeedItemRichListCtrl.GetRec(Row, rowData);
	addCellNum = rowData.cellDataList.Length;
	rowData.cellDataList.Length = (rowData.cellDataList.Length + 1);
	rowData.cellDataList[addCellNum] = cellData;
	_ModifyRowData(NeedItemRichListCtrl, rowData, Row);
	return;
}

function RichListCtrlRowData MakeRowDataNeedItemInfo(ItemInfo iInfo, INT64 needAmount, INT64 currAmount)
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
	MakeNeedItemDrawItem(iInfo, needAmount, currAmount, drawitems);
	rowData.cellDataList[Col].drawitems = drawitems;
	_needAmounts[_totalIndex] = needAmount;
	_currAmounts[_totalIndex] = currAmount;
	_currAmountsAnimation[_totalIndex] = currAmount;
	_needItemClassIds[_totalIndex] = iInfo.Id.ClassID;
	rowData.sOverlayTex = GetOverlayTexName(iInfo.Id.ClassID);
	return rowData;
}

function HandleItemSimpleUpdateListner(array<ItemInfo> iInfos, int Index)
{
	local INT64 ItemCount;
	local int i;

	if((iInfos.Length == 0))
	{
		ItemCount = INT64(0);
	}
	else if(IsStackableItem(iInfos[0].ConsumeType))
	{
		ItemCount = iInfos[0].ItemNum;
	}
	else
	{
		ItemCount = INT64(iInfos.Length);
		i = 0;
		while((i < iInfos.Length))
		{
			if(iInfos[i].bEquipped)
			{
				ItemCount = (ItemCount - INT64(1));
			}
			if(isDamagedItem(iInfos[i]))
			{
				ItemCount = (ItemCount - INT64(1));
			}
			i++;
		}
	}
	ModifyCurrentAmount(Index, ItemCount);
	if(bUseAnimation)
	{
		timerObj._Reset();
	}
	DelegateOnUpdateItem();
	return;
}

function InsertRecordNCheckScrollBar(RichListCtrlRowData rowData)
{
	local int Row, Col;

	GetRowNCol(_totalIndex, Row, Col);
	if((Col == 0))
	{
		NeedItemRichListCtrl.InsertRecord(rowData);
	}
	else
	{
		NeedItemRichListCtrl.ModifyRecord(Row, rowData);
	}
	CheckShowScrollBar();
	return;
}

function CheckShowScrollBar()
{
	local bool isShowScroll;

	isShowScroll = ((NeedItemRichListCtrl.GetRecordCount() > _showRowNum) && (_showRowNum > 0));
	NeedItemRichListCtrl.ShowScrollBar(isShowScroll);
	return;
}

function INT64 getItemCountByClassID(int ClassID)
{
	local array<ItemInfo> iInfos;
	local INT64 ItemCount;
	local int i;

	FindItemByClassIDFilter(ClassID, iInfos);
	if((iInfos.Length == 0))
	{
		ItemCount = INT64(0);
	}
	else if(IsStackableItem(iInfos[0].ConsumeType))
	{
		ItemCount = iInfos[0].ItemNum;
	}
	else
	{
		ItemCount = INT64(iInfos.Length);
		i = 0;
		while((i < iInfos.Length))
		{
			if(iInfos[i].bEquipped)
			{
				ItemCount = (ItemCount - INT64(1));
			}
			if(isDamagedItem(iInfos[i]))
			{
				ItemCount = (ItemCount - INT64(1));
			}
			i++;
		}
	}
	return ItemCount;
}

function int GetColCount()
{
	if(bShowOnLine)
	{
		return 1;
	}
	return _columnCount;
}

function int GetIndex(int Row, int Col)
{
	return ((Row * GetColCount()) + Col);
}

function GetRowNCol(int Index, out int Row, out int Col)
{
	Row = (Index / GetColCount());
	Col = int((float(Index) % float(GetColCount())));
	return;
}

event OnClickButton(string btnName)
{
	DelegateOnClickButton(btnName);
	return;
}

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	return m_hOwnerWnd.GetParentWindowHandle().GetScript().OnKeyUp(a_WindowHandle, nKey);
}

event bool OnKeyDown(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	return m_hOwnerWnd.GetParentWindowHandle().GetScript().OnKeyUp(a_WindowHandle, nKey);
}

event OnSetFocus(WindowHandle a_WindowHandle, bool bFocused)
{
	m_hOwnerWnd.GetParentWindowHandle().GetScript().OnSetFocus(a_WindowHandle, bFocused);
	return;
}

event OnClickListCtrlRecord(string ListCtrlID)
{
	m_hOwnerWnd.GetParentWindowHandle().GetScript().OnClickListCtrlRecord(ListCtrlID);
	return;
}

event OnDBClickListCtrlRecord(string ListCtrlID)
{
	m_hOwnerWnd.GetParentWindowHandle().GetScript().OnDBClickListCtrlRecord(ListCtrlID);
	return;
}
