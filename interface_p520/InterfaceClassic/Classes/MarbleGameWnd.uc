class MarbleGameWnd extends UICommonAPI
	dependson(UIPacket);

const MAX_PLATE = 40;
const DICE_TIMER_ID = 11233;
const DICE_MOVE_TIMER_ID = 11240;
const DiCE_TIMER_DELAY = 3000;
const BOSS_START_TIMER_ID = 11250;
const BOSS_END_TIMER_ID = 11252;
const PLAYER_WIDTH = 18;
const PLAYER_HEIGHT = 56;

enum DiceType
{
	DT_NORMAL,                      // 0
	DT_SPECIAL,                     // 1
	DT_MAX                          // 2
};

enum CellType
{
	CT_NONE,                        // 0
	CT_EVENT,                       // 1
	CT_BUFF,                        // 2
	CT_REWARD,                      // 3
	CT_MINI_GAME,                   // 4
	CT_PRISON                       // 5
};

enum MiniGameBossType
{
	MGBT_NONE,                      // 0
	MGBT_ANTARAS,                   // 1
	MGBT_BAIUM,                     // 2
	MGBT_ZAKEN,                     // 3
	MGBT_QUEENANT,                  // 4
	MGBT_ORFEN,                     // 5
	MGBT_CORE,                      // 6
	MGBT_VALAKAS                    // 7
};

enum MiniGameResultType
{
	MGRT_LOSE,                      // 0
	MGRT_WIN,                       // 1
	MGRT_DRAW                       // 2
};

enum PlayerState
{
	PS_READY,                       // 0
	PS_WAIT_REWARD,                 // 1
	PS_WAIT_MOVE_EVENT,             // 2
	PS_IN_PRISON,                   // 3
	PS_GOAL,                        // 4
	PS_WAIT_RESET,                  // 5
	PS_DONE                         // 6
};

var WindowHandle Me;
var TextureHandle heroPlayerTexture;
var WindowHandle disableWnd;
var WindowHandle PlateDialogWnd;
var TextBoxHandle PlateDialogWnd_Title_Txt;
var TextureHandle PlateDialogWnd_ResultBg_Tex;
var ItemWindowHandle PlateOption_ItemWindow;
var TextBoxHandle PlateOption_Txt;
var TextBoxHandle PlateDesc_Txt;
var WindowHandle BossDialogWnd;
var CharacterViewportWindowHandle BossObjectViewport;
var AnimTextureHandle BossVsAnimTexture;
var TextureHandle BossVsTexture;
var EffectViewportWndHandle EffectViewportBossDice;
var EffectViewportWndHandle EffectViewportUserDice;
var WindowHandle BossResultWnd;
var ItemWindowHandle BossSlotitem;
var TextBoxHandle BossSlotitemNameText;
var TextBoxHandle BossLuckyNumberText;
var EffectViewportWndHandle effectViewportBossReward;
var TextureHandle BossResultHeaderBgTexture;
var TextureHandle BossOkHighlightTexture;
var ButtonHandle FightBossButton;
var TextBoxHandle bossHeaderText;
var TextBoxHandle bossFlagText;
var TextBoxHandle UserFlagText;
var TextBoxHandle bossOkText;
var WindowHandle DesertIslandDialogWnd;
var TextureHandle DesertIslandStartTexture;
var TextBoxHandle DesertIslandRemainTimeTxt;
var TextBoxHandle DesertIslandDesc_Txt;
var WindowHandle DiceDialogWnd;
var EffectViewportWndHandle DiceEffectViewport;
var WindowHandle RewardRichListWnd;
var RichListCtrlHandle RewardRichList;
var ButtonHandle DiceBtn01;
var ButtonHandle DiceBtn02;
var ButtonHandle DiceHelpBtn01;
var ButtonHandle DiceHelpBtn02;
var TextBoxHandle DiceBtn01Name_Txt;
var TextBoxHandle DiceBtn02Name_Txt;
var TextBoxHandle DiceBtn01ItemWndName_Txt;
var TextBoxHandle DiceBtn02ItemWndName_Txt;
var TextBoxHandle CompleteDesc_Txt;
var WindowHandle CompleteWnd;
var EffectViewportWndHandle CompleteViewport;
var TextBoxHandle CompleteTitle_Txt;
var TextBoxHandle CompleteItemName_Txt;
var ItemWindowHandle Complete_Itemwindow;
var WindowHandle ResetWnd;
var TextBoxHandle ResetTitle_Txt;
var TextBoxHandle ResetItemName_Txt;
var ItemWindowHandle Reset_Itemwindow;
var WindowHandle FianlCompleteWnd;
var string m_Windowname;
var L2UITween l2UITweenScript;
var int toPlayerToMoveNum;
var int currentPlayerToMoveNum;
var Rect meRect;
var bool bPrisonMode;
var int desertIslandRemainTime;
var L2Util util;
var bool bFirstRun;
var bool bRecover;
var int nMaxNormalDiceUseCount;
var int nRemainNormalDiceUseCount;
var int currentCellType;
var int currentMableGamePlayCount;
var int maxMableGamePlayCount;
var int currentRewardClassID;
var INT64 currentRewardItemNum;
var int currentCellId;
var int beforeCellId;
var int currentRewardBuffID;
var int currentRewardBuffLevel;
var int currentDiceType;
var int CurrentState;
var int currentCompleteItemID;
var INT64 currentCompleteItemNum;
var int currentResetItemID;
var INT64 currentResetItemNum;
var int currentDiceResult;
var bool bEnableDice;
var UIPacket._S_EX_MABLE_GAME_MINIGAME currentEx_BossMiniGame;
var UIPacket._S_EX_MABLE_GAME_PRISON currentEx_Prison;
var UIPacket._S_EX_MABLE_GAME_MOVE currentEx_Move;
var int BossPlayerDice;
var int BossEnemyDice;
var int BossLuckyNumber;
var array<MableGameCellRewardItem> MableGameCellRewardItemArray;
var array<MableGameCellData> MableGameCellDataArray;

