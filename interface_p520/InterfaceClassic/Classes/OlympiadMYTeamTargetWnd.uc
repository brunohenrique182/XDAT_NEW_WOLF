class OlympiadMYTeamTargetWnd extends OlympiadTargetWnd;

var string m_Windowname;

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

function HandleUserInfo(string param)
{
	local int IsPlayer, PlayerNum, i, m_UserInfoIdx, MyTeamNum;
	local UserInfo myInfo;

	ParseInt(param, "IsPlayer", IsPlayer);
	ParseInt(param, "TotalCount", m_TotalCount);
	ParseInt(param, "MyTeamNum", MyTeamNum);
	GetPlayerInfo(myInfo);
	if((IsPlayer != 0))
	{
		return;
	}
	if((m_TotalCount <= 2))
	{
		return;
	}
	m_TeamCount = 0;
	m_UserInfoIdx = 0;
	i = 0;
	while((i < m_TotalCount))
	{
		ParseInt(param, ("PlayerNum_" $ string(i)), PlayerNum);
		if((PlayerNum == MyTeamNum))
		{
			m_TeamCount++;
		}
		else
		{
			i++;
			continue;
		}
		ParseInt(param, ("ID_" $ string(i)), m_id[m_UserInfoIdx]);
		ParseString(param, ("Name_" $ string(i)), m_name[m_UserInfoIdx]);
		if((myInfo.Name == m_name[m_UserInfoIdx]))
		{
			i++;
			continue;
		}
		ParseInt(param, ("ClassID_" $ string(i)), m_ClassID[m_UserInfoIdx]);
		ParseInt(param, ("MaxHP_" $ string(i)), m_MaxHP[m_UserInfoIdx]);
		ParseInt(param, ("CurHP_" $ string(i)), m_CurHP[m_UserInfoIdx]);
		ParseInt(param, ("MaxCP_" $ string(i)), m_MaxCP[m_UserInfoIdx]);
		ParseInt(param, ("CurCP_" $ string(i)), m_CurCP[m_UserInfoIdx]);
		m_UserInfoIdx++;
		i++;
	}
	if(((m_TeamCount - 1) <= 0))
	{
		Me.HideWindow();
	}
	else
	{
		ShowWindowCtrl((m_TeamCount - 1));
	}
	return;
}

function HandleBuffInfo(string param)
{
	local int Id, i, j, Max, CurRow;
	local StatusIconInfo Info;
	local int numOfBuff;

	ParseInt(param, "PlayerID", Id);
	i = findID(Id);
	if((i != -1))
	{
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
	}
	return;
}

function UpdateStatus()
{
	local int i;

	i = 0;
	while((i < m_TeamCount))
	{
		m_PlayerName[i].SetName(m_name[i], NCT_Normal, TA_Center);
		m_PlayerName[i].SetNameWithColor(m_name[i], NCT_Normal, TA_Center, getInstanceL2Util().Yellow);
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

defaultproperties
{
	m_Windowname="OlympiadMYTeamTargetWnd"
}
