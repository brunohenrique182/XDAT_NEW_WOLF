class PartyWnd extends UICommonAPI;

const SMALL_BUF_ICON_SIZE = 6;
const MAX_ArrayNum = 10;
const NSTATUSICON_MAXCOL = 12;
const PARTY_MASTER_WEIGHT = 18;
const PARTY_NAME_POSTION_X = 4;
const PARTY_NAME_POSTION_Y = 8;

struct VnameData
{
	var int Id;
	var int UseVName;
	var int DominionIDForVName;
	var string VName;
	var string SummonVName;
};

var int MAX_BUFF_ICONTYPE;
var int DEFAULT_NPARTYSTATUS_HEIGHT;
var int DEFAULT_NPARTYPETSTATUS_HEIGHT;
var int DEFAULT_BUFFICON_SIZE;
var int DEFAULT_BUFFICON_SIZE_FORSUMMON;
var int DEFAULT_STATUS_GAP;
var int DEFAULT_FIRSTWND_ADD_HEIGHT;
var string m_Windowname;
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
var VnameData m_Vname[10];
var bool m_AmIRoomMaster;
var WindowHandle m_wndTop;
var WindowHandle m_PartyStatus[10];
var WindowHandle m_PartyOption;
var NameCtrlHandle m_PlayerName[10];
var TextureHandle m_ClassIcon[10];
var TextureHandle m_LeaderIcon[10];
var AnimTextureHandle m_AssistAnimTex[10];
var TextureHandle m_SGIcon[10];
var StatusIconHandle m_StatusIconBuff[10];
var StatusIconHandle m_StatusIconDeBuff[10];
var StatusIconHandle m_StatusIconSongDance[10];
var StatusIconHandle m_StatusIconItem[10];
var StatusIconHandle m_StatusIconTriggerSkill[10];
var StatusBarHandle m_BarCP[10];
var StatusBarHandle m_BarHP[10];
var StatusBarHandle m_BarMP[10];
var ButtonHandle btnBuff;
var ButtonHandle m_petButton[10];
var WindowHandle m_PetPartyStatus[10];
var StatusIconHandle m_PetStatusIconBuff[10];
var StatusIconHandle m_PetStatusIconDeBuff[10];
var StatusIconHandle m_PetStatusIconSongDance[10];
var StatusIconHandle m_PetStatusIconItem[10];
var StatusIconHandle m_PetStatusIconTriggerSkill[10];
var StatusBarHandle m_PetBarHP[10];
var StatusBarHandle m_PetBarMP[10];
var TextureHandle m_PetClassIcon[10];
var TextureHandle m_ClassIconSummon[10];
var TextureHandle m_ClassIconSummonNum[10];
var TextureHandle m_IsDead[10];
var PartyWndOption PartyWndOptionScript;
var int partymasteridx;
var int partymasterClassIDidx;
var int partymasterRoutingType;
var L2Util util;
var int PartyLeaderID;
var string currentBuffButtonState;

event OnRegisterEvent()
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
	RegisterEvent(11681);
	RegisterEvent(1050);
	RegisterEvent(40);
	RegisterEvent(980);
	RegisterEvent(1182);
	RegisterEvent(1183);
	RegisterEvent(1052);
	RegisterEvent(1053);
	RegisterEvent(8000);
	return;
}

function checkClassicForm()
{
	local int idx;

	idx = 0;
	while((idx < 10))
	{
		if(getInstanceUIData().GetIsClassicServer())
		{
			m_ClassIconSummonNum[idx].HideWindow();
			idx++;
			continue;
		}
		m_ClassIconSummonNum[idx].ShowWindow();
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

function CustomTooltip partyInfoTooltip(bool bMaster, string UserName, int ClassID, optional int nRoutingType)
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;

	if(bMaster)
	{
		drawListArr[drawListArr.Length] = addDrawItemText((((UserName $ "(") $ GetSystemString(408)) $ ")"), getInstanceL2Util().Yellow, "", true, true);
	}
	else
	{
		drawListArr[drawListArr.Length] = addDrawItemText(UserName, getInstanceL2Util().BrightWhite, "", true, true);
	}
	if(getInstanceUIData().GetIsClassicServer())
	{
		drawListArr[drawListArr.Length] = addDrawItemText(GetClassType(ClassID), getInstanceL2Util().White, "", true, true);
	}
	else
	{
		drawListArr[drawListArr.Length] = addDrawItemText(((GetClassRoleName(ClassID) $ " - ") $ GetClassType(ClassID)), getInstanceL2Util().White, "", true, true);
	}
	if(bMaster)
	{
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = addDrawItemText(GetRoutingString(nRoutingType), getInstanceL2Util().Gold, "", true, true);
	}
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	if(bMaster)
	{
		setCustomToolTipMinimumWidth(mCustomTooltip);
	}
	return mCustomTooltip;
}

event OnLoad()
{
	local int idx;

	util = L2Util(GetScript("L2Util"));
	PartyWndOptionScript = PartyWndOption(GetScript("PartyWndOption"));
	InitHandleCOD();
	partymasteridx = -1;
	partymasterClassIDidx = -1;
	m_bCompact = false;
	m_bBuff = false;
	m_CurBf = 0;
	m_targetID = -1;
	m_LastChangeColor = -1;
	m_AmIRoomMaster = false;
	idx = 0;
	while((idx < 10))
	{
		if(getInstanceUIData().GetIsClassicServer())
		{
			m_StatusIconBuff[idx].SetAnchor((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)), "TopRight", "TopLeft", 15, 5);
			m_StatusIconDeBuff[idx].SetAnchor((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)), "TopRight", "TopLeft", 15, 5);
			m_StatusIconSongDance[idx].SetAnchor((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)), "TopRight", "TopLeft", 15, 5);
			m_StatusIconItem[idx].SetAnchor((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)), "TopRight", "TopLeft", 15, 5);
			m_StatusIconTriggerSkill[idx].SetAnchor((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)), "TopRight", "TopLeft", 15, 5);
			m_PetStatusIconBuff[idx].SetAnchor((((m_Windowname $ ".") $ "PartyStatusSummonWnd") $ string(idx)), "TopRight", "TopLeft", 15, 1);
			m_PetStatusIconDeBuff[idx].SetAnchor((((m_Windowname $ ".") $ "PartyStatusSummonWnd") $ string(idx)), "TopRight", "TopLeft", 15, 1);
			m_PetStatusIconSongDance[idx].SetAnchor((((m_Windowname $ ".") $ "PartyStatusSummonWnd") $ string(idx)), "TopRight", "TopLeft", 15, 1);
			m_PetStatusIconTriggerSkill[idx].SetAnchor((((m_Windowname $ ".") $ "PartyStatusSummonWnd") $ string(idx)), "TopRight", "TopLeft", 15, 1);
			m_PetStatusIconItem[idx].SetAnchor((((m_Windowname $ ".") $ "PartyStatusSummonWnd") $ string(idx)), "TopRight", "TopLeft", 15, 1);
			idx++;
			continue;
		}
		m_StatusIconBuff[idx].SetAnchor((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)), "TopRight", "TopLeft", 0, 5);
		m_StatusIconDeBuff[idx].SetAnchor((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)), "TopRight", "TopLeft", 0, 5);
		m_StatusIconSongDance[idx].SetAnchor((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)), "TopRight", "TopLeft", 0, 5);
		m_StatusIconItem[idx].SetAnchor((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)), "TopRight", "TopLeft", 0, 5);
		m_StatusIconTriggerSkill[idx].SetAnchor((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)), "TopRight", "TopLeft", 0, 5);
		m_PetStatusIconBuff[idx].SetAnchor((((m_Windowname $ ".") $ "PartyStatusSummonWnd") $ string(idx)), "TopRight", "TopLeft", 1, 1);
		m_PetStatusIconDeBuff[idx].SetAnchor((((m_Windowname $ ".") $ "PartyStatusSummonWnd") $ string(idx)), "TopRight", "TopLeft", 1, 1);
		m_PetStatusIconSongDance[idx].SetAnchor((((m_Windowname $ ".") $ "PartyStatusSummonWnd") $ string(idx)), "TopRight", "TopLeft", 1, 1);
		m_PetStatusIconTriggerSkill[idx].SetAnchor((((m_Windowname $ ".") $ "PartyStatusSummonWnd") $ string(idx)), "TopRight", "TopLeft", 1, 1);
		m_PetStatusIconItem[idx].SetAnchor((((m_Windowname $ ".") $ "PartyStatusSummonWnd") $ string(idx)), "TopRight", "TopLeft", 1, 1);
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
	return;
}

