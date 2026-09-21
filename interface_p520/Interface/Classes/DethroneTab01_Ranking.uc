class DethroneTab01_Ranking extends UICommonAPI
	dependson(UIPacket);

const TIMER_ID = 1001112;
const REFRESH_DELAY = 600;

var string m_Windowname;
var WindowHandle Me;
var ButtonHandle Top150Button;
var ButtonHandle MyRankingButton;
var ButtonHandle prvResultButton;
var TextureHandle ServerRichListFrame;
var RichListCtrlHandle Tab_RichList;
var WindowHandle DisableWndList;
var TextBoxHandle List_Empty;
var UIEventManager.RankingScope currentRankingScope;
var bool bCurrentSeason;
var bool bIAmRanker;
var int myRankingInList;
var UserInfo myInfo;

function OnRegisterEvent()
{
	RegisterEvent(9750);
	RegisterEvent((100000 + 951));
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
	Me = GetWindowHandle(m_Windowname);
	Top150Button = GetButtonHandle((m_Windowname $ ".Top150Button"));
	MyRankingButton = GetButtonHandle((m_Windowname $ ".MyRankingButton"));
	prvResultButton = GetButtonHandle((m_Windowname $ ".prvResultButton"));
	ServerRichListFrame = GetTextureHandle((m_Windowname $ ".ServerRichListFrame"));
	Tab_RichList = GetRichListCtrlHandle((m_Windowname $ ".Tab_RichList"));
	DisableWndList = GetWindowHandle((m_Windowname $ ".DisableWndList"));
	List_Empty = GetTextBoxHandle((m_Windowname $ ".DisableWndList.List_Empty"));
	return;
}

function Load()
{
	bCurrentSeason = false;
	return;
}

function OnShow()
{
	Debug(("-Onshow " @ string(GetWindowHandle("DethroneWnd").IsShowWindow())));
	if(GetWindowHandle("DethroneWnd").IsShowWindow())
	{
		showProcess();
	}
	return;
}

function showProcess()
{
	GetPlayerInfo(myInfo);
	OnRefreshButtonClick();
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "Top150Button":
			setLikeRadioButton(Name);
			OnRefreshButtonClick();
			break;
		case "MyRankingButton":
			setLikeRadioButton(Name);
			OnRefreshButtonClick();
			break;
		case "prvResultButton":
			bCurrentSeason = !bCurrentSeason;
			setToggleSeasonButton();
			OnRefreshButtonClick();
			break;
		default:
			break;
	}
	return;
}

function OnRefreshButtonClick()
{
	API_C_EX_DETHRONE_RANKING_INFO();
	DethroneWnd(GetScript("DethroneWnd")).setDisableWnd();
	return;
}

