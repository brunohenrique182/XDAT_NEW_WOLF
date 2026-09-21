class HomunculusWndBirth extends UICommonAPI
	dependson(UIPacket);

const TIMEID_DELAY = 1;
const TIME_REFRESH = 5000;
const TIMEID_COOL = 2;
const TIMER_COOL_REFRESH = 1000;
const TIMEID_CREATESTART = 9;
const TIME_CREATESTART = 3000;
const DIALOGID_START = 1;

enum type_State
{
	non,                            // 0
	ing,                            // 1
	done                            // 2
};

var WindowHandle Me;
var string m_Windowname;
var L2Util util;
var StatusBarHandle HPBar;
var TextBoxHandle txtSP;
var StatusBarHandle VPBar;
var StatusBarHandle Stat0;
var StatusBarHandle Stat1;
var StatusBarHandle Stat2;
var StatusBarHandle Stat3;
var EffectViewportWndHandle effectViewport;
var ButtonHandle btn0;
var ButtonHandle btn1;
var ButtonHandle btn2;
var ButtonHandle btn3;
var ButtonHandle btnMain0;
var ButtonHandle btnMain1;
var HomunculusAPI.HomunCreateData currHmunCreateData;
var int MaxVitality;
var int CurrentHP;
var int CurrentSP;
var int CurrentVP;
var INT64 currentExpiredTime;
var int currentEffectStep;
var int CurrentState;
var bool insertedRequest;
var WindowHandle resultWnd;
var CharacterViewportWindowHandle m_ObjectViewport;
var TextBoxHandle txtResult0;
var EffectViewportWndHandle effectViewportResult;
var TextureHandle birthCircle_tex;
var AnimTextureHandle birthCircleInput_anitex;
var INT64 myHP;
var INT64 mySP;
var int myVP;
var bool isGachaState;
var HomunculusWnd HomunculusWndScript;
var HomunculusWndMainList homunculusWndMainListScript;
var HomunculusWndGacha homunculusWndGachaScript;
var L2UITween l2UITweenScript;
var int curTweenID;

function HandleGameInit()
{
	if(!HomunculusWndScript.ChkSerVer())
	{
		return;
	}
	currHmunCreateData = HomunculusWndScript.API_GetHomunCreateData();
	SetTooltip();
	return;
}

function SetTooltip()
{
	local string tmpMsg, Msg;
	local CustomTooltip t;

	tmpMsg = GetSystemMessage(13211);
	Msg = MakeFullSystemMsg(tmpMsg, MakeCostString(string(currHmunCreateData.HpVolume)));
	btn0.SetTooltipCustomType(MakeTooltipSimpleText(Msg));
	Msg = MakeFullSystemMsg(tmpMsg, MakeCostString(string(currHmunCreateData.SpVolume)));
	btn1.SetTooltipCustomType(MakeTooltipSimpleText(Msg));
	Msg = MakeFullSystemMsg(tmpMsg, GetSystemString(13398));
	btn2.SetTooltipCustomType(MakeTooltipSimpleText(Msg));
	util.setCustomTooltip(t);
	util.ToopTipMinWidth(300);
	util.ToopTipInsertText(GetSystemString(13345));
	btn3.SetTooltipCustomType(util.getCustomToolTip());
	util.setCustomTooltip(t);
	util.ToopTipMinWidth(200);
	util.ToopTipInsertText(GetSystemString(13548));
	GetButtonHandle((m_Windowname $ ".Help_Btn")).SetTooltipCustomType(util.getCustomToolTip());
	return;
}

