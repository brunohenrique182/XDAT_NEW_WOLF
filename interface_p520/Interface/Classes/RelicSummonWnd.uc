class RelicSummonWnd extends UICommonAPI
	dependson(UIPacket);

struct cardStruct
{
	var int Grade;
	var int ClassID;
	var INT64 ItemNum;
	var bool bOpenCard;
};

var array<cardStruct> sortedCardArray;
var array<cardStruct> historyAutoOpenCardArray;
var WindowHandle Me;
var WindowHandle GetItem_wnd;
var RichListCtrlHandle GetItem_ListCtrl;
var UIControlNeedItemList GetItemListCtrl;
var WindowHandle AutoSummonHistory_wnd;
var RichListCtrlHandle AutoSummonHistoryList;
var WindowHandle UIControlDialogAsset;
var TextureHandle disable_tex;
var WindowHandle AutoSummon_wnd;
var ButtonHandle AutoSummonCancle_btn;
var ButtonHandle AutoSummonHistory_btn;
var ButtonHandle Ok_Btn;
var ButtonHandle TicketBuy_btn;
var TextBoxHandle Desc_txt;
var TextBoxHandle AutoSummonDesc_txt;
var bool isCardMotion;
var int currentCosumeItemClassID;
var bool bIsAutoCardOpen;
var bool bIsAutoCardOpenCancelProcess;
var bool bIsCombinationMode;
var bool bAutoSummonMaxNumberType;
var int nCurrentSummonID;
var int nCurrentSummonCount;
var int nCurrentSummonCountMAX;
var int nCurrentSummonCommisionID;
var INT64 nCurrentSummonCommisionAmount;
var string nCurrentSummonPointName;
var RichListCtrlHandle CosumeItem_ListCtrl;
var UIControlNeedItemList CosumeItemListCtrl;
var int currentGameCardNum;
var INT64 failItemNum;
//var delegate<SortByCard> __SortByCard__Delegate;

function OnRegisterEvent()
{
	RegisterEvent((100000 + 1115));
	RegisterEvent((100000 + 1120));
	RegisterEvent(12);
	return;
}

function OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	Me.SetFocus();
	return;
}

function OnHide()
{
	local int i;

	i = 1;
	while((i <= 11))
	{
		TweenStop(i);
		i++;
	}
	showDisable(false);
	hideAllButton();
	AutoSummonHistory_wnd.HideWindow();
	bIsAutoCardOpen = false;
	bIsAutoCardOpenCancelProcess = false;
	bIsCombinationMode = false;
	bAutoSummonMaxNumberType = false;
	historyAutoOpenCardArray.Length = 0;
	sortedCardArray.Length = 0;
	GetItem_wnd.HideWindow();
	showHideAutoSummonNum(false);
	API_C_EX_RELICS_SUMMON_CLOSE_UI();
	if(bIsCombinationMode)
	{
		API_C_EX_RELICS_COMBINATION_COMPLETE();
	}
	Class'Interface.RelicWnd'.static.Inst().CheckAndShowVisible();
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	initUIControlNeedItemList();
	SetPopupScript();
	return;
}

function Initialize()
{
	Me = GetMeWindow();
	AutoSummonHistory_wnd = GetWindowHandle("RelicAutoSummonHistory");
	AutoSummonHistoryList = GetRichListCtrlHandle("RelicAutoSummonHistory.AutoSummonHistory_wnd.AutoSummonHistoryList");
	UIControlDialogAsset = GetMeWindow("UIControlDialogAsset");
	disable_tex = GetMeTexture("disable_tex");
	CosumeItem_ListCtrl = GetMeRichListCtrl("ConsumeItem_wnd.CosumeItem_ListCtrl");
	Desc_txt = GetMeTextBox("Desc_txt");
	AutoSummonDesc_txt = GetMeTextBox("AutoSummon_wnd.AutoSummonDesc_txt");
	AutoSummonCancle_btn = GetMeButton("AutoSummonCancle_btn");
	AutoSummonHistory_btn = GetMeButton("AutoSummonHistory_btn");
	TicketBuy_btn = GetMeButton("TicketBuy_btn");
	Ok_Btn = GetMeButton("Ok_btn");
	GetItem_wnd = GetMeWindow("GetItem_wnd");
	GetItem_ListCtrl = GetMeRichListCtrl("GetItem_wnd.GetItem_ListCtrl");
	AutoSummon_wnd = GetMeWindow("AutoSummon_wnd");
	AutoSummonHistoryList.SetSelectedSelTooltip(false);
	AutoSummonHistoryList.SetAppearTooltipAtMouseX(true);
	AutoSummonHistoryList.SetSelectable(false);
	GetItem_ListCtrl.SetSelectedSelTooltip(false);
	GetItem_ListCtrl.SetAppearTooltipAtMouseX(true);
	GetItem_ListCtrl.SetSelectable(false);
	disable_tex.HideWindow();
	GetItem_wnd.HideWindow();
	hideAllButton();
	showHideAutoSummonNum(false);
	return;
}

