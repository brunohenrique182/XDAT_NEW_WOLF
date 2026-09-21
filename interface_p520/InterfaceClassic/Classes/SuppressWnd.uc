class SuppressWnd extends UICommonAPI
	dependson(UIPacket);

var WindowHandle Me;
var RichListCtrlHandle SuppressList_ListCtrl;
var TextureHandle SuppressZoneImg_tex;
var TextureHandle SuppressZoneImgEvent_tex;
var TextureHandle SuppressZoneEventIcon_tex;
var TextBoxHandle SuppressZoneTitle_txt;
var ButtonHandle SuppressRefresh_btn;
var ButtonHandle SuppressKey_btn;
var TextBoxHandle SuppressKeyDesc_txt;
var ButtonHandle SuppressTeleport_btn;
var TextBoxHandle SuppressTeleportDesc_txt;
var TextBoxHandle SuppressRankingTitle_txt;
var TextBoxHandle SuppressMyRankingTitle_txt;
var TextBoxHandle SuppressMyPointTitle_txt;
var TextBoxHandle SuppressMyRanking_txt;
var TextBoxHandle SuppressMyPoint_txt;
var RichListCtrlHandle SuppressRankingList_ListCtrl;
var string m_Windowname;
var int clientStartSec;
var int currentTimeSec;
var L2UITime L2UITime;
var int serverStartTime;
var array<SubjugationData> SubjugationDataArray;
var bool bScriptLoaded;
var int currentTeleportID;
var int currentSubjugationID;
var int lastSelectedListIndex;
//var delegate<SortByRankingDelegate> __SortByRankingDelegate__Delegate;

function OnRegisterEvent()
{
	RegisterEvent((100000 + 937));
	RegisterEvent((100000 + 938));
	RegisterEvent(10230);
	RegisterEvent(40);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	SuppressList_ListCtrl.SetSelectedSelTooltip(false);
	SuppressRankingList_ListCtrl.SetSelectedSelTooltip(false);
	SuppressRankingList_ListCtrl.SetAppearTooltipAtMouseX(true);
	SuppressRankingList_ListCtrl.SetSelectable(false);
	SetPopupScript();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("SuppressWnd");
	SuppressList_ListCtrl = GetRichListCtrlHandle("SuppressWnd.SuppressList_ListCtrl");
	SuppressZoneImg_tex = GetTextureHandle("SuppressWnd.SuppressZoneImg_tex");
	SuppressZoneImgEvent_tex = GetTextureHandle("SuppressWnd.SuppressZoneImgEvent_tex");
	SuppressZoneEventIcon_tex = GetTextureHandle("SuppressWnd.SuppressZoneEventIcon_tex");
	SuppressZoneTitle_txt = GetTextBoxHandle("SuppressWnd.SuppressZoneTitle_txt");
	SuppressRefresh_btn = GetButtonHandle("SuppressWnd.SuppressRefresh_btn");
	SuppressKey_btn = GetButtonHandle("SuppressWnd.SuppressKey_btn");
	SuppressKeyDesc_txt = GetTextBoxHandle("SuppressWnd.SuppressKeyDesc_txt");
	SuppressTeleportDesc_txt = GetTextBoxHandle("SuppressWnd.SuppressTeleportDesc_txt");
	SuppressTeleport_btn = GetButtonHandle("SuppressWnd.SuppressTeleport_btn");
	SuppressRankingTitle_txt = GetTextBoxHandle("SuppressWnd.SuppressRankingTitle_txt");
	SuppressMyRankingTitle_txt = GetTextBoxHandle("SuppressWnd.SuppressMyRankingTitle_txt");
	SuppressMyPointTitle_txt = GetTextBoxHandle("SuppressWnd.SuppressMyPointTitle_txt");
	SuppressMyRanking_txt = GetTextBoxHandle("SuppressWnd.SuppressMyRanking_txt");
	SuppressMyPoint_txt = GetTextBoxHandle("SuppressWnd.SuppressMyPoint_txt");
	SuppressRankingList_ListCtrl = GetRichListCtrlHandle("SuppressWnd.SuppressRankingList_ListCtrl");
	lastSelectedListIndex = -1;
	return;
}

