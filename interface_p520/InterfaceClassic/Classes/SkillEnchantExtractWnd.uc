class SkillEnchantExtractWnd extends UICommonAPI
	dependson(UIPacket);

struct SkillEEUIInfo
{
	var array<int> subLevelInfos;
	var int enchantMaxLevel;
	var SkillInfo SkillInfo;
	var int replaceSkillId;
	var UIPacket._S_EX_SKILL_ENCHANT_INFO enchantInfo;
	var bool isExtractMode;
	var array<SkillExtractData> extractCostData;
	var array<SkillTargetEnchantData> confirmCostData;
	var int confirmItemId;
	var int confirmTargetSubLevel;
	var int selectedCostItemId;
	var int extractSuccessItemID;
	var bool isFinalResult;
};

var WindowHandle Me;
var WindowHandle extractDialogWnd;
var WindowHandle dialogContainer;
var WindowHandle extractFormWnd;
var WindowHandle confirmFormWnd;
var WindowHandle errorDialogWnd;
var WindowHandle resultDialogWnd;
var ButtonHandle extractBtn;
var ButtonHandle confirmBtn;
var ButtonHandle CancelBtn;
var UIControlNeedItemList extractNeedItemScript;
var UIControlNeedItemList confirmNeedItemScript;
var UIControlDialogAssets extractDialogAsset;
var UIControlNeedItemSelectMultiItems extractNeedMultiItemScript;
var UIControlNeedItemSelectMultiItems confirmNeedMultiItemScript;
var RichListCtrlHandle successItemRichList;
var TextBoxHandle errorDialogTextBox;
var TextBoxHandle resultDescTextBox;
var TextBoxHandle resultNameTextBox;
var TextBoxHandle resultLevelTextBox;
var ItemWindowHandle resultItemWnd;
var EffectViewportWndHandle ResultEffectViewport;
var SkillEEUIInfo _info;

static function SkillEnchantExtractWnd Inst()
{
	return SkillEnchantExtractWnd(GetScript("SkillEnchantExtractWnd"));
}

function Initialize()
{
	InitControls();
	return;
}

