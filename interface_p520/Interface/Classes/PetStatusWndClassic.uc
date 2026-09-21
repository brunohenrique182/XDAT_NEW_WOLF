class PetStatusWndClassic extends PetStatusWnd;

var StatusBarHandle barFATIGUE;
var TextureHandle PetIcon_tex;
var TextBoxHandle PetLevel;
var TextureHandle Pet_Hungry_Alarm;
var TextureHandle Pet_HungryIcon_tex;
var bool bPetHungryAlarmFlag;
var TextureHandle PetSelectBG_tex;
var TextureHandle btnPetWndClassic_Alarm;
var WindowHandle petIconWnd;
var TextureHandle petClassIcon_tex;
var ButtonHandle petWndBtn;

static function PetStatusWndClassic Inst()
{
	return PetStatusWndClassic(GetScript("PetStatusWndClassic"));
}

function OnLoad()
{
	InitializeCOD();
	Load();
	return;
}

function InitializeCOD()
{
	BufIcon = GetStatusIconHandle((m_Windowname $ ".StatusIconBuff"));
	DebufIcon = GetStatusIconHandle((m_Windowname $ ".StatusIconDeBuff"));
	SongDanceIcon = GetStatusIconHandle((m_Windowname $ ".StatusIconSongDance"));
	ItemIcon = GetStatusIconHandle((m_Windowname $ ".StatusIconItem"));
	TriggerSkillIcon = GetStatusIconHandle((m_Windowname $ ".StatusIconTriggerSkill"));
	Me = GetWindowHandle(m_Windowname);
	barMP = GetStatusBarHandle((m_Windowname $ ".barMP"));
	barHP = GetStatusBarHandle((m_Windowname $ ".barHP"));
	PetName = GetNameCtrlHandle((m_Windowname $ ".PetName"));
	btnBuff = GetButtonHandle((m_Windowname $ ".btnBuff"));
	BackTex = GetWindowHandle((m_Windowname $ ".BackTex"));
	m_IsDead = GetTextureHandle((m_Windowname $ ".BackTex.IsDeadTexture"));
	m_StatusIconBuff = GetStatusIconHandle((m_Windowname $ ".StatusIconBuff"));
	m_StatusIconDeBuff = GetStatusIconHandle((m_Windowname $ ".StatusIconDeBuff"));
	m_StatusIconSongDance = GetStatusIconHandle((m_Windowname $ ".StatusIconSongDance"));
	m_StatusIconItem = GetStatusIconHandle((m_Windowname $ ".StatusIconItem"));
	m_StatusIconTriggerSkill = GetStatusIconHandle((m_Windowname $ ".StatusIconTriggerSkill"));
	m_IsDead.HideWindow();
	PetSelectBG_tex = GetTextureHandle((m_Windowname $ ".BackTex.PetSelectBG_tex"));
	btnPetWndClassic_Alarm = GetTextureHandle((m_Windowname $ ".btnPetWndClassic_Alarm"));
	barFATIGUE = GetStatusBarHandle((m_Windowname $ ".barFatigue"));
	PetIcon_tex = GetTextureHandle((m_Windowname $ ".BackTex.Pet_HUDIconWnd.PetIcon_tex"));
	petIconWnd = GetWindowHandle((m_Windowname $ ".BackTex.Pet_HUDIconWnd"));
	PetLevel = GetTextBoxHandle((m_Windowname $ ".BackTex.Pet_HUDIconWnd.Pet_Level"));
	Pet_Hungry_Alarm = GetTextureHandle((m_Windowname $ ".Pet_Hungry_Alarm"));
	Pet_HungryIcon_tex = GetTextureHandle((m_Windowname $ ".Pet_HungryIcon_tex"));
	petClassIcon_tex = GetTextureHandle((m_Windowname $ ".BackTex.ClassIconPet"));
	petWndBtn = GetButtonHandle((m_Windowname $ ".btnPetWndClassic"));
	PetSelectBG_tex.HideWindow();
	btnPetWndClassic_Alarm.HideWindow();
	return;
}

function OnRegisterEvent()
{
	super.OnRegisterEvent();
	RegisterEvent(11481);
	RegisterEvent(9750);
	return;
}

