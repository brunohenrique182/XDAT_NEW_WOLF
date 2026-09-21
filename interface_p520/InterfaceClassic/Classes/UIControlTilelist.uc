class UIControlTilelist extends UICommonAPI;

enum clickType
{
	non,                            // 0
	Button,                         // 1
	itemRenderer,                   // 2
	Max                             // 3
};

struct clickData
{
	var clickType Type;
	var int rendererIndex;
	var string Name;
	var ButtonHandle btnHandle;
};

var int itemNumTotal;
var int ownerStandardWH;
var int itemRendererNum;
var int standardNum;
var int standardWH;
var int rendererNumPerScroll;
var int scrollLineNum;
var int firstIndex;
var int maxScrollLine;
var L2UITimerObject tickTimerObject;
var L2UITimerObject tickTimerObjectClick;
var L2UITimerObject tickTImerObjectRefresh;
var clickData clickDataLast;
var int pressedRendererIndex;
var bool bUsePage;
var bool bUseOver;
var bool bUseSelect;
var bool bDontUseAnimation;
var int overedRendererIndex;
var int selectedRendererIndex;
var int overedIndex;
var int SelectedIndex;
var bool bOptionChanged;
//var delegate<DelegateOnScroll> __DelegateOnScroll__Delegate;
//var delegate<DelegateOnItemRenderer> __DelegateOnItemRenderer__Delegate;
//var delegate<DelegateOnSelect> __DelegateOnSelect__Delegate;
//var delegate<DelegateOnRendererClick> __DelegateOnRendererClick__Delegate;
//var delegate<DelegateOnClick> __DelegateOnClick__Delegate;
//var delegate<DelegateOnClickWithHandle> __DelegateOnClickWithHandle__Delegate;

function _SetUsePage(bool bUse)
{
	bUsePage = bUse;
	bOptionChanged = true;
	if(bUse)
	{
		rendererNumPerScroll = _GetItemRendererNum();
	}
	else
	{
		rendererNumPerScroll = standardNum;
	}
	scrollLineNum = (rendererNumPerScroll / standardNum);
	Validate();
	return;
}

delegate DelegateOnScroll()
{
	return;
}

delegate DelegateOnItemRenderer(string itemRendererID, int rendererIndex, int itemIndex)
{
	return;
}

delegate DelegateOnSelect(string itemRendererID, int rendererIndex, int itemIndex)
{
	return;
}

delegate DelegateOnRendererClick(string itemRendererPath, int rendererIndex, int itemIndex)
{
	return;
}

delegate DelegateOnClick(string BTNID, int rendererIndex, int itemIndex)
{
	return;
}

delegate DelegateOnClickWithHandle(ButtonHandle btnHandle, int rendererIndex, int itemIndex)
{
	return;
}

static function UIControlTilelist InitScript(WindowHandle wnd, int Col, int Row, optional bool _bV)
{
	local UIControlTilelist scr;

	wnd.SetScript("UIControlTilelist");
	scr = UIControlTilelist(wnd.GetScript());
	scr.InitWnd(wnd, Col, Row, _bV);
	return scr;
}

function InitWnd(WindowHandle wnd, int Col, int Row, bool _bV)
{
	m_hOwnerWnd = wnd;
	tickTimerObject = Class'InterfaceClassic.L2UITimer'.static.Inst()._MakeTimerObject(1, 1, 0);
	tickTimerObject._DelegateOnEnd = RefreshState;
	tickTimerObjectClick = Class'InterfaceClassic.L2UITimer'.static.Inst()._MakeTimerObject(1, 1, 0);
	tickTimerObjectClick._DelegateOnEnd = HandleClick;
	tickTImerObjectRefresh = Class'InterfaceClassic.L2UITimer'.static.Inst()._MakeTimerObject(1, 1, 0);
	tickTImerObjectRefresh._DelegateOnEnd = RefreshRenderer;
	itemRendererNum = (Row * Col);
	InitTileList(Col, Row, _bV);
	InitState();
	scrollLineNum = 1;
	rendererNumPerScroll = standardNum;
	ClearRendererIndexes();
	return;
}