function setPlacedCardBack(int NumCards)
{
	local int i, CardWidth, CardHeight, Gap, XOffset, YOffset, NumCardsInRow, NumRows, Row, Col, Index, addX, addY;
	local WindowHandle cardWnd;

	if((bIsAutoCardOpen || bIsAutoCardOpenCancelProcess))
	{
		// sortedCardArray.Sort(SortByCard);   // array.Sort() unsupported by this compiler
	}
	CardWidth = 90;
	CardHeight = 135;
	Gap = 40;
	isCardMotion = true;
	i = 1;
	while((i <= 11))
	{
		GetMeWindow(("CardSlot_" $ fillZeroString(2, string(i)))).MoveC(0, 0);
		GetMeWindow(("CardSlot_" $ fillZeroString(2, string(i)))).HideWindow();
		if(bIsCombinationMode)
		{
			GetMeButton((("CardSlot_" $ fillZeroString(2, string(i))) $ ".Card_btn")).HideWindow();
		}
		else
		{
			GetMeButton((("CardSlot_" $ fillZeroString(2, string(i))) $ ".Card_btn")).ShowWindow();
		}
		GetMeAnimTexture((("CardSlot_" $ fillZeroString(2, string(i))) $ ".CardOpen01_ani")).HideWindow();
		GetMeAnimTexture((("CardSlot_" $ fillZeroString(2, string(i))) $ ".CardEdgeEffect_ani")).HideWindow();
		GetMeAnimTexture((("CardSlot_" $ fillZeroString(2, string(i))) $ ".CardAppear_ani")).HideWindow();
		GetMeTexture((("CardSlot_" $ fillZeroString(2, string(i))) $ ".CardBack_tex")).ShowWindow();
		GetMeTexture((("CardSlot_" $ fillZeroString(2, string(i))) $ ".Card_tex")).HideWindow();
		GetMeItemWindow((("CardSlot_" $ fillZeroString(2, string(i))) $ ".ItemWindow")).HideWindow();
		GetMeItemWindow((("CardSlot_" $ fillZeroString(2, string(i))) $ ".ItemWindow")).Clear();
		GetMeButton((("CardSlot_" $ fillZeroString(2, string(i))) $ ".CardOpenTooltip_btn")).ClearTooltip();
		GetMeButton((("CardSlot_" $ fillZeroString(2, string(i))) $ ".CardOpenTooltip_btn")).HideWindow();
		i++;
	}
	if((NumCards <= 5))
	{
		NumCardsInRow = NumCards;
		NumRows = 1;
		addY = 20;
	}
	else if((NumCards == 6))
	{
		NumCardsInRow = 3;
		NumRows = 2;
	}
	else if((NumCards == 7))
	{
		NumCardsInRow = 4;
		NumRows = 2;
	}
	else if((NumCards == 8))
	{
		NumCardsInRow = 4;
		NumRows = 2;
	}
	else if((NumCards == 9))
	{
		NumCardsInRow = 5;
		NumRows = 2;
	}
	else if((NumCards == 10))
	{
		NumCardsInRow = 5;
		NumRows = 2;
	}
	else if((NumCards == 11))
	{
		NumCardsInRow = 6;
		NumRows = 2;
	}
	XOffset = ((920 - ((NumCardsInRow * CardWidth) + ((NumCardsInRow - 1) * Gap))) / 2);
	YOffset = (addY + ((550 - ((NumRows * CardHeight) + ((NumRows - 1) * Gap))) / 2));
	Index = 1;
	Row = 0;
	while((Row < NumRows))
	{
		Col = 0;
		while(((Col < NumCardsInRow) && (Index <= NumCards)))
		{
			if(((Row == 1) && ((float(NumCards) % 2.0000000) != 0.0000000)))
			{
				addX = 50;
			}
			else
			{
				addX = 0;
			}
			cardWnd = GetMeWindow(("CardSlot_" $ fillZeroString(2, string(Index))));
			cardWnd.ClearAnchor();
			cardWnd.MoveC((((XOffset + (Col * (CardWidth + Gap))) + addX) - 35), ((YOffset + (Row * (CardHeight + Gap))) - 30));
			cardWnd.ShowWindow();
			cardWnd.SetAlpha(0);
			TweenAdd(cardWnd, 255, Index, 100, 0, 0, EASENONE, (float((Index - 1)) * 30.0000000));
			AnimTexturePlay(GetMeAnimTexture((("CardSlot_" $ fillZeroString(2, string(Index))) $ ".CardAppear_ani")), true, 1);
			if(isHighGradeRelics(sortedCardArray[(Index - 1)].Grade))
			{
				AnimTexturePlay(GetMeAnimTexture((("CardSlot_" $ fillZeroString(2, string(Index))) $ ".CardEdgeEffect_ani")), true, 999999999);
				GetMeTexture((("CardSlot_" $ fillZeroString(2, string(Index))) $ ".CardBack_tex")).SetTexture("L2UI_NewTex.RelicWnd.RelicSummonCardBack_ABC");
			}
			else
			{
				GetMeTexture((("CardSlot_" $ fillZeroString(2, string(Index))) $ ".CardBack_tex")).SetTexture("L2UI_NewTex.RelicWnd.RelicSummonCardBack_DN");
			}
			Index++;
			Col++;
		}
		Row++;
	}
	Desc_txt.HideWindow();
	return;
}

function cardStruct getCardStruct(int Grade, int RelicsID)
{
	local cardStruct cardStru;

	cardStru.Grade = Grade;
	cardStru.ClassID = getRelicsItemClassID(RelicsID);
	cardStru.ItemNum = INT64(1);
	return cardStru;
}

delegate int SortByCard(cardStruct A, cardStruct B)
{
	if((A.Grade < B.Grade))
	{
		return -1;
	}
	return 0;
}

function bool isAllHighGrade()
{
	local int i, nHighGradeCardNum, closeCardNum;

	i = 0;
	while((i < sortedCardArray.Length))
	{
		if((sortedCardArray[i].bOpenCard == false))
		{
			closeCardNum++;
			if(isHighGradeRelics(sortedCardArray[i].Grade))
			{
				nHighGradeCardNum++;
			}
		}
		i++;
	}
	if((nHighGradeCardNum >= closeCardNum))
	{
		return true;
	}
	return false;
}

function bool isAllCardOpen()
{
	local int i, openCardNum, closeCardNum;

	i = 1;
	while((i <= 11))
	{
		if(GetMeWindow(("CardSlot_" $ fillZeroString(2, string(i)))).IsShowWindow())
		{
			closeCardNum++;
			if(GetMeTexture((("CardSlot_" $ fillZeroString(2, string(i))) $ ".Card_tex")).IsShowWindow())
			{
				openCardNum++;
			}
		}
		i++;
	}
	if((openCardNum == closeCardNum))
	{
		return true;
	}
	return false;
}

