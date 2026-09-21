class ShortcutWndArena extends UICommonAPI;

const MAX_Page = 2;
const MAX_ShortcutPerPage = 12;
const SKILLID_NONE = 0;
const SKILLID_ADD = 1;
const SKILLID_UPDATE = 2;
const SKILLID_REMOVE = 3;
const SKILLLINE_DRAGON = 10;
const SKILLLINE_DRAGONSLAYER = 11;

var WindowHandle Me;
var AnimTextureHandle SlotEffect_Ani;
var AnimTextureHandle PlusEffect_Ani;
var array<int> skillShortIDs;
var array<int> skillClassIDs;
var int currentUpgraeSkillID;
var string upgradeSkillShortcutName;
var bool preIsLockFlag;
var int currentPage0;

function OnRegisterEvent()
{
	RegisterEvent(630);
	RegisterEvent(640);
	RegisterEvent(650);
	RegisterEvent(91);
	RegisterEvent(693);
	RegisterEvent(5090);
	RegisterEvent(5091);
	RegisterEvent(180);
	return;
}

function OnShow()
{
	currentPage0 = 1;
	handleTransform();
	preIsLockFlag = GetOptionBool("Game", "IsLockShortcutWnd");
	SetOptionBool("Game", "IsLockShortcutWnd", true);
	return;
}

function OnHide()
{
	SetOptionBool("Game", "IsLockShortcutWnd", preIsLockFlag);
	return;
}

function OnLoad()
{
	local ToolTip Script;

	if(!getInstanceUIData().getIsArenaServer())
	{
		return;
	}
	Script = ToolTip(GetScript("Tooltip"));
	Script.setBoolSelect(true);
	Me = GetWindowHandle("ShortcutWndArena");
	SlotEffect_Ani = GetAnimTextureHandle("ShortcutWndArena.SlotEffect_Ani");
	PlusEffect_Ani = GetAnimTextureHandle("ShortcutWndArena.PlusEffect_Ani");
	handleNotUseShortcut();
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	if(!getInstanceUIData().getIsArenaServer())
	{
		return;
	}
	switch(a_EventID)
	{
		case 91:
			ExecuteShortcutCommandBySlot(a_Param);
			break;
		case 640:
			HandleShortcutPageUpdate(a_Param);
			break;
		case 630:
			HandleShortcutUpdate(a_Param);
			break;
		case 650:
			HandleShortcutClear();
			handleSetShortcutID();
			break;
		case 693:
		case 5090:
		case 5091:
			ClearAllShortcutItemTooltip();
			Class'NWindow.ShortcutWndAPI'.static.SetShortcutPage(0);
			Class'NWindow.ShortcutWndAPI'.static.SetShortcutPage(currentPage0);
			break;
		case 180:
			handleTransform();
			break;
		default:
			break;
	}
	return;
}

function handleSetShortcutID()
{
	local int i;

	i = 0;
	while((i < 12))
	{
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(("ShortcutWndArena.ShortcutWndHorizontalArena_0.Shortcut" $ string((i + 1))), i);
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(("ShortcutWndArena.ShortcutWndHorizontalArena_1.Shortcut" $ string((i + 1))), (i + 12));
		++i;
	}
	return;
}

function OnCallUCFunction(string Id, string param)
{
	handleSkillUpgrade(int(param));
	return;
}

function handleTransform()
{
	local UserInfo Info;

	if(GetPlayerInfo(Info))
	{
		if((currentPage0 != 1))
		{
			if((Info.nTransformID == 0))
			{
				SetCurPage0(1);
			}
		}
		else
		{
			switch(Info.nTransformID)
			{
				case 11:
					SetCurPage0(11);
					break;
				case 10:
					SetCurPage0(10);
					break;
				default:
					break;
			}
		}
	}
	return;
}

function SetCurPage0(int newPage)
{
	currentPage0 = newPage;
	Class'NWindow.ShortcutWndAPI'.static.SetShortcutPage(0);
	Class'NWindow.ShortcutWndAPI'.static.SetShortcutPage(currentPage0);
	return;
}

function skillUpgradeHide()
{
	SlotEffect_Ani.HideWindow();
	PlusEffect_Ani.HideWindow();
	return;
}

