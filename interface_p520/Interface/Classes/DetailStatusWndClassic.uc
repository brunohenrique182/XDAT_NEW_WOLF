class DetailStatusWndClassic extends UICommonAPI
	dependson(UIPacket);

const DIALOG_DetailStatusWnd = 90005;
const NSTATUS_SMALLBARSIZE = 85;
const NSTATUS_BARHEIGHT = 12;
const ElixirItemID = 94314;

struct SubjobInfo
{
	var int Id;
	var int ClassID;
	var int Level;
	var int Type;
};

var string m_Windowname;
var string m_Statsinfo_UsePoint_Win;
var int m_UserID;
var HennaInfo m_HennaInfo;
var WindowHandle Me;
var TextBoxHandle txtClassName;
var TextBoxHandle txtSP;
var TextBoxHandle txtName1;
var TextBoxHandle txtName2;
var TextBoxHandle txtHeadPledge;
var TextBoxHandle txtPledge;
var TextBoxHandle txtLvHead;
var TextBoxHandle txtLvName;
var TextBoxHandle txtHeadRank;
var TextBoxHandle txtRank;
var StatusBarHandle texHP;
var StatusBarHandle texMP;
var StatusBarHandle texCP;
var TextBoxHandle txtPhysicalAttack;
var TextBoxHandle txtPhysicalDefense;
var TextBoxHandle txtHitRate;
var TextBoxHandle txtCriticalRate;
var TextBoxHandle txtPhysicalAttackSpeed;
var TextBoxHandle txtMagicalAttack;
var TextBoxHandle txtMagicDefense;
var TextBoxHandle txtPhysicalAvoid;
var TextBoxHandle txtGmMoving;
var TextBoxHandle txtHeadMovingSpeed;
var TextBoxHandle txtMovingSpeed;
var TextBoxHandle txtHeadMagicCastingSpeed;
var TextBoxHandle txtMagicCastingSpeed;
var TextBoxHandle txtCriminalRate;
var TextBoxHandle txtSociality_PVP;
var TextBoxHandle txtSociality_PK;
var TextBoxHandle txtBonusVote;
var TextBoxHandle txtRaidPoint;
var TextureHandle texPledgeCrest;
var TextureHandle VitalityTex;
var ButtonHandle SpExtractOpenBtn;
var ButtonHandle Dye_BTN;
var AnimTextureHandle APActive;
var int MaxVitality;
var int nCanUseAP;
var L2Util util;
var TextBoxHandle txtDisapprove;
var WindowHandle ItemScoreWnd;
var TextBoxHandle txtItemScore;
var AnimTextureHandle ClassChangeLightBig;
var TextureHandle ClassBgMain_Big;
var TextureHandle ClassMarkBig;
var array<SubjobInfo> subjobInfoArray;
var SubjobInfo beforeSubjobInfo;
var int currentSubjobClassNum;
var bool isDualClass;
var int Race;
var int statusCanPlus;
var int statusMax;
var int statusPlusedCurrent;
var ButtonHandle UsePoint_Apply_BTN;
var ButtonHandle UsePoint_Cancel_BTN;
var ButtonHandle UsePoint_Reset_BTN;
var TextBoxHandle Statsinfo_UsePoint_text;
var WindowHandle StatConfirmResetWnd;
var WindowHandle StatConfirmApplyWnd;
var WindowHandle ConfirmWnd;
var RichListCtrlHandle ResetCharge_ListCtrl;
var TextBoxHandle NumPoint_text;
var array<int> statusPlused;
var ButtonHandle Reset_Btn;
var ButtonHandle FightInfo_BTN;
var ElementalSpiritWnd ElementalSpiritWndScript;
var TextBoxHandle ElixirPoint_txt;

event OnRegisterEvent()
{
	RegisterEvent(180);
	RegisterEvent(260);
	RegisterEvent(191);
	RegisterEvent(201);
	RegisterEvent(11680);
	RegisterEvent(211);
	RegisterEvent(221);
	RegisterEvent(231);
	RegisterEvent(241);
	RegisterEvent(4100);
	RegisterEvent(1710);
	RegisterEvent(1720);
	RegisterEvent(5310);
	RegisterEvent(5311);
	RegisterEvent(5312);
	RegisterEvent(40);
	RegisterEvent(4110);
	RegisterEvent(3400);
	RegisterEvent(9570);
	RegisterEvent(2070);
	RegisterEvent(2070);
	RegisterEvent(EV_PacketID(1165));
	return;
}

event OnLoad()
{
	util = L2Util(GetScript("L2Util"));
	SetClosingOnESC();
	InitializeCOD();
	Me.EnableWindow();
	MaxVitality = GetMaxVitality();
	nCanUseAP = 0;
	return;
}

function InitializeCOD()
{
	isDualClass = false;
	Me = GetWindowHandle("DetailStatusWndClassic");
	ClassBgMain_Big = GetTextureHandle((m_Windowname $ ".ClassBgMain_Big"));
	ClassMarkBig = GetTextureHandle((m_Windowname $ ".ClassMarkBig"));
	txtClassName = GetTextBoxHandle((m_Windowname $ ".txtClassName"));
	txtSP = GetTextBoxHandle((m_Windowname $ ".txtSP"));
	txtName1 = GetTextBoxHandle((m_Windowname $ ".txtName1"));
	txtName2 = GetTextBoxHandle((m_Windowname $ ".txtName2"));
	txtHeadPledge = GetTextBoxHandle((m_Windowname $ ".txtHeadPledge"));
	txtPledge = GetTextBoxHandle((m_Windowname $ ".txtPledge"));
	txtLvHead = GetTextBoxHandle((m_Windowname $ ".txtLvHead"));
	txtLvName = GetTextBoxHandle((m_Windowname $ ".txtLvName"));
	txtHeadRank = GetTextBoxHandle((m_Windowname $ ".txtHeadRank"));
	txtRank = GetTextBoxHandle((m_Windowname $ ".txtRank"));
	texHP = GetStatusBarHandle((m_Windowname $ ".texHP"));
	texMP = GetStatusBarHandle((m_Windowname $ ".texMP"));
	texCP = GetStatusBarHandle((m_Windowname $ ".texCP"));
	txtPhysicalAttack = GetTextBoxHandle((m_Windowname $ ".txtPhysicalAttack"));
	txtPhysicalDefense = GetTextBoxHandle((m_Windowname $ ".txtPhysicalDefense"));
	txtHitRate = GetTextBoxHandle((m_Windowname $ ".txtHitRate"));
	txtCriticalRate = GetTextBoxHandle((m_Windowname $ ".txtCriticalRate"));
	txtPhysicalAttackSpeed = GetTextBoxHandle((m_Windowname $ ".txtPhysicalAttackSpeed"));
	txtMagicalAttack = GetTextBoxHandle((m_Windowname $ ".txtMagicalAttack"));
	txtMagicDefense = GetTextBoxHandle((m_Windowname $ ".txtMagicDefense"));
	txtPhysicalAvoid = GetTextBoxHandle((m_Windowname $ ".txtPhysicalAvoid"));
	txtGmMoving = GetTextBoxHandle((m_Windowname $ ".txtGmMoving"));
	txtMovingSpeed = GetTextBoxHandle((m_Windowname $ ".txtMovingSpeed"));
	txtMagicCastingSpeed = GetTextBoxHandle((m_Windowname $ ".txtMagicCastingSpeed"));
	txtHeadMovingSpeed = GetTextBoxHandle((m_Windowname $ ".txtHeadMovingSpeed"));
	txtHeadMagicCastingSpeed = GetTextBoxHandle((m_Windowname $ ".txtHeadMagicCastingSpeed"));
	txtCriminalRate = GetTextBoxHandle((m_Windowname $ ".txtCriminalRate"));
	txtSociality_PVP = GetTextBoxHandle((m_Windowname $ ".txtSociality_PVP"));
	txtSociality_PK = GetTextBoxHandle((m_Windowname $ ".txtSociality_PK"));
	txtBonusVote = GetTextBoxHandle((m_Windowname $ ".txtRemainSulffrage"));
	txtDisapprove = GetTextBoxHandle((m_Windowname $ ".txtDisapprove"));
	txtRaidPoint = GetTextBoxHandle((m_Windowname $ ".txtRaidPoint"));
	texPledgeCrest = GetTextureHandle((m_Windowname $ ".texPledgeCrest"));
	VitalityTex = GetTextureHandle((m_Windowname $ ".LifeForceTex"));
	SpExtractOpenBtn = GetButtonHandle((m_Windowname $ ".SPExtract_Btn"));
	Dye_BTN = GetButtonHandle((m_Windowname $ ".Dye_BTN"));
	APActive = GetAnimTextureHandle((m_Windowname $ ".APActive"));
	ItemScoreWnd = GetWindowHandle((m_Windowname $ ".ItemScoreWnd"));
	txtItemScore = GetTextBoxHandle((ItemScoreWnd.m_WindowNameWithFullPath $ ".txtItemScore"));
	FightInfo_BTN = GetButtonHandle((m_Windowname $ ".FightInfo_BTN"));
	ElixirPoint_txt = GetTextBoxHandle((m_Windowname $ ".Statsinfo_Elixir_Win.ElixirPoint_txt"));
	UsePoint_Apply_BTN = GetButtonHandle((m_Statsinfo_UsePoint_Win $ ".UsePoint_Apply_BTN"));
	UsePoint_Cancel_BTN = GetButtonHandle((m_Statsinfo_UsePoint_Win $ ".UsePoint_Cancel_BTN"));
	UsePoint_Reset_BTN = GetButtonHandle((m_Statsinfo_UsePoint_Win $ ".UsePoint_Reset_BTN"));
	Statsinfo_UsePoint_text = GetTextBoxHandle((m_Statsinfo_UsePoint_Win $ ".Statsinfo_UsePoint_text"));
	StatConfirmResetWnd = GetWindowHandle((m_Windowname $ ".ConfirmWnd.ResetWnd"));
	StatConfirmApplyWnd = GetWindowHandle((m_Windowname $ ".ConfirmWnd.ApplyWnd"));
	ConfirmWnd = GetWindowHandle((m_Windowname $ ".ConfirmWnd"));
	StatConfirmResetWnd.HideWindow();
	StatConfirmApplyWnd.HideWindow();
	ConfirmWnd.HideWindow();
	ResetCharge_ListCtrl = GetRichListCtrlHandle((m_Windowname $ ".ConfirmWnd.ResetWnd.ResetCharge_ListCtrl"));
	NumPoint_text = GetTextBoxHandle((m_Windowname $ ".ConfirmWnd.ResetWnd.NumPoint_text"));
	GetTextBoxHandle((m_Windowname $ ".ConfirmWnd.ResetWnd.ResetPoint_text")).SetText(((GetSystemString(13118) $ "/") $ GetSystemString(3155)));
	Reset_Btn = GetButtonHandle((m_Windowname $ ".ConfirmWnd.ResetWnd.Reset_BTN"));
	ElementalSpiritWndScript = ElementalSpiritWnd(GetScript("ElementalSpiritWnd"));
	if((IsShowItemScore() == false))
	{
		ItemScoreWnd.HideWindow();
	}
	return;
}

