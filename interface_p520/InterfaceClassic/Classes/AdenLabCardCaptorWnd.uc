class AdenLabCardCaptorWnd extends UICommonAPI
	dependson(UIPacket);

const CARD_TOTAL = 36;
const CARD_ROW_MAX_SMALL = 4;
const CARD_NUM_ONELINE_SMALL = 9;
const CARD_ROW_MAX_BIG = 2;
const CARD_NUM_ONELINE_BIG = 5;
const CARD_BIG_NUM = 10;
const CARD_W = 106;
const CARD_H = 136;
const CARD_W_B = 168;
const CARD_H_B = 218;

var int BossID;
var int stageIndex;
var int cardNum;
var int cardMax;
var int remainCardNum;
var array<AdenLabCard> cards;
var array<AdenLabCard> cardSmalls;
var WindowHandle AdenLabCaptorWndBig;
var WindowHandle AdenLabCaptorWndSmall;
var WindowHandle disableWnd;
var ButtonHandle Ok_Btn;
var TextBoxHandle CardCaptorDesc01_txt;
var L2UITweenObject tObject;
var L2UITween l2UITweenScript;
var L2UITimerObject shakeTimerObject;
var INT64 lastAppMilliSeconds;
var int StartX;
var int StartY;
var bool depthSort;
var array<L2ItemAmount> lowFeeDailyFees;
var array<L2ItemAmount> highFeeDailyFees;
var int lowFeeDailyCountMax;
var int highFeeDailyCountMax;
var int normalGameSaleDailyCount;
var int normalGameDailyCount;
var bool bSale;
var bool bSuccess;
var bool bRequested;
var L2UITimerObject _RequestedRefreshTObject;
var UIControlNeedItemSelectMultiItems multiNeedItemsScr;
var UIControlNeedItem needItemMultiItems02Scr;
var AdenLabCard currentCardScr;
var UIControlDialogAssets uicontrolDialogAssetScr;

static function AdenLabCardCaptorWnd _Inst()
{
	return AdenLabCardCaptorWnd(GetScript("AdenLabCardCaptorWnd"));
}

function SetSelect(int Index)
{
	GetTextureHandle((GetCardpathSmall(Index) $ ".CardFront_Tex")).HideWindow();
	return;
}

