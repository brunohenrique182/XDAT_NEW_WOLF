class AdenLabCard extends UIScript;

const CENTER_X = 490;
const CENTER_Y = 287;
const Distance = 100;
const ROTATEANGLE = 6;
const TweenTime = 200;

var int _index;
var L2UITween l2UITweenScript;
var L2UITweenRotateObject tRObject;
var L2UITweenObject tObject;
var L2UITweenObject movingTObject;
var L2UITimerObject tickObject;
var INT64 lastAppMilliSeconds;
var int targetX;
var int targetY;
var float Angle;
var WindowHandle cardAniamtionWnd;
var AnimTextureHandle cardFlip;
var AnimTextureHandle cardFail;
var AnimTextureHandle cardDefault;
var TextureHandle cardImage;
var bool isOver;
var bool isDown;
var bool isMoving;
var bool isResultState;
var bool bSuccess;

static function AdenLabCard _InitScript(WindowHandle wnd)
{
	local AdenLabCard scr;

	wnd.SetScript("AdenLabCard");
	scr = AdenLabCard(wnd.GetScript());
	scr._InitWindow(wnd);
	return scr;
}

function _InitWindow(WindowHandle W)
{
	m_hOwnerWnd = W;
	Class'NWindow.UIAPI_WINDOW'.static.SetAlwaysOnTop(m_hOwnerWnd.m_WindowNameWithFullPath, false);
	_index = int(Right(m_hOwnerWnd.GetWindowName(), 2));
	InitTimerObject();
	InitTextures();
	InitTweensObject();
	return;
}

function InitTextures()
{
	cardAniamtionWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".cardAniamtionWnd"));
	cardFlip = GetAnimTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".cardAniamtionWnd.cardFlip"));
	cardFail = GetAnimTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".cardAniamtionWnd.cardFail"));
	cardDefault = GetAnimTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".cardAniamtionWnd.cardDefault"));
	cardFlip.SetLoopCount(1);
	cardFail.SetLoopCount(1);
	cardFail.HideWindow();
	cardDefault.SetLoopCount(1);
	cardDefault.Stop();
	cardImage = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".cardAniamtionWnd.cardImage"));
	return;
}

function InitTimerObject()
{
	tickObject = Class'InterfaceClassic.L2UITimer'.static.Inst()._MakeTimerObject(1, 1);
	tickObject._DelegateOnEnd = DelegateOnTick;
	return;
}

function InitTweensObject()
{
	l2UITweenScript = L2UITween(GetScript("l2UITween"));
	tObject = new Class'InterfaceClassic.L2UITweenObject';
	tObject.Id = _index;
	tObject.Owner = m_hOwnerWnd.m_WindowNameWithFullPath;
	tObject.Target = cardAniamtionWnd;
	tObject.Duration = 200.0000000;
	tObject.ease = OUT_STRONG;
	movingTObject = new Class'InterfaceClassic.L2UITweenObject';
	movingTObject.Id = _index;
	movingTObject.Owner = m_hOwnerWnd.m_WindowNameWithFullPath;
	movingTObject.Target = m_hOwnerWnd;
	movingTObject.Duration = 200.0000000;
	movingTObject.Delay = float((_index * 15));
	movingTObject.ease = OUT_STRONG;
	movingTObject._DelegateOnEnd = OnMovingEnd;
	return;
}

function _Reset()
{
	local int locX, locY;

	if((Class'InterfaceClassic.AdenLabCardCaptorWnd'.static._Inst()._GetCardNum() <= _index))
	{
		m_hOwnerWnd.HideWindow();
		return;
	}
	m_hOwnerWnd.ShowWindow();
	tObject._Stop();
	movingTObject._Stop();
	isDown = false;
	isOver = false;
	isMoving = false;
	_SetResultState(false);
	cardFlip.HideWindow();
	cardFail.HideWindow();
	cardImage.ShowWindow();
	cardDefault.Stop();
	cardAniamtionWnd.SetAlpha(255);
	GetLocalPosition(cardAniamtionWnd, locX, locY);
	cardAniamtionWnd.MoveC(0, 0);
	GetLocalPosition(cardAniamtionWnd, locX, locY);
	tickObject._Reset();
	cardFlip.Stop();
	cardFail.Stop();
	cardDefault.Stop();
	cardFlip.Pause();
	cardFail.Pause();
	cardDefault.Pause();
	return;
}

function _SetTargetXYByRowCol(int rowNumMax, int colNumMax, int lastEmptyColNum, int cardW, int cardH)
{
	local int targetRow, targetCol, lastStartY;

	targetRow = (_index / colNumMax);
	targetY = ((targetRow * cardH) + 60);
	if((targetRow == (rowNumMax - 1)))
	{
		lastStartY = ((lastEmptyColNum * cardW) / 2);
	}
	targetCol = int((float(_index) % float(colNumMax)));
	targetX = ((targetCol * cardW) + lastStartY);
	return;
}

function MoveToCenter()
{
	local int centerX, centerY;

	Class'InterfaceClassic.UICommonAPI'.static.InstUICommonAPI().Local2Global(Class'InterfaceClassic.AdenLabCardCaptorWnd'.static._Inst().m_hOwnerWnd, 490, 287, centerX, centerY);
	m_hOwnerWnd.MoveTo((centerX + (_index * 2)), (centerY + (_index * 2)));
	m_hOwnerWnd.SetFocus();
	return;
}

function StartMoveToMyPositoin()
{
	local int locX, locY;

	GetLocalPosition(m_hOwnerWnd, locX, locY);
	movingTObject.MoveX = float((targetX - locX));
	movingTObject.MoveY = float((targetY - locY));
	isMoving = true;
	movingTObject._Reset();
	return;
}

