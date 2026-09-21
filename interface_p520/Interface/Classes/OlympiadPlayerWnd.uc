class OlympiadPlayerWnd extends UICommonAPI;

const MAX_OLYMPIAD_USER_NUM = 3;
const MAX_OLYMPIAD_TEAM_NUM = 2;
const MAX_OLYMPIAD_SKILL_MSG = 5;
const MAX_OLYMPIAD_ALLSKILL_MSG = 15;
const CONTRACT_HEIGHT = 44;
const EXPAND_HEIGHT = 124;
const NSTATUSICON_FRAMESIZE = 12;
const NSTATUSICON_MAXCOL = 12;

struct OlympiadUserInfo
{
	var int m_TeamID;
	var int m_id;
	var string m_name;
	var int m_ClassID;
	var int m_MaxHP;
	var int m_CurHP;
	var int m_MaxCP;
	var int m_CurCP;
	var int m_MsgWnd;
};

var WindowHandle Me;
var WindowHandle m_StatusWnd[3];
var WindowHandle m_MsgWnd[3];
var NameCtrlHandle m_PlayerName[3];
var TextureHandle m_ClassIcon[3];
var StatusBarHandle m_BarCP[3];
var StatusBarHandle m_BarHP[3];
var TextBoxHandle m_TextBoxHandle[15];
var string m_Msg[15];
var StatusIconHandle StatusIcon[3];
var int m_PlayerNum;
var string m_Windowname;
var string m_BuffWindowName;
var bool m_Expand;
var int m_TotalCount;
var int m_MyTeamCount;
var int m_MsgStartLine[3];
var int m_MsgNextStartLine[3];
var int m_MyTeamNum;
var int m_IsPlayer;
var bool mFound;
var Color Red;
var Color Blue;
var OlympiadUserInfo UserInfo[3];

function SetPlayerNum(int PlayerNum)
{
	m_PlayerNum = PlayerNum;
	m_Windowname = (("OlympiadPlayer" $ string(m_PlayerNum)) $ "Wnd");
	m_BuffWindowName = (("OlympiadBuff" $ string(m_PlayerNum)) $ "Wnd");
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(920);
	RegisterEvent(910);
	RegisterEvent(290);
	RegisterEvent(280);
	RegisterEvent(930);
	RegisterEvent(940);
	RegisterEvent(11682);
	return;
}

function OnLoad()
{
	local int i, j;

	mFound = true;
	Me = GetWindowHandle(m_Windowname);
	i = 0;
	while((i < 3))
	{
		m_StatusWnd[i] = GetWindowHandle(((m_Windowname $ ".TargetWnd") $ string(i)));
		m_MsgWnd[i] = GetWindowHandle((((m_Windowname $ ".TargetWnd") $ string(i)) $ ".SysMsgWnd"));
		j = 0;
		while((j < 5))
		{
			m_TextBoxHandle[((i * 5) + j)] = GetTextBoxHandle((((((m_Windowname $ ".TargetWnd") $ string(i)) $ ".SysMsgWnd") $ ".txtMsg") $ string(j)));
			j++;
		}
		m_PlayerName[i] = GetNameCtrlHandle((((m_Windowname $ ".TargetWnd") $ string(i)) $ ".PlayerName"));
		m_ClassIcon[i] = GetTextureHandle((((m_Windowname $ ".TargetWnd") $ string(i)) $ ".ClassIcon"));
		m_BarCP[i] = GetStatusBarHandle((((m_Windowname $ ".TargetWnd") $ string(i)) $ ".barCP"));
		m_BarHP[i] = GetStatusBarHandle((((m_Windowname $ ".TargetWnd") $ string(i)) $ ".barHP"));
		StatusIcon[i] = GetStatusIconHandle((((m_Windowname $ ".TargetWnd") $ string(i)) $ ".BuffWnd"));
		i++;
	}
	i = 0;
	while((i < 3))
	{
		StatusIcon[i].SetAnchor(((m_Windowname $ ".TargetWnd") $ string(i)), "TopRight", "TopLeft", 1, 1);
		i++;
	}
	SetExpandMode(false);
	SetColor();
	return;
}

function SetColor()
{
	Red.R = 238;
	Red.G = 119;
	Red.B = 119;
	Red.A = 255;
	Blue.R = 102;
	Blue.G = 170;
	Blue.B = 238;
	Blue.A = 255;
	return;
}

