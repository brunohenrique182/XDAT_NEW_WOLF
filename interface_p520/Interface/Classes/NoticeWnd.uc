class NoticeWnd extends L2UIGFxScript
	dependson(UIPacket);

const FLASH_XPOS = -7;
const FLASH_YPOS = -250;
const NOTICEBUTTON_DELETE = "900";
const NOTICEBUTTON_DELETEALL = "1000";
const LAYOUT_MULTILINE = "10001";
const LAYOUT_ONELINE = "10002";

enum ENoticeType
{
	TYPE_MAIL,                      // 0
	TYPE_QUEST,                     // 1
	TYPE_PREM,                      // 2
	TYPE_TUTORIAL,                  // 3
	TYPE_SKILL,                     // 4
	TYPE_CAMPAIGN,                  // 5
	TYPE_ZONE,                      // 6
	TYPE_AWAKENED,                  // 7
	TYPE_CURIOUSEHOUSE,             // 8
	TYPE_EVENTCAMPAIGN,             // 9
	TYPE_PLEDGEALARM,               // 10
	TYPE_WEBPETITIONALARM,          // 11
	TYPE_SINGLEMESHZONE,            // 12
	TYPE_PVPBLOCKCHECKER,           // 13
	TYPE_PVPCRATAECUBE,             // 14
	TYPE_PVPMATCHRECORD,            // 15
	TYPE_PVPCLEFT,                  // 16
	TYPE_PATHTOAWAKENINGALARM,      // 17
	TYPE_TODOLIST,                  // 18
	TYPE_LINEAGE2HOME,              // 19
	TYPE_KILLER,                    // 20
	TYPE_PCROOM,                    // 21
	TYPE_ATTENDANCESTAMP,           // 22
	TYPE_CHINATUTORIAL,             // 23
	TYPE_ABILITYPOINT,              // 24
	TYPE_MONSTERBOOK,               // 25
	TYPE_FACTION,                   // 26
	TYPE_AUCTION_FAIL,              // 27
	TYPE_EVENT_INFO,                // 28
	TYPE_NSHOPHOME,                 // 29
	TYPE_OLYMPIAD_OPENSEASON,       // 30
	TYPE_ADVENTURE_GUIDE,           // 31
	TYPE_CHANGE_CLASS,              // 32
	TYPE_TELEPORTMAP,               // 33
	TYPE_VITAMINMANAGER,            // 34
	TYPE_TIME_HUNTINGZONE,          // 35
	TYPE_RANKING,                   // 36
	TYPE_YETIMODE,                  // 37
	TYPE_REVENGEHELP,               // 38
	TYPE_LOSTPROPERTY,              // 39
	TYPE_COLLECTION,                // 40
	TYPE_DETHRONE,                  // 41
	TYPE_WORLDEXCHANGE_BUY,         // 42
	TYPE_GIFT,                      // 43
	TYPE_ATTENDCHECK,               // 44
	TYPE_HOLY_FIRE,                 // 45
	TYPE_SP_EXTRACT,                // 46
	TYPE_RAID_AUCTION               // 47
};

var int RecentlyAddedQuestID;
var int HtmlString;
var int zonetype;
var array<GFxValue> args;
var GFxValue invokeResult;
var WindowHandle Me;
var WindowHandle AlarmWnd;
var MagicSkillWnd MagicSkillWndScript;
var QuestTreeWnd QuestTreeWndScript;
var YetiPCModeChangeWnd YetiPCModeChangeWndScript;
var UserInfo currentUserInfo;
var TabHandle m_TabCtrl;
var bool bCam;
var bool bZone;
var bool bEvent;
var bool bCheckSPPoint;
var int nQuitRestrictField;
var bool bUseSingleMesh;
var int awakeClassID;
var int awakeImmediate;
var int currentScreenWidth;
var int currentScreenHeight;
var int PathToAwakeningAlarmType;
var int PathToAwakeningAlarmValue;
var int nUsePledgeV2Live;
var bool bChkAbilityPoint;
var bool isPrologueGrowTypeState;
var bool isGetPremium;
var bool isEnchantBlindState;
var ItemID collectionToFindiID;

function OnRegisterEvent()
{
	RegisterEvent(2900);
	RegisterEvent(40);
	RegisterEvent(9750);
	RegisterEvent(1530);
	RegisterEvent(4700);
	RegisterEvent(110);
	RegisterEvent(1520);
	RegisterEvent(3460);
	RegisterEvent(5603);
	RegisterEvent(1511);
	RegisterEvent(2059);
	RegisterEvent(5470);
	RegisterEvent(9630);
	RegisterEvent(5210);
	RegisterEvent(5250);
	RegisterEvent(5220);
	RegisterEvent(9310);
	RegisterEvent(9500);
	RegisterEvent(9540);
	RegisterEvent(9541);
	RegisterEvent(9452);
	RegisterEvent(10040);
	RegisterEvent(3890);
	RegisterEvent(3900);
	RegisterEvent(3740);
	RegisterEvent(3750);
	RegisterEvent(3500);
	RegisterEvent(3470);
	RegisterEvent(3501);
	RegisterEvent(3370);
	RegisterEvent(3410);
	RegisterEvent(720);
	RegisterEvent(20177);
	RegisterEvent(320);
	RegisterGFxEvent(10450);
	RegisterEvent(180);
	RegisterEvent(3053);
	RegisterEvent(10171);
	RegisterEvent(10140);
	RegisterEvent(20177);
	RegisterEvent(5312);
	RegisterEvent(11020);
	RegisterEvent(11070);
	RegisterEvent(110);
	RegisterEvent(11400);
	RegisterEvent((100000 + 925));
	RegisterEvent(11400);
	RegisterEvent(11510);
	RegisterEvent((100000 + 934));
	RegisterEvent((100000 + 956));
	RegisterEvent(EV_PacketID(1025));
	RegisterEvent(EV_PacketID(1046));
	RegisterEvent(EV_PacketID(1053));
	RegisterEvent(EV_PacketID(1103));
	RegisterEvent(EV_PacketID(1096));
	return;
}

