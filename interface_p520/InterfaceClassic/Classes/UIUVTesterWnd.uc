class UIUVTesterWnd extends UICommonAPI;

const UVGABX = 5;

var WindowHandle SteerTexBody;
var TextureHandle texture0;
var TextureHandle Texture1;
var TextureHandle SteerTex;
var TextureHandle MainBG_texAni00;
var TextureHandle SteerTexInner;
var TextureHandle EyeLTex;
var TextureHandle EyeRTex;
var TextBoxHandle secText;
var EditBoxHandle speedText;
var L2UITimerObject tObject;
var float nU;
var float nV;
var INT64 lastAppMilliSeconds;
var float Time;
var float Speed;
var TextureHandle NewWnd;

event OnRegisterEvent()
{
	RegisterEvent(150);
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	texture0 = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".texture0"));
	Texture1 = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".texture1"));
	SteerTex = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SteerTex"));
	SteerTexBody = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SteerTexBody"));
	SteerTexInner = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SteerTexBody.SteerTex"));
	MainBG_texAni00 = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".MainBG_texAni000"));
	secText = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".secText"));
	speedText = GetEditBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".speedText"));
	EyeLTex = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EyeLTex"));
	EyeRTex = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EyeRTex"));
	SetTextureStartSetting();
	return;
}

event OnClickButton(string btnName)
{
	switch(btnName)
	{
		case "ResetButton":
			nU = 0.0000000;
			nV = 0.0000000;
			Time = 0.0000000;
			break;
		default:
			break;
	}
	return;
}

event OnChangeEditBox(string strID)
{
	Speed = float(speedText.GetString());
	return;
}

function SetTextureStartSetting()
{
	texture0.SetTextureSize(50, 39);
	Texture1.SetTextureSize(200, 300);
	EyeLTex.SetTextureSize(16, 100);
	EyeRTex.SetTextureSize(16, 100);
	return;
}

function HandleOnTick()
{
	local float DeltaTime, deltaSpeed;

	DeltaTime = (float(GetDeltaMilliTime()) / 1000.0000000);
	lastAppMilliSeconds = GetAppMilliSeconds();
	(Time += DeltaTime);
	secText.SetText(string(Time));
	deltaSpeed = (DeltaTime * Speed);
	nU = (nU + deltaSpeed);
	nV = (nV + deltaSpeed);
	texture0.SetUV(int(nU), int(nV));
	Texture1.SetUV(int(nU), int(nV));
	Texture1.SetRotationAngle(nU);
	AlphaGroupUV(int(nU));
	return;
}

function AlphaGroupUV(int nU)
{
	local int i;
	local TextureHandle minBgTex;

	i = 0;
	while((i < 5))
	{
		minBgTex = GetTextureHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".MainBG_texAni00") $ string(i)));
		minBgTex.SetUV(((5 * -i) + nU), 0);
		(i < i++);
	}
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".MainBG_texAni000")).MoveC((400 + nU), 50);
	return;
}

event OnShow()
{
	tObject._Play();
	lastAppMilliSeconds = GetAppMilliSeconds();
	m_hOwnerWnd.EnableTick();
	return;
}

event OnHide()
{
	tObject._Stop();
	m_hOwnerWnd.DisableTick();
	return;
}

event OnTick()
{
	HandleOnTick();
	return;
}

event OnMouseMove(WindowHandle wHandle, int X, int Y)
{
	HandleSteerTex(X, Y);
	HandleSteerTexBody(X, Y);
	HandleEyeLTex(X, Y);
	HandleEyeRTex(X, Y);
	return;
}

function HandleSteerTex(int X, int Y)
{
	local Rect rectWnd;
	local int mX, mY;
	local float ang;

	rectWnd = SteerTex.GetRect();
	mX = ((X - rectWnd.nX) - (rectWnd.nWidth / 2));
	mY = ((Y - rectWnd.nY) - (rectWnd.nHeight / 2));
	ang = ((Atan(float(mX), float(-mY)) * 180.0000000) / 3.1415927);
	SteerTex.SetRotationAngle(ang);
	return;
}

function HandleSteerTexBody(int X, int Y)
{
	local Rect rectWnd;
	local int mX, mY;
	local float ang;

	rectWnd = SteerTexInner.GetRect();
	mX = ((X - rectWnd.nX) - (rectWnd.nWidth / 2));
	mY = ((Y - rectWnd.nY) - (rectWnd.nHeight / 2));
	ang = ((Atan(float(mX), float(-mY)) * 180.0000000) / 3.1415927);
	SteerTexBody.SetRotationAngle(ang);
	SteerTexInner.SetRotationAngle(ang);
	return;
}

function HandleEyeLTex(int X, int Y)
{
	local Rect rectWnd;
	local int mX, mY;
	local float ang;

	rectWnd = EyeLTex.GetRect();
	mX = ((X - rectWnd.nX) - (rectWnd.nWidth / 2));
	mY = ((Y - rectWnd.nY) - (rectWnd.nHeight / 2));
	ang = ((Atan(float(mX), float(-mY)) * 180.0000000) / 3.1415927);
	EyeLTex.SetRotationAngle(ang);
	EyeLTex.SetUV(0, Min(GetDistance(0, 0, mX, mY), 100));
	return;
}

function HandleEyeRTex(int X, int Y)
{
	local Rect rectWnd;
	local int mX, mY;
	local float ang;

	rectWnd = EyeRTex.GetRect();
	mX = ((X - rectWnd.nX) - (rectWnd.nWidth / 2));
	mY = ((Y - rectWnd.nY) - (rectWnd.nHeight / 2));
	ang = ((Atan(float(mX), float(-mY)) * 180.0000000) / 3.1415927);
	EyeLTex.SetTextureSize(64, 100);
	EyeRTex.SetTextureSize(64, 100);
	EyeRTex.SetUV(0, Min(GetDistance(0, 0, mX, mY), 100));
	EyeRTex.SetRotationAngle(ang);
	return;
}

function INT64 GetDeltaMilliTime()
{
	return (GetAppMilliSeconds() - lastAppMilliSeconds);
}

function API_GetClientCursorPos(out int X, out int Y)
{
	GetClientCursorPos(X, Y);
	return;
}

function int GetDistance(int x1, int y1, int x2, int y2)
{
	local int gabX, gabY;

	gabX = (x1 - x2);
	gabY = (y1 - y2);
	return int(Sqrt(float(((gabX * gabX) + (gabY * gabY)))));
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	m_hOwnerWnd.HideWindow();
	return;
}
