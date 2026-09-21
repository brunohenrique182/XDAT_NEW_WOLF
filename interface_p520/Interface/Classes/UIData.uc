class UIData extends UICommonAPI
	dependson(UIPacket);

const NEW_PARTY_MAXCOUNT = 7;
const MAXLV2DISPLAY = 199;
const HUNTINGZONE_MAXCOUNT = 500;
const RAID_MAXCOUNT = 2000;
const RAID_MIN = 0;
const RAID_BLOODY_MAXCOUNT = 2500;
const RAID_BLOODY_MIN = 2000;
const ROLETYPEMAX = 9;
const ROLETYPEMAX_ADEN = 13;
const BOSSID_QUEEN = 1;
const TRANSFORMID_DRAGONSLAYER = 11;
const TRANSFORMID_DRAGON = 10;
const CASTLE_NUM_TOTAL = 2;
const PEACE_ZONE_TYPE = 11;

var int currentScreenWidth;
var int currentScreenHeight;
var string roleTypeStr;
var string ClassDescription;
var UserInfo prevUserInfo;
var UserInfo currUserInfo;
var int MAXLV;
var int nCurrentTranscendEnchant;
var int nCurrentAdenLabNum;
var INT64 adenaCount;
var int PcCafePoint;
var bool bIsPcCafe;
var int clanNameValue;
var int craftPoint;
var INT64 nVitalityPoint;
var INT64 nSP;
var int tmpDataInt;
var string tmpDataString;
var bool tmpDataBoolean;
var string preState;
var int teleportFreeLevel;
var int clientStartSec;
var int serverStartTime;
var int serverTimeZone;
var int serverDaylight;
var int clientTimeZone;
var int daylightSeconds;
var bool bTimer24Set;
var L2UITimerObject timer24Object;

static function UIData Inst()
{
	return UIData(GetScript("UIData"));
}

event OnLoad()
{
	UpdateCurrentResolution();
	MAXLV = GetMaxLevel();
	SetBuilderPC();
	timer24Object = Class'Interface.L2UITimer'.static.Inst()._MakeTimerObject(((((1000 * 60) * 60) * 12) + Rand((1000 * 60))), -1);
	timer24Object._DelegateOnTime = DelegateOnTime24;
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(2900);
	RegisterEvent(8000);
	RegisterEvent(1910);
	RegisterEvent(320);
	RegisterEvent(182);
	RegisterEvent(3411);
	RegisterEvent(10230);
	RegisterEvent((100000 + 836));
	RegisterEvent(40);
	RegisterEvent(10231);
	RegisterEvent(180);
	RegisterEvent(2070);
	RegisterEvent(9750);
	RegisterEvent(EV_PacketID(1159));
	return;
}

event OnEvent(int Event_ID, string param)
{
	local UserInfo UserInfo;

	switch(Event_ID)
	{
		case 2900:
			UpdateCurrentResolution();
			break;
		case 8000:
			MAXLV = GetMaxLevel();
			clanNameValue = 0;
			PcCafePoint = 0;
			break;
		case 1910:
			pcCafePointInfoHandler(param);
			break;
		case 320:
			UpdateClanInfoHandler(param);
			break;
		case 182:
			SwapPrevUserInfo();
			break;
		case 3411:
			preState = param;
			break;
		case 10230:
			Debug("============>========================================================================");
			Debug(("============> EV_CurrentserverTime" @ param));
			ParseInt(param, "ServerTime", serverStartTime);
			ParseInt(param, "ServerTimeZone", serverTimeZone);
			ParseInt(param, "ServerDaylight", serverDaylight);
			ParseInt(param, "ClientTimeZone", clientTimeZone);
			ParseInt(param, "DaylightSeconds", daylightSeconds);
			clientStartSec = int(GetAppSeconds());
			break;
		case EV_PacketID(836):
			ParsePacket_S_EX_CRAFT_INFO();
			break;
		case 10231:
			ParseInt(param, "TeleportFreeLevel", teleportFreeLevel);
			break;
		case 40:
			handleOnRestart();
			break;
		case 2070:
			SaveBuilderPCDatas();
			break;
		case 180:
			if(GetPlayerInfo(UserInfo))
			{
				nVitalityPoint = INT64(UserInfo.nVitality);
				nSP = UserInfo.nSP;
			}
			break;
		case 9750:
			HandleOnGameStart();
			break;
		case EV_PacketID(1159):
			RT_S_EX_ADENLAB_TOOLTIP_INFO();
			break;
		default:
			break;
	}
	return;
}

