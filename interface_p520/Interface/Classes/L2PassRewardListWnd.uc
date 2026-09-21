class L2PassRewardListWnd extends UICommonAPI;

var WindowHandle Me;
var RichListCtrlHandle rewardNormalRichList;
var RichListCtrlHandle rewardPremiumRichList;
var ButtonHandle confirmBtn;
var L2PassWnd parentWnd;
var TextBoxHandle TitleTextBox;
var L2PassData _l2PassData;

function Init(WindowHandle Owner, L2PassWnd Parent)
{
	local string ownerFullPath;

	ownerFullPath = Owner.m_WindowNameWithFullPath;
	parentWnd = Parent;
	Me = GetWindowHandle(ownerFullPath);
	_l2PassData = new Class'Interface.L2PassData';
	rewardNormalRichList = GetRichListCtrlHandle((ownerFullPath $ ".List0_ListCtrl"));
	rewardPremiumRichList = GetRichListCtrlHandle((ownerFullPath $ ".List1_ListCtrl"));
	confirmBtn = GetButtonHandle((ownerFullPath $ ".Confirm_Btn"));
	TitleTextBox = GetTextBoxHandle((ownerFullPath $ ".Title_text"));
	rewardNormalRichList.SetSelectedSelTooltip(false);
	rewardPremiumRichList.SetSelectedSelTooltip(false);
	rewardNormalRichList.SetSelectable(false);
	rewardPremiumRichList.SetSelectable(false);
	rewardNormalRichList.SetAppearTooltipAtMouseX(true);
	rewardPremiumRichList.SetAppearTooltipAtMouseX(true);
	return;
}

function _SetTotalRewardInfo(L2PassData.EL2PassType PassType, int rewardStep, int premiumRewardStep, bool isPremiumActivated)
{
	local array<L2PassRewardTotalData> normalRewardList, premiumRewardList;
	local RichListCtrlRowData normalRewardRowData, premiumRewardRowData;
	local ItemInfo RewardItemInfo;
	local int nPassType, i, iconWidth, iconHeight, textOffsetX, textOffsetY;
	local Color curCntTextColor, defaultTextColor;
	local string toolTipParam;
	local L2Util util;

	util = L2Util(GetScript("L2Util"));
	iconWidth = 32;
	iconHeight = 32;
	textOffsetX = 4;
	textOffsetX = 4;
	curCntTextColor = util.Yellow;
	defaultTextColor = util.White;
	normalRewardRowData.cellDataList.Length = 1;
	premiumRewardRowData.cellDataList.Length = 1;
	nPassType = int(PassType);
	if((int(PassType) == 0))
	{
		TitleTextBox.SetText(GetSystemString(5939));
	}
	else if((int(PassType) == 1))
	{
		TitleTextBox.SetText(GetSystemString(5940));
	}
	rewardNormalRichList.DeleteAllItem();
	rewardPremiumRichList.DeleteAllItem();
	GetL2PassRewardTotalList(nPassType, false, rewardStep, normalRewardList);
	GetL2PassRewardTotalList(nPassType, true, premiumRewardStep, premiumRewardList);
	i = 0;
	while((i < normalRewardList.Length))
	{
		normalRewardRowData.cellDataList[0].drawitems.Length = 0;
		RewardItemInfo = GetItemInfoByClassID(normalRewardList[i].ItemID);
		util.GetEllipsisString(RewardItemInfo.Name, 210);
		ItemInfoToParam(RewardItemInfo, toolTipParam);
		normalRewardRowData.szReserved = toolTipParam;
		AddRichListCtrlItem(normalRewardRowData.cellDataList[0].drawitems, RewardItemInfo);
		AddRichListCtrlString(normalRewardRowData.cellDataList[0].drawitems, RewardItemInfo.Name, defaultTextColor, false, textOffsetX);
		AddRichListCtrlString(normalRewardRowData.cellDataList[0].drawitems, string(normalRewardList[i].ItemCurrCnt), curCntTextColor, true, (iconWidth + textOffsetX), textOffsetY);
		AddRichListCtrlString(normalRewardRowData.cellDataList[0].drawitems, (" /" @ string(normalRewardList[i].ItemMaxCnt)));
		rewardNormalRichList.InsertRecord(normalRewardRowData);
		++i;
	}
	i = 0;
	while((i < premiumRewardList.Length))
	{
		premiumRewardRowData.cellDataList[0].drawitems.Length = 0;
		RewardItemInfo = GetItemInfoByClassID(premiumRewardList[i].ItemID);
		util.GetEllipsisString(RewardItemInfo.Name, 210);
		ItemInfoToParam(RewardItemInfo, toolTipParam);
		premiumRewardRowData.szReserved = toolTipParam;
		AddRichListCtrlItem(premiumRewardRowData.cellDataList[0].drawitems, RewardItemInfo);
		AddRichListCtrlString(premiumRewardRowData.cellDataList[0].drawitems, RewardItemInfo.Name, defaultTextColor, false, textOffsetX);
		AddRichListCtrlString(premiumRewardRowData.cellDataList[0].drawitems, string(premiumRewardList[i].ItemCurrCnt), curCntTextColor, true, (iconWidth + textOffsetX), textOffsetY);
		AddRichListCtrlString(premiumRewardRowData.cellDataList[0].drawitems, (" /" @ string(premiumRewardList[i].ItemMaxCnt)));
		rewardPremiumRichList.InsertRecord(premiumRewardRowData);
		++i;
	}
	return;
}

function _ScrollToStart()
{
	rewardNormalRichList.SetScrollPosition(0);
	rewardPremiumRichList.SetScrollPosition(0);
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "Confirm_Btn":
			Me.HideWindow();
			break;
		default:
			break;
	}
	return;
}

event OnShow()
{
	parentWnd._ShowDisalbeWnd(true);
	return;
}

event OnHide()
{
	parentWnd._ShowDisalbeWnd(false);
	return;
}
