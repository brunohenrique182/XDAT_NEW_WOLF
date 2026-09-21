class RankingWnd_Olympiad extends UICommonAPI
	dependson(UIPacket);

const TIMER_ID = 1001111;
const REFRESH_DELAY = 600;

enum OlympiadRankingType
{
	ORT_RANKING,                    // 0
	ORT_CLASSRANKING,               // 1
	ORT_CLASSRANKINGBYSERVER        // 2
};

enum OlympiadMatchResultType
{
	OMRT_WIN,                       // 0
	OMRT_LOSE,                      // 1
	OMRT_DRAW                       // 2
};

struct _S_EX_DECO_NPC_SET
{
	var int cResult;
	var int nAgitCID;
	var int cSlot;
	var int nDecoCID;
	var int nExpire;
};

struct ServerOlympiadHeroInfo
{
	var int nWorldID;
	var int nClassRoleType;
	var array<UIPacket._OlympiadHeroInfo> heroInfoArray;
};

var WindowHandle Me;
var WindowHandle disableWnd;
var TextureHandle RaceMark;
var TextureHandle RankingFlag;
var TextureHandle ClanMark;
var TextureHandle ClanMarkClassic;
var TextureHandle ClanBg;
var TextBoxHandle ClanNameText;
var TextBoxHandle levelText;
var TextBoxHandle ClassText;
var TextBoxHandle NameText;
var TextBoxHandle SesonText;
var ButtonHandle RankingHelpButton;
var TextureHandle OlympiadRankingArrow;
var TextBoxHandle OlympiadRankingEqualityText;
var TextBoxHandle OlympiadMyRankingText;
var TextBoxHandle OlympiadPointText;
var TextBoxHandle OlympiadCountText;
var TextBoxHandle OlympiadCountText2;
var TextBoxHandle LegendHeroTitleText;
var TextBoxHandle LegendNumText;
var TextBoxHandle LastSesonTitleText;
var TextBoxHandle LastSesonRankingText;
var TextBoxHandle ScoreTitleText;
var TextBoxHandle EnemyName01Text;
var TextBoxHandle EnemyName02Text;
var TextBoxHandle EnemyName03Text;
var TextureHandle EnemyClass01Icon;
var TextureHandle EnemyClass02Icon;
var TextureHandle EnemyClass03Icon;
var ButtonHandle RefreshButton;
var TextureHandle RankingTrophy;
var TextureHandle RankingPattern;
var TextureHandle RankingBg1;
var WindowHandle RankingTab01Wnd;
var ButtonHandle Top100Button;
var ButtonHandle MyRankingButton;
var ButtonHandle SeasonToggleButton;
var WindowHandle DisableWndList;
var TextBoxHandle List_Empty;
var WindowHandle ServerJobComboboxWnd;
var TextBoxHandle ServerCategoryText;
var ComboBoxHandle ServerCategoryCombobox;
var TextBoxHandle ClassCategoryText;
var ComboBoxHandle ClassCategoryCombobox;
var RichListCtrlHandle RankingTab01_RichList;
var WindowHandle RankingTab02Wnd;
var RichListCtrlHandle RankingTab02_RichList;
var TabHandle TabCtrl2;
var DetailStatusWnd DetailStatusWndScript;
var UserInfo myInfo;
var bool isFirstInit;
var UIEventManager.RankingScope currentRankingScope;
var UIEventManager.RankingGroup currentRankingGroup;
var OlympiadRankingType currentOlympiadRankingType;
var bool currentPastSeason;
var int currentClassID;
var int currentWorldID;
var int nTotalUser;
var bool bInitComboControl;
var int nElectionMatchCount;
var array<ServerOlympiadHeroInfo> eachServerHeroArray;
var array<ServerOlympiadHeroInfo> eachJobTypeHeroArray;
var string m_Windowname;

function OnRegisterEvent()
{
	RegisterEvent(9750);
	RegisterEvent(40);
	RegisterEvent((100000 + 832));
	RegisterEvent((100000 + 833));
	RegisterEvent((100000 + 834));
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
	DetailStatusWndScript = DetailStatusWnd(GetScript("DetailStatusWnd"));
	Me = GetWindowHandle(m_Windowname);
	disableWnd = GetWindowHandle((m_Windowname $ ".DisableWnd"));
	RaceMark = GetTextureHandle((m_Windowname $ ".RaceMark"));
	RankingFlag = GetTextureHandle((m_Windowname $ ".RankingFlag"));
	ClanMark = GetTextureHandle((m_Windowname $ ".ClanMark"));
	ClanMarkClassic = GetTextureHandle((m_Windowname $ ".ClanMarkClassic"));
	ClanBg = GetTextureHandle((m_Windowname $ ".ClanBg"));
	ClanNameText = GetTextBoxHandle((m_Windowname $ ".ClanNameText"));
	levelText = GetTextBoxHandle((m_Windowname $ ".LevelText"));
	ClassText = GetTextBoxHandle((m_Windowname $ ".ClassText"));
	NameText = GetTextBoxHandle((m_Windowname $ ".NameText"));
	SesonText = GetTextBoxHandle((m_Windowname $ ".SesonText"));
	RankingHelpButton = GetButtonHandle((m_Windowname $ ".RankingHelpButton"));
	OlympiadRankingArrow = GetTextureHandle((m_Windowname $ ".OlympiadRankingArrow"));
	OlympiadRankingEqualityText = GetTextBoxHandle((m_Windowname $ ".OlympiadRankingEqualityText"));
	OlympiadMyRankingText = GetTextBoxHandle((m_Windowname $ ".OlympiadMyRankingText"));
	OlympiadPointText = GetTextBoxHandle((m_Windowname $ ".OlympiadPointText"));
	OlympiadCountText = GetTextBoxHandle((m_Windowname $ ".OlympiadCountText"));
	OlympiadCountText2 = GetTextBoxHandle((m_Windowname $ ".OlympiadCountText2"));
	LegendHeroTitleText = GetTextBoxHandle((m_Windowname $ ".LegendHeroTitleText"));
	LegendNumText = GetTextBoxHandle((m_Windowname $ ".LegendNumText"));
	LastSesonTitleText = GetTextBoxHandle((m_Windowname $ ".LastSesonTitleText"));
	LastSesonRankingText = GetTextBoxHandle((m_Windowname $ ".LastSesonRankingText"));
	ScoreTitleText = GetTextBoxHandle((m_Windowname $ ".ScoreTitleText"));
	EnemyName01Text = GetTextBoxHandle((m_Windowname $ ".EnemyName01Text"));
	EnemyName02Text = GetTextBoxHandle((m_Windowname $ ".EnemyName02Text"));
	EnemyName03Text = GetTextBoxHandle((m_Windowname $ ".EnemyName03Text"));
	EnemyClass01Icon = GetTextureHandle((m_Windowname $ ".EnemyClass01Icon"));
	EnemyClass02Icon = GetTextureHandle((m_Windowname $ ".EnemyClass02Icon"));
	EnemyClass03Icon = GetTextureHandle((m_Windowname $ ".EnemyClass03Icon"));
	RefreshButton = GetButtonHandle((m_Windowname $ ".RefreshButton"));
	RankingTrophy = GetTextureHandle((m_Windowname $ ".RankingTrophy"));
	RankingPattern = GetTextureHandle((m_Windowname $ ".RankingPattern"));
	RankingBg1 = GetTextureHandle((m_Windowname $ ".RankingBg1"));
	RankingTab01Wnd = GetWindowHandle((m_Windowname $ ".RankingTab01Wnd"));
	Top100Button = GetButtonHandle((m_Windowname $ ".RankingTab01Wnd.Top100Button"));
	MyRankingButton = GetButtonHandle((m_Windowname $ ".RankingTab01Wnd.MyRankingButton"));
	SeasonToggleButton = GetButtonHandle((m_Windowname $ ".RankingTab01Wnd.SeasonToggleButton"));
	DisableWndList = GetWindowHandle((m_Windowname $ ".RankingTab01Wnd.DisableWndList"));
	List_Empty = GetTextBoxHandle((m_Windowname $ ".RankingTab01Wnd.DisableWndList.List_Empty"));
	ServerJobComboboxWnd = GetWindowHandle((m_Windowname $ ".RankingTab01Wnd.ServerJobComboboxWnd"));
	ServerCategoryText = GetTextBoxHandle((m_Windowname $ ".RankingTab01Wnd.ServerJobComboboxWnd.ServerCategoryText"));
	ServerCategoryCombobox = GetComboBoxHandle((m_Windowname $ ".RankingTab01Wnd.ServerJobComboboxWnd.ServerCategoryCombobox"));
	ClassCategoryText = GetTextBoxHandle((m_Windowname $ ".RankingTab01Wnd.ServerJobComboboxWnd.ClassCategoryText"));
	ClassCategoryCombobox = GetComboBoxHandle((m_Windowname $ ".RankingTab01Wnd.ServerJobComboboxWnd.ClassCategoryCombobox"));
	RankingTab01_RichList = GetRichListCtrlHandle((m_Windowname $ ".RankingTab01Wnd.RankingTab01_RichList"));
	RankingTab02Wnd = GetWindowHandle((m_Windowname $ ".RankingTab02Wnd"));
	RankingTab02_RichList = GetRichListCtrlHandle((m_Windowname $ ".RankingTab02Wnd.RankingTab02_RichList"));
	TabCtrl2 = GetTabHandle((m_Windowname $ ".TabCtrl2"));
	RankingTab01_RichList.SetUseStripeBackTexture(false);
	RankingTab02_RichList.SetUseStripeBackTexture(false);
	RankingTab01_RichList.SetSelectedSelTooltip(false);
	RankingTab01_RichList.SetAppearTooltipAtMouseX(true);
	RankingTab01_RichList.SetTooltipType("RankingOlympiad");
	RankingTab02_RichList.SetSelectedSelTooltip(false);
	RankingTab02_RichList.SetAppearTooltipAtMouseX(true);
	RankingTab02_RichList.SetTooltipType("RankingOlympiad");
	return;
}

