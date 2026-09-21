class QuestWnd extends UICommonAPI
	dependson(UIPacket);

var array<byte> _emptyByteArray;

const QuestWnd_MAX_COUNT = 40;
const QUEST_WINDOW_ONE = 0;
const QUEST_WINDOW_REPEAT = 1;
const QUEST_WINDOW_EPIC = 2;
const QUEST_WINDOW_JOB = 3;
const QUEST_WINDOW_SPECIAL = 4;

enum LMOUSEDOWNTYPEENUM
{
	non,                            // 0
	listSelect,                     // 1
	showDialogAgain,                // 2
	showDialogAccecptable           // 3
};

enum NotifType
{
	NOTIF_ACCEPT,                   // 0
	NOTIF_PROGRESS,                 // 1
	NOTIF_COMPLETE,                 // 2
	NOTIF_CANCEL                    // 3
};

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
var array<QuestUseInfo> ArrQuest;
var QuestDrawerWnd scTreeDrawer;
var ButtonHandle m_btnAddAlarm;
var ButtonHandle m_btnDeleteAlarm;
var L2Util util;
var int QuestID_Alarm;
var int QuestLevel_Alarm;
var int QuestEnd_Alarm;
var int m_OldQuestID;
var ListCtrlHandle ListTrackItem1;
var array<LVDataRecord> m_QuestTrackData;
var int m_TrackID;
var int m_DeleteQuestID;
var string m_DeleteNodeName;
var int m_recentlyQuestID;
var NoticeWnd NoticeWndScript;
var Vector currentQuestDirectTargetPos;
var string currentQuestDirectTargetString;
var int overedIndex;
var int nProceedingQuestCount;
var int toSelectqID;
var bool bRequest_C_EX_QUEST_UI;
var bool bRequest_S_EX_QUEST_ACCEPTABLE_LIST;
var LMOUSEDOWNTYPEENUM lMouseDownType;

static function QuestWnd Inst()
{
	return QuestWnd(GetScript("QuestWnd"));
}

event OnRegisterEvent()
{
	RegisterEvent(40);
	RegisterEvent(730);
	RegisterEvent(EV_PacketID(1081));
	RegisterEvent(EV_PacketID(1079));
	RegisterEvent(EV_PacketID(1083));
	RegisterEvent(EV_PacketID(1082));
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	util = L2Util(GetScript("L2Util"));
	scTreeDrawer = QuestDrawerWnd(GetScript("QuestDrawerWnd"));
	NoticeWndScript = NoticeWnd(GetScript("NoticeWnd"));
	m_OldQuestID = 0;
	m_recentlyQuestID = 0;
	GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".questListCtrl0")).SetSelectedSelTooltip(false);
	GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".questListCtrl0")).SetAppearTooltipAtMouseX(true);
	GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".questListCtrl1")).SetSelectedSelTooltip(false);
	GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".questListCtrl1")).SetAppearTooltipAtMouseX(true);
	GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".questListCtrl2")).SetSelectedSelTooltip(false);
	GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".questListCtrl2")).SetAppearTooltipAtMouseX(true);
	return;
}

function Initialize()
{
	QuestTreeTab = GetTabHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".QuestTreeTab"));
	TexTabBg = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".TexTabBg"));
	TexTabBgLine = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".TexTabBgLine"));
	txtQuestTreeTitle = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtQuestTreeTitle"));
	txtQuestNum = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtQuestNum"));
	m_btnAddAlarm = GetButtonHandle("QuestDrawerWnd.btnAddAlarm");
	m_btnDeleteAlarm = GetButtonHandle("QuestDrawerWnd.btnDeleteAlarm");
	return;
}

event OnShow()
{
	Me.SetFocus();
	RQ_C_EX_QUEST_ACCEPTABLE_LIST();
	RQ_C_EX_QUEST_UI();
	QuestProgressWnd(GetScript("QuestProgressWnd"))._Show();
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_PacketID(1082):
			RT_S_EX_QUEST_ACCEPTABLE_ALARM();
			break;
		case EV_PacketID(1083):
			RT_S_EX_QUEST_ACCEPTABLE_LIST();
			break;
		case EV_PacketID(1079):
			RT_S_EX_QUEST_NOTIFICATION();
			break;
		case EV_PacketID(1081):
			RT_S_EX_QUEST_UI();
			break;
		case 40:
			bRequest_C_EX_QUEST_UI = false;
			SetQuestOff();
			break;
		default:
			break;
	}
	if((Event_ID == 730))
	{
		HandleQuestSetCurrentID(param);
		Me.SetFocus();
	}
	return;
}