function OnShow()
{
	if(GetWindowHandle("SuppressDrawWnd").IsShowWindow())
	{
		GetWindowHandle("SuppressDrawWnd").HideWindow();
	}
	setLoadScriptData();
	refreshList();
	return;
}

function OnHide()
{
	if(GetWindowHandle((m_Windowname $ ".UIControlDialogAsset")).IsShowWindow())
	{
		GetPopupExpandScript().Hide();
	}
	return;
}

function refreshList()
{
	addListByScript();
	API_C_EX_SUBJUGATION_LIST();
	return;
}

function setLoadScriptData()
{
	if(!bScriptLoaded)
	{
		bScriptLoaded = true;
		GetSubjugationList(SubjugationDataArray);
	}
	return;
}

function addListByScript()
{
	local int i;

	SuppressList_ListCtrl.DeleteAllItem();
	i = 0;
	while((i < SubjugationDataArray.Length))
	{
		addRichListData(true, SubjugationDataArray[i], 0, 0, -1);
		i++;
	}
	if((lastSelectedListIndex > -1))
	{
		SuppressList_ListCtrl.SetSelectedIndex(lastSelectedListIndex, true);
	}
	else
	{
		SuppressList_ListCtrl.SetSelectedIndex(0, true);
		OnClickListCtrlRecord("SuppressList_ListCtrl");
	}
	return;
}

function SubjugationData getSubjugationDataByID(int Id)
{
	local int i;
	local SubjugationData emptyData;

	i = 0;
	while((i < SubjugationDataArray.Length))
	{
		if((SubjugationDataArray[i].Id == Id))
		{
			return SubjugationDataArray[i];
		}
		i++;
	}
	return emptyData;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "SuppressRefresh_btn":
			OnSuppressRefresh_btnClick();
			break;
		case "SuppressKey_btn":
			OnSuppressKey_btnClick();
			break;
		case "SuppressTeleport_btn":
			OnSuppressTeleport_btnClick();
			break;
		case "HelpWnd_Btn":
			ExecuteEvent(1210, "61");
			break;
		default:
			break;
	}
	return;
}

function OnSuppressRefresh_btnClick()
{
	refreshList();
	return;
}

function OnSuppressKey_btnClick()
{
	SuppressDrawWnd(GetScript("SuppressDrawWnd")).API_C_EX_SUBJUGATION_GACHA_UI(currentSubjugationID);
	Me.HideWindow();
	return;
}

function OnSuppressTeleport_btnClick()
{
	ShowPopup();
	return;
}

event OnDBClickListCtrlRecord(string ListCtrlID)
{
	switch(ListCtrlID)
	{
		case "SuppressList_ListCtrl":
			OnSuppressKey_btnClick();
			break;
		default:
			break;
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_PacketID(937):
			ParsePacket_S_EX_SUBJUGATION_LIST();
			break;
		case EV_PacketID(938):
			ParsePacket_S_EX_SUBJUGATION_RANKING();
			break;
		case 10230:
			setCurrentserverTime(param);
			break;
		case 40:
			bScriptLoaded = false;
			clientStartSec = 0;
			currentTimeSec = 0;
			lastSelectedListIndex = -1;
			break;
		default:
			break;
	}
	return;
}

function setSelectListByID(int Id)
{
	local int i;
	local RichListCtrlRowData tempRowData;

	i = 0;
	while((i < SuppressList_ListCtrl.GetRecordCount()))
	{
		SuppressList_ListCtrl.GetRec(i, tempRowData);
		if((INT64(Id) == tempRowData.nReserved1))
		{
			SuppressList_ListCtrl.SetSelectedIndex(i, true);
			break;
		}
		i++;
	}
	return;
}

