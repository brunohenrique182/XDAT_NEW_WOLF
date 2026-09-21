class ChatWnd extends UICommonAPI
	dependson(UIPacket);

const CHANNEL_ID_NORMAL = 0;
const CHANNEL_ID_TRADE = 1;
const CHANNEL_ID_PARTY = 2;
const CHANNEL_ID_CLAN = 3;
const CHANNEL_ID_ALLY = 4;
const CHANNEL_ID_HERO = 5;
const CHANNEL_ID_PARTYMASTER = 6;
const CHANNEL_ID_SHOUT = 7;
const CHANNEL_ID_WORLD = 8;
const CHANNEL_ID_INRAIDSERVER = 9;
const CHANNEL_ID_SYSTEM = 10;
const CHANNEL_ID_COUNT = 10;
const CHAT_WINDOW_TAB_NORMAL = 0;
const CHAT_WINDOW_TAB_1 = 1;
const CHAT_WINDOW_TAB_2 = 2;
const CHAT_WINDOW_TAB_3 = 3;
const CHAT_WINDOW_TAB_LEN = 4;
const CHAT_WINDOW_TAB_SYSTEM = 5;
const DIALOGID_GoWeb = 1234510;
const CHAT_UNION_MAX = 35;
const VALIDATEFLAG_ALARM_KEYWORD = 1;
const VALIDATEFLAG_ALARM_CHAT = 2;
const OPTION_ALARM_INDEX_SPT_TELL = 11;
const OPTION_ALARM_INDEX_SPT_WORLD = 12;
const OPTION_ALARM_INDEX_SPT_PLEDGE = 13;
const OPTION_ALARM_INDEX_SPT_ALLIANCE = 14;
const OPTION_ALARM_INDEX_SPT_INTER_PARTYMASTER_CHAT = 15;
const ALARM_INDEX_SPT_TELL = 12;
const ALARM_INDEX_SPT_WORLD = 13;
const ALARM_INDEX_SPT_PLEDGE = 14;
const ALARM_INDEX_SPT_ALLIANCE = 15;
const ALARM_INDEX_SPT_INTER_PARTYMASTER_CHAT = 16;
const FADE_IN_SPEED = 0.2f;
const FADE_OUT_SPEED = 0.7f;
const CONTEXT_ID_ADD_FRIEND = 0;
const CONTEXT_ID_ADD_PARTY = 1;
const CONTEXT_ID_ADD_BLOCK = 2;
const CONTEXT_ID_ADD_WHISPER = 3;
const TIMER_ID_PARTYMATCH = 1992;
const TIMER_TIME_PARTYMATCH = 500;
const TIMER_ID_CHANTTINGFADEOUTDELAY = 2022;
const TIMER_TIME_CHANTTINGFADEOUTDELAY = 5000;
const CHATWNDMINWIDTH = 399;
const CHATWNDMINHEIGHT = 130;
const CHATWNDMINHEIGHTSPLIT = 73;
const TABCTROLY = -26;

struct ChatFilterInfo
{
	var int bDice;
	var int bGetitems;
	var int bSystem;
	var int bChat;
	var int bDamage;
	var int bNormal;
	var int bShout;
	var int bClan;
	var int bParty;
	var int bTrade;
	var int bWhisper;
	var int bAlly;
	var int bWorldUnion;
	var int bUseitem;
	var int bHero;
	var int bUnion;
	var int bBattle;
	var int bNoNpcMessage;
	var int bWorldChat;
};

struct ChatUIType
{
	var int Id;
	var int UI;
};

struct chatTabInfo
{
	var int channelID;
	var ChatWindowHandle ChatWnd;
	var WindowHandle tabButton;
	var ButtonHandle newMessageBtn;
	var ButtonHandle channelBtn;
	var ButtonHandle tabMergeBtn;
	var bool isSplit;
	var bool bShowNewMessageBtn;
};

var int m_bUseSystemMsgWnd;
var int m_bSystemMsgWnd;
var int m_bDamageOption;
var int m_bDiceOption;
var int m_bUseSystemItem;
var int m_NoNpcMessage;
var int m_bWorldChat;
var int m_bWorldChatSpeaker;
var int m_bOnlyUseSystemMsgWnd;
var int m_bUseAlpha;
var int m_UseChatSymbol;
var int m_KeywordFilterSound;
var int m_KeywordFilterActivate;
var int m_ChatResizeOnOff;
var string m_Keyword0;
var string m_Keyword1;
var string m_Keyword2;
var string m_Keyword3;
var array<ChatFilterInfo> m_filterInfo;
var array<string> m_sectionName;
var ChatUIType m_chatType;
var string URL;
var string Text;
var ChatWindowHandle SystemMsg;
var array<chatTabInfo> chatTabInfos;
var WindowHandle UpScrollButton;
var WindowHandle DownScrollButton;
var WindowHandle SliderScrollButton;
var TabHandle ChatTabCtrl;
var EditBoxHandle ChatEditBox;
var WindowHandle m_hChatWnd;
var WindowHandle m_hSystemMsgWnd;
var WindowHandle m_hChatFontsizeWnd;
var TextureHandle m_ChatWndBg;
var ButtonHandle m_ChatMinBtn;
var ButtonHandle m_ChatMaxBtn;
var TextureHandle m_ChatMaxBtnAlarm;
var ButtonHandle m_ChatFilterBtn;
var WindowHandle dragTabNormal;
var string lastClickChatTabName;
var bool IsMouseOver;
var bool isMinSize;
var bool bPrefixChanged;
var int validateFlag;
var int bitFlagAlarmKewWord;
var int bitFlagAlarmChat;
var bool bShowSystemMessage;

static function ChatWnd Inst()
{
	return ChatWnd(GetScript("ChatWnd"));
}

function setInit()
{
	InitFilterInfo();
	SetChatFilterBool("Global", "EnterChatting", GetChatFilterBool("Global", "EnterChatting"));
	return;
}

function InitHandleCOD()
{
	m_hChatWnd = GetWindowHandle("ChatWnd");
	chatTabInfos.Length = 4;
	chatTabInfos[0].ChatWnd = GetChatWindowHandle("ChatWnd.NormalChat");
	chatTabInfos[1].ChatWnd = GetChatWindowHandle("ChatWnd.TradeChat");
	chatTabInfos[2].ChatWnd = GetChatWindowHandle("ChatWnd.PartyChat");
	chatTabInfos[3].ChatWnd = GetChatWindowHandle("ChatWnd.ClanChat");
	SystemMsg = GetChatWindowHandle("SystemMsgWnd.SystemMsgList");
	ChatTabCtrl = GetTabHandle("ChatWnd.ChatTabCtrl");
	chatTabInfos[0].tabButton = GetWindowHandle("ChatWnd.ChatTabCtrl.TabButton0");
	chatTabInfos[1].tabButton = GetWindowHandle("ChatWnd.ChatTabCtrl.TabButton1");
	chatTabInfos[2].tabButton = GetWindowHandle("ChatWnd.ChatTabCtrl.TabButton2");
	chatTabInfos[3].tabButton = GetWindowHandle("ChatWnd.ChatTabCtrl.TabButton3");
	dragTabNormal = m_hOwnerWnd.GetResizeFrame();
	m_ChatWndBg = GetTextureHandle("ChatWnd.ChatWndBg");
	ChatEditBox = GetEditBoxHandle("ChatWnd.ChatEditBox");
	m_hChatFontsizeWnd = GetWindowHandle("ChatFontsizeWnd");
	m_ChatMinBtn = GetButtonHandle("ChatWnd.ChatMinBtn");
	m_ChatMaxBtn = GetButtonHandle("ChatWnd.ChatMaxBtn");
	m_ChatMaxBtn.HideWindow();
	m_ChatMaxBtnAlarm = GetTextureHandle("ChatWnd.ChatMaxBtnAlarm");
	m_ChatMaxBtnAlarm.HideWindow();
	m_ChatFilterBtn = GetButtonHandle("ChatWnd.ChatFilterBtn");
	chatTabInfos[1].channelBtn = GetButtonHandle("ChatWnd.ChnnelTradeBtn");
	chatTabInfos[2].channelBtn = GetButtonHandle("ChatWnd.ChnnelPartyBtn");
	chatTabInfos[3].channelBtn = GetButtonHandle("ChatWnd.ChnnelClanBtn");
	chatTabInfos[1].tabMergeBtn = GetButtonHandle("ChatWnd.TabMergeTradeBtn");
	chatTabInfos[2].tabMergeBtn = GetButtonHandle("ChatWnd.TabMergePartyBtn");
	chatTabInfos[3].tabMergeBtn = GetButtonHandle("ChatWnd.TabMergeClanBtn");
	chatTabInfos[0].newMessageBtn = GetButtonHandle("ChatWnd.NewMessageBtn");
	chatTabInfos[1].newMessageBtn = GetButtonHandle("ChatWnd.NewMessageBtnTrade");
	chatTabInfos[2].newMessageBtn = GetButtonHandle("ChatWnd.NewMessageBtnParty");
	chatTabInfos[3].newMessageBtn = GetButtonHandle("ChatWnd.NewMessageBtnClan");
	chatTabInfos[1].tabMergeBtn.HideWindow();
	chatTabInfos[2].tabMergeBtn.HideWindow();
	chatTabInfos[3].tabMergeBtn.HideWindow();
	chatTabInfos[0].newMessageBtn.HideWindow();
	chatTabInfos[1].newMessageBtn.HideWindow();
	chatTabInfos[2].newMessageBtn.HideWindow();
	chatTabInfos[3].newMessageBtn.HideWindow();
	m_hChatWnd.EnableDynamicAlpha(true);
	chatTabInfos[0].ChatWnd.EnableDynamicAlpha(true);
	chatTabInfos[1].ChatWnd.EnableDynamicAlpha(true);
	chatTabInfos[2].ChatWnd.EnableDynamicAlpha(true);
	chatTabInfos[3].ChatWnd.EnableDynamicAlpha(true);
	AnchorTabs();
	SystemMsg.EnableDynamicAlpha(true);
	m_hSystemMsgWnd = GetWindowHandle("SystemMsgWnd");
	GetChatWindowHandle("ChatWnd.ClanChat").HideWindow();
	return;
}

function AnchorTabs()
{
	chatTabInfos[1].tabButton.SetAnchor(chatTabInfos[1].ChatWnd.m_WindowNameWithFullPath, "Topeft", "TopLeft", 101, -26);
	chatTabInfos[1].channelBtn.SetAnchor(chatTabInfos[1].ChatWnd.m_WindowNameWithFullPath, "Topeft", "TopLeft", 102, (-26 + 1));
	chatTabInfos[2].tabButton.SetAnchor(chatTabInfos[2].ChatWnd.m_WindowNameWithFullPath, "Topeft", "TopLeft", 200, -26);
	chatTabInfos[2].channelBtn.SetAnchor(chatTabInfos[2].ChatWnd.m_WindowNameWithFullPath, "Topeft", "TopLeft", 201, (-26 + 1));
	chatTabInfos[3].tabButton.SetAnchor(chatTabInfos[3].ChatWnd.m_WindowNameWithFullPath, "Topeft", "TopLeft", 299, -26);
	chatTabInfos[3].channelBtn.SetAnchor(chatTabInfos[3].ChatWnd.m_WindowNameWithFullPath, "Topeft", "TopLeft", 300, (-26 + 1));
	return;
}

function InitScrollBarPosition()
{
	chatTabInfos[0].ChatWnd.SetScrollBarPosition(0, 0, 15);
	chatTabInfos[1].ChatWnd.SetScrollBarPosition(0, 0, 15);
	chatTabInfos[2].ChatWnd.SetScrollBarPosition(0, 0, 15);
	chatTabInfos[3].ChatWnd.SetScrollBarPosition(0, 0, 15);
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(540);
	RegisterEvent(560);
	RegisterEvent(570);
	RegisterEvent(572);
	RegisterEvent(3000);
	RegisterEvent(3010);
	RegisterEvent(4961);
	RegisterEvent(150);
	RegisterEvent(1710);
	RegisterEvent(1720);
	RegisterEvent(555);
	RegisterEvent(2900);
	RegisterEvent(8000);
	RegisterEvent(40);
	RegisterEvent(9750);
	RegisterEvent(11550);
	RegisterEvent(5720);
	RegisterEvent(3410);
	return;
}

event OnLoad()
{
	m_filterInfo.Length = (10 + 1);
	m_sectionName.Length = 10;
	m_sectionName[0] = "entire_tab";
	m_sectionName[1] = "pledge_tab";
	m_sectionName[2] = "party_tab";
	m_sectionName[3] = "market_tab";
	m_sectionName[4] = "ally_tab";
	m_sectionName[5] = "hero_tab";
	m_sectionName[6] = "union_tab";
	m_sectionName[7] = "shout_tab";
	m_sectionName[8] = "worldChat_tab";
	m_sectionName[9] = "worldUnion_tab";
	RegisterState("ChatWnd", "OlympiadObserverState");
	RegisterState("ChatWnd", "TRAININGROOMSTATE");
	InitHandleCOD();
	InitFilterInfo();
	InitScrollBarPosition();
	ChatEditBox.SetEnableTextLink(true);
	ChatEditBox.SetAsChatEditBox();
	m_chatType.UI = 0;
	m_chatType.Id = -1;
	chatTabInfos[1].isSplit = false;
	chatTabInfos[2].isSplit = false;
	chatTabInfos[3].isSplit = false;
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SystemMessageToggleBtn")).HideWindow();
	return;
}

