class PetWndClassic extends UICommonAPI
	dependson(UIPacket);

const MAX_PET_INVEN_NUM = 17;
const DIALOG_EVOLVE = 1113;
const EFFECT_SLOT_NAME_SUFFIX = "_effect";

var WindowHandle Me;
var WindowHandle PetClassicInfoWnd;
var WindowHandle PetWnd_Status;
var WindowHandle skillNumWnd;
var WindowHandle dialogContainer;
var TextBoxHandle txtLvName;
var TextBoxHandle txtRandomStatName;
var TextBoxHandle txtRandomName;
var TextBoxHandle txtPetExp;
var TextBoxHandle txtPetMP;
var TextBoxHandle txtPetHP;
var TextBoxHandle txtEvolveStep;
var TextBoxHandle txtSkillNum;
var ButtonHandle Evolve_BTN;
var ButtonHandle EvolveTooltip_BTN;
var ButtonHandle RandomNameTooltip_BTN;
var ButtonHandle equipSlotBonusBtn;
var StatusBarHandle texPetHP;
var StatusBarHandle texPetMP;
var StatusBarHandle texPetExp;
var StatusBarHandle texPetFatigue;
var TextureHandle portraitIconTex;
var WindowHandle PetWnd_Inventory;
var ItemWindowHandle PetEquipItem_Head;
var ItemWindowHandle PetEquipItem_Chest;
var ItemWindowHandle PetEquipItem_Legs;
var ItemWindowHandle PetEquipItem_RHand;
var ItemWindowHandle PetEquipItem_Gloves;
var ItemWindowHandle PetEquipItem_Feet;
var ItemWindowHandle PetEquipItem_LFinger;
var ItemWindowHandle PetEquipItem_RFinger;
var ItemWindowHandle PetEquipItem_LEar;
var ItemWindowHandle PetEquipItem_REar;
var ItemWindowHandle PetEquipItem_Neck;
var ItemWindowHandle PetEquipItem_Underwear;
var ItemWindowHandle PetEquipItem_LHand;
var ItemWindowHandle PetEquipItem_Hair;
var ItemWindowHandle PetEquipItem_Hair2;
var ItemWindowHandle PetEquipItem_Waist;
var ItemWindowHandle PetEquipItem_Cloak;
var CharacterViewportWindowHandle viewportWnd;
var EffectViewportWndHandle effectViewportWnd;
var EffectViewportWndHandle evolveEffectViewportWnd;
var UIControlDialogAssets evolveDialogAsset;
var string m_Windowname;
var int m_PetID;
var bool m_bShowNameBtn;
var string m_LastInputPetName;
var int EvolutionizedAction;
var int nEvolvePetID;
var int nPetLevel;
var int nEvolutionStep;
var InventoryWnd inventoryWndScript;
var bool _requestPetEvolve;
var bool _needUpdateBackEquipViewport;

