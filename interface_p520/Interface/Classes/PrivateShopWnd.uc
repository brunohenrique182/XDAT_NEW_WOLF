class PrivateShopWnd extends UICommonAPI;

const DIALOG_TOP_TO_BOTTOM = 111;
const DIALOG_BOTTOM_TO_TOP = 222;
const DIALOG_ASK_PRICE = 333;
const DIALOG_CONFIRM_PRICE = 444;
const DIALOG_EDIT_SHOP_MESSAGE = 555;
const DIALOG_CONFIRM_PRICE_FINAL = 666;
const DIALOG_EDIT_BULK_SHOP_MESSAGE = 888;

enum PrivateShopType
{
	PT_NONE,                        // 0
	PT_Buy,                         // 1
	PT_Sell,                        // 2
	PT_BuyList,                     // 3
	PT_SellList                     // 4
};

var string m_Windowname;
var PrivateShopType m_type;
var bool m_bBulk;
var int m_merchantID;
var int m_buyMaxCount;
var int m_sellMaxCount;
var int m_curInventoryCount;
var int m_maxInventoryCount;
var int m_numPossibleSlotCount;
var PrivateShopType lastPrivateShopTypeSave;
var bool lastPrivateShopTypemBulk;
var bool stopSellFlag;
var ItemWindowHandle m_hPrivateShopWndTopList;
var ItemWindowHandle m_hPrivateShopWndBottomList;
var bool m_IsPrivateStoreBypass;

function OnRegisterEvent()
{
	RegisterEvent(2120);
	RegisterEvent(2130);
	RegisterEvent(2070);
	RegisterEvent(1710);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	m_hPrivateShopWndTopList = GetItemWindowHandle("PrivateShopWnd.TopList");
	m_hPrivateShopWndBottomList = GetItemWindowHandle("PrivateShopWnd.BottomList");
	m_merchantID = 0;
	m_buyMaxCount = 0;
	m_sellMaxCount = 0;
	m_IsPrivateStoreBypass = IsPrivateStoreBypass();
	return;
}

function OnSendPacketWhenHiding()
{
	RequestQuit();
	return;
}

function OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	GetWindowHandle("PrivateShopWndReport").HideWindow();
	return;
}

function OnHide()
{
	local DialogBox DialogBox;

	lastPrivateShopTypeSave = m_type;
	lastPrivateShopTypemBulk = m_bBulk;
	DialogBox = DialogBox(GetScript("DialogBox"));
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("DialogBox"))
	{
		if(DialogIsMine())
		{
			DialogBox.HandleCancel();
		}
	}
	Clear();
	if(GetWindowHandle("InventoryViewer").IsShowWindow())
	{
		GetWindowHandle("InventoryViewer").HideWindow();
	}
	return;
}

function contextMenuQuit()
{
	if((int(lastPrivateShopTypeSave) == 3))
	{
		ExecuteCommandFromAction("buy");
	}
	else if(((int(lastPrivateShopTypeSave) == 4) && !lastPrivateShopTypemBulk))
	{
		ExecuteCommandFromAction("vendor");
	}
	else if(((int(lastPrivateShopTypeSave) == 4) && lastPrivateShopTypemBulk))
	{
		ExecuteCommandFromAction("packagevendor");
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 2120:
			Clear();
			HandleOpenWindow(param);
			break;
		case 2130:
			HandleAddItem(param);
			break;
		case 2070:
			HandleSetMaxCount(param);
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
		Index = m_hPrivateShopWndBottomList.GetSelectedNum();
		MoveItemBottomToTop(Index, false);
	}
	else if((ControlName == "DownButton"))
	{
		Index = m_hPrivateShopWndTopList.GetSelectedNum();
		MoveItemTopToBottom(Index, false);
	}
	else if((ControlName == "OKButton"))
	{
		HandleOKButton(true);
	}
	else if((ControlName == "StopButton"))
	{
		RequestQuit();
		HideWindow("PrivateShopWnd");
	}
	else if((ControlName == "MessageButton"))
	{
		if(m_IsPrivateStoreBypass)
		{
			return;
		}
		DialogSetDefaultOK();
		DialogSetEditBoxMaxLength(29);
		DialogSetID(555);
		DialogShow(DialogModalType_Modalless, DialogType_OKCancelInput, GetSystemMessage(334));
		if(((int(m_type) == 4) && !m_bBulk))
		{
			DialogSetString(GetPrivateShopMessage("sell"));
		}
		else if(((int(m_type) == 4) && m_bBulk))
		{
			DialogSetString(GetPrivateShopMessage("bulksell"));
		}
		else if((int(m_type) == 3))
		{
			DialogSetString(GetPrivateShopMessage("buy"));
		}
	}
	else if((ControlName == "SortButton"))
	{
		getInstanceL2Util().SortItem(m_hPrivateShopWndTopList);
	}
	else if((ControlName == "InventoryViewerCall_Button"))
	{
		getInstanceInventoryViewer().showWindowByParentWindow(GetWindowHandle(getCurrentWindowName(string(self))), true);
	}
	else if((ControlName == "history_Btn"))
	{
		if(m_IsPrivateStoreBypass)
		{
			return;
		}
		if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("PrivateShopWndHistory"))
		{
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow("PrivateShopWndHistory");
		}
		else
		{
			Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("PrivateShopWndHistory");
		}
	}
	return;
}

function OnDBClickItem(string ControlName, int Index)
{
	local ItemInfo Info;

	if((ControlName == "TopList"))
	{
		m_hPrivateShopWndTopList.GetSelectedItem(Info);
		if(((int(m_type) == 1) && (m_bBulk == true)))
		{
			if(((m_hPrivateShopWndTopList.GetItemNum() <= m_numPossibleSlotCount) || IsStackableItem(Info.ConsumeType)))
			{
				MoveItemTopToBottom(Index, false);
			}
			else if(((int(m_type) == 2) || (int(m_type) == 4)))
			{
				AddSystemMessage(3676);
			}
			else
			{
				AddSystemMessage(3675);
			}
		}
		else if(((m_numPossibleSlotCount > m_hPrivateShopWndBottomList.GetItemNum()) || (IsStackableItem(Info.ConsumeType) && (int(m_type) != 4))))
		{
			if((IsStackableItem(Info.ConsumeType) && (int(m_type) != 2)))
			{
				MoveItemTopToBottom(Index, Class'NWindow.InputAPI'.static.IsAltPressed());
			}
			else
			{
				MoveItemTopToBottom(Index, false);
			}
		}
		else if((int(m_type) == 3))
		{
			AddSystemMessage(3676);
		}
		else if(((int(m_type) == 2) || (int(m_type) == 4)))
		{
			AddSystemMessage(3676);
		}
		else
		{
			AddSystemMessage(3675);
		}
	}
	else if((ControlName == "BottomList"))
	{
		MoveItemBottomToTop(Index, Class'NWindow.InputAPI'.static.IsAltPressed());
	}
	return;
}

