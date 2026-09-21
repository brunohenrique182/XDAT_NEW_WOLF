class UIToolWnd extends UICommonAPI;

var string m_Windowname;
var WindowHandle Me;
var ButtonHandle transBtn;
var ButtonHandle debugBtn;
var ButtonHandle uiBtn;
var ButtonHandle reloaduiBtn;
var ButtonHandle evemsgBtn;
var ButtonHandle uioffBtn;
var ButtonHandle showWBtn;
var ButtonHandle skillBtn;
var ButtonHandle killBtn;
var ButtonHandle weightBtn;
var ButtonHandle diaBtn;
var EditBoxHandle HEdit0;
var EditBoxHandle HEdit;
var EditBoxHandle NEdit;
var ListCtrlHandle WindowListCtrl;
var array<string> arrWinList;
var UIEasyLoginWnd easyLoginScript;
var WindowHandle m_dialogWnd;

function OnLoad()
{
	SetClosingOnESC();
	OnRegisterEvent();
	Me = GetWindowHandle("UIToolWnd");
	transBtn = GetButtonHandle("UIToolWnd.Tab0.transBtn");
	debugBtn = GetButtonHandle("UIToolWnd.Tab0.debugBtn");
	uiBtn = GetButtonHandle("UIToolWnd.Tab0.uiBtn");
	reloaduiBtn = GetButtonHandle("UIToolWnd.Tab0.reloaduiBtn");
	evemsgBtn = GetButtonHandle("UIToolWnd.Tab0.evemsgBtn");
	uioffBtn = GetButtonHandle("UIToolWnd.Tab0.uioffBtn");
	showWBtn = GetButtonHandle("UIToolWnd.Tab0.showWBtn");
	skillBtn = GetButtonHandle("UIToolWnd.Tab0.skillBtn");
	killBtn = GetButtonHandle("UIToolWnd.Tab0.killBtn");
	weightBtn = GetButtonHandle("UIToolWnd.Tab0.weightBtn");
	diaBtn = GetButtonHandle("UIToolWnd.Tab0.diaBtn");
	HEdit0 = GetEditBoxHandle("UIToolWnd.Tab1.HEdit0");
	HEdit = GetEditBoxHandle("UIToolWnd.Tab1.HEdit");
	NEdit = GetEditBoxHandle("UIToolWnd.Tab2.NEdit");
	WindowListCtrl = GetListCtrlHandle("UIToolWnd.Tab2.WindowListCtrl");
	easyLoginScript = UIEasyLoginWnd(GetScript("UIEasyLoginWnd"));
	setWindowTitleByString("UITool");
	setArr();
	SortButtonsTab0();
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(1710);
	RegisterEvent(1720);
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 17:
			dialogShowTest(a_Param);
			break;
		default:
			break;
	}
	return;
}

function dialogShowTest(string param)
{
	local int nSystemString, nSystemMessage, nHtml, nWidth, nHeight;
	local string dialogStr;

	ParseInt(param, "html", nHtml);
	ParseInt(param, "width", nWidth);
	ParseInt(param, "height", nHeight);
	ParseInt(param, "systemString", nSystemString);
	ParseInt(param, "systemMessage", nSystemMessage);
	ParseString(param, "string", dialogStr);
	DialogHide();
	DialogSetID(34567891);
	if((dialogStr == ""))
	{
		dialogStr = GetSystemMessage(nSystemMessage);
		if((dialogStr == ""))
		{
			dialogStr = GetSystemString(nSystemString);
		}
	}
	if((nWidth == 0))
	{
		nWidth = 319;
	}
	if((nHeight == 0))
	{
		nHeight = 143;
	}
	if(numToBool(nHtml))
	{
		DialogShowHtml(DialogModalType_Modalless, DialogType_Warning, dialogStr, m_hOwnerWnd);
	}
	else
	{
		DialogShow(DialogModalType_Modalless, DialogType_Warning, dialogStr, m_hOwnerWnd);
	}
	return;
}

function OnHide()
{
	SetINIString("UIToolWnd", "nEdit", NEdit.GetString(), "UIDEV.ini");
	return;
}

function OnShow()
{
	local string stringValue;

	stringValue = "";
	GetINIString("UIToolWnd", "nEdit", stringValue, "UIDEV.ini");
	NEdit.SetString(stringValue);
	if(easyLoginScript.getUseEasyLogin())
	{
		GetButtonHandle("UIToolWnd.Tab0.EasyLogin").SetNameText("EZLogin On");
	}
	else
	{
		GetButtonHandle("UIToolWnd.Tab0.EasyLogin").SetNameText("EZLogin Off");
	}
	return;
}