function InitControls()
{
	local string ownerFullPath;
	local WindowHandle extractNeedItemWnd, confirmNeedItemWnd;
	local RichListCtrlHandle extractNeedItemRichList, confirmNeedItemRichList;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	extractDialogWnd = GetWindowHandle((ownerFullPath $ ".extractDialogWnd"));
	dialogContainer = GetWindowHandle((ownerFullPath $ ".Popup_Wnd"));
	extractDialogAsset = Class'InterfaceClassic.UIControlDialogAssets'.static.InitScript(GetWindowHandle((dialogContainer.m_WindowNameWithFullPath $ ".UIControlDialogAsset")));
	extractDialogAsset.DelegateOnCancel = OnExtractDialogCancel;
	extractDialogAsset.DelegateOnClickBuy = OnExtractDialogConfirm;
	extractDialogAsset.SetUseBuyItem(false);
	extractDialogAsset.SetUseNeedItem(true);
	extractDialogAsset.SetUseNumberInput(false);
	errorDialogWnd = GetWindowHandle((dialogContainer.m_WindowNameWithFullPath $ ".Error_Wnd"));
	resultDialogWnd = GetWindowHandle((dialogContainer.m_WindowNameWithFullPath $ ".SkillEnchantResultPopup_Wnd"));
	errorDialogTextBox = GetTextBoxHandle((errorDialogWnd.m_WindowNameWithFullPath $ ".Description_Txt"));
	resultDescTextBox = GetTextBoxHandle((resultDialogWnd.m_WindowNameWithFullPath $ ".Result_Txt"));
	resultNameTextBox = GetTextBoxHandle((resultDialogWnd.m_WindowNameWithFullPath $ ".SkillName_Txt"));
	resultLevelTextBox = GetTextBoxHandle((resultDialogWnd.m_WindowNameWithFullPath $ ".PrvEnchantNum_Txt"));
	resultItemWnd = GetItemWindowHandle((resultDialogWnd.m_WindowNameWithFullPath $ ".SkillItem_ItemWindow"));
	ResultEffectViewport = GetEffectViewportWndHandle((resultDialogWnd.m_WindowNameWithFullPath $ ".EnchantEffectViewport"));
	extractFormWnd = GetWindowHandle((ownerFullPath $ ".EnchantExtractWnd"));
	confirmFormWnd = GetWindowHandle((ownerFullPath $ ".PerfectEnchantWnd"));
	successItemRichList = GetRichListCtrlHandle((extractFormWnd.m_WindowNameWithFullPath $ ".GetItem_RichListCtrl"));
	successItemRichList.SetSelectable(false);
	successItemRichList.SetSelectedSelTooltip(false);
	confirmBtn = GetButtonHandle((ownerFullPath $ ".Ok_Btn"));
	CancelBtn = GetButtonHandle((ownerFullPath $ ".Cancel_Btn"));
	extractBtn = GetButtonHandle((ownerFullPath $ ".EnchantExtract_Btn"));
	extractNeedItemWnd = GetWindowHandle((extractFormWnd.m_WindowNameWithFullPath $ ".Cost_RichListCtrl_Wnd"));
	extractNeedItemWnd.SetScript("UIControlNeedItemList");
	extractNeedItemScript = UIControlNeedItemList(extractNeedItemWnd.GetScript());
	extractNeedItemRichList = GetRichListCtrlHandle((extractNeedItemWnd.m_WindowNameWithFullPath $ ".Cost_RichListCtrl"));
	extractNeedItemScript.SetRichListControler(extractNeedItemRichList);
	extractNeedItemScript.DelegateOnUpdateItem = OnExtractNeedItemUpdate;
	confirmNeedItemWnd = GetWindowHandle((confirmFormWnd.m_WindowNameWithFullPath $ ".Cost_RichListCtrl_Wnd"));
	confirmNeedItemWnd.SetScript("UIControlNeedItemList");
	confirmNeedItemScript = UIControlNeedItemList(confirmNeedItemWnd.GetScript());
	confirmNeedItemRichList = GetRichListCtrlHandle((confirmNeedItemWnd.m_WindowNameWithFullPath $ ".Cost_RichListCtrl"));
	confirmNeedItemScript.SetRichListControler(confirmNeedItemRichList);
	confirmNeedItemScript.DelegateOnUpdateItem = OnConfirmNeedItemUpdate;
	extractNeedMultiItemScript = Class'InterfaceClassic.UIControlNeedItemSelectMultiItems'.static._InitScript(GetWindowHandle((extractFormWnd.m_WindowNameWithFullPath $ ".UIControlNeedItemSelectMultiItem")));
	extractNeedMultiItemScript = UIControlNeedItemSelectMultiItems(GetWindowHandle((extractFormWnd.m_WindowNameWithFullPath $ ".UIControlNeedItemSelectMultiItem")).GetScript());
	extractNeedMultiItemScript._ConnectPopup(GetWindowHandle((extractFormWnd.m_WindowNameWithFullPath $ ".UIControlNeedItemSelectMultiItemPopupWithDesc")), true, 150);
	extractNeedMultiItemScript.DelegateSelectedItemOnClick = OnExtractNeedItemSelect;
	extractNeedMultiItemScript.DelegateOnUpdateItem = OnExtractMultiNeedItemUpdate;
	confirmNeedMultiItemScript = Class'InterfaceClassic.UIControlNeedItemSelectMultiItems'.static._InitScript(GetWindowHandle((confirmFormWnd.m_WindowNameWithFullPath $ ".UIControlNeedItemSelectMultiItem")));
	confirmNeedMultiItemScript = UIControlNeedItemSelectMultiItems(GetWindowHandle((confirmFormWnd.m_WindowNameWithFullPath $ ".UIControlNeedItemSelectMultiItem")).GetScript());
	confirmNeedMultiItemScript._ConnectPopup(GetWindowHandle((confirmFormWnd.m_WindowNameWithFullPath $ ".UIControlNeedItemSelectMultiItemPopupWithDesc")), true, 150);
	confirmNeedMultiItemScript.DelegateSelectedItemOnClick = OnConfirmNeedItemSelect;
	confirmNeedMultiItemScript.DelegateOnUpdateItem = OnConfirmMultiNeedItemUpdate;
	return;
}

function ResetInfo()
{
	local SkillEEUIInfo defaultInfo;

	_info = defaultInfo;
	return;
}

function InitForm()
{
	if(_info.isExtractMode)
	{
		extractFormWnd.ShowWindow();
		confirmFormWnd.HideWindow();
		extractBtn.ShowWindow();
		confirmBtn.HideWindow();
		CancelBtn.HideWindow();
		SetLevelInfoWnd(_info.SkillInfo, _info.replaceSkillId, 0);
		InitExtractNeedItem();
		UpdateExtractForm();
	}
	else
	{
		extractFormWnd.HideWindow();
		confirmFormWnd.ShowWindow();
		extractBtn.HideWindow();
		confirmBtn.ShowWindow();
		CancelBtn.ShowWindow();
		SetLevelInfoWnd(_info.SkillInfo, _info.replaceSkillId, _info.confirmTargetSubLevel);
		InitConfirmNeedItem();
		UpdateConfirmForm();
	}
	return;
}