function OnClickItem(string ControlName, int Index)
{
	local WindowHandle m_dialogWnd;

	m_dialogWnd = GetWindowHandle("DialogBox");
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

	Index = -1;
	if(((strID == "TopList") && (Info.DragSrcName == "BottomList")))
	{
		if(((int(m_type) == 1) || (int(m_type) == 4)))
		{
			Index = m_hPrivateShopWndBottomList.FindItem(Info.Id);
		}
		else if(((int(m_type) == 2) || (int(m_type) == 3)))
		{
			Index = m_hPrivateShopWndBottomList.FindItemWithAllProperty(Info);
		}
		if((Index >= 0))
		{
			MoveItemBottomToTop(Index, (Info.AllItemCount > INT64(0)));
		}
	}
	else if(((strID == "BottomList") && (Info.DragSrcName == "TopList")))
	{
		if(((int(m_type) == 1) || (int(m_type) == 4)))
		{
			Index = m_hPrivateShopWndTopList.FindItem(Info.Id);
		}
		else if(((int(m_type) == 2) || (int(m_type) == 3)))
		{
			Index = m_hPrivateShopWndTopList.FindItemWithAllProperty(Info);
		}
		if((Index >= 0))
		{
			if(((int(m_type) == 1) && (m_bBulk == true)))
			{
				if(((m_hPrivateShopWndTopList.GetItemNum() <= m_numPossibleSlotCount) || IsStackableItem(Info.ConsumeType)))
				{
					MoveItemTopToBottom(Index, (Info.AllItemCount > INT64(0)));
				}
				else if(((int(m_type) == 2) || (int(m_type) == 4)))
				{
					AddSystemMessage(3676);
				}
				else
				{
					AddSystemMessage(3675);
				}
			}
			else if(((m_numPossibleSlotCount > m_hPrivateShopWndBottomList.GetItemNum()) || (IsStackableItem(Info.ConsumeType) && (int(m_type) != 4))))
			{
				if((IsStackableItem(Info.ConsumeType) && (int(m_type) != 2)))
				{
					MoveItemTopToBottom(Index, Class'NWindow.InputAPI'.static.IsAltPressed());
				}
				else
				{
					MoveItemTopToBottom(Index, false);
				}
			}
			else if((int(m_type) == 3))
			{
				AddSystemMessage(3676);
			}
			else if(((int(m_type) == 2) || (int(m_type) == 4)))
			{
				AddSystemMessage(3676);
			}
			else
			{
				AddSystemMessage(3675);
			}
		}
	}
	return;
}

function Clear()
{
	m_type = PT_NONE;
	m_merchantID = -1;
	m_bBulk = false;
	m_hPrivateShopWndTopList.Clear();
	m_hPrivateShopWndBottomList.Clear();
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.PriceText", "0");
	Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString("PrivateShopWnd.PriceText", "");
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.AdenaText", "0");
	Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString("PrivateShopWnd.AdenaText", "");
	return;
}

function RequestQuit()
{
	if((int(m_type) == 3))
	{
		RequestQuitPrivateShop("buy");
	}
	else if(((int(m_type) == 4) && !m_bBulk))
	{
		RequestQuitPrivateShop("sell");
	}
	else if(((int(m_type) == 4) && m_bBulk))
	{
		RequestQuitPrivateShop("bulksell");
	}
	return;
}

function MoveItemTopToBottom(int Index, bool bAllItem)
{
	local ItemInfo Info, bottomInfo;
	local int Num, i, bottomIndex;

	if(m_hPrivateShopWndTopList.GetItem(Index, Info))
	{
		if((int(m_type) == 4))
		{
			DialogSetID(333);
			DialogSetReservedItemID(Info.Id);
			DialogSetReservedInt3(int(bAllItem));
			DialogSetEditType("number");
			DialogSetParamInt64(INT64(-1));
			DialogSetDefaultOK();
			DialogShow(DialogModalType_Modalless, DialogType_NumberPad, GetSystemMessage(322));
		}
		else if((int(m_type) == 3))
		{
			DialogSetID(333);
			DialogSetReservedItemInfo(Info);
			DialogSetEditType("number");
			DialogSetParamInt64(INT64(-1));
			DialogSetDefaultOK();
			DialogShow(DialogModalType_Modalless, DialogType_NumberPad, GetSystemMessage(585));
		}
		else if(((int(m_type) == 2) || (int(m_type) == 1)))
		{
			if(((int(m_type) == 2) && (Info.bDisabled > 0)))
			{
				return;
			}
			if(((int(m_type) == 1) && m_bBulk))
			{
				Num = m_hPrivateShopWndTopList.GetItemNum();
				i = 0;
				while((i < Num))
				{
					m_hPrivateShopWndTopList.GetItem(i, Info);
					m_hPrivateShopWndBottomList.AddItem(Info);
					++i;
				}
				m_hPrivateShopWndTopList.Clear();
				AdjustPrice();
				AdjustCount();
			}
			else if(((!bAllItem && IsStackableItem(Info.ConsumeType)) && (Info.ItemNum > INT64(1))))
			{
				DialogSetID(111);
				if((int(m_type) == 2))
				{
					DialogSetReservedItemInfo(Info);
				}
				else if((int(m_type) == 1))
				{
					DialogSetReservedItemID(Info.Id);
				}
				if((int(m_type) == 2))
				{
					if((Info.ItemNum >= Info.Reserved64))
					{
						DialogSetParamInt64(Info.Reserved64);
					}
					else
					{
						DialogSetParamInt64(Info.ItemNum);
					}
				}
				else
				{
					DialogSetParamInt64(Info.ItemNum);
				}
				DialogSetDefaultOK();
				DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), Info.Name, ""));
			}
			else
			{
				if((int(m_type) == 1))
				{
					bottomIndex = m_hPrivateShopWndBottomList.FindItem(Info.Id);
				}
				else if((int(m_type) == 2))
				{
					bottomIndex = m_hPrivateShopWndBottomList.FindItemWithAllProperty(Info);
				}
				if(((bottomIndex >= 0) && IsStackableItem(Info.ConsumeType)))
				{
					m_hPrivateShopWndBottomList.GetItem(bottomIndex, bottomInfo);
					(bottomInfo.ItemNum += Info.ItemNum);
					m_hPrivateShopWndBottomList.SetItem(bottomIndex, bottomInfo);
				}
				else
				{
					m_hPrivateShopWndBottomList.AddItem(Info);
				}
				m_hPrivateShopWndTopList.DeleteItem(Index);
				AdjustPrice();
				AdjustCount();
			}
			if(((int(m_type) == 1) || (int(m_type) == 3)))
			{
				AdjustWeight();
			}
		}
	}
	return;
}

