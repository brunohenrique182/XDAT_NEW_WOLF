class L2UIInventoryObjectSimple extends UIEventManager;

var ItemID iID;
var int Index;
//var delegate<DelegateOnUpdateItem> __DelegateOnUpdateItem__Delegate;

delegate DelegateOnUpdateItem(optional array<ItemInfo> iInfo, optional int Index)
{
	return;
}

function setId(optional ItemID Id)
{
	iID = Id;
	return;
}
