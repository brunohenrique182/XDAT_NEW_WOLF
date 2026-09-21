class QuestProgressWnd extends UICommonAPI
	dependson(UIPacket);

var array<byte> _emptyByteArray;

const QUEST_REQUEST_TIMERID = 1123;
const LISTWIDTH = 250;
const WNDWIDTH = 270;
const MaxHeight = 200;
const MAXLISTCOUNT = 4;
const LIST_HEIGHT = 40;
const DIALOG_TOOLTIP_KEY0 = "\\#$Tooltip0";

enum NotifType
{
	NOTIF_ACCEPT,                   // 0
	NOTIF_PROGRESS,                 // 1
	NOTIF_COMPLETE,                 // 2
	NOTIF_CANCEL                    // 3
};

var int RecentlyAddedQuestID;
var string currentGFxMsg;
var WindowHandle Me;
var L2UITimerObject tObject;
var L2UITimerObject tObjectDeactiveOld;
var int lastActiveQID;
var RichListCtrlHandle QuestAlarmList_RichList;
var UIControlDialogAssets teleportDialog;
//var delegate<OnSortValueCompare> __OnSortValueCompare__Delegate;

delegate int OnSortValueCompare(int bitA, int bitB)
{
	if((bitA > bitB))
	{
		return -1;
	}
	return 1;
}

function Initialize()
{
	QuestAlarmList_RichList = GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".QuestAlarmList_RichList"));
	QuestAlarmList_RichList.SetSelectedSelTooltip(false);
	QuestAlarmList_RichList.SetAppearTooltipAtMouseX(true);
	QuestAlarmList_RichList.SetUseStripeBackTexture(false);
	teleportDialog = Class'InterfaceClassic.UIControlDialogAssets'.static.InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".UIControlDialogAsset")));
	teleportDialog.NeedItemRichListCtrl.SetColumnWidth(0, 200);
	teleportDialog.Hide();
	teleportDialog._SetHeaderType(SIMPLEHEADER);
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(40);
	RegisterEvent(EV_PacketID(1080));
	RegisterEvent(EV_PacketID(1079));
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	tObject = Class'InterfaceClassic.L2UITimer'.static.Inst()._MakeTimerObject(8000, 1);
	tObject._DelegateOnTime = DlegateOnTimeCheckNew;
	tObjectDeactiveOld = Class'InterfaceClassic.L2UITimer'.static.Inst()._MakeTimerObject(4000, 1);
	tObjectDeactiveOld._DelegateOnTime = DlegateOnTimeCheckDeactiveOld;
	return;
}

event OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 40:
			tObject._Stop();
			tObjectDeactiveOld._Stop();
			Me.KillTimer(1123);
			RecentlyAddedQuestID = 0;
			break;
		case EV_PacketID(1080):
			RT_S_EX_QUEST_NOTIFICATION_ALL();
			break;
		case EV_PacketID(1079):
			RT_S_EX_QUEST_NOTIFICATION();
			break;
		default:
			break;
	}
	return;
}

event OnTick()
{
	m_hOwnerWnd.DisableTick();
	RQ_C_EX_Teleport_UI();
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "btnClose":
			_Hide();
			SetINIBool(m_hOwnerWnd.m_WindowNameWithFullPath, "v", false, "windowsInfo.ini");
			break;
		default:
			break;
	}
	return;
}

event OnHide()
{
	teleportDialog.Hide();
	ReLoadOnTeleportShowHide();
	return;
}

event OnShow()
{
	TeleportDialogModeOnOff();
	return;
}

event OnRClickListCtrlRecord(string ListCtrlID)
{
	local int Index;

	Index = QuestAlarmList_RichList.GetSelectedIndex();
	Class'InterfaceClassic.QuestWnd'.static.Inst()._SetSelectQuest(GetQuestIDAtIndex(Index));
	QuestAlarmList_RichList.SetSelectedIndex(-1, false);
	Class'InterfaceClassic.QuestWnd'.static.Inst().m_hOwnerWnd.SetFocus();
	return;
}