function MoveItemBottomToTop(int Index, bool bAllItem)
{
	local ItemInfo Info, topInfo;
	local int stringIndex, Num, i, topIndex;

	if(m_hPrivateShopWndBottomList.GetItem(Index, Info))
	{
		if(((int(m_type) == 1) && m_bBulk))
		{
			Num = m_hPrivateShopWndBottomList.GetItemNum();
			i = 0;
			while((i < Num))
			{
				m_hPrivateShopWndBottomList.GetItem(i, Info);
				m_hPrivateShopWndTopList.AddItem(Info);
				++i;
			}
			m_hPrivateShopWndBottomList.Clear();
			AdjustPrice();
			AdjustCount();
		}
		else if(((!bAllItem && IsStackableItem(Info.ConsumeType)) && (Info.ItemNum > INT64(1))))
		{
			DialogSetID(222);
			if(((int(m_type) == 1) || (int(m_type) == 4)))
			{
				DialogSetReservedItemID(Info.Id);
			}
			else if(((int(m_type) == 2) || (int(m_type) == 3)))
			{
				DialogSetReservedItemInfo(Info);
			}
			switch(m_type)
			{
				case PT_SellList:
					stringIndex = 72;
					break;
				case PT_BuyList:
					stringIndex = 571;
					break;
				case PT_Sell:
					stringIndex = 72;
					break;
				case PT_Buy:
					stringIndex = 72;
					break;
				default:
					break;
			}
			DialogSetParamInt64(Info.ItemNum);
			DialogSetDefaultOK();
			DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(stringIndex), Info.Name, ""));
		}
		else
		{
			m_hPrivateShopWndBottomList.DeleteItem(Index);
			if((int(m_type) != 3))
			{
				if(((int(m_type) == 1) || (int(m_type) == 4)))
				{
					topIndex = m_hPrivateShopWndTopList.FindItem(Info.Id);
				}
				else if((int(m_type) == 2))
				{
					topIndex = m_hPrivateShopWndTopList.FindItemWithAllProperty(Info);
				}
				if(((topIndex >= 0) && IsStackableItem(Info.ConsumeType)))
				{
					m_hPrivateShopWndTopList.GetItem(topIndex, topInfo);
					(topInfo.ItemNum += Info.ItemNum);
					m_hPrivateShopWndTopList.SetItem(topIndex, topInfo);
				}
				else
				{
					m_hPrivateShopWndTopList.AddItem(Info);
				}
			}
			AdjustPrice();
			AdjustCount();
		}
		if(((int(m_type) == 1) || (int(m_type) == 3)))
		{
			AdjustWeight();
		}
	}
	return;
}

