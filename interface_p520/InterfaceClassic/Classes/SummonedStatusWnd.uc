class SummonedStatusWnd extends UICommonAPI;

const SUMMON_MAXCOUNT = 4;
const NSTATUSICON_MAXCOL = 12;

var int MAX_BUFF_ICONTYPE;
var string m_Windowname;
var WindowHandle Me;
var ButtonHandle btnBuff;
var WindowHandle SummonedStatusWnd1;
var WindowHandle SummonedStatusWnd2;
var WindowHandle SummonedStatusWnd3;
var WindowHandle SummonedStatusWnd4;
var NameCtrlHandle PetName;
var TextureHandle ClassIconSummon;
var StatusBarHandle barHP_1;
var StatusBarHandle barMP_1;
var StatusIconHandle m_StatusIconBuff[4];
var StatusIconHandle m_StatusIconDeBuff[4];
var StatusIconHandle m_StatusIconSongDance[4];
var StatusIconHandle m_StatusIconItem[4];
var StatusIconHandle m_StatusIconTriggerSkill[4];
var int m_targetID;
var int m_LastChangeColor;
var TextureHandle m_IsDead[4];
var L2Util util;
var int StatusWnd_SIZE_HEIGHT;
var int summonedServerID[4];
var int m_CurBf;
var bool m_IsSummonedStatusShowEvent;

function OnRegisterEvent()
{
	RegisterEvent(1100);
	RegisterEvent(1131);
	RegisterEvent(251);
	RegisterEvent(1110);
	RegisterEvent(1112);
	RegisterEvent(1113);
	RegisterEvent(1132);
	RegisterEvent(40);
	RegisterEvent(190);
	RegisterEvent(210);
	RegisterEvent(980);
	return;
}

function OnLoad()
{
	util = L2Util(GetScript("L2Util"));
	m_IsSummonedStatusShowEvent = false;
	Initialize();
	if(getInstanceUIData().GetIsClassicServer())
	{
		StatusWnd_SIZE_HEIGHT = 54;
	}
	else
	{
		StatusWnd_SIZE_HEIGHT = 50;
	}
	return;
}