function UpdateUIControls()
{
	if(_info.isExtractMode)
	{
		UpdateExtractForm();
	}
	else
	{
		UpdateConfirmForm();
	}
	return;
}

function InitExtractNeedItem()
{
	local int i;
	local SkillExtractData extractData;
	local ItemInfo iInfo;
	local RichListCtrlRowData rowData;

	extractNeedMultiItemScript._StartSelectItems(_info.extractCostData.Length);
	i = 0;
	while((i < _info.extractCostData.Length))
	{
		extractData = _info.extractCostData[i];
		extractNeedMultiItemScript._AddSelectItemClassID(extractData.ItemID, INT64(extractData.ItemCount), (((GetSystemString(642) @ ":") @ ConvertFloatToString((float(extractData.Prob) / 100.0000000), 2, false)) $ "%"));
		i++;
	}
	extractNeedMultiItemScript._EndSelectItems();
	extractNeedItemScript.StartNeedItemList(1);
	extractNeedItemScript.AddNeedItemClassID(57, INT64(0));
	extractNeedItemScript.SetBuyNum(INT64(1));
	successItemRichList.DeleteAllItem();
	rowData.cellDataList.Length = 1;
	if((_info.extractCostData.Length > 0))
	{
		extractData = _info.extractCostData[0];
		_info.extractSuccessItemID = extractData.SuccessItemID;
		iInfo = GetItemInfoByClassID(extractData.SuccessItemID);
		addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, 0, 1);
		AddRichListCtrlItem(rowData.cellDataList[0].drawitems, iInfo, 32, 32, -34, 1);
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, GetItemNameAll(iInfo, true), getInstanceL2Util().BrightWhite, false, 5, 2);
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, iInfo.AdditionalName, getInstanceL2Util().Yellow03, false, 5, 0);
		if((iInfo.AdditionalName == ""))
		{
			AddRichListCtrlString(rowData.cellDataList[0].drawitems, "x1", getInstanceL2Util().White, true, 40, 5);
		}
		else
		{
			AddRichListCtrlString(rowData.cellDataList[0].drawitems, "x1", getInstanceL2Util().White, true, 40, 0);
		}
		successItemRichList.InsertRecord(rowData);
	}
	return;
}

function InitConfirmNeedItem()
{
	local int i;
	local SkillTargetEnchantData confirmData;

	confirmNeedMultiItemScript._StartSelectItems(_info.confirmCostData.Length);
	i = 0;
	while((i < _info.confirmCostData.Length))
	{
		confirmData = _info.confirmCostData[i];
		confirmNeedMultiItemScript._AddSelectItemClassID(confirmData.ItemID, INT64(confirmData.ItemCount));
		i++;
	}
	confirmNeedMultiItemScript._EndSelectItems();
	if((_info.confirmCostData.Length > 0))
	{
		confirmData = _info.confirmCostData[0];
		confirmNeedItemScript.StartNeedItemList(2);
		confirmNeedItemScript.AddNeedItemClassID(_info.confirmItemId, INT64(1));
		confirmNeedItemScript.AddNeedItemClassID(57, INT64(0));
		confirmNeedItemScript.SetBuyNum(INT64(1));
	}
	return;
}

