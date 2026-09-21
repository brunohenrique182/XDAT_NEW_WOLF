class UIEventManager extends Interactions;

enum easeType
{
	IN_STRONG,                      // 0
	OUT_STRONG,                     // 1
	INOUT_STRONG,                   // 2
	IN_BOUNCE,                      // 3
	OUT_BOUNCE,                     // 4
	INOUT_BOUNCE,                   // 5
	IN_ELASTIC,                     // 6
	OUT_ELASTIC,                    // 7
	INOUT_ELASTIC,                  // 8
	EASENONE                        // 9
};

const MAX_PartyMemberCount = 9;
const CREATE_ON_DEMAND = 1;
const EQUIPMENT_BREAK = -1;
const EV_UI_Internal_Event = 5;
const EV_Test = 10;
const EV_Test_1 = 11;
const EV_Test_2 = 12;
const EV_Test_3 = 13;
const EV_Test_4 = 14;
const EV_Test_5 = 15;
const EV_Test_6 = 16;
const EV_Test_7 = 17;
const EV_Test_8 = 18;
const EV_Test_9 = 19;
const EV_Paste = 20;
const EV_Restart = 40;
const EV_Die = 50;
const EV_CardKeyLogin = 60;
const EV_RegenStatus = 70;
const EV_RadarTransitionFinished = 80;
const EV_ShortcutCommand = 90;
const EV_ShortcutCommandSlot = 91;
const EV_MagicSkillList = 100;
const EV_SetRadarZoneCode = 110;
const EV_RaidRecord = 120;
const EV_ShowGuideWnd = 130;
const EV_ShowScreenMessage = 140;
const EV_ShowScreenNPCZoomMessage = 141;
const EV_GamingStateEnter = 150;
const EV_GamingStateExit = 160;
const EV_GamingStatePreExit = 161;
const EV_ServerAgeLimitChange = 170;
const EV_UpdateUserInfo = 180;
const EV_UpdateUserEquipSlotInfo = 181;
const EV_PreUpdateUserInfo = 182;
const EV_UpdateHP = 190;
const EV_UpdateMyHP = 191;
const EV_UpdateMaxHP = 200;
const EV_UpdateMyMaxHP = 201;
const EV_UpdateMP = 210;
const EV_UpdateMyMP = 211;
const EV_UpdateMaxMP = 220;
const EV_UpdateMyMaxMP = 221;
const EV_UpdateCP = 230;
const EV_UpdateMyCP = 231;
const EV_UpdateMaxCP = 240;
const EV_UpdateMyMaxCP = 241;
const EV_UpdateMyDP = 245;
const EV_UpdateMyMaxDP = 246;
const EV_UpdateMyBP = 247;
const EV_UpdateMyMaxBP = 248;
const EV_UpdatePetInfo = 250;
const EV_UpdateSummonInfo = 251;
const EV_UpdateHennaInfo = 260;
const EV_ReceiveAttack = 280;
const EV_ReceiveMagicSkillUse = 290;
const EV_ReceiveTargetLevelDiff = 300;
const EV_ShowReplayQuitDialogBox = 310;
const EV_ClanInfo = 320;
const EV_ClanInfoUpdate = 330;
const EV_ClanMyAuth = 340;
const EV_ClanAuthGradeList = 350;
const EV_ClanCrestChange = 360;
const EV_ClanAuth = 370;
const EV_ClanAuthMember = 380;
const EV_ClanAddMember = 400;
const EV_ClanAddMemberMultiple = 410;
const EV_ClanDeleteAllMember = 420;
const EV_ClanMemberInfo = 430;
const EV_ClanMemberInfoUpdate = 440;
const EV_ClanDeleteMember = 450;
const EV_ClanWarList = 460;
const EV_ClanClearWarList = 470;
const EV_ClanSubClanUpdated = 480;
const EV_ClanSkillList = 490;
const EV_ClanSkillListRenew = 500;
const EV_MinFrameRateChanged = 510;
const EV_PartyMemberChanged = 520;
const EV_ShowPCCafeCouponUI = 530;
const EV_ToggleShowPCCafeEventWnd = 531;
const EV_ChatMessage = 540;
const EV_ReceiveChatMessage = 541;
const EV_GFxScrMessage = 542;
const EV_ChatWndStatusChange = 550;
const EV_ChatWndOnResize = 555;
const EV_ChatWndSetString = 560;
const EV_ChatWndSetFocus = 570;
const EV_ChatWndMsnStatus = 571;
const EV_ChatWndMacroCommand = 572;
const EV_SystemMessage = 580;
const EV_MessageWndString = 581;
const EV_JoypadLButtonDown = 590;
const EV_JoypadLButtonUp = 600;
const EV_JoypadRButtonDown = 610;
const EV_JoypadRButtonUp = 620;
const EV_ShortcutUpdate = 630;
const EV_ShortcutSkillListUpdate = 631;
const EV_ShortcutActionListUpdate = 632;
const EV_ShortcutPageUpdate = 640;
const EV_ShortcutClear = 650;
const EV_ShortcutJoypad = 660;
const EV_ShortcutPageDown = 670;
const EV_ShortcutPageUp = 680;
const EV_ShowShortcutWnd = 690;
const EV_ShortcutInit = 691;
const EV_ShortcutDataReceived = 692;
const EV_ShortcutKeyAssignChanged = 693;
const EV_ShortcutAutomaticUseActivated = 694;
const EV_QuestListStart = 700;
const EV_QuestList = 710;
const EV_QuestListEnd = 720;
const EV_QuestSetCurrentID = 730;
const EV_SSQStatus = 740;
const EV_SSQMainEvent = 750;
const EV_SSQSealStatus = 760;
const EV_SSQPreInfo = 770;
const EV_RecipeShowBuyListWnd = 780;
const EV_RecipeShopSellItem = 790;
const EV_RecipeShopItemInfo = 800;
const EV_RecipeShowRecipeTreeWnd = 810;
const EV_RecipeShowBookWnd = 820;
const EV_RecipeAddBookItem = 830;
const EV_RecipeItemMakeInfo = 840;
const EV_RecipeShopShowWnd = 850;
const EV_RecipeShopAddBookItem = 860;
const EV_RecipeShopAddShopItem = 870;
const EV_HeroShowList = 880;
const EV_HeroRecord = 890;
const EV_OlympiadTargetShow = 900;
const EV_OlympiadMatchEnd = 910;
const EV_OlympiadUserInfo = 920;
const EV_OlympiadBuffShow = 930;
const EV_OlympiadBuffInfo = 940;
const EV_AbnormalStatusNormalItem = 950;
const EV_AbnormalStatusEtcItem = 960;
const EV_AbnormalStatusShortItem = 970;
const EV_TargetUpdate = 980;
const EV_TargetSkillInfo = 981;
const EV_TargetSkillCancel = 982;
const EV_TargetHideWindow = 990;
const EV_ShowBuffIcon = 1000;
const EV_PetWndShow = 1010;
const EV_PetWndShowNameBtn = 1020;
const EV_PetWndRegPetNameFailed = 1030;
const EV_PetStatusShow = 1040;
const EV_PetStatusSpelledList = 1050;
const EV_PetStatusSpelledListDelete = 1052;
const EV_PetStatusSpelledListInsert = 1053;
const EV_PetInventoryItemStart = 1060;
const EV_PetInventoryItemList = 1070;
const EV_PetInventoryItemUpdate = 1080;
const EV_SummonedWndShow = 1090;
const EV_SummonedStatusShow = 1100;
const EV_SummonedStatusSpelledList = 1110;
const EV_SummonedStatusSpelledListDelete = 1112;
const EV_SummonedStatusSpelledListInsert = 1113;
const EV_SummonedStatusRemainTime = 1120;
const EV_PetStatusClose = 1130;
const EV_SummonedStatusClose = 1131;
const EV_SummonedDelete = 1132;
const EV_PartyAddParty = 1140;
const EV_PartyUpdateParty = 1150;
const EV_PartyDeleteParty = 1160;
const EV_PartyDeleteAllParty = 1170;
const EV_PartySpelledList = 1180;
const EV_PartyRenameMember = 1181;
const EV_PartySpelledListDelete = 1182;
const EV_PartySpelledListInsert = 1183;
const EV_ShowBBS = 1190;
const EV_ShowBoardPacket = 1200;
const EV_ShowHelp = 1210;
const EV_LoadHelpHtml = 1220;
const EV_LoadPetitionHtml = 1221;
const EV_MacroShowListWnd = 1230;
const EV_MacroUpdate = 1240;
const EV_MacroList = 1250;
const EV_MacroShowEditWnd = 1260;
const EV_MacroDeleted = 1270;
const EV_SkillListStart = 1280;
const EV_SkillList = 1290;
const EV_SkillListEnd = 1291;
const EV_ActionListStart = 1300;
const EV_ActionList = 1310;
const EV_ActionListNew = 1311;
const EV_ActionPetListStart = 1320;
const EV_ActionPetListEnd = 1321;
const EV_ActionPetList = 1330;
const EV_ActionSummonedCommonListStart = 1340;
const EV_ActionSummonedCommonList = 1350;
const EV_ActionSummonedAllSkillListStart = 1351;
const EV_ActionSummonedAllSkillList = 1352;
const EV_CommandChannelStart = 1360;
const EV_CommandChannelEnd = 1370;
const EV_CommandChannelInfo = 1380;
const EV_CommandChannelPartyList = 1390;
const EV_CommandChannelPartyUpdate = 1395;
const EV_CommandChannelRoutingType = 1400;
const EV_CommandChannelPartyMember = 1420;
const EV_RestartMenuShow = 1430;
const EV_RestartMenuHide = 1440;
const EV_SiegeInfo = 1450;
const EV_SiegeInfoClanListStart = 1460;
const EV_SiegeInfoClanList = 1470;
const EV_SiegeInfoClanListEnd = 1480;
const EV_SiegeInfoSelectableTime = 1490;
const EV_IMEStatusChange = 1500;
const EV_ArriveNewTutorialQuestion = 1510;
const EV_ArriveTutorial = 1511;
const EV_ArriveShowQuest = 1520;
const EV_ArriveNewMail = 1530;
const EV_PartyMatchStart = 1540;
const EV_PartyMatchRoomStart = 1550;
const EV_PartyMatchingRoomHistory = 1551;
const EV_PartyMatchRoomClose = 1560;
const EV_PartyMatchList = 1570;
const EV_PartyMatchRoomMember = 1580;
const EV_PartyMatchRoomMemberUpdate = 1590;
const EV_PartyMatchChatMessage = 1600;
const EV_PartyMatchWaitListStart = 1610;
const EV_PartyMatchWaitList = 1620;
const EV_PartyMatchCommand = 1630;
const EV_HennaListWndShowHideEquip = 1640;
const EV_HennaListWndAddHennaEquip = 1650;
const EV_HennaInfoWndShowHideEquip = 1660;
const EV_HennaInfoWndShowHidePremiumEquip = 1661;
const EV_HennaListWndShowHideUnEquip = 1670;
const EV_HennaListWndClose = 1671;
const EV_HennaListWndAddHennaUnEquip = 1680;
const EV_HennaInfoWndShowHideUnEquip = 1690;
const EV_HennaInfoWndShowHidePremiumUnEquip = 1691;
const EV_CalculatorWndShowHide = 1700;
const EV_DialogOK = 1710;
const EV_DialogCancel = 1720;
const EV_RadarAddTarget = 1730;
const EV_RadarDeleteTarget = 1740;
const EV_RadarDeleteAllTarget = 1750;
const EV_RadarColor = 1760;
const EV_ShowTownMap = 1770;
const EV_ShowMinimap = 1780;
const EV_MinimapAddTarget = 1790;
const EV_MinimapDeleteTarget = 1800;
const EV_MinimapDeleteAllTarget = 1810;
const EV_MinimapShowQuest = 1820;
const EV_MinimapHideQuest = 1830;
const EV_MinimapChangeZone = 1840;
const EV_MinimapCursedWeaponList = 1850;
const EV_MinimapCursedWeaponLocation = 1860;
const EV_MinimapShowReduceBtn = 1870;
const EV_MinimapHideReduceBtn = 1880;
const EV_MinimapUpdateGameTime = 1890;
const EV_MinimapShowMultilayer = 1891;
const EV_MinimapCloseMultilayer = 1892;
const EV_MinimapAdjustViewLocation = 1893;
const EV_LanguageChanged = 1900;
const EV_PCCafePointInfo = 1910;
const EV_ShowPetitionWnd = 1920;
const EV_ShowUserPetitionWnd = 1921;
const EV_PetitionChatMessage = 1930;
const EV_EnablePetitionFeedback = 1940;
const EV_TradeStart = 1950;
const EV_TradeAddItem = 1960;
const EV_TradeDone = 1970;
const EV_TradeOtherOK = 1980;
const EV_TradeUpdateInventoryItem = 1990;
const EV_TradeRequestStartExchange = 2000;
const EV_SkillTrainListWndShow = 2010;
const EV_SkillTrainListWndHide = 2020;
const EV_SkillTrainListWndAddSkill = 2030;
const EV_SkillTrainInfoWndShow = 2040;
const EV_SkillTrainInfoWndHide = 2050;
const EV_SkillTrainInfoWndAddExtendInfo = 2051;
const EV_SkillLearningTabAddSkillBegin = 2055;
const EV_SkillLearningTabAddSkillItem = 2056;
const EV_SkillLearningTabAddSkillEnd = 2057;
const EV_SkillLearningDetailInfo = 2058;
const EV_SkillLearningNewArrival = 2059;
const EV_SkillEnchantInfoWndShow = 2064;
const EV_SkillEnchantInfoWndAddSkill = 2065;
const EV_SkillEnchantInfoWndAddExtendInfo = 2067;
const EV_SetMaxCount = 2070;
const EV_ShopOpenWindow = 2080;
const EV_OnEndTransactionList = 2081;
const EV_OnAddCastleTaxRateList = 2082;
const EV_ShopAddItem = 2090;
const EV_WarehouseOpenWindow = 2100;
const EV_WarehouseAddItem = 2110;
const EV_WarehouseDeleteItem = 2111;
const EV_PrivateShopOpenWindow = 2120;
const EV_PrivateShopAddItem = 2130;
const EV_SelectDeliverClear = 2140;
const EV_SelectDeliverAddName = 2150;
const EV_DeliverOpenWindow = 2160;
const EV_DeliverAddItem = 2170;
const EV_ShowEventMatchGMWnd = 2180;
const EV_EventMatchCreated = 2190;
const EV_EventMatchDestroyed = 2200;
const EV_EventMatchManage = 2210;
const EV_EventMatchPartyLeader = 2211;
const EV_StartEventMatchObserver = 2220;
const EV_EventMatchUpdateTeamName = 2230;
const EV_EventMatchUpdateScore = 2240;
const EV_EventMatchUpdateTeamInfo = 2250;
const EV_EventMatchUpdateUserInfo = 2260;
const EV_EventMatchGMMessage = 2270;
const EV_ShowGMWnd = 2280;
const EV_GMObservingUserInfoUpdate = 2290;
const EV_GMObservingUserInfoUpdateClassic = 2291;
const EV_GMObservingSkillListStart = 2300;
const EV_GMObservingSkillList = 2310;
const EV_GMObservingQuestListStart = 2320;
const EV_GMObservingQuestList = 2330;
const EV_GMObservingQuestListEnd = 2340;
const EV_GMObservingQuestItem = 2350;
const EV_GMObservingWarehouseItemListStart = 2360;
const EV_GMObservingWarehouseItemList = 2370;
const EV_GMObservingClan = 2380;
const EV_GMObservingClanMemberStart = 2390;
const EV_GMObservingClanMember = 2400;
const EV_GMObservingInventoryAddItem = 2401;
const EV_GMObservingInventoryClear = 2402;
const EV_GMAddHennaInfo = 2403;
const EV_GMUpdateHennaInfo = 2404;
const EV_GMAddPremiumHennaInfo = 2405;
const EV_GMSnoop = 2410;
const EV_BeginShowZoneTitleWnd = 2420;
const EV_TutorialViewerWndShow = 2430;
const EV_TutorialViewerWndShowHtmlFile = 2431;
const EV_TutorialViewerWndHide = 2440;
const EV_ObserverWndShow = 2450;
const EV_ObserverWndHide = 2460;
const EV_AutoFishStart = 2471;
const EV_FishViewportWndHide = 2480;
const EV_AutoFishEnd = 2481;
const EV_AutoFishAvailable = 2490;
const EV_MultiSellInfoListBegin = 2530;
const EV_NewMultiSellInfoListBegin = 2531;
const EV_MultiSellResultItemInfo = 2535;
const EV_NewMultiSellResultItemInfo = 2536;
const EV_MultiSellOutputItemInfo = 2540;
const EV_NewMultiSellOutputItemInfo = 2541;
const EV_MultiSellInputItemInfo = 2550;
const EV_NewMultiSellInputItemInfo = 2551;
const EV_MultiSellInfoListEnd = 2560;
const EV_NewMultiSellInfoListEnd = 2561;
const EV_MultiSellResult = 2565;
const EV_InventoryClear = 2570;
const EV_InventoryOpenWindow = 2580;
const EV_InventoryHideWindow = 2590;
const EV_InventoryAddItem = 2600;
const EV_InventoryUpdateItem = 2610;
const EV_InventoryItemListEnd = 2620;
const EV_InventoryAddHennaInfo = 2630;
const EV_InventoryToggleWindow = 2631;
const EV_InventoryAddPremiumHennaInfo = 2632;
const EV_InventoryPremiumHennaInfoClear = 2633;
const EV_ManorCropSellWndShow = 2640;
const EV_ManorCropSellWndAddItem = 2645;
const EV_ManorCropSellWndSetCropSell = 2646;
const EV_ManorCropSellChangeWndShow = 2647;
const EV_ManorCropSellChangeWndAddItem = 2648;
const EV_ManorCropSellChangeWndSetCropNameAndRewardType = 2649;
const EV_ManorInfoWndSeedShow = 2650;
const EV_ManorInfoWndSeedAdd = 2651;
const EV_ManorInfoWndCropShow = 2652;
const EV_ManorInfoWndCropAdd = 2653;
const EV_ManorInfoWndDefaultShow = 2654;
const EV_ManorInfoWndDefaultAdd = 2655;
const EV_ManorSeedInfoSettingWndShow = 2656;
const EV_ManorSeedInfoSettingWndAddItem = 2657;
const EV_ManorSeedInfoSettingWndAddItemEnd = 2658;
const EV_ManorSeedInfoSettingWndChangeValue = 2659;
const EV_ManorSeedInfoChangeWndShow = 2660;
const EV_ManorCropInfoSettingWndShow = 2665;
const EV_ManorCropInfoSettingWndAddItem = 2666;
const EV_ManorCropInfoSettingWndAddItemEnd = 2667;
const EV_ManorCropInfoSettingWndChangeValue = 2668;
const EV_ManorCropInfoChangeWndShow = 2670;
const EV_ManorShopWndOpen = 2680;
const EV_ManorShopWndAddItem = 2690;
const EV_DuelAskStart = 2700;
const EV_DuelReady = 2710;
const EV_DuelStart = 2720;
const EV_DuelEnd = 2730;
const EV_DuelUpdateUserInfo = 2740;
const EV_DuelEnemyRelation = 2750;
const EV_ShowRefineryInteface = 2760;
const EV_RefineryConfirmTargetItemResult = 2770;
const EV_RefineryConfirmRefinerItemResult = 2780;
const EV_RefineryConfirmGemStoneResult = 2790;
const EV_RefineryRefineResult = 2800;
const EV_ShowRefineryCancelInteface = 2810;
const EV_RefineryConfirmCancelItemResult = 2820;
const EV_RefineryRefineCancelResult = 2830;
const EV_QuestInfoStart = 2840;
const EV_QuestInfo = 2850;
const EV_EnchantShow = 2860;
const EV_EnchantHide = 2865;
const EV_EnchantResult = 2870;
const EV_EnchantPutTargetItemResult = 2880;
const EV_EnchantPutSupportItemResult = 2881;
const EV_EnchantPutScrollItemResult = 2882;
const EV_EnchantRemoveSupportItemResult = 2883;
const EV_AttributeEnchantItemShow = 2893;
const EV_AttributeEnchantItemList = 2894;
const EV_AttributeEnchantResult = 2895;
const EV_RemoveAttributeEnchantWndShow = 2896;
const EV_RemoveAttributeEnchantItemData = 2897;
const EV_RemoveAttributeEnchantResult = 2898;
const EV_ResolutionChanged = 2900;
const EV_TrackerAttach = 2920;
const EV_TrackerDetach = 2930;
const EV_EditorSetProperty = 2940;
const EV_EditorUpdateProperty = 2950;
const EV_RequestTooltipInfo = 2960;
const EV_NotifyObject = 2970;
const EV_NotifyPartyMemberPosition = 2971;
const EV_MinimapTravel = 2980;
const EV_MinimapRegionInfoBtnClick = 2990;
const EV_TextLinkLButtonClick = 3000;
const EV_TextLinkRButtonClick = 3010;
const EV_LobbyMenuButtonEnable = 3020;
const EV_LobbyAddCharacterName = 3021;
const EV_LobbyCharacterSelect = 3022;
const EV_LobbyClearCharacterName = 3023;
const EV_LobbyStartButtonClick = 3024;
const EV_LobbyShowDialog = 3025;
const EV_LobbyGetSelectedCharacterIndex = 3026;
const EV_LobbyCharacterReceivingFinished = 3027;
const EV_LobbyShowPremiumLevelInfo = 3028;
const EV_LobbyShowDormantUserCouponWnd = 3029;
const EV_ITEM_AUCTION_INFO = 3050;
const EV_ITEM_AUCTION_NEXT_INFO = 3051;
const EV_ITEM_AUCTION_NEXT_NOTEXIST = 3052;
const EV_ITEM_AUCTION_UPDATED_BIDDING_INFO = 3053;
const EV_MouseOver = 3060;
const EV_MouseOut = 3070;
const EV_ShowWindow = 3080;
const EV_PartyPetAdd = 3110;
const EV_PartyPetUpdate = 3120;
const EV_PartyPetDelete = 3130;
const EV_PartySummonAdd = 3131;
const EV_PartySummonUpdate = 3132;
const EV_PartySummonDelete = 3133;
const EV_ShowCastleInfo = 3140;
const EV_AddCastleInfo = 3150;
const EV_ShowFortressInfo = 3160;
const EV_AddFortressInfo = 3170;
const EV_ShowAgitInfo = 3180;
const EV_AddAgitInfo = 3190;
const EV_ShowFortressSiegeInfo = 3200;
const EV_ShowFortressMapInfo = 3201;
const EV_FortressMapBarrackInfo = 3202;
const EV_CharacterCreateSetClassDesc = 3210;
const EV_CharacterCreateClearClassDesc = 3220;
const EV_CharacterCreateClearSetupWnd = 3230;
const EV_CharacterCreateClearWnd = 3240;
const EV_CharacterCreateClearName = 3250;
const EV_CharacterCreateEnableRotate = 3260;
const EV_NPCDialogWndShow = 3270;
const EV_NPCDialogWndShowBig1 = 3271;
const EV_NPCDialogWndHide = 3280;
const EV_NPCDialogWndHideBig1 = 3281;
const EV_NPCDialogWndLoadHtmlFromString = 3290;
const EV_NPCDialogWndLoadHtmlFromStringBig1 = 3291;
const EV_ItemDescWndShow = 3300;
const EV_ItemDescWndLoadHtmlFromString = 3310;
const EV_ItemDescWndSetWindowTitle = 3320;
const EV_QuestIDWndLoadHtmlFromString = 3321;
const EV_QuestHtmlWndLoadHtmlFromString = 3322;
const EV_QuestHtmlWndShow = 3323;
const EV_QuestHtmlWndHide = 3324;
const EV_ToggleXMasSealWndShowHide = 3330;
const EV_OpenDialogQuit = 3340;
const EV_OpenDialogRestart = 3350;
const EV_FinishRotate = 3360;
const EV_PVPMatchRecord = 3370;
const EV_PVPMatchRecordEachUserInfo = 3380;
const EV_PVPMatchUserDie = 3390;
const EV_ToggleDetailStatusWnd = 3400;
const EV_StateChanged = 3410;
const EV_NotifyBeforeStateChanged = 3411;
const EV_ShowChangeNicknameNColor = 3440;
const EV_BookMarkList = 3450;
const EV_BookMarkShow = 3451;
const EV_SetShowAllStateInfo = 3452;
const EV_PremiumItemAlarm = 3460;
const EV_PremiumItemList = 3461;
const EV_CrataeCubeRecordBegin = 3470;
const EV_CrataeCubeRecordItem = 3480;
const EV_CrataeCubeRecordEnd = 3490;
const EV_CrataeCubeRecordMyItem = 3500;
const EV_CrataeCubeRecordRetire = 3501;
const EV_RenderDeviceRecreated = 3511;
const EV_ShowMiniGame1 = 3520;
const EV_AirShipUpdate = 3530;
const EV_AirShipState = 3540;
const EV_AirShipAltitude = 3541;
const EV_AirShipTeleportListStart = 3542;
const EV_AirShipTeleportList = 3543;
const EV_AITimer = 3550;
const EV_BirthdayItemAlarm = 3560;
const EV_ShowDominionWarJoinListStart = 3570;
const EV_ShowDominionWarJoinListEnemyDominionInfo = 3571;
const EV_ShowDominionWarJoinListEnd = 3572;
const EV_ResultJoinDominionWar = 3580;
const EV_DominionInfoCnt = 3590;
const EV_DominionInfo = 3600;
const EV_DominionsOwnPos = 3610;
const EV_DominionWarChannelSet = 3620;
const EV_DominionWarStart = 3630;
const EV_DominionWarEnd = 3640;
const EV_CleftListInfo = 3690;
const EV_CleftListStart = 3700;
const EV_CleftListAdd = 3710;
const EV_CleftListRemove = 3720;
const EV_CleftListClose = 3730;
const EV_CleftStateTeam = 3740;
const EV_CleftStatePlayer = 3750;
const EV_CleftStateResult = 3760;
const EV_FlightTransform = 3800;
const EV_ReserveShortCut = 3801;
const EV_ChangeCharacterPawn = 3810;
const EV_BlockRemainTime = 3820;
const EV_BlockListStart = 3830;
const EV_BlockListAdd = 3840;
const EV_BlockListRemove = 3850;
const EV_BlockListClose = 3860;
const EV_BlockListVote = 3870;
const EV_BlockListTimeUpset = 3880;
const EV_BlockStateTeam = 3890;
const EV_BlockStatePlayer = 3900;
const EV_BlockStateResult = 3910;
const EV_MpccRoomInfo = 4000;
const EV_ListMpccWaitingStart = 4010;
const EV_ListMpccWaitingRoomInfo = 4020;
const EV_ListMpccWaitingCount = 4021;
const EV_DismissMpccRoom = 4030;
const EV_ManageMpccRoomMember = 4040;
const EV_MpccRoomMemberStart = 4050;
const EV_MpccRoomMemberInfo = 4060;
const EV_MpccRoomChatMessage = 4070;
const EV_MpccPartyMasterList = 4080;
const EV_VitalityPointInfo = 4100;
const EV_VitalityEffectInfo = 4110;
const EV_GMVitalityEffectInfo = 4111;
const EV_LoginVitalityEffectInfo = 4120;
const EV_ShowSeedMapInfo = 4200;
const EV_PawnViewerWndAddItem = 4300;
const EV_PawnViewerWndAddHairMeshName = 4320;
const EV_PawnViewerWndAddFaceTextureName = 4330;
const EV_PawnViewerWndUpdateHairAccCoord = 4340;
const EV_PawnViewerWndClearAnimList = 4350;
const EV_PawnViewerWndAddAnimName = 4360;
const EV_PawnViewerWndShortcutSave = 4365;
const EV_PCViewerWndReload = 4370;
const EV_NPCViewerWndReload = 4380;
const EV_MSViewerWndAddSkill = 4400;
const EV_MSViewerWndShow = 4410;
const EV_MSViewerWndDeleteAllSkill = 4420;
const EV_MSProfilingResult = 4430;
const EV_MSProfilingClear = 4431;
const EV_SceneListUpdate = 4500;
const EV_SceneDataUpdate = 4510;
const EV_SceneDataSave = 4520;
const EV_UpdateSceneTreeData = 4530;
const EV_CurSceneIndexInit = 4540;
const EV_SlideShow = 4550;
const EV_ScenePlayStart = 4560;
const EV_ScenePlay = 4570;
const EV_SkillEnchantResult = 4600;
const EV_Notice_Post_Arrived = 4700;
const EV_StartReceivedPostList = 4710;
const EV_AddReceivedPostList = 4720;
const EV_EndReceivedPostList = 4730;
const EV_ReplyReceivedPostStart = 4740;
const EV_ReplyReceivedPostAddItem = 4741;
const EV_ReplyReceivedPostEnd = 4742;
const EV_StartSentPostList = 4750;
const EV_AddSentPostList = 4760;
const EV_EndSentPostList = 4770;
const EV_ReplySentPostStart = 4780;
const EV_ReplySentPostAddItem = 4781;
const EV_ReplySentPostEnd = 4782;
const EV_PostWriteOpen = 4790;
const EV_PostWriteAddItem = 4791;
const EV_PostWriteEnd = 4792;
const EV_DeleteReceivedPost = 4793;
const EV_OpenStateReceivedPost = 4794;
const EV_ReceivedStateReceivedPost = 4795;
const EV_DeleteSentPost = 4796;
const EV_OpenStateSentPost = 4797;
const EV_ReceivedStateSentPost = 4798;
const EV_ReplyWritePost = 4799;
const EV_ShowNewUserPetitionWnd = 4800;
const EV_AddNewUserPetitionCategoryStepOne = 4810;
const EV_ShowNewUserPetitionDescription = 4820;
const EV_AddNewUserPetitionCategoryStepTwo = 4830;
const EV_ShowNewUserPetitionContents = 4840;
const EV_ShowNewUserPetitionHtml = 4850;
const EV_ShowPrivateMarketList = 4860;
const EV_AddPrivateMarketList = 4861;
const EV_UsePartyMatchAction = 4870;
const EV_EffectViewerAddEffect = 4880;
const EV_EffectViewerShow = 4881;
const EV_ShowAskCoupleActionDialog = 4900;
const EV_AskPartyLootingModify = 4910;
const EV_PartyLootingHasModified = 4911;
const EV_MembershipType = 4912;
const EV_PartyHasDismissed = 4913;
const EV_BecamePartyMember = 4914;
const EV_BecamePartyMaster = 4915;
const EV_OustPartyMember = 4916;
const EV_WithdrawParty = 4917;
const EV_HandOverPartyMaster = 4918;
const EV_RecvPartyMaster = 4919;
const EV_CommandAddAllianceCrestFile = 4920;
const EV_ExpandQuestAlarmKillMonster = 4930;
const EV_ExpandQuestAlarmKillMonsterStart = 4931;
const EV_ExpandQuestAlarmKillMonsterEnd = 4932;
const EV_ReceiveNewVoteSystemInfo = 4940;
const EV_ShowNewVoteSystemHelp = 4941;
const EV_PostEffectShow = 4950;
const EV_UrlLinkClick = 4960;
const EV_ChatIconClick = 4961;
const EV_ReceiveFriendList = 4970;
const EV_ConfirmAddingPostFriend = 4980;
const EV_ReceivePostFriendList = 4990;
const EV_ReceivePledgeMemberList = 5000;
const EV_ShowWeatherWnd = 5010;
const EV_ReplayRecStarted = 5020;
const EV_ReplayRecEnded = 5021;
const EV_EnterOlympiadObserverMode = 5030;
const EV_ListCtrlLoseSelected = 5040;
const EV_HDRRenderTestWndShow = 5050;
const EV_SkillCancel = 5060;
const EV_NatureRenderShow = 5070;
const EV_ReceiveOlympiadGameList = 5080;
const EV_ReceiveOlympiadResult = 5081;
const EV_ReceiveOlympiadResultV2 = 5082;
const EV_SetEnterChatting = 5090;
const EV_UnSetEnterChatting = 5091;
const EV_NavitAdventPointInfo = 5100;
const EV_NavitAdventEffect = 5110;
const EV_NavitAdventTimeChange = 5120;
const EV_TargetSpelledList = 5120;
const EV_TargetStatusWndShow = 5121;
const EV_TargetStatusWndHide = 5122;
const EV_ActivateAlterSkill = 5130;
const EV_InactivateAlterSkill = 5131;
const EV_UseActiveAlterSkill = 5132;
const EV_CrystalizingEstimationList = 5140;
const EV_CrystalizingEstimationListEnd = 5141;
const EV_CrystalizingFail = 5142;
const EV_UpdateUltimateSkillPoint = 5150;
const EV_RegisterUltimateSkill = 5151;
const EV_ShowSheathingWnd = 5160;
const EV_SheathingInfo = 5170;
const EV_RequestStartPledgeWar = 5180;
const EV_RequestStopPledgeWar = 5181;
const EV_JumpWayPointUpdate = 5190;
const EV_JumpWayPointHide = 5200;
const EV_CampaignArrived = 5210;
const EV_ZoneQuestArrived = 5220;
const EV_CampaignProgressInfo = 5230;
const EV_ZoneQuestProgressInfo = 5240;
const EV_CampaignFinish = 5250;
const EV_ZoneQuestFinish = 5260;
const EV_CampaignRewardStart = 5270;
const EV_ZoneQuestRewardStart = 5280;
const EV_CampaignRewardFinish = 5290;
const EV_ZoneQuestRewardFinish = 5300;
const EV_CampaignResult = 5301;
const EV_ZoneQuestResult = 5302;
const EV_MinimapShowCampaign = 5303;
const EV_MinimapHideCampaign = 5304;
const EV_NotifySubjob = 5310;
const EV_CreatedSubjob = 5311;
const EV_ChangedSubjob = 5312;
const EV_HeadDisplayUpdate = 5320;
const EV_OwnSkillHasLaunched = 5330;
const EV_OwnSkillHasCanceled = 5340;
const EV_GStarObtainSkill = 5350;
const EV_GstarShowMissionGuide = 5351;
const EV_GstarPlayFlashMovie = 5352;
const EV_GstarUIInit = 5353;
const EV_GstarCloseSkill = 5354;
const EV_GstarZoneChange = 5355;
const EV_GstarSceneStateEnter = 5356;
const EV_GstarCommandLineIcon = 5357;
const EV_GstarGameEnd = 5358;
const EV_GstarNotifyMonsterCount = 5359;
const EV_ApplySkillAvailability = 5360;
const EV_ApplyPetSkillAvailability = 5365;
const EV_DamageTextCreate = 5370;
const EV_DamageTextUpdate = 5371;
const EV_NotifyTutorialQuest = 5380;
const EV_ClearTutorialQuest = 5381;
const EV_FriendInfoListEmpty = 5390;
const EV_FriendAdded = 5391;
const EV_FriendRemoved = 5392;
const EV_FriendInfoUpdate = 5393;
const EV_FriendDetailInfoUpdate = 5394;
const EV_BlockInfoListEmpty = 5400;
const EV_BlockAdded = 5401;
const EV_BlockRemoved = 5402;
const EV_BlockInfoUpdate = 5403;
const EV_BlockDetailInfoUpdate = 5404;
const EV_InzonePartyHistoryUpdate = 5410;
const EV_ShowPersonalConnectionWnd = 5411;
const EV_MovieCaptureStarted = 5420;
const EV_MovieCaptureEnded = 5430;
const EV_MovieCaptureFailDiskSpace = 5440;
const EV_CallToChangeClass = 5470;
const EV_ChangeToAwakenedClass = 5480;
const EV_ItemCommissionWndShow = 5490;
const EV_ItemCommissionWndRegistrableItemCnt = 5492;
const EV_ItemCommissionWndRegistrableItemList = 5495;
const EV_ItemCommissionWndResponseInfo = 5500;
const EV_ItemCommissionWndListStart = 5510;
const EV_ItemCommissionWndEachItem = 5520;
const EV_ItemCommissionWndListEnd = 5530;
const EV_ItemCommissionWndSearchFail = 5535;
const EV_ItemCommissionWndBuyInfo = 5540;
const EV_ItemCommissionWndBuyResult = 5550;
const EV_ItemCommissionWndDeleteResult = 5560;
const EV_ItemCommissionWndRegisterResult = 5570;
const EV_ItemCommissionWndCloseCauseOfLongDistance = 5571;
const EV_ItemCommissionRegisterWndCloseCauseOfFreeUser = 5572;
const EV_ItemCommissionWndSellingPremiumItemRegisterReset = 5498;
const EV_ItemCommissionWndSellingPremiumItemRegister = 5499;
const EV_FlashDebugMsg = 5580;
const EV_StatisticWndShow = 5590;
const EV_StatisticHotLinkWndShow = 5591;
const EV_StatisticNameInfo = 5592;
const EV_StatisticAllNameInfo = 5593;
const EV_StatisticWorldRecord = 5594;
const EV_StatisticUserRecord = 5595;
const EV_ShowGoodsInventoryWnd = 5600;
const EV_GoodsInventoryItemList = 5601;
const EV_GoodsInventoryItemDesc = 5602;
const EV_GoodsInventoryNoti = 5603;
const EV_GoodsInventoryResult = 5604;
const EV_SecondaryAuthCreate = 5610;
const EV_SecondaryAuthVerify = 5611;
const EV_SecondaryAuthBlocked = 5612;
const EV_SecondaryAuthSuccess = 5613;
const EV_SecondaryAuthCreateFail = 5614;
const EV_SecondaryAuthVerifyFail = 5615;
const EV_SecondaryAuthFailEtc = 5616;
const EV_CharacterNameCreatable = 5618;
const EV_ShowSceneClipView = 5620;
const EV_DeleteSceneClipView = 5621;
const EV_ShowUsm = 5622;
const EV_ShowFullSceneClipView = 5623;
const EV_DeleteFullSceneClipView = 5624;
const EV_LoginBegin = 5630;
const EV_LoginFail = 5640;
const EV_LoginFailFlash = 5641;
const EV_LoginOK = 5650;
const EV_LoginQueueTicket = 5651;
const EV_LoginWait = 5660;
const EV_LoginTelephoneWait = 5661;
const EV_LoginSecurityCard = 5670;
const EV_LoginGoogleOtp = 5671;
const EV_ShowEula = 5680;
const EV_ShowChinaEula = 5681;
const EV_ServerListStart = 5690;
const EV_ServerList = 5691;
const EV_ServerListEnd = 5692;
const EV_LoginUIGetFocus = 5700;
const EV_CreditXMLString = 5710;
const EV_OptionHasApplied = 5720;
const EV_ChangeAttribute_CandidateListClear = 5730;
const EV_ChangeAttribute_CandidateItem = 5731;
const EV_ChangeAttribute_ItemDetail = 5732;
const EV_ChangeAttribute_ItemResult = 5733;
const EV_WebBrowser_ShowFileRegisterWnd = 5740;
const EV_WebBrowser_FinishedLoading = 5750;
const EV_WebBrowser_ReceivedTitle = 5751;
const EV_WebBrowser_NoticeOpenStatus = 5752;
const EV_WebBrowser_EventParam = 5753;
const EV_ConfirmMentee = 5800;
const EV_MentorMenteeListStart = 5810;
const EV_MentorMenteeListInfo = 5820;
const EV_MenteeWaitingListStart = 5830;
const EV_MenteeWaitingList = 5840;
const EV_MenteeWaitingListEnd = 5850;
const EV_InzoneWaitingInfo = 5860;
const EV_OptionWndShow = 5870;
const EV_SetFullScreenCheck = 5871;
const EV_EventAttendanceInfo = 6000;
const EV_ExtraWorldChattingCnt = 6110;
const EV_UpdateQuestMarkRadarMap = 6120;
const EV_UpdateTargetSelectedRadarMap = 6130;
const EV_ReceiveWindowsInfo = 6200;
const EV_ReceiveChatFilter = 6210;
const EV_ReceiveOption = 6220;
const EV_NeedResetUIData = 8000;
const EV_MatchGroup = 8200;
const EV_MatchGroupAsk = 8210;
const EV_MatchGroupWithdraw = 8220;
const EV_MatchGroupOust = 8230;
const EV_RequestMatchArena = 8300;
const EV_CompleteMatchArena = 8310;
const EV_ConfirmMatchArena = 8320;
const EV_CancelMatchArena = 8330;
const EV_StartChooseClassArena = 8340;
const EV_ChangeClassArena = 8350;
const EV_ConfirmClassArena = 8360;
const EV_StartBattleReadyArena = 8370;
const EV_BattleReadyArena = 8380;
const EV_BattleResultArena = 8400;
const EV_BattleResultArenaReward = 8401;
const EV_BattleResultArenaStat = 8402;
const EV_ExitArena = 8410;
const EV_ClosingArena = 8420;
const EV_ClosedArena = 8430;
const EV_ArenaDashboard = 8500;
const EV_ArenaUpdateEquipSlot = 8510;
const EV_ArenaKillInfo = 8520;
const EV_TransformNotification = 8530;
const EV_ArenaBattleOccupyDashboard = 8540;
const EV_ArenaBattleOccupyStatus = 8541;
const EV_ArenaBattleOccupyScore = 8542;
const EV_ArenaBattleOccupyShowSkill = 8545;
const EV_ArenaBattleOccupyHideSkill = 8546;
const EV_ArenaCustomNotification = 8600;
const EV_ArenaShowEnemyParty = 8610;
const EV_ArenaRankAll = 8650;
const EV_ArenaMyRank = 8660;
const EV_HtmlWithNPCViewport = 8700;
const EV_HtmlWithNPCViewportClose = 8701;
const EV_NpcStrWithNPCViewport = 8702;
const EV_NpcStrWithNPCViewportClose = 8703;
const EV_ArenaChangeAbilpage = 8800;
const EV_ArenaEnd = 9000;
const EV_BR_CashShopToggleWindow = 9010;
const EV_BR_CashShopCateroyAdd = 9011;
const EV_BR_CashShopCateroyTabRemove = 9012;
const EV_BR_RecentProductListEnd = 9013;
const EV_BR_BasketProductListEnd = 9014;
const EV_BR_CashShopNewIconAnim = 9015;
const EV_BR_CashShopCateroyTabClear = 9016;
const EV_BR_CashShopAddItem = 9020;
const EV_BR_SetNewList = 9021;
const EV_BR_ProductListEnd = 9022;
const EV_BR_CashShopAddProductItem = 9023;
const EV_BR_SetRecentProduct = 9025;
const EV_BR_SetBasketProduct = 9026;
const EV_BR_AddRecentProductItem = 9027;
const EV_BR_AddBasketProductItem = 9028;
const EV_BR_SetNewProductInfo = 9030;
const EV_BR_SetPresentNewProductInfo = 9031;
const EV_BR_AddMyShopBasketProductItem = 9032;
const EV_BR_DeleteMyShopBasketProductItem = 9033;
const EV_BR_DeleteCashShopBasketProductItem = 9034;
const EV_BR_DeleteAllBasketProductItem = 9035;
const EV_BR_AddEachProductInfo = 9040;
const EV_BR_AddPresentEachProductInfo = 9041;
const EV_BR_SETGAMEPOINT = 9050;
const EV_BR_SETEVENTCOIN = 9051;
const EV_BR_RESULT_BUY_PRODUCT = 9060;
const EV_BR_SHOW_CONFIRM = 9070;
const EV_BR_HIDE_CONFIRM = 9071;
const EV_BR_PRESENT_SHOW_CONFIRM = 9072;
const EV_BR_PRESENT_HIDE_CONFIRM = 9073;
const EV_BR_RESULT_PRESENT_BUY_PRODUCT = 9061;
const EV_BR_PREMIUM_STATE = 9080;
const EV_BR_FireEventStateInfo = 9090;
const EV_BR_FireEventTimeInfo = 9091;
const EV_BR_EventHalloweenHelp = 9100;
const EV_BR_EventHalloweenShow = 9101;
const EV_BR_EventRankerNowList = 9102;
const EV_BR_EventRankerLastList = 9103;
const EV_BR_EventChristmasShow = 9110;
const EV_BR_EventCommonHtml1 = 9111;
const EV_BR_EventCommonHtml2 = 9112;
const EV_BR_EventCommonHtml3 = 9113;
const EV_BR_MinigameMyRanking = 9120;
const EV_BR_MinigameAllRanking = 9121;
const EV_BR_EventValentineShow = 9130;
const EV_BR_Die_EnableNPC = 9140;
const EV_BR_RestartByNPCButtonEnable = 9150;
const EV_NotifyImportedCrestImage = 9220;
const EV_FlyMoveText = 9230;
const EV_NotifyFlyMoveStart = 9231;
const EV_BeastTestShow = 9240;
const EV_EnvTestShow = 9250;
const EV_ItemLookChangeShow = 9260;
const EV_ItemLookChangeHide = 9270;
const EV_ItemLookChangeResult = 9280;
const EV_ItemLookChangePutTargetItemResult = 9290;
const EV_ItemLookChangePutSupportItemResult = 9300;
const EV_CuriousHouseWaitState = 9310;
const EV_CuriousHouseEnter = 9320;
const EV_CuriousHouseLeave = 9330;
const EV_CuriousHouseMemberListStart = 9340;
const EV_CuriousHouseMemberList = 9341;
const EV_CuriousHouseMemberListEnd = 9342;
const EV_CuriousHouseMemberUpdate = 9350;
const EV_CuriousHouseRemainTime = 9360;
const EV_CuriousHouseResultIsVictory = 9370;
const EV_CuriousHouseResultListStart = 9380;
const EV_CuriousHouseResultList = 9381;
const EV_CuriousHouseResultListEnd = 9382;
const EV_CuriousHouseObserveListStart = 9390;
const EV_CuriousHouseObserveList = 9391;
const EV_CuriousHouseObserveListEnd = 9392;
const EV_CuriousHouseObserveModeON = 9400;
const EV_CuriousHouseObserveModeOFF = 9401;
const EV_UpdateHaircolorData = 9410;
const EV_ReceivePledgeUnionStateInfo = 9420;
const EV_ReceiveUnionPoint = 9421;
const EV_ReceivePledgeUnionOpenNPC = 9422;
const EV_RequestOpenClanUnionInfoWnd = 9425;
const EV_SendIsActiveUnionInfoBtn = 9426;
const EV_SendRequestResult = 9427;
const EV_EventKalieState = 9430;
const EV_EventKalieJackpotUser = 9431;
const EV_EventKalieDisable = 9432;
const EV_EventBalthusState = 9433;
const EV_EventBalthusJackpotUser = 9434;
const EV_EventBalthusDisable = 9435;
const EV_HairAccessoryPriority = 9439;
const EV_OpenBeautyshopWindow = 9440;
const EV_ReceiveBeautyItemList = 9441;
const EV_OpenBeautyshopResetWindow = 9442;
const EV_SendUserAdenaAndCoin = 9443;
const EV_IsSuccessBuyingStyle = 9444;
const EV_CurrentUserStyle = 9445;
const EV_OldUserStyle = 9446;
const EV_EndSocialAction = 9447;
const EV_ExitBeautyshop = 9448;
const EV_PurchaseItemList = 9449;
const EV_ShowWebPetitionMainPage = 9450;
const EV_ShowWebPetitionListPage = 9451;
const EV_WebPetitionReplyAlarm = 9452;
const EV_BR_Event_CampaignArrived = 9500;
const EV_BR_Event_CampaignProgressInfo = 9510;
const EV_BR_Event_CampaignFinish = 9520;
const EV_BR_Event_CampaignResult = 9530;
const EV_EnterSingleMeshZone = 9540;
const EV_ExitSingleMeshZone = 9541;
const EV_UnReadMailCount = 9550;
const EV_PledgeCount = 9560;
const EV_AdenaInvenCount = 9570;
const EV_PledgeRecruitBoardStart = 9580;
const EV_PledgeRecruitBoardItem = 9581;
const EV_PledgeRecruitInfo = 9582;
const EV_PledgeRecruitInfoItem = 9583;
const EV_PledgeRecruitBoardDetail = 9590;
const EV_PledgeWaitingListApplied = 9591;
const EV_PledgeWaitingListStart = 9600;
const EV_PledgeWaitingListItem = 9601;
const EV_PledgeWaitingUser = 9610;
const EV_PledgeDraftListStart = 9620;
const EV_PledgeDraftListItem = 9621;
const EV_PledgeWaitingListAlarm = 9630;
const EV_PledgeSigninForOpenJoiningMethod = 9631;
const EV_PledgeRecruitApplyInfo = 9640;
const EV_ShowEventChristmasWnd = 9650;
const EV_CardRewardStart = 9660;
const EV_CardListProperty = 9670;
const EV_CardProperty = 9680;
const EV_BR_10thAnniBannerShow = 9681;
const EV_DivideAdenaStart = 9690;
const EV_DivideAdenaCancel = 9700;
const EV_DivideAdenaDone = 9710;
const EV_CharacterDeleteFail = 9740;
const EV_GameStart = 9750;
const EV_GameStart_WorldRaid = 9751;
const EV_NewEnchantPushOneOK = 9760;
const EV_NewEnchantPushOneFail = 9770;
const EV_NewEnchantPushTwoOK = 9780;
const EV_NewEnchantPushTwoFail = 9790;
const EV_NewEnchantRemoveOneOK = 9800;
const EV_NewEnchantRemoveOneFail = 9810;
const EV_NewEnchantRemoveTwoOK = 9820;
const EV_NewEnchantRemoveTwoFail = 9830;
const EV_NewEnchantTrySuccess = 9840;
const EV_NewEnchantTryFail = 9850;
const EV_NewEnchantRetryPutItemsOK = 9851;
const EV_NewEnchantRetryPutItemsFail = 9852;
const EV_ContextMenu = 9860;
const EV_AlchemySkillList = 9870;
const EV_AlchemySkillListForXML = 9873;
const EV_AlchemyMixCubeInfo = 9875;
const EV_AlchemyTryMixCube = 9880;
const EV_AlchemyConversion = 9890;
const EV_AlchemySkillInfoFromScript = 9900;
const EV_AlchemyPushItemOnMixCube = 9910;
const EV_AlchemyAdditionPushItemOnMixCube = 9920;
const EV_UIDebugMsg = 9995;
const EV_BR_EventFastivalInkMax = 10000;
const EV_BR_EventFastivalInkEnergy = 10001;
const EV_ShowWebPathMainPage = 10010;
const EV_ShowWebPathListPage = 10011;
const EV_ShowWebPathAlarm = 10012;
const EV_ShowWebChinaShop = 10013;
const EV_ShowLuckyGame = 10021;
const EV_LuckyGameStart = 10022;
const EV_LuckyGameResult = 10023;
const EV_ShowTrainingRoom = 10030;
const EV_TrainingRoomStart = 10031;
const EV_TrainingRoomStutus = 10032;
const EV_TrainingRoomEnd = 10033;
const EV_TrainingRoomStart_SecondInfo = 10034;
const EV_PathToAwakeningAlarm = 10040;
const EV_InitEnterChattingSelectMode = 10041;
const EV_VipAttendanceItemList = 10050;
const EV_VipAttendanceCheck = 10051;
const EV_VipAttendanceRefresh = 10052;
const EV_NotifyAttendance = 10053;
const EV_EnsoulWndShow = 10060;
const EV_EnsoulResult = 10061;
const EV_EnsoulExtractionWndShow = 10062;
const EV_EnsoulExtractionResult = 10063;
const EV_CastleWarSeasonResult = 10070;
const EV_CastleWarSeasonReward = 10071;
const EV_FactionInfo = 10080;
const EV_VipBotCaptchaInfo = 10090;
const EV_VipBotCaptchaResult = 10091;
const EV_SendAgitFuncInfo = 10100;
const EV_ResponseDecoNPCAvalability = 10110;
const EV_InGameWebWnd_Info = 10120;
const EV_AI_CONTENT_MONSTER_ARENA_SCORE = 10130;
const EV_GotoWorldRaidServer = 10140;
const EV_MonsterBookStart = 10150;
const EV_MonsterBookInfo = 10151;
const EV_MonsterBookEnd = 10152;
const EV_MonsterBookRewardIcon = 10160;
const EV_MonsterBookOpenResult = 10161;
const EV_MonsterBookCloseForce = 10162;
const EV_FactionInfoRewardIcon = 10170;
const EV_FactionLevelUpNotify = 10171;
const EV_AddAgitSiegeInfo = 10180;
const EV_RaidBossSpawnInfo = 10181;
const EV_RaidServerInfo = 10182;
const EV_ItemAuctionStatus = 10183;
const EV_ShowUpgradeSystem = 10190;
const EV_UpgradeSystemResult = 10191;
const EV_UpgradeSystemProbList = 10192;
const EV_KserthFieldEventStep = 10200;
const EV_KserthFieldEventPoint = 10210;
const EV_PrivateStoreBuyingResult = 10220;
const EV_PrivateStoreSellingResult = 10221;
const EV_CurrentServerTime = 10230;
const EV_TeleportFreeLevel = 10231;
const EV_CardUpdownGameStart = 10240;
const EV_CardUpdownGamePickResult = 10250;
const EV_CardUpdownGamePrepReward = 10260;
const EV_CardUpdownGameRewardReply = 10270;
const EV_CardUpdownGameQuit = 10280;
const EV_PledgeContributionRank = 10350;
const EV_PledgeContributionInfo = 10360;
const EV_PledgeContributionReward = 10370;
const EV_PledgeRaidRank = 10400;
const EV_PledgeRaidInfo = 10410;
const EV_PledgeLevelUp = 10420;
const EV_PledgeShowInfoUpdate = 10430;
const EV_PledgeMissionInfo = 10440;
const EV_PledgeMissionRewardCount = 10441;
const EV_GFX_ClanInfo = 10450;
const EV_GFX_ClanInfoEnd = 10451;
const EV_GFX_ClanInfoUpdate = 10460;
const EV_GFX_ClanDeleteAllMember = 10470;
const EV_GFX_ClanAddMember = 10480;
const EV_GFX_ClanAddMemberMultiple = 10490;
const EV_GFX_ClanDeleteMember = 10500;
const EV_GFX_ClanMemberInfoUpdate = 10510;
const EV_GFX_ClanMyAuth = 10520;
const EV_GFX_ClanAuth = 10530;
const EV_GFX_ClanAuthMember = 10540;
const EV_GFX_ClanAuthGradeList = 10550;
const EV_GFX_ClanSubClanUpdated = 10560;
const EV_GFX_ResultJoinDominionWar = 10570;
const EV_GFX_AskStartPledgeWar = 10580;
const EV_GFX_ClanCrestChange = 10590;
const EV_GFX_ClanMemberInfo = 10600;
const EV_GFX_ClanSkillList = 10610;
const EV_GFX_ClanSkillListRenew = 10620;
const EV_GFX_ClanWarList = 10630;
const EV_GFX_ClanClearWarList = 10640;
const EV_GFX_ReceivePledgeMemberList = 10650;
const EV_GFX_AskStopPledgeWar = 10660;
const EV_PledgeMasteryInfo = 10670;
const EV_PledgeMasterySet = 10680;
const EV_PledgeMasteryReset = 10690;
const EV_TutorialShowID = 10700;
const EV_PledgeSkillInfo = 10710;
const EV_PledgeSkillActivate = 10720;
const EV_PledgeItemList = 10730;
const EV_PledgeItemActivate = 10740;
const EV_PledgeAnnounce = 10750;
const EV_PledgeAnnounceSet = 10760;
const EV_PledgeCrestSet = 10770;
const EV_PledgeEmblemSet = 10780;
const EV_AllyCrestSet = 10790;
const EV_PledgeCreateShow = 10800;
const EV_PledgeItemInfo = 10810;
const EV_PledgeItemBuy = 10820;
const EV_DismissPledge = 10830;
const EV_OustPledge = 10840;
const EV_WithdrawPledge = 10850;
const EV_ElementalSpiritInfo = 10860;
const EV_ElementalSpiritExtractInfo = 10870;
const EV_ElementalSpiritExtract = 10871;
const EV_ElementalSpiritEvolutionInfo = 10880;
const EV_ElementalSpiritEvolution = 10890;
const EV_ElementalSpiritSetTalent = 10900;
const EV_ElementalSpiritAbsorbInfo = 10910;
const EV_ElementalSpiritAbsorb = 10920;
const EV_ElementalSpiritGetExp = 10930;
const EV_ElementalSpiritSimpleInfo = 10940;
const EV_LockedItemShow = 11000;
const EV_LockedResult = 11010;
const EV_OlympiadInfo = 11020;
const EV_OlympiadRecord = 11021;
const EV_OlympiadMatchInfo = 11022;
const EV_OlympiadMatchMakingResult = 11023;
const EV_NextTargetModeChange = 11030;
const EV_GFX_ItemAnnounce = 11040;
const EV_Enchant_Artifact_Result = 11050;
const EV_BloodyCoinCount = 11060;
const EV_PurchaseLimitShopListBegin = 11061;
const EV_PurchaseLimitShopItemInfo = 11062;
const EV_PurchaseLimitShopListEnd = 11063;
const EV_PurchaseLimitShopItemBuy = 11064;
const EV_ClassChangeAlarm = 11070;
const EV_ClassChangeFlagOff = 11071;
const EV_MagicLamp_ExpInfo = 11080;
const EV_MagicLamp_GameInfo = 11081;
const EV_MagicLamp_GameResult = 11082;
const EV_MyTargetIsDead = 11090;
const EV_MinimapTreasureBoxLocation = 11110;
const EV_ShowCursedBarrierInfo = 11120;
const EV_PremiumManagerWndLoadHtmlFromString = 11130;
const EV_PremiumManagerWndShow = 11131;
const EV_PaybackListBegin = 11140;
const EV_PaybackListInfo = 11141;
const EV_PaybackListEnd = 11142;
const EV_PaybackGiveReward = 11143;
const EV_PaybackUILauncher = 11144;
const EV_CounterAttackListAdded = 11150;
const EV_CounterAttackListEmpty = 11151;
const EV_CounterAttack = 11152;
const EV_DieInfoBegin = 11160;
const EV_DieInfoDropItem = 11161;
const EV_DieInfoDamage = 11162;
const EV_DieInfoEnd = 11163;
const EV_AutoplaySetting = 11170;
const EV_AutoplayDoMacro = 11171;
const EV_GachaShopInfo = 11180;
const EV_GachaShopGachaGroup = 11181;
const EV_GachaShopGachaItemBegin = 11182;
const EV_GachaShopGachaItemInfo = 11183;
const EV_GachaShopGachaItemEnd = 11184;
const EV_TimeRestrictFieldListStart = 11190;
const EV_TimeRestrictFieldInfo = 11200;
const EV_TimeRestrictFieldListEnd = 11210;
const EV_TimeRestrictFieldEnterResult = 11220;
const EV_TimeRestrictFieldChargeResult = 11230;
const EV_TimeRestrictFieldUserAlarm = 11240;
const EV_TimeRestrictFieldExit = 11250;
const EV_HideQuitReportInstanceZone = 11251;
const EV_MyRankingDetailInfo = 11260;
const EV_MyRankingHistoryList = 11261;
const EV_CharacterRankingListBegin = 11270;
const EV_CharacterRankingInfo = 11271;
const EV_CharacterRankingListEnd = 11272;
const EV_ToggleCombatMode = 11280;
const EV_MCW_CastleInfo = 11300;
const EV_MCW_CastleSiegeHUDInfo = 11310;
const EV_MCW_CastleSiegeInfo = 11315;
const EV_MCW_CastleSiegeAttackerListStart = 11320;
const EV_MCW_CastleSiegeAttackerListItem = 11321;
const EV_MCW_CastleSiegeAttackerListEnd = 11322;
const EV_MCW_CastleSiegeDefenderListStart = 11330;
const EV_MCW_CastleSiegeDefenderListItem = 11331;
const EV_MCW_CastleSiegeDefenderListEnd = 11332;
const EV_PledgeMercenaryMemberListStart = 11340;
const EV_PledgeMercenaryMemberListItem = 11341;
const EV_PledgeMercenaryMemberListEnd = 11342;
const EV_PledgeMercenaryMemberJoin = 11350;
const EV_PvpbookListStart = 11360;
const EV_PvpbookListItem = 11370;
const EV_PvpbookListEnd = 11380;
const EV_PvpbookKillerLocation = 11390;
const EV_PvpbookNewPk = 11400;
const EV_UpdateWarMark = 11410;
const EV_UpdateTargetDead = 11420;
const EV_EquipItemTooltipClear = 11430;
const EV_SharedPositionAction = 11440;
const EV_GFX_TeleportFavoritesList = 11450;
const EV_XML_TeleportFavoritesList = 11451;
const EV_ShowHomunculusList = 11460;
const EV_ShowHomunculusBirthInfo = 11470;
const EV_PetSkillList = 11480;
const EV_PetAcquireSkillAlarm = 11481;
const EV_RequestEnemyPledgeRegister = 11490;
const EV_CollectionInfoEnd = 11500;
const EV_CollectionList = 11501;
const EV_CollectionUpdateFavorite = 11502;
const EV_CollectionFavoriteList = 11503;
const EV_CollectionSummary = 11504;
const EV_CollectionRegister = 11505;
const EV_CollectionComplete = 11506;
const EV_CollectionReceiveReward = 11507;
const EV_CollectionReset = 11508;
const EV_CollectionActiveEvent = 11509;
const EV_CollectionRegistEnableItem = 11510;
const EV_CollectionResetReward = 11511;
const EV_Hair2SlotEnable = 11520;
const EV_PenaltyItemListBegin = 11530;
const EV_PenaltyItemInfo = 11531;
const EV_PenaltyItemListEnd = 11532;
const EV_WorldCastleWarSiegeAttackerListStart = 11540;
const EV_WorldCastleWarSiegeAttackerList = 11541;
const EV_WorldCastleWarSiegeAttackerListEnd = 11542;
const EV_RequestInvitePartyAction = 11550;
const EV_RequestShowXMLDetailTooltip = 11555;
const EV_HideXMLDetailTooltip = 11560;
const EV_DisplayChanged = 11575;
const EV_ShowSimpleItemExchangeMultisellWnd = 11580;
const EV_Show_Dye = 11581;
const EV_Show_Potential = 11582;
const EV_Show_AdenLab = 11583;
const EV_DualInventoryInfo = 11590;
const EV_RequestDualInventorySwap = 11591;
const EV_UpdateMyAP = 11600;
const EV_UpdateMyMaxAP = 11601;
const EV_RequestAbilitySwap = 11610;
const EV_UpdatePlayerAutoAttacking = 11620;
const EV_PlayingCharCreateIntroAnimation = 11630;
const EV_EndCharCreateIntroAnimation = 11631;
const EV_UpdateMyLightLevel = 11640;
const EV_UpdateMyLP = 11641;
const EV_UpdateMyMaxLP = 11642;
const EV_StartCreateItemProbList = 11650;
const EV_CreateItemProbList = 11651;
const EV_EndCreateItemProbList = 11652;
const EV_PetPreview = 11660;
const EV_StartPetPreviewSkill = 11661;
const EV_PetPreviewSkill = 11662;
const EV_EndPetPreviewSkill = 11663;
const EV_UpdateMyWP = 11670;
const EV_UpdateMyMaxWP = 11671;
const EV_UpdateMyMaxHPBlockPer = 11680;
const EV_UpdatePartyMemberMaxHPBlockPer = 11681;
const EV_UpdateOlympiadUserMaxHPBlockPer = 11682;
const EV_VipProductItemStart = 20140;
const EV_VipProductItem = 20141;
const EV_VipProductItemEnd = 20142;
const EV_VipLuckyGameInfo = 20143;
const EV_VipLuckyGameItemList = 20144;
const EV_VipLuckyGameResult = 20145;
const EV_VipInfo = 20150;
const EV_VipInfoRemainTime = 20151;
const EV_TodoListShow = 20160;
const EV_TodoList = 20161;
const EV_TodoListHTML = 20162;
const EV_TodoListRecommandRenew = 20163;
const EV_TodoListInzoneRenew = 20164;
const EV_TodoListRecommandEnd = 20165;
const EV_TodoListInzoneEnd = 20166;
const EV_OneDayRewardListStart = 20170;
const EV_OneDayRewardList = 20171;
const EV_OneDayRewardListEnd = 20172;
const EV_OneDayRewardItemListStart = 20173;
const EV_OneDayRewardItemList = 20174;
const EV_OneDayRewardItemListEnd = 20175;
const EV_ConnectedTimeAndGettableReward = 20176;
const EV_OneDayRewardCount = 20177;
const EV_SoulShotUpdate = 20180;
const EV_MyPetSummonEvent = 20181;
const EV_BeginSoulShotUpdate = 20182;
const EV_PledgeBonusOpen = 20190;
const EV_PledgeBonusList = 20191;
const EV_PledgeBonusMarkReset = 20192;
const EV_PledgeBonusUpdate = 20193;
const EV_PledgeClassicRaidInfo = 20194;
const EV_TeleportMapWndShow = 20200;
const EV_UserBanInfo = 20240;
const EV_CostumeUseItem = 20250;
const EV_CostumeChooseItem = 20251;
const EV_CostumeList = 20252;
const EV_CostumeEvolution = 20253;
const EV_CostumeExtract = 20254;
const EV_CostumeLock = 20255;
const EV_CostumeShortCutList = 20256;
const EV_CostumeFullList = 20257;
const EV_CostumeCollectSkillActive = 20258;
const EV_FestivalInfo = 20260;
const EV_FestivalAllItemInfo = 20270;
const EV_FestivalTopItemInfo = 20280;
const EV_FestivalGame = 20290;
const EV_QTReceiveCurRoomInfo = 20420;
const EV_QTReceiveClanRoomID = 20421;
const EV_PkPenaltyInfoList = 20440;
const EV_NotifyWM_SetFocus = 20450;
const EV_UniqueGachaOpen = 20451;
const EV_PrivateShopFindOpen = 20460;
const EV_ProtocolBegin = 100000;
const MSIT_VITAL_POINT = -800;
const MSIT_CRAFT_POINT = -600;
const MSIT_RAID_POINT = -500;
const MSIT_FIELD_CYCLE_POINT = -400;
const MSIT_PVP_POINT = -300;
const MSIT_PLEDGE_POINT = -200;
const MSIT_PCCAFE_POINT = -100;
const MSIT_SP = -900;
const MSIT_DETHRONE_POINT = -1000;
const MSIT_VIS_POINT = -1100;
const ESTT_NORMAL = 0;
const ESTT_FISHING = 1;
const ESTT_CLAN = 2;
const ESTT_SUB_CLAN = 3;
const ESTT_TRANSFORM = 4;
const ESTT_SUBJOB = 5;
const ESTT_COLLECT = 6;
const ESTT_BISHOP_SHARING = 7;
const ESTT_ELDER_SHARING = 8;
const ESTT_SILEN_ELDER_SHARING = 9;
const CLAN_AUTH_VIEW = 1;
const CLAN_AUTH_EDIT = 2;
const CLAN_MAIN = 0;
const CLAN_KNIGHT1 = 100;
const CLAN_KNIGHT2 = 200;
const CLAN_KNIGHT3 = 1001;
const CLAN_KNIGHT4 = 1002;
const CLAN_KNIGHT5 = 2001;
const CLAN_KNIGHT6 = 2002;
const CLAN_ACADEMY = -1;
const CLAN_KNIGHTHOOD_COUNT = 8;
const CLAN_MEMBERTYPE_COUNT = 2;
const CLAN_AUTH_GRADE1 = 1;
const CLAN_AUTH_GRADE2 = 2;
const CLAN_AUTH_GRADE3 = 3;
const CLAN_AUTH_GRADE4 = 4;
const CLAN_AUTH_GRADE5 = 5;
const CLAN_AUTH_GRADE6 = 6;
const CLAN_AUTH_GRADE7 = 7;
const CLAN_AUTH_GRADE8 = 8;
const CLAN_AUTH_GRADE9 = 9;
const DisabledByStat = 1;
const DisabledByItem = 2;
const DisabledByCost = 4;
const DisabledByCasterAbnormalState = 8;
const DisabledByTargetAbnormalState = 16;
const DisabledByUltimateSkillPoint = 32;
const BLACKCOUPON_OLDSERVER = 1000001;
const MAX_RELATED_QUEST = 10;
const MAX_INCLUDE_ITEM = 10;
const EIST_INVALID = 0;
const EIST_NORMAL = 1;
const EIST_BM = 2;
const EIST_MAX = 3;
const EISI_INVALID = -1;
const EISI_START = 1;
const EISI_MAX = 2;
const SBT_NONE = 0;
const SBT_UNDERWEAR = 1;
const SBT_REAR = 2;
const SBT_LEAR = 4;
const SBT_NECK = 8;
const SBT_RFINGER = 16;
const SBT_LFINGER = 32;
const SBT_HEAD = 64;
const SBT_RHAND = 128;
const SBT_LHAND = 256;
const SBT_GLOVES = 512;
const SBT_CHEST = 1024;
const SBT_LEGS = 2048;
const SBT_FEET = 4096;
const SBT_BACK = 8192;
const SBT_RLHAND = 16384;
const SBT_ONEPIECE = 32768;
const SBT_HAIR = 65536;
const SBT_ALLDRESS = 131072;
const SBT_HAIR2 = 262144;
const SBT_HAIRALL = 524288;
const SBT_RBRACELET = 1048576;
const SBT_LBRACELET = 2097152;
const SBT_DECO1 = 4194304;
const SBT_DECO2 = 8388608;
const SBT_DECO3 = 16777216;
const SBT_DECO4 = 33554432;
const SBT_DECO5 = 67108864;
const SBT_DECO6 = 134217728;
const SBT_WAIST = 268435456;
const SBT_BROOCH = 536870912;
const SBT_JEWEL1 = 1073741824;
const SBT_JEWEL2 = 2147483648;
const SBT_JEWEL3 = 4294967296;
const SBT_JEWEL4 = 8589934592;
const SBT_JEWEL5 = 17179869184;
const SBT_JEWEL6 = 34359738368;
const SBT_AGATHION_MAIN = 68719476736;
const SBT_AGATHION_SUB1 = 137438953472;
const SBT_AGATHION_SUB2 = 274877906944;
const SBT_AGATHION_SUB3 = 549755813888;
const SBT_AGATHION_SUB4 = 1099511627776;
const SBT_ARTIFACTBOOK = 2199023255552;
const SBT_ARTIFACT_A1 = 4398046511104;
const SBT_ARTIFACT_A2 = 8796093022208;
const SBT_ARTIFACT_A3 = 17592186044416;
const SBT_ARTIFACT_A4 = 35184372088832;
const SBT_ARTIFACT_A5 = 70368744177664;
const SBT_ARTIFACT_A6 = 140737488355328;
const SBT_ARTIFACT_A7 = 281474976710656;
const SBT_ARTIFACT_A8 = 562949953421312;
const SBT_ARTIFACT_A9 = 1125899906842624;
const SBT_ARTIFACT_A10 = 2251799813685248;
const SBT_ARTIFACT_A11 = 4503599627370496;
const SBT_ARTIFACT_A12 = 9007199254740992;
const SBT_ARTIFACT_B1 = 18014398509481984;
const SBT_ARTIFACT_B2 = 36028797018963968;
const SBT_ARTIFACT_B3 = 72057594037927936;
const SBT_ARTIFACT_C1 = 144115188075855872;
const SBT_ARTIFACT_C2 = 288230376151711744;
const SBT_ARTIFACT_C3 = 576460752303423488;
const SBT_ARTIFACT_D1 = 1152921504606846976;
const SBT_ARTIFACT_D2 = 2305843009213693952;
const SBT_ARTIFACT_D3 = 4611686018427387904;
const SSB_None = 0;
const SSB_Unacquirable = 1;
const SSB_Acquirable = 2;
const SSB_AcquirableNextLevel = 4;
const SSB_RegistShortcut = 8;
const SSB_Enchantable = 16;
const SSB_ActiveSkill = 32;
const SSB_PreviewSkill = 64;
const NOT_PERIOIDIC_ITEM = -9999;
const AutoplayMacroSlotID = 276;
const AutoHPPotionSlotID = 277;
const AutoHPPetPotionSlotID = 278;
const AutoplayMacroSlotID2 = 279;
const VALIDATE_ENUM_MAX = 16;

