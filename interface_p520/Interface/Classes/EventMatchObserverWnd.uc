class EventMatchObserverWnd extends UICommonAPI;

const TIMERID_Show = 1;
const TIMERID_Msg = 2;

enum EMessageMode
{
	MESSAGEMODE_Normal,             // 0
	MESSAGEMODE_LeftRight,          // 1
	MESSAGEMODE_Off                 // 2
};

struct SkillMsgInfo
{
	var int AttackerTeamID;
	var int AttackerUserID;
	var string AttackerName;
	var int DefenderTeamID;
	var int DefenderUserID;
	var string DefenderName;
	var string SkillName;
};

var int m_Score1;
var int m_Score2;
var string m_TeamName1;
var string m_TeamName2;
var int m_SelectedUserID[2];
var bool m_ClassOrName;
var WindowHandle m_hTopWnd;
var WindowHandle m_hPlayerWnd[2];
var BarHandle m_hPlayerCPBar[2];
var BarHandle m_hPlayerHPBar[2];
var BarHandle m_hPlayerMPBar[2];
var TextureHandle m_hplayerback1_[2];
var TextureHandle m_hplayerback2_[2];
var TextureHandle m_hplayerback3_[2];
var TextBoxHandle m_hPlayerLvClassTextBox[2];
var TextBoxHandle m_hPlayerNameTextBox[2];
var WindowHandle m_hPlayerBuffCoverWnd[2];
var StatusIconHandle m_hPlayerBuffWnd[2];
var WindowHandle m_hParty1Wnd;
var WindowHandle m_hParty1MemberWnd[9];
var TextBoxHandle m_hParty1MemberNameTextBox[9];
var TextBoxHandle m_hParty1MemberClassTextBox[9];
var BarHandle m_hParty1MemberHPBar[9];
var BarHandle m_hParty1MemberCPBar[9];
var BarHandle m_hParty1MemberMPBar[9];
var WindowHandle m_hParty1MemberSelectedTex[9];
var TextureHandle m_hParty1NumberTex[9];
var TextureHandle m_hparty1back1_[9];
var TextureHandle m_hparty1back2_[9];
var TextureHandle m_hparty1back3_[9];
var WindowHandle m_hParty2Wnd;
var WindowHandle m_hParty2MemberWnd[9];
var TextBoxHandle m_hParty2MemberNameTextBox[9];
var TextBoxHandle m_hParty2MemberClassTextBox[9];
var BarHandle m_hParty2MemberHPBar[9];
var BarHandle m_hParty2MemberCPBar[9];
var BarHandle m_hParty2MemberMPBar[9];
var WindowHandle m_hParty2MemberSelectedTex[9];
var TextureHandle m_hParty2NumberTex[9];
var TextureHandle m_hparty2back1_[9];
var TextureHandle m_hparty2back2_[9];
var TextureHandle m_hparty2back3_[9];
var TextBoxHandle m_hTeamName1TextBox;
var TextBoxHandle m_hTeamName2TextBox;
var TextureHandle m_hScore1Tex;
var TextureHandle m_hScore2Tex;
var WindowHandle m_hMsgLeftWnd[6];
var TextBoxHandle m_hMsgLeftAttackerTextBox[6];
var TextBoxHandle m_hMsgLeftDefenderTextBox[6];
var TextBoxHandle m_hMsgLeftSkillTextBox[6];
var WindowHandle m_hMsgRightWnd[6];
var TextBoxHandle m_hMsgRightAttackerTextBox[6];
var TextBoxHandle m_hMsgRightDefenderTextBox[6];
var TextBoxHandle m_hMsgRightSkillTextBox[6];
var WindowHandle m_hMsgWnd;
var string m_Windowname;
var WindowHandle m_hObserverEndWnd;
var int m_Party1UserIDList[9];
var int m_Party2UserIDList[9];
var int m_MsgStartIndex;
var int m_Team1MsgStartIndex;
var int m_Team2MsgStartIndex;
var SkillMsgInfo m_MsgList[6];
var SkillMsgInfo m_Team1MsgList[6];
var SkillMsgInfo m_Team2MsgList[6];
var EMessageMode m_MsgMode;
var int m_MatchID;

function OnRegisterEvent()
{
	RegisterEvent(2220);
	RegisterEvent(2240);
	RegisterEvent(2230);
	RegisterEvent(2250);
	RegisterEvent(2260);
	RegisterEvent(290);
	RegisterEvent(90);
	return;
}

function OnLoad()
{
	InitHandleCOD();
	m_MatchID = 0;
	return;
}

