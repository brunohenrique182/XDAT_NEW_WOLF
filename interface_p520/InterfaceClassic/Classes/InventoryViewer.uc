class InventoryViewer extends UICommonAPI;

struct InvenCountData
{
	var int curCnt;
	var int maxCnt;
};

var ItemWindowHandle totalInven_ItemWnd;
var int baseWidth;
var int BaseHeight;
var InventoryWnd inventoryWndScript;
var TextBoxHandle InvenoryCount;
var TextBoxHandle AdenaText;
var WindowHandle ParentWindow;
var ButtonHandle HelpButton;
var InvenCountData invenCountDatainfo;

function Initialize()
{
	totalInven_ItemWnd = GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".InventoryItem_ItemWnd"));
	InvenoryCount = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".InventoryCount_TextBox"));
	AdenaText = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AdenaText"));
	HelpButton = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HelpButton"));
	inventoryWndScript = InventoryWnd(GetScript("inventoryWnd"));
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(2570);
	RegisterEvent(9570);
	RegisterEvent(2070);
	RegisterEvent(2610);
	return;
}

event OnLoad()
{
	Initialize();
	return;
}

event OnLButtonDown(WindowHandle a_WindowHandle, int nX, int nY)
{
	ParentWindow.SetFocus();
	m_hOwnerWnd.SetFocus();
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 9570:
			HandleEV_AdenaInvenCount(param);
			break;
		case 2070:
			HandleEV_SetMaxCount(param);
			break;
		case 2570:
			totalInven_ItemWnd.Clear();
			break;
		case 2610:
			HandleUpdateItem(param);
			break;
		default:
			break;
	}
	return;
}

event OnShow()
{
	SetAdenaText();
	SetItemCount();
	syncInventory();
	return;
}

event OnSetFocus(WindowHandle focusedWnd, bool bFocused)
{
	ParentWindow.GetScript().OnSetFocus(focusedWnd, bFocused);
	return;
}

event OnClickButton(string strID)
{
	if((strID == "CloseButton"))
	{
		m_hOwnerWnd.HideWindow();
	}
	return;
}

event OnTick()
{
	HandleOnTick();
	return;
}

function HandleOnTick()
{
	syncInventory();
	m_hOwnerWnd.DisableTick();
	return;
}

function ValidateInventoryAdd()
{
	m_hOwnerWnd.EnableTick();
	return;
}

function HandleUpdateItem(string param)
{
	local string Type;

	ParseString(param, "type", Type);
	if((Type == "add"))
	{
		ValidateInventoryAdd();
		SetItemCount();
		return;
	}
	else if((Type == "update"))
	{
		UpdateItem(param);
	}
	else if((Type == "delete"))
	{
		DeleteItem(param);
		SetItemCount();
	}
	return;
}

function UpdateItem(string param)
{
	local int Index;
	local ItemInfo iInfo;

	ParamToItemInfo(param, iInfo);
	Index = totalInven_ItemWnd.FindItem(iInfo.Id);
	if(iInfo.bEquipped)
	{
		iInfo.ForeTexture = "L2UI_CT1.Icon.WearPanel";
	}
	SetShowItemCount(iInfo);
	totalInven_ItemWnd.SetItem(Index, iInfo);
	return;
}

function DeleteItem(string param)
{
	local int Index;
	local ItemInfo iInfo, kClearItem;

	kClearItem.IconName = "L2ui_ct1.emptyBtn";
	ClearItemID(kClearItem.Id);
	ParamToItemInfo(param, iInfo);
	Index = totalInven_ItemWnd.FindItem(iInfo.Id);
	if((Index < 0))
	{
		return;
	}
	totalInven_ItemWnd.DeleteItem(Index);
	totalInven_ItemWnd.AddItem(kClearItem);
	return;
}

function HandleEV_AdenaInvenCount(string param)
{
	local int curCnt;

	SetAdenaText();
	ParseInt(param, "InvenCount", curCnt);
	if((invenCountDatainfo.curCnt == curCnt))
	{
		return;
	}
	invenCountDatainfo.curCnt = curCnt;
	if(!m_hOwnerWnd.IsShowWindow())
	{
		return;
	}
	SetItemCount();
	return;
}

function HandleEV_SetMaxCount(string param)
{
	local int maxCnt;

	ParseInt(param, "Inventory", maxCnt);
	if((invenCountDatainfo.maxCnt == maxCnt))
	{
		return;
	}
	invenCountDatainfo.maxCnt = maxCnt;
	if(!m_hOwnerWnd.IsShowWindow())
	{
		return;
	}
	SetItemCount();
	syncInventory();
	return;
}

function syncInventory()
{
	local int i;
	local ItemInfo kClearItem;
	local array<ItemInfo> itemarray, equipItemArray;

	kClearItem.IconName = "L2ui_ct1.emptyBtn";
	ClearItemID(kClearItem.Id);
	itemarray = getInstanceL2Util().SortItemArray(inventoryWndScript.getInventoryAllItemArray(true));
	equipItemArray = getInstanceL2Util().SortItemArray(inventoryWndScript.getInventoryEquipItemArray());
	i = 0;
	while((i < equipItemArray.Length))
	{
		equipItemArray[i].ForeTexture = "L2UI_CT1.Icon.WearPanel";
		SetShowItemCount(equipItemArray[i]);
		totalInven_ItemWnd.SetItem(i, equipItemArray[i]);
		i++;
	}
	i = 0;
	while((i < itemarray.Length))
	{
		SetShowItemCount(itemarray[i]);
		totalInven_ItemWnd.SetItem((i + equipItemArray.Length), itemarray[i]);
		i++;
	}
	i = (equipItemArray.Length + itemarray.Length);
	while((i < inventoryWndScript.GetMyInventoryLimit()))
	{
		totalInven_ItemWnd.SetItem(i, kClearItem);
		i++;
	}
	return;
}

function SetItemCount()
{
	InvenoryCount.SetText((((("(" $ string(invenCountDatainfo.curCnt)) $ "/") $ string(invenCountDatainfo.maxCnt)) $ ")"));
	getInstanceL2Util().ItemboxUpdate(totalInven_ItemWnd, invenCountDatainfo.maxCnt);
	if(HelpButton.IsShowWindow())
	{
		HelpButton.HideWindow();
	}
	return;
}

function SetAdenaText()
{
	local string Adenastring;

	Adenastring = string(GetAdena());
	AdenaText.SetText(MakeCostString(Adenastring));
	AdenaText.SetTooltipString(ConvertNumToText(Adenastring));
	return;
}

function showWindowByParentWindow(WindowHandle pWnd, optional bool bToggleShow)
{
	ParentWindow = pWnd;
	getInstanceL2Util().windowAnchorToSide(pWnd, m_hOwnerWnd, 2, 29);
	if(!m_hOwnerWnd.IsShowWindow())
	{
		m_hOwnerWnd.ShowWindow();
		m_hOwnerWnd.SetFocus();
		pWnd.SetFocus();
	}
	else if(bToggleShow)
	{
		m_hOwnerWnd.HideWindow();
	}
	return;
}