event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath).HideWindow();
	return;
}

event OnDBClickListCtrlRecord(string ListCtrlID)
{
	scTreeDrawer._OnbtnShowDialog();
	return;
}

event OnClickButton(string strID)
{
	if((InStr(strID, "btnInfoAccecptable") == 0))
	{
		lMouseDownType = showDialogAccecptable;
	}
	else if((InStr(strID, "btnInfo") == 0))
	{
		lMouseDownType = showDialogAgain;
	}
	else
	{
		return;
	}
	m_hOwnerWnd.EnableTick();
	return;
}

event OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	if((InStr(a_WindowHandle.GetWindowName(), "questListCtrl") == -1))
	{
		return;
	}
	lMouseDownType = listSelect;
	m_hOwnerWnd.EnableTick();
	return;
}

event OnTick()
{
	local int topIndex, qid;
	local RichListCtrlRowData rowData;

	topIndex = GetTabHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".QuestTreeTab")).GetTopIndex();
	GetRichListCtrlHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".questListCtrl") $ string(topIndex))).GetSelectedRec(rowData);
	qid = int(rowData.nReserved1);
	switch(lMouseDownType)
	{
		case listSelect:
			scTreeDrawer._SetCurrentQuestInfos(qid, int(rowData.nReserved2), int(rowData.nReserved3));
			break;
		case showDialogAccecptable:
			scTreeDrawer.m_hOwnerWnd.HideWindow();
			Class'InterfaceClassic.QuestDialogWnd'.static.Inst()._ShowStartDialog(qid);
			break;
		case showDialogAgain:
			Class'InterfaceClassic.QuestDialogWnd'.static.Inst()._SohwDialogAgain(qid);
			break;
		default:
			break;
	}
	lMouseDownType = non;
	m_hOwnerWnd.DisableTick();
	return;
}

function curQuestExpand(int QuestID)
{
	m_recentlyQuestID = QuestID;
	return;
}

function Vector getCurrentQuestDirectTargetPos()
{
	return currentQuestDirectTargetPos;
}

function Detele3DArrow()
{
	local int QuestID;
	local Vector vTargetPos;

	QuestID = 1;
	if((QuestID == 0))
	{
		if(!IsPlayerOnWorldRaidServer())
		{
			Class'NWindow.QuestAPI'.static.SetQuestTargetInfo(false, false, false, "", vTargetPos, QuestID, 0);
		}
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("QuestDrawerWnd");
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

function initVars()
{
	m_OldQuestID = 0;
	m_TrackID = 0;
	m_DeleteQuestID = 0;
	m_DeleteNodeName = "";
	ArrQuest.Remove(0, ArrQuest.Length);
	return;
}

function UpdateTargetNoneCheckPosBox(bool ShowArrow)
{
	if(ShowArrow)
	{
	}
	else
	{
		SetQuestOff();
	}
	return;
}

function SetQuestOff()
{
	UpdateQuestCount();
	CallGFxFunction("RadarMapWnd", "hideQuestTargetInfo", "");
	CallGFxFunction("MiniMapGfxWnd", "hideQuestTargetInfo", "");
	return;
}

function UpdateQuestCount()
{
	txtQuestNum.SetText((((("(" $ string(nProceedingQuestCount)) $ "/") $ string(40)) $ ")"));
	return;
}

function HandleQuestSetCurrentID(string param)
{
	return;
}

function _HandleQuestSetCurrentIDfromMiniMap(int QuestID, int Level, int nQuestType)
{
	return;
}

function _SetSelectQuest(int qid)
{
	local int Index;

	GetTabHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".QuestTreeTab")).SetTopOrder(GetTopIndex(qid), true);
	Index = GetQuestIndex(qid);
	if(!m_hOwnerWnd.IsShowWindow())
	{
		toSelectqID = qid;
		m_hOwnerWnd.ShowWindow();
		return;
	}
	if((Index == -1))
	{
		RQ_C_EX_QUEST_UI();
		toSelectqID = qid;
		return;
	}
	m_hOwnerWnd.SetFocus();
	GetRichListCtrlByID(qid).SetSelectedIndex(Index, true);
	lMouseDownType = listSelect;
	m_hOwnerWnd.EnableTick();
	return;
}

