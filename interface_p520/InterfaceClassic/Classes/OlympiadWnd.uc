class OlympiadWnd extends UICommonAPI;

const TIMER_CLICK = 99903;
const TIMER_CLICK1 = 99905;
const TIMER_DELAYC = 3000;
const TIMER_CLICK2 = 99907;

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
var TextBoxHandle OlympiadMonth_text;
var TextBoxHandle OlympiadState_text;
var TextureHandle OlympiadStateICON_Texture;
var TextBoxHandle OlympiadGames_text;
var TextBoxHandle OlympiadGamesNumber_text;
var TextBoxHandle StandbyStatus_text;
var ButtonHandle Watch_Button;
var ButtonHandle Help01_Button;
var ButtonHandle Help02_Button;
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
var ButtonHandle ReFresh_btn;
var ButtonHandle AllRanking_Btn;
var ButtonHandle WindowHelp_BTN;
var ButtonHandle ApplyCancel_Btn;
var int registered;
var int IsPeaceZone;
var int bOpen;

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	Load();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("OlympiadWnd");
	disableWnd = GetWindowHandle("OlympiadWnd.DisableWnd");
	MyScore_LastWeek_DisableWnd = GetWindowHandle("OlympiadWnd.MyScore_LastWeek_DisableWnd");
	OlympiadMonth_text = GetTextBoxHandle("OlympiadWnd.OlympiadMonth_text");
	OlympiadState_text = GetTextBoxHandle("OlympiadWnd.OlympiadState_text");
	OlympiadStateICON_Texture = GetTextureHandle("OlympiadWnd.OlympiadStateICON_Texture");
	OlympiadGames_text = GetTextBoxHandle("OlympiadWnd.OlympiadGames_text");
	OlympiadGamesNumber_text = GetTextBoxHandle("OlympiadWnd.OlympiadGamesNumber_text");
	StandbyStatus_text = GetTextBoxHandle("OlympiadWnd.StandbyStatus_text");
	Watch_Button = GetButtonHandle("OlympiadWnd.Watch_Button");
	Help01_Button = GetButtonHandle("OlympiadWnd.Help01_Button");
	MyScoreTitle_Text = GetTextBoxHandle("OlympiadWnd.MyScoreTitle_Text");
	MyScoreWeekTitle_Text = GetTextBoxHandle("OlympiadWnd.MyScoreWeekTitle_Text");
	MyClass_Text = GetTextBoxHandle("OlympiadWnd.MyClass_Text");
	MyScore_Text = GetTextBoxHandle("OlympiadWnd.MyScore_Text");
	WinTitle_Text = GetTextBoxHandle("OlympiadWnd.WinTitle_Text");
	WinNumber_Text = GetTextBoxHandle("OlympiadWnd.WinNumber_Text");
	MyScore_LastWeek_Title_Text = GetTextBoxHandle("OlympiadWnd.MyScore_LastWeek_Title_Text");
	MyClass_lastWeek_Text = GetTextBoxHandle("OlympiadWnd.MyClass_lastWeek_Text");
	Grade_lastWeek_Text = GetTextBoxHandle("OlympiadWnd.Grade_lastWeek_Text");
	AllRankingTitle_lastWeek_Text = GetTextBoxHandle("OlympiadWnd.AllRankingTitle_lastWeek_Text");
	AllRanking_lastWeek_Text = GetTextBoxHandle("OlympiadWnd.AllRanking_lastWeek_Text");
	AllClassRankingTitle_lastWeek_Text = GetTextBoxHandle("OlympiadWnd.AllClassRankingTitle_lastWeek_Text");
	AllClassRanking_lastWeek_Text = GetTextBoxHandle("OlympiadWnd.AllClassRanking_lastWeek_Text");
	ServerClassRankingTitle_lastWeek_Text = GetTextBoxHandle("OlympiadWnd.ServerClassRankingTitle_lastWeek_Text");
	ServerClassRanking_lastWeek_Text = GetTextBoxHandle("OlympiadWnd.ServerClassRanking_lastWeek_Text");
	ScoreTitle_lastWeek_Text = GetTextBoxHandle("OlympiadWnd.ScoreTitle_lastWeek_Text");
	Score_lastWeek_Text = GetTextBoxHandle("OlympiadWnd.Score_lastWeek_Text");
	WinTitle_lastWeek_Text = GetTextBoxHandle("OlympiadWnd.WinTitle_lastWeek_Text");
	Win_lastWeek_Text = GetTextBoxHandle("OlympiadWnd.Win_lastWeek_Text");
	LostTitle_lastWeek_Text = GetTextBoxHandle("OlympiadWnd.LostTitle_lastWeek_Text");
	Lost_lastWeek_Text = GetTextBoxHandle("OlympiadWnd.Lost_lastWeek_Text");
	Help02_Button = GetButtonHandle("OlympiadWnd.Help02_Button");
	ReFresh_btn = GetButtonHandle("OlympiadWnd.Refresh_Btn");
	AllRanking_Btn = GetButtonHandle("OlympiadWnd.AllRanking_Btn");
	WindowHelp_BTN = GetButtonHandle("OlympiadWnd.WindowHelp_Btn");
	ApplyCancel_Btn = GetButtonHandle("OlympiadWnd.ApplyCancel_Btn");
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(11020);
	RegisterEvent(11021);
	RegisterEvent(110);
	RegisterEvent(11023);
	return;
}