function OnRegisterEvent()
{
	RegisterEvent(15);
	RegisterEvent((100000 + 871));
	RegisterEvent((100000 + 872));
	RegisterEvent((100000 + 873));
	RegisterEvent((100000 + 874));
	RegisterEvent((100000 + 875));
	RegisterEvent((100000 + 876));
	RegisterEvent((100000 + 877));
	RegisterEvent((100000 + 878));
	RegisterEvent(9570);
	RegisterEvent(40);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

function Initialize()
{
	l2UITweenScript = L2UITween(GetScript("l2UITween"));
	util = L2Util(GetScript("L2Util"));
	Me = GetWindowHandle(m_Windowname);
	heroPlayerTexture = GetTextureHandle((m_Windowname $ ".heroPlayerTexture"));
	DiceDialogWnd = GetWindowHandle((m_Windowname $ ".DiceDialogWnd"));
	DiceEffectViewport = GetEffectViewportWndHandle((m_Windowname $ ".DiceDialogWnd.DiceEffectViewport"));
	PlateDialogWnd = GetWindowHandle((m_Windowname $ ".PlateDialogWnd"));
	PlateDialogWnd_Title_Txt = GetTextBoxHandle((m_Windowname $ ".PlateDialogWnd.Title_Txt"));
	PlateDialogWnd_ResultBg_Tex = GetTextureHandle((m_Windowname $ ".PlateDialogWnd.ResultBg_Tex"));
	PlateOption_ItemWindow = GetItemWindowHandle((m_Windowname $ ".PlateDialogWnd.PlateOption_ItemWindow"));
	PlateOption_Txt = GetTextBoxHandle((m_Windowname $ ".PlateDialogWnd.PlateOption_Txt"));
	PlateDesc_Txt = GetTextBoxHandle((m_Windowname $ ".PlateDialogWnd.PlateDesc_Txt"));
	disableWnd = GetWindowHandle((m_Windowname $ ".DisableWnd"));
	BossDialogWnd = GetWindowHandle((m_Windowname $ ".BossDialogWnd"));
	BossObjectViewport = GetCharacterViewportWindowHandle((m_Windowname $ ".BossDialogWnd.BossObjectViewport"));
	BossVsAnimTexture = GetAnimTextureHandle((m_Windowname $ ".BossDialogWnd.BossVsAnimTexture"));
	BossVsTexture = GetTextureHandle((m_Windowname $ ".BossDialogWnd.BossVsTexture"));
	BossResultWnd = GetWindowHandle((m_Windowname $ ".BossDialogWnd.BossResultWnd"));
	BossSlotitemNameText = GetTextBoxHandle((m_Windowname $ ".BossDialogWnd.BossResultWnd.ResultPopupWnd.BossSlotitemNameText"));
	BossLuckyNumberText = GetTextBoxHandle((m_Windowname $ ".BossDialogWnd.BossResultWnd.ResultPopupWnd.BossLuckyNumberText"));
	effectViewportBossReward = GetEffectViewportWndHandle((m_Windowname $ ".BossDialogWnd.BossResultWnd.ResultPopupWnd.EffectViewportReward"));
	BossSlotitem = GetItemWindowHandle((m_Windowname $ ".BossDialogWnd.BossResultWnd.ResultPopupWnd.BossSlotitem"));
	BossResultHeaderBgTexture = GetTextureHandle((m_Windowname $ ".BossDialogWnd.BossResultWnd.ResultPopupWnd.BossResultHeaderBgTexture"));
	bossHeaderText = GetTextBoxHandle((m_Windowname $ ".BossDialogWnd.HeaderText"));
	bossFlagText = GetTextBoxHandle((m_Windowname $ ".BossDialogWnd.bossFlagText"));
	UserFlagText = GetTextBoxHandle((m_Windowname $ ".BossDialogWnd.UserFlagText"));
	bossOkText = GetTextBoxHandle((m_Windowname $ ".BossDialogWnd.OkText"));
	FightBossButton = GetButtonHandle((m_Windowname $ ".BossDialogWnd.FightBossButton"));
	BossOkHighlightTexture = GetTextureHandle((m_Windowname $ ".BossDialogWnd.OkHighlightTexture"));
	EffectViewportBossDice = GetEffectViewportWndHandle((m_Windowname $ ".BossDialogWnd.EffectViewportBossDice"));
	EffectViewportUserDice = GetEffectViewportWndHandle((m_Windowname $ ".BossDialogWnd.EffectViewportUserDice"));
	DesertIslandDialogWnd = GetWindowHandle((m_Windowname $ ".DesertIslandDialogWnd"));
	DesertIslandStartTexture = GetTextureHandle((m_Windowname $ ".DesertIslandDialogWnd.DesertIslandStartTexture"));
	DesertIslandRemainTimeTxt = GetTextBoxHandle((m_Windowname $ ".DesertIslandDialogWnd.DesertIslandRemainTimeTxt"));
	DesertIslandDesc_Txt = GetTextBoxHandle((m_Windowname $ ".DesertIslandDialogWnd.DesertIslandDesc_Txt"));
	RewardRichListWnd = GetWindowHandle((m_Windowname $ ".RewardRichListWnd"));
	RewardRichList = GetRichListCtrlHandle((m_Windowname $ ".RewardRichListWnd.RewardRichList"));
	DiceBtn01 = GetButtonHandle((m_Windowname $ ".DiceBtn01"));
	DiceBtn02 = GetButtonHandle((m_Windowname $ ".DiceBtn02"));
	DiceHelpBtn01 = GetButtonHandle((m_Windowname $ ".DiceHelpBtn01"));
	DiceHelpBtn02 = GetButtonHandle((m_Windowname $ ".DiceHelpBtn02"));
	DiceBtn01Name_Txt = GetTextBoxHandle((m_Windowname $ ".DiceBtn01Name_Txt"));
	DiceBtn02Name_Txt = GetTextBoxHandle((m_Windowname $ ".DiceBtn02Name_Txt"));
	DiceBtn01ItemWndName_Txt = GetTextBoxHandle((m_Windowname $ ".DiceBtn01ItemWndName_Txt"));
	DiceBtn02ItemWndName_Txt = GetTextBoxHandle((m_Windowname $ ".DiceBtn02ItemWndName_Txt"));
	CompleteDesc_Txt = GetTextBoxHandle((m_Windowname $ ".CompleteDesc_Txt"));
	CompleteWnd = GetWindowHandle((m_Windowname $ ".CompleteWnd"));
	CompleteViewport = GetEffectViewportWndHandle((m_Windowname $ ".CompleteWnd.CompleteViewport"));
	CompleteTitle_Txt = GetTextBoxHandle((m_Windowname $ ".CompleteWnd.CompleteTitle_Txt"));
	CompleteItemName_Txt = GetTextBoxHandle((m_Windowname $ ".CompleteWnd.CompleteItemName_Txt"));
	Complete_Itemwindow = GetItemWindowHandle((m_Windowname $ ".CompleteWnd.Complete_Itemwindow"));
	ResetWnd = GetWindowHandle((m_Windowname $ ".ResetWnd"));
	ResetTitle_Txt = GetTextBoxHandle((m_Windowname $ ".ResetWnd.ResetTitle_Txt"));
	ResetItemName_Txt = GetTextBoxHandle((m_Windowname $ ".ResetWnd.ResetItemName_Txt"));
	Reset_Itemwindow = GetItemWindowHandle((m_Windowname $ ".ResetWnd.Reset_Itemwindow"));
	FianlCompleteWnd = GetWindowHandle((m_Windowname $ ".FianlCompleteWnd"));
	bossHeaderText.SetText("");
	bossFlagText.SetText("");
	RewardRichList.SetSelectedSelTooltip(false);
	RewardRichList.SetAppearTooltipAtMouseX(true);
	SetCusomTooltipAtHelpBtn();
	BossVsTexture.HideWindow();
	return;
}

function OnShow()
{
	PlaySound("ItemSound3.minigame_start");
	clearCurrentStateVar();
	initControl();
	Me.SetFocus();
	SideBar(GetScript("sideBar")).ToggleByWindowName(m_Windowname, Me.IsShowWindow());
	return;
}

function OnHide()
{
	API_C_EX_MABLE_GAME_CLOSE();
	clearCurrentStateVar();
	initControl();
	SideBar(GetScript("sideBar")).ToggleByWindowName(m_Windowname, Me.IsShowWindow());
	return;
}

function initControl()
{
	ResetWnd.HideWindow();
	CompleteWnd.HideWindow();
	DiceDialogWnd.HideWindow();
	PlateDialogWnd.HideWindow();
	FianlCompleteWnd.HideWindow();
	BossDialogWnd.HideWindow();
	DesertIslandDialogWnd.HideWindow();
	Me.KillTimer(11233);
	Me.KillTimer(11240);
	Me.KillTimer(11250);
	Me.KillTimer(11252);
	SetDisable(false);
	setRewardViewButton(false);
	BossObjectViewport.HideNPC(0.0000000);
	BossObjectViewport.SetUISound(false);
	return;
}

function clearCurrentStateVar()
{
	currentRewardBuffID = 0;
	currentRewardBuffLevel = 0;
	currentRewardClassID = 0;
	currentRewardItemNum = INT64(0);
	bPrisonMode = false;
	toPlayerToMoveNum = 0;
	beforeCellId = 1;
	currentCellType = 0;
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 40))
	{
		bFirstRun = false;
	}
	else if((Event_ID == 9570))
	{
		if(Me.IsShowWindow())
		{
			updateDiceState();
		}
	}
	else if((Event_ID == (100000 + 871)))
	{
		initControl();
		ParsePacket_S_EX_MABLE_GAME_SHOW_PLAYER_STATE();
	}
	else if((Event_ID == (100000 + 872)))
	{
		ParsePacket_S_EX_MABLE_GAME_DICE_RESULT();
	}
	else if((Event_ID == (100000 + 873)))
	{
		ParsePacket_S_EX_MABLE_GAME_MOVE();
	}
	else if((Event_ID == (100000 + 874)))
	{
		ParsePacket_S_EX_MABLE_GAME_PRISON();
	}
	else if((Event_ID == (100000 + 875)))
	{
		ParsePacket_S_EX_MABLE_GAME_REWARD_ITEM();
	}
	else if((Event_ID == (100000 + 876)))
	{
		ParsePacket_S_EX_MABLE_GAME_SKILL_INFO();
	}
	else if((Event_ID == (100000 + 877)))
	{
		ParsePacket_S_EX_MABLE_GAME_MINIGAME();
	}
	else if((Event_ID == (100000 + 878)))
	{
		ParsePacket_S_EX_MABLE_GAME_PLAY_UNABLE();
	}
	return;
}