event OnDefaultPosition()
{
	ChatTabCtrl.MergeTab(1);
	ChatTabCtrl.MergeTab(2);
	ChatTabCtrl.MergeTab(3);
	ChatTabCtrl.SetTopOrder(0, true);
	if(isMinSize)
	{
		chatTabInfos[0].ChatWnd.HideWindow();
	}
	HandleTabClick("ChatTabCtrl0");
	if(!IsMouseOver)
	{
		if((int(GetLanguage()) == 2))
		{
			return;
		}
		chatTabInfos[1].tabButton.SetAlpha(0, 0.7000000);
		chatTabInfos[2].tabButton.SetAlpha(0, 0.7000000);
		chatTabInfos[3].tabButton.SetAlpha(0, 0.7000000);
	}
	return;
}

event OnSetFocus(WindowHandle a_WindowHandle, bool IsFocused)
{
	if(IsMouseOver)
	{
		return;
	}
	if(IsFocused)
	{
		return;
	}
	if((a_WindowHandle == ChatEditBox))
	{
		SetAlphaTimer();
	}
	return;
}

event OnChangeEditBox(string strID)
{
	if(bPrefixChanged)
	{
		return;
	}
	if(isMinSize)
	{
		_Swap2Max();
	}
	_Swap2FullAlphaNormal();
	return;
}

event OnCompleteEditBox(string strID)
{
	local string strInput;
	local UIEventManager.SayPacketType SayType;

	if((strID == "ChatEditBox"))
	{
		strInput = ChatEditBox.GetString();
		if((Len(strInput) < 1))
		{
			return;
		}
		SayType = GetChatTypeByTabIndex(m_chatType.UI);
		ProcessChatMessage(strInput, SayType, false);
		ChatEditBox.SetString("");
		m_UseChatSymbol = int(GetChatFilterBool("Global", "OldChatting"));
		if((bool(m_UseChatSymbol) == true))
		{
			if((m_chatType.Id != 0))
			{
				if((int(SayType) != 0))
				{
					ChatEditBox.AddString(GetChatPrefix(SayType));
				}
			}
		}
		if(GetChatFilterBool("Global", "EnterChatting"))
		{
			ChatEditBox.ReleaseFocus();
		}
		else
		{
			ChatEditBox.SetFocus();
		}
	}
	if(!IsMouseOver)
	{
		SetAlphaTimer();
	}
	return;
}

function SetAlphaTimer()
{
	if((int(GetLanguage()) == 2))
	{
		return;
	}
	m_hOwnerWnd.KillTimer(2022);
	m_hOwnerWnd.SetTimer(2022, 5000);
	return;
}

event OnShow()
{
	local int FontSize, sizeW, sizeH, tempVal;
	local string isSavedString, sizeParam, isShowSystemMsgWndParam;
	local int CurrentMaxWidth, CurrentMaxHeight;
	local bool isSavedChatSize;

	GetINIString("global", "DefaultSaveOption", isSavedString, "chatfilter.ini");
	if((isSavedString == "true"))
	{
		if(!GetINIBool("worldUnion_tab", "worldUnion", tempVal, "chatfilter.ini"))
		{
			SetDefaultFilterValueWorldUnion();
			SaveChatFilterOption();
		}
		LoadINIFilterSetting();
	}
	else
	{
		if(getInstanceUIData().GetIsClassicServer())
		{
			SetINIInt("global", "ChatFontSizeSaved", 1, "chatfilter.ini");
		}
		else
		{
			SetINIInt("global", "ChatFontSizeSaved", 0, "chatfilter.ini");
		}
		isSavedString = "true";
		SetINIString("global", "DefaultSaveOption", isSavedString, "chatfilter.ini");
		SetDefaultFilterValue();
		SetDefaultFilterValueWorldUnion();
		SaveChatFilterOption();
	}
	if(getInstanceUIData().GetIsLiveServer())
	{
		GetINIBool("global", "SystemMsgWnd", m_bUseSystemMsgWnd, "chatfilter.ini");
		if(bool(m_bUseSystemMsgWnd))
		{
			m_hSystemMsgWnd.ShowWindow();
		}
		else
		{
			m_hSystemMsgWnd.HideWindow();
		}
	}
	else
	{
		m_hSystemMsgWnd.HideWindow();
	}
	ParamAdd(isShowSystemMsgWndParam, "visible", string(m_bUseSystemMsgWnd));
	if(GetINIBool("global", "UseWorldChatSpeaker", tempVal, "chatfilter.ini"))
	{
		CallGFxFunction("worldChatBox", "IsShowSystemMsgWnd", isShowSystemMsgWndParam);
	}
	CallGFxFunction("UserAlertMessage", "IsShowSystemMsgWnd", isShowSystemMsgWndParam);
	if(GetINIBool("global", "ChatResizing", tempVal, "chatfilter.ini"))
	{
		m_ChatResizeOnOff = tempVal;
		if(bool(m_ChatResizeOnOff))
		{
			EnableChatWndResizing(false);
		}
		else
		{
			EnableChatWndResizing(true);
		}
	}
	else
	{
		EnableChatWndResizing(true);
	}
	_SetAllcurrentAssignedChatTypeID();
	GetINIInt("global", "ChatFontSizeSaved", FontSize, "chatfilter.ini");
	_SetChangeFont(FontSize);
	GetCurrentResolution(CurrentMaxWidth, CurrentMaxHeight);
	isSavedChatSize = GetINIInt("global", "ChatSizeWidth", sizeW, "chatfilter.ini");
	isSavedChatSize = (GetINIInt("global", "ChatSizeHeight", sizeH, "chatfilter.ini") && isSavedChatSize);
	if((sizeW < 399))
	{
		sizeW = 399;
	}
	if((sizeH < 130))
	{
		sizeH = 130;
	}
	if(((isSavedChatSize && (sizeW <= CurrentMaxWidth)) && (sizeH <= (CurrentMaxHeight - 15))))
	{
		m_hChatWnd.SetWindowSize(sizeW, sizeH);
		ParamAdd(sizeParam, "w", string(sizeW));
		ParamAdd(sizeParam, "h", string((sizeH + 35)));
		CallGFxFunction("UserAlertMessage", "ReceiveChatWndSize", sizeParam);
		CallGFxFunction("worldChatBox", "ReceiveChatWndSize", sizeParam);
	}
	else
	{
		m_hChatWnd.SetWindowSize(399, 130);
		m_hChatWnd.SetResizeFrameOffset(399, 130);
		SetINIInt("global", "ChatSizeWidth", 399, "chatfilter.ini");
		SetINIInt("global", "ChatSizeHeight", 130, "chatfilter.ini");
		ParamAdd(sizeParam, "w", string(399));
		ParamAdd(sizeParam, "h", string((130 + 35)));
		CallGFxFunction("UserAlertMessage", "ReceiveChatWndSize", sizeParam);
		CallGFxFunction("worldChatBox", "ReceiveChatWndSize", sizeParam);
	}
	m_hChatWnd.SetResizeFrameOffset(399, 130);
	setInit();
	HandleOptionHasAppled();
	InitScrollBarPosition();
	return;
}

event OnRClickButton(string strID)
{
	switch(strID)
	{
		case "ChatTabCtrl0":
		case "ChatTabCtrl1":
		case "ChatTabCtrl2":
		case "ChatTabCtrl3":
		case "ChatTabCtrl4":
			HandleTabClick(strID);
			break;
		default:
			break;
	}
	return;
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "ChatTabCtrl0":
		case "ChatTabCtrl1":
		case "ChatTabCtrl2":
		case "ChatTabCtrl3":
			HandleTabClick(strID);
			break;
		case "ChatFilterBtn":
			CallGFxFunction("OptionWnd", "showChattingOption", "");
			break;
		case "ChatMinBtn":
			_Swap2Min();
			break;
		case "ChatMaxBtn":
			_Swap2Max();
			break;
		case "TabMergeTradeBtn":
			ChatTabCtrl.MergeTab(1);
			break;
		case "TabMergePartyBtn":
			ChatTabCtrl.MergeTab(2);
			break;
		case "TabMergeClanBtn":
			ChatTabCtrl.MergeTab(3);
			break;
		case "NewMessageBtn":
			HideNewMessageBtn(0);
			chatTabInfos[0].ChatWnd.SetScrollPosition(chatTabInfos[0].ChatWnd.GetScrollHeight());
			break;
		case "newMessageBtnTrade":
			HideNewMessageBtn(1);
			chatTabInfos[1].ChatWnd.SetScrollPosition(chatTabInfos[1].ChatWnd.GetScrollHeight());
			break;
		case "newMessageBtnParty":
			HideNewMessageBtn(2);
			chatTabInfos[2].ChatWnd.SetScrollPosition(chatTabInfos[2].ChatWnd.GetScrollHeight());
			break;
		case "newMessageBtnClan":
			HideNewMessageBtn(3);
			chatTabInfos[3].ChatWnd.SetScrollPosition(chatTabInfos[3].ChatWnd.GetScrollHeight());
			break;
		case "SystemMessageToggleBtn":
			HandleToggleSystemMessage();
			break;
		default:
			break;
	}
	return;
}

event OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	switch(a_WindowHandle.GetWindowName())
	{
		case "ChnnelTradeBtn":
			ShowContextMenuChannel(1, a_WindowHandle);
			break;
		case "ChnnelPartyBtn":
			ShowContextMenuChannel(2, a_WindowHandle);
			break;
		case "ChnnelClanBtn":
			ShowContextMenuChannel(3, a_WindowHandle);
			break;
		default:
			break;
	}
	return;
}

function ShowContextMenuChannel(int chatType, WindowHandle a_WindowHandle)
{
	local UIControlContextMenu ContextMenu;
	local int currentchannelID;

	ContextMenu = Class'Interface.UIControlContextMenu'.static.GetInstance();
	ContextMenu.Clear();
	ContextMenu.DelegateOnClickContextMenu = HandleOnClickContextMenu;
	ContextMenu.DelegateOnHide = HandleOnHideContextMenu;
	GetINIInt("global", ("TabIndex" $ string(chatType)), currentchannelID, "chatfilter.ini");
	ContextMenu.MenuNew(GetSystemStringByChatType(1), 1, GetContextMenuColor(currentchannelID, 1));
	ContextMenu.MenuNew(GetSystemStringByChatType(2), 2, GetContextMenuColor(currentchannelID, 2));
	ContextMenu.MenuNew(GetSystemStringByChatType(3), 3, GetContextMenuColor(currentchannelID, 3));
	ContextMenu.MenuNew(GetSystemStringByChatType(4), 4, GetContextMenuColor(currentchannelID, 4));
	ContextMenu.MenuNew(GetSystemStringByChatType(5), 5, GetContextMenuColor(currentchannelID, 5));
	ContextMenu.MenuNew(GetSystemStringByChatType(6), 6, GetContextMenuColor(currentchannelID, 6));
	ContextMenu.MenuNew(GetSystemStringByChatType(7), 7, GetContextMenuColor(currentchannelID, 7));
	ContextMenu.MenuNew(GetSystemStringByChatType(8), 8, GetContextMenuColor(currentchannelID, 8));
	if(IsAdenServer())
	{
		ContextMenu.MenuNew(GetSystemStringByChatType(9), 9, GetContextMenuColor(currentchannelID, 9));
	}
	ContextMenu._SetReservedInt(chatType);
	ContextMenu._ShowTo(a_WindowHandle, string(self));
	return;
}

function Color GetContextMenuColor(int currentchannelID, int channelID)
{
	if((currentchannelID == channelID))
	{
		return getInstanceL2Util().Yellow;
	}
	return getInstanceL2Util().White;
}

function HandleOnHideContextMenu()
{
	_Swap2AlphaNormal();
	return;
}

function HandleOnClickContextMenu(int channelID)
{
	local int i, tabindex;

	tabindex = Class'Interface.UIControlContextMenu'.static.GetInstance()._GetReservedInt();
	i = 1;
	while((i < 4))
	{
		if((i == tabindex))
		{
			i++;
			continue;
		}
		if((chatTabInfos[i].channelID == channelID))
		{
			ChangeTabChannel(i, chatTabInfos[tabindex].channelID);
			break;
		}
		i++;
	}
	ChangeTabChannel(tabindex, channelID);
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("OptionWnd"))
	{
		CallGFxFunction("OptionWnd", "channelChanged", "");
	}
	ChangePrefix(tabindex, channelID);
	return;
}

function Clear()
{
	ChatEditBox.Clear();
	chatTabInfos[0].ChatWnd.Clear();
	chatTabInfos[1].ChatWnd.Clear();
	chatTabInfos[2].ChatWnd.Clear();
	chatTabInfos[3].ChatWnd.Clear();
	return;
}

event OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case 1992:
			ClosePartyMatchingWnd();
			m_hChatWnd.KillTimer(1992);
			break;
		case 2022:
			_Swap2AlphaNormal();
			Class'Interface.SystemMsgWnd'.static.Inst()._Swap2Alpha();
			break;
		default:
			break;
	}
	return;
}

