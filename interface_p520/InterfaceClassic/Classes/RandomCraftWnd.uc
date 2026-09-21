class RandomCraftWnd extends UICommonAPI
	dependson(UIPacket);

const Dialog_RandomCraft = 1;
const Dialog_Lock = 2;
const Dialog_Refresh = 3;
const TIME_ID = 1100021;
const TIME_DELAY = 70;

var WindowHandle Me;
var WindowHandle Confirm_Wnd;
var WindowHandle ConfirmNeedItemDialogWnd;
var WindowHandle ConfirmAskDialogWnd;
var TextureHandle Exclamation_Tex;
var string m_Windowname;
var WindowHandle Result_WINDOW;
var TextBoxHandle Result_ItemName_text;
var WindowHandle ConfirmCraftCancelDialogWnd;
var ItemWindowHandle Result_ItemWnd;
var TextureHandle RewardSlotDisable_Tex;
var WindowHandle RandomSlotGroup01_Wnd;
var EffectViewportWndHandle Result_EffectViewport;
var EffectViewportWndHandle Cancle_EffectViewport;
var ProgressCtrlHandle RandomCraftWnd_Progress;
var WindowHandle RandomSlotGroupDisable_Wnd;
var TextBoxHandle RandomSlotGroupDisable_Txt;
var TextureHandle RewardRandomItem_Tex;
var ButtonHandle ItemListReflash_Btn;
var ButtonHandle RandomCraft_Btn;
var ItemWindowHandle RewardSlot_ItemWnd;
var TextBoxHandle ItemPointNum_TextBox;
var TextBoxHandle ItemPointGaugeMax_Txt;
var StatusBarHandle ItemPointNum_StatusBar;
var TextBoxHandle Description_Text;
var TextureHandle ItemPointIcon_tex;
var UIControlNeedItemDialog needItemDialogScript;
var UIControlBasicDialog askDialogScript;
var UIPacket._S_EX_CRAFT_RANDOM_INFO Craft_Ramdom_Info_PacketForUpdate;
var int nCurrentlockCount;
var int nCurrentCraftPoint;
var bool bItemWasReady;
var bool bUseRewardItem;
var WindowHandle RandomCraftProbWnd;

event OnRegisterEvent()
{
	RegisterEvent((100000 + 839));
	RegisterEvent((100000 + 840));
	RegisterEvent((100000 + 838));
	RegisterEvent((100000 + 841));
	return;
}

event OnLoad()
{
	bUseRewardItem = false;
	SetClosingOnESC();
	Initialize();
	initUI();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("RandomCraftWnd");
	Confirm_Wnd = GetWindowHandle("RandomCraftWnd.Confirm_Wnd");
	ConfirmNeedItemDialogWnd = GetWindowHandle("RandomCraftWnd.Confirm_Wnd.ConfirmNeedItemDialogWnd");
	ConfirmAskDialogWnd = GetWindowHandle("RandomCraftWnd.Confirm_Wnd.ConfirmAskDialogWnd");
	RandomCraftWnd_Progress = GetProgressCtrlHandle("RandomCraftWnd.ConfirmCraftCancelDialogWnd.RandomCraftWnd_Progress");
	RandomSlotGroupDisable_Wnd = GetWindowHandle("RandomCraftWnd.RandomSlotGroupDisable_Wnd");
	RandomSlotGroupDisable_Txt = GetTextBoxHandle("RandomCraftWnd.RandomSlotGroupDisable_Wnd.RandomSlotGroupDisable_Txt");
	Result_WINDOW = GetWindowHandle("RandomCraftWnd.Confirm_Wnd.Result_WINDOW");
	ConfirmCraftCancelDialogWnd = GetWindowHandle("RandomCraftWnd.Confirm_Wnd.ConfirmCraftCancelDialogWnd");
	Cancle_EffectViewport = GetEffectViewportWndHandle("RandomCraftWnd.Confirm_Wnd.ConfirmCraftCancelDialogWnd.Cancle_EffectViewport");
	Result_EffectViewport = GetEffectViewportWndHandle("RandomCraftWnd.Result_EffectViewport");
	RewardRandomItem_Tex = GetTextureHandle("RandomCraftWnd.Confirm_Wnd.ConfirmCraftCancelDialogWnd.RewardRandomItem_Tex");
	Result_ItemWnd = GetItemWindowHandle("RandomCraftWnd.Confirm_Wnd.Result_WINDOW.Result_ItemWnd");
	RewardSlotDisable_Tex = GetTextureHandle("RandomCraftWnd.RewardSlotDisable_Tex");
	Result_ItemName_text = GetTextBoxHandle("RandomCraftWnd.Confirm_Wnd.Result_WINDOW.Result_ItemName_text");
	Description_Text = GetTextBoxHandle("RandomCraftWnd.Description_Win.Description_text");
	ItemListReflash_Btn = GetButtonHandle("RandomCraftWnd.ItemListReflash_Btn");
	RandomCraft_Btn = GetButtonHandle("RandomCraftWnd.RandomCraft_Btn");
	RewardSlot_ItemWnd = GetItemWindowHandle("RandomCraftWnd.RewardSlot_ItemWnd");
	ItemPointNum_TextBox = GetTextBoxHandle("RandomCraftWnd.ItemPoint_Wnd.ItemPointNum_TextBox");
	ItemPointNum_TextBox = GetTextBoxHandle("RandomCraftWnd.ItemPoint_Wnd.ItemPointNum_TextBox");
	ItemPointGaugeMax_Txt = GetTextBoxHandle("RandomCraftWnd.ItemPoint_Wnd.ItemPointGaugeMax_Txt");
	ItemPointNum_StatusBar = GetStatusBarHandle("RandomCraftWnd.ItemPoint_Wnd.ItemPointNum_StatusBar");
	ItemPointIcon_tex = GetTextureHandle("RandomCraftWnd.ItemPoint_Wnd.ItemPointIcon_tex");
	SetScript_UIControlNeedItemDialog();
	SetScript_UIControlBaseDialog();
	Confirm_Wnd.HideWindow();
	Result_WINDOW.HideWindow();
	ConfirmCraftCancelDialogWnd.HideWindow();
	if((bUseRewardItem == false))
	{
		SetHideRewardInfos();
	}
	return;
}