function InitState()
{
	local int i;
	local string rendererPath;

	overedIndex = -1;
	overedRendererIndex = -1;
	SelectedIndex = -1;
	selectedRendererIndex = -1;
	bUseOver = (GetTextureHandle((_GetRendererPath(0) $ ".OverTexture")).GetParentWindowName() != "");
	bUseSelect = (GetTextureHandle((_GetRendererPath(0) $ ".SelectTexture")).GetParentWindowName() != "");
	i = 0;
	while((i < _GetItemRendererNum()))
	{
		rendererPath = _GetRendererPath(i);
		if(bUseOver)
		{
			if(bDontUseAnimation)
			{
				GetTextureHandle((rendererPath $ ".OverTexture")).HideWindow();
			}
			else
			{
				GetTextureHandle((rendererPath $ ".OverTexture")).SetAlpha(0);
			}
		}
		if(bUseSelect)
		{
			if(bDontUseAnimation)
			{
				GetTextureHandle((rendererPath $ ".SelectTexture")).HideWindow();
				i++;
				continue;
			}
			GetTextureHandle((rendererPath $ ".SelectTexture")).SetAlpha(0);
		}
		i++;
	}
	return;
}

function InitTileList(int colNum, int rowNum, bool _bV)
{
	local int _ownerWndW, _ownerWndH;

	m_hOwnerWnd.GetWindowSize(_ownerWndW, _ownerWndH);
	if(_bV)
	{
		standardNum = colNum;
		standardWH = (_ownerWndH / rowNum);
		ownerStandardWH = _ownerWndH;
	}
	else
	{
		standardNum = rowNum;
		standardWH = (_ownerWndW / colNum);
		ownerStandardWH = _ownerWndW;
	}
	return;
}

event OnScrollMove(string strID, int pos)
{
	OnScroll(pos);
	return;
}

event OnMouseOut(WindowHandle a_WindowHandle)
{
	local int rendererIndex;

	if(bUseOver)
	{
		rendererIndex = _GetItemRendererIndexWithWindow(a_WindowHandle);
		if((rendererIndex > -1))
		{
			_SetOver(-1);
		}
	}
	return;
}

event OnMouseOver(WindowHandle a_WindowHandle)
{
	local int rendererIndex;

	if(bUseOver)
	{
		rendererIndex = _GetItemRendererIndexWithWindow(a_WindowHandle);
		if((rendererIndex > -1))
		{
			_SetOver(_GetItemIndexWithRendererIndex(rendererIndex));
		}
	}
	return;
}

event OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	ValidateClick(Button, a_ButtonHandle.GetWindowName(), _GetItemRendererIndexWithWindow(a_ButtonHandle), a_ButtonHandle);
	return;
}

event OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	if(ChkInRenderer(pressedRendererIndex, X, Y))
	{
		ValidateClick(itemRenderer, a_WindowHandle.GetWindowName(), pressedRendererIndex);
	}
	return;
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	pressedRendererIndex = _GetItemRendererIndexWithWindow(a_WindowHandle);
	if(bUseSelect)
	{
		if((pressedRendererIndex > -1))
		{
			_SetSelect(_GetItemIndexWithRendererIndex(pressedRendererIndex));
		}
	}
	return;
}

function HandleClick()
{
	switch(clickDataLast.Type)
	{
		case Button:
			DelegateOnClick(clickDataLast.Name, clickDataLast.rendererIndex, _GetItemIndexWithRendererIndex(clickDataLast.rendererIndex));
			DelegateOnClickWithHandle(clickDataLast.btnHandle, clickDataLast.rendererIndex, _GetItemIndexWithRendererIndex(clickDataLast.rendererIndex));
			break;
		case itemRenderer:
			DelegateOnRendererClick(clickDataLast.Name, clickDataLast.rendererIndex, _GetItemIndexWithRendererIndex(clickDataLast.rendererIndex));
			break;
		default:
			break;
	}
	ClearRendererIndexes();
	return;
}

