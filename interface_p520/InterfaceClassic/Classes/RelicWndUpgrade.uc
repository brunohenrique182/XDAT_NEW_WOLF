class RelicWndUpgrade extends UICommonAPI;

var WindowHandle Me;
var WindowHandle relicBGWnd;
var WindowHandle stuffWnd;
var WindowHandle infoDisableWnd;
var WindowHandle relicSlotWnd;
var WindowHandle relicInfoWnd;
var WindowHandle statChangeInfoWnd;
var WindowHandle resultStatInfoWnd;
var WindowHandle resultWnd;
var WindowHandle resultInfoWnd;
var WindowHandle resultSuccessWnd;
var WindowHandle resultFailWnd;
var WindowHandle costDisableWnd;
var WindowHandle disableWnd;
var WindowHandle needItemWnd;
var WindowHandle needItemContainerWnd;
var RelicWndSlot targetRelicSlot;
var ButtonHandle upgradeBtn;
var ButtonHandle resultResetBtn;
var ButtonHandle maxLevelInfoBtn;
var ButtonHandle relicResetBtn;
var TextBoxHandle probTextBox;
var TextBoxHandle probTitleTextBox;
var TextBoxHandle sucRelicTextBox;
var TextBoxHandle relicNameTextBox;
var TextBoxHandle sucRelicLevelTextBox;
var TextBoxHandle sucPrevLevelTextBox;
var TextBoxHandle sucNextLevelTextBox;
var TextBoxHandle sucMaxLevelTextBox;
var TextBoxHandle failRelicTextBox;
var TextBoxHandle failRelicLevelTextBox;
var HtmlHandle statPrevHtml;
var HtmlHandle statNextHtml;
var HtmlHandle resultStatHtml;
var TextureHandle normalBGTex;
var TextureHandle registeredBGTex;
var TextureHandle sucLevelArrowTex;
var array<TextureHandle> stuffTexArray;
var UIControlNeedItem needItemScript;
var EffectViewportWndHandle ResultEffectViewport;
var Rect relicInfoWndRect;

static function RelicWndUpgrade Inst()
{
	return RelicWndUpgrade(GetScript("RelicWndUpgrade"));
}

function Initialize()
{
	InitControls();
	return;
}

