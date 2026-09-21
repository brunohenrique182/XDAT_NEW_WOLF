class QuestTreeWnd extends UICommonAPI;

const QUESTTREEWND_MAX_COUNT = 40;
const QUEST_WINDOW_ONE = 0;
const QUEST_WINDOW_REPEAT = 1;
const QUEST_WINDOW_EPIC = 2;
const QUEST_WINDOW_JOB = 3;
const QUEST_WINDOW_SPECIAL = 4;

struct QuestUseInfo
{
	var int QuestID;
	var int Level;
	var int Completed;
	var int QuestType;
	var bool bShowCompletionItem;
	var array<int> ArrNeedItemIDList;
	var array<int> ArrNeedItemNumList;
	var array<int> arrGoalType;
	var array<int> RewardIDList;
	var array<INT64> rewardNumList;
};

var WindowHandle Me;
var TabHandle QuestTreeTab;
var TextureHandle TexTabBg;
var TextureHandle TexTabBgLine;
var TextBoxHandle txtQuestTreeTitle;
var TextBoxHandle txtQuestNum;
var TreeHandle MainTree0;
var TreeHandle MainTree1;
var TreeHandle CurTree;
var CheckBoxHandle chkAssignNotifier;
var CheckBoxHandle chkNpcPosBox;
var ButtonHandle btnDetailInfo;
var string ROOTNAME;
var string TREE0;
var string TREE1;
var string TREE2;
var string TREE3;
var string TREE4;
var array<QuestUseInfo> ArrQuest;
var bool bDrawBgTree;
var string beforeTreeName;
var QuestAlarmWnd scQuestAlarm;
var QuestTreeDrawerWnd scTreeDrawer;
var ButtonHandle m_btnAddAlarm;
var ButtonHandle m_btnDeleteAlarm;
var L2Util util;
var int QuestID_Alarm;
var int QuestLevel_Alarm;
var int QuestEnd_Alarm;
var int m_QuestNum;
var int m_OldQuestID;
var ListCtrlHandle ListTrackItem1;
var array<LVDataRecord> m_QuestTrackData;
var int m_TrackID;
var int m_DeleteQuestID;
var string m_DeleteNodeName;
var string m_Windowname;
var int m_recentlyQuestID;
var NoticeWnd NoticeWndScript;
var Vector currentQuestDirectTargetPos;
var string currentQuestDirectTargetString;
var bool QuestAutoAlarm;

static function QuestTreeWnd Inst()
{
	return QuestTreeWnd(GetScript("QuestTreeWnd"));
}

event OnRegisterEvent()
{
	RegisterEvent(700);
	RegisterEvent(710);
	RegisterEvent(720);
	RegisterEvent(730);
	RegisterEvent(1710);
	RegisterEvent(40);
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	util = L2Util(GetScript("L2Util"));
	scQuestAlarm = QuestAlarmWnd(GetScript("QuestAlarmWnd"));
	scTreeDrawer = QuestTreeDrawerWnd(GetScript("QuestTreeDrawerWnd"));
	NoticeWndScript = NoticeWnd(GetScript("NoticeWnd"));
	CurTree = MainTree0;
	chkNpcPosBox.SetCheck(true);
	bDrawBgTree = false;
	m_QuestNum = 0;
	m_OldQuestID = 0;
	m_recentlyQuestID = 0;
	return;
}

function Initialize()
{
	Me = GetWindowHandle(m_Windowname);
	QuestTreeTab = GetTabHandle((m_Windowname $ ".QuestTreeTab"));
	TexTabBg = GetTextureHandle((m_Windowname $ ".TexTabBg"));
	TexTabBgLine = GetTextureHandle((m_Windowname $ ".TexTabBgLine"));
	txtQuestTreeTitle = GetTextBoxHandle((m_Windowname $ ".txtQuestTreeTitle"));
	txtQuestNum = GetTextBoxHandle((m_Windowname $ ".txtQuestNum"));
	MainTree0 = GetTreeHandle((m_Windowname $ ".MainTree0"));
	MainTree1 = GetTreeHandle((m_Windowname $ ".MainTree1"));
	chkAssignNotifier = GetCheckBoxHandle((m_Windowname $ ".chkAssignNotifier"));
	chkNpcPosBox = GetCheckBoxHandle((m_Windowname $ ".chkNpcPosBox"));
	btnDetailInfo = GetButtonHandle((m_Windowname $ ".btnDetailInfo"));
	m_btnAddAlarm = GetButtonHandle("QuestTreeDrawerWnd.btnAddAlarm");
	m_btnDeleteAlarm = GetButtonHandle("QuestTreeDrawerWnd.btnDeleteAlarm");
	return;
}

