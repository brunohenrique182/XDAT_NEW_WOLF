class Shortcut extends UICommonAPI;

const CHAT_WINDOW_NORMAL = 0;
const CHAT_WINDOW_TRADE = 1;
const CHAT_WINDOW_PARTY = 2;
const CHAT_WINDOW_CLAN = 3;
const CHAT_WINDOW_ALLY = 4;
const CHAT_WINDOW_COUNT = 5;
const CHAT_WINDOW_SYSTEM = 5;
const DIALOGID_Gohome = 44420;

var bool m_chatstateok;

event OnRegisterEvent()
{
	RegisterEvent(90);
	RegisterEvent(3410);
	RegisterEvent(3080);
	RegisterEvent(1710);
	RegisterEvent(1720);
	return;
}

event OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 90:
			HandleShortcutCommand(a_Param);
			break;
		case 3410:
			HandleStateChange(a_Param);
			break;
		case 3080:
			HandleShortcutKeyEvent(a_Param);
			break;
		case 1710:
			HandleDialogOK();
			break;
		default:
			break;
	}
	return;
}

static function Shortcut Inst()
{
	return Shortcut(GetScript("Shortcut"));
}

function _ExeShowHideWIndow(string wndname)
{
	HandleShortcutKeyEventWindow(wndname);
	return;
}

function OptionMuteModeChange()
{
	local int currentMODE;

	currentMODE = GetOptionInt("Audio", "MODE");
	if((currentMODE == 2))
	{
		currentMODE = 0;
	}
	else
	{
		currentMODE++;
	}
	SetOptionInt("Audio", "MODE", currentMODE);
	Debug("Shorcut OptionMuteModeChanged");
	OptionWnd(GetScript("OptionWnd"))._InitAudioOption();
	return;
}

function HandleShortcutKeyEventWindow(string wndname)
{
	local OptionWnd o_script;
	local ShortcutWnd s_script;
	local WindowHandle TempWnd;
	local string TargetName;

	o_script = OptionWnd(GetScript("OptionWnd"));
	s_script = ShortcutWnd(GetScript("ShortcutWnd"));
	if(getInstanceUIData().GetIsClassicServer())
	{
		TargetName = TargetStatusWndClassic(GetScript("TargetStatusWndClassic")).g_NameStr;
	}
	else
	{
		TargetName = TargetStatusWnd(GetScript("TargetStatusWnd")).g_NameStr;
	}
	switch(wndname)
	{
		case "QuestTreeWnd":
		case "QuestWnd":
			if((getInstanceUIData().GetIsLiveServer() || IsAdenServer()))
			{
				wndname = "QuestWnd";
			}
			else
			{
				wndname = "QuestTreeWnd";
			}
			break;
		case "GMWnd":
		case "GMClanWnd":
		case "GMDetailStatusWnd":
		case "GMInventoryWnd":
		case "GMMagicSkillWnd":
		case "GMWarehouseWnd":
		case "GMSnoopWnd":
		case "GMPetitionWnd":
			if(!IsBuilderPC())
			{
				return;
			}
			break;
		default:
			break;
	}
	switch(wndname)
	{
		case "InventoryWnd":
			ExecuteEvent(2631);
			break;
		case "MacroWnd":
			ExecuteEvent(1230);
			break;
		case "PartyMatchWnd":
			HandlePartyMatchingOnOff();
			break;
		case "BoardWnd":
			TempWnd = GetWindowHandle("BoardWnd");
			if(TempWnd.IsShowWindow())
			{
				TempWnd.HideWindow();
			}
			else
			{
				ExecuteEvent(1190);
			}
			break;
		case "MinimapWnd":
			RequestOpenMinimap();
			break;
		case "HelpHtmlWnd":
			HandleShowHelpHtmlWnd();
			break;
		case "FN_HideDropItemSilhauette":
			if(GetOptionBool("ScreenInfo", "HideDropItem"))
			{
				SetOptionBool("ScreenInfo", "HideDropItem", false);
			}
			else
			{
				SetOptionBool("ScreenInfo", "HideDropItem", true);
			}
			o_script.InitScreenInfoOption();
			break;
		case "FN_SendTargetedCharacterMessage":
			if((TargetName == ""))
			{
			}
			else
			{
				SetChatMessage((("\"" $ TargetName) $ " "));
			}
			break;
		case "FN_MuteAllAudio":
			OptionMuteModeChange();
			break;
		case "FN_SHORTCUTEXPAND":
			s_script.OnClickExpandShortcutButton();
			break;
		case "FN_UILocReset":
			o_script.SetDefaultPositionByClick();
			break;
		case "SystemMenuWnd":
			break;
		case "Post":
			HandleShowPostBoxWnd();
			break;
		case "ShortcutAssign":
			HandleShowShortcutAssignWnd();
			break;
		case "InstancedZone":
			if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("InstancedZoneHistoryWnd"))
			{
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow("InstancedZoneHistoryWnd");
			}
			else
			{
				RequestInzoneWaitingTime();
			}
			break;
		case "Rec":
			HandleShowMovieCaptureWnd();
			break;
		case "Replayrec":
			DoAction(Class'Interface.UICommonAPI'.static.GetItemID(55));
			break;
		case "Productinven":
			HandleShowProductInventory();
			break;
		case "ShopSell":
			if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("PrivateShopWnd"))
			{
				PrivateShopWnd(GetScript("PrivateShopWnd")).OnClickButton("StopButton");
			}
			else
			{
				DoAction(Class'Interface.UICommonAPI'.static.GetItemID(10));
			}
			break;
		case "ShopBuy":
			if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("PrivateShopWnd"))
			{
				PrivateShopWnd(GetScript("PrivateShopWnd")).OnClickButton("StopButton");
			}
			else
			{
				DoAction(Class'Interface.UICommonAPI'.static.GetItemID(28));
			}
			break;
		case "ShopSellAll":
			if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("PrivateShopWnd"))
			{
				PrivateShopWnd(GetScript("PrivateShopWnd")).OnClickButton("StopButton");
			}
			else
			{
				DoAction(Class'Interface.UICommonAPI'.static.GetItemID(61));
			}
			break;
		case "ShopSearch":
			DoAction(Class'Interface.UICommonAPI'.static.GetItemID(57));
			break;
		case "Petition":
			HandleShowPetitionBegin();
			break;
		case "Homepage":
			linkHomePage();
			break;
		case "PcRoom":
			HandleToggleShowPCCafeEventWnd();
			break;
		default:
			WindowOpenOrClose(wndname);
			break;
	}
	return;
}