function OnLoad()
{
	RegisterState("NoticeWnd", "GamingState");
	SetContainerHUD("none", 0);
	AddState("GAMINGSTATE");
	AddState("ARENAGAMINGSTATE");
	SetHavingFocus(false);
	SetDefaultShow(true);
	SetHUD();
	Me = GetWindowHandle("NoticeWnd");
	AlarmWnd = GetWindowHandle("PremiumItemAlarmWnd");
	MagicSkillWndScript = MagicSkillWnd(GetScript("MagicSkillWnd"));
	QuestTreeWndScript = QuestTreeWnd(GetScript("QuestTreeWnd"));
	YetiPCModeChangeWndScript = YetiPCModeChangeWnd(GetScript("YetiPCModeChangeWnd"));
	PathToAwakeningAlarmType = 0;
	PathToAwakeningAlarmValue = 0;
	return;
}

function OnShow()
{
	checkMultiLayOut();
	return;
}

function OnFlashLoaded()
{
	checkMultiLayOut();
	return;
}

function OnCallUCFunction(string functionName, string param)
{
	if((functionName == "updateButtonStateByCallUCFunction"))
	{
		updateButtonStateByCallUCFunction(param);
	}
	else
	{
		clickNoticeButton(functionName, param);
	}
	return;
}

function updateButtonStateByCallUCFunction(string param)
{
	local int layerMode, Count, h, V, hGap, vGap, X, Y, posX, posY;

	ParseInt(param, "layerMode", layerMode);
	ParseInt(param, "count", Count);
	ParseInt(param, "h", h);
	ParseInt(param, "v", V);
	ParseInt(param, "x", X);
	ParseInt(param, "y", Y);
	ParseInt(param, "hGap", hGap);
	ParseInt(param, "vGap", vGap);
	ParseInt(param, "posX", posX);
	ParseInt(param, "posY", posY);
	return;
}

