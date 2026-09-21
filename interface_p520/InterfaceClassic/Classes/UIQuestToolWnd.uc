class UIQuestToolWnd extends UICommonAPI
	dependson(UIPacket);

const TIMER_ID_UPDATELOCINFO = 10234568;

var ListCtrlHandle questListCtrl;
var HtmlHandle QuestHtmlViewer;
var ButtonHandle searchItemBtn;
var EditBoxHandle searchEditBox;
var EditBoxHandle itemCountEditBox;
var ButtonHandle InitBtn;
var ButtonHandle getItemBtn;
var TextBoxHandle etcTextBox;
var TextBoxHandle CTextBox;
var TextBoxHandle playerLocText;
var HtmlHandle DetailInfoHtmlCtrl;
var string htmlMsg;
var string QuestDescription;
var string selectNPCName;
var int freeNum;
var int chargeNum;
var int SelectQuestID;
var int bicIconLen;
var ItemInfo ItemInfo;
var Color redColor;
var bool apiChk;
var RichListCtrlHandle QuestListCtrl_RichList;
var UIControlDialogAssets teleportDialog;

function Initialize()
{
	questListCtrl = GetListCtrlHandle("UIQuestToolWnd.QuestListCtrl");
	QuestListCtrl_RichList = GetRichListCtrlHandle("UIQuestToolWnd.QuestListCtrl_RichList");
	QuestHtmlViewer = GetHtmlHandle("UIQuestToolWnd.QuestHtmlViewer");
	searchItemBtn = GetButtonHandle("UIQuestToolWnd.searchItemBtn");
	searchEditBox = GetEditBoxHandle("UIQuestToolWnd.searchEditBox");
	itemCountEditBox = GetEditBoxHandle("UIQuestToolWnd.itemCountEditBox");
	InitBtn = GetButtonHandle("UIQuestToolWnd.InitBtn");
	getItemBtn = GetButtonHandle("UIQuestToolWnd.getItemBtn");
	DetailInfoHtmlCtrl = GetHtmlHandle("UIQuestToolWnd.DetailInfoHtmlCtrl");
	etcTextBox = GetTextBoxHandle("UIQuestToolWnd.etcTextBox");
	CTextBox = GetTextBoxHandle("UIQuestToolWnd.cTextBox");
	playerLocText = GetTextBoxHandle("UIQuestToolWnd.playerLocText");
	teleportDialog = Class'InterfaceClassic.UIControlDialogAssets'.static.InitScript(GetWindowHandle("UIQuestToolWnd.UIControlDialogAsset"));
	teleportDialog.NeedItemRichListCtrl.SetColumnWidth(0, 220);
	if((getInstanceUIData().GetIsClassicServer() && !IsAdenServer()))
	{
		return;
	}
	GetButtonHandle("UIQuestToolWnd.getQuestButton").SetNameText("메뉴");  // EN?: Menu
	GetButtonHandle("UIQuestToolWnd.MoveStartNPCButton").SetNameText("내 퀘스트");  // EN?: My Quests
	GetButtonHandle("UIQuestToolWnd.MoveTargetLocButton").HideWindow();
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

event OnTimer(int TimerID)
{
	local Vector pVec;

	if((getInstanceUIData().GetIsClassicServer() && !IsAdenServer()))
	{
		return;
	}
	CTextBox.SetText("리스트 마우스 오른쪽 버튼 클릭 시 상태 메뉴");  // EN?: List right-click status menu
	if((TimerID == 10234568))
	{
		pVec = GetPlayerPosition();
		playerLocText.SetText((((((("CurrentPlayer Position" $ "\\nx") $ string(int(pVec.X))) $ " y") $ string(int(pVec.Y))) $ " z") $ string(int(pVec.Z))));
	}
	return;
}

event OnShow()
{
	m_hOwnerWnd.KillTimer(10234568);
	m_hOwnerWnd.SetTimer(10234568, 100);
	return;
}

event OnHide()
{
	m_hOwnerWnd.KillTimer(10234568);
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "searchItemBtn":
			OnsearchItemBtnClick();
			break;
		case "InitBtn":
			OnInitBtnClick();
			break;
		case "getQuestButton":
			if((getInstanceUIData().GetIsClassicServer() && !IsAdenServer()))
			{
				GetQuestButtonClick();
			}
			else
			{
				ShowContextMenu();
			}
			break;
		case "MoveStartNPCButton":
			if((getInstanceUIData().GetIsClassicServer() && !IsAdenServer()))
			{
				MoveStartNPCButtonClick();
			}
			else
			{
				SetMyQuests();
			}
			break;
		case "MoveTargetLocButton":
			MoveTargetLocButtonClick();
			break;
		default:
			HandleBtnByName(Name);
			break;
	}
	return;
}

event OnClickListCtrlRecord(string ListCtrlID)
{
	switch(ListCtrlID)
	{
		case "QuestListCtrl":
			addPinInTheMap(ListCtrlID, -1);
			break;
		case "QuestListCtrl_RichList":
			AddPinInTheGfxMap();
			break;
		default:
			break;
	}
	return;
}

event OnRClickListCtrlRecord(string ListCtrlID)
{
	switch(ListCtrlID)
	{
		case "QuestListCtrl":
			OnClickButton("MoveTargetLocButton");
			break;
		case "QuestListCtrl_RichList":
			ShowContextMenu();
			break;
		default:
			break;
	}
	return;
}

event OnDBClickListCtrlRecord(string ListCtrlID)
{
	local int QuestID, nSelect;
	local LVDataRecord dataRecord;

	nSelect = questListCtrl.GetSelectedIndex();
	if((ListCtrlID == "QuestListCtrl"))
	{
		if((nSelect >= 0))
		{
			questListCtrl.GetSelectedRec(dataRecord);
			QuestID = int(dataRecord.LVDataList[0].szData);
			if((QuestID > 0))
			{
				FindAllQuest(string(QuestID));
			}
		}
	}
	return;
}

function _ShowNQuestContextMenu(int qid)
{
	local UIControlContextMenu ContextMenu;
	local NQuestUIData o_data;
	local int mX, mY;

	if(!API_GetNQuestData(qid, o_data))
	{
		return;
	}
	ContextMenu = Class'InterfaceClassic.UIControlContextMenu'.static.GetInstance();
	ContextMenu.Clear();
	ContextMenu.DelegateOnClickContextMenu = HandleOnClickContextMenu;
	ContextMenu.MenuNew("퀘스트를 수락", 0);  // EN?: Accept Quest
	ContextMenu.MenuNew("퀘스트를 취소", 1);  // EN?: Cancel Quest
	ContextMenu.MenuNew("완료를 진행으로", 2);  // EN?: To Proceed to Completion
	ContextMenu.MenuNew("진행 횟수 변경", 3);  // EN?: Change the number of progress attempts
	ContextMenu.MenuNew("종료 상태로", 4);  // EN?: To Exit Status
	ContextMenu.MenuLineAdd();
	if((((o_data.Location.X != 0.0000000) && (o_data.Location.Y != 0.0000000)) && (o_data.Location.Z != 0.0000000)))
	{
		ContextMenu.MenuNew("퀘스트 위치로", 5);  // EN?: To Quest Position
	}
	else
	{
		ContextMenu.MenuNew("퀘스트 위치로", -1, getInstanceL2Util().Gray);  // EN?: To Quest Position
	}
	if((o_data.StartNPC.Id > 0))
	{
		ContextMenu.MenuNew("시작 NPC 위치로", 6);  // EN?: To Start NPC Position
	}
	else
	{
		ContextMenu.MenuNew("시작 NPC 위치로", -1, getInstanceL2Util().Gray);  // EN?: To Start NPC Position
	}
	if((o_data.EndNPC.Id > 0))
	{
		ContextMenu.MenuNew("종료 NPC 위치로", 7);  // EN?: to exit NPC position
	}
	else
	{
		ContextMenu.MenuNew("종료 NPC 위치로", -1, getInstanceL2Util().Gray);  // EN?: to exit NPC position
	}
	ContextMenu._SetReservedInt(qid);
	API_GetClientCursorPos(mX, mY);
	ContextMenu.Show(mX, mY, string(self));
	return;
}

