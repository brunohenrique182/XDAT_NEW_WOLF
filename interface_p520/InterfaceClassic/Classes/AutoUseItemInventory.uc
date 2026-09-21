class AutoUseItemInventory extends UICommonAPI;

var WindowHandle Me;
var ButtonHandle CloseButton;
var TextBoxHandle Inventory_Title_TextBox;
var ItemWindowHandle InventoryItem_ItemWnd;
var InventoryWnd inventoryWndScript;
var WindowHandle ParentWindow;

event OnRegisterEvent()
{
	RegisterEvent(2610);
	RegisterEvent(2600);
	RegisterEvent(40);
	return;
}

event OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	syncInventoryByAll();
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("AutoUseItemInventory");
	CloseButton = GetButtonHandle("AutoUseItemInventory.CloseButton");
	Inventory_Title_TextBox = GetTextBoxHandle("AutoUseItemInventory.Inventory_Title_TextBox");
	InventoryItem_ItemWnd = GetItemWindowHandle("AutoUseItemInventory.InventoryItem_ItemWnd");
	inventoryWndScript = InventoryWnd(GetScript("inventoryWnd"));
	return;
}

event OnClickItem(string strID, int Index)
{
	local ItemInfo SelectItemInfo;
	local int SlotNum;

	InventoryItem_ItemWnd.GetItem(Index, SelectItemInfo);
	if((SelectItemInfo.Id.ClassID > 0))
	{
		SlotNum = AutoUseItemWnd(GetScript("AutoUseItemWnd")).getEmptySlotNum();
		Debug(("slotNum" @ string(SlotNum)));
		if((SlotNum > 0))
		{
			Class'NWindow.ShortcutWndAPI'.static.RequestRegisterShortcut(SlotNum, SelectItemInfo);
		}
	}
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "CloseButton":
			OnCloseButtonClick();
			break;
		default:
			break;
	}
	return;
}

function OnCloseButtonClick()
{
	Me.HideWindow();
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 2610:
		case 2600:
			syncInventory(param);
			break;
		case 40:
			InventoryItem_ItemWnd.Clear();
			break;
		default:
			break;
	}
	return;
}

function showWindowByParentWindow(WindowHandle pWnd, optional bool bToggleShow)
{
	ParentWindow = pWnd;
	getInstanceL2Util().windowAnchorToSide(pWnd, Me, 2, 0);
	if(!Me.IsShowWindow())
	{
		Me.ShowWindow();
		Me.SetFocus();
		pWnd.SetFocus();
	}
	else if(bToggleShow)
	{
		Me.HideWindow();
	}
	return;
}

function syncInventory(string param)
{
	local ItemInfo updatedItemInfo;
	local string Type;
	local int Index;

	if(!Me.IsShowWindow())
	{
		return;
	}
	ParamToItemInfo(param, updatedItemInfo);
	ParseString(param, "type", Type);
	if((int(Class'NWindow.UIDATA_ITEM'.static.GetAutomaticUseItemType(updatedItemInfo.Id.ClassID)) == 1))
	{
		Index = InventoryItem_ItemWnd.FindItemByClassID(updatedItemInfo.Id);
		switch(Type)
		{
			case "delete":
				if((Index > -1))
				{
					InventoryItem_ItemWnd.DeleteItem(Index);
				}
				break;
			default:
				SetShowItemCount(updatedItemInfo);
				if((Index > -1))
				{
					InventoryItem_ItemWnd.SetItem(Index, updatedItemInfo);
				}
				else
				{
					InventoryItem_ItemWnd.AddItem(updatedItemInfo);
				}
				break;
		}
	}
	return;
}

function syncInventoryByAll()
{
	local int i;
	local array<ItemInfo> itemarray;

	if(!Me.IsShowWindow())
	{
		return;
	}
	itemarray = inventoryWndScript.getInventoryAllItemArray(true);
	InventoryItem_ItemWnd.Clear();
	i = 0;
	while((i < itemarray.Length))
	{
		if((int(Class'NWindow.UIDATA_ITEM'.static.GetAutomaticUseItemType(itemarray[i].Id.ClassID)) == 1))
		{
			SetShowItemCount(itemarray[i]);
			InventoryItem_ItemWnd.AddItem(itemarray[i]);
		}
		i++;
	}
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}
