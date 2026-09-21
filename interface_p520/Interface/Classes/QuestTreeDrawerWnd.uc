class QuestTreeDrawerWnd extends UICommonAPI;

var WindowHandle Me;
var TextureHandle GroupBox_Title;
var TextureHandle GroupBox_DescriptionTree;
var TextureHandle GroupBox_DescriptionTreeLarge;
var TextureHandle GroupBox_ItemTree;
var TextureHandle GroupBox_RewardItemTree;
var TextBoxHandle txtQuestTitle;
var TextBoxHandle txtRecommandedLevel;
var TextBoxHandle txtRecommandedLevelText;
var TextBoxHandle txtQuestType;
var TreeHandle QuestDescriptionTree;
var TreeHandle QuestDescriptionLargeTree;
var TextBoxHandle txtQuestItemTitle;
var TextBoxHandle txtQuestRewardItemTreeTitle;
var TreeHandle QuestItemTree;
var TreeHandle QuestRewardItemTree;
var ButtonHandle btnGiveUpCurrentQuest;
var ButtonHandle btnAddAlarm;
var ButtonHandle btnClose;
var ButtonHandle btnDeleteAlarm;
var L2Util util;
var int SelectQuestID;
var int SelectLevel;
var int SelectCompleted;
var array<int> SelectarrItemID;
var array<int> SelectarrItemNumList;
var array<int> SelectarrGoalType;
var QuestAlarmWnd m_scriptAlarm;
var QuestTreeWnd scQuestTree;

function OnRegisterEvent()
{
	return;
}

function OnLoad()
{
	Initialize();
	Load();
	util = L2Util(GetScript("L2Util"));
	m_scriptAlarm = QuestAlarmWnd(GetScript("QuestAlarmWnd"));
	scQuestTree = QuestTreeWnd(GetScript("QuestTreeWnd"));
	btnAddAlarm.DisableWindow();
	btnDeleteAlarm.DisableWindow();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("QuestTreeDrawerWnd");
	GroupBox_Title = GetTextureHandle("QuestTreeDrawerWnd.GroupBox_Title");
	GroupBox_DescriptionTree = GetTextureHandle("QuestTreeDrawerWnd.GroupBox_DescriptionTree");
	GroupBox_DescriptionTreeLarge = GetTextureHandle("QuestTreeDrawerWnd.GroupBox_DescriptionTreeLarge");
	GroupBox_ItemTree = GetTextureHandle("QuestTreeDrawerWnd.GroupBox_ItemTree");
	GroupBox_RewardItemTree = GetTextureHandle("QuestTreeDrawerWnd.GroupBox_RewardItemTree");
	txtQuestTitle = GetTextBoxHandle("QuestTreeDrawerWnd.txtQuestTitle");
	txtRecommandedLevel = GetTextBoxHandle("QuestTreeDrawerWnd.txtRecommandedLevel");
	txtRecommandedLevelText = GetTextBoxHandle("QuestTreeDrawerWnd.txtRecommandedLevelText");
	txtQuestType = GetTextBoxHandle("QuestTreeDrawerWnd.txtQuestType");
	QuestDescriptionTree = GetTreeHandle("QuestTreeDrawerWnd.QuestDescriptionTree");
	QuestDescriptionLargeTree = GetTreeHandle("QuestTreeDrawerWnd.QuestDescriptionLargeTree");
	txtQuestItemTitle = GetTextBoxHandle("QuestTreeDrawerWnd.txtQuestItemTitle");
	txtQuestRewardItemTreeTitle = GetTextBoxHandle("QuestTreeDrawerWnd.txtQuestRewardItemTreeTitle");
	QuestItemTree = GetTreeHandle("QuestTreeDrawerWnd.QuestItemTree");
	QuestRewardItemTree = GetTreeHandle("QuestTreeDrawerWnd.QuestRewardItemTree");
	btnGiveUpCurrentQuest = GetButtonHandle("QuestTreeDrawerWnd.btnGiveUpCurrentQuest");
	btnAddAlarm = GetButtonHandle("QuestTreeDrawerWnd.btnAddAlarm");
	btnClose = GetButtonHandle("QuestTreeDrawerWnd.btnClose");
	btnDeleteAlarm = GetButtonHandle("QuestTreeDrawerWnd.btnDeleteAlarm");
	return;
}

function Load()
{
	return;
}