function ShowContextMenu()
{
	local RichListCtrlRowData rowData;

	QuestListCtrl_RichList.GetSelectedRec(rowData);
	_ShowNQuestContextMenu(int(rowData.nReserved1));
	return;
}

function HandleOnClickContextMenu(int Index)
{
	local UIControlContextMenu ContextMenu;
	local NQuestUIData o_data;
	local int QuestID;

	ContextMenu = Class'InterfaceClassic.UIControlContextMenu'.static.GetInstance();
	QuestID = ContextMenu._GetReservedInt();
	if(!API_GetNQuestData(QuestID, o_data))
	{
		return;
	}
	Debug(("HandleOnClickContextMenu" @ string(Index)));
	switch(Index)
	{
		case 0:
			API_ExecuteCommand(("//setquestdata" @ string(QuestID)), true);
			break;
		case 1:
			API_ExecuteCommand(("//delquestdata" @ string(QuestID)), true);
			break;
		case 2:
			API_ExecuteCommand(("//resetquestdata" @ string(QuestID)), true);
			break;
		case 3:
			DialogShow(DialogModalType_Modalless, DialogType_NumberPad, ((((o_data.Name $ "\\n -") $ o_data.Goal.Name) $ "*") $ string(o_data.Goal.Num)));
			Class'InterfaceClassic.DialogBox'.static.Inst().AnchorToOwner(0, 200);
			DialogSetInputlimit(INT64(o_data.Goal.Num));
			DialogSetString(string(o_data.Goal.Num));
			DialogSetReservedInt(QuestID);
			Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnOK = HandleCountQuestDataDialogOK;
			Class'InterfaceClassic.DialogBox'.static.Inst()._AllSelect();
			break;
		case 4:
			API_ExecuteCommand(("//countquestdata_full" @ string(QuestID)), true);
			break;
		case 5:
			ProcessChatMessage(((("//teleport" @ string(o_data.Location.X)) @ string(o_data.Location.Y)) @ string(o_data.Location.Z)));
			break;
		case 6:
			ProcessChatMessage(((("//teleport" @ string(o_data.StartNPC.Location.X)) @ string(o_data.StartNPC.Location.Y)) @ string(o_data.StartNPC.Location.Z)));
			break;
		case 7:
			ProcessChatMessage(((("//teleport" @ string(o_data.EndNPC.Location.X)) @ string(o_data.EndNPC.Location.Y)) @ string(o_data.EndNPC.Location.Z)));
			break;
		default:
			break;
	}
	return;
}

function HandleCountQuestDataDialogOK()
{
	local int QuestID;

	QuestID = DialogGetReservedInt();
	ExecuteCommand((("//countquestdata" @ string(QuestID)) @ DialogGetString()));
	return;
}

function API_ExecuteCommand(string Command, optional bool bNeedTarget)
{
	local UserInfo uInfo;

	if(bNeedTarget)
	{
		if(!GetTargetInfo(uInfo))
		{
			Class'InterfaceClassic.L2Util'.static.Inst().showGfxScreenMessage(GetSystemMessage(50));
			return;
		}
	}
	ExecuteCommand(Command);
	return;
}

event OnReceivedCloseUI()
{
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	if(searchEditBox.IsFocused())
	{
		if((int(nKey) == 13))
		{
			if((trim(searchEditBox.GetString()) != ""))
			{
				OnsearchItemBtnClick();
			}
		}
	}
	return false;
}

function HandleBtnByName(string btnName)
{
	local array<string> descriptArray;

	Split(btnName, "_", descriptArray);
	if((descriptArray[0] == "telBtn"))
	{
		ShowTeleportDialog(int(descriptArray[1]));
	}
	return;
}

function OnsearchItemBtnClick()
{
	if((getInstanceUIData().GetIsClassicServer() && !IsAdenServer()))
	{
		FindAllQuest(searchEditBox.GetString());
	}
	else
	{
		FindAllQuestAdena();
	}
	return;
}

function OnInitBtnClick()
{
	searchEditBox.SetString("");
	QuestListCtrl_RichList.DeleteAllItem();
	questListCtrl.DeleteAllItem();
	return;
}

function GetQuestButtonClick()
{
	local int QuestID, nSelect;
	local LVDataRecord dataRecord;

	nSelect = questListCtrl.GetSelectedIndex();
	if((nSelect >= 0))
	{
		questListCtrl.GetSelectedRec(dataRecord);
		QuestID = int(dataRecord.LVDataList[0].szData);
		Debug(("questID" @ string(QuestID)));
		if((QuestID > 0))
		{
			ProcessChatMessage((("//setquest " $ string(QuestID)) $ " 1"));
		}
	}
	return;
}

function SetMyQuests()
{
	local int i;
	local RichListCtrlHandle QuestAlarmList_RichList;
	local RichListCtrlRowData rowData;
	local NQuestUIData questUIData;

	QuestAlarmList_RichList = GetRichListCtrlHandle("QuestProgressWnd.QuestAlarmList_RichList");
	searchEditBox.SetString("");
	QuestListCtrl_RichList.DeleteAllItem();
	Debug(("SetMyQuests" @ string(QuestAlarmList_RichList.GetRecordCount())));
	i = 0;
	while((i < QuestAlarmList_RichList.GetRecordCount()))
	{
		QuestAlarmList_RichList.GetRec(i, rowData);
		if(!API_GetNQuestData(int(rowData.nReserved1), questUIData))
		{
			i++;
			continue;
		}
		Debug(("SetMyQuests" @ string(rowData.nReserved1)));
		AddItemNewQuest(questUIData);
		i++;
	}
	return;
}

function MoveStartNPCButtonClick()
{
	local int QuestID, nSelect;
	local LVDataRecord dataRecord;
	local Vector Loc;

	nSelect = questListCtrl.GetSelectedIndex();
	if((nSelect >= 0))
	{
		questListCtrl.GetSelectedRec(dataRecord);
		QuestID = int(dataRecord.LVDataList[0].szData);
		Loc = Class'NWindow.UIDATA_QUEST'.static.GetStartNPCLoc(QuestID, 1);
		if((((Loc.X + Loc.Y) + Loc.Z) != 0.0000000))
		{
			Debug(((("teleport -> " @ string(Loc.X)) @ string(Loc.Y)) @ string(Loc.Z)));
			ProcessChatMessage(((("//teleport" @ string(Loc.X)) @ string(Loc.Y)) @ string(Loc.Z)));
		}
		if((QuestID <= 0))
		{
			AddSystemMessageString(("questID is wrong:" @ string(QuestID)));
		}
	}
	return;
}

function MoveTargetLocButtonClick()
{
	local int QuestID, nSelect, QuestLevel;
	local LVDataRecord dataRecord;
	local Vector Loc;

	nSelect = questListCtrl.GetSelectedIndex();
	if((nSelect >= 0))
	{
		questListCtrl.GetSelectedRec(dataRecord);
		QuestID = int(dataRecord.LVDataList[0].szData);
		QuestLevel = int(dataRecord.nReserved2);
		Loc = Class'NWindow.UIDATA_QUEST'.static.GetTargetLoc(QuestID, QuestLevel);
		if((((Loc.X + Loc.Y) + Loc.Z) != 0.0000000))
		{
			if((QuestID > 0))
			{
				Debug(((("teleport -> " @ string(Loc.X)) @ string(Loc.Y)) @ string(Loc.Z)));
				ProcessChatMessage(((("//teleport" @ string(Loc.X)) @ string(Loc.Y)) @ string(Loc.Z)));
			}
			else
			{
				AddSystemMessageString(("questID is wrong:" @ string(QuestID)));
			}
		}
	}
	return;
}