function string GetCardpathSmall(int Index)
{
	return ((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AdenLabCaptorWndSmall.ScrollArea.itemRenderer") $ Class'InterfaceClassic.UICommonAPI'.static.getInstanceUIData().Int2Str(Index));
}

function string GetCardPathBig(int Index)
{
	return ((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AdenLabCaptorWndBig.ScrollArea.itemRenderer") $ Class'InterfaceClassic.UICommonAPI'.static.getInstanceUIData().Int2Str(Index));
}

function _InitCardSelectData(CardSelectData Data)
{
	InitNeedItemMultiItems02();
	InitNeedItemSelectMultiItemsPopup();
	return;
}

function _InitFeeItems(CardSelectData Data)
{
	local int i;

	lowFeeDailyCountMax = Data.LowFeeDailyCount;
	highFeeDailyCountMax = Data.HighFeeDailyCount;
	multiNeedItemsScr._Clear();
	lowFeeDailyFees.Length = 0;
	highFeeDailyFees.Length = 0;
	i = 0;
	while((i < Data.FeeArray.Length))
	{
		switch(Data.FeeArray[i].FeeType)
		{
			case FEE_NORMALLOW:
				lowFeeDailyFees[lowFeeDailyFees.Length] = Data.FeeArray[i].FeeItem;
				break;
			case FEE_NORMALHIGH:
				highFeeDailyFees[highFeeDailyFees.Length] = Data.FeeArray[i].FeeItem;
				break;
			default:
				break;
		}
		i++;
	}
	needItemMultiItems02Scr.SetNumItem(INT64(1));
	needItemMultiItems02Scr.SetNumNeed(INT64(Data.LowFeeAdena));
	return;
}

function SetTextRemainNumText()
{
	local TextBoxHandle remainTextBoxhandle, stepTextBoxHandle;

	remainTextBoxhandle = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CardCaptorWndDescWnd.NeedItem_Wnd.FeeRemainText"));
	stepTextBoxHandle = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CardCaptorWndDescWnd.NeedItem_Wnd.FeeStepText"));
	remainTextBoxhandle.HideWindow();
	stepTextBoxHandle.HideWindow();
	return;
	if(bSale)
	{
		remainTextBoxhandle.ShowWindow();
		remainTextBoxhandle.SetText(((string((lowFeeDailyCountMax - normalGameSaleDailyCount)) $ "/") $ string(lowFeeDailyCountMax)));
		stepTextBoxHandle.SetText(("1" @ GetSystemString(14680)));
	}
	else
	{
		stepTextBoxHandle.SetText(("2" @ GetSystemString(14680)));
		remainTextBoxhandle.SetText(((string((highFeeDailyCountMax - normalGameDailyCount)) $ "/") $ string(highFeeDailyCountMax)));
		if((highFeeDailyCountMax == -1))
		{
			remainTextBoxhandle.HideWindow();
		}
		else
		{
			remainTextBoxhandle.ShowWindow();
		}
	}
	return;
}

function InitRowFeeDailyFees()
{
	bSale = true;
	InitFeeDailyFees(lowFeeDailyFees);
	return;
}

function InitHighFeeDailyFees()
{
	bSale = false;
	InitFeeDailyFees(highFeeDailyFees);
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

function InitNeedItemSelectMultiItemsPopup()
{
	local WindowHandle wnd;

	wnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".NeedItem_wnd.NeedItemMultiItems"));
	multiNeedItemsScr = Class'InterfaceClassic.UIControlNeedItemSelectMultiItems'.static._InitScript(wnd);
	multiNeedItemsScr._ConnectPopup(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".NeedItem_wnd.UIControlNeedItemSelectMultiItemPopup")));
	return;
}

function InitNeedItemMultiItems02()
{
	local WindowHandle needItemWnd;

	needItemWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".NeedItem_wnd.needItemMultiItems02"));
	needItemWnd.SetScript("UIControlNeedItem");
	needItemMultiItems02Scr = UIControlNeedItem(needItemWnd.GetScript());
	needItemMultiItems02Scr.Init((m_hOwnerWnd.m_WindowNameWithFullPath $ ".NeedItem_wnd.needItemMultiItems02"));
	needItemMultiItems02Scr.setId(GetItemID(57));
	return;
}

function InitWindowHandles()
{
	AdenLabCaptorWndBig = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AdenLabCaptorWndBig"));
	AdenLabCaptorWndSmall = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AdenLabCaptorWndSmall"));
	disableWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".disableWnd"));
	Ok_Btn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd.Ok_btn"));
	CardCaptorDesc01_txt = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CardCaptorWndDescWnd.CardCaptorDesc01_txt"));
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".NeedItem_wnd.Help_btn")).HideWindow();
	return;
}

function InitUIControlDialogAsset()
{
	local WindowHandle poopExpandWnd;

	poopExpandWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CardCaptorWndDescWnd.disableWnd.UIControlDialogAsset"));
	uicontrolDialogAssetScr = Class'InterfaceClassic.UIControlDialogAssets'.static.InitScript(poopExpandWnd);
	uicontrolDialogAssetScr.DelegateOnClickBuy = HandleDialogOK;
	uicontrolDialogAssetScr.DelegateOnCancel = HandleDialogCancel;
	uicontrolDialogAssetScr.SetUseBuyItem(false);
	uicontrolDialogAssetScr.SetUseNeedItem(true);
	uicontrolDialogAssetScr.SetUseNumberInput(false);
	uicontrolDialogAssetScr.StartNeedItemList(2);
	uicontrolDialogAssetScr.SetDialogDesc(GetSystemMessage(13972));
	return;
}

