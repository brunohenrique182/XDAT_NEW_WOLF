class OlympiadResultWnd extends UICommonAPI;

const TIMER_ID = 148;
const TIMER_DELAY = 20000;

enum OLYMPIAD_PACKET_TYPE
{
	GO_GAME_LIST,                   // 0
	GO_GAME_RESULT,                 // 1
	GO_GAME_RESULT_V2,              // 2
	GO_GAME_RESULT_TEAM,            // 3
	GO_MAX                          // 4
};

struct ResultDataStruct
{
	var string pcName;
	var int TeamColor;
	var int ClassName;
	var string ClanName;
	var int clanID;
	var INT64 totalDamage;
	var int currentPoint;
	var int GetPoint;
	var string resultString;
	var int OlympiadPacketType;
};

struct WinnerDataStruct
{
	var string winnerName;
	var int TeamColor;
	var int winMemberNum;
	var int loseMemberNum;
};

var string m_Windowname;
var WindowHandle Me;
var RichListCtrlHandle ListCtrl;

function OnRegisterEvent()
{
	RegisterEvent(5081);
	return;
}

function OnLoad()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	SetClosingOnESC();
	ListCtrl = GetRichListCtrlHandle((m_Windowname $ ".OlympiadArenaList_ListCtrl"));
	ListCtrl.SetUseHorizontalScrollBar(true);
	ListCtrl.SetColumnMinimumWidth(true);
	HandleResultDraw();
	return;
}

function OnEvent(int Event_ID, string a_Param)
{
	switch(Event_ID)
	{
		case 5081:
			Debug((("my EV_ReceiveOlympiadResult:" @ string(Event_ID)) @ a_Param));
			ListCtrl.DeleteAllItem();
			GetTextBoxHandle((m_Windowname $ ".resultTxt_textbox")).SetText(GetSystemString(846));
			HandleResultLists(a_Param);
			Me.ShowWindow();
			break;
		default:
			break;
	}
	return;
}

function OnShow()
{
	Me.SetTimer(148, 20000);
	return;
}

function OnHide()
{
	HandleResultDraw();
	Me.KillTimer(148);
	return;
}

function OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case 148:
			Me.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string strID)
{
	Me.HideWindow();
	return;
}

