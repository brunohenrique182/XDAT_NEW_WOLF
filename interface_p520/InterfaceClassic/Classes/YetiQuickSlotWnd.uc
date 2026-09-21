class YetiQuickSlotWnd extends UICommonAPI;

struct ReturningSpellbook
{
	var string Name;
	var INT64 totalItemNum;
	var array<int> nItemIDArray;
};

var WindowHandle Me;
var ButtonHandle ReturnScrollSlot_Btn;
var ButtonHandle ReturnScrollSlotSetting_Btn;
var ButtonHandle ViewPoint_Reset_Btn;
var ButtonHandle ViewPoint_180_Btn;
var TextBoxHandle ReturnScrollSlot_num;
var WindowHandle ReturnScrollSubWnd;
var ButtonHandle ReturnScroll_Town01_Btn;
var ButtonHandle ReturnScroll_Town02_Btn;
var ButtonHandle ReturnScroll_Town03_Btn;
var ButtonHandle ReturnScroll_Town04_Btn;
var array<ReturningSpellbook> returningSpellbookArray;
var int CURRENTITEMINDEX;

event OnRegisterEvent()
{
	RegisterEvent(9750);
	RegisterEvent(9570);
	RegisterEvent(2070);
	RegisterEvent(40);
	return;
}

event OnLoad()
{
	Initialize();
	Load();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("YetiQuickSlotWnd");
	ReturnScrollSlotSetting_Btn = GetButtonHandle("YetiQuickSlotWnd.ReturnScrollSlotSetting_Btn");
	ReturnScrollSlot_Btn = GetButtonHandle("YetiQuickSlotWnd.ReturnScrollSlot_Btn");
	ReturnScrollSlot_num = GetTextBoxHandle("YetiQuickSlotWnd.ReturnScrollSlot_num");
	ViewPoint_Reset_Btn = GetButtonHandle("YetiQuickSlotWnd.ViewPoint_Reset_Btn");
	ViewPoint_180_Btn = GetButtonHandle("YetiQuickSlotWnd.ViewPoint_180_Btn");
	ReturnScrollSubWnd = GetWindowHandle("YetiQuickSlotWnd.ReturnScrollSubWnd");
	ReturnScroll_Town01_Btn = GetButtonHandle("YetiQuickSlotWnd.ReturnScrollSubWnd.ReturnScroll_Town01_Btn");
	ReturnScroll_Town02_Btn = GetButtonHandle("YetiQuickSlotWnd.ReturnScrollSubWnd.ReturnScroll_Town02_Btn");
	ReturnScroll_Town03_Btn = GetButtonHandle("YetiQuickSlotWnd.ReturnScrollSubWnd.ReturnScroll_Town03_Btn");
	ReturnScroll_Town04_Btn = GetButtonHandle("YetiQuickSlotWnd.ReturnScrollSubWnd.ReturnScroll_Town04_Btn");
	ReturnScroll_Town01_Btn.SetTooltipType("text");
	ReturnScroll_Town02_Btn.SetTooltipType("text");
	ReturnScroll_Town03_Btn.SetTooltipType("text");
	ReturnScroll_Town04_Btn.SetTooltipType("text");
	return;
}

event Load()
{
	setServerTypeSetting();
	return;
}

function setServerTypeSetting()
{
	returningSpellbookArray.Remove(0, returningSpellbookArray.Length);
	returningSpellbookArray.Length = 4;
	ReturnScroll_Town01_Btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13088)));
	if(getInstanceUIData().GetIsLiveServer())
	{
		ReturnScroll_Town02_Btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13089)));
	}
	else
	{
		ReturnScroll_Town02_Btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13109)));
	}
	ReturnScroll_Town03_Btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13090)));
	ReturnScroll_Town04_Btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13091)));
	returningSpellbookArray[0].Name = GetSystemString(13088);
	if(getInstanceUIData().GetIsLiveServer())
	{
		returningSpellbookArray[1].Name = GetSystemString(13089);
	}
	else
	{
		returningSpellbookArray[1].Name = GetSystemString(13109);
	}
	returningSpellbookArray[2].Name = GetSystemString(13090);
	returningSpellbookArray[3].Name = GetSystemString(13091);
	if(getInstanceUIData().GetIsLiveServer())
	{
		setReturningSpellbookItemID(returningSpellbookArray[0].nItemIDArray, "736");
		setReturningSpellbookItemID(returningSpellbookArray[1].nItemIDArray, "1538,9156,33640");
		setReturningSpellbookItemID(returningSpellbookArray[2].nItemIDArray, "1829");
		setReturningSpellbookItemID(returningSpellbookArray[3].nItemIDArray, "1830");
	}
	else
	{
		setReturningSpellbookItemID(returningSpellbookArray[0].nItemIDArray, "736");
		setReturningSpellbookItemID(returningSpellbookArray[1].nItemIDArray, "91689,49500,49087");
		setReturningSpellbookItemID(returningSpellbookArray[2].nItemIDArray, "1829");
		setReturningSpellbookItemID(returningSpellbookArray[3].nItemIDArray, "1830");
	}
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "ReturnScrollSlot_Btn":
			OnReturnScrollSlot_BtnClick();
			break;
		case "ReturnScrollSlotSetting_Btn":
			OnReturnScrollSlotSetting_BtnClick();
			break;
		case "ViewPoint_Reset_Btn":
			OnViewPoint_Reset_BtnClick();
			break;
		case "ViewPoint_180_Btn":
			OnViewPoint_180_BtnClick();
			break;
		case "ReturnScroll_Town01_Btn":
		case "ReturnScroll_Town02_Btn":
		case "ReturnScroll_Town03_Btn":
		case "ReturnScroll_Town04_Btn":
			OnReturnScroll_Town_BtnClick(Name);
			break;
		case "Close_BTN":
			OnReturnScrollSlotSetting_BtnClick();
			break;
		default:
			break;
	}
	return;
}

