class GfxScreenMessage extends L2UIGFxScript
	dependson(UIPacket);

event OnRegisterEvent()
{
	RegisterGFxEvent(542);
	RegisterGFxEvent(11040);
	RegisterEvent((100000 + 830));
	RegisterEvent((100000 + 964));
	RegisterEvent((100000 + 920));
	RegisterEvent(11508);
	RegisterGFxEvent(40);
	RegisterEvent(14);
	return;
}

event OnLoad()
{
	RegisterState(getCurrentWindowName(string(self)), "GAMINGSTATE");
	RegisterState(getCurrentWindowName(string(self)), "COLLECTIONSTATE");
	RegisterState(getCurrentWindowName(string(self)), "ARENAPICKSTATE");
	RegisterState(getCurrentWindowName(string(self)), "ARENAGAMINGSTATE");
	RegisterState(getCurrentWindowName(string(self)), "ARENABATTLESTATE");
	RegisterState(getCurrentWindowName(string(self)), "OLYMPIADOBSERVERSTATE");
	SetDefaultShow(true);
	SetHavingFocus(false);
	return;
}

event OnFlashLoaded()
{
	SetAnchor("", ANCHORPOINT_BottomRight, ANCHORPOINT_TopLeft, 0, 0);
	SetRenderOnTop(true);
	SetAlwaysFullAlpha(true);
	IgnoreUIEvent(true);
	return;
}

event OnEvent(int Id, string param)
{
	switch(Id)
	{
		case (100000 + 830):
			HandleRaidDropItem();
			break;
		case (100000 + 964):
			HandleShopCraftLimitServerAnnounce();
			break;
		case 11508:
			Handle_CollectionReset(param);
			break;
		case 14:
			Handle_CollectionResetTest(param);
		default:
			break;
	}
	return;
}

event OnCallUCFunction(string functionName, string param)
{
	switch(functionName)
	{
		case "ShowFixedRearItemMessage":
			OnShowFixedRearItemMessage(param);
			break;
		case "ShowSpecialCraftMessage":
			ShowSpecialCraftMessage(param);
			break;
		default:
			break;
	}
	return;
}

function OnShowFixedRearItemMessage(string param)
{
	local string UserName, fromItemName, msgStr;
	local int SystemMsgID, ItemClassID;

	ParseString(param, "UserName", UserName);
	ParseString(param, "FromItemName", fromItemName);
	ParseInt(param, "ItemClassId", ItemClassID);
	if((UserName != ""))
	{
		SystemMsgID = 13662;
	}
	else
	{
		UserName = GetSystemString(13198);
		SystemMsgID = 13664;
	}
	msgStr = MakeFullSystemMsg(GetSystemMessage(SystemMsgID), UserName, fromItemName);
	Class'Interface.OnscreenEffectViewPortWnd'.static.Inst()._playEffectViewWithText(1.0000000, 1999.0000000, "LineageEffect2.ui_screen_message_flow", 0, 0, 0, -10, 0, 3000, 500, msgStr, L2Util(GetScript("L2Util")).White, GetItemInfoByClassID(ItemClassID), , true);
	return;
}

function ShowSpecialCraftMessage(string param)
{
	local string UserName, msgStr;
	local int SystemMsgID, ItemClassID;

	ParseString(param, "UserName", UserName);
	ParseInt(param, "ItemClassId", ItemClassID);
	if((UserName != ""))
	{
		SystemMsgID = 13176;
	}
	else
	{
		UserName = GetSystemString(13198);
		SystemMsgID = 13178;
	}
	msgStr = MakeFullSystemMsg(GetSystemMessage(SystemMsgID), UserName);
	Class'Interface.OnscreenEffectViewPortWnd'.static.Inst()._playEffectViewWithText(1.0000000, 1999.0000000, "LineageEffect2.ui_screen_message_flow", 0, 0, 0, -10, 0, 3000, 500, msgStr, L2Util(GetScript("L2Util")).White, GetItemInfoByClassID(ItemClassID), , true);
	return;
}

function HandleShopCraftLimitServerAnnounce()
{
	local string param;
	local UIPacket._S_EX_SERVERLIMIT_ITEM_ANNOUNCE packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_SERVERLIMIT_ITEM_ANNOUNCE(packet))
	{
		return;
	}
	param = "";
	ParamAdd(param, "Type", "6");
	ParamAdd(param, "UserName", packet.sUserName);
	ParamAdd(param, "ItemClassID", string(packet.nItemClassID));
	ParamAdd(param, "GetAmount", string(packet.nGetAmount));
	ParamAdd(param, "RemainAmount", string(packet.nRemainAmount));
	ParamAdd(param, "MaxAmount", string(packet.nMaxAmount));
	CallGFxFunction("GfxScreenMessage", "S_EX_SERVERLIMIT_ITEM_ANNOUNCE", param);
	AddSystemSERVERLIMITMessage(packet.sUserName, packet.nItemClassID, packet.nGetAmount, ((string(packet.nRemainAmount) $ "/") $ string(packet.nMaxAmount)));
	return;
}