function Initialize()
{
	local int i;

	Me = GetWindowHandle(m_Windowname);
	btnBuff = GetButtonHandle((m_Windowname $ ".btnBuff"));
	SummonedStatusWnd1 = GetWindowHandle((m_Windowname $ ".SummonedStatusWnd1"));
	SummonedStatusWnd2 = GetWindowHandle((m_Windowname $ ".SummonedStatusWnd2"));
	SummonedStatusWnd3 = GetWindowHandle((m_Windowname $ ".SummonedStatusWnd3"));
	SummonedStatusWnd4 = GetWindowHandle((m_Windowname $ ".SummonedStatusWnd4"));
	PetName = GetNameCtrlHandle((m_Windowname $ ".SummonedStatusWnd1.PetName"));
	ClassIconSummon = GetTextureHandle((m_Windowname $ ".SummonedStatusWnd1.ClassIconSummon"));
	barHP_1 = GetStatusBarHandle((m_Windowname $ ".SummonedStatusWnd1.barHP_1"));
	barMP_1 = GetStatusBarHandle((m_Windowname $ ".SummonedStatusWnd1.barMP_1"));
	i = 0;
	while((i < 4))
	{
		m_StatusIconBuff[i] = GetStatusIconHandle(((((m_Windowname $ ".SummonedStatusWnd") $ string((i + 1))) $ ".StatusIconBuff") $ string((i + 1))));
		m_StatusIconDeBuff[i] = GetStatusIconHandle(((((m_Windowname $ ".SummonedStatusWnd") $ string((i + 1))) $ ".StatusIconDebuff") $ string((i + 1))));
		m_StatusIconSongDance[i] = GetStatusIconHandle(((((m_Windowname $ ".SummonedStatusWnd") $ string((i + 1))) $ ".StatusIconSongDance") $ string((i + 1))));
		m_StatusIconItem[i] = GetStatusIconHandle(((((m_Windowname $ ".SummonedStatusWnd") $ string((i + 1))) $ ".StatusIconItem") $ string((i + 1))));
		m_StatusIconTriggerSkill[i] = GetStatusIconHandle(((((m_Windowname $ ".SummonedStatusWnd") $ string((i + 1))) $ ".StatusIconTriggerSkill") $ string((i + 1))));
		m_IsDead[i] = GetTextureHandle((((m_Windowname $ ".SummonedStatusWnd") $ string((i + 1))) $ ".IsDeadTexture"));
		i++;
	}
	initIsDeadTexture();
	clearBar();
	m_CurBf = 1;
	m_LastChangeColor = -1;
	m_targetID = -1;
	SetBuffButtonTooltip();
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
	if(m_IsSummonedStatusShowEvent)
	{
		if((summonedServerID[0] != -1))
		{
			Me.ShowWindow();
		}
	}
	GetINIInt(m_Windowname, "a", m_CurBf, "WindowsInfo.ini");
	if((m_CurBf > MAX_BUFF_ICONTYPE))
	{
		m_CurBf = 0;
		SetINIInt(m_Windowname, "a", m_CurBf, "WindowsInfo.ini");
	}
	SetBuffButtonTooltip();
	UpdateBuff(0);
	UpdateBuff(1);
	UpdateBuff(2);
	UpdateBuff(3);
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
	local int ServerID, CurrentHP, currentMP, SlotIndex;

	if((Event_ID == 190))
	{
		ParseInt(param, "ServerID", ServerID);
		ParseInt(param, "CurrentHP", CurrentHP);
		if((ServerID != 0))
		{
			SlotIndex = GetIsSummonedSlotIndex(ServerID);
			if((SlotIndex == -1))
			{
				return;
			}
			setStatusBarHP(SlotIndex, CurrentHP);
		}
	}
	else if((Event_ID == 210))
	{
		ParseInt(param, "ServerID", ServerID);
		ParseInt(param, "CurrentMP", currentMP);
		if((ServerID != 0))
		{
			SlotIndex = GetIsSummonedSlotIndex(ServerID);
			if((SlotIndex == -1))
			{
				return;
			}
			setStatusBarMP(SlotIndex, currentMP);
		}
	}
	else if((Event_ID == 1100))
	{
		if((GetGameStateName() != "GAMINGSTATE"))
		{
			return;
		}
		HandleSummonedStatusShow();
	}
	else if((Event_ID == 1131))
	{
		HandleSummonedStatusClose();
	}
	else if((Event_ID == 251))
	{
		if((GetGameStateName() != "GAMINGSTATE"))
		{
			return;
		}
		ParseInt(param, "ServerID", ServerID);
		if((ServerID != 0))
		{
			HandleSummonInfoUpdate(ServerID);
		}
	}
	else if((Event_ID == 1110))
	{
		HandleSummonedStatusSpelledList(param);
	}
	else if((Event_ID == 1112))
	{
		HandleSummonedStatusSpelledListDelete(param);
	}
	else if((Event_ID == 1113))
	{
		HandleSummonedStatusSpelledListInsert(param);
	}
	else if((Event_ID == 1132))
	{
		HandleSummonedDelete(param);
	}
	else if((Event_ID == 40))
	{
		Restart();
	}
	else if((Event_ID == 980))
	{
		HandleCheckTarget();
	}
	return;
}

