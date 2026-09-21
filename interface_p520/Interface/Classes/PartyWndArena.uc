class PartyWndArena extends UICommonAPI;

const NSTATUSICON_MAXCOL = 12;
const NPARTYSTATUS_HEIGHT = 42;
const NPARTYPETSTATUS_HEIGHT = 18;
const SMALL_BUF_ICON_SIZE = 6;
const MAX_ArrayNum = 10;
const MAX_BUFF_ICONTYPE = 4;
const ONCLASSICFORM_OFFSET_X = 12;
const ONAREAFORM_OFFSET_X = 3;
const BATTLETYPE_BASUTEI = 0;
const BATTLETYPE_CLASH = 1;
const BATTLETYPE_SIEGE = 2;

struct VnameData
{
	var int Id;
	var int UseVName;
	var int DominionIDForVName;
	var string VName;
	var string SummonVName;
};

var bool m_bCompact;
var bool m_bBuff;
var int m_arrID[10];
var int m_arrPetID[10];
var int m_arrSummonID[10];
var int m_arrPetIDOpen[10];
var int m_CurCount;
var int m_CurBf;
var int m_targetID;
var int m_LastChangeColor;
var int transformedMemberID;
var int transFormedType;
var VnameData m_Vname[10];
var bool m_AmIRoomMaster;
var WindowHandle m_wndTop;
var WindowHandle m_PartyStatus[10];
var WindowHandle m_PartyOption;
var NameCtrlHandle m_PlayerName[10];
var TextureHandle m_ClassIcon[10];
var TextureHandle m_LeaderIcon[10];
var TextureHandle m_VPIcon[10];
var TextureHandle m_IsDead[10];
var StatusIconHandle m_StatusIconBuff[10];
var StatusIconHandle m_StatusIconDeBuff[10];
var StatusIconHandle m_StatusIconSongDance[10];
var StatusIconHandle m_StatusIconTriggerSkill[10];
var BarHandle m_BarHP[10];
var BarHandle m_BarMP[10];
var ButtonHandle btnBuff;
var ButtonHandle m_petButton[10];
var ButtonHandle m_petButtonTrash[10];
var WindowHandle m_PetPartyStatus[10];
var StatusIconHandle m_PetStatusIconBuff[10];
var StatusIconHandle m_PetStatusIconDeBuff[10];
var StatusIconHandle m_PetStatusIconSongDance[10];
var StatusIconHandle m_PetStatusIconTriggerSkill[10];
var BarHandle m_PetBarHP[10];
var BarHandle m_PetBarMP[10];
var TextureHandle m_PetClassIcon[10];
var TextureHandle m_ClassIconSummon[10];
var TextureHandle m_ClassIconSummonNum[10];
var int partymasteridx;
var L2Util util;
var int PartyLeaderID;
var string currentBuffButtonState;
var int iconsOffsetX;
var array<int> m_arrMatchGroupMember;
var int currentindex;
var int matchGroupCount;
var int partyCount;
var int currentBattleType;

function OnRegisterEvent()
{
	RegisterEvent(1000);
	RegisterEvent(1140);
	RegisterEvent(1150);
	RegisterEvent(1160);
	RegisterEvent(1170);
	RegisterEvent(1180);
	RegisterEvent(1181);
	RegisterEvent(3131);
	RegisterEvent(3132);
	RegisterEvent(3133);
	RegisterEvent(3110);
	RegisterEvent(3120);
	RegisterEvent(3130);
	RegisterEvent(1050);
	RegisterEvent(40);
	RegisterEvent(980);
	RegisterEvent(1182);
	RegisterEvent(1183);
	RegisterEvent(1052);
	RegisterEvent(1053);
	RegisterEvent(8000);
	RegisterEvent(3410);
	RegisterEvent(8380);
	RegisterEvent(8430);
	return;
}

function checkClassicForm()
{
	local int idx;

	if(getInstanceUIData().GetIsClassicServer())
	{
		iconsOffsetX = 12;
	}
	else if(getInstanceUIData().getIsArenaServer())
	{
		iconsOffsetX = 3;
	}
	else
	{
		iconsOffsetX = 0;
	}
	idx = 0;
	while((idx < 10))
	{
		if((getInstanceUIData().GetIsClassicServer() || getInstanceUIData().getIsArenaServer()))
		{
			m_VPIcon[idx].HideWindow();
			m_ClassIconSummonNum[idx].HideWindow();
		}
		else
		{
			m_VPIcon[idx].ShowWindow();
			m_ClassIconSummonNum[idx].ShowWindow();
		}
		m_LeaderIcon[idx].SetAnchor(("PartyWndArena.PartyStatusWnd" $ string(idx)), "TopLeft", "TopLeft", (30 - iconsOffsetX), 8);
		idx++;
	}
	return;
}

function setHideClassIconSummonNum(int idx)
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		m_ClassIconSummonNum[idx].HideWindow();
	}
	else
	{
		m_ClassIconSummonNum[idx].ShowWindow();
	}
	return;
}

function OnLoad()
{
	local int idx;

	util = L2Util(GetScript("L2Util"));
	InitHandleCOD();
	partymasteridx = -1;
	m_bCompact = false;
	m_bBuff = false;
	m_CurBf = 0;
	m_targetID = -1;
	m_LastChangeColor = -1;
	m_AmIRoomMaster = false;
	idx = 0;
	while((idx < 10))
	{
		m_StatusIconBuff[idx].SetAnchor(("PartyWndArena.PartyStatusWnd" $ string(idx)), "TopRight", "TopLeft", 0, 5);
		m_StatusIconDeBuff[idx].SetAnchor(("PartyWndArena.PartyStatusWnd" $ string(idx)), "TopRight", "TopLeft", 0, 5);
		m_StatusIconSongDance[idx].SetAnchor(("PartyWndArena.PartyStatusWnd" $ string(idx)), "TopRight", "TopLeft", 0, 5);
		m_StatusIconTriggerSkill[idx].SetAnchor(("PartyWndArena.PartyStatusWnd" $ string(idx)), "TopRight", "TopLeft", 0, 5);
		m_PetStatusIconBuff[idx].SetAnchor(("PartyWndArena.PartyStatusSummonWnd" $ string(idx)), "TopRight", "TopLeft", 1, 1);
		m_PetStatusIconDeBuff[idx].SetAnchor(("PartyWndArena.PartyStatusSummonWnd" $ string(idx)), "TopRight", "TopLeft", 1, 1);
		m_PetStatusIconSongDance[idx].SetAnchor(("PartyWndArena.PartyStatusSummonWnd" $ string(idx)), "TopRight", "TopLeft", 1, 1);
		m_PetStatusIconTriggerSkill[idx].SetAnchor(("PartyWndArena.PartyStatusSummonWnd" $ string(idx)), "TopRight", "TopLeft", 1, 1);
		idx++;
	}
	m_PartyOption.HideWindow();
	idx = 0;
	while((idx < 10))
	{
		m_PartyStatus[idx].SetDragOverTexture("L2UI_CT1.ListCtrl.ListCtrl_DF_HighLight");
		idx++;
	}
	ResetVName();
	transformedMemberID = -1;
	m_arrMatchGroupMember.Length = 0;
	return;
}

