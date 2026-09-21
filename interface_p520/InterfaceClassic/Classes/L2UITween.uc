class L2UITween extends UICommonAPI;

const TWEENEND = "tweenEnd";
const SHAKEEND = "shakeEnd";





var WindowHandle Me;
var float lastAppSeconds;
var INT64 lastAppMilliSeconds;
var array<L2UITweenObject> tweenObjects;
var array<L2UITweenTwinkleObject> twinkleObjects;
var array<ShakeObject> shakeObjects;
var array<L2UITweenRotateObject> rotateObjects;
var bool isTickOn;

static function L2UITween Inst()
{
	return L2UITween(GetScript("L2UITween"));
}

event OnLoad()
{
	Me = GetWindowHandle("L2UITween");
	return;
}

event OnTick()
{
	local float DeltaTime;

	DeltaTime = (float(GetDeltaMilliTime()) / 1000.0000000);
	SetLastAppMilliSeconds();
	if((twinkleObjects.Length > 0))
	{
		UpdatePositionTwinkle(DeltaTime);
	}
	if((tweenObjects.Length > 0))
	{
		UpdatePosition(DeltaTime);
	}
	if((shakeObjects.Length > 0))
	{
		UpdatePositionShake(DeltaTime);
	}
	if((rotateObjects.Length > 0))
	{
		UpdatePositionRotate(DeltaTime);
	}
	CheckTickEnable();
	return;
}

function SetLastAppMilliSeconds()
{
	lastAppMilliSeconds = GetAppMilliSeconds();
	return;
}

function INT64 GetDeltaMilliTime()
{
	return (GetAppMilliSeconds() - lastAppMilliSeconds);
}

function TickOn()
{
	if(isTickOn)
	{
		return;
	}
	isTickOn = true;
	Me.EnableTick();
	SetLastAppMilliSeconds();
	return;
}

function TickOff()
{
	if(!isTickOn)
	{
		return;
	}
	isTickOn = false;
	Me.DisableTick();
	return;
}

function CheckTickEnable()
{
	if((tweenObjects.Length > 0))
	{
		return;
	}
	if((shakeObjects.Length > 0))
	{
		return;
	}
	if((twinkleObjects.Length > 0))
	{
		return;
	}
	if((rotateObjects.Length > 0))
	{
		return;
	}
	TickOff();
	return;
}

function Add(string TargetName, string Owner, int Id, int ease, float Duration, float Alpha, float MoveX, float MoveY, float SizeX, float SizeY, optional float Delay)
{
	local TweenObject tweenObj;

	tweenObj.Position = 0.0000000;
	tweenObj.Delay = Delay;
	tweenObj.Target = GetWindowHandle(TargetName);
	tweenObj.Owner = Owner;
	tweenObj.Id = Id;
	tweenObj.ease = easeType(ease);
	tweenObj.Duration = Duration;
	tweenObj.Alpha = Alpha;
	tweenObj.MoveX = MoveX;
	tweenObj.MoveY = MoveY;
	tweenObj.SizeX = SizeX;
	tweenObj.SizeY = SizeY;
	AddTweenObject(tweenObj);
	return;
}

function AddTweenObject(TweenObject tweenObj)
{
	local L2UITweenObject l2uiTweenObj;

	l2uiTweenObj = new Class'InterfaceClassic.L2UITweenObject';
	tweenObj.Position = 0.0000000;
	l2uiTweenObj.Position = tweenObj.Position;
	l2uiTweenObj.Delay = tweenObj.Delay;
	l2uiTweenObj.Target = tweenObj.Target;
	l2uiTweenObj.Owner = tweenObj.Owner;
	l2uiTweenObj.Id = tweenObj.Id;
	l2uiTweenObj.ease = easeType(tweenObj.ease);
	l2uiTweenObj.Duration = tweenObj.Duration;
	l2uiTweenObj.Alpha = tweenObj.Alpha;
	l2uiTweenObj.MoveX = tweenObj.MoveX;
	l2uiTweenObj.MoveY = tweenObj.MoveY;
	l2uiTweenObj.SizeX = tweenObj.SizeX;
	l2uiTweenObj.SizeY = tweenObj.SizeY;
	SetStartValue(l2uiTweenObj);
	TickOn();
	tweenObjects[tweenObjects.Length] = l2uiTweenObj;
	return;
}