enum EGMCommandType
{
	GMCOMMAND_None,                 // 0
	GMCOMMAND_StatusInfo,           // 1
	GMCOMMAND_ClanInfo,             // 2
	GMCOMMAND_SkillInfo,            // 3
	GMCOMMAND_QuestInfo,            // 4
	GMCOMMAND_InventoryInfo,        // 5
	GMCOMMAND_WarehouseInfo         // 6
};

enum ELanguageType
{
	LANG_Korean,                    // 0
	LANG_English,                   // 1
	LANG_Japanese,                  // 2
	LANG_Taiwan,                    // 3
	LANG_Chinese,                   // 4
	LANG_Thai,                      // 5
	LANG_Philippine,                // 6
	LANG_Indonesia,                 // 7
	LANG_Russia,                    // 8
	LANG_Euro,                      // 9
	LANG_Germany,                   // 10
	LANG_France,                    // 11
	LANG_Poland,                    // 12
	LANG_Turkey,                    // 13
	LANG_Spain                      // 14
};

enum EIMEType
{
	IME_NONE,                       // 0
	IME_KOR,                        // 1
	IME_ENG,                        // 2
	IME_JPN,                        // 3
	IME_CHN,                        // 4
	IME_TAIWAN_CHANGJIE,            // 5
	IME_TAIWAN_DAYI,                // 6
	IME_TAIWAN_NEWPHONETIC,         // 7
	IME_TAIWAN_BOSHAMY,             // 8
	IME_CHN_MS,                     // 9
	IME_CHN_JB,                     // 10
	IME_CHN_ABC,                    // 11
	IME_CHN_WUBI,                   // 12
	IME_CHN_WUBI2,                  // 13
	IME_THAI,                       // 14
	IME_RUSSIA,                     // 15
	IME_GERMANY,                    // 16
	IME_FRANCE,                     // 17
	IME_POLAND,                     // 18
	IME_TURKEY,                     // 19
	IME_SPAIN                       // 20
};

