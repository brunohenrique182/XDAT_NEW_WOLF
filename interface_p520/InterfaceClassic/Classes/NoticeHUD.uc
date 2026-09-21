class NoticeHUD extends UICommonAPI
	dependson(UIPacket);

const WINDOW_W_MIN = 2;
const WINDOW_W_GAP = 2;
const MAX_CYCLE_TYPE_EVENT = 3;
const TIMER_OLYMPIADNOTICE = 1;
const TIMER_TIMEZONENOTICE = 2;
const TIMER_SIEGENOTICE = 3;
const TIMER_FORTRESS_NOTICE = 4;
const TIMER_WORLDSIEGENOTICE = 5;
const TIMER_WROLDSIEGEOUT = 6;
const TIMER_BALROGWARNOTICE = 7;
const TIMER_SkyTowerNOTICE = 8;
const TIMER_MATCHINGINZONE = 9;
const TIMER_FRESH_COOLTIME = 1000;
const MINLEVEL_WORLDSIEGE = 76;
const DIALOG_WORLDSIEGEIN = 0;
const DIALOG_WORLDSIEGEOUT = 1;
const DIALOG_TIMEZONEEXIT = 2;

enum SiegeType
{
	READY,                          // 0
	Start,                          // 1
	End                             // 2
};

enum WorldSiegeStateType
{
	READY,                          // 0
	Start,                          // 1
	End,                            // 2
	WORLD                           // 3
};

enum FortressType
{
	READY,                          // 0
	Start,                          // 1
	End                             // 2
};

enum BALROGWAR_State
{
	BWS_NONE,                       // 0
	BWS_PREPARE,                    // 1
	BWS_PROGRESS,                   // 2
	BWS_REWARD,                     // 3
	BWS_END                         // 4
};

enum BALROGWAR_ProgressStep
{
	BWPS_NONE,                      // 0
	BWPS_START,                     // 1
	BWPS_MIDBOSS1,                  // 2
	BWPS_MIDBOSS2,                  // 3
	BWPS_FINALBOSS,                 // 4
	BWPS_FINALBOSS_SPECIAL          // 5
};

enum SkyTowerStateType
{
	STATE_NONE,                     // 0
	LEADER_INFO,                    // 1
	CAMP_SELECT,                    // 2
	LEADER_MOVE,                    // 3
	WAR,                            // 4
	Reward,                         // 5
	End                             // 6
};

struct EventNoticeInfo
{
	var int EventID;
};

var string m_OlympiadNoticeWndName;
var string m_TimeZoneNoticeWndName;
var string m_SiegeNoticeWnd;
var string m_FortressBattleNoticeWndName;
var string m_WorldSiegeNoticeWnd;
var string m_DethroneNoticeWnd;
var string m_BalrogNoticeWnd;
var string m_SkyTowerNoticeWnd;
var string m_EventNoticeWnd;
var string m_EventNotice2Wnd;
var string m_EventNotice3Wnd;
var string m_MatchingInzoneNoticeWnd;
var WindowHandle OlympiadNoticeWnd;
var AnimTextureHandle OlympiadNoticeAnim;
var AnimTextureHandle OlympiadNoticeRegistedTexture;
var ButtonHandle OlympiadNoticeBtn;
var TextBoxHandle OlympiadNoticeText;
var int OlympiadNoticeRemainSec;
var int OlympiadNoticeRegistered;
var int GameRuleType;
var WindowHandle TimeZoneNoticeWnd;
var AnimTextureHandle TimeZoneNoticeAnim_Tex;
var ButtonHandle TimeZoneNoticePlus_Btn;
var TextBoxHandle TimeZoneNoticeTime_Txt;
var TextureHandle TimezoneNoticeEventRibbon_Tex;
var int TimeZoneCurrentFieldID;
var int TimeZoneRemainTimeSec;
var ButtonHandle TimeZoneNoticeExit_Btn;
var ButtonHandle TimeZoneNoticeExitLabel_Btn;
var WindowHandle siegeNoticeWnd;
var TextBoxHandle siegeText;
var TextBoxHandle siegeNoticeText;
var ButtonHandle siegeBtn;
var int siegeRemainTime;
var array<int> siegeCastleIDs;
var int siegeState;
var AnimTextureHandle siegeResult_AniTex;
var TextureHandle siegePlusIcon;
var array<int> PreAlarms;
var array<int> Alarms;
var WindowHandle DethroneNoticeWnd;
var AnimTextureHandle DethroneNoticeAnim_Tex;
var ButtonHandle DethroneNotice_Btn;
var bool isInitedDethrone;
var WindowHandle worldsiegeNoticeWnd;
var TextBoxHandle worldSiegeText;
var TextBoxHandle worldSiegeNoticeText;
var int worldsiegeRemainTime;
var array<int> worldsiegeCastleIDs;
var int worldsiegeState;
var int worldSiegeRemainTimeInout;
var bool IsInWorldSiege;
var ButtonHandle worldSiegeOngoing_Btn;
var ButtonHandle WorldSiegeWaiting_Btn;
var bool isWorldSiegeInOuttime;
var WindowHandle FortressBattleNoticeWnd;
var TextBoxHandle FortressBattleText;
var TextBoxHandle FortressBattleNoticeText;
var ButtonHandle FortressBattleBtn;
var int FortressBattleRemainTime;
var WindowHandle BalrogNoticeWnd;
var TextBoxHandle BalrogReadyText;
var TextBoxHandle BalrogReadyNoticeText;
var ButtonHandle BalrogReadyBtn;
var int BalrogWarRemainTime;
var int SkyTowerRemainTime;
var int skyTowerCurrentState;
var int skyTowerFieldID;
var bool skyTowerIsOneTimeShow;
var WindowHandle SkyTowerNoticeWnd;
var TextBoxHandle SkyTowerText;
var TextBoxHandle SkyTowerNoticeText;
var ButtonHandle SkyTowerOngoing_Btn;
var ButtonHandle SkyTower_Btn;
var WindowHandle eventNoticeWnd;
var WindowHandle eventNotice2Wnd;
var WindowHandle eventNotice3Wnd;
var array<EventNoticeInfo> _eventNoticeInfos;
var WindowHandle MatchingInzoneNoticeWnd;
var TextBoxHandle MatchingInzoneNoticeText;
var TextureHandle MatchingInzoneNoticeEventRibbon_Tex;
var AnimTextureHandle MatchingInzoneNoticeEnterReady_Tex;
var int matchingInzoneFieldID;
var int matchingInzoneMaintainTime;
var array<WindowHandle> allWindow;
var bool isShowInfoWnd;

static function NoticeHUD Inst()
{
	return NoticeHUD(GetScript("NoticeHud"));
}

