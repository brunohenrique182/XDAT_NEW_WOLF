class BalrogWnd extends UICommonAPI
	dependson(UIPacket);

const TIME_REMAIN_SEC_ID = 11010102;

enum BALROGWAR_State
{
	BWS_NONE,                       // 0
	BWS_PREPARE,                    // 1
	BWS_PROGRESS,                   // 2
	BWS_REWARD,                     // 3
	BWS_END                         // 4
};

enum BALROGWAR_ProgressStep
{
	BWPS_NONE,                      // 0
	BWPS_START,                     // 1
	BWPS_MIDBOSS1,                  // 2
	BWPS_MIDBOSS2,                  // 3
	BWPS_FINALBOSS,                 // 4
	BWPS_FINALBOSS_SPECIAL          // 5
};

enum RewardState
{
	RS_NONE,                        // 0
	RS_HAS_REWARD,                  // 1
	RS_REWARD_RECEIVED              // 2
};

enum BossState
{
	BWBS_NONE,                      // 0
	BWBS_SPAWN,                     // 1
	BWBS_SUCCESS,                   // 2
	BWBS_FAIL                       // 3
};

var WindowHandle Me;
var EffectViewportWndHandle Reward_EffectViewport;
var CharacterViewportWindowHandle ObjectViewport;
var WindowHandle StepMonsterInfo_wnd02;
var WindowHandle StepMonsterInfo_wnd01;
var WindowHandle StepMonsterInfo_wnd00;
var ButtonHandle Tel_Btn;
var ButtonHandle ReFresh_btn;
var WindowHandle StepCheck_wnd00;
var WindowHandle StepCheck_wnd01;
var WindowHandle StepCheck_wnd02;
var WindowHandle StepCheck_wnd03;
var TextBoxHandle TimeTilte_txt;
var TextBoxHandle Time_Txt;
var TextBoxHandle BalrogStepTitle_txt;
var TextBoxHandle BalrogStep_txt;
var ButtonHandle BalrogStepHelp_Btn;
var StatusBarHandle StepMonsterGauge_bar;
var WindowHandle MyInfoWnd;
var ButtonHandle HelpTooltip_Btn;
var TextBoxHandle MyRankingTitle_txt;
var TextBoxHandle MyRanking_txt;
var TextBoxHandle MyScoreTitle_txt;
var TextBoxHandle MyScore_txt;
var TextBoxHandle RewardTitle_txt;
var TextureHandle RewardQuestionBG_tex;
var ItemWindowHandle Reward_itemWnd;
var ButtonHandle Reward_Btn;
var ButtonHandle Ranking_Btn;
var TextBoxHandle EventScoreTitle_txt;
var TextBoxHandle EventScore_txt;
var TextureHandle StepScoreGroupBG_Tex;
var string m_Windowname;
var int currentTeleportID;
var int RemainSec;
var bool bFirstSetting;
var BalrogwarUIData balrogwarData;
var bool bSpecialMode;
var UserInfo myInfo;
var int progressBarMax;
var int nHud_State;
var int nHud_nProgressStep;
var int npcIdFinalBoss;
var L2UITimerObject timerObject;

function OnRegisterEvent()
{
	RegisterEvent((100000 + 1013));
	RegisterEvent((100000 + 1015));
	RegisterEvent((100000 + 1016));
	RegisterEvent((100000 + 1017));
	RegisterEvent(40);
	RegisterEvent(9750);
	RegisterEvent(11);
	return;
}

