class UIControlNeedItemSelectMultiItemsPopup extends UICommonAPI;

var string m_Windowname;
var WindowHandle Me;
var RichListCtrlHandle NeedItemSelect_ListCtrl;
var UIControlNeedItemList NeedItemSelectListCtrlScript;
var TextBoxHandle Title_Txt;
var int selectListNum;
var bool descMode;
var int nDescColumnWidth;
//var delegate<DelegateOnClick> __DelegateOnClick__Delegate;

delegate DelegateOnClick(int selectNeedItemIndex, int selectedClassID, INT64 selectedAmount)
{
	return;
}

function InitWnd(WindowHandle wnd, bool bDescMode)
{
	descMode = bDescMode;
	m_hOwnerWnd = wnd;
	SetWindow(m_hOwnerWnd.m_WindowNameWithFullPath);
	return;
}

function SetDescColumnWidth(int nWidth)
{
	nDescColumnWidth = nWidth;
	return;
}

function SetWindow(string WindowName)
{
	m_Windowname = WindowName;
	Me = GetWindowHandle(m_Windowname);
	Title_Txt = GetTextBoxHandle(((m_Windowname $ ".") $ "Title_Txt"));
	NeedItemSelect_ListCtrl = GetRichListCtrlHandle(((m_Windowname $ ".") $ "NeedItemSelect_ListCtrl"));
	NeedItemSelectListCtrlScript = new Class'InterfaceClassic.UIControlNeedItemList';
	NeedItemSelectListCtrlScript.SetRichListControler(NeedItemSelect_ListCtrl);
	NeedItemSelectListCtrlScript._SetUseDefaultBackground(true);
	NeedItemSelect_ListCtrl.SetSelectable(true);
	NeedItemSelect_ListCtrl.SetUseSelectionTexture(false);
	return;
}

function _setListNum(int nListNum, optional int nWidthSize, optional string titleString)
{
	local bool bUseTitleText;
	local string tooltipStr;

	selectListNum = nListNum;
	NeedItemSelectListCtrlScript.CleariObjects();
	Title_Txt.SetText(titleString);
	if((nWidthSize <= 0))
	{
		nWidthSize = Me.GetRect().nWidth;
	}
	if((Len(titleString) == 0))
	{
		NeedItemSelect_ListCtrl.MoveC(6, 6);
		bUseTitleText = false;
		Title_Txt.HideWindow();
		Title_Txt.ClearTooltip();
	}
	else
	{
		bUseTitleText = true;
		Title_Txt.ShowWindow();
		tooltipStr = makeShortStringByPixel(titleString, (nWidthSize - 20), "...", "HS12");
		Title_Txt.SetText(tooltipStr);
		if((InStr(tooltipStr, "...") == -1))
		{
			Title_Txt.SetTooltipType("");
			Title_Txt.ClearTooltip();
		}
		else
		{
			Title_Txt.SetTooltipType("text");
			Title_Txt.SetTooltipString(titleString);
		}
		NeedItemSelect_ListCtrl.MoveC(6, (Title_Txt.GetRect().nHeight + 1));
	}
	if(bUseTitleText)
	{
		Me.SetWindowSize(nWidthSize, ((((40 * selectListNum) + 12) + Title_Txt.GetRect().nHeight) - 4));
	}
	else
	{
		Me.SetWindowSize(nWidthSize, ((40 * selectListNum) + 12));
	}
	NeedItemSelectListCtrlScript.StartNeedItemList(selectListNum);
	NeedItemSelect_ListCtrl.AdjustShowRow(selectListNum);
	NeedItemSelect_ListCtrl.SetWindowSize(nWidthSize, (40 * selectListNum));
	if(descMode)
	{
		if((nDescColumnWidth <= 0))
		{
			nDescColumnWidth = 100;
		}
		NeedItemSelect_ListCtrl.SetColumnWidth(0, ((nWidthSize - 13) - nDescColumnWidth));
		NeedItemSelect_ListCtrl.SetColumnWidth(1, nDescColumnWidth);
	}
	else
	{
		NeedItemSelect_ListCtrl.SetColumnWidth(0, (nWidthSize - 13));
	}
	return;
}

event OnClickListCtrlRecord(string strID)
{
	local int selectNeedItemIndex, selectedClassID;
	local INT64 selectedAmount;

	selectNeedItemIndex = NeedItemSelect_ListCtrl.GetSelectedIndex();
	selectedClassID = NeedItemSelectListCtrlScript._needItemClassIds[selectNeedItemIndex];
	selectedAmount = NeedItemSelectListCtrlScript._needAmounts[selectNeedItemIndex];
	DelegateOnClick(selectNeedItemIndex, selectedClassID, selectedAmount);
	return;
}