function SetHideRewardInfos()
{
	local int add_w, original_W_ItemPoint_Wnd, original_W_ItemPointNum_StatusBar;

	add_w = 74;
	original_W_ItemPoint_Wnd = 432;
	original_W_ItemPointNum_StatusBar = 376;
	GetWindowHandle("RandomCraftWnd.ItemPoint_Wnd").SetWindowSize((original_W_ItemPoint_Wnd + add_w), 48);
	ItemPointNum_StatusBar.SetWindowSize((original_W_ItemPointNum_StatusBar + add_w), 12);
	ItemPointGaugeMax_Txt.SetAnchor("RandomCraftWnd.ItemPoint_Wnd.ItemPointNum_StatusBar", "TopCenter", "TopCenter", -15, -1);
	RewardSlot_ItemWnd.HideWindow();
	GetWindowHandle("RandomCraftWnd.RewardSlotDivider_Tex").HideWindow();
	return;
}

event OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)), "RandomCraftChargingWnd");
	API_C_EX_CRAFT_RANDOM_INFO();
	updateStateRefresButton();
	updateDescTextField();
	return;
}

event OnHide()
{
	Cancle_EffectViewport.SpawnEffect("");
	Result_EffectViewport.SpawnEffect("");
	hideAllDialog();
	Me.KillTimer(1100021);
	return;
}

function initUI()
{
	local int i;

	i = 1;
	while((i < 6))
	{
		playSlotAnimEffect_RefreshTime(i, false);
		playSlotAnimEffect_GoodItem(i, RCAG_None);
		i++;
	}
	RandomCraftWnd_Progress.SetProgressTime(1500);
	RandomCraftWnd_Progress.SetPos(0);
	RandomCraftWnd_Progress.Reset();
	RandomSlotGroupDisable_Wnd.HideWindow();
	ItemListReflash_Btn.DisableWindow();
	RandomCraft_Btn.DisableWindow();
	RewardSlotDisable_Tex.HideWindow();
	return;
}

