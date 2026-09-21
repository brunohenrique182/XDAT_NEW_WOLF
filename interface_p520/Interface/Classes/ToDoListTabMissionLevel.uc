class ToDoListTabMissionLevel extends UICommonAPI
	dependson(UIPacket);

const SHOW_STEP_PER_PAGE = 10;
const SHOW_STEP_MINIMUM_PAGE = 1;
const TIMER_ID_SEASON_REMAIN = 1;
const TIMER_ID_BTN_DELAY = 2;
const TIMER_DELAY_BTN_DISABLE = 500;
const TIMER_DELAY_SEASON_REMAIN = 60000;

enum EMissionLevelRewardType
{
	RewardNone,                     // 0
	RewardBase,                     // 1
	RewardKey,                      // 2
	RewardSpecial,                  // 3
	RewardExtra                     // 4
};



struct MissionLevelInfo
{
	var int CurrentLevel;
	var int SeasonYear;
	var int SeasonMonth;
	var int RemainTime;
	var int pointPercent;
	var int extraRewardsAvailable;
	var int totalRewardsAvailable;
	var EMissionLevelRewardState specialRewardState;
	var EMissionLevelRewardState extraRewardState;
	var int SeasonDate;
	var int LimitLevel;
	var MissionRewardItem SpecialRewardItem;
	var MissionRewardItem ExtraRewardItem;
	var int currentStepPage;
	var int maxStepPage;
	var int availableBaseRewardLevel;
	var int availableKeyRewardLevel;
	var int levelJumpLCoin;
	var int LevelJumpStartLevel;
	var array<MissionLevelStepInfo> stepInfo;
	var bool isAccountLevelJumped;
};

var MissionLevelInfo _missionLevelInfo;
var int _remainTimerCount;
var bool _isWaitingBtnDelay;
var bool _isOpenPacket;
var WindowHandle Me;
var ToDoListWnd parentWnd;
var WindowHandle missionStepContainer;
var WindowHandle dialogContainer;
var ButtonHandle stepPrevBtn;
var ButtonHandle stepNextBtn;
var ButtonHandle specialRewardGetBtn;
var ButtonHandle extraRewardGetBtn;
var UIControlPageNavi PageNaviControl;
var TextBoxHandle prevLvTextBox;
var TextBoxHandle nextLvTextBox;
var TextBoxHandle remainTimeTextBox;
var StatusBarHandle missionStatusBar;
var ButtonHandle exRewardGetBtn;
var ItemWindowHandle exRewardItemWnd;
var TextureHandle specialRewardBgTex;
var TextureHandle addRewardTex;
var TextBoxHandle exRewardNameTextBox;
var EffectViewportWndHandle specialRewardEffect;
var ButtonHandle levelJumpBtn;
var UIControlDialogAssets levelJumpDialogAsset;
var ButtonHandle rewardTooltipBtn;
var array<ToDoListMissionLevelStepItem> stepControlList;