function UpdateExtractForm()
{
	local string skillNameStr;
	local ItemInfo skillItemInfo;
	local SkillExtractData extractData;
	local ItemWindowHandle skillItemWnd;
	local TextureHandle skillGradeTex;
	local TextBoxHandle skillNameTextBox, prevLvTextBox, nextLvTextBox, probTextBox;
	local int selectedMultiCostIndex, Prob;

	selectedMultiCostIndex = extractNeedMultiItemScript._GetSelectedIndexPopup();
	skillItemWnd = GetItemWindowHandle((extractFormWnd.m_WindowNameWithFullPath $ ".SkillItem_ItemWindow"));
	skillGradeTex = GetTextureHandle((extractFormWnd.m_WindowNameWithFullPath $ ".IconPanel_Tex"));
	skillNameTextBox = GetTextBoxHandle((extractFormWnd.m_WindowNameWithFullPath $ ".SkillName_Txt"));
	prevLvTextBox = GetTextBoxHandle((extractFormWnd.m_WindowNameWithFullPath $ ".PrvEnchantNum_Txt"));
	nextLvTextBox = GetTextBoxHandle((extractFormWnd.m_WindowNameWithFullPath $ ".NextEnchantNum_Txt"));
	probTextBox = GetTextBoxHandle((extractFormWnd.m_WindowNameWithFullPath $ ".Probability_Txt"));
	skillNameStr = _info.SkillInfo.SkillName;
	if((_info.SkillInfo.LevelHide == false))
	{
		skillNameStr = (skillNameStr @ Class'InterfaceClassic.SkillEnchantWnd'.static.Inst().GetSkillLevelStr(_info.SkillInfo.SkillLevel));
	}
	skillNameTextBox.SetText(skillNameStr);
	Class'InterfaceClassic.L2Util'.static.GetSkill2ItemInfo(_info.SkillInfo, skillItemInfo);
	skillItemInfo.Id.ClassID = 0;
	skillItemInfo.SubLevel = 0;
	if(!skillItemWnd.SetItem(0, skillItemInfo))
	{
		skillItemWnd.AddItem(skillItemInfo);
	}
	skillGradeTex.SetTexture(Class'InterfaceClassic.SkillEnchantWnd'.static.Inst().GetSkillGradeTextureName(_info.SkillInfo.Grade));
	prevLvTextBox.SetText(("+" $ string(Class'InterfaceClassic.SkillWnd'.static.Inst().ConvertEnchantLevel(_info.SkillInfo.SkillSubLevel))));
	nextLvTextBox.SetText("+0");
	if((selectedMultiCostIndex >= 0))
	{
		if((_info.extractCostData.Length > selectedMultiCostIndex))
		{
			extractData = _info.extractCostData[selectedMultiCostIndex];
			Prob = _info.extractCostData[selectedMultiCostIndex].Prob;
			extractNeedItemScript.StartNeedItemList(1);
			extractNeedItemScript.AddNeedItemClassID(57, extractData.CommissionAdena);
			extractNeedItemScript.SetBuyNum(INT64(1));
			_info.selectedCostItemId = extractData.ItemID;
		}
	}
	probTextBox.SetText((((GetSystemString(642) @ ":") @ ConvertFloatToString((float(Prob) / 100.0000000), 2, false)) $ "%"));
	UpdateExtractBtnState();
	return;
}

function UpdateConfirmForm()
{
	local string skillNameStr;
	local ItemInfo skillItemInfo;
	local SkillTargetEnchantData confirmData;
	local ItemWindowHandle skillItemWnd;
	local TextureHandle skillGradeTex;
	local TextBoxHandle skillNameTextBox, prevLvTextBox, nextLvTextBox, descTextBox;
	local int selectedMultiCostIndex;

	selectedMultiCostIndex = confirmNeedMultiItemScript._GetSelectedIndexPopup();
	skillItemWnd = GetItemWindowHandle((confirmFormWnd.m_WindowNameWithFullPath $ ".SkillItem_ItemWindow"));
	skillGradeTex = GetTextureHandle((confirmFormWnd.m_WindowNameWithFullPath $ ".IconPanel_Tex"));
	skillNameTextBox = GetTextBoxHandle((confirmFormWnd.m_WindowNameWithFullPath $ ".SkillName_Txt"));
	prevLvTextBox = GetTextBoxHandle((confirmFormWnd.m_WindowNameWithFullPath $ ".PrvEnchantNum_Txt"));
	nextLvTextBox = GetTextBoxHandle((confirmFormWnd.m_WindowNameWithFullPath $ ".NextEnchantNum_Txt"));
	descTextBox = GetTextBoxHandle((confirmFormWnd.m_WindowNameWithFullPath $ ".Description_Txt"));
	skillNameStr = _info.SkillInfo.SkillName;
	if((_info.SkillInfo.LevelHide == false))
	{
		skillNameStr = (skillNameStr @ Class'InterfaceClassic.SkillEnchantWnd'.static.Inst().GetSkillLevelStr(_info.SkillInfo.SkillLevel));
	}
	skillNameTextBox.SetText(skillNameStr);
	Class'InterfaceClassic.L2Util'.static.GetSkill2ItemInfo(_info.SkillInfo, skillItemInfo);
	skillItemInfo.Id.ClassID = 0;
	skillItemInfo.SubLevel = 0;
	if(!skillItemWnd.SetItem(0, skillItemInfo))
	{
		skillItemWnd.AddItem(skillItemInfo);
	}
	skillGradeTex.SetTexture(Class'InterfaceClassic.SkillEnchantWnd'.static.Inst().GetSkillGradeTextureName(_info.SkillInfo.Grade));
	prevLvTextBox.SetText(("+" $ string(Class'InterfaceClassic.SkillWnd'.static.Inst().ConvertEnchantLevel(_info.SkillInfo.SkillSubLevel))));
	nextLvTextBox.SetText(("+" $ string(Class'InterfaceClassic.SkillWnd'.static.Inst().ConvertEnchantLevel(_info.confirmTargetSubLevel))));
	descTextBox.SetText(((GetSystemMessage(13993) $ "\\n") $ GetSystemMessage(13994)));
	if((selectedMultiCostIndex >= 0))
	{
		if((_info.confirmCostData.Length > selectedMultiCostIndex))
		{
			confirmData = _info.confirmCostData[selectedMultiCostIndex];
			confirmNeedItemScript.StartNeedItemList(2);
			confirmNeedItemScript.AddNeedItemClassID(_info.confirmItemId, INT64(1));
			confirmNeedItemScript.AddNeedItemClassID(57, confirmData.CommissionAdena);
			confirmNeedItemScript.SetBuyNum(INT64(1));
			_info.selectedCostItemId = confirmData.ItemID;
		}
	}
	UpdateConfirmBtnState();
	return;
}

