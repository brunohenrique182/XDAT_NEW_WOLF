class WorldExchangeRegiWndItemHistoryTabWnd extends UICommonAPI
	dependson(UIPacket);

const REFRESHLIMIT = 2000;

enum listType
{
	Received,                       // 0
	TimeOut,                        // 1
	Normal,                         // 2
	Wait                            // 3
};

var array<UIPacket._WorldExchangeItemData> _itemDatas;
var L2UITimerObject tObject;
var RichListCtrlHandle ItemHistory_RichList;
var TextureHandle AddReward;
var INT64 nWEIndexRequested;
var int receivedNum;
var bool b_DisableWindow;

function ReduceReceiveNum()
{
	receivedNum--;
	CheckNoticeWnd();
	return;
}

function CheckNoticeWnd()
{
	local NoticeWnd noticeWndScr;
	local string param;

	noticeWndScr = NoticeWnd(GetScript("NoticeWnd"));
	if((receivedNum < 1))
	{
		noticeWndScr._RemoveNoticButtonWorldExchangeBuy();
	}
	else
	{
		ParamAdd(param, "rewardCount", string(receivedNum));
		noticeWndScr._CreateWorldExchangeBuyNotice(param);
	}
	return;
}

function SetRegisterEvent()
{
	RegisterEvent(EV_PacketID(1023));
	RegisterEvent(EV_PacketID(1024));
	RegisterEvent(EV_PacketID(1168));
	RegisterEvent(40);
	Debug("           -----------   히스토리 온 레디스트 됐나? OnRegisterEvent");  // EN?: ----------- Is History on Redist? OnRegisterEvent
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	tObject = Class'Interface.L2UITimer'.static.Inst()._MakeTimerObject(2000);
	tObject._DelegateOnEnd = SetEnableRefresh;
	ItemHistory_RichList = GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemHistory_RichList"));
	ItemHistory_RichList.SetSelectedSelTooltip(false);
	ItemHistory_RichList.SetAppearTooltipAtMouseX(true);
	Debug((("          -----------   히스토리 온 로드 됐나? OnLoad :" @ m_hOwnerWnd.m_WindowNameWithFullPath) $ ".ItemHistory_RichList"));  // EN?: ----------- History on loaded? OnLoad:
	SetRegisterEvent();
	SetMaxRegiItemDefault();
	return;
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case EV_PacketID(1023):
			RT_S_EX_WORLD_EXCHANGE_SETTLE_LIST();
			break;
		case EV_PacketID(1024):
			RT_S_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT();
			break;
		case EV_PacketID(1168):
			RT_S_EX_WORLD_EXCHANGE_INFO();
			break;
		case 40:
			SetMaxRegiItemDefault();
			break;
		default:
			break;
	}
	return;
}

event OnShow()
{
	if(b_DisableWindow)
	{
		tObject._Reset();
	}
	return;
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "Refresh_Btn":
			HandleRefresh();
			break;
		default:
			ChckBtnName(strID);
			break;
	}
	return;
}

function RQ_C_EX_WORLD_EXCHANGE_SETTLE_LIST()
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLD_EXCHANGE_SETTLE_LIST packet;

	if(!Class'Interface.UIPacket'.static.Encode_C_EX_WORLD_EXCHANGE_SETTLE_LIST(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(787, stream);
	return;
}

function RT_S_EX_WORLD_EXCHANGE_SETTLE_LIST()
{
	local UIPacket._S_EX_WORLD_EXCHANGE_SETTLE_LIST packet;

	Debug("RT_S_EX_WORLD_EXCHANGE_SETTLE_LIST");
	if(!Class'Interface.UIPacket'.static.Decode_S_EX_WORLD_EXCHANGE_SETTLE_LIST(packet))
	{
		return;
	}
	ItemHistory_RichList.DeleteAllItem();
	AddList(packet.vRecvItemDataList, Received);
	AddList(packet.vTimeOutItemDataList, TimeOut);
	AddList(packet.vRegiItemDataList, Normal);
	AddList(packet.vWaitItemDataList, Wait);
	receivedNum = packet.vRecvItemDataList.Length;
	CheckNoticeWnd();
	handleResult();
	return;
}

function RT_S_EX_WORLD_EXCHANGE_INFO()
{
	local UIPacket._S_EX_WORLD_EXCHANGE_INFO packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_WORLD_EXCHANGE_INFO(packet))
	{
		return;
	}
	Class'Interface.WorldExchangeRegiWnd'.static.Inst()._SetMaxRegiItemNum(packet.nMaxSlot);
	SetMaxRegiItem(packet.nMaxSlot);
	return;
}

