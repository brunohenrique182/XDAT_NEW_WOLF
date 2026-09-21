class AbnormalStatusWnd extends UICommonAPI;

const NSTATUSICON_FRAMESIZE = 12;

var WindowHandle Me;
var StatusIconHandle StatusIcon;
var int NSTATUSICON_MAXCOL;
var int m_EtcStatusRow;
var int m_ShortStatusRow;
var bool m_bOnCurState;

function ClearNormals()
{
	ClearStatus(false, false);
	return;
}

function ClearStatus(bool bEtcItem, bool bShortItem)
{
	local int i, j, rowcount, RowCountTmp, ColCount;
	local StatusIconInfo Info;

	if(((bEtcItem == true) && (bShortItem == false)))
	{
		m_EtcStatusRow = -1;
	}
	if(((bEtcItem == false) && (bShortItem == true)))
	{
		m_ShortStatusRow = -1;
	}
	rowcount = StatusIcon.GetRowCount();
	i = 0;
	while((i < rowcount))
	{
		ColCount = StatusIcon.GetColCount(i);
		j = 0;
		while((j < ColCount))
		{
			StatusIcon.GetItem(i, j, Info);
			if(IsValidItemID(Info.Id))
			{
				if(((Info.bEtcItem == bEtcItem) && (Info.bShortItem == bShortItem)))
				{
					StatusIcon.DelItem(i, j);
					j--;
					ColCount--;
					RowCountTmp = StatusIcon.GetRowCount();
					if((RowCountTmp != rowcount))
					{
						i--;
						rowcount--;
					}
				}
			}
			j++;
		}
		i++;
	}
	return;
}

function ClearAll()
{
	ClearNormals();
	ClearStatus(true, false);
	ClearStatus(false, true);
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(950);
	RegisterEvent(960);
	RegisterEvent(970);
	RegisterEvent(40);
	RegisterEvent(310);
	RegisterEvent(1900);
	RegisterEvent(3410);
	RegisterEvent(8000);
	return;
}

function OnLoad()
{
	NSTATUSICON_MAXCOL = 12;
	m_EtcStatusRow = -1;
	m_ShortStatusRow = -1;
	m_bOnCurState = false;
	InitHandle();
	return;
}

function InitHandle()
{
	Me = GetWindowHandle("AbnormalStatusWnd");
	StatusIcon = GetStatusIconHandle("AbnormalStatusWnd.StatusIcon");
	return;
}

function OnDefaultPosition()
{
	Me.EnableTick();
	return;
}

function OnTick()
{
	local string StatusWndName;

	if(getInstanceUIData().GetIsLiveServer())
	{
		StatusWndName = "StatusWnd";
		Me.SetAnchor(StatusWndName, "TopRight", "TopLeft", 6, 0);
	}
	else
	{
		StatusWndName = "StatusWndClassic";
		Me.SetAnchor(StatusWndName, "BottomLeft", "TopLeft", 0, 26);
	}
	Me.ClearAnchor();
	Me.DisableTick();
	return;
}

function OnEnterState(name a_CurrentStateName)
{
	m_bOnCurState = true;
	UpdateWindowSize();
	return;
}

function OnExitState(name a_CurrentStateName)
{
	m_bOnCurState = false;
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 8000:
			if(getInstanceUIData().GetIsLiveServer())
			{
				NSTATUSICON_MAXCOL = 12;
			}
			else
			{
				NSTATUSICON_MAXCOL = 24;
			}
			break;
		case 950:
			HandleAddNormalStatus(param);
			break;
		case 960:
			HandleAddEtcStatus(param);
			break;
		case 970:
			HandleAddShortStatus(param);
			break;
		case 40:
			ClearAll();
			break;
		case 310:
			Me.HideWindow();
			break;
		case 1900:
			HandleLanguageChanged();
			break;
		case 3410:
			if((param == "GAMINGSTATE"))
			{
				UpdateWindowSize();
			}
			break;
		default:
			break;
	}
	return;
}

function OnShow()
{
	local int rowcount;

	rowcount = StatusIcon.GetRowCount();
	if((rowcount < 1))
	{
		Me.HideWindow();
	}
	return;
}

