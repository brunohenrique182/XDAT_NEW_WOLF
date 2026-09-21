class TargetStatusWnd extends UICommonAPI;

const TimerValue1 = 1351;
const TimerValue2 = 6346;
const TimerValue3 = 4858;
const TimerValue4 = 7337;
const TimerValue5 = 3474;
const TimerValue6 = 5269;
const TimerValue7 = 5270;
const TimerValue8 = 5271;
const TimerValue9 = 5272;
const CONTRACT_HEIGHT = 52;
const EXPAND_HEIGHT = 86;
const CONTRACT_CLASSIC_HEIGHT = 58;
const EXPAND_CLASSIC_HEIGHT = 102;
const ALLIANCECREST_HEIGHT = 67;
const ALLIANCECREST_CLASSIC_HEIGHT = 72;
const BUFF_SIZE_BIG = 24;
const BUFF_SIZE_SMALL = 16;

enum WARMARKTYPE
{
	TYPE_WarMarkNone,               // 0
	TYPE_Dominion,                  // 1
	TYPE_DominionPenalty,           // 2
	TYPE_BlueAttackLeader,          // 3
	TYPE_BlueAttackLeaderPenalty,   // 4
	TYPE_BlueSword,                 // 5
	TYPE_BlueSwordPenalty,          // 6
	TYPE_BlueLeader,                // 7
	TYPE_BlueLeaderPenalty,         // 8
	TYPE_BlueShield,                // 9
	TYPE_BlueShieldPenalty,         // 10
	TYPE_RedAttackLeader,           // 11
	TYPE_RedAttackLeaderPenalty,    // 12
	TYPE_RedSword,                  // 13
	TYPE_RedSwordPenalty,           // 14
	TYPE_RedLeader,                 // 15
	TYPE_RedLeaderPenalty,          // 16
	TYPE_RedShield,                 // 17
	TYPE_RedShieldPenalty,          // 18
	TYPE_DecalreWarBothSide,        // 19
	TYPE_DecalreWarOneSide,         // 20
	TYPE_UserWatcher,               // 21
	TYPE_DecalreWarBothSide_UserWatcher,// 22
	TYPE_DecalreWarOneSide_UserWatcher// 23
};

var bool m_bExpand;
var int m_TargetLevel;
var int m_targetID;
var bool m_rotated;
var bool m_bShow;
var string g_NameStr;
var Vector targetLoc;
var WindowHandle Me1;
var WindowHandle Me2;
var WindowHandle Me;
var StatusBarHandle barMP;
var StatusBarHandle barHP;
var TextBoxHandle txtPledgeAllianceName;
var TextureHandle texPledgeAllianceCrest;
var TextBoxHandle txtAlliance;
var TextBoxHandle txtPledgeName;
var TextureHandle texPledgeCrest;
var TextBoxHandle txtPledge;
var NameCtrlHandle RankName;
var NameCtrlHandle UserName;
var ButtonHandle btnClose;
var TreeHandle NpcInfo;
var ButtonHandle btnExpand;
var ButtonHandle btnContract;
var WindowHandle TargetStatusBuff1Wnd;
var WindowHandle TargetStatusBuff2Wnd;
var WindowHandle BuffWnd;
var ButtonHandle btnBuffMoreView1;
var ButtonHandle btnBuffMoreView2;
var int yPosView2;
var StatusIconHandle StatusIcons;
var array<StatusIconInfo> arrMyBuff;
var array<StatusIconInfo> arrOtherBuff;
var array<StatusIconInfo> arrMyDebuff;
var array<StatusIconInfo> arrOtherDebuff;
var int LineCount;
var string strSelectTarget;
var ProgressCtrlHandle barSkillProgress1;
var NameCtrlHandle skillProgressName1;
var TextureHandle barSkillProgressEff1_Left;
var TextureHandle barSkillProgressEff1_Center;
var TextureHandle barSkillProgressEff1_Right;
var ProgressCtrlHandle barSkillProgress2;
var NameCtrlHandle skillProgressName2;
var TextureHandle barSkillProgressEff2_Left;
var TextureHandle barSkillProgressEff2_Center;
var TextureHandle barSkillProgressEff2_Right;
var TextureHandle texMark;
var bool bIsShowBackup;
var int m_TargetIDBackup;
var string m_Windowname;
var TextureHandle SiegeMark;
var TextureHandle DeathTexture;
var int _myMaxHPBlockPer;

function OnRegisterEvent()
{
	RegisterEvent(980);
	RegisterEvent(990);
	RegisterEvent(190);
	RegisterEvent(210);
	RegisterEvent(200);
	RegisterEvent(220);
	RegisterEvent(191);
	RegisterEvent(211);
	RegisterEvent(201);
	RegisterEvent(11680);
	RegisterEvent(221);
	RegisterEvent(300);
	RegisterEvent(5120);
	RegisterEvent(981);
	RegisterEvent(982);
	RegisterEvent(160);
	RegisterEvent(150);
	RegisterEvent(161);
	RegisterEvent(40);
	RegisterEvent(11410);
	RegisterEvent(11420);
	return;
}

function OnLoad()
{
	local bool nOption;

	SetClosingOnESC();
	InitializeCOD();
	OnShowProcess();
	Load();
	nOption = GetOptionBool("ScreenInfo", "StrangeStateBox");
	StateBoxShow(nOption);
	return;
}

function InitializeCOD()
{
	Me = GetWindowHandle(m_Windowname);
	barMP = GetStatusBarHandle((m_Windowname $ ".barMP"));
	barHP = GetStatusBarHandle((m_Windowname $ ".barHP"));
	txtPledgeAllianceName = GetTextBoxHandle((m_Windowname $ ".txtPledgeAllianceName"));
	texPledgeAllianceCrest = GetTextureHandle((m_Windowname $ ".texPledgeAllianceCrest"));
	txtAlliance = GetTextBoxHandle((m_Windowname $ ".txtAlliance"));
	txtPledgeName = GetTextBoxHandle((m_Windowname $ ".txtPledgeName"));
	texPledgeCrest = GetTextureHandle((m_Windowname $ ".texPledgeCrest"));
	txtPledge = GetTextBoxHandle((m_Windowname $ ".txtPledge"));
	RankName = GetNameCtrlHandle((m_Windowname $ ".RankName"));
	UserName = GetNameCtrlHandle((m_Windowname $ ".UserName"));
	btnClose = GetButtonHandle((m_Windowname $ ".btnClose"));
	NpcInfo = GetTreeHandle((m_Windowname $ ".NpcInfo"));
	Me1 = GetWindowHandle(m_Windowname);
	btnExpand = GetButtonHandle((m_Windowname $ ".btnExpand"));
	btnContract = GetButtonHandle((m_Windowname $ ".btnContract"));
	BuffWnd = GetWindowHandle((m_Windowname $ ".BuffWnd"));
	TargetStatusBuff1Wnd = GetWindowHandle("TargetStatusBuff1Wnd");
	TargetStatusBuff2Wnd = GetWindowHandle("TargetStatusBuff2Wnd");
	StatusIcons = GetStatusIconHandle((m_Windowname $ ".BuffWnd.StatusIcons"));
	btnBuffMoreView1 = GetButtonHandle((m_Windowname $ ".BuffWnd.btnBuffMoreView1"));
	btnBuffMoreView2 = GetButtonHandle((m_Windowname $ ".BuffWnd.btnBuffMoreView2"));
	barSkillProgress1 = GetProgressCtrlHandle((m_Windowname $ ".SkillProgressWnd1.barSkillProgress1"));
	skillProgressName1 = GetNameCtrlHandle((m_Windowname $ ".SkillProgressWnd1.SkillProgressName1"));
	barSkillProgressEff1_Left = GetTextureHandle((m_Windowname $ ".SkillProgressWnd1.barSkillProgressEff1_Left"));
	barSkillProgressEff1_Center = GetTextureHandle((m_Windowname $ ".SkillProgressWnd1.barSkillProgressEff1_Center"));
	barSkillProgressEff1_Right = GetTextureHandle((m_Windowname $ ".SkillProgressWnd1.barSkillProgressEff1_Right"));
	barSkillProgress2 = GetProgressCtrlHandle((m_Windowname $ ".SkillProgressWnd2.barSkillProgress2"));
	skillProgressName2 = GetNameCtrlHandle((m_Windowname $ ".SkillProgressWnd2.SkillProgressName2"));
	barSkillProgressEff2_Left = GetTextureHandle((m_Windowname $ ".SkillProgressWnd2.barSkillProgressEff2_Left"));
	barSkillProgressEff2_Center = GetTextureHandle((m_Windowname $ ".SkillProgressWnd2.barSkillProgressEff2_Center"));
	barSkillProgressEff2_Right = GetTextureHandle((m_Windowname $ ".SkillProgressWnd2.barSkillProgressEff2_Right"));
	texMark = GetTextureHandle((m_Windowname $ ".texMark"));
	SiegeMark = GetTextureHandle((m_Windowname $ ".SiegeMark"));
	DeathTexture = GetTextureHandle((m_Windowname $ ".DeathTexture"));
	return;
}

