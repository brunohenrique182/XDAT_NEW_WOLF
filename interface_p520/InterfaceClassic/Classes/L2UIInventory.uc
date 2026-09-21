class L2UIInventory extends UIScript;

var array<L2UIInventoryObject> inventoryObjects;
var array<L2UIInventoryObjectSimple> inventoryObjectsSimple;
var L2UIInventoryObjectFindByCompare L2UIInventoryFindByCompare;

static function L2UIInventory Inst()
{
	return L2UIInventory(GetScript("L2UIInventory"));
}

function OnLoad()
{
	L2UIInventoryFindByCompare = new Class'InterfaceClassic.L2UIInventoryObjectFindByCompare';
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(2610);
	RegisterEvent(9570);
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 2610:
			HandleUpdateItem(param);
			break;
		case 9570:
			HandleAdenaInevenCount(param);
		default:
			break;
	}
	return;
}

function HandleAdenaInevenCount(string param)
{
	local array<ItemInfo> iInfos;
	local int i;

	i = 0;
	while((i < inventoryObjectsSimple.Length))
	{
		iInfos.Length = 0;
		FindItem(inventoryObjectsSimple[i].iID, iInfos);
		if((inventoryObjectsSimple[i].iID.ClassID > 0))
		{
			inventoryObjectsSimple[i].DelegateOnUpdateItem(iInfos, inventoryObjectsSimple[i].Index);
		}
		i++;
	}
	return;
}

function L2UIInventoryObjectSimple NewObjectSimple(int ClassID, optional int ServerID, optional int Index)
{
	local int Len;

	Len = inventoryObjectsSimple.Length;
	inventoryObjectsSimple[Len] = new Class'InterfaceClassic.L2UIInventoryObjectSimple';
	inventoryObjectsSimple[Len].iID.ClassID = ClassID;
	inventoryObjectsSimple[Len].iID.ServerID = ServerID;
	inventoryObjectsSimple[Len].Index = Index;
	return inventoryObjectsSimple[Len];
}

function RemObjectSimpleByObject(L2UIInventoryObjectSimple iObject)
{
	local int i;

	i = 0;
	while((i < inventoryObjectsSimple.Length))
	{
		if((iObject == inventoryObjectsSimple[i]))
		{
			inventoryObjectsSimple.Remove(i, 1);
			return;
		}
		i++;
	}
	return;
}

function RemObjectSimple(int ClassID, optional int ServerID)
{
	local int i;

	i = 0;
	while((i < inventoryObjectsSimple.Length))
	{
		if(((inventoryObjectsSimple[i].iID.ClassID == ClassID) && (inventoryObjectsSimple[i].iID.ServerID == ServerID)))
		{
			inventoryObjectsSimple.Remove(i, 1);
			return;
		}
		i++;
	}
	return;
}

function HandleUpdateItem(string param)
{
	local int i;
	local ItemInfo iInfo;
	local string Type;

	ParseString(param, "type", Type);
	ParamToItemInfo(param, iInfo);
	i = 0;
	while((i < inventoryObjects.Length))
	{
		if(!inventoryObjects[i].DelegateOnCompare(iInfo, inventoryObjects[i].Index))
		{
			i++;
			continue;
		}
		switch(Type)
		{
			case "add":
				inventoryObjects[i].DelegateOnAddItem(iInfo, inventoryObjects[i].Index);
				break;
			case "update":
				inventoryObjects[i].DelegateOnUpdateItem(iInfo, inventoryObjects[i].Index);
				break;
			case "delete":
				inventoryObjects[i].DelegateOnDeletedItem(iInfo, inventoryObjects[i].Index);
				break;
			default:
				break;
		}
		i++;
	}
	return;
}

function L2UIInventoryObject NewObject()
{
	inventoryObjects[inventoryObjects.Length] = new Class'InterfaceClassic.L2UIInventoryObject';
	return inventoryObjects[(inventoryObjects.Length - 1)];
}

function bool _IsPeroidicItem(ItemInfo iInfo)
{
	if((iInfo.nDBDeleteDate != INT64(0)))
	{
		return true;
	}
	return (iInfo.CurrentPeriod != -9999);
}

function bool FindItem(ItemID Id, out array<ItemInfo> iInfos)
{
	local ItemInfo iInfo;

	iInfos.Length = 0;
	if((Id.ServerID > 0))
	{
		Class'NWindow.UIDATA_INVENTORY'.static.FindItem(Id.ServerID, iInfo);
		iInfos[0] = iInfo;
	}
	else
	{
		Class'NWindow.UIDATA_INVENTORY'.static.FindItemByClassID(Id.ClassID, iInfos);
	}
	return (iInfos.Length > 0);
}