function OnLoad()
{
	Initialize();
	Load();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("BalrogWnd");
	Reward_EffectViewport = GetEffectViewportWndHandle("BalrogWnd.Reward_EffectViewport");
	ObjectViewport = GetCharacterViewportWindowHandle("BalrogWnd.StepMonsterInfo_wnd02.ObjectViewport");
	StepMonsterInfo_wnd00 = GetWindowHandle("BalrogWnd.StepMonsterInfo_wnd00");
	StepMonsterInfo_wnd01 = GetWindowHandle("BalrogWnd.StepMonsterInfo_wnd01");
	StepMonsterInfo_wnd02 = GetWindowHandle("BalrogWnd.StepMonsterInfo_wnd02");
	Tel_Btn = GetButtonHandle("BalrogWnd.Tel_Btn");
	ReFresh_btn = GetButtonHandle("BalrogWnd.ReFresh_Btn");
	StepCheck_wnd00 = GetWindowHandle("BalrogWnd.StepCheck_wnd00");
	StepCheck_wnd01 = GetWindowHandle("BalrogWnd.StepCheck_wnd01");
	StepCheck_wnd02 = GetWindowHandle("BalrogWnd.StepCheck_wnd02");
	StepCheck_wnd03 = GetWindowHandle("BalrogWnd.StepCheck_wnd03");
	TimeTilte_txt = GetTextBoxHandle("BalrogWnd.TimeTilte_txt");
	Time_Txt = GetTextBoxHandle("BalrogWnd.Time_txt");
	BalrogStepTitle_txt = GetTextBoxHandle("BalrogWnd.BalrogStepTitle_txt");
	BalrogStep_txt = GetTextBoxHandle("BalrogWnd.BalrogStep_txt");
	BalrogStepHelp_Btn = GetButtonHandle("BalrogWnd.BalrogStepHelp_Btn");
	StepMonsterGauge_bar = GetStatusBarHandle("BalrogWnd.StepMonsterGauge_bar");
	MyInfoWnd = GetWindowHandle("BalrogWnd.MyInfoWnd");
	HelpTooltip_Btn = GetButtonHandle("BalrogWnd.MyInfoWnd.HelpTooltip_Btn");
	MyRankingTitle_txt = GetTextBoxHandle("BalrogWnd.MyInfoWnd.MyRankingTitle_txt");
	MyRanking_txt = GetTextBoxHandle("BalrogWnd.MyInfoWnd.MyRanking_txt");
	MyScoreTitle_txt = GetTextBoxHandle("BalrogWnd.MyInfoWnd.MyScoreTitle_txt");
	MyScore_txt = GetTextBoxHandle("BalrogWnd.MyInfoWnd.MyScore_txt");
	RewardTitle_txt = GetTextBoxHandle("BalrogWnd.MyInfoWnd.RewardTitle_txt");
	RewardQuestionBG_tex = GetTextureHandle("BalrogWnd.MyInfoWnd.RewardQuestionBG_tex");
	Reward_itemWnd = GetItemWindowHandle("BalrogWnd.MyInfoWnd.Reward_itemWnd");
	Reward_Btn = GetButtonHandle("BalrogWnd.MyInfoWnd.Reward_Btn");
	Ranking_Btn = GetButtonHandle("BalrogWnd.MyInfoWnd.Ranking_Btn");
	EventScoreTitle_txt = GetTextBoxHandle("BalrogWnd.MyInfoWnd.EventScoreTitle_txt");
	EventScore_txt = GetTextBoxHandle("BalrogWnd.MyInfoWnd.EventScore_txt");
	StepScoreGroupBG_Tex = GetTextureHandle("BalrogWnd.StepScoreGroupBG_Tex");
	return;
}

function Load()
{
	SetClosingOnESC();
	GetWindowHandle((m_Windowname $ ".disable_tex")).HideWindow();
	SetPopupScript();
	timerObject = Class'Interface.L2UITimer'.static.Inst()._MakeTimerObject();
	timerObject._time = 2000;
	timerObject._DelegateOnEnd = API_C_EX_BALROGWAR_SHOW_UI;
	return;
}

function loadScript()
{
	if((bFirstSetting == false))
	{
		balrogwarData = GetBalrogwarData();
	}
	bFirstSetting = true;
	HelpTooltip_Btn.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemMessage(13644), string(balrogwarData.Level), string(balrogwarData.MinPlayerPt)), 240));
	return;
}

function OnShow()
{
	API_C_EX_BALROGWAR_SHOW_UI();
	Me.SetFocus();
	ObjectViewport.SetUISound(true);
	return;
}

function setBarOnOff(int i, bool bOn, optional bool bRed)
{
	if(bOn)
	{
		if(bRed)
		{
			GetTextureHandle((("BalrogWnd.StepCheck_wnd0" $ string(i)) $ ".StepON_tex")).SetTexture("L2UI_EPIC.BalrogWnd.BalrogStepOn_Red");
		}
		else
		{
			GetTextureHandle((("BalrogWnd.StepCheck_wnd0" $ string(i)) $ ".StepON_tex")).SetTexture("L2UI_EPIC.BalrogWnd.BalrogStepOn");
		}
		GetTextureHandle((("BalrogWnd.StepCheck_wnd0" $ string(i)) $ ".StepON_tex")).ShowWindow();
	}
	else
	{
		GetTextureHandle((("BalrogWnd.StepCheck_wnd0" $ string(i)) $ ".StepON_tex")).HideWindow();
	}
	return;
}