function OnEvent(int EventID, string param)
{
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "btnGiveUpCurrentQuest":
			OnbtnGiveUpCurrentQuestClick();
			break;
		case "btnAddAlarm":
			OnbtnAddAlarmClick();
			break;
		case "btnClose":
			OnBtnCloseClick();
			break;
		case "btnDeleteAlarm":
			OnbtnDeleteAlarmClick();
			break;
		default:
			break;
	}
	return;
}

function OnbtnGiveUpCurrentQuestClick()
{
	local QuestTreeWnd Script;

	Script = QuestTreeWnd(GetScript("QuestTreeWnd"));
	Script.HandleQuestCancel();
	return;
}

function OnbtnAddAlarmClick()
{
	local int i, Count;
	local string alarmTitleStr;

	if((SelectarrItemID.Length > 0))
	{
		RequestAddExpandQuestAlarm(SelectQuestID);
	}
	i = 0;
	while((i < SelectarrItemID.Length))
	{
		alarmTitleStr = "";
		if((SelectarrGoalType[i] == 1))
		{
			alarmTitleStr = GetNpcString(SelectarrItemID[i]);
		}
		else if((SelectarrItemID[i] >= 1000000))
		{
			alarmTitleStr = ((Class'NWindow.UIDATA_NPC'.static.GetNPCName((SelectarrItemID[i] - 1000000)) $ " ") $ GetSystemString(2240));
			Count = 0;
		}
		else
		{
			alarmTitleStr = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(SelectarrItemID[i]));
			Count = int(GetInventoryItemCount(GetItemID(SelectarrItemID[i])));
		}
		m_scriptAlarm.AddQuestAlarmNew(SelectQuestID, Class'NWindow.UIDATA_QUEST'.static.GetQuestName(SelectQuestID, SelectLevel), SelectarrItemID[i], alarmTitleStr, Count, INT64(SelectarrItemNumList[i]), SelectLevel);
		i++;
	}
	scQuestTree.ButtonEnableCheck();
	return;
}

function OnBtnCloseClick()
{
	Me.HideWindow();
	return;
}

function OnbtnDeleteAlarmClick()
{
	scQuestTree.HandleDeleteAlarm();
	return;
}

