class ClanShopWndClassic extends UICommonAPI
	dependson(UIPacket);

const MAXITEMNUM = 99999;
const MAX_CATEGORY = 6;
const COSTITEMNUM = 5;
const ShopIndex = 100;
const TIMER_CLICK = 99902;
const TIMER_DELAYC = 3000;

struct PLShopItemDataStruct
{
	var int Index;
	var int nSlotNum;
	var int nItemClassID;
	var int nCostItemId[5];
	var INT64 nCostItemAmount[5];
	var int nRemainItemAmount;
	var int nRemainSec;
	var int nRemainServerItemAmount;
	var int PledgeLevel;
};

var string m_Windowname;
var WindowHandle Me;
var ButtonHandle Refresh_Button;
var ButtonHandle Close_Button;
var WindowHandle ClanShopListWnd;
var RichListCtrlHandle ClanShop_RichListCtrl;
var WindowHandle ItemInfo_DisableWnd;
var TextBoxHandle ItemInfoDscrp_tex;
var WindowHandle ClanShopItemInfoWnd;
var TextBoxHandle ItemInfo_Text;
var TextBoxHandle NeedItemTitle_Text;
var WindowHandle BuyItemRichListCtrl;
var RichListCtrlHandle RichListCtrl;
var WindowHandle inputItemWnd;
var ButtonHandle Buy_Button;
var int nPledgeCoin;
var array<PLShopItemDataStruct> pLShopItemDataList;
var UIControlDialogAssets popupExpandScript;
var UIControlNumberInput inputItemScript;
var UIControlNeedItemList needItemScript;
var L2Util util;
var int selectnSlotNum;
var int selectIndex;
var int AddClanNeedPointListIndex;

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("ClanShopWndClassic");
	Refresh_Button = GetButtonHandle("ClanShopWndClassic.Refresh_Button");
	Close_Button = GetButtonHandle("ClanShopWndClassic.Close_Button");
	ClanShopListWnd = GetWindowHandle("ClanShopWndClassic.ClanShopListWnd");
	ClanShop_RichListCtrl = GetRichListCtrlHandle("ClanShopWndClassic.ClanShopListWnd.ClanShop_RichListCtrl");
	ItemInfo_DisableWnd = GetWindowHandle("ClanShopWndClassic.ItemInfo_DisableWnd");
	ItemInfoDscrp_tex = GetTextBoxHandle("ClanShopWndClassic.ItemInfo_DisableWnd.ItemInfoDscrp_tex");
	ClanShopItemInfoWnd = GetWindowHandle("ClanShopWndClassic.ClanShopItemInfoWnd");
	ItemInfo_Text = GetTextBoxHandle("ClanShopWndClassic.ClanShopItemInfoWnd.ItemInfo_Text");
	NeedItemTitle_Text = GetTextBoxHandle("ClanShopWndClassic.ClanShopItemInfoWnd.NeedItemTitle_Text");
	BuyItemRichListCtrl = GetWindowHandle("ClanShopWndClassic.ClanShopItemInfoWnd.BuyItemRichListCtrl");
	RichListCtrl = GetRichListCtrlHandle("ClanShopWndClassic.ClanShopItemInfoWnd.BuyItemRichListCtrl.RichListCtrl");
	inputItemWnd = GetWindowHandle("ClanShopWndClassic.ClanShopItemInfoWnd.inputItemWnd");
	Buy_Button = GetButtonHandle("ClanShopWndClassic.ClanShopItemInfoWnd.Buy_Button");
	util = L2Util(GetScript("L2Util"));
	ClanShop_RichListCtrl.SetSelectedSelTooltip(false);
	ClanShop_RichListCtrl.SetAppearTooltipAtMouseX(true);
	selectIndex = 0;
	SetPopupScript();
	InitNeedItem();
	InitInputControl();
	return;
}