function OnClickItem(string strID, int Index)
{
	local int Row, Col;
	local StatusIconInfo Info;
	local SkillInfo SkillInfo;

	Col = (Index / 10);
	Row = (Index - (Col * 10));
	StatusIcon.GetItem(Row, Col, Info);
	if(!GetSkillInfo(Info.Id.ClassID, Info.Level, Info.SubLevel, SkillInfo))
	{
		return;
	}
	if((InStr(strID, "StatusIcon") > -1))
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

function HandleAddNormalStatus(string param)
{
	local int i, Max;
	local StatusIconInfo Info;
	local SkillInfo _skillInfo;
	local array<StatusIconInfo> arrSongDance, arrDebuff, arrItembuff, arrTriggerSkill, arrBuff, arrExtendBuff;
	local bool isDebuff;

	ClearNormals();
	Info.Size = 24;
	Info.BackTex = "L2UI.EtcWndBack.AbnormalBack";
	Info.bShow = true;
	Info.bEtcItem = false;
	Info.bShortItem = false;
	ParseInt(param, "ServerID", Info.ServerID);
	ParseInt(param, "Max", Max);
	i = 0;
	while((i < Max))
	{
		ParseItemIDWithIndex(param, Info.Id, i);
		ParseString(param, ("IconPanel_" $ string(i)), Info.IconPanel);
		ParseInt(param, ("SkillLevel_" $ string(i)), Info.Level);
		ParseInt(param, ("SkillSubLevel_" $ string(i)), Info.SubLevel);
		ParseInt(param, ("RemainTime_" $ string(i)), Info.RemainTime);
		ParseString(param, ("Name_" $ string(i)), Info.Name);
		ParseString(param, ("IconName_" $ string(i)), Info.IconName);
		ParseString(param, ("Description_" $ string(i)), Info.Description);
		ParseInt(param, ("SpellerID_" $ string(i)), Info.SpellerID);
		if(!GetSkillInfo(Info.Id.ClassID, Info.Level, Info.SubLevel, _skillInfo))
		{
			i++;
			continue;
		}
		if(IsIconHide(Info.Id, Info.Level, Info.SubLevel))
		{
			i++;
			continue;
		}
		if(!IsValidItemID(Info.Id))
		{
			i++;
			continue;
		}
		isDebuff = (GetDebuffType(Info.Id, Info.Level, Info.SubLevel) != 0);
		if((isDebuff && getInstanceUIData().GetIsClassicServer()))
		{
			arrDebuff.Length = (arrDebuff.Length + 1);
			arrDebuff[(arrDebuff.Length - 1)] = Info;
			i++;
			continue;
		}
		switch(_skillInfo.IsMagic)
		{
			case 3:
				arrSongDance.Length = (arrSongDance.Length + 1);
				arrSongDance[(arrSongDance.Length - 1)] = Info;
				break;
			case 4:
				arrItembuff.Length = (arrItembuff.Length + 1);
				arrItembuff[(arrItembuff.Length - 1)] = Info;
				break;
			case 5:
				arrTriggerSkill.Length = (arrTriggerSkill.Length + 1);
				arrTriggerSkill[(arrTriggerSkill.Length - 1)] = Info;
				break;
			case 0:
			case 1:
				if(isDebuff)
				{
					arrDebuff.Length = (arrDebuff.Length + 1);
					arrDebuff[(arrDebuff.Length - 1)] = Info;
				}
				else if(getInstanceUIData().GetIsLiveServer())
				{
					arrBuff.Length = (arrBuff.Length + 1);
					arrBuff[(arrBuff.Length - 1)] = Info;
				}
				else if((((_skillInfo.OperateType == 1) || (_skillInfo.OperateType == 3)) || (_skillInfo.OperateType == 6)))
				{
					arrExtendBuff[arrExtendBuff.Length] = Info;
				}
				else
				{
					arrBuff.Length = (arrBuff.Length + 1);
					arrBuff[(arrBuff.Length - 1)] = Info;
				}
				break;
			default:
				if(isDebuff)
				{
					arrDebuff.Length = (arrDebuff.Length + 1);
					arrDebuff[(arrDebuff.Length - 1)] = Info;
				}
				else
				{
					arrBuff.Length = (arrBuff.Length + 1);
					arrBuff[(arrBuff.Length - 1)] = Info;
				}
				break;
		}
		i++;
	}
	AbnormalStatusExtendWnd(GetScript("AbnormalStatusExtendWnd")).AddBuff(arrExtendBuff);
	InsertBuffList(arrBuff);
	if(getInstanceUIData().GetIsClassicServer())
	{
		InsertBuffList(arrItembuff);
		InsertBuffList(arrSongDance);
		InsertBuffList(arrTriggerSkill);
	}
	else
	{
		InsertBuffList(arrSongDance);
		InsertBuffList(arrItembuff);
		InsertBuffList(arrTriggerSkill);
	}
	InsertBuffList(arrDebuff);
	if((m_EtcStatusRow > -1))
	{
		m_EtcStatusRow = StatusIcon.GetRowCount();
	}
	if((m_ShortStatusRow > -1))
	{
		m_ShortStatusRow = StatusIcon.GetRowCount();
	}
	UpdateWindowSize();
	return;
}

function bool InsertBuffList(array<StatusIconInfo> statusIconInfs)
{
	local int i, rowcount;

	if(((m_EtcStatusRow == -1) && (m_ShortStatusRow == -1)))
	{
		rowcount = StatusIcon.GetRowCount();
	}
	else
	{
		rowcount = (StatusIcon.GetRowCount() - 1);
	}
	i = 0;
	while((i < statusIconInfs.Length))
	{
		if(((float(i) % float(NSTATUSICON_MAXCOL)) == 0.0000000))
		{
			rowcount++;
			StatusIcon.InsertRow((rowcount - 1));
		}
		StatusIcon.AddCol((rowcount - 1), statusIconInfs[i]);
		i++;
	}
	return (statusIconInfs.Length > 0);
}

function HandleAddEtcStatus(string param)
{
	local int i, Max;
	local StatusIconInfo Info;

	ClearStatus(true, false);
	Info.Size = 24;
	Info.BackTex = "L2UI.EtcWndBack.AbnormalBack";
	Info.bShow = true;
	Info.bEtcItem = true;
	Info.bShortItem = false;
	ParseInt(param, "Max", Max);
	i = 0;
	while((i < Max))
	{
		ParseItemIDWithIndex(param, Info.Id, i);
		ParseInt(param, ("SkillLevel_" $ string(i)), Info.Level);
		ParseInt(param, ("RemainTime_" $ string(i)), Info.RemainTime);
		ParseString(param, ("Name_" $ string(i)), Info.Name);
		ParseString(param, ("IconName_" $ string(i)), Info.IconName);
		ParseString(param, ("Description_" $ string(i)), Info.Description);
		ParseString(param, ("IconPanel_" $ string(i)), Info.IconPanel);
		if(IsValidItemID(Info.Id))
		{
			if(((m_EtcStatusRow == -1) && (m_ShortStatusRow == -1)))
			{
				m_EtcStatusRow = StatusIcon.GetRowCount();
				StatusIcon.AddRow();
			}
			StatusIcon.AddCol(m_EtcStatusRow, Info);
		}
		i++;
	}
	UpdateWindowSize();
	return;
}

function HandleAddShortStatus(string param)
{
	local int i, Max, CurCol;
	local StatusIconInfo Info;

	ClearStatus(false, true);
	Info.Size = 24;
	Info.BackTex = "L2UI.EtcWndBack.AbnormalBack";
	Info.bShow = true;
	Info.bEtcItem = false;
	Info.bShortItem = true;
	CurCol = -1;
	ParseInt(param, "Max", Max);
	i = 0;
	while((i < Max))
	{
		ParseItemIDWithIndex(param, Info.Id, i);
		ParseInt(param, ("SkillLevel_" $ string(i)), Info.Level);
		ParseInt(param, ("SkillSubLevel_" $ string(i)), Info.SubLevel);
		ParseInt(param, ("RemainTime_" $ string(i)), Info.RemainTime);
		ParseString(param, ("Name_" $ string(i)), Info.Name);
		ParseString(param, ("IconName_" $ string(i)), Info.IconName);
		ParseString(param, ("Description_" $ string(i)), Info.Description);
		ParseString(param, ("IconPanel_" $ string(i)), Info.IconPanel);
		if(IsValidItemID(Info.Id))
		{
			if(((m_EtcStatusRow == -1) && (m_ShortStatusRow == -1)))
			{
				m_ShortStatusRow = StatusIcon.GetRowCount();
				StatusIcon.AddRow();
			}
			CurCol++;
			StatusIcon.InsertCol(m_ShortStatusRow, CurCol, Info);
		}
		i++;
	}
	UpdateWindowSize();
	return;
}

function UpdateWindowSize()
{
	local int rowcount;
	local Rect rectWnd;

	rowcount = StatusIcon.GetRowCount();
	if((rowcount > 0))
	{
		if((m_bOnCurState && (GetGameStateName() != "TRAININGROOMSTATE")))
		{
			Me.ShowWindow();
		}
		else
		{
			Me.HideWindow();
		}
		rectWnd = StatusIcon.GetRect();
		if(getInstanceUIData().GetIsLiveServer())
		{
			Me.SetWindowSize((rectWnd.nWidth + 12), rectWnd.nHeight);
			Me.SetFrameSize(12, rectWnd.nHeight);
		}
		else
		{
			Me.SetWindowSize(rectWnd.nWidth, rectWnd.nHeight);
		}
	}
	else
	{
		Me.HideWindow();
	}
	return;
}

function HandleLanguageChanged()
{
	local int i, j, rowcount, ColCount;
	local StatusIconInfo Info;

	rowcount = StatusIcon.GetRowCount();
	i = 0;
	while((i < rowcount))
	{
		ColCount = StatusIcon.GetColCount(i);
		j = 0;
		while((j < ColCount))
		{
			StatusIcon.GetItem(i, j, Info);
			if(IsValidItemID(Info.Id))
			{
				Info.Name = Class'NWindow.UIDATA_SKILL'.static.GetName(Info.Id, Info.Level, Info.SubLevel);
				Info.Description = Class'NWindow.UIDATA_SKILL'.static.GetDescription(Info.Id, Info.Level, Info.SubLevel);
				StatusIcon.SetItem(i, j, Info);
			}
			j++;
		}
		i++;
	}
	return;
}
