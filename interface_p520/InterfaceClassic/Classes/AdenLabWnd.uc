class AdenLabWnd extends UICommonAPI
	dependson(UIPacket);

const TRANSCENDENCE_MAX = 3;
const PROGRESS_TIME = 1000;
const PROGRESS_TIME_AUTO = 700;
const BOSSID_QUEEN = 1;
const CAMERABG_DEFAULT = 580F;
const CAMERABG_LVFORDISTANCE = 140F;

var int bUseLocal;
var array<AdenLabPiece> pieceInfos;
var array<int> spcialPieceIDs;
var L2UITween l2UITweenScript;
var L2UITweenObject twObj;
var AdenLabBossOptionWnd AdenLabBossOptionWNdScr;
var L2UITweenObject MoveClickEncourage;
var int currentViewPieceID;
var int nCurrentSlot;
var CharacterViewportWindowHandle CharacterViewportBG;
var EffectViewportWndHandle EffectViewport01;
var EffectViewportWndHandle EffectViewport03;
var WindowHandle transcendenceWnd;
var WindowHandle transcendenceConfirmPopup;
var WindowHandle TransFrame;
var ButtonHandle transcendenceBtn;
var ButtonHandle transcendenceCancelBtn;
var ButtonHandle transcendenceStartBtn;
var ButtonHandle transcendenceAutoBtn;
var TextBoxHandle StepText;
var TextBoxHandle PercentText;
var TextBoxHandle PercentTextProcess;
var TextBoxHandle EffectStepText;
var TextBoxHandle TransBossTitle_txt;
var ProgressCtrlHandle ProgressBar;
var TextBoxHandle ItemScore_txt;
var WindowHandle ItemScoreWnd;
var bool isInitDataOnStart;
var bool IsAutoMode;
var UIControlNeedItemSelectMultiItems multiNeedItemsScr;
var UIControlNeedItemSelectMultiItems TransNeedItemMultiItemsScr;
var WindowHandle TransNeedItem_wnd;
var HtmlHandle EffectHtml01_txt;
var HtmlHandle EffectHtml02_txt;
var TextBoxHandle EffectHtml01Desc_txt;
var TextBoxHandle EffectHtml02Desc_txt;
var array<int> trancendenceProbs;

static function AdenLabWnd _Inst()
{
	return AdenLabWnd(GetScript("AdenLabWnd"));
}

function int _GetnCurrentSlot()
{
	return nCurrentSlot;
}

function _SetnCurrentSlot(int SlotNum)
{
	nCurrentSlot = SlotNum;
	Class'InterfaceClassic.UIData'.static.Inst()._SetCurrentSlot(SlotNum);
	return;
}

function int _GetCurrentPieceID()
{
	return (nCurrentSlot - 1);
}

function int _CurrentViewPieceID()
{
	return currentViewPieceID;
}

function int _GetCurrentTranscendEnchant()
{
	return Class'InterfaceClassic.UIData'.static.Inst()._GetCurrentTranscendEnchant();
}

function int _GetMaxPieceInfoNum()
{
	return pieceInfos.Length;
}

function int _GetCurrentStageNum()
{
	return (_GetCurrentPieceID() + _GetCurrentTranscendEnchant());
}

function array<string> _GetTrancendenceDescs(int Stage)
{
	local array<string> desces;
	local ExOptionData optionData;
	local CardSelectTranscendStage cardSelectTranscendStageData;

	desces.Length = 2;
	API_GetTranscendStageData(Stage, cardSelectTranscendStageData);
	if((cardSelectTranscendStageData.BasicDescOption.Id != 0))
	{
		API_GetExOptionData(cardSelectTranscendStageData.BasicDescOption.Id, cardSelectTranscendStageData.BasicDescOption.Level, optionData);
		if((IsShowItemScore() && (cardSelectTranscendStageData.ItemScore > 0)))
		{
			desces[0] = htmlSetHtmlStart((((((((ConvertHtmlDesc(optionData.Desc, true) $ "<br1><table width=200 height=19 cellpadding=0 border=0 cellspacing=0><tr><td width=20 align=left valign=top> <img src = \"L2UI_NewTex.DetailStatusWnd.ItemLevelIconSmall\" width = 17 height = 19> </td><td width=180 align=left valign=middle> <font color=") $ getColorHexString(GetColor(221, 221, 221, 255))) $ "\">") $ GetSystemString(14681)) @ "+") $ string(cardSelectTranscendStageData.ItemScore)) $ "</font></td></tr></table>"));
		}
		else
		{
			desces[0] = ConvertHtmlDesc(optionData.Desc);
		}
	}
	if((cardSelectTranscendStageData.EquipDescOption.Id != 0))
	{
		API_GetExOptionData(cardSelectTranscendStageData.EquipDescOption.Id, cardSelectTranscendStageData.EquipDescOption.Level, optionData);
		desces[1] = ConvertHtmlDesc(optionData.Desc);
	}
	return desces;
}

function _SetSuccess()
{
	local int i, currentPieceID;

	currentPieceID = _GetCurrentPieceID();
	i = 0;
	while((i < nCurrentSlot))
	{
		pieceInfos[i]._Show(true);
		i++;
	}
	pieceInfos[currentPieceID]._SetComplete();
	currentPieceID++;
	_SetnCurrentSlot((nCurrentSlot + 1));
	currentViewPieceID = currentPieceID;
	if((currentPieceID == _GetMaxPieceInfoNum()))
	{
		ShowTranscendenceWnd();
		SpawnTransitionBUttonEffect();
	}
	else
	{
		pieceInfos[currentPieceID]._SetNewPiece();
		if((int(pieceInfos[currentPieceID]._GetStageType()) == 2))
		{
			PlaySound("InterfaceSound.AdenLab_SPArtifact_Spawn");
			SetSpcialPieceBtns();
		}
		else
		{
			PlaySound("InterfaceSound.AdenLab_Artifact_Spawn");
		}
	}
	ChkNoticeWnd();
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Next_Btn")).DisableWindow();
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Prev_Btn")).EnableWindow();
	return;
}

