class MagicLampWnd extends UICommonAPI;

const TIMER_ID = 11231;
const TIMER_DELAY = 2000;
const TRY_MAX = 1000;
const HighGradeItemClassID = 91641;

enum GameMode
{
	NormalMode,                     // 0
	AdvancedMode                    // 1
};

var WindowHandle Me;
var TextureHandle CostBg_Tex;
var TextureHandle GameStartCancleBg_Tex;
var WindowHandle MagicLampResultWnd;
var TextureHandle MagicLampResultBg_Tex;
var TextureHandle MagicLampResultBgPattern_Tex;
var ButtonHandle Ok_Btn;
var TextBoxHandle MagicLampResultTitle_Txt;
var TextureHandle MagicLamp_Tex;
var TextureHandle VoucherIcon_Tex;
var TextureHandle VoucherIconBg_Tex;
var TextureHandle NumofPlayTxtBg_Tex;
var ButtonHandle NumofPlayUp_Btn;
var ButtonHandle NumofPlayDown_Btn;
var ButtonHandle NumofPlayMax_Btn;
var ButtonHandle GameStartorCancle_Btn;
var TextBoxHandle VoucherName_Txt;
var TextBoxHandle VoucherNum_Txt;
var TextBoxHandle VoucherMyNum_Txt;
var TextBoxHandle NumofPlayTitle_Txt;
var EditBoxHandle NumofPlay_EditBox;
var EffectViewportWndHandle EffectViewport01;
var EffectViewportWndHandle EffectViewport02;
var WindowHandle disableWnd;
var TextBoxHandle AdenaName_Txt;
var TextBoxHandle AdenaMyNum_Txt;
var TextureHandle AdenaIcon_Tex;
var TextBoxHandle AllExpNum_Txt;
var TextBoxHandle AllSpNum_Txt;
var CheckBoxHandle Advanced_CheckBox;
var WindowHandle MagicLampProbability_Wnd;
var int needPerGameForAdvanced;
var int TryMaxCount;
var int nGameCount;
var int nCountPerGame;
var int nCount;
var int nSize;
var int nGameMode;
var bool bIsGameStartClick;
var INT64 nHighgradeAmount;

event OnRegisterEvent()
{
	RegisterEvent(11080);
	RegisterEvent(11081);
	RegisterEvent(11082);
	RegisterEvent(40);
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("MagicLampWnd");
	disableWnd = GetWindowHandle("MagicLampWnd.DisableWnd");
	CostBg_Tex = GetTextureHandle("MagicLampWnd.CostBg_Tex");
	GameStartCancleBg_Tex = GetTextureHandle("MagicLampWnd.GameStartCancleBg_Tex");
	EffectViewport01 = GetEffectViewportWndHandle("MagicLampWnd.EffectViewport01");
	EffectViewport02 = GetEffectViewportWndHandle("MagicLampWnd.EffectViewport02");
	MagicLampResultWnd = GetWindowHandle("MagicLampWnd.MagicLampResultWnd");
	MagicLampResultBg_Tex = GetTextureHandle("MagicLampWnd.MagicLampResultWnd.MagicLampResultBg_Tex");
	MagicLampResultBgPattern_Tex = GetTextureHandle("MagicLampWnd.MagicLampResultWnd.MagicLampResultBgPattern_Tex");
	Ok_Btn = GetButtonHandle("MagicLampWnd.MagicLampResultWnd.OK_Btn");
	MagicLampResultTitle_Txt = GetTextBoxHandle("MagicLampWnd.MagicLampResultWnd.MagicLampResultTitle_Txt");
	NumofPlayUp_Btn = GetButtonHandle("MagicLampWnd.NumofPlayUp_Btn");
	NumofPlayDown_Btn = GetButtonHandle("MagicLampWnd.NumofPlayDown_Btn");
	NumofPlayMax_Btn = GetButtonHandle("MagicLampWnd.NumofPlayMax_Btn");
	GameStartorCancle_Btn = GetButtonHandle("MagicLampWnd.GameStartorCancle_Btn");
	VoucherName_Txt = GetTextBoxHandle("MagicLampWnd.VoucherName_Txt");
	VoucherMyNum_Txt = GetTextBoxHandle("MagicLampWnd.VoucherMyNum_Txt");
	AdenaName_Txt = GetTextBoxHandle("MagicLampWnd.AdenaName_Txt");
	AdenaMyNum_Txt = GetTextBoxHandle("MagicLampWnd.AdenaMyNum_Txt");
	AdenaIcon_Tex = GetTextureHandle("MagicLampWnd.AdenaIcon_Tex");
	NumofPlayTitle_Txt = GetTextBoxHandle("MagicLampWnd.NumofPlayTitle_Txt");
	NumofPlay_EditBox = GetEditBoxHandle("MagicLampWnd.NumofPlay_EditBox");
	Advanced_CheckBox = GetCheckBoxHandle("MagicLampWnd.Advanced_CheckBox");
	MagicLamp_Tex = GetTextureHandle("MagicLampWnd.MagicLamp_Tex");
	AllExpNum_Txt = GetTextBoxHandle("MagicLampWnd.MagicLampResultWnd.AllExpNum_Txt");
	AllSpNum_Txt = GetTextBoxHandle("MagicLampWnd.MagicLampResultWnd.AllSpNum_Txt");
	MagicLampProbability_Wnd = GetWindowHandle("MagicLampWnd.MagicLampProbability_Wnd");
	bIsGameStartClick = false;
	Advanced_CheckBox.SetTooltipCustomType(MakeTooltipMultiText(GetSystemString(13241), getInstanceL2Util().Yellow, "", false, , , , , , , , , 220));
	SetItemCountEditBox(1);
	return;
}

