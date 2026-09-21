class UniqueGachaWarehouseWnd extends UICommonAPI
	dependson(UIPacket);

const MAX_GACHA_INVEN = 1000;
const DIALOG_TOP_TO_BOTTOM = 1111;
const DIALOG_BOTTOM_TO_TOP = 2222;

var WindowHandle Me;
var string m_Windowname;
var ItemWindowHandle m_topList;
var ItemWindowHandle m_bottomList;
var int m_numPossibleSlotCount;
var int m_maxInventoryCount;
var array<int> hasStackableItemArray;

function OnRegisterEvent()
{
	RegisterEvent((100000 + 1068));
	RegisterEvent((100000 + 1069));
	RegisterEvent(1710);
	RegisterEvent(1720);
	RegisterEvent(2070);
	RegisterEvent(10140);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	Load();
	return;
}

function DelegateOnHide()
{
	m_topList.EnableWindow();
	m_bottomList.EnableWindow();
	Debug("DelegateOnHide");
	return;
}

function Initialize()
{
	Me = GetWindowHandle("UniqueGachaWarehouseWnd");
	m_topList = GetItemWindowHandle((m_Windowname $ ".TopList"));
	m_bottomList = GetItemWindowHandle((m_Windowname $ ".BottomList"));
	return;
}

function Load()
{
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "SortButton":
			OnSortButtonClick();
			break;
		case "OKButton":
			OnOKButtonClick();
			break;
		case "CancelButton":
			OnCancelButtonClick();
			break;
		default:
			break;
	}
	return;
}

function OnSortButtonClick()
{
	getInstanceL2Util().SortItemSimple(m_topList);
	return;
}

function OnOKButtonClick()
{
	API_C_EX_UNIQUE_GACHA_INVEN_GET_ITEM();
	Me.HideWindow();
	return;
}

function OnCancelButtonClick()
{
	Me.HideWindow();
	return;
}

function OnShow()
{
	if(IsPlayerOnWorldRaidServer())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
		Me.HideWindow();
		return;
	}
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	hasStackableItemArray.Remove(0, hasStackableItemArray.Length);
	m_topList.Clear();
	m_bottomList.Clear();
	m_topList.DisableWindow();
	m_bottomList.DisableWindow();
	checkEnableOKButton();
	Class'NWindow.UIAPI_INVENWEIGHT'.static.ZeroWeight("UniqueGachaWarehouseWnd.InvenWeight");
	refreshPossibleSlotCount();
	API_C_EX_UNIQUE_GACHA_INVEN_ITEM_LIST();
	return;
}

function checkEnableOKButton()
{
	if((m_bottomList.GetItemNum() > 0))
	{
		GetMeButton("OKButton").EnableWindow();
	}
	else
	{
		GetMeButton("OKButton").DisableWindow();
	}
	return;
}

function OnHide()
{
	if((DialogIsMine() && IsShowWindow("DialogBox")))
	{
		DialogHide();
	}
	return;
}

function OnDropItem(string strID, ItemInfo Info, int X, int Y)
{
	local int Index, nItemCount;

	if(((strID == "TopList") && (Info.DragSrcName == "BottomList")))
	{
		Index = m_bottomList.FindItemWithAllProperty(Info);
		if((Index >= 0))
		{
			if(HasStackableItemCheck(Info.Id.ClassID))
			{
				MoveItemBottomToTop(Index, (Info.AllItemCount > INT64(0)));
			}
		}
	}
	else if(((strID == "BottomList") && (Info.DragSrcName == "TopList")))
	{
		Index = m_topList.FindItemWithAllProperty(Info);
		if((m_bottomList.GetItemNum() > 0))
		{
			nItemCount = (m_bottomList.GetItemNum() - hasStackableItemArray.Length);
		}
		else
		{
			nItemCount = 0;
		}
		if((Index >= 0))
		{
			if(((m_numPossibleSlotCount > nItemCount) || ((HasStackableItemCheck(Info.Id.ClassID) && IsStackableItem(Info.ConsumeType)) && (m_numPossibleSlotCount >= nItemCount))))
			{
				MoveItemTopToBottom(Index, (Info.AllItemCount > INT64(0)));
			}
			else
			{
				AddSystemMessage(3675);
			}
		}
	}
	return;
}

function bool HasStackableItemCheck(int ItemClassID)
{
	local bool bReturn;

	if(IsStackableItem(GetItemInfoByClassID(ItemClassID).ConsumeType))
	{
		bReturn = Class'NWindow.UIDATA_INVENTORY'.static.HasItemByClassID(ItemClassID);
	}
	Debug(("HasStackableItemCheck" @ string(bReturn)));
	return bReturn;
}

