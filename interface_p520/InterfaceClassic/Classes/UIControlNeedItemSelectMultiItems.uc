class UIControlNeedItemSelectMultiItems extends UICommonAPI;

struct itemAmountStruct
{
	var int ItemClassID;
	var INT64 ItemAmount;
};

var string m_Windowname;
var WindowHandle Me;
var WindowHandle NeedItemSelect_wnd;
var TextBoxHandle NoticeTextBox;
var WindowHandle NeedItemSelectDialog_wnd;
var ButtonHandle NeedItemSelectArrow_btn;
var RichListCtrlHandle NeedItem_ListCtrl;
var UIControlNeedItemList NeedItemListCtrlScript;
var int selectItemNum;
var int nSelectCostItemClassID;
var INT64 nSelectCostItemAmount;
var UIControlNeedItemSelectMultiItemsPopup PopupScript;
var bool descMode;
var array<string> szReservedArray;
var array<itemAmountStruct> itemAmountsNew;
var array<itemAmountStruct> itemAmountsCur;
var AnimTextureHandle NeedItemSlotAni_tex;
//var delegate<DelegateSelectedItemOnClick> __DelegateSelectedItemOnClick__Delegate;
//var delegate<DelegateOnUpdateItem> __DelegateOnUpdateItem__Delegate;

delegate DelegateSelectedItemOnClick(int selectNeedItemIndex, int selectedClassID, INT64 selectedAmount)
{
	return;
}

delegate DelegateOnUpdateItem()
{
	return;
}

function _ShakeMultiItemsPopup()
{
	local L2UITween.ShakeObject shakeObj;
	local int GlobalX, GlobalY, gloalTextX, gloalTextY;
	local Rect R;

	Class'InterfaceClassic.L2UITween'.static.Inst().StopShake(Me.GetParentWindowName(), 0);
	if(PopupScript.Title_Txt.IsShowWindow())
	{
		R = PopupScript.Title_Txt.GetRect();
		Global2Local(PopupScript.Title_Txt.GetParentWindowHandle(), R.nX, R.nY, gloalTextX, gloalTextY);
		R.nX = (gloalTextX - 2);
		R.nY = ((gloalTextY + R.nHeight) - 2);
	}
	else
	{
		R.nX = 8;
		R.nY = 8;
	}
	Local2Global(PopupScript.Me, R.nX, R.nY, GlobalX, GlobalY);
	PopupScript.NeedItemSelect_ListCtrl.MoveTo(GlobalX, GlobalY);
	shakeObj.Owner = Me.GetParentWindowName();
	shakeObj.Id = 0;
	shakeObj.Target = PopupScript.NeedItemSelect_ListCtrl;
	shakeObj.Direction = small;
	shakeObj.shakeSize = 6.0000000;
	shakeObj.Duration = 300.0000000;
	Class'InterfaceClassic.L2UITween'.static.Inst().StartShakeObject(shakeObj);
	return;
}

static function UIControlNeedItemSelectMultiItems _InitScript(WindowHandle wnd)
{
	local UIControlNeedItemSelectMultiItems scr;

	wnd.SetScript("UIControlNeedItemSelectMultiItems");
	scr = UIControlNeedItemSelectMultiItems(wnd.GetScript());
	scr.InitWnd(wnd);
	return scr;
}

function InitWnd(WindowHandle wnd)
{
	m_hOwnerWnd = wnd;
	SetWindow(m_hOwnerWnd.m_WindowNameWithFullPath);
	return;
}

function SetWindow(string WindowName)
{
	m_Windowname = WindowName;
	Me = GetWindowHandle(m_Windowname);
	NeedItem_ListCtrl = GetRichListCtrlHandle(((m_Windowname $ ".") $ "NeedItem_ListCtrl"));
	NeedItem_ListCtrl.SetColumnWidth(0, (NeedItem_ListCtrl.GetRect().nWidth - 13));
	NeedItemSelect_wnd = GetWindowHandle(((m_Windowname $ ".") $ "NeedItemSelect_wnd"));
	NoticeTextBox = GetTextBoxHandle(((m_Windowname $ ".") $ "NeedItemSelect_wnd.NoticeTextBox"));
	NeedItemSelectArrow_btn = GetButtonHandle(((m_Windowname $ ".") $ "__NeedItemSelectArrow_btn"));
	NeedItemSlotAni_tex = GetAnimTextureHandle(((m_Windowname $ ".") $ "NeedItemSlotAni_tex"));
	NeedItemListCtrlScript = new Class'InterfaceClassic.UIControlNeedItemList';
	NeedItemListCtrlScript.SetRichListControler(NeedItem_ListCtrl);
	NeedItemListCtrlScript._SetUseDefaultBackground(true);
	NeedItemListCtrlScript.StartNeedItemList(1);
	NeedItemListCtrlScript.DelegateOnUpdateItem = HandleOnUpdateItem;
	NeedItemSelectArrow_btn.HideWindow();
	szReservedArray.Length = 0;
	return;
}

