class ItemJewelEnchantSubWnd extends UICommonAPI;

var TextureHandle SlotBg1_Texture;
var ItemWindowHandle itemJewelEnchantSubWnd_ItemWnd;
var array<ItemInfo> itemInfoArray;
var ButtonHandle ItemAddBtn;
var ItemJewelEnchantWnd itemJewelEnchantWndScript;
//var delegate<DelegateSortCompare> __DelegateSortCompare__Delegate;

static function ItemJewelEnchantSubWnd Inst()
{
	return ItemJewelEnchantSubWnd(GetScript("ItemJewelEnchantSubWnd"));
}

function Initialize()
{
	itemJewelEnchantSubWnd_ItemWnd = GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemJewelEnchantSubWnd_ItemWnd"));
	ItemAddBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemAddBtn"));
	ItemAddBtn.DisableWindow();
	itemJewelEnchantWndScript = ItemJewelEnchantWnd(GetScript("ItemJewelEnchantWnd"));
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(9570);
	return;
}

event OnLoad()
{
	Initialize();
	return;
}

event OnShow()
{
	_Refresh();
	return;
}

event OnHide()
{
	itemJewelEnchantSubWnd_ItemWnd.Clear();
	SetDescTextBox();
	return;
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "itemAddBtn":
			MoveAll();
			break;
		default:
			break;
	}
	return;
}

event OnRClickItem(string strID, int Index)
{
	OnDBClickItem(strID, Index);
	return;
}

event OnDBClickItem(string ControlName, int Index)
{
	local ItemInfo Info;

	if(itemJewelEnchantWndScript._IsWorkingEnchant())
	{
		return;
	}
	itemJewelEnchantSubWnd_ItemWnd.GetItem(Index, Info);
	if((Info.Id.ClassID > 0))
	{
		itemJewelEnchantWndScript._DropProcess(Info, 0);
	}
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 9570:
			if(m_hOwnerWnd.IsShowWindow())
			{
				if((itemJewelEnchantWndScript.GetStateName() != 'StateResult'))
				{
					_Refresh();
				}
			}
			break;
		default:
			break;
	}
	return;
}

function _Refresh()
{
	local int i;
	local INT64 nCommissionAdena;
	local CombinationItemUIData o_data;

	if(!itemJewelEnchantWndScript.m_hOwnerWnd.IsShowWindow())
	{
		return;
	}
	itemJewelEnchantSubWnd_ItemWnd.Clear();
	SetDescTextBox();
	ItemAddBtn.DisableWindow();
	if(IsAutoMode())
	{
		if((GetOwnerStateName() == 'stateAllReady'))
		{
			ItemAddBtn.EnableWindow();
			if(API_GetCombinationItemData(o_data))
			{
				if((o_data.AutomaticType == 0))
				{
					ItemAddBtn.DisableWindow();
					return;
				}
			}
		}
	}
	if(_GetCanEnchantItemCurrent(nCommissionAdena, itemInfoArray))
	{
		if((GetOwnerStateName() == 'stateReady'))
		{
			if((int(Class'Interface.ItemJewelEnchantWnd'.static.Inst().currentEnchantType) == 1))
			{
				itemInfoArray = GetDyeCombines(itemInfoArray);
			}
		}
		// itemInfoArray.Sort(DelegateSortCompare);   // array.Sort() unsupported by this compiler
		i = 0;
		while((i < itemInfoArray.Length))
		{
			itemJewelEnchantSubWnd_ItemWnd.AddItem(itemInfoArray[i]);
			i++;
		}
		if((itemInfoArray.Length > 0))
		{
			itemJewelEnchantSubWnd_ItemWnd.UpdatePointedNum();
		}
	}
	SetDescTextBox();
	return;
}

