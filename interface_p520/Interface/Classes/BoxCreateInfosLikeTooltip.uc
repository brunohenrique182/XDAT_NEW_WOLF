class BoxCreateInfosLikeTooltip extends UICommonAPI
	dependson(UIPacket);

const ITEMNAME_ICON_WHITESPACE = 70;
const ITEMNAME_HEIGHT = 58;
const LIST_HEIGHT = 28;
const LIST_SHOWROW = 20;

struct CreateItemData
{
	var string Name;
	var string AdditionalName;
	var int NameClass;
	var int Id;
	var int Enchant;
	var INT64 Count;
	var string Prob;
	var int Type;
	var int Group;
	var UIConstants.ERelicGrade Grade;
};

struct CreateItemGroup
{
	var array<CreateItemData> Items;
	var int Type;
	var int Group;
};

var WindowHandle Me;
var RichListCtrlHandle List_ListCtrl;
var ItemWindowHandle Item_ItemWindow;
var HtmlHandle ItemName_HtmlCtrl;
var array<CreateItemData> createItemDataArray;
var array<CreateItemData> fixedItemDataArray;
var array<CreateItemData> addItemDataArray;
var array<CreateItemData> randomItemDataArray;
var array<CreateItemGroup> addItemGroupArray;
var bool bUsePercentColumn;
var int lconX;
var int lconY;
var int clientW;
var int clientH;
var int ClassID;
var int LIST_PERCENT_COLUMN;

function OnRegisterEvent()
{
	RegisterEvent(11555);
	RegisterEvent(11560);
	RegisterEvent(40);
	RegisterEvent(9750);
	RegisterEvent(11650);
	RegisterEvent(11651);
	RegisterEvent(11652);
	RegisterEvent(EV_PacketID(1175));
	return;
}

function OnLoad()
{
	Initialize();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("BoxCreateInfosLikeTooltip");
	List_ListCtrl = GetRichListCtrlHandle(("BoxCreateInfosLikeTooltip" $ ".List_ListCtrl"));
	Item_ItemWindow = GetItemWindowHandle(("BoxCreateInfosLikeTooltip" $ ".Item_ItemWindow"));
	ItemName_HtmlCtrl = GetHtmlHandle(("BoxCreateInfosLikeTooltip" $ ".ItemName_HtmlCtrl"));
	List_ListCtrl.SetSelectedSelTooltip(false);
	List_ListCtrl.SetSelectable(false);
	return;
}

event OnEvent(int a_EventID, string a_Param)
{
	local int ShortcutType;
	local string TooltipType;

	switch(a_EventID)
	{
		case 11555:
			ParseString(a_Param, "TooltipType", TooltipType);
			if((TooltipType == "Skill"))
			{
				return;
			}
			if((TooltipType == "Macro"))
			{
				return;
			}
			if((TooltipType == "Action"))
			{
				return;
			}
			ParseInt(a_Param, "ShortCutType", ShortcutType);
			if((((ShortcutType == 1) || (ShortcutType == 0)) || (ShortcutType == 8)))
			{
				ParseInt(a_Param, "IconX", lconX);
				ParseInt(a_Param, "IconY", lconY);
				ParseInt(a_Param, "clientW", clientW);
				ParseInt(a_Param, "clientH", clientH);
				ParseInt(a_Param, "classID", ClassID);
				requestCreateInfos();
			}
			break;
		case 9750:
		case 40:
		case 11560:
			if(Me.IsShowWindow())
			{
				Me.HideWindow();
			}
			break;
		case 11650:
			createItemDataArray.Length = 0;
			Debug(("EV_StartCreateItemProbList" @ a_Param));
			break;
		case 11651:
			createItemDataArray[createItemDataArray.Length] = getParseStruct(a_Param);
			Debug((" EV_CreateItemProbList" @ a_Param));
			break;
		case 11652:
			Debug(("EV_EndCreateItemProbList" @ string(createItemDataArray.Length)));
			if((createItemDataArray.Length == 0))
			{
				return;
			}
			ShowCreateInfos();
			Me.SetFocus();
			List_ListCtrl.SetFocus();
			break;
		case EV_PacketID(1175):
			Rs_S_EX_RELICS_PROB_LIST();
			break;
		default:
			break;
	}
	return;
}

