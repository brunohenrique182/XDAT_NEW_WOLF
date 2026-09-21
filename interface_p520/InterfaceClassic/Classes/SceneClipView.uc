class SceneClipView extends L2UIGFxScript;

const CAPTION_FONTSIZE = 10;
const CAPTION_ADDPOSY = -5;
const TYPE_SERVER_FIRST = 0;
const TYPE_SERVER_CLASSIC = 1;
const TYPE_SERVER_LIVE = 2;
const TYPE_SERVER_ARENA = 3;
const TYPE_SERVER_BLOOD = 4;
const TYPE_SERVER_ADEN = 5;
const MOVIEID_GACHA_URSR = 100002;
const MOVIEID_GACHA_R = 100003;
const MOVIEID_GACHA_GET_UR = 100004;

var int MovieID;
var int currentScreenWidth;
var int currentScreenHeight;
var int audioVolume;
var bool bIsBuilderPC;

function OnRegisterEvent()
{
	RegisterGFxEvent(5620);
	RegisterGFxEvent(5623);
	RegisterGFxEvent(5621);
	RegisterGFxEvent(5624);
	RegisterGFxEvent(5720);
	RegisterGFxEventForLoaded(2900);
	RegisterEvent(3410);
	RegisterEvent(5720);
	RegisterEvent(5622);
	return;
}

function OnLoad()
{
	RegisterState("SceneClipView", "GamingState");
	SetHavingFocus(false);
	return;
}

function setSceneClipMode(bool bFullScreen)
{
	if(bFullScreen)
	{
		SetAlwaysOnTop(true);
		SetRenderOnTop(true);
	}
	else
	{
		SetAlwaysOnTop(false);
		SetRenderOnTop(false);
	}
	return;
}

function OnFlashLoaded()
{
	SetAnchor("", ANCHORPOINT_TopLeft, ANCHORPOINT_TopLeft, 0, 0);
	return;
}

function OnShow()
{
	return;
}

function OnHide()
{
	return;
}

function loginBGMovie()
{
	local string param, usmPath;
	local int currentScreenWidth, currentScreenHeight, nLoginMapType;

	nLoginMapType = GetLoginMapType();
	if((IsActivateUSMBackground(nLoginMapType) == false))
	{
		return;
	}
	setSceneClipMode(false);
	GetCurrentResolution(currentScreenWidth, currentScreenHeight);
	ParamAdd(param, "PosY", "0");
	ParamAdd(param, "PosY", "0");
	ParamAdd(param, "SkinType", "2");
	ParamAdd(param, "SkipButtonType", "0");
	ParamAdd(param, "Width", string(currentScreenWidth));
	ParamAdd(param, "Height", string(currentScreenHeight));
	switch(nLoginMapType)
	{
		case 0:
		case 2:
		case 4:
			usmPath = "login.usm";
			break;
		case 1:
		case 5:
			usmPath = "login_classic.usm";
			break;
		default:
			usmPath = "login.usm";
			break;
	}
	ParamAdd(param, "FileName", usmPath);
	ParamAdd(param, "MovieID", "0");
	ParamAdd(param, "targetAnchorPointType", "centerCenter");
	ParamAdd(param, "clipAnchorPointType", "centerCenter");
	ExecuteEvent(5620, param);
	SetAlwaysOnBack(true);
	ContainerHUD(GetScript("ContainerHUD")).SetAlwaysOnBack(true);
	return;
}

function ciMovie()
{
	local string param;
	local int currentScreenWidth, currentScreenHeight;

	setSceneClipMode(false);
	GetCurrentResolution(currentScreenWidth, currentScreenHeight);
	ParamAdd(param, "PosX", "0");
	ParamAdd(param, "PosY", "0");
	ParamAdd(param, "SkinType", "3");
	ParamAdd(param, "SkipButtonType", "0");
	ParamAdd(param, "Width", string(currentScreenWidth));
	ParamAdd(param, "Height", string(currentScreenHeight));
	if(IsTencentLoginSystem())
	{
		ParamAdd(param, "FileName", "intro_cn.usm");
	}
	else if(IsCmdLineLogin())
	{
		if((int(GetLanguage()) == 8))
		{
			ParamAdd(param, "FileName", "intro_ru.usm");
		}
		else
		{
			ParamAdd(param, "FileName", "intro_eu.usm");
		}
	}
	else
	{
		ParamAdd(param, "FileName", "intro.usm");
	}
	ParamAdd(param, "MovieID", "0");
	ParamAdd(param, "targetAnchorPointType", "centerCenter");
	ParamAdd(param, "clipAnchorPointType", "centerCenter");
	ExecuteEvent(5620, param);
	SetAlwaysOnBack(true);
	ContainerHUD(GetScript("ContainerHUD")).SetAlwaysOnBack(true);
	return;
}

