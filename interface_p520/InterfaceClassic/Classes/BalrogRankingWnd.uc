class BalrogRankingWnd extends UICommonAPI
	dependson(UIPacket);

var WindowHandle Me;
var TextureHandle ServerRichListFrame;
var RichListCtrlHandle Ranking_RichList;
var ButtonHandle ReFresh_btn;
var TextureHandle RankingBg2;
var UserInfo myInfo;
var string m_Windowname;
var bool bIAmRanker;
var int myRankingInList;

function OnRegisterEvent()
{
	RegisterEvent((100000 + 1014));
	RegisterEvent(40);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	Load();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("BalrogRankingWnd");
	ServerRichListFrame = GetTextureHandle("BalrogRankingWnd.ServerRichListFrame");
	Ranking_RichList = GetRichListCtrlHandle("BalrogRankingWnd.Ranking_RichList");
	ReFresh_btn = GetButtonHandle("BalrogRankingWnd.ReFresh_btn");
	RankingBg2 = GetTextureHandle("BalrogRankingWnd.RankingBg2");
	return;
}

function Load()
{
	return;
}

function OnShow()
{
	GetPlayerInfo(myInfo);
	API_C_EX_BALROGWAR_SHOW_RANKING();
	return;
}

function OnHide()
{
	Ranking_RichList.DeleteAllItem();
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "ReFresh_btn":
			OnReFresh_btnClick();
			break;
		default:
			break;
	}
	return;
}

function OnReFresh_btnClick()
{
	API_C_EX_BALROGWAR_SHOW_RANKING();
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_PacketID(1014):
			ParsePacket_S_EX_BALROGWAR_SHOW_RANKING();
			break;
		default:
			break;
	}
	return;
}

function ParsePacket_S_EX_BALROGWAR_SHOW_RANKING()
{
	local UIPacket._S_EX_BALROGWAR_SHOW_RANKING packet;
	local int i, nStartRow;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_BALROGWAR_SHOW_RANKING(packet))
	{
		return;
	}
	Debug((" -->  Decode_S_EX_BALROGWAR_SHOW_RANKING :  " @ string(packet.rankingList.Length)));
	bIAmRanker = false;
	myRankingInList = 0;
	Ranking_RichList.DeleteAllItem();
	if((packet.rankingList.Length > 0))
	{
		GetWindowHandle("BalrogRankingWnd.Disable_Wnd").HideWindow();
		i = 0;
		while((i < packet.rankingList.Length))
		{
			addRanking(packet.rankingList[i].nRank, packet.rankingList[i].sName, packet.rankingList[i].nPoint);
			i++;
		}
		if(bIAmRanker)
		{
			nStartRow = (myRankingInList - 3);
			if((nStartRow > 0))
			{
				if((Ranking_RichList.GetRecordCount() > nStartRow))
				{
					Ranking_RichList.SetStartRow(nStartRow);
				}
			}
		}
	}
	else
	{
		GetWindowHandle("BalrogRankingWnd.Disable_Wnd").ShowWindow();
	}
	return;
}

function addRanking(int nRank, string sName, int nPoint)
{
	local RichListCtrlRowData rowData;
	local string texStr;

	rowData.cellDataList.Length = 3;
	if(((nRank <= 3) && (nRank > 0)))
	{
		if((nRank == 1))
		{
			texStr = "L2UI_ct1.RankingWnd.RankingWnd_1st";
		}
		else if((nRank == 2))
		{
			texStr = "L2UI_ct1.RankingWnd.RankingWnd_2nd";
		}
		else if((nRank == 3))
		{
			texStr = "L2UI_ct1.RankingWnd.RankingWnd_3rd";
		}
		addRichListCtrlTexture(rowData.cellDataList[0].drawitems, texStr, 38, 33, -35, 5);
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, string(nRank), getInstanceL2Util().White, false, -25, 12);
	}
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, sName, GTColor().White, false, 4, -4);
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, MakeCostString(string(nPoint)), GTColor().White, false, 0, 0);
	if((myInfo.Name == sName))
	{
		rowData.sOverlayTex = "L2UI_CT1.RankingWnd.RankingWnd_MyRankBg";
		bIAmRanker = true;
		myRankingInList = Ranking_RichList.GetRecordCount();
	}
	else
	{
		rowData.sOverlayTex = "L2UI_CT1.EmptyBtn";
	}
	rowData.OverlayTexU = 734;
	rowData.OverlayTexV = 45;
	Ranking_RichList.InsertRecord(rowData);
	return;
}

function API_C_EX_BALROGWAR_SHOW_RANKING()
{
	local array<byte> stream;

	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(781, stream);
	Debug("--> C_EX_BALROGWAR_SHOW_RANKING");
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
	m_Windowname="BalrogRankingWnd"
}