function addRichListData(bool bAddList, SubjugationData sjData, int subjugationPoint, int gachaPoint, int nRemainedPeriodicGachaPoint)
{
	local RichListCtrlRowData rowData, tempRowData;
	local string Title;
	local int i, W, h;
	local float statusPercent;
	local bool bIsEvent, bIsCycle, bEnableLevel, bWaitState;
	local int nDisableState;
	local UserInfo UserInfo;
	local Color FontColor;
	local string timeStr;

	rowData.szReserved = sjData.Desc;
	bIsCycle = isInPeroid(sjData.Cycle);
	bIsEvent = isInPeroid(sjData.HotTimes);
	GetPlayerInfo(UserInfo);
	if(((sjData.MinLevel <= UserInfo.nLevel) && (sjData.MaxLevel >= UserInfo.nLevel)))
	{
		bEnableLevel = true;
		FontColor = GTColor().White;
	}
	else
	{
		FontColor = GTColor().Gray;
	}
	rowData.cellDataList.Length = 3;
	rowData.nReserved1 = INT64(sjData.Id);
	rowData.nReserved2 = INT64(boolToNum(bIsEvent));
	if((bEnableLevel && bIsCycle))
	{
		rowData.nReserved3 = INT64(1);
	}
	else
	{
		rowData.nReserved3 = INT64(0);
	}
	rowData.cellDataList[1].szData = sjData.Banner;
	Title = (((((sjData.Name $ " (Lv.") $ string(sjData.MinLevel)) $ "~") $ string(sjData.MaxLevel)) $ ")");
	rowData.cellDataList[0].szData = (((((sjData.Name $ "\\n(Lv.") $ string(sjData.MinLevel)) $ "~") $ string(sjData.MaxLevel)) $ ")");
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, Title, FontColor, false, 17, 14, "hs10");
	if(bIsEvent)
	{
		addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_EPIC.SuppressWnd.SuppressHotTimeIcon", 61, 19, 2, -2);
		addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_CT1.EmptyBtn", 61, 19, -61, 0);
		rowData.cellDataList[0].drawitems[(rowData.cellDataList[0].drawitems.Length - 1)].nReservedTooltipID = 99999;
		rowData.cellDataList[0].drawitems[(rowData.cellDataList[0].drawitems.Length - 1)].TooltipDesc = GetSystemString(13700);
	}
	if(!bEnableLevel)
	{
		addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_EPIC.SuppressWnd.SuppressLockIcon", 18, 24, 2, -2);
		nDisableState = 1;
	}
	if((nRemainedPeriodicGachaPoint >= sjData.MaxPeriodicGachaPoint))
	{
		nDisableState = 1;
	}
	timeStr = GetRemainTimeString(sjData.Cycle);
	if((timeStr == GetSystemString(3526)))
	{
		bWaitState = true;
		nDisableState = 1;
	}
	statusPercent = ((float(subjugationPoint) / float(sjData.MaxSubjugationPoint)) * 100.0000000);
	if(bEnableLevel)
	{
		if(bWaitState)
		{
			statusPercent = 0.0000000;
			AddRichListCtrlStatusInfo(rowData.cellDataList[0].drawitems, 312, 15, 15, 6, true, statusPercent, 0.0000000, (string(statusPercent) $ "%"), nDisableState, , FontColor);
		}
		else if((subjugationPoint == 0))
		{
			if((nRemainedPeriodicGachaPoint == 0))
			{
				AddRichListCtrlStatusInfo(rowData.cellDataList[0].drawitems, 312, 15, 15, 6, true, 100.0000000, 0.0000000, GetSystemString(898), nDisableState, , FontColor);
			}
			else
			{
				AddRichListCtrlStatusInfo(rowData.cellDataList[0].drawitems, 312, 15, 15, 6, true, statusPercent, 0.0000000, GetSystemString(13484), nDisableState, , FontColor);
			}
		}
		else
		{
			AddRichListCtrlStatusInfo(rowData.cellDataList[0].drawitems, 312, 15, 15, 6, true, statusPercent, 0.0000000, (string(statusPercent) $ "%"), 0, , FontColor);
		}
	}
	else
	{
		AddRichListCtrlStatusInfo(rowData.cellDataList[0].drawitems, 312, 15, 15, 6, true, statusPercent, 0.0000000, GetSystemString(3587), nDisableState, , FontColor);
	}
	rowData.cellDataList[0].nReserved1 = gachaPoint;
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_EPIC.SuppressWnd.SuppressKeyIcon", 36, 41, 0, -20);
	if((gachaPoint > 0))
	{
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, ("x" $ string(gachaPoint)), GTColor().Yellow, false, 2, 18, "hs10");
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, ("x" $ string(gachaPoint)), FontColor, false, 2, 18);
	}
	rowData.cellDataList[2].nReserved1 = sjData.TeleportID;
	if((nRemainedPeriodicGachaPoint == -1))
	{
		nRemainedPeriodicGachaPoint = sjData.MaxPeriodicGachaPoint;
	}
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, ((string(nRemainedPeriodicGachaPoint) $ "/") $ string(sjData.MaxPeriodicGachaPoint)), FontColor, false, 0, 10);
	GetTextSize(((string(nRemainedPeriodicGachaPoint) $ "/") $ string(sjData.MaxPeriodicGachaPoint)), "GameDefault", W, h);
	addRichListCtrlTexture(rowData.cellDataList[1].drawitems, "L2UI_CT1.EmptyBtn", W, 32, -W, -10);
	rowData.cellDataList[1].drawitems[(rowData.cellDataList[1].drawitems.Length - 1)].nReservedTooltipID = 99999;
	rowData.cellDataList[1].drawitems[(rowData.cellDataList[1].drawitems.Length - 1)].TooltipDesc = GetSystemString(13698);
	if(bWaitState)
	{
		addRichListCtrlTexture(rowData.cellDataList[2].drawitems, "L2UI_CH3.FishingWnd.fishing_clockicon", 16, 16, 0, 0);
	}
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, timeStr, FontColor, false, 0, 2);
	if(bAddList)
	{
		SuppressList_ListCtrl.InsertRecord(rowData);
	}
	else
	{
		i = 0;
		while((i < SuppressList_ListCtrl.GetRecordCount()))
		{
			SuppressList_ListCtrl.GetRec(i, tempRowData);
			if((INT64(sjData.Id) == tempRowData.nReserved1))
			{
				SuppressList_ListCtrl.ModifyRecord(i, rowData);
				break;
			}
			i++;
		}
	}
	return;
}