function _InsertSpecial(int pieceID)
{
	local ButtonHandle bossBtn;

	bossBtn = GetButtonHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".BossBtn") $ string(spcialPieceIDs.Length)));
	spcialPieceIDs[spcialPieceIDs.Length] = pieceID;
	bossBtn.SetTooltipType("text");
	bossBtn.SetTooltipCustomType(getInstanceL2Util().getCustomToolTip());
	return;
}

function _SetBtnOverByPieceID(int pieceID)
{
	GetSpecialBtnByPieceID(pieceID).SetTexture("L2UI_NewTex.AdenLabWnd.SpecialAbilityBtn_Over", "L2UI_NewTex.AdenLabWnd.SpecialAbilityBtn_Over", "L2UI_NewTex.AdenLabWnd.SpecialAbilityBtn_Over");
	return;
}

function _SetBtnOutByPieceID(int pieceID)
{
	GetSpecialBtnByPieceID(pieceID).SetTexture("L2UI_NewTex.AdenLabWnd.SpecialAbilityBtn_Normal", "L2UI_NewTex.AdenLabWnd.SpecialAbilityBtn_Down", "L2UI_NewTex.AdenLabWnd.SpecialAbilityBtn_Over");
	return;
}

function _SetSpecialOptionStepCurrent(int BossID, int SlotID, array<int> grades)
{
	local int pieceID;

	if((1 != BossID))
	{
		return;
	}
	pieceID = GetPieceIDBySlotID(SlotID);
	pieceInfos[pieceID]._SetLevels(grades);
	SetSpecialBtnTooltipByPieceID(pieceID);
	return;
}

function SetSpecialBtnTooltipByPieceID(int pieceID)
{
	GetSpecialBtnByPieceID(pieceID).SetTooltipCustomType(getInstanceL2Util().getCustomToolTip());
	return;
}

function ButtonHandle GetSpecialBtnByPieceID(int pieceID)
{
	return GetButtonHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".BossBtn") $ string(GetSpecialBtnIndex(pieceID))));
}

function int GetSpecialBtnIndex(int pieceID)
{
	local int i;

	i = 0;
	while((i < spcialPieceIDs.Length))
	{
		if((spcialPieceIDs[i] == pieceID))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function StopProgressBar()
{
	ProgressBar.SetPos(1000);
	ProgressBar.Stop();
	return;
}

function SetProgressBar()
{
	local Vector offset;

	PlaySound("InterfaceSound.AdenLab_Boss_Progress");
	if(IsAutoMode)
	{
		ProgressBar.SetProgressTime(700);
		ProgressBar.SetPos(700);
	}
	else
	{
		ProgressBar.SetProgressTime(1000);
		ProgressBar.SetPos(1000);
	}
	ProgressBar.Start();
	offset.Y = 0.2000000;
	EffectViewport03.SetOffset(offset);
	EffectViewport03.SetCameraDistance(120.0000000);
	EffectViewport03.SpawnEffect((("LineageEffect3.ui_Enchant_0" $ string((_GetCurrentTranscendEnchant() + 1))) $ "_grade"));
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".transcendenceWnd.TransIcon_tex")).ShowWindow();
	return;
}

function InitWindowHandles()
{
	transcendenceWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".transcendenceWnd"));
	transcendenceConfirmPopup = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".transcendenceWnd.transcendenceConfirmPopup"));
	EffectHtml01_txt = GetHtmlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".transcendenceWnd.transcendenceConfirmPopup.EffectHtml01_txt"));
	EffectHtml02_txt = GetHtmlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".transcendenceWnd.transcendenceConfirmPopup.EffectHtml02_txt"));
	EffectHtml01Desc_txt = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".transcendenceWnd.transcendenceConfirmPopup.EffectHtml01Desc_txt"));
	EffectHtml02Desc_txt = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".transcendenceWnd.transcendenceConfirmPopup.EffectHtml02Desc_txt"));
	transcendenceBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".transcendenceWnd.transcendenceBtn"));
	transcendenceCancelBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".transcendenceWnd.transcendenceCancelBtn"));
	transcendenceStartBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".transcendenceWnd.transcendenceConfirmPopup.transcendenceStartBtn"));
	transcendenceAutoBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".transcendenceWnd.transcendenceConfirmPopup.transcendenceAutoBtn"));
	StepText = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".transcendenceWnd.transcendenceConfirmPopup.StepText"));
	PercentText = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".transcendenceWnd.transcendenceConfirmPopup.PercentText"));
	PercentTextProcess = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".transcendenceWnd.TransNeedItem_wnd.TransProb_txt"));
	EffectStepText = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".transcendenceWnd.transcendenceConfirmPopup.EffectStepText"));
	TransBossTitle_txt = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".transcendenceWnd.transcendenceConfirmPopup.TransBossTitle_txt"));
	TransFrame = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".transcendenceWnd.TransFrame"));
	TransFrame.HideWindow();
	EffectViewport01 = GetEffectViewportWndHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".transcendenceWnd.EffectViewport01"));
	EffectViewport03 = GetEffectViewportWndHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".transcendenceWnd.EffectViewport03"));
	CharacterViewportBG = GetCharacterViewportWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".transcendenceWnd.CharacterViewportBG"));
	TransNeedItem_wnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".transcendenceWnd.TransNeedItem_wnd"));
	ProgressBar = GetProgressCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".transcendenceWnd.progressBar"));
	ProgressBar.SetProgressTime(1000);
	ItemScoreWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemScorewnd"));
	ItemScore_txt = GetTextBoxHandle((ItemScoreWnd.m_WindowNameWithFullPath $ ".ItemScore_txt"));
	if((IsShowItemScore() == false))
	{
		ItemScoreWnd.HideWindow();
	}
	return;
}

