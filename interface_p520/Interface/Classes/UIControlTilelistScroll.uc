class UIControlTilelistScroll extends UICommonAPI;

enum clickType
{
	non,                            // 0
	Button,                         // 1
	renderer,                       // 2
	Max                             // 3
};

struct clickData
{
	var clickType Type;
	var int rendererID;
	var string Name;
	var ButtonHandle btnHandle;
};

var bool bv;
var int rendererNumTotal;
var int standardLineNum;
var int standardNumPerLine;
var int standardSize;
var L2UITimerObject tickTimerObject;
var L2UITimerObject tickTimerObjectClick;
var L2UITimerObject tickTImerObjectRefreshOnScroll;
var L2UITimerObject tickTimerObjectScroll;
var int TargetIndex;
var INT64 clientStartSec;
var float timeMilsec;
var int startLineNum;
var int overedIndex;
var int SelectedIndex;
var bool bOptionChanged;
var clickData clickDataLast;
var int pressedRendererID;
var bool bDontUseScrollTween;
var int Length;
var bool bUseOver;
var bool bUseSelect;
var string rendererName;
//var delegate<DelegateOnScroll> __DelegateOnScroll__Delegate;
//var delegate<DelegateOnRenderer> __DelegateOnRenderer__Delegate;
//var delegate<DelegateOnSelect> __DelegateOnSelect__Delegate;
//var delegate<DelegateOnRendererClick> __DelegateOnRendererClick__Delegate;
//var delegate<DelegateOnClick> __DelegateOnClick__Delegate;
//var delegate<DelegateOnClickWithHandle> __DelegateOnClickWithHandle__Delegate;
//var delegate<DelegateOnSort> __DelegateOnSort__Delegate;

delegate DelegateOnScroll()
{
	return;
}

delegate DelegateOnRenderer(string rendererPath, int rendererID, int itemIndex)
{
	return;
}

delegate DelegateOnSelect(string rendererPath, int rendererID, int itemIndex)
{
	return;
}

delegate DelegateOnRendererClick(string rendererPath, int rendererID, int itemIndex)
{
	return;
}

delegate DelegateOnClick(string btnName, int rendererID, int itemIndex)
{
	return;
}

delegate DelegateOnClickWithHandle(ButtonHandle btnHandle, int rendererID, int itemIndex)
{
	return;
}

delegate DelegateOnSort(int sortIndex, int SortOrder)
{
	return;
}

static function UIControlTilelistScroll InitScript(WindowHandle wnd, int Col, int Row, optional bool _bV, optional string _rendererName)
{
	local UIControlTilelistScroll scr;

	wnd.SetScript("UIControlTilelistScroll");
	scr = UIControlTilelistScroll(wnd.GetScript());
	scr.InitWnd(wnd, Col, Row, _bV, _rendererName);
	return scr;
}

function InitWnd(WindowHandle wnd, int Col, int Row, bool _bV, string _rendererName)
{
	m_hOwnerWnd = wnd;
	if((_rendererName == ""))
	{
		rendererName = "renderer";
	}
	else
	{
		rendererName = _rendererName;
	}
	InitTickTimers();
	InitTileList(Col, Row, _bV);
	InitState();
	ClearRendererIDs();
	return;
}

function InitTickTimers()
{
	tickTimerObject = Class'Interface.L2UITimer'.static.Inst()._MakeTimerObject(1, 1, 0);
	tickTimerObject._DelegateOnEnd = RefreshState;
	tickTimerObjectClick = Class'Interface.L2UITimer'.static.Inst()._MakeTimerObject(1, 1, 0);
	tickTimerObjectClick._DelegateOnEnd = HandleClick;
	tickTImerObjectRefreshOnScroll = Class'Interface.L2UITimer'.static.Inst()._MakeTimerObject(1, 1, 0);
	tickTImerObjectRefreshOnScroll._DelegateOnEnd = RefreshRendererOnScroll;
	tickTimerObjectScroll = Class'Interface.L2UITimer'.static.Inst()._MakeTimerObject(1, -1);
	tickTimerObjectScroll._DelegateOnStart = ScrollMoveStart;
	tickTimerObjectScroll._DelegateOnTime = ScrollMove;
	return;
}

