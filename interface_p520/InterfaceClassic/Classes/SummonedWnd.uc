class SummonedWnd extends UICommonAPI;

const summonMaxNum = 4;
const summonpintMinPoint = 2;

struct summonedSlot
{
	var string Name;
	var int ServerID;
	var int ClassID;
	var int Level;
};

var WindowHandle Me;
var WindowHandle SummonedWnd_Status;
var TextBoxHandle txtLvHead;
var TextBoxHandle txtLvName;
var TextBoxHandle txtHeadFight;
var TextBoxHandle txtHeadPhysicalAttack;
var TextBoxHandle txtHeadPhysicalDefense;
var TextBoxHandle txtHeadHitRate;
var TextBoxHandle txtHeadPhysicalAvoid;
var TextBoxHandle txtHeadCriticalRate;
var TextBoxHandle txtHeadPhysicalAttackSpeed;
var TextBoxHandle txtHeadMovingSpeed;
var TextBoxHandle txtHeadSoulShot;
var TextBoxHandle txtHeadMagicalAttack;
var TextBoxHandle txtHeadMagicDefense;
var TextBoxHandle txtHeadMagicHit;
var TextBoxHandle txtHeadMagicAvoid;
var TextBoxHandle txtHeadMagicCritical;
var TextBoxHandle txtHeadMagicCastingSpeed;
var TextBoxHandle txtHeadSoulShotCosume1;
var TextBoxHandle txtHeadSoulShotCosume2;
var TextBoxHandle txtPhysicalAttack;
var TextBoxHandle txtPhysicalDefense;
var TextBoxHandle txtHitRate;
var TextBoxHandle txtPhysicalAvoid;
var TextBoxHandle txtCriticalRate;
var TextBoxHandle txtPhysicalAttackSpeed;
var TextBoxHandle txtMovingSpeed;
var TextBoxHandle txtMagicalAttack;
var TextBoxHandle txtMagicDefense;
var TextBoxHandle txtMagicHit;
var TextBoxHandle txtMagicAvoid;
var TextBoxHandle txtMagicCritical;
var TextBoxHandle txtMagicCastingSpeed;
var TextBoxHandle txtSoulShotCosume1;
var TextBoxHandle txtSoulShotCosume2;
var TextureHandle BackTex1;
var TextureHandle BackTex2;
var TextureHandle BackTex3;
var TextureHandle DividerLine;
var TextureHandle DividerLine2;
var TextureHandle SummonedFace;
var TextureHandle SummonedSlotOutline;
var WindowHandle SummonedWnd_Action;
var WindowHandle SummonedWnd_Action1;
var ItemWindowHandle SummonedActionWnd_Before;
var TextureHandle BackTexAction1_Before;
var WindowHandle SummonedWnd_Action2;
var TextBoxHandle txtHeadDirect;
var TextBoxHandle txtHeadPolicy;
var TextBoxHandle txtHeadSkill;
var ItemWindowHandle SummonedActionWnd;
var ItemWindowHandle SummonedActionWnd2;
var ItemWindowHandle SummonedActionWnd3;
var TextureHandle BackTexAction1;
var TextureHandle BackTexAction2;
var TextureHandle BackTexAction3;
var BarHandle barHP_1;
var BarHandle barHP_2;
var BarHandle barHP_3;
var BarHandle barHP_4;
var BarHandle barMP_1;
var BarHandle barMP_2;
var BarHandle barMP_3;
var BarHandle barMP_4;
var StatusBarHandle barSummonPoint;
var TextureHandle SummonedGroupBox1;
var TextureHandle SummonedGroupBox2;
var TextureHandle SummonedGroupBox3;
var TextureHandle SummonedGroupBox4;
var TextureHandle SummonedGroupBox5;
var TextureHandle SummonedSlotNone1;
var TextureHandle SummonedSlotNone2;
var TextureHandle SummonedSlotNone3;
var TextureHandle SummonedSlotNone4;
var TextureHandle SummonedSlotBlank1;
var TextureHandle SummonedSlotBlank2;
var TextureHandle SummonedSlotBlank3;
var TextureHandle SummonedSlotBlank4;
var TextureHandle SummonedFace1;
var TextureHandle SummonedFace2;
var TextureHandle SummonedFace3;
var TextureHandle SummonedFace4;
var TextureHandle SummonedSlotOutline1;
var TextureHandle SummonedSlotOutline2;
var TextureHandle SummonedSlotOutline3;
var TextureHandle SummonedSlotOutline4;
var ButtonHandle btnBar_1;
var ButtonHandle btnBar_2;
var ButtonHandle btnBar_3;
var ButtonHandle btnBar_4;
var TextBoxHandle txtHeadSummonPoint;
var TabHandle TabCtrl;
var TextureHandle TabLineTop;
var TextureHandle tabBg1;
var L2Util util;
var int summonServerID;
var bool bAwakeStateFlag;
var int selectedSlotIndex;
var summonedSlot summonedSlotArray[4];
var int currentSummonPolicy;

