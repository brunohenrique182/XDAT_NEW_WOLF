class AgeWnd extends UICommonAPI;

const TIMER_ID = 148;
const TIMER_DELAY = 5000;
const TIMER_ID2 = 149;
const TIMER_DELAY2 = 600000;

var WindowHandle Me;
var TextureHandle AgeTex;
var WindowHandle HelpHtmlWnd;
var string Texture15;
var string Texture18;
var string TextureFree;
var string HelpTexture15;
var string HelpTexture18;
var string HelpTextureFree;
var bool bBlock;

function OnRegisterEvent()
{
	RegisterEvent(170);
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
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	if((1 == 0))
	{
		Me = GetHandle("AgeWnd");
		AgeTex = TextureHandle(GetHandle("AgeWnd.AgeTex"));
	}
	else
	{
		Me = GetWindowHandle("AgeWnd");
		AgeTex = GetTextureHandle("AgeWnd.AgeTex");
	}
	bBlock = false;
	return;
}

function Load()
{
	Texture15 = "L2Font.Skins.kr_rated_15";
	Texture18 = "L2Font.Skins.kr_rated_19";
	TextureFree = "";
	HelpTexture15 = "L2Font.Skins.Help_Age_15";
	HelpTexture18 = "L2Font.Skins.Help_Age_19";
	HelpTextureFree = "";
	return;
}

function OnExitState(name a_CurrentStateName)
{
	if((a_CurrentStateName == 'LoadingState'))
	{
		if(!bBlock)
		{
			startAge();
		}
	}
	return;
}

function startAge()
{
	Me.ShowWindow();
	AgeTex.ShowWindow();
	Me.SetTimer(148, 5000);
	bBlock = true;
	Me.SetTimer(149, 600000);
	return;
}

function OnTimer(int TimerID)
{
	if((TimerID == 148))
	{
		Me.HideWindow();
		Me.KillTimer(148);
	}
	else if((TimerID == 149))
	{
		bBlock = false;
		Me.KillTimer(149);
	}
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	local int ServerAgeLimitInt;
	local UIEventManager.EServerAgeLimit ServerAgeLimit;
	local int GlobalVersion;

	if((a_EventID == 170))
	{
		ParseInt(a_Param, "ServerAgeLimit", ServerAgeLimitInt);
		ParseInt(a_Param, "GlobalVersion", GlobalVersion);
		if((GlobalVersion > 0))
		{
			bBlock = true;
			return;
		}
		ServerAgeLimit = EServerAgeLimit(ServerAgeLimitInt);
		switch(ServerAgeLimit)
		{
			case SERVER_AGE_LIMIT_15:
				AgeTex.SetTexture(Texture15);
				break;
			case SERVER_AGE_LIMIT_18:
				AgeTex.SetTexture(Texture18);
				break;
			case SERVER_AGE_LIMIT_Free:
			default:
				AgeTex.SetTexture(TextureFree);
				AgeTex.HideWindow();
				break;
		}
	}
	return;
}