function InitHandleCOD()
{
	local int i;

	m_hTopWnd = GetWindowHandle("TopWnd");
	m_hTeamName1TextBox = GetTextBoxHandle("TopWnd.TeamName1");
	m_hTeamName2TextBox = GetTextBoxHandle("TopWnd.TeamName2");
	m_hScore1Tex = GetTextureHandle("TopWnd.Score1Tex");
	m_hScore2Tex = GetTextureHandle("TopWnd.Score2Tex");
	i = 0;
	while((i < 2))
	{
		m_hPlayerWnd[i] = GetWindowHandle((("Player" $ string((i + 1))) $ "Wnd"));
		m_hPlayerCPBar[i] = GetBarHandle((("Player" $ string((i + 1))) $ "Wnd.CPBar"));
		m_hPlayerHPBar[i] = GetBarHandle((("Player" $ string((i + 1))) $ "Wnd.HPBar"));
		m_hPlayerMPBar[i] = GetBarHandle((("Player" $ string((i + 1))) $ "Wnd.MPBar"));
		m_hPlayerLvClassTextBox[i] = GetTextBoxHandle((("Player" $ string((i + 1))) $ "Wnd.LvClassTextBox"));
		m_hPlayerNameTextBox[i] = GetTextBoxHandle((("Player" $ string((i + 1))) $ "Wnd.NameTextBox"));
		m_hPlayerBuffCoverWnd[i] = GetWindowHandle((("Player" $ string((i + 1))) $ "BuffWnd"));
		m_hPlayerBuffWnd[i] = GetStatusIconHandle((("Player" $ string((i + 1))) $ "BuffWnd.StatusIconCtrl"));
		m_hplayerback1_[i] = GetTextureHandle((("Player" $ string((i + 1))) $ "Wnd.BackTex1"));
		m_hplayerback2_[i] = GetTextureHandle((("Player" $ string((i + 1))) $ "Wnd.BackTex2"));
		m_hplayerback3_[i] = GetTextureHandle((("Player" $ string((i + 1))) $ "Wnd.BackTex3"));
		++i;
	}
	m_hParty1Wnd = GetWindowHandle("Party1Wnd");
	i = 0;
	while((i < 9))
	{
		m_hParty1MemberWnd[i] = GetWindowHandle((("Party1Wnd.PartyMember" $ string((i + 1))) $ "Wnd"));
		m_hParty1MemberNameTextBox[i] = GetTextBoxHandle((("Party1Wnd.PartyMember" $ string((i + 1))) $ "Wnd.Name"));
		m_hParty1MemberClassTextBox[i] = GetTextBoxHandle((("Party1Wnd.PartyMember" $ string((i + 1))) $ "Wnd.Class"));
		m_hParty1MemberHPBar[i] = GetBarHandle((("Party1Wnd.PartyMember" $ string((i + 1))) $ "Wnd.HPBar"));
		m_hParty1MemberCPBar[i] = GetBarHandle((("Party1Wnd.PartyMember" $ string((i + 1))) $ "Wnd.CPBar"));
		m_hParty1MemberMPBar[i] = GetBarHandle((("Party1Wnd.PartyMember" $ string((i + 1))) $ "Wnd.MPBar"));
		m_hParty1MemberSelectedTex[i] = GetWindowHandle((("Party1Wnd.PartyMember" $ string((i + 1))) $ "Wnd.SelectedTex"));
		m_hParty1NumberTex[i] = GetTextureHandle((("Party1Wnd.PartyMember" $ string((i + 1))) $ "Wnd.NumberTex"));
		m_hparty1back1_[i] = GetTextureHandle((("Party1Wnd.PartyMember" $ string((i + 1))) $ "Wnd.BackTex1"));
		m_hparty1back2_[i] = GetTextureHandle((("Party1Wnd.PartyMember" $ string((i + 1))) $ "Wnd.BackTex2"));
		m_hparty1back3_[i] = GetTextureHandle((("Party1Wnd.PartyMember" $ string((i + 1))) $ "Wnd.BackTex3"));
		++i;
	}
	m_hParty2Wnd = GetWindowHandle("Party2Wnd");
	i = 0;
	while((i < 9))
	{
		m_hParty2MemberWnd[i] = GetWindowHandle((("Party2Wnd.PartyMember" $ string((i + 1))) $ "Wnd2"));
		m_hParty2MemberNameTextBox[i] = GetTextBoxHandle((("Party2Wnd.PartyMember" $ string((i + 1))) $ "Wnd2.Name"));
		m_hParty2MemberClassTextBox[i] = GetTextBoxHandle((("Party2Wnd.PartyMember" $ string((i + 1))) $ "Wnd2.Class"));
		m_hParty2MemberHPBar[i] = GetBarHandle((("Party2Wnd.PartyMember" $ string((i + 1))) $ "Wnd2.HPBar"));
		m_hParty2MemberCPBar[i] = GetBarHandle((("Party2Wnd.PartyMember" $ string((i + 1))) $ "Wnd2.CPBar"));
		m_hParty2MemberMPBar[i] = GetBarHandle((("Party2Wnd.PartyMember" $ string((i + 1))) $ "Wnd2.MPBar"));
		m_hParty2MemberSelectedTex[i] = GetWindowHandle((("Party2Wnd.PartyMember" $ string((i + 1))) $ "Wnd2.SelectedTex"));
		m_hParty2NumberTex[i] = GetTextureHandle((("Party2Wnd.PartyMember" $ string((i + 1))) $ "Wnd2.NumberTex"));
		m_hparty2back1_[i] = GetTextureHandle((("Party2Wnd.PartyMember" $ string((i + 1))) $ "Wnd2.BackTex1"));
		m_hparty2back2_[i] = GetTextureHandle((("Party2Wnd.PartyMember" $ string((i + 1))) $ "Wnd2.BackTex2"));
		m_hparty2back3_[i] = GetTextureHandle((("Party2Wnd.PartyMember" $ string((i + 1))) $ "Wnd2.BackTex3"));
		++i;
	}
	i = 0;
	while((i < 6))
	{
		m_hMsgLeftWnd[i] = GetWindowHandle(("MsgWnd.MsgLeft.Msg" $ string((i + 1))));
		m_hMsgRightWnd[i] = GetWindowHandle((("MsgWnd.MsgRight.Msg" $ string((i + 1))) $ "R"));
		m_hMsgLeftAttackerTextBox[i] = GetTextBoxHandle(((("MsgWnd.MsgLeft.Msg" $ string((i + 1))) $ ".Attacker") $ string((i + 1))));
		m_hMsgLeftDefenderTextBox[i] = GetTextBoxHandle(((("MsgWnd.MsgLeft.Msg" $ string((i + 1))) $ ".Defender") $ string((i + 1))));
		m_hMsgLeftSkillTextBox[i] = GetTextBoxHandle(((("MsgWnd.MsgLeft.Msg" $ string((i + 1))) $ ".Skill") $ string((i + 1))));
		m_hMsgRightAttackerTextBox[i] = GetTextBoxHandle(((("MsgWnd.MsgRight.Msg" $ string((i + 1))) $ "R.AttackerR") $ string((i + 1))));
		m_hMsgRightDefenderTextBox[i] = GetTextBoxHandle(((("MsgWnd.MsgRight.Msg" $ string((i + 1))) $ "R.DefenderR") $ string((i + 1))));
		m_hMsgRightSkillTextBox[i] = GetTextBoxHandle(((("MsgWnd.MsgRight.Msg" $ string((i + 1))) $ "R.SkillR") $ string((i + 1))));
		++i;
	}
	m_hMsgWnd = GetWindowHandle((m_Windowname $ ".MsgWnd"));
	m_hObserverEndWnd = GetWindowHandle((m_Windowname $ ".UserObserverEndWnd"));
	return;
}