function Initialize()
{
	local string ownerFullPath;
	local int i;
	local WindowHandle pageNaviControlWnd, levelJumpDialogWnd;

	_isWaitingBtnDelay = false;
	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	parentWnd = ToDoListWnd(GetScript("ToDoListWnd"));
	Me = GetWindowHandle(ownerFullPath);
	stepPrevBtn = GetButtonHandle((ownerFullPath $ ".ControlNaviAdvance_PrevBtn"));
	stepNextBtn = GetButtonHandle((ownerFullPath $ ".ControlNaviAdvance_NextBtn"));
	specialRewardGetBtn = GetButtonHandle((ownerFullPath $ ".LastRewardGet_BTN"));
	extraRewardGetBtn = GetButtonHandle((ownerFullPath $ ".BonusRewardGet_BTN"));
	pageNaviControlWnd = GetWindowHandle((ownerFullPath $ ".PageNaviControl"));
	pageNaviControlWnd.SetScript("UIControlPageNavi");
	PageNaviControl = UIControlPageNavi(pageNaviControlWnd.GetScript());
	PageNaviControl.Init((ownerFullPath $ ".PageNaviControl"));
	PageNaviControl.DelegeOnChangePage = OnPageNaviChanged;
	prevLvTextBox = GetTextBoxHandle((ownerFullPath $ ".PrvLVNum_txt"));
	nextLvTextBox = GetTextBoxHandle((ownerFullPath $ ".NextLVNum_txt"));
	remainTimeTextBox = GetTextBoxHandle((ownerFullPath $ ".Time_txt"));
	missionStatusBar = GetStatusBarHandle((ownerFullPath $ ".LVGauge_bar"));
	exRewardItemWnd = GetItemWindowHandle((ownerFullPath $ ".AdvanceRewardItem_ItemWnd"));
	specialRewardBgTex = GetTextureHandle((ownerFullPath $ ".AdvanceRewardItemBG_Texture"));
	addRewardTex = GetTextureHandle((ownerFullPath $ ".AddReward"));
	exRewardNameTextBox = GetTextBoxHandle((ownerFullPath $ ".RewardItemName_text"));
	rewardTooltipBtn = GetButtonHandle((ownerFullPath $ ".Help00_btn"));
	specialRewardEffect = GetEffectViewportWndHandle((ownerFullPath $ ".Result_EffectViewport"));
	levelJumpBtn = GetButtonHandle((ownerFullPath $ ".LevelJump_Btn"));
	dialogContainer = GetWindowHandle((ownerFullPath $ ".DisableWnd"));
	levelJumpDialogWnd = GetWindowHandle((dialogContainer.m_WindowNameWithFullPath $ ".UIControlDialogAsset"));
	levelJumpDialogAsset = Class'Interface.UIControlDialogAssets'.static.InitScript(levelJumpDialogWnd);
	levelJumpDialogAsset.DelegateOnCancel = OnLevelJumpDialogCancel;
	levelJumpDialogAsset.DelegateOnClickBuy = OnLevelJumpDialogConfirm;
	levelJumpDialogAsset.SetUseBuyItem(false);
	levelJumpDialogAsset.SetUseNumberInput(false);
	_missionLevelInfo.currentStepPage = 1;
	i = 0;
	while((i < 10))
	{
		AddStepControl(stepControlList, "Section0", i, Me);
		i++;
	}
	return;
}

function AddStepControl(out array<ToDoListMissionLevelStepItem> componentList, string componentName, int Index, WindowHandle Owner)
{
	local WindowHandle targetWindowHandle;
	local ToDoListMissionLevelStepItem targetControl;

	targetWindowHandle = GetWindowHandle((((Owner.m_WindowNameWithFullPath $ ".") $ componentName) $ string(Index)));
	targetWindowHandle.SetScript("ToDoListMissionLevelStepItem");
	targetControl = ToDoListMissionLevelStepItem(targetWindowHandle.GetScript());
	targetControl.Init(targetWindowHandle, self);
	targetControl.DelegateOnBaseRewardClicked = OnBaseRewardStepClicked;
	targetControl.DelegateOnKeyRewardClicked = OnKeyRewardStepClicked;
	componentList[componentList.Length] = targetControl;
	return;
}

function UpdateStepControls()
{
	local int i, infoIndex, infoLength, currentPage;

	currentPage = Max(_missionLevelInfo.currentStepPage, 1);
	infoLength = _missionLevelInfo.stepInfo.Length;
	infoIndex = (((currentPage - 1) * 10) + 1);
	i = 0;
	while((i < 10))
	{
		if((infoIndex < infoLength))
		{
			stepControlList[i]._SetStepInfo(_missionLevelInfo.stepInfo[infoIndex], _missionLevelInfo.CurrentLevel, _missionLevelInfo.availableBaseRewardLevel, _missionLevelInfo.availableKeyRewardLevel);
		}
		else
		{
			stepControlList[i]._SetDisable(true);
		}
		infoIndex++;
		i++;
	}
	SetPageNaviMaxPage(_missionLevelInfo.maxStepPage);
	SetPageNaviCurrentPage(currentPage);
	if((_missionLevelInfo.maxStepPage == 1))
	{
		stepPrevBtn.SetEnable(false);
		stepNextBtn.SetEnable(false);
	}
	else if((_missionLevelInfo.currentStepPage == _missionLevelInfo.maxStepPage))
	{
		stepPrevBtn.SetEnable(true);
		stepNextBtn.SetEnable(false);
	}
	else if((_missionLevelInfo.currentStepPage == 1))
	{
		stepPrevBtn.SetEnable(false);
		stepNextBtn.SetEnable(true);
	}
	else
	{
		stepPrevBtn.SetEnable(true);
		stepNextBtn.SetEnable(true);
	}
	return;
}

