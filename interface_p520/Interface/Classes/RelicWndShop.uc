class RelicWndShop extends UICommonAPI
	dependson(UIPacket);

const MAXTRYNUM = 100;

var WindowHandle RelicBuyWnd;
var RichListCtrlHandle ShopList_ListCtrl;
var UIControlNumberInput BuyNumWndScript;
var UIControlNeedItemSelectMultiItems multiNeedItemsScr;
var L2UITimerObject tObject;
var L2UITimerObject tObjectRefresh;
var ItemWindowHandle BuyItemWindow;
var TextBoxHandle BuyItemName_txt;
var ButtonHandle Buy_Btn;
var bool bRQ_C_EX_RELICS_SUMMON_LIST;
var bool _isShowTabReddot;
var array<UIPacket._RelicsSummonInfo> _relicsSummonInfos;

function InitHandles()
{
	BuyItemWindow = GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RelicBuyWnd.RelicBuyPopup.BuyItemWindow"));
	BuyItemName_txt = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RelicBuyWnd.RelicBuyPopup.BuyItemName_txt"));
	Buy_Btn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RelicBuyWnd.Buy_Btn"));
	return;
}

function InitNeedItemSelectMultiItemsPopup()
{
	local WindowHandle wnd;

	wnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RelicBuyWnd.NeedItemMultiItems"));
	multiNeedItemsScr = Class'Interface.UIControlNeedItemSelectMultiItems'.static._InitScript(wnd);
	multiNeedItemsScr._ConnectPopup(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".NeedItem_wnd.UIControlNeedItemSelectMultiItemPopup")));
	multiNeedItemsScr.DelegateSelectedItemOnClick = MultiItemSelected;
	return;
}

function InitUIControlNumberInputSteper()
{
	BuyNumWndScript = Class'Interface.UIControlNumberInput'.static.InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RelicBuyWnd.RelicBuyPopup.BuyNumWnd")));
	BuyNumWndScript.DelegateESCKey = OnReceivedCloseUI;
	BuyNumWndScript.delegateOnItemCountEdited = HandleDelegateOnChangeEditBox;
	BuyNumWndScript._SetUseCaculator(true);
	BuyNumWndScript.DelegateGetCountCanBuy = GetCanLcoinPriceItemNum;
	BuyNumWndScript.DelegateOnClickInput = HandleOnItemCountEditBtonClicked;
	return;
}

function MultiItemSelected(int selectNeedItemIndex, int selectedClassID, INT64 selectedAmount)
{
	BuyNumWndScript.SetCount(INT64(1));
	SetBuy_Btn();
	Debug(((("MultiItemSelected" @ string(selectNeedItemIndex)) @ string(selectedClassID)) @ string(selectedAmount)));
	return;
}

function HandleOnItemCountEditBtonClicked()
{
	local int maxNum;

	DialogShow(DialogModalType_Modal, DialogType_NumberPad, GetSystemMessage(4142));
	maxNum = Min(100, int(multiNeedItemsScr._GetMaxNumCanBuy()));
	DialogSetInputlimit(INT64(maxNum));
	DialogSetParamInt64(INT64(maxNum));
	Class'Interface.DialogBox'.static.Inst().AnchorToOwner();
	Class'Interface.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOkEdit;
	return;
}

function HandleDialogOkEdit()
{
	local INT64 ItemNum;

	ItemNum = MAX64(INT64(0), INT64(DialogGetString()));
	if((ItemNum == INT64(0)))
	{
		return;
	}
	BuyNumWndScript.SetCount(ItemNum);
	return;
}

function INT64 GetCanLcoinPriceItemNum()
{
	return INT64(Min(100, int(multiNeedItemsScr._GetMaxNumCanBuy())));
}

function HandleDelegateOnChangeEditBox(INT64 changedNum)
{
	SetBuy_Btn();
	Debug(("HandleDelegateOnChangeEditBox" @ string(changedNum)));
	return;
}