function Load()
{
	g_NameStr = "";
	m_bShow = false;
	m_targetID = -1;
	m_rotated = false;
	skillBarVisible(false, 1);
	showBuffMoreBtn(false, 1);
	skillBarVisible(false, 2);
	showBuffMoreBtn(false, 2);
	yPosView2 = 0;
	strSelectTarget = "Friendly";
	return;
}

function OnShowProcess()
{
	return;
}

function OnRotate1()
{
	Me2.SetAlpha(0);
	Me2.ShowWindow();
	Me.SetTimer(1351, 150);
	return;
}

function OnRotate2()
{
	Me1.SetAlpha(0);
	Me1.ShowWindow();
	Me.SetTimer(6346, 150);
	return;
}

function OnRotateClose()
{
	if((GetGameStateName() != "SPECIALCAMERASTATE"))
	{
		Me1.SetAlpha(0);
		Me1.ShowWindow();
		Me.SetTimer(3474, 150);
	}
	return;
}

function OnRotateReset()
{
	Me1.ShowWindow();
	Me2.HideWindow();
	Me1.SetAlpha(255);
	Me2.SetAlpha(0);
	m_rotated = false;
	HandleTargetUpdate();
	return;
}

function OnTimer(int TimerID)
{
	if((TimerID == 1351))
	{
		Me.KillTimer(1351);
		Me2.SetAlpha(255, 0.4000000);
		Me1.SetAlpha(0);
		Me.SetTimer(4858, 300);
	}
	if((TimerID == 4858))
	{
		Me.KillTimer(4858);
		Me1.HideWindow();
		m_rotated = true;
	}
	if((TimerID == 6346))
	{
		Me.KillTimer(6346);
		Me1.SetAlpha(255, 0.4000000);
		Me2.SetAlpha(0);
		Me.SetTimer(7337, 300);
	}
	if((TimerID == 7337))
	{
		Me.KillTimer(7337);
		Me2.HideWindow();
		m_rotated = false;
	}
	if((TimerID == 3474))
	{
		Me.KillTimer(3474);
		Me1.SetAlpha(255, 0.4000000);
		Me2.SetAlpha(0);
		Me.SetTimer(5269, 300);
	}
	if((TimerID == 5269))
	{
		Me.KillTimer(5269);
		Me2.HideWindow();
		Me1.HideWindow();
		m_rotated = false;
	}
	if((TimerID == 5270))
	{
		Me.KillTimer(5270);
		skillBarVisible(false, 1);
	}
	if((TimerID == 5271))
	{
		Me.KillTimer(5271);
		skillBarVisible(false, 2);
	}
	if((TimerID == 5272))
	{
		Me.KillTimer(5272);
		skillBarVisible(false, 1);
		skillBarVisible(false, 2);
	}
	return;
}

function OnShow()
{
	m_bShow = true;
	return;
}

function OnHide()
{
	m_bShow = false;
	g_NameStr = "";
	m_targetID = 0;
	return;
}

function EachSeverEnterState(name a_CurrentStateName)
{
	local int tmpInt;

	GetINIInt(m_Windowname, "e", tmpInt, "WindowsInfo.ini");
	m_bExpand = bool(tmpInt);
	SetExpandMode(m_bExpand, true);
	return;
}

function OnEnterState(name a_CurrentStateName)
{
	if(getInstanceUIData().GetIsLiveServer())
	{
		EachSeverEnterState(a_CurrentStateName);
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	if(getInstanceUIData().GetIsLiveServer())
	{
		EachServerEvent(Event_ID, param);
	}
	return;
}

function EachServerEvent(int Event_ID, string param)
{
	if((Event_ID == 980))
	{
		if(m_rotated)
		{
			OnRotateReset();
		}
		else
		{
			HandleTargetUpdate();
		}
	}
	else if((Event_ID == 990))
	{
		HandleTargetHideWindow();
	}
	else if((Event_ID == 300))
	{
		HandleReceiveTargetLevelDiff(param);
	}
	else if(((Event_ID == 190) || (Event_ID == 191)))
	{
		HandleUpdateGauge(param, 0);
	}
	else if(((Event_ID == 200) || (Event_ID == 201)))
	{
		HandleUpdateGauge(param, 0);
	}
	else if(((Event_ID == 210) || (Event_ID == 211)))
	{
		HandleUpdateGauge(param, 1);
	}
	else if(((Event_ID == 220) || (Event_ID == 221)))
	{
		HandleUpdateGauge(param, 1);
	}
	else if((Event_ID == 5120))
	{
		HandleTargetSpelledList(param);
	}
	else if((Event_ID == 981))
	{
		HandleTargetSkillInfo(param);
	}
	else if((Event_ID == 982))
	{
		HandleSkillCancel();
	}
	else if((Event_ID == 160))
	{
		RequestTargetCancel();
	}
	else if((Event_ID == 150))
	{
		if(bIsShowBackup)
		{
			if((m_TargetIDBackup > 0))
			{
				RequestTargetUser(m_TargetIDBackup);
			}
		}
	}
	else if((Event_ID == 161))
	{
		bIsShowBackup = Me.IsShowWindow();
		m_TargetIDBackup = m_targetID;
	}
	else if((Event_ID == 40))
	{
		bIsShowBackup = false;
		m_TargetIDBackup = -1;
	}
	else if((Event_ID == 11410))
	{
		HandleUpdateWarMark(param);
	}
	else if((Event_ID == 11420))
	{
		HandleUpdateTargetDead(param);
	}
	else if((Event_ID == 11680))
	{
		HandleUpdateMyMaxHPBlockPer(param);
	}
	return;
}

function OnRButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	local Rect rectWnd;
	local int targetID;
	local string UserName;
	local UserInfo myInfo;

	rectWnd = Me.GetRect();
	targetID = Class'NWindow.UIDATA_TARGET'.static.GetTargetID();
	if((targetID > 0))
	{
		GetPlayerInfo(myInfo);
		if(((X > rectWnd.nX) && (X < (rectWnd.nX + rectWnd.nWidth))))
		{
			if(((Y > rectWnd.nY) && (Y < (rectWnd.nY + rectWnd.nHeight))))
			{
				UserName = Class'NWindow.UIDATA_USER'.static.GetUserName(targetID);
				if((UserName != ""))
				{
					getInstanceContextMenu().execContextEvent(UserName, targetID, X, Y);
				}
			}
		}
	}
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnClose":
			OnCloseButton();
			break;
		case "RotateButton1":
			OnRotate1();
			break;
		case "RotateButton2":
			OnRotate2();
			break;
		case "btnExpand":
			SetExpandMode(false, true);
			break;
		case "btnContract":
			SetExpandMode(true, true);
			break;
		default:
			break;
	}
	return;
}

function OnCloseButton()
{
	RequestTargetCancel();
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	return;
}

function HandleTargetHideWindow()
{
	if(m_rotated)
	{
		OnRotateClose();
	}
	else
	{
		Me.HideWindow();
	}
	return;
}

function UpdateMaxHPBlockEffect()
{
	local int targetID, PlayerID;

	PlayerID = Class'NWindow.UIDATA_TARGET'.static.GetTargetID();
	targetID = Class'NWindow.UIDATA_PLAYER'.static.GetPlayerID();
	if(((PlayerID > 0) && (m_targetID == PlayerID)))
	{
		if((_myMaxHPBlockPer > 0))
		{
			barHP.SetDrawBlockEffect(true);
		}
		else
		{
			barHP.SetDrawBlockEffect(false);
		}
	}
	else
	{
		barHP.SetDrawBlockEffect(false);
	}
	return;
}

function HandleUpdateMyMaxHPBlockPer(string param)
{
	ParseInt(param, "MaxHPBlockPer", _myMaxHPBlockPer);
	UpdateMaxHPBlockEffect();
	return;
}

function HandleUpdateGauge(string param, int Type)
{
	local int ServerID;

	if(m_bShow)
	{
		ParseInt(param, "ServerID", ServerID);
		if((m_targetID == ServerID))
		{
			HandleTargetUpdateGauge(Type);
		}
	}
	return;
}

function HandleReceiveTargetLevelDiff(string param)
{
	ParseInt(param, "LevelDiff", m_TargetLevel);
	HandleTargetUpdate();
	return;
}

function HandleTargetUpdateGauge(int Type)
{
	local UserInfo Info;
	local int targetID;

	targetID = Class'NWindow.UIDATA_TARGET'.static.GetTargetID();
	if((targetID < 1))
	{
		if(m_rotated)
		{
			OnRotateClose();
		}
		else
		{
			Me.HideWindow();
		}
		return;
	}
	m_targetID = targetID;
	GetTargetInfo(Info);
	switch(Type)
	{
		case 0:
			UpdateHPBar(Info.nCurHP, Info.nMaxHP);
			break;
		case 1:
			UpdateMPBar(Info.nCurMP, Info.nMaxMP);
			break;
		default:
			break;
	}
	return;
}

