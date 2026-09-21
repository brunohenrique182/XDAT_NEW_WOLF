class DetailStatusWnd extends UICommonAPI;

const DIALOG_DetailStatusWnd = 90005;
const NSTATUS_SMALLBARSIZE = 85;
const NSTATUS_BARHEIGHT = 12;

struct SubjobInfo
{
	var int Id;
	var int ClassID;
	var int Level;
	var int Type;
};

var string m_Windowname;
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
var StatusBarHandle texExp;
var StatusBarHandle texCP;
var TextBoxHandle txtPhysicalAttack;
var TextBoxHandle txtPhysicalDefense;
var TextBoxHandle txtHitRate;
var TextBoxHandle txtCriticalRate;
var TextBoxHandle txtPhysicalAttackSpeed;
var TextBoxHandle txtMagicalAttack;
var TextBoxHandle txtMagicDefense;
var TextBoxHandle txtPhysicalAvoid;
var TextBoxHandle txtPerfect;
var TextBoxHandle txtHeadMovingSpeed;
var TextBoxHandle txtMovingSpeed;
var TextBoxHandle txtHeadMagicCastingSpeed;
var TextBoxHandle txtMagicCastingSpeed;
var TextBoxHandle txtSTR;
var TextBoxHandle txtDEX;
var TextBoxHandle txtCON;
var TextBoxHandle txtINT;
var TextBoxHandle txtWIT;
var TextBoxHandle txtMEN;
var TextBoxHandle txtCriminalRate;
var TextBoxHandle txtPVP;
var TextBoxHandle txtSociality;
var TextBoxHandle txtBonusVote;
var TextBoxHandle txtHeadPerfect;
var TextureHandle texHero;
var TextureHandle texPledgeCrest;
var TextureHandle VitalityTex;
var TextBoxHandle txtLUC;
var TextBoxHandle txtCHA;
var TextBoxHandle txtAttrAttackType;
var TextBoxHandle txtAttrAttackValue;
var TextBoxHandle txtAttrDefenseValFire;
var TextBoxHandle txtAttrDefenseValWater;
var TextBoxHandle txtAttrDefenseValWind;
var TextBoxHandle txtAttrDefenseValEarth;
var TextBoxHandle txtAttrDefenseValHoly;
var TextBoxHandle txtAttrDefenseValUnholy;
var TextBoxHandle txtHeadSTR;
var TextBoxHandle txtHeadDEX;
var TextBoxHandle txtHeadCON;
var TextBoxHandle txtHeadINT;
var TextBoxHandle txtHeadWIT;
var TextBoxHandle txtHeadMEN;
var TextBoxHandle txtHeadLUC;
var TextBoxHandle txtHeadCHA;
var ButtonHandle AbilityOpen;
var StatusBarHandle texVP;
var AnimTextureHandle APActive;
var TextBoxHandle txtPSkillCriticalRate;
var ButtonHandle FightInfo_BTN;
var int MaxVitality;
var L2Util util;
var AnimTextureHandle ClassChangeLightBig;
var TextureHandle ClassBgMain_Big;
var TextureHandle ClassMarkBig;
var AnimTextureHandle ClassChangeLightSmall1;
var TextureHandle ClassBgMain_Small1;
var TextureHandle ClassMarkSmall1;
var ButtonHandle ClassFrameBtn1;
var array<SubjobInfo> subjobInfoArray;
var SubjobInfo beforeSubjobInfo;
var int currentSubjobClassNum;
var bool isDualClass;
var int CurrentSubjobClassID;
var int Race;

function OnRegisterEvent()
{
	RegisterEvent(180);
	RegisterEvent(260);
	RegisterEvent(191);
	RegisterEvent(201);
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
	RegisterEvent(4110);
	RegisterEvent(3400);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	InitializeCOD();
	Me.EnableWindow();
	initClassChangeButton(false);
	MaxVitality = GetMaxVitality();
	txtHeadRank.HideWindow();
	txtRank.HideWindow();
	texExp.SetDecimalPlace(4);
	return;
}