function UpdateExtractBtnState()
{
	if((((extractNeedMultiItemScript._GetSelectedIndexPopup() >= 0) && extractNeedItemScript.GetCanBuy()) && extractNeedMultiItemScript._GetCanBuy()))
	{
		extractBtn.SetEnable(true);
	}
	else
	{
		extractBtn.SetEnable(false);
	}
	return;
}

function UpdateConfirmBtnState()
{
	if((((confirmNeedMultiItemScript._GetSelectedIndexPopup() >= 0) && confirmNeedItemScript.GetCanBuy()) && confirmNeedMultiItemScript._GetCanBuy()))
	{
		confirmBtn.SetEnable(true);
	}
	else
	{
		confirmBtn.SetEnable(false);
	}
	return;
}

function ShowExtractDialog()
{
	local string htmlDescText, probStr;
	local SkillExtractData extractData;
	local int selectedMultiCostIndex, Prob;

	selectedMultiCostIndex = extractNeedMultiItemScript._GetSelectedIndexPopup();
	if((selectedMultiCostIndex < 0))
	{
		return;
	}
	if((_info.extractCostData.Length <= selectedMultiCostIndex))
	{
		return;
	}
	extractData = _info.extractCostData[selectedMultiCostIndex];
	Prob = extractData.Prob;
	probStr = (((GetSystemString(642) @ ":") @ ConvertFloatToString((float(Prob) / 100.0000000), 2, false)) $ "%");
	extractDialogAsset.StartNeedItemList(2);
	htmlDescText = ((((htmlAddText(GetSystemMessage(13990), "") $ "<br1>") $ htmlAddText(probStr, "", getColorHexString(GTColor().Yellow))) $ "<br1>") $ htmlAddText(GetSystemMessage(13991), "", getColorHexString(GTColor().Red)));
	extractDialogAsset.SetDialogDescHtml(htmlDescText);
	extractDialogAsset.AddNeedItemClassID(extractData.ItemID, INT64(extractData.ItemCount));
	extractDialogAsset.AddNeedItemClassID(57, extractData.CommissionAdena);
	extractDialogAsset.SetItemNum(1);
	ShowDialogContainer();
	extractDialogAsset.Show();
	return;
}

function ShowExtractConfirmDialog()
{
	local string htmlDescText;
	local SkillTargetEnchantData confirmData;
	local int selectedMultiCostIndex;

	selectedMultiCostIndex = confirmNeedMultiItemScript._GetSelectedIndexPopup();
	if((selectedMultiCostIndex < 0))
	{
		return;
	}
	if((_info.confirmCostData.Length <= selectedMultiCostIndex))
	{
		return;
	}
	confirmData = _info.confirmCostData[selectedMultiCostIndex];
	extractDialogAsset.StartNeedItemList(3);
	htmlDescText = htmlSetHtmlStart(((htmlAddText(GetSystemMessage(13993), "") $ "<br1>") $ htmlAddText(GetSystemMessage(13994), "", getColorHexString(GTColor().Red))));
	extractDialogAsset.SetDialogDescHtml(htmlDescText);
	extractDialogAsset.AddNeedItemClassID(_info.confirmItemId, INT64(1));
	extractDialogAsset.AddNeedItemClassID(confirmData.ItemID, INT64(confirmData.ItemCount));
	extractDialogAsset.AddNeedItemClassID(57, confirmData.CommissionAdena);
	extractDialogAsset.SetItemNum(1);
	ShowDialogContainer();
	extractDialogAsset.Show();
	return;
}

function ShowErrorDialog()
{
	if(_info.isExtractMode)
	{
		errorDialogTextBox.SetText(GetSystemMessage(13992));
	}
	else
	{
		errorDialogTextBox.SetText(GetSystemMessage(13975));
	}
	ShowDialogContainer();
	errorDialogWnd.ShowWindow();
	return;
}

