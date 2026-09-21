class OptionWnd extends L2UIGFxScript
	dependson(UIPacket);

const PARTY_MODIFY_REQUEST = 9;
const DIALOGID_proc1 = 10;
const DIALOGID_proc2 = 11;
const DIALOGID_proc3 = 12;
const DIALOGID_proc4 = 13;
const ID_CALL_DIALOG = 10;
const ID_EXEC_FUNCTION = 11;
const ID_OPENWINDOW = 12;

var bool m_AntiAliasing;
var bool m_bDOF;
var int g_CurrentMaxWidth;
var int g_CurrentMaxHeight;
var int nPixelShaderVersion;
var int nVertexShaderVersion;
var bool isGAMINGSTATE;
var DialogBox dScript;
var bool bPartyMember;
var bool bPartyMaster;
var FlightShipCtrlWnd scriptShip;
var FlightTransformCtrlWnd scriptTrans;
var array<string> m_datasheetKeyReplace;
var array<string> m_datasheetKeyReplaced;
var bool isOpenShortCut;
var WindowHandle m_hPartyMatchWnd;
var WindowHandle m_hUnionMatchWnd;
var bool preEnterChattingOption;
var string m_Windowname;
//var delegate<DelegateOnChangeShortcut> __DelegateOnChangeShortcut__Delegate;

delegate DelegateOnChangeShortcut()
{
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(1710);
	RegisterEvent(1720);
	RegisterEvent(3410);
	RegisterEvent(4910);
	RegisterEvent(4911);
	RegisterEvent(4913);
	RegisterEvent(4916);
	RegisterEvent(4914);
	RegisterEvent(4915);
	RegisterEvent(4918);
	RegisterEvent(4919);
	RegisterEvent(1560);
	RegisterEvent(40);
	RegisterEvent(4917);
	RegisterEvent(520);
	RegisterEvent(692);
	RegisterGFxEvent(3452);
	RegisterGFxEvent(5870);
	RegisterGFxEvent(510);
	RegisterGFxEvent(5871);
	RegisterGFxEvent(691);
	RegisterGFxEvent(692);
	RegisterGFxEvent(6210);
	RegisterGFxEvent(9320);
	RegisterGFxEvent(9330);
	RegisterGFxEvent(11030);
	RegisterEvent((100000 + 842));
	RegisterGFxEvent(11575);
	return;
}

function LoadAudioOption()
{
	local bool bMute, bBackgroundBute;

	if(CanUseAudio())
	{
		bMute = GetOptionBool("Audio", "AudioMuteOn");
		SetOptionBool("Audio", "AudioMuteOn", bMute);
		bBackgroundBute = GetOptionBool("Audio", "AudioFocusOn");
		SetOptionBool("Audio", "AudioFocusOn", bBackgroundBute);
	}
	return;
}

function LoadVideoOption()
{
	local bool bKeepMinFrameRate;
	local int TerrainClippingRange;

	bKeepMinFrameRate = GetOptionBool("Video", "IsKeepMinFrameRate");
	TerrainClippingRange = GetOptionInt("Video", "TerrainClippingRange");
	if((TerrainClippingRange <= 0))
	{
		SetOptionInt("Video", "TerrainClippingRange", 1);
		if(bKeepMinFrameRate)
		{
			SetTerrainClippingRange(3);
		}
		else
		{
			SetTerrainClippingRange(1);
		}
	}
	else if((TerrainClippingRange >= 4))
	{
		SetOptionInt("Video", "TerrainClippingRange", 3);
		SetTerrainClippingRange(3);
	}
	m_AntiAliasing = GetOptionBool("Video", "YebisAntiAliasing");
	m_bDOF = GetOptionBool("Video", "YebisDOF");
	if(!bKeepMinFrameRate)
	{
		if(((nPixelShaderVersion >= 30) && (nVertexShaderVersion >= 30)))
		{
			SetYebisAntialiasing(m_AntiAliasing);
			SetYebisDOF(m_bDOF);
		}
	}
	return;
}

function LoadControlOption()
{
	local int iChecked;

	if(GetINIBool("Control", "RightClickBox", iChecked, "Option.ini"))
	{
		SetFixedDefaultCamera((iChecked == 1));
	}
	else
	{
		SetOptionBool("Control", "RightClickBox", true);
		SetFixedDefaultCamera(true);
	}
	if(!GetINIBool("Control", "IsWheelreversed", iChecked, "Option.ini"))
	{
		SetOptionBool("Control", "IsWheelreversed", true);
	}
	return;
}

function LoadChattingOption()
{
	local int iChecked;

	if(!GetINIBool("Global", "EnterChatting", iChecked, "ChatFilter.ini"))
	{
		Class'NWindow.ShortcutAPI'.static.ActivateGroup("TempStateShortcut");
		SetChatFilterBool("Global", "EnterChatting", true);
	}
	return;
}

