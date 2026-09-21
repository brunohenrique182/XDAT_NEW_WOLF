class QuestAlarmWnd extends UICommonAPI;

const QUEST_REQUEST_TIMERID = 1123;
const EXPEND_CONTRACT_GAP = 37;
const CONTRACT_WIN_WIDTH = 213;
const EXPEND_WIN_WIDTH = 250;
const CONTRACT_QUEST_NAME_WIDTH = 198;
const EXPEND_QUEST_NAME_WIDTH = 235;
const CONTRACT_ITEM_NAME_WIDTH = 113;
const EXPEND_ITEM_NAME_WIDTH = 150;
const QUEST_ITEM_NUM_DEFAULT = 85;
const TEXT_HEIGHT = 18;
const WINDOW_HEIGHT_MARGIN = 10;
const MAX_ITEM = 5;
const MAX_QUEST = 5;
const MAX_QUEST_ALL = 25;

var bool isClickedAdd;
var int m_NumOfQuest;
var int i;
var int j;
var Color Gold;
var Color White;
var Color Gray;
var int RecentlyAddedQuestID;
var WindowHandle Me;
var ButtonHandle btnClose;
var WindowHandle QuestWnd[5];
var NameCtrlHandle QuestAlarmName[5];
var int QuestAlarmNameID[5];
var NameCtrlHandle QuestItemName[25];
var int QuestItemNameID[25];
var TextBoxHandle QuestItemNum[25];
var INT64 QuestItemNumInt[25];
var int QuestAlarmLevel[5];
var int MonsterQuestID;
var array<int> MonsterNpcId;
var array<int> QuestStringType;
var array<int> MonsterNumOfKillMonsters;
var QuestTreeWnd scQuestTree;
var QuestTreeDrawerWnd scQuestTreeDrawer;
var bool bOptionQuestAlarm;
var L2Util util;

function OnRegisterEvent()
{
	RegisterEvent(160);
	RegisterEvent(150);
	RegisterEvent(3060);
	RegisterEvent(3070);
	RegisterEvent(4931);
	RegisterEvent(4930);
	RegisterEvent(4932);
	RegisterEvent(2600);
	RegisterEvent(2610);
	RegisterEvent(710);
	RegisterEvent(40);
	return;
}

function OnLoad()
{
	OnRegisterEvent();
	Initialize();
	Load();
	InitData();
	FitWindowSize();
	scQuestTree = QuestTreeWnd(GetScript("QuestTreeWnd"));
	scQuestTreeDrawer = QuestTreeDrawerWnd(GetScript("QuestTreeDrawerWnd"));
	util = L2Util(GetScript("L2Util"));
	return;
}

function Initialize()
{
	Me = GetWindowHandle("QuestAlarmWnd");
	btnClose = GetButtonHandle("QuestAlarmWnd.btnClose");
	i = 0;
	while((i < 5))
	{
		QuestWnd[i] = GetWindowHandle(("QuestAlarmWnd.QuestWnd" $ string((i + 1))));
		QuestAlarmName[i] = GetNameCtrlHandle((("QuestAlarmWnd.QuestWnd" $ string((i + 1))) $ ".QuestAlarmName1"));
		j = 0;
		while((j < 5))
		{
			QuestItemName[((i * 5) + j)] = GetNameCtrlHandle(((("QuestAlarmWnd.QuestWnd" $ string((i + 1))) $ ".QuestItemName") $ string((j + 1))));
			QuestItemNum[((i * 5) + j)] = GetTextBoxHandle(((("QuestAlarmWnd.QuestWnd" $ string((i + 1))) $ ".QuestItemNum") $ string((j + 1))));
			QuestItemNum[((i * 5) + j)].SetAnchor(((("QuestAlarmWnd.QuestWnd" $ string((i + 1))) $ ".QuestItemName") $ string((j + 1))), "TopRight", "TopLeft", 3, 0);
			j++;
		}
		i++;
	}
	bOptionQuestAlarm = GetOptionBool("Game", "autoQuestAlarm");
	return;
}