function setMYInfo(int nRank, int nScore, INT64 nEventScore)
{
	MyScore_txt.SetText(MakeCostString(string(nScore)));
	EventScore_txt.SetText(MakeCostString(string(nEventScore)));
	if((nRank == 0))
	{
		MyRanking_txt.SetText(MakeFullSystemMsg(GetSystemMessage(4553), " - "));
	}
	else
	{
		MyRanking_txt.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(nRank)));
	}
	return;
}

function setMonsterInfoStep(int nStep)
{
	switch(nStep)
	{
		case 0:
			StepMonsterInfo_wnd00.ShowWindow();
			StepMonsterInfo_wnd01.HideWindow();
			StepMonsterInfo_wnd02.HideWindow();
			break;
		case 1:
			StepMonsterInfo_wnd00.HideWindow();
			StepMonsterInfo_wnd01.ShowWindow();
			StepMonsterInfo_wnd02.HideWindow();
			break;
		case 2:
			StepMonsterInfo_wnd00.HideWindow();
			StepMonsterInfo_wnd01.HideWindow();
			StepMonsterInfo_wnd02.ShowWindow();
			Debug(("3d뷰" @ string(npcIdFinalBoss)));  // EN?: 3dview
			playNpcViewport(ObjectViewport, npcIdFinalBoss, getNpcDistance(npcIdFinalBoss), 34112);
			break;
		default:
			break;
	}
	return;
}

function int getNpcDistance(int NpcID)
{
	switch(NpcID)
	{
		case 29256:
			return 800;
		default:
			return 1500;
			return 0;
	}
}

function setProgressStep(int nStep, optional bool bRed)
{
	switch(nStep)
	{
		case 0:
			setBarOnOff(0, false);
			setBarOnOff(1, false);
			setBarOnOff(2, false);
			setBarOnOff(3, false);
			BalrogStepTitle_txt.SetText(GetSystemString(13992));
			BalrogStep_txt.SetText(GetSystemString(13998));
			break;
		case 1:
			setBarOnOff(0, true);
			setBarOnOff(1, false);
			setBarOnOff(2, false);
			setBarOnOff(3, false);
			BalrogStepTitle_txt.SetText(GetSystemString(13993));
			BalrogStep_txt.SetText(GetSystemString(13999));
			break;
		case 2:
			setBarOnOff(0, true);
			setBarOnOff(1, true);
			setBarOnOff(2, false);
			setBarOnOff(3, false);
			BalrogStepTitle_txt.SetText(GetSystemString(13994));
			BalrogStep_txt.SetText(GetSystemString(13999));
			break;
		case 3:
			setBarOnOff(0, true);
			setBarOnOff(1, true);
			setBarOnOff(2, true);
			setBarOnOff(3, false);
			BalrogStepTitle_txt.SetText(GetSystemString(13995));
			BalrogStep_txt.SetText(GetSystemString(13999));
			break;
		case 4:
			setBarOnOff(0, true, bRed);
			setBarOnOff(1, true, bRed);
			setBarOnOff(2, true, bRed);
			setBarOnOff(3, true, bRed);
			if(bRed)
			{
				bSpecialMode = true;
				BalrogStepTitle_txt.SetText(GetSystemString(13997));
				BalrogStep_txt.SetText(GetSystemString(14002));
			}
			else
			{
				bSpecialMode = false;
				BalrogStepTitle_txt.SetText(GetSystemString(13996));
				BalrogStep_txt.SetText(GetSystemString(14001));
			}
			break;
		default:
			break;
	}
	return;
}

function setMonsterKill(int nMonsterIndex, bool bLock, optional bool bKillComplete)
{
	local TextureHandle Monster_tex, Complete_tex, LockBG_tex;

	Complete_tex = GetTextureHandle((("BalrogWnd.StepMonsterInfo_wnd01.Slot_Wnd0" $ string(nMonsterIndex)) $ ".Complete_tex"));
	Monster_tex = GetTextureHandle((("BalrogWnd.StepMonsterInfo_wnd01.Slot_Wnd0" $ string(nMonsterIndex)) $ ".Monster_tex"));
	LockBG_tex = GetTextureHandle((("BalrogWnd.StepMonsterInfo_wnd01.Slot_Wnd0" $ string(nMonsterIndex)) $ ".LockBG_tex"));
	if(bLock)
	{
		Monster_tex.HideWindow();
		LockBG_tex.ShowWindow();
	}
	else
	{
		Monster_tex.ShowWindow();
		LockBG_tex.HideWindow();
	}
	if(bKillComplete)
	{
		Complete_tex.ShowWindow();
	}
	else
	{
		Complete_tex.HideWindow();
	}
	return;
}