function HandleDialogOK()
{
	local int Id, bottomIndex, topIndex, i, allItem;
	local ItemInfo bottomInfo, topInfo;
	local ItemID scID;
	local ItemInfo scInfo;
	local INT64 inputNum;
	local int currentItemNum;
	local bool enableAddCurrentItemFlag;

	currentItemNum = 0;
	if(DialogIsMine())
	{
		Id = DialogGetID();
		inputNum = INT64(DialogGetString());
		scID = DialogGetReservedItemID();
		DialogGetReservedItemInfo(scInfo);
		if((int(m_type) == 4))
		{
			if(((Id == 111) && (inputNum > INT64(0))))
			{
				topIndex = m_hPrivateShopWndTopList.FindItem(scID);
				if((topIndex >= 0))
				{
					m_hPrivateShopWndTopList.GetItem(topIndex, topInfo);
					bottomIndex = m_hPrivateShopWndBottomList.FindItem(scID);
					m_hPrivateShopWndBottomList.GetItem(bottomIndex, bottomInfo);
					if(((bottomIndex >= 0) && IsStackableItem(bottomInfo.ConsumeType)))
					{
						bottomInfo.Price = DialogGetReservedInt2();
						(bottomInfo.ItemNum += Min64(inputNum, topInfo.ItemNum));
						m_hPrivateShopWndBottomList.SetItem(bottomIndex, bottomInfo);
					}
					else
					{
						bottomInfo = topInfo;
						bottomInfo.ItemNum = Min64(inputNum, topInfo.ItemNum);
						bottomInfo.Price = DialogGetReservedInt2();
						m_hPrivateShopWndBottomList.AddItem(bottomInfo);
					}
					(topInfo.ItemNum -= inputNum);
					if((topInfo.ItemNum <= INT64(0)))
					{
						m_hPrivateShopWndTopList.DeleteItem(topIndex);
					}
					else
					{
						m_hPrivateShopWndTopList.SetItem(topIndex, topInfo);
					}
				}
				AdjustPrice();
				AdjustCount();
			}
			else if(((Id == 222) && (inputNum > INT64(0))))
			{
				bottomIndex = m_hPrivateShopWndBottomList.FindItem(scID);
				if((bottomIndex >= 0))
				{
					m_hPrivateShopWndBottomList.GetItem(bottomIndex, bottomInfo);
					topIndex = m_hPrivateShopWndTopList.FindItem(scID);
					if(((topIndex >= 0) && IsStackableItem(bottomInfo.ConsumeType)))
					{
						m_hPrivateShopWndTopList.GetItem(topIndex, topInfo);
						(topInfo.ItemNum += Min64(inputNum, bottomInfo.ItemNum));
						m_hPrivateShopWndTopList.SetItem(topIndex, topInfo);
					}
					else
					{
						topInfo = bottomInfo;
						topInfo.ItemNum = Min64(inputNum, bottomInfo.ItemNum);
						m_hPrivateShopWndTopList.AddItem(topInfo);
					}
					(bottomInfo.ItemNum -= inputNum);
					if((bottomInfo.ItemNum > INT64(0)))
					{
						m_hPrivateShopWndBottomList.SetItem(bottomIndex, bottomInfo);
					}
					else
					{
						m_hPrivateShopWndBottomList.DeleteItem(bottomIndex);
					}
				}
				AdjustPrice();
				AdjustCount();
			}
			else if((Id == 444))
			{
				topIndex = m_hPrivateShopWndTopList.FindItem(scID);
				if((topIndex >= 0))
				{
					allItem = DialogGetReservedInt3();
					m_hPrivateShopWndTopList.GetItem(topIndex, topInfo);
					if((((allItem == 0) && IsStackableItem(topInfo.ConsumeType)) && (topInfo.ItemNum != INT64(1))))
					{
						DialogSetID(111);
						if((topInfo.ItemNum == INT64(0)))
						{
							topInfo.ItemNum = INT64(1);
						}
						DialogSetParamInt64(topInfo.ItemNum);
						DialogSetDefaultOK();
						DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), topInfo.Name, ""));
					}
					else
					{
						if((allItem == 0))
						{
							topInfo.ItemNum = INT64(1);
						}
						topInfo.Price = DialogGetReservedInt2();
						bottomIndex = m_hPrivateShopWndBottomList.FindItem(topInfo.Id);
						if(((bottomIndex >= 0) && IsStackableItem(topInfo.ConsumeType)))
						{
							m_hPrivateShopWndBottomList.GetItem(bottomIndex, bottomInfo);
							(topInfo.ItemNum += bottomInfo.ItemNum);
							m_hPrivateShopWndBottomList.SetItem(bottomIndex, topInfo);
						}
						else
						{
							m_hPrivateShopWndBottomList.AddItem(topInfo);
						}
						m_hPrivateShopWndTopList.DeleteItem(topIndex);
						AdjustPrice();
						AdjustCount();
					}
				}
			}
			else if(((Id == 333) && (inputNum > INT64(0))))
			{
				topIndex = m_hPrivateShopWndTopList.FindItem(scID);
				if((topIndex >= 0))
				{
					m_hPrivateShopWndTopList.GetItem(topIndex, topInfo);
					if((inputNum >= INT64("1000000000000")))
					{
						DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(1369));
					}
					else if(!IsProperPrice(topInfo, inputNum))
					{
						DialogSetID(444);
						DialogSetReservedItemID(topInfo.Id);
						DialogSetReservedInt2(inputNum);
						DialogSetDefaultOK();
						DialogShow(DialogModalType_Modalless, DialogType_Warning, GetSystemMessage(569));
					}
					else
					{
						allItem = DialogGetReservedInt3();
						if(((allItem == 0) && IsStackableItem(topInfo.ConsumeType)))
						{
							DialogSetID(111);
							DialogSetReservedItemID(topInfo.Id);
							DialogSetReservedInt2(inputNum);
							DialogSetReservedInt3(allItem);
							DialogSetParamInt64(topInfo.ItemNum);
							DialogSetDefaultOK();
							DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), topInfo.Name, ""));
						}
						else
						{
							if((allItem == 0))
							{
								topInfo.ItemNum = INT64(1);
							}
							topInfo.Price = inputNum;
							bottomIndex = m_hPrivateShopWndBottomList.FindItem(topInfo.Id);
							if(((bottomIndex >= 0) && IsStackableItem(topInfo.ConsumeType)))
							{
								m_hPrivateShopWndBottomList.GetItem(bottomIndex, bottomInfo);
								(topInfo.ItemNum += bottomInfo.ItemNum);
								m_hPrivateShopWndBottomList.SetItem(bottomIndex, topInfo);
							}
							else
							{
								m_hPrivateShopWndBottomList.AddItem(topInfo);
							}
							m_hPrivateShopWndTopList.DeleteItem(topIndex);
							AdjustPrice();
							AdjustCount();
						}
					}
				}
			}
			else if((Id == 555))
			{
				if(!m_bBulk)
				{
					SetPrivateShopMessage("sell", DialogGetString());
				}
				else
				{
					SetPrivateShopMessage("bulksell", DialogGetString());
				}
			}
		}
		else if((int(m_type) == 3))
		{
			if(((Id == 111) && (inputNum > INT64(0))))
			{
				topIndex = m_hPrivateShopWndTopList.FindItemWithAllProperty(scInfo);
				if((topIndex >= 0))
				{
					m_hPrivateShopWndTopList.GetItem(topIndex, topInfo);
					bottomIndex = m_hPrivateShopWndBottomList.FindItemWithAllProperty(scInfo);
					m_hPrivateShopWndBottomList.GetItem(bottomIndex, bottomInfo);
					if(((bottomIndex >= 0) && IsStackableItem(bottomInfo.ConsumeType)))
					{
						bottomInfo.Price = DialogGetReservedInt2();
						(bottomInfo.ItemNum += inputNum);
						m_hPrivateShopWndBottomList.SetItem(bottomIndex, bottomInfo);
						AdjustPrice();
						return;
					}
					i = m_hPrivateShopWndBottomList.GetItemNum();
					if((bottomIndex >= 0))
					{
						i = m_hPrivateShopWndBottomList.GetItemNum();
						while((i >= 0))
						{
							m_hPrivateShopWndBottomList.GetItem(i, bottomInfo);
							if(IsSameClassID(bottomInfo.Id, scID))
							{
								m_hPrivateShopWndBottomList.DeleteItem(i);
							}
							--i;
						}
					}
					currentItemNum = i;
					enableAddCurrentItemFlag = false;
					if(IsStackableItem(topInfo.ConsumeType))
					{
						if(((currentItemNum + 1) <= m_buyMaxCount))
						{
							bottomInfo = topInfo;
							bottomInfo.ItemNum = inputNum;
							bottomInfo.Price = DialogGetReservedInt2();
							m_hPrivateShopWndBottomList.AddItem(bottomInfo);
							enableAddCurrentItemFlag = true;
						}
					}
					else
					{
						if((currentItemNum < 0))
						{
							currentItemNum = m_hPrivateShopWndBottomList.GetItemNum();
						}
						if(((INT64(currentItemNum) + inputNum) <= INT64(m_buyMaxCount)))
						{
							bottomInfo = topInfo;
							bottomInfo.ItemNum = INT64(1);
							bottomInfo.Price = DialogGetReservedInt2();
							i = 0;
							while((INT64(i) < inputNum))
							{
								if((m_hPrivateShopWndBottomList.GetItemNum() < m_buyMaxCount))
								{
									m_hPrivateShopWndBottomList.AddItem(bottomInfo);
									enableAddCurrentItemFlag = true;
								}
								++i;
							}
						}
					}
					if((enableAddCurrentItemFlag == false))
					{
						DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(351));
					}
				}
				AdjustWeight();
				AdjustPrice();
				AdjustCount();
			}
			else if(((Id == 222) && (inputNum > INT64(0))))
			{
				bottomIndex = m_hPrivateShopWndBottomList.FindItemWithAllProperty(scInfo);
				if((bottomIndex >= 0))
				{
					m_hPrivateShopWndBottomList.GetItem(bottomIndex, bottomInfo);
					(bottomInfo.ItemNum -= inputNum);
					if((bottomInfo.ItemNum > INT64(0)))
					{
						m_hPrivateShopWndBottomList.SetItem(bottomIndex, bottomInfo);
					}
					else
					{
						m_hPrivateShopWndBottomList.DeleteItem(bottomIndex);
					}
				}
			}
			else if((Id == 444))
			{
				topIndex = m_hPrivateShopWndTopList.FindItemWithAllProperty(scInfo);
				if((topIndex >= 0))
				{
					m_hPrivateShopWndTopList.GetItem(topIndex, topInfo);
					DialogSetID(111);
					DialogSetReservedItemID(topInfo.Id);
					DialogSetParamInt64(topInfo.ItemNum);
					DialogSetDefaultOK();
					DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(570), topInfo.Name, ""));
				}
				AdjustPrice();
				AdjustCount();
			}
			else if(((Id == 333) && (inputNum > INT64(0))))
			{
				topIndex = m_hPrivateShopWndTopList.FindItemWithAllProperty(scInfo);
				if((topIndex >= 0))
				{
					m_hPrivateShopWndTopList.GetItem(topIndex, topInfo);
					if((inputNum >= INT64("1000000000000")))
					{
						DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(1369));
					}
					else if(!IsProperPrice(topInfo, inputNum))
					{
						DialogSetID(444);
						DialogSetReservedItemID(topInfo.Id);
						DialogSetReservedInt2(inputNum);
						DialogSetDefaultOK();
						DialogShow(DialogModalType_Modalless, DialogType_Warning, GetSystemMessage(569));
					}
					else
					{
						DialogSetID(111);
						DialogSetReservedItemID(topInfo.Id);
						DialogSetReservedInt2(inputNum);
						DialogSetParamInt64(topInfo.ItemNum);
						DialogSetDefaultOK();
						DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(570), topInfo.Name, ""));
					}
				}
			}
			else if((Id == 555))
			{
				SetPrivateShopMessage("buy", DialogGetString());
			}
		}
		else if(((int(m_type) == 1) || (int(m_type) == 2)))
		{
			if(((Id == 111) && (inputNum > INT64(0))))
			{
				topIndex = -1;
				if((int(m_type) == 1))
				{
					topIndex = m_hPrivateShopWndTopList.FindItem(scID);
				}
				else if((int(m_type) == 2))
				{
					topIndex = m_hPrivateShopWndTopList.FindItemWithAllProperty(scInfo);
				}
				if((topIndex >= 0))
				{
					m_hPrivateShopWndTopList.GetItem(topIndex, topInfo);
					if((int(m_type) == 1))
					{
						bottomIndex = m_hPrivateShopWndBottomList.FindItem(scID);
					}
					else if((int(m_type) == 2))
					{
						bottomIndex = m_hPrivateShopWndBottomList.FindItemWithAllProperty(scInfo);
					}
					m_hPrivateShopWndBottomList.GetItem(bottomIndex, bottomInfo);
					if(((int(m_type) == 2) && (topInfo.Reserved64 < (inputNum + bottomInfo.ItemNum))))
					{
						DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(1036));
					}
					else
					{
						if((bottomIndex >= 0))
						{
							(bottomInfo.ItemNum += Min64(inputNum, topInfo.ItemNum));
							m_hPrivateShopWndBottomList.SetItem(bottomIndex, bottomInfo);
						}
						else
						{
							bottomInfo = topInfo;
							bottomInfo.ItemNum = Min64(inputNum, topInfo.ItemNum);
							m_hPrivateShopWndBottomList.AddItem(bottomInfo);
						}
						(topInfo.ItemNum -= inputNum);
						if((topInfo.ItemNum <= INT64(0)))
						{
							m_hPrivateShopWndTopList.DeleteItem(topIndex);
						}
						else
						{
							m_hPrivateShopWndTopList.SetItem(topIndex, topInfo);
						}
					}
				}
				AdjustPrice();
				AdjustCount();
			}
			else if(((Id == 222) && (inputNum > INT64(0))))
			{
				bottomIndex = -1;
				if((int(m_type) == 1))
				{
					bottomIndex = m_hPrivateShopWndBottomList.FindItem(scID);
				}
				else if((int(m_type) == 2))
				{
					bottomIndex = m_hPrivateShopWndBottomList.FindItemWithAllProperty(scInfo);
				}
				if((bottomIndex >= 0))
				{
					m_hPrivateShopWndBottomList.GetItem(bottomIndex, bottomInfo);
					topIndex = -1;
					if((int(m_type) == 1))
					{
						topIndex = m_hPrivateShopWndTopList.FindItem(scID);
					}
					else if((int(m_type) == 2))
					{
						topIndex = m_hPrivateShopWndTopList.FindItemWithAllProperty(scInfo);
					}
					if((topIndex >= 0))
					{
						m_hPrivateShopWndTopList.GetItem(topIndex, topInfo);
						(topInfo.ItemNum += Min64(inputNum, bottomInfo.ItemNum));
						m_hPrivateShopWndTopList.SetItem(topIndex, topInfo);
					}
					else
					{
						topInfo = bottomInfo;
						topInfo.ItemNum = Min64(inputNum, bottomInfo.ItemNum);
						m_hPrivateShopWndTopList.AddItem(topInfo);
					}
					(bottomInfo.ItemNum -= inputNum);
					if((bottomInfo.ItemNum > INT64(0)))
					{
						m_hPrivateShopWndBottomList.SetItem(bottomIndex, bottomInfo);
					}
					else
					{
						m_hPrivateShopWndBottomList.DeleteItem(bottomIndex);
					}
				}
				AdjustPrice();
				AdjustCount();
			}
			else if((Id == 666))
			{
				HandleOKButton(false);
			}
		}
		if(((int(m_type) == 1) || (int(m_type) == 3)))
		{
			AdjustWeight();
			AdjustPrice();
		}
	}
	return;
}