function Initialize()
{
	Me = GetWindowHandle("PetWndClassic");
	PetClassicInfoWnd = GetWindowHandle("PetWndClassic.PetClassicInfoWnd");
	txtLvName = GetTextBoxHandle("PetWndClassic.PetClassicInfoWnd.txtLvName");
	txtRandomName = GetTextBoxHandle("PetWndClassic.PetClassicInfoWnd.txtrandomName");
	txtRandomStatName = GetTextBoxHandle("PetWndClassic.PetClassicInfoWnd.txtrandomStatName");
	txtPetExp = GetTextBoxHandle("PetWndClassic.PetClassicInfoWnd.txtPetExp");
	txtPetMP = GetTextBoxHandle("PetWndClassic.PetClassicInfoWnd.txtPetMP");
	txtPetHP = GetTextBoxHandle("PetWndClassic.PetClassicInfoWnd.txtPetHP");
	Evolve_BTN = GetButtonHandle("PetWndClassic.PetClassicInfoWnd.Evolve_BTN");
	texPetHP = GetStatusBarHandle("PetWndClassic.PetClassicInfoWnd.texPetHP");
	texPetMP = GetStatusBarHandle("PetWndClassic.PetClassicInfoWnd.texPetMP");
	texPetExp = GetStatusBarHandle("PetWndClassic.PetClassicInfoWnd.texPetExp");
	texPetFatigue = GetStatusBarHandle("PetWndClassic.PetClassicInfoWnd.texPetFatigue");
	PetWnd_Status = GetWindowHandle("PetWndClassic.PetWnd_Status");
	PetWnd_Inventory = GetWindowHandle("PetWndClassic.PetWnd_Inventory");
	PetEquipItem_Head = GetItemWindowHandle("PetWndClassic.PetWnd_Inventory.PetEquipItem_Head");
	PetEquipItem_Chest = GetItemWindowHandle("PetWndClassic.PetWnd_Inventory.PetEquipItem_Chest");
	PetEquipItem_Legs = GetItemWindowHandle("PetWndClassic.PetWnd_Inventory.PetEquipItem_Legs");
	PetEquipItem_RHand = GetItemWindowHandle("PetWndClassic.PetWnd_Inventory.PetEquipItem_RHand");
	PetEquipItem_Gloves = GetItemWindowHandle("PetWndClassic.PetWnd_Inventory.PetEquipItem_Gloves");
	PetEquipItem_Feet = GetItemWindowHandle("PetWndClassic.PetWnd_Inventory.PetEquipItem_Feet");
	PetEquipItem_LFinger = GetItemWindowHandle("PetWndClassic.PetWnd_Inventory.PetEquipItem_LFinger");
	PetEquipItem_RFinger = GetItemWindowHandle("PetWndClassic.PetWnd_Inventory.PetEquipItem_RFinger");
	PetEquipItem_LEar = GetItemWindowHandle("PetWndClassic.PetWnd_Inventory.PetEquipItem_LEar");
	PetEquipItem_REar = GetItemWindowHandle("PetWndClassic.PetWnd_Inventory.PetEquipItem_REar");
	PetEquipItem_Neck = GetItemWindowHandle("PetWndClassic.PetWnd_Inventory.PetEquipItem_Neck");
	PetEquipItem_Underwear = GetItemWindowHandle("PetWndClassic.PetWnd_Inventory.PetEquipItem_Underwear");
	PetEquipItem_LHand = GetItemWindowHandle("PetWndClassic.PetWnd_Inventory.PetEquipItem_LHand");
	PetEquipItem_Hair = GetItemWindowHandle("PetWndClassic.PetWnd_Inventory.PetEquipItem_Hair");
	PetEquipItem_Hair2 = GetItemWindowHandle("PetWndClassic.PetWnd_Inventory.PetEquipItem_Hair2");
	PetEquipItem_Waist = GetItemWindowHandle("PetWndClassic.PetWnd_Inventory.PetEquipItem_Waist");
	PetEquipItem_Cloak = GetItemWindowHandle("PetWndClassic.PetWnd_Inventory.PetEquipItem_Cloak");
	PetEquipItem_Head.SetTooltipText(GetSystemString(230));
	PetEquipItem_Chest.SetTooltipText(GetSystemString(38));
	PetEquipItem_Legs.SetTooltipText(GetSystemString(39));
	PetEquipItem_RHand.SetTooltipText(GetSystemString(2520));
	PetEquipItem_Gloves.SetTooltipText(GetSystemString(37));
	PetEquipItem_Feet.SetTooltipText(GetSystemString(40));
	PetEquipItem_LFinger.SetTooltipText(GetSystemString(239));
	PetEquipItem_RFinger.SetTooltipText(GetSystemString(239));
	PetEquipItem_LEar.SetTooltipText(GetSystemString(237));
	PetEquipItem_REar.SetTooltipText(GetSystemString(237));
	PetEquipItem_Neck.SetTooltipText(GetSystemString(238));
	PetEquipItem_LHand.SetTooltipText(GetSystemString(13205));
	PetEquipItem_Hair.SetTooltipText(GetSystemString(1024));
	PetEquipItem_Hair2.SetTooltipText(GetSystemString(1024));
	PetEquipItem_Waist.SetTooltipText(GetSystemString(2538));
	PetEquipItem_Cloak.SetTooltipText(GetSystemString(234));
	PetEquipItem_Legs.SetDisableTex("L2UI.InventoryWnd.Icon_dualcap");
	PetEquipItem_Underwear.SetTooltipText(GetSystemString(3362));
	texPetExp.SetDecimalPlace(4);
	EvolveTooltip_BTN = GetButtonHandle("PetWndClassic.PetClassicInfoWnd.Tooltip2_Btn");
	RandomNameTooltip_BTN = GetButtonHandle("PetWndClassic.PetClassicInfoWnd.Tooltip_Btn");
	txtEvolveStep = GetTextBoxHandle("PetWndClassic.PetClassicInfoWnd.txtevolution");
	skillNumWnd = GetWindowHandle("PetWndClassic.PetClassicInfoWnd.SkillNum_Wnd");
	txtSkillNum = GetTextBoxHandle("PetWndClassic.PetClassicInfoWnd.SkillNum_Wnd.Num_Txt");
	portraitIconTex = GetTextureHandle("PetWndClassic.PetClassicInfoWnd.PortraitIcon_Tex");
	viewportWnd = GetCharacterViewportWindowHandle("PetWndClassic.PetWnd_Inventory.ObjectViewport");
	viewportWnd.SetUISound(false);
	viewportWnd.SetPetFlag(true);
	effectViewportWnd = GetEffectViewportWndHandle("PetWndClassic.PetWnd_Inventory.EffectViewport");
	evolveEffectViewportWnd = GetEffectViewportWndHandle("PetWndClassic.PetWnd_Inventory.EffectViewport2");
	equipSlotBonusBtn = GetButtonHandle("PetWndClassic.PetWnd_Inventory.Tooltip_Equipment_Btn");
	dialogContainer = GetWindowHandle("PetWndClassic.DisableWnd");
	evolveDialogAsset = Class'InterfaceClassic.UIControlDialogAssets'.static.InitScript(GetWindowHandle((dialogContainer.m_WindowNameWithFullPath $ ".UIControlDialogAsset")));
	evolveDialogAsset.DelegateOnCancel = OnEvolveDialogCancel;
	evolveDialogAsset.DelegateOnClickBuy = OnEvolveDialogConfirm;
	evolveDialogAsset.SetUseBuyItem(false);
	evolveDialogAsset.SetUseNeedItem(true);
	evolveDialogAsset.SetUseNumberInput(false);
	return;
}

function OnShow()
{
	Class'NWindow.PetAPI'.static.RequestPetInventoryItemList();
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("RefineryWnd");
	HandlePetInfoUpdate();
	UpdateViewport();
	UpdatePetSlotBonusInfo();
	UpdatePetBackEquipViewportEffect();
	return;
}