function LoadGameOption()
{
	local int iChecked;

	if(!GetINIBool("ScreenInfo", "ShowZoneTitle", iChecked, "Option.ini"))
	{
		SetOptionBool("ScreenInfo", "ShowZoneTitle", true);
	}
	if(!GetINIBool("ScreenInfo", "ShowGameTipMsg", iChecked, "Option.ini"))
	{
		SetOptionBool("ScreenInfo", "ShowGameTipMsg", true);
	}
	return;
}

event OnLoad()
{
	m_Windowname = getCurrentWindowName(string(self));
	SetSaveWnd(true, false);
	SetContainerWindow("SkinnedWindow", 205);
	AddState("GAMINGSTATE");
	AddState("LOGINSTATE");
	AddState("LOGINWAITSTATE");
	AddState("PAWNVIEWERSTATE");
	AddState("ARENAGAMINGSTATE");
	AddState("ARENABATTLESTATE");
	SetOptionBool("ScreenInfo", "HideDropItem", false);
	GetShaderVersion(nPixelShaderVersion, nVertexShaderVersion);
	LoadVideoOption();
	LoadAudioOption();
	LoadControlOption();
	LoadGameOption();
	LoadChattingOption();
	DataSheetAssignKeyReplacement();
	scriptShip = FlightShipCtrlWnd(GetScript("FlightShipCtrlWnd"));
	scriptTrans = FlightTransformCtrlWnd(GetScript("FlightTransformCtrlWnd"));
	m_hPartyMatchWnd = GetWindowHandle("PartyMatchWnd");
	m_hUnionMatchWnd = GetWindowHandle("UnionMatchWnd");
	SetReflectionEffect(0);
	if((nVertexShaderVersion >= 20))
	{
		SetOptionBool("Video", "GPUAnimation", true);
	}
	return;
}