function bool _GetCanEnchantItemCurrent(out INT64 nCommissionAdena, out array<ItemInfo> MaterialItems)
{
	local int slot1_ClassID, slot2_ClassID, slot1_Enchanted, slot2_Enchanted;

	slot1_ClassID = itemJewelEnchantWndScript._GetClassIDBySlotItemIndex(1);
	slot1_Enchanted = itemJewelEnchantWndScript._GetEnchantedBySlotItemIndex(1);
	slot2_ClassID = itemJewelEnchantWndScript._GetClassIDBySlotItemIndex(2);
	slot2_Enchanted = itemJewelEnchantWndScript._GetEnchantedBySlotItemIndex(2);
	switch(GetOwnerStateName())
	{
		case 'stateReady':
			API_GetMaterialItemForEnchantFromInven(-1, -1, -1, -1, nCommissionAdena, MaterialItems);
			CheckNDisableItemInfo(MaterialItems);
			break;
		case 'stateOneReady':
			API_GetMaterialItemForEnchantFromInven(slot1_ClassID, slot1_Enchanted, -1, -1, nCommissionAdena, MaterialItems);
			break;
		case 'stateAllReady':
			if(IsAutoMode())
			{
				API_GetMaterialItemForEnchantFromInven(slot1_ClassID, slot1_Enchanted, slot2_ClassID, slot2_Enchanted, nCommissionAdena, MaterialItems);
			}
			else
			{
				API_GetMaterialItemForEnchantFromInven(slot1_ClassID, slot1_Enchanted, -1, -1, nCommissionAdena, MaterialItems);
			}
			break;
		default:
			break;
	}
	return (MaterialItems.Length > 0);
}

function CheckNDisableItemInfo(out array<ItemInfo> MaterialItems)
{
	local int i;
	local INT64 nCommissionAdenaSlot2;
	local array<ItemInfo> materialItemSlot2;

	i = 0;
	while((i < MaterialItems.Length))
	{
		materialItemSlot2.Length = 0;
		if(!_CanEnchatItem(MaterialItems[i].Id.ClassID, MaterialItems[i].Enchanted, nCommissionAdenaSlot2, materialItemSlot2))
		{
			MaterialItems[i].bDisabled = 1;
		}
		i++;
	}
	return;
}

function bool _CheckCanEnchatItem(int ClassID, int Enchanted)
{
	local array<ItemInfo> MaterialItems;
	local INT64 nCommissionAdena;

	return _CanEnchatItem(ClassID, Enchanted, nCommissionAdena, MaterialItems);
}

function bool _CanEnchatItem(int slot1ClassID, int Enchanted, out INT64 nCommissionAdena, out array<ItemInfo> MaterialItems)
{
	local array<ItemInfo> iInfos;

	MaterialItems.Length = 0;
	nCommissionAdena = INT64(0);
	if((slot1ClassID != 0))
	{
		if((Class'NWindow.UIDATA_INVENTORY'.static.FindItemByClassID(slot1ClassID, iInfos) < 1))
		{
			return false;
		}
		if((iInfos[0].ItemNum < INT64(1)))
		{
			return false;
		}
	}
	API_GetMaterialItemForEnchantFromInven(GetSlotClassID(slot1ClassID), Enchanted, -1, -1, nCommissionAdena, MaterialItems);
	if((slot1ClassID == 0))
	{
		CheckNDisableItemInfo(MaterialItems);
		return false;
	}
	else
	{
		CheckNRemoveSameClassid(slot1ClassID, Enchanted, MaterialItems);
	}
	return (MaterialItems.Length > 0);
}

function SetDescTextBox()
{
	local CombinationItemUIData o_data;

	if((itemJewelEnchantSubWnd_ItemWnd.GetItemNum() == 0))
	{
		ItemAddBtn.DisableWindow();
		GetWindowHandle("ItemJewelEnchantSubWnd.DescriptionMsgWnd").ShowWindow();
	}
	else
	{
		GetWindowHandle("ItemJewelEnchantSubWnd.DescriptionMsgWnd").HideWindow();
	}
	if(API_GetCombinationItemData(o_data))
	{
		if((o_data.AutomaticType == 0))
		{
			GetTextBoxHandle("ItemJewelEnchantSubWnd.DescriptionMsgWnd.descTextBox").SetText(GetSystemMessage(13729));
			return;
		}
	}
	GetTextBoxHandle("ItemJewelEnchantSubWnd.DescriptionMsgWnd.descTextBox").SetText(GetSystemMessage(4222));
	return;
}