function Load()
{
	Gold.R = 175;
	Gold.G = 152;
	Gold.B = 120;
	Gold.A = 255;
	White.R = 250;
	White.G = 250;
	White.B = 250;
	White.A = 255;
	Gray.R = 135;
	Gray.G = 135;
	Gray.B = 135;
	Gray.A = 255;
	return;
}

function InitData()
{
	i = 0;
	while((i < 5))
	{
		QuestAlarmNameID[i] = -1;
		QuestAlarmName[i].SetName("", NCT_Normal, TA_Left);
		j = 0;
		while((j < 5))
		{
			QuestItemNameID[((i * 5) + j)] = -1;
			QuestItemName[((i * 5) + j)].SetName("", NCT_Normal, TA_Left);
			QuestItemNum[((i * 5) + j)].SetText("");
			j++;
		}
		i++;
	}
	m_NumOfQuest = 0;
	isClickedAdd = false;
	bOptionQuestAlarm = GetOptionBool("Game", "autoQuestAlarm");
	return;
}

function UpdateOptionData()
{
	bOptionQuestAlarm = GetOptionBool("Game", "autoQuestAlarm");
	return;
}

function HandleQuestList(string param)
{
	local int i, QuestID, Level, needQuestItemNum, needItemId, Completed, GoalType;
	local string QuestParam, alarmTitleStr;
	local int Max, Count;
	local bool oneCall;

	ParseInt(param, "QuestID", QuestID);
	ParseInt(param, "Level", Level);
	ParseInt(param, "Completed", Completed);
	Count = 0;
	oneCall = false;
	if((Completed == 0))
	{
		if((bOptionQuestAlarm == true))
		{
			return;
		}
		QuestParam = Class'NWindow.UIDATA_QUEST'.static.GetQuestItem(QuestID, Level);
		ParseInt(QuestParam, "Max", Max);
		i = 0;
		while((i < Max))
		{
			ParseInt(QuestParam, ("GoalID_" $ string(i)), needItemId);
			ParseInt(QuestParam, ("GoalNum_" $ string(i)), needQuestItemNum);
			ParseInt(QuestParam, ("GoalType_" $ string(i)), GoalType);
			if((GoalType == 1))
			{
				alarmTitleStr = GetNpcString(needItemId);
				if((Completed > 0))
				{
					Count = needQuestItemNum;
				}
				else
				{
					Count = 0;
				}
			}
			else if((needItemId >= 1000000))
			{
				alarmTitleStr = ((Class'NWindow.UIDATA_NPC'.static.GetNPCName((needItemId - 1000000)) $ " ") $ GetSystemString(2240));
				Count = needQuestItemNum;
			}
			else
			{
				alarmTitleStr = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(needItemId));
				Count = int(GetInventoryItemCount(GetItemID(needItemId)));
			}
			if((bOptionQuestAlarm == false))
			{
				AddQuestAlarmNew(QuestID, Class'NWindow.UIDATA_QUEST'.static.GetQuestName(QuestID, Level), needItemId, alarmTitleStr, Count, INT64(needQuestItemNum), Level);
			}
			if((oneCall == false))
			{
				oneCall = true;
				RequestAddExpandQuestAlarm(QuestID);
			}
			i++;
		}
	}
	return;
}

