class ToDoListMissionLevelStepItem extends UICommonAPI;

const MISSION_TEXTURE_PATH = "L2UI_NewTex.MissionWnd.";

enum EMissionLevelStepState
{
	EmptyReward,                    // 0
	NotInProgress,                  // 1
	InProgress,                     // 2
	CompleteNotRewardStep,          // 3
	CompleteRewardReady,            // 4
	CompleteRewarded                // 5
};

var WindowHandle Me;
var ToDoListTabMissionLevel parentWnd;
var ButtonHandle baseRewardBtn;
var ButtonHandle keyRewardBtn;
var TextureHandle baseRewardBgTex;
var TextureHandle baseRewardStateBgTex;
var TextureHandle keyRewardBgTex;
var TextureHandle baseRewardCompleteTex;
var TextureHandle keyRewardCompleteTex;
var AnimTextureHandle baseRewardReadyAnimTex;
var AnimTextureHandle keyRewardReadyAnimTex;
var ItemWindowHandle baseRewardItemSlot;
var ItemWindowHandle keyRewardItemSlot;
var TextBoxHandle levelTextBox;
var TextBoxHandle baseRewardCntTextBox;
var TextBoxHandle keyRewardCntTextBox;
var WindowHandle keyRewardWnd;
var ToDoListTabMissionLevel.MissionLevelStepInfo _info;
var EMissionLevelStepState baseRewardStepState;
var EMissionLevelStepState keyRewardStepState;
//var delegate<DelegateOnBaseRewardClicked> __DelegateOnBaseRewardClicked__Delegate;
//var delegate<DelegateOnKeyRewardClicked> __DelegateOnKeyRewardClicked__Delegate;

delegate DelegateOnBaseRewardClicked(ToDoListMissionLevelStepItem Owner)
{
	return;
}

delegate DelegateOnKeyRewardClicked(ToDoListMissionLevelStepItem Owner)
{
	return;
}

function Init(WindowHandle Owner, ToDoListTabMissionLevel Parent)
{
	local string ownerFullPath;

	ownerFullPath = Owner.m_WindowNameWithFullPath;
	parentWnd = Parent;
	Me = GetWindowHandle(ownerFullPath);
	levelTextBox = GetTextBoxHandle((ownerFullPath $ ".LVNum"));
	baseRewardBtn = GetButtonHandle((ownerFullPath $ ".RewardBase_Btn"));
	baseRewardBgTex = GetTextureHandle((ownerFullPath $ ".CountStateBGSet_texture"));
	baseRewardCompleteTex = GetTextureHandle((ownerFullPath $ ".RewardStateIcon_texture"));
	baseRewardReadyAnimTex = GetAnimTextureHandle((ownerFullPath $ ".RewardCountStateBG_animTex"));
	baseRewardItemSlot = GetItemWindowHandle((ownerFullPath $ ".Reward_ItemWnd"));
	baseRewardCntTextBox = GetTextBoxHandle((ownerFullPath $ ".RewardItemNem_Text"));
	keyRewardWnd = GetWindowHandle((ownerFullPath $ ".SpecialReward_wnd"));
	keyRewardBtn = GetButtonHandle((ownerFullPath $ ".Special_RewardBase_Btn"));
	keyRewardBgTex = GetTextureHandle((ownerFullPath $ ".Special_CountStateBGSet_texture"));
	keyRewardCompleteTex = GetTextureHandle((ownerFullPath $ ".Special_RewardStateIcon_texture"));
	keyRewardReadyAnimTex = GetAnimTextureHandle((ownerFullPath $ ".Special_CountStateBG_animTex"));
	keyRewardItemSlot = GetItemWindowHandle((ownerFullPath $ ".Special_Reward_ItemWnd"));
	keyRewardCntTextBox = GetTextBoxHandle((ownerFullPath $ ".Special_RewardItemNem_Text"));
	return;
}

event OnClickButton(string StringID)
{
	if((StringID == "RewardBase_Btn"))
	{
		DelegateOnBaseRewardClicked(self);
	}
	else if((StringID == "Special_RewardBase_Btn"))
	{
		DelegateOnKeyRewardClicked(self);
	}
	return;
}

event OnClickItem(string StringID, int Index)
{
	if((StringID == "Reward_ItemWnd"))
	{
		if(baseRewardBtn.IsEnableWindow())
		{
			DelegateOnBaseRewardClicked(self);
		}
	}
	else if((StringID == "Special_Reward_ItemWnd"))
	{
		if(keyRewardBtn.IsEnableWindow())
		{
			DelegateOnKeyRewardClicked(self);
		}
	}
	return;
}

function _SetStepInfo(ToDoListTabMissionLevel.MissionLevelStepInfo Info, int CurrentLevel, int availableBaseRewardLevel, int availableKeyRewardLevel)
{
	local ItemInfo baseItemInfo, keyItemInfo;

	_info = Info;
	if((Info.baseRewardItem.ItemClassID == 0))
	{
		_SetDisable(true);
		return;
	}
	baseItemInfo = GetItemInfoByClassID(Info.baseRewardItem.ItemClassID);
	baseRewardItemSlot.Clear();
	baseRewardItemSlot.AddItem(baseItemInfo);
	baseRewardCntTextBox.SetText(("x" $ string(Info.baseRewardItem.Amount)));
	if((Info.Level == (CurrentLevel + 1)))
	{
		levelTextBox.SetTextColor(GetColor(0, 255, 255, 255));
	}
	else
	{
		levelTextBox.SetTextColor(GetColor(255, 221, 102, 255));
	}
	levelTextBox.SetText(string(Info.Level));
	if((Info.keyRewardItem.ItemClassID == 0))
	{
		keyRewardWnd.HideWindow();
	}
	else
	{
		keyItemInfo = GetItemInfoByClassID(Info.keyRewardItem.ItemClassID);
		keyRewardItemSlot.Clear();
		keyRewardItemSlot.AddItem(keyItemInfo);
		keyRewardCntTextBox.SetText(("x" $ string(Info.keyRewardItem.Amount)));
		SetKeyRewardTexture(GetStepState(Info.Level, Info.keyRewardState, CurrentLevel, availableKeyRewardLevel));
		keyRewardWnd.ShowWindow();
	}
	SetBaseRewardTexture(GetStepState(Info.Level, Info.baseRewardState, CurrentLevel, availableBaseRewardLevel));
	_SetDisable(false);
	return;
}

