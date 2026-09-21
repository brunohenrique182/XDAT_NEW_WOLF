class DethroneShopWnd extends UICommonAPI
	dependson(UIPacket);

var array<byte> _emptyByteArray;

var WindowHandle Me;
var WindowHandle UIControlDialogAsset;
var WindowHandle inputItemWnd;
var WindowHandle BuyItemRichListCtrl;
var RichListCtrlHandle NeedItemRichListCtrl;
var RichListCtrlHandle Shop_RichListCtrl;
var WindowHandle disableWnd;
var string m_Windowname;
var UIControlDialogAssets popupExpandScript;
var UIControlNumberInput inputItemScript;
var UIControlNeedItemList needItemScript;
var ButtonHandle Buy_Button;
var L2Util util;
var int selectnSlotNum;
var int selectIndex;
var INT64 CurrentSP;
var INT64 currentDP;
var array<DethroneShopUIData> shopDataArray;
var int tryBuyID;
var INT64 tryBuyAmount;
var int spIndex;
var int dpIndex;
var L2UITimerObject delayTimeObject;

function OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(1088));
	RegisterEvent(EV_PacketID(1089));
	RegisterEvent(180);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

function SetPopupScript()
{
	local WindowHandle poopExpandWnd, disableWnd;

	poopExpandWnd = GetWindowHandle((m_Windowname $ ".UIControlDialogAsset"));
	popupExpandScript = Class'Interface.UIControlDialogAssets'.static.InitScript(poopExpandWnd);
	popupExpandScript.DelegateOnCancel = OnClickPopupCancel;
	popupExpandScript.DelegateOnClickBuy = OnClickPopupBuy;
	popupExpandScript.SetUseBuyItem(true);
	popupExpandScript.SetUseNeedItem(false);
	popupExpandScript.SetUseNumberInput(false);
	disableWnd = GetWindowHandle((m_Windowname $ ".DisableWnd"));
	popupExpandScript.SetDisableWindow(disableWnd);
	Class'NWindow.UIAPI_WINDOW'.static.SetAlwaysOnTop((m_Windowname $ ".DisableWnd"), false);
	return;
}

function OnClickPopupBuy()
{
	API_C_EX_DETHRONE_SHOP_BUY(tryBuyID, tryBuyAmount);
	GetPopupExpandScript().Hide();
	showDisable(false);
	return;
}

function OnClickPopupCancel()
{
	GetPopupExpandScript().Hide();
	showDisable(false);
	return;
}

function UIControlDialogAssets GetPopupExpandScript()
{
	local WindowHandle popExpandWnd;

	popExpandWnd = GetWindowHandle((m_Windowname $ ".UIControlDialogAsset"));
	return UIControlDialogAssets(popExpandWnd.GetScript());
}

function InitNeedItem()
{
	BuyItemRichListCtrl.SetScript("UIControlNeedItemList");
	needItemScript = UIControlNeedItemList(BuyItemRichListCtrl.GetScript());
	needItemScript.SetRichListControler(NeedItemRichListCtrl);
	needItemScript.DelegateOnUpdateItem = DelegateOnUpdateItem;
	return;
}

function DelegateOnUpdateItem()
{
	inputItemScript.SetControlerBtns();
	if((needItemScript.GetMaxNumCanBuy() > INT64(0)))
	{
		if((inputItemScript.GetCount() > INT64(0)))
		{
			Buy_Button.EnableWindow();
		}
		else
		{
			Buy_Button.DisableWindow();
		}
	}
	else
	{
		Buy_Button.DisableWindow();
	}
	return;
}

function InitInputControl()
{
	inputItemWnd.SetScript("UIControlNumberInput");
	inputItemScript = UIControlNumberInput(inputItemWnd.GetScript());
	inputItemScript.Init((m_Windowname $ ".ShopItemInfoWnd.inputItemWnd"));
	inputItemScript.DelegateGetCountCanBuy = MaxNumCanBuy;
	inputItemScript.delegateOnItemCountEdited = OnItemCountChanged;
	inputItemScript.DelegateESCKey = OnESCKey;
	inputItemScript.Reset_Btn = GetButtonHandle((m_Windowname $ ".ShopItemInfoWnd.inputItemWnd.Reset_Btn"));
	inputItemScript.Buy_Btn = GetButtonHandle((m_Windowname $ ".ShopItemInfoWnd.Buy_Button"));
	return;
}

