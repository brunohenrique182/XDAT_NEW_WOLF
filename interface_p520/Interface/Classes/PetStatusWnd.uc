class PetStatusWnd extends UICommonAPI;

const NSTATUSICON_MAXCOL = 12;

var int MAX_BUFF_ICONTYPE;
var string m_Windowname;
var bool m_bBuff;
var bool m_bShow;
var int m_PetID;
var int m_CurBf;
var bool m_bPetload;
var WindowHandle Me;
var StatusBarHandle barFATIGUE;
var StatusBarHandle barMP;
var StatusBarHandle barHP;
var NameCtrlHandle PetName;
var ButtonHandle btnBuff;
var WindowHandle BackTex;
var StatusIconHandle m_StatusIconBuff;
var StatusIconHandle m_StatusIconDeBuff;
var StatusIconHandle m_StatusIconSongDance;
var StatusIconHandle m_StatusIconItem;
var StatusIconHandle m_StatusIconTriggerSkill;
var StatusIconHandle BufIcon;
var StatusIconHandle DebufIcon;
var StatusIconHandle SongDanceIcon;
var StatusIconHandle TriggerSkillIcon;
var StatusIconHandle ItemIcon;
var TextureHandle m_IsDead;

function OnRegisterEvent()
{
	RegisterEvent(40);
	RegisterEvent(250);
	RegisterEvent(1000);
	RegisterEvent(1040);
	RegisterEvent(1050);
	RegisterEvent(1130);
	RegisterEvent(190);
	RegisterEvent(210);
	RegisterEvent(1052);
	RegisterEvent(1053);
	RegisterEvent(980);
	return;
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
	barFATIGUE = GetStatusBarHandle((m_Windowname $ ".barFATIGUE"));
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
	return;
}

function Load()
{
	m_CurBf = 1;
	m_bPetload = false;
	SetBuffButtonTooltip();
	m_bShow = false;
	m_bBuff = false;
	return;
}

function OnShow()
{
	local PetInfo PetInfo;

	GetPetInfo(PetInfo);
	if((PetInfo.nServerID < 0))
	{
		Me.HideWindow();
	}
	else
	{
		m_bShow = true;
	}
	return;
}

function OnHide()
{
	m_bShow = false;
	return;
}

function OnEnterState(name a_CurrentStateName)
{
	if(getInstanceUIData().GetIsLiveServer())
	{
		EachServerEnterState(a_CurrentStateName);
	}
	return;
}