function OnHide()
{
	ObjectViewport.SetUISound(false);
	if(GetWindowHandle("BalrogRankingWnd").IsShowWindow())
	{
		GetWindowHandle("BalrogRankingWnd").HideWindow();
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	local int Rotation, Distance, Npc, X, Y;

	switch(Event_ID)
	{
		case EV_PacketID(1013):
			ParsePacket_S_EX_BALROGWAR_SHOW_UI();
			break;
		case EV_PacketID(1015):
			ParsePacket_S_EX_BALROGWAR_GET_REWARD();
			break;
		case EV_PacketID(1016):
			ParsePacket_S_EX_BALROGWAR_HUD();
			if(Me.IsShowWindow())
			{
				API_C_EX_BALROGWAR_SHOW_UI();
			}
			break;
		case EV_PacketID(1017):
			ParsePacket_S_EX_BALROGWAR_BOSSINFO();
			break;
		case 40:
			bFirstSetting = false;
			timerObject._Stop();
			break;
		case 9750:
			loadScript();
			break;
		case 11:
			ParseInt(param, "npc", Npc);
			if((Npc > 0))
			{
				Me.ShowWindow();
				setMonsterInfoStep(2);
				ParseInt(param, "distance", Distance);
				ParseInt(param, "rotation", Rotation);
				ParseInt(param, "x", X);
				ParseInt(param, "y", Y);
				playNpcViewport(ObjectViewport, Npc, Distance, Rotation, X, Y);
			}
			break;
		default:
			break;
	}
	return;
}

function ParsePacket_S_EX_BALROGWAR_SHOW_UI()
{
	local UIPacket._S_EX_BALROGWAR_SHOW_UI packet;
	local ItemInfo rewardInfo;
	local StatusBaseHandle Handle;

	Handle = StepMonsterGauge_bar.GetSelfScript();
	if(!Class'Interface.UIPacket'.static.Decode_S_EX_BALROGWAR_SHOW_UI(packet))
	{
		return;
	}
	Debug(((((((" -->  Decode_S_EX_BALROGWAR_SHOW_UI :  " @ string(packet.nRank)) @ string(packet.nPersonalPoint)) @ string(packet.nTotalPoint)) @ string(packet.nRewardState)) @ string(packet.nRewardItemID)) @ string(packet.nRewardAmount)));
	Debug(("packet.nRank" @ string(packet.nRank)));
	Debug(("packet.nPersonalPoint" @ string(packet.nPersonalPoint)));
	Debug(("packet.nTotalPoint" @ string(packet.nTotalPoint)));
	Debug(("packet.nRewardState" @ string(packet.nRewardState)));
	Debug(("packet.nRewardItemID" @ string(packet.nRewardItemID)));
	Debug(("packet.nRewardAmount" @ string(packet.nRewardAmount)));
	setMYInfo(packet.nRank, packet.nPersonalPoint, packet.nTotalPoint);
	Reward_itemWnd.Clear();
	if((packet.nRewardItemID > 0))
	{
		rewardInfo = GetItemInfoByClassID(packet.nRewardItemID);
		rewardInfo.ItemNum = packet.nRewardAmount;
		Reward_itemWnd.AddItem(rewardInfo);
	}
	if((packet.nRewardState > 0))
	{
		if((packet.nRewardState == 2))
		{
			Reward_itemWnd.DisableWindow();
			Reward_Btn.DisableWindow();
		}
		else
		{
			Reward_itemWnd.EnableWindow();
			Reward_Btn.EnableWindow();
		}
	}
	else
	{
		Reward_Btn.DisableWindow();
	}
	if((packet.nTotalPoint > INT64(progressBarMax)))
	{
		StepMonsterGauge_bar.SetGaugeColor(6, GTColor().Red);
		StepMonsterGauge_bar.SetGaugeColor(7, GTColor().Red);
		StepMonsterGauge_bar.SetGaugeColor(8, GTColor().Red);
	}
	else
	{
		StepMonsterGauge_bar.SetGaugeColor(6, GTColor().Yellow);
		StepMonsterGauge_bar.SetGaugeColor(7, GTColor().Yellow);
		StepMonsterGauge_bar.SetGaugeColor(8, GTColor().Yellow);
	}
	StepMonsterGauge_bar.SetPoint(packet.nTotalPoint, INT64(progressBarMax));
	Debug(("packet.nTotalPoint" @ string(packet.nTotalPoint)));
	Debug(("progressBarMax" @ string(progressBarMax)));
	return;
}

function ParsePacket_S_EX_BALROGWAR_GET_REWARD()
{
	local UIPacket._S_EX_BALROGWAR_GET_REWARD packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_BALROGWAR_GET_REWARD(packet))
	{
		return;
	}
	Debug((" -->  Decode_S_EX_BALROGWAR_GET_REWARD :  " @ string(packet.bSuccess)));
	if((int(packet.bSuccess) > 0))
	{
		playResultEffectViewPort("LineageEffect2.ui_upgrade_succ");
		PlaySound("ItemSound3.enchant_success");
		Reward_Btn.DisableWindow();
		Reward_itemWnd.DisableWindow();
	}
	return;
}