function InitControls()
{
	local string ownerFullPath;
	local int i;
	local Rect parentRect;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	relicBGWnd = GetWindowHandle((ownerFullPath $ ".RelicRegisterWnd"));
	relicSlotWnd = GetWindowHandle((ownerFullPath $ ".RelicSlot"));
	stuffWnd = GetWindowHandle((ownerFullPath $ ".RelicmaterialWnd"));
	probTextBox = GetTextBoxHandle((relicBGWnd.m_WindowNameWithFullPath $ ".SuccessProbability_txt"));
	probTitleTextBox = GetTextBoxHandle((relicBGWnd.m_WindowNameWithFullPath $ ".SuccessProbabilityTitle_txt"));
	relicNameTextBox = GetTextBoxHandle((relicBGWnd.m_WindowNameWithFullPath $ ".UpgradeRelicName_txt"));
	relicResetBtn = GetButtonHandle((relicBGWnd.m_WindowNameWithFullPath $ ".RelicResetBtn"));
	relicInfoWnd = GetWindowHandle((ownerFullPath $ ".RelicUpgradeDetaliInfoWnd"));
	infoDisableWnd = GetWindowHandle((relicInfoWnd.m_WindowNameWithFullPath $ ".UpgradeDisable_wnd"));
	maxLevelInfoBtn = GetButtonHandle((relicInfoWnd.m_WindowNameWithFullPath $ ".UpgradeInfo_btn"));
	resultWnd = GetWindowHandle((ownerFullPath $ ".RelicUpgradeResultWnd"));
	resultSuccessWnd = GetWindowHandle((resultWnd.m_WindowNameWithFullPath $ ".UpgradeSuccessWnd"));
	resultFailWnd = GetWindowHandle((resultWnd.m_WindowNameWithFullPath $ ".UpgradeFailWnd"));
	normalBGTex = GetTextureHandle((relicBGWnd.m_WindowNameWithFullPath $ ".UpgradeBeforeBg_tex"));
	registeredBGTex = GetTextureHandle((relicBGWnd.m_WindowNameWithFullPath $ ".UpgradeAfterBg_tex"));
	upgradeBtn = GetButtonHandle((ownerFullPath $ ".RelicUpgrade_btn"));
	resultResetBtn = GetButtonHandle((ownerFullPath $ ".RelicUpgradeReset_btn"));
	statChangeInfoWnd = GetWindowHandle((relicInfoWnd.m_WindowNameWithFullPath $ ".RelicBeforeUpgradeInfo_Wnd"));
	resultStatInfoWnd = GetWindowHandle((relicInfoWnd.m_WindowNameWithFullPath $ ".RelicAfterUpgradeInfoText_Wnd"));
	statPrevHtml = GetHtmlHandle((statChangeInfoWnd.m_WindowNameWithFullPath $ ".PrvInfo_txt"));
	statNextHtml = GetHtmlHandle((statChangeInfoWnd.m_WindowNameWithFullPath $ ".NextInfo_txt"));
	resultStatHtml = GetHtmlHandle((resultStatInfoWnd.m_WindowNameWithFullPath $ ".AfterUpgradeInfo_txt"));
	needItemContainerWnd = GetWindowHandle((ownerFullPath $ ".UpgradeCostWnd"));
	needItemWnd = GetWindowHandle((needItemContainerWnd.m_WindowNameWithFullPath $ ".CostItem"));
	needItemWnd.SetScript("UIControlNeedItem");
	needItemScript = UIControlNeedItem(needItemWnd.GetScript());
	needItemScript.Init(("RelicWnd." $ needItemWnd.m_WindowNameWithFullPath));
	needItemScript.DelegateItemUpdate = DelegateNeedItemOnUpdateItem;
	sucRelicTextBox = GetTextBoxHandle((resultSuccessWnd.m_WindowNameWithFullPath $ ".RelicName0_txt"));
	sucRelicLevelTextBox = GetTextBoxHandle((resultSuccessWnd.m_WindowNameWithFullPath $ ".RelicFigure0_txt"));
	sucPrevLevelTextBox = GetTextBoxHandle((resultSuccessWnd.m_WindowNameWithFullPath $ ".PrvUpgrade_txt"));
	sucNextLevelTextBox = GetTextBoxHandle((resultSuccessWnd.m_WindowNameWithFullPath $ ".NextUpgrade_txt"));
	sucMaxLevelTextBox = GetTextBoxHandle((resultSuccessWnd.m_WindowNameWithFullPath $ ".MaxLevel_txt"));
	sucLevelArrowTex = GetTextureHandle((resultSuccessWnd.m_WindowNameWithFullPath $ ".UpgradeArrow_tex"));
	failRelicTextBox = GetTextBoxHandle((resultFailWnd.m_WindowNameWithFullPath $ ".RelicName1_txt"));
	failRelicLevelTextBox = GetTextBoxHandle((resultFailWnd.m_WindowNameWithFullPath $ ".RelicFigure1_txt"));
	costDisableWnd = GetWindowHandle((needItemContainerWnd.m_WindowNameWithFullPath $ ".CostDisableWnd"));
	disableWnd = GetWindowHandle((ownerFullPath $ ".DisableWnd"));
	ResultEffectViewport = GetEffectViewportWndHandle((resultWnd.m_WindowNameWithFullPath $ ".UpgradeEffectViewport"));
	stuffTexArray.Length = 0;
	i = 0;
	while((i < 4))
	{
		stuffTexArray[i] = GetTextureHandle(((stuffWnd.m_WindowNameWithFullPath $ ".RelicItem") $ string(i)));
		i++;
	}
	parentRect = m_hOwnerWnd.GetRect();
	relicInfoWndRect = relicInfoWnd.GetRect();
	relicInfoWndRect.nX = (relicInfoWndRect.nX - parentRect.nX);
	relicInfoWndRect.nY = (relicInfoWndRect.nY - parentRect.nY);
	targetRelicSlot = new Class'InterfaceClassic.RelicWndSlot';
	targetRelicSlot.Init(relicSlotWnd);
	Class'InterfaceClassic.RelicWnd'.static.Inst().DelegateChangeUpgradeStuff = OnChangeUpgradeStuff;
	return;
}

