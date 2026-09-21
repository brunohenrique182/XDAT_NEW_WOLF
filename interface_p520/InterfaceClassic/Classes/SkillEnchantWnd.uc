class SkillEnchantWnd extends UICommonAPI
	dependson(UIPacket);

const COUNT_DIALOG_ID = 1;

struct SkillEnchantUIInfo
{
	var array<ChargeExpItem> invenItemInfos;
	var array<ChargeExpItem> chargeItemInfos;
	var array<int> subLevelInfos;
	var int enchantLevel;
	var int enchantMaxLavel;
	var SkillInfo SkillInfo;
	var int replaceSkillId;
	var UIPacket._S_EX_SKILL_ENCHANT_INFO enchantInfo;
};

struct ChargeExpectInfo
{
	var ItemInfo costItemInfo;
	var int totalPoint;
	var array<UIPacket._ItemServerInfo> chargeItems;
};

var WindowHandle Me;
var WindowHandle dialogContainerWnd;
var WindowHandle enchantDialogWnd;
var WindowHandle enchantResultDialogWnd;
var WindowHandle errorDialogWnd;
var WindowHandle costDisableWnd;
var UIControlDialogAssets chargeDialogAsset;
var ItemWindowHandle skillItemWnd;
var ItemWindowHandle invenItemWnd;
var ItemWindowHandle chargeItemWnd;
var ItemWindowHandle chargeCostItemWnd;
var TextBoxHandle skillNameTextBox;
var TextBoxHandle skillLevelTextBox;
var TextBoxHandle chargeProbTextBox;
var TextBoxHandle chargeCostTextBox;
var TextBoxHandle statusBarTextBox;
var TextBoxHandle maxLevelTextBox;
var TextBoxHandle skillEnchantLvTextBox;
var StatusBarHandle chargeStatusBar;
var StatusBarHandle chargeExpectStatusBar;
var UIControlNeedItemList needItemScript;
var UIControlNeedItemList dialogNeedItemScript;
var HtmlHandle currentDescHtml;
var HtmlHandle nextDescHtml;
var ButtonHandle chargeBtn;
var ButtonHandle EnchantBtn;
var EffectViewportWndHandle ResultEffectViewport;
var TextureHandle skillGradeTex;
var SkillEnchantUIInfo _info;
var bool _isNeedShowResult;
var int _enchantResult;
var bool _isOpenedDialog;
var bool _isExtractItemUsed;

static function SkillEnchantWnd Inst()
{
	return SkillEnchantWnd(GetScript("SkillEnchantWnd"));
}

function Initialize()
{
	InitControls();
	return;
}

function InitControls()
{
	local string ownerFullPath;
	local WindowHandle descContainerWnd, chargeContainerWnd, needItemWnd, dialogNeedItemWnd, chargeDialogWnd;
	local RichListCtrlHandle needItemRichList, dialogNeedItemRichList;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	skillItemWnd = GetItemWindowHandle((ownerFullPath $ ".SkillItem_ItemWindow"));
	skillNameTextBox = GetTextBoxHandle((ownerFullPath $ ".SkillName_Txt"));
	skillLevelTextBox = GetTextBoxHandle((ownerFullPath $ ".SkillLevel_Txt"));
	skillEnchantLvTextBox = GetTextBoxHandle((ownerFullPath $ ".SkillEnchantNum_Txt"));
	skillGradeTex = GetTextureHandle((ownerFullPath $ ".IconPanel_Tex"));
	descContainerWnd = GetWindowHandle((ownerFullPath $ ".EnchantEffectItem_Wnd"));
	currentDescHtml = GetHtmlHandle((descContainerWnd.m_WindowNameWithFullPath $ ".CurrentEffectDesc1_Txt"));
	nextDescHtml = GetHtmlHandle((descContainerWnd.m_WindowNameWithFullPath $ ".CurrentEffectDesc2_Txt"));
	maxLevelTextBox = GetTextBoxHandle((descContainerWnd.m_WindowNameWithFullPath $ ".MaxLevel_txt"));
	chargeContainerWnd = GetWindowHandle((ownerFullPath $ ".EnchantInventory_Wnd"));
	chargeProbTextBox = GetTextBoxHandle((chargeContainerWnd.m_WindowNameWithFullPath $ ".Probability_Txt"));
	chargeStatusBar = GetStatusBarHandle((chargeContainerWnd.m_WindowNameWithFullPath $ ".statusCraftPoint"));
	chargeStatusBar.SetDrawPoint(false);
	chargeExpectStatusBar = GetStatusBarHandle((chargeContainerWnd.m_WindowNameWithFullPath $ ".statusExpectPoint"));
	chargeExpectStatusBar.SetDrawPoint(false);
	statusBarTextBox = GetTextBoxHandle((chargeContainerWnd.m_WindowNameWithFullPath $ ".StatusBar_Txt"));
	invenItemWnd = GetItemWindowHandle((chargeContainerWnd.m_WindowNameWithFullPath $ ".Inventory_Wnd.InvenSlot_ItemWindow"));
	chargeItemWnd = GetItemWindowHandle((chargeContainerWnd.m_WindowNameWithFullPath $ ".AbsorptionItem_Wnd.ChargeSlot_ItemWindow"));
	chargeCostItemWnd = GetItemWindowHandle((chargeContainerWnd.m_WindowNameWithFullPath $ ".AbsorptionCost_ItemWindow"));
	chargeCostTextBox = GetTextBoxHandle((chargeContainerWnd.m_WindowNameWithFullPath $ ".AbsorptionCost_Txt"));
	chargeBtn = GetButtonHandle((chargeContainerWnd.m_WindowNameWithFullPath $ ".Absorption_Btn"));
	EnchantBtn = GetButtonHandle((ownerFullPath $ ".Enchant_Btn"));
	costDisableWnd = GetWindowHandle((chargeContainerWnd.m_WindowNameWithFullPath $ ".Disable_Wnd"));
	dialogContainerWnd = GetWindowHandle((ownerFullPath $ ".Popup_Wnd"));
	enchantDialogWnd = GetWindowHandle((dialogContainerWnd.m_WindowNameWithFullPath $ ".SkillEnchantPopup_Wnd"));
	enchantResultDialogWnd = GetWindowHandle((dialogContainerWnd.m_WindowNameWithFullPath $ ".SkillEnchantResultPopup_Wnd"));
	errorDialogWnd = GetWindowHandle((dialogContainerWnd.m_WindowNameWithFullPath $ ".Error_Wnd"));
	ResultEffectViewport = GetEffectViewportWndHandle((enchantResultDialogWnd.m_WindowNameWithFullPath $ ".EnchantEffectViewport"));
	chargeDialogWnd = GetWindowHandle((dialogContainerWnd.m_WindowNameWithFullPath $ ".UIControlDialogAsset"));
	chargeDialogAsset = Class'InterfaceClassic.UIControlDialogAssets'.static.InitScript(chargeDialogWnd);
	chargeDialogAsset.DelegateOnCancel = OnChargeDialogCancel;
	chargeDialogAsset.DelegateOnClickBuy = OnChargeDialogConfirm;
	chargeDialogAsset.SetUseBuyItem(false);
	chargeDialogAsset.SetUseNeedItem(true);
	chargeDialogAsset.SetUseNumberInput(false);
	needItemWnd = GetWindowHandle((ownerFullPath $ ".Cost_Wnd"));
	needItemWnd.SetScript("UIControlNeedItemList");
	needItemScript = UIControlNeedItemList(needItemWnd.GetScript());
	needItemRichList = GetRichListCtrlHandle((needItemWnd.m_WindowNameWithFullPath $ ".Cost_RichListCtrl"));
	needItemScript.SetRichListControler(needItemRichList);
	dialogNeedItemWnd = GetWindowHandle((enchantDialogWnd.m_WindowNameWithFullPath $ ".Cost_Wnd"));
	dialogNeedItemWnd.SetScript("UIControlNeedItemList");
	dialogNeedItemScript = UIControlNeedItemList(dialogNeedItemWnd.GetScript());
	dialogNeedItemRichList = GetRichListCtrlHandle((dialogNeedItemWnd.m_WindowNameWithFullPath $ ".Cost_RichListCtrl"));
	dialogNeedItemScript.SetRichListControler(dialogNeedItemRichList);
	return;
}