function handleResult()
{
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".MyRegiItemNumTxt_Apply")).SetText(string(_GetRegiItemCount()));
	AddReward = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AddReward"));
	Class'Interface.WorldExchangeRegiWnd'.static.Inst()._SetCurrentRigedItemNum(_GetRegiItemCount());
	if((receivedNum == 0))
	{
		AddReward.HideWindow();
	}
	else if((receivedNum < 10))
	{
		AddReward.SetTexture(("L2UI_CT1.tab.TabNoticeCount_0" $ string(receivedNum)));
		AddReward.ShowWindow();
	}
	else if((receivedNum > 9))
	{
		AddReward.SetTexture("L2UI_CT1.tab.TabNoticeCount_09Plus");
		AddReward.ShowWindow();
	}
	return;
}

function int _GetRegiItemCount()
{
	return ItemHistory_RichList.GetRecordCount();
}

function AddList(array<UIPacket._WorldExchangeItemData> itemDatas, listType _listType)
{
	local int i;
	local RichListCtrlRowData rowData;

	i = 0;
	while((i < itemDatas.Length))
	{
		if((itemDatas[i].nItemClassID == 57))
		{
			if(MakeRowDataAdena(itemDatas[i], rowData, _listType))
			{
				ItemHistory_RichList.InsertRecord(rowData);
			}
			i++;
			continue;
		}
		if(MakeRowData(itemDatas[i], rowData, _listType))
		{
			ItemHistory_RichList.InsertRecord(rowData);
		}
		i++;
	}
	return;
}

function RQ_C_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT()
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT packet;

	Debug(("RQ_C_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT" @ string(nWEIndexRequested)));
	packet.nWEIndex = nWEIndexRequested;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(788, stream);
	return;
}

function RT_S_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT()
{
	local UIPacket._S_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT packet;

	Debug("RT_S_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT");
	if(!Class'Interface.UIPacket'.static.Decode_S_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT(packet))
	{
		return;
	}
	switch(packet.cSuccess)
	{
		case 1:
			HandleRecvResult();
			break;
		case 0:
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13686));
			break;
		case -1:
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13687));
			break;
		case -2:
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(6239));
			break;
		default:
			break;
	}
	GetWindowHandle("WorldExchangeRegiWnd.CancelSaleDialog_Wnd").HideWindow();
	return;
}

function HandleRecvResult()
{
	local int i;
	local RichListCtrlRowData rowData;

	i = GetRichListCtrlRowData(nWEIndexRequested, rowData);
	if((i < 0))
	{
		return;
	}
	switch(int(rowData.nReserved3))
	{
		case 0:
			ReduceReceiveNum();
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13668));
			break;
		case 1:
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13669));
			break;
		case 3:
		case 2:
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13670));
			break;
		default:
			break;
	}
	ItemHistory_RichList.DeleteRecord(i);
	handleResult();
	return;
}

function int GetRichListCtrlRowData(INT64 nWEIndex, out RichListCtrlRowData outRowData)
{
	local int i;

	i = GetListIndexWithnWEIndex(nWEIndex);
	ItemHistory_RichList.GetRec(i, outRowData);
	return i;
}

function SetDisablbRefresh()
{
	b_DisableWindow = true;
	Class'Interface.WorldExchangeRegiWnd'.static.Inst()._ShowDisableWIndow();
	tObject._Reset();
	return;
}

function SetEnableRefresh()
{
	b_DisableWindow = false;
	Class'Interface.WorldExchangeRegiWnd'.static.Inst()._HideDisableWindow();
	return;
}

function ChckBtnName(string btnName)
{
	local array<string> names;

	Split(btnName, "_", names);
	if((names[0] == "btnBuy"))
	{
		SetShowBuyDialogWindow(int(names[1]));
	}
	return;
}

function SetShowBuyDialogWindow(int WEIndex)
{
	local RichListCtrlRowData rowData;
	local int listIndex;

	if(IsPlayerOnWorldRaidServer())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
		return;
	}
	listIndex = GetListIndexWithnWEIndex(INT64(WEIndex));
	ItemHistory_RichList.GetRec(listIndex, rowData);
	nWEIndexRequested = INT64(WEIndex);
	switch(rowData.nReserved3)
	{
		case INT64(0):
		case INT64(1):
			RQ_C_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT();
			break;
		case INT64(3):
		case INT64(2):
			ShowDialog(rowData.szReserved);
			break;
		default:
			break;
	}
	return;
}