function bool ChkString(string SearchString, string targetString)
{
	local string modifiedString;

	modifiedString = Substitute(targetString, " ", "", false);
	return StringMatching(modifiedString, SearchString, " ");
}

function bool ChkQuestString(string SearchString, NQuestUIData questUIData)
{
	local int i;

	if((SearchString == ""))
	{
		return true;
	}
	if(((SearchString == "0") || (int(SearchString) > 0)))
	{
		if((int(SearchString) == questUIData.Id))
		{
			return true;
		}
		if((int(SearchString) == questUIData.TeleportID))
		{
			return true;
		}
		if((int(SearchString) == questUIData.StartNPC.Id))
		{
			return true;
		}
		if((int(SearchString) == questUIData.EndNPC.Id))
		{
			return true;
		}
		if((int(SearchString) == questUIData.StartNPC.TeleportID))
		{
			return true;
		}
		if((int(SearchString) == questUIData.EndNPC.TeleportID))
		{
			return true;
		}
	}
	if(ChkString(SearchString, questUIData.Name))
	{
		return true;
	}
	if((questUIData.StartNPC.Id > 0))
	{
		if(ChkString(SearchString, Class'NWindow.UIDATA_NPC'.static.GetNPCName(questUIData.StartNPC.Id)))
		{
			return true;
		}
		if(ChkString(SearchString, GetTeleportName(questUIData.StartNPC.TeleportID)))
		{
			return true;
		}
	}
	if((questUIData.EndNPC.Id > 0))
	{
		if(ChkString(SearchString, Class'NWindow.UIDATA_NPC'.static.GetNPCName(questUIData.EndNPC.Id)))
		{
			return true;
		}
		if(ChkString(SearchString, GetTeleportName(questUIData.EndNPC.TeleportID)))
		{
			return true;
		}
	}
	if(ChkString(SearchString, GetTeleportName(questUIData.TeleportID)))
	{
		return true;
	}
	if(ChkString(SearchString, questUIData.Goal.Name))
	{
		return true;
	}
	if((questUIData.Reward.Level > 0))
	{
		if(ChkString(SearchString, Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(95641))))
		{
			return true;
		}
	}
	if((questUIData.Reward.Exp > INT64(0)))
	{
		if(ChkString(SearchString, Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(15623))))
		{
			return true;
		}
	}
	if((questUIData.Reward.Sp > 0))
	{
		if(ChkString(SearchString, Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(15624))))
		{
			return true;
		}
	}
	i = 0;
	while((i < questUIData.Reward.Items.Length))
	{
		if(ChkString(SearchString, Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(questUIData.Reward.Items[i].ItemClassID))))
		{
			return true;
		}
		i++;
	}
	return false;
}

function FindAllQuest(string a_Param)
{
	local int Id, i, NpcID;
	local string modifiedString, fullNameString, NpcName, journalName, beforeJournalName, modifiedParam, zoneName;

	questListCtrl.ShowWindow();
	QuestListCtrl_RichList.HideWindow();
	questListCtrl.DeleteAllItem();
	if((int(a_Param) > 0))
	{
		a_Param = Class'NWindow.UIDATA_QUEST'.static.GetQuestName(int(a_Param));
	}
	modifiedParam = Substitute(a_Param, " ", "", false);
	Id = Class'NWindow.UIDATA_QUEST'.static.GetFirstID();
	while((-1 != Id))
	{
		fullNameString = Class'NWindow.UIDATA_QUEST'.static.GetQuestName(Id);
		NpcID = Class'NWindow.UIDATA_QUEST'.static.GetStartNPCID(Id, 1);
		NpcName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(NpcID);
		i = 0;
		while((i < 100))
		{
			zoneName = Class'NWindow.UIDATA_QUEST'.static.GetQuestName(Class'NWindow.UIDATA_QUEST'.static.GetQuestZone(Id, i));
			journalName = Class'NWindow.UIDATA_QUEST'.static.GetQuestJournalName(Id, i);
			journalName = Class'NWindow.UIDATA_QUEST'.static.GetQuestJournalNameLine(journalName);
			modifiedString = (((fullNameString $ journalName) $ NpcName) $ zoneName);
			modifiedString = Substitute(modifiedString, " ", "", false);
			if(((Len(journalName) <= 0) || (i == 0)))
			{
				i++;
				continue;
			}
			else if(((Len(journalName) != 0) && (beforeJournalName == journalName)))
			{
				continue;
			}
			if((InStr(modifiedString, modifiedParam) != -1))
			{
				AddItem(Id, i, fullNameString, journalName);
				beforeJournalName = journalName;
				i++;
				continue;
			}
			if((int(a_Param) > 0))
			{
				AddItem(Id, i, fullNameString, journalName);
				journalName = Class'NWindow.UIDATA_QUEST'.static.GetQuestJournalName(Id, i);
				journalName = Class'NWindow.UIDATA_QUEST'.static.GetQuestJournalNameLine(journalName);
				beforeJournalName = journalName;
			}
			i++;
		}
		Id = Class'NWindow.UIDATA_QUEST'.static.GetNextID();
	}
	return;
}

function AddItem(int nItemID, int QuestLevel, string fullNameString, string journalName)
{
	local LVDataRecord Record;
	local string questTypeStr, levelLimit, NpcName;
	local int QuestType, MinLevel, MaxLevel, NpcID, clearedQuestID;
	local Vector Loc;
	local bool bStartLoc, bTargetLoc;

	Record.nReserved1 = INT64(nItemID);
	Record.LVDataList.Length = 8;
	QuestType = Class'NWindow.UIDATA_QUEST'.static.GetQuestType(nItemID, QuestLevel);
	questTypeStr = getQuestTypeString(QuestType);
	MinLevel = Class'NWindow.UIDATA_QUEST'.static.GetMinLevel(nItemID, 1);
	MaxLevel = Class'NWindow.UIDATA_QUEST'.static.GetMaxLevel(nItemID, 1);
	if(((MinLevel > 0) && (MaxLevel > 0)))
	{
		levelLimit = ((string(MinLevel) $ "~") $ string(MaxLevel));
	}
	else if((MinLevel > 0))
	{
		levelLimit = ((string(MinLevel) $ " ") $ GetSystemString(859));
	}
	else
	{
		levelLimit = GetSystemString(866);
	}
	Record.nReserved2 = INT64(QuestLevel);
	Record.LVDataList[0].szData = string(nItemID);
	Record.LVDataList[1].TextColor = Class'InterfaceClassic.L2UIColor'.static.Inst().Sandrift;
	Record.LVDataList[1].bUseTextColor = true;
	Record.LVDataList[1].szData = questTypeStr;
	Record.LVDataList[2].szData = levelLimit;
	Record.LVDataList[3].bUseTextColor = true;
	if((QuestLevel == 1))
	{
		Record.LVDataList[3].szData = (("[" $ fullNameString) $ "]");
		Record.LVDataList[3].TextColor = getInstanceL2Util().Yellow;
	}
	else
	{
		Record.LVDataList[3].szData = (("   [" $ fullNameString) $ "]");
		Record.LVDataList[3].TextColor = Class'InterfaceClassic.L2UIColor'.static.Inst().Sandrift;
	}
	Record.LVDataList[3].hasIcon = true;
	Record.LVDataList[3].AttrColor.R = 200;
	Record.LVDataList[3].AttrColor.G = 200;
	Record.LVDataList[3].AttrColor.B = 200;
	Record.LVDataList[3].AttrStat[0] = Substitute(((("   " $ string(QuestLevel)) $ ": ") $ journalName), "\\n", "<br1>", false);
	NpcID = Class'NWindow.UIDATA_QUEST'.static.GetStartNPCID(nItemID, 1);
	NpcName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(NpcID);
	Record.LVDataList[4].szData = NpcName;
	clearedQuestID = Class'NWindow.UIDATA_QUEST'.static.GetClearedQuest(nItemID, QuestLevel);
	Loc = Class'NWindow.UIDATA_QUEST'.static.GetTargetLoc(nItemID, QuestLevel);
	Record.LVDataList[5].szData = Class'NWindow.UIDATA_QUEST'.static.GetQuestName(Class'NWindow.UIDATA_QUEST'.static.GetQuestZone(nItemID, QuestLevel));
	if((isVectorZero(Loc) == false))
	{
		bTargetLoc = true;
	}
	Loc = Class'NWindow.UIDATA_QUEST'.static.GetStartNPCLoc(nItemID, QuestLevel);
	if((isVectorZero(Loc) == false))
	{
		bStartLoc = true;
	}
	if(((bTargetLoc == true) && (bStartLoc == true)))
	{
		Record.LVDataList[6].szData = "OK";
	}
	else if(((bTargetLoc == true) && (bStartLoc == false)))
	{
		Record.LVDataList[6].szData = "No StartNPCLoc";
	}
	else if(((bTargetLoc == false) && (bStartLoc == true)))
	{
		Record.LVDataList[6].szData = "No TargetLoc";
	}
	else
	{
		Record.LVDataList[6].szData = "No Loc(StartNpcLoc,TargetLoc)";
	}
	if((clearedQuestID > 0))
	{
		Record.LVDataList[7].bUseTextColor = true;
		Record.LVDataList[7].TextColor = Class'InterfaceClassic.L2UIColor'.static.Inst().Sandrift;
		Record.LVDataList[7].szData = ((("QuestID:" $ string(clearedQuestID)) $ ": ") $ Class'NWindow.UIDATA_QUEST'.static.GetQuestName(clearedQuestID));
		Record.LVDataList[7].hasIcon = true;
		Record.LVDataList[7].AttrColor.R = 200;
		Record.LVDataList[7].AttrColor.G = 200;
		Record.LVDataList[7].AttrColor.B = 200;
		Record.LVDataList[7].AttrStat[0] = ((GetSystemString(1201) $ ":") $ Class'NWindow.UIDATA_QUEST'.static.GetRequirement(nItemID, QuestLevel));
	}
	questListCtrl.InsertRecord(Record);
	return;
}

