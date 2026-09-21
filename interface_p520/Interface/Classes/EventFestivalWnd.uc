class EventFestivalWnd extends UICommonAPI;

const TIMER_ID = 11100112;

var string m_Windowname;
var WindowHandle Me;
var ButtonHandle HelpButton;
var EffectViewportWndHandle ResultEffectViewport;
var WindowHandle Result_wnd;
var RichListCtrlHandle ResultItemList_ListCtrl;
var WindowHandle CharacterView;
var CharacterViewportWindowHandle ObjectViewport;
var ItemWindowHandle TicketItemWindow;
var TextBoxHandle CostText;
var ButtonHandle ParticipationBtn;
var ButtonHandle StopBtn;
var TextBoxHandle ParticipationText;
var TextBoxHandle TimeText;
var RichListCtrlHandle Star2Item_ListCtrl;
var RichListCtrlHandle Star1Item_ListCtrl;
var CheckBoxHandle AutoCheckBox;
var L2Util util;
var EventFestivalWndWindowTooltip eventFestivalWndWindowTooltipScript;
var int nIsUseFestival;
var int FestivalID;
var int TicketItemID;
var int TicketItemNum;
var bool bSpawnNPC;
var bool bFirstListUpdate;
var bool bResultParticipation;
var int nTicketItemNumPerGame;
var array<UIControlNeedItem> UIControlNeedItemScripts;

function OnRegisterEvent()
{
	RegisterEvent(20260);
	RegisterEvent(20290);
	RegisterEvent(20270);
	RegisterEvent(20280);
	RegisterEvent(10140);
	RegisterEvent(40);
	return;
}

function OnShow()
{
	RequestFestivalInfo(true);
	if((bSpawnNPC == false))
	{
		ObjectViewport.SpawnNPC();
		bSpawnNPC = true;
	}
	UpdateTime();
	SideBar(GetScript("SideBar")).ToggleByWindowName(m_Windowname, Me.IsShowWindow());
	Me.SetFocus();
	return;
}

function OnHide()
{
	if((IsPlayerOnWorldRaidServer() == false))
	{
		RequestFestivalInfo(false);
	}
	bSpawnNPC = false;
	bFirstListUpdate = false;
	bResultParticipation = false;
	GetWindowHandle("EventFestivalWnd.Result_Wnd").HideWindow();
	SideBar(GetScript("SideBar")).ToggleByWindowName(m_Windowname, Me.IsShowWindow());
	ParticipationBtn.ShowWindow();
	StopBtn.HideWindow();
	Me.KillTimer(11100112);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	InitUIControlNeedItem();
	return;
}