function HandleOnUpdateItem()
{
	DelegateOnUpdateItem();
	return;
}

function RichListCtrlRowData _GetRec(int Index)
{
	local RichListCtrlRowData Record;

	NeedItem_ListCtrl.GetRec(Index, Record);
	return Record;
}

function _ConnectPopup(WindowHandle wnd, optional bool bDescMode, optional int nDescColumnWidth)
{
	NeedItemSelectDialog_wnd = GetWindowHandle(wnd.m_WindowNameWithFullPath);
	descMode = bDescMode;
	wnd.SetScript("UIControlNeedItemSelectMultiItemsPopup");
	PopupScript = UIControlNeedItemSelectMultiItemsPopup(wnd.GetScript());
	PopupScript.InitWnd(wnd, bDescMode);
	if(bDescMode)
	{
		PopupScript.SetDescColumnWidth(nDescColumnWidth);
	}
	PopupScript.DelegateOnClick = ClickFunction;
	return;
}

function _SetNoticeTextChange(string noticeText)
{
	NoticeTextBox.SetText(noticeText);
	textBoxShortStringWithTooltip(NoticeTextBox, true);
	return;
}

function _SetNoticeTextColorChange(Color tColor)
{
	NoticeTextBox.SetTextColor(tColor);
	return;
}

function _SetHideMyNum(bool bHide)
{
	NeedItemListCtrlScript.SetHideMyNum(bHide);
	return;
}

function _DisableNeedItemSelectArrow_btn(bool bDiable)
{
	if(bDiable)
	{
		NeedItemSelectArrow_btn.DisableWindow();
	}
	else
	{
		NeedItemSelectArrow_btn.EnableWindow();
	}
	return;
}

function _Clear(optional bool bHideNoticeText)
{
	NeedItemListCtrlScript.CleariObjects();
	itemAmountsCur.Length = 0;
	_OpenPopup(false);
	NeedItemSelectArrow_btn.EnableWindow();
	if(bHideNoticeText)
	{
		NeedItemSelect_wnd.HideWindow();
		NeedItemSelectArrow_btn.HideWindow();
	}
	return;
}

function _StartSelectItems(int nItemNum, optional int nWidthSize, optional bool bClose, optional string titleString)
{
	StopHighlight();
	selectItemNum = nItemNum;
	NeedItemListCtrlScript.CleariObjects();
	NeedItemSelectArrow_btn.EnableWindow();
	szReservedArray.Length = 0;
	if((selectItemNum == 1))
	{
		_OpenPopup(false);
		NeedItemSelect_wnd.HideWindow();
	}
	else
	{
		_OpenPopup(!bClose);
		PopupScript._setListNum(nItemNum, nWidthSize, titleString);
		NeedItemSelect_wnd.ShowWindow();
	}
	return;
}

function _OpenPopup(bool bOpen)
{
	if(bOpen)
	{
		NeedItemSelectDialog_wnd.ShowWindow();
		if((selectItemNum > 0))
		{
			NeedItemSelectArrow_btn.ShowWindow();
		}
		else
		{
			NeedItemSelectArrow_btn.HideWindow();
		}
	}
	else
	{
		NeedItemSelectDialog_wnd.HideWindow();
		if((selectItemNum == 1))
		{
			NeedItemSelectArrow_btn.HideWindow();
		}
		else
		{
			NeedItemSelectArrow_btn.ShowWindow();
		}
	}
	return;
}

function _AddSelectItemClassID(int ItemClassID, INT64 ItemNum, optional string descString, optional Color descStringColor, optional string szReserved)
{
	szReservedArray[szReservedArray.Length] = szReserved;
	itemAmountsNew.Length = (itemAmountsNew.Length + 1);
	itemAmountsNew[(itemAmountsNew.Length - 1)].ItemClassID = ItemClassID;
	itemAmountsNew[(itemAmountsNew.Length - 1)].ItemAmount = ItemNum;
	if((selectItemNum == 1))
	{
		NeedItemListCtrlScript.AddNeedItemClassID(ItemClassID, ItemNum);
	}
	else
	{
		PopupScript.NeedItemSelectListCtrlScript.AddNeedItemClassID(ItemClassID, ItemNum);
		if((descMode && (descString != "")))
		{
			PopupScript.NeedItemSelectListCtrlScript._AddCellData((PopupScript.NeedItemSelectListCtrlScript.NeedItemRichListCtrl.GetRecordCount() - 1), MakeCellDataByString(descString, descStringColor));
		}
	}
	return;
}