function MoveItemTopToBottom(int Index, bool bAllItem)
{
	local ItemInfo topInfo, bottomInfo;
	local int bottomIndex;

	if(m_topList.GetItem(Index, topInfo))
	{
		if(((!bAllItem && IsStackableItem(topInfo.ConsumeType)) && (topInfo.ItemNum > INT64(1))))
		{
			m_topList.DisableWindow();
			m_bottomList.DisableWindow();
			DialogSetID(1111);
			DialogSetReservedItemID(topInfo.Id);
			DialogSetParamInt64(topInfo.ItemNum);
			DialogSetDefaultOK();
			DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), topInfo.Name, ""), m_hOwnerWnd);
			Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnHide = DelegateOnHide;
		}
		else
		{
			bottomIndex = m_bottomList.FindItem(topInfo.Id);
			if(((bottomIndex != -1) && IsStackableItem(topInfo.ConsumeType)))
			{
				m_bottomList.GetItem(bottomIndex, bottomInfo);
				(bottomInfo.ItemNum += topInfo.ItemNum);
				m_bottomList.SetItem(bottomIndex, bottomInfo);
			}
			else
			{
				m_bottomList.AddItem(topInfo);
			}
			m_topList.DeleteItem(Index);
			Class'NWindow.UIAPI_INVENWEIGHT'.static.AddWeight("UniqueGachaWarehouseWnd.InvenWeight", (topInfo.ItemNum * INT64(topInfo.Weight)));
			if(HasStackableItemCheck(topInfo.Id.ClassID))
			{
				addHasStackableItemArray(topInfo.Id.ClassID);
			}
			refreshPossibleSlotCount();
			checkEnableOKButton();
		}
	}
	return;
}

function MoveItemBottomToTop(int Index, bool bAllItem)
{
	local ItemInfo bottomInfo, topInfo;
	local int topIndex;

	if(m_bottomList.GetItem(Index, bottomInfo))
	{
		if(((!bAllItem && IsStackableItem(bottomInfo.ConsumeType)) && (bottomInfo.ItemNum > INT64(1))))
		{
			m_topList.DisableWindow();
			m_bottomList.DisableWindow();
			DialogSetID(2222);
			DialogSetReservedItemID(bottomInfo.Id);
			DialogSetParamInt64(bottomInfo.ItemNum);
			DialogSetDefaultOK();
			DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), bottomInfo.Name, ""), m_hOwnerWnd);
			Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnHide = DelegateOnHide;
		}
		else
		{
			topIndex = m_topList.FindItem(bottomInfo.Id);
			if(((topIndex != -1) && IsStackableItem(bottomInfo.ConsumeType)))
			{
				m_topList.GetItem(topIndex, topInfo);
				(topInfo.ItemNum += bottomInfo.ItemNum);
				m_topList.SetItem(topIndex, topInfo);
			}
			else
			{
				m_topList.AddItem(bottomInfo);
			}
			m_bottomList.DeleteItem(Index);
			Class'NWindow.UIAPI_INVENWEIGHT'.static.ReduceWeight("UniqueGachaWarehouseWnd.InvenWeight", (bottomInfo.ItemNum * INT64(bottomInfo.Weight)));
			if((findHasStackableItemArray(bottomInfo.Id.ClassID) != -1))
			{
				removeHasStackableItemArray(bottomInfo.Id.ClassID);
			}
			refreshPossibleSlotCount();
			checkEnableOKButton();
		}
	}
	return;
}