function OnLoad()
{
	OlympiadNoticeWnd = GetWindowHandle(m_OlympiadNoticeWndName);
	OlympiadNoticeAnim = GetAnimTextureHandle((m_OlympiadNoticeWndName $ ".OlympiadNoticeAnim"));
	OlympiadNoticeBtn = GetButtonHandle((m_OlympiadNoticeWndName $ ".OlympiadNoticeBtn"));
	OlympiadNoticeText = GetTextBoxHandle((m_OlympiadNoticeWndName $ ".OlympiadNoticeText"));
	OlympiadNoticeRegistedTexture = GetAnimTextureHandle((m_OlympiadNoticeWndName $ ".OlympiadNoticeRegistedTexture"));
	TimeZoneNoticeWnd = GetWindowHandle(m_TimeZoneNoticeWndName);
	TimeZoneNoticeAnim_Tex = GetAnimTextureHandle((m_TimeZoneNoticeWndName $ ".TimeZoneNoticeAnim_Tex"));
	TimezoneNoticeEventRibbon_Tex = GetTextureHandle((m_TimeZoneNoticeWndName $ ".TimezoneNoticeEventRibbon_Tex"));
	TimeZoneNoticePlus_Btn = GetButtonHandle((m_TimeZoneNoticeWndName $ ".TimeZoneNoticePlus_Btn"));
	TimeZoneNoticeTime_Txt = GetTextBoxHandle((m_TimeZoneNoticeWndName $ ".TimeZoneNoticeTime_Txt"));
	TimeZoneNoticeExit_Btn = GetButtonHandle((m_TimeZoneNoticeWndName $ ".TimeZoneNoticeExit_Btn"));
	TimeZoneNoticeExitLabel_Btn = GetButtonHandle((m_TimeZoneNoticeWndName $ ".TimeZoneNoticeExitLabel_Btn"));
	siegeNoticeWnd = GetWindowHandle(m_SiegeNoticeWnd);
	siegeText = GetTextBoxHandle((m_SiegeNoticeWnd $ ".siegeText"));
	siegeNoticeText = GetTextBoxHandle((m_SiegeNoticeWnd $ ".SiegeNoticeText"));
	siegeBtn = GetButtonHandle((m_SiegeNoticeWnd $ ".siegeBtn"));
	siegeResult_AniTex = GetAnimTextureHandle((m_SiegeNoticeWnd $ ".Result_AniTex"));
	siegePlusIcon = GetTextureHandle((m_SiegeNoticeWnd $ ".PlusIcon"));
	siegeResult_AniTex.HideWindow();
	siegeResult_AniTex.Stop();
	DethroneNoticeWnd = GetWindowHandle(m_DethroneNoticeWnd);
	DethroneNoticeAnim_Tex = GetAnimTextureHandle((m_DethroneNoticeWnd $ ".DethroneNoticeAnim_Tex"));
	DethroneNotice_Btn = GetButtonHandle((m_DethroneNoticeWnd $ ".DethroneNotice_Btn"));
	worldsiegeNoticeWnd = GetWindowHandle(m_WorldSiegeNoticeWnd);
	worldSiegeText = GetTextBoxHandle((m_WorldSiegeNoticeWnd $ ".worldSiegeText"));
	worldSiegeNoticeText = GetTextBoxHandle((m_WorldSiegeNoticeWnd $ ".worldSiegeNoticeText"));
	worldSiegeOngoing_Btn = GetButtonHandle((m_WorldSiegeNoticeWnd $ ".worldSiegeOngoing_Btn"));
	WorldSiegeWaiting_Btn = GetButtonHandle((m_WorldSiegeNoticeWnd $ ".WorldSiegeWaiting_Btn"));
	FortressBattleNoticeWnd = GetWindowHandle(m_FortressBattleNoticeWndName);
	FortressBattleText = GetTextBoxHandle((m_FortressBattleNoticeWndName $ ".FortressBattleText"));
	FortressBattleNoticeText = GetTextBoxHandle((m_FortressBattleNoticeWndName $ ".FortressBattleNoticeText"));
	FortressBattleBtn = GetButtonHandle((m_FortressBattleNoticeWndName $ ".FortressBattleBtn"));
	BalrogNoticeWnd = GetWindowHandle(m_BalrogNoticeWnd);
	BalrogReadyText = GetTextBoxHandle((m_BalrogNoticeWnd $ ".BalrogReadyText"));
	BalrogReadyNoticeText = GetTextBoxHandle((m_BalrogNoticeWnd $ ".BalrogReadyNoticeText"));
	BalrogReadyBtn = GetButtonHandle((m_BalrogNoticeWnd $ ".BalrogReadyBtn"));
	SkyTowerNoticeWnd = GetWindowHandle(m_SkyTowerNoticeWnd);
	SkyTowerText = GetTextBoxHandle((m_SkyTowerNoticeWnd $ ".SkyTowerText"));
	SkyTowerNoticeText = GetTextBoxHandle((m_SkyTowerNoticeWnd $ ".SkyTowerNoticeText"));
	SkyTowerOngoing_Btn = GetButtonHandle((m_SkyTowerNoticeWnd $ ".SkyTowerOngoing_Btn"));
	SkyTower_Btn = GetButtonHandle((m_SkyTowerNoticeWnd $ ".SkyTower_Btn"));
	eventNoticeWnd = GetWindowHandle(m_EventNoticeWnd);
	eventNotice2Wnd = GetWindowHandle(m_EventNotice2Wnd);
	eventNotice3Wnd = GetWindowHandle(m_EventNotice3Wnd);
	MatchingInzoneNoticeWnd = GetWindowHandle(m_MatchingInzoneNoticeWnd);
	MatchingInzoneNoticeText = GetTextBoxHandle((m_MatchingInzoneNoticeWnd $ ".MatchingInzoneNoticeText"));
	MatchingInzoneNoticeEventRibbon_Tex = GetTextureHandle((m_MatchingInzoneNoticeWnd $ ".MatchingInzoneNoticeEventRibbon_Tex"));
	MatchingInzoneNoticeEnterReady_Tex = GetAnimTextureHandle((m_MatchingInzoneNoticeWnd $ ".MatchingInzoneNoticeRegistedTexture"));
	setWindowOrder();
	if(IsAdenServer())
	{
		GetSiegePointAlarms(PreAlarms, Alarms);
	}
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(11023);
	RegisterEvent(11240);
	RegisterEvent(11230);
	RegisterEvent(11240);
	RegisterEvent(11220);
	RegisterEvent(11250);
	RegisterEvent(11310);
	RegisterEvent((100000 + 848));
	RegisterEvent((100000 + 963));
	RegisterEvent((100000 + 966));
	RegisterEvent((100000 + 969));
	RegisterEvent((100000 + 1016));
	RegisterEvent((100000 + 1124));
	RegisterEvent((100000 + 1125));
	RegisterEvent((100000 + 1167));
	RegisterEvent((100000 + 1190));
	RegisterEvent(1710);
	RegisterEvent(40);
	RegisterEvent(3410);
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 1710:
			HandleDialogOK();
			break;
		case (100000 + 966):
			if(IsPlayerOnWorldRaidServer())
			{
				return;
			}
			HandleEvent_S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_HUD_INFO();
			break;
		case (100000 + 969):
			HandleEvent_S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_HUD_INFO();
			break;
		case 11023:
		case 11021:
			HandleOlympiadMatchMakingResult(a_Param);
			break;
		case 11230:
			HandleTimeRestrictFieldChargeResult(a_Param);
			break;
		case 11240:
			HandleTimeRestrictFieldUserAlarm(a_Param);
			break;
		case 11220:
			Debug(("EV_TimeRestrictFieldEnterResult" @ a_Param));
			HandleTimeRestrictFieldEnterResult(a_Param);
			break;
		case 11250:
			HandleTimeRestrictFieldExit(a_Param);
			break;
		case 11310:
			HandleMCW_CastleSiegeHUDInfo(a_Param);
			break;
		case (100000 + 848):
			Handle_S_EX_ADEN_FORTRESS_SIEGE_HUD_INFO();
			break;
		case (100000 + 963):
			Handle_S_EX_DETHRONE_SEASON_INFO();
			break;
		case (100000 + 1016):
			Handle_S_EX_BALROGWAR_HUD();
			break;
		case (100000 + 1124):
			Handle_S_EX_SERVERWAR_NOTIFY_HOST_HUD_INFO();
			break;
		case (100000 + 1125):
			Handle_S_EX_SERVERWAR_NOTIFY_HUD_INFO();
			break;
		case (100000 + 1167):
			Nt_S_EX_POPUP_EVENT_HUD();
			break;
		case (100000 + 1190):
			Handle_S_EX_MATCHINGINZONE_NOTIFY_HUD_INFO();
			break;
		case 40:
			isWorldSiegeInOuttime = false;
			isInitedDethrone = false;
			TimeZoneCurrentFieldID = -1;
			skyTowerIsOneTimeShow = false;
			_eventNoticeInfos.Length = 0;
			HandleAllHide();
			break;
		case 3410:
			HandleStageChange();
			break;
		default:
			break;
	}
	return;
}

event OnTextureAnimEnd(AnimTextureHandle a_AnimTextureHandle)
{
	switch(a_AnimTextureHandle)
	{
		case siegeResult_AniTex:
			siegeResult_AniTex.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string a_ButtonID)
{
	switch(a_ButtonID)
	{
		case "OlympiadNoticeBtn":
			HandleOnClickOlympiadBtn();
			break;
		case "TimeZoneNotice_Btn":
			HandleOnClickTimeZoneNotice_Btn();
			break;
		case "TimeZoneNoticePlus_Btn":
			HandleOnClickTimeZoneNoticePlus_Btn();
			break;
		case "TimeZoneNoticeExit_Btn":
			HandleOnClickTimeZoneNoticeExit_Btn();
			break;
		case "TimeZoneNoticeExitLabel_Btn":
			HandleOnClickTimeZoneNoticeExit_Btn();
			break;
		case "SiegeBtn":
			HandleOnClickSiegeBtn();
			break;
		case "FortressBattleBtn":
			HandleOnClickFortressBtn();
			break;
		case "DethroneNotice_Btn":
			HandleOnClickDethroneNoticeBtn();
			break;
		case "worldSiegeOngoing_Btn":
			HandleOnClickworldSiegeOngoing_Btn();
			break;
		case "WorldSiegeWaiting_Btn":
			HandleOnClickWorldSiegeWaiting_Btn();
			break;
		case "BalrogReadyBtn":
			HandleOnClickBalrogReadyBtn();
			break;
		case "SkyTowerOngoing_Btn":
			HandleOnClickSkyTowerOngoing_Btn();
			break;
		case "SkyTower_Btn":
			HandleOnClickSkyTower_Btn();
			break;
		case "RewardClose_Btn":
			HandleOnRewardClose_Btn();
			break;
		default:
			break;
	}
	return;
}

function OnClickButtonWithHandle(ButtonHandle btnHandle)
{
	if((btnHandle.GetWindowName() == "EventNotice_Btn"))
	{
		if((btnHandle.GetParentWindowName() == "EventNoticeWnd"))
		{
			HandleOnEventNotice_Btn(0);
		}
		else if((btnHandle.GetParentWindowName() == "EventNotice2Wnd"))
		{
			HandleOnEventNotice_Btn(1);
		}
		else if((btnHandle.GetParentWindowName() == "EventNotice3Wnd"))
		{
			HandleOnEventNotice_Btn(2);
		}
	}
	else if((btnHandle.GetWindowName() == "MatchingInzoneNotice_Btn"))
	{
		if((btnHandle.GetParentWindowName() == "MatchingInzoneNoticeWnd"))
		{
			if(GetWindowHandle("TimeZoneWnd").IsShowWindow())
			{
				GetWindowHandle("TimeZoneWnd").HideWindow();
			}
			else
			{
				TimeZoneWnd(GetScript("TimeZoneWnd")).ShowBySideBar(matchingInzoneFieldID);
			}
		}
	}
	return;
}

function OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case 1:
			HandleOlympiadNoticeRemainSec();
			break;
		case 2:
			TimeZoneRemainTimeSec = (TimeZoneRemainTimeSec - 1);
			HandleTimeZoneNoticeRemainMin();
			break;
		case 3:
			siegeRemainTime = (siegeRemainTime - 1);
			HandleTimeSiegeRemain();
			break;
		case 4:
			FortressBattleRemainTime = (FortressBattleRemainTime - 1);
			HandleTimeFortressRemain();
			break;
		case 5:
			--worldsiegeRemainTime;
			HandleTimeWorldSiegeRemain();
			break;
		case 6:
			--worldSiegeRemainTimeInout;
			HandleTimeEndWorldSiegeInoutTime();
			break;
		case 7:
			--BalrogWarRemainTime;
			HandleTimeBalrogWarRemain();
			break;
		case 8:
			--SkyTowerRemainTime;
			HandleTimeSkyTowerRemain();
			break;
		case 9:
			HandleMatchingZoneTimer();
			break;
		default:
			break;
	}
	return;
}

