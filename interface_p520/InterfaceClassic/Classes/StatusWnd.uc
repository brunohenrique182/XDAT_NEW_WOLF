class StatusWnd extends UICommonAPI;

const TIMER_ID1 = 1310;
const TIMER_DELAY1 = 500;
const TIMER_ID2 = 1311;
const TIMER_DELAY2 = 20000;
const TIMER_PREM1 = 1312;
const TIMER_PREM_DELAY1 = 600;
const TIMER_PREM2 = 1313;
const TIMER_PREM_DELAY2 = 30000;
const ANIMMINALPHA = 39;
const ANIMMAXALPHA = 197;
const ANIMSPEEDFLOAT = 0.40f;
const ULTIMATE_SKILL_POINT_BOUNDARY_LEVEL1 = 500;
const ULTIMATE_SKILL_POINT_BOUNDARY_LEVEL2 = 1000;
const ULTIMATE_SKILL_POINT_BOUNDARY_LEVEL3 = 1500;
const WINDOW_MIN_SIZE_HEIGHT = 82;
const WINDOW_MAX_SIZE_HEIGHT = 102;
const WINDOW_CLASSIC_SIZE_HEIGHT = 68;
const TIMER_BAR = 1410;
const TIMER_BAR_DELAY = 400;
const POSX_MP = 86;
const POSY_MP2Line = 54;
const POSY_MP3Line = 46;
const OFFSETWIDTH = -109;

var int m_UserID;
var bool m_bReceivedUserInfo;
var int GlobalAlpha;
var bool GlobalAlphaBool;
var bool AnimTexKill;
var bool isAfterStatusNormaEvent;
var bool isVPApply;
var string m_Windowname;
var WindowHandle Me;
var StatusBarHandle CPBar;
var StatusBarHandle HPBar;
var StatusBarHandle MPBar;
var StatusBarHandle DPBar;
var StatusBarHandle BPBar;
var StatusBarHandle WPBar;
var NameCtrlHandle UserName;
var TextBoxHandle StatusWnd_LevelTextBox;
var StatusBarHandle VpDetailBar;
var BarHandle barFATIGUE;
var L2Util util;
var int MaxVitality;
var int nVitalityExtraBonus;
var int nVitalityBonus;
var int nVitalityItemMaxRestoreCount;
var bool AnimTexKillPremium;
var int m_CurPremiumState;
var bool m_AlphaIncrese;
var WindowHandle LevelBoxTexPremium;
var WindowHandle StatusWnd_LevelTextBox_back;
var TextBoxHandle StatusWnd_LevelTextBoxAfter100;
var WindowHandle LevelWindowUnder100;
var WindowHandle LevelWindowAfter100;
var WindowHandle LevelBoxTexPremium100;
var TextureHandle StatusGaugeBg;
var TextureHandle CombatIcon_Tex;
var AnimTextureHandle CombatIcon_ON_ani;
var AnimTextureHandle WPAnimEffect;
var WindowHandle WPAnimEffectWnd;
var int nCombatOnOff;
var bool bFirstUpdate;
var INT64 MyMaxDP;
var INT64 MyMaxBP;
var INT64 MyMaxWP;
var INT64 nWP;