event OnTabSplit(string sTabButton)
{
	local int tabindex;

	switch(sTabButton)
	{
		case "ChatTabCtrl0":
			return;
		default:
			tabindex = int(Right(sTabButton, 1));
			HandleTabClick(sTabButton);
			if((int(GetLanguage()) != 2))
			{
				chatTabInfos[tabindex].tabButton.SetAlpha(255, 0.2000000);
			}
			chatTabInfos[tabindex].isSplit = true;
			chatTabInfos[tabindex].tabMergeBtn.ShowWindow();
			ChatTabCtrl.SetTopOrder(tabindex, true);
			CheckOnChangeStateMessageBtn(tabindex);
			if(((tabindex != 0) && (tabindex < chatTabInfos.Length)))
			{
				chatTabInfos[tabindex].ChatWnd.Move(0, 0);
				chatTabInfos[tabindex].ChatWnd.SetWindowSizeRel(-1.0000000, -1.0000000, 0, 0);
				chatTabInfos[tabindex].ChatWnd.SetResizeFrameOffset(399, 73);
				chatTabInfos[tabindex].ChatWnd.SetSettledWnd(true);
				chatTabInfos[tabindex].ChatWnd.EnableTexture(true);
			}
			AnchorTabs();
			return;
	}
}

event OnTabMerge(string sTabButton)
{
	local int tabindex;
	local Rect rectWnd;

	switch(sTabButton)
	{
		case "ChatTabCtrl0":
			return;
		default:
			tabindex = int(Right(sTabButton, 1));
			chatTabInfos[tabindex].isSplit = false;
			chatTabInfos[tabindex].tabMergeBtn.HideWindow();
			CheckOnChangeStateMessageBtn(tabindex);
			if(((tabindex != 0) && (tabindex < chatTabInfos.Length)))
			{
				rectWnd = chatTabInfos[0].ChatWnd.GetRect();
				chatTabInfos[tabindex].ChatWnd.MoveTo(rectWnd.nX, rectWnd.nY);
				chatTabInfos[tabindex].ChatWnd.SetWindowSizeRel(1.0000000, 1.0000000, 0, -27);
				chatTabInfos[tabindex].ChatWnd.SetSettledWnd(false);
				chatTabInfos[tabindex].ChatWnd.EnableTexture(false);
				if((int(GetLanguage()) != 2))
				{
					if(IsMouseOver)
					{
						chatTabInfos[tabindex].tabButton.SetAlpha(255);
						chatTabInfos[tabindex].channelBtn.SetAlpha(255);
					}
					else
					{
						chatTabInfos[tabindex].tabButton.SetAlpha(0);
						chatTabInfos[tabindex].channelBtn.SetAlpha(0);
					}
				}
			}
	}
	if(isMinSize)
	{
		_Swap2Min();
	}
	AnchorTabs();
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 540:
			HandleChatmessage(param);
			break;
		case 570:
			HandleSetFocus();
			break;
		case 560:
			HandleSetString(param);
			break;
		case 572:
			HandleChatWndMacroCommand(param);
			break;
		case 3000:
			HandleTextLinkLButtonClick(param);
			break;
		case 3010:
			HandleTextLinkRButtonClick(param);
			break;
		case 4961:
			HandleChatIconClick(param);
			break;
		case 3620:
			HandleDominionWarChannelSet(param);
			break;
		case 150:
			ReselectTabSelected();
			break;
		case 40:
		case 8000:
			handleOnRestart();
			break;
		case 1710:
			HandleDialogOK();
			break;
		case 1720:
			break;
		case 555:
			UpdateSize(param);
			break;
		case 2900:
			UpdateResolution();
			break;
		case 9750:
			Clear();
			break;
		case 11550:
			API_C_EX_REQUEST_INVITE_PARTY(param);
			break;
		case 5720:
			HandleOptionHasAppled();
			CheckChatSetIME();
			break;
		case 3410:
			HandleStateChanged(param);
			break;
		default:
			break;
	}
	return;
}

function HandleStateChanged(string param)
{
	if((GetGameStateName() != "CHARACTERSELECTSTATE"))
	{
		return;
	}
	ResetTabSelected();
	return;
}

function CheckChatSetIME()
{
	if(!GetChatFilterBool("Global", "EnterChatting"))
	{
		ChatEditBox.SetIME();
	}
	return;
}

event OnMouseOver(WindowHandle W)
{
	local int tabindex;

	IsMouseOver = true;
	tabindex = GetTabIndexWithWindowHandle(W);
	if((tabindex != -1))
	{
		_Swap2FullAlpha(tabindex);
		return;
	}
	if(isMinSize)
	{
		return;
	}
	_Swap2FullAlphaNormal();
	Class'Interface.SystemMsgWnd'.static.Inst()._Swap2FullAlpha();
	return;
}

function int GetTabIndexWithWindowHandle(WindowHandle W)
{
	local int i;

	i = 1;
	while((i < chatTabInfos.Length))
	{
		if(chatTabInfos[i].isSplit)
		{
			switch(W)
			{
				case chatTabInfos[i].ChatWnd:
				case chatTabInfos[i].tabButton:
				case chatTabInfos[i].channelBtn:
				case chatTabInfos[i].newMessageBtn:
					return i;
				default:
					break;
			}
		}
		i++;
	}
	return -1;
}

event OnMouseOut(WindowHandle W)
{
	IsMouseOver = false;
	if(ChatEditBox.IsFocused())
	{
		return;
	}
	switch(GetTabIndexWithWindowHandle(W))
	{
		case 1:
			_Swap2Alpha(1);
			return;
		case 2:
			_Swap2Alpha(2);
			return;
		case 3:
			_Swap2Alpha(3);
			return;
		default:
			_Swap2AlphaNormal();
			Class'Interface.SystemMsgWnd'.static.Inst()._Swap2Alpha();
			return;
	}
}

function ResetTabSelected()
{
	lastClickChatTabName = "";
	ChatTabCtrl.SetTopOrder(0, true);
	HandleTabClick("ChatTabCtrl0");
	return;
}

function ReselectTabSelected()
{
	if((lastClickChatTabName != ""))
	{
		ChatTabCtrl.SetTopOrder(int(Right(lastClickChatTabName, 1)), true);
		HandleTabClick(lastClickChatTabName);
		if(isMinSize)
		{
			_Swap2Min();
		}
	}
	return;
}

function ChangePrefix(int tabindex, int channelID)
{
	local string strInput, strPrefix;

	if(!GetChatFilterBool("Global", "OldChatting"))
	{
		return;
	}
	if((m_chatType.UI != tabindex))
	{
		return;
	}
	strInput = ChatEditBox.GetString();
	IsPrefix(strInput);
	if((tabindex != 0))
	{
		strPrefix = GetChatPrefix(GetChatTypeByTabIndex(tabindex));
		if((strPrefix != "~"))
		{
			strInput = (strPrefix $ strInput);
		}
	}
	bPrefixChanged = true;
	ChatEditBox.SetString(strInput);
	bPrefixChanged = false;
	return;
}

function bool IsPrefix(out string strInput)
{
	local string strPrefix;
	local int StrLen;

	StrLen = Len(strInput);
	strPrefix = Left(strInput, 1);
	if((((((((((IsSameChatPrefix(SPT_MARKET, strPrefix) || IsSameChatPrefix(SPT_PARTY, strPrefix)) || IsSameChatPrefix(SPT_PLEDGE, strPrefix)) || IsSameChatPrefix(SPT_ALLIANCE, strPrefix)) || IsSameChatPrefix(SPT_HERO, strPrefix)) || IsSameChatPrefix(SPT_INTER_PARTYMASTER_CHAT, strPrefix)) || IsSameChatPrefix(SPT_SHOUT, strPrefix)) || IsSameChatPrefix(SPT_WORLD, strPrefix)) || IsSameChatPrefix(SPT_DOMINIONWAR, strPrefix)) || IsSameChatPrefix(SPT_WORLD_INRAIDSERVER, strPrefix)))
	{
		strInput = Right(strInput, (StrLen - 1));
		return true;
	}
	return false;
}

function HandleTabClick(string strID)
{
	m_chatType.UI = ChatTabCtrl.GetTopIndex();
	m_chatType.Id = chatTabInfos[m_chatType.UI].channelID;
	lastClickChatTabName = strID;
	ChangePrefix(m_chatType.UI, m_chatType.Id);
	CheckOnChangeStateMessageBtn(0);
	CheckOnChangeStateMessageBtn(1);
	CheckOnChangeStateMessageBtn(2);
	CheckOnChangeStateMessageBtn(3);
	return;
}

function bool CheckFilter(UIEventManager.SayPacketType SayType, int channelID, UIEventManager.ESystemMsgType systemType)
{
	if((!((channelID >= 0) && (channelID < 10)) && (channelID != 10)))
	{
		return false;
	}
	switch(SayType)
	{
		case SPT_MARKET:
			return (m_filterInfo[channelID].bTrade != 0);
		case SPT_NORMAL:
			return (m_filterInfo[channelID].bNormal != 0);
		case SPT_PLEDGE:
		case SPT_CASTLEWAR_PLEDGE_COMMAND_MSG:
			return (m_filterInfo[channelID].bClan != 0);
		case SPT_PARTY:
			return (m_filterInfo[channelID].bParty != 0);
		case SPT_SHOUT:
			return (m_filterInfo[channelID].bShout != 0);
		case SPT_TELL:
			return (m_filterInfo[channelID].bWhisper != 0);
		case SPT_ALLIANCE:
			return (m_filterInfo[channelID].bAlly != 0);
		case SPT_WORLD_INRAIDSERVER:
			return (m_filterInfo[channelID].bWorldUnion != 0);
		case SPT_HERO:
			return (channelID != 10);
		case SPT_DOMINIONWAR:
			return (m_filterInfo[channelID].bBattle != 0);
		case SPT_INTER_PARTYMASTER_CHAT:
		case SPT_COMMANDER_CHAT:
			return (m_filterInfo[channelID].bUnion != 0);
		case SPT_NPC_NORMAL:
		case SPT_NPC_SHOUT:
			return (m_filterInfo[channelID].bNoNpcMessage != 0);
		case SPT_WORLD:
			return ((m_filterInfo[channelID].bWorldChat != 0) && (channelID != 10));
		case SPT_ANNOUNCE:
		case SPT_CRITICAL_ANNOUNCE:
		case SPT_GM_PET:
		case SPT_FRIEND_ANNOUNCE:
			return true;
		case SPT_SYSTEM:
			break;
		default:
			return false;
	}
	if((channelID == 10))
	{
		switch(systemType)
		{
			case SYSTEM_SERVER:
			case SYSTEM_PETITION:
				return true;
			case SYSTEM_BATTLE:
			case SYSTEM_NONE:
				return bool(m_bSystemMsgWnd);
			case SYSTEM_DAMAGETEXT:
				return (bool(m_bSystemMsgWnd) || bool(m_bDamageOption));
			case SYSTEM_DAMAGE:
				return bool(m_bDamageOption);
			case SYSTEM_USEITEMS:
				return bool(m_bUseSystemItem);
			case SYSTEM_GETITEMS:
				if(IsBuilderPC())
				{
					if(bShowSystemMessage)
					{
						return true;
					}
				}
				return !getInstanceUIData().GetIsClassicServer();
			case SYSTEM_DICE:
				if(IsBuilderPC())
				{
					if(bShowSystemMessage)
					{
						return true;
					}
				}
				return (!getInstanceUIData().GetIsClassicServer() && bool(m_bDiceOption));
			case SYSTEM_ESSENTIAL:
				return true;
			default:
				break;
		}
	}
	else if((!bool(m_bOnlyUseSystemMsgWnd) || getInstanceUIData().GetIsClassicServer()))
	{
		switch(systemType)
		{
			case SYSTEM_SERVER:
			case SYSTEM_PETITION:
				return true;
			case SYSTEM_BATTLE:
			case SYSTEM_NONE:
				if(IsBuilderPC())
				{
					if(bShowSystemMessage)
					{
						return true;
					}
				}
				if(getInstanceUIData().GetIsClassicServer())
				{
					return false;
				}
				return (m_filterInfo[channelID].bSystem != 0);
			case SYSTEM_DAMAGETEXT:
				if(IsBuilderPC())
				{
					if(bShowSystemMessage)
					{
						return true;
					}
				}
				if(getInstanceUIData().GetIsClassicServer())
				{
					return false;
				}
				return ((m_filterInfo[channelID].bSystem != 0) || (m_filterInfo[channelID].bDamage != 0));
			case SYSTEM_DAMAGE:
				if(IsBuilderPC())
				{
					if(bShowSystemMessage)
					{
						return true;
					}
				}
				if(getInstanceUIData().GetIsClassicServer())
				{
					return false;
				}
				return (m_filterInfo[channelID].bDamage != 0);
			case SYSTEM_USEITEMS:
				if(IsBuilderPC())
				{
					if(bShowSystemMessage)
					{
						return true;
					}
				}
				if(getInstanceUIData().GetIsClassicServer())
				{
					return false;
				}
				return (m_filterInfo[channelID].bUseitem != 0);
			case SYSTEM_GETITEMS:
				return (m_filterInfo[channelID].bGetitems != 0);
			case SYSTEM_DICE:
				return (m_filterInfo[channelID].bDice != 0);
			case SYSTEM_ESSENTIAL:
			case SYSTEM_CLIENT_DEBUG_MSG:
				return true;
			default:
				break;
		}
	}
	return false;
}