function Load()
{
	return;
}

function OnShow()
{
	if(GetWindowHandle("RankingWnd").IsShowWindow())
	{
		GetPlayerInfo(myInfo);
		if((bInitComboControl == false))
		{
			initComboBox_ClassID();
			initComboBox_ServerList();
			bInitComboControl = true;
		}
		RankingTab01_RichList.DeleteAllItem();
		RankingTab02_RichList.DeleteAllItem();
		OnRefreshButtonClick();
	}
	return;
}

function OnHide()
{
	return;
}

function initUI()
{
	if((eachServerHeroArray.Length > 0))
	{
		eachServerHeroArray.Remove(0, eachServerHeroArray.Length);
	}
	if((eachJobTypeHeroArray.Length > 0))
	{
		eachJobTypeHeroArray.Remove(0, eachJobTypeHeroArray.Length);
	}
	initUIElements();
	SetCusomTooltipAtHelpBtn();
	disableWnd.HideWindow();
	Me.KillTimer(1001111);
	if(getInstanceUIData().GetIsClassicServer())
	{
		RankingTab01_RichList.SetColumnString(6, 13150);
		RankingTab01_RichList.SetColumnString(4, 13151);
		TabCtrl2.SetButtonName(2, GetSystemString(13148));
	}
	else
	{
		RankingTab01_RichList.SetColumnString(6, 13149);
		RankingTab01_RichList.SetColumnString(4, 14779);
		TabCtrl2.SetButtonName(2, GetSystemString(13147));
	}
	TabCtrl2.SetTopOrder(0, false);
	setTabState("TabCtrl20");
	setLikeRadioButton("Top100Button");
	currentPastSeason = true;
	setToggleSeasonButton();
	return;
}

function initUIElements()
{
	OlympiadRankingArrow.HideWindow();
	OlympiadRankingEqualityText.SetText("");
	SesonText.SetText("");
	ClassText.SetText("");
	ClanNameText.SetText("");
	NameText.SetText("");
	LegendNumText.SetText("");
	LastSesonRankingText.SetText("");
	OlympiadPointText.SetText("");
	OlympiadCountText.SetText("");
	OlympiadCountText2.SetText("");
	OlympiadMyRankingText.SetText("");
	EnemyName01Text.SetText("");
	EnemyName02Text.SetText("");
	EnemyName03Text.SetText("");
	EnemyClass01Icon.HideWindow();
	EnemyClass02Icon.HideWindow();
	EnemyClass03Icon.HideWindow();
	return;
}

function int myClassID()
{
	local int nClass;

	if(getInstanceUIData().GetIsLiveServer())
	{
		nClass = DetailStatusWndScript.getMainClassID();
	}
	else
	{
		nClass = myInfo.nSubClass;
	}
	return nClass;
}

function initComboBox_ClassID()
{
	local int classIndex, Max, nClassSystemString, nMyClassID, nOriginalClassID, selectIndex;
	local string fullNameString;
	local bool bSelect;

	nMyClassID = myClassID();
	Max = Class'NWindow.UIDataManager'.static.GetClassTypeMaxCount();
	ClassCategoryCombobox.Clear();
	classIndex = 0;
	while((classIndex < Max))
	{
		nClassSystemString = Class'NWindow.UIDataManager'.static.GetClassnameSysstringIndexByClassIndex(classIndex);
		fullNameString = GetSystemString(nClassSystemString);
		nOriginalClassID = -1;
		if((fullNameString != ""))
		{
			if(getInstanceUIData().GetIsClassicServer())
			{
				if((GetClassTransferDegree(classIndex) > 2))
				{
					nOriginalClassID = Class'NWindow.UIDataManager'.static.GetRootClassID(classIndex);
					if((nOriginalClassID > -1))
					{
						if(IsDeathKnightClass(nOriginalClassID))
						{
							if((classIndex == 199))
							{
								ClassCategoryCombobox.AddStringWithReserved(fullNameString, classIndex);
							}
						}
						else if(IsAssassinClass(nOriginalClassID))
						{
							if((classIndex == 224))
							{
								ClassCategoryCombobox.AddStringWithReserved(fullNameString, classIndex);
							}
						}
						else
						{
							ClassCategoryCombobox.AddStringWithReserved(fullNameString, classIndex);
						}
					}
				}
			}
			else if((GetClassTransferDegree(classIndex) > 3))
			{
				nOriginalClassID = Class'NWindow.UIDataManager'.static.GetRootClassID(classIndex);
				if((nOriginalClassID > -1))
				{
					if((classIndex != 216))
					{
						ClassCategoryCombobox.AddStringWithReserved(fullNameString, classIndex);
						if((classIndex == 151))
						{
							if((nMyClassID == 151))
							{
								selectIndex = (ClassCategoryCombobox.GetNumOfItems() - 1);
								bSelect = true;
							}
							nClassSystemString = Class'NWindow.UIDataManager'.static.GetClassnameSysstringIndexByClassIndex(216);
							fullNameString = GetSystemString(nClassSystemString);
							ClassCategoryCombobox.AddStringWithReserved(fullNameString, 216);
							if((nMyClassID == 216))
							{
								selectIndex = (ClassCategoryCombobox.GetNumOfItems() - 1);
								bSelect = true;
							}
						}
					}
				}
			}
			if(((classIndex != 151) && (classIndex != 216)))
			{
				if((((nOriginalClassID > -1) && (nMyClassID > 0)) && (nMyClassID == classIndex)))
				{
					selectIndex = (ClassCategoryCombobox.GetNumOfItems() - 1);
					bSelect = true;
				}
			}
		}
		classIndex++;
	}
	if((bSelect == false))
	{
		ClassCategoryCombobox.SetSelectedNum(0);
		currentClassID = ClassCategoryCombobox.GetReserved(0);
	}
	else
	{
		ClassCategoryCombobox.SetSelectedNum(selectIndex);
		currentClassID = ClassCategoryCombobox.GetReserved(selectIndex);
	}
	return;
}

