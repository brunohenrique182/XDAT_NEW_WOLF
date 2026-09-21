class L2UIInventoryObject extends UIEventManager;

var int Index;
//var delegate<DelegateOnAddItem> __DelegateOnAddItem__Delegate;
//var delegate<DelegateOnUpdateItem> __DelegateOnUpdateItem__Delegate;
//var delegate<DelegateOnDeletedItem> __DelegateOnDeletedItem__Delegate;
//var delegate<DelegateOnCompare> __DelegateOnCompare__Delegate;

delegate DelegateOnAddItem(optional ItemInfo iInfo, optional int Index)
{
	return;
}

delegate DelegateOnUpdateItem(optional ItemInfo iInfo, optional int Index)
{
	return;
}

delegate DelegateOnDeletedItem(optional ItemInfo iInfo, optional int Index)
{
	return;
}

delegate bool DelegateOnCompare(optional ItemInfo iInfo, optional int Index)
{

}