function InitState()
{
	local int i;
	local string rendererPath;

	overedIndex = -1;
	SelectedIndex = -1;
	bUseOver = (GetTextureHandle((_GetRendererPath(0) $ ".OverTexture")).GetParentWindowName() != "");
	bUseSelect = (GetTextureHandle((_GetRendererPath(0) $ ".SelectTexture")).GetParentWindowName() != "");
	i = 0;
	while((i < _GetRendererNumTotal()))
	{
		rendererPath = _GetRendererPath(i);
		if(bUseOver)
		{
			GetTextureHandle((rendererPath $ ".OverTexture")).HideWindow();
		}
		if(bUseSelect)
		{
			GetTextureHandle((rendererPath $ ".SelectTexture")).HideWindow();
		}
		i++;
	}
	return;
}

function InitTileList(int Col, int Row, bool _bV)
{
	local int W, h;

	bv = _bV;
	rendererNumTotal = (Row * Col);
	GetWindowHandleItemRederer(0).GetWindowSize(W, h);
	if(bv)
	{
		standardLineNum = Row;
		standardNumPerLine = Col;
		standardSize = h;
	}
	else
	{
		standardLineNum = Col;
		standardNumPerLine = Row;
		standardSize = W;
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
	local int rendererID;

	if(bUseOver)
	{
		rendererID = _GetRendererIDWithWindow(a_WindowHandle);
		if((rendererID > -1))
		{
			_SetOver(-1);
		}
	}
	return;
}

event OnMouseOver(WindowHandle a_WindowHandle)
{
	local int rendererID;

	if(bUseOver)
	{
		rendererID = _GetRendererIDWithWindow(a_WindowHandle);
		if((rendererID > -1))
		{
			_SetOver(_GetItemIndexWithRendererID(rendererID));
		}
	}
	return;
}

event OnClickButton(string strID)
{
	ExeSort(strID);
	return;
}

function ExeSort(string strID)
{
	local int Index, SortOrder;

	Index = int(Right(strID, 1));
	SortOrder = GetButtonHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ strID)).GetButtonValue();
	SortOrder = (1 - SortOrder);
	GetButtonHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ strID)).SetButtonValue(SortOrder);
	DelegateOnSort(Index, SortOrder);
	_Refresh();
	return;
}

function int GetTestSortOrder(optional int Index)
{
	return GetButtonHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".header") $ string(Index))).GetButtonValue();
}

event OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	ValidateClick(Button, a_ButtonHandle.GetWindowName(), _GetRendererIDWithWindow(a_ButtonHandle), a_ButtonHandle);
	return;
}

event OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	if(ChkInRenderer(pressedRendererID, X, Y))
	{
		ValidateClick(renderer, a_WindowHandle.GetWindowName(), pressedRendererID);
	}
	return;
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	pressedRendererID = _GetRendererIDWithWindow(a_WindowHandle);
	if(bUseSelect)
	{
		if((pressedRendererID > -1))
		{
			_SetSelect(_GetItemIndexWithRendererID(pressedRendererID));
		}
	}
	return;
}

function HandleClick()
{
	switch(clickDataLast.Type)
	{
		case Button:
			DelegateOnClick(clickDataLast.Name, clickDataLast.rendererID, _GetItemIndexWithRendererID(clickDataLast.rendererID));
			DelegateOnClickWithHandle(clickDataLast.btnHandle, clickDataLast.rendererID, _GetItemIndexWithRendererID(clickDataLast.rendererID));
			break;
		case renderer:
			DelegateOnRendererClick(clickDataLast.Name, clickDataLast.rendererID, _GetItemIndexWithRendererID(clickDataLast.rendererID));
			break;
		default:
			break;
	}
	ClearRendererIDs();
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
	local int rendererID;

	if(bOptionChanged)
	{
		RefreshOption();
	}
	rendererID = _GetRendererID(overedIndex);
	if((rendererID == -1))
	{
		if((overedIndex != -1))
		{
			GetTextureHandle((_GetRendererPath(_GetOveredRendererID()) $ ".OverTexture")).HideWindow();
		}
	}
	else
	{
		GetTextureHandle((_GetRendererPath(rendererID) $ ".OverTexture")).ShowWindow();
	}
	rendererID = _GetRendererID(SelectedIndex);
	if((rendererID == -1))
	{
		if((SelectedIndex != -1))
		{
			GetTextureHandle((_GetRendererPath(_GetSelectedRendererID()) $ ".SelectTexture")).HideWindow();
		}
	}
	else
	{
		GetTextureHandle((_GetRendererPath(rendererID) $ ".SelectTexture")).ShowWindow();
	}
	return;
}

