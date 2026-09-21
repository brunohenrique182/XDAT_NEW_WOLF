class SiegeMercenaryWnd extends UICommonAPI;

const TIMER_ID = 1;
const TIME_REFRESH = 3000;

enum TYPE_TABORDER
{
	Attacker,                       // 0
	DEFENDER                        // 1
};

var string m_Windowname;
var WindowHandle Me;
var RichListCtrlHandle SiegeMercenarySword_List;
var RichListCtrlHandle SiegeMercenaryShield_List;
var TextBoxHandle SiegeMercenaryRecruitNum_Txt;
var TabHandle SiegeMercenaryTabCtrl;
var int m_PlayerClanID;
var int currentPledgeID;
var int castleID;

function Initialize()
{
	Me = GetWindowHandle(m_Windowname);
	SiegeMercenarySword_List = GetRichListCtrlHandle((m_Windowname $ ".SiegeMercenarySword_List"));
	SiegeMercenaryShield_List = GetRichListCtrlHandle((m_Windowname $ ".SiegeMercenaryShield_List"));
	SiegeMercenaryRecruitNum_Txt = GetTextBoxHandle((m_Windowname $ ".SiegeMercenaryRecruitNum_Txt"));
	SiegeMercenaryTabCtrl = GetTabHandle((m_Windowname $ ".SiegeMercenaryTabCtrl"));
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(11320);
	RegisterEvent(11321);
	RegisterEvent(11322);
	RegisterEvent(11330);
	RegisterEvent(11331);
	RegisterEvent(11332);
	RegisterEvent(11350);
	return;
}

function OnLoad()
{
	Initialize();
	SetClosingOnESC();
	return;
}

function OnEvent(int Event_ID, string param)
{
	if(!Me.IsShowWindow())
	{
		return;
	}
	Debug((("OnEvent SiegeMercenaryWnd" @ string(Event_ID)) @ param));
	switch(Event_ID)
	{
		case 11320:
			HandleSiegeInfoClanListStart(param, 0);
			break;
		case 11321:
			HandleSiegeInfoClanList(param, 0);
			break;
		case 11322:
			HandleSiegeInfoClanListEnd(param, 0);
			break;
		case 11330:
			HandleSiegeInfoClanListStart(param, 1);
			break;
		case 11331:
			HandleSiegeInfoClanList(param, 1);
			break;
		case 11332:
			HandleSiegeInfoClanListEnd(param, 1);
			break;
		case 11350:
			HandlePledgeMercenaryMemberJoin(param);
			break;
		default:
			break;
	}
	return;
}

function OnShow()
{
	SiegeMercenaryTabCtrl.SetTopOrder(0, true);
	RequestMCWCastleSiegeAttackerListAll();
	Me.SetFocus();
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("SiegeWnd");
	Me.SetAnchor("SiegeWnd", "CenterCenter", "CenterCenter", 0, 0);
	Me.ClearAnchor();
	return;
}

function OnHide()
{
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("SiegeMercenaryDrawerWnd");
	return;
}

function OnClickButton(string strID)
{
	Debug(("OnDefenseCancelClick" @ strID));
	switch(strID)
	{
		case "SiegeMercenaryTabCtrl0":
			if(!SiegeMercenaryTabCtrl.IsEnableWindow())
			{
				return;
			}
			OnTabCtrl0Click();
			SiegeMercenaryTabCtrl.DisableWindow();
			Me.SetTimer(1, 3000);
			break;
		case "SiegeMercenaryTabCtrl1":
			if(!SiegeMercenaryTabCtrl.IsEnableWindow())
			{
				return;
			}
			OnTabCtrl1Click();
			SiegeMercenaryTabCtrl.DisableWindow();
			Me.SetTimer(1, 3000);
			break;
		default:
			break;
	}
	return;
}

function OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case 1:
			SiegeMercenaryTabCtrl.EnableWindow();
			break;
		default:
			break;
	}
	return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
	OnDBClickListCtrlRecord(ListCtrlID);
	return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
	local int idx;
	local RichListCtrlRowData rowData;
	local RichListCtrlHandle currentRichListCtrl;
	local string ClanName, PledgeMasterName, castleIDs;

	currentRichListCtrl = GetCurrentRichListCtrl();
	idx = currentRichListCtrl.GetSelectedIndex();
	currentRichListCtrl.GetRec(idx, rowData);
	ParseString(rowData.szReserved, "clanName", ClanName);
	ParseString(rowData.szReserved, "PledgeMasterName", PledgeMasterName);
	ParseString(rowData.szReserved, "castleIDs", castleIDs);
	SiegeMercenaryDrawerWnd(GetScript("SiegeMercenaryDrawerWnd")).SetSiegeMercenary(castleIDs, SiegeMercenaryTabCtrl.GetTopIndex(), int(rowData.nReserved1), ClanName, PledgeMasterName, int(rowData.cellDataList[1].szData));
	Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("SiegeMercenaryDrawerWnd");
	return;
}

function HandleSiegeInfoClanListStart(string param, int Type)
{
	ParseInt(param, "castleID", castleID);
	return;
}

function string MakeSiegeListString(int Index, int Type)
{
	local RichListCtrlRowData Record;
	local string castleIDs;

	if((Index == -1))
	{
		return string(castleID);
	}
	SiegeMercenarySword_List.GetRec(Index, Record);
	if((Type == 0))
	{
		SiegeMercenarySword_List.GetRec(Index, Record);
	}
	else if((Type == 1))
	{
		SiegeMercenaryShield_List.GetRec(Index, Record);
	}
	ParseString(Record.szReserved, "castleIDs", castleIDs);
	castleIDs = ((castleIDs $ "/") $ string(castleID));
	return castleIDs;
}

function HandleSiegeInfoClanList(string param, int Type)
{
	local int Index, clanID;
	local string ClanName, PledgeMasterName;
	local RichListCtrlRowData rowData;
	local int MercenaryRecruit, MercenaryMemberCount, MercenaryReward;

	ParseInt(param, "MercenaryRecruit", MercenaryRecruit);
	if((MercenaryRecruit < 1))
	{
		return;
	}
	ParseInt(param, "PledgeID", clanID);
	Index = FindRowIndexByClanID(clanID);
	ParseString(param, "PledgeName", ClanName);
	ParseString(param, "PledgeMasterName", PledgeMasterName);
	ParseInt(param, "MercenaryMemberCount", MercenaryMemberCount);
	ParseInt(param, "MercenaryReward", MercenaryReward);
	rowData = MakeRowData(MakeSiegeListString(Index, Type), clanID, ClanName, PledgeMasterName, MercenaryRecruit, MercenaryMemberCount, MercenaryReward);
	if((Index == -1))
	{
		if((Type == 0))
		{
			SiegeMercenarySword_List.InsertRecord(rowData);
		}
		else if((Type == 1))
		{
			SiegeMercenaryShield_List.InsertRecord(rowData);
		}
	}
	else if((Type == 0))
	{
		SiegeMercenarySword_List.ModifyRecord(Index, rowData);
	}
	else if((Type == 1))
	{
		SiegeMercenaryShield_List.ModifyRecord(Index, rowData);
	}
	return;
}

function HandleSiegeInfoClanListEnd(string param, int Type)
{
	if((Type == 0))
	{
		SiegeMercenaryRecruitNum_Txt.SetText(string(SiegeMercenarySword_List.GetRecordCount()));
	}
	else
	{
		SiegeMercenaryRecruitNum_Txt.SetText(string(SiegeMercenaryShield_List.GetRecordCount()));
	}
	return;
}

function HandlePledgeMercenaryMemberJoin(string param)
{
	local int Result;

	ParseInt(param, "Result", Result);
	if((Result > 0))
	{
		switch(SiegeMercenaryTabCtrl.GetTopIndex())
		{
			case 0:
				RequestMCWCastleSiegeAttackerListAll();
				break;
			case 1:
				RequestMCWCastleSiegeDefenderListAll();
				break;
			default:
				RequestMCWCastleSiegeAttackerListAll();
				break;
		}
	}
	return;
}