function KillAllTimer()
{
	OlympiadNoticeWnd.KillTimer(1);
	TimeZoneNoticeWnd.KillTimer(2);
	siegeNoticeWnd.KillTimer(3);
	FortressBattleNoticeWnd.KillTimer(4);
	worldsiegeNoticeWnd.KillTimer(5);
	worldsiegeNoticeWnd.KillTimer(6);
	BalrogNoticeWnd.KillTimer(7);
	SkyTowerNoticeWnd.KillTimer(8);
	MatchingInzoneNoticeWnd.KillTimer(9);
	return;
}

function HandleDialogOK()
{
	if(!DialogIsMine())
	{
		return;
	}
	switch(DialogGetID())
	{
		case 0:
			API_C_EX_WORLDCASTLEWAR_MOVE_TO_HOST();
			break;
		case 1:
			Class'InterfaceClassic.WorldSiegeWnd'.static.Inst().API_C_EX_WORLDCASTLEWAR_RETURN_TO_ORIGIN_PEER();
			break;
		case 2:
			Rq_C_EX_TIME_RESTRICT_FIELD_USER_LEAVE();
			break;
		default:
			break;
	}
	return;
}

function HandleOlympiadNotice(string param)
{
	local int Open;

	OlympiadNoticeWnd.KillTimer(1);
	ParseInt(param, "RemainSec", OlympiadNoticeRemainSec);
	ParseInt(param, "Open", Open);
	ParseInt(param, "GameRuleType", GameRuleType);
	if((Open > 0))
	{
		if((GameRuleType == 0))
		{
			OlympiadNoticeBtn.SetTexture("L2UI_ct1.RandomChallengeWnd.RandomChallengeWnd_BlueButton", "L2UI_ct1.RandomChallengeWnd.RandomChallengeWnd_BlueButton_Down", "L2UI_ct1.RandomChallengeWnd.RandomChallengeWnd_BlueButton_Over");
		}
		else
		{
			OlympiadNoticeBtn.SetTexture("L2UI_ct1.OlympiadWnd.OlympiadWnd_OlympiadButton", "L2UI_ct1.OlympiadWnd.OlympiadWnd_OlympiadButton_Down", "L2UI_ct1.OlympiadWnd.OlympiadWnd_OlympiadButton_Over");
		}
		OlympiadNoticeAnim.Stop();
		OlympiadNoticeAnim.SetLoopCount(1);
		OlympiadNoticeAnim.Play();
		HandleOlympiadNoticeRemainSec();
		OlympiadNoticeWnd.SetTimer(1, 1000);
		setWindowShow(OlympiadNoticeWnd);
	}
	else
	{
		SetWindowHide(OlympiadNoticeWnd);
	}
	return;
}

function HandleOlympiadMatchMakingResult(string param)
{
	ParseInt(param, "Registered", OlympiadNoticeRegistered);
	ChangeOlympiadJoinState();
	return;
}

function ChangeOlympiadJoinState()
{
	if((OlympiadNoticeRegistered > 0))
	{
		OlympiadNoticeRegistedTexture.Stop();
		OlympiadNoticeRegistedTexture.SetLoopCount(99999);
		OlympiadNoticeRegistedTexture.Play();
	}
	else
	{
		OlympiadNoticeRegistedTexture.Stop();
	}
	return;
}

function HandleOlympiadNoticeRemainSec()
{
	OlympiadNoticeRemainSec--;
	if((OlympiadNoticeRemainSec < 0))
	{
		OlympiadNoticeWnd.KillTimer(1);
		SetWindowHide(OlympiadNoticeWnd);
		return;
	}
	OlympiadNoticeText.SetText(GetTimeStringMS(OlympiadNoticeRemainSec));
	return;
}

function HandleOnClickOlympiadBtn()
{
	local array<byte> stream;
	local UIPacket._C_EX_OLYMPIAD_UI packet;

	if((GameRuleType == 0))
	{
		packet.cGameRuleType = GameRuleType;
		if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_OLYMPIAD_UI(stream, packet))
		{
			return;
		}
		Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(626, stream);
	}
	else if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("OlympiadWnd"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("OlympiadWnd");
	}
	else
	{
		RequestOlympiadRecord();
	}
	return;
}

function HandleTimeRestrictFieldChargeResult(string param)
{
	local int FieldId;

	ParseInt(param, "FieldID", FieldId);
	if((FieldId != TimeZoneCurrentFieldID))
	{
		return;
	}
	ParseInt(param, "RemainTime", TimeZoneRemainTimeSec);
	HandleTimeZoneNoticeRemainMin();
	TimeZoneNoticeAnim_Tex.Stop();
	TimeZoneNoticeAnim_Tex.SetLoopCount(1);
	TimeZoneNoticeAnim_Tex.Play();
	return;
}

function HandleTimeRestrictFieldUserAlarm(string param)
{
	ParseInt(param, "RemainTime", TimeZoneRemainTimeSec);
	HandleTimeZoneNoticeRemainMin();
	TimeZoneNoticeAnim_Tex.Stop();
	TimeZoneNoticeAnim_Tex.SetLoopCount(1);
	TimeZoneNoticeAnim_Tex.Play();
	return;
}

function HandleTimeRestrictFieldEnterResult(string param)
{
	local int EnterSuccess, EnterTimeStamp;
	local TimeRestrictFieldUIData fieldUIData;

	ParseInt(param, "bEnterSuccess", EnterSuccess);
	ParseInt(param, "RemainTime", TimeZoneRemainTimeSec);
	ParseInt(param, "EnterTimeStamp", EnterTimeStamp);
	if((EnterSuccess == 1))
	{
		ParseInt(param, "FieldID", TimeZoneCurrentFieldID);
		GetTimeRestrictFieldInfo(TimeZoneCurrentFieldID, fieldUIData);
		if(fieldUIData.IsEvent)
		{
			TimezoneNoticeEventRibbon_Tex.ShowWindow();
		}
		else
		{
			TimezoneNoticeEventRibbon_Tex.HideWindow();
		}
		if((fieldUIData.Type == "timezone"))
		{
			HandleTimeZoneNoticeRemainMin();
			if(IsTimeZoneUILabelType())
			{
				TimeZoneNoticeExit_Btn.HideWindow();
				TimeZoneNoticeExitLabel_Btn.ShowWindow();
				TimeZoneNoticePlus_Btn.HideWindow();
			}
			else
			{
				TimeZoneNoticeExit_Btn.ShowWindow();
				TimeZoneNoticeExitLabel_Btn.HideWindow();
				TimeZoneNoticePlus_Btn.ShowWindow();
			}
			setWindowShow(TimeZoneNoticeWnd);
			TimeZoneNoticeWnd.SetTimer(2, 1000);
		}
		QuitReportInstantZoneWnd(GetScript("QuitReportInstantZoneWnd")).InfoGainStart();
	}
	else
	{
		SetWindowHide(TimeZoneNoticeWnd);
	}
	return;
}

function int getTimeZoneCurrentFieldID()
{
	return TimeZoneCurrentFieldID;
}

function HandleTimeRestrictFieldExit(string param)
{
	local int FieldId;

	ParseInt(param, "FieldID", FieldId);
	if((TimeZoneCurrentFieldID == FieldId))
	{
		TimeZoneNoticeWnd.KillTimer(2);
		SetWindowHide(TimeZoneNoticeWnd);
		QuitReportInstantZoneWnd(GetScript("QuitReportInstantZoneWnd")).InfoGainResult();
		TimeZoneCurrentFieldID = -1;
	}
	return;
}

function HandleOnClickTimeZoneNotice_Btn()
{
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("TimeZoneWnd"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("TimeZoneWnd");
	}
	else if(getInstanceUIData().GetIsLiveServer())
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("TimeZoneWnd");
	}
	else
	{
		TimeZoneWnd(GetScript("TimeZoneWnd")).ShowBySideBar();
	}
	return;
}

function HandleOnClickTimeZoneNoticePlus_Btn()
{
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("TimeZoneSubWnd"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("TimeZoneSubWnd");
	}
	else
	{
		TimeZoneSubWnd(GetScript("TimeZoneSubWnd")).SetShowSubWindow(TimeZoneCurrentFieldID, TimeZoneNoticePlus_Btn);
	}
	return;
}

function HandleOnClickTimeZoneNoticeExit_Btn()
{
	ShowTimeZoneExitDialog();
	return;
}

function HandleTimeZoneNoticeRemainMin()
{
	if((TimeZoneRemainTimeSec < 60))
	{
		TimeZoneNoticeTime_Txt.SetText(MakeFullSystemMsg(GetSystemMessage(3408), MakeMin(60)));
	}
	else
	{
		TimeZoneNoticeTime_Txt.SetText(MakeMin(TimeZoneRemainTimeSec));
	}
	return;
}

function InputCastleIDs(int castleID)
{
	if(!siegeNoticeWnd.IsShowWindow())
	{
		siegeCastleIDs.Length = 0;
		SiegeWnd(GetScript("SiegeWnd")).castleIDs.Length = 0;
	}
	if((GetCastleIndexByCastleID(castleID) != -1))
	{
		return;
	}
	SiegeWnd(GetScript("SiegeWnd")).TabAdd(siegeCastleIDs.Length, castleID);
	siegeCastleIDs.Length = (siegeCastleIDs.Length + 1);
	siegeCastleIDs[(siegeCastleIDs.Length - 1)] = castleID;
	return;
}

