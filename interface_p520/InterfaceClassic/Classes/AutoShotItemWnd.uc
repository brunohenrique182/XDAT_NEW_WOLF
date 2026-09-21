class AutoShotItemWnd extends UICommonAPI;

const ITEM_ADD = 1;
const ITEM_SET = 2;
const ITEM_CLEAR = 3;
const TIME_ID = 30021;
const TIME_DELAY = 5000;

struct slotData
{
	var bool bNoticeShow;
	var string tooltipStr;
};

var WindowHandle Me;
var WindowHandle AutoShotItemSubWnd;
var int PetID;
var int SummonID;
var TextureHandle petIconHorTex;
var TextureHandle petIconVerTex;
var bool hasWeapon;
var bool bSummon;
var bool bPet;
var bool bBeforeSummon;
var bool bBeforePet;
var int showNoticeNum;
var int currentSelectSoulShotWndIndex;
var ItemInfo weaponItemInfo;
var ItemInfo beforeWeaponInfo;
var ShortcutWnd ShortcutWndScript;
var AutoPotionWnd AutoPotionWndScript;
var YetiPCModeChangeWnd YetiPCModeChangeWndScript;

function OnRegisterEvent()
{
	RegisterEvent(20180);
	RegisterEvent(20182);
	RegisterEvent(2610);
	RegisterEvent(2600);
	RegisterEvent(40);
	RegisterEvent(693);
	RegisterEvent(9750);
	return;
}

function OnLoad()
{
	Initialize();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("AutoShotItemWnd");
	AutoShotItemSubWnd = GetWindowHandle("AutoShotItemWnd.AutoShotItemSubWnd");
	ShortcutWndScript = ShortcutWnd(GetScript("ShortcutWnd"));
	AutoPotionWndScript = AutoPotionWnd(GetScript("AutoPotionWnd"));
	YetiPCModeChangeWndScript = YetiPCModeChangeWnd(GetScript("YetiPCModeChangeWnd"));
	petIconHorTex = GetTextureHandle("AutoShotItemWnd.AutoShotItemWnd_HorWnd.PetSlotGroupWnd_HorWnd.header_pet_horTexture");
	petIconVerTex = GetTextureHandle("AutoShotItemWnd.AutoShotItemWnd_VerWnd.PetSlotGroupWnd_VerWnd.header_pet_VerTexture");
	Init();
	return;
}

function CustomTooltip SetTooltip(string Text)
{
	local CustomTooltip ToolTip;
	local DrawItemInfo Info;

	ToolTip.MinimumWidth = 144;
	ToolTip.DrawList.Length = 1;
	Info.eType = DIT_TEXT;
	Info.t_color.R = 178;
	Info.t_color.G = 190;
	Info.t_color.B = 207;
	Info.t_color.A = 255;
	Info.t_strText = Text;
	ToolTip.DrawList[0] = Info;
	return ToolTip;
}