function InitHandleCOD()
{
	Me = GetWindowHandle(m_Windowname);
	CPBar = GetStatusBarHandle(((m_Windowname $ ".") $ "CPBar"));
	HPBar = GetStatusBarHandle(((m_Windowname $ ".") $ "HPBar"));
	MPBar = GetStatusBarHandle(((m_Windowname $ ".") $ "MPBar"));
	if((m_Windowname == "StatusWndClassic"))
	{
		DPBar = GetStatusBarHandle(((m_Windowname $ ".") $ "DPBar"));
		BPBar = GetStatusBarHandle(((m_Windowname $ ".") $ "BPBar"));
		WPBar = GetStatusBarHandle(((m_Windowname $ ".") $ "WPBar"));
	}
	if((m_Windowname == "StatusWndClassic"))
	{
		StatusGaugeBg = GetTextureHandle(((m_Windowname $ ".") $ "StatusGaugeBg"));
	}
	if((m_Windowname == "StatusWnd"))
	{
		UserName = GetNameCtrlHandle(((m_Windowname $ ".") $ "UserName"));
	}
	CombatIcon_Tex = GetTextureHandle(((m_Windowname $ ".") $ "CombatIcon_Tex"));
	CombatIcon_ON_ani = GetAnimTextureHandle(((m_Windowname $ ".") $ "CombatIcon_ON_ani"));
	StatusWnd_LevelTextBox = GetTextBoxHandle(((m_Windowname $ ".") $ "StatusWnd_LevelTextBox"));
	StatusWnd_LevelTextBox_back = GetWindowHandle(((m_Windowname $ ".") $ "StatusWnd_LevelTextBox_back"));
	LevelWindowUnder100 = GetWindowHandle(((m_Windowname $ ".") $ "StatusWnd_LevelTextBox_back"));
	if((m_Windowname == "StatusWnd"))
	{
		LevelBoxTexPremium = GetWindowHandle(((m_Windowname $ ".") $ "StatusWnd_LevelTextBox_back.WndLevelBackPremium"));
		VpDetailBar = GetStatusBarHandle(((m_Windowname $ ".") $ "VpDetailBar"));
		LevelWindowAfter100 = GetWindowHandle(((m_Windowname $ ".") $ "StatusWnd_LevelTextBox_back_lv100"));
		StatusWnd_LevelTextBoxAfter100 = GetTextBoxHandle(((m_Windowname $ ".") $ "StatusWnd_LevelTextBox_back_lv100.StatusWnd_LevelTextBox"));
		LevelBoxTexPremium100 = GetWindowHandle(((m_Windowname $ ".") $ "StatusWnd_LevelTextBox_back_lv100.WndLevelBackPremium_Lv100"));
	}
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(70);
	RegisterEvent(180);
	RegisterEvent(191);
	RegisterEvent(201);
	RegisterEvent(11680);
	RegisterEvent(211);
	RegisterEvent(221);
	RegisterEvent(231);
	RegisterEvent(241);
	RegisterEvent(245);
	RegisterEvent(246);
	RegisterEvent(247);
	RegisterEvent(248);
	RegisterEvent(11670);
	RegisterEvent(11671);
	RegisterEvent(4110);
	RegisterEvent(9080);
	RegisterEvent(950);
	RegisterEvent(11280);
	RegisterEvent(40);
	RegisterEvent(18);
	return;
}

event OnLoad()
{
	InitHandleCOD();
	bFirstUpdate = false;
	GlobalAlpha = 0;
	GlobalAlphaBool = true;
	InitAnimation();
	MaxVitality = GetMaxVitality();
	LevelBoxTexPremium.HideWindow();
	LevelBoxTexPremium100.HideWindow();
	nCombatOnOff = 0;
	CombatIcon_Tex.SetTooltipCustomType(combatTooltip());
	InitWPEffectAnimation();
	return;
}

event OnShow()
{
	toggleCombatMode("");
	if(getInstanceUIData().GetIsLiveServer())
	{
		GetWindowHandle("StatusWnd").ShowWindow();
		GetWindowHandle("StatusWndClassic").HideWindow();
	}
	else
	{
		bFirstUpdate = false;
		GetWindowHandle("StatusWnd").HideWindow();
		GetWindowHandle("StatusWndClassic").ShowWindow();
	}
	return;
}