function API_C_EX_SUBJUGATION_LIST()
{
	local array<byte> stream;

	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(704, stream);
	Debug("--> C_EX_SUBJUGATION_LIST");
	return;
}

function ParsePacket_S_EX_SUBJUGATION_LIST()
{
	local UIPacket._S_EX_SUBJUGATION_LIST packet;
	local int i;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_SUBJUGATION_LIST(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_SUBJUGATION_LIST :  ");
	i = 0;
	while((i < packet.vInfos.Length))
	{
		Debug(("-nID" @ string(packet.vInfos[i].nID)));
		Debug(("-nPoint" @ string(packet.vInfos[i].nPoint)));
		Debug(("-nGachaPoint" @ string(packet.vInfos[i].nGachaPoint)));
		Debug(("-nRemainedPeriodicGachaPoint" @ string(packet.vInfos[i].nRemainedPeriodicGachaPoint)));
		addRichListData(false, getSubjugationDataByID(packet.vInfos[i].nID), packet.vInfos[i].nPoint, packet.vInfos[i].nGachaPoint, packet.vInfos[i].nRemainedPeriodicGachaPoint);
		i++;
	}
	SuppressList_ListCtrl.SetSelectedIndex(SuppressList_ListCtrl.GetSelectedIndex(), true);
	OnClickListCtrlRecord("SuppressList_ListCtrl");
	return;
}

function API_C_EX_SUBJUGATION_RANKING(int nID)
{
	local array<byte> stream;
	local UIPacket._C_EX_SUBJUGATION_RANKING packet;

	packet.nID = nID;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_SUBJUGATION_RANKING(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(705, stream);
	return;
}

function ParsePacket_S_EX_SUBJUGATION_RANKING()
{
	local UIPacket._S_EX_SUBJUGATION_RANKING packet;
	local int i;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_SUBJUGATION_RANKING(packet))
	{
		return;
	}
	if((packet.nRank == 0))
	{
		SuppressMyRanking_txt.SetText(GetSystemString(27));
	}
	else
	{
		SuppressMyRanking_txt.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(packet.nRank)));
	}
	SuppressMyPoint_txt.SetText(MakeCostString(string(packet.nPoint)));
	SuppressRankingList_ListCtrl.DeleteAllItem();
	// packet.vRankers.Sort(SortByRankingDelegate);   // array.Sort() unsupported by this compiler
	i = 0;
	while((i < packet.vRankers.Length))
	{
		addRichListRanking(packet.vRankers[i].nRank, ChinaHideName(packet.vRankers[i].sUserName), packet.vRankers[i].nPoint);
		i++;
	}
	return;
}