event OnShow()
{
	setServerTypeSetting();
	GetINIInt("YetiQuickSlotWnd", "a", CURRENTITEMINDEX, "WindowsInfo.ini");
	ReturnScrollSubWnd.HideWindow();
	syncInventory();
	setItemButtonByIndex(CURRENTITEMINDEX);
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 9750:
			setServerTypeSetting();
			break;
		case 9570:
		case 2070:
			syncInventory();
			break;
		case 40:
					CURRENTITEMINDEX = -1;
			break;
		default:
			break;
	}
	return;
}

function setReturningSpellbookItemID(out array<int> nItemIDArray, string ArrayStr)
{
	local array<string> strItemIDArray;
	local int i;

	Split(ArrayStr, ",", strItemIDArray);
	nItemIDArray.Remove(0, nItemIDArray.Length);
	i = 0;
	while((i < strItemIDArray.Length))
	{
		nItemIDArray.Insert(nItemIDArray.Length, 1);
		nItemIDArray[(nItemIDArray.Length - 1)] = int(strItemIDArray[i]);
		i++;
	}
	return;
}

function syncInventory()
{
	local string itemCountStr;

	if(!Me.IsShowWindow())
	{
		return;
	}
	setItemButton(1, returningSpellbookArray[0].nItemIDArray, returningSpellbookArray[0].totalItemNum);
	setItemButton(2, returningSpellbookArray[1].nItemIDArray, returningSpellbookArray[1].totalItemNum);
	setItemButton(3, returningSpellbookArray[2].nItemIDArray, returningSpellbookArray[2].totalItemNum);
	setItemButton(4, returningSpellbookArray[3].nItemIDArray, returningSpellbookArray[3].totalItemNum);
	if((CURRENTITEMINDEX > -1))
	{
		if((returningSpellbookArray[CURRENTITEMINDEX].totalItemNum > INT64(99)))
		{
			itemCountStr = "+99";
		}
		else
		{
			itemCountStr = string(returningSpellbookArray[CURRENTITEMINDEX].totalItemNum);
		}
		if((returningSpellbookArray[CURRENTITEMINDEX].totalItemNum <= INT64(0)))
		{
			ReturnScrollSlot_num.SetText("");
			GetTextureHandle("YetiQuickSlotWnd.ReturnScroll_ItemIcon").HideWindow();
			ReturnScrollSlot_Btn.ClearTooltip();
			ReturnScrollSlot_Btn.DisableWindow();
			CURRENTITEMINDEX = -1;
		}
		else
		{
			ReturnScrollSlot_num.SetText(itemCountStr);
			ReturnScrollSlot_Btn.EnableWindow();
		}
	}
	return;
}

function setItemButton(int buttonIndex, array<int> nItemIDArray, out INT64 ItemCount)
{
	local array<ItemInfo> itemInfoArray;
	local string itemCountStr;
	local int i;

	ItemCount = INT64(0);
	i = 0;
	while((i < nItemIDArray.Length))
	{
		itemInfoArray.Remove(0, itemInfoArray.Length);
		Class'NWindow.UIDATA_INVENTORY'.static.FindItemByClassID(nItemIDArray[i], itemInfoArray);
		if((itemInfoArray.Length > 0))
		{
			ItemCount = (ItemCount + itemInfoArray[0].ItemNum);
		}
		i++;
	}
	if((ItemCount > INT64(0)))
	{
		GetButtonHandle((("YetiQuickSlotWnd.ReturnScrollSubWnd.ReturnScroll_Town0" $ string(buttonIndex)) $ "_Btn")).EnableWindow();
		if((ItemCount > INT64(99)))
		{
			itemCountStr = "+99";
		}
		else
		{
			itemCountStr = string(ItemCount);
		}
		GetTextBoxHandle((("YetiQuickSlotWnd.ReturnScrollSubWnd.ReturnScroll_Town0" $ string(buttonIndex)) $ "_num")).SetText(itemCountStr);
		if((ItemCount > INT64(0)))
		{
			GetTextureHandle((("YetiQuickSlotWnd.ReturnScrollSubWnd.ReturnScroll_Town0" $ string(buttonIndex)) $ "_ItemIcon")).ShowWindow();
		}
		else
		{
			GetTextureHandle((("YetiQuickSlotWnd.ReturnScrollSubWnd.ReturnScroll_Town0" $ string(buttonIndex)) $ "_ItemIcon")).HideWindow();
		}
	}
	else
	{
		GetButtonHandle((("YetiQuickSlotWnd.ReturnScrollSubWnd.ReturnScroll_Town0" $ string(buttonIndex)) $ "_Btn")).DisableWindow();
		GetTextBoxHandle((("YetiQuickSlotWnd.ReturnScrollSubWnd.ReturnScroll_Town0" $ string(buttonIndex)) $ "_num")).SetText("");
		GetTextureHandle((("YetiQuickSlotWnd.ReturnScrollSubWnd.ReturnScroll_Town0" $ string(buttonIndex)) $ "_ItemIcon")).HideWindow();
	}
	return;
}