function clickNoticeButton(string logicIDStr, string param)
{
	local string strParam;
	local int logicID;
	local CampaignAlarmWnd campaign;
	local ZoneQuestAlarmWnd Zone;
	local GfxDialog GfxDialogScript;
	local BR_CampaignAlarmWnd br_eventcampaign;
	local int tutorialID, tutorialType;

	logicID = int(logicIDStr);
	campaign = CampaignAlarmWnd(GetScript("CampaignAlarmWnd"));
	Zone = ZoneQuestAlarmWnd(GetScript("ZoneQuestAlarmWnd"));
	br_eventcampaign = BR_CampaignAlarmWnd(GetScript("BR_CampaignAlarmWnd"));
	if((logicID == 0))
	{
		PlayConsoleSound(IFST_WINDOW_OPEN);
		RequestRequestReceivedPostList();
	}
	else if((logicID == 1))
	{
		if((getInstanceUIData().IsAdenServer() || getInstanceUIData().GetIsLiveServer()))
		{
			Class'Interface.QuestWnd'.static.Inst()._ToggleShowByNotice();
			return;
		}
		ParamAdd(strParam, "QuestID", string(RecentlyAddedQuestID));
		ExecuteEvent(730, strParam);
	}
	else if((logicID == 2))
	{
		if((IsUseGoodsInvnentory() == false))
		{
			if(!AlarmWnd.IsShowWindow())
			{
				AlarmWnd.ShowWindow();
			}
		}
		else
		{
			HandleShowProductInventory();
		}
	}
	else if((logicID == 3))
	{
		ParseInt(param, "ID", tutorialID);
		ParseInt(param, "Type", tutorialType);
		if(Class'NWindow.UIDATA_PLAYER'.static.IsInPrison())
		{
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13773));
		}
		else
		{
			RequestTutorialMarkPressed(tutorialType, tutorialID);
		}
	}
	else if((logicID == 4))
	{
		MagicSkillWndScript.externalCallLearnSkill();
	}
	else if((logicID == 5))
	{
		bCam = false;
		campaign.RaderButtonClick();
	}
	else if((logicID == 6))
	{
		bZone = false;
		Zone.RaderButtonClick();
	}
	else if((logicID == 7))
	{
		ParamAdd(strParam, "Class", string(awakeClassID));
		GfxDialogScript = GfxDialog(GetScript("GfxDialog"));
		GfxDialogScript.showGfxDialog("dialogLinkageName", "AwakeNoticeDialog", strParam);
	}
	else if((logicID == 8))
	{
		RequestCuriousHouseHtml();
	}
	else if((logicID == 9))
	{
		bEvent = false;
		br_eventcampaign.RaderButtonClick();
	}
	else if((logicID == 10))
	{
		if(!Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("ClanSearch"))
		{
			Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("ClanSearch");
		}
	}
	else if((logicID == 11))
	{
		ExecuteEvent(9451);
		ResponsePetitionAlarm();
	}
	else if((logicID == 12))
	{
		bUseSingleMesh = !bUseSingleMesh;
		SwitchSingleMeshMode(bUseSingleMesh);
		if(bUseSingleMesh)
		{
			createNoticeButton(12, 3031);
		}
		else
		{
			createNoticeButton(12, 3030);
		}
	}
	else if((logicID == 13))
	{
		pvpButton(13);
	}
	else if((logicID == 14))
	{
		pvpButton(14);
	}
	else if((logicID == 15))
	{
		pvpButton(15);
	}
	else if((logicID == 17))
	{
		ParamAdd(strParam, "Type", string(PathToAwakeningAlarmType));
		ParamAdd(strParam, "Value", string(PathToAwakeningAlarmValue));
		ExecuteEvent(10010, strParam);
	}
	else if((logicID == 19))
	{
		showHideL2InGameWeb("main", "");
	}
	else if((logicID == 24))
	{
		showHideAbilityWnd();
	}
	else if((logicID == 25))
	{
		showhideMonsterBookWnd();
	}
	else if((logicID == 26))
	{
		showHideWindow("FactionWnd");
	}
	else if((logicID == 27))
	{
		handleAuctionFail();
	}
	else if((logicID == 18))
	{
		if(getInstanceUIData().GetIsLiveServer())
		{
			if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("ToDoListClanWnd"))
			{
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ToDoListClanWnd");
			}
			else
			{
				Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("ToDoListClanWnd");
			}
		}
		else if((getInstanceUIData().GetIsClassicServer() || getInstanceUIData().getIsArenaServer()))
		{
			ExecuteEvent(20160, "forceOpen=1");
		}
	}
	else if((logicID == 28))
	{
		showHideWindow("EventInfoWnd");
	}
	else if((logicID == 29))
	{
		showHideL2InGameWeb("nshop", "");
	}
	else if((logicID == 30))
	{
		if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("OlympiadWnd"))
		{
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow("OlympiadWnd");
		}
		else
		{
			RequestOlympiadRecord();
		}
	}
	else if((logicID == 32))
	{
		showHideWindow("JobChangeWnd");
		Debug("전직 버튼 클릭!!");  // EN: class change button clicked!!
	}
	else if((logicID == 33))
	{
		if(true)
		{
			showHideWindow("TeleportWnd");
		}
		else if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("TeleportMapWnd"))
		{
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow("TeleportMapWnd");
		}
		else
		{
			TeleportMapWnd(GetScript("TeleportMapWnd")).RQ_C_EX_Teleport_UI();
		}
		Debug("TYPE_TELEPORTMAP 버튼 클릭!!");  // EN: TYPE_TELEPORTMAP button clicked!!
	}
	else if((logicID == 34))
	{
		Debug("TYPE_VITAMINMANAGER버튼 클릭!!");  // EN: TYPE_VITAMINMANAGER button clicked!!
		RequestOpenWndWithoutNPC(OPEN_PREMIUM_MANAGER);
	}
	else if((logicID == 35))
	{
		Debug("TYPE_TIME_HUNTINGZONE 버튼 클릭!!");  // EN: TYPE_TIME_HUNTINGZONE button clicked!!
		if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("TimeZoneWnd"))
		{
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow("TimeZoneWnd");
		}
		else
		{
			Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("TimeZoneWnd");
		}
	}
	else if((logicID == 36))
	{
		if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("RankingWnd"))
		{
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow("RankingWnd");
		}
		else
		{
			Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("RankingWnd");
			Class'NWindow.UIAPI_WINDOW'.static.SetFocus("RankingWnd");
		}
	}
	else if((logicID == 37))
	{
		YetiPCModeChangeWndScript.setYetiMode(true);
	}
	else if((logicID == 20))
	{
		if((int(GetLanguage()) != 4))
		{
			Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("RevengeWnd");
		}
	}
	else if((logicID == 38))
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("RevengeWnd");
		GetTabHandle("RevengeWnd.RevengeTab").SetTopOrder(1, false);
	}
	else if((logicID == 39))
	{
		Debug("잃어 버린 아이템 복원! 창");  // EN?: Restore Lost Items! Window
		toggleWindow("RestoreLostPropertyWnd");
	}
	else if((logicID == 40))
	{
		collectionFindItem();
	}
	else if((logicID == 41))
	{
		Debug("Click TYPE_DETHRONE");
		DethroneWnd(GetScript("DethroneWnd")).gotoTabMission();
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("DethroneWnd");
		Class'NWindow.UIAPI_WINDOW'.static.SetFocus("DethroneWnd");
	}
	else if((logicID == 42))
	{
		ToggleWorldExchangeRegiWnd();
	}
	else if((logicID == 43))
	{
		if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("GiftInventoryWnd"))
		{
			GiftInventoryWnd(GetScript("GiftInventoryWnd")).refresh();
			Debug("선물 갱신");  // EN?: Renew gift
		}
		else
		{
			Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("GiftInventoryWnd");
			Class'NWindow.UIAPI_WINDOW'.static.SetFocus("GiftInventoryWnd");
			Debug("선물 창 열기");  // EN?: Open gift window
		}
	}
	else if((logicID == 44))
	{
		if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("AttendCheckWnd"))
		{
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow("AttendCheckWnd");
		}
		else
		{
			AttendCheckWnd(GetScript("AttendCheckWnd"))._Rq_C_EX_VIP_ATTENDANCE_LIST();
		}
	}
	else if((logicID == 45))
	{
		DethroneFireEnchantWnd(GetScript("DethroneFireEnchantWnd")).API_C_EX_HOLY_FIRE_OPEN_UI();
	}
	else if((logicID == 46))
	{
		Debug("sp extract");
		toggleWindow("SkillSpExtractWnd");
	}
	else if((logicID == 47))
	{
		toggleWindow("RaidAuctionRewardWnd");
	}
	return;
}

function ToggleWorldExchangeRegiWnd()
{
	Class'Interface.WorldExchangeRegiWnd'.static.Inst()._CheckOnClickNoticeBtn();
	return;
}

function collectionFindItem()
{
	local ItemInfo iInfo;
	local CollectionSystem collectionSystemScript;

	if(!Class'NWindow.UIDATA_INVENTORY'.static.FindItem(collectionToFindiID.ServerID, iInfo))
	{
		return;
	}
	collectionSystemScript = CollectionSystem(GetScript("CollectionSystem"));
	collectionSystemScript.SetToFindItemInfo(iInfo);
	collectionSystemScript.API_C_EX_COLLECTION_OPEN_UI();
	collectionToFindiID.ServerID = -1;
	collectionToFindiID.ClassID = -1;
	return;
}