function InitHandleCOD()
{
	local int idx;

	m_wndTop = GetWindowHandle("PartyWndArena");
	m_PartyOption = GetWindowHandle("PartyWndOption");
	idx = 0;
	while((idx < 10))
	{
		m_PartyStatus[idx] = GetWindowHandle(("PartyWndArena.PartyStatusWnd" $ string(idx)));
		m_PlayerName[idx] = GetNameCtrlHandle((("PartyWndArena.PartyStatusWnd" $ string(idx)) $ ".PlayerName"));
		m_ClassIcon[idx] = GetTextureHandle((("PartyWndArena.PartyStatusWnd" $ string(idx)) $ ".ClassIcon"));
		m_LeaderIcon[idx] = GetTextureHandle((("PartyWndArena.PartyStatusWnd" $ string(idx)) $ ".LeaderIcon"));
		m_VPIcon[idx] = GetTextureHandle((("PartyWndArena.PartyStatusWnd" $ string(idx)) $ ".PartyVPIcon"));
		m_IsDead[idx] = GetTextureHandle((("PartyWndArena.PartyStatusWnd" $ string(idx)) $ ".IsDeadTexture"));
		m_StatusIconBuff[idx] = GetStatusIconHandle((("PartyWndArena.PartyStatusWnd" $ string(idx)) $ ".StatusIconBuff"));
		m_StatusIconDeBuff[idx] = GetStatusIconHandle((("PartyWndArena.PartyStatusWnd" $ string(idx)) $ ".StatusIconDeBuff"));
		m_StatusIconSongDance[idx] = GetStatusIconHandle((("PartyWndArena.PartyStatusWnd" $ string(idx)) $ ".StatusIconSongDance"));
		m_StatusIconTriggerSkill[idx] = GetStatusIconHandle((("PartyWndArena.PartyStatusWnd" $ string(idx)) $ ".StatusIconTriggerSkill"));
		m_BarHP[idx] = GetBarHandle((("PartyWndArena.PartyStatusWnd" $ string(idx)) $ ".barHP"));
		m_BarMP[idx] = GetBarHandle((("PartyWndArena.PartyStatusWnd" $ string(idx)) $ ".barMP"));
		m_petButton[idx] = GetButtonHandle(("PartyWndArena.btnSummon" $ string(idx)));
		m_petButton[idx].HideWindow();
		m_PetPartyStatus[idx] = GetWindowHandle(("PartyWndArena.PartyStatusSummonWnd" $ string(idx)));
		m_PetStatusIconBuff[idx] = GetStatusIconHandle((("PartyWndArena.PartyStatusSummonWnd" $ string(idx)) $ ".StatusIconBuff"));
		m_PetStatusIconDeBuff[idx] = GetStatusIconHandle((("PartyWndArena.PartyStatusSummonWnd" $ string(idx)) $ ".StatusIconDebuff"));
		m_PetStatusIconSongDance[idx] = GetStatusIconHandle((("PartyWndArena.PartyStatusSummonWnd" $ string(idx)) $ ".StatusIconSongDance"));
		m_PetStatusIconTriggerSkill[idx] = GetStatusIconHandle((("PartyWndArena.PartyStatusSummonWnd" $ string(idx)) $ ".StatusIconTriggerSkill"));
		m_PetBarHP[idx] = GetBarHandle((("PartyWndArena.PartyStatusSummonWnd" $ string(idx)) $ ".barHP"));
		m_PetBarMP[idx] = GetBarHandle((("PartyWndArena.PartyStatusSummonWnd" $ string(idx)) $ ".barMP"));
		m_PetClassIcon[idx] = GetTextureHandle((("PartyWndArena.PartyStatusSummonWnd" $ string(idx)) $ ".ClassIconPet"));
		m_ClassIconSummon[idx] = GetTextureHandle((("PartyWndArena.PartyStatusSummonWnd" $ string(idx)) $ ".ClassIconSummon"));
		m_ClassIconSummonNum[idx] = GetTextureHandle((("PartyWndArena.PartyStatusSummonWnd" $ string(idx)) $ ".ClassIconSummonNum"));
		m_arrPetIDOpen[idx] = -1;
		m_arrSummonID[idx] = -1;
		m_arrID[idx] = 0;
		if((idx == 0))
		{
			m_petButton[idx].SetAnchor(("PartyWndArena.PartyStatusWnd" $ string(idx)), "TopLeft", "TopRight", 0, 32);
			idx++;
			continue;
		}
		m_petButton[idx].SetAnchor(("PartyWndArena.PartyStatusWnd" $ string(idx)), "TopLeft", "TopRight", 0, 2);
		idx++;
	}
	btnBuff = GetButtonHandle("PartyWndArena.btnBuff");
	return;
}

function string getSummonSortString(int typeN)
{
	local string returnV;

	returnV = "";
	switch(typeN)
	{
		case 0:
			returnV = GetSystemString(2311);
			break;
		case 1:
			returnV = GetSystemString(2312);
			break;
		case 2:
			returnV = GetSystemString(2313);
			break;
		case 3:
			returnV = GetSystemString(2314);
			break;
		case 4:
			returnV = GetSystemString(2315);
			break;
		default:
			break;
	}
	return returnV;
}

function OnShow()
{
	local int i, tmpInt;

	GetINIInt("PartyWndArena", "a", m_CurBf, "WindowsInfo.ini");
	SetBuffButtonTooltip();
	UpdateBuff();
	GetINIInt("PartyWndArena", "p", tmpInt, "WindowsInfo.ini");
	i = 0;
	while((i < 9))
	{
		if(bool(tmpInt))
		{
			if((m_arrPetIDOpen[i] > 0))
			{
				m_arrPetIDOpen[i] = 2;
			}
			i++;
			continue;
		}
		if((m_arrPetIDOpen[i] > 0))
		{
			m_arrPetIDOpen[i] = 1;
		}
		i++;
	}
	resizeOnly();
	return;
}

function OnHide()
{
	ResetVName();
	return;
}

function OnEnterState(name a_CurrentStateName)
{
	if((isAreaState() == false))
	{
		return;
	}
	m_bCompact = false;
	m_bBuff = false;
	ResizeWnd();
	SetBuffButtonTooltip();
	UpdateBuff();
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((isAreaState() == false))
	{
		return;
	}
	if((Event_ID == 1140))
	{
		HandlePartyAddParty(param);
	}
	else if((Event_ID == 1150))
	{
		HandlePartyUpdateParty(param);
	}
	else if((Event_ID == 1160))
	{
		HandlePartyDeleteParty(param);
	}
	else if((Event_ID == 1170))
	{
		HandlePartyDeleteAllParty();
	}
	else if(((Event_ID == 1180) || (Event_ID == 1050)))
	{
		HandlePartySpelledList(param);
	}
	else if((Event_ID == 1000))
	{
		HandleShowBuffIcon(param);
	}
	else if((Event_ID == 3131))
	{
		HandlePartySummonAdd(param);
	}
	else if((Event_ID == 3110))
	{
		HandlePartyPetAdd(param);
	}
	else if((Event_ID == 3132))
	{
		HandlePartySummonUpdate(param);
	}
	else if((Event_ID == 3120))
	{
		HandlePartyPetUpdate(param);
	}
	else if((Event_ID == 3133))
	{
		HandlePartySummonDelete(param);
	}
	else if((Event_ID == 3130))
	{
		HandlePartyPetDelete(param);
	}
	else if((Event_ID == 40))
	{
		HandleRestart();
	}
	else if((Event_ID == 980))
	{
		HandleCheckTarget();
	}
	else if((Event_ID == 1181))
	{
		HandlePartyRenameMember(param);
	}
	else if(((Event_ID == 1182) || (Event_ID == 1052)))
	{
		HandlePartySpelledListDelete(param);
	}
	else if(((Event_ID == 1183) || (Event_ID == 1053)))
	{
		HandlePartySpelledListInsert(param);
	}
	else if((Event_ID == 8000))
	{
		checkClassicForm();
	}
	else if((Event_ID == 3410))
	{
		if(((param == "ARENABATTLESTATE") && (m_CurCount > 0)))
		{
			m_wndTop.ShowWindow();
		}
	}
	else if((Event_ID == 8380))
	{
		ParseInt(param, "BattleType", currentBattleType);
	}
	else if((Event_ID == 8430))
	{
		transformedMemberID = -1;
	}
	return;
}

function OnCallUCFunction(string functionName, string param)
{
	switch(functionName)
	{
		case "addGroupMember":
			m_arrMatchGroupMember.Length = (m_arrMatchGroupMember.Length + 1);
			m_arrMatchGroupMember[(m_arrMatchGroupMember.Length - 1)] = int(param);
			break;
		case "resetGroupMember":
			m_arrMatchGroupMember.Length = 0;
			break;
		case "partyMemberTransformed":
			setTransForm(param);
			break;
		default:
			break;
	}
	return;
}

function bool isMatchGroupMember(int Id)
{
	local int i;

	i = 0;
	while((i < m_arrMatchGroupMember.Length))
	{
		if((m_arrMatchGroupMember[i] == Id))
		{
			return true;
		}
		i++;
	}
	return false;
}

