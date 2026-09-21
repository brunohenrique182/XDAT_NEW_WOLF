class SideBarVPWndWindowTooltip extends SideBarWndBase
	dependson(UIPacket);

const TIMER_ID_LIMIT = 5;
const TIMER_ID_LUCK = 6;

var string m_Windowname;
var WindowHandle Me;
var StatusBarHandle VpDetailBar;
var TextBoxHandle VPDetailGaugeMax_Txt;
var TextBoxHandle VPTitleTextBox;
var TextBoxHandle SayhasNum_Txt;
var TextBoxHandle SayhasMaxNum_TxT;
var int nVitalityBonus;
var int nVitalityExtraBonus;
var int nVitalityItemMaxRestoreCount;
var bool isAfterStatusNormaEvent;
var bool isVPApply;
var bool bNoticeVitalityZero;
var bool bNoticeUseVitalityItem;
var TextureHandle VpIcon;
var int VitalLimitEndTime;
var int VitalLuckyEndTime;
var int VitalLimitBonusExp;
var int VitalLimitBonusAdena;
var int nVitality;
var string sBonusString;
var string sExtraBonusString;
var WindowHandle RemainTime_Wnd;
var TextBoxHandle RemainTime_Txt;
var L2UITimerObject timeObject;

event OnRegisterEvent()
{
	RegisterEvent(180);
	RegisterEvent(4110);
	RegisterEvent(40);
	RegisterEvent(EV_PacketID(1166));
	return;
}

event OnLoad()
{
	InitSideBarWndDefaultOnLoad();
	Me = GetWindowHandle(m_Windowname);
	VpDetailBar = GetStatusBarHandle((m_Windowname $ ".SideBarVPDetailBar_StatusBar"));
	VPDetailGaugeMax_Txt = GetTextBoxHandle((m_Windowname $ ".SideBarVPDetailGaugeMax_Txt"));
	VPTitleTextBox = GetTextBoxHandle((m_Windowname $ ".SideBarVPTitle_Txt"));
	SayhasNum_Txt = GetTextBoxHandle((m_Windowname $ ".SayhasNum_Txt"));
	SayhasMaxNum_TxT = GetTextBoxHandle((m_Windowname $ ".SayhasMaxNum_TxT"));
	VpIcon = GetTextureHandle((m_Windowname $ ".SideBarVPIcon_Tex"));
	RemainTime_Wnd = GetWindowHandle((m_Windowname $ ".RemainTime_Wnd"));
	RemainTime_Txt = GetTextBoxHandle((m_Windowname $ ".RemainTime_Wnd.RemainTime_Txt"));
	return;
}

function InitTimerObject()
{
	timeObject = Class'InterfaceClassic.L2UITimer'.static.Inst()._MakeTimerObject(1000, 60);
	timeObject._DelegateOnPlayStart = OnTimerStartFunc;
	timeObject._DelegateOnTime = OnTimeFunc;
	timeObject._DelegateOnEnd = OnTimeEndFunc;
	timeObject._Stop();
	return;
}

event OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 180:
			handleVPPoint();
			break;
		case 4110:
			if(getInstanceUIData().GetIsClassicServer())
			{
				HandleVitalityEffectInfo(a_Param);
			}
			break;
		case 40:
			bNoticeVitalityZero = false;
			bNoticeUseVitalityItem = false;
			break;
		case EV_PacketID(1166):
			RT_S_EX_VITALITY_KEEP_VITALPOINT_INFO();
			break;
		default:
			break;
	}
	return;
}

function RT_S_EX_VITALITY_KEEP_VITALPOINT_INFO()
{
	local UIPacket._S_EX_VITALITY_KEEP_VITALPOINT_INFO packet;

	return;
	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_VITALITY_KEEP_VITALPOINT_INFO(packet))
	{
		return;
	}
	SetEndDateTime(packet.nEndDatetime);
	return;
}

event OnShow()
{
	return;
}

function TestRemainTime()
{
	if((RemainTime_Wnd.GetAlpha() > 0))
	{
		SetEndDateTime(0);
	}
	else
	{
		SetEndDateTime((Class'InterfaceClassic.UIData'.static.Inst().GetCurrentRealLocalTimeSec() + Rand(70)));
	}
	return;
}