function UpdateProgressInfoControls()
{
	local int CurrentLevel;

	CurrentLevel = _missionLevelInfo.CurrentLevel;
	prevLvTextBox.SetText(string(CurrentLevel));
	nextLvTextBox.SetText(string((CurrentLevel + 1)));
	if((CurrentLevel >= _missionLevelInfo.LimitLevel))
	{
		missionStatusBar.SetGaugeColor(7, GetColor(155, 40, 45, 255));
	}
	else
	{
		missionStatusBar.SetGaugeColor(7, GetColor(205, 130, 5, 255));
	}
	missionStatusBar.SetDecimalPlace(0);
	missionStatusBar.SetPointExpPercentRate((float(_missionLevelInfo.pointPercent) / 100.0000000));
	return;
}

function UpdateRemainTimeControls()
{
	local int RemainTime;

	RemainTime = _missionLevelInfo.RemainTime;
	(RemainTime -= (_remainTimerCount * 60));
	remainTimeTextBox.SetText(parentWnd.getTimeStringBySec(RemainTime));
	return;
}

function UpdateExRewardControls()
{
	local ItemInfo RewardItemInfo;
	local string rewardNameStr, rewardNumStr;

	if((int(_missionLevelInfo.specialRewardState) == 2))
	{
		RewardItemInfo = GetItemInfoByClassID(_missionLevelInfo.ExtraRewardItem.ItemClassID);
		exRewardItemWnd.Clear();
		exRewardItemWnd.AddItem(RewardItemInfo);
		rewardNameStr = RewardItemInfo.Name;
		if((_missionLevelInfo.extraRewardsAvailable > 1))
		{
			rewardNumStr = ("x" $ string((_missionLevelInfo.ExtraRewardItem.Amount * _missionLevelInfo.extraRewardsAvailable)));
		}
		else
		{
			rewardNumStr = ("x" $ string(_missionLevelInfo.ExtraRewardItem.Amount));
		}
		exRewardNameTextBox.SetText((rewardNameStr @ rewardNumStr));
		if((int(_missionLevelInfo.extraRewardState) == 1))
		{
			extraRewardGetBtn.SetEnable(true);
		}
		else
		{
			extraRewardGetBtn.SetEnable(false);
		}
		specialRewardBgTex.HideWindow();
		specialRewardGetBtn.HideWindow();
		extraRewardGetBtn.ShowWindow();
	}
	else
	{
		RewardItemInfo = GetItemInfoByClassID(_missionLevelInfo.SpecialRewardItem.ItemClassID);
		exRewardItemWnd.Clear();
		exRewardItemWnd.AddItem(RewardItemInfo);
		rewardNameStr = RewardItemInfo.Name;
		rewardNumStr = ("x" $ string(_missionLevelInfo.SpecialRewardItem.Amount));
		exRewardNameTextBox.SetText((rewardNameStr @ rewardNumStr));
		if((int(_missionLevelInfo.specialRewardState) == 1))
		{
			specialRewardGetBtn.SetEnable(true);
		}
		else
		{
			specialRewardGetBtn.SetEnable(false);
		}
		specialRewardBgTex.ShowWindow();
		specialRewardGetBtn.ShowWindow();
		extraRewardGetBtn.HideWindow();
	}
	if((_missionLevelInfo.extraRewardsAvailable > 0))
	{
		addRewardTex.ShowWindow();
	}
	else
	{
		addRewardTex.HideWindow();
	}
	return;
}