function Initialize()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	util = L2Util(GetScript("L2Util"));
	HPBar = GetStatusBarHandle((m_Windowname $ ".HPBar"));
	txtSP = GetTextBoxHandle((m_Windowname $ ".txtSP"));
	VPBar = GetStatusBarHandle((m_Windowname $ ".VPBar"));
	Stat0 = GetStatusBarHandle((m_Windowname $ ".Stat0"));
	Stat1 = GetStatusBarHandle((m_Windowname $ ".Stat1"));
	Stat2 = GetStatusBarHandle((m_Windowname $ ".Stat2"));
	Stat3 = GetStatusBarHandle((m_Windowname $ ".Stat3"));
	effectViewport = GetEffectViewportWndHandle((m_Windowname $ ".EffectViewport"));
	btn0 = GetButtonHandle((m_Windowname $ ".btn0"));
	btn1 = GetButtonHandle((m_Windowname $ ".btn1"));
	btn2 = GetButtonHandle((m_Windowname $ ".btn2"));
	btn3 = GetButtonHandle((m_Windowname $ ".btn3"));
	btnMain0 = GetButtonHandle((m_Windowname $ ".btnMain0"));
	btnMain1 = GetButtonHandle((m_Windowname $ ".btnMain1"));
	resultWnd = GetWindowHandle((m_Windowname $ ".resultWnd"));
	m_ObjectViewport = GetCharacterViewportWindowHandle((m_Windowname $ ".resultWnd.ObjectViewport"));
	m_ObjectViewport.SetUISound(true);
	txtResult0 = GetTextBoxHandle((m_Windowname $ ".resultWnd.txtResult0"));
	effectViewportResult = GetEffectViewportWndHandle((m_Windowname $ ".resultWnd.EffectViewportResult"));
	birthCircle_tex = GetTextureHandle((m_Windowname $ ".birthCircle_tex"));
	birthCircleInput_anitex = GetAnimTextureHandle((m_Windowname $ ".birthCircleInput_anitex"));
	HomunculusWndScript = HomunculusWnd(GetScript("HomunculusWnd"));
	homunculusWndMainListScript = HomunculusWndMainList(GetScript("HomunculusWnd.HomunculusWndMainList"));
	homunculusWndGachaScript = HomunculusWndGacha(GetScript("HomunculusWnd.HomunculusWndGacha"));
	l2UITweenScript = L2UITween(GetScript("L2UITween"));
	MaxVitality = GetMaxVitality();
	SetTooltip();
	curTweenID = -1;
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(150);
	RegisterEvent(1710);
	RegisterEvent(1720);
	RegisterEvent(191);
	RegisterEvent(180);
	RegisterEvent(9570);
	RegisterEvent(11460);
	RegisterEvent(11470);
	RegisterEvent((100000 + 855));
	RegisterEvent((100000 + 856));
	RegisterEvent((100000 + 857));
	RegisterEvent((100000 + 867));
	return;
}

function OnLoad()
{
	Initialize();
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 9570:
			if(Me.IsShowWindow())
			{
				HandleAdenaCount();
			}
			break;
		case 1710:
			HandleDialogOK(true);
			break;
		case 1720:
			HandleDialogOK(false);
			break;
		case 191:
		case 180:
			if(Me.IsShowWindow())
			{
				SetMyStat();
			}
			break;
		case 150:
			if(HomunculusWndScript.ChkSerVer())
			{
				HandleGameInit();
			}
			break;
		case 11460:
			HandleListItems();
			break;
		case 11470:
			Handle_EV_ShowHomunculusBirthInfo(param);
			break;
		case (100000 + 855):
			Handle_S_EX_HOMUNCULUS_CREATE_START_RESULT();
			break;
		case (100000 + 856):
			Handle_S_EX_HOMUNCULUS_INSERT_RESULT();
			break;
		case (100000 + 857):
			Handle_S_EX_HOMUNCULUS_SUMMON_RESULT();
			break;
		case (100000 + 867):
			Handle_S_EX_HOMUNCULUS_HPSPVP();
			break;
		default:
			break;
	}
	return;
}

function OnCallUCFunction(string funcName, string param)
{
	switch(funcName)
	{
		case "tweenEnd":
			Tweenkle(int(param));
			break;
		default:
			break;
	}
	return;
}

function OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case 1:
			Me.KillTimer(1);
			HandleCanBtns();
			break;
		case 2:
			HandleTime();
			break;
		case 9:
			TweenStop();
			birthCircle_tex.SetAlpha(0);
			Me.KillTimer(9);
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "btn0":
			API_C_EX_HOMUNCULUS_INSERT(0);
			btn0.DisableWindow();
			break;
		case "btn1":
			API_C_EX_HOMUNCULUS_INSERT(1);
			btn1.DisableWindow();
			break;
		case "btn2":
			API_C_EX_HOMUNCULUS_INSERT(2);
			btn2.DisableWindow();
			break;
		case "btnMain0":
			HandleClickBtnMain0();
			break;
		case "btnMain1":
			HomunculusWndScript.API_C_EX_HOMUNCULUS_SUMMON();
			break;
		case "btnConfirm":
			HandleConfirm();
			break;
		case "swapBtn":
			GetWindowHandle("HomunculusWndProbability").HideWindow();
			HandleSwapCacha();
			break;
		case "Probability_Btn":
			HomunculusWndProbability(GetScript("HomunculusWndProbability")).API_C_EX_REQ_HOMUNCULUS_PROB_LIST(0);
			break;
		default:
			break;
	}
	return;
}

function API_C_EX_HOMUNCULUS_INSERT(int Type)
{
	insertedRequest = true;
	HomunculusWndScript.API_C_EX_HOMUNCULUS_INSERT(Type);
	Me.SetTimer(1, 5000);
	return;
}

function Show()
{
	if(isGachaState)
	{
		SetShowGacha();
	}
	else
	{
		SetShowBirth();
	}
	return;
}

function SetShowGacha()
{
	homunculusWndGachaScript.Show();
	Me.HideWindow();
	SetEffectByPer(-1.0000000);
	return;
}

function SetShowBirth()
{
	HomunculusWndScript.API_C_EX_SHOW_HOMUNCULUS_INFO(0);
	homunculusWndGachaScript.Hide();
	Me.ShowWindow();
	Me.SetFocus();
	SetMyStat();
	HandleAdenaCount();
	return;
}

function Hide()
{
	Me.HideWindow();
	SetEffectByPer(-1.0000000);
	homunculusWndGachaScript.Hide();
	return;
}

function HandleTime()
{
	currentExpiredTime = (currentExpiredTime - INT64(1));
	if(!CanChargeTime())
	{
		Me.KillTimer(2);
	}
	Stat3.SetPoint((INT64(currHmunCreateData.CostTime) - currentExpiredTime), INT64(currHmunCreateData.CostTime));
	HandleCurrPercent();
	HandleCanBtns();
	return;
}

function HandleConfirm()
{
	resultWnd.HideWindow();
	HomunculusWndScript.SetState(Main);
	return;
}

function HandleClickBtnMain0()
{
	local string Msg;

	Msg = MakeFullSystemMsg(GetSystemMessage(13209), MakeCostStringINT64(currHmunCreateData.CostAdena));
	if((CurrentState == 0))
	{
		TweenStart();
		Class'InterfaceClassic.UICommonAPI'.static.DialogSetID(1);
		DialogShow(DialogModalType_Modalless, DialogType_OKCancel, Msg);
	}
	return;
}