function InitFilterInfo()
{
	local int i, tempVal;
	local string tempstring;

	SetDefaultFilterValue();
	i = 0;
	while((i < 10))
	{
		if(GetINIBool(m_sectionName[i], "dice", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bDice = tempVal;
		}
		else
		{
			SetINIBool(m_sectionName[i], "dice", bool(m_filterInfo[i].bDice), "chatfilter.ini");
		}
		if(GetINIBool(m_sectionName[i], "getitems", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bGetitems = tempVal;
		}
		if(GetINIBool(m_sectionName[i], "system", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bSystem = tempVal;
		}
		if(GetINIBool(m_sectionName[i], "chat", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bChat = tempVal;
		}
		if(GetINIBool(m_sectionName[i], "normal", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bNormal = tempVal;
		}
		if(GetINIBool(m_sectionName[i], "shout", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bShout = tempVal;
		}
		if(GetINIBool(m_sectionName[i], "pledge", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bClan = tempVal;
		}
		if(GetINIBool(m_sectionName[i], "party", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bParty = tempVal;
		}
		if(GetINIBool(m_sectionName[i], "market", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bTrade = tempVal;
		}
		if(GetINIBool(m_sectionName[i], "tell", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bWhisper = tempVal;
		}
		if(GetINIBool(m_sectionName[i], "damage", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bDamage = tempVal;
		}
		if(GetINIBool(m_sectionName[i], "ally", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bAlly = tempVal;
		}
		if(GetINIBool(m_sectionName[i], "worldUnion", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bWorldUnion = tempVal;
		}
		if(GetINIBool(m_sectionName[i], "useitems", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bUseitem = tempVal;
		}
		if(GetINIBool(m_sectionName[i], "hero", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bHero = tempVal;
		}
		if(GetINIBool(m_sectionName[i], "union", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bUnion = tempVal;
		}
		if(GetINIBool(m_sectionName[i], "battle", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bBattle = tempVal;
		}
		if(GetINIBool(m_sectionName[i], "nonpcmessage", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bNoNpcMessage = tempVal;
		}
		if(GetINIBool(m_sectionName[i], "worldChat", tempVal, "chatfilter.ini"))
		{
			m_filterInfo[i].bWorldChat = tempVal;
		}
		++i;
	}
	SetDefaultFilterOn();
	m_UseChatSymbol = int(GetChatFilterBool("Global", "OldChatting"));
	if(GetINIBool("global", "UseWorldChatSpeaker", tempVal, "chatfilter.ini"))
	{
		m_bWorldChatSpeaker = tempVal;
	}
	if(GetINIBool("global", "keywordsound", tempVal, "chatfilter.ini"))
	{
		m_KeywordFilterSound = tempVal;
	}
	if(GetINIBool("global", "keywordactivate", tempVal, "chatfilter.ini"))
	{
		m_KeywordFilterActivate = tempVal;
	}
	if(GetINIString("global", "Keyword0", tempstring, "chatfilter.ini"))
	{
		m_Keyword0 = tempstring;
	}
	if(GetINIString("global", "Keyword1", tempstring, "chatfilter.ini"))
	{
		m_Keyword1 = tempstring;
	}
	if(GetINIString("global", "Keyword2", tempstring, "chatfilter.ini"))
	{
		m_Keyword2 = tempstring;
	}
	if(GetINIString("global", "Keyword3", tempstring, "chatfilter.ini"))
	{
		m_Keyword3 = tempstring;
	}
	if(getInstanceUIData().GetIsLiveServer())
	{
		GetINIBool("global", "SystemMsgWnd", tempVal, "chatfilter.ini");
		m_bUseSystemMsgWnd = tempVal;
	}
	else
	{
		m_bUseSystemMsgWnd = 0;
	}
	if(GetINIBool("global", "UseSystemMsg", tempVal, "chatfilter.ini"))
	{
		m_bSystemMsgWnd = tempVal;
	}
	if(GetINIBool("global", "SystemMsgWndDamage", tempVal, "chatfilter.ini"))
	{
		m_bDamageOption = tempVal;
	}
	if(GetINIBool("global", "SystemMsgWndDice", tempVal, "chatfilter.ini"))
	{
		m_bDiceOption = tempVal;
	}
	if(GetINIBool("global", "SystemMsgWndExpendableItem", tempVal, "chatfilter.ini"))
	{
		m_bUseSystemItem = tempVal;
	}
	if(GetINIBool("global", "OnlyUseSystemMsgWnd", tempVal, "chatfilter.ini"))
	{
		m_bOnlyUseSystemMsgWnd = tempVal;
	}
	return;
}

function SetDefaultFilterValue()
{
	local int bSystemNDamage;

	if(getInstanceUIData().GetIsLiveServer())
	{
		bSystemNDamage = 1;
	}
	else
	{
		bSystemNDamage = 0;
	}
	m_filterInfo[0].bDice = 1;
	m_filterInfo[0].bGetitems = 1;
	m_filterInfo[0].bSystem = bSystemNDamage;
	m_filterInfo[0].bChat = 1;
	m_filterInfo[0].bNormal = 1;
	m_filterInfo[0].bShout = 1;
	m_filterInfo[0].bClan = 1;
	m_filterInfo[0].bParty = 1;
	m_filterInfo[0].bTrade = 1;
	m_filterInfo[0].bWhisper = 1;
	m_filterInfo[0].bDamage = bSystemNDamage;
	m_filterInfo[0].bAlly = 1;
	m_filterInfo[0].bUseitem = 0;
	m_filterInfo[0].bHero = 0;
	m_filterInfo[0].bUnion = 1;
	m_filterInfo[0].bBattle = 1;
	m_filterInfo[0].bNoNpcMessage = 0;
	m_filterInfo[0].bWorldChat = 1;
	m_filterInfo[1].bDice = 1;
	m_filterInfo[1].bGetitems = 1;
	m_filterInfo[1].bSystem = bSystemNDamage;
	m_filterInfo[1].bChat = 1;
	m_filterInfo[1].bNormal = 0;
	m_filterInfo[1].bShout = 1;
	m_filterInfo[1].bClan = 0;
	m_filterInfo[1].bParty = 0;
	m_filterInfo[1].bTrade = 1;
	m_filterInfo[1].bWhisper = 1;
	m_filterInfo[1].bDamage = bSystemNDamage;
	m_filterInfo[1].bAlly = 0;
	m_filterInfo[1].bUseitem = 0;
	m_filterInfo[1].bHero = 0;
	m_filterInfo[1].bUnion = 1;
	m_filterInfo[1].bBattle = 0;
	m_filterInfo[1].bNoNpcMessage = 0;
	m_filterInfo[1].bWorldChat = 0;
	m_filterInfo[2].bDice = 1;
	m_filterInfo[2].bGetitems = 1;
	m_filterInfo[2].bSystem = bSystemNDamage;
	m_filterInfo[2].bChat = 1;
	m_filterInfo[2].bNormal = 0;
	m_filterInfo[2].bShout = 1;
	m_filterInfo[2].bClan = 0;
	m_filterInfo[2].bParty = 1;
	m_filterInfo[2].bTrade = 0;
	m_filterInfo[2].bWhisper = 1;
	m_filterInfo[2].bDamage = bSystemNDamage;
	m_filterInfo[2].bAlly = 0;
	m_filterInfo[2].bUseitem = 0;
	m_filterInfo[2].bHero = 0;
	m_filterInfo[2].bUnion = 1;
	m_filterInfo[2].bBattle = 0;
	m_filterInfo[2].bNoNpcMessage = 0;
	m_filterInfo[2].bWorldChat = 0;
	m_filterInfo[3].bDice = 1;
	m_filterInfo[3].bGetitems = 1;
	m_filterInfo[3].bSystem = bSystemNDamage;
	m_filterInfo[3].bChat = 1;
	m_filterInfo[3].bNormal = 0;
	m_filterInfo[3].bShout = 1;
	m_filterInfo[3].bClan = 1;
	m_filterInfo[3].bParty = 0;
	m_filterInfo[3].bTrade = 0;
	m_filterInfo[3].bWhisper = 1;
	m_filterInfo[3].bDamage = bSystemNDamage;
	m_filterInfo[3].bAlly = 0;
	m_filterInfo[3].bUseitem = 0;
	m_filterInfo[3].bHero = 0;
	m_filterInfo[3].bUnion = 1;
	m_filterInfo[3].bBattle = 0;
	m_filterInfo[3].bNoNpcMessage = 0;
	m_filterInfo[3].bWorldChat = 0;
	m_filterInfo[4].bDice = 1;
	m_filterInfo[4].bGetitems = 1;
	m_filterInfo[4].bSystem = bSystemNDamage;
	m_filterInfo[4].bChat = 1;
	m_filterInfo[4].bNormal = 0;
	m_filterInfo[4].bShout = 1;
	m_filterInfo[4].bClan = 0;
	m_filterInfo[4].bParty = 0;
	m_filterInfo[4].bTrade = 0;
	m_filterInfo[4].bWhisper = 1;
	m_filterInfo[4].bDamage = bSystemNDamage;
	m_filterInfo[4].bAlly = 1;
	m_filterInfo[4].bUseitem = 0;
	m_filterInfo[4].bHero = 0;
	m_filterInfo[4].bUnion = 1;
	m_filterInfo[4].bBattle = 0;
	m_filterInfo[4].bNoNpcMessage = 0;
	m_filterInfo[4].bWorldChat = 0;
	m_filterInfo[5].bDice = 1;
	m_filterInfo[5].bGetitems = 1;
	m_filterInfo[5].bSystem = bSystemNDamage;
	m_filterInfo[5].bChat = 0;
	m_filterInfo[5].bNormal = 0;
	m_filterInfo[5].bShout = 1;
	m_filterInfo[5].bClan = 0;
	m_filterInfo[5].bParty = 0;
	m_filterInfo[5].bTrade = 0;
	m_filterInfo[5].bWhisper = 1;
	m_filterInfo[5].bDamage = bSystemNDamage;
	m_filterInfo[5].bAlly = 0;
	m_filterInfo[5].bUseitem = 0;
	m_filterInfo[5].bHero = 1;
	m_filterInfo[5].bUnion = 1;
	m_filterInfo[5].bBattle = 0;
	m_filterInfo[5].bNoNpcMessage = 0;
	m_filterInfo[5].bWorldChat = 0;
	m_filterInfo[6].bDice = 1;
	m_filterInfo[6].bGetitems = 1;
	m_filterInfo[6].bSystem = bSystemNDamage;
	m_filterInfo[6].bChat = 0;
	m_filterInfo[6].bNormal = 0;
	m_filterInfo[6].bShout = 1;
	m_filterInfo[6].bClan = 0;
	m_filterInfo[6].bParty = 0;
	m_filterInfo[6].bTrade = 0;
	m_filterInfo[6].bWhisper = 1;
	m_filterInfo[6].bDamage = bSystemNDamage;
	m_filterInfo[6].bAlly = 0;
	m_filterInfo[6].bUseitem = 0;
	m_filterInfo[6].bHero = 0;
	m_filterInfo[6].bUnion = 1;
	m_filterInfo[6].bBattle = 0;
	m_filterInfo[6].bNoNpcMessage = 0;
	m_filterInfo[6].bWorldChat = 0;
	m_filterInfo[7].bDice = 1;
	m_filterInfo[7].bGetitems = 1;
	m_filterInfo[7].bSystem = bSystemNDamage;
	m_filterInfo[7].bChat = 0;
	m_filterInfo[7].bNormal = 0;
	m_filterInfo[7].bShout = 1;
	m_filterInfo[7].bClan = 0;
	m_filterInfo[7].bParty = 0;
	m_filterInfo[7].bTrade = 0;
	m_filterInfo[7].bWhisper = 1;
	m_filterInfo[7].bDamage = bSystemNDamage;
	m_filterInfo[7].bAlly = 0;
	m_filterInfo[7].bUseitem = 0;
	m_filterInfo[7].bHero = 0;
	m_filterInfo[7].bUnion = 1;
	m_filterInfo[7].bBattle = 0;
	m_filterInfo[7].bNoNpcMessage = 0;
	m_filterInfo[7].bWorldChat = 0;
	m_filterInfo[8].bDice = 1;
	m_filterInfo[8].bGetitems = 1;
	m_filterInfo[8].bSystem = bSystemNDamage;
	m_filterInfo[8].bChat = 0;
	m_filterInfo[8].bNormal = 0;
	m_filterInfo[8].bShout = 1;
	m_filterInfo[8].bClan = 0;
	m_filterInfo[8].bParty = 0;
	m_filterInfo[8].bTrade = 0;
	m_filterInfo[8].bWhisper = 1;
	m_filterInfo[8].bDamage = bSystemNDamage;
	m_filterInfo[8].bAlly = 0;
	m_filterInfo[8].bUseitem = 0;
	m_filterInfo[8].bHero = 0;
	m_filterInfo[8].bUnion = 1;
	m_filterInfo[8].bBattle = 0;
	m_filterInfo[8].bNoNpcMessage = 0;
	m_filterInfo[8].bWorldChat = 1;
	m_bWorldChatSpeaker = 1;
	m_bUseSystemMsgWnd = 1;
	m_bSystemMsgWnd = 1;
	m_bDamageOption = 1;
	m_bDiceOption = 0;
	m_bUseSystemItem = 1;
	m_NoNpcMessage = 0;
	m_KeywordFilterSound = 0;
	m_KeywordFilterActivate = 0;
	m_UseChatSymbol = 1;
	m_ChatResizeOnOff = 0;
	m_Keyword0 = "";
	m_Keyword1 = "";
	m_Keyword2 = "";
	m_Keyword3 = "";
	m_bOnlyUseSystemMsgWnd = 1;
	return;
}

function SetDefaultFilterValueWorldUnion()
{
	local int bSystemNDamage;

	if(getInstanceUIData().GetIsLiveServer())
	{
		bSystemNDamage = 1;
	}
	else
	{
		bSystemNDamage = 0;
	}
	m_filterInfo[9].bDice = 1;
	m_filterInfo[9].bGetitems = 1;
	m_filterInfo[9].bSystem = 0;
	m_filterInfo[9].bChat = 0;
	m_filterInfo[9].bNormal = 0;
	m_filterInfo[9].bShout = 0;
	m_filterInfo[9].bClan = 0;
	m_filterInfo[9].bParty = 0;
	m_filterInfo[9].bTrade = 0;
	m_filterInfo[9].bWhisper = 0;
	m_filterInfo[9].bDamage = bSystemNDamage;
	m_filterInfo[9].bAlly = 0;
	m_filterInfo[9].bWorldUnion = 1;
	m_filterInfo[9].bUseitem = 0;
	m_filterInfo[9].bHero = 1;
	m_filterInfo[9].bUnion = 0;
	m_filterInfo[9].bBattle = 0;
	m_filterInfo[9].bNoNpcMessage = 0;
	m_filterInfo[9].bWorldChat = 0;
	m_filterInfo[0].bWorldUnion = 1;
	m_filterInfo[1].bWorldUnion = 1;
	m_filterInfo[2].bWorldUnion = 1;
	m_filterInfo[3].bWorldUnion = 1;
	m_filterInfo[4].bWorldUnion = 1;
	m_filterInfo[5].bWorldUnion = 1;
	m_filterInfo[6].bWorldUnion = 1;
	m_filterInfo[7].bWorldUnion = 1;
	m_filterInfo[8].bWorldUnion = 1;
	return;
}

function HandlePartyMatchWnd()
{
	local WindowHandle TaskWnd;
	local PartyMatchRoomWnd p2_script;

	p2_script = PartyMatchRoomWnd(GetScript("PartyMatchRoomWnd"));
	TaskWnd = GetWindowHandle("PartyMatchWnd");
	if(TaskWnd.IsShowWindow())
	{
		ClosePartyMatchingWnd();
	}
	else
	{
		TaskWnd = GetWindowHandle("PartyMatchRoomWnd");
		if(TaskWnd.IsShowWindow())
		{
			TaskWnd.HideWindow();
			TaskWnd = GetWindowHandle("PartyMatchWnd");
			p2_script.OnSendPacketWhenHiding();
			TaskWnd = GetWindowHandle("ChatWnd");
			TaskWnd.SetTimer(1992, 500);
		}
		else
		{
			TaskWnd = GetWindowHandle("PartyMatchWnd");
			Class'NWindow.PartyMatchAPI'.static.RequestOpenPartyMatch();
		}
	}
	return;
}

function ClosePartyMatchingWnd()
{
	local WindowHandle TaskWnd;
	local PartyMatchWnd p_script;

	p_script = PartyMatchWnd(GetScript("PartyMatchWnd"));
	TaskWnd = GetWindowHandle("PartyMatchWnd");
	TaskWnd.HideWindow();
	p_script.OnSendPacketWhenHiding();
	return;
}

function HandleChatmessage(string param)
{
	local int nTmp;
	local UIEventManager.SayPacketType SayType;
	local UIEventManager.ESystemMsgType systemType;
	local string Text, origText, userIDString;
	local Color Color, subColor;
	local SystemMsgData SysMsgData;
	local int SysMsgIndex, relationType, TargetLevel, SharedPositionID, keyWordfoundNum, addedChatNum;

	ParseInt(param, "Type", nTmp);
	SayType = SayPacketType(nTmp);
	ParseString(param, "Msg", origText);
	ParseInt(param, "SharedPositionID", SharedPositionID);
	if((Left(origText, 12) == "+hidden_msg+"))
	{
		return;
	}
	if((int(SayType) == 5))
	{
		ParseInt(param, "SysMsgIndex", SysMsgIndex);
		if((SysMsgIndex == -1))
		{
			Color = GetChatColorByType(int(SayType));
			subColor = GetChatSubColorByType(int(SayType));
		}
		else if((SysMsgIndex == 4700))
		{
			return;
		}
		else
		{
			GetSystemMsgInfo(SysMsgIndex, SysMsgData);
			Color = SysMsgData.FontColor;
		}
		ParseInt(param, "SysType", nTmp);
		systemType = ESystemMsgType(nTmp);
		if((int(systemType) == 10))
		{
			Color.R = 62;
			Color.G = 239;
			Color.B = 10;
		}
	}
	else
	{
		Color = GetChatColorByType(int(SayType));
		subColor = GetChatSubColorByType(int(SayType));
		systemType = SYSTEM_NONE;
	}
	Text = origText;
	if((int(SayType) == 2))
	{
		ParseString(Text, "Title", userIDString);
		ParseInt(param, "Relation", relationType);
		ParseInt(param, "Level", TargetLevel);
		if((Right(Left(userIDString, 2), 1) != "-"))
		{
			CallGFxFunction("UserAlertMessage", "WhisperMessage", ((((("Title=" $ userIDString) $ " RelationType=") $ string(relationType)) $ " Level=") $ string(TargetLevel)));
		}
		ShowmChatMaxBtnAlarm();
	}
	keyWordfoundNum = ChatNotificationFilter(Text, origText, m_Keyword0, m_Keyword1, m_Keyword2, m_Keyword3);
	AddStringToChatWindow(SayType, 0, systemType, Text, Color, subColor, SharedPositionID, addedChatNum);
	AddStringToChatWindow(SayType, 1, systemType, Text, Color, subColor, SharedPositionID, addedChatNum);
	AddStringToChatWindow(SayType, 2, systemType, Text, Color, subColor, SharedPositionID, addedChatNum);
	AddStringToChatWindow(SayType, 3, systemType, Text, Color, subColor, SharedPositionID, addedChatNum);
	if(CheckFilter(SayType, 10, systemType))
	{
		GetChatWindow(5).AddStringToChatWindow(Text, Color, subColor, SharedPositionID);
		CheckNewMessage(5);
		if(m_hSystemMsgWnd.IsShowWindow())
		{
			++addedChatNum;
		}
	}
	if((int(SayType) == 15))
	{
		ParseString(param, "FilteredMsg", origText);
		ShowScreenMessage(origText, 0);
		++addedChatNum;
	}
	if((int(SayType) == 19))
	{
		Color.R = 0;
		Color.G = 255;
		Color.B = 255;
		chatTabInfos[0].ChatWnd.AddStringToChatWindow(Text, Color, subColor, SharedPositionID);
		chatTabInfos[1].ChatWnd.AddStringToChatWindow(Text, Color, subColor, SharedPositionID);
		chatTabInfos[2].ChatWnd.AddStringToChatWindow(Text, Color, subColor, SharedPositionID);
		chatTabInfos[3].ChatWnd.AddStringToChatWindow(Text, Color, subColor, SharedPositionID);
		++addedChatNum;
	}
	if((int(SayType) == 28))
	{
		ShowGfxChattingMessage(param, Color);
	}
	if(((addedChatNum > 0) && (keyWordfoundNum > 0)))
	{
		ShowmChatMaxBtnAlarm();
		if((m_KeywordFilterActivate == 1))
		{
			SetAlarmMaskKeyWord(origText);
		}
	}
	return;
}

function ShowmChatMaxBtnAlarm()
{
	if(isMinSize)
	{
		m_ChatMaxBtnAlarm.ShowWindow();
	}
	return;
}

function UpdateResolution()
{
	local int CurrentMaxWidth, CurrentMaxHeight, CurrentChatWidth, CurrentChatHeight, CurrentEditBoxWidth;
	local bool isFixedW, isFixedH;

	GetCurrentResolution(CurrentMaxWidth, CurrentMaxHeight);
	m_hChatWnd.GetWindowSize(CurrentChatWidth, CurrentChatHeight);
	isFixedW = (CurrentChatWidth > CurrentMaxWidth);
	isFixedH = (CurrentChatHeight > (CurrentMaxHeight - 15));
	if((isFixedW || isFixedH))
	{
		m_hChatWnd.SetWindowSize(399, 130);
		m_hChatWnd.SetResizeFrameOffset(399, 130);
		SetINIInt("global", "ChatSizeWidth", 399, "chatfilter.ini");
		SetINIInt("global", "ChatSizeHeight", 130, "chatfilter.ini");
		OnDefaultPosition();
	}
	return;
}

function UpdateSize(string param)
{
	local int resizeWidth, resizeHeight;
	local string wName, sizeParam;

	ParseInt(param, "Width", resizeWidth);
	ParseInt(param, "Height", resizeHeight);
	ParseString(param, "WindowName", wName);
	ParamAdd(sizeParam, "w", string(resizeWidth));
	ParamAdd(sizeParam, "h", string((resizeHeight + 35)));
	CallGFxFunction("UserAlertMessage", "ReceiveChatWndSize", sizeParam);
	CallGFxFunction("worldChatBox", "ReceiveChatWndSize", sizeParam);
	if((wName == "ChatWnd"))
	{
		SetINIInt("global", "ChatSizeWidth", resizeWidth, "chatfilter.ini");
		SetINIInt("global", "ChatSizeHeight", resizeHeight, "chatfilter.ini");
	}
	return;
}

function handleOnRestart()
{
	ChatEditBox.ClearHistory();
	chatTabInfos[0].ChatWnd.Clear();
	chatTabInfos[1].ChatWnd.Clear();
	chatTabInfos[2].ChatWnd.Clear();
	chatTabInfos[3].ChatWnd.Clear();
	chatTabInfos[3].ChatWnd.Clear();
	SystemMsg.Clear();
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
		case 1234510:
			OpenGivenURL(URL);
			break;
		default:
			break;
	}
	return;
}

function HandleChatWndMacroCommand(string param)
{
	local string Command;
	local UIEventManager.SayPacketType SayType;

	if(!ParseString(param, "Command", Command))
	{
		return;
	}
	SayType = GetChatTypeByTabIndex(m_chatType.UI);
	ProcessChatMessage(Command, SayType, false);
	return;
}

function HandleSetString(string a_Param)
{
	local int IsAppend;
	local string tmpString;

	IsAppend = 0;
	ParseInt(a_Param, "IsAppend", IsAppend);
	if(ParseString(a_Param, "String", tmpString))
	{
		if((IsAppend > 0))
		{
			ChatEditBox.AddString(tmpString);
		}
		else
		{
			ChatEditBox.SetString(tmpString);
		}
	}
	return;
}

function HandleSetFocus()
{
	if(ChatEditBox.IsFocused())
	{
	}
	else
	{
		_Swap2FullAlphaNormal();
		if(isMinSize)
		{
			_Swap2Max();
		}
		Class'Interface.SystemMsgWnd'.static.Inst()._Swap2FullAlpha();
		ChatEditBox.SetFocus();
	}
	return;
}

function UIEventManager.SayPacketType GetChatTypeByTabIndex(int Index)
{
	local UIEventManager.SayPacketType SayType;

	switch(chatTabInfos[Index].channelID)
	{
		case 0:
			SayType = SPT_NORMAL;
			break;
		case 1:
			SayType = SPT_MARKET;
			break;
		case 2:
			SayType = SPT_PARTY;
			break;
		case 3:
			SayType = SPT_PLEDGE;
			break;
		case 4:
			SayType = SPT_ALLIANCE;
			break;
		case 5:
			SayType = SPT_HERO;
			break;
		case 6:
			SayType = SPT_INTER_PARTYMASTER_CHAT;
			break;
		case 7:
			SayType = SPT_SHOUT;
			break;
		case 8:
			SayType = SPT_WORLD;
			break;
		case 9:
			SayType = SPT_WORLD_INRAIDSERVER;
			break;
		default:
			break;
	}
	return SayType;
}

function bool CheckTitleCondition(string param, out string Title)
{
	local int Type;
	local UserInfo uInfo;

	ParseInt(param, "Type", Type);
	if((int(byte(Type)) != 3))
	{
		return false;
	}
	ParseString(param, "Title", Title);
	if((Left(Title, 2) == "->"))
	{
		Title = Mid(Title, 2);
	}
	if(!GetPlayerInfo(uInfo))
	{
		return false;
	}
	if((uInfo.Name == Title))
	{
		return false;
	}
	return true;
}

function HandleTextLinkRButtonClick(string param)
{
	local string ChatMsg, UserName;
	local int posX, posY, UserID;
	local UserInfo UserInfo;

	Debug(("우클릭Param" @ param));  // EN: right-click Param
	ParseInt(param, "PosX", posX);
	ParseInt(param, "PosY", posY);
	ParseInt(param, "ID", UserID);
	ParseString(param, "ChatMsg", ChatMsg);
	ParseString(param, "Title", UserName);
	GetPlayerInfo(UserInfo);
	if((UserInfo.Name != UserName))
	{
		if((UserName != ""))
		{
			getInstanceContextMenu().execContextEvent(UserName, UserID, posX, posY, 1, ChatMsg);
		}
	}
	return;
}

function HandleChatIconClick(string param)
{
	local string Title;

	if(!CheckTitleCondition(param, Title))
	{
		return;
	}
	ShowContextMenuIcon(Title);
	return;
}

function HandleTextLinkLButtonClick(string param)
{
	local string Title;

	if(!CheckTitleCondition(param, Title))
	{
		return;
	}
	SetChatMessage((("\"" $ Title) $ " "));
	ChatEditBox.SetFocus();
	return;
}

function ShowContextMenuIcon(string UserName)
{
	local UIControlContextMenu ContextMenu;
	local int X, Y;

	ContextMenu = Class'Interface.UIControlContextMenu'.static.GetInstance();
	ContextMenu.Clear();
	ContextMenu.DelegateOnClickContextMenu = HandleOnClickContextMenuIcon;
	ContextMenu.DelegateOnHide = HandleOnHideContextMenu;
	ContextMenu.MenuNew(GetSystemString(398), 3);
	if(!getInstanceUIData().isFriend(UserName))
	{
		ContextMenu.MenuNew(GetSystemString(3227), 0);
	}
	if(!getInstanceUIData()._IsParty(UserName))
	{
		ContextMenu.MenuNew(GetSystemString(396), 1);
	}
	if(!getInstanceUIData()._IsBlocked(UserName))
	{
		ContextMenu.MenuNew(GetSystemString(993), 2);
	}
	ContextMenu._SetReservedString(UserName);
	API_GetClientCursorPos(X, Y);
	ContextMenu.Show(X, Y, string(self));
	return;
}

function HandleOnClickContextMenuIcon(int Index)
{
	local string UserName;

	UserName = Class'Interface.UIControlContextMenu'.static.GetInstance()._GetReservedString();
	switch(Index)
	{
		case 0:
			Class'NWindow.PersonalConnectionAPI'.static.RequestAddFriend(UserName);
			break;
		case 1:
			API_RequestInviteParty(UserName);
			break;
		case 2:
			API_RequestAddBlock(UserName);
			break;
		case 3:
			SetChatMessage((("\"" $ UserName) $ " "));
			ChatEditBox.SetFocus();
			break;
		default:
			break;
	}
	return;
}

function API_RequestAddBlock(string UserName)
{
	Debug((("API_RequestAddBlock" @ UserName) @ ConvertWorldStrToID(UserName)));
	Class'NWindow.PersonalConnectionAPI'.static.RequestAddBlock(ConvertWorldStrToID(UserName));
	return;
}

function API_RequestInviteParty(string UserName)
{
	RequestInviteParty(UserName);
	return;
}

function HandleDominionWarChannelSet(string param)
{
	local int DominionWarChannelSet;

	ParseInt(param, "DominionWarChannelSet", DominionWarChannelSet);
	if((DominionWarChannelSet == 1))
	{
		AddSystemMessage(2445);
	}
	else
	{
		AddSystemMessage(2446);
	}
	return;
}

function _Swap2Min()
{
	m_ChatMinBtn.HideWindow();
	m_ChatMaxBtn.ShowWindow();
	m_ChatFilterBtn.HideWindow();
	ChatEditBox.HideWindow();
	chatTabInfos[0].tabButton.HideWindow();
	chatTabInfos[0].ChatWnd.HideWindow();
	chatTabInfos[0].newMessageBtn.HideWindow();
	chatTabInfos[1].tabMergeBtn.HideWindow();
	chatTabInfos[2].tabMergeBtn.HideWindow();
	chatTabInfos[3].tabMergeBtn.HideWindow();
	m_ChatWndBg.HideWindow();
	dragTabNormal.HideWindow();
	if(!chatTabInfos[1].isSplit)
	{
		chatTabInfos[1].channelBtn.HideWindow();
		chatTabInfos[1].ChatWnd.HideWindow();
		chatTabInfos[1].tabButton.HideWindow();
		chatTabInfos[1].newMessageBtn.HideWindow();
	}
	if(!chatTabInfos[2].isSplit)
	{
		chatTabInfos[2].channelBtn.HideWindow();
		chatTabInfos[2].ChatWnd.HideWindow();
		chatTabInfos[2].tabButton.HideWindow();
		chatTabInfos[2].newMessageBtn.HideWindow();
	}
	if(!chatTabInfos[3].isSplit)
	{
		chatTabInfos[3].channelBtn.HideWindow();
		chatTabInfos[3].ChatWnd.HideWindow();
		chatTabInfos[3].tabButton.HideWindow();
		chatTabInfos[3].newMessageBtn.HideWindow();
	}
	isMinSize = true;
	return;
}

function _Swap2Max()
{
	m_ChatMinBtn.ShowWindow();
	m_ChatMaxBtn.HideWindow();
	m_ChatFilterBtn.ShowWindow();
	ChatEditBox.ShowWindow();
	chatTabInfos[0].tabButton.ShowWindow();
	chatTabInfos[1].tabButton.ShowWindow();
	chatTabInfos[2].tabButton.ShowWindow();
	chatTabInfos[3].tabButton.ShowWindow();
	chatTabInfos[1].channelBtn.ShowWindow();
	chatTabInfos[2].channelBtn.ShowWindow();
	chatTabInfos[3].channelBtn.ShowWindow();
	m_ChatMaxBtnAlarm.HideWindow();
	dragTabNormal.ShowWindow();
	m_ChatWndBg.ShowWindow();
	switch(m_chatType.UI)
	{
		case 0:
			chatTabInfos[0].ChatWnd.ShowWindow();
			break;
		case 1:
			if(chatTabInfos[1].isSplit)
			{
				chatTabInfos[0].ChatWnd.ShowWindow();
			}
			else
			{
				chatTabInfos[1].ChatWnd.ShowWindow();
			}
			break;
		case 2:
			if(chatTabInfos[2].isSplit)
			{
				chatTabInfos[0].ChatWnd.ShowWindow();
			}
			else
			{
				chatTabInfos[2].ChatWnd.ShowWindow();
			}
			break;
		case 3:
			if(chatTabInfos[3].isSplit)
			{
				chatTabInfos[0].ChatWnd.ShowWindow();
			}
			else
			{
				chatTabInfos[3].ChatWnd.ShowWindow();
			}
			break;
		default:
			break;
	}
	if(chatTabInfos[1].isSplit)
	{
		chatTabInfos[1].ChatWnd.ShowWindow();
		chatTabInfos[1].tabMergeBtn.ShowWindow();
	}
	if(chatTabInfos[2].isSplit)
	{
		chatTabInfos[2].ChatWnd.ShowWindow();
		chatTabInfos[2].tabMergeBtn.ShowWindow();
	}
	if(chatTabInfos[3].isSplit)
	{
		chatTabInfos[3].ChatWnd.ShowWindow();
		chatTabInfos[3].tabMergeBtn.ShowWindow();
	}
	CheckOnChangeStateMessageBtn((0 + 1));
	CheckOnChangeStateMessageBtn((1 + 1));
	CheckOnChangeStateMessageBtn((2 + 1));
	CheckOnChangeStateMessageBtn((3 + 1));
	isMinSize = false;
	if(IsMouseOver)
	{
		_Swap2FullAlphaNormal();
		_Swap2FullAlpha(1);
		_Swap2FullAlpha(2);
		_Swap2FullAlpha(3);
	}
	if(bool(m_ChatResizeOnOff))
	{
		EnableChatWndResizing(false);
	}
	else
	{
		EnableChatWndResizing(true);
	}
	return;
}

function HandleOptionHasAppled()
{
	GetINIBool("global", "UseAlpha", m_bUseAlpha, "chatfilter.ini");
	if(IsMouseOver)
	{
		_Swap2FullAlphaNormal();
		_Swap2FullAlpha(1);
		_Swap2FullAlpha(2);
		_Swap2FullAlpha(3);
	}
	else
	{
		_Swap2AlphaNormal();
		_Swap2Alpha(1);
		_Swap2Alpha(2);
		_Swap2Alpha(3);
	}
	return;
}

function _Swap2FullAlpha(int tabindex)
{
	if((int(GetLanguage()) == 2))
	{
		return;
	}
	chatTabInfos[tabindex].ChatWnd.SetAlpha(255, 0.2000000);
	chatTabInfos[tabindex].tabButton.SetAlpha(255, 0.2000000);
	chatTabInfos[tabindex].channelBtn.SetAlpha(255, 0.2000000);
	chatTabInfos[tabindex].newMessageBtn.SetAlpha(255, 0.2000000);
	return;
}

function _Swap2Alpha(int tabindex)
{
	if((int(GetLanguage()) == 2))
	{
		return;
	}
	if((m_bUseAlpha == 1))
	{
		chatTabInfos[tabindex].ChatWnd.SetAlpha(0, 0.7000000);
	}
	chatTabInfos[tabindex].channelBtn.SetAlpha(0, 0.7000000);
	chatTabInfos[tabindex].tabButton.SetAlpha(0, 0.7000000);
	return;
}

function _Swap2FullAlphaNormal()
{
	m_hOwnerWnd.KillTimer(2022);
	if((int(GetLanguage()) == 2))
	{
		return;
	}
	m_ChatMinBtn.SetAlpha(255, 0.2000000);
	m_ChatFilterBtn.SetAlpha(255, 0.2000000);
	ChatEditBox.SetAlpha(255, 0.2000000);
	chatTabInfos[0].tabButton.SetAlpha(255, 0.2000000);
	chatTabInfos[0].ChatWnd.SetAlpha(255, 0.2000000);
	SystemMsg.SetAlpha(255, 0.2000000);
	chatTabInfos[1].tabMergeBtn.SetAlpha(255, 0.2000000);
	chatTabInfos[2].tabMergeBtn.SetAlpha(255, 0.2000000);
	chatTabInfos[3].tabMergeBtn.SetAlpha(255, 0.2000000);
	dragTabNormal.SetAlpha(255, 0.2000000);
	m_ChatWndBg.SetAlpha(255, 0.2000000);
	if(!chatTabInfos[1].isSplit)
	{
		_Swap2FullAlpha(1);
	}
	if(!chatTabInfos[2].isSplit)
	{
		_Swap2FullAlpha(2);
	}
	if(!chatTabInfos[3].isSplit)
	{
		_Swap2FullAlpha(3);
	}
	return;
}

function _Swap2AlphaNormal()
{
	local UIControlContextMenu ContextMenu;

	m_hOwnerWnd.KillTimer(2022);
	ContextMenu = Class'Interface.UIControlContextMenu'.static.GetInstance();
	if(ContextMenu.IsMine(string(self)))
	{
		if(ContextMenu.m_hOwnerWnd.IsShowWindow())
		{
			return;
		}
	}
	if((int(GetLanguage()) == 2))
	{
		return;
	}
	m_ChatMinBtn.SetAlpha(0, 0.7000000);
	m_ChatFilterBtn.SetAlpha(0, 0.7000000);
	ChatEditBox.SetAlpha(0, 0.7000000);
	chatTabInfos[0].tabButton.SetAlpha(0, 0.7000000);
	chatTabInfos[0].ChatWnd.SetAlpha(0, 0.7000000);
	SystemMsg.SetAlpha(0, 0.7000000);
	chatTabInfos[1].tabMergeBtn.SetAlpha(0, 0.7000000);
	chatTabInfos[2].tabMergeBtn.SetAlpha(0, 0.7000000);
	chatTabInfos[3].tabMergeBtn.SetAlpha(0, 0.7000000);
	dragTabNormal.SetAlpha(0, 0.7000000);
	if((m_bUseAlpha == 1))
	{
		m_ChatWndBg.SetAlpha(0, 0.7000000);
	}
	if(!chatTabInfos[1].isSplit)
	{
		_Swap2Alpha(1);
	}
	if(!chatTabInfos[2].isSplit)
	{
		_Swap2Alpha(2);
	}
	if(!chatTabInfos[3].isSplit)
	{
		_Swap2Alpha(3);
	}
	return;
}

function _SetChangeFont(int FontType)
{
	local string FontName;

	switch(FontType)
	{
		case 0:
			FontName = "chatFontSize10";
			break;
		case 1:
			FontName = "chatFontSize11";
			break;
		case 2:
			FontName = "chatFontSize12";
			break;
		default:
			FontName = "chatFontSize10";
			break;
	}
	chatTabInfos[0].ChatWnd.SetFontIDByName(FontName);
	chatTabInfos[1].ChatWnd.SetFontIDByName(FontName);
	chatTabInfos[2].ChatWnd.SetFontIDByName(FontName);
	chatTabInfos[3].ChatWnd.SetFontIDByName(FontName);
	SystemMsg.SetFontIDByName(FontName);
	return;
}

function SetDefaultFilterOn()
{
	m_filterInfo[1].bTrade = 1;
	m_filterInfo[2].bParty = 1;
	m_filterInfo[3].bClan = 1;
	m_filterInfo[4].bAlly = 1;
	return;
}

function ChangeTabChannel(int tabindex, int channelID)
{
	local string channelName;
	local LocationShareWnd LocationShareWndScript;

	LocationShareWndScript = LocationShareWnd(GetScript("LocationShareWnd"));
	channelName = GetSystemStringByChatType(channelID);
	switch(channelID)
	{
		case 1:
			ChatTabCtrl.SetButtonName(tabindex, channelName);
			LocationShareWndScript.Tab_Ctrl.SetButtonName((tabindex + 1), channelName);
			break;
		case 2:
			ChatTabCtrl.SetButtonName(tabindex, channelName);
			LocationShareWndScript.Tab_Ctrl.SetButtonName((tabindex + 1), channelName);
			break;
		case 3:
			ChatTabCtrl.SetButtonName(tabindex, channelName);
			LocationShareWndScript.Tab_Ctrl.SetButtonName((tabindex + 1), channelName);
			break;
		case 4:
			ChatTabCtrl.SetButtonName(tabindex, channelName);
			LocationShareWndScript.Tab_Ctrl.SetButtonName((tabindex + 1), channelName);
			break;
		case 5:
			ChatTabCtrl.SetButtonName(tabindex, channelName);
			LocationShareWndScript.Tab_Ctrl.SetButtonName((tabindex + 1), channelName);
			break;
		case 6:
			ChatTabCtrl.SetButtonName(tabindex, channelName);
			LocationShareWndScript.Tab_Ctrl.SetButtonName((tabindex + 1), channelName);
			break;
		case 7:
			ChatTabCtrl.SetButtonName(tabindex, channelName);
			LocationShareWndScript.Tab_Ctrl.SetButtonName((tabindex + 1), channelName);
			break;
		case 8:
			ChatTabCtrl.SetButtonName(tabindex, channelName);
			LocationShareWndScript.Tab_Ctrl.SetButtonName((tabindex + 1), channelName);
			break;
		case 9:
			ChatTabCtrl.SetButtonName(tabindex, channelName);
			LocationShareWndScript.Tab_Ctrl.SetButtonName((tabindex + 1), channelName);
			break;
		default:
			break;
	}
	chatTabInfos[tabindex].channelID = channelID;
	SetCurrentAssignedChatType2Ini(channelID, tabindex);
	return;
}

function SetCurrentAssignedChatType2Ini(int channelID, int chatType)
{
	SetINIInt("global", ("TabIndex" $ string(chatType)), channelID, "chatfilter.ini");
	return;
}

function _SetAllcurrentAssignedChatTypeID()
{
	local int i, tabindex, channelID;

	SetINIInt("global", "TabIndex0", 0, "chatfilter.ini");
	i = 0;
	while((i < 4))
	{
		channelID = i;
		chatTabInfos[i].channelID = channelID;
		i++;
	}
	tabindex = 1;
	while((tabindex < 4))
	{
		if((GetINIInt("global", ("TabIndex" $ string(tabindex)), channelID, "chatfilter.ini") && (channelID > 0)))
		{
			chatTabInfos[tabindex].channelID = channelID;
			ChangeTabChannel(tabindex, channelID);
			tabindex++;
			continue;
		}
		channelID = GetDefaultChannelID(tabindex);
		if((channelID == -1))
		{
			tabindex++;
			continue;
		}
		SetINIInt("global", ("TabIndex" $ string(tabindex)), channelID, "chatfilter.ini");
		ChangeTabChannel(tabindex, channelID);
		tabindex++;
	}
	return;
}

function int GetDefaultChannelID(int tabindex)
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		switch(tabindex)
		{
			case 1:
				return 8;
			case 2:
				return 2;
			case 3:
				return 3;
			default:
				break;
		}
	}
	else
	{
		switch(tabindex)
		{
			case 1:
				return 2;
			case 2:
				return 3;
			case 3:
				return 4;
			default:
				break;
		}
	}
	return -1;
}

function int GetCurrentChatTypeID(int chatTypeUI)
{
	return chatTabInfos[chatTypeUI].channelID;
}

function SetChatEditBox(string txt)
{
	ChatEditBox.SetString(txt);
	ChatEditBox.SetFocus();
	return;
}

function SaveChatFilterOption()
{
	local int i;

	i = 0;
	while((i < m_sectionName.Length))
	{
		SetINIBool(m_sectionName[i], "dice", bool(m_filterInfo[i].bDice), "chatfilter.ini");
		SetINIBool(m_sectionName[i], "getitems", bool(m_filterInfo[i].bGetitems), "chatfilter.ini");
		SetINIBool(m_sectionName[i], "system", bool(m_filterInfo[i].bSystem), "chatfilter.ini");
		SetINIBool(m_sectionName[i], "damage", bool(m_filterInfo[i].bDamage), "chatfilter.ini");
		SetINIBool(m_sectionName[i], "useitems", bool(m_filterInfo[i].bUseitem), "chatfilter.ini");
		SetINIBool(m_sectionName[i], "chat", bool(m_filterInfo[i].bChat), "chatfilter.ini");
		SetINIBool(m_sectionName[i], "normal", bool(m_filterInfo[i].bNormal), "chatfilter.ini");
		SetINIBool(m_sectionName[i], "party", bool(m_filterInfo[i].bParty), "chatfilter.ini");
		SetINIBool(m_sectionName[i], "shout", bool(m_filterInfo[i].bShout), "chatfilter.ini");
		SetINIBool(m_sectionName[i], "market", bool(m_filterInfo[i].bTrade), "chatfilter.ini");
		SetINIBool(m_sectionName[i], "pledge", bool(m_filterInfo[i].bClan), "chatfilter.ini");
		SetINIBool(m_sectionName[i], "tell", bool(m_filterInfo[i].bWhisper), "chatfilter.ini");
		SetINIBool(m_sectionName[i], "ally", bool(m_filterInfo[i].bAlly), "chatfilter.ini");
		SetINIBool(m_sectionName[i], "worldUnion", bool(m_filterInfo[i].bWorldUnion), "chatfilter.ini");
		SetINIBool(m_sectionName[i], "hero", bool(m_filterInfo[i].bHero), "chatfilter.ini");
		SetINIBool(m_sectionName[i], "union", bool(m_filterInfo[i].bUnion), "chatfilter.ini");
		SetINIBool(m_sectionName[i], "nonpcmessage", bool(m_filterInfo[i].bNoNpcMessage), "chatfilter.ini");
		SetINIBool(m_sectionName[i], "worldChat", bool(m_filterInfo[i].bWorldChat), "chatfilter.ini");
		i++;
	}
	SetINIBool("global", "OldChatting", bool(m_UseChatSymbol), "chatfilter.ini");
	SetINIBool("global", "keywordsound", bool(m_KeywordFilterSound), "chatfilter.ini");
	SetINIBool("global", "keywordactivate", bool(m_KeywordFilterActivate), "chatfilter.ini");
	SetINIBool("global", "ChatResizing", bool(m_ChatResizeOnOff), "chatfilter.ini");
	SetINIBool("global", "SystemMsgWnd", bool(m_bUseSystemMsgWnd), "chatfilter.ini");
	SetINIBool("global", "OnlyUseSystemMsgWnd", bool(m_bOnlyUseSystemMsgWnd), "chatfilter.ini");
	SetINIBool("global", "UseSystemMsg", bool(m_bSystemMsgWnd), "chatfilter.ini");
	SetINIBool("global", "SystemMsgWndDamage", bool(m_bDamageOption), "chatfilter.ini");
	SetINIBool("global", "SystemMsgWndDice", bool(m_bDiceOption), "chatfilter.ini");
	SetINIBool("global", "SystemMsgWndExpendableItem", bool(m_bUseSystemItem), "chatfilter.ini");
	SetINIBool("global", "UseWorldChatSpeaker", bool(m_bWorldChatSpeaker), "chatfilter.ini");
	SetINIString("global", "Keyword0", m_Keyword0, "chatfilter.ini");
	SetINIString("global", "Keyword1", m_Keyword1, "chatfilter.ini");
	SetINIString("global", "Keyword2", m_Keyword2, "chatfilter.ini");
	SetINIString("global", "Keyword3", m_Keyword3, "chatfilter.ini");
	if(bool(m_ChatResizeOnOff))
	{
		EnableChatWndResizing(false);
	}
	else
	{
		EnableChatWndResizing(true);
	}
	return;
}

function LoadINIFilterSetting()
{
	local int tempVal, i, resultNum;

	i = 0;
	while((i < m_sectionName.Length))
	{
		GetINIBool(m_sectionName[i], "dice", tempVal, "chatfilter.ini");
		m_filterInfo[i].bDice = tempVal;
		GetINIBool(m_sectionName[i], "getitems", tempVal, "chatfilter.ini");
		m_filterInfo[i].bGetitems = tempVal;
		GetINIBool(m_sectionName[i], "system", tempVal, "chatfilter.ini");
		m_filterInfo[i].bSystem = tempVal;
		GetINIBool(m_sectionName[i], "useitems", tempVal, "chatfilter.ini");
		m_filterInfo[i].bUseitem = tempVal;
		GetINIBool(m_sectionName[i], "damage", tempVal, "chatfilter.ini");
		m_filterInfo[i].bDamage = tempVal;
		GetINIBool(m_sectionName[i], "chat", tempVal, "chatfilter.ini");
		m_filterInfo[i].bChat = tempVal;
		GetINIBool(m_sectionName[i], "normal", tempVal, "chatfilter.ini");
		m_filterInfo[i].bNormal = tempVal;
		GetINIBool(m_sectionName[i], "party", tempVal, "chatfilter.ini");
		m_filterInfo[i].bParty = tempVal;
		GetINIBool(m_sectionName[i], "shout", tempVal, "chatfilter.ini");
		m_filterInfo[i].bShout = tempVal;
		GetINIBool(m_sectionName[i], "market", tempVal, "chatfilter.ini");
		m_filterInfo[i].bTrade = tempVal;
		GetINIBool(m_sectionName[i], "pledge", tempVal, "chatfilter.ini");
		m_filterInfo[i].bClan = tempVal;
		GetINIBool(m_sectionName[i], "tell", tempVal, "chatfilter.ini");
		m_filterInfo[i].bWhisper = tempVal;
		GetINIBool(m_sectionName[i], "ally", tempVal, "chatfilter.ini");
		m_filterInfo[i].bAlly = tempVal;
		GetINIBool(m_sectionName[i], "worldUnion", tempVal, "chatfilter.ini");
		m_filterInfo[i].bWorldUnion = tempVal;
		GetINIBool(m_sectionName[i], "hero", tempVal, "chatfilter.ini");
		m_filterInfo[i].bHero = tempVal;
		GetINIBool(m_sectionName[i], "union", tempVal, "chatfilter.ini");
		m_filterInfo[i].bUnion = tempVal;
		GetINIBool(m_sectionName[i], "nonpcmessage", tempVal, "chatfilter.ini");
		m_filterInfo[i].bNoNpcMessage = tempVal;
		GetINIBool(m_sectionName[i], "worldChat", tempVal, "chatfilter.ini");
		m_filterInfo[i].bWorldChat = tempVal;
		i++;
	}
	m_UseChatSymbol = int(GetChatFilterBool("Global", "OldChatting"));
	GetINIBool("global", "keywordsound", resultNum, "chatfilter.ini");
	m_KeywordFilterSound = resultNum;
	GetINIBool("global", "keywordactivate", resultNum, "chatfilter.ini");
	m_KeywordFilterActivate = resultNum;
	GetINIBool("global", "ChatResizing", resultNum, "chatfilter.ini");
	m_ChatResizeOnOff = resultNum;
	if(getInstanceUIData().GetIsLiveServer())
	{
		GetINIBool("global", "SystemMsgWnd", resultNum, "chatfilter.ini");
		m_bUseSystemMsgWnd = resultNum;
	}
	else
	{
		m_bUseSystemMsgWnd = 0;
	}
	GetINIBool("global", "OnlyUseSystemMsgWnd", resultNum, "chatfilter.ini");
	m_bOnlyUseSystemMsgWnd = resultNum;
	GetINIBool("global", "UseSystemMsg", resultNum, "chatfilter.ini");
	m_bSystemMsgWnd = resultNum;
	GetINIBool("global", "SystemMsgWndDamage", resultNum, "chatfilter.ini");
	m_bDamageOption = resultNum;
	GetINIBool("global", "SystemMsgWndDice", resultNum, "chatfilter.ini");
	m_bDiceOption = resultNum;
	GetINIBool("global", "SystemMsgWndExpendableItem", resultNum, "chatfilter.ini");
	m_bUseSystemItem = resultNum;
	GetINIBool("global", "UseWorldChatSpeaker", resultNum, "chatfilter.ini");
	m_bWorldChatSpeaker = resultNum;
	GetINIString("global", "Keyword0", m_Keyword0, "chatfilter.ini");
	GetINIString("global", "Keyword1", m_Keyword1, "chatfilter.ini");
	GetINIString("global", "Keyword2", m_Keyword2, "chatfilter.ini");
	GetINIString("global", "Keyword3", m_Keyword3, "chatfilter.ini");
	return;
}

function string GetSystemStringByChatType(int chatType)
{
	switch(chatType)
	{
		case 0:
			return GetSystemString(441);
		case 1:
			return GetSystemString(355);
		case 2:
			return GetSystemString(188);
		case 3:
			return GetSystemString(128);
		case 4:
			return GetSystemString(559);
		case 5:
			return GetSystemString(1961);
		case 6:
			return GetSystemString(1962);
		case 7:
			return GetSystemString(1963);
		case 8:
			return GetSystemString(3234);
		case 9:
			return GetSystemString(14108);
		default:
			return "";
	}
}

function UIEventManager.SayPacketType GetChatTypeByType(int nType)
{
	local UIEventManager.SayPacketType SayType;

	switch(nType)
	{
		case 0:
			SayType = SPT_NORMAL;
			break;
		case 1:
			SayType = SPT_MARKET;
			break;
		case 2:
			SayType = SPT_PARTY;
			break;
		case 3:
			SayType = SPT_PLEDGE;
			break;
		case 4:
			SayType = SPT_ALLIANCE;
			break;
		case 5:
			SayType = SPT_HERO;
			break;
		case 6:
			SayType = SPT_INTER_PARTYMASTER_CHAT;
			break;
		case 7:
			SayType = SPT_SHOUT;
			break;
		case 8:
			SayType = SPT_WORLD;
			break;
		case 9:
			SayType = SPT_WORLD_INRAIDSERVER;
		default:
			break;
	}
	return SayType;
}

function string InsertSHARPText(string Msg)
{
	local string MsgTemp, MsgTemp2;
	local int MaxLength, i, maxSharpNum;

	MaxLength = Len(Msg);
	maxSharpNum = 0;
	while((MaxLength > (35 * (maxSharpNum + 1))))
	{
		maxSharpNum++;
	}
	i = 0;
	while((i < maxSharpNum))
	{
		MaxLength = Len(Msg);
		MsgTemp = Left(Msg, ((35 * (i + 1)) + i));
		MsgTemp2 = Right(Msg, (MaxLength - ((35 * (i + 1)) + i)));
		Msg = ((MsgTemp $ "#") $ MsgTemp2);
		i++;
	}
	return Msg;
}

function ShowScreenMessage(string Msg, int FontType)
{
	local string strParam;

	if((Len(Msg) <= 0))
	{
		return;
	}
	Msg = InsertSHARPText(Msg);
	ParamAdd(strParam, "MsgType", string(1));
	ParamAdd(strParam, "WindowType", string(8));
	ParamAdd(strParam, "FontType", string(FontType));
	ParamAdd(strParam, "BackgroundType", string(0));
	ParamAdd(strParam, "LifeTime", string(5000));
	ParamAdd(strParam, "AnimationType", string(1));
	ParamAdd(strParam, "Msg", Msg);
	ParamAdd(strParam, "MsgColorR", string(255));
	ParamAdd(strParam, "MsgColorG", string(150));
	ParamAdd(strParam, "MsgColorB", string(149));
	ExecuteEvent(140, strParam);
	return;
}

function ShowGfxChattingMessage(string param, Color m_color)
{
	local string FilteredMsg;
	local int Color;

	ParseString(param, "FilteredMsg", FilteredMsg);
	Color = getInstanceL2Util().ColorToInt(m_color);
	param = "";
	ParamAdd(param, "Msg", FilteredMsg);
	ParamAdd(param, "type", string(2));
	ParamAdd(param, "textColor", string(Color));
	CallGFxFunction("GfxScreenMessage", "showMessage", param);
	return;
}

function ChatWindowHandle GetChatWindow(int tabindex)
{
	switch(tabindex)
	{
		case 0:
			return chatTabInfos[0].ChatWnd;
		case 1:
			return chatTabInfos[1].ChatWnd;
		case 2:
			return chatTabInfos[2].ChatWnd;
		case 3:
			return chatTabInfos[3].ChatWnd;
		case 5:
			return SystemMsg;
		default:
			return chatTabInfos[0].ChatWnd;
	}
}

function AddStringToChatWindow(UIEventManager.SayPacketType SayType, int tabindex, UIEventManager.ESystemMsgType systemType, string Text, Color mainColor, Color subColor, int SharedPositionID, optional out int addedChatNum)
{
	if(CheckFilter(SayType, chatTabInfos[tabindex].channelID, systemType))
	{
		GetChatWindow(tabindex).AddStringToChatWindow(Text, mainColor, subColor, SharedPositionID);
		CheckNewMessage(tabindex);
		if(GetChatWindow(tabindex).IsShowWindow())
		{
			SetAlarmMaskChat(SayType, Text);
			++addedChatNum;
		}
		else if(isMinSize)
		{
			if((m_chatType.UI == tabindex))
			{
				SetAlarmMaskChat(SayType, Text);
				++addedChatNum;
			}
			else
			{
				switch(tabindex)
				{
					case 0:
						if(((((m_chatType.UI == 1) && chatTabInfos[1].isSplit) || ((m_chatType.UI == 2) && chatTabInfos[2].isSplit)) || ((m_chatType.UI == 3) && chatTabInfos[3].isSplit)))
						{
							SetAlarmMaskChat(SayType, Text);
							++addedChatNum;
						}
						break;
					case 1:
						if(chatTabInfos[1].isSplit)
						{
							SetAlarmMaskChat(SayType, Text);
							++addedChatNum;
						}
						break;
					case 2:
						if(chatTabInfos[2].isSplit)
						{
							SetAlarmMaskChat(SayType, Text);
							++addedChatNum;
						}
						break;
					case 3:
						if(chatTabInfos[3].isSplit)
						{
							SetAlarmMaskChat(SayType, Text);
							++addedChatNum;
						}
						break;
					default:
						break;
				}
			}
		}
	}
	return;
}

event OnScrollMove(string strID, int pos)
{
	local int tabindex;

	tabindex = GetTabIndexByName(strID);
	if((tabindex == -1))
	{
		return;
	}
	if(!chatTabInfos[tabindex].bShowNewMessageBtn)
	{
		return;
	}
	if((GetChatWindow(tabindex).GetScrollPosition() != GetChatWindow(tabindex).GetScrollHeight()))
	{
		return;
	}
	HideNewMessageBtn(tabindex);
	return;
}

function int GetTabIndexByName(string chatWndName)
{
	local int i;

	i = 0;
	while((i < chatTabInfos.Length))
	{
		if((chatTabInfos[i].ChatWnd.GetWindowName() == chatWndName))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function CheckNewMessage(int tabindex)
{
	if((GetChatWindow(tabindex).GetScrollHeight() < 0))
	{
		return;
	}
	if((GetChatWindow(tabindex).GetScrollPosition() == GetChatWindow(tabindex).GetScrollHeight()))
	{
		return;
	}
	ShowNewMessageBtn(tabindex);
	return;
}

function ShowNewMessageBtn(int tabindex)
{
	if((tabindex == 5))
	{
		Class'Interface.SystemMsgWnd'.static.Inst()._ShowNewMessageBtn();
		return;
	}
	chatTabInfos[tabindex].bShowNewMessageBtn = true;
	if((chatTabInfos[tabindex].ChatWnd.IsShowWindow() || chatTabInfos[tabindex].isSplit))
	{
		chatTabInfos[tabindex].newMessageBtn.ShowWindow();
	}
	return;
}

function CheckOnChangeStateMessageBtn(int tabindex)
{
	if(chatTabInfos[tabindex].bShowNewMessageBtn)
	{
		if((chatTabInfos[tabindex].ChatWnd.IsShowWindow() || chatTabInfos[tabindex].isSplit))
		{
			chatTabInfos[tabindex].newMessageBtn.ShowWindow();
		}
		else
		{
			chatTabInfos[tabindex].newMessageBtn.HideWindow();
		}
	}
	else
	{
		chatTabInfos[tabindex].newMessageBtn.HideWindow();
	}
	return;
}

function HideNewMessageBtn(int tabindex)
{
	chatTabInfos[tabindex].bShowNewMessageBtn = false;
	chatTabInfos[tabindex].newMessageBtn.HideWindow();
	chatTabInfos[tabindex].ChatWnd.SetFocus();
	return;
}

function PlayNotifySoundsKeyWord()
{
	if(((bitFlagAlarmKewWord & 1) > 0))
	{
		API_PlayNotifySound(0);
	}
	if(((bitFlagAlarmKewWord & 2) > 0))
	{
		API_PlayNotifySound(1);
	}
	if(((bitFlagAlarmKewWord & 4) > 0))
	{
		API_PlayNotifySound(2);
	}
	if(((bitFlagAlarmKewWord & 8) > 0))
	{
		API_PlayNotifySound(3);
	}
	return;
}

function PlayNotifySoundsChat()
{
	if(((bitFlagAlarmChat & ExpInt(2, 11)) > 0))
	{
		API_PlayIndexedNotifySound(12);
	}
	if(((bitFlagAlarmChat & ExpInt(2, 12)) > 0))
	{
		API_PlayIndexedNotifySound(13);
	}
	if(((bitFlagAlarmChat & ExpInt(2, 13)) > 0))
	{
		API_PlayIndexedNotifySound(14);
	}
	if(((bitFlagAlarmChat & ExpInt(2, 14)) > 0))
	{
		API_PlayIndexedNotifySound(15);
	}
	if(((bitFlagAlarmChat & ExpInt(2, 15)) > 0))
	{
		API_PlayIndexedNotifySound(16);
	}
	bitFlagAlarmChat = 0;
	return;
}

function int SetAlarmMaskKeyWord(string origText)
{
	local int i, alarmType;
	local OptionWnd optionWndScript;
	local string Title, Message;
	local array<string> textes;

	ParseString(origText, "title", Title);
	Split(origText, ":", textes);
	Message = ((Title $ ":") $ textes[0]);
	i = 0;
	while((i < (textes.Length - 1)))
	{
		Message = ((Message $ ":") $ textes[(i + 1)]);
		i++;
	}
	if((m_KeywordFilterSound != 1))
	{
		return alarmType;
	}
	optionWndScript = OptionWnd(GetScript("OptionWnd"));
	if((InStr(Message, m_Keyword0) > 0))
	{
		ValidateNotifyKeyword(optionWndScript._GetKewordAlarmType(0));
	}
	if((InStr(Message, m_Keyword1) > 0))
	{
		ValidateNotifyKeyword(optionWndScript._GetKewordAlarmType(1));
	}
	if((InStr(Message, m_Keyword2) > 0))
	{
		ValidateNotifyKeyword(optionWndScript._GetKewordAlarmType(2));
	}
	if((InStr(Message, m_Keyword3) > 0))
	{
		ValidateNotifyKeyword(optionWndScript._GetKewordAlarmType(3));
	}
}

function SetAlarmMaskChat(UIEventManager.SayPacketType SayType, string Text)
{
	local int NOTIFYMUTEFLAG, Index;
	local string Title;

	switch(SayType)
	{
		case SPT_TELL:
			ParseString(Text, "Title", Title);
			if((InStr(Title, "->") == -1))
			{
				Index = 11;
			}
			break;
		case SPT_WORLD:
			Index = 12;
			break;
		case SPT_PLEDGE:
			Index = 13;
			break;
		case SPT_ALLIANCE:
			Index = 14;
			break;
		case SPT_INTER_PARTYMASTER_CHAT:
			Index = 15;
			break;
		default:
			return;
	}
	NOTIFYMUTEFLAG = GetOptionInt("Audio", "NOTIFYMUTEFLAG");
	if(((NOTIFYMUTEFLAG & ExpInt(2, Index)) == 0))
	{
		ValidateNotifyChat(Index);
	}
	return;
}

function API_GetClientCursorPos(out int X, out int Y)
{
	GetClientCursorPos(X, Y);
	return;
}

function API_C_EX_REQUEST_INVITE_PARTY(string param)
{
	local int cReqType;
	local array<byte> stream;
	local UIPacket._C_EX_REQUEST_INVITE_PARTY packet;

	ParseInt(param, "ReqType", cReqType);
	packet.cReqType = cReqType;
	packet.cSayType = int(GetChatTypeByTabIndex(m_chatType.UI));
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_REQUEST_INVITE_PARTY(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(752, stream);
	return;
}

function API_PlayNotifySound(int alarmType)
{
	Class'NWindow.AudioAPI'.static.PlayNotifySound("ItemSound3.Sys_Chat_Keyword");
	return;
}

function API_PlayIndexedNotifySound(int Index)
{
	if((Index == -1))
	{
		return;
	}
	Class'NWindow.AudioAPI'.static.PlayIndexedNotifySound("", Index, false);
	return;
}

event OnTick()
{
	m_hOwnerWnd.DisableTick();
	if(((validateFlag & 1) > 0))
	{
		PlayNotifySoundsKeyWord();
	}
	if(((validateFlag & 2) > 0))
	{
		PlayNotifySoundsChat();
	}
	validateFlag = 0;
	return;
}

function ValidateNotifyKeyword(int Index)
{
	if((Index == -1))
	{
		return;
	}
	Validate(1);
	bitFlagAlarmKewWord = (bitFlagAlarmKewWord | ExpInt(2, Index));
	return;
}

function ValidateNotifyChat(int Index)
{
	if((Index == -1))
	{
		return;
	}
	Validate(2);
	bitFlagAlarmChat = (bitFlagAlarmChat | ExpInt(2, Index));
	return;
}

function Validate(int flag)
{
	validateFlag = (validateFlag | flag);
	m_hOwnerWnd.EnableTick();
	return;
}

function _HandleShowDevTool()
{
	if(IsUseShowMessage())
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SystemMessageToggleBtn")).ShowWindow();
	}
	return;
}

function _HandleHideDevTool()
{
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SystemMessageToggleBtn")).HideWindow();
	return;
}

function bool IsUseShowMessage()
{
	if(getInstanceUIData().GetIsLiveServer())
	{
		return false;
	}
	if(!IsBuilderPC())
	{
		return false;
	}
	return true;
}

function _HandleSystemMessageBuilderOnGameStart()
{
	if(IsUseShowMessage())
	{
		ShowSYstemMessageBuilder();
	}
	return;
}

function ShowSYstemMessageBuilder()
{
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SystemMessageToggleBtn")).SetButtonName(228);
	bShowSystemMessage = true;
	return;
}

function HideSystemMessageBuilder()
{
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SystemMessageToggleBtn")).SetButtonName(227);
	bShowSystemMessage = false;
	return;
}

function HandleToggleSystemMessage()
{
	if(bShowSystemMessage)
	{
		HideSystemMessageBuilder();
	}
	else
	{
		ShowSYstemMessageBuilder();
	}
	return;
}

function bool CheckWorldFilterEnabled()
{
	local int SelectedTab, selectedChannelID;

	SelectedTab = ChatTabCtrl.GetTopIndex();
	selectedChannelID = chatTabInfos[SelectedTab].channelID;
	return bool(m_filterInfo[selectedChannelID].bWorldChat);
}