function setCardFront(int Index)
{
	if(isCardMotion)
	{
		return;
	}
	if((GetMeWindow(("CardSlot_" $ fillZeroString(2, string(Index)))).IsShowWindow() == false))
	{
		return;
	}
	if(GetMeTexture((("CardSlot_" $ fillZeroString(2, string(Index))) $ ".CardBack_tex")).IsShowWindow())
	{
		GetMeTexture((("CardSlot_" $ fillZeroString(2, string(Index))) $ ".CardBack_tex")).HideWindow();
		GetMeTexture((("CardSlot_" $ fillZeroString(2, string(Index))) $ ".Card_tex")).ShowWindow();
		GetMeTexture((("CardSlot_" $ fillZeroString(2, string(Index))) $ ".Card_tex")).SetTexture(("L2UI_NewTex.RelicWnd.RelicSummonCard_" $ getGradeRelicsString(sortedCardArray[(Index - 1)].Grade)));
		GetMeButton((("CardSlot_" $ fillZeroString(2, string(Index))) $ ".CardOpenTooltip_btn")).ShowWindow();
		GetMeButton((("CardSlot_" $ fillZeroString(2, string(Index))) $ ".CardOpenTooltip_btn")).SetTooltipCustomType(MakeTooltipSimpleColorText(GetItemNameAllByClassID(sortedCardArray[(Index - 1)].ClassID), getInstanceL2Util().GetRelicTextColor(ERelicGrade(sortedCardArray[(Index - 1)].Grade))));
		GetMeButton((("CardSlot_" $ fillZeroString(2, string(Index))) $ ".Card_btn")).HideWindow();
		GetMeItemWindow((("CardSlot_" $ fillZeroString(2, string(Index))) $ ".ItemWindow")).ShowWindow();
		GetMeItemWindow((("CardSlot_" $ fillZeroString(2, string(Index))) $ ".ItemWindow")).Clear();
		GetMeItemWindow((("CardSlot_" $ fillZeroString(2, string(Index))) $ ".ItemWindow")).AddItem(GetItemInfoByClassID(sortedCardArray[(Index - 1)].ClassID));
		AnimTexturePlay(GetMeAnimTexture((("CardSlot_" $ fillZeroString(2, string(Index))) $ ".CardOpen01_ani")), true, 1);
		sortedCardArray[(Index - 1)].bOpenCard = true;
		if(isHighGradeRelics(sortedCardArray[(Index - 1)].Grade))
		{
			AnimTexturePlay(GetMeAnimTexture((("CardSlot_" $ fillZeroString(2, string(Index))) $ ".CardEdgeEffect_ani")), true, 999999999);
			GetMeEffectViewportWnd((("CardSlot_" $ fillZeroString(2, string(Index))) $ ".CardOpen02_EffectViewport")).SpawnEffect("LineageEffect2.ui_relic_card_high");
		}
		else
		{
			GetMeEffectViewportWnd((("CardSlot_" $ fillZeroString(2, string(Index))) $ ".CardOpen02_EffectViewport")).SpawnEffect("LineageEffect2.ui_relic_card_normal");
		}
	}
	if(isAllCardOpen())
	{
		Desc_txt.HideWindow();
		hideAllButton();
		if(bIsCombinationMode)
		{
			Ok_Btn.ShowWindow();
			if((failItemNum > INT64(0)))
			{
				GetItem_wnd.ShowWindow();
			}
			else
			{
				GetItem_wnd.HideWindow();
			}
		}
		else
		{
			if((bIsAutoCardOpen == false))
			{
				Desc_txt.ShowWindow();
				Desc_txt.SetText(GetSystemString(14488));
			}
			ShowAndCheckGameButton();
			AutoSummonHistory_btn.EnableWindow();
		}
	}
	else
	{
		if((bIsCombinationMode == false))
		{
			Desc_txt.ShowWindow();
		}
		GetMeButton("ConfirmAll_btn").ShowWindow();
		GetMeButton("ConfirmAll_btn").EnableWindow();
		Desc_txt.SetText(GetSystemString(14550));
	}
	return;
}

function ShowAndCheckGameButton()
{
	if(bAutoSummonMaxNumberType)
	{
		TicketBuy_btn.ShowWindow();
	}
	else
	{
		GetMeButton("AutoSummon_btn").ShowWindow();
		GetMeButton("Retry_btn").ShowWindow();
		if(CosumeItemListCtrl.GetCanBuy())
		{
			GetMeButton("AutoSummon_btn").EnableWindow();
			GetMeButton("Retry_btn").EnableWindow();
		}
		else
		{
			GetMeButton("AutoSummon_btn").DisableWindow();
			GetMeButton("Retry_btn").DisableWindow();
		}
	}
	return;
}

function hideAllButton()
{
	GetMeButton("AutoSummon_btn").HideWindow();
	GetMeButton("Retry_btn").HideWindow();
	GetMeButton("ConfirmAll_btn").HideWindow();
	AutoSummon_wnd.HideWindow();
	AutoSummonCancle_btn.HideWindow();
	Ok_Btn.HideWindow();
	TicketBuy_btn.HideWindow();
	return;
}

function openAllCard(bool bForceAllOpen)
{
	local int i;

	i = 0;
	while((i < sortedCardArray.Length))
	{
		if(((isHighGradeRelics(sortedCardArray[i].Grade) == false) || bForceAllOpen))
		{
			setCardFront((i + 1));
		}
		i++;
	}
	PlaySound("InterfaceSound.GachaJewel_Basic");
	return;
}