function Handle_EV_ShowHomunculusBirthInfo(string param)
{
	local int Type;

	ParseInt(param, "type", Type);
	ParseInt(param, "CurrentHP", CurrentHP);
	ParseInt(param, "CurrentSP", CurrentSP);
	ParseInt(param, "CurrentVP", CurrentVP);
	if((CurrentState == 0))
	{
		currentExpiredTime = INT64(currHmunCreateData.CostTime);
	}
	else
	{
		currentExpiredTime = HomunculusWndScript.API_GetRemainBirthSeconds();
	}
	SetState(Type);
	Stat0.SetPoint(INT64(CurrentHP), INT64(currHmunCreateData.HpCount));
	Stat1.SetPoint(INT64(CurrentSP), INT64(currHmunCreateData.SpCount));
	Stat2.SetPoint(INT64(CurrentVP), INT64(currHmunCreateData.VpCount));
	Stat3.SetPoint((INT64(currHmunCreateData.CostTime) - currentExpiredTime), INT64(currHmunCreateData.CostTime));
	Me.KillTimer(2);
	if(CanChargeTime())
	{
		Me.SetTimer(2, 1000);
	}
	HandleCurrPercent();
	HandleCanBtns();
	return;
}

function Handle_S_EX_HOMUNCULUS_CREATE_START_RESULT()
{
	local UIPacket._S_EX_HOMUNCULUS_CREATE_START_RESULT packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_HOMUNCULUS_CREATE_START_RESULT(packet))
	{
		return;
	}
	Me.KillTimer(9);
	if((packet.Type == 1))
	{
	}
	else
	{
		AddSystemMessage(packet.nID);
		TweenStop();
	}
	return;
}

function Handle_S_EX_HOMUNCULUS_INSERT_RESULT()
{
	local UIPacket._S_EX_HOMUNCULUS_INSERT_RESULT packet;

	insertedRequest = false;
	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_HOMUNCULUS_INSERT_RESULT(packet))
	{
		return;
	}
	AddSystemMessage(packet.nID);
	if((packet.Type == 0))
	{
		return;
	}
	else
	{
		birthCircleInput_anitex.Stop();
		birthCircleInput_anitex.Play();
		Me.KillTimer(1);
		HandleCanBtns();
	}
	return;
}

function Handle_S_EX_HOMUNCULUS_SUMMON_RESULT()
{
	local UIPacket._S_EX_HOMUNCULUS_SUMMON_RESULT packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_HOMUNCULUS_SUMMON_RESULT(packet))
	{
		return;
	}
	AddSystemMessage(packet.nID);
	if((packet.Type == 0))
	{
	}
	else
	{
		resultWnd.ShowWindow();
	}
	return;
}

function Handle_S_EX_HOMUNCULUS_HPSPVP()
{
	local UIPacket._S_EX_HOMUNCULUS_HPSPVP packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_HOMUNCULUS_HPSPVP(packet))
	{
		return;
	}
	myHP = INT64(packet.nHP);
	mySP = packet.nSP;
	myVP = packet.nVP;
	SetMyStatusBars();
	return;
}

function HandleAdenaCount()
{
	local CustomTooltip t;
	local string Msg;

	util.setCustomTooltip(t);
	util.ToopTipMinWidth(10);
	Msg = MakeFullSystemMsg(GetSystemMessage(13210), MakeCostStringINT64(currHmunCreateData.CostAdena));
	if((currHmunCreateData.CostAdena > GetAdena()))
	{
		util.ToopTipInsertText(Msg, true, false, COLOR_RED);
	}
	else
	{
		util.ToopTipInsertText(Msg, true, false);
	}
	HandlebtnMain0();
	btnMain0.SetTooltipCustomType(util.getCustomToolTip());
	return;
}

function HandleListItems()
{
	local int i;
	local array<HomunculusAPI.HomunculusData> homunculusDatas;

	if(!Me.IsShowWindow())
	{
		return;
	}
	homunculusDatas = HomunculusWndScript.API_GetHomunculusDatas();
	HandlebtnMain0();
	i = 0;
	while((i < homunculusDatas.Length))
	{
		if(homunculusDatas[i].IsNew)
		{
			SetHomunculusData(homunculusDatas[i]);
			return;
		}
		i++;
	}
	return;
}

