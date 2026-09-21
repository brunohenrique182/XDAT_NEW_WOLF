class L2PassWndProgressComponent extends UICommonAPI;

var L2PassData _l2PassData;
var WindowHandle Me;
var TextureHandle gaugeBgTexture;
var StatusBarHandle pregressBar;

function Init(WindowHandle Owner)
{
	local string ownerFullPath;

	ownerFullPath = Owner.m_WindowNameWithFullPath;
	_l2PassData = new Class'Interface.L2PassData';
	Me = GetWindowHandle(ownerFullPath);
	gaugeBgTexture = GetTextureHandle((ownerFullPath $ ".GaugeStateBGSet_Texture"));
	pregressBar = GetStatusBarHandle((ownerFullPath $ ".Pass_StatusBar"));
	return;
}

function _SetProgressInfo(L2PassData.L2PassStepInfo Info)
{
	if((Info.rewardItemCnt == 0))
	{
		_SetDisable(true);
		return;
	}
	else
	{
		_SetDisable(false);
	}
	if((int(Info.stepState) == 1))
	{
		pregressBar.SetPointExpPercentRate((float(Info.missionCnt) / float(Info.missionMaxCnt)));
		ShowProgressDeco(Info.PassType, true);
	}
	else if((int(Info.stepState) == 0))
	{
		pregressBar.SetPointExpPercentRate(0.0000000);
		ShowProgressDeco(Info.PassType, false);
	}
	else
	{
		pregressBar.SetPointExpPercentRate(1.0000000);
		ShowProgressDeco(Info.PassType, true);
	}
	pregressBar.SetTooltipCustomType(MakeTooltipSimpleText(((string(Info.missionCnt) @ "/") @ string(Info.missionMaxCnt))));
	return;
}

function _SetDisable(bool IsDisable)
{
	if((IsDisable == true))
	{
		Me.HideWindow();
	}
	else
	{
		Me.ShowWindow();
	}
	return;
}

function ShowProgressDeco(L2PassData.EL2PassType PassType, bool isShow)
{
	local string texturePath;

	texturePath = "L2UI_NewTex.L2passWnd.";
	if((int(PassType) != 0))
	{
		return;
	}
	if((isShow == true))
	{
		gaugeBgTexture.SetTexture((texturePath $ "Gauge_ProgressBG"));
	}
	else
	{
		gaugeBgTexture.SetTexture((texturePath $ "Gauge_BasicBG"));
	}
	return;
}
