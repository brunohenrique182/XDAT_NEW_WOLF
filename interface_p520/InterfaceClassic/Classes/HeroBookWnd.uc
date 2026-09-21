class HeroBookWnd extends UICommonAPI
	dependson(UIPacket);

const MAX_CATEGORY = 5;
const TIME_BAR_ID = 1010105;

var WindowHandle Me;
var WindowHandle Confirm_Wnd;
var WindowHandle disableWnd;
var AnimTextureHandle ProbabilityRound_Trailer;
var StatusRoundHandle Probability_StatusRound;
var ItemWindowHandle ReceiveSkill_Item;
var ItemWindowHandle prvReceivedSkill_Item;
var ItemWindowHandle NextReceiveSkill_Item;
var TextBoxHandle CurrentLevel_text;
var TextBoxHandle ProbabilityTitle_text;
var EffectViewportWndHandle EffectViewport00;
var EffectViewportWndHandle EffectViewport01;
var TextBoxHandle addRewardLevel_text;
var ItemWindowHandle addRewardicon00_Item;
var ItemWindowHandle addRewardicon01_Item;
var ButtonHandle GameStartorCancle_Btn;
var UIControlGroupButtonAssets TopGroupButtonAsset;
var int nRoundProgress;
var int nResultLevel;
var float successPercent;
var array<UIPacket._PkHeroBook> books;
var int nCurrentPoint;
var int nCurrentLevel;
var int nLastRewardLevel;
var int nCurrentProb;
var int nCatogoryNum;

function OnRegisterEvent()
{
	RegisterEvent((100000 + 1050));
	RegisterEvent((100000 + 1047));
	RegisterEvent((100000 + 1048));
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
	Me = GetWindowHandle("HeroBookWnd");
	Confirm_Wnd = GetWindowHandle("HeroBookWnd.Confirm_Wnd");
	disableWnd = GetWindowHandle("HeroBookWnd.DisableWnd");
	ProbabilityRound_Trailer = GetAnimTextureHandle("HeroBookWnd.ProbabilityRound_Trailer");
	Probability_StatusRound = GetStatusRoundHandle("HeroBookWnd.Probability_StatusRound");
	ReceiveSkill_Item = GetItemWindowHandle("HeroBookWnd.ReceiveSkill_Item");
	prvReceivedSkill_Item = GetItemWindowHandle("HeroBookWnd.PrvReceivedSkill_wnd.Skill_Item");
	NextReceiveSkill_Item = GetItemWindowHandle("HeroBookWnd.NextReceivedSkill_wnd.Skill_Item");
	CurrentLevel_text = GetTextBoxHandle("HeroBookWnd.CurrentLevel_text");
	ProbabilityTitle_text = GetTextBoxHandle("HeroBookWnd.ProbabilityTitle_text");
	EffectViewport00 = GetEffectViewportWndHandle("HeroBookWnd.EffectViewport00");
	EffectViewport01 = GetEffectViewportWndHandle("HeroBookWnd.EffectViewport01");
	addRewardLevel_text = GetTextBoxHandle("HeroBookWnd.addRewardLevel_text");
	addRewardicon00_Item = GetItemWindowHandle("HeroBookWnd.AddRewardIcon00_Item");
	addRewardicon01_Item = GetItemWindowHandle("HeroBookWnd.AddRewardIcon01_Item");
	GameStartorCancle_Btn = GetButtonHandle("HeroBookWnd.GameStartorCancle_Btn");
	return;
}

function Load()
{
	initGroupButton();
	return;
}

function OnShow()
{
	PlaySound("InterfaceSound.ui_bookenchant_open");
	GotoState('None');
	GotoState('StateMain');
	SideBar(GetScript("SideBar")).ToggleByWindowName(getCurrentWindowName(string(self)), true);
	return;
}

function OnHide()
{
	EffectViewport00.SpawnEffect("");
	EffectViewport01.SpawnEffect("");
	setStartButton(false);
	if(GetWindowHandle("HeroBookProbabilityWnd").IsShowWindow())
	{
		GetWindowHandle("HeroBookProbabilityWnd").HideWindow();
	}
	if(GetWindowHandle("Confirm_Wnd").IsShowWindow())
	{
		GetWindowHandle("Confirm_Wnd").HideWindow();
	}
	GotoState('StateHide');
	SideBar(GetScript("SideBar")).ToggleByWindowName(getCurrentWindowName(string(self)), false);
	StopSound("InterfaceSound.ui_bookenchant_open");
	return;
}