function SetRowDatas(array<UIPacket._RelicsSummonInfo> relicsSummonInfos)
{
	local int i, j, Count;
	local array<RelicsSummonCategory> o_Datas;
	local RelicsPlayUIData relicPlayData;
	local int currentCategory;

	currentCategory = -1;
	_isShowTabReddot = false;
	ShopList_ListCtrl.DeleteAllItem();
	API_GetRelicsSummonCategoryList(o_Datas);
	i = 0;
	while((i < o_Datas.Length))
	{
		currentCategory = o_Datas[i].Index;
		ShopList_ListCtrl.InsertRecord(MakeRowDataCategory(o_Datas[i]));
		Count = ShopList_ListCtrl.GetRecordCount();
		j = 0;
		while((j < relicsSummonInfos.Length))
		{
			API_GetRelicsPlayData(ERPDT_Summon, relicsSummonInfos[j].nSummonID, relicPlayData);
			if((currentCategory == relicPlayData.SummonCategory))
			{
				ShopList_ListCtrl.InsertRecord(MakeRowData(relicPlayData, relicsSummonInfos[j]));
				relicsSummonInfos.Remove(j, 1);
			}
			else
			{
				j++;
			}
		}
		if((Count == ShopList_ListCtrl.GetRecordCount()))
		{
			ShopList_ListCtrl.DeleteRecord((Count - 1));
		}
		i++;
	}
	Class'Interface.RelicWnd'.static.Inst().SetShopReddot(_isShowTabReddot);
	return;
}

function RichListCtrlRowData MakeRowDataCategory(RelicsSummonCategory relicData)
{
	local RichListCtrlRowData rowData;

	rowData.cellDataList.Length = 1;
	rowData.nReserved1 = INT64(-1);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, GetNpcString(relicData.NPCStringID), getInstanceL2Util().White, false, 37, 1, "hs11");
	rowData.sOverlayTex = relicData.TextureName;
	return rowData;
}

function RichListCtrlRowData MakeRowData(RelicsPlayUIData relicPlayData, UIPacket._RelicsSummonInfo relicsSummonInfo)
{
	local RichListCtrlRowData rowData;
	local ItemInfo iInfo;
	local bool isShowReddot;

	iInfo = GetItemInfoByClassID(relicPlayData.SummonItem);
	rowData.cellDataList.Length = 3;
	rowData.nReserved1 = INT64(relicsSummonInfo.nSummonID);
	rowData.cellDataList[0].nReserved1 = relicPlayData.SummonItem;
	rowData.cellDataList[0].szData = GetItemNameAll(iInfo);
	AddRichListCtrlItem(rowData.cellDataList[0].drawitems, iInfo, 0, 0, 12);
	isShowReddot = IsAvailableCostItem(relicPlayData.CostItems);
	Debug(("RelicWndShop" @ string(isShowReddot)));
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, iInfo.Name, GetColor(170, 153, 119, 255), false, 5, 9);
	if((int(relicPlayData.MarkType) != 0))
	{
		AddRichListCtrlNewLine(rowData.cellDataList[0].drawitems, 0, -32);
		addRichListCtrlTexture(rowData.cellDataList[0].drawitems, GetMarkIconByType(LCoinShopMark_Event), 40, 40, 1, -1, 40, 40);
	}
	if((relicsSummonInfo.nRemainTime == -1))
	{
		AddRichListCtrlString(rowData.cellDataList[1].drawitems, "-", getInstanceL2Util().White, false, 0, -1);
	}
	else
	{
		addRichListCtrlTexture(rowData.cellDataList[1].drawitems, "L2UI_ct1.DailyMissionWnd.DailyMissionWnd_IconTime", 11, 12, 0, 2);
		AddRichListCtrlString(rowData.cellDataList[1].drawitems, getInstanceL2Util().getTimeStringBySec3(relicsSummonInfo.nRemainTime), getInstanceL2Util().White, false, 0, -1);
	}
	if(isShowReddot)
	{
		_isShowTabReddot = true;
		AddRichListCtrlButton(rowData.cellDataList[2].drawitems, ("btnBuy_" $ string(relicsSummonInfo.nSummonID)), 0, -1, "L2UI_NewTex.RelicWnd.RelicShopDotBtn_N", "L2UI_NewTex.RelicWnd.RelicShopDotBtn_D", "L2UI_NewTex.RelicWnd.RelicShopDotBtn_O", 108, 30, 108, 30);
	}
	else
	{
		AddRichListCtrlButton(rowData.cellDataList[2].drawitems, ("btnBuy_" $ string(relicsSummonInfo.nSummonID)), 0, -1, "L2UI_NewTex.RelicWnd.RelicShopBtn_N", "L2UI_NewTex.RelicWnd.RelicShopBtn_D", "L2UI_NewTex.RelicWnd.RelicShopBtn_O", 108, 30, 108, 30);
	}
	return rowData;
}