function ParsePacket_S_EX_MABLE_GAME_REWARD_ITEM()
{
	local UIPacket._S_EX_MABLE_GAME_REWARD_ITEM packet;
	local MableGameEventData tMableGameEventData;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_MABLE_GAME_REWARD_ITEM(packet))
	{
		return;
	}
	Debug(((" -->  S_EX_MABLE_GAME_REWARD_ITEM :  " @ string(packet.nRewardItemClassId)) @ string(packet.nRewardItemAmount)));
	currentCellType = 3;
	currentRewardClassID = packet.nRewardItemClassId;
	currentRewardItemNum = packet.nRewardItemAmount;
	GetMableGameEventData(currentCellId, MGET_REWARD, tMableGameEventData);
	Debug((" tMableGameEventData.EventDesc  " @ tMableGameEventData.EventDesc));
	Debug((" tMableGameEventData.EventGroupDesc  " @ tMableGameEventData.EventGroupDesc));
	if((currentCellId > 39))
	{
		if((CurrentState == 4))
		{
			enableDiceBtn(false);
			showDialogCompleteReward(currentRewardClassID, currentRewardItemNum);
		}
	}
	else if(((toPlayerToMoveNum == 0) && bRecover))
	{
		enableDiceBtn(false);
		showPlateDialog();
	}
	return;
}

function ParsePacket_S_EX_MABLE_GAME_SKILL_INFO()
{
	local UIPacket._S_EX_MABLE_GAME_SKILL_INFO packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_MABLE_GAME_SKILL_INFO(packet))
	{
		return;
	}
	Debug(((" -->  Decode_S_EX_MABLE_GAME_SKILL_INFO :  " @ string(packet.nSkillID)) @ string(packet.nLev)));
	currentCellType = 2;
	currentRewardBuffID = packet.nSkillID;
	currentRewardBuffLevel = packet.nLev;
	return;
}

function ParsePacket_S_EX_MABLE_GAME_PRISON()
{
	local UIPacket._S_EX_MABLE_GAME_PRISON packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_MABLE_GAME_PRISON(packet))
	{
		return;
	}
	Debug((((" -->  Decode_S_EX_MABLE_GAME_PRISON :  " @ string(packet.nMinDiceForLeavePrison)) @ string(packet.nMaxDiceForLeavePrison)) @ string(packet.nRemainCount)));
	currentEx_Prison = packet;
	desertIslandRemainTime = packet.nRemainCount;
	DesertIslandRemainTimeTxt.SetText(((GetSystemString(3624) $ ": ") $ string(currentEx_Prison.nRemainCount)));
	DesertIslandDesc_Txt.SetText(MakeFullSystemMsg(GetSystemMessage(13208), string(packet.nMinDiceForLeavePrison)));
	if(((toPlayerToMoveNum == 0) && bRecover))
	{
		OpenCard_DesertIslandMode();
	}
	return;
}

function ParsePacket_S_EX_MABLE_GAME_MINIGAME()
{
	local UIPacket._S_EX_MABLE_GAME_MINIGAME packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_MABLE_GAME_MINIGAME(packet))
	{
		return;
	}
	Debug(((((((((" -->  Decode_S_EX_MABLE_GAME_MINIGAME :  " @ string(packet.nBossType)) @ string(packet.nLuckyNumber)) @ string(packet.nMyDice)) @ string(packet.nBossDice)) @ string(packet.cMiniGameResult)) @ string(packet.bLuckyNumber)) @ string(packet.nRewardItemClassId)) @ string(packet.nRewardItemAmount)));
	currentEx_BossMiniGame = packet;
	currentCellType = 4;
	currentRewardClassID = packet.nRewardItemClassId;
	currentRewardItemNum = packet.nRewardItemAmount;
	if(((packet.nMyDice == 0) && (packet.nBossDice == 0)))
	{
		enableDiceBtn(false);
		startBossResult();
	}
	return;
}

function ParsePacket_S_EX_MABLE_GAME_PLAY_UNABLE()
{
	Me.HideWindow();
	Debug("--> ParsePacket_S_EX_MABLE_GAME_PLAY_UNABLE");
	return;
}

function ParsePacket_S_EX_MABLE_GAME_SHOW_PLAYER_STATE()
{
	local UIPacket._S_EX_MABLE_GAME_SHOW_PLAYER_STATE packet;
	local int i, currentindex;

	if((bFirstRun == false))
	{
		makeGameStage();
	}
	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_MABLE_GAME_SHOW_PLAYER_STATE(packet))
	{
		return;
	}
	Debug((((((" -->  Decode_S_EX_MABLE_GAME_SHOW_PLAYER_STATE :  " @ string(packet.nMableGamePlayCount)) @ string(packet.nCurrentCellId)) @ string(packet.nRemainNormalDiceUseCount)) @ string(packet.nMaxNormalDiceUseCount)) @ string(packet.cCurrentState)));
	bRecover = true;
	clearRichList();
	i = 0;
	while((i < packet.vFinishRewards.Length))
	{
		AddItemAtRichList(packet.vFinishRewards[i].nPlayCount, packet.vFinishRewards[i].nItemClassID, packet.vFinishRewards[i].nItemAmount, (packet.nMableGamePlayCount == packet.vFinishRewards[i].nPlayCount));
		if((packet.nMableGamePlayCount == packet.vFinishRewards[i].nPlayCount))
		{
			currentindex = i;
		}
		i++;
	}
	maxMableGamePlayCount = packet.vFinishRewards.Length;
	RewardRichList.SetSelectedIndex(currentindex, true);
	i = 0;
	while((i < packet.vResetItems.Length))
	{
		currentResetItemID = packet.vResetItems[i].nItemClassID;
		currentResetItemNum = packet.vResetItems[i].nAmount;
		break;
		i++;
	}
	currentMableGamePlayCount = packet.nMableGamePlayCount;
	currentCellId = packet.nCurrentCellId;
	nMaxNormalDiceUseCount = packet.nMaxNormalDiceUseCount;
	nRemainNormalDiceUseCount = packet.nRemainNormalDiceUseCount;
	CurrentState = packet.cCurrentState;
	Me.ShowWindow();
	CompleteDesc_Txt.SetText(MakeFullSystemMsg(GetSystemMessage(13196), string(packet.nMableGamePlayCount)));
	updateDiceState();
	currentPlayerToMoveNum = packet.nCurrentCellId;
	movePlate(currentPlayerToMoveNum);
	enableDiceBtn(true);
	switch(packet.cCurrentState)
	{
		case 0:
			break;
		case 1:
			break;
		case 2:
			break;
		case 3:
			break;
		case 4:
			break;
		case 5:
			enableDiceBtn(false);
			showDialogReset(currentResetItemID, currentResetItemNum);
			break;
		case 6:
			enableDiceBtn(false);
			SetDisable(true);
			FianlCompleteWnd.ShowWindow();
			FianlCompleteWnd.SetFocus();
			break;
		default:
			break;
	}
	return;
}

function updateDiceState()
{
	local INT64 adDiceItemNum, norDiceItemNum;
	local int normalDiceClassID, specialDiceClassID;

	if(getInstanceUIData().GetIsClassicServer())
	{
		normalDiceClassID = 93885;
		specialDiceClassID = 93886;
	}
	else
	{
		normalDiceClassID = 81461;
		specialDiceClassID = 81462;
	}
	norDiceItemNum = setDiceButtonInfo(true, normalDiceClassID);
	if((((nRemainNormalDiceUseCount > 0) && (norDiceItemNum > INT64(0))) && bEnableDice))
	{
		DiceBtn02.EnableWindow();
		DiceBtn02Name_Txt.SetTextColor(getInstanceL2Util().White);
	}
	else
	{
		DiceBtn02.DisableWindow();
		DiceBtn02Name_Txt.SetTextColor(getInstanceL2Util().Gray);
	}
	DiceBtn02Name_Txt.SetText((((((GetSystemString(13313) $ " (") $ string(nRemainNormalDiceUseCount)) $ "/") $ string(nMaxNormalDiceUseCount)) $ ")"));
	adDiceItemNum = setDiceButtonInfo(false, specialDiceClassID);
	if(((adDiceItemNum > INT64(0)) && bEnableDice))
	{
		DiceBtn01.EnableWindow();
		DiceBtn01Name_Txt.SetTextColor(getInstanceL2Util().White);
	}
	else
	{
		DiceBtn01.DisableWindow();
		DiceBtn01Name_Txt.SetTextColor(getInstanceL2Util().Gray);
	}
	return;
}

