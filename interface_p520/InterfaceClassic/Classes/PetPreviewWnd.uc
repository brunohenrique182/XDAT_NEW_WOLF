class PetPreviewWnd extends UICommonAPI
	dependson(UIPacket);

const SKILL_GROUP_NUM_MAX = 2;
const ITEM_SKILL_ICON_TYPE = 6615;




var WindowHandle Me;
var array<PetPreviewWndGroupItem> skillGroupItemList;
var WindowHandle skillScrollArea;
var TextBoxHandle skillEmptyTextBox;
var TextBoxHandle txtRandomStatName;
var TextBoxHandle txtRandomName;
var TextBoxHandle txtLvName;
var TextBoxHandle txtEvolveStep;
var TextureHandle portraitIconTex;
var StatusBarHandle texPetExp;
var ButtonHandle EvolveTooltip_BTN;
var ButtonHandle RandomNameTooltip_BTN;
var array<PetSkillGroupInfo__PetPreviewWnd> _skillGroups;
var array<PetSkillSlotInfo__PetPreviewWnd> _totalSkillInfos;
var PetPreviewInfo _petPreviewInfo;
//var delegate<OnSortByOrder> __OnSortByOrder__Delegate;

static function PetPreviewWnd Inst()
{
	return PetPreviewWnd(GetScript("PetPreviewWnd"));
}

function Initialize()
{
	InitControls();
	return;
}

function InitControls()
{
	local int i;
	local string ownerFullPath;
	local WindowHandle infoContainer;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	infoContainer = GetWindowHandle((ownerFullPath $ ".PetPreviewInfo_Wnd"));
	skillScrollArea = GetWindowHandle((ownerFullPath $ ".PetPreviewSKill_Wnd.Skill_Wnd.Skill.SkillScroll"));
	skillEmptyTextBox = GetTextBoxHandle((ownerFullPath $ ".PetPreviewSKill_Wnd.Skill_Wnd.Empty_Txt"));
	portraitIconTex = GetTextureHandle((infoContainer.m_WindowNameWithFullPath $ ".PortraitIcon_Tex"));
	texPetExp = GetStatusBarHandle((infoContainer.m_WindowNameWithFullPath $ ".texPetExp"));
	txtLvName = GetTextBoxHandle((infoContainer.m_WindowNameWithFullPath $ ".txtLvName"));
	txtEvolveStep = GetTextBoxHandle((infoContainer.m_WindowNameWithFullPath $ ".txtevolution"));
	txtRandomStatName = GetTextBoxHandle((infoContainer.m_WindowNameWithFullPath $ ".txtrandomStatName"));
	txtRandomName = GetTextBoxHandle((infoContainer.m_WindowNameWithFullPath $ ".txtrandomName"));
	EvolveTooltip_BTN = GetButtonHandle((infoContainer.m_WindowNameWithFullPath $ ".Tooltip2_Btn"));
	RandomNameTooltip_BTN = GetButtonHandle((infoContainer.m_WindowNameWithFullPath $ ".Tooltip_Btn"));
	i = 0;
	while((i < 2))
	{
		AddGroupItemControl(skillGroupItemList, "Skill", i, skillScrollArea);
		i++;
	}
	return;
}

function AddGroupItemControl(out array<PetPreviewWndGroupItem> componentList, string componentName, int Index, WindowHandle parentWnd)
{
	local WindowHandle targetWindowHandle;
	local PetPreviewWndGroupItem targetControl;

	targetWindowHandle = GetWindowHandle((((parentWnd.m_WindowNameWithFullPath $ ".") $ componentName) $ string(Index)));
	targetWindowHandle.SetScript("PetPreviewWndGroupItem");
	targetControl = PetPreviewWndGroupItem(targetWindowHandle.GetScript());
	targetControl.Init(targetWindowHandle);
	targetControl.DelegateOnSkillInfoClicked = OnPetSkillSlotInfoClicked;
	componentList[componentList.Length] = targetControl;
	return;
}

function ResetSkillGroupInfo()
{
	_totalSkillInfos.Length = 0;
	_skillGroups.Length = 0;
	return;
}

function ResetPetPreviewInfo()
{
	local PetPreviewInfo defaultInfo;

	_petPreviewInfo = defaultInfo;
	return;
}

function ResetInfo()
{
	ResetSkillGroupInfo();
	ResetPetPreviewInfo();
	_totalSkillInfos.Length = 0;
	return;
}

function UpdateSkillInfos()
{
	MakePetSkillGroupInfos(_totalSkillInfos, _skillGroups);
	return;
}