function OnCallUCFunction(string logicID, string statusStr)
{
	local int MovieID;

	MovieID = int(logicID);
	Debug(("실행     :" @ string(MovieID)));  // EN?: Execute
	Debug(("statusStr:" @ statusStr));
	if((statusStr == "start"))
	{
		Debug(("영상 시작 - MovieID:" @ string(MovieID)));  // EN: video start - MovieID:
		if((MovieID > 100000))
		{
			setSceneClipMode(true);
		}
		else
		{
			setSceneClipMode(false);
		}
	}
	else if((statusStr == "finish"))
	{
		Debug(("영상 끝 - MovieID:" @ string(MovieID)));  // EN: video end - MovieID:
		if((MovieID > 100000))
		{
			if((100002 == MovieID))
			{
				UniqueGacha(GetScript("UniqueGacha")).setShowStep(3);
			}
			else if((100003 == MovieID))
			{
				UniqueGacha(GetScript("UniqueGacha")).setShowStep(3);
			}
			else if((100004 == MovieID))
			{
				UniqueGacha(GetScript("UniqueGacha")).setShowStep(4);
			}
		}
		else
		{
			FlashMoviePlayEnd(MovieID);
		}
		HideWindow();
		if((GetGameStateName() == "INTROSTATE"))
		{
			if(IsTencentLoginSystem())
			{
				LoginWaitState();
			}
			else
			{
				StartLoginState();
			}
		}
	}
	else if((statusStr == "fullScreenStart"))
	{
		setSceneClipMode(true);
		FullScreenMovieStart();
	}
	else if((statusStr == "fullScreenFinish"))
	{
		FullScreenMovieEnd();
		onMovieEnd();
		HideWindow();
	}
	if((logicID == "IsBuilderPC"))
	{
		bIsBuilderPC = IsBuilderPC();
	}
	else if((logicID == "soundUpdate"))
	{
		audioVolume = getAudioVolume();
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	local int MovieID;

	if((Event_ID == 5622))
	{
		ParseInt(param, "MovieID", MovieID);
		if((MovieID >= 0))
		{
			ShowWindow();
			FlashMoviePlayStart(MovieID);
		}
		else
		{
			Debug("Error: Wrong MovieID ");
		}
		audioVolume = getAudioVolume();
	}
	else if((Event_ID == 3410))
	{
		Debug(("EV_StateChanged" @ param));
		if((param == "INTROSTATE"))
		{
			ciMovie();
		}
		else
		{
			useBackgroundUsm(param);
		}
	}
	else if((Event_ID == 19))
	{
		customPlayUsm(0, 0, 400, 300, 1, 1, "awake7.usm", 10001, "UIPowerToolWnd");
	}
	return;
}

function customPlayUsm(int posX, int posY, int nWidth, int nHeight, int skinType, int skipButtonType, string usmPath, int nMovieID, optional string anchorWindow)
{
	local string param;
	local Rect Rect;

	ParamAdd(param, "SkinType", string(skinType));
	ParamAdd(param, "SkipButtonType", string(skipButtonType));
	ParamAdd(param, "FileName", usmPath);
	ParamAdd(param, "MovieID", string(nMovieID));
	ParamAdd(param, "targetAnchorPointType", "topleft");
	ParamAdd(param, "clipAnchorPointType", "topleft");
	ParamAdd(param, "Width", string(nWidth));
	ParamAdd(param, "Height", string(nHeight));
	if((anchorWindow != ""))
	{
		Rect = GetWindowHandle(anchorWindow).GetRect();
		ParamAdd(param, "PosX", string((Rect.nX + posX)));
		ParamAdd(param, "PosY", string((Rect.nY + posY)));
	}
	else
	{
		ParamAdd(param, "PosX", string(posX));
		ParamAdd(param, "PosY", string(posY));
	}
	SetHavingFocus(true);
	SetAlwaysOnBack(false);
	setSceneClipMode(true);
	ExecuteEvent(5620, param);
	Debug(("EV_ShowSceneClipView" @ param));
	return;
}

function useBackgroundUsm(string param)
{
	Debug(("param" @ param));
	if(((((param == "SERVERLISTSTATE") || (param == "EULAMSGSTATE")) || (param == "LOGINSTATE")) || (param == "LOGINWAITSTATE")))
	{
		loginBGMovie();
	}
	else if(((param == "CHARACTERSELECTSTATE") || (param == "EDITORSTATE")))
	{
		ExecuteEvent(5621, "");
	}
	return;
}

function onMovieEnd()
{
	local GfxDialog GfxDialogScript;

	GfxDialogScript = GfxDialog(GetScript("GfxDialog"));
	GfxDialogScript.onMovieEnd();
	return;
}

function int getAudioVolume()
{
	local float fMusicVolume, fSoundVolume, fEffectVolume, fAmbientVolume, fSystemVoiceVolume, fNpcVoiceVolume, fMaxVolume;

	if((GetOptionInt("Audio", "MODE") == 2))
	{
		return 0;
	}
	fMusicVolume = GetOptionFloat("Audio", "MusicVolume");
	fEffectVolume = GetOptionFloat("Audio", "EffectVolume");
	fAmbientVolume = GetOptionFloat("Audio", "AmbientVolume");
	fSystemVoiceVolume = GetOptionFloat("Audio", "SystemVoiceVolume");
	fNpcVoiceVolume = GetOptionFloat("Audio", "NpcVoiceVolume");
	fSoundVolume = GetOptionFloat("Audio", "SoundVolume");
	fMaxVolume = FMax(fMusicVolume, fEffectVolume);
	fMaxVolume = FMax(fMaxVolume, fAmbientVolume);
	fMaxVolume = FMax(fMaxVolume, fSystemVoiceVolume);
	fMaxVolume = FMax(fMaxVolume, fNpcVoiceVolume);
	return int(((fMaxVolume * fSoundVolume) * 100.0000000));
}