function HandleShortcutKeyEvent(string a_Param)
{
	local string wndname;

	ParseString(a_Param, "Name", wndname);
	HandleShortcutKeyEventWindow(wndname);
	return;
}

function string getWindowNameByServerType(string wndname)
{
	if((wndname == "ChatMessage"))
	{
		wndname = "ChatWnd";
	}
	else if(getInstanceUIData().GetIsClassicServer())
	{
		wndname = GetClassicWindowName(wndname);
		if((wndname == "ClanWndClassic"))
		{
			wndname = "ClanWndClassicNew";
		}
	}
	return wndname;
}

function string GetClassicWindowName(string wndname)
{
	switch(wndname)
	{
		case "ClanWnd":
		case "DetailStatusWnd":
			return (wndname $ "Classic");
		default:
			return wndname;
	}
}

function PlayOpenSound(string wndname)
{
	switch(wndname)
	{
		case "AdenLabWnd":
			PlaySound("InterfaceSound.AdenLab_Open");
			break;
		case "MagicSkillWnd":
			PlayConsoleSound(IFST_MAPWND_OPEN);
			break;
		case "ActionWnd":
		case "DetailStatusWnd":
		case "DetailStatusWndClassic":
			PlayConsoleSound(IFST_WINDOW_OPEN);
			break;
		default:
			Debug("DefaultSoundOpen");
			PlayConsoleSound(IFST_STATUSWND_OPEN);
			break;
	}
	return;
}

function PlayCloseSound(string wndname)
{
	switch(wndname)
	{
		case "MagicSkillWnd":
			PlayConsoleSound(IFST_MAPWND_CLOSE);
			break;
		case "ActionWnd":
		case "DetailStatusWnd":
		case "DetailStatusWndClassic":
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			break;
		default:
			Debug("DefaultSoundCLose");
			PlayConsoleSound(IFST_STATUSWND_CLOSE);
			break;
	}
	return;
}

function WindowOpenOrClose(string wndname)
{
	local WindowHandle WNDNameHandle;
	local int tempVars;

	wndname = getWindowNameByServerType(wndname);
	WNDNameHandle = GetWindowHandle(wndname);
	switch(wndname)
	{
		case "TeleportMapWnd":
			if(true)
			{
				if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("TeleportWnd"))
				{
					Class'NWindow.UIAPI_WINDOW'.static.HideWindow("TeleportWnd");
				}
				else
				{
					if(Class'NWindow.UIDATA_PLAYER'.static.IsInDethrone())
					{
						getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
						return;
					}
					Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("TeleportWnd");
				}
			}
			else if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow(wndname))
			{
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow(wndname);
			}
			else
			{
				if(Class'NWindow.UIDATA_PLAYER'.static.IsInDethrone())
				{
					getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
					return;
				}
				TeleportMapWnd(GetScript("TeleportMapWnd")).RQ_C_EX_Teleport_UI();
			}
			break;
		case "RadarMapWnd":
			toggleWindow(wndname);
			break;
		case "OptionWnd":
			toggleShowOptionWnd();
			break;
		case "ChatWnd":
			if(WNDNameHandle.IsShowWindow())
			{
				CallGFxFunction("WorldChatBox", "ToggleShowWnd", "hide");
				WNDNameHandle.HideWindow();
				PlayCloseSound(wndname);
			}
			else
			{
				GetINIBool("global", "UseWorldChatSpeaker", tempVars, "chatfilter.ini");
				if(bool(tempVars))
				{
					CallGFxFunction("WorldChatBox", "ToggleShowWnd", "show");
				}
				WNDNameHandle.ShowWindow();
				WNDNameHandle.SetFocus();
				PlayOpenSound(wndname);
			}
			break;
		case "ClanWnd":
		case "ClanWndClassicNew":
			if(getInstanceUIData().GetIsClassicServer())
			{
				if(getInstanceL2Util().isClanV2())
				{
					toggleWindow("ClanGfxWnd", true, true);
				}
				else
				{
					toggleWindow("ClanWndClassicNew", true, true);
				}
			}
			else if(getInstanceL2Util().isClanV2())
			{
				toggleWindow("ClanGfxWnd", true, true);
			}
			else
			{
				toggleWindow("ClanWnd", true, true);
			}
			break;
		case "MagicSKillWnd":
			if(IsUseRenewalSkillWnd())
			{
				if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("SkillWnd"))
				{
					Class'NWindow.UIAPI_WINDOW'.static.HideWindow("SkillWnd");
					PlayCloseSound(wndname);
				}
				else
				{
					Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("SkillWnd");
					PlayOpenSound(wndname);
				}
			}
			else if(WNDNameHandle.IsShowWindow())
			{
				WNDNameHandle.HideWindow();
				PlayCloseSound(wndname);
			}
			else
			{
				WNDNameHandle.ShowWindow();
				WNDNameHandle.SetFocus();
				PlayOpenSound(wndname);
			}
			break;
		default:
			if(WNDNameHandle.IsShowWindow())
			{
				WNDNameHandle.HideWindow();
				PlayCloseSound(wndname);
			}
			else
			{
				WNDNameHandle.ShowWindow();
				WNDNameHandle.SetFocus();
				PlayOpenSound(wndname);
			}
			break;
	}
	return;
}