function showQuestDrawer(string Str)
{
	local int i, SplitCount;
	local array<string> arrSplit;
	local int QuestID, Level, Completed, QuestType, Type, MinLevel, MaxLevle;
	local string QuestDescription, QuestParam;
	local int Max;
	local array<int> arrItemIDList, arrItemNumList;
	local bool bShowCompletionItem;
	local array<int> RewardIDList;
	local array<INT64> rewardNumList;
	local string journalName;
	local bool bQuest;
	local array<int> arrGoalType;

	bQuest = false;
	if(!Me.IsShowWindow())
	{
		Me.ShowWindow();
	}
	btnGiveUpCurrentQuest.EnableWindow();
	SplitCount = Split(Str, ".", arrSplit);
	QuestID = int(arrSplit[1]);
	if((SplitCount == 2))
	{
		Level = 1;
		Completed = 0;
	}
	else if((SplitCount == 4))
	{
		Level = int(arrSplit[2]);
		Completed = int(arrSplit[3]);
	}
	MinLevel = Class'NWindow.UIDATA_QUEST'.static.GetMinLevel(QuestID, Level);
	MaxLevle = Class'NWindow.UIDATA_QUEST'.static.GetMaxLevel(QuestID, Level);
	QuestDescription = Class'NWindow.UIDATA_QUEST'.static.GetQuestDescription(QuestID, Level);
	journalName = Class'NWindow.UIDATA_QUEST'.static.GetQuestJournalName(QuestID, Level);
	journalName = Class'NWindow.UIDATA_QUEST'.static.GetQuestJournalNameLine(journalName);
	txtQuestTitle.SetText(journalName);
	txtRecommandedLevel.SetTextColor(util.White);
	txtRecommandedLevel.SetText((GetSystemString(922) @ ":"));
	txtRecommandedLevelText.SetTextColor(util.Token1);
	if(((MaxLevle > 0) && (MinLevel > 0)))
	{
		txtRecommandedLevelText.SetText(((string(MinLevel) $ "~") $ string(MaxLevle)));
	}
	else if((MinLevel > 0))
	{
		txtRecommandedLevelText.SetText(((string(MinLevel) $ " ") $ GetSystemString(859)));
	}
	else
	{
		txtRecommandedLevelText.SetText(GetSystemString(866));
	}
	QuestType = Class'NWindow.UIDATA_QUEST'.static.GetQuestIscategory(QuestID, Level);
	txtQuestType.SetTextColor(util.White);
	switch(QuestType)
	{
		case 0:
			txtQuestType.SetText(GetSystemString(862));
			break;
		case 1:
			Type = Class'NWindow.UIDATA_QUEST'.static.GetQuestType(QuestID, Level);
			if(((Type == 4) || (Type == 5)))
			{
				txtQuestType.SetText(GetSystemString(2788));
			}
			else
			{
				txtQuestType.SetText(GetSystemString(861));
			}
			break;
		case 2:
			txtQuestType.SetText(GetSystemString(1998));
			break;
		case 3:
			txtQuestType.SetText(GetSystemString(1999));
			break;
		case 4:
			txtQuestType.SetText(GetSystemString(2000));
			break;
		default:
			break;
	}
	QuestParam = Class'NWindow.UIDATA_QUEST'.static.GetQuestItem(QuestID, Level);
	ParseInt(QuestParam, "Max", Max);
	arrItemIDList.Length = Max;
	arrItemNumList.Length = Max;
	arrGoalType.Length = Max;
	i = 0;
	while((i < Max))
	{
		ParseInt(QuestParam, ("GoalID_" $ string(i)), arrItemIDList[i]);
		ParseInt(QuestParam, ("GoalNum_" $ string(i)), arrItemNumList[i]);
		ParseInt(QuestParam, ("GoalType_" $ string(i)), arrGoalType[i]);
		if(((arrItemIDList[i] < 1000000) && (arrGoalType[i] != 1)))
		{
			bQuest = true;
		}
		i++;
	}
	RewardIDList.Remove(0, RewardIDList.Length);
	rewardNumList.Remove(0, rewardNumList.Length);
	Class'NWindow.UIDATA_QUEST'.static.GetQuestReward(QuestID, Level, RewardIDList, rewardNumList);
	util.TreeClear("QuestTreeDrawerWnd.QuestDescriptionTree");
	util.TreeClear("QuestTreeDrawerWnd.QuestDescriptionLargeTree");
	util.TreeInsertRootNode("QuestTreeDrawerWnd.QuestDescriptionTree", "root", "");
	util.TreeInsertRootNode("QuestTreeDrawerWnd.QuestDescriptionLargeTree", "root", "");
	if((Max != 0))
	{
		if(!bQuest)
		{
			setQuestItemShow(false);
			util.TreeInsertTextNodeItem("QuestTreeDrawerWnd.QuestDescriptionLargeTree", "root", QuestDescription);
		}
		else
		{
			setQuestItemShow(true);
			util.TreeInsertTextNodeItem("QuestTreeDrawerWnd.QuestDescriptionTree", "root", QuestDescription);
		}
	}
	else
	{
		setQuestItemShow(false);
		util.TreeInsertTextNodeItem("QuestTreeDrawerWnd.QuestDescriptionLargeTree", "root", QuestDescription);
	}
	if((Max > 0))
	{
		if(bQuest)
		{
			bShowCompletionItem = Class'NWindow.UIDATA_QUEST'.static.IsShowableItemNumQuest(QuestID, Level);
			setQuestItem(Completed, Max, arrItemIDList, arrItemNumList, bShowCompletionItem, arrGoalType);
		}
	}
	if((RewardIDList.Length > 0))
	{
		setRewardItem(RewardIDList, rewardNumList);
	}
	selectQuestLastCall(QuestID);
	return;
}