enum EXMLControlType
{
	XCT_None,                       // 0
	XCT_FrameWnd,                   // 1
	XCT_Button,                     // 2
	XCT_TextBox,                    // 3
	XCT_EditBox,                    // 4
	XCT_TextureCtrl,                // 5
	XCT_ChatListBox,                // 6
	XCT_TabControl,                 // 7
	XCT_ItemWnd,                    // 8
	XCT_CheckBox,                   // 9
	XCT_ComboBox,                   // 10
	XCT_ProgressCtrl,               // 11
	XCT_MultiEdit,                  // 12
	XCT_ListCtrl,                   // 13
	XCT_ListBox,                    // 14
	XCT_StatusBarCtrl,              // 15
	XCT_StatusRoundCtrl,            // 16
	XCT_NameCtrl,                   // 17
	XCT_MinimapWnd,                 // 18
	XCT_ShortcutItemWnd,            // 19
	XCT_XMLTreeCtrl,                // 20
	XCT_SliderCtrl,                 // 21
	XCT_EffectButton,               // 22
	XCT_TextListBox,                // 23
	XCT_RadarWnd,                   // 24
	XCT_HtmlViewer,                 // 25
	XCT_RadioButton,                // 26
	XCT_InvenWeightWnd,             // 27
	XCT_StatusIconCtrl,             // 28
	XCT_BarCtrl,                    // 29
	XCT_ScrollWnd,                  // 30
	XCT_FishViewportWnd,            // 31
	XCT_VIPShopItemInfoWnd,         // 32
	XCT_VIPShopNeededItemWnd,       // 33
	XCT_DrawPanel,                  // 34
	XCT_RadarMapCtrl,               // 35
	XCT_PropertyController,         // 36
	XCT_FlashCtrl,                  // 37
	XCT_CharacterViewportWnd,       // 38
	XCT_SceneCameraCtrl,            // 39
	XCT_SceneNpcCtrl,               // 40
	XCT_ScenePcCtrl,                // 41
	XCT_SceneScreenCtrl,            // 42
	XCT_SceneMusicCtrl,             // 43
	XCT_RichListCtrl,               // 44
	XCT_EffectViewportWnd           // 45
};