function initComboBox_ServerList()
{
	local int i;
	local array<ServerInfoUIData> serverListArr;

	Class'NWindow.UIDataManager'.static.GetOlympiadGroupServerList(serverListArr);
	ServerCategoryCombobox.Clear();
	ServerCategoryCombobox.AddStringWithReserved(GetSystemString(1046), 0);
	i = 0;
	while((i < serverListArr.Length))
	{
		Debug("--------------------------------------------------------------------------");
		Debug(((string(serverListArr[i].ServerID) @ "(ServerID), ") @ serverListArr[i].ServerName));
		Debug(("- IsClassicServer " @ string(serverListArr[i].IsClassicServer)));
		Debug(("- IsAdenServer" @ string(serverListArr[i].IsAdenServer)));
		Debug(("- IsBroadCastServer" @ string(serverListArr[i].IsBroadCastServer)));
		Debug(("- IsBloodyServer" @ string(serverListArr[i].IsBloodyServer)));
		Debug(("- IsTestServer" @ string(serverListArr[i].IsTestServer)));
		Debug(("- IsWorldRaidServer" @ string(serverListArr[i].IsWorldRaidServer)));
		if(serverListArr[i].IsWorldRaidServer)
		{
			i++;
			continue;
		}
		if(serverListArr[i].IsBroadCastServer)
		{
			i++;
			continue;
		}
		ServerCategoryCombobox.AddStringWithReserved(serverListArr[i].ServerName, serverListArr[i].ServerID);
		i++;
	}
	if((ServerCategoryCombobox.GetNumOfItems() > 0))
	{
		ServerCategoryCombobox.SetSelectedNum(0);
		currentWorldID = ServerCategoryCombobox.GetReserved(0);
	}
	return;
}

function OnTimer(int TimeID)
{
	if((TimeID == 1001111))
	{
		hideDisableWnd();
	}
	return;
}

function SetCusomTooltipAtHelpBtn()
{
	RankingHelpButton.SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(13142), getInstanceL2Util().White, "", 250));
	return;
}

function OnComboBoxItemSelected(string strID, int Index)
{
	if((strID == "ClassCategoryCombobox"))
	{
		currentClassID = ClassCategoryCombobox.GetReserved(Index);
		OnRefreshButtonClick();
	}
	else if((strID == "ServerCategoryCombobox"))
	{
		currentWorldID = ServerCategoryCombobox.GetReserved(Index);
		OnRefreshButtonClick();
	}
	return;
}

function refresh()
{
	API_C_EX_OLYMPIAD_MY_RANKING_INFO();
	if((TabCtrl2.GetTopIndex() == 0))
	{
		currentOlympiadRankingType = ORT_RANKING;
		API_C_EX_OLYMPIAD_RANKING_INFO(currentOlympiadRankingType, currentRankingScope, currentPastSeason, currentClassID, currentWorldID);
	}
	else if((TabCtrl2.GetTopIndex() == 1))
	{
		if((ServerCategoryCombobox.GetSelectedNum() == 0))
		{
			currentOlympiadRankingType = ORT_CLASSRANKING;
		}
		else
		{
			currentOlympiadRankingType = ORT_CLASSRANKINGBYSERVER;
		}
		API_C_EX_OLYMPIAD_RANKING_INFO(currentOlympiadRankingType, currentRankingScope, currentPastSeason, currentClassID, currentWorldID);
	}
	else
	{
		API_C_EX_OLYMPIAD_HERO_AND_LEGEND_INFO();
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "RankingHelpButton":
			break;
		case "RefreshButton":
			OnRefreshButtonClick();
			break;
		case "Top100Button":
			setLikeRadioButton("Top100Button");
			OnRefreshButtonClick();
			break;
		case "MyRankingButton":
			setLikeRadioButton("MyRankingButton");
			OnRefreshButtonClick();
			break;
		case "SeasonToggleButton":
			OnSeasonToggleButtonClick();
			OnRefreshButtonClick();
			break;
		case "TabCtrl20":
		case "TabCtrl21":
		case "TabCtrl22":
			setTabState(Name);
			OnRefreshButtonClick();
			break;
		default:
			break;
	}
	return;
}

function setTabState(string TabName)
{
	if((TabName == "TabCtrl20"))
	{
		Top100Button.SetNameText(GetSystemString(3972));
		RankingTab01Wnd.ShowWindow();
		RankingTab02Wnd.HideWindow();
		ServerCategoryCombobox.HideWindow();
		ClassCategoryCombobox.HideWindow();
		ServerCategoryText.HideWindow();
		ClassCategoryText.HideWindow();
	}
	else if((TabName == "TabCtrl21"))
	{
		Top100Button.SetNameText(GetSystemString(13156));
		RankingTab01Wnd.ShowWindow();
		RankingTab02Wnd.HideWindow();
		if((int(currentRankingScope) == 0))
		{
			ServerCategoryText.ShowWindow();
			ClassCategoryText.ShowWindow();
			ServerCategoryCombobox.ShowWindow();
			ClassCategoryCombobox.ShowWindow();
		}
		else
		{
			ServerCategoryText.HideWindow();
			ClassCategoryText.HideWindow();
			ServerCategoryCombobox.HideWindow();
			ClassCategoryCombobox.HideWindow();
		}
	}
	else if((TabName == "TabCtrl22"))
	{
		RankingTab01Wnd.HideWindow();
		RankingTab02Wnd.ShowWindow();
	}
	return;
}

function OnRefreshButtonClick()
{
	RankingTab01_RichList.DeleteAllItem();
	RankingTab02_RichList.DeleteAllItem();
	setDisableWnd();
	refresh();
	return;
}

function OnSeasonToggleButtonClick()
{
	Debug(("OnSeasonToggleButtonClick" @ string(currentPastSeason)));
	currentPastSeason = !currentPastSeason;
	setToggleSeasonButton();
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 9750:
			bInitComboControl = false;
			initUI();
			break;
		case EV_PacketID(832):
			ParsePacket_OLYMPIAD_MY_RANKING_INFO();
			break;
		case EV_PacketID(833):
			ParsePacket_OLYMPIAD_RANKING_INFO();
			break;
		case EV_PacketID(834):
			ParsePacket_OLYMPIAD_HERO_AND_LEGEND_INFO();
			break;
		case 40:
			initUI();
			break;
		default:
			break;
	}
	return;
}