function int GetIndexWithStateNQid(int cState, int qid, int nCount)
{
	local int i;
	local bool isCompleted;
	local RichListCtrlHandle rHandle;
	local RichListCtrlRowData rowData;

	rHandle = GetRichListCtrlByID(qid);
	isCompleted = GetIsComplete(qid, nCount);
	i = 0;
	while((i < rHandle.GetRecordCount()))
	{
		rHandle.GetRec(i, rowData);
		if((rowData.nReserved3 < INT64(cState)))
		{
			i++;
			continue;
		}
		if((rowData.nReserved3 > INT64(cState)))
		{
			return i;
		}
		if((cState == 1))
		{
			if((isCompleted != GetIsComplete(int(rowData.nReserved1), int(rowData.nReserved2))))
			{
				if(isCompleted)
				{
					i++;
					continue;
				}
				else
				{
					return i;
				}
			}
		}
		if((rowData.nReserved1 < INT64(qid)))
		{
			return i;
		}
		i++;
	}
	return rHandle.GetRecordCount();
}

function Handle_S_EX_QUEST_NOTIFICATION(int qid, int nCount, int cNotifType)
{
	local int i;
	local RichListCtrlRowData rowData;
	local RichListCtrlHandle rHandle;

	if(!m_hOwnerWnd.IsShowWindow())
	{
		return;
	}
	i = GetQuestIndex(qid);
	rHandle = GetRichListCtrlByID(qid);
	switch(cNotifType)
	{
		case 0:
			nProceedingQuestCount++;
			if((i != -1))
			{
				rHandle.DeleteRecord(i);
			}
			if((MakeRowData(qid, nCount, 1, rowData) == false))
			{
				break;
			}
			InsertRecord(rHandle, rowData, GetIndexWithStateNQid(1, qid, nCount));
			break;
		case 1:
			if((MakeRowData(qid, nCount, 1, rowData) == false))
			{
				break;
			}
			if((GetIsComplete(qid, nCount) == false))
			{
				rHandle.ModifyRecord(i, rowData);
			}
			else
			{
				rHandle.DeleteRecord(i);
				InsertRecord(rHandle, rowData, GetIndexWithStateNQid(1, qid, nCount));
			}
			if((Class'InterfaceClassic.QuestDrawerWnd'.static.Inst()._GetCurrentQuestID() == qid))
			{
				Class'InterfaceClassic.QuestDrawerWnd'.static.Inst()._SetCurrentQuestInfos(qid, nCount, 1);
			}
			break;
		case 2:
			nProceedingQuestCount--;
			if((Class'InterfaceClassic.QuestDrawerWnd'.static.Inst()._GetCurrentQuestID() == qid))
			{
				GetWindowHandle("QuestDrawerWnd").HideWindow();
			}
			rHandle.DeleteRecord(i);
			if(IsDisplayOnCompleteCheck(qid))
			{
				if(MakeRowData(qid, nCount, 2, rowData))
				{
					InsertRecord(rHandle, rowData, GetIndexWithStateNQid(2, qid, nCount));
				}
			}
			break;
		case 3:
			nProceedingQuestCount--;
			if((Class'InterfaceClassic.QuestDrawerWnd'.static.Inst()._GetCurrentQuestID() == qid))
			{
				GetWindowHandle("QuestDrawerWnd").HideWindow();
			}
			rHandle.DeleteRecord(i);
			RQ_C_EX_QUEST_ACCEPTABLE_LIST();
			break;
		default:
			break;
	}
	UpdateQuestCount();
	return;
}

