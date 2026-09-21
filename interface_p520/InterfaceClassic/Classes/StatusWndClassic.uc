class StatusWndClassic extends StatusWnd;

var CharacterViewportWindowHandle myHeadCharacterViewport;
var ItemInfo currentWeaponInfo;
var string ClassName;

event OnLoad()
{
	InitHandleCOD();
	bFirstUpdate = false;
	GlobalAlpha = 0;
	GlobalAlphaBool = true;
	InitAnimation();
	MaxVitality = GetMaxVitality();
	nCombatOnOff = 0;
	CombatIcon_Tex.SetTooltipCustomType(combatTooltip());
	InitWPEffectAnimation();
	myHeadCharacterViewport = GetCharacterViewportWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".myHeadCharacterViewport"));
	myHeadCharacterViewport.SetHideEquipItem(true, false, false);
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".portraitSetterBtn")).HideWindow();
	if((IsBuilderPC() && (int(GetReleaseMode()) == 0)))
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".portraitSetterBtn")).ShowWindow();
	}
	return;
}

event OnRegisterEvent()
{
	super.OnRegisterEvent();
	RegisterEvent(3810);
	RegisterEvent(2610);
	RegisterEvent(181);
	return;
}

event OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 3810:
			HandleChangeCharacterPawn(a_Param);
			break;
		case 2610:
		case 181:
			HandleUpdateItem();
			break;
		default:
			if(getInstanceUIData().GetIsClassicServer())
			{
				EachServerEvent(a_EventID, a_Param);
			}
	}
	return;
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "portraitSetterBtn":
			GetWindowHandle("UIPortraitSetter").ShowWindow();
			UIPortraitSetter(GetScript("UIPortraitSetter"))._SetCurrentUserInfo(myHeadCharacterViewport);
			break;
		default:
			break;
	}
	return;
}

function toggleCombatMode(string paramStr, optional bool bUseGfxScreenMessage)
{
	local int prevNCombatOnOff;

	prevNCombatOnOff = nCombatOnOff;
	super.toggleCombatMode(paramStr, bUseGfxScreenMessage);
	if((nCombatOnOff == prevNCombatOnOff))
	{
		return;
	}
	if((nCombatOnOff < 1))
	{
		return;
	}
	GetEffectViewportWndHandle("StatusWndClassic.CombatIconEffectViewport").SpawnEffect("LineageEffect2.h_DK_hellfire_C_ra");
	return;
}

function HandleUpdateItem()
{
	local ItemInfo currentWeaponInfoTmp;

	if((m_hOwnerWnd.IsShowWindow() == false))
	{
		return;
	}
	currentWeaponInfoTmp = GetCurrentWeaponInfo();
	if((currentWeaponInfo.Id.ServerID == currentWeaponInfoTmp.Id.ServerID))
	{
		return;
	}
	Debug(((((" 무기 전환 : WeaponTypeCompare" @ string(currentWeaponInfoTmp.WeaponType)) @ string(currentWeaponInfoTmp.SlotBitType)) @ string(currentWeaponInfoTmp.ItemType)) @ ClassName));  // EN?: Weapon Switch: WeaponTypeCompare
	currentWeaponInfo = currentWeaponInfoTmp;
	ChangeCharacterPawnOption();
	return;
}

function bool IsWeaponType_Dual()
{
	switch(byte(currentWeaponInfo.WeaponType))
	{
		case 13:
		case 23:
		case 20:
			return true;
		default:
			return false;
	}
}

function bool IsWeaponType_Bow()
{
	return (int(byte(currentWeaponInfo.WeaponType)) == 11);
}

