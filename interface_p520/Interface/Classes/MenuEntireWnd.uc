class MenuEntireWnd extends UICommonAPI
	dependson(UIPacket);

const TIMER_ID = 123401;
const TIMER_DELAY = 300;
const CATEGORY_LINE_0 = 0;
const CATEGORY_LINE_1 = 1;
const CATEGORY_LINE_2 = 2;
const CATEGORY_LINE_3 = 3;
const CATEGORY_LINE_4 = 4;
const CATEGORY_LINE_5 = 5;
const BG_TYPE1_TEXTURE = "L2UI_NewTex.MenuWnd.MainMenu_MainButton.MenuWnd.MainMenu_iconBg02";
const BG_TYPE2_TEXTURE = "L2UI_NewTex.MenuWnd.MainMenu_MainButton.MenuWnd.MainMenu_iconBg01";
const MAX_CATEGORY = 6;
const MAX_CATEGORYBUTTONNUM = 18;
const MAX_FIXMENU_NUM = 10;
const CATEGORYBG_ADD_HEIGHT = 4;
const MENU_Ability = "Ability";
const MENU_Attend = "Attend";
const MENU_OlympiadRandomChallengeWnd = "OlympiadRandomChallengeWnd";
const MENU_Productinven = "Productinven";
const MENU_ShopLcoinCraft = "ShopLcoinCraft";
const MENU_NShop = "NShop";
const MENU_OlympiadWnd = "OlympiadWnd";
const MENU_RevengeWnd = "RevengeWnd";
const MENU_IngameWebWnd = "IngameWebWnd";
const MENU_BBS = "BBS";
const MENU_ShopSell = "ShopSell";
const MENU_ShopBuy = "ShopBuy";
const MENU_ShopSellAll = "ShopSellAll";
const MENU_ShopSearch = "ShopSearch";
const MENU_ShopFind = "ShopFind";
const MENU_Post = "Post";
const MENU_ShopLcoinCraftWnd = "ShopLcoinCraftWnd";
const MENU_PartyMatchWnd = "PartyMatchWnd";
const MENU_PersonalConnectionsWnd = "PersonalConnectionsWnd";
const MENU_InstancedZone = "InstancedZone";
const MENU_Petition = "Petition";
const MENU_ShortcutAssign = "ShortcutAssign";
const MENU_MacroWnd = "MacroWnd";
const MENU_SiegeCastleInfoWnd = "SiegeCastleInfoWnd";
const MENU_ClanSearch = "ClanSearch";
const MENU_FactionWnd = "FactionWnd";
const MENU_HennaEngraveWndLive = "HennaEngraveWndLive";
const MENU_PlayerAgeWnd = "PlayerAgeWnd";
const MENU_Qna = "Qna";
const MENU_OptionWnd = "OptionWnd";
const MENU_Rec = "Rec";
const MENU_TimeZoneWnd = "TimeZoneWnd";
const MENU_VitamainService = "VitamainService";
const MENU_YetiWnd = "YetiWnd";
const MENU_DetailStatusWnd = "DetailStatusWnd";
const MENU_InventoryWnd = "InventoryWnd";
const MENU_ActionWnd = "ActionWnd";
const MENU_MagicSkillWnd = "MagicSkillWnd";
const MENU_QuestWnd = "QuestWnd";
const MENU_ClanWnd = "ClanWnd";
const MENU_LShop = "LShop";
const MENU_PcRoom = "PcRoom";
const MENU_Shortcut = "Shortcut";
const MENU_PathToAwakening = "PathToAwakening";
const MENU_HomunculusWnd = "HomunculusWnd";
const MENU_Einhasad = "Einhasad";
const MENU_RestoreLostPropertyWnd = "RestoreLostPropertyWnd";
const MENU_CollectionSystem = "CollectionSystem";
const MENU_WorldSiegeRankingWnd = "WorldSiegeRankingWnd";
const MENU_DethroneWnd = "DethroneWnd";
const MENU_HennaMenuWnd = "HennaMenuWnd";
const MENU_HeroBookWnd = "HeroBookWnd";
const MENU_AdenaDistributionWnd = "AdenaDistributionWnd";
const MENU_TeleportWnd = "TeleportWnd";
const MENU_TodoListWnd = "TodoListWnd";
const MENU_WorldExchangeBuyWnd = "WorldExchangeBuyWnd";
const MENU_ElementalSpiritWnd = "ElementalSpiritWnd";
const MENU_MiniMapGfxWnd = "MinimapWnd";
const MENU_CostumeWnd = "CostumeWnd";
const MENU_RelicWnd = "RelicWnd";
const MENU_AdenLabWnd = "AdenLabWnd";
const MENU_CustomizingWnd = "CustomizingWnd";
const BG_TYPE1 = 0;
const BG_TYPE2 = 1;

enum GameRuleType
{
	GRT_TEAM,                       // 0
	GRT_CLASSLESS,                  // 1
	GRT_CLASS,                      // 2
	GRT_MAX                         // 3
};

struct MenuButtonSlotStructCategory
{
	var int CategoryIndex;
	var array<UIConstants.MenuButtonSlotStruct> MenuButtonSlotStructArray;
};

var WindowHandle Me;
var TextureHandle menuBgTexture;
var int lastButtonCount;
var Rect firstRect;
var bool bIsWorkingTimer;
var int nSystemMenuWndFocus;
var bool bEditMode;
var int nSquenceAdd;
var int nFiexedMenuTotalHeight;
var array<MenuButtonSlotStructCategory> menuSlotArray;
var array<UIConstants.MenuButtonSlotStruct> fixedMenuSlotStructArray;
//var delegate<SortDelegate> __SortDelegate__Delegate;

function OnRegisterEvent()
{
	RegisterEvent(150);
	RegisterEvent(3080);
	RegisterEvent(40);
	RegisterEvent(10052);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("MenuEntireWnd");
	menuBgTexture = GetTextureHandle("MenuEntireWnd.menuBgTexture");
	firstRect = Me.GetRect();
	return;
}

function OnSetFocus(WindowHandle a_WindowHandle, bool bFocused)
{
	if((nSystemMenuWndFocus == 1))
	{
		if((((bIsWorkingTimer == false) && Me.IsShowWindow()) && !bFocused))
		{
			if((bEditMode == false))
			{
				Me.HideWindow();
			}
		}
	}
	nSystemMenuWndFocus = 0;
	return;
}

function initAllMenu()
{
	menuSlotArray.Remove(0, menuSlotArray.Length);
	addCatogory(0);
	addCatogory(1);
	addCatogory(2);
	addCatogory(3);
	addCatogory(4);
	addCatogory(5);
	return;
}

function OnShow()
{
	bIsWorkingTimer = true;
	Me.KillTimer(123401);
	Me.SetTimer(123401, 300);
	return;
}

function OnHide()
{
	bIsWorkingTimer = true;
	Me.KillTimer(123401);
	Me.SetTimer(123401, 300);
	if(bEditMode)
	{
		bEditMode = false;
		setEditMode(false);
		loadOptionIni();
		refreshMenu();
	}
	nSystemMenuWndFocus = 1;
	return;
}

