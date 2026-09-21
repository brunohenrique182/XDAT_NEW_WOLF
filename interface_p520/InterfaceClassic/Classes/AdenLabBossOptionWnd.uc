class AdenLabBossOptionWnd extends UICommonAPI
	dependson(UIPacket);

const MAX_NUM = 3;
const PROGRESS_TIME = 800;
const GAB_ON_GAMING = -77;
const ROTATE_ANGLE = 1440;

var int BossID;
var int SlotID;
var int stageIndex;
var int optionNum;
var int MaxLevel;
var array<int> optionIds;
var array<int> optionStepsCurrent;
var array<int> optionStepsSaved;
var array<int> optionStepsCurrentTest;
var L2UITweenObject tObject;
var L2UITweenTwinkleObject twinkleObject;
var L2UITween l2UITweenScript;
var array<L2UITweenRotateObject> rotateTweeObjects;
var ProgressCtrlHandle ProgressBar;
var int startLocX;
var int startLocY;
var int StartAlpha;
var WindowHandle adenLabBossTitleNBg;
var WindowHandle adenLabBossOption;
var WindowHandle adenLabBossOptionChange;
var WindowHandle adenLabBossOptionPopup;
var UIControlNumberInputSteper numberInputStepper;
var RichListCtrlHandle EnchantValues;
var RichListCtrlHandle EnchantPayment;
var TextBoxHandle MainInfomation_txt;
var WindowHandle AdenBossOptionInfoWnd;
var UIControlNeedItemSelectMultiItems multiNeedItemsScr;
var UIControlDialogAssets uicontrolDialogAssetScr;
var TextBoxHandle ItemScore_txt;
var WindowHandle ItemScoreWnd;
var array<L2ItemAmount> playFeeDailyFees;
var array<L2ItemAmount> fixFeeDailyFees;
var int selectedPlayFeeClassID;
var int selectedFixFeeClassID;
var bool isFixMode;
var int targetStep;
var bool IsAutoMode;
var bool isCancelRequested;
var bool depthSort;
var bool bGetAniPlayed;
var bool bProgressBar;
var bool bRequested;
var L2UITimerObject _RequestedRefreshTObject;
var bool bSuccess;
var EffectViewportWndHandle effectViewport;
var TextureHandle MainBgChange_tex;
var TextBoxHandle ApplyInfo_txt;
var TextureHandle ShortcutIcon_Enter;
var TextureHandle ShortcutIcon_ESC;
var WindowHandle OptionGoalWnd;
var L2UIShortcutIconManagerObject shortcutIconManagerObj;
var WindowHandle AssetPopupWnd;

static function AdenLabBossOptionWnd _Inst()
{
	return AdenLabBossOptionWnd(GetScript("AdenLabBossOptionWnd"));
}

function InitWindowHandles()
{
	ProgressBar = GetProgressCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".progressBar"));
	ProgressBar.SetProgressTime(800);
	adenLabBossOption = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AdenLabBossOption"));
	adenLabBossOptionChange = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AdenLabBossOptionChange"));
	adenLabBossOptionChange.SetAlpha(0);
	MainInfomation_txt = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AdenBossOptionInfoWnd.MainInfomation_txt"));
	AdenBossOptionInfoWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AdenBossOptionInfoWnd"));
	adenLabBossOptionPopup = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".adenLabBossOptionPopup"));
	adenLabBossOptionPopup.HideWindow();
	adenLabBossTitleNBg = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".adenLabBossTitleNBg"));
	EnchantValues = GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AdenLabBossOptionPopup.EnchantValues"));
	EnchantPayment = GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AdenLabBossOptionPopup.EnchantPayment"));
	SetBossOptionChangeValueInit();
	effectViewport = GetEffectViewportWndHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".MainBgEffectViewport00"));
	MainBgChange_tex = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".MainBgChange_tex"));
	MainBgChange_tex.SetAlpha(0);
	ApplyInfo_txt = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ApplyInfo_txt"));
	OptionGoalWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".OptionGoalWnd"));
	AssetPopupWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AssetPopupWnd"));
	ItemScoreWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemScorewnd"));
	ItemScore_txt = GetTextBoxHandle((ItemScoreWnd.m_WindowNameWithFullPath $ ".ItemScore_txt"));
	if((IsShowItemScore() == false))
	{
		ItemScoreWnd.HideWindow();
	}
	return;
}

function SetTargetValues()
{
	GetTextBoxHandle((OptionGoalWnd.m_WindowNameWithFullPath $ ".TargetValue")).SetText(((((GetSystemString(7259) $ ": ") $ GetSystemString(88)) $ ".") $ string(targetStep)));
	return;
}

function InitTween()
{
	l2UITweenScript = Class'InterfaceClassic.L2UITween'.static.Inst();
	twinkleObject = l2UITweenScript._AddTweenTwinlkle(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ApplyModeBtn")), -1.0000000, 0.0000000, 500.0000000, 100, 255, 1.0000000);
	twinkleObject._Stop();
	tObject = new Class'InterfaceClassic.L2UITweenObject';
	tObject.Owner = m_hOwnerWnd.m_WindowNameWithFullPath;
	tObject.Target = adenLabBossOption;
	tObject.Id = 99;
	tObject.Duration = 500.0000000;
	tObject.ease = OUT_STRONG;
	tObject.MoveY = -77.0000000;
	tObject._Stop();
	tObject._DelegateOnStart = HandleDelegateOnStart;
	tObject._DelegateOnUpdate = HandleDelegateOnUpdateShow;
	GetLocalPosition(tObject.Target, startLocX, startLocY);
	return;
}

function HandleDelegateOnStart(L2UITweenObject tweenObj)
{
	StartAlpha = adenLabBossOptionChange.GetAlpha();
	return;
}

function HandleDelegateOnUpdateShow(L2UITweenObject tweenObj)
{
	adenLabBossOptionChange.SetAlpha(int((float(StartAlpha) + (tweenObj.ratioEase * float((255 - StartAlpha))))));
	return;
}

function HandleDelegateOnUPdateHide(L2UITweenObject tweenObj)
{
	adenLabBossOptionChange.SetAlpha(int((float(StartAlpha) - (tweenObj.ratioEase * float(StartAlpha)))));
	return;
}

function InitNeedItemSelectMultiItemsPopup()
{
	local WindowHandle wnd;

	wnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".NeedItem_wnd.NeedItemMultiItems"));
	multiNeedItemsScr = Class'InterfaceClassic.UIControlNeedItemSelectMultiItems'.static._InitScript(wnd);
	multiNeedItemsScr._ConnectPopup(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".NeedItem_wnd.UIControlNeedItemSelectMultiItemPopup")));
	multiNeedItemsScr.DelegateSelectedItemOnClick = MultiItemSelected;
	return;
}