function HandleResultLists(string a_Param)
{
	local ResultDataStruct resultData;
	local WinnerDataStruct winnerData;
	local int i, nOlympiadPacketType;

	ParseString(a_Param, "winnerName", winnerData.winnerName);
	ParseInt(a_Param, "teamColor", winnerData.TeamColor);
	ParseInt(a_Param, "winMemberNum", winnerData.winMemberNum);
	ParseInt(a_Param, "loseMemberNum", winnerData.loseMemberNum);
	ParseInt(a_Param, "OlympiadPacketType", nOlympiadPacketType);
	resultData.OlympiadPacketType = nOlympiadPacketType;
	Debug(("HandleResultLists a_param" @ a_Param));
	ListCtrl.SetColumnString(4, 2293);
	if(((int(GetLanguage()) == 9) || (int(GetLanguage()) == 8)))
	{
		ListCtrl.SetColumnString(4, 831);
	}
	i = 0;
	while((i < winnerData.winMemberNum))
	{
		ParseString(a_Param, ("winPcName" $ string(i)), resultData.pcName);
		ParseInt(a_Param, ("winTeamColor" $ string(i)), resultData.TeamColor);
		ParseString(a_Param, ("winClanName" $ string(i)), resultData.ClanName);
		ParseInt(a_Param, ("winClanID" $ string(i)), resultData.clanID);
		ParseInt(a_Param, ("winClassName" $ string(i)), resultData.ClassName);
		ParseINT64(a_Param, ("winTotalDamage" $ string(i)), resultData.totalDamage);
		ParseInt(a_Param, ("winCurrentPoint" $ string(i)), resultData.currentPoint);
		ParseInt(a_Param, ("winGetPoint" $ string(i)), resultData.GetPoint);
		if((winnerData.winnerName == ""))
		{
			resultData.resultString = GetSystemString(846);
		}
		else
		{
			resultData.resultString = GetSystemString(828);
		}
		if((winnerData.TeamColor == resultData.TeamColor))
		{
			HandleResultIsVictory(winnerData, (nOlympiadPacketType == 3));
		}
		HandleResultList(resultData);
		i++;
	}
	i = 0;
	while((i < winnerData.loseMemberNum))
	{
		ParseString(a_Param, ("losePcName" $ string(i)), resultData.pcName);
		ParseInt(a_Param, ("loseTeamColor" $ string(i)), resultData.TeamColor);
		ParseString(a_Param, ("loseClanName" $ string(i)), resultData.ClanName);
		ParseInt(a_Param, ("loseClanID" $ string(i)), resultData.clanID);
		ParseInt(a_Param, ("loseClassName" $ string(i)), resultData.ClassName);
		ParseINT64(a_Param, ("loseTotalDamage" $ string(i)), resultData.totalDamage);
		ParseInt(a_Param, ("loseCurrentPoint" $ string(i)), resultData.currentPoint);
		ParseInt(a_Param, ("loseGetPoint" $ string(i)), resultData.GetPoint);
		if((winnerData.winnerName == ""))
		{
			resultData.resultString = GetSystemString(846);
		}
		else
		{
			resultData.resultString = GetSystemString(2356);
		}
		if((winnerData.TeamColor == resultData.TeamColor))
		{
			HandleResultIsVictory(winnerData, (nOlympiadPacketType == 3));
		}
		HandleResultList(resultData);
		i++;
	}
	return;
}