enum ETrackerAlignType
{
	TAT_Left,                       // 0
	TAT_Center,                     // 1
	TAT_Right,                      // 2
	TAT_Width,                      // 3
	TAT_Height                      // 4
};

enum EControlPropertyGroupType
{
	CPGT_None,                      // 0
	CPGT_Single,                    // 1
	CPGT_SingleRequired,            // 2
	CPGT_Multiple,                  // 3
	CPGT_MultipleRequired,          // 4
	CPGT_Choice                     // 5
};

enum EControlPropertyItemType
{
	CPIT_None,                      // 0
	CPIT_Boolean,                   // 1
	CPIT_Integer,                   // 2
	CPIT_String                     // 3
};

enum EControlPropertyRestrictionType
{
	CPRT_None,                      // 0
	CPRT_Integer,                   // 1
	CPRT_String                     // 2
};

enum ETextLinkType
{
	TLT_None,                       // 0
	TLT_ServerItem,                 // 1
	TLT_LocalItem,                  // 2
	TLT_User,                       // 3
	TLT_SKill,                      // 4
	TLT_URL,                        // 5
	TLT_SharedPosition,             // 6
	TLT_EmojiIcon,                  // 7
	TLT_InviteParty,                // 8
	TLT_ChatMenuIcon,               // 9
	TLT_PartyRoomAnnounce           // 10
};

enum EControlOrderWay
{
	COW_None,                       // 0
	COW_Top,                        // 1
	COW_Up,                         // 2
	COW_Down,                       // 3
	COW_Bottom                      // 4
};

enum EProgressBarType
{
	PBT_None,                       // 0
	PBT_RightLeft,                  // 1
	PBT_LeftRight,                  // 2
	PBT_TopBottom,                  // 3
	PBT_BottomTop                   // 4
};

enum ETextureAutoRotateType
{
	ETART_None,                     // 0
	ETART_Camera,                   // 1
	ETART_Pawn                      // 2
};

enum EItemWindowType
{
	ITEMWNDTYPE_ScrollType,         // 0
	ITEMWNDTYPE_SideButtonType,     // 1
	ITEMWNDTYPE_UpDownButtonType    // 2
};

enum EItemWindowIconDrawType
{
	ITEMWND_IconDraw_Default,       // 0
	ITEMWND_IconDraw_NoConditionalEffect,// 1
	ITEMWND_IconDraw_ShowNewlyAcquired// 2
};

enum EAnchorPointType
{
	ANCHORPOINT_None,               // 0
	ANCHORPOINT_TopLeft,            // 1
	ANCHORPOINT_TopCenter,          // 2
	ANCHORPOINT_TopRight,           // 3
	ANCHORPOINT_CenterLeft,         // 4
	ANCHORPOINT_CenterCenter,       // 5
	ANCHORPOINT_CenterRight,        // 6
	ANCHORPOINT_BottomLeft,         // 7
	ANCHORPOINT_BottomCenter,       // 8
	ANCHORPOINT_BottomRight         // 9
};

enum EStatisticUnitType
{
	SUT_NONE,                       // 0
	SUT_HOUR,                       // 1
	SUT_MINUTE,                     // 2
	SUT_SECOND,                     // 3
	SUT_RAID,                       // 4
	SUT_TIME                        // 5
};

enum EMinimapTargetIcon
{
	TARGET_QUEST,                   // 0
	TARGET_ME                       // 1
};

enum EMinimapRegionType
{
	MRT_Castle,                     // 0
	MRT_Fortress,                   // 1
	MRT_Agit,                       // 2
	MRT_HuntingZone_Base,           // 3
	MRT_Faction,                    // 4
	MRT_HuntingZone_Mission,        // 5
	MRT_InstantZone,                // 6
	MRT_Raid,                       // 7
	MRT_Quest,                      // 8
	MRT_Etc                         // 9
};

enum EQuestStatus
{
	QuestStatus_None,               // 0
	QuestStatus_Doing,              // 1
	QuestStatus_Done                // 2
};

enum EAttributeType
{
	ATTRIBUTE_FIRE,                 // 0
	ATTRIBUTE_WATER,                // 1
	ATTRIBUTE_WIND,                 // 2
	ATTRIBUTE_EARTH,                // 3
	ATTRIBUTE_HOLY,                 // 4
	ATTRIBUTE_UNHOLY                // 5
};

enum EMixMagicType
{
	MIXMAGICTYPE_DEFAULT,           // 0
	MIXMAGICTYPE_EARTHTOGGLE,       // 1
	MIXMAGICTYPE_WINDTOGGLE,        // 2
	MIXMAGICTYPE_WATERTOGGLE,       // 3
	MIXMAGICTYPE_FIRETOGGLE,        // 4
	MIXMAGICTYPE_HOLYTOGGLE,        // 5
	MIXMAGICTYPE_UNHOLYTOGGLE,      // 6
	MIXMAGICTYPE_APPLIEDSKILL,      // 7
	MIXMAGICTYPE_ALTERSKILL,        // 8
	MIXMAGICTYPE_EQUILTOGGLE,       // 9
	MIXMAGICTYPE_RAGETOGGLE,        // 10
	MIXMAGICTYPE_ULTIMATEMAX        // 11
};

enum EMPlayerPushCategory
{
	MPPC_NONE,                      // 0
	MPPC_AUTOPLAY_OFF,              // 1
	MPPC_ATTACKED,                  // 2
	MPPC_DIE,                       // 3
	MPPC_EMPTY_VITAL_CLASSIC,       // 4
	MPPC_EMPTY_VITAL,               // 5
	MPPC_SERVER_DISCONNECT          // 6
};

enum ESearchListType
{
	SLT_FRIEND_LIST,                // 0
	SLT_PLEDGEMEMBER_LIST,          // 1
	SLT_ADDITIONALFRIEND_LIST,      // 2
	SLT_ADDITIONAL_LIST             // 3
};

enum EEventMatchObsMsgType
{
	MESSAGE_GM,                     // 0
	MESSAGE_Finish,                 // 1
	MESSAGE_Start,                  // 2
	MESSAGE_GameOver,               // 3
	MESSAGE_1,                      // 4
	MESSAGE_2,                      // 5
	MESSAGE_3,                      // 6
	MESSAGE_4,                      // 7
	MESSAGE_5                       // 8
};

enum ETextAlign
{
	TA_Undefined,                   // 0
	TA_Left,                        // 1
	TA_Center,                      // 2
	TA_Right,                       // 3
	TA_MacroIcon                    // 4
};

enum ETextVAlign
{
	TVA_Undefined,                  // 0
	TVA_Top,                        // 1
	TVA_Middle,                     // 2
	TVA_Bottom                      // 3
};

enum ETextureCtrlType
{
	TCT_Stretch,                    // 0
	TCT_Normal,                     // 1
	TCT_Tile,                       // 2
	TCT_Draggable,                  // 3
	TCT_Control,                    // 4
	TCT_Mask                        // 5
};

enum ETextureLayer
{
	TL_None,                        // 0
	TL_Normal,                      // 1
	TL_Background                   // 2
};

enum ENameCtrlType
{
	NCT_Normal,                     // 0
	NCT_Item                        // 1
};

enum EItemType
{
	ITEM_WEAPON,                    // 0
	ITEM_ARMOR,                     // 1
	ITEM_ACCESSARY,                 // 2
	ITEM_QUESTITEM,                 // 3
	ITEM_ASSET,                     // 4
	ITEM_ETCITEM                    // 5
};

enum EItemParamType
{
	ITEMP_WEAPON,                   // 0
	ITEMP_ARMOR,                    // 1
	ITEMP_SHIELD,                   // 2
	ITEMP_ACCESSARY,                // 3
	ITEMP_ETC                       // 4
};

enum EEtcItemType
{
	ITEME_NONE,                     // 0
	ITEME_SCROLL,                   // 1
	ITEME_ARROW,                    // 2
	ITEME_POTION,                   // 3
	ITEME_SPELLBOOK,                // 4
	ITEME_RECIPE,                   // 5
	ITEME_MATERIAL,                 // 6
	ITEME_PET_COLLAR,               // 7
	ITEME_CASTLE_GUARD,             // 8
	ITEME_DYE,                      // 9
	ITEME_SEED,                     // 10
	ITEME_SEED2,                    // 11
	ITEME_HARVEST,                  // 12
	ITEME_LOTTO,                    // 13
	ITEME_RACE_TICKET,              // 14
	ITEME_TICKET_OF_LORD,           // 15
	ITEME_LURE,                     // 16
	ITEME_CROP,                     // 17
	ITEME_MATURECROP,               // 18
	ITEME_ENCHT_WP,                 // 19
	ITEME_ENCHT_AM,                 // 20
	ITEME_BLESS_ENCHT_WP,           // 21
	ITEME_BLESS_ENCHT_AM,           // 22
	ITEME_COUPON,                   // 23
	ITEME_ELIXIR,                   // 24
	ITEME_ENCHT_ATTR,               // 25
	ITEME_ENCHT_ATTR_CURSED,        // 26
	ITEME_BOLT,                     // 27
	ITEME_ENCHT_ATTR_INC_PROP_ENCHT_WP,// 28
	ITEME_ENCHT_ATTR_INC_PROP_ENCHT_AM,// 29
	ITEME_ENCHT_ATTR_CRYSTAL_ENCHANT_AM,// 30
	ITEME_ENCHT_ATTR_CRYSTAL_ENCHANT_WP,// 31
	ITEME_ENCHT_ATTR_ANCIENT_CRYSTAL_ENCHANT_AM,// 32
	ITEME_ENCHT_ATTR_ANCIENT_CRYSTAL_ENCHANT_WP,// 33
	ITEME_ENCHT_ATTR_RUNE,          // 34
	ITEME_ENCHT_ATTRT_RUNE_SELECT,  // 35
	ITEME_TELEPORTBOOKMARK,         // 36
	ITEME_CHANGE_ATTR,              // 37
	ITEME_SOULSHOT,                 // 38
	ITEME_SHAPE_SHIFTING_WP,        // 39
	ITEME_BLESS_SHAPE_SHIFTING_WP,  // 40
	ITEME_SHAPE_SHIFTING_WP_FIXED,  // 41
	ITEME_SHAPE_SHIFTING_AM,        // 42
	ITEME_BLESS_SHAPE_SHIFTING_AM,  // 43
	ITEME_SHAPE_SHIFTING_AM_FIXED,  // 44
	ITEME_SHAPE_SHIFTING_HAIRACC,   // 45
	ITEME_BLESS_SHAPE_SHIFTING_HAIRACC,// 46
	ITEME_SHAPE_SHIFTING_HAIRACC_FIXED,// 47
	ITEME_RESTORE_SHAPE_SHIFTING_WP,// 48
	ITEME_RESTORE_SHAPE_SHIFTING_AM,// 49
	ITEME_RESTORE_SHAPE_SHIFTING_HAIRACC,// 50
	ITEME_RESTORE_SHAPE_SHIFTING_ALLITEM,// 51
	ITEME_BLESS_INC_PROP_ENCHT_WP,  // 52
	ITEME_BLESS_INC_PROP_ENCHT_AM,  // 53
	ITEME_CARD_EVENT,               // 54
	ITEME_SHAPE_SHIFTING_ALLITEM_FIXED,// 55
	ITEME_MULTI_ENCHT_WP,           // 56
	ITEME_MULTI_ENCHT_AM,           // 57
	ITEME_MULTI_INC_PROB_ENCHT_WP,  // 58
	ITEME_MULTI_INC_PROB_ENCHT_AM,  // 59
	ITEME_NICK_COLOR_OLD,           // 60
	ITEME_NICK_COLOR_NEW,           // 61
	ITEME_ENSOUL_STONE,             // 62
	ITEME_ENCHT_AG,                 // 63
	ITEME_BLESS_ENCHT_AG,           // 64
	ITEME_MULTI_ENCHT_AG,           // 65
	ITEME_ANCIENT_CRYSTAL_ENCHANT_AG,// 66
	ITEME_INC_PROP_ENCHT_AG,        // 67
	ITEME_BLESS_INC_PROP_ENCHT_AG,  // 68
	ITEME_MULTI_INC_PROB_ENCHT_AG,  // 69
	ITEME_LOCK_ITEM,                // 70
	ITEME_UNLOCK_ITEM,              // 71
	ITEME_BULLET,                   // 72
	ITEME_MAGIC_LAMP,               // 73
	ITEME_COSTUME_BOOK,             // 74
	ITEME_COSTUME_BOOK_RD_ALL,      // 75
	ITEME_COSTUME_BOOK_RD_PART,     // 76
	ITEME_COSTUME_BOOK_1,           // 77
	ITEME_COSTUME_BOOK_2,           // 78
	ITEME_COSTUME_BOOK_3,           // 79
	ITEME_COSTUME_BOOK_4,           // 80
	ITEME_COSTUME_BOOK_5,           // 81
	ITEME_POLY_ENCHANT_WP,          // 82
	ITEME_POLY_ENCHANT_AM,          // 83
	ITEME_POLY_INC_ENCHANT_PROP_WP, // 84
	ITEME_POLY_INC_ENCHANT_PROP_AM, // 85
	ITEME_CURSED_ENCHANT_WP,        // 86
	ITEME_CURSED_ENCHANT_AM,        // 87
	ITEME_BLESS_UPGRADE,            // 88
	ITEME_ORB,                      // 89
	ITEME_ITEM_RESTORE_COIN,        // 90
	ITEME_SPECIAL_ENCHT_WP,         // 91
	ITEME_SPECIAL_ENCHT_AM,         // 92
	ITEME_NICK_COLOR_ICON,          // 93
	ITEME_TRADE_TICKET,             // 94
	ITEME_PET_FOODER,               // 95
	ITEME_VITAL_POTION,             // 96
	ITEME_RELICS_SUMMON             // 97
};

enum ESkillCategory
{
	SKILL_Active,                   // 0
	SKILL_Passive                   // 1
};

enum EActionCategory
{
	ACTION_NONE,                    // 0
	ACTION_BASIC,                   // 1
	ACTION_PARTY,                   // 2
	ACTION_TACTICALSIGN,            // 3
	ACTION_SOCIAL,                  // 4
	ACTION_PET,                     // 5
	ACTION_SUMMON,                  // 6
	ACTION_SUMMON_DIRECT,           // 7
	ACTION_SUMMON_AI,               // 8
	ACTION_SUMMON_REACT,            // 9
	ACTION_SUMMON_SKILL             // 10
};

enum EXMLTreeNodeItemType
{
	XTNITEM_BLANK,                  // 0
	XTNITEM_TEXT,                   // 1
	XTNITEM_TEXTURE                 // 2
};

enum EServerAgeLimit
{
	SERVER_AGE_LIMIT_15,            // 0
	SERVER_AGE_LIMIT_18,            // 1
	SERVER_AGE_LIMIT_Free           // 2
};

enum EInterfaceSoundType
{
	IFST_CLICK1,                    // 0
	IFST_CLICK2,                    // 1
	IFST_CLICK_FAILED,              // 2
	IFST_PICKUP,                    // 3
	IFST_TRASH_BASKET,              // 4
	IFST_WINDOW_OPEN,               // 5
	IFST_WINDOW_CLOSE,              // 6
	IFST_QUEST_TUTORIAL,            // 7
	IFST_MINIMAP_OPEN_CLOSE,        // 8
	IFST_COOLTIME_END,              // 9
	IFST_PETITION,                  // 10
	IFST_STATUSWND_OPEN,            // 11
	IFST_STATUSWND_CLOSE,           // 12
	IFST_INVENWND_OPEN,             // 13
	IFST_INVENWND_CLOSE,            // 14
	IFST_MAPWND_OPEN,               // 15
	IFST_MAPWND_CLOSE,              // 16
	IFST_SYSTEMWND_OPEN,            // 17
	IFST_SYSTEMWND_CLOSE,           // 18
	IFST_WORKSHOP_OPEN,             // 19
	IFST_WORKSHOP_CLOSE,            // 20
	IFST_SYSTEMWND_TELEAUTHFAIL     // 21
};

