class DethroneTab04_Mission extends UICommonAPI
	dependson(UIPacket);

var string m_Windowname;
var WindowHandle Me;
var TextureHandle ServerRichListFrame;
var RichListCtrlHandle Tab_RichList;
var TextureHandle ListBg_tex;
var ButtonHandle ReFresh_btn;
var WindowHandle DisableWndList;
var TextBoxHandle List_Empty;

function OnRegisterEvent()
{
	RegisterEvent((100000 + 954));
	RegisterEvent((100000 + 955));
	return;
}

function OnLoad()
{
	Initialize();
	Load();
	return;
}

function Initialize()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	ServerRichListFrame = GetTextureHandle((m_Windowname $ ".ServerRichListFrame"));
	Tab_RichList = GetRichListCtrlHandle((m_Windowname $ ".Tab_RichList"));
	ListBg_tex = GetTextureHandle((m_Windowname $ ".ListBg_tex"));
	ReFresh_btn = GetButtonHandle((m_Windowname $ ".Refresh_btn"));
	DisableWndList = GetWindowHandle((m_Windowname $ ".DisableWndList"));
	List_Empty = GetTextBoxHandle((m_Windowname $ ".DisableWndList.List_Empty"));
	Tab_RichList.SetSelectedSelTooltip(false);
	Tab_RichList.SetAppearTooltipAtMouseX(true);
	return;
}

event OnShow()
{
	Debug(("Onshow " @ m_Windowname));
	if(GetWindowHandle("DethroneWnd").IsShowWindow())
	{
		API_C_EX_DETHRONE_DAILY_MISSION_INFO();
	}
	return;
}

function Load()
{
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "Refresh_btn":
			OnReFresh_btnClick();
			break;
		case "rewardBtn":
			onRewardBtnClick();
			break;
		default:
			break;
	}
	return;
}

function onRewardBtnClick()
{
	local RichListCtrlRowData rowData;

	Debug(("rewardBtn --> " @ string(Tab_RichList.GetSelectedIndex())));
	Tab_RichList.GetRec(Tab_RichList.GetSelectedIndex(), rowData);
	Debug((("RowData.cellDataList[2].szData" @ rowData.cellDataList[2].szData) @ string(rowData.nReserved1)));
	if((rowData.cellDataList[2].szData == "True"))
	{
		API_C_EX_DETHRONE_DAILY_MISSION_GET_REWARD(int(rowData.nReserved1));
		OnReFresh_btnClick();
	}
	return;
}

function OnReFresh_btnClick()
{
	API_C_EX_DETHRONE_DAILY_MISSION_INFO();
	DethroneWnd(GetScript("DethroneWnd")).setDisableWnd();
	return;
}

function AddDethronePointStateListItem(int nMissionID, string MissionName, int Progress, int progressTotal, bool bReward)
{
	local RichListCtrlRowData rowData;
	local float statusPercent;

	rowData.cellDataList.Length = 3;
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, MissionName, GTColor().White, false, 0, 0);
	statusPercent = ((float(Progress) / float(progressTotal)) * 100.0000000);
	if((statusPercent >= 100.0000000))
	{
		AddRichListCtrlStatusInfo(rowData.cellDataList[1].drawitems, 200, 15, 15, 6, true, statusPercent, 0.0000000, ((string(Progress) $ " / ") $ string(progressTotal)), 3);
	}
	else
	{
		AddRichListCtrlStatusInfo(rowData.cellDataList[1].drawitems, 200, 15, 15, 6, true, statusPercent, 0.0000000, ((string(Progress) $ " / ") $ string(progressTotal)), 2);
	}
	if(bReward)
	{
		AddRichListCtrlButton(rowData.cellDataList[2].drawitems, "rewardBtn", 0, 0, "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_List_AdditionalReward", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_List_AdditionalReward", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_List_AdditionalReward", 34, 38, 34, 38);
	}
	else
	{
		AddRichListCtrlButton(rowData.cellDataList[2].drawitems, "rewardBtn", 0, 0, "L2UI_EPIC.DethroneWnd.List_Icon_RewardDisable", "L2UI_EPIC.DethroneWnd.List_Icon_RewardDisable", "L2UI_EPIC.DethroneWnd.List_Icon_RewardDisable", 34, 38, 34, 38);
	}
	rowData.cellDataList[2].drawitems[(rowData.cellDataList[2].drawitems.Length - 1)].TooltipDesc = GetSystemString(7529);
	rowData.cellDataList[0].szData = MissionName;
	rowData.cellDataList[1].szData = string(Progress);
	rowData.cellDataList[2].szData = string(bReward);
	rowData.nReserved1 = INT64(nMissionID);
	Tab_RichList.InsertRecord(rowData);
	return;
}