function HandleResultList(ResultDataStruct resultData)
{
	local RichListCtrlRowData rowData;
	local Color TeamColor;
	local string pointString;
	local Texture PledgeCrestTexture, PledgeAllianceCrestTexture;
	local int clanTexturesNum;

	if((resultData.OlympiadPacketType == 3))
	{
		TeamColor = Get3vs3OlympiadTeamColor(resultData.TeamColor);
	}
	else
	{
		TeamColor = GetOlympiadTeamColor(resultData.TeamColor);
	}
	rowData.cellDataList.Length = 5;
	rowData.cellDataList[0].szData = resultData.pcName;
	rowData.cellDataList[0].drawitems.Length = 1;
	rowData.cellDataList[0].drawitems[0].eType = LCDIT_TEXT;
	rowData.cellDataList[0].drawitems[0].strInfo.strData = resultData.pcName;
	rowData.cellDataList[0].drawitems[0].strInfo.strColor = TeamColor;
	rowData.cellDataList[0].drawitems[0].strInfo.bStrNewLine = false;
	rowData.cellDataList[1].drawitems.Length = 1;
	rowData.cellDataList[1].drawitems[0].eType = LCDIT_TEXT;
	rowData.cellDataList[1].drawitems[0].strInfo.strData = GetClassType(resultData.ClassName);
	rowData.cellDataList[1].drawitems[0].strInfo.strColor = TeamColor;
	rowData.cellDataList[1].drawitems[0].strInfo.bStrNewLine = false;
	rowData.cellDataList[2].drawitems.Length = 3;
	clanTexturesNum = 0;
	if(Class'NWindow.UIDATA_CLAN'.static.GetAllianceCrestTexture(resultData.clanID, PledgeAllianceCrestTexture))
	{
		rowData.cellDataList[2].drawitems[clanTexturesNum].eType = LCDIT_TEXTURE;
		rowData.cellDataList[2].drawitems[clanTexturesNum].texInfo.sTex = string(PledgeAllianceCrestTexture);
		rowData.cellDataList[2].drawitems[clanTexturesNum].nPosX = 0;
		rowData.cellDataList[2].drawitems[clanTexturesNum].nPosY = 0;
		rowData.cellDataList[2].drawitems[clanTexturesNum].texInfo.Width = 14;
		rowData.cellDataList[2].drawitems[clanTexturesNum].texInfo.Height = 14;
		rowData.cellDataList[2].drawitems[clanTexturesNum].texInfo.UL = 14;
		rowData.cellDataList[2].drawitems[clanTexturesNum].texInfo.VL = 14;
		clanTexturesNum++;
	}
	if(Class'NWindow.UIDATA_CLAN'.static.GetCrestTexture(resultData.clanID, PledgeCrestTexture))
	{
		rowData.cellDataList[2].drawitems[clanTexturesNum].eType = LCDIT_TEXTURE;
		rowData.cellDataList[2].drawitems[clanTexturesNum].texInfo.sTex = string(PledgeCrestTexture);
		rowData.cellDataList[2].drawitems[clanTexturesNum].nPosX = 0;
		rowData.cellDataList[2].drawitems[clanTexturesNum].nPosY = 0;
		rowData.cellDataList[2].drawitems[clanTexturesNum].texInfo.Width = 14;
		rowData.cellDataList[2].drawitems[clanTexturesNum].texInfo.Height = 14;
		rowData.cellDataList[2].drawitems[clanTexturesNum].texInfo.UL = 14;
		rowData.cellDataList[2].drawitems[clanTexturesNum].texInfo.VL = 14;
		clanTexturesNum++;
	}
	rowData.cellDataList[2].drawitems[clanTexturesNum].eType = LCDIT_TEXT;
	rowData.cellDataList[2].drawitems[clanTexturesNum].strInfo.strData = resultData.ClanName;
	rowData.cellDataList[2].drawitems[clanTexturesNum].strInfo.strColor = TeamColor;
	rowData.cellDataList[2].drawitems[clanTexturesNum].strInfo.bStrNewLine = false;
	rowData.cellDataList[3].drawitems.Length = 1;
	rowData.cellDataList[3].drawitems[0].eType = LCDIT_TEXT;
	rowData.cellDataList[3].drawitems[0].strInfo.strData = string(resultData.totalDamage);
	rowData.cellDataList[3].drawitems[0].strInfo.strColor = TeamColor;
	rowData.cellDataList[3].drawitems[0].strInfo.bStrNewLine = false;
	rowData.cellDataList[4].drawitems.Length = 2;
	if((resultData.GetPoint > 0))
	{
		pointString = (((string(resultData.currentPoint) $ "[+") $ string(resultData.GetPoint)) $ "]");
	}
	else
	{
		pointString = (((string(resultData.currentPoint) $ "[") $ string(resultData.GetPoint)) $ "]");
	}
	rowData.cellDataList[4].szData = pointString;
	rowData.cellDataList[4].drawitems[1].eType = LCDIT_TEXT;
	rowData.cellDataList[4].drawitems[1].strInfo.strData = pointString;
	rowData.cellDataList[4].drawitems[1].strInfo.strColor = TeamColor;
	rowData.cellDataList[4].drawitems[1].strInfo.bStrNewLine = false;
	rowData.cellDataList[4].drawitems[1].nPosX = 16;
	if((resultData.OlympiadPacketType == 3))
	{
	}
	else
	{
		rowData.cellDataList[4].drawitems[0].eType = LCDIT_TEXTURE;
	}
	if((resultData.GetPoint > 0))
	{
		rowData.cellDataList[4].drawitems[0].texInfo.sTex = "L2UI_CT1.Clan.clan_DF_warlist_arrow2";
	}
	else if((resultData.GetPoint < 0))
	{
		rowData.cellDataList[4].drawitems[0].texInfo.sTex = "L2UI_CT1.Clan.clan_DF_warlist_arrow4";
	}
	rowData.cellDataList[4].drawitems[0].nPosX = 0;
	rowData.cellDataList[4].drawitems[0].nPosY = 0;
	rowData.cellDataList[4].drawitems[0].texInfo.Width = 14;
	rowData.cellDataList[4].drawitems[0].texInfo.Height = 14;
	rowData.cellDataList[4].drawitems[0].texInfo.UL = 14;
	rowData.cellDataList[4].drawitems[0].texInfo.VL = 14;
	ListCtrl.InsertRecord(rowData);
	return;
}

