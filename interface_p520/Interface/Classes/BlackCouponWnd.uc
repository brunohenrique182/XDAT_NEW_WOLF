class BlackCouponWnd extends UICommonAPI
	dependson(UIPacket);

var WindowHandle Me;
var WindowHandle ResultDialog_Wnd;
var ItemWindowHandle Result_ItemWnd;
var TextBoxHandle ItemName_Txt;
var TextBoxHandle Discription_Txt;
var ButtonHandle Ok_Btn;
var EffectViewportWndHandle EffectViewport02;
var WindowHandle ItemRecovery_Wnd;
var WindowHandle List_Wnd;
var WindowHandle Exchange_Wnd;
var WindowHandle ListDisable_Wnd;
var RichListCtrlHandle ExchangeItem_RichList;
var RichListCtrlHandle RecoveryRichList;
var WindowHandle Bottom_Wnd;
var TextBoxHandle Title_Txt;
var ButtonHandle Recovery_Btn;
var ButtonHandle Exchange_Btn;
var int nCurrentBrokenItemClassId;
var int nCurrentBrokenEnchantNum;
var int nCurrentFixedItemClassId;
var int currentRecoverTabNum;
var array<UIConstants.MultiSellInfo> m_MultiSellInfoList;
var int m_MultiSellGroupID;
var int m_nCurrentMultiSellInfoIndex;
var string m_Windowname;
var int nShowType;
var array<int> lastSelectedListArray;
var UIControlGroupButtonAssets TopGroupButtonAsset;
var UIControlGroupButtonAssets SubGroupButtonAsset;
var UIControlNeedItemList needItemScript;
var RecoveryCouponData CouponData;
var int currentCouponClassID;
//var delegate<SortListDelegate> __SortListDelegate__Delegate;

function updateNeedItem()
{
	return;
}

function OnRegisterEvent()
{
	RegisterEvent((100000 + 947));
	RegisterEvent((100000 + 948));
	RegisterEvent((100000 + 1064));
	RegisterEvent(2530);
	RegisterEvent(2535);
	RegisterEvent(2540);
	RegisterEvent(2550);
	RegisterEvent(2560);
	RegisterEvent(2565);
	RegisterEvent(9750);
	RegisterEvent(9570);
	return;
}

function Initialize()
{
	Me = GetWindowHandle(m_Windowname);
	ResultDialog_Wnd = GetWindowHandle((m_Windowname $ ".ResultDialog_Wnd"));
	Result_ItemWnd = GetItemWindowHandle((m_Windowname $ ".ResultDialog_Wnd.Result_ItemWnd"));
	ItemName_Txt = GetTextBoxHandle((m_Windowname $ ".ResultDialog_Wnd.ItemName_Txt"));
	Discription_Txt = GetTextBoxHandle((m_Windowname $ ".ResultDialog_Wnd.Discription_Txt"));
	Ok_Btn = GetButtonHandle((m_Windowname $ ".ResultDialog_Wnd.Ok_Btn"));
	EffectViewport02 = GetEffectViewportWndHandle((m_Windowname $ ".ResultDialog_Wnd.EffectViewport02"));
	ItemRecovery_Wnd = GetWindowHandle((m_Windowname $ ".ItemRecovery_Wnd"));
	List_Wnd = GetWindowHandle((m_Windowname $ ".ItemRecovery_Wnd.List_Wnd"));
	ListDisable_Wnd = GetWindowHandle((m_Windowname $ ".ItemRecovery_Wnd.ListDisable_Wnd"));
	RecoveryRichList = GetRichListCtrlHandle((m_Windowname $ ".List_Wnd.Item_RichList"));
	Exchange_Wnd = GetWindowHandle((m_Windowname $ ".Exchange_Wnd"));
	ExchangeItem_RichList = GetRichListCtrlHandle((m_Windowname $ ".ExchangeList_Wnd.ExchangeRichList"));
	Bottom_Wnd = GetWindowHandle((m_Windowname $ ".Bottom_Wnd"));
	Title_Txt = GetTextBoxHandle((m_Windowname $ ".Bottom_Wnd.Title_Txt"));
	Recovery_Btn = GetButtonHandle((m_Windowname $ ".Bottom_Wnd.Recovery_Btn"));
	Exchange_Btn = GetButtonHandle((m_Windowname $ ".Bottom_Wnd.Exchange_Btn"));
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	initGroupButton();
	InitNeedItem();
	SetPopupScript();
	GetRichListCtrlHandle((m_Windowname $ ".List_Wnd.Item_RichList")).SetSelectedSelTooltip(false);
	GetRichListCtrlHandle((m_Windowname $ ".List_Wnd.Item_RichList")).SetAppearTooltipAtMouseX(true);
	ExchangeItem_RichList.SetSelectedSelTooltip(false);
	ExchangeItem_RichList.SetAppearTooltipAtMouseX(true);
	return;
}