function InitTweensObject()
{
	l2UITweenScript = L2UITween(GetScript("l2UITween"));
	tObject = new Class'InterfaceClassic.L2UITweenObject';
	tObject.Owner = m_hOwnerWnd.m_WindowNameWithFullPath;
	tObject.Target = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".disableWnd.SuccessCard"));
	tObject.Target.SetAlpha(0);
	tObject.Duration = 500.0000000;
	tObject.Alpha = 255.0000000;
	tObject.ease = IN_STRONG;
	tObject._DelegateOnPlayStart = HandleDelegateOnStart;
	tObject._DelegateOnEnd = HandleDelegateOnEnd;
	return;
}

function InitTimerObject()
{
	shakeTimerObject = Class'InterfaceClassic.L2UITimer'.static.Inst()._MakeTimerObject(1, -1);
	shakeTimerObject._DelegateOnTime = DelegateOnTimer;
	shakeTimerObject._DelegateOnPlayStart = DelegateOnPlayStart;
	GetLocalPosition(tObject.Target, StartX, StartY);
	_RequestedRefreshTObject = Class'InterfaceClassic.L2UITimer'.static.Inst()._MakeTimerObject(5000);
	_RequestedRefreshTObject._DelegateOnEnd = RequestedRelease;
	_RequestedRefreshTObject._Stop();
	return;
}

function DelegateOnPlayStart()
{
	lastAppMilliSeconds = GetAppMilliSeconds();
	return;
}

function DelegateOnTimer(int Count)
{
	tObject.Target.MoveC(StartX, int(((float(StartY) + (Sin((float((GetAppMilliSeconds() - lastAppMilliSeconds)) / 300.0000000)) * 10.0000000)) + -10.0000000)));
	return;
}

function HandleDelegateOnStart(L2UITweenObject to)
{
	disableWnd.ShowWindow();
	GetEffectViewportWndHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".disableWnd.EffectViewport00")).SpawnEffect("LineageEffect2.ui_adenlab_normal_success");
	return;
}

function HandleDelegateOnEnd(L2UITweenObject to)
{
	shakeTimerObject._Play();
	return;
}

function InitCards()
{
	local int i;

	cardSmalls.Length = 36;
	i = 0;
	while((i < 36))
	{
		cardSmalls[i] = Class'InterfaceClassic.AdenLabCard'.static._InitScript(GetWindowHandle(GetCardpathSmall(i)));
		i++;
	}
	cards.Length = 10;
	i = 0;
	while((i < 10))
	{
		cards[i] = Class'InterfaceClassic.AdenLabCard'.static._InitScript(GetWindowHandle(GetCardPathBig(i)));
		i++;
	}
	return;
}

function SetCardNum(int Num)
{
	if((Num < 0))
	{
		return;
	}
	if((Num > 36))
	{
		return;
	}
	cardNum = Num;
	if((cardNum == 0))
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Prev_Btn")).DisableWindow();
	}
	else
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Prev_Btn")).EnableWindow();
	}
	if((cardNum == 36))
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Next_Btn")).DisableWindow();
	}
	else
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Next_Btn")).EnableWindow();
	}
	SetLayoutCards(Num);
	Reset();
	return;
}