function InitFeeDailyFees(array<L2ItemAmount> feeItems)
{
	local int i;

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

function InitUIControlDialogAsset()
{
	local WindowHandle poopExpandWnd;

	poopExpandWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AssetPopupWnd.UIControlDialogAsset"));
	uicontrolDialogAssetScr = Class'InterfaceClassic.UIControlDialogAssets'.static.InitScript(poopExpandWnd);
	uicontrolDialogAssetScr.DelegateOnCancel = OnClickPopupCancel;
	uicontrolDialogAssetScr.DelegateOnClickBuy = OnClickPopupBuy;
	uicontrolDialogAssetScr.SetUseNeedItem(true);
	return;
}

function InitUIControlNumberInputSteper()
{
	numberInputStepper = Class'InterfaceClassic.UIControlNumberInputSteper'.static.InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AdenLabBossOptionPopup.EnchantGoalSet_wndAsset")));
	numberInputStepper.DelegateESCKey = OnReceivedCloseUI;
	numberInputStepper.DelegateOnChangeEditBox = HandleOnChangeEditBox;
	numberInputStepper.m_hOwnerWnd.ShowWindow();
	numberInputStepper._SetDisable(true);
	numberInputStepper._setMaxLength(2);
	numberInputStepper._setAddButtons(-5, 5, MaxLevel);
	numberInputStepper.plus10Button.SetNameText(GetSystemString(3451));
	numberInputStepper._setRangeMinMaxNum(1, MaxLevel);
	return;
}

function DelegateNumberStepperOnSetFocus(bool IsFocused)
{
	if((IsFocused == true))
	{
		m_hOwnerWnd.SetFocus();
	}
	return;
}

function OnClickPopupCancel()
{
	uicontrolDialogAssetScr.Hide();
	AssetPopupWnd.HideWindow();
	return;
}

function OnClickPopupBuy()
{
	if((isFixMode == false))
	{
		SetModeBossOptionChange();
	}
	else if(Class'InterfaceClassic.AdenLabWnd'.static._Inst()._GetUseLocal())
	{
		RQ_C_EX_ADENLAB_SPECIAL_FIX_Local();
	}
	else
	{
		RQ_C_EX_ADENLAB_SPECIAL_FIX();
	}
	uicontrolDialogAssetScr.Hide();
	AssetPopupWnd.HideWindow();
	return;
}

function string MakeFixDialogHtml()
{
	local int i;
	local string HTML;

	i = 0;
	while((i < optionNum))
	{
		HTML = ((((HTML @ "<br><font color=\"EEEEEE\">") $ " ") $ _GetOptionNameString(optionIds[i], 1)) $ ":");
		if((optionStepsCurrent[i] == 0))
		{
			HTML = ((((((HTML @ "-") $ " (") $ GetSystemString(88)) $ ".") $ string(optionStepsCurrent[i])) $ ")</font>");
		}
		else
		{
			HTML = ((((((HTML @ _GetOptionValueString(optionIds[i], optionStepsCurrent[i])) $ " (") $ GetSystemString(88)) $ ".") $ string(optionStepsCurrent[i])) $ ")</font>");
		}
		if((optionStepsCurrent[i] == optionStepsSaved[i]))
		{
			HTML = (((((((HTML @ "<font color=\"EEEEEE\"> >>") $ _GetOptionValueString(optionIds[i], optionStepsSaved[i])) $ " (") $ GetSystemString(88)) $ ".") $ string(optionStepsSaved[i])) $ ")</font>");
			i++;
			continue;
		}
		if((optionStepsCurrent[i] < optionStepsSaved[i]))
		{
			HTML = (((((((HTML @ "<font color=\"EE0000\"> >>") $ _GetOptionValueString(optionIds[i], optionStepsSaved[i])) $ " (") $ GetSystemString(88)) $ ".") $ string(optionStepsSaved[i])) $ ")</font>");
			i++;
			continue;
		}
		HTML = (((((((HTML @ "<font color=\"00B0FF\"> >>") $ _GetOptionValueString(optionIds[i], optionStepsSaved[i])) $ " (") $ GetSystemString(88)) $ ".") $ string(optionStepsSaved[i])) $ ")</font>");
		i++;
	}
	return HTML;
}

function ShowDialog()
{
	if(isFixMode)
	{
		uicontrolDialogAssetScr.SetDialogDescHtml(((((("<br><font name=gameDefault9>" $ GetSystemMessage(13987)) $ "</font><br><br><font color=\"E6DCBE\" name=gameDefault9>") $ GetSystemMessage(13988)) $ "<br>") $ MakeFixDialogHtml()));
	}
	else if(CheckTutorialCondition())
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, GetSystemString(14677));
		Class'InterfaceClassic.DialogBox'.static.Inst().AnchorToOwner(0, 0);
		Class'InterfaceClassic.DialogBox'.static.Inst().SetDefaultAction(EDefaultCancel);
		return;
	}
	else
	{
		uicontrolDialogAssetScr.SetDialogDescHtml((((("<font name=gameDefault9>" $ GetSystemMessage(13985)) $ "</font><br><br><font color=\"E6DCBE\" name=gameDefault9>") $ GetSystemMessage(13986)) $ "</font>"));
	}
	uicontrolDialogAssetScr.SetUseNeedItem(true);
	uicontrolDialogAssetScr.StartNeedItemList(1);
	uicontrolDialogAssetScr.AddNeedItemClassID(multiNeedItemsScr._GetMyClassID(), multiNeedItemsScr._GetMyAmount());
	uicontrolDialogAssetScr.SetItemNum(1);
	AssetPopupWnd.ShowWindow();
	uicontrolDialogAssetScr.Show();
	return;
}

function PlayStartChangeAni()
{
	local int i;
	local AnimTextureHandle aniTexture;

	i = 0;
	while((i < 3))
	{
		aniTexture = GetAnimTextureHandle((GetOptionChangeRotationPath(i) $ ".OptionStartAni_tex"));
		aniTexture.ShowWindow();
		aniTexture.SetLoopCount(1);
		aniTexture.Play();
		i++;
	}
	return;
}

function PlayResultChangeAni()
{
	local int i;
	local AnimTextureHandle aniTexture;
	local int HigherGrade, Grade;

	HigherGrade = 100;
	i = 0;
	while((i < 3))
	{
		aniTexture = GetAnimTextureHandle((GetOptionChangeRotationPath(i) $ ".OptionGetAni_tex"));
		aniTexture.ShowWindow();
		Grade = GetGradeByStep(optionStepsSaved[i]);
		HigherGrade = Min(HigherGrade, Grade);
		aniTexture.SetTexture(GetAniTextureByStep(Grade));
		aniTexture.SetLoopCount(1);
		aniTexture.Play();
		i++;
	}
	switch(HigherGrade)
	{
		case 0:
			PlaySound("InterfaceSound.AdenLab_SPCard_GetA");
			break;
		case 1:
			PlaySound("InterfaceSound.AdenLab_SPCard_GetB");
			break;
		case 2:
			PlaySound("InterfaceSound.AdenLab_SPCard_GetC");
			break;
		default:
			break;
	}
	return;
}