function HandleTargetUpdate(optional bool bExpand)
{
	local Rect rectWnd;
	local string strTmp;
	local int targetID, PlayerID, PetID, clanType, clanNameValue;
	local bool bIsServerObject, bIsHPShowableNPC, bIsVehicle;
	local string Name, NameRank;
	local Color TargetNameColor;
	local int ServerObjectNameID;
	local Actor.EL2ObjectType ServerObjectType;
	local Vehicle VehicleActor;
	local string DriverName;
	local bool bShowHPBar, bShowMPBar, bShowPledgeInfo, bShowPledgeTex, bShowPledgeAllianceTex;
	local string PledgeName, PledgeAllianceName;
	local Texture PledgeCrestTexture, PledgeAllianceCrestTexture;
	local Color PledgeNameColor, PledgeAllianceNameColor;
	local bool bShowNpcInfo;
	local array<int> arrNpcInfo;
	local bool IsTargetChanged, WantHideName;
	local UserInfo Info;
	local PetInfo PetInfo;
	local UserInfo myInfo;
	local Color WhiteColor;
	local Rect textRect;
	local string warMarkTextureName;

	WhiteColor.R = 0;
	WhiteColor.G = 0;
	WhiteColor.B = 0;
	targetID = Class'NWindow.UIDATA_TARGET'.static.GetTargetID();
	if((targetID < 1))
	{
		if(m_rotated)
		{
			OnRotateClose();
		}
		else
		{
			Me.HideWindow();
		}
		return;
	}
	if((m_targetID != targetID))
	{
		IsTargetChanged = true;
		if(!bExpand)
		{
			DeathTexture.HideWindow();
			SiegeMark.HideWindow();
		}
	}
	m_targetID = targetID;
	GetTargetInfo(Info);
	if((Info.TacticSign == 0))
	{
		texMark.HideWindow();
	}
	else
	{
		texMark.ShowWindow();
		texMark.SetTexture(("l2ui_Ct1.TargetStatusWnd_DF_mark_0" $ string(Info.TacticSign)));
	}
	WantHideName = Info.WantHideName;
	rectWnd = Me.GetRect();
	PledgeName = GetSystemString(431);
	PledgeAllianceName = GetSystemString(591);
	PledgeNameColor.R = 128;
	PledgeNameColor.G = 128;
	PledgeNameColor.B = 128;
	PledgeAllianceNameColor.R = 128;
	PledgeAllianceNameColor.G = 128;
	PledgeAllianceNameColor.B = 128;
	TargetNameColor = GetTargetNameColor(m_TargetLevel);
	bIsServerObject = Class'NWindow.UIDATA_TARGET'.static.IsServerObject();
	bIsVehicle = Class'NWindow.UIDATA_TARGET'.static.IsVehicle();
	if(bIsServerObject)
	{
		ServerObjectType = Class'NWindow.UIDATA_STATICOBJECT'.static.GetServerObjectType(m_targetID);
		if((int(ServerObjectType) == 4))
		{
			Name = GetSystemString(1966);
			NameRank = "";
		}
		else if((int(ServerObjectType) == 5))
		{
			Name = Class'NWindow.UIDATA_STATICOBJECT'.static.GetServerObjectName(m_targetID);
			NameRank = "";
		}
		else
		{
			ServerObjectNameID = Class'NWindow.UIDATA_STATICOBJECT'.static.GetServerObjectNameID(m_targetID);
			if((ServerObjectNameID > 0))
			{
				Name = Class'NWindow.UIDATA_STATICOBJECT'.static.GetStaticObjectName(ServerObjectNameID);
				NameRank = "";
			}
		}
		UserName.SetName(Name, NCT_Normal, TA_Center);
		RankName.SetName(NameRank, NCT_Normal, TA_Center);
		if((int(ServerObjectType) == 1))
		{
			if(Class'NWindow.UIDATA_STATICOBJECT'.static.GetStaticObjectShowHP(m_targetID))
			{
				bShowHPBar = true;
				UpdateHPBar(INT64(Class'NWindow.UIDATA_STATICOBJECT'.static.GetServerObjectHP(m_targetID)), INT64(Class'NWindow.UIDATA_STATICOBJECT'.static.GetServerObjectMaxHP(m_targetID)));
			}
		}
	}
	else if(bIsVehicle)
	{
		HandleTargetHideWindow();
		return;
		UserName.SetName("AirShip", NCT_Normal, TA_Center);
		VehicleActor = Vehicle(Class'NWindow.UIDATA_TARGET'.static.GetTargetActor());
		if((VehicleActor != none))
		{
			if((VehicleActor.DriverID > 0))
			{
				DriverName = Class'NWindow.UIDATA_USER'.static.GetUserName(VehicleActor.DriverID);
			}
			if((Len(DriverName) < 1))
			{
				DriverName = GetSystemString(1967);
			}
			RankName.SetName(DriverName, NCT_Normal, TA_Center);
		}
	}
	else if((Len(Info.Name) < 1))
	{
		Name = Class'NWindow.UIDATA_PARTY'.static.GetMemberVirtualName(m_targetID);
		if((Name == ""))
		{
			Name = Class'NWindow.UIDATA_PARTY'.static.GetMemberName(m_targetID);
		}
		NameRank = "";
		UserName.SetName(Name, NCT_Normal, TA_Center);
		RankName.SetName(NameRank, NCT_Normal, TA_Center);
		if((Class'NWindow.UIDATA_PARTY'.static.GetMemberTacticalSign(m_targetID) == 0))
		{
			texMark.HideWindow();
			if(getInstanceUIData().GetIsClassicServer())
			{
				UserName.SetWindowSizeRel(1.0000000, 0.0000000, -43, 14);
				UserName.SetAnchor(m_Windowname, "TopLeft", "TopLeft", 30, 8);
			}
			else
			{
				UserName.SetWindowSizeRel(1.0000000, 0.0000000, -33, 14);
				UserName.SetAnchor(m_Windowname, "TopLeft", "TopLeft", 18, 8);
			}
		}
		else
		{
			texMark.ShowWindow();
			texMark.SetTexture(("l2ui_Ct1.TargetStatusWnd_DF_mark_0" $ string((Class'NWindow.UIDATA_PARTY'.static.GetMemberTacticalSign(m_targetID) - 1))));
			UserName.SetWindowSizeRel(1.0000000, 0.0000000, -54, 14);
			UserName.SetAnchor(m_Windowname, "TopLeft", "TopLeft", 36, 8);
		}
	}
	else
	{
		PlayerID = Class'NWindow.UIDATA_PLAYER'.static.GetPlayerID();
		GetPetInfo(PetInfo);
		PetID = Info.nID;
		bIsHPShowableNPC = Class'NWindow.UIDATA_TARGET'.static.IsHPShowableNPC();
		if((((((Info.bNpc && !Info.bPet) && bIsHPShowableNPC) || ((PlayerID > 0) && (m_targetID == PlayerID))) || ((Info.bNpc && Info.bPet) && (m_targetID == PetID))) || (Info.bNpc && bIsHPShowableNPC)))
		{
			if(IsAllWhiteID(Info.nClassID))
			{
				Name = Info.Name;
				NameRank = "";
				UserName.SetName(Name, NCT_Normal, TA_Center);
				RankName.SetName(NameRank, NCT_Normal, TA_Center);
				if(!IsNoBarID(Info.nClassID))
				{
					bShowHPBar = true;
					UpdateHPBar(Info.nCurHP, Info.nMaxHP);
				}
			}
			else
			{
				Name = Info.Name;
				NameRank = "";
				UserName.SetNameWithColor(Name, NCT_Normal, TA_Center, TargetNameColor);
				RankName.SetName(NameRank, NCT_Normal, TA_Center);
				if((Info.nMaxHP > INT64(0)))
				{
					bShowHPBar = true;
					UpdateHPBar(Info.nCurHP, Info.nMaxHP);
				}
				if(!(Info.bNpc && !Info.bPet))
				{
					if((Info.nMaxMP > 0))
					{
						bShowMPBar = true;
						UpdateMPBar(Info.nCurMP, Info.nMaxMP);
					}
				}
				if((getInstanceUIData().GetIsLiveServer() && Class'NWindow.UIDATA_PLAYER'.static.IsInDethrone()))
				{
					GetPlayerInfo(myInfo);
					if((myInfo.nWorldID == Info.nWorldID))
					{
						warMarkTextureName = "";
					}
					else if(Class'NWindow.UIDATA_USER'.static.IsDethroneComrade(Info.nID))
					{
						warMarkTextureName = GetServerMarkNameTarget(Info.nWorldID, false);
					}
					else if(Class'NWindow.UIDATA_USER'.static.IsDethroneEnemy(Info.nID))
					{
						warMarkTextureName = GetServerMarkNameTarget(Info.nWorldID, true);
					}
					Debug(("디스론 타겟 " @ GetServerMarkNameTarget(Info.nWorldID, true)));  // EN?: Disron Target
					Debug(("nWorldID" @ string(Info.nWorldID)));
					Debug(("warMarkTextureName" @ warMarkTextureName));
					Debug(("class'UIDATA_USER'.static.IsDethroneComrade(info.nWorldID)" @ string(Class'NWindow.UIDATA_USER'.static.IsDethroneComrade(Info.nWorldID))));
					if((warMarkTextureName == ""))
					{
						SiegeMark.HideWindow();
					}
					else
					{
						SiegeMark.SetTexture(warMarkTextureName);
						SiegeMark.ShowWindow();
					}
				}
			}
		}
		else
		{
			Name = Info.Name;
			if(WantHideName)
			{
				RankName.HideWindow();
			}
			if(Info.bNpc)
			{
				NameRank = "";
				g_NameStr = "";
			}
			else
			{
				if(getInstanceUIData().GetIsLiveServer())
				{
					NameRank = "";
				}
				else
				{
					NameRank = GetUserRankString(Info.nUserRank);
				}
				g_NameStr = Name;
				if((getInstanceUIData().GetIsLiveServer() && Class'NWindow.UIDATA_PLAYER'.static.IsInDethrone()))
				{
					GetPlayerInfo(myInfo);
					if((myInfo.nWorldID == Info.nWorldID))
					{
						warMarkTextureName = "";
					}
					else if(Class'NWindow.UIDATA_USER'.static.IsDethroneComrade(Info.nID))
					{
						warMarkTextureName = GetServerMarkNameTarget(Info.nWorldID, false);
					}
					else if(Class'NWindow.UIDATA_USER'.static.IsDethroneEnemy(Info.nID))
					{
						warMarkTextureName = GetServerMarkNameTarget(Info.nWorldID, true);
					}
					Debug(("디스론 타겟 " @ GetServerMarkNameTarget(Info.nWorldID, true)));  // EN?: Disron Target
					Debug(("nWorldID" @ string(Info.nWorldID)));
					Debug(("warMarkTextureName" @ warMarkTextureName));
					Debug(("class'UIDATA_USER'.static.IsDethroneComrade(info.nWorldID)" @ string(Class'NWindow.UIDATA_USER'.static.IsDethroneComrade(Info.nWorldID))));
					if((warMarkTextureName == ""))
					{
						SiegeMark.HideWindow();
					}
					else
					{
						SiegeMark.SetTexture(warMarkTextureName);
						SiegeMark.ShowWindow();
					}
				}
			}
			UserName.SetName(Name, NCT_Normal, TA_Center);
			RankName.SetName(NameRank, NCT_Normal, TA_Center);
		}
		if(m_bExpand)
		{
			if((Info.bNpc && (0 >= Info.nMasterID)))
			{
				if(Class'NWindow.UIDATA_NPC'.static.GetNpcProperty(Info.nClassID, arrNpcInfo))
				{
					bShowNpcInfo = true;
					if(IsTargetChanged)
					{
						UpdateNpcInfoTree(arrNpcInfo);
					}
				}
			}
			else
			{
				bShowPledgeInfo = true;
				if((Info.nClanID > 0))
				{
					PledgeName = Class'NWindow.UIDATA_CLAN'.static.GetName(Info.nClanID);
					PledgeNameColor.R = 176;
					PledgeNameColor.G = 152;
					PledgeNameColor.B = 121;
					if((((PledgeName != "") && Class'NWindow.UIDATA_USER'.static.GetClanType(m_targetID, clanType)) && Class'NWindow.UIDATA_CLAN'.static.GetNameValue(Info.nClanID, clanNameValue)))
					{
						if((clanType == -1))
						{
							PledgeNameColor.R = 209;
							PledgeNameColor.G = 167;
							PledgeNameColor.B = 2;
						}
						else if((clanNameValue > 0))
						{
							PledgeNameColor.R = 0;
							PledgeNameColor.G = 130;
							PledgeNameColor.B = 255;
						}
						else if((clanNameValue < 0))
						{
							PledgeNameColor.R = 255;
							PledgeNameColor.G = 0;
							PledgeNameColor.B = 0;
						}
					}
					if(Class'NWindow.UIDATA_CLAN'.static.GetCrestTexture(Info.nClanID, PledgeCrestTexture))
					{
						bShowPledgeTex = true;
						texPledgeCrest.SetTextureWithObject(PledgeCrestTexture);
					}
					else
					{
						bShowPledgeTex = false;
					}
					strTmp = Class'NWindow.UIDATA_CLAN'.static.GetAllianceName(Info.nClanID);
					if((Len(strTmp) > 0))
					{
						PledgeAllianceName = strTmp;
						PledgeAllianceNameColor.R = 176;
						PledgeAllianceNameColor.G = 155;
						PledgeAllianceNameColor.B = 121;
						if(Class'NWindow.UIDATA_CLAN'.static.GetAllianceCrestTexture(Info.nClanID, PledgeAllianceCrestTexture))
						{
							bShowPledgeAllianceTex = true;
							texPledgeAllianceCrest.SetTextureWithObject(PledgeAllianceCrestTexture);
						}
						else
						{
							bShowPledgeAllianceTex = false;
						}
					}
				}
			}
		}
	}
	if(((!Me.IsShowWindow() && (GetGameStateName() != "SPECIALCAMERASTATE")) && (GetGameStateName() != "COLLECTIONSTATE")))
	{
		Me.ShowWindow();
		Me.BringToFront();
		SetExpandMode(m_bExpand, false);
	}
	if((ContextMenu(GetScript("ContextMenu")).getContextEventInfo().Id > 0))
	{
		ContextMenu(GetScript("ContextMenu")).makeContextMenu();
		ContextMenu(GetScript("ContextMenu")).clearInfo();
	}
	if((bShowHPBar && (GetGameStateName() != "SPECIALCAMERASTATE")))
	{
		barHP.ShowWindow();
	}
	else
	{
		barHP.HideWindow();
	}
	if((bShowMPBar && (GetGameStateName() != "SPECIALCAMERASTATE")))
	{
		barMP.ShowWindow();
	}
	else
	{
		barMP.HideWindow();
	}
	if((Info.nClanID < 0))
	{
		bShowPledgeInfo = false;
	}
	if(bShowPledgeInfo)
	{
		if((!WantHideName && (GetGameStateName() != "SPECIALCAMERASTATE")))
		{
			txtPledge.ShowWindow();
			txtAlliance.ShowWindow();
			txtPledgeName.ShowWindow();
			txtPledgeAllianceName.ShowWindow();
			txtPledgeName.SetText(PledgeName);
			txtPledgeAllianceName.SetText(PledgeAllianceName);
			txtPledgeName.SetTextColor(PledgeNameColor);
			txtPledgeAllianceName.SetTextColor(PledgeAllianceNameColor);
			textRect = txtPledge.GetRect();
			if(bShowPledgeTex)
			{
				texPledgeCrest.ShowWindow();
				if(getInstanceUIData().GetIsLiveServer())
				{
					texPledgeCrest.MoveTo(((textRect.nX + textRect.nWidth) + 3), ((rectWnd.nY + 52) + 1));
				}
				else
				{
					texPledgeCrest.MoveTo(((textRect.nX + textRect.nWidth) + 4), (textRect.nY + 1));
				}
				if(getInstanceUIData().GetIsLiveServer())
				{
					txtPledgeName.MoveTo(((textRect.nX + textRect.nWidth) + 20), (rectWnd.nY + 52));
				}
				else
				{
					txtPledgeName.MoveTo(((textRect.nX + textRect.nWidth) + 33), textRect.nY);
				}
			}
			else
			{
				texPledgeCrest.HideWindow();
				if(getInstanceUIData().GetIsLiveServer())
				{
					txtPledgeName.MoveTo(((textRect.nX + textRect.nWidth) + 2), (rectWnd.nY + 52));
				}
				else
				{
					txtPledgeName.MoveTo(((textRect.nX + textRect.nWidth) + 6), textRect.nY);
				}
			}
			textRect = txtAlliance.GetRect();
			if(bShowPledgeAllianceTex)
			{
				texPledgeAllianceCrest.ShowWindow();
				if(getInstanceUIData().GetIsLiveServer())
				{
					texPledgeAllianceCrest.MoveTo(((textRect.nX + textRect.nWidth) + 3), (rectWnd.nY + 67));
					txtPledgeAllianceName.MoveTo(((textRect.nX + textRect.nWidth) + 12), (rectWnd.nY + 67));
				}
				else
				{
					txtPledgeAllianceName.MoveTo(((textRect.nX + textRect.nWidth) + 10), (rectWnd.nY + 72));
				}
			}
			else
			{
				texPledgeAllianceCrest.HideWindow();
				if(getInstanceUIData().GetIsLiveServer())
				{
					txtPledgeAllianceName.MoveTo(((textRect.nX + textRect.nWidth) + 2), (rectWnd.nY + 67));
				}
				else
				{
					txtPledgeAllianceName.MoveTo(((textRect.nX + textRect.nWidth) + 6), textRect.nY);
				}
			}
		}
		else
		{
			txtPledge.HideWindow();
			txtAlliance.HideWindow();
			txtPledgeName.HideWindow();
			txtPledgeAllianceName.HideWindow();
			texPledgeCrest.HideWindow();
			texPledgeAllianceCrest.HideWindow();
		}
	}
	else
	{
		txtPledge.HideWindow();
		txtAlliance.HideWindow();
		txtPledgeName.HideWindow();
		txtPledgeAllianceName.HideWindow();
		texPledgeCrest.HideWindow();
		texPledgeAllianceCrest.HideWindow();
	}
	if((bShowNpcInfo && (GetGameStateName() != "SPECIALCAMERASTATE")))
	{
		NpcInfo.ShowWindow();
		NpcInfo.ShowScrollBar(false);
	}
	else
	{
		NpcInfo.HideWindow();
	}
	UpdateMaxHPBlockEffect();
	RepositionNamePosition();
	return;
}

