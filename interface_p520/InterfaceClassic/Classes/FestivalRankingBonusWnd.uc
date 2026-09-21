class FestivalRankingBonusWnd extends UICommonAPI
	dependson(UIPacket);

enum REWARD_STATE
{
	non,                            // 0
	Reward,                         // 1
	Completed                       // 2
};

var WindowHandle Me;
var string m_Windowname;
var RichListCtrlHandle ListCtrl;
var FestivalRankingWnd festivalRankingWndScript;
var INT64 myAmount;
var array<UIPacket._RFBonusInfo> _bonusInfos;
var array<int> _receivedPoints;
var ButtonHandle TakeAll_Btn;
var int MyIndex;
var int completedRewardNum;

function Initialize()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	TakeAll_Btn = GetButtonHandle((m_Windowname $ ".TakeAll_Btn"));
	TakeAll_Btn.DisableWindow();
	festivalRankingWndScript = FestivalRankingWnd(GetScript("festivalRankingWnd"));
	ListCtrl = GetRichListCtrlHandle((m_Windowname $ ".Bonus_ListCtrl"));
	ListCtrl.SetSelectable(false);
	ListCtrl.SetAppearTooltipAtMouseX(true);
	ListCtrl.SetSelectedSelTooltip(false);
	ListCtrl.SetTooltipType("SellItemList");
	return;
}