function OnEnterState(name a_CurrentStateName)
{
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 920))
	{
		HandleUserInfo(param);
	}
	else if((Event_ID == 290))
	{
		HandleMagicSkillUse(param);
	}
	else if((Event_ID == 280))
	{
		HandleAttack(param);
	}
	else if((Event_ID == 930))
	{
	}
	else if((Event_ID == 940))
	{
		HandleBuffInfo(param);
	}
	else if((Event_ID == 910))
	{
		Clear();
	}
	else if((Event_ID == 11682))
	{
		HandleUpdateOlympiadUserMaxHPBlockPer(param);
	}
	return;
}

function HandleUpdateOlympiadUserMaxHPBlockPer(string param)
{
	local int userServerId, maxHPBlockPer, idx;

	ParseInt(param, "ServerID", userServerId);
	ParseInt(param, "MaxHPBlockPer", maxHPBlockPer);
	idx = FindOlympiadUserIndex(userServerId);
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

function int FindOlympiadUserIndex(int severId)
{
	local int idx;

	idx = 0;
	while((idx < 3))
	{
		if((UserInfo[idx].m_id == severId))
		{
			return idx;
		}
		idx++;
	}
	return -1;
}

function Clear()
{
	local int i;

	i = 0;
	while((i < 3))
	{
		UserInfo[i].m_TeamID = 0;
		UserInfo[i].m_id = 0;
		UserInfo[i].m_name = "";
		UserInfo[i].m_ClassID = 0;
		UserInfo[i].m_MaxHP = 0;
		UserInfo[i].m_CurHP = 0;
		UserInfo[i].m_MaxCP = 0;
		UserInfo[i].m_CurCP = 0;
		UserInfo[i].m_MsgWnd = 0;
		StatusIcon[i].Clear();
		i++;
	}
	i = 0;
	while((i < 15))
	{
		m_Msg[i] = "";
		i++;
	}
	i = 0;
	while((i < 3))
	{
		UpdateMsg(i, "");
		i++;
	}
	Me.HideWindow();
	return;
}

function Initialize()
{
	local int i;

	i = 0;
	while((i < 3))
	{
		UserInfo[i].m_TeamID = 0;
		UserInfo[i].m_id = 0;
		UserInfo[i].m_name = "";
		UserInfo[i].m_ClassID = 0;
		UserInfo[i].m_MaxHP = 0;
		UserInfo[i].m_CurHP = 0;
		UserInfo[i].m_MaxCP = 0;
		UserInfo[i].m_CurCP = 0;
		UserInfo[i].m_MsgWnd = 0;
		StatusIcon[i].Clear();
		m_MsgStartLine[i] = (15 * i);
		i++;
	}
	i = 0;
	while((i < 15))
	{
		m_Msg[i] = "";
		i++;
	}
	i = 0;
	while((i < 3))
	{
		UpdateMsg(i, "");
		i++;
	}
	return;
}

function OnShow()
{
	Initialize();
	return;
}

function HandleBuffInfo(string param)
{
	local int Id, i, j, Max, CurRow;
	local StatusIconInfo Info;
	local int numOfBuff;

	ParseInt(param, "PlayerID", Id);
	i = 0;
	while((i < m_MyTeamCount))
	{
		if(((Id < 1) || (Id == UserInfo[i].m_id)))
		{
			break;
		}
		i++;
	}
	if((i != m_MyTeamCount))
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
			StatusIcon[i].AddCol(CurRow, Info);
			numOfBuff++;
			j++;
		}
		if((Max > 0))
		{
		}
	}
	return;
}

