class PositionManagerWndBase extends UICommonAPI;

var string _targetWndname;
var TextureHandle ShortcutIcon_EnterCenter;
var bool isOver;
var bool isDown;
var L2UITimerObject tickTimerObject;
var WindowHandle viewWndHandle;
var int OffsetX;
var int OffsetY;
var int targetW;
var int targetH;
var bool isGfx;
//var delegate<DelegateOnSave> __DelegateOnSave__Delegate;

delegate DelegateOnSave()
{
	return;
}

function Init()
{
	return;
}

function ResetPosition()
{
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(3410);
	return;
}

event OnEvent(int eID, string param)
{
	m_hOwnerWnd.HideWindow();
	return;
}

event OnLoad()
{
	SetMyName();
	Class'Interface.PositionManager'.static.Inst()._AddBase(self);
	ShortcutIcon_EnterCenter = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ShortcutIcon_EnterCenter"));
	ShortcutIcon_EnterCenter.HideWindow();
	tickTimerObject = Class'Interface.L2UITimer'.static.Inst()._MakeTimerObject(1, 1, 0);
	tickTimerObject._DelegateOnEnd = RefreshState;
	viewWndHandle = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".viewWndHandle"));
	SetTargetInfos();
	Init();
	return;
}

event OnShow()
{
	SyncdPosition();
	m_hOwnerWnd.BringToFront();
	return;
}

event OnSetFocus(WindowHandle focusedWnd, bool bFocused)
{
	if(bFocused)
	{
		ShortcutIcon_EnterCenter.ShowWindow();
	}
	else
	{
		ShortcutIcon_EnterCenter.HideWindow();
	}
	return;
}

event bool OnKeyDown(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	switch(nKey)
	{
		case IK_Enter:
			if(ShortcutIcon_EnterCenter.IsShowWindow())
			{
				SavePosition();
				return true;
			}
			break;
		default:
			break;
	}
	return false;
}

event OnMouseOver(WindowHandle a_WindowHandle)
{
	isOver = (a_WindowHandle.GetWindowName() != "OKButton");
	tickTimerObject._Reset();
	return;
}

event OnMouseOut(WindowHandle a_WindowHandle)
{
	isOver = false;
	tickTimerObject._Reset();
	return;
}

event OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	isDown = false;
	tickTimerObject._Reset();
	return;
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	if((a_WindowHandle.GetWindowName() == "OKButton"))
	{
		return;
	}
	isDown = true;
	tickTimerObject._Reset();
	return;
}

event OnClickButton(string BTNID)
{
	switch(BTNID)
	{
		case "OKButton":
			SavePosition();
			break;
		default:
			break;
	}
	return;
}

function SetTargetInfos()
{
	local Rect rectWnd;

	if(((targetW != 0) || (targetH != 0)))
	{
		return;
	}
	rectWnd = GetWindowHandle(_targetWndname).GetRect();
	targetW = rectWnd.nWidth;
	targetH = rectWnd.nHeight;
	return;
}

function SetMyName()
{
	_targetWndname = m_hOwnerWnd.GetWindowName();
	_targetWndname = Right(m_hOwnerWnd.GetWindowName(), (Len(_targetWndname) - Len("PositionManager")));
	return;
}

function _SetShow()
{
	m_hOwnerWnd.ShowWindow();
	return;
}

function _SetShowHide()
{
	if(m_hOwnerWnd.IsShowWindow())
	{
		m_hOwnerWnd.HideWindow();
	}
	else
	{
		m_hOwnerWnd.ShowWindow();
	}
	return;
}

function RefreshState()
{
	Debug((("RefreshSate " @ string(isDown)) @ string(isOver)));
	if(isDown)
	{
		API_SetUseCursor(true);
		API_UnsetCursor();
		API_SetCursor(21);
	}
	else if(isOver)
	{
		API_SetUseCursor(true);
		API_SetCursor(3);
	}
	else
	{
		API_UnsetCursor();
		API_SetUseCursor(false);
	}
	return;
}

function SavePosition()
{
	SetAnchorPosition();
	m_hOwnerWnd.HideWindow();
	getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(14566));
	DelegateOnSave();
	return;
}

function _ResetPosition()
{
	local Rect targetRect;

	m_hOwnerWnd.HideWindow();
	ResetPosition();
	if(isGfx)
	{
		return;
	}
	targetRect = GetWindowHandle(_targetWndname).GetRect();
	SetINIInt(_targetWndname, "x", targetRect.nX, "Windowsinfo.ini");
	SetINIInt(_targetWndname, "y", targetRect.nY, "Windowsinfo.ini");
	SetINIInt(_targetWndname, "aT", 0, "Windowsinfo.ini");
	getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(14562));
	return;
}

function _MoveOnLoad()
{
	if(_IsSaved())
	{
		MoveOnLoad();
	}
	else
	{
		ResetPosition();
	}
	return;
}

function MoveOnLoad()
{
	local int anchorType, anchorOffsetX, anchorOffsetY;

	GetINIInt(_targetWndname, "aT", anchorType, "Windowsinfo.ini");
	GetINIInt(_targetWndname, "oX", anchorOffsetX, "Windowsinfo.ini");
	GetINIInt(_targetWndname, "oY", anchorOffsetY, "Windowsinfo.ini");
	SetAnchorByType(EAnchorPointType(anchorType), anchorOffsetX, anchorOffsetY);
	return;
}

