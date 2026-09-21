class RandomCraftChargingWnd extends UICommonAPI
	dependson(UIPacket);

const DIALOG_TOP_TO_BOTTOM = 111;
const DIALOG_BOTTOM_TO_TOP = 222;
const PRICE_ADENA_CLASSID = 57;

var string m_Windowname;
var WindowHandle Me;
var ItemWindowHandle m_topList;
var ItemWindowHandle m_bottomList;
var WindowHandle m_dialogWnd;
var StatusBarHandle statusCraftPoint;
var int craftPoint;
var byte craftPointMax;
var int craftPointAdded;
var int craftCharge;
var int craftChargeMax;
var int craftChargeAdded;
var INT64 craftChargePrice;
var WindowHandle m_Confirm_Wnd;
var WindowHandle m_SelectItemWnd;
var TextBoxHandle m_txtCraftPointAdded;
var TextBoxHandle m_statusGaugeMaxText;

function InitHandle()
{
	Me = GetWindowHandle(m_Windowname);
	m_dialogWnd = GetWindowHandle("DialogBox");
	m_topList = GetItemWindowHandle((m_Windowname $ ".TopList"));
	m_bottomList = GetItemWindowHandle((m_Windowname $ ".BottomList"));
	statusCraftPoint = GetStatusBarHandle((m_Windowname $ ".statusCraftPoint"));
	m_SelectItemWnd = GetWindowHandle((m_Windowname $ ".SelectItemWnd"));
	m_Confirm_Wnd = GetWindowHandle((m_Windowname $ ".Confirm_Wnd"));
	m_txtCraftPointAdded = GetTextBoxHandle((m_Windowname $ ".Confirm_Wnd.ConfirmDetails_Wnd.txtCraftPointAdded"));
	m_statusGaugeMaxText = GetTextBoxHandle((m_Windowname $ ".statusGaugeMaxText"));
	statusCraftPoint.SetDecimalPlace(2);
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(1710);
	RegisterEvent(1720);
	RegisterEvent((100000 + 836));
	RegisterEvent((100000 + 837));
	RegisterEvent(9570);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	InitHandle();
	return;
}

function OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)), "RandomCraftWnd");
	Clear();
	craftPointMax = API_GetMaxItemPoint();
	craftChargeMax = API_GetMaxGaugeValue();
	m_Confirm_Wnd.HideWindow();
	SetItems();
	SetAdenaItem();
	SetStatusCraftPoint(craftCharge);
	CheckAddedCondition();
	SetCraftPointTxt();
	Me.SetFocus();
	return;
}

function SetStatusCraftPoint(int craftChargePercent, optional int pointAdded)
{
	craftPointAdded = pointAdded;
	if((((craftPoint + craftPointAdded) >= int(craftPointMax)) && (craftChargePercent >= (craftChargeMax - 1))))
	{
		m_statusGaugeMaxText.ShowWindow();
		statusCraftPoint.SetDrawPoint(false);
	}
	else
	{
		m_statusGaugeMaxText.HideWindow();
		statusCraftPoint.SetDrawPoint(true);
	}
	craftChargeAdded = craftChargePercent;
	statusCraftPoint.SetPointPercent(getInstanceL2Util().Get9999Percent(INT64(craftChargePercent), INT64(craftChargeMax)), INT64(0), INT64(craftChargeMax));
	return;
}

function CheckAddedCondition()
{
	local StatusBaseHandle Handle;

	Handle = statusCraftPoint.GetSelfScript();
	if((m_bottomList.GetItemNum() > 0))
	{
		m_SelectItemWnd.ShowWindow();
		statusCraftPoint.SetGaugeColor(7, GetColor(65, 90, 24, 255));
		GetButtonHandle((m_Windowname $ ".OKButton")).EnableWindow();
		GetButtonHandle((m_Windowname $ ".ResetButton")).SetButtonName(479);
	}
	else
	{
		m_SelectItemWnd.HideWindow();
		statusCraftPoint.SetGaugeColor(7, GetColor(5, 57, 134, 255));
		GetButtonHandle((m_Windowname $ ".OKButton")).DisableWindow();
		GetButtonHandle((m_Windowname $ ".ResetButton")).SetButtonName(938);
	}
	return;
}