function INT64 MaxNumCanBuy()
{
	local RichListCtrlRowData rowData;
	local int Index;
	local INT64 Count;
	local ItemInfo Info;

	Index = Shop_RichListCtrl.GetSelectedIndex();
	Shop_RichListCtrl.GetRec(Index, rowData);
	Info = GetItemInfoByClassID(int(rowData.nReserved1));
	if(IsStackableItem(Info.ConsumeType))
	{
		Count = INT64(Min(int(needItemScript.GetMaxNumCanBuy()), 9999));
	}
	else
	{
		Count = needItemScript.GetMaxNumCanBuy();
	}
	return Count;
}

function OnItemCountChanged(INT64 ItemCount)
{
	ItemCount = MAX64(INT64(1), ItemCount);
	needItemScript.SetBuyNum(ItemCount);
	return;
}

event OnShow()
{
	local int i;

	API_C_EX_DETHRONE_SHOP_OPEN_UI();
	shopDataArray.Length = 0;
	Class'NWindow.UIDataManager'.static.GetDethroneShopDataList(shopDataArray);
	showDisable(false);
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	Shop_RichListCtrl.DeleteAllItem();
	i = 0;
	while((i < shopDataArray.Length))
	{
		Shop_RichListCtrl.InsertRecord(makeRecord(shopDataArray[i].item.ItemClassID, shopDataArray[i].item.ItemAmount, shopDataArray[i].Id));
		i++;
	}
	spIndex = -1;
	dpIndex = -1;
	Shop_RichListCtrl.SetSelectedIndex(0, true);
	Class'Interface.L2UITimer'.static.Inst()._AddTimerOnce(100)._DelegateOnTime = OnTime;
	return;
}

function OnTime(int Count)
{
	ClickRecord();
	return;
}

event OnHide()
{
	needItemScript.CleariObjects();
	Class'NWindow.UIAPI_MULTISELLITEMINFO'.static.Clear("DethroneShopWnd.multiSellItemInfo");
	return;
}

function int getNeedItemsIndexByID(int Id)
{
	local int i;

	i = 0;
	while((i < shopDataArray.Length))
	{
		if((shopDataArray[i].Id == Id))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function RichListCtrlRowData makeRecord(int nItemClassID, int nItemAmount, int Id)
{
	local RichListCtrlRowData Record;
	local ItemInfo iInfo;
	local string toolTipParam;

	Record.cellDataList.Length = 1;
	iInfo = GetItemInfoByClassID(nItemClassID);
	iInfo.ItemNum = INT64(nItemAmount);
	ItemInfoToParam(iInfo, toolTipParam);
	Record.szReserved = toolTipParam;
	Record.nReserved1 = INT64(iInfo.Id.ClassID);
	Record.nReserved2 = iInfo.ItemNum;
	Record.nReserved3 = INT64(Id);
	AddRichListCtrlItem(Record.cellDataList[0].drawitems, iInfo, 32, 32, 4, 6);
	AddRichListCtrlString(Record.cellDataList[0].drawitems, GetItemNameAllByClassID(iInfo.Id.ClassID), GTColor().White, false, 4, 9);
	AddRichListCtrlString(Record.cellDataList[0].drawitems, (" x" $ string(iInfo.ItemNum)), GTColor().Gold, false, 0, 0);
	return Record;
}

function Initialize()
{
	Me = GetWindowHandle(m_Windowname);
	UIControlDialogAsset = GetWindowHandle((m_Windowname $ ".UIControlDialogAsset"));
	inputItemWnd = GetWindowHandle((m_Windowname $ ".ShopItemInfoWnd.inputItemWnd"));
	BuyItemRichListCtrl = GetWindowHandle((m_Windowname $ ".ShopItemInfoWnd.BuyItemRichListCtrl"));
	NeedItemRichListCtrl = GetRichListCtrlHandle((m_Windowname $ ".ShopItemInfoWnd.BuyItemRichListCtrl.NeedItemRichListCtrl"));
	Shop_RichListCtrl = GetRichListCtrlHandle((m_Windowname $ ".ShopListWnd.Shop_RichListCtrl"));
	disableWnd = GetWindowHandle((m_Windowname $ ".DisableWnd"));
	Buy_Button = GetButtonHandle((m_Windowname $ ".ShopItemInfoWnd.Buy_Button"));
	util = L2Util(GetScript("L2Util"));
	Shop_RichListCtrl.SetSelectedSelTooltip(false);
	Shop_RichListCtrl.SetAppearTooltipAtMouseX(true);
	selectIndex = 0;
	SetPopupScript();
	InitNeedItem();
	InitInputControl();
	delayTimeObject = Class'Interface.L2UITimer'.static.Inst()._MakeTimerObject(1, 1);
	delayTimeObject._DelegateOnTime = delayAutoCall;
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 180:
			HandleUpdateUserInfo();
			break;
		case EV_PacketID(1088):
			HandleS_EX_DETHRONE_SHOP_BUY();
			break;
		case EV_PacketID(1089):
			HandleS_EX_DETHRONE_POINT_INFO();
			break;
		default:
			break;
	}
	return;
}

function HandleUpdateUserInfo()
{
	local UserInfo UserInfo;

	if(Me.IsShowWindow())
	{
		GetPlayerInfo(UserInfo);
		CurrentSP = UserInfo.nSP;
		if(Me.IsShowWindow())
		{
			if(((NeedItemRichListCtrl.GetRecordCount() > 0) && (spIndex > -1)))
			{
				needItemScript.ModifyCurrentAmount(spIndex, CurrentSP);
				DelegateOnUpdateItem();
			}
		}
	}
	return;
}

function HandleS_EX_DETHRONE_SHOP_BUY()
{
	local UIPacket._S_EX_DETHRONE_SHOP_BUY packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_DETHRONE_SHOP_BUY(packet))
	{
		return;
	}
	Debug(("packet.bSuccess" @ string(packet.bSuccess)));
	if((int(packet.bSuccess) > 0))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(6001));
	}
	else
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(6002));
	}
	showDisable(false);
	delayTimeObject._Stop();
	delayTimeObject._Play();
	return;
}