function SetPopupScript()
{
	local WindowHandle poopExpandWnd, disableWnd;

	poopExpandWnd = GetWindowHandle((m_Windowname $ ".UIControlDialogAsset"));
	popupExpandScript = Class'InterfaceClassic.UIControlDialogAssets'.static.InitScript(poopExpandWnd);
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
	API_RequestPurchaseLimitShopItemBuy(selectnSlotNum, int(inputItemScript.GetCount()));
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

function API_RequestPurchaseLimitShopItemBuy(int nSlotNum, int nItemAmount)
{
	RequestPurchaseLimitShopItemBuy(100, nSlotNum, nItemAmount);
	return;
}

function InitNeedItem()
{
	BuyItemRichListCtrl.SetScript("UIControlNeedItemList");
	needItemScript = UIControlNeedItemList(BuyItemRichListCtrl.GetScript());
	needItemScript.SetRichListControler(RichListCtrl);
	return;
}

function InitInputControl()
{
	inputItemWnd.SetScript("UIControlNumberInput");
	inputItemScript = UIControlNumberInput(inputItemWnd.GetScript());
	inputItemScript.Init((m_Windowname $ ".ClanShopItemInfoWnd.inputItemWnd"));
	inputItemScript.DelegateGetCountCanBuy = MaxNumCanBuy;
	inputItemScript.delegateOnItemCountEdited = OnItemCountChanged;
	inputItemScript.DelegateESCKey = OnESCKey;
	inputItemScript.Reset_Btn = GetButtonHandle("ClanShopWndClassic.ClanShopItemInfoWnd.inputItemWnd.Clear_Button");
	inputItemScript.Buy_Btn = GetButtonHandle((m_Windowname $ ".ClanShopItemInfoWnd.Buy_Button"));
	return;
}

function INT64 MaxNumCanBuy()
{
	local RichListCtrlRowData rowData;
	local int Count, Index;
	local ItemInfo Info;
	local PLShopItemDataStruct ItemData;

	Index = ClanShop_RichListCtrl.GetSelectedIndex();
	ClanShop_RichListCtrl.GetRec(Index, rowData);
	ItemData = pLShopItemDataList[int(rowData.nReserved1)];
	Info = GetItemInfoByClassID(ItemData.nItemClassID);
	if((rowData.nReserved2 == INT64(0)))
	{
		Count = 0;
	}
	else if(IsStackableItem(Info.ConsumeType))
	{
		Count = Min(int(needItemScript.GetMaxNumCanBuy()), GetCountCanBuyByIndex(selectIndex));
	}
	else
	{
		Count = 1;
	}
	return INT64(Count);
}

function OnItemCountChanged(INT64 ItemCount)
{
	ItemCount = MAX64(INT64(1), ItemCount);
	needItemScript.SetBuyNum(ItemCount);
	return;
}

event OnShow()
{
	Debug(" ------------------ OnShow  ClanShopWndClassic");
	API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST();
	showDisable(false);
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	return;
}

function OnRegisterEvent()
{
	RegisterEvent((100000 + 849));
	RegisterEvent((100000 + 949));
	RegisterEvent(11064);
	RegisterEvent(40);
	return;
}

function Load()
{
	return;
}

function API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST()
{
	local array<byte> stream;
	local UIPacket._C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST packet;

	packet.cShopIndex = 100;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(563, stream);
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case (100000 + 849):
			HandleS_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST_NEW();
			break;
		case (100000 + 949):
			HandleS_EX_PLEDGE_COIN_INFO();
			break;
		case 11064:
			if(!IsMyShopIndex(param))
			{
				return;
			}
			HandleBuyResult(param);
			break;
		case 40:
			selectIndex = 0;
			break;
		default:
			break;
	}
	return;
}

function HandleS_EX_PLEDGE_COIN_INFO()
{
	local UIPacket._S_EX_PLEDGE_COIN_INFO packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_PLEDGE_COIN_INFO(packet))
	{
		return;
	}
	nPledgeCoin = packet.nPledgeCoin;
	return;
}