event OnClickListCtrlRecord(string ListCtrlID)
{
	local RichListCtrlRowData rowData;
	local int Index;

	Index = QuestAlarmList_RichList.GetSelectedIndex();
	QuestAlarmList_RichList.GetRec(Index, rowData);
	if((rowData.cellDataList[0].nReserved1 == 1))
	{
		Class'InterfaceClassic.QuestDialogWnd'.static.Inst()._ShowCompleteDialog(GetQuestIDAtIndex(Index), true);
	}
	else
	{
		ChkTeleport(GetQuestIDAtIndex(Index));
	}
	QuestAlarmList_RichList.SetSelectedIndex(-1, false);
	return;
}

event OnDBClickListCtrlRecord(string ListCtrlID)
{
	QuestAlarmList_RichList.SetSelectedIndex(-1, false);
	return;
}

event OnEnterState(name a_CurrentStateName)
{
	if((QuestAlarmList_RichList.GetRecordCount() == 0))
	{
		return;
	}
	if(IsVisible())
	{
		m_hOwnerWnd.ShowWindow();
	}
	else
	{
		m_hOwnerWnd.HideWindow();
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

function _Show(optional bool bSetFocus)
{
	local bool isFocus;

	if(!IsShowCondition())
	{
		return;
	}
	isFocus = (!m_hOwnerWnd.IsShowWindow() || bSetFocus);
	reSizeWindow();
	SetINIBool(m_hOwnerWnd.m_WindowNameWithFullPath, "v", true, "windowsInfo.ini");
	m_hOwnerWnd.ShowWindow();
	if(isFocus)
	{
		m_hOwnerWnd.SetFocus();
	}
	return;
}

function _Hide()
{
	m_hOwnerWnd.HideWindow();
	return;
}

function MoveRecord(int fromIndex, int toIndex)
{
	local RichListCtrlRowData rowData;

	if((fromIndex == toIndex))
	{
		return;
	}
	QuestAlarmList_RichList.GetRec(fromIndex, rowData);
	if((fromIndex < toIndex))
	{
		InsertRecord(rowData, toIndex);
		QuestAlarmList_RichList.DeleteRecord(fromIndex);
	}
	else
	{
		QuestAlarmList_RichList.DeleteRecord(fromIndex);
		InsertRecord(rowData, toIndex);
	}
	return;
}

function InsertRecord(RichListCtrlRowData rowDataNew, int Index)
{
	local int i, lastIndex;
	local RichListCtrlRowData rowData;

	if((QuestAlarmList_RichList.GetRecordCount() == 0))
	{
		QuestAlarmList_RichList.InsertRecord(rowDataNew);
	}
	else
	{
		lastIndex = (QuestAlarmList_RichList.GetRecordCount() - 1);
		QuestAlarmList_RichList.GetRec(lastIndex, rowData);
		QuestAlarmList_RichList.InsertRecord(rowData);
		i = lastIndex;
		while((i > Index))
		{
			QuestAlarmList_RichList.GetRec((i - 1), rowData);
			QuestAlarmList_RichList.ModifyRecord(i, rowData);
			i--;
		}
		QuestAlarmList_RichList.ModifyRecord(Index, rowDataNew);
	}
	return;
}

function string GetQuestName(int qid)
{
	local NQuestUIData questUIData;

	if(!API_GetNQuestData(qid, questUIData))
	{
		return "";
	}
	return questUIData.Name;
}

function bool MakeRowData(int qid, int nCount, bool IsActive, out RichListCtrlRowData o_rowData, out int isComplete)
{
	local NQuestUIData questUIData;
	local RichListCtrlRowData rowData;
	local Color typeColor;
	local int textW, textH;
	local array<string> tooltipStrings;
	local NQuestDialogUIData questDialogUIData;
	local int i;

	if(!API_GetNQuestData(qid, questUIData))
	{
		return false;
	}
	rowData.cellDataList.Length = 1;
	if((questUIData.Goal.Num <= nCount))
	{
		isComplete = 1;
	}
	else
	{
		isComplete = 0;
	}
	rowData.nReserved1 = INT64(qid);
	rowData.nReserved2 = INT64(nCount);
	rowData.cellDataList[0].nReserved1 = isComplete;
	rowData.cellDataList[0].nReserved2 = int(IsActive);
	if((isComplete == 1))
	{
		typeColor = GetColor(255, 221, 102, 255);
	}
	else if(IsActive)
	{
		typeColor = GetColor(221, 221, 221, 255);
	}
	else
	{
		typeColor = GetColor(120, 120, 120, 255);
	}
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_NewTex.QuestWnd.AlarmListBg", 235, 40, 0, -40);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, "", GetColor(0, 0, 0, 0), true);
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems, GetTypeIcon(qid), 14, 14, 2, 5);
	AddEllipsisString(rowData.cellDataList[0].drawitems, questUIData.Name, 190, GetColor(170, 153, 119, 255), false, true, 20, 0);
	if(((isComplete == 0) && (questUIData.TeleportID > 0)))
	{
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, "", GetColor(0, 0, 0, 0), true);
		addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_CT1.Minimap.TelIcon_16", 16, 16, 193, -15);
		if((IsPlayerOnWorldRaidServer() == false))
		{
			ValidateTeleportInfo();
		}
	}
	GetTextSizeDefault(((string(nCount) $ "/") $ string(questUIData.Goal.Num)), textW, textH);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, ((string(nCount) $ "/") $ string(questUIData.Goal.Num)), typeColor, true, 0, 0);
	AddEllipsisString(rowData.cellDataList[0].drawitems, questUIData.Goal.Name, ((250 - 40) - textW), typeColor, false, true, 2, 0);
	if((teleportDialog.m_hOwnerWnd.IsShowWindow() && (teleportDialog.nDialogID == qid)))
	{
		rowData.sOverlayTex = "L2UI_NewTex.QuestWnd.ListBg_Teleoprt";
		rowData.OverlayTexU = 232;
		rowData.OverlayTexV = 40;
	}
	else
	{
		rowData.sOverlayTex = "";
	}
	API_GetNQuestDialogData(qid, questDialogUIData);
	GetStrings("\\#$Tooltip0", questDialogUIData.QuestInfo, tooltipStrings);
	if((tooltipStrings.Length > 0))
	{
		rowData.szReserved = tooltipStrings[0];
		i = 1;
		while((i < tooltipStrings.Length))
		{
			rowData.szReserved = ((rowData.szReserved $ "\\n") $ tooltipStrings[i]);
			i++;
		}
	}
	o_rowData = rowData;
	return true;
}