function ChkCreateCollectionButton()
{
	local ItemEnchantWnd itemEnchantWndscr;
	local ItemMultiEnchantWnd itemMultiEnchantWndscr;

	if(CollectionSystem(GetScript("CollectionSystem"))._GetAlarmCheck())
	{
		return;
	}
	itemMultiEnchantWndscr = ItemMultiEnchantWnd(GetScript("ItemMultiEnchantwnd"));
	if((itemMultiEnchantWndscr.m_hOwnerWnd.IsShowWindow() && itemMultiEnchantWndscr.bUseLateAnnounce))
	{
		isEnchantBlindState = true;
		return;
	}
	itemEnchantWndscr = ItemEnchantWnd(GetScript("ItemEnchantWnd"));
	if((itemEnchantWndscr.m_hOwnerWnd.IsShowWindow() && (itemEnchantWndscr.GetStateName() == 'stateCompleteBlind')))
	{
		isEnchantBlindState = true;
		return;
	}
	createNoticeButton(40, 13490);
	return;
}

function _CreateCollectionButtonBlind()
{
	if(isEnchantBlindState)
	{
		isEnchantBlindState = false;
		createNoticeButton(40, 13490);
	}
	return;
}

function handleAuctionFail()
{
	local string strParam;
	local HelpHtmlWnd Script;

	Script = HelpHtmlWnd(GetScript("HelpHtmlWnd"));
	ParamAdd(strParam, "FilePath", (GetLocalizedL2TextPathNameUC() $ "item_auction_rule_info002.htm"));
	Script.HandleShowHelp(strParam);
	return;
}

function showhideMonsterBookWnd()
{
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("MonsterBookWnd"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("MonsterBookWnd");
	}
	else
	{
		CallGFxFunction("MonsterBookWnd", "clearSearchCondition", "");
		CallGFxFunction("MonsterBookWnd", "ChangefactionCategroy", "0");
	}
	return;
}

function showHideWindow(string WindowName)
{
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow(WindowName))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow(WindowName);
	}
	else
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(WindowName);
		Class'NWindow.UIAPI_WINDOW'.static.SetFocus(WindowName);
	}
	return;
}

function showHideAbilityWnd()
{
	showHideWindow("AbilityUIWnd");
	return;
}

function showHideL2InGameWeb(string Category, string Message)
{
	local string strParam;

	ParamAdd(strParam, "Category", Category);
	ParamAdd(strParam, "Message", "");
	ExecuteEvent(10120, strParam);
	return;
}