event OnTimer(int TimerID)
{
	if((TimerID == 1311))
	{
		AnimTexKill = true;
	}
	if((TimerID == 1410))
	{
		Me.KillTimer(1410);
	}
	if((TimerID == 1312))
	{
		if(m_AlphaIncrese)
		{
			if(getInstanceUIData().GetIsLiveServer())
			{
				LevelBoxTexPremium.SetAlpha(197, 0.4000000);
				LevelBoxTexPremium100.SetAlpha(197, 0.4000000);
			}
			m_AlphaIncrese = false;
		}
		else if(!m_AlphaIncrese)
		{
			if(AnimTexKillPremium)
			{
				Me.KillTimer(1312);
				Me.KillTimer(1313);
				if(getInstanceUIData().GetIsLiveServer())
				{
					LevelBoxTexPremium.SetAlpha(255, 1.0000000);
					LevelBoxTexPremium100.SetAlpha(255, 1.0000000);
				}
			}
			else if(getInstanceUIData().GetIsLiveServer())
			{
				LevelBoxTexPremium.SetAlpha(39, 0.4000000);
				LevelBoxTexPremium100.SetAlpha(39, 0.4000000);
			}
			m_AlphaIncrese = true;
		}
	}
	if((TimerID == 1313))
	{
		AnimTexKillPremium = true;
	}
	return;
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	local Rect rectWnd;

	switch(a_WindowHandle)
	{
		case CPBar:
		case HPBar:
		case MPBar:
		case DPBar:
		case UserName:
		case StatusWnd_LevelTextBox:
		case VpDetailBar:
			rectWnd = a_WindowHandle.GetRect();
			if(((X > rectWnd.nX) && (X < (rectWnd.nX + rectWnd.nWidth))))
			{
				RequestSelfTarget();
			}
			break;
		case Me:
			rectWnd = Me.GetRect();
			if(((X > (rectWnd.nX + 13)) && (X < ((rectWnd.nX + rectWnd.nWidth) - 10))))
			{
				RequestSelfTarget();
			}
			break;
		default:
			break;
	}
	return;
}

event OnEvent(int a_EventID, string a_Param)
{
	if(getInstanceUIData().GetIsLiveServer())
	{
		EachServerEvent(a_EventID, a_Param);
	}
	return;
}

event OnEnterState(name a_CurrentStateName)
{
	m_bReceivedUserInfo = false;
	isAfterStatusNormaEvent = false;
	return;
}

event OnRButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	local Rect rectWnd;
	local int targetID;
	local string userNameStr;
	local UserInfo targetUserInfo;

	rectWnd = Me.GetRect();
	targetID = m_UserID;
	if((targetID > 0))
	{
		if(((X > rectWnd.nX) && (X < (rectWnd.nX + rectWnd.nWidth))))
		{
			if(((Y > rectWnd.nY) && (Y < (rectWnd.nY + rectWnd.nHeight))))
			{
				userNameStr = Class'NWindow.UIDATA_USER'.static.GetUserName(targetID);
				if((userNameStr != ""))
				{
					if(GetTargetInfo(targetUserInfo))
					{
					}
					if((targetUserInfo.nID != targetID))
					{
						setTargetByServerID(targetID);
					}
					getInstanceContextMenu().execContextEvent(userNameStr, targetID, X, Y);
				}
			}
		}
	}
	return;
}

function EachServerEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 18:
			PlayWPAnim();
			break;
		case 160:
			InitAnimation();
			break;
		case 180:
			UpdateUserInfo();
			break;
		case 191:
			HandleUpdateGauge(a_Param, 0);
			break;
		case 201:
			HandleUpdateGauge(a_Param, 0);
			break;
		case 211:
			HandleUpdateGauge(a_Param, 1);
			break;
		case 221:
			HandleUpdateGauge(a_Param, 1);
			break;
		case 11680:
			HandleUpdateMyMaxHPBlockPer(a_Param);
			break;
		case 231:
			HandleUpdateGauge(a_Param, 2);
			break;
		case 241:
			HandleUpdateGauge(a_Param, 2);
			break;
		case 245:
			HandleUpdateGauge(a_Param, 3);
			break;
		case 246:
			ParseMaxDp(a_Param);
			break;
		case 247:
			HandleUpdateGauge(a_Param, 4);
			break;
		case 248:
			ParseMaxBp(a_Param);
			break;
		case 11670:
			HandleUpdateGauge(a_Param, 5);
			break;
		case 11671:
			ParseMaxWp(a_Param);
			break;
		case 70:
			HandleRegenStatus(a_Param);
			break;
		case 4110:
			if(!getInstanceUIData().GetIsClassicServer())
			{
				HandleVitalityEffectInfo(a_Param);
			}
			break;
		case 9080:
			HandlePremiumState(a_Param);
			break;
		case 950:
			if(!getInstanceUIData().GetIsClassicServer())
			{
				if(!isAfterStatusNormaEvent)
				{
					isAfterStatusNormaEvent = true;
					showSystemMsg();
				}
			}
			break;
		case 11280:
			toggleCombatMode(a_Param, true);
			break;
		case 40:
			setDefaultPosistionOnShow();
			bFirstUpdate = false;
			nCombatOnOff = 0;
			MyMaxDP = INT64(0);
			MyMaxBP = INT64(0);
			MyMaxWP = INT64(0);
			nWP = INT64(-2);
			toggleCombatMode("");
			break;
		default:
			break;
	}
	return;
}

