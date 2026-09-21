class PetExtractWnd extends UICommonAPI
	dependson(UIPacket);

var WindowHandle Me;
var WindowHandle disableWnd;
var WindowHandle resultWnd;
var AnimTextureHandle ResulteEffect_ani;
var ButtonHandle ResultWnd_btn;
var TextBoxHandle ResultWndSlotDesc_txt;
var ItemWindowHandle ResultWndItemSlot_ItemWnd;
var WindowHandle ChargeWnd;
var ItemWindowHandle InventoryWnd_ItemWnd;
var WindowHandle PetExtractSlot1_wnd;
var ItemWindowHandle PetExtractSlot1_ItemWindow;
var TextureHandle PetExtractWndSlot1_Active;
var WindowHandle PetExtractSlot2_wnd;
var ItemWindowHandle PetExtractSlot2_ItemWindow;
var TextureHandle PetExtractWndSlot2_Active;
var AnimTextureHandle PetExtractEffect_ani;
var ButtonHandle PetExtract_Btn;
var ButtonHandle PetReset_Btn;
var TextureHandle PetExtractSlotArrow_Tex;
var ProgressCtrlHandle PetExtractProgress;
var bool isProgress;
var ItemInfo selectedPetItemInfo;
var PetExtractInfo ExtractInfo;
var INT64 ResultItemNum;

function OnRegisterEvent()
{
	RegisterEvent((100000 + 893));
	RegisterEvent((100000 + 895));
	RegisterEvent((100000 + 894));
	RegisterEvent(9570);
	RegisterEvent(2070);
	RegisterEvent(40);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	Load();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("PetExtractWnd");
	disableWnd = GetWindowHandle("PetExtractWnd.DisableWnd");
	resultWnd = GetWindowHandle("PetExtractWnd.ResultWnd");
	ResulteEffect_ani = GetAnimTextureHandle("PetExtractWnd.ResultWnd.ResulteEffect_ani");
	PetExtractEffect_ani = GetAnimTextureHandle("PetExtractWnd.PetExtractEffect_ani");
	ResultWnd_btn = GetButtonHandle("PetExtractWnd.ResultWnd.ResultWnd_btn");
	ResultWndSlotDesc_txt = GetTextBoxHandle("PetExtractWnd.ResultWnd.ResultWndSlotDesc_txt");
	ResultWndItemSlot_ItemWnd = GetItemWindowHandle("PetExtractWnd.ResultWnd.ResultWndItemSlot_ItemWnd");
	ChargeWnd = GetWindowHandle("PetExtractWnd.ChargeWnd");
	InventoryWnd_ItemWnd = GetItemWindowHandle("PetExtractWnd.ExtractInventoryWnd.InventoryWnd_ItemWnd");
	PetExtractSlot1_wnd = GetWindowHandle("PetExtractWnd.PetExtractSlot1_wnd");
	PetExtractSlot1_ItemWindow = GetItemWindowHandle("PetExtractWnd.PetExtractSlot1_wnd.PetExtractSlot_ItemWindow");
	PetExtractWndSlot1_Active = GetTextureHandle("PetExtractWnd.PetExtractSlot1_wnd.PetExtractWndSlot_Active");
	PetExtractSlot2_wnd = GetWindowHandle("PetExtractWnd.PetExtractSlot2_wnd");
	PetExtractSlot2_ItemWindow = GetItemWindowHandle("PetExtractWnd.PetExtractSlot2_wnd.PetExtractSlot_ItemWindow");
	PetExtractWndSlot2_Active = GetTextureHandle("PetExtractWnd.PetExtractSlot2_wnd.PetExtractWndSlot_Active");
	PetExtractSlotArrow_Tex = GetTextureHandle("PetExtractWnd.PetExtractSlotArrow_Tex");
	PetExtract_Btn = GetButtonHandle("PetExtractWnd.PetExtract_Btn");
	PetReset_Btn = GetButtonHandle("PetExtractWnd.PetReset_Btn");
	PetExtractProgress = GetProgressCtrlHandle("PetExtractWnd.PetExtractProgress");
	PetExtractProgress.SetProgressTime(100);
	return;
}

function Load()
{
	return;
}

function OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	syncPetItemInven();
	isProgress = false;
	GotoState('SelectPetItemState');
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "ResultWnd_btn":
		case "PetReset_Btn":
			GotoState('SelectPetItemState');
			break;
		case "PetExtract_Btn":
			OnPetExtract_BtnClick();
			break;
		default:
			break;
	}
	return;
}

function OnPetExtract_BtnClick()
{
	if(isProgress)
	{
		PetExtract_Btn.SetNameText(GetSystemString(13444));
		PetExtractEffect_ani.Stop();
		PetExtractEffect_ani.HideWindow();
		PetExtractProgress.SetPos(0);
		PetExtractProgress.Reset();
		isProgress = false;
		PetExtractSlotArrow_Tex.ShowWindow();
		PetReset_Btn.EnableWindow();
		GetTextBoxHandle("PetExtractWnd.PetExtract_Desc_txt").SetText(GetSystemString(13447));
	}
	else
	{
		PetExtractEffect_ani.ShowWindow();
		PetExtractEffect_ani.Stop();
		PetExtractEffect_ani.Play();
		PetExtractProgress.SetProgressTime(1500);
		PetExtractProgress.SetPos(0);
		PetExtractProgress.Reset();
		PetExtractProgress.Start();
		isProgress = true;
		PetExtractSlotArrow_Tex.HideWindow();
		PetExtract_Btn.SetNameText(GetSystemString(141));
		PetReset_Btn.DisableWindow();
		GetTextBoxHandle("PetExtractWnd.PetExtract_Desc_txt").SetText(GetSystemString(13449));
	}
	return;
}

function OnProgressTimeUp(string strID)
{
	Debug(("strID" @ strID));
	if((strID == "PetExtractProgress"))
	{
		if(Me.IsShowWindow())
		{
			API_C_EX_TRY_PET_EXTRACT_SYSTEM(selectedPetItemInfo.Id.ServerID);
		}
	}
	return;
}

function syncPetItemInven()
{
	local array<ItemInfo> itemarray;
	local int i;

	InventoryWnd_ItemWnd.Clear();
	GetObjectFindItemByCompare().DelegateCompare = petItemCompare;
	itemarray = GetObjectFindItemByCompare().GetAllItemByCompare();
	i = 0;
	while((i < itemarray.Length))
	{
		InventoryWnd_ItemWnd.AddItem(itemarray[i]);
		i++;
	}
	return;
}

function bool petItemCompare(ItemInfo item)
{
	local PetExtractInfo invenExtractInfo;
	local bool bFlag;

	if((int(byte(item.EtcItemType)) == 7))
	{
		if((item.PetExp <= INT64(0)))
		{
			return false;
		}
		bFlag = Class'NWindow.PetAPI'.static.GetPetExtractInfo(item.PetID, item.Enchanted, invenExtractInfo);
		if(bFlag)
		{
			return true;
		}
	}
	return false;
}

function bool setNeedCost(int SlotIndex, int ItemID, INT64 ItemCount)
{
	local TextBoxHandle myCostText, needCostText;
	local ItemWindowHandle CostItemWindow;
	local TextureHandle CostIconBg_Texture;
	local INT64 itemCountMine;
	local ItemInfo CostItem;
	local bool bEnable;

	needCostText = GetTextBoxHandle((("PetExtractWnd.ChargeWnd.Cost0" $ string(SlotIndex)) $ "_Txt"));
	myCostText = GetTextBoxHandle((("PetExtractWnd.ChargeWnd.MyCost0" $ string(SlotIndex)) $ "_Txt"));
	CostItemWindow = GetItemWindowHandle((("PetExtractWnd.ChargeWnd.CostIcon0" $ string(SlotIndex)) $ "_ItemWindow"));
	CostIconBg_Texture = GetTextureHandle((("PetExtractWnd.ChargeWnd.CostSlot0" $ string(SlotIndex)) $ "_Tex"));
	if((ItemID > 0))
	{
		CostItem = GetItemInfoByClassID(ItemID);
		needCostText.SetText(("x" $ MakeCostString(string(ItemCount))));
		CostIconBg_Texture.ShowWindow();
		CostItemWindow.ShowWindow();
		CostItemWindow.Clear();
		CostItemWindow.AddItem(CostItem);
		itemCountMine = GetInstanceL2UIInventory().GetInventoryItemCount(GetItemID(ItemID));
		myCostText.SetText((("(" $ MakeCostString(string(itemCountMine))) $ ")"));
		if((ItemCount > itemCountMine))
		{
			myCostText.SetTextColor(GTColor().DRed);
			bEnable = false;
		}
		else
		{
			myCostText.SetTextColor(GTColor().BLUE01);
			bEnable = true;
		}
	}
	else
	{
		needCostText.SetText("");
		myCostText.SetText("");
		CostItemWindow.HideWindow();
		CostItemWindow.Clear();
		CostIconBg_Texture.HideWindow();
	}
	return bEnable;
}