function Init()
{
	local int i;
	local ItemInfo tempInfo;

	i = 1;
	while((i < 5))
	{
		GetItemWindowHandle(("AutoShotItemWnd.AutoShotItemWnd_HorWnd.ShotItemSlot" $ string(i))).Clear();
		GetItemWindowHandle(("AutoShotItemWnd.AutoShotItemWnd_VerWnd.ShotItemSlot" $ string(i))).Clear();
		if(((i == 1) || (i == 2)))
		{
			GetItemWindowHandle(("AutoShotItemWnd.AutoShotItemWnd_HorWnd.ShotItemSlot" $ string(i))).SetTooltipText(GetSystemMessage(6828));
			GetItemWindowHandle(("AutoShotItemWnd.AutoShotItemWnd_VerWnd.ShotItemSlot" $ string(i))).SetTooltipText(GetSystemMessage(6828));
			i++;
			continue;
		}
		if(IsAdenServer())
		{
			GetTextureHandle("AutoShotItemWnd.AutoShotItemWnd_HorWnd.PetSlotGroupWnd_HorWnd.shotbg_PetWarrior_horTexture").SetTexture("L2UI_ct1.AutoShotItemWnd.shotbg_WeaponWarrior");
			GetTextureHandle("AutoShotItemWnd.AutoShotItemWnd_HorWnd.PetSlotGroupWnd_HorWnd.shotbg_PetMagic_horTexture").SetTexture("L2UI_ct1.AutoShotItemWnd.shotbg_WeaponMagic");
			GetTextureHandle("AutoShotItemWnd.AutoShotItemWnd_VerWnd.PetSlotGroupWnd_VerWnd.shotbg_PetWarrior_VerTexture").SetTexture("L2UI_ct1.AutoShotItemWnd.shotbg_WeaponWarrior");
			GetTextureHandle("AutoShotItemWnd.AutoShotItemWnd_VerWnd.PetSlotGroupWnd_VerWnd.shotbg_PetMagic_VerTexture").SetTexture("L2UI_ct1.AutoShotItemWnd.shotbg_WeaponWarrior");
			GetItemWindowHandle(("AutoShotItemWnd.AutoShotItemWnd_HorWnd.ShotItemSlot" $ string(i))).SetTooltipText(GetSystemMessage(6828));
			GetItemWindowHandle(("AutoShotItemWnd.AutoShotItemWnd_VerWnd.ShotItemSlot" $ string(i))).SetTooltipText(GetSystemMessage(6828));
			i++;
			continue;
		}
		GetTextureHandle("AutoShotItemWnd.AutoShotItemWnd_HorWnd.PetSlotGroupWnd_HorWnd.shotbg_PetWarrior_horTexture").SetTexture("L2UI_ct1.AutoShotItemWnd.shotbg_PetWarrior");
		GetTextureHandle("AutoShotItemWnd.AutoShotItemWnd_HorWnd.PetSlotGroupWnd_HorWnd.shotbg_PetMagic_horTexture").SetTexture("L2UI_ct1.AutoShotItemWnd.shotbg_PetMagic");
		GetTextureHandle("AutoShotItemWnd.AutoShotItemWnd_VerWnd.PetSlotGroupWnd_VerWnd.shotbg_PetWarrior_VerTexture").SetTexture("L2UI_ct1.AutoShotItemWnd.shotbg_PetWarrior");
		GetTextureHandle("AutoShotItemWnd.AutoShotItemWnd_VerWnd.PetSlotGroupWnd_VerWnd.shotbg_PetMagic_VerTexture").SetTexture("L2UI_ct1.AutoShotItemWnd.shotbg_PetMagic");
		GetItemWindowHandle(("AutoShotItemWnd.AutoShotItemWnd_HorWnd.ShotItemSlot" $ string(i))).SetTooltipText(GetSystemMessage(6829));
		GetItemWindowHandle(("AutoShotItemWnd.AutoShotItemWnd_VerWnd.ShotItemSlot" $ string(i))).SetTooltipText(GetSystemMessage(6829));
		i++;
	}
	PetID = 0;
	SummonID = 0;
	showNoticeNum = 0;
	hasWeapon = false;
	bBeforeSummon = false;
	bBeforePet = false;
	beforeWeaponInfo = tempInfo;
	weaponItemInfo = tempInfo;
	GetWindowHandle(getSlotPath(false, 1)).HideWindow();
	GetWindowHandle(getSlotPath(true, 1)).HideWindow();
	GetWindowHandle(getSlotPath(false, 3)).HideWindow();
	GetWindowHandle(getSlotPath(true, 3)).HideWindow();
	HideWindow("AutoShotItemWnd.AutoShotItemSubWnd");
	Me.HideWindow();
	Me.KillTimer(30021);
	return;
}

function OnShow()
{
	windowPositionAutoMove();
	return;
}

function OnDefaultPosition()
{
	windowPositionAutoMove();
	checkSlotShowState();
	return;
}