function UpdateAbilityBtn()
{
	local UserInfo UserInfo;
	local AbilityUIWnd.AbilityPresetInfo presetInfo;
	local bool Enable;
	local string tempTooltipStr;
	local array<DrawItemInfo> drawListArr;

	if((Me.IsShowWindow() == false))
	{
		return;
	}
	if(GetPlayerInfo(UserInfo))
	{
		if((UserInfo.nLevel >= 85))
		{
			Enable = true;
		}
	}
	util = L2Util(GetScript("L2Util"));
	presetInfo = AbilityUIWnd(GetScript("AbilityUIWnd")).GetAbilityPresetInfo();
	if((presetInfo.currentPreset == 1))
	{
		AbilityOpen.SetTexture("L2UI_CT1.PlayerStatusWnd.abilityIcon_B_default", "L2UI_CT1.PlayerStatusWnd.abilityIcon_B_over", "L2UI_CT1.PlayerStatusWnd.abilityIcon_B_down");
	}
	else
	{
		AbilityOpen.SetTexture("L2UI_CT1.PlayerStatusWnd.abilityIcon_A_default", "L2UI_CT1.PlayerStatusWnd.abilityIcon_A_over", "L2UI_CT1.PlayerStatusWnd.abilityIcon_A_down");
	}
	APActive.HideWindow();
	if(Enable)
	{
		GetTextureHandle((m_Windowname $ ".abilityIconSlotBlank")).HideWindow();
		AbilityOpen.ShowWindow();
		tempTooltipStr = ((GetSystemString(14444) $ ":") @ string(presetInfo.aPresetRemainAP));
		if((presetInfo.currentPreset == 0))
		{
			drawListArr[drawListArr.Length] = addDrawItemText(tempTooltipStr, util.Yellow, "", true, true);
		}
		else
		{
			drawListArr[drawListArr.Length] = addDrawItemText(tempTooltipStr, util.Gray, "", true, true);
		}
		tempTooltipStr = ((GetSystemString(14445) $ ":") @ string(presetInfo.bPresetRemainAP));
		if((presetInfo.currentPreset == 1))
		{
			drawListArr[drawListArr.Length] = addDrawItemText(tempTooltipStr, util.Yellow, "", true, true);
		}
		else
		{
			drawListArr[drawListArr.Length] = addDrawItemText(tempTooltipStr, util.Gray, "", true, true);
		}
		AbilityOpen.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
		if(((presetInfo.aPresetRemainAP > 0) || (presetInfo.bPresetRemainAP > 0)))
		{
			APActive.ShowWindow();
			APActive.SetLoopCount(999);
			APActive.Play();
		}
	}
	else
	{
		AbilityOpen.HideWindow();
		GetTextureHandle((m_Windowname $ ".abilityIconSlotBlank")).ShowWindow();
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemMessage(4195), util.White, "", true, true);
		GetTextureHandle((m_Windowname $ ".abilityIconSlotBlank")).SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
	}
	return;
}

function initClassChangeButton(bool visibleFlag)
{
	local int i;

	i = 1;
	while((i < 2))
	{
		setClassTexture(i, "", "", false);
		GetButtonHandle(((m_Windowname $ ".ClassFrameBtn") $ string(i))).DisableWindow();
		GetButtonHandle(((m_Windowname $ ".ClassFrameBtn") $ string(i))).SetTexture("L2UI_ct1.Misc_DF_Blank", "L2UI_ct1.Misc_DF_Blank", "L2UI_ct1.Misc_DF_Blank");
		GetButtonHandle(((m_Windowname $ ".ClassFrameBtn") $ string(i))).SetTooltipCustomType(subjobButtonToolTips(-1));
		if(visibleFlag)
		{
			i++;
			continue;
		}
		i++;
	}
	return;
}