function LevelJumpUIControls()
{
	if((_missionLevelInfo.LevelJumpStartLevel > 0))
	{
		levelJumpBtn.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(14006), string(_missionLevelInfo.LevelJumpStartLevel), string(_missionLevelInfo.levelJumpLCoin), string(_missionLevelInfo.LimitLevel))));
	}
	else
	{
		levelJumpBtn.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(14007), string(_missionLevelInfo.levelJumpLCoin), string(_missionLevelInfo.LimitLevel))));
	}
	if((((_missionLevelInfo.CurrentLevel >= _missionLevelInfo.LimitLevel) || (_missionLevelInfo.CurrentLevel < _missionLevelInfo.LevelJumpStartLevel)) || (_missionLevelInfo.isAccountLevelJumped == true)))
	{
		levelJumpBtn.SetEnable(false);
	}
	else
	{
		levelJumpBtn.SetEnable(true);
	}
	return;
}

function UpdateUIControls()
{
	UpdateProgressInfoControls();
	UpdateExRewardControls();
	UpdateStepControls();
	UpdateRemainTimeControls();
	LevelJumpUIControls();
	return;
}

function ShowSpecialRewardEffect(bool isShow)
{
	if((parentWnd.Me.IsShowWindow() == false))
	{
		return;
	}
	if((isShow == true))
	{
		specialRewardEffect.ShowWindow();
		specialRewardEffect.SpawnEffect("LineageEffect2.ui_upgrade_succ");
	}
	else
	{
		specialRewardEffect.HideWindow();
	}
	return;
}

function bool UpdateMissionLevelInfo(int SeasonDate)
{
	local int i;
	local MissionLevelUIData UIData;
	local MissionRewardItem tempRewardInfo;
	local MissionLevelStepInfo stepInfo;

	if((GetMissionLevelData(SeasonDate, UIData) == true))
	{
		_missionLevelInfo.RemainTime = UIData.SeasonRemainTime;
		StartSeasonRemainTimer();
		if((_missionLevelInfo.SeasonDate != UIData.SeasonDate))
		{
			_missionLevelInfo.SeasonDate = UIData.SeasonDate;
			_missionLevelInfo.LimitLevel = UIData.LimitLevel;
			_missionLevelInfo.SpecialRewardItem = UIData.SpecialRewardItem;
			_missionLevelInfo.ExtraRewardItem = UIData.ExtraRewardItem;
			_missionLevelInfo.currentStepPage = 1;
			_missionLevelInfo.maxStepPage = Max(appCeil((float(UIData.LimitLevel) / 10.0000000)), 1);
			Debug((((("UpdateMissionLevelInfo : " @ string(_missionLevelInfo.SeasonDate)) @ string(_missionLevelInfo.LimitLevel)) @ string(_missionLevelInfo.RemainTime)) @ string(UIData.BaseRewardItems.Length)));
			_missionLevelInfo.stepInfo.Length = 0;
			i = 0;
			while((i < UIData.BaseRewardItems.Length))
			{
				tempRewardInfo = UIData.BaseRewardItems[i];
				stepInfo.Level = tempRewardInfo.RewardLevel;
				stepInfo.baseRewardItem = tempRewardInfo;
				_missionLevelInfo.stepInfo[tempRewardInfo.RewardLevel] = stepInfo;
				i++;
			}
			i = 0;
			while((i < UIData.KeyRewardItems.Length))
			{
				tempRewardInfo = UIData.KeyRewardItems[i];
				_missionLevelInfo.stepInfo[tempRewardInfo.RewardLevel].keyRewardItem = tempRewardInfo;
				i++;
			}
			_missionLevelInfo.levelJumpLCoin = UIData.LevelJumpLCoinAmount;
			_missionLevelInfo.LevelJumpStartLevel = UIData.LevelJumpStartLevel;
		}
		rewardTooltipBtn.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(14012), string(_missionLevelInfo.LimitLevel))));
	}
	else
	{
		return false;
	}
	return true;
}