function InitPapers(CardSelectData infos)
{
	local int i;

	pieceInfos.Length = infos.StageArray.Length;
	i = 0;
	while((i < infos.StageArray.Length))
	{
		pieceInfos[i] = Class'InterfaceClassic.AdenLabPiece'.static._InitScript(GetPiece(i), infos);
		pieceInfos[i]._Hide(true);
		i++;
	}
	return;
}

function WindowHandle GetPiece(int Index)
{
	return GetWindowHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".piece_") $ string(Index)));
}

function AdenLabPiece _GetPieceInfoScript(int pieceID)
{
	return pieceInfos[pieceID];
}

function HidePaper(int Index, optional bool bImmediately)
{
	pieceInfos[Index]._Hide();
	return;
}

function ShowPaper(int Index, optional bool bImmediately)
{
	pieceInfos[Index]._Show();
	return;
}

function PrevPaper()
{
	HidePaper(currentViewPieceID);
	currentViewPieceID--;
	if((currentViewPieceID == -1))
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Prev_Btn")).DisableWindow();
	}
	else
	{
		pieceInfos[currentViewPieceID]._SetEnable();
	}
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Next_Btn")).EnableWindow();
	HideTranscendenceWnd();
	return;
}

function Nextpaper()
{
	local int compareNum;

	if((currentViewPieceID != -1))
	{
		pieceInfos[currentViewPieceID]._SetDisable();
	}
	currentViewPieceID++;
	if(_GetUseLocal())
	{
		compareNum = _GetMaxPieceInfoNum();
	}
	else
	{
		compareNum = _GetCurrentPieceID();
	}
	if((currentViewPieceID == compareNum))
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Next_Btn")).DisableWindow();
	}
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Prev_Btn")).EnableWindow();
	if((currentViewPieceID == _GetMaxPieceInfoNum()))
	{
		ShowTranscendenceWnd();
		SpawnTransitionBUttonEffect();
	}
	else
	{
		ShowPaper(currentViewPieceID);
		HideTranscendenceWnd();
	}
	return;
}

function TestTranscendenceWnd()
{
	pieceInfos.Length = 1;
	return;
}

function SpawnTransitionBUttonEffect()
{
	local Vector offset;

	if((_GetCurrentTranscendEnchant() == 3))
	{
		return;
	}
	offset.Y = 1.0700001;
	EffectViewport03.SetOffset(offset);
	EffectViewport03.SetCameraDistance(450.0000000);
	EffectViewport03.SpawnEffect("LineageEffect3.ui_transition_button");
	return;
}

function SetTranscendenceData()
{
	local int nextLv;
	local CardSelectData Data;
	local array<string> desces;

	nextLv = (_GetCurrentTranscendEnchant() + 1);
	API_GetCardSelectData(Data);
	StepText.SetText(((string(nextLv) $ "/") $ string(3)));
	PercentText.SetText(GetTrancendenceProb(_GetCurrentTranscendEnchant()));
	PercentTextProcess.SetText(((GetSystemString(13938) $ ":") @ PercentText.GetText()));
	desces = _GetTrancendenceDescs(((_GetMaxPieceInfoNum() + _GetCurrentTranscendEnchant()) + 1));
	if((desces[0] == ""))
	{
		EffectHtml01Desc_txt.ShowWindow();
		EffectHtml01_txt.HideWindow();
	}
	else
	{
		EffectHtml01_txt.LoadHtmlFromString(desces[0]);
		EffectHtml01Desc_txt.HideWindow();
		EffectHtml01_txt.ShowWindow();
	}
	if((desces[1] == ""))
	{
		EffectHtml02Desc_txt.ShowWindow();
		EffectHtml02_txt.HideWindow();
	}
	else
	{
		EffectHtml02_txt.LoadHtmlFromString(desces[1]);
		EffectHtml02Desc_txt.HideWindow();
		EffectHtml02_txt.ShowWindow();
	}
	return;
}

function ShowTranscendenceWnd()
{
	EffectViewport03.SpawnEffect("");
	TransNeedItem_wnd.HideWindow();
	transcendenceWnd.ShowWindow();
	PlaySound("InterfaceSound.AdenLab_Boss_Menu");
	transcendenceCancelBtn.HideWindow();
	if((_GetCurrentTranscendEnchant() == 3))
	{
		transcendenceBtn.HideWindow();
	}
	else
	{
		ShowTranscendceceBtn();
	}
	StopProgressBar();
	CharacterViewportBG.ShowWindow();
	CharacterViewportBG.SetNPCInfo(19671);
	CharacterViewportBG.SpawnNPC();
	CharacterViewportBG.SetBackgroundTex("L2UI_NewTex.AdenLabWnd.TransImg_QueenAnt");
	CharacterViewportBG.SpawnEffect("LineageEffect3.ui_aden_lab_bg");
	SpawnEffectDefaultTranscendence();
	return;
}

