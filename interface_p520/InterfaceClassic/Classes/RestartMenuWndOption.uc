class RestartMenuWndOption extends UICommonAPI
	dependson(UIPacket);

struct RetartPointInfoStruct
{
	var UIEventManager.RestartPoint restartPointLock;
	var int ClassID;
	var bool bLocked;
};

var array<RetartPointInfoStruct> restartPointLocks;
var bool bExpDown;
var RetartPointInfoStruct requestedLock;
var bool bRequeksted;
var RestartMenuWnd restartMenuWndscr;
var L2UITimerObject tObject;

event OnRegisterEvent()
{
	RegisterEvent(40);
	RegisterEvent(EV_PacketID(1019));
	RegisterEvent(EV_PacketID(1018));
	return;
}

event OnLoad()
{
	SetTitles();
	InitTimer();
	restartMenuWndscr = RestartMenuWnd(GetScript("RestartMenuWnd"));
	restartPointLocks.Length = 6;
	restartPointLocks[0].restartPointLock = RESTART_TIME_FIELD_START_POS;
	restartPointLocks[0].ClassID = -1;
	restartPointLocks[1].restartPointLock = RESTART_VILLAGE;
	restartPointLocks[1].ClassID = -1;
	restartPointLocks[2].restartPointLock = RESTART_VILLAGE_USING_ITEM;
	restartPointLocks[2].ClassID = 91663;
	restartPointLocks[3].restartPointLock = RESTART_BATTLE_CAMP;
	restartPointLocks[3].ClassID = -1;
	restartPointLocks[4].restartPointLock = RESTART_NEARBY_BATTLE_FIELD;
	restartPointLocks[4].ClassID = -1;
	HideAllLocks();
	return;
}

event OnEvent(int Event_ID, string param)
{
	if(!IsAdenServer())
	{
		return;
	}
	switch(Event_ID)
	{
		case 40:
			HideAllLocks();
			break;
		case EV_PacketID(1018):
			RT_S_EX_USER_RESTART_LOCKER_LIST();
			break;
		case EV_PacketID(1019):
			RT_S_EX_USER_RESTART_LOCKER_UPDATE();
			break;
		default:
			break;
	}
	return;
}

event OnHide()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	return;
}

event OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	local array<string> btnNames;
	local UIEventManager.RestartPoint pnt;
	local int Index, ClassID;

	Split(a_ButtonHandle.GetParentWindowName(), "_", btnNames);
	if((btnNames[1] == "Wnd"))
	{
		pnt = GetRestartPoint(btnNames[0]);
		ClassID = GetClassID(btnNames[0]);
		Index = GetIndex(pnt, ClassID);
		if((Index == -1))
		{
			return;
		}
		RQ_C_EX_USER_RESTART_LOCKER_UPDATE(pnt, ClassID, !restartPointLocks[Index].bLocked);
	}
	return;
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "Close_Btn":
		case "CloseButton":
			m_hOwnerWnd.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function HideAllLocks()
{
	local int i;

	i = 0;
	while((i < restartPointLocks.Length))
	{
		SetEhcekRestartLock(restartPointLocks[i].restartPointLock, restartPointLocks[i].ClassID, false);
		i++;
	}
	GetTextureHandle("RestartMenuWnd.FeeVillage_lock").HideWindow();
	return;
}

function SetEhcekRestartLock(UIEventManager.RestartPoint pnt, int ClassID, bool bLocked)
{
	local int Index;
	local string restartWndName;

	Index = GetIndex(pnt, ClassID);
	restartPointLocks[Index].restartPointLock = pnt;
	restartPointLocks[Index].ClassID = ClassID;
	restartPointLocks[Index].bLocked = bLocked;
	restartWndName = GetRestartWindowName(pnt, ClassID);
	if(bLocked)
	{
		if(GetButtonHandle(("RestartMenuWnd." $ GetRestartName(pnt, ClassID))).IsShowWindow())
		{
			if((((int(pnt) != 0) && (int(pnt) != 25)) || bExpDown))
			{
				restartMenuWndscr.GetLockTexture(Index).ShowWindow();
			}
		}
		GetTextureHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ restartWndName) $ ".checked")).ShowWindow();
		GetTextBoxHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ restartWndName) $ ".btnTitle_txt")).SetTextColor(GetColor(122, 105, 101, 255));
	}
	else
	{
		restartMenuWndscr.GetLockTexture(Index).HideWindow();
		GetTextureHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ restartWndName) $ ".checked")).HideWindow();
		GetTextBoxHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ restartWndName) $ ".btnTitle_txt")).SetTextColor(GetColor(230, 220, 190, 255));
	}
	return;
}

function RT_S_EX_USER_RESTART_LOCKER_LIST()
{
	local UIPacket._S_EX_USER_RESTART_LOCKER_LIST packet;
	local int i;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_USER_RESTART_LOCKER_LIST(packet))
	{
		return;
	}
	bExpDown = (int(packet.bExpDown) == 1);
	i = 0;
	while((i < packet._lockers.Length))
	{
		SetEhcekRestartLock(RestartPoint(packet._lockers[i].nRestartPoint), packet._lockers[i].nClassID, (int(packet._lockers[i].bLocked) == 1));
		i++;
	}
	if(!bExpDown)
	{
		restartMenuWndscr.GetLockTexture(GetIndex(RESTART_VILLAGE, 0)).HideWindow();
		restartMenuWndscr.GetLockTexture(GetIndex(RESTART_TIME_FIELD_START_POS, 0)).HideWindow();
	}
	return;
}