function HandleCheckTarget()
{
	local int idx;

	idx = -1;
	m_targetID = Class'NWindow.UIDATA_TARGET'.static.GetTargetID();
	if((m_targetID > 0))
	{
		idx = GetIsSummonedSlotIndex(m_targetID);
	}
	if(getInstanceUIData().GetIsLiveServer())
	{
		if((m_LastChangeColor != -1))
		{
			GetWindowHandle(((m_Windowname $ ".SummonedStatusWnd") $ string((m_LastChangeColor + 1)))).SetBackTexture("L2UI_CT1.Windows.Windows_DF_Small_Vertical_SizeControl_Bg");
			m_targetID = -1;
			m_LastChangeColor = -1;
		}
		if((idx != -1))
		{
			m_LastChangeColor = idx;
			GetWindowHandle(((m_Windowname $ ".SummonedStatusWnd") $ string((idx + 1)))).SetBackTexture("L2UI_CT1.Windows.Windows_DF_Small_Vertical_SizeControl_Bg_Over");
		}
	}
	else
	{
		if((m_LastChangeColor != -1))
		{
			GetWindowHandle(((m_Windowname $ ".SummonedStatusWnd") $ string((m_LastChangeColor + 1)))).SetBackTexture("L2UI_NewTex.Windows.PartyWndBG");
			m_targetID = -1;
			m_LastChangeColor = -1;
		}
		if((idx != -1))
		{
			m_LastChangeColor = idx;
			GetWindowHandle(((m_Windowname $ ".SummonedStatusWnd") $ string((idx + 1)))).SetBackTexture("L2UI_NewTex.PartyWndBG_OverClassic");
		}
	}
	return;
}

function Restart()
{
	local int i;

	i = 0;
	while((i < 4))
	{
		summonedServerID[i] = -1;
		i++;
	}
	initIsDeadTexture();
	return;
}

function OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	local string btnName;

	btnName = a_ButtonHandle.GetWindowName();
	switch(btnName)
	{
		case "btnBuff":
			OnBuffButton();
			break;
		default:
			break;
	}
	return;
}

function OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	local Rect rectWnd;
	local UserInfo UserInfo;
	local int ServerID, Num;
	local string WindowName;
	local WindowHandle hParent;

	rectWnd = Me.GetRect();
	if(((X > (rectWnd.nX + 14)) && (X < ((rectWnd.nX + rectWnd.nWidth) - 20))))
	{
		WindowName = a_WindowHandle.GetWindowName();
		if((WindowName != ""))
		{
			if((Left(WindowName, Len(m_Windowname)) != m_Windowname))
			{
				hParent = a_WindowHandle.GetParentWindowHandle();
				WindowName = hParent.GetWindowName();
			}
			Num = (int(Right(WindowName, 1)) - 1);
			ServerID = summonedServerID[Num];
			if((ServerID != -1))
			{
				if(GetPlayerInfo(UserInfo))
				{
					RequestAction(ServerID, UserInfo.Loc);
				}
			}
		}
	}
	return;
}

function OnClickButton(string Name)
{
	if((Name == "btnSummonWndClassic"))
	{
		ToggleSummonedClassic();
	}
	return;
}

function ToggleSummonedClassic()
{
	local WindowHandle summonedWndClassicWnd;

	summonedWndClassicWnd = GetWindowHandle("SummonedWndClassic");
	if(summonedWndClassicWnd.IsShowWindow())
	{
		summonedWndClassicWnd.HideWindow();
	}
	else
	{
		summonedWndClassicWnd.ShowWindow();
		summonedWndClassicWnd.SetFocus();
	}
	return;
}

function HandleSummonedDelete(string param)
{
	local int ServerID, curreSlotIndex, firstSlotIndex;

	ParseInt(param, "serverID", ServerID);
	curreSlotIndex = GetIsSummonedSlotIndex(ServerID);
	if((curreSlotIndex > -1))
	{
		firstSlotIndex = getSummonedSlotIndex();
		if((firstSlotIndex > 1))
		{
			delStatus(curreSlotIndex, firstSlotIndex);
			reSizeWindow((firstSlotIndex - 1));
		}
		else
		{
			summonedServerID[curreSlotIndex] = -1;
		}
	}
	return;
}

function HandleSummonedStatusClose()
{
	m_IsSummonedStatusShowEvent = false;
	m_targetID = -1;
	m_LastChangeColor = -1;
	clearBar();
	Me.HideWindow();
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	initIsDeadTexture();
	return;
}

function initIsDeadTexture()
{
	local int i;

	i = 0;
	while((i < 4))
	{
		m_IsDead[i].HideWindow();
		i++;
	}
	return;
}

function HandleSummonedStatusShow()
{
	m_IsSummonedStatusShowEvent = true;
	Me.ShowWindow();
	return;
}