function HandlePartyRenameMember(string param)
{
	local int idx, Id, UseVName, DominionIDForVName;
	local string VName, SummonVName;

	ParseInt(param, "ID", Id);
	ParseInt(param, "UseVName", UseVName);
	ParseInt(param, "DominionIDForVName", DominionIDForVName);
	ParseString(param, "VName", VName);
	ParseString(param, "SummonVName", SummonVName);
	idx = GetVNameIndexByID(Id);
	if((idx > -1))
	{
		m_Vname[idx].Id = Id;
		m_Vname[idx].UseVName = UseVName;
		m_Vname[idx].DominionIDForVName = DominionIDForVName;
		m_Vname[idx].VName = VName;
		m_Vname[idx].SummonVName = SummonVName;
		ExecuteEvent(980);
	}
	return;
}

function HandleCheckTarget()
{
	local int idx;

	idx = -1;
	m_targetID = Class'NWindow.UIDATA_TARGET'.static.GetTargetID();
	if((m_targetID > 0))
	{
		idx = FindPartyID(m_targetID);
	}
	if((m_LastChangeColor != -1))
	{
		m_PartyStatus[m_LastChangeColor].SetBackTexture("L2UI_CT1.Windows.Windows_DF_Small_Vertical_SizeControl_Bg_Darker");
		m_targetID = -1;
		m_LastChangeColor = -1;
	}
	if((idx != -1))
	{
		m_LastChangeColor = idx;
		m_PartyStatus[idx].SetBackTexture("L2UI_CT1.Windows.Windows_DF_Small_Vertical_SizeControl_Bg_Over");
	}
	return;
}

function HandleRestart()
{
	Clear();
	return;
}

function ClearTargetHighLight()
{
	local int i;

	i = 0;
	while((i < 10))
	{
		m_PartyStatus[i].SetBackTexture("L2UI_CT1.Windows.Windows_DF_Small_Vertical_SizeControl_Bg_Darker");
		i++;
	}
	m_LastChangeColor = -1;
	return;
}

function Clear()
{
	local int idx;

	idx = 0;
	while((idx < 10))
	{
		ClearStatus(idx);
		ClearPetStatus(idx);
		ClearSummonStatus(idx);
		m_arrSummonID[idx] = -1;
		idx++;
	}
	currentindex = 0;
	matchGroupCount = 0;
	partyCount = 0;
	m_CurCount = 0;
	m_targetID = -1;
	m_LastChangeColor = -1;
	ResizeWnd();
	ClearTargetHighLight();
	return;
}

function ClearStatus(int idx)
{
	m_StatusIconBuff[idx].Clear();
	m_StatusIconDeBuff[idx].Clear();
	m_StatusIconSongDance[idx].Clear();
	m_StatusIconTriggerSkill[idx].Clear();
	m_PlayerName[idx].SetName("", NCT_Normal, TA_Left);
	m_LeaderIcon[idx].SetTexture("");
	m_ClassIcon[idx].SetTexture("");
	UpdateHPBar(idx, 0, 0);
	UpdateMPBar(idx, 0, 0);
	m_arrID[idx] = 0;
	return;
}

function ClearPetStatus(int idx)
{
	m_PetStatusIconBuff[idx].Clear();
	m_PetStatusIconDeBuff[idx].Clear();
	m_PetStatusIconSongDance[idx].Clear();
	m_PetStatusIconTriggerSkill[idx].Clear();
	m_PetClassIcon[idx].HideWindow();
	UpdateHPBar((idx + 100), 0, 0);
	UpdateMPBar((idx + 100), 0, 0);
	m_arrPetID[idx] = -1;
	m_arrPetIDOpen[idx] = -1;
	m_arrSummonID[idx] = -1;
	return;
}

function ClearSummonStatus(int idx)
{
	m_arrSummonID[idx] = -1;
	m_ClassIconSummon[idx].HideWindow();
	m_ClassIconSummonNum[idx].HideWindow();
	return;
}

function CopyStatus(int DesIndex, int SrcIndex)
{
	local string strTmp;
	local int MaxValue, CurValue, Width, Height, Row, Col, maxrow, MaxCol;
	local StatusIconInfo Info;
	local CustomTooltip toolTipInfo, TooltipInfo2;
	local string vpIconTextureName, vpToolTipString;
	local Color NameColor;

	m_arrID[DesIndex] = m_arrID[SrcIndex];
	m_ClassIcon[DesIndex].SetTexture(m_ClassIcon[SrcIndex].GetTextureName());
	m_ClassIcon[SrcIndex].GetTooltipCustomType(toolTipInfo);
	m_ClassIcon[DesIndex].SetTooltipCustomType(toolTipInfo);
	strTmp = m_LeaderIcon[SrcIndex].GetTextureName();
	m_LeaderIcon[DesIndex].SetTexture(strTmp);
	if((Len(strTmp) > 0))
	{
		strTmp = m_PlayerName[DesIndex].GetName();
		GetTextSizeDefault(strTmp, Width, Height);
		m_LeaderIcon[DesIndex].ShowWindow();
	}
	m_LeaderIcon[SrcIndex].GetTooltipCustomType(TooltipInfo2);
	m_LeaderIcon[DesIndex].SetTooltipCustomType(TooltipInfo2);
	m_BarMP[SrcIndex].GetValue(MaxValue, CurValue);
	m_BarMP[DesIndex].SetValue(MaxValue, CurValue);
	m_BarHP[SrcIndex].GetValue(MaxValue, CurValue);
	m_BarHP[DesIndex].SetValue(MaxValue, CurValue);
	if((CurValue == 0))
	{
		m_IsDead[DesIndex].ShowWindow();
	}
	else
	{
		m_IsDead[DesIndex].HideWindow();
	}
	if(isMatchGroupMember(m_arrID[DesIndex]))
	{
		NameColor.R = 238;
		NameColor.G = 170;
		NameColor.B = 255;
		NameColor.A = 255;
	}
	else
	{
		NameColor = util.White;
	}
	m_PlayerName[DesIndex].SetNameWithColor(m_PlayerName[SrcIndex].GetName(), NCT_Normal, TA_Left, NameColor);
	vpIconTextureName = m_VPIcon[DesIndex].GetTextureName();
	vpToolTipString = m_VPIcon[DesIndex].GetTooltipText();
	m_VPIcon[DesIndex].SetTexture(m_VPIcon[SrcIndex].GetTextureName());
	m_VPIcon[DesIndex].SetTooltipText(m_VPIcon[SrcIndex].GetTooltipText());
	m_VPIcon[SrcIndex].SetTexture(vpIconTextureName);
	m_VPIcon[SrcIndex].SetTooltipText(vpToolTipString);
	m_StatusIconBuff[DesIndex].Clear();
	maxrow = m_StatusIconBuff[SrcIndex].GetRowCount();
	Row = 0;
	while((Row < maxrow))
	{
		m_StatusIconBuff[DesIndex].AddRow();
		MaxCol = m_StatusIconBuff[SrcIndex].GetColCount(Row);
		Col = 0;
		while((Col < MaxCol))
		{
			m_StatusIconBuff[SrcIndex].GetItem(Row, Col, Info);
			m_StatusIconBuff[DesIndex].AddCol(Row, Info);
			Col++;
		}
		Row++;
	}
	m_StatusIconDeBuff[DesIndex].Clear();
	maxrow = m_StatusIconDeBuff[SrcIndex].GetRowCount();
	Row = 0;
	while((Row < maxrow))
	{
		m_StatusIconDeBuff[DesIndex].AddRow();
		MaxCol = m_StatusIconDeBuff[SrcIndex].GetColCount(Row);
		Col = 0;
		while((Col < MaxCol))
		{
			m_StatusIconDeBuff[SrcIndex].GetItem(Row, Col, Info);
			Info.bHideRemainTime = true;
			m_StatusIconDeBuff[DesIndex].AddCol(Row, Info);
			Col++;
		}
		Row++;
	}
	m_StatusIconSongDance[DesIndex].Clear();
	maxrow = m_StatusIconSongDance[SrcIndex].GetRowCount();
	Row = 0;
	while((Row < maxrow))
	{
		m_StatusIconSongDance[DesIndex].AddRow();
		MaxCol = m_StatusIconSongDance[SrcIndex].GetColCount(Row);
		Col = 0;
		while((Col < MaxCol))
		{
			m_StatusIconSongDance[SrcIndex].GetItem(Row, Col, Info);
			m_StatusIconSongDance[DesIndex].AddCol(Row, Info);
			Col++;
		}
		Row++;
	}
	m_StatusIconTriggerSkill[DesIndex].Clear();
	maxrow = m_StatusIconTriggerSkill[SrcIndex].GetRowCount();
	Row = 0;
	while((Row < maxrow))
	{
		m_StatusIconTriggerSkill[DesIndex].AddRow();
		MaxCol = m_StatusIconTriggerSkill[SrcIndex].GetColCount(Row);
		Col = 0;
		while((Col < MaxCol))
		{
			m_StatusIconTriggerSkill[SrcIndex].GetItem(Row, Col, Info);
			m_StatusIconTriggerSkill[DesIndex].AddCol(Row, Info);
			Col++;
		}
		Row++;
	}
	m_arrPetID[DesIndex] = m_arrPetID[SrcIndex];
	m_arrSummonID[DesIndex] = m_arrSummonID[SrcIndex];
	m_arrPetIDOpen[DesIndex] = m_arrPetIDOpen[SrcIndex];
	m_PetBarHP[SrcIndex].GetValue(MaxValue, CurValue);
	m_PetBarHP[DesIndex].SetValue(MaxValue, CurValue);
	m_PetBarMP[SrcIndex].GetValue(MaxValue, CurValue);
	m_PetBarMP[DesIndex].SetValue(MaxValue, CurValue);
	m_PetStatusIconBuff[DesIndex].Clear();
	maxrow = m_PetStatusIconBuff[SrcIndex].GetRowCount();
	Row = 0;
	while((Row < maxrow))
	{
		m_PetStatusIconBuff[DesIndex].AddRow();
		MaxCol = m_PetStatusIconBuff[SrcIndex].GetColCount(Row);
		Col = 0;
		while((Col < MaxCol))
		{
			m_PetStatusIconBuff[SrcIndex].GetItem(Row, Col, Info);
			m_PetStatusIconBuff[DesIndex].AddCol(Row, Info);
			Col++;
		}
		Row++;
	}
	m_PetStatusIconDeBuff[DesIndex].Clear();
	maxrow = m_PetStatusIconDeBuff[SrcIndex].GetRowCount();
	Row = 0;
	while((Row < maxrow))
	{
		m_PetStatusIconDeBuff[DesIndex].AddRow();
		MaxCol = m_PetStatusIconDeBuff[SrcIndex].GetColCount(Row);
		Col = 0;
		while((Col < MaxCol))
		{
			m_PetStatusIconDeBuff[SrcIndex].GetItem(Row, Col, Info);
			Info.bHideRemainTime = true;
			m_PetStatusIconDeBuff[DesIndex].AddCol(Row, Info);
			Col++;
		}
		Row++;
	}
	m_PetStatusIconSongDance[DesIndex].Clear();
	maxrow = m_PetStatusIconSongDance[SrcIndex].GetRowCount();
	Row = 0;
	while((Row < maxrow))
	{
		m_PetStatusIconSongDance[DesIndex].AddRow();
		MaxCol = m_PetStatusIconSongDance[SrcIndex].GetColCount(Row);
		Col = 0;
		while((Col < MaxCol))
		{
			m_PetStatusIconSongDance[SrcIndex].GetItem(Row, Col, Info);
			m_PetStatusIconSongDance[DesIndex].AddCol(Row, Info);
			Col++;
		}
		Row++;
	}
	m_PetStatusIconTriggerSkill[DesIndex].Clear();
	maxrow = m_PetStatusIconTriggerSkill[SrcIndex].GetRowCount();
	Row = 0;
	while((Row < maxrow))
	{
		m_PetStatusIconTriggerSkill[DesIndex].AddRow();
		MaxCol = m_PetStatusIconTriggerSkill[SrcIndex].GetColCount(Row);
		Col = 0;
		while((Col < MaxCol))
		{
			m_PetStatusIconTriggerSkill[SrcIndex].GetItem(Row, Col, Info);
			m_PetStatusIconTriggerSkill[DesIndex].AddCol(Row, Info);
			Col++;
		}
		Row++;
	}
	ClearTargetHighLight();
	HandleCheckTarget();
	return;
}