function InitHandleCOD()
{
	local int idx;

	m_wndTop = GetWindowHandle(m_Windowname);
	m_PartyOption = GetWindowHandle("PartyWndOption");
	idx = 0;
	while((idx < 10))
	{
		m_PartyStatus[idx] = GetWindowHandle((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)));
		m_ClassIcon[idx] = GetTextureHandle(((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)) $ ".ClassIcon"));
		if(!isCompact())
		{
			m_PlayerName[idx] = GetNameCtrlHandle(((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)) $ ".PlayerName"));
			m_LeaderIcon[idx] = GetTextureHandle(((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)) $ ".LeaderIcon"));
			m_SGIcon[idx] = GetTextureHandle(((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)) $ ".PartySGIcon_Texture"));
			m_IsDead[idx] = GetTextureHandle(((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)) $ ".IsDeadTexture"));
			m_AssistAnimTex[idx] = GetAnimTextureHandle(((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)) $ ".AssistAnimTex"));
		}
		m_StatusIconBuff[idx] = GetStatusIconHandle(((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)) $ ".StatusIconBuff"));
		m_StatusIconDeBuff[idx] = GetStatusIconHandle(((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)) $ ".StatusIconDeBuff"));
		m_StatusIconSongDance[idx] = GetStatusIconHandle(((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)) $ ".StatusIconSongDance"));
		m_StatusIconItem[idx] = GetStatusIconHandle(((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)) $ ".StatusIconItem"));
		m_StatusIconTriggerSkill[idx] = GetStatusIconHandle(((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)) $ ".StatusIconTriggerSkill"));
		m_BarCP[idx] = GetStatusBarHandle(((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)) $ ".barCP"));
		m_BarHP[idx] = GetStatusBarHandle(((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)) $ ".barHP"));
		m_BarMP[idx] = GetStatusBarHandle(((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)) $ ".barMP"));
		if(isCompact())
		{
			if((idx == 0))
			{
				m_BarCP[idx].Move(0, 5, 0.0000000);
				m_BarHP[idx].Move(0, 5, 0.0000000);
				m_BarMP[idx].Move(0, 5, 0.0000000);
			}
		}
		m_petButton[idx] = GetButtonHandle((((m_Windowname $ ".") $ "btnSummon") $ string(idx)));
		m_petButton[idx].HideWindow();
		m_PetPartyStatus[idx] = GetWindowHandle((((m_Windowname $ ".") $ "PartyStatusSummonWnd") $ string(idx)));
		m_PetStatusIconBuff[idx] = GetStatusIconHandle(((((m_Windowname $ ".") $ "PartyStatusSummonWnd") $ string(idx)) $ ".StatusIconBuff"));
		m_PetStatusIconDeBuff[idx] = GetStatusIconHandle(((((m_Windowname $ ".") $ "PartyStatusSummonWnd") $ string(idx)) $ ".StatusIconDebuff"));
		m_PetStatusIconSongDance[idx] = GetStatusIconHandle(((((m_Windowname $ ".") $ "PartyStatusSummonWnd") $ string(idx)) $ ".StatusIconSongDance"));
		m_PetStatusIconTriggerSkill[idx] = GetStatusIconHandle(((((m_Windowname $ ".") $ "PartyStatusSummonWnd") $ string(idx)) $ ".StatusIconTriggerSkill"));
		m_PetStatusIconItem[idx] = GetStatusIconHandle(((((m_Windowname $ ".") $ "PartyStatusSummonWnd") $ string(idx)) $ ".StatusIconItem"));
		m_PetBarHP[idx] = GetStatusBarHandle(((((m_Windowname $ ".") $ "PartyStatusSummonWnd") $ string(idx)) $ ".barHP"));
		m_PetBarMP[idx] = GetStatusBarHandle(((((m_Windowname $ ".") $ "PartyStatusSummonWnd") $ string(idx)) $ ".barMP"));
		m_PetClassIcon[idx] = GetTextureHandle(((((m_Windowname $ ".") $ "PartyStatusSummonWnd") $ string(idx)) $ ".ClassIconPet"));
		m_ClassIconSummon[idx] = GetTextureHandle(((((m_Windowname $ ".") $ "PartyStatusSummonWnd") $ string(idx)) $ ".ClassIconSummon"));
		m_ClassIconSummonNum[idx] = GetTextureHandle(((((m_Windowname $ ".") $ "PartyStatusSummonWnd") $ string(idx)) $ ".ClassIconSummonNum"));
		m_arrPetIDOpen[idx] = -1;
		m_arrSummonID[idx] = -1;
		m_arrID[idx] = 0;
		if(isCompact())
		{
			if((idx == 0))
			{
				m_petButton[idx].SetAnchor((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)), "TopLeft", "TopRight", 0, 16);
			}
			else
			{
				m_petButton[idx].SetAnchor((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)), "TopLeft", "TopRight", 0, 2);
			}
			idx++;
			continue;
		}
		if((idx == 0))
		{
			if(getInstanceUIData().GetIsClassicServer())
			{
				m_petButton[idx].SetAnchor((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)), "TopLeft", "TopRight", -3, 40);
			}
			else
			{
				m_petButton[idx].SetAnchor((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)), "TopLeft", "TopRight", 0, 32);
			}
			idx++;
			continue;
		}
		if(getInstanceUIData().GetIsClassicServer())
		{
			m_petButton[idx].SetAnchor((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)), "TopLeft", "TopRight", -4, 2);
			idx++;
			continue;
		}
		m_petButton[idx].SetAnchor((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)), "TopLeft", "TopRight", 0, 2);
		idx++;
	}
	btnBuff = GetButtonHandle(((m_Windowname $ ".") $ "btnBuff"));
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

