class ItemAutoPeelExpandWnd extends UICommonAPI
	dependson(UIPacket);

const TIMER_ID_BTN_DELAY = 1;
const TIMER_DELAY_BTN_DISABLE = 500;
const LIST_ICON_SIZE = 32;
const LIST_TEXT_OFFSET = 4;
const MIN_PEEL_COUNT = 1;

var bool _isWaitingBtnDelay;
var WindowHandle Me;
var ButtonHandle autoPeelBtn;
var ButtonHandle resetBtn;
var ButtonHandle CloseBtn;
var ButtonHandle minimizeBtn;
var ButtonHandle setCountBtn;
var RichListCtrlHandle rareItemRichList;
var RichListCtrlHandle normalItemRichList;
var WindowHandle highGradeListBlockWnd;
var WindowHandle rareResultContainer;
var WindowHandle normalResultContainer;
var WindowHandle rareBlockWnd;
var WindowHandle rareBlockDescWnd;
var WindowHandle normalBlockDescWnd;
var WindowHandle disableWnd;
var TextBoxHandle itemNameTextBox;
var UIControlNumberInput numberInput;

static function ItemAutoPeelExpandWnd Inst()
{
	return ItemAutoPeelExpandWnd(GetScript("ItemAutoPeelExpandWnd"));
}

function Initialize()
{
	InitControls();
	_isWaitingBtnDelay = false;
	return;
}

function InitControls()
{
	local string ownerFullPath;

	_isWaitingBtnDelay = false;
	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	autoPeelBtn = GetButtonHandle((ownerFullPath $ ".BoxOpen_Btn"));
	resetBtn = GetButtonHandle((ownerFullPath $ ".PeelReset_Btn"));
	minimizeBtn = GetButtonHandle((ownerFullPath $ ".Min_BTN"));
	CloseBtn = GetButtonHandle((ownerFullPath $ ".WndClose_BTN"));
	setCountBtn = GetButtonHandle((ownerFullPath $ ".MultiSell_Input_Button_2"));
	itemNameTextBox = GetTextBoxHandle((ownerFullPath $ ".ItemName_txt"));
	rareResultContainer = GetWindowHandle((ownerFullPath $ ".RareResultItem_wnd"));
	normalResultContainer = GetWindowHandle((ownerFullPath $ ".NormalResultItem_wnd"));
	disableWnd = GetWindowHandle((ownerFullPath $ ".DisableWnd"));
	rareBlockWnd = GetWindowHandle((rareResultContainer.m_WindowNameWithFullPath $ ".BlindScreen_tex"));
	rareBlockDescWnd = GetWindowHandle((rareResultContainer.m_WindowNameWithFullPath $ ".DescriptionMsgWnd"));
	normalBlockDescWnd = GetWindowHandle((normalResultContainer.m_WindowNameWithFullPath $ ".DescriptionMsgWnd"));
	rareItemRichList = GetRichListCtrlHandle((rareResultContainer.m_WindowNameWithFullPath $ ".Item_ListCtrl"));
	normalItemRichList = GetRichListCtrlHandle((normalResultContainer.m_WindowNameWithFullPath $ ".Item_ListCtrl"));
	numberInput = Class'Interface.UIControlNumberInput'.static.InitScript(GetWindowHandle((ownerFullPath $ ".NumberInputExpanded")));
	numberInput.DelegateGetCountCanBuy = GetMaxNumCanPeel;
	numberInput.delegateOnItemCountEdited = OnItemPeelCountChanged;
	rareItemRichList.SetSelectedSelTooltip(false);
	normalItemRichList.SetSelectedSelTooltip(false);
	rareItemRichList.SetSelectable(false);
	normalItemRichList.SetSelectable(false);
	rareItemRichList.SetAppearTooltipAtMouseX(true);
	normalItemRichList.SetAppearTooltipAtMouseX(true);
	return;
}

function UpdateTargetItemControls()
{
	local ItemAutoPeelWnd.ItemAutoPeelInfo Info;

	Info = Class'Interface.ItemAutoPeelWnd'.static.Inst().GetItemAutoPeelInfo();
	itemNameTextBox.SetText(Info.targetItemName);
	return;
}

function UpdateResultItemControls()
{
	local ItemAutoPeelWnd.ItemAutoPeelInfo Info;

	Info = Class'Interface.ItemAutoPeelWnd'.static.Inst().GetItemAutoPeelInfo();
	if((Info.normalItemInfos.Length > 0))
	{
		normalBlockDescWnd.HideWindow();
		UpdateResultItemRichListControl(normalItemRichList, Info.normalItemInfos, false);
	}
	else
	{
		normalBlockDescWnd.ShowWindow();
		normalItemRichList.DeleteAllItem();
	}
	if((Info.rareItemInfos.Length > 0))
	{
		rareBlockWnd.HideWindow();
		rareBlockDescWnd.HideWindow();
		UpdateResultItemRichListControl(rareItemRichList, Info.rareItemInfos, true);
	}
	else
	{
		rareBlockWnd.ShowWindow();
		rareBlockDescWnd.ShowWindow();
		rareItemRichList.DeleteAllItem();
	}
	return;
}