function initGroupButton()
{
	local int i;
	local string categoryName;

	if((getInstanceUIData().GetIsLiveServer() == false))
	{
		return;
	}
	TopGroupButtonAsset = Class'InterfaceClassic.UIControlGroupButtonAssets'.static._InitScript(GetWindowHandle("HeroBookWnd.HeroBookList_Tab"));
	TopGroupButtonAsset._SetStartInfo("L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Center_Unselected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Center_Selected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Center_Unselected_Over", true);
	TopGroupButtonAsset._GetGroupButtonsInstance().DelegateOnClickButton = DelegateOnClickButton;
	i = 1;
	while((i <= 5))
	{
		categoryName = getCategoryName(i);
		if((categoryName == ""))
		{
			TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonTexture((i - 2), "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Right_Unselected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Right_Selected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Right_Unselected_Over");
			break;
			i++;
			continue;
		}
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText((i - 1), categoryName);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue((i - 1), i);
		if((i == 1))
		{
			TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonTexture(0, "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Left_Unselected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Left_Selected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWnd_Tab_Left_Unselected_Over");
		}
		i++;
	}
	TopGroupButtonAsset._GetGroupButtonsInstance()._setShowButtonNum((i - 1));
	TopGroupButtonAsset._GetGroupButtonsInstance()._setAutoWidth(737, 1);
	TopGroupButtonAsset._GetGroupButtonsInstance()._setTopOrder(0, true);
	nCatogoryNum = 1;
	return;
}

function DelegateOnClickButton(string parentWndName, string strName, int Index)
{
	local int i;

	Debug("----- 탭 -------");  // EN?: Tabs
	Debug(("strName" @ parentWndName));
	Debug(("strName" @ strName));
	Debug(("index" @ string(Index)));
	nCatogoryNum = TopGroupButtonAsset._GetGroupButtonsInstance()._getButtonValue(Index);
	i = 0;
	while((i < books.Length))
	{
		if((books[i].cCategory == nCatogoryNum))
		{
			nCurrentPoint = books[i].nPoint;
			nCurrentLevel = books[i].nLevel;
			nCurrentProb = books[i].nProb;
			break;
		}
		i++;
	}
	Debug((("-------------------" @ string(nCatogoryNum)) @ "-----------------"));
	Debug(("nPoint " @ string(nCurrentPoint)));
	Debug(("nLevel " @ string(nCurrentLevel)));
	Debug(("nProb " @ string(nCurrentProb)));
	if(GetWindowHandle("HeroBookProbabilityWnd").IsShowWindow())
	{
		HeroBookProbabilityWnd(GetScript("HeroBookProbabilityWnd")).refresh(nCurrentLevel);
	}
	if(GetWindowHandle("HeroBookCraftChargingWnd").IsShowWindow())
	{
		HeroBookCraftChargingWnd(GetScript("HeroBookCraftChargingWnd")).refreshSetting();
	}
	GotoState('None');
	GotoState('StateMain');
	Debug(("nCatogoryNum" @ string(nCatogoryNum)));
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "Confirm_Btn":
			OnConfirm_BtnClick();
			break;
		case "Cancle_Btn":
			OnCancle_BtnClick();
			break;
		case "WindowHelp_BTN":
			OnWindowHelp_BTNClick();
			break;
		case "ProbabilityPlus_Btn":
			OnProbabilityPlus_BtnClick();
			break;
		case "GameStartorCancle_Btn":
			OnGameStartorCancle_BtnClick();
			break;
		case "AllListView_Btn":
			OnAllListView_BtnClick();
			break;
		default:
			break;
	}
	return;
}

function OnConfirm_BtnClick()
{
	setStartButton(true);
	GotoState('StateProgress');
	return;
}

function OnCancle_BtnClick()
{
	Confirm_Wnd.HideWindow();
	disableWnd.HideWindow();
	return;
}

function OnWindowHelp_BTNClick()
{
	Class'InterfaceClassic.HelpWnd'.static.ShowHelp(64);
	return;
}

