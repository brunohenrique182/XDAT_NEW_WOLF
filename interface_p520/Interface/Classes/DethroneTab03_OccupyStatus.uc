class DethroneTab03_OccupyStatus extends UICommonAPI
	dependson(UIPacket);

var string m_Windowname;
var WindowHandle Me;
var ButtonHandle Help_btn;
var RichListCtrlHandle Tab_RichList;
var TextureHandle ListBg_tex;
var ButtonHandle ReFresh_btn;
var WindowHandle DisableWndList;
var TextBoxHandle List_Empty;
var UIControlGroupButtonAssets UIControlGroupButtonAsset;

function OnRegisterEvent()
{
	RegisterEvent((100000 + 953));
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
	Help_btn = GetButtonHandle((m_Windowname $ ".Help_btn"));
	Tab_RichList = GetRichListCtrlHandle((m_Windowname $ ".Tab_RichList"));
	ListBg_tex = GetTextureHandle((m_Windowname $ ".ListBg_tex"));
	ReFresh_btn = GetButtonHandle((m_Windowname $ ".Refresh_btn"));
	DisableWndList = GetWindowHandle((m_Windowname $ ".DisableWndList"));
	List_Empty = GetTextBoxHandle((m_Windowname $ ".DisableWndList.List_Empty"));
	Tab_RichList.SetTooltipType("SimpleRichListTooltip");
	Tab_RichList.SetSelectedSelTooltip(false);
	Tab_RichList.SetAppearTooltipAtMouseX(true);
	return;
}

function Load()
{
	initGroupButton();
	return;
}

function initGroupButton()
{
	UIControlGroupButtonAsset = Class'Interface.UIControlGroupButtonAssets'.static._InitScript(GetWindowHandle((m_Windowname $ ".UIControlGroupButtonAsset")));
	UIControlGroupButtonAsset._SetStartInfo("l2ui_ct1.RankingWnd_SubTabButton", "l2ui_ct1.RankingWnd_SubTabButton_Down", "l2ui_ct1.RankingWnd_SubTabButton_Over", true);
	UIControlGroupButtonAsset._GetGroupButtonsInstance().DelegateOnClickButton = DelegateOnClickButton;
	UIControlGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(0, GetSystemString(13756));
	UIControlGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(1, GetSystemString(1622));
	UIControlGroupButtonAsset._GetGroupButtonsInstance()._setShowButtonNum(2);
	UIControlGroupButtonAsset._GetGroupButtonsInstance()._setAutoWidth(300, 4);
	UIControlGroupButtonAsset._GetGroupButtonsInstance()._setTopOrder(0, true);
	return;
}

function DelegateOnClickButton(string parentWndName, string strName, int Index)
{
	Debug("-----메인 탭-------");  // EN?: -----Main Tab-------
	Debug(("strName" @ parentWndName));
	Debug(("strName" @ strName));
	Debug(("index" @ string(Index)));
	OnReFresh_btnClick();
	return;
}

event OnShow()
{
	Debug(("Onshow " @ m_Windowname));
	if(GetWindowHandle("DethroneWnd").IsShowWindow())
	{
		OnReFresh_btnClick();
		Debug(("어떤 버튼이 눌러져 있나?" @ string(UIControlGroupButtonAsset._GetGroupButtonsInstance()._getSelectButtonIndex())));  // EN?: Which button is pressed?
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "Help_btn":
			OnHelp_btnClick();
			break;
		case "Refresh_btn":
			OnReFresh_btnClick();
			break;
		default:
			break;
	}
	return;
}

function OnHelp_btnClick()
{
	Class'Interface.HelpWnd'.static.ShowHelp(63, 4);
	return;
}

function OnReFresh_btnClick()
{
	API_C_EX_DETHRONE_DISTRICT_OCCUPATION_INFO();
	DethroneWnd(GetScript("DethroneWnd")).setDisableWnd();
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 9750:
			break;
		case EV_PacketID(953):
			ParsePacket_S_EX_DETHRONE_DISTRICT_OCCUPATION_INFO();
			break;
		default:
			break;
	}
	return;
}

