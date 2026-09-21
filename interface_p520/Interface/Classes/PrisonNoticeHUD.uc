class PrisonNoticeHUD extends UICommonAPI
	dependson(UIPacket);

const TIMER_ID_REMAIN_TIME = 1;
const TIMER_DELAY_REMAIN_TIME = 10000;


var PrisonUIInfo _prisonInfo;
var int _remainTimerCount;
var bool _isEnterPacket;
var WindowHandle Me;
var TextBoxHandle prisonNameTextBox;
var TextBoxHandle remainTimeTextBox;
var TextBoxHandle currentCntTextBox;
var TextBoxHandle maxCntTextBox;
var TextBoxHandle cntDivisionTextBox;
var L2UIInventoryObjectSimple inventoryObject;

static function PrisonNoticeHUD Inst()
{
	return PrisonNoticeHUD(GetScript("PrisonNoticeHUD"));
}

function Initialize()
{
	InitControls();
	inventoryObject = AddItemListenerSimple(0);
	inventoryObject.DelegateOnUpdateItem = OnNeedItemUpdated;
	return;
}

function InitControls()
{
	local string ownerFullPath;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	prisonNameTextBox = GetTextBoxHandle((ownerFullPath $ ".PrisonName"));
	remainTimeTextBox = GetTextBoxHandle((ownerFullPath $ ".PrisonTimer_txt"));
	currentCntTextBox = GetTextBoxHandle((ownerFullPath $ ".PrisonCounterRemain_txt"));
	maxCntTextBox = GetTextBoxHandle((ownerFullPath $ ".PrisonCounterGoal_txt"));
	cntDivisionTextBox = GetTextBoxHandle((ownerFullPath $ ".Slash_txt"));
	return;
}

function UpdateUIControls()
{
	UpdateInfoControls();
	return;
}

function UpdateRemainTimeInfo()
{
	local int timerTime;

	timerTime = (_remainTimerCount * 10);
	_prisonInfo.uiRemainTime = (_prisonInfo.serverRemainTime - timerTime);
	if((_prisonInfo.uiRemainTime <= 0))
	{
		KillRemainTimer();
	}
	return;
}

function UpdateInfoControls()
{
	local Color currentCntColor;

	if(((_prisonInfo.inPrison == false) || (_prisonInfo.PrisonType == 0)))
	{
		return;
	}
	prisonNameTextBox.SetText(GetSystemString(GetPrisonTitleStringId(_prisonInfo.PrisonType)));
	remainTimeTextBox.SetText(GetRemainTimeText(_prisonInfo.uiRemainTime));
	if((_prisonInfo.prisonData.NeedItem.Id == 0))
	{
		currentCntTextBox.HideWindow();
		maxCntTextBox.HideWindow();
		cntDivisionTextBox.HideWindow();
	}
	else
	{
		currentCntTextBox.SetText(string(_prisonInfo.currentItemCnt));
		maxCntTextBox.SetText(string(_prisonInfo.prisonData.NeedItem.Amount));
		currentCntTextBox.ShowWindow();
		maxCntTextBox.ShowWindow();
		cntDivisionTextBox.ShowWindow();
		if((INT64(_prisonInfo.currentItemCnt) >= _prisonInfo.prisonData.NeedItem.Amount))
		{
			currentCntColor = GetColor(238, 170, 34, 255);
		}
		else
		{
			currentCntColor = GetColor(221, 221, 221, 255);
		}
		currentCntTextBox.SetTextColor(currentCntColor);
	}
	return;
}

function ResetPrisonInfo()
{
	_prisonInfo.inPrison = false;
	_prisonInfo.PrisonType = 0;
	_prisonInfo.prisonData.PrisonType = 0;
	_prisonInfo.serverRemainTime = 0;
	_prisonInfo.uiRemainTime = 0;
	_prisonInfo.currentItemCnt = 0;
	return;
}

function CloseAndResetInfo()
{
	KillRemainTimer();
	ResetPrisonInfo();
	CloseNoticeHUD();
	_isEnterPacket = false;
	_remainTimerCount = 0;
	Class'Interface.PrisonWnd'.static.Inst().ClosePrisonWnd();
	return;
}

function StartRemainTimer()
{
	KillRemainTimer();
	Me.SetTimer(1, 10000);
	return;
}

function KillRemainTimer()
{
	Me.KillTimer(1);
	return;
}

function OpenNoticeHUD()
{
	if(((_prisonInfo.inPrison == true) && (GetGameStateName() != "COLLECTIONSTATE")))
	{
		Me.ShowWindow();
	}
	return;
}

function CloseNoticeHUD()
{
	Me.HideWindow();
	return;
}

function CheckAndCloseWindows()
{
	local int i;
	local array<string> toCloseWindows;

	toCloseWindows[toCloseWindows.Length] = "TeleportWnd";
	toCloseWindows[toCloseWindows.Length] = "DethroneWnd";
	toCloseWindows[toCloseWindows.Length] = "TeleportBookMarkWnd";
	toCloseWindows[toCloseWindows.Length] = "OlympiadWnd";
	toCloseWindows[toCloseWindows.Length] = "TimeZoneWnd";
	i = 0;
	while((i < toCloseWindows.Length))
	{
		if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow(toCloseWindows[i]))
		{
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow(toCloseWindows[i]);
		}
		i++;
	}
	return;
}

function UpdatePrisonInfo()
{
	local PrisonUIData prisonData;

	if((_prisonInfo.PrisonType > 0))
	{
		GetPrisonData(_prisonInfo.PrisonType, prisonData);
		_prisonInfo.prisonData = prisonData;
		inventoryObject.setId(GetItemID(prisonData.NeedItem.Id));
	}
	else
	{
		ResetPrisonInfo();
		inventoryObject.setId();
	}
	return;
}

