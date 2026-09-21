class SummonedWndClassic extends UICommonAPI;

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
var StatusBarHandle barHP;
var StatusBarHandle barMP;
var TabHandle TabCtrl;
var TextureHandle TabLineTop;
var TextureHandle tabBg1;
var L2Util util;
var int summonServerID;
var bool bAwakeStateFlag;
var int selectedSlotIndex;
var int summonedServerID;
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
			if((summonedServerID != ServerID))
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
			if((summonedServerID != ServerID))
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
	SetClosingOnESC();
	util = L2Util(GetScript("L2Util"));
	Initialize();
	currentSummonPolicy = -1;
	txtHeadSoulShotCosume1.SetText(GetSystemString(404));
	txtHeadSoulShotCosume2.SetText(GetSystemString(496));
	return;
}

function Initialize()
{
	Me = GetWindowHandle("SummonedWndClassic");
	SummonedWnd_Status = GetWindowHandle("SummonedWndClassic.SummonedWnd_Status");
	txtLvHead = GetTextBoxHandle("SummonedWndClassic.txtLvHead");
	txtLvName = GetTextBoxHandle("SummonedWndClassic.txtLvName");
	txtHeadFight = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtHeadFight");
	txtHeadPhysicalAttack = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtHeadPhysicalAttack");
	txtHeadPhysicalDefense = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtHeadPhysicalDefense");
	txtHeadHitRate = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtHeadHitRate");
	txtHeadPhysicalAvoid = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtHeadPhysicalAvoid");
	txtHeadCriticalRate = GetTextBoxHandle("SummonedWndClassic.1.txtHeadCriticalRate");
	txtHeadPhysicalAttackSpeed = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtHeadPhysicalAttackSpeed");
	txtHeadMovingSpeed = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtHeadMovingSpeed");
	txtHeadSoulShot = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtHeadSoulShot");
	txtHeadMagicalAttack = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtHeadMagicalAttack");
	txtHeadMagicDefense = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtHeadMagicDefense");
	txtHeadMagicHit = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtHeadMagicHit");
	txtHeadMagicAvoid = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtHeadMagicAvoid");
	txtHeadMagicCritical = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtHeadMagicCritical");
	txtHeadMagicCastingSpeed = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtHeadMagicCastingSpeed");
	txtHeadSoulShotCosume1 = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtHeadSoulShotCosume1");
	txtHeadSoulShotCosume2 = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtHeadSoulShotCosume2");
	txtPhysicalAttack = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtPhysicalAttack");
	txtPhysicalDefense = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtPhysicalDefense");
	txtHitRate = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtHitRate");
	txtPhysicalAvoid = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtPhysicalAvoid");
	txtCriticalRate = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtCriticalRate");
	txtPhysicalAttackSpeed = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtPhysicalAttackSpeed");
	txtMovingSpeed = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtMovingSpeed");
	txtMagicalAttack = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtMagicalAttack");
	txtMagicDefense = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtMagicDefense");
	txtMagicHit = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtMagicHit");
	txtMagicAvoid = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtMagicAvoid");
	txtMagicCritical = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtMagicCritical");
	txtMagicCastingSpeed = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtMagicCastingSpeed");
	txtSoulShotCosume1 = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtSoulShotCosume1");
	txtSoulShotCosume2 = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtSoulShotCosume2");
	BackTex1 = GetTextureHandle("SummonedWndClassic.SummonedWnd_Status.BackTex1");
	BackTex2 = GetTextureHandle("SummonedWndClassic.SummonedWnd_Status.BackTex2");
	BackTex3 = GetTextureHandle("SummonedWndClassic.SummonedWnd_Status.BackTex3");
	DividerLine = GetTextureHandle("SummonedWndClassic.SummonedWnd_Status.DividerLine");
	DividerLine2 = GetTextureHandle("SummonedWndClassic.SummonedWnd_Status.DividerLine2");
	SummonedFace = GetTextureHandle("SummonedWndClassic.SummonedFace");
	SummonedSlotOutline = GetTextureHandle("SummonedWndClassic.SummonedWnd_Status.SummonedSlotOutline");
	SummonedWnd_Action = GetWindowHandle("SummonedWndClassic.SummonedWnd_Action");
	SummonedWnd_Action1 = GetWindowHandle("SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action1");
	BackTexAction1_Before = GetTextureHandle("SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action1.BackTexAction1_Before");
	SummonedWnd_Action2 = GetWindowHandle("SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action2");
	txtHeadDirect = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action2.txtHeadDirect");
	txtHeadPolicy = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action2.txtHeadPolicy");
	txtHeadSkill = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action2.txtHeadSkill");
	SummonedActionWnd_Before = GetItemWindowHandle("SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action1.SummonedActionWnd_Before");
	SummonedActionWnd = GetItemWindowHandle("SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action2.SummonedActionWnd");
	SummonedActionWnd2 = GetItemWindowHandle("SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action2.SummonedActionWnd2");
	SummonedActionWnd3 = GetItemWindowHandle("SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action2.SummonedActionWnd3");
	BackTexAction1 = GetTextureHandle("SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action2.BackTexAction1");
	BackTexAction2 = GetTextureHandle("SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action2.BackTexAction2");
	BackTexAction3 = GetTextureHandle("SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action2.BackTexAction3");
	barHP = GetStatusBarHandle("SummonedWndClassic.barHP");
	barMP = GetStatusBarHandle("SummonedWndClassic.barMP");
	TabCtrl = GetTabHandle("SummonedWndClassic.TabCtrl");
	TabLineTop = GetTextureHandle("SummonedWndClassic.TabLineTop");
	tabBg1 = GetTextureHandle("SummonedWndClassic.tabBg1");
	bAwakeStateFlag = false;
	initSlot();
	return;
}