function Init()
{
	MagicLampResultWnd.HideWindow();
	return;
}

event OnShow()
{
	if(isAdvancedLampPossible())
	{
		Advanced_CheckBox.EnableWindow();
	}
	else
	{
		Advanced_CheckBox.DisableWindow();
	}
	SetItemCountEditBox(1);
	bIsGameStartClick = false;
	GameStartorCancle_Btn.SetButtonName(160);
	DisableCurrentWindow(false);
	MagicLampResultWnd.HideWindow();
	MagicLampProbability_Wnd.HideWindow();
	RequestMagicLampGameInfo(GetGameModeType());
	EffectViewport01.SpawnEffect("LineageEffect2.ui_soul_crystal");
	return;
}

event OnHide()
{
	Me.KillTimer(11231);
	EffectViewport01.SpawnEffect("");
	EffectViewport02.SpawnEffect("");
	GameStartorCancle_Btn.SetButtonName(160);
	return;
}

function updateProbabilityList()
{
	local array<MagicLampResultItemUIData> oItemList;
	local int i;
	local bool bAdvanced;
	local string probabilityStr;

	if((GetTabHandle("MagicLampWnd.MagicLampProbability_Wnd.MagicLampProbability_Tab").GetTopIndex() == 0))
	{
		bAdvanced = false;
	}
	else
	{
		bAdvanced = true;
	}
	Debug(("bAdvanced" @ string(bAdvanced)));
	if(bAdvanced)
	{
		GetMagicLampAdvancedResultItemList(oItemList);
	}
	else
	{
		GetMagicLampNormalResultItemList(oItemList);
	}
	i = 0;
	while((i < oItemList.Length))
	{
		GetItemWindowHandle((("MagicLampWnd.MagicLampProbability_Wnd.CardWnd" $ string((i + 1))) $ ".ItemWnd")).Clear();
		GetItemWindowHandle((("MagicLampWnd.MagicLampProbability_Wnd.CardWnd" $ string((i + 1))) $ ".ItemWnd")).AddItem(GetItemInfoByClassID(oItemList[i].ItemClassID));
		GetTextBoxHandle((("MagicLampWnd.MagicLampProbability_Wnd.CardWnd" $ string((i + 1))) $ ".ExpNum_Txt")).SetText(MakeCostString(string(oItemList[i].Exp)));
		GetTextBoxHandle((("MagicLampWnd.MagicLampProbability_Wnd.CardWnd" $ string((i + 1))) $ ".SpNum_Txt")).SetText(MakeCostString(string(oItemList[i].Sp)));
		probabilityStr = getInstanceL2Util().CutFloatDecimalPlaces(oItemList[i].Probability, 2);
		GetTextBoxHandle((("MagicLampWnd.MagicLampProbability_Wnd.CardWnd" $ string((i + 1))) $ ".Probability_Txt")).SetText(probabilityStr);
		i++;
	}
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 11081:
			Debug(("EV_MagicLamp_GameInfo : " @ param));
			magicLampGameInfoHandler(param);
			break;
		case 11082:
			Debug(("EV_MagicLamp_GameResult : " @ param));
			magicLampGameResultHandler(param);
			break;
		case 40:
			bIsGameStartClick = false;
			Advanced_CheckBox.SetCheck(false);
			break;
		default:
			break;
	}
	return;
}

