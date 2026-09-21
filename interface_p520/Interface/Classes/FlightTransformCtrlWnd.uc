class FlightTransformCtrlWnd extends UIScript;

const MAX_ShortcutPerPage = 12;
const FTShortcutPage = 20;
const SelectTex_X = 1;
const SelectTex_Y = 1;
const FT_TIME = 45000;
const FT_TIME1 = 1000;
const FT_TIMER_ID = 150;
const FT_TIMER_ID1 = 152;

var WindowHandle Me;
var WindowHandle ShortcutWnd;
var ButtonHandle LockBtn;
var ButtonHandle UnlockBtn;
var ButtonHandle JoypadBtn;
var TextureHandle SelectTex;
var ShortcutWnd scriptShortcutWnd;
var int i;
var bool preEnterChattingOption;
var bool isNowActiveFlightTransShortcut;
var bool m_IsLocked;
var int preSlot;

function OnRegisterEvent()
{
	RegisterEvent(3800);
	RegisterEvent(630);
	RegisterEvent(650);
	RegisterEvent(640);
	RegisterEvent(91);
	RegisterEvent(3801);
	RegisterEvent(160);
	return;
}

function OnLoad()
{
	Me = GetWindowHandle("FlightTransformCtrlWnd");
	ShortcutWnd = GetWindowHandle("ShortcutWnd");
	SelectTex = GetTextureHandle("FlightTransformCtrlWnd.SelectTex");
	LockBtn = GetButtonHandle("FlightTransformCtrlWnd.FlightShortCut.LockBtn");
	UnlockBtn = GetButtonHandle("FlightTransformCtrlWnd.FlightShortCut.UnlockBtn");
	JoypadBtn = GetButtonHandle("FlightTransformCtrlWnd.FlightShortCut.JoypadBtn");
	scriptShortcutWnd = ShortcutWnd(GetScript("ShortcutWnd"));
	JoypadBtn.HideWindow();
	isNowActiveFlightTransShortcut = false;
	preSlot = -1;
	updateLockButton();
	ShortCutUpdateAll();
	return;
}

function updateLockButton()
{
	m_IsLocked = GetOptionBool("Game", "IsLockShortcutWnd");
	if(m_IsLocked)
	{
		if(!LockBtn.IsShowWindow())
		{
			LockBtn.ShowWindow();
		}
		if(UnlockBtn.IsShowWindow())
		{
			UnlockBtn.HideWindow();
		}
	}
	else
	{
		if(LockBtn.IsShowWindow())
		{
			LockBtn.HideWindow();
		}
		if(!UnlockBtn.IsShowWindow())
		{
			UnlockBtn.ShowWindow();
		}
	}
	scriptShortcutWnd.ArrangeWnd();
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "LockBtn":
			m_IsLocked = false;
			SetOptionBool("Game", "IsLockShortcutWnd", false);
			updateLockButton();
			break;
		case "UnlockBtn":
			m_IsLocked = true;
			SetOptionBool("Game", "IsLockShortcutWnd", true);
			updateLockButton();
			break;
		default:
			break;
	}
	return;
}

function OnExitState(name a_CurrentStateName)
{
	CallGFxFunction("OptionWnd", "onSwitchDisableEnterChatting", string(false));
	return;
}

function bool getIsArenaServer()
{
	local UIData Script;

	Script = UIData(GetScript("UIData"));
	return Script.getIsArenaServer();
}

function OnEvent(int a_EventID, string a_Param)
{
	if(getIsArenaServer())
	{
		return;
	}
	switch(a_EventID)
	{
		case 3800:
			OnFlightTransformState(a_Param);
			break;
		case 91:
			ExecuteShortcutCommandBySlot(a_Param);
			break;
		case 3801:
			OnReserveShortCut(a_Param);
			break;
		case 160:
			Me.KillTimer(150);
			Me.KillTimer(152);
			break;
		case 630:
			HandleShortcutUpdate(a_Param);
			break;
		case 640:
			ShortCutUpdateAll();
			break;
		case 650:
			HandleShortcutClear();
			updateLockButton();
			break;
		default:
			break;
	}
	return;
}

function OnTimer(int TimerID)
{
	local Vector MyPosition;

	if((TimerID == 150))
	{
		if(!GetOptionBool("ScreenInfo", "SystemTutorialBox"))
		{
			ShowAirTutorial(-1);
		}
		else
		{
			Me.KillTimer(150);
		}
	}
	else if((TimerID == 152))
	{
		MyPosition = GetPlayerPosition();
	}
	return;
}

