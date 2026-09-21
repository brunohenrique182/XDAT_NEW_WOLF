class MinimizeManager extends UICommonAPI;

const TweenTime = 700;

var array<string> ownerWwindowNames;
var array<string> ownerWindowNamesShowByOwner;

static function MinimizeManager Inst()
{
	return MinimizeManager(GetScript("MinimizeManager"));
}

function SetListShowByOwner()
{
	return;
}

event OnLoad()
{
	SetWndNameList();
	return;
}

event OnShow()
{
	m_hOwnerWnd.EnableTick();
	return;
}

event OnHide()
{
	HideAlarms();
	return;
}

event OnTick()
{
	SetListShowByOwner();
	ApplyMinSizes();
	m_hOwnerWnd.DisableTick();
	return;
}

event OnTimer(int TimerID)
{
	m_hOwnerWnd.KillTimer(TimerID);
	GetWindowHandle((ownerWwindowNames[TimerID] $ "Min")).HideWindow();
	return;
}

event OnCallUCFunction(string funcName, string param)
{
	switch(funcName)
	{
		case "MinimizeWindow":
			_MinimizeWindow(param);
			break;
		default:
			break;
	}
	return;
}

event OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	_MaximizeWindow(UtilDelMin(a_ButtonHandle.GetParentWindowHandle().GetParentWindowName()));
	return;
}

function _MinimizeWindow(string wName, optional bool bImmediately)
{
	local int i;
	local float TweenTime;
	local array<WindowHandle> childLists;

	SetINIInt(wName, "m", 1, "WindowsInfo.ini");
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow(wName);
	Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ wName) $ "Min"));
	if(!bImmediately)
	{
		Pull(wName);
		TweenTime = 0.0000000;
	}
	else
	{
		TweenTime = (TweenTime / 1000.0000000);
	}
	GetWindowHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ wName) $ "Min")).GetChildWindowList(childLists);
	GetScript(wName).OnCallUCFunction(m_hOwnerWnd.m_WindowNameWithFullPath, "onMin");
	i = 0;
	while((i < childLists.Length))
	{
		childLists[i].SetAlpha(255, TweenTime);
		i++;
	}
	return;
}

function _MaximizeWindow(string wName)
{
	local int i;
	local array<WindowHandle> childLists;

	SetINIInt(wName, "m", 0, "WindowsInfo.ini");
	_HideAlarm(wName);
	Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(wName);
	Push(wName);
	GetWindowHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ wName) $ "Min")).GetChildWindowList(childLists);
	GetScript(wName).OnCallUCFunction(m_hOwnerWnd.m_WindowNameWithFullPath, "onMax");
	i = 0;
	while((i < childLists.Length))
	{
		childLists[i].SetAlpha(0, (700.0000000 / 1000.0000000));
		i++;
	}
	return;
}

function _ShowWindow(string wName)
{
	if(_IsMin(wName))
	{
		_MinimizeWindow(wName, true);
	}
	else
	{
		_MaximizeWindow(wName);
	}
	return;
}

function _HideWindow(string wName)
{
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow(wName);
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ wName) $ "Min"));
	_HideAlarm(wName);
	return;
}

function _ShowAlarm(string wName)
{
	Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ wName) $ "Min.MinContents.texAlarm"));
	return;
}

function _HideAlarm(string wName)
{
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ wName) $ "Min.MinContents.texAlarm"));
	return;
}

function bool _IsMin(string wName)
{
	local int minState;

	if(GetINIInt(wName, "m", minState, "WindowsInfo.ini"))
	{
		return (minState == 1);
	}
	return false;
}

function _AddOwnerWindowNameShowByOwer(string wName)
{
	ownerWindowNamesShowByOwner[ownerWindowNamesShowByOwner.Length] = wName;
	return;
}

function _SetToolTIp(string wName, string ToolTip)
{
	Debug((((((("_SetToolTIp : " @ wName) @ ToolTip) @ m_hOwnerWnd.m_WindowNameWithFullPath) $ ".") $ wName) $ "Min.MinContents.MinBtn"));
	GetButtonHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ wName) $ "Min.MinContents.MinBtn")).SetTooltipCustomType(MakeTooltipSimpleText(ToolTip));
	return;
}

function HideAlarms()
{
	local int i;

	i = 0;
	while((i < ownerWwindowNames.Length))
	{
		_HideAlarm(ownerWwindowNames[i]);
		i++;
	}
	return;
}