enum SayPacketType
{
	SPT_NORMAL,                     // 0
	SPT_SHOUT,                      // 1
	SPT_TELL,                       // 2
	SPT_PARTY,                      // 3
	SPT_PLEDGE,                     // 4
	SPT_SYSTEM,                     // 5
	SPT_USER_PET,                   // 6
	SPT_GM_PET,                     // 7
	SPT_MARKET,                     // 8
	SPT_ALLIANCE,                   // 9
	SPT_ANNOUNCE,                   // 10
	SPT_CUSTOM,                     // 11
	SPT_L2_FRIEND,                  // 12
	SPT_MSN_CHAT,                   // 13
	SPT_PARTY_ROOM_CHAT,            // 14
	SPT_COMMANDER_CHAT,             // 15
	SPT_INTER_PARTYMASTER_CHAT,     // 16
	SPT_HERO,                       // 17
	SPT_CRITICAL_ANNOUNCE,          // 18
	SPT_SCREEN_ANNOUNCE,            // 19
	SPT_DOMINIONWAR,                // 20
	SPT_MPCC_ROOM_CHAT,             // 21
	SPT_NPC_NORMAL,                 // 22
	SPT_NPC_SHOUT,                  // 23
	SPT_FRIEND_ANNOUNCE,            // 24
	SPT_WORLD,                      // 25
	SPT_PLEDGE_INRAIDSERVER,        // 26
	SPT_ALLIANCE_INRAIDSERVER,      // 27
	SPT_CASTLEWAR_PLEDGE_COMMAND_MSG,// 28
	SPT_WORLD_INRAIDSERVER          // 29
};

enum ESystemMsgType
{
	SYSTEM_NONE,                    // 0
	SYSTEM_BATTLE,                  // 1
	SYSTEM_SERVER,                  // 2
	SYSTEM_DAMAGE,                  // 3
	SYSTEM_POPUP,                   // 4
	SYSTEM_ERROR,                   // 5
	SYSTEM_PETITION,                // 6
	SYSTEM_USEITEMS,                // 7
	SYSTEM_POPUPWITHMSG,            // 8
	SYSTEM_DAMAGETEXT,              // 9
	SYSTEM_CLIENT_DEBUG_MSG,        // 10
	SYSTEM_GETITEMS,                // 11
	SYSTEM_DICE,                    // 12
	SYSTEM_ESSENTIAL                // 13
};

enum ESystemMsgParamType
{
	SMPT_STRING,                    // 0
	SMPT_NUMBER,                    // 1
	SMPT_NPCID,                     // 2
	SMPT_ITEMID,                    // 3
	SMPT_SKILLID,                   // 4
	SMPT_CASTLEID,                  // 5
	SMPT_BIGNUMBER,                 // 6
	SMPT_ZONENAME                   // 7
};

enum EMoveType
{
	MVT_NONE,                       // 0
	MVT_SLOW,                       // 1
	MVT_FAST                        // 2
};

enum EEnvType
{
	ET_NONE,                        // 0
	ET_GROUND,                      // 1
	ET_UNDERWATER,                  // 2
	ET_AIR,                         // 3
	ET_HOVER                        // 4
};

enum EControlReturnType
{
	CRTT_NO_CONTROL_USE,            // 0
	CRTT_CONTROL_USE,               // 1
	CRTT_USE_AND_HIDE               // 2
};

enum EShortCutItemType
{
	SCIT_NONE,                      // 0
	SCIT_ITEM,                      // 1
	SCIT_SKILL,                     // 2
	SCIT_ACTION,                    // 3
	SCIT_MACRO,                     // 4
	SCIT_RECIPE,                    // 5
	SCIT_BOOKMARK,                  // 6
	SCIT_ATTRIBUTE,                 // 7
	SCIT_DELETED_ITEM               // 8
};

enum EInventoryUpdateType
{
	IVUT_NONE,                      // 0
	IVUT_ADD,                       // 1
	IVUT_UPDATE,                    // 2
	IVUT_DELETE                     // 3
};

enum RestartPoint
{
	RESTART_VILLAGE,                // 0
	RESTART_AGIT,                   // 1
	RESTART_CASTLE,                 // 2
	RESTART_FORTRESS,               // 3
	RESTART_BATTLE_CAMP,            // 4
	RESTART_ORIGINAL_PLACE,         // 5
	RESTART_VILLAGE_BY_DISMOUNT,    // 6
	RESTART_ORIGINAL_PLACE_LIMIT,   // 7
	RESTART_ARENA,                  // 8
	RESTART_VILLAGE_USING_ITEM,     // 9
	RESTART_DUMMY_10,               // 10
	RESTART_DUMMY_11,               // 11
	RESTART_DUMMY_12,               // 12
	RESTART_DUMMY_13,               // 13
	RESTART_DUMMY_14,               // 14
	RESTART_DUMMY_15,               // 15
	RESTART_DUMMY_16,               // 16
	RESTART_DUMMY_17,               // 17
	RESTART_DUMMY_18,               // 18
	RESTART_DUMMY_19,               // 19
	RESTART_BRANCH_START,           // 20
	RESTART_BY_AGATHION,            // 21
	RESTART_BY_NPC,                 // 22
	RESURRECT_BY_SKILL,             // 23
	RESTART_NEARBY_BATTLE_FIELD,    // 24
	RESTART_TIME_FIELD_START_POS    // 25
};

enum ECastleSiegeDefenderType
{
	CSDT_NOT_DEFENDER,              // 0
	CSDT_CASTLE_OWNER,              // 1
	CSDT_WAITING_CONFIRM,           // 2
	CSDT_APPROVED,                  // 3
	CSDT_REJECTED                   // 4
};

enum ETooltipSourceType
{
	NTST_TEXT,                      // 0
	NTST_ITEM,                      // 1
	NTST_LIST,                      // 2
	NTST_LIST_DRAWITEM              // 3
};

enum EBR_CashShopProduct
{
	BRCSP_PRODUCT,                  // 0
	BRCSP_RECENT,                   // 1
	BRCSP_BASKET                    // 2
};

enum EClassIconType
{
	CICON_LEVEL_TWO_WARRIOR,        // 0
	CICON_LEVEL_TWO_ROGUE,          // 1
	CICON_LEVEL_TWO_ARCHER,         // 2
	CICON_LEVEL_TWO_FIGHTER,        // 3
	CICON_LEVEL_TWO_SONGDANCER,     // 4
	CICON_LEVEL_TWO_WIZARD,         // 5
	CICON_LEVEL_TWO_HEALER,         // 6
	CICON_LEVEL_TWO_SUMMONER,       // 7
	CICON_LEVEL_ONE_WARRIOR,        // 8
	CICON_LEVEL_ONE_WIZARD,         // 9
	CICON_LEVEL_THREE_WARRIOR,      // 10
	CICON_LEVEL_THREE_ROGUE,        // 11
	CICON_LEVEL_THREE_ARCHER,       // 12
	CICON_LEVEL_THREE_FIGHTER,      // 13
	CICON_LEVEL_THREE_SONGDANCER,   // 14
	CICON_LEVEL_THREE_WIZARD,       // 15
	CICON_LEVEL_THREE_HEALER,       // 16
	CICON_LEVEL_THREE_SUMMONER,     // 17
	CICON_LEVEL_FOUR_FIGHTER,       // 18
	CICON_LEVEL_FOUR_WARRIOR,       // 19
	CICON_LEVEL_FOUR_ROGUE,         // 20
	CICON_LEVEL_FOUR_ARCHER,        // 21
	CICON_LEVEL_FOUR_WIZARD,        // 22
	CICON_LEVEL_FOUR_ENCHANTER,     // 23
	CICON_LEVEL_FOUR_SUMMONER,      // 24
	CICON_LEVEL_FOUR_HEALER,        // 25
	CICON_LEVEL_FIVE_FIGHTER,       // 26
	CICON_LEVEL_FIVE_WARRIOR,       // 27
	CICON_LEVEL_FIVE_ROGUE,         // 28
	CICON_LEVEL_FIVE_ARCHER,        // 29
	CICON_LEVEL_FIVE_WIZARD,        // 30
	CICON_LEVEL_FIVE_ENCHANTER,     // 31
	CICON_LEVEL_FIVE_SUMMONER,      // 32
	CICON_LEVEL_FIVE_HEALER         // 33
};

enum EClassRoleType
{
	ECRT_NONE,                      // 0
	ECRT_KNIGHT,                    // 1
	ECRT_WARRIOR,                   // 2
	ECRT_ROGUE,                     // 3
	ECRT_ARCHOR,                    // 4
	ECRT_WIZARD,                    // 5
	ECRT_SUMMONER,                  // 6
	ECRT_ENCHANTER,                 // 7
	ECRT_SUPPORT,                   // 8
	ECRT_NOVICE,                    // 9
	ECRT_SHAMAN,                    // 10
	ECRT_BARD,                      // 11
	ECRT_DEATHKNIGHT,               // 12
	ECRT_HUNTER                     // 13
};

enum EItemInventoryType
{
	EIIT_NONE,                      // 0
	EIIT_EQUIPMENT,                 // 1
	EIIT_CONSUMABLE,                // 2
	EIIT_MATERIAL,                  // 3
	EIIT_ETC,                       // 4
	EIIT_QUEST                      // 5
};

enum ECharacterDeleteFailType
{
	ECDFT_NONE,                     // 0
	ECDFT_UNKNOWN,                  // 1
	ECDFT_PLEDGE_MEMBER,            // 2
	ECDFT_PLEDGE_MASTER,            // 3
	ECDFT_PROHIBIT_CHAR_DELETION,   // 4
	ECDFT_COMMISSION,               // 5
	ECDFT_MENTOR,                   // 6
	ECDFT_MENTEE,                   // 7
	ECDFT_MAIL                      // 8
};

enum ETimerCheckType
{
	ETCT_STEADYBOX                  // 0
};

enum EPetType
{
	PT_Normal,                      // 0
	PT_Mercenary                    // 1
};

enum AttackType
{
	AT_NONE,                        // 0
	AT_SWORD,                       // 1
	AT_TWOHANDSWORD,                // 2
	AT_BUSTER,                      // 3
	AT_BLUNT,                       // 4
	AT_TWOHANDBLUNT,                // 5
	AT_STAFF,                       // 6
	AT_TWOHANDSTAFF,                // 7
	AT_DAGGER,                      // 8
	AT_POLE,                        // 9
	AT_FIST,                        // 10
	AT_BOW,                         // 11
	AT_ETC,                         // 12
	AT_DUAL,                        // 13
	AT_DUALFIST,                    // 14
	AT_FISHINGROD,                  // 15
	AT_RAPIER,                      // 16
	AT_CROSSBOW,                    // 17
	AT_ANCIENTSWORD,                // 18
	AT_FLAG,                        // 19
	AT_DUALDAGGER,                  // 20
	AT_OWNTHING,                    // 21
	AT_TWOHANDCROSSBOW,             // 22
	AT_DUALBLUNT,                   // 23
	AT_PISTOL,                      // 24
	AT_SHOOTER,                     // 25
	AT_MAX                          // 26
};

enum ArmorType
{
	AMT_NONE,                       // 0
	AMT_LIGHT,                      // 1
	AMT_HEAVY,                      // 2
	AMT_MAGIC,                      // 3
	AMT_SIGIL                       // 4
};

enum EBlessPanelDrawType
{
	BPDT_NEED_NONE,                 // 0
	BPDT_NEED_BLESS,                // 1
	BPDT_NEED_NO_BLESS              // 2
};

enum EItemUIAction
{
	IUIA_NONE,                      // 0
	IUIA_SHOW_DYE,                  // 1
	IUIA_SHOW_POTENTIAL,            // 2
	IUIA_SHOW_ADENLAB               // 3
};

enum EListCtlDrawItemType
{
	LCDIT_TEXT,                     // 0
	LCDIT_TEXTURE,                  // 1
	LCDIT_BUTTON,                   // 2
	LCDIT_ITEM,                     // 3
	LCDIT_STATUS,                   // 4
	LCDIT_SKILL,                    // 5
	LCDIT_PLEDGECREST               // 6
};

enum ESkillTraitType
{
	ESkillTrait_None,               // 0
	ESkillTrait_Hold,               // 1
	ESkillTrait_Infection,          // 2
	ESkillTrait_Sleep,              // 3
	ESkillTrait_Shock,              // 4
	ESkillTrait_Paralyze,           // 5
	ESkillTrait_Seal,               // 6
	ESkillTrait_Pull,               // 7
	ESkillTrait_Silence,            // 8
	ESkillTrait_Fear,               // 9
	ESkillTrait_SlowDown,           // 10
	ESkillTrait_TurnStone,          // 11
	ESkillTrait_Disarm,             // 12
	ESkillTrait_Hate,               // 13
	ESkillTrait_PhysicalBlockade,   // 14
	ESkillTrait_RootPhysically,     // 15
	ESkillTrait_Deport,             // 16
	ESkillTrait_Bluff,              // 17
	ESkillTrait_Poison,             // 18
	ESkillTrait_Bleed,              // 19
	ESkillTrait_Changebody,         // 20
	ESkillTrait_Derangement,        // 21
	ESkillTrait_AirBind,            // 22
	ESkillTrait_WindStun,           // 23
	ESkillTrait_Psychic,            // 24
	ESkillTrait_KnockBack,          // 25
	ESkillTrait_KnockDown,          // 26
	ESkillTrait_Max                 // 27
};

enum ESkillTargetType
{
	ESkillTarget_None,              // 0
	ESkillTarget_Enemy,             // 1
	ESkillTarget_EnemyOnly,         // 2
	ESkillTarget_EnemyNot,          // 3
	ESkillTarget_Self,              // 4
	ESkillTarget_Summon,            // 5
	ESkillTarget_Target,            // 6
	ESkillTarget_TargetSelf,        // 7
	ESkillTarget_RealEnemyOnly,     // 8
	ESkillTarget_Max                // 9
};

enum ESkillAffectScope
{
	ESkillAffect_None,              // 0
	ESkillAffect_Single,            // 1
	ESkillAffect_Party,             // 2
	ESkillAffect_Pledge,            // 3
	ESkillAffect_Fan,               // 4
	ESkillAffect_PointBlank,        // 5
	ESkillAffect_RangeSortByDist,   // 6
	ESkillAffect_RangeSortByHp,     // 7
	ESkillAffect_Range,             // 8
	ESkillAffect_Square,            // 9
	ESkillAffect_Range_sort_by_block_act,// 10
	ESkillAffect_Fan_with_relation, // 11
	ESkillAffect_Point_blank_with_relation,// 12
	ESkillAffect_Range_with_relation,// 13
	ESkillAffect_Square_with_relation,// 14
	ESkillAffect_Max                // 15
};

enum ESkillConditionEquipType
{
	SCET_NONE,                      // 0
	SCET_SHIELD,                    // 1
	SCET_WEAPON,                    // 2
	SCET_MAX                        // 3
};

enum E_CHARACTER_COLOR
{
	ECC_NONE,                       // 0
	ECC_RED,                        // 1
	ECC_BLUE,                       // 2
	ECC_PURPLE,                     // 3
	ECC_MAX                         // 4
};

enum EDrawItemType
{
	DIT_BLANK,                      // 0
	DIT_TEXT,                       // 1
	DIT_TEXTURE,                    // 2
	DIT_SPLITLINE,                  // 3
	DIT_TEXTLINK,                   // 4
	DIT_OVERLAY_TEXTURE,            // 5
	DIT_FORMATTEXT                  // 6
};

enum EDrawItemAlignType
{
	DIAT_LEFT,                      // 0
	DIAT_CENTER,                    // 1
	DIAT_RIGHT,                     // 2
	DIAT_RIGHT_BOTTOM               // 3
};

enum EKeepType
{
	EKT_NONE,                       // 0
	EKT_INDIVIDUAL,                 // 1
	EKT_PLEDGE,                     // 2
	EKT_INDIVIDUAL_PLEDGE,          // 3
	EKT_CASTLE,                     // 4
	EKT_INDIVIDUAL_CASTLE,          // 5
	EKT_PLEDGE_CASTLE,              // 6
	EKT_ALL,                        // 7
	EKT_ACCOUNTSHARE,               // 8
	EKT_INDIVIDUAL_ACCOUNTSHARE,    // 9
	EKT_PLEDGE_ACCOUNTSHARE,        // 10
	EKT_INDIVIDUAL_PLEDGE_ACCOUNTSHARE,// 11
	EKT_CASTLE_ACCOUNTSHARE,        // 12
	EKT_INDIVIDUAL_CASTLE_ACCOUNTSHARE,// 13
	EKT_PLEDGE_CASTLE_ACCOUNTSHARE, // 14
	EKT_ALL_ACCOUNTSHARE            // 15
};

enum EKeepSelectType
{
	EKST_NORMAL,                    // 0
	EKST_ENCHANT                    // 1
};

enum EFactionRequsetType
{
	FIRT_NONE,                      // 0
	FIRT_SHOW,                      // 1
	FIRT_REFRESH                    // 2
};

enum EWebMethodType
{
	EWMT_GET,                       // 0
	EWMT_POST                       // 1
};

enum EAutoNextTargetMode
{
	ANTM_DEFAULT,                   // 0
	ANTM_HOSTILE_NPC,               // 1
	ANTM_HOSTILE_PC,                // 2
	ANTM_FRIENDLY_NPC,              // 3
	ANTM_DEFAULT_AND_COUNTER_ATTACK,// 4
	ANTM_MAX                        // 5
};

enum EAutomaticUseItemType
{
	AUIT_NONE,                      // 0
	AUIT_ITEM,                      // 1
	AUIT_HP_POTION,                 // 2
	AUIT_HP_PET_POTION,             // 3
	AUIT_BOX,                       // 4
	AUIT_MAX                        // 5
};

enum EOnedayRewardCheckType
{
	OneDayRCT_CHAR,                 // 0
	OneDayRCT_ACCOUNT,              // 1
	OneDayRCT_ACCOUNT_WORLD,        // 2
	OneDayRCT_MAX                   // 3
};

enum EAutomaticUseSkillType
{
	AUST_NONE,                      // 0
	AUST_BUFF_SKILL,                // 1
	AUST_SEQUENTIAL_SKILL,          // 2
	AUST_PRIORITY_BUFF_SKILL,       // 3
	AUST_MAX                        // 4
};

enum PLSHOP_RESET_TYPE
{
	PLSHOP_RESET_ALWAYS,            // 0
	PLSHOP_RESET_ONEDAY,            // 1
	PLSHOP_RESET_ONEWEEK,           // 2
	PLSHOP_RESET_ONEMONTH,          // 3
	PLSHOP_RESET_ONEDAY2,           // 4
	PLSHOP_RESET_TYPE_MAX           // 5
};

enum PLSHOP_EVENT_TYPE
{
	PLSHOP_EVNET_NONE,              // 0
	PLSHOP_LIMITED_PERIOD           // 1
};

enum PLSHOP_BUY_RESULT_TYPE
{
	PLSHOP_BUY_SUCCESS,             // 0
	PLSHOP_BUY_SYSTEM_FAIL,         // 1
	PLSHOP_BUY_NOT_ENOUGH_COST_ITEM,// 2
	PLSHOP_BUY_NOT_ENOUGH_ITEM_AMOUNT,// 3
	PLSHOP_BUY_NOT_ENOUGH_LEVEL,    // 4
	PLSHOP_BUY_NOT_EVENT_TIME,      // 5
	PLSHOP_BUY_NOT_ENOUGH_SERVER_ITEM_AMOUNT,// 6
	PLSHOP_BUY_NOT_ENOUGH_INVENTORY,// 7
	PLSHOP_BUY_NOT_ENOUGH_CARRY_WEIGHT,// 8
	PLSHOP_BUY_NOT_ENOUGH_PLEDGE_LEVEL,// 9
	PLSHOP_BUY_NOT_ALIVE,           // 10
	PLSHOP_BUY_RESULT_TYPE_MAX      // 11
};

enum PLSHOP_LIMIT_TYPE
{
	PLSHOP_LIMIT_NONE,              // 0
	PLSHOP_LIMIT_CHARACTER,         // 1
	PLSHOP_LIMIT_ACCOUNT,           // 2
	PLSHOP_LIMIT_SERVER,            // 3
	PLSHOP_LIMIT_WORLD_ACCOUNT,     // 4
	PLSHOP_LIMIT_TYPE_MAX           // 5
};

enum ELCoinShopMarkType
{
	LCoinShopMark_None,             // 0
	LCoinShopMark_Event,            // 1
	LCoinShopMark_Sale,             // 2
	LCoinShopMark_Best,             // 3
	LCoinShopMark_Limited,          // 4
	LCoinShopMark_New,              // 5
	LCoinShopMark_Relay,            // 6
	LCoinShopMark_Account,          // 7
	LCoinShopMark_Character,        // 8
	LCoinShopMark_Server,           // 9
	LCoinShopMark_Max               // 10
};

enum ELCoinShopFilterType
{
	LCoinShopFilter_None,           // 0
	LCoinShopFilter_RareWeapon,     // 1
	LCoinShopFilter_NormalWeapon,   // 2
	LCoinShopFilter_RareArmor,      // 3
	LCoinShopFilter_HeavyArmor,     // 4
	LCoinShopFilter_LightArmor,     // 5
	LCoinShopFilter_Robe,           // 6
	LCoinShopFilter_Shield,         // 7
	LCoinShopFilter_Dye,            // 8
	LCoinShopFilter_Scroll,         // 9
	LCoinShopFilter_Etc,            // 10
	LCoinShopFilter_Belt,           // 11
	LCoinShopFilter_Elixir,         // 12
	LCoinShopFilter_Skillbook_S1,   // 13
	LCoinShopFilter_Skillbook_S2,   // 14
	LCoinShopFilter_Skillbook_S3,   // 15
	LCoinShopFilter_Max             // 16
};

enum HTML_OPEN_TYPE
{
	OPEN_HTML_NONE_TYPE,            // 0
	OPEN_PCCAFE_HTML,               // 1
	OPEN_PLSHOP_HTML,               // 2
	OPEN_15EVENT_HTML,              // 3
	OPEN_LCOINSHOP_HTML,            // 4
	OPEN_PREMIUM_MANAGER,           // 5
	OPEN_PAYBACK_HELP_HTML,         // 6
	OPEN_EINHASAD_COIN_HTML,        // 7
	OPEN_HTML_MAX_TYPE              // 8
};

enum PAYBACK_EVENT_ID_TYPE
{
	CR_EVENT_INVALID,               // 0
	CR_EVENT_LCOIN_2018,            // 1
	CR_EVENT_MAX                    // 2
};

enum AttackerTypeEnum
{
	ATTACKER_NONE,                  // 0
	ATTACKER_NPC,                   // 1
	ATTACKER_PC                     // 2
};

enum DamageTypeEnum
{
	DAMAGE_NONE,                    // 0
	DAMAGE_NORMAL,                  // 1
	DAMAGE_HEIGHT,                  // 2
	DAMAGE_WATER,                   // 3
	DAMAGE_SKILL,                   // 4
	DAMAGE_SUICIDE,                 // 5
	DAMAGE_AREA,                    // 6
	DAMAGE_OVER_HIT,                // 7
	DAMAGE_POISON,                  // 8
	DAMAGE_TRANSFER,                // 9
	DAMAGE_CHRONO,                  // 10
	DAMAGE_CURSED_WEAPON_EXPIRED,   // 11
	DAMAGE_FIST,                    // 12
	DAMAGE_SUICIDE_SKILL,           // 13
	DAMAGE_SHIELD,                  // 14
	DAMAGE_EVENT,                   // 15
	DAMAGE_END                      // 16
};

