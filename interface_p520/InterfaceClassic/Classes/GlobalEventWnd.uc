class GlobalEventWnd extends UICommonAPI
	dependson(UIPacket);

const EVENT_BTN_NAME = "eventBtn_";
const TIMER_ID_BTN_DELAY = 1;
const TIMER_DELAY_BTN_DISABLE = 500;

struct GlobalEventInfo
{
	var int Index;
	var string Title;
	var string Desc;
};

var array<GlobalEventInfo> _eventInfoList;
var WindowHandle Me;
var string m_Windowname;
var RichListCtrlHandle eventRichListCtrl;
var bool _isWaitingBtnDelay;

function Initialize()
{
	InitControls();
	InitData();
	return;
}

function InitControls()
{
	Me = GetWindowHandle(m_Windowname);
	eventRichListCtrl = GetRichListCtrlHandle((m_Windowname $ ".List_ListCtrl"));
	eventRichListCtrl.SetAppearTooltipAtMouseX(true);
	eventRichListCtrl.SetSelectedSelTooltip(false);
	eventRichListCtrl.SetSelectable(false);
	eventRichListCtrl.SetTooltipType("L2PassAdvanceListTooltip");
	return;
}

function InitData()
{
	local int i;

	_eventInfoList.Length = 0;
	return;
}

function GlobalEventInfo MakeEventInfo(int eventIndex)
{
	local string titleStr, descStr;
	local GlobalEventInfo eventInfo;

	GetEventHtmlString(eventIndex, titleStr, descStr);
	eventInfo.Index = eventIndex;
	eventInfo.Title = titleStr;
	eventInfo.Desc = descStr;
	return eventInfo;
}

function UpdateEventInfoControls()
{
	local int i;
	local RichListCtrlRowData eventRowData;
	local GlobalEventInfo eventInfo;
	local string wndTitle, EventTitle, eventTooltip;
	local L2Util util;

	util = L2Util(GetScript("L2Util"));
	if((Me.IsShowWindow() == false))
	{
		return;
	}
	if(getInstanceUIData().GetIsClassicServer())
	{
		wndTitle = GetSystemString(3949);
	}
	else
	{
		wndTitle = GetSystemString(5004);
	}
	Me.SetWindowTitle(wndTitle);
	eventRichListCtrl.DeleteAllItem();
	eventRowData.cellDataList.Length = 2;
	i = 0;
	while((i < _eventInfoList.Length))
	{
		eventInfo = _eventInfoList[i];
		eventRowData.cellDataList[0].drawitems.Length = 0;
		eventRowData.cellDataList[1].drawitems.Length = 0;
		eventRowData.ForceRefreshTooltip = true;
		EventTitle = eventInfo.Title;
		eventTooltip = ((EventTitle $ "\\n") $ eventInfo.Desc);
		util.GetEllipsisString(EventTitle, 190);
		eventRowData.szReserved = eventTooltip;
		eventRowData.nReserved1 = INT64(0);
		AddRichListCtrlString(eventRowData.cellDataList[0].drawitems, EventTitle);
		AddRichListCtrlButton(eventRowData.cellDataList[1].drawitems, ("eventBtn_" $ string(eventInfo.Index)), 0, 0, "L2UI_NewTex.GlobalEventWnd.GlobalEventBtn_Normal", "L2UI_NewTex.GlobalEventWnd.GlobalEventBtn_Down", "L2UI_NewTex.GlobalEventWnd.GlobalEventBtn_Over", 64, 32);
		eventRichListCtrl.InsertRecord(eventRowData);
		++i;
	}
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

event OnShow()
{
	KillBtnDelayTimer();
	UpdateEventInfoControls();
	Me.SetFocus();
	eventRichListCtrl.SetScrollPosition(0);
	return;
}

event OnHide()
{
	KillBtnDelayTimer();
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(989));
	RegisterEvent(EV_PacketID(990));
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_PacketID(989):
			Nt_S_EX_INIT_GLOBAL_EVENT_UI();
			break;
		case EV_PacketID(990):
			Nt_S_EX_SHOW_GLOBAL_EVENT_UI();
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
		KillBtnDelayTimer();
	}
	return;
}

event OnClickButton(string Name)
{
	local int SelectedIndex;

	if((Left(Name, Len("eventBtn_")) == "eventBtn_"))
	{
		if((_isWaitingBtnDelay == false))
		{
			StartBtnDelayTimer();
			SelectedIndex = int(Right(Name, (Len(Name) - Len("eventBtn_"))));
			Rq_C_EX_SELECT_GLOBAL_EVENT_UI(SelectedIndex);
		}
	}
	return;
}

function Rq_C_EX_SELECT_GLOBAL_EVENT_UI(int eventIndex)
{
	local array<byte> stream;
	local UIPacket._C_EX_SELECT_GLOBAL_EVENT_UI packet;

	packet.nEventIndex = eventIndex;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_SELECT_GLOBAL_EVENT_UI(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(755, stream);
	return;
}

function Nt_S_EX_INIT_GLOBAL_EVENT_UI()
{
	local UIPacket._S_EX_INIT_GLOBAL_EVENT_UI packet;
	local int i;
	local GlobalEventInfo EventData;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_INIT_GLOBAL_EVENT_UI(packet))
	{
		return;
	}
	_eventInfoList.Length = 0;
	i = 0;
	while((i < packet.vEventList.Length))
	{
		EventData = MakeEventInfo(packet.vEventList[i]);
		if((Len(EventData.Title) > 0))
		{
			_eventInfoList[i] = EventData;
		}
		i++;
	}
	UpdateEventInfoControls();
	return;
}

function Nt_S_EX_SHOW_GLOBAL_EVENT_UI()
{
	Me.ShowWindow();
	return;
}

function StartBtnDelayTimer()
{
	_isWaitingBtnDelay = true;
	Me.SetTimer(1, 500);
	return;
}

function KillBtnDelayTimer()
{
	Me.KillTimer(1);
	_isWaitingBtnDelay = false;
	return;
}

event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="GlobalEventWnd"
}