function HandleBuyResult(string param)
{
	local int Result;
	local PLShopItemDataStruct ItemData;
	local ItemInfo Info;

	Debug(("HandleBuyResult param" @ param));
	ParseInt(param, "Result", Result);
	GetPopupExpandScript().Hide();
	showDisable(false);
	switch(Result)
	{
		case 0:
			ItemData = pLShopItemDataList[selectIndex];
			Info = GetItemInfoByClassID(ItemData.nItemClassID);
			util.showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(13403), GetItemNameAll(Info)));
			AddSystemMessageString(MakeFullSystemMsg(GetSystemMessage(13403), GetItemNameAll(Info)));
			OnRefresh_ButtonClick();
			break;
		case 7:
			util.showGfxScreenMessage(GetSystemMessage(3675));
			AddSystemMessageString(GetSystemMessage(3675));
			break;
		case 4:
			util.showGfxScreenMessage(GetSystemMessage(13390));
			AddSystemMessageString(GetSystemMessage(13390));
			break;
		case 3:
			util.showGfxScreenMessage(GetSystemMessage(13389));
			AddSystemMessageString(GetSystemMessage(13389));
			break;
		case 2:
			util.showGfxScreenMessage(GetSystemMessage(13052));
			AddSystemMessageString(GetSystemMessage(13052));
			break;
		case 9:
			util.showGfxScreenMessage(GetSystemMessage(13391));
			AddSystemMessageString(GetSystemMessage(13391));
			break;
		case 1:
		case 5:
		case 6:
		case 8:
		case 11:
		default:
			util.showGfxScreenMessage(GetSystemMessage(4559));
			AddSystemMessageString(GetSystemMessage(4559));
			break;
	}
	return;
}

function ClearAll()
{
	pLShopItemDataList.Length = 0;
	ClanShop_RichListCtrl.DeleteAllItem();
	RichListCtrl.DeleteAllItem();
	return;
}

function bool IsMyShopIndex(string param)
{
	local int nShopIndex;

	ParseInt(param, "ShopIndex", nShopIndex);
	return (100 == nShopIndex);
}

function HandleS_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST_NEW()
{
	local UIPacket._S_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST_NEW packet;
	local int i, j;
	local PLShopItemDataStruct pLShopItemData;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST_NEW(packet))
	{
		return;
	}
	if((packet.cShopIndex != 100))
	{
		return;
	}
	if((packet.cPage == 1))
	{
		ClearAll();
	}
	i = 0;
	while((i < packet.vItemList.Length))
	{
		pLShopItemData.Index = i;
		pLShopItemData.nSlotNum = packet.vItemList[i].nSlotNum;
		pLShopItemData.nItemClassID = packet.vItemList[i].nItemClassID;
		pLShopItemData.nRemainItemAmount = packet.vItemList[i].nRemainItemAmount;
		pLShopItemData.nRemainSec = packet.vItemList[i].nRemainSec;
		pLShopItemData.nRemainServerItemAmount = packet.vItemList[0].nRemainServerItemAmount;
		j = 0;
		while((j < 5))
		{
			pLShopItemData.nCostItemId[j] = packet.vItemList[i].nCostItemId[j];
			j++;
		}
		j = 0;
		while((j < 5))
		{
			pLShopItemData.nCostItemAmount[j] = packet.vItemList[i].nCostItemAmount[j];
			j++;
		}
		pLShopItemDataList[pLShopItemDataList.Length] = pLShopItemData;
		i++;
	}
	if((packet.cPage < packet.cMaxPage))
	{
		return;
	}
	HandleItemNewList();
	return;
}

function HandleItemNewList()
{
	local int i;
	local RichListCtrlRowData Record;
	local PledgeShopProductUIData productData;
	local array<RichListCtrlRowData> RecordList;

	i = 0;
	while((i < pLShopItemDataList.Length))
	{
		API_GetLCoinShopProductData(pLShopItemDataList[i].nSlotNum, productData);
		Record = makeRecord(i);
		RecordList[RecordList.Length] = Record;
		i++;
	}
	i = 0;
	while((i < RecordList.Length))
	{
		API_GetLCoinShopProductData(pLShopItemDataList[int(RecordList[i].nReserved1)].nSlotNum, productData);
		ClanShop_RichListCtrl.InsertRecord(RecordList[i]);
		i++;
	}
	ClanShop_RichListCtrl.SetSelectedIndex(selectIndex, true);
	ClickRecord();
	return;
}

function API_GetLCoinShopProductData(int ProductID, out PledgeShopProductUIData productData)
{
	GetPledgeShopProductData(100, ProductID, productData);
	return;
}