function DataSheetAssignKeyReplacement()
{
	m_datasheetKeyReplace[1] = "LEFTMOUSE";
	m_datasheetKeyReplace[2] = "RIGHTMOUSE";
	m_datasheetKeyReplace[3] = "BACKSPACE";
	m_datasheetKeyReplace[4] = "ENTER";
	m_datasheetKeyReplace[5] = "SHIFT";
	m_datasheetKeyReplace[6] = "CTRL";
	m_datasheetKeyReplace[7] = "ALT";
	m_datasheetKeyReplace[8] = "PAUSE";
	m_datasheetKeyReplace[9] = "CAPSLOCK";
	m_datasheetKeyReplace[10] = "ESCAPE";
	m_datasheetKeyReplace[11] = "SPACE";
	m_datasheetKeyReplace[12] = "PAGEUP";
	m_datasheetKeyReplace[13] = "PAGEDOWN";
	m_datasheetKeyReplace[14] = "END";
	m_datasheetKeyReplace[15] = "HOME";
	m_datasheetKeyReplace[16] = "LEFT";
	m_datasheetKeyReplace[17] = "UP";
	m_datasheetKeyReplace[18] = "RIGHT";
	m_datasheetKeyReplace[19] = "DOWN";
	m_datasheetKeyReplace[20] = "SELECT";
	m_datasheetKeyReplace[21] = "PRINT";
	m_datasheetKeyReplace[22] = "PRINTSCRN";
	m_datasheetKeyReplace[23] = "INSERT";
	m_datasheetKeyReplace[24] = "DELETE";
	m_datasheetKeyReplace[25] = "HELP";
	m_datasheetKeyReplace[26] = "NUMPAD0";
	m_datasheetKeyReplace[27] = "NUMPAD1";
	m_datasheetKeyReplace[28] = "NUMPAD2";
	m_datasheetKeyReplace[29] = "NUMPAD3";
	m_datasheetKeyReplace[30] = "NUMPAD4";
	m_datasheetKeyReplace[31] = "NUMPAD5";
	m_datasheetKeyReplace[32] = "NUMPAD6";
	m_datasheetKeyReplace[33] = "NUMPAD7";
	m_datasheetKeyReplace[34] = "NUMPAD8";
	m_datasheetKeyReplace[35] = "NUMPAD9";
	m_datasheetKeyReplace[36] = "GREYSTAR";
	m_datasheetKeyReplace[37] = "GREYPLUS";
	m_datasheetKeyReplace[38] = "SEPARATOR";
	m_datasheetKeyReplace[39] = "GREYMINUS";
	m_datasheetKeyReplace[40] = "NUMPADPERIOD";
	m_datasheetKeyReplace[41] = "GREYSLASH";
	m_datasheetKeyReplace[42] = "NUMLOCK";
	m_datasheetKeyReplace[43] = "SCROLLLOCK";
	m_datasheetKeyReplace[44] = "UNICODE";
	m_datasheetKeyReplace[45] = "SEMICOLON";
	m_datasheetKeyReplace[46] = "EQUALS";
	m_datasheetKeyReplace[47] = "COMMA";
	m_datasheetKeyReplace[48] = "MINUS";
	m_datasheetKeyReplace[49] = "SLASH";
	m_datasheetKeyReplace[50] = "TILDE";
	m_datasheetKeyReplace[51] = "LEFTBRACKET";
	m_datasheetKeyReplace[52] = "BACKSLASH";
	m_datasheetKeyReplace[53] = "RIGHTBRACKET";
	m_datasheetKeyReplace[54] = "SINGLEQUOTE";
	m_datasheetKeyReplace[55] = "PERIOD";
	m_datasheetKeyReplace[56] = "MIDDLEMOUSE";
	m_datasheetKeyReplace[57] = "MOUSEWHEELDOWN";
	m_datasheetKeyReplace[58] = "MOUSEWHEELUP";
	m_datasheetKeyReplace[59] = "UNKNOWN16";
	m_datasheetKeyReplace[60] = "UNKNOWN17";
	m_datasheetKeyReplace[61] = "BACKSLASH";
	m_datasheetKeyReplace[62] = "UNKNOWN19";
	m_datasheetKeyReplace[63] = "UNKNOWN5C";
	m_datasheetKeyReplace[64] = "UNKNOWN5D";
	m_datasheetKeyReplace[65] = "UNKNOWN0C";
	m_datasheetKeyReplaced[1] = GetSystemString(1670);
	m_datasheetKeyReplaced[2] = GetSystemString(1671);
	m_datasheetKeyReplaced[3] = GetSystemString(1517);
	m_datasheetKeyReplaced[4] = "Enter";
	m_datasheetKeyReplaced[5] = "Shift";
	m_datasheetKeyReplaced[6] = "Ctrl";
	m_datasheetKeyReplaced[7] = "Alt";
	m_datasheetKeyReplaced[8] = "Pause";
	m_datasheetKeyReplaced[9] = "CapsLock";
	m_datasheetKeyReplaced[10] = "ESC";
	m_datasheetKeyReplaced[11] = GetSystemString(1672);
	m_datasheetKeyReplaced[12] = "PageUp";
	m_datasheetKeyReplaced[13] = "PageDown";
	m_datasheetKeyReplaced[14] = "End";
	m_datasheetKeyReplaced[15] = "Home";
	m_datasheetKeyReplaced[16] = "Left";
	m_datasheetKeyReplaced[17] = "Up";
	m_datasheetKeyReplaced[18] = "Right";
	m_datasheetKeyReplaced[19] = "Down";
	m_datasheetKeyReplaced[20] = "Select";
	m_datasheetKeyReplaced[21] = "Print";
	m_datasheetKeyReplaced[22] = "PrintScrn";
	m_datasheetKeyReplaced[23] = "Insert";
	m_datasheetKeyReplaced[24] = "Delete";
	m_datasheetKeyReplaced[25] = "Help";
	m_datasheetKeyReplaced[26] = GetSystemString(1657);
	m_datasheetKeyReplaced[27] = GetSystemString(1658);
	m_datasheetKeyReplaced[28] = GetSystemString(1659);
	m_datasheetKeyReplaced[29] = GetSystemString(1660);
	m_datasheetKeyReplaced[30] = GetSystemString(1661);
	m_datasheetKeyReplaced[31] = GetSystemString(1662);
	m_datasheetKeyReplaced[32] = GetSystemString(1663);
	m_datasheetKeyReplaced[33] = GetSystemString(1664);
	m_datasheetKeyReplaced[34] = GetSystemString(1665);
	m_datasheetKeyReplaced[35] = GetSystemString(1666);
	m_datasheetKeyReplaced[36] = "*";
	m_datasheetKeyReplaced[37] = "+";
	m_datasheetKeyReplaced[38] = "Separator";
	m_datasheetKeyReplaced[39] = "-";
	m_datasheetKeyReplaced[40] = ".";
	m_datasheetKeyReplaced[41] = "/";
	m_datasheetKeyReplaced[42] = "NumLock";
	m_datasheetKeyReplaced[43] = "ScrollLock";
	m_datasheetKeyReplaced[44] = "Unicode";
	m_datasheetKeyReplaced[45] = ";";
	m_datasheetKeyReplaced[46] = "=";
	m_datasheetKeyReplaced[47] = ",";
	m_datasheetKeyReplaced[48] = "-";
	m_datasheetKeyReplaced[49] = "/";
	m_datasheetKeyReplaced[50] = "`";
	m_datasheetKeyReplaced[51] = "[";
	m_datasheetKeyReplaced[52] = "";
	m_datasheetKeyReplaced[53] = "]";
	m_datasheetKeyReplaced[54] = "'";
	m_datasheetKeyReplaced[55] = ".";
	m_datasheetKeyReplaced[56] = GetSystemString(1669);
	m_datasheetKeyReplaced[57] = GetSystemString(1667);
	m_datasheetKeyReplaced[58] = GetSystemString(1668);
	m_datasheetKeyReplaced[59] = "-";
	m_datasheetKeyReplaced[60] = "=";
	m_datasheetKeyReplaced[61] = GetSystemString(1676);
	m_datasheetKeyReplaced[62] = GetSystemString(1673);
	m_datasheetKeyReplaced[63] = GetSystemString(1674);
	m_datasheetKeyReplaced[64] = GetSystemString(1675);
	m_datasheetKeyReplaced[65] = GetSystemString(1677);
	return;
}