function OnDropItemSource(string strTarget, ItemInfo Info)
{
	if((strTarget != "Console"))
	{
		return;
	}
	API_C_EX_PET_UNEQUIP_ITEM(Info.Id.ServerID);
	return;
}

function OnDropItem(string strTarget, ItemInfo Info, int X, int Y)
{
	local InventoryWnd Script;

	Script = InventoryWnd(GetScript("InventoryWnd"));
	if((((((((((((((((((((strTarget == "PetWnd_Inventory") || (strTarget == "PetEquipItem_Head")) || (strTarget == "PetEquipItem_Chest")) || (strTarget == "PetEquipItem_Legs")) || (strTarget == "PetEquipItem_RHand")) || (strTarget == "PetEquipItem_Gloves")) || (strTarget == "PetEquipItem_Feet")) || (strTarget == "PetEquipItem_LFinger")) || (strTarget == "PetEquipItem_RFinger")) || (strTarget == "PetEquipItem_LEar")) || (strTarget == "PetEquipItem_REar")) || (strTarget == "PetEquipItem_Neck")) || (strTarget == "PetEquipItem_Pet")) || (strTarget == "PetEquipItem_Underwear")) || (strTarget == "PetEquipItem_LHand")) || (strTarget == "PetEquipItem_Hair")) || (strTarget == "PetEquipItem_Hair2")) || (strTarget == "PetEquipItem_Waist")) || ((strTarget == "PetEquipItem_Cloak") && (Script.getInventoryItemWndName(Info.DragSrcName) == true))))
	{
		if(isDamagedItem(Info))
		{
			return;
		}
		API_C_EX_PET_EQUIP_ITEM(Info.Id.ServerID);
	}
	return;
}

function HandleLanguageChanged()
{
	Class'NWindow.ActionAPI'.static.RequestPetActionList();
	return;
}

function OnHide()
{
	HideEvolveDialog();
	return;
}

function OnEvent(int Event_ID, string param)
{
	if(!IsAdenServer())
	{
		return;
	}
	if((Event_ID == 250))
	{
		HandlePetInfoUpdate();
		if((_needUpdateBackEquipViewport == true))
		{
			_needUpdateBackEquipViewport = false;
			UpdatePetBackEquipViewportEffect();
		}
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
	else if((Event_ID == 11430))
	{
		clearEquipItemTooltip();
	}
	return;
}

function OnEvolveDialogCancel()
{
	HideEvolveDialog();
	return;
}

function OnEvolveDialogConfirm()
{
	local PetInfo PetInfo;
	local array<EvolveCondition> evolveConditionArr;
	local array<RequestItem> requestItemArr;
	local RequestItem RequestItem;
	local int i;

	GetPetInfo(PetInfo);
	Class'NWindow.PetAPI'.static.GetPetEvolveCondition(PetInfo.nPetID, (PetInfo.nEvolutionStep + 1), evolveConditionArr, requestItemArr);
	if((requestItemArr.Length > 0))
	{
		i = 0;
		while((i < requestItemArr.Length))
		{
			RequestItem = requestItemArr[i];
			if(hasEnoughItem(RequestItem.Id, RequestItem.Amount))
			{
				API_C_EX_EVOLVE_PET();
				break;
			}
			if((i == (requestItemArr.Length - 1)))
			{
				AddSystemMessage(13094);
			}
			i++;
		}
	}
	else
	{
		API_C_EX_EVOLVE_PET();
	}
	HideEvolveDialog();
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "Evolve_BTN":
			OnEvolve_BTNClick();
			break;
		case "SkillLearn_BTN":
			toggleWindow("PetSkillWnd");
			break;
		case "Character_BTN":
			toggleWindow("PetStatInfoWnd");
			break;
		case "WindowHelp_BTN":
			ExecuteEvent(1210, "53");
			break;
		default:
			break;
	}
	return;
}

function OnEvolve_BTNClick()
{
	ShowEvolveDialog();
	return;
}

function OnDBClickItem(string strID, int Index)
{
	local ItemInfo infItem;

	if(((Left(strID, 12) == "PetEquipItem") && (Index > -1)))
	{
		GetItemWindowHandle(("PetWndClassic.PetWnd_Inventory." $ strID)).GetItem(Index, infItem);
		API_C_EX_PET_UNEQUIP_ITEM(infItem.Id.ServerID);
	}
	return;
}

function OnRClickItem(string strID, int Index)
{
	OnDBClickItem(strID, Index);
	return;
}

