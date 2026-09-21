class TeleportMapWnd extends L2UIGFxScript
	dependson(UIPacket);

var int _priceRacio;

function OnRegisterEvent()
{
	RegisterGFxEvent(12);
	RegisterGFxEvent(10231);
	RegisterEvent(20200);
	RegisterGFxEvent(11450);
	RegisterEvent((100000 + 1052));
	return;
}

function OnLoad()
{
	SetSaveWnd(true, false);
	AddState("GAMINGSTATE");
	SetContainerWindow("SkinnedWindow", 687);
	return;
}

function OnFlashLoaded()
{
	return;
}

function OnShow()
{
	return;
}

function OnEvent(int Event_ID, string param)
{
	if(true)
	{
		return;
	}
	switch(Event_ID)
	{
		case 20200:
			RQ_C_EX_Teleport_UI();
			break;
		case (100000 + 1052):
			Rs_S_EX_TELEPORT_UI();
			break;
		default:
			break;
	}
	return;
}

function Rs_S_EX_TELEPORT_UI()
{
	local UIPacket._S_EX_TELEPORT_UI packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_TELEPORT_UI(packet))
	{
		return;
	}
	_priceRacio = packet.nPriceRatio;
	Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("TeleportMapWnd");
	return;
}

function RQ_C_EX_Teleport_UI()
{
	local array<byte> stream;

	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(808, stream);
	return;
}