function SpawnEffectDefaultTranscendence()
{
	switch(_GetCurrentTranscendEnchant())
	{
		case 0:
			EffectViewport01.SpawnEffect("");
			GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".transcendenceWnd.TransIcon_tex")).ShowWindow();
			break;
		case 1:
			EffectViewport01.SetCameraDistance(500.0000000);
			EffectViewport01.SpawnEffect("LineageEffect3.ui_button_deco");
			GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".transcendenceWnd.TransIcon_tex")).ShowWindow();
			break;
		case 2:
			EffectViewport01.SetCameraDistance(400.0000000);
			EffectViewport01.SpawnEffect("LineageEffect3.ui_button_deco_red");
			GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".transcendenceWnd.TransIcon_tex")).ShowWindow();
			break;
		case 3:
			EffectViewport01.SpawnEffect("");
			GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".transcendenceWnd.TransIcon_tex")).HideWindow();
			break;
		default:
			break;
	}
	CharacterViewportBG.SetCameraDistance((580 - (140 * _GetCurrentTranscendEnchant())));
	twObj.Target.SetAlpha(0);
	twObj._Reset();
	return;
}

function SetAutoCheck()
{
	if(!IsAutoMode)
	{
		return;
	}
	if((multiNeedItemsScr._GetMaxNumCanBuy() > INT64(1)))
	{
		m_hOwnerWnd.EnableTick();
	}
	else
	{
		TransNeedItem_wnd.HideWindow();
	}
	return;
}

function HideTranscendenceWnd()
{
	transcendenceWnd.HideWindow();
	CharacterViewportBG.SpawnEffect("");
	EffectViewport01.SpawnEffect("");
	return;
}

function TranscendenceEnd()
{
	transcendenceCancelBtn.HideWindow();
	if((_GetCurrentTranscendEnchant() == 3))
	{
		transcendenceBtn.HideWindow();
	}
	else
	{
		ShowTranscendceceBtn();
	}
	return;
}

function SetSueecssTranscendEnchant()
{
	local Vector offset;

	if(((_GetCurrentTranscendEnchant() + 1) == 3))
	{
		PlaySound("InterfaceSound.AdenLab_Boss_FinSuccess");
	}
	else
	{
		PlaySound("InterfaceSound.AdenLab_Boss_Success");
	}
	EffectViewport03.SetCameraDistance(120.0000000);
	offset.Y = 0.2000000;
	EffectViewport03.SetOffset(offset);
	EffectViewport03.SpawnEffect("LineageEffect2.ui_Enchant_success");
	SetnCurrentTranscendEnchant((_GetCurrentTranscendEnchant() + 1));
	SpawnEffectDefaultTranscendence();
	TransNeedItem_wnd.HideWindow();
	return;
}

function SetFailTranscendEnchant()
{
	local Vector offset;

	PlaySound("InterfaceSound.AdenLab_Boss_Fail");
	EffectViewport03.SetCameraDistance(120.0000000);
	offset.Y = 0.2000000;
	EffectViewport03.SetOffset(offset);
	EffectViewport03.SpawnEffect("LineageEffect2.ui_upgrade_fail");
	return;
}

function SetnCurrentTranscendEnchant(int nCurrentTranscendEnchant)
{
	Class'InterfaceClassic.UIData'.static.Inst()._SetCurrentTranscendEnchant(nCurrentTranscendEnchant);
	if((nCurrentTranscendEnchant == 3))
	{
		TransFrame.ShowWindow();
		ProgressBar.HideWindow();
	}
	else
	{
		TransFrame.HideWindow();
		ShowProgressBar();
	}
	transcendenceBtn.SetNameText((((GetSystemString(14620) @ string(nCurrentTranscendEnchant)) $ "/") $ string(3)));
	if((nCurrentTranscendEnchant == 3))
	{
		transcendenceBtn.HideWindow();
	}
	else
	{
		ShowTranscendceceBtn();
	}
	return;
}

function ShowTranscendceceBtn()
{
	transcendenceBtn.ShowWindow();
	return;
}

function ShowProgressBar()
{
	ProgressBar.ShowWindow();
	return;
}

function HideTranscendEnchantFunctions()
{
	if(_GetUseLocal())
	{
		return;
	}
	ProgressBar.HideWindow();
	transcendenceBtn.HideWindow();
	return;
}

function StartTranscendence()
{
	transcendenceConfirmPopup.HideWindow();
	transcendenceCancelBtn.ShowWindow();
	transcendenceBtn.HideWindow();
	SetProgressBar();
	return;
}

function StartAutoTranscendence()
{
	IsAutoMode = true;
	TransNeedItem_wnd.ShowWindow();
	TransNeedItemMultiItemsScr._StartSelectItems(1);
	TransNeedItemMultiItemsScr._AddSelectItemClassID(multiNeedItemsScr._GetMyClassID(), multiNeedItemsScr._GetMyAmount());
	TransNeedItemMultiItemsScr._EndSelectItems();
	StartTranscendence();
	return;
}

function StopTranscendence()
{
	transcendenceConfirmPopup.HideWindow();
	ShowTranscendenceWnd();
	return;
}

function ShowTranscendenceConfirmPopup()
{
	SetTranscendenceData();
	transcendenceConfirmPopup.ShowWindow();
	StopProgressBar();
	return;
}