function Clear()
{
	txtLvName.SetText("");
	texPetHP.SetPoint(INT64(0), INT64(0));
	texPetMP.SetPoint(INT64(0), INT64(0));
	texPetExp.SetPointPercent(INT64(0), INT64(0), INT64(0));
	texPetFatigue.SetTooltipCustomType(MakeTooltipSimpleText("[0]/[0]"));
	texPetFatigue.SetPointPercent(INT64(0), INT64(0), INT64(0));
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
	local int Hp, MaxHP, MP, maxMP, Fatigue, MaxFatigue, Level, nEvolutionID;
	local INT64 nCurExp, nMinExp, nMaxExp;
	local PetInfo Info;
	local PetNameInfo NameInfo;
	local PetLookInfo LookInfo;
	local L2PetRaceEmblemUIData petEmplemData;

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
		if((nEvolutionStep < Info.nEvolutionStep))
		{
			if((_requestPetEvolve == true))
			{
				PlayEvolveEffect();
				_requestPetEvolve = false;
			}
			UpdateViewport();
		}
		nEvolutionStep = Info.nEvolutionStep;
		nEvolvePetID = Info.nPetID;
		nPetLevel = Info.nLevel;
	}
	setEvolveInfoControl(nEvolutionStep);
	Class'NWindow.PetAPI'.static.GetPetEvolveLookInfo(Info.nEvolutionLook, LookInfo);
	if((nEvolutionStep > 0))
	{
		Class'NWindow.PetAPI'.static.GetPetEvolveNameInfo(Info.nEvolutionNameID, NameInfo);
		Name = NameInfo.Name;
		Class'NWindow.PetAPI'.static.GetPetEvolveNameInfo(Info.nEvolutionNamePrefixID, NameInfo);
		txtRandomName.SetText((NameInfo.Name @ Name));
		txtRandomName.MoveC(239, 70);
		RandomNameTooltip_BTN.SetTooltipCustomType(MakeTooltipSimpleText(NameInfo.Desc));
		RandomNameTooltip_BTN.ShowWindow();
	}
	else
	{
		txtRandomName.SetText(GetSystemString(971));
		txtRandomName.MoveC(220, 70);
		RandomNameTooltip_BTN.HideWindow();
	}
	txtEvolveStep.SetText(GetSystemString(getInstanceL2Util().GetPetEvolveStepStringId(EPetType(Info.nPetType), nEvolutionStep)));
	if((int(byte(Info.nPetType)) == 0))
	{
		EvolveTooltip_BTN.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14818)));
	}
	else if((int(byte(Info.nPetType)) == 1))
	{
		EvolveTooltip_BTN.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14819)));
	}
	if((Info.nEvolutionLook > 0))
	{
		Class'NWindow.PetAPI'.static.GetPetEvolveLookInfo(Info.nEvolutionLook, LookInfo);
	}
	else
	{
		Class'NWindow.PetAPI'.static.GetPetEvolveLookInfo(Info.nClassID, LookInfo);
	}
	txtRandomStatName.SetText(LookInfo.Name);
	txtRandomStatName.SetTooltipText(LookInfo.Desc);
	Class'NWindow.PetAPI'.static.GetPetRaceEmblemData(Info.nPetID, petEmplemData);
	portraitIconTex.SetTexture(petEmplemData.EmblemTexName);
	txtLvName.SetText(string(Level));
	texPetHP.SetPoint(INT64(Hp), INT64(MaxHP));
	texPetMP.SetPoint(INT64(MP), INT64(maxMP));
	texPetExp.SetPointPercent(nCurExp, nMinExp, nMaxExp);
	texPetFatigue.SetTooltipText((((("[" $ string(Fatigue)) $ "]/[") $ string(MaxFatigue)) $ "]"));
	texPetFatigue.SetPointPercent(INT64(Fatigue), INT64(0), INT64(MaxFatigue));
	EvolutionizedAction = nEvolutionID;
	Class'InterfaceClassic.PetStatInfoWnd'.static.Inst().UpdateUIControls();
	return;
}

function HandlePetShow()
{
	Clear();
	PlayConsoleSound(IFST_WINDOW_OPEN);
	Me.ShowWindow();
	Me.SetFocus();
	HandlePetInfoUpdate();
	return;
}

function UpdateViewport()
{
	local PetInfo PetInfo;
	local int NpcID;
	local float npcScale, OffsetY;

	GetPetInfo(PetInfo);
	if((PetInfo.nEvolutionStep > 0))
	{
		NpcID = PetInfo.nEvolutionLook;
	}
	else
	{
		NpcID = PetInfo.nClassID;
	}
	if((PetInfo.nPetType == 1))
	{
		if((PetInfo.nEvolutionStep == 0))
		{
			npcScale = 0.8500000;
			if((PetInfo.nPetID == 1003))
			{
				npcScale = 1.3000000;
				OffsetY = -4.0000000;
			}
		}
		else if((PetInfo.nEvolutionStep == 1))
		{
			npcScale = 0.9000000;
			if((PetInfo.nPetID == 1002))
			{
				npcScale = 0.8500000;
			}
			else if((PetInfo.nPetID == 1003))
			{
				npcScale = 1.3300000;
				OffsetY = -4.0000000;
			}
		}
		else if((PetInfo.nEvolutionStep == 2))
		{
			npcScale = 1.0000000;
			if((PetInfo.nPetID == 1001))
			{
				OffsetY = -3.0000000;
			}
			else if((PetInfo.nPetID == 1002))
			{
				npcScale = 1.1799999;
			}
			else if((PetInfo.nPetID == 1003))
			{
				npcScale = 1.3400000;
				OffsetY = -7.0000000;
			}
		}
	}
	else if((PetInfo.nEvolutionStep == 0))
	{
		npcScale = 0.8000000;
		if((PetInfo.nPetID == 17))
		{
			npcScale = 1.0000000;
		}
		else if((PetInfo.nPetID == 12))
		{
			npcScale = 0.7000000;
		}
		else
		{
			OffsetY = 3.0000000;
		}
	}
	else if((PetInfo.nEvolutionStep == 1))
	{
		npcScale = 1.1000000;
		OffsetY = 2.0000000;
		if((PetInfo.nPetID == 15))
		{
			npcScale = 0.9000000;
		}
		else if((PetInfo.nPetID == 17))
		{
			npcScale = 1.8000000;
			OffsetY = 40.0000000;
		}
	}
	else if((PetInfo.nEvolutionStep == 2))
	{
		npcScale = 1.2000000;
		if((PetInfo.nPetID == 15))
		{
			npcScale = 0.9000000;
		}
		else if((PetInfo.nPetID == 17))
		{
			npcScale = 1.0000000;
			OffsetY = 15.0000000;
		}
	}
	if((PetInfo.nEvolutionStep == 0))
	{
		effectViewportWnd.SpawnEffect("LineageEffect3.ui_companion_flag_blue");
	}
	else if((PetInfo.nEvolutionStep == 1))
	{
		effectViewportWnd.SpawnEffect("LineageEffect3.ui_companion_flag_yellow");
	}
	else if((PetInfo.nEvolutionStep == 2))
	{
		effectViewportWnd.SpawnEffect("LineageEffect3.ui_companion_flag_red");
	}
	viewportWnd.SetNPCInfo(NpcID);
	viewportWnd.SetSpawnDuration(0.1000000);
	viewportWnd.SetCharacterScale(npcScale);
	viewportWnd.SetCharacterOffsetY(int(OffsetY));
	viewportWnd.SpawnNPC();
	viewportWnd.UpdateDollAutoCameraDist(30.0000000);
	viewportWnd.PlayAnimation(0);
	return;
}

