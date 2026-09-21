class L2UITweenObject extends UIEventManager;

var WindowHandle Target;
var string Owner;
var int Id;
var float Position;
var float Duration;
var float Delay;
var float ratio;
var float ratioEase;
var float MoveX;
var float MoveY;
var float Alpha;
var float SizeX;
var float SizeY;
var int alphaStart;
var int posX;
var int posY;
var int sizeXStart;
var int sizeYStart;
var L2UITween.easeType ease;
var bool Paused;
//var delegate<_DelegateOnStart> ___DelegateOnStart__Delegate;
//var delegate<_DelegateOnPlayStart> ___DelegateOnPlayStart__Delegate;
//var delegate<_DelegateOnUpdate> ___DelegateOnUpdate__Delegate;
//var delegate<_DelegateOnEnd> ___DelegateOnEnd__Delegate;

delegate _DelegateOnStart(L2UITweenObject Me)
{
	return;
}

delegate _DelegateOnPlayStart(L2UITweenObject Me)
{
	return;
}

delegate _DelegateOnUpdate(L2UITweenObject Me)
{
	return;
}

delegate _DelegateOnEnd(L2UITweenObject Me)
{
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
	if((Class'InterfaceClassic.L2UITween'.static.Inst()._GetTweenObjectIndex(Owner, Id) < 0))
	{
		Class'InterfaceClassic.L2UITween'.static.Inst()._AddTweenObject(self);
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
	ratioEase = 0.0000000;
	ratio = 0.0000000;
	return;
}

function _Kill()
{
	Class'InterfaceClassic.L2UITween'.static.Inst().StopTween(Owner, Id);
	return;
}

function _Reset()
{
	Position = 0.0000000;
	ratioEase = 0.0000000;
	ratio = 0.0000000;
	Class'InterfaceClassic.L2UITween'.static.Inst().StopTween(Owner, Id);
	_Play(0);
	return;
}

function _Reverse()
{
	return;
}
