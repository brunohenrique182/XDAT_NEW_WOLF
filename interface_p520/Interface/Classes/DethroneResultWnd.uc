class DethroneResultWnd extends UICommonAPI
	dependson(UIPacket);

var WindowHandle Me;
var WindowHandle Result_wnd;
var TextBoxHandle OccupyName_txt;
var TextureHandle NowRulerServerMark_tex;
var TextBoxHandle OccupyTitle_txt;
var TextureHandle OccupyBG_tex;
var RichListCtrlHandle PointResult_RichList;
var TextBoxHandle PointResultTitle_txt;
var TextureHandle PointResultListBG_tex;
var TextureHandle PointResultBG_tex;
var TextBoxHandle AdenaTotalNuM_txt;
var TextBoxHandle ServerRewardNum_txt;
var TextBoxHandle AdenaTotalTitle_txt;
var TextBoxHandle ServerRewardTitle_txt;
var TextureHandle AdenaTotalBG_tex;
var TextBoxHandle ResultDscrp_txt;
var TextureHandle ResultDscrpBG_tex;
var WindowHandle Reward_wnd;
var ButtonHandle Reward_Btn;
var TextBoxHandle My_Ranking_txt;
var RichListCtrlHandle MyReward_ItemRichListCtrl;
var TextureHandle MyRewardItemRichListCtrlBG_tex;
var TextBoxHandle Server_Ranking_txt;
var RichListCtrlHandle ServerReward_ItemRichListCtrl;
var TextureHandle ServerRewardItemRichListCtrlBG_tex;
var TextBoxHandle My_RankingTitle_txt;
var TextBoxHandle Server_RankingTitle_txt;
var TextBoxHandle My_RewardTitle_txt;
var TextBoxHandle Server_RewardTitle_txt;
var TextureHandle My_RewardBG_tex;
var TextureHandle Server_RewardBG_tex;
var UIControlNeedItemList myRewardNeedItemList;
var UIControlNeedItemList serverRewardNeedItemList;

function OnRegisterEvent()
{
	RegisterEvent((100000 + 957));
	RegisterEvent((100000 + 958));
	RegisterEvent(9750);
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
	Me = GetWindowHandle("DethroneResultWnd");
	Result_wnd = GetWindowHandle("DethroneResultWnd.Result_wnd");
	OccupyName_txt = GetTextBoxHandle("DethroneResultWnd.Result_wnd.OccupyName_txt");
	NowRulerServerMark_tex = GetTextureHandle("DethroneResultWnd.Result_wnd.NowRulerServerMark_tex");
	OccupyTitle_txt = GetTextBoxHandle("DethroneResultWnd.Result_wnd.OccupyTitle_txt");
	OccupyBG_tex = GetTextureHandle("DethroneResultWnd.Result_wnd.OccupyBG_tex");
	PointResult_RichList = GetRichListCtrlHandle("DethroneResultWnd.Result_wnd.PointResult_RichList");
	PointResultTitle_txt = GetTextBoxHandle("DethroneResultWnd.Result_wnd.PointResultTitle_txt");
	PointResultListBG_tex = GetTextureHandle("DethroneResultWnd.Result_wnd.PointResultListBG_tex");
	PointResultBG_tex = GetTextureHandle("DethroneResultWnd.Result_wnd.PointResultBG_tex");
	AdenaTotalNuM_txt = GetTextBoxHandle("DethroneResultWnd.Result_wnd.AdenaTotalNuM_txt");
	ServerRewardNum_txt = GetTextBoxHandle("DethroneResultWnd.Result_wnd.ServerRewardNum_txt");
	AdenaTotalTitle_txt = GetTextBoxHandle("DethroneResultWnd.Result_wnd.AdenaTotalTitle_txt");
	ServerRewardTitle_txt = GetTextBoxHandle("DethroneResultWnd.Result_wnd.ServerRewardTitle_txt");
	AdenaTotalBG_tex = GetTextureHandle("DethroneResultWnd.Result_wnd.AdenaTotalBG_tex");
	ResultDscrp_txt = GetTextBoxHandle("DethroneResultWnd.Result_wnd.ResultDscrp_txt");
	ResultDscrpBG_tex = GetTextureHandle("DethroneResultWnd.Result_wnd.ResultDscrpBG_tex");
	Reward_wnd = GetWindowHandle("DethroneResultWnd.Reward_wnd");
	Reward_Btn = GetButtonHandle("DethroneResultWnd.Reward_wnd.Reward_Btn");
	My_Ranking_txt = GetTextBoxHandle("DethroneResultWnd.Reward_wnd.My_Ranking_txt");
	MyReward_ItemRichListCtrl = GetRichListCtrlHandle("DethroneResultWnd.Reward_wnd.MyReward_ItemRichListCtrl");
	MyRewardItemRichListCtrlBG_tex = GetTextureHandle("DethroneResultWnd.Reward_wnd.MyRewardItemRichListCtrlBG_tex");
	Server_Ranking_txt = GetTextBoxHandle("DethroneResultWnd.Reward_wnd.Server_Ranking_txt");
	ServerReward_ItemRichListCtrl = GetRichListCtrlHandle("DethroneResultWnd.Reward_wnd.ServerReward_ItemRichListCtrl");
	ServerRewardItemRichListCtrlBG_tex = GetTextureHandle("DethroneResultWnd.Reward_wnd.ServerRewardItemRichListCtrlBG_tex");
	My_RankingTitle_txt = GetTextBoxHandle("DethroneResultWnd.Reward_wnd.My_RankingTitle_txt");
	Server_RankingTitle_txt = GetTextBoxHandle("DethroneResultWnd.Reward_wnd.Server_RankingTitle_txt");
	My_RewardTitle_txt = GetTextBoxHandle("DethroneResultWnd.Reward_wnd.My_RewardTitle_txt");
	Server_RewardTitle_txt = GetTextBoxHandle("DethroneResultWnd.Reward_wnd.Server_RewardTitle_txt");
	My_RewardBG_tex = GetTextureHandle("DethroneResultWnd.Reward_wnd.My_RewardBG_tex");
	Server_RewardBG_tex = GetTextureHandle("DethroneResultWnd.Reward_wnd.Server_RewardBG_tex");
	PointResult_RichList.SetSelectedSelTooltip(false);
	PointResult_RichList.SetAppearTooltipAtMouseX(true);
	PointResult_RichList.SetSelectable(false);
	Reward_Btn.SetTooltipType("text");
	Reward_Btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13790), 270));
	return;
}