function ParsePacket_S_EX_MABLE_GAME_DICE_RESULT()
{
	local UIPacket._S_EX_MABLE_GAME_DICE_RESULT packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_MABLE_GAME_DICE_RESULT(packet))
	{
		return;
	}
	Debug(((((" -->  Decode_S_EX_MABLE_GAME_DICE_RESULT :  " @ string(packet.nDice)) @ string(packet.nResultCellId)) @ string(packet.cResultCellType)) @ string(packet.nRemainNormalDiceUseCount)));
	Debug(("before currentCellId" @ string(currentCellId)));
	toPlayerToMoveNum = (packet.nResultCellId - currentCellId);
	currentDiceResult = packet.nDice;
	beforeCellId = currentCellId;
	currentCellId = packet.nResultCellId;
	currentCellType = packet.cResultCellType;
	nRemainNormalDiceUseCount = packet.nRemainNormalDiceUseCount;
	Debug(("toPlayerToMoveNum" @ string(toPlayerToMoveNum)));
	Debug("주사위 돌리기 effect Show");  // EN?: Dice Spin effect Show
	DiceDialogWnd.ShowWindow();
	DiceDialogWnd.SetFocus();
	DiceEffectViewport.ShowWindow();
	DiceEffectViewport.SetFocus();
	DiceEffectViewport.SetCameraPitch(-10000);
	DiceEffectViewport.SetCameraYaw((Rand(5000) - 2500));
	if((currentDiceType == 0))
	{
		DiceEffectViewport.SpawnEffect((("LineageEffect2.white_black_" $ string(packet.nDice)) $ "_dice"));
	}
	else
	{
		DiceEffectViewport.SpawnEffect((("LineageEffect2.yellow_black_" $ string(packet.nDice)) $ "_dice"));
	}
	enableDiceBtn(false);
	FightBossButton.DisableWindow();
	FightBossButton.HideWindow();
	BossOkHighlightTexture.HideWindow();
	bossOkText.HideWindow();
	Me.KillTimer(11233);
	Me.SetTimer(11233, 3000);
	return;
}

function ParsePacket_S_EX_MABLE_GAME_MOVE()
{
	local UIPacket._S_EX_MABLE_GAME_MOVE packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_MABLE_GAME_MOVE(packet))
	{
		return;
	}
	Debug((((" -->  Decode_S_EX_MABLE_GAME_MOVE  :  " @ string(packet.nMoveDelta)) @ string(packet.nResultCellId)) @ string(packet.cResultCellType)));
	beforeCellId = currentCellId;
	currentCellId = packet.nResultCellId;
	currentCellType = 1;
	currentEx_Move = packet;
	return;
}

function INT64 setDiceButtonInfo(bool bNormal, int ItemClassID)
{
	local array<ItemInfo> itemInfoArray;
	local INT64 ItemNum;

	Class'NWindow.UIDATA_INVENTORY'.static.FindItemByClassID(ItemClassID, itemInfoArray);
	if((itemInfoArray.Length > 0))
	{
		ItemNum = itemInfoArray[0].ItemNum;
	}
	else
	{
		ItemNum = INT64(0);
	}
	if(bNormal)
	{
		DiceBtn02ItemWndName_Txt.SetText(((GetItemNameAll(GetItemInfoByClassID(ItemClassID)) $ " x ") $ string(ItemNum)));
	}
	else
	{
		DiceBtn01ItemWndName_Txt.SetText(((GetItemNameAll(GetItemInfoByClassID(ItemClassID)) $ " x ") $ string(ItemNum)));
	}
	return ItemNum;
}

function SetCusomTooltipAtHelpBtn()
{
	local array<DrawItemInfo> drawListArr1, drawListArr2;

	drawListArr1[drawListArr1.Length] = addDrawItemText(GetSystemString(13314), getInstanceL2Util().White, "");
	drawListArr2[drawListArr2.Length] = addDrawItemText(GetSystemString(13315), getInstanceL2Util().White, "");
	DiceHelpBtn01.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr1, 180));
	DiceHelpBtn02.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr2, 180));
	return;
}

function string getPlateIndex(int Index)
{
	switch(Index)
	{
		case 1:
			return "L2UI_CT1.EmptyBtn";
		case 2:
			return "L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_Plate_Yellow01_";
		case 3:
			return "L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_Plate_Violet_";
		case 4:
			return "L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_Plate_Red_";
		case 5:
			return "L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_Plate_Green_";
		case 6:
			return "L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_Plate_White_";
		case 7:
			return "L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_Plate_Yellow02_";
		case 8:
			return "L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_Plate_Red2_";
		case 9:
			return "L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_Plate_VioletDebuff_";
		default:
			return "";
	}
}