function CustomTooltip setLockCustomTooltip(string lockString)
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;
	local RandomCraftAPI.ItemAmount needItemAmout;
	local string iconTexture, lockCountStr, lockTitle;
	local ItemInfo Info;
	local int W, h, nMaxLockCount;
	local Color lockColor;

	lockTitle = lockString;
	if((lockString == GetSystemString(1072)))
	{
		lockColor = getInstanceL2Util().ColorGray;
	}
	else if((lockString == GetSystemString(13195)))
	{
		lockColor = getInstanceL2Util().Yellow;
	}
	else if((lockString == GetSystemString(13176)))
	{
		lockColor = getInstanceL2Util().BrightWhite;
	}
	else if((lockString == GetSystemString(13192)))
	{
		lockTitle = ((lockString $ ": ") $ GetSystemString(13193));
		lockColor = getInstanceL2Util().Red2;
	}
	drawListArr[drawListArr.Length] = addDrawItemText(lockString, lockColor, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13177), getInstanceL2Util().ColorDesc, "", true, false);
	nMaxLockCount = int(Class'NWindow.RandomCraftAPI'.static.GetMaxSlotLockCount());
	if((nCurrentlockCount >= nMaxLockCount))
	{
		lockCountStr = ((GetSystemString(13194) $ ": ") $ GetSystemString(27));
	}
	else
	{
		lockCountStr = ((((GetSystemString(13194) $ ": ") $ string((nMaxLockCount - nCurrentlockCount))) $ " / ") $ string(nMaxLockCount));
	}
	if((nCurrentlockCount == nMaxLockCount))
	{
		lockColor = getInstanceL2Util().Red2;
	}
	else
	{
		lockColor = getInstanceL2Util().Green;
	}
	drawListArr[drawListArr.Length] = addDrawItemText(lockCountStr, lockColor, "", true, true);
	if(((lockString != GetSystemString(13192)) && (nCurrentlockCount != nMaxLockCount)))
	{
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = addDrawItemText((("<" $ GetSystemString(13179)) $ ">"), getInstanceL2Util().White, "", true, true);
		needItemAmout = Class'NWindow.RandomCraftAPI'.static.GetItemLockCost(byte(nCurrentlockCount));
		iconTexture = Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(GetItemID(needItemAmout.ItemClassID));
		Info = GetItemInfoByClassID(needItemAmout.ItemClassID);
		GetTextSizeDefault(Info.Name, W, h);
		drawListArr[drawListArr.Length] = addDrawItemTextureCustom(iconTexture, false, true, 5, 4, 32, 32);
		drawListArr[drawListArr.Length] = addDrawItemText(Info.Name, getInstanceL2Util().ColorDesc, "", false, false, 4, 6);
		drawListArr[drawListArr.Length] = addDrawItemText(("x" $ MakeCostStringINT64(INT64(needItemAmout.Amount))), getInstanceL2Util().ColorYellow, , false, false, -W, (h + 4));
	}
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 240;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;
}

function SetScript_UIControlNeedItemDialog()
{
	local string m_name;

	m_name = (m_Windowname $ ".Confirm_Wnd.ConfirmNeedItemDialogWnd");
	ConfirmNeedItemDialogWnd = GetWindowHandle(m_name);
	ConfirmNeedItemDialogWnd.SetScript("UIControlNeedItemDialog");
	needItemDialogScript = UIControlNeedItemDialog(ConfirmNeedItemDialogWnd.GetScript());
	needItemDialogScript.SetWindow(m_name);
	needItemDialogScript.DelegateOnClickCancleButton = OnClickHideDialog;
	needItemDialogScript.DelegateOnClickOkButton = OnClickOkDialog;
	return;
}

function SetScript_UIControlBaseDialog()
{
	local string m_name;

	m_name = (m_Windowname $ ".Confirm_Wnd.ConfirmAskDialogWnd");
	ConfirmAskDialogWnd = GetWindowHandle(m_name);
	ConfirmAskDialogWnd.SetScript("UIControlBasicDialog");
	askDialogScript = UIControlBasicDialog(ConfirmAskDialogWnd.GetScript());
	askDialogScript.SetWindow(m_name);
	askDialogScript.DelegateOnClickCancleButton = OnClickHideDialog;
	return;
}

function OnClickHideDialog(optional int nDialogKey)
{
	hideAllDialog();
	return;
}

function OnClickOkDialog(optional int nDialogKey)
{
	hideAllDialog();
	if((nDialogKey == 1))
	{
		Confirm_Wnd.ShowWindow();
		ConfirmCraftCancelDialogWnd.ShowWindow();
		RandomCraftWnd_Progress.ShowWindow();
		RandomCraftWnd_Progress.SetProgressTime(1500);
		RandomCraftWnd_Progress.SetPos(0);
		RandomCraftWnd_Progress.Reset();
		RandomCraftWnd_Progress.Start();
		Cancle_EffectViewport.SpawnEffect("LineageEffect2.ui_soul_crystal");
		RewardRandomItem_Tex.SetTexture("");
		Me.KillTimer(1100021);
		Me.SetTimer(1100021, 70);
	}
	else if((nDialogKey == 2))
	{
		API_C_EX_CRAFT_RANDOM_LOCK_SLOT(needItemDialogScript.GetReservedInt());
	}
	else if((nDialogKey == 3))
	{
		API_C_EX_CRAFT_RANDOM_REFRESH();
	}
	return;
}

function string getRandomItemName()
{
	local ItemInfo Info;
	local string sTexture;

	GetItemWindowHandle((("RandomCraftWnd.RandomSlotGroup0" $ string((Rand(5) + 1))) $ "_Wnd.RandomSlot_ItemWnd")).GetItem(0, Info);
	if((Info.Id.ClassID > 0))
	{
		sTexture = Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(Info.Id);
	}
	return sTexture;
}

event OnTimer(int TimerID)
{
	local string sTexture;

	if((TimerID == 1100021))
	{
		sTexture = getRandomItemName();
		if((RewardRandomItem_Tex.GetTextureName() == sTexture))
		{
			sTexture = getRandomItemName();
		}
		RewardRandomItem_Tex.SetTexture(sTexture);
	}
	return;
}

