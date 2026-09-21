class L2UITweenRotateObject extends UIEventManager;

var WindowHandle Target;
var string Owner;
var float Position;
var float Duration;
var float Delay;
var float Angle;
var bool replay;
var bool Paused;
var L2UITween.easeType ease;
var Vector axisvector;
//var delegate<_DelegateOnStart> ___DelegateOnStart__Delegate;
//var delegate<_DelegateOnUpdate> ___DelegateOnUpdate__Delegate;
//var delegate<_DelegateOnEnd> ___DelegateOnEnd__Delegate;

delegate _DelegateOnStart(L2UITweenRotateObject Me)
{
	return;
}

delegate _DelegateOnUpdate(L2UITweenRotateObject Me)
{
	return;
}

delegate _DelegateOnEnd(L2UITweenRotateObject Me)
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
	if((Class'InterfaceClassic.L2UITween'.static.Inst()._GetRotateObjectIndex(Target) < 0))
	{
		Class'InterfaceClassic.L2UITween'.static.Inst()._AddTweenRotate(Target, int(ease), Angle, Duration, Delay, replay, axisvector);
	}
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
	Class'InterfaceClassic.L2UITween'.static.Inst()._KillRotateWithWnd(Target);
	return;
}

function _Reset()
{
	Paused = false;
	Position = 0.0000000;
	_Play(0);
	return;
}