function initGroupButton()
{
	TopGroupButtonAsset = Class'Interface.UIControlGroupButtonAssets'.static._InitScript(GetMeWindow("TopGroupButtonAsset"));
	TopGroupButtonAsset._SetStartInfo("L2UI_NewTex.tab.BigBrown_Tab_One_Unselected", "L2UI_NewTex.tab.BigBrown_Tab_One_Selected", "L2UI_NewTex.tab.BigBrown_Tab_One_Unselected_Over", true);
	TopGroupButtonAsset._GetGroupButtonsInstance().DelegateOnClickButton = DelegateOnClickButtonTopTab;
	SubGroupButtonAsset = Class'Interface.UIControlGroupButtonAssets'.static._InitScript(GetMeWindow("ItemRecovery_Wnd.SubGroupButtonAsset"));
	SubGroupButtonAsset._SetStartInfo("L2UI_ct1.RankingWnd.RankingWnd_SubTabButton", "L2UI_ct1.RankingWnd.RankingWnd_SubTabButton_Down", "L2UI_ct1.RankingWnd.RankingWnd_SubTabButton_Over", true);
	SubGroupButtonAsset._GetGroupButtonsInstance().DelegateOnClickButton = DelegateOnClickButtonSubTab;
	return;
}

function setTopGroupButtonCategory()
{
	local int tabNum;

	if((SubGroupButtonAsset._GetGroupButtonsInstance()._getShowButtonNum() > 0))
	{
		if((CouponData.DefaultMultisellId > 0))
		{
			tabNum = 2;
		}
		else
		{
			tabNum = 1;
		}
	}
	else
	{
		tabNum = 1;
	}
	if((tabNum == 2))
	{
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(0, GetSystemString(13668));
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(0, 0);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(1, GetSystemString(13669));
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(1, 1);
	}
	else
	{
		if((CouponData.DefaultMultisellId > 0))
		{
			TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(0, GetSystemString(14231));
		}
		else
		{
			TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(0, GetSystemString(13668));
		}
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(0, 0);
	}
	TopGroupButtonAsset._GetGroupButtonsInstance()._setShowButtonNum(tabNum);
	if((TopGroupButtonAsset._GetGroupButtonsInstance()._getShowButtonNum() == 1))
	{
		TopGroupButtonAsset._GetGroupButtonsInstance()._fixedWidth(598, 0);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonTexture(0, "L2UI_NewTex.tab.BigBrown_Tab_One_Unselected", "L2UI_NewTex.tab.BigBrown_Tab_One_Selected", "L2UI_NewTex.tab.BigBrown_Tab_One_Unselected_Over");
	}
	else
	{
		TopGroupButtonAsset._GetGroupButtonsInstance()._fixedWidth(299, 0);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonTexture(0, "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Left_Unselected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Left_Selected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Left_Unselected_Over");
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonTexture(1, "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Right_Unselected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Right_Selected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Right_Unselected_Over");
	}
	TopGroupButtonAsset._GetGroupButtonsInstance()._setTopOrder(0);
	return;
}

function setSubGroupButtonCategory()
{
	local int i;

	i = 0;
	while((i < CouponData.Categories.Length))
	{
		SubGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(i, GetSystemString(CouponData.Categories[i].SysStringId));
		SubGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(i, CouponData.Categories[i].Category);
		i++;
	}
	if((CouponData.Categories.Length == 0))
	{
		SubGroupButtonAsset._GetGroupButtonsInstance()._HideAllButtons();
	}
	else
	{
		SubGroupButtonAsset._GetGroupButtonsInstance()._setShowButtonNum(CouponData.Categories.Length);
	}
	if((SubGroupButtonAsset._GetGroupButtonsInstance()._getShowButtonNum() > 0))
	{
		SubGroupButtonAsset._GetGroupButtonsInstance()._fixedWidth(110, 5);
		SubGroupButtonAsset._GetGroupButtonsInstance()._setTopOrder(0);
	}
	return;
}

