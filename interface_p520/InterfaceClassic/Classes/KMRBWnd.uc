class KMRBWnd extends UICommonAPI;

const StartTimerID = 1234;
const FadeTimerID = 1235;

var TextureHandle ageLimitDscrp_Tex;
var TextureHandle ageLimit_Tex;
var WindowHandle Me;

function OnRegisterEvent()
{
	RegisterEvent(2900);
	return;
}

function OnLoad()
{
	Me = GetWindowHandle("KMRBWnd");
	ageLimitDscrp_Tex = GetTextureHandle("KMRBWnd.ageLimitDscrp_Tex");
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	if((a_EventID == 2900))
	{
		CheckResolution();
	}
	return;
}

function StartLoginStateFunc()
{
	Me.KillTimer(1234);
	StartLoginState();
	return;
}

event OnShow()
{
	CheckResolution();
	Me.KillTimer(1234);
	Me.KillTimer(1235);
	Me.SetTimer(1234, 4000);
	Me.SetTimer(1235, 3000);
	Me.SetFocus();
	Me.SetAlpha(255);
	return;
}

event OnTimer(int TimerID)
{
	if((TimerID == 1234))
	{
		StartLoginStateFunc();
	}
	else if((TimerID == 1235))
	{
		Me.SetAlpha(0, 1.0000000);
		Me.KillTimer(1235);
	}
	return;
}

function CheckResolution()
{
	local int CurrentMaxWidth, CurrentMaxHeight;

	GetCurrentResolution(CurrentMaxWidth, CurrentMaxHeight);
	ageLimitDscrp_Tex.SetAnchor("KMRBWnd", "CenterCenter", "CenterCenter", 0, 0);
	ageLimitDscrp_Tex.SetWindowSizeRel43(1.0000000, 1.0000000, 0, 0);
	return;
}

function float GetAbs(float Num)
{
	if((Num < 0.0000000))
	{
		return -Num;
	}
	return Num;
}