function string getReturnSpellBookTextureName(int i)
{
	if((i == 0))
	{
		return "L2UI_CT1.YetiWnd.736_Yeti";
	}
	else if((i == 1))
	{
		return "L2UI_CT1.YetiWnd.1538_Yeti";
	}
	else if((i == 2))
	{
		return "L2UI_CT1.YetiWnd.1829_Yeti";
	}
	return "L2UI_CT1.YetiWnd.1830_Yeti";
}

function setItemButtonByIndex(int Index)
{
	local string itemCountStr;

	if((returningSpellbookArray[Index].totalItemNum > INT64(0)))
	{
		if((returningSpellbookArray[Index].totalItemNum > INT64(99)))
		{
			itemCountStr = "+99";
		}
		else
		{
			itemCountStr = string(returningSpellbookArray[Index].totalItemNum);
		}
		ReturnScrollSlot_num.SetText(itemCountStr);
		ReturnScrollSubWnd.HideWindow();
		GetTextureHandle("YetiQuickSlotWnd.ReturnScroll_ItemIcon").SetTexture(getReturnSpellBookTextureName(Index));
		GetTextureHandle("YetiQuickSlotWnd.ReturnScroll_ItemIcon").ShowWindow();
		ReturnScrollSlot_Btn.SetTooltipCustomType(MakeTooltipSimpleText(returningSpellbookArray[Index].Name));
		ReturnScrollSlot_Btn.EnableWindow();
	}
	else
	{
		ReturnScrollSlot_num.SetText("");
		GetTextureHandle("YetiQuickSlotWnd.ReturnScroll_ItemIcon").HideWindow();
		ReturnScrollSlot_Btn.ClearTooltip();
		CURRENTITEMINDEX = -1;
		ReturnScrollSlot_Btn.DisableWindow();
	}
	return;
}

function OnReturnScroll_Town_BtnClick(string buttonName)
{
	local string strID;
	local int Index;

	strID = Mid(buttonName, Len("ReturnScroll_Town0"), 1);
	Index = (int(strID) - 1);
	CURRENTITEMINDEX = Index;
	SetINIInt("YetiQuickSlotWnd", "a", CURRENTITEMINDEX, "WindowsInfo.ini");
	setItemButtonByIndex(CURRENTITEMINDEX);
	return;
}

function OnReturnScrollSlot_BtnClick()
{
	TryUseItem();
	return;
}

function TryUseItem()
{
	local int i;
	local ItemInfo tmItemInfo;

	if((CURRENTITEMINDEX > -1))
	{
		i = 0;
		while((i < returningSpellbookArray[CURRENTITEMINDEX].nItemIDArray.Length))
		{
			if(getIInventemInfoByClassID(returningSpellbookArray[CURRENTITEMINDEX].nItemIDArray[i], tmItemInfo))
			{
				if((tmItemInfo.ItemNum > INT64(0)))
				{
					RequestUseItem(tmItemInfo.Id);
					break;
				}
			}
			i++;
		}
	}
	return;
}

function bool getIInventemInfoByClassID(int ClassID, out ItemInfo outItemInfo)
{
	local array<ItemInfo> itemInfoArray;

	Class'NWindow.UIDATA_INVENTORY'.static.FindItemByClassID(ClassID, itemInfoArray);
	if((itemInfoArray.Length > 0))
	{
		outItemInfo = itemInfoArray[0];
		return true;
	}
	return false;
}

function OnReturnScrollSlotSetting_BtnClick()
{
	if(ReturnScrollSubWnd.IsShowWindow())
	{
		ReturnScrollSubWnd.HideWindow();
	}
	else
	{
		ReturnScrollSubWnd.ShowWindow();
	}
	return;
}

function OnViewPoint_Reset_BtnClick()
{
	Class'NWindow.ShortcutAPI'.static.ExecuteShortcutCommand("FixedDefaultCamera");
	return;
}

function OnViewPoint_180_BtnClick()
{
	Class'NWindow.ShortcutAPI'.static.ExecuteShortcutCommand("TurnBack");
	return;
}

