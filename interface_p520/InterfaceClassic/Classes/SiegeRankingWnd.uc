class SiegeRankingWnd extends UICommonAPI;

var string m_Windowname;
var WindowHandle Me;
var ButtonHandle btnClose;
var TextBoxHandle Descriptext;
var array<string> arrRankData;
var bool bFlag;
var RichListCtrlHandle Ranking_RichList;
//var delegate<SortByNumberDelegate> __SortByNumberDelegate__Delegate;

function Initialize()
{
	Me = GetWindowHandle(m_Windowname);
	btnClose = GetButtonHandle((m_Windowname $ ".SiegeMercenaryClose_Btn"));
	Ranking_RichList = GetRichListCtrlHandle((m_Windowname $ ".Ranking_RichList"));
	Descriptext = GetTextBoxHandle((m_Windowname $ ".Descriptext"));
	Ranking_RichList.SetAppearTooltipAtMouseX(true);
	Ranking_RichList.SetSelectedSelTooltip(false);
	bFlag = false;
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
		case 11320:
			if(bFlag)
			{
				HandleSiegeInfoAttackerStart();
			}
			break;
		case 11321:
			if(bFlag)
			{
				HandleSiegeInfoAttackerList(param);
			}
			break;
		case 11322:
			break;
		case 11330:
			break;
		case 11331:
			if(bFlag)
			{
				HandleSiegeInfoDefenderList(param);
			}
			break;
		case 11332:
			if(bFlag)
			{
				HandleSiegeInfoDefenderEnd();
			}
			break;
		default:
			break;
	}
	return;
}

function HandleSiegeInfoAttackerStart()
{
	arrRankData.Remove(0, arrRankData.Length);
	Ranking_RichList.DeleteAllItem();
	Descriptext.ShowWindow();
	return;
}

function HandleSiegeInfoAttackerList(string param)
{
	local int point;

	ParseInt(param, "CurrentPledgeSiegePoint", point);
	if((point > 0))
	{
		arrRankData.Insert(arrRankData.Length, 1);
		arrRankData[(arrRankData.Length - 1)] = param;
	}
	return;
}

function HandleSiegeInfoAttackerEnd()
{
	return;
}

function HandleSiegeInfoDefenderStart()
{
	return;
}

function HandleSiegeInfoDefenderList(string param)
{
	local int point;

	ParseInt(param, "CurrentPledgeSiegePoint", point);
	if((point > 0))
	{
		arrRankData.Insert(arrRankData.Length, 1);
		arrRankData[(arrRankData.Length - 1)] = param;
	}
	return;
}

function HandleSiegeInfoDefenderEnd()
{
	local int i, TOTALLEN;
	local string PledgeName;
	local int nCurrentPledgeSiegePoint;

	TOTALLEN = 3;
	// arrRankData.Sort(SortByNumberDelegate);   // array.Sort() unsupported by this compiler
	if((arrRankData.Length == 0))
	{
		Descriptext.ShowWindow();
	}
	else
	{
		Descriptext.HideWindow();
		if((arrRankData.Length < 3))
		{
			TOTALLEN = arrRankData.Length;
		}
		i = 0;
		while((i < TOTALLEN))
		{
			ParseString(arrRankData[i], "PledgeName", PledgeName);
			ParseInt(arrRankData[i], "CurrentPledgeSiegePoint", nCurrentPledgeSiegePoint);
			addRichListItemAmount((i + 1), PledgeName, nCurrentPledgeSiegePoint);
			i++;
		}
	}
	bFlag = false;
	return;
}

delegate int SortByNumberDelegate(string aParam, string bparam)
{
	local int aPoint, bPoint;

	ParseInt(aParam, "CurrentPledgeSiegePoint", aPoint);
	ParseInt(bparam, "CurrentPledgeSiegePoint", bPoint);
	if((aPoint < bPoint))
	{
		return -1;
	}
	return 0;
}

function addRichListItemAmount(int Rank, string PledgeName, int sc)
{
	local RichListCtrlRowData Record;

	Record.cellDataList.Length = 3;
	Record.nReserved1 = INT64(Rank);
	AddRichListCtrlString(Record.cellDataList[0].drawitems, string(Rank), GTColor().BWhite, false, 0, 0);
	AddRichListCtrlString(Record.cellDataList[1].drawitems, PledgeName, GTColor().BWhite, false, 0, 0);
	AddRichListCtrlString(Record.cellDataList[2].drawitems, MakeFullSystemMsg(GetSystemMessage(13712), string(sc)), GTColor().BWhite, false, 0, 0);
	Ranking_RichList.InsertRecord(Record);
	return;
}

function OnClickButton(string btnName)
{
	switch(btnName)
	{
		case "SiegeMercenaryClose_Btn":
			if(Me.IsShowWindow())
			{
				Me.HideWindow();
			}
			else
			{
				Me.ShowWindow();
			}
			break;
		default:
			break;
	}
	return;
}

function int GetCastleID()
{
	local SiegeWnd siegeWndScript;

	siegeWndScript = SiegeWnd(GetScript("SiegeWnd"));
	return siegeWndScript.castleIDs[siegeWndScript.SelectedIndex];
}

function OnShow()
{
	API_RequestMCWCastleSiegeAttackerList(GetCastleID());
	API_RequestMCWCastleSiegeDefenderList(GetCastleID());
	bFlag = true;
	return;
}

function API_RequestMCWCastleSiegeAttackerList(int tmpCastleID)
{
	if((tmpCastleID > 0))
	{
		Class'NWindow.SiegeAPI'.static.RequestMCWCastleSiegeAttackerList(tmpCastleID);
	}
	return;
}

function API_RequestMCWCastleSiegeDefenderList(int tmpCastleID)
{
	if((tmpCastleID > 0))
	{
		Class'NWindow.SiegeAPI'.static.RequestMCWCastleSiegeDefenderList(tmpCastleID);
	}
	return;
}

defaultproperties
{
	m_Windowname="SiegeRankingWnd"
}