function setSummonPetOpen()
{
	local int i, tmpInt;

	GetINIInt(m_Windowname, "p", tmpInt, "WindowsInfo.ini");
	i = 0;
	while((i < 9))
	{
		if(bool(tmpInt))
		{
			if(((m_arrPetID[i] > 0) || (m_arrSummonID[i] > 0)))
			{
				m_arrPetIDOpen[i] = 2;
			}
			i++;
			continue;
		}
		if(((m_arrPetID[i] > 0) || (m_arrSummonID[i] > 0)))
		{
			m_arrPetIDOpen[i] = 1;
		}
		i++;
	}
	return;
}

event OnShow()
{
	GetINIInt(m_Windowname, "a", m_CurBf, "WindowsInfo.ini");
	SetBuffButtonTooltip();
	UpdateBuff();
	ResizeWnd(false);
	return;
}

event OnHide()
{
	ResetVName();
	return;
}

function EachServerEnterState(name a_CurrentStateName)
{
	m_bCompact = false;
	m_bBuff = false;
	ResizeWnd(true);
	SetBuffButtonTooltip();
	UpdateBuff();
	return;
}

event OnEnterState(name a_CurrentStateName)
{
	if(getInstanceUIData().GetIsLiveServer())
	{
		EachServerEnterState(a_CurrentStateName);
	}
	return;
}

event OnEvent(int Event_ID, string param)
{
	if((getInstanceUIData().GetIsClassicServer() == true))
	{
		return;
	}
	EachServerEvent(Event_ID, param);
	return;
}

function EachServerEvent(int Event_ID, string param)
{
	Debug(((("Event_ID>>>" $ string(Event_ID)) $ "&&") $ param));
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
	else if((Event_ID == 11681))
	{
		HandleUpdatePartyMemberMaxHPBlockPer(param);
	}
	return;
}

function _HandleUpdatePartyLootingHasModified(int IsSuccess, int LootingScheme)
{
	if((IsSuccess == 0))
	{
		return;
	}
	SetMasterTooltip(LootingScheme);
	return;
}

