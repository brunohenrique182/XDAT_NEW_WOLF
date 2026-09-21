class RestartMenuWnd extends UICommonAPI;

const TimerValue1 = 329;
const DIALOG_CONFIRM_RESTART = 1640;
const DIALOG_CONFIRM_COINRESTART = 1641;
const DIALOG_CONFIRM_FORTRESS = 1642;
const DIALOG_CONFIRM_CASTLE = 1643;
const DIALOG_CONFIRM_RESTART_TIME_ZONE = 1644;
const RESTARTPOINTITEM_ADENA = 57;
const RESTARTPOINTITEM_LCOIN = 91663;

var string m_Windowname;
var bool m_bRestartON;
var WindowHandle m_wndTop;
var ButtonHandle m_btnVillage;
var ButtonHandle m_btnNearbyBattleField;
var ButtonHandle m_btnAgit;
var ButtonHandle m_btnCastle;
var ButtonHandle m_btnBattleCamp;
var ButtonHandle m_btnFortress;
var ButtonHandle m_btnUnPenaltyLimit;
var ButtonHandle m_btnTimeZone;
var WindowHandle m_BressFeatherWnd;
var ButtonHandle m_btnOriginal;
var TextBoxHandle UnPenaltyTime;
var WindowHandle Adenserver_Window;
var WindowHandle FreeCostRestart_wnd;
var TextBoxHandle FreeLcoinTitle_Text;
var TextBoxHandle LcoinTitle_Text;
var WindowHandle PayCostRestart_wnd;
var TextBoxHandle LcoinPersentBtn_txt;
var TextBoxHandle AdenaPersentBtn_txt;
var WindowHandle DieReportWnd;
var TextureHandle backTexture;
var ButtonHandle m_BtnDamage;
var ButtonHandle m_BtnLostItem;
var int nCostItemClassID;
var int nCostItemAmount;
var bool _isTimeZoneDie;
var int nRemainFreeRestoreCount;
var int nAdenaRestoreCost;
var int nAdenaRestoreRatio;
var int nLConinRestoreCost;
var int nLConinResotreRatio;
var string DialogAsset_path;
var L2Util util;
var int DelayToUseRebirthItem;
var array<WindowHandle> RestartAll;
var WindowHandle LastBtn;

event OnRegisterEvent()
{
	RegisterEvent(50);
	RegisterEvent(40);
	RegisterEvent(1430);
	RegisterEvent(1440);
	RegisterEvent(1710);
	RegisterEvent(1720);
	RegisterEvent(11160);
	RegisterEvent(11162);
	RegisterEvent(11161);
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	DialogAsset_path = (m_Windowname $ ".UIControlDialogAsset");
	m_wndTop = GetWindowHandle(m_Windowname);
	m_btnVillage = GetButtonHandle((m_Windowname $ ".btnVillage"));
	m_btnTimeZone = GetButtonHandle((m_Windowname $ ".btnTimeZone"));
	m_btnNearbyBattleField = GetButtonHandle((m_Windowname $ ".btnNearbyBattleField"));
	m_btnAgit = GetButtonHandle((m_Windowname $ ".btnAgit"));
	m_btnCastle = GetButtonHandle((m_Windowname $ ".btnCastle"));
	m_btnBattleCamp = GetButtonHandle((m_Windowname $ ".btnBattleCamp"));
	m_btnFortress = GetButtonHandle((m_Windowname $ ".btnFortress"));
	m_btnUnPenaltyLimit = GetButtonHandle((m_Windowname $ ".btnUnPenaltyLimit"));
	m_btnOriginal = GetButtonHandle((m_Windowname $ ".UnPenaltyWnd.BtnUnPenalty"));
	m_BressFeatherWnd = GetWindowHandle((m_Windowname $ ".UnPenaltyWnd"));
	UnPenaltyTime = GetTextBoxHandle((m_Windowname $ ".UnPenaltyWnd.UnPenaltyTime"));
	Adenserver_Window = GetWindowHandle((m_Windowname $ ".Adenserver_Window"));
	FreeCostRestart_wnd = GetWindowHandle((m_Windowname $ ".FreeCostRestart_wnd"));
	FreeLcoinTitle_Text = GetTextBoxHandle((m_Windowname $ ".FreeCostRestart_wnd.FreeLcoinTitle_Text"));
	LcoinTitle_Text = GetTextBoxHandle((m_Windowname $ ".FreeCostRestart_wnd.LcoinTitle_Text"));
	PayCostRestart_wnd = GetWindowHandle((m_Windowname $ ".PayCostRestart_wnd"));
	LcoinPersentBtn_txt = GetTextBoxHandle((m_Windowname $ ".PayCostRestart_wnd.LcoinPersentBtn_txt"));
	AdenaPersentBtn_txt = GetTextBoxHandle((m_Windowname $ ".PayCostRestart_wnd.AdenaPersentBtn_txt"));
	DieReportWnd = GetWindowHandle((m_Windowname $ ".DieReportWnd"));
	backTexture = GetTextureHandle((m_Windowname $ ".BackTexture"));
	m_BtnDamage = GetButtonHandle((m_Windowname $ ".DieReportWnd.BtnDamage"));
	m_BtnLostItem = GetButtonHandle((m_Windowname $ ".DieReportWnd.BtnLostItem"));
	util = L2Util(GetScript("L2Util"));
	m_bRestartON = false;
	PushWnd(m_btnTimeZone, RestartAll);
	PushWnd(m_btnVillage, RestartAll);
	PushWnd(m_btnNearbyBattleField, RestartAll);
	PushWnd(Adenserver_Window, RestartAll);
	PushWnd(m_btnAgit, RestartAll);
	PushWnd(m_btnCastle, RestartAll);
	PushWnd(m_btnBattleCamp, RestartAll);
	PushWnd(m_btnFortress, RestartAll);
	PushWnd(m_btnUnPenaltyLimit, RestartAll);
	PushWnd(m_btnOriginal, RestartAll);
	GetButtonHandle((m_Windowname $ ".Adenserver_Window.Help_Button")).SetTooltipCustomType(getFeeHelpCustomTooltip());
	SetBtnStrings();
	return;
}