function MakePetSkillGroupInfos(array<PetSkillSlotInfo__PetPreviewWnd> skillInfos, out array<PetSkillGroupInfo__PetPreviewWnd> outPetSkillGroupInfos)
{
	local int i, IconType;
	local PetSkillSlotInfo__PetPreviewWnd tempInfo;
	local PetSkillGroupInfo__PetPreviewWnd tempGroupInfo, defaultGroupInfo;
	local array<PetSkillGroupInfo__PetPreviewWnd> tempGroupInfos, finalGroupInfos;
	local array<PetSkillSlotInfo__PetPreviewWnd> tempSkillArray;

	i = 0;
	while((i < skillInfos.Length))
	{
		tempInfo = skillInfos[i];
		IconType = tempInfo.SkillInfo.IconType;
		if((IconType < tempGroupInfos.Length))
		{
			tempGroupInfo = tempGroupInfos[IconType];
		}
		else
		{
			tempGroupInfo = defaultGroupInfo;
		}
		tempGroupInfo.Skills.Length = (tempGroupInfo.Skills.Length + 1);
		tempGroupInfo.Skills[(tempGroupInfo.Skills.Length - 1)] = tempInfo;
		tempGroupInfos[IconType] = tempGroupInfo;
		i++;
	}
	i = 0;
	while((i < tempGroupInfos.Length))
	{
		tempGroupInfo = tempGroupInfos[i];
		if((tempGroupInfo.Skills.Length > 0))
		{
			tempSkillArray = tempGroupInfo.Skills;
			// tempSkillArray.Sort(OnSortByOrder);   // array.Sort() unsupported by this compiler
			tempGroupInfo.Skills = tempSkillArray;
			tempGroupInfo.GroupType = i;
			finalGroupInfos[finalGroupInfos.Length] = tempGroupInfo;
		}
		i++;
	}
	outPetSkillGroupInfos = finalGroupInfos;
	return;
}

function UpdateSkillGroupControls()
{
	local int i, wndHeight;
	local PetPreviewWndGroupItem groupItem;

	skillEmptyTextBox.HideWindow();
	i = 0;
	while((i < skillGroupItemList.Length))
	{
		groupItem = skillGroupItemList[i];
		if((i >= _skillGroups.Length))
		{
			groupItem.SetDisable(true);
			i++;
			continue;
		}
		groupItem.SetGroupInfo(_skillGroups[i]);
		groupItem.SetDisable(false);
		wndHeight = (wndHeight + groupItem.Me.GetRect().nHeight);
		if((i > 0))
		{
			groupItem.Me.SetAnchor(skillGroupItemList[(i - 1)].Me.m_WindowNameWithFullPath, "BottomCenter", "TopCenter", 0, 0);
		}
		groupItem.Me.ClearAnchor();
		i++;
	}
	if((_skillGroups.Length == 0))
	{
		skillEmptyTextBox.ShowWindow();
	}
	skillScrollArea.SetScrollHeight(wndHeight);
	return;
}

function SetPetInfoControls()
{
	local L2PetRaceEmblemUIData petEmplemData;
	local UIEventManager.EPetType PetType;
	local PetNameInfo NameInfo;
	local PetLookInfo LookInfo;
	local string Name;

	PetType = EPetType(Class'NWindow.PetAPI'.static.GetPetType(_petPreviewInfo.PetID));
	Class'NWindow.PetAPI'.static.GetPetRaceEmblemData(_petPreviewInfo.PetID, petEmplemData);
	portraitIconTex.SetTexture(petEmplemData.EmblemTexName);
	texPetExp.SetPointPercent(_petPreviewInfo.currentExp, _petPreviewInfo.minExp, _petPreviewInfo.MaxExp);
	txtLvName.SetText(string(_petPreviewInfo.PetLevel));
	txtEvolveStep.SetText(GetSystemString(getInstanceL2Util().GetPetEvolveStepStringId(PetType, _petPreviewInfo.petEnvolveStep)));
	if((_petPreviewInfo.petEnvolveStep > 0))
	{
		Class'NWindow.PetAPI'.static.GetPetEvolveNameInfo(_petPreviewInfo.PetNameID, NameInfo);
		Name = NameInfo.Name;
		Class'NWindow.PetAPI'.static.GetPetEvolveNameInfo(_petPreviewInfo.PetNamePrefixID, NameInfo);
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
	if((_petPreviewInfo.petEvolutionLook > 0))
	{
		Class'NWindow.PetAPI'.static.GetPetEvolveLookInfo(_petPreviewInfo.petEvolutionLook, LookInfo);
	}
	else
	{
		Class'NWindow.PetAPI'.static.GetPetEvolveLookInfo(_petPreviewInfo.petClassID, LookInfo);
	}
	txtRandomStatName.SetText(LookInfo.Name);
	txtRandomStatName.SetTooltipText(LookInfo.Desc);
	if((int(PetType) == 0))
	{
		EvolveTooltip_BTN.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14818)));
	}
	else if((int(PetType) == 1))
	{
		EvolveTooltip_BTN.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14819)));
	}
	return;
}