function HandleGamingStateEnter()
{
	if((m_NumOfQuest > 0))
	{
		Me.ShowWindow();
	}
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	local int ClassID, QuestID, NpcID, numOfKillMonsters, isStringType;

	switch(a_EventID)
	{
		case 40:
			Me.KillTimer(1123);
			RecentlyAddedQuestID = 0;
			InitData();
			break;
		case 710:
			ParseInt(a_Param, "QuestID", QuestID);
			if((scQuestTree.m_recentlyQuestID == QuestID))
			{
				HandleQuestList(a_Param);
			}
			break;
		case 3070:
			break;
		case 150:
			HandleGamingStateEnter();
			break;
		case 4931:
			MonsterQuestID = 0;
			MonsterNpcId.Remove(0, MonsterNpcId.Length);
			QuestStringType.Remove(0, QuestStringType.Length);
			MonsterNumOfKillMonsters.Remove(0, MonsterNumOfKillMonsters.Length);
			break;
		case 4930:
			ParseInt(a_Param, "questId", QuestID);
			ParseInt(a_Param, "npcId", NpcID);
			ParseInt(a_Param, "numOfKillMonsters", numOfKillMonsters);
			ParseInt(a_Param, "type", isStringType);
			if(((NpcID == -1) && (numOfKillMonsters == -1)))
			{
			}
			MonsterQuestID = QuestID;
			if((NpcID == -1))
			{
				MonsterZeroCount();
				return;
			}
			MonsterNpcId.Insert(0, 1);
			MonsterNpcId[0] = NpcID;
			MonsterNumOfKillMonsters.Insert(0, 1);
			MonsterNumOfKillMonsters[0] = numOfKillMonsters;
			QuestStringType.Insert(0, 1);
			QuestStringType[0] = isStringType;
			break;
		case 4932:
			MonsterCountUpdate();
			break;
		case 2610:
			if(Me.IsShowWindow())
			{
				ParseInt(a_Param, "classID", ClassID);
				UpdateItemCount(ClassID);
			}
			break;
		default:
			break;
	}
	return;
}

function MonsterCountUpdate()
{
	local int i, j, k, Count, isStringType;

	i = 0;
	while((i < scQuestTree.ArrQuest.Length))
	{
		j = 0;
		while((j < scQuestTree.ArrQuest[i].ArrNeedItemIDList.Length))
		{
			if((MonsterQuestID == scQuestTree.ArrQuest[i].QuestID))
			{
				Count = 0;
				k = 0;
				while((k < MonsterNpcId.Length))
				{
					if((MonsterNpcId[k] == scQuestTree.ArrQuest[i].ArrNeedItemIDList[j]))
					{
						Count = MonsterNumOfKillMonsters[k];
						isStringType = QuestStringType[k];
						CountKillMonsterUpdate(MonsterQuestID, scQuestTree.ArrQuest[i].ArrNeedItemIDList[j], Count, isStringType);
					}
					k++;
				}
			}
			j++;
		}
		i++;
	}
	return;
}

function MonsterZeroCount()
{
	local int i, j, SetLevel, GoalType;
	local string QuestParam;

	i = 0;
	while((i < scQuestTree.ArrQuest.Length))
	{
		j = 0;
		while((j < scQuestTree.ArrQuest[i].ArrNeedItemIDList.Length))
		{
			if((MonsterQuestID == scQuestTree.ArrQuest[i].QuestID))
			{
				SetLevel = util.GetQuestLevelForID(MonsterQuestID);
				QuestParam = Class'NWindow.UIDATA_QUEST'.static.GetQuestItem(MonsterQuestID, SetLevel);
				ParseInt(QuestParam, ("GoalType_" $ string(j)), GoalType);
				CountKillMonsterUpdate(MonsterQuestID, scQuestTree.ArrQuest[i].ArrNeedItemIDList[j], 0, GoalType);
			}
			j++;
		}
		i++;
	}
	return;
}