function ShowExtractResultDialog(UIPacket._S_EX_EXTRACT_SKILL_ENCHANT packet)
{
	local ItemInfo tempItemInfo;

	if((packet.cReault == 0))
	{
		tempItemInfo = GetItemInfoByClassID(_info.extractSuccessItemID);
		resultLevelTextBox.HideWindow();
		resultDescTextBox.SetText(GetSystemString(14662));
		ResultEffectViewport.ShowWindow();
		ResultEffectViewport.SetScale(2.4000001);
		ResultEffectViewport.SetCameraDistance(200.0000000);
		ResultEffectViewport.SetCameraPitch(0);
		ResultEffectViewport.SetCameraYaw(0);
		ResultEffectViewport.SpawnEffect("LineageEffect2.ui_Enchant_success");
		PlaySound("Itemsound3.ui_enchant_success_sfx");
	}
	else if((packet.cReault == 1))
	{
		Class'InterfaceClassic.L2Util'.static.GetSkill2ItemInfo(_info.SkillInfo, tempItemInfo);
		resultLevelTextBox.SetText(("+" $ string(Class'InterfaceClassic.SkillWnd'.static.Inst().ConvertEnchantLevel(_info.SkillInfo.SkillSubLevel))));
		resultLevelTextBox.ShowWindow();
		resultDescTextBox.SetText(GetSystemString(14679));
		ResultEffectViewport.ShowWindow();
		ResultEffectViewport.SetScale(2.4000001);
		ResultEffectViewport.SetCameraDistance(200.0000000);
		ResultEffectViewport.SetCameraPitch(0);
		ResultEffectViewport.SetCameraYaw(0);
		ResultEffectViewport.SpawnEffect("LineageEffect2.ui_Enchant_fail");
		PlaySound("Itemsound3.ui_enchant_fail_sfx");
	}
	resultNameTextBox.SetText(tempItemInfo.Name);
	tempItemInfo.Id.ClassID = 0;
	tempItemInfo.SubLevel = 0;
	if(!resultItemWnd.SetItem(0, tempItemInfo))
	{
		resultItemWnd.AddItem(tempItemInfo);
	}
	ShowDialogContainer();
	resultDialogWnd.ShowWindow();
	return;
}

function ShowConfirmResultDialog(UIPacket._S_EX_REQUEST_SKILL_ENCHANT_CONFIRM packet)
{
	local ItemInfo tempItemInfo;

	Class'InterfaceClassic.L2Util'.static.GetSkill2ItemInfo(_info.SkillInfo, tempItemInfo);
	resultLevelTextBox.SetText(("+" $ string(Class'InterfaceClassic.SkillWnd'.static.Inst().ConvertEnchantLevel(_info.SkillInfo.SkillSubLevel))));
	resultLevelTextBox.ShowWindow();
	resultDescTextBox.SetText(GetSystemString(14364));
	ResultEffectViewport.ShowWindow();
	ResultEffectViewport.SetScale(2.4000001);
	ResultEffectViewport.SetCameraDistance(200.0000000);
	ResultEffectViewport.SetCameraPitch(0);
	ResultEffectViewport.SetCameraYaw(0);
	ResultEffectViewport.SpawnEffect("LineageEffect2.ui_Enchant_success");
	PlaySound("Itemsound3.ui_enchant_success_sfx");
	resultNameTextBox.SetText(tempItemInfo.Name);
	tempItemInfo.Id.ClassID = 0;
	tempItemInfo.SubLevel = 0;
	if(!resultItemWnd.SetItem(0, tempItemInfo))
	{
		resultItemWnd.AddItem(tempItemInfo);
	}
	ShowDialogContainer();
	resultDialogWnd.ShowWindow();
	return;
}

function OpenWindow(int SkillID, int Level, int SubLevel, int targetSubLevel, int replaceSkillId, int confirmItemId, bool extractMode)
{
	local SkillInfo SkillInfo, replaceSkillInfo;

	if(!GetSkillInfo(SkillID, Level, SubLevel, SkillInfo))
	{
		Debug("SkillEnchantExtractWnd : SkillInfo Error");
		Me.HideWindow();
		return;
	}
	if((GetSkillSubLevelList(SkillID, Level, _info.subLevelInfos) == 0))
	{
		Debug("SkillEnchantExtractWnd : SkillSubLevelList Error");
		Me.HideWindow();
		return;
	}
	_info.SkillInfo = SkillInfo;
	_info.replaceSkillId = replaceSkillId;
	_info.confirmItemId = confirmItemId;
	_info.confirmTargetSubLevel = targetSubLevel;
	if(((replaceSkillId >= 0) && GetSkillInfo(replaceSkillId, Level, SubLevel, replaceSkillInfo)))
	{
		_info.SkillInfo.SkillName = replaceSkillInfo.SkillName;
		_info.SkillInfo.Grade = replaceSkillInfo.Grade;
		_info.SkillInfo.TexName = replaceSkillInfo.TexName;
		_info.SkillInfo.SkillDesc = replaceSkillInfo.SkillDesc;
	}
	_info.enchantMaxLevel = (_info.subLevelInfos.Length - 1);
	_info.isExtractMode = extractMode;
	if((extractMode == true))
	{
		Me.SetWindowTitle(GetSystemString(14653));
		GetSkillExtractData(SkillInfo.Grade, SkillInfo.SkillSubLevel, _info.extractCostData);
	}
	else
	{
		Me.SetWindowTitle(GetSystemString(1526));
		GetSkillTargetEnchantData(SkillInfo.Grade, targetSubLevel, _info.confirmCostData);
	}
	ResultEffectViewport.HideWindow();
	CloseDialog();
	InitForm();
	Me.ShowWindow();
	return;
}