function UpdateUIControls()
{
	UpdateSkillGroupControls();
	SetPetInfoControls();
	return;
}

function UpdateSkillInfoWnd()
{
	if(Class'InterfaceClassic.PetPreviewInfoWnd'.static.Inst().Me.IsShowWindow())
	{
		Class'InterfaceClassic.PetPreviewInfoWnd'.static.Inst().UpdateSkillInfoControls();
	}
	return;
}

delegate int OnSortByOrder(PetSkillSlotInfo__PetPreviewWnd A, PetSkillSlotInfo__PetPreviewWnd B)
{
	if((A.GroupType != B.GroupType))
	{
		if((A.GroupType < B.GroupType))
		{
			return 0;
		}
		else
		{
			return -1;
		}
	}
	if((A.learned != B.learned))
	{
		if(((A.learned == true) && (B.learned == false)))
		{
			return 0;
		}
		else
		{
			return -1;
		}
	}
	if((A.OrderID != B.OrderID))
	{
		if((A.OrderID < B.OrderID))
		{
			return 0;
		}
		else
		{
			return -1;
		}
	}
	if((A.originalSkillId != B.originalSkillId))
	{
		if((A.originalSkillId < B.originalSkillId))
		{
			return 0;
		}
		else
		{
			return -1;
		}
	}
	return 0;
}

function bool IsActiveTypeSkill(int OperateType)
{
	return !IsPassiveTypeSkill(OperateType);
}

function bool IsPassiveTypeSkill(int OperateType)
{
	if((OperateType == 2))
	{
		return true;
	}
	return false;
}

