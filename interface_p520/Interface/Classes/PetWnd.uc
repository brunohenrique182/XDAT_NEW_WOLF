class PetWnd extends UICommonAPI;

const PET_EQUIPPEDTEXTURE_NAME = "l2ui_ch3.PetWnd.petitem_click";
const DIALOG_PETNAME = 1111;
const DIALOG_GIVEITEMTOPET = 2222;
const NPET_SMALLBARSIZE = 85;
const NPET_LARGEBARSIZE = 206;
const NPET_BARHEIGHT = 12;
const PET_EVOLUTIONIZED_ID = 1210114602;

var string m_Windowname;
var int m_PetID;
var bool m_bShowNameBtn;
var string m_LastInputPetName;
var int EvolutionizedAction;
var WindowHandle Me;
var StatusBarHandle texPetHP;
var StatusBarHandle texPetMP;
var StatusBarHandle texPetExp;
var StatusBarHandle texPetFatigue;
var ButtonHandle btnName;
var TextBoxHandle txtPetSP;
var TextBoxHandle txtLvName;
var TextBoxHandle txtPhysicalAttack;
var TextBoxHandle txtPhysicalDefense;
var TextBoxHandle txtHitRate;
var TextBoxHandle txtCriticalRate;
var TextBoxHandle txtPhysicalAttackSpeed;
var TextBoxHandle txtSoulShotCosume;
var TextBoxHandle txtMagicalAttack;
var TextBoxHandle txtMagicDefense;
var TextBoxHandle txtPhysicalAvoid;
var TextBoxHandle txtMovingSpeed;
var TextBoxHandle txtMagicCastingSpeed;
var TextBoxHandle txtSpiritShotConsume;
var TextBoxHandle txtMagicHit;
var TextBoxHandle txtMagicAvoid;
var TextBoxHandle txtMagicCritical;
var ItemWindowHandle PetActionWnd;
var ItemWindowHandle PetInvenWnd;

function OnRegisterEvent()
{
	RegisterEvent(1710);
	RegisterEvent(250);
	RegisterEvent(1010);
	RegisterEvent(1020);
	RegisterEvent(1030);
	RegisterEvent(1130);
	RegisterEvent(1311);
	RegisterEvent(1320);
	RegisterEvent(1330);
	RegisterEvent(1060);
	RegisterEvent(1070);
	RegisterEvent(1080);
	RegisterEvent(1900);
	RegisterEvent(190);
	RegisterEvent(210);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	if((1 == 0))
	{
		InitHandle();
	}
	else
	{
		InitHandleCOD();
	}
	m_bShowNameBtn = true;
	EvolutionizedAction = 0;
	return;
}

function InitHandle()
{
	Me = GetHandle("PetWnd");
	btnName = ButtonHandle(GetHandle("PetWnd.btnName"));
	texPetHP = StatusBarHandle(GetHandle("PetWnd.texPetHP"));
	texPetMP = StatusBarHandle(GetHandle("PetWnd.texPetMP"));
	texPetExp = StatusBarHandle(GetHandle("PetWnd.texPetExp"));
	texPetFatigue = StatusBarHandle(GetHandle("PetWnd.texPetFatigue"));
	txtPetSP = TextBoxHandle(GetHandle("PetWnd.txtPetSP"));
	txtLvName = TextBoxHandle(GetHandle("PetWnd.txtLvName"));
	txtPhysicalAttack = TextBoxHandle(GetHandle("PetWnd.PetWnd_Status.txtPhysicalAttack"));
	txtPhysicalDefense = TextBoxHandle(GetHandle("PetWnd.PetWnd_Status.txtPhysicalDefense"));
	txtHitRate = TextBoxHandle(GetHandle("PetWnd.PetWnd_Status.txtHitRate"));
	txtCriticalRate = TextBoxHandle(GetHandle("PetWnd.PetWnd_Status.txtCriticalRate"));
	txtPhysicalAttackSpeed = TextBoxHandle(GetHandle("PetWnd.PetWnd_Status.txtPhysicalAttackSpeed"));
	txtSoulShotCosume = TextBoxHandle(GetHandle("PetWnd.PetWnd_Status.txtSoulShotCosume"));
	txtMagicalAttack = TextBoxHandle(GetHandle("PetWnd.PetWnd_Status.txtMagicalAttack"));
	txtMagicDefense = TextBoxHandle(GetHandle("PetWnd.PetWnd_Status.txtMagicDefense"));
	txtPhysicalAvoid = TextBoxHandle(GetHandle("PetWnd.PetWnd_Status.txtPhysicalAvoid"));
	txtMovingSpeed = TextBoxHandle(GetHandle("PetWnd.PetWnd_Status.txtMovingSpeed"));
	txtMagicCastingSpeed = TextBoxHandle(GetHandle("PetWnd.PetWnd_Status.txtMagicCastingSpeed"));
	txtSpiritShotConsume = TextBoxHandle(GetHandle("PetWnd.PetWnd_Status.txtSpiritShotConsume"));
	txtMagicHit = TextBoxHandle(GetHandle("PetWnd.PetWnd_Status.txtMagicHit"));
	txtMagicAvoid = TextBoxHandle(GetHandle("PetWnd.PetWnd_Status.txtPhysicalAvoid"));
	txtMagicCritical = TextBoxHandle(GetHandle("PetWnd.PetWnd_Status.txtMagicCritical"));
	PetActionWnd = ItemWindowHandle(GetHandle("PetWnd.PetWnd_Action.PetActionWnd"));
	PetInvenWnd = ItemWindowHandle(GetHandle("PetWnd.PetWnd_Inventory.PetInvenWnd"));
	return;
}