function string GetUserReadableKeyName(string Input)
{
	local int i;
	local string Output;

	i = 0;
	while((i < m_datasheetKeyReplace.Length))
	{
		if((m_datasheetKeyReplace[i] == Input))
		{
			Output = m_datasheetKeyReplaced[i];
		}
		++i;
	}
	if((Output == ""))
	{
		Output = Input;
	}
	return Output;
}

function PartyLootingChanged(int selectedNum)
{
	if((bPartyMaster || (IsRoomMaster() && !bPartyMember)))
	{
		if((GetOptionInt("Communication", "PartyLooting") == selectedNum))
		{
			return;
		}
		setEnableLootingBox(false);
		RequestPartyLootingModify(selectedNum);
	}
	return;
}

function HandleSwitchEnterchatting()
{
	local bool enableEnterChatting;
	local FlightTransformCtrlWnd scriptFlgithForm;
	local FlightShipCtrlWnd scriptFlightShip;

	scriptFlgithForm = FlightTransformCtrlWnd(GetScript("FlightTransformCtrlWnd"));
	if(scriptFlgithForm.isNowActiveFlightTransShortcut)
	{
		return;
	}
	scriptFlightShip = FlightShipCtrlWnd(GetScript("FlightShipCtrlWnd"));
	if(scriptFlightShip.isNowActiveFlightShipShortcut)
	{
		return;
	}
	Class'NWindow.ShortcutAPI'.static.ActivateGroup("GamingStateDefaultShortcut");
	Class'NWindow.ShortcutAPI'.static.ActivateGroup("CameraControl");
	Class'NWindow.ShortcutAPI'.static.ActivateGroup("GamingStateGMShortcut");
	if(getInstanceUIData().getIsArenaServer())
	{
		handleArenaShortCut();
		preEnterChattingOption = GetChatFilterBool("Global", "EnterChatting");
		SetChatFilterBool("Global", "EnterChatting", true);
		enableEnterChatting = true;
		CallGFxFunction(m_Windowname, "onSwitchDisableEnterChatting", string(true));
	}
	else if(GetChatFilterBool("Global", "EnterChatting"))
	{
		Class'NWindow.ShortcutAPI'.static.ActivateGroup("TempStateShortcut");
		SetChatFilterBool("Global", "EnterChatting", true);
		enableEnterChatting = true;
	}
	else
	{
		Class'NWindow.ShortcutAPI'.static.DeactivateGroup("TempStateShortcut");
		SetChatFilterBool("Global", "EnterChatting", false);
		enableEnterChatting = false;
	}
	CallGFxFunction(m_Windowname, "onSwitchEnterChatting", string(enableEnterChatting));
	return;
}

function ToggleOpenMeWnd(bool isShortCut)
{
	isOpenShortCut = isShortCut;
	if(IsShowWindow())
	{
		HideWindow();
	}
	else
	{
		ShowWindow();
	}
	return;
}

function ShortCutReset()
{
	ActiveFlightShort();
	HandleSwitchEnterchatting();
	handleArenaShortCut();
	return;
}

event OnCallUCFunction(string funcName, string param)
{
	switch(funcName)
	{
		case "ShortCutReset":
			ShortCutReset();
			MenuEntireWnd(GetScript("MenuEntireWnd")).refreshMenu();
			DelegateOnChangeShortcut();
			break;
		case "HandleSwitchEnterchatting":
			HandleSwitchEnterchatting();
			MenuEntireWnd(GetScript("MenuEntireWnd")).refreshMenu();
			break;
		case "PartyLootingChanged":
			PartyLootingChanged(int(param));
			break;
		case "OnChangeShortCutKeyByOptionGfx":
			MenuEntireWnd(GetScript("MenuEntireWnd")).refreshMenu();
			DelegateOnChangeShortcut();
			break;
		case "SetPcRoomBoxData":
			SetPcRoomBoxData(bool(param));
			break;
		case "StateBoxShow":
			StateBoxShow(bool(param));
			break;
		case "handleShaderOptionChange":
			HandleShaderOptionChange();
			break;
		case "setChattingOption":
			setChattingOption();
			break;
		case "bAnonymity":
			API_C_EX_SAVE_ITEM_ANNOUNCE_SETTING(bool(param));
			break;
		case "showSoundContextMenu":
			HandleSelectAlarmType(param);
			break;
		case "ChatFontSizeSaved":
			HandleChatFontSizeSaved(param);
			break;
		default:
			break;
	}
	return;
}

function SetDefaultPositionByClick()
{
	GetCurrentResolution(g_CurrentMaxWidth, g_CurrentMaxHeight);
	SetDefaultPosition();
	return;
}