function UpdateResultItemRichListControl(RichListCtrlHandle targetControl, array<UIPacket._AutoPeelResultItem> infos, bool isRare)
{
	local int i, recordCnt;
	local bool needModify;
	local RichListCtrlRowData oldRowData, newRowData;
	local Color NameColor, cntColor;
	local ItemInfo ResultItemInfo;
	local string toolTipParam, resultItemName, StrEllipsised;
	local L2Util util;
	local UIPacket._AutoPeelResultItem resultInfo;

	util = L2Util(GetScript("L2Util"));
	if(isRare)
	{
		NameColor = util.White;
		cntColor = util.Yellow03;
	}
	else
	{
		NameColor = util.ColorGold;
		cntColor = util.White;
	}
	recordCnt = targetControl.GetRecordCount();
	newRowData.cellDataList.Length = 1;
	i = 0;
	while((i < infos.Length))
	{
		resultInfo = infos[i];
		if((i < recordCnt))
		{
			targetControl.GetRec(i, oldRowData);
			if(((oldRowData.nReserved1 == INT64(resultInfo.nItemClassID)) && (oldRowData.nReserved3 == INT64(resultInfo.Enchanted))))
			{
				if((oldRowData.nReserved2 == resultInfo.nAmount))
				{
					i++;
					continue;
				}
				else
				{
					if(isRare)
					{
						oldRowData.sOverlayTex = Class'Interface.ItemAutoPeelWnd'.static.Inst().GetGradeBGTextureName(resultInfo.gradeColor);
						oldRowData.OverlayTexU = 256;
						oldRowData.OverlayTexV = 32;
					}
					oldRowData.nReserved2 = resultInfo.nAmount;
					oldRowData.cellDataList[0].drawitems[2].strInfo.strData = ("x" $ MakeCostString(string(resultInfo.nAmount)));
					targetControl.ModifyRecord(i, oldRowData);
					i++;
					continue;
				}
			}
			else
			{
				needModify = true;
			}
		}
		newRowData.cellDataList[0].drawitems.Length = 0;
		ResultItemInfo = GetItemInfoByClassID(resultInfo.nItemClassID);
		ResultItemInfo.Enchanted = resultInfo.Enchanted;
		ItemInfoToParam(ResultItemInfo, toolTipParam);
		newRowData.szReserved = toolTipParam;
		newRowData.nReserved1 = INT64(resultInfo.nItemClassID);
		newRowData.nReserved2 = resultInfo.nAmount;
		newRowData.nReserved3 = INT64(resultInfo.Enchanted);
		newRowData.ForceRefreshTooltip = true;
		if(isRare)
		{
			newRowData.sOverlayTex = Class'Interface.ItemAutoPeelWnd'.static.Inst().GetGradeBGTextureName(resultInfo.gradeColor);
			newRowData.OverlayTexU = 256;
			newRowData.OverlayTexV = 32;
		}
		AddRichListCtrlItem(newRowData.cellDataList[0].drawitems, ResultItemInfo);
		resultItemName = ResultItemInfo.Name;
		if((resultInfo.Enchanted > 0))
		{
			resultItemName = (("+" $ string(resultInfo.Enchanted)) @ resultItemName);
		}
		StrEllipsised = resultItemName;
		Class'Interface.L2Util'.static.GetEllipsisString(StrEllipsised, (300 - 4));
		AddRichListCtrlString(newRowData.cellDataList[0].drawitems, StrEllipsised, NameColor, false, 4, (4 - 2));
		AddRichListCtrlString(newRowData.cellDataList[0].drawitems, ("x" $ MakeCostString(string(resultInfo.nAmount))), cntColor, true, (32 + 4), 4);
		if((needModify == true))
		{
			needModify = false;
			targetControl.ModifyRecord(i, newRowData);
			i++;
			continue;
		}
		targetControl.InsertRecord(newRowData);
		i++;
	}
	return;
}