function ValidateTeleportInfo()
{
	m_hOwnerWnd.EnableTick();
	return;
}

function string GetTypeIcon(int qid)
{
	if((qid < 20001))
	{
		return "L2UI_NewTex.QuestWnd.QIcon_Main";
	}
	if((qid < 30001))
	{
		return "L2UI_NewTex.QuestWnd.QIcon_Sub";
	}
	return "L2UI_NewTex.QuestWnd.QIcon_Especial";
}

function reSizeWindow()
{
	local int listHeight;

	listHeight = Min(160, (QuestAlarmList_RichList.GetRecordCount() * 40));
	QuestAlarmList_RichList.ShowScrollBar(((40 * 4) <= listHeight));
	QuestAlarmList_RichList.SetWindowSize(250, listHeight);
	m_hOwnerWnd.SetWindowSize(270, (Min(200, listHeight) + 40));
	return;
}

function Handle_S_EX_QUEST_NOTIFICATION_ALL(array<UIPacket._PkQuestNotif> pkQuestNotifs)
{
	local int i;
	local RichListCtrlRowData rowData;
	local int isComplete;

	QuestAlarmList_RichList.DeleteAllItem();
	i = 0;
	while((i < pkQuestNotifs.Length))
	{
		if(MakeRowData(pkQuestNotifs[i].nID, pkQuestNotifs[i].nCount, false, rowData, isComplete))
		{
			if(IsMainQuest(pkQuestNotifs[i].nID))
			{
				InsertRecord(rowData, 0);
				i++;
				continue;
			}
			if((isComplete == 1))
			{
				if(IsMainQuestFirst())
				{
					InsertRecord(rowData, 1);
				}
				else
				{
					InsertRecord(rowData, 0);
				}
				i++;
				continue;
			}
			QuestAlarmList_RichList.InsertRecord(rowData);
		}
		i++;
	}
	if((IsShowCondition() && IsVisible()))
	{
		_Show();
	}
	else
	{
		_Hide();
	}
	return;
}