function setLikeRadioButton(string buttonName)
{
	if((buttonName == "Top150Button"))
	{
		Top150Button.SetTexture("l2ui_ct1.RankingWnd_SubTabButton_Down", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Down");
		MyRankingButton.SetTexture("l2ui_ct1.RankingWnd_SubTabButton", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Over");
		currentRankingScope = TopN;
	}
	else if((buttonName == "MyRankingButton"))
	{
		MyRankingButton.SetTexture("l2ui_ct1.RankingWnd_SubTabButton_Down", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Down");
		Top150Button.SetTexture("l2ui_ct1.RankingWnd_SubTabButton", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Over");
		currentRankingScope = AroundMe;
	}
	return;
}

function string sliceName(string nameStr)
{
	local array<string> ArrayStr;

	Split(nameStr, "_", ArrayStr);
	return ArrayStr[0];
}

function AddRankingSystemListItem(int nRanking, int nTotalUser, int nServerID, string PlayerName, string severName, INT64 dethronePoint)
{
	local RichListCtrlRowData rowData;
	local Color applyColor;
	local bool bMe;
	local string percentStr, rankStr;
	local int tW, tH, mW, mH;

	rowData.cellDataList.Length = 4;
	Debug(("myInfo.Name" @ myInfo.Name));
	applyColor = GTColor().White;
	if((isMyServer(nServerID) && (PlayerName == sliceName(DethroneWnd(GetScript("DethroneWnd")).PCName_text.GetText()))))
	{
		bMe = true;
		rowData.sOverlayTex = "L2UI_CT1.RankingWnd.RankingWnd_MyRankBg";
		bIAmRanker = true;
		myRankingInList = Tab_RichList.GetRecordCount();
	}
	else
	{
		rowData.sOverlayTex = "L2UI_CT1.EmptyBtn";
	}
	rowData.OverlayTexU = 734;
	rowData.OverlayTexV = 45;
	rankStr = string(nRanking);
	GetTextSizeDefault(rankStr, tW, tH);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, rankStr, applyColor, false, -(tW / 2), 0);
	percentStr = (stringPer(float(nRanking), float(nTotalUser)) $ "%");
	percentStr = (stringPer(float(nRanking), float(nTotalUser)) $ "%");
	percentStr = (("(" $ percentStr) $ ")");
	GetTextSizeDefault(percentStr, mW, mH);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, percentStr, applyColor, false, (-tW - (mW / 4)), (tH + 2));
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, ((severName $ "_") $ getInstanceL2Util().makeZeroString(2, INT64(getServerExtIdByWorldID(nServerID)))), applyColor, false, 0, 0);
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, PlayerName, applyColor, false, 0, 0);
	AddRichListCtrlString(rowData.cellDataList[3].drawitems, MakeCostString(string(dethronePoint)), applyColor, false, 5, 0);
	rowData.cellDataList[0].szData = rankStr;
	rowData.cellDataList[1].szData = severName;
	rowData.cellDataList[2].szData = PlayerName;
	rowData.cellDataList[3].szData = string(dethronePoint);
	Tab_RichList.InsertRecord(rowData);
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 9750:
			bCurrentSeason = true;
			setLikeRadioButton("Top150Button");
			setToggleSeasonButton();
			break;
		case EV_PacketID(951):
			ParsePacket_S_EX_DETHRONE_RANKING_INFO();
			break;
		default:
			break;
	}
	return;
}

function ParsePacket_S_EX_DETHRONE_RANKING_INFO()
{
	local UIPacket._S_EX_DETHRONE_RANKING_INFO packet;
	local int i;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_DETHRONE_RANKING_INFO(packet))
	{
		return;
	}
	Debug((" -->  Decode_S_EX_DETHRONE_RANKING_INFO :  " @ string(packet.cRankingScope)));
	Debug(("packet.rankInfoList.length : " @ string(packet.rankInfoList.Length)));
	Tab_RichList.DeleteAllItem();
	bIAmRanker = false;
	myRankingInList = 0;
	i = 0;
	while((i < packet.rankInfoList.Length))
	{
		AddRankingSystemListItem(packet.rankInfoList[i].nRank, packet.nTotalRankers, packet.rankInfoList[i].nWorldID, packet.rankInfoList[i].sName, getServerNameByWorldID(packet.rankInfoList[i].nWorldID), packet.rankInfoList[i].nDethronePoint);
		i++;
	}
	rankingListEndHandler();
	return;
}

function rankingListEndHandler()
{
	local int nStartRow;

	if((Tab_RichList.GetRecordCount() > 0))
	{
		DisableWndList.HideWindow();
		if(bIAmRanker)
		{
			nStartRow = (myRankingInList - 3);
			if((nStartRow > 0))
			{
				if((Tab_RichList.GetRecordCount() > nStartRow))
				{
					Tab_RichList.SetStartRow(nStartRow);
				}
			}
		}
	}
	else
	{
		DisableWndList.ShowWindow();
		List_Empty.SetText(GetSystemString(13023));
	}
	Tab_RichList.SetFocus();
	return;
}

function setToggleSeasonButton()
{
	if(bCurrentSeason)
	{
		prvResultButton.SetButtonName(3707);
	}
	else
	{
		prvResultButton.SetButtonName(3706);
	}
	return;
}

function API_C_EX_DETHRONE_RANKING_INFO()
{
	local array<byte> stream;
	local UIPacket._C_EX_DETHRONE_RANKING_INFO packet;

	packet.bCurrentSeason = byte(bCurrentSeason);
	packet.cRankingScope = int(currentRankingScope);
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_DETHRONE_RANKING_INFO(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(716, stream);
	Debug((("----> Api Call : C_EX_DETHRONE_RANKING_INFO " @ string(packet.cRankingScope)) @ string(packet.bCurrentSeason)));
	return;
}