function windowPositionAutoMove()
{
	if((GetGameStateName() != "GAMINGSTATE"))
	{
		return;
	}
	if(IsVertical())
	{
		if((GetWindowHandle(("ShortcutWnd.ShortcutWndVertical" $ getShortcutIndexStr())).m_pTargetWnd == none))
		{
			return;
		}
		else
		{
			GetWindowHandle("AutoShotItemWnd").ClearAnchor();
			GetWindowHandle("AutoShotItemWnd").SetAnchor(("ShortcutWnd.ShortcutWndVertical" $ getShortcutIndexStr()), "TopLeft", "TopRight", -1, 17);
		}
	}
	else if((GetWindowHandle(("ShortcutWnd.ShortcutWndHorizontal" $ getShortcutIndexStr())).m_pTargetWnd == none))
	{
		return;
	}
	else
	{
		GetWindowHandle("AutoShotItemWnd").ClearAnchor();
		GetWindowHandle("AutoShotItemWnd").SetAnchor(("ShortcutWnd.ShortcutWndHorizontal" $ getShortcutIndexStr()), "TopLeft", "BottomLeft", 16, -1);
	}
	AutoPotionWndScript.windowPositionAutoMove();
	return;
}

function string getShortcutIndexStr()
{
	local int nIndex;
	local string RValue;

	nIndex = ShortcutWndScript.getExpandNum();
	if((nIndex <= 0))
	{
		RValue = "";
	}
	else
	{
		RValue = ("_" $ string(nIndex));
	}
	return RValue;
}

function OnEvent(int Event_ID, string param)
{
	if(getInstanceUIData().getIsArenaServer())
	{
		return;
	}
	switch(Event_ID)
	{
		case 9750:
			checkSlotShowState();
			windowPositionAutoMove();
			break;
		case 20182:
			beginSoulShotUpdateHandle(param);
			break;
		case 20180:
			soulShotUpdateHandle(param);
			break;
		case 2610:
		case 2600:
			syncInventory(param);
			break;
		case 40:
			Init();
			break;
		case 2900:
			windowPositionAutoMove();
			Me.SetTimer(30021, 5000);
			break;
		case 693:
			windowPositionAutoMove();
			break;
		default:
			break;
	}
	return;
}

function beginSoulShotUpdateHandle(string param)
{
	local int i;

	ParamToItemInfo(param, weaponItemInfo);
	showNoticeNum = 0;
	updateSlotWeapon(weaponItemInfo);
	i = 0;
	while((i < 4))
	{
		showTextureCounter(false, true, (i + 1));
		showTextureCounter(false, false, (i + 1));
		i++;
	}
	windowPositionAutoMove();
	return;
}

function checkSlotShowState()
{
	local PetInfo PetInfo;

	if((GetGameStateName() != "GAMINGSTATE"))
	{
		return;
	}
	if(YetiPCModeChangeWndScript.isYetiMode())
	{
		if(Me.IsShowWindow())
		{
			Me.HideWindow();
		}
		return;
	}
	else if(!Me.IsShowWindow())
	{
		Me.ShowWindow();
	}
	if(!Me.IsShowWindow())
	{
		Me.ShowWindow();
	}
	AutoPotionWndScript.windowPositionAutoMove();
	GetWindowHandle(getSlotPath(false, 1)).HideWindow();
	GetWindowHandle(getSlotPath(true, 1)).HideWindow();
	GetWindowHandle(getSlotPath(false, 3)).HideWindow();
	GetWindowHandle(getSlotPath(true, 3)).HideWindow();
	GetWindowHandle(getSlotPath(IsVertical(), 1)).ShowWindow();
	if((hasWeapon == false))
	{
		showTextureCounter(false, true, 1);
		showTextureCounter(false, true, 2);
		showTextureCounter(false, false, 1);
		showTextureCounter(false, false, 2);
	}
	if((bBeforeSummon || bBeforePet))
	{
		GetPetInfo(PetInfo);
		if((PetInfo.nPetType == 1))
		{
			petIconHorTex.SetTexture("L2UI_ct1.AutoShotItemWnd.header_Mercenary");
			petIconVerTex.SetTexture("L2UI_ct1.AutoShotItemWnd.header_Mercenary_v");
		}
		else
		{
			petIconHorTex.SetTexture("l2UI_CT1.AutoShotItemWnd.header_pet");
			petIconVerTex.SetTexture("L2UI_CT1.AutoShotItemWnd.header_pet_v");
		}
		GetWindowHandle(getSlotPath(IsVertical(), 3)).ShowWindow();
	}
	else
	{
		GetWindowHandle(getSlotPath(false, 3)).HideWindow();
		GetWindowHandle(getSlotPath(true, 3)).HideWindow();
	}
	AutoPotionWndScript.windowPositionAutoMove();
	return;
}