function Rs_S_EX_RELICS_PROB_LIST()
{
	local UIPacket._S_EX_RELICS_PROB_LIST packet;
	local int i;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_RELICS_PROB_LIST(packet))
	{
		return;
	}
	if((packet.Type == 4))
	{
		createItemDataArray.Length = 0;
		i = 0;
		while((i < packet.relicsProbList.Length))
		{
			createItemDataArray[createItemDataArray.Length] = getParseRelicStruct(packet.relicsProbList[i].nRelicsID, packet.relicsProbList[i].nProb);
			i++;
		}
		if((createItemDataArray.Length == 0))
		{
			return;
		}
		ShowCreateInfos();
		Me.SetFocus();
		List_ListCtrl.SetFocus();
	}
	return;
}

function CreateItemData getParseRelicStruct(int nRelicsID, INT64 nProb)
{
	local CreateItemData cItemData;
	local RelicsMainUIData o_data;

	cItemData.Type = 2;
	cItemData.Group = 0;
	GetRelicsMainData(nRelicsID, o_data);
	cItemData.Name = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(o_data.ItemID));
	cItemData.AdditionalName = Class'NWindow.UIDATA_ITEM'.static.GetItemAdditionalName(GetItemID(o_data.ItemID));
	if(GetSummonRelicShowProb())
	{
		cItemData.Prob = getInstanceL2Util().MakeDecimalPointString(string(nProb), 8, false, true);
	}
	else
	{
		cItemData.Prob = "";
	}
	cItemData.NameClass = Class'NWindow.UIDATA_ITEM'.static.GetItemNameClass(GetItemID(o_data.ItemID));
	cItemData.Grade = ERelicGrade(o_data.Grade);
	cItemData.Enchant = 0;
	cItemData.Count = INT64(1);
	cItemData.Id = o_data.ItemID;
	return cItemData;
}

function CreateItemData getParseStruct(string param)
{
	local CreateItemData cItemData;

	ParseInt(param, "Type", cItemData.Type);
	ParseInt(param, "Group", cItemData.Group);
	ParseString(param, "Name", cItemData.Name);
	ParseString(param, "AdditionalName", cItemData.AdditionalName);
	ParseString(param, "Prob", cItemData.Prob);
	ParseInt(param, "NameClass", cItemData.NameClass);
	ParseInt(param, "ID", cItemData.Id);
	ParseInt(param, "Enchant", cItemData.Enchant);
	ParseINT64(param, "Count", cItemData.Count);
	return cItemData;
}

event OnShow()
{
	ReturnShowXMLDetailTooltip(true);
	return;
}

event OnHide()
{
	return;
}

function requestCreateInfos()
{
	local ItemInfo Info;

	Info = GetItemInfoByClassID(ClassID);
	if(Info.bSimpleExchangeItem)
	{
		ReturnShowXMLDetailTooltip(true);
		Class'Interface.MultiSellItemExchangeWnd'.static.Inst().OpenWindow(Info.Id.ClassID, true);
		return;
	}
	if(Info.IsCreateItem)
	{
		API_C_EX_CREATE_ITEM_PROB_LIST(ClassID);
		return;
	}
	if((Info.EtcItemType == 97))
	{
		API_C_EX_RELICS_PROB_LIST(ClassID);
		return;
	}
	return;
}

