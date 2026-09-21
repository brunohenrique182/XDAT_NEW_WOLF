class DethroneTab02_ServerStatus extends UICommonAPI
	dependson(UIPacket);

var string m_Windowname;
var WindowHandle Me;
var WindowHandle DethronePointStatus_wnd;
var TextBoxHandle PointStatusTitle_text;
var RichListCtrlHandle Tab01_RichList;
var RichListCtrlHandle Tab02_RichList;
var ButtonHandle connectDethroneToggle_btn;
var TextureHandle DisableDialog_tex;
var WindowHandle DisableWndList;
var TextBoxHandle List_Empty;
var UserInfo myInfo;
var bool bAdenCastleOwner;
var bool bConnectingDethrone;
//var delegate<SortPointInfoListDelegate> __SortPointInfoListDelegate__Delegate;
//var delegate<SortSoulBeadInfoListDelegate> __SortSoulBeadInfoListDelegate__Delegate;

function OnRegisterEvent()
{
	RegisterEvent(9750);
	RegisterEvent((100000 + 952));
	RegisterEvent((100000 + 961));
	RegisterEvent((100000 + 962));
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
	DethronePointStatus_wnd = GetWindowHandle((m_Windowname $ ".DethronePointStatus_wnd"));
	PointStatusTitle_text = GetTextBoxHandle((m_Windowname $ ".DethronePointStatus_wnd.PointStatusTitle_text"));
	Tab01_RichList = GetRichListCtrlHandle((m_Windowname $ ".DethronePointStatus_wnd.Tab01_RichList"));
	Tab02_RichList = GetRichListCtrlHandle((m_Windowname $ ".DethroneAdenaStatus_wnd.Tab02_RichList"));
	connectDethroneToggle_btn = GetButtonHandle((m_Windowname $ ".DethroneAdenaStatus_wnd.connectDethroneToggle_btn"));
	DisableDialog_tex = GetTextureHandle((m_Windowname $ ".DisableDialog_tex"));
	DisableWndList = GetWindowHandle((m_Windowname $ ".DisableWndList"));
	List_Empty = GetTextBoxHandle((m_Windowname $ ".DisableWndList.List_Empty"));
	connectDethroneToggle_btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13915), 250));
	return;
}

function Load()
{
	return;
}

event OnShow()
{
	Debug(("- Onshow " @ m_Windowname));
	if(GetWindowHandle("DethroneWnd").IsShowWindow())
	{
		GetPlayerInfo(myInfo);
		API_C_EX_DETHRONE_SERVER_INFO();
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "connectDethroneToggle_btn":
			if(bAdenCastleOwner)
			{
				if(bConnectingDethrone)
				{
					DethroneWnd(GetScript("DethroneWnd")).AskDialogDethronedisConnect();
				}
				else
				{
					DethroneWnd(GetScript("DethroneWnd")).AskDialogDethroneConnect();
				}
			}
			else
			{
				getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13431));
			}
			break;
		case "Help1_btn":
			Class'Interface.HelpWnd'.static.ShowHelp(63, 2);
			break;
		case "Help2_btn":
			Class'Interface.HelpWnd'.static.ShowHelp(63, 3);
			break;
		default:
			break;
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 9750:
			bAdenCastleOwner = false;
			connectDethroneToggle_btn.SetButtonName(13749);
			break;
		case EV_PacketID(952):
			ParsePacket_S_EX_DETHRONE_SERVER_INFO();
			break;
		case EV_PacketID(961):
			ParsePacket_S_EX_DETHRONE_CONNECT_CASTLE();
			break;
		case EV_PacketID(962):
			ParsePacket_S_EX_DETHRONE_DISCONNECT_CASTLE();
			break;
		default:
			break;
	}
	return;
}

function ParsePacket_S_EX_DETHRONE_CONNECT_CASTLE()
{
	local UIPacket._S_EX_DETHRONE_CONNECT_CASTLE packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_DETHRONE_CONNECT_CASTLE(packet))
	{
		return;
	}
	Debug((" -->  Decode_S_EX_DETHRONE_CONNECT_CASTLE :  " @ string(packet.nResult)));
	API_C_EX_DETHRONE_SERVER_INFO();
	if((packet.nResult > 0))
	{
		AddSystemMessage(13429);
	}
	else if((packet.nResult == 0))
	{
		AddSystemMessage(4334);
	}
	else if((packet.nResult == -1))
	{
		AddSystemMessage(13431);
	}
	else if((packet.nResult == -2))
	{
		AddSystemMessage(13052);
	}
	return;
}

