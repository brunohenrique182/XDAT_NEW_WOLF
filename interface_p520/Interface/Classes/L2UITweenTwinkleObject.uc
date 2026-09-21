class L2UITweenTwinkleObject extends UIEventManager;

var WindowHandle Target;
var string Owner;
var float Position;
var float Duration;
var float Delay;
var float twinkleNum;
var bool Paused;
var int minAlpha;
var int maxAlpha;
var float startRatio;
var float gab;
//var delegate<_DelegateOnStart> ___DelegateOnStart__Delegate;
//var delegate<_DelegateOnUpdate> ___DelegateOnUpdate__Delegate;
//var delegate<_DelegateOnEnd> ___DelegateOnEnd__Delegate;

delegate _DelegateOnStart(L2UITweenTwinkleObject Me)
{
	return;
}

delegate _DelegateOnUpdate(L2UITweenTwinkleObject Me)
{
	return;
}

delegate _DelegateOnEnd(L2UITweenTwinkleObject Me)
{
	return;
}

function float _Ratio()
{
	return (Position / (Duration / 1000.0000000));
}

function _SetRatio(float ratio)
{
	Position = (ratio * (Duration / 1000.0000000));
	return;
}

function float _Position()
{
	return Position;
}

function _Play(optional int _delay)
{
	if((_delay != 0))
	{
		Delay = float(_delay);
	}
	Paused = false;
	return;
}

function _Pause()
{
	Paused = true;
	return;
}

function _Stop()
{
	Paused = true;
	Position = 0.0000000;
	return;
}

function _Kill()
{
	Class'Interface.L2UITween'.static.Inst()._KillTwinkleWithWnd(Target);
	return;
}

function _Reset()
{
	Paused = false;
	_SetRatio(startRatio);
	return;
}