function ShowCreateInfos()
{
	local int i, Count, W, h, N, itemNameTextW, OffsetX, toolTipWidth, TooltipHeight;
	local ItemInfo Info;
	local string htmlAdd, titleStr;

	Info = GetItemInfoByClassID(ClassID);
	bUsePercentColumn = true;
	Item_ItemWindow.Clear();
	Item_ItemWindow.AddItem(Info);
	GetTextSize((Info.Name @ Info.AdditionalName), "gameDefault10", itemNameTextW, h);
	htmlAdd = htmlAddText(Info.Name, "gameDefault10", getColorHexString(GTColor().BrightWhite));
	if((Info.AdditionalName != ""))
	{
		htmlAdd = (htmlAdd $ htmlAddText((" " $ Info.AdditionalName), "gameDefault10", getColorHexString(GTColor().Yellow)));
	}
	ItemName_HtmlCtrl.SetWindowSize((itemNameTextW + 20), (h + 4));
	ItemName_HtmlCtrl.LoadHtmlFromString(htmlSetHtmlStart(htmlAdd));
	List_ListCtrl.DeleteAllItem();
	Debug(("info.MaxUseCount" @ string(Info.MaxUseCount)));
	if((Info.MaxUseCount <= 0))
	{
		itemNameTextW = (itemNameTextW + 70);
		toolTipWidth = getWidthSizeWithDivItems();
		Debug(("fixedItemDataArray.length" @ string(fixedItemDataArray.Length)));
		Debug(("addItemGroupArray.length" @ string(addItemGroupArray.Length)));
		Debug(("randomItemDataArray.length" @ string(randomItemDataArray.Length)));
		i = 0;
		while((i < fixedItemDataArray.Length))
		{
			if((i == 0))
			{
				titleStr = GetSystemString(13978);
				List_ListCtrl.InsertRecord(makeTitleListItem(titleStr));
				GetTextSize(titleStr, "gameDefault10", W, h);
				if((toolTipWidth < W))
				{
					toolTipWidth = (W + 5);
				}
				Count++;
			}
			List_ListCtrl.InsertRecord(makeRecord(fixedItemDataArray[i]));
			Count++;
			i++;
		}
		i = 0;
		while((i < addItemGroupArray.Length))
		{
			if((addItemGroupArray.Length == 1))
			{
				titleStr = GetSystemString(13979);
			}
			else
			{
				titleStr = (GetSystemString(13979) @ string(addItemGroupArray[i].Group));
			}
			List_ListCtrl.InsertRecord(makeTitleListItem(titleStr));
			GetTextSize(titleStr, "gameDefault10", W, h);
			if((toolTipWidth < W))
			{
				toolTipWidth = (W + 5);
			}
			Count++;
			N = 0;
			while((N < addItemGroupArray[i].Items.Length))
			{
				List_ListCtrl.InsertRecord(makeRecord(addItemGroupArray[i].Items[N]));
				Count++;
				N++;
			}
			i++;
		}
		i = 0;
		while((i < randomItemDataArray.Length))
		{
			if((i == 0))
			{
				titleStr = GetSystemString(13980);
				List_ListCtrl.InsertRecord(makeTitleListItem(titleStr));
				GetTextSize(titleStr, "gameDefault10", W, h);
				if((toolTipWidth < W))
				{
					toolTipWidth = (W + 5);
				}
				Count++;
			}
			List_ListCtrl.InsertRecord(makeRecord(randomItemDataArray[i]));
			Count++;
			i++;
		}
	}
	else
	{
		itemNameTextW = (itemNameTextW + 70);
		i = 0;
		while((i < createItemDataArray.Length))
		{
			if((i == 0))
			{
				if((createItemDataArray[i].Type == 0))
				{
					titleStr = GetSystemString(13981);
				}
				else
				{
					titleStr = MakeFullSystemMsg(GetSystemMessage(13625), string(createItemDataArray[i].Type));
				}
				GetTextSize(titleStr, "gameDefault10", W, h);
				if((toolTipWidth < W))
				{
					toolTipWidth = (W + 5);
				}
				List_ListCtrl.InsertRecord(makeTitleListItem(titleStr));
				Count++;
			}
			List_ListCtrl.InsertRecord(makeRecord(createItemDataArray[i]));
			toolTipWidth = getMaxWidthInCreateResultItemData(toolTipWidth, createItemDataArray[i]);
			Count++;
			i++;
		}
	}
	if(bUsePercentColumn)
	{
		LIST_PERCENT_COLUMN = 140;
	}
	else
	{
		LIST_PERCENT_COLUMN = 0;
	}
	if((itemNameTextW > (toolTipWidth + LIST_PERCENT_COLUMN)))
	{
		List_ListCtrl.SetColumnWidth(0, (itemNameTextW - LIST_PERCENT_COLUMN));
		List_ListCtrl.SetColumnWidth(1, LIST_PERCENT_COLUMN);
		if((itemNameTextW > toolTipWidth))
		{
			toolTipWidth = itemNameTextW;
		}
	}
	else
	{
		List_ListCtrl.SetColumnWidth(0, toolTipWidth);
		List_ListCtrl.SetColumnWidth(1, LIST_PERCENT_COLUMN);
		toolTipWidth = (toolTipWidth + LIST_PERCENT_COLUMN);
	}
	toolTipWidth = (toolTipWidth + 9);
	if((Count >= 20))
	{
		TooltipHeight = ((28 * 20) + 58);
		Me.SetWindowSize(toolTipWidth, TooltipHeight);
		List_ListCtrl.SetWindowSize((toolTipWidth - 9), (28 * 20));
	}
	else
	{
		TooltipHeight = ((28 * Count) + 58);
		Me.SetWindowSize(((toolTipWidth + 5) + 1), TooltipHeight);
		List_ListCtrl.SetWindowSize(toolTipWidth, (28 * Count));
	}
	if(((lconY - TooltipHeight) < 0))
	{
		lconY = 0;
		OffsetX = 32;
	}
	else
	{
		lconY = (lconY - TooltipHeight);
	}
	if((((lconX + OffsetX) + toolTipWidth) > clientW))
	{
		OffsetX = (OffsetX - (((lconX + OffsetX) + toolTipWidth) - clientW));
	}
	else if(((lconX + OffsetX) < 0))
	{
		lconX = (lconX + OffsetX);
	}
	Me.MoveC((lconX + OffsetX), lconY);
	Me.ShowWindow();
	return;
}

