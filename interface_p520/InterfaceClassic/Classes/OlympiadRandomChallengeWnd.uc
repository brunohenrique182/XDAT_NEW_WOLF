class OlympiadRandomChallengeWnd extends UICommonAPI
	dependson(UIPacket);

const TIMER_DELAYC = 3000;
const TIMER_CLICK = 99906;
const TIMER_CLICK2 = 99900;

enum GameRuleType
{
	GRT_TEAM,                       // 0
	GRT_CLASSLESS,                  // 1
	GRT_CLASS,                      // 2
	GRT_MAX                         // 3
};

var WindowHandle Me;
var WindowHandle disableWnd;
var WindowHandle MyScore_LastWeek_DisableWnd;
var TextBoxHandle MyScoreTitle_Text;
var TextBoxHandle MyScoreWeekTitle_Text;
var TextBoxHandle MyClass_Text;
var TextBoxHandle MyScore_Text;
var TextBoxHandle WinTitle_Text;
var TextBoxHandle WinNumber_Text;
var TextBoxHandle MyScore_LastWeek_Title_Text;
var TextBoxHandle MyClass_lastWeek_Text;
var TextBoxHandle Grade_lastWeek_Text;
var TextBoxHandle AllRankingTitle_lastWeek_Text;
var TextBoxHandle AllRanking_lastWeek_Text;
var TextBoxHandle AllClassRankingTitle_lastWeek_Text;
var TextBoxHandle AllClassRanking_lastWeek_Text;
var TextBoxHandle ServerClassRankingTitle_lastWeek_Text;
var TextBoxHandle ServerClassRanking_lastWeek_Text;
var TextBoxHandle ScoreTitle_lastWeek_Text;
var TextBoxHandle Score_lastWeek_Text;
var TextBoxHandle WinTitle_lastWeek_Text;
var TextBoxHandle Win_lastWeek_Text;
var TextBoxHandle LostTitle_lastWeek_Text;
var TextBoxHandle Lost_lastWeek_Text;
var TextBoxHandle Time_text;
var TextBoxHandle State_text;
var TextureHandle StateICON_Texture;
var TextBoxHandle StandbyStatus_text;
var TextBoxHandle GamesNumber_text;
var ButtonHandle ApplyCancel_Btn;
var ButtonHandle ReFresh_btn;
var bool SaveOpen;
var int registered;
var int IsPeaceZone;
var int bOpen;

function OnRegisterEvent()
{
	RegisterEvent(11020);
	RegisterEvent(11021);
	RegisterEvent(110);
	RegisterEvent(11023);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

function OnShow()
{
	if(GetWindowHandle("OlympiadWnd").IsShowWindow())
	{
		GetWindowHandle("OlympiadWnd").HideWindow();
	}
	return;
}

function Initialize()
{
	Me = GetWindowHandle("OlympiadRandomChallengeWnd");
	disableWnd = GetWindowHandle("OlympiadRandomChallengeWnd.DisableWnd");
	MyScore_LastWeek_DisableWnd = GetWindowHandle("OlympiadRandomChallengeWnd.MyScore_LastWeek_DisableWnd");
	MyScoreTitle_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.MyScoreTitle_Text");
	MyScoreWeekTitle_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.MyScoreWeekTitle_Text");
	MyClass_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.MyClass_Text");
	MyScore_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.MyScore_Text");
	WinTitle_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.WinTitle_Text");
	WinNumber_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.WinNumber_Text");
	MyScore_LastWeek_Title_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.MyScore_LastWeek_Title_Text");
	MyClass_lastWeek_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.MyClass_lastWeek_Text");
	Grade_lastWeek_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.Grade_lastWeek_Text");
	AllRankingTitle_lastWeek_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.AllRankingTitle_lastWeek_Text");
	AllRanking_lastWeek_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.AllRanking_lastWeek_Text");
	AllClassRankingTitle_lastWeek_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.AllClassRankingTitle_lastWeek_Text");
	AllClassRanking_lastWeek_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.AllClassRanking_lastWeek_Text");
	ServerClassRankingTitle_lastWeek_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.ServerClassRankingTitle_lastWeek_Text");
	ServerClassRanking_lastWeek_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.ServerClassRanking_lastWeek_Text");
	ScoreTitle_lastWeek_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.ScoreTitle_lastWeek_Text");
	Score_lastWeek_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.Score_lastWeek_Text");
	WinTitle_lastWeek_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.WinTitle_lastWeek_Text");
	Win_lastWeek_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.Win_lastWeek_Text");
	LostTitle_lastWeek_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.LostTitle_lastWeek_Text");
	Lost_lastWeek_Text = GetTextBoxHandle("OlympiadRandomChallengeWnd.Lost_lastWeek_Text");
	Time_text = GetTextBoxHandle("OlympiadRandomChallengeWnd.OlympiadMonth_text");
	State_text = GetTextBoxHandle("OlympiadRandomChallengeWnd.OlympiadState_text");
	StandbyStatus_text = GetTextBoxHandle("OlympiadRandomChallengeWnd.StandbyStatus_text");
	GamesNumber_text = GetTextBoxHandle("OlympiadRandomChallengeWnd.OlympiadGamesNumber_text");
	StateICON_Texture = GetTextureHandle("OlympiadRandomChallengeWnd.OlympiadStateICON_Texture");
	ApplyCancel_Btn = GetButtonHandle("OlympiadRandomChallengeWnd.ApplyCancel_Btn");
	ReFresh_btn = GetButtonHandle("OlympiadRandomChallengeWnd.Refresh_Btn");
	StateICON_Texture.SetTexture("L2UI_CT1.OlympiadWnd.OffICON");
	Time_text.SetText("");
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "ApplyCancel_Btn":
			OnApplyCancel_BtnClick();
			break;
		case "WindowHelp_BTN":
			ExecuteEvent(1210, "118");
			break;
		case "AllRanking_Btn":
			OnAllRanking_BtnClick();
			break;
		case "Refresh_Btn":
			Me.SetTimer(99906, 3000);
			ReFresh_btn.DisableWindow();
			OnReFresh_btnClick();
			break;
		default:
			break;
	}
	return;
}