function ResetInfo()
{
	local SkillEnchantUIInfo defaultInfo;

	_info = defaultInfo;
	_isNeedShowResult = false;
	_enchantResult = 0;
	return;
}

function int ConvertSubLevel(int enchantLevel)
{
	local int SubLevel;

	SubLevel = -1;
	if((enchantLevel < _info.subLevelInfos.Length))
	{
		SubLevel = _info.subLevelInfos[enchantLevel];
	}
	return SubLevel;
}

function string ConvertHtmlDesc(string SkillDesc)
{
	local string htmlStr;

	htmlStr = SkillDesc;
	htmlStr = Substitute(htmlStr, "<", "&lt;", false);
	htmlStr = Substitute(htmlStr, ">", "&gt;", false);
	htmlStr = Substitute(htmlStr, "&lt;font", "<font", false);
	htmlStr = Substitute(htmlStr, "\"&gt;", "\">", false);
	htmlStr = Substitute(htmlStr, "&lt;/font&gt;", "</font>", false);
	htmlStr = Substitute(htmlStr, "\\n\\n", "<br>", false);
	htmlStr = Substitute(htmlStr, "\\n", "<br1>", false);
	htmlStr = htmlSetHtmlStart(htmlStr);
	return htmlStr;
}

function string GetSkillGradeTextureName(int Grade)
{
	switch(Grade)
	{
		case 1:
			return "Icon.icon_panel.SkillGrade_panel_D_64";
		case 2:
			return "Icon.icon_panel.SkillGrade_panel_C_64";
		case 3:
			return "Icon.icon_panel.SkillGrade_panel_B_64";
		case 4:
			return "Icon.icon_panel.SkillGrade_panel_A_64_Ani_00";
		case 5:
			return "Icon.icon_panel.SkillGrade_panel_S_64_Ani_00";
		default:
			return "";
	}
}

function string GetEnchantLvName(int enchantLevel)
{
	if((enchantLevel <= 0))
	{
		return "";
	}
	return ("+" $ string(enchantLevel));
}

function string GetSkillLevelStr(int Level)
{
	if((Level <= 0))
	{
		return "";
	}
	return ("Lv." $ string(Level));
}

function INT64 GetValidChargeCount(int itemSId, INT64 Count)
{
	local int leftPoint;
	local ChargeExpItem TargetInfo;
	local ChargeExpectInfo expectInfo;

	FindInvenChargeExpItem(itemSId, TargetInfo);
	expectInfo = GetChargeExpectInfo();
	leftPoint = (_info.enchantInfo.nMaxExp - (expectInfo.totalPoint + _info.enchantInfo.nEXP));
	if((leftPoint <= 0))
	{
		return INT64(0);
	}
	return Min64(Count, INT64(appCeil((float(leftPoint) / float(TargetInfo.ChargeExp)))));
}