function RichListCtrlRowData makeRecord(CreateItemData boxinfo)
{
	local RichListCtrlRowData rowData;
	local Color applyColor, applyGradeColor;
	local string toolTipParam;

	rowData.cellDataList.Length = 2;
	if((boxinfo.Id > 0))
	{
		rowData.nReserved1 = INT64(boxinfo.Id);
		if((boxinfo.Enchant > 0))
		{
			rowData.nReserved2 = INT64(boxinfo.Enchant);
		}
	}
	rowData.szReserved = toolTipParam;
	if((int(boxinfo.Grade) == 0))
	{
		List_ListCtrl.SetTooltipType("DetailTooltipList");
		applyColor = GetColor(255, 255, 255, 255);
		if((boxinfo.Enchant > 0))
		{
			AddRichListCtrlString(rowData.cellDataList[0].drawitems, (("+" $ string(boxinfo.Enchant)) $ " "), GTColor().Yellow, false, 0, 0, "GameDefault");
		}
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, boxinfo.Name, applyColor, false, 0, 0, "GameDefault");
		if((boxinfo.AdditionalName != ""))
		{
			AddRichListCtrlString(rowData.cellDataList[0].drawitems, (" " $ boxinfo.AdditionalName), GetColor(255, 217, 105, 255), false, 0, 0, "GameDefault");
		}
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, (" x " $ MakeFullSystemMsg(GetSystemMessage(1983), string(boxinfo.Count))), GTColor().White, false, 0, 0, "GameDefault");
		if((((boxinfo.Prob == "") || (boxinfo.Prob == "0%")) || (bUsePercentColumn == false)))
		{
			bUsePercentColumn = false;
			AddRichListCtrlString(rowData.cellDataList[1].drawitems, "", GTColor().White, false, 14, 0, "GameDefault");
		}
		else
		{
			AddRichListCtrlString(rowData.cellDataList[1].drawitems, boxinfo.Prob, GTColor().White, false, 14, 0, "GameDefault");
		}
	}
	else
	{
		List_ListCtrl.SetTooltipType("");
		applyColor = getInstanceL2Util().GetRelicTextColor(boxinfo.Grade);
		applyGradeColor = getInstanceL2Util().GetRelicTextColor(boxinfo.Grade);
		if(getInstanceUIData().GetIsLiveServer())
		{
			if((getInstanceL2Util().GetRelicGradeStringId(boxinfo.Grade) != 0))
			{
				AddRichListCtrlString(rowData.cellDataList[0].drawitems, GetSystemString(getInstanceL2Util().GetRelicGradeStringId(boxinfo.Grade)), applyGradeColor, false, 0, 0, "GameDefault");
			}
		}
		else if((getInstanceL2Util().GetDollGradeStringId(boxinfo.Grade) != 0))
		{
			AddRichListCtrlString(rowData.cellDataList[0].drawitems, GetSystemString(getInstanceL2Util().GetDollGradeStringId(boxinfo.Grade)), applyGradeColor, false, 0, 0, "GameDefault");
		}
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, (" " $ boxinfo.Name), applyColor, false, 0, 0, "GameDefault");
		if((boxinfo.AdditionalName != ""))
		{
			AddRichListCtrlString(rowData.cellDataList[0].drawitems, (" " $ boxinfo.AdditionalName), GetColor(255, 217, 105, 255), false, 0, 0, "GameDefault");
		}
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, (" " $ MakeFullSystemMsg(GetSystemMessage(1983), string(boxinfo.Count))), GTColor().White, false, 0, 0, "GameDefault");
		if((((boxinfo.Prob == "") || (boxinfo.Prob == "0%")) || (bUsePercentColumn == false)))
		{
			bUsePercentColumn = false;
			AddRichListCtrlString(rowData.cellDataList[1].drawitems, "", GTColor().White, false, 14, 0, "GameDefault");
		}
		else
		{
			AddRichListCtrlString(rowData.cellDataList[1].drawitems, boxinfo.Prob, GTColor().White, false, 14, 0, "GameDefault");
		}
	}
	return rowData;
}