function HandleUpdateWarMark(string param)
{
	local int TargetWarMark;
	local string warMarkTextureName;

	if(Class'NWindow.UIDATA_PLAYER'.static.IsInDethrone())
	{
		return;
	}
	ParseInt(param, "TargetWarMark", TargetWarMark);
	warMarkTextureName = GetWarMarkTargetTextureByWarMarkType(WARMARKTYPE(TargetWarMark));
	if((warMarkTextureName == ""))
	{
		SiegeMark.HideWindow();
	}
	else
	{
		SiegeMark.SetTexture(warMarkTextureName);
		SiegeMark.ShowWindow();
	}
	RepositionNamePosition();
	return;
}

function HandleUpdateTargetDead(string param)
{
	local int TargetDead, targetID;

	ParseInt(param, "TargetDead", TargetDead);
	ParseInt(param, "TargetID", targetID);
	if(getInstanceUIData().GetIsLiveServer())
	{
		switch(TargetDead)
		{
			case 0:
				DeathTexture.HideWindow();
				break;
			case 1:
				DeathTexture.ShowWindow();
				break;
			default:
				break;
		}
	}
	return;
}

function RepositionNamePosition()
{
	local int sizeRe, anchorX;

	sizeRe = -33;
	anchorX = 18;
	if((texMark.IsShowWindow() && SiegeMark.IsShowWindow()))
	{
		sizeRe = -80;
		anchorX = 62;
		if(getInstanceUIData().GetIsClassicServer())
		{
			SiegeMark.SetAnchor(m_Windowname, "TopLeft", "TopLeft", 52, 5);
		}
		else
		{
			SiegeMark.SetAnchor(m_Windowname, "TopLeft", "TopLeft", 44, 5);
		}
	}
	else if(texMark.IsShowWindow())
	{
		sizeRe = -54;
		anchorX = 36;
	}
	else if(SiegeMark.IsShowWindow())
	{
		sizeRe = -54;
		anchorX = 36;
		if(getInstanceUIData().GetIsClassicServer())
		{
			SiegeMark.SetAnchor(m_Windowname, "TopLeft", "TopLeft", 29, 5);
		}
		else
		{
			SiegeMark.SetAnchor(m_Windowname, "TopLeft", "TopLeft", 21, 5);
		}
	}
	if(getInstanceUIData().GetIsClassicServer())
	{
		UserName.SetWindowSizeRel(1.0000000, 0.0000000, -73, 14);
		UserName.SetAnchor(m_Windowname, "TopLeft", "TopLeft", 30, 8);
	}
	else
	{
		UserName.SetWindowSizeRel(1.0000000, 0.0000000, sizeRe, 14);
		UserName.SetAnchor(m_Windowname, "TopLeft", "TopLeft", anchorX, 8);
	}
	return;
}