function ParsePacket_S_EX_BALROGWAR_HUD()
{
	local UIPacket._S_EX_BALROGWAR_HUD packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_BALROGWAR_HUD(packet))
	{
		return;
	}
	Debug((((" -->  Decode_S_EX_BALROGWAR_HUD :  " @ string(packet.nState)) @ string(packet.nProgressStep)) @ string(packet.nLeftTime)));
	Debug(("packet.nProgressStep" @ string(packet.nProgressStep)));
	nHud_nProgressStep = packet.nProgressStep;
	nHud_State = packet.nState;
	RemainSec = packet.nLeftTime;
	Me.KillTimer(11010102);
	Me.SetTimer(11010102, 1000);
	switch(packet.nProgressStep)
	{
		case 0:
			progressBarMax = 0;
			setMonsterInfoStep(0);
			GetTextBoxHandle("BalrogWnd.StepMonsterInfo_wnd00.Descrip_txt").SetText(GetSystemString(14008));
			setProgressStep(0);
			BalrogStepHelp_Btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14030), 200));
			break;
		case 1:
			progressBarMax = balrogwarData.EventBeginPt;
			initHideBossInfo();
			setMonsterInfoStep(0);
			setProgressStep(1);
			GetTextBoxHandle("BalrogWnd.StepMonsterInfo_wnd00.Descrip_txt").SetText(GetSystemString(14008));
			BalrogStepHelp_Btn.SetTooltipCustomType(getCustomToolTipBossKill(13999, 14009));
			break;
		case 2:
			progressBarMax = balrogwarData.normal_1st_midboss_pt;
			setMonsterInfoStep(1);
			setProgressStep(2);
			break;
		case 3:
			progressBarMax = balrogwarData.normal_2nd_midboss_pt;
			setMonsterInfoStep(1);
			setProgressStep(3);
			break;
		case 4:
			progressBarMax = balrogwarData.normal_final_boss_pt;
			setMonsterInfoStep(2);
			setProgressStep(4);
			BalrogStepHelp_Btn.SetTooltipCustomType(getCustomToolTipBossKill(14001, 14010));
			break;
		case 5:
			progressBarMax = balrogwarData.specail_final_boss_pt;
			setMonsterInfoStep(2);
			setProgressStep(4, true);
			BalrogStepHelp_Btn.SetTooltipCustomType(getCustomToolTipBossKill(14002, 14034));
			break;
		default:
			break;
	}
	if((packet.nState == 3))
	{
		if(bSpecialMode)
		{
			BalrogStepTitle_txt.SetText(GetSystemString(14032));
			BalrogStep_txt.SetText(GetSystemString(14003));
		}
		else
		{
			BalrogStepTitle_txt.SetText(GetSystemString(14032));
			BalrogStep_txt.SetText(GetSystemString(14003));
		}
		BalrogStepHelp_Btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14003), 120));
		if(Me.IsShowWindow())
		{
			timerObject._Reset();
		}
	}
	if((packet.nState == 4))
	{
		Me.HideWindow();
		Me.KillTimer(11010102);
	}
	return;
}

function initHideBossInfo()
{
	local int i;

	i = 0;
	while((i < 5))
	{
		GetTextureHandle((("BalrogWnd.StepMonsterInfo_wnd01.Slot_Wnd0" $ string(i)) $ ".Monster_tex")).HideWindow();
		GetTextureHandle((("BalrogWnd.StepMonsterInfo_wnd01.Slot_Wnd0" $ string(i)) $ ".Complete_tex")).HideWindow();
		i++;
	}
	return;
}

