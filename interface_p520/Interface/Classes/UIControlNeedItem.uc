class UIControlNeedItem extends UICommonAPI;

var WindowHandle Me;
var string m_Windowname;
var ItemWindowHandle item;
var TextBoxHandle text0;
var TextBoxHandle text1;
var TextBoxHandle text2;
var INT64 numItem;
var INT64 numNeed;
var INT64 numMine;
var L2UIInventoryObjectSimple iObject;
//var delegate<DelegateItemUpdate> __DelegateItemUpdate__Delegate;

delegate DelegateItemUpdate(UIControlNeedItem Script)
{
	return;
}

function Init(string WindowName)
{
	m_Windowname = WindowName;
	Me = GetWindowHandle(m_Windowname);
	Me.ShowWindow();
	item = GetItemWindowHandle((WindowName $ ".item"));
	text0 = GetTextBoxHandle((WindowName $ ".text0"));
	text1 = GetTextBoxHandle((WindowName $ ".text1"));
	text2 = GetTextBoxHandle((WindowName $ ".text2"));
	item.Clear();
	text2.SetAnchor((WindowName $ ".text1"), "TopRight", "TopLeft", 0, 0);
	text0.SetText("");
	text1.SetText("");
	text2.SetText("");
	numItem = INT64(1);
	return;
}

function HandleItemListner(array<ItemInfo> iInfos, optional int Index)
{
	SetNumMine(iInfos[0].ItemNum);
	DelegateItemUpdate(self);
	return;
}

function ItemID GetID()
{
	local ItemInfo iInfo;

	iInfo = GetItemInfo();
	return iInfo.Id;
}

function ItemInfo GetItemInfo()
{
	local ItemInfo iInfo;

	item.GetItem(0, iInfo);
	return iInfo;
}

function setId(ItemID iID)
{
	local ItemInfo iInfo;
	local array<ItemInfo> iInfos;

	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(iID, iInfo);
	item.Clear();
	item.AddItem(iInfo);
	if((iObject == none))
	{
		iObject = AddItemListenerSimple(iID.ClassID, iID.ServerID);
		iObject.DelegateOnUpdateItem = HandleItemListner;
	}
	else
	{
		iObject.setId(iID);
	}
	text0.SetText(Class'NWindow.UIDATA_ITEM'.static.GetItemName(iID));
	Class'NWindow.UIDATA_INVENTORY'.static.FindItemByClassID(iID.ClassID, iInfos);
	SetNumMine(iInfos[0].ItemNum);
	return;
}

function MakeDotString()
{
	local string tempstring;
	local int nRectWidth;

	tempstring = text0.GetText();
	if((Len(tempstring) > 0))
	{
		nRectWidth = text0.GetRect().nWidth;
		text0.SetText(makeShortStringByPixel(tempstring, (nRectWidth - 40), ".."));
	}
	return;
}

function RemoveInventoryObject()
{
	RemObjectSimpleByObject(iObject);
	iObject = none;
	return;
}

function SetNumItem(INT64 Num)
{
	if((Num < INT64(1)))
	{
		Num = INT64(1);
	}
	numItem = Num;
	SetNumNeed((Num * numNeed));
	return;
}

function SetNumNeed(INT64 Num)
{
	numNeed = Num;
	text1.SetText(("x" $ MakeCostStringINT64((numNeed * numItem))));
	HandleTextColor();
	return;
}

function SetNumMine(INT64 Num)
{
	numMine = Num;
	text2.SetText((("(" $ MakeCostStringINT64(numMine)) $ ")"));
	HandleTextColor();
	return;
}

function HandleTextColor()
{
	if(canBuy())
	{
		text2.SetTextColor(getInstanceL2Util().BLUE01);
	}
	else
	{
		text2.SetTextColor(getInstanceL2Util().DRed);
	}
	return;
}

function bool canBuy()
{
	return (numMine >= (numNeed * numItem));
}