function OnRegisterEvent()
{
	RegisterEvent(251);
	RegisterEvent(1090);
	RegisterEvent(1131);
	RegisterEvent(1311);
	RegisterEvent(1340);
	RegisterEvent(1350);
	RegisterEvent(1120);
	RegisterEvent(1900);
	RegisterEvent(9140);
	RegisterEvent(40);
	RegisterEvent(980);
	RegisterEvent(1351);
	RegisterEvent(1352);
	RegisterEvent(1132);
	RegisterEvent(190);
	RegisterEvent(210);
	return;
}

function OnEvent(int Event_ID, string param)
{
	local int ServerID, CurrentHP, currentMP, SlotIndex;

	if(DebugConditions(Event_ID))
	{
	}
	if((Event_ID == 980))
	{
		HandleTargetUpdate();
	}
	else if((Event_ID == 9140))
	{
	}
	else if((Event_ID == 1351))
	{
	}
	else if((Event_ID == 1340))
	{
	}
	else if((Event_ID == 1352))
	{
		HandleActionSummonedList(param);
	}
	else if((Event_ID == 1350))
	{
		HandleActionSummonedList(param);
	}
	else if((Event_ID == 251))
	{
		if((GetGameStateName() != "GAMINGSTATE"))
		{
			return;
		}
		ParseInt(param, "ServerID", ServerID);
		if((ServerID != 0))
		{
			HandleSummonInfoUpdate(ServerID);
		}
	}
	else if((Event_ID == 190))
	{
		ParseInt(param, "ServerID", ServerID);
		ParseInt(param, "CurrentHP", CurrentHP);
		if((ServerID != 0))
		{
			SlotIndex = GetIsSummonedSlotIndex(ServerID);
			if((SlotIndex == -1))
			{
				return;
			}
			setStatusBarHP(SlotIndex, CurrentHP, ServerID);
		}
	}
	else if((Event_ID == 210))
	{
		ParseInt(param, "ServerID", ServerID);
		ParseInt(param, "CurrentMP", currentMP);
		if((ServerID != 0))
		{
			SlotIndex = GetIsSummonedSlotIndex(ServerID);
			if((SlotIndex == -1))
			{
				return;
			}
			setStatusBarMP(SlotIndex, currentMP, ServerID);
		}
	}
	else if((Event_ID == 1120))
	{
	}
	else if((Event_ID == 1131))
	{
		HandleSummonedStatusClose();
	}
	else if((Event_ID == 1090))
	{
		HandleSummonShow();
	}
	else if((Event_ID == 1900))
	{
	}
	else if((Event_ID == 1311))
	{
	}
	else if((Event_ID == 40))
	{
		Restart();
	}
	else if((Event_ID == 1132))
	{
		HandleSummonedDelete(param);
	}
	return;
}

function OnLoad()
{
	local int i;

	SetClosingOnESC();
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	util = L2Util(GetScript("L2Util"));
	Initialize();
	currentSummonPolicy = -1;
	i = 1;
	while((i <= 4))
	{
		GetTextureHandle(("SummonedWnd.SummonedSlotOutline" $ string(i))).HideWindow();
		GetBarHandle(("SummonedWnd.barHP_" $ string(i))).HideWindow();
		GetBarHandle(("SummonedWnd.barMP_" $ string(i))).HideWindow();
		i++;
	}
	txtHeadSoulShotCosume1.SetText(GetSystemString(404));
	txtHeadSoulShotCosume2.SetText(GetSystemString(496));
	return;
}