function enableDiceBtn(bool flag)
{
	bEnableDice = flag;
	if(flag)
	{
		Debug("=------------ enableDiceBtn 켜라!");  // EN?: = ------------ enableDiceBtn Turn it on!
		DiceBtn01.EnableWindow();
		DiceBtn02.EnableWindow();
		updateDiceState();
	}
	else
	{
		Debug("=------------ enableDiceBtn 끄기 !");  // EN?: = ------------ enableDiceBtn off!
		DiceBtn01.DisableWindow();
		DiceBtn02.DisableWindow();
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "DiceBtn01":
			enableDiceBtn(false);
			API_C_EX_MABLE_GAME_ROLL_DICE(1);
			break;
		case "DiceBtn02":
			enableDiceBtn(false);
			API_C_EX_MABLE_GAME_ROLL_DICE(0);
			break;
		case "Complete_Btn":
			API_C_EX_MABLE_GAME_POPUP_OK(3);
			CompleteWnd.HideWindow();
			SetDisable(false);
			Debug("-------------------");
			Debug(("currentMableGamePlayCount" @ string(currentMableGamePlayCount)));
			Debug(("maxMableGamePlayCount" @ string(maxMableGamePlayCount)));
			if((currentMableGamePlayCount >= maxMableGamePlayCount))
			{
				enableDiceBtn(false);
				SetDisable(true);
				FianlCompleteWnd.ShowWindow();
				FianlCompleteWnd.SetFocus();
			}
			else
			{
				showDialogReset(currentResetItemID, currentResetItemNum);
			}
			break;
		case "Reset_Btn":
			API_C_EX_MABLE_GAME_RESET(1);
			SetDisable(false);
			ResetWnd.HideWindow();
			break;
		case "ResetClose_Btn":
			SetDisable(false);
			ResetWnd.HideWindow();
			Me.HideWindow();
			break;
		case "PlateOK_Btn":
			SetDisable(false);
			PlateDialogWnd.HideWindow();
			if((currentCellType == 3))
			{
				API_C_EX_MABLE_GAME_POPUP_OK(currentCellType);
				clearCurrentStateVar();
				enableDiceBtn(true);
				return;
			}
			else if((currentCellType == 1))
			{
				Debug(("currentEx_Move.cResultCellType" @ string(currentEx_Move.cResultCellType)));
				if((currentEx_Move.nMoveDelta == 0))
				{
					currentPlayerToMoveNum = currentEx_Move.nResultCellId;
					Debug(("currentCellId" @ string(currentCellId)));
					Debug(("currentPlayerToMoveNum" @ string(currentPlayerToMoveNum)));
					teleportMovePlate(beforeCellId);
					updateDiceState();
				}
				else
				{
					toPlayerToMoveNum = currentEx_Move.nMoveDelta;
					startMovePlate(currentPlayerToMoveNum);
				}
				API_C_EX_MABLE_GAME_POPUP_OK(currentCellType);
				currentCellType = currentEx_Move.cResultCellType;
				return;
			}
			else if((currentCellType == 4))
			{
				OpenCard_BossMode(true);
			}
			else if((currentCellType == 5))
			{
				enableDiceBtn(true);
				OpenCard_DesertIslandMode();
			}
			else
			{
				enableDiceBtn(true);
			}
			break;
		case "FightBossButton":
			PlaySound("InterfaceSound.Event.AdenDice_Throw");
			BossPlayerDice = currentEx_BossMiniGame.nMyDice;
			BossEnemyDice = currentEx_BossMiniGame.nBossDice;
			Debug(("currentEx_BossMiniGame.nMyDice " @ string(currentEx_BossMiniGame.nMyDice)));
			Debug(("currentEx_BossMiniGame.nBossDice " @ string(currentEx_BossMiniGame.nBossDice)));
			FightBossButton.DisableWindow();
			FightBossButton.HideWindow();
			BossOkHighlightTexture.HideWindow();
			bossOkText.HideWindow();
			EffectViewportUserDice.SetCameraPitch(-10000);
			EffectViewportUserDice.SetCameraYaw((Rand(5000) - 2500));
			EffectViewportUserDice.SpawnEffect((("LineageEffect2.white_black_" $ string(BossPlayerDice)) $ "_dice"));
			EffectViewportBossDice.SetCameraPitch(-10000);
			EffectViewportBossDice.SetCameraYaw((Rand(5000) - 2500));
			EffectViewportBossDice.SpawnEffect((("LineageEffect2.white_red_" $ string(BossEnemyDice)) $ "_dice"));
			Me.KillTimer(11250);
			Me.SetTimer(11250, 3000);
			BossObjectViewport.PlayAttackAnimation(1);
			break;
		case "BossRewardButton":
			Debug("보스 보상");  // EN?: Boss Rewards
			Me.KillTimer(11252);
			SetDisable(false);
			BossDialogWnd.HideWindow();
			BossResultWnd.HideWindow();
			enableDiceBtn(true);
			FightBossButton.ShowWindow();
			FightBossButton.EnableWindow();
			BossOkHighlightTexture.ShowWindow();
			bossOkText.ShowWindow();
			BossObjectViewport.HideNPC(0.0000000);
			BossObjectViewport.SetUISound(false);
			API_C_EX_MABLE_GAME_POPUP_OK(currentCellType);
			break;
		case "ItemListWnd_Btn":
			if(RewardRichListWnd.IsShowWindow())
			{
				setRewardViewButton(false);
			}
			else
			{
				setRewardViewButton(true);
			}
			break;
		case "FianlComplete_Btn":
			Me.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function setRewardViewButton(bool bFlag)
{
	if(bFlag)
	{
		RewardRichListWnd.ShowWindow();
		RewardRichListWnd.SetFocus();
		RewardRichList.SetFocus();
		GetButtonHandle("MarbleGameWnd.ItemListWnd_Btn").SetTexture("L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_DownBtn_Normal", "L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_DownBtn_Down", "L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_DownBtn_Over");
	}
	else
	{
		RewardRichListWnd.HideWindow();
		GetButtonHandle("MarbleGameWnd.ItemListWnd_Btn").SetTexture("L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_UpBtn_Normal", "L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_UpBtn_Down", "L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_UpBtn_Over");
	}
	return;
}

function clearRichList()
{
	RewardRichList.DeleteAllItem();
	return;
}

function AddItemAtRichList(int nPlayCount, int nItemID, INT64 ItemNum, optional bool bSelect)
{
	local RichListCtrlRowData rowData;
	local string param;
	local ItemInfo Info;

	rowData.cellDataList.Length = 2;
	Info = GetItemInfoByClassID(nItemID);
	Info.ItemNum = ItemNum;
	ItemInfoToParam(Info, param);
	rowData.szReserved = param;
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, 0, 0);
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems, Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(GetItemID(nItemID)), 32, 32, -34, 2);
	if(bSelect)
	{
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, MakeFullSystemMsg(GetSystemMessage(13195), string(nPlayCount)), util.Yellow, false, 4, 8);
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, MakeFullSystemMsg(GetSystemMessage(13195), string(nPlayCount)), util.White, false, 4, 8);
	}
	RewardRichList.InsertRecord(rowData);
	return;
}

function OpenCard_DesertIslandMode()
{
	PlaySound("ItemSound3.minigame_over");
	bPrisonMode = true;
	SetDisable(true);
	DesertIslandDialogWnd.ShowWindow();
	return;
}

function OpenCard_BossMode(bool bVsAnimUse)
{
	local string NpcName;
	local UserInfo myUserInfo;
	local int NpcDist3, NpcDist4;

	if(bVsAnimUse)
	{
		BossVsTexture.HideWindow();
		BossVsAnimTexture.Stop();
		BossVsAnimTexture.ShowWindow();
		BossVsAnimTexture.Play();
		PlaySound("InterfaceSound.Event.AdenDice_BossSpawn");
	}
	if((currentEx_BossMiniGame.nLuckyNumber > 0))
	{
		BossLuckyNumberText.SetText(((GetSystemString(13309) $ ": ") $ string(currentEx_BossMiniGame.nLuckyNumber)));
	}
	else
	{
		BossLuckyNumberText.SetText("");
	}
	SetDisable(true);
	GetPlayerInfo(myUserInfo);
	UserFlagText.SetText(myUserInfo.Name);
	BossDialogWnd.ShowWindow();
	BossDialogWnd.SetFocus();
	FightBossButton.ShowWindow();
	FightBossButton.EnableWindow();
	BossOkHighlightTexture.ShowWindow();
	bossOkText.ShowWindow();
	if(getInstanceUIData().GetIsLiveServer())
	{
		NpcDist3 = 4400;
		NpcDist4 = 4400;
	}
	else
	{
		NpcDist3 = 400;
		NpcDist4 = 800;
	}
	switch(currentEx_BossMiniGame.nBossType)
	{
		case 1:
			playNpcViewport(BossObjectViewport, 19781, 4500, 28000, 150, 10, 0.0000000, "");
			NpcName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(19781);
			break;
		case 2:
			playNpcViewport(BossObjectViewport, 19782, 2300, 33000, 0, 0, 0.0000000, "");
			NpcName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(19782);
			break;
		case 3:
			playNpcViewport(BossObjectViewport, 19783, NpcDist3, 33000, 0, -4, 0.0000000, "");
			NpcName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(19783);
			break;
		case 4:
			playNpcViewport(BossObjectViewport, 19784, NpcDist4, 30000, 30, 0, 0.0000000, "");
			NpcName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(19784);
			break;
		case 5:
			playNpcViewport(BossObjectViewport, 19785, 750, 34000, 0, 0, 0.0000000, "");
			NpcName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(19785);
			break;
		default:
			playNpcViewport(BossObjectViewport, 19786, 6000, 33000, 0, 380, 0.0000000, "");
			NpcName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(19786);
			break;
	}
	bossHeaderText.SetText(GetSystemMessage(3441));
	bossFlagText.SetText(NpcName);
	return;
}

function MakeShakeObject()
{
	l2UITweenScript.StartShake((m_Windowname $ ".heroPlayerTexture"), 6, 500, small, 0);
	return;
}

function movePlate(int fromPlateNum)
{
	local string prevWnd, serverStr;
	local int nX, nY;

	if(getInstanceUIData().GetIsClassicServer())
	{
		serverStr = "GameBoardStageClassic";
	}
	else
	{
		serverStr = "GameBoardStageLive";
	}
	prevWnd = ((((m_Windowname $ ".") $ serverStr) $ ".BoardPlate") $ getInstanceL2Util().makeZeroString(2, INT64(fromPlateNum)));
	meRect = Me.GetRect();
	nX = ((GetWindowHandle(prevWnd).GetRect().nX + 18) - meRect.nX);
	nY = (((GetWindowHandle(prevWnd).GetRect().nY - 56) - meRect.nY) + 10);
	heroPlayerTexture.MoveC(nX, nY);
	Debug(("순간 이동 :" @ string(fromPlateNum)));  // EN?: TELEPORT
	return;
}