function InitHandleCOD()
{
	Me = GetWindowHandle("PetWnd");
	btnName = GetButtonHandle("PetWnd.btnName");
	texPetHP = GetStatusBarHandle("PetWnd.texPetHP");
	texPetMP = GetStatusBarHandle("PetWnd.texPetMP");
	texPetExp = GetStatusBarHandle("PetWnd.texPetExp");
	texPetFatigue = GetStatusBarHandle("PetWnd.texPetFatigue");
	txtPetSP = GetTextBoxHandle("PetWnd.txtPetSP");
	txtLvName = GetTextBoxHandle("PetWnd.txtLvName");
	txtPhysicalAttack = GetTextBoxHandle("PetWnd.PetWnd_Status.txtPhysicalAttack");
	txtPhysicalDefense = GetTextBoxHandle("PetWnd.PetWnd_Status.txtPhysicalDefense");
	txtHitRate = GetTextBoxHandle("PetWnd.PetWnd_Status.txtHitRate");
	txtCriticalRate = GetTextBoxHandle("PetWnd.PetWnd_Status.txtCriticalRate");
	txtPhysicalAttackSpeed = GetTextBoxHandle("PetWnd.PetWnd_Status.txtPhysicalAttackSpeed");
	txtSoulShotCosume = GetTextBoxHandle("PetWnd.PetWnd_Status.txtSoulShotCosume");
	txtMagicalAttack = GetTextBoxHandle("PetWnd.PetWnd_Status.txtMagicalAttack");
	txtMagicDefense = GetTextBoxHandle("PetWnd.PetWnd_Status.txtMagicDefense");
	txtPhysicalAvoid = GetTextBoxHandle("PetWnd.PetWnd_Status.txtPhysicalAvoid");
	txtMovingSpeed = GetTextBoxHandle("PetWnd.PetWnd_Status.txtMovingSpeed");
	txtMagicCastingSpeed = GetTextBoxHandle("PetWnd.PetWnd_Status.txtMagicCastingSpeed");
	txtSpiritShotConsume = GetTextBoxHandle("PetWnd.PetWnd_Status.txtSpiritShotConsume");
	txtMagicHit = GetTextBoxHandle("PetWnd.PetWnd_Status.txtMagicHit");
	txtMagicAvoid = GetTextBoxHandle("PetWnd.PetWnd_Status.txtMagicAvoid");
	txtMagicCritical = GetTextBoxHandle("PetWnd.PetWnd_Status.txtMagicCritical");
	PetActionWnd = GetItemWindowHandle("PetWnd.PetWnd_Action.PetActionWnd");
	PetInvenWnd = GetItemWindowHandle("PetWnd.PetWnd_Inventory.PetInvenWnd");
	return;
}

function OnShow()
{
	Class'NWindow.PetAPI'.static.RequestPetInventoryItemList();
	Class'NWindow.ActionAPI'.static.RequestPetActionList();
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("RefineryWnd");
	return;
}