function Load()
{
	myRewardNeedItemList = new Class'Interface.UIControlNeedItemList';
	myRewardNeedItemList.DelegateOnUpdateItem = DelegateOnUpdateItem;
	myRewardNeedItemList.SetRichListControler(MyReward_ItemRichListCtrl);
	serverRewardNeedItemList = new Class'Interface.UIControlNeedItemList';
	serverRewardNeedItemList.DelegateOnUpdateItem = DelegateOnUpdateItem;
	serverRewardNeedItemList.SetRichListControler(ServerReward_ItemRichListCtrl);
	return;
}

function OnShow()
{
	API_C_EX_DETHRONE_PREV_SEASON_INFO();
	return;
}

function DelegateOnUpdateItem()
{
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 9750:
			initControl();
			break;
		case EV_PacketID(957):
			ParsePacket_S_EX_DETHRONE_PREV_SEASON_INFO();
			break;
		case EV_PacketID(958):
			ParsePacket_S_EX_DETHRONE_GET_REWARD();
			break;
		default:
			break;
	}
	return;
}

function initControl()
{
	PointResult_RichList.DeleteAllItem();
	NowRulerServerMark_tex.SetTexture("");
	OccupyName_txt.SetText("");
	AdenaTotalNuM_txt.SetText("");
	ServerRewardNum_txt.SetText("");
	My_Ranking_txt.SetText("");
	Server_Ranking_txt.SetText("");
	MyReward_ItemRichListCtrl.DeleteAllItem();
	ServerReward_ItemRichListCtrl.DeleteAllItem();
	Reward_Btn.DisableWindow();
	return;
}

function ParsePacket_S_EX_DETHRONE_GET_REWARD()
{
	local UIPacket._S_EX_DETHRONE_GET_REWARD packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_DETHRONE_GET_REWARD(packet))
	{
		return;
	}
	Debug((" -->  Decode_S_EX_DETHRONE_GET_REWARD : " @ string(packet.nResult)));
	if((packet.nResult > 0))
	{
		Reward_Btn.DisableWindow();
		AddSystemMessage(5276);
	}
	API_C_EX_DETHRONE_PREV_SEASON_INFO();
	return;
}