function HandleDialogOK()
{
	local int Id, Index, topIndex;
	local INT64 Num;
	local ItemInfo Info, topInfo;
	local ItemID cID;

	if(DialogIsMine())
	{
		m_topList.EnableWindow();
		m_bottomList.EnableWindow();
		Id = DialogGetID();
		Num = INT64(DialogGetString());
		cID = DialogGetReservedItemID();
		if(((Id == 1111) && (Num > INT64(0))))
		{
			topIndex = m_topList.FindItem(cID);
			if((topIndex >= 0))
			{
				m_topList.GetItem(topIndex, topInfo);
				Num = Min64(Num, topInfo.ItemNum);
				Index = m_bottomList.FindItem(cID);
				if((Index >= 0))
				{
					m_bottomList.GetItem(Index, Info);
					(Info.ItemNum += Num);
					m_bottomList.SetItem(Index, Info);
				}
				else
				{
					Info = topInfo;
					Info.ItemNum = Num;
					m_bottomList.AddItem(Info);
				}
				Class'NWindow.UIAPI_INVENWEIGHT'.static.AddWeight("UniqueGachaWarehouseWnd.InvenWeight", (Num * INT64(Info.Weight)));
				(topInfo.ItemNum -= Num);
				if((topInfo.ItemNum <= INT64(0)))
				{
					m_topList.DeleteItem(topIndex);
				}
				else
				{
					m_topList.SetItem(topIndex, topInfo);
				}
				if(HasStackableItemCheck(topInfo.Id.ClassID))
				{
					addHasStackableItemArray(topInfo.Id.ClassID);
				}
			}
		}
		else if(((Id == 2222) && (Num > INT64(0))))
		{
			Index = m_bottomList.FindItem(cID);
			if((Index >= 0))
			{
				m_bottomList.GetItem(Index, Info);
				Num = Min64(Num, Info.ItemNum);
				(Info.ItemNum -= Num);
				if((Info.ItemNum > INT64(0)))
				{
					m_bottomList.SetItem(Index, Info);
				}
				else
				{
					if((findHasStackableItemArray(Info.Id.ClassID) != -1))
					{
						removeHasStackableItemArray(Info.Id.ClassID);
					}
					m_bottomList.DeleteItem(Index);
				}
				topIndex = m_topList.FindItem(cID);
				if(((topIndex >= 0) && IsStackableItem(Info.ConsumeType)))
				{
					m_topList.GetItem(topIndex, topInfo);
					(topInfo.ItemNum += Num);
					m_topList.SetItem(topIndex, topInfo);
				}
				else
				{
					Info.ItemNum = Num;
					m_topList.AddItem(Info);
				}
				Class'NWindow.UIAPI_INVENWEIGHT'.static.ReduceWeight("UniqueGachaWarehouseWnd.InvenWeight", (Num * INT64(Info.Weight)));
			}
		}
		refreshPossibleSlotCount();
		checkEnableOKButton();
	}
	return;
}

function refreshPossibleSlotCount()
{
	GetMeTextBox("TopCountText").SetText(((string(m_topList.GetItemNum()) $ "/") $ string(1000)));
	m_numPossibleSlotCount = (m_maxInventoryCount - (InventoryWnd(GetScript("InventoryWnd")).m_NormalInvenCount + InventoryWnd(GetScript("InventoryWnd")).EquipNormalItemGetItemNum()));
	GetMeTextBox("BottomCountText").SetText(((string((m_bottomList.GetItemNum() - hasStackableItemArray.Length)) $ "/") $ string(m_numPossibleSlotCount)));
	Debug(("hasStackableItemArray.Length" @ string(hasStackableItemArray.Length)));
	return;
}

function OnDBClickItem(string ControlName, int Index)
{
	local ItemInfo Info;
	local int nItemCount;

	if((ControlName == "TopList"))
	{
		if((Index >= 0))
		{
			m_topList.GetSelectedItem(Info);
			if((m_bottomList.GetItemNum() > 0))
			{
				nItemCount = (m_bottomList.GetItemNum() - hasStackableItemArray.Length);
			}
			else
			{
				nItemCount = 0;
			}
			if(((m_numPossibleSlotCount > nItemCount) || ((HasStackableItemCheck(Info.Id.ClassID) && IsStackableItem(Info.ConsumeType)) && (m_numPossibleSlotCount >= nItemCount))))
			{
				MoveItemTopToBottom(Index, Class'NWindow.InputAPI'.static.IsAltPressed());
			}
			else
			{
				AddSystemMessage(3675);
			}
		}
	}
	else if((ControlName == "BottomList"))
	{
		MoveItemBottomToTop(Index, Class'NWindow.InputAPI'.static.IsAltPressed());
	}
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case EV_PacketID(1068):
			ParsePacket_S_EX_UNIQUE_GACHA_INVEN_ITEM_LIST();
			break;
		case EV_PacketID(1069):
			ParsePacket_S_EX_UNIQUE_GACHA_INVEN_GET_ITEM();
			break;
		case 1710:
			HandleDialogOK();
			break;
		case 1720:
			Debug(("EV_DialogCancel" @ a_Param));
			break;
		case 2070:
			HandleSetMaxCount(a_Param);
			break;
		case 10140:
			if(Me.IsShowWindow())
			{
				Me.HideWindow();
			}
			break;
		default:
			break;
	}
	return;
}