function SetAdenaItem()
{
	local ItemInfo iInfo;
	local ItemID iID;

	iID.ClassID = 57;
	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(iID, iInfo);
	GetItemWindowHandle((m_Windowname $ ".AdenaIcon")).AddItem(iInfo);
	GetTextBoxHandle((m_Windowname $ ".Confirm_Wnd.ConfirmDetails_Wnd.PopupItemText")).SetText(iInfo.Name);
	GetItemWindowHandle((m_Windowname $ ".Confirm_Wnd.ConfirmDetails_Wnd.PopupIcon")).AddItem(iInfo);
	return;
}

function SetItems()
{
	local array<ItemInfo> iItems;
	local int i;

	iItems = InventoryWnd(GetScript("InventoryWnd")).getInventoryAllItemArray(true);
	i = 0;
	while((i < iItems.Length))
	{
		if(IsChargingItem(iItems[i]))
		{
			if(isCollectionItem(iItems[i]))
			{
				iItems[i].ForeTexture = "L2UI_EPIC.Icon.IconPanel_coll";
			}
			m_topList.AddItem(iItems[i]);
		}
		i++;
	}
	return;
}

function bool IsChargingItem(ItemInfo iInfo)
{
	if((iInfo.nGrindPoint <= 0))
	{
		return false;
	}
	if(iInfo.bSecurityLock)
	{
		return false;
	}
	if(!iInfo.bIsDesturctAble)
	{
		return false;
	}
	if((int(byte(iInfo.ItemType)) == 3))
	{
		return false;
	}
	if(isDamagedItem(iInfo))
	{
		return false;
	}
	return true;
}

function OnHide()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	m_topList.EnableWindow();
	m_bottomList.EnableWindow();
	if((DialogIsMine() && m_dialogWnd.IsShowWindow()))
	{
		DialogHide();
		m_dialogWnd.HideWindow();
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 1710:
			HandleDialogOK();
			break;
		case 1720:
			HandleDialogCancel();
			break;
		case EV_PacketID(837):
			ParsePacket_S_EX_CRAFT_EXTRACT();
			break;
		case 9570:
			HandleAdena();
			break;
		default:
			break;
	}
	return;
}

function HandleAdena()
{
	local INT64 Adena;
	local TextBoxHandle adenaCostText;

	Adena = GetAdena();
	adenaCostText = GetTextBoxHandle((m_Windowname $ ".Confirm_Wnd.ConfirmDetails_Wnd.PopupItemNumCurrentText"));
	if((Adena < craftChargePrice))
	{
		adenaCostText.SetTextColor(getInstanceL2Util().DRed);
		GetButtonHandle((m_Windowname $ ".Confirm_Wnd.ConfirmDetails_Wnd.PopupOK_BTN")).DisableWindow();
	}
	else
	{
		adenaCostText.SetTextColor(getInstanceL2Util().BLUE01);
		GetButtonHandle((m_Windowname $ ".Confirm_Wnd.ConfirmDetails_Wnd.PopupOK_BTN")).EnableWindow();
	}
	adenaCostText.SetText((("(" $ MakeCostString(string(Adena))) $ ")"));
	return;
}

event OnClickButton(string ControlName)
{
	if((ControlName == "OKButton"))
	{
		ShowPopup();
	}
	else if((ControlName == "CancelButton"))
	{
		Clear();
		HideWindow(m_Windowname);
	}
	else if((ControlName == "SortButton"))
	{
		getInstanceL2Util().SortItem(m_topList);
	}
	else if((ControlName == "ResetButton"))
	{
		Clear();
		SetItems();
	}
	else if((ControlName == "PopupOK_BTN"))
	{
		API_C_EX_CRAFT_EXTRACT();
		GetButtonHandle((m_Windowname $ ".Confirm_Wnd.ConfirmDetails_Wnd.PopupOK_BTN")).DisableWindow();
	}
	else if((ControlName == "PopupCancel_BTN"))
	{
		m_Confirm_Wnd.HideWindow();
	}
	return;
}

function OnRClickItem(string strID, int Index)
{
	OnDBClickItem(strID, Index);
	return;
}