function Initialize()
{
	Me = GetWindowHandle("SummonedWnd");
	SummonedWnd_Status = GetWindowHandle("SummonedWnd.SummonedWnd_Status");
	txtLvHead = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtLvHead");
	txtLvName = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtLvName");
	txtHeadFight = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtHeadFight");
	txtHeadPhysicalAttack = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtHeadPhysicalAttack");
	txtHeadPhysicalDefense = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtHeadPhysicalDefense");
	txtHeadHitRate = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtHeadHitRate");
	txtHeadPhysicalAvoid = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtHeadPhysicalAvoid");
	txtHeadCriticalRate = GetTextBoxHandle("SummonedWnd.1.txtHeadCriticalRate");
	txtHeadPhysicalAttackSpeed = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtHeadPhysicalAttackSpeed");
	txtHeadMovingSpeed = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtHeadMovingSpeed");
	txtHeadSoulShot = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtHeadSoulShot");
	txtHeadMagicalAttack = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtHeadMagicalAttack");
	txtHeadMagicDefense = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtHeadMagicDefense");
	txtHeadMagicHit = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtHeadMagicHit");
	txtHeadMagicAvoid = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtHeadMagicAvoid");
	txtHeadMagicCritical = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtHeadMagicCritical");
	txtHeadMagicCastingSpeed = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtHeadMagicCastingSpeed");
	txtHeadSoulShotCosume1 = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtHeadSoulShotCosume1");
	txtHeadSoulShotCosume2 = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtHeadSoulShotCosume2");
	txtPhysicalAttack = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtPhysicalAttack");
	txtPhysicalDefense = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtPhysicalDefense");
	txtHitRate = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtHitRate");
	txtPhysicalAvoid = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtPhysicalAvoid");
	txtCriticalRate = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtCriticalRate");
	txtPhysicalAttackSpeed = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtPhysicalAttackSpeed");
	txtMovingSpeed = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtMovingSpeed");
	txtMagicalAttack = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtMagicalAttack");
	txtMagicDefense = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtMagicDefense");
	txtMagicHit = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtMagicHit");
	txtMagicAvoid = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtMagicAvoid");
	txtMagicCritical = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtMagicCritical");
	txtMagicCastingSpeed = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtMagicCastingSpeed");
	txtSoulShotCosume1 = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtSoulShotCosume1");
	txtSoulShotCosume2 = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtSoulShotCosume2");
	BackTex1 = GetTextureHandle("SummonedWnd.SummonedWnd_Status.BackTex1");
	BackTex2 = GetTextureHandle("SummonedWnd.SummonedWnd_Status.BackTex2");
	BackTex3 = GetTextureHandle("SummonedWnd.SummonedWnd_Status.BackTex3");
	DividerLine = GetTextureHandle("SummonedWnd.SummonedWnd_Status.DividerLine");
	DividerLine2 = GetTextureHandle("SummonedWnd.SummonedWnd_Status.DividerLine2");
	SummonedFace = GetTextureHandle("SummonedWnd.SummonedWnd_Status.SummonedFace");
	SummonedSlotOutline = GetTextureHandle("SummonedWnd.SummonedWnd_Status.SummonedSlotOutline");
	SummonedWnd_Action = GetWindowHandle("SummonedWnd.SummonedWnd_Action");
	SummonedWnd_Action1 = GetWindowHandle("SummonedWnd.SummonedWnd_Action.SummonedWnd_Action1");
	BackTexAction1_Before = GetTextureHandle("SummonedWnd.SummonedWnd_Action.SummonedWnd_Action1.BackTexAction1_Before");
	SummonedWnd_Action2 = GetWindowHandle("SummonedWnd.SummonedWnd_Action.SummonedWnd_Action2");
	txtHeadDirect = GetTextBoxHandle("SummonedWnd.SummonedWnd_Action.SummonedWnd_Action2.txtHeadDirect");
	txtHeadPolicy = GetTextBoxHandle("SummonedWnd.SummonedWnd_Action.SummonedWnd_Action2.txtHeadPolicy");
	txtHeadSkill = GetTextBoxHandle("SummonedWnd.SummonedWnd_Action.SummonedWnd_Action2.txtHeadSkill");
	SummonedActionWnd_Before = GetItemWindowHandle("SummonedWnd.SummonedWnd_Action.SummonedWnd_Action1.SummonedActionWnd_Before");
	SummonedActionWnd = GetItemWindowHandle("SummonedWnd.SummonedWnd_Action.SummonedWnd_Action2.SummonedActionWnd");
	SummonedActionWnd2 = GetItemWindowHandle("SummonedWnd.SummonedWnd_Action.SummonedWnd_Action2.SummonedActionWnd2");
	SummonedActionWnd3 = GetItemWindowHandle("SummonedWnd.SummonedWnd_Action.SummonedWnd_Action2.SummonedActionWnd3");
	BackTexAction1 = GetTextureHandle("SummonedWnd.SummonedWnd_Action.SummonedWnd_Action2.BackTexAction1");
	BackTexAction2 = GetTextureHandle("SummonedWnd.SummonedWnd_Action.SummonedWnd_Action2.BackTexAction2");
	BackTexAction3 = GetTextureHandle("SummonedWnd.SummonedWnd_Action.SummonedWnd_Action2.BackTexAction3");
	barHP_1 = GetBarHandle("SummonedWnd.barHP_1");
	barHP_2 = GetBarHandle("SummonedWnd.barHP_2");
	barHP_3 = GetBarHandle("SummonedWnd.barHP_3");
	barHP_4 = GetBarHandle("SummonedWnd.barHP_4");
	barMP_1 = GetBarHandle("SummonedWnd.barMP_1");
	barMP_2 = GetBarHandle("SummonedWnd.barMP_2");
	barMP_3 = GetBarHandle("SummonedWnd.barMP_3");
	barMP_4 = GetBarHandle("SummonedWnd.barMP_4");
	SummonedGroupBox1 = GetTextureHandle("SummonedWnd.SummonedGroupBox1");
	SummonedGroupBox2 = GetTextureHandle("SummonedWnd.SummonedGroupBox2");
	SummonedGroupBox3 = GetTextureHandle("SummonedWnd.SummonedGroupBox3");
	SummonedGroupBox4 = GetTextureHandle("SummonedWnd.SummonedGroupBox4");
	SummonedGroupBox5 = GetTextureHandle("SummonedWnd.SummonedGroupBox5");
	SummonedSlotNone1 = GetTextureHandle("SummonedWnd.SummonedSlotNone1");
	SummonedSlotNone2 = GetTextureHandle("SummonedWnd.SummonedSlotNone2");
	SummonedSlotNone3 = GetTextureHandle("SummonedWnd.SummonedSlotNone3");
	SummonedSlotNone4 = GetTextureHandle("SummonedWnd.SummonedSlotNone4");
	SummonedSlotBlank1 = GetTextureHandle("SummonedWnd.SummonedSlotBlank1");
	SummonedSlotBlank2 = GetTextureHandle("SummonedWnd.SummonedSlotBlank2");
	SummonedSlotBlank3 = GetTextureHandle("SummonedWnd.SummonedSlotBlank3");
	SummonedSlotBlank4 = GetTextureHandle("SummonedWnd.SummonedSlotBlank4");
	SummonedFace1 = GetTextureHandle("SummonedWnd.SummonedFace1");
	SummonedFace2 = GetTextureHandle("SummonedWnd.SummonedFace2");
	SummonedFace3 = GetTextureHandle("SummonedWnd.SummonedFace3");
	SummonedFace4 = GetTextureHandle("SummonedWnd.SummonedFace4");
	SummonedSlotOutline1 = GetTextureHandle("SummonedWnd.SummonedSlotOutline1");
	SummonedSlotOutline2 = GetTextureHandle("SummonedWnd.SummonedSlotOutline2");
	SummonedSlotOutline3 = GetTextureHandle("SummonedWnd.SummonedSlotOutline3");
	SummonedSlotOutline4 = GetTextureHandle("SummonedWnd.SummonedSlotOutline4");
	btnBar_1 = GetButtonHandle("SummonedWnd.btnBar_1");
	btnBar_2 = GetButtonHandle("SummonedWnd.btnBar_2");
	btnBar_3 = GetButtonHandle("SummonedWnd.btnBar_3");
	btnBar_4 = GetButtonHandle("SummonedWnd.btnBar_4");
	txtHeadSummonPoint = GetTextBoxHandle("SummonedWnd.txtHeadSummonPoint");
	TabCtrl = GetTabHandle("SummonedWnd.TabCtrl");
	TabLineTop = GetTextureHandle("SummonedWnd.TabLineTop");
	tabBg1 = GetTextureHandle("SummonedWnd.tabBg1");
	barSummonPoint = GetStatusBarHandle("SummonedWnd.barSummonPoint");
	bAwakeStateFlag = false;
	initSlot();
	return;
}