function magicLampGameResultHandler(string param)
{
	local int i, resultCardCount, nGradeNum, nRewardCount;
	local bool bGet1st;
	local INT64 nEXP, nSP, nExpTotal, nSPTotal;

	DisableCurrentWindow(true);
	GameStartorCancle_Btn.SetButtonName(160);
	MagicLampResultWnd.ShowWindow();
	MagicLampResultWnd.SetFocus();
	MagicLampProbability_Wnd.HideWindow();
	ParseInt(param, "Size", resultCardCount);
	i = 1;
	while((i <= 4))
	{
		GetItemWindowHandle((("MagicLampWnd.MagicLampResultWnd.CardWnd" $ string(i)) $ ".ItemWnd")).Clear();
		GetItemWindowHandle((("MagicLampWnd.MagicLampResultWnd.CardWnd" $ string(i)) $ ".ItemWnd")).AddItem(getCustomRewardItemInfo(i));
		setCardInfo(i, 0, INT64(0), INT64(0));
		i++;
	}
	i = 1;
	while((i <= resultCardCount))
	{
		ParseInt(param, ("GradeNum_" $ string(i)), nGradeNum);
		ParseInt(param, ("RewardCount_" $ string(i)), nRewardCount);
		ParseINT64(param, ("EXP_" $ string(i)), nEXP);
		ParseINT64(param, ("SP_" $ string(i)), nSP);
		nExpTotal = (nExpTotal + (nEXP * INT64(nRewardCount)));
		nSPTotal = (nSPTotal + (nSP * INT64(nRewardCount)));
		setCardInfo(nGradeNum, nRewardCount, nEXP, nSP);
		if(((nGradeNum == 1) && (nRewardCount > 0)))
		{
			bGet1st = true;
		}
		i++;
	}
	if(bGet1st)
	{
		playResultEffectViewPort("LineageEffect.d_firework_a");
	}
	else
	{
		playResultEffectViewPort("LineageEffect2.ui_upgrade_succ");
	}
	PlaySound("InterfaceSound.MagicLamp_End");
	AllExpNum_Txt.SetText(MakeCostStringINT64(nExpTotal));
	AllSpNum_Txt.SetText(MakeCostStringINT64(nSPTotal));
	return;
}

function setCardInfo(int nGradeNum, int nRewardCount, INT64 nEXP, INT64 nSP)
{
	GetTextBoxHandle((("MagicLampWnd.MagicLampResultWnd.CardWnd" $ string(nGradeNum)) $ ".ExpNum_Txt")).SetText(MakeCostStringINT64(nEXP));
	GetTextBoxHandle((("MagicLampWnd.MagicLampResultWnd.CardWnd" $ string(nGradeNum)) $ ".SpNum_Txt")).SetText(MakeCostStringINT64(nSP));
	GetTextBoxHandle((("MagicLampWnd.MagicLampResultWnd.CardWnd" $ string(nGradeNum)) $ ".ItemNum_Txt")).SetText((" x" $ string(nRewardCount)));
	if((nRewardCount > 0))
	{
		GetItemWindowHandle((("MagicLampWnd.MagicLampResultWnd.CardWnd" $ string(nGradeNum)) $ ".ItemWnd")).EnableWindow();
	}
	else
	{
		GetItemWindowHandle((("MagicLampWnd.MagicLampResultWnd.CardWnd" $ string(nGradeNum)) $ ".ItemWnd")).DisableWindow();
	}
	return;
}

function ItemInfo getCustomRewardItemInfo(int nGradeNum)
{
	local string Icon, panel;
	local ItemInfo Info;

	if((nGameMode == 0))
	{
		switch(nGradeNum)
		{
			case 1:
				Icon = "icon.r99_soul_stone_i00";
				panel = "icon.panel_star_r3";
				break;
			case 2:
				Icon = "icon.r99_soul_stone_i05";
				panel = "icon.panel_star_r2";
				break;
			case 3:
				Icon = "icon.r99_soul_stone_i02";
				panel = "icon.panel_star_r1";
				break;
			case 4:
				Icon = "icon.r99_soul_stone_i04";
				panel = "icon.panel_2";
				break;
			default:
				break;
		}
	}
	else
	{
		switch(nGradeNum)
		{
			case 1:
				Icon = "icon.ensoul_big_pp";
				panel = "icon.panel_star_r3";
				break;
			case 2:
				Icon = "icon.ensoul_big_pm";
				panel = "icon.panel_star_r2";
				break;
			case 3:
				Icon = "icon.ensoul_big_m";
				panel = "icon.panel_star_r1";
				break;
			case 4:
				Icon = "icon.ensoul_big_ep";
				panel = "icon.panel_2";
				break;
			default:
				break;
		}
	}
	Info.IconName = Icon;
	Info.IconPanel = panel;
	return Info;
}

