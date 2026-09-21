class DeliverWnd extends UICommonAPI;

const DIALOG_TOP_TO_BOTTOM = 111;
const DIALOG_BOTTOM_TO_TOP = 222;

var int m_targetID;

function OnRegisterEvent()
{
	RegisterEvent(2160);
	RegisterEvent(2170);
	RegisterEvent(1710);
	return;
}

function OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	return;
}

function Clear()
{
	Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear("DeliverWnd.TopList");
	Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear("DeliverWnd.BottomList");
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("DeliverWnd.PriceText", "0");
	Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString("DeliverWnd.PriceText", "");
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("DeliverWnd.AdenaText", "0");
	Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString("DeliverWnd.AdenaText", "");
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 2160:
			HandleOpenWindow(param);
			break;
		case 2170:
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
		Index = Class'NWindow.UIAPI_ITEMWINDOW'.static.GetSelectedNum("DeliverWnd.BottomList");
		MoveItemBottomToTop(Index, INT64(0));
	}
	else if((ControlName == "DownButton"))
	{
		Index = Class'NWindow.UIAPI_ITEMWINDOW'.static.GetSelectedNum("DeliverWnd.TopList");
		MoveItemTopToBottom(Index, INT64(0));
	}
	else if((ControlName == "OKButton"))
	{
		HandleOKButton();
	}
	else if((ControlName == "CancelButton"))
	{
		Clear();
		HideWindow("DeliverWnd");
	}
	return;
}

function OnDBClickItem(string ControlName, int Index)
{
	local ItemInfo Info;

	if(Class'NWindow.InputAPI'.static.IsAltPressed())
	{
		GetMeItemWindow(ControlName).GetItem(Index, Info);
	}
	if((ControlName == "TopList"))
	{
		MoveItemTopToBottom(Index, Info.ItemNum);
	}
	else if((ControlName == "BottomList"))
	{
		MoveItemBottomToTop(Index, Info.ItemNum);
	}
	return;
}

function OnClickItem(string ControlName, int Index)
{
	local WindowHandle m_dialogWnd;

	if((1 == 0))
	{
		m_dialogWnd = GetHandle("DialogBox");
	}
	else
	{
		m_dialogWnd = GetWindowHandle("DialogBox");
	}
	if((ControlName == "TopList"))
	{
		if((DialogIsMine() && m_dialogWnd.IsShowWindow()))
		{
			DialogHide();
			m_dialogWnd.HideWindow();
		}
	}
	return;
}

function OnDropItem(string strID, ItemInfo Info, int X, int Y)
{
	local int Index;

	if(((strID == "TopList") && (Info.DragSrcName == "BottomList")))
	{
		Index = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem("DeliverWnd.BottomList", Info.Id);
		if((Index >= 0))
		{
			MoveItemBottomToTop(Index, Info.AllItemCount);
		}
	}
	else if(((strID == "BottomList") && (Info.DragSrcName == "TopList")))
	{
		Index = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem("DeliverWnd.TopList", Info.Id);
		if((Index >= 0))
		{
			MoveItemTopToBottom(Index, Info.AllItemCount);
		}
	}
	return;
}

function MoveItemTopToBottom(int Index, INT64 AllItemCount)
{
	local ItemInfo Info;

	if(Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("DeliverWnd.TopList", Index, Info))
	{
		if((IsStackableItem(Info.ConsumeType) && (Info.ItemNum > INT64(1))))
		{
			if((AllItemCount > INT64(0)))
			{
				ItemTopToBottom(Info.Id, AllItemCount);
				AdjustPrice();
			}
			else
			{
				DialogSetID(111);
				DialogSetReservedItemID(Info.Id);
				DialogSetParamInt64(Info.ItemNum);
				DialogSetDefaultOK();
				DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), Info.Name, ""));
			}
		}
		else
		{
			Info.ItemNum = INT64(1);
			Info.bShowCount = false;
			Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem("DeliverWnd.BottomList", Info);
			Class'NWindow.UIAPI_ITEMWINDOW'.static.DeleteItem("DeliverWnd.TopList", Index);
			AdjustPrice();
		}
	}
	return;
}

function MoveItemBottomToTop(int Index, INT64 AllItemCount)
{
	local ItemInfo Info;

	if(Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("DeliverWnd.BottomList", Index, Info))
	{
		if((IsStackableItem(Info.ConsumeType) && (Info.ItemNum > INT64(1))))
		{
			if((AllItemCount > INT64(0)))
			{
				ItemBottomToTop(Info.Id, AllItemCount);
				AdjustPrice();
			}
			else
			{
				DialogSetID(222);
				DialogSetReservedItemID(Info.Id);
				DialogSetParamInt64(Info.ItemNum);
				DialogSetDefaultOK();
				DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), Info.Name, ""));
			}
		}
		else
		{
			Class'NWindow.UIAPI_ITEMWINDOW'.static.DeleteItem("DeliverWnd.BottomList", Index);
			Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem("DeliverWnd.TopList", Info);
			AdjustPrice();
		}
	}
	return;
}