function CountKillMonsterUpdate(int QuestID, int NpcID, int numOfKillMonsters, int isStringType)
{
	local int i, Max;
	local array<int> needQuestItemID, needQuestItemNum;
	local string QuestParam;
	local int SetLevel;
	local string Goalname;
	local int Count, GoalType;

	SetLevel = util.GetQuestLevelForID(QuestID);
	QuestParam = Class'NWindow.UIDATA_QUEST'.static.GetQuestItem(QuestID, SetLevel);
	ParseInt(QuestParam, "Max", Max);
	needQuestItemID.Length = Max;
	needQuestItemNum.Length = Max;
	i = 0;
	while((i < Max))
	{
		ParseInt(QuestParam, ("GoalID_" $ string(i)), needQuestItemID[i]);
		ParseInt(QuestParam, ("GoalNum_" $ string(i)), needQuestItemNum[i]);
		ParseInt(QuestParam, ("GoalType_" $ string(i)), GoalType);
		if((NpcID == needQuestItemID[i]))
		{
			Goalname = "";
			if((GoalType == 1))
			{
				UpdateAlarmItem(needQuestItemID[i], INT64(numOfKillMonsters));
				if((Goalname == ""))
				{
					Goalname = GetNpcString(NpcID);
				}
				Count = numOfKillMonsters;
			}
			else if(((needQuestItemID[i] - 1000000) > 0))
			{
				UpdateAlarmItem(needQuestItemID[i], INT64(numOfKillMonsters), QuestID);
				if((Goalname == ""))
				{
					Goalname = ((Class'NWindow.UIDATA_NPC'.static.GetNPCName((needQuestItemID[i] - 1000000)) $ " ") $ GetSystemString(2240));
				}
				Count = numOfKillMonsters;
			}
			else
			{
				if((Goalname == ""))
				{
					Goalname = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(needQuestItemID[i]));
				}
				Count = int(GetInventoryItemCount(GetItemID(needQuestItemID[i])));
			}
			if((bOptionQuestAlarm == false))
			{
				AddQuestAlarmNew(QuestID, Class'NWindow.UIDATA_QUEST'.static.GetQuestName(QuestID, SetLevel), needQuestItemID[i], Goalname, Count, INT64(needQuestItemNum[i]), SetLevel);
			}
		}
		i++;
	}
	scQuestTree.ButtonEnableCheck();
	return;
}

function UpdateItemCount(int ClassID, optional INT64 a_ItemCount)
{
	local int i, j, k;
	local INT64 ItemCount;
	local int localQuestID, localQuestLv;
	local string Goalname;
	local ItemID ItemID;
	local bool isAddedQuest;

	isAddedQuest = false;
	i = 0;
	while((i < scQuestTree.ArrQuest.Length))
	{
		j = 0;
		while((j < scQuestTree.ArrQuest[i].ArrNeedItemIDList.Length))
		{
			if((scQuestTree.ArrQuest[i].arrGoalType[j] == 0))
			{
				if((ClassID == scQuestTree.ArrQuest[i].ArrNeedItemIDList[j]))
				{
					localQuestID = scQuestTree.ArrQuest[i].QuestID;
					localQuestLv = scQuestTree.ArrQuest[i].Level;
					isAddedQuest = true;
					k = 0;
					while((k < scQuestTree.ArrQuest[i].ArrNeedItemIDList.Length))
					{
						if((scQuestTree.ArrQuest[i].arrGoalType[k] == 0))
						{
							ItemID = GetItemID(scQuestTree.ArrQuest[i].ArrNeedItemIDList[k]);
							ItemCount = GetInventoryItemCount(ItemID);
							UpdateAlarmItem(scQuestTree.ArrQuest[i].ArrNeedItemIDList[k], ItemCount);
							Goalname = Class'NWindow.UIDATA_ITEM'.static.GetItemName(ItemID);
							if((bOptionQuestAlarm == false))
							{
								AddQuestAlarmNew(localQuestID, Class'NWindow.UIDATA_QUEST'.static.GetQuestName(localQuestID, localQuestLv), scQuestTree.ArrQuest[i].ArrNeedItemIDList[k], Goalname, int(ItemCount), INT64(scQuestTree.ArrQuest[i].ArrNeedItemNumList[k]), localQuestLv);
							}
						}
						k++;
					}
				}
				if(isAddedQuest)
				{
					if(IsThereDiffQuestType(i))
					{
						if((GetOptionBool("Game", "autoQuestAlarm") == false))
						{
							RequestAddExpandQuestAlarm(localQuestID);
						}
					}
					scQuestTree.ButtonEnableCheck();
					return;
				}
			}
			j++;
		}
		i++;
	}
	return;
}

function bool IsThereDiffQuestType(int QuestNum)
{
	local int i;

	i = 0;
	while((i < scQuestTree.ArrQuest[QuestNum].ArrNeedItemIDList.Length))
	{
		if((scQuestTree.ArrQuest[QuestNum].arrGoalType[i] == 1))
		{
			return true;
		}
		if((scQuestTree.ArrQuest[QuestNum].ArrNeedItemIDList[i] >= 1000000))
		{
			return true;
		}
		i++;
	}
	return false;
}