function ParsePacket_S_EX_DETHRONE_DISTRICT_OCCUPATION_INFO()
{
	local UIPacket._S_EX_DETHRONE_DISTRICT_OCCUPATION_INFO packet;
	local int i, M;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_DETHRONE_DISTRICT_OCCUPATION_INFO(packet))
	{
		return;
	}
	Debug((" -->  Decode_S_EX_DETHRONE_DISTRICT_OCCUPATION_INFO : " @ string(packet.occupationInfoList.Length)));
	Debug(("cCategory: " @ string(packet.cCategory)));
	Tab_RichList.DeleteAllItem();
	i = 0;
	while((i < packet.occupationInfoList.Length))
	{
		AddTitleListItem(true, GetDethroneDistrictName(packet.occupationInfoList[i].nDistrictID), packet.cCategory);
		AddTitleListItem(false, getServerNameByWorldID(packet.occupationInfoList[i].nOccupyingWorldID), packet.cCategory);
		M = 0;
		while((M < packet.occupationInfoList[i].pointInfoList.Length))
		{
			AddOccupationStateListItem(packet.occupationInfoList[i].pointInfoList[M].nRank, packet.occupationInfoList[i].pointInfoList[M].nWorldID, packet.occupationInfoList[i].pointInfoList[M].nPoint);
			M++;
		}
		i++;
	}
	Tab_RichList.SetFocus();
	return;
}

function AddTitleListItem(bool bTitle, string Str, int cCategory)
{
	local Color applyColor;
	local RichListCtrlRowData rowData;

	rowData.cellDataList.Length = 1;
	if(bTitle)
	{
		if((cCategory == 0))
		{
			rowData.sOverlayTex = "L2UI_EPIC.DethroneWnd.List_HeaderBg_Blue";
		}
		else
		{
			rowData.sOverlayTex = "L2UI_EPIC.DethroneWnd.List_HeaderBg_Red";
		}
		applyColor = GTColor().BrightWhite;
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, Str, applyColor, false, 0, 0);
	}
	else
	{
		rowData.sOverlayTex = "L2UI_EPIC.DethroneWnd.List_HeaderBg_Brown";
		applyColor = GTColor().WhiteSmoke;
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, (GetSystemString(13787) $ " : "), GTColor().Gold, false, 0, 0);
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, Str, applyColor, false, 0, 0);
	}
	rowData.OverlayTexU = 635;
	rowData.OverlayTexV = 32;
	Tab_RichList.InsertRecord(rowData);
	return;
}

function AddOccupationStateListItem(int nServerNo, int ServerID, INT64 areaPoint)
{
	local RichListCtrlRowData rowData;
	local Color applyColor;
	local bool bMe;
	local string rankStr;
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
	rankStr = string(nServerNo);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, rankStr, applyColor, false, 0, 10);
	Class'NWindow.UIDataManager'.static.GetServerInfo(ServerID, ServerInfo);
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems, GetServerMarkNameSmall(ServerID), 30, 30, 100, -8);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, ServerInfo.ServerName, applyColor, false, 0, 8);
	AddRichListCtrlButton(rowData.cellDataList[1].drawitems, "ReceipBtn", 0, 0, "L2UI_EPIC.DethroneWnd.DethroneZonePointIcon", "L2UI_EPIC.DethroneWnd.DethroneZonePointIcon", "L2UI_EPIC.DethroneWnd.DethroneZonePointIcon", 20, 21, 20, 21, 1, GetSystemString(13740));
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, MakeCostString(string(areaPoint)), applyColor, false, 26, 5);
	rowData.cellDataList[0].szData = rankStr;
	rowData.cellDataList[1].szData = string(areaPoint);
	Tab_RichList.InsertRecord(rowData);
	return;
}

function API_C_EX_DETHRONE_DISTRICT_OCCUPATION_INFO()
{
	local array<byte> stream;
	local UIPacket._C_EX_DETHRONE_DISTRICT_OCCUPATION_INFO packet;

	packet.cCategory = UIControlGroupButtonAsset._GetGroupButtonsInstance()._getSelectButtonIndex();
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_DETHRONE_DISTRICT_OCCUPATION_INFO(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(718, stream);
	Debug(("----> Api Call : C_EX_DETHRONE_DISTRICT_OCCUPATION_INFO " @ string(UIControlGroupButtonAsset._GetGroupButtonsInstance()._getSelectButtonIndex())));
	return;
}