function CloseWindow()
{
	Me.HideWindow();
	return;
}

function ShowDialogContainer()
{
	dialogContainer.ShowWindow();
	return;
}

function CloseDialog()
{
	dialogContainer.HideWindow();
	extractDialogAsset.Hide();
	resultDialogWnd.HideWindow();
	errorDialogWnd.HideWindow();
	return;
}

function SetLevelInfoWnd(SkillInfo SkillInfo, int replaceSkillId, int targetSubLevel)
{
	Class'InterfaceClassic.SkillEnchantExtractLevelInfoWnd'.static.Inst().SetInfo(SkillInfo, replaceSkillId, targetSubLevel);
	return;
}

function ToggleLevelInfoWnd()
{
	if(Class'InterfaceClassic.SkillEnchantExtractLevelInfoWnd'.static.Inst().Me.IsShowWindow())
	{
		HideLevelInfoWnd();
	}
	else
	{
		ShowLevelInfoWnd();
	}
	return;
}

function ShowLevelInfoWnd()
{
	if((Class'InterfaceClassic.SkillEnchantExtractLevelInfoWnd'.static.Inst().Me.IsShowWindow() == false))
	{
		Class'InterfaceClassic.SkillEnchantExtractLevelInfoWnd'.static.Inst().Me.ShowWindow();
	}
	return;
}

function HideLevelInfoWnd()
{
	if(Class'InterfaceClassic.SkillEnchantExtractLevelInfoWnd'.static.Inst().Me.IsShowWindow())
	{
		Class'InterfaceClassic.SkillEnchantExtractLevelInfoWnd'.static.Inst().Me.HideWindow();
	}
	return;
}

function bool CheckAndHideDialog()
{
	if((errorDialogWnd.IsShowWindow() == true))
	{
		CloseDialog();
		return true;
	}
	return false;
}

function Rq_C_EX_EXTRACT_SKILL_ENCHANT(int SkillID, int SkillLevel, int SkillSubLevel, int costItemClassId)
{
	local array<byte> stream;
	local UIPacket._C_EX_EXTRACT_SKILL_ENCHANT packet;

	packet.nSkillID = SkillID;
	packet.nLevel = SkillLevel;
	packet.nSubLevel = SkillSubLevel;
	packet.nItemClassID = costItemClassId;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_EXTRACT_SKILL_ENCHANT(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(893, stream);
	return;
}

function Rq_C_EX_REQUEST_SKILL_ENCHANT_CONFIRM(int SkillID, int confirmItemClassID, int commisionClassID)
{
	local array<byte> stream;
	local UIPacket._C_EX_REQUEST_SKILL_ENCHANT_CONFIRM packet;

	packet.nSkillID = SkillID;
	packet.nConfirmItemClassID = confirmItemClassID;
	packet.nCommisionClassID = commisionClassID;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_REQUEST_SKILL_ENCHANT_CONFIRM(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(894, stream);
	return;
}

function Rs_S_EX_EXTRACT_SKILL_ENCHANT()
{
	local UIPacket._S_EX_EXTRACT_SKILL_ENCHANT packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_EXTRACT_SKILL_ENCHANT(packet))
	{
		return;
	}
	Debug((((("_S_EX_EXTRACT_SKILL_ENCHANT" @ string(packet.cReault)) @ string(packet.nSkillID)) @ string(packet.nLevel)) @ string(packet.nSubLevel)));
	if((packet.cReault == 2))
	{
		ShowErrorDialog();
		return;
	}
	if((packet.cReault == 0))
	{
		_info.SkillInfo.SkillSubLevel = packet.nSubLevel;
		_info.isFinalResult = true;
	}
	ShowExtractResultDialog(packet);
	return;
}

function Rs_S_EX_REQUEST_SKILL_ENCHANT_CONFIRM()
{
	local UIPacket._S_EX_REQUEST_SKILL_ENCHANT_CONFIRM packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_REQUEST_SKILL_ENCHANT_CONFIRM(packet))
	{
		return;
	}
	Debug((((("Rs_S_EX_REQUEST_SKILL_ENCHANT_CONFIRM" @ string(packet.cResult)) @ string(packet.nSkillID)) @ string(packet.nSkillLevel)) @ string(packet.nSkillSubLevel)));
	if((packet.cResult == 1))
	{
		ShowErrorDialog();
		return;
	}
	if((packet.cResult == 0))
	{
		_info.SkillInfo.SkillSubLevel = packet.nSkillSubLevel;
		_info.isFinalResult = true;
	}
	ShowConfirmResultDialog(packet);
	return;
}

