class HeroTowerWndWorld extends HeroTowerWnd;

var bool isWroldOlympiad;
var ListCtrlHandle m_hLstHero;

function OnRegisterEvent()
{
	RegisterEvent(880);
	return;
}

function OnEvent(int Event_ID, string param)
{
	Debug((("OnEvent1" @ string(Event_ID)) @ param));
	if((Event_ID == 880))
	{
		Clear();
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_Windowname);
		Class'NWindow.UIAPI_WINDOW'.static.SetFocus(m_Windowname);
		HandleHeroShowList(param);
	}
	return;
}

function OnDBClickListCtrlRecord(string strID)
{
	switch(strID)
	{
		case "lstHero":
			HandleShowHistory();
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnHistory":
			HandleShowHistory();
			break;
		default:
			break;
	}
	return;
}

function Clear()
{
	Class'NWindow.UIAPI_LISTCTRL'.static.DeleteAllItem((m_Windowname $ ".lstHero"));
	return;
}

function HandleHeroShowList(string param)
{
	local int i, nMax;
	local string strName;
	local int ClassID;
	local string strPledgeName;
	local int WinCount, Legend;
	local LVDataRecord Record, recordClear;
	local string ServerName;

	ParseInt(param, "Max", nMax);
	i = 0;
	while((i < nMax))
	{
		strName = "";
		ClassID = 0;
		strPledgeName = "";
		WinCount = 0;
		ParseString(param, ("ServerName_" $ string(i)), ServerName);
		ParseString(param, ("Name_" $ string(i)), strName);
		ParseInt(param, ("ClassId_" $ string(i)), ClassID);
		ParseString(param, ("PledgeName_" $ string(i)), strPledgeName);
		ParseInt(param, ("WinCount_" $ string(i)), WinCount);
		ParseInt(param, ("Legend_" $ string(i)), Legend);
		Record = recordClear;
		Record.LVDataList.Length = 5;
		Record.LVDataList[0].szData = ServerName;
		if((Legend == 1))
		{
			Record.LVDataList[1].hasIcon = true;
			Record.LVDataList[1].nTextureWidth = 16;
			Record.LVDataList[1].nTextureHeight = 16;
			Record.LVDataList[1].nTextureU = 16;
			Record.LVDataList[1].nTextureV = 16;
			Record.LVDataList[1].szTexture = "L2UI_CT1.PlayerStatusWnd.myinfo_Legendicon";
			Record.LVDataList[1].FirstLineOffsetX = 3;
			Record.LVDataList[1].szData = strName;
		}
		Record.LVDataList[1].szData = strName;
		Record.LVDataList[2].szData = GetClassType(ClassID);
		Record.LVDataList[3].szData = strPledgeName;
		Record.LVDataList[4].szData = string(WinCount);
		Record.nReserved1 = INT64(ClassID);
		Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord((m_Windowname $ ".lstHero"), Record);
		i++;
	}
	return;
}

defaultproperties
{
	m_Windowname="HeroTowerWndWorld"
}