function showQuestDrawer(int QuestID, int Level)
{
	local int i, QuestType, MinLevel, MaxLevel;
	local string QuestParam;
	local int Max;
	local array<int> arrItemIDList, arrItemNumList, RewardIDList;
	local array<INT64> rewardNumList;
	local string journalName, titleName, NpcName, targetString, levelText, QuestTypeText;
	local Vector Loc, targetLoc;
	local string locHtml;
	local int NpcID;
	local string questArea, itemNumStr, etcOutputStr;

	htmlMsg = "";
	htmlMsg = ("<html><body>" $ htmlTableAdd());
	MinLevel = Class'NWindow.UIDATA_QUEST'.static.GetMinLevel(QuestID, Level);
	MaxLevel = Class'NWindow.UIDATA_QUEST'.static.GetMaxLevel(QuestID, Level);
	NpcID = Class'NWindow.UIDATA_QUEST'.static.GetStartNPCID(QuestID, 1);
	NpcName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(NpcID);
	etcOutputStr = (((((etcOutputStr $ "NpcID :") @ string(NpcID)) $ ", npcName :") @ NpcName) $ "\\n\\n");
	QuestDescription = Class'NWindow.UIDATA_QUEST'.static.GetQuestDescription(QuestID, Level);
	QuestDescription = Substitute(QuestDescription, "\\n", "<br1>", false);
	journalName = Class'NWindow.UIDATA_QUEST'.static.GetQuestJournalName(QuestID, Level);
	journalName = Class'NWindow.UIDATA_QUEST'.static.GetQuestJournalNameLine(journalName);
	titleName = htmlAddText((("[" @ journalName) @ "]"), "hs10", "d4af6f");
	if(((MaxLevel > 0) && (MinLevel > 0)))
	{
		levelText = ((string(MinLevel) $ "~") $ string(MaxLevel));
	}
	else if((MinLevel > 0))
	{
		levelText = ((string(MinLevel) $ " ") $ GetSystemString(859));
	}
	else
	{
		levelText = GetSystemString(866);
	}
	QuestType = Class'NWindow.UIDATA_QUEST'.static.GetQuestType(QuestID, 1);
	if(((0 <= QuestType) && (QuestType <= 13)))
	{
		QuestTypeText = getQuestTypeString(QuestType);
	}
	QuestTypeText = htmlfontAdd((QuestTypeText $ "  ["));
	Loc = Class'NWindow.UIDATA_QUEST'.static.GetStartNPCLoc(QuestID, 1);
	etcOutputStr = ((((((((etcOutputStr $ "startNpc Loc :") @ " x") $ string(int(Loc.X))) $ " y") $ string(int(Loc.Y))) $ " z") $ string(int(Loc.Z))) $ "\\n\\n");
	if((((Loc.X == 0.0000000) && (Loc.Y == 0.0000000)) && (Loc.Z == 0.0000000)))
	{
		Loc = Class'NWindow.UIDATA_QUEST'.static.GetTargetLoc(QuestID, Level);
		etcOutputStr = ((((((((etcOutputStr $ "TargetLoc :") @ " x") $ string(int(Loc.X))) $ " y") $ string(int(Loc.Y))) $ " z") $ string(int(Loc.Z))) $ "\\n\\n");
	}
	else
	{
		targetLoc = Class'NWindow.UIDATA_QUEST'.static.GetTargetLoc(QuestID, Level);
		etcOutputStr = ((((((((etcOutputStr $ "TargetLoc :") @ " x") $ string(int(targetLoc.X))) $ " y") $ string(int(targetLoc.Y))) $ " z") $ string(int(targetLoc.Z))) $ "\\n\\n");
	}
	etcOutputStr = (((etcOutputStr $ "TargetName :") @ Class'NWindow.UIDATA_QUEST'.static.GetTargetName(QuestID, Level)) $ "\\n\\n");
	etcOutputStr = (((etcOutputStr $ "bOnlyMinimap :") @ string(Class'NWindow.UIDATA_QUEST'.static.IsMinimapOnly(QuestID, Level))) $ "\\n\\n");
	etcOutputStr = ((((((((etcOutputStr $ "ZoneLoc :") @ " x") $ string(int(Loc.X))) $ " y") $ string(int(Loc.Y))) $ " z") $ string(int(Loc.Z))) $ "\\n");
	NpcName = Substitute(NpcName, " ", "!!", false);
	locHtml = ((((("(" $ NpcName) $ ")") $ questArea) @ GetSystemString(7199)) $ "<br>");
	htmlMsg = ((((((((htmlMsg $ titleName) $ "<br1>") $ htmlfontAdd(((GetSystemString(922) @ ":") @ levelText))) $ "<br1>") $ QuestTypeText) $ locHtml) $ htmlfontAdd("]")) $ "<br1></td></tr></table><br>");
	QuestParam = Class'NWindow.UIDATA_QUEST'.static.GetQuestItem(QuestID, Level);
	ParseInt(QuestParam, "Max", Max);
	arrItemIDList.Length = Max;
	arrItemNumList.Length = Max;
	i = 0;
	while((i < Max))
	{
		ParseInt(QuestParam, ("ItemID_" $ string(i)), arrItemIDList[i]);
		ParseInt(QuestParam, ("ItemNum_" $ string(i)), arrItemNumList[i]);
		if((arrItemNumList[i] == 0))
		{
			itemNumStr = GetSystemString(7292);
		}
		else
		{
			itemNumStr = string(arrItemNumList[i]);
		}
		if(((arrItemIDList[i] - 1000000) > 0))
		{
			targetString = (htmlfontAdd((((targetString $ Class'NWindow.UIDATA_NPC'.static.GetNPCName((arrItemIDList[i] - 1000000))) @ itemNumStr) $ "NeedKill")) $ "<br1>");
			i++;
			continue;
		}
		targetString = (htmlfontAdd((((targetString $ Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(arrItemIDList[i]))) @ itemNumStr) $ "NeedItem")) $ "<br1>");
		i++;
	}
	if((Max > 0))
	{
		targetString = ((((((htmlTableAdd() $ "<font name=hs10 color=\"d4af6f\">") $ GetSystemString(7259)) $ "</font>") $ "<br1>") $ targetString) $ "<br1></td></tr></table><br>");
		htmlMsg = (htmlMsg @ targetString);
	}
	RewardIDList.Remove(0, RewardIDList.Length);
	rewardNumList.Remove(0, rewardNumList.Length);
	Class'NWindow.UIDATA_QUEST'.static.GetQuestReward(QuestID, Level, RewardIDList, rewardNumList);
	if((RewardIDList.Length > 0))
	{
		setRewardItem(RewardIDList, rewardNumList);
	}
	etcTextBox.SetText(etcOutputStr);
	return;
}