function OnClickButton(string a_ButtonID)
{
	local UIDebugWnd util;
	local bool bFlag;

	util = UIDebugWnd(GetScript("UIDebugWnd"));
	Debug(("a_ButtonID" @ a_ButtonID));
	switch(a_ButtonID)
	{
		case "initBtn":
			initButtonClick();
			break;
		case "transBtn":
			if((transBtn.GetButtonName() == "HideOff"))
			{
				ExecuteCommand("//hide off");
				transBtn.SetNameText("HideOn");
			}
			else
			{
				ExecuteCommand("//hide on");
				transBtn.SetNameText("HideOff");
			}
			break;
		case "debugBtn":
			ExecuteCommand("///uidebug");
			break;
		case "uiBtn":
			ExecuteCommand("///ui");
			break;
		case "reloaduiBtn":
			ExecuteCommand("///reloadui");
			break;
		case "evemsgBtn":
			if((evemsgBtn.GetButtonName() == "EvMsgON"))
			{
				evemsgBtn.SetNameText("EvMsgOFF");
			}
			else
			{
				evemsgBtn.SetNameText("EvMsgON");
			}
			ExecuteCommand("///eventmsg");
			break;
		case "showWBtn":
			ExecuteCommand("///show windowname");
			break;
		case "skillBtn":
			ExecuteCommand("//setskill 7029 3");
			break;
		case "killBtn":
			ExecuteCommand("//죽어");  // EN: //die
			break;
		case "weightBtn":
			if((weightBtn.GetButtonName() == "WeightOFF"))
			{
				ExecuteCommand("//무게 켬");  // EN: //weight on
				weightBtn.SetNameText("WeightON");
			}
			else
			{
				ExecuteCommand("//무게 끔");  // EN: //weight off
				weightBtn.SetNameText("WeightOFF");
			}
			break;
		case "gfxBtn":
			ExecuteCommand("///gfx");
			break;
		case "delgfxBtn":
			ExecuteCommand("///delgfxall");
			break;
		case "loadBtn":
			loadButtonClick();
			break;
		case "htmlBtn":
			htmlButtonClick();
			break;
		case "winBtn":
			winButtonClick();
			break;
		case "shoWBBtn":
			ExecuteCommand("///show windowbox");
			break;
		case "allBtn":
			ExecuteCommand("//올스킬");  // EN: //all skills
			break;
		case "evnBtn":
			MakeEventBuff2();
			break;
		case "PowerTool":
			LoadWindowClick("UIPowerToolWnd");
			break;
		case "UITrace":
			util.ShowWindow();
			break;
		case "ServerHtml":
			LoadWindowClick("UIServerHtmlToolWnd");
			break;
		case "HtmlTool":
			LoadWindowClick("UIHtmlToolWnd");
			break;
		case "QuestTool":
			LoadWindowClick("UIQuestToolWnd");
			break;
		case "ItemTool":
			LoadWindowClick("UIItemToolWnd");
			break;
		case "GFXTester":
			CallGFxFunction("containerHUD", "showDebugTool", "");
			break;
		case "ShowUI":
			LoadWindowClick("UIOpenToolWnd");
			break;
		case "UIButton":
			toggleWindow("UIButtonTestWnd", true);
			break;
		case "EasyLogin":
			bFlag = easyLoginScript.getUseEasyLogin();
			if(bFlag)
			{
				GetButtonHandle("UIToolWnd.Tab0.EasyLogin").SetNameText("EasyLogin Off");
			}
			else
			{
				GetButtonHandle("UIToolWnd.Tab0.EasyLogin").SetNameText("EasyLogin On");
			}
			easyLoginScript.setUseEasyLogin(!bFlag);
			break;
		case "GammaOff":
			SetOptionFloat("Video", "Gamma", 0.0000000);
			break;
		case "JobTree":
			ShowWindow("JobTreeWnd");
			break;
		case "mapSearchButton":
			toggleWindow("UISearchMapWnd", true);
			break;
		case "Tween":
			toggleWindow("UITweenTestWnd", true);
			break;
		case "Viewport":
			toggleWindow("EffectTester", true);
			break;
		case "htmlEditorButton":
			Debug("html");
			toggleWindow("UIHtmlTestEditor", true);
			break;
		case "UISoundButton":
			toggleWindow("UISoundWnd", true);
			break;
		case "UIEffectButton":
			toggleWindow("UIEffectViewportTester", true);
			break;
		default:
			break;
	}
	return;
}

function LoadWindowClick(string WindowName)
{
	local WindowHandle NewWindow;

	NewWindow = GetWindowHandle(WindowName);
	NewWindow.ShowWindow();
	NewWindow.SetFocus();
	return;
}

function initButtonClick()
{
	ExecuteCommand("//투명 끔");  // EN: //invisibility off
	ExecuteCommand("//무적 on");  // EN: //invincible on
	ExecuteCommand("//속도 5");  // EN: //speed 5
	ExecuteCommand("///uidebug");
	ExecuteCommand("///autocom");
	return;
}

function loadButtonClick()
{
	local string Str;
	local array<string> arrStr;

	Str = HEdit0.GetString();
	Split(Str, ".", arrStr);
	if((arrStr[1] != ""))
	{
		ExecuteCommand(("//loadhtml " $ Str));
	}
	else
	{
		ExecuteCommand((("//loadhtml " $ Str) $ ".htm"));
	}
	return;
}

function htmlButtonClick()
{
	local ItemDescWnd Script;
	local string Str;
	local array<string> arrStr;

	Str = HEdit.GetString();
	Split(Str, ".", arrStr);
	Script = ItemDescWnd(GetScript("ItemDescWnd"));
	if((arrStr[1] != ""))
	{
		Script.ShowHelp((GetLocalizedL2TextPathNameUC() $ Str));
	}
	else
	{
		Script.ShowHelp(((GetLocalizedL2TextPathNameUC() $ Str) $ ".htm"));
	}
	return;
}

function winButtonClick()
{
	local WindowHandle NewWindow;
	local string Str;

	Str = NEdit.GetString();
	if((Str != ""))
	{
		NewWindow = GetWindowHandle(NEdit.GetString());
		NewWindow.ShowWindow();
		NewWindow.SetFocus();
	}
	return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
	local LVDataRecord Record;

	switch(ListCtrlID)
	{
		case "WindowListCtrl":
			WindowListCtrl.GetSelectedRec(Record);
			Class'NWindow.UIAPI_EDITBOX'.static.SetString("UIToolWnd.NEdit", Record.LVDataList[0].szData);
			break;
		default:
			break;
	}
	return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
	local LVDataRecord Record;
	local WindowHandle NewWindow;

	switch(ListCtrlID)
	{
		case "WindowListCtrl":
			WindowListCtrl.GetSelectedRec(Record);
			NewWindow = GetWindowHandle(Record.LVDataList[0].szData);
			NewWindow.ShowWindow();
			NewWindow.SetFocus();
			break;
		default:
			break;
	}
	return;
}