event OnCallUCFunction(string Id, string param)
{
	switch(Id)
	{
		case "setRoleType":
			tmpDataInt = int(GetClassRoleType(int(param)));
			break;
		case "setRoleTypeStr":
			SetRoleTypeStr(int(param));
			break;
		case "GetClassDescription":
			ClassDescription = GetClassDescription(int(param));
			break;
		case "setUCData":
			tmpDataString = param;
			break;
		case "getUCData":
			GetData(param);
			break;
		default:
			break;
	}
	return;
}

function handleOnRestart()
{
	bIsPcCafe = false;
	StopTimer24();
	return;
}

function HandleOnGameStart()
{
	PlayTimer24();
	return;
}

function DelegateOnTime24(int t)
{
	API_SendWindowsInfo();
	Debug((((" ------- 시간 저장." @ string(t)) @ string(timer24Object._curCount)) @ string(timer24Object._time)));  // EN?: Store Hours Setting
	return;
}

function ParsePacket_S_EX_CRAFT_INFO()
{
	local UIPacket._S_EX_CRAFT_INFO packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_CRAFT_INFO(packet))
	{
		return;
	}
	SetCurrentCraftPoint(packet.nPoint);
	RandomCraftChargingWnd(GetScript("RandomCraftChargingWnd")).ParsePacket_S_EX_CRAFT_INFO(packet);
	RandomCraftWnd(GetScript("RandomCraftWnd")).ParsePacket_S_EX_CRAFT_INFO(packet);
	BottomBar(GetScript("BottomBar")).Nt_S_EX_CRAFT_INFO(packet);
	return;
}

function RT_S_EX_ADENLAB_TOOLTIP_INFO()
{
	local UIPacket._S_EX_ADENLAB_TOOLTIP_INFO packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_ADENLAB_TOOLTIP_INFO(packet))
	{
		return;
	}
	if((packet.bossTooltips[0].nBossID == 1))
	{
		nCurrentTranscendEnchant = packet.bossTooltips[0].nTranscend;
		return;
	}
	return;
}

function UpdateCurrentResolution()
{
	GetCurrentResolution(currentScreenWidth, currentScreenHeight);
	return;
}

function SwapPrevUserInfo()
{
	prevUserInfo = currUserInfo;
	GetPlayerInfo(currUserInfo);
	return;
}

function UpdateClanInfoHandler(string param)
{
	ParseInt(param, "ClanNameValue", clanNameValue);
	return;
}

function pcCafePointInfoHandler(string param)
{
	local int nShow;

	ParseInt(param, "TotalPoint", PcCafePoint);
	ParseInt(param, "Show", nShow);
	bIsPcCafe = true;
	return;
}

function SaveBuilderPCDatas()
{
	if(IsBuilderPC())
	{
		SetINIInt("UIData", "serverStartTime", serverStartTime, "UIDEV.ini");
		SetINIInt("UIData", "serverTimeZone", serverTimeZone, "UIDEV.ini");
		SetINIInt("UIData", "clientTimeZone", clientTimeZone, "UIDEV.ini");
		SetINIInt("UIData", "daylightSeconds", daylightSeconds, "UIDEV.ini");
		SetINIInt("UIData", "clientStartSec", clientStartSec, "UIDEV.ini");
		GetINIInt("UIData", "serverStartTime", serverStartTime, "UIDEV.ini");
		ChatWnd(GetScript("ChatWnd"))._HandleSystemMessageBuilderOnGameStart();
	}
	return;
}