function UpdateDefaultStepPage()
{
	local int availableRewardLevel;

	if(((_missionLevelInfo.availableBaseRewardLevel > 0) && (_missionLevelInfo.availableKeyRewardLevel > 0)))
	{
		availableRewardLevel = Max(0, Min(_missionLevelInfo.availableBaseRewardLevel, _missionLevelInfo.availableKeyRewardLevel));
	}
	else if((_missionLevelInfo.availableBaseRewardLevel > 0))
	{
		availableRewardLevel = Max(0, _missionLevelInfo.availableBaseRewardLevel);
	}
	else if((_missionLevelInfo.availableKeyRewardLevel > 0))
	{
		availableRewardLevel = Max(0, _missionLevelInfo.availableKeyRewardLevel);
	}
	else
	{
		availableRewardLevel = Max(0, _missionLevelInfo.CurrentLevel);
	}
	_missionLevelInfo.currentStepPage = Min(Max(appCeil((float(availableRewardLevel) / 10.0000000)), 1), _missionLevelInfo.maxStepPage);
	return;
}

function SetPageNaviMaxPage(int maxPage)
{
	PageNaviControl.SetTotalPage(maxPage);
	return;
}

function SetPageNaviCurrentPage(int Page)
{
	PageNaviControl.Go(Page);
	return;
}

function StartSeasonRemainTimer()
{
	KillSeasonRemainTimer();
	Me.SetTimer(1, 60000);
	return;
}

function KillSeasonRemainTimer()
{
	Me.KillTimer(1);
	_remainTimerCount = 0;
	return;
}

function StartBtnDelayTimer()
{
	_isWaitingBtnDelay = true;
	Me.SetTimer(2, 500);
	return;
}

function KillBtnDelayTimer()
{
	Me.KillTimer(2);
	_isWaitingBtnDelay = false;
	return;
}

function StopAllAnimations()
{
	local int i;

	i = 0;
	while((i < stepControlList.Length))
	{
		stepControlList[i]._StopAllAnimations();
		i++;
	}
	return;
}

function ShowLevelJumpDialog()
{
	levelJumpDialogAsset.SetDialogDesc(MakeFullSystemMsg(GetSystemMessage(14013), string(_missionLevelInfo.LimitLevel)));
	levelJumpDialogAsset.SetUseNeedItem(true);
	levelJumpDialogAsset.StartNeedItemList(1);
	levelJumpDialogAsset.AddNeedItemClassID(91663, INT64(_missionLevelInfo.levelJumpLCoin));
	levelJumpDialogAsset.SetItemNum(1);
	dialogContainer.ShowWindow();
	levelJumpDialogAsset.Show();
	return;
}

function HideLevelJumpDialog()
{
	dialogContainer.HideWindow();
	levelJumpDialogAsset.Hide();
	return;
}

function bool CheckAndHideLevelJumpDialog()
{
	if(dialogContainer.IsShowWindow())
	{
		HideLevelJumpDialog();
		return true;
	}
	return false;
}

function _RequestRewardList()
{
	if((parentWnd.Me.IsShowWindow() == false))
	{
		return;
	}
	Rq_C_EX_MISSION_LEVEL_REWARD_LIST();
	return;
}

event OnLoad()
{
	Initialize();
	return;
}

event OnShow()
{
	return;
}

event OnHide()
{
	return;
}

event OnParentShow()
{
	KillBtnDelayTimer();
	UpdateUIControls();
	ShowSpecialRewardEffect(false);
	_isOpenPacket = true;
	_RequestRewardList();
	return;
}

event OnParentHide()
{
	KillBtnDelayTimer();
	KillSeasonRemainTimer();
	StopAllAnimations();
	HideLevelJumpDialog();
	return;
}