function OnTimer(int TimerID)
{
	if((TimerID == 123401))
	{
		KillIsWorkingTimerTimer();
		nSystemMenuWndFocus = 1;
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	local string nameStr, SystemMenuWndFocus;

	if((Event_ID == 150))
	{
		KillIsWorkingTimerTimer();
		initAllMenu();
		configurationMenuData(true);
		configurationFixedMenuData();
		bEditMode = false;
		setEditMode(false);
		loadOptionIni();
		refreshMenu();
	}
	else if((Event_ID == 3080))
	{
		ParseString(param, "Name", nameStr);
		if((nameStr == "SystemMenuWnd"))
		{
			ParseString(param, "SystemMenuWndFocus", SystemMenuWndFocus);
			nSystemMenuWndFocus = int(SystemMenuWndFocus);
			if(Me.IsShowWindow())
			{
				Me.HideWindow();
			}
			else if(!bIsWorkingTimer)
			{
				ShowWindowWithFocus(getCurrentWindowName(string(self)));
			}
		}
	}
	else if((Event_ID == 40))
	{
		KillIsWorkingTimerTimer();
	}
	else if((Event_ID == 10052))
	{
		initAllMenu();
		configurationMenuData();
		configurationFixedMenuData();
		loadOptionIni();
		refreshMenu();
	}
	return;
}

function configurationFixedMenuData()
{
	local UIEventManager.ELanguageType Language;
	local bool isClassic, isKorean, isAden, isLive;

	isLive = getInstanceUIData().GetIsLiveServer();
	isClassic = getInstanceUIData().GetIsClassicServer();
	isAden = IsAdenServer();
	Language = GetLanguage();
	isKorean = (int(Language) == 0);
	fixedMenuSlotStructArray.Remove(0, fixedMenuSlotStructArray.Length);
	if(isAden)
	{
		setListFixed(314, "ClanWnd", "");
		setListFixed(389, "PartyMatchWnd", "");
		setListFixed(470, "Petition", "", !isKorean);
		setListFixed(13515, "RestoreLostPropertyWnd", "");
		setListFixed(2668, "InstancedZone", "");
		setListFixed(3529, "SiegeCastleInfoWnd", "");
		setListFixed(3327, "PlayerAgeWnd", "", !isKorean);
		setListFixed(2448, "Rec", "");
		setListFixed(14168, "PersonalConnectionsWnd", "PersonalConnectionsWnd");
		setListFixed(387, "BBS", "BoardWnd");
	}
	else if((isClassic && !isAden))
	{
		setListFixed(314, "ClanWnd", "");
		setListFixed(389, "PartyMatchWnd", "");
		setListFixed(13515, "RestoreLostPropertyWnd", "");
		setListFixed(470, "Petition", "", !isKorean);
		setListFixed(2668, "InstancedZone", "");
		setListFixed(3529, "SiegeCastleInfoWnd", "");
		setListFixed(3327, "PlayerAgeWnd", "", !isKorean);
		setListFixed(2448, "Rec", "");
		setListFixed(14168, "PersonalConnectionsWnd", "PersonalConnectionsWnd");
		setListFixed(387, "BBS", "BoardWnd");
	}
	else
	{
		setListFixed(3471, "IngameWebWnd", "", !isKorean);
		setListFixed(387, "BBS", "BoardWnd");
		setListFixed(470, "Petition", "", !isKorean);
		setListFixed(3136, "Qna", "", !isKorean);
		setListFixed(2448, "Rec", "");
		setListFixed(3327, "PlayerAgeWnd", "", !isKorean);
	}
	return;
}

function configurationMenuData(optional bool bGamingStateEnter)
{
	local UIEventManager.ELanguageType Language;
	local bool isClassic, isKorean, isAden, isLive;

	isLive = getInstanceUIData().GetIsLiveServer();
	isClassic = getInstanceUIData().GetIsClassicServer();
	isAden = IsAdenServer();
	Language = GetLanguage();
	isKorean = (int(Language) == 0);
	GetMeButton("OptionBtn").SetTooltipCustomType(MakeTooltipSimpleColorText(setMainShortcutString(getAssignedKeyGroup(), "OptionWnd"), getInstanceL2Util().White));
	if(isKorean)
	{
		if(isAden)
		{
			setList(0, 14063, "WorldExchangeBuyWnd", "", !Class'Interface.WorldExchangeBuyWnd'.static.Inst().ChkUseableServerID(), GetColor(255, 211, 102, 255));
			setList(0, 3634, "NShop", "IngameWebWnd", !isKorean, GetColor(255, 211, 102, 255));
			setList(0, 2469, "Productinven", "", !GetINIBool2Bool("PrimeShop", "UseGoodsInventory"), GetColor(255, 211, 102, 255));
			setList(0, 3932, "LShop", "", !isKorean, GetColor(255, 211, 102, 255));
			setList(0, 14595, "CustomizingWnd", "CustomizingWnd");
			setList(1, 14491, "RelicWnd", "");
			setList(1, 14616, "AdenLabWnd", "");
			setList(1, 3776, "ElementalSpiritWnd", "");
			setList(1, 13904, "HennaMenuWnd", "");
			setList(1, 13476, "CollectionSystem", "", !IsCollectionServer());
			setList(2, 3506, "TodoListWnd", "");
			setList(2, 7464, "Attend", "", !getUseVipAttendance());
			setList(2, 118, "QuestWnd", "QuestWnd");
			setList(2, 711, "MacroWnd", "MacroWnd");
			setList(2, 127, "ActionWnd", "ActionWnd");
			setList(3, 13025, "TimeZoneWnd", "");
			setList(3, 687, "TeleportWnd", "");
			setList(3, 447, "MinimapWnd", "MinimapWnd");
			setList(3, 13082, "RevengeWnd", "");
			setList(3, 13799, "WorldSiegeRankingWnd", "", !isKorean);
			setList(4, 2074, "Post", "PostWnd");
			setList(4, 1, "InventoryWnd", "InventoryWnd");
			setList(4, 3651, "DetailStatusWnd", "DetailStatusWnd");
			setList(4, 119, "MagicSkillWnd", "MagicSkillWnd");
			setList(4, 146, "OptionWnd", "OptionWnd");
		}
		else if((isClassic && !isAden))
		{
			setList(0, 3634, "NShop", "IngameWebWnd", !isKorean, GetColor(255, 211, 102, 255));
			setList(0, 2469, "Productinven", "", !GetINIBool2Bool("PrimeShop", "UseGoodsInventory"), GetColor(255, 211, 102, 255));
			setList(0, 3932, "LShop", "", !isKorean, GetColor(255, 211, 102, 255));
			setList(0, 13832, "ShopFind", "", , GetColor(255, 211, 102, 255));
			setList(0, 14595, "CustomizingWnd", "CustomizingWnd");
			setList(1, 14491, "RelicWnd", "");
			setList(1, 3776, "ElementalSpiritWnd", "");
			setList(1, 13904, "HennaMenuWnd", "");
			setList(1, 13476, "CollectionSystem", "", !IsCollectionServer());
			setList(1, 14616, "AdenLabWnd", "");
			setList(2, 3506, "TodoListWnd", "");
			setList(2, 7464, "Attend", "", !getUseVipAttendance());
			setList(2, 118, "QuestWnd", "QuestWnd");
			setList(2, 711, "MacroWnd", "MacroWnd");
			setList(2, 127, "ActionWnd", "ActionWnd");
			setList(3, 13025, "TimeZoneWnd", "");
			setList(3, 687, "TeleportWnd", "");
			setList(3, 447, "MinimapWnd", "MinimapWnd");
			setList(3, 13082, "RevengeWnd", "");
			setList(4, 2074, "Post", "PostWnd");
			setList(4, 1, "InventoryWnd", "InventoryWnd");
			setList(4, 3651, "DetailStatusWnd", "DetailStatusWnd");
			setList(4, 119, "MagicSkillWnd", "MagicSkillWnd");
			setList(4, 146, "OptionWnd", "OptionWnd");
		}
		else
		{
			setList(0, 3634, "NShop", "IngameWebWnd", !isKorean, GetColor(255, 211, 102, 255), 1);
			setList(0, 2469, "Productinven", "", !GetINIBool2Bool("PrimeShop", "UseGoodsInventory"), GetColor(255, 211, 102, 255), 1);
			setList(0, 13535, "Einhasad", "", false, GetColor(255, 211, 102, 255), 1);
			setList(0, 1277, "PcRoom", "", !GetINIBool2Bool("Localize", "UsePCBangPoint"), GetColor(255, 211, 102, 255), 1);
			setList(0, 13832, "ShopFind", "", , GetColor(255, 211, 102, 255), 1);
			setList(0, 3137, "AdenaDistributionWnd", "", false, GetColor(255, 211, 102, 255), 1);
			setList(1, 687, "TeleportWnd", "");
			setList(1, 3651, "DetailStatusWnd", "DetailStatusWnd");
			setList(1, 1, "InventoryWnd", "InventoryWnd");
			setList(1, 127, "ActionWnd", "ActionWnd");
			setList(1, 119, "MagicSkillWnd", "MagicSkillWnd");
			setList(1, 118, "QuestWnd", "QuestWnd");
			setList(2, 314, "ClanWnd", "ClanWnd");
			setList(2, 447, "MinimapWnd", "MinimapWnd");
			setList(2, 7464, "Attend", "", !getUseVipAttendance());
			setList(2, 3966, "HennaEngraveWndLive", "");
			setList(2, 2383, "PersonalConnectionsWnd", "PersonalConnectionsWnd");
			setList(2, 2074, "Post", "PostWnd");
			setList(3, 645, "ShopLcoinCraftWnd", "ShopLcoinCraftWnd");
			setList(3, 2796, "InstancedZone", "InstancedZone");
			setList(3, 389, "PartyMatchWnd", "PartyMatchWnd");
			setList(3, 13476, "CollectionSystem", "", !IsCollectionServer());
			setList(3, 14157, "HeroBookWnd", "");
			setList(3, 13025, "TimeZoneWnd", "");
			setList(4, 3845, "OlympiadWnd", "");
			setList(4, 13343, "HomunculusWnd", "");
			setList(4, 13733, "DethroneWnd", "");
			setList(4, 711, "MacroWnd", "MacroWnd");
			setList(4, 14491, "RelicWnd", "");
			setList(4, 146, "OptionWnd", "OptionWnd");
		}
	}
	else if(isAden)
	{
		setList(0, 14063, "WorldExchangeBuyWnd", "", !Class'Interface.WorldExchangeBuyWnd'.static.Inst().ChkUseableServerID(), GetColor(255, 211, 102, 255));
		setList(0, 2469, "Productinven", "", !GetINIBool2Bool("PrimeShop", "UseGoodsInventory"), GetColor(255, 211, 102, 255));
		setList(0, 3932, "LShop", "", , GetColor(255, 211, 102, 255));
		setList(0, 387, "BBS", "BoardWnd");
		setList(0, 14595, "CustomizingWnd", "CustomizingWnd");
		setList(1, 14491, "RelicWnd", "");
		setList(1, 14616, "AdenLabWnd", "");
		setList(1, 3776, "ElementalSpiritWnd", "");
		setList(1, 13904, "HennaMenuWnd", "");
		setList(1, 13476, "CollectionSystem", "", !IsCollectionServer());
		setList(2, 3506, "TodoListWnd", "");
		setList(2, 7464, "Attend", "", !getUseVipAttendance());
		setList(2, 118, "QuestWnd", "QuestWnd");
		setList(2, 711, "MacroWnd", "MacroWnd");
		setList(2, 127, "ActionWnd", "ActionWnd");
		setList(3, 13025, "TimeZoneWnd", "");
		setList(3, 687, "TeleportWnd", "");
		setList(3, 447, "MinimapWnd", "MinimapWnd");
		setList(3, 13082, "RevengeWnd", "");
		setList(3, 13799, "WorldSiegeRankingWnd", "");
		setList(4, 2074, "Post", "PostWnd");
		setList(4, 1, "InventoryWnd", "InventoryWnd");
		setList(4, 3651, "DetailStatusWnd", "DetailStatusWnd");
		setList(4, 119, "MagicSkillWnd", "MagicSkillWnd");
		setList(4, 146, "OptionWnd", "OptionWnd");
	}
	else if((isClassic && !isAden))
	{
		setList(0, 2469, "Productinven", "", !GetINIBool2Bool("PrimeShop", "UseGoodsInventory"), GetColor(255, 211, 102, 255));
		setList(0, 3932, "LShop", "", !GetINIBool2Bool("Localize", "UseOldClassicLCoinShop"), GetColor(255, 211, 102, 255));
		setList(0, 13832, "ShopFind", "", , GetColor(255, 211, 102, 255));
		setList(0, 387, "BBS", "BoardWnd");
		setList(0, 14595, "CustomizingWnd", "CustomizingWnd");
		setList(1, 14491, "RelicWnd", "");
		setList(1, 3776, "ElementalSpiritWnd", "");
		setList(1, 13904, "HennaMenuWnd", "");
		setList(1, 13476, "CollectionSystem", "", !IsCollectionServer());
		setList(1, 14616, "AdenLabWnd", "");
		setList(2, 3506, "TodoListWnd", "");
		setList(2, 7464, "Attend", "", !getUseVipAttendance());
		setList(2, 118, "QuestWnd", "QuestWnd");
		setList(2, 711, "MacroWnd", "MacroWnd");
		setList(2, 127, "ActionWnd", "ActionWnd");
		setList(3, 13025, "TimeZoneWnd", "");
		setList(3, 687, "TeleportWnd", "");
		setList(3, 447, "MinimapWnd", "MinimapWnd");
		setList(3, 13082, "RevengeWnd", "");
		setList(3, 5867, "CostumeWnd", "", !IsUseCostume());
		setList(4, 2074, "Post", "PostWnd");
		setList(4, 1, "InventoryWnd", "InventoryWnd");
		setList(4, 3651, "DetailStatusWnd", "DetailStatusWnd");
		setList(4, 119, "MagicSkillWnd", "MagicSkillWnd");
		setList(4, 146, "OptionWnd", "OptionWnd");
	}
	else
	{
		setList(0, 3634, "NShop", "IngameWebWnd", !isKorean, GetColor(255, 211, 102, 255), 1);
		setList(0, 2469, "Productinven", "", !GetINIBool2Bool("PrimeShop", "UseGoodsInventory"), GetColor(255, 211, 102, 255), 1);
		setList(0, 13535, "Einhasad", "", !GetINIBool2Bool("Localize", "UseEinhasad"), GetColor(255, 211, 102, 255), 1);
		setList(0, 13832, "ShopFind", "", , GetColor(255, 211, 102, 255), 1);
		setList(0, 3137, "AdenaDistributionWnd", "", false, GetColor(255, 211, 102, 255), 1);
		setList(1, 687, "TeleportWnd", "");
		setList(1, 3651, "DetailStatusWnd", "DetailStatusWnd");
		setList(1, 1, "InventoryWnd", "InventoryWnd");
		setList(1, 127, "ActionWnd", "ActionWnd");
		setList(1, 119, "MagicSkillWnd", "MagicSkillWnd");
		setList(1, 118, "QuestWnd", "QuestWnd");
		setList(2, 314, "ClanWnd", "ClanWnd");
		setList(2, 447, "MinimapWnd", "MinimapWnd");
		setList(2, 7464, "Attend", "", !getUseVipAttendance());
		setList(2, 3966, "HennaEngraveWndLive", "");
		setList(2, 2383, "PersonalConnectionsWnd", "PersonalConnectionsWnd");
		setList(2, 2074, "Post", "PostWnd");
		setList(3, 645, "ShopLcoinCraftWnd", "ShopLcoinCraftWnd");
		setList(3, 2796, "InstancedZone", "InstancedZone");
		setList(3, 389, "PartyMatchWnd", "PartyMatchWnd");
		setList(3, 13476, "CollectionSystem", "", !IsCollectionServer());
		setList(3, 14157, "HeroBookWnd", "");
		setList(3, 13025, "TimeZoneWnd", "");
		setList(4, 3845, "OlympiadWnd", "");
		setList(4, 13343, "HomunculusWnd", "");
		setList(4, 13733, "DethroneWnd", "");
		setList(4, 711, "MacroWnd", "MacroWnd");
		setList(4, 14491, "RelicWnd", "");
		setList(4, 146, "OptionWnd", "OptionWnd");
	}
	return;
}

function onMenuClick(string MenuName)
{
	switch(MenuName)
	{
		case "Attend":
			if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("AttendCheckWnd"))
			{
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow("AttendCheckWnd");
			}
			else
			{
				AttendCheckWnd(GetScript("AttendCheckWnd"))._Rq_C_EX_VIP_ATTENDANCE_LIST();
			}
			break;
		case "NShop":
			clickNShopMenu();
			break;
		case "OlympiadWnd":
			OlympiadWndMenu();
			break;
		case "OlympiadRandomChallengeWnd":
			if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("OlympiadRandomChallengeWnd"))
			{
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow("OlympiadRandomChallengeWnd");
			}
			else
			{
				OlympiadRandomChallengeMenu();
			}
			break;
		case "Ability":
			showHideAbilityWnd();
			break;
		case "RevengeWnd":
			showHideRevengeWnd();
			break;
		case "IngameWebWnd":
			ShowHideIngameWebMain();
			break;
		case "BBS":
			ShowHideIngameWebBBS();
			break;
		case "MacroWnd":
			ShowHideMacroWnd();
			break;
		case "LShop":
			HandleToggleShowShopDailyWnd();
			break;
		case "VitamainService":
			if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("PremiumManagerWnd"))
			{
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow("PremiumManagerWnd");
			}
			else
			{
				RequestOpenWndWithoutNPC(OPEN_PREMIUM_MANAGER);
			}
			break;
		case "PcRoom":
			HandleToggleShowPCCafeCommuniWnd();
			break;
		case "YetiWnd":
			YetiPCModeChangeWnd(GetScript("YetiPCModeChangeWnd")).setYetiMode(true);
			break;
		case "Qna":
			handleShowQABoardWnd();
			break;
		case "FactionWnd":
			if(Class'NWindow.UIDATA_PLAYER'.static.IsInDethrone())
			{
				getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
			}
			else
			{
				toggleWindow("FactionWnd", true, true);
			}
			break;
		case "ClanSearch":
			toggleWindow("ClanSearch", true, true);
			break;
		case "Einhasad":
			HandleToggleShowShopDailyWnd();
			break;
		case "RestoreLostPropertyWnd":
			toggleWindow("RestoreLostPropertyWnd", true, true);
			break;
		case "CollectionSystem":
			OpenCollectionSelectedItem();
			break;
		case "ShopLcoinCraft":
			toggleWindow("ShopLcoinCraftWnd", true, true);
			break;
		case "ShopFind":
			toggleWindow("PrivateShopFindWnd", true, true);
			break;
		case "TimeZoneWnd":
			if(getInstanceUIData().GetIsClassicServer())
			{
				if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("TimeZoneWnd"))
				{
					Class'NWindow.UIAPI_WINDOW'.static.HideWindow("TimeZoneWnd");
				}
				else
				{
					TimeZoneWnd(GetScript("TimeZoneWnd")).ShowBySideBar();
				}
			}
			else if(IsPlayerOnWorldRaidServer())
			{
				getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
			}
			else
			{
				toggleWindow("TimeZoneWnd", true, true);
			}
			break;
		case "AdenaDistributionWnd":
			if(!Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("PrivateShopWndReport"))
			{
				CallGFxFunction("AdenaDistributionWnd", "RequestDivideAdenaStart", "");
			}
			else
			{
				getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(5104));
			}
			break;
		case "WorldExchangeBuyWnd":
			if(GetWindowHandle("WorldExchangeBuyWnd").IsShowWindow())
			{
				Class'Interface.WorldExchangeBuyWnd'.static.Inst()._Hide();
			}
			else if(GetWindowHandle("WorldExchangeRegiWnd").IsShowWindow())
			{
				Class'Interface.WorldExchangeRegiWnd'.static.Inst()._Hide();
			}
			else
			{
				Class'Interface.WorldExchangeBuyWnd'.static.Inst()._Show();
			}
			break;
		case "ElementalSpiritWnd":
			if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("elementalSpiritWnd"))
			{
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow("elementalSpiritWnd");
			}
			else
			{
				ElementalSpiritWnd(GetScript("ElementalSpiritWnd"))._API_RequestElementalSpiritInfo(true);
			}
			break;
		case "MagicSkillWnd":
			if(IsUseRenewalSkillWnd())
			{
				if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("SkillWnd"))
				{
					Class'NWindow.UIAPI_WINDOW'.static.HideWindow("SkillWnd");
				}
				else
				{
					Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("SkillWnd");
				}
			}
			else
			{
				ShowByShortcutFunction(MenuName);
			}
			break;
		case "CostumeWnd":
			if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("CostumeWnd"))
			{
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow("CostumeWnd");
			}
			else
			{
				Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("CostumeWnd");
			}
			break;
		case "RelicWnd":
			if(Class'Interface.RelicWnd'.static.Inst().IsShowAndVisible())
			{
				Class'Interface.RelicWnd'.static.Inst().CloseWindow();
			}
			else
			{
				Class'Interface.RelicWnd'.static.Inst().OpenWindow();
			}
			break;
		default:
			ShowByShortcutFunction(MenuName);
	}
	return;
}