function OnDefaultPosition()
{
	QuestTreeTab.MergeTab(0);
	QuestTreeTab.MergeTab(3);
	QuestTreeTab.SetTopOrder(0, true);
	return;
}

function OnShow()
{
	local string ExpandedNode;
	local int nQuestType;

	QuestTreeTab.InitTabCtrl();
	ExpandedNode = GetExpandedNode();
	nQuestType = Class'NWindow.UIDATA_QUEST'.static.GetQuestIscategory(getCurQuestID(), 1);
	ShowQuestList();
	CurTree = GetTreeHandle(((m_Windowname $ ".MainTree") $ string(getTreeNum(nQuestType))));
	if((ExpandedNode != "NULL"))
	{
		QuestTreeTab.SetTopOrder(getTreeNum(nQuestType), false);
		CurTree.SetExpandedNode(ExpandedNode, true);
		CheckQuestTrackList();
	}
	QuestAutoAlarm = GetOptionBool("Game", "autoQuestAlarm");
	scQuestAlarm.UpdateOptionData();
	if((QuestAutoAlarm == true))
	{
		chkAssignNotifier.SetCheck(true);
	}
	else
	{
		chkAssignNotifier.SetCheck(false);
	}
	CurTree.SetFocus();
	return;
}

function ShowQuestList()
{
	Class'NWindow.QuestAPI'.static.RequestQuestList();
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnClose":
			if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("QuestTreeDrawerWnd"))
			{
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow("QuestTreeDrawerWnd");
			}
			else
			{
				UpdateTargetInfo();
				Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("QuestTreeDrawerWnd");
			}
			break;
		case "QuestTreeTab0":
			setTabChange(0);
			break;
		case "QuestTreeTab1":
			setTabChange(1);
			break;
		case "btnDetailInfo":
			OnbtnDetailInfoClick();
			break;
		default:
			break;
	}
	selectQuestTree(strID, true);
	return;
}

function selectQuestTree(string strID, bool isButtonClick)
{
	local int SplitCount;
	local array<string> arrSplit;

	if((Left(strID, 4) == ROOTNAME))
	{
		SplitCount = Split(strID, ".", arrSplit);
		if((isButtonClick == false))
		{
			CurTree.SetExpandedNode(strID, true);
		}
		m_recentlyQuestID = 0;
		UpdateTargetInfo();
		if((GetExpandedNode() == ""))
		{
			if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("QuestTreeDrawerWnd"))
			{
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow("QuestTreeDrawerWnd");
			}
		}
		else
		{
			if((SplitCount == 2))
			{
				scTreeDrawer.showQuestDrawer(LastNodeName(int(arrSplit[1]), 1, Class'NWindow.UIDATA_QUEST'.static.GetQuestIscategory(int(arrSplit[1]), 1)));
			}
			else if((SplitCount == 4))
			{
				scTreeDrawer.showQuestDrawer(strID);
			}
			ButtonEnableCheck();
		}
	}
	return;
}

function setTabChange(int Select)
{
	local array<string> arrSplit;
	local int SplitCount;
	local string ExpandedNode;

	CurTree.HideWindow();
	CurTree = GetTreeHandle(((m_Windowname $ ".MainTree") $ string(Select)));
	GetTreeHandle(((m_Windowname $ ".MainTree") $ string(Select))).ShowWindow();
	scTreeDrawer.btnGiveUpCurrentQuest.DisableWindow();
	ExpandedNode = GetExpandedNode();
	UpdateTargetInfo();
	if((ExpandedNode == ""))
	{
		if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("QuestTreeDrawerWnd"))
		{
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow("QuestTreeDrawerWnd");
		}
	}
	else if((Left(GetExpandedNode(), 4) == ROOTNAME))
	{
		SplitCount = Split(ExpandedNode, ".", arrSplit);
		if((SplitCount == 2))
		{
			scTreeDrawer.showQuestDrawer(LastNodeName(int(arrSplit[1]), 1, Class'NWindow.UIDATA_QUEST'.static.GetQuestIscategory(int(arrSplit[1]), 1)));
		}
		else if((SplitCount == 4))
		{
			scTreeDrawer.showQuestDrawer(ExpandedNode);
		}
		ButtonEnableCheck();
	}
	if((Select != 4))
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((m_Windowname $ ".txtQuestNum"));
	}
	else
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".txtQuestNum"));
	}
	return;
}