function bool IsAvailableCostItem(array<L2ItemAmount> CostItems)
{
	local L2ItemAmount itemAmountInfo;
	local int i;

	i = 0;
	while((i < CostItems.Length))
	{
		itemAmountInfo = CostItems[i];
		if((itemAmountInfo.ItemClassID != 48472))
		{
			if((GetInventoryItemCount(GetItemID(itemAmountInfo.ItemClassID)) > INT64(0)))
			{
				return true;
			}
		}
		i++;
	}
	return false;
}

function UpdateShopList()
{
	SetRowDatas(_relicsSummonInfos);
	return;
}

function HandleRelicShopProb_Btn()
{
	local RichListCtrlRowData rowData;

	if((ShopList_ListCtrl.GetSelectedIndex() == 0))
	{
		return;
	}
	ShopList_ListCtrl.GetRec(ShopList_ListCtrl.GetSelectedIndex(), rowData);
	Class'Interface.RelicShopProbWnd'.static.Inst().ShowShopProbWnd(int(rowData.nReserved1));
	return;
}

function HandleOnClickBtnBuy(string btnName)
{
	if((InStr(btnName, "btnBuy_") == -1))
	{
		return;
	}
	HandlePopup();
	return;
}

function SetBuy_Btn()
{
	if(multiNeedItemsScr._GetCanBuy())
	{
		Buy_Btn.EnableWindow();
	}
	else
	{
		Buy_Btn.DisableWindow();
	}
	return;
}

function InitFees(array<L2ItemAmount> CostItems)
{
	local int i;

	multiNeedItemsScr._StartSelectItems(CostItems.Length);
	i = 0;
	while((i < CostItems.Length))
	{
		multiNeedItemsScr._AddSelectItemClassID(CostItems[i].ItemClassID, INT64(CostItems[i].ItemAmount));
		i++;
	}
	multiNeedItemsScr._SetSelectByIndex(0);
	multiNeedItemsScr._EndSelectItems();
	return;
}

function SetPopupInfo(int ClassID)
{
	local ItemInfo iInfo;

	iInfo = GetItemInfoByClassID(ClassID);
	BuyItemWindow.Clear();
	BuyItemWindow.AddItem(iInfo);
	BuyItemName_txt.SetText(GetItemNameAll(iInfo));
	return;
}

function HandlePopup()
{
	local RichListCtrlRowData rowData;

	ShopList_ListCtrl.GetRec(ShopList_ListCtrl.GetSelectedIndex(), rowData);
	if((rowData.nReserved1 == INT64(-1)))
	{
		return;
	}
	ShowPopup(int(rowData.nReserved1));
	SetPopupInfo(rowData.cellDataList[0].nReserved1);
	BuyNumWndScript.SetCount(INT64(1));
	SetBuy_Btn();
	return;
}

function ShowPopup(int SummonID)
{
	local RelicsPlayUIData relicPlayData;

	API_GetRelicsPlayData(ERPDT_Summon, SummonID, relicPlayData);
	InitFees(relicPlayData.CostItems);
	RelicBuyWnd.ShowWindow();
	return;
}

function HandleOnClickRefreshBtn()
{
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RelicBuyWnd.RefreshBtn")).DisableWindow();
	RQ_C_EX_RELICS_SUMMON_LIST();
	if((tObjectRefresh._timerID == 0))
	{
		tObjectRefresh = Class'Interface.L2UITimer'.static.Inst()._AddTimerOnce(1000);
		tObjectRefresh._DelegateOnEnd = DelegateOnEndRefreshBtnEnable;
	}
	return;
}

function DelegateOnEndRefreshBtnEnable()
{
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RelicBuyWnd.RefreshBtn")).EnableWindow();
	return;
}

function HandleOnCLickBuyBtn()
{
	local RichListCtrlRowData rowData;

	if((ShopList_ListCtrl.GetSelectedIndex() == 0))
	{
		return;
	}
	ShopList_ListCtrl.GetRec(ShopList_ListCtrl.GetSelectedIndex(), rowData);
	RelicBuyWnd.HideWindow();
	RelicSummonWnd(GetScript("RelicSummonWnd")).External_AskSummonID(BuyItemName_txt.GetText(), int(rowData.nReserved1), int(BuyNumWndScript.GetCount()), multiNeedItemsScr._GetMyClassID(), multiNeedItemsScr._GetMyAmount());
	return;
}