function SetBtnStrings()
{
	local ButtonHandle feeVillageBtn;

	m_btnVillage.SetNameText(m_btnVillage.GetButtonName());
	m_btnTimeZone.SetNameText(m_btnTimeZone.GetButtonName());
	m_btnOriginal.SetNameText(m_btnOriginal.GetButtonName());
	feeVillageBtn = GetButtonHandle((m_Windowname $ ".Adenserver_Window.FreeCostRestart_wnd.FeeVillage"));
	feeVillageBtn.SetNameText(feeVillageBtn.GetButtonName());
	return;
}

function CustomTooltip getFeeHelpCustomTooltip()
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13718), GTColor().White, "", true, true);
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 130;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;
}

function CustomTooltip getFeeCustomTooltip(int ItemClassID, int Amount)
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(637), GetColor(230, 220, 190, 255), "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemTextureCustom(Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(GetItemID(ItemClassID)), true, true, 0, 4, 32, 32);
	drawListArr[drawListArr.Length] = addDrawItemText(((Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(ItemClassID)) $ " x") $ MakeCostString(string(Amount))), GTColor().White, "", false, true, 4, 10);
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 130;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;
}

event OnEnterState(name a_CurrentStateName)
{
	if(m_bRestartON)
	{
		ShowMe();
	}
	else
	{
		HideMe();
	}
	if(IsAdenServer())
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SettingBTN")).ShowWindow();
	}
	else
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SettingBTN")).HideWindow();
	}
	return;
}

