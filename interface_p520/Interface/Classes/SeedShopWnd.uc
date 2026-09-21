class SeedShopWnd extends UICommonAPI;

const DIALOG_TOP_TO_BOTTOM = 111;
const DIALOG_BOTTOM_TO_TOP = 222;
const DIALOG_PREVIEW = 333;

enum ShopType
{
	ShopNone,                       // 0
	ShopBuy,                        // 1
	ShopSell,                       // 2
	ShopPreview                     // 3
};

var string m_Windowname;
var ShopType m_shopType;
var int m_merchantID;
var int m_npcID;
var INT64 m_currentPrice;

function OnRegisterEvent()
{
	RegisterEvent(2080);
	RegisterEvent(2090);
	RegisterEvent(1710);
	return;
}

function OnLoad()
{
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	return;
}

function Clear()
{
	m_shopType = ShopNone;
	m_merchantID = -1;
	m_npcID = -1;
	m_currentPrice = INT64(0);
	Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear((m_Windowname $ ".TopList"));
	Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear((m_Windowname $ ".BottomList"));
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".PriceText"), "0");
	Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString((m_Windowname $ ".PriceText"), "");
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".AdenaText"), "0");
	Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString((m_Windowname $ ".AdenaText"), "");
	Class'NWindow.UIAPI_INVENWEIGHT'.static.ZeroWeight((m_Windowname $ ".InvenWeight"));
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 2080:
			HandleOpenWindow(param);
			break;
		case 2090:
			HandleAddItem(param);
			break;
		case 1710:
			HandleDialogOK();
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string ControlName)
{
	local int Index;

	if((ControlName == "UpButton"))
	{
		Index = Class'NWindow.UIAPI_ITEMWINDOW'.static.GetSelectedNum((m_Windowname $ ".BottomList"));
		MoveItemBottomToTop(Index, false);
	}
	else if((ControlName == "DownButton"))
	{
		Index = Class'NWindow.UIAPI_ITEMWINDOW'.static.GetSelectedNum((m_Windowname $ ".TopList"));
		MoveItemTopToBottom(Index, false);
	}
	else if((ControlName == "OKButton"))
	{
		HandleOKButton();
	}
	else if((ControlName == "CancelButton"))
	{
		Clear();
		HideWindow(m_Windowname);
	}
	return;
}

function OnDBClickItem(string ControlName, int Index)
{
	if((ControlName == "TopList"))
	{
		MoveItemTopToBottom(Index, false);
	}
	else if((ControlName == "BottomList"))
	{
		MoveItemBottomToTop(Index, Class'NWindow.InputAPI'.static.IsAltPressed());
	}
	return;
}

function OnDropItem(string strID, ItemInfo Info, int X, int Y)
{
	local int Index;

	if(((strID == "TopList") && (Info.DragSrcName == "BottomList")))
	{
		Index = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem((m_Windowname $ ".BottomList"), Info.Id);
		if((Index >= 0))
		{
			MoveItemBottomToTop(Index, (Info.AllItemCount > INT64(0)));
		}
	}
	else if(((strID == "BottomList") && (Info.DragSrcName == "TopList")))
	{
		Index = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem((m_Windowname $ ".TopList"), Info.Id);
		if((Index >= 0))
		{
			MoveItemTopToBottom(Index, (Info.AllItemCount > INT64(0)));
		}
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
			DialogSetDefaultOK();
			if((int(m_shopType) == 2))
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
				Info.ItemNum = INT64(1);
				Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem((m_Windowname $ ".BottomList"), Info);
				Class'NWindow.UIAPI_INVENWEIGHT'.static.AddWeight((m_Windowname $ ".InvenWeight"), (INT64(Info.Weight) * Info.ItemNum));
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

function MoveItemBottomToTop(int Index, bool bAllItem)
{
	local ItemInfo Info, info2;
	local int bottomIndex;

	if(Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem((m_Windowname $ ".BottomList"), Index, Info))
	{
		if(((!bAllItem && IsStackableItem(Info.ConsumeType)) && (Info.ItemNum != INT64(1))))
		{
			DialogSetID(222);
			DialogSetDefaultOK();
			DialogSetReservedItemID(Info.Id);
			DialogSetParamInt64(Info.ItemNum);
			DialogSetDefaultOK();
			DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), Info.Name, ""));
		}
		else
		{
			Class'NWindow.UIAPI_ITEMWINDOW'.static.DeleteItem((m_Windowname $ ".BottomList"), Index);
			if((int(m_shopType) == 2))
			{
				bottomIndex = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem((m_Windowname $ ".TopList"), Info.Id);
				if((bottomIndex == -1))
				{
					Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem((m_Windowname $ ".TopList"), Info);
				}
				else
				{
					Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem((m_Windowname $ ".TopList"), bottomIndex, info2);
					(info2.ItemNum += Info.ItemNum);
					Class'NWindow.UIAPI_ITEMWINDOW'.static.SetItem((m_Windowname $ ".TopList"), bottomIndex, info2);
				}
			}
			else if((int(m_shopType) == 1))
			{
				Class'NWindow.UIAPI_INVENWEIGHT'.static.ReduceWeight((m_Windowname $ ".InvenWeight"), (INT64(Info.Weight) * Info.ItemNum));
			}
			AddPrice((-Info.Price * Info.ItemNum));
		}
	}
	return;
}