function RefreshRendererOnScroll()
{
	Repositioning(true);
	return;
}

function _SetScrollTween()
{
	tickTimerObjectScroll._Reset();
	return;
}

function ScrollMoveStart()
{
	clientStartSec = GetAppMilliSeconds();
	timeMilsec = ((float((startLineNum - (TargetIndex / standardNumPerLine))) * float(standardSize)) / 10.0000000);
	if((timeMilsec < 0.0000000))
	{
		timeMilsec = (timeMilsec * -1.0000000);
	}
	return;
}

function ScrollMove(int Time)
{
	local int pos, TargetPos;
	local float Position, ratio;

	Position = (float((GetAppMilliSeconds() - clientStartSec)) / timeMilsec);
	if((Position >= 1.0000000))
	{
		tickTimerObjectScroll._Stop();
		ratio = 1.0000000;
	}
	else
	{
		ratio = Class'Interface.L2UITween'.static.Inst().easeOutStrong(Position, 0.0000000, 1.0000000, 1.0000000);
	}
	pos = GetScrollPosition();
	TargetPos = Min((standardSize * (TargetIndex / standardNumPerLine)), GetScrollMaxPosition());
	GetWindowHandleScrollArea().SetScrollPosition(int((float(pos) + (float((TargetPos - pos)) * ratio))));
	return;
}

function Validate()
{
	tickTimerObject._Reset();
	return;
}

function ValidateClick(clickType Type, string btnName, int rendererID, optional ButtonHandle btnHandle)
{
	if((int(clickDataLast.Type) == 1))
	{
		return;
	}
	clickDataLast.Type = Type;
	clickDataLast.Name = btnName;
	clickDataLast.btnHandle = btnHandle;
	clickDataLast.rendererID = rendererID;
	tickTimerObjectClick._Reset();
	return;
}

function ValidateRefreshOnScroll()
{
	tickTImerObjectRefreshOnScroll._Reset();
	return;
}

function _SetDontUseScrollTween(bool bUse)
{
	bDontUseScrollTween = bUse;
	return;
}

function _SetSelect(int itemIndex, optional bool forceToSelect)
{
	local int rendererID;

	if((itemIndex >= Length))
	{
		itemIndex = -1;
	}
	if(forceToSelect)
	{
		if((itemIndex != -1))
		{
			TargetIndex = itemIndex;
			if(bDontUseScrollTween)
			{
				SetScrollIndex(TargetIndex);
			}
			else
			{
				_SetScrollTween();
			}
		}
	}
	if((SelectedIndex == itemIndex))
	{
		return;
	}
	if((SelectedIndex != -1))
	{
		GetTextureHandle((_GetRendererPath(_GetSelectedRendererID()) $ ".SelectTexture")).HideWindow();
	}
	SelectedIndex = itemIndex;
	if((itemIndex == -1))
	{
		return;
	}
	rendererID = _GetRendererID(itemIndex);
	DelegateOnSelect(_GetRendererPath(rendererID), rendererID, SelectedIndex);
	Validate();
	return;
}

function _SetOver(int itemIndex)
{
	if((itemIndex >= Length))
	{
		itemIndex = -1;
	}
	if((overedIndex == itemIndex))
	{
		return;
	}
	if((overedIndex != -1))
	{
		GetTextureHandle((_GetRendererPath(_GetOveredRendererID()) $ ".OverTexture")).HideWindow();
	}
	overedIndex = itemIndex;
	if((itemIndex == -1))
	{
		return;
	}
	Validate();
	return;
}