function _AddNeedItemInfo(ItemInfo iInfo, INT64 needAmount, INT64 currAmount, optional string descString, optional Color descStringColor, optional string szReserved)
{
	szReservedArray[szReservedArray.Length] = szReserved;
	itemAmountsNew.Length = (itemAmountsNew.Length + 1);
	itemAmountsNew[(itemAmountsNew.Length - 1)].ItemClassID = iInfo.Id.ClassID;
	itemAmountsNew[(itemAmountsNew.Length - 1)].ItemAmount = needAmount;
	if((selectItemNum == 1))
	{
		NeedItemListCtrlScript.CleariObjects();
		NeedItemListCtrlScript.AddNeeItemInfo(iInfo, needAmount, currAmount);
	}
	else
	{
		PopupScript.NeedItemSelectListCtrlScript.AddNeeItemInfo(iInfo, needAmount, currAmount);
		if((descMode && (descString != "")))
		{
			PopupScript.NeedItemSelectListCtrlScript._AddCellData((PopupScript.NeedItemSelectListCtrlScript.NeedItemRichListCtrl.GetRecordCount() - 1), MakeCellDataByString(descString, descStringColor));
		}
	}
	return;
}

function _SetDescString(int ntargetItemClassID, string descString, optional Color applyColor)
{
	local int i, nClassID;

	if((selectItemNum != 1))
	{
		i = 0;
		while((i < PopupScript.NeedItemSelect_ListCtrl.GetRecordCount()))
		{
			nClassID = PopupScript.NeedItemSelectListCtrlScript._needItemClassIds[i];
			if((ntargetItemClassID == nClassID))
			{
				PopupScript.NeedItemSelectListCtrlScript._AddCellData(i, MakeCellDataByString(descString, applyColor));
				return;
			}
			i++;
		}
	}
	return;
}

function _SetDescCellData(int ntargetItemClassID, RichListCtrlCellData cellData)
{
	local int i, nClassID;

	if((selectItemNum != 1))
	{
		i = 0;
		while((i < PopupScript.NeedItemSelect_ListCtrl.GetRecordCount()))
		{
			nClassID = PopupScript.NeedItemSelectListCtrlScript._needItemClassIds[i];
			if((ntargetItemClassID == nClassID))
			{
				PopupScript.NeedItemSelectListCtrlScript._AddCellData(i, cellData);
				break;
			}
			i++;
		}
	}
	return;
}

function RichListCtrlCellData MakeCellDataByString(string descString, optional Color applyColor)
{
	local RichListCtrlCellData cellData;

	if(((((int(applyColor.R) == 0) && (int(applyColor.G) == 0)) && (int(applyColor.B) == 0)) && (int(applyColor.A) == 0)))
	{
		applyColor = getInstanceL2Util().BrightWhite;
	}
	AddRichListCtrlString(cellData.drawitems, descString, applyColor, false, 5, 0);
	return cellData;
}

function _EndSelectItems()
{
	if((selectItemNum == 1))
	{
		NeedItemListCtrlScript.SetBuyNum(INT64(1));
	}
	else
	{
		PopupScript.NeedItemSelectListCtrlScript.SetBuyNum(INT64(1));
	}
	if(ChkPlayHighlight())
	{
		PlayHighlight();
	}
	itemAmountsCur = itemAmountsNew;
	itemAmountsNew.Length = 0;
	return;
}

function bool ChkPlayHighlight()
{
	local int i;

	if((itemAmountsCur.Length == 0))
	{
		return false;
	}
	if((itemAmountsCur.Length != itemAmountsNew.Length))
	{
		return true;
	}
	i = 0;
	while((i < itemAmountsCur.Length))
	{
		if((itemAmountsCur[i] != itemAmountsNew[i]))
		{
			return true;
		}
		i++;
	}
	return false;
}

function _SetSelectByItemClassID(int ntargetItemClassID)
{
	local int i, nClassID;
	local INT64 nAmount;

	if((selectItemNum != 1))
	{
		i = 0;
		while((i < PopupScript.NeedItemSelect_ListCtrl.GetRecordCount()))
		{
			nClassID = PopupScript.NeedItemSelectListCtrlScript._needItemClassIds[i];
			nAmount = PopupScript.NeedItemSelectListCtrlScript._needAmounts[i];
			if((ntargetItemClassID == nClassID))
			{
				PopupScript.NeedItemSelect_ListCtrl.SetSelectedIndex(i, true);
				NeedItemSelect_wnd.HideWindow();
				NeedItemSelectArrow_btn.ShowWindow();
				NeedItemSelectDialog_wnd.HideWindow();
				NeedItemListCtrlScript.CleariObjects();
				NeedItemListCtrlScript.AddNeedItemClassID(nClassID, nAmount);
				NeedItemListCtrlScript.SetBuyNum(INT64(1));
				break;
			}
			i++;
		}
	}
	return;
}