function int API_GetEnchantCandidateMaterialList(int ClassID, out array<int> CandidateMaterials)
{
	Class'NWindow.NewEnchantAPI'.static.GetEnchantCandidateMaterialList(ClassID, CandidateMaterials);
	return CandidateMaterials.Length;
}

function bool API_GetCombinationItemData(out CombinationItemUIData o_data)
{
	if((itemJewelEnchantWndScript._GetClassIDBySlotItemIndex(1) == -1))
	{
		return false;
	}
	if((itemJewelEnchantWndScript._GetClassIDBySlotItemIndex(2) == -1))
	{
		return false;
	}
	return Class'NWindow.NewEnchantAPI'.static.GetCombinationItemData(itemJewelEnchantWndScript._GetClassIDBySlotItemIndex(1), itemJewelEnchantWndScript._GetEnchantedBySlotItemIndex(1), itemJewelEnchantWndScript._GetClassIDBySlotItemIndex(2), itemJewelEnchantWndScript._GetEnchantedBySlotItemIndex(2), o_data);
}

function API_GetMaterialItemForEnchantFromInven(int OneSlotItemClassID, int OneSlotItemEnchant, int TwoSlotItemClassID, int TwoSlotItemEnchant, out INT64 Commission, out array<ItemInfo> MaterialItems)
{
	local int i;

	MaterialItems.Length = 0;
	if(getInstanceUIData().GetIsClassicServer())
	{
		Class'NWindow.NewEnchantAPI'.static.GetMaterialItemForEnchantFromInven(OneSlotItemClassID, OneSlotItemEnchant, TwoSlotItemClassID, TwoSlotItemEnchant, Commission, MaterialItems, 4);
	}
	else
	{
		Class'NWindow.NewEnchantAPI'.static.GetMaterialItemForEnchantFromInven(OneSlotItemClassID, OneSlotItemEnchant, TwoSlotItemClassID, TwoSlotItemEnchant, Commission, MaterialItems);
	}
	CheckNRemoveSlots(MaterialItems);
	CheckNRemoveSameAutoInventory(MaterialItems);
	i = 0;
	while((i < MaterialItems.Length))
	{
		MaterialItems[i].bShowCount = IsStackableItem(MaterialItems[i].ConsumeType);
		i++;
	}
	return;
}

function API_GetMaterialItemForEnchantFromEquip(int OneSlotItemClassID, int OneSlotItemEnchant, int TwoSlotItemClassID, int TwoSlotItemEnchant, out INT64 Commission, out array<ItemInfo> MaterialItems)
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		Class'NWindow.NewEnchantAPI'.static.GetMaterialItemForEnchantFromEquip(OneSlotItemClassID, OneSlotItemEnchant, TwoSlotItemClassID, TwoSlotItemEnchant, Commission, MaterialItems, 4);
	}
	else
	{
		Class'NWindow.NewEnchantAPI'.static.GetMaterialItemForEnchantFromEquip(OneSlotItemClassID, OneSlotItemEnchant, TwoSlotItemClassID, TwoSlotItemEnchant, Commission, MaterialItems);
	}
	return;
}

function int GetSlotClassID(int nClassID)
{
	if((nClassID > 0))
	{
		return nClassID;
	}
	return -1;
}

function name GetOwnerStateName()
{
	return Class'Interface.ItemJewelEnchantWnd'.static.Inst().GetStateName();
}

function array<ItemInfo> GetDyeCombines(array<ItemInfo> iInfos)
{
	local int i;
	local DyeCombinationUIData o_data;
	local array<ItemInfo> dyeCombines;

	i = 0;
	while((i < iInfos.Length))
	{
		if(Class'NWindow.UIDATA_HENNA'.static.GetDyeCombinationData(iInfos[i].Id.ClassID, o_data))
		{
			dyeCombines[dyeCombines.Length] = iInfos[i];
		}
		i++;
	}
	return dyeCombines;
}