function HandleUpdatePartyMemberMaxHPBlockPer(string param)
{
	local int userServerId, maxHPBlockPer, idx;

	ParseInt(param, "ServerID", userServerId);
	ParseInt(param, "MaxHPBlockPer", maxHPBlockPer);
	idx = FindPartyID(userServerId);
	if((idx > -1))
	{
		if((maxHPBlockPer > 0))
		{
			m_BarHP[idx].SetDrawBlockEffect(true);
		}
		else
		{
			m_BarHP[idx].SetDrawBlockEffect(false);
		}
	}
	return;
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

function ClearTargetHighLight()
{
	local int i;

	if(isCompact())
	{
		return;
	}
	i = 0;
	while((i < 10))
	{
		if(getInstanceUIData().GetIsLiveServer())
		{
			m_PartyStatus[i].SetBackTexture("L2UI_CT1.Windows.Windows_DF_Small_Vertical_SizeControl_Bg");
			i++;
			continue;
		}
		m_PartyStatus[i].SetBackTexture("L2UI_NewTex.Windows.PartyWndBG");
		i++;
	}
	m_LastChangeColor = -1;
	return;
}

function HandleCheckTarget()
{
	local int idx;

	if(isCompact())
	{
		return;
	}
	idx = -1;
	m_targetID = Class'NWindow.UIDATA_TARGET'.static.GetTargetID();
	if((m_targetID > 0))
	{
		idx = FindPartyID(m_targetID);
	}
	if((m_LastChangeColor != -1))
	{
		m_PartyStatus[m_LastChangeColor].SetBackTexture("L2UI_CT1.Windows.Windows_DF_Small_Vertical_SizeControl_Bg");
		if(getInstanceUIData().GetIsLiveServer())
		{
			m_PartyStatus[m_LastChangeColor].SetBackTexture("L2UI_CT1.Windows.Windows_DF_Small_Vertical_SizeControl_Bg");
		}
		else
		{
			m_PartyStatus[m_LastChangeColor].SetBackTexture("L2UI_NewTex.Windows.PartyWndBG");
		}
		m_targetID = -1;
		m_LastChangeColor = -1;
	}
	if((idx != -1))
	{
		m_LastChangeColor = idx;
		if(getInstanceUIData().GetIsLiveServer())
		{
			m_PartyStatus[idx].SetBackTexture("L2UI_CT1.Windows.Windows_DF_Small_Vertical_SizeControl_Bg_Over");
		}
		else
		{
			m_PartyStatus[idx].SetBackTexture("L2UI_NewTex.PartyWndBG_OverClassic");
		}
	}
	return;
}

function HandleRestart()
{
	Clear();
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
	m_CurCount = 0;
	m_targetID = -1;
	m_LastChangeColor = -1;
	ResizeWnd(false);
	ClearTargetHighLight();
	return;
}

function ClearStatus(int idx)
{
	m_StatusIconBuff[idx].Clear();
	m_StatusIconDeBuff[idx].Clear();
	m_StatusIconSongDance[idx].Clear();
	m_StatusIconItem[idx].Clear();
	m_StatusIconTriggerSkill[idx].Clear();
	if((isCompact() == false))
	{
		m_PlayerName[idx].SetName("", NCT_Normal, TA_Left);
		m_LeaderIcon[idx].SetTexture("");
		m_SGIcon[idx].SetTexture("");
	}
	m_ClassIcon[idx].SetTexture("");
	UpdateCPBar(idx, 0, 0);
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
	m_PetStatusIconItem[idx].Clear();
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

function CheckDeadTarget(int idx)
{
	if((m_targetID == m_arrID[idx]))
	{
		RequestReTargetUser(m_arrID[idx]);
	}
	return;
}

function CheckNHideDeadTargetTexture(int idx)
{
	if((m_targetID == m_arrID[idx]))
	{
		TargetStatusWnd(GetScript("TargetStatusWnd")).DeathTexture.HideWindow();
	}
	return;
}

function CopyStatus(int DesIndex, int SrcIndex)
{
	local string strTmp, strTmp1;
	local INT64 MaxValue, CurValue;
	local int Row, Col, maxrow, MaxCol;
	local StatusIconInfo Info;
	local CustomTooltip toolTipInfo, TooltipInfo2, TooltipStatusInfo;

	m_arrID[DesIndex] = m_arrID[SrcIndex];
	m_PartyStatus[SrcIndex].GetTooltipCustomType(TooltipStatusInfo);
	m_PartyStatus[DesIndex].SetTooltipCustomType(TooltipStatusInfo);
	m_ClassIcon[DesIndex].SetTexture(m_ClassIcon[SrcIndex].GetTextureName());
	m_ClassIcon[SrcIndex].GetTooltipCustomType(toolTipInfo);
	m_ClassIcon[DesIndex].SetTooltipCustomType(toolTipInfo);
	if(!isCompact())
	{
		strTmp = m_LeaderIcon[SrcIndex].GetTextureName();
		strTmp1 = m_SGIcon[SrcIndex].GetTextureName();
		m_LeaderIcon[DesIndex].SetTexture(strTmp);
		m_SGIcon[DesIndex].SetTexture(strTmp1);
		if((Len(strTmp) > 0))
		{
			m_LeaderIcon[DesIndex].ShowWindow();
			m_PlayerName[DesIndex].SetNameWithColor(m_PlayerName[SrcIndex].GetName(), NCT_Normal, TA_Left, getInstanceL2Util().Yellow);
		}
		else
		{
			m_PlayerName[DesIndex].SetNameWithColor(m_PlayerName[SrcIndex].GetName(), NCT_Normal, TA_Left, getInstanceL2Util().BrightWhite);
		}
		if((Len(strTmp1) > 0))
		{
			m_SGIcon[DesIndex].ShowWindow();
		}
		SetNamePostion(SrcIndex);
		SetNamePostion(DesIndex);
		m_LeaderIcon[SrcIndex].GetTooltipCustomType(TooltipInfo2);
		m_LeaderIcon[DesIndex].SetTooltipCustomType(TooltipInfo2);
	}
	m_BarCP[SrcIndex].GetPoint(CurValue, MaxValue);
	m_BarCP[DesIndex].SetPoint(CurValue, MaxValue);
	m_BarHP[SrcIndex].GetPoint(CurValue, MaxValue);
	m_BarHP[DesIndex].SetPoint(CurValue, MaxValue);
	if(!isCompact())
	{
		if((CurValue == INT64(0)))
		{
			m_IsDead[DesIndex].ShowWindow();
		}
		else
		{
			m_IsDead[DesIndex].HideWindow();
		}
	}
	if((CurValue == INT64(0)))
	{
		CheckDeadTarget(DesIndex);
	}
	else
	{
		CheckNHideDeadTargetTexture(DesIndex);
	}
	m_BarMP[SrcIndex].GetPoint(CurValue, MaxValue);
	m_BarMP[DesIndex].SetPoint(CurValue, MaxValue);
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
	m_StatusIconItem[DesIndex].Clear();
	maxrow = m_StatusIconItem[SrcIndex].GetRowCount();
	Row = 0;
	while((Row < maxrow))
	{
		m_StatusIconItem[DesIndex].AddRow();
		MaxCol = m_StatusIconItem[SrcIndex].GetColCount(Row);
		Col = 0;
		while((Col < MaxCol))
		{
			m_StatusIconItem[SrcIndex].GetItem(Row, Col, Info);
			m_StatusIconItem[DesIndex].AddCol(Row, Info);
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
	m_PetBarHP[SrcIndex].GetPoint(CurValue, MaxValue);
	m_PetBarHP[DesIndex].SetPoint(CurValue, MaxValue);
	m_PetBarMP[SrcIndex].GetPoint(CurValue, MaxValue);
	m_PetBarMP[DesIndex].SetPoint(CurValue, MaxValue);
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
	m_PetStatusIconItem[DesIndex].Clear();
	maxrow = m_PetStatusIconItem[SrcIndex].GetRowCount();
	Row = 0;
	while((Row < maxrow))
	{
		m_PetStatusIconItem[DesIndex].AddRow();
		MaxCol = m_PetStatusIconItem[SrcIndex].GetColCount(Row);
		Col = 0;
		while((Col < MaxCol))
		{
			m_PetStatusIconItem[SrcIndex].GetItem(Row, Col, Info);
			m_PetStatusIconItem[DesIndex].AddCol(Row, Info);
			Col++;
		}
		Row++;
	}
	ClearTargetHighLight();
	HandleCheckTarget();
	return;
}

function ResizeWnd(bool bTryShow)
{
	local int idx;
	local Rect rectWnd;
	local int i, OpenPetCount;
	local PartyMemberInfo PartyMemberInfo;

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
						m_PartyStatus[idx].SetAnchor((((m_Windowname $ ".") $ "PartyStatusSummonWnd") $ string((idx - 1))), "BottomLeft", "TopLeft", 0, DEFAULT_STATUS_GAP);
					}
					else
					{
						m_PartyStatus[idx].SetAnchor((((m_Windowname $ ".") $ "PartyStatusWnd") $ string((idx - 1))), "BottomLeft", "TopLeft", 0, DEFAULT_STATUS_GAP);
					}
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
						m_ClassIconSummonNum[idx].SetTexture(("L2UI_ch3.PARTYWND.party_summmon_num" $ string(PartyMemberInfo.curSummonNum)));
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
		if(isCompact())
		{
			m_wndTop.SetWindowSize(rectWnd.nWidth, (((DEFAULT_NPARTYSTATUS_HEIGHT * m_CurCount) + (OpenPetCount * DEFAULT_NPARTYPETSTATUS_HEIGHT)) + DEFAULT_FIRSTWND_ADD_HEIGHT));
			m_wndTop.SetResizeFrameSize(10, (((DEFAULT_NPARTYSTATUS_HEIGHT * m_CurCount) + (OpenPetCount * DEFAULT_NPARTYPETSTATUS_HEIGHT)) + DEFAULT_FIRSTWND_ADD_HEIGHT));
		}
		else
		{
			m_wndTop.SetWindowSize(rectWnd.nWidth, ((((DEFAULT_NPARTYSTATUS_HEIGHT * m_CurCount) + (OpenPetCount * DEFAULT_NPARTYPETSTATUS_HEIGHT)) + (DEFAULT_STATUS_GAP * (m_CurCount - 1))) + DEFAULT_FIRSTWND_ADD_HEIGHT));
			Debug(("DEFAULT_NPARTYSTATUS_HEIGHT!!" @ string(DEFAULT_NPARTYSTATUS_HEIGHT)));
			Debug(("DEFAULT_NPARTYPETSTATUS_HEIGHT!!" @ string(DEFAULT_NPARTYPETSTATUS_HEIGHT)));
			if(getInstanceUIData().GetIsClassicServer())
			{
				m_wndTop.SetResizeFrameSize(14, ((((DEFAULT_NPARTYSTATUS_HEIGHT * m_CurCount) + (OpenPetCount * DEFAULT_NPARTYPETSTATUS_HEIGHT)) + (DEFAULT_STATUS_GAP * (m_CurCount - 1))) + DEFAULT_FIRSTWND_ADD_HEIGHT));
			}
			else
			{
				m_wndTop.SetResizeFrameSize(10, ((((DEFAULT_NPARTYSTATUS_HEIGHT * m_CurCount) + (OpenPetCount * DEFAULT_NPARTYPETSTATUS_HEIGHT)) + (DEFAULT_STATUS_GAP * (m_CurCount - 1))) + DEFAULT_FIRSTWND_ADD_HEIGHT));
			}
		}
		GetWindowHandle(m_Windowname).ShowWindow();
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
	ParseString(param, "VName", VName);
	ParseString(param, "SummonVName", SummonVName);
	GetPartyMemberInfo(Id, PartyMemberInfo);
	GetPartyMemberPetInfo(Id, PartyMemberPetInfo);
	if((Id > 0))
	{
		m_Vname[m_CurCount].Id = Id;
		m_Vname[m_CurCount].UseVName = UseVName;
		m_Vname[m_CurCount].DominionIDForVName = DominionIDForVName;
		m_Vname[m_CurCount].VName = VName;
		m_Vname[m_CurCount].SummonVName = SummonVName;
		ExecuteEvent(980);
		m_CurCount++;
		m_arrID[(m_CurCount - 1)] = Id;
		UpdateStatus((m_CurCount - 1), param);
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
					m_ClassIconSummon[(m_CurCount - 1)].SetTooltipText(GetSystemString(505));
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
			UpdatePetIcon(Index, PartyMemberPetInfo.PetID);
			m_arrPetID[Index] = PartyMemberPetInfo.petServerID;
		}
		setSummonPetOpen();
		ResizeWnd(true);
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
			i = idx;
			while((i < (m_CurCount - 1)))
			{
				CopyStatus(i, (i + 1));
				i++;
			}
			ClearStatus((m_CurCount - 1));
			ClearPetStatus((m_CurCount - 1));
			m_CurCount--;
			ResizeWnd(true);
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
	Debug(("SetMasterTooltip" @ string(Lootingtype)));
	if(((partymasteridx < 10) && (partymasteridx > -1)))
	{
		if(!isCompact())
		{
			m_LeaderIcon[partymasteridx].SetTooltipCustomType(MakeTooltipSimpleText(GetRoutingString(Lootingtype)));
		}
		m_PartyStatus[partymasteridx].SetTooltipCustomType(partyInfoTooltip(true, m_PlayerName[partymasteridx].GetName(), partymasterClassIDidx, Lootingtype));
		m_ClassIcon[partymasteridx].SetTooltipCustomType(partyInfoTooltip(true, m_PlayerName[partymasteridx].GetName(), partymasterClassIDidx, Lootingtype));
	}
	return;
}

function UpdateStatus(int idx, string param)
{
	local string Name;
	local int MasterID, Id, CP, maxCP, Hp, MaxHP, MP, maxMP, ClassID, Level, vitality;
	local UserInfo TargetUser;
	local int UseVName;
	local string VName;
	local int SummonCount;
	local string useName;
	local int iSubstatus;

	ParseInt(param, "SubStitute", iSubstatus);
	if(((idx < 0) || (idx >= 10)))
	{
		return;
	}
	ParseString(param, "Name", Name);
	ParseInt(param, "ID", Id);
	GetUserInfo(Id, TargetUser);
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
	ParseInt(param, "MasterID", MasterID);
	if((MasterID > 0))
	{
		PartyLeaderID = MasterID;
	}
	if(!isCompact())
	{
		if((Hp == 0))
		{
			m_IsDead[idx].ShowWindow();
		}
		else
		{
			m_IsDead[idx].HideWindow();
		}
	}
	if((Hp == 0))
	{
		CheckDeadTarget(idx);
	}
	else
	{
		CheckNHideDeadTargetTexture(idx);
	}
	UseVName = m_Vname[idx].UseVName;
	VName = m_Vname[idx].VName;
	if((UseVName == 1))
	{
		useName = VName;
	}
	else
	{
		useName = Name;
	}
	m_ClassIcon[idx].SetTexture(GetClassRoleIconNameBig(ClassID));
	if((PartyLeaderID == Id))
	{
		partymasteridx = idx;
		partymasterClassIDidx = ClassID;
		ParseInt(param, "RoutingType", partymasterRoutingType);
		if(!isCompact())
		{
			m_LeaderIcon[idx].SetTexture("L2UI_CH3.PartyWnd.party_leadericon");
			m_LeaderIcon[idx].SetTooltipCustomType(MakeTooltipSimpleText(GetRoutingString(partymasterRoutingType)));
			m_PlayerName[idx].SetNameWithColor(useName, NCT_Normal, TA_Left, getInstanceL2Util().Yellow);
		}
		m_PartyStatus[idx].SetTooltipCustomType(partyInfoTooltip(true, useName, ClassID, partymasterRoutingType));
		m_ClassIcon[idx].SetTooltipCustomType(partyInfoTooltip(true, useName, ClassID, partymasterRoutingType));
	}
	else
	{
		if(!isCompact())
		{
			m_LeaderIcon[idx].SetTexture("");
			m_LeaderIcon[idx].SetTooltipCustomType(MakeTooltipSimpleText(""));
			m_PlayerName[idx].SetNameWithColor(useName, NCT_Normal, TA_Left, getInstanceL2Util().BrightWhite);
		}
		m_PartyStatus[idx].SetTooltipCustomType(partyInfoTooltip(false, useName, ClassID));
		m_ClassIcon[idx].SetTooltipCustomType(partyInfoTooltip(false, useName, ClassID));
	}
	if(getInstanceUIData().GetIsLiveServer())
	{
		if((vitality != 0))
		{
			m_SGIcon[idx].SetTexture("L2UI_CT1.PartyStatusWnd.VPICON_ON");
		}
		else
		{
			m_SGIcon[idx].SetTexture("L2UI_CT1.PartyStatusWnd.VPICON_OFF");
		}
	}
	else if((vitality != 0))
	{
		m_SGIcon[idx].SetTexture("L2UI_CT1.PartyStatusWnd.SGICON_ON");
	}
	else
	{
		m_SGIcon[idx].SetTexture("L2UI_CT1.PartyStatusWnd.SGICON_OFF");
	}
	SetNamePostion(idx);
	UpdateCPBar(idx, CP, maxCP);
	UpdateHPBar(idx, Hp, MaxHP);
	UpdateMPBar(idx, MP, maxMP);
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
			ResizeWnd(true);
		}
	}
	return;
}

function HandlePartyPetUpdate(string param)
{
	local int Id, idx, Type, PetID;

	ParseInt(param, "Type", Type);
	ParseInt(param, "ID", Id);
	ParseInt(param, "PetID", PetID);
	if((Type == 2))
	{
		idx = FindPetID(Id);
		UpdatePetStatus(idx, param);
		UpdatePetIcon(idx, PetID);
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
			ResizeWnd(true);
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

function UpdatePetIcon(int idx, int PetID)
{
	if((getInstanceUIData().GetIsClassicServer() && (idx < 10)))
	{
		if((int(byte(Class'NWindow.PetAPI'.static.GetPetType(PetID))) == 1))
		{
			m_PetClassIcon[idx].SetTexture("L2UI_ch3.PARTYWND.party_Mercenaryicon");
		}
		else
		{
			m_PetClassIcon[idx].SetTexture("L2UI_ch3.PARTYWND.party_peticon");
		}
	}
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
	setSummonPetOpen();
	ResizeWnd(true);
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
		ResizeWnd(true);
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
			m_ClassIconSummonNum[idx].SetTexture(("L2UI_ch3.PARTYWND.party_summmon_num" $ string(PartyMemberInfo.curSummonNum)));
		}
		else
		{
			ClearSummonStatus(idx);
		}
		ResizeWnd(true);
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
	local int i, idx, Id, Max, BuffCnt, BuffCurRow, DeBuffCnt, DeBuffCurRow, TriggerSkillCnt, TriggerSkillCurRow, ItemCnt, ItemCntCurRow;
	local bool isPC;
	local StatusIconInfo Info;

	DeBuffCurRow = -1;
	BuffCurRow = -1;
	ItemCntCurRow = -1;
	TriggerSkillCurRow = -1;
	isPC = false;
	ParseInt(param, "ID", Id);
	if((Id < 1))
	{
		return;
	}
	idx = FindPartyID(Id);
	if((idx >= 0))
	{
		m_StatusIconBuff[idx].Clear();
		m_StatusIconDeBuff[idx].Clear();
		m_StatusIconSongDance[idx].Clear();
		m_StatusIconItem[idx].Clear();
		m_StatusIconTriggerSkill[idx].Clear();
		isPC = true;
	}
	else
	{
		idx = FindPetID(Id);
		if((idx >= 0))
		{
			m_PetStatusIconBuff[idx].Clear();
			m_PetStatusIconDeBuff[idx].Clear();
			m_PetStatusIconSongDance[idx].Clear();
			m_PetStatusIconTriggerSkill[idx].Clear();
			m_PetStatusIconItem[idx].Clear();
			isPC = false;
		}
		else
		{
			return;
		}
	}
	if(isPC)
	{
		Info.Size = DEFAULT_BUFFICON_SIZE;
	}
	else
	{
		Info.Size = DEFAULT_BUFFICON_SIZE_FORSUMMON;
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
			Info.IconPanel = Class'NWindow.UIDATA_SKILL'.static.GetIconPanel(Info.Id, Info.Level, Info.SubLevel);
			if((GetDebuffType(Info.Id, Info.Level, Info.SubLevel) != 0))
			{
				Info.bHideRemainTime = true;
				if(((float(DeBuffCnt) % 12.0000000) == 0.0000000))
				{
					DeBuffCurRow++;
					if(isPC)
					{
						m_StatusIconDeBuff[idx].AddRow();
					}
					else
					{
						m_PetStatusIconDeBuff[idx].AddRow();
					}
				}
				if(isPC)
				{
					m_StatusIconDeBuff[idx].AddCol(DeBuffCurRow, Info);
				}
				else
				{
					m_PetStatusIconDeBuff[idx].AddCol(DeBuffCurRow, Info);
				}
				DeBuffCnt++;
				i++;
				continue;
			}
			if((GetIndexByIsMagic(Info) == 3))
			{
				if(isPC)
				{
					m_StatusIconSongDance[idx].AddRow();
				}
				else
				{
					m_PetStatusIconSongDance[idx].AddRow();
				}
				if(isPC)
				{
					m_StatusIconSongDance[idx].AddCol(0, Info);
				}
				else
				{
					m_PetStatusIconSongDance[idx].AddCol(0, Info);
				}
				i++;
				continue;
			}
			if((GetIndexByIsMagic(Info) == 4))
			{
				if(((float(ItemCnt) % 12.0000000) == 0.0000000))
				{
					ItemCntCurRow++;
					if(isPC)
					{
						m_StatusIconItem[idx].AddRow();
					}
					else
					{
						m_PetStatusIconItem[idx].AddRow();
					}
				}
				if(isPC)
				{
					m_StatusIconItem[idx].AddCol(ItemCntCurRow, Info);
				}
				else
				{
					m_PetStatusIconItem[idx].AddCol(ItemCntCurRow, Info);
				}
				ItemCnt++;
				i++;
				continue;
			}
			if((GetIndexByIsMagic(Info) == 5))
			{
				if(((float(TriggerSkillCnt) % 12.0000000) == 0.0000000))
				{
					TriggerSkillCurRow++;
					if(isPC)
					{
						m_StatusIconTriggerSkill[idx].AddRow();
					}
					else
					{
						m_PetStatusIconTriggerSkill[idx].AddRow();
					}
				}
				if(isPC)
				{
					m_StatusIconTriggerSkill[idx].AddCol(TriggerSkillCurRow, Info);
				}
				else
				{
					m_PetStatusIconTriggerSkill[idx].AddCol(TriggerSkillCurRow, Info);
				}
				TriggerSkillCnt++;
				i++;
				continue;
			}
			if(((float(BuffCnt) % 12.0000000) == 0.0000000))
			{
				BuffCurRow++;
				if(isPC)
				{
					m_StatusIconBuff[idx].AddRow();
				}
				else
				{
					m_PetStatusIconBuff[idx].AddRow();
				}
			}
			if(isPC)
			{
				m_StatusIconBuff[idx].AddCol(BuffCurRow, Info);
			}
			else
			{
				m_PetStatusIconBuff[idx].AddCol(BuffCurRow, Info);
			}
			BuffCnt++;
		}
		i++;
	}
	UpdateBuff();
	return;
}

function HandlePartySpelledListDelete(string param)
{
	local int i, idx, Id, Max;
	local StatusIconInfo Info;
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
	ParseInt(param, "Max", Max);
	i = 0;
	while((i < Max))
	{
		ParseItemIDWithIndex(param, Info.Id, i);
		ParseInt(param, ("Level_" $ string(i)), Info.Level);
		ParseInt(param, ("SubLevel_" $ string(i)), Info.SubLevel);
		ParseInt(param, ("SpellerID_" $ string(i)), Info.SpellerID);
		if(IsValidItemID(Info.Id))
		{
			if((GetDebuffType(Info.Id, Info.Level, Info.SubLevel) != 0))
			{
				if(isPC)
				{
					deleteBuff(m_StatusIconDeBuff[idx], Info.Level, Info.Id.ClassID, Info.SpellerID);
				}
				else
				{
					deleteBuff(m_PetStatusIconDeBuff[idx], Info.Level, Info.Id.ClassID, Info.SpellerID);
				}
				i++;
				continue;
			}
			if((GetIndexByIsMagic(Info) == 3))
			{
				if(isPC)
				{
					deleteBuff(m_StatusIconSongDance[idx], Info.Level, Info.Id.ClassID, Info.SpellerID);
				}
				else
				{
					deleteBuff(m_PetStatusIconSongDance[idx], Info.Level, Info.Id.ClassID, Info.SpellerID);
				}
				i++;
				continue;
			}
			if((GetIndexByIsMagic(Info) == 4))
			{
				if(isPC)
				{
					deleteBuff(m_StatusIconItem[idx], Info.Level, Info.Id.ClassID, Info.SpellerID);
				}
				else
				{
					deleteBuff(m_PetStatusIconItem[idx], Info.Level, Info.Id.ClassID, Info.SpellerID);
				}
				i++;
				continue;
			}
			if((GetIndexByIsMagic(Info) == 5))
			{
				if(isPC)
				{
					deleteBuff(m_StatusIconTriggerSkill[idx], Info.Level, Info.Id.ClassID, Info.SpellerID);
				}
				else
				{
					deleteBuff(m_PetStatusIconTriggerSkill[idx], Info.Level, Info.Id.ClassID, Info.SpellerID);
				}
				i++;
				continue;
			}
			if(isPC)
			{
				deleteBuff(m_StatusIconBuff[idx], Info.Level, Info.Id.ClassID, Info.SpellerID);
				i++;
				continue;
			}
			deleteBuff(m_PetStatusIconBuff[idx], Info.Level, Info.Id.ClassID, Info.SpellerID);
		}
		i++;
	}
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
		Info.Size = DEFAULT_BUFFICON_SIZE;
	}
	else
	{
		Info.Size = DEFAULT_BUFFICON_SIZE_FORSUMMON;
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
			Info.IconPanel = Class'NWindow.UIDATA_SKILL'.static.GetIconPanel(Info.Id, Info.Level, Info.SubLevel);
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
			else if((GetIndexByIsMagic(Info) == 3))
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
			else if((GetIndexByIsMagic(Info) == 4))
			{
				if(isPC)
				{
					tmpStatusIcon = m_StatusIconItem[idx];
				}
				else
				{
					tmpStatusIcon = m_PetStatusIconItem[idx];
				}
			}
			else if((GetIndexByIsMagic(Info) == 5))
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
	if((m_CurBf > MAX_BUFF_ICONTYPE))
	{
		m_CurBf = 0;
	}
	SetINIInt(m_Windowname, "a", m_CurBf, "WindowsInfo.ini");
	SetBuffButtonTooltip();
	UpdateBuff();
	return;
}

event OnClickButton(string strID)
{
	local int idx;

	switch(strID)
	{
		case "btnBuff":
			OnBuffButton();
			break;
		case "btnOption":
			OnOpenPartyWndOption();
			break;
		case "btnSummon":
			Debug("ERROR - you can't enter here");
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
		ResizeWnd(true);
	}
	return;
}

function OnOpenPartyWndOption()
{
	local int i;
	local PartyWndOption Script;

	Script = PartyWndOption(GetScript("PartyWndOption"));
	i = 0;
	while((i < 9))
	{
		Script.m_arrPetIDOpen[i] = m_arrPetIDOpen[i];
		i++;
	}
	Script.ShowPartyWndOption();
	m_PartyOption.SetAnchor(((m_Windowname $ ".") $ "PartyStatusWnd0"), "TopRight", "TopLeft", 5, 5);
	return;
}

function OnBuffButton()
{
	m_CurBf = (m_CurBf + 1);
	if((m_CurBf > MAX_BUFF_ICONTYPE))
	{
		m_CurBf = 0;
	}
	SetINIInt(m_Windowname, "a", m_CurBf, "WindowsInfo.ini");
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
			m_StatusIconItem[idx].HideWindow();
			m_PetStatusIconItem[idx].HideWindow();
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
			m_StatusIconItem[idx].HideWindow();
			m_PetStatusIconItem[idx].HideWindow();
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
			m_StatusIconItem[idx].HideWindow();
			m_PetStatusIconItem[idx].HideWindow();
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
			m_StatusIconItem[idx].ShowWindow();
			m_PetStatusIconItem[idx].ShowWindow();
			m_StatusIconTriggerSkill[idx].HideWindow();
			m_PetStatusIconTriggerSkill[idx].HideWindow();
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
			m_StatusIconItem[idx].HideWindow();
			m_PetStatusIconItem[idx].HideWindow();
			idx++;
		}
	}
	return;
}