function InitializeCOD()
{
	local Color tooltipColor;

	Me = GetWindowHandle("DetailStatusWnd");
	ClassChangeLightBig = GetAnimTextureHandle((m_Windowname $ ".ClassChangeLightBig"));
	ClassChangeLightSmall1 = GetAnimTextureHandle((m_Windowname $ ".ClassChangeLightSmall1"));
	ClassBgMain_Big = GetTextureHandle((m_Windowname $ ".ClassBgMain_Big"));
	ClassBgMain_Small1 = GetTextureHandle((m_Windowname $ ".ClassBgMain_Small1"));
	ClassFrameBtn1 = GetButtonHandle((m_Windowname $ ".ClassFrameBtn1"));
	ClassMarkBig = GetTextureHandle((m_Windowname $ ".ClassMarkBig"));
	ClassMarkSmall1 = GetTextureHandle((m_Windowname $ ".ClassMarkSmall1"));
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
	texExp = GetStatusBarHandle((m_Windowname $ ".texExp"));
	texCP = GetStatusBarHandle((m_Windowname $ ".texCP"));
	txtPhysicalAttack = GetTextBoxHandle((m_Windowname $ ".txtPhysicalAttack"));
	txtPhysicalDefense = GetTextBoxHandle((m_Windowname $ ".txtPhysicalDefense"));
	txtHitRate = GetTextBoxHandle((m_Windowname $ ".txtHitRate"));
	txtCriticalRate = GetTextBoxHandle((m_Windowname $ ".txtCriticalRate"));
	txtPhysicalAttackSpeed = GetTextBoxHandle((m_Windowname $ ".txtPhysicalAttackSpeed"));
	txtMagicalAttack = GetTextBoxHandle((m_Windowname $ ".txtMagicalAttack"));
	txtMagicDefense = GetTextBoxHandle((m_Windowname $ ".txtMagicDefense"));
	txtPhysicalAvoid = GetTextBoxHandle((m_Windowname $ ".txtPhysicalAvoid"));
	txtPerfect = GetTextBoxHandle((m_Windowname $ ".txtPerfect"));
	txtMovingSpeed = GetTextBoxHandle((m_Windowname $ ".txtMovingSpeed"));
	txtMagicCastingSpeed = GetTextBoxHandle((m_Windowname $ ".txtMagicCastingSpeed"));
	txtHeadMovingSpeed = GetTextBoxHandle((m_Windowname $ ".txtHeadMovingSpeed"));
	txtHeadMagicCastingSpeed = GetTextBoxHandle((m_Windowname $ ".txtHeadMagicCastingSpeed"));
	txtSTR = GetTextBoxHandle((m_Windowname $ ".txtSTR"));
	txtDEX = GetTextBoxHandle((m_Windowname $ ".txtDEX"));
	txtCON = GetTextBoxHandle((m_Windowname $ ".txtCON"));
	txtINT = GetTextBoxHandle((m_Windowname $ ".txtINT"));
	txtWIT = GetTextBoxHandle((m_Windowname $ ".txtWIT"));
	txtMEN = GetTextBoxHandle((m_Windowname $ ".txtMEN"));
	txtCriminalRate = GetTextBoxHandle((m_Windowname $ ".txtCriminalRate"));
	txtPVP = GetTextBoxHandle((m_Windowname $ ".txtPVP"));
	txtSociality = GetTextBoxHandle((m_Windowname $ ".txtSociality"));
	txtBonusVote = GetTextBoxHandle((m_Windowname $ ".txtRemainSulffrage"));
	txtHeadPerfect = GetTextBoxHandle((m_Windowname $ ".txtHeadPerfect"));
	texHero = GetTextureHandle((m_Windowname $ ".texHero"));
	texPledgeCrest = GetTextureHandle((m_Windowname $ ".texPledgeCrest"));
	txtAttrAttackType = GetTextBoxHandle((m_Windowname $ ".txtAttrAttackType"));
	txtAttrAttackValue = GetTextBoxHandle((m_Windowname $ ".txtAttrAttackValue"));
	txtAttrDefenseValFire = GetTextBoxHandle((m_Windowname $ ".txtAttrDefenseValFire"));
	txtAttrDefenseValWater = GetTextBoxHandle((m_Windowname $ ".txtAttrDefenseValWater"));
	txtAttrDefenseValWind = GetTextBoxHandle((m_Windowname $ ".txtAttrDefenseValWind"));
	txtAttrDefenseValEarth = GetTextBoxHandle((m_Windowname $ ".txtAttrDefenseValEarth"));
	txtAttrDefenseValHoly = GetTextBoxHandle((m_Windowname $ ".txtAttrDefenseValHoly"));
	txtAttrDefenseValUnholy = GetTextBoxHandle((m_Windowname $ ".txtAttrDefenseValUnholy"));
	VitalityTex = GetTextureHandle((m_Windowname $ ".LifeForceTex"));
	txtLUC = GetTextBoxHandle((m_Windowname $ ".txtLUC"));
	txtCHA = GetTextBoxHandle((m_Windowname $ ".txtCHA"));
	texVP = GetStatusBarHandle((m_Windowname $ ".texVP"));
	txtPSkillCriticalRate = GetTextBoxHandle("DetailStatusWnd.txtHeadMovingSpeed");
	AbilityOpen = GetButtonHandle((m_Windowname $ ".AbilityOpen"));
	txtHeadSTR = GetTextBoxHandle("DetailStatusWnd.txtHeadSTR");
	txtHeadDEX = GetTextBoxHandle("DetailStatusWnd.txtHeadDEX");
	txtHeadCON = GetTextBoxHandle("DetailStatusWnd.txtHeadCON");
	txtHeadINT = GetTextBoxHandle("DetailStatusWnd.txtHeadINT");
	txtHeadWIT = GetTextBoxHandle("DetailStatusWnd.txtHeadWIT");
	txtHeadMEN = GetTextBoxHandle("DetailStatusWnd.txtHeadMEN");
	txtHeadLUC = GetTextBoxHandle("DetailStatusWnd.txtHeadLUC");
	txtHeadCHA = GetTextBoxHandle("DetailStatusWnd.txtHeadCHA");
	tooltipColor = GetColor(230, 230, 230, 255);
	txtHeadSTR.SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14756), tooltipColor, , 220));
	txtHeadDEX.SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14757), tooltipColor, , 220));
	txtHeadCON.SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14758), tooltipColor, , 220));
	txtHeadINT.SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14759), tooltipColor, , 220));
	txtHeadWIT.SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14760), tooltipColor, , 220));
	txtHeadMEN.SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14761), tooltipColor, , 220));
	txtHeadLUC.SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14762), tooltipColor, , 220));
	txtHeadCHA.SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14763), tooltipColor, , 220));
	GetTextBoxHandle("DetailStatusWnd.txtHeadPhysicalAttack").SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14743), tooltipColor, , 220));
	GetTextBoxHandle("DetailStatusWnd.txtHeadPhysicalDefense").SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14745), tooltipColor, , 220));
	GetTextBoxHandle("DetailStatusWnd.txtHeadHitRate").SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14747), tooltipColor, , 220));
	GetTextBoxHandle("DetailStatusWnd.txtHeadPhysicalAvoid").SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14749), tooltipColor, , 220));
	GetTextBoxHandle("DetailStatusWnd.txtHeadCriticalRate").SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14753), tooltipColor, , 220));
	GetTextBoxHandle("DetailStatusWnd.txtHeadPhysicalAttackSpeed").SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14751), tooltipColor, , 220));
	GetTextBoxHandle("DetailStatusWnd.txtHeadMagicalAttack").SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14744), tooltipColor, , 220));
	GetTextBoxHandle("DetailStatusWnd.txtHeadMagicDefense").SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14746), tooltipColor, , 220));
	GetTextBoxHandle("DetailStatusWnd.txtHeadMagicHit").SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14748), tooltipColor, , 220));
	GetTextBoxHandle("DetailStatusWnd.txtHeadMagicAvoid").SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14750), tooltipColor, , 220));
	GetTextBoxHandle("DetailStatusWnd.txtHeadMagicCritical").SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14755), tooltipColor, , 220));
	GetTextBoxHandle("DetailStatusWnd.txtHeadMagicCastingSpeed").SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14752), tooltipColor, , 220));
	GetTextBoxHandle("DetailStatusWnd.txtHeadPSkillCriticalRate").SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14754), tooltipColor, , 220));
	GetTextBoxHandle("DetailStatusWnd.txtHeadMovingSpeed").SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14764), tooltipColor, , 220));
	GetTextBoxHandle("DetailStatusWnd.txtHeadAttackAttrType").SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14765), tooltipColor, , 220));
	GetTextBoxHandle("DetailStatusWnd.txtHeadDefenseFire").SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14766), tooltipColor, , 220));
	GetTextBoxHandle("DetailStatusWnd.txtHeadDefenseWind").SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14768), tooltipColor, , 220));
	GetTextBoxHandle("DetailStatusWnd.txtHeadDefenseHoly").SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14770), tooltipColor, , 220));
	GetTextBoxHandle("DetailStatusWnd.txtHeadDefenseWater").SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14767), tooltipColor, , 220));
	GetTextBoxHandle("DetailStatusWnd.txtHeadDefenseEarth").SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14769), tooltipColor, , 220));
	GetTextBoxHandle("DetailStatusWnd.txtHeadDefenseUnHoly").SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14771), tooltipColor, , 220));
	GetTextBoxHandle("DetailStatusWnd.txtHeadCriminalRate").SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14772), tooltipColor, , 220));
	GetTextBoxHandle("DetailStatusWnd.txtHeadSociality").SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14774), tooltipColor, , 220));
	GetTextBoxHandle("DetailStatusWnd.txtHeadPerfect").SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14980), tooltipColor, , 220));
	GetTextBoxHandle("DetailStatusWnd.txtHeadPVP").SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14773), tooltipColor, , 220));
	GetTextBoxHandle("DetailStatusWnd.txtHeadRemainSulffrage").SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14775), tooltipColor, , 220));
	APActive = GetAnimTextureHandle("DetailStatusWnd.APActive");
	FightInfo_BTN = GetButtonHandle((m_Windowname $ ".FightInfo_BTN"));
	isDualClass = false;
	return;
}