function OnLButtonUp(WindowHandle a_WindowHandle, int nX, int nY)
{
	if(GetWindowHandle("InventoryViewer").IsShowWindow())
	{
		GetWindowHandle("InventoryViewer").SetFocus();
		GetWindowHandle(getCurrentWindowName(string(self))).SetFocus();
		if(GetWindowHandle("DialogBox").IsShowWindow())
		{
			GetWindowHandle("DialogBox").SetFocus();
		}
	}
	return;
}

function HandleOpenWindow(string param)
{
	local string Type;
	local int bulk;
	local string Adenastring;
	local UserInfo User;
	local INT64 Adena;

	Clear();
	ParseString(param, "type", Type);
	ParseINT64(param, "adena", Adena);
	ParseInt(param, "userID", m_merchantID);
	ParseInt(param, "bulk", bulk);
	ParseInt(param, "nInventoryItemCount", m_curInventoryCount);
	if((bulk > 0))
	{
		m_bBulk = true;
		GetTextureHandle("PrivateShopWnd.Arrow").SetTexture("L2UI_CT1.PrivateShop_DF_Arrow");
		GetTextureHandle("PrivateShopWnd.BottomListBg").SetTexture("L2UI_CT1.PrivateShop_DF_GroupBox");
		SwithBulkOnlyShop();
	}
	else
	{
		m_bBulk = false;
		GetTextureHandle("PrivateShopWnd.Arrow").SetTexture("L2UI_CT1.ShopWnd_DF_Arrow");
		GetTextureHandle("PrivateShopWnd.BottomListBg").SetTexture("L2UI_CT1.GroupBox.GroupBox_DF");
		ResetBulkOnlyShop();
	}
	if(!m_IsPrivateStoreBypass)
	{
		Class'NWindow.UIAPI_BUTTON'.static.SetButtonName("PrivateShopWnd.MessageButton", 2331);
	}
	switch(Type)
	{
		case "buy":
			m_type = PT_Buy;
			if(!stopSellFlag)
			{
				getInstanceInventoryViewer().showWindowByParentWindow(GetWindowHandle(getCurrentWindowName(string(self))));
			}
			break;
		case "sell":
			m_type = PT_Sell;
			if(!stopSellFlag)
			{
				getInstanceInventoryViewer().showWindowByParentWindow(GetWindowHandle(getCurrentWindowName(string(self))));
			}
			break;
		case "buyList":
			m_type = PT_BuyList;
			break;
		case "sellList":
			m_type = PT_SellList;
			break;
		default:
			break;
	}
	if(stopSellFlag)
	{
		stopSellFlag = false;
		RequestQuit();
		return;
	}
	Adenastring = MakeCostString(string(Adena));
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.AdenaText", Adenastring);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString("PrivateShopWnd.AdenaText", ConvertNumToText(string(Adena)));
	if((param != ""))
	{
		ShowWindow("PrivateShopWnd");
		Class'NWindow.UIAPI_WINDOW'.static.SetFocus("PrivateShopWnd");
	}
	if((int(m_type) == 3))
	{
		Class'NWindow.UIAPI_WINDOW'.static.SetTooltipType("PrivateShopWnd.TopList", "Inventory");
		Class'NWindow.UIAPI_WINDOW'.static.SetTooltipType("PrivateShopWnd.BottomList", "InventoryStackableUnitPrice");
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.TopText", GetSystemString(1));
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.BottomText", GetSystemString(502));
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.PriceConstText", GetSystemString(142));
		Class'NWindow.UIAPI_BUTTON'.static.SetButtonName("PrivateShopWnd.OKButton", 428);
		ShowWindow("PrivateShopWnd.BottomCountText");
		ShowWindow("PrivateShopWnd.StopButton");
		if(!m_IsPrivateStoreBypass)
		{
			ShowWindow("PrivateShopWnd.MessageButton");
			ShowWindow("PrivateShopWnd.history_Btn");
		}
		else
		{
			HideWindow("PrivateShopWnd.MessageButton");
			HideWindow("PrivateShopWnd.history_Btn");
		}
		ShowWindow("PrivateShopWnd.OKButton");
		HideWindow("PrivateShopWnd.CheckBulk");
		Class'NWindow.UIAPI_BUTTON'.static.SetButtonName("PrivateShopWnd.StopButton", 2328);
		Class'NWindow.UIAPI_BUTTON'.static.SetButtonName("PrivateShopWnd.OKButton", 2327);
		setWindowTitleByString((((GetSystemString(498) $ "(") $ GetSystemString(1434)) $ ")"));
	}
	else if((int(m_type) == 4))
	{
		Class'NWindow.UIAPI_WINDOW'.static.SetTooltipType("PrivateShopWnd.TopList", "Inventory");
		Class'NWindow.UIAPI_WINDOW'.static.SetTooltipType("PrivateShopWnd.BottomList", "InventoryStackableUnitPrice");
		if((bulk > 0))
		{
			Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck("PrivateShopWnd.CheckBulk", true);
		}
		else
		{
			Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck("PrivateShopWnd.CheckBulk", false);
		}
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.TopText", GetSystemString(1));
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.BottomText", GetSystemString(137));
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.PriceConstText", GetSystemString(143));
		Class'NWindow.UIAPI_BUTTON'.static.SetButtonName("PrivateShopWnd.OKButton", 428);
		ShowWindow("PrivateShopWnd.BottomCountText");
		ShowWindow("PrivateShopWnd.StopButton");
		if(!m_IsPrivateStoreBypass)
		{
			ShowWindow("PrivateShopWnd.MessageButton");
			ShowWindow("PrivateShopWnd.history_Btn");
		}
		else
		{
			HideWindow("PrivateShopWnd.MessageButton");
			HideWindow("PrivateShopWnd.history_Btn");
		}
		ShowWindow("PrivateShopWnd.OKButton");
		ShowWindow("PrivateShopWnd.CheckBulk");
		if((bulk > 0))
		{
			Class'NWindow.UIAPI_BUTTON'.static.SetButtonName("PrivateShopWnd.StopButton", 2330);
			Class'NWindow.UIAPI_BUTTON'.static.SetButtonName("PrivateShopWnd.OKButton", 2329);
		}
		else
		{
			Class'NWindow.UIAPI_BUTTON'.static.SetButtonName("PrivateShopWnd.StopButton", 2326);
			Class'NWindow.UIAPI_BUTTON'.static.SetButtonName("PrivateShopWnd.OKButton", 2325);
		}
		setWindowTitleByString((((GetSystemString(498) $ "(") $ GetSystemString(1157)) $ ")"));
	}
	else if((int(m_type) == 1))
	{
		Class'NWindow.UIAPI_WINDOW'.static.SetTooltipType("PrivateShopWnd.TopList", "InventoryStackableUnitPrice");
		Class'NWindow.UIAPI_WINDOW'.static.SetTooltipType("PrivateShopWnd.BottomList", "InventoryStackableUnitPrice");
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.TopText", GetSystemString(137));
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.BottomText", GetSystemString(139));
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.PriceConstText", GetSystemString(142));
		Class'NWindow.UIAPI_BUTTON'.static.SetButtonName("PrivateShopWnd.OKButton", 140);
		ShowWindow("PrivateShopWnd.BottomCountText");
		HideWindow("PrivateShopWnd.StopButton");
		HideWindow("PrivateShopWnd.MessageButton");
		ShowWindow("PrivateShopWnd.OKButton");
		HideWindow("PrivateShopWnd.CheckBulk");
		HideWindow("PrivateShopWnd.history_Btn");
		GetUserInfo(m_merchantID, User);
		if(m_IsPrivateStoreBypass)
		{
			User.Name = GetSystemString(13198);
		}
		if((bulk > 0))
		{
			setWindowTitleByString(((((GetSystemString(498) $ "(") $ GetSystemString(1198)) $ ") - ") $ User.Name));
		}
		else
		{
			setWindowTitleByString(((((GetSystemString(498) $ "(") $ GetSystemString(1157)) $ ") - ") $ User.Name));
		}
	}
	else if((int(m_type) == 2))
	{
		Class'NWindow.UIAPI_WINDOW'.static.SetTooltipType("PrivateShopWnd.TopList", "InventoryPrice2PrivateShop");
		Class'NWindow.UIAPI_WINDOW'.static.SetTooltipType("PrivateShopWnd.BottomList", "InventoryStackableUnitPrice");
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.TopText", GetSystemString(503));
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.BottomText", GetSystemString(137));
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.PriceConstText", GetSystemString(143));
		Class'NWindow.UIAPI_BUTTON'.static.SetButtonName("PrivateShopWnd.OKButton", 140);
		ShowWindow("PrivateShopWnd.BottomCountText");
		HideWindow("PrivateShopWnd.StopButton");
		HideWindow("PrivateShopWnd.MessageButton");
		ShowWindow("PrivateShopWnd.OKButton");
		HideWindow("PrivateShopWnd.CheckBulk");
		HideWindow("PrivateShopWnd.history_Btn");
		GetUserInfo(m_merchantID, User);
		if(m_IsPrivateStoreBypass)
		{
			User.Name = GetSystemString(13198);
		}
		setWindowTitleByString(((((GetSystemString(498) $ "(") $ GetSystemString(1434)) $ ") - ") $ User.Name));
	}
	if(m_bBulk)
	{
		SwithBulkOnlyShop();
	}
	else
	{
		ResetBulkOnlyShop();
	}
	return;
}