function UpdateItemScoreInfo(int ItemScore)
{
	if(IsShowItemScore())
	{
		if((ItemScore > 0))
		{
			ItemScore_txt.SetText(string(ItemScore));
			ItemScoreWnd.SetTooltipCustomType(MakeTooltipSimpleText(((GetSystemString(14860) $ ":") @ string(ItemScore))));
			ItemScoreWnd.ShowWindow();
		}
		else
		{
			ItemScoreWnd.HideWindow();
		}
	}
	return;
}

function CancelTransendence()
{
	transcendenceConfirmPopup.HideWindow();
	StopProgressBar();
	return;
}

function API_GetExOptionData(int Id, int lv, out ExOptionData Data)
{
	Class'NWindow.UIDataManager'.static.GetExOptionData(Id, byte(lv), Data);
	return;
}

function API_GetTranscendStageData(int a_Index, out CardSelectTranscendStage o_TranscendStage)
{
	Class'NWindow.UIDataManager'.static.GetTranscendStageData(a_Index, o_TranscendStage);
	return;
}

function API_GetCardSelectData(out CardSelectData Data)
{
	Class'NWindow.UIDataManager'.static.GetCardSelectData(1, Data);
	return;
}

function API_GetSpecialStageData(int stageIndex, out CardSelectSpecialStage Data)
{
	Class'NWindow.UIDataManager'.static.GetSpecialStageData(stageIndex, Data);
	return;
}

function API_GetEquipAddOptionData(int opitonID, out array<EquipAddOptionData> datas)
{
	Class'NWindow.UIDataManager'.static.GetEquipAddOptionData(opitonID, datas);
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 40:
			HandleRestart();
			break;
		case 9750:
			HandleGameStart();
			SetLocalTest();
			break;
		case 11583:
			Class'InterfaceClassic.Shortcut'.static.Inst()._ExeShowHideWIndow(m_hOwnerWnd.m_WindowNameWithFullPath);
			break;
		case EV_PacketID(1150):
			RT_S_EX_ADENLAB_BOSS_INFO();
			break;
		case EV_PacketID(1157):
			RT_S_EX_ADENLAB_TRANSCEND_ENCHANT();
			break;
		case EV_PacketID(1158):
			RT_S_EX_ADENLAB_TRANSCEND_ANNOUNCE();
			break;
		case EV_PacketID(1160):
			RT_S_EX_ADENLAB_TRANSCEND_PROB();
			break;
		case EV_PacketID(1165):
			NT_S_EX_ITEM_SCORE();
			break;
		default:
			break;
	}
	return;
}

function HandleGameStart()
{
	if((isInitDataOnStart == true))
	{
		return;
	}
	RQ_C_EX_ADENLAB_BOSS_INFO();
	RQ_C_EX_ADENLAB_TRANSCEND_PROB();
	InitFeeItems();
	HideTranscendenceWnd();
	isInitDataOnStart = true;
	RQ_C_EX_ADENLAB_TRANSCEND_PROB();
	return;
}

function HandleRestart()
{
	isInitDataOnStart = false;
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(11583);
	RegisterEvent(9750);
	RegisterEvent(40);
	RegisterEvent(EV_PacketID(1150));
	RegisterEvent(EV_PacketID(1153));
	RegisterEvent(EV_PacketID(1157));
	RegisterEvent(EV_PacketID(1158));
	RegisterEvent(EV_PacketID(1160));
	RegisterEvent(EV_PacketID(1165));
	return;
}

event OnSetFocus(WindowHandle a_WindowHandle, bool bFocused)
{
	if(bFocused)
	{
		GetWindowHandle("AdenLabCardCaptorWnd").SetFocus();
		GetWindowHandle("AdenLabBossOptionWnd").SetFocus();
	}
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	InitWindowHandles();
	InitNeedItemSelectMultiItemsPopup();
	AdenLabBossOptionWNdScr = AdenLabBossOptionWnd(GetScript("AdenLabBossOptionWNd"));
	LoadDatas();
	TransBossTitle_txt.SetText(MakeFullSystemMsg(GetSystemMessage(13980), Class'InterfaceClassic.UIData'.static.Inst()._GetAdenLabBossName(1)));
	InitTweens();
	return;
}

event OnMouseOver(WindowHandle a_WindowHandle)
{
	ChkSpcialPieceBtnOver(a_WindowHandle.GetWindowName());
	return;
}

event OnMouseOut(WindowHandle a_WindowHandle)
{
	ChkSpcialPieceBtnOut(a_WindowHandle.GetWindowName());
	return;
}

function InitTweens()
{
	l2UITweenScript = L2UITween(GetScript("l2UITween"));
	twObj = new Class'InterfaceClassic.L2UITweenObject';
	twObj.Duration = 1200.0000000;
	twObj.Target = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".transcendenceWnd.TransImg_Wnd.TransImg_tex"));
	twObj.Owner = m_hOwnerWnd.m_WindowNameWithFullPath;
	twObj.Id = 1;
	twObj.ease = OUT_STRONG;
	twObj._DelegateOnUpdate = HandleDelegateOnUpdate;
	return;
}

function HandleDelegateOnUpdate(L2UITweenObject tweenObj)
{
	local float distanceFloat;

	distanceFloat = ((140.0000000 * tweenObj.ratioEase) * float((_GetCurrentTranscendEnchant() + 1)));
	CharacterViewportBG.SetCameraDistance(int((580.0000000 - distanceFloat)));
	return;
}

function bool _GetUseLocal()
{
	if((int(GetReleaseMode()) != 0))
	{
		return false;
	}
	return (bUseLocal == 1);
}