function endSoulShotUpdateHandle()
{
	bBeforeSummon = bSummonException();
	bBeforePet = Class'NWindow.UIDATA_PET'.static.IsHavePet();
	beforeWeaponInfo = weaponItemInfo;
	return;
}

function bool bSummonException()
{
	local bool bSummonFlag;
	local int nPlayClassID;

	if(getInstanceUIData().GetIsLiveServer())
	{
		nPlayClassID = DetailStatusWnd(GetScript("DetailStatusWnd")).CurrentSubjobClassID;
		switch(nPlayClassID)
		{
			case 176:
			case 177:
			case 178:
				bSummonFlag = false;
				break;
			default:
				bSummonFlag = numToBool(Class'NWindow.UIDATA_PET'.static.GetSummonNum());
		}
	}
	else
	{
		bSummonFlag = numToBool(Class'NWindow.UIDATA_PET'.static.GetSummonNum());
	}
	return bSummonFlag;
}

function soulShotUpdateHandle(string param)
{
	local int nType, nHave, nActivate;
	local string itemCountStr;
	local ItemInfo targetItemInfo, beforeTargetItemInfo;
	local bool bTwinkleEffect;
	local string effectPath;

	ParseInt(param, "type", nType);
	ParseInt(param, "have", nHave);
	ParseInt(param, "activate", nActivate);
	ParamToItemInfo(param, targetItemInfo);
	bPet = Class'NWindow.UIDATA_PET'.static.IsHavePet();
	bSummon = bSummonException();
	if((nType > -1))
	{
		bTwinkleEffect = true;
		if(((nActivate == 1) || (nActivate == 3)))
		{
			targetItemInfo.IsToggle = true;
		}
		else
		{
			targetItemInfo.IsToggle = false;
		}
		if(getShotItemSlot(false, nType).GetItem(0, beforeTargetItemInfo))
		{
			if((beforeTargetItemInfo.Id.ClassID == targetItemInfo.Id.ClassID))
			{
				if((targetItemInfo.ItemNum > INT64(0)))
				{
					bTwinkleEffect = false;
				}
			}
			else
			{
				setItemSlot(nType, 3);
			}
		}
		else if((targetItemInfo.ItemNum <= INT64(0)))
		{
			bTwinkleEffect = false;
		}
		if((nHave <= 0))
		{
		}
		else if(((nType == 1) || (nType == 2)))
		{
			if(hasWeapon)
			{
				if((targetItemInfo.Id.ClassID > 0))
				{
					if((beforeTargetItemInfo.Id.ClassID == targetItemInfo.Id.ClassID))
					{
						setItemSlot(nType, 2, targetItemInfo);
					}
					else
					{
						setItemSlot(nType, 1, targetItemInfo);
						effectPath = ("AutoShotItemWnd.EffectSlot" $ string(nType));
						if(IsVertical())
						{
							effectPath = (effectPath $ "_ver_AniTex");
						}
						else
						{
							effectPath = (effectPath $ "_hor_AniTex");
						}
						GetAnimTextureHandle(effectPath).Stop();
						GetAnimTextureHandle(effectPath).Play();
						HideWindow("AutoShotItemWnd.AutoShotItemSubWnd");
					}
				}
			}
			else
			{
				bTwinkleEffect = false;
			}
		}
		else if(((nType == 3) || (nType == 4)))
		{
			if((bSummon || bPet))
			{
				if((targetItemInfo.Id.ClassID > 0))
				{
					if((beforeTargetItemInfo.Id.ClassID == targetItemInfo.Id.ClassID))
					{
						setItemSlot(nType, 2, targetItemInfo);
					}
					else
					{
						setItemSlot(nType, 1, targetItemInfo);
						effectPath = ("AutoShotItemWnd.EffectSlot" $ string(nType));
						if(IsVertical())
						{
							effectPath = (effectPath $ "_ver_AniTex");
						}
						else
						{
							effectPath = (effectPath $ "_hor_AniTex");
						}
						GetAnimTextureHandle(effectPath).Stop();
						GetAnimTextureHandle(effectPath).Play();
						HideWindow("AutoShotItemWnd.AutoShotItemSubWnd");
					}
				}
				else
				{
					setItemSlot(nType, 3);
				}
			}
			else
			{
				bTwinkleEffect = false;
				setItemSlot(nType, 3);
			}
		}
		if((GetItemWindowHandle(("AutoShotItemWnd.ShotItemSlot" $ string(nType))).GetItemNum() > 0))
		{
			if((targetItemInfo.ItemNum > INT64(99)))
			{
				itemCountStr = "99+";
			}
			else
			{
				itemCountStr = string(targetItemInfo.ItemNum);
			}
		}
	}
	endSoulShotUpdateHandle();
	checkSlotShowState();
	return;
}