function Color GetTargetNameColor(int TargetLevelDiff)
{
	local Color OutColor;

	OutColor.A = 255;
	if(getInstanceUIData().GetIsClassicServer())
	{
		if((TargetLevelDiff <= -15))
		{
			OutColor.R = 255;
			OutColor.G = 0;
			OutColor.B = 0;
		}
		else if(((TargetLevelDiff > -15) && (TargetLevelDiff <= -10)))
		{
			OutColor.R = 255;
			OutColor.G = 145;
			OutColor.B = 145;
		}
		else if(((TargetLevelDiff > -10) && (TargetLevelDiff <= -5)))
		{
			OutColor.R = 250;
			OutColor.G = 254;
			OutColor.B = 145;
		}
		else if(((TargetLevelDiff > -5) && (TargetLevelDiff <= 14)))
		{
			OutColor.R = 230;
			OutColor.G = 230;
			OutColor.B = 230;
		}
		else if((TargetLevelDiff > 14))
		{
			OutColor.R = 30;
			OutColor.G = 100;
			OutColor.B = 200;
		}
	}
	else if((TargetLevelDiff <= -11))
	{
		OutColor.R = 255;
		OutColor.G = 0;
		OutColor.B = 0;
	}
	else if(((TargetLevelDiff > -11) && (TargetLevelDiff <= -6)))
	{
		OutColor.R = 255;
		OutColor.G = 145;
		OutColor.B = 145;
	}
	else if(((TargetLevelDiff > -6) && (TargetLevelDiff <= -3)))
	{
		OutColor.R = 250;
		OutColor.G = 254;
		OutColor.B = 145;
	}
	else if(((TargetLevelDiff > -3) && (TargetLevelDiff <= 2)))
	{
		OutColor.R = 230;
		OutColor.G = 230;
		OutColor.B = 230;
	}
	else if(((TargetLevelDiff > 2) && (TargetLevelDiff <= 5)))
	{
		OutColor.R = 162;
		OutColor.G = 255;
		OutColor.B = 171;
	}
	else if(((TargetLevelDiff > 5) && (TargetLevelDiff <= 10)))
	{
		OutColor.R = 162;
		OutColor.G = 168;
		OutColor.B = 252;
	}
	else if((TargetLevelDiff > 10))
	{
		OutColor.R = 30;
		OutColor.G = 100;
		OutColor.B = 200;
	}
	return OutColor;
}

function SetExpandMode(bool bExpand, bool bUseTargetUpdate)
{
	local int nWndWidth, nWndHeight;

	Me.GetWindowSize(nWndWidth, nWndHeight);
	m_bExpand = bExpand;
	if(bUseTargetUpdate)
	{
		m_targetID = -1;
		HandleTargetUpdate(true);
	}
	if(bExpand)
	{
		btnExpand.ShowWindow();
		btnContract.HideWindow();
		if(getInstanceUIData().GetIsLiveServer())
		{
			Me.SetWindowSize(nWndWidth, 86);
		}
		else
		{
			Me.SetWindowSize(nWndWidth, 102);
		}
		barSkillProgressEff1_Center.SetWindowSizeRel(1.0000000, 0.4000000, -35, 0);
		barSkillProgressEff2_Center.SetWindowSizeRel(1.0000000, 0.4000000, -35, 0);
	}
	else
	{
		btnExpand.HideWindow();
		btnContract.ShowWindow();
		if(getInstanceUIData().GetIsLiveServer())
		{
			Me.SetWindowSize(nWndWidth, 52);
		}
		else
		{
			Me.SetWindowSize(nWndWidth, 58);
		}
		barSkillProgressEff1_Center.SetWindowSizeRel(1.0000000, 0.7000000, -35, 0);
		barSkillProgressEff2_Center.SetWindowSizeRel(1.0000000, 0.7000000, -35, 0);
	}
	SetINIInt(m_Windowname, "e", boolToNum(bExpand), "WindowsInfo.ini");
	return;
}

function UpdateHPBar(INT64 Hp, INT64 MaxHP)
{
	if((MaxHP > INT64(0)))
	{
		barHP.SetPoint(Hp, MaxHP);
	}
	else
	{
		barHP.HideWindow();
	}
	return;
}

function UpdateMPBar(int MP, int maxMP)
{
	if((maxMP > 0))
	{
		barMP.SetPoint(INT64(MP), INT64(maxMP));
	}
	else
	{
		barMP.HideWindow();
	}
	return;
}

function UpdateNpcInfoTree(array<int> arrNpcInfo)
{
	local int i, SkillID, SkillLevel, CharInfoNumMaxOneLine;
	local string strNodeName;
	local XMLTreeNodeInfo infNode;
	local XMLTreeNodeItemInfo infNodeItem;
	local XMLTreeNodeInfo infNodeClear;
	local XMLTreeNodeItemInfo infNodeItemClear;

	CharInfoNumMaxOneLine = 10;
	NpcInfo.Clear();
	infNode.strName = "root";
	strNodeName = NpcInfo.InsertNode("", infNode);
	if((Len(strNodeName) < 1))
	{
		return;
	}
	i = 0;
	while((i < arrNpcInfo.Length))
	{
		SkillID = arrNpcInfo[i];
		SkillLevel = arrNpcInfo[(i + 1)];
		infNode = infNodeClear;
		infNode.nOffSetX = (int((float((i / 2)) % float(CharInfoNumMaxOneLine))) * 18);
		if(((float((i / 2)) % float(CharInfoNumMaxOneLine)) == 0.0000000))
		{
			if((i > 0))
			{
				infNode.nOffSetY = 3;
			}
			else
			{
				infNode.nOffSetY = 0;
			}
		}
		else
		{
			infNode.nOffSetY = -15;
		}
		infNode.strName = ("" $ string((i / 2)));
		infNode.bShowButton = 0;
		infNode.ToolTip = SetNpcInfoTooltip(SkillID, SkillLevel);
		strNodeName = NpcInfo.InsertNode("root", infNode);
		if((Len(strNodeName) < 1))
		{
			Log(("ERROR: Can't insert node. Name: " $ infNode.strName));
			return;
		}
		infNode.ToolTip.DrawList.Remove(0, infNode.ToolTip.DrawList.Length);
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXTURE;
		infNodeItem.u_nTextureWidth = 15;
		infNodeItem.u_nTextureHeight = 15;
		infNodeItem.u_nTextureUWidth = 32;
		infNodeItem.u_nTextureUHeight = 32;
		infNodeItem.u_strTexture = Class'NWindow.UIDATA_SKILL'.static.GetIconName(GetItemID(SkillID), SkillLevel, 0);
		NpcInfo.InsertNodeItem(strNodeName, infNodeItem);
		(i += 2);
	}
	return;
}