event OnEvent(int Event_ID, string param)
{
	if((Event_ID == 50))
	{
		HandleDie(param);
	}
	else if((Event_ID == 40))
	{
		HideMe();
	}
	else if((Event_ID == 1430))
	{
		ShowMe();
	}
	else if((Event_ID == 1440))
	{
		HideMe();
	}
	else if((Event_ID == 1710))
	{
		HandleDialogOK();
	}
	else if((Event_ID == 1720))
	{
	}
	else if((Event_ID == 11160))
	{
		m_BtnDamage.DisableWindow();
		m_BtnLostItem.DisableWindow();
	}
	else if((Event_ID == 11162))
	{
		m_BtnDamage.EnableWindow();
	}
	else if((Event_ID == 11161))
	{
		m_BtnLostItem.EnableWindow();
	}
	return;
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnTimeZone":
			timerAllKill();
			OnTimeZoneClick();
			break;
		case "btnVillage":
			timerAllKill();
			OnVillageClick();
			break;
		case "btnNearbyBattleField":
			OnNearByBattleFieldClick();
			break;
		case "btnAgit":
			timerAllKill();
			OnAgitClick();
			break;
		case "btnCastle":
			timerAllKill();
			OnCastleClick();
			break;
		case "btnBattleCamp":
			timerAllKill();
			OnBattleCampClick();
			break;
		case "BtnUnPenalty":
			timerAllKill();
			OnOriginalClick();
			break;
		case "btnFortress":
			timerAllKill();
			OnFortressClick();
			break;
		case "btnUnPenaltyLimit":
			timerAllKill();
			OnUnPenaltyLimitClick();
			break;
		case "BtnDamage":
			ShowHide("RestartMenuWndReportDamage");
			break;
		case "BtnLostItem":
			ShowHide("RestartMenuWndReportLostItem");
			break;
		case "payLcoinVillage":
			if(isTimeZoneDie())
			{
				showAskFeeDialog(1, MakeFullSystemMsg(GetSystemMessage(13708), (string(nLConinResotreRatio) $ "%")), 91663, nLConinRestoreCost);
			}
			else
			{
				showAskFeeDialog(1, MakeFullSystemMsg(GetSystemMessage(13410), (string(nLConinResotreRatio) $ "%")), 91663, nLConinRestoreCost);
			}
			break;
		case "FeeVillage":
			DialogSetID(1641);
			if(isTimeZoneDie())
			{
				DialogShow(DialogModalType_Modalless, DialogType_Warning, MakeFullSystemMsg(GetSystemMessage(13705), "100%"));
			}
			else
			{
				DialogShow(DialogModalType_Modalless, DialogType_Warning, MakeFullSystemMsg(GetSystemMessage(5265), "100%"));
			}
			break;
		case "SettingBTN":
			ToggleWindowRestartMenuWndOption();
			break;
		default:
			break;
	}
	return;
}

function ShowHide(string Name)
{
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow(Name))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow(Name);
	}
	else
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(Name);
		Class'NWindow.UIAPI_WINDOW'.static.SetFocus(Name);
	}
	return;
}

event OnTimer(int TimerID)
{
	if((TimerID == 329))
	{
		--DelayToUseRebirthItem;
		setReLiveText();
		if((DelayToUseRebirthItem == 0))
		{
			m_wndTop.KillTimer(329);
			m_btnOriginal.EnableWindow();
		}
	}
	return;
}

event OnHide()
{
	GetWindowHandle("RestartMenuWndOption").HideWindow();
	return;
}

function OnVillageClick()
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		OnClickDialogCancel();
		DialogSetID(1640);
		DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(5266));
	}
	else
	{
		RequestRestartPoint(RESTART_VILLAGE, 0, 0);
	}
	return;
}

function OnTimeZoneClick()
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		OnClickDialogCancel();
		DialogSetID(1644);
		DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(13706));
	}
	else
	{
		RequestRestartPoint(RESTART_TIME_FIELD_START_POS, 0, 0);
	}
	return;
}

function OnNearByBattleFieldClick()
{
	RequestRestartPoint(RESTART_NEARBY_BATTLE_FIELD, 0, 0);
	return;
}

function OnAgitClick()
{
	RequestRestartPoint(RESTART_AGIT, 0, 0);
	return;
}

function OnCastleClick()
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		OnClickDialogCancel();
		DialogSetID(1643);
		DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(13420));
	}
	else
	{
		RequestRestartPoint(RESTART_CASTLE, 0, 0);
	}
	return;
}

function OnFortressClick()
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		OnClickDialogCancel();
		DialogSetID(1642);
		DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(13421));
	}
	else
	{
		RequestRestartPoint(RESTART_FORTRESS, 0, 0);
	}
	return;
}

function OnBattleCampClick()
{
	RequestRestartPoint(RESTART_BATTLE_CAMP, 0, 0);
	return;
}

function OnOriginalClick()
{
	RequestRestartPoint(RESTART_ORIGINAL_PLACE, 0, 0);
	return;
}