function string GetMarkIconByType(UIEventManager.ELCoinShopMarkType MarkType)
{
	switch(MarkType)
	{
		case LCoinShopMark_None:
			return "";
			break;
		case LCoinShopMark_Event:
			return "L2UI_CT1.ShopWnd.ShopDailyLcoinWnd_EventIcon_02";
			break;
		case LCoinShopMark_Sale:
			return "L2UI_CT1.ShopWnd.ShopDailyLcoinWnd_SaleIcon_02";
			break;
		case LCoinShopMark_Best:
			return "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_BestIcon";
			break;
		case LCoinShopMark_Limited:
			return "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_LimitedIcon";
			break;
		case LCoinShopMark_New:
			return "L2UI_EPIC.LCoinShopICON_ribbonNEW";
			break;
		default:
			return "L2UI_EPIC.LCoinShopWnd.RelayIcon";
			break;
	}
	return "";
}

function API_GetRelicsSummonCategoryList(out array<RelicsSummonCategory> o_Datas)
{
	GetRelicsSummonCategoryList(o_Datas);
	return;
}

function API_GetRelicsPlayData(UIEventManager.ERelicsPlayDataType a_Type, int a_grade, out RelicsPlayUIData o_data)
{
	GetRelicsPlayData(a_Type, a_grade, o_data);
	return;
}

function RQ_C_EX_RELICS_SUMMON_LIST()
{
	local array<byte> stream;
	local UIPacket._C_EX_RELICS_SUMMON_LIST packet;

	if(bRQ_C_EX_RELICS_SUMMON_LIST)
	{
		return;
	}
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_RELICS_SUMMON_LIST(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(903, stream);
	if((tObject._timerID == 0))
	{
		tObject = Class'Interface.L2UITimer'.static.Inst()._AddTimerOnce(5000);
		tObject._DelegateOnEnd = DelegateOnEndC_EX_RELICS_SUMMON_LIST;
	}
	bRQ_C_EX_RELICS_SUMMON_LIST = true;
	return;
}

function DelegateOnEndC_EX_RELICS_SUMMON_LIST()
{
	bRQ_C_EX_RELICS_SUMMON_LIST = false;
	return;
}

function RT_S_EX_RELICS_SUMMON_LIST()
{
	local UIPacket._S_EX_RELICS_SUMMON_LIST packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_RELICS_SUMMON_LIST(packet))
	{
		return;
	}
	bRQ_C_EX_RELICS_SUMMON_LIST = false;
	_relicsSummonInfos = packet.infos;
	SetRowDatas(packet.infos);
	return;
}

event OnDBClickListCtrlRecord(string ListCtrlID)
{
	switch(ListCtrlID)
	{
		case "ShopList_ListCtrl":
			HandlePopup();
			break;
		default:
			break;
	}
	return;
}

event OnRClickListCtrlRecord(string ListCtrlID)
{
	switch(ListCtrlID)
	{
		case "ShopList_ListCtrl":
			HandlePopup();
			break;
		default:
			break;
	}
	return;
}

event OnClickButton(string btnName)
{
	switch(btnName)
	{
		case "RelicShopProb_Btn":
			HandleRelicShopProb_Btn();
			break;
		case "Buy_Btn":
			HandleOnCLickBuyBtn();
			break;
		case "Close_Btn":
			RelicBuyWnd.HideWindow();
			break;
		case "RefreshBtn":
			HandleOnClickRefreshBtn();
			break;
		default:
			HandleOnClickBtnBuy(btnName);
			break;
	}
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(1181));
	return;
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case EV_PacketID(1181):
			RT_S_EX_RELICS_SUMMON_LIST();
			break;
		default:
			break;
	}
	return;
}

event OnLoad()
{
	ShopList_ListCtrl = GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ShopList_ListCtrl"));
	ShopList_ListCtrl.SetSelectedSelTooltip(false);
	ShopList_ListCtrl.SetAppearTooltipAtMouseX(true);
	ShopList_ListCtrl.SetUseStripeBackTexture(false);
	RelicBuyWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RelicBuyWnd"));
	InitHandles();
	InitUIControlNumberInputSteper();
	InitNeedItemSelectMultiItemsPopup();
	return;
}

event OnShow()
{
	RelicBuyWnd.HideWindow();
	return;
}