function startMovePlate(int fromPlateNum)
{
	local string prevWnd, currWnd, serverStr;
	local int nX, nY, toNx, toNy, toPlateNum;

	if((toPlayerToMoveNum > 0))
	{
		toPlateNum = (fromPlateNum + 1);
	}
	else
	{
		toPlateNum = (fromPlateNum - 1);
	}
	if(getInstanceUIData().GetIsClassicServer())
	{
		serverStr = "GameBoardStageClassic";
	}
	else
	{
		serverStr = "GameBoardStageLive";
	}
	prevWnd = ((((m_Windowname $ ".") $ serverStr) $ ".BoardPlate") $ getInstanceL2Util().makeZeroString(2, INT64(fromPlateNum)));
	currWnd = ((((m_Windowname $ ".") $ serverStr) $ ".BoardPlate") $ getInstanceL2Util().makeZeroString(2, INT64(toPlateNum)));
	meRect = Me.GetRect();
	nX = ((GetWindowHandle(prevWnd).GetRect().nX + 18) - meRect.nX);
	nY = (((GetWindowHandle(prevWnd).GetRect().nY - 56) - meRect.nY) + 10);
	heroPlayerTexture.MoveC(nX, nY);
	toNx = ((GetWindowHandle(currWnd).GetRect().nX + 18) - (nX + meRect.nX));
	toNy = (((GetWindowHandle(currWnd).GetRect().nY - 56) - (nY + meRect.nY)) + 10);
	TweenLazyStart((m_Windowname $ ".heroPlayerTexture"), m_Windowname, 1, 1, 150.0000000, 255.0000000, float(toNx), float(toNy), 0.0000000, 0.0000000);
	PlaySound("ItemSound2.smelting.Smelting_dragin");
	return;
}

function teleportMovePlate(int fromPlateNum)
{
	local string prevWnd, currWnd, serverStr;
	local int nX, nY, toNx, toNy;

	PlaySound("ItemSound3.minigame_block_change");
	if(getInstanceUIData().GetIsClassicServer())
	{
		serverStr = "GameBoardStageClassic";
	}
	else
	{
		serverStr = "GameBoardStageLive";
	}
	prevWnd = ((((m_Windowname $ ".") $ serverStr) $ ".BoardPlate") $ getInstanceL2Util().makeZeroString(2, INT64(fromPlateNum)));
	currWnd = ((((m_Windowname $ ".") $ serverStr) $ ".BoardPlate") $ getInstanceL2Util().makeZeroString(2, INT64(currentPlayerToMoveNum)));
	meRect = Me.GetRect();
	nX = ((GetWindowHandle(prevWnd).GetRect().nX + 18) - meRect.nX);
	nY = (((GetWindowHandle(prevWnd).GetRect().nY - 56) - meRect.nY) + 10);
	heroPlayerTexture.MoveC(nX, nY);
	toNx = ((GetWindowHandle(currWnd).GetRect().nX + 18) - (nX + meRect.nX));
	toNy = (((GetWindowHandle(currWnd).GetRect().nY - 56) - (nY + meRect.nY)) + 10);
	TweenLazyStart((m_Windowname $ ".heroPlayerTexture"), m_Windowname, 2, 1, 1000.0000000, 255.0000000, float(toNx), float(toNy), 0.0000000, 0.0000000);
	return;
}

function startBossResult()
{
	OpenCard_BossMode(false);
	BossResultWnd.ShowWindow();
	BossSlotitem.Clear();
	BossSlotitem.AddItem(GetItemInfoByClassID(currentEx_BossMiniGame.nRewardItemClassId));
	BossSlotitemNameText.SetText(((GetItemInfoByClassID(currentEx_BossMiniGame.nRewardItemClassId).Name $ " x") $ string(currentEx_BossMiniGame.nRewardItemAmount)));
	Debug(("-- 보스전 결과창 -- nRewardItemClassId : " @ string(currentEx_BossMiniGame.nRewardItemClassId)));  // EN?: -- Boss Battle Results Window -- nRewardItemClassId:
	if((currentEx_BossMiniGame.cMiniGameResult == 1))
	{
		BossResultHeaderBgTexture.SetTexture("L2UI_EPIC.MarbleGameWnd_BossWnd_Win");
		effectViewportBossReward.ShowWindow();
		effectViewportBossReward.SetFocus();
		effectViewportBossReward.SpawnEffect("LineageEffect2.ui_upgrade_succ");
		PlaySound("ItemSound3.mini_game.cardgame_succeed");
	}
	else if((currentEx_BossMiniGame.cMiniGameResult == 0))
	{
		BossResultHeaderBgTexture.SetTexture("L2UI_EPIC.MarbleGameWnd_BossWnd_Lose");
		effectViewportBossReward.ShowWindow();
		effectViewportBossReward.SetFocus();
		effectViewportBossReward.SpawnEffect("LineageEffect2.ui_upgrade_fail");
		PlaySound("ItemSound3.mini_game.cardgame_fail");
	}
	else
	{
		BossResultHeaderBgTexture.SetTexture("L2UI_EPIC.MarbleGameWnd_BossWnd_Draw");
		effectViewportBossReward.ShowWindow();
		effectViewportBossReward.SetFocus();
		effectViewportBossReward.SpawnEffect("LineageEffect2.y_kn_summon_cubic_fire_body");
		PlaySound("SkillSound14.d_firework_a");
	}
	return;
}

function initPlateDialog()
{
	PlateOption_Txt.SetText("");
	PlateDesc_Txt.SetText("");
	return;
}

function showPlateDialog()
{
	local ItemInfo Info;
	local SkillInfo SkillInfo;
	local MableGameEventData tMableGameEventData;

	initPlateDialog();
	if(DesertIslandDialogWnd.IsShowWindow())
	{
		return;
	}
	if((currentCellType != 0))
	{
		SetDisable(true);
		PlateDialogWnd.ShowWindow();
		PlateOption_ItemWindow.HideWindow();
	}
	switch(currentCellType)
	{
		case 1:
			PlaySound("ItemSound3.arena_skill_powerup");
			PlateDialogWnd_ResultBg_Tex.SetTexture("L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_PlateDialogBg_Yellow");
			if((currentEx_Move.nMoveDelta == 0))
			{
				GetMableGameEventData(currentPlayerToMoveNum, MGET_WARP, tMableGameEventData);
			}
			else if((currentEx_Move.nMoveDelta > 0))
			{
				GetMableGameEventData(currentPlayerToMoveNum, MGET_NEXT, tMableGameEventData);
			}
			else
			{
				GetMableGameEventData(currentPlayerToMoveNum, MGET_BACK, tMableGameEventData);
			}
			toPlayerToMoveNum = currentEx_Move.nMoveDelta;
			PlateDialogWnd_Title_Txt.SetText(tMableGameEventData.EventGroupDesc);
			PlateDesc_Txt.SetText(tMableGameEventData.EventDesc);
			Debug(("currentPlayerToMoveNum" @ string(currentPlayerToMoveNum)));
			Debug(("currentEx_Move.nMoveDelta" @ string(currentEx_Move.nMoveDelta)));
			Debug(("tMableGameEventData.EventDesc" @ tMableGameEventData.EventDesc));
			Debug(("tMableGameEventData.EventGroupDesc" @ tMableGameEventData.EventGroupDesc));
			break;
		case 2:
			PlateDialogWnd_ResultBg_Tex.SetTexture("L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_PlateDialogBg_Blue");
			if((MableGameCellDataArray[(currentCellId - 1)].CellColor == 9))
			{
				PlateDialogWnd_Title_Txt.SetText(GetSystemString(13399));
				AddSystemMessage(13273);
				PlaySound("Itemsound2.smelting.smelting_dragout");
			}
			else
			{
				PlaySound("InterfaceSound.Event.AdenDice_Buff");
				PlateDialogWnd_Title_Txt.SetText(GetSystemString(13318));
			}
			Debug(("currentRewardBuffID" @ string(currentRewardBuffID)));
			Debug(("currentRewardBuffLevel" @ string(currentRewardBuffLevel)));
			if(!GetSkillInfo(currentRewardBuffID, currentRewardBuffLevel, 0, SkillInfo))
			{
				Debug("ERROR - no skill info!!");
				return;
			}
			else
			{
				Info.Level = SkillInfo.SkillLevel;
				Info.SubLevel = SkillInfo.SkillSubLevel;
				Info.Name = SkillInfo.SkillName;
				Info.IconName = SkillInfo.TexName;
				Info.IconPanel = SkillInfo.IconPanel;
				Info.Description = SkillInfo.SkillDesc;
				Info.ShortcutType = 2;
			}
			PlateOption_ItemWindow.ShowWindow();
			PlateOption_ItemWindow.Clear();
			PlateOption_ItemWindow.AddItem(Info);
			PlateOption_ItemWindow.SetTooltipType("Skill");
			PlateOption_Txt.SetText(((SkillInfo.SkillName $ " lv") $ string(currentRewardBuffLevel)));
			break;
		case 3:
			PlaySound("ItemSound2.smelting.smelting_finalD");
			if((currentCellId > 39))
			{
				showDialogCompleteReward(currentRewardClassID, currentRewardItemNum);
			}
			else
			{
				PlateDialogWnd_Title_Txt.SetText(GetSystemString(3004));
				PlateDialogWnd_ResultBg_Tex.SetTexture("L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_PlateDialogBg_Blue");
				PlateOption_ItemWindow.ShowWindow();
				Info = GetItemInfoByClassID(currentRewardClassID);
				Info.ItemNum = currentRewardItemNum;
				PlateOption_ItemWindow.Clear();
				PlateOption_ItemWindow.AddItem(Info);
				PlateOption_ItemWindow.SetTooltipType("Inventory");
				PlateOption_Txt.SetText(((Info.Name $ " x") $ string(Info.ItemNum)));
			}
			break;
		case 4:
			PlateDialogWnd_Title_Txt.SetText(GetSystemString(13319));
			PlateDialogWnd_ResultBg_Tex.SetTexture("L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_PlateDialogBg_Red");
			PlaySound("InterfaceSound.Event.AdenDice_BossPopup");
			break;
		case 5:
			PlaySound("InterfaceSound.charstat_open_01");
			PlateDialogWnd_Title_Txt.SetText(GetSystemString(13320));
			PlateDialogWnd_ResultBg_Tex.SetTexture("L2UI_EPIC.MarbleGameWnd.MarbleGameWnd_PlateDialogBg_Green");
			break;
		default:
			enableDiceBtn(true);
			break;
	}
	return;
}