function OnDropItem(string strTarget, ItemInfo Info, int X, int Y)
{
	local InventoryWnd Script;

	Script = InventoryWnd(GetScript("InventoryWnd"));
	if(((strTarget == "PetInvenWnd") && (Script.getInventoryItemWndName(Info.DragSrcName) == true)))
	{
		if((IsStackableItem(Info.ConsumeType) && (Info.ItemNum > INT64(1))))
		{
			if((Info.AllItemCount > INT64(0)))
			{
				Class'NWindow.PetAPI'.static.RequestGiveItemToPet(Info.Id, Info.AllItemCount);
			}
			else
			{
				DialogSetID(2222);
				DialogSetReservedItemID(Info.Id);
				DialogSetParamInt64(Info.ItemNum);
				DialogSetDefaultOK();
				DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), Info.Name));
			}
		}
		else
		{
			Class'NWindow.PetAPI'.static.RequestGiveItemToPet(Info.Id, INT64(1));
		}
	}
	return;
}

function HandleLanguageChanged()
{
	Class'NWindow.PetAPI'.static.RequestPetInventoryItemList();
	Class'NWindow.ActionAPI'.static.RequestPetActionList();
	return;
}

function OnHide()
{
	if(DialogIsMine())
	{
		DialogHide();
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	if(!getInstanceUIData().GetIsLiveServer())
	{
		return;
	}
	if((Event_ID == 250))
	{
		HandlePetInfoUpdate();
	}
	else if((Event_ID == 190))
	{
		UpdatePetHP(param);
	}
	else if((Event_ID == 210))
	{
		UpdatePetMP(param);
	}
	else if((Event_ID == 1130))
	{
		HandlePetStatusClose();
	}
	else if((Event_ID == 1010))
	{
		HandlePetInfoUpdate();
		HandlePetShow();
	}
	else if((Event_ID == 1020))
	{
		HandlePetShowNameBtn(param);
	}
	else if((Event_ID == 1030))
	{
		HandleRegPetName(param);
	}
	else if((Event_ID == 1710))
	{
		HandleDialogOK();
	}
	else if((Event_ID == 1320))
	{
		HandleActionPetListStart();
	}
	else if((Event_ID == 1330))
	{
		HandleActionPetList(param);
	}
	else if((Event_ID == 1060))
	{
		HandlePetInventoryItemStart();
	}
	else if((Event_ID == 1070))
	{
		HandlePetInventoryItemList(param);
	}
	else if((Event_ID == 1080))
	{
		HandlePetInventoryItemUpdate(param);
	}
	else if((Event_ID == 1900))
	{
		HandleLanguageChanged();
	}
	else if((Event_ID == 1311))
	{
		Class'NWindow.ActionAPI'.static.RequestPetActionList();
	}
	return;
}

function HandleDialogOK()
{
	local int Id;
	local ItemID sID;
	local INT64 Number;

	if(DialogIsMine())
	{
		Id = DialogGetID();
		sID = DialogGetReservedItemID();
		Number = INT64(DialogGetString());
		if((Id == 1111))
		{
			m_LastInputPetName = DialogGetString();
			RequestChangePetName(m_LastInputPetName);
		}
		else if((Id == 2222))
		{
			Class'NWindow.PetAPI'.static.RequestGiveItemToPet(sID, Number);
		}
	}
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnName":
			OnNameClick();
			break;
		default:
			break;
	}
	return;
}

function OnNameClick()
{
	DialogSetID(1111);
	DialogSetDefaultOK();
	DialogShow(DialogModalType_Modalless, DialogType_OKCancelInput, GetSystemMessage(535));
	return;
}

function OnClickItem(string strID, int Index)
{
	local ItemInfo infItem;

	if(((strID == "PetActionWnd") && (Index > -1)))
	{
		if(PetActionWnd.GetItem(Index, infItem))
		{
			DoAction(infItem.Id);
		}
	}
	return;
}

function OnDBClickItem(string strID, int Index)
{
	local ItemInfo infItem;

	if(((strID == "PetInvenWnd") && (Index > -1)))
	{
		if(PetInvenWnd.GetItem(Index, infItem))
		{
			Class'NWindow.PetAPI'.static.RequestPetUseItem(infItem.Id);
		}
	}
	return;
}

function OnRClickItem(string strID, int Index)
{
	local ItemInfo infItem;

	if(((strID == "PetInvenWnd") && (Index > -1)))
	{
		if(PetInvenWnd.GetItem(Index, infItem))
		{
			Class'NWindow.PetAPI'.static.RequestPetUseItem(infItem.Id);
		}
	}
	return;
}