function OnProbabilityPlus_BtnClick()
{
	toggleWindow("HeroBookCraftChargingWnd", true, true);
	return;
}

function OnAllListView_BtnClick()
{
	toggleWindow("HeroBookProbabilityWnd");
	if(GetWindowHandle("HeroBookProbabilityWnd").IsShowWindow())
	{
		HeroBookProbabilityWnd(GetScript("HeroBookProbabilityWnd")).refresh(nCurrentLevel);
	}
	return;
}

function OnGameStartorCancle_BtnClick()
{
	local array<ItemInfo> allItem, EquipItem;
	local int nLimit;

	if((GameStartorCancle_Btn.GetButtonValue() == 1))
	{
		EffectViewport01.SpawnEffect("");
		setStartButton(false);
		GotoState('StateMain');
	}
	else if((GameStartorCancle_Btn.GetButtonValue() == 0))
	{
		Class'NWindow.UIDATA_INVENTORY'.static.GetAllInvenItem(allItem);
		Class'NWindow.UIDATA_INVENTORY'.static.GetAllEquipItem(EquipItem);
		Debug(("allItem" @ string(allItem.Length)));
		Debug(("equipItem" @ string(EquipItem.Length)));
		Debug(("90% 구하기 " @ string(((InventoryWnd(GetScript("InventoryWnd")).GetMyInventoryLimit() * 90) / 100))));  // EN?: Save 90%
		nLimit = ((InventoryWnd(GetScript("InventoryWnd")).GetMyInventoryLimit() * 90) / 100);
		if((GetCanInventoryWeight() && ((allItem.Length + EquipItem.Length) < nLimit)))
		{
			disableWnd.ShowWindow();
			Confirm_Wnd.ShowWindow();
			Confirm_Wnd.SetFocus();
		}
		else
		{
			AddSystemMessage(13719);
		}
	}
	else
	{
		GotoState('StateMain');
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
		return (Per <= 0.8000000);
	}
	return false;
}

function HeroBookData getLastRewardLevelData(int nLevel, out int lastLevel)
{
	local HeroBookData levelData, emptyLevelData;
	local array<HeroBookListData> listDatas;
	local int i;

	Class'NWindow.HeroBookAPI'.static.GetAllHeroBookListData(byte(HeroBookWnd(GetScript("HeroBookWnd")).getCatogoryNum()), listDatas);
	i = (nLevel - 1);
	while((i < listDatas.Length))
	{
		Class'NWindow.HeroBookAPI'.static.GetHeroBookData(byte(nCatogoryNum), (i + 1), levelData);
		if(((listDatas[i].SuccessSkillID > 0) || (listDatas[i].SuccessItemID > 0)))
		{
			lastLevel = (i + 1);
			Debug(("--> lastLevel" @ string(lastLevel)));
			return levelData;
		}
		i++;
	}
	return emptyLevelData;
}

function loadHerobookData(optional bool bResultWindowItem)
{
	local HeroBookData levelData, currentLevelData;
	local bool bIconEnable;

	if(bResultWindowItem)
	{
		Class'NWindow.HeroBookAPI'.static.GetHeroBookData(byte(nCatogoryNum), (nResultLevel + 1), levelData);
		GetMeTextBox("ResultGroup01_wnd.ResultLevel_text").SetText(((GetSystemString(7121) $ " : ") $ string(nCurrentLevel)));
		GetMeTextBox("ResultGroup01_wnd.ResultSkillName_tex").SetText(GetSkillInfoByValue(levelData.BookSkillID, levelData.BookSkillLevel, 0).SkillName);
		setRewardItem(levelData.SuccessItemID, levelData.SuccessItemCount, true);
		setRewardSkill(levelData.SuccessSkillID, levelData.SuccessSkillLevel, true);
		Class'NWindow.HeroBookAPI'.static.GetHeroBookData(byte(nCatogoryNum), nCurrentLevel, levelData);
	}
	else
	{
		levelData = getLastRewardLevelData((nCurrentLevel + 1), nLastRewardLevel);
		if(((nLastRewardLevel - 1) == nCurrentLevel))
		{
			bIconEnable = true;
		}
		setRewardItem(levelData.SuccessItemID, levelData.SuccessItemCount, bIconEnable);
		setRewardSkill(levelData.SuccessSkillID, levelData.SuccessSkillLevel, bIconEnable);
		if((nLastRewardLevel == 0))
		{
			addRewardLevel_text.SetText("");
		}
		else if(((levelData.SuccessItemID <= 0) && (levelData.SuccessSkillID <= 0)))
		{
			addRewardLevel_text.SetText("");
		}
		else
		{
			addRewardLevel_text.SetText(MakeFullSystemMsg(GetSystemMessage(13718), string(nLastRewardLevel)));
		}
	}
	Class'NWindow.HeroBookAPI'.static.GetHeroBookData(byte(nCatogoryNum), nCurrentLevel, currentLevelData);
	setReceiveItem(currentLevelData.BookSkillID, currentLevelData.BookSkillLevel, currentLevelData.PrevSkillID, currentLevelData.PrevSkillLevel, currentLevelData.NextSkillID, currentLevelData.NextSkillLevel);
	return;
}

