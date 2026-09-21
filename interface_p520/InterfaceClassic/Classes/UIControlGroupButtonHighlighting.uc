class UIControlGroupButtonHighlighting extends UIConstants;

var string btnTextureNormal;
var string btnTextureOver;
var string btnTextureDown;
var ButtonHandle groupBaseBtn;
var array<WindowHandle> windows;
var bool disalbed;
//var delegate<DelegateOnButtonClick> __DelegateOnButtonClick__Delegate;
//var delegate<DelegateOnSelectItemWithHandle> __DelegateOnSelectItemWithHandle__Delegate;
//var delegate<DelegateOnLButtonUp> __DelegateOnLButtonUp__Delegate;

delegate DelegateOnButtonClick(string strBtn)
{
	return;
}

delegate DelegateOnSelectItemWithHandle(ItemWindowHandle a_hItemWindow, int a_Index)
{
	return;
}

delegate DelegateOnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	return;
}

static function UIControlGroupButtonHighlighting InitScript(WindowHandle wnd)
{
	local UIControlGroupButtonHighlighting scr;

	wnd.SetScript("UIControlGroupButtonHighlighting");
	scr = UIControlGroupButtonHighlighting(wnd.GetScript());
	scr.InitWnd(wnd);
	return scr;
}

function InitWnd(WindowHandle wnd)
{
	m_hOwnerWnd = wnd;
	Init();
	return;
}

function Init()
{
	groupBaseBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".GroupBaseBtn"));
	return;
}

event OnMouseOver(WindowHandle a_WindowHandle)
{
	if(disalbed)
	{
		return;
	}
	if((a_WindowHandle.GetWindowName() != groupBaseBtn.GetWindowName()))
	{
		if(!IsKeyDown(IK_LeftMouse))
		{
			groupBaseBtn.SetTexture(btnTextureOver, btnTextureDown, btnTextureNormal);
		}
	}
	return;
}

event OnMouseOut(WindowHandle a_WindowHandle)
{
	if(disalbed)
	{
		return;
	}
	if(!IsKeyDown(IK_LeftMouse))
	{
		groupBaseBtn.SetTexture(btnTextureNormal, btnTextureDown, btnTextureOver);
	}
	return;
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	if(disalbed)
	{
		return;
	}
	if(groupBaseBtn.IsMouseOver())
	{
		return;
	}
	groupBaseBtn.SetTexture(btnTextureDown, btnTextureDown, btnTextureNormal);
	return;
}

event OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	if(disalbed)
	{
		return;
	}
	if(groupBaseBtn.IsMouseOver())
	{
		groupBaseBtn.SetTexture(btnTextureNormal, btnTextureDown, btnTextureOver);
	}
	else if(_IsOver(X, Y))
	{
		groupBaseBtn.SetTexture(btnTextureOver, btnTextureDown, btnTextureNormal);
	}
	else
	{
		groupBaseBtn.SetTexture(btnTextureNormal, btnTextureDown, btnTextureOver);
	}
	DelegateOnLButtonUp(a_WindowHandle, X, Y);
	return;
}

event OnClickButton(string strBtn)
{
	if(disalbed)
	{
		return;
	}
	DelegateOnButtonClick(strBtn);
	return;
}

event OnSelectItemWithHandle(ItemWindowHandle a_hItemWindow, int a_Index)
{
	DelegateOnSelectItemWithHandle(a_hItemWindow, a_Index);
	return;
}

function _SetGroupBaseButton(ButtonHandle baseBtn)
{
	groupBaseBtn = baseBtn;
	return;
}

function _AddWindow(WindowHandle childBtn)
{
	windows[windows.Length] = childBtn;
	return;
}

function _SetBtnTexture(string Normal, optional string Over, optional string Down)
{
	btnTextureNormal = Normal;
	btnTextureOver = Over;
	btnTextureDown = Down;
	return;
}

function bool _IsOver(int X, int Y)
{
	local int i;

	if(groupBaseBtn.IsMouseOver())
	{
		return true;
	}
	i = 0;
	while((i < windows.Length))
	{
		if(IsOverWnd(windows[i], X, Y))
		{
			return true;
		}
		i++;
	}
	return false;
}

function _SetDisable()
{
	disalbed = true;
	groupBaseBtn.SetTexture(btnTextureNormal, btnTextureDown, btnTextureOver);
	return;
}

function _SetEnable()
{
	disalbed = false;
	return;
}

function bool IsOverWnd(WindowHandle wnd, int X, int Y)
{
	local Rect wndRect;

	wndRect = wnd.GetRect();
	if((X < wndRect.nX))
	{
		return false;
	}
	if((Y < wndRect.nY))
	{
		return false;
	}
	if((X > (wndRect.nX + wndRect.nWidth)))
	{
		return false;
	}
	if((Y > (wndRect.nY + wndRect.nHeight)))
	{
		return false;
	}
	return true;
}