function Clear()
{
	txtLvName.SetText("");
	txtPetSP.SetText("0");
	texPetHP.SetPoint(INT64(0), INT64(0));
	texPetMP.SetPoint(INT64(0), INT64(0));
	texPetExp.SetPointPercent(INT64(0), INT64(0), INT64(0));
	texPetFatigue.SetPointPercent(INT64(0), INT64(0), INT64(0));
	return;
}

function ClearActionWnd()
{
	PetActionWnd.Clear();
	return;
}

function ClearInvenWnd()
{
	PetInvenWnd.Clear();
	return;
}

function HandleRegPetName(string param)
{
	local int MsgNo;

	ParseInt(param, "ErrMsgNo", MsgNo);
	AddSystemMessage(MsgNo);
	DialogSetDefaultOK();
	DialogShow(DialogModalType_Modalless, DialogType_OKCancelInput, GetSystemMessage(535));
	if((MsgNo == 80))
	{
		DialogSetString(m_LastInputPetName);
	}
	return;
}

function HandlePetShowNameBtn(string param)
{
	local int ShowFlag;

	ParseInt(param, "Show", ShowFlag);
	if((ShowFlag == 1))
	{
		SetVisibleNameBtn(true);
	}
	else
	{
		SetVisibleNameBtn(false);
	}
	return;
}

function SetVisibleNameBtn(bool bShow)
{
	if(bShow)
	{
		btnName.ShowWindow();
	}
	else
	{
		btnName.HideWindow();
	}
	m_bShowNameBtn = bShow;
	return;
}

function HandlePetStatusClose()
{
	Me.HideWindow();
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	return;
}

function UpdatePetMP(string param)
{
	local int ServerID, currentMP, MP, maxMP;
	local PetInfo Info;

	ParseInt(param, "ServerID", ServerID);
	ParseInt(param, "CurrentMP", currentMP);
	if(GetPetInfo(Info))
	{
		if((ServerID == Info.nServerID))
		{
			MP = currentMP;
			maxMP = Info.nMaxMP;
			texPetMP.SetPoint(INT64(MP), INT64(maxMP));
		}
	}
	return;
}

function UpdatePetHP(string param)
{
	local int ServerID, CurrentHP, Hp, MaxHP;
	local PetInfo Info;

	ParseInt(param, "ServerID", ServerID);
	ParseInt(param, "CurrentHP", CurrentHP);
	if(GetPetInfo(Info))
	{
		if((ServerID == Info.nServerID))
		{
			Hp = CurrentHP;
			MaxHP = Info.nMaxHP;
			texPetHP.SetPoint(INT64(Hp), INT64(MaxHP));
		}
	}
	return;
}

function HandlePetInfoUpdate()
{
	local string Name;
	local int Hp, MaxHP, MP, maxMP, Fatigue, MaxFatigue;
	local INT64 Sp;
	local int Level, PhysicalAttack, PhysicalDefense, HitRate, CriticalRate, PhysicalAttackSpeed, MagicalAttack, MagicDefense, PhysicalAvoid, MovingSpeed, MagicCastingSpeed, SoulShotCosume, SpiritShotConsume, nEvolutionID, MagicalHitRate, MagicalAvoid, MagicalCritical;
	local INT64 nCurExp, nMinExp, nMaxExp;
	local PetInfo Info;

	if(!Me.IsShowWindow())
	{
		return;
	}
	if(GetPetInfo(Info))
	{
		if((Info.PetOrSummoned != 2))
		{
			return;
		}
		m_PetID = Info.nServerID;
		Name = Info.Name;
		Sp = Info.nSP;
		Level = Info.nLevel;
		Hp = Info.nCurHP;
		MaxHP = Info.nMaxHP;
		MP = Info.nCurMP;
		maxMP = Info.nMaxMP;
		Fatigue = Info.nFatigue;
		MaxFatigue = Info.nMaxFatigue;
		nCurExp = Info.nCurExp;
		nMinExp = Info.nMinExp;
		nMaxExp = Info.nMaxExp;
		nEvolutionID = Info.nEvolutionID;
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
	}
	txtLvName.SetText(((string(Level) $ " ") $ Name));
	txtPetSP.SetText(string(Sp));
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
	txtSoulShotCosume.SetText(string(SoulShotCosume));
	txtSpiritShotConsume.SetText(string(SpiritShotConsume));
	txtMagicHit.SetText(string(MagicalHitRate));
	txtMagicAvoid.SetText(string(MagicalAvoid));
	txtMagicCritical.SetText(string(MagicalCritical));
	texPetHP.SetPoint(INT64(Hp), INT64(MaxHP));
	texPetMP.SetPoint(INT64(MP), INT64(maxMP));
	texPetExp.SetPointPercent(nCurExp, nMinExp, nMaxExp);
	texPetFatigue.SetPointPercent(INT64(Fatigue), INT64(0), INT64(MaxFatigue));
	EvolutionizedAction = nEvolutionID;
	return;
}

