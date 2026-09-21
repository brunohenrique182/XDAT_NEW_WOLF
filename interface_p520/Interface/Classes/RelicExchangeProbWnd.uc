class RelicExchangeProbWnd extends UICommonAPI
	dependson(UIPacket);

struct RelicExchangeProbInfo
{
	var string relicName;
	var INT64 Prob;
};

var RelicWnd.RelicExchangeInfo _exchangeInfo;
var RichListCtrlHandle RichListCtrl;
var WindowHandle Me;
//var delegate<OnSortByProb> __OnSortByProb__Delegate;

static function RelicExchangeProbWnd Inst()
{
	return RelicExchangeProbWnd(GetScript("RelicExchangeProbWnd"));
}

function Initialize()
{
	InitControls();
	return;
}

function InitControls()
{
	local string ownerFullPath;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	RichListCtrl = GetRichListCtrlHandle((ownerFullPath $ ".List_ListCtrl0"));
	RichListCtrl.SetSelectable(false);
	Me = GetWindowHandle(ownerFullPath);
	return;
}

function ShowInfo(RelicWnd.RelicExchangeInfo exchangeInfo)
{
	if(((Me.IsShowWindow() && (exchangeInfo.Info.nIndex == _exchangeInfo.Info.nIndex)) && (exchangeInfo.Info.nRelicsID == _exchangeInfo.Info.nRelicsID)))
	{
		Me.HideWindow();
		return;
	}
	_exchangeInfo = exchangeInfo;
	Rq_C_EX_RELICS_PROB_LIST(exchangeInfo.Info.nRelicsID);
	return;
}

function UpdateListControls(int relicId, array<UIPacket._RelicsProb> relicProbs)
{
	local UIConstants.ERelicGrade Grade;
	local array<RelicExchangeProbInfo> probList;
	local RichListCtrlRowData rowData;
	local L2Util util;
	local RelicsMainUIData relicUIData;
	local RelicExchangeProbInfo tmpInfo;
	local int i;

	util = L2Util(GetScript("L2Util"));
	GetRelicsMainData(_exchangeInfo.Info.nRelicsID, relicUIData);
	Grade = ERelicGrade(relicUIData.Grade);
	MakeRelicList(relicProbs, probList);
	// probList.Sort(OnSortByProb);   // array.Sort() unsupported by this compiler
	RichListCtrl.DeleteAllItem();
	rowData.cellDataList.Length = 2;
	if((probList.Length > 0))
	{
		i = 0;
		while((i < (probList.Length + 1)))
		{
			rowData.cellDataList[0].drawitems.Length = 0;
			rowData.cellDataList[1].drawitems.Length = 0;
			if((i == 0))
			{
				rowData.sOverlayTex = GetProbGradeTexString(Grade);
				rowData.OverlayTexU = 334;
				rowData.OverlayTexV = 42;
				AddRichListCtrlString(rowData.cellDataList[0].drawitems, Class'Interface.RelicWnd'.static.Inst().GetRelicGradeString(Grade), util.BWhite, false, 8, , "hs12");
			}
			else
			{
				rowData.sOverlayTex = "";
				tmpInfo = probList[(i - 1)];
				AddRichListCtrlString(rowData.cellDataList[0].drawitems, tmpInfo.relicName, util.GetRelicTextColor(Grade), false, 10);
				AddRichListCtrlString(rowData.cellDataList[1].drawitems, util.MakeDecimalPointString(string(tmpInfo.Prob), 8, true, true), util.White, false, 22);
			}
			RichListCtrl.InsertRecord(rowData);
			i++;
		}
	}
	Me.ShowWindow();
	return;
}

function MakeRelicList(array<UIPacket._RelicsProb> relicProbs, out array<RelicExchangeProbInfo> outProbList)
{
	local int i;
	local UIPacket._RelicsProb packetInfo;
	local RelicsMainUIData relicUIData;
	local RelicExchangeProbInfo tempProbInfo;

	i = 0;
	while((i < relicProbs.Length))
	{
		packetInfo = relicProbs[i];
		if(GetRelicsMainData(packetInfo.nRelicsID, relicUIData))
		{
			tempProbInfo.relicName = GetItemInfoByClassID(relicUIData.ItemID).Name;
			tempProbInfo.Prob = packetInfo.nProb;
			outProbList[outProbList.Length] = tempProbInfo;
		}
		i++;
	}
	return;
}

function string GetProbGradeTexString(UIConstants.ERelicGrade Grade)
{
	switch(Grade)
	{
		case RG_A:
			return "L2UI_NewTex.RelicWnd.ListHeaderBg_A";
		case RG_B:
			return "L2UI_NewTex.RelicWnd.ListHeaderBg_B";
		case RG_C:
			return "L2UI_NewTex.RelicWnd.ListHeaderBg_C";
		case RG_D:
			return "L2UI_NewTex.RelicWnd.ListHeaderBg_D";
		case RG_N:
			return "L2UI_NewTex.RelicWnd.ListHeaderBg_N";
		default:
			return "";
	}
}

delegate int OnSortByProb(RelicExchangeProbInfo A, RelicExchangeProbInfo B)
{
	if((A.Prob != B.Prob))
	{
		if((A.Prob > B.Prob))
		{
			return 0;
		}
		else
		{
			return -1;
		}
	}
	if((A.relicName > B.relicName))
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

function Rq_C_EX_RELICS_PROB_LIST(int relicId)
{
	local array<byte> stream;
	local UIPacket._C_EX_RELICS_PROB_LIST packet;

	packet.Type = 2;
	packet.Key = relicId;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_RELICS_PROB_LIST(stream, packet))
	{
		return;
	}
	Debug((("Rq_C_EX_RELICS_PROB_LIST" @ string(packet.Type)) @ string(packet.Key)));
	Class'Interface.UIPacket'.static.RequestUIPacket(899, stream);
	return;
}

function Rs_S_EX_RELICS_PROB_LIST()
{
	local UIPacket._S_EX_RELICS_PROB_LIST packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_RELICS_PROB_LIST(packet))
	{
		return;
	}
	if((packet.Type != 2))
	{
		return;
	}
	Debug(((("Rs_S_EX_RELICS_PROB_LIST" @ string(packet.Type)) @ string(packet.Key)) @ string(packet.relicsProbList.Length)));
	UpdateListControls(packet.Key, packet.relicsProbList);
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(1175));
	return;
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case EV_PacketID(1175):
			Rs_S_EX_RELICS_PROB_LIST();
			break;
		default:
			break;
	}
	return;
}

event OnLoad()
{
	Initialize();
	return;
}