function int _GetStartLineNum()
{
	return startLineNum;
}

function int _GetStartRendererID()
{
	return (_GetStartLineNum() * standardNumPerLine);
}

function int _GetSelectedIndex()
{
	return SelectedIndex;
}

function int _GetSelectedRendererID()
{
	return int((float(SelectedIndex) % float(rendererNumTotal)));
}

function int _GetOveredIndex()
{
	return overedIndex;
}

function int _GetOveredRendererID()
{
	return int((float(overedIndex) % float(rendererNumTotal)));
}

function int _GetLength()
{
	return Length;
}

function int _GetRendererNumTotal()
{
	return rendererNumTotal;
}

function int _GetFirstItemIndex()
{
	return (startLineNum * standardNumPerLine);
}

function int _GetItemIndexWithRendererID(int rendererID)
{
	local int firstItemIndex;

	firstItemIndex = _GetFirstItemIndex();
	return int(((float(int(((float(rendererID) - (float(firstItemIndex) % float(rendererNumTotal))) + float(rendererNumTotal)))) % float(rendererNumTotal)) + float(firstItemIndex)));
}

function int _GetRendererID(int itemIndex)
{
	local int firstItemIndex;

	firstItemIndex = _GetFirstItemIndex();
	if((itemIndex < firstItemIndex))
	{
		return -1;
	}
	if((itemIndex > ((firstItemIndex + rendererNumTotal) - 1)))
	{
		return -1;
	}
	return int((float(itemIndex) % float(rendererNumTotal)));
}

function int _GetRendererIDWithWindow(WindowHandle childWindow)
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
	while((i < rendererNumTotal))
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

function _SetTileListLength(int _length)
{
	if((Length != _length))
	{
		SetScrollIndex(0);
	}
	Length = _length;
	ApplyTileListSetting();
	return;
}

function _SetUseSelect(bool bUseSelectP)
{
	local int i;

	if((bUseSelect && !bUseSelectP))
	{
		i = 0;
		while((i < _GetRendererNumTotal()))
		{
			GetTextureHandle((_GetRendererPath(i) $ ".SelectTexture")).HideWindow();
			i++;
		}
		SelectedIndex = -1;
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
		while((i < _GetRendererNumTotal()))
		{
			GetTextureHandle((_GetRendererPath(i) $ ".OverTexture")).HideWindow();
			i++;
		}
	}
	bUseOver = bUseOverP;
	return;
}

function _Refresh()
{
	local int i;

	Repositioning();
	i = 0;
	while((i < rendererNumTotal))
	{
		DelegateOnRenderer(_GetRendererPath(i), i, _GetItemIndexWithRendererID(i));
		i++;
	}
	return;
}

function _RefreshRenderer(int rendererID)
{
	local int itemIndex;

	itemIndex = _GetItemIndexWithRendererID(rendererID);
	DelegateOnRenderer(_GetRendererPath(rendererID), rendererID, itemIndex);
	return;
}

function ApplyTileListSetting()
{
	GetWindowHandleScrollArea().SetScrollHeight(GetScrollMaxHeight());
	startLineNum = 0;
	GetWindowHandleScrollArea().SetScrollPosition(0);
	return;
}

function OnScroll(int pos)
{
	local int currentStartLineNum;

	Debug((((" -- OnScroll " @ string(pos)) @ string(GetScrollPosition())) @ string(GetScrollMaxPosition())));
	pos = Max(0, pos);
	currentStartLineNum = (pos / standardSize);
	if((startLineNum == currentStartLineNum))
	{
		return;
	}
	startLineNum = currentStartLineNum;
	ValidateRefreshOnScroll();
	Validate();
	DelegateOnScroll();
	return;
}