function CustomTooltip SetNpcInfoTooltip(int Id, int Level)
{
	local CustomTooltip ToolTip;
	local DrawItemInfo Info, infoClear;
	local ItemInfo item;
	local ItemID cID;

	cID = GetItemID(Id);
	item.Name = Class'NWindow.UIDATA_SKILL'.static.GetName(cID, Level, 0);
	item.Description = Class'NWindow.UIDATA_SKILL'.static.GetDescription(cID, Level, 0);
	ToolTip.DrawList.Length = 1;
	Info = infoClear;
	Info.eType = DIT_TEXT;
	Info.t_bDrawOneLine = true;
	Info.t_strText = item.Name;
	ToolTip.DrawList[0] = Info;
	if((Len(item.Description) > 0))
	{
		ToolTip.MinimumWidth = 144;
		ToolTip.DrawList.Length = 2;
		Info = infoClear;
		Info.eType = DIT_TEXT;
		Info.nOffSetY = 6;
		Info.bLineBreak = true;
		Info.t_color.R = 178;
		Info.t_color.G = 190;
		Info.t_color.B = 207;
		Info.t_color.A = 255;
		Info.t_strText = item.Description;
		ToolTip.DrawList[1] = Info;
	}
	return ToolTip;
}

function bool IsAllWhiteID(int m_targetID)
{
	local bool bIsAllWhiteName;

	bIsAllWhiteName = false;
	switch(m_targetID)
	{
		case 12775:
		case 12776:
		case 12778:
		case 12779:
		case 13016:
		case 13017:
		case 13031:
		case 13032:
		case 13033:
		case 13034:
		case 13035:
		case 13036:
		case 13098:
		case 13120:
		case 13121:
		case 13122:
		case 13123:
		case 13124:
		case 13271:
		case 13272:
		case 13273:
		case 13274:
		case 13275:
		case 13276:
		case 13277:
		case 13278:
		case 13187:
		case 13188:
		case 13189:
		case 13190:
		case 13191:
		case 13192:
		case 13286:
		case 13287:
		case 13288:
		case 13289:
		case 13290:
		case 13291:
		case 13292:
		case 13342:
		case 13343:
		case 13344:
		case 13345:
		case 13346:
		case 13347:
		case 13348:
		case 13349:
		case 13400:
		case 13401:
		case 13402:
		case 13404:
		case 13405:
		case 13406:
		case 26089:
		case 13419:
		case 13420:
		case 13421:
		case 13422:
		case 26091:
		case 26248:
		case 13551:
		case 13552:
		case 34499:
		case 24330:
		case 24332:
		case 24331:
		case 24333:
		case 24366:
		case 24367:
		case 24368:
		case 24369:
		case 24370:
		case 24371:
		case 18371:
		case 18372:
		case 18389:
		case 18407:
		case 18394:
		case 18395:
		case 18396:
		case 18397:
		case 34168:
		case 34170:
		case 34167:
		case 18458:
		case 18459:
		case 34143:
		case 34144:
		case 34145:
		case 18440:
		case 18441:
		case 26458:
		case 13608:
		case 13609:
		case 13610:
		case 18583:
		case 18584:
		case 18585:
		case 18586:
		case 18587:
		case 18588:
		case 18589:
		case 18590:
		case 18591:
		case 18592:
		case 18593:
		case 18594:
		case 18595:
		case 18598:
		case 18599:
		case 18600:
		case 18601:
		case 18602:
		case 29398:
		case 19846:
		case 19847:
		case 19848:
		case 19866:
		case 18699:
		case 18700:
		case 19011:
		case 19012:
		case 19013:
		case 19014:
		case 19015:
		case 19016:
		case 19017:
		case 19020:
		case 19849:
		case 19850:
		case 19851:
		case 19852:
		case 19853:
		case 13635:
		case 19081:
		case 19082:
		case 19083:
		case 19084:
		case 13636:
		case 19886:
		case 19887:
		case 19888:
		case 19889:
		case 19890:
		case 19891:
		case 19892:
		case 19893:
		case 19895:
		case 19896:
		case 19897:
		case 18010:
		case 18011:
		case 18012:
		case 18013:
		case 18957:
		case 18958:
		case 18959:
		case 18978:
		case 18996:
		case 18997:
		case 18998:
		case 19284:
			bIsAllWhiteName = true;
			break;
		default:
			break;
	}
	if((GetServerType() == 1))
	{
		switch(m_targetID)
		{
			case 8696:
			case 8697:
			case 8699:
			case 8700:
			case 8701:
			case 8702:
				bIsAllWhiteName = true;
				break;
			default:
				break;
		}
	}
	else if((GetServerType() == 2))
	{
		switch(m_targetID)
		{
			case 9051:
			case 9052:
			case 9054:
			case 9055:
			case 9056:
			case 9057:
				bIsAllWhiteName = true;
				break;
			default:
				break;
		}
	}
	return bIsAllWhiteName;
}

function bool IsNoBarID(int m_targetID)
{
	local bool bIsNoBarName;

	bIsNoBarName = false;
	switch(m_targetID)
	{
		case 13036:
		case 13098:
			bIsNoBarName = true;
			break;
		default:
			break;
	}
	return bIsNoBarName;
}

function HandleTargetSpelledList(string param)
{
	local int i, Max, B, targetID;
	local StatusIconInfo Info;

	ClearAll();
	ParseInt(param, "ID", targetID);
	ParseInt(param, "Max", Max);
	i = 0;
	while((i < Max))
	{
		ParseInt(param, ("ClassID_" $ string(i)), Info.Id.ClassID);
		ParseInt(param, ("Level_" $ string(i)), Info.Level);
		ParseInt(param, ("SubLevel_" $ string(i)), Info.SubLevel);
		if(IsIconHide(Info.Id, Info.Level, Info.SubLevel))
		{
			i++;
			continue;
		}
		if(Class'NWindow.UIDATA_SKILL'.static.IsToppingSkill(Info.Id, Info.Level, Info.SubLevel))
		{
			i++;
			continue;
		}
		ParseInt(param, ("Sec_" $ string(i)), Info.RemainTime);
		ParseInt(param, ("OwnerShip_" $ string(i)), B);
		Info.Name = Class'NWindow.UIDATA_SKILL'.static.GetName(Info.Id, Info.Level, Info.SubLevel);
		Info.IconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(Info.Id, Info.Level, Info.SubLevel);
		Info.Description = Class'NWindow.UIDATA_SKILL'.static.GetDescription(Info.Id, Info.Level, Info.SubLevel);
		Info.IconPanel = Class'NWindow.UIDATA_SKILL'.static.GetIconPanel(Info.Id, Info.Level, Info.SubLevel);
		if((B == 0))
		{
			Info.bOwnership = false;
		}
		else
		{
			Info.bOwnership = true;
		}
		Info = SelectTexture(Info);
		i++;
	}
	MyBuffDraw();
	OtherBuffDraw();
	MyDebuffDraw();
	OtherDebuffDraw();
	moveBuffWndMoreView2();
	return;
}

function MyBuffDraw()
{
	local int i, Length;
	local array<StatusIconInfo> temp;
	local TargetStatusBuff1Wnd Script;

	Script = TargetStatusBuff1Wnd(GetScript("TargetStatusBuff1Wnd"));
	Script.ResetBuffIcon();
	Length = arrMyBuff.Length;
	if(((Length > 0) && (Length < 9)))
	{
		showBuffMoreBtn(false, 1);
		StatusIcons.AddRow();
		i = 0;
		while((i < Length))
		{
			StatusIcons.AddCol(LineCount, arrMyBuff[i]);
			i++;
		}
		LineCount++;
	}
	else if((Length >= 9))
	{
		showBuffMoreBtn(true, 1);
		StatusIcons.AddRow();
		i = 0;
		while((i < Length))
		{
			if((i > (Length - 9)))
			{
				StatusIcons.AddCol(LineCount, arrMyBuff[i]);
				i++;
				continue;
			}
			temp.Insert(temp.Length, 1);
			temp[(temp.Length - 1)] = arrMyBuff[i];
			i++;
		}
		Script.showBuff(temp);
		LineCount++;
	}
	return;
}

