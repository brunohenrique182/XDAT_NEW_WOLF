class DethroneFireStateWnd extends UICommonAPI
	dependson(UIPacket);

const TIMER_ID_ELAPSED_TIME = 1;
const TIMER_ELAPSED_DELAY_TIME = 1000;
const TILE_LIST_COLUMN = 4;
const TILE_LIST_ROW = 1;
const ITEM_ID_PERSONAL_POINT = 82499;
const ITEM_ID_SERVER_POINT = 82659;
const ITEM_ID_PRIMAL_FIRE_POINT = 82609;

var array<UIPacket._HolyFire> _infos;
var int _uiElapsedTimeCount;
var WindowHandle Me;
var WindowHandle ScrollAreaWnd;
var WindowHandle disableWnd;
var WindowHandle UIControlDialogAsset;
var array<DethroneFireStateItemObject> rendererObjectList;
var UIControlTilelist scrollTileList;

function Initialize()
{
	InitControls();
	scrollTileList._SetTileListItemNumTotal(4);
	return;
}

function InitControls()
{
	local int i;
	local WindowHandle itemRendererWnd;
	local DethroneFireStateItemObject itemObject;

	Me = GetWindowHandle("DethroneFireStateWnd");
	ScrollAreaWnd = GetWindowHandle("DethroneFireStateWnd.ScrollAreaWnd");
	scrollTileList = Class'InterfaceClassic.UIControlTilelist'.static.InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ScrollAreaWnd")), 4, 1, true);
	scrollTileList.DelegateOnItemRenderer = HandleDelegateOnItemRenderer;
	scrollTileList._SetUsePage(true);
	rendererObjectList.Length = 0;
	i = 0;
	while((i < 4))
	{
		itemRendererWnd = GetWindowHandle(scrollTileList._GetRendererPath(i));
		itemObject = new Class'InterfaceClassic.DethroneFireStateItemObject';
		itemObject.Init(itemRendererWnd);
		rendererObjectList[rendererObjectList.Length] = itemObject;
		i++;
	}
	return;
}

function ResetInfo()
{
	local int i;

	_infos.Length = 0;
	_uiElapsedTimeCount = 0;
	i = 0;
	while((i < rendererObjectList.Length))
	{
		rendererObjectList[i].ResetInfo();
		i++;
	}
	return;
}

function StartElapsedTimer()
{
	KillElapsedTimer();
	Me.SetTimer(1, 1000);
	return;
}

function KillElapsedTimer()
{
	Me.KillTimer(1);
	return;
}

function HandleDelegateOnItemRenderer(string itemRendererID, int rendererIndex, int Position)
{
	local DethroneFireStateItemObject rendererObject;

	rendererObject = rendererObjectList[rendererIndex];
	if((Position < _infos.Length))
	{
		rendererObject.SetInfo(_infos[Position], _uiElapsedTimeCount);
		rendererObject.Me.ShowWindow();
	}
	else
	{
		rendererObject.ResetInfo();
		rendererObject.Me.HideWindow();
	}
	return;
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "WindowHelp_BTN":
			Class'InterfaceClassic.HelpWnd'.static.ShowHelp(63, 6);
			break;
		default:
			break;
	}
	return;
}

function Rq_C_EX_HOLY_FIRE_OPEN_UI()
{
	local array<byte> stream;

	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(844, stream);
	return;
}

function Rs_S_EX_HOLY_FIRE_OPEN_UI()
{
	local UIPacket._S_EX_HOLY_FIRE_OPEN_UI packet;
	local UIPacket._ItemInfo itemStruct;
	local int i;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_HOLY_FIRE_OPEN_UI(packet))
	{
		return;
	}
	scrollTileList._SetTileListItemNumTotal(packet.infos.Length);
	i = 0;
	while((i < packet.infos.Length))
	{
		if((packet.infos[i].nRewardPersonalPoint > 0))
		{
			itemStruct.nItemClassID = 82499;
			itemStruct.nAmount = INT64(packet.infos[i].nRewardPersonalPoint);
			packet.infos[i].rewards[packet.infos[i].rewards.Length] = itemStruct;
		}
		if((packet.infos[i].nRewardServerPoint > 0))
		{
			itemStruct.nItemClassID = 82659;
			itemStruct.nAmount = INT64(packet.infos[i].nRewardServerPoint);
			packet.infos[i].rewards[packet.infos[i].rewards.Length] = itemStruct;
		}
		if((packet.infos[i].nRewardPrimalFirePoint > 0))
		{
			itemStruct.nItemClassID = 82609;
			itemStruct.nAmount = INT64(packet.infos[i].nRewardPrimalFirePoint);
			packet.infos[i].rewards[packet.infos[i].rewards.Length] = itemStruct;
		}
		i++;
	}
	_uiElapsedTimeCount = 0;
	StartElapsedTimer();
	_infos = packet.infos;
	scrollTileList._Refresh();
	if((Me.IsShowWindow() == false))
	{
		Me.ShowWindow();
		Me.SetFocus();
	}
	return;
}

function Nt_S_EX_HOLY_FIRE_NOTIFY()
{
	Debug("Rs_S_EX_HOLY_FIRE_NOTIFY");
	if(Me.IsShowWindow())
	{
		Rq_C_EX_HOLY_FIRE_OPEN_UI();
	}
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(1095));
	RegisterEvent(EV_PacketID(1096));
	return;
}

function OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case EV_PacketID(1095):
			Rs_S_EX_HOLY_FIRE_OPEN_UI();
			break;
		case EV_PacketID(1096):
			Nt_S_EX_HOLY_FIRE_NOTIFY();
			break;
		default:
			break;
	}
	return;
}

event OnHide()
{
	ResetInfo();
	KillElapsedTimer();
	return;
}

event OnTimer(int TimerID)
{
	if((TimerID == 1))
	{
		_uiElapsedTimeCount++;
		scrollTileList._Refresh();
	}
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("DethroneFireStateWnd").HideWindow();
	return;
}