function OnTimer(int TimerID)
{
	if((TimerID == 1123))
	{
		Class'NWindow.QuestAPI'.static.RequestQuestList();
		Me.KillTimer(1123);
	}
	return;
}

function externalDelayTimerRequestAddExpandQuest(int nRecentlyAddedQuestID)
{
	RecentlyAddedQuestID = nRecentlyAddedQuestID;
	if((RecentlyAddedQuestID > 0))
	{
		Me.KillTimer(1123);
		Me.SetTimer(1123, 1000);
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "btnClose":
			OnBtnCloseClick();
			break;
		default:
			break;
	}
	return;
}

function OnBtnCloseClick()
{
	InitData();
	if(Me.IsShowWindow())
	{
		Me.HideWindow();
	}
	return;
}

function ExpendWindowSize()
{
	local int Height;
	local string tempStr;
	local int nWidth, nHeight;

	Me.GetWindowSize(i, Height);
	Me.SetWindowSize(250, Height);
	i = 0;
	while((i < 5))
	{
		QuestWnd[i].GetWindowSize(j, Height);
		QuestWnd[i].SetWindowSize(235, Height);
		QuestAlarmName[i].SetWindowSize(235, 18);
		i++;
	}
	i = 0;
	while((i < 25))
	{
		tempStr = QuestItemName[i].GetName();
		GetTextSizeDefault(tempStr, nWidth, nHeight);
		if(((nWidth < 150) && (nWidth > 5)))
		{
			QuestItemName[i].SetWindowSize(nWidth, 18);
			i++;
			continue;
		}
		QuestItemName[i].SetWindowSize(150, 18);
		i++;
	}
	Me.MoveEx((213 - 250), 0);
	return;
}

function FitWindowSize()
{
	local int Width, Height, TotalHeight, oneWinHeight;

	TotalHeight = 0;
	m_NumOfQuest = 0;
	i = 0;
	while((i < 5))
	{
		if((QuestAlarmNameID[i] == -1))
		{
			if(QuestWnd[i].IsShowWindow())
			{
				QuestWnd[i].HideWindow();
			}
			i++;
			continue;
		}
		m_NumOfQuest++;
		if(!QuestWnd[i].IsShowWindow())
		{
			QuestWnd[i].ShowWindow();
		}
		oneWinHeight = 0;
		oneWinHeight = (oneWinHeight + 18);
		j = 0;
		while((j < 5))
		{
			if((QuestItemNameID[((i * 5) + j)] != -1))
			{
				oneWinHeight = (oneWinHeight + 18);
			}
			j++;
		}
		TotalHeight = ((TotalHeight + oneWinHeight) + 10);
		QuestWnd[i].GetWindowSize(Width, Height);
		QuestWnd[i].SetWindowSize(Width, oneWinHeight);
		i++;
	}
	if((m_NumOfQuest == 0))
	{
		if(Me.IsShowWindow())
		{
			Me.HideWindow();
		}
	}
	else
	{
		Me.GetWindowSize(Width, Height);
		Me.SetWindowSize(Width, TotalHeight);
		if(!Me.IsShowWindow())
		{
			if((GetGameStateName() != "COLLECTIONSTATE"))
			{
				Me.ShowWindow();
			}
		}
	}
	return;
}