function RichListCtrlRowData MakeRowData(string castleIDs, int clanID, string ClanName, string PledgeMasterName, int MercenaryRecruit, int MercenaryMemberCount, int MercenaryReward)
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
	Debug(("  ----  castleIds " @ castleIDs));
	ParamAdd(szReserved, "clanName", ClanName);
	ParamAdd(szReserved, "PledgeMasterName", PledgeMasterName);
	ParamAdd(szReserved, "castleIDs", castleIDs);
	rowData.szReserved = szReserved;
	Debug((("MakeRowData" @ ClanName) @ PledgeMasterName));
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
	rowData.cellDataList[1].szData = string(MercenaryReward);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, (string(MercenaryReward) $ "%"), GetColor(211, 211, 211, 255), false, 20, 0);
	rowData.cellDataList[1].HiddenStringForSorting = num2Str((100 - MercenaryReward));
	Debug((("MakeRowData" @ ClanName) @ string(MercenaryMemberCount)));
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, "/100", GetColor(211, 211, 211, 255), false, 20, 0);
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, string(MercenaryMemberCount), GetColor(187, 170, 136, 255), false, 0, 0);
	rowData.cellDataList[2].HiddenStringForSorting = num2Str(MercenaryMemberCount);
	return rowData;
}

function int FindRowIndexByClanID(int clanID)
{
	local int i;
	local RichListCtrlHandle currentRichListCtrl;
	local RichListCtrlRowData rowData;

	currentRichListCtrl = GetCurrentRichListCtrl();
	i = 0;
	while((i < currentRichListCtrl.GetRecordCount()))
	{
		currentRichListCtrl.GetRec(i, rowData);
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
	local SiegeWnd siegeWndScript;

	siegeWndScript = SiegeWnd(GetScript("SiegeWnd"));
	return siegeWndScript.castleIDs[siegeWndScript.SelectedIndex];
}

function Color GetColor(int R, int G, int B, int A)
{
	local Color tColor;

	tColor.R = byte(R);
	tColor.G = byte(G);
	tColor.B = byte(B);
	tColor.A = byte(A);
	return tColor;
}

function OnTabCtrl0Click()
{
	RequestMCWCastleSiegeAttackerListAll();
	return;
}

function OnTabCtrl1Click()
{
	RequestMCWCastleSiegeDefenderListAll();
	return;
}

function RichListCtrlHandle GetCurrentRichListCtrl()
{
	switch(SiegeMercenaryTabCtrl.GetTopIndex())
	{
		case 0:
			return SiegeMercenarySword_List;
			break;
		case 1:
			return SiegeMercenaryShield_List;
			break;
		default:
			return SiegeMercenarySword_List;
			break;
	}
}

function API_RequestMCWCastleSiegeAttackerList(int castleID)
{
	Debug(("API_RequestMCWCastleSiegeAttackerList" @ string(castleID)));
	if((castleID > 0))
	{
		Class'NWindow.SiegeAPI'.static.RequestMCWCastleSiegeAttackerList(castleID);
	}
	return;
}

function API_RequestMCWCastleSiegeDefenderList(int castleID)
{
	Debug(("API_RequestMCWCastleSiegeDefenderList" @ string(castleID)));
	if((castleID > 0))
	{
		Class'NWindow.SiegeAPI'.static.RequestMCWCastleSiegeDefenderList(castleID);
	}
	return;
}

function GetPledgeID()
{
	local UserInfo infUser;

	currentPledgeID = -1;
	m_PlayerClanID = 0;
	if(GetPlayerInfo(infUser))
	{
		m_PlayerClanID = infUser.nClanID;
	}
	return;
}

function RequestMCWCastleSiegeAttackerListAll()
{
	local int i;
	local array<int> castleIDs;

	castleIDs = GetCastleIds();
	GetPledgeID();
	SiegeMercenarySword_List.DeleteAllItem();
	i = 0;
	while((i < castleIDs.Length))
	{
		API_RequestMCWCastleSiegeAttackerList(castleIDs[i]);
		i++;
	}
	return;
}

function RequestMCWCastleSiegeDefenderListAll()
{
	local int i;
	local array<int> castleIDs;

	castleIDs = GetCastleIds();
	GetPledgeID();
	SiegeMercenaryShield_List.DeleteAllItem();
	i = 0;
	while((i < castleIDs.Length))
	{
		API_RequestMCWCastleSiegeDefenderList(castleIDs[i]);
		i++;
	}
	return;
}

function array<int> GetCastleIds()
{
	return SiegeWnd(GetScript("SiegeWnd")).castleIDs;
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
	Me.HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="SiegeMercenaryWnd"
}
