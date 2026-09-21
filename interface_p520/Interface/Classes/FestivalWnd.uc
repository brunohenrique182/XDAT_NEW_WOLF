class FestivalWnd extends UICommonAPI;

var WindowHandle Me;
var WindowHandle PopUpWnd;
var ItemWindowHandle PopUpCostItemWindow;
var TextBoxHandle PopUpDescriptionText;
var WindowHandle disableWnd;
var WindowHandle CharacterView;
var CharacterViewportWindowHandle ObjectViewport;
var TextureHandle CharacterViewBG;
var TextBoxHandle TicketText;
var ItemWindowHandle TicketItemWindow;
var TextBoxHandle TicketNumberText;
var TextBoxHandle CostText;
var ItemWindowHandle CostItemWindow;
var TextBoxHandle CostNumberText;
var ButtonHandle ParticipationBtn;
var TextBoxHandle TimeNumberText;
var TextBoxHandle GoldNumberText;
var ListCtrlHandle FestivalItemListCtrl;
var EffectViewportWndHandle ResultEffectViewport;
var FestivalSubWnd FestivalSubWndScript;
var L2Util util;
var int nIsUseFestival;
var int FestivalID;
var int TicketItemID;
var int TicketItemNum;
var bool bSpawnNPC;
var bool bFirstListUpdate;
var int nTicketItemNumPerGame;

function OnRegisterEvent()
{
	RegisterEvent(20260);
	RegisterEvent(20290);
	RegisterEvent(20270);
	RegisterEvent(20280);
	RegisterEvent(40);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	Load();
	return;
}

function Initialize()
{
	util = L2Util(GetScript("L2Util"));
	FestivalSubWndScript = FestivalSubWnd(GetScript("FestivalSubWnd"));
	Me = GetWindowHandle("FestivalWnd");
	PopUpWnd = GetWindowHandle("FestivalWnd.PopUpWnd");
	PopUpCostItemWindow = GetItemWindowHandle("FestivalWnd.PopUpWnd.PopUpCostItemWindow");
	PopUpDescriptionText = GetTextBoxHandle("FestivalWnd.PopUpWnd.PopUpDescriptionText");
	disableWnd = GetWindowHandle("FestivalWnd.DisableWnd");
	ObjectViewport = GetCharacterViewportWindowHandle("FestivalWnd.CharacterView.ObjectViewport");
	ResultEffectViewport = GetEffectViewportWndHandle("FestivalWnd.ResultEffectViewport");
	TicketItemWindow = GetItemWindowHandle("FestivalWnd.TicketItemWindow");
	TicketNumberText = GetTextBoxHandle("FestivalWnd.TicketNumberText");
	CostItemWindow = GetItemWindowHandle("FestivalWnd.CostItemWindow");
	CostNumberText = GetTextBoxHandle("FestivalWnd.CostNumberText");
	ParticipationBtn = GetButtonHandle("FestivalWnd.ParticipationBtn");
	TimeNumberText = GetTextBoxHandle("FestivalWnd.TimeNumberText");
	GoldNumberText = GetTextBoxHandle("FestivalWnd.GoldNumberText");
	FestivalItemListCtrl = GetListCtrlHandle("FestivalWnd.FestivalItemListCtrl");
	FestivalItemListCtrl.SetSelectedSelTooltip(false);
	FestivalItemListCtrl.SetAppearTooltipAtMouseX(true);
	setViewPortParams(8534, 1, 6, 1.0000000, 34000, 140);
	return;
}

function Load()
{
	return;
}

function OnShow()
{
	if((bSpawnNPC == false))
	{
		ObjectViewport.SpawnNPC();
		bSpawnNPC = true;
	}
	UpdateTime();
	return;
}

function OnHide()
{
	ResetUI();
	return;
}

function ResetUI()
{
	bSpawnNPC = false;
	bFirstListUpdate = false;
	GetWindowHandle("FestivalWnd.ResultWnd").HideWindow();
	OnPopUpCancelBtnClick();
	GetTextureHandle("FestivalWnd.ResultFrame").HideWindow();
	return;
}

