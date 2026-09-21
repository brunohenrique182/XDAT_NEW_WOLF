class WorldSiegeRankingWnd extends UICommonAPI
	dependson(UIPacket);

const TIMER_RANKING_ID = 10;
const TIMER_RANKING_TIME = 30000;

var RichListCtrlHandle Ranking_RichList;
var TextBoxHandle WorldSiegeDate_Text;
var TextBoxHandle CastleName_Text;
var TextBoxHandle SiegeInfo_Text;
var TextBoxHandle Myclan_Text;
var TextBoxHandle MyclanRankingEquality_Text;
var TextBoxHandle MyWorldSiegeName_Text;
var TextBoxHandle MyWorldSiegeRankingText;
var TextBoxHandle MyclanRankingDisable_Text;
var TextBoxHandle MyWorldSiegeRankingDisable_Text;
var TextBoxHandle MyWorldSiegeRankingEquality_Text;
var TextBoxHandle MyclanRankingText;
var TextBoxHandle WorldSiegeDate02_Text;
var TabHandle Ranking_Tab;
var array<UIPacket._WorldCastleWar_RankingInfo> lstPledgeRankingList;
var array<UIPacket._WorldCastleWar_RankingInfo> lstPersonalRankingList;
var bool bRnkingCooltime;
var int myPledgeRank;
var int myRank;

static function WorldSiegeRankingWnd Inst()
{
	return WorldSiegeRankingWnd(GetScript("WorldSiegeRankingWnd"));
}

function Init()
{
	Ranking_RichList = GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Ranking_wnd.Ranking_RichList"));
	WorldSiegeDate_Text = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Ranking_wnd.WorldSiegeDate_Text"));
	CastleName_Text = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Ranking_wnd.CastleName_Text"));
	SiegeInfo_Text = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Ranking_wnd.WorldSiegeDate_Text"));
	Myclan_Text = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Ranking_wnd.Myclan_Text"));
	MyclanRankingEquality_Text = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Ranking_wnd.MyclanRankingEquality_Text"));
	MyWorldSiegeName_Text = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Ranking_wnd.MyWorldSiegeName_Text"));
	MyWorldSiegeRankingText = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Ranking_wnd.MyWorldSiegeRankingText"));
	MyWorldSiegeRankingEquality_Text = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Ranking_wnd.MyWorldSiegeRankingEquality_Text"));
	MyclanRankingText = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Ranking_wnd.MyclanRankingText"));
	WorldSiegeDate02_Text = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Ranking_wnd.WorldSiegeDate02_Text"));
	Ranking_Tab = GetTabHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Ranking_Tab"));
	SiegeInfo_Text.SetText(GetSystemString(13050));
	MyclanRankingDisable_Text = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Ranking_wnd.MyclanRankingDisable_Text"));
	MyWorldSiegeRankingDisable_Text = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Ranking_wnd.MyWorldSiegeRankingDisable_Text"));
	Ranking_RichList.SetSelectable(false);
	return;
}

event OnTimer(int Id)
{
	switch(Id)
	{
		case 10:
			m_hOwnerWnd.KillTimer(Id);
			bRnkingCooltime = false;
			break;
		default:
			break;
	}
	return;
}

event OnRegisterEvent()
{
	RegisterEvent((100000 + 1010));
	RegisterEvent((100000 + 1011));
	RegisterEvent((100000 + 966));
	RegisterEvent(40);
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	Init();
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case (100000 + 1010):
			Handle_S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_RANKING_INFO();
			break;
		case (100000 + 1011):
			Handle_S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_RANKING_INFO();
			break;
		case (100000 + 966):
			Handle_S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_HUD_INFO();
			break;
		case 40:
			Handle_Restart();
			break;
		default:
			break;
	}
	return;
}

event OnClickButton(string btnName)
{
	switch(btnName)
	{
		case "Ranking_Tab0":
			Ranking_RichList.SetColumnString(1, 580);
			MakeList();
			break;
		case "Ranking_Tab1":
			Ranking_RichList.SetColumnString(1, 393);
			MakeList();
			break;
		default:
			break;
	}
	return;
}

event OnShow()
{
	API_RequestRankingInfo();
	m_hOwnerWnd.SetFocus();
	return;
}

function Handle_S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_HUD_INFO()
{
	local UIPacket._S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_HUD_INFO packet;
	local L2UITime L2UITime;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_HUD_INFO(packet))
	{
		return;
	}
	if(!ChkCastleID(packet.nCastleID))
	{
		return;
	}
	GetTimeStruct(packet.nNextSiegeTime, L2UITime);
	WorldSiegeDate02_Text.SetText((((((((((((GetSystemString(13888) $ "\\n") $ string(L2UITime.nYear)) $ ".") $ string(L2UITime.nMonth)) $ ".") $ string(L2UITime.nDay)) @ "[") $ Class'InterfaceClassic.UIData'.static.Inst().Int2Str(L2UITime.nHour)) $ ":") $ Class'InterfaceClassic.UIData'.static.Inst().Int2Str(L2UITime.nMin)) $ "]"));
	return;
}