function AddQuestAlarmNew(int QuestID, string questName, int ItemID, string ItemName, int ItemCount, INT64 ItemNum, int Level)
{
	local int idx, idxItem, idxItemSomeID;
	local string tempStr;
	local Color tmpColor;

	if((ItemName == ""))
	{
		return;
	}
	idx = QuestSlotIdx(QuestID);
	if((idx == -1))
	{
		idx = FindEmptyQuestSlot();
		if((idx == -1))
		{
			if((isClickedAdd == true))
			{
				AddSystemMessage(2279);
			}
			isClickedAdd = false;
			return;
		}
		else
		{
			QuestAlarmName[idx].SetNameWithColor(questName, NCT_Normal, TA_Left, Gold);
			QuestAlarmNameID[idx] = QuestID;
			QuestAlarmLevel[idx] = Level;
		}
	}
	idxItem = FindEmptyItemSlot(idx);
	if((idxItem == -1))
	{
		return;
	}
	else
	{
		idxItemSomeID = QuestItemSlotIdx(idx, ItemID);
		if((idxItemSomeID == -1))
		{
			if((ItemNum < INT64(0)))
			{
				ItemNum = -ItemNum;
			}
			tempStr = ("- " $ ItemName);
			if(((INT64(ItemCount) < ItemNum) || (ItemNum == INT64(0))))
			{
				tmpColor = White;
			}
			else
			{
				tmpColor = Gray;
			}
			QuestItemName[((idx * 5) + idxItem)].SetNameWithColor(tempStr, NCT_Normal, TA_Left, tmpColor);
			QuestItemNum[((idx * 5) + idxItem)].SetTextColor(tmpColor);
			if((ItemNum == INT64(0)))
			{
				QuestItemNum[((idx * 5) + idxItem)].SetText((("(" $ string(ItemCount)) $ ")"));
			}
			else
			{
				QuestItemNum[((idx * 5) + idxItem)].SetText((((("(" $ string(ItemCount)) $ "/") $ string(ItemNum)) $ ")"));
			}
			QuestItemNameID[((idx * 5) + idxItem)] = ItemID;
			QuestItemNumInt[((idx * 5) + idxItem)] = ItemNum;
			setItemWindowSize(((idx * 5) + idxItem), tempStr);
		}
	}
	FitWindowSize();
	return;
}

function setItemWindowSize(int Index, string tmpStr)
{
	local int nWidth, nWidth2, nHeight;
	local Rect myRectWnd;
	local int OffsetX;

	OffsetX = 25;
	myRectWnd = Me.GetRect();
	GetTextSizeDefault(tmpStr, nWidth, nHeight);
	GetTextSizeDefault(QuestItemNum[Index].GetText(), nWidth2, nHeight);
	QuestItemNum[Index].GetWindowSize(nWidth2, nHeight);
	if((((nWidth + nWidth2) + OffsetX) > myRectWnd.nWidth))
	{
		nWidth = ((myRectWnd.nWidth - nWidth2) - OffsetX);
	}
	QuestItemName[Index].SetWindowSize(nWidth, nHeight);
	return;
}

function CustomTooltip getQuestToolTip(int QuestID, int Level)
{
	local CustomTooltip m_Tooltip;
	local string questDesc, trimStr, huntingStr, tempStr, journalName;
	local Vector questZoneLoc;
	local int questZoneID, tooltipLine;

	questZoneLoc = Class'NWindow.UIDATA_QUEST'.static.GetTargetLoc(QuestID, Level);
	questZoneID = Class'NWindow.UIDATA_QUEST'.static.GetQuestZone(QuestID, Level);
	journalName = Class'NWindow.UIDATA_QUEST'.static.GetQuestJournalName(QuestID, Level);
	questDesc = Class'NWindow.UIDATA_QUEST'.static.GetQuestDescription(QuestID, Level);
	trimStr = trim(questDesc);
	questDesc = Substitute(questDesc, "\\n", " ", false);
	huntingStr = cutTheStr(questDesc, GetSystemString(3318), true);
	tempStr = cutTheStr(questDesc, GetSystemString(3318), false);
	if((Len(tempStr) > 0))
	{
		questDesc = tempStr;
	}
	if((Len(huntingStr) > 0))
	{
		tooltipLine = 4;
	}
	else
	{
		tooltipLine = 3;
	}
	if((Len(questDesc) > 0))
	{
		m_Tooltip.DrawList.Length = tooltipLine;
		m_Tooltip.MinimumWidth = 230;
		m_Tooltip.DrawList[0].eType = DIT_TEXT;
		m_Tooltip.DrawList[0].t_color.R = 255;
		m_Tooltip.DrawList[0].t_color.G = 255;
		m_Tooltip.DrawList[0].t_color.B = 255;
		m_Tooltip.DrawList[0].t_color.A = 255;
		m_Tooltip.DrawList[0].t_strText = journalName;
		m_Tooltip.DrawList[1].eType = DIT_BLANK;
		m_Tooltip.DrawList[1].b_nHeight = 3;
		m_Tooltip.DrawList[2].eType = DIT_TEXT;
		m_Tooltip.DrawList[2].nOffSetY = 4;
		m_Tooltip.DrawList[2].bLineBreak = true;
		m_Tooltip.DrawList[2].t_color.R = 178;
		m_Tooltip.DrawList[2].t_color.G = 190;
		m_Tooltip.DrawList[2].t_color.B = 207;
		m_Tooltip.DrawList[2].t_color.A = 255;
		m_Tooltip.DrawList[2].t_strText = questDesc;
		if((tooltipLine > 3))
		{
			m_Tooltip.DrawList[3].eType = DIT_TEXT;
			m_Tooltip.DrawList[3].nOffSetY = 10;
			m_Tooltip.DrawList[3].bLineBreak = true;
			m_Tooltip.DrawList[3].t_color.R = 211;
			m_Tooltip.DrawList[3].t_color.G = 30;
			m_Tooltip.DrawList[3].t_color.B = 30;
			m_Tooltip.DrawList[3].t_color.A = 255;
			m_Tooltip.DrawList[3].t_strText = huntingStr;
		}
	}
	return m_Tooltip;
}