function _SetDisable(bool IsDisable)
{
	if((IsDisable == true))
	{
		Me.HideWindow();
	}
	else
	{
		Me.ShowWindow();
	}
	return;
}

function _StopAllAnimations()
{
	baseRewardReadyAnimTex.Stop();
	keyRewardReadyAnimTex.Stop();
	return;
}

function SetBaseRewardTexture(EMissionLevelStepState stepState)
{
	baseRewardBtn.SetEnable(false);
	switch(stepState)
	{
		case NotInProgress:
			baseRewardCompleteTex.HideWindow();
			baseRewardReadyAnimTex.HideWindow();
			baseRewardBgTex.SetTexture(("L2UI_NewTex.MissionWnd." $ "Free_Basic"));
			break;
		case InProgress:
			baseRewardCompleteTex.HideWindow();
			baseRewardReadyAnimTex.HideWindow();
			baseRewardBgTex.SetTexture(("L2UI_NewTex.MissionWnd." $ "Free_GaugeProgress"));
			break;
		case CompleteNotRewardStep:
			baseRewardCompleteTex.HideWindow();
			baseRewardReadyAnimTex.HideWindow();
			baseRewardBgTex.SetTexture(("L2UI_NewTex.MissionWnd." $ "Free_GaugeComplete"));
			break;
		case CompleteRewardReady:
			baseRewardCompleteTex.HideWindow();
			baseRewardBgTex.SetTexture(("L2UI_NewTex.MissionWnd." $ "Free_GaugeComplete"));
			baseRewardReadyAnimTex.SetTexture(("L2UI_NewTex.MissionWnd." $ "Free_GaugeComplete_Ani0000"));
			baseRewardBtn.SetEnable(true);
			baseRewardReadyAnimTex.ShowWindow();
			baseRewardReadyAnimTex.Stop();
			baseRewardReadyAnimTex.SetLoopCount(9999);
			baseRewardReadyAnimTex.Play();
			break;
		case CompleteRewarded:
			baseRewardCompleteTex.ShowWindow();
			baseRewardReadyAnimTex.HideWindow();
			baseRewardBgTex.SetTexture(("L2UI_NewTex.MissionWnd." $ "Free_RewardComplet"));
			break;
		default:
			break;
	}
	return;
}

function SetKeyRewardTexture(EMissionLevelStepState stepState)
{
	keyRewardBtn.SetEnable(false);
	switch(stepState)
	{
		case NotInProgress:
			keyRewardCompleteTex.HideWindow();
			keyRewardReadyAnimTex.HideWindow();
			keyRewardBgTex.SetTexture(("L2UI_NewTex.MissionWnd." $ "Special_Basic"));
			break;
		case InProgress:
			keyRewardCompleteTex.HideWindow();
			keyRewardReadyAnimTex.HideWindow();
			keyRewardBgTex.SetTexture(("L2UI_NewTex.MissionWnd." $ "Special_GaugeProgress"));
			break;
		case CompleteNotRewardStep:
			keyRewardCompleteTex.HideWindow();
			keyRewardReadyAnimTex.HideWindow();
			keyRewardBgTex.SetTexture(("L2UI_NewTex.MissionWnd." $ "Special_GaugeComplete"));
			break;
		case CompleteRewardReady:
			keyRewardCompleteTex.HideWindow();
			keyRewardBgTex.SetTexture(("L2UI_NewTex.MissionWnd." $ "Special_GaugeComplete"));
			keyRewardReadyAnimTex.SetTexture("L2UI_EPIC.RandomCraftWnd.RandomCraftWnd_ItemSlot3_Ani01");
			keyRewardBtn.SetEnable(true);
			keyRewardReadyAnimTex.ShowWindow();
			keyRewardReadyAnimTex.Stop();
			keyRewardReadyAnimTex.SetLoopCount(9999);
			keyRewardReadyAnimTex.Play();
			break;
		case CompleteRewarded:
			keyRewardCompleteTex.ShowWindow();
			keyRewardReadyAnimTex.HideWindow();
			keyRewardBgTex.SetTexture(("L2UI_NewTex.MissionWnd." $ "Special_RewardComplet"));
			break;
		default:
			break;
	}
	return;
}

function EMissionLevelStepState GetStepState(int Level, ToDoListTabMissionLevel.EMissionLevelRewardState RewardState, int CurrentLevel, int availableLevel)
{
	local int nextLevel;

	nextLevel = (CurrentLevel + 1);
	if((nextLevel == Level))
	{
		return InProgress;
	}
	else if((nextLevel < Level))
	{
		return NotInProgress;
	}
	else if((nextLevel > Level))
	{
		if((int(RewardState) == 2))
		{
			return CompleteRewarded;
		}
		else if(((int(RewardState) == 1) && (availableLevel == Level)))
		{
			return CompleteRewardReady;
		}
		else
		{
			return CompleteNotRewardStep;
		}
	}
}