function OnEnterState(name a_CurrentStateName)
{
	UpdateScore();
	UpdateTeamName();
	UpdateTeamInfo(0);
	UpdateTeamInfo(1);
	ClearMsg();
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 2220:
			HandleStartEventMatchObserver(a_Param);
			break;
		case 2240:
			UpdateScore();
			break;
		case 2230:
			UpdateTeamName();
			break;
		case 2250:
			HandleEventMatchUpdateTeamInfo(a_Param);
			break;
		case 2260:
			HandleEventMatchUpdateUserInfo(a_Param);
			break;
		case 290:
			HandleReceiveMagicSkillUse(a_Param);
			break;
		case 90:
			HandleShortcutCommand(a_Param);
			break;
		default:
			break;
	}
	return;
}

function OnTimer(int a_TimerID)
{
	local int i;

	switch(a_TimerID)
	{
		case 1:
			m_hOwnerWnd.KillTimer(1);
			m_hTopWnd.HideWindow();
			break;
		case 2:
			i = 0;
			while((i < 6))
			{
				if((m_hMsgLeftWnd[i].IsShowWindow() && (0 != m_hMsgLeftWnd[i].GetAlpha())))
				{
					m_hMsgLeftWnd[i].SetAlpha(255);
					m_hMsgLeftWnd[i].SetAlpha(0, 2.0000000);
					break;
				}
				if((m_hMsgRightWnd[i].IsShowWindow() && (0 != m_hMsgRightWnd[i].GetAlpha())))
				{
					m_hMsgRightWnd[i].SetAlpha(255);
					m_hMsgRightWnd[i].SetAlpha(0, 2.0000000);
					break;
				}
				++i;
			}
			break;
		default:
			break;
	}
	return;
}

function OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	local int i;

	i = 0;
	while((i < 9))
	{
		if(a_WindowHandle.IsChildOf(m_hParty1MemberWnd[i]))
		{
			SetSelectedUser(0, i);
			return;
		}
		++i;
	}
	i = 0;
	while((i < 9))
	{
		if(a_WindowHandle.IsChildOf(m_hParty2MemberWnd[i]))
		{
			SetSelectedUser(1, i);
			return;
		}
		++i;
	}
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnStop":
			Class'NWindow.EventMatchAPI'.static.RequestEventMatchObserverEnd(m_MatchID);
			break;
		default:
			break;
	}
	return;
}

function HandleStartEventMatchObserver(string a_Param)
{
	local int builder, MatchID;

	ParseInt(a_Param, "Builder", builder);
	if((builder == 2))
	{
		m_hMsgWnd.HideWindow();
		m_hObserverEndWnd.ShowWindow();
		ParseInt(a_Param, "MatchID", MatchID);
		m_MatchID = MatchID;
	}
	else
	{
		m_hObserverEndWnd.HideWindow();
		m_hMsgWnd.ShowWindow();
	}
	return;
}

function HandleEventMatchUpdateTeamInfo(string a_Param)
{
	local int TeamID;

	if(ParseInt(a_Param, "TeamID", TeamID))
	{
		UpdateTeamInfo(TeamID);
	}
	return;
}

function HandleEventMatchUpdateUserInfo(string a_Param)
{
	local int UserID, TeamID;

	ParseInt(a_Param, "UserID", UserID);
	ParseInt(a_Param, "TeamID", TeamID);
	UpdateUserInfo(TeamID, UserID);
	return;
}