function HandlebtnMain0()
{
	if((currHmunCreateData.CostAdena > GetAdena()))
	{
		btnMain0.DisableWindow();
	}
	else if((homunculusWndMainListScript.GetEmptySlot() == -1))
	{
		btnMain0.DisableWindow();
	}
	else
	{
		btnMain0.EnableWindow();
	}
	return;
}

function SetHomunculusData(HomunculusAPI.HomunculusData Data)
{
	local HomunculusAPI.HomunculusNpcData npcData;

	npcData = HomunculusWndScript.GetHomunculusNpcData(Data.Id);
	SetViewPortSetting(Data.Id);
	SetViewPort(npcData.NpcID);
	SetInfo(npcData.NpcID, Data.Type, Data.Level);
	resultWnd.ShowWindow();
	effectViewportResult.SpawnEffect("LineageEffect2.ui_upgrade_succ");
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
			m_ObjectViewport.SetBackgroundTex(("L2UI_EPIC.HomunCulusWnd.Homun_birthResultBG_0" $ string((Type + 1))));
			break;
		default:
			break;
	}
	return;
}

function HandleCurrPercent()
{
	local float currPer;

	if((CurrentState == 0))
	{
		SetEffectByPer(-1.0000000);
		return;
	}
	currPer = (float(CurrentHP) / float(currHmunCreateData.HpCount));
	(currPer += (float(CurrentSP) / float(currHmunCreateData.SpCount)));
	(currPer += (float(CurrentVP) / float(currHmunCreateData.VpCount)));
	(currPer += (float((INT64(currHmunCreateData.CostTime) - currentExpiredTime)) / float(currHmunCreateData.CostTime)));
	(currPer /= 4.0000000);
	SetEffectByPer(currPer);
	return;
}

function SetEffect(string EffectName, optional int dist)
{
	effectViewport.SetCameraDistance(float(dist));
	effectViewport.ShowWindow();
	effectViewport.SpawnEffect(EffectName);
	return;
}

function SetEffectByPer(float currPer)
{
	local int newEffectStep;

	if((currPer == -1.0000000))
	{
		newEffectStep = 0;
	}
	else if((currPer <= 0.2500000))
	{
		newEffectStep = 1;
	}
	else if((currPer <= 0.5000000))
	{
		newEffectStep = 2;
	}
	else if((currPer <= 0.7500000))
	{
		newEffectStep = 3;
	}
	else if((currPer <= 1.0000000))
	{
		newEffectStep = 4;
	}
	else
	{
		newEffectStep = 0;
	}
	if((currentEffectStep == newEffectStep))
	{
		return;
	}
	currentEffectStep = newEffectStep;
	switch(currentEffectStep)
	{
		case 0:
			SetEffect("", 0);
			break;
		case 1:
			SetEffect("LineageEffect_br.br_e_lamp_deco_d", 240);
			break;
		case 2:
			SetEffect("LineageEffect_br.br_e_lamp_deco_d", 192);
			break;
		case 3:
			SetEffect("LineageEffect_br.br_e_lamp_deco_d", 146);
			break;
		case 4:
			SetEffect("LineageEffect_br.br_e_lamp_deco_d", 100);
			break;
		default:
			break;
	}
	return;
}

function TweenStart()
{
	Me.SetTimer(9, 3000);
	birthCircle_tex.SetAlpha(0);
	TweenAdd(240, 0, 3000, OUT_BOUNCE);
	return;
}

function TweenHide()
{
	birthCircle_tex.SetAlpha(240);
	TweenAdd(-100, 1, 2000, IN_STRONG);
	return;
}

function TweenShow()
{
	birthCircle_tex.SetAlpha(140);
	TweenAdd(100, 2, 2000, OUT_STRONG);
	return;
}

function Tweenkle(int Id)
{
	switch(Id)
	{
		case 0:
			TweenHide();
			break;
		case 1:
			TweenShow();
			break;
		case 2:
			TweenHide();
			break;
		default:
			break;
	}
	return;
}