function PlayAnimation()
{
	Me.KillTimer(1310);
	Me.KillTimer(1311);
	AnimTexKill = false;
	Me.SetTimer(1310, 500);
	Me.SetTimer(1311, 20000);
	return;
}

function InitAnimation()
{
	Me.KillTimer(1310);
	Me.KillTimer(1311);
	Me.KillTimer(1312);
	Me.KillTimer(1313);
	if(getInstanceUIData().GetIsLiveServer())
	{
		LevelBoxTexPremium.SetAlpha(1);
		LevelBoxTexPremium100.SetAlpha(39, 0.4000000);
	}
	return;
}

function UpdateUserGauge(int Type)
{
	local UserInfo UserInfo;

	if(GetPlayerInfo(UserInfo))
	{
		m_UserID = UserInfo.nID;
		switch(Type)
		{
			case 0:
				HPBar.SetPoint(UserInfo.nCurHP, UserInfo.nMaxHP);
				break;
			case 1:
				MPBar.SetPoint(INT64(UserInfo.nCurMP), INT64(UserInfo.nMaxMP));
				break;
			case 2:
				CPBar.SetPoint(INT64(UserInfo.nCurCP), INT64(UserInfo.nMaxCP));
				break;
			default:
				break;
		}
	}
	return;
}

function UpdateUserInfo()
{
	local UserInfo UserInfo;
	local int vitality;

	if(GetPlayerInfo(UserInfo))
	{
		m_UserID = UserInfo.nID;
		vitality = UserInfo.nVitality;
		CPBar.SetPoint(INT64(UserInfo.nCurCP), INT64(UserInfo.nMaxCP));
		HPBar.SetPoint(UserInfo.nCurHP, UserInfo.nMaxHP);
		MPBar.SetPoint(INT64(UserInfo.nCurMP), INT64(UserInfo.nMaxMP));
		if(getInstanceUIData().GetIsLiveServer())
		{
			VpDetailBar.SetPoint(INT64(vitality), INT64(MaxVitality));
			UserName.SetName(UserInfo.Name, NCT_Normal, TA_Left);
			if((nCombatOnOff > 0))
			{
				UserName.SetNameWithColor(UserInfo.Name, NCT_Normal, TA_Left, getInstanceL2Util().PKNameColor);
				UserName.SetWindowSizeRel(1.0000000, 1.0000000, -75, -162);
			}
			else
			{
				UserName.SetNameWithColor(UserInfo.Name, NCT_Normal, TA_Left, getInstanceL2Util().White);
				UserName.SetWindowSizeRel(1.0000000, 1.0000000, -50, -162);
			}
			StatusWnd_LevelTextBoxAfter100.SetInt(UserInfo.nLevel);
		}
		if(Class'NWindow.UIDATA_USER'.static.IsPrologueGrowType(UserInfo.nSubClass))
		{
			if((int(GetLanguage()) == 0))
			{
				StatusWnd_LevelTextBox.SetText("∞");
			}
			else
			{
				StatusWnd_LevelTextBox.SetText("--");
			}
		}
		else
		{
			StatusWnd_LevelTextBox.SetInt(UserInfo.nLevel);
		}
		if(getInstanceUIData().GetIsLiveServer())
		{
			if((UserInfo.nLevel > 99))
			{
				UserName.SetAnchor("StatusWnd", "TopLeft", "TopLeft", 53, 8);
				LevelWindowUnder100.HideWindow();
				LevelWindowAfter100.ShowWindow();
				StatusWnd_LevelTextBox_back.HideWindow();
			}
			else
			{
				UserName.SetAnchor("StatusWnd", "TopLeft", "TopLeft", 45, 8);
				LevelWindowUnder100.ShowWindow();
				LevelWindowAfter100.HideWindow();
			}
		}
		UpdateVp(vitality);
		if(getInstanceUIData().GetIsClassicServer())
		{
			SetMoveBarForExtraBar(UserInfo);
		}
	}
	return;
}

