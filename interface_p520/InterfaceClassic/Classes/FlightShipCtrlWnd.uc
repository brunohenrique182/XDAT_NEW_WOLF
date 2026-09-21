class FlightShipCtrlWnd extends UIScript;

const MAX_ShortcutPerPage = 12;
const FSShortcutPage = 21;
const Relative_Altitude = 4000;
const SelectTex_X = 1;
const SelectTex_Y = 1;

var WindowHandle Me;
var WindowHandle ShortcutWnd;
var TextBoxHandle AltitudeTxt;
var TextureHandle SelectTex;
var ButtonHandle UpButton;
var ButtonHandle DownButton;
var ButtonHandle LockBtn;
var ButtonHandle UnlockBtn;
var ButtonHandle JoypadBtn;
var EditBoxHandle ChatEditBox;
var ShortcutWnd scriptShortcutWnd;
var int i;
var bool preEnterChattingOption;
var bool m_IsLocked;
var bool m_preDriver;
var bool isNowActiveFlightShipShortcut;
var int preSlot;

function OnRegisterEvent()
{
	RegisterEvent(3540);
	RegisterEvent(3541);
	RegisterEvent(91);
	RegisterEvent(3801);
	RegisterEvent(640);
	RegisterEvent(630);
	RegisterEvent(650);
	return;
}

function OnLoad()
{
	Me = GetWindowHandle("FlightShipCtrlWnd");
	ShortcutWnd = GetWindowHandle("ShortcutWnd");
	AltitudeTxt = GetTextBoxHandle("FlightShipCtrlWnd.AltitudeTxt");
	SelectTex = GetTextureHandle("FlightShipCtrlWnd.FlightShortCut.SelectTex");
	UpButton = GetButtonHandle("FlightShipCtrlWnd.FlightSteerWnd.UpButton");
	DownButton = GetButtonHandle("FlightShipCtrlWnd.FlightSteerWnd.DownButton");
	LockBtn = GetButtonHandle("FlightShipCtrlWnd.FlightShortCut.LockBtn");
	UnlockBtn = GetButtonHandle("FlightShipCtrlWnd.FlightShortCut.UnlockBtn");
	JoypadBtn = GetButtonHandle("FlightShipCtrlWnd.FlightShortCut.JoypadBtn");
	ChatEditBox = GetEditBoxHandle("ChatWnd.ChatEditBox");
	scriptShortcutWnd = ShortcutWnd(GetScript("ShortcutWnd"));
	isNowActiveFlightShipShortcut = false;
	m_preDriver = false;
	preSlot = -1;
	JoypadBtn.HideWindow();
	updateLockButton();
	ShortCutUpdateAll();
	return;
}

function OnExitState(name a_CurrentStateName)
{
	CallGFxFunction("OptionWnd", "onSwitchDisableEnterChatting", string(false));
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
		case 3540:
			OnAirShipState(a_Param);
			break;
		case 3541:
			OnAirShipAltitude(a_Param);
			break;
		case 91:
			ExecuteShortcutCommandBySlot(a_Param);
			break;
		case 3801:
			OnReserveShortCut(a_Param);
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

function OnAirShipState(string a_Param)
{
	local int VehicleID, IsDriver;

	ParseInt(a_Param, "VehicleID", VehicleID);
	ParseInt(a_Param, "IsDriver", IsDriver);
	if((IsDriver > 0))
	{
		if((VehicleID > 0))
		{
			preEnterChattingOption = GetChatFilterBool("Global", "EnterChatting");
			SetChatFilterBool("Global", "EnterChatting", true);
			Debug("OnAirShipState true");
			CallGFxFunction("OptionWnd", "onSwitchEnterChatting", string(true));
			CallGFxFunction("OptionWnd", "onSwitchDisableEnterChatting", string(true));
			Class'NWindow.ShortcutAPI'.static.ActivateGroup("FlightStateShortcut");
			updateLockButton();
			if(!Me.IsShowWindow())
			{
				Me.ShowWindow();
				ShortcutWnd.HideWindow();
			}
			ChatEditBox.ReleaseFocus();
			isNowActiveFlightShipShortcut = true;
			m_preDriver = true;
		}
	}
	else if(((VehicleID > 0) && (m_preDriver == true)))
	{
		CallGFxFunction("OptionWnd", "onSwitchDisableEnterChatting", string(false));
		Class'NWindow.ShortcutAPI'.static.DeactivateGroup("FlightStateShortcut");
		SetChatFilterBool("Global", "EnterChatting", preEnterChattingOption);
		if(preEnterChattingOption)
		{
			Class'NWindow.ShortcutAPI'.static.ActivateGroup("TempStateShortcut");
		}
		Debug(("OnAirShipState2  " @ string(preEnterChattingOption)));
		CallGFxFunction("OptionWnd", "onSwitchEnterChatting", string(preEnterChattingOption));
		if(Me.IsShowWindow())
		{
			Me.HideWindow();
			ShortcutWnd.ShowWindow();
		}
		isNowActiveFlightShipShortcut = false;
		ChatEditBox.ReleaseFocus();
	}
	return;
}

function OnAirShipAltitude(string a_Param)
{
	local int m_nZ;

	ParseInt(a_Param, "Z", m_nZ);
	AltitudeTxt.SetText(string((m_nZ + 4000)));
	return;
}

function ShortCutUpdateAll()
{
	local int nShortcutID;

	nShortcutID = (12 * 21);
	i = 0;
	while((i < 12))
	{
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(("FlightShipCtrlWnd.FlightShortCut.Shortcut" $ string((i + 1))), nShortcutID);
		nShortcutID++;
		++i;
	}
	return;
}

function HandleShortcutUpdate(string param)
{
	local int nShortcutID, nShortcutNum;

	ParseInt(param, "ShortcutID", nShortcutID);
	nShortcutNum = ((nShortcutID - (12 * 21)) + 1);
	if(((nShortcutNum > 0) && (nShortcutNum < (12 + 1))))
	{
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(("FlightShipCtrlWnd.FlightShortCut.Shortcut" $ string(nShortcutNum)), nShortcutID);
	}
	return;
}

function HandleShortcutClear()
{
	i = 0;
	while((i < 12))
	{
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear(("FlightShipCtrlWnd.FlightShortCut.Shortcut" $ string((i + 1))));
		++i;
	}
	return;
}

function ExecuteShortcutCommandBySlot(string a_Param)
{
	local int Slot;

	ParseInt(a_Param, "Slot", Slot);
	if(((Slot >= (12 * 21)) && (Slot < (12 * (21 + 1)))))
	{
		Class'NWindow.ShortcutWndAPI'.static.ExecuteShortcutBySlot(Slot);
	}
	return;
}

function OnReserveShortCut(string a_Param)
{
	local int Slot, slotFromOne;

	ParseInt(a_Param, "Slot", Slot);
	if(((Slot >= (12 * 21)) && (Slot < (12 * (21 + 1)))))
	{
		slotFromOne = ((Slot - (12 * 21)) + 1);
		SelectTex.SetAnchor((("FlightShipCtrlWnd.FlightShortCut.F" $ string(slotFromOne)) $ "Tex"), "TopLeft", "TopLeft", 1, 1);
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

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "UpButton":
			Class'NWindow.VehicleAPI'.static.AirShipMoveUp();
			break;
		case "DownButton":
			Class'NWindow.VehicleAPI'.static.AirShipMoveDown();
			break;
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
