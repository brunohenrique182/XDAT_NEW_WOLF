class L2UIInventoryObjectFindByCompare extends UIEventManager;

//var delegate<DelegateCompare> __DelegateCompare__Delegate;

delegate bool DelegateCompare(optional ItemInfo iInfos)
{

}

function array<ItemInfo> GetAllItemByCompare()
{
	local int i;
	local array<ItemInfo> iInfos, newiInfos;

	Class'NWindow.UIDATA_INVENTORY'.static.GetAllItem(iInfos);
	i = 0;
	while((i < iInfos.Length))
	{
		if(DelegateCompare(iInfos[i]))
		{
			newiInfos[newiInfos.Length] = iInfos[i];
		}
		i++;
	}
	return newiInfos;
}

function array<ItemInfo> GetAllInvenItemByCompare()
{
	local int i;
	local array<ItemInfo> iInfos, newiInfos;

	Class'NWindow.UIDATA_INVENTORY'.static.GetAllInvenItem(iInfos);
	i = 0;
	while((i < iInfos.Length))
	{
		if(DelegateCompare(iInfos[i]))
		{
			newiInfos[newiInfos.Length] = iInfos[i];
		}
		i++;
	}
	return newiInfos;
}

function array<ItemInfo> GetAllInvenItemAndArtifactItemAndQuestByCompare()
{
	local int i;
	local array<ItemInfo> iInfos, newiInfos;

	Class'NWindow.UIDATA_INVENTORY'.static.GetAllInvenItem(iInfos);
	i = 0;
	while((i < iInfos.Length))
	{
		if(DelegateCompare(iInfos[i]))
		{
			newiInfos[newiInfos.Length] = iInfos[i];
		}
		i++;
	}
	Class'NWindow.UIDATA_INVENTORY'.static.GetAllArtifactItem(iInfos);
	i = 0;
	while((i < iInfos.Length))
	{
		if(DelegateCompare(iInfos[i]))
		{
			newiInfos[newiInfos.Length] = iInfos[i];
		}
		i++;
	}
	Class'NWindow.UIDATA_INVENTORY'.static.GetAllQuestItem(iInfos);
	i = 0;
	while((i < iInfos.Length))
	{
		if(DelegateCompare(iInfos[i]))
		{
			newiInfos[newiInfos.Length] = iInfos[i];
		}
		i++;
	}
	return newiInfos;
}
