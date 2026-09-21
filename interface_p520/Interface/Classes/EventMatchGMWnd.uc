class EventMatchGMWnd extends UICommonAPI;

const TIMERID_CountDown = 1;
const BUTTONNAME_FenceUp = 1081;
const BUTTONNAME_FenceDown = 1082;

var HtmlHandle m_hCommandHtml;
var WindowHandle m_hEventMatchGMCommandWnd;
var WindowHandle m_hEventMatchGMFenceWnd;
var ButtonHandle m_hCreateEventMatchButton;
var ButtonHandle m_hSetTeam1LeaderButton;
var ButtonHandle m_hLockTeam1Button;
var ButtonHandle m_hSetTeam2LeaderButton;
var ButtonHandle m_hLockTeam2Button;
var ButtonHandle m_hPauseButton;
var ButtonHandle m_hStartButton;
var ButtonHandle m_hSetScoreButton;
var ButtonHandle m_hSendAnnounceButton;
var ButtonHandle m_hShowCommandWndButton;
var ButtonHandle m_hSendGameEndMsgButton;
var ButtonHandle m_hSetFenceButton;
var ButtonHandle m_hTeam1FirecrackerButton;
var ButtonHandle m_hTeam2FirecrackerButton;
var ButtonHandle Summon2Team;
var ButtonHandle SetAllHeal;
var ButtonHandle DelayReset;
var ButtonHandle Summon1Team;
var EditBoxHandle m_hTeam1NameEditBox;
var EditBoxHandle m_hTeam2NameEditBox;
var EditBoxHandle m_hTeam1LeaderNameEditBox;
var EditBoxHandle m_hTeam2LeaderNameEditBox;
var EditBoxHandle m_hOptionFileEditBox;
var EditBoxHandle m_hCommandFileEditBox;
var EditBoxHandle m_hTeam1ScoreEditBox;
var EditBoxHandle m_hTeam2ScoreEditBox;
var EditBoxHandle m_hAnnounceEditBox;
var TextBoxHandle m_hMatchIDTextBox;
var ListCtrlHandle m_hTeam1ListCtrl;
var ListCtrlHandle m_hTeam2ListCtrl;
var int m_CountDown;
var int m_MatchID;
var bool m_Team1Locked;
var bool m_Team2Locked;
var bool m_Paused;
var string m_Team1Name;
var string m_Team2Name;

function OnRegisterEvent()
{
	RegisterEvent(2180);
	RegisterEvent(2190);
	RegisterEvent(2250);
	RegisterEvent(2210);
	RegisterEvent(2211);
	return;
}