function OnReFresh_btnClick()
{
	local array<byte> stream;
	local UIPacket._C_EX_OLYMPIAD_UI packet;

	packet.cGameRuleType = 0;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_OLYMPIAD_UI(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(626, stream);
	return;
}

function OnApplyCancel_BtnClick()
{
	Me.SetTimer(99900, 3000);
	ApplyCancel_Btn.DisableWindow();
	if((registered > 0))
	{
		API_C_EX_OLYMPIAD_MATCH_MAKING_CANCEL();
	}
	else
	{
		API_C_EX_OLYMPIAD_MATCH_MAKING();
	}
	return;
}

function OnAllRanking_BtnClick()
{
	RankingWnd(GetScript("RankingWnd")).ShowRankging();
	return;
}

function OnTimer(int TimerID)
{
	if((TimerID == 99906))
	{
		ReFresh_btn.EnableWindow();
		Me.KillTimer(99906);
	}
	else if((TimerID == 99900))
	{
		ApplyCancel_Btn.EnableWindow();
		Me.KillTimer(TimerID);
	}
	return;
}

function API_C_EX_OLYMPIAD_MATCH_MAKING()
{
	local array<byte> stream;
	local UIPacket._C_EX_OLYMPIAD_MATCH_MAKING packet;

	packet.cGameRuleType = 0;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_OLYMPIAD_MATCH_MAKING(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(585, stream);
	Debug("-> API_C_EX_OLYMPIAD_MATCH_MAKING");
	return;
}

function API_C_EX_OLYMPIAD_MATCH_MAKING_CANCEL()
{
	local array<byte> stream;
	local UIPacket._C_EX_OLYMPIAD_MATCH_MAKING_CANCEL packet;

	packet.cGameRuleType = 0;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_OLYMPIAD_MATCH_MAKING_CANCEL(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(586, stream);
	Debug("-> API_C_EX_OLYMPIAD_MATCH_MAKING_CANCEL");
	return;
}

function bool isRandomChallenge(string param)
{
	local int nGameRuleType;

	ParseInt(param, "GameRuleType", nGameRuleType);
	if((0 == nGameRuleType))
	{
		return true;
	}
	return false;
}

function OnEvent(int a_EventID, string param)
{
	switch(a_EventID)
	{
		case 11020:
			SaveData(param);
			break;
		case 11021:
			if(!isRandomChallenge(param))
			{
				return;
			}
			HandleOlympiadRecord(param);
			break;
		case 110:
			SetRadarZoneCode(param);
			break;
		case 11023:
			if(!isRandomChallenge(param))
			{
				return;
			}
			SwapApplyCancelButtonState(param);
			break;
		default:
			break;
	}
	return;
}

function HandleOlympiadRecord(string param)
{
	local int i, nMatchCount;
	local UserInfo Info;
	local string ClassName;
	local int nPrevClassType, nPrevGrade, nPoint, nWinCount;
	local float nPrevRank, nPrevRankCount, nPrevClassRank, nPrevClassRankCount, nPrevClassRankByServer, nPrevClassRankByServerCount;
	local int nPrevPoint, nPrevWinCount, nPrevLoseCount, season;
	local DetailStatusWnd Detail;

	ParseInt(param, "Season", season);
	Time_text.SetText((string(season) $ GetSystemString(934)));
	ParseInt(param, "MatchCount", nMatchCount);
	GamesNumber_text.SetText((string(nMatchCount) $ "/5"));
	ParseInt(param, "Point", nPoint);
	ParseInt(param, "WinCount", nWinCount);
	if(GetMyUserInfo(Info))
	{
		Detail = DetailStatusWnd(GetScript("DetailStatusWnd"));
		i = 0;
		while((i < Detail.subjobInfoArray.Length))
		{
			if((Detail.subjobInfoArray[i].Type == 0))
			{
				ClassName = GetClassType(Detail.subjobInfoArray[i].ClassID);
			}
			i++;
		}
		if(((Info.nNobless == 0) && !getInstanceUIData().GetIsClassicServer()))
		{
			disableWnd.ShowWindow();
		}
		else
		{
			disableWnd.HideWindow();
		}
	}
	MyClass_Text.SetText(ClassName);
	MyScore_Text.SetText((string(nPoint) @ GetSystemString(1442)));
	WinNumber_Text.SetText((string(nWinCount) @ GetSystemString(3844)));
	ParseInt(param, "PrevClassType", nPrevClassType);
	ParseInt(param, "PrevGrade", nPrevGrade);
	ParseFloat(param, "PrevRank", nPrevRank);
	ParseFloat(param, "PrevRankCount", nPrevRankCount);
	ParseFloat(param, "PrevClassRank", nPrevClassRank);
	ParseFloat(param, "PrevClassRankCount", nPrevClassRankCount);
	ParseFloat(param, "PrevClassRankByServer", nPrevClassRankByServer);
	ParseFloat(param, "PrevClassRankByServerCount", nPrevClassRankByServerCount);
	ParseInt(param, "PrevPoint", nPrevPoint);
	ParseInt(param, "PrevWinCount", nPrevWinCount);
	ParseInt(param, "PrevLoseCount", nPrevLoseCount);
	if((nPrevRank == 0.0000000))
	{
		MyScore_LastWeek_DisableWnd.ShowWindow();
	}
	else
	{
		MyScore_LastWeek_DisableWnd.HideWindow();
		MyClass_lastWeek_Text.SetText(GetClassType(nPrevClassType));
		if(getInstanceUIData().GetIsClassicServer())
		{
			Grade_lastWeek_Text.SetText(GetSystemString(1797));
		}
		else
		{
			Grade_lastWeek_Text.SetText((string(nPrevGrade) $ GetSystemString(1328)));
		}
		AllRanking_lastWeek_Text.SetText(((((string(int(nPrevRank)) @ GetSystemString(1375)) @ "(") $ stringPer(nPrevRank, nPrevRankCount)) $ "%)"));
		AllClassRanking_lastWeek_Text.SetText(((((string(int(nPrevClassRank)) @ GetSystemString(1375)) @ "(") $ stringPer(nPrevClassRank, nPrevClassRankCount)) $ "%)"));
		ServerClassRanking_lastWeek_Text.SetText(((((string(int(nPrevClassRankByServer)) @ GetSystemString(1375)) @ "(") $ stringPer(nPrevClassRankByServer, nPrevClassRankByServerCount)) $ "%)"));
		Score_lastWeek_Text.SetText((string(nPrevPoint) @ GetSystemString(1442)));
		Win_lastWeek_Text.SetText((string(nPrevWinCount) @ GetSystemString(3844)));
		Lost_lastWeek_Text.SetText((string(nPrevLoseCount) @ GetSystemString(3854)));
	}
	SwapApplyCancelButtonState(param);
	if((bOpen <= 0))
	{
		ApplyCancel_Btn.DisableWindow();
	}
	else
	{
		ApplyCancel_Btn.EnableWindow();
	}
	Me.ShowWindow();
	Me.SetFocus();
	return;
}

function SaveData(string param)
{
	ParseInt(param, "Open", bOpen);
	if((!isRandomChallenge(param) && (bOpen == 1)))
	{
		bOpen = 0;
	}
	if((bOpen == 0))
	{
		SaveOpen = false;
		StateICON_Texture.SetTexture("L2UI_CT1.OlympiadWnd.OffICON");
		if(((int(GetLanguage()) == 1) && getInstanceUIData().GetIsClassicServer()))
		{
			StandbyStatus_text.SetText(GetSystemString(9003));
		}
		else
		{
			StandbyStatus_text.SetText(GetSystemString(13211));
		}
		State_text.SetText(GetSystemString(13210));
		ApplyCancel_Btn.DisableWindow();
	}
	else
	{
		SaveOpen = true;
		StateICON_Texture.SetTexture("L2UI_CT1.OlympiadWnd.ONICON");
		StandbyStatus_text.SetText("");
		State_text.SetText(GetSystemString(13209));
		ApplyCancel_Btn.EnableWindow();
	}
	return;
}

function SetRadarZoneCode(string param)
{
	local int zonetype;

	ParseInt(param, "ZoneCode", zonetype);
	if(getInstanceUIData().IsPeaceZoneType(zonetype))
	{
		IsPeaceZone = 1;
	}
	else
	{
		IsPeaceZone = 0;
	}
	return;
}

function SwapApplyCancelButtonState(string param)
{
	ParseInt(param, "Registered", registered);
	SwapApplyCancelButtonText();
	return;
}

function SwapApplyCancelButtonText()
{
	if((registered > 0))
	{
		ApplyCancel_Btn.SetButtonName(3088);
	}
	else
	{
		ApplyCancel_Btn.SetButtonName(2277);
	}
	return;
}

function bool GetMyUserInfo(out UserInfo a_MyUserInfo)
{
	return GetPlayerInfo(a_MyUserInfo);
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}
