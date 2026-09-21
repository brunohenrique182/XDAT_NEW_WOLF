class MatchingInzoneTeambattle extends UICommonAPI;

const AITIMER_ID = 10;
const TIME_ID = 1013033;
const TIME_INTIME_DELAY = 2000;
const SPAWN_EFFECT = "LineageEffect2.ui_soul_crystal";

var int BAR_WSIZE;
var int BAR_HSIZE;
var WindowHandle Me;
var TextureHandle CenterLight;
var EffectViewportWndHandle CenterLightEffectViewportWnd;
var TextureHandle LeftTexture;
var TextureHandle RightTexture;
var TextBoxHandle RightTeamTextBox;
var TextBoxHandle LeftTeamTextBox;
var L2UITweenObject movingTObject;
var bool bInTime;
var bool bFirstRun;

function OnRegisterEvent()
{
	RegisterEvent(3410);
	RegisterEvent(40);
	RegisterEvent(3550);
	return;
}

function OnLoad()
{
	Initialize();
	Load();
	return;
}

function Initialize()
{
	local Rect barRect;

	Me = GetWindowHandle("MatchingInzoneTeambattle");
	CenterLight = GetTextureHandle("MatchingInzoneTeambattle.CenterLight");
	CenterLightEffectViewportWnd = GetEffectViewportWndHandle("MatchingInzoneTeambattle.CenterLightEffectViewportWnd");
	LeftTexture = GetTextureHandle("MatchingInzoneTeambattle.LeftTexture");
	RightTexture = GetTextureHandle("MatchingInzoneTeambattle.RightTexture");
	RightTeamTextBox = GetTextBoxHandle("MatchingInzoneTeambattle.RightTeamTextBox");
	LeftTeamTextBox = GetTextBoxHandle("MatchingInzoneTeambattle.LeftTeamTextBox");
	barRect = RightTexture.GetRect();
	BAR_WSIZE = barRect.nWidth;
	BAR_HSIZE = barRect.nHeight;
	return;
}

function Load()
{
	InitTweensObject();
	return;
}

function InitTweensObject()
{
	movingTObject = new Class'InterfaceClassic.L2UITweenObject';
	movingTObject.Owner = m_hOwnerWnd.m_WindowNameWithFullPath;
	movingTObject.Target = LeftTexture;
	movingTObject.Duration = 1000.0000000;
	movingTObject.ease = EASENONE;
	movingTObject._Stop();
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 3550:
			ParseAITimer(a_Param);
			break;
		case 40:
			hideInit();
			break;
		case 3410:
			ShowUI();
			break;
		default:
			break;
	}
	return;
}

function ParseAITimer(string param)
{
	local string Param1, Param2, param3, param4, param5, param6;
	local int EventID;

	ParseInt(param, "EventID", EventID);
	if((EventID == 10))
	{
		ParseString(param, "Param1", Param1);
		ParseString(param, "Param2", Param2);
		ParseString(param, "Param3", param3);
		ParseString(param, "Param4", param4);
		ParseString(param, "Param5", param5);
		ParseString(param, "Param6", param6);
		Debug(("EventID>>>>>>>" $ string(EventID)));
		Debug(("Param1>>>>>>>" $ Param1));
		Debug(("Param2>>>>>>>" $ Param2));
		Debug(("Param3>>>>>>>" $ param3));
		Debug(("Param4>>>>>>>" $ param4));
		Debug(("Param5>>>>>>>" $ param5));
		Debug(("Param6>>>>>>>" $ param6));
		setTeamBar(Param2, Param1, int(param6), int(param3));
	}
	else if((EventID == 1))
	{
		hideInit();
	}
	return;
}

function hideInit()
{
	bInTime = false;
	bFirstRun = false;
	movingTObject._Stop();
	Me.KillTimer(1013033);
	if(Me.IsShowWindow())
	{
		Me.HideWindow();
	}
	return;
}

function OnTimer(int TimerID)
{
	if((TimerID == 1013033))
	{
		hideInit();
	}
	return;
}

function ShowUI()
{
	if((GetGameStateName() != "GAMINGSTATE"))
	{
		return;
	}
	if(bInTime)
	{
		CenterLightEffectViewportWnd.SpawnEffect("LineageEffect2.ui_soul_crystal");
		Me.ShowWindow();
	}
	return;
}

function setTeamBar(string leftName, string rightName, int leftScore, int rightScore)
{
	local float teamBarOffset;
	local int beforeWidth;

	if((GetGameStateName() == "GAMINGSTATE"))
	{
		bInTime = true;
		if((bFirstRun == false))
		{
			movingTObject.Duration = 1.0000000;
			bFirstRun = true;
			CenterLightEffectViewportWnd.SpawnEffect("LineageEffect2.ui_soul_crystal");
		}
		else
		{
			movingTObject.Duration = 1000.0000000;
		}
		if((leftName == ""))
		{
			leftName = GetNpcString(1805966);
		}
		if((rightName == ""))
		{
			rightName = GetNpcString(1805965);
		}
		leftName = MakeFullSystemMsg(GetSystemMessage(14651), leftName);
		rightName = MakeFullSystemMsg(GetSystemMessage(14651), rightName);
		LeftTeamTextBox.SetText(leftName);
		RightTeamTextBox.SetText(rightName);
		beforeWidth = LeftTexture.GetRect().nWidth;
		teamBarOffset = (float(leftScore) / float((leftScore + rightScore)));
		movingTObject.SizeX = ((float(BAR_WSIZE) * teamBarOffset) - float(beforeWidth));
		movingTObject._Reset();
		Me.ShowWindow();
		Me.KillTimer(1013033);
		Me.SetTimer(1013033, 2000);
	}
	else
	{
		Me.HideWindow();
	}
	return;
}