function OnLoad()
{
	GotoState('HidingState');
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	if((1 == 0))
	{
		m_hEventMatchGMCommandWnd = GetHandle("EventMatchGMCommandWnd");
		m_hCommandHtml = HtmlHandle(GetHandle("EventMatchGMCommandWnd.HtmlCtrl"));
		m_hEventMatchGMFenceWnd = GetHandle("EventMatchGMFenceWnd");
		m_hCreateEventMatchButton = ButtonHandle(GetHandle("CreateEventMatchButton"));
		m_hSetTeam1LeaderButton = ButtonHandle(GetHandle("SetTeam1LeaderButton"));
		m_hLockTeam1Button = ButtonHandle(GetHandle("LockTeam1Button"));
		m_hSetTeam2LeaderButton = ButtonHandle(GetHandle("SetTeam2LeaderButton"));
		m_hLockTeam2Button = ButtonHandle(GetHandle("LockTeam2Button"));
		m_hPauseButton = ButtonHandle(GetHandle("PauseButton"));
		m_hStartButton = ButtonHandle(GetHandle("StartButton"));
		Summon2Team = ButtonHandle(GetHandle("Summon2Team"));
		SetAllHeal = ButtonHandle(GetHandle("SetAllHeal"));
		DelayReset = ButtonHandle(GetHandle("DelayReset"));
		Summon1Team = ButtonHandle(GetHandle("Summon1Team"));
		m_hSetScoreButton = ButtonHandle(GetHandle("SetScoreButton"));
		m_hSendAnnounceButton = ButtonHandle(GetHandle("SendAnnounceButton"));
		m_hShowCommandWndButton = ButtonHandle(GetHandle("ShowCommandWndButton"));
		m_hSendGameEndMsgButton = ButtonHandle(GetHandle("SendGameEndMsgButton"));
		m_hSetFenceButton = ButtonHandle(GetHandle("SetFenceButton"));
		m_hTeam1FirecrackerButton = ButtonHandle(GetHandle("Team1FirecrackerButton"));
		m_hTeam2FirecrackerButton = ButtonHandle(GetHandle("Team2FirecrackerButton"));
		m_hTeam1NameEditBox = EditBoxHandle(GetHandle("Team1NameEditBox"));
		m_hTeam2NameEditBox = EditBoxHandle(GetHandle("Team2NameEditBox"));
		m_hTeam1LeaderNameEditBox = EditBoxHandle(GetHandle("Team1LeaderNameEditBox"));
		m_hTeam2LeaderNameEditBox = EditBoxHandle(GetHandle("Team2LeaderNameEditBox"));
		m_hOptionFileEditBox = EditBoxHandle(GetHandle("OptionFileEditBox"));
		m_hCommandFileEditBox = EditBoxHandle(GetHandle("CommandFileEditBox"));
		m_hTeam1ScoreEditBox = EditBoxHandle(GetHandle("Team1ScoreEditBox"));
		m_hTeam2ScoreEditBox = EditBoxHandle(GetHandle("Team2ScoreEditBox"));
		m_hAnnounceEditBox = EditBoxHandle(GetHandle("AnnounceEditBox"));
		m_hMatchIDTextBox = TextBoxHandle(GetHandle("MatchIDTextBox"));
		m_hTeam1ListCtrl = ListCtrlHandle(GetHandle("Team1ListCtrl"));
		m_hTeam2ListCtrl = ListCtrlHandle(GetHandle("Team2ListCtrl"));
	}
	else
	{
		m_hEventMatchGMCommandWnd = GetWindowHandle("EventMatchGMCommandWnd");
		m_hCommandHtml = GetHtmlHandle("EventMatchGMWnd.EventMatchGMCommandWnd.HtmlCtrl");
		m_hEventMatchGMFenceWnd = GetWindowHandle("EventMatchGMFenceWnd");
		m_hCreateEventMatchButton = GetButtonHandle("EventMatchGMWnd.CreateEventMatchButton");
		m_hSetTeam1LeaderButton = GetButtonHandle("EventMatchGMWnd.SetTeam1LeaderButton");
		m_hLockTeam1Button = GetButtonHandle("EventMatchGMWnd.LockTeam1Button");
		m_hSetTeam2LeaderButton = GetButtonHandle("EventMatchGMWnd.SetTeam2LeaderButton");
		m_hLockTeam2Button = GetButtonHandle("EventMatchGMWnd.LockTeam2Button");
		m_hPauseButton = GetButtonHandle("EventMatchGMWnd.PauseButton");
		m_hStartButton = GetButtonHandle("EventMatchGMWnd.StartButton");
		Summon2Team = GetButtonHandle("EventMatchGMWnd.Summon2Team");
		SetAllHeal = GetButtonHandle("EventMatchGMWnd.SetAllHeal");
		DelayReset = GetButtonHandle("EventMatchGMWnd.DelayReset");
		Summon1Team = GetButtonHandle("EventMatchGMWnd.Summon1Team");
		m_hSetScoreButton = GetButtonHandle("EventMatchGMWnd.SetScoreButton");
		m_hSendAnnounceButton = GetButtonHandle("EventMatchGMWnd.SendAnnounceButton");
		m_hShowCommandWndButton = GetButtonHandle("EventMatchGMWnd.ShowCommandWndButton");
		m_hSendGameEndMsgButton = GetButtonHandle("EventMatchGMWnd.SendGameEndMsgButton");
		m_hSetFenceButton = GetButtonHandle("EventMatchGMWnd.SetFenceButton");
		m_hTeam1FirecrackerButton = GetButtonHandle("EventMatchGMWnd.Team1FirecrackerButton");
		m_hTeam2FirecrackerButton = GetButtonHandle("EventMatchGMWnd.Team2FirecrackerButton");
		m_hTeam1NameEditBox = GetEditBoxHandle("EventMatchGMWnd.Team1NameEditBox");
		m_hTeam2NameEditBox = GetEditBoxHandle("EventMatchGMWnd.Team2NameEditBox");
		m_hTeam1LeaderNameEditBox = GetEditBoxHandle("EventMatchGMWnd.Team1LeaderNameEditBox");
		m_hTeam2LeaderNameEditBox = GetEditBoxHandle("EventMatchGMWnd.Team2LeaderNameEditBox");
		m_hOptionFileEditBox = GetEditBoxHandle("EventMatchGMWnd.OptionFileEditBox");
		m_hCommandFileEditBox = GetEditBoxHandle("EventMatchGMWnd.CommandFileEditBox");
		m_hTeam1ScoreEditBox = GetEditBoxHandle("EventMatchGMWnd.Team1ScoreEditBox");
		m_hTeam2ScoreEditBox = GetEditBoxHandle("EventMatchGMWnd.Team2ScoreEditBox");
		m_hAnnounceEditBox = GetEditBoxHandle("EventMatchGMWnd.AnnounceEditBox");
		m_hMatchIDTextBox = GetTextBoxHandle("EventMatchGMWnd.MatchIDTextBox");
		m_hTeam1ListCtrl = GetListCtrlHandle("EventMatchGMWnd.Team1ListCtrl");
		m_hTeam2ListCtrl = GetListCtrlHandle("EventMatchGMWnd.Team2ListCtrl");
	}
	return;
}

function OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	Debug("ClickedButton");
	switch(a_ButtonHandle)
	{
		case m_hCreateEventMatchButton:
			OnClickCreateEventMatchButton();
			break;
		case m_hSetTeam1LeaderButton:
			OnClickSetTeam1LeaderButton();
			break;
		case m_hLockTeam1Button:
			OnClickLockTeam1Button();
			break;
		case m_hSetTeam2LeaderButton:
			OnClickSetTeam2LeaderButton();
			break;
		case m_hLockTeam2Button:
			OnClickLockTeam2Button();
			break;
		case m_hPauseButton:
			OnClickPauseButton();
			break;
		case m_hStartButton:
			OnClickStartButton();
			break;
		case m_hSetScoreButton:
			OnClickSetScoreButton();
			break;
		case m_hSendAnnounceButton:
			OnClickSendAnnounceButton();
			break;
		case m_hShowCommandWndButton:
			OnClickShowCommandWndButton();
			break;
		case m_hSendGameEndMsgButton:
			OnClickSendGameEngMsgButton();
			break;
		case m_hSetFenceButton:
			OnClickSetFenceButton();
			break;
		case m_hTeam1FirecrackerButton:
			OnClickTeam1FirecrackerButton();
			break;
		case m_hTeam2FirecrackerButton:
			OnClickTeam2FirecrackerButton();
			break;
		case Summon2Team:
			OnClickSummon2Team();
			break;
		case SetAllHeal:
			OnClickSetAllHeal();
			break;
		case DelayReset:
			OnClickDelayReset();
			break;
		case Summon1Team:
			OnClickSummon1Team();
			break;
		default:
			break;
	}
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	Debug(("EVID" @ string(a_EventID)));
	switch(a_EventID)
	{
		case 2180:
			HandleShowEventMatchGMWnd();
			break;
		case 2190:
			HandleEventMatchCreated(a_Param);
			break;
		case 2250:
			HandleEventMatchUpdateTeamInfo(a_Param);
			break;
		case 2210:
			HandleEventMatchManage(a_Param);
			break;
		case 2211:
			HandleEventMatchPartyLeader(a_Param);
			break;
		default:
			break;
	}
	return;
}

function OnHide()
{
	GotoState('HidingState');
	return;
}

function OnClickCreateEventMatchButton()
{
	return;
}

function OnClickSetTeam1LeaderButton()
{
	return;
}

function OnClickLockTeam1Button()
{
	return;
}

function OnClickSetTeam2LeaderButton()
{
	return;
}

function OnClickLockTeam2Button()
{
	return;
}

function OnClickPauseButton()
{
	return;
}

function OnClickStartButton()
{
	return;
}

function OnClickSetScoreButton()
{
	return;
}

function OnClickSendAnnounceButton()
{
	return;
}

function OnClickShowCommandWndButton()
{
	local string CommandFileName;
	local int Count;
	local string HtmlString;
	local int i;
	local string CommandString;

	CommandFileName = m_hCommandFileEditBox.GetString();
	if((CommandFileName == ""))
	{
		DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(1415));
		return;
	}
	RefreshINI(CommandFileName);
	if(!GetINIInt("Cmd", "CmdCnt", Count, CommandFileName))
	{
		Count = 0;
	}
	HtmlString = "<html><body>";
	i = 0;
	while((i < Count))
	{
		if(GetINIString("Cmd", ("Cmd" $ string(i)), CommandString, CommandFileName))
		{
			HtmlString = (((((HtmlString $ "<a cmd = \"") $ CommandString) $ "\">") $ CommandString) $ "</a><br1>");
		}
		++i;
	}
	HtmlString = (HtmlString $ "</body></html>");
	m_hEventMatchGMCommandWnd.ShowWindow();
	m_hEventMatchGMCommandWnd.SetFocus();
	m_hCommandHtml.LoadHtmlFromString(HtmlString);
	return;
}

function OnClickSendGameEngMsgButton()
{
	return;
}

function OnClickSetFenceButton()
{
	return;
}

function OnClickTeam1FirecrackerButton()
{
	return;
}

function OnClickTeam2FirecrackerButton()
{
	return;
}

function NotifyFenceInfo(Vector a_Position, int a_XLength, int a_YLength)
{
	return;
}

function HandleShowEventMatchGMWnd()
{
	return;
}

function HandleEventMatchCreated(string a_Param)
{
	return;
}

function HandleEventMatchUpdateTeamInfo(string a_Param)
{
	local int TeamID, i, PartyMemberCount;
	local LVDataRecord Record;
	local EventMatchUserData UserData;
	local ListCtrlHandle hTeamListCtrl;

	if(ParseInt(a_Param, "TeamID", TeamID))
	{
		PartyMemberCount = Class'NWindow.EventMatchAPI'.static.GetPartyMemberCount(TeamID);
		switch(TeamID)
		{
			case 0:
				m_hLockTeam1Button.EnableWindow();
				if((0 != PartyMemberCount))
				{
					m_hLockTeam1Button.SetButtonName(1072);
					m_Team1Locked = true;
				}
				hTeamListCtrl = m_hTeam1ListCtrl;
				break;
			case 1:
				m_hLockTeam2Button.EnableWindow();
				if((0 != PartyMemberCount))
				{
					m_hLockTeam2Button.SetButtonName(1072);
					m_Team2Locked = true;
				}
				hTeamListCtrl = m_hTeam2ListCtrl;
				break;
			default:
				break;
		}
		hTeamListCtrl.DeleteAllItem();
		Record.LVDataList.Length = 3;
		i = 0;
		while((i < PartyMemberCount))
		{
			if(Class'NWindow.EventMatchAPI'.static.GetUserData(TeamID, i, UserData))
			{
				Record.LVDataList[0].szData = UserData.UserName;
				Record.LVDataList[1].szData = string(UserData.UserLv);
				Record.LVDataList[2].szData = GetClassType(UserData.UserClass);
				hTeamListCtrl.InsertRecord(Record);
			}
			++i;
		}
		RefreshLockStatus();
	}
	return;
}