function ParsePacket_S_EX_DETHRONE_DISCONNECT_CASTLE()
{
	local UIPacket._S_EX_DETHRONE_DISCONNECT_CASTLE packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_DETHRONE_DISCONNECT_CASTLE(packet))
	{
		return;
	}
	Debug((" -->  Decode_S_EX_DETHRONE_DISCONNECT_CASTLE :  " @ string(packet.nResult)));
	API_C_EX_DETHRONE_SERVER_INFO();
	if((packet.nResult > 0))
	{
		AddSystemMessage(13430);
	}
	else if((packet.nResult == 0))
	{
		AddSystemMessage(4334);
	}
	else if((packet.nResult == -1))
	{
		AddSystemMessage(13431);
	}
	else if((packet.nResult == -2))
	{
		AddSystemMessage(13052);
	}
	return;
}

delegate int SortPointInfoListDelegate(UIPacket._PkDethronePointInfo a1, UIPacket._PkDethronePointInfo a2)
{
	if((a1.nRank > a2.nRank))
	{
		return -1;
	}
	return 0;
}

delegate int SortSoulBeadInfoListDelegate(UIPacket._PkDethroneSoulBeadInfo a1, UIPacket._PkDethroneSoulBeadInfo a2)
{
	local ServerInfoUIData serverInfo1, serverInfo2;

	if((a1.nRank > a2.nRank))
	{
		return -1;
	}
	if((a1.nRank == a2.nRank))
	{
		Class'NWindow.UIDataManager'.static.GetServerInfo(a1.nWorldID, serverInfo1);
		Class'NWindow.UIDataManager'.static.GetServerInfo(a2.nWorldID, serverInfo2);
		if((serverInfo1.ServerName > serverInfo2.ServerName))
		{
			return -1;
		}
	}
	else
	{
		return 0;
	}
}

function ParsePacket_S_EX_DETHRONE_SERVER_INFO()
{
	local int i, N;
	local UIPacket._S_EX_DETHRONE_SERVER_INFO packet;
	local bool bConnect;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_DETHRONE_SERVER_INFO(packet))
	{
		return;
	}
	Debug((((((" -->  Decode__S_EX_DETHRONE_SERVER_INFO :  " @ string(packet.pointInfoList.Length)) @ string(packet.soulBeadInfoList.Length)) @ string(packet.connectionList.Length)) @ string(packet.bAdenCastleOwner)) @ string(packet.nDethroneWorldID)));
	Tab01_RichList.DeleteAllItem();
	// packet.pointInfoList.Sort(SortPointInfoListDelegate);   // array.Sort() unsupported by this compiler
	// packet.soulBeadInfoList.Sort(SortSoulBeadInfoListDelegate);   // array.Sort() unsupported by this compiler
	i = 0;
	while((i < packet.pointInfoList.Length))
	{
		AddDethronePointStateListItem(packet.pointInfoList[i].nRank, packet.pointInfoList[i].nWorldID, packet.pointInfoList[i].nPoint);
		i++;
	}
	bConnectingDethrone = false;
	Tab02_RichList.DeleteAllItem();
	i = 0;
	while((i < packet.soulBeadInfoList.Length))
	{
		Debug(((("packet.connectionList[i]" @ string(i)) @ string(packet.connectionList[i])) @ string(packet.soulBeadInfoList[i].nWorldID)));
		bConnect = false;
		N = 0;
		while((N < packet.connectionList.Length))
		{
			if((packet.connectionList[N] == packet.soulBeadInfoList[i].nWorldID))
			{
				if(((int(packet.bAdenCastleOwner) > 0) && (packet.soulBeadInfoList[i].nWorldID == myInfo.nWorldID)))
				{
					bConnectingDethrone = true;
				}
				bConnect = true;
				break;
			}
			N++;
		}
		AddSoulMarbleStateListItem(packet.soulBeadInfoList[i].nRank, packet.soulBeadInfoList[i].nWorldID, bConnect, packet.soulBeadInfoList[i].nSoulBead, packet.nDethroneWorldID);
		i++;
	}
	bAdenCastleOwner = numToBool(int(packet.bAdenCastleOwner));
	if((bAdenCastleOwner && !Class'NWindow.UIDATA_PLAYER'.static.IsInDethrone()))
	{
		connectDethroneToggle_btn.EnableWindow();
	}
	else
	{
		connectDethroneToggle_btn.DisableWindow();
	}
	if(bConnectingDethrone)
	{
		connectDethroneToggle_btn.SetButtonName(13769);
	}
	else
	{
		connectDethroneToggle_btn.SetButtonName(13749);
	}
	return;
}