function clearNeedCost()
{
	setNeedCost(1, 0, INT64(0));
	setNeedCost(2, 0, INT64(0));
	return;
}

function OnClickItem(string strID, int Index)
{
	Debug((("strID" @ strID) @ string(Index)));
	InventoryWnd_ItemWnd.GetSelectedItem(selectedPetItemInfo);
	if((selectedPetItemInfo.Id.ClassID > 0))
	{
		Debug(("선택" @ string(selectedPetItemInfo.Id.ClassID)));  // EN?: Optional
		Debug(("선택 selectedPetItemInfo.PetID" @ string(selectedPetItemInfo.PetID)));  // EN?: selectedPetItemInfo.PetID
		PetExtractSlot1_ItemWindow.Clear();
		PetExtractSlot1_ItemWindow.AddItem(selectedPetItemInfo);
		GotoState('TryPetExtractState');
	}
	return;
}

function refreshNeedItem()
{
	local bool bCheckExtract1, bCheckExtract2;

	Class'NWindow.PetAPI'.static.GetPetExtractInfo(selectedPetItemInfo.PetID, selectedPetItemInfo.Enchanted, ExtractInfo);
	Debug(("selectedPetItemInfo.PetID" @ string(selectedPetItemInfo.PetID)));
	Debug(("ExtractInfo.ExtractItemClassID" @ string(ExtractInfo.ExtractItemClassID)));
	PetExtractSlot2_ItemWindow.Clear();
	PetExtractSlot2_ItemWindow.AddItem(GetItemInfoByClassID(ExtractInfo.ExtractItemClassID));
	ResultItemNum = (selectedPetItemInfo.PetExp / ExtractInfo.ExtractExp);
	GetTextBoxHandle("PetExtractWnd.PetExtractSlot2_wnd.PetExtractWndSlotDesc_txt").SetText(("x" $ MakeCostString(string(ResultItemNum))));
	Debug(("selectedPetItemInfo.PetExp : " @ string(selectedPetItemInfo.PetExp)));
	Debug(("ExtractExp : " @ string(ExtractInfo.ExtractExp)));
	clearNeedCost();
	bCheckExtract1 = setNeedCost(1, ExtractInfo.DefaultExtractCost.Id, ExtractInfo.DefaultExtractCost.Amount);
	bCheckExtract2 = setNeedCost(2, ExtractInfo.ExtractCost.Id, (ExtractInfo.ExtractCost.Amount * ResultItemNum));
	if((bCheckExtract1 && bCheckExtract2))
	{
		GetTextBoxHandle("PetExtractWnd.ChargeWnd.ChargeWndDesc_txt").SetText(GetSystemString(13445));
		PetExtract_Btn.EnableWindow();
	}
	else
	{
		GetTextBoxHandle("PetExtractWnd.ChargeWnd.ChargeWndDesc_txt").SetText(GetSystemString(13448));
		PetExtract_Btn.DisableWindow();
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 9750:
			break;
		case EV_PacketID(893):
			Debug("event -> S_EX_SHOW_PET_EXTRACT_SYSTEM");
			Me.ShowWindow();
			Me.SetFocus();
			break;
		case EV_PacketID(895):
			Me.HideWindow();
			Debug("event -> S_EX_HIDE_PET_EXTRACT_SYSTEM");
			break;
		case EV_PacketID(894):
			ParsePacket_S_EX_RESULT_PET_EXTRACT_SYSTEM();
			break;
		case 9570:
		case 2070:
			if((Me.IsShowWindow() && IsInState('TryPetExtractState')))
			{
				refreshNeedItem();
			}
			break;
		case 40:
			InventoryWnd_ItemWnd.Clear();
			break;
		default:
			break;
	}
	return;
}

