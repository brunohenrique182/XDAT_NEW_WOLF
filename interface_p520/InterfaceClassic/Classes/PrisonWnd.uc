class PrisonWnd extends UICommonAPI
	dependson(UIPacket);

const MIN_PRISON_TYPE = 1;
const MAX_PRISON_TYPE = 3;

var WindowHandle Me;
var WindowHandle modalWnd;
var WindowHandle prisonDisableWnd;
var WindowHandle itemInfoWnd;
var TextureHandle prisonBGTex;
var ButtonHandle prisonPrevBtn;
var ButtonHandle prisonNextBtn;
var ButtonHandle donationBtn;
var TextBoxHandle prisonNameTextBox;
var TextBoxHandle prisonDescTextBox;
var TextBoxHandle remainTimeTextBox;
var TextBoxHandle currentCntTextBox;
var TextBoxHandle maxCntTextBox;
var TextBoxHandle cntDivisionTextBox;
var ItemWindowHandle ItemWnd;
var UIControlDialogAssets donationDialog;
var array<WindowHandle> tabBtnWnds;
var int _currentPrisonType;

static function PrisonWnd Inst()
{
	return PrisonWnd(GetScript("PrisonWnd"));
}

function Initialize()
{
	InitControls();
	return;
}

function InitControls()
{
	local string ownerFullPath;
	local WindowHandle mainContainer;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	mainContainer = GetWindowHandle((ownerFullPath $ ".MainPrison"));
	prisonBGTex = GetTextureHandle((mainContainer.m_WindowNameWithFullPath $ ".MainPrisonBG"));
	prisonPrevBtn = GetButtonHandle((mainContainer.m_WindowNameWithFullPath $ ".MainArrowLeft_btn"));
	prisonNextBtn = GetButtonHandle((mainContainer.m_WindowNameWithFullPath $ ".MainArrowRight_btn"));
	prisonNameTextBox = GetTextBoxHandle((mainContainer.m_WindowNameWithFullPath $ ".MainPrisonName"));
	prisonDescTextBox = GetTextBoxHandle((mainContainer.m_WindowNameWithFullPath $ ".MainPrisonStory_txt"));
	remainTimeTextBox = GetTextBoxHandle((mainContainer.m_WindowNameWithFullPath $ ".PrisonTimer"));
	currentCntTextBox = GetTextBoxHandle((mainContainer.m_WindowNameWithFullPath $ ".PrisonWorkRemain_txt"));
	itemInfoWnd = GetWindowHandle((mainContainer.m_WindowNameWithFullPath $ ".CollectItem_Wnd"));
	maxCntTextBox = GetTextBoxHandle((itemInfoWnd.m_WindowNameWithFullPath $ ".PrisonWorkGoal_txt"));
	cntDivisionTextBox = GetTextBoxHandle((itemInfoWnd.m_WindowNameWithFullPath $ ".PrisonWorkSlash_txt"));
	ItemWnd = GetItemWindowHandle((itemInfoWnd.m_WindowNameWithFullPath $ ".CollectItem"));
	donationBtn = GetButtonHandle((ownerFullPath $ ".Donation_btn"));
	prisonDisableWnd = GetWindowHandle((mainContainer.m_WindowNameWithFullPath $ ".MainDisableWnd"));
	modalWnd = GetWindowHandle((ownerFullPath $ ".WindowDisable_Wnd"));
	donationDialog = Class'InterfaceClassic.UIControlDialogAssets'.static.InitScript(GetWindowHandle((modalWnd.m_WindowNameWithFullPath $ ".UIControlDialogAsset")));
	donationDialog.SetDisableWindow(modalWnd);
	tabBtnWnds.Length = 0;
	tabBtnWnds[tabBtnWnds.Length] = GetItemWindowHandle((mainContainer.m_WindowNameWithFullPath $ ".Prison1"));
	tabBtnWnds[tabBtnWnds.Length] = GetItemWindowHandle((mainContainer.m_WindowNameWithFullPath $ ".Prison2"));
	tabBtnWnds[tabBtnWnds.Length] = GetItemWindowHandle((mainContainer.m_WindowNameWithFullPath $ ".Prison3"));
	return;
}

function UpdateUIContols()
{
	UpdatePrisonPanelControls();
	UpdatePrisonRemainTimeControl();
	UpdatePrisonNeedItemControl();
	return;
}