function SetHPBarBlockTextureSmallSize(bool isSmallSize)
{
	if(isSmallSize)
	{
		HPBar.SetGaugeTexture(21, "L2UI_NewTex.Gauge.MaxHpBlock_Gauge16_Left", 4, 16);
		HPBar.SetGaugeTexture(22, "L2UI_NewTex.Gauge.MaxHpBlock_Gauge16_Center", 2, 16);
		HPBar.SetGaugeTexture(23, "L2UI_NewTex.Gauge.MaxHpBlock_Gauge16_Right", 136, 16);
	}
	else
	{
		HPBar.SetGaugeTexture(21, "L2UI_NewTex.Gauge.MaxHpBlock_Gauge24_Left", 4, 24);
		HPBar.SetGaugeTexture(22, "L2UI_NewTex.Gauge.MaxHpBlock_Gauge24_Center", 2, 24);
		HPBar.SetGaugeTexture(23, "L2UI_NewTex.Gauge.MaxHpBlock_Gauge24_Right", 136, 24);
	}
	return;
}

function setDefaultPosistionOnShow()
{
	CPBar.ClearPoint();
	HPBar.ClearPoint();
	MPBar.ClearPoint();
	if(getInstanceUIData().GetIsClassicServer())
	{
		DPBar.ClearPoint();
		BPBar.ClearPoint();
		WPBar.ClearPoint();
	}
	return;
}

function UpdateVp(int vitality)
{
	if(getInstanceUIData().GetIsLiveServer())
	{
		if(((vitality < 1807) && (vitality > 0)))
		{
			VpDetailBar.SetPoint(INT64(1807), INT64(MaxVitality));
		}
		else
		{
			VpDetailBar.SetPoint(INT64(vitality), INT64(MaxVitality));
		}
	}
	return;
}

function ParseMaxDp(string param)
{
	local int ServerID;

	ParseInt(param, "ServerID", ServerID);
	if((m_UserID == ServerID))
	{
		ParseINT64(param, "MyMaxDP", MyMaxDP);
	}
	return;
}

function ParseMaxBp(string param)
{
	local int ServerID;

	ParseInt(param, "ServerID", ServerID);
	if((m_UserID == ServerID))
	{
		ParseINT64(param, "MyMaxBP", MyMaxBP);
	}
	return;
}

function ParseMaxWp(string param)
{
	local int ServerID;
	local UserInfo Info;
	local Rect rectWnd;

	ParseInt(param, "ServerID", ServerID);
	if((m_UserID != ServerID))
	{
		return;
	}
	ParseINT64(param, "MyMaxWP", MyMaxWP);
	rectWnd = Me.GetRect();
	GetPlayerInfo(Info);
	if(((getInstanceL2Util().GetPlayerType(Info.nSubClass, Info.Race) == "werewolf") && (MyMaxWP > INT64(0))))
	{
		SetHPMPLIne3();
		ShowExtraBar(WPBar);
	}
	else
	{
		SetHPMPLine2();
	}
	return;
}