function Initialize()
{
	local bool isKorean;

	m_Windowname = getCurrentWindowName(string(self));
	util = L2Util(GetScript("L2Util"));
	eventFestivalWndWindowTooltipScript = EventFestivalWndWindowTooltip(GetScript("EventFestivalWndWindowTooltip"));
	Me = GetWindowHandle("EventFestivalWnd");
	HelpButton = GetButtonHandle("EventFestivalWnd.HelpButton");
	HelpButton.HideWindow();
	ResultEffectViewport = GetEffectViewportWndHandle("EventFestivalWnd.ResultEffectViewport");
	Result_wnd = GetWindowHandle("EventFestivalWnd.Result_Wnd");
	ResultItemList_ListCtrl = GetRichListCtrlHandle("EventFestivalWnd.Result_Wnd.ResultItemList_ListCtrl");
	ObjectViewport = GetCharacterViewportWindowHandle("EventFestivalWnd.CharacterView.ObjectViewport");
	ParticipationBtn = GetButtonHandle("EventFestivalWnd.ParticipationBtn");
	StopBtn = GetButtonHandle("EventFestivalWnd.StopBtn");
	ParticipationText = GetTextBoxHandle("EventFestivalWnd.FestivalTime_wnd.ParticipationText");
	TimeText = GetTextBoxHandle("EventFestivalWnd.FestivalTime_wnd.TimeText");
	Star2Item_ListCtrl = GetRichListCtrlHandle("EventFestivalWnd.Star2Item_ListCtrl");
	Star1Item_ListCtrl = GetRichListCtrlHandle("EventFestivalWnd.Star1Item_ListCtrl");
	Star1Item_ListCtrl.SetSelectable(false);
	Star1Item_ListCtrl.SetAppearTooltipAtMouseX(true);
	Star1Item_ListCtrl.SetSelectedSelTooltip(false);
	Star2Item_ListCtrl.SetSelectable(false);
	Star2Item_ListCtrl.SetAppearTooltipAtMouseX(true);
	Star2Item_ListCtrl.SetSelectedSelTooltip(false);
	GetItemWindowHandle("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_1Wnd.ItemWindow").SetDisableTex("L2UI_CT1.ItemWindow.ItemWindow_IconDisable");
	GetItemWindowHandle("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_2Wnd.ItemWindow").SetDisableTex("L2UI_CT1.ItemWindow.ItemWindow_IconDisable");
	GetItemWindowHandle("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_3Wnd.ItemWindow").SetDisableTex("L2UI_CT1.ItemWindow.ItemWindow_IconDisable");
	AutoCheckBox = GetCheckBoxHandle("EventFestivalWnd.autoCheckBox_Wnd.autoCheckBox");
	AutoCheckBox.SetCheck(false);
	ParticipationBtn.ShowWindow();
	StopBtn.HideWindow();
	isKorean = (int(GetLanguage()) == 0);
	if(isKorean)
	{
		if(!getInstanceUIData().GetIsClassicServer())
		{
			setViewPortParams(19652, 1, 3, 1.0000000, 34000, 100);
		}
		else if(IsAdenServer())
		{
			setViewPortParams(18482, 1, 3, 1.0000000, 34000, 100);
		}
		else
		{
			setViewPortParams(18464, 1, 3, 1.0000000, 34000, 100);
		}
	}
	else
	{
		SetInitLocalization();
	}
	return;
}

function SetInitLocalization()
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		if(IsAdenServer())
		{
			setViewPortParams(18482, 1, 3, 1.0000000, 34000, 100);
		}
		else
		{
			setViewPortParams(9071, 1, 3, 1.0000000, 34000, 100);
		}
	}
	else
	{
		setViewPortParams(19652, 1, 3, 1.0000000, 34000, 100);
	}
	return;
}

