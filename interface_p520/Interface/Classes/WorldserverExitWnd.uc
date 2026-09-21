class WorldserverExitWnd extends UICommonAPI;

var WindowHandle Me;
var string m_Windowname;
var L2Util util;

function Initialize()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	util = L2Util(GetScript("L2Util"));
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(150);
	return;
}

function OnLoad()
{
	Initialize();
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 150:
			if(IsPlayerOnWorldRaidServer())
			{
				if(getInstanceUIData().GetIsClassicServer())
				{
				}
			}
			break;
		default:
			break;
	}
	return;
}

function OnTimer(int TimerID)
{
	switch(TimerID)
	{
		default:
			return;
	}
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "WorldserverExit_Btn":
			API_C_EX_RETURN_TO_ORIGIN();
			break;
		default:
			break;
	}
	return;
}

function API_C_EX_RETURN_TO_ORIGIN()
{
	local array<byte> stream;

	Class'Interface.UIPacket'.static.RequestUIPacket(656, stream);
	Debug("C_EX_RETURN_TO_ORIGIN call 차원 사냥터 나가기");  // EN?: C_EX_return_TO_origin call Exit Dimensional Hunting Grounds
	return;
}

function ClearAll()
{
	return;
}