function ParsePacket_S_EX_BALROGWAR_BOSSINFO()
{
	local int i;
	local UIPacket._S_EX_BALROGWAR_BOSSINFO packet;
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;
	local bool bUseTooltip;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_BALROGWAR_BOSSINFO(packet))
	{
		return;
	}
	npcIdFinalBoss = (packet.nFinalBossClassID - 1000000);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14000), getInstanceL2Util().BrightWhite, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	i = 0;
	while((i < 5))
	{
		if((packet.nMidBossClassID[i] > 0))
		{
			GetTextureHandle((("BalrogWnd.StepMonsterInfo_wnd01.Slot_Wnd0" $ string(i)) $ ".Monster_tex")).SetTexture(getMonsterTexture(packet.nMidBossClassID[i]));
			i++;
			continue;
		}
		GetTextureHandle((("BalrogWnd.StepMonsterInfo_wnd01.Slot_Wnd0" $ string(i)) $ ".Monster_tex")).SetTexture("L2UI_EPIC.BalrogWnd.BalrogMonsterSlot");
		i++;
	}
	i = 0;
	while((i < 5))
	{
		if((packet.nMidBossState[i] == 0))
		{
			GetTextureHandle((("BalrogWnd.StepMonsterInfo_wnd01.Slot_Wnd0" $ string(i)) $ ".Monster_tex")).HideWindow();
		}
		else if((packet.nMidBossState[i] == 1))
		{
			GetTextureHandle((("BalrogWnd.StepMonsterInfo_wnd01.Slot_Wnd0" $ string(i)) $ ".Monster_tex")).ShowWindow();
			drawListArr[drawListArr.Length] = addDrawItemText(("- " $ Class'NWindow.UIDATA_NPC'.static.GetNPCName((packet.nMidBossClassID[i] - 1000000))), getInstanceL2Util().ColorDesc, "", true, true);
			bUseTooltip = true;
			BalrogStep_txt.SetText(GetSystemString(14000));
		}
		if((packet.nMidBossState[i] == 2))
		{
			GetTextureHandle((("BalrogWnd.StepMonsterInfo_wnd01.Slot_Wnd0" $ string(i)) $ ".Complete_tex")).SetTexture("L2UI_EPIC.BalrogWnd.BalrogComplete");
			GetTextureHandle((("BalrogWnd.StepMonsterInfo_wnd01.Slot_Wnd0" $ string(i)) $ ".Complete_tex")).ShowWindow();
			i++;
			continue;
		}
		if((packet.nMidBossState[i] == 3))
		{
			if(GetTextureHandle((("BalrogWnd.StepMonsterInfo_wnd01.Slot_Wnd0" $ string(i)) $ ".Monster_tex")).IsShowWindow())
			{
				GetTextureHandle((("BalrogWnd.StepMonsterInfo_wnd01.Slot_Wnd0" $ string(i)) $ ".Complete_tex")).SetTexture("L2UI_EPIC.BalrogWnd.BalrogFail");
				GetTextureHandle((("BalrogWnd.StepMonsterInfo_wnd01.Slot_Wnd0" $ string(i)) $ ".Complete_tex")).ShowWindow();
			}
			else
			{
				GetTextureHandle((("BalrogWnd.StepMonsterInfo_wnd01.Slot_Wnd0" $ string(i)) $ ".Complete_tex")).HideWindow();
			}
			i++;
			continue;
		}
		GetTextureHandle((("BalrogWnd.StepMonsterInfo_wnd01.Slot_Wnd0" $ string(i)) $ ".Complete_tex")).HideWindow();
		i++;
	}
	if(bUseTooltip)
	{
		mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
		mCustomTooltip.MinimumWidth = 130;
		setCustomToolTipMinimumWidth(mCustomTooltip);
		BalrogStepHelp_Btn.SetTooltipCustomType(mCustomTooltip);
	}
	else if((packet.nFinalBossClassID == 0))
	{
		if(((nHud_State == 3) || (nHud_State == 4)))
		{
		}
		else if((nHud_State == 1))
		{
			BalrogStepHelp_Btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14836), 200));
			BalrogStep_txt.SetText(GetSystemString(13998));
		}
		else
		{
			BalrogStepHelp_Btn.SetTooltipCustomType(getCustomToolTipBossKill(13999, 14009));
			BalrogStep_txt.SetText(GetSystemString(13999));
		}
	}
	if(((nHud_nProgressStep == 4) || (nHud_nProgressStep == 5)))
	{
		Debug(("3d뷰 갱신 " @ string(npcIdFinalBoss)));  // EN?: Renew 3d view
		playNpcViewport(ObjectViewport, npcIdFinalBoss, getNpcDistance(npcIdFinalBoss), 34112);
	}
	if(((packet.nFinalBossState == 1) || (packet.nFinalBossState == 0)))
	{
		GetTextureHandle("BalrogWnd.StepMonsterInfo_wnd02.BossComplete_tex").HideWindow();
	}
	else if((packet.nFinalBossState == 2))
	{
		GetTextureHandle("BalrogWnd.StepMonsterInfo_wnd02.BossComplete_tex").SetTexture("L2UI_EPIC.BalrogWnd.BalrogCompleteLarge");
		GetTextureHandle("BalrogWnd.StepMonsterInfo_wnd02.BossComplete_tex").ShowWindow();
		if(Me.IsShowWindow())
		{
			API_C_EX_BALROGWAR_SHOW_UI();
		}
	}
	else if((packet.nFinalBossState == 3))
	{
		GetTextureHandle("BalrogWnd.StepMonsterInfo_wnd02.BossComplete_tex").SetTexture("L2UI_EPIC.BalrogWnd.BalrogFailLarge");
		GetTextureHandle("BalrogWnd.StepMonsterInfo_wnd02.BossComplete_tex").ShowWindow();
		if(Me.IsShowWindow())
		{
			API_C_EX_BALROGWAR_SHOW_UI();
		}
	}
	return;
}