function HandleDialogOK()
{
	local int Id;
	local INT64 Num;
	local ItemID cID;

	if(DialogIsMine())
	{
		Id = DialogGetID();
		Num = INT64(DialogGetString());
		cID = DialogGetReservedItemID();
		if(((Id == 111) && (Num > INT64(0))))
		{
			ItemTopToBottom(cID, Num);
		}
		else if(((Id == 222) && (Num > INT64(0))))
		{
			ItemBottomToTop(cID, Num);
		}
		AdjustPrice();
	}
	return;
}

function ItemTopToBottom(ItemID cID, INT64 Num)
{
	local int Index, topIndex;
	local ItemInfo Info, topInfo;

	topIndex = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem("DeliverWnd.TopList", cID);
	if((topIndex >= 0))
	{
		Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("DeliverWnd.TopList", topIndex, topInfo);
		Index = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem("DeliverWnd.BottomList", cID);
		if((Index >= 0))
		{
			Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("DeliverWnd.BottomList", Index, Info);
			(Info.ItemNum += Num);
			Class'NWindow.UIAPI_ITEMWINDOW'.static.SetItem("DeliverWnd.BottomList", Index, Info);
		}
		else
		{
			Info = topInfo;
			Info.ItemNum = Num;
			Info.bShowCount = false;
			Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem("DeliverWnd.BottomList", Info);
		}
		(topInfo.ItemNum -= Num);
		if((topInfo.ItemNum <= INT64(0)))
		{
			Class'NWindow.UIAPI_ITEMWINDOW'.static.DeleteItem("DeliverWnd.TopList", topIndex);
		}
		else
		{
			Class'NWindow.UIAPI_ITEMWINDOW'.static.SetItem("DeliverWnd.TopList", topIndex, topInfo);
		}
	}
	return;
}

function ItemBottomToTop(ItemID cID, INT64 Num)
{
	local int Index, topIndex;
	local ItemInfo Info, topInfo;

	Index = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem("DeliverWnd.BottomList", cID);
	if((Index >= 0))
	{
		Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("DeliverWnd.BottomList", Index, Info);
		(Info.ItemNum -= Num);
		if((Info.ItemNum > INT64(0)))
		{
			Class'NWindow.UIAPI_ITEMWINDOW'.static.SetItem("DeliverWnd.BottomList", Index, Info);
		}
		else
		{
			Class'NWindow.UIAPI_ITEMWINDOW'.static.DeleteItem("DeliverWnd.BottomList", Index);
		}
		topIndex = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem("DeliverWnd.TopList", cID);
		if(((topIndex >= 0) && IsStackableItem(Info.ConsumeType)))
		{
			Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("DeliverWnd.TopList", topIndex, topInfo);
			(topInfo.ItemNum += Num);
			Class'NWindow.UIAPI_ITEMWINDOW'.static.SetItem("DeliverWnd.TopList", topIndex, topInfo);
		}
		else
		{
			Info.ItemNum = Num;
			Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem("DeliverWnd.TopList", Info);
		}
	}
	return;
}

function HandleOpenWindow(string param)
{
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
	ParseINT64(param, "adena", Adena);
	ParseInt(param, "destinationID", m_targetID);
	Adenastring = MakeCostString(string(Adena));
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("DeliverWnd.AdenaText", Adenastring);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString("DeliverWnd.AdenaText", ConvertNumToText(string(Adena)));
	ShowWindow("DeliverWnd");
	Class'NWindow.UIAPI_WINDOW'.static.SetFocus("DeliverWnd");
	return;
}

function HandleAddItem(string param)
{
	local ItemInfo Info;

	ParamToItemInfo(param, Info);
	if((isDamagedItem(Info) == false))
	{
		Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem("DeliverWnd.TopList", Info);
	}
	return;
}

function AdjustPrice()
{
	local string Adena;
	local int Count;

	Count = Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItemNum("DeliverWnd.BottomList");
	Adena = MakeCostString(string((Count * 1000)));
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("DeliverWnd.PriceText", Adena);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString("DeliverWnd.PriceText", ConvertNumToText(string((Count * 1000))));
	return;
}

function HandleOKButton()
{
	local string param;
	local int Count, Index;
	local ItemInfo ItemInfo;

	Count = Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItemNum("DeliverWnd.BottomList");
	ParamAdd(param, "targetID", string(m_targetID));
	ParamAdd(param, "num", string(Count));
	Index = 0;
	while((Index < Count))
	{
		Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("DeliverWnd.BottomList", Index, ItemInfo);
		ParamAdd(param, ("dbID" $ string(Index)), string(ItemInfo.Reserved));
		ParamAdd(param, ("count" $ string(Index)), string(ItemInfo.ItemNum));
		++Index;
	}
	RequestPackageSend(param);
	HideWindow("DeliverWnd");
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	OnClickButton("CancelButton");
	return;
}
