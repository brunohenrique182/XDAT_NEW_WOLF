class WorldSiegeMercenaryWnd extends UICommonAPI;

var RichListCtrlHandle SiegeMercenarySword_List;
var RichListCtrlHandle SiegeMercenaryShield_List;
var TextBoxHandle SiegeMercenaryRecruitNum_Txt;
var int m_PlayerClanID;
var int currentPledgeID;

static function WorldSiegeMercenaryWnd Inst()
{
	return WorldSiegeMercenaryWnd(GetScript("WorldSiegeMercenaryWnd"));
}

function Initialize()
{
	SiegeMercenarySword_List = GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeMercenarySword_List"));
	SiegeMercenaryRecruitNum_Txt = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeMercenaryRecruitNum_Txt"));
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(11540);
	RegisterEvent(11541);
	RegisterEvent(11542);
	return;
}

event OnLoad()
{
	Initialize();
	SetClosingOnESC();
	return;
}

event OnEvent(int Event_ID, string param)
{
	if(!m_hOwnerWnd.IsShowWindow())
	{
		return;
	}
	switch(Event_ID)
	{
		case 11540:
			Handle_EV_WorldCastleWarSiegeAttackerListStart();
			break;
		case 11541:
			Handle_EV_WorldCastleWarSiegeAttackerList(param);
			break;
		case 11542:
			Handle_EV_WorldCastleWarSiegeAttackerListEnd(param);
			break;
		default:
			break;
	}
	return;
}

event OnShow()
{
	m_hOwnerWnd.SetFocus();
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("WorldSiegeWnd");
	m_hOwnerWnd.SetAnchor("WorldSiegeWnd", "CenterCenter", "CenterCenter", 0, 0);
	m_hOwnerWnd.ClearAnchor();
	Class'Interface.WorldSiegeInfoMCWWnd'.static.Inst().API_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_ATTACKER_LIST();
	m_hOwnerWnd.SetFocus();
	return;
}

event OnHide()
{
	local WindowHandle worldSiegeWndHandle;

	worldSiegeWndHandle = Class'Interface.WorldSiegeWnd'.static.Inst().m_hOwnerWnd;
	worldSiegeWndHandle.SetAnchor(m_hOwnerWnd.m_WindowNameWithFullPath, "CenterCenter", "CenterCenter", 0, 0);
	worldSiegeWndHandle.ClearAnchor();
	worldSiegeWndHandle.ShowWindow();
	worldSiegeWndHandle.BringToFront();
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("WorldSiegeMercenaryDrawerWnd");
	return;
}

event OnClickListCtrlRecord(string ListCtrlID)
{
	OnDBClickListCtrlRecord(ListCtrlID);
	return;
}

event OnDBClickListCtrlRecord(string ListCtrlID)
{
	local int idx;
	local RichListCtrlRowData rowData;
	local string ClanName, PledgeMasterName;

	idx = SiegeMercenarySword_List.GetSelectedIndex();
	SiegeMercenarySword_List.GetRec(idx, rowData);
	ParseString(rowData.szReserved, "clanName", ClanName);
	ParseString(rowData.szReserved, "PledgeMasterName", PledgeMasterName);
	Class'Interface.WorldSiegeMercenaryDrawerWnd'.static.Inst().SetSiegeMercenary(int(rowData.nReserved1), ClanName, ConvertWorldIDToStr(PledgeMasterName));
	return;
}

function Handle_EV_WorldCastleWarSiegeAttackerListStart()
{
	SiegeMercenarySword_List.DeleteAllItem();
	return;
}

function ModifyJoinType(int joinType, int clanID)
{
	local int Index, MercenaryMemberCount;
	local RichListCtrlRowData rowData;

	Index = FindRowIndexByClanID(clanID);
	if((Index == -1))
	{
		Class'Interface.WorldSiegeInfoMCWWnd'.static.Inst().API_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_ATTACKER_LIST();
		return;
	}
	SiegeMercenarySword_List.GetRec(Index, rowData);
	MercenaryMemberCount = int(rowData.cellDataList[1].HiddenStringForSorting);
	if((joinType == 0))
	{
		MercenaryMemberCount--;
	}
	else
	{
		MercenaryMemberCount++;
	}
	rowData.cellDataList[1].drawitems[1].strInfo.strData = string(MercenaryMemberCount);
	rowData.cellDataList[1].HiddenStringForSorting = num2Str(MercenaryMemberCount);
	SiegeMercenarySword_List.ModifyRecord(Index, rowData);
	return;
}

function ModifyMercenaryMemberCount(int MercenaryMemberCount, int clanID)
{
	local int Index;
	local RichListCtrlRowData rowData;

	Index = FindRowIndexByClanID(clanID);
	if((Index == -1))
	{
		Class'Interface.WorldSiegeInfoMCWWnd'.static.Inst().API_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_ATTACKER_LIST();
		return;
	}
	SiegeMercenarySword_List.GetRec(Index, rowData);
	rowData.cellDataList[1].drawitems[1].strInfo.strData = string(MercenaryMemberCount);
	rowData.cellDataList[1].HiddenStringForSorting = num2Str(MercenaryMemberCount);
	SiegeMercenarySword_List.ModifyRecord(Index, rowData);
	return;
}