function skillUpgradeShow(string shortcutName)
{
	upgradeSkillShortcutName = shortcutName;
	if((shortcutName == ""))
	{
		return;
	}
	SlotEffect_Ani.ShowWindow();
	PlusEffect_Ani.ShowWindow();
	setAnchorShortcut(shortcutName);
	return;
}

function handleSkillUpgrade(int ClassID)
{
	local int idx;

	currentUpgraeSkillID = ClassID;
	idx = getSkillShortcutIdxByClassID(currentUpgraeSkillID);
	if(((currentUpgraeSkillID == -1) || (idx == -1)))
	{
		skillUpgradeHide();
	}
	else
	{
		skillUpgradeShow(handleGetShortcutName(skillShortIDs[idx]));
	}
	return;
}

function setAnchorShortcut(string shortcutName)
{
	SlotEffect_Ani.Play();
	PlusEffect_Ani.SetLoopCount(999);
	PlusEffect_Ani.Play();
	SlotEffect_Ani.SetAnchor(shortcutName, "CenterCenter", "CenterCenter", 0, 0);
	PlusEffect_Ani.SetAnchor(shortcutName, "CenterCenter", "CenterCenter", 0, 0);
	return;
}

function string handleGetShortcutName(int nShortcutID)
{
	local string shortcutName;
	local int ShortcutPage, nShortcutNum;

	nShortcutNum = (int((float(nShortcutID) % 12.0000000)) + 1);
	ShortcutPage = (nShortcutID / 12);
	if((ShortcutPage == currentPage0))
	{
		ShortcutPage = 1;
	}
	if(((ShortcutPage < 0) || (ShortcutPage >= 2)))
	{
		return "";
	}
	shortcutName = (makeShortcutPathName(ShortcutPage) $ string(nShortcutNum));
	return shortcutName;
}

function string makeShortcutPathName(int shortcutLine)
{
	return (("ShortcutWndArena.ShortcutWndHorizontalArena_" $ string(shortcutLine)) $ ".Shortcut");
}

function int getSkillShortcutHandleType(int idx, UIEventManager.EShortCutItemType ShortcutType)
{
	local bool isSkillID;

	isSkillID = (2 == int(ShortcutType));
	if((isSkillID && (idx == -1)))
	{
		return 1;
	}
	if(isSkillID)
	{
		return 2;
	}
	if((idx != -1))
	{
		return 3;
	}
	return 0;
}

function setSkillID(string param, int nShortcutID, string shortcutName)
{
	local int ClassID, idx, ShortcutType, Type;
	local bool isUpgradeSkill;

	ParseInt(param, "ShortcutType", ShortcutType);
	idx = getSkillArrIndexByShortcutID(nShortcutID);
	Type = getSkillShortcutHandleType(idx, EShortCutItemType(ShortcutType));
	ParseInt(param, "ClassID", ClassID);
	isUpgradeSkill = (currentUpgraeSkillID == ClassID);
	switch(Type)
	{
		case 1:
			skillIDAdd(nShortcutID, ClassID);
			if(isUpgradeSkill)
			{
				skillUpgradeShow(shortcutName);
			}
			break;
		case 2:
			skillIDUpdate(nShortcutID, ClassID, idx);
			if(isUpgradeSkill)
			{
				skillUpgradeShow(shortcutName);
			}
			break;
		case 3:
			skillIDRemove(idx);
			break;
		default:
			break;
	}
	return;
}

