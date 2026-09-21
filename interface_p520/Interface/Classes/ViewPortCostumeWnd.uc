class ViewPortCostumeWnd extends ViewPortWndBase;

var CharacterViewportWindowHandle m_ObjectViewport;

function OnRegisterEvent()
{
	RegisterEvent(3810);
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 3810:
			HandleChangeCharacterPawn(param);
			break;
		default:
			break;
	}
	return;
}

function OnShow()
{
	Debug("--------- viewport OnShow");
	return;
}

function InitializeCOD()
{
	Me = GetWindowHandle(m_Windowname);
	m_ObjectViewport = GetCharacterViewportWindowHandle((m_Windowname $ ".EffectStageWnd.ObjectViewport"));
	m_ObjectViewport.SetSpawnDuration(0.2000000);
	m_ObjectViewport.SetDragRotationRate(300);
	Me.DisableWindow();
	return;
}

function HandleChangeCharacterPawn(string param)
{
	local int m_MeshType;

	Debug(("HandleChangeCharacterPawn" @ param));
	ParseInt(param, "MeshType", m_MeshType);
	switch(m_MeshType)
	{
		case 0:
			m_ObjectViewport.SetCharacterScale(0.9500000);
			m_ObjectViewport.SetCharacterOffsetX(-20);
			m_ObjectViewport.SetCharacterOffsetY(-5);
			break;
		case 1:
			m_ObjectViewport.SetCharacterScale(0.9500000);
			m_ObjectViewport.SetCharacterOffsetX(-30);
			m_ObjectViewport.SetCharacterOffsetY(-6);
			break;
		case 8:
			m_ObjectViewport.SetCharacterScale(1.0000000);
			m_ObjectViewport.SetCharacterOffsetX(-20);
			m_ObjectViewport.SetCharacterOffsetY(-7);
			break;
		case 9:
			m_ObjectViewport.SetCharacterScale(1.0000000);
			m_ObjectViewport.SetCharacterOffsetX(-21);
			m_ObjectViewport.SetCharacterOffsetY(-7);
			break;
		case 6:
			m_ObjectViewport.SetCharacterScale(0.9400000);
			m_ObjectViewport.SetCharacterOffsetX(-20);
			m_ObjectViewport.SetCharacterOffsetY(-6);
			break;
		case 7:
			m_ObjectViewport.SetCharacterScale(0.9600000);
			m_ObjectViewport.SetCharacterOffsetX(-35);
			m_ObjectViewport.SetCharacterOffsetY(-7);
			break;
			m_ObjectViewport.SetCharacterScale(0.9400000);
			m_ObjectViewport.SetCharacterOffsetX(-20);
			m_ObjectViewport.SetCharacterOffsetY(-6);
			m_ObjectViewport.SetCharacterScale(0.9600000);
			m_ObjectViewport.SetCharacterOffsetX(-35);
			m_ObjectViewport.SetCharacterOffsetY(-7);
		case 2:
			m_ObjectViewport.SetCharacterScale(0.9700000);
			m_ObjectViewport.SetCharacterOffsetX(-10);
			m_ObjectViewport.SetCharacterOffsetY(-6);
			break;
		case 3:
			m_ObjectViewport.SetCharacterScale(0.9600000);
			m_ObjectViewport.SetCharacterOffsetX(-20);
			m_ObjectViewport.SetCharacterOffsetY(-6);
			break;
			m_ObjectViewport.SetCharacterScale(0.9700000);
			m_ObjectViewport.SetCharacterOffsetX(-10);
			m_ObjectViewport.SetCharacterOffsetY(-6);
			m_ObjectViewport.SetCharacterScale(0.9600000);
			m_ObjectViewport.SetCharacterOffsetX(-20);
			m_ObjectViewport.SetCharacterOffsetY(-6);
		case 10:
			m_ObjectViewport.SetCharacterScale(0.9300000);
			m_ObjectViewport.SetCharacterOffsetX(-10);
			m_ObjectViewport.SetCharacterOffsetY(-7);
			break;
		case 11:
			m_ObjectViewport.SetCharacterScale(0.9300000);
			m_ObjectViewport.SetCharacterOffsetX(-20);
			m_ObjectViewport.SetCharacterOffsetY(-7);
			break;
		case 12:
			m_ObjectViewport.SetCharacterScale(0.9300000);
			m_ObjectViewport.SetCharacterOffsetX(-20);
			m_ObjectViewport.SetCharacterOffsetY(-7);
			break;
		case 13:
			m_ObjectViewport.SetCharacterScale(0.9100000);
			m_ObjectViewport.SetCharacterOffsetX(-30);
			m_ObjectViewport.SetCharacterOffsetY(-7);
			break;
		case 4:
			m_ObjectViewport.SetCharacterScale(0.9900000);
			m_ObjectViewport.SetCharacterOffsetX(-10);
			m_ObjectViewport.SetCharacterOffsetY(0);
			break;
		case 5:
			m_ObjectViewport.SetCharacterScale(1.0000000);
			m_ObjectViewport.SetCharacterOffsetX(-30);
			m_ObjectViewport.SetCharacterOffsetY(-5);
			break;
		case 14:
			m_ObjectViewport.SetCharacterScale(0.9300000);
			m_ObjectViewport.SetCharacterOffsetX(-25);
			m_ObjectViewport.SetCharacterOffsetY(-5);
			break;
		case 15:
			m_ObjectViewport.SetCharacterScale(1.0100000);
			m_ObjectViewport.SetCharacterOffsetX(0);
			m_ObjectViewport.SetCharacterOffsetY(-3);
			break;
		case 17:
			m_ObjectViewport.SetCharacterScale(1.0150000);
			m_ObjectViewport.SetCharacterOffsetX(-1);
			m_ObjectViewport.SetCharacterOffsetY(14);
			break;
		default:
			break;
	}
	return;
}