function InteractionChargeItem(bool isUnregister, ItemInfo TargetInfo, bool isAllItem)
{
	local int Index;
	local ItemInfo tmpItemInfo;
	local INT64 ItemNum;
	local ChargeExpItem invenChargeExpItem;

	if(((isUnregister == false) && (_info.enchantInfo.nEXP >= _info.enchantInfo.nMaxExp)))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13101));
		return;
	}
	if(((FindInvenChargeExpItem(TargetInfo.Id.ServerID, invenChargeExpItem) == true) && (invenChargeExpItem.TargetLevel > 0)))
	{
		_isExtractItemUsed = true;
		getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "SkillEnchantExtractWnd", 200, 30);
		Class'InterfaceClassic.SkillEnchantExtractWnd'.static.Inst().OpenWindow(_info.SkillInfo.SkillID, _info.SkillInfo.SkillLevel, _info.SkillInfo.SkillSubLevel, invenChargeExpItem.TargetLevel, _info.replaceSkillId, TargetInfo.Id.ClassID, false);
		Me.HideWindow();
		return;
	}
	if((isUnregister == true))
	{
		Index = chargeItemWnd.FindItem(TargetInfo.Id);
		if((Index != -1))
		{
			chargeItemWnd.GetItem(Index, tmpItemInfo);
			ItemNum = tmpItemInfo.ItemNum;
		}
	}
	else
	{
		Index = invenItemWnd.FindItem(TargetInfo.Id);
		if((Index != -1))
		{
			invenItemWnd.GetItem(Index, tmpItemInfo);
			ItemNum = tmpItemInfo.ItemNum;
		}
	}
	if((isAllItem == true))
	{
		if((isUnregister == true))
		{
			UnregisterChargeItem(TargetInfo.Id.ServerID, ItemNum);
		}
		else
		{
			RegisterChargeItem(TargetInfo.Id.ServerID, ItemNum);
		}
	}
	else if((ItemNum > INT64(1)))
	{
		ShowItemCountDialog(isUnregister, TargetInfo, ItemNum);
	}
	else if((isUnregister == true))
	{
		UnregisterChargeItem(TargetInfo.Id.ServerID, INT64(1));
	}
	else
	{
		RegisterChargeItem(TargetInfo.Id.ServerID, INT64(1));
	}
	UpdateInvenControls();
	UpdateChargeGaugeControls();
	return;
}

function RegisterChargeItem(int itemSId, INT64 Count)
{
	local int i;
	local INT64 tmpItemNum;
	local ChargeExpItem invenChargeExpItem;
	local INT64 validCount;

	validCount = GetValidChargeCount(itemSId, Count);
	if((validCount == INT64(0)))
	{
		return;
	}
	i = 0;
	while((i < _info.chargeItemInfos.Length))
	{
		invenChargeExpItem = _info.chargeItemInfos[i];
		if((invenChargeExpItem.item.Id.ServerID == itemSId))
		{
			tmpItemNum = (invenChargeExpItem.item.ItemNum + validCount);
			invenChargeExpItem.item.ItemNum = tmpItemNum;
			_info.chargeItemInfos[i] = invenChargeExpItem;
			Debug((((("RegisterChargeItem : " @ string(itemSId)) @ string(Count)) @ string(validCount)) @ string(tmpItemNum)));
			return;
		}
		i++;
	}
	if((FindInvenChargeExpItem(itemSId, invenChargeExpItem) == true))
	{
		invenChargeExpItem.item.ItemNum = validCount;
		_info.chargeItemInfos.Length = (_info.chargeItemInfos.Length + 1);
		_info.chargeItemInfos[(_info.chargeItemInfos.Length - 1)] = invenChargeExpItem;
	}
	return;
}

function UnregisterChargeItem(int itemSId, INT64 Count)
{
	local int i, RemoveIndex;
	local INT64 tmpItemNum;
	local ChargeExpItem invenChargeExpItem;

	i = 0;
	while((i < _info.chargeItemInfos.Length))
	{
		invenChargeExpItem = _info.chargeItemInfos[i];
		if((invenChargeExpItem.item.Id.ServerID == itemSId))
		{
			tmpItemNum = (invenChargeExpItem.item.ItemNum - Count);
			if((tmpItemNum <= INT64(0)))
			{
				RemoveIndex = i;
				break;
				i++;
				continue;
			}
			invenChargeExpItem.item.ItemNum = tmpItemNum;
			_info.chargeItemInfos[i] = invenChargeExpItem;
			Debug(((("UnregisterChargeItem : " @ string(itemSId)) @ string(Count)) @ string(tmpItemNum)));
			return;
		}
		i++;
	}
	_info.chargeItemInfos.Remove(RemoveIndex, 1);
	return;
}

function bool FindRegisteredChargeItem(int itemSId, out ItemInfo ItemInfo)
{
	local int i;
	local ChargeExpItem tempInfo;

	i = 0;
	while((i < _info.chargeItemInfos.Length))
	{
		tempInfo = _info.chargeItemInfos[i];
		if((tempInfo.item.Id.ServerID == itemSId))
		{
			ItemInfo = tempInfo.item;
			return true;
		}
		i++;
	}
	return false;
}

function bool FindInvenChargeExpItem(int itemSId, out ChargeExpItem outinfo)
{
	local int i;
	local ChargeExpItem tempInfo;

	i = 0;
	while((i < _info.invenItemInfos.Length))
	{
		tempInfo = _info.invenItemInfos[i];
		if((tempInfo.item.Id.ServerID == itemSId))
		{
			outinfo = tempInfo;
			return true;
		}
		i++;
	}
	return false;
}