function setRewardItem(array<int> RewardIDList, array<INT64> rewardNumList)
{
	local int i;
	local string IconName, ItemName, rewardSmallIconHtml, rewardMsgHtml, rewardEndMsgHtml, itemText;
	local int tableIndex, smallIconIndex;
	local string addItemHtml, HtmlString;

	tableIndex = 0;
	smallIconIndex = 0;
	bicIconLen = 0;
	rewardSmallIconHtml = "<table width=280 border=0 cellpadding=0 cellspacing=2 background=L2UI_CT1.HtmlWnd.HTMLWnd_GroupBox_DF_Center>";
	rewardMsgHtml = "<table width=280 border=0 cellpadding=0 cellspacing=2 background=L2UI_CT1.HtmlWnd.HTMLWnd_GroupBox_DF_Center>";
	i = 0;
	while((i < RewardIDList.Length))
	{
		if(((((RewardIDList[i] != 57) && (RewardIDList[i] != 15623)) && (RewardIDList[i] != 15624)) && (RewardIDList[i] != 47130)))
		{
			bicIconLen++;
		}
		i++;
	}
	if((RewardIDList.Length > 0))
	{
		i = 0;
		while((i < RewardIDList.Length))
		{
			if((i == 0))
			{
				addItemHtml = ((((htmlTableAdd("L2UI_CT1.GroupBox.GroupBox_DF") $ "<font color=\"ffcc00\" name=GameDefault>") $ GetSystemString(2006)) $ "</font>") $ "</td></tr></table>");
			}
			switch(RewardIDList[i])
			{
				case 57:
				case 15623:
				case 15624:
				case 47130:
					ItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(RewardIDList[i]));
					if((RewardIDList[i] == 57))
					{
						IconName = "L2UI_CT1.HtmlWnd.HTMLWnd_adena";
						ItemName = GetSystemString(469);
					}
					else if((RewardIDList[i] == 15623))
					{
						if((getLanguageNumber() == 1))
						{
						}
						IconName = "L2UI_CT1.HtmlWnd.HTMLWnd_EXP";
					}
					else if((RewardIDList[i] == 15624))
					{
						IconName = "L2UI_CT1.HtmlWnd.HTMLWnd_SP";
					}
					else if((RewardIDList[i] == 47130))
					{
						IconName = "L2UI_CT1.HtmlWnd.HTMLWnd_FP";
					}
					if((rewardNumList[i] == INT64(0)))
					{
						itemText = GetSystemString(584);
					}
					else if((RewardIDList[i] == 15624))
					{
						itemText = string(rewardNumList[i]);
					}
					else
					{
						itemText = string(rewardNumList[i]);
					}
					rewardSmallIconHtml = (((((((((rewardSmallIconHtml $ "<tr><td width=45 height=23 align=center valign=center><Img width=32 height=18") $ " src=\"") $ IconName) $ "\"") $ "></td><td height=23 width=246><font color=ba8860>") $ itemText) $ "</font>") @ htmlfontAdd(ItemName)) $ "</td></tr>");
					smallIconIndex = (smallIconIndex + 1);
					break;
				default:
					IconName = Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(GetItemID(RewardIDList[i]));
					ItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(RewardIDList[i]));
					if((rewardNumList[i] == INT64(0)))
					{
						itemText = htmlfontAdd(GetSystemString(584), "ba8860");
					}
					else if((((((((((((RewardIDList[i] == 15623) || (RewardIDList[i] == 15624)) || (RewardIDList[i] == 15625)) || (RewardIDList[i] == 15626)) || (RewardIDList[i] == 15627)) || (RewardIDList[i] == 15628)) || (RewardIDList[i] == 15629)) || (RewardIDList[i] == 15630)) || (RewardIDList[i] == 15631)) || (RewardIDList[i] == 15632)) || (RewardIDList[i] == 15633)))
					{
						itemText = htmlfontAdd(string(rewardNumList[i]), "ba8860");
					}
					else
					{
						itemText = MakeFullSystemMsg(htmlfontAdd(GetSystemMessage(1983)), htmlfontAdd(string(rewardNumList[i]), "ba8860"), "");
					}
					if((bicIconLen == 1))
					{
						rewardMsgHtml = (((((((((((((((((rewardMsgHtml $ "<tr><td align=center valign=center width=43 height=39><button width=32 height=32") $ " itemtooltip=\"") $ string(RewardIDList[i])) $ "\"") $ " back=\"") $ IconName) $ "\"") $ " high=\"") $ IconName) $ "\"") $ " fore=\"") $ IconName) $ "\"></button></td><td width=240 hdight=39>") $ htmlfontAdd(ItemName)) $ "<br1>") $ itemText) $ "</td></tr>");
					}
					else
					{
						if(((RewardIDList.Length > 0) && (Len(ItemName) > 8)))
						{
							ItemName = (Mid(ItemName, 0, 8) $ "..");
						}
						if(((float(tableIndex) % 2.0000000) > 0.0000000))
						{
							rewardMsgHtml = Mid(rewardMsgHtml, 0, (Len(rewardMsgHtml) - 5));
							rewardMsgHtml = ((((((((((((((((((rewardMsgHtml $ "<td align=center valign=center width=43 height=39><button width=32 height=32") $ " itemtooltip=\"") $ string(RewardIDList[i])) $ "\"") $ " back=\"") $ IconName) $ "\"") $ " high=\"") $ IconName) $ "\"") $ " fore=\"") $ IconName) $ "\"></button></td><td width=115 hdight=39>") $ htmlfontAdd(ItemName)) $ "<br1>") $ itemText) $ "<br1>") $ "</td></tr>");
						}
						else
						{
							rewardMsgHtml = ((((((((((((((((((rewardMsgHtml $ htmlTableTrAdd()) $ "<tr><td align=center valign=center width=43 height=39><button width=32 height=32") $ " itemtooltip=\"") $ string(RewardIDList[i])) $ "\"") $ " back=\"") $ IconName) $ "\"") $ " high=\"") $ IconName) $ "\"") $ " fore=\"") $ IconName) $ "\"></button></td><td width=115 hdight=39>") $ htmlfontAdd(ItemName)) $ "<br1>") $ itemText) $ "</td></tr>");
						}
					}
					tableIndex = (tableIndex + 1);
			}
			i++;
		}
		if((tableIndex > 0))
		{
			rewardMsgHtml = (rewardMsgHtml $ "</table>");
		}
		else
		{
			rewardMsgHtml = "";
		}
		if((smallIconIndex > 0))
		{
			rewardSmallIconHtml = (rewardSmallIconHtml $ "</table>");
		}
		else
		{
			rewardSmallIconHtml = "";
		}
		HtmlString = Mid(HtmlString, 6, Len(HtmlString));
		HtmlString = Mid(HtmlString, 0, (Len(HtmlString) - 7));
		rewardEndMsgHtml = "<table width=278 border=0 cellpadding=0 cellspacing=1 background=L2UI_CT1.HtmlWnd.HTMLWnd_GroupBox_DF_Down><tr><td width=278></td></tr></table>";
		addItemHtml = ((((HtmlString $ addItemHtml) $ rewardSmallIconHtml) $ rewardMsgHtml) $ rewardEndMsgHtml);
		addItemHtml = ((((("<html><body>" $ addItemHtml) $ "<br><table border=0 cellpadding=0 cellspacing=3 width=288 ><tr><td height=11 align=center valign=center></td></tr><tr><td></td></tr></table><br><br>") $ rewardEndMsgHtml) $ QuestDescription) $ "</body></html>");
		DetailInfoHtmlCtrl.LoadHtmlFromString(addItemHtml);
	}
	return;
}