function int IndexAtOwnerWindowNamesShowByOwner(string wName)
{
	local int i;

	i = 0;
	while((i < ownerWindowNamesShowByOwner.Length))
	{
		if((ownerWindowNamesShowByOwner[i] == wName))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function SetWndNameList()
{
	local int i;
	local array<WindowHandle> wndLists;

	m_hOwnerWnd.GetChildWindowList(wndLists);
	i = 0;
	while((i < wndLists.Length))
	{
		if((Right(wndLists[i].GetWindowName(), 3) == "Min"))
		{
			ownerWwindowNames[ownerWwindowNames.Length] = UtilDelMin(wndLists[i].GetWindowName());
		}
		i++;
	}
	return;
}

function ApplyMinSizes()
{
	local int i;

	i = 0;
	while((i < ownerWwindowNames.Length))
	{
		if(_IsMin(ownerWwindowNames[i]))
		{
			if((IndexAtOwnerWindowNamesShowByOwner(ownerWwindowNames[i]) == -1))
			{
				_MinimizeWindow(ownerWwindowNames[i], true);
			}
		}
		i++;
	}
	return;
}

function Pull(string wName)
{
	local int X, Y;
	local Rect btnMinRect, minRect;
	local string btnMinName;
	local WindowHandle wBtnMin;
	local L2UITween.TweenObject tObject;

	m_hOwnerWnd.KillTimer(GetIndexByName(wName));
	GetClientCursorPos(X, Y);
	btnMinName = (((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ wName) $ "Min");
	Class'Interface.L2UITween'.static.Inst().StopTween(btnMinName, 0);
	wBtnMin = GetWindowHandle((btnMinName $ ".MinContents"));
	minRect = GetWindowHandle(btnMinName).GetRect();
	btnMinRect = wBtnMin.GetRect();
	wBtnMin.MoveC(((minRect.nWidth - btnMinRect.nWidth) / 2), ((minRect.nHeight - btnMinRect.nHeight) / 2));
	wBtnMin.Move((((X - (btnMinRect.nWidth / 2)) - minRect.nX) / 50), (((Y - (btnMinRect.nHeight / 2)) - minRect.nY) / 50));
	btnMinRect = wBtnMin.GetRect();
	wBtnMin.SetAlpha(0);
	tObject.Alpha = 255.0000000;
	tObject.Duration = 300.0000000;
	tObject.ease = OUT_BOUNCE;
	tObject.MoveX = float(((minRect.nX - btnMinRect.nX) + ((minRect.nWidth - btnMinRect.nWidth) / 2)));
	tObject.MoveY = float(((minRect.nY - btnMinRect.nY) + ((minRect.nHeight - btnMinRect.nHeight) / 2)));
	tObject.Target = wBtnMin;
	tObject.Owner = btnMinName;
	Class'Interface.L2UITween'.static.Inst().AddTweenObject(tObject);
	return;
}

function Push(string wName)
{
	local Rect btnMinRect, targetRect;
	local string btnMinName;
	local WindowHandle wBtnMin, tWnd;
	local L2UITween.TweenObject tObject;

	btnMinName = (((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ wName) $ "Min");
	Class'Interface.L2UITween'.static.Inst().StopTween(btnMinName, 0);
	wBtnMin = GetWindowHandle((btnMinName $ ".MinContents"));
	tWnd = GetWindowHandle(wName);
	if((tWnd.m_pTargetWnd == none))
	{
		GetINIInt(wName, "x", targetRect.nX, "WindowsInfo.ini");
		GetINIInt(wName, "y", targetRect.nY, "WindowsInfo.ini");
		GetINIInt(wName, "w", targetRect.nWidth, "WindowsInfo.ini");
		GetINIInt(wName, "h", targetRect.nHeight, "WindowsInfo.ini");
	}
	else
	{
		targetRect = tWnd.GetRect();
	}
	btnMinRect = wBtnMin.GetRect();
	tObject.Alpha = -255.0000000;
	tObject.Duration = 300.0000000;
	tObject.ease = OUT_STRONG;
	tObject.MoveX = (float(((targetRect.nX - btnMinRect.nX) + ((targetRect.nWidth - btnMinRect.nWidth) / 2))) / 20.0000000);
	tObject.MoveY = (float(((targetRect.nY - btnMinRect.nY) + ((targetRect.nHeight - btnMinRect.nHeight) / 2))) / 20.0000000);
	tObject.Target = wBtnMin;
	tObject.Owner = btnMinName;
	Class'Interface.L2UITween'.static.Inst().AddTweenObject(tObject);
	m_hOwnerWnd.SetTimer(GetIndexByName(wName), 700);
	return;
}

function string UtilDelMin(string wName)
{
	return Left(wName, (Len(wName) - 3));
}

function int GetIndexByName(string wName)
{
	local int i;

	i = 0;
	while((i < ownerWwindowNames.Length))
	{
		if((ownerWwindowNames[i] == wName))
		{
			return i;
		}
		i++;
	}
	return -1;
}