function RichListCtrlRowData makeRecord(int Index)
{
	local RichListCtrlRowData Record;
	local string fullNameString, toolTipParam;
	local ItemInfo Info;
	local UserInfo PlayerInfo;
	local PLShopItemDataStruct ItemData;
	local PledgeShopProductUIData productData;
	local Color tmpTextColor;
	local bool bBreakLine, canBuy, lockPanel;
	local ClanWndClassicNew ClanWnd;

	ClanWnd = ClanWndClassicNew(GetScript("ClanWndClassicNew"));
	ItemData = pLShopItemDataList[Index];
	API_GetLCoinShopProductData(ItemData.nSlotNum, productData);
	canBuy = (GetItemLimitAmount(Index) > 0);
	GetPlayerInfo(PlayerInfo);
	Info = GetItemInfoByClassID(ItemData.nItemClassID);
	fullNameString = GetItemNameAll(Info);
	ItemInfoToParam(Info, toolTipParam);
	Record.szReserved = toolTipParam;
	Record.cellDataList.Length = 3;
	Record.nReserved1 = INT64(Index);
	Record.cellDataList[0].nReserved1 = ItemData.nItemClassID;
	if((productData.PledgeLevelMin > ClanWnd.m_clanLevel))
	{
		lockPanel = false;
		Record.nReserved2 = INT64(0);
	}
	else
	{
		lockPanel = true;
		Record.nReserved2 = INT64(1);
	}
	Record.cellDataList[2].nReserved3 = ItemData.nSlotNum;
	Record.cellDataList[0].szData = fullNameString;
	AddRichListCtrlItem(Record.cellDataList[0].drawitems, Info, 32, 32, 10, 6);
	if(!canBuy)
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, "L2UI_CT1.ItemWindow.ItemWindow_IconDisable", 32, 32, -32, 0);
	}
	if(!lockPanel)
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, "L2UI_CT1.Icon.ItemLock", 32, 32, -32, 0);
	}
	if(lockPanel)
	{
		tmpTextColor = GetColor(170, 153, 119, 255);
	}
	else
	{
		tmpTextColor = util.DarkGray;
	}
	AddRichListCtrlString(Record.cellDataList[0].drawitems, productData.ProductName, tmpTextColor, false, 5, 2);
	AddRichListCtrlString(Record.cellDataList[0].drawitems, (GetSystemString(3731) @ string(productData.PledgeLevelMin)), tmpTextColor, true, 47, 0);
	if(lockPanel)
	{
		tmpTextColor = GetColor(254, 215, 160, 255);
	}
	else
	{
		tmpTextColor = util.DarkGray;
	}
	if((productData.LevelMin != 1))
	{
		AddRichListCtrlString(Record.cellDataList[1].drawitems, (string(productData.LevelMin) @ GetSystemString(859)), tmpTextColor, false, 10, -2);
		bBreakLine = true;
	}
	if((productData.LevelMax != 999))
	{
		AddRichListCtrlString(Record.cellDataList[1].drawitems, (GetSystemString(13268) @ string(productData.LevelMax)), tmpTextColor, bBreakLine, 10, -2);
	}
	if(((productData.LevelMin == 1) && (productData.LevelMax == 999)))
	{
		AddRichListCtrlString(Record.cellDataList[1].drawitems, "-", tmpTextColor, false, 10, 0);
	}
	if((productData.LimitCountMax > 0))
	{
		if(lockPanel)
		{
			if(canBuy)
			{
				tmpTextColor = util.White;
			}
			else
			{
				tmpTextColor = util.ColorYellow;
			}
		}
		else
		{
			tmpTextColor = util.DarkGray;
		}
		AddRichListCtrlString(Record.cellDataList[2].drawitems, (((string(ItemData.nRemainItemAmount) $ "/") $ string(productData.LimitCountMax)) $ GetBuyTypeStringBuyRefresh(productData.ResetType)), tmpTextColor, false, 0, 0);
	}
	else
	{
		if(lockPanel)
		{
			tmpTextColor = GetColor(119, 255, 153, 255);
		}
		else
		{
			tmpTextColor = util.DarkGray;
		}
		AddRichListCtrlString(Record.cellDataList[2].drawitems, GetSystemString(866), tmpTextColor, false, 0, 0);
	}
	return Record;
}

function int GetCurrentSelectedIndex()
{
	return 0;
}

function bool GetStringIDFromBtnName(string btnName, string someString, out string strID)
{
	if(!CheckBtnName(btnName, someString))
	{
		return false;
	}
	strID = Mid(btnName, Len(someString));
	return true;
}

function bool CheckBtnName(string btnName, string someString)
{
	return (Left(btnName, Len(someString)) == someString);
}