function ChangeCharacterPawnOption()
{
	switch(ClassName)
	{
		case "MFighter":
			myHeadCharacterViewport.SetCameraDistance(210);
			myHeadCharacterViewport.SetCurrentRotation(32800);
			myHeadCharacterViewport.SetCameraPitch(0);
			myHeadCharacterViewport.SetCharacterOffsetX(-26);
			myHeadCharacterViewport.SetCharacterOffsetY(28);
			myHeadCharacterViewport.SetCharacterOffsetZ(0);
			break;
		case "FFighter":
			myHeadCharacterViewport.SetCameraDistance(210);
			myHeadCharacterViewport.SetCurrentRotation(33500);
			myHeadCharacterViewport.SetCameraPitch(0);
			myHeadCharacterViewport.SetCharacterOffsetX(-45);
			myHeadCharacterViewport.SetCharacterOffsetY(24);
			myHeadCharacterViewport.SetCharacterOffsetZ(-2);
			break;
		case "MMagic":
			myHeadCharacterViewport.SetCameraDistance(210);
			myHeadCharacterViewport.SetCurrentRotation(33150);
			myHeadCharacterViewport.SetCameraPitch(1182);
			myHeadCharacterViewport.SetCharacterOffsetX(-43);
			myHeadCharacterViewport.SetCharacterOffsetY(28);
			myHeadCharacterViewport.SetCharacterOffsetZ(0);
			break;
		case "FMagic":
			myHeadCharacterViewport.SetCameraDistance(195);
			myHeadCharacterViewport.SetCurrentRotation(33425);
			myHeadCharacterViewport.SetCameraPitch(0);
			myHeadCharacterViewport.SetCharacterOffsetX(-48);
			myHeadCharacterViewport.SetCharacterOffsetY(21);
			myHeadCharacterViewport.SetCharacterOffsetZ(0);
			break;
		case "MElf":
			myHeadCharacterViewport.SetCameraDistance(210);
			myHeadCharacterViewport.SetCurrentRotation(32500);
			myHeadCharacterViewport.SetCameraPitch(0);
			myHeadCharacterViewport.SetCharacterOffsetX(-29);
			myHeadCharacterViewport.SetCharacterOffsetY(26);
			myHeadCharacterViewport.SetCharacterOffsetZ(2);
			break;
		case "FElf":
			myHeadCharacterViewport.SetCameraDistance(210);
			myHeadCharacterViewport.SetCurrentRotation(31320);
			myHeadCharacterViewport.SetCameraPitch(2532);
			myHeadCharacterViewport.SetCharacterOffsetX(-46);
			myHeadCharacterViewport.SetCharacterOffsetY(34);
			myHeadCharacterViewport.SetCharacterOffsetZ(7);
			break;
		case "MDarkElf":
			myHeadCharacterViewport.SetCameraDistance(210);
			myHeadCharacterViewport.SetCurrentRotation(34100);
			myHeadCharacterViewport.SetCameraPitch(1900);
			myHeadCharacterViewport.SetCharacterOffsetX(-16);
			myHeadCharacterViewport.SetCharacterOffsetY(29);
			myHeadCharacterViewport.SetCharacterOffsetZ(-3);
			break;
		case "FDarkElf":
			myHeadCharacterViewport.SetCameraDistance(210);
			myHeadCharacterViewport.SetCurrentRotation(33425);
			myHeadCharacterViewport.SetCameraPitch(2195);
			myHeadCharacterViewport.SetCharacterOffsetX(-29);
			myHeadCharacterViewport.SetCharacterOffsetY(31);
			myHeadCharacterViewport.SetCharacterOffsetZ(-1);
			break;
		case "MOrc":
			myHeadCharacterViewport.SetCameraDistance(210);
			myHeadCharacterViewport.SetCurrentRotation(33200);
			myHeadCharacterViewport.SetCameraPitch(0);
			myHeadCharacterViewport.SetCharacterOffsetX(-9);
			myHeadCharacterViewport.SetCharacterOffsetY(28);
			myHeadCharacterViewport.SetCharacterOffsetZ(-1);
			break;
		case "MOrc_Rider":
			myHeadCharacterViewport.SetCameraDistance(232);
			myHeadCharacterViewport.SetCurrentRotation(33200);
			myHeadCharacterViewport.SetCameraPitch(0);
			myHeadCharacterViewport.SetCharacterOffsetX(-18);
			myHeadCharacterViewport.SetCharacterOffsetY(41);
			myHeadCharacterViewport.SetCharacterOffsetZ(0);
			break;
		case "FOrc":
			myHeadCharacterViewport.SetCameraDistance(210);
			myHeadCharacterViewport.SetCurrentRotation(32500);
			myHeadCharacterViewport.SetCameraPitch(0);
			myHeadCharacterViewport.SetCharacterOffsetX(-20);
			myHeadCharacterViewport.SetCharacterOffsetY(26);
			myHeadCharacterViewport.SetCharacterOffsetZ(2);
			break;
		case "MShaman":
			myHeadCharacterViewport.SetCameraDistance(210);
			myHeadCharacterViewport.SetCurrentRotation(32800);
			myHeadCharacterViewport.SetCameraPitch(0);
			myHeadCharacterViewport.SetCharacterOffsetX(-16);
			myHeadCharacterViewport.SetCharacterOffsetY(27);
			myHeadCharacterViewport.SetCharacterOffsetZ(2);
			break;
		case "FShaman":
			myHeadCharacterViewport.SetCameraDistance(210);
			myHeadCharacterViewport.SetCurrentRotation(34000);
			myHeadCharacterViewport.SetCameraPitch(0);
			myHeadCharacterViewport.SetCharacterOffsetX(-20);
			myHeadCharacterViewport.SetCharacterOffsetY(25);
			myHeadCharacterViewport.SetCharacterOffsetZ(-1);
			break;
		case "MDwarf":
			myHeadCharacterViewport.SetCameraDistance(210);
			myHeadCharacterViewport.SetCurrentRotation(33000);
			myHeadCharacterViewport.SetCameraPitch(0);
			myHeadCharacterViewport.SetCharacterOffsetX(-10);
			myHeadCharacterViewport.SetCharacterOffsetY(21);
			myHeadCharacterViewport.SetCharacterOffsetZ(0);
			break;
		case "FDwarf":
			myHeadCharacterViewport.SetCameraDistance(210);
			myHeadCharacterViewport.SetCurrentRotation(32950);
			myHeadCharacterViewport.SetCameraPitch(0);
			myHeadCharacterViewport.SetCharacterOffsetX(-30);
			myHeadCharacterViewport.SetCharacterOffsetY(20);
			myHeadCharacterViewport.SetCharacterOffsetZ(1);
			break;
		case "MKamael":
			myHeadCharacterViewport.SetCameraDistance(210);
			myHeadCharacterViewport.SetCurrentRotation(33425);
			myHeadCharacterViewport.SetCameraPitch(2500);
			myHeadCharacterViewport.SetCharacterOffsetX(-26);
			myHeadCharacterViewport.SetCharacterOffsetY(32);
			myHeadCharacterViewport.SetCharacterOffsetZ(0);
			break;
		case "FKamael":
			myHeadCharacterViewport.SetCameraDistance(210);
			myHeadCharacterViewport.SetCurrentRotation(32074);
			myHeadCharacterViewport.SetCameraPitch(3039);
			myHeadCharacterViewport.SetCharacterOffsetX(-25);
			myHeadCharacterViewport.SetCharacterOffsetY(35);
			myHeadCharacterViewport.SetCharacterOffsetZ(1);
			break;
		case "FErtheia":
			myHeadCharacterViewport.SetCameraDistance(210);
			myHeadCharacterViewport.SetCurrentRotation(33500);
			myHeadCharacterViewport.SetCameraPitch(0);
			myHeadCharacterViewport.SetCharacterOffsetX(-2);
			myHeadCharacterViewport.SetCharacterOffsetY(0);
			myHeadCharacterViewport.SetCharacterOffsetZ(-3);
			break;
		case "MSylph":
			myHeadCharacterViewport.SetCameraDistance(210);
			myHeadCharacterViewport.SetCurrentRotation(33150);
			myHeadCharacterViewport.SetCameraPitch(2532);
			myHeadCharacterViewport.SetCharacterOffsetX(-30);
			myHeadCharacterViewport.SetCharacterOffsetY(29);
			myHeadCharacterViewport.SetCharacterOffsetZ(-1);
			break;
		case "FSylph":
			myHeadCharacterViewport.SetCameraDistance(210);
			myHeadCharacterViewport.SetCurrentRotation(33000);
			myHeadCharacterViewport.SetCameraPitch(0);
			myHeadCharacterViewport.SetCharacterOffsetX(-46);
			myHeadCharacterViewport.SetCharacterOffsetY(22);
			myHeadCharacterViewport.SetCharacterOffsetZ(-2);
			break;
		case "MHighElf":
			myHeadCharacterViewport.SetCameraDistance(210);
			myHeadCharacterViewport.SetCurrentRotation(32840);
			myHeadCharacterViewport.SetCameraPitch(0);
			myHeadCharacterViewport.SetCharacterOffsetX(-27);
			myHeadCharacterViewport.SetCharacterOffsetY(28);
			myHeadCharacterViewport.SetCharacterOffsetZ(0);
			break;
		case "FHighElf":
			myHeadCharacterViewport.SetCameraDistance(210);
			myHeadCharacterViewport.SetCurrentRotation(35100);
			myHeadCharacterViewport.SetCameraPitch(3000);
			myHeadCharacterViewport.SetCharacterOffsetX(-28);
			myHeadCharacterViewport.SetCharacterOffsetY(35);
			myHeadCharacterViewport.SetCharacterOffsetZ(-7);
			break;
		case "MHuman_DeathKnight":
			myHeadCharacterViewport.SetCameraDistance(210);
			myHeadCharacterViewport.SetCurrentRotation(34200);
			myHeadCharacterViewport.SetCameraPitch(2000);
			myHeadCharacterViewport.SetCharacterOffsetX(-13);
			myHeadCharacterViewport.SetCharacterOffsetY(24);
			myHeadCharacterViewport.SetCharacterOffsetZ(-1);
			break;
		case "MElf_DeathKnight":
			myHeadCharacterViewport.SetCameraDistance(210);
			myHeadCharacterViewport.SetCurrentRotation(32750);
			myHeadCharacterViewport.SetCameraPitch(0);
			myHeadCharacterViewport.SetCharacterOffsetX(-17);
			myHeadCharacterViewport.SetCharacterOffsetY(20);
			myHeadCharacterViewport.SetCharacterOffsetZ(2);
			break;
		case "MDarkElf_DeathKnight":
			myHeadCharacterViewport.SetCameraDistance(210);
			myHeadCharacterViewport.SetCurrentRotation(32800);
			myHeadCharacterViewport.SetCameraPitch(0);
			myHeadCharacterViewport.SetCharacterOffsetX(-21);
			myHeadCharacterViewport.SetCharacterOffsetY(19);
			myHeadCharacterViewport.SetCharacterOffsetZ(2);
			break;
		case "MHuman_DeathFighter":
			break;
		case "MHuman_Assassin":
			myHeadCharacterViewport.SetCameraDistance(210);
			myHeadCharacterViewport.SetCurrentRotation(30000);
			myHeadCharacterViewport.SetCameraPitch(2300);
			myHeadCharacterViewport.SetCharacterOffsetX(-11);
			myHeadCharacterViewport.SetCharacterOffsetY(31);
			myHeadCharacterViewport.SetCharacterOffsetZ(3);
			break;
		case "FDarkElf_Assassin":
			myHeadCharacterViewport.SetCameraDistance(210);
			myHeadCharacterViewport.SetCurrentRotation(31900);
			myHeadCharacterViewport.SetCameraPitch(2400);
			myHeadCharacterViewport.SetCharacterOffsetX(-34);
			myHeadCharacterViewport.SetCharacterOffsetY(33);
			myHeadCharacterViewport.SetCharacterOffsetZ(2);
			break;
		case "FDwarf_Maker":
			break;
		case "MHuman_WereWolf":
			myHeadCharacterViewport.SetCameraDistance(210);
			myHeadCharacterViewport.SetCurrentRotation(32600);
			myHeadCharacterViewport.SetCameraPitch(3200);
			myHeadCharacterViewport.SetCharacterOffsetX(-19);
			myHeadCharacterViewport.SetCharacterOffsetY(32);
			myHeadCharacterViewport.SetCharacterOffsetZ(1);
			break;
		case "transform_wildwolf":
			myHeadCharacterViewport.SetCameraDistance(330);
			myHeadCharacterViewport.SetCurrentRotation(34100);
			myHeadCharacterViewport.SetCameraPitch(5056);
			myHeadCharacterViewport.SetCharacterOffsetX(19);
			myHeadCharacterViewport.SetCharacterOffsetY(21);
			myHeadCharacterViewport.SetCharacterOffsetZ(1);
			break;
		case "FDarkElf_RoseVain":
			myHeadCharacterViewport.SetCameraDistance(210);
			myHeadCharacterViewport.SetCurrentRotation(32550);
			myHeadCharacterViewport.SetCameraPitch(2195);
			myHeadCharacterViewport.SetCharacterOffsetX(-29);
			myHeadCharacterViewport.SetCharacterOffsetY(33);
			myHeadCharacterViewport.SetCharacterOffsetZ(0);
			break;
		default:
			break;
	}
	return;
}

function HandleChangeCharacterPawn(string param)
{
	ParseString(param, "ClassName", ClassName);
	myHeadCharacterViewport = GetCharacterViewportWindowHandle("StatusWndClassic.myHeadCharacterViewport");
	myHeadCharacterViewport.ShowWindow();
	myHeadCharacterViewport.SetCharacterScale(1.0000000);
	ChangeCharacterPawnOption();
	return;
}

function WeaponTypeCompare(ItemInfo iInfoA)
{
	Debug((((" 무기 전환 : WeaponTypeCompare" @ string(iInfoA.WeaponType)) @ string(iInfoA.SlotBitType)) @ string(iInfoA.ItemType)));  // EN?: Weapon Switch: WeaponTypeCompare
	return;
}

function ItemInfo GetCurrentWeaponInfo()
{
	local ItemInfo currentWeaponInfo;
	local InventoryWnd invenScr;

	invenScr = InventoryWnd(GetScript("InventoryWnd"));
	invenScr.m_equipItem[5].GetItem(0, currentWeaponInfo);
	return currentWeaponInfo;
}

defaultproperties
{
	m_Windowname="StatusWndClassic"
}