function StopRotates()
{
	local int i;

	i = 0;
	while((i < rotateTweeObjects.Length))
	{
		rotateTweeObjects[i]._Stop();
		i++;
	}
	return;
}

function ResetRotateOptionChanges()
{
	local int i;

	i = 0;
	while((i < 3))
	{
		GetWindowHandle(GetOptionChangeRotationPath(i)).SetRotationAngle(0.0000000);
		i++;
	}
	return;
}

function HandleOnChangeEditBox(UIControlNumberInputSteper scr)
{
	local int i;

	EnchantValues.DeleteAllItem();
	i = 0;
	while((i < optionNum))
	{
		EnchantValues.InsertRecord(MakeRecord_EnchantValues(i));
		i++;
	}
	return;
}

function RichListCtrlRowData MakeRecord_EnchantValues(int Index)
{
	local Color color_txt;
	local string szString, optionNameString;
	local RichListCtrlRowData Record;
	local string probString;

	targetStep = numberInputStepper._getEditNum();
	Record.cellDataList.Length = 2;
	optionNameString = _GetOptionNameString(optionIds[Index], 1);
	szString = (((GetSystemString(88) $ ".") $ string(optionStepsCurrent[Index])) @ optionNameString);
	AddRichListCtrlString(Record.cellDataList[0].drawitems, szString, GetColor(255, 255, 255, 255), false);
	if((targetStep < optionStepsCurrent[Index]))
	{
		color_txt = getInstanceL2Util().Red;
	}
	else if((targetStep == optionStepsCurrent[Index]))
	{
		color_txt = getInstanceL2Util().White;
	}
	else
	{
		color_txt = GetColor(0, 176, 255, 255);
	}
	if((optionStepsCurrent[Index] == 0))
	{
		szString = ((GetSystemString(88) $ ". ") $ string(optionStepsCurrent[Index]));
	}
	else
	{
		szString = _GetOptionValueString(optionIds[Index], optionStepsCurrent[Index]);
	}
	AddRichListCtrlString(Record.cellDataList[0].drawitems, szString, getInstanceL2Util().White, true);
	szString = (" >>" @ _GetOptionValueString(optionIds[Index], targetStep));
	AddRichListCtrlString(Record.cellDataList[0].drawitems, szString, color_txt, false);
	probString = AdenLabBossOptionProbWnd(GetScript("AdenLabBossOptionProbWNd"))._GetProbIndexNLevel(Index, targetStep);
	AddRichListCtrlString(Record.cellDataList[1].drawitems, probString, getInstanceL2Util().White, false);
	return Record;
}

function SetRangeMinMaxNum()
{
	numberInputStepper._setRangeMinMaxNum(1, MaxLevel);
	numberInputStepper._setEditNum(MaxLevel);
	return;
}

function StopProgressBar()
{
	ProgressBar.SetPos(800);
	ProgressBar.Stop();
	bProgressBar = false;
	return;
}

function SetProgressBar()
{
	PlaySound("InterfaceSound.AdenLab_SPCard_Progress");
	ProgressBar.SetProgressTime(800);
	ProgressBar.SetPos(800);
	ProgressBar.Start();
	bProgressBar = true;
	return;
}

function SetOptionStepCurrent(int Index)
{
	local string Path;
	local int OptionID;

	OptionID = optionIds[Index];
	Path = GetOptionPath(Index);
	if((optionStepsCurrent.Length == 0))
	{
		GetTextBoxHandle((Path $ ".OptionStep")).SetText("");
		GetTextBoxHandle((Path $ ".OptionValue")).SetText("");
		GetTextureHandle((Path $ ".GradeTexture")).SetTexture("L2UI_NewTex.AdenLabWnd.OptionBG_N");
	}
	else
	{
		GetTextBoxHandle((Path $ ".OptionStep")).SetText(((GetSystemString(88) $ ".") $ string(optionStepsCurrent[Index])));
		GetTextBoxHandle((Path $ ".OptionValue")).SetText(_GetOptionValueString(OptionID, optionStepsCurrent[Index]));
		GetTextureHandle((Path $ ".GradeTexture")).SetTexture(GetGradeTextureByStep(optionStepsCurrent[Index]));
	}
	return;
}

function string GetGradeTextureByStep(int Step)
{
	switch(Step)
	{
		case MaxLevel:
			return "L2UI_NewTex.AdenLabWnd.OptionBG_A";
		case (MaxLevel - 1):
			return "L2UI_NewTex.AdenLabWnd.OptionBG_B";
		case (MaxLevel - 2):
			return "L2UI_NewTex.AdenLabWnd.OptionBG_C";
		case (MaxLevel - 3):
			return "L2UI_NewTex.AdenLabWnd.OptionBG_D";
		case (MaxLevel - 4):
			return "L2UI_NewTex.AdenLabWnd.OptionBG_E";
		default:
			return "L2UI_NewTex.AdenLabWnd.OptionBG_F";
	}
}

function StartBossOptionChange()
{
	SetProgressBar();
	PlayStartChangeAni();
	SetButtonBossOptionChange();
	return;
}

function SetBossOptionValueCurrents()
{
	local int i;

	i = 0;
	while((i < optionNum))
	{
		SetOptionStepCurrent(i);
		i++;
	}
	return;
}

function SetApplyBossOptoinChanged()
{
	local int i;
	local AnimTextureHandle aniTexture;

	if(CheckTutorialCondition())
	{
		bSuccess = true;
	}
	i = 0;
	while((i < 3))
	{
		aniTexture = GetAnimTextureHandle((GetOptionPath(i) $ ".OptionGetAni_tex"));
		aniTexture.ShowWindow();
		aniTexture.SetLoopCount(1);
		aniTexture.Play();
		i++;
	}
	PlaySound("InterfaceSound.AdenLab_SPCard_ChangeFin");
	optionStepsCurrent = optionStepsSaved;
	optionStepsSaved.Length = 0;
	SetBossOptionValueCurrents();
	SetBossOptionChangedValue();
	SetModeBossOptionView();
	Class'InterfaceClassic.AdenLabWnd'.static._Inst()._SetSpecialOptionStepCurrent(BossID, SlotID, optionStepsCurrent);
	return;
}

function SetPlayDailyFee()
{
	InitFeeDailyFees(playFeeDailyFees);
	if((selectedPlayFeeClassID != 0))
	{
		multiNeedItemsScr._SetSelectByItemClassID(selectedPlayFeeClassID);
	}
	return;
}

function SetAutoPaymentItemList()
{
	EnchantPayment.DeleteAllItem();
	EnchantPayment.InsertRecord(multiNeedItemsScr._GetRec(0));
	return;
}

function SetFixDailyFee()
{
	local array<L2ItemAmount> tutorialCondition;

	if(CheckTutorialCondition())
	{
		tutorialCondition[0] = fixFeeDailyFees[0];
		tutorialCondition[0].ItemAmount = 0;
		InitFeeDailyFees(tutorialCondition);
		return;
	}
	InitFeeDailyFees(fixFeeDailyFees);
	if((selectedFixFeeClassID != 0))
	{
		multiNeedItemsScr._SetSelectByItemClassID(selectedFixFeeClassID);
	}
	return;
}