function MakeWindowList()
{
	local LVDataRecord Record;
	local int i;

	NEdit.ClearAdditionalSearchList(SLT_ADDITIONAL_LIST);
	i = 0;
	while((i < arrWinList.Length))
	{
		Record.LVDataList.Length = 1;
		Record.LVDataList[0].szData = arrWinList[i];
		Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord("UIToolWnd.WindowListCtrl", Record);
		NEdit.AddNameToAdditionalSearchList(Record.LVDataList[0].szData, SLT_ADDITIONAL_LIST);
		i++;
	}
	return;
}

function MakeEventBuff2()
{
	local string strParam;
	local int i;

	ParamAdd(strParam, "ServerID", string(1229005689));
	ParamAdd(strParam, "Max", string(70));
	i = 0;
	while((i < 36))
	{
		ParamAdd(strParam, ("ClassID_" $ string(i)), string(11259));
		ParamAdd(strParam, ("SkillLevel_" $ string(i)), string(4));
		ParamAdd(strParam, ("RemainTime_" $ string(i)), string(13));
		ParamAdd(strParam, ("Name_" $ string(i)), "쇠약의 낙인");  // EN: Mark of Weakness
		ParamAdd(strParam, ("IconName_" $ string(i)), "icon.skill1263");
		ParamAdd(strParam, ("Description_" $ string(i)), "테스트용으로 마구 찍는 디버프ㅋㅋ");  // EN: a debuff spammed for testing lol
		i++;
	}
	i = 36;
	while((i < 70))
	{
		ParamAdd(strParam, ("ClassID_" $ string(i)), string(1040));
		ParamAdd(strParam, ("SkillLevel_" $ string(i)), string(1));
		ParamAdd(strParam, ("RemainTime_" $ string(i)), string(942));
		ParamAdd(strParam, ("Name_" $ string(i)), "실드");  // EN: shield
		ParamAdd(strParam, ("IconName_" $ string(i)), "icon.skill1040");
		ParamAdd(strParam, ("Description_" $ string(i)), "테스트용으로 마구 찍는 디버프ㅋㅋ");  // EN: a debuff spammed for testing lol
		i++;
	}
	ExecuteEvent(950, strParam);
	return;
}

function SortButtonsTab0()
{
	local array<WindowHandle> ChildList;
	local int i, X, Y;

	GetWindowHandle("UIToolWnd.Tab0").GetChildWindowList(ChildList);
	i = 0;
	while((i < ChildList.Length))
	{
		ChildList[i].SetWindowSize(93, 30);
		X = ((int((float(i) % 3.0000000)) * 94) + 1);
		Y = (((i / 3) * 32) + 9);
		ChildList[i].SetAnchor("UIToolWnd.Tab0", "TopLeft", "TopLeft", X, Y);
		i++;
	}
	return;
}

function MakeEventBuff()
{
	local string strParam;
	local int i;
	local TargetStatusWnd Script;

	Script = TargetStatusWnd(GetScript("TargetStatusWnd"));
	Script.HandleSkillCancel();
	ParamAdd(strParam, "TargetID", string(100));
	ParamAdd(strParam, "Max", string(40));
	i = 0;
	while((i < 10))
	{
		ParamAdd(strParam, ("Level_" $ string(i)), string(1));
		ParamAdd(strParam, ("Sec_" $ string(i)), string(100));
		ParamAdd(strParam, ("Count_" $ string(i)), string(1));
		ParamAdd(strParam, ("OwnerShip_" $ string(i)), string(1));
		i++;
	}
	ParamAdd(strParam, "ClassID_0", string(92));
	ParamAdd(strParam, "ClassID_1", string(101));
	ParamAdd(strParam, "ClassID_2", string(102));
	ParamAdd(strParam, "ClassID_3", string(105));
	ParamAdd(strParam, "ClassID_4", string(115));
	ParamAdd(strParam, "ClassID_5", string(129));
	ParamAdd(strParam, "ClassID_6", string(1069));
	ParamAdd(strParam, "ClassID_7", string(1083));
	ParamAdd(strParam, "ClassID_8", string(1160));
	ParamAdd(strParam, "ClassID_9", string(1164));
	i = 10;
	while((i < 20))
	{
		ParamAdd(strParam, ("Level_" $ string(i)), string(1));
		ParamAdd(strParam, ("Sec_" $ string(i)), string(100));
		ParamAdd(strParam, ("Count_" $ string(i)), string(1));
		ParamAdd(strParam, ("OwnerShip_" $ string(i)), string(0));
		i++;
	}
	ParamAdd(strParam, "ClassID_10", string(92));
	ParamAdd(strParam, "ClassID_11", string(101));
	ParamAdd(strParam, "ClassID_12", string(102));
	ParamAdd(strParam, "ClassID_13", string(105));
	ParamAdd(strParam, "ClassID_14", string(115));
	ParamAdd(strParam, "ClassID_15", string(129));
	ParamAdd(strParam, "ClassID_16", string(1069));
	ParamAdd(strParam, "ClassID_17", string(1083));
	ParamAdd(strParam, "ClassID_18", string(1160));
	ParamAdd(strParam, "ClassID_19", string(1164));
	i = 20;
	while((i < 30))
	{
		ParamAdd(strParam, ("Level_" $ string(i)), string(1));
		ParamAdd(strParam, ("Sec_" $ string(i)), string(10));
		ParamAdd(strParam, ("Count_" $ string(i)), string(1));
		ParamAdd(strParam, ("OwnerShip_" $ string(i)), string(1));
		i++;
	}
	ParamAdd(strParam, "ClassID_20", string(77));
	ParamAdd(strParam, "ClassID_21", string(78));
	ParamAdd(strParam, "ClassID_22", string(82));
	ParamAdd(strParam, "ClassID_23", string(91));
	ParamAdd(strParam, "ClassID_24", string(99));
	ParamAdd(strParam, "ClassID_25", string(112));
	ParamAdd(strParam, "ClassID_26", string(113));
	ParamAdd(strParam, "ClassID_27", string(118));
	ParamAdd(strParam, "ClassID_28", string(121));
	ParamAdd(strParam, "ClassID_29", string(137));
	i = 30;
	while((i < 40))
	{
		ParamAdd(strParam, ("Level_" $ string(i)), string(1));
		ParamAdd(strParam, ("Sec_" $ string(i)), string(10));
		ParamAdd(strParam, ("Count_" $ string(i)), string(1));
		ParamAdd(strParam, ("OwnerShip_" $ string(i)), string(0));
		i++;
	}
	ParamAdd(strParam, "ClassID_30", string(77));
	ParamAdd(strParam, "ClassID_31", string(78));
	ParamAdd(strParam, "ClassID_32", string(82));
	ParamAdd(strParam, "ClassID_33", string(91));
	ParamAdd(strParam, "ClassID_34", string(99));
	ParamAdd(strParam, "ClassID_35", string(112));
	ParamAdd(strParam, "ClassID_36", string(113));
	ParamAdd(strParam, "ClassID_37", string(118));
	ParamAdd(strParam, "ClassID_38", string(121));
	ParamAdd(strParam, "ClassID_39", string(137));
	ExecuteEvent(5120, strParam);
	return;
}

