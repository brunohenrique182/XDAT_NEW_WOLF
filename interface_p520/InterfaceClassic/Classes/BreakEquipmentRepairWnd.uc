class BreakEquipmentRepairWnd extends UICommonAPI
	dependson(UIPacket);

var WindowHandle Me;
var WindowHandle UIControlDialogAsset;
var UIControlDialogAssets popupExpandScript;

function OnRegisterEvent()
{
	RegisterEvent((100000 + 1198));
	return;
}

function OnLoad()
{
	Initialize();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("BreakEquipmentRepairWnd");
	UIControlDialogAsset = GetWindowHandle("BreakEquipmentRepairWnd.UIControlDialogAsset");
	SetPopupScript();
	return;
}

function OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)), "InventoryWnd");
	return;
}

function SetPopupScript()
{
	local WindowHandle popupExpandWnd;

	popupExpandWnd = GetWindowHandle("BreakEquipmentRepairWnd.UIControlDialogAsset");
	popupExpandScript = Class'InterfaceClassic.UIControlDialogAssets'.static.InitScript(popupExpandWnd);
	return;
}

function OnEvent(int Event_ID, string a_Param)
{
	if((Event_ID == (100000 + 1198)))
	{
		ParsePacket_S_EX_REPAIR_ALL_EQUIPMENT();
	}
	return;
}

function OnHide()
{
	GetPopupExpandScript().Hide();
	return;
}

function DialogWndOpen(int nItemNum)
{
	local int costItemID, CostItemAmount, nResizeHeight;
	local bool bHasNeedItem;

	bHasNeedItem = GetEquipmentBreakRestoreCost(nItemNum, costItemID, CostItemAmount);
	if(((nItemNum > 0) && bHasNeedItem))
	{
		popupExpandScript.SetUseNeedItem(true);
		popupExpandScript.StartNeedItemList(1);
		popupExpandScript.AddNeedItemClassID(costItemID, INT64(CostItemAmount));
		popupExpandScript.SetItemNum(1);
		nResizeHeight = 224;
	}
	else if(((nItemNum <= 0) || (bHasNeedItem == false)))
	{
		popupExpandScript.SetUseNeedItem(false);
		nResizeHeight = 160;
	}
	popupExpandScript.SetDialogDesc(((((GetSystemString(14894) $ "\\n\\n") $ GetSystemString(14897)) $ " : ") $ string(nItemNum)));
	popupExpandScript.Show();
	popupExpandScript.DelegateOnCancel = OnClickPopupCancel;
	popupExpandScript.DelegateOnClickBuy = OnClickPopupBuy;
	Me.SetWindowSize(430, nResizeHeight);
	Me.ShowWindow();
	Me.SetFocus();
	return;
}

function UIControlDialogAssets GetPopupExpandScript()
{
	local WindowHandle popExpandWnd;

	popExpandWnd = GetWindowHandle("BreakEquipmentRepairWnd.UIControlDialogAsset");
	return UIControlDialogAssets(popExpandWnd.GetScript());
}

function OnClickPopupBuy()
{
	API_C_EX_REPAIR_ALL_EQUIPMENT();
	Me.HideWindow();
	return;
}

function OnClickPopupCancel()
{
	Me.HideWindow();
	return;
}

function API_C_EX_REPAIR_ALL_EQUIPMENT()
{
	local array<byte> stream;
	local UIPacket._C_EX_REPAIR_ALL_EQUIPMENT packet;

	if(Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_REPAIR_ALL_EQUIPMENT(stream, packet))
	{
		Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(921, stream);
	}
	Debug("Api call : C_EX_REPAIR_ALL_EQUIPMENT");
	return;
}

function ParsePacket_S_EX_REPAIR_ALL_EQUIPMENT()
{
	local UIPacket._S_EX_REPAIR_ALL_EQUIPMENT packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_REPAIR_ALL_EQUIPMENT(packet))
	{
		return;
	}
	Debug(("---> S_EX_REPAIR_ALL_EQUIPMENT" @ string(packet.cResult)));
	if((packet.cResult == 1))
	{
		BreakEquipmentNotice(GetScript("BreakEquipmentNotice")).fixIt();
		AddSystemMessage(14578);
	}
	else if((packet.cResult == 2))
	{
		AddSystemMessage(14579);
	}
	else
	{
		AddSystemMessage(14580);
	}
	return;
}
