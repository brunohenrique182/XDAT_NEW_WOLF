class HeroTowerWnd extends UICommonAPI;

var int m_IDofHero;
var bool isWroldOlympiad;
var string m_Windowname;
var ListCtrlHandle m_hLstHero;

function OnRegisterEvent()
{
	RegisterEvent(880);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	m_hLstHero = GetListCtrlHandle((m_Windowname $ ".lstHero"));
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 880))
	{
		return;
		Clear();
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_Windowname);
		Class'NWindow.UIAPI_WINDOW'.static.SetFocus(m_Windowname);
		HandleCheckAmIHero();
		HandleHeroShowList(param);
	}
	return;
}

function OnDBClickListCtrlRecord(string strID)
{
	switch(strID)
	{
		case "lstHero":
			HandleShowDiary();
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
		case "btnShowDiary":
			HandleShowDiary();
			break;
		case "btnReg":
			Class'NWindow.HeroTowerAPI'.static.RequestWriteHeroWords(Class'NWindow.UIAPI_EDITBOX'.static.GetString((m_Windowname $ ".txtDiary")));
			Class'NWindow.UIAPI_EDITBOX'.static.SetString((m_Windowname $ ".txtDiary"), "");
			break;
		case "btnHistory":
			HandleShowHistory();
			break;
		default:
			break;
	}
	return;
}

function HandleShowDiary()
{
	local LVDataRecord Record;
	local string strTmp;

	m_hLstHero.GetSelectedRec(Record);
	if((Record.nReserved1 > INT64(0)))
	{
		strTmp = (("_diary?class=" $ string(Record.nReserved1)) $ "&page=1");
		RequestBypassToServer(strTmp);
	}
	return;
}

function HandleShowHistory()
{
	local LVDataRecord Record;

	if((m_hLstHero.GetSelectedIndex() < 0))
	{
		return;
	}
	m_hLstHero.GetSelectedRec(Record);
	Class'NWindow.HeroTowerAPI'.static.RequestHeroMatchRecord(int(Record.nReserved1));
	return;
}

function HandleCheckAmIHero()
{
	local bool bHero;

	bHero = Class'NWindow.UIDATA_PLAYER'.static.IsHero();
	if(bHero)
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((m_Windowname $ ".txtDiary"));
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((m_Windowname $ ".btnReg"));
	}
	else
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".txtDiary"));
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".btnReg"));
	}
	return;
}

function Clear()
{
	Class'NWindow.UIAPI_LISTCTRL'.static.DeleteAllItem((m_Windowname $ ".lstHero"));
	Class'NWindow.UIAPI_EDITBOX'.static.SetString((m_Windowname $ ".txtDiary"), "");
	return;
}

function HandleHeroShowList(string param)
{
	local int i, nMax;
	local string strName;
	local int ClassID;
	local string strPledgeName;
	local int PledgeCrestID;
	local string strAllianceName;
	local int AllianceCrestID, WinCount;
	local Texture texPledge, texAlliance;
	local LVDataRecord Record, recordClear;

	ParseInt(param, "Max", nMax);
	i = 0;
	while((i < nMax))
	{
		strName = "";
		ClassID = 0;
		strPledgeName = "";
		PledgeCrestID = 0;
		strAllianceName = "";
		AllianceCrestID = 0;
		WinCount = 0;
		ParseString(param, ("Name_" $ string(i)), strName);
		ParseInt(param, ("ClassId_" $ string(i)), ClassID);
		ParseString(param, ("PledgeName_" $ string(i)), strPledgeName);
		ParseInt(param, ("PledgeCrestId_" $ string(i)), PledgeCrestID);
		ParseString(param, ("AllianceName_" $ string(i)), strAllianceName);
		ParseInt(param, ("AllianceCrestId_" $ string(i)), AllianceCrestID);
		ParseInt(param, ("WinCount_" $ string(i)), WinCount);
		texPledge = GetPledgeCrestTexFromPledgeCrestID(PledgeCrestID);
		texAlliance = GetAllianceCrestTexFromAllianceCrestID(AllianceCrestID);
		Record = recordClear;
		Record.LVDataList.Length = 5;
		Record.LVDataList[0].szData = strName;
		Record.LVDataList[1].szData = GetClassType(ClassID);
		Record.LVDataList[2].szData = strPledgeName;
		if((AllianceCrestID > 0))
		{
			if((PledgeCrestID > 0))
			{
				Record.LVDataList[2].arrTexture.Length = 2;
				Record.LVDataList[2].arrTexture[0].objTex = texAlliance;
				Record.LVDataList[2].arrTexture[0].X = 10;
				Record.LVDataList[2].arrTexture[0].Y = 0;
				Record.LVDataList[2].arrTexture[0].Width = 8;
				Record.LVDataList[2].arrTexture[0].Height = 12;
				Record.LVDataList[2].arrTexture[0].U = 0;
				Record.LVDataList[2].arrTexture[0].V = 4;
				Record.LVDataList[2].arrTexture[1].objTex = texPledge;
				Record.LVDataList[2].arrTexture[1].X = 18;
				Record.LVDataList[2].arrTexture[1].Y = 0;
				Record.LVDataList[2].arrTexture[1].Width = 16;
				Record.LVDataList[2].arrTexture[1].Height = 12;
				Record.LVDataList[2].arrTexture[1].U = 0;
				Record.LVDataList[2].arrTexture[1].V = 4;
			}
			else
			{
				Record.LVDataList[2].arrTexture.Length = 1;
				Record.LVDataList[2].arrTexture[0].objTex = texPledge;
				Record.LVDataList[2].arrTexture[0].X = 10;
				Record.LVDataList[2].arrTexture[0].Y = 0;
				Record.LVDataList[2].arrTexture[0].Width = 8;
				Record.LVDataList[2].arrTexture[0].Height = 12;
				Record.LVDataList[2].arrTexture[0].U = 0;
				Record.LVDataList[2].arrTexture[0].V = 4;
			}
		}
		else if((PledgeCrestID > 0))
		{
			Record.LVDataList[2].arrTexture.Length = 1;
			Record.LVDataList[2].arrTexture[0].objTex = texPledge;
			Record.LVDataList[2].arrTexture[0].X = 10;
			Record.LVDataList[2].arrTexture[0].Y = 0;
			Record.LVDataList[2].arrTexture[0].Width = 16;
			Record.LVDataList[2].arrTexture[0].Height = 12;
			Record.LVDataList[2].arrTexture[0].U = 0;
			Record.LVDataList[2].arrTexture[0].V = 4;
		}
		Record.LVDataList[3].szData = strAllianceName;
		Record.LVDataList[4].szData = string(WinCount);
		Record.nReserved1 = INT64(ClassID);
		Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord((m_Windowname $ ".lstHero"), Record);
		i++;
	}
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="HeroTowerWnd"
}