function OnFlightTransformState(string a_Param)
{
	local int IsFlying;

	ParseInt(a_Param, "IsFly", IsFlying);
	if((IsFlying > 0))
	{
		if(!GetOptionBool("ScreenInfo", "SystemTutorialBox"))
		{
			ShowAirTutorial(2493);
			ShowAirTutorial(2495);
			Me.SetTimer(150, 45000);
		}
		Me.SetTimer(152, 1000);
		preEnterChattingOption = GetChatFilterBool("Global", "EnterChatting");
		SetChatFilterBool("Global", "EnterChatting", true);
		Debug("OnFlightTransformState true");
		CallGFxFunction("OptionWnd", "onSwitchEnterChatting", string(true));
		CallGFxFunction("OptionWnd", "onSwitchDisableEnterChatting", string(true));
		updateLockButton();
		Class'NWindow.ShortcutAPI'.static.ActivateGroup("FlightTransformShortcut");
		if(!Me.IsShowWindow())
		{
			Me.ShowWindow();
			ShortcutWnd.HideWindow();
		}
		isNowActiveFlightTransShortcut = true;
	}
	else
	{
		Me.KillTimer(150);
		Me.KillTimer(152);
		CallGFxFunction("OptionWnd", "onSwitchDisableEnterChatting", string(false));
		Class'NWindow.ShortcutAPI'.static.DeactivateGroup("FlightTransformShortcut");
		SetChatFilterBool("Global", "EnterChatting", preEnterChattingOption);
		if(preEnterChattingOption)
		{
			Class'NWindow.ShortcutAPI'.static.ActivateGroup("TempStateShortcut");
		}
		CallGFxFunction("OptionWnd", "onSwitchEnterChatting", string(preEnterChattingOption));
		if(Me.IsShowWindow())
		{
			Me.HideWindow();
			ShortcutWnd.ShowWindow();
		}
		isNowActiveFlightTransShortcut = false;
	}
	return;
}

function ShortCutUpdateAll()
{
	local int nShortcutID;

	nShortcutID = (12 * 20);
	i = 0;
	while((i < 12))
	{
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(("FlightTransformCtrlWnd.FlightShortCut.Shortcut" $ string((i + 1))), nShortcutID);
		nShortcutID++;
		++i;
	}
	return;
}

function HandleShortcutUpdate(string param)
{
	local int nShortcutID, nShortcutNum;

	ParseInt(param, "ShortcutID", nShortcutID);
	nShortcutNum = ((nShortcutID - (12 * 20)) + 1);
	if(((nShortcutNum > 0) && (nShortcutNum < (12 + 1))))
	{
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(("FlightTransformCtrlWnd.FlightShortCut.Shortcut" $ string(nShortcutNum)), nShortcutID);
	}
	return;
}

function HandleShortcutClear()
{
	i = 0;
	while((i < 12))
	{
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear(("FlightTransformCtrlWnd.FlightShortCut.Shortcut" $ string((i + 1))));
		++i;
	}
	return;
}

function HandleShortcutPageUpdate(string param)
{
	local int ShortcutPage;

	if(ParseInt(param, "ShortcutPage", ShortcutPage))
	{
		Debug(("----------------ShortcutPage " $ string(ShortcutPage)));
		if((ShortcutPage == 20))
		{
			ShortCutUpdateAll();
		}
	}
	return;
}

function ExecuteShortcutCommandBySlot(string a_Param)
{
	local int Slot, slotFromOne;

	ParseInt(a_Param, "Slot", Slot);
	if(((Slot >= (12 * 20)) && (Slot < (12 * (20 + 1)))))
	{
		slotFromOne = ((Slot - (12 * 20)) + 1);
		Class'NWindow.ShortcutWndAPI'.static.ExecuteShortcutBySlot(Slot);
		SelectTex.SetAnchor((("FlightTransformCtrlWnd.F" $ string(slotFromOne)) $ "Tex"), "TopLeft", "TopLeft", 1, 1);
	}
	return;
}

function OnReserveShortCut(string a_Param)
{
	local int Slot, slotFromOne;

	ParseInt(a_Param, "Slot", Slot);
	if(((Slot >= (12 * 20)) && (Slot < (12 * (20 + 1)))))
	{
		slotFromOne = ((Slot - (12 * 20)) + 1);
		SelectTex.SetAnchor((("FlightTransformCtrlWnd.F" $ string(slotFromOne)) $ "Tex"), "TopLeft", "TopLeft", 1, 1);
		if((preSlot == slotFromOne))
		{
			Class'NWindow.ShortcutWndAPI'.static.ExecuteShortcutBySlot(Slot);
		}
		else
		{
			preSlot = slotFromOne;
		}
	}
	return;
}

function ShowAirTutorial(int SystemMsgID)
{
	local int RandVal, RandSystemMsgID;

	if((SystemMsgID < 0))
	{
		RandVal = Rand(4);
		RandSystemMsgID = 2493;
		switch(RandVal)
		{
			case 0:
				RandSystemMsgID = 2493;
				break;
			case 1:
				RandSystemMsgID = 2495;
				break;
			case 2:
				RandSystemMsgID = 2496;
				break;
			case 3:
				RandSystemMsgID = 2497;
				break;
			default:
				break;
		}
	}
	else
	{
		RandSystemMsgID = SystemMsgID;
	}
	if(!GetOptionBool("ScreenInfo", "SystemTutorialBox"))
	{
		AddSystemMessage(RandSystemMsgID);
	}
	else
	{
		Me.KillTimer(150);
	}
	return;
}