function SetMyStat()
{
	local UserInfo uInfo;

	if(GetPlayerInfo(uInfo))
	{
		myHP = uInfo.nCurHP;
		mySP = uInfo.nSP;
		myVP = uInfo.nVitality;
		SetMyStatusBars();
	}
	return;
}

function SetMyStatusBars()
{
	local UserInfo uInfo;

	if(GetPlayerInfo(uInfo))
	{
		HPBar.SetPoint(myHP, uInfo.nMaxHP);
		txtSP.SetText(string(mySP));
		VPBar.SetPoint(INT64(myVP), INT64(MaxVitality));
		if(!insertedRequest)
		{
			HandleCanBtns();
		}
	}
	return;
}

function HandleCanBtns()
{
	if(CanChargeHP())
	{
		btn0.EnableWindow();
	}
	else
	{
		btn0.DisableWindow();
	}
	if(CanChargeSP())
	{
		btn1.EnableWindow();
	}
	else
	{
		btn1.DisableWindow();
	}
	if(CanChargeVP())
	{
		btn2.EnableWindow();
	}
	else
	{
		btn2.DisableWindow();
	}
	if(CanChargeTime())
	{
		btn3.EnableWindow();
	}
	else
	{
		btn3.DisableWindow();
	}
	return;
}

function SetInfo(int NpcID, int Type, int Level)
{
	local string NpcName;

	NpcName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(NpcID);
	txtResult0.SetText(((((GetSystemString(88) $ ".") $ string(Level)) @ GetGrade(Type)) @ NpcName));
	SetGrade(Type);
	return;
}

function string GetGrade(int Type)
{
	switch(Type)
	{
		case 0:
			return GetSystemString(441);
			break;
		case 1:
			return GetSystemString(3290);
			break;
		case 2:
			return GetSystemString(13336);
			break;
		default:
			break;
	}
	return "";
}

function SetViewPort(int NpcID)
{
	m_ObjectViewport.SetSpawnDuration(0.1000000);
	m_ObjectViewport.SetNPCInfo(NpcID);
	m_ObjectViewport.SpawnNPC();
	m_ObjectViewport.PlayAnimation(0);
	return;
}

function SetViewPortSetting(int Id)
{
	local float tmpScale;
	local int OffsetY;

	switch(Id)
	{
		case 0:
			tmpScale = 0.5000000;
			OffsetY = -1;
			break;
		case 1:
		case 2:
		case 3:
			tmpScale = 1.2000000;
			OffsetY = -11;
			break;
		case 4:
		case 5:
		case 6:
			tmpScale = 1.5000000;
			OffsetY = -1;
			break;
		case 7:
		case 8:
		case 9:
			tmpScale = 0.9000000;
			OffsetY = -1;
			break;
		case 10:
		case 11:
		case 12:
			tmpScale = 1.7000000;
			OffsetY = -8;
			break;
		case 13:
		case 14:
		case 15:
			tmpScale = 1.1000000;
			OffsetY = -1;
			break;
		case 16:
		case 17:
		case 18:
			tmpScale = 1.4000000;
			OffsetY = -3;
			break;
		case 19:
		case 20:
		case 21:
			tmpScale = 1.6000000;
			OffsetY = -1;
			break;
		case 22:
		case 23:
		case 24:
			tmpScale = 1.5000000;
			OffsetY = -5;
			break;
		case 25:
		case 26:
		case 27:
			tmpScale = 1.2000000;
			OffsetY = 0;
			break;
		case 28:
		case 29:
		case 30:
			tmpScale = 1.2000000;
			OffsetY = -1;
			break;
		case 31:
		case 32:
		case 33:
			tmpScale = 1.4000000;
			OffsetY = -8;
			break;
		case 34:
		case 35:
		case 36:
			tmpScale = 1.4000000;
			OffsetY = -17;
			break;
		case 37:
		case 38:
		case 39:
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
		case 1:
			if(bOK)
			{
				HomunculusWndScript.API_C_EX_HOMUNCULUS_CREATE_START();
			}
			break;
		default:
			break;
	}
	return;
}