function EachServerEnterState(name a_CurrentStateName)
{
	if(m_bPetload)
	{
		Me.ShowWindow();
	}
	m_bBuff = false;
	GetINIInt(m_Windowname, "a", m_CurBf, "WindowsInfo.ini");
	if((m_CurBf > MAX_BUFF_ICONTYPE))
	{
		m_CurBf = 0;
		SetINIInt(m_Windowname, "a", m_CurBf, "WindowsInfo.ini");
	}
	SetBuffButtonTooltip();
	UpdateBuff();
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
	if((Event_ID == 250))
	{
		HandlePetInfoUpdate();
	}
	else if((Event_ID == 190))
	{
		UpdatePetHP(param);
	}
	else if((Event_ID == 210))
	{
		UpdatePetMP(param);
	}
	else if((Event_ID == 1130))
	{
		HandlePetStatusClose();
		m_bPetload = false;
	}
	else if((Event_ID == 1040))
	{
		if((GetGameStateName() != "GAMINGSTATE"))
		{
			return;
		}
		HandlePetStatusShow();
		m_bPetload = true;
	}
	else if((Event_ID == 1000))
	{
		HandleShowBuffIcon(param);
	}
	else if((Event_ID == 1050))
	{
		HandlePetStatusSpelledList(param);
	}
	else if((Event_ID == 1052))
	{
		HandlePetStatusSpelledListDelete(param);
	}
	else if((Event_ID == 1053))
	{
		HandlePetStatusSpelledListInsert(param);
	}
	else if((Event_ID == 980))
	{
		HandleCheckTarget();
	}
	else if((Event_ID == 40))
	{
		m_bPetload = false;
		m_IsDead.HideWindow();
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
	if(getInstanceUIData().GetIsLiveServer())
	{
		if(bItsME)
		{
			Me.SetBackTexture("L2UI_CT1.Windows.Windows_DF_Small_Vertical_SizeControl_Bg_Over");
		}
		else
		{
			Me.SetBackTexture("L2UI_CT1.Windows.Windows_DF_Small_Vertical_SizeControl_Bg");
		}
	}
	else if(bItsME)
	{
		BackTex.SetBackTexture("L2UI_NewTex.PetWnd.PetHUD_Select");
	}
	else
	{
		BackTex.SetBackTexture("L2UI_NewTex.PetWnd.PetHUDFrame_BG");
	}
	return;
}

function ClearTargetHighLight()
{
	if(getInstanceUIData().GetIsLiveServer())
	{
		Me.SetBackTexture("L2UI_CT1.Windows.Windows_DF_Small_Vertical_SizeControl_Bg");
	}
	else
	{
		BackTex.SetBackTexture("L2UI_NewTex.PetWnd.PetHUDFrame_BG");
	}
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
	return;
}

function HandlePetStatusClose()
{
	Me.HideWindow();
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	return;
}

function UpdatePetMP(string param)
{
	local int ServerID, currentMP, MP, maxMP;
	local PetInfo Info;

	ParseInt(param, "ServerID", ServerID);
	ParseInt(param, "CurrentMP", currentMP);
	if(GetPetInfo(Info))
	{
		if((ServerID == Info.nServerID))
		{
			MP = currentMP;
			maxMP = Info.nMaxMP;
			barMP.SetPoint(INT64(MP), INT64(maxMP));
		}
	}
	return;
}

function UpdatePetHP(string param)
{
	local int ServerID, CurrentHP, Hp, MaxHP;
	local PetInfo Info;

	ParseInt(param, "ServerID", ServerID);
	ParseInt(param, "CurrentHP", CurrentHP);
	if(GetPetInfo(Info))
	{
		if((ServerID == Info.nServerID))
		{
			Hp = CurrentHP;
			MaxHP = Info.nMaxHP;
			barHP.SetPoint(INT64(Hp), INT64(MaxHP));
			if((m_PetID >= 0))
			{
				if((CurrentHP <= 0))
				{
					m_IsDead.ShowWindow();
				}
				else
				{
					m_IsDead.HideWindow();
				}
			}
		}
	}
	return;
}

function HandlePetInfoUpdate()
{
	local string Name;
	local int Hp, MaxHP, MP, maxMP, Fatigue, MaxFatigue;
	local PetInfo Info;

	m_PetID = 0;
	if(GetPetInfo(Info))
	{
		m_PetID = Info.nServerID;
		Name = Info.Name;
		Hp = Info.nCurHP;
		MP = Info.nCurMP;
		Fatigue = Info.nFatigue;
		MaxHP = Info.nMaxHP;
		maxMP = Info.nMaxMP;
		MaxFatigue = Info.nMaxFatigue;
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
	}
	PetName.SetName(Name, NCT_Normal, TA_Left);
	barHP.SetPoint(INT64(Hp), INT64(MaxHP));
	barMP.SetPoint(INT64(MP), INT64(maxMP));
	barFATIGUE.SetPoint(INT64(Fatigue), INT64(MaxFatigue));
	return;
}

function HandlePetStatusShow()
{
	Clear();
	Me.ShowWindow();
	Me.SetFocus();
	return;
}

function HandlePetStatusSpelledList(string param)
{
	local int i, Id, Max, BuffCnt, BuffCurRow, DeBuffCnt, DeBuffCurRow, SongDanceCnt, SongDanceCurRow, TriggerSkillCnt, TriggerSkillCurRow, ItemCnt, ItemCurRow;
	local StatusIconInfo Info;

	DeBuffCurRow = -1;
	BuffCurRow = -1;
	SongDanceCurRow = -1;
	ItemCurRow = -1;
	TriggerSkillCurRow = -1;
	ParseInt(param, "ID", Id);
	if(((Id < 1) || (m_PetID != Id)))
	{
		return;
	}
	m_StatusIconBuff.Clear();
	m_StatusIconDeBuff.Clear();
	m_StatusIconSongDance.Clear();
	m_StatusIconItem.Clear();
	m_StatusIconTriggerSkill.Clear();
	Info.Size = 16;
	Info.bShow = true;
	ParseInt(param, "Max", Max);
	i = 0;
	while((i < Max))
	{
		ParseItemIDWithIndex(param, Info.Id, i);
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
		ParseInt(param, ("SpellerID_" $ string(i)), Info.SpellerID);
		if(IsValidItemID(Info.Id))
		{
			Info.IconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(Info.Id, Info.Level, Info.SubLevel);
			Info.IconPanel = Class'NWindow.UIDATA_SKILL'.static.GetIconPanel(Info.Id, Info.Level, Info.SubLevel);
			Info.bHideRemainTime = true;
			if((GetDebuffType(Info.Id, Info.Level, Info.SubLevel) != 0))
			{
				if(((float(DeBuffCnt) % 12.0000000) == 0.0000000))
				{
					DeBuffCurRow++;
					m_StatusIconDeBuff.AddRow();
				}
				m_StatusIconDeBuff.AddCol(DeBuffCurRow, Info);
				DeBuffCnt++;
				i++;
				continue;
			}
			if((GetIndexByIsMagic(Info) == 3))
			{
				if(((float(SongDanceCnt) % 12.0000000) == 0.0000000))
				{
					SongDanceCurRow++;
					m_StatusIconSongDance.AddRow();
				}
				m_StatusIconSongDance.AddCol(SongDanceCurRow, Info);
				SongDanceCnt++;
				i++;
				continue;
			}
			if((GetIndexByIsMagic(Info) == 4))
			{
				if(((float(ItemCnt) % 12.0000000) == 0.0000000))
				{
					ItemCurRow++;
					m_StatusIconItem.AddRow();
				}
				m_StatusIconItem.AddCol(ItemCurRow, Info);
				ItemCnt++;
				i++;
				continue;
			}
			if((GetIndexByIsMagic(Info) == 5))
			{
				if(((float(TriggerSkillCnt) % 12.0000000) == 0.0000000))
				{
					TriggerSkillCurRow++;
					m_StatusIconTriggerSkill.AddRow();
				}
				m_StatusIconTriggerSkill.AddCol(TriggerSkillCurRow, Info);
				TriggerSkillCnt++;
				i++;
				continue;
			}
			if(((float(BuffCnt) % 12.0000000) == 0.0000000))
			{
				BuffCurRow++;
				m_StatusIconBuff.AddRow();
			}
			m_StatusIconBuff.AddCol(BuffCurRow, Info);
			BuffCnt++;
		}
		i++;
	}
	UpdateBuff();
	return;
}

function HandlePetStatusSpelledListDelete(string param)
{
	local int i, Id, Max;
	local StatusIconInfo Info;

	ParseInt(param, "ID", Id);
	if(((Id < 1) || (m_PetID != Id)))
	{
		return;
	}
	ParseInt(param, "Max", Max);
	i = 0;
	while((i < Max))
	{
		ParseItemIDWithIndex(param, Info.Id, i);
		ParseInt(param, ("Level_" $ string(i)), Info.Level);
		ParseInt(param, ("SubLevel_" $ string(i)), Info.SubLevel);
		ParseInt(param, ("SpellerID_" $ string(i)), Info.SpellerID);
		if(IsValidItemID(Info.Id))
		{
			if((GetDebuffType(Info.Id, Info.Level, Info.SubLevel) != 0))
			{
				deleteBuff(m_StatusIconDeBuff, Info.Level, Info.Id.ClassID, Info.SpellerID);
				i++;
				continue;
			}
			if((GetIndexByIsMagic(Info) == 3))
			{
				deleteBuff(m_StatusIconSongDance, Info.Level, Info.Id.ClassID, Info.SpellerID);
				i++;
				continue;
			}
			if((GetIndexByIsMagic(Info) == 4))
			{
				deleteBuff(m_StatusIconItem, Info.Level, Info.Id.ClassID, Info.SpellerID);
				i++;
				continue;
			}
			if((GetIndexByIsMagic(Info) == 5))
			{
				deleteBuff(m_StatusIconTriggerSkill, Info.Level, Info.Id.ClassID, Info.SpellerID);
				i++;
				continue;
			}
			deleteBuff(m_StatusIconBuff, Info.Level, Info.Id.ClassID, Info.SpellerID);
		}
		i++;
	}
	UpdateBuff();
	return;
}

function deleteBuff(StatusIconHandle tmpStatusIcon, int Level, int ClassID, int SpellerID)
{
	local int Row, Col;
	local StatusIconInfo Info;

	Row = 0;
	while((Row < tmpStatusIcon.GetRowCount()))
	{
		Col = 0;
		while((Col < tmpStatusIcon.GetColCount(Row)))
		{
			tmpStatusIcon.GetItem(Row, Col, Info);
			if((((Info.Id.ClassID == ClassID) && (Info.Level == Level)) && (Info.SpellerID == SpellerID)))
			{
				tmpStatusIcon.DelItem(Row, Col);
				refreshPostion(tmpStatusIcon, Row);
				return;
			}
			Col++;
		}
		Row++;
	}
	return;
}

function refreshPostion(StatusIconHandle tmpStatusIcon, int deletedRow)
{
	local int Row;
	local StatusIconInfo Info;

	Row = deletedRow;
	while((Row < (tmpStatusIcon.GetRowCount() - 1)))
	{
		tmpStatusIcon.GetItem((Row + 1), 0, Info);
		tmpStatusIcon.AddCol(Row, Info);
		tmpStatusIcon.DelItem((Row + 1), 0);
		Row++;
	}
	return;
}

function HandlePetStatusSpelledListInsert(string param)
{
	local int i, Id, Max;
	local StatusIconInfo Info;
	local StatusIconHandle tmpStatusIcon;

	ParseInt(param, "ID", Id);
	if(((Id < 1) || (m_PetID != Id)))
	{
		return;
	}
	Info.Size = 16;
	Info.bShow = true;
	ParseInt(param, "Max", Max);
	i = 0;
	while((i < Max))
	{
		ParseItemIDWithIndex(param, Info.Id, i);
		ParseInt(param, ("Level_" $ string(i)), Info.Level);
		ParseInt(param, ("SubLevel_" $ string(i)), Info.SubLevel);
		ParseInt(param, ("Sec_" $ string(i)), Info.RemainTime);
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
		ParseInt(param, ("SpellerID_" $ string(i)), Info.SpellerID);
		Info.bHideRemainTime = true;
		if(IsValidItemID(Info.Id))
		{
			Info.IconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(Info.Id, Info.Level, Info.SubLevel);
			Info.IconPanel = Class'NWindow.UIDATA_SKILL'.static.GetIconPanel(Info.Id, Info.Level, Info.SubLevel);
			Info.bHideRemainTime = true;
			if((GetDebuffType(Info.Id, Info.Level, Info.SubLevel) != 0))
			{
				tmpStatusIcon = m_StatusIconDeBuff;
			}
			else if((GetIndexByIsMagic(Info) == 3))
			{
				tmpStatusIcon = m_StatusIconSongDance;
			}
			else if((GetIndexByIsMagic(Info) == 4))
			{
				tmpStatusIcon = m_StatusIconItem;
			}
			else if((GetIndexByIsMagic(Info) == 5))
			{
				tmpStatusIcon = m_StatusIconTriggerSkill;
			}
			else
			{
				tmpStatusIcon = m_StatusIconBuff;
			}
			if(((tmpStatusIcon.GetRowCount() == 0) || ((float(tmpStatusIcon.GetColCount((tmpStatusIcon.GetRowCount() - 1))) % 12.0000000) == 0.0000000)))
			{
				tmpStatusIcon.AddRow();
			}
			tmpStatusIcon.AddCol((tmpStatusIcon.GetRowCount() - 1), Info);
		}
		i++;
	}
	UpdateBuff();
	return;
}

function HandleShowBuffIcon(string param)
{
	local int nShow;

	ParseInt(param, "Show", nShow);
	if((nShow == 1))
	{
		UpdateBuff();
	}
	else
	{
		UpdateBuff();
	}
	return;
}

function UpdateBuff()
{
	if((m_CurBf == 1))
	{
		m_StatusIconBuff.ShowWindow();
		m_StatusIconDeBuff.ShowWindow();
		m_StatusIconSongDance.HideWindow();
		m_StatusIconItem.HideWindow();
		m_StatusIconTriggerSkill.HideWindow();
	}
	else if((m_CurBf == 2))
	{
		m_StatusIconBuff.HideWindow();
		m_StatusIconDeBuff.HideWindow();
		m_StatusIconSongDance.ShowWindow();
		m_StatusIconItem.HideWindow();
		m_StatusIconTriggerSkill.HideWindow();
	}
	else if((m_CurBf == 3))
	{
		m_StatusIconBuff.HideWindow();
		m_StatusIconDeBuff.HideWindow();
		m_StatusIconSongDance.HideWindow();
		m_StatusIconItem.ShowWindow();
		m_StatusIconTriggerSkill.HideWindow();
	}
	else if((m_CurBf == 4))
	{
		m_StatusIconBuff.HideWindow();
		m_StatusIconDeBuff.HideWindow();
		m_StatusIconSongDance.HideWindow();
		m_StatusIconItem.HideWindow();
		m_StatusIconTriggerSkill.ShowWindow();
	}
	else
	{
		m_StatusIconBuff.HideWindow();
		m_StatusIconDeBuff.HideWindow();
		m_StatusIconSongDance.HideWindow();
		m_StatusIconItem.HideWindow();
		m_StatusIconTriggerSkill.HideWindow();
	}
	return;
}

function OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	local Rect rectWnd;
	local UserInfo UserInfo;

	rectWnd = Me.GetRect();
	if(((X > (rectWnd.nX + 13)) && (X < ((rectWnd.nX + rectWnd.nWidth) - 10))))
	{
		if(GetPlayerInfo(UserInfo))
		{
			RequestAction(m_PetID, UserInfo.Loc);
		}
	}
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnBuff":
			OnBuffButton();
			break;
		default:
			break;
	}
	return;
}