function SetLayoutCards(int Num)
{
	local int rowNum, colNum, lastEmptyColNum, i;

	if((Num > 10))
	{
		GetCardXYSmall(rowNum, colNum);
		lastEmptyColNum = ((colNum * rowNum) - cardNum);
		AdenLabCaptorWndBig.HideWindow();
		GetWindowHandle((AdenLabCaptorWndSmall.m_WindowNameWithFullPath $ ".ScrollArea")).SetWindowSize((106 * colNum), ((136 * rowNum) + 60));
		AdenLabCaptorWndSmall.ShowWindow();
		i = 0;
		while((i < cardNum))
		{
			cardSmalls[i]._SetTargetXYByRowCol(rowNum, colNum, lastEmptyColNum, 106, 136);
			i++;
		}
	}
	else
	{
		GetCardXYBig(rowNum, colNum);
		lastEmptyColNum = ((colNum * rowNum) - cardNum);
		AdenLabCaptorWndSmall.HideWindow();
		GetWindowHandle((AdenLabCaptorWndBig.m_WindowNameWithFullPath $ ".ScrollArea")).SetWindowSize((168 * colNum), ((218 * rowNum) + 60));
		AdenLabCaptorWndBig.ShowWindow();
		i = 0;
		while((i < cardNum))
		{
			cards[i]._SetTargetXYByRowCol(rowNum, colNum, lastEmptyColNum, 168, 218);
			i++;
		}
	}
	return;
}

function GetCardXYBig(out int rowNum, out int colNum)
{
	local int colNumMax, colNumCurrent;
	local float magnification;

	magnification = (5.0000000 / 2.0000000);
	rowNum = 1;
	while((rowNum <= 2))
	{
		colNumCurrent = appCeil((float(cardNum) / float(rowNum)));
		colNumMax = int((magnification * float(rowNum)));
		if((colNumCurrent <= colNumMax))
		{
			colNum = colNumCurrent;
			return;
		}
		rowNum++;
	}
	rowNum = 2;
	colNum = 5;
	return;
}

function GetCardXYSmall(out int rowNum, out int colNum)
{
	local int colNumMax, colNumCurrent;
	local float magnification;

	magnification = (9.0000000 / 4.0000000);
	rowNum = 2;
	while((rowNum <= 4))
	{
		colNumCurrent = appCeil((float(cardNum) / float(rowNum)));
		colNumMax = int((magnification * float(rowNum)));
		if((colNumCurrent <= colNumMax))
		{
			colNum = colNumCurrent;
			return;
		}
		rowNum++;
	}
	rowNum = 4;
	colNum = 9;
	return;
}

function _SetRemainTryDailyCount(int nNormalGameSaleDailyCount, int nNormalGameDailyCount)
{
	normalGameSaleDailyCount = nNormalGameSaleDailyCount;
	normalGameDailyCount = nNormalGameDailyCount;
	return;
}

function bool _HandleOnCardButtonUP(AdenLabCard cardScr)
{
	if(bRequested)
	{
		return false;
	}
	if(bSuccess)
	{
		return false;
	}
	if((multiNeedItemsScr._GetMyClassID() == -1))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemString(14054));
		multiNeedItemsScr._ShakeMultiItemsPopup();
		return false;
	}
	currentCardScr = cardScr;
	currentCardScr._SetResultState(true);
	uicontrolDialogAssetScr.AddNeedItemClassID(multiNeedItemsScr._GetMyClassID(), multiNeedItemsScr._GetMyAmount());
	uicontrolDialogAssetScr.AddNeedItemClassID(needItemMultiItems02Scr.GetID().ClassID, needItemMultiItems02Scr.numNeed);
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".disableWnd.SuccessCard")).HideWindow();
	GetEffectViewportWndHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".disableWnd.EffectViewport00")).SpawnEffect("");
	disableWnd.ShowWindow();
	Ok_Btn.HideWindow();
	uicontrolDialogAssetScr.SetItemNum(1);
	uicontrolDialogAssetScr.Show();
	return true;
}

function HandleDialogOK()
{
	uicontrolDialogAssetScr.Hide();
	disableWnd.HideWindow();
	Ok_Btn.ShowWindow();
	if(Class'InterfaceClassic.AdenLabWnd'.static._Inst()._GetUseLocal())
	{
		RQ_C_EX_ADENLAB_NORMAL_PLAY_Local();
	}
	else
	{
		RQ_C_EX_ADENLAB_NORMAL_PLAY(multiNeedItemsScr._GetSelectedIndexPopup());
	}
	return;
}