function UpdatePrisonPanelControls()
{
	local PrisonUIData prisonData;
	local PrisonNoticeHUD.PrisonUIInfo inPrisonInfo;
	local int RemainTime, currentItemCnt, maxItemCnt, ItemID;
	local ItemInfo ItemInfo;
	local Color currentCntColor;

	if((Me.IsShowWindow() == false))
	{
		return;
	}
	if(((_currentPrisonType <= 0) || (_currentPrisonType > 3)))
	{
		return;
	}
	GetPrisonData(_currentPrisonType, prisonData);
	inPrisonInfo = Class'InterfaceClassic.PrisonNoticeHUD'.static.Inst().GetInPrisonInfo();
	prisonNameTextBox.SetText(GetSystemString(Class'InterfaceClassic.PrisonNoticeHUD'.static.Inst().GetPrisonTitleStringId(prisonData.PrisonType)));
	prisonDescTextBox.SetText(GetSystemString(GetPrisonDescStringId(prisonData.PrisonType)));
	prisonBGTex.SetTexture(GetPrisonBGTextureName(prisonData.PrisonType));
	maxItemCnt = int(prisonData.NeedItem.Amount);
	ItemID = prisonData.NeedItem.Id;
	if((ItemID != 0))
	{
		ItemInfo = GetItemInfoByClassID(ItemID);
	}
	if((prisonData.PrisonType == inPrisonInfo.PrisonType))
	{
		RemainTime = inPrisonInfo.uiRemainTime;
		currentItemCnt = inPrisonInfo.currentItemCnt;
		donationBtn.SetEnable(true);
		prisonDisableWnd.HideWindow();
	}
	else
	{
		RemainTime = (prisonData.HoldingMinute * 60);
		currentItemCnt = 0;
		donationBtn.SetEnable(false);
		prisonDisableWnd.ShowWindow();
	}
	remainTimeTextBox.SetText(Class'InterfaceClassic.PrisonNoticeHUD'.static.Inst().GetRemainTimeText(RemainTime));
	if(((maxItemCnt == 0) || (ItemID == 0)))
	{
		ItemWnd.Clear();
		itemInfoWnd.HideWindow();
	}
	else
	{
		if(!ItemWnd.SetItem(0, ItemInfo))
		{
			ItemWnd.AddItem(ItemInfo);
		}
		currentCntTextBox.SetText(string(currentItemCnt));
		maxCntTextBox.SetText(string(maxItemCnt));
		itemInfoWnd.ShowWindow();
		if((currentItemCnt >= maxItemCnt))
		{
			currentCntColor = GetColor(238, 170, 34, 255);
		}
		else
		{
			currentCntColor = GetColor(221, 221, 221, 255);
		}
		currentCntTextBox.SetTextColor(currentCntColor);
	}
	return;
}

function UpdateTabButtonControls()
{
	local PrisonNoticeHUD.PrisonUIInfo inPrisonInfo;
	local PrisonUIData prisonData;
	local int i, targetPrisonType;
	local TextureHandle tempSelectTex, tempInPrisonTex;
	local CustomTooltip toolTipInfo;
	local array<DrawItemInfo> drawListArr;
	local string Adenastring;
	local ItemInfo tooltipItemInfo;
	local int W, h;

	if((Me.IsShowWindow() == false))
	{
		return;
	}
	if(((_currentPrisonType <= 0) || (_currentPrisonType > 3)))
	{
		return;
	}
	GetPrisonData(_currentPrisonType, prisonData);
	inPrisonInfo = Class'InterfaceClassic.PrisonNoticeHUD'.static.Inst().GetInPrisonInfo();
	i = 0;
	while((i <= tabBtnWnds.Length))
	{
		targetPrisonType = (i + 1);
		tempSelectTex = GetTextureHandle((tabBtnWnds[i].m_WindowNameWithFullPath $ ".PrisonSelect"));
		tempInPrisonTex = GetTextureHandle((tabBtnWnds[i].m_WindowNameWithFullPath $ ".PrisonPanel"));
		if((inPrisonInfo.PrisonType == targetPrisonType))
		{
			tempInPrisonTex.ShowWindow();
		}
		else
		{
			tempInPrisonTex.HideWindow();
		}
		if((_currentPrisonType == targetPrisonType))
		{
			tempSelectTex.ShowWindow();
			i++;
			continue;
		}
		tempSelectTex.HideWindow();
		i++;
	}
	tooltipItemInfo = GetItemInfoByClassID(57);
	GetTextSizeDefault(tooltipItemInfo.Name, W, h);
	Adenastring = ("x" $ MakeCostStringINT64(INT64(prisonData.DonationAdena)));
	drawListArr[drawListArr.Length] = addDrawItemTextureCustom(tooltipItemInfo.IconName, false, true, 5, 4, 32, 32);
	drawListArr[drawListArr.Length] = addDrawItemText(tooltipItemInfo.Name, getInstanceL2Util().ColorDesc, "", false, false, 4, 6);
	drawListArr[drawListArr.Length] = addDrawItemText(("x" $ MakeCostStringINT64(INT64(prisonData.DonationAdena))), getInstanceL2Util().White, "", false, false, -W, (h + 6));
	toolTipInfo = MakeTooltipMultiTextByArray(drawListArr);
	GetTextSizeDefault(Adenastring, W, h);
	toolTipInfo.MinimumWidth = (W + 50);
	donationBtn.SetTooltipCustomType(toolTipInfo);
	return;
}

function UpdatePrisonRemainTimeControl()
{
	return;
}

function UpdatePrisonNeedItemControl()
{
	return;
}