function Handle_S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_RANKING_INFO()
{
	local UIPacket._S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_RANKING_INFO packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_RANKING_INFO(packet))
	{
		return;
	}
	if(!ChkCastleID(packet.nCastleID))
	{
		return;
	}
	lstPledgeRankingList = packet.lstPledgeRankingList;
	lstPersonalRankingList = packet.lstPersonalRankingList;
	WorldSiegeDate_Text.SetText(GetSystemString(3701));
	CastleName_Text.SetText(GetCastleName(packet.nCastleID));
	Debug(((("Handle_S_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_RANKING_INFO stp :" @ GetCastleName(packet.nCastleID)) @ string(packet.lstPledgeRankingList.Length)) @ string(packet.lstPersonalRankingList.Length)));
	MakeList();
	setResult(true);
	return;
}

function Handle_S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_RANKING_INFO()
{
	local UIPacket._S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_RANKING_INFO packet;
	local UserInfo uInfo;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_RANKING_INFO(packet))
	{
		return;
	}
	if(!ChkCastleID(packet.nCastleID))
	{
		return;
	}
	lstPledgeRankingList = packet.lstPledgeRankingList;
	lstPersonalRankingList = packet.lstPersonalRankingList;
	CastleName_Text.SetText(GetCastleName(packet.nCastleID));
	Debug((((("Handle_S_EX_WORLDCASTLEWAR_CASTLE_SIEGE_RANKING_INFO stp :" @ GetCastleName(packet.nCastleID)) @ string(Class'InterfaceClassic.NoticeHUD'.static.Inst().worldsiegeState)) @ string(packet.lstPledgeRankingList.Length)) @ string(packet.lstPersonalRankingList.Length)));
	MakeList();
	if((Class'InterfaceClassic.NoticeHUD'.static.Inst().worldsiegeState == 1))
	{
		WorldSiegeDate_Text.SetText(GetSystemString(3700));
		if(GetPlayerInfo(uInfo))
		{
			Myclan_Text.SetText(Class'NWindow.UIDATA_CLAN'.static.GetName(uInfo.nClanID));
			MyWorldSiegeName_Text.SetText(uInfo.Name);
		}
		myPledgeRank = packet.nMyPledgeRank;
		myRank = packet.nMyRank;
		MyclanRankingText.SetText(string(myPledgeRank));
		MyclanRankingEquality_Text.SetText(MakeCostString(string(packet.nMyPledgeSiegePoint)));
		MyWorldSiegeRankingEquality_Text.SetText(string(myRank));
		MyWorldSiegeRankingText.SetText(MakeCostString(string(packet.nMySiegePoint)));
		MyclanRankingDisable_Text.HideWindow();
		MyWorldSiegeRankingDisable_Text.HideWindow();
		setResult(false);
	}
	else
	{
		WorldSiegeDate_Text.SetText(GetSystemString(3701));
		setResult(true);
	}
	return;
}

function Handle_Restart()
{
	Ranking_RichList.DeleteAllItem();
	SiegeInfo_Text.SetText(GetSystemString(13050));
	bRnkingCooltime = false;
	m_hOwnerWnd.KillTimer(10);
	return;
}

function setResult(bool bResult)
{
	if(bResult)
	{
		MyclanRankingDisable_Text.HideWindow();
		MyWorldSiegeRankingDisable_Text.HideWindow();
		Myclan_Text.SetText("-");
		MyWorldSiegeName_Text.SetText("-");
		MyclanRankingText.SetText("");
		MyclanRankingEquality_Text.SetText("");
		MyWorldSiegeRankingEquality_Text.SetText("");
		MyWorldSiegeRankingText.SetText("");
	}
	else
	{
		MyclanRankingDisable_Text.HideWindow();
		MyWorldSiegeRankingDisable_Text.HideWindow();
		WorldSiegeDate02_Text.SetText("");
	}
	return;
}

function DelegateGroupButtonOnClickButton(string parentWndName, string strName, int Index)
{
	MakeList();
	return;
}

function API_C_EX_WORLDCASTLEWAR_CASTLE_INFO()
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLDCASTLEWAR_CASTLE_INFO packet;

	packet.nCastleID = GetCastleID();
	if(Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_WORLDCASTLEWAR_CASTLE_INFO(stream, packet))
	{
		Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(732, stream);
		Debug(("API_C_EX_WORLDCASTLEWAR_CASTLE_INFO 요청 합 " @ string(packet.nCastleID)));  // EN?: Sum of API_C_EX_WORLDCASTLEWAR_castle_info requests
	}
	return;
}