function UpdateCPBar(int idx, int Value, int MaxValue)
{
	m_BarCP[idx].SetPoint(INT64(Value), INT64(MaxValue));
	return;
}

function UpdateHPBar(int idx, int Value, int MaxValue)
{
	if((idx < 100))
	{
		m_BarHP[idx].SetPoint(INT64(Value), INT64(MaxValue));
	}
	else
	{
		m_PetBarHP[(idx - 100)].SetPoint(INT64(Value), INT64(MaxValue));
	}
	return;
}

function UpdateMPBar(int idx, int Value, int MaxValue)
{
	if((idx < 100))
	{
		m_BarMP[idx].SetPoint(INT64(Value), INT64(MaxValue));
	}
	else
	{
		m_PetBarMP[(idx - 100)].SetPoint(INT64(Value), INT64(MaxValue));
	}
	return;
}

function int getIdxByWindowHandle(WindowHandle a_WindowHandle)
{
	local int idx, i;

	idx = -1;
	if((a_WindowHandle == none))
	{
		return -1;
	}
	if((a_WindowHandle.GetWindowName() == m_Windowname))
	{
		return -1;
	}
	if((Left(a_WindowHandle.GetWindowName(), Len("PartyStatusWnd")) == "PartyStatusWnd"))
	{
		idx = int(Right(a_WindowHandle.GetWindowName(), 1));
	}
	else
	{
		i = -1;
		if((Left(a_WindowHandle.GetParentWindowName(), Len("PartyStatusWnd")) == "PartyStatusWnd"))
		{
			idx = int(Right(a_WindowHandle.GetParentWindowName(), 1));
		}
		else if((Left(a_WindowHandle.GetWindowName(), Len("PartyStatusSummonWnd")) == "PartyStatusSummonWnd"))
		{
			i = int(Right(a_WindowHandle.GetWindowName(), 1));
		}
		else if((Left(a_WindowHandle.GetParentWindowName(), Len("PartyStatusSummonWnd")) == "PartyStatusSummonWnd"))
		{
			i = int(Right(a_WindowHandle.GetParentWindowName(), 1));
		}
		if((i > -1))
		{
			if((m_arrPetIDOpen[i] == 1))
			{
				idx = (i + 100);
			}
		}
	}
	return idx;
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	local UserInfo UserInfo;
	local int idx;

	idx = getIdxByWindowHandle(a_WindowHandle);
	if(((idx == -1) || (a_WindowHandle == none)))
	{
		return;
	}
	if(GetPlayerInfo(UserInfo))
	{
		if(IsPKMode())
		{
			if((idx < 100))
			{
				RequestAttack(m_arrID[idx], UserInfo.Loc);
			}
			else
			{
				RequestAttack(m_arrPetID[(idx - 100)], UserInfo.Loc);
			}
		}
		else if((idx < 100))
		{
			RequestAction(m_arrID[idx], UserInfo.Loc);
		}
		else
		{
			RequestAction(m_arrPetID[(idx - 100)], UserInfo.Loc);
		}
	}
	return;
}

event OnRButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	local UserInfo UserInfo;
	local int idx;

	idx = getIdxByWindowHandle(a_WindowHandle);
	if(((idx == -1) || (a_WindowHandle == none)))
	{
		return;
	}
	if(GetPlayerInfo(UserInfo))
	{
		if((idx < 100))
		{
			RequestAssist(m_arrID[idx], UserInfo.Loc);
			m_AssistAnimTex[idx].Stop();
			m_AssistAnimTex[idx].Play();
		}
		else
		{
			RequestAssist(m_arrPetID[(idx - 100)], UserInfo.Loc);
		}
	}
	return;
}

function SetBuffButtonTooltip()
{
	local Color b1, b2, b3, b4;
	local array<DrawItemInfo> drawListArr;

	b1 = getInstanceL2Util().Gray;
	b2 = getInstanceL2Util().Gray;
	b3 = getInstanceL2Util().Gray;
	b4 = getInstanceL2Util().Gray;
	if((m_CurBf == 0))
	{
		btnBuff.SetTexture("L2ui_CH3.PartyWnd.party_buffbutton_off", "L2ui_CH3.PartyWnd.party_buffbutton_off", "L2ui_CH3.PartyWnd.party_buffbutton_off");
	}
	else
	{
		btnBuff.SetTexture(("L2ui_CH3.PartyWnd.party_buffbutton_" $ string(m_CurBf)), ("L2ui_CH3.PartyWnd.party_buffbutton_" $ string(m_CurBf)), ("L2ui_CH3.PartyWnd.party_buffbutton_" $ string(m_CurBf)));
	}
	switch(m_CurBf)
	{
		case 0:
			break;
		case 1:
			b1 = getInstanceL2Util().Yellow;
			break;
		case 2:
			b2 = getInstanceL2Util().Yellow;
			break;
		case 3:
			b3 = getInstanceL2Util().Yellow;
			break;
		case 4:
			b4 = getInstanceL2Util().Yellow;
			break;
		default:
			break;
	}
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(1496), b1, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(1497), b2, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(1741), b3, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(2307), b4, "", true, true);
	btnBuff.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
	return;
}

