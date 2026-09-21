class AbilityUIWnd extends UICommonAPI
	dependson(UIPacket);

const DIALOGID_INIT = 1;
const DIALOGID_APPLY = 2;
const TIMER_ID_ABILITY_SWAP_DELAY = 1;
const TIMER_TIME_ABILITY_SWAP_DELAY = 5500;


var WindowHandle Me;
var WindowHandle AbilityCategory0;
var WindowHandle AbilityCategory1;
var WindowHandle AbilityCategory2;
var TextBoxHandle Category0TextBox;
var TextBoxHandle Category1TextBox;
var TextBoxHandle Category2TextBox;
var ButtonHandle InitButton;
var ButtonHandle ApplyButton;
var ButtonHandle CancelButton;
var UIControlGroupButtonAssets abilitySwapBtnGroup;
var TextBoxHandle classNameTextBox;
var int apTotal;
var int apTotalFirstValue;
var int apCategory0;
var int apCategory1;
var int apCategory2;
var int apCategory0Applied;
var int apCategory1Applied;
var int apCategory2Applied;
var TextBoxHandle TotalAPTextBox;
var INT64 nNeedResetSP;
var bool bInitClickRun;
var AbilityPresetInfo _presetInfo;
var bool _isRequestedAbilitySwap;

function OnRegisterEvent()
{
	RegisterEvent(9750);
	RegisterEvent(40);
	RegisterEvent(180);
	RegisterEvent(11610);
	RegisterEvent((100000 + 607));
	RegisterEvent((100000 + 615));
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
	Me = GetMeWindow();
	AbilityCategory0 = GetMeWindow("AbilityCategory0");
	AbilityCategory1 = GetMeWindow("AbilityCategory1");
	AbilityCategory2 = GetMeWindow("AbilityCategory2");
	Category0TextBox = GetMeTextBox("Category0TextBox");
	Category1TextBox = GetMeTextBox("Category1TextBox");
	Category2TextBox = GetMeTextBox("Category2TextBox");
	InitButton = GetMeButton("InitButton");
	ApplyButton = GetMeButton("ApplyButton");
	CancelButton = GetMeButton("CancelButton");
	TotalAPTextBox = GetMeTextBox("TotalAPTextBox");
	GetMeTextBox("TotalAPTitleTextBox").SetText((GetSystemString(3156) $ ":"));
	classNameTextBox = GetMeTextBox("JobText_Txt");
	InitAbilitySwapBtnGroup();
	return;
}

function InitAbilitySwapBtnGroup()
{
	abilitySwapBtnGroup = Class'Interface.UIControlGroupButtonAssets'.static._InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SubUIControlGroupButtonAsset")));
	abilitySwapBtnGroup._SetStartInfo("L2UI_ct1.RankingWnd.RankingWnd_SubTabButton", "L2UI_NewTex.Button.SubTabButton_Selected", "L2UI_ct1.RankingWnd.RankingWnd_SubTabButton_Over", true);
	abilitySwapBtnGroup._GetGroupButtonsInstance().DelegateOnClickButton = OnClickAbilitySwapBtn;
	abilitySwapBtnGroup._GetGroupButtonsInstance()._setShowButtonNum(2);
	abilitySwapBtnGroup._GetGroupButtonsInstance()._fixedWidth(40, 6);
	abilitySwapBtnGroup._GetGroupButtonsInstance()._setTopOrder(0, true);
	abilitySwapBtnGroup._GetGroupButtonsInstance()._setButtonTooltip(0, GetSystemString(14447));
	abilitySwapBtnGroup._GetGroupButtonsInstance()._setButtonTooltip(1, GetSystemString(14448));
	return;
}

event OnShow()
{
	showDisable(true);
	UpdateClassInfoControls();
	API_C_EX_ABILITY_WND_OPEN();
	API_C_EX_REQUEST_POTENTIAL_SKILL_LIST();
	return;
}

event OnHide()
{
	initAllAP();
	OnClickCancelDialog();
	API_C_EX_ABILITY_WND_CLOSE();
	return;
}