function Handle_S_EX_QUEST_NOTIFICATION(int qid, int nCount, int cNotifType)
{
	local int i, oIsComplete, toIndex;
	local RichListCtrlRowData rowData;

	switch(cNotifType)
	{
		case 0:
			if(MakeRowData(qid, nCount, false, rowData, oIsComplete))
			{
				if(IsMainQuest(qid))
				{
					InsertRecord(rowData, 0);
				}
				else
				{
					InsertRecord(rowData, GetActieLastOrNewFirstRecordIndex());
				}
				PlaySound("ItemSound.Quest_Accept_2023");
				Class'InterfaceClassic.L2Util'.static.Inst().showGfxScreenMessage(((MakeFullSystemMsg(GetSystemMessage(13854), (("&quot;" $ GetQuestName(qid)) $ "&quot;")) $ "<br>") $ currentGFxMsg));
				currentGFxMsg = "";
				_Show(true);
			}
			break;
		case 1:
			i = GetQuestIndex(qid);
			if(MakeRowData(qid, nCount, true, rowData, oIsComplete))
			{
				QuestAlarmList_RichList.ModifyRecord(i, rowData);
				if((oIsComplete == 1))
				{
					if((teleportDialog.nDialogID == qid))
					{
						teleportDialog.Hide();
						ReLoadOnTeleportShowHide();
					}
				}
				if(!IsMainQuest(qid))
				{
					if((oIsComplete == 1))
					{
						toIndex = GetCompleteLastRecord();
					}
					else
					{
						toIndex = GetActieLastOrNewFirstRecordIndex();
					}
					MoveRecord(i, toIndex);
				}
				if((oIsComplete == 0))
				{
					if((lastActiveQID != qid))
					{
						lastActiveQID = qid;
						tObjectDeactiveOld._Reset();
					}
					tObject._Reset();
				}
			}
			break;
		case 2:
			PlaySound("ItemSound.Quest_Done_2023");
			Class'InterfaceClassic.L2Util'.static.Inst().showGfxScreenMessage(((MakeFullSystemMsg(GetSystemMessage(13909), (("&quot;" $ GetQuestName(qid)) $ "&quot;")) $ "<br>") $ currentGFxMsg));
			currentGFxMsg = "";
		case 3:
			if((teleportDialog.nDialogID == qid))
			{
				teleportDialog.Hide();
				ReLoadOnTeleportShowHide();
			}
			i = GetQuestIndex(qid);
			QuestAlarmList_RichList.DeleteRecord(i);
			break;
		default:
			break;
	}
	if((IsShowCondition() && IsVisible()))
	{
		_Show();
	}
	else
	{
		_Hide();
	}
	if((oIsComplete == 1))
	{
		Class'InterfaceClassic.QuestDialogWnd'.static.Inst()._ShowCompleteDialog(qid);
	}
	if((cNotifType == 0))
	{
		ChkTeleportOnAccept(qid);
	}
	return;
}

function _SetGfxMsg(string Msg)
{
	currentGFxMsg = Msg;
	return;
}

function ChkTeleportOnAccept(int qid)
{
	local NQuestUIData questUIData;
	local TeleportListAPI.TeleportListData targetTeleport;

	teleportDialog.nDialogID = -1;
	if(!API_GetNQuestData(qid, questUIData))
	{
		return;
	}
	if((questUIData.InstantZoneID > 0))
	{
		if((API_GetCurrentZoneName() == GetInZoneNameWithZoneID(questUIData.InstantZoneID)))
		{
			return;
		}
	}
	else
	{
		if((questUIData.TeleportID < 1))
		{
			return;
		}
		if(!GetTeleportInfo(qid, targetTeleport))
		{
			return;
		}
		if((API_GetCurrentZoneName() == targetTeleport.Name))
		{
			return;
		}
	}
	ShowTeleportDialog(qid);
	if((teleportDialog.nDialogID == qid))
	{
		m_hOwnerWnd.ShowWindow();
	}
	return;
}