function string TrimRight(string S)
{
	S = Left(S, (Len(S) - 1));
	return S;
}

function string cutTheStr(string S, string t, bool cutStringEnd)
{
	local int i;

	i = InStr(S, t);
	if((i <= -1))
	{
		return "";
	}
	else if(cutStringEnd)
	{
		return Mid(S, i, Len(S));
	}
	else
	{
		return Mid(S, 0, i);
	}
}

function DeleteQuestAlarm(int QuestID)
{
	local int idx;
	local Color tempColor;
	local int nWidth, nHeight;

	idx = QuestSlotIdx(QuestID);
	if((idx == -1))
	{
		return;
	}
	else
	{
		i = (idx + 1);
		while((i < 5))
		{
			QuestAlarmName[(i - 1)].SetNameWithColor(QuestAlarmName[i].GetName(), NCT_Normal, TA_Left, Gold);
			QuestAlarmNameID[(i - 1)] = QuestAlarmNameID[i];
			QuestAlarmLevel[(i - 1)] = QuestAlarmLevel[i];
			j = 0;
			while((j < 5))
			{
				tempColor = QuestItemNum[((i * 5) + j)].GetTextColor();
				QuestItemName[(((i - 1) * 5) + j)].SetNameWithColor(QuestItemName[((i * 5) + j)].GetName(), NCT_Normal, TA_Left, tempColor);
				QuestItemName[((i * 5) + j)].GetWindowSize(nWidth, nHeight);
				QuestItemName[(((i - 1) * 5) + j)].SetWindowSize(nWidth, nHeight);
				QuestItemNameID[(((i - 1) * 5) + j)] = QuestItemNameID[((i * 5) + j)];
				QuestItemNum[(((i - 1) * 5) + j)].SetText(QuestItemNum[((i * 5) + j)].GetText());
				QuestItemNum[(((i - 1) * 5) + j)].SetTextColor(tempColor);
				QuestItemNumInt[(((i - 1) * 5) + j)] = QuestItemNumInt[((i * 5) + j)];
				j++;
			}
			i++;
		}
		idx = (5 - 1);
		QuestAlarmName[idx].SetName("", NCT_Normal, TA_Left);
		QuestAlarmNameID[idx] = -1;
		QuestAlarmLevel[idx] = -1;
		j = 0;
		while((j < 5))
		{
			QuestItemName[((idx * 5) + j)].SetName("", NCT_Normal, TA_Left);
			QuestItemNameID[((idx * 5) + j)] = -1;
			QuestItemNum[((idx * 5) + j)].SetText("");
			QuestItemNumInt[((idx * 5) + j)] = INT64(-1);
			j++;
		}
	}
	FitWindowSize();
	return;
}