function toggleCombatMode(string paramStr, optional bool bUseGfxScreenMessage)
{
	local UserInfo UserInfo;

	ParseInt(paramStr, "OnOff", nCombatOnOff);
	GetPlayerInfo(UserInfo);
	if((nCombatOnOff > 0))
	{
		CombatIcon_Tex.ShowWindow();
		AnimTexturePlay(CombatIcon_ON_ani, true, 1);
		if(getInstanceUIData().GetIsLiveServer())
		{
			UserName.SetNameWithColor(UserInfo.Name, NCT_Normal, TA_Left, getInstanceL2Util().PKNameColor);
			UserName.SetWindowSizeRel(1.0000000, 1.0000000, -75, -162);
		}
		if(bUseGfxScreenMessage)
		{
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13032));
		}
	}
	else
	{
		CombatIcon_Tex.HideWindow();
		AnimTextureStop(CombatIcon_ON_ani, true);
		if(getInstanceUIData().GetIsLiveServer())
		{
			UserName.SetNameWithColor(UserInfo.Name, NCT_Normal, TA_Left, getInstanceL2Util().White);
			UserName.SetWindowSizeRel(1.0000000, 1.0000000, -50, -162);
		}
		if(bUseGfxScreenMessage)
		{
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13033));
		}
	}
	return;
}

function HandleUpdateMyMaxHPBlockPer(string param)
{
	local int maxHPBlockPer;

	ParseInt(param, "MaxHPBlockPer", maxHPBlockPer);
	if((maxHPBlockPer > 0))
	{
		HPBar.SetDrawBlockEffect(true);
	}
	else
	{
		HPBar.SetDrawBlockEffect(false);
	}
	return;
}

function HandleVitalityPointInfo(string param)
{
	local int nVitality;

	ParseInt(param, "Vitality", nVitality);
	UpdateVp(nVitality);
	return;
}

function HandleUpdateGauge(string param, int Type)
{
	local int ServerID;
	local INT64 MyCurrentDP, MyCurrentBP, MyCurrentWP;

	if(!m_bReceivedUserInfo)
	{
		m_bReceivedUserInfo = true;
		UpdateUserInfo();
	}
	ParseInt(param, "ServerID", ServerID);
	if((m_UserID == ServerID))
	{
		UpdateUserGauge(Type);
		if((Type == 3))
		{
			ParseINT64(param, "MyCurrentDP", MyCurrentDP);
			if((MyMaxDP > INT64(0)))
			{
				DPBar.SetPoint(MyCurrentDP, MyMaxDP);
			}
		}
		if((Type == 4))
		{
			ParseINT64(param, "MyCurrentBP", MyCurrentBP);
			if((MyMaxBP > INT64(0)))
			{
				BPBar.SetPoint(MyCurrentBP, MyMaxBP);
			}
		}
		if((Type == 5))
		{
			ParseINT64(param, "MyCurrentWP", MyCurrentWP);
			if((MyMaxWP > INT64(0)))
			{
				WPBar.SetPoint(MyCurrentWP, MyMaxWP);
				if(((nWP == INT64(-2)) && (MyCurrentWP == INT64(0))))
				{
					nWP = INT64(-1);
					return;
				}
				if(((nWP > INT64(-1)) && ((MyCurrentWP - nWP) >= INT64(100))))
				{
					PlayWPAnim();
				}
				nWP = MyCurrentWP;
			}
		}
	}
	return;
}

function HandleUpdateInfo(string param)
{
	local int ServerID;

	ParseInt(param, "ServerID", ServerID);
	if(((m_UserID == ServerID) || !m_bReceivedUserInfo))
	{
		m_bReceivedUserInfo = true;
		UpdateUserInfo();
	}
	return;
}

function HandleRegenStatus(string a_Param)
{
	local int Type, Duration, ticks;
	local float Amount;

	ParseInt(a_Param, "Type", Type);
	if((Type == 1))
	{
		ParseInt(a_Param, "Duration", Duration);
		ParseInt(a_Param, "Ticks", ticks);
		ParseFloat(a_Param, "Amount", Amount);
		HPBar.SetRegenInfo(Duration, ticks, Amount);
	}
	return;
}

function PlayAnimationPrem()
{
	Me.KillTimer(1312);
	Me.KillTimer(1313);
	AnimTexKillPremium = false;
	Me.SetTimer(1312, 600);
	Me.SetTimer(1313, 30000);
	m_AlphaIncrese = true;
	return;
}

