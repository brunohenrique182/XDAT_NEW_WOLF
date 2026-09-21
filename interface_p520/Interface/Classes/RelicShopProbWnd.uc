class RelicShopProbWnd extends UICommonAPI
	dependson(UIPacket);

const currentType = 0;

struct RelicCombineProbInfo
{
	var string relicName;
	var INT64 Prob;
	var UIConstants.ERelicGrade Grade;
};

struct RelicProbsInfo
{
	var int SummonID;
	var array<UIPacket._RelicsProb> relicProbs;
};

var int _summonID;
var WindowHandle Me;
var RichListCtrlHandle RichListCtrl;
var array<RelicProbsInfo> relicProbsInfos;
//var delegate<OnSortByProb> __OnSortByProb__Delegate;

static function RelicShopProbWnd Inst()
{
	return RelicShopProbWnd(GetScript("RelicShopProbWnd"));
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

function ShowInfo(array<UIPacket._RelicsProb> relicProbs)
{
	local int i;
	local L2Util util;
	local RichListCtrlRowData rowData;
	local RelicCombineProbInfo tmpInfo;
	local array<RelicCombineProbInfo> probLists;
	local UIConstants.ERelicGrade currentGrade;

	util = L2Util(GetScript("L2Util"));
	MakeRelicProbInfo(relicProbs, probLists);
	// probLists.Sort(OnSortByProb);   // array.Sort() unsupported by this compiler
	RichListCtrl.DeleteAllItem();
	rowData.cellDataList.Length = 2;
	if((probLists.Length > 0))
	{
		i = 0;
		while((i < probLists.Length))
		{
			rowData.cellDataList[0].drawitems.Length = 0;
			rowData.cellDataList[1].drawitems.Length = 0;
			if((int(currentGrade) != int(probLists[i].Grade)))
			{
				currentGrade = probLists[i].Grade;
				InsertTitleRecord(currentGrade);
			}
			tmpInfo = probLists[i];
			AddRichListCtrlString(rowData.cellDataList[0].drawitems, tmpInfo.relicName, util.GetRelicTextColor(currentGrade), false, 10);
			if(GetSummonRelicShowProb())
			{
				AddRichListCtrlString(rowData.cellDataList[1].drawitems, util.MakeDecimalPointString(string(tmpInfo.Prob), 8, true, true), util.White, false, 22);
			}
			RichListCtrl.InsertRecord(rowData);
			i++;
		}
	}
	return;
}

function InsertTitleRecord(UIConstants.ERelicGrade currentGrade)
{
	local RichListCtrlRowData rowData;

	rowData.cellDataList.Length = 1;
	rowData.sOverlayTex = GetProbGradeTexString(currentGrade);
	rowData.OverlayTexU = 334;
	rowData.OverlayTexV = 42;
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, Class'Interface.RelicWnd'.static.Inst().GetRelicGradeString(currentGrade), getInstanceL2Util().BWhite, false, 8, , "hs12");
	RichListCtrl.InsertRecord(rowData);
	return;
}

function MakeRelicProbInfo(array<UIPacket._RelicsProb> probs, out array<RelicCombineProbInfo> o_probLists)
{
	local int i;
	local UIPacket._RelicsProb packetInfo;
	local RelicsMainUIData relicUIData;
	local RelicCombineProbInfo tempProbInfo;

	i = 0;
	while((i < probs.Length))
	{
		packetInfo = probs[i];
		if(API_GetRelicsMainData(packetInfo.nRelicsID, relicUIData))
		{
			tempProbInfo.relicName = GetItemInfoByClassID(relicUIData.ItemID).Name;
			tempProbInfo.Prob = packetInfo.nProb;
			tempProbInfo.Grade = ERelicGrade(relicUIData.Grade);
			o_probLists[o_probLists.Length] = tempProbInfo;
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

function ShowShopProbWnd(int nSummonID)
{
	local int Index;

	if((Me.IsShowWindow() && (nSummonID == _summonID)))
	{
		Me.HideWindow();
	}
	else
	{
		Me.ShowWindow();
		Index = GetIndexProbsInfos(nSummonID);
		if((Index > -1))
		{
			_summonID = nSummonID;
			ShowInfo(relicProbsInfos[Index].relicProbs);
		}
		else
		{
			Rq_C_EX_RELICS_PROB_LIST(nSummonID);
		}
	}
	return;
}

function InsertRelicProbsInfo(array<UIPacket._RelicsProb> relicProbs)
{
	local RelicProbsInfo relicProbsInfodata;

	relicProbsInfodata.SummonID = _summonID;
	relicProbsInfodata.relicProbs = relicProbs;
	relicProbsInfos[relicProbsInfos.Length] = relicProbsInfodata;
	return;
}

function int GetIndexProbsInfos(int SummonID)
{
	local int i;

	i = 0;
	while((i < relicProbsInfos.Length))
	{
		if((relicProbsInfos[i].SummonID == SummonID))
		{
			return i;
		}
		i++;
	}
	return -1;
}

delegate int OnSortByProb(RelicCombineProbInfo A, RelicCombineProbInfo B)
{
	if((int(A.Grade) != int(B.Grade)))
	{
		if((int(A.Grade) < int(B.Grade)))
		{
			return -1;
		}
		else
		{
			return 0;
		}
	}
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

function Rq_C_EX_RELICS_PROB_LIST(int SummonID)
{
	local array<byte> stream;
	local UIPacket._C_EX_RELICS_PROB_LIST packet;

	if((_summonID == SummonID))
	{
		return;
	}
	packet.Type = 0;
	packet.Key = SummonID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_RELICS_PROB_LIST(stream, packet))
	{
		return;
	}
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
	if((packet.Type != 0))
	{
		Me.HideWindow();
		return;
	}
	_summonID = packet.Key;
	InsertRelicProbsInfo(packet.relicsProbList);
	Debug((("Rs_S_EX_RELICS_PROB_LIST" @ string(_summonID)) @ string(packet.relicsProbList.Length)));
	ShowInfo(packet.relicsProbList);
	return;
}

function bool API_GetRelicsMainData(int a_RelicsID, out RelicsMainUIData o_data)
{
	return GetRelicsMainData(a_RelicsID, o_data);
}

event OnRegisterEvent()
{
	RegisterEvent(40);
	RegisterEvent(EV_PacketID(1175));
	return;
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case 40:
			_summonID = -1;
			break;
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
