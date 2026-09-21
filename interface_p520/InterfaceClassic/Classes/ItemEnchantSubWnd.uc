class ItemEnchantSubWnd extends UICommonAPI;

enum SortOrder
{
	non,                            // 0
	up,                             // 1
	Down                            // 2
};

var TextureHandle SlotBg1_Texture;
var ItemWindowHandle ItemWnd;
var SortOrder currentSortOrder;
//var delegate<OnSortNameCompare> __OnSortNameCompare__Delegate;
//var delegate<OnSortProbCompare> __OnSortProbCompare__Delegate;

static function ItemEnchantSubWnd Inst()
{
	return ItemEnchantSubWnd(GetScript("ItemEnchantSubWnd"));
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
	Class'InterfaceClassic.ItemEnchantWnd'.static.Inst().RequestInputItemInfo(iInfo);
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
	switch(Class'InterfaceClassic.ItemEnchantWnd'.static.Inst().GetStateName())
	{
		case 'stateNone':
			break;
		case 'stateReadyScroll':
			SetTitle(GetSystemString(1532));
			SetScrollItemWnds();
			break;
		case 'stateReadyEquipment':
		case 'stateReadySupport':
		case 'stateReadySupportstone':
		case 'stateReadySupportsystem':
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
	local int i, enchantMax, enchantMin;
	local array<ItemInfo> iInfos;
	local ItemInfo iInfo;
	local EnchantScrollSetUIData enchantScrollData;

	ItemWnd.Clear();
	Class'NWindow.UIDATA_INVENTORY'.static.GetAllItem(iInfos);
	ItemEnchantWnd(GetScript("ItemEnchantWNd"))._GetTargetItemInfo(iInfo);
	i = 0;
	while((i < iInfos.Length))
	{
		if(IsEnchantScroll(EEtcItemType(iInfos[i].EtcItemType)))
		{
			if(IsValidItemID(iInfo.Id))
			{
				if(API_GetEnchantScrollSetData(iInfos[i], iInfo, enchantScrollData))
				{
					enchantMax = enchantScrollData.EnchantRangeDatas[(enchantScrollData.EnchantRangeDatas.Length - 1)].RangeMax;
					enchantMin = enchantScrollData.EnchantRangeDatas[0].RangeMin;
					if(((iInfo.Enchanted > enchantMax) && (enchantMax > -1)))
					{
						i++;
						continue;
					}
					if(((iInfo.Enchanted < enchantMin) && (enchantMin > -1)))
					{
						i++;
						continue;
					}
				}
				else
				{
					i++;
					continue;
				}
			}
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

function bool API_GetEnchantScrollSetData(ItemInfo iInfo, ItemInfo iInfo2, out EnchantScrollSetUIData enchantScrollData)
{
	return Class'NWindow.UIDATA_ITEM'.static.GetEnchantScrollSetData(iInfo.Id.ClassID, iInfo2.Id.ClassID, enchantScrollData);
}

function SetEnchantableItems()
{
	local int i, enchantMax, enchantMin;
	local ItemInfo iInfo, scrollInfo;
	local array<ItemInfo> iInfos;
	local EnchantScrollSetUIData enchantScrollData;

	ItemWnd.Clear();
	scrollInfo = GetIteminfoScroll();
	Class'NWindow.UIDATA_INVENTORY'.static.GetAllEnchantableInvenItem(scrollInfo.Id.ClassID, iInfos);
	iInfo = GetItemInfoEquipment();
	// iInfos.Sort(OnSortProbCompare);   // array.Sort() unsupported by this compiler
	// iInfos.Sort(OnSortNameCompare);   // array.Sort() unsupported by this compiler
	i = 0;
	while((i < iInfos.Length))
	{
		if((iInfo.Id == iInfos[i].Id))
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

function array<ItemInfo> GetSupportItems()
{
	local int i, supportClassID;
	local array<ItemInfo> iInfos, iInfosSupport;

	supportClassID = GetScrollInfoSupport().Id.ClassID;
	Class'NWindow.UIDATA_INVENTORY'.static.GetAllItem(iInfos);
	i = 0;
	while((i < iInfos.Length))
	{
		if(!IsIncPropItem(EEtcItemType(iInfos[i].EtcItemType)))
		{
			i++;
			continue;
		}
		if(!CheckMatchSupportItem(EEtcItemType(iInfos[i].EtcItemType)))
		{
			i++;
			continue;
		}
		if((iInfos[i].Id.ClassID == supportClassID))
		{
			i++;
			continue;
		}
		iInfosSupport[iInfosSupport.Length] = iInfos[i];
		i++;
	}
	return iInfosSupport;
}

function SetSupportItems(ItemWindowHandle supportItemWnd)
{
	local int i;
	local array<ItemInfo> iInfos;

	supportItemWnd.Clear();
	if(!Class'InterfaceClassic.ItemEnchantWnd'.static.Inst().UseSupportSlot())
	{
		return;
	}
	iInfos = GetSupportItems();
	i = 0;
	while((i < iInfos.Length))
	{
		iInfos[i].bShowCount = IsStackableItem(iInfos[i].ConsumeType);
		supportItemWnd.AddItem(iInfos[i]);
		i++;
	}
	if((iInfos.Length > 0))
	{
		supportItemWnd.UpdatePointedNum();
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

function bool IsIncPropItem(UIEventManager.EEtcItemType Type)
{
	return ((((((((int(Type) == 29) || (int(Type) == 28)) || (int(Type) == 52)) || (int(Type) == 53)) || (int(Type) == 58)) || (int(Type) == 59)) || (int(Type) == 84)) || (int(Type) == 85));
}

function bool IsEnchantScroll(UIEventManager.EEtcItemType Type)
{
	return ((((((((((((((((((((int(Type) == 19) || (int(Type) == 20)) || (int(Type) == 21)) || (int(Type) == 22)) || (int(Type) == 30)) || (int(Type) == 31)) || (int(Type) == 32)) || (int(Type) == 33)) || (int(Type) == 56)) || (int(Type) == 57)) || (int(Type) == 63)) || (int(Type) == 64)) || (int(Type) == 65)) || (int(Type) == 66)) || (int(Type) == 87)) || (int(Type) == 86)) || (int(Type) == 82)) || (int(Type) == 83)) || (int(Type) == 91)) || (int(Type) == 92));
}

function bool CheckMatchSupportItem(UIEventManager.EEtcItemType supportSubType)
{
	local UIEventManager.EEtcItemType scrollSubType;

	return true;
	scrollSubType = EEtcItemType(GetIteminfoScroll().EtcItemType);
	switch(supportSubType)
	{
		case ITEME_BLESS_INC_PROP_ENCHT_WP:
			return (int(scrollSubType) == 21);
		case ITEME_BLESS_INC_PROP_ENCHT_AM:
			return (int(scrollSubType) == 22);
		case ITEME_MULTI_INC_PROB_ENCHT_WP:
			return (int(scrollSubType) == 56);
		case ITEME_MULTI_INC_PROB_ENCHT_AM:
			return (int(scrollSubType) == 57);
		case ITEME_POLY_INC_ENCHANT_PROP_WP:
			return (int(scrollSubType) == 82);
		case ITEME_POLY_INC_ENCHANT_PROP_AM:
			return (int(scrollSubType) == 83);
		default:
			return false;
	}
}

function ItemInfo GetIteminfoScroll()
{
	local ItemInfo scrollItem;

	Class'InterfaceClassic.ItemEnchantWnd'.static.Inst().scrollItemWindow.GetItem(0, scrollItem);
	return scrollItem;
}

function ItemInfo GetItemInfoEquipment()
{
	local ItemInfo equipmentItem;

	Class'InterfaceClassic.ItemEnchantWnd'.static.Inst().equipmentItemWindow.GetItem(0, equipmentItem);
	return equipmentItem;
}

function ItemInfo GetScrollInfoSupport()
{
	local ItemInfo supportiInfo;

	Class'InterfaceClassic.ItemEnchantWnd'.static.Inst().supportItemWindow.GetItem(0, supportiInfo);
	return supportiInfo;
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