function OnClickCheckBox(string strID)
{
	switch(strID)
	{
		case "chkNpcPosBox":
			UpdateTargetInfo();
			break;
		case "chkAssignNotifier":
			if(chkAssignNotifier.IsChecked())
			{
				SetOptionBool("Game", "autoQuestAlarm", true);
				QuestAutoAlarm = true;
			}
			else
			{
				SetOptionBool("Game", "autoQuestAlarm", false);
				QuestAutoAlarm = false;
			}
			scQuestAlarm.UpdateOptionData();
			break;
		default:
			break;
	}
	return;
}

function OnbtnDetailInfoClick()
{
	Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("QuestTreeDrawerWnd");
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 700))
	{
		HandleQuestListStart();
	}
	else if((Event_ID == 710))
	{
		HandleQuestList(param);
	}
	else if((Event_ID == 720))
	{
		HandleQuestListEnd();
		InsertQuestTrackList();
		ButtonEnableCheck();
	}
	else if((Event_ID == 730))
	{
		HandleQuestSetCurrentID(param);
		CurTree.SetFocus();
		Me.SetFocus();
	}
	else if((Event_ID == 1710))
	{
		if(DialogIsMine())
		{
			if((DialogGetID() == 0))
			{
				scQuestAlarm.DeleteQuestAlarm(m_DeleteQuestID);
				Class'NWindow.QuestAPI'.static.RequestDestroyQuest(m_DeleteQuestID);
				SetQuestOff();
				CurTree.DeleteNode(m_DeleteNodeName);
				m_DeleteQuestID = 0;
				m_DeleteNodeName = "";
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow("QuestTreeDrawerWnd");
			}
		}
	}
	else if((Event_ID == 40))
	{
		SetQuestOff();
	}
	return;
}

function curQuestExpand(int QuestID)
{
	m_recentlyQuestID = QuestID;
	return;
}

function HandleQuestListStart()
{
	initTree();
	initVars();
	return;
}

function HandleQuestList(string param)
{
	local int i, QuestID, Level, Completed, nQuestType;
	local string QuestParam;
	local int Max;

	ParseInt(param, "QuestID", QuestID);
	ParseInt(param, "Level", Level);
	ParseInt(param, "Completed", Completed);
	nQuestType = Class'NWindow.UIDATA_QUEST'.static.GetQuestIscategory(QuestID, Level);
	ArrQuest.Insert(ArrQuest.Length, 1);
	ArrQuest[(ArrQuest.Length - 1)].QuestID = QuestID;
	ArrQuest[(ArrQuest.Length - 1)].Level = Level;
	ArrQuest[(ArrQuest.Length - 1)].Completed = Completed;
	ArrQuest[(ArrQuest.Length - 1)].QuestType = nQuestType;
	if((Completed == 0))
	{
		QuestParam = Class'NWindow.UIDATA_QUEST'.static.GetQuestItem(QuestID, Level);
		ParseInt(QuestParam, "Max", Max);
		ArrQuest[(ArrQuest.Length - 1)].ArrNeedItemIDList.Length = Max;
		ArrQuest[(ArrQuest.Length - 1)].ArrNeedItemNumList.Length = Max;
		ArrQuest[(ArrQuest.Length - 1)].arrGoalType.Length = Max;
		i = 0;
		while((i < Max))
		{
			ParseInt(QuestParam, ("GoalID_" $ string(i)), ArrQuest[(ArrQuest.Length - 1)].ArrNeedItemIDList[i]);
			ParseInt(QuestParam, ("GoalNum_" $ string(i)), ArrQuest[(ArrQuest.Length - 1)].ArrNeedItemNumList[i]);
			ParseInt(QuestParam, ("GoalType_" $ string(i)), ArrQuest[(ArrQuest.Length - 1)].arrGoalType[i]);
			i++;
		}
		Class'NWindow.UIDATA_QUEST'.static.GetQuestReward(QuestID, Level, ArrQuest[(ArrQuest.Length - 1)].RewardIDList, ArrQuest[(ArrQuest.Length - 1)].rewardNumList);
	}
	if((m_OldQuestID != QuestID))
	{
		if((nQuestType != 4))
		{
			m_QuestNum++;
		}
	}
	m_OldQuestID = QuestID;
	return;
}