function SetBuilderPC()
{
	if(!IsBuilderPC())
	{
		return;
	}
	GetINIInt("UIData", "serverStartTime", serverStartTime, "UIDEV.ini");
	GetINIInt("UIData", "serverTimeZone", serverTimeZone, "UIDEV.ini");
	GetINIInt("UIData", "clientTimeZone", clientTimeZone, "UIDEV.ini");
	GetINIInt("UIData", "daylightSeconds", daylightSeconds, "UIDEV.ini");
	GetINIInt("UIData", "clientStartSec", clientStartSec, "UIDEV.ini");
	ResetUIData();
	return;
}

function INT64 GetMaxAdena()
{
	return INT64("999999999999");
}

function L2UITime GetCurrentRealLocalTime()
{
	local L2UITime currentRealLocalTimeStruct;

	GetTimeStruct(GetCurrentRealLocalTimeSec(), currentRealLocalTimeStruct);
	return currentRealLocalTimeStruct;
}

function int GetCurrentRealLocalTimeSec()
{
	return ((((serverStartTime + gameConnectTimeSec()) - clientTimeZone) + serverTimeZone) - daylightSeconds);
}

function int gameConnectTimeSec()
{
	return int((GetAppSeconds() - float(clientStartSec)));
}

function string GameConnectTimeString()
{
	return MakeTimeStr(gameConnectTimeSec());
}

function string GetCurrentRealLocalTimeString()
{
	local L2UITime timeStruct;

	GetTimeStruct(GetCurrentRealLocalTimeSec(), timeStruct);
	return getMakeTimeString(timeStruct);
}

function string getCurrentServerTimeString()
{
	local L2UITime timeStruct;
	local int serverTime, currentUnixTime;

	serverTime = int(((float(serverStartTime) + GetAppSeconds()) - float(clientStartSec)));
	currentUnixTime = (serverTime - serverTimeZone);
	GetTimeStructGMT(currentUnixTime, timeStruct);
	return getMakeTimeString(timeStruct);
}

function string getMakeTimeString(L2UITime timeStruct)
{
	local string Str;

	Str = ((((((((string(timeStruct.nYear) $ "/") $ Int2Str(timeStruct.nMonth)) $ "/") $ Int2Str(timeStruct.nDay)) $ " ") $ Int2Str(timeStruct.nHour)) $ ":") $ Int2Str(timeStruct.nMin));
	return Str;
}

function string _GetMakeTimeStringDHM(L2UITime timeStruct)
{
	local string Str;

	if((timeStruct.nDay > 0))
	{
		Str = (MakeFullSystemMsg(GetSystemMessage(7393), string(timeStruct.nDay)) $ " ");
	}
	if((timeStruct.nHour > 0))
	{
		Str = ((Str $ MakeFullSystemMsg(GetSystemMessage(2204), string(timeStruct.nHour))) $ " ");
	}
	if((((timeStruct.nDay == 0) && (timeStruct.nHour == 0)) && (timeStruct.nMin == 0)))
	{
		Str = (Str $ MakeFullSystemMsg(GetSystemMessage(4360), "1"));
	}
	else
	{
		Str = (Str $ MakeFullSystemMsg(GetSystemMessage(7395), string(timeStruct.nMin)));
	}
	return Str;
}

function bool GetIsPcCafe()
{
	return bIsPcCafe;
}

function bool GetIsLiveServer()
{
	return (GetServerType() == 1);
}

function bool GetIsClassicServer()
{
	return (GetServerType() == 2);
}

function bool getIsArenaServer()
{
	return (GetServerType() == 3);
}

function bool IsPawnChanged()
{
	if((prevUserInfo.nID != currUserInfo.nID))
	{
		return false;
	}
	return (prevUserInfo.m_bPawnChanged != currUserInfo.m_bPawnChanged);
}

function bool IsMount()
{
	if((prevUserInfo.nID != currUserInfo.nID))
	{
		return false;
	}
	if(currUserInfo.m_bPawnChanged)
	{
		return false;
	}
	return ((prevUserInfo.nTransformID == 0) && (currUserInfo.nTransformID > 0));
}