function resizeOnly()
{
	local int idx;
	local Rect rectWnd;
	local bool bOption;
	local int i, OpenPetCount;
	local PartyMemberInfo PartyMemberInfo;
	local int tmpInt;

	GetINIInt("PartyWndArena", "e", tmpInt, "Windowsinfo.ini");
	bOption = bool(tmpInt);
	if((m_CurCount > 0))
	{
		idx = 0;
		while((idx < 10))
		{
			if((idx <= (m_CurCount - 1)))
			{
				if((idx > 0))
				{
					if((m_arrPetIDOpen[(idx - 1)] == 1))
					{
						m_PartyStatus[idx].SetAnchor(("PartyWndArena.PartyStatusSummonWnd" $ string((idx - 1))), "BottomLeft", "TopLeft", 0, -4);
					}
					else
					{
						m_PartyStatus[idx].SetAnchor(("PartyWndArena.PartyStatusWnd" $ string((idx - 1))), "BottomLeft", "TopLeft", 0, -4);
					}
				}
				if((m_arrID[idx] != 0))
				{
					if((m_arrPetIDOpen[idx] > -1))
					{
						m_petButton[idx].ShowWindow();
					}
					else
					{
						m_petButton[idx].HideWindow();
					}
					m_PartyStatus[idx].SetVirtualDrag(true);
					m_PartyStatus[idx].ShowWindow();
				}
				GetPartyMemberInfo(m_arrID[idx], PartyMemberInfo);
				if(((PartyMemberInfo.curSummonNum > 0) || PartyMemberInfo.curHavePet))
				{
					if((m_arrPetIDOpen[idx] == -1))
					{
						m_arrPetIDOpen[idx] = 1;
					}
					m_PetPartyStatus[idx].ShowWindow();
					if((PartyMemberInfo.curSummonNum > 0))
					{
						m_ClassIconSummon[idx].ShowWindow();
						setHideClassIconSummonNum(idx);
						m_ClassIconSummonNum[idx].SetTexture(("L2UI_ch3.PartyWndArena.party_summmon_num" $ string(PartyMemberInfo.curSummonNum)));
					}
					else
					{
						m_ClassIconSummon[idx].HideWindow();
						m_ClassIconSummonNum[idx].HideWindow();
					}
					if(PartyMemberInfo.curHavePet)
					{
						m_PetBarMP[idx].ShowWindow();
						m_PetBarHP[idx].ShowWindow();
						m_PetClassIcon[idx].ShowWindow();
					}
					else
					{
						m_PetBarMP[idx].HideWindow();
						m_PetBarHP[idx].HideWindow();
						m_PetClassIcon[idx].HideWindow();
					}
				}
				else
				{
					m_PetPartyStatus[idx].HideWindow();
					m_arrPetIDOpen[idx] = -1;
				}
				idx++;
				continue;
			}
			m_petButton[idx].HideWindow();
			m_PartyStatus[idx].SetVirtualDrag(false);
			m_PartyStatus[idx].HideWindow();
			m_PetPartyStatus[idx].HideWindow();
			idx++;
		}
		OpenPetCount = 0;
		i = 0;
		while((i < 10))
		{
			if((m_arrPetIDOpen[i] == 1))
			{
				OpenPetCount++;
				i++;
				continue;
			}
			if(m_PetPartyStatus[i].IsShowWindow())
			{
				m_PetPartyStatus[i].HideWindow();
			}
			i++;
		}
		rectWnd = m_wndTop.GetRect();
		m_wndTop.SetWindowSize(rectWnd.nWidth, ((42 * m_CurCount) + (OpenPetCount * 18)));
		m_wndTop.SetResizeFrameSize(10, ((42 * m_CurCount) + (OpenPetCount * 18)));
	}
	else
	{
		m_wndTop.HideWindow();
	}
	return;
}