function OnBuffButton()
{
	m_CurBf = (m_CurBf + 1);
	if((m_CurBf > MAX_BUFF_ICONTYPE))
	{
		m_CurBf = 0;
	}
	SetINIInt(m_Windowname, "a", m_CurBf, "WindowsInfo.ini");
	SetBuffButtonTooltip();
	UpdateBuff();
	return;
}

function SetBuffButtonTooltip()
{
	local Color b1, b2, b3;
	local array<DrawItemInfo> drawListArr;
	local int buttonIndex;

	b1 = getInstanceL2Util().Gray;
	b2 = getInstanceL2Util().Gray;
	b3 = getInstanceL2Util().Gray;
	if((m_CurBf == 0))
	{
		btnBuff.SetTexture("L2ui_CH3.PartyWnd.party_buffbutton_off", "L2ui_CH3.PartyWnd.party_buffbutton_off", "L2ui_CH3.PartyWnd.party_buffbutton_off");
	}
	else
	{
		if((m_CurBf > 1))
		{
			buttonIndex = (m_CurBf + 1);
		}
		else
		{
			buttonIndex = m_CurBf;
		}
		btnBuff.SetTexture(("L2ui_CH3.PartyWnd.party_buffbutton_" $ string(buttonIndex)), ("L2ui_CH3.PartyWnd.party_buffbutton_" $ string(buttonIndex)), ("L2ui_CH3.PartyWnd.party_buffbutton_" $ string(buttonIndex)));
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
		default:
			break;
	}
	drawListArr[drawListArr.Length] = addDrawItemText(((GetSystemString(1496) $ "/") $ GetSystemString(1497)), b1, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(1741), b2, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(2307), b3, "", true, true);
	btnBuff.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
	return;
}