function HandleResultDraw()
{
	local HtmlHandle resultText;
	local string resultString, htmlAdd;
	local Rect rectWnd;

	resultText = GetHtmlHandle((m_Windowname $ ".resultTxt_textbox"));
	resultString = GetSystemString(846);
	resultString = htmlAddText(resultString, "hs16", "DCDCDC");
	rectWnd = resultText.GetRect();
	htmlAdd = HtmlAddTableTD(resultString, "center", "center", rectWnd.nWidth, 0, "", true);
	HtmlSetTableTR(htmlAdd);
	htmlAdd = (((((("<table width=" $ string(rectWnd.nWidth)) $ " height=") $ string(rectWnd.nHeight)) $ ">") $ htmlAdd) $ "</table>");
	resultText.LoadHtmlFromString(htmlSetHtmlStart(htmlAdd));
	return;
}

function HandleResultIsVictory(WinnerDataStruct winnerData, bool bTeam3vs3)
{
	local HtmlHandle resultText;
	local string resultString1, resultString2, htmlAdd, colorStr;
	local Rect rectWnd;

	resultText = GetHtmlHandle((m_Windowname $ ".resultTxt_textbox"));
	if((winnerData.winnerName == ""))
	{
		return;
	}
	resultString1 = winnerData.winnerName;
	if(bTeam3vs3)
	{
		resultString2 = GetSystemString(13236);
		switch(winnerData.TeamColor)
		{
			case 1:
				colorStr = "66AAEE";
				break;
			case 2:
				colorStr = "EE7777";
				break;
			default:
				break;
		}
	}
	else
	{
		resultString2 = GetSystemString(828);
		switch(winnerData.TeamColor)
		{
			case 1:
				colorStr = "EE7777";
				break;
			case 2:
				colorStr = "66AAEE";
				break;
			default:
				break;
		}
	}
	resultString1 = htmlAddText(resultString1, "hs16", colorStr);
	resultString2 = htmlAddText(resultString2, "hs16", "DCDCDC");
	rectWnd = resultText.GetRect();
	if(((int(GetLanguage()) == 9) || (int(GetLanguage()) == 8)))
	{
		htmlAdd = HtmlAddTableTD((resultString2 @ resultString1), "center", "center", rectWnd.nWidth, 0, "", true);
	}
	else
	{
		htmlAdd = HtmlAddTableTD((resultString1 @ resultString2), "center", "center", rectWnd.nWidth, 0, "", true);
	}
	HtmlSetTableTR(htmlAdd);
	htmlAdd = (((((("<table width=" $ string(rectWnd.nWidth)) $ " height=") $ string(rectWnd.nHeight)) $ ">") $ htmlAdd) $ "</table>");
	resultText.LoadHtmlFromString(htmlSetHtmlStart(htmlAdd));
	return;
}

function Color GetOlympiadTeamColor(int TeamColor)
{
	switch(TeamColor)
	{
		case 1:
			return GetColor(238, 119, 119, 255);
			break;
		case 2:
			return GetColor(102, 170, 238, 255);
			break;
		default:
			return GetColor(102, 170, 238, 255);
			break;
	}
	return GetColor(220, 220, 220, 255);
}

function Color Get3vs3OlympiadTeamColor(int TeamColor)
{
	switch(TeamColor)
	{
		case 1:
			return GetColor(102, 170, 238, 255);
			break;
		case 2:
			return GetColor(238, 119, 119, 255);
			break;
		default:
			return GetColor(102, 170, 238, 255);
			break;
	}
	return GetColor(220, 220, 220, 255);
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}