function CheckNRemoveSlotSlotIndex(int SlotIndex, out array<ItemInfo> MaterialItems)
{
	local int i, ServerID, Enchanted;

	ServerID = itemJewelEnchantWndScript._GetServerIDBySlotItemIndex(SlotIndex);
	Enchanted = itemJewelEnchantWndScript._GetEnchantedBySlotItemIndex(SlotIndex);
	if((ServerID == -1))
	{
		return;
	}
	i = 0;
	while((i < MaterialItems.Length))
	{
		if(((MaterialItems[i].Id.ServerID == ServerID) && (MaterialItems[i].Enchanted == Enchanted)))
		{
			MaterialItems[i].ItemNum = (MaterialItems[i].ItemNum - INT64(1));
			if((MaterialItems[i].ItemNum == INT64(0)))
			{
				MaterialItems.Remove(i, 1);
			}
			return;
		}
		i++;
	}
	return;
}

function CheckNRemoveSlots(out array<ItemInfo> MaterialItems)
{
	switch(GetOwnerStateName())
	{
		case 'stateOneReady':
			CheckNRemoveSlotSlotIndex(1, MaterialItems);
			break;
		case 'stateAllReady':
			CheckNRemoveSlotSlotIndex(1, MaterialItems);
			CheckNRemoveSlotSlotIndex(2, MaterialItems);
			break;
		case 'stateProcess':
			CheckNRemoveSlotSlotIndex(1, MaterialItems);
			CheckNRemoveSlotSlotIndex(2, MaterialItems);
			break;
		default:
			break;
	}
	return;
}

function CheckNRemoveSameClassid(int ClassID, int Enchanted, out array<ItemInfo> MaterialItems)
{
	local int i;

	i = 0;
	while((i < MaterialItems.Length))
	{
		if(((MaterialItems[i].Id.ClassID == ClassID) && (MaterialItems[i].Enchanted == Enchanted)))
		{
			MaterialItems[i].ItemNum = (MaterialItems[i].ItemNum - INT64(1));
			if((MaterialItems[i].ItemNum == INT64(0)))
			{
				MaterialItems.Remove(i, 1);
			}
			return;
		}
		i++;
	}
	return;
}

function CheckNRemoveSameAutoInventory(out array<ItemInfo> MaterialItems)
{
	local int i, j, Len;
	local ItemInfo iInfo;

	Len = Class'Interface.ItemJewelEnchantWnd'.static.Inst().InventoryItem.GetItemNum();
	j = 0;
	while((j < Len))
	{
		if(Class'Interface.ItemJewelEnchantWnd'.static.Inst().InventoryItem.GetItem(j, iInfo))
		{
			i = 0;
			while((i < MaterialItems.Length))
			{
				if(((iInfo.Id == MaterialItems[i].Id) && (iInfo.Enchanted == MaterialItems[i].Enchanted)))
				{
					MaterialItems[i].ItemNum = (MaterialItems[i].ItemNum - iInfo.ItemNum);
					if((MaterialItems[i].ItemNum < INT64(1)))
					{
						MaterialItems.Remove(i, 1);
					}
					break;
				}
				i++;
			}
		}
		j++;
	}
	return;
}

function int GetIndexSubIvenItem(int ClassID)
{
	local ItemInfo Info;
	local int ItemNum, i;

	ItemNum = itemJewelEnchantSubWnd_ItemWnd.GetItemNum();
	i = 0;
	while((i < ItemNum))
	{
		itemJewelEnchantSubWnd_ItemWnd.GetItem(i, Info);
		if((Info.Id.ClassID == ClassID))
		{
			return i;
		}
		i++;
	}
	return -1;
}