function OpenCollectionSelectedItem()
{
	local CollectionSystem collectionSystemScript;

	collectionSystemScript = CollectionSystem(GetScript("collectionSystem"));
	collectionSystemScript.API_C_EX_COLLECTION_OPEN_UI();
	return;
}

function handleShowQABoardWnd()
{
	local string strParam;

	ParamAdd(strParam, "Index", "8");
	ExecuteEvent(1190, strParam);
	return;
}

function HandleToggleShowShopDailyWnd()
{
	if((IsAdenServer() || getInstanceUIData().GetIsClassicServer()))
	{
		toggleWindow("ShopLcoinWnd", true, true);
	}
	else
	{
		toggleWindow("ShopLcoinWnd", true, true);
	}
	return;
}

function string getMenuIconTexture(string MenuName)
{
	local string Tex;

	switch(MenuName)
	{
		case "Ability":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Ability";
			break;
		case "Attend":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_AttendCheack";
			break;
		case "OlympiadRandomChallengeWnd":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_RandomChallenge";
			break;
		case "Productinven":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Product";
			break;
		case "ShopLcoinCraft":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_ShopLcoinCraft";
			break;
		case "NShop":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Nshop";
			break;
		case "OlympiadWnd":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Olympiad";
			break;
		case "RevengeWnd":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Revenge";
			break;
		case "IngameWebWnd":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Lineage2Home";
			break;
		case "BBS":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Bbs";
			break;
		case "ShopSell":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_ShopSell";
			break;
		case "ShopBuy":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_ShopBuy";
			break;
		case "ShopSellAll":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_ShopSellAll";
			break;
		case "ShopSearch":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_ShopSearch";
			break;
		case "ShopFind":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_PrivateShopFind";
			break;
		case "Ability":
			Tex = "L2UI_NewTex.MenuWnd.icon_Nshop";
			break;
		case "Post":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Post";
			break;
		case "ShopLcoinCraftWnd":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_ShopLcoinCraft";
			break;
		case "PartyMatchWnd":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_PartyMatch";
			break;
		case "PersonalConnectionsWnd":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_PersonalConnection";
			break;
		case "InstancedZone":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_InstancedZone";
			break;
		case "Petition":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Petition";
			break;
		case "ShortcutAssign":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_ShortcutAssign";
			break;
		case "MacroWnd":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Macro";
			break;
		case "SiegeCastleInfoWnd":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_CastleInfo";
			break;
		case "ClanSearch":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_ClanSearch";
			break;
		case "FactionWnd":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_FactionMark";
			break;
		case "HennaEngraveWndLive":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_HennaEngrave";
			break;
		case "PlayerAgeWnd":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Playerage";
			break;
		case "Qna":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_QnA";
			break;
		case "OptionWnd":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Option";
			break;
		case "Rec":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_MovieRec";
			break;
		case "TimeZoneWnd":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_TimeZone";
			break;
		case "VitamainService":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_VitamainService";
			break;
		case "YetiWnd":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Yeti";
			break;
		case "DetailStatusWnd":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Character";
			break;
		case "InventoryWnd":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Inventory";
			break;
		case "ActionWnd":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Action";
			break;
		case "MagicSkillWnd":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Skill";
			break;
		case "QuestWnd":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Quest";
			break;
		case "ClanWnd":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Clan";
			break;
		case "LShop":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_LconShop";
			break;
		case "PcRoom":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_PcRoomEvent";
			break;
		case "Shortcut":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_ShortcutAssign";
			break;
		case "PathToAwakening":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_PathToAwakening";
			break;
		case "HomunculusWnd":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Homunculus";
			break;
		case "Einhasad":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Einhasad";
			break;
		case "RestoreLostPropertyWnd":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_icon_RestoreLostPropert";
			break;
		case "CollectionSystem":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Collection";
			break;
		case "WorldSiegeRankingWnd":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_WorldSiege";
			break;
		case "DethroneWnd":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Dethrone";
			break;
		case "HennaMenuWnd":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_dyepotential";
			break;
		case "HeroBookWnd":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Herobook";
			break;
		case "AdenaDistributionWnd":
			if(getInstanceUIData().GetIsLiveServer())
			{
				Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_AdenaCalculate";
			}
			else
			{
				Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_AdenaCalculate_Live";
			}
			break;
		case "TeleportWnd":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_TeleportMap";
			break;
		case "TodoListWnd":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_ToDoListWnd";
			break;
		case "WorldExchangeBuyWnd":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_WorldExchangeWnd";
			break;
		case "ElementalSpiritWnd":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_ElementalSpiritWnd";
			break;
		case "MinimapWnd":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Map";
			break;
		case "CostumeWnd":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Costume";
			break;
		case "RelicWnd":
			if(getInstanceUIData().GetIsLiveServer())
			{
				Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Relic";
			}
			else
			{
				Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Doll";
			}
			break;
		case "AdenLabWnd":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_AdenLab";
			break;
		case "CustomizingWnd":
			Tex = "L2UI_NewTex.MenuWnd.MainMenu_Icon_Style";
			break;
		default:
			break;
	}
	return Tex;
}