function OnCallUCFunction(string functionName, string param)
{
	switch(functionName)
	{
		case "SpawnEffect":
			m_ObjectViewport.SpawnEffect(param);
			break;
		case "SpawnNPC":
			m_ObjectViewport.SpawnNPC();
			break;
		case "changeMonsterAnimation":
			m_ObjectViewport.PlayAnimation(int(param));
			break;
		case "StartRotation":
			m_ObjectViewport.StartRotation(bool(param));
			break;
		case "EndRotation":
			m_ObjectViewport.EndRotation();
			break;
		case "StartZoom":
			m_ObjectViewport.StartZoom(bool(param));
			break;
		case "EndZoom":
			m_ObjectViewport.EndZoom();
			break;
		case "SetCharacterScale":
			m_ObjectViewport.SetCharacterScale(float(param));
			break;
		case "SetCharacterOffsetX":
			m_ObjectViewport.SetCharacterOffsetX(int(param));
			break;
		case "SetCharacterOffsetY":
			m_ObjectViewport.SetCharacterOffsetY(int(param));
			break;
		case "PlayAttackAnimation":
			m_ObjectViewport.PlayAttackAnimation(int(param));
			break;
		case "AutoAttacking":
			m_ObjectViewport.AutoAttacking(bool(param));
			break;
		case "ShowNPC":
			m_ObjectViewport.ShowNPC(float(param));
			break;
		case "HideNPC":
			m_ObjectViewport.HideNPC(float(param));
			break;
		case "SetNPCInfo":
			m_ObjectViewport.SetNPCInfo(int(param));
			break;
		case "SetDragRotationRate":
			m_ObjectViewport.SetDragRotationRate(int(param));
			break;
		case "SetCurrentRotation":
			m_ObjectViewport.SetCurrentRotation(int(param));
			break;
		case "SetCameraDistance":
			m_ObjectViewport.SetCameraDistance(int(param));
			break;
		case "SetSpawnDuration":
			m_ObjectViewport.SetSpawnDuration(float(param));
			break;
		case "SpawnNPC":
			m_ObjectViewport.SpawnNPC();
			break;
		case "ApplyPreviewCostumeItem":
			Debug(("ApplyPreviewCostumeItem" @ param));
			m_ObjectViewport.ApplyPreviewCostumeItem(int(param));
			break;
		case "SetBackgroundTex":
			m_ObjectViewport.SetBackgroundTex(param);
			break;
		default:
			break;
	}
	Me.BringToFront();
	return;
}