function DelegateOnClickButtonTopTab(string parentWndName, string strName, int Index)
{
	Debug("-----메인 탭-------");  // EN?: -----Main Tab-------
	Debug(("strName" @ parentWndName));
	Debug(("strName" @ strName));
	Debug(("index" @ string(Index)));
	if((TopGroupButtonAsset._GetGroupButtonsInstance()._getShowButtonNum() == 1))
	{
		if((Index == 0))
		{
			if((CouponData.DefaultMultisellId > 0))
			{
				GotoState('ExchangeState');
			}
			else
			{
				GotoState('ItemRecoveryState');
			}
		}
	}
	else if((Index == 0))
	{
		GotoState('ItemRecoveryState');
	}
	else
	{
		GotoState('ExchangeState');
	}
	return;
}

function DelegateOnClickButtonSubTab(string parentWndName, string strName, int Index)
{
	Debug("-----서브 탭-------");  // EN?: -----Sub Tab-------
	Debug(("strName" @ parentWndName));
	Debug(("strName" @ strName));
	Debug(("index" @ string(Index)));
	currentRecoverTabNum = Index;
	API_C_EX_ITEM_RESTORE_LIST(SubGroupButtonAsset._GetGroupButtonsInstance()._getButtonValue(Index));
	return;
}

function ClearMultiSellAll()
{
	m_nCurrentMultiSellInfoIndex = 0;
	m_MultiSellInfoList.Length = 0;
	m_MultiSellGroupID = 0;
	return;
}

function setUpdateSystemString()
{
	setWindowTitleBySysStringNum(CouponData.TitleSysstringId);
	Recovery_Btn.SetTooltipCustomType(recoverCustomTooltip());
	return;
}

event OnShow()
{
	showProcess();
	return;
}

function showProcess()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	GetRecoveryCouponData(currentCouponClassID, CouponData);
	setSubGroupButtonCategory();
	setTopGroupButtonCategory();
	setUpdateSystemString();
	lastSelectedListArray[0] = 0;
	lastSelectedListArray[1] = 0;
	lastSelectedListArray[2] = 0;
	lastSelectedListArray[3] = 0;
	lastSelectedListArray[4] = 0;
	ExchangeItem_RichList.DeleteAllItem();
	ListDisable_Wnd.HideWindow();
	showDisable(false);
	GetPopupExpandScript().Hide();
	ResultDialog_Wnd.HideWindow();
	if((TopGroupButtonAsset._GetGroupButtonsInstance()._getShowButtonNum() == 1))
	{
		GotoState('None');
		if((CouponData.DefaultMultisellId > 0))
		{
			GotoState('ExchangeState');
		}
		else
		{
			GotoState('ItemRecoveryState');
		}
	}
	else
	{
		GotoState('None');
		GotoState('ItemRecoveryState');
	}
	return;
}

event OnHide()
{
	EffectViewport02.SpawnEffect("");
	RecoveryRichList.DeleteAllItem();
	needItemScript.CleariObjects();
	return;
}

function addRichList_ItemRecovery(RichListCtrlHandle richList, int ItemClassID, int fixedItemClassID, int EnchantedNum)
{
	local RichListCtrlRowData rowData;
	local ItemInfo Info;
	local string gradeString, enchantedString;

	rowData.cellDataList.Length = 3;
	Info = GetItemInfoByClassID(fixedItemClassID);
	Info.Enchanted = EnchantedNum;
	ItemInfoToParam(Info, rowData.szReserved);
	gradeString = getInstanceL2Util().getItemGradeSystemString(Info.CrystalType);
	if((Info.Enchanted > 0))
	{
		enchantedString = ("+" $ string(Info.Enchanted));
	}
	else
	{
		enchantedString = "-";
	}
	AddRichListCtrlItem(rowData.cellDataList[0].drawitems, Info, 42, 42, 4, 0);
	rowData.cellDataList[0].szData = GetItemNameAll(Info);
	rowData.cellDataList[0].HiddenStringForSorting = rowData.cellDataList[0].szData;
	rowData.cellDataList[0].nReserved1 = ItemClassID;
	rowData.cellDataList[0].nReserved2 = EnchantedNum;
	rowData.cellDataList[0].nReserved3 = fixedItemClassID;
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, GetItemNameAll(Info), GTColor().White, false, 4, 12);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, gradeString, GTColor().ColorGold, false, 0, 0);
	rowData.cellDataList[1].HiddenStringForSorting = gradeString;
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, enchantedString, GTColor().WhiteSmoke, false, 0, 0);
	rowData.cellDataList[2].HiddenStringForSorting = enchantedString;
	richList.InsertRecord(rowData);
	return;
}