function setItemSlot(int nType, int nItemCommand, optional ItemInfo Info)
{
	if((nItemCommand == 1))
	{
		getShotItemSlot(false, nType).AddItem(Info);
		getShotItemSlot(true, nType).AddItem(Info);
		setTextureCounter(true, nType, Info.ItemNum);
		setTextureCounter(false, nType, Info.ItemNum);
		if((Info.ItemNum <= INT64(0)))
		{
			showTextureCounter(false, true, nType);
			showTextureCounter(false, false, nType);
		}
	}
	else if((nItemCommand == 2))
	{
		getShotItemSlot(false, nType).SetItem(0, Info);
		getShotItemSlot(true, nType).SetItem(0, Info);
		setTextureCounter(true, nType, Info.ItemNum);
		setTextureCounter(false, nType, Info.ItemNum);
		if((Info.ItemNum <= INT64(0)))
		{
			showTextureCounter(false, true, nType);
			showTextureCounter(false, false, nType);
		}
	}
	else if((nItemCommand == 3))
	{
		getShotItemSlot(true, nType).Clear();
		getShotItemSlot(false, nType).Clear();
		showTextureCounter(false, false, nType);
		showTextureCounter(false, true, nType);
	}
	return;
}

function OnTimer(int TimerID)
{
	if((TimerID == 30021))
	{
		windowPositionAutoMove();
		Me.KillTimer(30021);
	}
	return;
}

function updateSlotWeapon(ItemInfo Info)
{
	weaponItemInfo = Info;
	if((Info.Id.ClassID > 0))
	{
		hasWeapon = true;
	}
	else
	{
		hasWeapon = false;
	}
	return;
}

function ExHideSubWnd()
{
	HideWindow("AutoShotItemWnd.AutoShotItemSubWnd");
	return;
}