function Clear()
{
	m_StatusIconBuff.Clear();
	m_StatusIconDeBuff.Clear();
	m_StatusIconSongDance.Clear();
	m_StatusIconItem.Clear();
	m_StatusIconTriggerSkill.Clear();
	PetName.SetName("", NCT_Normal, TA_Left);
	barHP.SetPoint(INT64(0), INT64(0));
	barMP.SetPoint(INT64(0), INT64(0));
	barFATIGUE.SetPoint(INT64(0), INT64(0));
	ClearTargetHighLight();
	Me.HideWindow();
	if(bPetHungryAlarmFlag)
	{
		Class'Interface.L2UITween'.static.Inst()._KillTwinkleWithWnd(Pet_Hungry_Alarm);
	}
	bPetHungryAlarmFlag = false;
	return;
}

function OnEvent(int Event_ID, string param)
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		if((Event_ID == 11481))
		{
			ShowPetNoticeAlarm(true);
		}
		if((Event_ID == 9750))
		{
			Pet_Hungry_Alarm.HideWindow();
			bPetHungryAlarmFlag = false;
			ShowPetNoticeAlarm(false);
		}
		else if((Event_ID == 980))
		{
			HandleCheckTarget();
		}
		else
		{
			EachServerEvent(Event_ID, param);
		}
	}
	return;
}

function HandleCheckTarget()
{
	local bool bItsME;

	if(((Class'NWindow.UIDATA_TARGET'.static.GetTargetID() == m_PetID) && (m_PetID > 0)))
	{
		bItsME = true;
	}
	if(bItsME)
	{
		BackTex.SetBackTexture("L2UI_NewTex.PetWnd.PetHUD_Select");
		PetSelectBG_tex.ShowWindow();
	}
	else
	{
		BackTex.SetBackTexture("L2UI_NewTex.PetWnd.PetHUDFrame_BG");
		PetSelectBG_tex.HideWindow();
	}
	return;
}

function OnEnterState(name a_CurrentStateName)
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		EachServerEnterState(a_CurrentStateName);
	}
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnBuff":
			super.OnBuffButton();
			break;
		case "btnPetWndClassic":
			TogglePetWndClassic();
			break;
		default:
			break;
	}
	return;
}

function HandlePetInfoUpdate()
{
	local string Name;
	local int Hp, MaxHP, MP, maxMP;
	local INT64 CurExp, minExp, MaxExp;
	local PetInfo Info;
	local int Fatigue;
	local float FatiguePer;
	local L2PetRaceEmblemUIData petEmplemData;

	m_PetID = 0;
	if(GetPetInfo(Info))
	{
		m_PetID = Info.nServerID;
		Name = Info.Name;
		Hp = Info.nCurHP;
		MP = Info.nCurMP;
		CurExp = Info.nCurExp;
		MaxHP = Info.nMaxHP;
		maxMP = Info.nMaxMP;
		minExp = Info.nMinExp;
		MaxExp = Info.nMaxExp;
		Fatigue = Info.nFatigue;
		if((m_PetID >= 0))
		{
			if((Hp <= 0))
			{
				m_IsDead.ShowWindow();
			}
			else
			{
				m_IsDead.HideWindow();
			}
		}
		if((Fatigue <= 0))
		{
			if((bPetHungryAlarmFlag == false))
			{
				bPetHungryAlarmFlag = true;
				Pet_Hungry_Alarm.ShowWindow();
				Class'Interface.L2UITween'.static.Inst()._AddTweenTwinlkle(Pet_Hungry_Alarm, -1.0000000, 0.5000000, 1000.0000000);
			}
		}
		else if(bPetHungryAlarmFlag)
		{
			Pet_Hungry_Alarm.HideWindow();
			Class'Interface.L2UITween'.static.Inst()._KillTwinkleWithWnd(Pet_Hungry_Alarm);
			bPetHungryAlarmFlag = false;
		}
		FatiguePer = float(ConvertFloatToString(((float(Fatigue) / float(Info.nMaxFatigue)) * 100.0000000), 2, true));
		Pet_HungryIcon_tex.SetTooltipText((((GetSystemString(14821) $ ":") @ string0100Per(FatiguePer)) $ "%"));
		barFATIGUE.SetPointPercent(INT64(Info.nFatigue), INT64(0), INT64(Info.nMaxFatigue));
		petIconWnd.SetTooltipText((((GetSystemString(13364) $ ":") @ ConvertFloatToString(((float((CurExp - minExp)) / float((MaxExp - minExp))) * 100.0000000), 4, true)) $ "%"));
	}
	PetName.SetName(Name, NCT_Normal, TA_Left);
	barHP.SetPoint(INT64(Hp), INT64(MaxHP));
	barMP.SetPoint(INT64(MP), INT64(maxMP));
	PetLevel.SetText(("Lv." $ string(Info.nLevel)));
	Class'NWindow.PetAPI'.static.GetPetRaceEmblemData(Info.nPetID, petEmplemData);
	PetIcon_tex.SetTexture(petEmplemData.HUDEmblemTexName);
	if((Info.nPetType == 1))
	{
		petClassIcon_tex.SetTexture("L2UI_ch3.PARTYWND.party_Mercenaryicon");
		petWndBtn.SetTexture("L2UI_NewTex.PetWnd.MercenaryNewStatusBtn_N", "L2UI_NewTex.PetWnd.MercenaryNewStatusBtn_D", "L2UI_NewTex.PetWnd.MercenaryNewStatusBtn_O");
	}
	else
	{
		petClassIcon_tex.SetTexture("L2UI_CH3.PARTYWND.party_peticon");
		petWndBtn.SetTexture("L2UI_NewTex.PetWnd.PetNewStatusBtn_N", "L2UI_NewTex.PetWnd.PetNewStatusBtn_O", "L2UI_NewTex.PetWnd.PetNewStatusBtn_D");
	}
	return;
}