function RefreshLockStatus()
{
	return;
}

function StartCountDown()
{
	return;
}

function bool ApplySkillRule(string a_OptionFile)
{
	local int DefaultAllow;
	local string Command;
	local int i, Count, Id;

	if(!GetINIBool("Skill", "DefaultAllow", DefaultAllow, a_OptionFile))
	{
		DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(1425));
		return false;
	}
	Command = ("//eventmatch skill_rule" @ string(m_MatchID));
	if((1 == DefaultAllow))
	{
		Command = (Command @ "allow_all");
	}
	else
	{
		Command = (Command @ "deny_all");
	}
	if(!GetINIInt("Skill", "ExpSkillCnt", Count, a_OptionFile))
	{
		Count = 0;
	}
	i = 0;
	while((i < Count))
	{
		if(!GetINIInt("Skill", ("ExpSkillID" $ string(i)), Id, a_OptionFile))
		{
			DialogShow(DialogModalType_Modalless, DialogType_Notice, MakeFullSystemMsg(GetSystemMessage(1427), string(i)));
			return false;
		}
		if((1 == DefaultAllow))
		{
			Command = (Command @ "D");
		}
		else
		{
			Command = (Command @ "A");
		}
		Command = (Command $ string(Id));
		++i;
	}
	ExecuteCommand(Command);
	return true;
}

function bool ApplyItemRule(string a_OptionFile)
{
	local int DefaultAllow;
	local string Command;
	local int i, Count, Id;

	if(!GetINIBool("Item", "DefaultAllow", DefaultAllow, a_OptionFile))
	{
		DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(1425));
		return false;
	}
	Command = ("//eventmatch item_rule" @ string(m_MatchID));
	if((1 == DefaultAllow))
	{
		Command = (Command @ "allow_all");
	}
	else
	{
		Command = (Command @ "deny_all");
	}
	if(!GetINIInt("Item", "ExpItemCnt", Count, a_OptionFile))
	{
		Count = 0;
	}
	i = 0;
	while((i < Count))
	{
		if(!GetINIInt("Item", ("ExpItemID" $ string(i)), Id, a_OptionFile))
		{
			DialogShow(DialogModalType_Modalless, DialogType_Notice, MakeFullSystemMsg(GetSystemMessage(1427), string(i)));
			return false;
		}
		if((1 == DefaultAllow))
		{
			Command = (Command @ "D");
		}
		else
		{
			Command = (Command @ "A");
		}
		Command = (Command $ string(Id));
		++i;
	}
	ExecuteCommand(Command);
	return true;
}

function bool ApplyBuffRule()
{
	local string OptionFile, Command;
	local int i, Count, Level, Id;

	OptionFile = m_hOptionFileEditBox.GetString();
	if(!GetINIInt("Buff", "BuffCnt", Count, OptionFile))
	{
		DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(1422));
		return false;
	}
	if((0 >= Count))
	{
		return true;
	}
	Command = ("//eventmatch useskill" @ string(m_MatchID));
	i = 0;
	while((i < Count))
	{
		if(!GetINIInt("Buff", ("BuffID" $ string(i)), Id, OptionFile))
		{
			DialogShow(DialogModalType_Modalless, DialogType_Notice, MakeFullSystemMsg(GetSystemMessage(1423), string(i)));
			return false;
		}
		if(!GetINIInt("Buff", ("BuffLv" $ string(i)), Level, OptionFile))
		{
			DialogShow(DialogModalType_Modalless, DialogType_Notice, MakeFullSystemMsg(GetSystemMessage(1424), string(i)));
			return false;
		}
		Command = ((Command @ string(Id)) @ string(Level));
		++i;
	}
	ExecuteCommand(Command);
	return true;
}

function bool CheckBuffRule(string a_OptionFile)
{
	local int i, Count, Level, Id;

	if(!GetINIInt("Buff", "BuffCnt", Count, a_OptionFile))
	{
		DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(1422));
		return false;
	}
	i = 0;
	while((i < Count))
	{
		if(!GetINIInt("Buff", ("BuffID" $ string(i)), Id, a_OptionFile))
		{
			DialogShow(DialogModalType_Modalless, DialogType_Notice, MakeFullSystemMsg(GetSystemMessage(1423), string(i)));
			return false;
		}
		if(!GetINIInt("Buff", ("BuffLv" $ string(i)), Level, a_OptionFile))
		{
			DialogShow(DialogModalType_Modalless, DialogType_Notice, MakeFullSystemMsg(GetSystemMessage(1424), string(i)));
			return false;
		}
		++i;
	}
	return true;
}

function SetFence()
{
	if((m_hSetFenceButton.GetButtonName() == GetSystemString(1081)))
	{
		m_hSetFenceButton.SetButtonName(1082);
		ExecuteCommand((("//eventmatch fence" @ string(m_MatchID)) @ "2"));
	}
	else if((m_hSetFenceButton.GetButtonName() == GetSystemString(1082)))
	{
		m_hSetFenceButton.SetButtonName(1081);
		ExecuteCommand((("//eventmatch fence" @ string(m_MatchID)) @ "1"));
	}
	return;
}