function HandleAddItem(string param)
{
	local ItemInfo Info;
	local string Target;

	ParseString(param, "target", Target);
	ParamToItemInfo(param, Info);
	if((Target == "topList"))
	{
		if(((int(m_type) == 2) && (Info.ItemNum == INT64(0))))
		{
			Info.bDisabled = 1;
		}
		if(isCollectionItem(Info))
		{
			Info.ForeTexture = "L2UI_EPIC.Icon.IconPanel_coll";
		}
		m_hPrivateShopWndTopList.AddItem(Info);
	}
	else if((Target == "bottomList"))
	{
		if(isCollectionItem(Info))
		{
			Info.ForeTexture = "L2UI_EPIC.Icon.IconPanel_coll";
		}
		m_hPrivateShopWndBottomList.AddItem(Info);
	}
	AdjustPrice();
	AdjustCount();
	if(((int(m_type) == 3) || (int(m_type) == 1)))
	{
		AdjustWeight();
	}
	return;
}

function AdjustPrice()
{
	local string Adena;
	local int Count;
	local INT64 Price, addPrice64;
	local ItemInfo Info;

	Count = m_hPrivateShopWndBottomList.GetItemNum();
	while((Count > 0))
	{
		m_hPrivateShopWndBottomList.GetItem((Count - 1), Info);
		addPrice64 = (Info.Price * Info.ItemNum);
		Price = (Price + addPrice64);
		--Count;
	}
	Adena = MakeCostStringINT64(Price);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.PriceText", Adena);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString("PrivateShopWnd.PriceText", ConvertNumToText(string(Price)));
	return;
}