enum GACHA_SHOP_RESULT_TYPE
{
	GACHA_SHOP_GACHA_SUCESS,        // 0
	GACHA_SHOP_GACHA_SYSTEM_FAIL,   // 1
	GACHA_SHOP_NOT_ENOUGH_COST_ITEM,// 2
	GACHA_SHOP_NOT_EVENT_TIME       // 3
};

enum RankingGroup
{
	ServerGroup,                    // 0
	RaceGroup,                      // 1
	Pledge,                         // 2
	Friends,                        // 3
	ClassRankingGroup               // 4
};

enum RankingScope
{
	TopN,                           // 0
	AroundMe                        // 1
};

enum RankingType
{
	RANKTYPE_Character,             // 0
	RANKTYPE_Olympiad,              // 1
	RANKTYPE_Pledge,                // 2
	RANKTYPE_PVP,                   // 3
	RANKTYPE_MAX                    // 4
};

enum StatBonusType
{
	SBT_STR,                        // 0
	SBT_INT,                        // 1
	SBT_DEX,                        // 2
	SBT_WIT,                        // 3
	SBT_CON,                        // 4
	SBT_MEN,                        // 5
	SBT_MAX                         // 6
};

enum RaidNPCRespawnType
{
	RNRT_NoUse,                     // 0
	RNRT_Unknown,                   // 1
	RNRT_AfterDeath,                // 2
	RNRT_SpecificTime,              // 3
	RNRT_SpecificDayTime,           // 4
	RNRT_MAX                        // 5
};

enum RandomCraftAnnounceGrade
{
	RCAG_None,                      // 0
	RCAG_1,                         // 1
	RCAG_2,                         // 2
	RCAG_3                          // 3
};

enum MableGameEventType
{
	MGET_NONE,                      // 0
	MGET_BACK,                      // 1
	MGET_NEXT,                      // 2
	MGET_WARP,                      // 3
	MGET_PRISON,                    // 4
	MGET_REWARD                     // 5
};

enum PetEvolveConditionType
{
	PECT_NONE,                      // 0
	PECT_LEVEL                      // 1
};

enum EBlessRepeatType
{
	EBT_NONE,                       // 0
	EBT_REPEAT                      // 1
};

enum EItemAnnounce
{
	IA_ENCHANT,                     // 0
	IA_REAR_ITEM,                   // 1
	IA_CRAFT,                       // 2
	IA_PURCHASE_LIMIT_SHOP,         // 3
	IA_RECIPE,                      // 4
	IA_FESTIVAL,                    // 5
	IA_PURCHASE_LIMIT_SERVER_CRAFT, // 6
	IA_FIXED_REAR_ITEM,             // 7
	IA_COMBINATION,                 // 8
	IA_PURCHASE_SPECIAL_CRAFT,      // 9
	IA_UPGRADE_ITEM,                // 10
	IA_SERVERWAR_ITEM               // 11
};

enum EWorldCastleWarMapNPCType
{
	WCWMNT_Occupy,                  // 0
	WCWMNT_Door,                    // 1
	WCWMNT_Golem                    // 2
};

enum ECombinationResultBlessType
{
	CRBT_BLESS_IGNORE,              // 0
	CRBT_BLESS_KEEP_ALL,            // 1
	CRBT_BLESS_KEEP_SUCCESS,        // 2
	CRBT_BLESS_KEEP_FAIL            // 3
};

enum ECombinationResultEffectType
{
	CRET_DEFAULT,                   // 0
	CRET_NOFAIL,                    // 1
	CRET_NONE,                      // 2
	CRET_MAX                        // 3
};

enum ECombinationAutomaticType
{
	ECAT_NONE,                      // 0
	ECAT_REPEAT,                    // 1
	ECAT_GROWNUP,                   // 2
	ECAT_LEVELUP,                   // 3
	ECAT_MAX                        // 4
};

enum EScalableSizeType
{
	SSIZE_Type1,                    // 0
	SSIZE_Type2,                    // 1
	SSIZE_Type3,                    // 2
	SSIZE_Type4,                    // 3
	SSIZE_Type5,                    // 4
	SSIZE_Type6,                    // 5
	SSIZE_Type7,                    // 6
	SSIZE_Type8,                    // 7
	SSIZE_Type9,                    // 8
	SSIZE_Type10,                   // 9
	SSIZE_Type11,                   // 10
	SSIZE_Type12,                   // 11
	SSIZE_Type13,                   // 12
	SSIZE_Type14,                   // 13
	SSIZE_Type15,                   // 14
	SSIZE_Type16,                   // 15
	SSIZE_Type17,                   // 16
	SSIZE_Type18,                   // 17
	SSIZE_Type19,                   // 18
	SSIZE_Type20,                   // 19
	SSIZE_Type21,                   // 20
	SSIZE_Type22,                   // 21
	SSIZE_Type23,                   // 22
	SSIZE_Type24,                   // 23
	SSIZE_Type25,                   // 24
	SSIZE_Type26,                   // 25
	SSIZE_Type27,                   // 26
	SSIZE_Type28,                   // 27
	SSIZE_Type29,                   // 28
	SSIZE_Type30,                   // 29
	SSIZE_Type31,                   // 30
	SSIZE_Type32,                   // 31
	SSIZE_Type33,                   // 32
	SSIZE_Type34,                   // 33
	SSIZE_Type35,                   // 34
	SSIZE_Type36,                   // 35
	SSIZE_Type37,                   // 36
	SSIZE_Type38,                   // 37
	SSIZE_Type39,                   // 38
	SSIZE_Type40,                   // 39
	SSIZE_Type41,                   // 40
	SSIZE_Type42,                   // 41
	SSIZE_Type43,                   // 42
	SSIZE_Type44,                   // 43
	SSIZE_Type45,                   // 44
	SSIZE_Type46,                   // 45
	SSIZE_Type47,                   // 46
	SSIZE_Type48,                   // 47
	SSIZE_Type49,                   // 48
	SSIZE_Type50,                   // 49
	SSIZE_Type51,                   // 50
	SSIZE_Type52,                   // 51
	SSIZE_Type53,                   // 52
	SSIZE_Type54,                   // 53
	SSIZE_Type55,                   // 54
	SSIZE_Type56,                   // 55
	SSIZE_Type57,                   // 56
	SSIZE_Type58,                   // 57
	SSIZE_Type59,                   // 58
	SSIZE_Type60,                   // 59
	SSIZE_Type61,                   // 60
	SSIZE_Type62,                   // 61
	SSIZE_Type63,                   // 62
	SSIZE_Type64,                   // 63
	SSIZE_Type65,                   // 64
	SSIZE_Type66,                   // 65
	SSIZE_Type67,                   // 66
	SSIZE_Type68,                   // 67
	SSIZE_Type69,                   // 68
	SSIZE_Type70,                   // 69
	SSIZE_Type71,                   // 70
	SSIZE_Type72,                   // 71
	SSIZE_Type73,                   // 72
	SSIZE_Type74,                   // 73
	SSIZE_Type75,                   // 74
	SSIZE_Type76,                   // 75
	SSIZE_Type77,                   // 76
	SSIZE_Type78,                   // 77
	SSIZE_Type79,                   // 78
	SSIZE_Type80,                   // 79
	SSIZE_Type81,                   // 80
	SSIZE_Type82,                   // 81
	SSIZE_Type83,                   // 82
	SSIZE_Type84,                   // 83
	SSIZE_Type85,                   // 84
	SSIZE_Type86,                   // 85
	SSIZE_Type87,                   // 86
	SSIZE_Type88,                   // 87
	SSIZE_Type89,                   // 88
	SSIZE_Type90,                   // 89
	SSIZE_Type91,                   // 90
	SSIZE_Type92,                   // 91
	SSIZE_Type93,                   // 92
	SSIZE_Type94,                   // 93
	SSIZE_Type95,                   // 94
	SSIZE_Type96,                   // 95
	SSIZE_Type97,                   // 96
	SSIZE_Type98,                   // 97
	SSIZE_Type99,                   // 98
	SSIZE_Type100,                  // 99
	SSIZE_Type101                   // 100
};

enum ValidateEnum
{
	PDEFEND,                        // 0
	MDEFEND,                        // 1
	pAttack,                        // 2
	mAttack,                        // 3
	pAttackSpeed,                   // 4
	mAttackSpeed,                   // 5
	PSKILLSPEED,                    // 6
	PHIT,                           // 7
	MHIT,                           // 8
	PCRITICAL,                      // 9
	MCRITICAL,                      // 10
	Speed,                          // 11
	ShieldDefense,                  // 12
	ShieldDefenseRate,              // 13
	pAvoid,                         // 14
	mAvoid,                         // 15
	Max                             // 16
};

enum EStringMatchingItemFilter
{
	SMIF_AllItem,                   // 0
	SMIF_WorldExchangeItem          // 1
};

enum ENQuestType
{
	NQT_NONE,                       // 0
	NQT_ONETIME,                    // 1
	NQT_DAILY,                      // 2
	NQT_WEEKLY,                     // 3
	NQT_REPEAT                      // 4
};

enum EFireAbilityType
{
	EFAT_PRIMAL_FIRE,               // 0
	EFAT_PRIMAL_LIFE,               // 1
	EFAT_PIECE_OF_FIRE,             // 2
	EFAT_TOTEM_OF_FIRE,             // 3
	EFAT_FIGHTING_SPIRIT            // 4
};

enum ERankingInzoneEnterType
{
	RIET_Single,                    // 0
	RIET_Pledge                     // 1
};

enum ERankingInzoneCheckType
{
	RICT_Time,                      // 0
	RICT_Exp,                       // 1
	RICT_Score                      // 2
};

enum ERankingInzoneRewardType
{
	RIRT_Item,                      // 0
	RIRT_Skill                      // 1
};

enum ERelicsPlayDataType
{
	ERPDT_Combination,              // 0
	ERPDT_Upgrade,                  // 1
	ERPDT_Change,                   // 2
	ERPDT_Summon                    // 3
};

enum EExOptionType
{
	OPTION_DIFF,                    // 0
	OPTION_PER,                     // 1
	OPTION_PERSUM                   // 2
};

enum ECardSelectFeeType
{
	FEE_OPEN,                       // 0
	FEE_NORMALLOW,                  // 1
	FEE_NORMALHIGH,                 // 2
	FEE_SPECIAL,                    // 3
	FEE_SPECIALFIXED,               // 4
	FEE_TRANSCEND                   // 5
};

enum EStageType
{
	STAGE_NONE,                     // 0
	STAGE_NORMAL,                   // 1
	STAGE_SPECIAL,                  // 2
	STAGE_TRANSCEND                 // 3
};

enum ECreateItemProbType
{
	CIPT_Fix,                       // 0
	CIPT_AddRandom,                 // 1
	CIPT_Random,                    // 2
	CIPT_Max                        // 3
};

enum EClassSexType
{
	CST_Male,                       // 0
	CST_Female,                     // 1
	CST_Both                        // 2
};

enum EChangeClassExtractSkillType
{
	CCEST_None,                     // 0
	CCEST_Legendary,                // 1
	CCEST_Mythic                    // 2
};

struct DynamicContentInfo
{
	var string Title;
	var string Name;
	var string ToolTip;
	var int GoalCnt;
	var array<int> GoalID;
	var array<string> GoalDescription;
};

struct EventContentInfo
{
	var string Title;
	var string Name;
	var string ToolTip;
	var int GoalCnt;
	var array<int> GoalID;
	var array<string> GoalDescription;
};

struct ItemID
{
	var int ClassID;
	var int ServerID;
};

struct ToppingSkillExtraInfo
{
	var int Id;
	var int Level;
	var int SubLevel;
	var int SlotIndex;
	var bool bIsDefault;
};

struct AgitDecoPriceToken
{
	var int ItemClassID;
	var int Cnt;
};

struct AgitDecoNPCData
{
	var int DecoNpcId;
	var int NpcID;
	var int Level;
	var int FactionType;
	var int NpcType;
	var int NpcTypeIdx;
	var int SubType;
	var int SubTypeIdx;
	var INT64 PriceAdena;
	var array<AgitDecoPriceToken> PriceToken;
	var int Period;
	var string Desc;
};

struct AgitDecoNPCTypeList
{
	var int NpcType;
	var int NpcTypeIdx;
};

struct EnsoulOptionInfo
{
	var array<int> OptionArray;
};

struct ItemInfo
{
	var ItemID Id;
	var string Name;
	var string AdditionalName;
	var string IconName;
	var string IconNameEx1;
	var string IconNameEx2;
	var string IconNameEx3;
	var string IconNameEx4;
	var string ForeTexture;
	var string Description;
	var string DragSrcName;
	var string IconPanel;
	var string IconPanel2;
	var int DragSrcReserved;
	var string MacroCommand;
	var int ItemType;
	var int EtcItemType;
	var int ShortcutType;
	var INT64 ItemNum;
	var INT64 Price;
	var int Level;
	var int SubLevel;
	var INT64 SlotBitType;
	var int Weight;
	var int MaterialType;
	var int WeaponType;
	var float pDefense;
	var float mDefense;
	var float pAttack;
	var float mAttack;
	var float pAttackSpeed;
	var float mAttackSpeed;
	var float pHitRate;
	var float mHitRate;
	var float pCriRate;
	var float mCriRate;
	var float MoveSpeed;
	var float ShieldDefense;
	var float ShieldDefenseRate;
	var float pAvoid;
	var float mAvoid;
	var INT64 n64DefaultPriceFromScript;
	var int nGrindPoint;
	var int nGrindCommission;
	var int Durability;
	var int CrystalType;
	var int RandomDamage;
	var int MpConsume;
	var int ArmorType;
	var int Damaged;
	var int Enchanted;
	var int MpBonus;
	var int SoulshotCount;
	var int SpiritshotCount;
	var int PopMsgNum;
	var int BodyPart;
	var int RefineryOp1;
	var int RefineryOp2;
	var int RefineryOp3;
	var int CurrentDurability;
	var int CurrentPeriod;
	var int Reserved;
	var INT64 Reserved64;
	var INT64 DefaultPrice;
	var int ConsumeType;
	var int Blessed;
	var INT64 AllItemCount;
	var int IconIndex;
	var bool bEquipped;
	var bool bRecipe;
	var bool bArrow;
	var bool bShowCount;
	var int bDisabled;
	var int iSkillDisabled;
	var bool bSecurityLockable;
	var bool bSecurityLock;
	var int AttackAttributeType;
	var int AttackAttributeValue;
	var int DefenseAttributeValueFire;
	var int DefenseAttributeValueWater;
	var int DefenseAttributeValueWind;
	var int DefenseAttributeValueEarth;
	var int DefenseAttributeValueHoly;
	var int DefenseAttributeValueUnholy;
	var int RelatedQuestID[10];
	var int ReuseDelayShareGroupID;
	var int Attribution;
	var bool IsToggleSkill;
	var bool IsToggle;
	var int IsBRPremium;
	var int IncludeItem[10];
	var int BR_CurrentEnergy;
	var int BR_MaxEnergy;
	var int LookChangeIconID;
	var int LookChangeItemID;
	var string LookChangeItemName;
	var string LookChangeIconPanel;
	var EnsoulOptionInfo EnsoulOption[2];
	var int ORDER;
	var string tooltipTexutre;
	var string tooltipBGTexture;
	var string tooltipBGTextureCompare;
	var string tooltipBGDecoTexture;
	var int CurUseCount;
	var int MaxUseCount;
	var float RemainReuseDelay;
	var float MaxReuseDelay;
	var float ReceivedAppSec;
	var bool IsNewlyAcquired;
	var bool bAutomaticUseActivated;
	var int nKeepType;
	var bool bIsTradeAble;
	var bool bIsDropAble;
	var bool bIsDesturctAble;
	var bool bIsPrivateType;
	var bool bIsNpcTradeAble;
	var bool bIsAuctionAble;
	var bool bSimpleExchangeItem;
	var bool IsBlessedItem;
	var int BlessBaseEffectID;
	var int EnchantBlessGroupID;
	var int PetEvolveStep;
	var int PetNamePrefixID;
	var int PetNameID;
	var int PetID;
	var INT64 PetExp;
	var INT64 nDBDeleteDate;
	var bool IsCreateItem;
	var int SortOrder;
	var EBlessPanelDrawType BlessPanelDrawType;
	var int AuctionCategory;
	var int HeroBookPoint;
	var bool IsVirtualItem;
	var byte Grade;
	var byte SkillStateBitflag;
	var EItemUIAction DefaultAction;
	var bool IsPetSkill;
	var bool bUseAutoItemPanel;
};

struct LVTexture
{
	var Texture objTex;
	var int X;
	var int Y;
	var int Width;
	var int Height;
	var int U;
	var int V;
	var int UL;
	var int VL;
	var bool IsFront;
};

struct LVData
{
	var bool hasIcon;
	var int nsortPrior;
	var bool iconPostion;
	var string szData;
	var string szReserved;
	var string HiddenStringForSorting;
	var int FirstLineOffsetX;
	var ETextAlign textAlignment;
	var bool bUseTextColor;
	var Color TextColor;
	var int nReserved1;
	var int nReserved2;
	var int nReserved3;
	var string AttrStat[6];
	var array<LVTexture> AttrIconTexArray;
	var Color AttrColor;
	var string szTexture;
	var int nTextureWidth;
	var int nTextureHeight;
	var int nTextureU;
	var int nTextureV;
	var int IconPosX;
	var string iconBackTexName;
	var int backTexOffsetXFromIconPosX;
	var int backTexOffsetYFromIconPosY;
	var int backTexWidth;
	var int backTexHeight;
	var int backTexUL;
	var int backTexVL;
	var string iconPanelName;
	var int panelOffsetXFromIconPosX;
	var int panelOffsetYFromIconPosY;
	var int panelWidth;
	var int panelHeight;
	var int panelUL;
	var int panelVL;
	var string foreTextureName;
	var string LookChangeiconPanelName;
	var array<LVTexture> arrTexture;
	var int nStatusBarCurrentCount;
	var int nStatusBarMaxCount;
	var string BlessedItemIconPanelName;
};

struct LVDataRecord
{
	var array<LVData> LVDataList;
	var string szReserved;
	var INT64 nReserved1;
	var INT64 nReserved2;
	var INT64 nReserved3;
	var bool bUseStatusBar;
	var int nStatusBarIndex;
	var string strStatusBarForeLeftTex;
	var string strStatusBarForeCenterTex;
	var string strStatusBarForeRightTex;
	var string strStatusBarBackLeftTex;
	var string strStatusBarBackCenterTex;
	var string strStatusBarBackRightTex;
	var int nStatusBarWidth;
	var int nStatusBarHeight;
};

struct StringDrawItem
{
	var string FontName;
	var string strData;
	var Color strColor;
	var bool bStrNewLine;
};

struct TextureDrawItem
{
	var string sTex;
	var int Width;
	var int Height;
	var int U;
	var int V;
	var int UL;
	var int VL;
};

struct ButtonDrawItem
{
	var string strID;
	var TextureDrawItem highlightTex;
	var TextureDrawItem normalTex;
	var TextureDrawItem pushedTex;
};

struct ItemDrawItem
{
	var ItemInfo ItemInfo;
	var int Width;
	var int Height;
};

struct StatusDrawItem
{
	var int Width;
	var int Height;
	var string Text;
	var string FontName;
	var Color FontColor;
	var int FontSize;
	var bool bNewLine;
	var string sBackLeftTex;
	var string sBackCenterTex;
	var string sBackRightTex;
	var string sForeLeftTex;
	var string sForeCenterTex;
	var string sForeRightTex;
	var string sOverLeftTex;
	var string sOverCenterTex;
	var string sOverRightTex;
	var int TexWidth;
	var int TexHeight;
	var float ForeProgress;
	var float OverProgress;
};

struct PledgeCrestDrawItem
{
	var int PledgeID;
	var int Width;
	var int Height;
};

struct RichListCtrlDrawItem
{
	var EListCtlDrawItemType eType;
	var bool bNotScalable;
	var int nPosX;
	var int nPosY;
	var int nReservedTooltipID;
	var string TooltipDesc;
	var string TooltipTypeString;
	var StringDrawItem strInfo;
	var TextureDrawItem texInfo;
	var ButtonDrawItem btnInfo;
	var ItemDrawItem ItemInfo;
	var StatusDrawItem statusInfo;
	var PledgeCrestDrawItem pledgeCrestInfo;
};

struct RichListCtrlCellData
{
	var string HiddenStringForSorting;
	var int iSortPrior;
	var string szData;
	var string szReserved;
	var int nReserved1;
	var int nReserved2;
	var int nReserved3;
	var array<RichListCtrlDrawItem> drawitems;
};

struct RichListCtrlRowData
{
	var array<RichListCtrlCellData> cellDataList;
	var string sOverlayTex;
	var int OverlayTexU;
	var int OverlayTexV;
	var bool ForceRefreshTooltip;
	var string szReserved;
	var INT64 nReserved1;
	var INT64 nReserved2;
	var INT64 nReserved3;
};

struct UserInfo
{
	var int nID;
	var string Name;
	var string strNickName;
	var string RealName;
	var int nSex;
	var int Race;
	var int Class;
	var int nLevel;
	var int nClassID;
	var int nSubClass;
	var INT64 nSP;
	var INT64 nCurHP;
	var INT64 nMaxHP;
	var int nCurMP;
	var int nMaxMP;
	var int nCurCP;
	var int nMaxCP;
	var INT64 nCurExp;
	var int nUserRank;
	var int nClanID;
	var int nAllianceID;
	var int nCarryWeight;
	var int nCarringWeight;
	var INT64 nPhysicalAttack;
	var int nPhysicalDefense;
	var int nHitRate;
	var int nCriticalRate;
	var int nPhysicalAttackSpeed;
	var int nPhysicalSkillCastingSpeed;
	var INT64 nMagicalAttack;
	var int nMagicDefense;
	var int nMagicAvoid;
	var int nMagicHitRate;
	var int nMagicCriticalRate;
	var int nPhysicalAvoid;
	var int nWaterMaxSpeed;
	var int nWaterMinSpeed;
	var int nAirMaxSpeed;
	var int nAirMinSpeed;
	var int nGroundMaxSpeed;
	var int nGroundMinSpeed;
	var float fNonAttackSpeedModifier;
	var int nMagicCastingSpeed;
	var int nAddPAttack;
	var int nAddMAttack;
	var int nPSkillCriticalRate;
	var int nPerfect;
	var int nStr;
	var int nDex;
	var int nCon;
	var int nInt;
	var int nWit;
	var int nMen;
	var int nLuc;
	var int nCha;
	var int nTotalBonus;
	var int nStrBonus;
	var int nDexBonus;
	var int nConBonus;
	var int nIntBonus;
	var int nWitBonus;
	var int nMenBonus;
	var int nStrAdditional;
	var int nDexAdditional;
	var int nConAdditional;
	var int nIntAdditional;
	var int nWitAdditional;
	var int nMenAdditional;
	var int nCriminalRate;
	var int nDualCount;
	var int nPKCount;
	var int nVoteCount;
	var int nBonusCount;
	var int nNegativeVoteCount;
	var int nNotoriety;
	var int nNobless;
	var bool bHero;
	var bool bLegend;
	var bool bNpc;
	var bool bPet;
	var bool bCanBeAttacked;
	var bool m_bPawnChanged;
	var bool WantHideName;
	var Vector Loc;
	var int AttrAttackType;
	var int AttrAttackValue;
	var int AttrDefenseValFire;
	var int AttrDefenseValWater;
	var int AttrDefenseValWind;
	var int AttrDefenseValEarth;
	var int AttrDefenseValHoly;
	var int AttrDefenseValUnholy;
	var int nTransformID;
	var int nInvenLimit;
	var int PvPPointRestrain;
	var int PvPPoint;
	var int RaidPoint;
	var Color NicknameColor;
	var int nVitality;
	var int nVitalBonus;
	var int nVitalItem;
	var int nMasterID;
	var int nTalismanNum;
	var int nJewelNum;
	var int nAgathionMainNum;
	var int nAgathionSubNum;
	var int nArtifactGroupNum;
	var int nFullArmor;
	var int JoinedDominionID;
	var int DominionIDForVirtualName;
	var float fExpPercentRate;
	var int UltimateSkillPoint;
	var int TacticSign;
	var int nRemainAbilityPoint;
	var int nFireAttack;
	var int nWaterAttack;
	var int nWindAttack;
	var int nEarthAttack;
	var int nFireDefend;
	var int nWaterDefend;
	var int nWindDefend;
	var int nEarthDefend;
	var int nDyeChargeAmount;
	var bool bRaidBattleBuff;
	var int nActivatedElixirPoint;
	var int nOrcRiderShapeLevel;
	var int nWorldID;
};