function UpdateTime()
{
	TimeNumberText.SetText(getTimeStringBySec(FestivalSubWndScript.getFestivalEndTime(), false));
	checkEnableParticipationBtn();
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 20260))
	{
		ParseInt(param, "TicketItemID", TicketItemID);
		ParseInt(param, "TicketItemNum", TicketItemNum);
		ParseInt(param, "TicketItemNumPerGame", nTicketItemNumPerGame);
		CostNumberText.SetText(("x" $ string(nTicketItemNumPerGame)));
		CostItemWindow.Clear();
		CostItemWindow.AddItem(GetItemInfoByClassID(TicketItemID));
		TicketNumberText.SetText(string(TicketItemNum));
	}
	else if((Event_ID == 20270))
	{
		setListRewardItem(param);
	}
	else if((Event_ID == 20280))
	{
		Debug(("EV_FestivalTopItemInfo  :" @ param));
		updateTopItem(param);
	}
	else if((Event_ID == 20290))
	{
		Debug(("EV_FestivalGame :" @ param));
		resultWindow(param);
	}
	else if((Event_ID == 40))
	{
		bSpawnNPC = false;
	}
	return;
}

function updateTopItem(string param)
{
	local int Grade, ItemID, RemainItemNum, MAXITEMNUM, i, gradeItemCount;
	local ItemInfo Info;

	ParseInt(param, "IsUseFestival", nIsUseFestival);
	if((nIsUseFestival == 0))
	{
		Me.HideWindow();
		return;
	}
	i = 0;
	ParseInt(param, ("Grade" $ string(i)), Grade);
	ParseInt(param, ("itemID" $ string(i)), ItemID);
	ParseInt(param, ("MaxItemNum" $ string(i)), MAXITEMNUM);
	ParseInt(param, ("RemainItemNum" $ string(i)), RemainItemNum);
	if((Grade == 1))
	{
		gradeItemCount = 0;
		while((gradeItemCount < 3))
		{
			GetItemWindowHandle((("FestivalWnd.Gold" $ string((gradeItemCount + 1))) $ "Window.GoldItemWindow")).GetItem(0, Info);
			if((Info.Id.ClassID == ItemID))
			{
				GetItemWindowHandle((("FestivalWnd.Gold" $ string((gradeItemCount + 1))) $ "Window.GoldItemWindow")).Clear();
				GetItemWindowHandle((("FestivalWnd.Gold" $ string((gradeItemCount + 1))) $ "Window.GoldItemWindow")).AddItem(Info);
				GetTextBoxHandle((("FestivalWnd.Gold" $ string((gradeItemCount + 1))) $ "Window.GoldText")).SetText(makeShortStringByPixel(Info.Name, 100, ".."));
				GetTextBoxHandle((("FestivalWnd.Gold" $ string((gradeItemCount + 1))) $ "Window.GoldNumberText")).SetText(((string(RemainItemNum) $ "/") $ string(MAXITEMNUM)));
				break;
			}
			gradeItemCount++;
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
		ResultEffectViewport.SetScale(6.0000000);
		ResultEffectViewport.SetCameraDistance(1300.0000000);
		ResultEffectViewport.SetOffset(offset);
		ObjectViewport.PlayAnimation(4);
	}
	else if((effectPath == "LineageEffect.d_firework_a"))
	{
		offset.X = 10.0000000;
		offset.Y = -5.0000000;
		ResultEffectViewport.SetScale(6.0000000);
		ResultEffectViewport.SetCameraDistance(1300.0000000);
		ResultEffectViewport.SetOffset(offset);
		ObjectViewport.PlayAnimation(5);
	}
	GetTextureHandle("FestivalWnd.ResultFrame").ShowWindow();
	ResultEffectViewport.SetFocus();
	ResultEffectViewport.SpawnEffect(effectPath);
	return;
}

function resultWindow(string param)
{
	local ItemInfo Info, ticketInfo;
	local int FestivalResult, RewardItemID, RewardItemNum, RewardItemGrade;

	ParseInt(param, "FestivalResult", FestivalResult);
	ParseInt(param, "RewardItemGrade", RewardItemGrade);
	ParseInt(param, "TicketItemID", TicketItemID);
	ParseInt(param, "TicketItemNum", TicketItemNum);
	ParseInt(param, "RewardItemID", RewardItemID);
	ParseInt(param, "RewardItemNum", RewardItemNum);
	ParseInt(param, "TicketItemNumPerGame", nTicketItemNumPerGame);
	DisableCurrentWindow(false);
	if((FestivalResult > 0))
	{
		CostNumberText.SetText(("x" $ string(nTicketItemNumPerGame)));
		if((RewardItemGrade == 1))
		{
			playResultEffectViewPort("LineageEffect2.ui_upgrade_succ");
		}
		else
		{
			playResultEffectViewPort("LineageEffect.d_firework_a");
		}
		GetWindowHandle("FestivalWnd.ResultWnd").ShowWindow();
		GetWindowHandle("FestivalWnd.ResultWnd").SetFocus();
		Info = GetItemInfoByClassID(RewardItemID);
		Info.ItemNum = INT64(RewardItemNum);
		CostItemWindow.Clear();
		ticketInfo = GetItemInfoByClassID(TicketItemID);
		ticketInfo.ItemNum = INT64(TicketItemNum);
		if((TicketItemNum <= 0))
		{
			ParticipationBtn.DisableWindow();
		}
		else
		{
			ParticipationBtn.EnableWindow();
		}
		CostItemWindow.AddItem(ticketInfo);
		TicketNumberText.SetText(string(TicketItemNum));
		GetItemWindowHandle("FestivalWnd.ResultWnd.ResultItemWindow").Clear();
		GetItemWindowHandle("FestivalWnd.ResultWnd.ResultItemWindow").AddItem(Info);
		GetTextBoxHandle("FestivalWnd.ResultWnd.ResultText").SetText(makeShortStringByPixel(Info.Name, 250, ".."));
		GetTextBoxHandle("FestivalWnd.ResultWnd.ResultNumberText").SetText(("x" $ string(RewardItemNum)));
		getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(1889), Info.Name));
	}
	else
	{
		Me.HideWindow();
	}
	return;
}