function SetLocalTest()
{
	if((GetINIBool(m_hOwnerWnd.m_WindowNameWithFullPath, "UseLocal", bUseLocal, "UIDEV.ini") == false))
	{
		if((int(GetReleaseMode()) == 0))
		{
			SetINIBool(m_hOwnerWnd.m_WindowNameWithFullPath, "UseLocal", false, "UIDEV.ini");
		}
	}
	if(_GetUseLocal())
	{
	}
	else
	{
		GetButtonHandle("AdenLabCardCaptorWnd.Prev_Btn").HideWindow();
		GetButtonHandle("AdenLabCardCaptorWnd.Next_Btn").HideWindow();
		GetButtonHandle("AdenLabBossOptionWnd.Prev_Btn").HideWindow();
		GetButtonHandle("AdenLabBossOptionWnd.Next_Btn").HideWindow();
	}
	return;
}

function InitNeedItemSelectMultiItemsPopup()
{
	local WindowHandle wnd;

	wnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".transcendenceWnd.transcendenceConfirmPopup.NeedItemMultiItems"));
	multiNeedItemsScr = Class'InterfaceClassic.UIControlNeedItemSelectMultiItems'.static._InitScript(wnd);
	multiNeedItemsScr._ConnectPopup(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".transcendenceWnd.transcendenceConfirmPopup.UIControlNeedItemSelectMultiItemPopup")));
	multiNeedItemsScr.DelegateOnUpdateItem = HandleOnNeedItemUpted;
	multiNeedItemsScr.DelegateSelectedItemOnClick = HandleOnSelectItem;
	transcendenceStartBtn.DisableWindow();
	transcendenceAutoBtn.DisableWindow();
	wnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".transcendenceWnd.TransNeedItem_wnd.TransNeedItemMultiItems"));
	TransNeedItemMultiItemsScr = Class'InterfaceClassic.UIControlNeedItemSelectMultiItems'.static._InitScript(wnd);
	return;
}

function HandleOnSelectItem(int selectNeedItemIndex, int selectedClassID, INT64 selectedAmount)
{
	HandleOnNeedItemUpted();
	return;
}

function HandleOnNeedItemUpted()
{
	if(multiNeedItemsScr._GetCanBuy())
	{
		transcendenceStartBtn.EnableWindow();
		transcendenceAutoBtn.EnableWindow();
	}
	else
	{
		transcendenceStartBtn.DisableWindow();
		transcendenceAutoBtn.DisableWindow();
	}
	return;
}

function InitFeeItem(CardSelectData Data)
{
	local int i;
	local array<L2ItemAmount> feeItems;

	transcendenceStartBtn.DisableWindow();
	transcendenceAutoBtn.DisableWindow();
	multiNeedItemsScr._Clear();
	feeItems.Length = 0;
	i = 0;
	while((i < Data.FeeArray.Length))
	{
		if((int(Data.FeeArray[i].FeeType) == 5))
		{
			feeItems.Length = (feeItems.Length + 1);
			feeItems[(feeItems.Length - 1)] = Data.FeeArray[i].FeeItem;
		}
		i++;
	}
	multiNeedItemsScr._StartSelectItems(feeItems.Length);
	i = 0;
	while((i < feeItems.Length))
	{
		multiNeedItemsScr._AddSelectItemClassID(feeItems[i].ItemClassID, INT64(feeItems[i].ItemAmount));
		i++;
	}
	multiNeedItemsScr._EndSelectItems();
	return;
}

function LoadDatas()
{
	local CardSelectData Data;

	API_GetCardSelectData(Data);
	InitPapers(Data);
	Class'InterfaceClassic.AdenLabCardCaptorWnd'.static._Inst()._InitCardSelectData(Data);
	Class'InterfaceClassic.AdenLabBossOptionWnd'.static._Inst()._InitSpcialData(Data);
	return;
}

function InitFeeItems()
{
	local CardSelectData Data;

	API_GetCardSelectData(Data);
	Class'InterfaceClassic.AdenLabCardCaptorWnd'.static._Inst()._InitFeeItems(Data);
	Class'InterfaceClassic.AdenLabBossOptionWnd'.static._Inst()._InitFeeItemsSpcial(Data);
	InitFeeItem(Data);
	return;
}

event OnClickButton(string btnName)
{
	switch(btnName)
	{
		case "transcendenceCancelBtn":
			StopTranscendence();
			break;
		case "transcendenceBtn":
			ShowTranscendenceConfirmPopup();
			break;
		case "transcendenceStartBtn":
			IsAutoMode = false;
			StartTranscendence();
			break;
		case "transcendenceAutoBtn":
			StartAutoTranscendence();
			break;
		case "TransBack_btn":
		case "transcendenceEndBtn":
			transcendenceConfirmPopup.HideWindow();
			break;
		case "WindowClose_Btn":
			m_hOwnerWnd.HideWindow();
			break;
		case "WindowHelp_Btn":
			Class'InterfaceClassic.HelpWnd'.static.ShowHelp(77);
			break;
		case "AbilityList_Btn":
			Class'InterfaceClassic.AdenLabBossOptionProbWnd'.static._Inst()._ToggleAdenOption();
			break;
		case "Prev_Btn":
			PrevPaper();
			break;
		case "Next_Btn":
			Nextpaper();
			break;
		default:
			ChkSpcialPieceBtn(btnName);
			break;
	}
	return;
}

event OnTick()
{
	m_hOwnerWnd.DisableTick();
	StartTranscendence();
	return;
}