function HandleDialogCancel()
{
	uicontrolDialogAssetScr.Hide();
	disableWnd.HideWindow();
	Ok_Btn.ShowWindow();
	currentCardScr._SetResultState(false);
	return;
}

function SetSuccess()
{
	local int GlobalX, GlobalY;

	PlaySound("InterfaceSound.AdenLab_StatCard_Success");
	if(!m_hOwnerWnd.IsShowWindow())
	{
		Class'InterfaceClassic.AdenLabWnd'.static._Inst()._SetSuccess();
		return;
	}
	currentCardScr._SetSuccessTween();
	tObject.Delay = 500.0000000;
	Local2Global(tObject.Target.GetParentWindowHandle(), StartX, StartY, GlobalX, GlobalY);
	tObject.Target.MoveTo(GlobalX, GlobalY);
	tObject.Target.SetAlpha(0);
	tObject.Target.ShowWindow();
	tObject._Reset();
	SetCardCaptorDesc(GetSystemString(14627));
	bSuccess = true;
	return;
}

function SetFail()
{
	if(!m_hOwnerWnd.IsShowWindow())
	{
		return;
	}
	currentCardScr._SetFailTween();
	SetCardCaptorDesc(GetSystemString(14626));
	return;
}

function int _GetCardNum()
{
	return cardNum;
}

function _TryShowNormalGame(int nStageIndex, int nBossID)
{
	BossID = nBossID;
	stageIndex = nStageIndex;
	if(Class'InterfaceClassic.AdenLabWnd'.static._Inst()._GetUseLocal())
	{
		RQ_C_EX_ADENLAB_NORMAL_SLOT_Local();
	}
	else
	{
		RQ_C_EX_ADENLAB_NORMAL_SLOT();
	}
	return;
}

function OpenNormalGame()
{
	SetCardNum(remainCardNum);
	SetRemainCardNumText();
	SetStageNameText();
	SetFeeDailys();
	SetTextRemainNumText();
	m_hOwnerWnd.ShowWindow();
	SetCardCaptorDesc(MakeFullSystemMsg(GetSystemMessage(13971), Class'InterfaceClassic.UIData'.static.Inst()._GetAdenLabBossName(BossID)));
	return;
}

function SetCardCaptorDesc(string Str)
{
	CardCaptorDesc01_txt.SetText(Str);
	return;
}

function SetFeeDailys()
{
	if((multiNeedItemsScr._GetMyClassID() == -1))
	{
		if((normalGameSaleDailyCount != lowFeeDailyCountMax))
		{
			InitRowFeeDailyFees();
		}
		else
		{
			InitHighFeeDailyFees();
		}
	}
	else if((bSale && (normalGameSaleDailyCount != lowFeeDailyCountMax)))
	{
		InitHighFeeDailyFees();
	}
	return;
}

function FeeSaleChanged()
{
	local bool bChanged;

	if(bSale)
	{
		normalGameSaleDailyCount++;
		bChanged = (normalGameSaleDailyCount == lowFeeDailyCountMax);
	}
	else
	{
		normalGameSaleDailyCount++;
	}
	if(bChanged)
	{
		InitHighFeeDailyFees();
	}
	SetTextRemainNumText();
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(1151));
	RegisterEvent(EV_PacketID(1152));
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_PacketID(1151):
			RT_S_EX_ADENLAB_NORMAL_SLOT();
			break;
		case EV_PacketID(1152):
			RT_S_EX_ADENLAB_NORMAL_PLAY();
			break;
		default:
			break;
	}
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	InitCards();
	InitWindowHandles();
	InitUIControlDialogAsset();
	InitTweensObject();
	InitTimerObject();
	return;
}

event OnClickButton(string btnName)
{
	switch(btnName)
	{
		case "CardCaptorBack_btn":
			OnReceivedCloseUI();
			break;
		case "Prev_Btn":
			SetCardNum((cardNum - 1));
			break;
		case "Next_Btn":
			SetCardNum((cardNum + 1));
			break;
		case "OK_Btn":
			OnReceivedCloseUI();
			break;
		default:
			break;
	}
	return;
}