function int GetIsSummonedSlotIndex(int ServerID)
{
	local int i;

	i = 0;
	while((i < 4))
	{
		if((summonedServerID[i] == ServerID))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function int getSummonedSlotIndex()
{
	local int i;

	i = 0;
	while((i < 4))
	{
		if((summonedServerID[i] == -1))
		{
			return i;
		}
		i++;
	}
	return 4;
}

function clearBar()
{
	local int i;

	i = 0;
	while((i < 4))
	{
		GetWindowHandle(((m_Windowname $ ".SummonedStatusWnd") $ string((i + 1)))).HideWindow();
		summonedServerID[i] = -1;
		i++;
	}
	return;
}

function HandleSummonedStatusSpelledList(string param)
{
	local int curreSlotIndex, i, Id, Max, BuffCnt, BuffCurRow, DeBuffCnt, DeBuffCurRow, SongDanceCnt, SongDanceCurRow, TriggerSkillCnt, TriggerSkillCurRow, ItemCnt, ItemCurRow;
	local StatusIconInfo Info;

	ParseInt(param, "ID", Id);
	curreSlotIndex = GetIsSummonedSlotIndex(Id);
	DeBuffCurRow = -1;
	BuffCurRow = -1;
	SongDanceCurRow = -1;
	ItemCurRow = -1;
	TriggerSkillCurRow = -1;
	ParseInt(param, "ID", Id);
	Info.ServerID = Id;
	if((curreSlotIndex < 0))
	{
		return;
	}
	m_StatusIconBuff[curreSlotIndex].Clear();
	m_StatusIconDeBuff[curreSlotIndex].Clear();
	m_StatusIconSongDance[curreSlotIndex].Clear();
	m_StatusIconItem[curreSlotIndex].Clear();
	m_StatusIconTriggerSkill[curreSlotIndex].Clear();
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
		if(IsValidItemID(Info.Id))
		{
			Info.IconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(Info.Id, Info.Level, Info.SubLevel);
			Info.IconPanel = Class'NWindow.UIDATA_SKILL'.static.GetIconPanel(Info.Id, Info.Level, Info.SubLevel);
			Info.bHideRemainTime = true;
			if((GetDebuffType(Info.Id, Info.Level, Info.SubLevel) != 0))
			{
				if((DeBuffCnt == 0))
				{
					DeBuffCurRow++;
					m_StatusIconDeBuff[curreSlotIndex].AddRow();
				}
				m_StatusIconDeBuff[curreSlotIndex].AddCol(DeBuffCurRow, Info);
				DeBuffCnt++;
				i++;
				continue;
			}
			if((GetIndexByIsMagic(Info) == 3))
			{
				if((SongDanceCnt == 0))
				{
					SongDanceCurRow++;
					m_StatusIconSongDance[curreSlotIndex].AddRow();
				}
				m_StatusIconSongDance[curreSlotIndex].AddCol(SongDanceCurRow, Info);
				SongDanceCnt++;
				i++;
				continue;
			}
			if((GetIndexByIsMagic(Info) == 4))
			{
				if((ItemCnt == 0))
				{
					ItemCurRow++;
					m_StatusIconItem[curreSlotIndex].AddRow();
				}
				m_StatusIconItem[curreSlotIndex].AddCol(ItemCurRow, Info);
				ItemCnt++;
				i++;
				continue;
			}
			if((GetIndexByIsMagic(Info) == 5))
			{
				if((TriggerSkillCnt == 0))
				{
					TriggerSkillCurRow++;
					m_StatusIconTriggerSkill[curreSlotIndex].AddRow();
				}
				m_StatusIconTriggerSkill[curreSlotIndex].AddCol(TriggerSkillCurRow, Info);
				TriggerSkillCnt++;
				i++;
				continue;
			}
			if(((float(BuffCnt) % 12.0000000) == 0.0000000))
			{
				BuffCurRow++;
				m_StatusIconBuff[curreSlotIndex].AddRow();
			}
			m_StatusIconBuff[curreSlotIndex].AddCol(BuffCurRow, Info);
			BuffCnt++;
		}
		i++;
	}
	UpdateBuff(curreSlotIndex);
	return;
}

function HandleSummonedStatusSpelledListDelete(string param)
{
	local int i, Id, Max;
	local StatusIconInfo Info;
	local int curreSlotIndex;

	ParseInt(param, "ID", Id);
	curreSlotIndex = GetIsSummonedSlotIndex(Id);
	if((curreSlotIndex < 0))
	{
		return;
	}
	Info.ServerID = Id;
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
				deleteBuff(m_StatusIconDeBuff[curreSlotIndex], Info.Level, Info.Id.ClassID, Info.SpellerID);
				i++;
				continue;
			}
			if((GetIndexByIsMagic(Info) == 3))
			{
				deleteBuff(m_StatusIconSongDance[curreSlotIndex], Info.Level, Info.Id.ClassID, Info.SpellerID);
				i++;
				continue;
			}
			if((GetIndexByIsMagic(Info) == 4))
			{
				deleteBuff(m_StatusIconItem[curreSlotIndex], Info.Level, Info.Id.ClassID, Info.SpellerID);
				i++;
				continue;
			}
			if((GetIndexByIsMagic(Info) == 5))
			{
				deleteBuff(m_StatusIconTriggerSkill[curreSlotIndex], Info.Level, Info.Id.ClassID, Info.SpellerID);
				i++;
				continue;
			}
			deleteBuff(m_StatusIconBuff[curreSlotIndex], Info.Level, Info.Id.ClassID, Info.SpellerID);
		}
		i++;
	}
	UpdateBuff(curreSlotIndex);
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