event OnProgressTimeUp(string strID)
{
	if((strID == "RandomCraftWnd_Progress"))
	{
		hideAllDialog();
		Confirm_Wnd.ShowWindow();
		API_C_EX_CRAFT_RANDOM_MAKE();
	}
	return;
}

function playSlotAnimEffect_RefreshTime(int nSlotIndex, bool bShow)
{
	local string ctrlPath;

	ctrlPath = (("RandomCraftWnd.RandomSlotGroup0" $ string(nSlotIndex)) $ "_Wnd.ItemListReflash_AniTex");
	if(bShow)
	{
		AnimTexturePlay(GetAnimTextureHandle(ctrlPath), true, 1);
	}
	else
	{
		AnimTextureStop(GetAnimTextureHandle(ctrlPath), true);
	}
	return;
}

function playSlotAnimEffect_GoodItem(int nSlotIndex, UIEventManager.RandomCraftAnnounceGrade Grade)
{
	local AnimTextureHandle aniTexture;

	aniTexture = GetPlaySlotAnimEffectCtrlTextureBySlotIndex(nSlotIndex);
	if((int(Grade) == 1))
	{
		aniTexture.ShowWindow();
		AnimTexturePlay(aniTexture, true, 9999999);
	}
	else
	{
		aniTexture.HideWindow();
		AnimTextureStop(aniTexture, true);
	}
	return;
}

function setSlot(int nSlotIndex, int nlockRemainNum, byte bLocked, int nItemClassID, INT64 nItemAmount)
{
	local array<byte> slotSuccessRateArr;
	local TextureHandle lockTexture, LockBtnLocked_Tex;
	local ItemInfo Info;
	local UIEventManager.RandomCraftAnnounceGrade Grade;
	local int nMaxLockCount, nMaxItemLockCount;

	lockTexture = GetLockTexBySlotIndex(nSlotIndex);
	LockBtnLocked_Tex = GetLockBtnLockedTexBySlotIndex(nSlotIndex);
	nMaxLockCount = int(Class'NWindow.RandomCraftAPI'.static.GetMaxSlotLockCount());
	nMaxItemLockCount = int(Class'NWindow.RandomCraftAPI'.static.GetMaxItemLockCount());
	slotSuccessRateArr = Class'NWindow.RandomCraftAPI'.static.GetSlotsSuccessRate();
	GetTextBoxHandle((("RandomCraftWnd.RandomSlotGroup0" $ string(nSlotIndex)) $ "_Wnd.Probability_textbox")).SetText((string(slotSuccessRateArr[(nSlotIndex - 1)]) $ "%"));
	GetTextBoxHandle((("RandomCraftWnd.RandomSlotGroup0" $ string(nSlotIndex)) $ "_Wnd.LockNum_textbox")).SetText(((string(nlockRemainNum) $ "/") $ string(nMaxItemLockCount)));
	GetItemWindowHandle((("RandomCraftWnd.RandomSlotGroup0" $ string(nSlotIndex)) $ "_Wnd.RandomSlot_ItemWnd")).Clear();
	if((nItemClassID > 0))
	{
		Info = GetItemInfoByClassID(nItemClassID);
		if(isCollectionItem(Info))
		{
			Info.ForeTexture = "L2UI_EPIC.Icon.IconPanel_coll";
		}
		if((nItemAmount > INT64(0)))
		{
			Info.ItemNum = nItemAmount;
		}
		GetItemWindowHandle((("RandomCraftWnd.RandomSlotGroup0" $ string(nSlotIndex)) $ "_Wnd.RandomSlot_ItemWnd")).AddItem(Info);
		Grade = Class'NWindow.RandomCraftAPI'.static.GetItemAnnounceGrade(Info.Id.ClassID);
		playSlotAnimEffect_GoodItem(nSlotIndex, Grade);
	}
	if((nlockRemainNum <= 0))
	{
		GetTextBoxHandle((("RandomCraftWnd.RandomSlotGroup0" $ string(nSlotIndex)) $ "_Wnd.LockNum_textbox")).SetTextColor(getInstanceL2Util().Red3);
		lockTexture.SetTexture((GetPlaySlotCardBackImageByGrade(Grade) $ "_Disabled"));
		LockBtnLocked_Tex.SetTexture("L2UI_EPIC.RandomCraftWnd.RandomCraftWnd_Lock_DisUn");
		GetLock_BtnBySlotIndex(nSlotIndex).ShowWindow();
		GetLock_BtnBySlotIndex(nSlotIndex).DisableWindow();
		GetLock_StateBGTexBySlotIndex(nSlotIndex).HideWindow();
	}
	else
	{
		GetTextBoxHandle((("RandomCraftWnd.RandomSlotGroup0" $ string(nSlotIndex)) $ "_Wnd.LockNum_textbox")).SetTextColor(getInstanceL2Util().White);
		if((int(bLocked) > 0))
		{
			lockTexture.SetTexture((GetPlaySlotCardBackImageByGrade(Grade) $ "_Locked"));
			GetLock_BtnBySlotIndex(nSlotIndex).HideWindow();
			GetLock_StateBGTexBySlotIndex(nSlotIndex).ShowWindow();
			LockBtnLocked_Tex.SetTexture("L2UI_EPIC.RandomCraftWnd.RandomCraftWnd_Lock");
		}
		else
		{
			GetLock_BtnBySlotIndex(nSlotIndex).ShowWindow();
			GetLock_BtnBySlotIndex(nSlotIndex).EnableWindow();
			GetLock_StateBGTexBySlotIndex(nSlotIndex).HideWindow();
			lockTexture.SetTexture((GetPlaySlotCardBackImageByGrade(Grade) $ "_Normal"));
		}
	}
	if((nCurrentlockCount == nMaxLockCount))
	{
		GetTextBoxHandle((("RandomCraftWnd.RandomSlotGroup0" $ string(nSlotIndex)) $ "_Wnd.LockNum_textbox")).SetTextColor(getInstanceL2Util().Gray);
	}
	return;
}