function RefreshOption()
{
	ApplyTileListSetting();
	bOptionChanged = false;
	return;
}

function RefreshState()
{
	local int rendererIndex;

	if(bOptionChanged)
	{
		RefreshOption();
	}
	rendererIndex = _GetItemRendererIndex(overedIndex);
	if((overedRendererIndex != rendererIndex))
	{
		if(((overedRendererIndex > -1) && (overedRendererIndex < itemRendererNum)))
		{
			if(bDontUseAnimation)
			{
				GetTextureHandle((_GetRendererPath(overedRendererIndex) $ ".OverTexture")).HideWindow();
			}
			else
			{
				GetTextureHandle((_GetRendererPath(overedRendererIndex) $ ".OverTexture")).SetAlpha(0, 0.1000000);
			}
		}
		if(((rendererIndex > -1) && (rendererIndex < itemRendererNum)))
		{
			if(bDontUseAnimation)
			{
				GetTextureHandle((_GetRendererPath(rendererIndex) $ ".OverTexture")).ShowWindow();
			}
			else
			{
				GetTextureHandle((_GetRendererPath(rendererIndex) $ ".OverTexture")).SetAlpha(255);
			}
		}
		overedRendererIndex = rendererIndex;
	}
	rendererIndex = _GetItemRendererIndex(SelectedIndex);
	if((selectedRendererIndex != rendererIndex))
	{
		if(((selectedRendererIndex > -1) && (selectedRendererIndex < itemRendererNum)))
		{
			if(bDontUseAnimation)
			{
				GetTextureHandle((_GetRendererPath(selectedRendererIndex) $ ".SelectTexture")).HideWindow();
			}
			else
			{
				GetTextureHandle((_GetRendererPath(selectedRendererIndex) $ ".SelectTexture")).SetAlpha(0);
			}
		}
		if(((rendererIndex > -1) && (rendererIndex < itemRendererNum)))
		{
			if(bDontUseAnimation)
			{
				GetTextureHandle((_GetRendererPath(rendererIndex) $ ".SelectTexture")).ShowWindow();
			}
			else
			{
				GetTextureHandle((_GetRendererPath(rendererIndex) $ ".SelectTexture")).SetAlpha(255);
			}
			DelegateOnSelect(_GetRendererPath(rendererIndex), rendererIndex, SelectedIndex);
		}
		selectedRendererIndex = _GetItemRendererIndex(SelectedIndex);
	}
	return;
}

function RefreshRenderer()
{
	_Refresh();
	return;
}

function Validate()
{
	tickTimerObject._Reset();
	return;
}

function ValidateClick(clickType Type, string btnName, int rendererIndex, optional ButtonHandle btnHandle)
{
	if((int(clickDataLast.Type) == 1))
	{
		return;
	}
	clickDataLast.Type = Type;
	clickDataLast.Name = btnName;
	clickDataLast.btnHandle = btnHandle;
	clickDataLast.rendererIndex = rendererIndex;
	tickTimerObjectClick._Reset();
	return;
}

function ValidateRefresh()
{
	tickTImerObjectRefresh._Reset();
	return;
}

function _DontUseAnimation(bool _bDontUseAnimation)
{
	bDontUseAnimation = _bDontUseAnimation;
	InitState();
	return;
}

function _SetPage(int Page)
{
	SetScrollIndex(Page);
	return;
}

function _NextPage()
{
	_SetPage(Min(GetScrollIndexMax(), (GetScrollIndex() + 1)));
	return;
}

function _PrevPage()
{
	_SetPage(Max(0, (GetScrollIndex() - 1)));
	return;
}

function int _PageMax()
{
	return GetScrollIndexMax();
}

function int _Page()
{
	return GetScrollIndex();
}

function _GotoItemIndex(int itemIndex)
{
	_SetPage((itemIndex / rendererNumPerScroll));
	return;
}

function _SetTileListItemNumTotal(int _itemNumTotal)
{
	itemNumTotal = _itemNumTotal;
	ApplyTileListSetting();
	return;
}

function int _GetSelectedIndex()
{
	return SelectedIndex;
}