function HandlePremiumState(string a_Param)
{
	local int premiumstate;

	ParseInt(a_Param, "PREMIUMSTATE", premiumstate);
	if((m_CurPremiumState == premiumstate))
	{
		return;
	}
	m_CurPremiumState = premiumstate;
	if((m_CurPremiumState == 1))
	{
		if(getInstanceUIData().GetIsLiveServer())
		{
			LevelBoxTexPremium.ShowWindow();
			LevelBoxTexPremium100.ShowWindow();
			PlayAnimationPrem();
		}
	}
	else
	{
		if(getInstanceUIData().GetIsLiveServer())
		{
			LevelBoxTexPremium.HideWindow();
			LevelBoxTexPremium100.HideWindow();
		}
		InitAnimation();
	}
	return;
}

function HandleVitalityEffectInfo(string param)
{
	local CustomTooltip t;
	local int nVitality, nVitalityItemRestoreCount;
	local string sBonusString, sExtraBonusString;

	ParseInt(param, "vitalityPoint", nVitality);
	ParseInt(param, "vitalityBonus", nVitalityBonus);
	ParseInt(param, "restoreCount", nVitalityItemRestoreCount);
	ParseInt(param, "maxRestoreCount", nVitalityItemMaxRestoreCount);
	ParseInt(param, "vitalityExtraBonus", nVitalityExtraBonus);
	sBonusString = (string(nVitalityBonus) $ "%");
	if((nVitalityExtraBonus > 0))
	{
		sExtraBonusString = (("(+" $ string(nVitalityExtraBonus)) $ "%)");
	}
	util = L2Util(GetScript("L2Util"));
	util.setCustomTooltip(t);
	util.ToopTipInsertText(GetSystemString(2494), true, false);
	if((nVitality <= 0))
	{
		util.ToopTipInsertText(GetSystemString(2496), true, false, COLOR_GRAY);
		util.ToopTipInsertText(GetSystemMessage(13112), true, true);
	}
	else
	{
		util.ToopTipInsertText(sBonusString, true, false);
		util.ToopTipInsertText(sExtraBonusString, true, false, COLOR_YELLOW03);
		util.ToopTipInsertText(((" " $ GetSystemString(2495)) $ ". "), true, false);
		util.ToopTipInsertText(GetSystemMessage(13111), true, true);
	}
	VpDetailBar.SetTooltipCustomType(util.getCustomToolTip());
	if(((isVPApply && (nVitality == 0)) || (!isVPApply && (nVitality > 0))))
	{
		showSystemMsg();
	}
	return;
}

function showSystemMsg()
{
	local string sBonusString, sExtraBonusString, sSysMsgParamString;
	local UserInfo UserInfo;
	local int nVitality;
	local string sMessage;

	if(!GetPlayerInfo(UserInfo))
	{
		return;
	}
	nVitality = UserInfo.nVitality;
	sBonusString = (string(nVitalityBonus) $ "%");
	if((nVitalityExtraBonus > 0))
	{
		sExtraBonusString = (("(+" $ string(nVitalityExtraBonus)) $ "%)");
	}
	if(isAfterStatusNormaEvent)
	{
		isVPApply = (nVitality > 0);
		if(isVPApply)
		{
			ParamAdd(sSysMsgParamString, "Type", string(0));
			ParamAdd(sSysMsgParamString, "param1", (sBonusString $ sExtraBonusString));
			AddSystemMessageParam(sSysMsgParamString);
			sSysMsgParamString = "";
			ParamAdd(sSysMsgParamString, "Type", string(1));
			ParamAdd(sSysMsgParamString, "param1", string(nVitalityItemMaxRestoreCount));
			AddSystemMessageParam(sSysMsgParamString);
			sMessage = EndSystemMessageParam(6067, true);
			if(!getInstanceUIData().GetIsClassicServer())
			{
				AddSystemMessageString(sMessage);
			}
			isVPApply = true;
		}
		else
		{
			ParamAdd(sSysMsgParamString, "Type", string(1));
			ParamAdd(sSysMsgParamString, "param1", string(nVitalityItemMaxRestoreCount));
			AddSystemMessageParam(sSysMsgParamString);
			if((getInstanceUIData().GetIsLiveServer() && ((int(GetLanguage()) == 8) || (int(GetLanguage()) == 9))))
			{
				sMessage = EndSystemMessageParam(6841, true);
			}
			else
			{
				sMessage = EndSystemMessageParam(6068, true);
			}
			AddSystemMessageString(sMessage);
			isVPApply = false;
		}
	}
	return;
}