function AddRankingSystemListItem(UIPacket._OlympiadRankInfo rankInfo, int nElectionMatchCount)
{
	local RichListCtrlRowData rowData;
	local string texStr, tmStr;
	local Color applyColor;
	local int nH, nW, tH, tW, nAddY, nAddX, nChangeRankStrAddX, nChangeRank;
	local string levelStr, percentStr, changeRankStr, ClassName;
	local ServerInfoUIData ServerInfo;
	local bool bUseRankingTexture;
	local string NameLV;

	rowData.cellDataList.Length = 7;
	rowData.nReserved2 = INT64(rankInfo.nLevel);
	rowData.nReserved3 = INT64(nElectionMatchCount);
	rowData.cellDataList[5].szData = string(boolToNum(currentPastSeason));
	if(getInstanceUIData().GetIsLiveServer())
	{
		if(((rankInfo.nElectionRank <= 3) && (rankInfo.nElectionRank > 0)))
		{
			if((rankInfo.nElectionRank == 1))
			{
				texStr = "L2UI_ct1.RankingWnd.Medal_1st";
			}
			else if((rankInfo.nElectionRank == 2))
			{
				texStr = "L2UI_ct1.RankingWnd.Medal_2nd";
			}
			else if((rankInfo.nElectionRank == 3))
			{
				texStr = "L2UI_ct1.RankingWnd.Medal_3rd";
			}
			addRichListCtrlTexture(rowData.cellDataList[0].drawitems, texStr, 32, 43, 5, -1);
			bUseRankingTexture = true;
			nAddX = 10;
			nAddY = 6;
			nChangeRankStrAddX = 6;
		}
		else
		{
			GetTextSizeDefault(string(rankInfo.nRank), tW, tH);
			AddRichListCtrlString(rowData.cellDataList[0].drawitems, string(rankInfo.nRank), getInstanceL2Util().White, false, (23 - (tW / 2)), 12);
			nAddX = 14;
			nAddY = -4;
			nChangeRankStrAddX = 2;
		}
	}
	else if(((rankInfo.nRank <= 3) && (rankInfo.nRank > 0)))
	{
		if((rankInfo.nRank == 1))
		{
			texStr = "L2UI_ct1.RankingWnd.RankingWnd_1st";
		}
		else if((rankInfo.nRank == 2))
		{
			texStr = "L2UI_ct1.RankingWnd.RankingWnd_2nd";
		}
		else if((rankInfo.nRank == 3))
		{
			texStr = "L2UI_ct1.RankingWnd.RankingWnd_3rd";
		}
		addRichListCtrlTexture(rowData.cellDataList[0].drawitems, texStr, 38, 33, 5, 5);
		bUseRankingTexture = true;
		nAddX = 10;
		nAddY = 6;
		nChangeRankStrAddX = 6;
	}
	else
	{
		GetTextSizeDefault(string(rankInfo.nRank), tW, tH);
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, string(rankInfo.nRank), getInstanceL2Util().White, false, (23 - (tW / 2)), 12);
		nAddX = 14;
		nAddY = -4;
		nChangeRankStrAddX = 2;
	}
	rowData.cellDataList[0].szData = string(rankInfo.nRank);
	rowData.cellDataList[2].szData = ChinaHideName(rankInfo.sCharName);
	rowData.cellDataList[3].szData = rankInfo.sPledgeName;
	if((rankInfo.nPrevRank == 0))
	{
		nChangeRank = 0;
	}
	else
	{
		nChangeRank = (rankInfo.nPrevRank - rankInfo.nRank);
	}
	if(((int(currentRankingScope) == 1) && (rankInfo.nPrevRank == 0)))
	{
		nChangeRank = 0;
	}
	if((((((int(currentOlympiadRankingType) == 0) && (int(currentRankingScope) != 1)) && (rankInfo.nPrevRank > 100)) && (rankInfo.nRank <= 100)) || ((((int(currentOlympiadRankingType) != 0) && (int(currentRankingScope) != 1)) && (rankInfo.nPrevRank > 50)) && (rankInfo.nRank <= 50))))
	{
		changeRankStr = "NEW";
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, changeRankStr, GetColor(0, 255, 0, 255), false, (nAddX + nChangeRankStrAddX), (nAddY - 4));
		nChangeRankStrAddX = 0;
		nChangeRankStrAddX = (nChangeRankStrAddX + 8);
	}
	else if((nChangeRank > 0))
	{
		changeRankStr = string(nChangeRank);
		addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_CT1.RankingWnd.RankingWnd_ArrowUp", 8, 8, nAddX, nAddY);
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, changeRankStr, GetColor(230, 101, 101, 255), false, 2, -4);
		nAddX = (nAddX + 5);
	}
	else if((nChangeRank == 0))
	{
		changeRankStr = "-";
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, changeRankStr, GetColor(153, 153, 153, 255), false, (nAddX + nChangeRankStrAddX), (nAddY - 4));
		nChangeRankStrAddX = 0;
		nChangeRankStrAddX = (nChangeRankStrAddX + 8);
	}
	else
	{
		changeRankStr = string(nChangeRank);
		addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_CT1.RankingWnd.RankingWnd_ArrowDown", 8, 8, nAddX, nAddY);
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, changeRankStr, GetColor(0, 170, 255, 255), false, 2, -4);
		nAddX = (nAddX + 5);
	}
	GetTextSizeDefault(changeRankStr, tW, tH);
	percentStr = (stringPer(float(rankInfo.nRank), float(nTotalUser)) $ "%");
	if(bUseRankingTexture)
	{
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, (("(" $ percentStr) $ ")"), GetColor(170, 153, 119, 255), false, (-tW - nAddX), 14);
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, (("(" $ percentStr) $ ")"), GetColor(170, 153, 119, 255), false, ((-tW - 14) + nChangeRankStrAddX), 18);
	}
	if(Class'NWindow.UIDataManager'.static.GetServerInfo(rankInfo.nWorldID, ServerInfo))
	{
		rowData.cellDataList[1].szData = ServerInfo.ServerName;
		AddRichListCtrlString(rowData.cellDataList[1].drawitems, ServerInfo.ServerName, GetColor(170, 153, 119, 255), false, 0, 0);
	}
	levelStr = (("(Lv." $ string(rankInfo.nLevel)) $ ")");
	NameLV = (ChinaHideName(rankInfo.sCharName) @ levelStr);
	GetTextSizeDefault(NameLV, nW, nH);
	applyColor = GetColor(182, 182, 182, 255);
	if((nW > 208))
	{
		GetTextSizeDefault(levelStr, tW, tH);
		tmStr = makeShortStringByPixel((ChinaHideName(rankInfo.sCharName) $ " "), (208 - tW), "..");
		AddRichListCtrlString(rowData.cellDataList[2].drawitems, (tmStr @ levelStr), applyColor, false, 4, -4);
		GetTextSizeDefault((tmStr @ levelStr), nW, nH);
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[2].drawitems, NameLV, applyColor, false, 4, -4);
	}
	ClassName = GetClassType(rankInfo.nClassID);
	rowData.szReserved = ClassName;
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, ClassName, applyColor, false, -nW, 15);
	if((rankInfo.sPledgeName == ""))
	{
		AddRichListCtrlString(rowData.cellDataList[3].drawitems, GetSystemString(431), applyColor, false, 5, 0);
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[3].drawitems, rankInfo.sPledgeName, applyColor, false, 5, 0);
		GetTextSizeDefault(rankInfo.sPledgeName, nW, nH);
		AddRichListCtrlString(rowData.cellDataList[3].drawitems, (("(Lv." $ string(rankInfo.nPledgeLevel)) $ ")"), applyColor, false, -nW, 15);
	}
	if(getInstanceUIData().GetIsLiveServer())
	{
		AddRichListCtrlString(rowData.cellDataList[4].drawitems, ((((string(rankInfo.nWinCount) $ "/") $ string(rankInfo.nLoseCount)) $ "/") $ string(rankInfo.nDrawCount)), applyColor, false, 0, -7);
		GetTextSizeDefault(((((string(rankInfo.nWinCount) $ "/") $ string(rankInfo.nLoseCount)) $ "/") $ string(rankInfo.nDrawCount)), nW, nH);
		if((((rankInfo.nWinCount + rankInfo.nLoseCount) + rankInfo.nDrawCount) >= nElectionMatchCount))
		{
			AddRichListCtrlString(rowData.cellDataList[4].drawitems, (("(" $ string(((rankInfo.nWinCount + rankInfo.nLoseCount) + rankInfo.nDrawCount))) $ ")"), GTColor().White, true, (nW / 4), 0);
		}
		else
		{
			AddRichListCtrlString(rowData.cellDataList[4].drawitems, (("(" $ string(((rankInfo.nWinCount + rankInfo.nLoseCount) + rankInfo.nDrawCount))) $ ")"), GTColor().Red, true, (nW / 4), 0);
		}
		rowData.cellDataList[4].szData = ((((string(rankInfo.nWinCount) $ "/") $ string(rankInfo.nLoseCount)) $ "/") $ string(rankInfo.nDrawCount));
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[4].drawitems, ((string(rankInfo.nWinCount) $ "/") $ string(rankInfo.nLoseCount)), applyColor, false, 5, 0);
		rowData.cellDataList[4].szData = ((string(rankInfo.nWinCount) $ "/") $ string(rankInfo.nLoseCount));
	}
	AddRichListCtrlString(rowData.cellDataList[5].drawitems, MakeCostString(string(rankInfo.nOlympiadPoint)), applyColor, false, 5, 0);
	if(getInstanceUIData().GetIsClassicServer())
	{
		AddRichListCtrlString(rowData.cellDataList[6].drawitems, string(rankInfo.nHeroCount), applyColor, false, 5, 0);
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[6].drawitems, ((string(rankInfo.nLegendCount) $ "/") $ string(rankInfo.nHeroCount)), applyColor, false, 20, 0);
	}
	if(((myInfo.Name == ChinaOriginName(rankInfo.sCharName)) && (myInfo.nWorldID == rankInfo.nWorldID)))
	{
		rowData.sOverlayTex = "L2UI_CT1.RankingWnd.RankingWnd_MyRankBg";
	}
	else
	{
		rowData.sOverlayTex = "L2UI_CT1.EmptyBtn";
	}
	rowData.OverlayTexU = 734;
	rowData.OverlayTexV = 45;
	rowData.nReserved1 = INT64(1003);
	RankingTab01_RichList.InsertRecord(rowData);
	return;
}