delegate int DelegateSortCompare(ItemInfo A, ItemInfo B)
{
	if((A.Id.ClassID > B.Id.ClassID))
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

function MoveAll()
{
	local int i, Len;
	local ItemInfo iInfo;

	Len = itemJewelEnchantSubWnd_ItemWnd.GetItemNum();
	i = 0;
	while((i < Len))
	{
		itemJewelEnchantSubWnd_ItemWnd.GetItem(i, iInfo);
		itemJewelEnchantWndScript._AddInventoryItem(iInfo);
		i++;
	}
	itemJewelEnchantWndScript._SortItemInventory();
	itemJewelEnchantSubWnd_ItemWnd.Clear();
	SetDescTextBox();
	return;
}

function bool _MoveToOwner(ItemInfo iInfo, optional INT64 ItemNum)
{
	local int i, idx, Len;
	local ItemInfo iiInfo;

	if(IsStackableItem(iInfo.ConsumeType))
	{
		idx = itemJewelEnchantSubWnd_ItemWnd.FindItem(iInfo.Id);
		if((idx == -1))
		{
			return false;
		}
		if((iInfo.ItemNum == ItemNum))
		{
			itemJewelEnchantSubWnd_ItemWnd.DeleteItem(idx);
		}
		else
		{
			iInfo.ItemNum = (iInfo.ItemNum - ItemNum);
			itemJewelEnchantSubWnd_ItemWnd.SetItem(idx, iInfo);
		}
		iInfo.ItemNum = ItemNum;
		itemJewelEnchantWndScript._AddInventoryItem(iInfo);
	}
	else
	{
		Len = itemJewelEnchantSubWnd_ItemWnd.GetItemNum();
		i = (Len - 1);
		while((i >= 0))
		{
			itemJewelEnchantSubWnd_ItemWnd.GetItem(i, iiInfo);
			if((iInfo.Id.ClassID == iiInfo.Id.ClassID))
			{
				if((iInfo.Enchanted == iiInfo.Enchanted))
				{
					itemJewelEnchantSubWnd_ItemWnd.DeleteItem(i);
					itemJewelEnchantWndScript._AddInventoryItem(iiInfo);
					ItemNum = (ItemNum - INT64(1));
					if((ItemNum == INT64(0)))
					{
						break;
					}
				}
			}
			i--;
		}
	}
	itemJewelEnchantWndScript._SortItemInventory();
	SetDescTextBox();
	return true;
}

function bool _GetSlot1ItemInfo(out ItemInfo iInfo)
{
	return itemJewelEnchantWndScript._GetSlot1ItemInfo(iInfo);
}

function bool _GetSlot2ItemInfo(out ItemInfo iInfo)
{
	return itemJewelEnchantWndScript._GetSlot2ItemInfo(iInfo);
}

function INT64 _GetIneventoryItemNum(ItemInfo iInfo)
{
	local int i, idx;
	local INT64 ItemNum;
	local ItemInfo iiInfo;

	if(IsStackableItem(iInfo.ConsumeType))
	{
		idx = itemJewelEnchantSubWnd_ItemWnd.FindItem(iInfo.Id);
		if((idx == -1))
		{
			return INT64(0);
		}
		itemJewelEnchantSubWnd_ItemWnd.GetItem(idx, iiInfo);
		ItemNum = iiInfo.ItemNum;
	}
	else
	{
		i = 0;
		while((i < itemJewelEnchantSubWnd_ItemWnd.GetItemNum()))
		{
			while(!itemJewelEnchantSubWnd_ItemWnd.GetItem(i, iiInfo))
			{
				idx++;
			}
			idx++;
			if((iInfo.Id.ClassID == iiInfo.Id.ClassID))
			{
				if((iInfo.Enchanted == iiInfo.Enchanted))
				{
					ItemNum = (ItemNum + INT64(1));
				}
			}
			i++;
		}
	}
	return ItemNum;
}

function bool IsAutoMode()
{
	return Class'Interface.ItemJewelEnchantWnd'.static.Inst()._IsAutoMode();
}