function SetEndDateTime(int endDateTime)
{
	Debug(("SetEndDateTime" @ string(endDateTime)));
	SetRemainTimer((endDateTime - Class'InterfaceClassic.UIData'.static.Inst().GetCurrentRealLocalTimeSec()));
	return;
}

function SetRemainTimer(int RemainTime)
{
	if((RemainTime > 0))
	{
		Debug((("SetRemainTimer" @ string(RemainTime)) @ "이 0보다 크다"));  // EN?: is greater than zero
		timeObject._maxCount = RemainTime;
		timeObject._Reset();
	}
	else
	{
		Debug((("SetRemainTimer" @ string(RemainTime)) @ "이 0보다 작다 종료 해라."));  // EN?: This is less than zero. Exit.
		OnTimeEndFunc();
	}
	return;
}

function OnTimerStartFunc()
{
	RemainTime_Wnd.ShowWindow();
	RemainTime_Wnd.SetAlpha(0);
	RemainTime_Wnd.SetAlpha(255, 0.5000000);
	OnTimeFunc(0);
	SetActiveGreenIcons();
	return;
}

function OnTimeEndFunc()
{
	RemainTime_Wnd.SetAlpha(0, 0.5000000);
	timeObject._Stop();
	timeObject._maxCount = 0;
	SetLimit();
	return;
}

function OnTimeFunc(int curCount)
{
	RemainTime_Txt.SetText(Class'InterfaceClassic.L2Util'.static.Inst().getTimeStringBySec3((timeObject._maxCount - curCount)));
	return;
}

function handleVPPoint()
{
	local UserInfo UserInfo;
	local int MaxVitality;

	MaxVitality = GetMaxVitality();
	if(GetPlayerInfo(UserInfo))
	{
		nVitality = UserInfo.nVitality;
		SetLimit();
		if((nVitality == 0))
		{
			VPDetailGaugeMax_Txt.SetText("0%");
			VPTitleTextBox.SetText(GetSystemString(2492));
		}
		else if((nVitality == MaxVitality))
		{
			VPDetailGaugeMax_Txt.SetText(GetSystemString(3451));
			VPTitleTextBox.SetText(GetSystemString(2492));
		}
		else
		{
			VPDetailGaugeMax_Txt.SetText((ConvertFloatToString(((float(nVitality) / float(MaxVitality)) * 100.0000000), 0, false) $ "%"));
			VPTitleTextBox.SetText(GetSystemString(2492));
		}
		SayhasNum_Txt.SetText(MakeCostString(string(nVitality)));
		SayhasMaxNum_TxT.SetText((("/" @ MakeCostString(string(GetMaxVitality()))) $ " (MAX)"));
		ChkVpPointAlarm();
		VpDetailBar.SetPoint(INT64(nVitality), INT64(MaxVitality));
		SideBarScript.SetPointByIndex(TYPE_VP, nVitality, MaxVitality);
	}
	return;
}

function ChkVpPointAlarm()
{
	local INT64 MaxValue, CurValue;

	if((nVitality > 0))
	{
		return;
	}
	VpDetailBar.GetPoint(CurValue, MaxValue);
	if((CurValue > INT64(0)))
	{
		API_PlayIndexedNotifySound();
	}
	return;
}