function HandleUserInfo(string param)
{
	local int i, TeamID, PlayerID, m_ClassID;
	local string m_name;
	local int m_MaxHP, m_CurHP, m_MaxCP, m_CurCP, m_MsgWnd, m_UserInfoIdx;

	ParseInt(param, "IsPlayer", m_IsPlayer);
	if((m_IsPlayer != 1))
	{
		return;
	}
	ParseInt(param, "TotalCount", m_TotalCount);
	m_MyTeamCount = (m_TotalCount / 2);
	if(((m_TotalCount == 2) || (m_TotalCount == 6)))
	{
		m_UserInfoIdx = 0;
		i = 0;
		while((i < m_TotalCount))
		{
			ParseInt(param, ("PlayerNum_" $ string(i)), TeamID);
			if((TeamID != m_PlayerNum))
			{
				i++;
				continue;
			}
			ParseInt(param, ("ID_" $ string(i)), PlayerID);
			ParseString(param, ("Name_" $ string(i)), m_name);
			ParseInt(param, ("ClassID_" $ string(i)), m_ClassID);
			ParseInt(param, ("MaxHP_" $ string(i)), m_MaxHP);
			ParseInt(param, ("CurHP_" $ string(i)), m_CurHP);
			ParseInt(param, ("MaxCP_" $ string(i)), m_MaxCP);
			ParseInt(param, ("CurCP_" $ string(i)), m_CurCP);
			ParseInt(param, ("SysMsg_" $ string(i)), m_MsgWnd);
			UserInfo[m_UserInfoIdx].m_TeamID = TeamID;
			UserInfo[m_UserInfoIdx].m_id = PlayerID;
			UserInfo[m_UserInfoIdx].m_name = m_name;
			UserInfo[m_UserInfoIdx].m_ClassID = m_ClassID;
			UserInfo[m_UserInfoIdx].m_MaxHP = m_MaxHP;
			UserInfo[m_UserInfoIdx].m_CurHP = m_CurHP;
			UserInfo[m_UserInfoIdx].m_MaxCP = m_MaxCP;
			UserInfo[m_UserInfoIdx].m_CurCP = m_CurCP;
			UserInfo[m_UserInfoIdx].m_MsgWnd = m_MsgWnd;
			m_UserInfoIdx++;
			i++;
		}
		Resize((m_TotalCount / 2));
		UpdateUsersInfo();
	}
	return;
}

function HandleMagicSkillUse(string param)
{
	local int Id, SkillID, i;
	local string paramsend, strMsg;

	if(!Me.IsShowWindow())
	{
		return;
	}
	ParseInt(param, "AttackerID", Id);
	i = 0;
	while((i < m_MyTeamCount))
	{
		if(((Id < 1) || (Id == UserInfo[i].m_id)))
		{
			break;
		}
		i++;
	}
	if((i != m_MyTeamCount))
	{
		ParseInt(param, "SkillID", SkillID);
		if(!isSkill(SkillID))
		{
			return;
		}
		ParamAdd(paramsend, "Type", string(4));
		ParamAdd(paramsend, "param1", string(SkillID));
		ParamAdd(paramsend, "param2", "1");
		AddSystemMessageParam(paramsend);
		strMsg = EndSystemMessageParam(46, true);
		UpdateMsg(i, strMsg);
	}
	return;
}

function bool isSkill(int SkillID)
{
	if(((SkillID > 0) && (SkillID < 1900)))
	{
		return true;
	}
	else if(((SkillID > 10000) && (SkillID < 12000)))
	{
		return true;
	}
	return false;
}

function HandleAttack(string param)
{
	local int attackerId;
	local string AttackerName;
	local int defenderId, Critical, Miss, ShieldDefense, i;
	local string paramsend, strMsg;

	ParseInt(param, "AttackerID", attackerId);
	ParseString(param, "AttackerName", AttackerName);
	ParseInt(param, "DefenderID", defenderId);
	ParseInt(param, "Critical", Critical);
	ParseInt(param, "Miss", Miss);
	ParseInt(param, "ShieldDefense", ShieldDefense);
	i = 0;
	while((i < m_MyTeamCount))
	{
		if(((attackerId > 0) && (attackerId == UserInfo[i].m_id)))
		{
			if((Critical > 0))
			{
				UpdateMsg(i, GetSystemMessage(44));
			}
			i++;
			continue;
		}
		if(((defenderId > 0) && (defenderId == UserInfo[i].m_id)))
		{
			if((Miss > 0))
			{
				ParamAdd(paramsend, "Type", string(0));
				ParamAdd(paramsend, "param1", AttackerName);
				AddSystemMessageParam(paramsend);
				strMsg = EndSystemMessageParam(42, true);
				UpdateMsg(i, strMsg);
				i++;
				continue;
			}
			if((ShieldDefense > 0))
			{
				UpdateMsg(i, GetSystemMessage(111));
			}
		}
		i++;
	}
	return;
}