event OnShow()
{
	GetRichListCtrlHandle((m_Windowname $ ".Bonus_ListCtrl")).SetStartRow(MyIndex);
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

event OnClickButton(string Name)
{
	local array<int> Points;

	if((Left(Name, 7) == "btnInfo"))
	{
		Points[Points.Length] = int(Right(Name, (Len(Name) - 7)));
		festivalRankingWndScript.API_RequestRankingFestivalBonus(Points);
	}
	else if((Name == "TakeAll_Btn"))
	{
		HandleReceiveAll();
	}
	return;
}

event OnHide()
{
	TakeAll_Btn.DisableWindow();
	return;
}

function HandleReceiveAll()
{
	local int i;
	local array<int> Points;

	i = 0;
	while((i < completedRewardNum))
	{
		if((GetReceivedIndexByPoint(_bonusInfos[i].nPoint) == -1))
		{
			Points[Points.Length] = _bonusInfos[i].nPoint;
		}
		i++;
	}
	festivalRankingWndScript.C_EX_RANKING_FESTIVAL_BONUS(Points);
	return;
}

function Show()
{
	Me.ShowWindow();
	Me.SetFocus();
	return;
}

function SetMyAmount(INT64 Amount)
{
	myAmount = Amount;
	SetBonusList(_bonusInfos);
	return;
}

function AddBonusReceived(array<int> addedPoints)
{
	local int i;

	i = 0;
	while((i < addedPoints.Length))
	{
		_receivedPoints[_receivedPoints.Length] = addedPoints[i];
		i++;
	}
	SetBonusReceived(_receivedPoints);
	return;
}

function SetBonusReceived(array<int> receivedPoints)
{
	local int i, Index;
	local ItemInfo iInfo;

	_receivedPoints = receivedPoints;
	i = 0;
	while((i < _receivedPoints.Length))
	{
		Index = GetIndexByPoint(_receivedPoints[i]);
		if((Index == -1))
		{
			i++;
			continue;
		}
		iInfo = GetItemInfoByClassID(_bonusInfos[Index].nRewardItemClassId);
		iInfo.ItemNum = _bonusInfos[Index].nRewardItemAmount;
		ListCtrl.ModifyRecord(Index, MakeRecordBonus(_bonusInfos[Index].nPoint, iInfo, Completed));
		i++;
	}
	CheckCanReard();
	return;
}

function int GetReceivedIndexByPoint(int point)
{
	local int i;

	i = 0;
	while((i < _receivedPoints.Length))
	{
		if((_receivedPoints[i] == point))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function SetBonusList(array<UIPacket._RFBonusInfo> bonusInfos)
{
	local int i;
	local ItemInfo iInfo;
	local REWARD_STATE RewardState;

	ListCtrl.DeleteAllItem();
	_bonusInfos = bonusInfos;
	completedRewardNum = _bonusInfos.Length;
	MyIndex = -1;
	i = 0;
	while((i < _bonusInfos.Length))
	{
		iInfo = GetItemInfoByClassID(bonusInfos[i].nRewardItemClassId);
		iInfo.ItemNum = bonusInfos[i].nRewardItemAmount;
		if((myAmount < INT64(bonusInfos[i].nPoint)))
		{
			completedRewardNum--;
			RewardState = non;
		}
		else if((GetReceivedIndexByPoint(bonusInfos[i].nPoint) == -1))
		{
			RewardState = Reward;
			if((MyIndex == -1))
			{
				MyIndex = i;
			}
		}
		else
		{
			RewardState = Completed;
		}
		ListCtrl.InsertRecord(MakeRecordBonus(bonusInfos[i].nPoint, iInfo, RewardState));
		i++;
	}
	CheckCanReard();
	ListCtrl.SetStartRow(MyIndex);
	return;
}

function CheckCanReard()
{
	if((completedRewardNum <= _receivedPoints.Length))
	{
		festivalRankingWndScript.SetGiftBox(false);
		TakeAll_Btn.DisableWindow();
	}
	else
	{
		festivalRankingWndScript.SetGiftBox(true);
		TakeAll_Btn.EnableWindow();
	}
	return;
}

function RichListCtrlRowData MakeRecordBonus(int ItemNum, ItemInfo iInfo, REWARD_STATE Type)
{
	local RichListCtrlRowData Record;
	local Color nameTextColor, numTextColor, btnTextColor;
	local int nWidth, nHeight;
	local string btnString, param;

	Record.cellDataList.Length = 3;
	ItemInfoToParam(iInfo, param);
	Record.szReserved = param;
	switch(Type)
	{
		case non:
			numTextColor = GetColor(255, 221, 102, 255);
			break;
		case Reward:
			numTextColor = GetColor(255, 255, 255, 255);
			break;
		case Completed:
			numTextColor = GetColor(153, 153, 153, 255);
			break;
		default:
			break;
	}
	addRichListCtrlTexture(Record.cellDataList[0].drawitems, GetTextureByType(Type), 64, 64, 0, 1, 64, 64);
	GetTextSizeDefault(string(ItemNum), nWidth, nHeight);
	AddRichListCtrlString(Record.cellDataList[0].drawitems, string(ItemNum), numTextColor, false, (-(64 + nWidth) / 2), ((64 - nHeight) / 2));
	addRichListCtrlTexture(Record.cellDataList[1].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_DF_Slotbox_2x2", 36, 36, 0, 1);
	addRichListCtrlTexture(Record.cellDataList[1].drawitems, iInfo.IconName, 36, 36, -36, 0);
	switch(Type)
	{
		case non:
			nameTextColor = GetColor(153, 153, 153, 255);
			numTextColor = GetColor(153, 153, 153, 255);
			AddRichListCtrlButton(Record.cellDataList[2].drawitems, ("NotEnough_btnInfo" $ string(ItemNum)), 0, 0, "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_DF_Button_Disable", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_DF_Button_Disable", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_DF_Button_Disable", 90, 30);
			btnString = GetSystemString(1737);
			btnTextColor = GetColor(153, 153, 153, 255);
			break;
		case Reward:
			nameTextColor = GetColor(255, 255, 255, 255);
			numTextColor = GetColor(255, 221, 102, 255);
			addRichListCtrlTexture(Record.cellDataList[1].drawitems, "L2UI_ct1.FestivalWnd.FestivalWnd_ItemSlot", 36, 36, -38, -2);
			AddRichListCtrlButton(Record.cellDataList[2].drawitems, ("btnInfo" $ string(ItemNum)), 0, 0, "L2UI_ct1.LCoinShopWnd.LCoinShopWnd_DF_Button", "L2UI_ct1.LCoinShopWnd.LCoinShopWnd_DF_Button_Down", "L2UI_ct1.LCoinShopWnd.LCoinShopWnd_DF_Button_Over", 90, 30);
			btnString = GetSystemString(1737);
			btnTextColor = GetColor(230, 220, 190, 255);
			break;
		case Completed:
			addRichListCtrlTexture(Record.cellDataList[1].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_IconDisable", 36, 36, -36, 0);
			nameTextColor = GetColor(153, 153, 153, 255);
			numTextColor = GetColor(153, 153, 153, 255);
			addRichListCtrlTexture(Record.cellDataList[1].drawitems, "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_CheckAni0015", 25, 21, -36, 0);
			AddRichListCtrlButton(Record.cellDataList[2].drawitems, ("completed_btnInfo" $ string(ItemNum)), 0, 0, "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_DF_Button_Disable", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_DF_Button_Disable", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_DF_Button_Disable", 90, 30);
			btnString = GetSystemString(898);
			btnTextColor = GetColor(153, 153, 153, 255);
			break;
		default:
			break;
	}
	AddRichListCtrlString(Record.cellDataList[1].drawitems, iInfo.Name, nameTextColor, true, 40, -31);
	AddRichListCtrlString(Record.cellDataList[1].drawitems, ("x" $ MakeCostString(string(iInfo.ItemNum))), numTextColor, true, 40, 0);
	GetTextSizeDefault(btnString, nWidth, nHeight);
	AddRichListCtrlString(Record.cellDataList[2].drawitems, btnString, btnTextColor, false, (-(90 + nWidth) / 2), ((30 - nHeight) / 2));
	return Record;
}

function string GetTextureByType(REWARD_STATE Type)
{
	switch(Type)
	{
		case non:
			return "L2UI_EPIC.RankingFestivalWnd.RewardYellowBg";
			break;
		case Reward:
			return "L2UI_EPIC.RankingFestivalWnd.RewardBlueBg";
			break;
		case Completed:
			return "L2UI_EPIC.RankingFestivalWnd.RewardGrayBg";
			break;
		default:
			break;
	}
}

function int GetIndexByPoint(int point)
{
	local int i;

	i = 0;
	while((i < _bonusInfos.Length))
	{
		if((_bonusInfos[i].nPoint == point))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	Me.HideWindow();
	return;
}