function HandleReceiveMagicSkillUse(string a_Param)
{
	local int attackerId, defenderId, SkillID;
	local UserInfo AttackerInfo, DefenderInfo;
	local SkillInfo UsedSkillInfo;
	local int AttackerTeamID, AttackerUserID, DefenderTeamID, DefenderUserID;

	if(!IsShowWindow("EventMatchObserverWnd"))
	{
		return;
	}
	if(!ParseInt(a_Param, "AttackerID", attackerId))
	{
		return;
	}
	if(!ParseInt(a_Param, "DefenderID", defenderId))
	{
		return;
	}
	if(!ParseInt(a_Param, "SkillID", SkillID))
	{
		return;
	}
	if(!GetTeamUserID(attackerId, AttackerTeamID, AttackerUserID))
	{
		return;
	}
	if(!GetTeamUserID(defenderId, DefenderTeamID, DefenderUserID))
	{
		return;
	}
	if(!GetUserInfo(attackerId, AttackerInfo))
	{
		return;
	}
	if(!GetUserInfo(defenderId, DefenderInfo))
	{
		return;
	}
	if(!GetSkillInfo(SkillID, 1, 0, UsedSkillInfo))
	{
		return;
	}
	AddSkillMsg(AttackerTeamID, AttackerUserID, AttackerInfo.Name, DefenderTeamID, DefenderUserID, DefenderInfo.Name, UsedSkillInfo.SkillName);
	return;
}

function HandleShortcutCommand(string a_Param)
{
	local string Command;
	local bool Draggable;

	if(ParseString(a_Param, "Command", Command))
	{
		switch(Command)
		{
			case "EventMatchShowPartyWindow":
				if(m_hParty1Wnd.IsShowWindow())
				{
					m_hParty1Wnd.HideWindow();
					m_hParty2Wnd.HideWindow();
				}
				else
				{
					m_hParty1Wnd.ShowWindow();
					m_hParty2Wnd.ShowWindow();
					UpdateTeamInfo(0);
					UpdateTeamInfo(1);
				}
				break;
			case "EventMatchLockPosition":
				Draggable = m_hPlayerWnd[0].IsDraggable();
				m_hPlayerWnd[0].SetDraggable(!Draggable);
				m_hPlayerWnd[1].SetDraggable(!Draggable);
				m_hPlayerBuffCoverWnd[0].SetDraggable(!Draggable);
				m_hPlayerBuffCoverWnd[1].SetDraggable(!Draggable);
				m_hParty1Wnd.SetDraggable(!Draggable);
				m_hParty2Wnd.SetDraggable(!Draggable);
				break;
			case "EventMatchInitPosition":
				m_hPlayerWnd[0].SetAnchor("", "TopLeft", "TopLeft", 0, 98);
				m_hPlayerWnd[0].ClearAnchor();
				m_hPlayerWnd[1].SetAnchor("", "TopRight", "TopRight", 0, 98);
				m_hPlayerWnd[1].ClearAnchor();
				m_hPlayerBuffCoverWnd[0].SetAnchor("Player1Wnd", "BottomLeft", "TopLeft", 0, 0);
				m_hPlayerBuffCoverWnd[0].ClearAnchor();
				m_hPlayerBuffCoverWnd[1].SetAnchor("Player2Wnd", "BottomLeft", "TopLeft", 0, 0);
				m_hPlayerBuffCoverWnd[1].ClearAnchor();
				m_hParty1Wnd.SetAnchor("", "TopLeft", "TopLeft", 0, 340);
				m_hParty1Wnd.ClearAnchor();
				m_hParty2Wnd.SetAnchor("", "TopRight", "TopRight", 0, 340);
				m_hParty2Wnd.ClearAnchor();
				break;
			case "EventMatchToggleShowClassOrName":
				m_ClassOrName = !m_ClassOrName;
				RefreshClassOrName();
				break;
			case "EventMatchSwitchMessageMode":
				switch(m_MsgMode)
				{
					case MESSAGEMODE_Normal:
						m_MsgMode = MESSAGEMODE_LeftRight;
						break;
					case MESSAGEMODE_LeftRight:
						m_MsgMode = MESSAGEMODE_Off;
						break;
					case MESSAGEMODE_Off:
						m_MsgMode = MESSAGEMODE_Normal;
						break;
					default:
						m_MsgMode = MESSAGEMODE_Normal;
						break;
				}
				UpdateSkillMsg();
				break;
			default:
				break;
		}
	}
	return;
}

function RefreshClassOrName()
{
	local int i;

	if(m_ClassOrName)
	{
		i = 0;
		while((i < 9))
		{
			m_hParty1MemberNameTextBox[i].HideWindow();
			m_hParty2MemberNameTextBox[i].HideWindow();
			m_hParty1MemberClassTextBox[i].ShowWindow();
			m_hParty2MemberClassTextBox[i].ShowWindow();
			++i;
		}
	}
	else
	{
		i = 0;
		while((i < 9))
		{
			m_hParty1MemberNameTextBox[i].ShowWindow();
			m_hParty2MemberNameTextBox[i].ShowWindow();
			m_hParty1MemberClassTextBox[i].HideWindow();
			m_hParty2MemberClassTextBox[i].HideWindow();
			++i;
		}
	}
	return;
}