function setMainUI()
{
	local HeroBookData levelData;
	local SkillInfo pSkillInfo;
	local string perString;

	Class'NWindow.HeroBookAPI'.static.GetHeroBookData(byte(nCatogoryNum), nCurrentLevel, levelData);
	Debug(("nCurrentLevel" @ string(nCurrentLevel)));
	Debug(("nCurrentProb" @ string(nCurrentProb)));
	CurrentLevel_text.SetText(string(nCurrentLevel));
	perString = getInstanceL2Util().MakeDecimalPointString(string(nCurrentProb), 2, true, false);
	if((float(perString) >= 10.0000000))
	{
		GetMeTextBox("MainGroup01_wnd.Probability_text").SetTextColor(GTColor().Yellow2);
	}
	else
	{
		GetMeTextBox("MainGroup01_wnd.Probability_text").SetTextColor(GTColor().BrightGray);
	}
	GetMeTextBox("MainGroup01_wnd.Probability_text").SetText((perString $ "%"));
	Probability_StatusRound.SetPoint(INT64(int(perString)), INT64(100));
	if((int(perString) == 0))
	{
		AnimTextureStop(ProbabilityRound_Trailer, true);
	}
	else
	{
		AnimTexturePlay(ProbabilityRound_Trailer, true);
		circleMove(int(perString), 100);
	}
	pSkillInfo = GetSkillInfoByValue(levelData.BookSkillID, levelData.BookSkillLevel, 0);
	GetMeItemWindow("Confirm_Wnd.ConfirmReceiveSkill_Item").Clear();
	GetMeItemWindow("Confirm_Wnd.ConfirmReceiveSkill_Item").AddItem(getSkillToItemInfo(pSkillInfo));
	GetMeTextBox("Confirm_Wnd.ReceivedSkillLv_Text").SetText((GetSystemString(88) $ string(levelData.BookSkillLevel)));
	GetMeTextBox("Confirm_Wnd.ReceivedSkillName_Text").SetText(pSkillInfo.SkillName);
	GetMeTextBox("Confirm_Wnd.Probability_Text").SetText((perString $ "%"));
	if(((float(perString) >= 10.0000000) && (levelData.NextSkillID > 0)))
	{
		GameStartorCancle_Btn.EnableWindow();
		GameStartorCancle_Btn.ClearTooltip();
		GetMeWindow("MainGroup01_wnd").ShowWindow();
	}
	else
	{
		GameStartorCancle_Btn.DisableWindow();
		if((levelData.NextSkillID <= 0))
		{
			GameStartorCancle_Btn.SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(13908), GTColor().Yellow, , 250));
			GetMeWindow("MainGroup01_wnd").HideWindow();
			addRewardLevel_text.SetText(GetSystemString(898));
		}
		else
		{
			GameStartorCancle_Btn.SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14166), GTColor().White, , 250));
			GetMeWindow("MainGroup01_wnd").ShowWindow();
		}
	}
	return;
}