function string GetItemTextureNameByClassID(int ClassID)
{
	local ItemID cID;

	cID.ClassID = ClassID;
	return Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(cID);
}

function INT64 GetAdenaNum(PLShopItemDataStruct ItemData)
{
	local int i;

	i = 0;
	while((i < 5))
	{
		if((ItemData.nCostItemId[i] == 57))
		{
			return ItemData.nCostItemAmount[i];
		}
		i++;
	}
	return INT64(-1);
}

function INT64 GetLcoinNum(PLShopItemDataStruct ItemData)
{
	local int i;

	i = 0;
	while((i < 5))
	{
		if((ItemData.nCostItemId[i] == 91663))
		{
			return ItemData.nCostItemAmount[i];
		}
		i++;
	}
	return INT64(-1);
}

function string GetBuyTypeStringBuyRefresh(UIEventManager.PLSHOP_RESET_TYPE Type)
{
	switch(Type)
	{
		case PLSHOP_RESET_ALWAYS:
			return (("(" $ GetSystemString(5142)) $ ")");
			break;
		case PLSHOP_RESET_ONEDAY:
			return ((("(" $ "1") $ GetSystemString(1109)) $ ")");
			break;
		case PLSHOP_RESET_ONEWEEK:
			return (("(" $ GetSystemString(13866)) $ ")");
			break;
		case PLSHOP_RESET_ONEMONTH:
			return (("(" $ GetSystemString(13867)) $ ")");
			break;
		default:
			break;
	}
	return "";
}

function showDisable(bool bShow)
{
	if(bShow)
	{
		GetWindowHandle((m_Windowname $ ".DisableWnd")).ShowWindow();
		GetEditBoxHandle((m_Windowname $ ".ClanShopItemInfoWnd.inputItemWnd.ItemCount_EditBox")).HideWindow();
	}
	else
	{
		GetWindowHandle((m_Windowname $ ".DisableWnd")).HideWindow();
		GetEditBoxHandle((m_Windowname $ ".ClanShopItemInfoWnd.inputItemWnd.ItemCount_EditBox")).ShowWindow();
	}
	return;
}

function HandleUserInfo()
{
	if(getInstanceUIData().IsLevelUP())
	{
		Me.HideWindow();
	}
	return;
}

function ItemInfo GetItemInfoByRecord(RichListCtrlRowData Record)
{
	return GetItemInfoByIndex(int(Record.nReserved1));
}

function ItemInfo GetItemInfoByIndex(int Index)
{
	return GetItemInfoByClassID(pLShopItemDataList[Index].nItemClassID);
}

function ItemInfo GetItemInfoCurrentSelected()
{
	return GetItemInfoByIndex(GetCurrentSelectedIndex());
}

function int GetSlotNumByRecord(RichListCtrlRowData Record)
{
	return Record.cellDataList[2].nReserved3;
}

function int GetCountCanBuyByIndex(int Index)
{
	local int Count;

	if(!CheckLevelCondition(Index))
	{
		return 0;
	}
	Count = pLShopItemDataList[Index].nRemainItemAmount;
	return Count;
}

function bool CheckLevelCondition(int Index)
{
	local UserInfo Info;
	local PLShopItemDataStruct ItemData;
	local PledgeShopProductUIData productData;

	ItemData = pLShopItemDataList[Index];
	API_GetLCoinShopProductData(ItemData.nSlotNum, productData);
	if(!GetPlayerInfo(Info))
	{
		return false;
	}
	if(((Info.nLevel > productData.LevelMax) || (Info.nLevel < productData.LevelMin)))
	{
		return false;
	}
	return true;
}

function int GetItemLimitAmount(int Index)
{
	local PledgeShopProductUIData productData;

	API_GetLCoinShopProductData(pLShopItemDataList[Index].nSlotNum, productData);
	return pLShopItemDataList[Index].nRemainItemAmount;
}

function int GetMinAmoutByCostItemNum(int Index)
{
	local int Count, i;
	local PLShopItemDataStruct ItemData;

	ItemData = pLShopItemDataList[Index];
	Count = 99999;
	i = 0;
	while((i < 5))
	{
		if((ItemData.nCostItemId[i] != 0))
		{
			Count = Min(Count, int((GetInventoryItemCount(GetItemID(ItemData.nCostItemId[i])) / ItemData.nCostItemAmount[i])));
		}
		i++;
	}
	return Count;
}