function ResizeWnd()
{
	local int idx;
	local Rect rectWnd;
	local bool bOption;
	local int i, OpenPetCount;
	local PartyMemberInfo PartyMemberInfo;
	local int tmpInt;

	GetINIInt("PartyWndArena", "e", tmpInt, "Windowsinfo.ini");
	bOption = bool(tmpInt);
	if((m_CurCount > 0))
	{
		idx = 0;
		while((idx < 10))
		{
			if((idx <= (m_CurCount - 1)))
			{
				if((idx > 0))
				{
					if((m_arrPetIDOpen[(idx - 1)] == 1))
					{
						m_PartyStatus[idx].SetAnchor(("PartyWndArena.PartyStatusSummonWnd" $ string((idx - 1))), "BottomLeft", "TopLeft", 0, -4);
					}
					else
					{
						m_PartyStatus[idx].SetAnchor(("PartyWndArena.PartyStatusWnd" $ string((idx - 1))), "BottomLeft", "TopLeft", 0, -4);
					}
				}
				if((m_arrID[idx] != 0))
				{
					if((m_arrPetIDOpen[idx] > -1))
					{
						m_petButton[idx].ShowWindow();
					}
					else
					{
						m_petButton[idx].HideWindow();
					}
					m_PartyStatus[idx].SetVirtualDrag(true);
					m_PartyStatus[idx].ShowWindow();
				}
				GetPartyMemberInfo(m_arrID[idx], PartyMemberInfo);
				if(((PartyMemberInfo.curSummonNum > 0) || PartyMemberInfo.curHavePet))
				{
					if((m_arrPetIDOpen[idx] == -1))
					{
						m_arrPetIDOpen[idx] = 1;
					}
					m_PetPartyStatus[idx].ShowWindow();
					if((PartyMemberInfo.curSummonNum > 0))
					{
						m_ClassIconSummon[idx].ShowWindow();
						setHideClassIconSummonNum(idx);
						m_ClassIconSummonNum[idx].SetTexture(("L2UI_ch3.PartyWndArena.party_summmon_num" $ string(PartyMemberInfo.curSummonNum)));
					}
					else
					{
						m_ClassIconSummon[idx].HideWindow();
						m_ClassIconSummonNum[idx].HideWindow();
					}
					if(PartyMemberInfo.curHavePet)
					{
						m_PetBarMP[idx].ShowWindow();
						m_PetBarHP[idx].ShowWindow();
						m_PetClassIcon[idx].ShowWindow();
					}
					else
					{
						m_PetBarMP[idx].HideWindow();
						m_PetBarHP[idx].HideWindow();
						m_PetClassIcon[idx].HideWindow();
					}
				}
				else
				{
					m_PetPartyStatus[idx].HideWindow();
					m_arrPetIDOpen[idx] = -1;
				}
				idx++;
				continue;
			}
			m_petButton[idx].HideWindow();
			m_PartyStatus[idx].SetVirtualDrag(false);
			m_PartyStatus[idx].HideWindow();
			m_PetPartyStatus[idx].HideWindow();
			idx++;
		}
		OpenPetCount = 0;
		i = 0;
		while((i < 10))
		{
			if((m_arrPetIDOpen[i] == 1))
			{
				OpenPetCount++;
				i++;
				continue;
			}
			if(m_PetPartyStatus[i].IsShowWindow())
			{
				m_PetPartyStatus[i].HideWindow();
			}
			i++;
		}
		rectWnd = m_wndTop.GetRect();
		m_wndTop.SetWindowSize(rectWnd.nWidth, ((42 * m_CurCount) + (OpenPetCount * 18)));
		m_wndTop.SetResizeFrameSize(10, ((42 * m_CurCount) + (OpenPetCount * 18)));
		m_wndTop.ShowWindow();
	}
	else
	{
		m_wndTop.HideWindow();
	}
	return;
}

function int FindPartyID(int Id)
{
	local int idx;

	idx = 0;
	while((idx < 10))
	{
		if((m_arrID[idx] == Id))
		{
			return idx;
		}
		idx++;
	}
	return -1;
}

function int FindPetID(int Id)
{
	local int idx;

	idx = 0;
	while((idx < 10))
	{
		if((m_arrPetID[idx] == Id))
		{
			return idx;
		}
		idx++;
	}
	return -1;
}

function int FindSummonMasterID(int Id)
{
	local int idx;

	idx = 0;
	while((idx < 10))
	{
		if((m_arrSummonID[idx] == Id))
		{
			return idx;
		}
		idx++;
	}
	return -1;
}

function HandlePartyAddParty(string param)
{
	local int Id, SummonID, UseVName, DominionIDForVName, SummonCount;
	local string VName, SummonVName;
	local PartyMemberInfo PartyMemberInfo;
	local PartyMemberPetInfo PartyMemberPetInfo;
	local int Index, i, summonClassID, summonType, summonMAXHP, summonMAXMP, summonHP, summonMP;

	ParseInt(param, "ID", Id);
	ParseInt(param, "SummonID", SummonID);
	ParseInt(param, "UseVName", UseVName);
	ParseInt(param, "DominionIDForVName", DominionIDForVName);
	ParseString(param, "SummonVName", SummonVName);
	GetPartyMemberInfo(Id, PartyMemberInfo);
	GetPartyMemberPetInfo(Id, PartyMemberPetInfo);
	if((Id > 0))
	{
		if(isMatchGroupMember(Id))
		{
			currentindex = matchGroupCount;
			matchGroupCount++;
		}
		else
		{
			currentindex = (m_arrMatchGroupMember.Length + partyCount);
			partyCount++;
		}
		m_CurCount++;
		m_Vname[currentindex].Id = Id;
		m_Vname[currentindex].UseVName = UseVName;
		m_Vname[currentindex].DominionIDForVName = DominionIDForVName;
		m_Vname[currentindex].VName = VName;
		m_Vname[currentindex].SummonVName = SummonVName;
		ExecuteEvent(980);
		m_arrID[currentindex] = Id;
		UpdateStatus(currentindex, param);
		if((PartyMemberInfo.curSummonNum > 0))
		{
			PartySummonProcess(Id);
			i = 0;
			while((i < SummonCount))
			{
				ParseInt(param, ("SummonType" $ string(i)), summonType);
				ParseInt(param, ("SummonClassID" $ string(i)), summonClassID);
				if((summonType == 1))
				{
					m_ClassIconSummon[currentindex].SetTooltipText(GetSystemString(505));
					break;
				}
				i++;
			}
		}
		if((PartyMemberInfo.curHavePet == true))
		{
			Index = FindPartyID(Id);
			ParseInt(param, "SummonCount", SummonCount);
			i = 0;
			while((i < SummonCount))
			{
				ParseInt(param, ("SummonType" $ string(i)), summonType);
				if((summonType == 2))
				{
					ParseInt(param, ("SummonMaxHP" $ string(i)), summonMAXHP);
					ParseInt(param, ("SummonMaxMP" $ string(i)), summonMAXMP);
					ParseInt(param, ("SummonHP" $ string(i)), summonHP);
					ParseInt(param, ("SummonMP" $ string(i)), summonMP);
					UpdateHPBar((Index + 100), summonHP, summonMAXHP);
					UpdateMPBar((Index + 100), summonMP, summonMAXMP);
				}
				i++;
			}
			m_arrPetID[Index] = PartyMemberPetInfo.petServerID;
		}
		ResizeWnd();
	}
	return;
}

function HandlePartyUpdateParty(string param)
{
	local int Id, idx;

	ParseInt(param, "ID", Id);
	if((Id > 0))
	{
		idx = FindPartyID(Id);
		UpdateStatus(idx, param);
	}
	return;
}

function HandlePartyDeleteParty(string param)
{
	local int Id, idx, i;

	ParseInt(param, "ID", Id);
	if((Id > 0))
	{
		idx = FindPartyID(Id);
		if((idx > -1))
		{
			if(isMatchGroupMember(Id))
			{
				matchGroupCount--;
			}
			else
			{
				partyCount--;
			}
			i = idx;
			while((i < (m_CurCount - 1)))
			{
				CopyStatus(i, (i + 1));
				i++;
			}
			ClearStatus((m_CurCount - 1));
			ClearPetStatus((m_CurCount - 1));
			m_CurCount--;
			ResizeWnd();
		}
	}
	return;
}

function HandlePartyDeleteAllParty()
{
	Clear();
	return;
}

function SetMasterTooltip(int Lootingtype)
{
	if(((partymasteridx < 10) && (partymasteridx > -1)))
	{
		m_LeaderIcon[partymasteridx].SetTooltipCustomType(MakeTooltipSimpleText(GetRoutingString(Lootingtype)));
	}
	return;
}