function HandlePetStatusClose()
{
	ShowPetNoticeAlarm(false);
	Me.HideWindow();
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	return;
}

function OnHide()
{
	super.OnHide();
	GetWindowHandle((m_Windowname $ ".AutoPotionSubWndPet")).HideWindow();
	return;
}

function TogglePetWndClassic()
{
	local WindowHandle petWndClassicWnd;

	petWndClassicWnd = GetWindowHandle("PetWndClassic");
	if(petWndClassicWnd.IsShowWindow())
	{
		petWndClassicWnd.HideWindow();
	}
	else
	{
		ShowPetNoticeAlarm(false);
		petWndClassicWnd.ShowWindow();
		petWndClassicWnd.SetFocus();
	}
	return;
}

function SetBuffButtonTooltip()
{
	local Color b1, b2, b3, b4;
	local array<DrawItemInfo> drawListArr;

	b1 = getInstanceL2Util().Gray;
	b2 = getInstanceL2Util().Gray;
	b3 = getInstanceL2Util().Gray;
	b4 = getInstanceL2Util().Gray;
	if((m_CurBf == 0))
	{
		btnBuff.SetTexture("L2ui_CH3.PartyWnd.party_buffbutton_off", "L2ui_CH3.PartyWnd.party_buffbutton_off", "L2ui_CH3.PartyWnd.party_buffbutton_off");
	}
	else
	{
		btnBuff.SetTexture(("L2ui_CH3.PartyWnd.party_buffbutton_" $ string(m_CurBf)), ("L2ui_CH3.PartyWnd.party_buffbutton_" $ string(m_CurBf)), ("L2ui_CH3.PartyWnd.party_buffbutton_" $ string(m_CurBf)));
	}
	switch(m_CurBf)
	{
		case 0:
			break;
		case 1:
			b1 = getInstanceL2Util().Yellow;
			break;
		case 2:
			b2 = getInstanceL2Util().Yellow;
			break;
		case 3:
			b3 = getInstanceL2Util().Yellow;
			break;
		case 4:
			b4 = getInstanceL2Util().Yellow;
			break;
		default:
			break;
	}
	drawListArr[drawListArr.Length] = addDrawItemText(((GetSystemString(1496) $ "/") $ GetSystemString(1497)), b1, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(1741), b2, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13440), b3, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(2307), b4, "", true, true);
	btnBuff.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
	return;
}

function ShowPetNoticeAlarm(bool isShow)
{
	local array<DrawItemInfo> drawListArr;
	local L2Util util;

	util = getInstanceL2Util();
	if(isShow)
	{
		btnPetWndClassic_Alarm.ShowWindow();
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(2624), util.White, "", false, true);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(10);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14410), util.Gold, "", true, true);
	}
	else
	{
		btnPetWndClassic_Alarm.HideWindow();
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(2624), util.White, "", false, false);
	}
	petWndBtn.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
	return;
}

function OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	local Rect rectWnd;
	local UserInfo UserInfo;

	rectWnd = Me.GetRect();
	if(((X > (rectWnd.nX + 27)) && (X < ((rectWnd.nX + rectWnd.nWidth) - 10))))
	{
		if(GetPlayerInfo(UserInfo))
		{
			if((a_WindowHandle.GetWindowName() == "btnPetWndClassic"))
			{
				return;
			}
			if((m_PetID != Class'NWindow.UIDATA_TARGET'.static.GetTargetID()))
			{
				RequestAction(m_PetID, UserInfo.Loc);
			}
		}
	}
	return;
}

defaultproperties
{
	MAX_BUFF_ICONTYPE=4
	m_Windowname="PetStatusWndClassic"
}
