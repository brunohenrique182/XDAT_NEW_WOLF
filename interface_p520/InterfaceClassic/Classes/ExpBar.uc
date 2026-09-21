class ExpBar extends L2UIGFxScript
	dependson(UIPacket);

struct _S_EX_USER_BOOST_STAT
{
	var int Type;
	var int Count;
	var int Percent;
};

function OnRegisterEvent()
{
	if(true)
	{
		return;
	}
	RegisterGFxEvent(180);
	RegisterGFxEvent(9750);
	RegisterGFxEvent(40);
	RegisterGFxEvent(9550);
	RegisterGFxEvent(9560);
	RegisterGFxEvent(9570);
	RegisterGFxEvent(2070);
	RegisterGFxEvent(320);
	RegisterGFxEvent(10450);
	RegisterGFxEvent(420);
	RegisterGFxEvent(10470);
	RegisterGFxEvent(8000);
	RegisterGFxEvent(11060);
	RegisterGFxEvent(1910);
	RegisterEvent((100000 + 843));
	RegisterGFxEvent(11030);
	RegisterGFxEvent(5720);
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
		case 9750:
			break;
		case EV_PacketID(843):
			ParsePacket_S_EX_USER_BOOST_STAT();
			break;
		default:
			break;
	}
	return;
}

function ParsePacket_S_EX_USER_BOOST_STAT()
{
	local UIPacket._S_EX_USER_BOOST_STAT packet;
	local string strParam;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_USER_BOOST_STAT(packet))
	{
		return;
	}
	ParamAdd(strParam, "type", string(packet.Type));
	ParamAdd(strParam, "count", string(packet.Count));
	ParamAdd(strParam, "percent", string(packet.Percent));
	CallGFxFunction("ExpBar", "S_EX_USER_BOOST_STAT", strParam);
	return;
}

function OnCallUCFunction(string functionName, string param)
{
	switch(functionName)
	{
		case "LCoin":
			HandleToggleShowShopDailyWnd();
			break;
		case "PcCafe":
			HandleToggleShowPCCafeCommuniWnd();
			break;
		case "einhasad":
			HandleToggleShowShopDailyWnd();
			break;
		default:
			break;
	}
	return;
}

function HandleToggleShowPCCafeCommuniWnd()
{
	if(getInstanceL2Util().getIsPrologueGrowType())
	{
		AddSystemMessage(4533);
	}
	else if(GetWindowHandle("NPCDialogWnd").IsShowWindow())
	{
		GetWindowHandle("NPCDialogWnd").HideWindow();
	}
	else
	{
		RequestOpenWndWithoutNPC(OPEN_PCCAFE_HTML);
	}
	return;
}

function HandleToggleShowShopDailyWnd()
{
	getInstanceL2Util().toggleWindow("ShopLcoinWnd", true, true);
	return;
}

function OnLoad()
{
	if(true)
	{
		return;
	}
	AddState("GAMINGSTATE");
	AddState("ARENAGAMINGSTATE");
	AddState("ARENABATTLESTATE");
	AddState("ARENAPICKSTATE");
	SetContainerHUD("none", 0);
	SetDefaultShow(true);
	SetHavingFocus(false);
	SetHUD();
	return;
}