function delCastleIDs(int Index)
{
	if((Index == -1))
	{
		return;
	}
	siegeCastleIDs.Remove(Index, 1);
	SiegeWnd(GetScript("SiegeWnd")).TabDel(Index);
	if((siegeCastleIDs.Length == 0))
	{
		SetWindowHide(siegeNoticeWnd);
		siegeNoticeWnd.KillTimer(3);
	}
	return;
}

function int GetCastleIndexByCastleID(int castleID)
{
	local int i;

	i = 0;
	while((i < siegeCastleIDs.Length))
	{
		if((siegeCastleIDs[i] == castleID))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function HandleMCW_CastleSiegeHUDInfo(string param)
{
	local int siegeCastleID;

	if(IsPlayerOnWorldRaidServer())
	{
		return;
	}
	ParseInt(param, "SiegeState", siegeState);
	ParseInt(param, "CastleID", siegeCastleID);
	switch(siegeState)
	{
		case 0:
			siegeText.SetTextColor(GetColor(255, 255, 255, 255));
			siegeNoticeText.SetTextColor(GetColor(255, 255, 255, 255));
			siegeNoticeWnd.KillTimer(3);
			break;
		case 1:
			siegeText.SetTextColor(GetColor(255, 119, 0, 255));
			siegeNoticeText.SetTextColor(GetColor(255, 153, 0, 255));
			siegeNoticeWnd.KillTimer(3);
			break;
		case 2:
			delCastleIDs(GetCastleIndexByCastleID(siegeCastleID));
			return;
			break;
		default:
			break;
	}
	InputCastleIDs(siegeCastleID);
	siegePlusIcon.HideWindow();
	setWindowShow(siegeNoticeWnd);
	ParseInt(param, "RemainTime", siegeRemainTime);
	siegeNoticeWnd.SetTimer(3, 1000);
	switch(siegeState)
	{
		case 0:
			siegeText.SetText(GetSystemString(13048));
			siegeBtn.SetTexture("L2UI_ct1.SiegeWnd_SiegeWaitingButton", "L2UI_ct1.SiegeWnd_SiegeWaitingButton_Over", "L2UI_ct1.SiegeWnd_SiegeWaitingButton_Down");
			break;
		case 1:
			siegeText.SetText(GetSystemString(13049));
			siegeBtn.SetTexture("L2UI_ct1.SiegeWnd_SiegeProgressButton", "L2UI_ct1.SiegeWnd_SiegeProgressButton_Over", "L2UI_ct1.SiegeWnd_SiegeProgressButton_Down");
			break;
		default:
			break;
	}
	return;
}

function HandleOnClickSiegeBtn()
{
	if(GetWindowHandle("SiegeWnd").IsShowWindow())
	{
		GetWindowHandle("SiegeWnd").HideWindow();
	}
	else if((siegeCastleIDs.Length > 0))
	{
		SiegeWnd(GetScript("SiegeWnd")).TabSetSelectedIndex(0);
	}
	return;
}

function HandleTimeSiegeRemain()
{
	if((siegeRemainTime < 0))
	{
		siegeNoticeWnd.KillTimer(3);
		SetWindowHide(siegeNoticeWnd);
		return;
	}
	if(((siegeState == 1) && (IsAdenServer() == true)))
	{
		setAlarms(siegeRemainTime);
	}
	siegeNoticeText.SetText(GetTimeStringMS(siegeRemainTime));
	return;
}

function setAlarms(int Time)
{
	local int i;
	local bool bper;

	bper = false;
	i = 0;
	while((i < PreAlarms.Length))
	{
		if(((Time <= PreAlarms[i]) && (Time > Alarms[i])))
		{
			bper = true;
		}
		if((Time == Alarms[i]))
		{
			siegeResult_AniTex.ShowWindow();
			siegeResult_AniTex.Stop();
			siegeResult_AniTex.SetLoopCount(1);
			siegeResult_AniTex.Play();
		}
		i++;
	}
	if(bper)
	{
		siegePlusIcon.ShowWindow();
		siegeNoticeText.SetTextColor(GetColor(0, 255, 0, 255));
	}
	else
	{
		siegePlusIcon.HideWindow();
		siegeNoticeText.SetTextColor(GetColor(220, 220, 220, 255));
	}
	return;
}

function InputWorldCastleIDs(int castleID)
{
	if(!worldsiegeNoticeWnd.IsShowWindow())
	{
		worldsiegeCastleIDs.Length = 0;
		WorldSiegeWnd(GetScript("WorldSiegeWnd")).castleIDs.Length = 0;
	}
	if((GetWorldCastleIndexByCastleID(castleID) != -1))
	{
		return;
	}
	worldsiegeCastleIDs[worldsiegeCastleIDs.Length] = castleID;
	WorldSiegeWnd(GetScript("WorldSiegeWnd")).castleIDs = worldsiegeCastleIDs;
	return;
}

function DelWorldCastleIDs(int Index)
{
	if((Index == -1))
	{
		return;
	}
	worldsiegeCastleIDs.Remove(Index, 1);
	if(((worldsiegeCastleIDs.Length == 0) && !isWorldSiegeInOuttime))
	{
		SetWindowHide(worldsiegeNoticeWnd);
		worldsiegeNoticeWnd.KillTimer(5);
	}
	return;
}

function int GetWorldCastleIndexByCastleID(int castleID)
{
	local int i;

	i = 0;
	while((i < worldsiegeCastleIDs.Length))
	{
		if((worldsiegeCastleIDs[i] == castleID))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function SetWorldSiegeEnd(int siegeState)
{
	if((worldsiegeState != 1))
	{
		worldsiegeState = siegeState;
		return;
	}
	if(!IsInWorldSiege)
	{
		return;
	}
	worldsiegeState = siegeState;
	GetWindowHandle("WorldSiegeWnd").HideWindow();
	GetWindowHandle("WorldSiegeRankingWnd").HideWindow();
	GetWindowHandle("WorldSiegeInfoMCWWnd").HideWindow();
	GetWindowHandle("WorldSiegeMercenaryWnd").HideWindow();
	worldSiegeRemainTimeInout = 1800;
	HandleTimeEndWorldSiegeInoutTime();
	worldSiegeText.SetText(GetSystemString(13048));
	worldSiegeText.SetTextColor(GetColor(255, 255, 255, 255));
	worldSiegeNoticeText.SetTextColor(GetColor(255, 255, 255, 255));
	worldSiegeText.SetText(GetSystemString(153));
	worldsiegeNoticeWnd.KillTimer(5);
	worldsiegeNoticeWnd.SetTimer(6, 1000);
	isWorldSiegeInOuttime = true;
	setWindowShow(worldsiegeNoticeWnd);
	return;
}

function SetWorldCastleSiegeHUDInfo(int castleID, int siegeState, int nowTime, int RemainTime)
{
	switch(siegeState)
	{
		case 0:
			if(((nowTime == 0) && (RemainTime == 0)))
			{
				DelWorldCastleIDs(GetWorldCastleIndexByCastleID(castleID));
				return;
			}
			worldSiegeText.SetText(GetSystemString(13048));
			worldSiegeText.SetTextColor(GetColor(255, 255, 255, 255));
			worldSiegeNoticeText.SetTextColor(GetColor(255, 255, 255, 255));
			break;
		case 1:
			worldSiegeText.SetText(GetSystemString(13049));
			worldSiegeText.SetTextColor(GetColor(255, 119, 0, 255));
			worldSiegeNoticeText.SetTextColor(GetColor(255, 153, 0, 255));
			break;
		case 2:
			worldSiegeText.SetText(GetSystemString(13050));
			DelWorldCastleIDs(GetWorldCastleIndexByCastleID(castleID));
			SetWorldSiegeEnd(siegeState);
			break;
		default:
			break;
	}
	worldsiegeState = siegeState;
	if((2 == worldsiegeState))
	{
		return;
	}
	Class'InterfaceClassic.WorldSiegeRankingWnd'.static.Inst().SiegeInfo_Text.SetText(worldSiegeText.GetText());
	InputWorldCastleIDs(castleID);
	setWindowShow(worldsiegeNoticeWnd);
	worldsiegeRemainTime = Max(0, ((nowTime + RemainTime) - Class'InterfaceClassic.UIData'.static.Inst().GetCurrentRealLocalTimeSec()));
	HandleTimeWorldSiegeRemain();
	worldsiegeNoticeWnd.KillTimer(5);
	worldsiegeNoticeWnd.SetTimer(5, 1000);
	WorldSiegeWnd(GetScript("WorldSiegeWnd")).SetWorldCastleSiegeHUDInfo(castleID, siegeState);
	return;
}

function HandleOnClickworldSiegeOngoing_Btn()
{
	if(GetWindowHandle("WorldSiegeWnd").IsShowWindow())
	{
		GetWindowHandle("WorldSiegeWnd").HideWindow();
	}
	else if(isWorldSiegeInOuttime)
	{
		Class'InterfaceClassic.UICommonAPI'.static.DialogSetID(1);
		DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(13200));
		DialogMoveToCursor();
	}
	else
	{
		WorldSiegeWnd(GetScript("WorldSiegeWnd")).API_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_INFO();
	}
	return;
}

function HandleOnClickWorldSiegeWaiting_Btn()
{
	local UserInfo UserInfo;

	GetPlayerInfo(UserInfo);
	if((UserInfo.nLevel < 76))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13578));
	}
	else
	{
		Class'InterfaceClassic.UICommonAPI'.static.DialogSetID(0);
		DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemString(13864));
		DialogMoveToCursor();
	}
	return;
}

function HandleTimeBalrogWarRemain()
{
	if((BalrogWarRemainTime <= 0))
	{
		BalrogNoticeWnd.KillTimer(7);
		SetWindowHide(BalrogNoticeWnd);
	}
	BalrogReadyNoticeText.SetText(GetTimeStringMS(BalrogWarRemainTime));
	return;
}