function setRewardItem(int ItemClassID, int ItemNum, bool bIconEnable)
{
	local ItemInfo Info;

	addRewardicon00_Item.Clear();
	Debug(("setRewardItem: " @ string(ItemClassID)));
	if((ItemClassID > 0))
	{
		Info = GetItemInfoByClassID(ItemClassID);
		Info.ItemNum = INT64(ItemNum);
		addRewardicon00_Item.AddItem(Info);
		addRewardicon00_Item.ShowWindow();
		GetMeTexture("addRewardIconBg00_Tex").ShowWindow();
		if(bIconEnable)
		{
			GetMeTexture("AddRewardDisable00_tex").HideWindow();
		}
		else
		{
			GetMeTexture("AddRewardDisable00_tex").ShowWindow();
		}
	}
	else
	{
		addRewardicon00_Item.HideWindow();
		GetMeTexture("AddRewardDisable00_tex").HideWindow();
		Debug("setRewardItem hide");
	}
	return;
}

function setRewardSkill(int SkillID, int SkillLevel, bool bIconEnable)
{
	addRewardicon01_Item.Clear();
	Debug(("setRewardSkill: " @ string(SkillLevel)));
	if((SkillID > 0))
	{
		addRewardicon01_Item.AddItem(getSkillToItemInfo(GetSkillInfoByValue(SkillID, SkillLevel, 0)));
		addRewardicon01_Item.ShowWindow();
		GetMeTexture("addRewardIconBg01_Tex").ShowWindow();
		if(bIconEnable)
		{
			GetMeTexture("AddRewardDisable01_tex").HideWindow();
		}
		else
		{
			GetMeTexture("AddRewardDisable01_tex").ShowWindow();
		}
	}
	else
	{
		addRewardicon01_Item.HideWindow();
		GetMeTexture("AddRewardDisable01_tex").HideWindow();
		Debug("setRewardSkill hide");
	}
	return;
}

function setReceiveItem(int nBookSkillID, int nBookSkillLevel, int nPrevSkillID, int nPrevSkillLevel, int nNextSkillID, int nNextSkillLevel)
{
	ReceiveSkill_Item.Clear();
	if((nBookSkillID > 0))
	{
		ReceiveSkill_Item.AddItem(getSkillToItemInfo(GetSkillInfoByValue(nBookSkillID, nBookSkillLevel, 0)));
	}
	prvReceivedSkill_Item.Clear();
	if((nPrevSkillID > 0))
	{
		prvReceivedSkill_Item.AddItem(getSkillToItemInfo(GetSkillInfoByValue(nPrevSkillID, nPrevSkillLevel, 0)));
		GetMeTexture("PrvReceivedSkill_wnd.Disable_tex").ShowWindow();
	}
	else
	{
		prvReceivedSkill_Item.EnableWindow();
		GetMeTexture("PrvReceivedSkill_wnd.Disable_tex").HideWindow();
	}
	NextReceiveSkill_Item.Clear();
	if((nNextSkillID > 0))
	{
		NextReceiveSkill_Item.AddItem(getSkillToItemInfo(GetSkillInfoByValue(nNextSkillID, nNextSkillLevel, 0)));
	}
	return;
}

function setStartButton(bool bRun, optional bool noSoundStop)
{
	if(bRun)
	{
		OnCancle_BtnClick();
		Me.KillTimer(1010105);
		Me.SetTimer(1010105, 10);
		Probability_StatusRound.SetPoint(INT64(0), INT64(100));
		circleMove(0, 100);
		nRoundProgress = 0;
		EffectViewport01.SpawnEffect("LineageEffect2.ui_herobook_progress");
		EffectViewport01.SetScale(2.0699999);
		EffectViewport01.SetOffset(setVector(0, 0, 0));
		PlaySound("InterfaceSound.ui_bookenchant_progress");
		HeroBookCraftChargingWnd(GetScript("HeroBookCraftChargingWnd")).setProgress(true);
	}
	else
	{
		Me.KillTimer(1010105);
		Probability_StatusRound.SetPoint(INT64(0), INT64(36));
		EffectViewport00.SpawnEffect("LineageEffect2.ui_herobook_standby");
		HeroBookCraftChargingWnd(GetScript("HeroBookCraftChargingWnd")).setProgress(false);
		if((noSoundStop == false))
		{
			StopSound("InterfaceSound.ui_bookenchant_progress");
		}
	}
	return;
}