event OnEnterState(name a_CurrentStateName)
{
	HandleUpdateUserInfo();
	return;
}

event OnShow()
{
	if(IsUseRenewalSkillWnd())
	{
		SpExtractOpenBtn.ShowWindow();
	}
	else
	{
		SpExtractOpenBtn.HideWindow();
	}
	SetElixirInfo();
	HandleUpdateUserInfo();
	InitStatusInfo();
	return;
}

event OnEvent(int Event_ID, string param)
{
	if((Event_ID == 180))
	{
		HandleUpdateUserInfo();
	}
	else if((Event_ID == 260))
	{
		HandleUpdateHennaInfo(param);
	}
	else if((Event_ID == 191))
	{
		HandleUpdateStatusGauge(param, 0);
	}
	else if((Event_ID == 201))
	{
		HandleUpdateStatusGauge(param, 0);
	}
	else if((Event_ID == 11680))
	{
		HandleUpdateMyMaxHPBlockPer(param);
	}
	else if((Event_ID == 211))
	{
		HandleUpdateStatusGauge(param, 1);
	}
	else if((Event_ID == 221))
	{
		HandleUpdateStatusGauge(param, 1);
	}
	else if((Event_ID == 231))
	{
		HandleUpdateStatusGauge(param, 2);
	}
	else if((Event_ID == 241))
	{
		HandleUpdateStatusGauge(param, 2);
	}
	else if((Event_ID == 3400))
	{
		HandleToggle();
	}
	else if((Event_ID == 5310))
	{
		updateSubjobInfo(param, Event_ID);
	}
	else if((Event_ID == 5311))
	{
		updateSubjobInfo(param, Event_ID);
	}
	else if((Event_ID == 5312))
	{
		updateSubjobInfo(param, Event_ID);
		ExecuteEvent(3280);
	}
	else if((Event_ID == 1710))
	{
		HandleDialogOK();
	}
	else if((Event_ID == 1720))
	{
		if(DialogIsMine())
		{
			Me.EnableWindow();
		}
	}
	else if((Event_ID == 4110))
	{
		HandleVitalityEffectInfo(param);
	}
	else if(((Event_ID == 9570) || (Event_ID == 2070)))
	{
		if(StatConfirmResetWnd.IsShowWindow())
		{
			HandleItemUpdate();
		}
	}
	else if((Event_ID == 40))
	{
	}
	else if((Event_ID == EV_PacketID(1165)))
	{
		RT_S_EX_ITEM_SCORE();
	}
	return;
}