function _SetSelectByIndex(int ntargetIndex)
{
	local int nClassID;
	local INT64 nAmount;

	if((selectItemNum != 1))
	{
		if((PopupScript.NeedItemSelect_ListCtrl.GetRecordCount() > 0))
		{
			nClassID = PopupScript.NeedItemSelectListCtrlScript._needItemClassIds[ntargetIndex];
			nAmount = PopupScript.NeedItemSelectListCtrlScript._needAmounts[ntargetIndex];
			PopupScript.NeedItemSelect_ListCtrl.SetSelectedIndex(ntargetIndex, true);
			NeedItemSelect_wnd.HideWindow();
			NeedItemSelectArrow_btn.ShowWindow();
			NeedItemSelectDialog_wnd.HideWindow();
			NeedItemListCtrlScript.CleariObjects();
			NeedItemListCtrlScript.AddNeedItemClassID(nClassID, nAmount);
			NeedItemListCtrlScript.SetBuyNum(INT64(1));
		}
	}
	return;
}

function bool _GetCanBuy()
{
	if((NeedItemListCtrlScript._needItemClassIds.Length > 0))
	{
		return NeedItemListCtrlScript.GetCanBuy();
	}
	else
	{
		return false;
	}
}

function INT64 _GetMaxNumCanBuy()
{
	return NeedItemListCtrlScript.GetMaxNumCanBuy();
}

function _ModifyCurrentAmountMe(INT64 currentAmount)
{
	if((NeedItemListCtrlScript._needAmounts.Length > 0))
	{
		NeedItemListCtrlScript.ModifyCurrentAmount(0, currentAmount);
	}
	return;
}

function int _GetMyClassID()
{
	if((NeedItemListCtrlScript._needItemClassIds.Length > 0))
	{
		return NeedItemListCtrlScript._needItemClassIds[0];
	}
	return -1;
}

function INT64 _GetMyAmount()
{
	if((NeedItemListCtrlScript._needAmounts.Length > 0))
	{
		return NeedItemListCtrlScript._needAmounts[0];
	}
	return INT64(-1);
}

function string _GetMySzReserved()
{
	if(((szReservedArray.Length > 0) && (_GetSelectedIndexPopup() > -1)))
	{
		return szReservedArray[_GetSelectedIndexPopup()];
	}
	return "";
}

function int _GetSelectedIndexPopup()
{
	if((selectItemNum == 1))
	{
		return 0;
	}
	return PopupScript.NeedItemSelect_ListCtrl.GetSelectedIndex();
}

function _ModifyCurrentAmountPopup(int Index, INT64 currentAmount)
{
	PopupScript.NeedItemSelectListCtrlScript.ModifyCurrentAmount(Index, currentAmount);
	return;
}

function _ModifyCurrentAmountPopupByClassID(int nClassID, INT64 currentAmount)
{
	local int i, ClassID;

	i = 0;
	while((i < PopupScript.NeedItemSelect_ListCtrl.GetRecordCount()))
	{
		ClassID = PopupScript.NeedItemSelectListCtrlScript._needItemClassIds[i];
		if((ClassID == nClassID))
		{
			PopupScript.NeedItemSelectListCtrlScript.ModifyCurrentAmount(i, currentAmount);
			break;
		}
		i++;
	}
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "__NeedItemSelectArrow_btn":
			onToggleSelectNeedItem();
			break;
		default:
			break;
	}
	return;
}

function onToggleSelectNeedItem()
{
	if(NeedItemSelectDialog_wnd.IsShowWindow())
	{
		NeedItemSelectDialog_wnd.HideWindow();
	}
	else
	{
		NeedItemSelectDialog_wnd.ShowWindow();
	}
	return;
}

function bool _isOpenPopup()
{
	return PopupScript.Me.IsShowWindow();
}

function PlayHighlight()
{
	NeedItemSlotAni_tex.ShowWindow();
	NeedItemSlotAni_tex.Stop();
	NeedItemSlotAni_tex.SetLoopCount(1);
	NeedItemSlotAni_tex.Play();
	return;
}

function StopHighlight()
{
	NeedItemSlotAni_tex.HideWindow();
	Debug("_StopHighlight");
	return;
}

function ClickFunction(int selectNeedItemIndex, int selectedClassID, INT64 selectedAmount)
{
	NeedItemListCtrlScript.CleariObjects();
	NeedItemListCtrlScript.AddNeedItemClassID(selectedClassID, selectedAmount);
	NeedItemListCtrlScript.SetBuyNum(INT64(1));
	NeedItemSelect_wnd.HideWindow();
	NeedItemSelectArrow_btn.ShowWindow();
	PopupScript.Me.HideWindow();
	DelegateSelectedItemOnClick(selectNeedItemIndex, selectedClassID, selectedAmount);
	return;
}