function addPinInTheMap(string ListCtrlID, int SelectedIndex)
{
	local LVDataRecord Record;
	local int QuestID, Level;

	if((ListCtrlID == "QuestListCtrl"))
	{
		if((SelectedIndex != -1))
		{
			questListCtrl.SetSelectedIndex(SelectedIndex, false);
		}
		questListCtrl.GetSelectedRec(Record);
		QuestID = int(Record.nReserved1);
		Level = int(Record.nReserved2);
		showQuestDrawer(QuestID, Level);
		if((SelectedIndex == -1))
		{
			questListCtrl.SetFocus();
		}
	}
	return;
}

function AddPinInTheGfxMap()
{
	local RichListCtrlRowData rowData;
	local NQuestUIData o_data;

	QuestListCtrl_RichList.GetSelectedRec(rowData);
	if(!API_GetNQuestData(int(rowData.nReserved1), o_data))
	{
		return;
	}
	ShowNewQuestDefaultInfo(o_data);
	SetNewQuestDetailInfo(o_data);
	return;
}

function FindAllQuestAdena()
{
	local int qid;
	local string SearchString;
	local NQuestUIData questUIData;

	QuestListCtrl_RichList.ShowWindow();
	QuestListCtrl_RichList.DeleteAllItem();
	SearchString = searchEditBox.GetString();
	qid = Class'NWindow.UIDATA_QUEST'.static.GetNFirstID();
	while((-1 != qid))
	{
		if(!API_GetNQuestData(qid, questUIData))
		{
			qid = Class'NWindow.UIDATA_QUEST'.static.GetNNextID();
			continue;
		}
		if(!ChkQuestString(SearchString, questUIData))
		{
			qid = Class'NWindow.UIDATA_QUEST'.static.GetNNextID();
			continue;
		}
		AddItemNewQuest(questUIData);
		qid = Class'NWindow.UIDATA_QUEST'.static.GetNNextID();
	}
	return;
}

function AddItemNewQuest(NQuestUIData questUIData)
{
	local RichListCtrlRowData rowData;
	local string startNpcname, endNpcname;

	rowData.nReserved1 = INT64(questUIData.Id);
	rowData.cellDataList.Length = 8;
	rowData.cellDataList[0].HiddenStringForSorting = string(questUIData.Id);
	rowData.cellDataList[0].szData = string(questUIData.Id);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, string(questUIData.Id), GetColor(200, 200, 200, 255), true);
	rowData.cellDataList[1].HiddenStringForSorting = string(questUIData.Type);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, GetNewQuestTypeAdena(questUIData.Type), Class'InterfaceClassic.L2UIColor'.static.Inst().Sandrift, true);
	rowData.cellDataList[2].HiddenStringForSorting = string(questUIData.LevelMin);
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, GetNewLevelString(questUIData), Class'InterfaceClassic.L2UIColor'.static.Inst().Sandrift, true);
	rowData.cellDataList[3].HiddenStringForSorting = questUIData.Name;
	AddRichListCtrlString(rowData.cellDataList[3].drawitems, questUIData.Name, GetColor(200, 200, 200, 255), true);
	rowData.cellDataList[3].szData = questUIData.Name;
	if((questUIData.TeleportID > 0))
	{
		AddRichListCtrlButton(rowData.cellDataList[3].drawitems, ("telBtn_" $ string(questUIData.TeleportID)), 0, 0, "L2UI_CT1.Minimap.TelIcon_16", "L2UI_CT1.Minimap.TelIcon_16", "L2UI_CT1.Minimap.TelIcon_16", 16, 16, 16, 16);
	}
	startNpcname = Class'NWindow.UIDATA_NPC'.static.GetNPCName(questUIData.StartNPC.Id);
	rowData.cellDataList[4].HiddenStringForSorting = startNpcname;
	AddRichListCtrlString(rowData.cellDataList[4].drawitems, startNpcname, GetColor(200, 200, 200, 255), true);
	if((questUIData.StartNPC.TeleportID > 0))
	{
		AddRichListCtrlButton(rowData.cellDataList[4].drawitems, ("telBtn_" $ string(questUIData.StartNPC.TeleportID)), 0, 0, "L2UI_CT1.Minimap.TelIcon_16", "L2UI_CT1.Minimap.TelIcon_16", "L2UI_CT1.Minimap.TelIcon_16", 16, 16, 16, 16);
	}
	endNpcname = Class'NWindow.UIDATA_NPC'.static.GetNPCName(questUIData.EndNPC.Id);
	rowData.cellDataList[5].HiddenStringForSorting = endNpcname;
	AddRichListCtrlString(rowData.cellDataList[5].drawitems, endNpcname, GetColor(200, 200, 200, 255), true);
	if((questUIData.EndNPC.TeleportID > 0))
	{
		AddRichListCtrlButton(rowData.cellDataList[5].drawitems, ("telBtn_" $ string(questUIData.EndNPC.TeleportID)), 0, 0, "L2UI_CT1.Minimap.TelIcon_16", "L2UI_CT1.Minimap.TelIcon_16", "L2UI_CT1.Minimap.TelIcon_16", 16, 16, 16, 16);
	}
	QuestListCtrl_RichList.InsertRecord(rowData);
	return;
}

function ShowNewQuestDefaultInfo(NQuestUIData questUIData)
{
	local string HtmlString;

	HtmlString = HtmlQuestnameTableAdd(questUIData.Name);
	AddHtmlString(HtmlString, GetNewQuestType(questUIData));
	AddHtmlString(HtmlString, GetNewQuestDesc(questUIData));
	AddHtmlString(HtmlString, GetGoalText(questUIData.Goal.Name, 0, questUIData.Goal.Num));
	AddHtmlString(HtmlString, GetRewardItems(questUIData.Reward));
	HtmlString = (("<html><body>" $ HtmlString) $ "</body></html>");
	DetailInfoHtmlCtrl.LoadHtmlFromString(htmlSetHtmlStart(HtmlString));
	return;
}

function string HtmlQuestnameTableAdd(string Title)
{
	local string hex;

	hex = Class'InterfaceClassic.L2UIColor'.static.Inst()._Color2ZeroX(Class'InterfaceClassic.L2UIColor'.static.Inst().Sandrift);
	return (((("<table width=290 cellpadding=0 border=0 cellspacing=0><tr><td width=26> <img src = \"L2UI_CT1.Minimap.Minimap_OpenGuideWnd\" width=26 height=26></td><td width=254 align=left valign=bottom><font color=\"" $ hex) $ "\" name=GameDefault>") $ Title) $ "</font></td></tr></table>");
}

function string GetNewQuestDesc(NQuestUIData questUIData)
{
	local NQuestDialogUIData questDialogUIData;

	if(!API_GetNQuestDialogData(questUIData.Id, questDialogUIData))
	{
		return "";
	}
	return (("<table width=290 border=0 cellpadding=2 cellspacing=2 background=L2UI_CT1.GroupBox.GroupBox_DF><tr><td>" $ questDialogUIData.QuestInfo) $ "</td></tr></table>");
}