function HandleVitalityEffectInfo(string param)
{
	local int nVitalityItemRestoreCount;
	local string sSysMsgParamString;

	ParseInt(param, "vitalityPoint", nVitality);
	ParseInt(param, "vitalityBonus", nVitalityBonus);
	ParseInt(param, "restoreCount", nVitalityItemRestoreCount);
	ParseInt(param, "maxRestoreCount", nVitalityItemMaxRestoreCount);
	SetLimit();
	ParseInt(param, "vitalityExtraBonus", nVitalityExtraBonus);
	sBonusString = (string(nVitalityBonus) $ "%");
	if((nVitalityExtraBonus > 0))
	{
		sExtraBonusString = ((" +" $ string(nVitalityExtraBonus)) $ "%");
	}
	if(((nVitality <= 0) && (bNoticeVitalityZero == false)))
	{
		ParamAdd(sSysMsgParamString, "Type", string(1));
		ParamAdd(sSysMsgParamString, "param1", string(nVitalityItemMaxRestoreCount));
		AddSystemMessageParam(sSysMsgParamString);
		if((getInstanceUIData().GetIsLiveServer() && ((int(GetLanguage()) == 8) || (int(GetLanguage()) == 9))))
		{
			AddSystemMessageString(EndSystemMessageParam(6841, true));
		}
		else
		{
			AddSystemMessageString(EndSystemMessageParam(6068, true));
		}
		bNoticeVitalityZero = true;
	}
	else if(((nVitality > 0) && (bNoticeUseVitalityItem == false)))
	{
		bNoticeUseVitalityItem = true;
	}
	MakeTooltip();
	return;
}

function MakeTooltip()
{
	local CustomTooltip t;
	local L2Util util;

	util = L2Util(GetScript("L2Util"));
	util.setCustomTooltip(t);
	util.ToopTipInsertText((GetSystemString(14187) $ " "), true, true);
	if((nVitality <= 0))
	{
		util.ToopTipInsertText(GetSystemString(2496), true, false, COLOR_GRAY);
		util.ToopTipInsertText(", ", true, false);
		bNoticeUseVitalityItem = false;
	}
	else
	{
		util.ToopTipInsertText(sBonusString, true, false);
		util.ToopTipInsertText(sExtraBonusString, true, false, COLOR_YELLOW03);
		bNoticeVitalityZero = false;
	}
	if((int(GetLanguage()) != 0))
	{
		util.ToopTipMinWidth(300);
		util.ToopTipInsertText(GetSystemString(5926), true, true);
		if((VitalLimitEndTime > 0))
		{
			util.ToopTipInsertText(string(VitalLimitEndTime), true, false);
			ParamAdd(util.tooltipText.DrawList[(util.tooltipText.DrawList.Length - 1)].Condition, "Type", "VitalTimeLimit");
		}
		else
		{
			util.ToopTipInsertText(GetSystemString(2496), true, false, COLOR_GRAY);
		}
		util.ToopTipInsertText(MakeFullSystemMsg(GetSystemMessage(6872), string(VitalLimitBonusExp), string(VitalLimitBonusAdena)), false, true);
		util.ToopTipInsertText(GetSystemString(5927), true, true);
		if((VitalLuckyEndTime > 0))
		{
			util.ToopTipInsertText(string(VitalLuckyEndTime), true, false);
			ParamAdd(util.tooltipText.DrawList[(util.tooltipText.DrawList.Length - 1)].Condition, "Type", "VitalTimeLucky");
		}
		else
		{
			util.ToopTipInsertText(GetSystemString(2496), true, false, COLOR_GRAY);
		}
	}
	VpDetailBar.SetTooltipCustomType(util.getCustomToolTip());
	return;
}

event OnEnterState(name a_CurrentStateName)
{
	isAfterStatusNormaEvent = false;
	return;
}

event OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case 5:
			VitalLimitEndTime = 0;
			Me.KillTimer(5);
			MakeTooltip();
			break;
		case 6:
			VitalLuckyEndTime = 0;
			Me.KillTimer(6);
			MakeTooltip();
			SetLuck();
			break;
		default:
			break;
	}
	return;
}