function bool isQuestIDSearch(int QuestID)
{
	local int i, questLen;
	local bool flag;

	flag = false;
	questLen = ArrQuest.Length;
	i = 0;
	while((i < questLen))
	{
		if((QuestID == ArrQuest[i].QuestID))
		{
			flag = true;
			break;
		}
		i++;
	}
	return flag;
}

function HandleQuestListEnd()
{
	local int i, j, nQuestType;

	if((m_QuestNum == 0))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("QuestTreeDrawerWnd");
		scTreeDrawer.allclear();
	}
	setTreeQuestList();
	i = 0;
	while((i < ArrQuest.Length))
	{
		j = 0;
		while((j < 5))
		{
			if(((ArrQuest[i].QuestID == scQuestAlarm.QuestAlarmNameID[j]) && (ArrQuest[i].Level == scQuestAlarm.QuestAlarmLevel[j])))
			{
				if((ArrQuest[i].Completed == 1))
				{
					scQuestAlarm.DeleteQuestAlarm(scQuestAlarm.QuestAlarmNameID[j]);
				}
			}
			j++;
		}
		i++;
	}
	j = 0;
	while((j < 5))
	{
		if((scQuestAlarm.QuestAlarmNameID[j] != -1))
		{
			findNowQuestExist(scQuestAlarm.QuestAlarmNameID[j]);
		}
		j++;
	}
	UpdateQuestCount();
	if((m_recentlyQuestID != 0))
	{
		nQuestType = Class'NWindow.UIDATA_QUEST'.static.GetQuestIscategory(m_recentlyQuestID, 1);
		QuestTreeTab.SetTopOrder(getTreeNum(nQuestType), false);
		setCurrentTree(nQuestType);
		CurTree.SetExpandedNode(("root." $ string(m_recentlyQuestID)), true);
		scTreeDrawer.showQuestDrawer(("root." $ string(m_recentlyQuestID)));
		scTreeDrawer.showQuestDrawer(LastNodeName(m_recentlyQuestID, 1, nQuestType));
	}
	Detele3DArrow();
	return;
}

function Detele3DArrow()
{
	local int QuestID;
	local Vector vTargetPos;

	QuestID = getCurQuestID();
	if((QuestID == 0))
	{
		if(!IsPlayerOnWorldRaidServer())
		{
			Class'NWindow.QuestAPI'.static.SetQuestTargetInfo(false, false, false, "", vTargetPos, QuestID, 0);
		}
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("QuestTreeDrawerWnd");
		CallGFxFunction("RadarMapWnd", "hideQuestTargetInfo", "");
		CallGFxFunction("MiniMapGfxWnd", "hideQuestTargetInfo", "");
	}
	return;
}

function findNowQuestExist(int QuestID)
{
	local int i;
	local bool isExist;

	i = 0;
	while((i < ArrQuest.Length))
	{
		if((ArrQuest[i].QuestID == QuestID))
		{
			isExist = true;
			break;
		}
		i++;
	}
	if(!isExist)
	{
		scQuestAlarm.DeleteQuestAlarm(QuestID);
		if((int(GetReleaseMode()) == 0))
		{
		}
		else if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("NoticeWnd"))
		{
			NoticeWndScript.hideNoticeButton_QUEST();
		}
	}
	return;
}

function initTree()
{
	MainTree0.Clear();
	MainTree1.Clear();
	return;
}

function initVars()
{
	m_QuestNum = 0;
	m_OldQuestID = 0;
	m_TrackID = 0;
	m_DeleteQuestID = 0;
	m_DeleteNodeName = "";
	ArrQuest.Remove(0, ArrQuest.Length);
	return;
}