function UpdateUpgradeInfo()
{
	local int i, Prob;
	local RelicWnd.RelicUpgradeInfo upgradeInfo;
	local TextureHandle stuffTex;
	local RelicsMainUIData relicUIData;
	local ItemInfo stuffItemInfo;
	local RelicsPlayUIData relicPlayData;
	local L2ItemAmount CostItem;
	local bool isRegistered;

	upgradeInfo = Class'InterfaceClassic.RelicWnd'.static.Inst().GetUpgradeInfo();
	if((upgradeInfo.targetRelicId != 0))
	{
		GetRelicsPlayData(ERPDT_Upgrade, upgradeInfo.RelicInfo.Data.Grade, relicPlayData);
		isRegistered = true;
	}
	if(isRegistered)
	{
		targetRelicSlot.SetInfo(upgradeInfo.RelicInfo, true);
		infoDisableWnd.HideWindow();
		probTitleTextBox.ShowWindow();
		probTextBox.ShowWindow();
		statChangeInfoWnd.ShowWindow();
		normalBGTex.HideWindow();
		registeredBGTex.ShowWindow();
		CostItem = relicPlayData.CostItems[0];
		needItemScript.setId(GetItemID(CostItem.ItemClassID));
		needItemScript.SetNumNeed(INT64(CostItem.ItemAmount));
		costDisableWnd.HideWindow();
		statPrevHtml.LoadHtmlFromString(Class'InterfaceClassic.RelicWnd'.static.Inst().GetHtmlSkillStr(upgradeInfo.RelicInfo.Data.Skills[upgradeInfo.RelicInfo.Level]));
		statNextHtml.LoadHtmlFromString(Class'InterfaceClassic.RelicWnd'.static.Inst().GetHtmlSkillStr(upgradeInfo.RelicInfo.Data.Skills[(upgradeInfo.RelicInfo.Level + 1)]));
		maxLevelInfoBtn.ShowWindow();
		maxLevelInfoBtn.SetTooltipCustomType(MakeTooltipSimpleText(((GetSystemString(14565) $ ": +") $ string((upgradeInfo.RelicInfo.Data.Skills.Length - 1)))));
		relicNameTextBox.SetText(getInstanceL2Util().GetDollNameWithGrade(GetItemInfoByClassID(upgradeInfo.RelicInfo.Data.ItemID).Name, ERelicGrade(upgradeInfo.RelicInfo.Data.Grade)));
		relicNameTextBox.SetTextColor(getInstanceL2Util().GetRelicTextColor(ERelicGrade(upgradeInfo.RelicInfo.Data.Grade)));
		relicResetBtn.ShowWindow();
	}
	else
	{
		targetRelicSlot.ResetInfo();
		infoDisableWnd.ShowWindow();
		probTitleTextBox.HideWindow();
		probTextBox.HideWindow();
		statChangeInfoWnd.HideWindow();
		normalBGTex.ShowWindow();
		registeredBGTex.HideWindow();
		resultStatInfoWnd.HideWindow();
		ShowResultWnd(false, false);
		HideModalAndDialog();
		needItemScript.setId(GetItemID(0));
		needItemScript.SetNumNeed(INT64(0));
		costDisableWnd.ShowWindow();
		maxLevelInfoBtn.HideWindow();
		relicNameTextBox.SetText("");
		relicResetBtn.HideWindow();
	}
	if((upgradeInfo.stuffArray.Length > 0))
	{
		if(needItemScript.canBuy())
		{
			upgradeBtn.SetEnable(true);
		}
		else
		{
			upgradeBtn.SetEnable(false);
		}
	}
	else
	{
		upgradeBtn.SetEnable(false);
	}
	i = 0;
	while((i < stuffTexArray.Length))
	{
		stuffTex = stuffTexArray[i];
		if((i < upgradeInfo.stuffArray.Length))
		{
			GetRelicsMainData(upgradeInfo.stuffArray[i], relicUIData);
			stuffItemInfo = GetItemInfoByClassID(relicUIData.ItemID);
			stuffTex.SetTexture(stuffItemInfo.IconName);
			i++;
			continue;
		}
		stuffTex.SetTexture("");
		i++;
	}
	if((upgradeInfo.stuffArray.Length == 0))
	{
		Prob = 0;
	}
	else
	{
		Prob = relicPlayData.UpgradeProbs[(upgradeInfo.stuffArray.Length - 1)];
	}
	probTextBox.SetText((string(Prob) $ "%"));
	return;
}