function _InitAudioOption()
{
	CallGFxFunction(m_Windowname, "InitAudioOption", "");
	return;
}

function InitControlOption()
{
	CallGFxFunction(m_Windowname, "InitControlOption", "");
	return;
}

function InitScreenInfoOption()
{
	CallGFxFunction(m_Windowname, "InitScreenInfoOption", "");
	return;
}

function StateBoxShow(bool bChecked)
{
	local TargetStatusWnd util;

	util = TargetStatusWnd(GetScript("TargetStatusWnd"));
	util.StateBoxShow(bChecked);
	return;
}

function SetPcRoomBoxData(bool bOption)
{
	return;
}

function ActiveFlightShort()
{
	if(scriptShip.Me.IsShowWindow())
	{
		SetChatFilterBool("Global", "EnterChatting", true);
		CallGFxFunction(m_Windowname, "onSwitchEnterChatting", string(true));
		CallGFxFunction(m_Windowname, "onSwitchDisableEnterChatting", string(true));
		Class'NWindow.ShortcutAPI'.static.ActivateGroup("FlightStateShortcut");
		scriptShip.updateLockButton();
	}
	else if(scriptTrans.Me.IsShowWindow())
	{
		SetChatFilterBool("Global", "EnterChatting", true);
		CallGFxFunction(m_Windowname, "onSwitchEnterChatting", string(true));
		CallGFxFunction(m_Windowname, "onSwitchDisableEnterChatting", string(true));
		scriptTrans.updateLockButton();
		Class'NWindow.ShortcutAPI'.static.ActivateGroup("FlightTransformShortcut");
	}
	return;
}

function HandleShaderOptionChange()
{
	m_AntiAliasing = GetOptionBool("Video", "YebisAntialiasing");
	m_bDOF = GetOptionBool("Video", "YebisDOF");
	SetYebisDOF(m_bDOF);
	SetYebisAntialiasing(m_AntiAliasing);
	return;
}

event OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 1710:
			HandleDialogResult(true);
			break;
		case 1720:
			HandleDialogResult(false);
			break;
		case 3410:
			UIActivationUponStateChanges(a_Param);
			break;
		case 4910:
			OnAskPartyLootingModify(a_Param);
			break;
		case 4911:
			OnPartyLootingHasModified(a_Param);
			break;
		case 4917:
		case 4916:
		case 4913:
			bPartyMember = false;
			bPartyMaster = false;
			OnPartyHasDismissed();
			break;
		case 4914:
			bPartyMember = true;
			bPartyMaster = false;
			OnBecamePartyMember(a_Param);
			break;
		case 4915:
			bPartyMember = false;
			bPartyMaster = true;
			OnBecamePartyMaster(a_Param);
			break;
		case 4918:
			bPartyMember = true;
			bPartyMaster = false;
			OnHandOverPartyMaster();
			if((m_hPartyMatchWnd.IsShowWindow() == true))
			{
				m_hPartyMatchWnd.HideWindow();
			}
			if((m_hUnionMatchWnd.IsShowWindow() == true))
			{
				m_hUnionMatchWnd.HideWindow();
			}
			break;
		case 4919:
			bPartyMember = false;
			bPartyMaster = true;
			OnRecvPartyMaster();
			break;
		case 40:
			bPartyMember = false;
			bPartyMaster = false;
			OnRestart();
			break;
		case 1560:
			OnPartyMatchRoomClose();
			break;
		case 692:
			handleArenaShortCut();
			break;
		case (100000 + 842):
			ParsePacket_S_EX_ITEM_ANNOUNCE_SETTING();
			break;
		default:
			break;
	}
	return;
}

function ParsePacket_S_EX_ITEM_ANNOUNCE_SETTING()
{
	local UIPacket._S_EX_ITEM_ANNOUNCE_SETTING packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_ITEM_ANNOUNCE_SETTING(packet))
	{
		return;
	}
	SetOptionBool("Communication", "bAnonymity", (int(packet.bAnonymity) == 1));
	return;
}

function handleArenaShortCut()
{
	local string stateName;

	stateName = GetGameStateName();
	if(((((stateName == "ARENAGAMINGSTATE") || (stateName == "ARENABATTLESTATE")) || (stateName == "ARENAPICKSTATE")) || (stateName == "ARENAOBSERVERSTATE")))
	{
		Class'NWindow.ShortcutAPI'.static.ActivateGroup("ArenaGamingShortcut");
		Class'NWindow.ShortcutAPI'.static.ActivateGroup("ArenaGamingEnterChattingShortcut");
	}
	return;
}

function HandleDialogResult(bool bOK)
{
	local DialogBox dialogBoxScript;

	dialogBoxScript = DialogBox(GetScript("DialogBox"));
	if(DialogIsMineWithTarget(m_Windowname))
	{
		if((dialogBoxScript.DialogGetID() == 9))
		{
			SetRequestPartyLootingModifyAgreement(bOK);
		}
	}
	return;
}