function HandleEV_ArriveShowQuest(string param)
{
	local int Level;
	local string strTargetName;
	local Vector vTargetPos;
	local bool bOnlyMinimap;
	local string strParam;

	if((getInstanceUIData().GetIsLiveServer() || IsAdenServer()))
	{
		return;
	}
	ParseInt(param, "QuestID", RecentlyAddedQuestID);
	ParseInt(param, "QuestLevel", Level);
	QuestAlarmWnd(GetScript("QuestAlarmWnd")).externalDelayTimerRequestAddExpandQuest(RecentlyAddedQuestID);
	GetPlayerInfo(currentUserInfo);
	if(((((RecentlyAddedQuestID == 10338) || ((currentUserInfo.nClassID <= 181) && (currentUserInfo.nClassID >= 148))) || (currentUserInfo.nClassID == 188)) || (currentUserInfo.nClassID == 189)))
	{
		ChangeToAwakenedArrived(false);
	}
	if(((RecentlyAddedQuestID > 0) && (Level > 0)))
	{
		strTargetName = Class'NWindow.UIDATA_QUEST'.static.GetTargetName(RecentlyAddedQuestID, Level);
		vTargetPos = Class'NWindow.UIDATA_QUEST'.static.GetTargetLoc(RecentlyAddedQuestID, Level);
		ParamAdd(strParam, "X", string(vTargetPos.X));
		ParamAdd(strParam, "Y", string(vTargetPos.Y));
		ParamAdd(strParam, "Z", string(vTargetPos.Z));
		ParamAdd(strParam, "targetName", strTargetName);
		ParamAdd(strParam, "QuestID", string(RecentlyAddedQuestID));
		ParamAdd(strParam, "QuestLevel", string(Level));
		ParamAdd(strParam, "questName", Class'NWindow.UIDATA_QUEST'.static.GetQuestName(RecentlyAddedQuestID, Level));
		CallGFxFunction("RadarMapWnd", "showQuestTargetInfo", strParam);
		bOnlyMinimap = Class'NWindow.UIDATA_QUEST'.static.IsMinimapOnly(RecentlyAddedQuestID, Level);
		QuestTreeWndScript.curQuestExpand(RecentlyAddedQuestID);
		if(bOnlyMinimap)
		{
			if(!IsPlayerOnWorldRaidServer())
			{
				Class'NWindow.QuestAPI'.static.SetQuestTargetInfo(true, false, false, strTargetName, vTargetPos, RecentlyAddedQuestID, Level);
			}
		}
		else if(!IsPlayerOnWorldRaidServer())
		{
			Class'NWindow.QuestAPI'.static.SetQuestTargetInfo(true, true, true, strTargetName, vTargetPos, RecentlyAddedQuestID, Level);
		}
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	local int iEffectNumber, statusInt;
	local string strParam;
	local int nRewardCount, isNewMissionLevelReward;
	local GfxDialog GfxDialogScript;
	local int UserType, clanID;

	if((Event_ID == 1530))
	{
	}
	else if((Event_ID == 4700))
	{
		ParseInt(param, "IdxMail", iEffectNumber);
		createNoticeButton(0, 2074);
	}
	else if((Event_ID == 9630))
	{
		createNoticeButton(10, 3068);
	}
	else if((Event_ID == 720))
	{
		QuestTreeWndScript.findNowQuestExist(RecentlyAddedQuestID);
	}
	else if((Event_ID == 1520))
	{
		ArriveShowQuest();
		HandleEV_ArriveShowQuest(param);
	}
	else if(((Event_ID == 3460) || (Event_ID == 5603)))
	{
		PremiumItemAlarm();
	}
	else if((Event_ID == 1511))
	{
		ArriveNewTutorialQuestion(param);
	}
	else if((Event_ID == 2059))
	{
		SkillLearningNewArrival();
	}
	else if((Event_ID == 5210))
	{
		bCam = true;
		CampaignArrived();
	}
	else if((Event_ID == 5250))
	{
		ClearCampaignBtn();
	}
	else if((Event_ID == 5220))
	{
		bZone = true;
		ZoneQuestArrived();
	}
	else if((Event_ID == 9500))
	{
		bEvent = true;
		EventCampaignArrived();
	}
	else if((Event_ID == 5470))
	{
		ParseInt(param, "Class", awakeClassID);
		ParseInt(param, "Immediate", awakeImmediate);
		ParseInt(param, "UserType", UserType);
		if((UserType == 0))
		{
			strParam = "";
			ParamAdd(strParam, "Class", string(awakeClassID));
			GfxDialogScript = GfxDialog(GetScript("GfxDialog"));
			GfxDialogScript.showGfxDialog("dialogLinkageName", "DualPayDialogStep1", strParam);
		}
		else if((awakeClassID <= 0))
		{
		}
		else if((awakeImmediate == 1))
		{
			strParam = "";
			ParamAdd(strParam, "Class", string(awakeClassID));
			ParamAdd(strParam, "Immediate", string(awakeImmediate));
			GfxDialogScript = GfxDialog(GetScript("GfxDialog"));
			GfxDialogScript.showGfxDialog("dialogLinkageName", "AwakeNoticeDialog", strParam);
		}
		else
		{
			ChangeToAwakenedArrived(true);
		}
	}
	else if((Event_ID == 40))
	{
		ParseInt(param, "QuitRestrictField", nQuitRestrictField);
		isGetPremium = false;
		isPrologueGrowTypeState = false;
		bChkAbilityPoint = false;
		if((nQuitRestrictField == 0))
		{
			bCheckSPPoint = false;
		}
		removeALLNoticeButton();
	}
	else if((Event_ID == 9750))
	{
	}
	else if((Event_ID == 2900))
	{
		checkMultiLayOut();
	}
	else if((Event_ID == 9310))
	{
		CuriousHouseHandle(param);
	}
	else if((Event_ID == 9452))
	{
		WebPetitionReplyAlarm();
	}
	else if((Event_ID == 9540))
	{
		bUseSingleMesh = true;
		if(bUseSingleMesh)
		{
			createNoticeButton(12, 3031);
		}
		else
		{
			createNoticeButton(12, 3030);
		}
	}
	else if((Event_ID == 9541))
	{
		bUseSingleMesh = false;
		removeNoticeButton(12);
	}
	else if(((Event_ID == 3890) || (Event_ID == 3900)))
	{
		createNoticeButton(13, 2445);
	}
	else if((Event_ID == 3500))
	{
		createNoticeButton(14, 2444);
	}
	else if((Event_ID == 3470))
	{
		ParseInt(param, "Status", statusInt);
		if((statusInt == 0))
		{
			createNoticeButton(14, 2444);
		}
		else if((statusInt == 2))
		{
			removeNoticeButton(14);
		}
	}
	else if((Event_ID == 3501))
	{
		removeNoticeButton(14);
	}
	else if((Event_ID == 3370))
	{
		ParseInt(param, "CurrentState", statusInt);
		if((statusInt == 0))
		{
			createNoticeButton(15, 2442);
		}
		else if((statusInt == 2))
		{
			removeNoticeButton(15);
		}
	}
	else if(((Event_ID == 3740) || (Event_ID == 3750)))
	{
		createNoticeButton(16, 2443);
	}
	else if((Event_ID == 10040))
	{
		ParseInt(param, "Type", PathToAwakeningAlarmType);
		ParseInt(param, "Value", PathToAwakeningAlarmValue);
		createNoticeButton(17, 5178);
	}
	else if((Event_ID == 320))
	{
		ParseInt(param, "ClanID", clanID);
		if((clanID > 0))
		{
			removeNoticeButton(10);
		}
	}
	else if((Event_ID == 180))
	{
		chkAbilityPoint();
		if(IsAdenServer())
		{
			chkSpPoint();
		}
		ParseInt(param, "ClanID", clanID);
		if((clanID > 0))
		{
			removeNoticeButton(10);
		}
	}
	else if((Event_ID == 3053))
	{
		createNoticeButton(27, 3500);
	}
	else if((Event_ID == 10171))
	{
		createNoticeButton(26, 3443);
	}
	else if((Event_ID == 10160))
	{
		createNoticeButton(25, 3511);
	}
	else if((Event_ID == 20177))
	{
		ParseInt(param, "rewardCount", nRewardCount);
		ParseInt(param, "isNewMissionLevelReward", isNewMissionLevelReward);
		if((nRewardCount > 0))
		{
			createNoticeButtonWithParam(18, 3506, param);
			if((isNewMissionLevelReward > 0))
			{
				ToDoListWnd(GetScript("ToDoListWnd")).RequestMissionLevelRewardList();
			}
		}
		else
		{
			removeNoticeButton(18);
		}
	}
	else if((Event_ID == 10140))
	{
		if(getInstanceL2Util().isClanV2())
		{
			removeNoticeButton(18);
		}
	}
	else if((Event_ID == 11020))
	{
		HandleOlympiadEvent(param);
	}
	else if((Event_ID == 5312))
	{
		handleChangedSubjob(param);
	}
	else if((Event_ID == 3410))
	{
		if(((param == "GAMINGSTATE") || (param == "ARENAGAMINGSTATE")))
		{
			isPrologueGrowTypeState = getInstanceL2Util().getIsPrologueGrowType();
			if(bUseL2Button())
			{
			}
		}
	}
	else if((Event_ID == 11070))
	{
		createNoticeButton(32, 1795);
	}
	else if(((Event_ID == 11230) || (Event_ID == 11240)))
	{
		createNoticeButton(35, 13025);
	}
	else if((Event_ID == (100000 + 925)))
	{
		S_EX_PVPBOOK_SHARE_REVENGE_NEW_REVENGEINFO();
	}
	else if((Event_ID == (100000 + 934)))
	{
		ParsePacket_S_EX_PENALTY_ITEM_INFO();
	}
	else if((Event_ID == 11510))
	{
		ParseInt(param, "classID", collectionToFindiID.ClassID);
		ParseInt(param, "ServerID", collectionToFindiID.ServerID);
		ChkCreateCollectionButton();
	}
	else if((Event_ID == EV_PacketID(1025)))
	{
		RT_S_EX_WORLD_EXCHANGE_SELL_COMPLETE_ALARM();
	}
	else if((Event_ID == EV_PacketID(1046)))
	{
		RT_S_EX_WORLD_EXCHANGE_SETTLE_ALARM();
	}
	else if((Event_ID == (100000 + 956)))
	{
		ParsePacket_S_EX_DETHRONE_DAILY_MISSION_COMPLETE();
	}
	else if((Event_ID == EV_PacketID(1053)))
	{
		Debug("-> 선물 수신 동의 알람 S_EX_GOODS_GIFT_CHANGED_NOTI");  // EN?: - > Gift opt-in alarm S_EX_goods_gift_changed_noti
		createNoticeButton(43, 14201);
	}
	else if((Event_ID == EV_PacketID(1103)))
	{
		Nt_S_EX_VIP_ATTENDANCE_NOTIFY();
	}
	else if((Event_ID == EV_PacketID(1096)))
	{
		ParsePacket_S_EX_HOLY_FIRE_NOTIFY();
	}
	return;
}

function ParsePacket_S_EX_HOLY_FIRE_NOTIFY()
{
	local UIPacket._S_EX_HOLY_FIRE_NOTIFY packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_HOLY_FIRE_NOTIFY(packet))
	{
		return;
	}
	Debug(("UIPacket._S_EX_HOLY_FIRE_NOTIFY packet.cState" @ string(packet.cState)));
	switch(packet.cState)
	{
		case 0:
		case 2:
		case 3:
			createNoticeButton(45, 14329);
			break;
		default:
			break;
	}
	return;
}