event OnClickButtonWithHandle(ButtonHandle aButtonHandle)
{
	local string parentname;
	local int idx, lockIndex;

	parentname = aButtonHandle.GetParentWindowName();
	if((aButtonHandle.GetWindowName() == "ProbBtn"))
	{
		ToggleRandomCraftProbWnd();
	}
	else if((Left(parentname, Len("RandomSlotGroup")) == "RandomSlotGroup"))
	{
		idx = (InStr(parentname, "_Wnd") - 1);
		lockIndex = int(Mid(parentname, idx, 1));
		if((nCurrentlockCount < int(Class'NWindow.RandomCraftAPI'.static.GetMaxSlotLockCount())))
		{
			tryDialogRandomCraft(2, (lockIndex - 1));
		}
		else
		{
			getInstanceL2Util().showGfxScreenMessage(GetSystemString(13177));
		}
	}
	return;
}

function ToggleRandomCraftProbWnd()
{
	if(GetWindowHandle("RandomCraftProbWnd").IsShowWindow())
	{
		GetWindowHandle("RandomCraftProbWnd").HideWindow();
	}
	else
	{
		GetWindowHandle("RandomCraftProbWnd").ShowWindow();
	}
	return;
}

event OnClickButton(string Name)
{
	Debug(("OnClickButton: " @ Name));
	switch(Name)
	{
		case "HelpWnd_Btn":
			ExecuteEvent(1210, "49");
			break;
		case "ResultOK_BTN":
			OnResult_BTNClick();
			break;
		case "ItemListReflash_Btn":
			OnItemListReflash_BtnClick();
			break;
		case "ItemPointCharge_Btn":
			toggleWindow("RandomCraftChargingWnd", true, true);
			break;
		case "RandomCraft_Btn":
			tryDialogRandomCraft(1);
			break;
		case "CraftCancel_Btn":
			RandomCraftWnd_Progress.Stop();
			hideAllDialog();
			break;
		case "":
			break;
		default:
			break;
	}
	return;
}

function tryDialogRandomCraft(int nDialogKey, optional int nLockIndex)
{
	local RandomCraftAPI.ItemAmount costItemAmout;
	local array<RandomCraftAPI.ItemAmount> ItemCostArr;
	local int i;

	if((nDialogKey == 1))
	{
		ItemCostArr = Class'NWindow.RandomCraftAPI'.static.GetItemMakingCosts();
	}
	else if((nDialogKey == 3))
	{
		ItemCostArr = Class'NWindow.RandomCraftAPI'.static.GetRestCosts();
	}
	else
	{
		costItemAmout = Class'NWindow.RandomCraftAPI'.static.GetItemLockCost(byte(nCurrentlockCount));
	}
	Confirm_Wnd.ShowWindow();
	Result_WINDOW.HideWindow();
	ConfirmAskDialogWnd.HideWindow();
	ConfirmNeedItemDialogWnd.ShowWindow();
	ConfirmNeedItemDialogWnd.SetFocus();
	if((nDialogKey == 1))
	{
		needItemDialogScript.setInit(GetSystemString(13182), nDialogKey);
	}
	else if((nDialogKey == 3))
	{
		needItemDialogScript.setInit(GetSystemString(13197), nDialogKey);
	}
	else
	{
		needItemDialogScript.setInit(GetSystemString(13181), nDialogKey);
		needItemDialogScript.SetReservedInt(nLockIndex);
	}
	if((ItemCostArr.Length > 0))
	{
		needItemDialogScript.StartNeedItemList();
		i = 0;
		while((i < ItemCostArr.Length))
		{
			needItemDialogScript.AddNeedItem(ItemCostArr[i].ItemClassID, INT64(ItemCostArr[i].Amount));
			i++;
		}
		needItemDialogScript.EndNeedItemList();
	}
	else
	{
		needItemDialogScript.StartNeedItemList();
		needItemDialogScript.AddNeedItem(costItemAmout.ItemClassID, INT64(costItemAmout.Amount));
		needItemDialogScript.EndNeedItemList();
	}
	return;
}