function UpdateButtonControls()
{
	local ItemAutoPeelWnd.ItemAutoPeelInfo Info;
	local L2Util util;
	local bool countBtnEnabled, autoPeelBtnEnabled;

	Info = Class'Interface.ItemAutoPeelWnd'.static.Inst().GetItemAutoPeelInfo();
	util = getInstanceL2Util();
	autoPeelBtn.SetTexture("L2UI_NewTex.Button.Button29_DF", "Button29_Down", "L2UI_NewTex.Button.Button29_Over");
	if((Info.targetItemSId != 0))
	{
		if((Info.isPeeling == true))
		{
			if((Info.isPause == true))
			{
				autoPeelBtn.SetButtonName(1731);
				autoPeelBtnEnabled = true;
				countBtnEnabled = false;
			}
			else
			{
				autoPeelBtn.SetTexture("L2UI_NewTex.ButtonEffect.BTNEnchant_Over_0001", "L2UI_NewTex.ButtonEffect.BTNEnchant_Normal", "L2UI_NewTex.ButtonEffect.BTNEnchant_Normal");
				autoPeelBtn.SetButtonName(14042);
				autoPeelBtnEnabled = true;
				countBtnEnabled = false;
			}
		}
		else
		{
			autoPeelBtn.SetButtonName(14041);
			autoPeelBtnEnabled = true;
			countBtnEnabled = true;
		}
	}
	else
	{
		autoPeelBtn.SetButtonName(14041);
		autoPeelBtnEnabled = false;
		countBtnEnabled = false;
	}
	autoPeelBtn.SetEnable(autoPeelBtnEnabled);
	resetBtn.SetEnable(countBtnEnabled);
	setCountBtn.SetEnable(countBtnEnabled);
	numberInput._SetForceDisable(!countBtnEnabled);
	if(countBtnEnabled)
	{
		numberInput._SetEditBoxFontColor(util.White);
	}
	else
	{
		numberInput._SetEditBoxFontColor(util.Gray);
	}
	return;
}

function UpdateNumberInputControls()
{
	local ItemAutoPeelWnd.ItemAutoPeelInfo Info;

	Info = Class'Interface.ItemAutoPeelWnd'.static.Inst().GetItemAutoPeelInfo();
	if((Info.isPeeling == false))
	{
		numberInput.SetCount(Info.totalPeelCnt);
	}
	return;
}

function UpdateUIControls()
{
	UpdateTargetItemControls();
	UpdateResultItemControls();
	UpdateButtonControls();
	UpdateNumberInputControls();
	return;
}

function ShowDisableWnd(bool isShow)
{
	if(isShow)
	{
		disableWnd.ShowWindow();
	}
	else
	{
		disableWnd.HideWindow();
	}
	return;
}

function StartBtnDelayTimer()
{
	_isWaitingBtnDelay = true;
	Me.SetTimer(1, 500);
	return;
}

function KillBtnDelayTimer()
{
	Me.KillTimer(1);
	_isWaitingBtnDelay = false;
	return;
}

function INT64 GetMaxNumCanPeel()
{
	return Class'Interface.ItemAutoPeelWnd'.static.Inst().GetTargetItemNum();
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "BoxOpen_Btn":
			OnItemAutoPeelBtnClicked();
			break;
		case "PeelReset_Btn":
			OnResetBtnClicked();
			break;
		case "WndClose_BTN":
			OnCloseBtnClicked();
			break;
		case "Min_BTN":
			OnMinimizeBtnClicked();
			break;
		case "MultiSell_Input_Button_2":
			OnSetCountBtnClicked();
			break;
		default:
			break;
	}
	return;
}

event OnTimer(int TimerID)
{
	if((TimerID == 1))
	{
		KillBtnDelayTimer();
	}
	return;
}

event OnSetFocus(WindowHandle a_WindowHandle, bool IsFocused)
{
	if(IsFocused)
	{
		GetWindowHandle("ItemAutoPeelWnd").SetFocus();
	}
	return;
}

event OnItemAutoPeelBtnClicked()
{
	local ItemAutoPeelWnd.ItemAutoPeelInfo Info;

	if((_isWaitingBtnDelay == true))
	{
		return;
	}
	Info = Class'Interface.ItemAutoPeelWnd'.static.Inst().GetItemAutoPeelInfo();
	StartBtnDelayTimer();
	if((Info.targetItemSId != 0))
	{
		if((Info.isPeeling == true))
		{
			if((Info.isPause == true))
			{
				Class'Interface.ItemAutoPeelWnd'.static.Inst().StartItemAutoPeel();
			}
			else
			{
				Class'Interface.ItemAutoPeelWnd'.static.Inst().PauseItemAutoPeel();
			}
		}
		else
		{
			Class'Interface.ItemAutoPeelWnd'.static.Inst().StartItemAutoPeel();
		}
	}
	return;
}

event OnItemPeelCountChanged(INT64 ItemCount)
{
	Class'Interface.ItemAutoPeelWnd'.static.Inst().SetTargetTotalPeelCnt(ItemCount);
	return;
}

event OnResetBtnClicked()
{
	if((_isWaitingBtnDelay == true))
	{
		return;
	}
	StartBtnDelayTimer();
	Class'Interface.ItemAutoPeelWnd'.static.Inst().ResetTargetItem();
	return;
}

event OnSetCountBtnClicked()
{
	Class'Interface.ItemAutoPeelWnd'.static.Inst().ShowItemCountDialog();
	return;
}

event OnCloseBtnClicked()
{
	Class'Interface.ItemAutoPeelWnd'.static.Inst().CloseWindow();
	return;
}

event OnMinimizeBtnClicked()
{
	Class'Interface.ItemAutoPeelWnd'.static.Inst().SetExpand(false);
	return;
}

event OnReceivedCloseUI()
{
	Class'Interface.ItemAutoPeelWnd'.static.Inst().CloseWindow();
	return;
}
