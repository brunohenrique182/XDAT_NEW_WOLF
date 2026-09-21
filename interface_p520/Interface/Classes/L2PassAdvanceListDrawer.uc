class L2PassAdvanceListDrawer extends UICommonAPI;

var WindowHandle Me;
var RichListCtrlHandle advanceItemInfoRichList;
var ButtonHandle CloseBtn;

function Initialize()
{
	Me = GetWindowHandle("L2PassAdvanceListDrawer");
	advanceItemInfoRichList = GetRichListCtrlHandle((Me.m_WindowNameWithFullPath $ ".List_ListCtrl"));
	CloseBtn = GetButtonHandle((Me.m_WindowNameWithFullPath $ "CloseButton"));
	advanceItemInfoRichList.SetSelectedSelTooltip(false);
	advanceItemInfoRichList.SetAppearTooltipAtMouseX(true);
	advanceItemInfoRichList.SetSelectable(false);
	return;
}

function _SetAdvanceItemInfo(array<int> EnableList)
{
	local array<L2PassAdvanceData> advanceInfoList;
	local string titleStr;
	local L2PassAdvanceData advanceInfo;
	local RichListCtrlRowData rowData;
	local ItemInfo advanceItemInfo;
	local int i, j, iconWidth, iconHeight, textOffsetX, textOffsetY;
	local Color titleTextColor;
	local L2Util util;

	util = L2Util(GetScript("L2Util"));
	titleTextColor = util.Yellow;
	iconWidth = 32;
	iconHeight = 32;
	textOffsetX = 4;
	textOffsetY = 10;
	advanceItemInfoRichList.DeleteAllItem();
	GetL2PassAdvanceInfo(EnableList, advanceInfoList);
	rowData.cellDataList.Length = 1;
	i = 0;
	while((i < advanceInfoList.Length))
	{
		advanceInfo = advanceInfoList[i];
		titleStr = advanceInfo.AdvanceTypeName;
		util.GetEllipsisString(titleStr, 185);
		advanceItemInfoRichList.InsertRecord(MakeTitleRecord(titleStr, titleTextColor, advanceInfo.Desc));
		j = 0;
		while((j < advanceInfo.arrTargetItem.Length))
		{
			rowData.cellDataList[0].drawitems.Length = 0;
			advanceItemInfo = GetItemInfoByClassID(advanceInfo.arrTargetItem[j]);
			util.GetEllipsisString(advanceItemInfo.Name, 190);
			AddRichListCtrlItem(rowData.cellDataList[0].drawitems, advanceItemInfo);
			AddRichListCtrlString(rowData.cellDataList[0].drawitems, advanceItemInfo.Name, util.White, false, textOffsetX, textOffsetY);
			rowData.nReserved1 = INT64(1);
			rowData.nReserved2 = INT64(advanceInfo.arrTargetItem[j]);
			advanceItemInfoRichList.InsertRecord(rowData);
			j++;
		}
		i++;
	}
	return;
}

function RichListCtrlRowData MakeTitleRecord(string titleStr, Color TextColor, string tooltipStr)
{
	local RichListCtrlRowData Record;

	Record.cellDataList.Length = 1;
	AddRichListCtrlString(Record.cellDataList[0].drawitems, titleStr, TextColor, false, 10, 0, "hs11");
	Record.szReserved = tooltipStr;
	Record.nReserved1 = INT64(0);
	Record.sOverlayTex = "L2UI_EPIC.LCoinShopWnd.CraftListInHeader";
	Record.OverlayTexU = 258;
	Record.OverlayTexV = 50;
	return Record;
}

event OnLoad()
{
	Initialize();
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "CloseButton":
			Me.HideWindow();
			break;
		default:
			break;
	}
	return;
}