function ChargeExpectInfo GetChargeExpectInfo()
{
	local ChargeExpectInfo resultInfo;
	local ChargeExpItem tmpExpItemInfo;
	local UIPacket._ItemServerInfo tmpServerItem;
	local array<UIPacket._ItemServerInfo> chargeItems;
	local ItemInfo CostItem;
	local INT64 totalCost;
	local int totalPoint, i;

	i = 0;
	while((i < _info.chargeItemInfos.Length))
	{
		tmpExpItemInfo = _info.chargeItemInfos[i];
		totalPoint = (totalPoint + (int(tmpExpItemInfo.item.ItemNum) * tmpExpItemInfo.ChargeExp));
		if((i == 0))
		{
			CostItem = GetItemInfoByClassID(tmpExpItemInfo.commissionItemId);
		}
		totalCost = (totalCost + (INT64(tmpExpItemInfo.CommissionCount) * tmpExpItemInfo.item.ItemNum));
		tmpServerItem.nItemServerId = tmpExpItemInfo.item.Id.ServerID;
		tmpServerItem.nAmount = tmpExpItemInfo.item.ItemNum;
		chargeItems[chargeItems.Length] = tmpServerItem;
		i++;
	}
	CostItem.ItemNum = totalCost;
	resultInfo.costItemInfo = CostItem;
	resultInfo.chargeItems = chargeItems;
	resultInfo.totalPoint = totalPoint;
	return resultInfo;
}

function ShowItemCountDialog(bool isUnregister, ItemInfo ItemInfo, INT64 maxNum)
{
	DialogHide();
	DialogSetReservedItemID(ItemInfo.Id);
	DialogSetReservedInt(int(isUnregister));
	DialogSetReservedInt2(maxNum);
	DialogSetParamInt64(maxNum);
	DialogSetID(1);
	DialogSetCancelD(1);
	_isOpenedDialog = true;
	DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), ItemInfo.Name));
	dialogContainerWnd.ShowWindow();
	Class'InterfaceClassic.DialogBox'.static.Inst().AnchorToOwner(0, 100);
	Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnCancel = OnItemCountDialogCancel;
	Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnOK = OnItemCountDialogConfirm;
	Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnHide = OnItemCountDialogHide;
	Class'InterfaceClassic.DialogBox'.static.Inst().SetDefaultAction(EDefaultOK);
	return;
}

function ShowChargeDialog()
{
	local string htmlDescText;
	local ChargeExpectInfo expectInfo;

	expectInfo = GetChargeExpectInfo();
	chargeDialogAsset.StartNeedItemList(1);
	htmlDescText = htmlSetHtmlStart(((htmlAddText(GetSystemString(14162), "") $ "<br><br>") $ htmlAddText(GetSystemString(14163), "", getColorHexString(GTColor().Red))));
	chargeDialogAsset.SetDialogDescHtml(htmlDescText);
	chargeDialogAsset.AddNeedItemClassID(expectInfo.costItemInfo.Id.ClassID, expectInfo.costItemInfo.ItemNum);
	chargeDialogAsset.SetItemNum(1);
	dialogContainerWnd.ShowWindow();
	chargeDialogAsset.Show();
	return;
}

function ShowEnchantDialog()
{
	local ItemInfo skillItemInfo;
	local ItemWindowHandle ItemWnd;
	local TextBoxHandle skillNameTextBox, currentELvTextBox, nextELvTextBox, probTextBox;
	local ButtonHandle confirmBtn;

	ItemWnd = GetItemWindowHandle((enchantDialogWnd.m_WindowNameWithFullPath $ ".SkillItem_ItemWindow"));
	skillNameTextBox = GetTextBoxHandle((enchantDialogWnd.m_WindowNameWithFullPath $ ".SkillName_Txt"));
	currentELvTextBox = GetTextBoxHandle((enchantDialogWnd.m_WindowNameWithFullPath $ ".PrvEnchantNum_Txt"));
	nextELvTextBox = GetTextBoxHandle((enchantDialogWnd.m_WindowNameWithFullPath $ ".NextEnchantNum_Txt"));
	probTextBox = GetTextBoxHandle((enchantDialogWnd.m_WindowNameWithFullPath $ ".Probability_Txt"));
	confirmBtn = GetButtonHandle((enchantDialogWnd.m_WindowNameWithFullPath $ ".EnchantDialog_Ok_Btn"));
	if((_info.SkillInfo.LevelHide == true))
	{
		skillNameTextBox.SetText(_info.SkillInfo.SkillName);
	}
	else
	{
		skillNameTextBox.SetText((_info.SkillInfo.SkillName @ GetSkillLevelStr(_info.SkillInfo.SkillLevel)));
	}
	probTextBox.SetText((((GetSystemString(13938) @ ":") @ ConvertFloatToString((float(_info.enchantInfo.nProbPerHundred) / 100.0000000), 2, false)) $ "%"));
	currentELvTextBox.SetText(("+" $ string(_info.enchantLevel)));
	nextELvTextBox.SetText(("+" $ string((_info.enchantLevel + 1))));
	Class'InterfaceClassic.L2Util'.static.GetSkill2ItemInfo(_info.SkillInfo, skillItemInfo);
	skillItemInfo.Id.ClassID = 0;
	skillItemInfo.SubLevel = 0;
	if(!ItemWnd.SetItem(0, skillItemInfo))
	{
		ItemWnd.AddItem(skillItemInfo);
	}
	dialogNeedItemScript.StartNeedItemList(1);
	if((_info.enchantInfo.commissionItem.nItemClassID != 0))
	{
		dialogNeedItemScript.AddNeedItemClassID(_info.enchantInfo.commissionItem.nItemClassID, _info.enchantInfo.commissionItem.nAmount);
		dialogNeedItemScript.SetBuyNum(INT64(1));
	}
	if((((dialogNeedItemScript.GetMaxNumCanBuy() > INT64(0)) && (_info.enchantInfo.nEXP >= _info.enchantInfo.nMaxExp)) && (_info.enchantLevel < _info.enchantMaxLavel)))
	{
		confirmBtn.SetEnable(true);
	}
	else
	{
		confirmBtn.SetEnable(false);
	}
	dialogContainerWnd.ShowWindow();
	enchantDialogWnd.ShowWindow();
	return;
}