function PlayEvolveEffect()
{
	evolveEffectViewportWnd.SpawnEffect("LineageEffect2.ui_upgrade_succ");
	return;
}

function SetSkillNumControl(int skillNum)
{
	if((skillNum > 0))
	{
		txtSkillNum.SetText(string(skillNum));
		skillNumWnd.ShowWindow();
	}
	else
	{
		skillNumWnd.HideWindow();
	}
	return;
}

function HandlePetInventoryItemStart()
{
	clearAllIEquip();
	return;
}

function HandlePetInventoryItemList(string param)
{
	local ItemInfo infItem;

	ParamToItemInfo(param, infItem);
	if(!infItem.bEquipped)
	{
		return;
	}
	PetEquipItemUpdate(infItem);
	return;
}

function HandlePetInventoryItemUpdate(string param)
{
	local ItemInfo infItem;
	local int tmp;
	local UIEventManager.EInventoryUpdateType WorkType;

	ParamToItemInfo(param, infItem);
	ParseInt(param, "WorkType", tmp);
	WorkType = EInventoryUpdateType(tmp);
	if(!IsValidItemID(infItem.Id))
	{
		return;
	}
	switch(WorkType)
	{
		case IVUT_ADD:
		case IVUT_UPDATE:
			PetEquipItemUpdate(infItem);
			break;
		case IVUT_DELETE:
			PetEquipItemUpdate(infItem, true);
			break;
		default:
			break;
	}
	return;
}

function int getLeftRightSlotBitType(int slotBitTypeLeft, int slotBitTypeRight, ItemInfo a_Info)
{
	local int itemNumL, itemNumR;
	local ItemInfo infoL, InfoR;

	itemNumL = getSlotItemWindowBySlotBit(INT64(slotBitTypeLeft)).GetItemNum();
	itemNumR = getSlotItemWindowBySlotBit(INT64(slotBitTypeRight)).GetItemNum();
	if(((itemNumL + itemNumR) > 0))
	{
		if((itemNumL > 0))
		{
			getSlotItemWindowBySlotBit(INT64(slotBitTypeLeft)).GetItem(0, infoL);
		}
		if((itemNumR > 0))
		{
			getSlotItemWindowBySlotBit(INT64(slotBitTypeRight)).GetItem(0, InfoR);
		}
		if(IsSameServerID(infoL.Id, a_Info.Id))
		{
			return slotBitTypeLeft;
		}
		else if(IsSameServerID(InfoR.Id, a_Info.Id))
		{
			return slotBitTypeRight;
		}
	}
	if((itemNumL <= 0))
	{
		return slotBitTypeLeft;
	}
	else if((itemNumR <= 0))
	{
		return slotBitTypeRight;
	}
	return -1;
}

function AnimTextureHandle GetEffectTexFromEquipName(string slotName)
{
	local string effectSlotPath;
	local AnimTextureHandle effectTex;

	effectSlotPath = (("PetWndClassic.PetWnd_Inventory." $ slotName) $ "_effect");
	effectTex = GetAnimTextureHandle(effectSlotPath);
	return effectTex;
}

function AddPetItemSlot(ItemWindowHandle targetSlot, ItemInfo ItemInfo)
{
	local AnimTextureHandle effectTex;
	local int lv;
	local string texturePath;

	effectTex = GetEffectTexFromEquipName(targetSlot.GetWindowName());
	targetSlot.AddItem(ItemInfo);
	if(Me.IsShowWindow())
	{
		lv = targetSlot.GetInventoryEffectLevel(0);
		if((lv <= 0))
		{
			effectTex.HideWindow();
		}
		else
		{
			texturePath = GetEffectTextureName(targetSlot.GetInventoryEffectLevel(0));
			if((texturePath != ""))
			{
				effectTex.SetTexture(texturePath);
				effectTex.SetLoopCount(-1);
				effectTex.SetCurrentFrame(GetEffectAnimCurrentFrame());
				effectTex.Play();
				effectTex.ShowWindow();
			}
			else
			{
				effectTex.HideWindow();
			}
		}
	}
	return;
}