function string GetNewQuestType(NQuestUIData questUIData)
{
	local string questMainType;

	questMainType = GetMainTypeString(questUIData);
	return (((((((("<table width=290 border=0 cellpadding=2 cellspacing=2 background=L2UI_CT1.GroupBox.GroupBox_DF><tr><td align=left>" $ questMainType) $ " ") $ htmlfontAdd(GetNewQuestTypeAdena(questUIData.Type), Class'InterfaceClassic.L2UIColor'.static.Inst()._Color2ZeroX(Class'InterfaceClassic.L2UIColor'.static.Inst().Sandrift))) $ "</td></tr><tr><td>") $ GetSystemString(922)) $ " ") $ htmlfontAdd(GetNewLevelString(questUIData), Class'InterfaceClassic.L2UIColor'.static.Inst()._Color2ZeroX(Class'InterfaceClassic.L2UIColor'.static.Inst().Sandrift))) $ "</td></tr></table>");
}

function string GetNewQuestTypeAdena(UIEventManager.ENQuestType Type)
{
	switch(Type)
	{
		case NQT_ONETIME:
			return GetSystemString(862);
		case NQT_DAILY:
			return GetSystemString(2788);
		case NQT_WEEKLY:
			return GetSystemString(14389);
		case NQT_REPEAT:
			return GetSystemString(861);
		default:
			return "";
	}
}

function string GetTeleportName(int tID)
{
	local TeleportListAPI.TeleportListData tInfo;

	tInfo = Class'NWindow.TeleportListAPI'.static.GetFirstTeleportListData();
	while(("" != tInfo.Name))
	{
		if((tInfo.Id == tID))
		{
			return tInfo.Name;
		}
		tInfo = Class'NWindow.TeleportListAPI'.static.GetNextTeleportListData();
	}
	return "";
}

function string GetMainTypeString(NQuestUIData questUIData)
{
	if((questUIData.Id < 20001))
	{
		return GetSystemString(2738);
	}
	else if((questUIData.Id < 30001))
	{
		return GetSystemString(2341);
	}
	return GetSystemString(1796);
}

function string GetNewLevelString(NQuestUIData qUIData)
{
	if(((qUIData.LevelMax > 0) && (qUIData.LevelMin > 0)))
	{
		return ((string(qUIData.LevelMin) $ "~") $ string(qUIData.LevelMax));
	}
	else if((qUIData.LevelMin > 0))
	{
		return ((string(qUIData.LevelMin) $ " ") $ GetSystemString(859));
	}
	return GetSystemString(866);
}

function string GetGoalText(string Goalname, int Cnt, int goalNum)
{
	local string goalNuMString;

	if((goalNum > 1))
	{
		goalNuMString = (" " $ string(goalNum));
	}
	return ((((HtmlTitleTableAdd(GetSystemString(14407)) $ "<table width=290 border=0 cellpadding=2 cellspacing=2 background=L2UI_CT1.GroupBox.GroupBox_DF><tr><td>") $ Goalname) $ goalNuMString) $ "</td></tr></table>");
}

function string GetRewardItems(NQuestRewardData rewardDatas)
{
	local int i;
	local string IconName, ItemName, rewardMsgHtml, itemNumText, NameColor, numColor, DisplayString;
	local array<NQuestRewardItemData> Items;

	Class'InterfaceClassic.QuestConfirmWnd'.static.Inst()._GetRewardItems(rewardDatas, Items);
	NameColor = Class'InterfaceClassic.L2UIColor'.static.Inst()._Color2ZeroX(Class'InterfaceClassic.L2UIColor'.static.Inst().BrightWhite);
	numColor = Class'InterfaceClassic.L2UIColor'.static.Inst()._Color2ZeroX(Class'InterfaceClassic.L2UIColor'.static.Inst().Sandrift);
	i = 0;
	while((i < Items.Length))
	{
		if((Items[i].Amount == INT64(0)))
		{
			itemNumText = htmlfontAdd(GetSystemString(584), numColor);
		}
		else
		{
			DisplayString = Class'InterfaceClassic.L2Util'.static.Inst()._GetItemDisplayString(Class'InterfaceClassic.L2Util'.static.Inst()._GetItemDisplayType(Items[i].ItemClassID), Items[i].Amount);
			itemNumText = htmlfontAdd(DisplayString, numColor);
		}
		IconName = Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(GetItemID(Items[i].ItemClassID));
		ItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(Items[i].ItemClassID));
		if((Items.Length == 1))
		{
			rewardMsgHtml = (((((((((((((((("<tr><td align=center valign=center width=40 height=39><button width=32 height=32" $ " itemtooltip=\"") $ string(Items[i].ItemClassID)) $ "\"") $ " back=\"") $ IconName) $ "\"") $ " high=\"") $ IconName) $ "\"") $ " fore=\"") $ IconName) $ "\"></button></td><td width=245 hdight=39>") $ htmlfontAdd(ItemName, NameColor)) $ "<br1>") $ itemNumText) $ "</td></tr>");
			i++;
			continue;
		}
		if(((Items.Length > 0) && (Len(ItemName) > 8)))
		{
			ItemName = (Mid(ItemName, 0, 8) $ "..");
		}
		if(((float(i) % 2.0000000) == 0.0000000))
		{
			rewardMsgHtml = (((((((((((((((((rewardMsgHtml $ "<tr><td align=center valign=center width=40 height=39><button width=32 height=32") $ " itemtooltip=\"") $ string(Items[i].ItemClassID)) $ "\"") $ " back=\"") $ IconName) $ "\"") $ " high=\"") $ IconName) $ "\"") $ " fore=\"") $ IconName) $ "\"></button></td><td width=105 hdight=39>") $ htmlfontAdd(ItemName, NameColor)) $ "<br1>") $ itemNumText) $ "</td></tr>");
			i++;
			continue;
		}
		rewardMsgHtml = Mid(rewardMsgHtml, 0, (Len(rewardMsgHtml) - 5));
		rewardMsgHtml = ((((((((((((((((((rewardMsgHtml $ "<td align=center valign=center width=40 height=39><button width=32 height=32") $ " itemtooltip=\"") $ string(Items[i].ItemClassID)) $ "\"") $ " back=\"") $ IconName) $ "\"") $ " high=\"") $ IconName) $ "\"") $ " fore=\"") $ IconName) $ "\"></button></td><td width=105 hdight=39>") $ htmlfontAdd(ItemName, NameColor)) $ "<br1>") $ itemNumText) $ "<br1>") $ "</td></tr>");
		i++;
	}
	if((rewardMsgHtml == ""))
	{
		return "";
	}
	return (((HtmlTitleTableAdd(GetSystemString(14408)) $ "<table width=290 border=0 cellpadding=2 cellspacing=0 background=L2UI_CT1.GroupBox.GroupBox_DF>") $ rewardMsgHtml) $ "</table>");
}

function string HtmlTitleTableAdd(string Title, optional Color C)
{
	local string hex;

	if(((((int(C.R) == 0) && (int(C.G) == 0)) && (int(C.B) == 0)) && (int(C.A) == 0)))
	{
		C = Class'InterfaceClassic.L2UIColor'.static.Inst().Sandrift;
	}
	hex = Class'InterfaceClassic.L2UIColor'.static.Inst()._Color2ZeroX(C);
	return (((("<table width=290 cellpadding=0 border=0 cellspacing=0><tr><td width=290><font color=\"" $ hex) $ "\" name=GameDefault>") $ Title) $ "</font></td></tr></table>");
}