function UpdateTeamName()
{
	m_TeamName1 = Class'NWindow.EventMatchAPI'.static.GetTeamName(0);
	m_TeamName2 = Class'NWindow.EventMatchAPI'.static.GetTeamName(1);
	m_hTeamName1TextBox.SetText(m_TeamName1);
	m_hTeamName2TextBox.SetText(m_TeamName2);
	return;
}

function UpdateTeamInfo(int a_TeamID)
{
	local int i, PartyMemberCount;

	if(((0 != a_TeamID) && (1 != a_TeamID)))
	{
		return;
	}
	PartyMemberCount = Class'NWindow.EventMatchAPI'.static.GetPartyMemberCount(a_TeamID);
	switch(a_TeamID)
	{
		case 0:
			m_hParty1Wnd.SetWindowSize(280, (70 * PartyMemberCount));
			i = 0;
			while((i < 9))
			{
				if((i < PartyMemberCount))
				{
					m_hParty1MemberWnd[i].ShowWindow();
					UpdateUserInfo(0, i);
					++i;
					continue;
				}
				m_hParty1MemberWnd[i].HideWindow();
				m_Party1UserIDList[i] = 0;
				++i;
			}
			break;
		case 1:
			m_hParty2Wnd.SetWindowSize(280, (70 * PartyMemberCount));
			i = 0;
			while((i < 9))
			{
				if((i < PartyMemberCount))
				{
					m_hParty2MemberWnd[i].ShowWindow();
					UpdateUserInfo(1, i);
					++i;
					continue;
				}
				m_hParty2MemberWnd[i].HideWindow();
				m_Party2UserIDList[i] = 0;
				++i;
			}
			break;
		default:
			break;
	}
	SetSelectedUser(a_TeamID, -1);
	RefreshClassOrName();
	return;
}

function UpdateScore()
{
	m_Score1 = Class'NWindow.EventMatchAPI'.static.GetScore(0);
	m_Score2 = Class'NWindow.EventMatchAPI'.static.GetScore(1);
	m_hScore1Tex.SetTexture(("L2UI_CH3.BroadcastObs.br_score" $ string(m_Score1)));
	m_hScore2Tex.SetTexture(("L2UI_CH3.BroadcastObs.br_score" $ string(m_Score2)));
	m_hTopWnd.ShowWindow();
	m_hOwnerWnd.SetTimer(1, 7000);
	return;
}