function updateSubjobInfo(string param, int Event_ID)
{
	local int Count, i, CurrentSubjobClassID;
	local UserInfo myUserInfo;
	local bool bFlag;
	local SubjobInfo tempSubjobInfo;

	isDualClass = false;
	GetPlayerInfo(myUserInfo);
	ParseInt(param, "Count", Count);
	ParseInt(param, "currentSubjobClassID", CurrentSubjobClassID);
	if((subjobInfoArray.Length > 0))
	{
		subjobInfoArray.Remove(0, subjobInfoArray.Length);
	}
	bFlag = false;
	ParseInt(param, "Race", Race);
	i = 0;
	while((i < Count))
	{
		subjobInfoArray.Insert(subjobInfoArray.Length, 1);
		ParseInt(param, ("SubjobClassID_" $ string(i)), subjobInfoArray[i].ClassID);
		ParseInt(param, ("SubjobID_" $ string(i)), subjobInfoArray[i].Id);
		ParseInt(param, ("SubjobLevel_" $ string(i)), subjobInfoArray[i].Level);
		ParseInt(param, ("SubjobType_" $ string(i)), subjobInfoArray[i].Type);
		if((subjobInfoArray[i].Type == 1))
		{
			isDualClass = true;
		}
		i++;
	}
	i = 0;
	while((i < Count))
	{
		if((CurrentSubjobClassID == subjobInfoArray[i].ClassID))
		{
			tempSubjobInfo = subjobInfoArray[i];
			subjobInfoArray[i] = subjobInfoArray[0];
			subjobInfoArray[0] = tempSubjobInfo;
			currentSubjobClassNum = 0;
			break;
		}
		i++;
	}
	i = 1;
	while((i < Count))
	{
		if((i < Count))
		{
			if((beforeSubjobInfo.ClassID == subjobInfoArray[i].ClassID))
			{
				bFlag = true;
				i++;
				continue;
			}
			bFlag = false;
		}
		i++;
	}
	if((GetClassTransferDegree(subjobInfoArray[currentSubjobClassNum].ClassID) > 0))
	{
		if((5312 == Event_ID))
		{
			bFlag = true;
		}
		else
		{
			bFlag = false;
		}
		if((subjobInfoArray[currentSubjobClassNum].Type == 2))
		{
			setClassTexture(0, "l2ui_ct1.PlayerStatusWnd_ClassBgSub_Big", (("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ string(subjobInfoArray[currentSubjobClassNum].ClassID)) $ "_Big"), bFlag);
		}
		else if((subjobInfoArray[currentSubjobClassNum].Type == 1))
		{
			setClassTexture(0, "l2ui_ct1.PlayerStatusWnd_ClassBgDual_Big", (("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ string(subjobInfoArray[currentSubjobClassNum].ClassID)) $ "_Big"), bFlag);
		}
		else if((subjobInfoArray[currentSubjobClassNum].Type == 0))
		{
			setClassTexture(0, "l2ui_ct1.PlayerStatusWnd_ClassBgMain_Big", (("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ string(subjobInfoArray[currentSubjobClassNum].ClassID)) $ "_Big"), bFlag);
		}
	}
	else if((subjobInfoArray[currentSubjobClassNum].Type == 2))
	{
		setClassTexture(0, "l2ui_ct1.PlayerStatusWnd_ClassBgSub_Big", (("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ GetRaceString(Race)) $ "_Big"), false);
	}
	else if((subjobInfoArray[currentSubjobClassNum].Type == 1))
	{
		setClassTexture(0, "l2ui_ct1.PlayerStatusWnd_ClassBgDual_Big", (("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ GetRaceString(Race)) $ "_Big"), false);
	}
	else if((subjobInfoArray[currentSubjobClassNum].Type == 0))
	{
		setClassTexture(0, "l2ui_ct1.PlayerStatusWnd_ClassBgMain_Big", (("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ GetRaceString(Race)) $ "_Big"), false);
	}
	beforeSubjobInfo = subjobInfoArray[currentSubjobClassNum];
	return;
}

function HandleDialogOK()
{
	local int dialogValue;
	local ItemInfo infItem;

	if(DialogIsMine())
	{
		if((DialogGetID() == 90005))
		{
			dialogValue = DialogGetReservedInt();
			switch(dialogValue)
			{
				case 0:
				case 1:
				case 2:
				case 3:
					ExecuteEvent(3280);
					if((subjobInfoArray[dialogValue].Type == 0))
					{
						infItem.Id.ClassID = 1566;
						UseSkill(infItem.Id, 2);
					}
					else
					{
						if((subjobInfoArray[dialogValue].Type == 1))
						{
						}
						infItem.Id.ClassID = (1567 + (dialogValue - 1));
						UseSkill(infItem.Id, 2);
					}
				default:
					Me.EnableWindow();
			}
		}
	}
	return;
}

function askDialogBox(int currentClickSubjobNum)
{
	local WindowHandle m_dialogWnd;

	m_dialogWnd = GetWindowHandle("DialogBox");
	if(!m_dialogWnd.IsShowWindow())
	{
		if((subjobInfoArray[0].ClassID != subjobInfoArray[currentClickSubjobNum].ClassID))
		{
			DialogSetID(90005);
			DialogSetReservedInt(currentClickSubjobNum);
			Me.DisableWindow();
			DialogShow(DialogModalType_Modalless, DialogType_Warning, MakeFullSystemMsg(GetSystemMessage(3280), (((("<" $ GetClassType(subjobInfoArray[0].ClassID)) $ "> ") $ getSubjobTypeStr(subjobInfoArray[0].Type)) $ ""), (((("<" $ GetClassType(subjobInfoArray[currentClickSubjobNum].ClassID)) $ "> ") $ getSubjobTypeStr(subjobInfoArray[currentClickSubjobNum].Type)) $ "")));
		}
	}
	return;
}

function string getSubjobTypeStr(int nType)
{
	local string tempStr;

	switch(nType)
	{
		case 0:
			tempStr = GetSystemString(2340);
			break;
		case 1:
			tempStr = GetSystemString(2737);
			break;
		case 2:
			tempStr = GetSystemString(2339);
			break;
		default:
			break;
	}
	return tempStr;
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "StatBonusInfo_BTN":
			if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("StatBonusWndClassic"))
			{
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow("StatBonusWndClassic");
			}
			else
			{
				Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("StatBonusWndClassic");
				Class'NWindow.UIAPI_WINDOW'.static.SetFocus("StatBonusWndClassic");
			}
			break;
		case "UsePoint_Apply_BTN":
			StatConfirmApplyWnd.ShowWindow();
			ConfirmWnd.ShowWindow();
			ConfirmWnd.SetFocus();
			break;
		case "UsePoint_Reset_BTN":
			HandleShowResetWindow();
			break;
		case "UsePoint_Cancel_BTN":
			HandleOnCliCKUsePointCancel();
			break;
		case "Cancel_BTN":
			StatConfirmApplyWnd.HideWindow();
			StatConfirmResetWnd.HideWindow();
			ConfirmWnd.HideWindow();
			break;
		case "Apply_BTN":
			API_C_EX_SET_STATUS_BONUS();
			HandleOnCliCKUsePointCancel();
			StatConfirmApplyWnd.HideWindow();
			ConfirmWnd.HideWindow();
			break;
		case "Reset_BTN":
			API_C_EX_RESET_STATUS_BONUS();
			HandleOnCliCKUsePointCancel();
			StatConfirmResetWnd.HideWindow();
			ConfirmWnd.HideWindow();
			break;
		case "FightInfo_BTN":
			if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("InfoFightWndClassic"))
			{
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow("InfoFightWndClassic");
			}
			else
			{
				Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("InfoFightWndClassic");
				Class'NWindow.UIAPI_WINDOW'.static.SetFocus("InfoFightWndClassic");
			}
			break;
		case "SPExtract_Btn":
			toggleWindow("SkillSpExtractWnd", true, true);
			break;
		case "Dye_BTN":
			toggleWindow("HennaMenuWnd", true, true);
			break;
		default:
			break;
	}
	return;
}

function OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	switch(a_ButtonHandle.GetWindowName())
	{
		case "Statsinfo_PointPlusNum_BTN":
			HandleOnClickPlusBtn(int(Right(a_ButtonHandle.GetParentWindowName(), 1)));
			break;
		case "Statsinfo_PointMinusNum_BTN":
			HandleOnClickMinusBtn(int(Right(a_ButtonHandle.GetParentWindowName(), 1)));
			break;
		default:
			break;
	}
	return;
}

function effectAniTexture(int TargetType)
{
	GetAnimTextureHandle(((m_Windowname $ ".ClassChangeLightSmall") $ string(TargetType))).SetTexture("l2ui_ct1.PlayerStatusWnd_ClassChangeLightSmall_00");
	GetAnimTextureHandle(((m_Windowname $ ".ClassChangeLightSmall") $ string(TargetType))).ShowWindow();
	GetAnimTextureHandle(((m_Windowname $ ".ClassChangeLightSmall") $ string(TargetType))).SetLoopCount(1);
	GetAnimTextureHandle(((m_Windowname $ ".ClassChangeLightSmall") $ string(TargetType))).Stop();
	GetAnimTextureHandle(((m_Windowname $ ".ClassChangeLightSmall") $ string(TargetType))).Play();
	return;
}

function setClassTexture(int TargetType, string bgTexture, string markTextureStr, bool effectFlag)
{
	if((TargetType == 0))
	{
		ClassBgMain_Big.SetTexture(bgTexture);
		ClassMarkBig.SetTexture(markTextureStr);
		if((effectFlag == true))
		{
			GetAnimTextureHandle((m_Windowname $ ".ClassChangeLightBig")).SetTexture("l2ui_ct1.PlayerStatusWnd_ClassChangeLightBig_00");
			GetAnimTextureHandle((m_Windowname $ ".ClassChangeLightBig")).ShowWindow();
			GetAnimTextureHandle((m_Windowname $ ".ClassChangeLightBig")).SetLoopCount(1);
			GetAnimTextureHandle((m_Windowname $ ".ClassChangeLightBig")).Stop();
			GetAnimTextureHandle((m_Windowname $ ".ClassChangeLightBig")).Play();
		}
	}
	return;
}

function HandleToggle()
{
	if(!getInstanceUIData().GetIsClassicServer())
	{
		return;
	}
	if(m_hOwnerWnd.IsShowWindow())
	{
		m_hOwnerWnd.HideWindow();
	}
	else
	{
		m_hOwnerWnd.ShowWindow();
		m_hOwnerWnd.SetFocus();
	}
	return;
}

function HandleUpdateMyMaxHPBlockPer(string param)
{
	local int maxHPBlockPer;

	ParseInt(param, "MaxHPBlockPer", maxHPBlockPer);
	if((maxHPBlockPer > 0))
	{
		texHP.SetDrawBlockEffect(true);
	}
	else
	{
		texHP.SetDrawBlockEffect(false);
	}
	return;
}

function HandleUpdateStatusGauge(string param, int Type)
{
	local int ServerID;

	if(m_hOwnerWnd.IsShowWindow())
	{
		ParseInt(param, "ServerID", ServerID);
		if((m_UserID == ServerID))
		{
			HandleUpdateUserGauge(Type);
		}
	}
	return;
}

function HandleUpdateHennaInfo(string param)
{
	ParseInt(param, "HennaID", m_HennaInfo.HennaID);
	ParseInt(param, "ClassID", m_HennaInfo.ClassID);
	ParseInt(param, "Num", m_HennaInfo.Num);
	ParseInt(param, "Fee", m_HennaInfo.Fee);
	ParseInt(param, "CanUse", m_HennaInfo.CanUse);
	ParseInt(param, "INTnow", m_HennaInfo.INTnow);
	ParseInt(param, "INTchange", m_HennaInfo.INTchange);
	ParseInt(param, "STRnow", m_HennaInfo.STRnow);
	ParseInt(param, "STRchange", m_HennaInfo.STRchange);
	ParseInt(param, "CONnow", m_HennaInfo.CONnow);
	ParseInt(param, "CONchange", m_HennaInfo.CONchange);
	ParseInt(param, "MENnow", m_HennaInfo.MENnow);
	ParseInt(param, "MENchange", m_HennaInfo.MENchange);
	ParseInt(param, "DEXnow", m_HennaInfo.DEXnow);
	ParseInt(param, "DEXchange", m_HennaInfo.DEXchange);
	ParseInt(param, "WITnow", m_HennaInfo.WITnow);
	ParseInt(param, "WITchange", m_HennaInfo.WITchange);
	ParseInt(param, "LUCnow", m_HennaInfo.LUCnow);
	ParseInt(param, "LUCchange", m_HennaInfo.LUCchange);
	ParseInt(param, "CHAnow", m_HennaInfo.CHAnow);
	ParseInt(param, "CHAchange", m_HennaInfo.CHAchange);
	return;
}

function bool GetMyUserInfo(out UserInfo a_MyUserInfo)
{
	return GetPlayerInfo(a_MyUserInfo);
}

function string GetMovingSpeed(UserInfo a_UserInfo)
{
	local float MovingSpeed;
	local UIEventManager.EMoveType MoveType;
	local UIEventManager.EEnvType EnvType;

	MoveType = Class'NWindow.UIDATA_PLAYER'.static.GetPlayerMoveType();
	EnvType = Class'NWindow.UIDATA_PLAYER'.static.GetPlayerEnvironment();
	if((int(MoveType) == 2))
	{
		MovingSpeed = (float(a_UserInfo.nGroundMaxSpeed) * a_UserInfo.fNonAttackSpeedModifier);
		switch(EnvType)
		{
			case ET_UNDERWATER:
				MovingSpeed = (float(a_UserInfo.nWaterMaxSpeed) * a_UserInfo.fNonAttackSpeedModifier);
				break;
			case ET_AIR:
				MovingSpeed = (float(a_UserInfo.nAirMaxSpeed) * a_UserInfo.fNonAttackSpeedModifier);
				break;
			default:
				break;
		}
	}
	else if((int(MoveType) == 1))
	{
		MovingSpeed = (float(a_UserInfo.nGroundMinSpeed) * a_UserInfo.fNonAttackSpeedModifier);
		switch(EnvType)
		{
			case ET_UNDERWATER:
				MovingSpeed = (float(a_UserInfo.nWaterMinSpeed) * a_UserInfo.fNonAttackSpeedModifier);
				break;
			case ET_AIR:
				MovingSpeed = (float(a_UserInfo.nAirMinSpeed) * a_UserInfo.fNonAttackSpeedModifier);
				break;
			default:
				break;
		}
	}
	return string(appRound(MovingSpeed));
}

function float GetMyExpRate()
{
	return (Class'NWindow.UIDATA_PLAYER'.static.GetPlayerEXPRate() * 100.0000000);
}

function HandleUpdateUserGauge(int Type)
{
	local INT64 CurValue, MaxValue;
	local UserInfo Info;

	if(GetMyUserInfo(Info))
	{
		m_UserID = Info.nID;
		switch(Type)
		{
			case 0:
				CurValue = Info.nCurHP;
				MaxValue = Info.nMaxHP;
				UpdateHPBar(CurValue, MaxValue);
				break;
			case 1:
				CurValue = INT64(Info.nCurMP);
				MaxValue = INT64(Info.nMaxMP);
				UpdateMPBar(CurValue, MaxValue);
				break;
			case 2:
				CurValue = INT64(Info.nCurCP);
				MaxValue = INT64(Info.nMaxCP);
				UpdateCPBar(CurValue, MaxValue);
				break;
			default:
				break;
		}
	}
	return;
}

function AddItemScoreTooltipDrawItem(string titleStr, int Value, Color TextColor, bool addLine, out CustomTooltip toolTipInfo)
{
	local DrawItemInfo drawInfo;
	local CustomTooltip tempTooltipInfo;

	tempTooltipInfo = toolTipInfo;
	drawInfo.eType = DIT_TEXT;
	drawInfo.t_bDrawOneLine = true;
	drawInfo.t_strText = titleStr;
	drawInfo.t_color = getInstanceL2Util().White;
	drawInfo.eAlignType = DIAT_LEFT;
	drawInfo.bLineBreak = true;
	tempTooltipInfo.DrawList[tempTooltipInfo.DrawList.Length] = drawInfo;
	drawInfo.t_strText = string(Value);
	drawInfo.t_color = TextColor;
	drawInfo.eAlignType = DIAT_RIGHT;
	drawInfo.bLineBreak = false;
	drawInfo.nOffSetX = 10;
	tempTooltipInfo.DrawList[tempTooltipInfo.DrawList.Length] = drawInfo;
	if(addLine)
	{
		drawInfo.eType = DIT_BLANK;
		drawInfo.b_nHeight = 3;
		drawInfo.nOffSetX = 0;
		drawInfo.eAlignType = DIAT_LEFT;
		tempTooltipInfo.DrawList[tempTooltipInfo.DrawList.Length] = drawInfo;
		drawInfo.eType = DIT_SPLITLINE;
		drawInfo.u_nTextureWidth = 10;
		drawInfo.u_nTextureHeight = 1;
		drawInfo.u_strTexture = "L2ui_ch3.tooltip_line";
		tempTooltipInfo.DrawList[tempTooltipInfo.DrawList.Length] = drawInfo;
		drawInfo.eType = DIT_BLANK;
		drawInfo.b_nHeight = 3;
		tempTooltipInfo.DrawList[tempTooltipInfo.DrawList.Length] = drawInfo;
	}
	toolTipInfo = tempTooltipInfo;
	return;
}

function RT_S_EX_ITEM_SCORE()
{
	local UIPacket._S_EX_ITEM_SCORE packet;
	local CustomTooltip toolTipInfo;
	local Color gradeColor;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_ITEM_SCORE(packet))
	{
		return;
	}
	gradeColor = util.GetItemScoreGradeColor(GetItemScoreColorIndex(packet.nTotal));
	txtItemScore.SetText(string(packet.nTotal));
	txtItemScore.SetTextColor(gradeColor);
	ItemScoreWnd.SetTooltipType("text");
	AddItemScoreTooltipDrawItem(GetSystemString(14860), packet.nTotal, gradeColor, true, toolTipInfo);
	AddItemScoreTooltipDrawItem(("-" @ GetSystemString(116)), ((packet.nBless + packet.nEnsoul) + packet.nEquipItem), util.Gold, false, toolTipInfo);
	AddItemScoreTooltipDrawItem(("-" @ GetSystemString(14497)), packet.nRelics, util.Gold, false, toolTipInfo);
	AddItemScoreTooltipDrawItem(("-" @ GetSystemString(14863)), packet.nRelicsCollection, util.Gold, false, toolTipInfo);
	AddItemScoreTooltipDrawItem(("-" @ GetSystemString(14616)), packet.nAdenLab, util.Gold, false, toolTipInfo);
	ItemScoreWnd.SetTooltipCustomType(toolTipInfo);
	return;
}

function HandleUpdateUserInfo()
{
	if(m_hOwnerWnd.IsShowWindow())
	{
		UpdateInterface();
	}
	return;
}

function UpdateInterface()
{
	local Rect rectWnd;
	local int Width1, Height1, Width2, Height2;
	local string Name, nickname;
	local Color NameColor, NicknameColor;
	local int SubClassID;
	local string ClassName, UserRank;
	local INT64 Hp, MaxHP;
	local int MP, maxMP, CP, maxCP;
	local INT64 Sp;
	local int Level, PledgeID;
	local string PledgeName;
	local Texture PledgeCrestTexture;
	local bool bPledgeCrestTexture;
	local Color PledgeNameColor;
	local INT64 PhysicalAttack;
	local int PhysicalDefense, HitRate, CriticalRate, PhysicalAttackSpeed;
	local INT64 MagicalAttack;
	local int MagicDefense, PhysicalAvoid;
	local string MovingSpeed;
	local int MagicCastingSpeed, CriminalRate, iNameColorRate;
	local string strCriminalRate;
	local int DualCount, PKCount, VoteCount, BonusCount, NegativeVoteCount, Notoriety, RaidPoint, nMagicAvoid, nMagicHitRate, nMagicCriticalRate, activatedElixirPoint;
	local UserInfo Info;

	texPledgeCrest.SetTexture("");
	rectWnd = m_hOwnerWnd.GetRect();
	if(GetMyUserInfo(Info))
	{
		StatesByUserInfoUpdate(Info);
		HandleOnChangeState();
		m_UserID = Info.nID;
		Name = Info.Name;
		nickname = Info.strNickName;
		SubClassID = Info.nSubClass;
		ClassName = GetClassType(SubClassID);
		Sp = Info.nSP;
		Level = Info.nLevel;
		UserRank = GetUserRankString(Info.nUserRank);
		Hp = Info.nCurHP;
		MaxHP = Info.nMaxHP;
		MP = Info.nCurMP;
		maxMP = Info.nMaxMP;
		CP = Info.nCurCP;
		maxCP = Info.nMaxCP;
		PledgeID = Info.nClanID;
		NicknameColor = Info.NicknameColor;
		PhysicalAttack = Info.nPhysicalAttack;
		PhysicalDefense = Info.nPhysicalDefense;
		HitRate = Info.nHitRate;
		CriticalRate = Info.nCriticalRate;
		if(IsUseSkillCastingSpeedStat())
		{
			PhysicalAttackSpeed = Info.nPhysicalSkillCastingSpeed;
		}
		else
		{
			PhysicalAttackSpeed = Info.nPhysicalAttackSpeed;
		}
		MagicalAttack = Info.nMagicalAttack;
		MagicDefense = Info.nMagicDefense;
		PhysicalAvoid = Info.nPhysicalAvoid;
		MagicCastingSpeed = Info.nMagicCastingSpeed;
		MovingSpeed = GetMovingSpeed(Info);
		CriminalRate = Info.nCriminalRate;
		DualCount = Info.nDualCount;
		PKCount = Info.nPKCount;
		VoteCount = Info.nVoteCount;
		BonusCount = Info.nBonusCount;
		NegativeVoteCount = Info.nNegativeVoteCount;
		Notoriety = Info.nNotoriety;
		RaidPoint = Info.RaidPoint;
		nMagicAvoid = Info.nMagicAvoid;
		nMagicHitRate = Info.nMagicHitRate;
		nMagicCriticalRate = Info.nMagicCriticalRate;
		activatedElixirPoint = Info.nActivatedElixirPoint;
	}
	if((CriminalRate > 0))
	{
		iNameColorRate = Min((100 + (CriminalRate / 100)), 255);
		NameColor.R = 0;
		NameColor.G = byte(iNameColorRate);
		NameColor.B = 0;
		NameColor.A = 255;
		if((CriminalRate > 999999))
		{
			strCriminalRate = (string(999999) $ " (+)");
		}
		else
		{
			strCriminalRate = string(CriminalRate);
		}
	}
	else if((CriminalRate < 0))
	{
		iNameColorRate = Min((100 + (-CriminalRate / 100)), 255);
		NameColor.R = byte(iNameColorRate);
		NameColor.G = 0;
		NameColor.B = 0;
		NameColor.A = 255;
		if((CriminalRate < -999999))
		{
			strCriminalRate = (string(-999999) $ " (+)");
		}
		else
		{
			strCriminalRate = string(CriminalRate);
		}
	}
	else
	{
		NameColor.R = 230;
		NameColor.G = 230;
		NameColor.B = 230;
		NameColor.A = 255;
		strCriminalRate = ("" $ string(CriminalRate));
	}
	if((Len(nickname) > 0))
	{
		GetTextSizeDefault(Name, Width1, Height1);
		GetTextSizeDefault(nickname, Width2, Height2);
		if(((Width1 + Width2) > 220))
		{
			if((Width1 > 109))
			{
				Name = Left(Name, 8);
				GetTextSizeDefault(Name, Width1, Height1);
			}
			if((Width2 > 109))
			{
				GetTextSizeDefault(nickname, Width2, Height2);
			}
		}
		txtName1.SetFormatString(nickname);
		txtName1.SetTextColor(NicknameColor);
		txtName2.SetText(Name);
		txtName2.SetTextColor(NameColor);
		txtName2.MoveTo((((rectWnd.nX + 15) + Width2) + 47), (rectWnd.nY + 41));
	}
	else
	{
		txtName1.SetText(Name);
		txtName1.SetTextColor(NameColor);
		txtName2.SetText("");
	}
	txtLvName.SetText(("" $ string(Level)));
	txtClassName.SetText(ClassName);
	txtRank.SetText(UserRank);
	txtSP.SetText(string(Sp));
	if((PledgeID > 0))
	{
		bPledgeCrestTexture = Class'NWindow.UIDATA_CLAN'.static.GetCrestTexture(PledgeID, PledgeCrestTexture);
		PledgeName = Class'NWindow.UIDATA_CLAN'.static.GetName(PledgeID);
		PledgeNameColor.R = 176;
		PledgeNameColor.G = 155;
		PledgeNameColor.B = 121;
		PledgeNameColor.A = 255;
	}
	else
	{
		PledgeName = GetSystemString(431);
		PledgeNameColor.R = 230;
		PledgeNameColor.G = 230;
		PledgeNameColor.B = 230;
		PledgeNameColor.A = 255;
	}
	txtPledge.SetText(PledgeName);
	txtPledge.SetTextColor(PledgeNameColor);
	if(bPledgeCrestTexture)
	{
		texPledgeCrest.SetTextureWithObject(PledgeCrestTexture);
		txtPledge.MoveTo((rectWnd.nX + 118), (rectWnd.nY + 59));
	}
	else
	{
		txtPledge.MoveTo((rectWnd.nX + 86), (rectWnd.nY + 59));
	}
	nMagicAvoid = Info.nMagicAvoid;
	nMagicHitRate = Info.nMagicHitRate;
	nMagicCriticalRate = Info.nMagicCriticalRate;
	GetTextBoxHandle((m_Windowname $ ".txtMagicAvoid")).SetText(string(nMagicAvoid));
	GetTextBoxHandle((m_Windowname $ ".txtMagicHit")).SetText(string(nMagicHitRate));
	GetTextBoxHandle((m_Windowname $ ".txtMagicCritical")).SetText(string(nMagicCriticalRate));
	txtPhysicalAttack.SetText(string(PhysicalAttack));
	txtPhysicalDefense.SetText(string(PhysicalDefense));
	txtHitRate.SetText(string(HitRate));
	txtCriticalRate.SetText(string(CriticalRate));
	txtPhysicalAttackSpeed.SetText(string(PhysicalAttackSpeed));
	txtMagicalAttack.SetText(string(MagicalAttack));
	txtMagicDefense.SetText(string(MagicDefense));
	txtPhysicalAvoid.SetText(string(PhysicalAvoid));
	txtMovingSpeed.SetText(MovingSpeed);
	txtMagicCastingSpeed.SetText(string(MagicCastingSpeed));
	if((int(strCriminalRate) < 0))
	{
		txtCriminalRate.SetTextColor(NameColor);
	}
	else
	{
		txtCriminalRate.SetTextColor(GetColor(200, 200, 200, 255));
	}
	txtCriminalRate.SetText(strCriminalRate);
	txtSociality_PVP.SetText(string(DualCount));
	if((PKCount > 0))
	{
		txtSociality_PK.SetTextColor(GetColor(255, 102, 102, 255));
	}
	else
	{
		txtSociality_PK.SetTextColor(GetColor(200, 200, 200, 255));
	}
	txtSociality_PK.SetText(string(PKCount));
	txtBonusVote.SetText(((string(BonusCount) $ " / ") $ string(VoteCount)));
	txtRaidPoint.SetText(string(RaidPoint));
	UpdateHPBar(Hp, MaxHP);
	UpdateMPBar(INT64(MP), INT64(maxMP));
	UpdateCPBar(INT64(CP), INT64(maxCP));
	txtDisapprove.SetText(((string(Notoriety) $ " / ") $ string(NegativeVoteCount)));
	ElixirPoint_txt.SetText(((string(activatedElixirPoint) $ "/") $ string(API_GetMaxElixir())));
	return;
}

function UpdateHPBar(INT64 Value, INT64 MaxValue)
{
	texHP.SetPoint(Value, MaxValue);
	return;
}

function UpdateMPBar(INT64 Value, INT64 MaxValue)
{
	texMP.SetPoint(Value, MaxValue);
	return;
}

function UpdateCPBar(INT64 Value, INT64 MaxValue)
{
	texCP.SetPoint(Value, MaxValue);
	return;
}

function ToggleOpenCharInfoWnd()
{
	switch(m_hOwnerWnd.IsShowWindow())
	{
		case true:
			m_hOwnerWnd.HideWindow();
			PlaySound("InterfaceSound.charstat_close_01");
			break;
		case false:
			m_hOwnerWnd.ShowWindow();
			m_hOwnerWnd.SetFocus();
			PlaySound("InterfaceSound.charstat_open_01");
			break;
		default:
			break;
	}
	return;
}

function HandleVitalityEffectInfo(string param)
{
	local CustomTooltip t;
	local string tmpStr, sSysMsgParamString;
	local int nVitality, nVitalityBonus, nVitalityItemRestoreCount;

	ParseInt(param, "vitalityPoint", nVitality);
	ParseInt(param, "vitalityBonus", nVitalityBonus);
	ParseInt(param, "restoreCount", nVitalityItemRestoreCount);
	util.setCustomTooltip(t);
	util.ToopTipInsertText(GetSystemString(2494), true, false);
	if((nVitality <= 0))
	{
		tmpStr = GetSystemString(2496);
		util.ToopTipInsertText(tmpStr, true, false, COLOR_GRAY);
		tmpStr = ", ";
		util.ToopTipInsertText(tmpStr, true, false);
		sSysMsgParamString = "";
		tmpStr = "";
		ParamAdd(sSysMsgParamString, "Type", string(1));
		ParamAdd(sSysMsgParamString, "param1", string(nVitalityItemRestoreCount));
		AddSystemMessageParam(sSysMsgParamString);
		tmpStr = EndSystemMessageParam(6073, true);
		util.ToopTipInsertText(tmpStr, true, false);
	}
	else
	{
		sSysMsgParamString = "";
		tmpStr = "";
		ParamAdd(sSysMsgParamString, "Type", string(1));
		ParamAdd(sSysMsgParamString, "param1", string(nVitalityBonus));
		AddSystemMessageParam(sSysMsgParamString);
		tmpStr = EndSystemMessageParam(6072, true);
		util.ToopTipInsertText(tmpStr, true, false);
		tmpStr = " ";
		util.ToopTipInsertText(tmpStr, true, false);
		tmpStr = "";
		sSysMsgParamString = "";
		ParamAdd(sSysMsgParamString, "Type", string(1));
		ParamAdd(sSysMsgParamString, "param1", string(nVitalityItemRestoreCount));
		AddSystemMessageParam(sSysMsgParamString);
		tmpStr = EndSystemMessageParam(6073, true);
		util.ToopTipInsertText(tmpStr, true, false);
	}
	return;
}

function InitStatusInfo()
{
	local int i;
	local UserInfo uInfo;

	if(!GetPlayerInfo(uInfo))
	{
		return;
	}
	statusPlused.Length = 6;
	StatConfirmApplyWnd.HideWindow();
	StatConfirmResetWnd.HideWindow();
	ConfirmWnd.HideWindow();
	i = 0;
	while((i < 6))
	{
		GetPlusWindowByIndex(i).HideWindow();
		GetTxtBoxHandleBasicByIndex(i).ShowWindow();
		GetTxtBoxHandlePlusByIndex(i).SetText("0");
		GetTxtBoxHandlePlusByIndex(i).SetTextColor(GetColor(150, 150, 150, 255));
		statusPlused[i] = 0;
		i++;
	}
	StatesByUserInfoUpdate(uInfo);
	CheckStatusButtomBtns(false);
	return;
}

function StatesByUserInfoUpdate(UserInfo uInfo)
{
	local int i;

	if((Me.IsShowWindow() == false))
	{
		return;
	}
	statusCanPlus = ((uInfo.nTotalBonus - GetTotalBonusAdded(uInfo)) - GetAllStatusPlused());
	statusMax = uInfo.nTotalBonus;
	i = 0;
	while((i < 6))
	{
		GetTxtBoxHandleBasicByIndex(i).SetText(string(GetStatusStatByIndex(i, uInfo)));
		GetTxtBoxHandleBasicPreviewByIndex(i).SetText(string(GetStatusStatByIndex(i, uInfo)));
		if((GetStatusBonusByType(i, uInfo) > 0))
		{
			GetTextureHandleAddedByIndex(i).ShowWindow();
			i++;
			continue;
		}
		GetTextureHandleAddedByIndex(i).HideWindow();
		i++;
	}
	CheckStatusResetButton(uInfo);
	SetCanUsePointText();
	CheckStatusPlusButtons();
	CheckStatusMinusButtons();
	GetWindowHandle(GetStatusPlusPathByIndex(0)).SetTooltipCustomType(MakeStatusCustomTooltip(GetSystemString(3366), 0, uInfo));
	GetWindowHandle(GetStatusPlusPathByIndex(2)).SetTooltipCustomType(MakeStatusCustomTooltip(GetSystemString(3368), 2, uInfo));
	GetWindowHandle(GetStatusPlusPathByIndex(4)).SetTooltipCustomType(MakeStatusCustomTooltip(GetSystemString(3370), 4, uInfo));
	GetWindowHandle(GetStatusPlusPathByIndex(1)).SetTooltipCustomType(MakeStatusCustomTooltip(GetSystemString(3367), 1, uInfo));
	GetWindowHandle(GetStatusPlusPathByIndex(3)).SetTooltipCustomType(MakeStatusCustomTooltip(GetSystemString(3369), 3, uInfo));
	GetWindowHandle(GetStatusPlusPathByIndex(5)).SetTooltipCustomType(MakeStatusCustomTooltip(GetSystemString(3371), 5, uInfo));
	StatBonusWndClassic(GetScript("StatBonusWndClassic")).ResetData();
	return;
}

function CustomTooltip MakeStatusCustomTooltip(string Title, int Type, UserInfo uInfo)
{
	local CustomTooltip m_Tooltip;
	local int basicStatus, hennaItemSkillStatus, bonusStatus, currentindex;

	basicStatus = GetStatusStatByIndex(Type, uInfo);
	hennaItemSkillStatus = GetStatusHennaSkillItemBonusByType(Type, uInfo);
	bonusStatus = GetStatusBonusByType(Type, uInfo);
	m_Tooltip.DrawList.Length = 3;
	m_Tooltip.MinimumWidth = 214;
	m_Tooltip.DrawList[0].eType = DIT_TEXT;
	m_Tooltip.DrawList[0].t_color.R = 200;
	m_Tooltip.DrawList[0].t_color.G = 200;
	m_Tooltip.DrawList[0].t_color.B = 200;
	m_Tooltip.DrawList[0].t_color.A = 255;
	m_Tooltip.DrawList[0].t_strText = Title;
	m_Tooltip.DrawList[1].bLineBreak = true;
	m_Tooltip.DrawList[1].eType = DIT_TEXT;
	m_Tooltip.DrawList[1].t_color.R = 153;
	m_Tooltip.DrawList[1].t_color.G = 153;
	m_Tooltip.DrawList[1].t_color.B = 153;
	m_Tooltip.DrawList[1].t_color.A = 255;
	m_Tooltip.DrawList[1].t_strText = (GetSystemString(103) @ ": ");
	m_Tooltip.DrawList[2].eType = DIT_TEXT;
	m_Tooltip.DrawList[2].t_color.R = 187;
	m_Tooltip.DrawList[2].t_color.G = 170;
	m_Tooltip.DrawList[2].t_color.B = 136;
	m_Tooltip.DrawList[2].t_color.A = 255;
	m_Tooltip.DrawList[2].t_strText = string(((basicStatus - bonusStatus) - hennaItemSkillStatus));
	currentindex = m_Tooltip.DrawList.Length;
	if((hennaItemSkillStatus != 0))
	{
		m_Tooltip.DrawList.Length = (m_Tooltip.DrawList.Length + 2);
		m_Tooltip.DrawList[currentindex].bLineBreak = true;
		m_Tooltip.DrawList[currentindex].eType = DIT_TEXT;
		m_Tooltip.DrawList[currentindex].t_color.R = 153;
		m_Tooltip.DrawList[currentindex].t_color.G = 153;
		m_Tooltip.DrawList[currentindex].t_color.B = 153;
		m_Tooltip.DrawList[currentindex].t_color.A = 255;
		m_Tooltip.DrawList[currentindex].t_strText = (GetSystemString(13165) $ " : ");
		currentindex = (currentindex + 1);
		m_Tooltip.DrawList[currentindex].eType = DIT_TEXT;
		m_Tooltip.DrawList[currentindex].t_color.R = 187;
		m_Tooltip.DrawList[currentindex].t_color.G = 170;
		m_Tooltip.DrawList[currentindex].t_color.B = 136;
		m_Tooltip.DrawList[currentindex].t_color.A = 255;
		m_Tooltip.DrawList[currentindex].t_strText = string(hennaItemSkillStatus);
		currentindex = (currentindex + 1);
	}
	if((bonusStatus > 0))
	{
		m_Tooltip.DrawList.Length = (m_Tooltip.DrawList.Length + 2);
		m_Tooltip.DrawList[currentindex].bLineBreak = true;
		m_Tooltip.DrawList[currentindex].eType = DIT_TEXT;
		m_Tooltip.DrawList[currentindex].t_color.R = 153;
		m_Tooltip.DrawList[currentindex].t_color.G = 153;
		m_Tooltip.DrawList[currentindex].t_color.B = 153;
		m_Tooltip.DrawList[currentindex].t_color.A = 255;
		m_Tooltip.DrawList[currentindex].t_strText = (GetSystemString(13117) @ ": ");
		currentindex = (currentindex + 1);
		m_Tooltip.DrawList[currentindex].eType = DIT_TEXT;
		m_Tooltip.DrawList[currentindex].t_color.R = 187;
		m_Tooltip.DrawList[currentindex].t_color.G = 170;
		m_Tooltip.DrawList[currentindex].t_color.B = 136;
		m_Tooltip.DrawList[currentindex].t_color.A = 255;
		m_Tooltip.DrawList[currentindex].t_strText = string(bonusStatus);
	}
	return m_Tooltip;
}

function CheckStatusResetButton(UserInfo uInfo)
{
	if((GetTotalBonusAdded(uInfo) > 0))
	{
		UsePoint_Reset_BTN.EnableWindow();
	}
	else
	{
		UsePoint_Reset_BTN.DisableWindow();
	}
	return;
}

function bool GetIsPlused()
{
	local int i;

	i = 0;
	while((i < 6))
	{
		if((statusPlused[i] > 0))
		{
			return true;
		}
		i++;
	}
	return false;
}

function int GetAllStatusPlused()
{
	local int i, allplused;

	i = 0;
	while((i < 6))
	{
		allplused = (allplused + statusPlused[i]);
		i++;
	}
	return allplused;
}

function SetCanUsePointText()
{
	local int statusCanPlusUInt;

	statusCanPlusUInt = statusCanPlus;
	if((statusCanPlusUInt < 0))
	{
		statusCanPlusUInt = 0;
	}
	Statsinfo_UsePoint_text.SetText(((string(statusCanPlusUInt) $ "/") $ string(statusMax)));
	return;
}

function HandleOnCliCKUsePointCancel()
{
	local int i;

	statusCanPlus = (statusCanPlus + GetAllStatusPlused());
	i = 0;
	while((i < 6))
	{
		HandleUsePointCancelByType(i);
		i++;
	}
	CheckStatusButtomBtns(false);
	SetCanUsePointText();
	return;
}

function HandleUsePointCancelByType(int Type)
{
	GetPlusWindowByIndex(Type).HideWindow();
	GetTxtBoxHandleBasicByIndex(Type).ShowWindow();
	GetTxtBoxHandlePlusByIndex(Type).SetText("0");
	GetTxtBoxHandlePlusByIndex(Type).SetTextColor(GetColor(150, 150, 150, 255));
	statusPlused[Type] = 0;
	GetStatusPlusBtnByIndex(Type).EnableWindow();
	GetStatusMinusBtnByIndex(Type).DisableWindow();
	StatBonusWndClassic(GetScript("StatBonusWndClassic")).HandleOnChangedStatusType(Type);
	return;
}

function HandleShowResetWindow()
{
	HandleItemUpdate();
	StatConfirmResetWnd.ShowWindow();
	ConfirmWnd.ShowWindow();
	ConfirmWnd.SetFocus();
	getInstanceL2Util().ItemRelationWindowHide("DetailStatusWndClassic.ConfirmWnd");
	return;
}

function HandleItemUpdate()
{
	local UserInfo uInfo;
	local array<RequestItem> arrStatBonusResetUIData;
	local int i;

	arrStatBonusResetUIData = API_GetStatBonusResetData();
	if(!GetPlayerInfo(uInfo))
	{
		return;
	}
	ResetCharge_ListCtrl.DeleteAllItem();
	Reset_Btn.EnableWindow();
	i = 0;
	while((i < arrStatBonusResetUIData.Length))
	{
		ResetCharge_ListCtrl.InsertRecord(MakeRowDataStatusResetNeedItem(arrStatBonusResetUIData[i].Id, arrStatBonusResetUIData[i].Amount));
		i++;
	}
	NumPoint_text.SetText(((string(GetTotalBonusAdded(uInfo)) $ "/") $ string(uInfo.nTotalBonus)));
	return;
}

function RichListCtrlRowData MakeRowDataStatusResetNeedItem(int ClassID, INT64 Amount)
{
	local RichListCtrlRowData rowData;
	local Color itemNumColor;
	local ItemID cID;
	local InventoryWnd inventoryWndScript;
	local INT64 ItemCount;

	rowData.cellDataList.Length = 1;
	cID.ClassID = ClassID;
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, 0, 1);
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems, Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(cID), 32, 32, -34, 1);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, Class'NWindow.UIDATA_ITEM'.static.GetItemName(cID), util.BrightWhite, false, 5, 0);
	inventoryWndScript = InventoryWnd(GetScript("InventoryWnd"));
	ItemCount = inventoryWndScript.getItemCountByClassID(ClassID);
	if((ItemCount < Amount))
	{
		Reset_Btn.DisableWindow();
		itemNumColor = GetColor(255, 0, 0, 255);
	}
	else
	{
		itemNumColor = GetColor(0, 176, 255, 255);
	}
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, ("x" $ MakeCostStringINT64(Amount)), util.White, true, 40, 5);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, ((" (" $ MakeCostStringINT64(ItemCount)) $ ")"), itemNumColor, false);
	return rowData;
}

function HandleOnClickMinusBtn(int Type)
{
	if((statusPlused[Type] == 0))
	{
		return;
	}
	statusPlused[Type] = (statusPlused[Type] - 1);
	statusCanPlus++;
	if((statusPlused[Type] == 0))
	{
		HandleUsePointCancelByType(Type);
		CheckStatusButtomBtns((GetAllStatusPlused() > 0));
		GetTxtBoxHandleBasicPreviewByIndex(Type).HideWindow();
		GetTxtBoxHandleBasicByIndex(Type).ShowWindow();
	}
	else
	{
		GetTxtBoxHandleAddedByIndex(Type).SetText(string(GetStatusPlused((int(GetTxtBoxHandleBasicByIndex(Type).GetText()) + statusPlused[Type]))));
		GetTxtBoxHandlePlusByIndex(Type).SetText(("+" $ string(statusPlused[Type])));
		GetTxtBoxHandleBasicPreviewByIndex(Type).ShowWindow();
		GetTxtBoxHandleBasicByIndex(Type).HideWindow();
	}
	CheckStatusPlusButtons();
	SetCanUsePointText();
	StatBonusWndClassic(GetScript("StatBonusWndClassic")).HandleOnChangedStatusType(Type);
	return;
}

function HandleOnClickPlusBtn(int Type)
{
	statusPlused[Type] = (statusPlused[Type] + 1);
	GetTxtBoxHandleAddedByIndex(Type).SetText(string(GetStatusPlused((int(GetTxtBoxHandleBasicByIndex(Type).GetText()) + statusPlused[Type]))));
	GetPlusWindowByIndex(Type).ShowWindow();
	statusCanPlus--;
	SetCanUsePointText();
	GetTxtBoxHandlePlusByIndex(Type).SetText(("+" $ string(statusPlused[Type])));
	GetTxtBoxHandlePlusByIndex(Type).SetTextColor(GetColor(255, 228, 0, 255));
	CheckStatusPlusButtons();
	GetStatusMinusBtnByIndex(Type).EnableWindow();
	CheckStatusButtomBtns(true);
	GetTxtBoxHandleBasicPreviewByIndex(Type).ShowWindow();
	GetTxtBoxHandleBasicByIndex(Type).HideWindow();
	StatBonusWndClassic(GetScript("StatBonusWndClassic")).HandleOnChangedStatusType(Type);
	return;
}

function HandleOnChangeState()
{
	local int i;

	i = 0;
	while((i < statusPlused.Length))
	{
		if(GetPlusWindowByIndex(i).IsShowWindow())
		{
			GetTxtBoxHandleAddedByIndex(i).SetText(string(GetStatusPlused((int(GetTxtBoxHandleBasicByIndex(i).GetText()) + statusPlused[i]))));
		}
		i++;
	}
	return;
}

function int GetStatusPlused(int plusedNum)
{
	if((plusedNum > 200))
	{
		return 200;
	}
	return plusedNum;
}

function CheckStatusPlusButtons()
{
	local int i;

	if((statusCanPlus > 0))
	{
		i = 0;
		while((i < 6))
		{
			GetStatusPlusBtnByIndex(i).EnableWindow();
			i++;
		}
	}
	else
	{
		i = 0;
		while((i < 6))
		{
			GetStatusPlusBtnByIndex(i).DisableWindow();
			i++;
		}
	}
	return;
}

function CheckStatusMinusButtons()
{
	local int i;

	i = 0;
	while((i < 6))
	{
		if((statusPlused[i] > 0))
		{
			GetStatusMinusBtnByIndex(i).EnableWindow();
			i++;
			continue;
		}
		GetStatusMinusBtnByIndex(i).DisableWindow();
		i++;
	}
	return;
}

function CheckStatusButtomBtns(bool isPlused)
{
	if(isPlused)
	{
		UsePoint_Apply_BTN.ShowWindow();
		UsePoint_Cancel_BTN.ShowWindow();
		UsePoint_Reset_BTN.HideWindow();
	}
	else
	{
		UsePoint_Apply_BTN.HideWindow();
		UsePoint_Cancel_BTN.HideWindow();
		UsePoint_Reset_BTN.ShowWindow();
	}
	return;
}

function SetElixirInfo()
{
	local ItemInfo iInfo;

	iInfo = GetItemInfoByClassID(94314);
	GetItemWindowHandle((m_Windowname $ ".Statsinfo_Elixir_Win.ElixirItem")).AddItem(iInfo);
	GetTextBoxHandle((m_Windowname $ ".Statsinfo_Elixir_Win.ElixirTitle_txt")).SetText(iInfo.Name);
	return;
}

function TextBoxHandle GetTxtBoxHandleBasicByIndex(int Index)
{
	return GetTextBoxHandle((GetStatusPlusPathByIndex(Index) $ ".Statsinfo_Num_text"));
}

function TextBoxHandle GetTxtBoxHandleBasicPreviewByIndex(int Index)
{
	return GetTextBoxHandle(((GetStatusPlusPathByIndex(Index) $ ".STR_PreviewNum_Wnd") $ ".Statsinfo_Num02_text"));
}

function TextBoxHandle GetTxtBoxHandleAddedByIndex(int Index)
{
	return GetTextBoxHandle(((GetStatusPlusPathByIndex(Index) $ ".STR_PreviewNum_Wnd") $ ".Statsinfo_PreviewNum_text"));
}

function WindowHandle GetPlusWindowByIndex(int Index)
{
	return GetWindowHandle((GetStatusPlusPathByIndex(Index) $ ".STR_PreviewNum_Wnd"));
}

function TextureHandle GetTextureHandleAddedByIndex(int Index)
{
	return GetTextureHandle((GetStatusPlusPathByIndex(Index) $ ".Statsinfo_IconPointPanel_tex"));
}

function TextBoxHandle GetTxtBoxHandlePlusByIndex(int Index)
{
	return GetTextBoxHandle((GetStatusPlusPathByIndex(Index) $ ".Statsinfo_PointPlusNum_Text"));
}

function ButtonHandle GetStatusPlusBtnByIndex(int Index)
{
	return GetButtonHandle((GetStatusPlusPathByIndex(Index) $ ".Statsinfo_PointPlusNum_BTN"));
}

function ButtonHandle GetStatusMinusBtnByIndex(int Index)
{
	return GetButtonHandle((GetStatusPlusPathByIndex(Index) $ ".Statsinfo_PointMinusNum_BTN"));
}

function string GetStatusPlusPathByIndex(int Index)
{
	return ((m_Statsinfo_UsePoint_Win $ ".Win0") $ string(Index));
}

function CustomTooltip subjobButtonToolTips(int TargetType)
{
	local CustomTooltip m_Tooltip;
	local int subjobSlotStringNum;

	if((TargetType == -1))
	{
		m_Tooltip.DrawList.Length = 1;
		m_Tooltip.MinimumWidth = 210;
		m_Tooltip.DrawList[0].eType = DIT_TEXT;
		m_Tooltip.DrawList[0].t_color.R = 220;
		m_Tooltip.DrawList[0].t_color.G = 220;
		m_Tooltip.DrawList[0].t_color.B = 220;
		m_Tooltip.DrawList[0].t_color.A = 255;
		subjobSlotStringNum = 2342;
		if((Race == 6))
		{
			subjobSlotStringNum = 3315;
		}
		m_Tooltip.DrawList[0].t_strText = GetSystemString(subjobSlotStringNum);
	}
	else
	{
		m_Tooltip.DrawList.Length = 5;
		if(((int(GetLanguage()) == 8) || (int(GetLanguage()) == 9)))
		{
			m_Tooltip.MinimumWidth = 260;
		}
		else
		{
			m_Tooltip.MinimumWidth = 214;
		}
		m_Tooltip.DrawList[0].eType = DIT_TEXT;
		m_Tooltip.DrawList[0].t_color.R = 200;
		m_Tooltip.DrawList[0].t_color.G = 200;
		m_Tooltip.DrawList[0].t_color.B = 200;
		m_Tooltip.DrawList[0].t_color.A = 255;
		m_Tooltip.DrawList[0].t_strText = "Lv";
		m_Tooltip.DrawList[1].eType = DIT_TEXT;
		m_Tooltip.DrawList[1].t_color.R = 175;
		m_Tooltip.DrawList[1].t_color.G = 152;
		m_Tooltip.DrawList[1].t_color.B = 120;
		m_Tooltip.DrawList[1].t_color.A = 255;
		m_Tooltip.DrawList[1].t_strText = (string(subjobInfoArray[TargetType].Level) @ GetClassType(subjobInfoArray[TargetType].ClassID));
		m_Tooltip.DrawList[2].eType = DIT_TEXT;
		m_Tooltip.DrawList[2].t_color.R = 200;
		m_Tooltip.DrawList[2].t_color.G = 200;
		m_Tooltip.DrawList[2].t_color.B = 200;
		m_Tooltip.DrawList[2].t_color.A = 255;
		if((subjobInfoArray[TargetType].Type == 2))
		{
			m_Tooltip.DrawList[2].t_strText = ((" (" $ GetSystemString(2341)) $ ")");
		}
		else if((subjobInfoArray[TargetType].Type == 1))
		{
			m_Tooltip.DrawList[2].t_strText = ((" (" $ GetSystemString(2739)) $ ")");
		}
		else
		{
			m_Tooltip.DrawList[2].t_strText = ((" (" $ GetSystemString(2738)) $ ")");
		}
		m_Tooltip.DrawList[3].eType = DIT_TEXT;
		m_Tooltip.DrawList[3].bLineBreak = true;
		m_Tooltip.DrawList[3].t_color.R = 220;
		m_Tooltip.DrawList[3].t_color.G = 220;
		m_Tooltip.DrawList[3].t_color.B = 220;
		m_Tooltip.DrawList[3].t_color.A = 255;
		m_Tooltip.DrawList[3].t_strText = GetSystemString(2343);
		m_Tooltip.DrawList[4].eType = DIT_TEXT;
		if(((subjobInfoArray[TargetType].Type == 2) && (isDualClass == false)))
		{
			m_Tooltip.DrawList[4].bLineBreak = true;
			m_Tooltip.DrawList[4].t_color.R = 110;
			m_Tooltip.DrawList[4].t_color.G = 140;
			m_Tooltip.DrawList[4].t_color.B = 170;
			m_Tooltip.DrawList[4].t_color.A = 255;
			m_Tooltip.DrawList[4].t_strText = GetSystemString(2344);
		}
		else
		{
			m_Tooltip.DrawList[4].t_strText = "";
		}
	}
	return m_Tooltip;
}

function array<RequestItem> API_GetStatBonusResetData()
{
	local array<RequestItem> arrStatBonusResetUIData;
	local UserInfo uInfo;

	if(!GetPlayerInfo(uInfo))
	{
		return arrStatBonusResetUIData;
	}
	GetStatBonusResetData(GetTotalBonusAdded(uInfo), arrStatBonusResetUIData);
	return arrStatBonusResetUIData;
}

function int API_GetMaxElixir()
{
	return GetMaxElixir();
}

function API_C_EX_SET_STATUS_BONUS()
{
	local array<byte> stream;
	local UIPacket._C_EX_SET_STATUS_BONUS packet;
	local UserInfo uInfo;

	if(!GetPlayerInfo(uInfo))
	{
		return;
	}
	packet.additionalStatBonus.nStrBonus = statusPlused[0];
	packet.additionalStatBonus.nDexBonus = statusPlused[2];
	packet.additionalStatBonus.nConBonus = statusPlused[4];
	packet.additionalStatBonus.nIntBonus = statusPlused[1];
	packet.additionalStatBonus.nWitBonus = statusPlused[3];
	packet.additionalStatBonus.nMenBonus = statusPlused[5];
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_SET_STATUS_BONUS(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(611, stream);
	return;
}

function API_C_EX_RESET_STATUS_BONUS()
{
	local array<byte> stream;
	local UIPacket._C_EX_RESET_STATUS_BONUS packet;

	if(!Class'Interface.UIPacket'.static.Encode_C_EX_RESET_STATUS_BONUS(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(612, stream);
	return;
}

function int GetStatusStatByIndex(int Index, UserInfo uInfo)
{
	switch(Index)
	{
		case 0:
			return uInfo.nStr;
			break;
		case 1:
			return uInfo.nInt;
			break;
		case 2:
			return uInfo.nDex;
			break;
		case 3:
			return uInfo.nWit;
			break;
		case 4:
			return uInfo.nCon;
			break;
		case 5:
			return uInfo.nMen;
			break;
		default:
			break;
	}
	return -1;
}

function int GetStatusBonusByType(int Type, UserInfo uInfo)
{
	switch(Type)
	{
		case 0:
			return uInfo.nStrBonus;
			break;
		case 1:
			return uInfo.nIntBonus;
			break;
		case 2:
			return uInfo.nDexBonus;
			break;
		case 3:
			return uInfo.nWitBonus;
			break;
		case 4:
			return uInfo.nConBonus;
			break;
		case 5:
			return uInfo.nMenBonus;
			break;
		default:
			break;
	}
	return -1;
}

function int GetStatusHennaSkillItemBonusByType(int Type, UserInfo uInfo)
{
	switch(Type)
	{
		case 0:
			return uInfo.nStrAdditional;
			break;
		case 1:
			return uInfo.nIntAdditional;
			break;
		case 2:
			return uInfo.nDexAdditional;
			break;
		case 3:
			return uInfo.nWitAdditional;
			break;
		case 4:
			return uInfo.nConAdditional;
			break;
		case 5:
			return uInfo.nMenAdditional;
			break;
		default:
			break;
	}
	return -1;
}

function int GetTotalBonusAdded(UserInfo uInfo)
{
	local int i, total;

	i = 0;
	while((i < 6))
	{
		total = (total + GetStatusBonusByType(i, uInfo));
		i++;
	}
	return total;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	if(ConfirmWnd.IsShowWindow())
	{
		ConfirmWnd.HideWindow();
	}
	else
	{
		GetWindowHandle(m_Windowname).HideWindow();
	}
	return;
}

defaultproperties
{
	m_Windowname="DetailStatusWndClassic"
	m_Statsinfo_UsePoint_Win="DetailStatusWndClassic.Statsinfo_UsePoint_Win"
}