event OnShow()
{
	SetStartXY();
	PlayConsoleSound(IFST_WINDOW_OPEN);
	m_hOwnerWnd.SetFocus();
	RQ_C_EX_ADENLAB_BOSS_INFO();
	if(transcendenceWnd.IsShowWindow())
	{
		SpawnEffectDefaultTranscendence();
	}
	SetLocalTest();
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Prev_Btn")).SetFocus();
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Next_Btn")).SetFocus();
	return;
}

event OnHide()
{
	GetWindowHandle("AdenLabCardCaptorWnd").HideWindow();
	GetWindowHandle("AdenLabBossOptionWnd").HideWindow();
	GetWindowHandle("AdenLabBossOptionProbWnd").HideWindow();
	return;
}

event OnReceivedCloseUI()
{
	CloseUI();
	return;
}

event OnProgressTimeUp(string strID)
{
	if(_GetUseLocal())
	{
		RQ_C_EX_ADENLAB_TRANSCEND_ENCHANT_Local();
	}
	else
	{
		RQ_C_EX_ADENLAB_TRANSCEND_ENCHANT();
	}
	TranscendenceEnd();
	return;
}

function string GetTrancendenceProb(int Level)
{
	return Class'InterfaceClassic.L2Util'.static.Inst().MakeDecimalPointString(string(trancendenceProbs[Level]), 2, true, true);
}

function string ConvertHtmlDesc(string SkillDesc, optional bool widthoutHtmlStart)
{
	SkillDesc = Substitute(SkillDesc, "<", "&lt;", false);
	SkillDesc = Substitute(SkillDesc, ">", "&gt;", false);
	SkillDesc = Substitute(SkillDesc, "&lt;font", "<font", false);
	SkillDesc = Substitute(SkillDesc, "\"&gt;", "\">", false);
	SkillDesc = Substitute(SkillDesc, "&lt;/font&gt;", "</font>", false);
	SkillDesc = Substitute(SkillDesc, "%%", "%", false);
	SkillDesc = Substitute(SkillDesc, "\\n\\n", "<br>", false);
	SkillDesc = Substitute(SkillDesc, "\\n", "<br1>", false);
	if(widthoutHtmlStart)
	{
		return SkillDesc;
	}
	else
	{
		return htmlSetHtmlStart(SkillDesc);
	}
}

function int GetPieceIDByBtnName(string btnName)
{
	if((InStr(btnName, "BossBtn") == -1))
	{
		return -1;
	}
	return int(Right(btnName, (Len(btnName) - Len("BossBtn"))));
}

function ChkSpcialPieceBtn(string btnName)
{
	local int spcialIndex, SlotID, pieceID;

	spcialIndex = GetPieceIDByBtnName(btnName);
	if((spcialIndex == -1))
	{
		return;
	}
	pieceID = spcialPieceIDs[spcialIndex];
	SlotID = GetSlotIDByPieceID(pieceID);
	Class'InterfaceClassic.AdenLabBossOptionWnd'.static._Inst()._TryShowSpecialGame(pieceInfos[pieceID]._GetStageIndex(), SlotID, 1);
	return;
}

function ChkSpcialPieceBtnOver(string btnName)
{
	local int spcialIndex, pieceID;

	spcialIndex = GetPieceIDByBtnName(btnName);
	if((spcialIndex == -1))
	{
		return;
	}
	pieceID = spcialPieceIDs[spcialIndex];
	pieceInfos[pieceID]._SetMouseOver();
	return;
}

function ChkSpcialPieceBtnOut(string btnName)
{
	local int spcialIndex, pieceID;

	spcialIndex = GetPieceIDByBtnName(btnName);
	if((spcialIndex == -1))
	{
		return;
	}
	pieceID = spcialPieceIDs[spcialIndex];
	pieceInfos[pieceID]._SetMouseOut();
	return;
}

function int GetSlotIDByPieceID(int pieceID)
{
	return (pieceID + 1);
}

function int GetPieceIDBySlotID(int SlotID)
{
	return (SlotID - 1);
}

function AdenLabPiece GetPaperInfoBySlotID(int SlotID)
{
	return pieceInfos[GetPieceIDBySlotID(SlotID)];
}

function RQ_C_EX_ADENLAB_TRANSCEND_PROB()
{
	local array<byte> stream;
	local UIPacket._C_EX_ADENLAB_TRANSCEND_PROB packet;

	packet.nBossID = 1;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_ADENLAB_TRANSCEND_PROB(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(891, stream);
	return;
}

function RT_S_EX_ADENLAB_TRANSCEND_PROB()
{
	local UIPacket._S_EX_ADENLAB_TRANSCEND_PROB packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_ADENLAB_TRANSCEND_PROB(packet))
	{
		return;
	}
	trancendenceProbs = packet.probs;
	return;
}

function RQ_C_EX_ADENLAB_BOSS_INFO()
{
	local array<byte> stream;
	local UIPacket._C_EX_ADENLAB_BOSS_INFO packet;

	packet.nBossID = 1;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_ADENLAB_BOSS_INFO(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(883, stream);
	return;
}

function RT_S_EX_ADENLAB_BOSS_INFO()
{
	local UIPacket._S_EX_ADENLAB_BOSS_INFO packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_ADENLAB_BOSS_INFO(packet))
	{
		return;
	}
	Class'InterfaceClassic.AdenLabCardCaptorWnd'.static._Inst()._SetRemainTryDailyCount(packet.nNormalGameSaleDailyCount, packet.nNormalGameDailyCount);
	SetCurrentSlot(packet.nCurrentSlot);
	SetnCurrentTranscendEnchant(packet.nTranscendEnchant);
	HandleSpecialSlotInfos(packet.specialSlots);
	return;
}