function addRichList_Exchange(RichListCtrlHandle richList, int ItemClassID, INT64 ItemNum, int multiSellindex)
{
	local RichListCtrlRowData rowData;
	local ItemInfo Info;

	rowData.cellDataList.Length = 2;
	Info = GetItemInfoByClassID(ItemClassID);
	Info.ItemNum = ItemNum;
	ItemInfoToParam(Info, rowData.szReserved);
	AddRichListCtrlItem(rowData.cellDataList[0].drawitems, Info, 42, 42, 4, 0);
	rowData.nReserved1 = INT64(multiSellindex);
	rowData.cellDataList[0].szData = Info.Name;
	rowData.cellDataList[0].HiddenStringForSorting = rowData.cellDataList[0].szData;
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, Info.Name, GTColor().White, false, 4, 12);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, MakeCostString(string(ItemNum)), GTColor().ColorGold, false, 0, 0);
	rowData.cellDataList[1].HiddenStringForSorting = MakeCostString(string(ItemNum));
	richList.InsertRecord(rowData);
	return;
}

function CustomTooltip recoverCustomTooltip()
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText(("- " $ GetSystemString(13673)), getInstanceL2Util().BrightWhite, "", true, true);
	if(getInstanceUIData().GetIsClassicServer())
	{
		drawListArr[drawListArr.Length] = addDrawItemText(("- " $ GetSystemString(13675)), getInstanceL2Util().BrightWhite, "", true, true);
	}
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 50;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "Ok_Btn":
			OnOk_BtnClick();
			break;
		case "Recovery_Btn":
			OnRecovery_BtnClick();
			break;
		case "Exchange_Btn":
			OnExchange_BtnClick();
			break;
		default:
			break;
	}
	return;
}

function OnOk_BtnClick()
{
	if(IsInState('ItemRecoveryState'))
	{
		ResultDialog_Wnd.HideWindow();
		API_C_EX_ITEM_RESTORE_LIST(SubGroupButtonAsset._GetGroupButtonsInstance()._getSelectedButtonValue());
	}
	showDisable(false);
	return;
}

function OnRecovery_BtnClick()
{
	local RichListCtrlRowData rowData;

	if((RecoveryRichList.GetSelectedIndex() > -1))
	{
		RecoveryRichList.GetSelectedRec(rowData);
		nCurrentBrokenItemClassId = rowData.cellDataList[0].nReserved1;
		nCurrentBrokenEnchantNum = rowData.cellDataList[0].nReserved2;
		nCurrentFixedItemClassId = rowData.cellDataList[0].nReserved3;
		ShowPopup(GetSystemMessage(13394), (("<" $ rowData.cellDataList[0].szData) $ ">"));
	}
	else
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(3443));
	}
	return;
}

function OnExchange_BtnClick()
{
	local RichListCtrlRowData rowData;

	if((ExchangeItem_RichList.GetSelectedIndex() > -1))
	{
		ExchangeItem_RichList.GetSelectedRec(rowData);
		ShowPopup(GetSystemMessage(13395), (("<" $ rowData.cellDataList[0].szData) $ ">"));
	}
	else
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(3443));
	}
	return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
	if((ListCtrlID == "Item_RichList"))
	{
		if((RecoveryRichList.GetSelectedIndex() > -1))
		{
			lastSelectedListArray[currentRecoverTabNum] = RecoveryRichList.GetSelectedIndex();
			updateNeedItem();
			DelegateNeedItemOnUpdateItem();
		}
	}
	else if((ListCtrlID == "ExchangeRichList"))
	{
		updateNeedItem();
		DelegateNeedItemOnUpdateItem();
	}
	return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
	if(needItemScript.GetCanBuy())
	{
		if((ListCtrlID == "Item_RichList"))
		{
			OnRecovery_BtnClick();
		}
		else
		{
			OnExchange_BtnClick();
		}
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_PacketID(1064):
			ParsePacket_S_EX_ITEM_RESTORE_OPEN();
			return;
		case EV_PacketID(947):
			ParsePacket_S_EX_ITEM_RESTORE_LIST();
			return;
		case EV_PacketID(948):
			ParsePacket_S_EX_ITEM_RESTORE();
			return;
		default:
			if((Event_ID == 2530))
			{
				ParseInt(param, "ShowType", nShowType);
			}
			if((nShowType == 3))
			{
				switch(Event_ID)
				{
					case 2530:
						HandleMultiSellInfoListBegin(param);
						break;
					case 2535:
						HandleMultiSellResultItemInfo(param);
						break;
					case 2540:
						HandelMultiSellOutputItemInfo(param);
						break;
					case 2550:
						HandelMultiSellInputItemInfo(param);
						break;
					case 2560:
						HandleMultiSellInfoListEnd(param);
						break;
					case 2565:
						showDisable(false);
						break;
					case 9570:
						updateNeedItem();
						DelegateNeedItemOnUpdateItem();
						break;
					default:
						break;
				}
			}
	}
	return;
}