event OnShow()
{
	PlaySound("InterfaceSound.AdenLab_StatCard_IN");
	m_hOwnerWnd.SetFocus();
	m_hOwnerWnd.SetAnchor("AdenLabWnd", "BottomCenter", "BottomCenter", 0, 6);
	Reset();
	return;
}

event OnMouseOver(WindowHandle a_WindowHandle)
{
	if((a_WindowHandle.GetWindowName() == "Help_btn"))
	{
		ShowMultiStep(a_WindowHandle);
	}
	return;
}

function ShowMultiStep(WindowHandle a_WindowHandle)
{
	local UIControlNeedItemSelectMultiItemsPopupTable popupTable;

	popupTable = Class'InterfaceClassic.UIControlNeedItemSelectMultiItemsPopupTable'.static._Inst();
	popupTable._Clear();
	popupTable._AddStep(lowFeeDailyFees, lowFeeDailyCountMax);
	popupTable._ShowWithOwner(a_WindowHandle);
	return;
}

event OnMouseOut(WindowHandle a_WindowHandle)
{
	if((a_WindowHandle.GetWindowName() == "Help_btn"))
	{
		Class'InterfaceClassic.UIControlNeedItemSelectMultiItemsPopupTable'.static._Inst()._Hide();
	}
	return;
}

function Reset()
{
	local int i;

	bSuccess = false;
	if((cardNum > 10))
	{
		i = 0;
		while((i < cardSmalls.Length))
		{
			cardSmalls[i]._Reset();
			i++;
		}
	}
	else
	{
		i = 0;
		while((i < cards.Length))
		{
			cards[i]._Reset();
			i++;
		}
	}
	tObject._Stop();
	disableWnd.HideWindow();
	return;
}

function SetCardQuility(int quility)
{
	local int i;
	local string cardImgTexture, cardFlipAniTexture, gradeTextureString;
	local Color C;

	C = GetGradeColor(quility);
	gradeTextureString = GetGradeTextureString(quility);
	cardFlipAniTexture = (("L2UI_NewTex.AdenLabWNd.CardFlip" $ gradeTextureString) $ "Ani00");
	if((cardNum > 10))
	{
		cardImgTexture = ("L2UI_NewTex.AdenLabWNd.CardSmall" $ gradeTextureString);
		i = 0;
		while((i < cardSmalls.Length))
		{
			cardSmalls[i]._SetCardTextures(cardImgTexture, cardFlipAniTexture, C);
			i++;
		}
	}
	else
	{
		cardImgTexture = ("L2UI_NewTex.AdenLabWNd.CardBig" $ gradeTextureString);
		i = 0;
		while((i < cards.Length))
		{
			cards[i]._SetCardTextures(cardImgTexture, cardFlipAniTexture, C);
			i++;
		}
	}
	return;
}

function Color GetGradeColor(int Grade)
{
	switch(Grade)
	{
		case 1:
			return GetColor(150, 140, 130, 255);
		default:
			return GetColor(255, 255, 255, 255);
	}
}

function string GetGradeTextureString(int Grade)
{
	switch(Grade)
	{
		case 1:
			return "Copper";
		case 2:
			return "Silver";
		case 3:
			return "Gold";
		default:
			return "Copper";
	}
}

event OnHide()
{
	CheckOnHideSuccess();
	return;
}

function CheckOnHideSuccess()
{
	if((bSuccess == false))
	{
		return;
	}
	Class'InterfaceClassic.AdenLabWnd'.static._Inst()._SetSuccess();
	FeeSaleChanged();
	return;
}

event OnSetFocus(WindowHandle a_WindowHandle, bool bFocused)
{
	if((bFocused == false))
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

event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	m_hOwnerWnd.HideWindow();
	return;
}

