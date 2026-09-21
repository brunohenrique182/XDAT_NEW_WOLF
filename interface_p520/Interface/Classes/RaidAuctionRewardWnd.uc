class RaidAuctionRewardWnd extends UICommonAPI
	dependson(UIPacket);

var array<byte> _emptyByteArray;

const maxNum = 240;

enum ASSET_TYPE
{
	type_reward,                    // 0
	type_receiveall,                // 1
	type_cancel                     // 2
};

enum RaidAuctionPostType
{
	DropItem,                       // 0
	Refund,                         // 1
	Adjustment,                     // 2
	RandomItem                      // 3
};

var RichListCtrlHandle RewardRichList;
var UIControlDialogAssets uicontrolDialogAssetScr;
var TextBoxHandle num_Txt;

function Initialize()
{
	RewardRichList = GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RewardRichList"));
	num_Txt = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".num_Txt"));
	return;
}

function InitDialogAssets()
{
	uicontrolDialogAssetScr = Class'Interface.UIControlDialogAssets'.static.InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.UIControlDialogAsset")));
	uicontrolDialogAssetScr.SetDisableWindow(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd")));
	uicontrolDialogAssetScr.SetUseNeedItem(true);
	uicontrolDialogAssetScr._SetNeedItemCountAlawaysOne();
	uicontrolDialogAssetScr.DelegateOnCancel = HandleDelegateOnCancel;
	uicontrolDialogAssetScr.DelegateOnClickBuy = HandleDelegateOnClickBuy;
	return;
}

function ShowEmptyText()
{
	uicontrolDialogAssetScr.m_hOwnerWnd.HideWindow();
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.Empty_Txt")).ShowWindow();
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd")).ShowWindow();
	return;
}

function HideEmptyText()
{
	uicontrolDialogAssetScr.m_hOwnerWnd.HideWindow();
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.Empty_Txt")).HideWindow();
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd")).HideWindow();
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(17);
	RegisterEvent(EV_PacketID(1195));
	RegisterEvent(EV_PacketID(1196));
	return;
}

event OnEvent(int Id, string param)
{
	Debug(("ID" @ string(Id)));
	switch(Id)
	{
		case 17:
			HandleTest();
			break;
		case EV_PacketID(1195):
			Rt_S_EX_RAID_AUCTION_POST_ALARM();
			break;
		case EV_PacketID(1196):
			Rt_S_EX_RAID_AUCTION_POST_LIST();
			break;
		default:
			break;
	}
	return;
}

function HandleTest()
{
	RQ_C_EX_RAID_AUCTION_POST_LIST();
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	InitDialogAssets();
	return;
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "RewardBtn":
			HandleCLickRewardBtn();
			break;
		case "CancelBtn":
			HandleClickCancelBtn();
			break;
		case "ReceiveAll_Btn":
			HandleClickReceiveAllBtn();
			break;
		case "refresh_Btn":
			HandleCLickRefreshBtn();
			break;
		default:
			break;
	}
	return;
}

event OnShow()
{
	uicontrolDialogAssetScr.Hide();
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd")).HideWindow();
	m_hOwnerWnd.SetFocus();
	RQ_C_EX_RAID_AUCTION_POST_LIST();
	return;
}

event OnHide()
{
	if((RewardRichList.GetRecordCount() > 0))
	{
		ShowRaidAuction();
	}
	return;
}

event OnEnterState(name a_CurrentStateName)
{
	EnableRefreshBtn();
	return;
}

event OnReceivedCloseUI()
{
	CloseUI();
	return;
}

function HandleCLickRewardBtn()
{
	uicontrolDialogAssetScr.SetUseNeedItem(true);
	uicontrolDialogAssetScr.StartNeedItemList(1);
	uicontrolDialogAssetScr.AddNeedItemClassID(91663, GetCurrentSelectedAmount());
	uicontrolDialogAssetScr.SetDialogDesc(GetSystemString(14914));
	uicontrolDialogAssetScr.SetItemNum(1);
	uicontrolDialogAssetScr.SetDialogID(0);
	uicontrolDialogAssetScr.Show();
	Debug("HandleCLickRewardBtn");
	return;
}

function HandleClickReceiveAllBtn()
{
	uicontrolDialogAssetScr.SetUseNeedItem(true);
	uicontrolDialogAssetScr.StartNeedItemList(1);
	uicontrolDialogAssetScr.AddNeedItemClassID(91663, GetPostFeeAll());
	uicontrolDialogAssetScr.SetDialogDesc(GetSystemString(14916));
	uicontrolDialogAssetScr.SetItemNum(1);
	uicontrolDialogAssetScr.SetDialogID(1);
	uicontrolDialogAssetScr.Show();
	Debug("HandleClickReceiveAllBtn");
	return;
}