function HandlePetShow()
{
	Clear();
	PlayConsoleSound(IFST_WINDOW_OPEN);
	Me.ShowWindow();
	Me.SetFocus();
	HandlePetInfoUpdate();
	SetVisibleNameBtn(m_bShowNameBtn);
	return;
}

function HandleActionPetListStart()
{
	HandlePetInfoUpdate();
	ClearActionWnd();
	return;
}

function HandleActionPetList(string param)
{
	local int tmp;
	local UIEventManager.EActionCategory Type;
	local string strActionName, strIconName, strDescription, strCommand;
	local int intClassID;
	local ItemInfo infItem;

	ParseItemID(param, infItem.Id);
	ParseInt(param, "Type", tmp);
	ParseString(param, "Name", strActionName);
	ParseString(param, "IconName", strIconName);
	ParseString(param, "Description", strDescription);
	ParseString(param, "Command", strCommand);
	ParseInt(param, "ClassID", intClassID);
	infItem.Name = strActionName;
	infItem.IconName = strIconName;
	infItem.Description = strDescription;
	infItem.ShortcutType = 3;
	infItem.MacroCommand = strCommand;
	Type = EActionCategory(tmp);
	if((int(Type) == 5))
	{
		switch(EvolutionizedAction)
		{
			case 2:
				if((intClassID == 1044))
				{
				}
				else
				{
					PetActionWnd.AddItem(infItem);
				}
				break;
			case 1:
				if(((intClassID == 1042) || (intClassID == 1044)))
				{
				}
				else
				{
					PetActionWnd.AddItem(infItem);
				}
				break;
			case 0:
				if((((((intClassID == 1042) || (intClassID == 1043)) || (intClassID == 1044)) || (intClassID == 1045)) || (intClassID == 1046)))
				{
				}
				else
				{
					PetActionWnd.AddItem(infItem);
				}
				break;
			case 3:
				PetActionWnd.AddItem(infItem);
				break;
			default:
				break;
		}
	}
	return;
}

function HandlePetInventoryItemStart()
{
	ClearInvenWnd();
	return;
}

function HandlePetInventoryItemList(string param)
{
	local ItemInfo infItem;

	ParamToItemInfo(param, infItem);
	if(infItem.bEquipped)
	{
		infItem.ForeTexture = "l2ui_ch3.PetWnd.petitem_click";
	}
	PetInvenWnd.AddItem(infItem);
	return;
}

function HandlePetInventoryItemUpdate(string param)
{
	local ItemInfo infItem;
	local int tmp, Index;
	local UIEventManager.EInventoryUpdateType WorkType;

	ParamToItemInfo(param, infItem);
	ParseInt(param, "WorkType", tmp);
	WorkType = EInventoryUpdateType(tmp);
	if(!IsValidItemID(infItem.Id))
	{
		return;
	}
	if(infItem.bEquipped)
	{
		infItem.ForeTexture = "l2ui_ch3.PetWnd.petitem_click";
	}
	switch(WorkType)
	{
		case IVUT_ADD:
			PetInvenWnd.AddItem(infItem);
			break;
		case IVUT_UPDATE:
			Index = PetInvenWnd.FindItem(infItem.Id);
			if((Index < 0))
			{
				return;
			}
			PetInvenWnd.SetItem(Index, infItem);
			break;
		case IVUT_DELETE:
			Index = PetInvenWnd.FindItem(infItem.Id);
			if((Index < 0))
			{
				return;
			}
			PetInvenWnd.DeleteItem(Index);
			break;
		default:
			break;
	}
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="PetWnd"
}