function setTreeQuestList()
{
	local int i;
	local string treeName, questName, journalName, setTreeName, strRetName;
	local LVDataRecord Record;
	local LVData data1, data2;

	i = 0;
	while((i < ArrQuest.Length))
	{
		treeName = ((m_Windowname $ ".MainTree") $ string(getTreeNum(ArrQuest[i].QuestType)));
		setTreeName = ((ROOTNAME $ ".") $ string(ArrQuest[i].QuestID));
		journalName = Class'NWindow.UIDATA_QUEST'.static.GetQuestJournalName(ArrQuest[i].QuestID, ArrQuest[i].Level);
		journalName = Class'NWindow.UIDATA_QUEST'.static.GetQuestJournalNameSplit(journalName, ArrQuest[i].Completed);
		if(Class'NWindow.UIAPI_TREECTRL'.static.IsNodeNameExist(treeName, setTreeName))
		{
			questName = Class'NWindow.UIDATA_QUEST'.static.GetQuestName(ArrQuest[i].QuestID, ArrQuest[i].Level);
			Class'NWindow.UIAPI_TREECTRL'.static.SetNodeItemText(treeName, setTreeName, 0, questName);
		}
		else
		{
			questName = Class'NWindow.UIDATA_QUEST'.static.GetQuestName(ArrQuest[i].QuestID, ArrQuest[i].Level);
			util.TreeInsertRootNode(treeName, ROOTNAME, "", 0, 4);
			util.TreeInsertExpandBtnNode(treeName, string(ArrQuest[i].QuestID), ROOTNAME);
			util.TreeInsertTextNodeItem(treeName, ((ROOTNAME $ ".") $ string(ArrQuest[i].QuestID)), questName, 5, 0, COLOR_DEFAULT, true);
			data1.nReserved1 = ArrQuest[i].QuestID;
			data2.nReserved2 = ArrQuest[i].Level;
			data1.nReserved3 = ArrQuest[i].QuestType;
			data1.szData = questName;
			Record.LVDataList[0] = data1;
			Record.LVDataList[1] = data2;
			m_QuestTrackData[m_TrackID] = Record;
			m_TrackID = (m_TrackID + 1);
		}
		strRetName = QuestJournalNodeMake(treeName, setTreeName, ArrQuest[i].Level, ArrQuest[i].Completed);
		if(bDrawBgTree)
		{
			util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_CH3.etc.textbackline", 209, 24, 4, , , , 14);
		}
		else
		{
			util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_CT1.EmptyBtn", 209, 24, 4);
		}
		bDrawBgTree = !bDrawBgTree;
		if((ArrQuest[i].Completed == 1))
		{
			util.TreeInsertTextNodeItem(treeName, strRetName, (("(" $ GetSystemString(898)) $ ")"), -202, 7, COLOR_GOLD, true);
			util.TreeInsertTextNodeItem(treeName, strRetName, journalName, 4, 7, COLOR_GRAY, true);
			i++;
			continue;
		}
		util.TreeInsertTextNodeItem(treeName, strRetName, journalName, -202, 7, COLOR_GRAY, true);
		i++;
	}
	return;
}

function setMiniMapTrackInsert(int QuestID, int Level, int nQuestType)
{
	return;
}

function string QuestJournalNodeMake(string treeName, string parentname, int Level, int Completed)
{
	local XMLTreeNodeInfo infNode;

	infNode.strName = ((("" $ string(Level)) $ ".") $ string(Completed));
	infNode.nOffSetX = 14;
	infNode.bShowButton = 0;
	infNode.bDrawBackground = 1;
	infNode.bTexBackHighlight = 0;
	infNode.nTexBackHighlightHeight = 15;
	infNode.nTexBackWidth = 211;
	infNode.nTexBackUWidth = 211;
	infNode.nTexBackOffSetX = 3;
	infNode.nTexBackOffSetY = 0;
	infNode.nTexBackOffSetBottom = 1;
	return Class'NWindow.UIAPI_TREECTRL'.static.InsertNode(treeName, parentname, infNode);
}

function Vector getCurrentQuestDirectTargetPos()
{
	return currentQuestDirectTargetPos;
}

function string getCurrentQuestDirectTargetString()
{
	return currentQuestDirectTargetString;
}

