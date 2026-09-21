class OlympiadTargetWnd extends UICommonAPI;

const MAX_OLYMPIAD_USER_NUM = 3;

var WindowHandle Me;
var WindowHandle m_TargetWnd[3];
var StatusBarHandle m_BarCP[3];
var StatusBarHandle m_BarHP[3];
var NameCtrlHandle m_PlayerName[3];
var int m_PlayerNum;
var int m_id[3];
var string m_name[3];
var int m_ClassID[3];
var int m_MaxHP[3];
var int m_CurHP[3];
var int m_MaxCP[3];
var int m_CurCP[3];
var int m_TotalCount;
var StatusIconHandle StatusIcon[3];
var int m_TeamCount;
var string m_Windowname;

function OnRegisterEvent()
{
	RegisterEvent(900);
	RegisterEvent(920);
	RegisterEvent(910);
	RegisterEvent(940);
	RegisterEvent(11682);
	return;
}

function OnLoad()
{
	local int i;

	Me = GetWindowHandle(m_Windowname);
	i = 0;
	while((i < 3))
	{
		m_TargetWnd[i] = GetWindowHandle(((m_Windowname $ ".TargetWnd") $ string(i)));
		m_BarCP[i] = GetStatusBarHandle((((m_Windowname $ ".TargetWnd") $ string(i)) $ ".barcp"));
		m_BarHP[i] = GetStatusBarHandle((((m_Windowname $ ".TargetWnd") $ string(i)) $ ".barhp"));
		m_PlayerName[i] = GetNameCtrlHandle((((m_Windowname $ ".TargetWnd") $ string(i)) $ ".PlayerName"));
		StatusIcon[i] = GetStatusIconHandle((((m_Windowname $ ".TargetWnd") $ string(i)) $ ".BuffWnd"));
		i++;
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 900))
	{
		Clear();
		ParseInt(param, "PlayerNum", m_PlayerNum);
		Debug(("EV_OlympiadTargetShow" @ param));
	}
	else if((Event_ID == 920))
	{
		Debug(("OlympiadTargetWnd EV_OlympiadUserInfo" @ param));
		HandleUserInfo(param);
		UpdateStatus();
	}
	else if((Event_ID == 910))
	{
		Debug(("EV_OlympiadMatchEnd-->" @ param));
		Clear();
		HideAllWindow();
	}
	else if((Event_ID == 940))
	{
		Debug(("EV_OlympiadBuffInfo-->" @ param));
		HandleBuffInfo(param);
	}
	else if((Event_ID == 11682))
	{
		HandleUpdateOlympiadUserMaxHPBlockPer(param);
	}
	return;
}

function OnEnterState(name a_CurrentStateName)
{
	Clear();
	return;
}

function Clear()
{
	local int i;

	m_PlayerNum = 0;
	i = 0;
	while((i < 3))
	{
		m_id[i] = 0;
		m_name[i] = "";
		m_ClassID[i] = 0;
		m_MaxHP[i] = 0;
		m_CurHP[i] = 0;
		m_MaxCP[i] = 0;
		m_CurCP[i] = 0;
		i++;
	}
	UpdateStatus();
	HideAllWindow();
	return;
}

function HandleUserInfo(string param)
{
	local int IsPlayer, PlayerNum, i, m_UserInfoIdx, MyTeamNum;

	ParseInt(param, "IsPlayer", IsPlayer);
	if((IsPlayer != 0))
	{
		return;
	}
	ParseInt(param, "TotalCount", m_TotalCount);
	ParseInt(param, "MyTeamNum", MyTeamNum);
	m_TeamCount = 0;
	m_UserInfoIdx = 0;
	i = 0;
	while((i < m_TotalCount))
	{
		ParseInt(param, ("PlayerNum_" $ string(i)), PlayerNum);
		if((PlayerNum != m_PlayerNum))
		{
			i++;
			continue;
		}
		else
		{
			m_TeamCount++;
		}
		ParseInt(param, ("ID_" $ string(i)), m_id[m_UserInfoIdx]);
		ParseString(param, ("Name_" $ string(i)), m_name[m_UserInfoIdx]);
		ParseInt(param, ("ClassID_" $ string(i)), m_ClassID[m_UserInfoIdx]);
		ParseInt(param, ("MaxHP_" $ string(i)), m_MaxHP[m_UserInfoIdx]);
		ParseInt(param, ("CurHP_" $ string(i)), m_CurHP[m_UserInfoIdx]);
		ParseInt(param, ("MaxCP_" $ string(i)), m_MaxCP[m_UserInfoIdx]);
		ParseInt(param, ("CurCP_" $ string(i)), m_CurCP[m_UserInfoIdx]);
		m_UserInfoIdx++;
		i++;
	}
	ShowWindowCtrl(m_TeamCount);
	return;
}