event OnTimer(int TimerID)
{
	if((TimerID == 1))
	{
		_remainTimerCount++;
		UpdateRemainTimeControls();
	}
	else if((TimerID == 2))
	{
		KillBtnDelayTimer();
	}
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(1012));
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_PacketID(1012):
			Rs_S_EX_MISSION_LEVEL_REWARD_LIST();
			break;
		default:
			break;
	}
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "LastRewardGet_BTN":
			OnSpecialRewardGetBtnClicked();
			break;
		case "BonusRewardGet_BTN":
			OnExtraRewardGetBtnClicked();
			break;
		case "ControlNaviAdvance_PrevBtn":
			OnPageStepperClicked(false);
			break;
		case "ControlNaviAdvance_NextBtn":
			OnPageStepperClicked(true);
			break;
		case "ControlNaviAdvance_NextBtn":
			OnPageStepperClicked(true);
			break;
		case "LevelJump_Btn":
			ShowLevelJumpDialog();
			break;
		default:
			break;
	}
	return;
}

event OnLevelJumpDialogCancel()
{
	HideLevelJumpDialog();
	return;
}

event OnLevelJumpDialogConfirm()
{
	Rq_C_EX_MISSION_LEVEL_JUMP_LEVEL();
	HideLevelJumpDialog();
	return;
}

event OnSpecialRewardGetBtnClicked()
{
	if((_isWaitingBtnDelay == true))
	{
		return;
	}
	if((int(_missionLevelInfo.specialRewardState) == 1))
	{
		StartBtnDelayTimer();
		Rq_C_EX_MISSION_LEVEL_RECEIVE_REWARD(_missionLevelInfo.LimitLevel, RewardSpecial);
	}
	return;
}

event OnExtraRewardGetBtnClicked()
{
	if((_isWaitingBtnDelay == true))
	{
		return;
	}
	if((int(_missionLevelInfo.extraRewardState) == 1))
	{
		StartBtnDelayTimer();
		Rq_C_EX_MISSION_LEVEL_RECEIVE_REWARD(_missionLevelInfo.CurrentLevel, RewardExtra);
	}
	return;
}

event OnBaseRewardStepClicked(ToDoListMissionLevelStepItem Owner)
{
	if((_isWaitingBtnDelay == true))
	{
		return;
	}
	if((int(Owner._info.baseRewardState) == 1))
	{
		StartBtnDelayTimer();
		Rq_C_EX_MISSION_LEVEL_RECEIVE_REWARD(Owner._info.baseRewardItem.RewardLevel, RewardBase);
	}
	return;
}

event OnKeyRewardStepClicked(ToDoListMissionLevelStepItem Owner)
{
	if((_isWaitingBtnDelay == true))
	{
		return;
	}
	if((int(Owner._info.keyRewardState) == 1))
	{
		StartBtnDelayTimer();
		Rq_C_EX_MISSION_LEVEL_RECEIVE_REWARD(Owner._info.keyRewardItem.RewardLevel, RewardKey);
	}
	return;
}

event OnPageNaviChanged(int Page)
{
	_missionLevelInfo.currentStepPage = Page;
	UpdateUIControls();
	return;
}

event OnPageStepperClicked(bool isNext)
{
	if((_missionLevelInfo.currentStepPage < 1))
	{
		return;
	}
	if((isNext == true))
	{
		if((_missionLevelInfo.currentStepPage < _missionLevelInfo.maxStepPage))
		{
			_missionLevelInfo.currentStepPage++;
		}
	}
	else if((_missionLevelInfo.currentStepPage > 1))
	{
		_missionLevelInfo.currentStepPage--;
	}
	UpdateUIControls();
	return;
}

function Rq_C_EX_MISSION_LEVEL_REWARD_LIST()
{
	local array<byte> stream;

	Class'Interface.UIPacket'.static.RequestUIPacket(776, stream);
	return;
}

function Rq_C_EX_MISSION_LEVEL_JUMP_LEVEL()
{
	local array<byte> stream;

	Debug("Rq_C_EX_MISSION_LEVEL_JUMP_LEVEL");
	Class'Interface.UIPacket'.static.RequestUIPacket(778, stream);
	return;
}