function OnTimer(int TimerID)
{
	if((TimerID == 1010105))
	{
		nRoundProgress++;
		Probability_StatusRound.SetPoint(INT64(nRoundProgress), INT64(100));
		circleMove(nRoundProgress, 100);
		if((nRoundProgress >= 100))
		{
			Me.KillTimer(1010105);
			AnimTextureStop(ProbabilityRound_Trailer, true);
			API_C_EX_HERO_BOOK_ENCHANT();
		}
	}
	return;
}

function circleMove(int tickNum, int Cycle)
{
	local float X, Y, Angle, Radius;

	Radius = 82.0000000;
	Angle = ((360.0000000 / float(Cycle)) * float(tickNum));
	X = (Radius * Sin(((3.1400001 * Angle) / 180.0000000)));
	Y = (-Radius * Cos(((3.1400001 * Angle) / 180.0000000)));
	X = ((((Radius + X) + float(Probability_StatusRound.GetRect().nX)) - float((ProbabilityRound_Trailer.GetRect().nWidth / 2))) + 36.0000000);
	Y = ((((Radius + Y) + float(Probability_StatusRound.GetRect().nY)) - float((ProbabilityRound_Trailer.GetRect().nHeight / 2))) + 36.0000000);
	ProbabilityRound_Trailer.MoveTo(int(X), int(Y));
	return;
}

function OnEvent(int a_EventID, string param)
{
	local int nQuitRestrictField;

	switch(a_EventID)
	{
		case (100000 + 1050):
			ParsePacket_S_EX_HERO_BOOK_ENCHANT();
			break;
		case (100000 + 1047):
			ParsePacket_S_EX_HERO_BOOK_INFO();
			break;
		case (100000 + 1048):
			ParsePacket_S_EX_HERO_BOOK_UI();
			break;
		case 40:
			ParseInt(param, "QuitRestrictField", nQuitRestrictField);
			if((nQuitRestrictField == 0))
			{
				nCatogoryNum = 1;
				TopGroupButtonAsset._GetGroupButtonsInstance()._setTopOrder(0, true);
			}
			break;
		default:
			break;
	}
	return;
}

function ParsePacket_S_EX_HERO_BOOK_UI()
{
	Me.ShowWindow();
	Me.SetFocus();
	return;
}

function API_C_EX_HERO_BOOK_ENCHANT()
{
	local array<byte> stream;
	local UIPacket._C_EX_HERO_BOOK_ENCHANT packet;

	nResultLevel = nCurrentLevel;
	Debug("API_C_EX_HERO_BOOK_ENCHANT");
	packet.cCategory = nCatogoryNum;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_HERO_BOOK_ENCHANT(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(806, stream);
	return;
}

function ParsePacket_S_EX_HERO_BOOK_INFO()
{
	local UIPacket._S_EX_HERO_BOOK_INFO packet;
	local int i;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_HERO_BOOK_INFO(packet))
	{
		return;
	}
	books = packet.books;
	i = 0;
	while((i < books.Length))
	{
		if((books[i].cCategory == nCatogoryNum))
		{
			nCurrentPoint = books[i].nPoint;
			nCurrentLevel = books[i].nLevel;
			nCurrentProb = books[i].nProb;
		}
		i++;
	}
	if((GetStateName() == 'StateMain'))
	{
		setMainUI();
	}
	return;
}