function RT_S_EX_USER_RESTART_LOCKER_UPDATE()
{
	local UIPacket._S_EX_USER_RESTART_LOCKER_UPDATE packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_USER_RESTART_LOCKER_UPDATE(packet))
	{
		return;
	}
	tObject._Stop();
	bRequeksted = false;
	if((int(packet.bSuccess) == 0))
	{
		return;
	}
	SetEhcekRestartLock(requestedLock.restartPointLock, requestedLock.ClassID, requestedLock.bLocked);
	return;
}

function RQ_C_EX_USER_RESTART_LOCKER_UPDATE(UIEventManager.RestartPoint pnt, int ClassID, bool bLock)
{
	local array<byte> stream;
	local UIPacket._C_EX_USER_RESTART_LOCKER_UPDATE packet;

	if(bRequeksted)
	{
		return;
	}
	requestedLock.restartPointLock = pnt;
	requestedLock.ClassID = ClassID;
	requestedLock.bLocked = bLock;
	packet.nRestartPoint = int(pnt);
	packet.nClassID = ClassID;
	if(bLock)
	{
		packet.bLocked = 1;
	}
	else
	{
		packet.bLocked = 0;
	}
	tObject._Reset();
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_USER_RESTART_LOCKER_UPDATE(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(783, stream);
	return;
}

function SetTitles()
{
	GetTextBoxHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ GetRestartWindowName(RESTART_TIME_FIELD_START_POS)) $ ".btnTitle_txt")).SetText(GetSystemString(14132));
	GetTextBoxHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ GetRestartWindowName(RESTART_VILLAGE)) $ ".btnTitle_txt")).SetText(GetSystemString(14707));
	GetTextBoxHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ GetRestartWindowName(RESTART_VILLAGE_USING_ITEM, 91663)) $ ".btnTitle_txt")).SetText(GetSystemString(13716));
	GetTextBoxHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ GetRestartWindowName(RESTART_BATTLE_CAMP)) $ ".btnTitle_txt")).SetText(GetSystemString(373));
	GetTextBoxHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ GetRestartWindowName(RESTART_NEARBY_BATTLE_FIELD)) $ ".btnTitle_txt")).SetText(GetSystemString(13076));
	return;
}

function InitTimer()
{
	tObject = Class'InterfaceClassic.L2UITimer'.static.Inst()._MakeTimerObject(5000);
	tObject._DelegateOnEnd = DelegateRefreshTImer;
	tObject._DelegateOnStart = DelegateOnStartTImer;
	return;
}

function DelegateRefreshTImer()
{
	bRequeksted = false;
	return;
}

function DelegateOnStartTImer()
{
	bRequeksted = true;
	return;
}

function bool GetLockedByName(string restartname)
{
	local int lockIndex;

	lockIndex = GetIndexByName(restartname);
	if((lockIndex == -1))
	{
		return false;
	}
	return restartPointLocks[lockIndex].bLocked;
}

function int GetIndexByName(string restartname)
{
	return GetIndex(GetRestartPoint(restartname), GetClassID(restartname));
}

function int GetIndex(UIEventManager.RestartPoint pnt, int ClassID)
{
	local int i;

	i = 0;
	while((i < restartPointLocks.Length))
	{
		if((int(restartPointLocks[i].restartPointLock) == int(pnt)))
		{
			if((restartPointLocks[i].ClassID == ClassID))
			{
				return i;
			}
		}
		i++;
	}
	return -1;
}

function string GetRestartWindowName(UIEventManager.RestartPoint RestartPoint, optional int ClassID)
{
	return (GetRestartName(RestartPoint, ClassID) $ "_wnd");
}

function int GetClassID(string restartname)
{
	switch(restartname)
	{
		case "payLcoinVillage":
			return 91663;
		default:
			return -1;
	}
}

function UIEventManager.RestartPoint GetRestartPoint(string restartname)
{
	switch(restartname)
	{
		case "btnTimeZone":
			return RESTART_TIME_FIELD_START_POS;
		case "btnVillage":
			return RESTART_VILLAGE;
		case "btnNearbyBattleField":
			return RESTART_NEARBY_BATTLE_FIELD;
		case "btnCastle":
			return RESTART_CASTLE;
		case "btnBattleCamp":
			return RESTART_BATTLE_CAMP;
		case "btnFortress":
			return RESTART_FORTRESS;
		case "payLcoinVillage":
			return RESTART_VILLAGE_USING_ITEM;
		default:
			return RESTART_DUMMY_10;
	}
}

function string GetRestartName(UIEventManager.RestartPoint RestartPoint, optional int ClassID)
{
	switch(RestartPoint)
	{
		case RESTART_TIME_FIELD_START_POS:
			return "btnTimeZone";
		case RESTART_VILLAGE:
			return "btnVillage";
		case RESTART_NEARBY_BATTLE_FIELD:
			return "btnNearbyBattleField";
		case RESTART_CASTLE:
			return "btnCastle";
		case RESTART_BATTLE_CAMP:
			return "btnBattleCamp";
		case RESTART_FORTRESS:
			return "btnFortress";
		case RESTART_VILLAGE_USING_ITEM:
			return "payLcoinVillage";
		default:
			return "";
	}
}
