class ShopLcoinCraftMinimizeWnd extends UICommonAPI;

var ShopLcoinCraftWnd.AutoCraftInfo _autoCraftInfo;
var TextBoxHandle cntTextBox;
var TextBoxHandle descTextBox;
var ButtonHandle CancelBtn;
var ButtonHandle maximizeBtn;
var ShopLcoinCraftWnd craftWndScript;
var EffectViewportWndHandle craftEffect;
var ProgressCtrlHandle ProgressBar;
var WindowHandle Me;
var array<WindowHandle> slotWndArray;
var array<int> slotXPosArray;
var bool _isUserCancel;

static function ShopLcoinCraftMinimizeWnd Inst()
{
	return ShopLcoinCraftMinimizeWnd(GetScript("ShopLcoinCraftMinimizeWnd"));
}

function Initialize()
{
	InitControls();
	craftWndScript = ShopLcoinCraftWnd(GetScript("ShopLcoinCraftWnd"));
	return;
}

function InitControls()
{
	local string ownerFullPath;
	local int i;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	cntTextBox = GetTextBoxHandle((ownerFullPath $ ".Num_Txt"));
	descTextBox = GetTextBoxHandle((ownerFullPath $ ".Desc_Txt"));
	CancelBtn = GetButtonHandle((ownerFullPath $ ".Cancel_btn"));
	maximizeBtn = GetButtonHandle((ownerFullPath $ ".Maximize_btn"));
	craftEffect = GetEffectViewportWndHandle((ownerFullPath $ ".EffectViewport00"));
	ProgressBar = GetProgressCtrlHandle((ownerFullPath $ ".Progressbar"));
	slotWndArray.Length = 0;
	ProgressBar.SetProgressTime((1020 - 100));
	i = 0;
	while((i < 5))
	{
		slotWndArray[i] = GetWindowHandle(((ownerFullPath $ ".RandomSlotGroup_Wnd") $ string(i)));
		i++;
	}
	return;
}

function SetItemSlots(PurchaseLimitCraftUIData productData)
{
	local int i;
	local WindowHandle slotWnd;

	if((true == false))
	{
		return;
	}
	AlignCards(productData.BuyItems.Length);
	i = 0;
	while((i < slotWndArray.Length))
	{
		slotWnd = slotWndArray[i];
		if((i < productData.BuyItems.Length))
		{
			SetBuySlot(slotWnd, productData.BuyItems[i], productData.LimitType);
			slotWnd.ShowWindow();
			i++;
			continue;
		}
		slotWnd.HideWindow();
		i++;
	}
	_isUserCancel = false;
	return;
}

function AlignCards(int Num)
{
	local int i, StartX, gab, gabW, targetX;

	gab = 60;
	gabW = (((5 - Num) * 60) / 2);
	StartX = (16 + gabW);
	i = 0;
	while((i < Num))
	{
		targetX = (StartX + (gab * i));
		slotWndArray[i].MoveC(targetX, 50);
		slotXPosArray[i] = targetX;
		i++;
	}
	return;
}

function SetBuySlot(WindowHandle slotWnd, PurchaseLimitCraftBuyItemInfo buyItemInfo, UIEventManager.PLSHOP_LIMIT_TYPE LimitType)
{
	local ItemWindowHandle ItemWnd;
	local TextureHandle gradeTex, limitedTex, disableTex;
	local TextBoxHandle resultNumTextBox;
	local ItemInfo ItemInfo;

	if((true == false))
	{
		return;
	}
	ItemWnd = GetItemWindowHandle((slotWnd.m_WindowNameWithFullPath $ ".CraftSlot_ItemWnd"));
	gradeTex = GetTextureHandle((slotWnd.m_WindowNameWithFullPath $ ".CraftCardBG_tex"));
	limitedTex = GetTextureHandle((slotWnd.m_WindowNameWithFullPath $ ".LimitedRibbon_Tex"));
	disableTex = GetTextureHandle((slotWnd.m_WindowNameWithFullPath $ ".AutoCraft_CardCover_Tex"));
	resultNumTextBox = GetTextBoxHandle((slotWnd.m_WindowNameWithFullPath $ ".ResultNum_textbox"));
	ItemInfo = GetItemInfoByClassID(buyItemInfo.ItemClassID);
	ItemInfo.RefineryOp1 = 0;
	ItemInfo.RefineryOp2 = 0;
	ItemInfo.RefineryOp3 = 0;
	ItemInfo.Enchanted = buyItemInfo.Enchant;
	if(buyItemInfo.IsLimitBuy)
	{
		limitedTex.SetTexture(craftWndScript.GetItemMarkIconByLimitType(LimitType));
		limitedTex.ShowWindow();
	}
	else
	{
		limitedTex.HideWindow();
	}
	resultNumTextBox.SetText("");
	gradeTex.SetTexture(GetGradeTextureByRank(buyItemInfo.ProductRank));
	ItemWnd.Clear();
	ItemWnd.AddItem(ItemInfo);
	disableTex.ShowWindow();
	return;
}