function int getSkillShortcutIdxByClassID(int ClassID)
{
	local int i;

	i = 0;
	while((i < skillClassIDs.Length))
	{
		if((skillClassIDs[i] == ClassID))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function int getSkillArrIndexByShortcutID(int ShortcutID)
{
	local int i;

	i = 0;
	while((i < skillShortIDs.Length))
	{
		if((skillShortIDs[i] == ShortcutID))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function skillIDRemove(int idx)
{
	local bool isUpgradeSkill, isMineSkill;

	isUpgradeSkill = (skillClassIDs[idx] == currentUpgraeSkillID);
	isMineSkill = (upgradeSkillShortcutName == handleGetShortcutName(skillShortIDs[idx]));
	isMineSkill = (isMineSkill && (upgradeSkillShortcutName != ""));
	skillClassIDs.Remove(idx, 1);
	skillShortIDs.Remove(idx, 1);
	if(isUpgradeSkill)
	{
		idx = getSkillShortcutIdxByClassID(currentUpgraeSkillID);
		if((idx == -1))
		{
			skillUpgradeHide();
		}
		else if(isMineSkill)
		{
			skillUpgradeShow(handleGetShortcutName(skillShortIDs[idx]));
		}
	}
	return;
}

function skillIDUpdate(int ShortcutID, int ClassID, int idx)
{
	skillShortIDs[idx] = ShortcutID;
	skillClassIDs[idx] = ClassID;
	return;
}

function skillIDAdd(int ShortcutID, int ClassID)
{
	local int idx;

	idx = skillClassIDs.Length;
	skillShortIDs.Length = (idx + 1);
	skillClassIDs.Length = skillShortIDs.Length;
	skillShortIDs[idx] = ShortcutID;
	skillClassIDs[idx] = ClassID;
	return;
}

function ClearAllShortcutItemTooltip()
{
	Me.ClearAllChildShortcutItemTooltip();
	return;
}

function HandleShortcutPageUpdate(string param)
{
	local int i, nstartShortcutID, ShortcutPage;
	local string shortcutPath;

	if(ParseInt(param, "ShortcutPage", ShortcutPage))
	{
		if((currentPage0 == ShortcutPage))
		{
			shortcutPath = makeShortcutPathName(1);
		}
		else if(((ShortcutPage >= 2) || (0 > ShortcutPage)))
		{
			return;
		}
		else
		{
			shortcutPath = makeShortcutPathName(ShortcutPage);
		}
		nstartShortcutID = (ShortcutPage * 12);
		i = 0;
		while((i < 12))
		{
			Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut((shortcutPath $ string((i + 1))), (nstartShortcutID + i));
			++i;
		}
	}
	return;
}

function HandleShortcutUpdate(string param)
{
	local int nShortcutID;
	local string shortcutName;

	ParseInt(param, "ShortcutID", nShortcutID);
	if((nShortcutID < 0))
	{
		return;
	}
	shortcutName = handleGetShortcutName(nShortcutID);
	setSkillID(param, nShortcutID, shortcutName);
	if((shortcutName != ""))
	{
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(shortcutName, nShortcutID);
	}
	return;
}

function HandleShortcutClear()
{
	local int i;

	skillClassIDs.Length = 0;
	skillShortIDs.Length = 0;
	currentUpgraeSkillID = -1;
	skillUpgradeHide();
	i = 0;
	while((i < 12))
	{
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear(("ShortcutWndArena.ShortcutWndHorizontalArena_0.Shortcut" $ string((i + 1))));
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear(("ShortcutWndArena.ShortcutWndHorizontalArena_1.Shortcut" $ string((i + 1))));
		++i;
	}
	return;
}

function ExecuteShortcutCommandBySlot(string param)
{
	local int Slot;

	ParseInt(param, "Slot", Slot);
	if(Me.IsShowWindow())
	{
		if((Slot >= 12))
		{
			Slot = (((currentPage0 - 1) * 12) + Slot);
		}
		else if((Slot < 0))
		{
			return;
		}
		Class'NWindow.ShortcutWndAPI'.static.ExecuteShortcutBySlot(Slot);
	}
	return;
}

function handleNotUseShortcut()
{
	local string shortcutPath;

	shortcutPath = makeShortcutPathName(0);
	GetWindowHandle((shortcutPath $ "1")).HideWindow();
	GetWindowHandle((shortcutPath $ "2")).HideWindow();
	GetWindowHandle((shortcutPath $ "3")).HideWindow();
	GetWindowHandle((shortcutPath $ "9")).HideWindow();
	GetWindowHandle((shortcutPath $ "10")).HideWindow();
	GetWindowHandle((shortcutPath $ "12")).HideWindow();
	GetWindowHandle((makeShortcutPathName(1) $ "12")).HideWindow();
	return;
}