function RichListCtrlRowData makeTitleListItem(string Str)
{
	local Color applyColor;
	local RichListCtrlRowData rowData;

	rowData.cellDataList.Length = 1;
	rowData.sOverlayTex = "L2UI_NewTex.ToolTip.TooltipwndListHeader";
	applyColor = GetColor(238, 170, 34, 255);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, Str, applyColor, false, 0, 0, "gameDefault10");
	rowData.OverlayTexU = 256;
	rowData.OverlayTexV = 28;
	return rowData;
}

function int getMaxWidthInCreateResultItemData(int maxTextW, CreateItemData ItemData)
{
	local string AdditionalName, enchantedStr, relicOrDollGrade, countStr, allStr;
	local int W, h;

	if((ItemData.Enchant > 0))
	{
		enchantedStr = (("+" $ string(ItemData.Enchant)) $ " ");
	}
	if((ItemData.AdditionalName != ""))
	{
		AdditionalName = (" " $ ItemData.AdditionalName);
	}
	if(getInstanceUIData().GetIsLiveServer())
	{
		if((getInstanceL2Util().GetRelicGradeStringId(ItemData.Grade) != 0))
		{
			relicOrDollGrade = (GetSystemString(getInstanceL2Util().GetRelicGradeStringId(ItemData.Grade)) $ " ");
		}
	}
	else if((getInstanceL2Util().GetDollGradeStringId(ItemData.Grade) != 0))
	{
		relicOrDollGrade = (GetSystemString(getInstanceL2Util().GetDollGradeStringId(ItemData.Grade)) $ " ");
	}
	countStr = (" " $ MakeFullSystemMsg(GetSystemMessage(1983), string(ItemData.Count)));
	allStr = ((((enchantedStr $ relicOrDollGrade) $ ItemData.Name) $ AdditionalName) $ countStr);
	GetTextSizeDefault(allStr, W, h);
	W = (W + 30);
	if((maxTextW < W))
	{
		maxTextW = W;
	}
	return maxTextW;
}