function ResetInfo()
{
	needItemScript.RemoveInventoryObject();
	return;
}

function ShowResultWnd(bool isShow, bool IsSuccess, optional int Level, optional int relicId)
{
	local RelicWnd.RelicUpgradeInfo upgradeInfo;
	local ItemInfo relicItemInfo;

	upgradeInfo = Class'InterfaceClassic.RelicWnd'.static.Inst().GetUpgradeInfo();
	relicItemInfo = GetItemInfoByClassID(upgradeInfo.RelicInfo.Data.ItemID);
	if(isShow)
	{
		resultWnd.ShowWindow();
		relicBGWnd.HideWindow();
		stuffWnd.HideWindow();
		resultStatInfoWnd.ShowWindow();
		resultResetBtn.ShowWindow();
		statChangeInfoWnd.HideWindow();
		needItemContainerWnd.HideWindow();
		relicInfoWnd.MoveC(relicInfoWndRect.nX, (relicInfoWndRect.nY + 57));
		Class'InterfaceClassic.RelicWnd'.static.Inst().relicListScript.ShowDisableWnd();
	}
	else
	{
		resultWnd.HideWindow();
		relicBGWnd.ShowWindow();
		stuffWnd.ShowWindow();
		resultStatInfoWnd.HideWindow();
		resultResetBtn.HideWindow();
		needItemContainerWnd.ShowWindow();
		relicInfoWnd.MoveC(relicInfoWndRect.nX, relicInfoWndRect.nY);
		upgradeBtn.SetButtonName(14508);
		Class'InterfaceClassic.RelicWnd'.static.Inst().relicListScript.hideDisableWnd();
		return;
	}
	if(IsSuccess)
	{
		targetRelicSlot.SetInfo(upgradeInfo.RelicInfo, true);
		sucRelicTextBox.SetText(getInstanceL2Util().GetDollNameWithGrade(relicItemInfo.Name, ERelicGrade(upgradeInfo.RelicInfo.Data.Grade)));
		sucRelicTextBox.SetTextColor(getInstanceL2Util().GetRelicTextColor(ERelicGrade(upgradeInfo.RelicInfo.Data.Grade)));
		sucRelicLevelTextBox.SetText(("+" $ string(Level)));
		if((upgradeInfo.RelicInfo.Level >= (upgradeInfo.RelicInfo.Data.Skills.Length - 1)))
		{
			sucMaxLevelTextBox.ShowWindow();
			sucPrevLevelTextBox.HideWindow();
			sucNextLevelTextBox.HideWindow();
			sucLevelArrowTex.HideWindow();
			upgradeBtn.SetEnable(false);
		}
		else
		{
			sucPrevLevelTextBox.SetText(("+" $ string((Level - 1))));
			sucNextLevelTextBox.SetText(("+" $ string(Level)));
			sucMaxLevelTextBox.HideWindow();
			sucPrevLevelTextBox.ShowWindow();
			sucNextLevelTextBox.ShowWindow();
			sucLevelArrowTex.ShowWindow();
			upgradeBtn.SetEnable(true);
		}
		resultSuccessWnd.ShowWindow();
		resultFailWnd.HideWindow();
	}
	else
	{
		resultSuccessWnd.HideWindow();
		resultFailWnd.ShowWindow();
		failRelicTextBox.SetText(getInstanceL2Util().GetDollNameWithGrade(relicItemInfo.Name, ERelicGrade(upgradeInfo.RelicInfo.Data.Grade)));
		failRelicTextBox.SetTextColor(getInstanceL2Util().GetRelicTextColor(ERelicGrade(upgradeInfo.RelicInfo.Data.Grade)));
		failRelicLevelTextBox.SetText(("+" $ string(Level)));
		upgradeBtn.SetEnable(true);
	}
	upgradeBtn.SetButtonName(1731);
	resultStatHtml.LoadHtmlFromString(Class'InterfaceClassic.RelicWnd'.static.Inst().GetHtmlSkillStr(upgradeInfo.RelicInfo.Data.Skills[Level]));
	return;
}