function UpdateStatus()
{
	local int i;

	i = 0;
	while((i < m_TeamCount))
	{
		m_PlayerName[i].SetName(m_name[i], NCT_Normal, TA_Center);
		if((m_MaxCP[i] > 0))
		{
			m_BarCP[i].SetPoint(INT64(m_CurCP[i]), INT64(m_MaxCP[i]));
		}
		else
		{
			m_BarCP[i].SetPoint(INT64(0), INT64(0));
		}
		if((m_MaxHP[i] > 0))
		{
			m_BarHP[i].SetPoint(INT64(m_CurHP[i]), INT64(m_MaxHP[i]));
			i++;
			continue;
		}
		m_BarHP[i].SetPoint(INT64(0), INT64(0));
		i++;
	}
	return;
}

function HandleUpdateOlympiadUserMaxHPBlockPer(string param)
{
	local int userServerId, maxHPBlockPer, idx;

	ParseInt(param, "ServerID", userServerId);
	ParseInt(param, "MaxHPBlockPer", maxHPBlockPer);
	idx = findID(userServerId);
	if((idx > -1))
	{
		if((maxHPBlockPer > 0))
		{
			m_BarHP[idx].SetDrawBlockEffect(true);
		}
		else
		{
			m_BarHP[idx].SetDrawBlockEffect(false);
		}
	}
	return;
}

function HandleBuffInfo(string param)
{
	local int Id, i, j, Max, CurRow;
	local StatusIconInfo Info;
	local int numOfBuff;
	local Rect rectWnd, mainWnd;

	ParseInt(param, "PlayerID", Id);
	i = findID(Id);
	Debug(("HandleBuffInfo-->ID--->i--->" @ string(i)));
	if((i != -1))
	{
		mainWnd = m_TargetWnd[i].GetRect();
		StatusIcon[i].MoveTo((mainWnd.nX - 7), (mainWnd.nY + 5));
		StatusIcon[i].Clear();
		CurRow = -1;
		ParseInt(param, "Max", Max);
		numOfBuff = 0;
		j = 0;
		while((j < Max))
		{
			ParseItemIDWithIndex(param, Info.Id, j);
			ParseInt(param, ("SkillLevel_" $ string(j)), Info.Level);
			ParseInt(param, ("SkillSubLevel_" $ string(j)), Info.SubLevel);
			if((GetDebuffType(Info.Id, Info.Level, Info.SubLevel) != 0))
			{
				if(IsIconHide(Info.Id, Info.Level, Info.SubLevel))
				{
					j++;
					continue;
				}
				if(Class'NWindow.UIDATA_SKILL'.static.IsToppingSkill(Info.Id, Info.Level, Info.SubLevel))
				{
					j++;
					continue;
				}
				if(((float(numOfBuff) % 12.0000000) == 0.0000000))
				{
					StatusIcon[i].AddRow();
					CurRow++;
				}
				ParseInt(param, ("RemainTime_" $ string(j)), Info.RemainTime);
				ParseInt(param, ("SpellerID_" $ string(j)), Info.SpellerID);
				ParseString(param, ("Name_" $ string(j)), Info.Name);
				ParseString(param, ("IconName_" $ string(j)), Info.IconName);
				ParseString(param, ("IconPanel_" $ string(i)), Info.IconPanel);
				ParseString(param, ("Description_" $ string(j)), Info.Description);
				Info.Size = 16;
				Info.BackTex = "L2UI.EtcWndBack.AbnormalBack";
				Info.bShow = true;
				Info.bHideRemainTime = true;
				StatusIcon[i].AddCol(CurRow, Info);
				numOfBuff++;
			}
			j++;
		}
		rectWnd = StatusIcon[i].GetRect();
		StatusIcon[i].MoveTo((rectWnd.nX - rectWnd.nWidth), rectWnd.nY);
	}
	return;
}

function int findID(int Id)
{
	local int i;

	i = 0;
	while((i < m_TeamCount))
	{
		if((Id == m_id[i]))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function ShowWindowCtrl(int Count)
{
	local int i;
	local Rect entireRect;

	entireRect = Me.GetRect();
	Me.ShowWindow();
	if((Count == 1))
	{
		m_TargetWnd[0].ShowWindow();
		m_BarCP[0].ShowWindow();
		m_BarHP[0].ShowWindow();
		m_PlayerName[0].ShowWindow();
		i = 1;
		while((i < 3))
		{
			m_TargetWnd[i].HideWindow();
			m_BarCP[i].HideWindow();
			m_BarHP[i].HideWindow();
			m_PlayerName[i].HideWindow();
			i++;
		}
		Me.SetWindowSize(entireRect.nWidth, 46);
	}
	else
	{
		i = 0;
		while((i < Count))
		{
			m_TargetWnd[i].ShowWindow();
			m_BarCP[i].ShowWindow();
			m_BarHP[i].ShowWindow();
			m_PlayerName[i].ShowWindow();
			i++;
		}
		if((Count > 1))
		{
			Me.SetWindowSize(entireRect.nWidth, (Count * 50));
		}
	}
	return;
}

function HideAllWindow()
{
	local int i;

	Me.HideWindow();
	i = 0;
	while((i < 3))
	{
		m_TargetWnd[i].HideWindow();
		m_BarCP[i].HideWindow();
		m_BarHP[i].HideWindow();
		m_PlayerName[i].HideWindow();
		i++;
	}
	return;
}

defaultproperties
{
	m_Windowname="OlympiadTargetWnd"
}