function OtherBuffDraw()
{
	local int i;

	if((arrOtherBuff.Length > 0))
	{
		StatusIcons.AddRow();
		i = 0;
		while((i < arrOtherBuff.Length))
		{
			if((i > (arrOtherBuff.Length - 13)))
			{
				arrOtherBuff[i].bHideRemainTime = true;
				StatusIcons.AddCol(LineCount, arrOtherBuff[i]);
			}
			i++;
		}
		LineCount++;
	}
	return;
}

function MyDebuffDraw()
{
	local int i, Length;
	local array<StatusIconInfo> temp;
	local TargetStatusBuff2Wnd Script;

	Script = TargetStatusBuff2Wnd(GetScript("TargetStatusBuff2Wnd"));
	Script.ResetBuffIcon();
	Length = arrMyDebuff.Length;
	if(((Length > 0) && (Length < 9)))
	{
		showBuffMoreBtn(false, 2);
		StatusIcons.AddRow();
		i = 0;
		while((i < Length))
		{
			StatusIcons.AddCol(LineCount, arrMyDebuff[i]);
			i++;
		}
		LineCount++;
	}
	else if((Length >= 9))
	{
		showBuffMoreBtn(true, 2);
		StatusIcons.AddRow();
		i = 0;
		while((i < Length))
		{
			if((i > (Length - 9)))
			{
				StatusIcons.AddCol(LineCount, arrMyDebuff[i]);
				i++;
				continue;
			}
			temp.Insert(temp.Length, 1);
			temp[(temp.Length - 1)] = arrMyDebuff[i];
			i++;
		}
		Script.showBuff(temp);
		LineCount++;
	}
	return;
}

function OtherDebuffDraw()
{
	local int i, Num;

	Num = 0;
	if((arrOtherDebuff.Length > 0))
	{
		StatusIcons.AddRow();
		i = 0;
		while((i < arrOtherDebuff.Length))
		{
			if((i > (arrOtherDebuff.Length - 25)))
			{
				if((Num == 12))
				{
					StatusIcons.AddRow();
					LineCount++;
				}
				Num++;
				arrOtherDebuff[i].bHideRemainTime = true;
				StatusIcons.AddCol(LineCount, arrOtherDebuff[i]);
			}
			i++;
		}
		LineCount++;
	}
	return;
}

function ClearAll()
{
	LineCount = 0;
	showBuffMoreBtn(false, 1);
	showBuffMoreBtn(false, 2);
	ResetArray();
	ResetBuffIcon();
	return;
}

function ResetArray()
{
	arrMyBuff.Remove(0, arrMyBuff.Length);
	arrOtherBuff.Remove(0, arrOtherBuff.Length);
	arrMyDebuff.Remove(0, arrMyDebuff.Length);
	arrOtherDebuff.Remove(0, arrOtherDebuff.Length);
	return;
}

function ResetBuffIcon()
{
	StatusIcons.Clear();
	return;
}

function StatusIconInfo SelectTexture(StatusIconInfo Info)
{
	Info.bShow = true;
	if((GetDebuffType(Info.Id, Info.Level, Info.SubLevel) != 0))
	{
		if(Info.bOwnership)
		{
			Info.Size = 24;
			Info.BackTex = "L2UI_CT1.Buff.DeBuffFrame_24";
			arrMyDebuff.Insert(arrMyDebuff.Length, 1);
			arrMyDebuff[(arrMyDebuff.Length - 1)] = Info;
		}
		else
		{
			Info.Size = 16;
			Info.BackTex = "L2UI_CT1.Buff.DeBuffFrame_16";
			arrOtherDebuff.Insert(arrOtherDebuff.Length, 1);
			arrOtherDebuff[(arrOtherDebuff.Length - 1)] = Info;
		}
	}
	else if((GetIndexByIsMagic(Info) == 5))
	{
		if(Info.bOwnership)
		{
			Info.Size = 24;
			Info.BackTex = "L2UI_CT1.Buff.BuffFrame_24_3";
			arrMyBuff.Insert(arrMyBuff.Length, 1);
			arrMyBuff[(arrMyBuff.Length - 1)] = Info;
		}
		else
		{
			Info.Size = 16;
			Info.BackTex = "L2UI_CT1.Buff.BuffFrame_16_3";
			arrOtherBuff.Insert(arrOtherBuff.Length, 1);
			arrOtherBuff[(arrOtherBuff.Length - 1)] = Info;
		}
	}
	else if((GetIndexByIsMagic(Info) == 3))
	{
		if(Info.bOwnership)
		{
			Info.Size = 24;
			Info.BackTex = "L2UI_CT1.Buff.BuffFrame_24_2";
			arrMyBuff.Insert(arrMyBuff.Length, 1);
			arrMyBuff[(arrMyBuff.Length - 1)] = Info;
		}
		else
		{
			Info.Size = 16;
			Info.BackTex = "L2UI_CT1.Buff.BuffFrame_16_2";
			arrOtherBuff.Insert(arrOtherBuff.Length, 1);
			arrOtherBuff[(arrOtherBuff.Length - 1)] = Info;
		}
	}
	else if(Info.bOwnership)
	{
		Info.Size = 24;
		Info.BackTex = "L2UI_CT1.Buff.BuffFrame_24_1";
		arrMyBuff.Insert(arrMyBuff.Length, 1);
		arrMyBuff[(arrMyBuff.Length - 1)] = Info;
	}
	else
	{
		Info.Size = 16;
		Info.BackTex = "L2UI_CT1.Buff.BuffFrame_16_1";
		arrOtherBuff.Insert(arrOtherBuff.Length, 1);
		arrOtherBuff[(arrOtherBuff.Length - 1)] = Info;
	}
	return Info;
}

function showBuffMoreBtn(bool B, int N)
{
	if((B == true))
	{
		GetButtonHandle(((m_Windowname $ ".BuffWnd.btnBuffMoreView") $ string(N))).ShowWindow();
	}
	else
	{
		GetButtonHandle(((m_Windowname $ ".BuffWnd.btnBuffMoreView") $ string(N))).HideWindow();
	}
	return;
}

function moveBuffWndMoreView2()
{
	if((arrMyBuff.Length > 0))
	{
		yPosView2 = 26;
	}
	else
	{
		yPosView2 = 0;
	}
	if((arrOtherBuff.Length > 0))
	{
		yPosView2 = (yPosView2 + 18);
	}
	btnBuffMoreView2.MoveTo(BuffWnd.GetRect().nX, (BuffWnd.GetRect().nY + yPosView2));
	return;
}

event OnMouseOver(WindowHandle W)
{
	if((btnBuffMoreView1 == W))
	{
		TargetStatusBuff1Wnd.ShowWindow();
	}
	else if((btnBuffMoreView2 == W))
	{
		TargetStatusBuff2Wnd.ShowWindow();
	}
	return;
}

event OnMouseOut(WindowHandle W)
{
	if((btnBuffMoreView1 == W))
	{
		TargetStatusBuff1Wnd.HideWindow();
	}
	else if((btnBuffMoreView2 == W))
	{
		TargetStatusBuff2Wnd.HideWindow();
	}
	return;
}

function HandleTargetSkillInfo(string param)
{
	local int bIsHostile, bUseSlot1;
	local float fTotalTimeSlot1, fElapsedTimeSlot1;
	local string SkillNameSlot1;
	local int Resistcast1, bUseSlot2;
	local float fTotalTimeSlot2, fElapsedTimeSlot2;
	local string SkillNameSlot2;
	local int Resistcast2;
	local Color White, Red;

	Red.R = 255;
	Red.G = 0;
	Red.B = 0;
	Red.A = 255;
	White.R = 230;
	White.G = 230;
	White.B = 230;
	White.A = 255;
	ParseInt(param, "bIsHostile", bIsHostile);
	if((bIsHostile == 0))
	{
		strSelectTarget = "Friendly";
	}
	else
	{
		strSelectTarget = "Enemy";
	}
	ParseInt(param, "bUseSlot1", bUseSlot1);
	ParseFloat(param, "fTotalTimeSlot1", fTotalTimeSlot1);
	ParseFloat(param, "fElapsedTimeSlot1", fElapsedTimeSlot1);
	ParseString(param, "SkillNameSlot1", SkillNameSlot1);
	ParseInt(param, "ResistCast1", Resistcast1);
	ParseInt(param, "bUseSlot2", bUseSlot2);
	ParseFloat(param, "fTotalTimeSlot2", fTotalTimeSlot2);
	ParseFloat(param, "fElapsedTimeSlot2", fElapsedTimeSlot2);
	ParseString(param, "SkillNameSlot2", SkillNameSlot2);
	ParseInt(param, "ResistCast2", Resistcast2);
	if((GetOptionBool("ScreenInfo", "SkillCastingBox") == false))
	{
		return;
	}
	if((bUseSlot1 != 0))
	{
		if((fTotalTimeSlot1 > 0.0000000))
		{
			Me.KillTimer(5270);
			Me.KillTimer(5272);
			SetTextureBar("Progress", 1);
			SetEffectTexture("Progress", 1);
			showSkillSlot(fTotalTimeSlot1, fElapsedTimeSlot1, 1);
			if((Resistcast1 == 1))
			{
				skillProgressName1.SetNameWithColor(SkillNameSlot1, NCT_Normal, TA_Center, Red);
			}
			else
			{
				skillProgressName1.SetNameWithColor(SkillNameSlot1, NCT_Normal, TA_Center, White);
			}
		}
	}
	else
	{
		skillBarVisible(false, 1);
		barSkillProgress1.Reset();
	}
	if((bUseSlot2 != 0))
	{
		if((fTotalTimeSlot1 > 0.0000000))
		{
			Me.KillTimer(5271);
			Me.KillTimer(5272);
			SetTextureBar("Progress", 2);
			SetEffectTexture("Progress", 2);
			showSkillSlot(fTotalTimeSlot2, fElapsedTimeSlot2, 2);
			if((Resistcast2 == 1))
			{
				skillProgressName2.SetNameWithColor(SkillNameSlot2, NCT_Normal, TA_Center, Red);
			}
			else
			{
				skillProgressName2.SetNameWithColor(SkillNameSlot2, NCT_Normal, TA_Center, White);
			}
		}
	}
	else
	{
		skillBarVisible(false, 2);
		barSkillProgress2.Reset();
	}
	return;
}