struct SkillInfo
{
	var string SkillName;
	var string SkillDesc;
	var int SkillID;
	var int SkillLevel;
	var int SkillSubLevel;
	var int OperateType;
	var int MpConsume;
	var int HpConsume;
	var int CastRange;
	var int CastStyle;
	var float HitTime;
	var float CoolTime;
	var float ReuseDelay;
	var bool IsUsed;
	var int IsMagic;
	var int IsDouble;
	var string AnimName;
	var string SkillPresetName;
	var string TexName;
	var string IconPanel;
	var string IconPanel2;
	var int IconType;
	var int Debuff;
	var string EnchantName;
	var string EnchantDesc;
	var int Enchanted;
	var int EnchantSkillLevel;
	var string EnchantIcon;
	var int RumbleSelf;
	var int RumbleTarget;
	var int MagicType;
	var bool LevelHide;
	var int DpConsume;
	var int EnergyConsume;
	var INT64 DBDeleteDate;
	var int AbnormalTime;
	var ESkillTraitType TraitType;
	var ESkillTargetType TargetType;
	var ESkillAffectScope AffectScope;
	var int Grade;
	var int GroupType;
	var int OrderID;
};

struct PetInfo
{
	var int nServerID;
	var int nClassID;
	var string Name;
	var int nLevel;
	var INT64 nSP;
	var int nCurHP;
	var int nMaxHP;
	var int nCurMP;
	var int nMaxMP;
	var INT64 nCurExp;
	var INT64 nMaxExp;
	var INT64 nMinExp;
	var int nCarryWeight;
	var int nCarringWeight;
	var int nPhysicalAttack;
	var int nPhysicalDefense;
	var int nHitRate;
	var int nCriticalRate;
	var int nPhysicalAttackSpeed;
	var int nPhysicalSkillCastingSpeed;
	var int nPhysicalAvoid;
	var int nMagicalAttack;
	var int nMagicDefense;
	var int nMagicalAvoid;
	var int nMagicalHitRate;
	var int nMagicalCritical;
	var int nMovingSpeed;
	var int nMagicCastingSpeed;
	var int nSoulShotCosume;
	var int nSpiritShotConsume;
	var int nFatigue;
	var int nMaxFatigue;
	var int PetOrSummoned;
	var int nPetID;
	var int nEvolutionID;
	var int nEvolutionStep;
	var int nEvolutionLook;
	var int nEvolutionNamePrefixID;
	var int nEvolutionNameID;
	var int nPetType;
};

struct SummonInfo
{
	var int nServerID;
	var int nClassID;
	var string Name;
	var int nLevel;
	var INT64 nSP;
	var int nCurHP;
	var int nMaxHP;
	var int nCurMP;
	var int nMaxMP;
	var INT64 nCurExp;
	var INT64 nMaxExp;
	var INT64 nMinExp;
	var int nCarryWeight;
	var int nCarringWeight;
	var int nPhysicalAttack;
	var int nPhysicalDefense;
	var int nHitRate;
	var int nCriticalRate;
	var int nPhysicalAttackSpeed;
	var int nPhysicalSkillCastingSpeed;
	var int nMagicalAttack;
	var int nMagicDefense;
	var int nMagicalHitRate;
	var int nMagicalAvoid;
	var int nMagicalCritical;
	var int nPhysicalAvoid;
	var int nMovingSpeed;
	var int nMagicCastingSpeed;
	var int nSoulShotCosume;
	var int nSpiritShotConsume;
	var int nFatigue;
	var int nMaxFatigue;
	var int PetOrSummoned;
	var int nEvolutionID;
};

struct MacroInfo
{
	var int Id;
	var string Name;
	var string IconName;
	var string IconTextureName;
	var int IconSkillId;
	var string Description;
	var string CommandList[20];
};

struct MacroPresetInfo
{
	var int Id;
	var string Name;
	var string IconName;
	var string IconTextureName;
	var string Description;
	var string PresetDescription;
	var string CommandList[20];
};

struct Rect
{
	var int nX;
	var int nY;
	var int nWidth;
	var int nHeight;
};

struct ClanMemberInfo
{
	var int clanType;
	var string sName;
	var int Level;
	var int ClassID;
	var int gender;
	var int Race;
	var int Id;
	var int bActive;
	var int bHaveMaster;
};

struct ClanInfo
{
	var array<ClanMemberInfo> m_array;
	var string m_sName;
	var string m_sMasterName;
};

struct ResolutionInfo
{
	var int nWidth;
	var int nHeight;
	var int nColorBit;
};

struct FileNameInfo
{
	var string Filename;
	var bool bIsFile;
};

struct DriveInfo
{
	var string driveChar;
};

struct KeepSelectInfo
{
	var EKeepSelectType KeepSelectType;
	var int KeepEnchantCondition;
	var EKeepType KeepOption1;
	var EKeepType KeepOption2;
};

struct TextSectionInfo
{
	var Color TextColor;
	var int pos;
};

struct DrawItemInfo
{
	var EDrawItemType eType;
	var int nOffSetX;
	var int nOffSetY;
	var bool bLineBreak;
	var int b_nHeight;
	var int t_ID;
	var string t_strText;
	var Color t_color;
	var bool t_bDrawOneLine;
	var int t_MaxWidth;
	var array<TextSectionInfo> t_SectionList;
	var string t_strFontName;
	var int u_nTextureWidth;
	var int u_nTextureHeight;
	var int u_nTextureUWidth;
	var int u_nTextureUHeight;
	var int u_nTextureU;
	var int u_nTextureV;
	var string u_strTexture;
	var string Condition;
	var EDrawItemAlignType eAlignType;
};

struct CustomTooltip
{
	var int MinimumWidth;
	var int SimpleLineCount;
	var array<DrawItemInfo> DrawList;
};

struct XMLTreeNodeItemInfo
{
	var EXMLTreeNodeItemType eType;
	var int nOffSetX;
	var int nOffSetY;
	var bool bLineBreak;
	var bool bStopMouseFocus;
	var int b_nHeight;
	var int t_nTextID;
	var string t_strText;
	var Color t_color;
	var bool t_bDrawOneLine;
	var ETextVAlign t_vAlign;
	var int t_nMaxHeight;
	var int t_nMaxWidth;
	var int u_nTextureWidth;
	var int u_nTextureHeight;
	var int u_nTextureUWidth;
	var int u_nTextureUHeight;
	var string u_strTexture;
	var string u_strTextureMouseOn;
	var string u_strTextureExpanded;
	var int nReserved;
	var int nReserved2;
};

struct XMLTreeNodeInfo
{
	var string strName;
	var int nOffSetX;
	var int nOffSetY;
	var int bDrawBackground;
	var int bTexBackHighlight;
	var int nTexBackHighlightHeight;
	var int nTexBackWidth;
	var int nTexBackUWidth;
	var int nTexBackOffSetX;
	var int nTexBackOffSetY;
	var int nTexBackOffSetBottom;
	var string strTexExpandedLeft;
	var string strTexExpandedRight;
	var int nTexExpandedOffSetX;
	var int nTexExpandedOffSetY;
	var int nTexExpandedHeight;
	var int nTexExpandedRightWidth;
	var int nTexExpandedLeftUWidth;
	var int nTexExpandedLeftUHeight;
	var int nTexExpandedRightUWidth;
	var int nTexExpandedRightUHeight;
	var int bShowButton;
	var int nTexBtnWidth;
	var int nTexBtnHeight;
	var int nTexBtnOffSetX;
	var int nTexBtnOffSetY;
	var string strTexBtnExpand;
	var string strTexBtnCollapse;
	var string strTexBtnExpand_Over;
	var string strTexBtnCollapse_Over;
	var CustomTooltip ToolTip;
	var bool bFollowCursor;
};

struct StatusIconInfo
{
	var int ServerID;
	var string Name;
	var string IconName;
	var string IconPanel;
	var int Size;
	var string Description;
	var string BackTex;
	var int RemainTime;
	var ItemID Id;
	var int Level;
	var int SubLevel;
	var bool bOwnership;
	var bool bShow;
	var bool bShortItem;
	var bool bEtcItem;
	var int Debuff;
	var int SpellerID;
	var bool bHideRemainTime;
};

struct GameTipData
{
	var int Id;
	var int Priority;
	var int TargetLevel;
	var bool Validity;
	var string TipMsg;
	var string TipImg;
};

struct HennaInfo
{
	var int HennaID;
	var int ClassID;
	var int Num;
	var int Fee;
	var int CanUse;
	var int INTnow;
	var int INTchange;
	var int STRnow;
	var int STRchange;
	var int CONnow;
	var int CONchange;
	var int MENnow;
	var int MENchange;
	var int DEXnow;
	var int DEXchange;
	var int WITnow;
	var int WITchange;
	var int LUCnow;
	var int LUCchange;
	var int CHAnow;
	var int CHAchange;
};

struct EventMatchUserData
{
	var int UserID;
	var string UserName;
	var int HPNow;
	var int HPMax;
	var int MPNow;
	var int MPMax;
	var int CPNow;
	var int CPMax;
	var int UserLv;
	var int UserClass;
	var int UserGender;
	var int UserRace;
	var array<int> BuffIDList;
	var array<int> BuffRemainList;
};

struct EventMatchTeamData
{
	var int Score;
	var string TeamName;
	var int PartyMemberCount;
	var EventMatchUserData User[9];
};

struct ShortcutCommandItem
{
	var string sCommand;
	var string Key;
	var string subkey1;
	var string subkey2;
	var string sState;
	var string sCategory;
	var string sAction;
	var int Id;
};

struct ShortcutScriptData
{
	var int Id;
	var string sCommand;
	var int sysString;
	var int sysMsg;
};

struct EventMatchData
{
	var EventMatchTeamData Team[2];
};

struct RequestItem
{
	var int Id;
	var INT64 Amount;
};

struct PartyMemberInfo
{
	var int CreatureID;
	var string Name;
	var int CurHP;
	var int MaxHP;
	var int curMP;
	var int maxMP;
	var int curCP;
	var int maxCP;
	var int vitality;
	var int ClassID;
	var int Level;
	var bool curHavePet;
	var int curSummonNum;
	var int iSubstitute;
};

struct PartyMemberPetInfo
{
	var int CreatureID;
	var int PetID;
	var int petServerID;
	var int petClassID;
	var int Type;
	var int petHP;
	var int petMaxHP;
	var int petMP;
	var int petMaxMP;
};

struct PartyMemberSummonedInfo
{
	var int CreatureID;
	var int summonedID;
	var int summonedClassID;
	var int Type;
	var int summonedHP;
	var int summonedMaxHP;
	var int summonedMP;
	var int summonedMaxMP;
};

struct AlchemyDataInfo
{
	var int SkillID;
	var int SkillLevel;
	var int SkillMaxLevel;
	var bool GradeType;
	var int CategoryType;
	var int StringID;
	var array<int> RecipeItemClassIDs;
	var array<int> RecipeItemNums;
	var int ResultItemClassID;
	var int ResultItemNum;
};

struct CommissionPremiumItemInfo
{
	var int commissionItemId;
	var string commissionItemName;
	var int commissionPeriod;
	var int commissionExpired;
	var int commissionDiscountInfoType;
	var int commissionDiscountInfo;
};

struct ProductItem
{
	var int iItemID;
	var int iAmount;
	var int iWeight;
	var int iTradable;
	var string strDesc;
};

struct ProductInfo
{
	var int iProductID;
	var int iCategory;
	var int iPaymentType;
	var int iShowTab;
	var int iPanel_Type;
	var int iMinLevel;
	var int iMaxLevel;
	var int iMinBirthday;
	var int iMaxBirthday;
	var int iRestrictionDay;
	var int iAvailableCount;
	var int iSale_Percent;
	var int iPrice;
	var string strName;
	var string strIconName;
	var int iDayWeek;
	var int iStartSale;
	var int iEndSale;
	var int iStartHour;
	var int iStartMin;
	var int iEndHour;
	var int iEndMin;
	var int iStock;
	var int iMaxStock;
	var bool bLimited;
	var bool bEnable;
	var bool bMyShopBasketEnable;
	var string strDesc;
	var string strMainSubject;
	var array<ProductItem> itemarray;
};

struct L2UserFactionUIInfo
{
	var int nFactionID;
	var int nFactionLevel;
	var float fFactionPointRate;
	var bool bIsFactionLevelLimited;
	var bool bIsFactionRewardIcon;
};

struct L2FactionLevelUIData
{
	var int nFactionLevel;
	var string strIconTexture;
	var array<int> arrQuestID;
	var array<int> arrQuestLevel;
	var array<string> arrQuestName;
	var array<string> arrFactionRewardTitle;
	var array<string> arrFactionRewardDesc;
	var array<int> arrFactionRewardGroup;
};

struct L2FactionUIData
{
	var int nFactionID;
	var string strFactionName;
	var string strEmblemTexture;
	var string strEmblemBigTexture;
	var string strFactionDesc;
	var array<string> arrFactionNPCName;
	var array<int> arrFactionAreaZoneID;
	var array<string> arrFactionAreaName;
	var array<int> arrFactionAreaLevel;
	var int nRegionID;
	var int nMonsterbookUse;
	var array<L2FactionLevelUIData> arrLevelData;
};

struct L2MonsterBookUIData
{
	var int nMonsterBookID;
	var int nSortOrder;
	var int nNpcID;
	var int nNpcLevel;
	var string strNpcName;
	var string strNpcNick;
	var INT64 nNpcHP;
	var INT64 nNpcMP;
	var array<int> arrNpcProperty;
	var int nTrophyLevel;
	var int nTrophyCount;
	var int nTrophyMax;
	var array<int> arrDropItemID;
	var array<string> arrDropItemName;
	var string strCardTexture;
	var string strCardPanel;
	var int nZoneID;
	var string strZoneName;
	var int nFactionID;
	var string strFactionName;
	var string strFactionEmblem;
	var array<int> arrRewardFP;
	var array<INT64> arrRewardExp;
	var array<int> arrRewardSP;
	var array<int> arrRewardItem1;
	var array<int> arrRewardItem2;
	var array<int> arrRewardItem3;
	var array<int> arrRewardItem4;
	var int nViewX;
	var int nViewY;
	var float fViewScale;
	var int nViewRot;
	var int nViewDist;
};

struct OfferingItemList
{
	var int nItemID;
	var INT64 nAmount;
};

struct MinimapRegionIconData
{
	var string strIconNormal;
	var string strIconOver;
	var string strIconPushed;
	var int nWorldLocX;
	var int nWorldLocY;
	var int nWorldLocZ;
	var int nWidth;
	var int nHeight;
	var int nIconOffsetX;
	var int nIconOffsetY;
	var int nDescOffsetX;
	var int nDescOffsetY;
	var string strDescFontName;
	var bool bIgnoreMouseInput;
};

struct MinimapRegionInfo
{
	var EMinimapRegionType eType;
	var int nIndex;
	var string strDesc;
	var Color DescColor;
	var string strTooltip;
	var MinimapRegionIconData IconData;
};

struct HuntingZoneUIData
{
	var int nID;
	var string strName;
	var int nType;
	var int nMinLevel;
	var int nMaxLevel;
	var Vector nWorldLoc;
	var int nSearchZoneID;
	var int nRegionID;
	var int nNpcID;
	var array<int> arrQuestIDs;
	var int nInstantZoneID;
};

struct EventAlarmUIData
{
	var int nEventID;
	var int nEventType;
	var string strNotifyIcon;
	var string strTitle;
	var int nStartDate;
	var int nEndDate;
	var int nStartTime;
	var int nEndTime;
	var int nActivateTime;
	var int nDeactivateTime;
	var array<int> nEventDay;
	var string strEventDesc;
	var int nIntTimeStart;
	var int nIntTimeEnd;
};

struct L2UITime
{
	var int nYear;
	var int nMonth;
	var int nDay;
	var int nHour;
	var int nMin;
	var int nSec;
	var int nWeekDay;
	var int nYDay;
};

struct WebRequestParam
{
	var bool bNeedUrlEncode;
	var string strKey;
	var string strValue;
};

struct WebRequestInfo
{
	var EWebMethodType eMethodType;
	var string strRequestUrl;
	var string strNPAuthTokenLoginUrl;
	var array<WebRequestParam> arrRequestParams;
	var array<WebRequestParam> arrHeaderParams;
};

struct TutorialIndex
{
	var int Id;
	var int Category;
	var int LevelCount;
	var string Name;
	var int ORDER;
};

struct TutorialBody
{
	var string Description;
	var int DisplayType;
};

struct PledgeLevelData
{
	var int PledgeLevel;
	var int NeedPledgeExp;
	var int NumGeneral;
	var string MeritDesc;
	var array<string> OpenContents;
	var array<int> SellingItemList;
	var array<string> SkillNameList;
};

struct PledgeMissionRewardItem
{
	var int ItemClassID;
	var int ItemCount;
};

struct PledgeMissionCondition
{
	var int PledgeLevel;
	var string PledgeMasteryName;
	var int MinLevel;
	var int MaxLevel;
	var bool JobMain;
	var bool JobDual;
	var bool JobSub;
	var int PreMissionID;
	var int StartDate;
	var int EndDate;
	var int StartTime;
	var int EndTime;
	var int ActivateTime;
	var int DeactivateTime;
	var array<int> AvailableDays;
};

struct PledgeMissionUIData
{
	var int MissionID;
	var int Category;
	var byte nRepeat;
	var string MissionName;
	var PledgeMissionCondition Condition;
	var string GoalDesc;
	var int GoalCount;
	var int RewardPledgeNameValue;
	var int RewardPVPPoint;
	var array<PledgeMissionRewardItem> RewardItems;
};

struct PledgeDonationData
{
	var int DonationType;
	var array<PledgeMissionRewardItem> PersonalRewards;
	var array<PledgeMissionRewardItem> PledgeRewards;
	var int DonationItem;
	var INT64 DonationItemAmount;
};

struct ArtifactUIData
{
	var int ArtifactItemID;
	var int EnchantSkillID;
	var int MaxSkillLevel;
};

struct AutoplaySettingData
{
	var bool IsAutoPlayOn;
	var bool IsPickupOn;
	var EAutoNextTargetMode NextTargetMode;
	var bool IsNearTargetMode;
	var int HPPotionPercent;
	var int HPPetPotionPercent;
	var bool IsMannerModeOn;
	var bool IsClientRequest;
	var byte MacroIndex;
};

struct LCoinShopBuyItemInfo
{
	var int ItemClassID;
	var int Count;
	var string ProductName;
	var int LevelMin;
	var int LevelMax;
};

struct LCoinShopProductUIData
{
	var int ProductID;
	var int Category;
	var ELCoinShopMarkType MarkType;
	var array<LCoinShopBuyItemInfo> BuyItems;
	var int ProductType;
	var PLSHOP_LIMIT_TYPE LimitType;
	var PLSHOP_RESET_TYPE ResetType;
	var int LimitCountMax;
	var string ProductDesc;
	var string ProductHtm;
	var string HeadLine;
};

struct LCoinShopBannerUIData
{
	var string TextureName;
	var string LinkURL;
};

struct PurchaseLimitCraftCostItemInfo
{
	var int ItemClassID;
	var INT64 Count;
	var byte Enchant;
	var bool IsBlessedItem;
	var bool bUserSelect;
};

struct PurchaseLimitCraftBuyItemInfo
{
	var int ItemClassID;
	var int Count;
	var int Enchant;
	var int ProductRank;
	var bool IsLimitBuy;
};

struct PurchaseLimitCraftUIData
{
	var int ShopIndex;
	var int ProductID;
	var int Category;
	var int CategorySub;
	var ELCoinShopMarkType MarkType;
	var int MaxBuyCount;
	var string ProductName;
	var int ProductItemClassID;
	var int ProductItemEnchant;
	var array<PurchaseLimitCraftBuyItemInfo> BuyItems;
	var array<PurchaseLimitCraftCostItemInfo> CostItemSlot1;
	var array<PurchaseLimitCraftCostItemInfo> CostItemSlot2;
	var array<PurchaseLimitCraftCostItemInfo> CostItemSlot3;
	var array<PurchaseLimitCraftCostItemInfo> CostItemSlot4;
	var array<PurchaseLimitCraftCostItemInfo> CostItemSlot5;
	var int LevelMin;
	var int LevelMax;
	var PLSHOP_LIMIT_TYPE LimitType;
	var PLSHOP_RESET_TYPE ResetType;
	var int LimitCountMax;
	var array<int> RequirementBuySkills;
	var bool KeepOption;
	var array<PurchaseLimitCraftBuyItemInfo> KeepOptionFee;
	var int AutomaticType;
};

struct PledgeShopBuyItemInfo
{
	var int ItemClassID;
	var int Count;
	var float Prob;
};

struct PledgeShopProductUIData
{
	var int ShopIndex;
	var int ProductID;
	var string ProductName;
	var int ProductItemClassID;
	var array<PledgeShopBuyItemInfo> BuyItems;
	var int LevelMin;
	var int LevelMax;
	var int PledgeLevelMin;
	var int PledgeLevelMax;
	var PLSHOP_LIMIT_TYPE LimitType;
	var PLSHOP_RESET_TYPE ResetType;
	var int LimitCountMax;
	var string ProductDesc;
};

struct L2GachaShopItemInfo
{
	var int ClassID;
	var int Count;
};

struct L2GachaShopGroupItemInfo
{
	var L2GachaShopItemInfo ItemInfo;
	var float ItemProb;
};

struct L2GachaShopGroupUIData
{
	var int GroupID;
	var float GroupProb;
	var array<L2GachaShopItemInfo> PickCosts;
	var int TitleItemClassID;
	var array<L2GachaShopGroupItemInfo> ItemList;
};

struct L2GachaShopUIData
{
	var int ShopID;
	var array<L2GachaShopItemInfo> RollCosts;
};

