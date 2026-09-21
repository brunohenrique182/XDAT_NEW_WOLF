class EnsoulSubWnd extends UICommonAPI;

const STATE_INSERT_WEAPON = "STATE_INSERT_WEAPON";
const STATE_INSERT_ENSOULSTONE = "STATE_INSERT_ENSOULSTONE";
const STATE_SELECT_ENSOUL = "STATE_SELECT_ENSOUL";
const STATE_CONFIRM_ENSOUL = "STATE_CONFIRM_ENSOUL";
const STATE_ASK_OVERWRITE = "STATE_ASK_OVERWRITE";
const STATE_RESULT = "STATE_RESULT";

var WindowHandle Me;
var TextureHandle SlotBg1_Texture;
var ItemWindowHandle EnsoulSubWnd_Item1;
var ItemWindowHandle EnsoulSubWnd_Item2;
var TabHandle EnsoulSubWnd_Tab;
var TextureHandle tabbgLine;
var TextureHandle tabBg;
var L2Util util;
var InventoryWnd inventoryWndScript;
var EnsoulWnd ensoulWndScript;

function OnRegisterEvent()
{
	return;
}

function OnShow()
{
	syncInventory();
	return;
}

function syncInventory()
{
	local array<ItemInfo> itemarray;
	local int i, nStackableNum;
	local ItemInfo hasItemInfo;

	if((EnsoulSubWnd_Tab.GetTopIndex() == 0))
	{
		itemarray = inventoryWndScript.getInventoryEnSoulEnableItemArray();
		EnsoulSubWnd_Item1.Clear();
		i = 0;
		while((i < itemarray.Length))
		{
			if(!ensoulWndScript.externalCheckUsingItem(itemarray[i]))
			{
				EnsoulSubWnd_Item1.AddItem(itemarray[i]);
			}
			i++;
		}
	}
	else if((EnsoulSubWnd_Tab.GetTopIndex() == 1))
	{
		ensoulWndScript.getItemSlotWindow(0).GetItem(0, hasItemInfo);
		itemarray = inventoryWndScript.getInventoryEnSoulStoneArray(hasItemInfo.ItemType);
		EnsoulSubWnd_Item2.Clear();
		i = 0;
		while((i < itemarray.Length))
		{
			nStackableNum = 0;
			if(IsStackableItem(itemarray[i].ConsumeType))
			{
				if(ensoulWndScript.externalCheckUsingItem(itemarray[i], nStackableNum))
				{
					itemarray[i].ItemNum = (itemarray[i].ItemNum - INT64(nStackableNum));
				}
				if((itemarray[i].ItemNum > INT64(0)))
				{
					EnsoulSubWnd_Item2.AddItem(itemarray[i]);
				}
				else
				{
					EnsoulSubWnd_Item2.DeleteItem(i);
				}
				i++;
				continue;
			}
			if(!ensoulWndScript.externalCheckUsingItem(itemarray[i]))
			{
				EnsoulSubWnd_Item2.AddItem(itemarray[i]);
			}
			i++;
		}
	}
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

function OnLoad()
{
	Initialize();
	EnsoulSubWnd_Tab.SetButtonName(0, GetSystemString(116));
	return;
}

function OnClickButton(string Name)
{
	OnShow();
	switch(Name)
	{
		case "EnsoulInfo_Button":
			break;
		default:
			break;
	}
	return;
}

function OnDBClickItem(string ControlName, int Index)
{
	local ItemInfo Info;

	if(((ControlName == "EnsoulSubWnd_Item1") && (EnsoulSubWnd_Item1.IsEnableWindow() == false)))
	{
		return;
	}
	if(((ControlName == "EnsoulSubWnd_Item2") && (EnsoulSubWnd_Item2.IsEnableWindow() == false)))
	{
		return;
	}
	if((((ensoulWndScript.getCurrentEnsoulState() == "STATE_INSERT_WEAPON") || (ensoulWndScript.getCurrentEnsoulState() == "STATE_INSERT_ENSOULSTONE")) || (ensoulWndScript.getCurrentEnsoulState() == "STATE_SELECT_ENSOUL")))
	{
		if((ControlName == "EnsoulSubWnd_Item1"))
		{
			EnsoulSubWnd_Item1.GetItem(Index, Info);
			ensoulWndScript.InsertWeapon(Info);
		}
		else if((ControlName == "EnsoulSubWnd_Item2"))
		{
			EnsoulSubWnd_Item2.GetItem(Index, Info);
			ensoulWndScript.InsertEnsoulStone(-1, Info);
		}
	}
	return;
}

function OnRClickItem(string strID, int Index)
{
	OnDBClickItem(strID, Index);
	return;
}

function Initialize()
{
	Me = GetWindowHandle("EnsoulSubWnd");
	SlotBg1_Texture = GetTextureHandle("EnsoulSubWnd.SlotBg1_Texture");
	EnsoulSubWnd_Item1 = GetItemWindowHandle("EnsoulSubWnd.EnsoulSubWnd_Item1");
	EnsoulSubWnd_Item2 = GetItemWindowHandle("EnsoulSubWnd.EnsoulSubWnd_Item2");
	EnsoulSubWnd_Tab = GetTabHandle("EnsoulSubWnd.EnsoulSubWnd_Tab");
	tabbgLine = GetTextureHandle("EnsoulSubWnd.tabbgLine");
	tabBg = GetTextureHandle("EnsoulSubWnd.tabbg");
	util = L2Util(GetScript("L2Util"));
	inventoryWndScript = InventoryWnd(GetScript("inventoryWnd"));
	ensoulWndScript = EnsoulWnd(GetScript("EnsoulWnd"));
	return;
}

function setTabIndex(int nIndex)
{
	EnsoulSubWnd_Tab.SetTopOrder(nIndex, false);
	syncInventory();
	return;
}