function UpdateAlarmItem(int ItemID, INT64 Count, optional int QuestID)
{
	local string NameTemp1;
	local INT64 counts;
	local int QuestNum;

	i = 0;
	while((i < 25))
	{
		QuestNum = (i / 5);
		if(((QuestItemNameID[i] == ItemID) && (((QuestID == QuestAlarmNameID[QuestNum]) || (QuestID == 0)) || (QuestAlarmNameID[QuestNum] == -1))))
		{
			if((QuestItemNumInt[i] < INT64(0)))
			{
				counts = -QuestItemNumInt[i];
			}
			else
			{
				counts = QuestItemNumInt[i];
			}
			if(((Count < counts) || (counts == INT64(0))))
			{
				NameTemp1 = QuestItemName[i].GetName();
				QuestItemName[i].SetNameWithColor(NameTemp1, NCT_Normal, TA_Left, White);
				QuestItemNum[i].SetTextColor(White);
			}
			else
			{
				NameTemp1 = QuestItemName[i].GetName();
				QuestItemName[i].SetNameWithColor(NameTemp1, NCT_Normal, TA_Left, Gray);
				QuestItemNum[i].SetTextColor(Gray);
			}
			if((counts == INT64(0)))
			{
				QuestItemNum[i].SetText((("(" $ string(Count)) $ ")"));
			}
			else
			{
				QuestItemNum[i].SetText((((("(" $ string(Count)) $ "/") $ string(counts)) $ ")"));
			}
			setItemWindowSize(i, NameTemp1);
			return;
		}
		i++;
	}
	return;
}

function UpdateAlarmExpand(int NpcID, int Count)
{
	local string NameTemp1;

	i = 0;
	while((i < 25))
	{
		if((QuestItemNameID[i] == NpcID))
		{
			if(((INT64(Count) < QuestItemNumInt[i]) || (QuestItemNumInt[i] == INT64(0))))
			{
				NameTemp1 = QuestItemName[i].GetName();
				QuestItemName[i].SetNameWithColor(NameTemp1, NCT_Normal, TA_Left, White);
				QuestItemNum[i].SetTextColor(White);
			}
			else
			{
				NameTemp1 = QuestItemName[i].GetName();
				QuestItemName[i].SetNameWithColor(NameTemp1, NCT_Normal, TA_Left, Gray);
				QuestItemNum[i].SetTextColor(Gray);
			}
			if((QuestItemNumInt[i] == INT64(0)))
			{
				QuestItemNum[i].SetText(((" (" $ string(Count)) $ ")"));
				i++;
				continue;
			}
			QuestItemNum[i].SetText(((((" (" $ string(Count)) $ "/") $ string(QuestItemNumInt[i])) $ ")"));
		}
		i++;
	}
	return;
}

function int FindEmptyQuestSlot()
{
	local int SlotID;

	SlotID = -1;
	i = 0;
	while((i < 5))
	{
		if((QuestAlarmNameID[i] == -1))
		{
			SlotID = i;
			break;
		}
		i++;
	}
	return SlotID;
}

function int QuestSlotIdx(int QuestID)
{
	local int SlotID;

	SlotID = -1;
	i = 0;
	while((i < 5))
	{
		if((QuestAlarmNameID[i] == QuestID))
		{
			SlotID = i;
			break;
		}
		i++;
	}
	return SlotID;
}

function int FindEmptyItemSlot(int QuestIdx)
{
	local int itemSlotID;

	itemSlotID = -1;
	i = 0;
	while((i < 5))
	{
		if((QuestItemNameID[((QuestIdx * 5) + i)] == -1))
		{
			itemSlotID = i;
			break;
		}
		i++;
	}
	return itemSlotID;
}

function int QuestItemSlotIdx(int QuestIdx, int ItemID)
{
	local int itemSlotID;

	itemSlotID = -1;
	i = 0;
	while((i < 5))
	{
		if((QuestItemNameID[((QuestIdx * 5) + i)] == ItemID))
		{
			itemSlotID = i;
			break;
		}
		i++;
	}
	return itemSlotID;
}