function ClearPetItemSlot(ItemWindowHandle targetSlot)
{
	local AnimTextureHandle effectTex;

	effectTex = GetEffectTexFromEquipName(targetSlot.GetWindowName());
	targetSlot.Clear();
	effectTex.HideWindow();
	return;
}

function UpdatePetSlotBonusInfo()
{
	local string statusStr;
	local int i, bonusSkillId, equipedNum;
	local SkillInfo bonusSkillInfo;
	local PetInfo PetInfo;
	local array<DrawItemInfo> drawListArr;
	local L2Util util;

	util = getInstanceL2Util();
	if((Me.IsShowWindow() == false))
	{
		return;
	}
	GetPetInfo(PetInfo);
	bonusSkillId = Class'NWindow.PetAPI'.static.GetEquipSlotCompleteBonusSkillID(PetInfo.nPetID);
	if((bonusSkillId == 0))
	{
		equipSlotBonusBtn.HideWindow();
		return;
	}
	else
	{
		equipSlotBonusBtn.ShowWindow();
	}
	i = 0;
	while((i < 17))
	{
		if((getSlotItemWindowBySlotType(i).GetItemNum() > 0))
		{
			equipedNum++;
		}
		i++;
	}
	statusStr = (((((GetSystemString(14958) $ "(") $ string(equipedNum)) $ "/") $ string(17)) $ ")");
	GetSkillInfo(bonusSkillId, 1, 0, bonusSkillInfo);
	if((17 == equipedNum))
	{
		equipSlotBonusBtn.SetEnable(true);
		drawListArr[drawListArr.Length] = addDrawItemText(statusStr, util.Yellow, "", false, true);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(100);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = addDrawItemText(bonusSkillInfo.SkillDesc, util.White, "", true, true);
	}
	else
	{
		equipSlotBonusBtn.SetEnable(false);
		drawListArr[drawListArr.Length] = addDrawItemText(statusStr, util.White, "", false, true);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(100);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = addDrawItemText(bonusSkillInfo.SkillDesc, util.Gray, "", true, true);
	}
	equipSlotBonusBtn.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
	return;
}

function UpdatePetBackEquipViewportEffect()
{
	local PetInfo PetInfo;

	if((Me.IsShowWindow() == false))
	{
		return;
	}
	if((GetPetInfo(PetInfo) == false))
	{
		return;
	}
	viewportWnd.CopyPetEquipment(PetInfo.nServerID, INT64(8192));
	return;
}

function string GetEffectTextureName(int lv)
{
	switch(lv)
	{
		case 1:
			return "L2UI_NewTex.PetWnd.PetSlotAni_Gray0000";
		case 2:
			return "L2UI_NewTex.PetWnd.PetSlotAni_Green0000";
		case 3:
			return "L2UI_NewTex.PetWnd.PetSlotAni_Yellow0000";
		case 4:
			return "L2UI_NewTex.PetWnd.PetSlotAni_Red0000";
		case 5:
			return "L2UI_NewTex.PetWnd.PetSlotAni_Purple0000";
		default:
			return "";
	}
}

function PetEquipItemUpdate(ItemInfo a_Info, optional bool bDelete)
{
	local ItemWindowHandle hItemWnd;
	local int nTargetSlotBitType;
	local bool bEarSwap, bFingerSwap;
	local ItemInfo tempInfo;

	switch(a_Info.SlotBitType)
	{
		case INT64(32768):
			if(bDelete)
			{
				ClearPetItemSlot(PetEquipItem_Chest);
				ClearPetItemSlot(PetEquipItem_Legs);
				PetEquipItem_Legs.EnableWindow();
			}
			else
			{
				ClearPetItemSlot(PetEquipItem_Chest);
				ClearPetItemSlot(PetEquipItem_Legs);
				a_Info.IconIndex = 1;
				AddPetItemSlot(PetEquipItem_Chest, a_Info);
				a_Info.IconIndex = 2;
				AddPetItemSlot(PetEquipItem_Legs, a_Info);
				PetEquipItem_Legs.DisableWindow();
			}
			break;
		case INT64(2):
		case INT64(4):
		case INT64(6):
			nTargetSlotBitType = getLeftRightSlotBitType(4, 2, a_Info);
			if((nTargetSlotBitType == -1))
			{
				hItemWnd = none;
			}
			else
			{
				hItemWnd = getSlotItemWindowBySlotBit(INT64(nTargetSlotBitType));
			}
			if(((nTargetSlotBitType == 4) && bDelete))
			{
				bEarSwap = true;
			}
			break;
		case INT64(16):
		case INT64(32):
		case INT64(48):
			nTargetSlotBitType = getLeftRightSlotBitType(32, 16, a_Info);
			if((nTargetSlotBitType == -1))
			{
				hItemWnd = none;
			}
			else
			{
				hItemWnd = getSlotItemWindowBySlotBit(INT64(nTargetSlotBitType));
			}
			if(((nTargetSlotBitType == 32) && bDelete))
			{
				bFingerSwap = true;
			}
			break;
		default:
			hItemWnd = getSlotItemWindowBySlotBit(a_Info.SlotBitType);
	}
	if(((none != hItemWnd) && (a_Info.SlotBitType != INT64(32768))))
	{
		ClearPetItemSlot(hItemWnd);
		if(!bDelete)
		{
			AddPetItemSlot(hItemWnd, a_Info);
		}
		if(bEarSwap)
		{
			getSlotItemWindowBySlotBit(INT64(6)).GetItem(0, tempInfo);
			ClearPetItemSlot(getSlotItemWindowBySlotBit(INT64(6)));
			if((tempInfo.Id.ClassID > 0))
			{
				ClearPetItemSlot(hItemWnd);
				AddPetItemSlot(hItemWnd, tempInfo);
			}
		}
		else if(bFingerSwap)
		{
			getSlotItemWindowBySlotBit(INT64(16)).GetItem(0, tempInfo);
			ClearPetItemSlot(getSlotItemWindowBySlotBit(INT64(16)));
			if((tempInfo.Id.ClassID > 0))
			{
				ClearPetItemSlot(hItemWnd);
				AddPetItemSlot(hItemWnd, tempInfo);
			}
		}
	}
	if((PetEquipItem_Chest.GetItemNum() == 0))
	{
		PetEquipItem_Legs.EnableWindow();
	}
	else if(PetEquipItem_Chest.GetItem(0, tempInfo))
	{
		if((tempInfo.SlotBitType != INT64(32768)))
		{
			PetEquipItem_Legs.EnableWindow();
		}
	}
	if((a_Info.SlotBitType == INT64(8192)))
	{
		_needUpdateBackEquipViewport = true;
	}
	Me.EnableTick();
	return;
}