function Load()
{
	Help01_Button.SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(3839), GetColor(178, 190, 207, 255), ""));
	Help02_Button.SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(3840), GetColor(178, 190, 207, 255), ""));
	if(getInstanceUIData().GetIsLiveServer())
	{
		ApplyCancel_Btn.SetTooltipType("text");
		ApplyCancel_Btn.SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14805), GetColor(178, 190, 207, 255), "", 300));
	}
	return;
}

function OnShow()
{
	if(Class'NWindow.UIDATA_PLAYER'.static.IsInPrison())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13773));
		Me.HideWindow();
		return;
	}
	if(GetWindowHandle("OlympiadRandomChallengeWnd").IsShowWindow())
	{
		GetWindowHandle("OlympiadRandomChallengeWnd").HideWindow();
	}
	Me.SetFocus();
	return;
}

function bool isRandomChallenge(string param)
{
	local int nGameRuleType;

	ParseInt(param, "GameRuleType", nGameRuleType);
	Debug(("GameRuleType.GRT_TEAM" @ string(0)));
	Debug(("nGameRuleType" @ string(nGameRuleType)));
	if((0 == nGameRuleType))
	{
		return true;
	}
	return false;
}

function OnEvent(int a_EventID, string param)
{
	local int zonetype;

	switch(a_EventID)
	{
		case 11020:
			Debug(("EV_OlympiadInfo" @ param));
			SaveData(param);
			break;
		case 11021:
			Debug(("EV_OlympiadRecord" @ param));
			if(isRandomChallenge(param))
			{
				return;
			}
			HandleOlympiadRecord(param);
			break;
		case 110:
			ParseInt(param, "ZoneCode", zonetype);
			if(getInstanceUIData().IsPeaceZoneType(zonetype))
			{
				IsPeaceZone = 1;
			}
			else
			{
				IsPeaceZone = 0;
			}
			break;
		case 11023:
			Debug(("EV_OlympiadMatchMakingResult" @ param));
			if(isRandomChallenge(param))
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

function SaveData(string param)
{
	ParseInt(param, "Open", bOpen);
	if((isRandomChallenge(param) && (bOpen == 1)))
	{
		bOpen = 0;
	}
	if((bOpen == 0))
	{
		OlympiadStateICON_Texture.SetTexture("L2UI_CT1.OlympiadWnd.OffICON");
		Watch_Button.HideWindow();
		StandbyStatus_text.ShowWindow();
		StandbyStatus_text.SetText(GetSystemString(3849));
		OlympiadState_text.SetText(GetSystemString(3836));
		ApplyCancel_Btn.DisableWindow();
	}
	else
	{
		OlympiadStateICON_Texture.SetTexture("L2UI_CT1.OlympiadWnd.ONICON");
		Watch_Button.ShowWindow();
		StandbyStatus_text.HideWindow();
		OlympiadState_text.SetText(GetSystemString(3835));
		ApplyCancel_Btn.EnableWindow();
	}
	return;
}

function bool GetMyUserInfo(out UserInfo a_MyUserInfo)
{
	return GetPlayerInfo(a_MyUserInfo);
}

function HandleOlympiadRecord(string param)
{
	local int i;
	local UserInfo Info;
	local string ClassName;
	local int SeasonYear, SeasonMonth, nMatchCount, nPoint, nWinCount, nPrevClassType, nPrevGrade;
	local float nPrevRank, nPrevRankCount, nPrevClassRank, nPrevClassRankCount, nPrevClassRankByServer, nPrevClassRankByServerCount;
	local int nPrevPoint, nPrevWinCount, nPrevLoseCount, season;
	local DetailStatusWnd Detail;

	Debug("-> HandleOlympiadRecord");
	ParseInt(param, "MatchCount", nMatchCount);
	if(getInstanceUIData().GetIsClassicServer())
	{
		ParseInt(param, "Season", season);
		OlympiadMonth_text.SetText((string(season) $ GetSystemString(934)));
		OlympiadGamesNumber_text.SetText((string(nMatchCount) $ "/5"));
		SwapApplyCancelButtonState(param);
		if(((nMatchCount == 0) || (bOpen <= 0)))
		{
			ApplyCancel_Btn.DisableWindow();
		}
		else
		{
			ApplyCancel_Btn.EnableWindow();
		}
	}
	else
	{
		ParseInt(param, "SeasonYear", SeasonYear);
		ParseInt(param, "SeasonMonth", SeasonMonth);
		OlympiadMonth_text.SetText((((string(SeasonYear) $ GetSystemString(3847)) @ string(SeasonMonth)) $ GetSystemString(3848)));
		OlympiadGamesNumber_text.SetText((string(nMatchCount) $ "/25"));
		SwapApplyCancelButtonState(param);
		GetPlayerInfo(Info);
		Debug(("info.nLevel" @ string(Info.nLevel)));
		Debug(("info.nNobless" @ string(Info.nNobless)));
		Debug(("GetClassTransferDegree( info.nSubClass )" @ string(GetClassTransferDegree(Info.nSubClass))));
		if((((Info.nLevel >= 110) && (Info.nNobless > 0)) && (GetClassTransferDegree(Info.nSubClass) > 3)))
		{
			if(((nMatchCount == 0) || (bOpen <= 0)))
			{
				ApplyCancel_Btn.DisableWindow();
			}
			else
			{
				ApplyCancel_Btn.EnableWindow();
			}
		}
		else
		{
			ApplyCancel_Btn.DisableWindow();
		}
	}
	if((nMatchCount <= 0))
	{
		OlympiadGamesNumber_text.SetTextColor(getInstanceL2Util().DarkGray);
	}
	else
	{
		OlympiadGamesNumber_text.SetTextColor(GetColor(187, 170, 136, 255));
	}
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
	ParseInt(param, "Point", nPoint);
	ParseInt(param, "WinCount", nWinCount);
	MyClass_Text.SetText(ClassName);
	MyScore_Text.SetText((string(nPoint) $ GetSystemString(1442)));
	WinNumber_Text.SetText((string(nWinCount) $ GetSystemString(3844)));
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
		AllRanking_lastWeek_Text.SetText(((((string(int(nPrevRank)) $ GetSystemString(1375)) $ "(") $ stringPer(nPrevRank, nPrevRankCount)) $ "%)"));
		AllClassRanking_lastWeek_Text.SetText(((((string(int(nPrevClassRank)) $ GetSystemString(1375)) $ "(") $ stringPer(nPrevClassRank, nPrevClassRankCount)) $ "%)"));
		ServerClassRanking_lastWeek_Text.SetText(((((string(int(nPrevClassRankByServer)) $ GetSystemString(1375)) $ "(") $ stringPer(nPrevClassRankByServer, nPrevClassRankByServerCount)) $ "%)"));
		Score_lastWeek_Text.SetText((string(nPrevPoint) $ GetSystemString(1442)));
		Win_lastWeek_Text.SetText((string(nPrevWinCount) $ GetSystemString(3844)));
		Lost_lastWeek_Text.SetText((string(nPrevLoseCount) $ GetSystemString(3854)));
	}
	Me.ShowWindow();
	Me.SetFocus();
	return;
}

function SwapApplyCancelButtonState(string param)
{
	ParseInt(param, "Registered", registered);
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

function OnTimer(int TimerID)
{
	if((TimerID == 99903))
	{
		ReFresh_btn.EnableWindow();
		Me.KillTimer(99903);
	}
	else if((TimerID == 99905))
	{
		Watch_Button.EnableWindow();
		Me.KillTimer(99905);
	}
	else if((TimerID == 99907))
	{
		ApplyCancel_Btn.EnableWindow();
		Me.KillTimer(TimerID);
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "Watch_Button":
			Me.SetTimer(99905, 3000);
			Watch_Button.DisableWindow();
			OnWatch_ButtonClick();
			break;
		case "Help01_Button":
			OnWindowHelp_BTNClick();
			break;
		case "Help02_Button":
			OnWindowHelp_BTNClick();
			break;
		case "Refresh_Btn":
			Me.SetTimer(99903, 3000);
			ReFresh_btn.DisableWindow();
			OnReFresh_btnClick();
			break;
		case "AllRanking_Btn":
			OnAllRanking_BtnClick();
			break;
		case "WindowHelp_Btn":
			OnWindowHelp_BTNClick();
			break;
		case "ApplyCancel_Btn":
			OnApplyCancel_ButtonClick();
			break;
		default:
			break;
	}
	return;
}

function OnApplyCancel_ButtonClick()
{
	Me.SetTimer(99907, 3000);
	ApplyCancel_Btn.DisableWindow();
	if((registered > 0))
	{
		Class'NWindow.OlympiadAPI'.static.RequestExOlympiadMatchMakingCancel();
	}
	else
	{
		Class'NWindow.OlympiadAPI'.static.RequestExOlympiadMatchMaking();
	}
	return;
}

function OnWatch_ButtonClick()
{
	if((IsPeaceZone == 1))
	{
		Class'NWindow.OlympiadAPI'.static.RequestOlympiadMatchList();
	}
	else
	{
		AddSystemMessage(5183);
	}
	return;
}

function OnWindowHelp_BTNClick()
{
	local string strParam;

	if(getInstanceUIData().GetIsClassicServer())
	{
		ParamAdd(strParam, "FilePath", (GetLocalizedL2TextPathNameUC() $ "olympiad_operator001h.htm"));
		ExecuteEvent(1210, strParam);
	}
	else
	{
		ExecuteEvent(1210, "114");
	}
	return;
}

function OnReFresh_btnClick()
{
	RequestOlympiadRecord();
	return;
}

function OnAllRanking_BtnClick()
{
	RankingWnd(GetScript("RankingWnd")).ShowRankging();
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}