function bool IsDismoust()
{
	if((prevUserInfo.nID != currUserInfo.nID))
	{
		return false;
	}
	if(currUserInfo.m_bPawnChanged)
	{
		return false;
	}
	return ((prevUserInfo.nTransformID > 0) && (currUserInfo.nTransformID == 0));
}

function bool IsLevelUP()
{
	if((prevUserInfo.nID != currUserInfo.nID))
	{
		return false;
	}
	return (prevUserInfo.nLevel < currUserInfo.nLevel);
}

function bool IsLevelDown()
{
	if((prevUserInfo.nID != currUserInfo.nID))
	{
		return false;
	}
	return (prevUserInfo.nLevel > currUserInfo.nLevel);
}

function bool _IsParty(string Name)
{
	if(GetIsClassicServer())
	{
		return IsPartyClassic(Name);
	}
	return IsPartyLive(Name);
}

function bool IsPartyClassic(string Name)
{
	local int i;
	local PartyWndClassic partyWndClassicScript;

	partyWndClassicScript = PartyWndClassic(GetScript("partyWndClassic"));
	Debug(("클래식 일 때 랜스 몇????" @ string(10)));  // EN?: How many lance when it is classic????
	i = 0;
	while((i < 10))
	{
		if((partyWndClassicScript.m_PlayerName[i].GetName() == Name))
		{
			return true;
		}
		i++;
	}
	return false;
}

function bool IsPartyLive(string Name)
{
	local int i;
	local PartyWnd partywndscript;

	partywndscript = PartyWnd(GetScript("partywnd"));
	Debug(("라이브 일 때 랜스 몇????" @ string(10)));  // EN?: How many lances when live????
	i = 0;
	while((i < 10))
	{
		if((partywndscript.m_PlayerName[i].GetName() == Name))
		{
			return true;
		}
		i++;
	}
	return false;
}

function bool isFriend(string Name)
{
	local PersonalConnectionsWnd PersonalConnectionsWndScript;
	local L2Util l2UtilScript;

	PersonalConnectionsWndScript = PersonalConnectionsWnd(GetScript("PersonalConnectionsWnd"));
	l2UtilScript = L2Util(GetScript("L2Util"));
	return (l2UtilScript.ctrlListSearchByName(PersonalConnectionsWndScript.FriendList, Name) != -1);
}

function bool _IsBlocked(string Name)
{
	local PersonalConnectionsWnd PersonalConnectionsWndScript;
	local L2Util l2UtilScript;

	PersonalConnectionsWndScript = PersonalConnectionsWnd(GetScript("PersonalConnectionsWnd"));
	l2UtilScript = L2Util(GetScript("L2Util"));
	return (l2UtilScript.ctrlListSearchByName(PersonalConnectionsWndScript.BlockList, Name) != -1);
}

function int GetMyNobless()
{
	local UserInfo Info;

	if(!GetPlayerInfo(Info))
	{
		return -1;
	}
	return Info.nNobless;
}

function bool GetbHero()
{
	local UserInfo Info;

	if(!GetPlayerInfo(Info))
	{
		return false;
	}
	return Info.bHero;
}

function string getCurrentLocalTimeString()
{
	local L2UITime timeStruct;

	GetTimeStruct(int(((float(serverStartTime) + GetAppSeconds()) - float(clientStartSec))), timeStruct);
	return getMakeTimeString(timeStruct);
}

function bool IsTeleportFreeLevel()
{
	local UserInfo uInfo;

	if(!GetPlayerInfo(uInfo))
	{
		return false;
	}
	return (uInfo.nLevel <= teleportFreeLevel);
}

function INT64 GetTeleportPriceByID(int Id)
{
	local TeleportListAPI.TeleportListData listData;

	if(IsTeleportFreeLevel())
	{
		return INT64(0);
	}
	listData = Class'NWindow.TeleportListAPI'.static.GetFirstTeleportListData();
	while(("" != listData.Name))
	{
		if((listData.Id == Id))
		{
			return listData.Price[0].Amount;
		}
		listData = Class'NWindow.TeleportListAPI'.static.GetNextTeleportListData();
	}
	return INT64(-1);
}

