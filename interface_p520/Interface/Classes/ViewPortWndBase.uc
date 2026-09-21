class ViewPortWndBase extends UICommonAPI;

const EFFECT_MONSTER_ID = 19671;

var string m_Windowname;
var WindowHandle Me;
var CharacterViewportWindowHandle m_ObjectViewport;

function OnLoad()
{
	m_Windowname = getCurrentWindowName(string(self));
	InitializeCOD();
	RegisterState("ViewPortWndBase", "CHARACTERSELECTSTATE");
	return;
}

function InitializeCOD()
{
	Me = GetWindowHandle(m_Windowname);
	m_ObjectViewport = GetCharacterViewportWindowHandle((m_Windowname $ ".EffectStageWnd.ObjectViewport"));
	m_ObjectViewport.SetSpawnDuration(0.2000000);
	Me.DisableWindow();
	return;
}

function SetNPCViewportData(int Id)
{
	m_ObjectViewport.SetNPCViewportData(Id);
	return;
}

function SpawnEffect(string EffectName)
{
	m_ObjectViewport.SpawnEffect(EffectName);
	return;
}

function SpawnNPC()
{
	m_ObjectViewport.SpawnNPC();
	return;
}

function PlayAnimation(int Index)
{
	m_ObjectViewport.PlayAnimation(Index);
	return;
}

function StartRotation(bool isRight)
{
	m_ObjectViewport.StartRotation(isRight);
	return;
}

function EndRotation()
{
	m_ObjectViewport.EndRotation();
	return;
}

function SetNPCInfo(int Index)
{
	m_ObjectViewport.SetNPCInfo(Index);
	return;
}

function StartZoom(bool isZoomOut)
{
	m_ObjectViewport.StartZoom(isZoomOut);
	return;
}

function EndZoom()
{
	m_ObjectViewport.EndZoom();
	return;
}

function SetCharacterScale(float Scale)
{
	m_ObjectViewport.SetCharacterScale(Scale);
	return;
}

function SetCharacterOffsetX(int Position)
{
	m_ObjectViewport.SetCharacterOffsetX(Position);
	return;
}

function SetCharacterOffsetY(int Position)
{
	m_ObjectViewport.SetCharacterOffsetY(Position);
	return;
}

function SetCharacterOffsetZ(int Position)
{
	m_ObjectViewport.SetCharacterOffsetZ(Position);
	return;
}

function SetCharacterOffset(int X, int Y, int Z)
{
	m_ObjectViewport.SetCharacterOffset(setVector(X, Y, Z));
	return;
}

function PlayAttackAnimation(int Index)
{
	m_ObjectViewport.PlayAttackAnimation(Index);
	return;
}

function AutoAttacking(bool isAutoAttack)
{
	m_ObjectViewport.AutoAttacking(isAutoAttack);
	return;
}

function ShowNPC(float Duration)
{
	m_ObjectViewport.ShowNPC(Duration);
	return;
}

function HideNPC(float Duration)
{
	m_ObjectViewport.HideNPC(Duration);
	return;
}

function SetDragRotationRate(int Rate)
{
	m_ObjectViewport.SetDragRotationRate(Rate);
	return;
}

function SetCurrentRotation(int Rotation)
{
	m_ObjectViewport.SetCurrentRotation(Rotation);
	return;
}

function SetCameraDistance(int Distance)
{
	m_ObjectViewport.SetCameraDistance(Distance);
	return;
}

function SetSpawnDuration(float Duration)
{
	m_ObjectViewport.SetSpawnDuration(Duration);
	return;
}

function SetUISound(bool IsSound)
{
	m_ObjectViewport.SetUISound(IsSound);
	return;
}

function OnCallUCFunction(string functionName, string param)
{
	switch(functionName)
	{
		case "SpawnEffect":
			SpawnEffect(param);
			break;
		case "SpawnNPC":
			SpawnNPC();
			break;
		case "PlayAnimation":
			PlayAnimation(int(param));
			break;
		case "StartRotation":
			StartRotation(bool(param));
			break;
		case "EndRotation":
			EndRotation();
			break;
		case "StartZoom":
			StartZoom(bool(param));
			break;
		case "EndZoom":
			EndZoom();
			break;
		case "SetCharacterScale":
			SetCharacterScale(float(param));
			break;
		case "SetCharacterOffsetX":
			SetCharacterOffsetX(int(param));
			break;
		case "SetCharacterOffsetY":
			SetCharacterOffsetY(int(param));
			break;
		case "SetCharacterOffsetZ":
			SetCharacterOffsetZ(int(param));
			break;
		case "SetCharacterOffset":
			handleSetCharacterOffset(param);
			break;
		case "PlayAttackAnimation":
			PlayAttackAnimation(int(param));
			break;
		case "AutoAttacking":
			AutoAttacking(bool(param));
			break;
		case "ShowNPC":
			ShowNPC(float(param));
			break;
		case "HideNPC":
			HideNPC(float(param));
			break;
		case "SetNPCInfo":
			SetNPCInfo(int(param));
			break;
		case "SetDragRotationRate":
			SetDragRotationRate(int(param));
			break;
		case "SetCurrentRotation":
			SetCurrentRotation(int(param));
			break;
		case "SetCameraDistance":
			SetCameraDistance(int(param));
			break;
		case "SetSpawnDuration":
			SetSpawnDuration(float(param));
			break;
		case "SetUISound":
			SetUISound(bool(param));
			break;
		default:
			break;
	}
	return;
}

function handleSetCharacterOffset(string param)
{
	local int X, Y, Z;

	ParseInt(param, "x", X);
	ParseInt(param, "y", Y);
	ParseInt(param, "z", Z);
	SetCharacterOffset(X, Y, Z);
	return;
}

defaultproperties
{
	m_Windowname="ViewPortWndBase"
}