function string getMonsterTexture(int NpcID)
{
	return ("L2UI_EPIC.BalrogWnd.BalrogMonsterID_" $ string((NpcID - 1000000)));
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "Tel_Btn":
			OnTel_BtnClick();
			break;
		case "ReFresh_Btn":
			OnReFresh_btnClick();
			break;
		case "BalrogStepHelp_Btn":
			OnBalrogStepHelp_BtnClick();
			break;
		case "HelpTooltip_Btn":
			OnHelpTooltip_BtnClick();
			break;
		case "Reward_Btn":
			OnReward_BtnClick();
			break;
		case "Ranking_Btn":
			OnRanking_BtnClick();
			break;
		case "FrameHelp_BTN":
			ExecuteEvent(1210, "54");
			break;
		default:
			break;
	}
	return;
}

function OnTel_BtnClick()
{
	GetPlayerInfo(myInfo);
	if((balrogwarData.Level <= myInfo.nLevel))
	{
		ShowPopup();
	}
	else
	{
		AddSystemMessageString(MakeFullSystemMsg(GetSystemMessage(13643), string(balrogwarData.Level)));
	}
	return;
}

function OnReFresh_btnClick()
{
	API_C_EX_BALROGWAR_SHOW_UI();
	return;
}

function OnBalrogStepHelp_BtnClick()
{
	return;
}

function OnHelpTooltip_BtnClick()
{
	return;
}

function OnReward_BtnClick()
{
	API_C_EX_BALROGWAR_GET_REWARD();
	return;
}

function OnRanking_BtnClick()
{
	toggleWindow("BalrogRankingWnd", true);
	getInstanceL2Util().windowMoveToSide(Me, GetWindowHandle("BalrogRankingWnd"));
	return;
}

function CustomTooltip getCustomToolTipBossKill(int nTitleStringNum, int nContextStringNum)
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(nTitleStringNum), getInstanceL2Util().BrightWhite, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(nContextStringNum), getInstanceL2Util().ColorDesc, "", true, false);
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 250;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;
}

function OnTimer(int TimerID)
{
	if((TimerID == 11010102))
	{
		RemainSec--;
		if((RemainSec < 0))
		{
			Me.KillTimer(11010102);
		}
		else
		{
			Time_Txt.SetText(GetTimeStringMS(RemainSec));
		}
	}
	return;
}

function playResultEffectViewPort(string effectPath)
{
	local Vector offset;

	if((effectPath == "LineageEffect2.ui_upgrade_succ"))
	{
		offset.X = 10.0000000;
		offset.Y = -5.0000000;
		Reward_EffectViewport.SetScale(6.0000000);
		Reward_EffectViewport.SetCameraDistance(1300.0000000);
		Reward_EffectViewport.SetOffset(offset);
	}
	else if((effectPath == "LineageEffect.d_firework_a"))
	{
		offset.X = 10.0000000;
		offset.Y = -5.0000000;
		Reward_EffectViewport.SetScale(6.0000000);
		Reward_EffectViewport.SetCameraDistance(1300.0000000);
		Reward_EffectViewport.SetOffset(offset);
	}
	Reward_EffectViewport.SetFocus();
	Reward_EffectViewport.SpawnEffect(effectPath);
	return;
}

function UIControlDialogAssets GetPopupExpandScript()
{
	local WindowHandle poopExpandWnd;

	poopExpandWnd = GetWindowHandle((m_Windowname $ ".UIControlDialogAsset"));
	return UIControlDialogAssets(poopExpandWnd.GetScript());
}