function initSlot()
{
	local int i;

	i = 0;
	while((i < 4))
	{
		summonedSlotArray[i].ServerID = -1;
		GetBarHandle(("SummonedWnd.barHP_" $ string((i + 1)))).SetValue(0, 0);
		GetBarHandle(("SummonedWnd.barMP_" $ string((i + 1)))).SetValue(0, 0);
		i++;
	}
	return;
}

function OnShow()
{
	return;
}

function bool DebugConditions(int Event_ID)
{
	local array<int> conditoins;
	local int i;

	conditoins[0] = 1120;
	conditoins[1] = 1350;
	i = 0;
	while((i < conditoins.Length))
	{
		if((conditoins[i] == Event_ID))
		{
			return false;
		}
		i++;
	}
	return true;
}

function Restart()
{
	local int i;

	i = 0;
	while((i < 4))
	{
		summonedSlotArray[i].ServerID = -1;
		i++;
	}
	return;
}

function OnClickItem(string strID, int Index)
{
	local ItemInfo infItem;

	if((Index > -1))
	{
		switch(strID)
		{
			case "SummonedActionWnd_Before":
				if(SummonedActionWnd_Before.GetItem(Index, infItem))
				{
					DoAction(infItem.Id);
				}
				break;
			case "SummonedActionWnd":
				if(SummonedActionWnd.GetItem(Index, infItem))
				{
					DoAction(infItem.Id);
				}
				break;
			case "SummonedActionWnd2":
				if(SummonedActionWnd2.GetItem(Index, infItem))
				{
					Debug(("index" @ string(Index)));
					Debug(("currentSummonPolicy" @ string(currentSummonPolicy)));
					if((Index != currentSummonPolicy))
					{
						SummonedActionWnd2.SetToggleEffect(Index, true);
						SummonedActionWnd2.SetToggleEffect(currentSummonPolicy, false);
						currentSummonPolicy = Index;
						DoAction(infItem.Id);
					}
				}
				break;
			case "SummonedActionWnd3":
				if(SummonedActionWnd3.GetItem(Index, infItem))
				{
					DoAction(infItem.Id);
				}
				break;
			default:
				break;
		}
	}
	return;
}

function HandleTargetUpdate()
{
	local int ServerID;

	ServerID = Class'NWindow.UIDATA_TARGET'.static.GetTargetID();
	if((GetIsSummonedSlotIndex(ServerID) != -1))
	{
		setInformation(ServerID);
		setbtnBarSelection(ServerID);
	}
	return;
}