function int getMenuIndex(string MenuName)
{
	local int Index;

	switch(MenuName)
	{
		case "Ability":
			Index = 1;
			break;
		case "Attend":
			Index = 2;
			break;
		case "OlympiadRandomChallengeWnd":
			Index = 3;
			break;
		case "Productinven":
			Index = 4;
			break;
		case "ShopLcoinCraft":
			Index = 5;
			break;
		case "NShop":
			Index = 6;
			break;
		case "OlympiadWnd":
			Index = 7;
			break;
		case "RevengeWnd":
			Index = 8;
			break;
		case "IngameWebWnd":
			Index = 9;
			break;
		case "BBS":
			Index = 10;
			break;
		case "ShopSell":
			Index = 11;
			break;
		case "ShopBuy":
			Index = 12;
			break;
		case "ShopSellAll":
			Index = 13;
			break;
		case "ShopSearch":
			Index = 14;
			break;
		case "ShopFind":
			Index = 15;
			break;
		case "Ability":
			Index = 16;
			break;
		case "Post":
			Index = 17;
			break;
		case "ShopLcoinCraftWnd":
			Index = 18;
			break;
		case "PartyMatchWnd":
			Index = 19;
			break;
		case "PersonalConnectionsWnd":
			Index = 20;
			break;
		case "InstancedZone":
			Index = 21;
			break;
		case "Petition":
			Index = 22;
			break;
		case "ShortcutAssign":
			Index = 23;
			break;
		case "MacroWnd":
			Index = 24;
			break;
		case "SiegeCastleInfoWnd":
			Index = 25;
			break;
		case "ClanSearch":
			Index = 26;
			break;
		case "FactionWnd":
			Index = 27;
			break;
		case "HennaEngraveWndLive":
			Index = 28;
			break;
		case "PlayerAgeWnd":
			Index = 29;
			break;
		case "Qna":
			Index = 30;
			break;
		case "OptionWnd":
			Index = 31;
			break;
		case "Rec":
			Index = 32;
			break;
		case "TimeZoneWnd":
			Index = 33;
			break;
		case "VitamainService":
			Index = 34;
			break;
		case "YetiWnd":
			Index = 35;
			break;
		case "DetailStatusWnd":
			Index = 36;
			break;
		case "InventoryWnd":
			Index = 37;
			break;
		case "ActionWnd":
			Index = 38;
			break;
		case "MagicSkillWnd":
			Index = 39;
			break;
		case "QuestWnd":
			Index = 40;
			break;
		case "ClanWnd":
			Index = 41;
			break;
		case "LShop":
			Index = 42;
			break;
		case "PcRoom":
			Index = 43;
			break;
		case "Shortcut":
			Index = 44;
			break;
		case "PathToAwakening":
			Index = 45;
			break;
		case "HomunculusWnd":
			Index = 46;
			break;
		case "Einhasad":
			Index = 47;
			break;
		case "RestoreLostPropertyWnd":
			Index = 48;
			break;
		case "CollectionSystem":
			Index = 49;
			break;
		case "WorldSiegeRankingWnd":
			Index = 50;
			break;
		case "DethroneWnd":
			Index = 51;
			break;
		case "HennaMenuWnd":
			Index = 52;
			break;
		case "HeroBookWnd":
			Index = 53;
			break;
		case "AdenaDistributionWnd":
			Index = 54;
			break;
		case "TeleportWnd":
			Index = 55;
			break;
		case "TodoListWnd":
			Index = 56;
			break;
		case "WorldExchangeBuyWnd":
			Index = 57;
			break;
		case "ElementalSpiritWnd":
			Index = 58;
			break;
		case "MinimapWnd":
			Index = 59;
			break;
		case "RelicWnd":
			Index = 60;
			break;
		case "CostumeWnd":
			Index = 61;
			break;
		case "AdenLabWnd":
			Index = 62;
			break;
		case "CustomizingWnd":
			Index = 63;
			break;
		default:
			break;
	}
	return Index;
}