function HandleMultiSellInfoListBegin(string param)
{
	ClearMultiSellAll();
	ParseInt(param, "MultiSellGroupID", m_MultiSellGroupID);
	return;
}

function HandleMultiSellResultItemInfo(string param)
{
	local int nMultiSellInfoID, nBuyType;
	local ItemInfo Info;

	ParseInt(param, "MultiSellInfoID", nMultiSellInfoID);
	ParseInt(param, "BuyType", nBuyType);
	ItemInfoToParam(Info, param);
	m_nCurrentMultiSellInfoIndex = m_MultiSellInfoList.Length;
	m_MultiSellInfoList.Length = (m_MultiSellInfoList.Length + 1);
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellInfoID = nMultiSellInfoID;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellType = nBuyType;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].ResultItemInfo = Info;
	return;
}

function HandelMultiSellOutputItemInfo(string param)
{
	local ItemInfo Info;
	local int nItemClassID, nMultiSellInfoID, nCurrentOutputItemInfoIndex;

	ParseItemID(param, Info.Id);
	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(Info.Id, Info);
	ParamToItemInfo(param, Info);
	ParseInt(param, "ClassID", nItemClassID);
	ParseInt(param, "MultiSellInfoID", nMultiSellInfoID);
	if((m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellInfoID != nMultiSellInfoID))
	{
		return;
	}
	nCurrentOutputItemInfoIndex = m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList.Length;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList.Length = (nCurrentOutputItemInfoIndex + 1);
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList[nCurrentOutputItemInfoIndex] = Info;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList[nCurrentOutputItemInfoIndex].Reserved = m_nCurrentMultiSellInfoIndex;
	return;
}

function HandelMultiSellInputItemInfo(string param)
{
	local int nMultiSellInfoID, nCurrentInputItemInfoIndex, nItemClassID;
	local ItemInfo Info;

	ParseItemID(param, Info.Id);
	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(Info.Id, Info);
	ParseInt(param, "MultiSellInfoID", nMultiSellInfoID);
	ParseInt(param, "ClassID", nItemClassID);
	ParamToItemInfo(param, Info);
	if((m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellInfoID != nMultiSellInfoID))
	{
		return;
	}
	if((nItemClassID != -400))
	{
		nCurrentInputItemInfoIndex = m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].InputItemInfoList.Length;
		m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].InputItemInfoList.Length = (nCurrentInputItemInfoIndex + 1);
		m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].InputItemInfoList[nCurrentInputItemInfoIndex] = Info;
	}
	return;
}

function HandleMultiSellInfoListEnd(string param)
{
	local int i, N, multiSellindex;

	multiSellindex = GetExchangeItemSelectedMultiSellIndex();
	ExchangeItem_RichList.DeleteAllItem();
	N = 0;
	while((N < m_MultiSellInfoList.Length))
	{
		i = 0;
		while((i < m_MultiSellInfoList[N].OutputItemInfoList.Length))
		{
			addRichList_Exchange(ExchangeItem_RichList, m_MultiSellInfoList[N].OutputItemInfoList[i].Id.ClassID, m_MultiSellInfoList[N].OutputItemInfoList[i].ItemNum, N);
			i++;
		}
		N++;
	}
	if((multiSellindex > -1))
	{
		ExchangeItem_RichList.SetSelectedIndex(multiSellindex, true);
		ExchangeItem_RichList.SetFocus();
		updateNeedItem();
	}
	else if((ExchangeItem_RichList.GetRecordCount() > 0))
	{
		ExchangeItem_RichList.SetSelectedIndex(0, true);
		ExchangeItem_RichList.SetFocus();
		updateNeedItem();
	}
	return;
}

function ParsePacket_S_EX_ITEM_RESTORE_OPEN()
{
	local UIPacket._S_EX_ITEM_RESTORE_OPEN packet;

	if(IsPlayerOnWorldRaidServer())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
		return;
	}
	if(!Class'Interface.UIPacket'.static.Decode_S_EX_ITEM_RESTORE_OPEN(packet))
	{
		return;
	}
	Debug(("ParsePacket_S_EX_ITEM_RESTORE_OPEN" @ string(packet.nItemClassID)));
	if((Me.IsShowWindow() && (currentCouponClassID == packet.nItemClassID)))
	{
		Me.HideWindow();
		return;
	}
	if((Me.IsShowWindow() && (currentCouponClassID != packet.nItemClassID)))
	{
		currentCouponClassID = packet.nItemClassID;
		showProcess();
		return;
	}
	currentCouponClassID = packet.nItemClassID;
	Me.ShowWindow();
	Me.SetFocus();
	return;
}