function UpdateStatus(int idx, string param)
{
	local string Name;
	local int Id, CP, maxCP, Hp, MaxHP, MP, maxMP, ClassID, Level, vitality, UseVName;
	local string VName;
	local int SummonCount, iSubstatus;
	local Color NameColor;

	ParseInt(param, "SubStitute", iSubstatus);
	if(((idx < 0) || (idx >= 10)))
	{
		return;
	}
	ParseString(param, "Name", Name);
	ParseInt(param, "ID", Id);
	ParseInt(param, "CurCP", CP);
	ParseInt(param, "MaxCP", maxCP);
	ParseInt(param, "CurHP", Hp);
	ParseInt(param, "MaxHP", MaxHP);
	ParseInt(param, "CurMP", MP);
	ParseInt(param, "MaxMP", maxMP);
	ParseInt(param, "ClassID", ClassID);
	ParseInt(param, "Level", Level);
	ParseInt(param, "Vitality", vitality);
	ParseInt(param, "SummonCount", SummonCount);
	if(isMatchGroupMember(Id))
	{
		NameColor.R = 238;
		NameColor.G = 170;
		NameColor.B = 255;
		NameColor.A = 255;
	}
	else
	{
		NameColor = util.White;
	}
	if((Hp == 0))
	{
		m_IsDead[idx].ShowWindow();
	}
	else
	{
		m_IsDead[idx].HideWindow();
	}
	UseVName = m_Vname[idx].UseVName;
	VName = m_Vname[idx].VName;
	if((UseVName == 1))
	{
		m_PlayerName[idx].SetNameWithColor(VName, NCT_Normal, TA_Left, NameColor);
	}
	else
	{
		m_PlayerName[idx].SetNameWithColor(Name, NCT_Normal, TA_Left, NameColor);
	}
	if((transformedMemberID == -1))
	{
		m_ClassIcon[idx].SetTexture(GetClassArenaRoleIconName(ClassID));
	}
	else
	{
		setTransFormTexture(transformedMemberID);
	}
	m_ClassIcon[idx].SetTooltipCustomType(MakeTooltipSimpleText(((GetClassRoleName(ClassID) $ " - ") $ GetClassType(ClassID))));
	UpdateHPBar(idx, Hp, MaxHP);
	UpdateMPBar(idx, MP, maxMP);
	return;
}

function setTransForm(string param)
{
	local int UserID, Type;

	ParseInt(param, "userID", UserID);
	ParseInt(param, "teamNum", transFormedType);
	ParseInt(param, "type", Type);
	switch(Type)
	{
		case 4:
			setTransFormTexture(UserID);
			break;
		case 5:
			setClassTexture(UserID);
			break;
		default:
			break;
	}
	return;
}

function setClassTexture(int UserID)
{
	local string TextureName;
	local PartyMemberInfo PartyMemberInfo;
	local int idx;

	GetPartyMemberInfo(UserID, PartyMemberInfo);
	idx = FindPartyID(UserID);
	if((idx == -1))
	{
		return;
	}
	TextureName = GetClassArenaRoleIconName(PartyMemberInfo.ClassID);
	m_ClassIcon[idx].SetTexture(TextureName);
	transformedMemberID = -1;
	return;
}

function setTransFormTexture(int UserID)
{
	local string TextureName;
	local int idx;

	idx = FindPartyID(UserID);
	if((idx == -1))
	{
		return;
	}
	transformedMemberID = UserID;
	switch(transFormedType)
	{
		case 0:
			TextureName = "L2UI.TheArena.party_styleicon_teamDragon_Arena";
			break;
		case 1:
			TextureName = "L2UI.TheArena.party_styleicon_teamSlayer_Arena";
			break;
		default:
			break;
	}
	m_ClassIcon[idx].SetTexture(TextureName);
	return;
}

function HandlePartyPetAdd(string param)
{
	local int MasterID, Id, i, Type, MasterIndex;

	ParseInt(param, "Type", Type);
	if((Type == 2))
	{
		ParseInt(param, "MasterID", MasterID);
		ParseInt(param, "ID", Id);
		if((MasterID > 0))
		{
			MasterIndex = -1;
			i = 0;
			while((i < 10))
			{
				if((m_arrID[i] == MasterID))
				{
					MasterIndex = i;
				}
				i++;
			}
			if((MasterIndex == -1))
			{
				return;
			}
			m_arrPetID[MasterIndex] = Id;
			m_arrPetIDOpen[MasterIndex] = 1;
			UpdatePetStatus(MasterIndex, param);
			ResizeWnd();
		}
	}
	return;
}

function HandlePartyPetUpdate(string param)
{
	local int Id, idx, Type;

	ParseInt(param, "Type", Type);
	ParseInt(param, "ID", Id);
	if((Type == 2))
	{
		idx = FindPetID(Id);
		UpdatePetStatus(idx, param);
	}
	return;
}

function HandlePartyPetDelete(string param)
{
	local int SummonID, idx;

	ParseInt(param, "SummonID", SummonID);
	if((SummonID > 0))
	{
		idx = FindPetID(SummonID);
		if((idx > -1))
		{
			ClearPetStatus(idx);
			ResizeWnd();
		}
	}
	return;
}

function UpdatePetStatus(int idx, string param)
{
	local int Id, ClassID, Type, MasterID, Hp, MaxHP, MP, maxMP, Level;

	if(((idx < 0) || (idx >= 10)))
	{
		return;
	}
	ParseInt(param, "ID", Id);
	ParseInt(param, "ClassID", ClassID);
	ParseInt(param, "Type", Type);
	ParseInt(param, "MasterID", MasterID);
	ParseInt(param, "HP", Hp);
	ParseInt(param, "MaxHP", MaxHP);
	ParseInt(param, "MP", MP);
	ParseInt(param, "MaxMP", maxMP);
	ParseInt(param, "Level", Level);
	UpdateHPBar((idx + 100), Hp, MaxHP);
	UpdateMPBar((idx + 100), MP, maxMP);
	return;
}

function HandlePartySummonAdd(string param)
{
	local int MasterID, Id, idx, Type;
	local SummonInfo m_SummonInfo;

	ParseInt(param, "Type", Type);
	ParseInt(param, "MasterID", MasterID);
	ParseInt(param, "ID", Id);
	GetSummonInfo(Id, m_SummonInfo);
	idx = FindSummonMasterID(MasterID);
	if((idx > 0))
	{
		m_ClassIconSummon[idx].SetTooltipText(GetSystemString(505));
	}
	if((Type == 1))
	{
		PartySummonProcess(MasterID);
	}
	return;
}

function PartySummonProcess(int MasterID)
{
	local int i, MasterIndex;
	local PartyMemberInfo PartyMemberInfo;

	if((MasterID > 0))
	{
		MasterIndex = -1;
		i = 0;
		while((i < 10))
		{
			if((m_arrID[i] == MasterID))
			{
				MasterIndex = i;
				break;
			}
			i++;
		}
		if((MasterIndex == -1))
		{
			return;
		}
		GetPartyMemberInfo(MasterID, PartyMemberInfo);
		if((PartyMemberInfo.curSummonNum > 0))
		{
			m_arrSummonID[MasterIndex] = MasterID;
		}
		else
		{
			m_arrSummonID[MasterIndex] = -1;
		}
		ResizeWnd();
	}
	return;
}

function HandlePartySummonUpdate(string param)
{
	local int MasterID, Type;

	ParseInt(param, "MasterID", MasterID);
	ParseInt(param, "Type", Type);
	if((Type == 1))
	{
		PartySummonProcess(MasterID);
	}
	return;
}

function HandlePartySummonDelete(string param)
{
	local int SummonMasterID, idx;
	local PartyMemberInfo PartyMemberInfo;

	ParseInt(param, "SummonMasterID", SummonMasterID);
	if((SummonMasterID > 0))
	{
		idx = FindSummonMasterID(SummonMasterID);
		GetPartyMemberInfo(SummonMasterID, PartyMemberInfo);
		if((PartyMemberInfo.curSummonNum > 0))
		{
			m_ClassIconSummon[idx].ShowWindow();
			setHideClassIconSummonNum(idx);
			m_ClassIconSummonNum[idx].SetTexture(("L2UI_ch3.PartyWndArena.party_summmon_num" $ string(PartyMemberInfo.curSummonNum)));
		}
		else
		{
			ClearSummonStatus(idx);
		}
		ResizeWnd();
	}
	return;
}