function string getMenuString(int menuNameIndex)
{
	local string MenuName;

	switch(menuNameIndex)
	{
		case 1:
			MenuName = "Ability";
			break;
		case 2:
			MenuName = "Attend";
			break;
		case 3:
			MenuName = "OlympiadRandomChallengeWnd";
			break;
		case 4:
			MenuName = "Productinven";
			break;
		case 5:
			MenuName = "ShopLcoinCraft";
			break;
		case 6:
			MenuName = "NShop";
			break;
		case 7:
			MenuName = "OlympiadWnd";
			break;
		case 8:
			MenuName = "RevengeWnd";
			break;
		case 9:
			MenuName = "IngameWebWnd";
			break;
		case 10:
			MenuName = "BBS";
			break;
		case 11:
			MenuName = "ShopSell";
			break;
		case 12:
			MenuName = "ShopBuy";
			break;
		case 13:
			MenuName = "ShopSellAll";
			break;
		case 14:
			MenuName = "ShopSearch";
			break;
		case 15:
			MenuName = "ShopFind";
			break;
		case 16:
			MenuName = "Ability";
			break;
		case 17:
			MenuName = "Post";
			break;
		case 18:
			MenuName = "ShopLcoinCraftWnd";
			break;
		case 19:
			MenuName = "PartyMatchWnd";
			break;
		case 20:
			MenuName = "PersonalConnectionsWnd";
			break;
		case 21:
			MenuName = "InstancedZone";
			break;
		case 22:
			MenuName = "Petition";
			break;
		case 23:
			MenuName = "ShortcutAssign";
			break;
		case 24:
			MenuName = "MacroWnd";
			break;
		case 25:
			MenuName = "SiegeCastleInfoWnd";
			break;
		case 26:
			MenuName = "ClanSearch";
			break;
		case 27:
			MenuName = "FactionWnd";
			break;
		case 28:
			MenuName = "HennaEngraveWndLive";
			break;
		case 29:
			MenuName = "PlayerAgeWnd";
			break;
		case 30:
			MenuName = "Qna";
			break;
		case 31:
			MenuName = "OptionWnd";
			break;
		case 32:
			MenuName = "Rec";
			break;
		case 33:
			MenuName = "TimeZoneWnd";
			break;
		case 34:
			MenuName = "VitamainService";
			break;
		case 35:
			MenuName = "YetiWnd";
			break;
		case 36:
			MenuName = "DetailStatusWnd";
			break;
		case 37:
			MenuName = "InventoryWnd";
			break;
		case 38:
			MenuName = "ActionWnd";
			break;
		case 39:
			MenuName = "MagicSkillWnd";
			break;
		case 40:
			MenuName = "QuestWnd";
			break;
		case 41:
			MenuName = "ClanWnd";
			break;
		case 42:
			MenuName = "LShop";
			break;
		case 43:
			MenuName = "PcRoom";
			break;
		case 44:
			MenuName = "Shortcut";
			break;
		case 45:
			MenuName = "PathToAwakening";
			break;
		case 46:
			MenuName = "HomunculusWnd";
			break;
		case 47:
			MenuName = "Einhasad";
			break;
		case 48:
			MenuName = "RestoreLostPropertyWnd";
			break;
		case 49:
			MenuName = "CollectionSystem";
			break;
		case 50:
			MenuName = "WorldSiegeRankingWnd";
			break;
		case 51:
			MenuName = "DethroneWnd";
			break;
		case 52:
			MenuName = "HennaMenuWnd";
			break;
		case 53:
			MenuName = "HeroBookWnd";
			break;
		case 54:
			MenuName = "AdenaDistributionWnd";
			break;
		case 55:
			MenuName = "TeleportWnd";
			break;
		case 56:
			MenuName = "TodoListWnd";
			break;
		case 57:
			MenuName = "WorldExchangeBuyWnd";
			break;
		case 58:
			MenuName = "ElementalSpiritWnd";
			break;
		case 59:
			MenuName = "MinimapWnd";
			break;
		case 60:
			MenuName = "RelicWnd";
			break;
		case 61:
			MenuName = "CostumeWnd";
			break;
		case 62:
			MenuName = "AdenLabWnd";
			break;
		case 63:
			MenuName = "CustomizingWnd";
			break;
		default:
			break;
	}
	return MenuName;
}

event OnCilckCheckBoxWithHandle(CheckBoxHandle a_CheckBoxHandle)
{
	local array<UIConstants.MenuButtonSlotStruct> arrayCheckedMenu;
	local int CategoryIndex, buttonIndex;

	CategoryIndex = int(Right(a_CheckBoxHandle.GetParentWindowHandle().GetParentWindowName(), 1));
	buttonIndex = int(Right(a_CheckBoxHandle.GetParentWindowName(), 2));
	if(GetCheckBoxHandle((((("MenuEntireWnd.MenuCategory" $ string(CategoryIndex)) $ ".MenuButtonSlot") $ fillZero(buttonIndex)) $ ".checkBox")).IsChecked())
	{
		menuSlotArray[CategoryIndex].MenuButtonSlotStructArray[buttonIndex].nSequence = nSquenceAdd;
		nSquenceAdd++;
	}
	else
	{
		menuSlotArray[CategoryIndex].MenuButtonSlotStructArray[buttonIndex].nSequence = 0;
	}
	arrayCheckedMenu = getCheckboxChecked();
	if((arrayCheckedMenu.Length > 9))
	{
		lockCheckboxChecked();
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13806));
	}
	else
	{
		unlockCheckboxChecked();
	}
	Menu(GetScript("Menu")).setBTN();
	return;
}

function lockCheckboxChecked()
{
	local int CategoryIndex, buttonIndex;

	CategoryIndex = 0;
	while((CategoryIndex < menuSlotArray.Length))
	{
		buttonIndex = 0;
		while((buttonIndex < 18))
		{
			if((buttonIndex < menuSlotArray[CategoryIndex].MenuButtonSlotStructArray.Length))
			{
				if(!GetCheckBoxHandle((((("MenuEntireWnd.MenuCategory" $ string(CategoryIndex)) $ ".MenuButtonSlot") $ fillZero(buttonIndex)) $ ".checkBox")).IsChecked())
				{
					GetCheckBoxHandle((((("MenuEntireWnd.MenuCategory" $ string(CategoryIndex)) $ ".MenuButtonSlot") $ fillZero(buttonIndex)) $ ".checkBox")).DisableWindow();
					buttonIndex++;
					continue;
				}
				GetCheckBoxHandle((((("MenuEntireWnd.MenuCategory" $ string(CategoryIndex)) $ ".MenuButtonSlot") $ fillZero(buttonIndex)) $ ".checkBox")).EnableWindow();
			}
			buttonIndex++;
		}
		CategoryIndex++;
	}
	return;
}

function int getLastCategoryCount()
{
	local int CategoryIndex, categoryCount;

	CategoryIndex = 0;
	while((CategoryIndex < menuSlotArray.Length))
	{
		if((menuSlotArray[CategoryIndex].MenuButtonSlotStructArray.Length > 0))
		{
			categoryCount++;
		}
		CategoryIndex++;
	}
	return (categoryCount - 1);
}

function unlockCheckboxChecked()
{
	local int CategoryIndex, buttonIndex;

	CategoryIndex = 0;
	while((CategoryIndex < menuSlotArray.Length))
	{
		buttonIndex = 0;
		while((buttonIndex < 18))
		{
			if((buttonIndex < menuSlotArray[CategoryIndex].MenuButtonSlotStructArray.Length))
			{
				GetCheckBoxHandle((((("MenuEntireWnd.MenuCategory" $ string(CategoryIndex)) $ ".MenuButtonSlot") $ fillZero(buttonIndex)) $ ".checkBox")).EnableWindow();
			}
			buttonIndex++;
		}
		CategoryIndex++;
	}
	return;
}

function array<UIConstants.MenuButtonSlotStruct> getCheckboxChecked()
{
	local int CategoryIndex, buttonIndex;
	local array<UIConstants.MenuButtonSlotStruct> MainMenuButtonSlotStructArray;

	CategoryIndex = 0;
	while((CategoryIndex < menuSlotArray.Length))
	{
		buttonIndex = 0;
		while((buttonIndex < 18))
		{
			if((buttonIndex < menuSlotArray[CategoryIndex].MenuButtonSlotStructArray.Length))
			{
				if(GetCheckBoxHandle((((("MenuEntireWnd.MenuCategory" $ string(CategoryIndex)) $ ".MenuButtonSlot") $ fillZero(buttonIndex)) $ ".checkBox")).IsChecked())
				{
					MainMenuButtonSlotStructArray[MainMenuButtonSlotStructArray.Length] = menuSlotArray[CategoryIndex].MenuButtonSlotStructArray[buttonIndex];
				}
			}
			buttonIndex++;
		}
		CategoryIndex++;
	}
	// MainMenuButtonSlotStructArray.Sort(SortDelegate);   // array.Sort() unsupported by this compiler
	return MainMenuButtonSlotStructArray;
}

function loadOptionIni()
{
	local int CategoryIndex, buttonIndex, i;
	local array<string> ArrayStr;
	local string rStr, isMenuSetting;

	GetINIString("MenuEntireWnd", "e", isMenuSetting, "WindowsInfo.ini");
	if((int(isMenuSetting) == 0))
	{
		setDefaultOptionIni();
	}
	GetINIString("MenuEntireWnd", "a", rStr, "WindowsInfo.ini");
	nSquenceAdd = 0;
	if((rStr != ""))
	{
		Split(rStr, ",", ArrayStr);
		CategoryIndex = 0;
		while((CategoryIndex < menuSlotArray.Length))
		{
			buttonIndex = 0;
			while((buttonIndex < 18))
			{
				if((buttonIndex < menuSlotArray[CategoryIndex].MenuButtonSlotStructArray.Length))
				{
					GetCheckBoxHandle((((("MenuEntireWnd.MenuCategory" $ string(CategoryIndex)) $ ".MenuButtonSlot") $ fillZero(buttonIndex)) $ ".checkBox")).SetCheck(false);
					i = 0;
					while((i < ArrayStr.Length))
					{
						if((getMenuString(int(ArrayStr[i])) == menuSlotArray[CategoryIndex].MenuButtonSlotStructArray[buttonIndex].MenuName))
						{
							menuSlotArray[CategoryIndex].MenuButtonSlotStructArray[buttonIndex].nSequence = i;
							nSquenceAdd++;
							GetCheckBoxHandle((((("MenuEntireWnd.MenuCategory" $ string(CategoryIndex)) $ ".MenuButtonSlot") $ fillZero(buttonIndex)) $ ".checkBox")).SetCheck(true);
							break;
						}
						i++;
					}
				}
				buttonIndex++;
			}
			CategoryIndex++;
		}
	}
	if((ArrayStr.Length != nSquenceAdd))
	{
		Debug("----- 전체 메뉴와 메인 메뉴 수량이 달라짐, 다시 저장 하기 ------");  // EN?: ----- Quantity of entire menu and main menu is different, save again ------
		Debug(("menuSlotArray.Length :" @ string(ArrayStr.Length)));
		Debug(("nSquenceAdd: " @ string(nSquenceAdd)));
		saveOptionIni(true);
	}
	return;
}