function setTargetSummon(int Num)
{
	local UserInfo UserInfo;
	local int ServerID;

	ServerID = summonedSlotArray[Num].ServerID;
	if((ServerID != -1))
	{
		if(GetPlayerInfo(UserInfo))
		{
			RequestAction(ServerID, UserInfo.Loc);
		}
	}
	return;
}

function HandleSummonedStatusClose()
{
	local int usedSummonPoint, SummonablePoint, i;

	PlayConsoleSound(IFST_WINDOW_CLOSE);
	Me.HideWindow();
	i = 0;
	while((i < 4))
	{
		deleteSlotbyIndex(i);
		i++;
	}
	GetSummonPoint(usedSummonPoint, SummonablePoint);
	barSummonPoint.SetPoint(INT64((SummonablePoint - usedSummonPoint)), INT64(SummonablePoint));
	ClearActionWnd();
	setInformation(-1);
	setbtnBarSelection(-1);
	currentSummonPolicy = -1;
	return;
}

function HandleSummonShow()
{
	PlayConsoleSound(IFST_WINDOW_OPEN);
	if(!getInstanceUIData().GetIsClassicServer())
	{
		CheckAndHideInfoTab();
		Me.ShowWindow();
		Me.SetFocus();
	}
	return;
}

function HandleSummonedDelete(string param)
{
	local int ServerID, SlotIndex, nextSlotIndex, usedSummonPoint, SummonablePoint;

	ParseInt(param, "serverID", ServerID);
	if(bAwakeStateFlag)
	{
		SlotIndex = GetIsSummonedSlotIndex(ServerID);
		nextSlotIndex = getNextSummonedSlotIndex(SlotIndex);
		if((nextSlotIndex != -1))
		{
			SummonedActionWnd3.Clear();
			Class'NWindow.ActionAPI'.static.RequestSummonedAllSkillActionList();
			setInformation(summonedSlotArray[nextSlotIndex].ServerID);
			setbtnBarSelection(summonedSlotArray[nextSlotIndex].ServerID);
			GetSummonPoint(usedSummonPoint, SummonablePoint);
			barSummonPoint.SetPoint(INT64((SummonablePoint - usedSummonPoint)), INT64(SummonablePoint));
			deleteSlotbyIndex(SlotIndex);
			setSummonedSlotNone(false);
		}
	}
	return;
}

function bool isLock()
{
	local int usedSummonPoint, SummonablePoint;

	GetSummonPoint(usedSummonPoint, SummonablePoint);
	if((((SummonablePoint - usedSummonPoint) < 2) || (usedSummonPoint == 0)))
	{
		return true;
	}
	return false;
}

function setSummonedSlotNone(bool Lock)
{
	local string hidePath, showPath;
	local int i;

	if(Lock)
	{
		hidePath = "SummonedWnd.SummonedSlotBlank";
		showPath = "SummonedWnd.SummonedSlotNone";
	}
	else
	{
		hidePath = "SummonedWnd.SummonedSlotNone";
		showPath = "SummonedWnd.SummonedSlotBlank";
	}
	i = 1;
	while((i <= 4))
	{
		GetTextureHandle((hidePath $ string(i))).HideWindow();
		GetTextureHandle((showPath $ string(i))).ShowWindow();
		i++;
	}
	return;
}

function deleteSlotbyIndex(int SlotIndex)
{
	local TextureHandle SummonedFace;

	GetButtonHandle(("SummonedWnd.btnBar_" $ string((SlotIndex + 1)))).ClearTooltip();
	summonedSlotArray[SlotIndex].ServerID = -1;
	SummonedFace = GetTextureHandle(("SummonedWnd.SummonedFace" $ string((SlotIndex + 1))));
	SummonedFace.SetTexture("");
	GetTextureHandle(("SummonedWnd.SummonedSlotOutline" $ string((SlotIndex + 1)))).HideWindow();
	GetBarHandle(("SummonedWnd.barHP_" $ string((SlotIndex + 1)))).HideWindow();
	GetBarHandle(("SummonedWnd.barMP_" $ string((SlotIndex + 1)))).HideWindow();
	return;
}