event OnDropWnd(WindowHandle hTarget, WindowHandle hDropWnd, int X, int Y)
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
		ResizeWnd(true);
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

function SetNamePostion(int idx)
{
	if(!isCompact())
	{
		if((m_LeaderIcon[idx].GetTextureName() != ""))
		{
			m_PlayerName[idx].SetWindowSizeRel(1.0000000, 0.0000000, -48, 14);
			m_PlayerName[idx].SetAnchor((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)), "TopLeft", "TopLeft", (8 + 18), 8);
			if((m_SGIcon[idx].GetTextureName() != ""))
			{
				m_LeaderIcon[idx].SetAnchor((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)), "TopLeft", "TopLeft", (16 + 3), 8);
				m_PlayerName[idx].SetAnchor((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)), "TopLeft", "TopLeft", ((4 + 16) + 19), 8);
			}
		}
		else
		{
			m_PlayerName[idx].SetWindowSizeRel(1.0000000, 0.0000000, -28, 14);
			if((m_SGIcon[idx].GetTextureName() != ""))
			{
				m_PlayerName[idx].SetAnchor((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)), "TopLeft", "TopLeft", (4 + 16), 8);
				m_PlayerName[idx].SetAnchor((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)), "TopLeft", "TopLeft", (4 + 16), 8);
			}
			else
			{
				m_PlayerName[idx].SetAnchor((((m_Windowname $ ".") $ "PartyStatusWnd") $ string(idx)), "TopLeft", "TopLeft", 4, 8);
			}
		}
	}
	return;
}

function int GetIndexByIsMagic(StatusIconInfo Info)
{
	local SkillInfo SkillInfo;

	if(!GetSkillInfo(Info.Id.ClassID, Info.Level, Info.SubLevel, SkillInfo))
	{
		return -1;
	}
	return SkillInfo.IsMagic;
}

function bool isCompact()
{
	if((m_Windowname == "PartyWndCompact"))
	{
		return true;
	}
	return false;
}

defaultproperties
{
	MAX_BUFF_ICONTYPE=4
	DEFAULT_NPARTYSTATUS_HEIGHT=59
	DEFAULT_NPARTYPETSTATUS_HEIGHT=16
	DEFAULT_BUFFICON_SIZE=16
	DEFAULT_BUFFICON_SIZE_FORSUMMON=10
	DEFAULT_STATUS_GAP=-3
	m_Windowname="PartyWnd"
}