struct TimeRestrictFieldUIData
{
	var string Type;
	var int FieldId;
	var string FieldName;
	var string Desc;
	var array<int> RefillItemList;
	var int Category;
	var string FieldImage;
	var int PvpType;
	var bool IsEvent;
	var string TimeInfo;
	var bool IsAccountShare;
};

struct RankingRewardUIData
{
	var int SkillID;
	var int ItemID;
	var int ItemAmount;
};

struct LetterCollectUIData
{
	var int Id;
	var array<int> LetterItemIDs;
};

struct StatBonusNameUIData
{
	var StatBonusType Type;
	var int Grade;
	var string Desc;
};

struct ServerInfoUIData
{
	var int ServerID;
	var int ServerExtID;
	var string ServerName;
	var bool IsClassicServer;
	var bool IsArenaServer;
	var bool IsBroadCastServer;
	var bool IsAdenServer;
	var bool IsBloodyServer;
	var bool IsTestServer;
	var bool IsWorldRaidServer;
};

struct SharedPositionData
{
	var int SharingCostLCoin;
	var int UsingCostLCoin;
	var int UsingMaxCount;
};

struct MableGameCellRewardItem
{
	var int ItemClassID;
	var int ItemCount;
};

struct MableGameCellData
{
	var int CellColor;
	var string CellName;
	var array<MableGameCellRewardItem> RewardItems;
};

struct MableGameEventData
{
	var string EventGroupDesc;
	var string EventDesc;
};

struct EvolveCondition
{
	var int ConditionType;
	var int Value;
};

struct PetNameInfo
{
	var int NameID;
	var int SkillID;
	var int SkillLevel;
	var string Name;
	var string Desc;
};

struct PetLookInfo
{
	var int LookID;
	var string Name;
	var string Desc;
};

struct ActionUIData
{
	var int Id;
	var int Category;
	var string Icon;
	var string Name;
	var string Desc;
};

struct BlessEffectInfo
{
	var int Id;
	var int EnchantedValue;
	var string OptionDesc;
};

struct BlessOptionUIData
{
	var EBlessRepeatType Type;
	var array<BlessEffectInfo> BaseEffects;
	var array<BlessEffectInfo> EnchantEffects;
	var array<BlessEffectInfo> ChangeLookEffects;
};

struct EnchantBlessScrollUIData
{
	var int ScrollItemClassID;
	var float Probability;
	var array<int> EnchantableGroupIDs;
};

struct PetAcquireSkillInfo
{
	var bool bEnable;
	var int SkillID;
	var int SkillLevel;
	var int SkillMinLevel;
	var int SkillMaxLevel;
	var int NeedPetEvolveStep;
	var int NeedPetLevel;
	var array<RequestItem> NeedItem;
	var array<RequestItem> PrioritizedItems;
};

struct PetExtractInfo
{
	var INT64 ExtractExp;
	var int ExtractItemClassID;
	var RequestItem DefaultExtractCost;
	var RequestItem ExtractCost;
};

struct L2PetRaceEmblemUIData
{
	var int PetID;
	var int PetType;
	var string RaceName;
	var string EmblemTexName;
	var string HUDEmblemTexName;
};

struct CollectionOption
{
	var string Name;
	var bool diff;
	var float Value;
};

struct CollectionSlotItem
{
	var int ItemID;
	var int ItemCount;
	var int EnchantCondition;
	var int BlessCondition;
	var int SlotID;
	var bool Representative;
	var int ReplaceID;
};

struct CollectionRewardItem
{
	var int ItemID;
	var int ItemCount;
};

struct CollectionRewardSkill
{
	var int SkillID;
	var int SkillLevel;
};

struct CollectionData
{
	var int collection_ID;
	var string collection_name;
	var int main_category;
	var int Period;
	var int option_id;
	var array<CollectionOption> Option_filter;
	var array<CollectionSlotItem> SlotItems;
	var array<CollectionRewardItem> RewardItems;
	var array<CollectionRewardSkill> RewardSkills;
	var string startDateTime;
	var string endDateTime;
	var bool bDurationEvent;
};

struct CollectionMainData
{
	var int main_id;
	var int background_level;
	var int Category;
	var int collection_ID;
	var int key_item_id;
	var int key_effect;
};

struct CollectionItemInfo
{
	var int nItemClassID;
	var bool bBless;
	var int Enchant;
	var int Amount;
	var int BlessCondition;
};

struct CollectionInfo
{
	var CollectionItemInfo ItemInfo[6];
	var bool isFavorite;
	var bool isReward;
	var int RemainTime;
	var bool isActiveEvent;
};

struct CollectionCount
{
	var int CollectionTotalCount;
	var int CollectionCompleteCount;
	var int CollectionProgressCount;
	var int SlotTotalCount;
	var int SlotRegistCount;
};

struct L2CharacterAbilityUIData
{
	var string Category;
	var string Detail;
	var bool IsPercent;
	var string TooltipDesc;
	var int ServerType;
};

struct SubjugationData
{
	var int Id;
	var string Name;
	var string Desc;
	var string Banner;
	var int MinLevel;
	var int MaxLevel;
	var int MaxSubjugationPoint;
	var int MaxGachaPoint;
	var int MaxPeriodicGachaPoint;
	var int GachaCostItem;
	var int GachaCostNum;
	var int MaxUsePoint;
	var int TeleportID;
	var array<int> Cycle;
	var array<int> HotTimes;
	var array<int> ShowGachaMain;
	var array<int> ShowGachaSub;
	var array<int> RewardRank1;
	var array<int> RewardRank2;
	var array<int> RewardRank3;
	var array<int> RewardRank4;
	var array<int> RewardRank5;
};

struct L2PassRewardData
{
	var int PassType;
	var int RewardIndex;
	var int FreeRewardType;
	var int FreeRewardItemID;
	var int FreeRewardItemCnt;
	var int PaidRewardType;
	var int PaidRewardItemID;
	var int PaidRewardItemCnt;
};

struct L2PassRewardTotalData
{
	var int PassType;
	var int IsPaid;
	var int ItemID;
	var int ItemCurrCnt;
	var int ItemMaxCnt;
};

struct L2PassAdvanceData
{
	var int nIndex;
	var int nAdvanceType;
	var string AdvanceTypeName;
	var array<int> arrTargetItem;
	var array<int> arrTargetEnchantValue;
	var string Desc;
};

struct DethroneDailyMissionData
{
	var string Name;
	var int Id;
	var int GoalCount;
	var string ProgressDetailDesc;
};

struct UniqueGachaItemInfo
{
	var int RankType;
	var int ItemType;
	var INT64 Amount;
	var float fProb;
};

struct UniquegachaGameTypeInfo
{
	var int GameCount;
	var INT64 CostItemAmount;
};

struct RangedIDData
{
	var int Id;
	var int Min;
	var int Max;
};

struct NickNameItemData
{
	var int Id;
	var array<RangedIDData> Color;
	var array<RangedIDData> Icon;
};

struct DyePotentialUIData
{
	var int DyePotentialID;
	var int DyeSlotID;
	var int MaxSkillLevel;
	var int SkillID;
	var string EffectName;
};

struct DyePotentialExpUIData
{
	var int DyePotentialLevel;
	var int Exp;
};

struct DyePotentialEnchantExp
{
	var int Exp;
	var float Prob;
};

struct VirtualItemInfo
{
	var int nSubIndex;
	var INT64 nSBT;
	var int nClassID;
	var int nEnchant;
	var int nEnchantPoints;
};

struct DyePotentialUpgradeItemInfo
{
	var int ItemClassID;
	var int ItemCount;
};

struct DyePotentialFeeUIData
{
	var int EnchantFeeStep;
	var int DailyCount;
	var array<DyePotentialEnchantExp> EnchantExps;
	var array<DyePotentialUpgradeItemInfo> UpgradeItemInfos;
	var int Commission;
};

struct DyeCombinationUIData
{
	var int SlotOneItemID;
	var int SlotTwoItemID;
	var int Commission;
	var float Prob;
};

struct WorldCastleWarMapData
{
	var int NpcType;
	var int ClassID;
	var int Tier;
	var Vector Location;
};

struct CombinationResultItem
{
	var int ClassID;
	var int Enchant;
	var int Num;
	var int Display;
};

struct CombinationItemUIData
{
	var int GroupID;
	var int AutomaticType;
	var int Level;
	var int MaxLevel;
	var int SlotOneClassID;
	var int SlotOneEnchant;
	var int SlotTwoClassID;
	var int SlotTwoEnchant;
	var array<CombinationResultItem> ResultItems;
	var int ResultEffectType;
	var int ResultEffectType2;
	var INT64 Commission;
};

struct EnchantValidateUIData
{
	var float EnchantValue[16];
	var float PropertyValue[16];
};

struct EnchantRangeData
{
	var int RangeMin;
	var int RangeMax;
	var int RandomValue;
};

struct EnchantScrollSetUIData
{
	var byte ScrollSetID;
	var byte FailureBase;
	var byte FailureDecrease;
	var bool FailureMaintain;
	var bool FailureCrush;
	var int IncBaseMin;
	var int IncBaseMax;
	var byte GreatSuccessEffect;
	var array<EnchantRangeData> EnchantRangeDatas;
	var byte EnchantGroupID;
};

struct EnchantChallengePointSettingUIData
{
	var byte MaxPoint;
	var byte MaxTicketCharge;
	var byte ProbInc1Fee;
	var byte ProbInc2Fee;
	var byte OverUpProbFee;
	var byte NumResetProbFee;
	var byte NumDownProbFee;
	var byte NumProtectProbFee;
};

struct EnchantOptionData
{
	var float Prob;
	var int RangeMin;
	var int RangeMax;
};

struct EnchantOverUpValue
{
	var byte Value;
	var float Prob;
};

struct EnchantOverUpData
{
	var array<EnchantOverUpValue> OverUps;
	var int RangeMin;
	var int RangeMax;
};

struct EnchantChallengePointUIData
{
	var byte PointGroupID;
	var EnchantOptionData ProbInc1;
	var EnchantOptionData ProbInc2;
	var EnchantOverUpData OverUpProb;
	var EnchantOptionData NumResetProb;
	var EnchantOptionData NumDownProb;
	var EnchantOptionData NumProtectProb;
};

struct MagicLampResultItemUIData
{
	var int ItemClassID;
	var int Exp;
	var int Sp;
	var float Probability;
};

struct CreateResultItemData
{
	var int ItemClassID;
	var string ItemName;
	var string AdditionalName;
	var string Prob;
	var int Count;
	var int EnchantValue;
	var byte NameClass;
};

struct ItemCreateUIData
{
	var array<CreateResultItemData> Items;
	var byte Category;
};

struct BalrogwarUIData
{
	var int Level;
	var int MinPlayerPt;
	var int EventBeginPt;
	var int normal_1st_midboss_pt;
	var int normal_2nd_midboss_pt;
	var int normal_final_boss_pt;
	var int specail_final_boss_pt;
};

struct MissionRewardItem
{
	var int RewardLevel;
	var int ItemClassID;
	var int Amount;
};

struct MissionLevelUIData
{
	var int SeasonDate;
	var int SeasonRemainTime;
	var int LimitLevel;
	var int LevelJumpStartLevel;
	var int LevelJumpLCoinAmount;
	var array<MissionRewardItem> BaseRewardItems;
	var array<MissionRewardItem> KeyRewardItems;
	var MissionRewardItem SpecialRewardItem;
	var MissionRewardItem ExtraRewardItem;
};

struct WorldExchangeUIData
{
	var array<int> UseableServerIDs;
	var int UseableLevel;
	var int RegistFee;
	var int MaxSellFee;
	var byte SellFee;
};

struct HeroBookData
{
	var byte Category;
	var int BookSkillID;
	var int BookSkillLevel;
	var int PrevSkillID;
	var int PrevSkillLevel;
	var int NextSkillID;
	var int NextSkillLevel;
	var int SuccessItemID;
	var int SuccessItemCount;
	var int SuccessSkillID;
	var int SuccessSkillLevel;
	var int Commission;
};

struct HeroBookListData
{
	var int Id;
	var int BookSkillID;
	var int BookSkillLevel;
	var int SuccessItemID;
	var int SuccessItemCount;
	var int SuccessSkillID;
	var int SuccessSkillLevel;
};

struct DyePotentialSlotFeeUIData
{
	var int DyeSlotID;
	var int DyePotentialMinLevel;
	var int DyePotentialMaxLevel;
	var array<DyePotentialFeeUIData> DyePotentialFeeUIDataList;
};

struct PrisonUIData
{
	var int PrisonType;
	var int MinPKCount;
	var int MaxPKCount;
	var int DonationAdena;
	var RequestItem NeedItem;
	var int HoldingMinute;
};

struct RecoveryCouponCategoryData
{
	var int Category;
	var int SysStringId;
};

struct RecoveryCouponData
{
	var array<RecoveryCouponCategoryData> Categories;
	var int TitleSysstringId;
	var int DefaultMultisellId;
	var int ExtraMultisellId;
	var array<int> ExtraMultisellServers;
};

struct ItemExchangeMultisellUIData
{
	var int MultisellID;
	var string MultisellName;
};

struct PledgeCrestPresetUIData
{
	var int Id;
	var string CrestTexName;
};

struct AbilityItemUIData
{
	var int AbilityID;
	var int AbilityLev;
	var int RequireAbilityID;
	var int RequireCount;
	var string Name;
	var string Icon;
	var string IconPanel;
	var array<string> LevelDesc;
};

struct NQuestNPCData
{
	var int Id;
	var int TeleportID;
	var int InstantZoneID;
	var Vector Location;
};

struct NQuestGoalData
{
	var string Name;
	var int Num;
};

struct NQuestRewardItemData
{
	var int ItemClassID;
	var INT64 Amount;
};

struct NQuestRewardData
{
	var int Level;
	var INT64 Exp;
	var int Sp;
	var array<NQuestRewardItemData> Items;
};

struct NQuestUIData
{
	var int Id;
	var ENQuestType Type;
	var string Name;
	var array<int> ClassFilter;
	var array<int> PreQuestIDs;
	var int LevelMin;
	var int LevelMax;
	var int QuestItem;
	var int StartItem;
	var int TeleportID;
	var int InstantZoneID;
	var Vector Location;
	var NQuestNPCData StartNPC;
	var NQuestNPCData EndNPC;
	var NQuestGoalData Goal;
	var NQuestRewardData Reward;
};

struct NQuestDialogUIData
{
	var int QuestID;
	var string StartDialog;
	var string AcceptDialog;
	var string CompleteDialog;
	var string EndDialog;
	var string QuestInfo;
};

struct NQuestNpcPortraitUIData
{
	var int NpcID;
	var int ViewOffsetX;
	var int ViewOffsetY;
	var int ViewOffsetZ;
	var int ViewDist;
	var int ViewRotationYaw;
	var float ViewScale;
};

struct ChargeExpItem
{
	var ItemInfo item;
	var int ChargeExp;
	var int commissionItemId;
	var int CommissionCount;
	var byte GroupID;
	var int TargetLevel;
};

struct SkillAcquireData
{
	var INT64 ConsumeSP;
	var INT64 ConsumeAdena;
	var int ConsumePriorityItemID;
	var int ConsumePriorityItemCount;
	var int ConsumeItemID;
	var int ConsumeItemCount;
	var int MultisellGroupID;
	var int SystemMsgID;
	var int Level;
	var byte GetLevel;
	var byte CategoryIndex;
};

struct SkillExtractData
{
	var int ItemID;
	var int ItemCount;
	var INT64 CommissionAdena;
	var int Prob;
	var int SuccessItemID;
};

struct SkillTargetEnchantData
{
	var int ItemID;
	var int ItemCount;
	var INT64 CommissionAdena;
};

struct L2ItemAmount
{
	var int ItemClassID;
	var int ItemAmount;
};

struct L2ItemAmountLarge
{
	var int ItemClassID;
	var INT64 ItemAmount;
};

struct DethroneShopUIData
{
	var int Id;
	var L2ItemAmount item;
	var array<L2ItemAmount> NeedItemList;
};

struct FireAbilityLevelupInfoUIData
{
	var int Level;
	var int Exp;
	var array<L2ItemAmount> ExpUpCostItem;
	var int ExpUpAmount;
	var float ExpUpSuccessRate;
	var array<L2ItemAmount> LevelUpCost;
	var array<L2ItemAmount> ExpUpSuccessReward;
	var array<string> SkillEffect;
};

struct FireAbilityUIData
{
	var EFireAbilityType Type;
	var int DailyExpUpCount;
	var int DailyInitCount;
	var array<L2ItemAmount> DailyInitCost;
	var int MaxLevel;
	var array<FireAbilityLevelupInfoUIData> LevelupInfo;
};

struct FireAbilityComboEffectUIData
{
	var int Level;
	var string Title;
	var array<string> DescriptionList;
};

struct PledgeEnemyDeletePenaltyUIData
{
	var int MinimumRegisterTime;
	var int CostLCoin;
};

struct RankingInzoneRewardView
{
	var int MinRank;
	var int MaxRank;
	var array<int> RewardIDList;
	var array<int> RewardAmountList;
};

struct RankingInzoneUIData
{
	var int RankingID;
	var int InstantZoneID;
	var ERankingInzoneEnterType EnterType;
	var ERankingInzoneCheckType CheckType;
	var ERankingInzoneRewardType RewardType;
	var array<RankingInzoneRewardView> RewardViewList;
};

struct SkillDefaultInfo
{
	var int SkillID;
	var int SkillLevel;
	var int ItemScore;
};

struct RelicsMainUIData
{
	var int RelicsID;
	var int ItemID;
	var int Grade;
	var int Level;
	var int SortOrder;
	var int NpcID;
	var array<SkillDefaultInfo> Skills;
	var array<int> Enchants;
};

struct RelicsPlayUIData
{
	var int Grade;
	var ERelicsPlayDataType Type;
	var array<L2ItemAmount> CostItems;
	var array<int> UpgradeProbs;
	var int SummonItem;
	var int SummonCategory;
	var ELCoinShopMarkType MarkType;
	var int MaxFailPoint;
};

struct RelicsCollectionOption
{
	var string OptionName;
	var float OptionValue;
	var byte OptionType;
};

struct RelicsCollectionNeed
{
	var int RelicsID;
	var int RelicsLevel;
};

struct RelicsCollectionUIData
{
	var int CollectionID;
	var int Category;
	var string CollectionName;
	var int OptionID;
	var array<RelicsCollectionOption> Options;
	var array<RelicsCollectionNeed> NeedRelics;
	var int ItemScore;
};

struct RelicsSummonCategory
{
	var int Index;
	var int NPCStringID;
	var string TextureName;
};

struct PurchaseLimitCraftCategoryUIData
{
	var int Category;
	var int SysStringId;
	var string StringColor;
	var string RibbonTexture;
	var byte Optional;
};

struct ExOptionFilter
{
	var EExOptionType Type;
	var float Value;
	var string Name;
};

struct ExOptionData
{
	var int Id;
	var byte Level;
	var byte Quality;
	var string Desc;
	var array<ExOptionFilter> Filter;
};

struct ExOptionKeyData
{
	var int Id;
	var int Level;
};

struct EquipAddOptionData
{
	var int Id;
	var int ItemID;
	var byte RequiredEnchant;
	var byte ItemState;
	var array<ExOptionKeyData> ExOptionKeyArray;
};

struct CardSelectFee
{
	var ECardSelectFeeType FeeType;
	var L2ItemAmount FeeItem;
};

struct CardSelectStageInfo
{
	var int Index;
	var EStageType StageType;
};

struct CardSelectNormalStage
{
	var int Index;
	var int CardCount;
	var int CardQuality;
	var ExOptionKeyData ExOptionKey;
};

struct SpecialEffect
{
	var ExOptionKeyData ExOptionKey;
	var int EffectSlot;
};

struct CardSelectSpecialStage
{
	var int Index;
	var array<SpecialEffect> EffectArray;
	var int ItemScore;
};

struct CardSelectData
{
	var byte BossID;
	var int LowFeeDailyCount;
	var int HighFeeDailyCount;
	var int LowFeeAdena;
	var int HighFeeAdena;
	var array<CardSelectFee> FeeArray;
	var array<CardSelectStageInfo> StageArray;
	var array<int> TranscendEffectArray;
};

struct PopupEventData
{
	var int Id;
	var int TeleportID;
	var byte Type;
	var int TitleStringID;
	var int FieldStringID;
	var int DescStringID;
	var string PopupTexture;
	var string HUDTexture;
	var string HUDOverTexture;
	var string HUDPushTexture;
};

struct CardSelectTranscendStage
{
	var int Index;
	var int EquipOption;
	var ExOptionKeyData BasicDescOption;
	var ExOptionKeyData EquipDescOption;
	var array<ExOptionKeyData> EffectArray;
	var int ItemScore;
};

struct StoreURLData
{
	var string BannerURL;
	var string PopupURL;
};

struct DyeEffectUIData
{
	var byte Category;
	var byte SlotID;
	var byte DyeLevel;
	var SkillDefaultInfo Skill;
	var L2ItemAmount NeedItem;
	var L2ItemAmount CancelNeedItem;
	var L2ItemAmount CancelReturnItem;
	var L2ItemAmount HiddenNeedItem;
	var SkillDefaultInfo HiddenSkill;
};

struct CollectionDurationUIData
{
	var byte ResetDay;
	var byte ResetHour;
	var byte ResetMinute;
};

struct ChangeClassData
{
	var byte RaceType;
	var byte Sex;
	var byte JobGroup;
	var bool IsHide;
	var int ClassID;
	var string RaceName;
	var string ClassName;
	var string MaleTextureName;
	var string FemaleTextureName;
};

struct ChangeClassExtractSkillData
{
	var L2ItemAmount LegendaryReward;
	var L2ItemAmount MythicReward;
	var array<L2ItemAmount> ArrLegendaryFee;
	var array<L2ItemAmount> ArrMythicFee;
};

struct PostFeeSettingData
{
	var int BaseFee;
	var int SlotPerFee;
};

struct PostBillingData
{
	var int MinBilling;
	var INT64 MaxBilling;
};

struct CharacterStyleUIData
{
	var int StyleID;
	var byte Category;
	var byte MarkType;
	var byte UiGrade;
	var string StyleName;
	var array<L2ItemAmount> ActiveCosts;
	var int ShiftWeaponID;
	var int SkillID;
	var array<int> Enchants;
	var string KillEffect;
	var string ChatBgTex;
};

native function ExecuteEvent(int a_EventID, optional string a_Param);

native function ParamAdd(out string strParam, string strName, string strValue);

native function ParamAddINT64(out string strParam, string strName, INT64 sValue);

native function bool ParseString(string a_strCmd, string a_strMatch, out string a_strResult);

native function bool ParseInt(string a_strCmd, string a_strMatch, out int a_Result);

native function bool ParseINT64(string a_strCmd, string a_strMatch, out INT64 a_Result);

native function bool ParseFloat(string a_strCmd, string a_strMatch, out float a_Result);

native function ParamToItemInfo(string param, out ItemInfo Info);

native function ItemInfoToParam(ItemInfo Info, out string param);

native function RegisterEvent(int ev);

native function RegisterState(string WindowName, string State);

native function SetUIState(string State);

native function MessageBox(string Msg);

native function SMessageBox(int SystemMsgNum);

native function string GetUIState();