function NT_S_EX_ITEM_SCORE()
{
	local UIPacket._S_EX_ITEM_SCORE packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_ITEM_SCORE(packet))
	{
		return;
	}
	UpdateItemScoreInfo(packet.nAdenLab);
	return;
}

function HandleSpecialSlotInfos(array<UIPacket._PkAdenLabSpecialSlotInfo> specialSlots)
{
	local int i;

	i = 0;
	while((i < specialSlots.Length))
	{
		_SetSpecialOptionStepCurrent(1, specialSlots[i].nSlotID, specialSlots[i].optionGrades);
		i++;
	}
	return;
}

function RQ_C_EX_ADENLAB_TRANSCEND_ENCHANT_Local()
{
	local CardSelectData Data;

	API_GetCardSelectData(Data);
	if((Rand(100) <= 50))
	{
		SetSueecssTranscendEnchant();
	}
	else
	{
		SetFailTranscendEnchant();
		SetAutoCheck();
	}
	return;
}

function RQ_C_EX_ADENLAB_TRANSCEND_ENCHANT()
{
	local array<byte> stream;
	local UIPacket._C_EX_ADENLAB_TRANSCEND_ENCHANT packet;

	packet.nBossID = 1;
	packet.nFeeIndex = multiNeedItemsScr._GetSelectedIndexPopup();
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_ADENLAB_TRANSCEND_ENCHANT(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(890, stream);
	return;
}

function RT_S_EX_ADENLAB_TRANSCEND_ENCHANT()
{
	local UIPacket._S_EX_ADENLAB_TRANSCEND_ENCHANT packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_ADENLAB_TRANSCEND_ENCHANT(packet))
	{
		return;
	}
	if((packet.cSuccess == 1))
	{
		SetSueecssTranscendEnchant();
	}
	else if((packet.cSuccess == 0))
	{
		SetFailTranscendEnchant();
		SetAutoCheck();
	}
	return;
}

function RT_S_EX_ADENLAB_TRANSCEND_ANNOUNCE()
{
	local UIPacket._S_EX_ADENLAB_TRANSCEND_ANNOUNCE packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_ADENLAB_TRANSCEND_ANNOUNCE(packet))
	{
		return;
	}
	if((packet.nBossID != 1))
	{
		return;
	}
	HandleAnnounceMessage(packet.sUserName, packet.nBossID, packet.cEnchantCount);
	return;
}

function HandleAnnounceMessage(string UserName, int BossID, int enchantCOunt)
{
	local string Msg;

	if((UserName == ""))
	{
		Msg = MakeFullSystemMsg(GetSystemMessage(13998), GetSystemString(13198), Class'InterfaceClassic.UIData'.static.Inst()._GetAdenLabBossName(BossID), string(enchantCOunt));
	}
	else
	{
		Msg = MakeFullSystemMsg(GetSystemMessage(13997), UserName, Class'InterfaceClassic.UIData'.static.Inst()._GetAdenLabBossName(BossID), string(enchantCOunt));
	}
	getInstanceL2Util().showGfxScreenMessage(Msg);
	AddSystemMessageString(Msg);
	return;
}

function ChkNoticeWnd()
{
	if((int(pieceInfos[_GetCurrentPieceID()]._GetStageType()) == 2))
	{
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Notice_wnd")).ShowWindow();
	}
	else
	{
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Notice_wnd")).HideWindow();
	}
	return;
}

function SetCurrentSlot(int currentSlot)
{
	local int i, currentPieceID;

	_SetnCurrentSlot(currentSlot);
	currentPieceID = _GetCurrentPieceID();
	ChkNoticeWnd();
	pieceInfos[currentViewPieceID]._SetDisable();
	i = 0;
	while((i <= currentPieceID))
	{
		pieceInfos[i]._Show(true);
		i++;
	}
	i = i;
	while((i < _GetMaxPieceInfoNum()))
	{
		pieceInfos[i]._Hide(true);
		i++;
	}
	if((nCurrentSlot == (_GetMaxPieceInfoNum() + 1)))
	{
		ShowTranscendenceWnd();
	}
	currentViewPieceID = currentPieceID;
	pieceInfos[currentViewPieceID]._SetEnable();
	if(!_GetUseLocal())
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Next_Btn")).DisableWindow();
	}
	if((currentViewPieceID > -1))
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Prev_Btn")).EnableWindow();
	}
	SetSpcialPieceBtns();
	return;
}

function SetStartXY()
{
	local int i;

	i = 0;
	while((i < _GetMaxPieceInfoNum()))
	{
		pieceInfos[i]._SetStartPosition();
		i++;
	}
	return;
}

function SetSpcialPieceBtns()
{
	local int i, currentPieceID;

	currentPieceID = _GetCurrentPieceID();
	i = 0;
	while((i < spcialPieceIDs.Length))
	{
		if((spcialPieceIDs[i] <= currentPieceID))
		{
			GetButtonHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".BossBtn") $ string(i))).EnableWindow();
			GetButtonHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".BossBtn") $ string(i))).ShowWindow();
			i++;
			continue;
		}
		GetButtonHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".BossBtn") $ string(i))).DisableWindow();
		GetButtonHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".BossBtn") $ string(i))).HideWindow();
		i++;
	}
	return;
}