function toggleShowOptionWnd()
{
	local OptionWnd win;

	win = OptionWnd(GetScript("OptionWnd"));
	win.ToggleOpenMeWnd(false);
	return;
}

function HandleShowShortcutAssignWnd()
{
	local OptionWnd win;

	win = OptionWnd(GetScript("OptionWnd"));
	win.ToggleOpenMeWnd(true);
	return;
}

function HandleToggleShowPCCafeEventWnd()
{
	return;
}

function HandleShowMovieCaptureWnd()
{
	local bool tmpBool;
	local WindowHandle win, win1;

	win = GetWindowHandle("MovieCaptureWnd_Expand");
	win1 = GetWindowHandle("MovieCaptureWnd");
	tmpBool = IsNowMovieCapturing();
	if(tmpBool)
	{
		win.HideWindow();
		if(win.IsShowWindow())
		{
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			win.HideWindow();
		}
		else
		{
			PlayConsoleSound(IFST_WINDOW_OPEN);
			win.ShowWindow();
			win.SetFocus();
		}
	}
	else if(win1.IsShowWindow())
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		win1.HideWindow();
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_OPEN);
		win1.ShowWindow();
		win1.SetFocus();
	}
	return;
}

function HandleShowPetitionBegin()
{
	local WindowHandle win, win1, win2;
	local UIScript.PetitionMethod useNewPetition;

	win = GetWindowHandle("NewUserPetitionWnd");
	win1 = GetWindowHandle("UserPetitionWnd");
	win2 = GetWindowHandle("WebPetitionWnd");
	useNewPetition = PetitionMethod(GetPetitionMethod());
	if((int(useNewPetition) == 1))
	{
		if(win.IsShowWindow())
		{
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			win.HideWindow();
		}
		else
		{
			PlayConsoleSound(IFST_WINDOW_OPEN);
			RequestShowPetitionAsMethod();
		}
	}
	else if((int(useNewPetition) == 0))
	{
		if(win1.IsShowWindow())
		{
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			win1.HideWindow();
		}
		else
		{
			PlayConsoleSound(IFST_WINDOW_OPEN);
			win1.ShowWindow();
			win1.SetFocus();
		}
	}
	else if((int(useNewPetition) == 2))
	{
		if(win2.IsShowWindow())
		{
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			win2.HideWindow();
		}
		else
		{
			PlayConsoleSound(IFST_WINDOW_OPEN);
			RequestShowPetitionAsMethod();
		}
	}
	return;
}

function linkHomePage()
{
	DialogSetID(44420);
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(3208));
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
		case 44420:
			OpenL2Home();
			break;
		default:
			break;
	}
	return;
}

function HandleShowProductInventory()
{
	local WindowHandle win, win1;
	local L2Util util;

	win = GetWindowHandle("ProductInventoryWnd");
	win1 = GetWindowHandle("ShopWnd");
	util = L2Util(GetScript("L2Util"));
	if(win.IsShowWindow())
	{
		PlayConsoleSound(IFST_INVENWND_CLOSE);
		win.HideWindow();
	}
	else
	{
		util.ItemRelationWindowHide("ProductInventoryWnd");
		if(!win1.IsShowWindow())
		{
			PlayConsoleSound(IFST_INVENWND_OPEN);
			win.ShowWindow();
			win.SetFocus();
		}
	}
	return;
}

function HandleShowPostBoxWnd()
{
	local WindowHandle win;

	win = GetWindowHandle("PostBoxWnd");
	if(win.IsShowWindow())
	{
		win.HideWindow();
		PlayConsoleSound(IFST_WINDOW_CLOSE);
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_OPEN);
		RequestRequestReceivedPostList();
	}
	return;
}

function ClosePartyMatchingWnd()
{
	local WindowHandle TaskWnd;
	local PartyMatchWnd p_script;

	p_script = PartyMatchWnd(GetScript("PartyMatchWnd"));
	if((1 == 0))
	{
		TaskWnd = GetHandle("PartyMatchWnd");
	}
	else
	{
		TaskWnd = GetWindowHandle("PartyMatchWnd");
	}
	TaskWnd.HideWindow();
	p_script.OnSendPacketWhenHiding();
	return;
}

