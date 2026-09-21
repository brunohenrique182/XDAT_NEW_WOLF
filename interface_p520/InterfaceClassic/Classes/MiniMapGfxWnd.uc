class MiniMapGfxWnd extends L2UIGFxScript
	dependson(UIPacket);

var string tmpCurrentTelCost;

event OnRegisterEvent()
{
	RegisterGFxEventForLoaded(40);
	RegisterGFxEventForLoaded(1840);
	RegisterGFxEvent(1780);
	RegisterGFxEvent(2420);
	RegisterGFxEvent(1840);
	RegisterGFxEvent(1890);
	RegisterGFxEvent(1140);
	RegisterGFxEvent(1150);
	RegisterGFxEvent(1160);
	RegisterGFxEvent(1170);
	RegisterGFxEvent(3410);
	RegisterGFxEvent(3150);
	RegisterGFxEvent(3170);
	RegisterGFxEvent(10180);
	RegisterGFxEvent(4200);
	RegisterGFxEvent(10182);
	RegisterGFxEvent(10183);
	RegisterGFxEvent(11110);
	RegisterGFxEvent(1860);
	RegisterGFxEvent(10181);
	RegisterGFxEvent(5860);
	RegisterGFxEvent(10080);
	RegisterGFxEvent(11390);
	RegisterGFxEvent(3511);
	RegisterGFxEvent(20440);
	RegisterEvent(1520);
	RegisterEvent((100000 + 835));
	RegisterEvent(180);
	return;
}

event OnLoad()
{
	SetSaveWnd(true, true);
	AddState("GAMINGSTATE");
	AddState("PAWNVIEWERSTATE");
	SetContainerWindow("SimpleNoBgNoDrag", 447);
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 1520:
			HandleArriveShowQuest(param);
			break;
		case (100000 + 835):
			ParsePacket_S_EX_RAID_TELEPORT_INFO();
			break;
		case 180:
			HandleUpdateUserInfo();
			break;
		default:
			break;
	}
	return;
}

function HandleArriveShowQuest(string param)
{
	local int Level, RecentlyAddedQuestID;
	local string strParam, strTargetName;
	local Vector vTargetPos;

	ParseInt(param, "QuestID", RecentlyAddedQuestID);
	ParseInt(param, "QuestLevel", Level);
	if(((RecentlyAddedQuestID > 0) && (Level > 0)))
	{
		strTargetName = Class'NWindow.UIDATA_QUEST'.static.GetTargetName(RecentlyAddedQuestID, Level);
		vTargetPos = Class'NWindow.UIDATA_QUEST'.static.GetTargetLoc(RecentlyAddedQuestID, Level);
		ParamAdd(strParam, "X", string(vTargetPos.X));
		ParamAdd(strParam, "Y", string(vTargetPos.Y));
		ParamAdd(strParam, "Z", string(vTargetPos.Z));
		ParamAdd(strParam, "targetName", strTargetName);
		ParamAdd(strParam, "QuestID", string(RecentlyAddedQuestID));
		ParamAdd(strParam, "QuestLevel", string(Level));
		ParamAdd(strParam, "questName", Class'NWindow.UIDATA_QUEST'.static.GetQuestName(RecentlyAddedQuestID, Level));
		CallGFxFunction("MiniMapGfxWnd", "showQuestTargetInfo", strParam);
	}
	return;
}

event OnCallUCFunction(string functionName, string param)
{
	switch(functionName)
	{
		case "ucExecuteCommand":
			if((param != ""))
			{
				ExecuteCommand(param);
			}
			break;
		case "C_EX_RAID_TELEPORT_INFO":
			API_C_EX_RAID_TELEPORT_INFO();
			break;
		case "C_EX_TELEPORT_TO_RAID_POSITION":
			API_C_EX_TELEPORT_TO_RAID_POSITION(int(param));
			break;
		case "MinimapGfxWnd show popup":
			HandleShowTeleportPopup(param);
			break;
		default:
			break;
	}
	return;
}

event OnShow()
{
	RQ_C_EX_Teleport_UI();
	return;
}

function RQ_C_EX_Teleport_UI()
{
	if(API_IsInDethrone())
	{
		return;
	}
	if(API_IsPlayerOnWorldRaidServer())
	{
		return;
	}
	Class'InterfaceClassic.TeleportWnd'.static.Inst().RQ_C_EX_Teleport_UI();
	return;
}

function ParsePacket_S_EX_RAID_TELEPORT_INFO()
{
	local UIPacket._S_EX_RAID_TELEPORT_INFO packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_RAID_TELEPORT_INFO(packet))
	{
		return;
	}
	CallGFxFunction("MiniMapGfxWnd", "S_EX_RAID_TELEPORT_INFO", string(packet.nUsedFreeCount));
	return;
}

function bool API_IsInDethrone()
{
	return Class'NWindow.UIDATA_PLAYER'.static.IsInDethrone();
}

function bool API_IsPlayerOnWorldRaidServer()
{
	return IsPlayerOnWorldRaidServer();
}

function API_C_EX_RAID_TELEPORT_INFO()
{
	local array<byte> stream;
	local UIPacket._C_EX_RAID_TELEPORT_INFO packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_RAID_TELEPORT_INFO(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(617, stream);
	return;
}

function API_C_EX_TELEPORT_TO_RAID_POSITION(int nRaidID)
{
	local array<byte> stream;
	local UIPacket._C_EX_TELEPORT_TO_RAID_POSITION packet;

	packet.nRaidID = nRaidID;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_TELEPORT_TO_RAID_POSITION(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(618, stream);
	return;
}

function HandleUpdateUserInfo()
{
	if((getInstanceUIData().IsLevelUP() || getInstanceUIData().IsLevelDown()))
	{
		CallGFxFunction("MiniMapGfxWnd", "LevelChanged", "");
	}
	return;
}

function HandleShowTeleportPopup(string param)
{
	local array<string> priceInfo;

	if(Class'NWindow.UIDATA_PLAYER'.static.IsInPrison())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13773));
		tmpCurrentTelCost = "-1";
		return;
	}
	Split(param, "|", priceInfo);
	tmpCurrentTelCost = string(Class'InterfaceClassic.TeleportWnd'.static.Inst().GetTeleportCost(INT64(priceInfo[0]), int(priceInfo[1]), int(priceInfo[2])));
	return;
}