function showHideAutoSummonNum(bool bShow)
{
	if(bShow)
	{
		GetMeTextBox("AutoSummon_wnd.SummonNumSlash_txt").ShowWindow();
		GetMeTextBox("AutoSummon_wnd.SummonNum_txt").ShowWindow();
		GetMeTextBox("AutoSummon_wnd.SummonMaxNum_txt").ShowWindow();
		GetMeTextBox("AutoSummon_wnd.AutoSummonName_txt").ShowWindow();
	}
	else
	{
		GetMeTextBox("AutoSummon_wnd.SummonNumSlash_txt").HideWindow();
		GetMeTextBox("AutoSummon_wnd.SummonNum_txt").HideWindow();
		GetMeTextBox("AutoSummon_wnd.SummonMaxNum_txt").HideWindow();
		GetMeTextBox("AutoSummon_wnd.AutoSummonName_txt").HideWindow();
	}
	return;
}

function setAutoSummonNum()
{
	GetMeTextBox("AutoSummon_wnd.AutoSummonName_txt").SetText(nCurrentSummonPointName);
	GetMeTextBox("AutoSummon_wnd.SummonNum_txt").SetText(string(nCurrentSummonCount));
	GetMeTextBox("AutoSummon_wnd.SummonMaxNum_txt").SetText(string(nCurrentSummonCountMAX));
	return;
}

function OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	local int Index;

	if(bIsCombinationMode)
	{
		return;
	}
	if((a_ButtonHandle.GetWindowName() == "Card_btn"))
	{
		Index = int(Mid(a_ButtonHandle.GetParentWindowName(), 9, 2));
		setCardFront(Index);
		PlaySound("InterfaceSound.GachaJewel_DropB");
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "Close_Btn":
			OnClose_BtnClick();
			break;
		case "AutoSummonCancle_btn":
			OnAutoSummonCancle_btnClick();
			break;
		case "AutoSummonHistory_btn":
			OnAutoSummonHistory_btnClick();
			break;
		case "AutoSummon_btn":
			OnAutoSummon_btnClick();
			break;
		case "Retry_btn":
			OnRetry_btnClick();
			break;
		case "ConfirmAll_btn":
			OnConfirmAll_btnClick();
			break;
		case "Ok_btn":
			OnOk_BtnClick();
			break;
		case "TicketBuy_btn":
			Class'Interface.RelicWnd'.static.Inst().OpenWindow();
			break;
		default:
			break;
	}
	return;
}

function OnAutoSummonCancle_btnClick()
{
	bIsAutoCardOpen = false;
	bIsAutoCardOpenCancelProcess = true;
	AutoSummon_wnd.HideWindow();
	AutoSummonDesc_txt.HideWindow();
	AutoSummonCancle_btn.HideWindow();
	showHideAutoSummonNum(false);
	return;
}

function OnClose_BtnClick()
{
	AutoSummonHistory_wnd.HideWindow();
	return;
}

function OnAutoSummonHistory_btnClick()
{
	if(AutoSummonHistory_wnd.IsShowWindow())
	{
		AutoSummonHistory_wnd.HideWindow();
	}
	else
	{
		AutoSummonHistory_wnd.ShowWindow();
		updateAutoSummonHistoryList();
	}
	return;
}

function OnAutoSummon_btnClick()
{
	ShowPopupAutoSummon();
	GetMeButton("Retry_btn").DisableWindow();
	return;
}

function OnRetry_btnClick()
{
	bIsAutoCardOpen = false;
	bIsAutoCardOpenCancelProcess = false;
	hideAllButton();
	Desc_txt.HideWindow();
	AutoSummonHistory_btn.DisableWindow();
	AutoSummonHistory_wnd.HideWindow();
	API_C_EX_RELICS_SUMMON();
	return;
}

function OnConfirmAll_btnClick()
{
	if((isCardMotion == false))
	{
		if(bIsCombinationMode)
		{
			openAllCard(true);
			GetMeButton("ConfirmAll_btn").DisableWindow();
			API_C_EX_RELICS_COMBINATION_COMPLETE();
		}
		else
		{
			openAllCard(true);
			GetMeButton("ConfirmAll_btn").DisableWindow();
		}
	}
	return;
}

function OnOk_BtnClick()
{
	Me.HideWindow();
	Debug("유물 합성, 확인 버튼 클릭");  // EN?: Artifact synthesis, click OK button
	return;
}

function updateAutoSummonHistoryList()
{
	local int i, nGrade;
	local bool bTitlePrint;

	AutoSummonHistoryList.DeleteAllItem();
	nGrade = 5;
	while((nGrade > -1))
	{
		bTitlePrint = true;
		i = 0;
		while((i < historyAutoOpenCardArray.Length))
		{
			if((historyAutoOpenCardArray[i].Grade == nGrade))
			{
				if(bTitlePrint)
				{
					addRichListRowDataTitle(nGrade);
					bTitlePrint = false;
				}
				addRichListRowDataHistory(historyAutoOpenCardArray[i].ClassID, historyAutoOpenCardArray[i].ItemNum, historyAutoOpenCardArray[i].Grade);
			}
			i++;
		}
		nGrade--;
	}
	return;
}

function addRichListRowDataTitle(int nGradeType)
{
	local RichListCtrlRowData rowData;

	rowData.cellDataList.Length = 1;
	rowData.sOverlayTex = ("L2UI_NewTex.RelicWnd.ListHeaderBg_" $ getGradeRelicsString(nGradeType));
	rowData.OverlayTexU = 334;
	rowData.OverlayTexV = 42;
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, getGradeRelicsSystemString(nGradeType), GTColor().White, false, 8, 13);
	AutoSummonHistoryList.InsertRecord(rowData);
	return;
}