function UpdateVp(int vitality)
{
	if(((vitality < 2205) && (vitality > 0)))
	{
		texVP.SetPoint(INT64(2205), INT64(MaxVitality));
	}
	else
	{
		texVP.SetPoint(INT64(vitality), INT64(MaxVitality));
	}
	return;
}

function OnEnterState(name a_CurrentStateName)
{
	HandleUpdateUserInfo();
	return;
}

function OnShow()
{
	HandleUpdateUserInfo();
	return;
}

event OnHide()
{
	if(DialogIsMine())
	{
		DialogHide();
	}
	return;
}

function OnEvent(int Event_ID, string param)
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
	else if((Event_ID == 4100))
	{
		HandleVitalityPointInfo(param);
	}
	else if((Event_ID == 5310))
	{
		updateSubjobInfo(param, Event_ID);
	}
	else if((Event_ID == 5311))
	{
		updateSubjobInfo(param, Event_ID);
		if(((Me.IsShowWindow() == false) && !getInstanceUIData().getIsArenaServer()))
		{
			Me.ShowWindow();
			Me.SetFocus();
		}
		ExecuteEvent(3280);
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
	return;
}

function hideAlchemyWindow(string winName)
{
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow(winName))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow(winName);
	}
	return;
}

function updateSubjobInfo(string param, int Event_ID)
{
	local int Count, i;
	local UserInfo myUserInfo;
	local bool bFlag;
	local SubjobInfo tempSubjobInfo;

	isDualClass = false;
	hideAlchemyWindow("AlchemyItemConversionWnd");
	hideAlchemyWindow("AlchemyMixCubeWnd");
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
	if((Count > 0))
	{
		initClassChangeButton(true);
	}
	else
	{
		initClassChangeButton(false);
	}
	i = 1;
	while((i < Count))
	{
		if((i < Count))
		{
			if((beforeSubjobInfo.ClassID == subjobInfoArray[i].ClassID))
			{
				bFlag = true;
			}
			else
			{
				bFlag = false;
			}
			if((subjobInfoArray[i].Type == 2))
			{
				if((GetClassTransferDegree(subjobInfoArray[i].ClassID) >= 1))
				{
					setClassTexture(i, "l2ui_ct1.playerstatuswnd_ClassBgSub_Small", (("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ string(subjobInfoArray[i].ClassID)) $ "_Small"), bFlag);
				}
				else
				{
					setClassTexture(i, "l2ui_ct1.playerstatuswnd_ClassBgSub_Small", (("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ GetRaceString(Race)) $ "_Small"), bFlag);
				}
			}
			else if((subjobInfoArray[i].Type == 1))
			{
				if((GetClassTransferDegree(subjobInfoArray[i].ClassID) >= 1))
				{
					setClassTexture(i, "l2ui_ct1.PlayerStatusWnd_ClassBgDual_Small", (("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ string(subjobInfoArray[i].ClassID)) $ "_Small"), bFlag);
				}
				else
				{
					setClassTexture(i, "l2ui_ct1.PlayerStatusWnd_ClassBgDual_Small", (("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ GetRaceString(Race)) $ "_Small"), bFlag);
				}
			}
			else if((subjobInfoArray[i].Type == 0))
			{
				if((GetClassTransferDegree(subjobInfoArray[i].ClassID) >= 1))
				{
					setClassTexture(i, "l2ui_ct1.PlayerStatusWnd_ClassBgMain_Small", (("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ string(subjobInfoArray[i].ClassID)) $ "_Small"), bFlag);
				}
				else
				{
					setClassTexture(i, "l2ui_ct1.PlayerStatusWnd_ClassBgMain_Small", (("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ GetRaceString(Race)) $ "_Small"), bFlag);
				}
			}
			GetButtonHandle(((m_Windowname $ ".ClassFrameBtn") $ string(i))).EnableWindow();
			GetButtonHandle(((m_Windowname $ ".ClassFrameBtn") $ string(i))).ShowWindow();
			GetButtonHandle(((m_Windowname $ ".ClassFrameBtn") $ string(i))).SetTexture("L2UI_ct1.PlayerStatusWnd_ClassFrameBtn", "L2UI_ct1.PlayerStatusWnd_ClassFrameBtn_down", "L2UI_ct1.PlayerStatusWnd_ClassFrameBtn_over");
			GetButtonHandle(((m_Windowname $ ".ClassFrameBtn") $ string(i))).SetTooltipCustomType(subjobButtonToolTips(i));
			GetTextureHandle(((m_Windowname $ ".ClassSlotBlank") $ string(i))).HideWindow();
			i++;
			continue;
		}
		if((Race != 6))
		{
			setClassTexture(i, "", "", false);
			GetButtonHandle(((m_Windowname $ ".ClassFrameBtn") $ string(i))).DisableWindow();
			GetButtonHandle(((m_Windowname $ ".ClassFrameBtn") $ string(i))).SetTexture("L2UI_ct1.Misc_DF_Blank", "L2UI_ct1.Misc_DF_Blank", "L2UI_ct1.Misc_DF_Blank");
			GetButtonHandle(((m_Windowname $ ".ClassFrameBtn") $ string(i))).SetTooltipCustomType(subjobButtonToolTips(-1));
			GetTextureHandle(((m_Windowname $ ".ClassSlotBlank") $ string(i))).ShowWindow();
		}
		i++;
	}
	if((GetClassTransferDegree(subjobInfoArray[currentSubjobClassNum].ClassID) >= 1))
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
						infItem.Id.ClassID = 1567;
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
			DialogSetCancelD(90005);
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

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "AbilityOpen":
			if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("AbilityUIWnd"))
			{
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow("AbilityUIWnd");
			}
			else
			{
				toggleWindow("AbilityUIWnd", true, true);
			}
			break;
		case "ClassFrameBtn1":
			if((GetButtonHandle((m_Windowname $ ".ClassFrameBtn1")).IsEnableWindow() && (subjobInfoArray.Length > 1)))
			{
				ExecuteEvent(3280);
				effectAniTexture(1);
				askDialogBox(1);
			}
			break;
		case "FightInfo_BTN":
			if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("InfoFightWndLive"))
			{
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow("InfoFightWndLive");
			}
			else
			{
				Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("InfoFightWndLive");
				Class'NWindow.UIAPI_WINDOW'.static.SetFocus("InfoFightWndLive");
			}
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
	else
	{
		GetTextureHandle(((m_Windowname $ ".ClassBgMain_Small") $ string(TargetType))).SetTexture(bgTexture);
		GetTextureHandle(((m_Windowname $ ".ClassMarkSmall") $ string(TargetType))).SetTexture(markTextureStr);
		GetTextureHandle(((m_Windowname $ ".ClassMarkSmall") $ string(TargetType))).ShowWindow();
		if((effectFlag == true))
		{
			effectAniTexture(TargetType);
		}
	}
	return;
}

function HandleToggle()
{
	if(getInstanceUIData().GetIsClassicServer())
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
	return string(int(MovingSpeed));
}

function float GetMyExpRate()
{
	return (Class'NWindow.UIDATA_PLAYER'.static.GetPlayerEXPRate() * 100.0000000);
}

function HandleUpdateUserGauge(int Type)
{
	local INT64 CurValue, MaxValue;
	local int vitality;
	local UserInfo Info;

	if(GetMyUserInfo(Info))
	{
		vitality = Info.nVitality;
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
				UpdateVp(vitality);
			default:
				break;
		}
	}
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

function setSubjobSlot(bool isEr)
{
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
	local string HeroTexture;
	local bool bHero;
	local int nNobless, nStr, nDex, nCon, nInt, nWit, nMen;
	local string strTmp;
	local int nLuc, nCha;
	local INT64 PhysicalAttack;
	local int PhysicalDefense, HitRate, CriticalRate, PhysicalAttackSpeed;
	local INT64 MagicalAttack;
	local int MagicDefense, PhysicalAvoid;
	local string MovingSpeed;
	local int MagicCastingSpeed, CriminalRate, iNameColorRate;
	local string strCriminalRate;
	local int DualCount, PKCount, PvPPoint, VoteCount, BonusCount, NegativeVoteCount, Notoriety, Perfect, AttrAttackType, AttrAttackValue, AttrDefenseValFire, AttrDefenseValWater, AttrDefenseValWind, AttrDefenseValEarth, AttrDefenseValHoly, AttrDefenseValUnholy;
	local string AttrAttackTypeTxt;
	local int nMagicAvoid, nMagicHitRate, nMagicCriticalRate, nPSkillCriticalRate;
	local bool m_bPawnChanged;
	local UserInfo Info;
	local int vitality;

	texPledgeCrest.SetTexture("");
	rectWnd = m_hOwnerWnd.GetRect();
	if(GetMyUserInfo(Info))
	{
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
		bHero = Info.bHero;
		nNobless = Info.nNobless;
		NicknameColor = Info.NicknameColor;
		nStr = Info.nStr;
		nDex = Info.nDex;
		nCon = Info.nCon;
		nInt = Info.nInt;
		nWit = Info.nWit;
		nMen = Info.nMen;
		nLuc = Info.nLuc;
		nCha = Info.nCha;
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
		PvPPoint = Info.PvPPoint;
		VoteCount = Info.nVoteCount;
		BonusCount = Info.nBonusCount;
		NegativeVoteCount = Info.nNegativeVoteCount;
		Notoriety = Info.nNotoriety;
		Perfect = Info.nPerfect;
		vitality = Info.nVitality;
		AttrAttackType = Info.AttrAttackType;
		AttrAttackValue = Info.AttrAttackValue;
		AttrDefenseValFire = Info.AttrDefenseValFire;
		AttrDefenseValWater = Info.AttrDefenseValWater;
		AttrDefenseValWind = Info.AttrDefenseValWind;
		AttrDefenseValEarth = Info.AttrDefenseValEarth;
		AttrDefenseValHoly = Info.AttrDefenseValHoly;
		AttrDefenseValUnholy = Info.AttrDefenseValUnholy;
		m_bPawnChanged = Info.m_bPawnChanged;
		nMagicAvoid = Info.nMagicAvoid;
		nMagicHitRate = Info.nMagicHitRate;
		nMagicCriticalRate = Info.nMagicCriticalRate;
		nPSkillCriticalRate = Info.nPSkillCriticalRate;
		switch(AttrAttackType)
		{
			case -2:
				AttrAttackTypeTxt = GetSystemString(27);
				break;
			case 0:
				AttrAttackTypeTxt = GetSystemString(1630);
				break;
			case 1:
				AttrAttackTypeTxt = GetSystemString(1631);
				break;
			case 2:
				AttrAttackTypeTxt = GetSystemString(1632);
				break;
			case 3:
				AttrAttackTypeTxt = GetSystemString(1633);
				break;
			case 4:
				AttrAttackTypeTxt = GetSystemString(1634);
				break;
			case 5:
				AttrAttackTypeTxt = GetSystemString(1635);
				break;
			default:
				break;
		}
		UpdateVp(vitality);
		setSubjobSlot((Info.Race == 6));
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
				nickname = Left(nickname, 8);
				GetTextSizeDefault(nickname, Width2, Height2);
			}
		}
		txtName1.SetText(nickname);
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
	if(getInstanceL2Util().getIsPrologueGrowType(SubClassID))
	{
		if((int(GetLanguage()) == 0))
		{
			txtLvName.SetText("∞");
		}
		else
		{
			txtLvName.SetText("--");
		}
	}
	else
	{
		txtLvName.SetText(("" $ string(Level)));
	}
	txtClassName.SetText(ClassName);
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
		txtPledge.MoveTo((rectWnd.nX + 114), (rectWnd.nY + 68));
	}
	else
	{
		txtPledge.MoveTo((rectWnd.nX + 90), (rectWnd.nY + 68));
	}
	if(bHero)
	{
		HeroTexture = "L2UI_CH3.PlayerStatusWnd.myinfo_heroicon";
	}
	else if((nNobless == 1))
	{
		HeroTexture = "L2UI_CH3.PlayerStatusWnd.myinfo_nobleicon";
	}
	else if((nNobless == 2))
	{
		HeroTexture = "L2UI_CH3.PlayerStatusWnd.myinfo_nobleicon2";
	}
	texHero.SetTexture(HeroTexture);
	if((m_HennaInfo.STRchange > 0))
	{
		strTmp = (((string(nStr) $ "(+") $ string(m_HennaInfo.STRchange)) $ ")");
	}
	else if((m_HennaInfo.STRchange < 0))
	{
		strTmp = (((string(nStr) $ "(") $ string(m_HennaInfo.STRchange)) $ ")");
	}
	else
	{
		strTmp = string(nStr);
	}
	txtSTR.SetText(strTmp);
	if((m_HennaInfo.DEXchange > 0))
	{
		strTmp = (((string(nDex) $ "(+") $ string(m_HennaInfo.DEXchange)) $ ")");
	}
	else if((m_HennaInfo.DEXchange < 0))
	{
		strTmp = (((string(nDex) $ "(") $ string(m_HennaInfo.DEXchange)) $ ")");
	}
	else
	{
		strTmp = string(nDex);
	}
	txtDEX.SetText(strTmp);
	if((m_HennaInfo.CONchange > 0))
	{
		strTmp = (((string(nCon) $ "(+") $ string(m_HennaInfo.CONchange)) $ ")");
	}
	else if((m_HennaInfo.CONchange < 0))
	{
		strTmp = (((string(nCon) $ "(") $ string(m_HennaInfo.CONchange)) $ ")");
	}
	else
	{
		strTmp = string(nCon);
	}
	txtCON.SetText(strTmp);
	if((m_HennaInfo.INTchange > 0))
	{
		strTmp = (((string(nInt) $ "(+") $ string(m_HennaInfo.INTchange)) $ ")");
	}
	else if((m_HennaInfo.INTchange < 0))
	{
		strTmp = (((string(nInt) $ "(") $ string(m_HennaInfo.INTchange)) $ ")");
	}
	else
	{
		strTmp = string(nInt);
	}
	txtINT.SetText(strTmp);
	if((m_HennaInfo.WITchange > 0))
	{
		strTmp = (((string(nWit) $ "(+") $ string(m_HennaInfo.WITchange)) $ ")");
	}
	else if((m_HennaInfo.WITchange < 0))
	{
		strTmp = (((string(nWit) $ "(") $ string(m_HennaInfo.WITchange)) $ ")");
	}
	else
	{
		strTmp = string(nWit);
	}
	txtWIT.SetText(strTmp);
	if((m_HennaInfo.MENchange > 0))
	{
		strTmp = (((string(nMen) $ "(+") $ string(m_HennaInfo.MENchange)) $ ")");
	}
	else if((m_HennaInfo.MENchange < 0))
	{
		strTmp = (((string(nMen) $ "(") $ string(m_HennaInfo.MENchange)) $ ")");
	}
	else
	{
		strTmp = string(nMen);
	}
	txtMEN.SetText(strTmp);
	if((m_HennaInfo.LUCchange > 0))
	{
		strTmp = (((string(nLuc) $ "(+") $ string(m_HennaInfo.LUCchange)) $ ")");
	}
	else if((m_HennaInfo.LUCchange < 0))
	{
		strTmp = (((string(nLuc) $ "(") $ string(m_HennaInfo.LUCchange)) $ ")");
	}
	else
	{
		strTmp = string(nLuc);
	}
	txtLUC.SetText(strTmp);
	if((m_HennaInfo.CHAchange > 0))
	{
		strTmp = (((string(nCha) $ "(+") $ string(m_HennaInfo.CHAchange)) $ ")");
	}
	else if((m_HennaInfo.CHAchange < 0))
	{
		strTmp = (((string(nCha) $ "(") $ string(m_HennaInfo.CHAchange)) $ ")");
	}
	else
	{
		strTmp = string(nCha);
	}
	txtCHA.SetText(strTmp);
	nMagicAvoid = Info.nMagicAvoid;
	nMagicHitRate = Info.nMagicHitRate;
	nMagicCriticalRate = Info.nMagicCriticalRate;
	GetTextBoxHandle((m_Windowname $ ".txtMagicAvoid")).SetText(string(nMagicAvoid));
	GetTextBoxHandle((m_Windowname $ ".txtMagicHit")).SetText(string(nMagicHitRate));
	GetTextBoxHandle((m_Windowname $ ".txtMagicCritical")).SetText(string(nMagicCriticalRate));
	GetTextBoxHandle((m_Windowname $ ".txtPSkillCriticalRate")).SetText(string(nPSkillCriticalRate));
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
	txtCriminalRate.SetText(strCriminalRate);
	txtPVP.SetText(string(PvPPoint));
	txtSociality.SetText(((string(DualCount) $ " / ") $ string(PKCount)));
	txtBonusVote.SetText(((string(BonusCount) $ " / ") $ string(VoteCount)));
	txtPerfect.SetText(string(Perfect));
	UpdateHPBar(Hp, MaxHP);
	UpdateMPBar(INT64(MP), INT64(maxMP));
	UpdateCPBar(INT64(CP), INT64(maxCP));
	UpdateEXPBar(Info.fExpPercentRate);
	txtAttrAttackType.SetText(("" $ AttrAttackTypeTxt));
	txtAttrAttackValue.SetText(("" $ string(AttrAttackValue)));
	txtAttrDefenseValFire.SetText(("" $ string(AttrDefenseValFire)));
	txtAttrDefenseValWater.SetText(("" $ string(AttrDefenseValWater)));
	txtAttrDefenseValWind.SetText(("" $ string(AttrDefenseValWind)));
	txtAttrDefenseValEarth.SetText(("" $ string(AttrDefenseValEarth)));
	txtAttrDefenseValHoly.SetText(("" $ string(AttrDefenseValHoly)));
	txtAttrDefenseValUnholy.SetText(("" $ string(AttrDefenseValUnholy)));
	if(m_bPawnChanged)
	{
	}
	else
	{
		RunUnTransformManage();
	}
	UpdateAbilityBtn();
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

function UpdateEXPBar(float ExpPercent)
{
	texExp.SetPointExpPercentRate(ExpPercent);
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

function HandleVitalityPointInfo(string param)
{
	local int nVitality;

	ParseInt(param, "Vitality", nVitality);
	UpdateVp(nVitality);
	return;
}

function HandleVitalityEffectInfo(string param)
{
	local CustomTooltip t;
	local int nVitality, nVitalityBonus, nVitalityItemRestoreCount, nVitalityExtraBonus;
	local string sBonusString, sExtraBonusString;

	ParseInt(param, "vitalityPoint", nVitality);
	ParseInt(param, "vitalityBonus", nVitalityBonus);
	ParseInt(param, "restoreCount", nVitalityItemRestoreCount);
	util = L2Util(GetScript("L2Util"));
	util.setCustomTooltip(t);
	util.ToopTipInsertText(GetSystemString(2494), true, false);
	ParseInt(param, "vitalityExtraBonus", nVitalityExtraBonus);
	sBonusString = (string(nVitalityBonus) $ "%");
	if((nVitalityExtraBonus > 0))
	{
		sExtraBonusString = (("(+" $ string(nVitalityExtraBonus)) $ "%)");
	}
	util = L2Util(GetScript("L2Util"));
	util.setCustomTooltip(t);
	util.ToopTipInsertText(GetSystemString(2494), true, false);
	if((nVitality <= 0))
	{
		util.ToopTipInsertText(GetSystemString(2496), true, false, COLOR_GRAY);
		util.ToopTipInsertText(GetSystemMessage(13112), true, true);
	}
	else
	{
		util.ToopTipInsertText(sBonusString, true, false);
		util.ToopTipInsertText(sExtraBonusString, true, false, COLOR_YELLOW03);
		util.ToopTipInsertText(((" " $ GetSystemString(2495)) $ ". "), true, false);
		util.ToopTipInsertText(GetSystemMessage(13111), true, true);
	}
	texVP.SetTooltipCustomType(util.getCustomToolTip());
	return;
}

function RunTransformManage()
{
	return;
}

function RunUnTransformManage()
{
	return;
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

function int getMainLevel()
{
	local int i;
	local UserInfo Info;

	if((subjobInfoArray.Length > 1))
	{
		i = 0;
		while((i < subjobInfoArray.Length))
		{
			if((subjobInfoArray[i].Type == 0))
			{
				if((CurrentSubjobClassID == subjobInfoArray[i].ClassID))
				{
					GetPlayerInfo(Info);
					return Info.nLevel;
					i++;
					continue;
				}
				return subjobInfoArray[i].Level;
			}
			i++;
		}
	}
	else
	{
		GetPlayerInfo(Info);
		return Info.nLevel;
	}
	Debug("Error: DetailStatusWnd getMainLevel의 값이 잘못되었습니다. -1 ");  // EN: Error: DetailStatusWnd getMainLevel returned a bad value. -1
	return -1;
}

function int getMainClassID()
{
	local int i;
	local UserInfo Info;

	if((subjobInfoArray.Length > 1))
	{
		i = 0;
		while((i < subjobInfoArray.Length))
		{
			if((subjobInfoArray[i].Type == 0))
			{
				return subjobInfoArray[i].ClassID;
			}
			i++;
		}
	}
	else
	{
		GetPlayerInfo(Info);
		return Info.nSubClass;
	}
	Debug("Error: DetailStatusWnd getMainClassID의 값이 잘못되었습니다. -1 ");  // EN: Error: DetailStatusWnd getMainClassID returned a bad value. -1
	return -1;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="DetailStatusWnd"
}