function ShowDonationDialog()
{
	local PrisonNoticeHUD.PrisonUIInfo inPrisonInfo;

	inPrisonInfo = Class'InterfaceClassic.PrisonNoticeHUD'.static.Inst().GetInPrisonInfo();
	if(((inPrisonInfo.PrisonType != _currentPrisonType) || (inPrisonInfo.prisonData.DonationAdena == 0)))
	{
		return;
	}
	donationDialog.SetUseNeedItem(true);
	donationDialog.StartNeedItemList(1);
	donationDialog.SetDialogDesc(GetSystemMessage(13765));
	donationDialog.AddNeedItemClassID(57, INT64(inPrisonInfo.prisonData.DonationAdena));
	donationDialog.SetItemNum(1);
	donationDialog.Show();
	donationDialog.DelegateOnClickBuy = OnDonationDialogConfirm;
	donationDialog.DelegateOnCancel = OnDonationDialogCancel;
	return;
}

function OpenPrisonWnd()
{
	_currentPrisonType = Class'InterfaceClassic.PrisonNoticeHUD'.static.Inst().GetInPrisonType();
	if((_currentPrisonType == 0))
	{
		Me.HideWindow();
	}
	else
	{
		Me.ShowWindow();
	}
	return;
}

function ClosePrisonWnd()
{
	Me.HideWindow();
	return;
}

function ToggleOpenPrisonWnd()
{
	if(Me.IsShowWindow())
	{
		ClosePrisonWnd();
	}
	else
	{
		OpenPrisonWnd();
	}
	return;
}

function ShowDonationSuccessDialog()
{
	DialogShow(DialogModalType_Modalless, DialogType_OK, GetSystemMessage(13766));
	return;
}

function SetCurrentPrisonType(int PrisonType)
{
	_currentPrisonType = PrisonType;
	UpdateTabButtonControls();
	UpdateUIContols();
	return;
}

function string GetPrisonBGTextureName(int PrisonType)
{
	switch(PrisonType)
	{
		case 1:
			return "L2UI_NewTex.CursedVillageWnd.PrisonMainBG01";
		case 2:
			return "L2UI_NewTex.CursedVillageWnd.PrisonMainBG02";
		case 3:
			return "L2UI_NewTex.CursedVillageWnd.PrisonMainBG03";
		default:
			return "";
	}
}

function int GetPrisonDescStringId(int PrisonType)
{
	switch(PrisonType)
	{
		case 1:
			return 14216;
		case 2:
			return 14217;
		case 3:
			return 14218;
		default:
			return 0;
	}
}

function Rq_C_EX_PRISON_USER_DONATION()
{
	local array<byte> stream;
	local UIPacket._C_EX_PRISON_USER_DONATION packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_PRISON_USER_DONATION(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(815, stream);
	return;
}

function Rs_S_EX_PRISON_USER_DONATION()
{
	local UIPacket._S_EX_PRISON_USER_DONATION packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_PRISON_USER_DONATION(packet))
	{
		return;
	}
	ClosePrisonWnd();
	if(bool(packet.bSuccess))
	{
		ShowDonationSuccessDialog();
	}
	else
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13774));
	}
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(1063));
	return;
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case EV_PacketID(1063):
			Rs_S_EX_PRISON_USER_DONATION();
			break;
		default:
			break;
	}
	return;
}

event OnClickButton(string buttonStr)
{
	switch(buttonStr)
	{
		case "PrisonNomal_Btn1":
			SetCurrentPrisonType(1);
			break;
		case "PrisonNomal_Btn2":
			SetCurrentPrisonType(2);
			break;
		case "PrisonNomal_Btn3":
			SetCurrentPrisonType(3);
			break;
		case "MainArrowLeft_btn":
			OnNavigateBtnClicked(false);
			break;
		case "MainArrowRight_btn":
			OnNavigateBtnClicked(true);
			break;
		case "Donation_btn":
			ShowDonationDialog();
			break;
		case "Close_btn":
			ClosePrisonWnd();
			break;
		case "HelpWnd_Btn":
			Class'InterfaceClassic.HelpWnd'.static.ShowHelp(65);
			break;
		default:
			break;
	}
	return;
}

event OnNavigateBtnClicked(bool isNext)
{
	local int targetPrisonType;

	targetPrisonType = _currentPrisonType;
	if(isNext)
	{
		targetPrisonType++;
		if((targetPrisonType > 3))
		{
			targetPrisonType = 1;
		}
	}
	else
	{
		targetPrisonType--;
		if((targetPrisonType < 1))
		{
			targetPrisonType = 3;
		}
	}
	SetCurrentPrisonType(targetPrisonType);
	return;
}

event OnDonationDialogConfirm()
{
	Rq_C_EX_PRISON_USER_DONATION();
	donationDialog.Hide();
	return;
}

event OnDonationDialogCancel()
{
	donationDialog.Hide();
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
	UpdateUIContols();
	UpdateTabButtonControls();
	Me.SetFocus();
	return;
}

event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	Me.HideWindow();
	return;
}