function ChkTeleport(int qid)
{
	local NQuestUIData questUIData;

	if(!API_GetNQuestData(qid, questUIData))
	{
		return;
	}
	if((questUIData.TeleportID < 1))
	{
		return;
	}
	ShowTeleportDialog(qid);
	return;
}

function ShowTeleportDialog(int qid)
{
	local string Desc, teleportName;
	local TeleportListAPI.TeleportListData targetTeleport;
	local INT64 teleportCost;
	local int instanceZoneID;
	local string tellzoneName;

	instanceZoneID = GetCurrentInstanceZoneID(qid);
	if(GetTeleportInfo(qid, targetTeleport))
	{
		tellzoneName = targetTeleport.Name;
		if((targetTeleport.Level > 0))
		{
			teleportName = (((("(" $ tellzoneName) $ " Lv ") $ string(targetTeleport.Level)) $ ")");
		}
		else
		{
			teleportName = (("(" $ tellzoneName) $ ")");
		}
		teleportCost = Class'InterfaceClassic.TeleportWnd'.static.Inst().GetTeleportCost(targetTeleport.Price[0].Amount, targetTeleport.UsableLevel, targetTeleport.UsableTransferDegree);
	}
	else if((instanceZoneID > 0))
	{
		tellzoneName = GetInZoneNameWithZoneID(instanceZoneID);
		teleportName = (((("(" $ tellzoneName) @ " - <font name=\"hs9\" color=\"FFDF4C\">") $ GetSystemString(2668)) $ "</font>)");
		teleportDialog.SetUseNeedItem(false);
	}
	else
	{
		return;
	}
	GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".UIControlDialogAsset.NeedItemWnd.NeedItemRichListCtrl")).SetUseHorizontalScrollBar(false);
	if((API_GetCurrentZoneName() == tellzoneName))
	{
		Desc = ((htmlAddText(GetSystemString(14434), "", getColorHexString(GTColor().Red)) @ "</br1>") $ htmlAddText(teleportName, ""));
	}
	else
	{
		Desc = ((GetSystemMessage(5239) @ "<br>") $ teleportName);
	}
	teleportDialog.SetDialogDescHtml(Desc);
	if((targetTeleport.Price.Length > 0))
	{
		teleportDialog.SetUseNeedItem(true);
		teleportDialog.StartNeedItemList(1);
		teleportDialog.AddNeedItemClassID(targetTeleport.Price[0].Id, teleportCost);
		teleportDialog.SetItemNum(1);
	}
	ReloadOnTeleportHide();
	teleportDialog.nDialogID = qid;
	teleportDialog.Show();
	teleportDialog.DelegateOnClickBuy = OnTeleportDialogConfirm;
	teleportDialog.DelegateOnCancel = OnTeleportDialogCancel;
	ReLoadOnTeleportShowHide();
	return;
}

function TeleportDialogModeOnOff()
{
	local int i;
	local array<WindowHandle> childs;

	m_hOwnerWnd.GetChildWindowList(childs);
	if(IsVisible())
	{
		i = 0;
		while((i < childs.Length))
		{
			if((teleportDialog.m_hOwnerWnd != childs[i]))
			{
				childs[i].ShowWindow();
			}
			i++;
		}
		teleportDialog.m_hOwnerWnd.MoveC(18, -188);
		reSizeWindow();
	}
	else
	{
		i = 0;
		while((i < childs.Length))
		{
			if((teleportDialog.m_hOwnerWnd != childs[i]))
			{
				childs[i].HideWindow();
			}
			i++;
		}
		teleportDialog.m_hOwnerWnd.MoveC(18, -158);
		m_hOwnerWnd.SetWindowSize(270, 30);
	}
	return;
}

function int GetTeleportID(int qid)
{
	local NQuestUIData questUIData;

	if(!API_GetNQuestData(qid, questUIData))
	{
		return -1;
	}
	return questUIData.TeleportID;
}