function HandleDialogOK()
{
	local int Id, Index, topIndex;
	local INT64 Num;
	local ItemInfo Info, topInfo;
	local string param;
	local ItemID cID;

	if(DialogIsMine())
	{
		Id = DialogGetID();
		Num = INT64(DialogGetString());
		cID = DialogGetReservedItemID();
		if(((Id == 111) && (Num > INT64(0))))
		{
			topIndex = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem((m_Windowname $ ".TopList"), cID);
			if((topIndex >= 0))
			{
				Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem((m_Windowname $ ".TopList"), topIndex, topInfo);
				if((int(m_shopType) == 2))
				{
					if((topInfo.ItemNum < Num))
					{
						Num = topInfo.ItemNum;
					}
				}
				Index = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem((m_Windowname $ ".BottomList"), cID);
				if((Index >= 0))
				{
					Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem((m_Windowname $ ".BottomList"), Index, Info);
					(Info.ItemNum += Num);
					Class'NWindow.UIAPI_ITEMWINDOW'.static.SetItem((m_Windowname $ ".BottomList"), Index, Info);
					AddPrice((Num * Info.Price));
				}
				else
				{
					Info = topInfo;
					Info.ItemNum = Num;
					Info.bShowCount = false;
					Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem((m_Windowname $ ".BottomList"), Info);
					AddPrice((Num * Info.Price));
				}
				if((int(m_shopType) == 2))
				{
					(topInfo.ItemNum -= Num);
					if((topInfo.ItemNum <= INT64(0)))
					{
						Class'NWindow.UIAPI_ITEMWINDOW'.static.DeleteItem((m_Windowname $ ".TopList"), topIndex);
					}
					else
					{
						Class'NWindow.UIAPI_ITEMWINDOW'.static.SetItem((m_Windowname $ ".TopList"), topIndex, topInfo);
					}
				}
				else if((int(m_shopType) == 1))
				{
					Class'NWindow.UIAPI_INVENWEIGHT'.static.AddWeight((m_Windowname $ ".InvenWeight"), (INT64(Info.Weight) * Num));
				}
			}
		}
		else if(((Id == 222) && (Num > INT64(0))))
		{
			Index = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem((m_Windowname $ ".BottomList"), cID);
			if((Index >= 0))
			{
				Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem((m_Windowname $ ".BottomList"), Index, Info);
				(Info.ItemNum -= Num);
				if((Info.ItemNum > INT64(0)))
				{
					Class'NWindow.UIAPI_ITEMWINDOW'.static.SetItem((m_Windowname $ ".BottomList"), Index, Info);
				}
				else
				{
					Class'NWindow.UIAPI_ITEMWINDOW'.static.DeleteItem((m_Windowname $ ".BottomList"), Index);
				}
				if((int(m_shopType) == 2))
				{
					topIndex = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem((m_Windowname $ ".TopList"), cID);
					if(((topIndex >= 0) && IsStackableItem(Info.ConsumeType)))
					{
						Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem((m_Windowname $ ".TopList"), topIndex, topInfo);
						(topInfo.ItemNum += Num);
						Class'NWindow.UIAPI_ITEMWINDOW'.static.SetItem((m_Windowname $ ".TopList"), topIndex, topInfo);
					}
					else
					{
						Info.ItemNum = Num;
						Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem((m_Windowname $ ".TopList"), Info);
					}
				}
				else if((int(m_shopType) == 1))
				{
					Class'NWindow.UIAPI_INVENWEIGHT'.static.ReduceWeight((m_Windowname $ ".InvenWeight"), (INT64(Info.Weight) * Num));
				}
				if((Info.ItemNum <= INT64(0)))
				{
					Num = (Info.ItemNum + Num);
				}
				AddPrice((-Num * Info.Price));
			}
		}
		else if((Id == 333))
		{
			Num = INT64(Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItemNum((m_Windowname $ ".BottomList")));
			if((Num > INT64(0)))
			{
				ParamAdd(param, "merchant", string(m_merchantID));
				ParamAdd(param, "npc", string(m_npcID));
				ParamAdd(param, "num", string(Num));
				Index = 0;
				while((INT64(Index) < Num))
				{
					Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem((m_Windowname $ ".BottomList"), Index, Info);
					ParamAddItemIDWithIndex(param, Info.Id, Index);
					++Index;
				}
				RequestPreviewItem(param);
			}
		}
	}
	return;
}