function Nt_S_EX_VIP_ATTENDANCE_NOTIFY()
{
	createNoticeButton(44, 5190);
	return;
}

function RemoveAttendCheckNotice()
{
	removeNoticeButton(44);
	return;
}

function RT_S_EX_WORLD_EXCHANGE_SELL_COMPLETE_ALARM()
{
	local UIPacket._S_EX_WORLD_EXCHANGE_SELL_COMPLETE_ALARM packet;
	local string param;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_WORLD_EXCHANGE_SELL_COMPLETE_ALARM(packet))
	{
		return;
	}
	if(Class'Interface.WorldExchangeRegiWnd'.static.Inst().m_hOwnerWnd.IsShowWindow())
	{
		Class'Interface.WorldExchangeRegiWnd'.static.Inst().HandleCancelCancel();
		Class'Interface.WorldExchangeRegiWnd'.static.Inst().historyScr.HandleRefresh();
	}
	ParamAdd(param, "rewardCount", string(Class'Interface.WorldExchangeRegiWnd'.static.Inst().historyScr.receivedNum));
	_CreateWorldExchangeBuyNotice(param);
	Debug(("RT_S_EX_WORLD_EXCHANGE_SELL_COMPLETE_ALARM" @ param));
	return;
}

function RT_S_EX_WORLD_EXCHANGE_SETTLE_ALARM()
{
	local UIPacket._S_EX_WORLD_EXCHANGE_SETTLE_ALARM packet;
	local string param;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_WORLD_EXCHANGE_SETTLE_ALARM(packet))
	{
		return;
	}
	if(Class'Interface.WorldExchangeRegiWnd'.static.Inst().m_hOwnerWnd.IsShowWindow())
	{
		Class'Interface.WorldExchangeRegiWnd'.static.Inst().HandleCancelCancel();
		Class'Interface.WorldExchangeRegiWnd'.static.Inst().historyScr.HandleRefresh();
	}
	param = "";
	ParamAdd(param, "rewardCount", string(packet.nCount));
	_CreateWorldExchangeBuyNotice(param);
	return;
}

function _CreateWorldExchangeBuyNotice(optional string param)
{
	createNoticeButtonWithParam(42, 14063, param);
	return;
}

function _RemoveNoticButtonWorldExchangeBuy()
{
	removeNoticeButton(42);
	return;
}

function _RemoveNoticButtonGift()
{
	removeNoticeButton(43);
	return;
}

function _RemoveNoticButtonProductInventory()
{
	removeNoticeButton(2);
	return;
}

function ParsePacket_S_EX_DETHRONE_DAILY_MISSION_COMPLETE()
{
	local UIPacket._S_EX_DETHRONE_DAILY_MISSION_COMPLETE packet;
	local string param;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_DETHRONE_DAILY_MISSION_COMPLETE(packet))
	{
		return;
	}
	Debug((" -->  Decode_S_EX_DETHRONE_DAILY_MISSION_COMPLETE : " @ string(packet.nCompleteMissionCount)));
	ParamAdd(param, "rewardCount", string(packet.nCompleteMissionCount));
	if((packet.nCompleteMissionCount > 0))
	{
		createNoticeButtonWithParam(41, 13733, param);
	}
	else
	{
		removeNoticeButton(41);
	}
	return;
}

function removeNoticeDethroneMissionNotice()
{
	removeNoticeButton(41);
	return;
}

function ParsePacket_S_EX_PENALTY_ITEM_INFO()
{
	local UIPacket._S_EX_PENALTY_ITEM_INFO packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_PENALTY_ITEM_INFO(packet))
	{
		return;
	}
	LostPropertyArrived(packet.nCount);
	return;
}