delegate int SortByRankingDelegate(UIPacket._PkSubjugationRanker a1, UIPacket._PkSubjugationRanker a2)
{
	if((a1.nRank > a2.nRank))
	{
		return -1;
	}
	return 0;
}

function addRichListRanking(int nRanking, string Title, int nPoint)
{
	local RichListCtrlRowData rowData;
	local string texStr;
	local ItemInfo Info;
	local SubjugationData sjData;
	local int i;

	rowData.cellDataList.Length = 3;
	sjData = getSubjugationDataByID(currentSubjugationID);
	if((nRanking == 1))
	{
		texStr = "L2UI_ct1.RankingWnd.RankingWnd_1st";
		i = 0;
		while((i < sjData.RewardRank1.Length))
		{
			if((i == 0))
			{
				Info = GetItemInfoByClassID(sjData.RewardRank1[i]);
				i++;
				continue;
			}
			if((i == 1))
			{
				Info.ItemNum = INT64(sjData.RewardRank1[i]);
			}
			i++;
		}
	}
	else if((nRanking == 2))
	{
		texStr = "L2UI_ct1.RankingWnd.RankingWnd_2nd";
		i = 0;
		while((i < sjData.RewardRank2.Length))
		{
			if((i == 0))
			{
				Info = GetItemInfoByClassID(sjData.RewardRank2[i]);
				i++;
				continue;
			}
			if((i == 1))
			{
				Info.ItemNum = INT64(sjData.RewardRank2[i]);
			}
			i++;
		}
	}
	else if((nRanking == 3))
	{
		texStr = "L2UI_ct1.RankingWnd.RankingWnd_3rd";
		i = 0;
		while((i < sjData.RewardRank3.Length))
		{
			if((i == 0))
			{
				Info = GetItemInfoByClassID(sjData.RewardRank3[i]);
				i++;
				continue;
			}
			if((i == 1))
			{
				Info.ItemNum = INT64(sjData.RewardRank3[i]);
			}
			i++;
		}
	}
	else if((nRanking == 4))
	{
		texStr = "L2UI_EPIC.RankingWnd.RankingWnd_4th";
		i = 0;
		while((i < sjData.RewardRank4.Length))
		{
			if((i == 0))
			{
				Info = GetItemInfoByClassID(sjData.RewardRank4[i]);
				i++;
				continue;
			}
			if((i == 1))
			{
				Info.ItemNum = INT64(sjData.RewardRank4[i]);
			}
			i++;
		}
	}
	else if((nRanking == 5))
	{
		texStr = "L2UI_EPIC.RankingWnd.RankingWnd_5th";
		i = 0;
		while((i < sjData.RewardRank5.Length))
		{
			if((i == 0))
			{
				Info = GetItemInfoByClassID(sjData.RewardRank5[i]);
				i++;
				continue;
			}
			if((i == 1))
			{
				Info.ItemNum = INT64(sjData.RewardRank5[i]);
			}
			i++;
		}
	}
	if((Info.ItemNum > INT64(1)))
	{
		Info.bShowCount = true;
	}
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems, texStr, 38, 33, 10, 10);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, Title, GetColor(254, 215, 160, 255), false, 0, 12);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, MakeCostString(string(nPoint)), GTColor().White, true, 0, 0);
	addRichListCtrlTexture(rowData.cellDataList[2].drawitems, "L2UI_EPIC.SuppressWnd.SuppressItem1st_Frame", 36, 36, 0, 12);
	AddRichListCtrlItem(rowData.cellDataList[2].drawitems, Info, 32, 32, -34, 2);
	SuppressRankingList_ListCtrl.InsertRecord(rowData);
	return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
	local RichListCtrlRowData rowData;

	if((ListCtrlID == "SuppressList_ListCtrl"))
	{
		lastSelectedListIndex = SuppressList_ListCtrl.GetSelectedIndex();
		SuppressList_ListCtrl.GetSelectedRec(rowData);
		currentTeleportID = rowData.cellDataList[2].nReserved1;
		setSuppressPage(numToBool(int(rowData.nReserved2)), numToBool(int(rowData.nReserved3)), rowData.cellDataList[0].szData, rowData.cellDataList[0].nReserved1, rowData.cellDataList[1].szData);
		SuppressRankingList_ListCtrl.DeleteAllItem();
		SuppressMyRanking_txt.SetText(GetSystemString(27));
		SuppressMyPoint_txt.SetText("0");
		currentSubjugationID = int(rowData.nReserved1);
		API_C_EX_SUBJUGATION_RANKING(currentSubjugationID);
		setTooltipAtSuppressKey_btn();
	}
	return;
}