function setQuestItem(int Completed, int Count, array<int> IDList, array<int> ItemNum, bool bShowCompletionItem, array<int> arrGoalType)
{
	local int i;
	local string treeName, setTreeName, strRetName;
	local bool bDrawBgTreeQuestItem;
	local string IconName, ItemName;

	treeName = "QuestTreeDrawerWnd.QuestItemTree";
	TreeClear(treeName);
	bDrawBgTreeQuestItem = false;
	util.TreeInsertRootNode(treeName, "List", "", 0, 2);
	setTreeName = "List";
	i = 0;
	while((i < Count))
	{
		if((arrGoalType[i] == 0))
		{
			if((IDList[i] < 1000000))
			{
				strRetName = util.TreeInsertItemNode(treeName, string(i), setTreeName, false, -4, -2);
				IconName = Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(GetItemID(IDList[i]));
				ItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(IDList[i]));
				if(!bDrawBgTreeQuestItem)
				{
					util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_CH3.etc.textbackline", 244, 38, , , , , 14);
				}
				else
				{
					util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_CT1.EmptyBtn", 244, 38);
				}
				bDrawBgTreeQuestItem = !bDrawBgTreeQuestItem;
				util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -238, 2);
				util.TreeInsertTextureNodeItem(treeName, strRetName, IconName, 32, 32, -34, 3);
				util.TreeInsertTextNodeItem(treeName, strRetName, ItemName, 5, 6, COLOR_DEFAULT, true, , IDList[i]);
				if((ItemNum[i] > 0))
				{
					if(((Completed > 0) && bShowCompletionItem))
					{
						util.TreeInsertTextNodeItem(treeName, strRetName, (((("(" $ GetSystemString(898)) $ "/") $ string(ItemNum[i])) $ ")"), 48, -18, COLOR_GOLD, , true);
					}
					else
					{
						util.TreeInsertTextNodeItem(treeName, strRetName, (("(" $ string(ItemNum[i])) $ ")"), 48, -18, COLOR_GOLD, , true);
					}
					i++;
					continue;
				}
				if((ItemNum[i] == 0))
				{
					if(((Completed > 0) && bShowCompletionItem))
					{
						util.TreeInsertTextNodeItem(treeName, strRetName, (((("(" $ GetSystemString(898)) $ "/") $ GetSystemString(858)) $ ")"), 48, -18, COLOR_GOLD, , true);
					}
					else
					{
						util.TreeInsertTextNodeItem(treeName, strRetName, (("(" $ GetSystemString(858)) $ ")"), 48, -18, COLOR_GOLD, , true);
					}
					i++;
					continue;
				}
				if(((Completed > 0) && bShowCompletionItem))
				{
					util.TreeInsertTextNodeItem(treeName, strRetName, ((((("(" $ GetSystemString(898)) $ "/") $ string(-ItemNum[i])) $ GetSystemString(859)) $ ")"), 48, -18, COLOR_GOLD, , true);
					i++;
					continue;
				}
				util.TreeInsertTextNodeItem(treeName, strRetName, ((("(" $ string(-ItemNum[i])) $ GetSystemString(859)) $ ")"), 48, -18, COLOR_GOLD, , true);
			}
		}
		i++;
	}
	return;
}

function setRewardItem(array<int> RewardIDList, array<INT64> rewardNumList)
{
	local int i;
	local string treeName, setTreeName, strRetName;
	local bool bDrawBgTreeReward;
	local string IconName, ItemName;

	treeName = "QuestTreeDrawerWnd.QuestRewardItemTree";
	TreeClear(treeName);
	bDrawBgTreeReward = false;
	util.TreeInsertRootNode(treeName, "List", "", 0, 2);
	setTreeName = "List";
	i = 0;
	while((i < RewardIDList.Length))
	{
		strRetName = util.TreeInsertItemNode(treeName, string(i), setTreeName, false, -4, -2);
		if(!bDrawBgTreeReward)
		{
			util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_CH3.etc.textbackline", 244, 38, , , , , 14);
		}
		else
		{
			util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_CT1.EmptyBtn", 244, 38);
		}
		bDrawBgTreeReward = !bDrawBgTreeReward;
		util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -238, 2);
		switch(RewardIDList[i])
		{
			case 57:
				IconName = Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(GetItemID(57));
				ItemName = GetSystemString(469);
				util.TreeInsertTextureNodeItem(treeName, strRetName, IconName, 32, 32, -34, 3);
				util.TreeInsertTextNodeItem(treeName, strRetName, ItemName, 5, 6, COLOR_DEFAULT, true);
				if((rewardNumList[i] == INT64(0)))
				{
					util.TreeInsertTextNodeItem(treeName, strRetName, GetSystemString(584), 48, -18, COLOR_GOLD, , true);
				}
				else
				{
					util.TreeInsertTextNodeItem(treeName, strRetName, MakeFullSystemMsg(GetSystemMessage(2932), MakeCostString(string(rewardNumList[i])), ""), 48, -18, COLOR_GOLD, , true);
				}
				break;
			default:
				IconName = Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(GetItemID(RewardIDList[i]));
				ItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(RewardIDList[i]));
				util.TreeInsertTextureNodeItem(treeName, strRetName, IconName, 32, 32, -34, 3);
				util.TreeInsertTextNodeItem(treeName, strRetName, ItemName, 5, 6, COLOR_DEFAULT, true, , RewardIDList[i]);
				if((rewardNumList[i] == INT64(0)))
				{
					util.TreeInsertTextNodeItem(treeName, strRetName, GetSystemString(584), 48, -18, COLOR_GOLD, , true);
				}
				else if(((((((((((((RewardIDList[i] == 15623) || (RewardIDList[i] == 15624)) || (RewardIDList[i] == 15625)) || (RewardIDList[i] == 15626)) || (RewardIDList[i] == 15627)) || (RewardIDList[i] == 15628)) || (RewardIDList[i] == 15629)) || (RewardIDList[i] == 15630)) || (RewardIDList[i] == 15631)) || (RewardIDList[i] == 15632)) || (RewardIDList[i] == 15633)) || (RewardIDList[i] == 47130)))
				{
					util.TreeInsertTextNodeItem(treeName, strRetName, MakeCostString(string(rewardNumList[i])), 48, -18, COLOR_GOLD, , true);
				}
				else if((RewardIDList[i] == 95641))
				{
					util.TreeInsertTextNodeItem(treeName, strRetName, MakeFullSystemMsg(GetSystemMessage(13405), MakeCostString(string(rewardNumList[i])), ""), 48, -18, COLOR_GOLD, , true);
				}
				else
				{
					util.TreeInsertTextNodeItem(treeName, strRetName, MakeFullSystemMsg(GetSystemMessage(1983), MakeCostString(string(rewardNumList[i])), ""), 48, -18, COLOR_GOLD, , true);
				}
				break;
		}
		i++;
	}
	return;
}

