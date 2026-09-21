class ItemAutoPeelInvenWnd extends UICommonAPI;

var WindowHandle Me;
var ItemWindowHandle ItemWnd;

static function ItemAutoPeelInvenWnd Inst()
{
	return ItemAutoPeelInvenWnd(GetScript("ItemAutoPeelInvenWnd"));
}

function Initialize()
{
	InitControls();
	return;
}

function InitControls()
{
	local string ownerFullPath;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	ItemWnd = GetItemWindowHandle((ownerFullPath $ ".ItemEnchantSubWndItemWnd"));
	return;
}

function UpdateInventoryWnd()
{
	local int i;
	local INT64 RemainItemNum;
	local ItemInfo tempInfo;
	local array<ItemInfo> ItemInfos;
	local ItemAutoPeelWnd.ItemAutoPeelInfo ItemAutoPeelInfo;

	ItemAutoPeelInfo = Class'InterfaceClassic.ItemAutoPeelWnd'.static.Inst().GetItemAutoPeelInfo();
	if((Me.IsShowWindow() == false))
	{
		return;
	}
	ItemWnd.Clear();
	Class'NWindow.UIDATA_INVENTORY'.static.GetAllDefaultActionPeelItem(ItemInfos);
	i = 0;
	while((i < ItemInfos.Length))
	{
		tempInfo = ItemInfos[i];
		if((tempInfo.Id.ServerID == ItemAutoPeelInfo.targetItemSId))
		{
			RemainItemNum = (tempInfo.ItemNum - ItemAutoPeelInfo.totalPeelCnt);
			if((RemainItemNum <= INT64(0)))
			{
				i++;
				continue;
			}
			tempInfo.ItemNum = RemainItemNum;
		}
		tempInfo.bShowCount = true;
		tempInfo.bDisabled = 0;
		ItemWnd.AddItem(tempInfo);
		i++;
	}
	ItemWnd.UpdatePointedNum();
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(9570);
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 9570:
			if(m_hOwnerWnd.IsShowWindow())
			{
				UpdateInventoryWnd();
			}
			break;
		default:
			break;
	}
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

event OnShow()
{
	UpdateInventoryWnd();
	return;
}

event OnDBClickItem(string strID, int Index)
{
	local ItemInfo targetItemInfo;

	if((Index >= 0))
	{
		ItemWnd.GetItem(Index, targetItemInfo);
		Class'InterfaceClassic.ItemAutoPeelWnd'.static.Inst().RegisterItem(targetItemInfo.Id.ServerID, Class'NWindow.InputAPI'.static.IsAltPressed());
	}
	return;
}

event OnRClickItem(string strID, int Index)
{
	OnDBClickItem(strID, Index);
	return;
}

event OnReceivedCloseUI()
{
	Class'InterfaceClassic.ItemAutoPeelWnd'.static.Inst().CloseWindow();
	return;
}
