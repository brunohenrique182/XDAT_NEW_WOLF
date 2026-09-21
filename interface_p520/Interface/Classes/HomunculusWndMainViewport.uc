class HomunculusWndMainViewport extends UICommonAPI
	dependson(UIPacket);

const TIMER_ID_ANIMATION = 19;
const TIMER_DELAY = 20000;
const TIMER_ID_CLICK = 2;
const TIMER_DELAY_CLICK = 200;
const MONSTERID_DEACTIVE = 19652;
const TIMER_ID_COMMUNION = 3;
const DIALOG_ID_DELETE = 17;

var WindowHandle Me;
var string m_Windowname;
var bool isDown;
var CharacterViewportWindowHandle m_ObjectViewport;
var ButtonHandle btn0;
var ButtonHandle btn1;
var ButtonHandle btn2;
var TextureHandle EvolutionBtn_Tex;
var TextBoxHandle text0;
var TextBoxHandle text1;
var AnimTextureHandle texCommunion;
var StatusBarHandle ExpBar;
var bool isCommunion;
var int requestedCommunionIdx;
var HomunculusWnd HomunculusWndScript;
var HomunculusWndMainList homunculusWndMainListScript;
var int spawnedIndex;
var int idx;
var int Level;
var int lastRevolutionIdx;

function ClearAll()
{
	spawnedIndex = -1;
	text0.SetText("");
	ExpBar.SetPoint(INT64(0), INT64(100));
	texCommunion.Stop();
	texCommunion.HideWindow();
	btn1.DisableWindow();
	ShowHideEvolotionBtn(false);
	SetGrade(-1);
	SetViewPortSetting(0);
	SetViewPort(19652);
	idx = -1;
	Level = 1;
	lastRevolutionIdx = -1;
	return;
}

function HandleGameInit()
{
	if(!HomunculusWndScript.ChkSerVer())
	{
		return;
	}
	ClearAll();
	return;
}

function Initialize()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	text0 = GetTextBoxHandle((m_Windowname $ ".text0"));
	text1 = GetTextBoxHandle((m_Windowname $ ".text1"));
	btn0 = GetButtonHandle((m_Windowname $ ".btn0"));
	btn1 = GetButtonHandle((m_Windowname $ ".btn1"));
	btn2 = GetButtonHandle((m_Windowname $ ".btn2"));
	EvolutionBtn_Tex = GetTextureHandle((m_Windowname $ ".EvolutionBtn_Tex"));
	ExpBar = GetStatusBarHandle((m_Windowname $ ".EXPBar"));
	texCommunion = GetAnimTextureHandle((m_Windowname $ ".texCommunion"));
	m_ObjectViewport = GetCharacterViewportWindowHandle((m_Windowname $ ".ObjectViewport"));
	m_ObjectViewport.SetDragRotationRate(200);
	m_ObjectViewport.SetSpawnDuration(0.2000000);
	m_ObjectViewport.SetUISound(true);
	HomunculusWndScript = HomunculusWnd(GetScript("HomunculusWnd"));
	homunculusWndMainListScript = HomunculusWndMainList(GetScript("HomunculusWnd.HomunculusWndMainList"));
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(1710);
	RegisterEvent(150);
	RegisterEvent((100000 + 860));
	return;
}

event OnLoad()
{
	Initialize();
	return;
}

event OnEvent(int Event_ID, string param)
{
	Debug((("------------------- HomunculusWndMainViewport's event : " @ string(Event_ID)) @ param));
	switch(Event_ID)
	{
		case 1710:
			HandleDialogOK(true);
			break;
		case (100000 + 860):
			Handle_S_EX_ACTIVATE_HOMUNCULUS_RESULT();
			break;
		case 150:
			HandleGameInit();
			break;
		default:
			break;
	}
	return;
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	if((a_WindowHandle == m_ObjectViewport))
	{
		Me.SetTimer(2, 200);
		isDown = true;
	}
	return;
}

event OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	if((a_WindowHandle == m_ObjectViewport))
	{
		if(isDown)
		{
			PlayRandAnimation();
			Me.SetTimer(19, 20000);
		}
	}
	Me.KillTimer(2);
	isDown = false;
	return;
}

event OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case 2:
			Me.KillTimer(2);
			isDown = false;
			break;
		default:
			break;
	}
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "btn0":
			ChangeActivate();
			break;
		case "btn1":
			HandleDeleteBtnClicked();
			break;
		case "btn2":
			HandleShowRevolution();
			break;
		default:
			break;
	}
	return;
}

function HandleDeleteBtnClicked()
{
	local string Msg;
	local HomunculusAPI.HomunCreateData currHmunCreateData;

	currHmunCreateData = HomunculusWndScript.API_GetHomunCreateData();
	Msg = ((((GetSystemString(13377) $ "\\n") $ GetSystemString(3155)) $ ":") @ string(currHmunCreateData.GainEvolutionPoint[GetCurrHomunculusData().Type]));
	DialogSetID(17);
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, Msg);
	return;
}

function HandleShowRevolution()
{
	HomunculusWndScript._SetRevolutionState();
	return;
}

function Show()
{
	Me.ShowWindow();
	Me.SetFocus();
	return;
}

function Hide()
{
	Me.HideWindow();
	return;
}

function ChangeActivate()
{
	requestedCommunionIdx = GetCurrHomunculusData().idx;
	HomunculusWndScript.API_C_EX_REQUEST_ACTIVATE_HOMUNCULUS(requestedCommunionIdx, !GetCurrHomunculusData().Activate);
	return;
}

function PlayRandAnimation()
{
	local int aniType;

	aniType = Rand(2);
	m_ObjectViewport.PlayAnimation(aniType);
	return;
}

function SetGrade(int Type)
{
	switch(Type)
	{
		case 0:
		case 1:
		case 2:
		case 3:
			text1.SetText(HomunculusWndScript.GetGradeString(Type));
			m_ObjectViewport.SetBackgroundTex(("L2UI_EPIC.HomunCulusWnd.Homun_NPCBackTex0" $ string((Type + 1))));
			break;
		default:
			text1.SetText(HomunculusWndScript.GetGradeString(Type));
			m_ObjectViewport.SetBackgroundTex("L2UI_EPIC.HomunCulusWnd.Homun_NPCBackTex01");
			break;
	}
	return;
}

function SetNoneHomunculus()
{
	text1.SetText(GetSystemString(13397));
	return;
}

function SetViewPort(int NpcID)
{
	if((NpcID == spawnedIndex))
	{
		return;
	}
	spawnedIndex = NpcID;
	m_ObjectViewport.SetNPCInfo(NpcID);
	m_ObjectViewport.SpawnNPC();
	PlayRandAnimation();
	return;
}

function _SetDispawnOnHide()
{
	m_ObjectViewport.SetNPCInfo(-1);
	m_ObjectViewport.SpawnNPC();
	return;
}

function _SetSpawnOnShow()
{
	m_ObjectViewport.SetNPCInfo(spawnedIndex);
	m_ObjectViewport.SpawnNPC();
	return;
}