function string GetTeleportPlaceNameByID(int Id)
{
	local TeleportListAPI.TeleportListData listData;

	listData = Class'NWindow.TeleportListAPI'.static.GetFirstTeleportListData();
	while(("" != listData.Name))
	{
		if((listData.Id == Id))
		{
			return listData.Name;
		}
		listData = Class'NWindow.TeleportListAPI'.static.GetNextTeleportListData();
	}
	return "";
}

function int GetTeleportIDByXYZ(int X, int Y, int Z, optional bool bOnlyTown)
{
	local TeleportListAPI.TeleportListData listData;
	local Vector Loc;
	local string locZoneName;

	Loc.X = float(X);
	Loc.Y = float(Y);
	Loc.Z = float(Z);
	locZoneName = GetZoneNameWithLocation(Loc);
	listData = Class'NWindow.TeleportListAPI'.static.GetFirstTeleportListData();
	while(("" != listData.Name))
	{
		if(bOnlyTown)
		{
			if(((listData.Priority == 1) || (listData.Priority == 2)))
			{
				if((listData.Name == locZoneName))
				{
					return listData.Id;
				}
			}
			listData = Class'NWindow.TeleportListAPI'.static.GetNextTeleportListData();
			continue;
		}
		if((listData.Name == locZoneName))
		{
			return listData.Id;
		}
		listData = Class'NWindow.TeleportListAPI'.static.GetNextTeleportListData();
	}
	return -1;
}

function TeleportListAPI.TeleportListData GetTeleportListDataByID(int Id)
{
	local TeleportListAPI.TeleportListData listData, emptyData;

	listData = Class'NWindow.TeleportListAPI'.static.GetFirstTeleportListData();
	while(("" != listData.Name))
	{
		if((listData.Id == Id))
		{
			return listData;
		}
		listData = Class'NWindow.TeleportListAPI'.static.GetNextTeleportListData();
	}
	return emptyData;
}

function SetCurrentClanNameValue(int point)
{
	clanNameValue = point;
	return;
}

function int GetCurrentClanNameValue()
{
	return clanNameValue;
}

function INT64 GetCurrentVitalityPoint()
{
	return nVitalityPoint;
}

function INT64 GetCurrentSP()
{
	return nSP;
}

function SetCurrentVitalityPoint(int point)
{
	nVitalityPoint = INT64(point);
	return;
}

function SetPcCafePoint(int point)
{
	PcCafePoint = point;
	return;
}

function int GetCurrentPcCafePoint()
{
	return PcCafePoint;
}

function SetCurrentCraftPoint(int point)
{
	craftPoint = point;
	return;
}

function int GetCurrentCraftPoint()
{
	return craftPoint;
}

function int GetScreenWidth()
{
	if((currentScreenWidth <= 0))
	{
		UpdateCurrentResolution();
	}
	return currentScreenWidth;
}

function int GetScreenHeight()
{
	if((currentScreenWidth <= 0))
	{
		UpdateCurrentResolution();
	}
	return currentScreenHeight;
}

function string Int2Str(int Num)
{
	if((Num < 10))
	{
		return ("0" $ string(Num));
	}
	return string(Num);
}

function bool IsPeaceZoneType(int zonetype)
{
	return (zonetype == 11);
}

function int _GetCurrentTranscendEnchant()
{
	return nCurrentTranscendEnchant;
}

function _SetCurrentTranscendEnchant(int enchantNum)
{
	nCurrentTranscendEnchant = enchantNum;
	return;
}

function _SetCurrentSlot(int SlotNum)
{
	nCurrentAdenLabNum = SlotNum;
	return;
}

function int _GetCurrentStageIndex()
{
	return ((nCurrentAdenLabNum + _GetCurrentTranscendEnchant()) - 1);
}