function bool IsDisplayOnCompleteCheck(int qid)
{
	local NQuestUIData questUIData;

	if(!API_GetNQuestData(qid, questUIData))
	{
		return false;
	}
	if((qid < 20001))
	{
		return true;
	}
	switch(questUIData.Type)
	{
		case NQT_ONETIME:
			return true;
		case NQT_DAILY:
		case NQT_WEEKLY:
		case NQT_REPEAT:
			return false;
		default:
			return false;
	}
}

function bool GetIsComplete(int qid, int nCount)
{
	local NQuestUIData questUIData;

	if(!API_GetNQuestData(qid, questUIData))
	{
		return false;
	}
	return (questUIData.Goal.Num <= nCount);
}

function bool MakeRowData(int qid, int nCount, int cState, out RichListCtrlRowData oRowData)
{
	local NQuestUIData questUIData;
	local RichListCtrlRowData rowData;
	local Color TextColor;
	local bool isComplete;

	if(!API_GetNQuestData(qid, questUIData))
	{
		return false;
	}
	if((cState == 2))
	{
		if(!IsDisplayOnCompleteCheck(qid))
		{
			return false;
		}
	}
	rowData.cellDataList.Length = 2;
	rowData.nReserved1 = INT64(qid);
	rowData.nReserved2 = INT64(nCount);
	rowData.nReserved3 = INT64(cState);
	rowData.cellDataList[0].szData = questUIData.Name;
	if((cState == -1))
	{
		TextColor = getInstanceL2Util().White;
	}
	else if((cState == 1))
	{
		isComplete = (questUIData.Goal.Num <= nCount);
		if(isComplete)
		{
			TextColor = GetColor(255, 221, 102, 255);
		}
		else
		{
			TextColor = GetColor(170, 153, 119, 255);
		}
	}
	else
	{
		TextColor = GetColor(170, 153, 119, 100);
	}
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems, GetIconTextureByState(cState, isComplete), 24, 24, 4, 0, 24, 24);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, questUIData.Name, TextColor, false, 2, 5);
	if((cState == 2))
	{
		AddRichListCtrlButton(rowData.cellDataList[1].drawitems, "btnInfo", 0, 0, "L2UI_NewTex.Talk_Disable", "L2UI_NewTex.Talk_Disable", "L2UI_NewTex.Talk_Disable", 32, 32, 32, 32);
	}
	else if((cState == -1))
	{
		AddRichListCtrlButton(rowData.cellDataList[1].drawitems, "btnInfoAccecptable", 0, 0, "L2UI_NewTex.QuestWnd.Talk_DF", "L2UI_NewTex.QuestWnd.Talk_Down", "L2UI_NewTex.QuestWnd.Talk_Over", 32, 32, 32, 32);
	}
	else
	{
		AddRichListCtrlButton(rowData.cellDataList[1].drawitems, "btnInfo", 0, 0, "L2UI_NewTex.QuestWnd.Talk_DF", "L2UI_NewTex.QuestWnd.Talk_Down", "L2UI_NewTex.QuestWnd.Talk_Over", 32, 32, 32, 32);
	}
	oRowData = rowData;
	return true;
}

function Handle_S_EX_S_EX_QUEST_UI(array<UIPacket._PkQuestInfo> questInfos)
{
	local int i;
	local RichListCtrlRowData rowData;
	local RichListCtrlHandle rHandle;

	DeleteAllNotAcceptableList();
	i = questInfos.Length;
	while((i >= 0))
	{
		if((MakeRowData(questInfos[i].nID, questInfos[i].nCount, questInfos[i].cState, rowData) == false))
		{
			i--;
			continue;
		}
		rHandle = GetRichListCtrlByID(questInfos[i].nID);
		InsertRecord(rHandle, rowData, GetIndexWithStateNQid(questInfos[i].cState, questInfos[i].nID, questInfos[i].nCount));
		i--;
	}
	return;
}