function UpdateTargetNoneCheckPosBox(bool ShowArrow)
{
	local array<string> arrSplit;
	local int SplitCount, QuestID, Level, Completed;
	local string strChildList, strTargetNode, strNodeName, strTargetName;
	local Vector vTargetPos;
	local bool bOnlyMinimap;
	local string strParam;

	strNodeName = GetExpandedNode();
	if((Len(strNodeName) < 1))
	{
		SetQuestOff();
		return;
	}
	strChildList = CurTree.GetChildNode(strNodeName);
	if((Len(strChildList) > 0))
	{
		SplitCount = Split(strChildList, "|", arrSplit);
		strTargetNode = arrSplit[(SplitCount - 1)];
	}
	else
	{
		SetQuestOff();
		return;
	}
	arrSplit.Remove(0, arrSplit.Length);
	SplitCount = Split(strTargetNode, ".", arrSplit);
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
	if(((QuestID > 0) && (Level > 0)))
	{
		strTargetName = Class'NWindow.UIDATA_QUEST'.static.GetTargetName(QuestID, Level);
		vTargetPos = Class'NWindow.UIDATA_QUEST'.static.GetTargetLoc(QuestID, Level);
		ParamAdd(strParam, "X", string(vTargetPos.X));
		ParamAdd(strParam, "Y", string(vTargetPos.Y));
		ParamAdd(strParam, "Z", string(vTargetPos.Z));
		ParamAdd(strParam, "targetName", strTargetName);
		ParamAdd(strParam, "QuestID", string(QuestID));
		ParamAdd(strParam, "QuestLevel", string(Level));
		ParamAdd(strParam, "questName", Class'NWindow.UIDATA_QUEST'.static.GetQuestName(QuestID, Level));
		CallGFxFunction("RadarMapWnd", "showQuestTargetInfo", strParam);
		CallGFxFunction("MiniMapGfxWnd", "showQuestTargetInfo", strParam);
		if(((Completed == 0) && (Len(strTargetName) > 0)))
		{
			bOnlyMinimap = Class'NWindow.UIDATA_QUEST'.static.IsMinimapOnly(QuestID, Level);
			if(bOnlyMinimap)
			{
				if(!IsPlayerOnWorldRaidServer())
				{
					Class'NWindow.QuestAPI'.static.SetQuestTargetInfo(true, false, false, strTargetName, vTargetPos, QuestID, Level);
				}
			}
			else if(!IsPlayerOnWorldRaidServer())
			{
				Class'NWindow.QuestAPI'.static.SetQuestTargetInfo(true, true, ShowArrow, strTargetName, vTargetPos, QuestID, Level);
			}
		}
		else
		{
			SetQuestOff();
		}
	}
	return;
}

function UpdateTargetInfo()
{
	if(!chkNpcPosBox.IsChecked())
	{
		SetQuestOff();
		return;
	}
	UpdateTargetNoneCheckPosBox(true);
	return;
}

function SetQuestOff()
{
	local Vector vVector, emptyLoc;

	if(!IsPlayerOnWorldRaidServer())
	{
		Class'NWindow.QuestAPI'.static.SetQuestTargetInfo(false, false, false, "", vVector, 0, 0);
	}
	CallGFxFunction("RadarMapWnd", "hideQuestTargetInfo", "");
	CallGFxFunction("MiniMapGfxWnd", "hideQuestTargetInfo", "");
	QuestID_Alarm = -1;
	QuestLevel_Alarm = -1;
	QuestEnd_Alarm = -1;
	m_recentlyQuestID = 0;
	currentQuestDirectTargetPos = emptyLoc;
	currentQuestDirectTargetString = "";
	return;
}

function string GetExpandedNode()
{
	local array<string> arrSplit;
	local int SplitCount;
	local string strNodeName;

	strNodeName = CurTree.GetExpandedNode("root");
	SplitCount = Split(strNodeName, "|", arrSplit);
	if((SplitCount > 0))
	{
		strNodeName = arrSplit[0];
	}
	return strNodeName;
}

function ButtonEnableCheck()
{
	local int i, M, QuestIDSlot;
	local bool isCanBeAddAlarm;

	QuestAutoAlarm = GetOptionBool("Game", "autoQuestAlarm");
	GetNodeInfo_Alarm();
	isCanBeAddAlarm = false;
	i = 0;
	while((i < ArrQuest.Length))
	{
		if((ArrQuest[i].QuestID == QuestID_Alarm))
		{
			if((ArrQuest[i].ArrNeedItemIDList.Length > 0))
			{
				isCanBeAddAlarm = true;
				break;
			}
			M = 0;
			while((M < ArrQuest[i].arrGoalType.Length))
			{
				if((ArrQuest[i].arrGoalType[M] == 1))
				{
					isCanBeAddAlarm = true;
					break;
				}
				M++;
			}
		}
		i++;
	}
	QuestIDSlot = scQuestAlarm.QuestSlotIdx(QuestID_Alarm);
	if((QuestID_Alarm <= 0))
	{
		m_btnAddAlarm.DisableWindow();
		m_btnDeleteAlarm.DisableWindow();
	}
	else if((QuestIDSlot < 0))
	{
		if((isCanBeAddAlarm == true))
		{
			m_btnAddAlarm.EnableWindow();
			m_btnDeleteAlarm.DisableWindow();
		}
		else
		{
			m_btnAddAlarm.DisableWindow();
			m_btnDeleteAlarm.DisableWindow();
		}
	}
	else
	{
		m_btnAddAlarm.DisableWindow();
		m_btnDeleteAlarm.EnableWindow();
	}
	return;
}