function UpdateUserInfo(int a_TeamID, int a_UserID)
{
	local int i, CurRow;
	local EventMatchUserData UserData;
	local StatusIconInfo Info;
	local SkillInfo TheSkillInfo;
	local int Width, Height, buffLengthMax;

	if(Class'NWindow.EventMatchAPI'.static.GetUserData(a_TeamID, a_UserID, UserData))
	{
		switch(a_TeamID)
		{
			case 0:
				if((UserData.HPNow == 0))
				{
					m_Party1UserIDList[a_UserID] = UserData.UserID;
					m_hParty1MemberNameTextBox[a_UserID].SetText(UserData.UserName);
					m_hParty1MemberClassTextBox[a_UserID].SetText(GetClassType(UserData.UserClass));
					m_hParty1MemberHPBar[a_UserID].SetValue(UserData.HPMax, UserData.HPNow);
					m_hParty1MemberCPBar[a_UserID].SetValue(UserData.CPMax, UserData.CPNow);
					m_hParty1MemberMPBar[a_UserID].SetValue(UserData.MPMax, UserData.MPNow);
					m_hParty1NumberTex[a_UserID].SetTexture("L2UI_CH3.BroadcastObs.br_party_x");
					m_hparty1back1_[a_UserID].SetTexture("L2UI_CH3.BroadcastObs.br_dead2_back1");
					m_hparty1back2_[a_UserID].SetTexture("L2UI_CH3.BroadcastObs.br_dead2_back2");
					m_hparty1back3_[a_UserID].SetTexture("L2UI_CH3.BroadcastObs.br_dead2_back3");
				}
				else
				{
					m_Party1UserIDList[a_UserID] = UserData.UserID;
					m_hParty1MemberNameTextBox[a_UserID].SetText(UserData.UserName);
					m_hParty1MemberClassTextBox[a_UserID].SetText(GetClassType(UserData.UserClass));
					m_hParty1MemberHPBar[a_UserID].SetValue(UserData.HPMax, UserData.HPNow);
					m_hParty1MemberCPBar[a_UserID].SetValue(UserData.CPMax, UserData.CPNow);
					m_hParty1MemberMPBar[a_UserID].SetValue(UserData.MPMax, UserData.MPNow);
					m_hParty1NumberTex[a_UserID].SetTexture(("L2UI_CH3.BroadcastObs.br_party2_" $ string((a_UserID + 1))));
					m_hparty1back1_[a_UserID].SetTexture("L2UI_CH3.BroadcastObs.br_party2_back1");
					m_hparty1back2_[a_UserID].SetTexture("L2UI_CH3.BroadcastObs.br_party2_back2");
					m_hparty1back3_[a_UserID].SetTexture("L2UI_CH3.BroadcastObs.br_party2_back3");
				}
				break;
			case 1:
				if((UserData.HPNow == 0))
				{
					m_hParty2MemberHPBar[a_UserID].SetValue(UserData.HPMax, UserData.HPNow);
					m_hParty2MemberCPBar[a_UserID].SetValue(UserData.CPMax, UserData.CPNow);
					m_hParty2MemberMPBar[a_UserID].SetValue(UserData.MPMax, UserData.MPNow);
					m_hParty2NumberTex[a_UserID].SetTexture("L2UI_CH3.BroadcastObs.br_party_x");
					m_hparty2back1_[a_UserID].SetTexture("L2UI_CH3.BroadcastObs.br_dead2_back1");
					m_hparty2back2_[a_UserID].SetTexture("L2UI_CH3.BroadcastObs.br_dead2_back2");
					m_hparty2back3_[a_UserID].SetTexture("L2UI_CH3.BroadcastObs.br_dead2_back3");
				}
				else
				{
					m_Party2UserIDList[a_UserID] = UserData.UserID;
					m_hParty2MemberNameTextBox[a_UserID].SetText(UserData.UserName);
					m_hParty2MemberClassTextBox[a_UserID].SetText(GetClassType(UserData.UserClass));
					m_hParty2MemberHPBar[a_UserID].SetValue(UserData.HPMax, UserData.HPNow);
					m_hParty2MemberCPBar[a_UserID].SetValue(UserData.CPMax, UserData.CPNow);
					m_hParty2MemberMPBar[a_UserID].SetValue(UserData.MPMax, UserData.MPNow);
					m_hParty2NumberTex[a_UserID].SetTexture(("L2UI_CH3.BroadcastObs.br_party1_" $ string((a_UserID + 1))));
					m_hparty2back1_[a_UserID].SetTexture("L2UI_CH3.BroadcastObs.br_party2_back1");
					m_hparty2back2_[a_UserID].SetTexture("L2UI_CH3.BroadcastObs.br_party2_back2");
					m_hparty2back3_[a_UserID].SetTexture("L2UI_CH3.BroadcastObs.br_party2_back3");
				}
				break;
			default:
				break;
		}
		if(IsSelectedUser(a_TeamID, a_UserID))
		{
			m_hPlayerNameTextBox[a_TeamID].SetText(UserData.UserName);
			m_hPlayerLvClassTextBox[a_TeamID].SetText(((("Lv" $ string(UserData.UserLv)) $ " ") $ GetClassType(UserData.UserClass)));
			m_hPlayerHPBar[a_TeamID].SetValue(UserData.HPMax, UserData.HPNow);
			m_hPlayerCPBar[a_TeamID].SetValue(UserData.CPMax, UserData.CPNow);
			m_hPlayerMPBar[a_TeamID].SetValue(UserData.MPMax, UserData.MPNow);
			if((UserData.HPNow == 0))
			{
				m_hplayerback1_[a_TeamID].SetTexture("L2UI_CH3.BroadcastObs.br_dead1_back1");
				m_hplayerback2_[a_TeamID].SetTexture("L2UI_CH3.BroadcastObs.br_dead1_back2");
				m_hplayerback3_[a_TeamID].SetTexture("L2UI_CH3.BroadcastObs.br_dead1_back3");
			}
			else
			{
				m_hplayerback1_[a_TeamID].SetTexture("L2UI_CH3.BroadcastObs.br_party1_back1");
				m_hplayerback2_[a_TeamID].SetTexture("L2UI_CH3.BroadcastObs.br_party1_back2");
				m_hplayerback3_[a_TeamID].SetTexture("L2UI_CH3.BroadcastObs.br_party1_back3");
			}
			m_hPlayerBuffWnd[a_TeamID].Clear();
			CurRow = -1;
			buffLengthMax = UserData.BuffIDList.Length;
			if((buffLengthMax > 24))
			{
				buffLengthMax = 24;
			}
			i = 0;
			while((i < buffLengthMax))
			{
				if((0.0000000 == (float(i) % 12.0000000)))
				{
					CurRow++;
					m_hPlayerBuffWnd[a_TeamID].AddRow();
				}
				if(GetSkillInfo(UserData.BuffIDList[i], 1, 0, TheSkillInfo))
				{
					Info.Size = 10;
					Info.Id = GetItemID(UserData.BuffIDList[i]);
					Info.Level = 1;
					Info.RemainTime = UserData.BuffRemainList[i];
					Info.IconName = TheSkillInfo.TexName;
					Info.IconPanel = TheSkillInfo.IconPanel;
					Info.Name = TheSkillInfo.SkillName;
					Info.Description = TheSkillInfo.SkillDesc;
					Info.bShow = true;
					Info.Size = 22;
					m_hPlayerBuffWnd[a_TeamID].AddCol(CurRow, Info);
				}
				++i;
			}
			m_hPlayerBuffWnd[a_TeamID].GetWindowSize(Width, Height);
			m_hPlayerBuffCoverWnd[a_TeamID].SetWindowSize(Width, Height);
		}
	}
	return;
}