function magicLampGameInfoHandler(string param)
{
	local int nSize, i, nItemClassID;

	ParseInt(param, "MaxCount", TryMaxCount);
	ParseInt(param, "GameCount", nGameCount);
	ParseInt(param, "CountPerGame", nCountPerGame);
	ParseInt(param, "Count", nCount);
	ParseInt(param, "GameMode", nGameMode);
	if((nGameMode == 1))
	{
		ParseInt(param, "Size", nSize);
		i = 1;
		while((i <= nSize))
		{
			ParseInt(param, ("ItemClassID_" $ string(i)), nItemClassID);
			ParseInt(param, ("AmountPerGame_" $ string(i)), needPerGameForAdvanced);
			ParseINT64(param, ("Amount_" $ string(i)), nHighgradeAmount);
			break;
			i++;
		}
		AdenaName_Txt.SetTextColor(getInstanceL2Util().White);
		AdenaIcon_Tex.SetAlpha(255);
		AdenaIcon_Tex.SetTexture(Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(GetItemID(nItemClassID)));
		AdenaMyNum_Txt.ShowWindow();
		AdenaName_Txt.ShowWindow();
		AdenaName_Txt.SetText(((Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(91641)) $ " x") $ string(needPerGameForAdvanced)));
		AdenaMyNum_Txt.SetText((("(" $ MakeCostString(string(nHighgradeAmount))) $ ")"));
	}
	else
	{
		needPerGameForAdvanced = 0;
		nItemClassID = 91641;
		AdenaName_Txt.SetText(Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(nItemClassID)));
		AdenaName_Txt.SetTextColor(getInstanceL2Util().Gray);
		AdenaIcon_Tex.SetAlpha(140);
		AdenaIcon_Tex.SetTexture(Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(GetItemID(nItemClassID)));
		AdenaMyNum_Txt.HideWindow();
	}
	if((nGameCount > 0))
	{
		SetItemCountEditBox(nGameCount);
	}
	else
	{
		SetItemCountEditBox(1);
	}
	VoucherName_Txt.SetText(((GetSystemString(3937) $ " x") $ string(nCountPerGame)));
	if((MagicLampResultWnd.IsShowWindow() == false))
	{
		DisableCurrentWindow(false);
	}
	SetControlerBtns();
	return;
}

event OnClickButton(string Name)
{
	Debug(("Name" @ Name));
	switch(Name)
	{
		case "WindowHelp_BTN":
			ExecuteEvent(1210, "20");
			break;
		case "OK_Btn":
			OnOk_BtnClick();
			break;
		case "NumofPlayUp_Btn":
			OnNumofPlayUp_BtnClick();
			break;
		case "NumofPlayDown_Btn":
			OnNumofPlayDown_BtnClick();
			break;
		case "NumofPlayMax_Btn":
			OnNumofPlayMax_BtnClick();
			break;
		case "GameStartorCancle_Btn":
			OnGameStartorCancle_BtnClick();
			break;
		case "ProbabilityView_Btn":
			toggleWindow("MagicLampWnd.MagicLampProbability_Wnd", true);
			if(GetWindowHandle("MagicLampWnd.MagicLampProbability_Wnd").IsShowWindow())
			{
				updateProbabilityList();
			}
			break;
		case "POK_Btn":
			MagicLampProbability_Wnd.HideWindow();
			break;
		case "MagicLampProbability_Tab0":
			updateProbabilityList();
			break;
		case "MagicLampProbability_Tab1":
			updateProbabilityList();
			break;
		default:
			break;
	}
	return;
}

function OnOk_BtnClick()
{
	bIsGameStartClick = false;
	MagicLampResultWnd.HideWindow();
	DisableCurrentWindow(false);
	SetControlerBtns();
	return;
}