function checkEnableParticipationBtn()
{
	if(((TicketItemNum <= 0) || (FestivalSubWndScript.getFestivalEndTime() <= 0)))
	{
		ParticipationBtn.DisableWindow();
	}
	else
	{
		ParticipationBtn.EnableWindow();
	}
	return;
}

function initGoldSlot()
{
	local int i;

	i = 0;
	while((i < 3))
	{
		GetItemWindowHandle((("FestivalWnd.Gold" $ string((i + 1))) $ "Window.GoldItemWindow")).Clear();
		GetTextBoxHandle((("FestivalWnd.Gold" $ string((i + 1))) $ "Window.GoldText")).SetText("");
		GetTextBoxHandle((("FestivalWnd.Gold" $ string((i + 1))) $ "Window.GoldNumberText")).SetText("");
		i++;
	}
	return;
}

function setListRewardItem(string param)
{
	local Rect rectWnd;
	local int ListCount, newFestivalID, Grade, ItemID, RemainItemNum, MAXITEMNUM, i, gradeItemCount, beforeGradeItem, ListNum;
	local ItemInfo Info;
	local LVDataRecord Record, tmRecord;
	local string itemParam, symbolTexture;
	local bool bUpdate;
	local int rGradeCount;

	rectWnd = GetWindowHandle("FestivalWnd.FestivalPattern").GetRect();
	ParseInt(param, "ListCount", ListCount);
	ParseInt(param, "FestivalID", newFestivalID);
	ParseInt(param, "TicketItemID", TicketItemID);
	ParseInt(param, "TicketItemNum", TicketItemNum);
	checkEnableParticipationBtn();
	CostItemWindow.Clear();
	CostItemWindow.AddItem(GetItemInfoByClassID(TicketItemID));
	TicketNumberText.SetText(string(TicketItemNum));
	if((bFirstListUpdate && (FestivalID == newFestivalID)))
	{
		bUpdate = true;
	}
	else
	{
		FestivalItemListCtrl.DeleteAllItem();
	}
	initGoldSlot();
	FestivalID = newFestivalID;
	i = 0;
	while((i < ListCount))
	{
		Record = tmRecord;
		beforeGradeItem = Grade;
		ParseInt(param, ("Grade" $ string(i)), Grade);
		ParseInt(param, ("itemID" $ string(i)), ItemID);
		ParseInt(param, ("MaxItemNum" $ string(i)), MAXITEMNUM);
		ParseInt(param, ("RemainItemNum" $ string(i)), RemainItemNum);
		if((beforeGradeItem == Grade))
		{
			gradeItemCount++;
		}
		else
		{
			gradeItemCount = 0;
		}
		Info = GetItemInfoByClassID(ItemID);
		if((Grade == 1))
		{
			GetItemWindowHandle((("FestivalWnd.Gold" $ string((gradeItemCount + 1))) $ "Window.GoldItemWindow")).ShowWindow();
			GetItemWindowHandle((("FestivalWnd.Gold" $ string((gradeItemCount + 1))) $ "Window.GoldItemWindow")).Clear();
			GetItemWindowHandle((("FestivalWnd.Gold" $ string((gradeItemCount + 1))) $ "Window.GoldItemWindow")).AddItem(Info);
			GetTextBoxHandle((("FestivalWnd.Gold" $ string((gradeItemCount + 1))) $ "Window.GoldText")).SetText(makeShortStringByPixel(Info.Name, 100, ".."));
			GetTextBoxHandle((("FestivalWnd.Gold" $ string((gradeItemCount + 1))) $ "Window.GoldNumberText")).SetText(((string(RemainItemNum) $ "/") $ string(MAXITEMNUM)));
			rGradeCount++;
			i++;
			continue;
		}
		ItemInfoToParam(Info, itemParam);
		Record.szReserved = itemParam;
		Record.LVDataList.Length = 3;
		if((gradeItemCount == 0))
		{
			if((Grade == 2))
			{
				symbolTexture = "l2ui_ct1.FestivalWnd.FestivalWnd_Flag_Silver1";
			}
			else if((Grade == 3))
			{
				symbolTexture = "l2ui_ct1.FestivalWnd.FestivalWnd_Flag_Bronze1";
			}
			if(((Grade == 2) || (Grade == 3)))
			{
				Record.LVDataList[0].arrTexture.Length = 1;
				lvTextureAdd(Record.LVDataList[0].arrTexture[0], symbolTexture, 0, 0, 50, 50);
			}
		}
		else if((gradeItemCount == 1))
		{
			if((Grade == 2))
			{
				symbolTexture = "l2ui_ct1.FestivalWnd.FestivalWnd_Flag_Silver2";
			}
			else if((Grade == 3))
			{
				symbolTexture = "l2ui_ct1.FestivalWnd.FestivalWnd_Flag_Bronze2";
			}
			if(((Grade == 2) || (Grade == 3)))
			{
				Record.LVDataList[0].arrTexture.Length = 1;
				lvTextureAdd(Record.LVDataList[0].arrTexture[0], symbolTexture, 0, -1, 50, 50);
			}
		}
		Record.LVDataList[1].szData = Info.Name;
		Record.LVDataList[1].hasIcon = true;
		Record.LVDataList[1].nTextureWidth = 32;
		Record.LVDataList[1].nTextureHeight = 32;
		Record.LVDataList[1].nTextureU = 32;
		Record.LVDataList[1].nTextureV = 32;
		Record.LVDataList[1].szTexture = Info.IconName;
		Record.LVDataList[1].IconPosX = 4;
		Record.LVDataList[1].FirstLineOffsetX = 6;
		Record.LVDataList[1].iconBackTexName = "l2ui_ct1.ItemWindow_DF_SlotBox_Default";
		Record.LVDataList[1].backTexOffsetXFromIconPosX = -2;
		Record.LVDataList[1].backTexOffsetYFromIconPosY = -1;
		Record.LVDataList[1].backTexWidth = 36;
		Record.LVDataList[1].backTexHeight = 36;
		Record.LVDataList[1].backTexUL = 36;
		Record.LVDataList[1].backTexVL = 36;
		Record.LVDataList[2].bUseTextColor = true;
		Record.LVDataList[2].TextColor = GetColor(170, 153, 119, 255);
		Record.LVDataList[2].szData = ((string(RemainItemNum) $ "/") $ string(MAXITEMNUM));
		Record.LVDataList[2].textAlignment = TA_Center;
		if(bUpdate)
		{
			FestivalItemListCtrl.ModifyRecord(ListNum, Record);
		}
		else
		{
			FestivalItemListCtrl.InsertRecord(Record);
		}
		ListNum++;
		bFirstListUpdate = true;
		i++;
	}
	GetWindowHandle("FestivalWnd.Gold1Window").HideWindow();
	GetWindowHandle("FestivalWnd.Gold2Window").HideWindow();
	GetWindowHandle("FestivalWnd.Gold3Window").HideWindow();
	if((rGradeCount == 1))
	{
		setGoldItem(1, rectWnd, 156, 110);
	}
	else if((rGradeCount == 2))
	{
		setGoldItem(1, rectWnd, 80, 110);
		setGoldItem(2, rectWnd, 232, 110);
	}
	else if((rGradeCount == 3))
	{
		setGoldItem(1, rectWnd, 20, 110);
		setGoldItem(2, rectWnd, 156, 110);
		setGoldItem(3, rectWnd, 292, 110);
	}
	return;
}