function INT64 getAdjustPrice()
{
	local int Count;
	local INT64 Price, addPrice64;
	local ItemInfo Info;

	Count = m_hPrivateShopWndBottomList.GetItemNum();
	while((Count > 0))
	{
		m_hPrivateShopWndBottomList.GetItem((Count - 1), Info);
		addPrice64 = (Info.Price * Info.ItemNum);
		Price = (Price + addPrice64);
		--Count;
	}
	return Price;
}

function AdjustCount()
{
	local int Num, maxNum;

	if((int(m_type) == 4))
	{
		maxNum = m_sellMaxCount;
		Num = m_hPrivateShopWndBottomList.GetItemNum();
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.BottomCountText", (((("(" $ string(Num)) $ "/") $ string(maxNum)) $ ")"));
	}
	else if((int(m_type) == 3))
	{
		maxNum = m_buyMaxCount;
		Num = m_hPrivateShopWndBottomList.GetItemNum();
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.BottomCountText", (((("(" $ string(Num)) $ "/") $ string(maxNum)) $ ")"));
	}
	else if(((int(m_type) == 1) || (int(m_type) == 2)))
	{
		Num = m_hPrivateShopWndBottomList.GetItemNum();
		maxNum = (m_maxInventoryCount - m_curInventoryCount);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.BottomCountText", (((("(" $ string(Num)) $ "/") $ string(maxNum)) $ ")"));
	}
	m_numPossibleSlotCount = maxNum;
	return;
}

function AdjustWeight()
{
	local int Count;
	local INT64 Weight;
	local ItemInfo Info;

	Class'NWindow.UIAPI_INVENWEIGHT'.static.ZeroWeight("PrivateShopWnd.InvenWeight");
	Count = m_hPrivateShopWndBottomList.GetItemNum();
	Weight = INT64(0);
	while((Count > 0))
	{
		m_hPrivateShopWndBottomList.GetItem((Count - 1), Info);
		(Weight += (INT64(Info.Weight) * Info.ItemNum));
		--Count;
	}
	Class'NWindow.UIAPI_INVENWEIGHT'.static.AddWeight("PrivateShopWnd.InvenWeight", Weight);
	return;
}

function addParamEnSoul(ItemInfo Info, int itemIndex, out string param)
{
	local int i, N, Cnt;

	i = 1;
	while((i < 3))
	{
		Cnt = Info.EnsoulOption[(i - 1)].OptionArray.Length;
		ParamAdd(param, ((("EnsoulOptionNum_" $ string(itemIndex)) $ "_") $ string(i)), string(Cnt));
		N = 1;
		while((N < (1 + Cnt)))
		{
			ParamAdd(param, ((((("EnsoulOptionID_" $ string(itemIndex)) $ "_") $ string(i)) $ "_") $ string(N)), string(Info.EnsoulOption[(i - 1)].OptionArray[(N - 1)]));
			N++;
		}
		i++;
	}
	return;
}