function addRichListRowDataHistory(int ClassID, INT64 nAmount, int nGrade)
{
	local RichListCtrlRowData rowData;
	local ItemInfo Info;

	rowData.cellDataList.Length = 1;
	Info = GetItemInfoByClassID(ClassID);
	Info.ItemNum = nAmount;
	AddRichListCtrlItem(rowData.cellDataList[0].drawitems, Info, 32, 32, 4, 4);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, GetItemNameAllByClassID(ClassID), getInstanceL2Util().GetRelicTextColor(ERelicGrade(nGrade)), false, 7, 11);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, ("x" $ MakeCostStringINT64(nAmount)), GTColor().White, false, 4, 0);
	AutoSummonHistoryList.InsertRecord(rowData);
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case (100000 + 1115):
			ParsePacket_S_EX_RELICS_SUMMON_RESULT();
			break;
		case (100000 + 1120):
			ParsePacket_S_EX_RELICS_COMBINATION();
			break;
		case 12:
			ParseString(param, "name", nCurrentSummonPointName);
			ParseInt(param, "summonID", nCurrentSummonID);
			ParseInt(param, "summonCount", nCurrentSummonCount);
			ParseInt(param, "commisionID", nCurrentSummonCommisionID);
			ParseINT64(param, "commisionAmount", nCurrentSummonCommisionAmount);
			External_AskSummonID(nCurrentSummonPointName, nCurrentSummonID, nCurrentSummonCount, nCurrentSummonCommisionID, nCurrentSummonCommisionAmount);
			break;
		default:
			break;
	}
	return;
}

function External_AskSummonID(string pointName, int SummonID, int SummonCount, int CommisionID, INT64 CommisionAmount)
{
	nCurrentSummonPointName = pointName;
	nCurrentSummonID = SummonID;
	nCurrentSummonCount = SummonCount;
	nCurrentSummonCountMAX = SummonCount;
	nCurrentSummonCommisionID = CommisionID;
	nCurrentSummonCommisionAmount = CommisionAmount;
	getInstanceL2Util().syncWindowLoc("RelicWnd", getCurrentWindowName(string(self)));
	ShowPopupAutosummonNum();
	return;
}

function ParsePacket_S_EX_RELICS_SUMMON_RESULT()
{
	local UIPacket._S_EX_RELICS_SUMMON_RESULT packet;
	local int i;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_RELICS_SUMMON_RESULT(packet))
	{
		return;
	}
	Debug(((("---> S_EX_RELICS_SUMMON_RESULT" @ string(packet.cResult)) @ string(packet.relicsList.Length)) @ string(packet.nItemID)));
	if(GetMeWindow("UIControlDialogAsset").IsShowWindow())
	{
		GetPopupExpandScript().Hide();
		showDisable(false);
		if(bAutoSummonMaxNumberType)
		{
			bAutoSummonMaxNumberType = false;
		}
	}
	if((packet.cResult == 2))
	{
		if((Me.IsShowWindow() == false))
		{
			return;
		}
		OnAutoSummonCancle_btnClick();
		GetMeButton("AutoSummon_btn").ShowWindow();
		GetMeButton("Retry_btn").ShowWindow();
		GetMeButton("AutoSummon_btn").DisableWindow();
		GetMeButton("Retry_btn").DisableWindow();
		AutoSummonHistory_btn.ShowWindow();
		AutoSummonHistory_btn.EnableWindow();
		Desc_txt.ShowWindow();
		Desc_txt.SetText(GetSystemMessage(13911));
	}
	else if((packet.cResult == 1))
	{
		Me.SetWindowTitle(GetSystemString(14484));
		bIsCombinationMode = false;
		Ok_Btn.HideWindow();
		AutoSummonHistory_btn.ShowWindow();
		GetMeWindow("ConsumeItem_wnd").ShowWindow();
		if((Me.IsShowWindow() == false))
		{
			Me.ShowWindow();
			Me.SetFocus();
			AutoSummonHistory_btn.DisableWindow();
		}
		if(bAutoSummonMaxNumberType)
		{
		}
		else
		{
			currentCosumeItemClassID = packet.nItemID;
		}
		Class'Interface.L2UITimer'.static.Inst()._AddTimerOnce(1)._DelegateOnEnd = cosumeItemUpdateAndCardSetting;
		sortedCardArray.Length = 0;
		i = 0;
		while((i < packet.relicsList.Length))
		{
			sortedCardArray[sortedCardArray.Length] = getCardStruct(getGradeRelics(packet.relicsList[i]), packet.relicsList[i]);
			sumHistoryAutoOpenCardArray(sortedCardArray[(sortedCardArray.Length - 1)]);
			i++;
		}
		if(AutoSummonHistory_wnd.IsShowWindow())
		{
			updateAutoSummonHistoryList();
		}
	}
	else if((packet.cResult == 0))
	{
		AddSystemMessage(4559);
		Me.HideWindow();
	}
	if(Class'Interface.RelicWnd'.static.Inst().IsShowAndVisible())
	{
		Class'Interface.RelicWnd'.static.Inst().CloseWindow();
	}
	return;
}

function sumHistoryAutoOpenCardArray(cardStruct A)
{
	local int i;
	local bool bSum;

	i = 0;
	while((i < historyAutoOpenCardArray.Length))
	{
		if((historyAutoOpenCardArray[i].ClassID == A.ClassID))
		{
			historyAutoOpenCardArray[i].ItemNum = (historyAutoOpenCardArray[i].ItemNum + INT64(1));
			bSum = true;
		}
		i++;
	}
	if((bSum == false))
	{
		historyAutoOpenCardArray[historyAutoOpenCardArray.Length] = A;
	}
	return;
}

function cosumeItemUpdateAndCardSetting()
{
	if(bAutoSummonMaxNumberType)
	{
		CosumeItemListCtrl.CleariObjects();
		CosumeItemListCtrl.AddNeedItemClassID(nCurrentSummonCommisionID, nCurrentSummonCommisionAmount);
		CosumeItemListCtrl.SetBuyNum(INT64(1));
	}
	else
	{
		CosumeItemListCtrl.CleariObjects();
		CosumeItemListCtrl.AddNeedItemClassID(currentCosumeItemClassID, INT64(1));
		CosumeItemListCtrl.SetBuyNum(INT64(1));
	}
	currentGameCardNum = sortedCardArray.Length;
	setPlacedCardBack(sortedCardArray.Length);
	return;
}