function initTopSlot()
{
	local int i;

	i = 1;
	while((i <= 3))
	{
		GetItemWindowHandle((("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string(i)) $ "Wnd.ItemWindow")).Clear();
		GetTextBoxHandle((("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string(i)) $ "Wnd.ItemName_Text")).SetText("");
		GetTextBoxHandle((("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string(i)) $ "Wnd.ItemNumber_Text")).SetText("");
		GetTextureHandle((("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string(i)) $ "Wnd.SoldOutImg")).HideWindow();
		i++;
	}
	return;
}

function UpdateTime()
{
	if((eventFestivalWndWindowTooltipScript.getFestivalEndTime() <= 0))
	{
		GetTextureHandle("EventFestivalWnd.FestivalTime_wnd.ParticipationOnoff_Tex").SetTexture("L2UI_CT1.OlympiadWnd.OffICON");
	}
	else if((nIsUseFestival == 1))
	{
		GetTextureHandle("EventFestivalWnd.FestivalTime_wnd.ParticipationOnoff_Tex").SetTexture("L2UI_CT1.OlympiadWnd.ONICON");
	}
	else if((nIsUseFestival == 2))
	{
		GetTextureHandle("EventFestivalWnd.FestivalTime_wnd.ParticipationOnoff_Tex").SetTexture("L2UI_CT1.OlympiadWnd.OffICON");
	}
	TimeText.SetText(((GetSystemString(1108) $ " : ") $ eventFestivalWndWindowTooltipScript.GetSecToTimeStr(eventFestivalWndWindowTooltipScript.getFestivalEndTime())));
	checkEnableParticipationBtn();
	return;
}

function checkEnableParticipationBtn()
{
	if(((UIControlNeedItemScripts[0].canBuy() == false) || (eventFestivalWndWindowTooltipScript.getFestivalEndTime() <= 0)))
	{
		ParticipationBtn.DisableWindow();
		if(AutoCheckBox.IsShowWindow())
		{
			StopBtn.HideWindow();
			ParticipationBtn.ShowWindow();
		}
	}
	else
	{
		ParticipationBtn.EnableWindow();
	}
	return;
}

function OnClickCheckBox(string strID)
{
	Debug((("strID" @ strID) @ string(AutoCheckBox.IsChecked())));
	if((AutoCheckBox.IsChecked() == false))
	{
		ParticipationBtn.ShowWindow();
		StopBtn.HideWindow();
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "ParticipationBtn":
			OnParticipationBtnClick();
			break;
		case "StopBtn":
			ParticipationBtn.ShowWindow();
			StopBtn.HideWindow();
			break;
		case "RefreshButton":
			Debug("Api Call -> RequestFestivalInfo(true)");
			RequestFestivalInfo(true);
			break;
		default:
			break;
	}
	return;
}

function OnParticipationBtnClick()
{
	if((IsPlayerOnWorldRaidServer() || (Me.IsShowWindow() == false)))
	{
		Me.HideWindow();
		return;
	}
	if((bResultParticipation == false))
	{
		if(GetCanInventoryWeight())
		{
			if(AutoCheckBox.IsChecked())
			{
				StopBtn.ShowWindow();
				ParticipationBtn.HideWindow();
			}
			ParticipationBtn.DisableWindow();
			bResultParticipation = true;
			RequestFestivalGame();
			Debug("Api Call -> RequestFestivalGame()");
		}
		else
		{
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(6196));
			if(AutoCheckBox.IsChecked())
			{
				StopBtn.HideWindow();
				ParticipationBtn.ShowWindow();
			}
		}
	}
	return;
}

function bool GetCanInventoryWeight()
{
	local UserInfo uInfo;
	local float Per;

	if(GetPlayerInfo(uInfo))
	{
		Per = (float(uInfo.nCarringWeight) / float(uInfo.nCarryWeight));
		return (Per <= 0.9000000);
	}
	return false;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 20260))
	{
		Debug(("EV_FestivalInfo :" @ param));
		ParseInt(param, "TicketItemID", TicketItemID);
		ParseInt(param, "TicketItemNum", TicketItemNum);
		ParseInt(param, "TicketItemNumPerGame", nTicketItemNumPerGame);
		updateNeedItem(TicketItemID, nTicketItemNumPerGame);
	}
	else if((Event_ID == 20270))
	{
		Debug(("EV_FestivalAllItemInfo :" @ param));
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
		bResultParticipation = false;
		bSpawnNPC = false;
		AutoCheckBox.SetCheck(false);
		ParticipationBtn.ShowWindow();
		StopBtn.HideWindow();
		initTopSlot();
	}
	else if((Event_ID == 10140))
	{
		Me.HideWindow();
	}
	return;
}

function setListRewardItem(string param)
{
	local int ListCount, newFestivalID, Grade, ItemID, RemainItemNum, MAXITEMNUM, i, gradeItemCount, beforeGradeItem, ListNum;
	local ItemInfo Info;
	local string itemParam;
	local bool bUpdate;
	local int rGradeCount;

	ParseInt(param, "ListCount", ListCount);
	ParseInt(param, "FestivalID", newFestivalID);
	ParseInt(param, "TicketItemID", TicketItemID);
	ParseInt(param, "TicketItemNum", TicketItemNum);
	checkEnableParticipationBtn();
	if((bFirstListUpdate && (FestivalID == newFestivalID)))
	{
		bUpdate = true;
	}
	else
	{
		Star1Item_ListCtrl.DeleteAllItem();
		Star2Item_ListCtrl.DeleteAllItem();
		initTopSlot();
	}
	FestivalID = newFestivalID;
	i = 0;
	while((i < ListCount))
	{
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
		ItemInfoToParam(Info, itemParam);
		if((Grade == 1))
		{
			GetItemWindowHandle((("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string((gradeItemCount + 1))) $ "Wnd.ItemWindow")).Clear();
			GetItemWindowHandle((("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string((gradeItemCount + 1))) $ "Wnd.ItemWindow")).AddItem(Info);
			GetItemWindowHandle((("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string((gradeItemCount + 1))) $ "Wnd.ItemWindow")).UpdatePointedNum();
			GetTextBoxHandle((("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string((gradeItemCount + 1))) $ "Wnd.ItemName_Text")).SetText(makeShortStringByPixel(Info.Name, 160, ".."));
			GetTextBoxHandle((("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string((gradeItemCount + 1))) $ "Wnd.ItemNumber_Text")).SetText(((string(RemainItemNum) $ "/") $ string(MAXITEMNUM)));
			if((RemainItemNum <= 0))
			{
				GetTextBoxHandle((("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string((gradeItemCount + 1))) $ "Wnd.ItemName_Text")).SetTextColor(GTColor().Gray);
				GetTextBoxHandle((("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string((gradeItemCount + 1))) $ "Wnd.ItemNumber_Text")).SetTextColor(GTColor().Gray);
				GetItemWindowHandle((("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string((gradeItemCount + 1))) $ "Wnd.ItemWindow")).DisableWindow();
				GetTextureHandle((("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string((gradeItemCount + 1))) $ "Wnd.SoldOutImg")).ShowWindow();
			}
			else
			{
				GetTextBoxHandle((("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string((gradeItemCount + 1))) $ "Wnd.ItemName_Text")).SetTextColor(GTColor().White);
				GetTextBoxHandle((("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string((gradeItemCount + 1))) $ "Wnd.ItemNumber_Text")).SetTextColor(GTColor().Yellow);
				GetItemWindowHandle((("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string((gradeItemCount + 1))) $ "Wnd.ItemWindow")).EnableWindow();
				GetTextureHandle((("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string((gradeItemCount + 1))) $ "Wnd.SoldOutImg")).HideWindow();
			}
			rGradeCount++;
			i++;
			continue;
		}
		else if((Grade == 2))
		{
			addRichItemList(Star2Item_ListCtrl, bUpdate, Info.Id.ClassID, ((string(RemainItemNum) $ "/") $ string(MAXITEMNUM)), RemainItemNum, itemParam);
		}
		else if((Grade == 3))
		{
			addRichItemList(Star1Item_ListCtrl, bUpdate, Info.Id.ClassID, ((string(RemainItemNum) $ "/") $ string(MAXITEMNUM)), RemainItemNum, itemParam);
		}
		ListNum++;
		bFirstListUpdate = true;
		i++;
	}
	return;
}

function addRichItemList(RichListCtrlHandle rList, bool bModify, int nItemID, string itemNumStr, int RemainItemNum, string itemParam)
{
	local RichListCtrlRowData rowData;
	local int W, h, updateListNum;
	local string ItemName;

	rowData.cellDataList.Length = 1;
	rowData.szReserved = itemParam;
	rowData.nReserved1 = INT64(nItemID);
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, 3, 5);
	AddRichListCtrlItem(rowData.cellDataList[0].drawitems, GetItemInfoByClassID(nItemID), 32, 32, -34, 1);
	if((RemainItemNum <= 0))
	{
		addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_CT1.ItemWindow.ItemWindow_IconDisable", 32, 32, -32, 0);
	}
	ItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(nItemID));
	ItemName = makeShortStringByPixel(ItemName, 240, "..");
	GetTextSizeDefault(ItemName, W, h);
	if((RemainItemNum <= 0))
	{
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, ItemName, GTColor().Gray, false, 5, 4);
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, itemNumStr, GTColor().Gray, false, -W, 12);
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, ItemName, GTColor().White, false, 5, 4);
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, itemNumStr, GTColor().Yellow, false, -W, 12);
	}
	if(bModify)
	{
		updateListNum = findListNumhRichItemList(rList, nItemID);
		if((updateListNum > -1))
		{
			rList.ModifyRecord(updateListNum, rowData);
		}
	}
	else
	{
		rList.InsertRecord(rowData);
	}
	return;
}

function int findListNumhRichItemList(RichListCtrlHandle rList, int nItemID)
{
	local int i;
	local RichListCtrlRowData rowData;

	i = 0;
	while((i < rList.GetRecordCount()))
	{
		rList.GetRec(i, rowData);
		if((rowData.nReserved1 == INT64(nItemID)))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function updateTopItem(string param)
{
	local int Grade, ItemID, RemainItemNum, MAXITEMNUM, i, gradeItemCount;
	local ItemInfo Info;

	ParseInt(param, "IsUseFestival", nIsUseFestival);
	if((nIsUseFestival == 0))
	{
		Debug(("nIsUseFestival" @ string(nIsUseFestival)));
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
		gradeItemCount = 1;
		while((gradeItemCount <= 3))
		{
			GetItemWindowHandle((("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string(gradeItemCount)) $ "Wnd.ItemWindow")).GetItem(0, Info);
			if((Info.Id.ClassID == ItemID))
			{
				GetItemWindowHandle((("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string(gradeItemCount)) $ "Wnd.ItemWindow")).Clear();
				GetItemWindowHandle((("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string(gradeItemCount)) $ "Wnd.ItemWindow")).AddItem(Info);
				GetItemWindowHandle((("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string(gradeItemCount)) $ "Wnd.ItemWindow")).UpdatePointedNum();
				GetTextBoxHandle((("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string(gradeItemCount)) $ "Wnd.ItemName_Text")).SetText(makeShortStringByPixel(Info.Name, 160, ".."));
				GetTextBoxHandle((("EventFestivalWnd.Star3ItemGroup_Wnd.Star3Item_" $ string(gradeItemCount)) $ "Wnd.ItemNumber_Text")).SetText(((string(RemainItemNum) $ "/") $ string(MAXITEMNUM)));
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

	ResultEffectViewport.SpawnEffect("");
	if((effectPath == "LineageEffect2.ui_upgrade_succ"))
	{
		offset.X = 10.0000000;
		offset.Y = -5.0000000;
		ResultEffectViewport.SetScale(6.0000000);
		ResultEffectViewport.SetCameraDistance(1300.0000000);
		ResultEffectViewport.SetOffset(offset);
	}
	else if((effectPath == "LineageEffect.d_firework_b"))
	{
		offset.X = 10.0000000;
		offset.Y = -5.0000000;
		ResultEffectViewport.SetScale(6.0000000);
		ResultEffectViewport.SetCameraDistance(1300.0000000);
		ResultEffectViewport.SetOffset(offset);
	}
	else if((effectPath == "LineageEffect_br.br_e_firebox_fire_b"))
	{
		offset.X = 10.0000000;
		offset.Y = -5.0000000;
		ResultEffectViewport.SetScale(6.0000000);
		ResultEffectViewport.SetCameraDistance(1300.0000000);
		ResultEffectViewport.SetOffset(offset);
	}
	GetWindowHandle("EventFestivalWnd.Result_Wnd").ShowWindow();
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
	bResultParticipation = false;
	if((FestivalResult > 0))
	{
		updateNeedItem(TicketItemID, nTicketItemNumPerGame);
		if((RewardItemGrade == 1))
		{
			playResultEffectViewPort("LineageEffect_br.br_e_firebox_fire_b");
		}
		else if((RewardItemGrade == 2))
		{
			playResultEffectViewPort("LineageEffect.d_firework_b");
		}
		else
		{
			playResultEffectViewPort("LineageEffect2.ui_upgrade_succ");
		}
		GetWindowHandle("EventFestivalWnd.Result_Wnd").ShowWindow();
		Info = GetItemInfoByClassID(RewardItemID);
		Info.ItemNum = INT64(RewardItemNum);
		ticketInfo = GetItemInfoByClassID(TicketItemID);
		ticketInfo.ItemNum = INT64(TicketItemNum);
		checkEnableParticipationBtn();
		GetItemWindowHandle("EventFestivalWnd.Result_Wnd.Itemwnd.ItemWindow").Clear();
		GetItemWindowHandle("EventFestivalWnd.Result_Wnd.Itemwnd.ItemWindow").AddItem(Info);
		GetTextBoxHandle("EventFestivalWnd.Result_Wnd.Itemwnd.ItemName_Text").SetText(makeShortStringByPixel(Info.Name, 220, ".."));
		GetTextBoxHandle("EventFestivalWnd.Result_Wnd.Itemwnd.ItemNum_Text").SetText(("x" $ string(Info.ItemNum)));
		if((RewardItemGrade == 1))
		{
			getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(1889), Info.Name));
		}
		if(((AutoCheckBox.IsChecked() && Me.IsShowWindow()) && StopBtn.IsShowWindow()))
		{
			Me.KillTimer(11100112);
			Me.SetTimer(11100112, 1);
		}
		if((AutoCheckBox.IsChecked() == false))
		{
			ParticipationBtn.ShowWindow();
			StopBtn.HideWindow();
		}
	}
	else
	{
		Me.HideWindow();
	}
	return;
}

function OnTimer(int TimeID)
{
	if((TimeID == 11100112))
	{
		Me.KillTimer(11100112);
		if(((UIControlNeedItemScripts[0].canBuy() && (eventFestivalWndWindowTooltipScript.getFestivalEndTime() > 0)) && Me.IsShowWindow()))
		{
			ParticipationBtn.HideWindow();
			StopBtn.ShowWindow();
			OnParticipationBtnClick();
		}
		else
		{
			ParticipationBtn.ShowWindow();
			StopBtn.HideWindow();
		}
	}
	return;
}

function setViewPortParams(int NpcID, int OffsetX, int OffsetY, float viewSale, int Rotation, int Distance)
{
	ObjectViewport.SetNPCInfo(NpcID);
	ObjectViewport.SetCharacterOffsetX(OffsetX);
	ObjectViewport.SetCharacterOffsetY(OffsetY);
	ObjectViewport.SetCharacterScale(viewSale);
	ObjectViewport.SetCurrentRotation(Rotation);
	ObjectViewport.SetCameraDistance(Distance);
	return;
}

function InitUIControlNeedItem()
{
	local int i;
	local string WindowName;

	WindowName = "EventFestivalWnd.CostWnd";
	i = 0;
	while((i < 1))
	{
		GetWindowHandle(WindowName).SetScript("UIControlNeedItem");
		UIControlNeedItemScripts[i] = UIControlNeedItem(GetWindowHandle(WindowName).GetScript());
		UIControlNeedItemScripts[i].Init(WindowName);
		UIControlNeedItemScripts[i].DelegateItemUpdate = PeeItemUpdated;
		i++;
	}
	return;
}

function PeeItemUpdated(UIControlNeedItem Script)
{
	checkEnableParticipationBtn();
	return;
}

function updateNeedItem(int ItemClassID, int Amount)
{
	UIControlNeedItemScripts[0].setId(GetItemID(ItemClassID));
	UIControlNeedItemScripts[0].SetNumNeed(INT64(Amount));
	UIControlNeedItemScripts[0].MakeDotString();
	return;
}

function OnReceivedCloseUI()
{
	if(StopBtn.IsShowWindow())
	{
		OnClickButton("StopBtn");
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	}
	return;
}