function setArr()
{
	local int Index;

	Index = 0;
	arrWinList[Index++] = "AbnormalStatusWnd";
	arrWinList[Index++] = "ActionWnd";
	arrWinList[Index++] = "AdenaDistributionResultWnd";
	arrWinList[Index++] = "AdenaDistributionWnd";
	arrWinList[Index++] = "AgeWnd";
	arrWinList[Index++] = "AgitDecoDrawerWnd";
	arrWinList[Index++] = "AgitDecoWnd";
	arrWinList[Index++] = "AITimerWnd";
	arrWinList[Index++] = "AlchemyItemConversionWnd";
	arrWinList[Index++] = "AlchemyMixCubeWnd";
	arrWinList[Index++] = "AlchemyOpener";
	arrWinList[Index++] = "AlchemySkillCollectionWnd";
	arrWinList[Index++] = "AlchemySkillLearnWnd";
	arrWinList[Index++] = "AlchemySkillWnd";
	arrWinList[Index++] = "AlterSkill";
	arrWinList[Index++] = "AlterSkillJump";
	arrWinList[Index++] = "AnniveEvent";
	arrWinList[Index++] = "AnniveEventLauncher";
	arrWinList[Index++] = "AnnounceMessage";
	arrWinList[Index++] = "ArchiveHotLinkWnd";
	arrWinList[Index++] = "ArchiveViewWnd";
	arrWinList[Index++] = "ArenaCharacterInfoWnd";
	arrWinList[Index++] = "ArenaDualManager";
	arrWinList[Index++] = "ArenaMapGuidance";
	arrWinList[Index++] = "ArenaMatchGroupWnd";
	arrWinList[Index++] = "ArenaMatchWnd";
	arrWinList[Index++] = "ArenaPickWnd";
	arrWinList[Index++] = "ArenaRankingWnd";
	arrWinList[Index++] = "ArenaRevivalWnd";
	arrWinList[Index++] = "ArenaScoreBoardHUD";
	arrWinList[Index++] = "ArenaScoreBoardWnd";
	arrWinList[Index++] = "ArenaSkillUpgrade";
	arrWinList[Index++] = "ArenaTutorialWnd";
	arrWinList[Index++] = "ArmorEnchantEffectTestWnd";
	arrWinList[Index++] = "ArmyTrainingCenterBottomWnd";
	arrWinList[Index++] = "ArmyTrainingCenterWnd";
	arrWinList[Index++] = "AttendCheckWnd";
	arrWinList[Index++] = "AttributeEnchantWnd";
	arrWinList[Index++] = "AttributeRemoveWnd";
	arrWinList[Index++] = "AuctionNextWnd";
	arrWinList[Index++] = "AuctionWnd";
	arrWinList[Index++] = "AutoShotItemWnd";
	arrWinList[Index++] = "AwakeViewWnd";
	arrWinList[Index++] = "BeautyShop";
	arrWinList[Index++] = "BenchMarkMenuWnd";
	arrWinList[Index++] = "BirthdayAlarmBtn";
	arrWinList[Index++] = "BirthdayAlarmWnd";
	arrWinList[Index++] = "BlockCounter";
	arrWinList[Index++] = "BlockCurTriggerWnd";
	arrWinList[Index++] = "BlockCurWnd";
	arrWinList[Index++] = "BlockEnterWnd";
	arrWinList[Index++] = "BoardWnd";
	arrWinList[Index++] = "BOTsystemWnd";
	arrWinList[Index++] = "BR_CampaignAlarmWnd";
	arrWinList[Index++] = "BR_CampaignTopContributorListWnd";
	arrWinList[Index++] = "BR_CashShopAPI";
	arrWinList[Index++] = "BR_CashShopReceiverListAddWnd";
	arrWinList[Index++] = "BR_EventChristmasWnd";
	arrWinList[Index++] = "BR_EventDefaultWnd";
	arrWinList[Index++] = "BR_EventFastivalInkWnd";
	arrWinList[Index++] = "BR_EventFireWnd";
	arrWinList[Index++] = "BR_EventHalloweenTodayWnd";
	arrWinList[Index++] = "BR_EventHalloweenWnd";
	arrWinList[Index++] = "BR_EventHtmlWndA";
	arrWinList[Index++] = "BR_EventHtmlWndB";
	arrWinList[Index++] = "BR_EventHtmlWndC";
	arrWinList[Index++] = "BR_MiniGameRankWnd";
	arrWinList[Index++] = "BR_MyShopWnd";
	arrWinList[Index++] = "BR_NewBuyingWnd";
	arrWinList[Index++] = "BR_NewCashShopReceiverListWnd";
	arrWinList[Index++] = "BR_NewCashShopWnd";
	arrWinList[Index++] = "BR_NewPresentBuyingWnd";
	arrWinList[Index++] = "BR_PathWnd";
	arrWinList[Index++] = "BR_ChinaShop";
	arrWinList[Index++] = "BuilderCmdWnd";
	arrWinList[Index++] = "CalculatorWnd";
	arrWinList[Index++] = "CampaignAlarmWnd";
	arrWinList[Index++] = "CampaignTopContributorListWnd";
	arrWinList[Index++] = "CardDrawEventWnd";
	arrWinList[Index++] = "CardExchange";
	arrWinList[Index++] = "CardExchangeB";
	arrWinList[Index++] = "CardExchangeC";
	arrWinList[Index++] = "CharacterCreateMenuWnd";
	arrWinList[Index++] = "CharacterPasswordHelpHtmlWnd";
	arrWinList[Index++] = "CharacterPasswordWnd";
	arrWinList[Index++] = "ChatAlertMessage";
	arrWinList[Index++] = "ChatWnd";
	arrWinList[Index++] = "ClanDrawerWnd";
	arrWinList[Index++] = "ClanDrawerWndClassic";
	arrWinList[Index++] = "ClanGfxWnd";
	arrWinList[Index++] = "ClanPledgeBonusDrawerWnd";
	arrWinList[Index++] = "ClanRaidsWnd";
	arrWinList[Index++] = "ClanSearch";
	arrWinList[Index++] = "ClanShopEditWnd";
	arrWinList[Index++] = "ClanShopWnd";
	arrWinList[Index++] = "ClanWnd";
	arrWinList[Index++] = "ClanWndClassicNew";
	arrWinList[Index++] = "CleftCounter";
	arrWinList[Index++] = "CleftCurTriggerWnd";
	arrWinList[Index++] = "CleftCurWnd";
	arrWinList[Index++] = "CleftEnterWnd";
	arrWinList[Index++] = "ColorNickNameWnd";
	arrWinList[Index++] = "ConsoleWnd";
	arrWinList[Index++] = "ContainerHUD";
	arrWinList[Index++] = "ContainerWindow";
	arrWinList[Index++] = "ContextMenu";
	arrWinList[Index++] = "CouponEventWnd";
	arrWinList[Index++] = "Credit";
	arrWinList[Index++] = "CrystallizationWnd";
	arrWinList[Index++] = "DamageText";
	arrWinList[Index++] = "DeliverWnd";
	arrWinList[Index++] = "DepthOfField";
	arrWinList[Index++] = "DetailStatusWnd";
	arrWinList[Index++] = "DetailStatusWndClassic";
	arrWinList[Index++] = "DialogBox";
	arrWinList[Index++] = "DominionWarInfoWnd";
	arrWinList[Index++] = "DuelManager";
	arrWinList[Index++] = "EffectTester";
	arrWinList[Index++] = "ElementalSpiritWnd";
	arrWinList[Index++] = "EnsoulExtractSubWnd";
	arrWinList[Index++] = "EnsoulExtractWnd";
	arrWinList[Index++] = "EnsoulSubWnd";
	arrWinList[Index++] = "EnsoulWnd";
	arrWinList[Index++] = "EnvTestWnd";
	arrWinList[Index++] = "ErtheiaTestWnd";
	arrWinList[Index++] = "EventBalthus";
	arrWinList[Index++] = "EventChristmasWnd";
	arrWinList[Index++] = "EventInfoWnd";
	arrWinList[Index++] = "EventKalie";
	arrWinList[Index++] = "EventMatchGMFenceWnd";
	arrWinList[Index++] = "EventMatchGMMsgWnd";
	arrWinList[Index++] = "EventMatchGMWnd";
	arrWinList[Index++] = "EventMatchObserverWnd";
	arrWinList[Index++] = "EventMatchSpecialMsgWnd";
	arrWinList[Index++] = "ExpBar";
	arrWinList[Index++] = "FactionWnd";
	arrWinList[Index++] = "FileListWnd";
	arrWinList[Index++] = "FileRegisterWnd";
	arrWinList[Index++] = "FileWnd";
	arrWinList[Index++] = "Fishing";
	arrWinList[Index++] = "FishViewportWnd";
	arrWinList[Index++] = "FlightShipCtrlWnd";
	arrWinList[Index++] = "FlightTeleportWnd";
	arrWinList[Index++] = "FlightTransformCtrlWnd";
	arrWinList[Index++] = "GametipWnd";
	arrWinList[Index++] = "GfxDialog";
	arrWinList[Index++] = "GfxScreenMessage";
	arrWinList[Index++] = "GfxScreenMessageBG";
	arrWinList[Index++] = "GMClanWnd";
	arrWinList[Index++] = "GMDetailStatusWnd";
	arrWinList[Index++] = "GMFindTreeWnd";
	arrWinList[Index++] = "GMInventoryWnd";
	arrWinList[Index++] = "GMMagicSkillWnd";
	arrWinList[Index++] = "GMSnoopWnd";
	arrWinList[Index++] = "GMWarehouseWnd";
	arrWinList[Index++] = "GMWnd";
	arrWinList[Index++] = "HairshopWnd";
	arrWinList[Index++] = "HDRRenderTestWnd";
	arrWinList[Index++] = "HelpHtmlWnd";
	arrWinList[Index++] = "HelpWnd";
	arrWinList[Index++] = "HennaInfoPremiumWnd";
	arrWinList[Index++] = "HennaInfoWnd";
	arrWinList[Index++] = "HennaListWnd";
	arrWinList[Index++] = "HeroTowerWnd";
	arrWinList[Index++] = "HeroTowerWndWorld";
	arrWinList[Index++] = "InfoWnd";
	arrWinList[Index++] = "IngameNoticeWnd";
	arrWinList[Index++] = "IngameShopWnd";
	arrWinList[Index++] = "IngameWebWnd";
	arrWinList[Index++] = "InstancedZoneHistoryWnd";
	arrWinList[Index++] = "InventoryViewer";
	arrWinList[Index++] = "InventoryWnd";
	arrWinList[Index++] = "InviteClanPopWnd";
	arrWinList[Index++] = "InviteClanPopWndClassic";
	arrWinList[Index++] = "ItemAttributeChangeWnd";
	arrWinList[Index++] = "ItemDescWnd";
	arrWinList[Index++] = "ItemEnchantWnd";
	arrWinList[Index++] = "ItemJewelEnchantSubWnd";
	arrWinList[Index++] = "ItemJewelEnchantWnd";
	arrWinList[Index++] = "ItemLockSubWnd";
	arrWinList[Index++] = "ItemLockWnd";
	arrWinList[Index++] = "ItemLookChangeWnd";
	arrWinList[Index++] = "ItemUpgrade";
	arrWinList[Index++] = "JobTreeWnd";
	arrWinList[Index++] = "KillpointCounterWnd";
	arrWinList[Index++] = "KillpointRankTrigger";
	arrWinList[Index++] = "KillPointRankWnd";
	arrWinList[Index++] = "L2UIGFxScript";
	arrWinList[Index++] = "L2UIGFxScriptNoneContainer";
	arrWinList[Index++] = "L2UIToolTip";
	arrWinList[Index++] = "L2Util";
	arrWinList[Index++] = "LoadingWnd";
	arrWinList[Index++] = "LoadingWnd_cn";
	arrWinList[Index++] = "LoadingWnd_de";
	arrWinList[Index++] = "LoadingWnd_e";
	arrWinList[Index++] = "LoadingWnd_eu";
	arrWinList[Index++] = "LoadingWnd_fr";
	arrWinList[Index++] = "LoadingWnd_id";
	arrWinList[Index++] = "LoadingWnd_j";
	arrWinList[Index++] = "LoadingWnd_k";
	arrWinList[Index++] = "LoadingWnd_ph";
	arrWinList[Index++] = "LoadingWnd_pl";
	arrWinList[Index++] = "LoadingWnd_ru";
	arrWinList[Index++] = "LoadingWnd_th";
	arrWinList[Index++] = "LoadingWnd_tr";
	arrWinList[Index++] = "LoadingWnd_tw";
	arrWinList[Index++] = "LobbyMenuWnd";
	arrWinList[Index++] = "LogIn";
	arrWinList[Index++] = "LogInEula";
	arrWinList[Index++] = "LogInLoading";
	arrWinList[Index++] = "LogInMenu";
	arrWinList[Index++] = "LoginServerSelect";
	arrWinList[Index++] = "LoginSystemMessageWnd";
	arrWinList[Index++] = "LuckyGame";
	arrWinList[Index++] = "MacroEditWnd";
	arrWinList[Index++] = "MacroListWnd";
	arrWinList[Index++] = "MacroPresetWnd";
	arrWinList[Index++] = "MagicSkillDrawerWnd";
	arrWinList[Index++] = "MagicskillGuideWnd";
	arrWinList[Index++] = "MagicSkillWnd";
	arrWinList[Index++] = "MailBtnWnd";
	arrWinList[Index++] = "MainMenu";
	arrWinList[Index++] = "ManorCropInfoChangeWnd";
	arrWinList[Index++] = "ManorCropInfoSettingWnd";
	arrWinList[Index++] = "ManorCropSellChangeWnd";
	arrWinList[Index++] = "ManorCropSellWnd";
	arrWinList[Index++] = "ManorInfoWnd";
	arrWinList[Index++] = "ManorSeedInfoChangeWnd";
	arrWinList[Index++] = "ManorSeedInfoSettingWnd";
	arrWinList[Index++] = "ManorShopWnd";
	arrWinList[Index++] = "Menu";
	arrWinList[Index++] = "MiniGame1Wnd";
	arrWinList[Index++] = "MiniMapGfxWnd";
	arrWinList[Index++] = "MinimapMissionWnd";
	arrWinList[Index++] = "MinimapWnd";
	arrWinList[Index++] = "MonsterArenaResultWnd";
	arrWinList[Index++] = "MonsterBookDetailedInfo";
	arrWinList[Index++] = "MonsterBookWnd";
	arrWinList[Index++] = "MovieCaptureWnd";
	arrWinList[Index++] = "MovieCaptureWnd_Expand";
	arrWinList[Index++] = "MSProfilerWnd";
	arrWinList[Index++] = "MSViewerWnd";
	arrWinList[Index++] = "MultiSellWnd";
	arrWinList[Index++] = "MultiTimer";
	arrWinList[Index++] = "MysteriousMansionControlWnd";
	arrWinList[Index++] = "MysteriousMansionMenuWnd";
	arrWinList[Index++] = "MysteriousMansionResultWnd";
	arrWinList[Index++] = "MysteriousMansionRoomListWnd";
	arrWinList[Index++] = "MysteriousMansionStatusWnd";
	arrWinList[Index++] = "NewPetitionFeedBackResultWnd";
	arrWinList[Index++] = "NewPetitionFeedBackWnd";
	arrWinList[Index++] = "NewPetitionFeedBackWnd_2nd";
	arrWinList[Index++] = "NewPetitionWnd";
	arrWinList[Index++] = "NewUserPetitionDrawerWnd";
	arrWinList[Index++] = "NewUserPetitionWnd";
	arrWinList[Index++] = "NoticeWnd";
	arrWinList[Index++] = "NPCDialogWnd";
	arrWinList[Index++] = "NPCViewerWnd";
	arrWinList[Index++] = "ObserverWnd";
	arrWinList[Index++] = "OlympiadArenaListWnd";
	arrWinList[Index++] = "OlympiadBuff1Wnd";
	arrWinList[Index++] = "OlympiadBuff2Wnd";
	arrWinList[Index++] = "OlympiadBuffWnd";
	arrWinList[Index++] = "OlympiadControlWnd";
	arrWinList[Index++] = "OlympiadGuideWnd";
	arrWinList[Index++] = "OlympiadPlayer1Wnd";
	arrWinList[Index++] = "OlympiadPlayer2Wnd";
	arrWinList[Index++] = "OlympiadPlayerWnd";
	arrWinList[Index++] = "OlympiadResultWnd";
	arrWinList[Index++] = "OlympiadScoreBoardHUD";
	arrWinList[Index++] = "OlympiadTargetWnd";
	arrWinList[Index++] = "OlympiadWnd";
	arrWinList[Index++] = "OptionWnd";
	arrWinList[Index++] = "PacketTest";
	arrWinList[Index++] = "PartyMatchMakeRoomWnd";
	arrWinList[Index++] = "PartyMatchOutWaitListWnd";
	arrWinList[Index++] = "PartyMatchRoomWnd";
	arrWinList[Index++] = "PartyMatchWaitListWnd";
	arrWinList[Index++] = "PartyMatchWnd";
	arrWinList[Index++] = "PartyMatchWndCommon";
	arrWinList[Index++] = "PartyWnd";
	arrWinList[Index++] = "PartyWndArena";
	arrWinList[Index++] = "PartyWndOption";
	arrWinList[Index++] = "PCViewerWnd";
	arrWinList[Index++] = "PersonalConnectionsDrawerWnd";
	arrWinList[Index++] = "PersonalConnectionsWnd";
	arrWinList[Index++] = "PetitionFeedBackWnd";
	arrWinList[Index++] = "PetitionWnd";
	arrWinList[Index++] = "PetStatusWnd";
	arrWinList[Index++] = "PetWnd";
	arrWinList[Index++] = "PlayerAgeWnd";
	arrWinList[Index++] = "PlayerSkillGauge";
	arrWinList[Index++] = "PledgeCreateWnd";
	arrWinList[Index++] = "PostBoxWnd";
	arrWinList[Index++] = "PostDetailWnd_General";
	arrWinList[Index++] = "PostDetailWnd_SafetyTrade";
	arrWinList[Index++] = "PostEffectTestWnd";
	arrWinList[Index++] = "PostReceiverListAddWnd";
	arrWinList[Index++] = "PostReceiverListWnd";
	arrWinList[Index++] = "PostWriteWnd";
	arrWinList[Index++] = "PremiumItemAlarmWnd";
	arrWinList[Index++] = "PremiumItemGetWnd";
	arrWinList[Index++] = "PrivateMarketWnd";
	arrWinList[Index++] = "PrivateShopWnd";
	arrWinList[Index++] = "PrivateShopWndHistory";
	arrWinList[Index++] = "PrivateShopWndReport";
	arrWinList[Index++] = "ProductInventoryDrawerWnd";
	arrWinList[Index++] = "ProductInventoryHelpHtmlWnd";
	arrWinList[Index++] = "ProductInventoryWnd";
	arrWinList[Index++] = "ProgressBox";
	arrWinList[Index++] = "PVBuilderCmdWnd";
	arrWinList[Index++] = "PVPCounter";
	arrWinList[Index++] = "PVPCounterTrigger";
	arrWinList[Index++] = "PVPDetailedWnd";
	arrWinList[Index++] = "PVShortcutWnd";
	arrWinList[Index++] = "QuestAlarmWnd";
	arrWinList[Index++] = "QuestBtnWnd";
	arrWinList[Index++] = "QuestHTMLWnd";
	arrWinList[Index++] = "QuestListWnd";
	arrWinList[Index++] = "QuestTreeWnd";
	arrWinList[Index++] = "QuestTutorialWnd";
	arrWinList[Index++] = "QuitReportDrawerWnd";
	arrWinList[Index++] = "QuitReportWnd";
	arrWinList[Index++] = "RadarMapWnd";
	arrWinList[Index++] = "RecipeBookWnd";
	arrWinList[Index++] = "RecipeBuyListWnd";
	arrWinList[Index++] = "RecipeBuyManufactureWnd";
	arrWinList[Index++] = "RecipeManufactureWnd";
	arrWinList[Index++] = "RecipeShopWnd";
	arrWinList[Index++] = "RecipeTreeWnd";
	arrWinList[Index++] = "RecommendBonusHelpHtmlWnd";
	arrWinList[Index++] = "RecommendBonusWnd";
	arrWinList[Index++] = "RefineryWnd";
	arrWinList[Index++] = "ReplayListWnd";
	arrWinList[Index++] = "ReplayLogoWnd";
	arrWinList[Index++] = "ReplayLogoWnd_cn";
	arrWinList[Index++] = "ReplayLogoWnd_de";
	arrWinList[Index++] = "ReplayLogoWnd_e";
	arrWinList[Index++] = "ReplayLogoWnd_eu";
	arrWinList[Index++] = "ReplayLogoWnd_fr";
	arrWinList[Index++] = "ReplayLogoWnd_id";
	arrWinList[Index++] = "ReplayLogoWnd_j";
	arrWinList[Index++] = "ReplayLogoWnd_k";
	arrWinList[Index++] = "ReplayLogoWnd_ph";
	arrWinList[Index++] = "ReplayLogoWnd_pl";
	arrWinList[Index++] = "ReplayLogoWnd_ru";
	arrWinList[Index++] = "ReplayLogoWnd_th";
	arrWinList[Index++] = "ReplayLogoWnd_tr";
	arrWinList[Index++] = "ReplayLogoWnd_tw";
	arrWinList[Index++] = "RestartMenuWnd";
	arrWinList[Index++] = "Sample";
	arrWinList[Index++] = "SceneClipView";
	arrWinList[Index++] = "SceneEditorSlideWnd";
	arrWinList[Index++] = "SceneEditorWnd";
	arrWinList[Index++] = "SeedShopWnd";
	arrWinList[Index++] = "SelectDeliverWnd";
	arrWinList[Index++] = "SellingAgencyWnd";
	arrWinList[Index++] = "ShaderBuild";
	arrWinList[Index++] = "SheathingWnd";
	arrWinList[Index++] = "ShopWnd";
	arrWinList[Index++] = "Shortcut";
	arrWinList[Index++] = "ShortcutWnd";
	arrWinList[Index++] = "ShortcutWndArena";
	arrWinList[Index++] = "SiegeInfoWnd";
	arrWinList[Index++] = "SiegeReportWnd";
	arrWinList[Index++] = "SkillLearnWnd";
	arrWinList[Index++] = "SkillTrainClanTreeWnd";
	arrWinList[Index++] = "SkillTrainInfoWnd";
	arrWinList[Index++] = "SkillTrainListWnd";
	arrWinList[Index++] = "SSAOWnd";
	arrWinList[Index++] = "SSQMainBoard";
	arrWinList[Index++] = "StatusWnd";
	arrWinList[Index++] = "SummonedStatusWnd";
	arrWinList[Index++] = "SummonedWnd";
	arrWinList[Index++] = "SummonedWndClassic";
	arrWinList[Index++] = "SystemMsgWnd";
	arrWinList[Index++] = "TargetStatusBuff1Wnd";
	arrWinList[Index++] = "TargetStatusBuff2Wnd";
	arrWinList[Index++] = "TargetStatusWnd";
	arrWinList[Index++] = "TargetStatusWndArena";
	arrWinList[Index++] = "TeleportBookMarkDrawerWnd";
	arrWinList[Index++] = "TeleportBookMarkWnd";
	arrWinList[Index++] = "ToDoListClanWnd";
	arrWinList[Index++] = "ToDoListWnd";
	arrWinList[Index++] = "TokenTradeWnd";
	arrWinList[Index++] = "Tooltip";
	arrWinList[Index++] = "ToolTipWnd";
	arrWinList[Index++] = "TownMapWnd";
	arrWinList[Index++] = "TradeWnd";
	arrWinList[Index++] = "TutorialBtnWnd";
	arrWinList[Index++] = "TutorialViewerWnd";
	arrWinList[Index++] = "UICommandWnd";
	arrWinList[Index++] = "UICommonAPI";
	arrWinList[Index++] = "UIConstants";
	arrWinList[Index++] = "UIData";
	arrWinList[Index++] = "UIDebugWnd";
	arrWinList[Index++] = "UIDevTestWnd";
	arrWinList[Index++] = "UIDevTestWnd_SubFrameWnd";
	arrWinList[Index++] = "UIEasyLoginWnd";
	arrWinList[Index++] = "UIEditor_ControlManager";
	arrWinList[Index++] = "UIEditor_DocumentInfo";
	arrWinList[Index++] = "UIEditor_FileManager";
	arrWinList[Index++] = "UIEditor_PropertyController";
	arrWinList[Index++] = "UIEditor_Worksheet";
	arrWinList[Index++] = "UIHtmlToolWnd";
	arrWinList[Index++] = "UIItemToolWnd";
	arrWinList[Index++] = "UIOpenToolWnd";
	arrWinList[Index++] = "UIPowerToolWnd";
	arrWinList[Index++] = "UIQuestToolWnd";
	arrWinList[Index++] = "UISearchMapWnd";
	arrWinList[Index++] = "UIServerHtmlToolWnd";
	arrWinList[Index++] = "UISysMsgToolWnd";
	arrWinList[Index++] = "UIToolWnd";
	arrWinList[Index++] = "UnionDetailWnd";
	arrWinList[Index++] = "UnionDetailWndClassic";
	arrWinList[Index++] = "UnionMatchDrawerWnd";
	arrWinList[Index++] = "UnionMatchMakeRoomWnd";
	arrWinList[Index++] = "UnionMatchWnd";
	arrWinList[Index++] = "UnionWnd";
	arrWinList[Index++] = "UniversalToolTip";
	arrWinList[Index++] = "UnrefineryWnd";
	arrWinList[Index++] = "UserAlertMessage";
	arrWinList[Index++] = "UserPetitionWnd";
	arrWinList[Index++] = "ViewPortElementalSpirit";
	arrWinList[Index++] = "ViewPortWndArena";
	arrWinList[Index++] = "ViewPortWndBase";
	arrWinList[Index++] = "ViewPortWndEffect";
	arrWinList[Index++] = "ViewPortWndMonster";
	arrWinList[Index++] = "VipInfoWnd";
	arrWinList[Index++] = "WarehouseWnd";
	arrWinList[Index++] = "WeatherWnd";
	arrWinList[Index++] = "WebBrowserWnd";
	arrWinList[Index++] = "WebPetitionWnd";
	arrWinList[Index++] = "WorldChatBox";
	arrWinList[Index++] = "WorldOlympiadResultWnd";
	arrWinList[Index++] = "XMasSealWnd";
	arrWinList[Index++] = "ZoneQuestAlarmWnd";
	arrWinList[Index++] = "ZoneQuestSituationWnd";
	arrWinList[Index++] = "ZoneTitleWnd";
	MakeWindowList();
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="UIToolWnd"
}