function ParsePacket_S_EX_RELICS_COMBINATION()
{
	local UIPacket._S_EX_RELICS_COMBINATION packet;
	local int i;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_RELICS_COMBINATION(packet))
	{
		return;
	}
	Debug(((("---> S_EX_RELICS_COMBINATION" @ string(packet.cResult)) @ string(packet.relicsList.Length)) @ string(packet.failItemList.Length)));
	if((packet.cResult > 0))
	{
		Me.SetWindowTitle(GetSystemString(14566));
		bIsCombinationMode = true;
		bIsAutoCardOpen = false;
		bIsAutoCardOpenCancelProcess = false;
		i = 1;
		while((i <= 11))
		{
			TweenStop(i);
			i++;
		}
		if(Me.IsShowWindow())
		{
			Me.SetFocus();
		}
		else
		{
			Me.ShowWindow();
			Me.SetFocus();
		}
		hideAllButton();
		Desc_txt.HideWindow();
		GetMeWindow("ConsumeItem_wnd").HideWindow();
		if(AutoSummonHistory_wnd.IsShowWindow())
		{
			AutoSummonHistory_wnd.HideWindow();
		}
		AutoSummonHistory_btn.HideWindow();
		historyAutoOpenCardArray.Length = 0;
		sortedCardArray.Length = 0;
		i = 0;
		while((i < packet.relicsList.Length))
		{
			sortedCardArray[sortedCardArray.Length] = getCardStruct(getGradeRelics(packet.relicsList[i]), packet.relicsList[i]);
			i++;
		}
		currentGameCardNum = sortedCardArray.Length;
		setPlacedCardBack(sortedCardArray.Length);
		GetItem_wnd.HideWindow();
		GetItemListCtrl.CleariObjects();
		if((packet.failItemList.Length > 0))
		{
			failItemNum = INT64(packet.failItemList.Length);
			i = 0;
			while((i < packet.failItemList.Length))
			{
				Debug(((("packet.failItemList" @ string(i)) @ string(packet.failItemList[i].nItemClassID)) @ string(packet.failItemList[i].nAmount)));
				GetItemListCtrl.AddNeedItemClassID(packet.failItemList[i].nItemClassID, packet.failItemList[i].nAmount);
				i++;
			}
			GetItemListCtrl.SetBuyNum(INT64(1));
		}
		else
		{
			failItemNum = INT64(0);
		}
		if(Class'Interface.RelicWnd'.static.Inst().Me.IsShowWindow())
		{
			getInstanceL2Util().syncWindowLoc("RelicWnd", getCurrentWindowName(string(self)));
		}
	}
	else
	{
		AddSystemMessage(4559);
		Me.HideWindow();
	}
	Class'Interface.RelicWnd'.static.Inst().CheckAndHideVisible();
	return;
}

function TweenAdd(WindowHandle targetWnd, int TargetAlpha, int Id, int Duration, int nX, int nY, L2UITween.easeType Type, optional float Delay)
{
	local L2UITween.TweenObject tweenObjectData;

	tweenObjectData.Owner = m_hOwnerWnd.m_WindowNameWithFullPath;
	tweenObjectData.Id = Id;
	tweenObjectData.Target = targetWnd;
	tweenObjectData.Duration = float(Duration);
	tweenObjectData.Alpha = float(TargetAlpha);
	tweenObjectData.ease = easeType(Type);
	tweenObjectData.MoveX = float(nX);
	tweenObjectData.MoveY = float(nY);
	tweenObjectData.Delay = Delay;
	TweenStop(Id);
	Class'Interface.L2UITween'.static.Inst().AddTweenObject(tweenObjectData);
	return;
}

function TweenStop(int Id)
{
	Class'Interface.L2UITween'.static.Inst().StopTween(m_hOwnerWnd.m_WindowNameWithFullPath, Id);
	return;
}

function OnCallUCFunction(string funcName, string param)
{
	switch(funcName)
	{
		case "tweenEnd":
			if((int(param) == currentGameCardNum))
			{
				isCardMotion = false;
				if(bIsAutoCardOpen)
				{
					openAllCard(true);
					if(bAutoSummonMaxNumberType)
					{
						if((CosumeItemListCtrl.GetCanBuy() && (nCurrentSummonCount > 0)))
						{
							Class'Interface.L2UITimer'.static.Inst()._AddTimerOnce(1000)._DelegateOnEnd = API_C_EX_RELICS_ID_SUMMON;
							hideAllButton();
							AutoSummon_wnd.ShowWindow();
							AutoSummonCancle_btn.ShowWindow();
							AutoSummonHistory_btn.DisableWindow();
						}
						else
						{
							bIsAutoCardOpen = false;
							hideAllButton();
							AutoSummon_wnd.ShowWindow();
							AutoSummonDesc_txt.ShowWindow();
							Desc_txt.ShowWindow();
							Desc_txt.SetText(GetSystemString(14488));
							AutoSummonDesc_txt.SetText(GetSystemString(14553));
							AutoSummonCancle_btn.HideWindow();
							AutoSummonHistory_btn.EnableWindow();
							showHideAutoSummonNum(false);
							ShowAndCheckGameButton();
						}
					}
					else if(CosumeItemListCtrl.GetCanBuy())
					{
						Class'Interface.L2UITimer'.static.Inst()._AddTimerOnce(1000)._DelegateOnEnd = API_C_EX_RELICS_SUMMON;
						hideAllButton();
						AutoSummon_wnd.ShowWindow();
						AutoSummonCancle_btn.ShowWindow();
						AutoSummonHistory_btn.DisableWindow();
					}
					else
					{
						bIsAutoCardOpen = false;
						hideAllButton();
						AutoSummon_wnd.ShowWindow();
						AutoSummonDesc_txt.ShowWindow();
						Desc_txt.ShowWindow();
						Desc_txt.SetText(GetSystemString(14488));
						AutoSummonDesc_txt.SetText(GetSystemString(14553));
						AutoSummonCancle_btn.HideWindow();
						AutoSummonHistory_btn.EnableWindow();
						ShowAndCheckGameButton();
					}
				}
				else if(bIsAutoCardOpenCancelProcess)
				{
					openAllCard(true);
					hideAllButton();
					AutoSummon_wnd.ShowWindow();
					AutoSummonDesc_txt.ShowWindow();
					Desc_txt.ShowWindow();
					Desc_txt.SetText(GetSystemString(14488));
					AutoSummonDesc_txt.SetText(GetSystemString(14553));
					AutoSummonCancle_btn.HideWindow();
					AutoSummonHistory_btn.EnableWindow();
					ShowAndCheckGameButton();
				}
				else
				{
					hideAllButton();
					if(bIsCombinationMode)
					{
						GetMeButton("ConfirmAll_btn").ShowWindow();
						GetMeButton("ConfirmAll_btn").EnableWindow();
						GetMeButton("ConfirmAll_btn").SetNameText(GetSystemString(14557));
						Desc_txt.ShowWindow();
						Desc_txt.SetText(GetSystemString(14558));
					}
					else
					{
						Desc_txt.ShowWindow();
						GetMeButton("ConfirmAll_btn").ShowWindow();
						GetMeButton("ConfirmAll_btn").SetNameText(GetSystemString(14485));
						AutoSummonHistory_btn.DisableWindow();
						GetMeButton("ConfirmAll_btn").EnableWindow();
						Desc_txt.SetText(GetSystemString(14550));
					}
				}
			}
			break;
		default:
			break;
	}
	return;
}