function initSlot()
{
	barHP.SetPoint(INT64(0), INT64(0));
	barMP.SetPoint(INT64(0), INT64(0));
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
	summonedServerID = -1;
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
	if((summonedServerID == ServerID))
	{
		setInformation(ServerID);
	}
	return;
}

function setTargetSummon()
{
	local UserInfo UserInfo;

	if((summonedServerID != -1))
	{
		if(GetPlayerInfo(UserInfo))
		{
			RequestAction(summonedServerID, UserInfo.Loc);
		}
	}
	return;
}

function HandleSummonedStatusClose()
{
	local int usedSummonPoint, SummonablePoint;

	PlayConsoleSound(IFST_WINDOW_CLOSE);
	Me.HideWindow();
	deleteSlot();
	GetSummonPoint(usedSummonPoint, SummonablePoint);
	ClearActionWnd();
	setInformation(-1);
	currentSummonPolicy = -1;
	return;
}

function HandleSummonShow()
{
	PlayConsoleSound(IFST_WINDOW_OPEN);
	if(getInstanceUIData().GetIsClassicServer())
	{
		Me.ShowWindow();
		Me.SetFocus();
	}
	return;
}

function HandleSummonedDelete(string param)
{
	local int ServerID;

	ParseInt(param, "serverID", ServerID);
	if(bAwakeStateFlag)
	{
		if((summonedServerID == ServerID))
		{
			SummonedActionWnd3.Clear();
			deleteSlot();
		}
	}
	return;
}

function deleteSlot()
{
	summonedServerID = -1;
	return;
}

function HandleSummonInfoUpdate(int ServerID)
{
	local int Hp, MaxHP, MP, maxMP, ClassID;
	local string Name;
	local int Level;
	local SummonInfo Info;

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
		summonedServerID = ServerID;
		SummonedFace.SetTexture(Class'NWindow.UIDATA_NPC'.static.GetNPCIconName(ClassID));
		SummonedFace.SetTextureSize(32, 32);
		summonedServerID = ServerID;
		Class'NWindow.ActionAPI'.static.RequestSummonedCommonActionList(ServerID);
		Class'NWindow.ActionAPI'.static.RequestSummonedAllSkillActionList();
		setInformation(ServerID);
		barHP.SetPoint(INT64(Hp), INT64(MaxHP));
		barMP.SetPoint(INT64(MP), INT64(maxMP));
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
		barHP.SetPoint(INT64(CurHP), INT64(MaxHP));
		barMP.SetPoint(INT64(MP), INT64(maxMP));
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
		barHP.SetPoint(INT64(Hp), INT64(MaxHP));
		barMP.SetPoint(INT64(curMP), INT64(maxMP));
	}
	return;
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
		case "btnBar":
			setTargetSummon();
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
	GetWindowHandle("SummonedWndClassic").HideWindow();
	return;
}