function MultiItemSelected(int selectNeedItemIndex, int selectedClassID, INT64 selectedAmount)
{
	if((isFixMode == false))
	{
		selectedPlayFeeClassID = selectedClassID;
	}
	else
	{
		selectedFixFeeClassID = selectedClassID;
	}
	return;
}

function SetModeBossOptionView()
{
	isFixMode = false;
	SetPlayDailyFee();
	SetSavedOption();
	HideArrows();
	HideMainBgChange();
	StopProgressBar();
	OptionGoalWnd.HideWindow();
	adenLabBossOptionPopup.HideWindow();
	StopAllPlayAnis();
	SetButtonBossOptionView();
	OptionCheck();
	HideMainInfomation();
	return;
}

function HideMainBgChange()
{
	ApplyInfo_txt.HideWindow();
	MainBgChange_tex.SetAlpha(0, 0.5000000);
	return;
}

function ShowMainBgChange()
{
	ApplyInfo_txt.ShowWindow();
	ApplyInfo_txt.SetText(GetSystemMessage(13987));
	MainBgChange_tex.SetAlpha(255, 0.5000000);
	return;
}

function StopAllPlayAnis()
{
	local int i;

	i = 0;
	while((i < 3))
	{
		GetAnimTextureHandle((GetOptionChangeRotationPath(i) $ ".OptionGetAni_tex")).HideWindow();
		GetTextureHandle((GetOptionChangeRotationPath(i) $ ".GradeBackTexture")).HideWindow();
		i++;
	}
	StopRotates();
	ResetRotateOptionChanges();
	HideAllGradeBackTexture();
	StopProgressBar();
	return;
}

function SetButtonBossOptionView()
{
	AllBtnHide();
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ApplyModeBtn")).ShowWindow();
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".StartBtn")).ShowWindow();
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AutoStartBtn")).ShowWindow();
	if(CheckFirstPlayCondition())
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AutoStartBtn")).DisableWindow();
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".StartBtn")).EnableWindow();
		UpdateItemScoreInfo(false);
	}
	else if(CheckTutorialCondition())
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AutoStartBtn")).DisableWindow();
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".StartBtn")).DisableWindow();
		ApplyInfo_txt.ShowWindow();
		ApplyInfo_txt.SetText(GetSystemMessage(14027));
		UpdateItemScoreInfo(false);
	}
	else
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AutoStartBtn")).EnableWindow();
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".StartBtn")).EnableWindow();
		UpdateItemScoreInfo(true);
	}
	return;
}

function bool CheckFirstPlayCondition()
{
	if((optionStepsSaved.Length > 0))
	{
		return false;
	}
	if((optionStepsCurrent[0] > 0))
	{
		return false;
	}
	return true;
}

function bool CheckTutorialCondition()
{
	if((optionStepsSaved.Length == 0))
	{
		return false;
	}
	if((optionStepsCurrent[0] > 0))
	{
		return false;
	}
	return true;
}

function SetModeBossOptionChange()
{
	SetButtonBossOptionChange();
	SetBossOptionChangedValue();
	SetBossOptionShowSavedTweenPlay();
	StartBossOptionChange();
	IsAutoMode = false;
	HideMainInfomation();
	return;
}

function SetButtonBossOptionChange()
{
	AllBtnHide();
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CancelBtn")).SetNameText(GetSystemString(14738));
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CancelBtn")).ShowWindow();
	return;
}

function SetModeBossOptionChangeEnd()
{
	if(Class'InterfaceClassic.AdenLabWnd'.static._Inst()._GetUseLocal())
	{
		RQ_C_EX_ADENLAB_SPECIAL_PLAY_Local();
	}
	else
	{
		RQ_C_EX_ADENLAB_SPECIAL_PLAY();
	}
	return;
}

function SetAutoCheck()
{
	if(IsAutoMode)
	{
		if(ChkMinStepNTargetStep())
		{
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13977));
			GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CancelBtn")).SetNameText(GetSystemString(3903));
		}
		else if((multiNeedItemsScr._GetMaxNumCanBuy() <= INT64(1)))
		{
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13978));
		}
		else
		{
			m_hOwnerWnd.EnableTick();
		}
	}
	else
	{
		SetButtonBossOptionChangeEnd();
	}
	return;
}

function bool ChkMinStepNTargetStep()
{
	local int i;

	i = 0;
	while((i < optionNum))
	{
		if((targetStep <= optionStepsSaved[i]))
		{
			return true;
		}
		i++;
	}
	return false;
}

function SetButtonBossOptionChangeEnd()
{
	AllBtnHide();
	if(CheckTutorialCondition())
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".StartBtn")).DisableWindow();
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AutoStartBtn")).DisableWindow();
		ApplyInfo_txt.ShowWindow();
		ApplyInfo_txt.SetText(GetSystemMessage(14027));
	}
	else
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".StartBtn")).EnableWindow();
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AutoStartBtn")).EnableWindow();
		SetMainInfomation_txt(GetSystemString(14641));
	}
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".StartBtn")).ShowWindow();
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AutoStartBtn")).ShowWindow();
	return;
}

function SetModeBossOptionApply()
{
	if(_IsRequested())
	{
		return;
	}
	isFixMode = true;
	SetFixDailyFee();
	StopAllPlayAnis();
	ShowArrows();
	ShowMainBgChange();
	SetBossOptionShowSavedTweenPlay();
	OptionGoalWnd.HideWindow();
	SetButtonBossOptionApply();
	if(CheckTutorialCondition())
	{
		SetMainInfomation_txt(GetSystemString(14678));
	}
	else if((optionNum == 1))
	{
		SetMainInfomation_txt(GetSystemString(14645));
	}
	else
	{
		SetMainInfomation_txt(GetSystemString(14649));
	}
	return;
}

function SetButtonBossOptionApply()
{
	AllBtnHide();
	if((optionStepsSaved.Length == 0))
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ApplyBtn")).DisableWindow();
	}
	else
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ApplyBtn")).EnableWindow();
	}
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ApplyModeBtn")).HideWindow();
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ApplyBtn")).ShowWindow();
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ApplyCancelBtn")).ShowWindow();
	return;
}

function HideArrows()
{
	local int i;

	i = 0;
	while((i < 3))
	{
		GetTextureHandle((GetOptionBGPath(i) $ ".ArrowTextureApplyDeco")).HideWindow();
		i++;
	}
	return;
}

function ShowArrows()
{
	local int i;

	i = 0;
	while((i < 3))
	{
		GetTextureHandle((GetOptionBGPath(i) $ ".ArrowTextureApplyDeco")).ShowWindow();
		i++;
	}
	return;
}

function HideSavedOptionAniTextures()
{
	local int i;

	i = 0;
	while((i < 3))
	{
		GetWindowHandle((GetOptionChangePath(i) $ ".OptionTradeAni_tex")).HideWindow();
		i++;
	}
	return;
}