function Rq_C_EX_LOAD_PET_PREVIEW_BY_SID(int ServerID, int bWorldRaidServer)
{
	local array<byte> stream;
	local UIPacket._C_EX_LOAD_PET_PREVIEW_BY_SID packet;

	packet.nPetCollarServerId = ServerID;
	packet.bIsInWorldServer = byte(bWorldRaidServer);
	Debug(("Rq_C_EX_LOAD_PET_PREVIEW_BY_SID" @ string(ServerID)));
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_LOAD_PET_PREVIEW_BY_SID(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(912, stream);
	return;
}

function Rq_C_EX_LOAD_PET_PREVIEW_BY_DBID(int DBId)
{
	local array<byte> stream;
	local UIPacket._C_EX_LOAD_PET_PREVIEW_BY_DBID packet;

	packet.nPetCollarDBId = DBId;
	Debug(("Rq_C_EX_LOAD_PET_PREVIEW_BY_SID" @ string(DBId)));
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_LOAD_PET_PREVIEW_BY_DBID(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(913, stream);
	return;
}

function Rs_EV_RequestShowXMLDetailTooltip(string param)
{
	local ItemInfo ItemInfo;
	local int ClassID, itemServerID, itemDBID, bWorldRaidServer;

	ParseInt(param, "classID", ClassID);
	ItemInfo = GetItemInfoByClassID(ClassID);
	ParseInt(param, "ServerID", itemServerID);
	ParseInt(param, "Reserved", itemDBID);
	if((int(byte(ItemInfo.EtcItemType)) != 7))
	{
		return;
	}
	if(((itemServerID <= 0) && (itemDBID <= 0)))
	{
		return;
	}
	Me.HideWindow();
	ResetPetPreviewInfo();
	_petPreviewInfo.ItemClassID = ClassID;
	_petPreviewInfo.itemServerID = itemServerID;
	_petPreviewInfo.itemDBID = itemDBID;
	ParseInt(param, "PetId", _petPreviewInfo.PetID);
	ParseInt(param, "PetEvolveStep", _petPreviewInfo.petEnvolveStep);
	ParseInt(param, "PetNamePrefixID", _petPreviewInfo.PetNamePrefixID);
	ParseInt(param, "PetNameID", _petPreviewInfo.PetNameID);
	ParseInt(param, "Enchanted", _petPreviewInfo.PetLevel);
	ParseInt(param, "WorldRaidServer", bWorldRaidServer);
	if((itemServerID > 0))
	{
		Rq_C_EX_LOAD_PET_PREVIEW_BY_SID(_petPreviewInfo.itemServerID, bWorldRaidServer);
	}
	else if((itemDBID > 0))
	{
		Rq_C_EX_LOAD_PET_PREVIEW_BY_DBID(_petPreviewInfo.itemDBID);
	}
	return;
}

function Rs_EV_PetPreview(string param)
{
	ParseInt(param, "PetID", _petPreviewInfo.PetID);
	ParseInt(param, "PetCollarServerID", _petPreviewInfo.itemServerID);
	ParseInt(param, "PetCollarDBID", _petPreviewInfo.itemDBID);
	ParseInt(param, "ClassID", _petPreviewInfo.petClassID);
	ParseInt(param, "EvolutionLook", _petPreviewInfo.petEvolutionLook);
	ParseINT64(param, "PetExp", _petPreviewInfo.currentExp);
	ParseINT64(param, "MinExp", _petPreviewInfo.minExp);
	ParseINT64(param, "MaxExp", _petPreviewInfo.MaxExp);
	return;
}

function Rs_EV_StartPetPreviewSkill(string param)
{
	ResetSkillGroupInfo();
	return;
}

function Rs_EV_PetPreviewSkill(string param)
{
	local int ClassID, Level, MinLevel, MaxLevel, replaceSkillId;
	local SkillInfo SkillInfo, replaceSkillInfo;
	local PetSkillSlotInfo__PetPreviewWnd skillSlotInfo;

	ParseInt(param, "ClassID", ClassID);
	ParseInt(param, "Level", Level);
	ParseInt(param, "ReplaceID", replaceSkillId);
	ParseInt(param, "MinLevel", MinLevel);
	ParseInt(param, "MaxLevel", MaxLevel);
	if(!GetSkillInfo(ClassID, Level, 0, SkillInfo))
	{
		return;
	}
	if((SkillInfo.MagicType == 8))
	{
		return;
	}
	if(((replaceSkillId > 0) && GetSkillInfo(replaceSkillId, Level, 0, replaceSkillInfo)))
	{
		SkillInfo = replaceSkillInfo;
		skillSlotInfo.OrderID = replaceSkillInfo.OrderID;
		skillSlotInfo.GroupType = replaceSkillInfo.GroupType;
	}
	skillSlotInfo.originalSkillId = ClassID;
	skillSlotInfo.SkillInfo = SkillInfo;
	skillSlotInfo.learned = true;
	Class'InterfaceClassic.L2Util'.static.GetSkill2ItemInfo(SkillInfo, skillSlotInfo.skillItemInfo);
	skillSlotInfo.OrderID = SkillInfo.OrderID;
	skillSlotInfo.GroupType = SkillInfo.GroupType;
	skillSlotInfo.replaceSkillId = replaceSkillId;
	skillSlotInfo.MinLevel = MinLevel;
	skillSlotInfo.isCanLevelUp = false;
	skillSlotInfo.MaxLevel = MaxLevel;
	skillSlotInfo.skillItemInfo.iSkillDisabled = GetSkillAvailability(ClassID, Level, 0);
	skillSlotInfo.isActiveSkill = IsActiveTypeSkill(SkillInfo.OperateType);
	if((SkillInfo.IconType == 8))
	{
		skillSlotInfo.skillItemInfo.ShortcutType = 7;
	}
	_totalSkillInfos[_totalSkillInfos.Length] = skillSlotInfo;
	return;
}

function Rs_EV_EndPetPreviewSkill(string param)
{
	local int i, j;
	local array<PetAcquireSkillInfo> acquireSkillList;
	local SkillInfo SkillInfo;
	local PetAcquireSkillInfo acquireSkillInfo;
	local PetSkillSlotInfo__PetPreviewWnd skillSlotInfo;
	local bool isFound;

	if((_totalSkillInfos.Length == 0))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(14564));
		return;
	}
	Class'NWindow.PetAPI'.static.GetPetAcquireSkillList(_petPreviewInfo.PetID, _petPreviewInfo.PetLevel, _petPreviewInfo.petEnvolveStep, acquireSkillList);
	i = 0;
	while((i < acquireSkillList.Length))
	{
		acquireSkillInfo = acquireSkillList[i];
		if(!GetSkillInfo(acquireSkillInfo.SkillID, acquireSkillInfo.SkillLevel, 0, SkillInfo))
		{
			i++;
			continue;
		}
		isFound = false;
		j = 0;
		while((j < _totalSkillInfos.Length))
		{
			skillSlotInfo = _totalSkillInfos[j];
			if((skillSlotInfo.originalSkillId == acquireSkillInfo.SkillID))
			{
				if((skillSlotInfo.MaxLevel != skillSlotInfo.SkillInfo.SkillLevel))
				{
					if(((_petPreviewInfo.PetLevel >= acquireSkillInfo.NeedPetLevel) && (_petPreviewInfo.petEnvolveStep >= acquireSkillInfo.NeedPetEvolveStep)))
					{
						skillSlotInfo.isCanLevelUp = true;
						_totalSkillInfos[j] = skillSlotInfo;
					}
				}
				isFound = true;
				break;
			}
			j++;
		}
		if((isFound == false))
		{
			skillSlotInfo.originalSkillId = acquireSkillInfo.SkillID;
			skillSlotInfo.SkillInfo = SkillInfo;
			skillSlotInfo.learned = false;
			Class'InterfaceClassic.L2Util'.static.GetSkill2ItemInfo(SkillInfo, skillSlotInfo.skillItemInfo);
			skillSlotInfo.OrderID = SkillInfo.OrderID;
			skillSlotInfo.GroupType = SkillInfo.GroupType;
			skillSlotInfo.MinLevel = acquireSkillInfo.SkillMinLevel;
			skillSlotInfo.MaxLevel = acquireSkillInfo.SkillMaxLevel;
			skillSlotInfo.isActiveSkill = IsActiveTypeSkill(SkillInfo.OperateType);
			skillSlotInfo.replaceSkillId = -1;
			if(((_petPreviewInfo.PetLevel >= acquireSkillInfo.NeedPetLevel) && (_petPreviewInfo.petEnvolveStep >= acquireSkillInfo.NeedPetEvolveStep)))
			{
				skillSlotInfo.isCanLevelUp = true;
			}
			else
			{
				skillSlotInfo.isCanLevelUp = false;
			}
			_totalSkillInfos[_totalSkillInfos.Length] = skillSlotInfo;
		}
		i++;
	}
	UpdateSkillInfos();
	UpdateUIControls();
	UpdateSkillGroupControls();
	Me.ShowWindow();
	return;
}