function ShowEnchantResultDialog(int Result)
{
	local ItemInfo skillItemInfo;
	local ItemWindowHandle ItemWnd;
	local TextBoxHandle skillNameTextBox, currentELvTextBox, resultTextBox;
	local string resultStr;

	ItemWnd = GetItemWindowHandle((enchantResultDialogWnd.m_WindowNameWithFullPath $ ".SkillItem_ItemWindow"));
	skillNameTextBox = GetTextBoxHandle((enchantResultDialogWnd.m_WindowNameWithFullPath $ ".SkillName_Txt"));
	currentELvTextBox = GetTextBoxHandle((enchantResultDialogWnd.m_WindowNameWithFullPath $ ".PrvEnchantNum_Txt"));
	resultTextBox = GetTextBoxHandle((enchantResultDialogWnd.m_WindowNameWithFullPath $ ".Result_Txt"));
	if((_info.SkillInfo.LevelHide == true))
	{
		skillNameTextBox.SetText(_info.SkillInfo.SkillName);
	}
	else
	{
		skillNameTextBox.SetText((_info.SkillInfo.SkillName @ GetSkillLevelStr(_info.SkillInfo.SkillLevel)));
	}
	currentELvTextBox.SetText(GetEnchantLvName(_info.enchantLevel));
	Class'InterfaceClassic.L2Util'.static.GetSkill2ItemInfo(_info.SkillInfo, skillItemInfo);
	skillItemInfo.Id.ClassID = 0;
	skillItemInfo.SubLevel = 0;
	if(!ItemWnd.SetItem(0, skillItemInfo))
	{
		ItemWnd.AddItem(skillItemInfo);
	}
	if((Result == 0))
	{
		resultStr = GetSystemString(14364);
		ShowResultEffect(true);
	}
	else if((Result == 1))
	{
		resultStr = ((GetSystemString(14365) $ "\\n") $ MakeFullSystemMsg(GetSystemMessage(13812), MakeCostString(string(_info.enchantInfo.nEXP))));
		ShowResultEffect(false);
	}
	else
	{
		resultStr = GetSystemMessage(4559);
	}
	resultTextBox.SetText(resultStr);
	dialogContainerWnd.ShowWindow();
	enchantResultDialogWnd.ShowWindow();
	return;
}

function ShowErrorDialog()
{
	dialogContainerWnd.ShowWindow();
	errorDialogWnd.ShowWindow();
	return;
}

function ShowResultEffect(bool IsSuccess)
{
	if((Me.IsShowWindow() == false))
	{
		return;
	}
	if(IsSuccess)
	{
		ResultEffectViewport.ShowWindow();
		ResultEffectViewport.SetScale(2.4000001);
		ResultEffectViewport.SetCameraDistance(200.0000000);
		ResultEffectViewport.SetCameraPitch(0);
		ResultEffectViewport.SetCameraYaw(0);
		ResultEffectViewport.SpawnEffect("LineageEffect2.ui_Enchant_success");
		PlaySound("Itemsound3.ui_enchant_success_sfx");
	}
	else
	{
		ResultEffectViewport.ShowWindow();
		ResultEffectViewport.SetScale(2.4000001);
		ResultEffectViewport.SetCameraDistance(200.0000000);
		ResultEffectViewport.SetCameraPitch(0);
		ResultEffectViewport.SetCameraYaw(0);
		ResultEffectViewport.SpawnEffect("LineageEffect2.ui_Enchant_fail");
		PlaySound("Itemsound3.ui_enchant_fail_sfx");
	}
	return;
}

function OpenWindow(int SkillID, int Level, int SubLevel, int replaceSkillId)
{
	local SkillInfo SkillInfo, replaceSkillInfo;

	if(!GetSkillInfo(SkillID, Level, SubLevel, SkillInfo))
	{
		Me.HideWindow();
		return;
	}
	_info.SkillInfo = SkillInfo;
	_info.replaceSkillId = replaceSkillId;
	if(((replaceSkillId >= 0) && GetSkillInfo(replaceSkillId, Level, SubLevel, replaceSkillInfo)))
	{
		_info.SkillInfo.SkillName = replaceSkillInfo.SkillName;
		_info.SkillInfo.Grade = replaceSkillInfo.Grade;
		_info.SkillInfo.TexName = replaceSkillInfo.TexName;
	}
	if((GetSkillSubLevelList(SkillID, Level, _info.subLevelInfos) == 0))
	{
		Me.HideWindow();
		return;
	}
	_info.enchantMaxLavel = (_info.subLevelInfos.Length - 1);
	_info.enchantLevel = Class'InterfaceClassic.SkillWnd'.static.Inst().ConvertEnchantLevel(SubLevel);
	UpdateUIControls();
	Rq_C_EX_SKILL_ENCHANT_INFO(SkillID, Level, SubLevel);
	Me.ShowWindow();
	return;
}

function CloseDialog()
{
	dialogContainerWnd.HideWindow();
	enchantDialogWnd.HideWindow();
	enchantResultDialogWnd.HideWindow();
	chargeDialogAsset.Hide();
	errorDialogWnd.HideWindow();
	return;
}