function ShowSavedOptionAniTextures()
{
	local int i;

	i = 0;
	while((i < 3))
	{
		GetWindowHandle((GetOptionChangePath(i) $ ".OptionTradeAni_tex")).ShowWindow();
		i++;
	}
	return;
}

function HideSavedOption()
{
	HideSavedOptionAniTextures();
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ApplyModeBtn")).DisableWindow();
	SetBossOptionHideSavedTweenPlay();
	return;
}

function ShowSavedOption()
{
	ShowSavedOptionAniTextures();
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ApplyModeBtn")).EnableWindow();
	SetBossOptionShowSavedTweenPlay();
	return;
}

function SetSavedOption()
{
	if((optionStepsSaved.Length == 0))
	{
		HideSavedOption();
	}
	else
	{
		ShowSavedOption();
	}
	return;
}

function SetModeBossOptionChangeAutoPopup()
{
	SetAutoPaymentItemList();
	SetRangeMinMaxNum();
	adenLabBossOptionPopup.ShowWindow();
	if(multiNeedItemsScr._GetCanBuy())
	{
		GetButtonHandle((adenLabBossOptionPopup.m_WindowNameWithFullPath $ ".ConfirmBtn")).EnableWindow();
	}
	else
	{
		GetButtonHandle((adenLabBossOptionPopup.m_WindowNameWithFullPath $ ".ConfirmBtn")).DisableWindow();
	}
	return;
}

function SetModeBossOptionChangeAuto()
{
	adenLabBossOptionPopup.HideWindow();
	SetButtonBossOptionChange();
	SetBossOptionShowSavedTweenPlay();
	StartBossOptionChange();
	OptionGoalWnd.ShowWindow();
	SetTargetValues();
	IsAutoMode = true;
	isCancelRequested = false;
	return;
}

function SetBossOptionChangedValue()
{
	local int i;
	local string Path;

	if((optionStepsSaved.Length == 0))
	{
		SetBossOptionChangeValueInit();
		HideSavedOption();
		return;
	}
	i = 0;
	while((i < optionNum))
	{
		Path = GetOptionChangeRotationPath(i);
		if((optionStepsSaved[i] > optionStepsCurrent[i]))
		{
			GetTextureHandle((Path $ ".ArrowTexture")).SetTexture("L2UI_NewTex.AdenLabWnd.OptionArrow_Up");
		}
		else if((optionStepsSaved[i] == optionStepsCurrent[i]))
		{
			GetTextureHandle((Path $ ".ArrowTexture")).SetTexture("L2UI_CT1.EmptyBtn");
		}
		else
		{
			GetTextureHandle((Path $ ".ArrowTexture")).SetTexture("L2UI_NewTex.AdenLabWnd.OptionArrow_Down");
		}
		GetTextBoxHandle((Path $ ".OptionStep")).SetText(((GetSystemString(88) $ ".") $ string(optionStepsSaved[i])));
		GetTextBoxHandle((Path $ ".OptionValue")).SetText(_GetOptionValueString(optionIds[i], optionStepsSaved[i]));
		GetTextureHandle((Path $ ".GradeTexture")).SetTexture(GetGradeTextureByStep(optionStepsSaved[i]));
		i++;
	}
	ShowSavedOption();
	return;
}

function SetBossOptionChangeValueInit()
{
	local int i;
	local string Path;

	i = 0;
	while((i < 3))
	{
		Path = GetOptionChangeRotationPath(i);
		GetTextureHandle((Path $ ".ArrowTexture")).SetTexture("L2UI_CT1.EmptyBtn");
		GetTextBoxHandle((Path $ ".OptionStep")).SetText("");
		GetTextBoxHandle((Path $ ".OptionValue")).SetText("");
		GetTextureHandle((Path $ ".GradeTexture")).SetTexture("L2UI_NewTex.AdenLabWnd.OptionBG_N");
		i++;
	}
	return;
}

function SetBossOptionShowSavedTweenPlay()
{
	local int locX, locY;

	tObject._DelegateOnUpdate = HandleDelegateOnUpdateShow;
	GetLocalPosition(tObject.Target, locX, locY);
	tObject.MoveY = ((-77.0000000 + float(startLocY)) - float(locY));
	tObject._Reset();
	return;
}

function SetBossOptionHideSavedTweenPlay()
{
	local int locX, locY;

	GetLocalPosition(tObject.Target, locX, locY);
	tObject.MoveY = float((startLocY - locY));
	tObject._DelegateOnUpdate = HandleDelegateOnUPdateHide;
	tObject._Reset();
	return;
}

function SetOptionLayOutByOptionNum()
{
	local int i, oX, oY, movX;

	movX = (((1146 - 279) - ((optionNum - 1) * (279 + 67))) / 2);
	Local2Global(adenLabBossTitleNBg, movX, 0, oX, oY);
	GetWindowHandle(GetOptionBGPath(0)).MoveTo(oX, oY);
	Local2Global(adenLabBossOption, movX, 0, oX, oY);
	GetWindowHandle(GetOptionPath(0)).MoveTo((oX + 22), oY);
	Local2Global(adenLabBossOptionChange, movX, 0, oX, oY);
	GetWindowHandle(GetOptionChangePath(0)).MoveTo((oX + 22), oY);
	i = 0;
	while((i < optionNum))
	{
		GetWindowHandle(GetOptionBGPath(i)).ShowWindow();
		GetWindowHandle(GetOptionPath(i)).ShowWindow();
		GetWindowHandle(GetOptionChangePath(i)).ShowWindow();
		i++;
	}
	i = optionNum;
	while((i < 3))
	{
		GetWindowHandle(GetOptionBGPath(i)).HideWindow();
		GetWindowHandle(GetOptionPath(i)).HideWindow();
		GetWindowHandle(GetOptionChangePath(i)).HideWindow();
		i++;
	}
	return;
}

function OptionCheck()
{
	if((optionStepsSaved.Length > 0))
	{
		twinkleObject._Play();
	}
	else
	{
		twinkleObject._Stop();
	}
	return;
}

function AllBtnHide()
{
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".StartBtn")).HideWindow();
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AutoStartBtn")).HideWindow();
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CancelBtn")).HideWindow();
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ApplyCancelBtn")).HideWindow();
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ApplyBtn")).HideWindow();
	return;
}