function setDefaultOptionIni()
{
	local string saveString;
	local UIEventManager.ELanguageType Language;
	local bool isKorean;

	Language = GetLanguage();
	isKorean = (int(Language) == 0);
	if(isKorean)
	{
		if(getInstanceUIData().GetIsClassicServer())
		{
			if(IsAdenServer())
			{
				saveString = ((((((((((((string(getMenuIndex("TeleportWnd")) $ ",") $ string(getMenuIndex("MinimapWnd"))) $ ",") $ string(getMenuIndex("DetailStatusWnd"))) $ ",") $ string(getMenuIndex("InventoryWnd"))) $ ",") $ string(getMenuIndex("TimeZoneWnd"))) $ ",") $ string(getMenuIndex("WorldExchangeBuyWnd"))) $ ",") $ string(getMenuIndex("LShop")));
			}
			else
			{
				saveString = ((((((((((((string(getMenuIndex("TeleportWnd")) $ ",") $ string(getMenuIndex("CollectionSystem"))) $ ",") $ string(getMenuIndex("MinimapWnd"))) $ ",") $ string(getMenuIndex("DetailStatusWnd"))) $ ",") $ string(getMenuIndex("InventoryWnd"))) $ ",") $ string(getMenuIndex("TimeZoneWnd"))) $ ",") $ string(getMenuIndex("LShop")));
			}
		}
		else
		{
			saveString = ((((((((((((((string(getMenuIndex("TeleportWnd")) $ ",") $ string(getMenuIndex("DetailStatusWnd"))) $ ",") $ string(getMenuIndex("InventoryWnd"))) $ ",") $ string(getMenuIndex("ActionWnd"))) $ ",") $ string(getMenuIndex("MagicSkillWnd"))) $ ",") $ string(getMenuIndex("QuestWnd"))) $ ",") $ string(getMenuIndex("ClanWnd"))) $ ",") $ string(getMenuIndex("MinimapWnd")));
		}
	}
	else if(getInstanceUIData().GetIsClassicServer())
	{
		if(IsAdenServer())
		{
			saveString = ((((((((((string(getMenuIndex("TeleportWnd")) $ ",") $ string(getMenuIndex("MinimapWnd"))) $ ",") $ string(getMenuIndex("DetailStatusWnd"))) $ ",") $ string(getMenuIndex("InventoryWnd"))) $ ",") $ string(getMenuIndex("TimeZoneWnd"))) $ ",") $ string(getMenuIndex("WorldExchangeBuyWnd")));
		}
		else
		{
			saveString = ((((((((((string(getMenuIndex("TeleportWnd")) $ ",") $ string(getMenuIndex("CollectionSystem"))) $ ",") $ string(getMenuIndex("MinimapWnd"))) $ ",") $ string(getMenuIndex("DetailStatusWnd"))) $ ",") $ string(getMenuIndex("InventoryWnd"))) $ ",") $ string(getMenuIndex("TimeZoneWnd")));
		}
	}
	else
	{
		saveString = ((((((((((((((string(getMenuIndex("TeleportWnd")) $ ",") $ string(getMenuIndex("DetailStatusWnd"))) $ ",") $ string(getMenuIndex("InventoryWnd"))) $ ",") $ string(getMenuIndex("ActionWnd"))) $ ",") $ string(getMenuIndex("MagicSkillWnd"))) $ ",") $ string(getMenuIndex("QuestWnd"))) $ ",") $ string(getMenuIndex("ClanWnd"))) $ ",") $ string(getMenuIndex("MinimapWnd")));
	}
	SetINIString("MenuEntireWnd", "a", saveString, "WindowsInfo.ini");
	SetINIString("MenuEntireWnd", "b", "1", "WindowsInfo.ini");
	return;
}

function saveOptionIni(optional bool bDoNotNeverUse)
{
	local int i;
	local array<UIConstants.MenuButtonSlotStruct> menuArr;
	local string rStr;

	menuArr = getCheckboxChecked();
	i = 0;
	while((i < menuArr.Length))
	{
		if((i == 0))
		{
			rStr = string(getMenuIndex(menuArr[i].MenuName));
			i++;
			continue;
		}
		rStr = ((rStr $ ",") $ string(getMenuIndex(menuArr[i].MenuName)));
		i++;
	}
	Debug(("저장된 save str:" @ rStr));  // EN?: Save str:
	SetINIString("MenuEntireWnd", "a", rStr, "WindowsInfo.ini");
	if((bDoNotNeverUse == false))
	{
		SetINIString("MenuEntireWnd", "e", "1", "WindowsInfo.ini");
	}
	return;
}

delegate int SortDelegate(UIConstants.MenuButtonSlotStruct A, UIConstants.MenuButtonSlotStruct B)
{
	if((A.nSequence > B.nSequence))
	{
		return -1;
	}
	return 0;
}

function UIConstants.MenuButtonSlotStruct getSlotStructByMenuName(string MenuName)
{
	local int CategoryIndex, buttonIndex;
	local UIConstants.MenuButtonSlotStruct emptyStruct;

	CategoryIndex = 0;
	while((CategoryIndex < menuSlotArray.Length))
	{
		buttonIndex = 0;
		while((buttonIndex < 18))
		{
			if((buttonIndex < menuSlotArray[CategoryIndex].MenuButtonSlotStructArray.Length))
			{
				if((menuSlotArray[CategoryIndex].MenuButtonSlotStructArray[buttonIndex].MenuName == MenuName))
				{
					return menuSlotArray[CategoryIndex].MenuButtonSlotStructArray[buttonIndex];
				}
			}
			buttonIndex++;
		}
		CategoryIndex++;
	}
	return emptyStruct;
}

function OnLButtonDown(WindowHandle btnHandle, int X, int Y)
{
	local int CategoryIndex, buttonIndex;

	if((Left(btnHandle.GetWindowName(), 7) == "MenuBtn"))
	{
		CategoryIndex = int(Right(btnHandle.GetParentWindowHandle().GetParentWindowName(), 1));
		buttonIndex = int(Right(btnHandle.GetParentWindowName(), 2));
		onMenuClick(menuSlotArray[CategoryIndex].MenuButtonSlotStructArray[buttonIndex].MenuName);
	}
	else if(((btnHandle.GetWindowName() == "FixedMenuBtn") && (bEditMode == false)))
	{
		buttonIndex = int(Right(btnHandle.GetParentWindowName(), 2));
		Debug(("btnHandle.GetParentWindowName()" @ btnHandle.GetParentWindowName()));
		Debug(("buttonIndex" @ string(buttonIndex)));
		onMenuClick(fixedMenuSlotStructArray[buttonIndex].MenuName);
	}
	else
	{
		switch(btnHandle.GetWindowName())
		{
			case "RestartBtn":
				showHideRestart();
				break;
			case "ExitBtn":
				showHideExit();
				break;
			case "HelpBtn":
				ShowHelp();
				break;
			case "EditBtn":
			case "ApplyMenuEditBtn":
				bEditMode = !bEditMode;
				if(bEditMode)
				{
					nSystemMenuWndFocus = 0;
					refreshMenu();
					setEditMode(true);
					Me.ShowWindow();
					Me.SetFocus();
				}
				else
				{
					nSystemMenuWndFocus = 0;
					getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13803));
					saveOptionIni();
					refreshMenu();
					setEditMode(false);
					Me.KillTimer(123401);
					Me.SetTimer(123401, 300);
				}
				break;
			case "DefaultMenuBtn":
				MenueClose();
				nSystemMenuWndFocus = 1;
				bEditMode = false;
				setEditMode(false);
				setDefaultOptionIni();
				loadOptionIni();
				Menu(GetScript("Menu")).ShowHideMenus(true);
				refreshMenu();
				getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13805));
				break;
			case "CancelMenuEditBtn":
				bEditMode = false;
				nSystemMenuWndFocus = 0;
				getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13804));
				loadOptionIni();
				refreshMenu();
				setEditMode(false);
				Me.KillTimer(123401);
				Me.SetTimer(123401, 300);
				break;
			case "OptionBtn":
				onMenuClick("OptionWnd");
				break;
			default:
				break;
		}
	}
	return;
}

function setEditMode(bool bLock)
{
	local int i;

	if(bLock)
	{
		GetMeButton("RestartBtn").HideWindow();
		GetMeButton("ExitBtn").HideWindow();
		GetMeButton("OptionBtn").HideWindow();
		GetMeButton("EditBtn").HideWindow();
		GetMeButton("DefaultMenuBtn").ShowWindow();
		GetMeButton("CancelMenuEditBtn").ShowWindow();
		GetMeButton("ApplyMenuEditBtn").ShowWindow();
		i = 0;
		while((i < 10))
		{
			GetWindowHandle((("MenuEntireWnd.MenuFixedButtonSlot" $ fillZero(i)) $ ".FixedMenuBtn")).DisableWindow();
			i++;
		}
	}
	else
	{
		GetMeButton("EditBtn").ShowWindow();
		GetMeButton("RestartBtn").ShowWindow();
		GetMeButton("ExitBtn").ShowWindow();
		GetMeButton("ExitBtn").ShowWindow();
		GetMeButton("OptionBtn").ShowWindow();
		GetMeButton("DefaultMenuBtn").HideWindow();
		GetMeButton("CancelMenuEditBtn").HideWindow();
		GetMeButton("ApplyMenuEditBtn").HideWindow();
		i = 0;
		while((i < 10))
		{
			GetWindowHandle((("MenuEntireWnd.MenuFixedButtonSlot" $ fillZero(i)) $ ".FixedMenuBtn")).EnableWindow();
			i++;
		}
	}
	return;
}

function ShowHelp()
{
	Shortcut(GetScript("Shortcut")).HandleShowHelpHtmlWnd();
	return;
}

function MenueClose()
{
	Me.HideWindow();
	return;
}

function showHideRestart()
{
	ExecuteEvent(3350);
	return;
}