function HandleShowBBS()
{
	local string param;

	if(GetWindowHandle("IngameWebWnd").IsShowWindow())
	{
		GetWindowHandle("IngameWebWnd").HideWindow();
		return;
	}
	param = "";
	ParamAdd(param, "Category", "bbs");
	ExecuteEvent(10120, param);
	return;
}

function HandleShowHelpHtmlWnd()
{
	local AgeWnd script1;

	Class'Interface.HelpWnd'.static.ShowHelp();
	script1 = AgeWnd(GetScript("AgeWnd"));
	if((script1.bBlock == false))
	{
		script1.startAge();
	}
	return;
}

function HandlePartyMatchingOnOff()
{
	local WindowHandle PartyMatchRoomWnd, PartyMatchWnd;
	local PartyMatchRoomWnd p2_script;
	local L2Util util;

	if(getInstanceUIData().getIsArenaServer())
	{
		util = L2Util(GetScript("L2Util"));
		util.showGfxScreenMessage(GetSystemMessage(5517));
	}
	PartyMatchWnd = GetWindowHandle("PartyMatchWnd");
	PartyMatchRoomWnd = GetWindowHandle("PartyMatchRoomWnd");
	p2_script = PartyMatchRoomWnd(GetScript("PartyMatchRoomWnd"));
	if(PartyMatchWnd.IsShowWindow())
	{
		ClosePartyMatchingWnd();
	}
	else if(PartyMatchRoomWnd.IsShowWindow())
	{
		PartyMatchRoomWnd.HideWindow();
		p2_script.OnSendPacketWhenHiding();
		PartyMatchWnd.SetTimer(1991, 500);
	}
	else
	{
		Class'NWindow.PartyMatchAPI'.static.RequestOpenPartyMatch();
	}
	return;
}

function OnTimer(int TimerID)
{
	if((TimerID == 1991))
	{
		ClosePartyMatchingWnd();
		Class'NWindow.UIAPI_WINDOW'.static.KillUITimer("ShortcutTab", 1991);
	}
	return;
}

function HandleShortcutCommand(string a_Param)
{
	local string Command;

	if(ParseString(a_Param, "Command", Command))
	{
		switch(Command)
		{
			case "CloseAllWindow":
				HandleCloseAllWindow();
				break;
			case "ShowChatWindow":
				HandleShowChatWindow();
				break;
			case "SetPrevChatType":
				HandleSetPrevChatType();
				break;
			case "SetNextChatType":
				HandleSetNextChatType();
				break;
			case "shortcutreset":
				Class'NWindow.ShortcutAPI'.static.RestoreDefault();
				break;
			case "shortcutsave":
				Class'NWindow.ShortcutAPI'.static.Save();
				break;
			case "shortcutload":
				Class'NWindow.ShortcutAPI'.static.RequestList();
				break;
			case "test":
				HandleShortcutTest();
				break;
			case "printshortcut":
				HandlePrintShortcut();
				break;
			case "getPrevTarget":
				if(getInstanceUIData().getIsArenaServer())
				{
					ExecuteCommand("/targetPrev");
				}
				break;
			case "getNextTarget":
				if(getInstanceUIData().getIsArenaServer())
				{
					ExecuteCommand("/targetNext");
				}
				break;
			case "useRunSkill":
				if(getInstanceUIData().getIsArenaServer())
				{
					setUseSkill(18651);
				}
				break;
			case "useBaseRecallSkill":
				if(getInstanceUIData().getIsArenaServer())
				{
					setUseSkill(18652);
				}
				break;
			case "AutoPlay":
				if(getInstanceUIData().GetIsLiveServer())
				{
					AutoUseItemWnd(GetScript("AutoUseItemWnd")).OnClickButton("AutoTargetAll_BTN");
				}
				else
				{
					YetiQuickSlotWnd(GetScript("YetiQuickSlotWnd")).OnAutoHunt_All_BtnClick();
				}
				break;
			case "HideAllWindow":
				HandleHideAllWindow();
			default:
				break;
		}
	}
	return;
}

function setUseSkill(int SkillID)
{
	local ItemID skillItemID;

	skillItemID.ClassID = SkillID;
	UseSkill(skillItemID, 2);
	return;
}

function HandleHideAllWindow()
{
	return;
}

function HandlePrintShortcut()
{
	local array<ShortcutCommandItem> CommandList;
	local array<string> grouplist;
	local int i;

	Class'NWindow.ShortcutAPI'.static.GetGroupList(grouplist);
	i = 0;
	while((i < grouplist.Length))
	{
		CommandList.Length = 0;
		Class'NWindow.ShortcutAPI'.static.GetGroupCommandList(grouplist[i], CommandList);
		++i;
	}
	grouplist.Length = 0;
	Class'NWindow.ShortcutAPI'.static.GetActiveGroupList(grouplist);
	i = 0;
	while((i < grouplist.Length))
	{
		++i;
	}
	return;
}

function HandleForceShowChatWindow(bool bOpen)
{
	local WindowHandle Handle;
	local int tempVars;

	Handle = GetWindowHandle("ChatWnd");
	if(bOpen)
	{
		Handle.ShowWindow();
		GetINIBool("global", "SystemMsgWnd", tempVars, "chatfilter.ini");
		if(bool(tempVars))
		{
			if(getInstanceUIData().GetIsLiveServer())
			{
				Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("SystemMsgWnd");
			}
		}
	}
	else
	{
		Handle.HideWindow();
		GetINIBool("global", "SystemMsgWnd", tempVars, "chatfilter.ini");
		if(!bool(tempVars))
		{
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow("SystemMsgWnd");
		}
	}
	return;
}