function HandleClickCancelBtn()
{
	uicontrolDialogAssetScr.SetUseNeedItem(false);
	uicontrolDialogAssetScr.SetDialogDescHtml(GetSystemString(14915));
	uicontrolDialogAssetScr.SetDialogID(2);
	uicontrolDialogAssetScr.Show();
	Debug("HandleCLickCancelBtn");
	return;
}

function HandleCLickRefreshBtn()
{
	RQ_C_EX_RAID_AUCTION_POST_LIST();
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".refresh_Btn")).DisableWindow();
	Class'Interface.L2UITimer'.static.Inst()._AddTimerOnce(5000)._DelegateOnEnd = EnableRefreshBtn;
	RewardRichList.DeleteAllItem();
	Debug("HandleCLickRefreshBtn");
	return;
}

function EnableRefreshBtn()
{
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".refresh_Btn")).EnableWindow();
	return;
}

function HandleDelegateOnCancel()
{
	uicontrolDialogAssetScr.Hide();
	return;
}

function HandleDelegateOnClickBuy()
{
	uicontrolDialogAssetScr.Hide();
	switch(uicontrolDialogAssetScr.GetDialogID())
	{
		case 0:
			RQ_C_EX_RAID_AUCTION_POST_RECEIVE(true);
			DelRecordByID(GetCurrentSelectedID());
			break;
		case 2:
			RQ_C_EX_RAID_AUCTION_POST_RECEIVE(false);
			DelRecordByID(GetCurrentSelectedID());
			break;
		case 1:
			RQ_C_EX_RAID_AUCTION_POST_RECEIVE_ALL();
			RewardRichList.DeleteAllItem();
			ShowEmptyText();
			SetItemNum();
			break;
		default:
			break;
	}
	return;
}

function RQ_C_EX_RAID_AUCTION_POST_LIST()
{
	Class'Interface.UIPacket'.static.RequestUIPacket(918, _emptyByteArray);
	return;
}

function RQ_C_EX_RAID_AUCTION_POST_RECEIVE(bool bAccept)
{
	local array<byte> stream;
	local UIPacket._C_EX_RAID_AUCTION_POST_RECEIVE packet;

	packet.nID = GetCurrentSelectedID();
	packet.bAccept = byte(int(bAccept));
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_RAID_AUCTION_POST_RECEIVE(stream, packet))
	{
		return;
	}
	Debug((("RQ_C_EX_RAID_AUCTION_POST_RECEIVE" @ string(packet.nID)) @ string(packet.bAccept)));
	Class'Interface.UIPacket'.static.RequestUIPacket(919, stream);
	return;
}

function RQ_C_EX_RAID_AUCTION_POST_RECEIVE_ALL()
{
	Class'Interface.UIPacket'.static.RequestUIPacket(920, _emptyByteArray);
	return;
}

function Rt_S_EX_RAID_AUCTION_POST_LIST()
{
	local array<UIPacket._PkRaidAuctionPost> posts;
	local UIPacket._S_EX_RAID_AUCTION_POST_LIST packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_RAID_AUCTION_POST_LIST(packet))
	{
		return;
	}
	RewardRichList.DeleteAllItem();
	MakeRowDatas(packet.posts);
	return;
}

function Rt_S_EX_RAID_AUCTION_POST_ALARM()
{
	ShowRaidAuction();
	return;
}

function ShowRaidAuction()
{
	NoticeWnd(GetScript("NoticeWnd"))._ShowRaidAuction();
	return;
}

function MakeRowDatas(array<UIPacket._PkRaidAuctionPost> posts)
{
	local RichListCtrlRowData rowData;
	local int i;

	i = 0;
	while((i < posts.Length))
	{
		if(MakeRowData(rowData, posts[i]))
		{
			RewardRichList.InsertRecord(rowData);
		}
		i++;
	}
	SetItemNum();
	if((RewardRichList.GetRecordCount() == 0))
	{
		ShowEmptyText();
	}
	else
	{
		HideEmptyText();
	}
	m_hOwnerWnd.ShowWindow();
	return;
}