function OnDBClickItem(string ControlName, int Index)
{
	if((Index >= 0))
	{
		if((ControlName == "TopList"))
		{
			MoveItemTopToBottom(Index, Class'NWindow.InputAPI'.static.IsAltPressed());
		}
		else if((ControlName == "BottomList"))
		{
			MoveItemBottomToTop(Index, Class'NWindow.InputAPI'.static.IsAltPressed());
		}
	}
	return;
}

function OnDropItem(string strID, ItemInfo Info, int X, int Y)
{
	local int Index;

	if(((strID == "TopList") && (Info.DragSrcName == "BottomList")))
	{
		Index = m_bottomList.FindItemWithAllProperty(Info);
		if((Index >= 0))
		{
			MoveItemBottomToTop(Index, (Info.AllItemCount > INT64(0)));
		}
	}
	else if(((strID == "BottomList") && (Info.DragSrcName == "TopList")))
	{
		Index = m_topList.FindItemWithAllProperty(Info);
		if((Index >= 0))
		{
			MoveItemTopToBottom(Index, (Info.AllItemCount > INT64(0)));
		}
	}
	return;
}

function Clear()
{
	m_topList.Clear();
	m_bottomList.Clear();
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".AdenaText"), "0");
	Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString((m_Windowname $ ".AdenaText"), "");
	SetStatusCraftPoint(craftCharge);
	CheckAddedCondition();
	m_SelectItemWnd.HideWindow();
	m_Confirm_Wnd.HideWindow();
	m_statusGaugeMaxText.HideWindow();
	return;
}

function MoveItemTopToBottom(int Index, bool bAllItem)
{
	local ItemInfo topInfo, bottomInfo;
	local int bottomIndex;
	local INT64 toAddNum;

	if(m_statusGaugeMaxText.IsShowWindow())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13101));
		return;
	}
	if(!m_topList.IsEnableWindow())
	{
		return;
	}
	if(m_topList.GetItem(Index, topInfo))
	{
		if(((!bAllItem && IsStackableItem(topInfo.ConsumeType)) && (topInfo.ItemNum > INT64(1))))
		{
			toAddNum = CheckNumEnough(topInfo.ItemNum, topInfo.nGrindPoint, true);
			DialogSetID(111);
			DialogSetReservedItemID(topInfo.Id);
			DialogSetParamInt64(topInfo.ItemNum);
			DialogSetDefaultOK();
			DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), topInfo.Name, ""));
			m_topList.DisableWindow();
			m_bottomList.DisableWindow();
			DialogSetInputlimit(toAddNum);
			Class'Interface.DialogBox'.static.Inst().SetEditMessage(string(toAddNum));
			Class'Interface.DialogBox'.static.Inst()._AllSelect();
		}
		else
		{
			toAddNum = CheckNumEnough(topInfo.ItemNum, topInfo.nGrindPoint);
			bottomIndex = m_bottomList.FindItem(topInfo.Id);
			if((topInfo.ItemNum == toAddNum))
			{
				m_topList.DeleteItem(Index);
			}
			else
			{
				topInfo.ItemNum = (topInfo.ItemNum - toAddNum);
				m_topList.SetItem(Index, topInfo);
			}
			if(((bottomIndex != -1) && IsStackableItem(topInfo.ConsumeType)))
			{
				m_bottomList.GetItem(bottomIndex, bottomInfo);
				(bottomInfo.ItemNum += toAddNum);
				m_bottomList.SetItem(bottomIndex, bottomInfo);
			}
			else
			{
				topInfo.ItemNum = toAddNum;
				m_bottomList.AddItem(topInfo);
			}
			SetChargingInfos();
		}
	}
	return;
}

function MoveItemBottomToTop(int Index, bool bAllItem)
{
	local ItemInfo bottomInfo, topInfo;
	local int topIndex;

	if(!m_bottomList.IsEnableWindow())
	{
		return;
	}
	if(m_bottomList.GetItem(Index, bottomInfo))
	{
		if(((!bAllItem && IsStackableItem(bottomInfo.ConsumeType)) && (bottomInfo.ItemNum > INT64(1))))
		{
			DialogSetID(222);
			DialogSetReservedItemID(bottomInfo.Id);
			DialogSetParamInt64(bottomInfo.ItemNum);
			DialogSetDefaultOK();
			DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), bottomInfo.Name, ""));
			m_topList.DisableWindow();
			m_bottomList.DisableWindow();
			DialogSetInputlimit(bottomInfo.ItemNum);
			Class'Interface.DialogBox'.static.Inst().SetEditMessage(string(bottomInfo.ItemNum));
			Class'Interface.DialogBox'.static.Inst()._AllSelect();
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
			SetChargingInfos();
		}
	}
	return;
}

