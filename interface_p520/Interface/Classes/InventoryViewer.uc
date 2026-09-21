class InventoryViewer extends UICommonAPI;

var WindowHandle Me;
var ItemWindowHandle totalInven_ItemWnd;
var int baseWidth;
var int BaseHeight;
var InventoryWnd inventoryWndScript;
var TextBoxHandle InvenoryCount;
var TextBoxHandle AdenaText;
var WindowHandle ParentWindow;
var ButtonHandle HelpButton;

function OnRegisterEvent()
{
	RegisterEvent(2570);
	RegisterEvent(9570);
	RegisterEvent(2070);
	return;
}

function OnLoad()
{
	Initialize();
	return;
}

function Initialize()
{
	Me = GetWindowHandle(getCurrentWindowName(string(self)));
	totalInven_ItemWnd = GetItemWindowHandle((getCurrentWindowName(string(self)) $ ".InventoryItem_ItemWnd"));
	InvenoryCount = GetTextBoxHandle((getCurrentWindowName(string(self)) $ ".InventoryCount_TextBox"));
	AdenaText = GetTextBoxHandle((getCurrentWindowName(string(self)) $ ".AdenaText"));
	HelpButton = GetButtonHandle((getCurrentWindowName(string(self)) $ ".HelpButton"));
	inventoryWndScript = InventoryWnd(GetScript("inventoryWnd"));
	return;
}

function OnDefaultPosition()
{
	return;
}

function OnLButtonDown(WindowHandle a_WindowHandle, int nX, int nY)
{
	ParentWindow.SetFocus();
	Me.SetFocus();
	return;
}

function showWindowByParentWindow(WindowHandle pWnd, optional bool bToggleShow)
{
	ParentWindow = pWnd;
	getInstanceL2Util().windowAnchorToSide(pWnd, Me, 2, 29);
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

function SetAdenaText()
{
	local string Adenastring;

	Adenastring = MakeCostString(string(GetAdena()));
	AdenaText.SetText(Adenastring);
	AdenaText.SetTooltipString(ConvertNumToText(string(GetAdena())));
	return;
}

function OnShow()
{
	SetAdenaText();
	SetItemCount();
	syncInventory();
	return;
}

function OnClickButton(string strID)
{
	if((strID == "CloseButton"))
	{
		Me.HideWindow();
	}
	return;
}

function SetItemCount()
{
	local int limit, Count;
	local array<ItemInfo> artifactItemArray;
	local CustomTooltip t;
	local L2Util util;

	Class'NWindow.UIDATA_INVENTORY'.static.GetAllArtifactItem(artifactItemArray);
	Count = (inventoryWndScript.m_NormalInvenCount + inventoryWndScript.EquipNormalItemGetItemNum());
	limit = inventoryWndScript.GetMyInventoryLimit();
	InvenoryCount.SetText((((("(" $ string(Count)) $ "/") $ string(limit)) $ ")"));
	getInstanceL2Util().ItemboxUpdate(totalInven_ItemWnd, (limit + artifactItemArray.Length));
	if(getInstanceUIData().GetIsClassicServer())
	{
		if(HelpButton.IsShowWindow())
		{
			HelpButton.HideWindow();
		}
	}
	else
	{
		util = L2Util(GetScript("L2Util"));
		util.setCustomTooltip(t);
		util.ToopTipInsertText(((((((GetSystemString(441) $ " : ") $ "(") $ string(Count)) $ "/") $ string(limit)) $ ")"), true, true, COLOR_GOLD);
		util.ToopTipInsertText(((((((GetSystemString(3877) $ " : ") $ "(") $ string(artifactItemArray.Length)) $ "/") $ string(inventoryWndScript.GetArtifactItemInventoryLimit())) $ ")"), true, true, COLOR_ARTIFACT);
		if((HelpButton.IsShowWindow() == false))
		{
			HelpButton.ShowWindow();
		}
		HelpButton.SetTooltipCustomType(util.getCustomToolTip());
	}
	return;
}

function syncInventory()
{
	local array<ItemInfo> itemarray, equipItemArray;
	local int i;
	local ItemInfo kClearItem;
	local array<ItemInfo> artifactItemArray;

	Class'NWindow.UIDATA_INVENTORY'.static.GetAllArtifactItem(artifactItemArray);
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
	i = ((equipItemArray.Length + itemarray.Length) + artifactItemArray.Length);
	while((i < (inventoryWndScript.GetMyInventoryLimit() + artifactItemArray.Length)))
	{
		totalInven_ItemWnd.SetItem(i, kClearItem);
		i++;
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 9570:
		case 2070:
			if(Me.IsShowWindow())
			{
				SetAdenaText();
				SetItemCount();
				syncInventory();
			}
			break;
		case 2570:
			totalInven_ItemWnd.Clear();
			break;
		default:
			break;
	}
	return;
}