function UpdateSkillInfoControls()
{
	local ItemInfo skillItemInfo;
	local SkillInfo tempSkillInfo, descSkillInfo;

	skillNameTextBox.SetText(_info.SkillInfo.SkillName);
	if(((_info.replaceSkillId >= 0) && GetSkillInfo(_info.replaceSkillId, _info.SkillInfo.SkillLevel, _info.SkillInfo.SkillSubLevel, tempSkillInfo)))
	{
		descSkillInfo = tempSkillInfo;
	}
	else
	{
		descSkillInfo = _info.SkillInfo;
	}
	if((_info.SkillInfo.LevelHide == true))
	{
		skillLevelTextBox.SetText("");
	}
	else
	{
		skillLevelTextBox.SetText(GetSkillLevelStr(_info.SkillInfo.SkillLevel));
	}
	skillEnchantLvTextBox.SetText(GetEnchantLvName(_info.enchantLevel));
	if((skillEnchantLvTextBox.GetText() == ""))
	{
		skillEnchantLvTextBox.SetWindowSize(0, skillEnchantLvTextBox.GetRect().nHeight);
	}
	else
	{
		skillEnchantLvTextBox.SetText((skillEnchantLvTextBox.GetText() $ " "));
	}
	Class'InterfaceClassic.L2Util'.static.GetSkill2ItemInfo(_info.SkillInfo, skillItemInfo);
	skillItemInfo.Id.ClassID = 0;
	skillItemInfo.SubLevel = 0;
	if(!skillItemWnd.SetItem(0, skillItemInfo))
	{
		skillItemWnd.AddItem(skillItemInfo);
	}
	skillGradeTex.SetTexture(GetSkillGradeTextureName(_info.SkillInfo.Grade));
	currentDescHtml.LoadHtmlFromString(ConvertHtmlDesc(descSkillInfo.SkillDesc));
	if((_info.enchantLevel == _info.enchantMaxLavel))
	{
		nextDescHtml.LoadHtmlFromString(ConvertHtmlDesc(""));
		maxLevelTextBox.ShowWindow();
		costDisableWnd.ShowWindow();
	}
	else
	{
		GetSkillInfo(descSkillInfo.SkillID, _info.SkillInfo.SkillLevel, ConvertSubLevel((_info.enchantLevel + 1)), tempSkillInfo);
		nextDescHtml.LoadHtmlFromString(ConvertHtmlDesc(tempSkillInfo.SkillDesc));
		maxLevelTextBox.HideWindow();
		costDisableWnd.HideWindow();
	}
	return;
}

function UpdateEnchantInfoControls()
{
	needItemScript.StartNeedItemList(1);
	if((_info.enchantInfo.commissionItem.nItemClassID != 0))
	{
		needItemScript.AddNeedItemClassID(_info.enchantInfo.commissionItem.nItemClassID, _info.enchantInfo.commissionItem.nAmount);
		needItemScript.SetBuyNum(INT64(1));
	}
	if((((needItemScript.GetMaxNumCanBuy() > INT64(0)) && (_info.enchantInfo.nEXP >= _info.enchantInfo.nMaxExp)) && (_info.enchantLevel < _info.enchantMaxLavel)))
	{
		EnchantBtn.SetEnable(true);
	}
	else
	{
		EnchantBtn.SetEnable(false);
	}
	return;
}

function UpdateChargeGaugeControls()
{
	local ChargeExpectInfo ChargeExpectInfo;
	local bool isDisableChargeBtn;

	chargeProbTextBox.SetText((((GetSystemString(13938) @ ":") @ ConvertFloatToString((float(_info.enchantInfo.nProbPerHundred) / 100.0000000), 2, false)) $ "%"));
	chargeStatusBar.SetPoint(INT64(_info.enchantInfo.nEXP), INT64(_info.enchantInfo.nMaxExp));
	ChargeExpectInfo = GetChargeExpectInfo();
	chargeExpectStatusBar.SetPoint(INT64((_info.enchantInfo.nEXP + ChargeExpectInfo.totalPoint)), INT64(_info.enchantInfo.nMaxExp));
	chargeCostTextBox.SetText(MakeCostStringINT64(ChargeExpectInfo.costItemInfo.ItemNum));
	statusBarTextBox.SetText(((MakeCostString(string((_info.enchantInfo.nEXP + ChargeExpectInfo.totalPoint))) @ "/") @ MakeCostString(string(_info.enchantInfo.nMaxExp))));
	if(!chargeCostItemWnd.SetItem(0, ChargeExpectInfo.costItemInfo))
	{
		chargeCostItemWnd.AddItem(ChargeExpectInfo.costItemInfo);
	}
	if((_info.enchantInfo.nEXP >= _info.enchantInfo.nMaxExp))
	{
		chargeBtn.SetEnable(false);
		return;
	}
	if((ChargeExpectInfo.totalPoint == 0))
	{
		isDisableChargeBtn = true;
	}
	if((GetInventoryItemCount(ChargeExpectInfo.costItemInfo.Id) < ChargeExpectInfo.costItemInfo.ItemNum))
	{
		chargeCostTextBox.SetTextColor(getInstanceL2Util().DRed);
		isDisableChargeBtn = true;
	}
	else
	{
		chargeCostTextBox.SetTextColor(getInstanceL2Util().White);
	}
	chargeBtn.SetEnable(!isDisableChargeBtn);
	return;
}