function _SyncdPosition()
{
	SyncdPosition();
	return;
}

function SyncdPosition()
{
	local Rect rectWnd;
	local int X, Y;

	if(isGfx)
	{
		GetINIInt(_targetWndname, "x", X, "Windowsinfo.ini");
		GetINIInt(_targetWndname, "y", Y, "Windowsinfo.ini");
	}
	else
	{
		rectWnd = GetWindowHandle(_targetWndname).GetRect();
		X = rectWnd.nX;
		Y = rectWnd.nY;
	}
	m_hOwnerWnd.MoveTo((X - OffsetX), (Y - OffsetY));
	return;
}

function bool _IsSaved()
{
	local int AnchorPoint;

	if((GetINIInt(_targetWndname, "aT", AnchorPoint, "windowsInfo.ini") == false))
	{
		return false;
	}
	if((AnchorPoint == 0))
	{
		return false;
	}
	return true;
}

function SaveAnchorInfos(UIEventManager.EAnchorPointType anchorType, int anchorOffsetX, int anchorOffsetY)
{
	SetINIInt(_targetWndname, "aT", int(anchorType), "Windowsinfo.ini");
	SetINIInt(_targetWndname, "oX", anchorOffsetX, "Windowsinfo.ini");
	SetINIInt(_targetWndname, "oY", anchorOffsetY, "Windowsinfo.ini");
	return;
}

function SetAnchorPosition()
{
	local UIEventManager.EAnchorPointType anchorType;
	local int anchorOffsetX, anchorOffsetY;

	anchorType = GetAnchorType(anchorOffsetX, anchorOffsetY);
	SetAnchorByType(anchorType, anchorOffsetX, anchorOffsetY);
	SaveAnchorInfos(anchorType, anchorOffsetX, anchorOffsetY);
	return;
}

function SetAnchorByType(UIEventManager.EAnchorPointType anchorType, int anchorOffsetX, int anchorOffsetY)
{
	if(isGfx)
	{
		L2UIGFxScript(GetScript(_targetWndname)).SetAnchor("", anchorType, ANCHORPOINT_CenterCenter, anchorOffsetX, anchorOffsetY);
	}
	else
	{
		GetWindowHandle(_targetWndname).SetAnchor("", GetAnchorTypeString(anchorType), "CenterCenter", anchorOffsetX, anchorOffsetY);
	}
	return;
}

function string GetAnchorTypeString(UIEventManager.EAnchorPointType anchorType)
{
	switch(anchorType)
	{
		case ANCHORPOINT_TopLeft:
			return "TopLeft";
		case ANCHORPOINT_TopCenter:
			return "TopCenter";
		case ANCHORPOINT_TopRight:
			return "TopRight";
		case ANCHORPOINT_CenterLeft:
			return "CenterLeft";
		case ANCHORPOINT_CenterCenter:
			return "CenterCenter";
		case ANCHORPOINT_CenterRight:
			return "CenterRight";
		case ANCHORPOINT_BottomLeft:
			return "BottomLeft";
		case ANCHORPOINT_BottomCenter:
			return "BottomCenter";
		case ANCHORPOINT_BottomRight:
			return "BottomRight";
		default:
			return "CenterCenter";
	}
}

function UIEventManager.EAnchorPointType GetAnchorType(out int anchorOffsetX, out int anchorOffsetY)
{
	local int anchorType;
	local Rect rectWnd;
	local int currentScreenWidth, currentScreenHeight, currentScreenCenterX, currentScreenCenterY, targetX, targetY, targetCenterX, targetCenterY;

	rectWnd = viewWndHandle.GetRect();
	targetX = (rectWnd.nX + OffsetX);
	targetCenterX = (targetX + (targetW / 2));
	targetY = (rectWnd.nY + OffsetY);
	targetCenterY = (targetY + (targetH / 2));
	API_GetCurrentResolution(currentScreenWidth, currentScreenHeight);
	currentScreenCenterX = (currentScreenWidth / 2);
	currentScreenCenterY = (currentScreenHeight / 2);
	if((currentScreenCenterY < targetCenterY))
	{
		anchorType = 7;
		anchorOffsetY = (targetCenterY - currentScreenHeight);
	}
	else if((currentScreenCenterY > targetCenterY))
	{
		anchorType = 1;
		anchorOffsetY = targetCenterY;
	}
	else
	{
		anchorType = 4;
	}
	if((currentScreenCenterX < targetCenterX))
	{
		anchorType = (anchorType + 2);
		anchorOffsetX = (targetCenterX - currentScreenWidth);
	}
	else if((currentScreenCenterX > targetCenterX))
	{
		anchorOffsetX = targetCenterX;
	}
	else
	{
		anchorType = (anchorType + 1);
		anchorOffsetX = 0;
	}
	return EAnchorPointType(anchorType);
}

function API_UnsetCursor()
{
	UnsetCursor();
	return;
}

function bool API_SetCursor(int Index)
{
	return SetCursor(Index);
}

function API_SetUseCursor(bool a_bUseCursor)
{
	m_hOwnerWnd.SetUseCursor(a_bUseCursor);
	return;
}

function API_GetCurrentResolution(out int currentScreenWidth, out int currentScreenHeight)
{
	GetCurrentResolution(currentScreenWidth, currentScreenHeight);
	return;
}
