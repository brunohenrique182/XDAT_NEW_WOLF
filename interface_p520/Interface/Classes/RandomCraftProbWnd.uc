class RandomCraftProbWnd extends UICommonAPI
	dependson(UIPacket);

const SLOT_MAX = 5;

struct probInfo
{
	var int SlotIndex;
	var array<UIPacket._CraftItemInfo> craftItemInfos;
};

var int currentSlot;
var array<probInfo> probInfos;

event OnLoad()
{
	probInfos.Length = 5;
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(1172));
	RegisterEvent(9750);
	return;
}

event OnEvent(int enventID, string param)
{
	switch(enventID)
	{
		case EV_PacketID(1172):
			RT_S_EX_CRAFT_SLOT_PROB_LIST();
			break;
		case 9750:
			RQ_C_EX_CRAFT_SLOT_PROB_LIST_ALL();
			break;
		default:
			break;
	}
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "NextBtn":
			SetCurrentSlot((currentSlot + 1));
			break;
		case "PrevBtn":
			SetCurrentSlot((currentSlot - 1));
			break;
		case "Close_btn":
			m_hOwnerWnd.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function SetCurrentSlot(int SlotNum)
{
	currentSlot = SlotNum;
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".NextBtn")).EnableWindow();
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".PrevBtn")).EnableWindow();
	if((currentSlot == 0))
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".PrevBtn")).DisableWindow();
	}
	else if((currentSlot == (5 - 1)))
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".NextBtn")).DisableWindow();
	}
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SlotNameText")).SetText(MakeFullSystemMsg(GetSystemMessage(14028), string((currentSlot + 1))));
	MakeList();
	return;
}

function MakeList()
{
	local int i;
	local RichListCtrlHandle List;

	List = GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AdenLabBossOptionProb_List"));
	List.SetAppearTooltipAtMouseX(true);
	List.SetSelectedSelTooltip(false);
	List.SetSelectable(false);
	List.DeleteAllItem();
	i = 0;
	while((i < probInfos[currentSlot].craftItemInfos.Length))
	{
		List.InsertRecord(MakeRowData(i));
		i++;
	}
	return;
}

function RichListCtrlRowData MakeRowData(int Index)
{
	local RichListCtrlRowData rowData;
	local string ItemName, ItemCount, probString;

	rowData.cellDataList.Length = 3;
	ItemName = GetItemNameAllByClassID(probInfos[currentSlot].craftItemInfos[Index].nItemID);
	ItemCount = string(probInfos[currentSlot].craftItemInfos[Index].nItemCount);
	probString = Class'Interface.L2Util'.static.Inst().MakeDecimalPointString(string(probInfos[currentSlot].craftItemInfos[Index].nProb), 6, true, true);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, ItemName, , , , , , true, ItemName);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, ItemCount);
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, probString);
	return rowData;
}

function RQ_C_EX_CRAFT_SLOT_PROB_LIST_ALL()
{
	local int i;

	if(getInstanceUIData().GetIsLiveServer())
	{
		return;
	}
	i = 0;
	while((i < 5))
	{
		RQ_C_EX_CRAFT_SLOT_PROB_LIST(i);
		i++;
	}
	return;
}

function RQ_C_EX_CRAFT_SLOT_PROB_LIST(int SlotIndex)
{
	local array<byte> stream;
	local UIPacket._C_EX_CRAFT_SLOT_PROB_LIST packet;

	packet.nSlot = SlotIndex;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_CRAFT_SLOT_PROB_LIST(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(896, stream);
	return;
}

function RT_S_EX_CRAFT_SLOT_PROB_LIST()
{
	local UIPacket._S_EX_CRAFT_SLOT_PROB_LIST packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_CRAFT_SLOT_PROB_LIST(packet))
	{
		return;
	}
	Debug((("RT_S_EX_CRAFT_SLOT_PROB_LIST" @ string(packet.nSlot)) @ string(packet.craftItems.Length)));
	probInfos[packet.nSlot].craftItemInfos = packet.craftItems;
	if((packet.nSlot == 0))
	{
		SetCurrentSlot(0);
	}
	return;
}