function UpdateBuySlot(int SlotIndex, int craftNum)
{
	local WindowHandle slotWnd;
	local Rect slotWndRect;

	if((true == false))
	{
		return;
	}
	if((SlotIndex >= slotWndArray.Length))
	{
		return;
	}
	slotWnd = slotWndArray[SlotIndex];
	GetTextureHandle((slotWnd.m_WindowNameWithFullPath $ ".AutoCraft_CardCover_Tex")).HideWindow();
	GetTextBoxHandle((slotWnd.m_WindowNameWithFullPath $ ".ResultNum_textbox")).SetText(("x" $ string(craftNum)));
	slotWndRect = slotWnd.GetRect();
	if(Me.IsShowWindow())
	{
		craftEffect.MoveC((slotXPosArray[SlotIndex] - 41), 6);
		craftEffect.SpawnEffect("LineageEffect2.ui_upgrade_succ");
	}
	return;
}

function UpdateAutoCraftInfo(ShopLcoinCraftWnd.AutoCraftInfo Info)
{
	if((true == false))
	{
		return;
	}
	_autoCraftInfo = Info;
	if((int(Info.uiState) == 1))
	{
		cntTextBox.ShowWindow();
		descTextBox.HideWindow();
		if((int(Info.Type) == 1))
		{
			cntTextBox.SetText((GetSystemMessage(13861) @ string(_autoCraftInfo.currentCount)));
		}
		else if((int(Info.Type) == 2))
		{
			cntTextBox.SetText((((GetSystemMessage(13861) @ string(_autoCraftInfo.currentCount)) $ "/") $ string(_autoCraftInfo.maxCount)));
		}
		CancelBtn.SetButtonName(141);
	}
	else
	{
		cntTextBox.HideWindow();
		descTextBox.ShowWindow();
		ProgressBar.Reset();
		if((_isUserCancel == true))
		{
			_isUserCancel = false;
			descTextBox.SetText(GetSystemMessage(13885));
		}
		else
		{
			descTextBox.SetText(GetSystemMessage(13884));
		}
		descTextBox.SetTextColor(GetColor(229, 219, 189, 255));
		CancelBtn.SetButtonName(140);
	}
	return;
}

function string GetGradeTextureByRank(int ProductRank)
{
	switch(ProductRank)
	{
		case 0:
			return "L2UI_EPIC.LCoinShopWnd.LCoinShopCraftCardSmall_01";
			break;
		case 1:
			return "L2UI_EPIC.LCoinShopWnd.LCoinShopCraftCardSmall_02";
			break;
		case 2:
			return "L2UI_EPIC.LCoinShopWnd.LCoinShopCraftCardSmall_03";
			break;
		case 3:
			return "L2UI_EPIC.LCoinShopWnd.LCoinShopCraftCardSmall_04";
			break;
		case 4:
			return "L2UI_EPIC.LCoinShopWnd.LCoinShopCraftCardSmall_05";
			break;
		default:
			break;
	}
	return "";
}

function SetFailMessage(int msgIndex, optional bool isSystemStr)
{
	if((isSystemStr == true))
	{
		descTextBox.SetText(GetSystemString(msgIndex));
	}
	else
	{
		descTextBox.SetText(GetSystemMessage(msgIndex));
	}
	descTextBox.SetTextColor(GetColor(255, 0, 0, 255));
	return;
}

function StartCraftProgressBar()
{
	if(((true == false) || (Me.IsShowWindow() == false)))
	{
		return;
	}
	ProgressBar.Reset();
	ProgressBar.Start();
	return;
}

function SetCraftProgressBar(int CurrentTime)
{
	if((int(_autoCraftInfo.uiState) != 1))
	{
		return;
	}
	ProgressBar.SetPos(CurrentTime);
	ProgressBar.Start();
	return;
}

function OpenWindow()
{
	Me.ShowWindow();
	return;
}

function CloseWindow()
{
	ProgressBar.Reset();
	Me.HideWindow();
	return;
}

event OnLoad()
{
	Initialize();
	SetClosingOnESC();
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "Cancel_btn":
			if((int(_autoCraftInfo.uiState) == 1))
			{
				_isUserCancel = true;
				craftWndScript.HandleCraftBtn();
			}
			else
			{
				craftWndScript.SetAutoCraftMinimize(false);
			}
			break;
		case "Maximize_btn":
			craftWndScript.SetAutoCraftMinimize(false);
			break;
		default:
			break;
	}
	return;
}

event OnCancelBtnClicked()
{
	return;
}

event OnMaximizeBtnClicked()
{
	return;
}

event OnReceivedCloseUI()
{
	craftWndScript.OnReceivedCloseUI();
	return;
}