function UpdateSummonStatus(int idx, string param)
{
	local int Id, ClassID, Type, MasterID, Hp, MaxHP, MP, maxMP, Level;

	if(((idx < 0) || (idx >= 10)))
	{
		return;
	}
	ParseInt(param, "ID", Id);
	ParseInt(param, "ClassID", ClassID);
	ParseInt(param, "Type", Type);
	ParseInt(param, "MasterID", MasterID);
	ParseInt(param, "HP", Hp);
	ParseInt(param, "MaxHP", MaxHP);
	ParseInt(param, "MP", MP);
	ParseInt(param, "MaxMP", maxMP);
	ParseInt(param, "Level", Level);
	return;
}

function HandlePartySpelledList(string param)
{
	UpdateBuff();
	return;
}

function HandlePartySpelledListDelete(string param)
{
	UpdateBuff();
	return;
}

function deleteBuff(StatusIconHandle tmpStatusIcon, int Level, int ClassID, int SpellerID)
{
	local int Row, Col;
	local StatusIconInfo Info;

	Row = 0;
	while((Row < tmpStatusIcon.GetRowCount()))
	{
		Col = 0;
		while((Col < tmpStatusIcon.GetColCount(Row)))
		{
			tmpStatusIcon.GetItem(Row, Col, Info);
			if((((Info.Id.ClassID == ClassID) && (Info.Level == Level)) && (Info.SpellerID == SpellerID)))
			{
				tmpStatusIcon.DelItem(Row, Col);
				refreshPostion(tmpStatusIcon, Row);
				return;
			}
			Col++;
		}
		Row++;
	}
	return;
}

function refreshPostion(StatusIconHandle tmpStatusIcon, int deletedRow)
{
	local int Row;
	local StatusIconInfo Info;

	Row = deletedRow;
	while((Row < (tmpStatusIcon.GetRowCount() - 1)))
	{
		tmpStatusIcon.GetItem((Row + 1), 0, Info);
		tmpStatusIcon.AddCol(Row, Info);
		tmpStatusIcon.DelItem((Row + 1), 0);
		Row++;
	}
	return;
}

function HandlePartySpelledListInsert(string param)
{
	local int i, idx, Id, Max;
	local StatusIconInfo Info;
	local StatusIconHandle tmpStatusIcon;
	local bool isPC;

	ParseInt(param, "ID", Id);
	if((Id < 1))
	{
		return;
	}
	idx = FindPartyID(Id);
	if((idx < 0))
	{
		isPC = false;
		idx = FindPetID(Id);
	}
	else
	{
		isPC = true;
	}
	if((idx < 0))
	{
		return;
	}
	if(isPC)
	{
		Info.Size = 16;
	}
	else
	{
		Info.Size = 10;
	}
	Info.bShow = true;
	ParseInt(param, "Max", Max);
	i = 0;
	while((i < Max))
	{
		ParseItemIDWithIndex(param, Info.Id, i);
		ParseInt(param, ("Level_" $ string(i)), Info.Level);
		ParseInt(param, ("SubLevel_" $ string(i)), Info.SubLevel);
		if(IsIconHide(Info.Id, Info.Level, Info.SubLevel))
		{
			i++;
			continue;
		}
		if(Class'NWindow.UIDATA_SKILL'.static.IsToppingSkill(Info.Id, Info.Level, Info.SubLevel))
		{
			i++;
			continue;
		}
		ParseInt(param, ("Sec_" $ string(i)), Info.RemainTime);
		ParseInt(param, ("SpellerID_" $ string(i)), Info.SpellerID);
		if(IsValidItemID(Info.Id))
		{
			Info.IconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(Info.Id, Info.Level, Info.SubLevel);
			Info.bHideRemainTime = true;
			if((GetDebuffType(Info.Id, Info.Level, Info.SubLevel) != 0))
			{
				if(isPC)
				{
					tmpStatusIcon = m_StatusIconDeBuff[idx];
				}
				else
				{
					tmpStatusIcon = m_PetStatusIconDeBuff[idx];
				}
			}
			else if((IsSongDance(Info.Id, Info.Level, Info.SubLevel) == true))
			{
				if(isPC)
				{
					tmpStatusIcon = m_StatusIconSongDance[idx];
				}
				else
				{
					tmpStatusIcon = m_PetStatusIconSongDance[idx];
				}
			}
			else if((IsTriggerSkill(Info.Id, Info.Level, Info.SubLevel) == true))
			{
				if(isPC)
				{
					tmpStatusIcon = m_StatusIconTriggerSkill[idx];
				}
				else
				{
					tmpStatusIcon = m_PetStatusIconTriggerSkill[idx];
				}
			}
			else if(isPC)
			{
				tmpStatusIcon = m_StatusIconBuff[idx];
			}
			else
			{
				tmpStatusIcon = m_PetStatusIconBuff[idx];
			}
			deleteBuff(tmpStatusIcon, Info.Level, Info.Id.ClassID, Info.SpellerID);
			if(((tmpStatusIcon.GetRowCount() == 0) || ((float(tmpStatusIcon.GetColCount((tmpStatusIcon.GetRowCount() - 1))) % 12.0000000) == 0.0000000)))
			{
				tmpStatusIcon.AddRow();
			}
			tmpStatusIcon.AddCol((tmpStatusIcon.GetRowCount() - 1), Info);
		}
		i++;
	}
	UpdateBuff();
	return;
}

function HandleShowBuffIcon(string param)
{
	local int nShow;

	ParseInt(param, "Show", nShow);
	m_CurBf = (m_CurBf + 1);
	if((m_CurBf > 4))
	{
		m_CurBf = 0;
	}
	SetINIInt("PartyWndArena", "a", m_CurBf, "WindowsInfo.ini");
	SetBuffButtonTooltip();
	UpdateBuff();
	return;
}

function OnClickButton(string strID)
{
	local int idx;

	switch(strID)
	{
		case "btnBuff":
			OnBuffButton();
			break;
		case "btnCompact":
			OnOpenPartyWndOption();
			break;
		case "btnSummon":
			break;
		default:
			break;
	}
	if((InStr(strID, "btnSummon") > -1))
	{
		idx = int(Right(strID, 1));
		if(m_PetPartyStatus[idx].IsShowWindow())
		{
			m_PetPartyStatus[idx].HideWindow();
			m_arrPetIDOpen[idx] = 2;
		}
		else
		{
			m_PetPartyStatus[idx].ShowWindow();
			m_arrPetIDOpen[idx] = 1;
		}
		ResizeWnd();
	}
	return;
}

function OnOpenPartyWndOption()
{
	local int i;
	local PartyWndOption Script;

	Script = PartyWndOption(GetScript("PartyWndOption"));
	i = 0;
	while((i < 10))
	{
		Script.m_arrPetIDOpen[i] = m_arrPetIDOpen[i];
		i++;
	}
	Script.ShowPartyWndOption();
	m_PartyOption.SetAnchor("PartyWndArena.PartyStatusWnd0", "TopRight", "TopLeft", 5, 5);
	return;
}

function OnBuffButton()
{
	m_CurBf = (m_CurBf + 1);
	if((m_CurBf > 4))
	{
		m_CurBf = 0;
	}
	SetINIInt("PartyWndArena", "a", m_CurBf, "WindowsInfo.ini");
	SetBuffButtonTooltip();
	UpdateBuff();
	return;
}