function ParsePacket_S_EX_ITEM_RESTORE_LIST()
{
	local UIPacket._S_EX_ITEM_RESTORE_LIST packet;
	local int i, lastSelectedIndex;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_ITEM_RESTORE_LIST(packet))
	{
		return;
	}
	Debug(" -->  S_EX_ITEM_RESTORE_LIST  :  ");
	// packet.Items.Sort(SortListDelegate);   // array.Sort() unsupported by this compiler
	RecoveryRichList.DeleteAllItem();
	if((packet.Items.Length > 0))
	{
		ListDisable_Wnd.HideWindow();
	}
	else
	{
		ListDisable_Wnd.ShowWindow();
	}
	i = 0;
	while((i < packet.Items.Length))
	{
		addRichList_ItemRecovery(RecoveryRichList, packet.Items[i].nBrokenItemClassID, packet.Items[i].nFixedItemClassID, packet.Items[i].cEnchant);
		i++;
	}
	if((RecoveryRichList.GetRecordCount() > -1))
	{
		lastSelectedIndex = lastSelectedListArray[currentRecoverTabNum];
		if((lastSelectedIndex < RecoveryRichList.GetRecordCount()))
		{
			RecoveryRichList.SetSelectedIndex(lastSelectedIndex, true);
		}
		else
		{
			RecoveryRichList.SetSelectedIndex((RecoveryRichList.GetRecordCount() - 1), true);
		}
		RecoveryRichList.SetFocus();
		updateNeedItem();
	}
	return;
}

function ParsePacket_S_EX_ITEM_RESTORE()
{
	local UIPacket._S_EX_ITEM_RESTORE packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_ITEM_RESTORE(packet))
	{
		return;
	}
	Debug((" -->  S_EX_ITEM_RESTORE  :  " @ string(packet.cResult)));
	if((packet.cResult == 0))
	{
		setResult();
	}
	else
	{
		Me.HideWindow();
	}
	return;
}

delegate int SortListDelegate(UIPacket._PkItemRestoreNode a1, UIPacket._PkItemRestoreNode a2)
{
	if((a1.cOrder > a2.cOrder))
	{
		return -1;
	}
	return 0;
}

function InitNeedItem()
{
	local WindowHandle needItemWnd;

	needItemWnd = GetWindowHandle((m_Windowname $ ".Bottom_Wnd.needItemWnd"));
	needItemWnd.SetScript("UIControlNeedItemList");
	needItemScript = UIControlNeedItemList(needItemWnd.GetScript());
	needItemScript.SetRichListControler(GetRichListCtrlHandle((m_Windowname $ ".Bottom_Wnd.needItemWnd.NeedItemRichListCtrl")));
	needItemScript.DelegateOnUpdateItem = DelegateNeedItemOnUpdateItem;
	return;
}

function DelegateNeedItemOnUpdateItem()
{
	if(needItemScript.GetCanBuy())
	{
		if(IsInState('ItemRecoveryState'))
		{
			Recovery_Btn.EnableWindow();
		}
		else
		{
			Exchange_Btn.EnableWindow();
		}
	}
	else if(IsInState('ItemRecoveryState'))
	{
		Recovery_Btn.DisableWindow();
	}
	else
	{
		Exchange_Btn.DisableWindow();
	}
	return;
}

function SetPopupScript()
{
	local WindowHandle popExpandWnd;
	local UIControlDialogAssets popupExpandScript;
	local WindowHandle disableWnd;

	popExpandWnd = GetWindowHandle((m_Windowname $ ".UIControlDialogAsset"));
	popupExpandScript = Class'Interface.UIControlDialogAssets'.static.InitScript(popExpandWnd);
	disableWnd = GetWindowHandle((m_Windowname $ ".disable_tex"));
	popupExpandScript.SetDisableWindow(disableWnd);
	Class'NWindow.UIAPI_WINDOW'.static.SetAlwaysOnTop((m_Windowname $ ".disable_tex"), false);
	return;
}

function UIControlDialogAssets GetPopupExpandScript()
{
	local WindowHandle popExpandWnd;

	popExpandWnd = GetWindowHandle((m_Windowname $ ".UIControlDialogAsset"));
	return UIControlDialogAssets(popExpandWnd.GetScript());
}