function OnExtractNeedItemSelect(int SelectedIndex, int selectedClassID, INT64 selectedAmount)
{
	UpdateExtractForm();
	return;
}

function OnExtractNeedItemUpdate()
{
	UpdateExtractBtnState();
	return;
}

function OnExtractMultiNeedItemUpdate()
{
	UpdateExtractBtnState();
	return;
}

function OnConfirmNeedItemSelect(int SelectedIndex, int selectedClassID, INT64 selectedAmount)
{
	UpdateConfirmForm();
	return;
}

function OnConfirmNeedItemUpdate()
{
	UpdateConfirmBtnState();
	return;
}

function OnConfirmMultiNeedItemUpdate()
{
	UpdateConfirmBtnState();
	return;
}

function OnExtractDialogCancel()
{
	CloseDialog();
	return;
}

function OnExtractDialogConfirm()
{
	if(_info.isExtractMode)
	{
		Rq_C_EX_EXTRACT_SKILL_ENCHANT(_info.SkillInfo.SkillID, _info.SkillInfo.SkillLevel, _info.SkillInfo.SkillSubLevel, _info.selectedCostItemId);
	}
	else
	{
		Rq_C_EX_REQUEST_SKILL_ENCHANT_CONFIRM(_info.SkillInfo.SkillID, _info.confirmItemId, _info.selectedCostItemId);
	}
	CloseDialog();
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(1163));
	RegisterEvent(EV_PacketID(1164));
	return;
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case EV_PacketID(1163):
			Rs_S_EX_EXTRACT_SKILL_ENCHANT();
			break;
		case EV_PacketID(1164):
			Rs_S_EX_REQUEST_SKILL_ENCHANT_CONFIRM();
			break;
		default:
			break;
	}
	return;
}

event OnClickButton(string btnName)
{
	switch(btnName)
	{
		case "Ok_Btn":
			ShowExtractConfirmDialog();
			break;
		case "Cancel_Btn":
			CloseWindow();
			break;
		case "Info_Btn":
			ToggleLevelInfoWnd();
			break;
		case "ErrorDialog_Ok_Btn":
			CloseDialog();
			break;
		case "ResultDialog_Ok_Btn":
			if(_info.isFinalResult)
			{
				CloseWindow();
			}
			else
			{
				CloseDialog();
			}
			break;
		case "EnchantExtract_Btn":
			ShowExtractDialog();
			break;
		default:
			break;
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
	if(Class'InterfaceClassic.SkillEnchantExtractLevelInfoWnd'.static.Inst().Me.IsShowWindow())
	{
		Class'InterfaceClassic.SkillEnchantExtractLevelInfoWnd'.static.Inst().Me.HideWindow();
	}
	if(_info.isExtractMode)
	{
		getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "SkillWnd", -100, -30);
		Class'InterfaceClassic.SkillWnd'.static.Inst().Me.ShowWindow();
	}
	else if((_info.enchantMaxLevel == _info.SkillInfo.SkillSubLevel))
	{
		getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "SkillWnd", -100, -30);
		Class'InterfaceClassic.SkillWnd'.static.Inst().Me.ShowWindow();
	}
	else
	{
		getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "SkillEnchantWnd", -200, -30);
		Class'InterfaceClassic.SkillEnchantWnd'.static.Inst().OpenWindow(_info.SkillInfo.SkillID, _info.SkillInfo.SkillLevel, _info.SkillInfo.SkillSubLevel, _info.replaceSkillId);
	}
	CloseDialog();
	ResetInfo();
	extractNeedItemScript.CleariObjects();
	confirmNeedItemScript.CleariObjects();
	extractNeedMultiItemScript._Clear();
	confirmNeedMultiItemScript._Clear();
	return;
}

event OnReceivedCloseUI()
{
	if((CheckAndHideDialog() == false))
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		Me.HideWindow();
	}
	return;
}