function OnResult_BTNClick()
{
	Confirm_Wnd.HideWindow();
	Result_WINDOW.HideWindow();
	return;
}

function OnItemListReflash_BtnClick()
{
	tryDialogRandomCraft(3);
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 9750:
			initUI();
			break;
		case EV_PacketID(838):
			ParsePacket_S_EX_CRAFT_RANDOM_INFO();
			break;
		case EV_PacketID(839):
			ParsePacket_S_EX_CRAFT_RANDOM_LOCK_SLOT();
			break;
		case EV_PacketID(840):
			ParsePacket_S_EX_CRAFT_RANDOM_REFRESH();
			break;
		case EV_PacketID(841):
			ParsePacket_S_EX_CRAFT_RANDOM_MAKE();
			break;
		default:
			break;
	}
	return;
}

function ParsePacket_S_EX_CRAFT_RANDOM_MAKE()
{
	local UIPacket._S_EX_CRAFT_RANDOM_MAKE packet;
	local ItemInfo Info;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_CRAFT_RANDOM_MAKE(packet))
	{
		return;
	}
	if((packet.cResult == 0))
	{
		hideAllDialog();
		Confirm_Wnd.ShowWindow();
		Result_WINDOW.ShowWindow();
		Info = GetItemInfoByClassID(packet.Result.nItemClassID);
		Info.ItemNum = packet.Result.nAmount;
		Info.Enchanted = packet.Result.cEnchanted;
		if(isCollectionItem(Info))
		{
			Info.ForeTexture = "L2UI_EPIC.Icon.IconPanel_coll";
		}
		Result_ItemWnd.Clear();
		Result_ItemWnd.AddItem(Info);
		Result_ItemName_text.SetText(GetItemNameAll(Info));
		Result_EffectViewport.SpawnEffect("LineageEffect2.ui_upgrade_succ");
		Result_EffectViewport.SetFocus();
	}
	else
	{
		Me.HideWindow();
	}
	return;
}

function updateStateRefresButton()
{
	if((nCurrentCraftPoint > 0))
	{
		ItemListReflash_Btn.EnableWindow();
	}
	else
	{
		ItemListReflash_Btn.DisableWindow();
	}
	return;
}

function updateDescTextField()
{
	if(ItemListReflash_Btn.IsEnableWindow())
	{
		RandomSlotGroupDisable_Txt.SetText(GetSystemString(13190));
	}
	else
	{
		RandomSlotGroupDisable_Txt.SetText(GetSystemString(13191));
	}
	return;
}

function ParsePacket_S_EX_CRAFT_INFO(UIPacket._S_EX_CRAFT_INFO packet)
{
	local float fPer;
	local int maxGauge;
	local ItemInfo Info;
	local int currentCharge, MaxPoint;
	local RandomCraftAPI.ItemAmount sItemAmout;
	local array<RandomCraftAPI.ItemAmount> RewardItems;

	MaxPoint = int(Class'NWindow.RandomCraftAPI'.static.GetMaxItemPoint());
	maxGauge = Class'NWindow.RandomCraftAPI'.static.GetMaxGaugeValue();
	ItemPointNum_TextBox.SetText(("x" $ string(packet.nPoint)));
	nCurrentCraftPoint = packet.nPoint;
	if((nCurrentCraftPoint > 0))
	{
		ItemListReflash_Btn.EnableWindow();
	}
	else
	{
		ItemListReflash_Btn.DisableWindow();
	}
	if(((packet.nPoint >= MaxPoint) && (packet.nCharge >= (maxGauge - 1))))
	{
		ItemPointGaugeMax_Txt.SetText("Max");
	}
	else
	{
		currentCharge = int(getInstanceL2Util().Get9999Percent(INT64(packet.nCharge), INT64(maxGauge)));
		fPer = ((float(currentCharge) / float(maxGauge)) * 100.0000000);
		ItemPointGaugeMax_Txt.SetText(getInstanceL2Util().cutFloat(fPer));
	}
	ItemPointNum_StatusBar.SetPoint(INT64(packet.nCharge), INT64(maxGauge));
	RewardItems = Class'NWindow.RandomCraftAPI'.static.GetRewardItems();
	if((RewardItems.Length > 0))
	{
		sItemAmout = RewardItems[0];
	}
	RewardSlot_ItemWnd.Clear();
	Info = GetItemInfoByClassID(sItemAmout.ItemClassID);
	Info.ItemNum = INT64(sItemAmout.Amount);
	if(isCollectionItem(Info))
	{
		Info.ForeTexture = "L2UI_EPIC.Icon.IconPanel_coll";
	}
	RewardSlot_ItemWnd.AddItem(Info);
	if((int(packet.bGiveItem) > 0))
	{
		RewardSlotDisable_Tex.HideWindow();
		ItemPointIcon_tex.SetTexture("L2UI_CT1.InfoWnd.InfoWnd_RandomCraftIcon");
	}
	else
	{
		if((bUseRewardItem == true))
		{
			RewardSlotDisable_Tex.ShowWindow();
		}
		ItemPointIcon_tex.SetTexture("L2UI_CT1.InfoWnd.InfoWnd_RandomCraftIcon_dis");
	}
	updateDescTextField();
	return;
}

