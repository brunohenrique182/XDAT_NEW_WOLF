class SiegeCastleInfoWnd extends UICommonAPI;

const MAX_Page = 3;

struct EVMCW_CastleInfoStruct
{
	var int castleID;
	var int OwnerPledgeID;
	var string OwnerPledgeName;
	var string OwnerPledgeMasterName;
	var int taxRate;
	var INT64 CurrentIncome;
	var INT64 TotalIncome;
	var int NextSiegeTime;
};

var string m_Windowname;
var WindowHandle Me;
var TextBoxHandle txtTaxNumber;
var TextBoxHandle txtTaxNextWeek;
var TextBoxHandle txtSiegeCalendarYearNumber;
var TextBoxHandle txtSiegeCalendarMonthNumber;
var TextBoxHandle txtSiegeCalendarDayNumber;
var TextBoxHandle txtWaitingTime;
var TextBoxHandle txtProgressTime;
var int currentTabNum;
var array<int> castleIDs;

function SetcastleIDs()
{
	castleIDs.Length = 2;
	castleIDs[0] = 3;
	castleIDs[1] = 7;
	return;
}

function Initialize()
{
	SetcastleIDs();
	Me = GetWindowHandle(m_Windowname);
	txtSiegeCalendarYearNumber = GetTextBoxHandle((m_Windowname $ ".txtSiegeCalendarYearNumber"));
	txtSiegeCalendarMonthNumber = GetTextBoxHandle((m_Windowname $ ".txtSiegeCalendarMonthNumber"));
	txtSiegeCalendarDayNumber = GetTextBoxHandle((m_Windowname $ ".txtSiegeCalendarDayNumber"));
	txtWaitingTime = GetTextBoxHandle((m_Windowname $ ".txtWaitingTime"));
	txtProgressTime = GetTextBoxHandle((m_Windowname $ ".txtProgressTime"));
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(11300);
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
	switch(Event_ID)
	{
		case 11300:
			HandleEVMCW_CastleInfo(param);
			break;
		default:
			break;
	}
	return;
}

function OnShow()
{
	if(ObserverWnd(GetScript("ObserverWnd")).m_bObserverMode)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(781));
		Me.HideWindow();
		return;
	}
	Me.SetFocus();
	ClearDayInfo();
	HideWindowHandleAll();
	RequestMCWCastleInfo_All();
	return;
}

function HideWindowHandleAll()
{
	local int i;

	currentTabNum = 0;
	i = 0;
	while((i < 3))
	{
		GetCastleWindowHandleByTabNum(i).HideWindow();
		i++;
	}
	return;
}

function ClearDayInfo()
{
	txtSiegeCalendarYearNumber.SetText("-");
	txtSiegeCalendarMonthNumber.SetText("-");
	txtSiegeCalendarDayNumber.SetText("-");
	txtWaitingTime.SetText(GetSystemString(3979));
	txtProgressTime.SetText(GetSystemString(3979));
	return;
}

function RequestMCWCastleInfo_All()
{
	local int i;

	i = 0;
	while((i < castleIDs.Length))
	{
		Class'NWindow.SiegeAPI'.static.RequestMCWCastleInfo(castleIDs[i]);
		i++;
	}
	return;
}

function HandleEVMCW_CastleInfo(string param)
{
	local int tabNum;
	local L2UITime L2UITime;
	local EVMCW_CastleInfoStruct MCW_CastleInfo;
	local TextureHandle textureCastleEmblem;
	local TextBoxHandle txtCastleName, txtPledgeName, txtPledgeMasterName;

	if(!Me.IsShowWindow())
	{
		return;
	}
	ParseInt(param, "NextSiegeTime", MCW_CastleInfo.NextSiegeTime);
	if((MCW_CastleInfo.NextSiegeTime == 0))
	{
		return;
	}
	tabNum = currentTabNum;
	currentTabNum++;
	ParseInt(param, "CastleID", MCW_CastleInfo.castleID);
	GetCastleWindowHandleByTabNum(tabNum).ShowWindow();
	ParseInt(param, "OwnerPledgeID", MCW_CastleInfo.OwnerPledgeID);
	ParseString(param, "OwnerPledgeName", MCW_CastleInfo.OwnerPledgeName);
	ParseString(param, "OwnerPledgeMasterName", MCW_CastleInfo.OwnerPledgeMasterName);
	ParseInt(param, "TaxRate", MCW_CastleInfo.taxRate);
	ParseINT64(param, "CurrentIncome", MCW_CastleInfo.CurrentIncome);
	ParseINT64(param, "TotalIncome", MCW_CastleInfo.TotalIncome);
	GetTimeStruct(MCW_CastleInfo.NextSiegeTime, L2UITime);
	textureCastleEmblem = GetTextureHandle((((m_Windowname $ ".") $ GetCastleInfoWndNameByTabNum(tabNum)) $ ".textureCastleEmblem"));
	txtCastleName = GetTextBoxHandle((((m_Windowname $ ".") $ GetCastleInfoWndNameByTabNum(tabNum)) $ ".txtCastleName"));
	txtPledgeName = GetTextBoxHandle((((m_Windowname $ ".") $ GetCastleInfoWndNameByTabNum(tabNum)) $ ".txtPledgeName"));
	txtPledgeMasterName = GetTextBoxHandle((((m_Windowname $ ".") $ GetCastleInfoWndNameByTabNum(tabNum)) $ ".txtPledgeMasterName"));
	txtTaxNumber = GetTextBoxHandle((((m_Windowname $ ".") $ GetCastleInfoWndNameByTabNum(tabNum)) $ ".txtTaxNumber"));
	txtTaxNextWeek = GetTextBoxHandle((((m_Windowname $ ".") $ GetCastleInfoWndNameByTabNum(tabNum)) $ ".txtTaxNextWeek"));
	textureCastleEmblem.SetTexture(GetCurrentCastleEmblem(MCW_CastleInfo.castleID));
	SetClanEmblem(MCW_CastleInfo.OwnerPledgeID, tabNum);
	txtCastleName.SetText(GetCastleName(MCW_CastleInfo.castleID));
	txtPledgeName.SetText(MCW_CastleInfo.OwnerPledgeName);
	txtPledgeMasterName.SetText(MCW_CastleInfo.OwnerPledgeMasterName);
	txtTaxNumber.SetText(string(MCW_CastleInfo.taxRate));
	txtTaxNextWeek.SetText(MakeCostStringINT64(MCW_CastleInfo.CurrentIncome));
	txtSiegeCalendarYearNumber.SetText(string(L2UITime.nYear));
	txtSiegeCalendarMonthNumber.SetText(Int2Str(L2UITime.nMonth));
	txtSiegeCalendarDayNumber.SetText(Int2Str(L2UITime.nDay));
	SetWaitintTime(L2UITime.nHour, L2UITime.nMin, L2UITime.nSec);
	SetProgressTime(L2UITime.nHour, L2UITime.nMin, L2UITime.nSec);
	return;
}