function AddSystemSERVERLIMITMessage(string sUserName, int ItemClassID, INT64 getAmount, string amountString)
{
	local int msgInt;
	local string UserName, ItemName;

	if((sUserName != ""))
	{
		msgInt = 13440;
		UserName = sUserName;
	}
	else
	{
		msgInt = 13442;
		UserName = GetSystemString(13198);
	}
	ItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(Class'Interface.UICommonAPI'.static.GetItemID(ItemClassID));
	AddSystemMessageString(MakeFullSystemMsg(GetSystemMessage(msgInt), UserName, ((ItemName $ " x") $ string(getAmount)), amountString));
	return;
}

function HandleRaidDropItem()
{
	local UIPacket._S_EX_RAID_DROP_ITEM_ANNOUNCE packet;
	local string nickname, Name, Message, param;
	local int i;
	local string nameTotal;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_RAID_DROP_ITEM_ANNOUNCE(packet))
	{
		return;
	}
	if((packet.dropItemClassIds.Length == 0))
	{
		return;
	}
	nickname = Class'NWindow.UIDATA_NPC'.static.GetNPCNickName((packet.nNPCClassID - 1000000));
	Name = Class'NWindow.UIDATA_NPC'.static.GetNPCName((packet.nNPCClassID - 1000000));
	if((nickname == ""))
	{
		nameTotal = Name;
	}
	else
	{
		nameTotal = ((nickname @ "-") @ Name);
	}
	AddSystemMessageString(MakeFullSystemMsg(GetSystemMessage(13072), ConvertWorldIDToStr(packet.sLastAttackerName), nameTotal, GetDropItemNames(packet.dropItemClassIds)));
	Name = getInstanceL2Util().gfxHtmlAddText(Name, "#FFFFFF", "20");
	Message = MakeFullSystemMsg(GetSystemMessage(13073), ConvertWorldIDToStr(packet.sLastAttackerName), Name);
	Message = getInstanceL2Util().gfxHtmlAddText(Message, "#A09682", "20");
	param = "";
	ParamAdd(param, "Msg", Message);
	ParamAdd(param, "itemCount", string(packet.dropItemClassIds.Length));
	i = 0;
	while((i < packet.dropItemClassIds.Length))
	{
		ParamAdd(param, ("classID" $ string(i)), string(packet.dropItemClassIds[i]));
		i++;
	}
	ParamAdd(param, "type", "6");
	CallGFxFunction("GfxScreenMessage", "showMessage", param);
	return;
}

function Handle_CollectionResetTest(string param)
{
	local int Id;

	ParseInt(param, "id", Id);
	DisplayCollectionReset(Id);
	return;
}

function DisplayCollectionReset(int CollectionID)
{
	local CollectionData cData;
	local CollectionSystem collectionSystemScr;
	local string effectDesc;

	collectionSystemScr = CollectionSystem(GetScript("CollectionSystem"));
	if(!collectionSystemScr.API_GetCollectionData(CollectionID, cData))
	{
		return;
	}
	effectDesc = CollectionSystemSub(GetScript("CollectionSystem.CollectionSystemSub")).GetOptionByOptionID(cData.option_id);
	if((effectDesc == ""))
	{
		return;
	}
	AddSystemMessageString(MakeFullSystemMsg(GetSystemMessage(13416), cData.collection_name, effectDesc));
	getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(13691), cData.collection_name, effectDesc));
	return;
}

function Handle_CollectionReset(string param)
{
	local int nCollectionID;

	ParseInt(param, "CollectionID", nCollectionID);
	DisplayCollectionReset(nCollectionID);
	return;
}

function string GetDropItemNames(array<int> dropItemClassIds)
{
	local int i;
	local string ItemName, itenNameStrings;
	local ItemID Id;

	itenNameStrings = "";
	i = 0;
	while((i < dropItemClassIds.Length))
	{
		Id.ClassID = dropItemClassIds[i];
		ItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(Id);
		if((itenNameStrings != ""))
		{
			itenNameStrings = (itenNameStrings $ ", ");
		}
		itenNameStrings = (itenNameStrings $ ItemName);
		i++;
	}
	return itenNameStrings;
}

static function ItemInfo GetItemInfoByClassID(int Id)
{
	local ItemID cID;
	local ItemInfo Info;

	cID.ClassID = Id;
	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(cID, Info);
	return Info;
}

function showGfxScreenMessage(string Type, string Msg, string IconName, optional string TextColor)
{
	local string strParam;

	strParam = "";
	ParamAdd(strParam, "type", Type);
	ParamAdd(strParam, "Msg", Msg);
	ParamAdd(strParam, "iconName", IconName);
	if((TextColor != ""))
	{
		ParamAdd(strParam, "textColor", TextColor);
	}
	CallGFxFunction("GfxScreenMessage", "showMessage", strParam);
	return;
}

function showTestGfxScreenMessage(string Label, optional string labelIndex, optional string motionType, optional string Delay, optional string locY)
{
	local string strParam;

	strParam = "";
	ParamAdd(strParam, "Msg", "1");
	ParamAdd(strParam, "type", string(3));
	ParamAdd(strParam, "label", Label);
	ParamAdd(strParam, "labelIndex", labelIndex);
	ParamAdd(strParam, "motionType", motionType);
	ParamAdd(strParam, "delay", Delay);
	ParamAdd(strParam, "locY", locY);
	CallGFxFunction("GfxScreenMessage", "showMessage", strParam);
	return;
}