function HandleSetMaxCount(string param)
{
	ParseInt(param, "Inventory", m_maxInventoryCount);
	return;
}

function API_C_EX_UNIQUE_GACHA_INVEN_GET_ITEM()
{
	local array<byte> stream;
	local UIPacket._C_EX_UNIQUE_GACHA_INVEN_GET_ITEM packet;
	local int i;
	local ItemInfo Info;

	if((m_bottomList.GetItemNum() > 0))
	{
		packet.getItems.Length = m_bottomList.GetItemNum();
		i = 0;
		while((i < m_bottomList.GetItemNum()))
		{
			m_bottomList.GetItem(i, Info);
			packet.getItems[i].nItemType = Info.Id.ClassID;
			packet.getItems[i].nAmount = Info.ItemNum;
			i++;
		}
		if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_UNIQUE_GACHA_INVEN_GET_ITEM(stream, packet))
		{
			return;
		}
		Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(820, stream);
		Debug(("API C_EX_UNIQUE_GACHA_INVEN_GET_ITEM :" @ string(packet.getItems.Length)));
	}
	return;
}

function API_C_EX_UNIQUE_GACHA_INVEN_ITEM_LIST()
{
	local array<byte> stream;
	local UIPacket._C_EX_UNIQUE_GACHA_INVEN_ITEM_LIST packet;

	packet.cInvenType = 0;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_UNIQUE_GACHA_INVEN_ITEM_LIST(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(819, stream);
	Debug("API C_EX_UNIQUE_GACHA_INVEN_ITEM_LIST :");
	return;
}

function ParsePacket_S_EX_UNIQUE_GACHA_INVEN_GET_ITEM()
{
	local UIPacket._S_EX_UNIQUE_GACHA_INVEN_GET_ITEM packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_UNIQUE_GACHA_INVEN_GET_ITEM(packet))
	{
		return;
	}
	Debug((" -->  Decode_S_EX_UNIQUE_GACHA_INVEN_GET_ITEM :  " @ string(packet.cResult)));
	if((packet.cResult == 1))
	{
		AddSystemMessage(6236);
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(6236));
	}
	Me.HideWindow();
	return;
}

function ParsePacket_S_EX_UNIQUE_GACHA_INVEN_ITEM_LIST()
{
	local UIPacket._S_EX_UNIQUE_GACHA_INVEN_ITEM_LIST packet;
	local int i;
	local ItemInfo Info;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_UNIQUE_GACHA_INVEN_ITEM_LIST(packet))
	{
		return;
	}
	Debug(((" -->  Decode_S_EX_UNIQUE_GACHA_INVEN_ITEM_LIST :  " @ string(packet.cPage)) @ string(packet.cMaxPage)));
	if((packet.cPage == 1))
	{
		m_topList.Clear();
	}
	Debug(("packet.myItems.length" @ string(packet.myItems.Length)));
	i = 0;
	while((i < packet.myItems.Length))
	{
		Debug(("myItems nItemType: " @ string(packet.myItems[i].nItemType)));
		Debug(("myItems nAmount  : " @ string(packet.myItems[i].nAmount)));
		Info = GetItemInfoByClassID(packet.myItems[i].nItemType);
		Info.ItemNum = packet.myItems[i].nAmount;
		if(IsStackableItem(Info.ConsumeType))
		{
			Info.bShowCount = true;
		}
		m_topList.AddItem(Info);
		i++;
	}
	if((packet.cPage == packet.cMaxPage))
	{
		Debug("목록 완료");  // EN?: List complete
		refreshPossibleSlotCount();
		m_topList.EnableWindow();
		m_bottomList.EnableWindow();
	}
	return;
}

function addHasStackableItemArray(int ClassID)
{
	if((findHasStackableItemArray(ClassID) == -1))
	{
		hasStackableItemArray[hasStackableItemArray.Length] = ClassID;
	}
	return;
}

function int findHasStackableItemArray(int ClassID)
{
	local int i, returnV;

	returnV = -1;
	i = 0;
	while((i < hasStackableItemArray.Length))
	{
		if((hasStackableItemArray[i] == ClassID))
		{
			returnV = i;
			break;
		}
		i++;
	}
	return returnV;
}

function removeHasStackableItemArray(int ClassID)
{
	local int Index;

	Index = findHasStackableItemArray(ClassID);
	if((Index != -1))
	{
		hasStackableItemArray.Remove(Index, 1);
	}
	return;
}

function OnReceivedCloseUI()
{
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="UniqueGachaWarehouseWnd"
}