function HandleSummonInfoUpdate(int ServerID)
{
	local int Hp, MaxHP, MP, maxMP, ClassID;
	local string Name;
	local int Level, SummonablePoint, usedSummonPoint;
	local SummonInfo Info;
	local int SlotIndex;
	local TextureHandle SummonedFace;

	if(GetSummonInfo(ServerID, Info))
	{
		ClassID = Info.nClassID;
		Name = Info.Name;
		Level = Info.nLevel;
		Hp = Info.nCurHP;
		MaxHP = Info.nMaxHP;
		MP = Info.nCurMP;
		maxMP = Info.nMaxMP;
		if((ClassID <= 0))
		{
			return;
		}
		SlotIndex = GetIsSummonedSlotIndex(ServerID);
		if((SlotIndex == -1))
		{
			SlotIndex = getSummonedSlotIndex();
			SummonedFace = GetTextureHandle(("SummonedWnd.SummonedFace" $ string((SlotIndex + 1))));
			SummonedFace.SetTexture(Class'NWindow.UIDATA_NPC'.static.GetNPCIconName(ClassID));
			SummonedFace.SetTextureSize(32, 32);
			GetTextureHandle(("SummonedWnd.SummonedSlotOutline" $ string((SlotIndex + 1)))).ShowWindow();
			GetBarHandle(("SummonedWnd.barHP_" $ string((SlotIndex + 1)))).ShowWindow();
			GetBarHandle(("SummonedWnd.barMP_" $ string((SlotIndex + 1)))).ShowWindow();
			summonedSlotArray[SlotIndex].ServerID = ServerID;
			Class'NWindow.ActionAPI'.static.RequestSummonedCommonActionList(ServerID);
			Class'NWindow.ActionAPI'.static.RequestSummonedAllSkillActionList();
		}
		if((SlotIndex == selectedSlotIndex))
		{
			setInformation(ServerID);
		}
		GetSummonPoint(usedSummonPoint, SummonablePoint);
		barSummonPoint.SetPoint(INT64((SummonablePoint - usedSummonPoint)), INT64(SummonablePoint));
		setSummonedSlotNone(isLock());
		GetBarHandle(("SummonedWnd.barHP_" $ string((SlotIndex + 1)))).SetValue(MaxHP, Hp);
		GetBarHandle(("SummonedWnd.barMP_" $ string((SlotIndex + 1)))).SetValue(maxMP, MP);
		GetButtonHandle(("SummonedWnd.btnBar_" $ string((SlotIndex + 1)))).SetTooltipCustomType(setHpMpToolTips(Level, Name, MaxHP, Hp, maxMP, MP));
	}
	return;
}

function setStatusBarHP(int SlotIndex, int CurHP, int ServerID)
{
	local SummonInfo Info;
	local string Name;
	local int Level, MaxHP, MP, maxMP;

	if(GetSummonInfo(ServerID, Info))
	{
		MaxHP = Info.nMaxHP;
		maxMP = Info.nMaxMP;
		MP = Info.nCurMP;
		Name = Info.Name;
		Level = Info.nLevel;
		GetBarHandle(("SummonedWnd.barHP_" $ string((SlotIndex + 1)))).SetValue(MaxHP, CurHP);
		GetBarHandle(("SummonedWnd.barMP_" $ string((SlotIndex + 1)))).SetValue(maxMP, MP);
		GetButtonHandle(("SummonedWnd.btnBar_" $ string((SlotIndex + 1)))).SetTooltipCustomType(setHpMpToolTips(Level, Name, MaxHP, CurHP, maxMP, MP));
	}
	return;
}

function setStatusBarMP(int SlotIndex, int curMP, int ServerID)
{
	local SummonInfo Info;
	local string Name;
	local int Level, MaxHP, Hp, maxMP;

	if(GetSummonInfo(ServerID, Info))
	{
		MaxHP = Info.nMaxHP;
		maxMP = Info.nMaxMP;
		Hp = Info.nCurHP;
		Name = Info.Name;
		Level = Info.nLevel;
		GetBarHandle(("SummonedWnd.barHP_" $ string((SlotIndex + 1)))).SetValue(MaxHP, Hp);
		GetBarHandle(("SummonedWnd.barMP_" $ string((SlotIndex + 1)))).SetValue(maxMP, curMP);
		GetButtonHandle(("SummonedWnd.btnBar_" $ string((SlotIndex + 1)))).SetTooltipCustomType(setHpMpToolTips(Level, Name, MaxHP, Hp, maxMP, curMP));
	}
	return;
}

function setbtnBarSelection(int ServerID)
{
	local ButtonHandle btnBAr;
	local string btnString_None, btnString_Over, btnString_Down;
	local int SlotIndex, i;

	btnString_None = "L2UI_ct1.Summoned.Summoned_DF_SelectBtn";
	btnString_Over = "L2UI_ct1.Summoned.Summoned_DF_SelectBtn_Over";
	btnString_Down = "L2UI_ct1.Summoned.Summoned_DF_SelectBtn_Down";
	selectedSlotIndex = -1;
	i = 1;
	while((i <= 4))
	{
		btnBAr = GetButtonHandle(("SummonedWnd.btnBar_" $ string(i)));
		btnBAr.SetTexture(btnString_None, btnString_Down, btnString_Over);
		i++;
	}
	if((ServerID > 0))
	{
		SlotIndex = GetIsSummonedSlotIndex(ServerID);
		btnBAr = GetButtonHandle(("SummonedWnd.btnBar_" $ string((SlotIndex + 1))));
		btnString_None = "L2UI_ct1.Summoned.Summoned_DF_SelectBtn_Down";
		btnBAr.SetTexture(btnString_None, btnString_Down, btnString_Over);
		selectedSlotIndex = SlotIndex;
	}
	return;
}

function int getNextSummonedSlotIndex(int SlotIndex)
{
	local int i;

	i = 0;
	while((i < 4))
	{
		SlotIndex++;
		if((SlotIndex == 4))
		{
			SlotIndex = 0;
		}
		if((summonedSlotArray[SlotIndex].ServerID != -1))
		{
			return SlotIndex;
		}
		i++;
	}
	return -1;
}