function ParsePacket_S_EX_CRAFT_RANDOM_INFO(optional bool bUpdate)
{
	local UIPacket._S_EX_CRAFT_RANDOM_INFO packet;
	local int i, nMaxLockCount;
	local string lockString;

	if(bUpdate)
	{
		packet = Craft_Ramdom_Info_PacketForUpdate;
	}
	else
	{
		if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_CRAFT_RANDOM_INFO(packet))
		{
			return;
		}
		Craft_Ramdom_Info_PacketForUpdate = packet;
	}
	nMaxLockCount = int(Class'NWindow.RandomCraftAPI'.static.GetMaxSlotLockCount());
	nCurrentlockCount = 0;
	bItemWasReady = false;
	i = 0;
	while((i < packet.slotInfoList.Length))
	{
		if(((((int(packet.slotInfoList[i].bLocked) == 0) && (packet.slotInfoList[i].nLockRemain == 0)) && (packet.slotInfoList[i].nItemClassID == 0)) && (packet.slotInfoList[i].nItemAmount == INT64(0))))
		{
		}
		else
		{
			bItemWasReady = true;
		}
		if(((int(packet.slotInfoList[i].bLocked) > 0) || (packet.slotInfoList[i].nLockRemain == 0)))
		{
			nCurrentlockCount++;
		}
		i++;
	}
	if((nCurrentlockCount >= nMaxLockCount))
	{
		nCurrentlockCount = nMaxLockCount;
	}
	i = 0;
	while((i < packet.slotInfoList.Length))
	{
		setSlot((i + 1), packet.slotInfoList[i].nLockRemain, packet.slotInfoList[i].bLocked, packet.slotInfoList[i].nItemClassID, packet.slotInfoList[i].nItemAmount);
		if((packet.slotInfoList[i].nLockRemain <= 0))
		{
			lockString = GetSystemString(1072);
		}
		else if((int(packet.slotInfoList[i].bLocked) > 0))
		{
			lockString = GetSystemString(13195);
		}
		else if((nCurrentlockCount >= nMaxLockCount))
		{
			lockString = GetSystemString(13192);
		}
		else
		{
			lockString = GetSystemString(13176);
		}
		GetLock_StateBGTexBySlotIndex((i + 1)).SetTooltipCustomType(setLockCustomTooltip(lockString));
		GetLock_BtnBySlotIndex((i + 1)).SetTooltipCustomType(setLockCustomTooltip(lockString));
		i++;
	}
	if(bItemWasReady)
	{
		RandomSlotGroupDisable_Wnd.HideWindow();
		RandomSlotGroupDisable_Txt.HideWindow();
		RandomCraft_Btn.EnableWindow();
		Description_Text.SetText(GetSystemString(13175));
	}
	else
	{
		RandomSlotGroupDisable_Wnd.ShowWindow();
		RandomSlotGroupDisable_Txt.ShowWindow();
		RandomCraft_Btn.DisableWindow();
		Description_Text.SetText("");
	}
	updateDescTextField();
	return;
}

function ParsePacket_S_EX_CRAFT_RANDOM_LOCK_SLOT()
{
	local UIPacket._S_EX_CRAFT_RANDOM_LOCK_SLOT packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_CRAFT_RANDOM_LOCK_SLOT(packet))
	{
		return;
	}
	Debug((" -->  Decode_S_EX_CRAFT_RANDOM_LOCK_SLOT : " @ string(packet.cResult)));
	ParsePacket_S_EX_CRAFT_RANDOM_INFO(true);
	return;
}

function ParsePacket_S_EX_CRAFT_RANDOM_REFRESH()
{
	local UIPacket._S_EX_CRAFT_RANDOM_REFRESH packet;
	local int i;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_CRAFT_RANDOM_REFRESH(packet))
	{
		return;
	}
	Debug((" -->  Decode_S_EX_CRAFT_RANDOM_REFRESH : " @ string(packet.cResult)));
	if((packet.cResult == 0))
	{
		i = 1;
		while((i < 6))
		{
			if((GetLockTexBySlotIndex(i).GetTextureName() != "RandomCraftWnd_Slot_Locked"))
			{
				playSlotAnimEffect_RefreshTime(i, true);
			}
			i++;
		}
	}
	return;
}