function string _GetAdenLabBossName(int BossID)
{
	Debug(((("__________________GetAdenLabBossName" @ string(BossID)) @ string(1)) @ GetSystemString(14676)));
	switch(BossID)
	{
		case 1:
			return GetSystemString(14676);
		default:
	}
}

function ResetUIData()
{
	ExecuteEvent(8000, "");
	ExecuteEvent(2900, "");
	ExecuteEvent(9750, "");
	RequestItemList();
	if(GetIsClassicServer())
	{
		Class'NWindow.UIDATA_CLAN'.static.RequestClanInfo();
	}
	return;
}

function StopTimer24()
{
	bTimer24Set = false;
	timer24Object._Stop();
	return;
}

function PlayTimer24()
{
	if(bTimer24Set)
	{
		return;
	}
	bTimer24Set = true;
	timer24Object._Reset();
	return;
}

function SetRoleTypeStr(int ClassID)
{
	roleTypeStr = GetClassRoleName(ClassID);
	return;
}

function GetData(string DataName)
{
	switch(DataName)
	{
		case "GameStateName":
			tmpDataString = GetGameStateName();
			break;
		case "nNobless":
			tmpDataInt = GetMyNobless();
			break;
		case "bHero":
			tmpDataBoolean = GetbHero();
			break;
		case "roleIconName":
			tmpDataString = GetClassRoleIconName(int(tmpDataString));
			break;
		case "roleBigIconName":
			tmpDataString = GetClassRoleIconNameBig(int(tmpDataString));
			break;
		case "arenaRoleIconName":
			tmpDataString = GetClassArenaRoleIconName(int(tmpDataString));
			break;
		case "ClassRoleNameByRole":
			tmpDataString = GetClassRoleNameByRole(int(byte(int(tmpDataString))));
			break;
		case "GetUserName":
			tmpDataString = Class'NWindow.UIDATA_USER'.static.GetUserName(int(tmpDataString));
			break;
		case "GetPartyMemberLocationWithID":
			setGetPartyMemberLocationWithID(int(tmpDataString));
			break;
		case "GetItemNameAllBySeverID":
			tmpDataString = GetItemNameAllBySeverID(int(tmpDataString));
			break;
		case "GetItemGradeTextureName":
			tmpDataString = GetItemGradeTextureName(int(tmpDataString));
			break;
		case "GetIsFriend":
			tmpDataBoolean = isFriend(tmpDataString);
			break;
		case "GetUIUserPremiumLevel":
			tmpDataInt = GetUIUserPremiumLevel();
			break;
		case "GetServerTimeString":
			tmpDataString = getCurrentServerTimeString();
			break;
		case "GetLocalTimeString":
			tmpDataString = getCurrentLocalTimeString();
			break;
		case "IsStackableItemByClassID":
			tmpDataBoolean = IsStackableItemByClassID(int(tmpDataString));
			break;
		case "GetAdditionalName":
			tmpDataString = GetAdditionalName(int(tmpDataString));
			break;
		case "MakeDecimalPointString2":
			tmpDataString = getInstanceL2Util().MakeDecimalPointString(tmpDataString, 2, true, false);
			break;
		default:
			break;
	}
	return;
}

function bool IsStackableItemByClassID(int ClassID)
{
	local ItemInfo Info;

	Info = GetItemInfoByClassID(ClassID);
	if(IsStackableItem(Info.ConsumeType))
	{
		return true;
	}
	return false;
}

function string GetAdditionalName(int ClassID)
{
	local ItemInfo Info;

	Info = GetItemInfoByClassID(ClassID);
	return Info.AdditionalName;
}

function setGetPartyMemberLocationWithID(int a_PartyMemberSID)
{
	local Vector a_Location;

	if(GetPartyMemberLocationWithID(int(tmpDataString), a_Location))
	{
		tmpDataString = "";
		ParamAdd(tmpDataString, "x", string(a_Location.X));
		ParamAdd(tmpDataString, "y", string(a_Location.Y));
		ParamAdd(tmpDataString, "z", string(a_Location.Z));
	}
	return;
}

function API_SendWindowsInfo()
{
	SendWindowsInfo();
	return;
}
