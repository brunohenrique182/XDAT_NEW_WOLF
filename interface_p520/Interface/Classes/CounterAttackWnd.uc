class CounterAttackWnd extends UICommonAPI;

const TIMER_ID = 111;
const TIMER_DELAY = 180000;

var WindowHandle Me;
var string m_Windowname;
var int clickedX;
var int clickedY;
var bool OnMousePressed;

function OnRegisterEvent()
{
	RegisterEvent(11150);
	RegisterEvent(11151);
	return;
}

function OnLoad()
{
	Me = GetWindowHandle(m_Windowname);
	return;
}

function OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	local Rect rectWnd;

	rectWnd = Me.GetRect();
	clickedX = rectWnd.nX;
	clickedY = rectWnd.nY;
	return;
}

function OnShow()
{
	Me.SetTimer(111, 180000);
	return;
}

function OnHide()
{
	Me.KillTimer(111);
	return;
}

function OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case 111:
			ResetCounterAttackList();
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string Name)
{
	local Rect rectWnd;

	switch(Name)
	{
		case "CounterAttackIcon":
			rectWnd = Me.GetRect();
			if(((GetAbs((clickedX - rectWnd.nX)) > 3) || ((clickedY - rectWnd.nY) > 3)))
			{
				return;
			}
			SelectCounterAttackTarget();
			break;
		default:
			break;
	}
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 11150:
			if(!Me.IsShowWindow())
			{
				Me.ShowWindow();
				Me.SetFocus();
			}
			break;
		case 11151:
			Me.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function int GetAbs(int Num)
{
	if((Num < 0))
	{
		return -Num;
	}
	return Num;
}

defaultproperties
{
	m_Windowname="CounterAttackWnd"
}