event OnClickListCtrlRecord(string ListCtrlID)
{
	switch(ListCtrlID)
	{
		case "ClanShop_RichListCtrl":
			RichListCtrl.DeleteAllItem();
			ClickRecord();
			break;
		default:
			break;
	}
	return;
}

function ClickRecord()
{
	local int i, Index;
	local ItemInfo Info, info2;
	local RichListCtrlRowData rowData;
	local PLShopItemDataStruct ItemData;
	local INT64 haveItem;

	Class'NWindow.UIAPI_MULTISELLITEMINFO'.static.Clear("ClanShopWndClassic.multiSellItemInfo");
	Index = ClanShop_RichListCtrl.GetSelectedIndex();
	ClanShop_RichListCtrl.GetRec(Index, rowData);
	ItemData = pLShopItemDataList[int(rowData.nReserved1)];
	Info = GetItemInfoByClassID(ItemData.nItemClassID);
	selectnSlotNum = ItemData.nSlotNum;
	selectIndex = Index;
	Class'NWindow.UIAPI_MULTISELLITEMINFO'.static.SetItemInfo("ClanShopWndClassic.multiSellItemInfo", 0, Info);
	needItemScript.StartNeedItemList(3);
	i = 0;
	while((i < 5))
	{
		if((ItemData.nCostItemId[i] != 0))
		{
			if((ItemData.nCostItemId[i] == -700))
			{
				needItemScript.AddNeedPoint(GetSystemString(13696), "icon.etc_i.pledge_coin_dummy", ItemData.nCostItemAmount[0], INT64(nPledgeCoin));
				i++;
				continue;
			}
			if((ItemData.nCostItemId[i] == 57))
			{
				haveItem = GetInventoryItemCount(GetItemID(57));
				info2 = GetItemInfoByClassID(57);
				needItemScript.AddNeedPoint(info2.Name, info2.IconName, ItemData.nCostItemAmount[0], haveItem);
				i++;
				continue;
			}
			if((ItemData.nCostItemId[i] == 91663))
			{
				haveItem = GetInventoryItemCount(GetItemID(91663));
				info2 = GetItemInfoByClassID(91663);
				needItemScript.AddNeedPoint(info2.Name, info2.IconName, ItemData.nCostItemAmount[0], haveItem);
			}
		}
		i++;
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

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "Refresh_Button":
			OnRefresh_ButtonClick();
			break;
		case "Close_Button":
			OnClose_ButtonClick();
			break;
		case "HelpWnd_Btn":
			ExecuteEvent(1210, "68");
			break;
		case "Buy_Button":
			OnBuy_ButtonClick();
			break;
		default:
			break;
	}
	return;
}

function OnRefresh_ButtonClick()
{
	API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST();
	Me.SetTimer(99902, 3000);
	Refresh_Button.DisableWindow();
	return;
}

function OnTimer(int TimerID)
{
	if((TimerID == 99902))
	{
		Refresh_Button.EnableWindow();
		Me.KillTimer(99902);
	}
	return;
}

function OnClose_ButtonClick()
{
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

function OnClear_ButtonClick()
{
	return;
}

function OnMultiSell_Up_ButtonClick()
{
	return;
}

function OnMultiSell_Down_ButtonClick()
{
	return;
}

function OnMultiSell_Input_ButtonClick()
{
	return;
}

function OnBuy_ButtonClick()
{
	local PLShopItemDataStruct ItemData;
	local ItemInfo Info;
	local PledgeShopProductUIData productData;

	ItemData = pLShopItemDataList[selectIndex];
	Info = GetItemInfoByClassID(ItemData.nItemClassID);
	API_GetLCoinShopProductData(ItemData.nSlotNum, productData);
	popupExpandScript.SetDialogDesc(MakeFullSystemMsg(GetSystemMessage(13404), GetItemNameAll(Info)));
	popupExpandScript.SetBuyItemClassID(ItemData.nItemClassID, productData.BuyItems[0].Count);
	popupExpandScript.SetItemNum(int(inputItemScript.GetCount()));
	popupExpandScript.OKButton.EnableWindow();
	popupExpandScript.Show();
	showDisable(true);
	return;
}

function OnESCKey()
{
	ClanShop_RichListCtrl.SetFocus();
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
	m_Windowname="ClanShopWndClassic"
}