function HandleDialogCancel()
{
	m_topList.EnableWindow();
	m_bottomList.EnableWindow();
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
		Id = DialogGetID();
		Num = INT64(DialogGetString());
		cID = DialogGetReservedItemID();
		m_topList.EnableWindow();
		m_bottomList.EnableWindow();
		if(((Id == 111) && (Num > INT64(0))))
		{
			topIndex = m_topList.FindItem(cID);
			if((topIndex >= 0))
			{
				m_topList.GetItem(topIndex, topInfo);
				Num = Min64(Num, topInfo.ItemNum);
				Num = CheckNumEnough(Num, topInfo.nGrindPoint);
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
					Info.bShowCount = false;
					m_bottomList.AddItem(Info);
				}
				(topInfo.ItemNum -= Num);
				if((topInfo.ItemNum <= INT64(0)))
				{
					m_topList.DeleteItem(topIndex);
				}
				else
				{
					m_topList.SetItem(topIndex, topInfo);
				}
			}
		}
		else if(((Id == 222) && (Num > INT64(0))))
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
			}
		}
		SetChargingInfos();
	}
	return;
}

function HandleOKButton()
{
	HideWindow(m_Windowname);
	return;
}

function ShowPopup()
{
	HandleAdena();
	m_Confirm_Wnd.ShowWindow();
	m_Confirm_Wnd.SetFocus();
	return;
}

function INT64 GetCraftChargeCurrentTotal()
{
	return INT64(((craftPoint * craftChargeMax) + craftCharge));
}

function SetChargingInfos()
{
	local int i;
	local INT64 craftChargePercent;
	local string addedString;
	local INT64 tmpCraftPointAdded, tmpCraftPointTotal, craftChargeAdded, CraftChargeCurrentTotal;
	local ItemInfo iInfo;

	craftChargeAdded = INT64(0);
	craftChargePrice = INT64(0);
	i = 0;
	while((i < m_bottomList.GetItemNum()))
	{
		m_bottomList.GetItem(i, iInfo);
		craftChargeAdded = (craftChargeAdded + (INT64(iInfo.nGrindPoint) * iInfo.ItemNum));
		craftChargePrice = (craftChargePrice + (INT64(iInfo.nGrindCommission) * iInfo.ItemNum));
		i++;
	}
	CraftChargeCurrentTotal = GetCraftChargeCurrentTotal();
	tmpCraftPointTotal = ((craftChargeAdded + CraftChargeCurrentTotal) / INT64(craftChargeMax));
	if((tmpCraftPointTotal > INT64(int(craftPointMax))))
	{
		tmpCraftPointAdded = INT64((int(craftPointMax) - craftPoint));
		craftChargePercent = INT64(craftChargeMax);
	}
	else
	{
		tmpCraftPointAdded = (tmpCraftPointTotal - INT64(craftPoint));
		craftChargePercent = ((CraftChargeCurrentTotal + craftChargeAdded) - (tmpCraftPointTotal * INT64(craftChargeMax)));
	}
	SetStatusCraftPoint(int(craftChargePercent), int(tmpCraftPointAdded));
	CheckAddedCondition();
	addedString = (("+ " $ string(tmpCraftPointAdded)) @ GetSystemString(2293));
	m_txtCraftPointAdded.SetText(addedString);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".AdenaText"), MakeCostString(string(craftChargePrice)));
	Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString((m_Windowname $ ".AdenaText"), ConvertNumToText(string(craftChargePrice)));
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".Confirm_Wnd.ConfirmDetails_Wnd.PopupItemNumText"), ("x" $ MakeCostString(string(craftChargePrice))));
	Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString((m_Windowname $ ".Confirm_Wnd.ConfirmDetails_Wnd.PopupItemNumText"), ConvertNumToText(string(craftChargePrice)));
	return;
}