function string GetOptionBGPath(int Index)
{
	return ((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AdenLabBossTitleNBg.OptionWnd") $ string(Index));
}

function string GetOptionPath(int Index)
{
	return ((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AdenLabBossOption.OptionWnd") $ string(Index));
}

function string GetOptionChangePath(int Index)
{
	return ((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AdenLabBossOptionChange.OptionWnd") $ string(Index));
}

function string GetOptionChangeRotationPath(int Index)
{
	return (GetOptionChangePath(Index) $ ".RotationWnd");
}

function SetTmpBackNextBtns()
{
	if((optionNum == 1))
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Prev_Btn")).DisableWindow();
	}
	else
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Prev_Btn")).EnableWindow();
	}
	if((optionNum == 3))
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Next_Btn")).DisableWindow();
	}
	else
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Next_Btn")).EnableWindow();
	}
	return;
}

function OpenSpicialGame()
{
	local CardSelectSpecialStage spcialStageData;

	API_GetSpecialStageData(SlotID, spcialStageData);
	HideAllGradeBackTexture();
	SetOptionIds();
	SetBossOptionDescs();
	SetBossOptionValueCurrents();
	SetBossOptionChangedValue();
	SetOptionLayOutByOptionNum();
	m_hOwnerWnd.ShowWindow();
	return;
}

function HideAllGradeBackTexture()
{
	local int i;

	i = 0;
	while((i < 3))
	{
		GetTextureHandle((GetOptionChangeRotationPath(i) $ ".GradeBackTexture")).HideWindow();
		i++;
	}
	return;
}

function ShowAllGradeBackTexture()
{
	local int i;

	i = 0;
	while((i < 3))
	{
		GetTextureHandle((GetOptionChangeRotationPath(i) $ ".GradeBackTexture")).ShowWindow();
		i++;
	}
	return;
}

function SetOptionIds()
{
	_GetOptionIDs(stageIndex, optionNum, MaxLevel, optionIds);
	numberInputStepper._setAddButtons(-5, 5, MaxLevel);
	return;
}

function SetBossOptionDescs()
{
	local int i;

	i = 0;
	while((i < optionIds.Length))
	{
		GetTextBoxHandle((GetOptionBGPath(i) $ ".OptionName")).SetText(_GetOptionNameString(optionIds[i], 1));
		i++;
	}
	return;
}

function TestSetOptionSavedRandomValue()
{
	local int i;

	optionStepsSaved.Length = 3;
	i = 0;
	while((i < 3))
	{
		optionStepsSaved[i] = (Rand(MaxLevel) + 1);
		i++;
	}
	return;
}

function TestSetCurrentOptions()
{
	local int i;

	optionStepsCurrentTest.Length = 3;
	i = 0;
	while((i < optionStepsCurrentTest.Length))
	{
		optionStepsCurrentTest[i] = (Rand(MaxLevel) + 1);
		i++;
	}
	return;
}

function TestLayOutChange()
{
	SetTmpBackNextBtns();
	optionIds.Length = optionNum;
	optionStepsCurrent.Length = optionNum;
	SetBossOptionValueCurrents();
	SetOptionLayOutByOptionNum();
	return;
}

function _InitSpcialData(CardSelectData Data)
{
	InitNeedItemSelectMultiItemsPopup();
	return;
}

function _InitFeeItemsSpcial(CardSelectData Data)
{
	local int i;

	multiNeedItemsScr._Clear();
	playFeeDailyFees.Length = 0;
	fixFeeDailyFees.Length = 0;
	i = 0;
	while((i < Data.FeeArray.Length))
	{
		switch(Data.FeeArray[i].FeeType)
		{
			case FEE_SPECIAL:
				playFeeDailyFees[playFeeDailyFees.Length] = Data.FeeArray[i].FeeItem;
				break;
			case FEE_SPECIALFIXED:
				fixFeeDailyFees[fixFeeDailyFees.Length] = Data.FeeArray[i].FeeItem;
				break;
			default:
				break;
		}
		i++;
	}
	return;
}

function _TryShowSpecialGame(int nStageIndex, int nSlotID, int nBossID)
{
	BossID = nBossID;
	SlotID = nSlotID;
	stageIndex = nStageIndex;
	if(Class'InterfaceClassic.AdenLabWnd'.static._Inst()._GetUseLocal())
	{
		RQ_C_EX_ADENLAB_SPECIAL_SLOT_Local();
	}
	else
	{
		RQ_C_EX_ADENLAB_SPECIAL_SLOT();
	}
	return;
}

function UpdateItemScoreInfo(bool isEnable)
{
	local CardSelectSpecialStage spcialStageData;
	local L2Util util;

	util = Class'InterfaceClassic.L2Util'.static.Inst();
	if(IsShowItemScore())
	{
		API_GetSpecialStageData(SlotID, spcialStageData);
		if((spcialStageData.ItemScore > 0))
		{
			ItemScore_txt.SetText(string(spcialStageData.ItemScore));
			ItemScoreWnd.ShowWindow();
			if(isEnable)
			{
				ItemScore_txt.SetTextColor(GetColor(221, 221, 221, 255));
				ItemScoreWnd.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14862)));
			}
			else
			{
				ItemScore_txt.SetTextColor(util.Gray);
				ItemScoreWnd.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14861)));
			}
		}
		else
		{
			ItemScoreWnd.HideWindow();
		}
	}
	return;
}

function _GetOptionIDs(int nStageIndex, out int oOptionNum, out int oMaxLevel, out array<int> oOptionIDs)
{
	local int i, SlotIndex;
	local CardSelectSpecialStage spcialStageData;

	API_GetSpecialStageData(nStageIndex, spcialStageData);
	oOptionIDs.Length = 0;
	i = 0;
	while((i < spcialStageData.EffectArray.Length))
	{
		SlotIndex = spcialStageData.EffectArray[i].EffectSlot;
		oOptionIDs.Length = Max(oOptionIDs.Length, SlotIndex);
		if((oOptionIDs.Length == 0))
		{
			oOptionIDs[SlotIndex] = spcialStageData.EffectArray[i].ExOptionKey.Id;
			i++;
			continue;
		}
		if((oOptionIDs[SlotIndex] != spcialStageData.EffectArray[i].ExOptionKey.Id))
		{
			oOptionIDs[SlotIndex] = spcialStageData.EffectArray[i].ExOptionKey.Id;
		}
		i++;
	}
	oOptionNum = oOptionIDs.Length;
	oMaxLevel = (spcialStageData.EffectArray.Length / oOptionNum);
	return;
}

function string GValueStringByStepNOptionID(int OptionID, int Step)
{
	local ExOptionData oOptionData;

	API_GetExOptionData(OptionID, Step, oOptionData);
	return _GetOptionTooltipString(oOptionData.Filter[0]);
}

function string _GetOptionTooltipString(ExOptionFilter optionFilter)
{
	local string nameString;
	local UIEventManager.EExOptionType Type;
	local float Value;
	local string valueString;

	Type = EExOptionType(optionFilter.Type);
	Value = optionFilter.Value;
	nameString = optionFilter.Name;
	valueString = getInstanceL2Util().CutFloatDecimalPlaces(Value, 2, true);
	if((Value > 0.0000000))
	{
		valueString = ("+" $ valueString);
	}
	switch(Type)
	{
		case OPTION_PER:
			valueString = (valueString $ "%");
		default:
			return (nameString @ valueString);
	}
}

function string _GetOptionNameString(int OptionID, int Step)
{
	local ExOptionData oOptionData;

	API_GetExOptionData(OptionID, Step, oOptionData);
	return oOptionData.Filter[0].Name;
}