function delayAutoCall(int Count)
{
	Debug(("needItemScript.GetMaxNumCanBuy()" @ string(needItemScript.GetMaxNumCanBuy())));
	if((needItemScript.GetMaxNumCanBuy() > INT64(0)))
	{
		inputItemScript.SetCount(INT64(1));
	}
	else
	{
		inputItemScript.SetCount(INT64(int(needItemScript.GetMaxNumCanBuy())));
	}
	return;
}

function HandleS_EX_DETHRONE_POINT_INFO()
{
	local UIPacket._S_EX_DETHRONE_POINT_INFO packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_DETHRONE_POINT_INFO(packet))
	{
		return;
	}
	currentDP = packet.nPersonalPoint;
	if(Me.IsShowWindow())
	{
		if(((NeedItemRichListCtrl.GetRecordCount() > 0) && (dpIndex > -1)))
		{
			needItemScript.ModifyCurrentAmount(dpIndex, currentDP);
			DelegateOnUpdateItem();
		}
	}
	Debug(("currentDP" @ string(currentDP)));
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "Buy_Button":
			OnBuy_ButtonClick();
			break;
		default:
			break;
	}
	return;
}

function OnBuy_ButtonClick()
{
	local RichListCtrlRowData rowData;
	local ItemInfo Info;

	if((Shop_RichListCtrl.GetSelectedIndex() < 0))
	{
		util.showGfxScreenMessage(GetSystemMessage(326));
		return;
	}
	Shop_RichListCtrl.GetSelectedRec(rowData);
	tryBuyID = int(rowData.nReserved3);
	tryBuyAmount = inputItemScript.GetCount();
	Info = GetItemInfoByClassID(int(rowData.nReserved1));
	popupExpandScript.SetDialogDesc(MakeFullSystemMsg(GetSystemMessage(13404), GetItemNameAll(Info)));
	popupExpandScript.SetBuyItemClassID(Info.Id.ClassID, int(rowData.nReserved2));
	popupExpandScript.SetItemNum(int(inputItemScript.GetCount()));
	popupExpandScript.OKButton.EnableWindow();
	popupExpandScript.Show();
	showDisable(true);
	return;
}

event OnClickListCtrlRecord(string ListCtrlID)
{
	switch(ListCtrlID)
	{
		case "Shop_RichListCtrl":
			ClickRecord();
			break;
		default:
			break;
	}
	return;
}

