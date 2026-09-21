class PetPreviewWndGroupItem extends UICommonAPI;

const SKILL_SLOT_COLUMN_NUM = 6;
const SKILL_SLOT_GAP_Y = 12;
const SKILL_SLOT_HEIGHT = 48;

var PetSkillGroupInfo__PetPreviewWnd _info;
var array<PetSkillSlotInfo__PetPreviewWnd> _slotInfos;
var WindowHandle Me;
var TextBoxHandle TitleTextBox;
var ItemWindowHandle skillItemWnd;
//var delegate<DelegateOnSkillInfoClicked> __DelegateOnSkillInfoClicked__Delegate;

delegate DelegateOnSkillInfoClicked(PetSkillSlotInfo__PetPreviewWnd skillSlotInfo)
{
	return;
}

function Init(WindowHandle Owner)
{
	local string ownerFullPath;

	ownerFullPath = Owner.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	TitleTextBox = GetTextBoxHandle((ownerFullPath $ ".SkillNameStr"));
	skillItemWnd = GetItemWindowHandle((ownerFullPath $ ".SkillItem"));
	return;
}

function SetGroupInfo(PetSkillGroupInfo__PetPreviewWnd Info)
{
	local int i, windowHeight, SlotIndex, Row, prevGroup, nextGroup;
	local PetSkillSlotInfo__PetPreviewWnd tmpSkillInfo;

	_info = Info;
	_slotInfos.Length = 0;
	i = 0;
	while((i < _info.Skills.Length))
	{
		tmpSkillInfo = _info.Skills[i];
		nextGroup = tmpSkillInfo.GroupType;
		if((i > 0))
		{
			prevGroup = _info.Skills[(i - 1)].GroupType;
			if((prevGroup != nextGroup))
			{
				SlotIndex = (appCeil((float(_slotInfos.Length) / 6.0000000)) * 6);
			}
		}
		_slotInfos[SlotIndex] = tmpSkillInfo;
		SlotIndex++;
		i++;
	}
	TitleTextBox.SetText(getSkillTypeString(Info.GroupType));
	skillItemWnd.Clear();
	if((Info.GroupType == -1))
	{
		skillItemWnd.SetTooltipType("Action");
	}
	else
	{
		skillItemWnd.SetTooltipType("Skill");
	}
	i = 0;
	while((i < _slotInfos.Length))
	{
		tmpSkillInfo = _slotInfos[i];
		if((tmpSkillInfo.learned == false))
		{
			tmpSkillInfo.skillItemInfo.ForeTexture = "L2UI_CT1.WindowDisable_BG";
		}
		if((tmpSkillInfo.SkillInfo.SkillID == 0))
		{
			tmpSkillInfo.skillItemInfo.ShortcutType = 2;
			tmpSkillInfo.skillItemInfo.ForeTexture = "";
		}
		tmpSkillInfo.skillItemInfo.SkillStateBitflag = MakeSkillStateBitflag(tmpSkillInfo);
		skillItemWnd.AddItem(tmpSkillInfo.skillItemInfo);
		skillItemWnd.SetPetSkillWindow(i, true);
		i++;
	}
	Row = appCeil((float(_slotInfos.Length) / 6.0000000));
	windowHeight = ((12 + 48) * Row);
	skillItemWnd.SetWindowSize(skillItemWnd.GetRect().nWidth, windowHeight);
	Me.SetWindowSize(Me.GetRect().nWidth, (windowHeight + 45));
	return;
}

function byte MakeSkillStateBitflag(PetSkillSlotInfo__PetPreviewWnd slotInfo)
{
	local byte bitflag;

	if(((slotInfo.learned == false) && (slotInfo.isCanLevelUp == false)))
	{
		bitflag = byte((int(bitflag) | 1));
	}
	if(((slotInfo.learned == false) && (slotInfo.isCanLevelUp == true)))
	{
		bitflag = byte((int(bitflag) | 2));
	}
	if(((slotInfo.learned == true) && (slotInfo.isCanLevelUp == true)))
	{
		bitflag = byte((int(bitflag) | 4));
	}
	if(slotInfo.isActiveSkill)
	{
		bitflag = byte((int(bitflag) | 32));
	}
	bitflag = byte((int(bitflag) | 64));
	return bitflag;
}

function PetSkillSlotInfo__PetPreviewWnd GetPetSkillSlotInfo(int ClassID)
{
	local PetSkillSlotInfo__PetPreviewWnd skillSlotInfo;
	local int i;

	i = 0;
	while((i < _info.Skills.Length))
	{
		skillSlotInfo = _info.Skills[i];
		if((skillSlotInfo.skillItemInfo.Id.ClassID == ClassID))
		{
			return skillSlotInfo;
		}
		i++;
	}
	skillSlotInfo.SkillInfo.SkillID = 0;
	return skillSlotInfo;
}

function UpdateSkillDisableState()
{
	local int i, Id, Level, SubLevel, SkillDisabled;

	if((Me.IsShowWindow() == false))
	{
		return;
	}
	i = 0;
	while((i < skillItemWnd.GetItemNum()))
	{
		skillItemWnd.GetItemIdLevel(i, Id, Level, SubLevel);
		SkillDisabled = GetSkillAvailability(Id, Level, SubLevel);
		skillItemWnd.SetItemSkillDisabled(i, SkillDisabled);
		i++;
	}
	return;
}

function SetDisable(bool IsDisable)
{
	if((IsDisable == true))
	{
		skillItemWnd.Clear();
		Me.HideWindow();
	}
	else
	{
		Me.ShowWindow();
	}
	return;
}

event OnClickItem(string strID, int Index)
{
	return;
}

event OnRClickItemWithHandle(ItemWindowHandle ItemWnd, int Index)
{
	local ItemInfo Info;

	ItemWnd.GetItem(Index, Info);
	if((Info.ShortcutType == 3))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(14042));
		return;
	}
	if((Info.Id.ClassID == 0))
	{
		return;
	}
	DelegateOnSkillInfoClicked(GetPetSkillSlotInfo(Info.Id.ClassID));
	return;
}

event OnDBClickItemWithHandle(ItemWindowHandle ItemWnd, int Index)
{
	OnRClickItemWithHandle(ItemWnd, Index);
	return;
}