function SetSelectedUser(int a_TeamID, int a_UserID)
{
	local int i;

	switch(a_TeamID)
	{
		case 0:
			i = 0;
			while((i < 9))
			{
				if((i == a_UserID))
				{
					m_hParty1MemberSelectedTex[i].ShowWindow();
					++i;
					continue;
				}
				m_hParty1MemberSelectedTex[i].HideWindow();
				++i;
			}
			break;
		case 1:
			i = 0;
			while((i < 9))
			{
				if((i == a_UserID))
				{
					m_hParty2MemberSelectedTex[i].ShowWindow();
					++i;
					continue;
				}
				m_hParty2MemberSelectedTex[i].HideWindow();
				++i;
			}
			break;
		default:
			break;
	}
	m_SelectedUserID[a_TeamID] = a_UserID;
	if((-1 == a_UserID))
	{
		m_hPlayerNameTextBox[a_TeamID].SetText("");
		m_hPlayerLvClassTextBox[a_TeamID].SetText("");
		m_hPlayerHPBar[a_TeamID].SetValue(0, 0);
		m_hPlayerCPBar[a_TeamID].SetValue(0, 0);
		m_hPlayerMPBar[a_TeamID].SetValue(0, 0);
		m_hPlayerBuffCoverWnd[a_TeamID].HideWindow();
	}
	else
	{
		Class'NWindow.EventMatchAPI'.static.SetSelectedUser(a_TeamID, a_UserID);
		m_hPlayerBuffCoverWnd[a_TeamID].ShowWindow();
		UpdateUserInfo(a_TeamID, a_UserID);
	}
	return;
}

function bool IsSelectedUser(int a_TeamID, int a_UserID)
{
	if(((0 != a_TeamID) && (1 != a_TeamID)))
	{
		return false;
	}
	if((m_SelectedUserID[a_TeamID] != a_UserID))
	{
		return false;
	}
	return true;
}

function ClearMsg()
{
	local int i;

	i = 0;
	while((i < 6))
	{
		m_hMsgLeftWnd[i].HideWindow();
		m_hMsgRightWnd[i].HideWindow();
		++i;
	}
	return;
}

function bool GetTeamUserID(int a_UserClassID, out int a_TeamID, out int a_UserID)
{
	local int i;

	if((0 == a_UserClassID))
	{
		return false;
	}
	i = 0;
	while((i < 9))
	{
		if((m_Party1UserIDList[i] == a_UserClassID))
		{
			a_TeamID = 0;
			a_UserID = i;
			return true;
		}
		++i;
	}
	i = 0;
	while((i < 9))
	{
		if((m_Party2UserIDList[i] == a_UserClassID))
		{
			a_TeamID = 1;
			a_UserID = i;
			return true;
		}
		++i;
	}
}

function AddSkillMsg(int a_AttackerTeamID, int a_AttackerUserID, string a_AttackerName, int a_DefenderTeamID, int a_DefenderUserID, string a_DefenderName, string a_SkillName)
{
	m_MsgList[m_MsgStartIndex].AttackerTeamID = a_AttackerTeamID;
	m_MsgList[m_MsgStartIndex].AttackerUserID = a_AttackerUserID;
	m_MsgList[m_MsgStartIndex].AttackerName = a_AttackerName;
	m_MsgList[m_MsgStartIndex].DefenderTeamID = a_DefenderTeamID;
	m_MsgList[m_MsgStartIndex].DefenderUserID = a_DefenderUserID;
	m_MsgList[m_MsgStartIndex].DefenderName = a_DefenderName;
	m_MsgList[m_MsgStartIndex].SkillName = a_SkillName;
	m_MsgStartIndex = int((float((m_MsgStartIndex + 1)) % 6.0000000));
	if((0 == a_AttackerTeamID))
	{
		m_Team1MsgList[m_Team1MsgStartIndex].AttackerTeamID = a_AttackerTeamID;
		m_Team1MsgList[m_Team1MsgStartIndex].AttackerUserID = a_AttackerUserID;
		m_Team1MsgList[m_Team1MsgStartIndex].AttackerName = a_AttackerName;
		m_Team1MsgList[m_Team1MsgStartIndex].DefenderTeamID = a_DefenderTeamID;
		m_Team1MsgList[m_Team1MsgStartIndex].DefenderUserID = a_DefenderUserID;
		m_Team1MsgList[m_Team1MsgStartIndex].DefenderName = a_DefenderName;
		m_Team1MsgList[m_Team1MsgStartIndex].SkillName = a_SkillName;
		m_Team1MsgStartIndex = int((float((m_Team1MsgStartIndex + 1)) % 6.0000000));
	}
	else
	{
		m_Team2MsgList[m_Team2MsgStartIndex].AttackerTeamID = a_AttackerTeamID;
		m_Team2MsgList[m_Team2MsgStartIndex].AttackerUserID = a_AttackerUserID;
		m_Team2MsgList[m_Team2MsgStartIndex].AttackerName = a_AttackerName;
		m_Team2MsgList[m_Team2MsgStartIndex].DefenderTeamID = a_DefenderTeamID;
		m_Team2MsgList[m_Team2MsgStartIndex].DefenderUserID = a_DefenderUserID;
		m_Team2MsgList[m_Team2MsgStartIndex].DefenderName = a_DefenderName;
		m_Team2MsgList[m_Team2MsgStartIndex].SkillName = a_SkillName;
		m_Team2MsgStartIndex = int((float((m_Team2MsgStartIndex + 1)) % 6.0000000));
	}
	UpdateSkillMsg();
	return;
}