function bool MakeRowData(out RichListCtrlRowData outRowData, UIPacket._PkRaidAuctionPost post)
{
	local int ItemID, Type, RemainTime;
	local INT64 Amount;
	local RichListCtrlRowData rowData;
	local ItemInfo iInfo;
	local int nWidth, nHeight;

	outRowData = rowData;
	ItemID = post.nItemClassID;
	Type = post.nType;
	RemainTime = post.nRemainTime;
	Amount = post.nAmount;
	if(!Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(ItemID), iInfo))
	{
		return false;
	}
	rowData.cellDataList.Length = 5;
	rowData.nReserved1 = INT64(post.nPostID);
	rowData.nReserved2 = INT64(API_GetRaidAuctionPostFee());
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "l2ui_ct1.ItemWindow_DF_SlotBox_Default", 36, 36, 0, 1);
	AddRichListCtrlItem(rowData.cellDataList[0].drawitems, iInfo, 32, 32, -34, 2);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, GetItemNameAll(iInfo), GTColor().White, false, 4, 2);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, ("x" $ MakeCostStringINT64(Amount)), GTColor().White, true, 39, 3);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, GetTypeString(Type));
	if((RemainTime < 60))
	{
		AddRichListCtrlString(rowData.cellDataList[2].drawitems, GetStringDayAndTime(RemainTime), GTColor().Red, false);
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[2].drawitems, GetStringDayAndTime(RemainTime), GTColor().White, false);
	}
	if((Type == 1))
	{
		AddRichListCtrlString(rowData.cellDataList[3].drawitems, "-");
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[3].drawitems, MakeCostString(string(rowData.nReserved2)), GetNumericColor(string(rowData.nReserved2)), false, 0, 13);
		AddRichListCtrlNewLine(rowData.cellDataList[3].drawitems);
		addRichListCtrlTexture(rowData.cellDataList[3].drawitems, "L2UI_NewTex.LCoinShopWnd.bm_Lcoin", 30, 30, 80, -23);
	}
	AddRichListCtrlButton(rowData.cellDataList[4].drawitems, "RewardBtn", 0, 0, "L2UI_NewTex.Button.SimpleBtnGreen_DF", "L2UI_NewTex.Button.SimpleBtnGreen_Down", "L2UI_NewTex.Button.SimpleBtnGreen_Over", 90, 30, 90, 30);
	GetTextSizeDefault(GetSystemString(1737), nWidth, nHeight);
	AddRichListCtrlString(rowData.cellDataList[4].drawitems, GetSystemString(1737), GTColor().White, false, (-(90 + nWidth) / 2), ((32 - nHeight) / 2));
	AddRichListCtrlButton(rowData.cellDataList[4].drawitems, "CancelBtn", 38, -8, "L2UI_NewTex.Button.SimpleBtnRed_DF", "L2UI_NewTex.Button.SimpleBtnRed_Down", "L2UI_NewTex.Button.SimpleBtnRed_Over", 90, 30, 90, 30);
	GetTextSizeDefault(GetSystemString(425), nWidth, nHeight);
	AddRichListCtrlString(rowData.cellDataList[4].drawitems, GetSystemString(425), GTColor().White, false, (-(90 + nWidth) / 2), ((32 - nHeight) / 2));
	outRowData = rowData;
	return true;
}

function int API_GetRaidAuctionPostFee()
{
	return GetRaidAuctionPostFee();
}

function SetItemNum()
{
	num_Txt.SetText(((string(RewardRichList.GetRecordCount()) $ "/") $ string(240)));
	return;
}

function DelRecordByID(int Id)
{
	local int i;
	local RichListCtrlRowData rowData;

	i = 0;
	while((i < RewardRichList.GetRecordCount()))
	{
		RewardRichList.GetRec(i, rowData);
		if((rowData.nReserved1 != INT64(Id)))
		{
			i++;
			continue;
		}
		RewardRichList.DeleteRecord(i);
		RewardRichList.SetSelectedIndex(-1, false);
		if((RewardRichList.GetRecordCount() == 0))
		{
			ShowEmptyText();
		}
		SetItemNum();
		return;
		i++;
	}
	return;
}

function int GetCurrentSelectedID()
{
	local RichListCtrlRowData rowData;

	RewardRichList.GetSelectedRec(rowData);
	return int(rowData.nReserved1);
}

function INT64 GetCurrentSelectedAmount()
{
	return GetPostFee(RewardRichList.GetSelectedIndex());
}

function INT64 GetPostFee(int Index)
{
	local RichListCtrlRowData rowData;

	RewardRichList.GetRec(Index, rowData);
	return rowData.nReserved2;
}

function INT64 GetPostFeeAll()
{
	local int i;
	local INT64 amountAll;

	i = 0;
	while((i < RewardRichList.GetRecordCount()))
	{
		(amountAll += GetPostFee(i));
		i++;
	}
	return amountAll;
}

function string GetTypeString(int Type)
{
	switch(Type)
	{
		case 0:
			return GetSystemString(14911);
		case 1:
			return GetSystemString(14913);
		case 2:
			return GetSystemString(14912);
		case 3:
			return GetSystemString(14925);
		default:
	}
}