function setSuppressPage(bool bEvent, bool bEnableState, string titleStr, int gachaPoint, string bgTexStr)
{
	SuppressZoneTitle_txt.SetText(titleStr);
	SuppressKeyDesc_txt.SetText(((GetSystemString(13630) $ "\\nx") $ string(gachaPoint)));
	if((gachaPoint > 0))
	{
		SuppressKeyDesc_txt.SetTextColor(GTColor().Yellow);
	}
	else
	{
		SuppressKeyDesc_txt.SetTextColor(GTColor().White);
	}
	if(bEvent)
	{
		SuppressZoneEventIcon_tex.ShowWindow();
		SuppressZoneImgEvent_tex.ShowWindow();
	}
	else
	{
		SuppressZoneEventIcon_tex.HideWindow();
		SuppressZoneImgEvent_tex.HideWindow();
	}
	if((bgTexStr == ""))
	{
		SuppressZoneImg_tex.SetTexture("L2UI_EPIC.SuppressWnd.SuppressItem_Bg");
	}
	else
	{
		SuppressZoneImg_tex.SetTexture(bgTexStr);
	}
	if(bEnableState)
	{
		SuppressTeleport_btn.EnableWindow();
		SuppressTeleportDesc_txt.SetTextColor(GTColor().White);
	}
	else
	{
		SuppressTeleport_btn.DisableWindow();
		SuppressTeleportDesc_txt.SetTextColor(GTColor().Gray);
	}
	return;
}

function setTooltipAtSuppressKey_btn()
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;
	local SubjugationData currentSubjugationData;
	local int i;
	local ItemInfo Info;

	currentSubjugationData = getSubjugationDataByID(currentSubjugationID);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(2984), getInstanceL2Util().BrightWhite, "hs14", true, true);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	i = 0;
	while((i < (currentSubjugationData.ShowGachaMain.Length / 3)))
	{
		Info = GetItemInfoByClassID(currentSubjugationData.ShowGachaMain[(i * 3)]);
		Info.ItemNum = INT64(currentSubjugationData.ShowGachaMain[((i * 3) + 1)]);
		if((Info.ItemNum > INT64(1)))
		{
			Info.bShowCount = true;
		}
		addDrawItemGameItem(drawListArr, Info, true, GTColor().Yellow);
		i++;
	}
	i = 0;
	while((i < (currentSubjugationData.ShowGachaSub.Length / 3)))
	{
		Info = GetItemInfoByClassID(currentSubjugationData.ShowGachaSub[(i * 3)]);
		Info.ItemNum = INT64(currentSubjugationData.ShowGachaSub[((i * 3) + 1)]);
		if((Info.ItemNum > INT64(1)))
		{
			Info.bShowCount = true;
		}
		addDrawItemGameItem(drawListArr, Info, true);
		i++;
	}
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	SuppressKey_btn.SetTooltipType("text");
	SuppressKey_btn.SetTooltipCustomType(mCustomTooltip);
	return;
}

function setCurrentserverTime(string param)
{
	clientStartSec = int(GetAppSeconds());
	ParseInt(param, "ServerTime", serverStartTime);
	return;
}

function int changeTimeData(int nTime)
{
	local string timeStr;
	local int Day;

	Day = int(Left(getInstanceL2Util().makeZeroString(5, INT64(nTime)), 1));
	timeStr = Right(getInstanceL2Util().makeZeroString(5, INT64(nTime)), 4);
	if((Day == 0))
	{
		Day = 7;
	}
	return int((string(Day) $ timeStr));
}

function int getRemainTimeSec(int RemainTime)
{
	local string timeStr;
	local int Day, Hour, Min, totalSec;

	Day = int(Left(getInstanceL2Util().makeZeroString(5, INT64(RemainTime)), 1));
	timeStr = Right(getInstanceL2Util().makeZeroString(5, INT64(RemainTime)), 4);
	Hour = int(Left(timeStr, 2));
	Min = int(Right(timeStr, 2));
	totalSec = (((((Day * 24) * 60) * 60) + ((Hour * 60) * 60)) + (Min * 60));
	return totalSec;
}