function OnNumofPlayUp_BtnClick()
{
	SetItemCountEditBox((int(NumofPlay_EditBox.GetString()) + 1));
	return;
}

function OnNumofPlayDown_BtnClick()
{
	SetItemCountEditBox((int(NumofPlay_EditBox.GetString()) - 1));
	return;
}

function OnNumofPlayMax_BtnClick()
{
	SetItemCountEditBox(1000);
	return;
}

function OnGameStartorCancle_BtnClick()
{
	Me.KillTimer(11231);
	if((bIsGameStartClick == false))
	{
		GameStartorCancle_Btn.SetButtonName(141);
		Me.SetTimer(11231, 2000);
		bIsGameStartClick = true;
		EffectViewport01.SpawnEffect("LineageEffect.d_chainheal_ta");
		PlaySound("InterfaceSound.MagicLamp_Start");
	}
	else
	{
		Me.KillTimer(11231);
		GameStartorCancle_Btn.SetButtonName(160);
		bIsGameStartClick = false;
		EffectViewport01.SpawnEffect("LineageEffect2.ui_soul_crystal");
	}
	MagicLampProbability_Wnd.HideWindow();
	return;
}

function OnTimer(int TimerID)
{
	local int nBet;

	if((TimerID == 11231))
	{
		Me.KillTimer(11231);
		EffectViewport01.SpawnEffect("LineageEffect2.ui_soul_crystal");
		nBet = int(NumofPlay_EditBox.GetString());
		if((nBet > 0))
		{
			RequestMagicLampGameStart(GetGameModeType(), nBet);
		}
	}
	return;
}

function int DelegateGetCountCanBuy()
{
	local INT64 Num;

	if(Advanced_CheckBox.IsChecked())
	{
		if(((nCount >= (TryMaxCount * nCountPerGame)) && (getInventoryItemNumByClassID(91641) >= INT64((TryMaxCount * needPerGameForAdvanced)))))
		{
			return TryMaxCount;
		}
		Num = Min_Int64(getMaximumBuyCount(INT64(nCount), INT64(nCountPerGame)), getMaximumBuyCount(getInventoryItemNumByClassID(91641), INT64(needPerGameForAdvanced)));
	}
	else
	{
		if((nCount >= (TryMaxCount * nCountPerGame)))
		{
			return TryMaxCount;
		}
		Num = getMaximumBuyCount(INT64(nCount), INT64(nCountPerGame));
	}
	return int(Num);
}

function INT64 Min_Int64(INT64 A, INT64 B)
{
	if((A > B))
	{
		return B;
	}
	return A;
}

function INT64 getMaximumBuyCount(INT64 hasCount, INT64 needCount)
{
	return (hasCount / needCount);
}

function delegateOnItemCountEdited(int Num)
{
	VoucherNum_Txt.SetText(string(Num));
	return;
}

function SetItemCountEditBox(int Num)
{
	Num = Min(DelegateGetCountCanBuy(), Num);
	if((Num != int(NumofPlay_EditBox.GetString())))
	{
		NumofPlay_EditBox.SetString(string(Num));
	}
	delegateOnItemCountEdited(Num);
	SetControlerBtns();
	return;
}

function int canIBuy(int tryNum)
{
	if(((nCount >= (tryNum * nCountPerGame)) && (getInventoryItemNumByClassID(91641) >= INT64((tryNum * needPerGameForAdvanced)))))
	{
		return tryNum;
	}
	if(((nCount <= 0) || (getInventoryItemNumByClassID(91641) <= INT64(0))))
	{
		return 1;
	}
	return tryNum;
}