function SetViewPortSetting(int Id)
{
	local float tmpScale;
	local int OffsetY, OffsetX, Distance;

	Distance = 250;
	OffsetX = 0;
	switch(Id)
	{
		case 0:
			Distance = 120;
			tmpScale = 1.0000000;
			OffsetY = 1;
			break;
		case 1:
		case 2:
		case 3:
		case 40:
			tmpScale = 1.2000000;
			OffsetY = -11;
			break;
		case 4:
		case 5:
		case 6:
		case 41:
			tmpScale = 1.5000000;
			OffsetY = -1;
			break;
		case 7:
		case 8:
		case 9:
		case 42:
			tmpScale = 0.9000000;
			OffsetY = -1;
			break;
		case 10:
		case 11:
		case 12:
		case 43:
			tmpScale = 1.7000000;
			OffsetY = -8;
			break;
		case 13:
		case 14:
		case 15:
		case 44:
			tmpScale = 1.1000000;
			OffsetY = -1;
			break;
		case 16:
		case 17:
		case 18:
		case 45:
			tmpScale = 1.4000000;
			OffsetY = -3;
			break;
		case 19:
		case 20:
		case 21:
		case 46:
			tmpScale = 1.6000000;
			OffsetY = -1;
			break;
		case 22:
		case 23:
		case 24:
		case 47:
			tmpScale = 1.5000000;
			OffsetY = -5;
			break;
		case 25:
		case 26:
		case 27:
		case 48:
			tmpScale = 1.2000000;
			OffsetY = 0;
			break;
		case 28:
		case 29:
		case 30:
		case 49:
			tmpScale = 1.2000000;
			OffsetY = -1;
			break;
		case 31:
		case 32:
		case 33:
		case 50:
			tmpScale = 1.4000000;
			OffsetY = -8;
			break;
		case 34:
		case 35:
		case 36:
		case 51:
			tmpScale = 1.4000000;
			OffsetY = -17;
			break;
		case 37:
		case 38:
		case 39:
		case 52:
			tmpScale = 1.6000000;
			OffsetY = 0;
			break;
		default:
			tmpScale = 1.2000000;
			OffsetY = -1;
			break;
	}
	m_ObjectViewport.SetCharacterScale(tmpScale);
	m_ObjectViewport.SetCharacterOffsetY(OffsetY);
	m_ObjectViewport.SetCharacterOffsetX(OffsetX);
	m_ObjectViewport.SetCameraDistance(Distance);
	return;
}

function SetInfo(int NpcID)
{
	local string NpcName;
	local HomunculusAPI.HomunculusNpcLevelData npcLevelData;
	local int prevExp, currExp;

	NpcName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(NpcID);
	npcLevelData = HomunculusWndScript.API_GetHomunculusNpcLevelData(GetCurrHomunculusData().Id, GetCurrHomunculusData().Level);
	if((GetCurrHomunculusData().Level == 1))
	{
		prevExp = 0;
	}
	else
	{
		prevExp = HomunculusWndScript.API_GetHomunculusNpcLevelData(GetCurrHomunculusData().Id, (GetCurrHomunculusData().Level - 1)).MaxExp;
	}
	currExp = (npcLevelData.MaxExp - prevExp);
	ExpBar.SetPointExpPercentRate((float((GetCurrHomunculusData().Exp - prevExp)) / float(currExp)));
	ExpBar.ShowWindow();
	text0.SetText((((GetSystemString(88) $ ".") $ string(GetCurrHomunculusData().Level)) @ NpcName));
	ChkSetRevolutionBtn();
	return;
}

function ShowHideEvolotionBtn(bool isShow)
{
	if(isShow)
	{
		btn2.ShowWindow();
		EvolutionBtn_Tex.ShowWindow();
	}
	else
	{
		btn2.HideWindow();
		EvolutionBtn_Tex.HideWindow();
	}
	return;
}

function ChkSetRevolutionBtn()
{
	local INT64 CurrentValue, maxVlaue, MinValue;

	ShowHideEvolotionBtn(false);
	if((GetCurrHomunculusData().Type != 2))
	{
		return;
	}
	ShowHideEvolotionBtn(true);
	ExpBar.GetPoint(CurrentValue, maxVlaue, MinValue);
	if(((GetCurrHomunculusData().Activate || (CurrentValue < maxVlaue)) || (GetCurrHomunculusData().Level < 5)))
	{
		btn2.DisableWindow();
	}
	else
	{
		btn2.EnableWindow();
	}
	SetTooltipReward();
	return;
}

function SetActive(bool IsActive)
{
	if(IsActive)
	{
		btn0.SetButtonName(13363);
		texCommunion.Stop();
		texCommunion.SetLoopCount(99999);
		texCommunion.Play();
		texCommunion.ShowWindow();
	}
	else
	{
		btn0.SetButtonName(13362);
		texCommunion.Stop();
		texCommunion.HideWindow();
	}
	ChkSetRevolutionBtn();
	return;
}