function setQuestItemShow(bool B)
{
	if(B)
	{
		QuestDescriptionLargeTree.HideWindow();
		QuestDescriptionTree.ShowWindow();
		txtQuestItemTitle.ShowWindow();
		GroupBox_DescriptionTree.ShowWindow();
		GroupBox_ItemTree.ShowWindow();
		QuestItemTree.ShowWindow();
	}
	else
	{
		QuestDescriptionTree.HideWindow();
		QuestDescriptionLargeTree.ShowWindow();
		txtQuestItemTitle.HideWindow();
		QuestItemTree.HideWindow();
		GroupBox_DescriptionTree.HideWindow();
		GroupBox_ItemTree.HideWindow();
	}
	return;
}

function TreeClear(string Str)
{
	Class'NWindow.UIAPI_TREECTRL'.static.Clear(Str);
	return;
}

function selectQuestLastCall(int selectQuest)
{
	local int Level, i;
	local string QuestParam;
	local int Max;
	local array<int> arrItemIDList, arrItemNumList, arrGoalType;

	Level = 0;
	Level = util.GetQuestLevelForID(selectQuest);
	QuestParam = Class'NWindow.UIDATA_QUEST'.static.GetQuestItem(selectQuest, Level);
	ParseInt(QuestParam, "Max", Max);
	arrItemIDList.Length = Max;
	arrItemNumList.Length = Max;
	arrGoalType.Length = Max;
	i = 0;
	while((i < Max))
	{
		ParseInt(QuestParam, ("GoalID_" $ string(i)), arrItemIDList[i]);
		ParseInt(QuestParam, ("GoalNum_" $ string(i)), arrItemNumList[i]);
		ParseInt(QuestParam, ("GoalType_" $ string(i)), arrGoalType[i]);
		i++;
	}
	SelectQuestID = selectQuest;
	SelectLevel = Level;
	SelectarrItemID = arrItemIDList;
	SelectarrItemNumList = arrItemNumList;
	SelectarrGoalType = arrGoalType;
	return;
}

function OnHide()
{
	allclear();
	return;
}

function allclear()
{
	util.TreeClear("QuestTreeDrawerWnd.QuestItemTree");
	util.TreeClear("QuestTreeDrawerWnd.QuestRewardItemTree");
	util.TreeClear("QuestTreeDrawerWnd.QuestDescriptionTree");
	util.TreeClear("QuestTreeDrawerWnd.QuestDescriptionLargeTree");
	txtQuestTitle.SetText("");
	txtRecommandedLevel.SetText("");
	txtRecommandedLevelText.SetText("");
	txtQuestType.SetText("");
	btnGiveUpCurrentQuest.DisableWindow();
	return;
}