function copySpelledList(int fromIndex, int toIndex)
{
	local int Row, Col;
	local StatusIconInfo Info;

	m_StatusIconDeBuff[toIndex].Clear();
	Row = 0;
	while((Row < m_StatusIconDeBuff[fromIndex].GetRowCount()))
	{
		m_StatusIconDeBuff[toIndex].AddRow();
		Col = 0;
		while((Col < m_StatusIconDeBuff[fromIndex].GetColCount(Row)))
		{
			m_StatusIconDeBuff[fromIndex].GetItem(Row, Col, Info);
			m_StatusIconDeBuff[toIndex].AddCol(Row, Info);
			Col++;
		}
		Row++;
	}
	m_StatusIconSongDance[toIndex].Clear();
	Row = 0;
	while((Row < m_StatusIconSongDance[fromIndex].GetRowCount()))
	{
		m_StatusIconSongDance[toIndex].AddRow();
		Col = 0;
		while((Col < m_StatusIconSongDance[fromIndex].GetColCount(Row)))
		{
			m_StatusIconSongDance[fromIndex].GetItem(Row, Col, Info);
			m_StatusIconSongDance[toIndex].AddCol(Row, Info);
			Col++;
		}
		Row++;
	}
	m_StatusIconItem[toIndex].Clear();
	Row = 0;
	while((Row < m_StatusIconItem[fromIndex].GetRowCount()))
	{
		m_StatusIconItem[toIndex].AddRow();
		Col = 0;
		while((Col < m_StatusIconItem[fromIndex].GetColCount(Row)))
		{
			m_StatusIconItem[fromIndex].GetItem(Row, Col, Info);
			m_StatusIconItem[toIndex].AddCol(Row, Info);
			Col++;
		}
		Row++;
	}
	m_StatusIconTriggerSkill[toIndex].Clear();
	Row = 0;
	while((Row < m_StatusIconTriggerSkill[fromIndex].GetRowCount()))
	{
		m_StatusIconTriggerSkill[toIndex].AddRow();
		Col = 0;
		while((Col < m_StatusIconTriggerSkill[fromIndex].GetColCount(Row)))
		{
			m_StatusIconTriggerSkill[fromIndex].GetItem(Row, Col, Info);
			m_StatusIconTriggerSkill[toIndex].AddCol(Row, Info);
			Col++;
		}
		Row++;
	}
	m_StatusIconBuff[toIndex].Clear();
	Row = 0;
	while((Row < m_StatusIconBuff[fromIndex].GetRowCount()))
	{
		m_StatusIconBuff[toIndex].AddRow();
		Col = 0;
		while((Col < m_StatusIconBuff[fromIndex].GetColCount(Row)))
		{
			m_StatusIconBuff[fromIndex].GetItem(Row, Col, Info);
			m_StatusIconBuff[toIndex].AddCol(Row, Info);
			Col++;
		}
		Row++;
	}
	return;
}