function RemoveEventMatch()
{
	m_Team1Name = "";
	m_Team2Name = "";
	ExecuteCommand(("//eventmatch remove" @ string(m_MatchID)));
	GotoState('WaitingState');
	return;
}

function SetScore()
{
	ExecuteCommand(((("//eventmatch score" @ string(m_MatchID)) @ m_hTeam1ScoreEditBox.GetString()) @ m_hTeam2ScoreEditBox.GetString()));
	return;
}

function SendAnnounce()
{
	ExecuteCommand(((((("//eventmatch msg" @ string(m_MatchID)) @ string(0)) @ "\"") @ m_hAnnounceEditBox.GetString()) @ "\""));
	m_hAnnounceEditBox.Clear();
	return;
}

function SendGameEndMsg()
{
	ExecuteCommand(((("//eventmatch msg" @ string(m_MatchID)) @ string(3)) @ "NULL"));
	return;
}

function Firecracker(int a_TeamID)
{
	local int PartyMemberCount, i;
	local EventMatchUserData UserData;

	PartyMemberCount = Class'NWindow.EventMatchAPI'.static.GetPartyMemberCount(a_TeamID);
	i = 0;
	while((i < PartyMemberCount))
	{
		if(Class'NWindow.EventMatchAPI'.static.GetUserData(a_TeamID, i, UserData))
		{
			ExecuteCommand(("//eventmatch firecracker" @ UserData.UserName));
		}
		++i;
	}
	return;
}

function HandleEventMatchPartyLeader(string a_Param)
{
	local int TeamIdx;
	local string UserName;

	Debug(("HandleEventMatchPartyLeader a_Param=" @ a_Param));
	ParseInt(a_Param, "TeamIndex", TeamIdx);
	ParseString(a_Param, "UserName", UserName);
	switch(TeamIdx)
	{
		case 1:
			m_hTeam1LeaderNameEditBox.SetString(UserName);
			break;
		case 2:
			m_hTeam2LeaderNameEditBox.SetString(UserName);
			break;
		default:
			break;
	}
	return;
}

function HandleEventMatchManage(string a_Param)
{
	local int MatchID, MatchStat, FenceStat;
	local string Team1Name, Team2Name;
	local int Team1Stat, Team2Stat;

	ParseInt(a_Param, "MatchID", MatchID);
	ParseInt(a_Param, "MatchStat", MatchStat);
	ParseInt(a_Param, "FenceStat", FenceStat);
	ParseString(a_Param, "Team1Name", Team1Name);
	ParseString(a_Param, "Team2Name", Team2Name);
	ParseInt(a_Param, "Team1Stat", Team1Stat);
	ParseInt(a_Param, "Team2Stat", Team2Stat);
	GotoState('WaitingState');
	SetMatchID(MatchID);
	switch(MatchStat)
	{
		case 1:
			GotoState('CreatedState');
			break;
		case 2:
			GotoState('GamingState');
			SetPause(false);
			break;
		case 3:
			GotoState('GamingState');
			SetPause(true);
			break;
		default:
			break;
	}
	switch(FenceStat)
	{
		case 0:
		case 1:
			m_hSetFenceButton.SetButtonName(1081);
			break;
		case 2:
			m_hSetFenceButton.SetButtonName(1082);
			break;
		default:
			break;
	}
	if((0 == Team1Stat))
	{
		m_hLockTeam1Button.SetButtonName(1071);
		m_Team1Locked = false;
	}
	else
	{
		m_hLockTeam1Button.SetButtonName(1072);
		m_Team1Locked = true;
	}
	if((0 == Team2Stat))
	{
		m_hLockTeam2Button.SetButtonName(1071);
		m_Team2Locked = false;
	}
	else
	{
		m_hLockTeam2Button.SetButtonName(1072);
		m_Team2Locked = true;
	}
	m_hTeam1NameEditBox.SetString(Team1Name);
	m_hTeam2NameEditBox.SetString(Team2Name);
	m_hTeam1ListCtrl.DeleteAllItem();
	m_hTeam2ListCtrl.DeleteAllItem();
	return;
}

function SetPause(bool a_Pause, optional bool a_SendToServer)
{
	if((m_Paused == a_Pause))
	{
		return;
	}
	if(a_Pause)
	{
		m_hPauseButton.SetButtonName(1074);
		if(a_SendToServer)
		{
			ExecuteCommand(("//eventmatch pause" @ string(m_MatchID)));
		}
	}
	else
	{
		m_hPauseButton.SetButtonName(1073);
		if(a_SendToServer)
		{
			ExecuteCommand(("//eventmatch start" @ string(m_MatchID)));
		}
	}
	m_Paused = a_Pause;
	return;
}

function SetMatchID(int a_MatchID)
{
	m_MatchID = a_MatchID;
	if((-1 == m_MatchID))
	{
		m_hMatchIDTextBox.SetText("");
	}
	else
	{
		m_hMatchIDTextBox.SetText(string(m_MatchID));
	}
	return;
}