function OnClickItem(string strID, int Index)
{
	local ItemInfo infItem, SelectItemInfo;
	local array<ItemInfo> itemInfoArray;
	local int i, wndIndex;

	if((Left(strID, 12) == "ShotItemSlot"))
	{
		wndIndex = int(Right(strID, 1));
		if(((currentSelectSoulShotWndIndex == wndIndex) && IsShowWindow("AutoShotItemWnd.AutoShotItemSubWnd")))
		{
			currentSelectSoulShotWndIndex = -1;
			HideWindow("AutoShotItemWnd.AutoShotItemSubWnd");
			return;
		}
		currentSelectSoulShotWndIndex = wndIndex;
		if(((currentSelectSoulShotWndIndex > 0) && (currentSelectSoulShotWndIndex < 5)))
		{
			GetAutoEquipShotList(currentSelectSoulShotWndIndex, itemInfoArray);
			ShowWindowWithFocus("AutoShotItemWnd.AutoShotItemSubWnd");
			if(IsVertical())
			{
				GetWindowHandle("AutoShotItemWnd.AutoShotItemSubWnd.ArrowHor_Texture_SubWnd").HideWindow();
				GetWindowHandle("AutoShotItemWnd.AutoShotItemSubWnd.ArrowVer_Texture_SubWnd").ShowWindow();
				GetWindowHandle("AutoShotItemWnd.AutoShotItemSubWnd").SetAnchor(((getSlotPath(IsVertical(), wndIndex) $ ".ShotItemSlot") $ string(wndIndex)), "TopRight", "TopLeft", -135, 0);
			}
			else
			{
				GetWindowHandle("AutoShotItemWnd.AutoShotItemSubWnd.ArrowHor_Texture_SubWnd").ShowWindow();
				GetWindowHandle("AutoShotItemWnd.AutoShotItemSubWnd.ArrowVer_Texture_SubWnd").HideWindow();
				GetWindowHandle("AutoShotItemWnd.AutoShotItemSubWnd").SetAnchor(((getSlotPath(IsVertical(), wndIndex) $ ".ShotItemSlot") $ string(wndIndex)), "TopLeft", "TopLeft", -62, -95);
			}
		}
		else
		{
			currentSelectSoulShotWndIndex = -1;
			HideWindow("AutoShotItemWnd.AutoShotItemSubWnd");
		}
		if((itemInfoArray.Length > 0))
		{
			if((getShotItemSlot(false, wndIndex).GetItemNum() > 0))
			{
				getShotItemSlot(false, wndIndex).GetItem(0, infItem);
			}
			GetItemWindowHandle("AutoShotItemWnd.AutoShotItemSubWnd.AutoShotItem_ItemWnd_SubWnd").Clear();
			i = 0;
			while((i < itemInfoArray.Length))
			{
				if((infItem.Id.ClassID != itemInfoArray[i].Id.ClassID))
				{
					SetShowItemCount(itemInfoArray[i]);
					GetItemWindowHandle("AutoShotItemWnd.AutoShotItemSubWnd.AutoShotItem_ItemWnd_SubWnd").AddItem(itemInfoArray[i]);
				}
				i++;
			}
		}
	}
	else if((strID == "AutoShotItem_ItemWnd_SubWnd"))
	{
		GetItemWindowHandle("AutoShotItemWnd.AutoShotItemSubWnd.AutoShotItem_ItemWnd_SubWnd").GetItem(Index, SelectItemInfo);
		if(((SelectItemInfo.Id.ClassID > 0) && (currentSelectSoulShotWndIndex != -1)))
		{
			SoulShotSlotSelected(currentSelectSoulShotWndIndex, SelectItemInfo.Id.ClassID);
			HideWindow("AutoShotItemWnd.AutoShotItemSubWnd");
		}
	}
	return;
}