function string GetRemainTimeString(array<int> Cycle)
{
	local int i, timeIndex, CurTime, nCurrentTime, nTemp, nStartTime, nEndTime;

	GetTimeStruct(int(((float(serverStartTime) + GetAppSeconds()) - float(clientStartSec))), L2UITime);
	CurTime = ((L2UITime.nHour * 100) + L2UITime.nMin);
	nCurrentTime = int((string(L2UITime.nWeekDay) $ getInstanceL2Util().makeZeroString(4, INT64(CurTime))));
	Debug(("1 nCurrentTime" @ string(nCurrentTime)));
	nCurrentTime = changeTimeData(nCurrentTime);
	Debug(("2 nCurrentTime" @ string(nCurrentTime)));
	timeIndex = -1;
	i = 0;
	while((i < (Cycle.Length / 2)))
	{
		nStartTime = changeTimeData(Cycle[(i * 2)]);
		nEndTime = changeTimeData(Cycle[((i * 2) + 1)]);
		nTemp = (nStartTime - nEndTime);
		Debug(("Cycle" @ string(Cycle[i])));
		Debug(("시작 시간 " @ string(nStartTime)));  // EN?: Start-up time
		Debug(("nCurrentTime" @ string(nCurrentTime)));
		Debug(("끝 시간 " @ string(nEndTime)));  // EN?: EndTime
		if((nTemp <= -1))
		{
			if(((nStartTime <= nCurrentTime) && (nEndTime >= nCurrentTime)))
			{
				timeIndex = i;
				break;
			}
		}
		i++;
	}
	Debug(("timeIndex" @ string(timeIndex)));
	if((timeIndex > -1))
	{
		nTemp = (getRemainTimeSec(nEndTime) - getRemainTimeSec(nCurrentTime));
		Debug(((("남은 시간" @ string(nTemp)) @ string(nTemp)) @ getTimeStringBySec(getRemainTimeSec(nTemp))));  // EN?: Time Remaining
		return getTimeStringBySec(nTemp);
	}
	return GetSystemString(3526);
}

function bool isInPeroid(array<int> Cycle)
{
	local int i, nStartTime, nEndTime, CurTime, nCurrentTime, nTemp;

	GetTimeStruct(int(((float(serverStartTime) + GetAppSeconds()) - float(clientStartSec))), L2UITime);
	CurTime = ((L2UITime.nHour * 100) + L2UITime.nMin);
	nCurrentTime = int((string(L2UITime.nWeekDay) $ getInstanceL2Util().makeZeroString(4, INT64(CurTime))));
	nCurrentTime = changeTimeData(nCurrentTime);
	i = 0;
	while((i < (Cycle.Length / 2)))
	{
		nStartTime = changeTimeData(Cycle[(i * 2)]);
		nEndTime = changeTimeData(Cycle[((i * 2) + 1)]);
		nTemp = (nStartTime - nEndTime);
		if((nTemp <= -1))
		{
			if(((nStartTime <= nCurrentTime) && (nEndTime >= nCurrentTime)))
			{
				return true;
			}
		}
		i++;
	}
	return false;
}

function bool IsInPeroidWithRemainTime(array<int> Cycle, out int RemainTime)
{
	local int i, nStartTime, nEndTime, CurTime, nCurrentTime, nTemp;

	GetTimeStruct(int(((float(serverStartTime) + GetAppSeconds()) - float(clientStartSec))), L2UITime);
	CurTime = ((L2UITime.nHour * 100) + L2UITime.nMin);
	nCurrentTime = int((string(L2UITime.nWeekDay) $ getInstanceL2Util().makeZeroString(4, INT64(CurTime))));
	nCurrentTime = changeTimeData(nCurrentTime);
	i = 0;
	while((i < (Cycle.Length / 2)))
	{
		nStartTime = changeTimeData(Cycle[(i * 2)]);
		nEndTime = changeTimeData(Cycle[((i * 2) + 1)]);
		nTemp = (nStartTime - nEndTime);
		if((nTemp <= -1))
		{
			if(((nStartTime <= nCurrentTime) && (nEndTime >= nCurrentTime)))
			{
				RemainTime = (TimeStringToSec(nEndTime) - TimeStringToSec(nCurrentTime));
				return true;
				i++;
				continue;
			}
			if((nCurrentTime < nStartTime))
			{
				RemainTime = (TimeStringToSec(nStartTime) - TimeStringToSec(nCurrentTime));
				return false;
			}
		}
		i++;
	}
	if((Cycle.Length > 0))
	{
		RemainTime = (TimeStringToSec((changeTimeData(Cycle[0]) + 70000)) - TimeStringToSec(nCurrentTime));
	}
	return false;
}