function OnClickSummon2Team()
{
	local int i, PartyMemberCount;
	local EventMatchUserData UserData;

	PartyMemberCount = Class'NWindow.EventMatchAPI'.static.GetPartyMemberCount(1);
	i = 0;
	while((i < PartyMemberCount))
	{
		if(Class'NWindow.EventMatchAPI'.static.GetUserData(1, i, UserData))
		{
			ExecuteCommand(("//recall" @ UserData.UserName));
		}
		++i;
	}
	return;
}

function OnClickSetAllHeal()
{
	local int PartyMemberCount0, PartyMemberCount1;
	local EventMatchUserData UserData;
	local int i;

	PartyMemberCount0 = Class'NWindow.EventMatchAPI'.static.GetPartyMemberCount(0);
	PartyMemberCount1 = Class'NWindow.EventMatchAPI'.static.GetPartyMemberCount(1);
	i = 0;
	while((i < PartyMemberCount0))
	{
		if(Class'NWindow.EventMatchAPI'.static.GetUserData(0, i, UserData))
		{
			ExecuteCommand(("//healthy" @ UserData.UserName));
		}
		++i;
	}
	i = 0;
	while((i < PartyMemberCount1))
	{
		if(Class'NWindow.EventMatchAPI'.static.GetUserData(1, i, UserData))
		{
			ExecuteCommand(("//healthy" @ UserData.UserName));
		}
		++i;
	}
	return;
}

function OnClickDelayReset()
{
	local int PartyMemberCount0, PartyMemberCount1;
	local EventMatchUserData UserData;
	local int i;

	PartyMemberCount0 = Class'NWindow.EventMatchAPI'.static.GetPartyMemberCount(0);
	PartyMemberCount1 = Class'NWindow.EventMatchAPI'.static.GetPartyMemberCount(1);
	i = 0;
	while((i < PartyMemberCount0))
	{
		if(Class'NWindow.EventMatchAPI'.static.GetUserData(0, i, UserData))
		{
			ExecuteCommand(("/target" @ UserData.UserName));
			ExecuteCommand("//remove_skill_delay_all");
		}
		++i;
	}
	i = 1;
	while((i < PartyMemberCount1))
	{
		if(Class'NWindow.EventMatchAPI'.static.GetUserData(1, i, UserData))
		{
			ExecuteCommand(("/target" @ UserData.UserName));
			ExecuteCommand("//remove_skill_delay_all");
		}
		++i;
	}
	return;
}

function OnClickSummon1Team()
{
	local int PartyMemberCount, i;
	local EventMatchUserData UserData;

	PartyMemberCount = Class'NWindow.EventMatchAPI'.static.GetPartyMemberCount(0);
	i = 0;
	while((i < PartyMemberCount))
	{
		if(Class'NWindow.EventMatchAPI'.static.GetUserData(0, i, UserData))
		{
			ExecuteCommand(("//recall" @ UserData.UserName));
		}
		++i;
	}
	return;
}

state HidingState
{
	function BeginState()
	{
		m_hOwnerWnd.HideWindow();
		return;
	}

	function EndState()
	{
		m_hOwnerWnd.ShowWindow();
		return;
	}

	function HandleShowEventMatchGMWnd()
	{
		GotoState('WaitingState');
		return;
	}
}

state WaitingState
{
	function BeginState()
	{
		SetMatchID(-1);
		m_hTeam1NameEditBox.Clear();
		m_hTeam2NameEditBox.Clear();
		m_hTeam1LeaderNameEditBox.Clear();
		m_hTeam2LeaderNameEditBox.Clear();
		m_hLockTeam1Button.SetButtonName(1071);
		m_hLockTeam2Button.SetButtonName(1071);
		m_hTeam1ListCtrl.DeleteAllItem();
		m_hTeam2ListCtrl.DeleteAllItem();
		m_Team1Locked = false;
		m_Team2Locked = false;
		SetPause(false);
		m_hCreateEventMatchButton.SetButtonName(1068);
		m_hCreateEventMatchButton.EnableWindow();
		m_hSetTeam1LeaderButton.DisableWindow();
		m_hLockTeam1Button.DisableWindow();
		m_hSetTeam2LeaderButton.DisableWindow();
		m_hLockTeam2Button.DisableWindow();
		m_hPauseButton.DisableWindow();
		m_hStartButton.DisableWindow();
		m_hSetScoreButton.DisableWindow();
		m_hSendAnnounceButton.DisableWindow();
		m_hSendGameEndMsgButton.DisableWindow();
		m_hSetFenceButton.DisableWindow();
		m_hTeam1FirecrackerButton.DisableWindow();
		m_hTeam2FirecrackerButton.DisableWindow();
		return;
	}

	function OnClickCreateEventMatchButton()
	{
		local string Team1Name, Team2Name;

		Team1Name = m_hTeam1NameEditBox.GetString();
		if((Team1Name == ""))
		{
			DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(1418));
			return;
		}
		Team2Name = m_hTeam2NameEditBox.GetString();
		if((Team2Name == ""))
		{
			DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(1419));
			return;
		}
		if((Team1Name == Team2Name))
		{
			DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(1420));
			return;
		}
		m_Team1Name = Team1Name;
		m_Team2Name = Team2Name;
		m_hEventMatchGMFenceWnd.ShowWindow();
		m_hEventMatchGMFenceWnd.SetFocus();
		return;
	}

	function NotifyFenceInfo(Vector a_Position, int a_XLength, int a_YLength)
	{
		ExecuteCommand(((((((("//eventmatch create 1" @ m_Team1Name) @ m_Team2Name) @ string(int(a_Position.X))) @ string(int(a_Position.Y))) @ string(int(a_Position.Z))) @ string(a_XLength)) @ string(a_YLength)));
		GotoState('CreatingState');
		return;
	}
}