function HandleOKButton(bool bPriceCheck)
{
	local string param;
	local int ItemCount, itemIndex;
	local ItemInfo ItemInfo;
	local PrivateShopWndReport report;
	local INT64 nPriceAdena;

	report = PrivateShopWndReport(GetScript("PrivateShopWndReport"));
	ItemCount = m_hPrivateShopWndBottomList.GetItemNum();
	if((int(m_type) == 4))
	{
		nPriceAdena = getAdjustPrice();
		if((getInstanceUIData().GetMaxAdena() < (GetAdena() + nPriceAdena)))
		{
			AddSystemMessage(4470);
			return;
		}
		if(Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked("PrivateShopWnd.CheckBulk"))
		{
			ParamAdd(param, "bulk", "1");
		}
		else
		{
			ParamAdd(param, "bulk", "0");
		}
		ParamAdd(param, "num", string(ItemCount));
		itemIndex = 0;
		while((itemIndex < ItemCount))
		{
			m_hPrivateShopWndBottomList.GetItem(itemIndex, ItemInfo);
			ParamAddItemIDWithIndex(param, ItemInfo.Id, itemIndex);
			ParamAdd(param, ("Count_" $ string(itemIndex)), string(ItemInfo.ItemNum));
			ParamAdd(param, ("Price_" $ string(itemIndex)), string(ItemInfo.Price));
			ParamAdd(param, ("ItemName_" $ string(itemIndex)), ItemInfo.Name);
			report.externalAddItem(ItemInfo);
			++itemIndex;
		}
		if((ItemCount > 0))
		{
			report.startOpenPrivateShop(param);
		}
		SendPrivateShopList("sellList", param);
	}
	else if((int(m_type) == 1))
	{
		ParamAdd(param, "merchantID", string(m_merchantID));
		ParamAdd(param, "num", string(ItemCount));
		itemIndex = 0;
		while((itemIndex < ItemCount))
		{
			m_hPrivateShopWndBottomList.GetItem(itemIndex, ItemInfo);
			if((bPriceCheck && !IsProperPrice(ItemInfo, ItemInfo.Price)))
			{
				break;
			}
			ParamAddItemIDWithIndex(param, ItemInfo.Id, itemIndex);
			ParamAdd(param, ("Count_" $ string(itemIndex)), string(ItemInfo.ItemNum));
			ParamAdd(param, ("Price_" $ string(itemIndex)), string(ItemInfo.Price));
			++itemIndex;
		}
		if((bPriceCheck && (itemIndex < ItemCount)))
		{
			DialogSetID(666);
			DialogShow(DialogModalType_Modalless, DialogType_Warning, GetSystemMessage(569));
			return;
		}
		else
		{
			SendPrivateShopList("buy", param);
		}
	}
	else if((int(m_type) == 3))
	{
		ParamAdd(param, "num", string(ItemCount));
		itemIndex = 0;
		while((itemIndex < ItemCount))
		{
			m_hPrivateShopWndBottomList.GetItem(itemIndex, ItemInfo);
			ParamAddItemIDWithIndex(param, ItemInfo.Id, itemIndex);
			ParamAdd(param, ("Enchanted_" $ string(itemIndex)), string(ItemInfo.Enchanted));
			ParamAdd(param, ("Damaged_" $ string(itemIndex)), string(ItemInfo.Damaged));
			ParamAdd(param, ("Count_" $ string(itemIndex)), string(ItemInfo.ItemNum));
			ParamAdd(param, ("Price_" $ string(itemIndex)), string(ItemInfo.Price));
			ParamAdd(param, ("RefineryOp1_" $ string(itemIndex)), string(ItemInfo.RefineryOp1));
			ParamAdd(param, ("RefineryOp2_" $ string(itemIndex)), string(ItemInfo.RefineryOp2));
			ParamAdd(param, ("RefineryOp3_" $ string(itemIndex)), string(ItemInfo.RefineryOp3));
			ParamAdd(param, ("LookChangeItemID_" $ string(itemIndex)), string(ItemInfo.LookChangeItemID));
			ParamAdd(param, ("AttrAttackType_" $ string(itemIndex)), string(ItemInfo.AttackAttributeType));
			ParamAdd(param, ("AttrAttackValue_" $ string(itemIndex)), string(ItemInfo.AttackAttributeValue));
			ParamAdd(param, ("AttrDefenseValueFire_" $ string(itemIndex)), string(ItemInfo.DefenseAttributeValueFire));
			ParamAdd(param, ("AttrDefenseValueWater_" $ string(itemIndex)), string(ItemInfo.DefenseAttributeValueWater));
			ParamAdd(param, ("AttrDefenseValueWind_" $ string(itemIndex)), string(ItemInfo.DefenseAttributeValueWind));
			ParamAdd(param, ("AttrDefenseValueEarth_" $ string(itemIndex)), string(ItemInfo.DefenseAttributeValueEarth));
			ParamAdd(param, ("AttrDefenseValueHoly_" $ string(itemIndex)), string(ItemInfo.DefenseAttributeValueHoly));
			ParamAdd(param, ("AttrDefenseValueUnholy_" $ string(itemIndex)), string(ItemInfo.DefenseAttributeValueUnholy));
			ParamAdd(param, ("ItemName_" $ string(itemIndex)), ItemInfo.Name);
			addParamEnSoul(ItemInfo, itemIndex, param);
			ParamAdd(param, ("IsBlessedItem_" $ string(itemIndex)), string(ItemInfo.BlessBaseEffectID));
			report.externalAddItem(ItemInfo);
			++itemIndex;
		}
		if((ItemCount > 0))
		{
			report.startOpenPrivateShop(param);
		}
		SendPrivateShopList("buyList", param);
	}
	else if((int(m_type) == 2))
	{
		ParamAdd(param, "merchantID", string(m_merchantID));
		ParamAdd(param, "num", string(ItemCount));
		itemIndex = 0;
		while((itemIndex < ItemCount))
		{
			m_hPrivateShopWndBottomList.GetItem(itemIndex, ItemInfo);
			if((bPriceCheck && !IsProperPrice(ItemInfo, ItemInfo.Price)))
			{
				break;
			}
			ParamAddItemIDWithIndex(param, ItemInfo.Id, itemIndex);
			ParamAdd(param, ("Enchanted_" $ string(itemIndex)), string(ItemInfo.Enchanted));
			ParamAdd(param, ("Damaged_" $ string(itemIndex)), string(ItemInfo.Damaged));
			ParamAdd(param, ("Count_" $ string(itemIndex)), string(ItemInfo.ItemNum));
			ParamAdd(param, ("Price_" $ string(itemIndex)), string(ItemInfo.Price));
			ParamAdd(param, ("RefineryOp1_" $ string(itemIndex)), string(ItemInfo.RefineryOp1));
			ParamAdd(param, ("RefineryOp2_" $ string(itemIndex)), string(ItemInfo.RefineryOp2));
			ParamAdd(param, ("RefineryOp3_" $ string(itemIndex)), string(ItemInfo.RefineryOp3));
			ParamAdd(param, ("LookChangeItemID_" $ string(itemIndex)), string(ItemInfo.LookChangeItemID));
			addParamEnSoul(ItemInfo, itemIndex, param);
			++itemIndex;
		}
		if((bPriceCheck && (itemIndex < ItemCount)))
		{
			DialogSetID(666);
			DialogShow(DialogModalType_Modalless, DialogType_Warning, GetSystemMessage(569));
			return;
		}
		else
		{
			SendPrivateShopList("sell", param);
		}
	}
	HideWindow("PrivateShopWnd");
	Clear();
	return;
}

function HandleSetMaxCount(string param)
{
	ParseInt(param, "Inventory", m_maxInventoryCount);
	ParseInt(param, "privateShopSell", m_sellMaxCount);
	ParseInt(param, "privateShopBuy", m_buyMaxCount);
	return;
}

function bool IsProperPrice(out ItemInfo Info, INT64 Price)
{
	if(((Info.DefaultPrice > INT64(0)) && ((Price <= (Info.DefaultPrice / INT64(5))) || (Price >= (Info.DefaultPrice * INT64(5))))))
	{
		return false;
	}
	return true;
}

function SwithBulkOnlyShop()
{
	setWindowTitleByString((((GetSystemString(596) $ "(") $ GetSystemString(1198)) $ ")"));
	HideWindow("PrivateShopWnd.CheckBulk");
	return;
}

function ResetBulkOnlyShop()
{
	HideWindow("PrivateShopWnd.CheckBulk");
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	RequestQuit();
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="PrivateShopWnd"
}