function S_EX_PVPBOOK_SHARE_REVENGE_NEW_REVENGEINFO()
{
	local UIPacket._S_EX_PVPBOOK_SHARE_REVENGE_NEW_REVENGEINFO packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_PVPBOOK_SHARE_REVENGE_NEW_REVENGEINFO(packet))
	{
		return;
	}
	if((packet.nShareType != 1))
	{
		RevengeHelpArrived();
	}
	if(((packet.nShareType != 2) && (packet.nShareType != 4)))
	{
		createNoticeButton(20, 0, MakeFullSystemMsg(GetSystemMessage(13049), packet.sKillUserName));
	}
	return;
}

function chkAbilityPoint()
{
	local UserInfo UserInfo;

	GetPlayerInfo(UserInfo);
	if(getInstanceUIData().IsLevelUP())
	{
		bChkAbilityPoint = true;
	}
	if(bChkAbilityPoint)
	{
		if((UserInfo.nRemainAbilityPoint > 0))
		{
			createNoticeButton(24, 3151);
			bChkAbilityPoint = false;
		}
	}
	return;
}

function chkSpPoint()
{
	local UserInfo UserInfo;

	GetPlayerInfo(UserInfo);
	if((UserInfo.nSP >= GetMaximumSkillPoint()))
	{
		if((bCheckSPPoint == false))
		{
			createNoticeButton(46, 14804);
			bCheckSPPoint = true;
		}
	}
	else
	{
		if(bCheckSPPoint)
		{
			removeNoticeButton(46);
		}
		bCheckSPPoint = false;
	}
	return;
}

function bool isChinaVer()
{
	local UIEventManager.ELanguageType Language;
	local bool flag;

	Language = GetLanguage();
	if((int(Language) == 4))
	{
		flag = true;
	}
	return flag;
}

function bool bUseL2Button()
{
	local UIEventManager.ELanguageType Language;
	local bool flag;

	Language = GetLanguage();
	if(((int(Language) == 0) && !getInstanceUIData().getIsArenaServer()))
	{
		flag = true;
	}
	return flag;
}

function toggleWindow(string WindowName)
{
	if(!GetWindowHandle(WindowName).IsShowWindow())
	{
		GetWindowHandle(WindowName).ShowWindow();
		GetWindowHandle(WindowName).SetFocus();
	}
	else
	{
		GetWindowHandle(WindowName).HideWindow();
	}
	return;
}

function pvpButton(int SelectPVP)
{
	if((SelectPVP == 13))
	{
		toggleWindow("BlockCurWnd");
	}
	else if((SelectPVP == 14))
	{
		if(!GetWindowHandle("KillPointRankWnd").IsShowWindow())
		{
			RequestStartShowCrataeCubeRank();
		}
		toggleWindow("KillPointRankWnd");
	}
	else if((SelectPVP == 15))
	{
		toggleWindow("PVPDetailedWnd");
	}
	else if((SelectPVP == 16))
	{
		toggleWindow("CleftCurWnd");
	}
	return;
}

function CuriousHouseHandle(string param)
{
	local int HouseState;

	ParseInt(param, "State", HouseState);
	switch(HouseState)
	{
		case 1:
			createNoticeButton(8, 2804);
			break;
		case 0:
		case 2:
		case 3:
			removeNoticeButton(8);
			break;
		default:
			break;
	}
	return;
}

function PledgeAlarm()
{
	createNoticeButton(10, 3068);
	return;
}

function WebPetitionReplyAlarm()
{
	createNoticeButton(11, 3109);
	return;
}

function HandleOlympiadEvent(string param)
{
	local int nOlympiadOpenSeason;

	if(getInstanceUIData().GetIsClassicServer())
	{
		NoticeHUD(GetScript("NoticeHUD")).HandleOlympiadNotice(param);
	}
	else
	{
		ParseInt(param, "Open", nOlympiadOpenSeason);
		if((nOlympiadOpenSeason > 0))
		{
			createNoticeButtonWithParam(30, 3845, param);
		}
		else
		{
			removeNoticeButton(30);
		}
	}
	return;
}

function Notice_Post_Arrived()
{
	createNoticeButton(0, 2074);
	return;
}

function ArriveShowQuest()
{
	if((!getInstanceUIData().GetIsClassicServer() || IsAdenServer()))
	{
		createNoticeButton(1, 118);
	}
	else
	{
		createNoticeButton(1, 14405);
	}
	return;
}

function PremiumItemAlarm()
{
	if((IsUseGoodsInvnentory() == false))
	{
		createNoticeButton(2, 1738);
		AddSystemMessage(2313);
	}
	else
	{
		createNoticeButton(2, 2680);
	}
	return;
}

function SkillLearningNewArrival()
{
	createNoticeButton(4, 2369);
	return;
}

function CampaignArrived()
{
	createNoticeButton(5, 2440);
	return;
}

function ZoneQuestArrived()
{
	createNoticeButton(6, 2441);
	return;
}

function RevengeHelpArrived()
{
	createNoticeButton(38, 13502);
	return;
}

function LostPropertyArrived(int nCount)
{
	local string param;

	ParamAdd(param, "rewardCount", string(nCount));
	if((nCount > 0))
	{
		createNoticeButtonWithParam(39, 13526, param);
	}
	else
	{
		removeNoticeButton(39);
	}
	return;
}

function EventCampaignArrived()
{
	createNoticeButton(9, 5143);
	return;
}

function EventInfoArrived()
{
	local SideBar SideBarScript;

	if((int(GetLanguage()) == 0))
	{
		if(getInstanceUIData().GetIsClassicServer())
		{
			return;
		}
		SideBarScript = SideBar(GetScript("SideBar"));
		SideBarScript.SetWindowShowHideByIndex(16, true);
	}
	return;
}

function hideNoticeButton_EventInfo()
{
	removeNoticeButton(28);
	return;
}

function ClearCampaignBtn()
{
	if((bCam == true))
	{
		removeNoticeButton(5);
		bCam = false;
	}
	return;
}

function ClearZoneQuestBtn()
{
	if((bZone == true))
	{
		removeNoticeButton(6);
		bZone = false;
	}
	return;
}