event OnTextureAnimEnd(AnimTextureHandle a_WindowHandle)
{
	switch(a_WindowHandle.GetWindowName())
	{
		case "ItemSlot_AniTex1":
			break;
		default:
			a_WindowHandle.HideWindow();
			break;
	}
	return;
}

function API_C_EX_CRAFT_RANDOM_REFRESH()
{
	local array<byte> stream;

	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(622, stream);
	Debug("----> Api Call : C_EX_CRAFT_RANDOM_REFRESH (제작 목록 갱신)");  // EN?: ---- > Api Call: C_EX_craft_random_refresh
	return;
}

function API_C_EX_CRAFT_RANDOM_MAKE()
{
	local array<byte> stream;

	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(623, stream);
	Debug("----> Api Call : C_EX_CRAFT_RANDOM_MAKE (랜덤 제작)");  // EN?: ---- > Api Call: C_EX_craft_random_make (Random)
	return;
}

function API_C_EX_CRAFT_RANDOM_INFO()
{
	local array<byte> stream;

	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(620, stream);
	Debug("----> Api Call : C_EX_CRAFT_RANDOM_INFO (제작 정보)");  // EN?: ---- > Api Call: C_EX_craft_random_info (Production Information)
	return;
}

function API_C_EX_CRAFT_RANDOM_LOCK_SLOT(int nSlot)
{
	local array<byte> stream;
	local UIPacket._C_EX_CRAFT_RANDOM_LOCK_SLOT packet;

	packet.nSlot = nSlot;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_CRAFT_RANDOM_LOCK_SLOT(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(621, stream);
	Debug(("----> Api Call : C_EX_CRAFT_RANDOM_LOCK_SLOT (슬롯 잠그기)" @ string(nSlot)));  // EN?: ---- > Api Call: C_EX_craft_random_LOCK_slot (lock slot)
	return;
}

function hideAllDialog()
{
	Confirm_Wnd.HideWindow();
	ConfirmAskDialogWnd.HideWindow();
	ConfirmNeedItemDialogWnd.HideWindow();
	Result_WINDOW.HideWindow();
	ConfirmCraftCancelDialogWnd.HideWindow();
	Me.KillTimer(1100021);
	return;
}

function string GetPlaySlotCardBackImageByGrade(UIEventManager.RandomCraftAnnounceGrade Grade)
{
	local string ctrlPath;

	switch(Grade)
	{
		case RCAG_None:
			ctrlPath = "L2UI_EPIC.RandomCraftWnd.RandomCraftWnd_Slot00";
			break;
		case RCAG_1:
			ctrlPath = "L2UI_EPIC.RandomCraftWnd.RandomCraftWnd_Slot03";
			break;
		case RCAG_2:
			ctrlPath = "L2UI_EPIC.RandomCraftWnd.RandomCraftWnd_Slot02";
			break;
		case RCAG_3:
			ctrlPath = "L2UI_EPIC.RandomCraftWnd.RandomCraftWnd_Slot01";
			break;
		default:
			ctrlPath = "L2UI_EPIC.RandomCraftWnd.RandomCraftWnd_Slot00";
			break;
	}
	return ctrlPath;
}

function TextureHandle GetLock_StateBGTexBySlotIndex(int nSlotIndex)
{
	return GetTextureHandle((("RandomCraftWnd.RandomSlotGroup0" $ string(nSlotIndex)) $ "_Wnd.Lock_StateBG"));
}

function ButtonHandle GetLock_BtnBySlotIndex(int nSlotIndex)
{
	return GetButtonHandle((("RandomCraftWnd.RandomSlotGroup0" $ string(nSlotIndex)) $ "_Wnd.Lock_Btn"));
}

function AnimTextureHandle GetPlaySlotAnimEffectCtrlTextureBySlotIndex(int nSlotIndex)
{
	return GetAnimTextureHandle((("RandomCraftWnd.RandomSlotGroup0" $ string(nSlotIndex)) $ "_Wnd.ItemSlot_AniTex1"));
}

function TextureHandle GetLockTexBySlotIndex(int nSlotIndex)
{
	return GetTextureHandle((("RandomCraftWnd.RandomSlotGroup0" $ string(nSlotIndex)) $ "_Wnd.RandomSlot_Lock_Tex"));
}

function TextureHandle GetLockBtnLockedTexBySlotIndex(int nSlotIndex)
{
	return GetTextureHandle((("RandomCraftWnd.RandomSlotGroup0" $ string(nSlotIndex)) $ "_Wnd.LockBtnLocked_Tex"));
}

event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	if(Confirm_Wnd.IsShowWindow())
	{
		hideAllDialog();
	}
	else if(GetWindowHandle("RandomCraftProbWnd").IsShowWindow())
	{
		GetWindowHandle("RandomCraftProbWnd").HideWindow();
	}
	else
	{
		GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	}
	return;
}

defaultproperties
{
	m_Windowname="RandomCraftWnd"
}