function setGoldItem(int windowNum, Rect rectWnd, int X, int Y)
{
	GetWindowHandle((("FestivalWnd.Gold" $ string(windowNum)) $ "Window")).ShowWindow();
	GetWindowHandle((("FestivalWnd.Gold" $ string(windowNum)) $ "Window")).MoveTo((rectWnd.nX + X), (rectWnd.nY + Y));
	return;
}

function testObjectView(string param)
{
	local int nX, nY, NpcID, Rotation, Distance, Animation;
	local float Scale;

	ParseInt(param, "x", nX);
	ParseInt(param, "y", nY);
	ParseInt(param, "rotation", Rotation);
	ParseInt(param, "distance", Distance);
	ParseInt(param, "npcID", NpcID);
	ParseInt(param, "animation", Animation);
	ParseFloat(param, "scale", Scale);
	setViewPortParams(NpcID, nX, nY, Scale, Rotation, Distance);
	ObjectViewport.SpawnNPC();
	ObjectViewport.PlayAnimation(Animation);
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "PopUpOkBtn":
			OnPopUpOkBtnClick();
			break;
		case "PopUpCancelBtn":
			OnPopUpCancelBtnClick();
			break;
		case "ParticipationBtn":
			OnParticipationBtnClick();
			break;
		case "RefreshBtn":
			Debug("Api Call -> RequestFestivalInfo(false)");
			RequestFestivalInfo(true);
			break;
		case "ResultBtn":
			GetWindowHandle("FestivalWnd.ResultWnd").HideWindow();
			GetTextureHandle("FestivalWnd.ResultFrame").HideWindow();
			break;
		case "HelpButton":
			OnHelpBtnClick();
			break;
		default:
			break;
	}
	return;
}