function bool SetControlerBtns()
{
	local int Count, canBuyCount;

	Count = int(NumofPlay_EditBox.GetString());
	canBuyCount = DelegateGetCountCanBuy();
	if((canBuyCount > 0))
	{
		GameStartorCancle_Btn.EnableWindow();
		NumofPlayMax_Btn.EnableWindow();
	}
	else
	{
		GameStartorCancle_Btn.DisableWindow();
		NumofPlayMax_Btn.DisableWindow();
	}
	if((GetGameModeType() == 0))
	{
		if((nCount == 0))
		{
			VoucherMyNum_Txt.SetTextColor(getInstanceL2Util().DRed);
		}
		else
		{
			VoucherMyNum_Txt.SetTextColor(getInstanceL2Util().Blue);
		}
	}
	else
	{
		if((nCount >= nCountPerGame))
		{
			VoucherMyNum_Txt.SetTextColor(getInstanceL2Util().Blue);
		}
		else
		{
			VoucherMyNum_Txt.SetTextColor(getInstanceL2Util().DRed);
		}
		if((getInventoryItemNumByClassID(91641) >= INT64(needPerGameForAdvanced)))
		{
			AdenaMyNum_Txt.SetTextColor(getInstanceL2Util().Blue);
		}
		else
		{
			AdenaMyNum_Txt.SetTextColor(getInstanceL2Util().DRed);
		}
	}
	if((canBuyCount > 0))
	{
		if((canBuyCount == 1))
		{
			NumofPlayDown_Btn.DisableWindow();
			NumofPlay_EditBox.DisableWindow();
		}
		else
		{
			NumofPlayDown_Btn.EnableWindow();
			NumofPlay_EditBox.EnableWindow();
		}
		if((canBuyCount == Count))
		{
			NumofPlayUp_Btn.DisableWindow();
		}
		else
		{
			NumofPlayUp_Btn.EnableWindow();
		}
		if((Count <= 1))
		{
			NumofPlayDown_Btn.DisableWindow();
		}
		else
		{
			NumofPlayDown_Btn.EnableWindow();
		}
	}
	else
	{
		NumofPlayUp_Btn.DisableWindow();
		NumofPlayDown_Btn.DisableWindow();
		NumofPlayDown_Btn.DisableWindow();
		NumofPlay_EditBox.DisableWindow();
		NumofPlayMax_Btn.DisableWindow();
		return false;
	}
}

function playResultEffectViewPort(string effectPath)
{
	local Vector offset;

	if((effectPath == "LineageEffect2.ui_upgrade_succ"))
	{
		offset.X = 10.0000000;
		offset.Y = -5.0000000;
		EffectViewport02.SetScale(6.0000000);
		EffectViewport02.SetCameraDistance(1300.0000000);
		EffectViewport02.SetOffset(offset);
	}
	else if((effectPath == "LineageEffect.d_firework_a"))
	{
		offset.X = 10.0000000;
		offset.Y = -5.0000000;
		EffectViewport02.SetScale(6.0000000);
		EffectViewport02.SetCameraDistance(1300.0000000);
		EffectViewport02.SetOffset(offset);
	}
	EffectViewport02.SetFocus();
	EffectViewport02.SpawnEffect(effectPath);
	return;
}

function OnClickCheckBox(string strID)
{
	switch(strID)
	{
		case "Advanced_CheckBox":
			if(Advanced_CheckBox.IsChecked())
			{
				MagicLamp_Tex.SetTexture("L2UI_CT1.MagicLampWnd.MagicLamp_Bg_Advanced");
			}
			else
			{
				MagicLamp_Tex.SetTexture("L2UI_CT1.MagicLampWnd.MagicLamp_Bg");
			}
			Debug((("api-> RequestMagicLampGameInfo" @ string(GetGameModeType())) @ string(0)));
			SetItemCountEditBox(1);
			RequestMagicLampGameInfo(GetGameModeType());
			break;
		default:
			break;
	}
	return;
}

function OnChangeEditBox(string strID)
{
	switch(strID)
	{
		case "NumofPlay_EditBox":
			CheckZero();
			SetItemCountEditBox(int(NumofPlay_EditBox.GetString()));
			break;
		default:
			break;
	}
	return;
}

function int GetGameModeType()
{
	if(Advanced_CheckBox.IsChecked())
	{
		return 1;
	}
	return 0;
}

function setCheckBoxState()
{
	if(isAdvancedLampPossible())
	{
		Advanced_CheckBox.EnableWindow();
	}
	else
	{
		Advanced_CheckBox.DisableWindow();
		Advanced_CheckBox.SetCheck(false);
	}
	return;
}

function bool isAdvancedLampPossible()
{
	local UserInfo Info;

	GetPlayerInfo(Info);
	if(((GetClassTransferDegree(Info.nSubClass) > 2) && (Info.nLevel >= 76)))
	{
		return true;
	}
	return false;
}

function CheckZero()
{
	local string EditBoxString;

	EditBoxString = NumofPlay_EditBox.GetString();
	if(((Left(EditBoxString, 1) == "0") && (Len(EditBoxString) > 1)))
	{
		NumofPlay_EditBox.SetString(Right(EditBoxString, (Len(EditBoxString) - 1)));
	}
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

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}