function addList_LegendTitle()
{
	local RichListCtrlRowData rowData;
	local string texStr;

	rowData.cellDataList.Length = 2;
	rowData.sOverlayTex = "L2UI_CT1.RankingWnd.RankingWnd_LegendHeroHeaderBg";
	texStr = GetSystemString(13152);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, texStr, GetColor(255, 221, 102, 255), false, 15, 0, "hs14");
	addRichListCtrlTexture(rowData.cellDataList[1].drawitems, "L2UI_ch3.LoginWnd.aboutotpicon", 15, 15, 10, 0);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, GetSystemString(13153), GetColor(254, 215, 160, 255), false, 8, 1);
	rowData.nReserved1 = INT64(1001);
	rowData.szReserved = GetSystemString(13154);
	rowData.OverlayTexU = 734;
	rowData.OverlayTexV = 45;
	RankingTab02_RichList.InsertRecord(rowData);
	return;
}

function addList_HeroCountTitle()
{
	local RichListCtrlRowData rowData;
	local ServerInfoUIData ServerInfo;
	local string texStr, serverStr;
	local int i, textStrSizeX, nH;

	rowData.cellDataList.Length = 2;
	rowData.sOverlayTex = "L2UI_CT1.RankingWnd.RankingWnd_LegendHeroHeaderBg";
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, GetSystemString(13144), GetColor(255, 221, 102, 255), false, 15, 0, "hs14");
	addRichListCtrlTexture(rowData.cellDataList[1].drawitems, "L2UI_ch3.LoginWnd.aboutotpicon", 15, 15, 10, 0);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, GetSystemString(13163), GetColor(170, 153, 119, 255), false, 8, 1);
	rowData.OverlayTexU = 734;
	rowData.OverlayTexV = 70;
	GetTextSizeDefault(texStr, textStrSizeX, nH);
	i = 0;
	while((i < eachServerHeroArray.Length))
	{
		if(Class'NWindow.UIDataManager'.static.GetServerInfo(eachServerHeroArray[i].nWorldID, ServerInfo))
		{
			serverStr = (((serverStr $ ServerInfo.ServerName) @ string(eachServerHeroArray[i].heroInfoArray.Length)) $ GetSystemString(1013));
			if(((i + 1) < eachServerHeroArray.Length))
			{
				serverStr = (serverStr $ ", ");
			}
		}
		i++;
	}
	rowData.nReserved1 = INT64(1000);
	rowData.szReserved = serverStr;
	RankingTab02_RichList.InsertRecord(rowData);
	return;
}

function addListBG_ClassRole(int nClassRoleType)
{
	local RichListCtrlRowData rowData;
	local string texStr;

	rowData.cellDataList.Length = 1;
	rowData.sOverlayTex = "L2UI_CT1.RankingWnd.RankingWnd_ClassHeaderBg";
	texStr = GetClassRoleNameByRole(nClassRoleType);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, texStr, GetColor(170, 153, 119, 255), false, 15, 0, "hs11");
	rowData.OverlayTexU = 734;
	rowData.OverlayTexV = 70;
	RankingTab02_RichList.InsertRecord(rowData);
	return;
}