function SetChangeHomunculusData()
{
	local HomunculusAPI.HomunculusNpcData npcData;

	CheckLevelUP();
	idx = GetCurrHomunculusData().idx;
	npcData = HomunculusWndScript.GetHomunculusNpcData(GetCurrHomunculusData().Id);
	SetGrade(GetCurrHomunculusData().Type);
	SetViewPortSetting(GetCurrHomunculusData().Id);
	SetViewPort(npcData.NpcID);
	SetInfo(npcData.NpcID);
	SetActive(GetCurrHomunculusData().Activate);
	btn0.EnableWindow();
	btn1.EnableWindow();
	if((lastRevolutionIdx == GetCurrHomunculusData().idx))
	{
		SpawnEffectRevolution();
	}
	return;
}

function _SetRevolutionIdx(int idx)
{
	lastRevolutionIdx = idx;
	return;
}

function CheckLevelUP()
{
	if((GetCurrHomunculusData().idx == idx))
	{
		if((Level < GetCurrHomunculusData().Level))
		{
			AddSystemMessage(13239);
			m_ObjectViewport.SpawnEffect("LineageEffect2.ui_spirit_lvup");
			m_ObjectViewport.PlayAnimation(1);
		}
	}
	Level = GetCurrHomunculusData().Level;
	return;
}

function SpawnEffectRevolution()
{
	lastRevolutionIdx = -1;
	AddSystemMessage(13969);
	m_ObjectViewport.SpawnEffect("LineageEffect2.ui_spirit_lvup");
	m_ObjectViewport.PlayAnimation(1);
	return;
}

function Handle_S_EX_ACTIVATE_HOMUNCULUS_RESULT()
{
	local UIPacket._S_EX_ACTIVATE_HOMUNCULUS_RESULT packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_ACTIVATE_HOMUNCULUS_RESULT(packet))
	{
		return;
	}
	if((packet.Type == 1))
	{
		homunculusWndMainListScript.SetActiveIdx(bool(packet.bActivate), requestedCommunionIdx);
		SetActive(bool(packet.bActivate));
	}
	else
	{
		AddSystemMessage(packet.nID);
	}
	requestedCommunionIdx = -1;
	return;
}

function HomunculusAPI.HomunculusData GetCurrHomunculusData()
{
	return HomunculusWndMainList(GetScript("HomunculusWnd.HomunculusWndMainList")).GetCurrHomunculusData();
}

function SetTooltipReward()
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;
	local ItemInfo iInfo;
	local int i;
	local HomunculusAPI.HomunculusNpcData npcData;

	if(GetCurrHomunculusData().Activate)
	{
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemMessage(13996), getInstanceL2Util().BrightWhite, "hs9", true, false);
		mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
		btn2.SetTooltipType("text");
		btn2.SetTooltipCustomType(mCustomTooltip);
		return;
	}
	npcData = HomunculusWndScript.GetHomunculusNpcData(GetCurrHomunculusData().Id);
	if((npcData.EvolutionCostPoint > 0))
	{
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14604), getInstanceL2Util().BrightWhite, "hs11", true, false);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	}
	iInfo = GetItemInfoByClassID(81812);
	iInfo.ItemNum = INT64(1);
	iInfo.Name = (GetSystemString(13336) @ GetSystemString(13343));
	addDrawItemGameItem(drawListArr, iInfo, true);
	iInfo = GetItemInfoByClassID(83051);
	iInfo.ItemNum = INT64(npcData.EvolutionCostPoint);
	addDrawItemGameItem(drawListArr, iInfo, true);
	i = 0;
	while((i < npcData.EvolutionCostItems.Length))
	{
		iInfo = GetItemInfoByClassID(npcData.EvolutionCostItems[i].ItemClassID);
		iInfo.ItemNum = npcData.EvolutionCostItems[i].ItemAmount;
		addDrawItemGameItem(drawListArr, iInfo, true);
		i++;
	}
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	btn2.SetTooltipType("text");
	btn2.SetTooltipCustomType(mCustomTooltip);
	return;
}

function HandleDialogOK(bool bOK)
{
	if(!DialogIsMine())
	{
		return;
	}
	switch(DialogGetID())
	{
		case 17:
			if(bOK)
			{
				HomunculusWndScript.API_C_EX_DELETE_HOMUNCULUS_DATA(GetCurrHomunculusData().idx);
			}
			break;
		default:
			break;
	}
	return;
}