function GetNodeInfo_Alarm()
{
	local string strNodeName, strTargetNode;
	local int i;
	local array<string> arrSplit;
	local int SplitCount;
	local string strChildList;

	strNodeName = GetExpandedNode();
	strChildList = CurTree.GetChildNode(strNodeName);
	if((Len(strChildList) > 0))
	{
		SplitCount = Split(strChildList, "|", arrSplit);
		strTargetNode = arrSplit[(SplitCount - 1)];
	}
	else
	{
		SetQuestOff();
		return;
	}
	arrSplit.Remove(0, arrSplit.Length);
	SplitCount = Split(strTargetNode, ".", arrSplit);
	i = 0;
	while((i < SplitCount))
	{
		switch(i)
		{
			case 0:
				break;
			case 1:
				QuestID_Alarm = int(arrSplit[i]);
				break;
			case 2:
				QuestLevel_Alarm = int(arrSplit[i]);
				break;
			case 2:
				QuestEnd_Alarm = int(arrSplit[i]);
				break;
			default:
				break;
		}
		i++;
	}
	return;
}

function HandleDeleteAlarm()
{
	local int i;

	GetNodeInfo_Alarm();
	i = 0;
	while((i < ArrQuest.Length))
	{
		if((ArrQuest[i].QuestID == QuestID_Alarm))
		{
			scQuestAlarm.DeleteQuestAlarm(QuestID_Alarm);
		}
		i++;
	}
	ButtonEnableCheck();
	return;
}

function UpdateQuestCount()
{
	txtQuestNum.SetText((((("(" $ string(m_QuestNum)) $ "/") $ string(40)) $ ")"));
	return;
}

function setCurrentTree(int nQuestType)
{
	switch(nQuestType)
	{
		case 3:
			CurTree = MainTree0;
			break;
		default:
			CurTree = MainTree1;
	}
	return;
}

function int getTreeNum(int nQuestType)
{
	local int treeNum;

	switch(nQuestType)
	{
		case 3:
			treeNum = 0;
			break;
		default:
			treeNum = 1;
	}
	return treeNum;
}

function HandleQuestSetCurrentID(string param)
{
	local string strNodeName, strChildList;
	local int RecentlyAddedQuestID, SplitCount, nQuestType;
	local array<string> arrSplit;

	if(!ParseInt(param, "QuestID", RecentlyAddedQuestID))
	{
		return;
	}
	if((RecentlyAddedQuestID > 0))
	{
		nQuestType = Class'NWindow.UIDATA_QUEST'.static.GetQuestIscategory(RecentlyAddedQuestID, 1);
		setCurrentTree(nQuestType);
		QuestTreeTab.SetTopOrder(getTreeNum(nQuestType), false);
		strNodeName = ("root." $ string(RecentlyAddedQuestID));
		CurTree.SetExpandedNode(strNodeName, true);
		if(!Me.IsShowWindow())
		{
			Me.ShowWindow();
			PlayConsoleSound(IFST_WINDOW_OPEN);
		}
		strChildList = CurTree.GetChildNode(strNodeName);
		if((Len(strChildList) > 0))
		{
			SplitCount = Split(strChildList, "|", arrSplit);
			CurTree.SetExpandedNode(arrSplit[(SplitCount - 1)], true);
		}
		if((Left(strNodeName, 4) == "root"))
		{
			scTreeDrawer.showQuestDrawer(arrSplit[(SplitCount - 1)]);
		}
		UpdateTargetInfo();
		RequestAddExpandQuestAlarm(RecentlyAddedQuestID);
		selectQuestTree(strNodeName, false);
		if((QuestAutoAlarm == false))
		{
			scTreeDrawer.OnbtnAddAlarmClick();
		}
	}
	return;
}