function OnTick()
{
	Me.DisableTick();
	UpdatePetSlotBonusInfo();
	return;
}

function ShowEvolveDialog()
{
	local PetInfo PetInfo;
	local array<EvolveCondition> evolveConditionArr;
	local array<RequestItem> requestItemArr;
	local RequestItem RequestItem;
	local int i;
	local ItemInfo tmpItemInfo;
	local CustomTooltip helpTooltip;

	GetPetInfo(PetInfo);
	evolveDialogAsset.SetDialogDesc(GetSystemMessage(14049));
	Class'NWindow.PetAPI'.static.GetPetEvolveCondition(PetInfo.nPetID, (PetInfo.nEvolutionStep + 1), evolveConditionArr, requestItemArr);
	if((requestItemArr.Length > 0))
	{
		evolveDialogAsset.SetUseNeedItem(true);
		evolveDialogAsset.StartNeedItemList(1);
		i = 0;
		while((i < requestItemArr.Length))
		{
			RequestItem = requestItemArr[i];
			if((GetInventoryItemCount(GetItemID(RequestItem.Id)) >= RequestItem.Amount))
			{
				break;
			}
			i++;
		}
	}
	else
	{
		evolveDialogAsset.SetUseNeedItem(false);
	}
	if((requestItemArr.Length == 2))
	{
		addToolTipDrawList(helpTooltip, addDrawItemTextureCustom("L2UI_NewTex.SkillWnd.Icon_Substitution", false, false, 0, -2, 16, 16, 20, 20));
		addToolTipDrawList(helpTooltip, addDrawItemText((GetSystemString(14395) $ ":"), getInstanceL2Util().White, "", false, true));
		Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(requestItemArr[0].Id), tmpItemInfo);
		addToolTipDrawList(helpTooltip, addDrawItemText(tmpItemInfo.Name, getInstanceL2Util().Gold, "", true, true));
		if((Len(tmpItemInfo.AdditionalName) > 0))
		{
			addToolTipDrawList(helpTooltip, addDrawItemText(tmpItemInfo.AdditionalName, GetColor(255, 217, 105, 255), "", false, true, 4));
		}
		addToolTipDrawList(helpTooltip, addDrawItemText((("(" $ GetSystemString(14401)) $ ")"), GetColor(255, 101, 101, 255), "", false, true, 4));
		Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(requestItemArr[1].Id), tmpItemInfo);
		addToolTipDrawList(helpTooltip, addDrawItemText(tmpItemInfo.Name, getInstanceL2Util().Gold, "", true, true));
		if((Len(tmpItemInfo.AdditionalName) > 0))
		{
			addToolTipDrawList(helpTooltip, addDrawItemText(tmpItemInfo.AdditionalName, GetColor(255, 217, 105, 255), "", false, true, 4));
		}
		evolveDialogAsset.SetNeedItemHelpTooltip(helpTooltip);
		evolveDialogAsset.ShowNeedItemHelpTexture(true);
	}
	else
	{
		evolveDialogAsset.ShowNeedItemHelpTexture(false);
	}
	evolveDialogAsset.AddNeedItemClassID(RequestItem.Id, RequestItem.Amount);
	evolveDialogAsset.SetItemNum(1);
	dialogContainer.ShowWindow();
	evolveDialogAsset.Show();
	return;
}

function HideEvolveDialog()
{
	dialogContainer.HideWindow();
	evolveDialogAsset.Hide();
	return;
}

function ItemWindowHandle getSlotItemWindowBySlotBit(INT64 slotbit)
{
	switch(slotbit)
	{
		case INT64(1):
			return PetEquipItem_Underwear;
		case INT64(16384):
		case INT64(128):
			return PetEquipItem_RHand;
		case INT64(32768):
		case INT64(1024):
			return PetEquipItem_Chest;
		case INT64(8):
			return PetEquipItem_Neck;
		case INT64(2048):
			return PetEquipItem_Legs;
		case INT64(512):
			return PetEquipItem_Gloves;
		case INT64(4096):
			return PetEquipItem_Feet;
		case INT64(64):
			return PetEquipItem_Head;
		case INT64(32):
			return PetEquipItem_LFinger;
		case INT64(16):
			return PetEquipItem_RFinger;
		case INT64(4):
			return PetEquipItem_LEar;
		case INT64(2):
			return PetEquipItem_REar;
		case INT64(256):
			return PetEquipItem_LHand;
		case INT64(65536):
			return PetEquipItem_Hair;
		case INT64(262144):
			return PetEquipItem_Hair2;
		case INT64(268435456):
			return PetEquipItem_Waist;
		case INT64(8192):
			return PetEquipItem_Cloak;
		default:
			return PetEquipItem_REar;
	}
}