event OnEvent(int Event_ID, string param)
{
	local UserInfo UserInfo;

	switch(Event_ID)
	{
		case 9750:
			ApplyButton.DisableWindow();
			CancelButton.DisableWindow();
			InitButton.DisableWindow();
			break;
		case 40:
			m_hOwnerWnd.KillTimer(1);
			_isRequestedAbilitySwap = false;
			break;
		case 11610:
			Nt_EV_RequestAbilitySwap();
			break;
		case 180:
			if(Me.IsShowWindow())
			{
				GetPlayerInfo(UserInfo);
				if((UserInfo.nLevel < 85))
				{
					Me.HideWindow();
				}
				InitButton.SetTooltipCustomType(getCustomTooltipInit());
				buttonStateCheck();
				UpdateClassInfoControls();
			}
			break;
		case EV_PacketID(607):
			ParsePacket_S_EX_ACQUIRE_AP_SKILL_LIST();
			break;
		case EV_PacketID(615):
			Nt_S_EX_CLOSE_AP_LIST_WND();
			break;
		default:
			break;
	}
	return;
}

function Nt_EV_RequestAbilitySwap()
{
	local int presetIndex;

	if((_presetInfo.currentPreset == 0))
	{
		presetIndex = 1;
	}
	Rq_C_EX_CHANGE_ABILITY_PRESET(presetIndex);
	return;
}

function Nt_S_EX_CLOSE_AP_LIST_WND()
{
	CloseUI();
	return;
}

function ParsePacket_S_EX_ACQUIRE_AP_SKILL_LIST()
{
	local UIPacket._S_EX_ACQUIRE_AP_SKILL_LIST packet;
	local int i;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_ACQUIRE_AP_SKILL_LIST(packet))
	{
		return;
	}
	showDisable(false);
	_isRequestedAbilitySwap = false;
	_presetInfo.currentPreset = packet.cCurrentPreset;
	_presetInfo.aPresetRemainAP = packet.nAPresetRemainAP;
	_presetInfo.bPresetRemainAP = packet.nBPresetRemainAP;
	abilitySwapBtnGroup._GetGroupButtonsInstance()._setTopOrder(packet.cCurrentPreset, true);
	if(((packet.cResult == 1) || (packet.cResult == 2)))
	{
		if((bInitClickRun == true))
		{
			initAllAP();
		}
		else
		{
			initAllAP(true);
		}
		bInitClickRun = false;
		nNeedResetSP = packet.nResetSP;
		apTotalFirstValue = packet.nAP;
		apTotal = packet.nAP;
		InitButton.SetTooltipCustomType(getCustomTooltipInit());
		ApplyButton.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(4188)));
		i = 0;
		while((i < packet.abilitySkills.Length))
		{
			_setSlotAppliedAP(packet.abilitySkills[i].nID, packet.abilitySkills[i].nLevel);
			i++;
		}
		if((packet.abilitySkills.Length > 0))
		{
			_updateCategory(0);
			_updateCategory(1);
			_updateCategory(2);
		}
		updateTextBox();
		buttonStateCheck();
		if((packet.cResult == 2))
		{
			abilitySwapBtnGroup._clearDelayTime();
			abilitySwapBtnGroup._setDelayTime(5500);
			abilitySwapBtnGroup._tryDelayClick();
			m_hOwnerWnd.KillTimer(1);
			m_hOwnerWnd.SetTimer(1, 5500);
		}
	}
	else if((packet.cResult == 0))
	{
		AddSystemMessage(4559);
		Me.HideWindow();
	}
	return;
}