function string _GetOptionValueString(int OptionID, int Step)
{
	local ExOptionData oOptionData;
	local ExOptionFilter optionFilter;

	API_GetExOptionData(OptionID, Step, oOptionData);
	optionFilter = oOptionData.Filter[0];
	return _MakeOptionValueString(OptionID, optionFilter.Value);
}

function string _MakeOptionValueString(int opitonID, float Value)
{
	local ExOptionData optionData;
	local string valueString;
	local UIEventManager.EExOptionType Type;
	local ExOptionFilter optionFilter;

	API_GetExOptionData(opitonID, 1, optionData);
	optionFilter = optionData.Filter[0];
	Type = EExOptionType(optionFilter.Type);
	if((Value == 0.0000000))
	{
		return "";
	}
	valueString = getInstanceL2Util().CutFloatDecimalPlaces(Value, 2, true);
	if((Value > 0.0000000))
	{
		valueString = ("+" $ valueString);
	}
	switch(Type)
	{
		case OPTION_PERSUM:
		case OPTION_PER:
			valueString = (valueString $ "%");
			break;
		default:
			break;
	}
	return valueString;
}

event OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(1153));
	RegisterEvent(EV_PacketID(1155));
	RegisterEvent(EV_PacketID(1156));
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_PacketID(1153):
			RT_S_EX_ADENLAB_SPECIAL_SLOT();
			break;
		case EV_PacketID(1155):
			RT_S_EX_ADENLAB_SPECIAL_PLAY();
			break;
		case EV_PacketID(1156):
			RT_S_EX_ADENLAB_SPECIAL_FIX();
			break;
		default:
			break;
	}
	return;
}

event OnLoad()
{
	InitDatas();
	SetClosingOnESC();
	InitWindowHandles();
	InitTween();
	_RequestedRefreshTObject = Class'InterfaceClassic.L2UITimer'.static.Inst()._MakeTimerObject(10000);
	_RequestedRefreshTObject._DelegateOnEnd = RequestedRelease;
	_RequestedRefreshTObject._Stop();
	InitUIControlNumberInputSteper();
	InitUIControlDialogAsset();
	ShortcutIcon_Enter = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AdenLabBossOptionPopup.AdenLabBossAutoSetWnd.ShortcutIcon_Enter"));
	ShortcutIcon_ESC = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AdenLabBossOptionPopup.AdenLabBossAutoSetWnd.ShortcutIcon_ESC"));
	return;
}

event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	if(bProgressBar)
	{
		SetModeBossOptionView();
		return;
	}
	if(isFixMode)
	{
		SetModeBossOptionView();
		return;
	}
	m_hOwnerWnd.HideWindow();
	return;
}

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	switch(nKey)
	{
		case IK_Escape:
			return HandleCancel();
		default:
			return false;
	}
}

event bool OnKeyDown(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	switch(nKey)
	{
		case IK_Enter:
			return HandleOK();
		default:
			return false;
	}
}

function bool HandleOK()
{
	if(adenLabBossOptionPopup.IsShowWindow())
	{
		if(multiNeedItemsScr._GetCanBuy())
		{
			SetModeBossOptionChangeAuto();
		}
		return true;
	}
	return false;
}

function bool HandleCancel()
{
	if(adenLabBossOptionPopup.IsShowWindow())
	{
		SetModeBossOptionView();
		return true;
	}
	return false;
}

function InitDatas()
{
	selectedPlayFeeClassID = 0;
	selectedFixFeeClassID = 0;
	return;
}

event OnClickButton(string btnName)
{
	if(uicontrolDialogAssetScr.m_hOwnerWnd.IsShowWindow())
	{
		uicontrolDialogAssetScr.Hide();
		AssetPopupWnd.HideWindow();
	}
	if((Class'InterfaceClassic.DialogBox'.static.Inst().m_hOwnerWnd.IsShowWindow() && DialogIsMine()))
	{
		Class'InterfaceClassic.DialogBox'.static.Inst().HideDialog();
	}
	switch(btnName)
	{
		case "AutoCancelBtn":
		case "ApplyCancelBtn":
		case "Close_Btn":
			SetModeBossOptionView();
			break;
		case "ApplyModeBtn":
			SetModeBossOptionApply();
			break;
		case "ApplyBtn":
			OnClickPopupBuy();
			break;
		case "StartBtn":
			ShowDialog();
			break;
		case "AutoStartBtn":
			SetModeBossOptionChangeAutoPopup();
			HideMainInfomation();
			break;
		case "ConfirmBtn":
			SetModeBossOptionChangeAuto();
			break;
		case "CancelBtn":
			HandleCancelBtnClick();
			break;
		case "Back_btn":
			OnReceivedCloseUI();
			break;
		case "Prev_Btn":
			optionNum = Max(1, (optionNum - 1));
			TestLayOutChange();
			break;
		case "Next_Btn":
			optionNum = Min(3, (optionNum + 1));
			TestLayOutChange();
			break;
		default:
			break;
	}
	return;
}

function HandleCancelBtnClick()
{
	if((IsAutoMode == true))
	{
		isCancelRequested = true;
	}
	SetModeBossOptionView();
	return;
}

event OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	local int Index, OptionID;

	switch(a_ButtonHandle.GetWindowName())
	{
		case "valueInfo":
			Index = int(Right(a_ButtonHandle.GetParentWindowName(), 1));
			OptionID = optionIds[Index];
			Class'InterfaceClassic.AdenLabBossOptionProbWnd'.static._Inst()._ToggleAdenSpcialOption(OptionID, Index, GetcurrentLevel(Index));
			m_hOwnerWnd.SetFocus();
			break;
		default:
			break;
	}
	return;
}

event OnShow()
{
	PlaySound("InterfaceSound.AdenLab_SPCard_IN");
	m_hOwnerWnd.SetAnchor("AdenLabWnd", "BottomCenter", "BottomC`", 0, 4);
	effectViewport.SpawnEffect("LineageEffect2.ave_white_trans_deco");
	SetOptionLayOutByOptionNum();
	SetModeBossOptionView();
	uicontrolDialogAssetScr.Hide();
	AssetPopupWnd.HideWindow();
	m_hOwnerWnd.SetFocus();
	Class'InterfaceClassic.AdenLabBossOptionProbWnd'.static._Inst()._ToggleAdenSpcialOption(optionIds[0], 0, GetcurrentLevel(0));
	return;
}

event OnSetFocus(WindowHandle a_WindowHandle, bool bFocused)
{
	if(bFocused)
	{
		ShortcutIcon_Enter.ShowWindow();
		ShortcutIcon_ESC.ShowWindow();
	}
	else
	{
		ShortcutIcon_Enter.HideWindow();
		ShortcutIcon_ESC.HideWindow();
	}
	if(!bFocused)
	{
		return;
	}
	if(!depthSort)
	{
		depthSort = true;
		GetWindowHandle("AdenLabWNd").SetFocus();
	}
	else
	{
		super.OnSetFocus(a_WindowHandle, bFocused);
	}
	depthSort = false;
	return;
}