function AddLegendHeroListItem(UIPacket._OlympiadHeroInfo heroInfo, optional bool bLegend)
{
	local RichListCtrlRowData rowData;
	local ServerInfoUIData ServerInfo;
	local string heroPhotoTexture, texStr, tmStr, levelStr;
	local Color applyColor;
	local int nW, nH, tW, tH;
	local string NameLV;

	rowData.cellDataList.Length = 6;
	heroPhotoTexture = getSD_CharacterTexture(heroInfo.nRace, heroInfo.nClassID, heroInfo.nSex);
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems, heroPhotoTexture, 58, 58, 5, 14);
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_ct1.RankingWnd.RankingWnd_LegendHeroStar", 28, 28, 6, 15);
	texStr = (string(heroInfo.nCount) @ GetSystemString(3295));
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, texStr, getInstanceL2Util().Yellow, false, 0, 6, "chatFontSize11");
	levelStr = (("(Lv." $ string(heroInfo.nLevel)) $ ")");
	NameLV = (ChinaHideName(heroInfo.sCharName) @ levelStr);
	GetTextSizeDefault(NameLV, nW, nH);
	if(bLegend)
	{
		applyColor = GetColor(254, 215, 160, 255);
		rowData.cellDataList[0].szData = ((GetSystemString(13152) $ " : ") $ ChinaHideName(heroInfo.sCharName));
	}
	else
	{
		applyColor = getInstanceL2Util().BWhite;
		rowData.cellDataList[0].szData = ((GetSystemString(13144) $ " : ") $ ChinaHideName(heroInfo.sCharName));
	}
	if((nW > 200))
	{
		GetTextSizeDefault(levelStr, tW, tH);
		tmStr = makeShortStringByPixel(ChinaHideName(heroInfo.sCharName), (180 - tW), "..");
		AddRichListCtrlString(rowData.cellDataList[1].drawitems, (tmStr @ levelStr), applyColor, false, 4, -4);
		GetTextSizeDefault((tmStr @ levelStr), nW, nH);
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[1].drawitems, NameLV, applyColor, false, 4, -4);
		GetTextSizeDefault(NameLV, nW, nH);
	}
	applyColor = GetColor(182, 182, 182, 255);
	texStr = GetClassType(heroInfo.nClassID);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, makeShortStringByPixel(texStr, 200, ".."), applyColor, false, -nW, 15);
	rowData.cellDataList[1].szData = texStr;
	if(Class'NWindow.UIDataManager'.static.GetServerInfo(heroInfo.nWorldID, ServerInfo))
	{
		if((ServerInfo.ServerID == GetServerNo()))
		{
			rowData.cellDataList[2].szData = ServerInfo.ServerName;
			AddRichListCtrlString(rowData.cellDataList[2].drawitems, makeShortStringByPixel(ServerInfo.ServerName, 72, ".."), GetColor(170, 153, 119, 255), false, 0, -4);
			GetTextSizeDefault(makeShortStringByPixel(ServerInfo.ServerName, 72, ".."), tW, tH);
			AddRichListCtrlString(rowData.cellDataList[2].drawitems, (("(" $ GetSystemString(13155)) $ ")"), GetColor(136, 255, 255, 255), false, -tW, 15);
		}
		else
		{
			rowData.cellDataList[2].szData = ServerInfo.ServerName;
			AddRichListCtrlString(rowData.cellDataList[2].drawitems, makeShortStringByPixel(ServerInfo.ServerName, 72, ".."), GetColor(170, 153, 119, 255), false, 0, 0);
		}
	}
	if((heroInfo.sPledgeName == ""))
	{
		AddRichListCtrlString(rowData.cellDataList[3].drawitems, GetSystemString(431), applyColor, false, 5, 0);
	}
	else
	{
		if(bLegend)
		{
			applyColor = GetColor(254, 215, 160, 255);
		}
		else
		{
			applyColor = GetColor(182, 182, 182, 255);
		}
		AddRichListCtrlString(rowData.cellDataList[3].drawitems, makeShortStringByPixel(heroInfo.sPledgeName, 122, ".."), applyColor, false, 5, -4);
		GetTextSizeDefault(heroInfo.sPledgeName, nW, nH);
		AddRichListCtrlString(rowData.cellDataList[3].drawitems, (("(Lv." $ string(heroInfo.nPledgeLevel)) $ ")"), applyColor, false, -nW, 15);
	}
	rowData.cellDataList[3].szData = heroInfo.sPledgeName;
	applyColor = GetColor(182, 182, 182, 255);
	if(getInstanceUIData().GetIsLiveServer())
	{
		AddRichListCtrlString(rowData.cellDataList[4].drawitems, ((((string(heroInfo.nWinCount) $ "/") $ string(heroInfo.nLoseCount)) $ "/") $ string(heroInfo.nDrawCount)), applyColor, false, 0, 0);
		rowData.cellDataList[4].szData = ((((string(heroInfo.nWinCount) $ "/") $ string(heroInfo.nLoseCount)) $ "/") $ string(heroInfo.nDrawCount));
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[4].drawitems, ((((string(heroInfo.nWinCount) $ GetSystemString(3844)) $ "/") $ string(heroInfo.nLoseCount)) @ GetSystemString(3859)), applyColor, false, 0, 0);
		rowData.cellDataList[4].szData = ((string(heroInfo.nWinCount) $ "/") $ string(heroInfo.nLoseCount));
	}
	AddRichListCtrlString(rowData.cellDataList[5].drawitems, (MakeCostString(string(heroInfo.nOlympiadPoint)) @ GetSystemString(1442)), applyColor, false, 20, 0);
	rowData.nReserved1 = INT64(1002);
	RankingTab02_RichList.InsertRecord(rowData);
	return;
}

function addEachJobTypeHeroArray(out array<ServerOlympiadHeroInfo> heroInfoArray, UIPacket._OlympiadHeroInfo heroInfo)
{
	local int i, nRoleType;
	local ServerOlympiadHeroInfo newServerOlympiadHeroInfo;

	i = 0;
	while((i < heroInfoArray.Length))
	{
		nRoleType = int(GetClassRoleType(heroInfo.nClassID));
		if((heroInfoArray[i].nClassRoleType == nRoleType))
		{
			heroInfoArray[i].heroInfoArray[heroInfoArray[i].heroInfoArray.Length] = heroInfo;
			return;
		}
		i++;
	}
	nRoleType = int(GetClassRoleType(heroInfo.nClassID));
	newServerOlympiadHeroInfo.nClassRoleType = nRoleType;
	newServerOlympiadHeroInfo.heroInfoArray[newServerOlympiadHeroInfo.heroInfoArray.Length] = heroInfo;
	heroInfoArray[heroInfoArray.Length] = newServerOlympiadHeroInfo;
	return;
}

function addEachServerHeroCountArray(out array<ServerOlympiadHeroInfo> heroInfoArray, UIPacket._OlympiadHeroInfo heroInfo)
{
	local int i;
	local ServerOlympiadHeroInfo newServerOlympiadHeroInfo;

	i = 0;
	while((i < heroInfoArray.Length))
	{
		if((heroInfoArray[i].nWorldID == heroInfo.nWorldID))
		{
			heroInfoArray[i].heroInfoArray[heroInfoArray[i].heroInfoArray.Length] = heroInfo;
			return;
		}
		i++;
	}
	newServerOlympiadHeroInfo.nWorldID = heroInfo.nWorldID;
	newServerOlympiadHeroInfo.heroInfoArray[newServerOlympiadHeroInfo.heroInfoArray.Length] = heroInfo;
	heroInfoArray[heroInfoArray.Length] = newServerOlympiadHeroInfo;
	return;
}

function ParsePacket_OLYMPIAD_HERO_AND_LEGEND_INFO()
{
	local UIPacket._S_EX_OLYMPIAD_HERO_AND_LEGEND_INFO packet;
	local int i, N;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_OLYMPIAD_HERO_AND_LEGEND_INFO(packet))
	{
		return;
	}
	if((packet.legendInfo.sCharName != ""))
	{
		addList_LegendTitle();
		AddLegendHeroListItem(packet.legendInfo, true);
	}
	eachServerHeroArray.Remove(0, eachServerHeroArray.Length);
	eachJobTypeHeroArray.Remove(0, eachJobTypeHeroArray.Length);
	i = 0;
	while((i < packet.heroInfoList.Length))
	{
		addEachServerHeroCountArray(eachServerHeroArray, packet.heroInfoList[i]);
		addEachJobTypeHeroArray(eachJobTypeHeroArray, packet.heroInfoList[i]);
		i++;
	}
	if((packet.heroInfoList.Length > 0))
	{
		addList_HeroCountTitle();
	}
	i = 0;
	while((i < eachJobTypeHeroArray.Length))
	{
		if((eachJobTypeHeroArray[i].heroInfoArray.Length > 0))
		{
			addListBG_ClassRole(eachJobTypeHeroArray[i].nClassRoleType);
		}
		N = 0;
		while((N < eachJobTypeHeroArray[i].heroInfoArray.Length))
		{
			AddLegendHeroListItem(eachJobTypeHeroArray[i].heroInfoArray[N]);
			N++;
		}
		i++;
	}
	if((RankingTab02_RichList.GetRecordCount() > 0))
	{
		RankingTab02_RichList.SetFocus();
	}
	return;
}