function AddDethronePointStateListItem(int nRanking, int ServerID, INT64 dethronePoint)
{
	local RichListCtrlRowData rowData;
	local Color applyColor;
	local bool bMe;
	local string rankStr;
	local ServerInfoUIData ServerInfo;

	rowData.cellDataList.Length = 3;
	bMe = isMyServer(ServerID);
	if(bMe)
	{
		applyColor = GTColor().Yellow;
	}
	else
	{
		applyColor = GTColor().White;
	}
	rankStr = string(nRanking);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, rankStr, applyColor, false, 0, 0);
	Class'NWindow.UIDataManager'.static.GetServerInfo(ServerID, ServerInfo);
	addRichListCtrlTexture(rowData.cellDataList[1].drawitems, GetServerMarkNameSmall(ServerID), 30, 30);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, ServerInfo.ServerName, applyColor, false, 0, 8);
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, MakeCostString(string(dethronePoint)), applyColor, false, 5, 0);
	rowData.cellDataList[0].szData = rankStr;
	rowData.cellDataList[1].szData = ServerInfo.ServerName;
	rowData.cellDataList[2].szData = string(dethronePoint);
	Tab01_RichList.InsertRecord(rowData);
	return;
}

function AddSoulMarbleStateListItem(int nRanking, int ServerID, bool bConnect, INT64 dethronePoint, int nDethroneWorldID)
{
	local RichListCtrlRowData rowData;
	local Color applyColor;
	local bool bMe;
	local string rankStr;
	local ServerInfoUIData ServerInfo;

	rowData.cellDataList.Length = 4;
	bMe = isMyServer(ServerID);
	if(bMe)
	{
		applyColor = GTColor().Yellow;
	}
	else
	{
		applyColor = GTColor().White;
	}
	rankStr = string(nRanking);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, rankStr, applyColor, false, 0, 0);
	Class'NWindow.UIDataManager'.static.GetServerInfo(ServerID, ServerInfo);
	addRichListCtrlTexture(rowData.cellDataList[1].drawitems, GetServerMarkNameSmall(ServerID), 30, 30);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, ServerInfo.ServerName, applyColor, false, 0, 8);
	if((ServerID == nDethroneWorldID))
	{
		AddRichListCtrlString(rowData.cellDataList[2].drawitems, "-", applyColor);
	}
	else if(bConnect)
	{
		addRichListCtrlTexture(rowData.cellDataList[2].drawitems, "L2UI_CT1.OlympiadWnd.ONICON", 40, 15);
	}
	else
	{
		addRichListCtrlTexture(rowData.cellDataList[2].drawitems, "L2UI_CT1.OlympiadWnd.OFFICON", 40, 15);
	}
	AddRichListCtrlString(rowData.cellDataList[3].drawitems, MakeCostStringINT64(dethronePoint), applyColor, false, 5, 0);
	rowData.cellDataList[0].szData = rankStr;
	rowData.cellDataList[1].szData = ServerInfo.ServerName;
	rowData.cellDataList[2].szData = string(bConnect);
	rowData.cellDataList[3].szData = string(dethronePoint);
	Tab02_RichList.InsertRecord(rowData);
	return;
}

function API_C_EX_DETHRONE_SERVER_INFO()
{
	local array<byte> stream;

	Class'Interface.UIPacket'.static.RequestUIPacket(717, stream);
	Debug("----> Api Call : C_EX_DETHRONE_SERVER_INFO ");
	return;
}

function API_C_EX_DETHRONE_CONNECT_CASTLE()
{
	local array<byte> stream;

	Class'Interface.UIPacket'.static.RequestUIPacket(727, stream);
	Debug("----> Api Call : C_EX_DETHRONE_CONNECT_CASTLE ");
	return;
}

function API_C_EX_DETHRONE_DISCONNECT_CASTLE()
{
	local array<byte> stream;

	Class'Interface.UIPacket'.static.RequestUIPacket(728, stream);
	Debug("----> Api Call : C_EX_DETHRONE_DISCONNECT_CASTLE ");
	return;
}