function SetNewQuestDetailInfo(NQuestUIData questUIData)
{
	local string detailString;
	local NQuestDialogUIData questDialogUIData;

	if((questUIData.StartNPC.Id > 0))
	{
		AddString(detailString, (("시작 : " $ Class'NWindow.UIDATA_NPC'.static.GetNPCName(questUIData.StartNPC.Id)) @ string(questUIData.StartNPC.Id)));  // EN?: Start:
		AddString(detailString, ((((("ㆍV : " $ string(int(questUIData.StartNPC.Location.X))) $ " / ") $ string(int(questUIData.StartNPC.Location.Y))) $ " / ") $ string(int(questUIData.StartNPC.Location.Z))));  // EN?: V:
		if((questUIData.StartNPC.TeleportID > 0))
		{
			AddString(detailString, (("ㆍT : " $ GetTeleportName(questUIData.StartNPC.TeleportID)) @ string(questUIData.StartNPC.TeleportID)));  // EN?: T:
		}
	}
	else
	{
		AddString(detailString, "시작 : 없음");  // EN?: Start: None
	}
	AddString(detailString);
	if((questUIData.EndNPC.Id > 0))
	{
		AddString(detailString, (("종료 : " $ Class'NWindow.UIDATA_NPC'.static.GetNPCName(questUIData.EndNPC.Id)) @ string(questUIData.EndNPC.Id)));  // EN?: Termination:
		AddString(detailString, ((((("ㆍV : " $ string(int(questUIData.EndNPC.Location.X))) $ " / ") $ string(int(questUIData.EndNPC.Location.Y))) $ " / ") $ string(int(questUIData.EndNPC.Location.Z))));  // EN?: V:
		if((questUIData.EndNPC.TeleportID > 0))
		{
			AddString(detailString, (("ㆍT : " $ GetTeleportName(questUIData.EndNPC.TeleportID)) @ string(questUIData.EndNPC.TeleportID)));  // EN?: T:
		}
	}
	else
	{
		AddString(detailString, "종료 : 없음");  // EN?: To: None
	}
	AddString(detailString);
	if((questUIData.TeleportID > 0))
	{
		AddString(detailString, ("Loc : " $ GetTeleportName(questUIData.TeleportID)));
		AddString(detailString, ((((("ㆍV : " $ string(int(questUIData.Location.X))) $ " / ") $ string(int(questUIData.Location.Y))) $ " / ") $ string(int(questUIData.Location.Z))));  // EN?: V:
		AddString(detailString, (("ㆍT :" @ GetTeleportName(questUIData.TeleportID)) @ string(questUIData.TeleportID)));  // EN?: T:
	}
	else
	{
		AddString(detailString, "Loc : 없음");  // EN?: Loc: None
	}
	etcTextBox.SetText(detailString);
	API_GetNQuestDialogData(questUIData.Id, questDialogUIData);
	return;
}

function OnTeleportDialogConfirm()
{
	local UserInfo UserInfo;

	teleportDialog.Hide();
	if((GetPlayerInfo(UserInfo) == false))
	{
		return;
	}
	if((UserInfo.nCurHP == INT64(0)))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(5243));
		teleportDialog.Hide();
		return;
	}
	Class'NWindow.TeleportListAPI'.static.RequestTeleport(teleportDialog.nDialogID);
	return;
}

function OnTeleportDialogCancel()
{
	teleportDialog.Hide();
	return;
}

function ShowTeleportDialog(int TeleportID)
{
	local string Desc, teleportName;
	local TeleportListAPI.TeleportListData targetTeleport;
	local INT64 teleportCost;

	if(!GetCurrentTeleportInfo(targetTeleport, TeleportID))
	{
		return;
	}
	if((targetTeleport.Level > 0))
	{
		teleportName = (((("(" $ targetTeleport.Name) $ " Lv ") $ string(targetTeleport.Level)) $ ")");
	}
	else
	{
		teleportName = (("(" $ targetTeleport.Name) $ ")");
	}
	Desc = ((GetSystemMessage(5239) $ "\\n\\n") $ teleportName);
	teleportDialog.SetDialogDesc(Desc);
	teleportDialog.SetUseNeedItem(true);
	teleportDialog.StartNeedItemList(1);
	teleportCost = Class'InterfaceClassic.TeleportWnd'.static.Inst().GetTeleportCost(targetTeleport.Price[0].Amount, targetTeleport.UsableLevel, targetTeleport.UsableTransferDegree);
	if((targetTeleport.Price.Length > 0))
	{
		teleportDialog.AddNeedItemClassID(targetTeleport.Price[0].Id, teleportCost);
	}
	teleportDialog.SetItemNum(1);
	teleportDialog.Show();
	teleportDialog.nDialogID = TeleportID;
	teleportDialog.DelegateOnClickBuy = OnTeleportDialogConfirm;
	teleportDialog.DelegateOnCancel = OnTeleportDialogCancel;
	return;
}

function bool GetCurrentTeleportInfo(out TeleportListAPI.TeleportListData o_tInfo, int TeleportID)
{
	local TeleportListAPI.TeleportListData tInfo;

	tInfo = Class'NWindow.TeleportListAPI'.static.GetFirstTeleportListData();
	while(("" != tInfo.Name))
	{
		if((tInfo.Id == TeleportID))
		{
			o_tInfo = tInfo;
			return true;
		}
		tInfo = Class'NWindow.TeleportListAPI'.static.GetNextTeleportListData();
	}
	return false;
}

function string htmlTableAdd(optional string backgroundUrl)
{
	local string htmlStr;

	if((backgroundUrl == ""))
	{
		htmlStr = ("<table width=290 cellpadding=2 border=0 cellspacing=0" $ "><tr><td width=0></td><td width=290>");
	}
	else
	{
		htmlStr = (("<table width=290 cellpadding=2 border=0 cellspacing=0 background=" $ backgroundUrl) $ "><tr><td width=0></td><td width=290>");
	}
	return htmlStr;
}

function string htmlTableTrAdd()
{
	return "<tr><td width=40 ></td><td width=115 ></td><td width=40 ></td><td width=115 ></td></tr>";
}

function string htmlfontAdd(string strText, optional string FontColor)
{
	local string targetHtml;

	if((FontColor == ""))
	{
		FontColor = "d3c5ae";
	}
	targetHtml = ((((("<font color=\"" $ FontColor) $ "\"") $ ">") $ strText) $ "</font>");
	return targetHtml;
}

function int getLanguageNumber()
{
	local UIEventManager.ELanguageType Language;
	local int languageNum;

	Language = GetLanguage();
	switch(Language)
	{
		case LANG_Korean:
			languageNum = 0;
			break;
		case LANG_English:
			languageNum = 1;
			break;
		case LANG_Japanese:
			languageNum = 2;
			break;
		case LANG_Taiwan:
			languageNum = 3;
			break;
		case LANG_Chinese:
			languageNum = 4;
			break;
		case LANG_Thai:
			languageNum = 5;
			break;
		case LANG_Philippine:
			languageNum = 6;
			break;
		case LANG_Indonesia:
			languageNum = 7;
			break;
		case LANG_Russia:
			languageNum = 8;
			break;
		case LANG_Euro:
			languageNum = 9;
			break;
		case LANG_Germany:
			languageNum = 10;
			break;
		case LANG_France:
			languageNum = 11;
			break;
		case LANG_Poland:
			languageNum = 12;
			break;
		case LANG_Turkey:
			languageNum = 13;
			break;
		default:
			languageNum = 0;
			break;
	}
	return languageNum;
}

function AddHtmlString(out string HtmlString, string AddString)
{
	if((AddString == ""))
	{
		return;
	}
	HtmlString = ((HtmlString $ "<br>") $ AddString);
	return;
}

function AddString(out string textstring, optional string AddString)
{
	if((textstring != ""))
	{
		textstring = (textstring $ "\\n");
	}
	if((AddString == ""))
	{
		return;
	}
	textstring = (textstring $ AddString);
	return;
}

function bool API_GetNQuestData(int a_QuestID, out NQuestUIData o_data)
{
	return GetNQuestData(a_QuestID, o_data);
}

function bool API_GetNQuestDialogData(int a_QuestID, out NQuestDialogUIData o_data)
{
	return GetNQuestDialogData(a_QuestID, o_data);
}

function API_GetClientCursorPos(out int X, out int Y)
{
	GetClientCursorPos(X, Y);
	return;
}

function RQ_C_EX_QUEST_TELEPORT()
{
	local array<byte> stream;
	local UIPacket._C_EX_QUEST_TELEPORT packet;

	packet.nID = teleportDialog.nDialogID;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_QUEST_TELEPORT(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(827, stream);
	return;
}
