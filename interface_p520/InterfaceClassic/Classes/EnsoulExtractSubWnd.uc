class EnsoulExtractSubWnd extends UICommonAPI;

var WindowHandle Me;
var ItemWindowHandle EnsoulSubWnd_Item1;
var ItemWindowHandle EnsoulSubWnd_Item2;
var TabHandle EnsoulSubWnd_Tab;
var L2Util util;
var InventoryWnd inventoryWndScript;
var EnsoulExtractWnd ensoulExtractWndScript;

function OnRegisterEvent()
{
	return;
}

function OnLoad()
{
	Initialize();
	EnsoulSubWnd_Tab.SetButtonName(0, GetSystemString(116));
	return;
}

function OnShow()
{
	syncInventory();
	return;
}

function Initialize()
{
	ensoulExtractWndScript = EnsoulExtractWnd(GetScript("EnsoulExtractWnd"));
	inventoryWndScript = InventoryWnd(GetScript("InventoryWnd"));
	Me = GetWindowHandle("EnsoulExtractSubWnd");
	EnsoulSubWnd_Tab = GetTabHandle("EnsoulExtractSubWnd.EnsoulSubWnd_Tab");
	EnsoulSubWnd_Item1 = GetItemWindowHandle("EnsoulExtractSubWnd.EnsoulSubWnd_Item1");
	EnsoulSubWnd_Item2 = GetItemWindowHandle("EnsoulExtractSubWnd.EnsoulSubWnd_Item2");
	EnsoulSubWnd_Item2.DisableWindow();
	EnsoulSubWnd_Tab.SetDisable(1, true);
	return;
}

function setLock(bool bLock)
{
	if(bLock)
	{
		EnsoulSubWnd_Item1.DisableWindow();
		EnsoulSubWnd_Item2.DisableWindow();
	}
	else
	{
		EnsoulSubWnd_Item1.EnableWindow();
		EnsoulSubWnd_Item2.EnableWindow();
	}
	return;
}

function OnRClickItem(string strID, int Index)
{
	OnDBClickItem(strID, Index);
	return;
}

function OnDBClickItem(string ControlName, int Index)
{
	local ItemInfo Info;

	if((ControlName == "EnsoulSubWnd_Item1"))
	{
		if(EnsoulSubWnd_Item1.IsEnableWindow())
		{
			EnsoulSubWnd_Item1.GetItem(Index, Info);
			ensoulExtractWndScript.InsertWeapon(Info);
		}
	}
	return;
}

function syncInventory()
{
	local array<ItemInfo> itemarray;
	local int i;

	if((EnsoulSubWnd_Tab.GetTopIndex() == 0))
	{
		itemarray = inventoryWndScript.getInventoryEnSoulExtractEnableItemArray();
		EnsoulSubWnd_Item1.Clear();
		i = 0;
		while((i < itemarray.Length))
		{
			if((!ensoulExtractWndScript.externalCheckUsingItem(itemarray[i]) && !itemarray[i].bSecurityLock))
			{
				EnsoulSubWnd_Item1.AddItem(itemarray[i]);
			}
			i++;
		}
	}
	return;
}