function setEnableLootingBox(bool bEnable)
{
	CallGFxFunction(m_Windowname, "setEnableLootingBox", string(bEnable));
	return;
}

function setLootingBoxSelection(int SelectNum)
{
	CallGFxFunction(m_Windowname, "setLootingBoxSelection", string(SelectNum));
	return;
}

function saveLootingBoxSelection()
{
	CallGFxFunction(m_Windowname, "saveLootingBoxSelection", "");
	return;
}

function SetRequestPartyLootingModifyAgreement(bool bOK)
{
	if(bOK)
	{
		RequestPartyLootingModifyAgreement(1);
	}
	else
	{
		dScript._SetButtonName(1337, 1342);
		RequestPartyLootingModifyAgreement(0);
	}
	return;
}

function OnPartyMatchRoomClose()
{
	if((!bPartyMember && !bPartyMaster))
	{
		setLootingBoxSelection(GetOptionInt("Communication", "PartyLooting"));
	}
	return;
}

function OnPartyHasDismissed()
{
	setLootingBoxSelection(GetOptionInt("Communication", "PartyLooting"));
	setEnableLootingBox(true);
	return;
}

function OnBecamePartyMember(string a_Param)
{
	local int Lootingtype;

	ParseInt(a_Param, "Lootingtype", Lootingtype);
	setLootingBoxSelection(Lootingtype);
	setEnableLootingBox(false);
	return;
}

function OnBecamePartyMaster(string a_Param)
{
	local int Lootingtype;

	ParseInt(a_Param, "Lootingtype", Lootingtype);
	setLootingBoxSelection(Lootingtype);
	setEnableLootingBox(true);
	return;
}

function OnHandOverPartyMaster()
{
	setEnableLootingBox(false);
	return;
}

function OnRecvPartyMaster()
{
	saveLootingBoxSelection();
	setEnableLootingBox(true);
	return;
}

function OnRestart()
{
	setLootingBoxSelection(GetOptionInt("Communication", "PartyLooting"));
	setEnableLootingBox(true);
	if(getInstanceUIData().getIsArenaServer())
	{
		SetChatFilterBool("Global", "EnterChatting", preEnterChattingOption);
	}
	CallGFxFunction(m_Windowname, "ClearAllButtonDeco", "");
	return;
}

function bool IsRoomMaster()
{
	local PartyWnd Script;

	Script = PartyWnd(GetScript("PartyWnd"));
	return Script.m_AmIRoomMaster;
}

function OnPartyLootingHasModified(string a_Param)
{
	local int IsSuccess, LootingScheme;
	local string Schemestr, strParam;
	local SystemMsgData SystemMsgCurrent;
	local TextBoxHandle t_handle;
	local L2Util util;

	util = L2Util(GetScript("L2Util"));
	ParseInt(a_Param, "IsSuccess", IsSuccess);
	ParseInt(a_Param, "LootingScheme", LootingScheme);
	if(getInstanceUIData().GetIsClassicServer())
	{
		PartyWndClassic(GetScript("PartyWndClassic"))._HandleUpdatePartyLootingHasModified(IsSuccess, LootingScheme);
	}
	else
	{
		PartyWnd(GetScript("PartyWnd"))._HandleUpdatePartyLootingHasModified(IsSuccess, LootingScheme);
	}
	if((bPartyMaster || IsRoomMaster()))
	{
		AddSystemMessage(3136);
		setEnableLootingBox(true);
		if((IsSuccess == 0))
		{
			setLootingBoxSelection(GetOptionInt("Communication", "PartyLooting"));
		}
		else
		{
			SetOptionInt("Communication", "PartyLooting", LootingScheme);
		}
	}
	if((IsSuccess == 0))
	{
		return;
	}
	Schemestr = util.getLootingString(LootingScheme);
	t_handle = GetTextBoxHandle("PartyMatchRoomWnd.LootingMethod");
	t_handle.SetText(Schemestr);
	switch(IsSuccess)
	{
		case 1:
		case 2:
			GetSystemMsgInfo(3138, SystemMsgCurrent);
			ParamAdd(strParam, "Type", string(1));
			ParamAdd(strParam, "param1", Schemestr);
			PlaySound(SystemMsgCurrent.Sound);
			setLootingBoxSelection(LootingScheme);
			break;
		default:
			break;
	}
	return;
}