function StopTween(string Owner, int Id)
{
	local int Index;

	Index = GetTweenObjectIndex(Owner, Id);
	if((Index != -1))
	{
		tweenObjects.Remove(Index, 1);
	}
	return;
}

function _AddTweenObject(L2UITweenObject tObject)
{
	SetStartValue(tObject);
	TickOn();
	tweenObjects[tweenObjects.Length] = tObject;
	return;
}

function _Pause(string Owner, int Id)
{
	local int Index;

	Index = GetTweenObjectIndex(Owner, Id);
	if((Index != -1))
	{
		tweenObjects[Index]._Pause();
	}
	return;
}

function _Play(string Owner, int Id)
{
	local int Index;

	Index = GetTweenObjectIndex(Owner, Id);
	if((Index != -1))
	{
		tweenObjects[Index]._Play();
	}
	return;
}

function SetStartValue(out L2UITweenObject tweenObjectData)
{
	local Rect rectWnd, rectWndParent;

	tweenObjectData._DelegateOnStart(tweenObjectData);
	rectWnd = tweenObjectData.Target.GetRect();
	rectWndParent = tweenObjectData.Target.GetParentWindowHandle().GetRect();
	tweenObjectData.alphaStart = tweenObjectData.Target.GetAlpha();
	tweenObjectData.posX = (rectWnd.nX - rectWndParent.nX);
	tweenObjectData.posY = (rectWnd.nY - rectWndParent.nY);
	tweenObjectData.sizeXStart = rectWnd.nWidth;
	tweenObjectData.sizeYStart = rectWnd.nHeight;
	return;
}

function UpdatePosition(float Value)
{
	local float ratio, ratioEase, beforePosition, delaySec;
	local int i;
	local array<int> completeds;
	local array<L2UITweenObject> completedargetObject;

	i = 0;
	while((i < tweenObjects.Length))
	{
		if(tweenObjects[i].Paused)
		{
			i++;
			continue;
		}
		beforePosition = tweenObjects[i].Position;
		(tweenObjects[i].Position += Value);
		delaySec = (tweenObjects[i].Delay / 1000.0000000);
		if((tweenObjects[i].Position <= delaySec))
		{
			i++;
			continue;
		}
		if((beforePosition <= delaySec))
		{
			tweenObjects[i]._DelegateOnPlayStart(tweenObjects[i]);
		}
		tweenObjects[i]._DelegateOnUpdate(tweenObjects[i]);
		ratio = ((tweenObjects[i].Position - (tweenObjects[i].Delay / 1000.0000000)) / (tweenObjects[i].Duration / 1000.0000000));
		if((ratio >= 1.0000000))
		{
			ratio = 1.0000000;
			tweenObjects[i].Position = ((tweenObjects[i].Duration + tweenObjects[i].Delay) / 1000.0000000);
			completedargetObject[completedargetObject.Length] = tweenObjects[i];
			completeds[completeds.Length] = i;
		}
		ratioEase = _GetRationEase(ratio, tweenObjects[i].ease);
		if((tweenObjects[i].Target.m_pTargetWnd == none))
		{
			i++;
			continue;
		}
		if((tweenObjects[i].Alpha != 0.0000000))
		{
			tweenObjects[i].Target.SetAlpha(int((float(tweenObjects[i].alphaStart) + (tweenObjects[i].Alpha * ratioEase))));
		}
		if(((tweenObjects[i].SizeX != 0.0000000) || (tweenObjects[i].SizeY != 0.0000000)))
		{
			tweenObjects[i].Target.SetWindowSize(int((float(tweenObjects[i].sizeXStart) + (tweenObjects[i].SizeX * ratioEase))), int((float(tweenObjects[i].sizeYStart) + (tweenObjects[i].SizeY * ratioEase))));
		}
		if(((tweenObjects[i].MoveX != 0.0000000) || (tweenObjects[i].MoveY != 0.0000000)))
		{
			tweenObjects[i].Target.MoveC(int((float(tweenObjects[i].posX) + (tweenObjects[i].MoveX * ratioEase))), int((float(tweenObjects[i].posY) + (tweenObjects[i].MoveY * ratioEase))));
		}
		tweenObjects[i].ratio = ratio;
		tweenObjects[i].ratioEase = ratioEase;
		i++;
	}
	i = (completeds.Length - 1);
	while((i >= 0))
	{
		tweenObjects.Remove(completeds[i], 1);
		i--;
	}
	i = 0;
	while((i < completeds.Length))
	{
		CompleteTween(completedargetObject[i]);
		i++;
	}
	return;
}

