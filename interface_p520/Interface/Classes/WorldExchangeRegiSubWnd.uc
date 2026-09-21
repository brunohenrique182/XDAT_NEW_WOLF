class WorldExchangeRegiSubWnd extends UICommonAPI;

var ItemWindowHandle ItemWnd;

static function WorldExchangeRegiSubWnd Inst()
{
	return WorldExchangeRegiSubWnd(GetScript("WorldExchangeRegiSubWnd"));
}

function Initialize()
{
	ItemWnd = GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".itemEnchantSubWndItemWnd"));
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DescriptionMsgWnd.descTextBox")).SetText(GetSystemMessage(4222));
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

event OnRClickItem(string ControlName, int Index)
{
	OnDBClickItem(ControlName, Index);
	return;
}

event OnDBClickItem(string ControlName, int Index)
{
	local ItemInfo iInfo;

	ItemWnd.GetItem(Index, iInfo);
	iInfo.DragSrcName = "itemEnchantSubWndItemWnd";
	Class'Interface.WorldExchangeRegiWnd'.static.Inst().OnDropItem("", iInfo, 0, 0);
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 9570:
			if(m_hOwnerWnd.IsShowWindow())
			{
				RefreshItemNum();
			}
			break;
		default:
			break;
	}
	return;
}

function _Show()
{
	m_hOwnerWnd.ShowWindow();
	refresh();
	return;
}

function _Hide()
{
	m_hOwnerWnd.HideWindow();
	return;
}

function refresh()
{
	SetSellItems();
	return;
}

function RefreshItemNum()
{
	return;
}

function _ResetSellItem()
{
	local int idx;
	local ItemInfo iInfo, inveniInfo, sellItemInfo;

	Class'Interface.WorldExchangeRegiWnd'.static.Inst()._GetSellItemInfo(sellItemInfo);
	if(!Class'NWindow.UIDATA_INVENTORY'.static.HasItem(sellItemInfo.Id.ServerID))
	{
		Class'Interface.WorldExchangeRegiWnd'.static.Inst().DelItemInfo();
		refresh();
		return;
	}
	Class'NWindow.UIDATA_INVENTORY'.static.FindItem(sellItemInfo.Id.ServerID, inveniInfo);
	idx = ItemWnd.FindItem(sellItemInfo.Id);
	if((idx == -1))
	{
		refresh();
		return;
	}
	else
	{
		ItemWnd.GetItem(idx, iInfo);
		refresh();
		return;
	}
	iInfo.ItemNum = (inveniInfo.ItemNum - sellItemInfo.ItemNum);
	ItemWnd.SetItem(idx, iInfo);
	return;
}

function SetSellItems()
{
	local int i;
	local ItemInfo sellItemInfo;
	local array<ItemInfo> iInfos;

	ItemWnd.Clear();
	iInfos = GetAllItemInfo();
	Class'Interface.WorldExchangeRegiWnd'.static.Inst()._GetSellItemInfo(sellItemInfo);
	i = 0;
	while((i < iInfos.Length))
	{
		if(IsAdena(iInfos[i].Id))
		{
		}
		else if(!iInfos[i].bIsAuctionAble)
		{
			continue;
		}
		if((sellItemInfo.Id == iInfos[i].Id))
		{
			iInfos[i].ItemNum = (iInfos[i].ItemNum - sellItemInfo.ItemNum);
		}
		if((iInfos[i].ItemNum == INT64(0)))
		{
			i++;
			continue;
		}
		if(iInfos[i].bSecurityLock)
		{
			i++;
			continue;
		}
		if((iInfos[i].CurrentPeriod > 0))
		{
			i++;
			continue;
		}
		if(getInstanceUIData().GetIsLiveServer())
		{
			if(isRefinery(iInfos[i]))
			{
				i++;
				continue;
			}
		}
		iInfos[i].bShowCount = IsStackableItem(iInfos[i].ConsumeType);
		ItemWnd.AddItem(iInfos[i]);
		i++;
	}
	SetDescTextBox();
	return;
}

function array<ItemInfo> GetAllItemInfo()
{
	local array<ItemInfo> allItem, artifactItems;
	local int i;

	Class'NWindow.UIDATA_INVENTORY'.static.GetAllInvenItem(allItem);
	if(getInstanceUIData().GetIsLiveServer())
	{
		Class'NWindow.UIDATA_INVENTORY'.static.GetAllArtifactItem(artifactItems);
		i = 0;
		while((i < artifactItems.Length))
		{
			allItem[allItem.Length] = artifactItems[i];
			i++;
		}
	}
	return allItem;
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

function bool isRefinery(out ItemInfo item)
{
	if((((item.RefineryOp1 != 0) || (item.RefineryOp2 != 0)) || (item.RefineryOp3 != 0)))
	{
		return true;
	}
	return false;
}