function UpdatePrisonNeedItemCntInfo()
{
	local int needItemId;

	needItemId = _prisonInfo.prisonData.NeedItem.Id;
	if(((_prisonInfo.inPrison == true) && (needItemId > 0)))
	{
		_prisonInfo.currentItemCnt = int(GetInventoryItemCount(GetItemID(needItemId)));
	}
	else
	{
		_prisonInfo.currentItemCnt = 0;
	}
	return;
}

function int GetPrisonTitleStringId(int PrisonType)
{
	switch(PrisonType)
	{
		case 1:
			return 14213;
		case 2:
			return 14214;
		case 3:
			return 14215;
		default:
			return 0;
	}
}

function PrisonUIInfo GetInPrisonInfo()
{
	return _prisonInfo;
}

function int GetInPrisonType()
{
	return _prisonInfo.PrisonType;
}

function string GetRemainTimeText(int Time)
{
	local L2Util util;

	util = L2Util(GetScript("L2Util"));
	if((Time <= 0))
	{
		return MakeFullSystemMsg(GetSystemMessage(3390), string(0));
	}
	else if((Time < 60))
	{
		return MakeFullSystemMsg(GetSystemMessage(4360), string(1));
	}
	else
	{
		return util.getTimeStringBySec(Time, true, true);
	}
}

function Rq_C_EX_PRISON_USER_INFO()
{
	local array<byte> stream;
	local UIPacket._C_EX_PRISON_USER_INFO packet;

	if(!Class'Interface.UIPacket'.static.Encode_C_EX_PRISON_USER_INFO(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(814, stream);
	return;
}

function Rs_S_EX_PRISON_USER_ENTER()
{
	local UIPacket._S_EX_PRISON_USER_ENTER packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_PRISON_USER_ENTER(packet))
	{
		return;
	}
	_isEnterPacket = true;
	CheckAndCloseWindows();
	Rq_C_EX_PRISON_USER_INFO();
	return;
}

function Rs_S_EX_PRISON_USER_EXIT()
{
	local UIPacket._S_EX_PRISON_USER_EXIT packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_PRISON_USER_EXIT(packet))
	{
		return;
	}
	CloseAndResetInfo();
	return;
}

function Rs_S_EX_PRISON_USER_INFO()
{
	local UIPacket._S_EX_PRISON_USER_INFO packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_PRISON_USER_INFO(packet))
	{
		return;
	}
	if((packet.cPrisonType > 0))
	{
		_prisonInfo.inPrison = true;
	}
	else
	{
		_prisonInfo.inPrison = false;
	}
	_prisonInfo.PrisonType = packet.cPrisonType;
	_prisonInfo.currentItemCnt = packet.nItemAmount;
	_prisonInfo.serverRemainTime = packet.nRemainTime;
	_prisonInfo.uiRemainTime = packet.nRemainTime;
	UpdatePrisonInfo();
	if((_prisonInfo.inPrison == true))
	{
		_remainTimerCount = 0;
		OpenNoticeHUD();
		if((_prisonInfo.serverRemainTime != 0))
		{
			StartRemainTimer();
		}
		if((_isEnterPacket == true))
		{
			_isEnterPacket = false;
			Class'Interface.PrisonWnd'.static.Inst().OpenPrisonWnd();
		}
	}
	return;
}

function Nt_EV_Restart()
{
	CloseAndResetInfo();
	return;
}

function Nt_EV_StateChanged()
{
	if((GetGameStateName() == "GAMINGSTATE"))
	{
		OpenNoticeHUD();
	}
	else
	{
		CloseNoticeHUD();
		if((GetGameStateName() != "COLLECTIONSTATE"))
		{
			KillRemainTimer();
		}
	}
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(1060));
	RegisterEvent(EV_PacketID(1061));
	RegisterEvent(EV_PacketID(1062));
	RegisterEvent(40);
	RegisterEvent(3410);
	return;
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case 40:
			Nt_EV_Restart();
			break;
		case 3410:
			Nt_EV_StateChanged();
			break;
		case EV_PacketID(1060):
			Rs_S_EX_PRISON_USER_ENTER();
			break;
		case EV_PacketID(1061):
			Rs_S_EX_PRISON_USER_EXIT();
			break;
		case EV_PacketID(1062):
			Rs_S_EX_PRISON_USER_INFO();
			break;
		default:
			break;
	}
	return;
}

event OnTimer(int TimerID)
{
	if((TimerID == 1))
	{
		_remainTimerCount++;
		UpdateRemainTimeInfo();
		UpdateInfoControls();
		Class'Interface.PrisonWnd'.static.Inst().UpdatePrisonPanelControls();
	}
	return;
}

event OnClickButton(string buttonStr)
{
	switch(buttonStr)
	{
		case "PrisonHud_btn":
			OnPrisonWndBtnClicked();
			break;
		default:
			break;
	}
	return;
}

event OnNeedItemUpdated(optional array<ItemInfo> iInfo, optional int Index)
{
	if((((_prisonInfo.inPrison == true) && (_prisonInfo.prisonData.NeedItem.Id > 0)) && (iInfo.Length > 0)))
	{
		UpdatePrisonNeedItemCntInfo();
		UpdateInfoControls();
		Class'Interface.PrisonWnd'.static.Inst().UpdatePrisonPanelControls();
	}
	return;
}

event OnPrisonWndBtnClicked()
{
	Class'Interface.PrisonWnd'.static.Inst().ToggleOpenPrisonWnd();
	return;
}

event OnShow()
{
	UpdatePrisonInfo();
	UpdateUIControls();
	return;
}

event OnLoad()
{
	Initialize();
	return;
}