function ShowPopup(string Msg, string Param1)
{
	local UIControlDialogAssets popupExpandScript;

	popupExpandScript = GetPopupExpandScript();
	popupExpandScript.SetDialogDesc(MakeFullSystemMsg(Msg, Param1));
	popupExpandScript.Show();
	popupExpandScript.OKButton.EnableWindow();
	popupExpandScript.DelegateOnClickBuy = OnDialogOK;
	popupExpandScript.DelegateOnCancel = OnClickCancelDialog;
	showDisable(true);
	return;
}

function OnDialogOK()
{
	local string param;
	local int multiSellindex;

	if(IsInState('ItemRecoveryState'))
	{
		GetPopupExpandScript().Hide();
		API_C_EX_ITEM_RESTORE(nCurrentBrokenItemClassId, nCurrentBrokenEnchantNum);
	}
	else
	{
		GetPopupExpandScript().Hide();
		multiSellindex = GetExchangeItemSelectedMultiSellIndex();
		ParamAdd(param, "MultiSellGroupID", string(m_MultiSellGroupID));
		ParamAdd(param, "MultiSellInfoID", string(m_MultiSellInfoList[multiSellindex].MultiSellInfoID));
		ParamAdd(param, "ItemCount", "1");
		ParamAdd(param, "Enchant", string(m_MultiSellInfoList[multiSellindex].ResultItemInfo.Enchanted));
		ParamAdd(param, "RefineryOp1", string(m_MultiSellInfoList[multiSellindex].ResultItemInfo.RefineryOp1));
		ParamAdd(param, "RefineryOp2", string(m_MultiSellInfoList[multiSellindex].ResultItemInfo.RefineryOp2));
		ParamAdd(param, "RefineryOp3", string(m_MultiSellInfoList[multiSellindex].ResultItemInfo.RefineryOp3));
		ParamAdd(param, "AttrAttackType", string(m_MultiSellInfoList[multiSellindex].ResultItemInfo.AttackAttributeType));
		ParamAdd(param, "AttrAttackValue", string(m_MultiSellInfoList[multiSellindex].ResultItemInfo.AttackAttributeValue));
		ParamAdd(param, "AttrDefenseValueFire", string(m_MultiSellInfoList[multiSellindex].ResultItemInfo.DefenseAttributeValueFire));
		ParamAdd(param, "AttrDefenseValueWater", string(m_MultiSellInfoList[multiSellindex].ResultItemInfo.DefenseAttributeValueWater));
		ParamAdd(param, "AttrDefenseValueWind", string(m_MultiSellInfoList[multiSellindex].ResultItemInfo.DefenseAttributeValueWind));
		ParamAdd(param, "AttrDefenseValueEarth", string(m_MultiSellInfoList[multiSellindex].ResultItemInfo.DefenseAttributeValueEarth));
		ParamAdd(param, "AttrDefenseValueHoly", string(m_MultiSellInfoList[multiSellindex].ResultItemInfo.DefenseAttributeValueHoly));
		ParamAdd(param, "AttrDefenseValueUnholy", string(m_MultiSellInfoList[multiSellindex].ResultItemInfo.DefenseAttributeValueUnholy));
		addParamEnsoulOptionInfo(m_MultiSellInfoList[multiSellindex].ResultItemInfo, param);
		ParamAdd(param, "IsBlessedItem", string(m_MultiSellInfoList[multiSellindex].ResultItemInfo.BlessBaseEffectID));
		RequestMultiSellChoose(param);
	}
	showDisable(false);
	return;
}

function OnClickCancelDialog()
{
	GetPopupExpandScript().Hide();
	showDisable(false);
	return;
}

function setResult()
{
	local ItemInfo Info;

	ResultDialog_Wnd.ShowWindow();
	Info = GetItemInfoByClassID(nCurrentFixedItemClassId);
	Info.Enchanted = nCurrentBrokenEnchantNum;
	Result_ItemWnd.Clear();
	Result_ItemWnd.AddItem(Info);
	ItemName_Txt.SetText(GetItemNameAll(Info));
	Discription_Txt.SetText(GetSystemString(13676));
	playResultEffectViewPort("LineageEffect2.ui_upgrade_succ");
	PlaySound("ItemSound3.enchant_success");
	return;
}

function int getMultiSellID()
{
	return CouponData.DefaultMultisellId;
}

function API_C_EX_ITEM_RESTORE_LIST(int cCategory)
{
	local array<byte> stream;
	local UIPacket._C_EX_ITEM_RESTORE_LIST packet;

	packet.cCategory = cCategory;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_ITEM_RESTORE_LIST(stream, packet))
	{
		return;
	}
	RecoveryRichList.DeleteAllItem();
	Class'Interface.UIPacket'.static.RequestUIPacket(713, stream);
	Debug(("----> Api Call : C_EX_ITEM_RESTORE_LIST  " @ string(cCategory)));
	return;
}