function CompleteTween(L2UITweenObject tweenObjectData)
{
	local WindowHandle Target;

	Target = tweenObjectData.Target;
	if((tweenObjectData.Alpha > 0.0000000))
	{
		Target.SetAlpha(int((float(tweenObjectData.alphaStart) + tweenObjectData.Alpha)));
	}
	Target.SetWindowSize(int((float(tweenObjectData.sizeXStart) + tweenObjectData.SizeX)), int((float(tweenObjectData.sizeYStart) + tweenObjectData.SizeY)));
	Target.MoveC(int((float(tweenObjectData.posX) + tweenObjectData.MoveX)), int((float(tweenObjectData.posY) + tweenObjectData.MoveY)));
	GetScript(tweenObjectData.Owner).OnCallUCFunction("tweenEnd", string(tweenObjectData.Id));
	tweenObjectData._DelegateOnEnd(tweenObjectData);
	return;
}

function StartShake(string TargetName, int nShakeSize, int nTime, directionType Dir, optional int Delay, optional int Id)
{
	local ShakeObject shakeObjectData;

	shakeObjectData.Owner = TargetName;
	shakeObjectData.Target = GetWindowHandle(TargetName);
	shakeObjectData.Duration = float(nTime);
	shakeObjectData.shakeSize = float(nShakeSize);
	shakeObjectData.Direction = Dir;
	shakeObjectData.Delay = float(Delay);
	shakeObjectData.Id = Id;
	StartShakeObject(shakeObjectData);
	return;
}

function StartShakeObject(ShakeObject shakeObjectData)
{
	shakeObjects[shakeObjects.Length] = shakeObjectData;
	TickOn();
	return;
}

function SetStartValueShake(out ShakeObject shakeObjectData)
{
	local Rect rectWnd, rectWndParent;

	rectWnd = shakeObjectData.Target.GetRect();
	rectWndParent = shakeObjectData.Target.GetParentWindowHandle().GetRect();
	shakeObjectData.posX = (rectWnd.nX - rectWndParent.nX);
	shakeObjectData.posY = (rectWnd.nY - rectWndParent.nY);
	shakeObjectData.shakeStarted = true;
	return;
}

function UpdatePositionShake(float DeltaTime)
{
	local int i;
	local array<int> Completed;
	local float ratio;
	local bool complete;

	i = 0;
	while((i < shakeObjects.Length))
	{
		(shakeObjects[i].Position += DeltaTime);
		if((shakeObjects[i].Position <= (shakeObjects[i].Delay / 1000.0000000)))
		{
			i++;
			continue;
		}
		else if(!shakeObjects[i].shakeStarted)
		{
			SetStartValueShake(shakeObjects[i]);
		}
		ratio = ((shakeObjects[i].Position - (shakeObjects[i].Delay / 1000.0000000)) / (shakeObjects[i].Duration / 1000.0000000));
		complete = (ratio >= 1.0000000);
		Shake(shakeObjects[i], ratio);
		if(complete)
		{
			Completed[Completed.Length] = i;
			CompleteShake(i);
		}
		i++;
	}
	i = (Completed.Length - 1);
	while((i >= 0))
	{
		shakeObjects.Remove(Completed[i], 1);
		i--;
	}
	return;
}