function setResult(int Result, int Level, int relicId)
{
	if((Result == 1))
	{
		ShowResultWnd(true, true, Level, relicId);
		ShowResultEffect(true);
	}
	else if((Result == 0))
	{
		ShowResultWnd(true, false, Level, relicId);
		ShowResultEffect(false);
	}
	else
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4334));
	}
	return;
}

function bool IsShowResultWnd()
{
	return resultWnd.IsShowWindow();
}

function ShowUpgradeDialog()
{
	DialogHide();
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemString(14567));
	ShowModal();
	Class'InterfaceClassic.DialogBox'.static.Inst().AnchorToTarget("RelicWnd", 250, 20);
	Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnCancel = OnUpgradeDialogCancel;
	Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnOK = OnUpgradeDialogConfirm;
	Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnHide = OnUpgradeDialogHide;
	Class'InterfaceClassic.DialogBox'.static.Inst().SetDefaultAction(EDefaultOK);
	return;
}

function ShowModal()
{
	Class'InterfaceClassic.RelicWnd'.static.Inst().relicListScript.ShowDisableWnd();
	disableWnd.ShowWindow();
	return;
}

function HideModal()
{
	Class'InterfaceClassic.RelicWnd'.static.Inst().relicListScript.hideDisableWnd();
	disableWnd.HideWindow();
	return;
}

function HideModalAndDialog()
{
	if((DialogIsMine() == true))
	{
		DialogHide();
	}
	HideModal();
	return;
}

function ShowResultEffect(bool IsSuccess)
{
	if(IsSuccess)
	{
		ResultEffectViewport.SetCameraDistance(130.0000000);
		ResultEffectViewport.SetOffset(setVector(-3, 0, 0));
		ResultEffectViewport.SpawnEffect("LineageEffect2.ui_relic_success");
		PlaySound("Itemsound3.ui_enchant_success_sfx");
	}
	else
	{
		ResultEffectViewport.SetCameraDistance(115.0000000);
		ResultEffectViewport.SetOffset(setVector(-3, -1, 0));
		ResultEffectViewport.SpawnEffect("LineageEffect2.ui_relic_fail");
		PlaySound("Itemsound3.ui_enchant_fail_sfx");
	}
	return;
}

function DelegateNeedItemOnUpdateItem(UIControlNeedItem Script)
{
	return;
}

function OnChangeUpgradeStuff()
{
	UpdateUpgradeInfo();
	return;
}

event OnUpgradeDialogConfirm()
{
	if((DialogIsMine() == true))
	{
		Class'InterfaceClassic.RelicWnd'.static.Inst().RequestRelicUpgrade();
		HideModal();
	}
	return;
}

event OnUpgradeDialogCancel()
{
	if((DialogIsMine() == true))
	{
		HideModal();
	}
	return;
}

event OnUpgradeDialogHide()
{
	if((DialogIsMine() == true))
	{
		HideModal();
	}
	return;
}

event OnClickButton(string btnName)
{
	switch(btnName)
	{
		case "RelicUpgrade_btn":
			if(IsShowResultWnd())
			{
				ShowResultWnd(false, false);
				Class'InterfaceClassic.RelicWnd'.static.Inst().ResetUpgradeStuffList();
			}
			else
			{
				ShowUpgradeDialog();
			}
			break;
		case "RelicResetBtn":
			Class'InterfaceClassic.RelicWnd'.static.Inst().ResetUpgradeTargetRelic();
			statPrevHtml.SetScrollPosition(0);
			statNextHtml.SetScrollPosition(0);
			break;
		case "RelicmaterialResetBtn":
			Class'InterfaceClassic.RelicWnd'.static.Inst().ResetUpgradeStuffList();
			break;
		case "RelicUpgradeReset_btn":
			Class'InterfaceClassic.RelicWnd'.static.Inst().ResetUpgradeTargetRelic();
			statPrevHtml.SetScrollPosition(0);
			statNextHtml.SetScrollPosition(0);
			break;
		default:
			break;
	}
	return;
}

event OnLoad()
{
	Initialize();
	return;
}