event OnHide()
{
	effectViewport.SpawnEffect("");
	CheckOnHideSuccess();
	BossID = -1;
	SlotID = -1;
	Class'InterfaceClassic.AdenLabBossOptionProbWnd'.static._Inst()._Hide();
	return;
}

function CheckOnHideSuccess()
{
	if((bSuccess == false))
	{
		return;
	}
	Class'InterfaceClassic.AdenLabWnd'.static._Inst()._SetSuccess();
	bSuccess = false;
	return;
}

event OnProgressTimeUp(string strID)
{
	bProgressBar = false;
	SetModeBossOptionChangeEnd();
	return;
}

event OnTick()
{
	if(isCancelRequested)
	{
		return;
	}
	m_hOwnerWnd.DisableTick();
	StartBossOptionChange();
	return;
}

function SyncWindowCheck()
{
	if(GetWindowHandle("AdenLabWnd").IsShowWindow())
	{
		getInstanceL2Util().syncWindowLoc("AdenLabWnd", getCurrentWindowName(string(self)));
	}
	return;
}

function _RQ_C_EX_ADENLAB_SPECIAL_SLOT(int nBossID, int nSlotID)
{
	local array<byte> stream;
	local UIPacket._C_EX_ADENLAB_SPECIAL_SLOT packet;

	if(!SetRequestLock())
	{
		return;
	}
	packet.nBossID = nBossID;
	packet.nSlotID = nSlotID;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_ADENLAB_SPECIAL_SLOT(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(886, stream);
	return;
}

function RQ_C_EX_ADENLAB_SPECIAL_SLOT_Local()
{
	local array<int> fixedOptionGrades, drawnOptionGrades;

	optionStepsCurrent = fixedOptionGrades;
	optionStepsSaved = drawnOptionGrades;
	OpenSpicialGame();
	return;
}

function RQ_C_EX_ADENLAB_SPECIAL_SLOT()
{
	_RQ_C_EX_ADENLAB_SPECIAL_SLOT(BossID, SlotID);
	return;
}

function RT_S_EX_ADENLAB_SPECIAL_SLOT()
{
	local UIPacket._S_EX_ADENLAB_SPECIAL_SLOT packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_ADENLAB_SPECIAL_SLOT(packet))
	{
		return;
	}
	if((packet.nBossID != BossID))
	{
		return;
	}
	if((packet.nSlotID != SlotID))
	{
		return;
	}
	optionStepsCurrent = packet.fixedOptionGrades;
	optionStepsSaved = packet.drawnOptionGrades;
	OpenSpicialGame();
	RequestedRelease();
	return;
}

function RQ_C_EX_ADENLAB_SPECIAL_PLAY_Local()
{
	TestSetOptionSavedRandomValue();
	PlayResultChangeAni();
	SetBossOptionChangedValue();
	twinkleObject._Play();
	SetAutoCheck();
	return;
}

function RQ_C_EX_ADENLAB_SPECIAL_PLAY()
{
	local array<byte> stream;
	local UIPacket._C_EX_ADENLAB_SPECIAL_PLAY packet;

	if(!SetRequestLock())
	{
		return;
	}
	packet.nBossID = BossID;
	packet.nSlotID = SlotID;
	packet.nFeeIndex = Max(0, multiNeedItemsScr._GetSelectedIndexPopup());
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_ADENLAB_SPECIAL_PLAY(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(888, stream);
	PlayResultChangeAni();
	return;
}

function RT_S_EX_ADENLAB_SPECIAL_PLAY()
{
	local UIPacket._S_EX_ADENLAB_SPECIAL_PLAY packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_ADENLAB_SPECIAL_PLAY(packet))
	{
		return;
	}
	if((int(packet.bSuccess) == 0))
	{
		return;
	}
	optionStepsSaved = packet.drawnOptionGrades;
	SetBossOptionChangedValue();
	RequestedRelease();
	twinkleObject._Play();
	SetAutoCheck();
	return;
}

function RQ_C_EX_ADENLAB_SPECIAL_FIX_Local()
{
	SetApplyBossOptoinChanged();
	return;
}

function RQ_C_EX_ADENLAB_SPECIAL_FIX()
{
	local array<byte> stream;
	local UIPacket._C_EX_ADENLAB_SPECIAL_FIX packet;

	if(!SetRequestLock())
	{
		return;
	}
	packet.nBossID = BossID;
	packet.nSlotID = SlotID;
	packet.nFeeIndex = Max(0, multiNeedItemsScr._GetSelectedIndexPopup());
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_ADENLAB_SPECIAL_FIX(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(889, stream);
	return;
}

function RT_S_EX_ADENLAB_SPECIAL_FIX()
{
	local UIPacket._S_EX_ADENLAB_SPECIAL_FIX packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_ADENLAB_SPECIAL_FIX(packet))
	{
		return;
	}
	if((int(packet.bSuccess) == 1))
	{
		SetApplyBossOptoinChanged();
	}
	RequestedRelease();
	return;
}

function int GetGradeByStep(int Step)
{
	if((Step >= MaxLevel))
	{
		return 0;
	}
	else if((Step >= (MaxLevel - 5)))
	{
		return 1;
	}
	return 2;
}

function int GetcurrentLevel(int Index)
{
	if((optionStepsCurrent.Length == 0))
	{
		return -1;
	}
	return optionStepsCurrent[Index];
}

function string GetAniTextureByStep(int Grade)
{
	if((Grade == 0))
	{
		return "L2UI_NewTex.AdenLabWnd.OptionGetAniA_0000";
	}
	else if((Grade == 1))
	{
		return "L2UI_NewTex.AdenLabWnd.OptionGetAni_0000";
	}
	return "L2UI_NewTex.AdenLabWnd.OptionGetAniC_0000";
}

function SetMainInfomation_txt(string Str)
{
	MainInfomation_txt.SetText(Str);
	AdenBossOptionInfoWnd.SetAlpha(255, 1.0000000);
	return;
}

function HideMainInfomation()
{
	AdenBossOptionInfoWnd.SetAlpha(0, 1.0000000);
	return;
}

function RequestedRelease()
{
	_RequestedRefreshTObject._Stop();
	bRequested = false;
	return;
}

function bool SetRequestLock()
{
	if(bRequested)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13799));
		_RequestedRefreshTObject._Play();
		return false;
	}
	bRequested = true;
	Class'InterfaceClassic.L2UITimer'.static.Inst()._AddTimerOnce(5000)._DelegateOnEnd = RequestedRelease;
	return true;
}

function bool _IsRequested()
{
	return bRequested;
}

function API_GetSpecialStageData(int nStageIndex, out CardSelectSpecialStage Data)
{
	Class'NWindow.UIDataManager'.static.GetSpecialStageData(nStageIndex, Data);
	return;
}

function API_GetExOptionData(int OptionID, int lv, out ExOptionData Data)
{
	Class'NWindow.UIDataManager'.static.GetExOptionData(OptionID, byte(lv), Data);
	return;
}