function _RQ_C_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT()
{
	RQ_C_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT();
	return;
}

function ShowDialog(string itemReservedString)
{
	Class'Interface.WorldExchangeRegiWnd'.static.Inst()._SetShowCancelDialog(itemReservedString);
	return;
}

function int GetListIndexWithnWEIndex(INT64 nWEIndex)
{
	local int i;
	local RichListCtrlRowData rowData;

	i = 0;
	while((i < ItemHistory_RichList.GetRecordCount()))
	{
		ItemHistory_RichList.GetRec(i, rowData);
		if((rowData.nReserved1 == nWEIndex))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function _Show()
{
	return;
}

function _Hide()
{
	m_hOwnerWnd.HideWindow();
	return;
}

function HandleRefresh()
{
	Debug(" Handle Refresh");
	SetDisablbRefresh();
	RQ_C_EX_WORLD_EXCHANGE_SETTLE_LIST();
	return;
}

function bool MakeRowDataAdena(UIPacket._WorldExchangeItemData _itemData, out RichListCtrlRowData outRowData, listType _listType)
{
	local RichListCtrlRowData rowData;
	local ItemInfo iInfo;
	local string strcom, itemParam;
	local int nWidth, nHeight, buttonW, RemainTime;
	local float unitPrice;

	rowData.cellDataList.Length = 6;
	if((_itemData.nItemClassID < 1))
	{
		return false;
	}
	if(!Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(_itemData.nItemClassID), iInfo))
	{
		return false;
	}
	rowData.nReserved1 = _itemData.nWEIndex;
	RemainTime = ((_itemData.nExpiredTime - Class'Interface.UIData'.static.Inst().serverStartTime) - Class'Interface.UIData'.static.Inst().gameConnectTimeSec());
	rowData.nReserved3 = INT64(int(_listType));
	iInfo = GetItemInfoByClassID(57);
	iInfo.ItemNum = _itemData.nAmount;
	iInfo.bShowCount = true;
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "l2ui_ct1.ItemWindow_DF_SlotBox_Default", 36, 36, 0, 1);
	Class'Interface.WorldExchangeBuyWnd'.static.Inst()._MakeAdenaitemInfo(iInfo);
	AddRichListCtrlItem(rowData.cellDataList[0].drawitems, iInfo, 32, 32, -34, 2);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, Class'Interface.WorldExchangeBuyWnd'.static.Inst()._MakeAdenaString(iInfo.ItemNum), GetNumericColor(string(iInfo.ItemNum)), false, 4, 9);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, "1", GTColor().White, false);
	switch(_listType)
	{
		case Wait:
			AddRichListCtrlString(rowData.cellDataList[2].drawitems, "-", GTColor().White, false);
			break;
		case Normal:
			AddRichListCtrlString(rowData.cellDataList[2].drawitems, Class'Interface.L2Util'.static.Inst().getTimeStringBySec3(RemainTime), GTColor().White, false);
			break;
		default:
			AddRichListCtrlString(rowData.cellDataList[2].drawitems, Class'Interface.L2Util'.static.Inst().getTimeStringBySec3(RemainTime), GTColor().Red, false);
			break;
	}
	iInfo.Price = _itemData.nPrice;
	strcom = MakeCostStringINT64(iInfo.Price);
	AddRichListCtrlString(rowData.cellDataList[3].drawitems, GetSystemString(3931), GetColor(147, 136, 112, 255), false, 18, 0);
	AddRichListCtrlString(rowData.cellDataList[3].drawitems, strcom, GetNumericColor(strcom), false, 5, 0);
	buttonW = 110;
	switch(_listType)
	{
		case Received:
			AddRichListCtrlButton(rowData.cellDataList[5].drawitems, ("btnBuy_" $ string(_itemData.nWEIndex)), 0, 0, "L2UI_NewTex.Button.SimpleBtnGreen_DF", "L2UI_NewTex.Button.SimpleBtnGreen_Down", "L2UI_NewTex.Button.SimpleBtnGreen_Over", buttonW, 30, buttonW, 30, int(_itemData.nWEIndex));
			GetTextSizeDefault(GetSystemString(14068), nWidth, nHeight);
			AddRichListCtrlString(rowData.cellDataList[5].drawitems, GetSystemString(14068), getInstanceL2Util().White, false, (-(buttonW + nWidth) / 2), 8);
			break;
		case TimeOut:
			AddRichListCtrlButton(rowData.cellDataList[5].drawitems, ("btnBuy_" $ string(_itemData.nWEIndex)), 0, 0, "L2UI_NewTex.Button.SimpleBtnBlue_DF", "L2UI_NewTex.Button.SimpleBtnBlue_Down", "L2UI_NewTex.Button.SimpleBtnBlue_Over", buttonW, 30, buttonW, 30, int(_itemData.nWEIndex));
			GetTextSizeDefault(GetSystemString(14069), nWidth, nHeight);
			AddRichListCtrlString(rowData.cellDataList[5].drawitems, GetSystemString(14069), getInstanceL2Util().White, false, (-(buttonW + nWidth) / 2), 8);
			break;
		case Wait:
			AddRichListCtrlButton(rowData.cellDataList[5].drawitems, ("btnBuy_" $ string(_itemData.nWEIndex)), 0, 0, "L2UI_NewTex.Button.SimpleBtnBrown_DF", "L2UI_NewTex.Button.SimpleBtnBrown_Down", "L2UI_NewTex.Button.SimpleBtnBrown_Over", buttonW, 30, buttonW, 30, int(_itemData.nWEIndex));
			GetTextSizeDefault(GetSystemString(14866), nWidth, nHeight);
			AddRichListCtrlString(rowData.cellDataList[5].drawitems, GetSystemString(14866), getInstanceL2Util().White, false, (-(buttonW + nWidth) / 2), 8);
			break;
		case Normal:
			AddRichListCtrlButton(rowData.cellDataList[5].drawitems, ("btnBuy_" $ string(_itemData.nWEIndex)), 0, 0, "L2UI_NewTex.Button.SimpleBtnBrown_DF", "L2UI_NewTex.Button.SimpleBtnBrown_Down", "L2UI_NewTex.Button.SimpleBtnBrown_Over", buttonW, 30, buttonW, 30, int(_itemData.nWEIndex));
			GetTextSizeDefault(GetSystemString(2519), nWidth, nHeight);
			AddRichListCtrlString(rowData.cellDataList[5].drawitems, GetSystemString(2519), getInstanceL2Util().White, false, (-(buttonW + nWidth) / 2), 8);
			break;
		default:
			break;
	}
	unitPrice = (float(iInfo.Price) / (float(iInfo.ItemNum) / float(Class'Interface.WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT)));
	strcom = MakeCostStringINT64((iInfo.Price / (iInfo.ItemNum / Class'Interface.WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT)));
	AddRichListCtrlString(rowData.cellDataList[4].drawitems, "", GetColor(0, 0, 0, 0), false, 0, 0);
	AddRichListCtrlString(rowData.cellDataList[4].drawitems, ("." $ Class'Interface.WorldExchangeBuyWnd'.static.Inst().GetDecimalNnmStr(unitPrice)), GetColor(123, 123, 123, 255), false, 0, 1, "hs7");
	AddRichListCtrlString(rowData.cellDataList[4].drawitems, strcom, GetNumericColor(strcom), false, 0, -2);
	AddRichListCtrlButton(rowData.cellDataList[4].drawitems, "btnTooltipAdena", 3, -2, "L2UI_NewTex.Icon.ExclamationMark_s", "L2UI_NewTex.Icon.ExclamationMark_s", "L2UI_NewTex.Icon.ExclamationMark_s", 16, 16, 16, 16, int(_itemData.nWEIndex), "btnTooltipAdena");
	ItemInfoToParam(iInfo, itemParam);
	rowData.szReserved = itemParam;
	rowData.nReserved2 = (iInfo.Price - GetCommitionSell(iInfo.Price));
	outRowData = rowData;
	return true;
}

function bool MakeRowData(UIPacket._WorldExchangeItemData _itemData, out RichListCtrlRowData outRowData, listType _listType)
{
	local RichListCtrlRowData rowData;
	local ItemInfo iInfo;
	local string strcom, itemParam;
	local int nWidth, nHeight, buttonW, RemainTime;
	local float unitPrice;

	rowData.cellDataList.Length = 6;
	if((_itemData.nItemClassID < 1))
	{
		return false;
	}
	if(!Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(_itemData.nItemClassID), iInfo))
	{
		return false;
	}
	rowData.nReserved1 = _itemData.nWEIndex;
	RemainTime = ((_itemData.nExpiredTime - Class'Interface.UIData'.static.Inst().serverStartTime) - Class'Interface.UIData'.static.Inst().gameConnectTimeSec());
	rowData.nReserved3 = INT64(int(_listType));
	iInfo.ItemNum = _itemData.nAmount;
	iInfo.bShowCount = IsStackableItem(iInfo.ConsumeType);
	iInfo.Enchanted = _itemData.nEnchant;
	iInfo.RefineryOp1 = _itemData.nVariationOpt1;
	iInfo.RefineryOp2 = _itemData.nVariationOpt2;
	iInfo.RefineryOp3 = _itemData.nVariationOpt3;
	iInfo.AttackAttributeType = _itemData.nBaseAttributeAttackType;
	iInfo.AttackAttributeValue = _itemData.nBaseAttributeAttackValue;
	iInfo.DefenseAttributeValueFire = _itemData.nBaseAttributeDefendValue[0];
	iInfo.DefenseAttributeValueWater = _itemData.nBaseAttributeDefendValue[1];
	iInfo.DefenseAttributeValueWind = _itemData.nBaseAttributeDefendValue[2];
	iInfo.DefenseAttributeValueEarth = _itemData.nBaseAttributeDefendValue[3];
	iInfo.DefenseAttributeValueHoly = _itemData.nBaseAttributeDefendValue[4];
	iInfo.DefenseAttributeValueUnholy = _itemData.nBaseAttributeDefendValue[5];
	iInfo.LookChangeItemID = _itemData.nShapeShiftingClassId;
	iInfo.LookChangeItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(_itemData.nShapeShiftingClassId));
	if((_itemData.nShapeShiftingClassId > 0))
	{
		iInfo.LookChangeIconPanel = "BranchSys3.Icon.pannel_lookChange";
	}
	iInfo.EnsoulOption[(1 - 1)].OptionArray[0] = _itemData.nEsoulOption[0];
	iInfo.EnsoulOption[(1 - 1)].OptionArray[1] = _itemData.nEsoulOption[1];
	iInfo.EnsoulOption[(2 - 1)].OptionArray[0] = _itemData.nEsoulOption[2];
	iInfo.IsBlessedItem = (_itemData.nBlessOption == 1);
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "l2ui_ct1.ItemWindow_DF_SlotBox_Default", 36, 36, 0, 1);
	AddRichListCtrlItem(rowData.cellDataList[0].drawitems, iInfo, 32, 32, -34, 2);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, GetItemNameAll(iInfo), GTColor().White, false, 4, 9);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, string(_itemData.nAmount), GTColor().White, false);
	switch(_listType)
	{
		case Wait:
			AddRichListCtrlString(rowData.cellDataList[2].drawitems, "-", GTColor().White, false);
			break;
		case Normal:
			AddRichListCtrlString(rowData.cellDataList[2].drawitems, Class'Interface.L2Util'.static.Inst().getTimeStringBySec3(RemainTime), GTColor().White, false);
			break;
		default:
			AddRichListCtrlString(rowData.cellDataList[2].drawitems, Class'Interface.L2Util'.static.Inst().getTimeStringBySec3(RemainTime), GTColor().Red, false);
			break;
	}
	iInfo.Price = _itemData.nPrice;
	strcom = MakeCostStringINT64(iInfo.Price);
	AddRichListCtrlString(rowData.cellDataList[3].drawitems, GetSystemString(3931), GetColor(147, 136, 112, 255), false, 18, 0);
	AddRichListCtrlString(rowData.cellDataList[3].drawitems, strcom, GetNumericColor(strcom), false, 5, 0);
	buttonW = 110;
	switch(_listType)
	{
		case Received:
			AddRichListCtrlButton(rowData.cellDataList[5].drawitems, ("btnBuy_" $ string(_itemData.nWEIndex)), 0, 0, "L2UI_NewTex.Button.SimpleBtnGreen_DF", "L2UI_NewTex.Button.SimpleBtnGreen_Down", "L2UI_NewTex.Button.SimpleBtnGreen_Over", buttonW, 30, buttonW, 30, int(_itemData.nWEIndex));
			GetTextSizeDefault(GetSystemString(14068), nWidth, nHeight);
			AddRichListCtrlString(rowData.cellDataList[5].drawitems, GetSystemString(14068), getInstanceL2Util().White, false, (-(buttonW + nWidth) / 2), 8);
			break;
		case TimeOut:
			AddRichListCtrlButton(rowData.cellDataList[5].drawitems, ("btnBuy_" $ string(_itemData.nWEIndex)), 0, 0, "L2UI_NewTex.Button.SimpleBtnBlue_DF", "L2UI_NewTex.Button.SimpleBtnBlue_Down", "L2UI_NewTex.Button.SimpleBtnBlue_Over", buttonW, 30, buttonW, 30, int(_itemData.nWEIndex));
			GetTextSizeDefault(GetSystemString(14069), nWidth, nHeight);
			AddRichListCtrlString(rowData.cellDataList[5].drawitems, GetSystemString(14069), getInstanceL2Util().White, false, (-(buttonW + nWidth) / 2), 8);
			break;
		case Wait:
			AddRichListCtrlButton(rowData.cellDataList[5].drawitems, ("btnBuy_" $ string(_itemData.nWEIndex)), 0, 0, "L2UI_NewTex.Button.SimpleBtnBrown_DF", "L2UI_NewTex.Button.SimpleBtnBrown_Down", "L2UI_NewTex.Button.SimpleBtnBrown_Over", buttonW, 30, buttonW, 30, int(_itemData.nWEIndex));
			GetTextSizeDefault(GetSystemString(14866), nWidth, nHeight);
			AddRichListCtrlString(rowData.cellDataList[5].drawitems, GetSystemString(14866), getInstanceL2Util().White, false, (-(buttonW + nWidth) / 2), 8);
			break;
		case Normal:
			AddRichListCtrlButton(rowData.cellDataList[5].drawitems, ("btnBuy_" $ string(_itemData.nWEIndex)), 0, 0, "L2UI_NewTex.Button.SimpleBtnBrown_DF", "L2UI_NewTex.Button.SimpleBtnBrown_Down", "L2UI_NewTex.Button.SimpleBtnBrown_Over", buttonW, 30, buttonW, 30, int(_itemData.nWEIndex));
			GetTextSizeDefault(GetSystemString(2519), nWidth, nHeight);
			AddRichListCtrlString(rowData.cellDataList[5].drawitems, GetSystemString(2519), getInstanceL2Util().White, false, (-(buttonW + nWidth) / 2), 8);
			break;
		default:
			break;
	}
	unitPrice = (float(iInfo.Price) / float(iInfo.ItemNum));
	strcom = MakeCostStringINT64((iInfo.Price / iInfo.ItemNum));
	AddRichListCtrlString(rowData.cellDataList[4].drawitems, "", GetColor(0, 0, 0, 0), false, 0, 0);
	AddRichListCtrlString(rowData.cellDataList[4].drawitems, ("." $ Class'Interface.WorldExchangeBuyWnd'.static.Inst().GetDecimalNnmStr(unitPrice)), GetColor(123, 123, 123, 255), false, 0, 1, "hs7");
	AddRichListCtrlString(rowData.cellDataList[4].drawitems, strcom, GetNumericColor(strcom), false, 0, -2);
	ItemInfoToParam(iInfo, itemParam);
	rowData.szReserved = itemParam;
	rowData.nReserved2 = (iInfo.Price - GetCommitionSell(iInfo.Price));
	outRowData = rowData;
	return true;
}

function INT64 GetCommitionSell(INT64 Cnt)
{
	local WorldExchangeUIData tmpWorldExchangeUIData;

	tmpWorldExchangeUIData = Class'Interface.WorldExchangeRegiWnd'.static.Inst().API_GetWorldExchangeData();
	return INT64(Max(Min(tmpWorldExchangeUIData.MaxSellFee, int((float(Cnt) * (float(tmpWorldExchangeUIData.SellFee) / 100.0000000)))), 1));
}

function SetMaxRegiItemDefault()
{
	SetMaxRegiItem(10);
	return;
}

function SetMaxRegiItem(int maxNum)
{
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".MyRegiItemNumTxt_Total")).SetText(("/" $ string(maxNum)));
	return;
}

event OnReceivedCloseUI()
{
	Class'Interface.WorldExchangeRegiWnd'.static.Inst()._Hide();
	return;
}