function OnUnPenaltyLimitClick()
{
	RequestRestartPoint(RESTART_ORIGINAL_PLACE_LIMIT, 0, 0);
	return;
}

function ToggleWindowRestartMenuWndOption()
{
	if(GetWindowHandle("RestartMenuWndOption").IsShowWindow())
	{
		GetWindowHandle("RestartMenuWndOption").HideWindow();
	}
	else
	{
		GetWindowHandle("RestartMenuWndOption").ShowWindow();
	}
	return;
}

function showAskFeeDialog(int nDialogID, string Msg, int nCostItemClassID, int nCount)
{
	DialogHide();
	CommonDialogGetScript(DialogAsset_path).StartNeedItemList(1);
	CommonDialogGetScript(DialogAsset_path).AddNeedItemClassID(nCostItemClassID, INT64(nCount));
	CommonDialogGetScript(DialogAsset_path).SetItemNum(1);
	CommonDialogGetScript(DialogAsset_path).SetDialogID(nDialogID);
	CommonDialogShow(DialogAsset_path, Msg, true);
	return;
}

function OnClickDialogCancel()
{
	CommonDialogHide(DialogAsset_path);
	return;
}

function OnClickDialogOk()
{
	RequestRestartPoint(RESTART_VILLAGE_USING_ITEM, 91663, nLConinRestoreCost);
	CommonDialogHide(DialogAsset_path);
	return;
}

function HandleDialogOK()
{
	local int Id;

	if(DialogIsMine())
	{
		Id = DialogGetID();
		if((Id == 1641))
		{
			RequestRestartPoint(RESTART_VILLAGE_USING_ITEM, 0, 0);
		}
		else if((Id == 1640))
		{
			RequestRestartPoint(RESTART_VILLAGE, 0, 0);
		}
		else if((Id == 1644))
		{
			RequestRestartPoint(RESTART_TIME_FIELD_START_POS, 0, 0);
		}
		else if((Id == 1642))
		{
			RequestRestartPoint(RESTART_FORTRESS, 0, 0);
		}
		else if((Id == 1643))
		{
			RequestRestartPoint(RESTART_CASTLE, 0, 0);
		}
	}
	return;
}

function HandleDie(string param)
{
	local bool tmpOpt;
	local ButtonHandle emptyBtn;

	CommonDialogHide(DialogAsset_path);
	HideAllWindow();
	LastBtn = emptyBtn;
	_isTimeZoneDie = GetOptionBoolFromParam(param, "TimeFieldStartPos");
	SetBtnsPostion(m_btnTimeZone, _isTimeZoneDie);
	tmpOpt = GetOptionBoolFromParam(param, "Village");
	SetBtnsPostion(m_btnVillage, tmpOpt);
	tmpOpt = GetOptionBoolFromParam(param, "Agit");
	SetBtnsPostion(m_btnAgit, (tmpOpt && (IsAdenServer() || getInstanceUIData().GetIsLiveServer())));
	tmpOpt = GetOptionBoolFromParam(param, "NearbyBattleField");
	SetBtnsPostion(m_btnNearbyBattleField, tmpOpt);
	tmpOpt = GetOptionBoolFromParam(param, "Castle");
	SetBtnsPostion(m_btnCastle, (tmpOpt && getInstanceUIData().GetIsLiveServer()));
	tmpOpt = GetOptionBoolFromParam(param, "BattleCamp");
	SetBtnsPostion(m_btnBattleCamp, tmpOpt);
	tmpOpt = GetOptionBoolFromParam(param, "Fortress");
	SetBtnsPostion(m_btnFortress, (tmpOpt && !IsAdenServer()));
	tmpOpt = GetOptionBoolFromParam(param, "AvailableCountRebirthItem");
	SetBtnsPostion(m_btnUnPenaltyLimit, tmpOpt);
	UnPenaltyTime.SetText("");
	tmpOpt = GetOptionBoolFromParam(param, "Original");
	SetBtnsPostion(m_BressFeatherWnd, tmpOpt);
	SetBressFeather(param);
	tmpOpt = SetAdenServerWindow(param);
	SetBtnsPostion(Adenserver_Window, tmpOpt);
	UpdateVillageInfoUI(_isTimeZoneDie);
	SetWindowSize();
	return;
}