function HandleSummonedStatusSpelledListInsert(string param)
{
	local int i, Id, Max;
	local StatusIconInfo Info;
	local StatusIconHandle tmpStatusIcon;
	local int curreSlotIndex;

	ParseInt(param, "ID", Id);
	curreSlotIndex = GetIsSummonedSlotIndex(Id);
	if((curreSlotIndex < 0))
	{
		return;
	}
	Info.ServerID = Id;
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
		ParseInt(param, ("SpellerID_" $ string(i)), Info.SpellerID);
		Info.bHideRemainTime = true;
		if(IsValidItemID(Info.Id))
		{
			Info.IconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(Info.Id, Info.Level, Info.SubLevel);
			Info.IconPanel = Class'NWindow.UIDATA_SKILL'.static.GetIconPanel(Info.Id, Info.Level, Info.SubLevel);
			if((GetDebuffType(Info.Id, Info.Level, Info.SubLevel) != 0))
			{
				tmpStatusIcon = m_StatusIconDeBuff[curreSlotIndex];
			}
			else if((GetIndexByIsMagic(Info) == 3))
			{
				tmpStatusIcon = m_StatusIconSongDance[curreSlotIndex];
			}
			else if((GetIndexByIsMagic(Info) == 4))
			{
				tmpStatusIcon = m_StatusIconItem[curreSlotIndex];
			}
			else if((GetIndexByIsMagic(Info) == 5))
			{
				tmpStatusIcon = m_StatusIconTriggerSkill[curreSlotIndex];
			}
			else
			{
				tmpStatusIcon = m_StatusIconBuff[curreSlotIndex];
			}
			if(((tmpStatusIcon.GetRowCount() == 0) || ((float(tmpStatusIcon.GetColCount((tmpStatusIcon.GetRowCount() - 1))) % 12.0000000) == 0.0000000)))
			{
				tmpStatusIcon.AddRow();
			}
			tmpStatusIcon.AddCol((tmpStatusIcon.GetRowCount() - 1), Info);
		}
		i++;
	}
	UpdateBuff(curreSlotIndex);
	return;
}

function UpdateBuff(int curreSlotIndex)
{
	if((m_CurBf == 1))
	{
		m_StatusIconBuff[curreSlotIndex].ShowWindow();
		m_StatusIconDeBuff[curreSlotIndex].ShowWindow();
		m_StatusIconSongDance[curreSlotIndex].HideWindow();
		m_StatusIconItem[curreSlotIndex].HideWindow();
		m_StatusIconTriggerSkill[curreSlotIndex].HideWindow();
	}
	else if((m_CurBf == 2))
	{
		m_StatusIconBuff[curreSlotIndex].HideWindow();
		m_StatusIconDeBuff[curreSlotIndex].HideWindow();
		m_StatusIconSongDance[curreSlotIndex].ShowWindow();
		m_StatusIconItem[curreSlotIndex].HideWindow();
		m_StatusIconTriggerSkill[curreSlotIndex].HideWindow();
	}
	else if((m_CurBf == 3))
	{
		m_StatusIconBuff[curreSlotIndex].HideWindow();
		m_StatusIconDeBuff[curreSlotIndex].HideWindow();
		m_StatusIconSongDance[curreSlotIndex].HideWindow();
		m_StatusIconItem[curreSlotIndex].ShowWindow();
		m_StatusIconTriggerSkill[curreSlotIndex].HideWindow();
	}
	else if((m_CurBf == 4))
	{
		m_StatusIconBuff[curreSlotIndex].HideWindow();
		m_StatusIconDeBuff[curreSlotIndex].HideWindow();
		m_StatusIconSongDance[curreSlotIndex].HideWindow();
		m_StatusIconItem[curreSlotIndex].HideWindow();
		m_StatusIconTriggerSkill[curreSlotIndex].ShowWindow();
	}
	else
	{
		m_StatusIconBuff[curreSlotIndex].HideWindow();
		m_StatusIconDeBuff[curreSlotIndex].HideWindow();
		m_StatusIconSongDance[curreSlotIndex].HideWindow();
		m_StatusIconItem[curreSlotIndex].HideWindow();
		m_StatusIconTriggerSkill[curreSlotIndex].HideWindow();
	}
	return;
}