function int getWidthSizeWithDivItems()
{
	local int i, maxTextW, Len;

	fixedItemDataArray.Length = 0;
	addItemDataArray.Length = 0;
	randomItemDataArray.Length = 0;
	addItemGroupArray.Length = 0;
	i = 0;
	while((i < createItemDataArray.Length))
	{
		switch(createItemDataArray[i].Type)
		{
			case 0:
				fixedItemDataArray.Insert(fixedItemDataArray.Length, 1);
				fixedItemDataArray[(fixedItemDataArray.Length - 1)] = createItemDataArray[i];
				break;
			case 1:
				if((addItemGroupArray.Length == 0))
				{
					addItemGroupArray.Insert(addItemGroupArray.Length, getMaxGroupInArray());
				}
				addItemGroupArray[(createItemDataArray[i].Group - 1)].Group = createItemDataArray[i].Group;
				Len = addItemGroupArray[(createItemDataArray[i].Group - 1)].Items.Length;
				addItemGroupArray[(createItemDataArray[i].Group - 1)].Items.Insert(Len, 1);
				Len = addItemGroupArray[(createItemDataArray[i].Group - 1)].Items.Length;
				addItemGroupArray[(createItemDataArray[i].Group - 1)].Items[(Len - 1)] = createItemDataArray[i];
				break;
			case 2:
				randomItemDataArray.Insert(randomItemDataArray.Length, 1);
				randomItemDataArray[(randomItemDataArray.Length - 1)] = createItemDataArray[i];
				break;
			default:
				break;
		}
		maxTextW = getMaxWidthInCreateResultItemData(maxTextW, createItemDataArray[i]);
		i++;
	}
	return maxTextW;
}

function int getMaxGroupInArray()
{
	local int i, Max;

	i = 0;
	while((i < createItemDataArray.Length))
	{
		if((createItemDataArray[i].Type == 1))
		{
			if((createItemDataArray[i].Group > Max))
			{
				Max = createItemDataArray[i].Group;
			}
		}
		i++;
	}
	return Max;
}

function Color GetNameClassColor(int NameClass)
{
	local Color applyColor;

	switch(NameClass)
	{
		case 0:
			applyColor = GetColor(137, 137, 137, 255);
			break;
		case 2:
			applyColor = GetColor(255, 251, 4, 255);
			break;
		case 3:
			applyColor = GetColor(240, 68, 68, 255);
			break;
		case 4:
			applyColor = GetColor(33, 164, 255, 255);
			break;
		case 5:
			applyColor = GetColor(255, 0, 255, 255);
			break;
		default:
			applyColor = GetColor(255, 255, 255, 255);
			break;
	}
	return applyColor;
}

function API_C_EX_CREATE_ITEM_PROB_LIST(int nClassID)
{
	local array<byte> stream;
	local UIPacket._C_EX_CREATE_ITEM_PROB_LIST packet;

	packet.nClassID = nClassID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_CREATE_ITEM_PROB_LIST(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(895, stream);
	Debug(("API Call C_EX_CREATE_ITEM_PROB_LIST " @ string(nClassID)));
	return;
}

function API_C_EX_RELICS_PROB_LIST(int ItemID)
{
	local array<byte> stream;
	local UIPacket._C_EX_RELICS_PROB_LIST packet;

	packet.Type = 4;
	packet.Key = ItemID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_RELICS_PROB_LIST(stream, packet))
	{
		return;
	}
	Debug((("API_C_EX_RELICS_PROB_LIST" @ string(packet.Type)) @ string(packet.Key)));
	Class'Interface.UIPacket'.static.RequestUIPacket(899, stream);
	return;
}