function bool GetTeleportInfo(int qid, out TeleportListAPI.TeleportListData o_tInfo)
{
	local TeleportListAPI.TeleportListData tInfo;
	local NQuestUIData questUIData;

	if(!API_GetNQuestData(qid, questUIData))
	{
		return false;
	}
	if((questUIData.TeleportID < 1))
	{
		return false;
	}
	tInfo = Class'NWindow.TeleportListAPI'.static.GetFirstTeleportListData();
	while(("" != tInfo.Name))
	{
		if((tInfo.Id == questUIData.TeleportID))
		{
			o_tInfo = tInfo;
			return true;
		}
		tInfo = Class'NWindow.TeleportListAPI'.static.GetNextTeleportListData();
	}
	return false;
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
		return;
	}
	RQ_C_EX_QUEST_TELEPORT();
	ReLoadOnTeleportShowHide();
	if(!IsVisible())
	{
		m_hOwnerWnd.HideWindow();
	}
	return;
}

function OnTeleportDialogCancel()
{
	teleportDialog.Hide();
	ReLoadOnTeleportShowHide();
	if(!IsVisible())
	{
		m_hOwnerWnd.HideWindow();
	}
	return;
}

function ReLoadOnTeleportShowHide()
{
	local int Index, isComplete;
	local RichListCtrlRowData rowData;

	Index = GetQuestIndex(teleportDialog.nDialogID);
	QuestAlarmList_RichList.GetRec(Index, rowData);
	if(MakeRowData(int(rowData.nReserved1), int(rowData.nReserved2), (rowData.cellDataList[0].nReserved2 == 1), rowData, isComplete))
	{
		QuestAlarmList_RichList.ModifyRecord(Index, rowData);
	}
	return;
}

function ReloadOnTeleportHide()
{
	local int Index, isComplete;
	local RichListCtrlRowData rowData;

	if((teleportDialog.nDialogID == -1))
	{
		return;
	}
	Index = GetQuestIndex(teleportDialog.nDialogID);
	QuestAlarmList_RichList.GetRec(Index, rowData);
	teleportDialog.nDialogID = -1;
	if(MakeRowData(int(rowData.nReserved1), int(rowData.nReserved2), (rowData.cellDataList[0].nReserved2 == 1), rowData, isComplete))
	{
		QuestAlarmList_RichList.ModifyRecord(Index, rowData);
	}
	return;
}

function DlegateOnTimeCheckDeactiveOld(int Cnt)
{
	local int i;
	local RichListCtrlRowData rowData;

	i = 0;
	while((i < QuestAlarmList_RichList.GetRecordCount()))
	{
		QuestAlarmList_RichList.GetRec(i, rowData);
		if((rowData.nReserved1 == INT64(lastActiveQID)))
		{
			i++;
			continue;
		}
		if((rowData.cellDataList[0].nReserved2 != 1))
		{
			i++;
			continue;
		}
		if(MakeRowData(int(rowData.nReserved1), int(rowData.nReserved2), false, rowData, rowData.cellDataList[0].nReserved1))
		{
			QuestAlarmList_RichList.ModifyRecord(i, rowData);
		}
		i++;
	}
	return;
}

function DlegateOnTimeCheckNew(int Cnt)
{
	local int Index, isComplete;
	local RichListCtrlRowData rowData;

	Index = GetQuestIndex(lastActiveQID);
	QuestAlarmList_RichList.GetRec(Index, rowData);
	if(MakeRowData(int(rowData.nReserved1), int(rowData.nReserved2), false, rowData, isComplete))
	{
		QuestAlarmList_RichList.ModifyRecord(Index, rowData);
	}
	lastActiveQID = -1;
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

function RT_S_EX_QUEST_NOTIFICATION_ALL()
{
	local UIPacket._S_EX_QUEST_NOTIFICATION_ALL packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_QUEST_NOTIFICATION_ALL(packet))
	{
		return;
	}
	Handle_S_EX_QUEST_NOTIFICATION_ALL(packet.questNotifs);
	return;
}

function RQ_C_EX_QUEST_NOTIFICATION_ALL()
{
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(831, _emptyByteArray);
	return;
}

