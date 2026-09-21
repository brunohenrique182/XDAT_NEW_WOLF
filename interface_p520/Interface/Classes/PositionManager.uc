class PositionManager extends UICommonAPI;

var bool isMoving;
var bool isDown;
var array<PositionManagerWndBase> PositionManagerWndBases;

static function PositionManager Inst()
{
	return PositionManager(GetScript("PositionManager"));
}

event OnRegisterEvent()
{
	RegisterEvent(9750);
	RegisterEvent(2900);
	RegisterEvent(16);
	return;
}

event OnEvent(int eID, string param)
{
	switch(eID)
	{
		case 9750:
			MoveOnLoads();
			break;
		case 16:
			Handle_EV_Test_6(param);
			break;
		case 2900:
			Handle_EV_ResolutionChanged();
			break;
		default:
			break;
	}
	return;
}

function Handle_EV_ResolutionChanged()
{
	local int i;

	i = 0;
	while((i < PositionManagerWndBases.Length))
	{
		if(PositionManagerWndBases[i].m_hOwnerWnd.IsShowWindow())
		{
			PositionManagerWndBases[i]._SyncdPosition();
		}
		i++;
	}
	return;
}

function Handle_EV_Test_6(string param)
{
	local int Index;
	local string TargetName;
	local int oX, oY, tW, tH;

	ParseString(param, "n", TargetName);
	Index = GetIndexByWindowName(TargetName);
	if((Index == -1))
	{
		return;
	}
	ParseInt(param, "x", oX);
	ParseInt(param, "y", oY);
	ParseInt(param, "w", tW);
	ParseInt(param, "h", tH);
	if((oX != 0))
	{
		PositionManagerWndBases[Index].OffsetX = oX;
	}
	if((oY != 0))
	{
		PositionManagerWndBases[Index].OffsetY = oY;
	}
	if((tW != 0))
	{
		PositionManagerWndBases[Index].targetW = tW;
	}
	if((tH != 0))
	{
		PositionManagerWndBases[Index].targetH = tH;
	}
	return;
}

event OnCallUCFunction(string funcName, string param)
{
	switch(funcName)
	{
		case "setShow":
			SetShow();
			break;
		case "setDefault":
			SetDefault();
			break;
		default:
			break;
	}
	return;
}

function MoveOnLoads()
{
	local int i;

	i = 0;
	while((i < PositionManagerWndBases.Length))
	{
		PositionManagerWndBases[i]._MoveOnLoad();
		i++;
	}
	return;
}

function int GetIndexByWindowName(string targetWndName)
{
	local int i;

	i = 0;
	while((i < PositionManagerWndBases.Length))
	{
		if((PositionManagerWndBases[i]._targetWndname == targetWndName))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function SetDefault()
{
	local int i;

	i = 0;
	while((i < PositionManagerWndBases.Length))
	{
		PositionManagerWndBases[i]._ResetPosition();
		i++;
	}
	return;
}

function SetShow()
{
	local int i;

	i = 0;
	while((i < PositionManagerWndBases.Length))
	{
		PositionManagerWndBases[i]._SetShow();
		i++;
	}
	m_hOwnerWnd.BringToFront();
	return;
}

function _AddBase(PositionManagerWndBase Base)
{
	PositionManagerWndBases[PositionManagerWndBases.Length] = Base;
	return;
}

function _MoveOnLoad(string WindowName)
{
	local int Index;

	Index = GetIndexByWindowName(WindowName);
	PositionManagerWndBases[Index]._MoveOnLoad();
	return;
}

function bool _IsSaved(string WindowName)
{
	local int Index;

	Index = GetIndexByWindowName(WindowName);
	if((Index == -1))
	{
		return false;
	}
	return PositionManagerWndBases[Index]._IsSaved();
}