function UpdateVillageInfoUI(bool isTimeZoneDie)
{
	local TextBoxHandle freeCostTitleTextBox, payCostTitleTextBox;

	freeCostTitleTextBox = GetTextBoxHandle((FreeCostRestart_wnd.m_WindowNameWithFullPath $ ".VillageTitle_Text"));
	payCostTitleTextBox = GetTextBoxHandle((PayCostRestart_wnd.m_WindowNameWithFullPath $ ".VillageTitle_Text"));
	if(isTimeZoneDie)
	{
		freeCostTitleTextBox.SetText(GetSystemString(14132));
		payCostTitleTextBox.SetText(GetSystemString(14132));
	}
	else
	{
		freeCostTitleTextBox.SetText(GetSystemString(14707));
		payCostTitleTextBox.SetText(GetSystemString(14707));
	}
	return;
}

function bool isTimeZoneDie()
{
	return _isTimeZoneDie;
}

function ShowMe()
{
	CommonDialogSetScript(DialogAsset_path, "", true);
	CommonDialogGetScript(DialogAsset_path).DelegateOnCancel = OnClickDialogCancel;
	CommonDialogGetScript(DialogAsset_path).DelegateOnClickBuy = OnClickDialogOk;
	m_bRestartON = true;
	m_wndTop.ShowWindow();
	m_wndTop.SetFocus();
	return;
}

function HideMe()
{
	timerAllKill();
	m_bRestartON = false;
	m_wndTop.HideWindow();
	m_BtnDamage.DisableWindow();
	m_BtnLostItem.DisableWindow();
	CommonDialogHide(DialogAsset_path);
	return;
}

function setReLiveText()
{
	local string Str;

	if((DelayToUseRebirthItem == 0))
	{
		Str = "";
	}
	else
	{
		Str = MakeFullSystemMsg(GetSystemMessage(3278), string(DelayToUseRebirthItem));
	}
	UnPenaltyTime.SetText(Str);
	return;
}

function SetBressFeather(string param)
{
	ParseInt(param, "DelayToUseRebirthItem", DelayToUseRebirthItem);
	if((DelayToUseRebirthItem != 0))
	{
		timerAllKill();
		m_btnOriginal.DisableWindow();
		DelayToUseRebirthItem = (DelayToUseRebirthItem - 1);
		setReLiveText();
		m_wndTop.SetTimer(329, 1000);
		m_BressFeatherWnd.SetWindowSize(176, 40);
	}
	else
	{
		m_btnOriginal.EnableWindow();
		UnPenaltyTime.SetText("");
		m_BressFeatherWnd.SetWindowSize(176, 27);
	}
	return;
}

function SetWindowSize()
{
	local Rect lastBtnRect, topRectWnd;
	local int sizeH;

	lastBtnRect = LastBtn.GetRect();
	topRectWnd = m_wndTop.GetRect();
	sizeH = ((((lastBtnRect.nY + lastBtnRect.nHeight) + 8) + 35) - topRectWnd.nY);
	if((sizeH < 187))
	{
		sizeH = 187;
	}
	WindowReSize(sizeH);
	return;
}

function bool SetAdenServerWindow(string param)
{
	if(IsAdenServer())
	{
		Debug(("EV_DIE " @ param));
		ParseInt(param, "RemainFreeRestoreCount", nRemainFreeRestoreCount);
		if((nRemainFreeRestoreCount > 0))
		{
			FreeCostRestart_wnd.ShowWindow();
			PayCostRestart_wnd.HideWindow();
			LcoinTitle_Text.SetText(MakeFullSystemMsg(GetSystemMessage(2297), string(nRemainFreeRestoreCount)));
		}
		else
		{
			ParseInt(param, "AdenaRestoreCost", nAdenaRestoreCost);
			ParseInt(param, "AdenaRestoreRatio", nAdenaRestoreRatio);
			ParseInt(param, "LConinRestoreCost", nLConinRestoreCost);
			ParseInt(param, "LConinResotreRatio", nLConinResotreRatio);
			LcoinPersentBtn_txt.SetText((string(nLConinResotreRatio) $ "%"));
			AdenaPersentBtn_txt.SetText((string(nAdenaRestoreRatio) $ "%"));
			FreeCostRestart_wnd.HideWindow();
			PayCostRestart_wnd.ShowWindow();
			GetButtonHandle("RestartMenuWnd.PayCostRestart_wnd.payLcoinVillage").SetTooltipType("Text");
			GetButtonHandle("RestartMenuWnd.PayCostRestart_wnd.payLcoinVillage").SetTooltipCustomType(getFeeCustomTooltip(91663, nLConinRestoreCost));
		}
		return true;
	}
	return false;
}