function Shake(ShakeObject shakeObjectData, float ratio)
{
	local float X, Y, Value;

	switch(shakeObjectData.Direction)
	{
		case big:
			Value = (shakeObjectData.shakeSize * ratio);
			break;
		case small:
			Value = (shakeObjectData.shakeSize * (1.0000000 - ratio));
			break;
		default:
			break;
	}
	if((Rand(2) == 0))
	{
		X = float((shakeObjectData.posX - appRound(float(Rand(int(Value))))));
	}
	else
	{
		X = float((shakeObjectData.posX + appRound(float(Rand(int(Value))))));
	}
	if((Rand(2) == 0))
	{
		Y = float((shakeObjectData.posY - appRound(float(Rand(int(Value))))));
	}
	else
	{
		Y = float((shakeObjectData.posY + appRound(float(Rand(int(Value))))));
	}
	shakeObjectData.Target.MoveC(int(X), int(Y));
	return;
}

function StopShake(string Owner, int Id)
{
	local int Index;

	Index = GetShakeObjectIndex(Owner, Id);
	if((Index != -1))
	{
		shakeObjects.Remove(Index, 1);
	}
	return;
}

function int GetShakeObjectIndex(string Owner, int Id)
{
	local int i;

	i = 0;
	while((i < shakeObjects.Length))
	{
		if(((shakeObjects[i].Owner == Owner) && (shakeObjects[i].Id == Id)))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function CompleteShake(int Index)
{
	local WindowHandle Target;
	local ShakeObject shakeObjectData;

	shakeObjectData = shakeObjects[Index];
	Target = shakeObjectData.Target;
	Target.MoveC(shakeObjectData.posX, shakeObjectData.posY);
	GetScript(shakeObjectData.Owner).OnCallUCFunction("shakeEnd", string(shakeObjectData.Id));
	return;
}

function L2UITweenTwinkleObject _AddTweenTwinlkle(WindowHandle targetObject, optional float twinkleNum, optional float startRatio, optional float Duration, optional int minAlpha, optional int maxAlpha, optional float gab, optional float Delay)
{
	local L2UITweenTwinkleObject twinkleObj;
	local int Index;

	if((targetObject.m_pTargetWnd == none))
	{
		return none;
	}
	if((Duration == 0.0000000))
	{
		Duration = 1000.0000000;
	}
	twinkleObj = new Class'InterfaceClassic.L2UITweenTwinkleObject';
	twinkleObj.Owner = targetObject.GetTopFrameWnd().GetWindowName();
	twinkleObj.Target = targetObject;
	twinkleObj.Duration = Duration;
	twinkleObj.twinkleNum = twinkleNum;
	twinkleObj.startRatio = startRatio;
	twinkleObj.minAlpha = minAlpha;
	twinkleObj.gab = gab;
	twinkleObj.Delay = Delay;
	twinkleObj._SetRatio(startRatio);
	if((maxAlpha == 0))
	{
		twinkleObj.maxAlpha = 255;
	}
	else
	{
		twinkleObj.maxAlpha = maxAlpha;
	}
	Index = GetTwinkleObjectIndex(targetObject);
	if((Index >= 0))
	{
		twinkleObjects[Index] = twinkleObj;
	}
	else
	{
		twinkleObjects[twinkleObjects.Length] = twinkleObj;
		TickOn();
	}
	return twinkleObj;
}

function UpdatePositionTwinkle(float Value)
{
	local int i, Index;
	local float ratio;
	local array<int> completeds;
	local L2UITweenTwinkleObject delegateOnEnds;

	i = 0;
	while((i < twinkleObjects.Length))
	{
		if(twinkleObjects[i].Paused)
		{
			i++;
			continue;
		}
		if(!twinkleObjects[i].Target.GetTopFrameWnd().IsShowWindow())
		{
			i++;
			continue;
		}
		if((twinkleObjects[i].Delay > 0.0000000))
		{
			if((twinkleObjects[i].Delay > Value))
			{
				(twinkleObjects[i].Delay -= Value);
				i++;
				continue;
			}
			else
			{
				if((twinkleObjects[i].Position == 0.0000000))
				{
					twinkleObjects[i]._DelegateOnStart(twinkleObjects[i]);
				}
				(twinkleObjects[i].Position += twinkleObjects[i].Delay);
				twinkleObjects[i].Delay = 0.0000000;
			}
			ratio = twinkleObjects[i]._Ratio();
		}
		else
		{
			if((twinkleObjects[i].Position == 0.0000000))
			{
				twinkleObjects[i]._DelegateOnStart(twinkleObjects[i]);
			}
			(twinkleObjects[i].Position += Value);
			ratio = twinkleObjects[i]._Ratio();
			if((int((ratio - ((Value * 1000.0000000) / twinkleObjects[i].Duration))) < int(ratio)))
			{
				twinkleObjects[i].Delay = twinkleObjects[i].gab;
			}
		}
		twinkleObjects[i]._DelegateOnUpdate(twinkleObjects[i]);
		if((twinkleObjects[i].twinkleNum == -1.0000000))
		{
			if((ratio >= 1.0000000))
			{
				twinkleObjects[i].Position = 0.0000000;
			}
		}
		else if((ratio >= twinkleObjects[i].twinkleNum))
		{
			completeds[completeds.Length] = i;
			ratio = twinkleObjects[i].twinkleNum;
		}
		if((twinkleObjects[i].Target.m_pTargetWnd != none))
		{
			twinkleObjects[i].Target.SetAlpha((int((((Cos(((ratio * 2.0000000) * 3.1415927)) + 1.0000000) / 2.0000000) * float((twinkleObjects[i].maxAlpha - twinkleObjects[i].minAlpha)))) + twinkleObjects[i].minAlpha));
		}
		i++;
	}
	i = (completeds.Length - 1);
	while((i >= 0))
	{
		Index = completeds[i];
		delegateOnEnds = twinkleObjects[Index];
		twinkleObjects.Remove(Index, 1);
		delegateOnEnds._DelegateOnEnd(delegateOnEnds);
		i--;
	}
	return;
}

function _KillTwinkleWithWnd(WindowHandle targetWnd)
{
	local int Index;

	Index = GetTwinkleObjectIndex(targetWnd);
	if((Index == -1))
	{
		return;
	}
	twinkleObjects.Remove(Index, 1);
	return;
}

function L2UITweenRotateObject _AddTweenRotate(WindowHandle targetObject, int ease, float Angle, optional float Duration, optional float Delay, optional bool replay, optional Vector axisvector)
{
	local L2UITweenRotateObject rotateObj;
	local int Index;

	if((targetObject.m_pTargetWnd == none))
	{
		return none;
	}
	if((Duration == 0.0000000))
	{
		Duration = 1000.0000000;
	}
	rotateObj = new Class'InterfaceClassic.L2UITweenRotateObject';
	rotateObj.Owner = targetObject.GetTopFrameWnd().GetWindowName();
	rotateObj.Target = targetObject;
	rotateObj.Duration = Duration;
	rotateObj.Delay = Delay;
	rotateObj.Angle = Angle;
	rotateObj.replay = replay;
	rotateObj.ease = easeType(ease);
	if((((axisvector.X == 0.0000000) && (axisvector.Y == 0.0000000)) && (axisvector.Z == 0.0000000)))
	{
		axisvector.Z = 1.0000000;
	}
	rotateObj.axisvector = axisvector;
	Index = GetRotateObjectIndex(targetObject);
	if((Index >= 0))
	{
		rotateObjects[Index] = rotateObj;
	}
	else
	{
		rotateObjects[rotateObjects.Length] = rotateObj;
		TickOn();
	}
	return rotateObj;
}

function UpdatePositionRotate(float Value)
{
	local int i, Index;
	local float ratio, ratioBefore, ratioEase, ratioEaseBefore;
	local array<int> completeds;
	local L2UITweenRotateObject delegateOnEnds;

	i = 0;
	while((i < rotateObjects.Length))
	{
		if(rotateObjects[i].Paused)
		{
			i++;
			continue;
		}
		if(!rotateObjects[i].Target.GetTopFrameWnd().IsShowWindow())
		{
			i++;
			continue;
		}
		if((rotateObjects[i].Delay > 0.0000000))
		{
			if((rotateObjects[i].Delay > Value))
			{
				(rotateObjects[i].Delay -= Value);
				i++;
				continue;
			}
			else
			{
				if((rotateObjects[i].Position == 0.0000000))
				{
					rotateObjects[i]._DelegateOnStart(rotateObjects[i]);
				}
				ratioBefore = rotateObjects[i]._Ratio();
				ratioEaseBefore = _GetRationEase(ratioBefore, rotateObjects[i].ease);
				(rotateObjects[i].Position += rotateObjects[i].Delay);
				rotateObjects[i].Delay = 0.0000000;
			}
			ratio = rotateObjects[i]._Ratio();
		}
		else
		{
			if((rotateObjects[i].Position == 0.0000000))
			{
				rotateObjects[i]._DelegateOnStart(rotateObjects[i]);
			}
			ratioBefore = rotateObjects[i]._Ratio();
			ratioEaseBefore = _GetRationEase(ratioBefore, rotateObjects[i].ease);
			(rotateObjects[i].Position += Value);
			ratio = rotateObjects[i]._Ratio();
		}
		rotateObjects[i]._DelegateOnUpdate(rotateObjects[i]);
		if((rotateObjects[i].replay == true))
		{
			if((ratio >= 1.0000000))
			{
				rotateObjects[i].Target.SetRotationAngle((rotateObjects[i].Target.GetRotationAngle() + (rotateObjects[i].Angle * (1.0000000 - ratioEaseBefore))), rotateObjects[i].axisvector);
				rotateObjects[i].Position = (rotateObjects[i].Position % 1.0000000);
				ratio = (ratio % 1.0000000);
				ratioEaseBefore = 0.0000000;
			}
		}
		else if((ratio >= 1.0000000))
		{
			completeds[completeds.Length] = i;
			ratio = 1.0000000;
		}
		if((rotateObjects[i].Target.m_pTargetWnd != none))
		{
			ratioEase = _GetRationEase(ratio, rotateObjects[i].ease);
			rotateObjects[i].Target.SetRotationAngle((rotateObjects[i].Target.GetRotationAngle() + (rotateObjects[i].Angle * (ratioEase - ratioEaseBefore))), rotateObjects[i].axisvector);
		}
		i++;
	}
	i = (completeds.Length - 1);
	while((i >= 0))
	{
		Index = completeds[i];
		delegateOnEnds = rotateObjects[Index];
		rotateObjects.Remove(Index, 1);
		delegateOnEnds._DelegateOnEnd(delegateOnEnds);
		i--;
	}
	return;
}

function _KillRotateWithWnd(WindowHandle targetWnd)
{
	local int Index;

	Index = GetTwinkleObjectIndex(targetWnd);
	if((Index == -1))
	{
		return;
	}
	twinkleObjects.Remove(Index, 1);
	return;
}

function int _GetRotateObjectIndex(WindowHandle wndHancle)
{
	return GetRotateObjectIndex(wndHancle);
}

function int GetRotateObjectIndex(WindowHandle wndHandle)
{
	local int i;

	i = 0;
	while((i < rotateObjects.Length))
	{
		if((rotateObjects[i].Target == wndHandle))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function int GetTwinkleObjectIndex(WindowHandle wndHandle)
{
	local int i;

	i = 0;
	while((i < twinkleObjects.Length))
	{
		if((twinkleObjects[i].Target == wndHandle))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function int _GetTweenObjectIndex(string Owner, int Id)
{
	return GetTweenObjectIndex(Owner, Id);
}

function int GetTweenObjectIndex(string Owner, int Id)
{
	local int i;

	i = 0;
	while((i < tweenObjects.Length))
	{
		if(((tweenObjects[i].Owner == Owner) && (tweenObjects[i].Id == Id)))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function int GetAbs(int Num)
{
	if((Num < 0))
	{
		return -Num;
	}
	return Num;
}

function float _GetRationEase(float ratio, easeType Type)
{
	switch(Type)
	{
		case IN_STRONG:
			return easeInStrong(ratio, 0.0000000, 1.0000000, 1.0000000);
			break;
		case OUT_STRONG:
			return easeOutStrong(ratio, 0.0000000, 1.0000000, 1.0000000);
			break;
		case INOUT_STRONG:
			return easeInOutStrong(ratio, 0.0000000, 1.0000000, 1.0000000);
			break;
		case IN_BOUNCE:
			return easeInBounce(ratio, 0.0000000, 1.0000000, 1.0000000);
			break;
		case OUT_BOUNCE:
			return easeOutBounce(ratio, 0.0000000, 1.0000000, 1.0000000);
			break;
		case INOUT_BOUNCE:
			return easeInOutBounce(ratio, 0.0000000, 1.0000000, 1.0000000);
			break;
		case IN_ELASTIC:
			return easeInElastic(ratio, 0.0000000, 1.0000000, 1.0000000);
			break;
		case OUT_ELASTIC:
			return easeOutElastic(ratio, 0.0000000, 1.0000000, 1.0000000);
			break;
		case INOUT_ELASTIC:
			break;
		case EASENONE:
			break;
		default:
			break;
	}
	return ratio;
}

function float easeInElastic(float t, float B, float C, float D, optional float A, optional float P)
{
	local float S, PI2;

	PI2 = (2.0000000 * 3.1415927);
	if((t == 0.0000000))
	{
		return B;
	}
	if(((t /= D) == 1.0000000))
	{
		return (B + C);
	}
	if((P != 0.0000000))
	{
		P = (D * 0.3000000);
	}
	if(((A != 0.0000000) || (A < float(GetAbs(int(C))))))
	{
		A = C;
		S = (P / 4.0000000);
	}
	else
	{
		S = ((P / PI2) * Asin((C / A)));
	}
	return (-((A * ExpFloat((10.0000000 * (t -= 1.0000000)), 2)) * Sin(((((t * D) - S) * PI2) / P))) + B);
}

function float easeOutElastic(float t, float B, float C, float D, optional float A, optional float P)
{
	local float S, PI2;

	PI2 = (2.0000000 * 3.1415927);
	if((t == 0.0000000))
	{
		return B;
	}
	if(((t /= D) == 1.0000000))
	{
		return (B + C);
	}
	if((P != 0.0000000))
	{
		P = (D * 0.3000000);
	}
	if(((A != 0.0000000) || (A < float(GetAbs(int(C))))))
	{
		A = C;
		S = (P / 4.0000000);
	}
	else
	{
		S = ((P / PI2) * Asin((C / A)));
	}
	return ((((A * ExpFloat(2.0000000, (-10 * t))) * Sin(((((t * D) - S) * PI2) / P))) + C) + B);
}

function float easeOutBounce(float t, float B, float C, float D)
{
	if(((t /= D) < (1.0000000 / 2.7500000)))
	{
		return ((C * ((7.5625000 * t) * t)) + B);
	}
	else if((t < (2.0000000 / 2.7500000)))
	{
		return ((C * (((7.5625000 * (t -= (1.5000000 / 2.7500000))) * t) + 0.7500000)) + B);
	}
	else if((t < (2.5000000 / 2.7500000)))
	{
		return ((C * (((7.5625000 * (t -= (2.2500000 / 2.7500000))) * t) + 0.9375000)) + B);
	}
	else
	{
		return ((C * (((7.5625000 * (t -= (2.6250000 / 2.7500000))) * t) + 0.9843750)) + B);
	}
}

function float easeInBounce(float t, float B, float C, float D)
{
	return ((C - easeOutBounce((D - t), 0.0000000, C, D)) + B);
}

function float easeInOutBounce(float t, float B, float C, float D)
{
	if((t < (D / 2.0000000)))
	{
		return ((easeInBounce((t * 2.0000000), 0.0000000, C, D) * 0.5000000) + B);
	}
	else
	{
		return (((easeOutBounce(((t * 2.0000000) - D), 0.0000000, C, D) * 0.5000000) + (C * 0.5000000)) + B);
	}
}

function float easeInOutStrong(float t, float B, float C, float D)
{
	if(((t /= (D / 2.0000000)) < 1.0000000))
	{
		return (((((((C / 2.0000000) * t) * t) * t) * t) * t) + B);
	}
	return (((C / 2.0000000) * ((((((t -= 2.0000000) * t) * t) * t) * t) + 2.0000000)) + B);
}

function float easeOutStrong(float t, float B, float C, float D)
{
	t = (t - 1.0000000);
	return (ExpFloat(t, 5) + 1.0000000);
}

function float easeInStrong(float t, float B, float C, float D)
{
	return ((((((C * (t /= D)) * t) * t) * t) * t) + B);
}