function InsertRecord(RichListCtrlHandle rHandle, RichListCtrlRowData rowDataNew, int Index)
{
	local int i, lastIndex, lastSelectedIndex;
	local RichListCtrlRowData rowData;

	lastSelectedIndex = rHandle.GetSelectedIndex();
	if((rHandle.GetRecordCount() == 0))
	{
		rHandle.InsertRecord(rowDataNew);
	}
	else
	{
		lastIndex = (rHandle.GetRecordCount() - 1);
		rHandle.GetRec(lastIndex, rowData);
		rHandle.InsertRecord(rowData);
		i = lastIndex;
		while((i > Index))
		{
			rHandle.GetRec((i - 1), rowData);
			rHandle.ModifyRecord(i, rowData);
			i--;
		}
		rHandle.ModifyRecord(Index, rowDataNew);
	}
	if((lastSelectedIndex >= Index))
	{
		rHandle.SetSelectedIndex((lastSelectedIndex + 1), false);
	}
	return;
}

function RT_S_EX_QUEST_UI()
{
	local int Index;
	local UIPacket._S_EX_QUEST_UI packet;

	bRequest_C_EX_QUEST_UI = false;
	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_QUEST_UI(packet))
	{
		return;
	}
	nProceedingQuestCount = packet.nProceedingQuestCount;
	UpdateQuestCount();
	Handle_S_EX_S_EX_QUEST_UI(packet.questInfos);
	if((toSelectqID < 1))
	{
		return;
	}
	Index = GetQuestIndex(toSelectqID);
	if((Index == -1))
	{
		return;
	}
	m_hOwnerWnd.ShowWindow();
	m_hOwnerWnd.SetFocus();
	GetRichListCtrlByID(toSelectqID).SetSelectedIndex(Index, true);
	lMouseDownType = listSelect;
	m_hOwnerWnd.EnableTick();
	toSelectqID = -1;
	return;
}

function RT_S_EX_QUEST_NOTIFICATION()
{
	local UIPacket._S_EX_QUEST_NOTIFICATION packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_QUEST_NOTIFICATION(packet))
	{
		return;
	}
	Handle_S_EX_QUEST_NOTIFICATION(packet.nID, packet.nCount, packet.cNotifType);
	return;
}

function RQ_C_EX_QUEST_UI()
{
	if(bRequest_C_EX_QUEST_UI)
	{
		return;
	}
	bRequest_C_EX_QUEST_UI = true;
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(832, _emptyByteArray);
	return;
}

function RT_S_EX_QUEST_ACCEPTABLE_LIST()
{
	local UIPacket._S_EX_QUEST_ACCEPTABLE_LIST packet;

	bRequest_S_EX_QUEST_ACCEPTABLE_LIST = false;
	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_QUEST_ACCEPTABLE_LIST(packet))
	{
		return;
	}
	Handle_S_EX_QUEST_ACCEPTABLE_LIST(packet.questIDs);
	return;
}

function RQ_C_EX_QUEST_ACCEPTABLE_LIST()
{
	if(bRequest_S_EX_QUEST_ACCEPTABLE_LIST)
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(833, _emptyByteArray);
	return;
}

function RT_S_EX_QUEST_ACCEPTABLE_ALARM()
{
	NoticeWnd(GetScript("NoticeWnd")).ArriveShowQuest();
	return;
}

function bool API_GetNQuestData(int a_QuestID, out NQuestUIData o_data)
{
	return GetNQuestData(a_QuestID, o_data);
}

function bool IsMainQuest(int qid)
{
	return (qid < 20001);
}

function int GetTopIndex(int qid)
{
	if((qid < 20001))
	{
		return 0;
	}
	if((qid < 30001))
	{
		return 1;
	}
	return 2;
}

function RichListCtrlHandle GetRichListCtrlByID(int qid)
{
	return GetRichListCtrlHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".questListCtrl") $ string(GetTopIndex(qid))));
}