function string getSD_CharacterTexture(int nRace, int nClassID, int nSex)
{
	local string sexStr;

	if((nSex > 0))
	{
		sexStr = "W";
	}
	else
	{
		sexStr = "M";
	}
	if((nRace == 6))
	{
		sexStr = "W";
	}
	if(IsDeathKnightClass(Class'NWindow.UIDataManager'.static.GetRootClassID(nClassID)))
	{
		sexStr = "M";
	}
	if(IsDeathFighterClass(Class'NWindow.UIDataManager'.static.GetRootClassID(nClassID)))
	{
		sexStr = "M";
	}
	if(IsRoseVainClass(Class'NWindow.UIDataManager'.static.GetRootClassID(nClassID)))
	{
		sexStr = "W";
	}
	return ((((("L2UI_CT1.RankingWnd.RankingWnd_FaceIcon_" $ GetRaceString(nRace)) $ "_") $ getInstanceL2Util().GetPlayerType(nClassID, nRace)) $ "_") $ sexStr);
}

function ParsePacket_OLYMPIAD_RANKING_INFO()
{
	local UIPacket._S_EX_OLYMPIAD_RANKING_INFO packet;
	local int i, nStartRow, nMyRanking;
	local bool bIAmRanker;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_OLYMPIAD_RANKING_INFO(packet))
	{
		return;
	}
	GetPlayerInfo(myInfo);
	nTotalUser = packet.nTotalUser;
	i = 0;
	while((i < packet.rankInfoList.Length))
	{
		AddRankingSystemListItem(packet.rankInfoList[i], packet.nElectionMatchCount);
		if(((ChinaOriginName(packet.rankInfoList[i].sCharName) == myInfo.Name) && (myInfo.nWorldID == packet.rankInfoList[i].nWorldID)))
		{
			bIAmRanker = true;
			nMyRanking = packet.rankInfoList[i].nRank;
		}
		i++;
	}
	if((packet.rankInfoList.Length <= 0))
	{
		DisableWndList.ShowWindow();
	}
	else
	{
		DisableWndList.HideWindow();
		if(bIAmRanker)
		{
			nStartRow = (nMyRanking - 3);
			if((nStartRow > 0))
			{
				if((RankingTab01_RichList.GetRecordCount() > nStartRow))
				{
					RankingTab01_RichList.SetStartRow(nStartRow);
				}
			}
		}
	}
	RankingTab01_RichList.SetFocus();
	return;
}