function CustomTooltip getCustomTooltipInit()
{
	local UserInfo UserInfo;
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;

	GetPlayerInfo(UserInfo);
	drawListArr[drawListArr.Length] = addDrawItemText(MakeFullSystemMsg(GetSystemMessage(4191), MakeCostStringINT64(nNeedResetSP)), GTColor().Yellow, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip();
	drawListArr[drawListArr.Length] = addDrawItemText((GetSystemString(1575) $ " : "), GTColor().White, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(MakeCostStringINT64(UserInfo.nSP), GTColor().Orange2, "", false, true);
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 130;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;
}

function _setSlotAppliedAP(int nID, int nLevel)
{
	local int nCategory, X, Y;

	nCategory = 0;
	while((nCategory < 3))
	{
		X = 1;
		while((X <= 4))
		{
			Y = 1;
			while((Y <= 6))
			{
				if((getSlotControl(nCategory, X, Y)._getAbilityID() == nID))
				{
					getSlotControl(nCategory, X, Y)._setAppliedAP(nLevel);
					return;
				}
				Y++;
			}
			X++;
		}
		nCategory++;
	}
	return;
}

function int _getAPTotal()
{
	return (((apTotal - apCategory0Applied) - apCategory1Applied) - apCategory2Applied);
}

function _useAP(int useAtCategory)
{
	if((apTotal > 0))
	{
		--apTotal;
		switch(useAtCategory)
		{
			case 0:
				apCategory0++;
				break;
			case 1:
				apCategory1++;
				break;
			case 2:
				apCategory2++;
				break;
			default:
				break;
		}
	}
	updateTextBox();
	return;
}

function _removeAP(int useAtCategory)
{
	++apTotal;
	switch(useAtCategory)
	{
		case 0:
			apCategory0--;
			break;
		case 1:
			apCategory1--;
			break;
		case 2:
			apCategory2--;
			break;
		default:
			break;
	}
	updateTextBox();
	return;
}

function buttonStateCheck()
{
	local UserInfo UserInfo;

	GetPlayerInfo(UserInfo);
	if(((((apCategory0Applied + apCategory1Applied) + apCategory2Applied) > 0) && (UserInfo.nSP >= nNeedResetSP)))
	{
		InitButton.EnableWindow();
	}
	else
	{
		InitButton.DisableWindow();
	}
	return;
}

function int _getAPCategory(int useAtCategory)
{
	local int RValue;

	switch(useAtCategory)
	{
		case 0:
			RValue = (apCategory0 + apCategory0Applied);
			break;
		case 1:
			RValue = (apCategory1 + apCategory1Applied);
			break;
		case 2:
			RValue = (apCategory2 + apCategory2Applied);
			break;
		default:
			break;
	}
	return RValue;
}

function _updateCategory(int nCategory)
{
	local int X, Y;

	X = 1;
	while((X <= 4))
	{
		Y = 1;
		while((Y <= 6))
		{
			getSlotControl(nCategory, X, Y)._updateSlot();
			Y++;
		}
		X++;
	}
	return;
}

function int _findMaxRequireAbilityLev(int nCategory, int RequireAbilityID)
{
	local int X, Y, V;

	X = 1;
	while((X <= 4))
	{
		Y = 1;
		while((Y <= 6))
		{
			V = getSlotControl(nCategory, X, Y)._getMaxAbilityLev(RequireAbilityID);
			if((V > 0))
			{
				return V;
			}
			Y++;
		}
		X++;
	}
	return -1;
}

function int _findCurrentAP(int nCategory, int AbilityID)
{
	local int X, Y;

	X = 1;
	while((X <= 4))
	{
		Y = 1;
		while((Y <= 6))
		{
			if((getSlotControl(nCategory, X, Y)._getAbilityID() == AbilityID))
			{
				return getSlotControl(nCategory, X, Y)._getCurrentAP();
			}
			Y++;
		}
		X++;
	}
	return -1;
}

function int _totalAppliedAP()
{
	local int nCategory, X, Y, sumAP;

	nCategory = 0;
	while((nCategory < 3))
	{
		X = 1;
		while((X <= 4))
		{
			Y = 1;
			while((Y <= 6))
			{
				sumAP = (sumAP + getSlotControl(nCategory, X, Y)._getCurrentAppliedAP());
				Y++;
			}
			X++;
		}
		nCategory++;
	}
	return sumAP;
}

function int _totalUseAP()
{
	local int nCategory, X, Y, sumAP;

	nCategory = 0;
	while((nCategory < 3))
	{
		X = 1;
		while((X <= 4))
		{
			Y = 1;
			while((Y <= 6))
			{
				sumAP = (sumAP + getSlotControl(nCategory, X, Y)._getCurrentUseAP());
				Y++;
			}
			X++;
		}
		nCategory++;
	}
	return sumAP;
}

function bool _checkEnableRClick(int nCategory, int Col, int AbilityID)
{
	local int X, Y, sumAP;

	Y = 1;
	while((Y <= (Col - 1)))
	{
		X = 1;
		while((X <= 4))
		{
			sumAP = (getSlotControl(nCategory, X, Y)._getCurrentAP() + sumAP);
			X++;
		}
		Y++;
	}
	Y = Y;
	while((Y <= 5))
	{
		X = 1;
		while((X <= 4))
		{
			sumAP = (getSlotControl(nCategory, X, Y)._getCurrentAP() + sumAP);
			X++;
		}
		Col = (Y + 1);
		X = 1;
		while((X <= 4))
		{
			if((getSlotControl(nCategory, X, Col)._getCurrentAP() == 0))
			{
				X++;
				continue;
			}
			if((getSlotControl(nCategory, X, Col)._getRequireCount() == sumAP))
			{
				return false;
				X++;
				continue;
			}
			if((getSlotControl(nCategory, X, Col)._getRequireAbilityID() == AbilityID))
			{
				return false;
			}
			X++;
		}
		Y++;
	}
	return true;
}

function _setCategoryApApplied(int nCategory, int addAP)
{
	switch(nCategory)
	{
		case 0:
			apCategory0Applied = (addAP + apCategory0Applied);
			break;
		case 1:
			apCategory1Applied = (addAP + apCategory1Applied);
			break;
		case 2:
			apCategory2Applied = (addAP + apCategory2Applied);
			break;
		default:
			break;
	}
	updateTextBox();
	return;
}

function AbilityPresetInfo GetAbilityPresetInfo()
{
	return _presetInfo;
}

function Load()
{
	local int nCategory, X, Y;

	SetPopupScript();
	nCategory = 0;
	while((nCategory < 3))
	{
		X = 1;
		while((X <= 4))
		{
			Y = 1;
			while((Y <= 6))
			{
				AddControl(nCategory, X, Y);
				Y++;
			}
			X++;
		}
		nCategory++;
	}
	_updateCategory(0);
	_updateCategory(1);
	_updateCategory(2);
	ApplyButton.DisableWindow();
	CancelButton.DisableWindow();
	InitButton.DisableWindow();
	return;
}

function AddControl(int Category, int X, int Y)
{
	local WindowHandle targetWindowHandle;
	local AbilitySlot targetControl;

	targetWindowHandle = GetMeWindow(((((("AbilityCategory" $ string(Category)) $ ".") $ "AbilitySlot") $ string(Y)) $ string(X)));
	targetWindowHandle.SetScript("AbilitySlot");
	targetControl = AbilitySlot(targetWindowHandle.GetScript());
	targetControl.Init(targetWindowHandle, self, Category, X, Y);
	return;
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "InitButton":
			ShowPopup(GetSystemMessage(4192), 1, MakeCostStringINT64(nNeedResetSP));
			break;
		case "ApplyButton":
			ShowPopup(GetSystemMessage(4189), 2, "");
			break;
		case "CancelButton":
			cancelAllAP();
			L2UITween(GetScript("l2UITween")).StartShake("AbilityUIWnd", 4, 1000, small, 0);
			break;
		case "WindowHelp_BTN":
			ExecuteEvent(1210, "18");
			break;
		default:
			break;
	}
	return;
}

event OnClickAbilitySwapBtn(string parentWndName, string strName, int Index)
{
	Rq_C_EX_CHANGE_ABILITY_PRESET(Index);
	return;
}

function AbilitySlot getSlotControl(int Category, int X, int Y)
{
	local WindowHandle targetWindowHandle;
	local AbilitySlot targetControl;

	targetWindowHandle = GetMeWindow(((((("AbilityCategory" $ string(Category)) $ ".") $ "AbilitySlot") $ string(Y)) $ string(X)));
	targetControl = AbilitySlot(targetWindowHandle.GetScript());
	return targetControl;
}

function cancelAllAP()
{
	local int nCategory, X, Y;

	nCategory = 0;
	while((nCategory < 3))
	{
		X = 1;
		while((X <= 4))
		{
			Y = 1;
			while((Y <= 6))
			{
				getSlotControl(nCategory, X, Y)._cancelAP();
				Y++;
			}
			X++;
		}
		nCategory++;
	}
	apCategory0 = 0;
	apCategory1 = 0;
	apCategory2 = 0;
	apTotal = apTotalFirstValue;
	updateTextBox();
	_updateCategory(0);
	_updateCategory(1);
	_updateCategory(2);
	ApplyButton.DisableWindow();
	CancelButton.DisableWindow();
	return;
}

function initAllAP(optional bool NoUseAPInit)
{
	local int nCategory, X, Y;

	nCategory = 0;
	while((nCategory < 3))
	{
		X = 1;
		while((X <= 4))
		{
			Y = 1;
			while((Y <= 6))
			{
				getSlotControl(nCategory, X, Y)._initAP(NoUseAPInit);
				Y++;
			}
			X++;
		}
		nCategory++;
	}
	apCategory0 = 0;
	apCategory1 = 0;
	apCategory2 = 0;
	apCategory0Applied = 0;
	apCategory1Applied = 0;
	apCategory2Applied = 0;
	apTotal = 0;
	apTotalFirstValue = 0;
	updateTextBox();
	_updateCategory(0);
	_updateCategory(1);
	_updateCategory(2);
	ApplyButton.DisableWindow();
	CancelButton.DisableWindow();
	InitButton.DisableWindow();
	return;
}

function updateTextBox()
{
	Category0TextBox.SetText(((string((apCategory0 + apCategory0Applied)) $ " ") $ GetSystemString(3164)));
	Category1TextBox.SetText(((string((apCategory1 + apCategory1Applied)) $ " ") $ GetSystemString(3164)));
	Category2TextBox.SetText(((string((apCategory2 + apCategory2Applied)) $ " ") $ GetSystemString(3164)));
	TotalAPTextBox.SetText(string((((apTotal - apCategory0Applied) - apCategory1Applied) - apCategory2Applied)));
	return;
}

function UpdateClassInfoControls()
{
	local UserInfo UserInfo;

	GetPlayerInfo(UserInfo);
	classNameTextBox.SetText(GetClassType(UserInfo.nSubClass));
	return;
}

function _callBackSlotClick(int Category, int X, int Y, int AbilityID)
{
	if((_totalUseAP() > 0))
	{
		ApplyButton.EnableWindow();
		CancelButton.EnableWindow();
	}
	else
	{
		ApplyButton.DisableWindow();
		CancelButton.DisableWindow();
	}
	return;
}

function SetPopupScript()
{
	local WindowHandle popExpandWnd;
	local UIControlDialogAssets popupExpandScript;
	local WindowHandle disableWnd;

	popExpandWnd = GetMeWindow("UIControlDialogAsset");
	popupExpandScript = Class'Interface.UIControlDialogAssets'.static.InitScript(popExpandWnd);
	disableWnd = GetMeWindow("DisableWnd");
	popupExpandScript.SetDisableWindow(disableWnd);
	Class'NWindow.UIAPI_WINDOW'.static.SetAlwaysOnTop("AbilityUIWnd.DisableWnd", false);
	return;
}

function UIControlDialogAssets GetPopupExpandScript()
{
	local WindowHandle popExpandWnd;

	popExpandWnd = GetMeWindow("UIControlDialogAsset");
	return UIControlDialogAssets(popExpandWnd.GetScript());
}

function ShowPopup(string Msg, int dialogID, string Param1)
{
	local UIControlDialogAssets popupExpandScript;

	popupExpandScript = GetPopupExpandScript();
	popupExpandScript.SetDialogDesc(MakeFullSystemMsg(Msg, Param1));
	popupExpandScript.Show();
	popupExpandScript.DelegateOnClickBuy = OnDialogOK;
	popupExpandScript.DelegateOnCancel = OnClickCancelDialog;
	popupExpandScript.SetDialogID(dialogID);
	showDisable(true);
	return;
}

function OnDialogOK()
{
	switch(GetPopupExpandScript().GetDialogID())
	{
		case 1:
			bInitClickRun = true;
			API_C_EX_RESET_POTENTIAL_SKILL();
			L2UITween(GetScript("l2UITween")).StartShake("AbilityUIWnd", 8, 1000, small, 0);
			break;
		case 2:
			API_C_EX_ACQUIRE_POTENTIAL_SKILL();
			break;
		default:
			break;
	}
	GetPopupExpandScript().Hide();
	showDisable(false);
	return;
}

function OnClickCancelDialog()
{
	GetPopupExpandScript().Hide();
	showDisable(false);
	return;
}

function showDisable(bool bShow)
{
	if(bShow)
	{
		GetMeWindow("DisableWnd").ShowWindow();
	}
	else
	{
		GetMeWindow("DisableWnd").HideWindow();
	}
	return;
}

function API_C_EX_ACQUIRE_POTENTIAL_SKILL()
{
	local array<byte> stream;
	local UIPacket._C_EX_ACQUIRE_POTENTIAL_SKILL packet;

	packet.nAP = _totalUseAP();
	packet.abilitySkillsPerType[0] = getArrayPkAbilitySkill(0);
	packet.abilitySkillsPerType[1] = getArrayPkAbilitySkill(1);
	packet.abilitySkillsPerType[2] = getArrayPkAbilitySkill(2);
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_ACQUIRE_POTENTIAL_SKILL(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(443, stream);
	Debug(("api Call : C_EX_ACQUIRE_POTENTIAL_SKILL" @ string(packet.nAP)));
	return;
}

function API_C_EX_REQUEST_POTENTIAL_SKILL_LIST()
{
	local array<byte> stream;

	Class'Interface.UIPacket'.static.RequestUIPacket(444, stream);
	Debug("API Call --> C_EX_REQUEST_POTENTIAL_SKILL_LIST");
	return;
}

function API_C_EX_RESET_POTENTIAL_SKILL()
{
	local array<byte> stream;

	Class'Interface.UIPacket'.static.RequestUIPacket(445, stream);
	Debug("API Call --> C_EX_RESET_POTENTIAL_SKILL");
	return;
}

function API_C_EX_ABILITY_WND_OPEN()
{
	local array<byte> stream;

	Class'Interface.UIPacket'.static.RequestUIPacket(448, stream);
	Debug("API Call --> C_EX_ABILITY_WND_OPEN");
	return;
}

function API_C_EX_ABILITY_WND_CLOSE()
{
	local array<byte> stream;

	Class'Interface.UIPacket'.static.RequestUIPacket(449, stream);
	Debug("API Call --> C_EX_ABILITY_WND_CLOSE");
	return;
}

function Rq_C_EX_CHANGE_ABILITY_PRESET(int Index)
{
	local array<byte> stream;
	local UIPacket._C_EX_CHANGE_ABILITY_PRESET packet;

	if((_isRequestedAbilitySwap || abilitySwapBtnGroup.bOnDelayTime))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13799));
		return;
	}
	packet.cPreset = Index;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_CHANGE_ABILITY_PRESET(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(849, stream);
	abilitySwapBtnGroup._setDelayTime(5500);
	abilitySwapBtnGroup._tryDelayClick();
	_isRequestedAbilitySwap = true;
	m_hOwnerWnd.SetTimer(1, 5500);
	return;
}

function UIPacket._PkAbilitySkillsPerType getArrayPkAbilitySkill(int nCategory)
{
	local UIPacket._PkAbilitySkillsPerType skillPerType;
	local UIPacket._PkAbilitySkill pkSkill;
	local int X, Y, useAP, AbilityID;

	Y = 1;
	while((Y <= 6))
	{
		X = 1;
		while((X <= 4))
		{
			useAP = 0;
			if(getSlotControl(nCategory, X, Y)._isShow())
			{
				useAP = getSlotControl(nCategory, X, Y)._getCurrentAP();
				AbilityID = getSlotControl(nCategory, X, Y)._getAbilityID();
			}
			if(((useAP > 0) && (AbilityID > 0)))
			{
				pkSkill.nID = AbilityID;
				pkSkill.nLevel = useAP;
				skillPerType.abilitySkills.Length = (skillPerType.abilitySkills.Length + 1);
				skillPerType.abilitySkills[(skillPerType.abilitySkills.Length - 1)] = pkSkill;
			}
			X++;
		}
		Y++;
	}
	Debug((("skillPerType.abilitySkills.Length" @ string(nCategory)) @ string(skillPerType.abilitySkills.Length)));
	return skillPerType;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	CloseUI();
	return;
}