function syncInventory(string param)
{
	local array<ItemInfo> itemInfoArray;
	local int Index, i;
	local ItemInfo infItem, updatedItemInfo;
	local string Type;
	local bool bPassItem;
	local ItemWindowHandle shotSubInvenWnd;

	if((IsShowWindow("AutoShotItemWnd.AutoShotItemSubWnd") == false))
	{
		return;
	}
	shotSubInvenWnd = GetItemWindowHandle("AutoShotItemWnd.AutoShotItemSubWnd.AutoShotItem_ItemWnd_SubWnd");
	if(((currentSelectSoulShotWndIndex > 0) && (currentSelectSoulShotWndIndex < 5)))
	{
		GetAutoEquipShotList(currentSelectSoulShotWndIndex, itemInfoArray);
		if((getShotItemSlot(false, currentSelectSoulShotWndIndex).GetItemNum() > 0))
		{
			getShotItemSlot(false, currentSelectSoulShotWndIndex).GetItem(0, infItem);
			Index = shotSubInvenWnd.FindItemByClassID(infItem.Id);
			if((Index > -1))
			{
				shotSubInvenWnd.DeleteItem(Index);
			}
		}
	}
	ParamToItemInfo(param, updatedItemInfo);
	ParseString(param, "type", Type);
	switch(currentSelectSoulShotWndIndex)
	{
		case 1:
			GetAutoEquipShotList(1, itemInfoArray);
			break;
		case 2:
			GetAutoEquipShotList(2, itemInfoArray);
			break;
		case 3:
			GetAutoEquipShotList(3, itemInfoArray);
			break;
		case 4:
			GetAutoEquipShotList(4, itemInfoArray);
			break;
		default:
			break;
	}
	i = 0;
	while((i < itemInfoArray.Length))
	{
		if((itemInfoArray[i].Id.ClassID == updatedItemInfo.Id.ClassID))
		{
			bPassItem = true;
			break;
		}
		i++;
	}
	if((bPassItem == false))
	{
		return;
	}
	Index = shotSubInvenWnd.FindItemByClassID(updatedItemInfo.Id);
	if((Type == "delete"))
	{
		if((Index > -1))
		{
			shotSubInvenWnd.DeleteItem(Index);
		}
	}
	else
	{
		SetShowItemCount(updatedItemInfo);
		if((Index > -1))
		{
			shotSubInvenWnd.SetItem(Index, updatedItemInfo);
		}
		else if((infItem.Id.ClassID != updatedItemInfo.Id.ClassID))
		{
			shotSubInvenWnd.AddItem(updatedItemInfo);
		}
	}
	return;
}

function OnRButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	clickShotcutItem(a_WindowHandle, X, Y);
	return;
}

function clickShotcutItem(WindowHandle a_WindowHandle, int X, int Y)
{
	local string targetStr, targetID;
	local ItemInfo targetItemInfo;

	targetStr = a_WindowHandle.GetWindowName();
	targetID = Mid(targetStr, (Len(targetStr) - 1), Len(targetStr));
	switch(targetID)
	{
		case "1":
		case "2":
		case "3":
		case "4":
			if(GetItemWindowHandle(("AutoShotItemWnd.ShotItemSlot" $ targetID)).GetItem(0, targetItemInfo))
			{
				SoulShotSlotClicked(int(targetID), targetItemInfo.Id.ClassID);
			}
			break;
		default:
			break;
	}
	return;
}

function ItemWindowHandle getShotItemSlot(bool IsShortcutWndVertical, int SlotIndex)
{
	local ItemWindowHandle ItemWnd;

	if(IsShortcutWndVertical)
	{
		if((SlotIndex > 2))
		{
			ItemWnd = GetItemWindowHandle(("AutoShotItemWnd.AutoShotItemWnd_VerWnd.PetSlotGroupWnd_VerWnd.ShotItemSlot" $ string(SlotIndex)));
		}
		else
		{
			ItemWnd = GetItemWindowHandle(("AutoShotItemWnd.AutoShotItemWnd_VerWnd.WeaponSlotGroupWnd_VerWnd.ShotItemSlot" $ string(SlotIndex)));
		}
	}
	else if((SlotIndex > 2))
	{
		ItemWnd = GetItemWindowHandle(("AutoShotItemWnd.AutoShotItemWnd_HorWnd.PetSlotGroupWnd_HorWnd.ShotItemSlot" $ string(SlotIndex)));
	}
	else
	{
		ItemWnd = GetItemWindowHandle(("AutoShotItemWnd.AutoShotItemWnd_HorWnd.WeaponSlotGroupWnd_HorWnd.ShotItemSlot" $ string(SlotIndex)));
	}
	return ItemWnd;
}