function UpdateSkillMsg()
{
	local int i, SkillMsgIndex;
	local Color Team1Color, Team2Color;

	Team1Color.R = 220;
	Team1Color.G = 220;
	Team1Color.B = 220;
	Team2Color.R = 255;
	Team2Color.G = 55;
	Team2Color.B = 55;
	switch(m_MsgMode)
	{
		case MESSAGEMODE_Normal:
			i = 0;
			while((i < 6))
			{
				m_hMsgRightWnd[i].HideWindow();
				++i;
			}
			i = 0;
			while((i < 6))
			{
				SkillMsgIndex = int((float((m_MsgStartIndex + i)) % 6.0000000));
				if((m_MsgList[SkillMsgIndex].AttackerName == ""))
				{
					m_hMsgLeftWnd[i].HideWindow();
					++i;
					continue;
				}
				m_hMsgLeftAttackerTextBox[i].SetText((string((m_MsgList[SkillMsgIndex].AttackerUserID + 1)) $ m_MsgList[SkillMsgIndex].AttackerName));
				m_hMsgLeftDefenderTextBox[i].SetText((string((m_MsgList[SkillMsgIndex].DefenderUserID + 1)) $ m_MsgList[SkillMsgIndex].DefenderName));
				m_hMsgLeftSkillTextBox[i].SetText(m_MsgList[SkillMsgIndex].SkillName);
				if((0 == m_MsgList[SkillMsgIndex].AttackerTeamID))
				{
					m_hMsgLeftAttackerTextBox[i].SetTextColor(Team1Color);
				}
				else
				{
					m_hMsgLeftAttackerTextBox[i].SetTextColor(Team2Color);
				}
				if((0 == m_MsgList[SkillMsgIndex].DefenderTeamID))
				{
					m_hMsgLeftDefenderTextBox[i].SetTextColor(Team1Color);
				}
				else
				{
					m_hMsgLeftDefenderTextBox[i].SetTextColor(Team2Color);
				}
				m_hMsgLeftWnd[i].ShowWindow();
				m_hMsgLeftWnd[i].SetAlpha(255);
				++i;
			}
			break;
		case MESSAGEMODE_LeftRight:
			i = 0;
			while((i < 6))
			{
				SkillMsgIndex = int((float((m_Team1MsgStartIndex + i)) % 6.0000000));
				if((m_Team1MsgList[SkillMsgIndex].AttackerName == ""))
				{
					m_hMsgLeftWnd[i].HideWindow();
					++i;
					continue;
				}
				m_hMsgLeftAttackerTextBox[i].SetText(string((m_Team1MsgList[SkillMsgIndex].AttackerUserID + 1)));
				m_hMsgLeftDefenderTextBox[i].SetText(string((m_Team1MsgList[SkillMsgIndex].DefenderUserID + 1)));
				m_hMsgLeftSkillTextBox[i].SetText(m_Team1MsgList[SkillMsgIndex].SkillName);
				m_hMsgLeftAttackerTextBox[i].SetTextColor(Team1Color);
				if((0 == m_Team1MsgList[SkillMsgIndex].DefenderTeamID))
				{
					m_hMsgLeftDefenderTextBox[i].SetTextColor(Team1Color);
				}
				else
				{
					m_hMsgLeftDefenderTextBox[i].SetTextColor(Team2Color);
				}
				m_hMsgLeftWnd[i].ShowWindow();
				m_hMsgLeftWnd[i].SetAlpha(255);
				++i;
			}
			i = 0;
			while((i < 6))
			{
				SkillMsgIndex = int((float((m_MsgStartIndex + i)) % 6.0000000));
				if((m_Team2MsgList[SkillMsgIndex].AttackerName == ""))
				{
					m_hMsgRightWnd[i].HideWindow();
					++i;
					continue;
				}
				m_hMsgRightAttackerTextBox[i].SetText(string((m_Team2MsgList[SkillMsgIndex].AttackerUserID + 1)));
				m_hMsgRightDefenderTextBox[i].SetText(string((m_Team2MsgList[SkillMsgIndex].DefenderUserID + 1)));
				m_hMsgRightSkillTextBox[i].SetText(m_Team2MsgList[SkillMsgIndex].SkillName);
				m_hMsgRightAttackerTextBox[i].SetTextColor(Team2Color);
				if((0 == m_Team2MsgList[SkillMsgIndex].DefenderTeamID))
				{
					m_hMsgRightDefenderTextBox[i].SetTextColor(Team1Color);
				}
				else
				{
					m_hMsgRightDefenderTextBox[i].SetTextColor(Team2Color);
				}
				m_hMsgRightWnd[i].ShowWindow();
				m_hMsgRightWnd[i].SetAlpha(255);
				++i;
			}
			break;
		case MESSAGEMODE_Off:
			i = 0;
			while((i < 6))
			{
				m_hMsgLeftWnd[i].HideWindow();
				m_hMsgRightWnd[i].HideWindow();
				++i;
			}
			break;
		default:
			break;
	}
	m_hOwnerWnd.KillTimer(2);
	m_hOwnerWnd.SetTimer(2, 14000);
	return;
}

defaultproperties
{
	m_Windowname="EventMatchObserverWnd"
}