function CustomTooltip combatTooltip()
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13078), getInstanceL2Util().PKNameColor, "", true, true);
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	return mCustomTooltip;
}

function SetMoveBarForExtraBar(UserInfo Info)
{
	if(bFirstUpdate)
	{
		return;
	}
	bFirstUpdate = true;
	if((getInstanceL2Util().GetPlayerType(Info.nSubClass, Info.Race) == "deathKnight"))
	{
		SetHPMPLIne3();
		ShowExtraBar(DPBar);
	}
	else if((getInstanceL2Util().GetPlayerType(Info.nSubClass, Info.Race) == "vanguard"))
	{
		SetHPMPLIne3();
		ShowExtraBar(BPBar);
	}
	else if(((getInstanceL2Util().GetPlayerType(Info.nSubClass, Info.Race) == "werewolf") && (MyMaxWP > INT64(0))))
	{
		SetHPMPLIne3();
		ShowExtraBar(WPBar);
	}
	else
	{
		SetHPMPLine2();
	}
	return;
}

function SetHPMPLIne3()
{
	local Rect rectWnd;

	rectWnd = Me.GetRect();
	HPBar.SetWindowSizeRel(1.0000000, 0.0000000, -109, 16);
	MPBar.SetWindowSizeRel(1.0000000, 0.0000000, -109, 16);
	MPBar.MoveTo((rectWnd.nX + 86), (rectWnd.nY + 46));
	StatusGaugeBg.SetTexture("L2UI_NewTex.StatusWnd.StatusGaugeBg02");
	SetHPBarBlockTextureSmallSize(true);
	return;
}

function SetHPMPLine2()
{
	local Rect rectWnd;

	rectWnd = Me.GetRect();
	HPBar.SetWindowSizeRel(1.0000000, 0.0000000, -109, 24);
	MPBar.SetWindowSizeRel(1.0000000, 0.0000000, -109, 24);
	MPBar.MoveTo((rectWnd.nX + 86), (rectWnd.nY + 54));
	DPBar.HideWindow();
	BPBar.HideWindow();
	WPBar.HideWindow();
	WPAnimEffect.HideWindow();
	StatusGaugeBg.SetTexture("L2UI_NewTex.StatusWnd.StatusGaugeBg01");
	SetHPBarBlockTextureSmallSize(false);
	return;
}

function ShowExtraBar(StatusBarHandle bar)
{
	BPBar.HideWindow();
	DPBar.HideWindow();
	WPBar.HideWindow();
	bar.ShowWindow();
	if((bar == WPBar))
	{
		WPAnimEffect.ShowWindow();
	}
	else
	{
		WPAnimEffect.HideWindow();
	}
	return;
}

function InitWPEffectAnimation()
{
	WPAnimEffectWnd = GetWindowHandle((m_Windowname $ ".WPAnimEffectWnd"));
	WPAnimEffect = GetAnimTextureHandle((m_Windowname $ ".WPAnimEffectWnd.WPAnimEffect"));
	WPAnimEffect.SetLoopCount(1);
	return;
}

function PlayWPAnim()
{
	SetWPEffectWidth();
	WPAnimEffect.Stop();
	WPAnimEffect.Play();
	return;
}

function SetWPEffectWidth()
{
	local int W, h;
	local INT64 C, Max, Min;

	WPBar.GetWindowSize(W, h);
	WPBar.GetPoint(C, Max, Min);
	WPAnimEffectWnd.SetWindowSizeRel(1.0000000, 0.0000000, (-109 - (W - int(((INT64(W) * C) / Max)))), 15);
	return;
}

defaultproperties
{
	m_Windowname="StatusWnd"
}
