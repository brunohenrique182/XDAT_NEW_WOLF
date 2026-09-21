class RelicCombineProbWnd extends UICommonAPI
	dependson(UIPacket);

struct RelicCombineProbInfo
{
	var string relicName;
	var INT64 Prob;
};

struct ProbPacketInfo
{
	var UIConstants.ERelicGrade Grade;
	var array<UIPacket._RelicsProb> probList;
};

var UIConstants.ERelicGrade _grade;
var array<ProbPacketInfo> _gradeProbList;
var array<ProbPacketInfo> _gradeFixProbList;
var int currentType;
var WindowHandle Me;
var RichListCtrlHandle RichListCtrl;
//var delegate<OnSortByProb> __OnSortByProb__Delegate;

static function RelicCombineProbWnd Inst()
{
	return RelicCombineProbWnd(GetScript("RelicCombineProbWnd"));
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

function ResetProbPacketInfo()
{
	_gradeProbList.Length = 0;
	_gradeFixProbList.Length = 0;
	return;
}

function UpdateInfo()
{
	local RelicWnd.RelicCombineInfo combineInfo;
	local UIConstants.ERelicGrade Grade;

	if((currentType == 1))
	{
		combineInfo = Class'InterfaceClassic.RelicWnd'.static.Inst().GetCombineInfo();
		if((combineInfo.stuffTotalArray.Length > 0))
		{
			Grade = combineInfo.Grade;
		}
	}
	else if((currentType == 3))
	{
		Grade = Class'InterfaceClassic.RelicWndList'.static.Inst().GetSelectedTabGrade();
	}
	if((int(Grade) == 0))
	{
		_grade = RG_NONE;
		Me.HideWindow();
		return;
	}
	UpdateProbControls(Grade);
	return;
}

function UpdateProbControls(UIConstants.ERelicGrade Grade)
{
	if((Me.IsShowWindow() == false))
	{
		return;
	}
	if((CheckAndRequestProb(int(Grade)) == false))
	{
		Rq_C_EX_RELICS_PROB_LIST(Grade);
	}
	else
	{
		ShowInfo(Grade);
	}
	return;
}

function ShowInfo(UIConstants.ERelicGrade Grade)
{
	local UIConstants.ERelicGrade failGrade, successGrade;
	local array<RelicCombineProbInfo> failProbList, successProbList;
	local RichListCtrlRowData rowData;
	local L2Util util;
	local RelicCombineProbInfo tmpInfo;
	local int i;

	if((Me.IsShowWindow() == false))
	{
		return;
	}
	_grade = Grade;
	MakeRelicProbInfo(Grade, GetCurrentProbListArr()[int(Grade)], failProbList, successProbList);
	failGrade = Grade;
	successGrade = ERelicGrade((int(Grade) + 1));
	util = L2Util(GetScript("L2Util"));
	if((failProbList.Length > 1))
	{
		// failProbList.Sort(OnSortByProb);   // array.Sort() unsupported by this compiler
	}
	if((successProbList.Length > 1))
	{
		// successProbList.Sort(OnSortByProb);   // array.Sort() unsupported by this compiler
	}
	RichListCtrl.DeleteAllItem();
	rowData.cellDataList.Length = 2;
	if((successProbList.Length > 0))
	{
		i = 0;
		while((i < (successProbList.Length + 1)))
		{
			rowData.cellDataList[0].drawitems.Length = 0;
			rowData.cellDataList[1].drawitems.Length = 0;
			if((i == 0))
			{
				rowData.sOverlayTex = GetProbGradeTexString(successGrade);
				rowData.OverlayTexU = 334;
				rowData.OverlayTexV = 42;
				AddRichListCtrlString(rowData.cellDataList[0].drawitems, GetSystemString(util.GetDollGradeStringId(successGrade)), util.BWhite, false, 8, , "hs12");
			}
			else
			{
				rowData.sOverlayTex = "";
				tmpInfo = successProbList[(i - 1)];
				AddRichListCtrlString(rowData.cellDataList[0].drawitems, util.GetDollNameWithGrade(tmpInfo.relicName, successGrade), util.GetRelicTextColor(successGrade), false, 10);
				AddRichListCtrlString(rowData.cellDataList[1].drawitems, util.MakeDecimalPointString(string(tmpInfo.Prob), 8, true, true), util.White, false, 22);
			}
			RichListCtrl.InsertRecord(rowData);
			i++;
		}
	}
	if((failProbList.Length > 0))
	{
		i = 0;
		while((i < (failProbList.Length + 1)))
		{
			rowData.cellDataList[0].drawitems.Length = 0;
			rowData.cellDataList[1].drawitems.Length = 0;
			if((i == 0))
			{
				rowData.sOverlayTex = GetProbGradeTexString(failGrade);
				rowData.OverlayTexU = 334;
				rowData.OverlayTexV = 42;
				AddRichListCtrlString(rowData.cellDataList[0].drawitems, GetSystemString(util.GetDollGradeStringId(failGrade)), util.BWhite, false, 8, , "hs12");
			}
			else
			{
				rowData.sOverlayTex = "";
				tmpInfo = failProbList[(i - 1)];
				AddRichListCtrlString(rowData.cellDataList[0].drawitems, util.GetDollNameWithGrade(tmpInfo.relicName, failGrade), util.GetRelicTextColor(failGrade), false, 10);
				AddRichListCtrlString(rowData.cellDataList[1].drawitems, util.MakeDecimalPointString(string(tmpInfo.Prob), 8, true, true), util.White, false, 22);
			}
			RichListCtrl.InsertRecord(rowData);
			i++;
		}
	}
	return;
}

function MakeRelicProbInfo(UIConstants.ERelicGrade Grade, ProbPacketInfo probInfo, out array<RelicCombineProbInfo> outFailProbList, out array<RelicCombineProbInfo> outSuccessProbList)
{
	local int i;
	local UIPacket._RelicsProb packetInfo;
	local RelicsMainUIData relicUIData;
	local RelicCombineProbInfo tempProbInfo;

	i = 0;
	while((i < probInfo.probList.Length))
	{
		packetInfo = probInfo.probList[i];
		if(GetRelicsMainData(packetInfo.nRelicsID, relicUIData))
		{
			tempProbInfo.relicName = GetItemInfoByClassID(relicUIData.ItemID).Name;
			tempProbInfo.Prob = packetInfo.nProb;
			if((relicUIData.Grade == int(probInfo.Grade)))
			{
				outFailProbList[outFailProbList.Length] = tempProbInfo;
				i++;
				continue;
			}
			outSuccessProbList[outSuccessProbList.Length] = tempProbInfo;
		}
		i++;
	}
	return;
}

function array<ProbPacketInfo> GetCurrentProbListArr()
{
	switch(currentType)
	{
		case 1:
			return _gradeProbList;
		case 3:
			return _gradeFixProbList;
		default:
	}
}

function bool CheckAndRequestProb(int Grade)
{
	if(((GetCurrentProbListArr().Length > Grade) && (GetCurrentProbListArr()[Grade].probList.Length > 0)))
	{
		return true;
	}
	return false;
}

function string GetProbGradeTexString(UIConstants.ERelicGrade Grade)
{
	switch(Grade)
	{
		case RG_R:
			return "L2UI_NewTex.RelicWnd.DollListHeaderBg_R";
		case RG_S:
			return "L2UI_NewTex.RelicWnd.DollListHeaderBg_S";
		case RG_A:
			return "L2UI_NewTex.RelicWnd.DollListHeaderBg_A";
		case RG_B:
			return "L2UI_NewTex.RelicWnd.DollListHeaderBg_B";
		case RG_C:
			return "L2UI_NewTex.RelicWnd.DollListHeaderBg_C";
		case RG_D:
			return "L2UI_NewTex.RelicWnd.DollListHeaderBg_D";
		case RG_N:
			return "L2UI_NewTex.RelicWnd.DollListHeaderBg_N";
		default:
			return "";
	}
}

function ToggleCombineProbInfo()
{
	ToggleShow(1);
	return;
}

function ToggleFixCombineProbInfo()
{
	ToggleShow(3);
	return;
}

function bool IsGradeSame(int newType)
{
	if((newType == 1))
	{
		return (int(_grade) == int(Class'InterfaceClassic.RelicWnd'.static.Inst().GetCombineInfo().Grade));
	}
	else if((newType == 3))
	{
		return (int(_grade) == int(Class'InterfaceClassic.RelicWndList'.static.Inst().GetSelectedTabGrade()));
	}
	return false;
}

function SetType(int newType)
{
	currentType = newType;
	switch(currentType)
	{
		case 1:
			Me.SetWindowTitle(GetSystemString(14551));
			break;
		case 3:
			Me.SetWindowTitle(GetSystemString(14829));
			break;
		default:
			break;
	}
	return;
}

function ToggleShow(int newType)
{
	if(((Me.IsShowWindow() && (currentType == newType)) && IsGradeSame(newType)))
	{
		SetType(newType);
		Me.HideWindow();
	}
	else
	{
		SetType(newType);
		Me.ShowWindow();
		UpdateInfo();
	}
	return;
}

delegate int OnSortByProb(RelicCombineProbInfo A, RelicCombineProbInfo B)
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

function Rq_C_EX_RELICS_PROB_LIST(UIConstants.ERelicGrade Grade)
{
	local array<byte> stream;
	local UIPacket._C_EX_RELICS_PROB_LIST packet;

	if((CheckAndRequestProb(int(Grade)) == true))
	{
		return;
	}
	packet.Type = currentType;
	packet.Key = int(Grade);
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_RELICS_PROB_LIST(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(899, stream);
	return;
}

function Rs_S_EX_RELICS_PROB_LIST()
{
	local UIPacket._S_EX_RELICS_PROB_LIST packet;
	local ProbPacketInfo packetInfo;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_RELICS_PROB_LIST(packet))
	{
		return;
	}
	if((packet.Type != currentType))
	{
		Me.HideWindow();
		return;
	}
	if((packet.Key > 8))
	{
		Debug(("!!!!!! S_EX_RELICS_PROB_LIST Invalid Grade" @ string(packet.Key)));
		return;
	}
	packetInfo.Grade = ERelicGrade(packet.Key);
	packetInfo.probList = packet.relicsProbList;
	InsertPacketInfo(int(packetInfo.Grade), packetInfo);
	ShowInfo(packetInfo.Grade);
	return;
}

function InsertPacketInfo(int Grade, ProbPacketInfo packetInfo)
{
	switch(currentType)
	{
		case 1:
			_gradeProbList[Grade] = packetInfo;
			break;
		case 3:
			_gradeFixProbList[Grade] = packetInfo;
			break;
		default:
			break;
	}
	return;
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
			ResetProbPacketInfo();
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