function showHideExit()
{
	ExecuteEvent(3340);
	return;
}

function setList(int CategoryIndex, int stringNum, string MenuName, optional string tooltipKey, optional bool bDoNotUse, optional Color TextColor, optional int bgType)
{
	if(bDoNotUse)
	{
		return;
	}
	if((((int(TextColor.R) == 0) && (int(TextColor.G) == 0)) && (int(TextColor.B) == 0)))
	{
		TextColor = GetColor(170, 170, 170, 255);
	}
	addMenu(CategoryIndex, GetSystemString(stringNum), MenuName, tooltipKey, "", TextColor, bgType);
	return;
}

function addCatogory(int CategoryIndex)
{
	menuSlotArray.Insert(menuSlotArray.Length, 1);
	menuSlotArray[(menuSlotArray.Length - 1)].CategoryIndex = CategoryIndex;
	menuSlotArray[(menuSlotArray.Length - 1)].MenuButtonSlotStructArray.Remove(0, menuSlotArray[(menuSlotArray.Length - 1)].MenuButtonSlotStructArray.Length);
	return;
}

function addMenu(int CategoryIndex, string buttonText, string MenuName, string tooltipKey, optional string SpecialParam, optional Color TextColor, optional int bgType)
{
	local int buttonIndex;

	buttonIndex = menuSlotArray[CategoryIndex].MenuButtonSlotStructArray.Length;
	menuSlotArray[CategoryIndex].MenuButtonSlotStructArray.Insert(buttonIndex, 1);
	menuSlotArray[CategoryIndex].MenuButtonSlotStructArray[buttonIndex].CategoryIndex = CategoryIndex;
	menuSlotArray[CategoryIndex].MenuButtonSlotStructArray[buttonIndex].buttonIndex = buttonIndex;
	menuSlotArray[CategoryIndex].MenuButtonSlotStructArray[buttonIndex].MenuName = MenuName;
	menuSlotArray[CategoryIndex].MenuButtonSlotStructArray[buttonIndex].nBGTextureIndex = bgType;
	menuSlotArray[CategoryIndex].MenuButtonSlotStructArray[buttonIndex].buttonTextColor = TextColor;
	Class'Interface.L2Util'.static.GetEllipsisString(buttonText, 110);
	menuSlotArray[CategoryIndex].MenuButtonSlotStructArray[buttonIndex].buttonText = buttonText;
	menuSlotArray[CategoryIndex].MenuButtonSlotStructArray[buttonIndex].tooltipKey = tooltipKey;
	menuSlotArray[CategoryIndex].MenuButtonSlotStructArray[buttonIndex].SpecialParam = SpecialParam;
	return;
}

function setListFixed(int stringNum, string MenuName, optional string tooltipKey, optional bool bDoNotUse, optional Color TextColor)
{
	if(bDoNotUse)
	{
		return;
	}
	if((((int(TextColor.R) == 0) && (int(TextColor.G) == 0)) && (int(TextColor.B) == 0)))
	{
		TextColor = GetColor(170, 170, 170, 255);
	}
	addFixedMenu(GetSystemString(stringNum), MenuName, tooltipKey, "", TextColor);
	return;
}

function addFixedMenu(string buttonText, string MenuName, string tooltipKey, optional string SpecialParam, optional Color TextColor)
{
	fixedMenuSlotStructArray.Length = (fixedMenuSlotStructArray.Length + 1);
	fixedMenuSlotStructArray[(fixedMenuSlotStructArray.Length - 1)].MenuName = MenuName;
	fixedMenuSlotStructArray[(fixedMenuSlotStructArray.Length - 1)].buttonTextColor = TextColor;
	fixedMenuSlotStructArray[(fixedMenuSlotStructArray.Length - 1)].buttonText = buttonText;
	fixedMenuSlotStructArray[(fixedMenuSlotStructArray.Length - 1)].tooltipKey = tooltipKey;
	fixedMenuSlotStructArray[(fixedMenuSlotStructArray.Length - 1)].SpecialParam = SpecialParam;
	return;
}

function string getTooltipShortcutAutoPlay()
{
	return setMainShortcutString(getAssignedKeyGroup(), "AutoPlay");
}

function setFixedMenuWindow(int buttonIndex, UIConstants.MenuButtonSlotStruct slotStruct)
{
	local string controlPath, ToolTipString;

	controlPath = ("MenuEntireWnd.MenuFixedButtonSlot" $ fillZero(buttonIndex));
	GetTextBoxHandle((controlPath $ ".MenuNameTextBox")).SetText(slotStruct.buttonText);
	textBoxShortStringWithTooltip(GetTextBoxHandle((controlPath $ ".MenuNameTextBox")), false, -6);
	GetTextBoxHandle((controlPath $ ".MenuNameTextBox")).SetTextColor(slotStruct.buttonTextColor);
	ToolTipString = setMainShortcutString(getAssignedKeyGroup(), slotStruct.tooltipKey);
	GetButtonHandle((controlPath $ ".FixedMenuBtn")).ClearTooltip();
	if((ToolTipString != ""))
	{
		GetButtonHandle((controlPath $ ".FixedMenuBtn")).SetTooltipCustomType(MakeTooltipSimpleColorText(ToolTipString, getInstanceL2Util().White));
	}
	GetTextureHandle((controlPath $ ".MenuIcon")).SetTexture(getMenuIconTexture(slotStruct.MenuName));
	return;
}

function setMenuWindow(int CategoryIndex, int buttonIndex, UIConstants.MenuButtonSlotStruct slotStruct)
{
	local string controlPath, ToolTipString;

	controlPath = ((("MenuEntireWnd.MenuCategory" $ string(CategoryIndex)) $ ".MenuButtonSlot") $ fillZero(buttonIndex));
	GetTextBoxHandle((controlPath $ ".MenuNameTextBox")).SetFontIDByName("hs10");
	GetTextBoxHandle((controlPath $ ".MenuNameTextBox")).SetText(slotStruct.buttonText);
	textBoxShortStringWithTooltip(GetTextBoxHandle((controlPath $ ".MenuNameTextBox")), false, -6);
	GetTextBoxHandle((controlPath $ ".MenuNameTextBox")).SetTextColor(slotStruct.buttonTextColor);
	if((slotStruct.nBGTextureIndex == 1))
	{
		GetTextureHandle((controlPath $ ".MenuBgTexture")).SetTexture("L2UI_NewTex.MenuWnd.MainMenu_MainButton.MenuWnd.MainMenu_iconBg01");
	}
	else
	{
		GetTextureHandle((controlPath $ ".MenuBgTexture")).SetTexture("L2UI_NewTex.MenuWnd.MainMenu_MainButton.MenuWnd.MainMenu_iconBg02");
	}
	ToolTipString = setMainShortcutString(getAssignedKeyGroup(), slotStruct.tooltipKey);
	GetButtonHandle((controlPath $ ".MenuBtn")).ClearTooltip();
	if((ToolTipString != ""))
	{
		GetButtonHandle((controlPath $ ".MenuBtn")).SetTooltipCustomType(MakeTooltipSimpleColorText(ToolTipString, getInstanceL2Util().White));
	}
	if(bEditMode)
	{
		GetCheckBoxHandle((controlPath $ ".checkBox")).ShowWindow();
		GetButtonHandle((controlPath $ ".MenuBtn")).HideWindow();
	}
	else
	{
		GetButtonHandle((controlPath $ ".MenuBtn")).ShowWindow();
		GetCheckBoxHandle((controlPath $ ".checkBox")).HideWindow();
		GetTextureHandle((controlPath $ ".MenuIcon")).SetTexture(getMenuIconTexture(slotStruct.MenuName));
	}
	return;
}

function refreshMenu()
{
	local int CategoryIndex, buttonIndex, i;

	CategoryIndex = 0;
	while((CategoryIndex < menuSlotArray.Length))
	{
		if((lastButtonCount < menuSlotArray[CategoryIndex].MenuButtonSlotStructArray.Length))
		{
			lastButtonCount = menuSlotArray[CategoryIndex].MenuButtonSlotStructArray.Length;
		}
		buttonIndex = 0;
		while((buttonIndex < 18))
		{
			if((buttonIndex < menuSlotArray[CategoryIndex].MenuButtonSlotStructArray.Length))
			{
				GetWindowHandle(((("MenuEntireWnd.MenuCategory" $ string(CategoryIndex)) $ ".MenuButtonSlot") $ fillZero(buttonIndex))).ShowWindow();
				setMenuWindow(CategoryIndex, buttonIndex, menuSlotArray[CategoryIndex].MenuButtonSlotStructArray[buttonIndex]);
				buttonIndex++;
				continue;
			}
			GetWindowHandle(((("MenuEntireWnd.MenuCategory" $ string(CategoryIndex)) $ ".MenuButtonSlot") $ fillZero(buttonIndex))).HideWindow();
			buttonIndex++;
		}
		CategoryIndex++;
	}
	i = 0;
	while((i < 10))
	{
		GetWindowHandle(("MenuEntireWnd.MenuFixedButtonSlot" $ fillZero(i))).HideWindow();
		i++;
	}
	if((fixedMenuSlotStructArray.Length > lastButtonCount))
	{
		GetMeTexture("MenuFixedBtnBg_tex").SetWindowSizeRel(100.0000000, 0.0000000, 0, 62);
	}
	else
	{
		GetMeTexture("MenuFixedBtnBg_tex").SetWindowSizeRel(100.0000000, 0.0000000, 0, 32);
	}
	i = 0;
	while((i < fixedMenuSlotStructArray.Length))
	{
		GetWindowHandle(("MenuEntireWnd.MenuFixedButtonSlot" $ fillZero(i))).ShowWindow();
		GetWindowHandle(("MenuEntireWnd.MenuFixedButtonSlot" $ fillZero(i))).ClearAnchor();
		if((lastButtonCount > i))
		{
			if((fixedMenuSlotStructArray.Length > lastButtonCount))
			{
				GetWindowHandle(("MenuEntireWnd.MenuFixedButtonSlot" $ fillZero(i))).SetAnchor("MenuEntireWnd", "BottomLeft", "BottomLeft", (4 + (152 * i)), -91);
			}
			else
			{
				GetWindowHandle(("MenuEntireWnd.MenuFixedButtonSlot" $ fillZero(i))).SetAnchor("MenuEntireWnd", "BottomLeft", "BottomLeft", (4 + (152 * i)), -61);
			}
			nFiexedMenuTotalHeight = 80;
		}
		else
		{
			GetWindowHandle(("MenuEntireWnd.MenuFixedButtonSlot" $ fillZero(i))).SetAnchor("MenuEntireWnd", "BottomLeft", "BottomLeft", (4 + (152 * (i - lastButtonCount))), -61);
			nFiexedMenuTotalHeight = 110;
		}
		setFixedMenuWindow(i, fixedMenuSlotStructArray[i]);
		i++;
	}
	resizeMenuWnd();
	if(getInstanceUIData().GetIsLiveServer())
	{
		AutoUseItemWnd(GetScript("AutoUseItemWnd")).setShortcutTooltip(getTooltipShortcutAutoPlay());
		AutoUseItemWndMin(GetScript("AutoUseItemWndMin")).setShortcutTooltip(getTooltipShortcutAutoPlay());
	}
	else
	{
		AutomaticPlay(GetScript("AutomaticPlay")).setShortcutTooltip(getTooltipShortcutAutoPlay());
	}
	Menu(GetScript("Menu")).setBTN();
	return;
}