function OnMovingEnd(L2UITweenObject Me)
{
	isMoving = false;
	return;
}

function DelegateOnEndHide(L2UITweenObject Me)
{
	return;
}

event OnSetFocus(WindowHandle a_WindowHandle, bool bFocused)
{
	Debug((((("OnSetFocus card" @ a_WindowHandle.GetWindowName()) @ a_WindowHandle.GetTopFrameWnd().GetWindowName()) @ string(a_WindowHandle.GetTopFrameWnd().IsFocused())) @ string(a_WindowHandle.IsFocused())));
	return;
}

event OnTextureAnimEnd(AnimTextureHandle a_AnimTextureHandle)
{
	switch(a_AnimTextureHandle)
	{
		case cardFlip:
			cardFlip.HideWindow();
			if((bSuccess == false))
			{
				cardFail.ShowWindow();
				cardFail.Play();
				PlaySound("InterfaceSound.AdenLab_StatCard_Fail");
			}
			break;
		case cardFail:
			cardFail.HideWindow();
			break;
		default:
			break;
	}
	return;
}

event OnMouseOver(WindowHandle a_WindowHandle)
{
	if(isMoving)
	{
		return;
	}
	if(isResultState)
	{
		return;
	}
	if(!isOver)
	{
		SetOver();
	}
	isOver = true;
	return;
}

event OnMouseOut(WindowHandle a_WindowHandle)
{
	if(isMoving)
	{
		return;
	}
	if(isResultState)
	{
		return;
	}
	if(isOver)
	{
		SetOut();
	}
	isOver = false;
	return;
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	if(isMoving)
	{
		return;
	}
	if(isResultState)
	{
		return;
	}
	isDown = true;
	return;
}

event OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	if(isMoving)
	{
		return;
	}
	if(isResultState)
	{
		return;
	}
	isDown = false;
	HandleOnLButtonUP();
	return;
}

function HandleOnLButtonUP()
{
	if(!isOver)
	{
		return;
	}
	if(isResultState)
	{
		return;
	}
	if(!Class'InterfaceClassic.AdenLabCardCaptorWnd'.static._Inst()._HandleOnCardButtonUP(self))
	{
		return;
	}
	return;
}

function FlipCard()
{
	PlaySound("InterfaceSound.AdenLab_StatCard_Flip");
	cardFlip.ShowWindow();
	cardFlip.Play();
	cardImage.HideWindow();
	cardDefault.HideWindow();
	return;
}

function _SetResultState(bool bResultState)
{
	isResultState = bResultState;
	if(!isResultState)
	{
		SetOut();
		isOver = false;
	}
	return;
}

function _SetFailTween()
{
	local int locX, locY;

	bSuccess = false;
	FlipCard();
	GetLocalPosition(cardAniamtionWnd, locX, locY);
	tObject.Duration = 1000.0000000;
	tObject.MoveY = float(-locY);
	tObject.Alpha = 255.0000000;
	tObject.ease = IN_STRONG;
	tObject._DelegateOnEnd = DelegateEndShowResult;
	tObject._Reset();
	return;
}

function _SetSuccessTween()
{
	local int locX, locY;

	bSuccess = true;
	FlipCard();
	GetLocalPosition(cardAniamtionWnd, locX, locY);
	tObject.Duration = 1000.0000000;
	tObject.ease = OUT_STRONG;
	tObject._DelegateOnEnd = None;
	tObject._Reset();
	return;
}

function DelegateEndShowResult(L2UITweenObject to)
{
	local int locX, locY;

	GetLocalPosition(cardAniamtionWnd, locX, locY);
	tObject.Duration = 1000.0000000;
	tObject.MoveY = float(-locY);
	tObject.Alpha = -255.0000000;
	tObject.ease = IN_STRONG;
	tObject._DelegateOnEnd = None;
	tObject._Reset();
	return;
}

function DelegateOnTick()
{
	MoveToCenter();
	StartMoveToMyPositoin();
	return;
}

function SetOver()
{
	local int locX, locY;

	PlaySound("InterfaceSound.AdenLab_StatCard_Over");
	m_hOwnerWnd.SetFocus();
	GetLocalPosition(cardAniamtionWnd, locX, locY);
	tObject.MoveY = float((-20 - locY));
	tObject.Alpha = 255.0000000;
	tObject.Duration = 200.0000000;
	tObject.ease = OUT_BOUNCE;
	tObject._DelegateOnEnd = None;
	tObject._Reset();
	cardDefault.ShowWindow();
	cardDefault.Stop();
	cardDefault.Play();
	return;
}

function SetOut()
{
	local int locX, locY;

	GetLocalPosition(cardAniamtionWnd, locX, locY);
	tObject.MoveY = float(-locY);
	tObject.ease = OUT_STRONG;
	tObject._DelegateOnEnd = DelegateOnEndHide;
	tObject._Reset();
	return;
}

function _SetCardTextures(string cardImageTexture, string cardFlipAniTexture, Color C)
{
	cardImage.SetTexture(cardImageTexture);
	cardFlip.SetTexture(cardFlipAniTexture);
	cardDefault.SetColorModify(C);
	return;
}

function GetLocalPosition(WindowHandle W, out int X, out int Y)
{
	local Rect rectWnd, rectWndParent;

	rectWnd = W.GetRect();
	if((W.m_pTargetWnd == none))
	{
		X = rectWnd.nX;
		Y = rectWnd.nY;
		return;
	}
	rectWndParent = W.GetParentWindowHandle().GetRect();
	X = (rectWnd.nX - rectWndParent.nX);
	Y = (rectWnd.nY - rectWndParent.nY);
	return;
}
