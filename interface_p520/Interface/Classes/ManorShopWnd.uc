class ManorShopWnd extends SeedShopWnd;

var InventoryWnd inventoryWndScript;

event OnRegisterEvent()
{
	RegisterEvent(2680);
	RegisterEvent(2690);
	RegisterEvent(1710);
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	inventoryWndScript = InventoryWnd(GetScript("InventoryWnd"));
	return;
}

event OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 2680:
			HandleOpenWindow(param);
			updateInventoryItemCountText();
			break;
		case 2690:
			HandleAddItem(param);
			updateInventoryItemCountText();
			break;
		case 1710:
			if(!DialogIsMine())
			{
				return;
			}
			if(!m_hOwnerWnd.IsShowWindow())
			{
				return;
			}
			HandleDialogOK();
			updateInventoryItemCountText();
			break;
		default:
			break;
	}
	return;
}

function MoveItemTopToBottom(int Index, bool bAllItem)
{
	local int bottomIndex;
	local ItemInfo Info, bottomInfo;

	if(Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem((m_Windowname $ ".TopList"), Index, Info))
	{
		if(((!bAllItem && IsStackableItem(Info.ConsumeType)) && (Info.ItemNum != INT64(1))))
		{
			DialogSetID(111);
			DialogSetReservedItemID(Info.Id);
			if(((int(m_shopType) == 2) || (int(m_shopType) == 1)))
			{
				DialogSetParamInt64(Info.ItemNum);
			}
			else
			{
				DialogSetParamInt64(INT64(-1));
			}
			DialogSetDefaultOK();
			DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), Info.Name, ""));
		}
		else
		{
			Info.bShowCount = false;
			if((int(m_shopType) == 2))
			{
				bottomIndex = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem((m_Windowname $ ".BottomList"), Info.Id);
				if(((bottomIndex >= 0) && IsStackableItem(Info.ConsumeType)))
				{
					Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem((m_Windowname $ ".BottomList"), bottomIndex, bottomInfo);
					(bottomInfo.ItemNum += Info.ItemNum);
					Class'NWindow.UIAPI_ITEMWINDOW'.static.SetItem((m_Windowname $ ".BottomList"), bottomIndex, bottomInfo);
				}
				else
				{
					Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem((m_Windowname $ ".BottomList"), Info);
				}
				Class'NWindow.UIAPI_ITEMWINDOW'.static.DeleteItem((m_Windowname $ ".TopList"), Index);
			}
			else if((int(m_shopType) == 1))
			{
				bottomIndex = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem((m_Windowname $ ".BottomList"), Info.Id);
				if(((bottomIndex >= 0) && IsStackableItem(Info.ConsumeType)))
				{
					Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem((m_Windowname $ ".BottomList"), bottomIndex, bottomInfo);
					(bottomInfo.ItemNum += Info.ItemNum);
					Class'NWindow.UIAPI_ITEMWINDOW'.static.SetItem((m_Windowname $ ".BottomList"), bottomIndex, bottomInfo);
				}
				else
				{
					Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem((m_Windowname $ ".BottomList"), Info);
					Class'NWindow.UIAPI_INVENWEIGHT'.static.AddWeight((m_Windowname $ ".InvenWeight"), (INT64(Info.Weight) * Info.ItemNum));
				}
				if(bAllItem)
				{
					Class'NWindow.UIAPI_ITEMWINDOW'.static.DeleteItem((m_Windowname $ ".TopList"), Index);
				}
			}
			else if((int(m_shopType) == 3))
			{
				bottomIndex = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem((m_Windowname $ ".BottomList"), Info.Id);
				Info.ItemNum = INT64(1);
				Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem((m_Windowname $ ".BottomList"), Info);
			}
			AddPrice((Info.Price * Info.ItemNum));
		}
	}
	return;
}

function HandleOpenWindow(string param)
{
	super.HandleOpenWindow(param);
	setWindowTitleBySysStringNum(738);
	Class'NWindow.UIAPI_WINDOW'.static.SetTooltipType((m_Windowname $ ".TopList"), "InventoryPrice1HideEnchant");
	return;
}

function HandleAddItem(string param)
{
	local ItemInfo Info;

	ParamToItemInfo(param, Info);
	Info.bShowCount = false;
	Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem((m_Windowname $ ".TopList"), Info);
	return;
}

function HandleOKButton()
{
	local string param;
	local int topCount, bottomCount, topIndex, bottomIndex;
	local ItemInfo topInfo, bottomInfo;
	local INT64 limitedItemCount;

	bottomCount = Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItemNum((m_Windowname $ ".BottomList"));
	if((int(m_shopType) == 1))
	{
		topCount = Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItemNum((m_Windowname $ ".TopList"));
		topIndex = 0;
		while((topIndex < topCount))
		{
			Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem((m_Windowname $ ".TopList"), topIndex, topInfo);
			if((topInfo.ItemNum > INT64(0)))
			{
				limitedItemCount = INT64(0);
				bottomCount = Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItemNum((m_Windowname $ ".BottomList"));
				bottomIndex = 0;
				while((bottomIndex < bottomCount))
				{
					Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem((m_Windowname $ ".BottomList"), bottomIndex, bottomInfo);
					if(IsSameClassID(bottomInfo.Id, topInfo.Id))
					{
						(limitedItemCount += bottomInfo.ItemNum);
					}
					++bottomIndex;
				}
				if((limitedItemCount > topInfo.ItemNum))
				{
					DialogShow(DialogModalType_Modalless, DialogType_Warning, GetSystemMessage(1338));
					return;
				}
			}
			++topIndex;
		}
		ParamAdd(param, "merchant", string(m_merchantID));
		ParamAdd(param, "num", string(bottomCount));
		bottomIndex = 0;
		while((bottomIndex < bottomCount))
		{
			Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem((m_Windowname $ ".BottomList"), bottomIndex, bottomInfo);
			ParamAddItemIDWithIndex(param, bottomInfo.Id, bottomIndex);
			ParamAdd(param, ("Count_" $ string(bottomIndex)), string(bottomInfo.ItemNum));
			++bottomIndex;
		}
		RequestBuySeed(param);
	}
	else if((int(m_shopType) == 2))
	{
		ParamAdd(param, "merchant", string(m_merchantID));
		ParamAdd(param, "num", string(bottomCount));
		bottomIndex = 0;
		while((bottomIndex < bottomCount))
		{
			Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem((m_Windowname $ ".BottomList"), bottomIndex, bottomInfo);
			ParamAddItemIDWithIndex(param, bottomInfo.Id, bottomIndex);
			ParamAdd(param, ("Count_" $ string(bottomIndex)), string(bottomInfo.ItemNum));
			++bottomIndex;
		}
	}
	else if((int(m_shopType) == 3))
	{
		if((bottomCount > 0))
		{
			DialogSetID(333);
			DialogShow(DialogModalType_Modalless, DialogType_Warning, GetSystemMessage(1157));
		}
	}
	HideWindow(m_Windowname);
	return;
}

function updateInventoryItemCountText()
{
	local int Count, invenCount;

	Count = inventoryWndScript.getCurrentInventoryItemCount();
	invenCount = Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItemNum((m_Windowname $ ".BottomList"));
	GetTextBoxHandle((m_Windowname $ ".ItemCount")).SetText((((("(" $ string(invenCount)) $ "/") $ string(Count)) $ ")"));
	return;
}

function OnReceivedCloseUI()
{
	Clear();
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="ManorShopWnd"
}
