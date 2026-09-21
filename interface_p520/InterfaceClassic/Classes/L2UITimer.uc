class L2UITimer extends UIScript;

const TIMER_ID_NULL = 0;

var array<L2UITimerObject> timerObjects;
var int lastTimerID;
var array<int> returnedIndex;

static function L2UITimer Inst()
{
	return L2UITimer(GetScript("L2UITimer"));
}

function L2UITimerObject _AddTimerOnce(optional int Time, optional int maxCount, optional int Delay)
{
	local L2UITimerObject timerObject;

	timerObject = _MakeTimerObject(Time, maxCount, Delay, true);
	_Play(timerObject._timerID);
	return timerObject;
}

function L2UITimerObject _MakeTimerObject(optional int Time, optional int maxCount, optional int Delay, optional bool isKillOnEnd)
{
	local int Len;

	if((Time == 0))
	{
		Time = 1000;
	}
	Len = timerObjects.Length;
	timerObjects[Len] = new Class'InterfaceClassic.L2UITimerObject';
	timerObjects[Len]._time = Time;
	timerObjects[Len]._timerID = GetEmptyTimerID();
	timerObjects[Len]._isKillOnEnd = isKillOnEnd;
	timerObjects[Len]._delay = Delay;
	if((maxCount == 0))
	{
		timerObjects[Len]._maxCount = 1;
	}
	else
	{
		timerObjects[Len]._maxCount = maxCount;
	}
	return timerObjects[Len];
}

function bool _Play(int TimerID)
{
	local int Index;
	local L2UITimerObject timerObject;

	if(!FindIndex(TimerID, Index))
	{
		return false;
	}
	timerObject = timerObjects[Index];
	m_hOwnerWnd.KillTimer(timerObject._timerID);
	if((timerObject._delay == 0))
	{
		if(((timerObject._curCount == 0) && (timerObject._Position() == 0.0000000)))
		{
			timerObject._DelegateOnPlayStart();
		}
		m_hOwnerWnd.SetTimer(timerObject._timerID, timerObject._time);
	}
	else
	{
		m_hOwnerWnd.SetTimer(timerObject._timerID, timerObject._delay);
	}
	return true;
}

function bool _Pause(int TimerID)
{
	local int Index;

	if(!FindIndex(TimerID, Index))
	{
		return false;
	}
	m_hOwnerWnd.KillTimer(timerObjects[Index]._timerID);
	return true;
}

function bool _Stop(int TimerID)
{
	local int Index;

	if(!FindIndex(TimerID, Index))
	{
		return false;
	}
	StopWithIndex(Index);
	return true;
}

function bool _Kill(int TimerID)
{
	local int Index;

	if(!FindIndex(TimerID, Index))
	{
		return false;
	}
	KillWithIndex(Index);
	return true;
}

function _KillAllTimer(optional bool isKillALll)
{
	local int i;

	i = 0;
	while((i < timerObjects.Length))
	{
		m_hOwnerWnd.KillTimer(timerObjects[i]._timerID);
		timerObjects[i]._timerID = 0;
		timerObjects[i] = none;
		i++;
	}
	timerObjects.Length = 0;
	returnedIndex.Length = 0;
	lastTimerID = 0;
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(40);
	return;
}

event OnEvent(int eID, string param)
{
	switch(eID)
	{
		case 40:
			HandleEvRestart();
			break;
		default:
			break;
	}
	return;
}

function HandleEvRestart()
{
	local int i, Len;

	Len = timerObjects.Length;
	i = Len;
	while((i >= 0))
	{
		if(timerObjects[i]._isKillOnEnd)
		{
			KillWithIndex(i);
			i--;
			continue;
		}
		StopWithIndex(i);
		i--;
	}
	return;
}

event OnTimer(int TimerID)
{
	local int Index;
	local L2UITimerObject timerObject;

	if(!FindIndex(TimerID, Index))
	{
		return;
	}
	timerObject = timerObjects[Index];
	if((timerObject._delay > 0))
	{
		timerObject._delay = 0;
		m_hOwnerWnd.KillTimer(timerObject._timerID);
		if(((timerObject._curCount == 0) && (timerObject._Position() == 0.0000000)))
		{
			timerObject._DelegateOnPlayStart();
		}
		m_hOwnerWnd.SetTimer(timerObject._timerID, timerObject._time);
		return;
	}
	if((timerObject._curCount == 0))
	{
		timerObject._DelegateOnStart();
	}
	timerObject._DelegateOnTime(timerObject._curCount);
	timerObject._curCount++;
	if((timerObject._curCount == timerObject._maxCount))
	{
		if(timerObject._isKillOnEnd)
		{
			KillWithIndex(Index);
		}
		else
		{
			m_hOwnerWnd.KillTimer(timerObject._timerID);
		}
		timerObject._DelegateOnEnd();
	}
	return;
}

function int GetEmptyTimerID()
{
	local int TimerID;

	if((returnedIndex.Length > 0))
	{
		TimerID = returnedIndex[0];
		returnedIndex.Remove(0, 1);
		return TimerID;
	}
	lastTimerID++;
	return lastTimerID;
}

function ReturnTimerID(int TimerID)
{
	returnedIndex[returnedIndex.Length] = TimerID;
	return;
}

function StopWithIndex(int Index)
{
	m_hOwnerWnd.KillTimer(timerObjects[Index]._timerID);
	timerObjects[Index]._curCount = 0;
	return;
}

function KillWithIndex(int Index)
{
	m_hOwnerWnd.KillTimer(timerObjects[Index]._timerID);
	ReturnTimerID(timerObjects[Index]._timerID);
	timerObjects[Index]._timerID = 0;
	timerObjects[Index] = none;
	timerObjects.Remove(Index, 1);
	return;
}

function bool FindIndex(int TimerID, out int Index)
{
	local int i;

	i = 0;
	while((i < timerObjects.Length))
	{
		if((timerObjects[i]._timerID == TimerID))
		{
			Index = i;
			return true;
		}
		i++;
	}
	return false;
}

function bool FindTimerObject(int TimerID, out L2UITimerObject timerObject)
{
	local int Index;

	if(!FindIndex(TimerID, Index))
	{
		return false;
	}
	timerObject = timerObjects[Index];
	return true;
}