function TweenAdd(int TargetAlpha, int Id, int Duration, L2UITween.easeType Type)
{
	local L2UITween.TweenObject tweenObjectData;

	tweenObjectData.Owner = ("HomunculusWnd." $ m_Windowname);
	tweenObjectData.Id = Id;
	tweenObjectData.Target = birthCircle_tex;
	tweenObjectData.Duration = float(Duration);
	tweenObjectData.Alpha = float(TargetAlpha);
	tweenObjectData.ease = easeType(Type);
	TweenStop();
	l2UITweenScript.AddTweenObject(tweenObjectData);
	curTweenID = Id;
	return;
}

function TweenStop()
{
	if((curTweenID != -1))
	{
		l2UITweenScript.StopTween(("HomunculusWnd." $ m_Windowname), curTweenID);
	}
	curTweenID = -1;
	return;
}

function SetState(int State)
{
	CurrentState = State;
	switch(CurrentState)
	{
		case 0:
			TweenStop();
			birthCircle_tex.HideWindow();
			Me.KillTimer(2);
			btnMain0.ShowWindow();
			btnMain1.HideWindow();
			HandleCanBtns();
			resultWnd.HideWindow();
			HomunculusWndScript.HideNotice(0);
			break;
		case 1:
			birthCircle_tex.ShowWindow();
			if((curTweenID == -1))
			{
				TweenShow();
			}
			btnMain0.HideWindow();
			btnMain1.ShowWindow();
			btnMain1.DisableWindow();
			HandleCanBtns();
			resultWnd.HideWindow();
			HomunculusWndScript.HideNotice(0);
			break;
		case 2:
			TweenStop();
			birthCircle_tex.ShowWindow();
			btnMain0.HideWindow();
			btnMain1.ShowWindow();
			btnMain1.EnableWindow();
			HandleCanBtns();
			resultWnd.HideWindow();
			HomunculusWndScript.SetNotice(0);
			break;
		default:
			break;
	}
	return;
}

function HandleSwapCacha()
{
	isGachaState = !isGachaState;
	Show();
	if(DialogIsMine())
	{
		Class'InterfaceClassic.DialogBox'.static.Inst().HideDialog();
	}
	return;
}

function SetGachaState()
{
	isGachaState = true;
	Show();
	return;
}

function SetBirthState()
{
	isGachaState = false;
	Show();
	return;
}

function bool GetIsMaxHP()
{
	return (CurrentHP == currHmunCreateData.HpCount);
}

function bool GetIsMaxSP()
{
	return (CurrentSP == currHmunCreateData.SpCount);
}

function bool GetIsMaxVP()
{
	return (CurrentVP == currHmunCreateData.VpCount);
}

function bool GetIsMaxTime()
{
	return (currentExpiredTime == INT64(0));
}

function bool CanChargeHP()
{
	if((CurrentState != 1))
	{
		return false;
	}
	if(GetIsMaxHP())
	{
		return false;
	}
	return (INT64(currHmunCreateData.HpVolume) <= myHP);
}

function bool CanChargeSP()
{
	if((CurrentState != 1))
	{
		return false;
	}
	if(GetIsMaxSP())
	{
		return false;
	}
	return (currHmunCreateData.SpVolume <= mySP);
}

function bool CanChargeVP()
{
	if((CurrentState != 1))
	{
		return false;
	}
	if(GetIsMaxVP())
	{
		return false;
	}
	return (currHmunCreateData.VpVolume <= myVP);
}

function bool CanChargeTime()
{
	if((CurrentState != 1))
	{
		return false;
	}
	if(GetIsMaxTime())
	{
		return false;
	}
	return (currentExpiredTime <= INT64(currHmunCreateData.CostTime));
}

function bool BeProgress()
{
	return (CurrentState != 0);
}