function ParsePacket_S_EX_RESULT_PET_EXTRACT_SYSTEM()
{
	local UIPacket._S_EX_RESULT_PET_EXTRACT_SYSTEM packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_RESULT_PET_EXTRACT_SYSTEM(packet))
	{
		return;
	}
	Debug((" -->  Decode_S_EX_RESULT_PET_EXTRACT_SYSTEM :  " @ string(packet.bSuccess)));
	if((int(packet.bSuccess) > 0))
	{
		GotoState('ResultExtractState');
	}
	else
	{
		Me.HideWindow();
	}
	return;
}

function API_C_EX_TRY_PET_EXTRACT_SYSTEM(int nPetItemSID)
{
	local array<byte> stream;
	local UIPacket._C_EX_TRY_PET_EXTRACT_SYSTEM packet;

	packet.nPetItemSID = nPetItemSID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_TRY_PET_EXTRACT_SYSTEM(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(669, stream);
	Debug(("----> Api Call : C_EX_TRY_PET_EXTRACT_SYSTEM" @ string(nPetItemSID)));
	return;
}

function OnReceivedCloseUI()
{
	if(isProgress)
	{
		OnPetExtract_BtnClick();
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	}
	return;
}

state SelectPetItemState
{
	function BeginState()
	{
		disableWnd.HideWindow();
		resultWnd.HideWindow();
		PetReset_Btn.HideWindow();
		GetWindowHandle("PetExtractWnd.ExtractInventoryWnd").ShowWindow();
		InventoryWnd_ItemWnd.ShowWindow();
		ChargeWnd.HideWindow();
		PetExtract_Btn.HideWindow();
		GetTextBoxHandle("PetExtractWnd.PetExtract_Desc_txt").SetText(GetSystemString(13446));
		PetExtractSlot1_wnd.ShowWindow();
		PetExtractSlot2_wnd.HideWindow();
		PetExtractWndSlot1_Active.ShowWindow();
		PetExtractWndSlot2_Active.HideWindow();
		ResulteEffect_ani.Stop();
		ResulteEffect_ani.HideWindow();
		PetExtractEffect_ani.Stop();
		PetExtractEffect_ani.HideWindow();
		PetExtractEffect_ani.Stop();
		PetExtractEffect_ani.HideWindow();
		PetExtractSlot1_ItemWindow.Clear();
		syncPetItemInven();
		if(isProgress)
		{
			OnPetExtract_BtnClick();
		}
		PetExtractSlotArrow_Tex.HideWindow();
		return;
	}
}

state TryPetExtractState
{
	function BeginState()
	{
		isProgress = false;
		PetExtract_Btn.SetNameText(GetSystemString(13444));
		PetExtractEffect_ani.Stop();
		PetExtractEffect_ani.HideWindow();
		PetExtractSlotArrow_Tex.ShowWindow();
		GetTextBoxHandle("PetExtractWnd.PetExtract_Desc_txt").SetText(GetSystemString(13447));
		PetReset_Btn.ShowWindow();
		PetReset_Btn.EnableWindow();
		GetWindowHandle("PetExtractWnd.ExtractInventoryWnd").HideWindow();
		InventoryWnd_ItemWnd.HideWindow();
		ChargeWnd.ShowWindow();
		PetExtract_Btn.ShowWindow();
		PetExtractSlot1_wnd.ShowWindow();
		PetExtractSlot2_wnd.ShowWindow();
		PetExtractWndSlot1_Active.HideWindow();
		PetExtractWndSlot2_Active.ShowWindow();
		ResulteEffect_ani.Stop();
		ResulteEffect_ani.HideWindow();
		refreshNeedItem();
		return;
	}
}

state ResultExtractState
{
	function BeginState()
	{
		disableWnd.ShowWindow();
		disableWnd.SetFocus();
		resultWnd.ShowWindow();
		resultWnd.SetFocus();
		PetReset_Btn.ShowWindow();
		PetReset_Btn.EnableWindow();
		ResulteEffect_ani.ShowWindow();
		ResulteEffect_ani.Stop();
		ResulteEffect_ani.Play();
		ResultWndSlotDesc_txt.SetText(("x" $ MakeCostString(string(ResultItemNum))));
		ResultWndItemSlot_ItemWnd.Clear();
		ResultWndItemSlot_ItemWnd.AddItem(GetItemInfoByClassID(ExtractInfo.ExtractItemClassID));
		return;
	}
}