function UpdateBuff()
{
	local int idx;

	if((m_CurBf == 1))
	{
		idx = 0;
		while((idx < 10))
		{
			m_StatusIconBuff[idx].ShowWindow();
			m_PetStatusIconBuff[idx].ShowWindow();
			m_StatusIconDeBuff[idx].HideWindow();
			m_PetStatusIconDeBuff[idx].HideWindow();
			m_StatusIconSongDance[idx].HideWindow();
			m_PetStatusIconSongDance[idx].HideWindow();
			m_StatusIconTriggerSkill[idx].HideWindow();
			m_PetStatusIconTriggerSkill[idx].HideWindow();
			idx++;
		}
	}
	else if((m_CurBf == 2))
	{
		idx = 0;
		while((idx < 10))
		{
			m_StatusIconBuff[idx].HideWindow();
			m_PetStatusIconBuff[idx].HideWindow();
			m_StatusIconDeBuff[idx].ShowWindow();
			m_PetStatusIconDeBuff[idx].ShowWindow();
			m_StatusIconSongDance[idx].HideWindow();
			m_PetStatusIconSongDance[idx].HideWindow();
			m_StatusIconTriggerSkill[idx].HideWindow();
			m_PetStatusIconTriggerSkill[idx].HideWindow();
			idx++;
		}
	}
	else if((m_CurBf == 3))
	{
		idx = 0;
		while((idx < 10))
		{
			m_StatusIconBuff[idx].HideWindow();
			m_PetStatusIconBuff[idx].HideWindow();
			m_StatusIconDeBuff[idx].HideWindow();
			m_PetStatusIconDeBuff[idx].HideWindow();
			m_StatusIconSongDance[idx].ShowWindow();
			m_PetStatusIconSongDance[idx].ShowWindow();
			m_StatusIconTriggerSkill[idx].HideWindow();
			m_PetStatusIconTriggerSkill[idx].HideWindow();
			idx++;
		}
	}
	else if((m_CurBf == 4))
	{
		idx = 0;
		while((idx < 10))
		{
			m_StatusIconBuff[idx].HideWindow();
			m_PetStatusIconBuff[idx].HideWindow();
			m_StatusIconDeBuff[idx].HideWindow();
			m_PetStatusIconDeBuff[idx].HideWindow();
			m_StatusIconSongDance[idx].HideWindow();
			m_PetStatusIconSongDance[idx].HideWindow();
			m_StatusIconTriggerSkill[idx].ShowWindow();
			m_PetStatusIconTriggerSkill[idx].ShowWindow();
			idx++;
		}
	}
	else
	{
		idx = 0;
		while((idx < 10))
		{
			m_StatusIconBuff[idx].HideWindow();
			m_PetStatusIconBuff[idx].HideWindow();
			m_StatusIconDeBuff[idx].HideWindow();
			m_PetStatusIconDeBuff[idx].HideWindow();
			m_StatusIconSongDance[idx].HideWindow();
			m_PetStatusIconSongDance[idx].HideWindow();
			m_StatusIconTriggerSkill[idx].HideWindow();
			m_PetStatusIconTriggerSkill[idx].HideWindow();
			idx++;
		}
	}
	return;
}

function UpdateHPBar(int idx, int Value, int MaxValue)
{
	if((idx < 100))
	{
		m_BarHP[idx].SetValue(MaxValue, Value);
	}
	else
	{
		m_PetBarHP[(idx - 100)].SetValue(MaxValue, Value);
	}
	return;
}

function UpdateMPBar(int idx, int Value, int MaxValue)
{
	if((idx < 100))
	{
		m_BarMP[idx].SetValue(MaxValue, Value);
	}
	else
	{
		m_PetBarMP[(idx - 100)].SetValue(MaxValue, Value);
	}
	return;
}

function OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	local Rect rectWnd, rectPetClassIcon;
	local UserInfo UserInfo;
	local int idx;

	rectWnd = m_wndTop.GetRect();
	if(((X > (rectWnd.nX + 13)) && (X < ((rectWnd.nX + rectWnd.nWidth) - 10))))
	{
		if(GetPlayerInfo(UserInfo))
		{
			idx = GetIdx((Y - rectWnd.nY));
			rectWnd = m_PetPartyStatus[idx].GetRect();
			rectPetClassIcon = m_PetClassIcon[idx].GetRect();
			if(IsPKMode())
			{
				if((idx < 100))
				{
					RequestAttack(m_arrID[idx], UserInfo.Loc);
				}
				else if(((X > rectPetClassIcon.nX) && (X < ((rectWnd.nX + rectWnd.nWidth) - 10))))
				{
					RequestAttack(m_arrPetID[(idx - 100)], UserInfo.Loc);
				}
			}
			else if((idx < 100))
			{
				RequestAction(m_arrID[idx], UserInfo.Loc);
			}
			else if(((X > rectPetClassIcon.nX) && (X < ((rectWnd.nX + rectWnd.nWidth) - 10))))
			{
				RequestAction(m_arrPetID[(idx - 100)], UserInfo.Loc);
			}
		}
	}
	return;
}

function OnRButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	local Rect rectWnd;
	local UserInfo UserInfo;
	local int idx;

	rectWnd = m_wndTop.GetRect();
	if(((X > (rectWnd.nX + 13)) && (X < ((rectWnd.nX + rectWnd.nWidth) - 10))))
	{
		if(GetPlayerInfo(UserInfo))
		{
			idx = GetIdx((Y - rectWnd.nY));
			if((idx < 100))
			{
				RequestAssist(m_arrID[idx], UserInfo.Loc);
			}
			else
			{
				RequestAssist(m_arrPetID[(idx - 100)], UserInfo.Loc);
			}
		}
	}
	return;
}

function int GetIdx(int Y)
{
	local int tempY, i, idx;

	idx = -1;
	tempY = Y;
	i = 0;
	while((i < 10))
	{
		tempY = (tempY - 42);
		if((tempY < 0))
		{
			idx = i;
			return idx;
			i++;
			continue;
		}
		if((m_arrPetIDOpen[i] == 1))
		{
			tempY = (tempY - 18);
			if((tempY < 0))
			{
				idx = (i + 100);
				return idx;
			}
		}
		i++;
	}
	return idx;
}

function SetBuffButtonTooltip()
{
	local int idx;

	switch(m_CurBf)
	{
		case 0:
			idx = 1496;
			break;
		case 1:
			idx = 1497;
			break;
		case 2:
			idx = 1741;
			break;
		case 3:
			idx = 2307;
			break;
		case 4:
			idx = 1498;
			break;
		default:
			break;
	}
	btnBuff.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(idx)));
	return;
}

function OnDropWnd(WindowHandle hTarget, WindowHandle hDropWnd, int X, int Y)
{
	local string sTargetName, sDropName, sTargetParent;
	local int dropIdx, targetIdx, i;

	dropIdx = -1;
	targetIdx = -1;
	if(((hTarget == none) || (hDropWnd == none)))
	{
		return;
	}
	sTargetName = hTarget.GetWindowName();
	sDropName = hDropWnd.GetWindowName();
	sTargetParent = hTarget.GetParentWindowName();
	if((((InStr(sTargetName, "PartyStatusWnd") == -1) && (InStr(sTargetParent, "PartyStatusWnd") == -1)) || (InStr(sDropName, "PartyStatusWnd") == -1)))
	{
		return;
	}
	else
	{
		dropIdx = int(Right(sDropName, 1));
		if((InStr(sTargetName, "PartyStatusWnd") > -1))
		{
			targetIdx = int(Right(sTargetName, 1));
		}
		else
		{
			targetIdx = int(Right(sTargetParent, 1));
		}
		if(((dropIdx < 0) || (targetIdx < 0)))
		{
		}
		if((dropIdx > targetIdx))
		{
			CopyStatus(9, dropIdx);
			i = (dropIdx - 1);
			while((i > (targetIdx - 1)))
			{
				CopyStatus((i + 1), i);
				i--;
			}
			CopyStatus(targetIdx, 9);
		}
		else if((dropIdx < targetIdx))
		{
			CopyStatus(9, dropIdx);
			i = (dropIdx + 1);
			while((i < (targetIdx + 1)))
			{
				CopyStatus((i - 1), i);
				i++;
			}
			CopyStatus(targetIdx, 9);
		}
		ClearStatus(9);
		ClearPetStatus(9);
		Class'NWindow.UIDATA_PARTY'.static.MovePartyMember(dropIdx, targetIdx);
		ResizeWnd();
	}
	return;
}

function int GetVNameIndexByID(int Id)
{
	local int i;

	i = 0;
	while((i < 10))
	{
		if((m_Vname[i].Id == Id))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function ResetVName()
{
	local int i;

	i = 0;
	while((i < 10))
	{
		m_Vname[i].Id = i;
		m_Vname[i].UseVName = 0;
		m_Vname[i].DominionIDForVName = 0;
		m_Vname[i].VName = "";
		m_Vname[i].SummonVName = "";
		i++;
	}
	return;
}

function HandleRegistPartySubstitute(string param)
{
	local int iOK, iUserID;

	ParseInt(param, "OK", iOK);
	ParseInt(param, "UserID", iUserID);
	return;
}

function HandleDeletePartySubstitute(string param)
{
	local int iOK, iUserID;

	ParseInt(param, "OK", iOK);
	ParseInt(param, "UserID", iUserID);
	return;
}