state CreatingState
{
	function BeginState()
	{
		m_hCreateEventMatchButton.SetButtonName(1099);
		m_hCreateEventMatchButton.DisableWindow();
		return;
	}

	function HandleEventMatchCreated(string a_Param)
	{
		local int MatchID;

		if(ParseInt(a_Param, "MatchID", MatchID))
		{
			SetMatchID(MatchID);
			GotoState('CreatedState');
		}
		return;
	}
}

state CreatedState
{
	function BeginState()
	{
		m_hCreateEventMatchButton.SetButtonName(1069);
		m_hStartButton.SetButtonName(1075);
		m_hSetFenceButton.SetButtonName(1081);
		m_hCreateEventMatchButton.EnableWindow();
		m_hSetTeam1LeaderButton.EnableWindow();
		m_hLockTeam1Button.EnableWindow();
		m_hSetTeam2LeaderButton.EnableWindow();
		m_hLockTeam2Button.EnableWindow();
		m_hPauseButton.DisableWindow();
		RefreshLockStatus();
		m_hSetScoreButton.EnableWindow();
		m_hSendAnnounceButton.EnableWindow();
		m_hSendGameEndMsgButton.EnableWindow();
		m_hSetFenceButton.EnableWindow();
		m_hTeam1FirecrackerButton.EnableWindow();
		m_hTeam2FirecrackerButton.EnableWindow();
		SetPause(false);
		return;
	}

	function OnClickCreateEventMatchButton()
	{
		RemoveEventMatch();
		return;
	}

	function OnClickSetTeam1LeaderButton()
	{
		local UserInfo TargetInfo;

		if(GetTargetInfo(TargetInfo))
		{
			m_hTeam1LeaderNameEditBox.SetString(TargetInfo.Name);
		}
		return;
	}

	function OnClickLockTeam1Button()
	{
		local string OptionFile;

		OptionFile = m_hOptionFileEditBox.GetString();
		if(m_Team1Locked)
		{
			ExecuteCommand((("//eventmatch unlock" @ string(m_MatchID)) @ "1"));
			m_hLockTeam1Button.SetButtonName(1071);
			m_Team1Locked = false;
			m_hTeam1ListCtrl.DeleteAllItem();
			RefreshLockStatus();
		}
		else
		{
			ExecuteCommand(((("//eventmatch leader" @ string(m_MatchID)) @ "1") @ m_hTeam1LeaderNameEditBox.GetString()));
			ExecuteCommand((("//eventmatch lock" @ string(m_MatchID)) @ "1"));
		}
		RefreshINI(OptionFile);
		return;
	}

	function OnClickSetTeam2LeaderButton()
	{
		local UserInfo TargetInfo;

		if(GetTargetInfo(TargetInfo))
		{
			m_hTeam2LeaderNameEditBox.SetString(TargetInfo.Name);
		}
		return;
	}

	function OnClickLockTeam2Button()
	{
		local string OptionFile;

		OptionFile = m_hOptionFileEditBox.GetString();
		if(m_Team2Locked)
		{
			ExecuteCommand((("//eventmatch unlock" @ string(m_MatchID)) @ "2"));
			m_hLockTeam2Button.SetButtonName(1071);
			m_Team2Locked = false;
			m_hTeam2ListCtrl.DeleteAllItem();
			RefreshLockStatus();
		}
		else
		{
			ExecuteCommand(((("//eventmatch leader" @ string(m_MatchID)) @ "2") @ m_hTeam2LeaderNameEditBox.GetString()));
			ExecuteCommand((("//eventmatch lock" @ string(m_MatchID)) @ "2"));
		}
		RefreshINI(OptionFile);
		return;
	}

	function RefreshLockStatus()
	{
		if((m_Team1Locked && m_Team2Locked))
		{
			m_hStartButton.EnableWindow();
		}
		else
		{
			m_hStartButton.DisableWindow();
		}
		return;
	}

	function OnClickSetFenceButton()
	{
		SetFence();
		return;
	}

	function OnClickStartButton()
	{
		local string OptionFile;

		OptionFile = m_hOptionFileEditBox.GetString();
		if((OptionFile == ""))
		{
			DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(1421));
			return;
		}
		RefreshINI(OptionFile);
		if(!ApplySkillRule(OptionFile))
		{
			return;
		}
		if(!ApplyItemRule(OptionFile))
		{
			return;
		}
		if(!CheckBuffRule(OptionFile))
		{
			return;
		}
		GotoState('CountDownState');
		return;
	}

	function OnClickSetScoreButton()
	{
		SetScore();
		return;
	}

	function OnClickSendAnnounceButton()
	{
		SendAnnounce();
		return;
	}

	function OnClickSendGameEngMsgButton()
	{
		SendGameEndMsg();
		return;
	}

	function OnClickTeam1FirecrackerButton()
	{
		Firecracker(0);
		return;
	}

	function OnClickTeam2FirecrackerButton()
	{
		Firecracker(1);
		return;
	}

	function OnCompleteEditBox(string a_EditBoxID)
	{
		if((a_EditBoxID == "AnnounceEditBox"))
		{
			SendAnnounce();
		}
		return;
	}
}