function Repositioning(optional bool bDelegateOnRenderer)
{
	local int i, j, lineNum, rendererID, pos, locX, locY, NewPos, standardPosNum;
	local Rect rectWnd;
	local int itemIndex;

	pos = GetScrollPosition();
	i = 0;
	while((i < standardLineNum))
	{
		lineNum = (startLineNum + i);
		itemIndex = (lineNum * standardNumPerLine);
		rendererID = _GetRendererID(itemIndex);
		rectWnd = GetWindowHandleItemRederer(rendererID).GetRect();
		Global2Local(GetWindowHandleItemRederer(rendererID).GetParentWindowHandle(), rectWnd.nX, rectWnd.nY, locX, locY);
		if(bv)
		{
			standardPosNum = locY;
		}
		else
		{
			standardPosNum = locX;
		}
		NewPos = ((standardSize * lineNum) - pos);
		if((standardPosNum == NewPos))
		{
			i++;
			continue;
		}
		j = 0;
		while((j < standardNumPerLine))
		{
			if(bv)
			{
				GetWindowHandleItemRederer(rendererID).MoveC((rectWnd.nWidth * j), NewPos);
			}
			else
			{
				GetWindowHandleItemRederer(rendererID).MoveC(NewPos, (rectWnd.nHeight * j));
			}
			if(bDelegateOnRenderer)
			{
				DelegateOnRenderer(_GetRendererPath(rendererID), rendererID, (itemIndex + j));
			}
			rendererID++;
			j++;
		}
		i++;
	}
	return;
}

function SetScrollIndex(int scrollINdex)
{
	local int pos, TargetPos;

	pos = GetScrollPosition();
	TargetPos = Min((standardSize * (scrollINdex / standardNumPerLine)), GetScrollMaxPosition());
	GetWindowHandleScrollArea().SetScrollPosition(int((float(pos) + float((TargetPos - pos)))));
	return;
}

function int GetScrollIndex()
{
	return (GetScrollPosition() / standardSize);
}

function int GetScrollIndexMax()
{
	return ((GetScrollMaxHeight() - standardSize) / standardSize);
}

function int GetScrollPosition()
{
	return GetWindowHandleScrollArea().GetScrollPosition();
}

function int GetScrollMaxPosition()
{
	local int pos, W, h;

	pos = (standardSize * appCeil((float(Length) / float(standardNumPerLine))));
	GetWindowHandleScrollArea().GetWindowSize(W, h);
	if(bv)
	{
		return Max(0, (pos - h));
	}
	else
	{
		return Max(0, (pos - W));
	}
}

function int GetScrollMaxHeight()
{
	return (appCeil((float(_GetLength()) / float(standardNumPerLine))) * standardSize);
}

function WindowHandle GetWindowHandleItemRederer(int rendererID)
{
	return GetWindowHandle(_GetRendererPath(rendererID));
}

function WindowHandle GetWindowHandleScrollArea()
{
	return GetWindowHandle(_GetScrollPath());
}

function string _GetScrollPath()
{
	return (m_hOwnerWnd.m_WindowNameWithFullPath $ ".ScrollArea");
}

function string _GetRendererPath(int rendererID)
{
	return (((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ScrollArea.") $ rendererName) $ Int2Str(rendererID));
}

function string Int2Str(int Num)
{
	if((Num < 10))
	{
		return ("0" $ string(Num));
	}
	return string(Num);
}

function bool ChkInRenderer(int rendererID, int X, int Y)
{
	local Rect rendererRect;

	if((rendererID < 0))
	{
		return false;
	}
	if((rendererID >= _GetRendererNumTotal()))
	{
		return false;
	}
	rendererRect = GetWindowHandle(_GetRendererPath(rendererID)).GetRect();
	Debug((((((("ChkInRenderer" @ string(X)) @ string(Y)) @ string(rendererRect.nX)) @ string(rendererRect.nY)) @ string(rendererRect.nWidth)) @ string(rendererRect.nHeight)));
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

function ClearRendererIDs()
{
	local ButtonHandle defaultHandle;

	pressedRendererID = -1;
	clickDataLast.Type = non;
	clickDataLast.Name = "";
	clickDataLast.btnHandle = defaultHandle;
	clickDataLast.rendererID = -1;
	return;
}