function resizeMenuWnd()
{
	local Rect R, C, B;
	local int i;

	C = GetWindowHandle("MenuEntireWnd.MenuCategory0").GetRect();
	R = GetWindowHandle(("MenuEntireWnd.MenuCategory0.MenuButtonSlot" $ fillZero(lastButtonCount))).GetRect();
	B = menuBgTexture.GetRect();
	i = 0;
	while((i < 6))
	{
		GetWindowHandle(("MenuEntireWnd.MenuCategory" $ string(i))).HideWindow();
		i++;
	}
	i = 0;
	while((i < menuSlotArray.Length))
	{
		GetWindowHandle(("MenuEntireWnd.MenuCategory" $ string(i))).ShowWindow();
		GetWindowHandle(("MenuEntireWnd.MenuCategory" $ string(i))).SetWindowSize((R.nX - C.nX), C.nHeight);
		GetWindowHandle(("MenuEntireWnd.MenuCategory" $ string(i))).ClearAnchor();
		GetWindowHandle(("MenuEntireWnd.MenuCategory" $ string(i))).SetAnchor("MenuEntireWnd", "TopLeft", "TopLeft", 4, (4 + (i * 70)));
		i++;
	}
	Me.SetWindowSize(((4 + R.nX) - C.nX), (((((getLastCategoryCount() * R.nHeight) + nFiexedMenuTotalHeight) + 60) + 30) + 4));
	menuBgTexture.SetWindowSize((R.nX - C.nX), (B.nHeight + 4));
	return;
}

function ShowByShortcutFunction(string MenuName)
{
	Class'Interface.Shortcut'.static.Inst()._ExeShowHideWIndow(MenuName);
	return;
}

function HandleToggleShowPCCafeCommuniWnd()
{
	if(getInstanceL2Util().getIsPrologueGrowType())
	{
		AddSystemMessage(4533);
	}
	else if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("NPCDialogWnd"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("NPCDialogWnd");
	}
	else
	{
		RequestOpenWndWithoutNPC(OPEN_PCCAFE_HTML);
	}
	return;
}

function ShowHideMacroWnd()
{
	ExecuteEvent(1230);
	return;
}

function ShowHideIngameWebBBS()
{
	local string param;

	ParamAdd(param, "Category", "bbs");
	ExecuteEvent(10120, param);
	return;
}

function ShowHideIngameWebMain()
{
	local string param;

	ParamAdd(param, "Category", "main");
	ExecuteEvent(10120, param);
	return;
}

function showHideRevengeWnd()
{
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("RevengeWnd"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("RevengeWnd");
	}
	else
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("RevengeWnd");
	}
	return;
}

function clickNShopMenu()
{
	NoticeWnd(GetScript("NoticeWnd")).showHideL2InGameWeb("nshop", "");
	return;
}

function showHideAbilityWnd()
{
	if((GetGameStateName() == "ARENABATTLESTATE"))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(5575));
		return;
	}
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("AbilityWnd"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("AbilityWnd");
	}
	else
	{
		CallGFxFunction("AbilityWnd", "setShow", "");
	}
	return;
}

function OlympiadWndMenu()
{
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("OlympiadWnd"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("OlympiadWnd");
	}
	else
	{
		RequestOlympiadRecord();
	}
	return;
}

function OlympiadRandomChallengeMenu()
{
	local array<byte> stream;
	local UIPacket._C_EX_OLYMPIAD_UI packet;

	packet.cGameRuleType = 0;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_OLYMPIAD_UI(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(626, stream);
	return;
}

function int b2i(bool Value)
{
	if(Value)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

function bool i2b(int Value)
{
	if((Value == 0))
	{
		return false;
	}
	else
	{
		return true;
	}
}

function bool GetINIBool2Bool(string Category, string ItemName)
{
	local int bValue;

	if(!GetINIBool(Category, ItemName, bValue, "L2.ini"))
	{
		return false;
	}
	return i2b(bValue);
}

function bool getUseVipAttendance()
{
	return IsAttendanceSystemEnable();
}

function KillIsWorkingTimerTimer()
{
	bIsWorkingTimer = false;
	Me.KillTimer(123401);
	return;
}

function string fillZero(int Num)
{
	if((Num <= 9))
	{
		return ("0" $ string(Num));
	}
	return string(Num);
}

function string getAssignedKeyGroup()
{
	if(GetChatFilterBool("global", "EnterChatting"))
	{
		return "TempStateShortcut";
	}
	return "GamingStateShortcut";
}

function string setMainShortcutString(string GroupName, string commandName, optional bool B)
{
	local ShortcutCommandItem commandItem;
	local OptionWnd optionWndScript;
	local string strShort;

	if((commandName == ""))
	{
		return "";
	}
	optionWndScript = OptionWnd(GetScript("OptionWnd"));
	if(((commandName == "AutoPlay") || (commandName == "NextTargetModeChange")))
	{
		Class'NWindow.ShortcutAPI'.static.GetAssignedKeyFromCommand(GroupName, commandName, commandItem);
	}
	else
	{
		Class'NWindow.ShortcutAPI'.static.GetAssignedKeyFromCommand(GroupName, ("ShowWindow Name=" $ commandName), commandItem);
	}
	if((((commandItem.subkey1 == "") && (commandItem.subkey2 == "")) && (commandItem.Key == "")))
	{
		if(((commandName == "AutoPlay") || (commandName == "NextTargetModeChange")))
		{
			Class'NWindow.ShortcutAPI'.static.GetAssignedKeyFromCommand("GamingStateShortcut", commandName, commandItem);
		}
		else
		{
			Class'NWindow.ShortcutAPI'.static.GetAssignedKeyFromCommand("GamingStateShortcut", ("ShowWindow Name=" $ commandName), commandItem);
		}
		if((((commandItem.subkey1 == "") && (commandItem.subkey2 == "")) && (commandItem.Key == "")))
		{
			strShort = "";
		}
		else
		{
			if(B)
			{
				strShort = (strShort $ "n");
			}
			strShort = (((strShort $ "<") $ GetSystemString(1523)) $ ": ");
		}
	}
	else
	{
		if(B)
		{
			strShort = (strShort $ "n");
		}
		strShort = (((strShort $ "<") $ GetSystemString(1523)) $ ": ");
	}
	if((commandItem.subkey1 != ""))
	{
		strShort = ((strShort $ optionWndScript.GetUserReadableKeyName(commandItem.subkey1)) $ "+");
	}
	if((commandItem.subkey2 != ""))
	{
		strShort = ((strShort $ optionWndScript.GetUserReadableKeyName(commandItem.subkey2)) $ "+");
	}
	if((commandItem.Key != ""))
	{
		if((commandName == "InventoryWnd"))
		{
			strShort = ((strShort $ optionWndScript.GetUserReadableKeyName(commandItem.Key)) $ ",");
		}
		else
		{
			strShort = ((strShort $ optionWndScript.GetUserReadableKeyName(commandItem.Key)) $ ">");
		}
	}
	if((commandName == "InventoryWnd"))
	{
		Class'NWindow.ShortcutAPI'.static.GetAssignedKeyFromCommand("GamingStateShortcut", "TabShowInventoryWindow", commandItem);
		if((commandItem.subkey1 != ""))
		{
			strShort = ((strShort $ optionWndScript.GetUserReadableKeyName(commandItem.subkey1)) $ "+");
		}
		if((commandItem.subkey2 != ""))
		{
			strShort = ((strShort $ optionWndScript.GetUserReadableKeyName(commandItem.subkey2)) $ "+");
		}
		if((commandItem.Key != ""))
		{
			strShort = ((strShort $ optionWndScript.GetUserReadableKeyName(commandItem.Key)) $ ">");
		}
	}
	return strShort;
}

function HandleDialogOK()
{
	Debug("ok");
	nSystemMenuWndFocus = 1;
	bEditMode = false;
	setEditMode(false);
	setDefaultOptionIni();
	loadOptionIni();
	Menu(GetScript("Menu")).ShowHideMenus(true);
	refreshMenu();
	getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13805));
	return;
}

function HandleDialogOnHide()
{
	Debug("cancel");
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}