function ParsePacket_S_EX_DETHRONE_PREV_SEASON_INFO()
{
	local UIPacket._S_EX_DETHRONE_PREV_SEASON_INFO packet;
	local int i;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_DETHRONE_PREV_SEASON_INFO(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_DETHRONE_PREV_SEASON_INFO : ");
	PointResult_RichList.DeleteAllItem();
	Debug(("packet.pointList.length" @ string(packet.pointList.Length)));
	i = 0;
	while((i < packet.pointList.Length))
	{
		Debug(("packet.pointList[i].nWorldID" @ string(packet.pointList[i].nWorldID)));
		Debug(("packet.pointList[i].nPoint" @ string(packet.pointList[i].nPoint)));
		AddDethronePointStateListItem((i + 1), packet.pointList[i].nWorldID, packet.pointList[i].nPoint);
		i++;
	}
	NowRulerServerMark_tex.SetTexture(GetServerMarkNameSmall(packet.nOccupyingWorldID));
	OccupyName_txt.SetText(packet.sConquerorName);
	AdenaTotalNuM_txt.SetText(MakeCostString(string(packet.nTotalSoulBead)));
	ServerRewardNum_txt.SetText(MakeCostString(string(packet.nOccupyingServerReward)));
	if((packet.nRank == 0))
	{
		My_Ranking_txt.SetText(MakeFullSystemMsg(GetSystemMessage(4553), " - "));
		Server_Ranking_txt.SetText(" - ");
	}
	else
	{
		My_Ranking_txt.SetText(((((MakeFullSystemMsg(GetSystemMessage(4553), string(packet.nRank)) $ " (") $ stringPer(float(packet.nRank), float(packet.nTotalRankers))) $ "%") $ ")"));
		Server_Ranking_txt.SetText(getServerNameByWorldID(packet.nOccupyingWorldID));
	}
	if((packet.personalRewardList.Length == 0))
	{
		GetTextBoxHandle("DethroneResultWnd.Result_wnd.MyNonReward_text").ShowWindow();
	}
	else
	{
		GetTextBoxHandle("DethroneResultWnd.Result_wnd.MyNonReward_text").HideWindow();
	}
	if((packet.serverRewardList.Length == 0))
	{
		GetTextBoxHandle("DethroneResultWnd.Result_wnd.ServerNonReward_text").ShowWindow();
	}
	else
	{
		GetTextBoxHandle("DethroneResultWnd.Result_wnd.ServerNonReward_text").HideWindow();
	}
	myRewardNeedItemList.StartNeedItemList(2);
	myRewardNeedItemList.SetHideMyNum(true);
	i = 0;
	while((i < packet.personalRewardList.Length))
	{
		myRewardNeedItemList.AddNeedItemClassID(packet.personalRewardList[i].nItemClassID, packet.personalRewardList[i].nAmount);
		Debug(("1 id-> " @ string(packet.personalRewardList[i].nItemClassID)));
		Debug(("1 count-> " @ string(packet.personalRewardList[i].nAmount)));
		i++;
	}
	myRewardNeedItemList.SetBuyNum(INT64(1));
	serverRewardNeedItemList.StartNeedItemList(2);
	serverRewardNeedItemList.SetHideMyNum(true);
	i = 0;
	while((i < packet.serverRewardList.Length))
	{
		Debug(("2 id-> " @ string(packet.serverRewardList[i].nItemClassID)));
		Debug(("2 count-> " @ string(packet.serverRewardList[i].nAmount)));
		serverRewardNeedItemList.AddNeedItemClassID(packet.serverRewardList[i].nItemClassID, packet.serverRewardList[i].nAmount);
		i++;
	}
	serverRewardNeedItemList.SetBuyNum(INT64(1));
	Debug(("packet.bHasReward " @ string(packet.bHasReward)));
	if(((int(packet.bHasReward) > 0) && !Class'NWindow.UIDATA_PLAYER'.static.IsInDethrone()))
	{
		Reward_Btn.EnableWindow();
	}
	else
	{
		Reward_Btn.DisableWindow();
	}
	return;
}

function AddDethronePointStateListItem(int nRank, int ServerID, INT64 dethronePoint)
{
	local RichListCtrlRowData rowData;
	local Color applyColor;
	local bool bMe;
	local ServerInfoUIData ServerInfo;

	rowData.cellDataList.Length = 2;
	bMe = isMyServer(ServerID);
	if(bMe)
	{
		applyColor = GTColor().Yellow;
	}
	else
	{
		applyColor = GTColor().White;
	}
	Class'NWindow.UIDataManager'.static.GetServerInfo(ServerID, ServerInfo);
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems, GetServerMarkNameSmall(ServerID), 30, 30);
	if((nRank == 1))
	{
		addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_EPIC.ClanWnd.ClanWnd_MasterIcon", 21, 19, 0, 4);
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, ServerInfo.ServerName, applyColor, false, 2, 4);
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, ServerInfo.ServerName, applyColor, false, 0, 8);
	}
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, MakeCostString(string(dethronePoint)), applyColor, false, 5, 0);
	rowData.cellDataList[0].szData = ServerInfo.ServerName;
	rowData.cellDataList[1].szData = string(dethronePoint);
	rowData.cellDataList[0].drawitems[(rowData.cellDataList[0].drawitems.Length - 1)].nReservedTooltipID = 99999;
	rowData.cellDataList[0].drawitems[(rowData.cellDataList[0].drawitems.Length - 1)].TooltipDesc = GetSystemString(13700);
	rowData.szReserved = ServerInfo.ServerName;
	PointResult_RichList.InsertRecord(rowData);
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "Reward_Btn":
			OnReward_BtnClick();
			break;
		case "ok_Btn":
			Me.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function OnReward_BtnClick()
{
	API_C_EX_DETHRONE_GET_REWARD();
	return;
}

function API_C_EX_DETHRONE_PREV_SEASON_INFO()
{
	local array<byte> stream;

	Class'Interface.UIPacket'.static.RequestUIPacket(721, stream);
	Debug("----> Api Call : C_EX_DETHRONE_PREV_SEASON_INFO ");
	return;
}

function API_C_EX_DETHRONE_GET_REWARD()
{
	local array<byte> stream;

	Class'Interface.UIPacket'.static.RequestUIPacket(722, stream);
	Reward_Btn.DisableWindow();
	Debug("----> Api Call : C_EX_DETHRONE_GET_REWARD ");
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}