function SetPopupScript()
{
	local WindowHandle poopExpandWnd;
	local UIControlDialogAssets popupExpandScript;
	local WindowHandle disableWnd;

	poopExpandWnd = GetWindowHandle((m_Windowname $ ".UIControlDialogAsset"));
	popupExpandScript = Class'Interface.UIControlDialogAssets'.static.InitScript(poopExpandWnd);
	disableWnd = GetWindowHandle((m_Windowname $ ".disable_tex"));
	popupExpandScript.SetDisableWindow(disableWnd);
	Class'NWindow.UIAPI_WINDOW'.static.SetAlwaysOnTop((m_Windowname $ ".disable_tex"), false);
	return;
}

function ShowPopup()
{
	local UIControlDialogAssets popupExpandScript;
	local TeleportListAPI.TeleportListData listData;

	popupExpandScript = GetPopupExpandScript();
	currentTeleportID = 472;
	listData = getInstanceUIData().GetTeleportListDataByID(currentTeleportID);
	popupExpandScript.SetDialogDesc(((((GetSystemMessage(5239) $ "\\n") $ "(") $ listData.Name) $ ")"));
	popupExpandScript.SetUseNeedItem(true);
	popupExpandScript.StartNeedItemList(1);
	popupExpandScript.AddNeedItemClassID(57, getInstanceUIData().GetTeleportPriceByID(currentTeleportID));
	popupExpandScript.SetItemNum(1);
	popupExpandScript.Show();
	popupExpandScript.DelegateOnClickBuy = onClickTeleport;
	popupExpandScript.DelegateOnCancel = OnClickCancelDialog;
	return;
}

function OnClickCancelDialog()
{
	GetPopupExpandScript().Hide();
	return;
}

function onClickTeleport()
{
	API_C_EX_BALROGWAR_TELEPORT();
	GetPopupExpandScript().Hide();
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

function playNpcViewport(CharacterViewportWindowHandle ObjectViewport, int NpcID, int Distance, optional int Rotation, optional int nX, optional int nY, optional string SpawnEffect)
{
	ObjectViewport.SetCameraDistance(Distance);
	ObjectViewport.SetCharacterOffsetX(nX);
	ObjectViewport.SetCharacterOffsetY(nY);
	ObjectViewport.SetCurrentRotation(Rotation);
	ObjectViewport.ShowWindow();
	ObjectViewport.SetNPCInfo(NpcID);
	if(Me.IsShowWindow())
	{
		ObjectViewport.SetUISound(true);
	}
	else
	{
		ObjectViewport.SetUISound(false);
	}
	ObjectViewport.SetSpawnDuration(0.1000000);
	ObjectViewport.SpawnNPC();
	ObjectViewport.AutoAdjustCharOffsetY();
	ObjectViewport.SpawnEffect(SpawnEffect);
	return;
}

function API_C_EX_BALROGWAR_TELEPORT()
{
	local array<byte> stream;
	local UIPacket._C_EX_BALROGWAR_TELEPORT packet;

	if(!Class'Interface.UIPacket'.static.Encode_C_EX_BALROGWAR_TELEPORT(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(779, stream);
	Debug("--> C_EX_BALROGWAR_TELEPORT ");
	return;
}

function API_C_EX_BALROGWAR_GET_REWARD()
{
	local array<byte> stream;
	local UIPacket._C_EX_BALROGWAR_GET_REWARD packet;

	if(!Class'Interface.UIPacket'.static.Encode_C_EX_BALROGWAR_GET_REWARD(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(782, stream);
	Debug("--> C_EX_BALROGWAR_GET_REWARD  ");
	return;
}

function API_C_EX_BALROGWAR_SHOW_UI()
{
	local array<byte> stream;
	local UIPacket._C_EX_BALROGWAR_SHOW_UI packet;

	if(!Class'Interface.UIPacket'.static.Encode_C_EX_BALROGWAR_SHOW_UI(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(780, stream);
	Debug("--> C_EX_BALROGWAR_SHOW_UI  ");
	return;
}

function string GetTimeStringMS(int Second)
{
	local int Min, Sec;

	Min = (Second / 60);
	Sec = int((float(Second) % 60.0000000));
	return MakeFullSystemMsg(GetSystemMessage(13418), Int2Str(Min), Int2Str(Sec));
}

function string Int2Str(int Num)
{
	if((Num < 10))
	{
		return ("0" $ string(Num));
	}
	return string(Num);
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="BalrogWnd"
}