function WindowReSize(int Size)
{
	backTexture.SetWindowSize(199, Size);
	m_wndTop.SetWindowSize(280, Size);
	return;
}

function TextureHandle GetLockTexture(int lockIndex)
{
	local RestartMenuWndOption restartMenuWNdOptionScr;

	restartMenuWNdOptionScr = RestartMenuWndOption(GetScript("RestartMenuWNdOption"));
	return GetTextureHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ restartMenuWNdOptionScr.GetRestartName(restartMenuWNdOptionScr.restartPointLocks[lockIndex].restartPointLock, restartMenuWNdOptionScr.restartPointLocks[lockIndex].ClassID)) $ "_lock"));
}

function bool GetOptionBoolFromParam(string param, string paramName)
{
	local int tmpOption;

	ParseInt(param, paramName, tmpOption);
	return (tmpOption > 0);
}

function PushWnd(WindowHandle btnWnd, out array<WindowHandle> targetArray)
{
	targetArray.Length = (targetArray.Length + 1);
	targetArray[(RestartAll.Length - 1)] = btnWnd;
	return;
}

function SetBtnsPostion(WindowHandle mWnd, bool bUseBtn)
{
	HandleBtnLock(mWnd, bUseBtn);
	if(!bUseBtn)
	{
		return;
	}
	if((LastBtn.m_pTargetWnd == none))
	{
		mWnd.SetAnchor(((m_Windowname $ ".") $ m_btnVillage.GetWindowName()), "TopLeft", "TopLeft", 0, 2);
	}
	else
	{
		mWnd.SetAnchor(((m_Windowname $ ".") $ LastBtn.GetWindowName()), "BottomLeft", "TopLeft", 0, 2);
	}
	mWnd.ShowWindow();
	LastBtn = mWnd;
	return;
}

function HandleBtnLock(WindowHandle mWnd, bool bUseBtn)
{
	local int lockIndex;
	local RestartMenuWndOption restartMenuWNdOptionScr;

	if(!IsAdenServer())
	{
		return;
	}
	restartMenuWNdOptionScr = RestartMenuWndOption(GetScript("RestartMenuWndOption"));
	lockIndex = restartMenuWNdOptionScr.GetIndexByName(mWnd.GetWindowName());
	if((lockIndex == -1))
	{
		return;
	}
	if(!bUseBtn)
	{
		GetLockTexture(lockIndex).HideWindow();
		return;
	}
	if(restartMenuWNdOptionScr.GetLockedByName(mWnd.GetWindowName()))
	{
		if((((mWnd == m_btnVillage) || (mWnd == m_btnTimeZone)) && !restartMenuWNdOptionScr.bExpDown))
		{
			GetLockTexture(lockIndex).HideWindow();
		}
		else
		{
			GetLockTexture(lockIndex).ShowWindow();
		}
	}
	else
	{
		GetLockTexture(lockIndex).HideWindow();
	}
	return;
}

function HideAllWindow()
{
	m_btnVillage.HideWindow();
	m_btnTimeZone.HideWindow();
	m_btnNearbyBattleField.HideWindow();
	Adenserver_Window.HideWindow();
	m_btnAgit.HideWindow();
	m_btnCastle.HideWindow();
	m_btnBattleCamp.HideWindow();
	m_btnFortress.HideWindow();
	m_btnUnPenaltyLimit.HideWindow();
	m_BressFeatherWnd.HideWindow();
	return;
}

function timerAllKill()
{
	m_wndTop.KillTimer(329);
	return;
}

event OnReceivedCloseUI()
{
	if(GetWindowHandle("RestartmenuWndOption").IsShowWindow())
	{
		GetWindowHandle("RestartmenuWndOption").HideWindow();
	}
	return;
}

defaultproperties
{
	m_Windowname="RestartmenuWnd"
}