function SetLimit()
{
	local StatusRoundHandle statusBarRound;
	local TextureHandle mainIconTexture;
	local bool isOn, IsActive;

	isOn = (VitalLimitEndTime > 0);
	IsActive = ((isOn && (nVitality == 0)) || (timeObject._maxCount > 0));
	statusBarRound = SideBarScript.GetStatusBarByIndex(0);
	mainIconTexture = SideBarScript.GetMainIconByIndex(0);
	Me.KillTimer(5);
	if(isOn)
	{
		GetTextureHandle((m_Windowname $ ".CTextureCtrl939")).SetTexture("L2UI_NewTex.SideBar.SideBar_Drawer_Gold_Bg");
		statusBarRound.SetGaugeTexture(0, "L2UI_NewTex.SideBar.SideBar_GreenSlot_BgCircle");
		VpDetailBar.SetGaugeTexture(0, "L2UI_NewTex.Gauge.Gauge_DF_VP_Left");
		VpDetailBar.SetGaugeTexture(1, "L2UI_NewTex.Gauge.Gauge_DF_VP_Center");
		VpDetailBar.SetGaugeTexture(2, "L2UI_NewTex.Gauge.Gauge_DF_VP_Right");
		if((VitalLimitEndTime < 604800))
		{
			Me.SetTimer(5, (VitalLimitEndTime * 1000));
		}
	}
	else
	{
		GetTextureHandle((m_Windowname $ ".CTextureCtrl939")).SetTexture("L2UI_NewTex.SideBar.SideBar_Drawer_Bg");
		statusBarRound.SetGaugeTexture(0, "L2UI_NewTex.SideBar_Slot_BgCircle");
		VpDetailBar.SetGaugeTexture(0, "L2UI_CT1.Gauges.Gauge_DF_Large_CP_bg_Left");
		VpDetailBar.SetGaugeTexture(1, "L2UI_CT1.Gauges.Gauge_DF_Large_CP_bg_Center");
		VpDetailBar.SetGaugeTexture(2, "L2UI_CT1.Gauges.Gauge_DF_Large_CP_bg_Right");
	}
	if(IsActive)
	{
		SetActiveGreenIcons();
	}
	else
	{
		if((nVitality == 0))
		{
			SideBarScript.SetIconTexture(TYPE_VP, "L2UI_CT1.Icon.InfoWnd_VPIcon_dis");
		}
		else
		{
			mainIconTexture.SetTexture("L2UI_NewTex.SideBar.SideBar_VPIcon");
		}
		VpIcon.SetTexture("L2UI_NewTex.SideBar.SideBar_VPSmallIcon");
	}
	return;
}

function SetActiveGreenIcons()
{
	local TextureHandle mainIconTexture;

	mainIconTexture = SideBarScript.GetMainIconByIndex(0);
	mainIconTexture.SetTexture("L2UI_NewTex.SideBar.SideBar_VPGreenIcon");
	VpIcon.SetTexture("L2UI_NewTex.SideBar.SideBar_VPGreenSmallIcon");
	return;
}

function SetLuck()
{
	local AnimTextureHandle Anim;
	local bool isOn;

	isOn = (VitalLuckyEndTime > 0);
	Me.KillTimer(6);
	if((false && isOn))
	{
		Anim = SideBarScript.GetEffectAniTextureByIndex(0, 0);
		Anim.ShowWindow();
		Anim.Stop();
		Anim.SetLoopCount(1);
		Anim.Play();
		Me.SetTimer(6, (VitalLuckyEndTime * 1000));
	}
	else
	{
		Anim.Stop();
		Anim.HideWindow();
	}
	return;
}

function HandleVitalExInfo(string param)
{
	ParseInt(param, "VitalLimitEndTime", VitalLimitEndTime);
	ParseInt(param, "VitalLuckyEndTime", VitalLuckyEndTime);
	ParseInt(param, "VitalLimitBonusExp", VitalLimitBonusExp);
	ParseInt(param, "VitalLimitBonusAdena", VitalLimitBonusAdena);
	SetLimit();
	SetLuck();
	MakeTooltip();
	return;
}

function API_PlayIndexedNotifySound()
{
	local int NOTIFYMUTEFLAG, notifySoundIndex;

	notifySoundIndex = 5;
	NOTIFYMUTEFLAG = GetOptionInt("Audio", "NOTIFYMUTEFLAG");
	if(((NOTIFYMUTEFLAG & ExpInt(2, (notifySoundIndex - 1))) != 0))
	{
		return;
	}
	Class'NWindow.AudioAPI'.static.PlayIndexedNotifySound("13790", notifySoundIndex, true);
	return;
}

defaultproperties
{
	m_Windowname="SideBarVPWndWindowTooltip"
}
