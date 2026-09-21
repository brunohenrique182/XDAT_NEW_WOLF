class GMDetailStatusWnd extends DetailStatusWnd;

var string temp1;
var bool bShow;
var UserInfo m_ObservingUserInfo;

function OnRegisterEvent()
{
	RegisterEvent(2290);
	RegisterEvent(4111);
	RegisterEvent(2404);
	return;
}

function OnLoad()
{
	temp1 = "Water/Air/Ground";
	InitializeCOD();
	Me.EnableWindow();
	initClassChangeButton(false);
	MaxVitality = GetMaxVitality();
	bShow = false;
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

function OnEnterState(name a_CurrentStateName)
{
	return;
}

function ShowStatus(string a_Param)
{
	if((a_Param == ""))
	{
		return;
	}
	if(bShow)
	{
		m_hOwnerWnd.HideWindow();
		bShow = false;
	}
	else
	{
		Class'NWindow.GMAPI'.static.RequestGMCommand(GMCOMMAND_StatusInfo, a_Param);
		bShow = true;
	}
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 2290:
			if(HandleGMObservingUserInfoUpdate())
			{
				m_hOwnerWnd.ShowWindow();
				m_hOwnerWnd.SetFocus();
			}
			break;
		case 4111:
			HandleVitalityEffectInfo(a_Param);
			break;
		case 2404:
			HandleGMUpdateHennaInfo(a_Param);
			break;
		default:
			break;
	}
	return;
}

function bool HandleGMObservingUserInfoUpdate()
{
	local UserInfo ObservingUserInfo;

	if(Class'NWindow.GMAPI'.static.GetObservingUserInfo(ObservingUserInfo))
	{
		HandleUpdateUserInfo();
		return true;
	}
	else
	{
		return false;
	}
}

function HandleGMUpdateHennaInfo(string a_Param)
{
	HandleUpdateHennaInfo(a_Param);
	HandleGMObservingUserInfoUpdate();
	return;
}

function bool GetMyUserInfo(out UserInfo a_MyUserInfo)
{
	local bool Result;

	Result = Class'NWindow.GMAPI'.static.GetObservingUserInfo(m_ObservingUserInfo);
	if(Result)
	{
		a_MyUserInfo = m_ObservingUserInfo;
		return true;
	}
	else
	{
		return false;
	}
}

function string GetMovingSpeed(UserInfo a_UserInfo)
{
	local int WaterMaxSpeed, WaterMinSpeed, AirMaxSpeed, AirMinSpeed, GroundMaxSpeed, GroundMinSpeed;
	local string MovingSpeed;

	WaterMaxSpeed = int((float(a_UserInfo.nWaterMaxSpeed) * a_UserInfo.fNonAttackSpeedModifier));
	WaterMinSpeed = int((float(a_UserInfo.nWaterMinSpeed) * a_UserInfo.fNonAttackSpeedModifier));
	AirMaxSpeed = int((float(a_UserInfo.nAirMaxSpeed) * a_UserInfo.fNonAttackSpeedModifier));
	AirMinSpeed = int((float(a_UserInfo.nAirMinSpeed) * a_UserInfo.fNonAttackSpeedModifier));
	GroundMaxSpeed = int((float(a_UserInfo.nGroundMaxSpeed) * a_UserInfo.fNonAttackSpeedModifier));
	GroundMinSpeed = int((float(a_UserInfo.nGroundMinSpeed) * a_UserInfo.fNonAttackSpeedModifier));
	MovingSpeed = ((string(WaterMaxSpeed) $ ",") $ string(WaterMinSpeed));
	MovingSpeed = ((((MovingSpeed $ "/") $ string(AirMaxSpeed)) $ ",") $ string(AirMinSpeed));
	MovingSpeed = ((((MovingSpeed $ "/") $ string(GroundMaxSpeed)) $ ",") $ string(GroundMinSpeed));
	return MovingSpeed;
}

function float GetMyExpRate()
{
	return (m_ObservingUserInfo.fExpPercentRate * 100.0000000);
}

defaultproperties
{
	m_Windowname="GMDetailStatusWnd"
}
