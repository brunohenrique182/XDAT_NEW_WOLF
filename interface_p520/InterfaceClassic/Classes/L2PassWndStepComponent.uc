class L2PassWndStepComponent extends UICommonAPI;

var L2PassData.EL2PassStepState _stepState;
var L2PassData.EL2PassType _passType;
var bool _isPremiumStep;
var bool _isPremiumActivated;
var int _index;
var L2PassData _l2PassData;
var WindowHandle Me;
var ButtonHandle rewardBtn;
var TextureHandle premiumStateTexture;
var TextureHandle stateBgTexture;
var TextureHandle rewardStateBgTexture;
var AnimTextureHandle rewardReadyAnimTexture;
var ItemWindowHandle rewardItemSlot;
var TextBoxHandle rewardCntText;
//var delegate<DelegateOnStepClicked> __DelegateOnStepClicked__Delegate;

delegate DelegateOnStepClicked(L2PassWndStepComponent Owner)
{
	return;
}

function Init(WindowHandle Owner)
{
	local string ownerFullPath;

	ownerFullPath = Owner.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	_l2PassData = new Class'InterfaceClassic.L2PassData';
	rewardBtn = GetButtonHandle((ownerFullPath $ ".RewardBase_Btn"));
	premiumStateTexture = GetTextureHandle((ownerFullPath $ ".P_ActiveBG_texture"));
	stateBgTexture = GetTextureHandle((ownerFullPath $ ".CountStateBGSet_texture"));
	rewardStateBgTexture = GetTextureHandle((ownerFullPath $ ".RewardStateIcon_texture"));
	rewardReadyAnimTexture = GetAnimTextureHandle((ownerFullPath $ ".RewardCountStateBG_animTex"));
	rewardItemSlot = GetItemWindowHandle((ownerFullPath $ ".Reward_ItemWnd"));
	rewardCntText = GetTextBoxHandle((ownerFullPath $ ".RewardItemNem_Text"));
	return;
}

event OnClickButtonWithHandle(ButtonHandle Button)
{
	DelegateOnStepClicked(self);
	return;
}

function _SetStepInfo(L2PassData.L2PassStepInfo Info)
{
	local ItemInfo RewardItemInfo;

	_passType = EL2PassType(Info.PassType);
	_isPremiumStep = Info.isPremiumStep;
	_isPremiumActivated = Info.isPremiumActivated;
	_stepState = EL2PassStepState(Info.stepState);
	_index = Info.Index;
	RewardItemInfo = GetItemInfoByClassID(Info.RewardItemID);
	rewardItemSlot.Clear();
	rewardItemSlot.AddItem(RewardItemInfo);
	rewardCntText.SetText(("x" $ string(Info.rewardItemCnt)));
	SetBgTexture(Info.stepState, Info.isPremiumStep, Info.isPremiumActivated);
	if((Info.rewardItemCnt == 0))
	{
		_SetDisable(true);
	}
	else
	{
		_SetDisable(false);
	}
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
	rewardReadyAnimTexture.Stop();
	return;
}

function string SetBgTexture(L2PassData.EL2PassStepState stepState, bool isPremiumStep, bool isPremiumActivated)
{
	local string texturePath;

	texturePath = "L2UI_NewTex.L2passWnd.";
	if(((isPremiumStep == true) && isPremiumActivated))
	{
		premiumStateTexture.ShowWindow();
	}
	else
	{
		premiumStateTexture.HideWindow();
	}
	rewardBtn.SetEnable(false);
	switch(stepState)
	{
		case NotInProgress:
			rewardReadyAnimTexture.HideWindow();
			if((isPremiumStep == false))
			{
				stateBgTexture.SetTexture((texturePath $ "Free_Basic"));
				rewardStateBgTexture.HideWindow();
			}
			else if((isPremiumActivated == false))
			{
				stateBgTexture.SetTexture((texturePath $ "Prem_LockBasic"));
				rewardStateBgTexture.SetTexture((texturePath $ "Prem_LockIcon"));
				rewardStateBgTexture.ShowWindow();
			}
			else
			{
				stateBgTexture.SetTexture((texturePath $ "Prem_ActiveBaisc"));
				rewardStateBgTexture.HideWindow();
			}
			break;
		case InProgress:
			rewardReadyAnimTexture.HideWindow();
			if((isPremiumStep == false))
			{
				stateBgTexture.SetTexture((texturePath $ "Free_GaugeProgress"));
				rewardStateBgTexture.HideWindow();
			}
			else if((isPremiumActivated == false))
			{
				stateBgTexture.SetTexture((texturePath $ "Prem_LockGaugeProgress"));
				rewardStateBgTexture.SetTexture((texturePath $ "Prem_LockIcon"));
				rewardStateBgTexture.ShowWindow();
			}
			else
			{
				stateBgTexture.SetTexture((texturePath $ "Prem_ActiveGaugeProgress"));
				rewardStateBgTexture.HideWindow();
			}
			break;
		case CompleteNotRewardStep:
			rewardReadyAnimTexture.HideWindow();
			if((isPremiumStep == false))
			{
				stateBgTexture.SetTexture((texturePath $ "Free_GaugeComplete"));
				rewardStateBgTexture.HideWindow();
			}
			else if((isPremiumActivated == false))
			{
				stateBgTexture.SetTexture((texturePath $ "Prem_LockGaugeProgress"));
				rewardStateBgTexture.SetTexture((texturePath $ "Prem_LockIcon"));
				rewardStateBgTexture.ShowWindow();
			}
			else
			{
				stateBgTexture.SetTexture((texturePath $ "Prem_ActiveGaugeComplete"));
				rewardStateBgTexture.HideWindow();
			}
			break;
		case CompleteRewardReady:
			if((isPremiumStep == false))
			{
				stateBgTexture.SetTexture((texturePath $ "Free_GaugeComplete"));
				rewardReadyAnimTexture.SetTexture((texturePath $ "Free_GaugeComplete_Ani"));
				rewardStateBgTexture.HideWindow();
				rewardBtn.SetEnable(true);
			}
			else
			{
				rewardReadyAnimTexture.SetTexture((texturePath $ "Prem_ActiveGaugeComplete_Ani"));
				if((isPremiumActivated == false))
				{
					stateBgTexture.SetTexture((texturePath $ "Prem_LockGaugeProgress"));
					rewardStateBgTexture.SetTexture((texturePath $ "Prem_LockIcon"));
					rewardStateBgTexture.ShowWindow();
					rewardBtn.SetEnable(false);
				}
				else
				{
					stateBgTexture.SetTexture((texturePath $ "Prem_ActiveGaugeComplete"));
					rewardStateBgTexture.HideWindow();
					rewardBtn.SetEnable(true);
				}
			}
			rewardReadyAnimTexture.ShowWindow();
			rewardReadyAnimTexture.Stop();
			rewardReadyAnimTexture.SetLoopCount(9999);
			rewardReadyAnimTexture.Play();
			break;
		case CompleteRewarded:
			rewardReadyAnimTexture.HideWindow();
			if((isPremiumStep == false))
			{
				stateBgTexture.SetTexture((texturePath $ "Free_RewardComplet"));
				rewardStateBgTexture.SetTexture((texturePath $ "RewardCompleteICON"));
				rewardStateBgTexture.ShowWindow();
			}
			else if((isPremiumActivated == false))
			{
			}
			else
			{
				stateBgTexture.SetTexture((texturePath $ "Prem_ActiveRewardComplet"));
				rewardStateBgTexture.SetTexture((texturePath $ "RewardCompleteICON"));
				rewardStateBgTexture.ShowWindow();
			}
			break;
		default:
			break;
	}
}