function HandleOpenWindow(string param)
{
	local string Type;
	local INT64 Adena;
	local string Adenastring;
	local WindowHandle m_inventoryWnd;

	if((1 == 0))
	{
		m_inventoryWnd = GetHandle("InventoryWnd");
	}
	else
	{
		m_inventoryWnd = GetWindowHandle("InventoryWnd");
	}
	Clear();
	ParseString(param, "type", Type);
	ParseInt(param, "merchant", m_merchantID);
	ParseINT64(param, "adena", Adena);
	if((Type == "buy"))
	{
		m_shopType = ShopBuy;
	}
	else if((Type == "sell"))
	{
		m_shopType = ShopSell;
	}
	else if((Type == "preview"))
	{
		m_shopType = ShopPreview;
	}
	else
	{
		m_shopType = ShopNone;
	}
	Adenastring = MakeCostString(string(Adena));
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".AdenaText"), Adenastring);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString((m_Windowname $ ".AdenaText"), ConvertNumToText(string(Adena)));
	ShowWindow(m_Windowname);
	Class'NWindow.UIAPI_WINDOW'.static.SetFocus(m_Windowname);
	if((Type == "buy"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.SetTooltipType((m_Windowname $ ".TopList"), "InventoryPrice1HideEnchantStackable");
		Class'NWindow.UIAPI_WINDOW'.static.SetTooltipType((m_Windowname $ ".BottomList"), "InventoryPrice1");
		setWindowTitleBySysStringNum(136);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".TopText"), GetSystemString(137));
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".BottomText"), GetSystemString(139));
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".PriceConstText"), GetSystemString(142));
	}
	else if((Type == "sell"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.SetTooltipType((m_Windowname $ ".TopList"), "InventoryPrice2");
		Class'NWindow.UIAPI_WINDOW'.static.SetTooltipType((m_Windowname $ ".BottomList"), "InventoryPrice2");
		setWindowTitleBySysStringNum(136);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".TopText"), GetSystemString(138));
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".BottomText"), GetSystemString(137));
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".PriceConstText"), GetSystemString(143));
	}
	else if((Type == "preview"))
	{
		ParseInt(param, "npc", m_npcID);
		Class'NWindow.UIAPI_WINDOW'.static.SetTooltipType((m_Windowname $ ".TopList"), "InventoryPrice1HideEnchantStackable");
		Class'NWindow.UIAPI_WINDOW'.static.SetTooltipType((m_Windowname $ ".BottomList"), "InventoryPrice1");
		setWindowTitleBySysStringNum(847);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".TopText"), GetSystemString(811));
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".BottomText"), GetSystemString(812));
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".PriceConstText"), GetSystemString(813));
	}
	return;
}

function HandleAddItem(string param)
{
	local ItemInfo Info;

	ParamToItemInfo(param, Info);
	if(((int(m_shopType) == 1) && (Info.ItemNum > INT64(0))))
	{
		Info.bShowCount = true;
	}
	Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem((m_Windowname $ ".TopList"), Info);
	return;
}

function AddPrice(INT64 Price)
{
	local string Adena;

	m_currentPrice = (m_currentPrice + Price);
	Adena = MakeCostStringINT64(m_currentPrice);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".PriceText"), Adena);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString((m_Windowname $ ".PriceText"), ConvertNumToText(string(m_currentPrice)));
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
		RequestBuyItem(param);
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
		RequestSellItem(param);
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

defaultproperties
{
	m_Windowname="ShopWnd"
}
