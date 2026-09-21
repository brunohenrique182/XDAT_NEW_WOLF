class L2UITimerObject extends UIEventManager;

var int _time;
var int _timerID;
var int _curCount;
var int _maxCount;
var int _delay;
var bool _isKillOnEnd;
//var delegate<_DelegateOnPlayStart> ___DelegateOnPlayStart__Delegate;
//var delegate<_DelegateOnStart> ___DelegateOnStart__Delegate;
//var delegate<_DelegateOnTime> ___DelegateOnTime__Delegate;
//var delegate<_DelegateOnEnd> ___DelegateOnEnd__Delegate;

delegate _DelegateOnPlayStart()
{
	return;
}

delegate _DelegateOnStart()
{
	return;
}

delegate _DelegateOnTime(int Count)
{
	return;
}

delegate _DelegateOnEnd()
{
	return;
}

function float _Position()
{
	return (float(_curCount) / float(_maxCount));
}

function _Play(optional int Delay)
{
	if((Delay != 0))
	{
		_delay = Delay;
	}
	Class'Interface.L2UITimer'.static.Inst()._Play(_timerID);
	return;
}

function _Pause()
{
	Class'Interface.L2UITimer'.static.Inst()._Pause(_timerID);
	return;
}

function _Stop()
{
	Class'Interface.L2UITimer'.static.Inst()._Stop(_timerID);
	return;
}

function _Kill()
{
	Class'Interface.L2UITimer'.static.Inst()._Kill(_timerID);
	return;
}

function _Reset()
{
	Class'Interface.L2UITimer'.static.Inst()._Stop(_timerID);
	Class'Interface.L2UITimer'.static.Inst()._Play(_timerID);
	return;
}
