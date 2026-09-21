class ItemMultiEnchantSubWnd extends UICommonAPI;

enum SortOrder
{
	non,                            // 0
	up,                             // 1
	Down                            // 2
};

var ItemWindowHandle ItemWnd;
var SortOrder currentSortOrder;
//var delegate<OnSortNameCompare> __OnSortNameCompare__Delegate;
//var delegate<OnSortProbCompare> __OnSortProbCompare__Delegate;

static function ItemMultiEnchantSubWnd Inst()
{
	return ItemMultiEnchantSubWnd(GetScript("ItemMultiEnchantSubWnd"));
}

function Initialize()
{
	ItemWnd = GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".itemEnchantSubWndItemWnd"));
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DescriptionMsgWnd.descTextBox")).SetText(GetSystemMessage(4222));
	currentSortOrder = Down;
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
	refresh();
	return;
}

event OnRClickItem(string strID, int Index)
{
	OnDBClickItem(strID, Index);
	return;
}

event OnDBClickItem(string ControlName, int Index)
{
	local ItemInfo iInfo;

	ItemWnd.GetItem(Index, iInfo);
	switch(Class'Interface.ItemMultiEnchantWnd'.static.Inst().GetStateName())
	{
		case 'stateReadyScroll':
			Class'Interface.ItemMultiEnchantWnd'.static.Inst().RQ_C_EX_REQ_START_MULTI_ENCHANT_SCROLL(iInfo);
			break;
		case 'stateReadyEquipment':
			Class'Interface.ItemMultiEnchantWnd'.static.Inst().SetSlotEmpty(iInfo);
			break;
		default:
			break;
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
				refresh();
			}
			break;
		default:
			break;
	}
	return;
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "sort_btn":
			ToggleSort();
			break;
		default:
			break;
	}
	return;
}

function ToggleSort()
{
	switch(currentSortOrder)
	{
		case up:
			currentSortOrder = Down;
			break;
		default:
			currentSortOrder = up;
			break;
	}
	refresh();
	return;
}

function refresh()
{
	switch(Class'Interface.ItemMultiEnchantWnd'.static.Inst().GetStateName())
	{
		case 'stateNone':
			break;
		case 'stateReadyScroll':
			SetTitle(GetSystemString(1532));
			SetScrollItemWnds();
			break;
		case 'stateReadyEquipment':
			SetTitle(GetSystemString(13846));
			SetEnchantableItems();
			break;
		default:
			break;
	}
	SetDescTextBox();
	return;
}

function SetScrollItemWnds()
{
	local int i;
	local array<ItemInfo> iInfos;

	ItemWnd.Clear();
	Class'NWindow.UIDATA_INVENTORY'.static.GetAllItem(iInfos);
	i = 0;
	while((i < iInfos.Length))
	{
		if(IsNormalEnchantScroll(EEtcItemType(iInfos[i].EtcItemType)))
		{
			iInfos[i].bShowCount = IsStackableItem(iInfos[i].ConsumeType);
			ItemWnd.AddItem(iInfos[i]);
		}
		i++;
	}
	if((iInfos.Length > 0))
	{
		ItemWnd.UpdatePointedNum();
	}
	return;
}

function Show()
{
	m_hOwnerWnd.ShowWindow();
	refresh();
	return;
}

function Hide()
{
	m_hOwnerWnd.HideWindow();
	return;
}

function bool API_GetEnchantScrollSetData(ItemInfo iInfo, ItemInfo iInfo2, out EnchantScrollSetUIData enchantScrollData)
{
	return Class'NWindow.UIDATA_ITEM'.static.GetEnchantScrollSetData(iInfo.Id.ClassID, iInfo2.Id.ClassID, enchantScrollData);
}

function SetEnchantableItems()
{
	local int i, enchantMax, enchantMin;
	local array<ItemInfo> iInfos;
	local ItemInfo scrollInfo;
	local EnchantScrollSetUIData enchantScrollData;

	ItemWnd.Clear();
	scrollInfo = GetIteminfoScroll();
	Class'NWindow.UIDATA_INVENTORY'.static.GetAllEnchantableInvenItem(scrollInfo.Id.ClassID, iInfos);
	// iInfos.Sort(OnSortProbCompare);   // array.Sort() unsupported by this compiler
	// iInfos.Sort(OnSortNameCompare);   // array.Sort() unsupported by this compiler
	i = 0;
	while((i < iInfos.Length))
	{
		if((Class'Interface.ItemMultiEnchantWnd'.static.Inst().FindIndexEquipmentWithServerID(iInfos[i].Id.ServerID) > -1))
		{
			i++;
			continue;
		}
		if(!API_GetEnchantScrollSetData(scrollInfo, iInfos[i], enchantScrollData))
		{
			i++;
			continue;
		}
		enchantMax = enchantScrollData.EnchantRangeDatas[(enchantScrollData.EnchantRangeDatas.Length - 1)].RangeMax;
		enchantMin = enchantScrollData.EnchantRangeDatas[0].RangeMin;
		if(((iInfos[i].Enchanted > enchantMax) && (enchantMax > -1)))
		{
			i++;
			continue;
		}
		if(((iInfos[i].Enchanted < enchantMin) && (enchantMin > -1)))
		{
			i++;
			continue;
		}
		iInfos[i].bShowCount = IsStackableItem(iInfos[i].ConsumeType);
		ItemWnd.AddItem(iInfos[i]);
		i++;
	}
	if((iInfos.Length > 0))
	{
		ItemWnd.UpdatePointedNum();
	}
	return;
}

function SetDescTextBox()
{
	if((ItemWnd.GetItemNum() == 0))
	{
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DescriptionMsgWnd")).ShowWindow();
	}
	else
	{
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DescriptionMsgWnd")).HideWindow();
	}
	return;
}

function SetTitle(string Title)
{
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemMaterialTitle_Txt")).SetText(Title);
	return;
}

function bool IsEnchantableItem(UIEventManager.EItemParamType Type)
{
	return ((((int(Type) == 0) || (int(Type) == 1)) || (int(Type) == 3)) || (int(Type) == 2));
}

function bool IsNormalEnchantScroll(UIEventManager.EEtcItemType Type)
{
	return (((int(Type) == 19) || (int(Type) == 20)) || (int(Type) == 63));
}

function ItemInfo GetIteminfoScroll()
{
	local ItemInfo scrollItem;

	Class'Interface.ItemMultiEnchantWnd'.static.Inst().scrollItemWindow.GetItem(0, scrollItem);
	return scrollItem;
}

delegate int OnSortNameCompare(ItemInfo A, ItemInfo B)
{
	switch(currentSortOrder)
	{
		case non:
			return 0;
		case up:
			if((float(A.Id.ClassID) > float(B.Id.ClassID)))
			{
				return -1;
			}
			else
			{
				break;
			}
		case Down:
			if((float(A.Id.ClassID) < float(B.Id.ClassID)))
			{
				return -1;
			}
			else
			{
				break;
			}
		default:
			break;
	}
	return 0;
}

delegate int OnSortProbCompare(ItemInfo A, ItemInfo B)
{
	switch(currentSortOrder)
	{
		case non:
			return 0;
		case up:
			if((float(A.Enchanted) > float(B.Enchanted)))
			{
				return -1;
			}
			else
			{
				break;
			}
		case Down:
			if((float(A.Enchanted) < float(B.Enchanted)))
			{
				return -1;
			}
			else
			{
				break;
			}
		default:
			break;
	}
	return 0;
}