function int TimeStringToSec(int Time)
{
	local int D, h, M;
	local string remainTimeString;

	remainTimeString = getInstanceL2Util().makeZeroString(5, INT64(Time));
	D = int(Left(remainTimeString, 1));
	h = int(Right(Left(remainTimeString, 3), 2));
	M = int(Right(remainTimeString, 2));
	return (((D * 86400) + (h * 3600)) + (M * 60));
}

function string getTimeStringBySec(int Sec)
{
	local int timeTemp, timeTemp0, timeTemp1;
	local string returnStr;

	returnStr = "";
	timeTemp = (((Sec / 60) / 60) / 24);
	timeTemp0 = ((Sec / 60) / 60);
	timeTemp1 = (Sec / 60);
	if((timeTemp > 0))
	{
		returnStr = MakeFullSystemMsg(GetSystemMessage(4466), string(timeTemp), string(int((float(((Sec / 60) / 60)) % 24.0000000))), string(int((float((Sec / 60)) % 60.0000000))));
	}
	else if((timeTemp0 > 0))
	{
		returnStr = MakeFullSystemMsg(GetSystemMessage(3304), string(timeTemp0), string(int((float((Sec / 60)) % 60.0000000))));
	}
	else if((timeTemp1 > 0))
	{
		returnStr = MakeFullSystemMsg(GetSystemMessage(3390), string(timeTemp1));
	}
	else
	{
		returnStr = MakeFullSystemMsg(GetSystemMessage(4360), string(1));
	}
	return returnStr;
}

function UIControlDialogAssets GetPopupExpandScript()
{
	local WindowHandle poopExpandWnd;

	poopExpandWnd = GetWindowHandle((m_Windowname $ ".UIControlDialogAsset"));
	return UIControlDialogAssets(poopExpandWnd.GetScript());
}

function SetPopupScript()
{
	local WindowHandle poopExpandWnd;
	local UIControlDialogAssets popupExpandScript;
	local WindowHandle disableWnd;

	poopExpandWnd = GetWindowHandle((m_Windowname $ ".UIControlDialogAsset"));
	popupExpandScript = Class'InterfaceClassic.UIControlDialogAssets'.static.InitScript(poopExpandWnd);
	disableWnd = GetWindowHandle((m_Windowname $ ".disable_tex"));
	popupExpandScript.SetDisableWindow(disableWnd);
	Class'NWindow.UIAPI_WINDOW'.static.SetAlwaysOnTop((m_Windowname $ ".disable_tex"), false);
	return;
}

function ShowPopup()
{
	local UIControlDialogAssets popupExpandScript;
	local TeleportListAPI.TeleportListData listData;

	popupExpandScript = GetPopupExpandScript();
	listData = getInstanceUIData().GetTeleportListDataByID(currentTeleportID);
	popupExpandScript.SetDialogDesc(((((GetSystemMessage(5239) $ "\\n\\n") $ "(") $ listData.Name) $ ")"));
	popupExpandScript.SetUseNeedItem(true);
	popupExpandScript.StartNeedItemList(1);
	popupExpandScript.AddNeedItemClassID(57, getInstanceUIData().GetTeleportPriceByID(currentTeleportID));
	popupExpandScript.SetItemNum(1);
	popupExpandScript.Show();
	popupExpandScript.DelegateOnClickBuy = onClickTeleport;
	popupExpandScript.DelegateOnCancel = OnClickCancelDialog;
	return;
}

function OnClickCancelDialog()
{
	GetPopupExpandScript().Hide();
	return;
}

function onClickTeleport()
{
	Class'NWindow.TeleportListAPI'.static.RequestTeleport(currentTeleportID);
	GetPopupExpandScript().Hide();
	GetWindowHandle(m_Windowname).HideWindow();
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
	m_Windowname="SuppressWnd"
}