event OnRegisterEvent()
{
	if((IsUseRenewalSkillWnd() == false))
	{
		return;
	}
	RegisterEvent(11555);
	RegisterEvent(11660);
	RegisterEvent(11661);
	RegisterEvent(11662);
	RegisterEvent(11663);
	return;
}

event OnEvent(int EventID, string param)
{
	if((IsUseRenewalSkillWnd() == false))
	{
		return;
	}
	switch(EventID)
	{
		case 11555:
			Rs_EV_RequestShowXMLDetailTooltip(param);
			break;
		case 11660:
			Rs_EV_PetPreview(param);
			break;
		case 11661:
			Rs_EV_StartPetPreviewSkill(param);
			break;
		case 11662:
			Rs_EV_PetPreviewSkill(param);
			break;
		case 11663:
			Rs_EV_EndPetPreviewSkill(param);
			break;
		default:
			break;
	}
	return;
}

event OnClickButton(string btnName)
{
	switch(btnName)
	{
		case "HelpBtn":
			Class'InterfaceClassic.HelpWnd'.static.ShowHelp(15, 1);
			break;
		default:
			break;
	}
	return;
}

event OnPetSkillSlotInfoClicked(PetSkillSlotInfo__PetPreviewWnd skillSlotInfo)
{
	Class'InterfaceClassic.PetPreviewInfoWnd'.static.Inst().OpenWindow(skillSlotInfo);
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

event OnShow()
{
	Me.SetFocus();
	return;
}

event OnHide()
{
	Class'InterfaceClassic.PetPreviewInfoWnd'.static.Inst().Me.HideWindow();
	Class'InterfaceClassic.PetPreviewInfoWnd'.static.Inst().OnHide();
	ResetInfo();
	return;
}

event OnReceivedCloseUI()
{
	if(Class'InterfaceClassic.PetPreviewInfoWnd'.static.Inst().Me.IsShowWindow())
	{
		Class'InterfaceClassic.PetPreviewInfoWnd'.static.Inst().OnReceivedCloseUI();
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		Me.HideWindow();
	}
	return;
}