function showDialogCompleteReward(int ItemClassID, INT64 ItemNum)
{
	local ItemInfo Info;

	CompleteWnd = GetWindowHandle((m_Windowname $ ".CompleteWnd"));
	CompleteViewport = GetEffectViewportWndHandle((m_Windowname $ ".CompleteWnd.CompleteViewport"));
	enableDiceBtn(false);
	SetDisable(true);
	CompleteWnd.ShowWindow();
	Info = GetItemInfoByClassID(ItemClassID);
	Info.ItemNum = ItemNum;
	Complete_Itemwindow.Clear();
	Complete_Itemwindow.AddItem(Info);
	CompleteItemName_Txt.SetText(((Info.Name $ " x") $ string(Info.ItemNum)));
	CompleteTitle_Txt.SetText(MakeFullSystemMsg(GetSystemMessage(13197), string(currentMableGamePlayCount)));
	CompleteViewport.ShowWindow();
	CompleteViewport.SpawnEffect("LineageEffect2.ui_upgrade_succ");
	PlaySound("ItemSound3.enchant_success");
	return;
}

function showDialogReset(int ItemClassID, INT64 ItemNum)
{
	local ItemInfo Info;

	enableDiceBtn(false);
	SetDisable(true);
	ResetWnd.ShowWindow();
	Info = GetItemInfoByClassID(ItemClassID);
	Info.ItemNum = ItemNum;
	Reset_Itemwindow.Clear();
	Reset_Itemwindow.AddItem(Info);
	ResetItemName_Txt.SetText(((GetItemNameAll(GetItemInfoByClassID(ItemClassID)) $ " x ") $ string(ItemNum)));
	return;
}

function setStagePlagteCustomTooltip(int plateNum)
{
	local string CellName;

	CellName = MableGameCellDataArray[(plateNum - 1)].CellName;
	GetButtonHandle((getPathPlate(plateNum) $ ".boardBtn")).SetTooltipCustomType(getPlateToolTip(CellName, MableGameCellDataArray[(plateNum - 1)].RewardItems));
	return;
}

function CustomTooltip getPlateToolTip(string Title, array<MableGameCellRewardItem> RewardItems)
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;
	local int i;
	local string TextureName, ItemName;

	drawListArr[drawListArr.Length] = addDrawItemText(Title, getInstanceL2Util().BrightWhite, "", true, true);
	if((RewardItems.Length > 0))
	{
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(2984), getInstanceL2Util().Yellow, "", true, true);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		i = 0;
		while((i < RewardItems.Length))
		{
			TextureName = Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(GetItemID(RewardItems[i].ItemClassID));
			drawListArr[drawListArr.Length] = addDrawItemTextureCustom(TextureName, true, true, 0, 0, 32, 32);
			ItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(RewardItems[i].ItemClassID));
			drawListArr[drawListArr.Length] = addDrawItemText(ItemName, getInstanceL2Util().BWhite, "", false, true, 4, 0);
			if((RewardItems[i].ItemCount <= 0))
			{
				RewardItems[i].ItemCount = 1;
			}
			drawListArr[drawListArr.Length] = addDrawItemText(("x" $ string(RewardItems[i].ItemCount)), getInstanceL2Util().BWhite, "", true, true, 36, -16);
			drawListArr[drawListArr.Length] = addDrawItemBlank(4);
			i++;
		}
	}
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 30;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;
}

function string getPathPlate(int plateNum)
{
	local string Path;

	Path = (m_Windowname $ ".");
	if(getInstanceUIData().GetIsClassicServer())
	{
		Path = (Path $ "GameBoardStageClassic.BoardPlate");
	}
	else
	{
		Path = (Path $ "GameBoardStageLive.BoardPlate");
	}
	Path = (Path $ getInstanceL2Util().makeZeroString(2, INT64(plateNum)));
	return Path;
}

function makeGameStage()
{
	local int i;
	local string btnStr;
	local MableGameCellData tMableGameCellData;

	bFirstRun = true;
	if(getInstanceUIData().GetIsClassicServer())
	{
		GetWindowHandle(((m_Windowname $ ".") $ "GameBoardStageClassic")).ShowWindow();
		GetWindowHandle(((m_Windowname $ ".") $ "GameBoardStageLive")).HideWindow();
	}
	else
	{
		GetWindowHandle(((m_Windowname $ ".") $ "GameBoardStageClassic")).HideWindow();
		GetWindowHandle(((m_Windowname $ ".") $ "GameBoardStageLive")).ShowWindow();
	}
	MableGameCellDataArray.Remove(0, MableGameCellDataArray.Length);
	MableGameCellRewardItemArray.Remove(0, MableGameCellRewardItemArray.Length);
	i = 1;
	while((i < 41))
	{
		GetMableGameCellData(i, tMableGameCellData);
		MableGameCellDataArray.Insert(MableGameCellDataArray.Length, 1);
		MableGameCellDataArray[(MableGameCellDataArray.Length - 1)] = tMableGameCellData;
		Debug((("셀 CellColor    :" @ string(i)) @ string(MableGameCellDataArray[(MableGameCellDataArray.Length - 1)].CellColor)));  // EN?: CellColor:
		i++;
	}
	i = 1;
	while((i <= MableGameCellDataArray.Length))
	{
		btnStr = getPlateIndex(MableGameCellDataArray[(i - 1)].CellColor);
		if((MableGameCellDataArray[(i - 1)].CellColor == 8))
		{
			GetButtonHandle((getPathPlate(i) $ ".boardAnim")).ShowWindow();
		}
		else
		{
			GetButtonHandle((getPathPlate(i) $ ".boardAnim")).HideWindow();
		}
		if((btnStr == "L2UI_CT1.EmptyBtn"))
		{
			GetButtonHandle((getPathPlate(i) $ ".boardBtn")).SetTexture(btnStr, btnStr, btnStr);
		}
		else
		{
			GetButtonHandle((getPathPlate(i) $ ".boardBtn")).SetTexture((btnStr $ "Normal"), (btnStr $ "Over"), (btnStr $ "Over"));
		}
		setStagePlagteCustomTooltip(i);
		i++;
	}
	return;
}