function HandleShortcutTest()
{
	return;
}

function HandleShowChatWindow()
{
	local WindowHandle Handle;
	local int tempVars;

	Handle = GetWindowHandle("ChatWnd");
	if(Handle.IsShowWindow())
	{
		Handle.HideWindow();
		GetINIBool("global", "SystemMsgWnd", tempVars, "chatfilter.ini");
		if(!bool(tempVars))
		{
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow("SystemMsgWnd");
		}
	}
	else
	{
		Handle.ShowWindow();
		GetINIBool("global", "SystemMsgWnd", tempVars, "chatfilter.ini");
		if(bool(tempVars))
		{
			if(getInstanceUIData().GetIsLiveServer())
			{
				Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("SystemMsgWnd");
			}
		}
	}
	return;
}

function HandleSetPrevChatType()
{
	local ChatWnd chatWndScript;

	chatWndScript = ChatWnd(GetScript("ChatWnd"));
	switch(chatWndScript.m_chatType.UI)
	{
		case 0:
			chatWndScript.ChatTabCtrl.SetTopOrder(4, true);
			chatWndScript.HandleTabClick("ChatTabCtrl4");
			break;
		case 1:
			chatWndScript.ChatTabCtrl.SetTopOrder(0, true);
			chatWndScript.HandleTabClick("ChatTabCtrl0");
			break;
		case 2:
			chatWndScript.ChatTabCtrl.SetTopOrder(1, true);
			chatWndScript.HandleTabClick("ChatTabCtrl1");
			break;
		case 3:
			chatWndScript.ChatTabCtrl.SetTopOrder(2, true);
			chatWndScript.HandleTabClick("ChatTabCtrl2");
			break;
		case 4:
			chatWndScript.ChatTabCtrl.SetTopOrder(3, true);
			chatWndScript.HandleTabClick("ChatTabCtrl3");
			break;
		default:
			break;
	}
	return;
}

function HandleSetNextChatType()
{
	local ChatWnd chatWndScript;

	chatWndScript = ChatWnd(GetScript("ChatWnd"));
	switch(chatWndScript.m_chatType.UI)
	{
		case 0:
			chatWndScript.ChatTabCtrl.SetTopOrder(1, true);
			chatWndScript.HandleTabClick("ChatTabCtrl1");
			break;
		case 1:
			chatWndScript.ChatTabCtrl.SetTopOrder(2, true);
			chatWndScript.HandleTabClick("ChatTabCtrl2");
			break;
		case 2:
			chatWndScript.ChatTabCtrl.SetTopOrder(3, true);
			chatWndScript.HandleTabClick("ChatTabCtrl3");
			break;
		case 3:
			chatWndScript.ChatTabCtrl.SetTopOrder(4, true);
			chatWndScript.HandleTabClick("ChatTabCtrl4");
			break;
		case 4:
			chatWndScript.ChatTabCtrl.SetTopOrder(0, true);
			chatWndScript.HandleTabClick("ChatTabCtrl0");
			break;
		default:
			break;
	}
	return;
}