function setTextureCounter(bool IsShortcutWndVertical, int SlotIndex, INT64 Count)
{
	local string tempStr, valueStr;

	if((Count > INT64(99)))
	{
		valueStr = "99+";
	}
	else
	{
		valueStr = string(Count);
	}
	showTextureCounter(false, IsShortcutWndVertical, SlotIndex);
	tempStr = getSlotPath(IsShortcutWndVertical, SlotIndex);
	switch(Len(valueStr))
	{
		case 3:
			showTextureCounter(true, IsShortcutWndVertical, SlotIndex);
			GetTextureHandle(((((tempStr $ ".") $ "counter100_slot") $ string(SlotIndex)) $ "_texture")).SetTexture("l2UI_CT1.AutoShotItemWnd.ItemCountNum_9");
			GetTextureHandle(((((tempStr $ ".") $ "counter10_slot") $ string(SlotIndex)) $ "_texture")).SetTexture("l2UI_CT1.AutoShotItemWnd.ItemCountNum_9");
			GetTextureHandle(((((tempStr $ ".") $ "counter1_slot") $ string(SlotIndex)) $ "_texture")).SetTexture("l2UI_CT1.AutoShotItemWnd.ItemCountNum_Plus");
			break;
		case 2:
			GetTextureHandle(((((tempStr $ ".") $ "counter10_slot") $ string(SlotIndex)) $ "_texture")).ShowWindow();
			GetTextureHandle(((((tempStr $ ".") $ "counter10_slot") $ string(SlotIndex)) $ "_texture")).SetTexture(("l2UI_CT1.AutoShotItemWnd.ItemCountNum_" $ Left(valueStr, 1)));
		case 1:
			GetTextureHandle(((((tempStr $ ".") $ "counter1_slot") $ string(SlotIndex)) $ "_texture")).ShowWindow();
			GetTextureHandle(((((tempStr $ ".") $ "counter1_slot") $ string(SlotIndex)) $ "_texture")).SetTexture(("l2UI_CT1.AutoShotItemWnd.ItemCountNum_" $ Right(valueStr, 1)));
		default:
			break;
	}
	return;
}

function showTextureCounter(bool bShow, bool IsShortcutWndVertical, int SlotIndex)
{
	local string tempStr;

	tempStr = getSlotPath(IsShortcutWndVertical, SlotIndex);
	if(bShow)
	{
		GetTextureHandle(((((tempStr $ ".") $ "counter1_slot") $ string(SlotIndex)) $ "_texture")).ShowWindow();
		GetTextureHandle(((((tempStr $ ".") $ "counter10_slot") $ string(SlotIndex)) $ "_texture")).ShowWindow();
		GetTextureHandle(((((tempStr $ ".") $ "counter100_slot") $ string(SlotIndex)) $ "_texture")).ShowWindow();
	}
	else
	{
		GetTextureHandle(((((tempStr $ ".") $ "counter1_slot") $ string(SlotIndex)) $ "_texture")).HideWindow();
		GetTextureHandle(((((tempStr $ ".") $ "counter10_slot") $ string(SlotIndex)) $ "_texture")).HideWindow();
		GetTextureHandle(((((tempStr $ ".") $ "counter100_slot") $ string(SlotIndex)) $ "_texture")).HideWindow();
	}
	return;
}

function string getSlotPath(bool IsShortcutWndVertical, int SlotIndex)
{
	local string tempStr;

	tempStr = "AutoShotItemWnd";
	if(IsShortcutWndVertical)
	{
		tempStr = (tempStr $ ".AutoShotItemWnd_VerWnd");
		if((SlotIndex > 2))
		{
			tempStr = (tempStr $ ".PetSlotGroupWnd_VerWnd");
		}
		else
		{
			tempStr = (tempStr $ ".WeaponSlotGroupWnd_VerWnd");
		}
	}
	else
	{
		tempStr = (tempStr $ ".AutoShotItemWnd_HorWnd");
		if((SlotIndex > 2))
		{
			tempStr = (tempStr $ ".PetSlotGroupWnd_HorWnd");
		}
		else
		{
			tempStr = (tempStr $ ".WeaponSlotGroupWnd_HorWnd");
		}
	}
	return tempStr;
}

function bool IsVertical()
{
	return ShortcutWndScript.IsVertical();
}