function ModifyDethronePointStateListItem(int indexRecord, bool bReward)
{
	local RichListCtrlRowData rowData;

	Tab_RichList.GetRec(indexRecord, rowData);
	rowData.cellDataList[2].drawitems.Length = 0;
	AddRichListCtrlButton(rowData.cellDataList[2].drawitems, "rewardBtn", 0, 0, "L2UI_EPIC.DethroneWnd.List_Icon_RewardDisable", "L2UI_EPIC.DethroneWnd.List_Icon_RewardDisable", "L2UI_EPIC.DethroneWnd.List_Icon_RewardDisable", 34, 38, 34, 38);
	rowData.cellDataList[2].szData = string(bReward);
	Tab_RichList.ModifyRecord(indexRecord, rowData);
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_PacketID(954):
			ParsePacket_S_EX_DETHRONE_DAILY_MISSION_INFO();
			break;
		case EV_PacketID(955):
			ParsePacket_S_EX_DETHRONE_DAILY_MISSION_GET_REWARD();
			break;
		default:
			break;
	}
	return;
}

function ParsePacket_S_EX_DETHRONE_DAILY_MISSION_GET_REWARD()
{
	local UIPacket._S_EX_DETHRONE_DAILY_MISSION_GET_REWARD packet;
	local int Index;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_DETHRONE_DAILY_MISSION_GET_REWARD(packet))
	{
		return;
	}
	Debug(((((" -->  Decode_S_EX_DETHRONE_DAILY_MISSION_GET_REWARD :  " @ string(packet.bSuccess)) @ string(packet.nID)) @ string(packet.nPersonalDethronePoint)) @ string(packet.nServerDethronePoint)));
	if((int(packet.bSuccess) > 0))
	{
		AddSystemMessageString(MakeFullSystemMsg(GetSystemMessage(13428), string(packet.nPersonalDethronePoint), string(packet.nServerDethronePoint)));
		getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(13428), string(packet.nPersonalDethronePoint), string(packet.nServerDethronePoint)));
	}
	Index = getListIndexByMissionID(packet.nID);
	if((Index > -1))
	{
		ModifyDethronePointStateListItem(Index, false);
	}
	deleteNoticeCheck();
	return;
}

function deleteNoticeCheck()
{
	local int i;
	local RichListCtrlRowData rowData;

	i = 0;
	while((i < Tab_RichList.GetRecordCount()))
	{
		Tab_RichList.GetRec(i, rowData);
		if((rowData.cellDataList[2].szData == "True"))
		{
			return;
		}
		i++;
	}
	NoticeWnd(GetScript("NoticeWnd")).removeNoticeDethroneMissionNotice();
	return;
}

function int getListIndexByMissionID(int nMissionID)
{
	local int i;
	local RichListCtrlRowData rowData;

	i = 0;
	while((i < Tab_RichList.GetRecordCount()))
	{
		Tab_RichList.GetRec(i, rowData);
		if((INT64(nMissionID) == rowData.nReserved1))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function ParsePacket_S_EX_DETHRONE_DAILY_MISSION_INFO()
{
	local int i;
	local UIPacket._S_EX_DETHRONE_DAILY_MISSION_INFO packet;
	local DethroneDailyMissionData missionData;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_DETHRONE_DAILY_MISSION_INFO(packet))
	{
		return;
	}
	Debug((" -->  Decode_S_EX_DETHRONE_DAILY_MISSION_INFO :  len->" @ string(packet.missionInfoList.Length)));
	Tab_RichList.DeleteAllItem();
	i = 0;
	while((i < packet.missionInfoList.Length))
	{
		Debug(("" @ string(packet.missionInfoList[i].nID)));
		GetDethroneDailyMissionData(packet.missionInfoList[i].nID, missionData);
		AddDethronePointStateListItem(packet.missionInfoList[i].nID, missionData.Name, packet.missionInfoList[i].nCount, missionData.GoalCount, numToBool(int(packet.missionInfoList[i].bHasReward)));
		i++;
	}
	Tab_RichList.SetFocus();
	deleteNoticeCheck();
	return;
}

function API_C_EX_DETHRONE_DAILY_MISSION_INFO()
{
	local array<byte> stream;

	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(719, stream);
	Debug("----> Api Call : C_EX_DETHRONE_DAILY_MISSION_INFO ");
	return;
}

function API_C_EX_DETHRONE_DAILY_MISSION_GET_REWARD(int nMissionID)
{
	local array<byte> stream;
	local UIPacket._C_EX_DETHRONE_DAILY_MISSION_GET_REWARD packet;

	packet.nID = nMissionID;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_DETHRONE_DAILY_MISSION_GET_REWARD(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(720, stream);
	Debug(("----> Api Call : C_EX_DETHRONE_DAILY_MISSION_GET_REWARD " @ string(nMissionID)));
	return;
}