function int _GetSelectedRendererIndex()
{
	return selectedRendererIndex;
}

function int _GetOveredIndex()
{
	return overedIndex;
}

function int _GetOveredRendererIndex()
{
	return overedRendererIndex;
}

function int _GetItemNumTotal()
{
	return itemNumTotal;
}

function int _GetItemRendererNum()
{
	return itemRendererNum;
}

function int _GetItemIndexWithRendererIndex(int itemRendererNum)
{
	if((firstIndex < 0))
	{
		return itemRendererNum;
	}
	return (firstIndex + itemRendererNum);
}

function int _GetItemRendererIndex(int Index)
{
	if((firstIndex < 0))
	{
		return -1;
	}
	return (Index - firstIndex);
}

function int _GetItemRendererIndexWithWindow(WindowHandle childWindow)
{
	local int i;
	local WindowHandle tmpWnd;

	if((childWindow == none))
	{
		return -1;
	}
	if((childWindow.m_pTargetWnd == none))
	{
		return -1;
	}
	i = 0;
	while((i < itemRendererNum))
	{
		tmpWnd = GetWindowHandleItemRederer(i);
		if((tmpWnd.GetWindowName() == ""))
		{
			i++;
			continue;
		}
		if(childWindow.IsChildOf(tmpWnd))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function _SetUseSelect(bool bUseSelectP)
{
	local int i;

	if((bUseSelect && !bUseSelectP))
	{
		i = 0;
		while((i < _GetItemRendererNum()))
		{
			if(bDontUseAnimation)
			{
				GetTextureHandle((_GetRendererPath(i) $ ".SelectTexture")).HideWindow();
				i++;
				continue;
			}
			GetTextureHandle((_GetRendererPath(i) $ ".SelectTexture")).SetAlpha(0);
			i++;
		}
		SelectedIndex = -1;
		selectedRendererIndex = -1;
	}
	bUseSelect = bUseSelectP;
	return;
}

function _SetUseOver(bool bUseOverP)
{
	local int i;

	if(bUseOver)
	{
		i = 0;
		while((i < _GetItemRendererNum()))
		{
			if(bDontUseAnimation)
			{
				GetTextureHandle((_GetRendererPath(i) $ ".OverTexture")).HideWindow();
				i++;
				continue;
			}
			GetTextureHandle((_GetRendererPath(i) $ ".OverTexture")).SetAlpha(0);
			i++;
		}
	}
	bUseOver = bUseOverP;
	return;
}

function _Refresh()
{
	local int i, showenlen, itemIndex, firstItemIndex;

	showenlen = _GetItemRendererNum();
	firstItemIndex = _GetItemIndexWithRendererIndex(i);
	i = 0;
	while((i < showenlen))
	{
		itemIndex = (firstItemIndex + i);
		DelegateOnItemRenderer(_GetRendererPath(i), i, itemIndex);
		i++;
	}
	return;
}

function _RefreshRenderer(int itemRendererIndex)
{
	local int itemIndex;

	itemIndex = _GetItemIndexWithRendererIndex(itemRendererIndex);
	DelegateOnItemRenderer(_GetRendererPath(itemRendererIndex), itemRendererIndex, itemIndex);
	return;
}

function _SetSelect(int itemIndex, optional bool forceToSelect)
{
	if((SelectedIndex == itemIndex))
	{
		return;
	}
	SelectedIndex = itemIndex;
	if(forceToSelect)
	{
		_SetPage((itemIndex / rendererNumPerScroll));
	}
	Validate();
	return;
}

function _SetOver(int itemIndex)
{
	if((overedIndex == itemIndex))
	{
		return;
	}
	overedIndex = itemIndex;
	Validate();
	return;
}

function ApplyTileListSetting()
{
	SetMaxScrollLine();
	GetWindowHandleScrollArea().SetScrollHeight(GetScrollMaxPosition());
	GetWindowHandleScrollArea().SetScrollUnit(GetPageWidth(), true);
	firstIndex = -1;
	GetWindowHandleScrollArea().SetScrollPosition(0);
	return;
}

function SetMaxScrollLine()
{
	maxScrollLine = (_GetItemNumTotal() / rendererNumPerScroll);
	if((_GetItemNumTotal() > (maxScrollLine * rendererNumPerScroll)))
	{
		maxScrollLine++;
	}
	return;
}

function OnScroll(int pos)
{
	local int tmpSelectedRendererIndex, currentFirstIndex, Page;

	pos = Max(0, pos);
	Page = (pos / GetPageWidth());
	if((pos != (Page * GetPageWidth())))
	{
		GetWindowHandleScrollArea().SetScrollPosition((Page * GetPageWidth()));
		return;
	}
	currentFirstIndex = (Page * rendererNumPerScroll);
	if((firstIndex == currentFirstIndex))
	{
		return;
	}
	tmpSelectedRendererIndex = _GetItemRendererIndex(SelectedIndex);
	if(((tmpSelectedRendererIndex > -1) && (tmpSelectedRendererIndex < _GetItemRendererNum())))
	{
		if(bDontUseAnimation)
		{
			GetTextureHandle((_GetRendererPath(tmpSelectedRendererIndex) $ ".SelectTexture")).HideWindow();
		}
		else
		{
			GetTextureHandle((_GetRendererPath(tmpSelectedRendererIndex) $ ".SelectTexture")).SetAlpha(0);
		}
	}
	firstIndex = currentFirstIndex;
	if((overedRendererIndex > -1))
	{
		overedIndex = _GetItemIndexWithRendererIndex(overedRendererIndex);
	}
	ValidateRefresh();
	Validate();
	DelegateOnScroll();
	return;
}

function SetScrollIndex(int scrollINdex)
{
	GetWindowHandleScrollArea().SetScrollPosition((Min(GetScrollIndexMax(), scrollINdex) * GetPageWidth()));
	return;
}

function int GetScrollIndex()
{
	return (GetScrollPosition() / GetPageWidth());
}

function int GetScrollIndexMax()
{
	return ((GetScrollMaxPosition() - ownerStandardWH) / GetPageWidth());
}

function int GetScrollPosition()
{
	return GetWindowHandleScrollArea().GetScrollPosition();
}

function string _GetScrollPath()
{
	return (m_hOwnerWnd.m_WindowNameWithFullPath $ ".ScrollArea");
}

function string _GetRendererPath(int itemRendererIndex)
{
	return ((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ScrollArea.itemRenderer") $ Int2Str(itemRendererIndex));
}

function WindowHandle GetWindowHandleItemRederer(int itemRendererIndex)
{
	return GetWindowHandle(_GetRendererPath(itemRendererIndex));
}

function WindowHandle GetWindowHandleScrollArea()
{
	return GetWindowHandle(_GetScrollPath());
}

function int GetScrollMaxPosition()
{
	return (maxScrollLine * GetPageWidth());
}

function int GetPageWidth()
{
	return (standardWH * scrollLineNum);
}

function string Int2Str(int Num)
{
	if((Num < 10))
	{
		return ("0" $ string(Num));
	}
	return string(Num);
}

function bool ChkInRenderer(int rendererIndex, int X, int Y)
{
	local Rect rendererRect;

	if((rendererIndex < 0))
	{
		return false;
	}
	if((rendererIndex >= _GetItemRendererNum()))
	{
		return false;
	}
	rendererRect = GetWindowHandle(_GetRendererPath(rendererIndex)).GetRect();
	if((X < rendererRect.nX))
	{
		return false;
	}
	if((X > (rendererRect.nX + rendererRect.nWidth)))
	{
		return false;
	}
	if((Y < rendererRect.nY))
	{
		return false;
	}
	if((Y > (rendererRect.nY + rendererRect.nHeight)))
	{
		return false;
	}
	return true;
}

function ClearRendererIndexes()
{
	local ButtonHandle defaultHandle;

	pressedRendererIndex = -1;
	clickDataLast.Type = non;
	clickDataLast.Name = "";
	clickDataLast.btnHandle = defaultHandle;
	clickDataLast.rendererIndex = -1;
	return;
}