function int getSummonedSlotIndex()
{
	local int i;

	i = 0;
	while((i < 4))
	{
		if((summonedSlotArray[i].ServerID == -1))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function int GetIsSummonedSlotIndex(int ServerID)
{
	local int i;

	i = 0;
	while((i < 4))
	{
		if((summonedSlotArray[i].ServerID == ServerID))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function ClearActionWnd()
{
	SummonedActionWnd.Clear();
	SummonedActionWnd2.Clear();
	SummonedActionWnd3.Clear();
	SummonedActionWnd_Before.Clear();
	return;
}

function HandleActionSummonedList(string param)
{
	local UserInfo UserInfo;
	local int tmpID, tmp;
	local UIEventManager.EActionCategory Type;
	local string strActionName, strIconName, strDescription, strCommand;
	local ItemInfo infItem;
	local int usedSummonPoint, SummonablePoint;

	ParseItemID(param, infItem.Id);
	ParseInt(param, "Type", tmp);
	ParseString(param, "Name", strActionName);
	ParseString(param, "IconName", strIconName);
	ParseString(param, "Description", strDescription);
	ParseString(param, "Command", strCommand);
	infItem.Name = strActionName;
	infItem.IconName = strIconName;
	infItem.Description = strDescription;
	infItem.ShortcutType = 3;
	infItem.MacroCommand = strCommand;
	infItem.ReuseDelayShareGroupID = -1;
	GetPlayerInfo(UserInfo);
	GetSummonPoint(usedSummonPoint, SummonablePoint);
	if((usedSummonPoint > 0))
	{
		SummonedWnd_Action2.ShowWindow();
		SummonedWnd_Action1.HideWindow();
		bAwakeStateFlag = true;
	}
	else
	{
		SummonedWnd_Action1.ShowWindow();
		SummonedWnd_Action2.HideWindow();
		bAwakeStateFlag = false;
	}
	Type = EActionCategory(tmp);
	if((bAwakeStateFlag == false))
	{
		tmpID = SummonedActionWnd_Before.FindItem(infItem.Id);
		if((int(Type) == 6))
		{
			if((tmpID < 0))
			{
				SummonedActionWnd_Before.AddItem(infItem);
			}
		}
	}
	else if((int(Type) == 7))
	{
		tmpID = SummonedActionWnd.FindItem(infItem.Id);
		if((tmpID < 0))
		{
			SummonedActionWnd.AddItem(infItem);
		}
	}
	else if((int(Type) == 8))
	{
		tmpID = SummonedActionWnd2.FindItem(infItem.Id);
		if((tmpID < 0))
		{
			SummonedActionWnd2.AddItem(infItem);
		}
		if((currentSummonPolicy == -1))
		{
			if(SummonedActionWnd2.GetItem(0, infItem))
			{
				currentSummonPolicy = 0;
				SummonedActionWnd2.SetToggleEffect(currentSummonPolicy, true);
			}
		}
	}
	else if((int(Type) == 10))
	{
		tmpID = SummonedActionWnd3.FindItem(infItem.Id);
		if((tmpID < 0))
		{
			SummonedActionWnd3.AddItem(infItem);
		}
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "btnBar_1":
			setTargetSummon(0);
			break;
		case "btnBar_2":
			setTargetSummon(1);
			break;
		case "btnBar_3":
			setTargetSummon(2);
			break;
		case "btnBar_4":
			setTargetSummon(3);
			break;
		default:
			break;
	}
	return;
}

function setInformation(int ServerID)
{
	local string Name;
	local int Level, ClassID, PhysicalAttack, PhysicalDefense, HitRate, CriticalRate, PhysicalAttackSpeed, MagicalAttack, MagicDefense, PhysicalAvoid, MovingSpeed, MagicCastingSpeed, SoulShotCosume, SpiritShotConsume, MagicalHitRate, MagicalAvoid, MagicalCritical;
	local SummonInfo Info;

	if(GetSummonInfo(ServerID, Info))
	{
		Name = Info.Name;
		Level = Info.nLevel;
		ClassID = Info.nClassID;
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
		MovingSpeed = Info.nMovingSpeed;
		MagicCastingSpeed = Info.nMagicCastingSpeed;
		SoulShotCosume = Info.nSoulShotCosume;
		SpiritShotConsume = Info.nSpiritShotConsume;
		MagicalHitRate = Info.nMagicalHitRate;
		MagicalAvoid = Info.nMagicalAvoid;
		MagicalCritical = Info.nMagicalCritical;
		SummonedFace.SetTexture(Class'NWindow.UIDATA_NPC'.static.GetNPCIconName(ClassID));
		SummonedFace.SetTextureSize(32, 32);
		txtLvName.SetText(((string(Level) $ " ") $ Name));
		txtPhysicalAttack.SetText(string(PhysicalAttack));
		txtPhysicalDefense.SetText(string(PhysicalDefense));
		txtHitRate.SetText(string(HitRate));
		txtCriticalRate.SetText(string(CriticalRate));
		txtPhysicalAttackSpeed.SetText(string(PhysicalAttackSpeed));
		txtMagicalAttack.SetText(string(MagicalAttack));
		txtMagicDefense.SetText(string(MagicDefense));
		txtPhysicalAvoid.SetText(string(PhysicalAvoid));
		txtMovingSpeed.SetText(string(MovingSpeed));
		txtMagicCastingSpeed.SetText(string(MagicCastingSpeed));
		txtMagicHit.SetText(string(MagicalHitRate));
		txtMagicAvoid.SetText(string(MagicalAvoid));
		txtMagicCritical.SetText(string(MagicalCritical));
		txtSoulShotCosume1.SetText(string(SoulShotCosume));
		txtSoulShotCosume2.SetText(string(SpiritShotConsume));
	}
	else
	{
		SoulShotCosume = 0;
		SpiritShotConsume = 0;
		txtLvName.SetText("");
		txtPhysicalAttack.SetText("");
		txtPhysicalDefense.SetText("");
		txtHitRate.SetText("");
		txtCriticalRate.SetText("");
		txtPhysicalAttackSpeed.SetText("");
		txtMagicalAttack.SetText("");
		txtMagicDefense.SetText("");
		txtPhysicalAvoid.SetText("");
		txtMovingSpeed.SetText("");
		txtMagicCastingSpeed.SetText("");
		txtSoulShotCosume1.SetText(string(SoulShotCosume));
		txtSoulShotCosume2.SetText(string(SpiritShotConsume));
	}
	return;
}

function CheckAndHideInfoTab()
{
	local UserInfo UserInfo;

	GetPlayerInfo(UserInfo);
	if((((UserInfo.nSubClass == 176) || (UserInfo.nSubClass == 177)) || (UserInfo.nSubClass == 178)))
	{
		TabCtrl.SetDisable(0, true);
		TabCtrl.SetTopOrder(1, true);
	}
	else
	{
		TabCtrl.SetDisable(0, false);
	}
	return;
}

function CustomTooltip setHpMpToolTips(int Level, string Name, int MaxHP, int CurrentHP, int maxMP, int currentMP)
{
	local CustomTooltip m_Tooltip;

	m_Tooltip.DrawList.Length = 8;
	m_Tooltip.DrawList[0].t_bDrawOneLine = true;
	m_Tooltip.DrawList[0].eType = DIT_TEXT;
	m_Tooltip.DrawList[0].t_strText = "Lv ";
	m_Tooltip.DrawList[1].t_bDrawOneLine = true;
	m_Tooltip.DrawList[1].eType = DIT_TEXT;
	m_Tooltip.DrawList[1].t_color.R = 175;
	m_Tooltip.DrawList[1].t_color.G = 152;
	m_Tooltip.DrawList[1].t_color.B = 120;
	m_Tooltip.DrawList[1].t_color.A = 255;
	m_Tooltip.DrawList[1].t_strText = ((string(Level) $ " ") $ Name);
	m_Tooltip.DrawList[2].t_bDrawOneLine = true;
	m_Tooltip.DrawList[2].eType = DIT_TEXT;
	m_Tooltip.DrawList[2].bLineBreak = true;
	m_Tooltip.DrawList[2].t_strText = "HP: ";
	m_Tooltip.DrawList[3].t_bDrawOneLine = true;
	m_Tooltip.DrawList[3].eType = DIT_TEXT;
	m_Tooltip.DrawList[3].t_color.R = 175;
	m_Tooltip.DrawList[3].t_color.G = 152;
	m_Tooltip.DrawList[3].t_color.B = 120;
	m_Tooltip.DrawList[3].t_color.A = 255;
	m_Tooltip.DrawList[3].t_strText = string(CurrentHP);
	m_Tooltip.DrawList[4].t_bDrawOneLine = true;
	m_Tooltip.DrawList[4].eType = DIT_TEXT;
	m_Tooltip.DrawList[4].t_strText = ((" / " $ string(MaxHP)) $ "  ");
	m_Tooltip.DrawList[5].eType = DIT_TEXT;
	m_Tooltip.DrawList[5].bLineBreak = true;
	m_Tooltip.DrawList[5].t_strText = "MP: ";
	m_Tooltip.DrawList[6].t_bDrawOneLine = true;
	m_Tooltip.DrawList[6].eType = DIT_TEXT;
	m_Tooltip.DrawList[6].t_color.R = 175;
	m_Tooltip.DrawList[6].t_color.G = 152;
	m_Tooltip.DrawList[6].t_color.B = 120;
	m_Tooltip.DrawList[6].t_color.A = 255;
	m_Tooltip.DrawList[6].t_strText = string(currentMP);
	m_Tooltip.DrawList[7].t_bDrawOneLine = true;
	m_Tooltip.DrawList[7].eType = DIT_TEXT;
	m_Tooltip.DrawList[7].t_strText = (" / " $ string(maxMP));
	return m_Tooltip;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("SummonedWnd").HideWindow();
	return;
}