function HandleCloseAllWindow()
{
	local WindowHandle Handle;
	local int i;
	local array<string> WndList, GFxWndList;
	local PrivateShopWnd PrivateShopWndScript;
	local ItemAutoPeelWnd ItemAutoPeelScript;

	PrivateShopWndScript = PrivateShopWnd(GetScript("PrivateShopWnd"));
	PrivateShopWndScript.RequestQuit();
	ItemAutoPeelScript = ItemAutoPeelWnd(GetScript("ItemAutoPeelWnd"));
	ItemAutoPeelScript.CloseWindow();
	if((Class'NWindow.UIDATA_PLAYER'.static.IsInDethrone() == false))
	{
		Class'NWindow.RecipeAPI'.static.RequestRecipeShopManageQuit();
		Debug("--> RequestRecipeShopManageQuit");
		Class'NWindow.EnchantAPI'.static.RequestExCancelEnchantItem();
		Debug("--> RequestExCancelEnchantItem");
	}
	WndList[WndList.Length] = "ActionWnd";
	WndList[WndList.Length] = "AttributeEnchantWnd";
	WndList[WndList.Length] = "AttributeRemoveWnd";
	WndList[WndList.Length] = "BoardWnd";
	WndList[WndList.Length] = "CalculatorWnd";
	WndList[WndList.Length] = getWindowNameByServerType("ClanWnd");
	WndList[WndList.Length] = "ConsoleWnd";
	WndList[WndList.Length] = "CouponEventWnd";
	WndList[WndList.Length] = "DeliverWnd";
	WndList[WndList.Length] = "SelectDeliverWnd";
	WndList[WndList.Length] = getWindowNameByServerType("DetailStatusWnd");
	WndList[WndList.Length] = "MailBtnWnd";
	WndList[WndList.Length] = "HelpHtmlWnd";
	WndList[WndList.Length] = "HelpWnd";
	WndList[WndList.Length] = "HennaInfoWnd";
	WndList[WndList.Length] = "HennaListWnd";
	WndList[WndList.Length] = "HennaInfoWndLive";
	WndList[WndList.Length] = "HennaListWndLive";
	WndList[WndList.Length] = "HennaEngraveWndLive";
	WndList[WndList.Length] = "HeroTowerWnd";
	WndList[WndList.Length] = "HeroTowerWndWorld";
	WndList[WndList.Length] = "InventoryWnd";
	WndList[WndList.Length] = "ItemEnchantWnd";
	WndList[WndList.Length] = "XMasSealWnd";
	WndList[WndList.Length] = "MacroEditWnd";
	WndList[WndList.Length] = "MacroListWnd";
	WndList[WndList.Length] = "MagicSkillWnd";
	WndList[WndList.Length] = "ManorCropInfoChangeWnd";
	WndList[WndList.Length] = "ManorCropInfoSettingWnd";
	WndList[WndList.Length] = "ManorCropSellChangeWnd";
	WndList[WndList.Length] = "ManorCropSellWnd";
	WndList[WndList.Length] = "ManorInfoWnd";
	WndList[WndList.Length] = "ManorSeedInfoChangeWnd";
	WndList[WndList.Length] = "ManorSeedInfoSettingWnd";
	WndList[WndList.Length] = "ManorShopWnd";
	WndList[WndList.Length] = "MultiSellWnd";
	WndList[WndList.Length] = "OptionWnd";
	WndList[WndList.Length] = "PetitionFeedBackWnd";
	WndList[WndList.Length] = "PetitionWnd";
	WndList[WndList.Length] = "UserPetitionWnd";
	WndList[WndList.Length] = "PetWnd";
	WndList[WndList.Length] = "PetWndClassic";
	WndList[WndList.Length] = "PrivateShopWnd";
	WndList[WndList.Length] = "QuestListWnd";
	WndList[WndList.Length] = "RecipeBookWnd";
	WndList[WndList.Length] = "RecipeBuyListWnd";
	WndList[WndList.Length] = "RecipeBuyManufactureWnd";
	WndList[WndList.Length] = "RecipeManufactureWnd";
	WndList[WndList.Length] = "RecipeShopWnd";
	WndList[WndList.Length] = "RecipeTreeWnd";
	WndList[WndList.Length] = "RefineryWnd";
	WndList[WndList.Length] = "ReplayListWnd";
	WndList[WndList.Length] = "ReplayLogoWnd";
	WndList[WndList.Length] = "ShopWnd";
	WndList[WndList.Length] = "SiegeInfoWnd";
	WndList[WndList.Length] = "SummonedWnd";
	WndList[WndList.Length] = "TownMapWnd";
	WndList[WndList.Length] = "TradeWnd";
	WndList[WndList.Length] = "SkillTrainClanTreeWnd";
	WndList[WndList.Length] = "SkillTrainInfoWnd";
	WndList[WndList.Length] = "SkillTrainListWnd";
	WndList[WndList.Length] = "TutorialViewerWnd";
	WndList[WndList.Length] = "unrefineryWnd";
	WndList[WndList.Length] = "WarehouseWnd";
	WndList[WndList.Length] = "PartyMatchWnd";
	WndList[WndList.Length] = "PersonalConnectionsWnd";
	WndList[WndList.Length] = "NPCDialogWnd";
	WndList[WndList.Length] = "PostBoxWnd";
	WndList[WndList.Length] = "NewUserPetitionWnd";
	WndList[WndList.Length] = "ProductInventoryWnd";
	WndList[WndList.Length] = "GiftInventoryWnd";
	WndList[WndList.Length] = "AuctionWnd";
	WndList[WndList.Length] = "BlockCurWnd";
	WndList[WndList.Length] = "BlockEnterWnd";
	WndList[WndList.Length] = "CleftEnterWnd";
	WndList[WndList.Length] = "CleftCurWnd";
	WndList[WndList.Length] = "ColorNickNameWnd";
	WndList[WndList.Length] = "DominionWarInfoWnd";
	WndList[WndList.Length] = "FileRegisterWnd";
	WndList[WndList.Length] = "KillPointRankWnd";
	WndList[WndList.Length] = "MagicskillGuideWnd";
	WndList[WndList.Length] = "miniGame1Wnd";
	WndList[WndList.Length] = "NewPetitionWnd";
	WndList[WndList.Length] = "PetitionFeedBackWnd";
	WndList[WndList.Length] = "PostWriteWnd";
	WndList[WndList.Length] = "PremiumItemGetWnd";
	WndList[WndList.Length] = "PVPDetailedWnd";
	WndList[WndList.Length] = "QuesthtmlWnd";
	WndList[WndList.Length] = "SeedShopWnd";
	WndList[WndList.Length] = "SellingAgencyWnd";
	WndList[WndList.Length] = "TeleportBookMarkWnd";
	WndList[WndList.Length] = "WebPetitionWnd";
	WndList[WndList.Length] = "IngameNoticeWnd";
	WndList[WndList.Length] = "ItemJewelEnchantWnd";
	WndList[WndList.Length] = "PlayerAgeWnd";
	if((int(GetLanguage()) != 0))
	{
		WndList[WndList.Length] = "BR_PathWnd";
	}
	WndList[WndList.Length] = "BR_ChinaShop";
	WndList[WndList.Length] = "ToDoListWnd";
	WndList[WndList.Length] = "ToDoListClanWnd";
	WndList[WndList.Length] = "InventoryViewer";
	WndList[WndList.Length] = "EnsoulWnd";
	WndList[WndList.Length] = "AttendCheckWnd";
	WndList[WndList.Length] = "SiegeReportWnd";
	WndList[WndList.Length] = "AgitDecoWnd";
	WndList[WndList.Length] = "MonsterArenaResultWnd";
	WndList[WndList.Length] = "MacroPresetWnd";
	WndList[WndList.Length] = "IngameWebWnd";
	WndList[WndList.Length] = "MonsterBookDetailedInfo";
	WndList[WndList.Length] = "PrivateShopWndHistory";
	WndList[WndList.Length] = "ItemLockWnd";
	WndList[WndList.Length] = "OlympiadWnd";
	WndList[WndList.Length] = "OlympiadRandomChallengeWnd";
	WndList[WndList.Length] = "RestartMenuWndReportDamage";
	WndList[WndList.Length] = "RestartMenuWndReportLostItem";
	WndList[WndList.Length] = "TimeZoneWnd";
	WndList[WndList.Length] = "RankingWnd";
	WndList[WndList.Length] = "AutoPotionSubWnd";
	WndList[WndList.Length] = "AutoUseItemInventory";
	WndList[WndList.Length] = "SiegeCastleInfoWnd";
	WndList[WndList.Length] = "SiegeWnd";
	WndList[WndList.Length] = "SiegeMercenaryWnd";
	WndList[WndList.Length] = "SiegeInfoMCWWnd";
	WndList[WndList.Length] = "EventletterCollectorWnd";
	WndList[WndList.Length] = "RandomCraftChargingWnd";
	WndList[WndList.Length] = "RandomCraftWnd";
	WndList[WndList.Length] = "MenuEntireWnd";
	WndList[WndList.Length] = "FortressBattleInfoWnd";
	WndList[WndList.Length] = "LocationShareWnd";
	WndList[WndList.Length] = "MoveLocationWnd";
	WndList[WndList.Length] = "MarbleGameWnd";
	WndList[WndList.Length] = "HomunculusWnd";
	WndList[WndList.Length] = "PetExtractWnd";
	WndList[WndList.Length] = "UIControlContextMenu";
	WndList[WndList.Length] = "FestivalRankingWnd";
	WndList[WndList.Length] = "FestivaRankingWindowTooltip";
	WndList[WndList.Length] = "FestivalRankingBonusWnd";
	WndList[WndList.Length] = "RestoreLostPropertyWnd";
	WndList[WndList.Length] = "SuppressWnd";
	WndList[WndList.Length] = "SuppressDrawWnd";
	WndList[WndList.Length] = "BlackCouponWnd";
	WndList[WndList.Length] = "InfoFightWndClassic";
	WndList[WndList.Length] = "ClanShopWndClassic";
	WndList[WndList.Length] = "DethroneCharacterCreatewnd";
	WndList[WndList.Length] = "DethroneWnd";
	WndList[WndList.Length] = "DethroneResultWnd";
	WndList[WndList.Length] = "ColorNickNameWndClassic";
	WndList[WndList.Length] = "PrivateShopFindWnd";
	WndList[WndList.Length] = "HennaEnchantWnd";
	WndList[WndList.Length] = "HennaMenuWnd";
	WndList[WndList.Length] = "WorldSiegeBoardWnd";
	WndList[WndList.Length] = "WorldSiegeInfoMCWWnd";
	WndList[WndList.Length] = "WorldSiegeMercenaryWnd";
	WndList[WndList.Length] = "WorldSiegeRankingWnd";
	WndList[WndList.Length] = "WorldSiegeWnd";
	WndList[WndList.Length] = "HennaDyeEnchantWnd";
	WndList[WndList.Length] = "ItemMultiEnchantWnd";
	WndList[WndList.Length] = "WorldExchangeRegiWnd";
	WndList[WndList.Length] = "WorldExchangeBuyWnd";
	WndList[WndList.Length] = "FestivalWRankingWnd";
	WndList[WndList.Length] = "FestivalWRankingWindowTooltip";
	WndList[WndList.Length] = "FestivalWRankingBonusWnd";
	WndList[WndList.Length] = "HeroBookWnd";
	WndList[WndList.Length] = "HeroBookCraftChargingWnd";
	WndList[WndList.Length] = "TeleportWnd";
	WndList[WndList.Length] = "MultiSellItemExchangeWnd";
	WndList[WndList.Length] = "AbilityUIWnd";
	WndList[WndList.Length] = "RevengeWnd";
	WndList[WndList.Length] = "DethroneFireStateWnd";
	WndList[WndList.Length] = "DethroneFireEnchantWnd";
	WndList[WndList.Length] = "QuitReportInstantZoneWnd";
	WndList[WndList.Length] = "QuestProgressWnd";
	WndList[WndList.Length] = "VirtualItemWnd";
	WndList[WndList.Length] = "CrossEventWnd";
	WndList[WndList.Length] = "SkyTowerWnd";
	WndList[WndList.Length] = "SkyTowerEnterWnd";
	WndList[WndList.Length] = "AdenLabWnd";
	WndList[WndList.Length] = "PetSkillWnd";
	WndList[WndList.Length] = "PetPreviewWnd";
	WndList[WndList.Length] = "UniqueGacha";
	WndList[WndList.Length] = "UniqueGachaWarehouseWnd";
	WndList[WndList.Length] = "MatchingInzoneWnd";
	WndList[WndList.Length] = "RaidAuctionRewardWnd";
	WndList[WndList.Length] = "ClassChangeWnd";
	WndList[WndList.Length] = "CustomizingWnd";
	if((IsUseRelicSystem() || IsUseDollSystem()))
	{
		WndList[WndList.Length] = "RelicSummonWnd";
		WndList[WndList.Length] = "RelicWnd";
	}
	if(IsUseRenewalSkillWnd())
	{
		WndList[WndList.Length] = "SkillWnd";
		WndList[WndList.Length] = "SkillSpExtractWnd";
		WndList[WndList.Length] = "SkillEnchantWnd";
	}
	if(IsAdenServer())
	{
		WndList[WndList.Length] = "MagicLampWnd";
	}
	if((getInstanceUIData().GetIsClassicServer() && !IsAdenServer()))
	{
		WndList[WndList.Length] = "QuestTreeWnd";
	}
	else
	{
		WndList[WndList.Length] = "QuestWnd";
	}
	i = 0;
	while((i < WndList.Length))
	{
		Handle = GetWindowHandle(WndList[i]);
		if((WndList[i] == ""))
		{
		}
		if(Handle.IsShowWindow())
		{
			if((Handle.GetWindowName() == "RefineryWnd"))
			{
				RefineryWnd(GetScript("RefineryWnd")).OnClickButton("exitbutton");
			}
			if((Handle.GetWindowName() == "UniqueGacha"))
			{
				UniqueGacha(GetScript("UniqueGacha")).closeAltW();
				++i;
				continue;
			}
			Handle.HideWindow();
		}
		++i;
	}
	GFxWndList[GFxWndList.Length] = "ClanSearch";
	GFxWndList[GFxWndList.Length] = "InstancedZoneHistoryWnd";
	GFxWndList[GFxWndList.Length] = "OptionWnd";
	GFxWndList[GFxWndList.Length] = "CardExchange";
	GFxWndList[GFxWndList.Length] = "CardExchangeB";
	GFxWndList[GFxWndList.Length] = "CardExchangeC";
	GFxWndList[GFxWndList.Length] = "AdenaDistributionWnd";
	GFxWndList[GFxWndList.Length] = "AlchemyMixCubeWnd";
	GFxWndList[GFxWndList.Length] = "AlchemyOpener";
	GFxWndList[GFxWndList.Length] = "AlchemyItemConversionWnd";
	GFxWndList[GFxWndList.Length] = "FactionWnd";
	GFxWndList[GFxWndList.Length] = "VipInfoWnd";
	GFxWndList[GFxWndList.Length] = "IngameShopWnd";
	GFxWndList[GFxWndList.Length] = "LuckyGame";
	GFxWndList[GFxWndList.Length] = "MonsterBookWnd";
	GFxWndList[GFxWndList.Length] = "MiniMapGFxWnd";
	GFxWndList[GFxWndList.Length] = "EventInfoWnd";
	GFxWndList[GFxWndList.Length] = "CardDrawEventWnd";
	GFxWndList[GFxWndList.Length] = "ArenaRankingWnd";
	GFxWndList[GFxWndList.Length] = "ClanRaidsWnd";
	GFxWndList[GFxWndList.Length] = "ClanGfxWnd";
	GFxWndList[GFxWndList.Length] = "ElementalSpiritWnd";
	GFxWndList[GFxWndList.Length] = "JobChangeWnd";
	GFxWndList[GFxWndList.Length] = "RankingHistoryWnd";
	GFxWndList[GFxWndList.Length] = "MiniMapGfxWnd";
	GFxWndList[GFxWndList.Length] = "ShopLcoinWnd";
	GFxWndList[GFxWndList.Length] = "ShopLcoinCraftWnd";
	i = 0;
	while((i < GFxWndList.Length))
	{
		if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow(GFxWndList[i]))
		{
			if((GFxWndList[i] == "AdenaDistributionWnd"))
			{
				CallGFxFunction("AdenaDistributionWnd", "RequestDivideAdenaCancel", "");
			}
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow(GFxWndList[i]);
		}
		i++;
	}
	return;
}