function OnAskPartyLootingModify(string a_Param)
{
	local string LeaderName;
	local int LootingScheme;
	local string Schemestr;
	local L2Util util;

	util = L2Util(GetScript("L2Util"));
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("DialogBox"))
	{
		SetRequestPartyLootingModifyAgreement(false);
		return;
	}
	dScript._SetButtonName(184, 185);
	Class'InterfaceClassic.UICommonAPI'.static.DialogSetID(9);
	Class'InterfaceClassic.UICommonAPI'.static.DialogSetParamInt64(INT64((10 * 1000)));
	Class'InterfaceClassic.UICommonAPI'.static.DialogSetDefaultCancle();
	ParseString(a_Param, "LeaderName", LeaderName);
	ParseInt(a_Param, "LootingScheme", LootingScheme);
	Schemestr = util.getLootingString(LootingScheme);
	Class'InterfaceClassic.UICommonAPI'.static.DialogShowWithTarget(DialogModalType_Modalless, DialogType_Progress, MakeFullSystemMsg(GetSystemMessage(3134), Schemestr), m_Windowname);
	return;
}

function UIActivationUponStateChanges(string a_Param)
{
	if(((((a_Param == "GAMINGSTATE") || (a_Param == "ARENAGAMINGSTATE")) || (a_Param == "ARENABATTLESTATE")) || (a_Param == "ARENAPICKSTATE")))
	{
		HandleSwitchEnterchatting();
		Class'NWindow.ShortcutAPI'.static.RequestList();
		isGAMINGSTATE = true;
	}
	else
	{
		isGAMINGSTATE = false;
	}
	SetAlwaysOnTop(!isGAMINGSTATE);
	InitControlOption();
	return;
}

function setChattingOption()
{
	local ChatWnd Script;
	local int tempVal, i, resultNum;

	Script = ChatWnd(GetScript("ChatWnd"));
	i = 0;
	while((i < Script.m_sectionName.Length))
	{
		GetINIBool(Script.m_sectionName[i], "dice", tempVal, "chatfilter.ini");
		Script.m_filterInfo[i].bDice = tempVal;
		GetINIBool(Script.m_sectionName[i], "getitems", tempVal, "chatfilter.ini");
		Script.m_filterInfo[i].bGetitems = tempVal;
		GetINIBool(Script.m_sectionName[i], "system", tempVal, "chatfilter.ini");
		Script.m_filterInfo[i].bSystem = tempVal;
		GetINIBool(Script.m_sectionName[i], "useitems", tempVal, "chatfilter.ini");
		Script.m_filterInfo[i].bUseitem = tempVal;
		GetINIBool(Script.m_sectionName[i], "damage", tempVal, "chatfilter.ini");
		Script.m_filterInfo[i].bDamage = tempVal;
		GetINIBool(Script.m_sectionName[i], "chat", tempVal, "chatfilter.ini");
		Script.m_filterInfo[i].bChat = tempVal;
		GetINIBool(Script.m_sectionName[i], "normal", tempVal, "chatfilter.ini");
		Script.m_filterInfo[i].bNormal = tempVal;
		GetINIBool(Script.m_sectionName[i], "party", tempVal, "chatfilter.ini");
		Script.m_filterInfo[i].bParty = tempVal;
		GetINIBool(Script.m_sectionName[i], "shout", tempVal, "chatfilter.ini");
		Script.m_filterInfo[i].bShout = tempVal;
		GetINIBool(Script.m_sectionName[i], "market", tempVal, "chatfilter.ini");
		Script.m_filterInfo[i].bTrade = tempVal;
		GetINIBool(Script.m_sectionName[i], "pledge", tempVal, "chatfilter.ini");
		Script.m_filterInfo[i].bClan = tempVal;
		GetINIBool(Script.m_sectionName[i], "tell", tempVal, "chatfilter.ini");
		Script.m_filterInfo[i].bWhisper = tempVal;
		GetINIBool(Script.m_sectionName[i], "ally", tempVal, "chatfilter.ini");
		Script.m_filterInfo[i].bAlly = tempVal;
		GetINIBool(Script.m_sectionName[i], "hero", tempVal, "chatfilter.ini");
		Script.m_filterInfo[i].bHero = tempVal;
		GetINIBool(Script.m_sectionName[i], "union", tempVal, "chatfilter.ini");
		Script.m_filterInfo[i].bUnion = tempVal;
		GetINIBool(Script.m_sectionName[i], "nonpcmessage", tempVal, "chatfilter.ini");
		Script.m_filterInfo[i].bNoNpcMessage = tempVal;
		GetINIBool(Script.m_sectionName[i], "worldChat", tempVal, "chatfilter.ini");
		Script.m_filterInfo[i].bWorldChat = tempVal;
		GetINIBool(Script.m_sectionName[i], "worldUnion", tempVal, "chatfilter.ini");
		Script.m_filterInfo[i].bWorldUnion = tempVal;
		i++;
	}
	Script.m_UseChatSymbol = int(GetChatFilterBool("Global", "OldChatting"));
	GetINIBool("global", "keywordsound", resultNum, "chatfilter.ini");
	Script.m_KeywordFilterSound = resultNum;
	GetINIBool("global", "keywordactivate", resultNum, "chatfilter.ini");
	Script.m_KeywordFilterActivate = resultNum;
	GetINIBool("global", "ChatResizing", resultNum, "chatfilter.ini");
	Script.m_ChatResizeOnOff = resultNum;
	GetINIBool("global", "SystemMsgWnd", resultNum, "chatfilter.ini");
	Script.m_bUseSystemMsgWnd = resultNum;
	GetINIBool("global", "UseSystemMsg", resultNum, "chatfilter.ini");
	Script.m_bSystemMsgWnd = resultNum;
	GetINIBool("global", "SystemMsgWndDamage", resultNum, "chatfilter.ini");
	Script.m_bDamageOption = resultNum;
	GetINIBool("global", "SystemMsgWndExpendableItem", resultNum, "chatfilter.ini");
	Script.m_bUseSystemItem = resultNum;
	GetINIBool("global", "UseWorldChatSpeaker", resultNum, "chatfilter.ini");
	Script.m_bWorldChatSpeaker = resultNum;
	GetINIBool("global", "OnlyUseSystemMsgWnd", resultNum, "chatfilter.ini");
	Script.m_bOnlyUseSystemMsgWnd = resultNum;
	GetINIBool("global", "SystemMsgWndDice", resultNum, "chatfilter.ini");
	Script.m_bDiceOption = resultNum;
	GetINIString("global", "Keyword0", Script.m_Keyword0, "chatfilter.ini");
	GetINIString("global", "Keyword1", Script.m_Keyword1, "chatfilter.ini");
	GetINIString("global", "Keyword2", Script.m_Keyword2, "chatfilter.ini");
	GetINIString("global", "Keyword3", Script.m_Keyword3, "chatfilter.ini");
	if(getInstanceUIData().GetIsLiveServer())
	{
		if(bool(Script.m_bUseSystemMsgWnd))
		{
			Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("SystemMsgWnd");
		}
		else
		{
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow("SystemMsgWnd");
		}
	}
	else
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("SystemMsgWnd");
	}
	if(bool(Script.m_ChatResizeOnOff))
	{
		EnableChatWndResizing(false);
	}
	else
	{
		EnableChatWndResizing(true);
	}
	Script._SetAllcurrentAssignedChatTypeID();
	return;
}