state CountDownState
{
	function BeginState()
	{
		m_hStartButton.DisableWindow();
		m_hStartButton.SetButtonName(1102);
		m_hOwnerWnd.SetTimer(1, 1000);
		m_CountDown = 4;
		ExecuteCommand(((("//eventmatch msg" @ string(m_MatchID)) @ string(8)) @ "NULL"));
		return;
	}

	function OnClickCreateEventMatchButton()
	{
		RemoveEventMatch();
		return;
	}

	function OnClickSetFenceButton()
	{
		SetFence();
		return;
	}

	function OnTimer(int a_TimerID)
	{
		switch(a_TimerID)
		{
			case 1:
				switch(m_CountDown)
				{
					case 4:
						ExecuteCommand(((("//eventmatch msg" @ string(m_MatchID)) @ string(7)) @ "NULL"));
						m_CountDown = 3;
						break;
					case 3:
						ExecuteCommand(((("//eventmatch msg" @ string(m_MatchID)) @ string(6)) @ "NULL"));
						m_CountDown = 2;
						break;
					case 2:
						ExecuteCommand(((("//eventmatch msg" @ string(m_MatchID)) @ string(5)) @ "NULL"));
						m_CountDown = 1;
						break;
					case 1:
						ExecuteCommand(((("//eventmatch msg" @ string(m_MatchID)) @ string(4)) @ "NULL"));
						m_CountDown = 0;
						break;
					case 0:
						ExecuteCommand(((("//eventmatch msg" @ string(m_MatchID)) @ string(2)) @ "NULL"));
						if(!ApplyBuffRule())
						{
							return;
						}
						ExecuteCommand(("//eventmatch start" @ string(m_MatchID)));
						GotoState('GamingState');
					default:
						m_hOwnerWnd.KillTimer(1);
						m_CountDown = -1;
						break;
				}
				break;
			default:
				break;
		}
		return;
	}

	function OnClickSetScoreButton()
	{
		SetScore();
		return;
	}

	function OnClickSendAnnounceButton()
	{
		SendAnnounce();
		return;
	}

	function OnClickSendGameEngMsgButton()
	{
		SendGameEndMsg();
		return;
	}

	function OnClickTeam1FirecrackerButton()
	{
		Firecracker(0);
		return;
	}

	function OnClickTeam2FirecrackerButton()
	{
		Firecracker(1);
		return;
	}

	function OnCompleteEditBox(string a_EditBoxID)
	{
		if((a_EditBoxID == "AnnounceEditBox"))
		{
			SendAnnounce();
		}
		return;
	}
}

state GamingState
{
	function BeginState()
	{
		m_hPauseButton.SetButtonName(1073);
		m_hStartButton.SetButtonName(1076);
		m_hCreateEventMatchButton.EnableWindow();
		m_hSetTeam1LeaderButton.DisableWindow();
		m_hLockTeam1Button.DisableWindow();
		m_hSetTeam2LeaderButton.DisableWindow();
		m_hLockTeam2Button.DisableWindow();
		m_hPauseButton.EnableWindow();
		m_hStartButton.EnableWindow();
		m_hSetScoreButton.EnableWindow();
		m_hSendAnnounceButton.EnableWindow();
		m_hSendGameEndMsgButton.EnableWindow();
		m_hSetFenceButton.EnableWindow();
		m_hTeam1FirecrackerButton.EnableWindow();
		m_hTeam2FirecrackerButton.EnableWindow();
		return;
	}

	function OnClickCreateEventMatchButton()
	{
		RemoveEventMatch();
		return;
	}

	function OnClickStartButton()
	{
		ExecuteCommand(("//eventmatch dispelall" @ string(m_MatchID)));
		ExecuteCommand(("//eventmatch end" @ string(m_MatchID)));
		ExecuteCommand(((("//eventmatch msg" @ string(m_MatchID)) @ string(1)) @ "NULL"));
		GotoState('CreatedState');
		return;
	}

	function OnClickSetFenceButton()
	{
		SetFence();
		return;
	}

	function OnClickPauseButton()
	{
		SetPause(!m_Paused, true);
		return;
	}

	function OnClickSetScoreButton()
	{
		SetScore();
		return;
	}

	function OnClickSendAnnounceButton()
	{
		SendAnnounce();
		return;
	}

	function OnClickSendGameEngMsgButton()
	{
		SendGameEndMsg();
		return;
	}

	function OnClickTeam1FirecrackerButton()
	{
		Firecracker(0);
		return;
	}

	function OnClickTeam2FirecrackerButton()
	{
		Firecracker(1);
		return;
	}

	function OnCompleteEditBox(string a_EditBoxID)
	{
		if((a_EditBoxID == "AnnounceEditBox"))
		{
			SendAnnounce();
		}
		return;
	}
}