function showSkillSlot(float total, float elapsed, int Slot)
{
	skillBarVisible(true, Slot);
	GetProgressCtrlHandle((((((m_Windowname $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgress") $ string(Slot))).Stop();
	GetProgressCtrlHandle((((((m_Windowname $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgress") $ string(Slot))).Reset();
	GetProgressCtrlHandle((((((m_Windowname $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgress") $ string(Slot))).SetProgressTime(int(total));
	GetProgressCtrlHandle((((((m_Windowname $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgress") $ string(Slot))).SetPos(int((total - elapsed)));
	GetProgressCtrlHandle((((((m_Windowname $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgress") $ string(Slot))).Start();
	return;
}

function OnProgressTimeUp(string strID)
{
	if((strID == "barSkillProgress1"))
	{
		SetTextureBar("Success", 1);
		SetEffectTexture("Success", 1);
		Me.SetTimer(5270, 1000);
	}
	else if((strID == "barSkillProgress2"))
	{
		SetTextureBar("Success", 2);
		SetEffectTexture("Success", 2);
		Me.SetTimer(5271, 1000);
	}
	return;
}

function HandleSkillCancel()
{
	SetTextureBar("Failed", 1);
	SetEffectTexture("Failed", 1);
	barSkillProgress1.Stop();
	SetTextureBar("Failed", 2);
	SetEffectTexture("Failed", 2);
	barSkillProgress2.Stop();
	Me.SetTimer(5272, 1000);
	return;
}

function skillBarVisible(bool flag, int Slot)
{
	if((flag == true))
	{
		GetNameCtrlHandle((((((m_Windowname $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "skillProgressName") $ string(Slot))).ShowWindow();
		GetProgressCtrlHandle((((((m_Windowname $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgress") $ string(Slot))).ShowWindow();
		GetTextureHandle(((((((m_Windowname $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgressEff") $ string(Slot)) $ "_Left")).ShowWindow();
		GetTextureHandle(((((((m_Windowname $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgressEff") $ string(Slot)) $ "_Center")).ShowWindow();
		GetTextureHandle(((((((m_Windowname $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgressEff") $ string(Slot)) $ "_Right")).ShowWindow();
	}
	else
	{
		if((Slot == 1))
		{
			barSkillProgress1.Reset();
		}
		else
		{
			barSkillProgress2.Reset();
		}
		GetNameCtrlHandle((((((m_Windowname $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "skillProgressName") $ string(Slot))).HideWindow();
		GetProgressCtrlHandle((((((m_Windowname $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgress") $ string(Slot))).HideWindow();
		GetProgressCtrlHandle((((((m_Windowname $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgress") $ string(Slot))).Reset();
		GetTextureHandle(((((((m_Windowname $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgressEff") $ string(Slot)) $ "_Left")).HideWindow();
		GetTextureHandle(((((((m_Windowname $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgressEff") $ string(Slot)) $ "_Center")).HideWindow();
		GetTextureHandle(((((((m_Windowname $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgressEff") $ string(Slot)) $ "_Right")).HideWindow();
	}
	return;
}

function SetTextureBar(string stateString, int Slot)
{
	GetProgressCtrlHandle((((((m_Windowname $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgress") $ string(Slot))).SetBackTex((((("L2UI_ct1.SkillOperate_DF_" $ strSelectTarget) $ "_") $ stateString) $ "_Bg_Left"), (((("L2UI_ct1.SkillOperate_DF_" $ strSelectTarget) $ "_") $ stateString) $ "_Bg_Center"), (((("L2UI_ct1.SkillOperate_DF_" $ strSelectTarget) $ "_") $ stateString) $ "_Bg_Right"));
	GetProgressCtrlHandle((((((m_Windowname $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgress") $ string(Slot))).SetBarTex((((("L2UI_ct1.SkillOperate_DF_" $ strSelectTarget) $ "_") $ stateString) $ "_Gage_Left"), (((("L2UI_ct1.SkillOperate_DF_" $ strSelectTarget) $ "_") $ stateString) $ "_Gage_Center"), (((("L2UI_ct1.SkillOperate_DF_" $ strSelectTarget) $ "_") $ stateString) $ "_Gage_Right"));
	return;
}

function SetEffectTexture(string stateString, int Slot)
{
	GetTextureHandle(((((((m_Windowname $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgressEff") $ string(Slot)) $ "_Left")).SetTexture((((("L2UI_ct1.SkillOperate_DF_" $ strSelectTarget) $ "_") $ stateString) $ "_Eff_Left"));
	GetTextureHandle(((((((m_Windowname $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgressEff") $ string(Slot)) $ "_Center")).SetTexture((((("L2UI_ct1.SkillOperate_DF_" $ strSelectTarget) $ "_") $ stateString) $ "_Eff_Center"));
	GetTextureHandle(((((((m_Windowname $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgressEff") $ string(Slot)) $ "_Right")).SetTexture((((("L2UI_ct1.SkillOperate_DF_" $ strSelectTarget) $ "_") $ stateString) $ "_Eff_Right"));
	return;
}

function StateBoxShow(bool B)
{
	if((B == true))
	{
		BuffWnd.ShowWindow();
	}
	else
	{
		BuffWnd.HideWindow();
	}
	return;
}

function int GetTargetID()
{
	return m_targetID;
}

function string GetWarMarkTargetTextureByWarMarkType(WARMARKTYPE Type)
{
	switch(Type)
	{
		case TYPE_BlueAttackLeader:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_Blueflagleader";
			break;
		case TYPE_BlueAttackLeaderPenalty:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_Blueflagleader_penalty";
			break;
		case TYPE_BlueSword:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_Bluesword";
			break;
		case TYPE_BlueSwordPenalty:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_Bluesword_penalty";
			break;
		case TYPE_BlueLeader:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_BluecrownLeader";
			break;
		case TYPE_BlueLeaderPenalty:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_BluecrownLeader_Penalty";
			break;
		case TYPE_BlueShield:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_Blueshield";
			break;
		case TYPE_BlueShieldPenalty:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_Blueshield_penalty";
			break;
		case TYPE_RedAttackLeader:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_Redflagleader";
			break;
		case TYPE_RedAttackLeaderPenalty:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_Redflagleader_penalty";
			break;
		case TYPE_RedSword:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_Redsword";
			break;
		case TYPE_RedSwordPenalty:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_Redsword_penalty";
			break;
		case TYPE_RedLeader:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_RedcrownLeader";
			break;
		case TYPE_RedLeaderPenalty:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_RedcrownLeader_Penalty";
			break;
		case TYPE_RedShield:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_Redshield";
			break;
		case TYPE_RedShieldPenalty:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_Redshield_penalty";
			break;
		case TYPE_DecalreWarBothSide:
			if(getInstanceUIData().GetIsLiveServer())
			{
				return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_Bothside";
			}
			else
			{
				return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_BothsideClassic";
			}
			break;
		case TYPE_DecalreWarOneSide:
			if(getInstanceUIData().GetIsLiveServer())
			{
				return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_Oneside";
			}
			else
			{
				return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_OnesideClassic";
			}
			break;
		case TYPE_UserWatcher:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_observation";
			break;
		case TYPE_DecalreWarOneSide_UserWatcher:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_observOneside";
			break;
		case TYPE_DecalreWarBothSide_UserWatcher:
			return "L2UI_CT1.TargetStatusWnd.TargetStatusWnd_Clanwaricon_observBothside";
			break;
		default:
			break;
	}
	return "";
}

function int GetIndexByIsMagic(StatusIconInfo Info)
{
	local SkillInfo SkillInfo;

	if(!GetSkillInfo(Info.Id.ClassID, Info.Level, Info.SubLevel, SkillInfo))
	{
		return -1;
	}
	return SkillInfo.IsMagic;
}

function OnReceivedCloseUI()
{
	OnCloseButton();
	return;
}

defaultproperties
{
	m_Windowname="TargetStatusWnd"
}