function OnClickItem(string strID, int Index)
{
	local int Row, Col;
	local StatusIconInfo Info;
	local SkillInfo SkillInfo;
	local StatusIconHandle StatusIcon;

	Col = (Index / 10);
	Row = (Index - (Col * 10));
	if((InStr(strID, "StatusIconBuff") > -1))
	{
		StatusIcon = BufIcon;
	}
	if((InStr(strID, "StatusIconDeBuff") > -1))
	{
		StatusIcon = DebufIcon;
	}
	if((InStr(strID, "StatusIconSongDance") > -1))
	{
		StatusIcon = SongDanceIcon;
	}
	if((InStr(strID, "StatusIconItem") > -1))
	{
		StatusIcon = ItemIcon;
	}
	if((InStr(strID, "StatusIconTriggerSkill") > -1))
	{
		StatusIcon = TriggerSkillIcon;
	}
	StatusIcon.GetItem(Row, Col, Info);
	if(!GetSkillInfo(Info.Id.ClassID, Info.Level, Info.SubLevel, SkillInfo))
	{
		return;
	}
	if((((((InStr(strID, "StatusIconBuff") > -1) || (InStr(strID, "StatusIconDeBuff") > -1)) || (InStr(strID, "StatusIconSongDance") > -1)) || (InStr(strID, "StatusIconTriggerSkill") > -1)) || (InStr(strID, "StatusIconItem") > -1)))
	{
		if(((SkillInfo.Debuff == 0) && (SkillInfo.OperateType == 1)))
		{
			RequestDispel(m_PetID, Info.Id, Info.Level, Info.SubLevel);
		}
		else
		{
			AddSystemMessage(2318);
		}
	}
	return;
}

function OnRButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	local Rect rectWnd;
	local int targetID;
	local string UserName;
	local UserInfo targetUserInfo;

	rectWnd = Me.GetRect();
	targetID = m_PetID;
	if((targetID > 0))
	{
		if(((X > rectWnd.nX) && (X < (rectWnd.nX + rectWnd.nWidth))))
		{
			if(((Y > rectWnd.nY) && (Y < (rectWnd.nY + rectWnd.nHeight))))
			{
				UserName = Class'NWindow.UIDATA_USER'.static.GetUserName(targetID);
				if((UserName != ""))
				{
					if(GetTargetInfo(targetUserInfo))
					{
					}
					if((targetUserInfo.nID != targetID))
					{
						setTargetByServerID(targetID);
					}
					getInstanceContextMenu().execContextEvent(UserName, targetID, X, Y);
				}
			}
		}
	}
	return;
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

defaultproperties
{
	MAX_BUFF_ICONTYPE=3
	m_Windowname="PetStatusWnd"
}