function initUIControlNeedItemList()
{
	CosumeItemListCtrl = new Class'Interface.UIControlNeedItemList';
	CosumeItemListCtrl.SetRichListControler(CosumeItem_ListCtrl);
	CosumeItemListCtrl.SetFormType(NORMALNEEDSMALLFONT);
	CosumeItemListCtrl.StartNeedItemList(1);
	GetItemListCtrl = new Class'Interface.UIControlNeedItemList';
	GetItemListCtrl.SetRichListControler(GetItem_ListCtrl);
	GetItemListCtrl.StartNeedItemList(1);
	GetItemListCtrl.SetHideMyNum(true);
	return;
}

function SetPopupScript()
{
	local WindowHandle popExpandWnd;
	local UIControlDialogAssets popupExpandScript;
	local WindowHandle disableWnd;

	popExpandWnd = GetMeWindow("UIControlDialogAsset");
	popupExpandScript = Class'Interface.UIControlDialogAssets'.static.InitScript(popExpandWnd);
	disableWnd = GetMeWindow("disable_tex");
	popupExpandScript.SetDisableWindow(disableWnd);
	Class'NWindow.UIAPI_WINDOW'.static.SetAlwaysOnTop((m_hOwnerWnd.m_WindowNameWithFullPath $ ".disable_tex"), false);
	popupExpandScript.SetNeedItemTitle_text(GetSystemString(14782));
	return;
}

function UIControlDialogAssets GetPopupExpandScript()
{
	local WindowHandle popExpandWnd;

	popExpandWnd = GetMeWindow("UIControlDialogAsset");
	return UIControlDialogAssets(popExpandWnd.GetScript());
}

function ShowPopupAutoSummon()
{
	local UIControlDialogAssets popupExpandScript;

	popupExpandScript = GetPopupExpandScript();
	popupExpandScript.SetDialogDesc(GetSystemString(14489));
	popupExpandScript.SetUseNeedItem(true);
	popupExpandScript.StartNeedItemList(1);
	popupExpandScript.AddNeedItemClassID(currentCosumeItemClassID, INT64(1));
	popupExpandScript.SetItemNum(1);
	popupExpandScript.Show();
	popupExpandScript.DelegateOnClickBuy = OnDialogOK;
	popupExpandScript.DelegateOnCancel = OnClickCancelDialog;
	showDisable(true);
	bAutoSummonMaxNumberType = false;
	return;
}

function ShowPopupAutosummonNum()
{
	local UIControlDialogAssets popupExpandScript;
	local int i;
	local string Desc;

	Me.ShowWindow();
	Desc_txt.HideWindow();
	AutoSummonHistory_btn.DisableWindow();
	hideAllButton();
	i = 1;
	while((i <= 11))
	{
		GetMeWindow(("CardSlot_" $ fillZeroString(2, string(i)))).HideWindow();
		i++;
	}
	bAutoSummonMaxNumberType = true;
	cosumeItemUpdateAndCardSetting();
	popupExpandScript = GetPopupExpandScript();
	Desc = Substitute(GetSystemMessage(14040), "\\n", "<br1>", false);
	popupExpandScript.SetDialogDescHtml(MakeFullSystemMsg(Desc, htmlAddText(nCurrentSummonPointName, "", getColorHexString(GTColor().Orange2)), htmlAddText(string(nCurrentSummonCount), "HS12", getColorHexString(GTColor().Yellow))));
	popupExpandScript.SetUseNeedItem(true);
	popupExpandScript.StartNeedItemList(1);
	popupExpandScript.AddNeedItemClassID(nCurrentSummonCommisionID, nCurrentSummonCommisionAmount);
	popupExpandScript.SetItemNum(1);
	popupExpandScript.Show();
	popupExpandScript.DelegateOnClickBuy = OnDialogOK;
	popupExpandScript.DelegateOnCancel = OnClickCancelDialog;
	showDisable(true);
	Class'Interface.RelicWnd'.static.Inst().CheckAndHideVisible();
	return;
}

function OnDialogOK()
{
	bIsAutoCardOpen = true;
	bIsAutoCardOpenCancelProcess = false;
	hideAllButton();
	AutoSummon_wnd.ShowWindow();
	AutoSummonCancle_btn.ShowWindow();
	Desc_txt.HideWindow();
	AutoSummonHistory_btn.DisableWindow();
	AutoSummonHistory_wnd.HideWindow();
	AutoSummonDesc_txt.ShowWindow();
	AutoSummonDesc_txt.SetText(GetSystemString(14552));
	GetPopupExpandScript().Hide();
	showDisable(false);
	if(bAutoSummonMaxNumberType)
	{
		API_C_EX_RELICS_ID_SUMMON();
	}
	else
	{
		API_C_EX_RELICS_SUMMON();
	}
	return;
}