function UpdateInvenControls()
{
	local int i;
	local INT64 tmpItemNum;
	local array<ChargeExpItem> invenInfos;
	local ItemInfo tmpInvenItemInfo, tmpChargeItemInfo;

	GetEnchantExpItemListFromInven(_info.SkillInfo.Grade, _info.SkillInfo.SkillSubLevel, invenInfos);
	_info.invenItemInfos = invenInfos;
	invenItemWnd.Clear();
	chargeItemWnd.Clear();
	i = 0;
	while((i < invenInfos.Length))
	{
		tmpInvenItemInfo = invenInfos[i].item;
		if((FindRegisteredChargeItem(tmpInvenItemInfo.Id.ServerID, tmpChargeItemInfo) == true))
		{
			if((IsStackableItem(tmpChargeItemInfo.ConsumeType) == true))
			{
				tmpItemNum = (tmpInvenItemInfo.ItemNum - tmpChargeItemInfo.ItemNum);
				if((tmpItemNum > INT64(0)))
				{
					tmpInvenItemInfo.ItemNum = tmpItemNum;
					invenItemWnd.AddItem(tmpInvenItemInfo);
				}
			}
			i++;
			continue;
		}
		invenItemWnd.AddItem(tmpInvenItemInfo);
		i++;
	}
	i = 0;
	while((i < _info.chargeItemInfos.Length))
	{
		tmpInvenItemInfo = _info.chargeItemInfos[i].item;
		chargeItemWnd.AddItem(tmpInvenItemInfo);
		i++;
	}
	return;
}

function UpdateUIControls()
{
	UpdateSkillInfoControls();
	UpdateInvenControls();
	UpdateChargeGaugeControls();
	UpdateEnchantInfoControls();
	return;
}

function ResetChargeInvenAndUpdate()
{
	_info.chargeItemInfos.Length = 0;
	if(Me.IsShowWindow())
	{
		UpdateUIControls();
	}
	return;
}

function Rq_C_EX_SKILL_ENCHANT_INFO(int SkillID, int Level, int SubLevel)
{
	local array<byte> stream;
	local UIPacket._C_EX_SKILL_ENCHANT_INFO packet;

	packet.nSkillID = SkillID;
	packet.nLevel = Level;
	packet.nSubLevel = SubLevel;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_SKILL_ENCHANT_INFO(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(834, stream);
	return;
}

function Rq_C_EX_SKILL_ENCHANT_CHARGE(int SkillID, int Level, int SubLevel, array<UIPacket._ItemServerInfo> Items)
{
	local array<byte> stream;
	local UIPacket._C_EX_SKILL_ENCHANT_CHARGE packet;

	packet.nSkillID = SkillID;
	packet.nLevel = Level;
	packet.nSubLevel = SubLevel;
	packet.Items = Items;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_SKILL_ENCHANT_CHARGE(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(835, stream);
	return;
}

function Rq_C_EX_REQ_ENCHANT_SKILL(int SkillID, int Level, int nextSubLevel)
{
	RequestExEnchantSkill(0, SkillID, Level, nextSubLevel);
	return;
}

function Rs_S_EX_SKILL_ENCHANT_INFO()
{
	local UIPacket._S_EX_SKILL_ENCHANT_INFO packet;
	local SkillInfo newSkillInfo, newReplaceSkillInfo;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_SKILL_ENCHANT_INFO(packet))
	{
		return;
	}
	_info.enchantInfo = packet;
	GetSkillInfo(_info.SkillInfo.SkillID, _info.SkillInfo.SkillLevel, packet.nSubLevel, newSkillInfo);
	_info.SkillInfo = newSkillInfo;
	if(((_info.replaceSkillId >= 0) && GetSkillInfo(_info.replaceSkillId, _info.SkillInfo.SkillLevel, packet.nSubLevel, newReplaceSkillInfo)))
	{
		_info.SkillInfo.SkillName = newReplaceSkillInfo.SkillName;
		_info.SkillInfo.Grade = newReplaceSkillInfo.Grade;
		_info.SkillInfo.TexName = newReplaceSkillInfo.TexName;
	}
	_info.enchantLevel = Class'InterfaceClassic.SkillWnd'.static.Inst().ConvertEnchantLevel(packet.nSubLevel);
	if((_isNeedShowResult == true))
	{
		_isNeedShowResult = false;
		ShowEnchantResultDialog(_enchantResult);
	}
	UpdateUIControls();
	return;
}

function Rs_S_EX_SKILL_ENCHANT_CHARGE()
{
	local UIPacket._S_EX_SKILL_ENCHANT_CHARGE packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_SKILL_ENCHANT_CHARGE(packet))
	{
		return;
	}
	if((packet.cReault == 0))
	{
		ResetChargeInvenAndUpdate();
	}
	else
	{
		Debug("Rs_S_EX_SKILL_ENCHANT_CHARGE ERROR");
	}
	Debug((("Rs_S_EX_SKILL_ENCHANT_CHARGE" @ string(packet.nSkillID)) @ string(packet.cReault)));
	return;
}

function Rs_EV_SkillEnchantResult(string param)
{
	local int Result;

	ParseInt(param, "success", Result);
	_isNeedShowResult = true;
	_enchantResult = Result;
	Debug(("Rs_EV_SkillEnchantResult" @ param));
	return;
}

function Nt_EV_GamingStateExit()
{
	Me.HideWindow();
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(1084));
	RegisterEvent(EV_PacketID(1085));
	RegisterEvent(4600);
	RegisterEvent(160);
	return;
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case EV_PacketID(1084):
			Rs_S_EX_SKILL_ENCHANT_INFO();
			break;
		case EV_PacketID(1085):
			Rs_S_EX_SKILL_ENCHANT_CHARGE();
			break;
		case 4600:
			Rs_EV_SkillEnchantResult(param);
			break;
		case 160:
			Nt_EV_GamingStateExit();
			break;
		default:
			break;
	}
	return;
}

event OnChargeDialogConfirm()
{
	Rq_C_EX_SKILL_ENCHANT_CHARGE(_info.SkillInfo.SkillID, _info.SkillInfo.SkillLevel, _info.SkillInfo.SkillSubLevel, GetChargeExpectInfo().chargeItems);
	CloseDialog();
	return;
}