function int GetQuestIndex(int qid)
{
	local int i;
	local RichListCtrlRowData rowData;
	local RichListCtrlHandle rHandle;

	rHandle = GetRichListCtrlByID(qid);
	i = 0;
	while((i < rHandle.GetRecordCount()))
	{
		rHandle.GetRec(i, rowData);
		if((rowData.nReserved1 == INT64(qid)))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function int GetStartIndexProgress(RichListCtrlHandle rHandle)
{
	local int i;
	local RichListCtrlRowData rowData;

	i = rHandle.GetRecordCount();
	while((i >= 0))
	{
		rHandle.GetRec(i, rowData);
		if((rowData.nReserved3 == INT64(-1)))
		{
			return (i + 1);
		}
		i--;
	}
	return 0;
}

function int GetEndIndexProgress(RichListCtrlHandle rHandle)
{
	local int i;
	local RichListCtrlRowData rowData;

	i = rHandle.GetRecordCount();
	while((i >= 0))
	{
		rHandle.GetRec(i, rowData);
		if((rowData.nReserved3 == INT64(1)))
		{
			return (i + 1);
		}
		i--;
	}
	return GetStartIndexProgress(rHandle);
}

function string _GetIconTextureByState(int State, bool isComplete)
{
	return GetIconTextureByState(State, isComplete);
}

function string GetIconTextureByState(int State, bool isComplete)
{
	switch(State)
	{
		case -1:
			return "L2UI_NewTex.QuestWnd.Icon_Quest01";
		case 1:
			if(isComplete)
			{
				return "L2UI_NewTex.QuestWnd.Icon_Quest03";
			}
			else
			{
				return "L2UI_NewTex.QuestWnd.Icon_Quest02";
			}
		default:
			return "L2UI_NewTex.QuestWnd.Icon_Quest04";
	}
}

function DeleteAllAcceptableList()
{
	local int i, listIndex, currentindex;
	local RichListCtrlRowData rowData;
	local RichListCtrlHandle rHandle;
	local int Len;

	listIndex = 0;
	while((listIndex < 3))
	{
		rHandle = GetRichListCtrlHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".questListCtrl") $ string(listIndex)));
		Len = rHandle.GetRecordCount();
		currentindex = 0;
		i = 0;
		while((i < Len))
		{
			rHandle.GetRec(currentindex, rowData);
			if((rowData.nReserved3 == INT64(-1)))
			{
				rHandle.DeleteRecord(currentindex);
				i++;
				continue;
			}
			currentindex++;
			i++;
		}
		listIndex++;
	}
	return;
}

function DeleteAllNotAcceptableList()
{
	local int i, listIndex;
	local RichListCtrlRowData rowData;
	local RichListCtrlHandle rHandle;

	listIndex = 0;
	while((listIndex < 3))
	{
		rHandle = GetRichListCtrlHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".questListCtrl") $ string(listIndex)));
		i = (rHandle.GetRecordCount() - 1);
		while((i >= 0))
		{
			rHandle.GetRec(i, rowData);
			if((rowData.nReserved3 == INT64(-1)))
			{
				break;
			}
			rHandle.DeleteRecord(i);
			i--;
		}
		listIndex++;
	}
	return;
}

function Handle_S_EX_QUEST_ACCEPTABLE_LIST(array<int> questIDs)
{
	local int i;
	local RichListCtrlRowData rowData;
	local RichListCtrlHandle rHandle;

	DeleteAllAcceptableList();
	i = questIDs.Length;
	while((i >= 0))
	{
		rHandle = GetRichListCtrlByID(questIDs[i]);
		if(MakeRowData(questIDs[i], 0, -1, rowData))
		{
			InsertRecord(rHandle, rowData, 0);
		}
		i--;
	}
	return;
}

function _ToggleShowByNotice()
{
	local int listIndex;
	local RichListCtrlRowData rowData;
	local RichListCtrlHandle rHandle;

	if(m_hOwnerWnd.IsShowWindow())
	{
		m_hOwnerWnd.HideWindow();
		return;
	}
	else
	{
		m_hOwnerWnd.ShowWindow();
		m_hOwnerWnd.SetFocus();
	}
	listIndex = 2;
	while((listIndex >= 0))
	{
		rHandle = GetRichListCtrlHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".questListCtrl") $ string(listIndex)));
		rHandle.GetRec(0, rowData);
		if((int(rowData.nReserved3) == -1))
		{
			GetTabHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".QuestTreeTab")).SetTopOrder(listIndex, true);
			return;
		}
		listIndex--;
	}
	return;
}