function HandleTimeSkyTowerRemain()
{
	if((SkyTowerRemainTime <= 0))
	{
		BalrogNoticeWnd.KillTimer(8);
		SetWindowHide(SkyTowerNoticeWnd);
	}
	SkyTowerNoticeText.SetText(GetTimeStringMS(SkyTowerRemainTime));
	return;
}

function HandleTimeWorldSiegeRemain()
{
	if((worldsiegeRemainTime <= 0))
	{
		worldsiegeNoticeWnd.KillTimer(5);
		if(!isWorldSiegeInOuttime)
		{
			SetWindowHide(worldsiegeNoticeWnd);
		}
		return;
	}
	worldSiegeNoticeText.SetText(GetTimeStringMS(worldsiegeRemainTime));
	Class'InterfaceClassic.WorldSiegeBoardWnd'.static.Inst().Time_Txt.SetText(worldSiegeNoticeText.GetText());
	return;
}

function HandleTimeEndWorldSiegeInoutTime()
{
	if((worldSiegeRemainTimeInout <= 0))
	{
		worldsiegeNoticeWnd.KillTimer(6);
		SetWindowHide(worldsiegeNoticeWnd);
		isWorldSiegeInOuttime = false;
		return;
	}
	worldSiegeNoticeText.SetText(GetTimeStringMS(worldSiegeRemainTimeInout));
	return;
}

function bool IsInWorldSiegeStarted()
{
	return (IsInWorldSiege && (worldsiegeState == 1));
}

function HandleEvent_S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_HUD_INFO()
{
	local UIPacket._S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_HUD_INFO packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_HUD_INFO(packet))
	{
		return;
	}
	switch(packet.nSiegeState)
	{
		case 1:
			if(IsInWorldSiege)
			{
				Class'InterfaceClassic.WorldSiegeBoardWnd'.static.Inst().API_C_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HUD_INFO();
			}
			Class'InterfaceClassic.WorldSiegeLauncherWnd'.static.Inst().m_hOwnerWnd.ShowWindow();
			break;
		default:
			Class'InterfaceClassic.WorldSiegeLauncherWnd'.static.Inst().m_hOwnerWnd.HideWindow();
			Class'InterfaceClassic.WorldSiegeBoardWnd'.static.Inst().EndWorldSiege();
			break;
	}
	IsInWorldSiege = true;
	SetWorldCastleSiegeHUDInfo(packet.nCastleID, packet.nSiegeState, packet.nNowTime, packet.nRemainTime);
	worldSiegeOngoing_Btn.ShowWindow();
	WorldSiegeWaiting_Btn.HideWindow();
	return;
}

function HandleEvent_S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_HUD_INFO()
{
	local UIPacket._S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_HUD_INFO packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_HUD_INFO(packet))
	{
		return;
	}
	IsInWorldSiege = false;
	SetWorldCastleSiegeHUDInfo(packet.nCastleID, packet.nSiegeState, packet.nNowTime, packet.nRemainTime);
	worldSiegeOngoing_Btn.HideWindow();
	WorldSiegeWaiting_Btn.ShowWindow();
	Class'InterfaceClassic.WorldSiegeBoardWnd'.static.Inst().EndWorldSiege();
	Class'InterfaceClassic.WorldSiegeLauncherWnd'.static.Inst().m_hOwnerWnd.HideWindow();
	return;
}

function Handle_S_EX_SERVERWAR_NOTIFY_HOST_HUD_INFO()
{
	local UIPacket._S_EX_SERVERWAR_NOTIFY_HOST_HUD_INFO packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_SERVERWAR_NOTIFY_HOST_HUD_INFO(packet))
	{
		return;
	}
	Debug(((((("--> Decode_S_EX_SERVERWAR_NOTIFY_HOST_HUD_INFO" @ string(packet.nFieldID)) @ string(packet.nState)) @ string(packet.nNowTime)) @ string(packet.nRemainTime)) @ string(packet.nNextStateBeginTime)));
	SetSkyTowerHUDInfo(packet.nFieldID, packet.nState, packet.nNowTime, packet.nRemainTime, packet.nNextStateBeginTime);
	return;
}

function Handle_S_EX_SERVERWAR_NOTIFY_HUD_INFO()
{
	local UIPacket._S_EX_SERVERWAR_NOTIFY_HUD_INFO packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_SERVERWAR_NOTIFY_HUD_INFO(packet))
	{
		return;
	}
	Debug(((((("--> Decode_S_EX_SERVERWAR_NOTIFY_HUD_INFO" @ string(packet.nFieldID)) @ string(packet.nState)) @ string(packet.nNowTime)) @ string(packet.nRemainTime)) @ string(packet.nNextStateBeginTime)));
	SetSkyTowerHUDInfo(packet.nFieldID, packet.nState, packet.nNowTime, packet.nRemainTime, packet.nNextStateBeginTime);
	return;
}

function SetSkyTowerHUDInfo(int nFieldID, int nState, int nowTime, int RemainTime, int nNextStateBeginTime)
{
	skyTowerFieldID = nFieldID;
	skyTowerCurrentState = nState;
	switch(nState)
	{
		case 1:
			SkyTowerText.SetText(GetSystemString(14527));
			SkyTowerOngoing_Btn.HideWindow();
			SkyTower_Btn.ShowWindow();
			if(GetWindowHandle("SkyTowerEnterWnd").IsShowWindow())
			{
				GetWindowHandle("SkyTowerEnterWnd").HideWindow();
			}
			break;
		case 2:
			SkyTowerText.SetText(GetSystemString(14528));
			SkyTowerOngoing_Btn.HideWindow();
			SkyTower_Btn.ShowWindow();
			if(GetWindowHandle("SkyTowerEnterWnd").IsShowWindow())
			{
				GetWindowHandle("SkyTowerEnterWnd").HideWindow();
			}
			break;
		case 3:
			SkyTowerText.SetText(GetSystemString(14570));
			SkyTowerOngoing_Btn.HideWindow();
			SkyTower_Btn.ShowWindow();
			if(GetWindowHandle("SkyTowerWnd").IsShowWindow())
			{
				Class'InterfaceClassic.SkyTowerWnd'.static.Inst().API_C_EX_SERVERWAR_LEADER_LIST(skyTowerFieldID);
				Class'InterfaceClassic.SkyTowerWnd'.static.Inst().API_C_EX_SERVERWAR_SELECT_LEADER_INFO(skyTowerFieldID);
			}
			break;
		case 4:
			SkyTowerText.SetText(GetSystemString(14529));
			SkyTowerOngoing_Btn.ShowWindow();
			SkyTower_Btn.HideWindow();
			if(GetWindowHandle("SkyTowerWnd").IsShowWindow())
			{
				Class'InterfaceClassic.SkyTowerWnd'.static.Inst().API_C_EX_SERVERWAR_SELECT_LEADER_INFO(skyTowerFieldID);
				Class'InterfaceClassic.SkyTowerWnd'.static.Inst().API_C_EX_SERVERWAR_LEADER_LIST(skyTowerFieldID);
			}
			else if(((IsPlayerOnWorldRaidServer() && (TimeZoneCurrentFieldID == skyTowerFieldID)) && (skyTowerIsOneTimeShow == false)))
			{
				skyTowerIsOneTimeShow = true;
				Class'InterfaceClassic.SkyTowerWnd'.static.Inst().API_C_EX_SERVERWAR_SELECT_LEADER_INFO(skyTowerFieldID);
				Class'InterfaceClassic.SkyTowerWnd'.static.Inst().API_C_EX_SERVERWAR_LEADER_LIST(skyTowerFieldID);
			}
			break;
		case 5:
			SkyTowerText.SetText(GetSystemString(14530));
			SkyTowerOngoing_Btn.HideWindow();
			SkyTower_Btn.ShowWindow();
			if(GetWindowHandle("SkyTowerWnd").IsShowWindow())
			{
				Class'InterfaceClassic.SkyTowerWnd'.static.Inst().API_C_EX_SERVERWAR_SELECT_LEADER_INFO(skyTowerFieldID);
				Class'InterfaceClassic.SkyTowerWnd'.static.Inst().API_C_EX_SERVERWAR_LEADER_LIST(skyTowerFieldID);
				Class'InterfaceClassic.SkyTowerWnd'.static.Inst().API_C_EX_SERVERWAR_REWARD_ITEM_INFO(skyTowerFieldID);
				Class'InterfaceClassic.SkyTowerWnd'.static.Inst().API_C_EX_SERVERWAR_REWARD_INFO(skyTowerFieldID);
			}
			break;
		default:
			break;
	}
	if(((nState == 6) || (nState == 0)))
	{
		SetWindowHide(SkyTowerNoticeWnd);
		SkyTowerNoticeWnd.KillTimer(8);
		if(GetWindowHandle("SkyTowerWnd").IsShowWindow())
		{
			GetWindowHandle("SkyTowerWnd").HideWindow();
		}
	}
	else
	{
		SkyTowerRemainTime = Max(0, ((nowTime + RemainTime) - Class'InterfaceClassic.UIData'.static.Inst().GetCurrentRealLocalTimeSec()));
		SkyTowerNoticeWnd.KillTimer(8);
		SkyTowerNoticeWnd.SetTimer(8, 1000);
		setWindowShow(SkyTowerNoticeWnd);
	}
	return;
}

function HandleOnClickSkyTowerOngoing_Btn()
{
	HandleOnClickSkyTower_Btn();
	return;
}