function OnRegisterEvent()
{
	RegisterEvent(1710);
	RegisterEvent(1720);
	RegisterEvent(250);
	RegisterEvent(1010);
	RegisterEvent(1020);
	RegisterEvent(1030);
	RegisterEvent(1130);
	RegisterEvent(1060);
	RegisterEvent(1070);
	RegisterEvent(1080);
	RegisterEvent(1900);
	RegisterEvent(190);
	RegisterEvent(210);
	RegisterEvent(11481);
	RegisterEvent(9750);
	RegisterEvent(11430);
	return;
}

function API_C_EX_PET_EQUIP_ITEM(int nItemServerId)
{
	local array<byte> stream;
	local UIPacket._C_EX_PET_EQUIP_ITEM packet;

	packet.nItemServerId = nItemServerId;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_PET_EQUIP_ITEM(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(631, stream);
	return;
}

function API_C_EX_PET_UNEQUIP_ITEM(int nItemServerId)
{
	local array<byte> stream;
	local UIPacket._C_EX_PET_UNEQUIP_ITEM packet;

	if((nItemServerId <= 0))
	{
		Debug((" Api Call Error : C_EX_PET_UNEQUIP_ITEM, ServerID is wrong" @ string(nItemServerId)));
		return;
	}
	packet.nItemServerId = nItemServerId;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_PET_UNEQUIP_ITEM(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(632, stream);
	return;
}

function API_C_EX_EVOLVE_PET(optional int cDummy)
{
	local array<byte> stream;
	local UIPacket._C_EX_EVOLVE_PET packet;

	packet.cDummy = cDummy;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_EVOLVE_PET(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(641, stream);
	_requestPetEvolve = true;
	return;
}

function clearAllIEquip()
{
	local int i;

	i = 0;
	while((i < 17))
	{
		ClearPetItemSlot(getSlotItemWindowBySlotType(i));
		i++;
	}
	return;
}

function int GetEffectAnimCurrentFrame()
{
	local int i;
	local AnimTextureHandle effectTex;

	i = 0;
	while((i < 17))
	{
		effectTex = GetEffectTexFromEquipName(getSlotItemWindowBySlotType(i).GetWindowName());
		if(effectTex.IsShowWindow())
		{
			return effectTex.GetCurrentFrame();
		}
		i++;
	}
	return i;
}

function setEvolveInfoControl(int nEvolStep)
{
	local array<EvolveCondition> evolveConditionArr;
	local array<RequestItem> requestItemArr;
	local int i;
	local bool bEvolveCondition;

	Class'NWindow.PetAPI'.static.GetPetEvolveCondition(nEvolvePetID, (nEvolStep + 1), evolveConditionArr, requestItemArr);
	i = 0;
	while((i < evolveConditionArr.Length))
	{
		if((evolveConditionArr[i].ConditionType == 1))
		{
			if((evolveConditionArr[i].Value <= nPetLevel))
			{
				bEvolveCondition = true;
			}
		}
		i++;
	}
	if(bEvolveCondition)
	{
		Evolve_BTN.EnableWindow();
	}
	else
	{
		Evolve_BTN.DisableWindow();
	}
	return;
}

function setRandomPetName(string nameStr, string statName)
{
	txtRandomName.SetText(nameStr);
	txtRandomStatName.SetText(statName);
	return;
}

function ItemWindowHandle getSlotItemWindowBySlotType(int hSlotType)
{
	switch(hSlotType)
	{
		case 0:
			return PetEquipItem_RHand;
		case 1:
			return PetEquipItem_Chest;
		case 2:
			return PetEquipItem_Neck;
		case 3:
			return PetEquipItem_Legs;
		case 4:
			return PetEquipItem_Gloves;
		case 5:
			return PetEquipItem_Feet;
		case 6:
			return PetEquipItem_Head;
		case 7:
			return PetEquipItem_LFinger;
		case 8:
			return PetEquipItem_RFinger;
		case 9:
			return PetEquipItem_LEar;
		case 10:
			return PetEquipItem_REar;
		case 11:
			return PetEquipItem_Underwear;
		case 12:
			return PetEquipItem_LHand;
		case 13:
			return PetEquipItem_Hair;
		case 14:
			return PetEquipItem_Hair2;
		case 15:
			return PetEquipItem_Waist;
		case 16:
			return PetEquipItem_Cloak;
		default:
			return PetEquipItem_REar;
	}
}

function clearEquipItemTooltip()
{
	local int i;

	i = 0;
	while((i < 17))
	{
		getSlotItemWindowBySlotType(i).ClearItemTooltip();
		i++;
	}
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	m_bShowNameBtn = true;
	EvolutionizedAction = 0;
	inventoryWndScript = InventoryWnd(GetScript("InventoryWnd"));
	return;
}

function OnReceivedCloseUI()
{
	GetWindowHandle(m_Windowname).HideWindow();
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	return;
}

defaultproperties
{
	m_Windowname="PetWndClassic"
}