function Rq_C_EX_MISSION_LEVEL_RECEIVE_REWARD(int Level, EMissionLevelRewardType RewardType)
{
	local array<byte> stream;
	local UIPacket._C_EX_MISSION_LEVEL_RECEIVE_REWARD packet;

	packet.nLevel = Level;
	packet.nRewardType = int(RewardType);
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_MISSION_LEVEL_RECEIVE_REWARD(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(777, stream);
	return;
}

function Rs_S_EX_MISSION_LEVEL_REWARD_LIST()
{
	local UIPacket._S_EX_MISSION_LEVEL_REWARD_LIST packet;
	local int i, firstAvailableBaseLevel, firstAvailableKeyLevel;
	local UIPacket._PkMissionLevelReward rewardInfo;

	firstAvailableBaseLevel = -1;
	firstAvailableKeyLevel = -1;
	if(!Class'Interface.UIPacket'.static.Decode_S_EX_MISSION_LEVEL_REWARD_LIST(packet))
	{
		return;
	}
	if((packet.rewards.Length == 0))
	{
		Debug("Rs_S_EX_MISSION_LEVEL_REWARD_LIST Empty Packet");
		return;
	}
	_missionLevelInfo.extraRewardsAvailable = packet.nExtraRewardsAvailable;
	_missionLevelInfo.CurrentLevel = packet.nLevel;
	_missionLevelInfo.pointPercent = packet.nPointPercent;
	_missionLevelInfo.SeasonYear = packet.nSeasonYear;
	_missionLevelInfo.SeasonMonth = packet.nSeasonMonth;
	_missionLevelInfo.totalRewardsAvailable = packet.nTotalRewardsAvailable;
	_missionLevelInfo.isAccountLevelJumped = bool(packet.bAccountLevelJumped);
	if((packet.nExtraRewardsAvailable > 0))
	{
		_missionLevelInfo.extraRewardState = Available;
	}
	else
	{
		_missionLevelInfo.extraRewardState = Unavailable;
	}
	if(UpdateMissionLevelInfo(((packet.nSeasonYear * 100) + packet.nSeasonMonth)))
	{
		i = 0;
		while((i < packet.rewards.Length))
		{
			rewardInfo = packet.rewards[i];
			if((rewardInfo.nType == 4))
			{
				i++;
				continue;
			}
			if((rewardInfo.nType == 3))
			{
				if(((int(_missionLevelInfo.specialRewardState) == 1) && (_isOpenPacket != true)))
				{
					if((int(byte(rewardInfo.nState)) == 2))
					{
						ShowSpecialRewardEffect(true);
					}
				}
				_missionLevelInfo.specialRewardState = EMissionLevelRewardState(rewardInfo.nState);
				i++;
				continue;
			}
			if((rewardInfo.nType == 1))
			{
				_missionLevelInfo.stepInfo[rewardInfo.nLevel].baseRewardState = EMissionLevelRewardState(rewardInfo.nState);
				if((int(byte(rewardInfo.nState)) == 1))
				{
					if((firstAvailableBaseLevel < 0))
					{
						firstAvailableBaseLevel = rewardInfo.nLevel;
					}
					else
					{
						firstAvailableBaseLevel = Min(firstAvailableBaseLevel, rewardInfo.nLevel);
					}
				}
				i++;
				continue;
			}
			if((rewardInfo.nType == 2))
			{
				_missionLevelInfo.stepInfo[rewardInfo.nLevel].keyRewardState = EMissionLevelRewardState(rewardInfo.nState);
				if((int(byte(rewardInfo.nState)) == 1))
				{
					if((firstAvailableKeyLevel < 0))
					{
						firstAvailableKeyLevel = rewardInfo.nLevel;
						i++;
						continue;
					}
					firstAvailableKeyLevel = Min(firstAvailableKeyLevel, rewardInfo.nLevel);
				}
			}
			i++;
		}
		_missionLevelInfo.availableBaseRewardLevel = firstAvailableBaseLevel;
		_missionLevelInfo.availableKeyRewardLevel = firstAvailableKeyLevel;
	}
	else
	{
		Debug("Not Found MissionLevel Client Season Info");
	}
	if((_isOpenPacket == true))
	{
		_isOpenPacket = false;
		UpdateDefaultStepPage();
	}
	parentWnd._SetMissionLevelRewardNum(packet.nTotalRewardsAvailable);
	UpdateUIControls();
	return;
}