function API_C_EX_SAVE_ITEM_ANNOUNCE_SETTING(bool bAnonymity)
{
	local array<byte> stream;
	local UIPacket._C_EX_SAVE_ITEM_ANNOUNCE_SETTING packet;

	packet.bAnonymity = byte(bAnonymity);
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_SAVE_ITEM_ANNOUNCE_SETTING(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(625, stream);
	return;
}

function HandleSelectAlarmType(string param)
{
	local UIControlContextMenu ContextMenu;
	local int X, Y, keyWordIndex, kewordAlarmType;
	local string buttonName;

	ParseInt(param, "x", X);
	ParseInt(param, "y", Y);
	ParseString(param, "buttonName", buttonName);
	ContextMenu = Class'InterfaceClassic.UIControlContextMenu'.static.GetInstance();
	ContextMenu.Clear();
	ContextMenu.DelegateOnClickContextMenu = HandleOnClickContextMenu;
	keyWordIndex = int(Right(buttonName, 1));
	kewordAlarmType = _GetKewordAlarmType(keyWordIndex);
	NewArarmMenu(GetSystemString(14248), keyWordIndex, 0, kewordAlarmType);
	NewArarmMenu(GetSystemString(14249), keyWordIndex, 1, kewordAlarmType);
	NewArarmMenu(GetSystemString(14250), keyWordIndex, 2, kewordAlarmType);
	NewArarmMenu(GetSystemString(14250), keyWordIndex, 3, kewordAlarmType);
	ContextMenu.Show(X, Y, string(self));
	return;
}

function NewArarmMenu(string Title, int btnIndex, int soundType, int currentAlarmType)
{
	local UIControlContextMenu ContextMenu;

	ContextMenu = Class'InterfaceClassic.UIControlContextMenu'.static.GetInstance();
	if((soundType == currentAlarmType))
	{
		ContextMenu.MenuNew(Title, ((btnIndex * 10) + soundType), getInstanceL2Util().Yellow);
	}
	else
	{
		ContextMenu.MenuNew(Title, ((btnIndex * 10) + soundType), getInstanceL2Util().Gray);
	}
	return;
}

function HandleOnClickContextMenu(int Index)
{
	local int keyWordIndex, soundType;

	keyWordIndex = (Index / 10);
	soundType = int((float(Index) % 10.0000000));
	SetINIInt("global", ("KeywordAlarmType" $ string(keyWordIndex)), soundType, "chatfilter.ini");
	return;
}

function HandleChatFontSizeSaved(string param)
{
	Debug(("HandleChatFontSizeSaved" @ param));
	Class'InterfaceClassic.ChatWnd'.static.Inst()._SetChangeFont(int(param));
	return;
}

function int _GetKewordAlarmType(int keyWordIndex)
{
	local int Type;

	if(GetINIInt("global", ("KeywordAlarmType" $ string(keyWordIndex)), Type, "chatfilter.ini"))
	{
		return Type;
	}
	return 0;
}