function SetWaitintTime(int NextSiegeHour, int NextSiegeMin, int NextSiegeSec)
{
	txtWaitingTime.SetText(((((((Int2Str((NextSiegeHour - 2)) $ ":") $ Int2Str(NextSiegeMin)) $ "~") $ Int2Str(NextSiegeHour)) $ ":") $ Int2Str(NextSiegeMin)));
	return;
}

function SetProgressTime(int NextSiegeHour, int NextSiegeMin, int NextSiegeSec)
{
	txtProgressTime.SetText(((((((Int2Str(NextSiegeHour) $ ":") $ Int2Str(NextSiegeMin)) $ "~") $ Int2Str((NextSiegeHour + 1))) $ ":") $ Int2Str(NextSiegeMin)));
	return;
}

function string GetCurrentCastleEmblem(int castleID)
{
	switch(castleID)
	{
		case 3:
			return "L2UI_ct1.SiegeWnd.SiegeWnd_SiegeCastleInfo_Flag_Giran";
			break;
		case 7:
			return "L2UI_ct1.SiegeWnd.SiegeWnd_SiegeCastleInfo_Flag_Godard";
			break;
		default:
			break;
	}
}

function SetClanEmblem(int PledgeID, int tabNum)
{
	local Texture PledgeCrestTexture, PledgeAllianceCrestTexture;
	local bool bPledge, bAlliance;
	local TextureHandle texturePledge, texturePledgeCrest;

	texturePledge = GetTextureHandle((((m_Windowname $ ".") $ GetCastleInfoWndNameByTabNum(tabNum)) $ ".texturePledge"));
	texturePledgeCrest = GetTextureHandle((((m_Windowname $ ".") $ GetCastleInfoWndNameByTabNum(tabNum)) $ ".texturePledgeCrest"));
	bPledge = Class'NWindow.UIDATA_CLAN'.static.GetCrestTexture(PledgeID, PledgeCrestTexture);
	bAlliance = Class'NWindow.UIDATA_CLAN'.static.GetAllianceCrestTexture(PledgeID, PledgeAllianceCrestTexture);
	texturePledge.SetTexture("");
	texturePledgeCrest.SetTexture("");
	if(bPledge)
	{
		texturePledge.SetTextureWithObject(PledgeCrestTexture);
	}
	if(bAlliance)
	{
		texturePledgeCrest.SetTextureWithObject(PledgeAllianceCrestTexture);
	}
	return;
}

function int GetCastleID()
{
	return 3;
}

function int GetTabNumByCastleID(int castleID)
{
	local int i;

	i = 0;
	while((i < castleIDs.Length))
	{
		if((castleIDs[i] == castleID))
		{
			return i;
		}
		i++;
	}
}

function string Int2Str(int Num)
{
	if((Num < 10))
	{
		return ("0" $ string(Num));
	}
	return string(Num);
}

function string GetCastleInfoWndNameByTabNum(int tabNum)
{
	return ("SiegeCastleInfoWnd_Tab0" $ string((tabNum + 1)));
}

function WindowHandle GetCastleWindowHandleByTabNum(int tabNum)
{
	return GetWindowHandle(((m_Windowname $ ".") $ GetCastleInfoWndNameByTabNum(tabNum)));
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("SiegeCastleInfoWnd");
	return;
}

defaultproperties
{
	m_Windowname="SiegeCastleInfoWnd"
}