function ParsePacket_S_EX_HERO_BOOK_ENCHANT()
{
	local UIPacket._S_EX_HERO_BOOK_ENCHANT packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_HERO_BOOK_ENCHANT(packet))
	{
		return;
	}
	Debug(("결과 " @ string(packet.cResult)));  // EN?: Results
	GotoState('StateResult');
	if((packet.cResult == 0))
	{
		GetMeTextBox("ResultGroup00_wnd.CurrentLevelTitle_text").SetText(GetSystemString(13820));
		EffectViewport01.SpawnEffect("LineageEffect2.ui_Enchant_success");
		EffectViewport01.SetScale(2.0100000);
		EffectViewport01.SetCameraDistance(210.0000000);
		EffectViewport01.SetCameraPitch(-800);
		EffectViewport01.SetCameraYaw(34000);
		EffectViewport01.SetOffset(setVector(0, 0, 0));
		PlaySound("InterfaceSound.ui_bookenchant_success");
		loadHerobookData(true);
	}
	else if((packet.cResult == 1))
	{
		GetMeTextBox("ResultGroup00_wnd.CurrentLevelTitle_text").SetText(GetSystemString(13821));
		EffectViewport01.SpawnEffect("LineageEffect2.ui_Enchant_fail");
		EffectViewport01.SetScale(2.0100000);
		EffectViewport01.SetCameraDistance(210.0000000);
		EffectViewport01.SetCameraPitch(-800);
		EffectViewport01.SetCameraYaw(34000);
		EffectViewport01.SetOffset(setVector(0, 0, 0));
		PlaySound("InterfaceSound.ui_bookenchant_fail");
		loadHerobookData(true);
		addRewardicon00_Item.Clear();
		addRewardicon01_Item.Clear();
		GetMeTexture("addRewardIconBg00_Tex").HideWindow();
		GetMeTexture("addRewardIconBg01_Tex").HideWindow();
	}
	else
	{
		AddSystemMessage(4334);
		Me.HideWindow();
		return;
	}
	setStartButton(false, true);
	return;
}

function string getCategoryName(int nCategory)
{
	switch(nCategory)
	{
		case 1:
			return GetNpcString(1804289);
		case 2:
			return GetNpcString(1804290);
		case 3:
			return GetNpcString(1804291);
		case 4:
			return GetNpcString(1804292);
		case 5:
			return GetNpcString(1804293);
		default:
			return "";
			return "";
	}
}

function int getCatogoryNum()
{
	return nCatogoryNum;
}

function OnReceivedCloseUI()
{
	if(Confirm_Wnd.IsShowWindow())
	{
		OnCancle_BtnClick();
	}
	else
	{
		CloseUI();
	}
	return;
}

state StateHide
{
	function BeginState()
	{
		return;
	}
}

state StateMain
{
	function BeginState()
	{
		local HeroBookData levelData;

		Class'NWindow.HeroBookAPI'.static.GetHeroBookData(byte(nCatogoryNum), nCurrentLevel, levelData);
		Debug(("--> StateMain, nCatogoryNum" @ string(nCatogoryNum)));
		setStartButton(false);
		disableWnd.HideWindow();
		GetMeWindow("MainGroup00_wnd").ShowWindow();
		GetMeWindow("MainGroup01_wnd").ShowWindow();
		GetMeWindow("ResultGroup00_wnd").HideWindow();
		GetMeWindow("ResultGroup01_wnd").HideWindow();
		GameStartorCancle_Btn.SetButtonName(5005);
		GameStartorCancle_Btn.SetButtonValue(0);
		GetMeWindow("NextReceivedSkill_wnd").ShowWindow();
		GetMeWindow("PrvReceivedSkill_wnd").ShowWindow();
		loadHerobookData(false);
		setMainUI();
		return;
	}
}

state StateProgress
{
	function BeginState()
	{
		Debug("StateProgress");
		GetMeWindow("MainGroup00_wnd").HideWindow();
		GetMeWindow("MainGroup01_wnd").HideWindow();
		GetMeWindow("ResultGroup00_wnd").HideWindow();
		GetMeWindow("ResultGroup01_wnd").HideWindow();
		GetMeWindow("NextReceivedSkill_wnd").HideWindow();
		GetMeWindow("PrvReceivedSkill_wnd").HideWindow();
		GameStartorCancle_Btn.SetButtonName(2420);
		GameStartorCancle_Btn.SetButtonValue(1);
		return;
	}
}

state StateResult
{
	function BeginState()
	{
		Debug("StateResult");
		GetMeWindow("MainGroup00_wnd").HideWindow();
		GetMeWindow("MainGroup01_wnd").HideWindow();
		GetMeWindow("ResultGroup00_wnd").ShowWindow();
		GetMeWindow("ResultGroup01_wnd").ShowWindow();
		GetMeWindow("NextReceivedSkill_wnd").HideWindow();
		GetMeWindow("PrvReceivedSkill_wnd").HideWindow();
		GameStartorCancle_Btn.SetButtonName(5158);
		GameStartorCancle_Btn.SetButtonValue(2);
		addRewardLevel_text.SetText(GetSystemString(3853));
		return;
	}
}