function INT64 CheckNumEnough(INT64 itemMax, int nGrindPoint, optional bool notShowMsg)
{
	local INT64 enoughNum;

	enoughNum = GetNumEnough(itemMax, nGrindPoint);
	if(((itemMax != enoughNum) && !notShowMsg))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13101));
	}
	return enoughNum;
}

function INT64 GetNumEnough(INT64 itemMax, int nGrindPoint)
{
	local INT64 CraftChargeCurrentTotal, canPutChargeNum, canCharge;

	CraftChargeCurrentTotal = INT64((((craftPoint * craftChargeMax) + (craftPointAdded * craftChargeMax)) + craftChargeAdded));
	canCharge = INT64((((int(craftPointMax) * craftChargeMax) + craftChargeMax) - 1));
	canCharge = (canCharge - CraftChargeCurrentTotal);
	canPutChargeNum = (canCharge / INT64(nGrindPoint));
	if(((canPutChargeNum * INT64(nGrindPoint)) < canCharge))
	{
		canPutChargeNum = (canPutChargeNum + INT64(1));
	}
	return Min64(itemMax, canPutChargeNum);
}

function SetShowPopup()
{
	m_Confirm_Wnd.ShowWindow();
	m_Confirm_Wnd.SetFocus();
	return;
}

function int API_GetMaxGaugeValue()
{
	return Class'NWindow.RandomCraftAPI'.static.GetMaxGaugeValue();
}

function byte API_GetMaxItemPoint()
{
	return Class'NWindow.RandomCraftAPI'.static.GetMaxItemPoint();
}

function API_C_EX_CRAFT_EXTRACT()
{
	local array<byte> stream;
	local UIPacket._C_EX_CRAFT_EXTRACT packet;
	local ItemInfo iInfo;
	local int i;

	packet.Items.Length = m_bottomList.GetItemNum();
	i = 0;
	while((i < m_bottomList.GetItemNum()))
	{
		m_bottomList.GetItem(i, iInfo);
		packet.Items[i].nItemServerId = iInfo.Id.ServerID;
		packet.Items[i].nAmount = iInfo.ItemNum;
		i++;
	}
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_CRAFT_EXTRACT(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(619, stream);
	return;
}

function ParsePacket_S_EX_CRAFT_EXTRACT()
{
	local UIPacket._S_EX_CRAFT_EXTRACT packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_CRAFT_EXTRACT(packet))
	{
		return;
	}
	switch(packet.cResult)
	{
		case 0:
			m_bottomList.Clear();
			CheckAddedCondition();
			break;
		default:
			break;
	}
	m_Confirm_Wnd.HideWindow();
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".AdenaText"), "0");
	Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString((m_Windowname $ ".AdenaText"), "");
	return;
}

function ParsePacket_S_EX_CRAFT_INFO(UIPacket._S_EX_CRAFT_INFO packet)
{
	craftPoint = packet.nPoint;
	craftCharge = packet.nCharge;
	SetStatusCraftPoint(craftCharge, craftPointAdded);
	CheckAddedCondition();
	SetCraftPointTxt();
	if((int(packet.bGiveItem) > 0))
	{
		GetTextureHandle("RandomCraftChargingWnd.CraftIcon").SetTexture("L2UI_CT1.InfoWnd.InfoWnd_RandomCraftIcon");
	}
	else
	{
		GetTextureHandle("RandomCraftChargingWnd.CraftIcon").SetTexture("L2UI_CT1.InfoWnd.InfoWnd_RandomCraftIcon_dis");
	}
	return;
}

function SetCraftPointTxt()
{
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".txtCraftPoint"), ((((GetSystemString(13159) @ "x") $ string(craftPoint)) $ "/") $ string(craftPointMax)));
	return;
}

function OnReceivedCloseUI()
{
	if(m_Confirm_Wnd.IsShowWindow())
	{
		m_Confirm_Wnd.HideWindow();
	}
	else
	{
		GetWindowHandle(m_Windowname).HideWindow();
	}
	return;
}

defaultproperties
{
	m_Windowname="RandomCraftChargingWnd"
}