function UpdateMsg(int Userindex, string strMsg)
{
	local int i, CurPos, BoxPos;

	m_MsgStartLine[Userindex] = int((float((Userindex * 5)) + (float(m_MsgNextStartLine[Userindex]) % 5.0000000)));
	m_Msg[m_MsgStartLine[Userindex]] = strMsg;
	m_MsgNextStartLine[Userindex] = (m_MsgStartLine[Userindex] + 1);
	i = 0;
	while((i < 5))
	{
		CurPos = int((float((Userindex * 5)) + (float((m_MsgStartLine[Userindex] + i)) % 5.0000000)));
		BoxPos = ((((Userindex * 5) + 5) - 1) - i);
		m_TextBoxHandle[BoxPos].SetText(m_Msg[CurPos]);
		i++;
	}
	return;
}

function UpdateUsersInfo()
{
	local int i;

	i = 0;
	while((i < m_MyTeamCount))
	{
		UpdateUserInfo(i);
		i++;
	}
	Me.ShowWindow();
	return;
}

function UpdateUserInfo(int Index)
{
	if((m_PlayerNum == 1))
	{
		m_PlayerName[Index].SetNameWithColor(UserInfo[Index].m_name, NCT_Normal, TA_Center, Blue);
	}
	else
	{
		m_PlayerName[Index].SetNameWithColor(UserInfo[Index].m_name, NCT_Normal, TA_Center, Red);
	}
	if((UserInfo[Index].m_MaxCP > 0))
	{
		m_BarCP[Index].SetPoint(INT64(UserInfo[Index].m_CurCP), INT64(UserInfo[Index].m_MaxCP));
	}
	else
	{
		m_BarCP[Index].SetPoint(INT64(0), INT64(0));
	}
	if((UserInfo[Index].m_MaxHP > 0))
	{
		m_BarHP[Index].SetPoint(INT64(UserInfo[Index].m_CurHP), INT64(UserInfo[Index].m_MaxHP));
	}
	else
	{
		m_BarHP[Index].SetPoint(INT64(0), INT64(0));
	}
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		default:
			return;
	}
}

function SetExpandMode(bool bExpand)
{
	local Rect rectWnd, rectBuffWnd;
	local int nWndWidth, nWndHeight;

	Me.GetWindowSize(nWndWidth, nWndHeight);
	if(bExpand)
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((m_Windowname $ ".SysMsgWnd"));
		Me.SetWindowSize(nWndWidth, 124);
	}
	else
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".SysMsgWnd"));
		Me.SetWindowSize(nWndWidth, 44);
	}
	rectWnd = Class'NWindow.UIAPI_WINDOW'.static.GetRect(m_Windowname);
	rectBuffWnd = Class'NWindow.UIAPI_WINDOW'.static.GetRect(m_BuffWindowName);
	if(!bExpand)
	{
		if((((rectWnd.nY + 46) == rectBuffWnd.nY) || ((rectWnd.nY + 47) == rectBuffWnd.nY)))
		{
			Class'NWindow.UIAPI_WINDOW'.static.MoveEx(m_BuffWindowName, 0, 80);
		}
	}
	else if((((rectWnd.nY + 126) == rectBuffWnd.nY) || ((rectWnd.nY + 127) == rectBuffWnd.nY)))
	{
		Class'NWindow.UIAPI_WINDOW'.static.MoveEx(m_BuffWindowName, 0, -80);
	}
	return;
}

function Resize(int Count)
{
	local Rect entireRect, statusWndRect, msgWndRect;

	entireRect = Me.GetRect();
	statusWndRect = m_StatusWnd[0].GetRect();
	msgWndRect = m_MsgWnd[0].GetRect();
	Me.SetWindowSize(entireRect.nWidth, (((statusWndRect.nHeight + msgWndRect.nHeight) - 8) * Count));
	Me.SetResizeFrameSize(10, (((statusWndRect.nHeight + msgWndRect.nHeight) - 8) * Count));
	if((m_TotalCount == 2))
	{
		m_StatusWnd[0].ShowWindow();
		m_StatusWnd[1].HideWindow();
		m_StatusWnd[2].HideWindow();
		m_MsgWnd[0].ShowWindow();
		m_MsgWnd[1].HideWindow();
		m_MsgWnd[2].HideWindow();
	}
	else if((m_TotalCount == 6))
	{
		m_StatusWnd[0].ShowWindow();
		m_StatusWnd[1].ShowWindow();
		m_StatusWnd[2].ShowWindow();
		m_MsgWnd[0].ShowWindow();
		m_MsgWnd[1].ShowWindow();
		m_MsgWnd[2].ShowWindow();
	}
	return;
}
