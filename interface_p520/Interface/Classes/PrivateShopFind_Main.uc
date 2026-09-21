class PrivateShopFind_Main extends UICommonAPI
	dependson(UIPacket);

var WindowHandle Me;
var TextBoxHandle Desc01_txt;
var TextBoxHandle Desc03_txt;
var RichListCtrlHandle List01_RichList;
var RichListCtrlHandle List02_RichList;
var PrivateShopFindWnd PrivateShopFindWndScript;
var bool bFirstSetting;

function OnRegisterEvent()
{
	RegisterEvent(9750);
	RegisterEvent(40);
	RegisterEvent((100000 + 981));
	return;
}

function OnLoad()
{
	Initialize();
	return;
}

function OnShow()
{
	if(GetWindowHandle("PrivateShopFindWnd").IsShowWindow())
	{
		Debug("OnShow  PrivateShopFind_Main");
		if((bFirstSetting == false))
		{
			bFirstSetting = true;
			API_C_EX_PRIVATE_STORE_SEARCH_STATISTICS();
		}
	}
	return;
}

function Initialize()
{
	Me = GetWindowHandle("PrivateShopFind_Main");
	Desc01_txt = GetTextBoxHandle("PrivateShopFind_Main.Desc01_txt");
	Desc03_txt = GetTextBoxHandle("PrivateShopFind_Main.Desc03_txt");
	List01_RichList = GetRichListCtrlHandle("PrivateShopFind_Main.List01_RichList");
	List02_RichList = GetRichListCtrlHandle("PrivateShopFind_Main.List02_RichList");
	List01_RichList.SetSelectedSelTooltip(false);
	List01_RichList.SetAppearTooltipAtMouseX(true);
	List01_RichList.SetSelectable(false);
	List02_RichList.SetSelectedSelTooltip(false);
	List02_RichList.SetAppearTooltipAtMouseX(true);
	List02_RichList.SetSelectable(false);
	PrivateShopFindWndScript = PrivateShopFindWnd(GetScript("PrivateShopFindWnd"));
	bFirstSetting = false;
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 9750:
			bFirstSetting = false;
			break;
		case 40:
			bFirstSetting = false;
			break;
		case EV_PacketID(981):
			ParsePacket_S_EX_PRIVATE_STORE_SEARCH_STATISTICS();
			break;
		default:
			break;
	}
	return;
}

function ParsePacket_S_EX_PRIVATE_STORE_SEARCH_STATISTICS()
{
	local UIPacket._S_EX_PRIVATE_STORE_SEARCH_STATISTICS packet;
	local ItemInfo Info;
	local int i;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_PRIVATE_STORE_SEARCH_STATISTICS(packet))
	{
		return;
	}
	Debug(((" -->  Decode_S_EX_PRIVATE_STORE_SEARCH_STATISTICS :  " @ string(packet.mostItems.Length)) @ string(packet.highestItems.Length)));
	List01_RichList.DeleteAllItem();
	i = 0;
	while((i < packet.mostItems.Length))
	{
		RequestDisassembleItemInfo(packet.mostItems[i].itemAssemble, Info);
		addRichListItemAmount((i + 1), Info.Id.ClassID, Info.ItemNum, INT64(packet.mostItems[i].nCount));
		i++;
	}
	List02_RichList.DeleteAllItem();
	i = 0;
	while((i < packet.highestItems.Length))
	{
		RequestDisassembleItemInfo(packet.highestItems[i].itemAssemble, Info);
		addRichListItemPrice((i + 1), Info, Info.ItemNum, packet.highestItems[i].nPrice);
		i++;
	}
	return;
}

function addRichListItemAmount(int Rank, int ClassID, INT64 Amount, INT64 dealCount)
{
	local RichListCtrlRowData rowData;
	local ItemInfo Info;

	Info = GetItemInfoByClassID(ClassID);
	rowData.cellDataList.Length = 3;
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, string(Rank), GTColor().White, false, 0, 0);
	AddRichListCtrlItem(rowData.cellDataList[1].drawitems, Info, 32, 32, 4, 2, "noTooltip");
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, GetItemNameAll(Info), GTColor().White, false, 4, 9);
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, MakeCostStringINT64(dealCount), GTColor().White, false, 0, 0);
	List01_RichList.InsertRecord(rowData);
	return;
}

function addRichListItemPrice(int Rank, ItemInfo Info, INT64 Amount, INT64 adenaPrice)
{
	local RichListCtrlRowData rowData;

	rowData.cellDataList.Length = 3;
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, string(Rank), GTColor().White, false, 0, 0);
	AddRichListCtrlItem(rowData.cellDataList[1].drawitems, Info, 32, 32, 4, 2, "noTooltip");
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, GetItemNameAll(Info), GTColor().White, false, 4, 2);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, ("x" $ MakeCostStringINT64(Amount)), GTColor().White, true, 40, 2);
	addRichListCtrlTexture(rowData.cellDataList[2].drawitems, "L2UI_EPIC.RestartMenuWnd.Icon_Adena", 18, 13, 156, 10);
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, "", GTColor().White, true, 0, 0);
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, ConvertNumToTextNoAdena(string(adenaPrice)), GetNumericColor(MakeCostStringINT64(adenaPrice)), false, 0, -14);
	List02_RichList.InsertRecord(rowData);
	return;
}

function API_C_EX_PRIVATE_STORE_SEARCH_STATISTICS()
{
	local array<byte> stream;

	Class'Interface.UIPacket'.static.RequestUIPacket(742, stream);
	Debug("api Call : C_EX_PRIVATE_STORE_SEARCH_STATISTICS");
	return;
}