event OnChargeDialogCancel()
{
	CloseDialog();
	return;
}

event OnItemCountDialogConfirm()
{
	local bool isUnregister;
	local INT64 maxNum;
	local int itemSId;
	local INT64 Number;

	if((DialogIsMine() == false))
	{
		return;
	}
	Number = INT64(DialogGetString());
	isUnregister = bool(DialogGetReservedInt());
	maxNum = DialogGetReservedInt2();
	itemSId = DialogGetReservedItemID().ServerID;
	if(((Number < INT64(1)) || (Number > maxNum)))
	{
		return;
	}
	Debug(((("OnItemCountDialogConfirm : " @ string(Number)) @ string(isUnregister)) @ string(itemSId)));
	if(isUnregister)
	{
		UnregisterChargeItem(itemSId, Number);
	}
	else
	{
		RegisterChargeItem(itemSId, Number);
	}
	UpdateInvenControls();
	UpdateChargeGaugeControls();
	return;
}

event OnItemCountDialogCancel()
{
	if(DialogIsMine())
	{
		if((_isOpenedDialog == true))
		{
			_isOpenedDialog = false;
			CloseDialog();
		}
	}
	return;
}

event OnItemCountDialogHide()
{
	if((DialogIsMine() == true))
	{
		if((_isOpenedDialog == true))
		{
			_isOpenedDialog = false;
			CloseDialog();
		}
	}
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "SPExtract_Btn":
			toggleWindow("SkillSpExtractWnd", true, true);
			break;
		case "AllLevelCheck_Btn":
			Debug("OnClickButton SkillEnchantAllLevelWnd");
			if(Class'InterfaceClassic.SkillEnchantAllLevelWnd'.static.Inst().Me.IsShowWindow())
			{
				Class'InterfaceClassic.SkillEnchantAllLevelWnd'.static.Inst().Me.HideWindow();
			}
			else
			{
				Class'InterfaceClassic.SkillEnchantAllLevelWnd'.static.Inst().ShowInfo(_info.SkillInfo, _info.replaceSkillId);
			}
			break;
		case "Absorption_Btn":
			ShowChargeDialog();
			break;
		case "Enchant_Btn":
			ShowEnchantDialog();
			break;
		case "EnchantDialog_Ok_Btn":
			Rq_C_EX_REQ_ENCHANT_SKILL(_info.SkillInfo.SkillID, _info.SkillInfo.SkillLevel, ConvertSubLevel((_info.enchantLevel + 1)));
			CloseDialog();
			break;
		case "EnchantDialog_Cancel_Btn":
			CloseDialog();
			break;
		case "ResultDialog_Ok_Btn":
			CloseDialog();
			break;
		case "ErrorDialog_Ok_Btn":
			CloseDialog();
			break;
		case "HelpBtn":
			Class'InterfaceClassic.HelpWnd'.static.ShowHelp(76, 1);
			break;
		default:
			break;
	}
	return;
}

event OnDBClickItemWithHandle(ItemWindowHandle ItemWnd, int Index)
{
	local ItemInfo targetItemInfo;
	local bool isUnregister;

	if(((ItemWnd != invenItemWnd) && (ItemWnd != chargeItemWnd)))
	{
		return;
	}
	if((Index >= 0))
	{
		ItemWnd.GetItem(Index, targetItemInfo);
		if((ItemWnd == chargeItemWnd))
		{
			isUnregister = true;
		}
		InteractionChargeItem(isUnregister, targetItemInfo, Class'NWindow.InputAPI'.static.IsAltPressed());
	}
	return;
}

event OnRClickItemWithHandle(ItemWindowHandle ItemWnd, int Index)
{
	OnDBClickItemWithHandle(ItemWnd, Index);
	return;
}

event OnDropItemSource(string strTarget, ItemInfo Info)
{
	if(((strTarget == "ChargeSlot_ItemWindow") && (Info.DragSrcName == "InvenSlot_ItemWindow")))
	{
		InteractionChargeItem(false, Info, Class'NWindow.InputAPI'.static.IsAltPressed());
	}
	else if(((strTarget == "InvenSlot_ItemWindow") && (Info.DragSrcName == "ChargeSlot_ItemWindow")))
	{
		InteractionChargeItem(true, Info, Class'NWindow.InputAPI'.static.IsAltPressed());
	}
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

event OnShow()
{
	if((GetGameStateName() != "GAMINGSTATE"))
	{
		Me.HideWindow();
		return;
	}
	CloseDialog();
	ResultEffectViewport.HideWindow();
	Class'InterfaceClassic.SkillWnd'.static.Inst().Me.HideWindow();
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	Me.SetFocus();
	return;
}

event OnHide()
{
	if(DialogIsMine())
	{
		DialogHide();
	}
	if(Class'InterfaceClassic.SkillEnchantAllLevelWnd'.static.Inst().Me.IsShowWindow())
	{
		Class'InterfaceClassic.SkillEnchantAllLevelWnd'.static.Inst().Me.HideWindow();
	}
	CloseDialog();
	if((_isExtractItemUsed == true))
	{
		_isExtractItemUsed = false;
	}
	else if((GetGameStateName() == "GAMINGSTATE"))
	{
		getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "SkillWnd");
		Class'InterfaceClassic.SkillWnd'.static.Inst().Me.ShowWindow();
	}
	ResetInfo();
	needItemScript.CleariObjects();
	dialogNeedItemScript.CleariObjects();
	return;
}

event OnReceivedCloseUI()
{
	if((dialogContainerWnd.IsShowWindow() && (chargeDialogAsset.Me.IsShowWindow() == false)))
	{
		CloseDialog();
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		Me.HideWindow();
	}
	return;
}