function API_C_EX_ITEM_RESTORE(int nBrokenItemClassID, int cEnchant)
{
	local array<byte> stream;
	local UIPacket._C_EX_ITEM_RESTORE packet;

	packet.nBrokenItemClassID = nBrokenItemClassID;
	packet.cEnchant = cEnchant;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_ITEM_RESTORE(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(714, stream);
	Debug((("----> Api Call : C_EX_ITEM_RESTORE  " @ string(nBrokenItemClassID)) @ string(cEnchant)));
	return;
}

function API_C_EX_MULTI_SELL_LIST(int nMultiSellID)
{
	local array<byte> stream;
	local UIPacket._C_EX_SELECT_GLOBAL_EVENT_UI packet;

	packet.nEventIndex = nMultiSellID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_SELECT_GLOBAL_EVENT_UI(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(755, stream);
	Debug(("----> Api Call : C_EX_MULTI_SELL_LIST 멀티셀 호출 " @ string(nMultiSellID)));  // EN?: ---- > Api Call: C_EX_multi_sell_list Multicell call
	return;
}

function int GetExchangeItemSelectedMultiSellIndex()
{
	local RichListCtrlRowData rowData;

	if((ExchangeItem_RichList.GetSelectedIndex() == -1))
	{
		return -1;
	}
	if((ExchangeItem_RichList.GetRecordCount() < 1))
	{
		return -1;
	}
	ExchangeItem_RichList.GetSelectedRec(rowData);
	return int(rowData.nReserved1);
}

function showDisable(bool bShow)
{
	if(bShow)
	{
		GetWindowHandle((m_Windowname $ ".disable_tex")).ShowWindow();
	}
	else
	{
		GetWindowHandle((m_Windowname $ ".disable_tex")).HideWindow();
	}
	return;
}

function playResultEffectViewPort(string effectPath)
{
	local Vector offset;

	if((effectPath == "LineageEffect2.ui_upgrade_succ"))
	{
		offset.X = 10.0000000;
		offset.Y = -5.0000000;
		EffectViewport02.SetScale(6.0000000);
		EffectViewport02.SetCameraDistance(1300.0000000);
		EffectViewport02.SetOffset(offset);
	}
	else if((effectPath == "LineageEffect.d_firework_a"))
	{
		offset.X = 10.0000000;
		offset.Y = -5.0000000;
		EffectViewport02.SetScale(6.0000000);
		EffectViewport02.SetCameraDistance(1300.0000000);
		EffectViewport02.SetOffset(offset);
	}
	EffectViewport02.SetFocus();
	EffectViewport02.SpawnEffect(effectPath);
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

state ItemRecoveryState
{
	function BeginState()
	{
		Recovery_Btn.ShowWindow();
		Exchange_Btn.HideWindow();
		ItemRecovery_Wnd.ShowWindow();
		Exchange_Wnd.HideWindow();
		updateNeedItem();
		Debug("시작 스테이트 ItemRecoveryState");  // EN?: Start State ItemRecoveryState
		return;
	}

	function updateNeedItem()
	{
		needItemScript.CleariObjects();
		needItemScript.StartNeedItemList(1);
		needItemScript.AddNeedItemClassID(currentCouponClassID, INT64(1));
		needItemScript.SetBuyNum(INT64(1));
		return;
	}
}

state ExchangeState
{
	function BeginState()
	{
		Recovery_Btn.HideWindow();
		Exchange_Btn.ShowWindow();
		ItemRecovery_Wnd.HideWindow();
		Exchange_Wnd.ShowWindow();
		Debug("시작 스테이트 ExchangeState");  // EN?: Start State ExchangeState
		needItemScript.CleariObjects();
		API_C_EX_MULTI_SELL_LIST(getMultiSellID());
		return;
	}

	function updateNeedItem()
	{
		local int i, multiSellindex;

		multiSellindex = GetExchangeItemSelectedMultiSellIndex();
		if((multiSellindex > -1))
		{
			needItemScript.CleariObjects();
			needItemScript.StartNeedItemList(1);
			i = 0;
			while((i < m_MultiSellInfoList[multiSellindex].InputItemInfoList.Length))
			{
				needItemScript.AddNeedItemClassID(m_MultiSellInfoList[multiSellindex].InputItemInfoList[i].Id.ClassID, m_MultiSellInfoList[multiSellindex].InputItemInfoList[i].ItemNum);
				i++;
			}
			needItemScript.SetBuyNum(INT64(1));
		}
		return;
	}
}

defaultproperties
{
	m_Windowname="BlackCouponWnd"
}