function SetMercenaryRecruited(int clanID, string ClanName, string PledgeMasterName, int MercenaryRecruit, int MercenaryMemberCount)
{
	local int Index;
	local RichListCtrlRowData rowData;

	rowData = MakeRowData(clanID, ConvertWorldIDToStr(ClanName), ConvertWorldIDToStr(PledgeMasterName), MercenaryRecruit, MercenaryMemberCount);
	Index = FindRowIndexByClanID(clanID);
	if((Index == -1))
	{
		SiegeMercenarySword_List.InsertRecord(rowData);
	}
	else
	{
		SiegeMercenarySword_List.ModifyRecord(Index, rowData);
	}
	return;
}

function Handle_EV_WorldCastleWarSiegeAttackerList(string param)
{
	local int clanID;
	local string ClanName, PledgeMasterName;
	local int MercenaryRecruit, MercenaryMemberCount;

	ParseInt(param, "IsMercenaryRecruit", MercenaryRecruit);
	if((MercenaryRecruit < 1))
	{
		return;
	}
	ParseInt(param, "ClanID", clanID);
	ParseString(param, "ClanName", ClanName);
	ParseString(param, "ClanMasterName", PledgeMasterName);
	ParseInt(param, "CurrentMercenaryMemberCount", MercenaryMemberCount);
	SetMercenaryRecruited(clanID, ClanName, PledgeMasterName, MercenaryRecruit, MercenaryMemberCount);
	return;
}

function Handle_EV_WorldCastleWarSiegeAttackerListEnd(string param)
{
	SiegeMercenaryRecruitNum_Txt.SetText(string(SiegeMercenarySword_List.GetRecordCount()));
	return;
}

function RichListCtrlRowData MakeRowData(int clanID, string ClanName, string PledgeMasterName, int MercenaryRecruit, int MercenaryMemberCount)
{
	local RichListCtrlRowData rowData;
	local string szReserved;
	local Color clanNameColor;
	local int gabX, gabY, clanTexturesNum;
	local Texture PledgeAllianceCrestTexture, PledgeCrestTexture;

	rowData.cellDataList.Length = 3;
	rowData.nReserved1 = INT64(clanID);
	rowData.nReserved2 = INT64(MercenaryRecruit);
	szReserved = "";
	ParamAdd(szReserved, "clanName", ClanName);
	ParamAdd(szReserved, "PledgeMasterName", PledgeMasterName);
	rowData.szReserved = szReserved;
	if(((m_PlayerClanID > 0) && (clanID == m_PlayerClanID)))
	{
		addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_CT1.SiegeReportWnd.SiegeReport_Flag", 16, 16, 0, 0);
		clanNameColor = GetColor(255, 204, 0, 255);
		gabX = 0;
		gabY = 2;
	}
	else
	{
		clanNameColor = GetColor(211, 211, 211, 255);
		gabX = 16;
	}
	clanTexturesNum = rowData.cellDataList[0].drawitems.Length;
	if(Class'NWindow.UIDATA_CLAN'.static.GetAllianceCrestTexture(clanID, PledgeAllianceCrestTexture))
	{
		rowData.cellDataList[0].drawitems.Length = (clanTexturesNum + 1);
		rowData.cellDataList[0].drawitems[clanTexturesNum].eType = LCDIT_TEXTURE;
		rowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.sTex = string(PledgeAllianceCrestTexture);
		rowData.cellDataList[0].drawitems[clanTexturesNum].nPosX = gabX;
		rowData.cellDataList[0].drawitems[clanTexturesNum].nPosY = gabY;
		rowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.Width = 8;
		rowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.Height = 12;
		rowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.V = 4;
		rowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.UL = 8;
		rowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.VL = 12;
		gabX = 0;
		gabY = 0;
		clanTexturesNum++;
	}
	if(Class'NWindow.UIDATA_CLAN'.static.GetCrestTexture(clanID, PledgeCrestTexture))
	{
		rowData.cellDataList[0].drawitems.Length = (clanTexturesNum + 1);
		rowData.cellDataList[0].drawitems[clanTexturesNum].eType = LCDIT_TEXTURE;
		rowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.sTex = string(PledgeCrestTexture);
		rowData.cellDataList[0].drawitems[clanTexturesNum].nPosX = gabX;
		rowData.cellDataList[0].drawitems[clanTexturesNum].nPosY = gabY;
		rowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.Width = 24;
		rowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.Height = 12;
		rowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.V = 4;
		rowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.UL = 24;
		rowData.cellDataList[0].drawitems[clanTexturesNum].texInfo.VL = 12;
		gabX = 0;
	}
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, ClanName, clanNameColor, false, gabX, 0);
	rowData.cellDataList[0].HiddenStringForSorting = ClanName;
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, "/100", GetColor(211, 211, 211, 255), false, 20, 0);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, string(MercenaryMemberCount), GetColor(187, 170, 136, 255), false, 0, 0);
	rowData.cellDataList[1].HiddenStringForSorting = num2Str(MercenaryMemberCount);
	return rowData;
}

function int FindRowIndexByClanID(int clanID)
{
	local int i;
	local RichListCtrlRowData rowData;

	i = 0;
	while((i < SiegeMercenarySword_List.GetRecordCount()))
	{
		SiegeMercenarySword_List.GetRec(i, rowData);
		if((int(rowData.nReserved1) == clanID))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function int GetCastleID()
{
	return Class'Interface.WorldSiegeWnd'.static.Inst().GetCastleIDSelected();
}

function string num2Str(int Num)
{
	if((Num < 10))
	{
		return ("00" $ string(Num));
	}
	if((Num < 100))
	{
		return ("0" $ string(Num));
	}
	return string(Num);
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	m_hOwnerWnd.HideWindow();
	return;
}