event OnDBClickListCtrlRecord(string ListCtrlID)
{
	switch(ListCtrlID)
	{
		case "Shop_RichListCtrl":
			if((needItemScript.GetMaxNumCanBuy() > INT64(0)))
			{
				OnBuy_ButtonClick();
			}
			break;
		default:
			break;
	}
	return;
}

function ClickRecord()
{
	local int i, Index, needItemIndex;
	local ItemInfo Info;
	local RichListCtrlRowData rowData;

	Index = Shop_RichListCtrl.GetSelectedIndex();
	if((Index <= -1))
	{
		return;
	}
	Shop_RichListCtrl.GetRec(Index, rowData);
	Info = GetItemInfoByClassID(int(rowData.nReserved1));
	Class'NWindow.UIAPI_MULTISELLITEMINFO'.static.Clear("DethroneShopWnd.multiSellItemInfo");
	Class'NWindow.UIAPI_MULTISELLITEMINFO'.static.SetItemInfo("DethroneShopWnd.multiSellItemInfo", 0, Info);
	needItemIndex = getNeedItemsIndexByID(int(rowData.nReserved3));
	if((needItemIndex > -1))
	{
		NeedItemRichListCtrl.DeleteAllItem();
		needItemScript.StartNeedItemList(shopDataArray[needItemIndex].NeedItemList.Length);
		spIndex = -1;
		dpIndex = -1;
		i = 0;
		while((i < shopDataArray[needItemIndex].NeedItemList.Length))
		{
			Debug(("필요아이템 classid:" @ string(shopDataArray[needItemIndex].NeedItemList[i].ItemClassID)));  // EN?: Required item classid:
			if((shopDataArray[needItemIndex].NeedItemList[i].ItemClassID == 82499))
			{
				dpIndex = needItemScript.AddNeeItemInfo(GetItemInfoByClassID(82499), INT64(shopDataArray[needItemIndex].NeedItemList[i].ItemAmount), currentDP);
				i++;
				continue;
			}
			if((shopDataArray[needItemIndex].NeedItemList[i].ItemClassID == 82500))
			{
				CurrentSP = getInstanceUIData().GetCurrentSP();
				spIndex = needItemScript.AddNeeItemInfo(GetItemInfoByClassID(82500), INT64(shopDataArray[needItemIndex].NeedItemList[i].ItemAmount), CurrentSP);
				i++;
				continue;
			}
			needItemScript.AddNeedItemClassID(shopDataArray[needItemIndex].NeedItemList[i].ItemClassID, INT64(shopDataArray[needItemIndex].NeedItemList[i].ItemAmount));
			i++;
		}
	}
	if((needItemScript.GetMaxNumCanBuy() > INT64(0)))
	{
		inputItemScript.SetCount(INT64(1));
	}
	else
	{
		inputItemScript.SetCount(INT64(int(needItemScript.GetMaxNumCanBuy())));
	}
	return;
}

function showDisable(bool bShow)
{
	if(bShow)
	{
		GetWindowHandle((m_Windowname $ ".DisableWnd")).ShowWindow();
		GetEditBoxHandle((m_Windowname $ ".ShopItemInfoWnd.inputItemWnd.ItemCount_EditBox")).HideWindow();
	}
	else
	{
		GetWindowHandle((m_Windowname $ ".DisableWnd")).HideWindow();
		GetEditBoxHandle((m_Windowname $ ".ShopItemInfoWnd.inputItemWnd.ItemCount_EditBox")).ShowWindow();
	}
	return;
}

function API_C_EX_DETHRONE_SHOP_BUY(int ClassID, INT64 nCount)
{
	local array<byte> stream;
	local UIPacket._C_EX_DETHRONE_SHOP_BUY packet;

	packet.nID = ClassID;
	packet.nCount = nCount;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_DETHRONE_SHOP_BUY(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(839, stream);
	Debug((("API Call --> C_EX_DETHRONE_SHOP_BUY" @ string(ClassID)) @ string(nCount)));
	return;
}

function API_C_EX_DETHRONE_SHOP_OPEN_UI()
{
	Class'Interface.UIPacket'.static.RequestUIPacket(838, _emptyByteArray);
	Debug("API Call --> C_EX_DETHRONE_SHOP_OPEN_UI");
	return;
}

function OnESCKey()
{
	Shop_RichListCtrl.SetFocus();
	return;
}

function OnReceivedCloseUI()
{
	showDisable(false);
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="DethroneShopWnd"
}