function HandleOnClickSkyTower_Btn()
{
	Debug(("skyTowerCurrentState" @ string(skyTowerCurrentState)));
	if((IsPlayerOnWorldRaidServer() == false))
	{
		if(GetWindowHandle("SkyTowerEnterWnd").IsShowWindow())
		{
			GetWindowHandle("SkyTowerEnterWnd").HideWindow();
		}
		else
		{
			Class'InterfaceClassic.SkyTowerEnterWnd'.static.Inst().API_C_EX_SERVERWAR_FIELD_ENTER_USER_INFO(skyTowerFieldID);
		}
		return;
	}
	if((TimeZoneCurrentFieldID != skyTowerFieldID))
	{
		if(GetWindowHandle("SkyTowerEnterWnd").IsShowWindow())
		{
			GetWindowHandle("SkyTowerEnterWnd").HideWindow();
		}
		else
		{
			Class'InterfaceClassic.SkyTowerEnterWnd'.static.Inst().API_C_EX_SERVERWAR_FIELD_ENTER_USER_INFO(skyTowerFieldID);
		}
		return;
	}
	switch(skyTowerCurrentState)
	{
		case 1:
			if(GetWindowHandle("SkyTowerEnterWnd").IsShowWindow())
			{
				GetWindowHandle("SkyTowerEnterWnd").HideWindow();
			}
			else
			{
				GetWindowHandle("SkyTowerEnterWnd").ShowWindow();
				SkyTowerEnterWnd(GetScript("SkyTowerEnterWnd")).setDisableTeleportBtn();
				Debug("텔레포트 버튼 상태 ");  // EN?: Teleport button status
			}
			break;
		case 2:
			if(GetWindowHandle("SkyTowerWnd").IsShowWindow())
			{
				GetWindowHandle("SkyTowerWnd").HideWindow();
			}
			else
			{
				Class'InterfaceClassic.SkyTowerWnd'.static.Inst().API_C_EX_SERVERWAR_LEADER_LIST(skyTowerFieldID);
			}
			break;
		case 3:
			if(GetWindowHandle("SkyTowerWnd").IsShowWindow())
			{
				GetWindowHandle("SkyTowerWnd").HideWindow();
			}
			else
			{
				Class'InterfaceClassic.SkyTowerWnd'.static.Inst().API_C_EX_SERVERWAR_SELECT_LEADER_INFO(skyTowerFieldID);
			}
			break;
		case 4:
			if(GetWindowHandle("SkyTowerWnd").IsShowWindow())
			{
				GetWindowHandle("SkyTowerWnd").HideWindow();
			}
			else
			{
				Class'InterfaceClassic.SkyTowerWnd'.static.Inst().API_C_EX_SERVERWAR_SELECT_LEADER_INFO(skyTowerFieldID);
				Class'InterfaceClassic.SkyTowerWnd'.static.Inst().API_C_EX_SERVERWAR_LEADER_LIST(skyTowerFieldID);
			}
			break;
		case 5:
			if(GetWindowHandle("SkyTowerWnd").IsShowWindow())
			{
				GetWindowHandle("SkyTowerWnd").HideWindow();
			}
			else
			{
				Class'InterfaceClassic.SkyTowerWnd'.static.Inst().API_C_EX_SERVERWAR_SELECT_LEADER_INFO(skyTowerFieldID);
				Class'InterfaceClassic.SkyTowerWnd'.static.Inst().API_C_EX_SERVERWAR_LEADER_LIST(skyTowerFieldID);
				Class'InterfaceClassic.SkyTowerWnd'.static.Inst().API_C_EX_SERVERWAR_REWARD_ITEM_INFO(skyTowerFieldID);
				Class'InterfaceClassic.SkyTowerWnd'.static.Inst().API_C_EX_SERVERWAR_REWARD_INFO(skyTowerFieldID);
			}
			break;
		default:
			break;
	}
	return;
}

function HandleOnEventNotice_Btn(int eventIndex)
{
	if((eventIndex < _eventNoticeInfos.Length))
	{
		Class'InterfaceClassic.EventNoticeEnterWnd'.static.Inst().ToggleShowNoticeEnterWnd(_eventNoticeInfos[eventIndex].EventID);
	}
	return;
}

function HandleOnRewardClose_Btn()
{
	return;
}

function Handle_S_EX_BALROGWAR_HUD()
{
	local UIPacket._S_EX_BALROGWAR_HUD packet;
	local string BalrogText;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_BALROGWAR_HUD(packet))
	{
		return;
	}
	if((packet.nState == 1))
	{
		BalrogText = GetSystemString(13989);
	}
	else if((packet.nState == 2))
	{
		BalrogText = GetSystemString(13990);
	}
	else if((packet.nState == 3))
	{
		BalrogText = GetSystemString(13991);
	}
	else if((packet.nState == 4))
	{
		BalrogNoticeWnd.KillTimer(7);
		SetWindowHide(BalrogNoticeWnd);
	}
	if(((int(GetLanguage()) == 8) || (int(GetLanguage()) == 9)))
	{
		BalrogReadyText.SetTooltipType("text");
		BalrogReadyText.SetTooltipText(BalrogText);
		BalrogText = GetEllipsisString(BalrogText, 50);
	}
	BalrogReadyText.SetText(BalrogText);
	if((packet.nProgressStep == 0))
	{
		setBalrogProgress(0);
	}
	else if((packet.nProgressStep == 1))
	{
		setBalrogProgress(1);
	}
	else if((packet.nProgressStep == 2))
	{
		setBalrogProgress(2);
	}
	else if((packet.nProgressStep == 3))
	{
		setBalrogProgress(3);
	}
	else if((packet.nProgressStep == 4))
	{
		setBalrogProgress(4);
	}
	else if((packet.nProgressStep == 5))
	{
		setBalrogProgress(4, true);
	}
	if((packet.nState != 4))
	{
		BalrogWarRemainTime = packet.nLeftTime;
		BalrogNoticeWnd.KillTimer(7);
		BalrogNoticeWnd.SetTimer(7, 1000);
		setWindowShow(BalrogNoticeWnd);
	}
	return;
}

function setBalrogProgress(int nStep, optional bool bRed)
{
	if(bRed)
	{
		GetTextureHandle(("BalrogNoticeWnd.StepCheck_wnd00" $ ".StepOn_tex")).SetTexture("L2UI_EPIC.BalrogWnd.BalrogHudStep_Red");
		GetTextureHandle(("BalrogNoticeWnd.StepCheck_wnd01" $ ".StepOn_tex")).SetTexture("L2UI_EPIC.BalrogWnd.BalrogHudStep_Red");
		GetTextureHandle(("BalrogNoticeWnd.StepCheck_wnd02" $ ".StepOn_tex")).SetTexture("L2UI_EPIC.BalrogWnd.BalrogHudStep_Red");
		GetTextureHandle(("BalrogNoticeWnd.StepCheck_wnd03" $ ".StepOn_tex")).SetTexture("L2UI_EPIC.BalrogWnd.BalrogHudStep_Red");
	}
	else
	{
		GetTextureHandle(("BalrogNoticeWnd.StepCheck_wnd00" $ ".StepOn_tex")).SetTexture("L2UI_EPIC.BalrogWnd.BalrogHudStep_on");
		GetTextureHandle(("BalrogNoticeWnd.StepCheck_wnd01" $ ".StepOn_tex")).SetTexture("L2UI_EPIC.BalrogWnd.BalrogHudStep_on");
		GetTextureHandle(("BalrogNoticeWnd.StepCheck_wnd02" $ ".StepOn_tex")).SetTexture("L2UI_EPIC.BalrogWnd.BalrogHudStep_on");
		GetTextureHandle(("BalrogNoticeWnd.StepCheck_wnd03" $ ".StepOn_tex")).SetTexture("L2UI_EPIC.BalrogWnd.BalrogHudStep_on");
	}
	switch(nStep)
	{
		case 0:
			GetTextureHandle(("BalrogNoticeWnd.StepCheck_wnd00" $ ".StepOn_tex")).HideWindow();
			GetTextureHandle(("BalrogNoticeWnd.StepCheck_wnd01" $ ".StepOn_tex")).HideWindow();
			GetTextureHandle(("BalrogNoticeWnd.StepCheck_wnd02" $ ".StepOn_tex")).HideWindow();
			GetTextureHandle(("BalrogNoticeWnd.StepCheck_wnd03" $ ".StepOn_tex")).HideWindow();
			break;
		case 1:
			GetTextureHandle(("BalrogNoticeWnd.StepCheck_wnd00" $ ".StepOn_tex")).ShowWindow();
			GetTextureHandle(("BalrogNoticeWnd.StepCheck_wnd01" $ ".StepOn_tex")).HideWindow();
			GetTextureHandle(("BalrogNoticeWnd.StepCheck_wnd02" $ ".StepOn_tex")).HideWindow();
			GetTextureHandle(("BalrogNoticeWnd.StepCheck_wnd03" $ ".StepOn_tex")).HideWindow();
			break;
		case 2:
			GetTextureHandle(("BalrogNoticeWnd.StepCheck_wnd00" $ ".StepOn_tex")).ShowWindow();
			GetTextureHandle(("BalrogNoticeWnd.StepCheck_wnd01" $ ".StepOn_tex")).ShowWindow();
			GetTextureHandle(("BalrogNoticeWnd.StepCheck_wnd02" $ ".StepOn_tex")).HideWindow();
			GetTextureHandle(("BalrogNoticeWnd.StepCheck_wnd03" $ ".StepOn_tex")).HideWindow();
			break;
		case 3:
			GetTextureHandle(("BalrogNoticeWnd.StepCheck_wnd00" $ ".StepOn_tex")).ShowWindow();
			GetTextureHandle(("BalrogNoticeWnd.StepCheck_wnd01" $ ".StepOn_tex")).ShowWindow();
			GetTextureHandle(("BalrogNoticeWnd.StepCheck_wnd02" $ ".StepOn_tex")).ShowWindow();
			GetTextureHandle(("BalrogNoticeWnd.StepCheck_wnd03" $ ".StepOn_tex")).HideWindow();
			break;
		case 4:
			GetTextureHandle(("BalrogNoticeWnd.StepCheck_wnd00" $ ".StepOn_tex")).ShowWindow();
			GetTextureHandle(("BalrogNoticeWnd.StepCheck_wnd01" $ ".StepOn_tex")).ShowWindow();
			GetTextureHandle(("BalrogNoticeWnd.StepCheck_wnd02" $ ".StepOn_tex")).ShowWindow();
			GetTextureHandle(("BalrogNoticeWnd.StepCheck_wnd03" $ ".StepOn_tex")).ShowWindow();
			break;
		default:
			break;
	}
	return;
}

