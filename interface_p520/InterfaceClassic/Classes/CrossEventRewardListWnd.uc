class CrossEventRewardListWnd extends UICommonAPI
	dependson(UIPacket);

var WindowHandle Me;
var RichListCtrlHandle RichListCtrl;

static function CrossEventRewardListWnd Inst()
{
	return CrossEventRewardListWnd(GetScript("CrossEventRewardListWnd"));
}

function Initialize()
{
	InitControls();
	return;
}

function InitControls()
{
	local string ownerFullPath;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	RichListCtrl = GetRichListCtrlHandle((ownerFullPath $ ".CrossRewardList_ListCtrl"));
	RichListCtrl.SetSelectable(false);
	RichListCtrl.SetSelectedSelTooltip(false);
	RichListCtrl.SetAppearTooltipAtMouseX(true);
	RichListCtrl.SetTooltipType("SellItemList");
	Me = GetWindowHandle(ownerFullPath);
	return;
}

function SetInfo(array<UIPacket._ItemInfo> rareRewards)
{
	local int i;
	local RichListCtrlRowData rowData;
	local UIPacket._ItemInfo RewardItemInfo;
	local ItemInfo tempItemInfo;
	local L2Util util;
	local string itemNameStr, countStr, itemParam;
	local int textWidth, textHeight;

	util = L2Util(GetScript("L2Util"));
	RichListCtrl.DeleteAllItem();
	rowData.cellDataList.Length = 1;
	i = 0;
	while((i < rareRewards.Length))
	{
		rowData.cellDataList[0].drawitems.Length = 0;
		RewardItemInfo = rareRewards[i];
		tempItemInfo = GetItemInfoByClassID(RewardItemInfo.nItemClassID);
		tempItemInfo.ItemNum = RewardItemInfo.nAmount;
		ItemInfoToParam(tempItemInfo, itemParam);
		rowData.szReserved = itemParam;
		countStr = (" x" $ MakeCostString(string(RewardItemInfo.nAmount)));
		GetTextSizeDefault(countStr, textWidth, textHeight);
		itemNameStr = GetItemNameAll(tempItemInfo);
		Class'InterfaceClassic.L2Util'.static.GetEllipsisString(itemNameStr, (286 - textWidth));
		AddRichListCtrlItem(rowData.cellDataList[0].drawitems, tempItemInfo, 24, 24, 2, 2);
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, (itemNameStr $ countStr), util.White, false, 8, 4);
		RichListCtrl.InsertRecord(rowData);
		i++;
	}
	return;
}

function ShowWnd()
{
	RichListCtrl.SetSelectedIndex(0, true);
	RichListCtrl.SetSelectedIndex(-1, false);
	Me.ShowWindow();
	return;
}

function CloseWnd()
{
	Me.HideWindow();
	return;
}

function ToggleShowWnd()
{
	if(Me.IsShowWindow())
	{
		CloseWnd();
	}
	else
	{
		ShowWnd();
	}
	return;
}

event OnClickButton(string btnName)
{
	if((btnName == "CloseButton"))
	{
		CloseWnd();
	}
	return;
}

event OnLoad()
{
	Initialize();
	return;
}