function API_C_EX_MABLE_GAME_OPEN()
{
	local array<byte> stream;

	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(651, stream);
	return;
}

function API_C_EX_MABLE_GAME_ROLL_DICE(int cDiceType)
{
	local array<byte> stream;
	local UIPacket._C_EX_MABLE_GAME_ROLL_DICE packet;

	packet.cDiceType = cDiceType;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_MABLE_GAME_ROLL_DICE(stream, packet))
	{
		return;
	}
	bRecover = false;
	currentDiceType = cDiceType;
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(652, stream);
	PlaySound("InterfaceSound.Event.AdenDice_Throw");
	Debug(("--> API_C_EX_MABLE_GAME_ROLL_DICE:" @ string(cDiceType)));
	return;
}

function API_C_EX_MABLE_GAME_POPUP_OK(int cCellType)
{
	local array<byte> stream;
	local UIPacket._C_EX_MABLE_GAME_POPUP_OK packet;

	packet.cCellType = cCellType;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_MABLE_GAME_POPUP_OK(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(653, stream);
	Debug(("--> API_C_EX_MABLE_GAME_POPUP_OK" @ string(cCellType)));
	return;
}

function API_C_EX_MABLE_GAME_RESET(int nResetItemType)
{
	local array<byte> stream;
	local UIPacket._C_EX_MABLE_GAME_RESET packet;

	packet.nResetItemType = nResetItemType;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_MABLE_GAME_RESET(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(654, stream);
	Debug(("--> API_C_EX_MABLE_GAME_RESET:" @ string(nResetItemType)));
	return;
}

function API_C_EX_MABLE_GAME_CLOSE()
{
	local array<byte> stream;

	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(655, stream);
	Debug("--> API_C_EX_MABLE_GAME_CLOSE");
	return;
}

function OnCallUCFunction(string functionName, string param)
{
	Debug(("OnCallUCFunction CompleteTween" @ param));
	switch(functionName)
	{
		case "tweenEnd":
			if((int(param) == 1))
			{
				if((toPlayerToMoveNum > 0))
				{
					toPlayerToMoveNum--;
					currentPlayerToMoveNum++;
					if((currentPlayerToMoveNum >= 40))
					{
						showDialogCompleteReward(currentRewardClassID, currentRewardItemNum);
						return;
					}
					if((toPlayerToMoveNum > 0))
					{
						startMovePlate(currentPlayerToMoveNum);
					}
					else
					{
						showPlateDialog();
					}
					Debug(("전진" @ string(toPlayerToMoveNum)));  // EN?: Advance
					Debug(("currentPlayerToMoveNum" @ string(currentPlayerToMoveNum)));
				}
				else if((toPlayerToMoveNum < 0))
				{
					Debug(("후진" @ string(toPlayerToMoveNum)));  // EN?: Apse
					toPlayerToMoveNum++;
					currentPlayerToMoveNum--;
					if((currentPlayerToMoveNum <= 1))
					{
						return;
					}
					if((toPlayerToMoveNum < 0))
					{
						startMovePlate(currentPlayerToMoveNum);
					}
					else
					{
						showPlateDialog();
					}
				}
			}
			else if((int(param) == 2))
			{
				showPlateDialog();
			}
			break;
		default:
			break;
	}
	return;
}

function OnTimer(int TimerID)
{
	if((TimerID == 11233))
	{
		Me.KillTimer(11233);
		DiceEffectViewport.SpawnEffect("");
		Debug(("감옥 체크 is currentState" @ string((CurrentState == 5))));  // EN?: Prison Check is currentState
		Debug(("currentState" @ string(CurrentState)));
		Debug(("bPrisonMode" @ string(bPrisonMode)));
		if(bPrisonMode)
		{
			if((currentDiceResult >= currentEx_Prison.nMinDiceForLeavePrison))
			{
				PlaySound("ItemSound3.enchant_success");
				bPrisonMode = false;
				desertIslandRemainTime = 0;
				toPlayerToMoveNum = 1;
				SetDisable(false);
				DesertIslandDialogWnd.HideWindow();
				Me.SetTimer(11240, 1000);
				Debug("- 무인도 탈출 초기화- 높은 주사위로 탈출");  // EN?: - Reset uninhabited island escape- Escape with high dice
			}
			else
			{
				Debug(("bPrisonMode" @ string(bPrisonMode)));
				Debug(("desertIslandRemainTime" @ string(desertIslandRemainTime)));
				Debug(("toPlayerToMoveNum" @ string(toPlayerToMoveNum)));
				if((toPlayerToMoveNum > 0))
				{
					toPlayerToMoveNum = 1;
					bPrisonMode = false;
					desertIslandRemainTime = 0;
					SetDisable(false);
					DesertIslandDialogWnd.HideWindow();
					Me.SetTimer(11240, 1000);
					Debug("- 무인도 탈출 3회 이상 돌려서 그냥 탈출");  // EN?: - Just escape by turning the uninhabited island escape more than 3 times
				}
				else
				{
					enableDiceBtn(true);
				}
			}
		}
		else
		{
			Me.SetTimer(11240, 100);
		}
	}
	else if((TimerID == 11240))
	{
		Debug(("currentPlayerToMoveNum" @ string(currentPlayerToMoveNum)));
		startMovePlate(currentPlayerToMoveNum);
		DiceDialogWnd.HideWindow();
		Me.KillTimer(11240);
	}
	else if((TimerID == 11250))
	{
		Me.KillTimer(11250);
		EffectViewportUserDice.SpawnEffect("");
		EffectViewportBossDice.SpawnEffect("");
		startBossResult();
	}
	else if((TimerID == 11252))
	{
		Me.KillTimer(11252);
		SetDisable(false);
		BossDialogWnd.HideWindow();
	}
	return;
}

function OnTextureAnimEnd(AnimTextureHandle a_WindowHandle)
{
	switch(a_WindowHandle)
	{
		case BossVsAnimTexture:
			BossVsAnimTexture.Stop();
			BossVsAnimTexture.HideWindow();
			BossVsTexture.ShowWindow();
			break;
		default:
			break;
	}
	return;
}

function SetDisable(bool bFlag)
{
	if(bFlag)
	{
		disableWnd.SetFocus();
		disableWnd.ShowWindow();
	}
	else
	{
		disableWnd.HideWindow();
	}
	return;
}

function playNpcViewport(CharacterViewportWindowHandle ObjectViewport, int NpcID, int Distance, optional int Rotation, optional int nX, optional int nY, optional float Duration, optional string SpawnEffect)
{
	ObjectViewport.SetCameraDistance(Distance);
	ObjectViewport.SetCharacterOffsetX(nX);
	ObjectViewport.SetCharacterOffsetY(nY);
	ObjectViewport.SetCurrentRotation(Rotation);
	ObjectViewport.ShowWindow();
	ObjectViewport.SetSpawnDuration(Duration);
	ObjectViewport.SetNPCInfo(NpcID);
	ObjectViewport.SetUISound(true);
	ObjectViewport.SetSpawnDuration(0.1000000);
	ObjectViewport.SpawnNPC();
	ObjectViewport.SpawnEffect(SpawnEffect);
	return;
}

function Rect TweenLazyStart(string TargetName, string Owner, int Id, int ease, float Duration, float Alpha, float MoveX, float MoveY, optional float SizeX, optional float SizeY, optional float Delay)
{
	local L2UITween.TweenObject tweenObj;
	local Rect mRect;

	tweenObj.Position = 0.0000000;
	tweenObj.Delay = Delay;
	GetWindowHandle(TargetName).GetRect();
	tweenObj.Target = GetWindowHandle(TargetName);
	tweenObj.Owner = Owner;
	tweenObj.Id = Id;
	tweenObj.ease = easeType(ease);
	tweenObj.Duration = Duration;
	tweenObj.Alpha = Alpha;
	tweenObj.MoveX = MoveX;
	tweenObj.MoveY = MoveY;
	tweenObj.SizeX = SizeX;
	tweenObj.SizeY = SizeY;
	l2UITweenScript.AddTweenObject(tweenObj);
	return mRect;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="MarbleGameWnd"
}