function HandleOnClickBalrogReadyBtn()
{
	if(GetWindowHandle("BalrogWnd").IsShowWindow())
	{
		GetWindowHandle("BalrogWnd").HideWindow();
	}
	else
	{
		GetWindowHandle("BalrogWnd").ShowWindow();
	}
	return;
}

function Handle_S_EX_MATCHINGINZONE_NOTIFY_HUD_INFO()
{
	local UIPacket._S_EX_MATCHINGINZONE_NOTIFY_HUD_INFO packet;
	local TimeRestrictFieldUIData fieldUIData;
	local int RemainTime;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_MATCHINGINZONE_NOTIFY_HUD_INFO(packet))
	{
		return;
	}
	Debug(((("매칭fieldID" @ string(packet.nFieldID)) @ string(packet.nState)) @ string(packet.nMaintainTime)));  // EN?: MatchfieldID
	Debug(("matchingInzoneFieldID" @ string(matchingInzoneFieldID)));
	matchingInzoneFieldID = packet.nFieldID;
	Debug("======================================================");
	Debug(("matchingInzoneFieldID" @ string(matchingInzoneFieldID)));
	Debug(("nState" @ string(packet.nState)));
	GetTimeRestrictFieldInfo(packet.nFieldID, fieldUIData);
	MatchingInzoneNoticeText.SetText(fieldUIData.FieldName);
	Debug(("fieldUIData.FieldName" @ fieldUIData.FieldName));
	Debug(("fieldUIData.Type " @ fieldUIData.Type));
	Debug("======================================================");
	if(fieldUIData.IsEvent)
	{
		MatchingInzoneNoticeEventRibbon_Tex.ShowWindow();
	}
	else
	{
		MatchingInzoneNoticeEventRibbon_Tex.HideWindow();
	}
	if(!((packet.nMaintainTime == 0) && (packet.nState == 0)))
	{
		matchingInzoneMaintainTime = packet.nMaintainTime;
	}
	Debug(("matchingInzoneMaintainTime" @ string(matchingInzoneMaintainTime)));
	RemainTime = (matchingInzoneMaintainTime - Class'InterfaceClassic.UIData'.static.Inst().GetCurrentRealLocalTimeSec());
	Debug(("remainTime" @ string(RemainTime)));
	Debug((((((("S_EX_MATCHINGINZONE_NOTIFY_HUD_INFO" @ string(packet.nFieldID)) @ fieldUIData.Type) @ string(packet.nNowTime)) @ string(matchingInzoneMaintainTime)) @ string(Class'InterfaceClassic.UIData'.static.Inst().GetCurrentRealLocalTimeSec())) @ string(RemainTime)));
	if((RemainTime > 0))
	{
		MatchingInzoneNoticeWnd.SetTimer(9, 1000);
	}
	else
	{
		MatchingInzoneNoticeWnd.KillTimer(9);
	}
	if(((packet.nState == 0) && (RemainTime <= 0)))
	{
		SetWindowHide(MatchingInzoneNoticeWnd);
	}
	else
	{
		setWindowShow(MatchingInzoneNoticeWnd);
	}
	UpdateMatchingInzoneEnterReadyState();
	return;
}

function UpdateMatchingInzoneEnterReadyState()
{
	local TimeRestrictFieldUIData fieldUIData;
	local int teamMatchingEntryTime;

	if((MatchingInzoneNoticeWnd.IsShowWindow() == false))
	{
		return;
	}
	GetTimeRestrictFieldInfo(matchingInzoneFieldID, fieldUIData);
	if((fieldUIData.Type == "team_matchingInzone"))
	{
		if(CheckScheduledTimeRestrictFieldUserEnterPacket(matchingInzoneFieldID, teamMatchingEntryTime))
		{
			Debug("CheckScheduledTimeRestrictFieldUserEnterPacket true");
			Debug(("teamMatchingEntryTime" @ string(teamMatchingEntryTime)));
			if((MatchingInzoneNoticeEnterReady_Tex.IsShowWindow() == false))
			{
				MatchingInzoneNoticeEnterReady_Tex.Stop();
				MatchingInzoneNoticeEnterReady_Tex.SetLoopCount(99999);
				MatchingInzoneNoticeEnterReady_Tex.Play();
				MatchingInzoneNoticeEnterReady_Tex.ShowWindow();
			}
			MatchingInzoneNoticeText.MoveC(3, 71);
		}
		else
		{
			MatchingInzoneNoticeEnterReady_Tex.Stop();
			MatchingInzoneNoticeEnterReady_Tex.HideWindow();
			MatchingInzoneNoticeText.MoveC(3, 60);
			Debug("CheckScheduledTimeRestrictFieldUserEnterPacket false");
		}
	}
	else
	{
		MatchingInzoneNoticeEnterReady_Tex.Stop();
		MatchingInzoneNoticeEnterReady_Tex.HideWindow();
		MatchingInzoneNoticeText.MoveC(3, 60);
	}
	return;
}

function int GetOpenedMatchingInzoneFieldID()
{
	if(MatchingInzoneNoticeWnd.IsShowWindow())
	{
		return matchingInzoneFieldID;
	}
	return 0;
}

function HandleMatchingZoneTimer()
{
	local int RemainTime;

	RemainTime = (matchingInzoneMaintainTime - Class'InterfaceClassic.UIData'.static.Inst().GetCurrentRealLocalTimeSec());
	if((RemainTime <= 0))
	{
		SetWindowHide(MatchingInzoneNoticeWnd);
		MatchingInzoneNoticeWnd.KillTimer(9);
	}
	return;
}

function Handle_S_EX_DETHRONE_SEASON_INFO()
{
	local UIPacket._S_EX_DETHRONE_SEASON_INFO packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_DETHRONE_SEASON_INFO(packet))
	{
		return;
	}
	if((int(packet.bOpen) == 1))
	{
		DethroneNoticeAnim_Tex.Stop();
		DethroneNoticeAnim_Tex.SetLoopCount(1);
		DethroneNoticeAnim_Tex.Play();
		setWindowShow(DethroneNoticeWnd);
		if(!Class'NWindow.UIDATA_PLAYER'.static.IsInDethrone())
		{
			AddSystemMessage(13424);
		}
	}
	else
	{
		SetWindowHide(DethroneNoticeWnd);
		if(isInitedDethrone)
		{
			AddSystemMessage(13425);
		}
	}
	if(!isInitedDethrone)
	{
		isInitedDethrone = true;
	}
	DethroneCharacterCreatewnd(GetScript("DethroneCharacterCreatewnd")).SetBOpen(int(packet.bOpen));
	return;
}

function HandleOnClickDethroneNoticeBtn()
{
	if(GetWindowHandle("DethroneWnd").IsShowWindow())
	{
		GetWindowHandle("DethroneWnd").HideWindow();
	}
	else
	{
		GetWindowHandle("DethroneWnd").ShowWindow();
	}
	return;
}

function Handle_S_EX_ADEN_FORTRESS_SIEGE_HUD_INFO()
{
	local UIPacket._S_EX_ADEN_FORTRESS_SIEGE_HUD_INFO packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_ADEN_FORTRESS_SIEGE_HUD_INFO(packet))
	{
		return;
	}
	switch(packet.nSiegeState)
	{
		case 0:
			FortressBattleText.SetText(GetSystemString(13237));
			setWindowShow(FortressBattleNoticeWnd);
			FortressBattleBtn.SetTexture("L2UI_EPIC.FortressBattleInfoWnd_FortressWaitingButton", "L2UI_EPIC.FortressBattleInfoWnd_FortressWaitingButton_Over", "L2UI_EPIC.FortressBattleInfoWnd_FortressWaitingButton_Down");
			break;
		case 1:
			FortressBattleText.SetText(GetSystemString(13238));
			setWindowShow(FortressBattleNoticeWnd);
			FortressBattleBtn.SetTexture("L2UI_EPIC.FortressBattleInfoWnd.FortressBattleInfoWnd_FortressProgressButton", "L2UI_EPIC.FortressBattleInfoWnd.FortressBattleInfoWnd_FortressProgressButton_Over", "L2UI_EPIC.FortressBattleInfoWnd.FortressBattleInfoWnd_FortressProgressButton_Down");
			break;
		case 2:
			SetWindowHide(FortressBattleNoticeWnd);
			GetWindowHandle("FortressBattleInfoWnd").HideWindow();
			break;
		default:
			break;
	}
	FortressBattleRemainTime = packet.nRemainTime;
	FortressBattleNoticeWnd.KillTimer(4);
	FortressBattleNoticeWnd.SetTimer(4, 1000);
	return;
}

function Nt_S_EX_POPUP_EVENT_HUD()
{
	local UIPacket._S_EX_POPUP_EVENT_HUD packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_POPUP_EVENT_HUD(packet))
	{
		return;
	}
	Debug((("Nt_S_EX_POPUP_EVENT_HUD" @ string(packet.nID)) @ string(packet.bOn)));
	UpdateEventNoticeInfo(bool(packet.bOn), packet.nID);
	UpdateEventNoticeWnd();
	return;
}