function OnPopUpOkBtnClick()
{
	PopUpWnd.HideWindow();
	RequestFestivalGame();
	return;
}

function OnPopUpCancelBtnClick()
{
	PopUpWnd.HideWindow();
	DisableCurrentWindow(false);
	return;
}

function OnParticipationBtnClick()
{
	Debug(("TicketItemNum" @ string(TicketItemNum)));
	DisableCurrentWindow(true);
	PopUpCostItemWindow.Clear();
	PopUpCostItemWindow.AddItem(GetItemInfoByClassID(TicketItemID));
	GetTextBoxHandle("FestivalWnd.PopUpWnd.PopUpCostNumberText").SetText(("x" $ string(nTicketItemNumPerGame)));
	PopUpWnd.ShowWindow();
	PopUpWnd.SetFocus();
	return;
}

function DisableCurrentWindow(bool bFlag)
{
	if(bFlag)
	{
		disableWnd.ShowWindow();
		disableWnd.SetFocus();
	}
	else
	{
		disableWnd.HideWindow();
	}
	return;
}

function setViewPortParams(int NpcID, int OffsetX, int OffsetY, float viewSale, int Rotation, int Distance)
{
	Debug("setViewPortParams");
	ObjectViewport.SetNPCInfo(NpcID);
	ObjectViewport.SetCharacterOffsetX(OffsetX);
	ObjectViewport.SetCharacterOffsetY(OffsetY);
	ObjectViewport.SetCharacterScale(viewSale);
	ObjectViewport.SetCurrentRotation(Rotation);
	ObjectViewport.SetCameraDistance(Distance);
	return;
}

function string getTimeStringBySec(int Sec, bool bRemainStr)
{
	local int timeTemp0, timeTemp1, Msg;
	local string returnStr;

	if((Sec < 0))
	{
		Sec = 0;
	}
	returnStr = "";
	timeTemp0 = ((Sec / 60) / 60);
	timeTemp1 = (Sec / 60);
	if((timeTemp0 > 0))
	{
		if(bRemainStr)
		{
			Msg = 6210;
		}
		else
		{
			Msg = 3304;
		}
		returnStr = MakeFullSystemMsg(GetSystemMessage(Msg), string(timeTemp0), string(int((float((Sec / 60)) % 60.0000000))));
	}
	else if((timeTemp1 > 0))
	{
		if(bRemainStr)
		{
			Msg = 6211;
		}
		else
		{
			Msg = 3390;
		}
		returnStr = MakeFullSystemMsg(GetSystemMessage(Msg), string(timeTemp1));
	}
	else
	{
		if(bRemainStr)
		{
			Msg = 6211;
		}
		else
		{
			Msg = 4360;
		}
		returnStr = MakeFullSystemMsg(GetSystemMessage(Msg), string(1));
	}
	return returnStr;
}

function OnHelpBtnClick()
{
	local string strParam;
	local HelpHtmlWnd Script;

	Script = HelpHtmlWnd(GetScript("HelpHtmlWnd"));
	ParamAdd(strParam, "FilePath", (GetLocalizedL2TextPathNameUC() $ "festival_help002.htm"));
	Script.HandleShowHelp(strParam);
	return;
}

function string htmlSetHtmlStart(string targetHtml)
{
	return (("<html><body>" $ targetHtml) $ "</body></html>");
}

function OnReceivedCloseUI()
{
	if(PopUpWnd.IsShowWindow())
	{
		OnPopUpCancelBtnClick();
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	}
	return;
}