function PathToAwakeningAlarm()
{
	AllocGFxValues(args, 2);
	AllocGFxValue(invokeResult);
	args[0].SetInt(17);
	CreateObject(args[1]);
	args[1].SetMemberInt("toolTipNum", 5178);
	Invoke("_root.onEvent", args, invokeResult);
	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);
	return;
}

function ClearBRCampaignBtn()
{
	if((bEvent == true))
	{
		removeNoticeButton(9);
		bEvent = false;
	}
	return;
}

function ChangeToAwakenedArrived(bool bOnOff)
{
	if(bOnOff)
	{
		createNoticeButton(7, 2491);
	}
	else
	{
		removeNoticeButton(7);
	}
	return;
}

function HandleShowProductInventory()
{
	local WindowHandle win;

	win = GetWindowHandle("ProductInventoryWnd");
	if(!win.IsShowWindow())
	{
		win.ShowWindow();
		win.SetFocus();
	}
	else
	{
		ProductInventoryWnd(GetScript("ProductInventoryWnd")).refresh();
	}
	return;
}

function SetShowWindow()
{
	local bool bStateCheck;

	bStateCheck = (GetGameStateName() == "GAMINGSTATE");
	bStateCheck = (bStateCheck || (GetGameStateName() == "ARENAGAMINGSTATE"));
	if(((IsShowWindow() == false) && bStateCheck))
	{
		ShowWindow();
	}
	return;
}

function OnEnterState(name a_CurrentStateName)
{
	SetShowWindow();
	return;
}

function checkMultiLayOut()
{
	local string param;

	SetAnchor("", ANCHORPOINT_BottomRight, ANCHORPOINT_TopLeft, 0, 0);
	ParamAdd(param, "w", "-46");
	ParamAdd(param, "h", "-140");
	CallGFxFunction("noticeWnd", "10002", param);
	return;
}

function ArriveNewTutorialQuestion(string param)
{
	local int toolTipNum;

	ParseInt(param, "toolTipNum", toolTipNum);
	if((toolTipNum <= 0))
	{
		toolTipNum = 448;
	}
	createNoticeButtonWithParam(3, toolTipNum, param);
	return;
}

function createNoticeButton(int nType, int nTooltipString, optional string forceTooltipString)
{
	local string paramStr;

	if(checkIisPrologueGrowType(nType))
	{
		return;
	}
	if(((getInstanceL2Util().isClanV2() && IsPlayerOnWorldRaidServer()) && (nType == 18)))
	{
		return;
	}
	ParamAdd(paramStr, "toolTipNum", string(nTooltipString));
	if((forceTooltipString != ""))
	{
		paramStr = "";
		ParamAdd(paramStr, "toolTipString", forceTooltipString);
	}
	CallGFxFunction("noticeWnd", string(nType), paramStr);
	return;
}

function createNoticeButtonWithParam(int nType, int nTooltipString, string paramStr)
{
	if(checkIisPrologueGrowType(nType))
	{
		return;
	}
	if(((getInstanceL2Util().isClanV2() && IsPlayerOnWorldRaidServer()) && (nType == 18)))
	{
		return;
	}
	ParamAdd(paramStr, "toolTipNum", string(nTooltipString));
	CallGFxFunction("noticeWnd", string(nType), paramStr);
	return;
}

function removeNoticeButton(int nType)
{
	local string paramStr;

	if(IsShowWindow())
	{
		ParamAdd(paramStr, "type", string(nType));
		CallGFxFunction("noticeWnd", "900", paramStr);
	}
	return;
}

function removeALLNoticeButton()
{
	if(IsShowWindow())
	{
		CallGFxFunction("noticeWnd", "1000", "");
	}
	return;
}

function hideNoticeButton_QUEST()
{
	removeNoticeButton(1);
	return;
}

function hideNoticeButton_PVPBLOCKCHECKER()
{
	removeNoticeButton(13);
	return;
}

function hideNoticeButton_PVPCRATAECUBE()
{
	removeNoticeButton(14);
	return;
}

function hideNoticeButton_PVPMATCHRECORD()
{
	removeNoticeButton(15);
	return;
}

function hideNoticeButton_PVPCLEFT()
{
	removeNoticeButton(16);
	return;
}

function hideNoticeButton_CAMPAIGN()
{
	removeNoticeButton(5);
	return;
}

function hideNoticeButton_ZONE()
{
	removeNoticeButton(6);
	return;
}

function _ShowRaidAuction()
{
	createNoticeButton(47, 3142);
	return;
}

function handleChangedSubjob(string param)
{
	local bool tmpIsPrologueGrowTypeState;
	local UserInfo Info;

	tmpIsPrologueGrowTypeState = getisPrologueGrowTypeState(param);
	if((tmpIsPrologueGrowTypeState != isPrologueGrowTypeState))
	{
		isPrologueGrowTypeState = tmpIsPrologueGrowTypeState;
		if(!isPrologueGrowTypeState)
		{
			if(EventInfoWnd(GetScript("EventInfoWnd")).hasNoticeIcon)
			{
				EventInfoArrived();
			}
			if(GetPlayerInfo(Info))
			{
				if((Info.nClanID <= 0))
				{
					createNoticeButton(10, 3068);
				}
			}
			if(isGetPremium)
			{
				PremiumItemAlarm();
			}
		}
	}
	return;
}

function bool getisPrologueGrowTypeState(string param)
{
	local int currentClassID;

	if((param != ""))
	{
		ParseInt(param, "CurrentSubjobClassID", currentClassID);
	}
	return getInstanceL2Util().getIsPrologueGrowType(currentClassID);
}

function bool checkIisPrologueGrowType(int nType)
{
	if(isPrologueGrowTypeState)
	{
		switch(nType)
		{
			case 2:
				isGetPremium = true;
			case 3:
			case 10:
			case 28:
			case 29:
				return true;
			default:
				break;
		}
	}
	return false;
}