function UpdateEventNoticeWnd()
{
	local PopupEventData EventData;
	local array<WindowHandle> eventWnds;
	local int i, eventnum;

	eventWnds[0] = eventNoticeWnd;
	eventWnds[1] = eventNotice2Wnd;
	eventWnds[2] = eventNotice3Wnd;
	eventnum = Max(_eventNoticeInfos.Length, eventWnds.Length);
	i = 0;
	while((i < eventnum))
	{
		if((i < _eventNoticeInfos.Length))
		{
			Class'NWindow.UIDataManager'.static.GetPopupEventData(_eventNoticeInfos[i].EventID, EventData);
			TextBoxHandle(eventWnds[i].GetChildWindow("EventNoticeText")).SetText(GetNpcString(EventData.TitleStringID));
			ButtonHandle(eventWnds[i].GetChildWindow("EventNotice_Btn")).SetTexture(EventData.HUDTexture, EventData.HUDPushTexture, EventData.HUDOverTexture);
			setWindowShow(eventWnds[i]);
			i++;
			continue;
		}
		SetWindowHide(eventWnds[i]);
		i++;
	}
	return;
}

function UpdateEventNoticeInfo(bool isOn, int EventID)
{
	local int i, foundIndex;
	local EventNoticeInfo eventInfo;

	foundIndex = -1;
	i = 0;
	while((i < _eventNoticeInfos.Length))
	{
		if((_eventNoticeInfos[i].EventID == EventID))
		{
			foundIndex = i;
			break;
		}
		i++;
	}
	if(isOn)
	{
		if((foundIndex == -1))
		{
			if((_eventNoticeInfos.Length < 3))
			{
				eventInfo.EventID = EventID;
				_eventNoticeInfos[_eventNoticeInfos.Length] = eventInfo;
			}
			else
			{
				Debug(("!!!! UpdateEventNoticeInfo 최대 겹치는 이벤트가 기획팀에서 예상한 수보다 넘어감 :" @ string(3)));  // EN?: !!!! UpdateEventNoticeInfo Max overlapping events exceeding the number expected by the planning team:
			}
		}
	}
	else if((foundIndex > -1))
	{
		_eventNoticeInfos.Remove(foundIndex, 1);
	}
	return;
}

function HandleOnClickFortressBtn()
{
	if(GetWindowHandle("FortressBattleInfoWnd").IsShowWindow())
	{
		GetWindowHandle("FortressBattleInfoWnd").HideWindow();
	}
	else
	{
		GetWindowHandle("FortressBattleInfoWnd").ShowWindow();
	}
	return;
}

function HandleTimeFortressRemain()
{
	if((FortressBattleRemainTime < 0))
	{
		FortressBattleNoticeWnd.KillTimer(4);
		SetWindowHide(FortressBattleNoticeWnd);
		return;
	}
	FortressBattleNoticeText.SetText(GetTimeStringMS(FortressBattleRemainTime));
	return;
}

function API_RequestMCWCastleSiegeInfo(int castleID)
{
	Class'NWindow.SiegeAPI'.static.RequestMCWCastleSiegeInfo(castleID);
	return;
}

function API_C_EX_WORLDCASTLEWAR_MOVE_TO_HOST()
{
	local UserInfo UserInfo;
	local array<byte> stream;
	local UIPacket._C_EX_WORLDCASTLEWAR_MOVE_TO_HOST packet;

	GetPlayerInfo(UserInfo);
	packet.nUserSID = UserInfo.nID;
	packet.nCastleID = 5;
	if(Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_WORLDCASTLEWAR_MOVE_TO_HOST(stream, packet))
	{
		Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(730, stream);
	}
	return;
}

function Rq_C_EX_TIME_RESTRICT_FIELD_USER_LEAVE()
{
	local array<byte> stream;

	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(594, stream);
	return;
}

function setWindowShow(WindowHandle tmpWnd)
{
	setWindowShowHide(tmpWnd, true);
	return;
}

function SetWindowHide(WindowHandle tmpWnd)
{
	setWindowShowHide(tmpWnd, false);
	return;
}

function ShowTimeZoneExitDialog()
{
	local string Desc;

	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("TimeZoneWnd"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("TimeZoneWnd");
	}
	Desc = GetSystemMessage(13704);
	Class'InterfaceClassic.UICommonAPI'.static.DialogSetID(2);
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, Desc);
	DialogMoveToCursor();
	return;
}

function bool IsTimeZoneUILabelType()
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		return true;
	}
	return false;
}

function HandleAllHide()
{
	local int i;

	i = 0;
	while((i < allWindow.Length))
	{
		SetWindowHide(allWindow[i]);
		i++;
	}
	return;
}

function setWindowShowHide(WindowHandle tmpWnd, optional bool isShow)
{
	local int nWndWidth, nWndHeight, i, nWndWMax, nMoveX;
	local Rect rectWnd;

	if((isShow == tmpWnd.IsShowWindow()))
	{
		return;
	}
	if(isShow)
	{
		tmpWnd.ShowWindow();
	}
	else
	{
		tmpWnd.HideWindow();
	}
	rectWnd = m_hOwnerWnd.GetRect();
	isShowInfoWnd = false;
	i = 0;
	while((i < allWindow.Length))
	{
		if(allWindow[i].IsShowWindow())
		{
			allWindow[i].GetWindowSize(nWndWidth, nWndHeight);
			allWindow[i].MoveTo((rectWnd.nX + nWndWMax), rectWnd.nY);
			nWndWMax = (nWndWMax + nWndWidth);
			isShowInfoWnd = true;
		}
		i++;
	}
	if((isShowInfoWnd && checkState()))
	{
		m_hOwnerWnd.ShowWindow();
	}
	else
	{
		m_hOwnerWnd.HideWindow();
	}
	nMoveX = ((2 + nWndWMax) - rectWnd.nWidth);
	m_hOwnerWnd.MoveTo((rectWnd.nX - nMoveX), rectWnd.nY);
	m_hOwnerWnd.SetWindowSize((2 + nWndWMax), rectWnd.nHeight);
	return;
}

function HandleStageChange()
{
	if(checkState())
	{
		if(isShowInfoWnd)
		{
			m_hOwnerWnd.ShowWindow();
		}
	}
	else
	{
		m_hOwnerWnd.HideWindow();
		if((GetGameStateName() != "COLLECTIONSTATE"))
		{
			KillAllTimer();
		}
	}
	return;
}

function bool checkState()
{
	return (GetGameStateName() == "GAMINGSTATE");
}

function string MakeMin(int Sec)
{
	if(((int(GetLanguage()) == 1) && ((Sec / 60) > 1)))
	{
		return (string((Sec / 60)) $ " Min");
	}
	return MakeFullSystemMsg(GetSystemMessage(3390), string((Sec / 60)));
}

function string GetTimeStringMS(int Second)
{
	local int Min, Sec;

	Min = (Second / 60);
	Sec = int((float(Second) % 60.0000000));
	return ((Int2Str(Min) $ ":") $ Int2Str(Sec));
}

function string Int2Str(int Num)
{
	if((Num < 10))
	{
		return ("0" $ string(Num));
	}
	return string(Num);
}

function string GetEllipsisString(string Str, int MaxWidth)
{
	local string fixedString;
	local int nWidth, nHeight, textWidth;

	textWidth = MaxWidth;
	GetTextSizeDefault((Str $ "..."), nWidth, nHeight);
	if((nWidth < textWidth))
	{
		return Str;
	}
	fixedString = DivideStringWithWidth(Str, textWidth);
	if((fixedString != Str))
	{
		fixedString = (fixedString $ "...");
	}
	return fixedString;
}

function Color GetColor(int R, int G, int B, int A)
{
	local Color tColor;

	tColor.R = byte(R);
	tColor.G = byte(G);
	tColor.B = byte(B);
	tColor.A = byte(A);
	return tColor;
}

function setWindowOrder()
{
	allWindow[allWindow.Length] = OlympiadNoticeWnd;
	allWindow[allWindow.Length] = TimeZoneNoticeWnd;
	allWindow[allWindow.Length] = siegeNoticeWnd;
	allWindow[allWindow.Length] = FortressBattleNoticeWnd;
	allWindow[allWindow.Length] = DethroneNoticeWnd;
	allWindow[allWindow.Length] = worldsiegeNoticeWnd;
	allWindow[allWindow.Length] = BalrogNoticeWnd;
	allWindow[allWindow.Length] = SkyTowerNoticeWnd;
	allWindow[allWindow.Length] = eventNoticeWnd;
	allWindow[allWindow.Length] = eventNotice2Wnd;
	allWindow[allWindow.Length] = eventNotice3Wnd;
	allWindow[allWindow.Length] = MatchingInzoneNoticeWnd;
	return;
}

defaultproperties
{
	m_OlympiadNoticeWndName="NoticeHUD.OlympiadNoticeWnd"
	m_TimeZoneNoticeWndName="NoticeHUD.TimeZoneNoticeWnd"
	m_SiegeNoticeWnd="NoticeHUD.SiegeNoticeWnd"
	m_FortressBattleNoticeWndName="NoticeHUD.FortressBattleNoticeWnd"
	m_WorldSiegeNoticeWnd="NoticeHUD.WorldSiegeNoticeWnd"
	m_DethroneNoticeWnd="NoticeHUD.DethroneNoticeWnd"
	m_BalrogNoticeWnd="NoticeHUD.BalrogNoticeWnd"
	m_SkyTowerNoticeWnd="NoticeHUD.SkyTowerNoticeWnd"
	m_EventNoticeWnd="NoticeHUD.EventNoticeWnd"
	m_EventNotice2Wnd="NoticeHUD.EventNotice2Wnd"
	m_EventNotice3Wnd="NoticeHUD.EventNotice3Wnd"
	m_MatchingInzoneNoticeWnd="NoticeHUD.MatchingInzoneNoticeWnd"
}