function HandleStateChange(string State)
{
	local FlightShipCtrlWnd scriptShip;
	local FlightTransformCtrlWnd scriptTrans;

	scriptShip = FlightShipCtrlWnd(GetScript("FlightShipCtrlWnd"));
	scriptTrans = FlightTransformCtrlWnd(GetScript("FlightTransformCtrlWnd"));
	if((State == "GAMINGSTATE"))
	{
		if(GetChatFilterBool("Global", "EnterChatting"))
		{
			Class'NWindow.ShortcutAPI'.static.ActivateGroup("TempStateShortcut");
		}
		if(scriptShip.isNowActiveFlightShipShortcut)
		{
			if(GetChatFilterBool("Global", "EnterChatting"))
			{
				Class'NWindow.ShortcutAPI'.static.DeactivateGroup("TempStateShortcut");
			}
			Class'NWindow.ShortcutAPI'.static.ActivateGroup("FlightStateShortcut");
		}
		else if(scriptTrans.isNowActiveFlightTransShortcut)
		{
			if(GetChatFilterBool("Global", "EnterChatting"))
			{
				Class'NWindow.ShortcutAPI'.static.DeactivateGroup("TempStateShortcut");
			}
			Class'NWindow.ShortcutAPI'.static.ActivateGroup("FlightTransformShortcut");
		}
	}
	return;
}