function OnClickCancelDialog()
{
	GetPopupExpandScript().Hide();
	showDisable(false);
	ShowAndCheckGameButton();
	if(bAutoSummonMaxNumberType)
	{
		if(Class'Interface.RelicWnd'.static.Inst().Me.IsShowWindow())
		{
			getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "RelicWnd");
		}
		Me.HideWindow();
		Class'Interface.RelicWnd'.static.Inst().CheckAndShowVisible();
	}
	return;
}

function showDisable(bool bShow)
{
	if(bShow)
	{
		GetMeWindow("disable_tex").ShowWindow();
		GetMeWindow("disable_tex").SetFocus();
	}
	else
	{
		GetMeWindow("disable_tex").HideWindow();
	}
	return;
}

function bool isHighGradeRelics(int nGrade)
{
	switch(nGrade)
	{
		case 6:
		case 5:
		case 4:
		case 3:
			return true;
			break;
		default:
			break;
	}
	return false;
}

function int getGradeRelics(int relicsClassID)
{
	local RelicsMainUIData rData;

	GetRelicsMainData(relicsClassID, rData);
	return rData.Grade;
}

function int getRelicsItemClassID(int relicsClassID)
{
	local RelicsMainUIData rData;

	GetRelicsMainData(relicsClassID, rData);
	return rData.ItemID;
}

function string getGradeRelicsSystemString(int Grade)
{
	switch(Grade)
	{
		case 1:
			return GetSystemString(2622);
		case 2:
			return GetSystemString(2613);
		case 3:
			return GetSystemString(2614);
		case 4:
			return GetSystemString(2615);
		case 5:
			return GetSystemString(2616);
		case 6:
			return GetSystemString(2617);
		default:
			return "";
	}
}

function string getGradeRelicsString(int Grade)
{
	switch(Grade)
	{
		case 1:
			return "N";
		case 2:
			return "D";
		case 3:
			return "C";
		case 4:
			return "B";
		case 5:
			return "A";
		case 6:
			return "S";
		default:
			return "";
	}
}

function API_C_EX_RELICS_SUMMON_CLOSE_UI()
{
	local array<byte> stream;
	local UIPacket._C_EX_RELICS_SUMMON_CLOSE_UI packet;

	if(!Class'Interface.UIPacket'.static.Encode_C_EX_RELICS_SUMMON_CLOSE_UI(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(857, stream);
	Debug("Api Call -----> C_EX_RELICS_SUMMON_CLOSE_UI");
	return;
}

function API_C_EX_RELICS_SUMMON()
{
	local array<byte> stream;
	local UIPacket._C_EX_RELICS_SUMMON packet;

	if((Me.IsShowWindow() == false))
	{
		return;
	}
	if(bIsAutoCardOpenCancelProcess)
	{
		bIsAutoCardOpen = false;
		bIsAutoCardOpenCancelProcess = false;
		hideAllButton();
		AutoSummon_wnd.ShowWindow();
		AutoSummonDesc_txt.ShowWindow();
		Desc_txt.ShowWindow();
		Desc_txt.SetText(GetSystemString(14488));
		AutoSummonDesc_txt.SetText(GetSystemString(14553));
		AutoSummonCancle_btn.HideWindow();
		AutoSummonHistory_btn.EnableWindow();
		ShowAndCheckGameButton();
		return;
	}
	packet.nItemID = currentCosumeItemClassID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_RELICS_SUMMON(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(859, stream);
	Debug(("Api Call -----> C_EX_RELICS_SUMMON" @ string(packet.nItemID)));
	return;
}

function API_C_EX_RELICS_ID_SUMMON()
{
	local array<byte> stream;
	local UIPacket._C_EX_RELICS_ID_SUMMON packet;

	if((Me.IsShowWindow() == false))
	{
		return;
	}
	if(bIsAutoCardOpenCancelProcess)
	{
		bIsAutoCardOpen = false;
		bIsAutoCardOpenCancelProcess = false;
		hideAllButton();
		AutoSummon_wnd.ShowWindow();
		AutoSummonDesc_txt.ShowWindow();
		Desc_txt.ShowWindow();
		Desc_txt.SetText(GetSystemString(14488));
		AutoSummonDesc_txt.SetText(GetSystemString(14553));
		AutoSummonCancle_btn.HideWindow();
		AutoSummonHistory_btn.EnableWindow();
		ShowAndCheckGameButton();
		return;
	}
	showHideAutoSummonNum(true);
	packet.nSummonID = nCurrentSummonID;
	packet.nCommisionID = nCurrentSummonCommisionID;
	nCurrentSummonCount--;
	setAutoSummonNum();
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_RELICS_ID_SUMMON(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(902, stream);
	Debug((("Api Call -----> C_EX_RELICS_ID_SUMMON" @ string(packet.nSummonID)) @ string(packet.nCommisionID)));
	return;
}

function API_C_EX_RELICS_COMBINATION_COMPLETE()
{
	local array<byte> stream;
	local UIPacket._C_EX_RELICS_COMBINATION_COMPLETE packet;

	if(!Class'Interface.UIPacket'.static.Encode_C_EX_RELICS_COMBINATION_COMPLETE(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(874, stream);
	Debug("Api Call -----> C_EX_RELICS_COMBINATION_COMPLETE");
	return;
}

function OnReceivedCloseUI()
{
	if(AutoSummonHistory_wnd.IsShowWindow())
	{
		AutoSummonHistory_wnd.HideWindow();
	}
	else if(AutoSummonCancle_btn.IsShowWindow())
	{
		OnAutoSummonCancle_btnClick();
	}
	else
	{
		CloseUI();
	}
	return;
}