function ParsePacket_OLYMPIAD_MY_RANKING_INFO()
{
	local UIPacket._S_EX_OLYMPIAD_MY_RANKING_INFO packet;
	local Texture PledgeCrestTexture;
	local bool bPledgeCrestTexture;
	local int nClass, nLevel, i, nChangeRank;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_OLYMPIAD_MY_RANKING_INFO(packet))
	{
		return;
	}
	GetPlayerInfo(myInfo);
	if(getInstanceUIData().GetIsLiveServer())
	{
		nClass = DetailStatusWndScript.getMainClassID();
		nLevel = DetailStatusWndScript.getMainLevel();
	}
	else
	{
		nClass = myInfo.nSubClass;
		nLevel = myInfo.nLevel;
	}
	levelText.SetText(("Lv." $ string(nLevel)));
	ClassText.SetText(GetClassType(nClass));
	if((myInfo.nClanID > 0))
	{
		ClanNameText.SetText(GetClanName(myInfo.nClanID));
	}
	else
	{
		ClanNameText.SetText(GetSystemString(431));
	}
	NameText.SetText(myInfo.Name);
	bPledgeCrestTexture = Class'NWindow.UIDATA_CLAN'.static.GetCrestTexture(myInfo.nClanID, PledgeCrestTexture);
	if(getInstanceUIData().GetIsLiveServer())
	{
		ClanMarkClassic.HideWindow();
		if(bPledgeCrestTexture)
		{
			ClanMark.ShowWindow();
			ClanMark.SetTextureWithObject(PledgeCrestTexture);
		}
		else
		{
			ClanMark.HideWindow();
		}
	}
	else
	{
		ClanMark.HideWindow();
		if(bPledgeCrestTexture)
		{
			ClanMarkClassic.ShowWindow();
			ClanMarkClassic.SetTextureWithObject(PledgeCrestTexture);
		}
		else
		{
			ClanMarkClassic.HideWindow();
		}
	}
	RaceMark.SetTexture(("l2ui_ct1.RankingWnd.RankingWnd_RaceMark_" $ GetRaceString(myInfo.Race)));
	if((isFirstInit == false))
	{
		isFirstInit = true;
	}
	if((packet.nPrevRank == 0))
	{
		nChangeRank = 0;
	}
	else
	{
		nChangeRank = (packet.nPrevRank - packet.nRank);
	}
	if(getInstanceUIData().GetIsClassicServer())
	{
		SesonText.SetText((string(packet.nSeason) $ GetSystemString(934)));
	}
	else
	{
		SesonText.SetText((((string(packet.nSeasonYear) $ GetSystemString(3847)) @ string(packet.nSeasonMonth)) $ GetSystemString(3848)));
	}
	if((nChangeRank > 0))
	{
		OlympiadRankingArrow.ShowWindow();
		OlympiadRankingArrow.SetTexture("L2UI_CT1.RankingWnd.RankingWnd_ArrowUp");
		OlympiadRankingEqualityText.SetText(string(nChangeRank));
	}
	else if((nChangeRank < 0))
	{
		OlympiadRankingArrow.ShowWindow();
		OlympiadRankingArrow.SetTexture("L2UI_CT1.RankingWnd.RankingWnd_ArrowDown");
		OlympiadRankingEqualityText.SetText(string(nChangeRank));
	}
	else
	{
		OlympiadRankingEqualityText.SetText("-");
		OlympiadRankingArrow.HideWindow();
	}
	OlympiadMyRankingText.SetText((string(packet.nRank) @ GetSystemString(1375)));
	OlympiadPointText.SetText((MakeCostString(string(packet.nOlympiadPoint)) @ GetSystemString(1442)));
	nElectionMatchCount = packet.nElectionMatchCount;
	if(getInstanceUIData().GetIsLiveServer())
	{
		OlympiadCountText.SetText(((((string(packet.nWinCount) @ "/") @ string(packet.nLoseCount)) @ "/") @ string(packet.nDrawCount)));
		OlympiadCountText.SetTooltipText(((((GetSystemString(3844) $ "/") $ GetSystemString(3854)) $ "/") $ GetSystemString(13146)));
		OlympiadCountText.MoveC(638, 124);
		OlympiadCountText2.SetText(((GetSystemString(14777) @ ":") @ string(packet.nElectionMatchCount)));
		OlympiadCountText2.SetTooltipText(GetSystemString(14778));
	}
	else
	{
		OlympiadCountText.SetText(((string(packet.nWinCount) @ "/ ") @ string(packet.nLoseCount)));
		OlympiadCountText.SetTooltipText(((GetSystemString(3844) $ "/") $ GetSystemString(3854)));
		OlympiadCountText.MoveC(638, 114);
		OlympiadCountText2.SetText("");
		OlympiadCountText2.ClearTooltip();
		OlympiadCountText2.SetTooltipText("");
	}
	LegendNumText.SetText(((((string(packet.nLegendCount) @ GetSystemString(3295)) @ "/ ") $ string(packet.nHeroCount)) @ GetSystemString(3295)));
	LastSesonRankingText.SetText(((((((((((MakeCostString(string(packet.nPrevOlympiadPoint)) @ GetSystemString(1442)) $ " ") $ string(packet.nPrevRank)) @ GetSystemString(1375)) $ ",  ") $ string(packet.nPrevWinCount)) @ GetSystemString(3844)) @ "/") @ string(packet.nPrevLoseCount)) @ GetSystemString(3854)));
	EnemyName01Text.SetText("");
	EnemyName02Text.SetText("");
	EnemyName03Text.SetText("");
	EnemyClass01Icon.HideWindow();
	EnemyClass02Icon.HideWindow();
	EnemyClass03Icon.HideWindow();
	i = 0;
	while((i < 3))
	{
		if((packet.recentMatches.Length <= 0))
		{
			GetTextBoxHandle((((m_Windowname $ ".EnemyName0") $ string((i + 1))) $ "Text")).SetTextColor(getInstanceL2Util().Gray);
			GetTextBoxHandle((((m_Windowname $ ".EnemyName0") $ string((i + 1))) $ "Text")).SetText(GetSystemString(1454));
			GetTextBoxHandle((((m_Windowname $ ".EnemyName0") $ string((i + 1))) $ "Text")).ClearTooltip();
			i++;
			continue;
		}
		if(((packet.recentMatches.Length > i) && (packet.recentMatches[i].sCharName != "")))
		{
			GetTextBoxHandle((((m_Windowname $ ".EnemyName0") $ string((i + 1))) $ "Text")).SetTooltipType("Text");
			if((packet.recentMatches[i].cResult == 0))
			{
				GetTextBoxHandle((((m_Windowname $ ".EnemyName0") $ string((i + 1))) $ "Text")).SetTextColor(GetColor(230, 101, 101, 255));
				GetTextBoxHandle((((m_Windowname $ ".EnemyName0") $ string((i + 1))) $ "Text")).SetTooltipText(GetSystemString(3844));
			}
			else if((packet.recentMatches[i].cResult == 1))
			{
				GetTextBoxHandle((((m_Windowname $ ".EnemyName0") $ string((i + 1))) $ "Text")).SetTextColor(GetColor(0, 170, 255, 255));
				GetTextBoxHandle((((m_Windowname $ ".EnemyName0") $ string((i + 1))) $ "Text")).SetTooltipText(GetSystemString(3854));
			}
			else
			{
				GetTextBoxHandle((((m_Windowname $ ".EnemyName0") $ string((i + 1))) $ "Text")).SetTextColor(GetColor(182, 182, 182, 255));
				GetTextBoxHandle((((m_Windowname $ ".EnemyName0") $ string((i + 1))) $ "Text")).SetTooltipText(GetSystemString(13146));
			}
			GetTextBoxHandle((((m_Windowname $ ".EnemyName0") $ string((i + 1))) $ "Text")).SetText((("Lv." $ string(packet.recentMatches[i].nLevel)) @ ChinaHideName(packet.recentMatches[i].sCharName)));
			GetTextureHandle((((m_Windowname $ ".EnemyClass0") $ string((i + 1))) $ "Icon")).ShowWindow();
			GetTextureHandle((((m_Windowname $ ".EnemyClass0") $ string((i + 1))) $ "Icon")).SetTexture((("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ string(packet.recentMatches[i].nClassID)) $ "_Small"));
			GetTextureHandle((((m_Windowname $ ".EnemyClass0") $ string((i + 1))) $ "Icon")).SetTooltipType("Text");
			GetTextureHandle((((m_Windowname $ ".EnemyClass0") $ string((i + 1))) $ "Icon")).SetTooltipText(GetClassType(packet.recentMatches[i].nClassID));
			i++;
			continue;
		}
		GetTextBoxHandle((((m_Windowname $ ".EnemyName0") $ string((i + 1))) $ "Text")).SetTextColor(getInstanceL2Util().Gray);
		GetTextBoxHandle((((m_Windowname $ ".EnemyName0") $ string((i + 1))) $ "Text")).SetText(GetSystemString(1454));
		GetTextBoxHandle((((m_Windowname $ ".EnemyName0") $ string((i + 1))) $ "Text")).ClearTooltip();
		i++;
	}
	return;
}

function setLikeRadioButton(string buttonName)
{
	if((buttonName == "Top100Button"))
	{
		Top100Button.SetTexture("l2ui_ct1.RankingWnd_SubTabButton_Down", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Down");
		MyRankingButton.SetTexture("l2ui_ct1.RankingWnd_SubTabButton", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Over");
		currentRankingScope = TopN;
		if((TabCtrl2.GetTopIndex() == 1))
		{
			ServerCategoryText.ShowWindow();
			ClassCategoryText.ShowWindow();
			ServerCategoryCombobox.ShowWindow();
			ClassCategoryCombobox.ShowWindow();
		}
	}
	else if((buttonName == "MyRankingButton"))
	{
		MyRankingButton.SetTexture("l2ui_ct1.RankingWnd_SubTabButton_Down", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Down");
		Top100Button.SetTexture("l2ui_ct1.RankingWnd_SubTabButton", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Over");
		currentRankingScope = AroundMe;
		if((TabCtrl2.GetTopIndex() == 1))
		{
			ServerCategoryText.HideWindow();
			ClassCategoryText.HideWindow();
			ServerCategoryCombobox.HideWindow();
			ClassCategoryCombobox.HideWindow();
		}
	}
	return;
}

function setToggleSeasonButton()
{
	if(currentPastSeason)
	{
		SeasonToggleButton.SetTexture("L2UI_ct1.Button.Button_DF", "L2UI_ct1.Button.Button_DF_Click", "L2UI_ct1.Button.Button_DF_Over");
		SeasonToggleButton.SetButtonName(3707);
	}
	else
	{
		SeasonToggleButton.SetTexture("L2UI_ct1.Button.Button_DF", "L2UI_ct1.Button.Button_DF_Click", "L2UI_ct1.Button.Button_DF_Over");
		SeasonToggleButton.SetButtonName(3706);
	}
	return;
}

function setDisableWnd()
{
	disableWnd.ShowWindow();
	RankingWnd(GetScript("RankingWnd")).tabDisable(true);
	Me.SetTimer(1001111, 600);
	return;
}

function hideDisableWnd()
{
	disableWnd.HideWindow();
	RankingWnd(GetScript("RankingWnd")).tabDisable(false);
	Me.KillTimer(1001111);
	return;
}

function API_C_EX_OLYMPIAD_RANKING_INFO(OlympiadRankingType cRankingType, UIEventManager.RankingScope cRankingScope, bool bCurrentSeason, int nClassID, int nWorldID)
{
	local array<byte> stream;
	local UIPacket._C_EX_OLYMPIAD_RANKING_INFO packet;

	packet.cRankingType = int(cRankingType);
	packet.cRankingScope = int(cRankingScope);
	packet.bCurrentSeason = byte(bCurrentSeason);
	if((((int(cRankingType) == 0) || (int(cRankingType) == 1)) && (int(cRankingScope) == 1)))
	{
		packet.nWorldID = GetServerNo();
		packet.nClassID = myClassID();
	}
	else
	{
		packet.nClassID = nClassID;
		packet.nWorldID = nWorldID;
	}
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_OLYMPIAD_RANKING_INFO(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(614, stream);
	Debug(((((("----> Api Call : C_EX_OLYMPIAD_RANKING_INFO" @ string(cRankingType)) @ string(cRankingScope)) @ string(bCurrentSeason)) @ string(nClassID)) @ string(nWorldID)));
	return;
}

function API_C_EX_OLYMPIAD_MY_RANKING_INFO()
{
	local array<byte> stream;

	Class'Interface.UIPacket'.static.RequestUIPacket(613, stream);
	Debug("----> Api Call : C_EX_OLYMPIAD_MY_RANKING_INFO");
	return;
}

function API_C_EX_OLYMPIAD_HERO_AND_LEGEND_INFO()
{
	local array<byte> stream;

	Class'Interface.UIPacket'.static.RequestUIPacket(615, stream);
	Debug("----> Api Call : C_EX_OLYMPIAD_HERO_AND_LEGEND_INFO");
	return;
}