function HandleShowBuffIcon(string param)
{
	local int nShow;

	ParseInt(param, "Show", nShow);
	if((nShow == 1))
	{
		UpdateBuff(0);
		UpdateBuff(1);
		UpdateBuff(2);
		UpdateBuff(3);
	}
	else
	{
		UpdateBuff(0);
		UpdateBuff(1);
		UpdateBuff(2);
		UpdateBuff(3);
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
	UpdateBuff(0);
	UpdateBuff(1);
	UpdateBuff(2);
	UpdateBuff(3);
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

function HandleSummonInfoUpdate(int ServerID)
{
	local SummonInfo Info;
	local int SlotIndex;

	if(GetSummonInfo(ServerID, Info))
	{
		SlotIndex = GetIsSummonedSlotIndex(ServerID);
		if((SlotIndex == -1))
		{
			SlotIndex = getSummonedSlotIndex();
			inputStatus(SlotIndex, ServerID);
			reSizeWindow((SlotIndex + 1));
		}
		setStatusBar(SlotIndex);
	}
	return;
}

function delStatus(int SlotIndex, int firstSlotIndex)
{
	local int i;

	i = SlotIndex;
	while((i < (firstSlotIndex - 1)))
	{
		summonedServerID[i] = summonedServerID[(i + 1)];
		copySpelledList((i + 1), i);
		setStatusBar(i);
		i++;
	}
	GetWindowHandle(((m_Windowname $ ".SummonedStatusWnd") $ string(firstSlotIndex))).HideWindow();
	summonedServerID[(firstSlotIndex - 1)] = -1;
	return;
}

function reSizeWindow(int firstSlotIndex)
{
	local int W, h, h2;

	h2 = MeHeight(firstSlotIndex);
	Me.GetWindowSize(W, h);
	Me.SetWindowSize(W, h2);
	if(getInstanceUIData().GetIsClassicServer())
	{
		Me.SetResizeFrameSize(14, h2);
	}
	else
	{
		Me.SetResizeFrameSize(10, h2);
	}
	return;
}

function int MeHeight(int SlotIndex)
{
	return (StatusWnd_SIZE_HEIGHT * SlotIndex);
}

function inputStatus(int SlotIndex, int ServerID)
{
	summonedServerID[SlotIndex] = ServerID;
	GetWindowHandle(((m_Windowname $ ".SummonedStatusWnd") $ string((SlotIndex + 1)))).ShowWindow();
	return;
}

function setStatusBar(int SlotIndex)
{
	local int ServerID;
	local SummonInfo Info;
	local int Hp, MaxHP, MP, maxMP;
	local string Name;

	ServerID = summonedServerID[SlotIndex];
	if(GetSummonInfo(ServerID, Info))
	{
		Hp = Info.nCurHP;
		MaxHP = Info.nMaxHP;
		MP = Info.nCurMP;
		maxMP = Info.nMaxMP;
		Name = Info.Name;
		GetNameCtrlHandle((((m_Windowname $ ".SummonedStatusWnd") $ string((SlotIndex + 1))) $ ".PetName")).SetName(Name, NCT_Normal, TA_Left);
		GetStatusBarHandle((((m_Windowname $ ".SummonedStatusWnd") $ string((SlotIndex + 1))) $ ".barHP_1")).SetPoint(INT64(Hp), INT64(MaxHP));
		GetStatusBarHandle((((m_Windowname $ ".SummonedStatusWnd") $ string((SlotIndex + 1))) $ ".barMP_1")).SetPoint(INT64(MP), INT64(maxMP));
		if((Hp <= 0))
		{
			m_IsDead[SlotIndex].ShowWindow();
		}
		else
		{
			m_IsDead[SlotIndex].HideWindow();
		}
	}
	return;
}

function setStatusBarHP(int SlotIndex, int CurHP)
{
	local int ServerID;
	local SummonInfo Info;
	local int MaxHP;

	ServerID = summonedServerID[SlotIndex];
	if(GetSummonInfo(ServerID, Info))
	{
		MaxHP = Info.nMaxHP;
		GetStatusBarHandle((((m_Windowname $ ".SummonedStatusWnd") $ string((SlotIndex + 1))) $ ".barHP_1")).SetPoint(INT64(CurHP), INT64(MaxHP));
		if((CurHP <= 0))
		{
			m_IsDead[SlotIndex].ShowWindow();
		}
		else
		{
			m_IsDead[SlotIndex].HideWindow();
		}
	}
	return;
}

function setStatusBarMP(int SlotIndex, int curMP)
{
	local int ServerID;
	local SummonInfo Info;
	local int maxMP;

	ServerID = summonedServerID[SlotIndex];
	if(GetSummonInfo(ServerID, Info))
	{
		maxMP = Info.nMaxMP;
		GetStatusBarHandle((((m_Windowname $ ".SummonedStatusWnd") $ string((SlotIndex + 1))) $ ".barMP_1")).SetPoint(INT64(curMP), INT64(maxMP));
	}
	return;
}

function OnClickItem(string strID, int Index)
{
	local int Row, Col;
	local StatusIconInfo Info;
	local SkillInfo SkillInfo;
	local StatusIconHandle StatusIcon;
	local string tmpNum;

	Col = (Index / 10);
	Row = (Index - (Col * 10));
	tmpNum = Right(strID, 1);
	StatusIcon = GetStatusIconHandle(((((m_Windowname $ ".SummonedStatusWnd") $ tmpNum) $ ".") $ strID));
	StatusIcon.GetItem(Row, Col, Info);
	if(!GetSkillInfo(Info.Id.ClassID, Info.Level, Info.SubLevel, SkillInfo))
	{
		return;
	}
	if(((((InStr(strID, ("StatusIconBuff" $ tmpNum)) > -1) || (InStr(strID, ("StatusIconDeBuff" $ tmpNum)) > -1)) || (InStr(strID, ("StatusIconSongDance" $ tmpNum)) > -1)) || (InStr(strID, ("StatusIconTriggerSkill" $ tmpNum)) > -1)))
	{
		if(((SkillInfo.Debuff == 0) && (SkillInfo.OperateType == 1)))
		{
			RequestDispel(Info.ServerID, Info.Id, Info.Level, Info.SubLevel);
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
	local string UserName;
	local UserInfo targetUserInfo;
	local int ServerID, Num;
	local string WindowName;
	local WindowHandle hParent;

	rectWnd = Me.GetRect();
	if(((X > rectWnd.nX) && (X < (rectWnd.nX + rectWnd.nWidth))))
	{
		if(((Y > rectWnd.nY) && (Y < (rectWnd.nY + rectWnd.nHeight))))
		{
			WindowName = a_WindowHandle.GetWindowName();
			if((WindowName != ""))
			{
				if((Left(WindowName, Len(m_Windowname)) != m_Windowname))
				{
					hParent = a_WindowHandle.GetParentWindowHandle();
					WindowName = hParent.GetWindowName();
				}
				Num = (int(Right(WindowName, 1)) - 1);
				ServerID = summonedServerID[Num];
			}
			if((ServerID > 0))
			{
				UserName = Class'NWindow.UIDATA_USER'.static.GetUserName(ServerID);
				if((UserName != ""))
				{
					if(GetTargetInfo(targetUserInfo))
					{
					}
					if((targetUserInfo.nID != ServerID))
					{
						setTargetByServerID(ServerID);
					}
					getInstanceContextMenu().execContextEvent(UserName, ServerID, X, Y);
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
	m_Windowname="SummonedStatusWnd"
}