function API_C_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_RANKING_INFO()
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_RANKING_INFO packet;

	packet.nCastleID = GetCastleID();
	if(Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_RANKING_INFO(stream, packet))
	{
		Debug(("Encode_C_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_RANKING_INFO : " @ string(packet.nCastleID)));
		Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(743, stream);
	}
	return;
}

function API_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_RANKING_INFO()
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_RANKING_INFO packet;

	Debug(("Encode_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_RANKING_INFO : " @ string(GetCastleID())));
	packet.nCastleID = GetCastleID();
	if(Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_RANKING_INFO(stream, packet))
	{
		Debug(("Encode_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_RANKING_INFO : " @ string(packet.nCastleID)));
		Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(744, stream);
	}
	return;
}

function array<UIPacket._WorldCastleWar_RankingInfo> MakeTestList()
{
	local int i;
	local array<UIPacket._WorldCastleWar_RankingInfo> currentRankingList;

	currentRankingList.Length = 100;
	i = 0;
	while((i < 100))
	{
		currentRankingList[i].nRank = (i + 1);
		if((Ranking_Tab.GetTopIndex() == 0))
		{
			currentRankingList[i].sName = ("혈맹 name" @ string(i));  // EN?: Bloodline name
		}
		else
		{
			currentRankingList[i].sName = ("name" @ string(i));
		}
		currentRankingList[i].nSiegePoint = INT64((i * 100));
		i++;
	}
	myPledgeRank = 1;
	myRank = 100;
	return currentRankingList;
}

function MakeList()
{
	local int i, currentRank;
	local RichListCtrlRowData rowData;
	local array<UIPacket._WorldCastleWar_RankingInfo> currentRankingList;

	switch(Ranking_Tab.GetTopIndex())
	{
		case 0:
			currentRankingList = lstPledgeRankingList;
			currentRank = myPledgeRank;
			break;
		case 1:
			currentRankingList = lstPersonalRankingList;
			currentRank = myRank;
			break;
		default:
			break;
	}
	Ranking_RichList.DeleteAllItem();
	i = 0;
	while((i < currentRankingList.Length))
	{
		if(MakeRowData(currentRankingList[i], currentRank, rowData))
		{
			Ranking_RichList.InsertRecord(rowData);
		}
		i++;
	}
	return;
}

function bool MakeRowData(UIPacket._WorldCastleWar_RankingInfo rankingInfo, int currentRank, out RichListCtrlRowData rowData)
{
	local Color C;

	rowData.cellDataList.Length = 3;
	rowData.cellDataList[0].drawitems.Length = 0;
	rowData.cellDataList[1].drawitems.Length = 0;
	rowData.cellDataList[2].drawitems.Length = 0;
	rowData.cellDataList[0].szData = string(rankingInfo.nRank);
	rowData.cellDataList[1].szData = ConvertWorldIDToStr(ChinaHideName(rankingInfo.sName));
	rowData.cellDataList[2].szData = string(rankingInfo.nSiegePoint);
	C = getInstanceL2Util().BrightWhite;
	if((rankingInfo.nRank < 6))
	{
		addRichListCtrlTexture(rowData.cellDataList[0].drawitems, GetRankingImg(rankingInfo.nRank), 38, 33);
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, rowData.cellDataList[0].szData, C, false, 14);
	}
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, rowData.cellDataList[1].szData, C);
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, MakeCostString(rowData.cellDataList[2].szData), C);
	return true;
}

function string GetRankingImg(int Ranking)
{
	switch(Ranking)
	{
		case 1:
			return "L2UI_CT1.RankingWnd.RankingWnd_1st";
		case 2:
			return "L2UI_CT1.RankingWnd.RankingWnd_2nd";
		case 3:
			return "L2UI_CT1.RankingWnd.RankingWnd_3rd";
		case 4:
			return "L2UI_EPIC.SuppressWnd.RankingWnd_4th";
		case 5:
			return "L2UI_EPIC.SuppressWnd.RankingWnd_5th";
		default:
			return "L2UI_CT1.EmptyBtn";
	}
}

function API_RequestRankingInfo()
{
	if(bRnkingCooltime)
	{
		return;
	}
	bRnkingCooltime = true;
	m_hOwnerWnd.SetTimer(10, 30000);
	if(IsPlayerOnWorldRaidServer())
	{
		API_C_EX_WORLDCASTLEWAR_CASTLE_INFO();
		API_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_RANKING_INFO();
	}
	else
	{
		API_C_EX_WORLDCASTLEWAR_HOST_CASTLE_SIEGE_RANKING_INFO();
	}
	return;
}

function int GetCastleID()
{
	local int castleID;

	castleID = Class'InterfaceClassic.WorldSiegeWnd'.static.Inst().GetCastleIDSelected();
	if((castleID < 1))
	{
		castleID = 5;
	}
	return castleID;
}

function bool ChkCastleID(int castleID)
{
	return (castleID == GetCastleID());
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	m_hOwnerWnd.HideWindow();
	return;
}