function _HandleQuestSetCurrentIDfromMiniMap(int QuestID, int Level, int nQuestType)
{
	local string strNodeName, strChildList;
	local int RecentlyAddedQuestID, SplitCount;
	local array<string> arrSplit;

	RecentlyAddedQuestID = QuestID;
	setCurrentTree(nQuestType);
	QuestTreeTab.SetTopOrder(getTreeNum(nQuestType), false);
	if((RecentlyAddedQuestID > 0))
	{
		strNodeName = ("root." $ string(RecentlyAddedQuestID));
		CurTree.SetExpandedNode(strNodeName, true);
		strChildList = CurTree.GetChildNode(strNodeName);
		if((Len(strChildList) > 0))
		{
			SplitCount = Split(strChildList, "|", arrSplit);
			CurTree.SetExpandedNode(arrSplit[(SplitCount - 1)], true);
		}
		UpdateTargetNoneCheckPosBox(true);
		if((Left(strNodeName, 4) == "root"))
		{
			scTreeDrawer.showQuestDrawer(arrSplit[(SplitCount - 1)]);
		}
	}
	return;
}

function CheckQuestTrackList()
{
	local int i, QuestID;

	QuestID = getCurQuestID();
	i = 0;
	while((i < m_TrackID))
	{
		if((m_QuestTrackData[i].LVDataList[0].nReserved1 == QuestID))
		{
			return;
		}
		i++;
	}
	return;
}

function InsertQuestTrackList()
{
	local int i, QuestID;

	QuestID = getCurQuestID();
	i = 0;
	while((i < m_TrackID))
	{
		if((m_QuestTrackData[i].LVDataList[0].nReserved1 == QuestID))
		{
		}
		i++;
	}
	return;
}

function int getCurQuestID()
{
	local int QuestID;
	local string strNodeName;
	local int SplitCount;
	local array<string> arrSplit;

	strNodeName = GetExpandedNode();
	SplitCount = Split(strNodeName, ".", arrSplit);
	if((SplitCount > 1))
	{
		QuestID = int(arrSplit[1]);
	}
	else
	{
		QuestID = 0;
	}
	return QuestID;
}

function HandleQuestCancel()
{
	local array<string> arrSplit;
	local int SplitCount;
	local string strNodeName, strDeleteQuestName, strDeleteQuestMessage;

	m_DeleteQuestID = 0;
	m_DeleteNodeName = "";
	strNodeName = GetExpandedNode();
	SplitCount = Split(strNodeName, "|", arrSplit);
	if((SplitCount > 0))
	{
		strNodeName = arrSplit[0];
		arrSplit.Remove(0, arrSplit.Length);
		SplitCount = Split(strNodeName, ".", arrSplit);
		if((SplitCount > 1))
		{
			m_DeleteQuestID = int(arrSplit[1]);
			m_DeleteNodeName = strNodeName;
		}
	}
	if((Len(m_DeleteNodeName) < 1))
	{
		strDeleteQuestMessage = GetSystemMessage(1201);
		DialogShow(DialogModalType_Modalless, DialogType_Notice, strDeleteQuestMessage);
		DialogSetID(1);
	}
	else
	{
		strDeleteQuestName = Class'NWindow.UIDATA_QUEST'.static.GetQuestName(m_DeleteQuestID, util.GetQuestLevelForID(m_DeleteQuestID));
		strDeleteQuestMessage = MakeFullSystemMsg(GetSystemMessage(182), strDeleteQuestName, "");
		DialogShow(DialogModalType_Modalless, DialogType_Warning, strDeleteQuestMessage);
		DialogSetID(0);
	}
	return;
}

function string LastNodeName(int QuestID, int Level, int nQuestType)
{
	local string strNodeName, strChildList;
	local int RecentlyAddedQuestID, SplitCount;
	local array<string> arrSplit;
	local TreeHandle tempCurTree;

	tempCurTree = CurTree;
	RecentlyAddedQuestID = QuestID;
	setCurrentTree(nQuestType);
	QuestTreeTab.SetTopOrder(getTreeNum(nQuestType), false);
	if((RecentlyAddedQuestID > 0))
	{
		strNodeName = ("root." $ string(RecentlyAddedQuestID));
		strChildList = CurTree.GetChildNode(strNodeName);
		if((Len(strChildList) > 0))
		{
			SplitCount = Split(strChildList, "|", arrSplit);
			CurTree.SetExpandedNode(arrSplit[(SplitCount - 1)], true);
		}
	}
	CurTree = tempCurTree;
	return arrSplit[(SplitCount - 1)];
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

defaultproperties
{
	ROOTNAME="root"
	m_Windowname="QuestTreeWnd"
}