function RQ_C_EX_Teleport_UI()
{
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(808, _emptyByteArray);
	return;
}

function RQ_C_EX_QUEST_TELEPORT()
{
	local array<byte> stream;
	local UIPacket._C_EX_QUEST_TELEPORT packet;

	packet.nID = teleportDialog.nDialogID;
	Debug(("RQ_C_EX_QUEST_" @ string(packet.nID)));
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_QUEST_TELEPORT(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(827, stream);
	return;
}

function string API_GetCurrentZoneName()
{
	return GetCurrentZoneName();
}

function bool API_GetNQuestData(int a_QuestID, out NQuestUIData o_data)
{
	return GetNQuestData(a_QuestID, o_data);
}

function bool API_GetNQuestDialogData(int a_QuestID, out NQuestDialogUIData o_data)
{
	return GetNQuestDialogData(a_QuestID, o_data);
}

function GetStrings(string keyString, string wordString, out array<string> strings)
{
	local int startIndex, endIndex, keylen;

	startIndex = InStr(wordString, (keyString $ "S"));
	if((startIndex == -1))
	{
		return;
	}
	endIndex = InStr(wordString, (keyString $ "E"));
	keylen = (Len(keyString) + 1);
	strings[strings.Length] = Mid(wordString, (startIndex + keylen), (endIndex - (startIndex + keylen)));
	GetStrings(keyString, Right(wordString, (Len(wordString) - (endIndex + keylen))), strings);
	return;
}

function bool IsMainQuestFirst()
{
	if((QuestAlarmList_RichList.GetRecordCount() == 0))
	{
		return false;
	}
	return IsMainQuest(GetQuestIDAtIndex(0));
}

function bool IsMainQuest(int qid)
{
	return (qid < 20001);
}

function int GetCompleteLastRecord()
{
	local int i;
	local RichListCtrlRowData rowData;

	if(IsMainQuestFirst())
	{
		i = 1;
	}
	else
	{
		i = 0;
	}
	i = i;
	while((i < QuestAlarmList_RichList.GetRecordCount()))
	{
		QuestAlarmList_RichList.GetRec(i, rowData);
		if((rowData.cellDataList[0].nReserved1 == 1))
		{
			i++;
			continue;
		}
		return i;
		i++;
	}
	return i;
}

function int GetActieLastOrNewFirstRecordIndex()
{
	local int i;
	local RichListCtrlRowData rowData;

	i = GetCompleteLastRecord();
	while((i < QuestAlarmList_RichList.GetRecordCount()))
	{
		QuestAlarmList_RichList.GetRec(i, rowData);
		if((rowData.cellDataList[0].nReserved2 == 1))
		{
			i++;
			continue;
		}
		return i;
		i++;
	}
	return i;
}

function int GetQuestIDAtIndex(int Index)
{
	local RichListCtrlRowData rowData;

	if((QuestAlarmList_RichList.GetRecordCount() <= Index))
	{
		return -1;
	}
	QuestAlarmList_RichList.GetRec(Index, rowData);
	return int(rowData.nReserved1);
}

function int GetQuestIndex(int qid)
{
	local int i;
	local RichListCtrlRowData rowData;

	i = 0;
	while((i < QuestAlarmList_RichList.GetRecordCount()))
	{
		QuestAlarmList_RichList.GetRec(i, rowData);
		if((rowData.nReserved1 == INT64(qid)))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function int GetCurrentInstanceZoneID(int qid)
{
	local NQuestUIData questUIData;

	API_GetNQuestData(qid, questUIData);
	return questUIData.InstantZoneID;
}

function bool IsVisible()
{
	local int bValue;

	if(!GetINIBool(m_hOwnerWnd.m_WindowNameWithFullPath, "v", bValue, "windowsInfo.ini"))
	{
		bValue = 1;
	}
	return (bValue == 1);
}

function bool IsShowCondition()
{
	if((GetGameStateName() == "COLLECTIONSTATE"))
	{
		return false;
	}
	if((QuestAlarmList_RichList.GetRecordCount() == 0))
	{
		return false;
	}
	return true;
}