function RQ_C_EX_ADENLAB_NORMAL_SLOT_Local()
{
	local CardSelectNormalStage normalStageData;

	API_GetNormalStageData(normalStageData);
	remainCardNum = normalStageData.CardCount;
	OpenNormalGame();
	return;
}

function RQ_C_EX_ADENLAB_NORMAL_SLOT()
{
	local array<byte> stream;
	local UIPacket._C_EX_ADENLAB_NORMAL_SLOT packet;

	if(!SetRequestLock())
	{
		return;
	}
	packet.nBossID = BossID;
	packet.nSlotID = Class'InterfaceClassic.AdenLabWnd'.static._Inst()._GetnCurrentSlot();
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_ADENLAB_NORMAL_SLOT(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(884, stream);
	return;
}

function RT_S_EX_ADENLAB_NORMAL_SLOT()
{
	local UIPacket._S_EX_ADENLAB_NORMAL_SLOT packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_ADENLAB_NORMAL_SLOT(packet))
	{
		return;
	}
	remainCardNum = packet.nRemainCard;
	OpenNormalGame();
	RequestedRelease();
	return;
}

function RQ_C_EX_ADENLAB_NORMAL_PLAY_Local()
{
	remainCardNum--;
	SetRemainCardNumText();
	if((Rand(remainCardNum) == 0))
	{
		handleResult(1);
	}
	else
	{
		handleResult(0);
	}
	return;
}

function RQ_C_EX_ADENLAB_NORMAL_PLAY(int feeIndex)
{
	local array<byte> stream;
	local UIPacket._C_EX_ADENLAB_NORMAL_PLAY packet;

	if((SetRequestLock() == false))
	{
		return;
	}
	if(bSuccess)
	{
		return;
	}
	packet.nBossID = BossID;
	packet.nSlotID = Class'InterfaceClassic.AdenLabWnd'.static._Inst()._GetnCurrentSlot();
	packet.nFeeIndex = feeIndex;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_ADENLAB_NORMAL_PLAY(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(885, stream);
	return;
}

function RT_S_EX_ADENLAB_NORMAL_PLAY()
{
	local UIPacket._S_EX_ADENLAB_NORMAL_PLAY packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_ADENLAB_NORMAL_PLAY(packet))
	{
		return;
	}
	RequestedRelease();
	remainCardNum--;
	handleResult(packet.cSuccess);
	return;
}

function handleResult(int nSuccess)
{
	switch(nSuccess)
	{
		case 0:
			SetFail();
			FeeSaleChanged();
			SetRemainCardNumText();
			break;
		case 1:
			SetSuccess();
			break;
		case -1:
			currentCardScr._SetResultState(false);
			break;
		default:
			break;
	}
	return;
}

function SetStageNameText()
{
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CardCaptorWndDescWnd.CardCaptorDesc02_txt")).SetText(GetStageName());
	return;
}

function SetRemainCardNumText()
{
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CardCaptorWndDescWnd.CardCaptorDesc03_txt")).SetText(((GetSystemString(13938) $ ": 1/") $ string(remainCardNum)));
	return;
}

function string GetStageName()
{
	local CardSelectNormalStage normalStageData;
	local ExOptionData optionData;
	local int OptionID;

	API_GetNormalStageData(normalStageData);
	OptionID = normalStageData.ExOptionKey.Id;
	API_GetExOptionData(OptionID, 1, optionData);
	SetCardQuility(normalStageData.CardQuality);
	return optionData.Desc;
}

function API_GetNormalStageData(out CardSelectNormalStage Data)
{
	Class'NWindow.UIDataManager'.static.GetNormalStageData(stageIndex, Data);
	return;
}

function API_GetExOptionData(int OptionID, int lv, out ExOptionData Data)
{
	Class'NWindow.UIDataManager'.static.GetExOptionData(OptionID, byte(lv), Data);
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
	_RequestedRefreshTObject._Reset();
	return true;
}

function bool _IsRequested()
{
	return bRequested;
}
