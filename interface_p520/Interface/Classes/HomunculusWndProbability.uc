class HomunculusWndProbability extends UICommonAPI
	dependson(UIPacket);

var WindowHandle Me;
var ButtonHandle CloseButton;
var TextBoxHandle Title_TextBox;
var RichListCtrlHandle List_ListCtrl;
var ButtonHandle Close_Btn;

event OnRegisterEvent()
{
	RegisterEvent((100000 + 1008));
	RegisterEvent((100000 + 1009));
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("HomunculusWndProbability");
	Title_TextBox = GetTextBoxHandle("HomunculusWndProbability.Title_TextBox");
	List_ListCtrl = GetRichListCtrlHandle("HomunculusWndProbability.List_ListCtrl");
	Close_Btn = GetButtonHandle("HomunculusWndProbability.Close_BTN");
	CloseButton = GetButtonHandle("HomunculusWndProbability.CloseButton");
	return;
}

function OnShow()
{
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "CloseButton":
			OnCloseButtonClick();
			break;
		case "Close_BTN":
			OnClose_BtnClick();
			break;
		default:
			break;
	}
	return;
}

function OnCloseButtonClick()
{
	Me.HideWindow();
	return;
}

function OnClose_BtnClick()
{
	Me.HideWindow();
	return;
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case (100000 + 1008):
			Handle_S_EX_HOMUNCULUS_CREATE_PROB_LIST();
			break;
		case (100000 + 1009):
			Handle_S_EX_HOMUNCULUS_COUPON_PROB_LIST();
			break;
		default:
			break;
	}
	return;
}

function Handle_S_EX_HOMUNCULUS_CREATE_PROB_LIST()
{
	local UIPacket._S_EX_HOMUNCULUS_CREATE_PROB_LIST packet;
	local HomunculusAPI.HomunculusNpcData npcData;
	local string NpcName, probabilityStr;
	local int i;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_HOMUNCULUS_CREATE_PROB_LIST(packet))
	{
		return;
	}
	Debug(("Handle_S_EX_HOMUNCULUS_CREATE_PROB_LIST" @ string(packet.lstHomunculusProbList.Length)));
	List_ListCtrl.DeleteAllItem();
	i = 0;
	while((i < packet.lstHomunculusProbList.Length))
	{
		npcData = Class'NWindow.HomunculusAPI'.static.GetHomunculusNpcData(packet.lstHomunculusProbList[i].nIndex);
		NpcName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(npcData.NpcID);
		probabilityStr = getInstanceL2Util().MakeDecimalPointString(string(packet.lstHomunculusProbList[i].nProbPerMillion), 6, true, true);
		List_ListCtrl.InsertRecord(makeRecord(NpcName, probabilityStr));
		i++;
	}
	Title_TextBox.SetText(((GetSystemString(13555) $ "-") $ GetSystemString(13960)));
	Me.ShowWindow();
	Me.SetFocus();
	return;
}

function Handle_S_EX_HOMUNCULUS_COUPON_PROB_LIST()
{
	local UIPacket._S_EX_HOMUNCULUS_COUPON_PROB_LIST packet;
	local HomunculusAPI.HomunculusNpcData npcData;
	local string NpcName, ItemName, probabilityStr;
	local int i;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_HOMUNCULUS_COUPON_PROB_LIST(packet))
	{
		return;
	}
	Debug(("Handle_S_EX_HOMUNCULUS_COUPON_PROB_LIST" @ string(packet.lstHomunculusProbList.Length)));
	Debug(("nSlotItemClassID" @ string(packet.nSlotItemClassId)));
	List_ListCtrl.DeleteAllItem();
	i = 0;
	while((i < packet.lstHomunculusProbList.Length))
	{
		npcData = Class'NWindow.HomunculusAPI'.static.GetHomunculusNpcData(packet.lstHomunculusProbList[i].nIndex);
		NpcName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(npcData.NpcID);
		probabilityStr = getInstanceL2Util().MakeDecimalPointString(string(packet.lstHomunculusProbList[i].nProbPerMillion), 6, true, true);
		List_ListCtrl.InsertRecord(makeRecord(NpcName, probabilityStr));
		i++;
	}
	ItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(packet.nSlotItemClassId));
	Title_TextBox.SetText(((ItemName $ "-") $ GetSystemString(13960)));
	Me.ShowWindow();
	Me.SetFocus();
	return;
}

function RichListCtrlRowData makeRecord(string Name, string perStr)
{
	local RichListCtrlRowData rowData;

	rowData.cellDataList.Length = 2;
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, Name, GTColor().White, false, 0, 0);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, perStr, GTColor().White, false, 20, 0);
	return rowData;
}

function API_C_EX_REQ_HOMUNCULUS_PROB_LIST(int nType, optional int nSlotItemClassId)
{
	local array<byte> stream;
	local UIPacket._C_EX_REQ_HOMUNCULUS_PROB_LIST packet;

	packet.nType = nType;
	packet.nSlotItemClassId = nSlotItemClassId;
	Debug((("API_C_EX_REQ_HOMUNCULUS_PROB_LIST" @ string(nType)) @ string(nSlotItemClassId)));
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_REQ_HOMUNCULUS_PROB_LIST(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(773, stream);
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}
