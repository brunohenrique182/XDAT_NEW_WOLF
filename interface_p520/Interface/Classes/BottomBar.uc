class BottomBar extends UICommonAPI
	dependson(UIPacket);

const TIMER_ID_SUPPRESS = 1;
const ITEM_ID_A_COIN = 97145;
const ITEM_ID_GIRAN_COIN = 92314;

enum EBottomBarBtnType
{
	TypeNone,                       // 0
	PostBox,                        // 1
	Clan,                           // 2
	Party,                          // 3
	PcCafePoint,                    // 4
	LCoinShop,                      // 5
	Adena,                          // 6
	Inventory,                      // 7
	Suppress,                       // 8
	MagicLamp,                      // 9
	RandomCraft,                    // 10
	LCoinCraft,                     // 11
	VitaminManager,                 // 12
	DualInventory                   // 13
};

enum EExpBoostType
{
	ExpBoostNone,                   // 0
	ExpBoostVital,                  // 1
	ExpBoostBuff,                   // 2
	ExpBoostPassive,                // 3
	ExpBoostMax                     // 4
};

struct BottomBarInfo
{
	var UIPacket._S_EX_USER_BOOST_STAT expBoostInfos[4];
	var float expPercentRate;
	var int unreadMailCnt;
	var bool isClanMember;
	var int clanMemberCnt;
	var INT64 bloodyCoinCnt;
	var INT64 adenaCnt;
	var INT64 aCoinCnt;
	var INT64 giranCoinCnt;
	var int PcCafePoint;
	var int invenCnt;
	var int invenMaxCnt;
	var int suppressId;
	var int suppressKeyCnt;
	var bool isSuppressMaxKey;
	var bool isSuppressHotTime;
	var string suppressName;
	var int suppressPoint;
	var int suppressMaxPoint;
	var bool isSuppressAlarm;
	var float magicLampPercent;
	var int magicLampBoostPercent;
	var int magicLampBoostCnt;
	var bool isMagicLampNormalEffect;
	var bool isMagicLampCompleteEffect;
	var int randomCraftPoint;
	var int randomCraftCharge;
	var bool isRandomCraftAlarm;
	var int carringWeight;
	var int carryWeight;
	var bool isPartyOnState;
	var bool isPartyAlarm;
	var bool isPartyWndMinimized;
};

struct BottomBarBtnInfo
{
	var EBottomBarBtnType Type;
	var WindowHandle btnWnd;
	var Rect defaultRect;
};

var array<BottomBarBtnInfo> _bottomBarBtns;
var array<EBottomBarBtnType> _availableBtnGroup;
var BottomBarInfo _bottomBarInfo;
var WindowHandle Me;
var ButtonHandle expBoostBtn;
var StatusBarHandle expStatusBar;
var WindowHandle expInfoWnd;
var TextBoxHandle expTextBox;
var TextBoxHandle expBoostTextBox;
var TextureHandle expBoostOnTex;
var TextureHandle expBoostOffTex;

static function BottomBar Inst()
{
	return BottomBar(GetScript("BottomBar"));
}

function Initialize()
{
	InitControls();
	return;
}

function InitControls()
{
	local string ownerFullPath;
	local WindowHandle btnContainerWnd;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	InitAvailableBtnGroupInfo();
	Me = GetWindowHandle(ownerFullPath);
	expStatusBar = GetStatusBarHandle((ownerFullPath $ ".ExpStatusBar"));
	expStatusBar.SetDrawPoint(false);
	btnContainerWnd = GetWindowHandle((ownerFullPath $ ".btnContainer"));
	expInfoWnd = GetWindowHandle((ownerFullPath $ ".ExpInfoWnd"));
	expTextBox = GetTextBoxHandle((ownerFullPath $ ".ExpInfoWnd.ExpPercentWnd.ExpPercent_txt"));
	expBoostTextBox = GetTextBoxHandle((ownerFullPath $ ".ExpInfoWnd.ExpBoostingWnd.ExpBoosting_txt"));
	expBoostBtn = GetButtonHandle((ownerFullPath $ ".ExpInfoWnd.ExpBoostingWnd.ExpBoostingBg"));
	expBoostOnTex = GetTextureHandle((ownerFullPath $ ".ExpInfoWnd.ExpBoostingWnd.BoostingArrowOn_tex"));
	expBoostOffTex = GetTextureHandle((ownerFullPath $ ".ExpInfoWnd.ExpBoostingWnd.BoostingArrowOff_tex"));
	_bottomBarBtns.Length = 0;
	AddBottomBarBtnControls(_bottomBarBtns, ownerFullPath, "postBoxBtnWnd", PostBox);
	AddBottomBarBtnControls(_bottomBarBtns, ownerFullPath, "clanBtnWnd", Clan);
	AddBottomBarBtnControls(_bottomBarBtns, ownerFullPath, "partyBtnWnd", Party);
	AddBottomBarBtnControls(_bottomBarBtns, ownerFullPath, "suppressBtnWnd", Suppress);
	AddBottomBarBtnControls(_bottomBarBtns, ownerFullPath, "magicLampBtnWnd", MagicLamp);
	AddBottomBarBtnControls(_bottomBarBtns, ownerFullPath, "randomCraftBtnWnd", RandomCraft);
	AddBottomBarBtnControls(_bottomBarBtns, ownerFullPath, "LCoinCraftBtnWnd", LCoinCraft);
	AddBottomBarBtnControls(_bottomBarBtns, ownerFullPath, "vitaminManagerBtnWnd", VitaminManager);
	AddBottomBarBtnControls(_bottomBarBtns, ownerFullPath, "pcCafePointBtnWnd", PcCafePoint);
	AddBottomBarBtnControls(_bottomBarBtns, ownerFullPath, "LCoinShopBtnWnd", LCoinShop);
	AddBottomBarBtnControls(_bottomBarBtns, ownerFullPath, "adenaBtnWnd", Adena);
	AddBottomBarBtnControls(_bottomBarBtns, ownerFullPath, "inventoryBtnWnd", Inventory);
	AddBottomBarBtnControls(_bottomBarBtns, ownerFullPath, "dualInventoryBtnWnd", DualInventory);
	InitShowBtns();
	InitLCointCraftBtnSize();
	return;
}

function InitAvailableBtnGroupInfo()
{
	local int isEinhasad;

	_availableBtnGroup.Length = 0;
	if(getInstanceUIData().GetIsClassicServer())
	{
		_availableBtnGroup[_availableBtnGroup.Length] = Clan;
		_availableBtnGroup[_availableBtnGroup.Length] = Suppress;
		if(IsAdenServer())
		{
			_availableBtnGroup[_availableBtnGroup.Length] = MagicLamp;
		}
		_availableBtnGroup[_availableBtnGroup.Length] = RandomCraft;
		_availableBtnGroup[_availableBtnGroup.Length] = LCoinCraft;
		if(IsShowPcCafe())
		{
			_availableBtnGroup[_availableBtnGroup.Length] = PcCafePoint;
		}
		_availableBtnGroup[_availableBtnGroup.Length] = LCoinShop;
		_availableBtnGroup[_availableBtnGroup.Length] = Adena;
		_availableBtnGroup[_availableBtnGroup.Length] = DualInventory;
	}
	else
	{
		_availableBtnGroup[_availableBtnGroup.Length] = PostBox;
		_availableBtnGroup[_availableBtnGroup.Length] = Clan;
		_availableBtnGroup[_availableBtnGroup.Length] = Party;
		if(IsShowPcCafe())
		{
			_availableBtnGroup[_availableBtnGroup.Length] = PcCafePoint;
		}
		GetINIBool("Localize", "UseEinhasad", isEinhasad, "L2.ini");
		if(bool(isEinhasad))
		{
			_availableBtnGroup[_availableBtnGroup.Length] = LCoinShop;
		}
		_availableBtnGroup[_availableBtnGroup.Length] = Adena;
		_availableBtnGroup[_availableBtnGroup.Length] = Inventory;
	}
	return;
}

function AddBottomBarBtnControls(out array<BottomBarBtnInfo> OutArray, string ownerPath, string targetWndName, EBottomBarBtnType Type)
{
	local BottomBarBtnInfo btnInfo;
	local WindowHandle btnWnd;

	btnWnd = GetWindowHandle(((ownerPath $ ".") $ targetWndName));
	if((btnWnd.m_pTargetWnd != none))
	{
		btnInfo.btnWnd = btnWnd;
		btnInfo.Type = Type;
		btnInfo.defaultRect = btnWnd.GetRect();
		OutArray[OutArray.Length] = btnInfo;
	}
	return;
}

function InitShowBtns()
{
	local int i;
	local BottomBarBtnInfo btnInfo;

	i = 0;
	while((i < _bottomBarBtns.Length))
	{
		btnInfo = _bottomBarBtns[i];
		if(IsAvailableBtnType(btnInfo.Type))
		{
			btnInfo.btnWnd.ShowWindow();
			btnInfo.btnWnd.SetWindowSize(btnInfo.defaultRect.nWidth, btnInfo.defaultRect.nHeight);
			i++;
			continue;
		}
		btnInfo.btnWnd.SetWindowSize(0, btnInfo.defaultRect.nHeight);
		btnInfo.btnWnd.HideWindow();
		i++;
	}
	return;
}

function InitLCointCraftBtnSize()
{
	local WindowHandle wnd;
	local TextBoxHandle txtBox;
	local string labelStr;
	local int strWidth, strHeight;

	labelStr = GetSystemString(13683);
	GetTextSizeDefault(labelStr, strWidth, strHeight);
	if((strWidth > 50))
	{
		wnd = GetBottomBarBtnWnd(LCoinCraft);
		if(((wnd.m_pTargetWnd == none) || (wnd.IsShowWindow() == false)))
		{
			return;
		}
		wnd.SetWindowSize(146, 22);
		txtBox = TextBoxHandle(wnd.GetChildWindow("LCoinCraftBtn_txt"));
		txtBox.SetWindowSize(100, 16);
		ButtonHandle(wnd.GetChildWindow("LCoinCraftBtn")).SetWindowSize(147, 21);
		Class'Interface.L2Util'.static.GetEllipsisString(labelStr, 100);
		txtBox.SetText(labelStr);
	}
	return;
}

function RegistAndShowBtn(EBottomBarBtnType Type)
{
	local BottomBarBtnInfo btnInfo;

	btnInfo = GetBottomBarBtnInfo(Type);
	if(((int(btnInfo.Type) == 0) || (btnInfo.btnWnd.m_pTargetWnd == none)))
	{
		return;
	}
	if(IsAvailableBtnType(Type))
	{
		if((btnInfo.btnWnd.IsShowWindow() == false))
		{
			btnInfo.btnWnd.ShowWindow();
			btnInfo.btnWnd.SetWindowSize(btnInfo.defaultRect.nWidth, btnInfo.defaultRect.nHeight);
		}
	}
	else
	{
		_availableBtnGroup[_availableBtnGroup.Length] = EBottomBarBtnType(Type);
		btnInfo.btnWnd.SetWindowSize(btnInfo.defaultRect.nWidth, btnInfo.defaultRect.nHeight);
		btnInfo.btnWnd.ShowWindow();
	}
	return;
}

function UnregistAndHideBtn(EBottomBarBtnType Type)
{
	local BottomBarBtnInfo btnInfo;

	btnInfo = GetBottomBarBtnInfo(Type);
	if(((int(btnInfo.Type) == 0) || (btnInfo.btnWnd.m_pTargetWnd == none)))
	{
		return;
	}
	if((IsAvailableBtnType(Type) || (btnInfo.btnWnd.IsShowWindow() == true)))
	{
		btnInfo.btnWnd.SetWindowSize(0, btnInfo.defaultRect.nHeight);
		btnInfo.btnWnd.HideWindow();
	}
	return;
}

function ResetInfo()
{
	local BottomBarInfo defaultInfo;

	_bottomBarInfo = defaultInfo;
	return;
}

function WindowHandle GetBottomBarBtnWnd(EBottomBarBtnType Type)
{
	local int i;
	local WindowHandle btnWnd;
	local BottomBarBtnInfo btnInfo;

	i = 0;
	while((i < _bottomBarBtns.Length))
	{
		btnInfo = _bottomBarBtns[i];
		if((int(btnInfo.Type) == int(Type)))
		{
			btnWnd = btnInfo.btnWnd;
			break;
		}
		i++;
	}
	return btnWnd;
}

function BottomBarBtnInfo GetBottomBarBtnInfo(EBottomBarBtnType Type)
{
	local int i;
	local BottomBarBtnInfo btnInfo;

	i = 0;
	while((i < _bottomBarBtns.Length))
	{
		if((int(_bottomBarBtns[i].Type) == int(Type)))
		{
			btnInfo = _bottomBarBtns[i];
			break;
		}
		i++;
	}
	return btnInfo;
}

function int GetBottomBarBtnsIndex(EBottomBarBtnType Type)
{
	local int i;

	i = 0;
	while((i < _bottomBarBtns.Length))
	{
		if((int(_bottomBarBtns[i].Type) == int(Type)))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function string GetExpBoostString(EExpBoostType Type)
{
	switch(Type)
	{
		case ExpBoostVital:
			return GetSystemString(13143);
		case ExpBoostPassive:
			return GetSystemString(13145);
		case ExpBoostBuff:
			return GetSystemString(13144);
		default:
	}
}

function bool IsShowPcCafe()
{
	local int isPcCafe;

	if((int(GetLanguage()) == 0))
	{
		return true;
	}
	else
	{
		GetINIBool("Localize", "UsePCBangPoint", isPcCafe, "L2.ini");
		if(bool(isPcCafe))
		{
			if((int(GetLanguage()) == 2))
			{
				return true;
			}
			else if(((int(GetLanguage()) == 3) || (int(GetLanguage()) == 4)))
			{
				if((IsInEvaServer() || IsInWolfServer()))
				{
					return true;
				}
			}
			else if(((((int(GetLanguage()) == 8) || (int(GetLanguage()) == 9)) || (int(GetLanguage()) == 12)) || (int(GetLanguage()) == 14)))
			{
				if(getInstanceUIData().GetIsLiveServer())
				{
					return true;
				}
				if((IsInEvaServer() || IsInWolfServer()))
				{
					return true;
				}
			}
			else if((int(GetLanguage()) == 1))
			{
				if(IsInWolfServer())
				{
					return true;
				}
			}
			else
			{
				return true;
			}
		}
		return false;
	}
}

function bool IsAvailableBtnType(EBottomBarBtnType Type)
{
	local int i;

	i = 0;
	while((i < _availableBtnGroup.Length))
	{
		if((int(_availableBtnGroup[i]) == int(Type)))
		{
			return true;
		}
		i++;
	}
	return false;
}

function bool IsInPeroidWithRemainTime(array<int> Cycle, out int RemainTime)
{
	return SuppressWnd(GetScript("SuppressWnd")).IsInPeroidWithRemainTime(Cycle, RemainTime);
}

function bool GetCurrentSubjugationData(int Id, out SubjugationData outsubjugationData)
{
	local int i;
	local array<SubjugationData> subjugationDatas;

	GetSubjugationList(subjugationDatas);
	i = 0;
	while((i < subjugationDatas.Length))
	{
		if((subjugationDatas[i].Id == Id))
		{
			outsubjugationData = subjugationDatas[i];
			return true;
		}
		i++;
	}
	return false;
}

function SetSuppressEvent()
{
	local int RemainTime;
	local SubjugationData mySubjugationDatas;

	Me.KillTimer(1);
	if(!GetCurrentSubjugationData(_bottomBarInfo.suppressId, mySubjugationDatas))
	{
		_bottomBarInfo.isSuppressHotTime = false;
	}
	else
	{
		_bottomBarInfo.isSuppressHotTime = IsInPeroidWithRemainTime(mySubjugationDatas.HotTimes, RemainTime);
	}
	if((RemainTime > 0))
	{
		Me.SetTimer(1, (RemainTime * 1000));
	}
	UpdateSuppressControls();
	return;
}

function UpdateExpStatusControls()
{
	expStatusBar.SetPointExpPercentRate(_bottomBarInfo.expPercentRate);
	return;
}

function UpdateExpInfoControls()
{
	local string expPercentStr;

	expPercentStr = ConvertFloatToString((_bottomBarInfo.expPercentRate * 100.0000000), 4, false);
	expTextBox.SetText((expPercentStr $ "%"));
	return;
}

function UpdateExpBoostInfoControls()
{
	local int i, totalCount, totalPercent;
	local UIPacket._S_EX_USER_BOOST_STAT expBoostInfo;
	local array<DrawItemInfo> drawListArr;
	local L2Util util;
	local string boostPercentString;

	util = getInstanceL2Util();
	i = 1;
	while((i < 4))
	{
		expBoostInfo = _bottomBarInfo.expBoostInfos[i];
		if(((expBoostInfo.Count > 0) && (expBoostInfo.Percent > 0)))
		{
			totalCount = (totalCount + expBoostInfo.Count);
			totalPercent = (totalPercent + expBoostInfo.Percent);
		}
		i++;
	}
	expBoostTextBox.SetText((util.MakeDecimalPointString(string(totalPercent), 1, true) $ "%"));
	if((totalCount > 0))
	{
		drawListArr[drawListArr.Length] = addDrawItemText(MakeFullSystemMsg(GetSystemMessage(13141), util.MakeDecimalPointString(string(totalPercent), 1, true)), util.Yellow, "", false, true);
		expBoostOnTex.ShowWindow();
		expBoostOffTex.HideWindow();
	}
	else
	{
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemMessage(13142), util.White, "", false, true);
		expBoostOnTex.HideWindow();
		expBoostOffTex.ShowWindow();
	}
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	expBoostInfo = _bottomBarInfo.expBoostInfos[1];
	boostPercentString = util.MakeDecimalPointString(string(expBoostInfo.Percent), 1, true);
	if((expBoostInfo.Count > 0))
	{
		drawListArr[drawListArr.Length] = addDrawItemText(MakeFullSystemMsg(GetSystemMessage(13143), boostPercentString, string(expBoostInfo.Count)), util.Yellow, "", true, true);
	}
	else
	{
		drawListArr[drawListArr.Length] = addDrawItemText(MakeFullSystemMsg(GetSystemMessage(13143), boostPercentString, string(expBoostInfo.Count)), util.Gray, "", true, true);
	}
	expBoostInfo = _bottomBarInfo.expBoostInfos[2];
	boostPercentString = util.MakeDecimalPointString(string(expBoostInfo.Percent), 1, true);
	if((expBoostInfo.Count > 0))
	{
		drawListArr[drawListArr.Length] = addDrawItemText(MakeFullSystemMsg(GetSystemMessage(13145), boostPercentString, string(expBoostInfo.Count)), util.Yellow, "", true, true);
	}
	else
	{
		drawListArr[drawListArr.Length] = addDrawItemText(MakeFullSystemMsg(GetSystemMessage(13145), boostPercentString, string(expBoostInfo.Count)), util.Gray, "", true, true);
	}
	expBoostInfo = _bottomBarInfo.expBoostInfos[3];
	boostPercentString = util.MakeDecimalPointString(string(expBoostInfo.Percent), 1, true);
	if((expBoostInfo.Count > 0))
	{
		drawListArr[drawListArr.Length] = addDrawItemText(MakeFullSystemMsg(GetSystemMessage(13144), boostPercentString, string(expBoostInfo.Count)), util.Yellow, "", true, true);
	}
	else
	{
		drawListArr[drawListArr.Length] = addDrawItemText(MakeFullSystemMsg(GetSystemMessage(13144), boostPercentString, string(expBoostInfo.Count)), util.Gray, "", true, true);
	}
	expBoostBtn.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
	return;
}

function UpdatePostBoxControls()
{
	local WindowHandle wnd;
	local TextBoxHandle textBox;

	wnd = GetBottomBarBtnWnd(PostBox);
	if(((wnd.m_pTargetWnd == none) || (wnd.IsShowWindow() == false)))
	{
		return;
	}
	textBox = TextBoxHandle(wnd.GetChildWindow("PostBoxBtn_txt"));
	textBox.SetText(string(_bottomBarInfo.unreadMailCnt));
	return;
}

function UpdateClanControls()
{
	local WindowHandle wnd;
	local TextBoxHandle textBox;
	local TextureHandle Icontex;

	wnd = GetBottomBarBtnWnd(Clan);
	if(((wnd.m_pTargetWnd == none) || (wnd.IsShowWindow() == false)))
	{
		return;
	}
	textBox = TextBoxHandle(wnd.GetChildWindow("ClanBtn_txt"));
	Icontex = TextureHandle(wnd.GetChildWindow("ClanBtn_tex"));
	if((_bottomBarInfo.isClanMember == true))
	{
		Icontex.SetTexture("L2UI_NewTex.Bottombar.BottomBar_Clan");
		textBox.SetText(string(_bottomBarInfo.clanMemberCnt));
	}
	else
	{
		Icontex.SetTexture("L2UI_NewTex.BottomBar.BottomBar_ClanSearch");
		textBox.SetText(GetSystemString(314));
	}
	return;
}

function UpdatePartyControls()
{
	local WindowHandle wnd;
	local TextBoxHandle textBox;
	local TextureHandle normalTex, alarmTex;

	wnd = GetBottomBarBtnWnd(Party);
	if(((wnd.m_pTargetWnd == none) || (wnd.IsShowWindow() == false)))
	{
		return;
	}
	textBox = TextBoxHandle(wnd.GetChildWindow("PartyBtn_txt"));
	normalTex = TextureHandle(wnd.GetChildWindow("PartyBtn_tex"));
	alarmTex = TextureHandle(wnd.GetChildWindow("PartyMatching_tex"));
	if((_bottomBarInfo.isPartyAlarm == true))
	{
		normalTex.HideWindow();
		alarmTex.ShowWindow();
	}
	else
	{
		normalTex.ShowWindow();
		alarmTex.HideWindow();
	}
	if((_bottomBarInfo.isPartyOnState == true))
	{
		textBox.SetText("ON");
	}
	else
	{
		textBox.SetText("OFF");
	}
	return;
}

function SetPartyOnOffState(bool isShow, bool isMinimized)
{
	local bool isOn;

	isOn = isShow;
	if(((isShow == false) && (_bottomBarInfo.isPartyWndMinimized == true)))
	{
		isOn = true;
	}
	_bottomBarInfo.isPartyWndMinimized = isMinimized;
	if((_bottomBarInfo.isPartyOnState != isOn))
	{
		_bottomBarInfo.isPartyOnState = isOn;
		UpdatePartyControls();
	}
	return;
}

function SetPartyAlarmOn(bool isAlarm)
{
	if((_bottomBarInfo.isPartyAlarm != isAlarm))
	{
		_bottomBarInfo.isPartyAlarm = isAlarm;
		UpdatePartyControls();
	}
	return;
}

function UpdatePcCafePointControls()
{
	local WindowHandle wnd;
	local TextBoxHandle textBox;

	wnd = GetBottomBarBtnWnd(PcCafePoint);
	if(((wnd.m_pTargetWnd == none) || (wnd.IsShowWindow() == false)))
	{
		return;
	}
	textBox = TextBoxHandle(wnd.GetChildWindow("PcCafePointBtn_txt"));
	textBox.SetText(MakeCostString(string(_bottomBarInfo.PcCafePoint)));
	return;
}

function UpdateLCoinShopControls()
{
	local WindowHandle wnd;
	local TextBoxHandle textBox;
	local ButtonHandle btn;
	local array<DrawItemInfo> drawListArr;
	local ItemInfo ItemInfo;
	local TextureHandle Icontex;
	local bool IsInova;

	wnd = GetBottomBarBtnWnd(LCoinShop);
	if(((wnd.m_pTargetWnd == none) || (wnd.IsShowWindow() == false)))
	{
		return;
	}
	textBox = TextBoxHandle(wnd.GetChildWindow("LCoinShopBtn_txt"));
	btn = ButtonHandle(wnd.GetChildWindow("LCoinShopBtn"));
	Icontex = TextureHandle(wnd.GetChildWindow("LCoinShopBtn_tex"));
	textBox.SetText(MakeCostString(string(_bottomBarInfo.bloodyCoinCnt)));
	if(((((int(GetLanguage()) == 9) || (int(GetLanguage()) == 12)) || (int(GetLanguage()) == 14)) || (int(GetLanguage()) == 8)))
	{
		IsInova = true;
	}
	if(getInstanceUIData().GetIsClassicServer())
	{
		Icontex.SetTexture("L2UI_NewTex.BottomBar.BottomBar_Lcoin");
		ItemInfo = GetItemInfoByClassID(92314);
		if(IsAdenServer())
		{
			if(IsInova)
			{
				drawListArr[drawListArr.Length] = addDrawItemText(((GetSystemString(13441) $ ": ") $ MakeCostString(string(_bottomBarInfo.aCoinCnt))), getInstanceL2Util().White, "", true, true);
			}
			else
			{
				drawListArr[drawListArr.Length] = addDrawItemText((MakeCostString(string(_bottomBarInfo.aCoinCnt)) @ GetSystemString(13441)), getInstanceL2Util().White, "", true, true);
			}
			drawListArr[drawListArr.Length] = addDrawItemBlank(4);
			drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
			drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		}
		if(IsInova)
		{
			drawListArr[drawListArr.Length] = addDrawItemText(((ItemInfo.Name $ ": ") $ MakeCostString(string(_bottomBarInfo.giranCoinCnt))), getInstanceL2Util().White, "", true, true);
		}
		else
		{
			drawListArr[drawListArr.Length] = addDrawItemText((MakeCostString(string(_bottomBarInfo.giranCoinCnt)) @ ItemInfo.Name), getInstanceL2Util().White, "", true, true);
		}
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		if(IsInova)
		{
			drawListArr[drawListArr.Length] = addDrawItemText(((GetSystemString(3931) $ ": ") $ MakeCostString(string(_bottomBarInfo.bloodyCoinCnt))), getInstanceL2Util().White, "", true, true);
		}
		else
		{
			drawListArr[drawListArr.Length] = addDrawItemText((MakeCostString(string(_bottomBarInfo.bloodyCoinCnt)) @ GetSystemString(3931)), getInstanceL2Util().White, "", true, true);
		}
		btn.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
	}
	else
	{
		Icontex.SetTexture("L2UI_NewTex.BottomBar.BottomBar_EinhasadCoin");
		btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13535)));
	}
	return;
}

function UpdateAdenaControls()
{
	local WindowHandle wnd;
	local TextBoxHandle textBox;
	local ButtonHandle btn;
	local array<DrawItemInfo> drawListArr;
	local float weightPer;
	local string Adenastring;

	wnd = GetBottomBarBtnWnd(Adena);
	if(((wnd.m_pTargetWnd == none) || (wnd.IsShowWindow() == false)))
	{
		return;
	}
	textBox = TextBoxHandle(wnd.GetChildWindow("AdenaBtn_txt"));
	btn = ButtonHandle(wnd.GetChildWindow("AdenaBtn"));
	if(getInstanceUIData().GetIsClassicServer())
	{
		weightPer = ((float(_bottomBarInfo.carringWeight) / float(_bottomBarInfo.carryWeight)) * 100.0000000);
		if((_bottomBarInfo.adenaCnt != INT64(0)))
		{
			drawListArr[drawListArr.Length] = addDrawItemText(ConvertNumToText(string(_bottomBarInfo.adenaCnt)), getInstanceL2Util().White, "", true, true);
		}
		else
		{
			drawListArr[drawListArr.Length] = addDrawItemText((string(_bottomBarInfo.adenaCnt) @ GetSystemString(469)), getInstanceL2Util().White, "", true, true);
		}
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = addDrawItemText((((GetSystemString(3070) @ string(_bottomBarInfo.invenCnt)) $ "/") $ string(_bottomBarInfo.invenMaxCnt)), getInstanceL2Util().White, "", true, true);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = addDrawItemText(((GetSystemString(52) @ ConvertFloatToString(weightPer, 2, false)) $ "%"), getInstanceL2Util().White, "", true, true);
		btn.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
		textBox.SetText(MakeCostString(string(_bottomBarInfo.adenaCnt)));
	}
	else
	{
		if(GetOptionBool("ExpBarOption", "bIsShowAdenaInfo"))
		{
			textBox.SetText(MakeCostString(string(_bottomBarInfo.adenaCnt)));
		}
		else
		{
			Adenastring = GetSystemString(3121);
			Class'Interface.L2Util'.static.GetEllipsisString(Adenastring, 105);
			textBox.SetText(Adenastring);
			btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3121)));
		}
		if((_bottomBarInfo.adenaCnt > INT64(0)))
		{
			btn.SetTooltipCustomType(MakeTooltipSimpleText(ConvertNumToText(string(_bottomBarInfo.adenaCnt))));
		}
		else
		{
			btn.ClearTooltip();
		}
	}
	return;
}

function UpdateInventoryControls()
{
	local WindowHandle wnd;
	local TextBoxHandle textBox;

	wnd = GetBottomBarBtnWnd(Inventory);
	if(((wnd.m_pTargetWnd == none) || (wnd.IsShowWindow() == false)))
	{
		return;
	}
	textBox = TextBoxHandle(wnd.GetChildWindow("InventoryBtn_txt"));
	textBox.SetText(((string(_bottomBarInfo.invenCnt) $ "/") $ string(_bottomBarInfo.invenMaxCnt)));
	return;
}

function UpdateSuppressControls()
{
	local WindowHandle wnd;
	local TextBoxHandle textBox;
	local string keyCntStr;
	local ButtonHandle btn;
	local TextureHandle Icontex, alarmTex, hotTimeTex;
	local array<DrawItemInfo> drawListArr;
	local int titleGapX;
	local float expPer;

	wnd = GetBottomBarBtnWnd(Suppress);
	if(((wnd.m_pTargetWnd == none) || (wnd.IsShowWindow() == false)))
	{
		return;
	}
	textBox = TextBoxHandle(wnd.GetChildWindow("SuppressBtn_txt"));
	btn = ButtonHandle(wnd.GetChildWindow("SuppressBtn"));
	Icontex = TextureHandle(wnd.GetChildWindow("SuppressBtn_tex"));
	alarmTex = TextureHandle(wnd.GetChildWindow("SuppressAlarm_tex"));
	hotTimeTex = TextureHandle(wnd.GetChildWindow("SuppressHotTime_tex"));
	keyCntStr = ("x" $ string(_bottomBarInfo.suppressKeyCnt));
	textBox.SetText(keyCntStr);
	if((_bottomBarInfo.suppressId <= 1))
	{
		btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13627)));
		Icontex.SetTexture("L2UI_NewTex.BottomBar.BottomBar_Suppress");
		alarmTex.HideWindow();
		hotTimeTex.HideWindow();
	}
	else
	{
		if(_bottomBarInfo.isSuppressHotTime)
		{
			drawListArr[drawListArr.Length] = addDrawItemTextureCustom("L2UI_NewTex.BottomBar.SuppressHotTime", false, false, 0, 0, 10, 11, 10, 11);
			titleGapX = 4;
			hotTimeTex.ShowWindow();
		}
		else
		{
			hotTimeTex.HideWindow();
		}
		drawListArr[drawListArr.Length] = addDrawItemText(_bottomBarInfo.suppressName, getInstanceL2Util().Yellow, "", false, true, titleGapX);
		drawListArr[drawListArr.Length] = addDrawItemText(((" - " $ GetSystemString(13634)) @ keyCntStr), getInstanceL2Util().White, "", true, true);
		if(_bottomBarInfo.isSuppressMaxKey)
		{
			drawListArr[drawListArr.Length] = addDrawItemText((" - " $ GetSystemString(3451)), getInstanceL2Util().White, "", true, true);
		}
		else
		{
			expPer = ((float(_bottomBarInfo.suppressPoint) / float(_bottomBarInfo.suppressMaxPoint)) * 100.0000000);
			drawListArr[drawListArr.Length] = addDrawItemText(((" - " $ getInstanceL2Util().cutFloat(expPer)) @ GetSystemString(13635)), getInstanceL2Util().White, "", true, true);
		}
		btn.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
		if(_bottomBarInfo.isSuppressAlarm)
		{
			alarmTex.ShowWindow();
		}
		else
		{
			alarmTex.HideWindow();
		}
	}
	return;
}

function UpdateMagicLampContols()
{
	local WindowHandle wnd;
	local TextBoxHandle textBox;
	local ButtonHandle btn;
	local UserInfo myUserInfo;
	local string perStr, tooltipPerStr;
	local AnimTextureHandle completeEffectTex;
	local array<DrawItemInfo> drawListArr;
	local L2Util util;

	wnd = GetBottomBarBtnWnd(MagicLamp);
	if(((wnd.m_pTargetWnd == none) || (wnd.IsShowWindow() == false)))
	{
		return;
	}
	if(!GetPlayerInfo(myUserInfo))
	{
		return;
	}
	util = getInstanceL2Util();
	textBox = TextBoxHandle(wnd.GetChildWindow("MagicLampBtn_txt"));
	btn = ButtonHandle(wnd.GetChildWindow("MagicLampBtn"));
	completeEffectTex = AnimTextureHandle(wnd.GetChildWindow("MagicLampComplete_tex"));
	perStr = (string(int(_bottomBarInfo.magicLampPercent)) $ "%");
	textBox.SetText(perStr);
	if((_bottomBarInfo.isMagicLampCompleteEffect == true))
	{
		completeEffectTex.Stop();
		completeEffectTex.Play();
		_bottomBarInfo.isMagicLampCompleteEffect = false;
	}
	tooltipPerStr = MakeFullSystemMsg(GetSystemMessage(13856), ConvertFloatToString(_bottomBarInfo.magicLampPercent, 4, false));
	if((_bottomBarInfo.magicLampBoostCnt > 0))
	{
		drawListArr[drawListArr.Length] = addDrawItemText(MakeFullSystemMsg(GetSystemMessage(13849), string(_bottomBarInfo.magicLampBoostPercent), string(_bottomBarInfo.magicLampBoostCnt)), util.Yellow, "", true, true);
	}
	else
	{
		drawListArr[drawListArr.Length] = addDrawItemText(MakeFullSystemMsg(GetSystemMessage(13849), string(_bottomBarInfo.magicLampBoostPercent), string(_bottomBarInfo.magicLampBoostCnt)), util.Gray, "", true, true);
	}
	drawListArr[drawListArr.Length] = addDrawItemText(tooltipPerStr, util.White, "", true, true);
	btn.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
	return;
}

function UpdateRandomCraftControls()
{
	local WindowHandle wnd;
	local TextBoxHandle textBox;
	local ButtonHandle btn;
	local float MaxPoint, fPer;
	local int maxGauge, currentCharge;
	local string pointStr, gaugeStr;
	local TextureHandle alarmTex;

	wnd = GetBottomBarBtnWnd(RandomCraft);
	if(((wnd.m_pTargetWnd == none) || (wnd.IsShowWindow() == false)))
	{
		return;
	}
	textBox = TextBoxHandle(wnd.GetChildWindow("RandomCraftBtn_txt"));
	btn = ButtonHandle(wnd.GetChildWindow("RandomCraftBtn"));
	alarmTex = TextureHandle(wnd.GetChildWindow("RandomCraftAlarm_tex"));
	MaxPoint = float(Class'NWindow.RandomCraftAPI'.static.GetMaxItemPoint());
	maxGauge = Class'NWindow.RandomCraftAPI'.static.GetMaxGaugeValue();
	pointStr = ("x" $ string(_bottomBarInfo.randomCraftPoint));
	currentCharge = int(getInstanceL2Util().Get9999Percent(INT64(_bottomBarInfo.randomCraftCharge), INT64(maxGauge)));
	fPer = ((float(currentCharge) / float(maxGauge)) * 100.0000000);
	gaugeStr = (ConvertFloatToString(fPer, 2, false) $ "%");
	textBox.SetText(pointStr);
	btn.SetTooltipCustomType(MakeTooltipMultiText((GetSystemString(13159) @ pointStr), getInstanceL2Util().White, "", true, gaugeStr, getInstanceL2Util().Yellow, "", true, , , , ));
	if((_bottomBarInfo.isRandomCraftAlarm == true))
	{
		alarmTex.ShowWindow();
	}
	else
	{
		alarmTex.HideWindow();
	}
	return;
}

function UpdateLCoinCraftControls()
{
	local WindowHandle wnd;
	local TextureHandle alarmTex, alarmTagTex;

	wnd = GetBottomBarBtnWnd(LCoinCraft);
	if(((wnd.m_pTargetWnd == none) || (wnd.IsShowWindow() == false)))
	{
		return;
	}
	alarmTex = TextureHandle(wnd.GetChildWindow("LCoinCraftAlarm_Tex"));
	alarmTagTex = TextureHandle(wnd.GetChildWindow("LimitedAlarm_tex"));
	alarmTex.HideWindow();
	alarmTagTex.HideWindow();
	return;
}

function UpdateVitaminManagerControls()
{
	return;
}

function _UpdateDualInventoryControls()
{
	local TextBoxHandle textBox;
	local WindowHandle wnd;

	wnd = GetBottomBarBtnWnd(DualInventory);
	if(((wnd.m_pTargetWnd == none) || (wnd.IsShowWindow() == false)))
	{
		return;
	}
	textBox = TextBoxHandle(wnd.GetChildWindow("DualInventoryBtn_txt"));
	switch(InventoryWnd(GetScript("InventoryWnd"))._GetSwapSelectButtonIndex())
	{
		case 0:
			textBox.SetText("A");
			break;
		case 1:
			textBox.SetText("B");
			break;
		default:
			break;
	}
	wnd.GetChildWindow("DualInventoryBtn").SetTooltipCustomType(GetDualEquipCustomTooltip());
	return;
}

function CustomTooltip GetDualEquipCustomTooltip()
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;
	local string A, B;
	local Color colorA, ColorB;

	A = GetSystemString(14274);
	B = GetSystemString(14275);
	switch(InventoryWnd(GetScript("InventoryWnd"))._GetSwapSelectButtonIndex())
	{
		case 0:
			A = (((A $ "(") $ GetSystemString(3533)) $ ")");
			colorA = getInstanceL2Util().Yellow;
			ColorB = getInstanceL2Util().Gray;
			break;
		case 1:
			B = (((B $ "(") $ GetSystemString(3533)) $ ")");
			colorA = getInstanceL2Util().Gray;
			ColorB = getInstanceL2Util().Yellow;
			break;
		default:
			break;
	}
	drawListArr[drawListArr.Length] = addDrawItemText(A, colorA, "", false, true);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = addDrawItemText(B, ColorB, "", true, true);
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;
}

function UpdateUIControls()
{
	UpdateExpStatusControls();
	UpdateExpStatusControls();
	UpdateExpInfoControls();
	UpdateExpBoostInfoControls();
	UpdatePostBoxControls();
	UpdateClanControls();
	UpdatePartyControls();
	UpdatePcCafePointControls();
	UpdateLCoinShopControls();
	UpdateAdenaControls();
	UpdateInventoryControls();
	UpdateSuppressControls();
	UpdateMagicLampContols();
	UpdateRandomCraftControls();
	UpdateLCoinCraftControls();
	UpdateVitaminManagerControls();
	_UpdateDualInventoryControls();
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "PostBoxBtn":
			OnPostBoxBtnClicked();
			break;
		case "ClanBtn":
			OnClanBtnClicked();
			break;
		case "PartyBtn":
			OnPartyBtnClicked();
			break;
		case "LCoinShopBtn":
			OnLCoinShopBtnClicked();
			break;
		case "PcCafePointBtn":
			OnPcCafePointBtnClicked();
			break;
		case "AdenaBtn":
			OnAdenaBtnClicked();
			break;
		case "InventoryBtn":
			OnInventoryBtnClicked();
			break;
		case "SuppressBtn":
			OnSuppressBtnClicked();
			break;
		case "RandomCraftBtn":
			OnRandomCraftBtnClicked();
			break;
		case "RandomCraftChargingBtn":
			OnRandomCraftChargingBtnClicked();
			break;
		case "LCoinCraftBtn":
			OnLCoinCraftBtnClicked();
			break;
		case "VitaminManagerBtn":
			OnVitaminManagerBtnClicked();
			break;
		case "DualInventoryBtn":
			OnDualInventoryBtnClicked();
			break;
		default:
			break;
	}
	return;
}

event OnMouseOver(WindowHandle W)
{
	if(((_bottomBarInfo.isSuppressAlarm == true) && (W.GetWindowName() == "SuppressBtn")))
	{
		_bottomBarInfo.isSuppressAlarm = false;
		UpdateSuppressControls();
	}
	if(((_bottomBarInfo.isRandomCraftAlarm == true) && (W.GetWindowName() == "RandomCraftBtn")))
	{
		_bottomBarInfo.isRandomCraftAlarm = false;
		UpdateRandomCraftControls();
	}
	return;
}

event OnPostBoxBtnClicked()
{
	local WindowHandle win;

	win = GetWindowHandle("PostBoxWnd");
	if(win.IsShowWindow())
	{
		win.HideWindow();
		PlayConsoleSound(IFST_WINDOW_CLOSE);
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_OPEN);
		RequestRequestReceivedPostList();
	}
	return;
}

event OnClanBtnClicked()
{
	if((_bottomBarInfo.isClanMember == true))
	{
		if(getInstanceUIData().GetIsClassicServer())
		{
			if(getInstanceL2Util().isClanV2())
			{
				toggleWindow("ClanGfxWnd", true, true);
			}
			else
			{
				toggleWindow("ClanWndClassicNew", true, true);
			}
		}
		else if(getInstanceL2Util().isClanV2())
		{
			toggleWindow("ClanGfxWnd", true, true);
		}
		else
		{
			toggleWindow("ClanWnd", true, true);
		}
	}
	else
	{
		toggleWindow("ClanSearch", true, true);
	}
	return;
}

event OnPartyBtnClicked()
{
	_bottomBarInfo.isPartyAlarm = false;
	Class'NWindow.PartyMatchAPI'.static.RequestOpenPartyMatch();
	return;
}

event OnLCoinShopBtnClicked()
{
	toggleWindow("ShopLcoinWnd", true, true);
	return;
}

event OnPcCafePointBtnClicked()
{
	if(getInstanceL2Util().getIsPrologueGrowType())
	{
		AddSystemMessage(4533);
	}
	else if(GetWindowHandle("NPCDialogWnd").IsShowWindow())
	{
		GetWindowHandle("NPCDialogWnd").HideWindow();
	}
	else
	{
		RequestOpenWndWithoutNPC(OPEN_PCCAFE_HTML);
	}
	return;
}

event OnAdenaBtnClicked()
{
	local bool isShowAdenaOption;

	if(getInstanceUIData().GetIsClassicServer())
	{
		toggleWindow("InventoryWnd", true, true);
	}
	else
	{
		isShowAdenaOption = GetOptionBool("ExpBarOption", "bIsShowAdenaInfo");
		SetOptionBool("ExpBarOption", "bIsShowAdenaInfo", !isShowAdenaOption);
		UpdateAdenaControls();
	}
	return;
}

event OnInventoryBtnClicked()
{
	toggleWindow("InventoryWnd", true, true);
	return;
}

event OnSuppressBtnClicked()
{
	toggleWindow("SuppressWnd", true, true);
	SuppressWnd(GetScript("SuppressWnd")).setSelectListByID(_bottomBarInfo.suppressId);
	return;
}

event OnRandomCraftBtnClicked()
{
	toggleWindow("RandomCraftWnd", true, true);
	return;
}

event OnRandomCraftChargingBtnClicked()
{
	toggleWindow("RandomCraftChargingWnd", true, true);
	return;
}

event OnLCoinCraftBtnClicked()
{
	toggleWindow("ShopLCoinCraftWnd", true, true);
	return;
}

event OnVitaminManagerBtnClicked()
{
	if(GetWindowHandle("PremiumManagerWnd").IsShowWindow())
	{
		GetWindowHandle("PremiumManagerWnd").HideWindow();
	}
	else
	{
		RequestOpenWndWithoutNPC(OPEN_PREMIUM_MANAGER);
	}
	return;
}

event OnDualInventoryBtnClicked()
{
	ExecuteEvent(11591, "");
	return;
}

event OnLoad()
{
	Initialize();
	return;
}

event OnRegisterEvent()
{
	if((true == false))
	{
		return;
	}
	RegisterEvent(40);
	RegisterEvent(180);
	RegisterEvent(9560);
	RegisterEvent(9550);
	RegisterEvent(420);
	RegisterEvent(320);
	RegisterEvent(9570);
	RegisterEvent(2070);
	RegisterEvent(11060);
	RegisterEvent(1910);
	RegisterEvent(EV_PacketID(1104));
	RegisterEvent(EV_PacketID(843));
	RegisterEvent(EV_PacketID(936));
	return;
}

event OnEvent(int Event_ID, string param)
{
	if((true == false))
	{
		return;
	}
	switch(Event_ID)
	{
		case 180:
			Nt_EV_UpdateUserInfo();
			break;
		case 9560:
			Nt_EV_PledgeCount(param);
			break;
		case 9550:
			Nt_EV_UnReadMailCount(param);
			break;
		case 420:
			Nt_EV_ClanDeleteAllMember(param);
			break;
		case 320:
			Nt_EV_EV_ClanInfo(param);
			break;
		case 11060:
			Nt_EV_BloodyCoinCount(param);
			break;
		case 1910:
			Nt_EV_PCCafePointInfo(param);
			break;
		case 9570:
			Nt_EV_AdenaInvenCount(param);
			break;
		case 2070:
			Nt_EV_SetMaxCount(param);
			break;
		case EV_PacketID(1104):
			Nt_S_EX_MAGICLAMP_INFO();
			break;
		case EV_PacketID(843):
			Nt_S_EX_USER_BOOST_STAT();
			break;
		case EV_PacketID(936):
			Nt_S_EX_SUBJUGATION_SIDEBAR();
			break;
		case 40:
			ResetInfo();
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
		SetSuppressEvent();
	}
	return;
}

event OnShow()
{
	if((true == false))
	{
		Me.HideWindow();
		return;
	}
	if(IsShowPcCafe())
	{
		RegistAndShowBtn(PcCafePoint);
	}
	else
	{
		UnregistAndHideBtn(PcCafePoint);
	}
	UpdateUIControls();
	return;
}

function Nt_EV_UpdateUserInfo()
{
	local UserInfo UserInfo;

	GetPlayerInfo(UserInfo);
	if((_bottomBarInfo.expPercentRate != UserInfo.fExpPercentRate))
	{
		_bottomBarInfo.expPercentRate = UserInfo.fExpPercentRate;
		UpdateExpStatusControls();
		UpdateExpInfoControls();
	}
	if(((_bottomBarInfo.carringWeight != UserInfo.nCarringWeight) || (_bottomBarInfo.carryWeight != UserInfo.nCarryWeight)))
	{
		_bottomBarInfo.carringWeight = UserInfo.nCarringWeight;
		_bottomBarInfo.carryWeight = UserInfo.nCarryWeight;
		UpdateAdenaControls();
	}
	return;
}

function Nt_EV_PledgeCount(string param)
{
	local int clanMemberCnt;

	ParseInt(param, "PledgeCount", clanMemberCnt);
	_bottomBarInfo.clanMemberCnt = clanMemberCnt;
	if((clanMemberCnt > 0))
	{
		_bottomBarInfo.isClanMember = true;
	}
	UpdateClanControls();
	return;
}

function Nt_EV_UnReadMailCount(string param)
{
	local int unreadMailCnt;

	ParseInt(param, "UnReadMailCount", unreadMailCnt);
	_bottomBarInfo.unreadMailCnt = unreadMailCnt;
	UpdatePostBoxControls();
	return;
}

function Nt_EV_ClanDeleteAllMember(string param)
{
	_bottomBarInfo.isClanMember = false;
	UpdateClanControls();
	return;
}

function Nt_EV_EV_ClanInfo(string param)
{
	_bottomBarInfo.isClanMember = true;
	UpdateClanControls();
	return;
}

function Nt_EV_BloodyCoinCount(string param)
{
	local INT64 bloodyCoinCnt;

	ParseINT64(param, "CoinCount", bloodyCoinCnt);
	_bottomBarInfo.bloodyCoinCnt = bloodyCoinCnt;
	UpdateLCoinShopControls();
	return;
}

function Nt_EV_PCCafePointInfo(string param)
{
	local int PcCafePoint, Show;

	ParseInt(param, "TotalPoint", PcCafePoint);
	ParseInt(param, "Show", Show);
	if((Show > 0))
	{
		_bottomBarInfo.PcCafePoint = PcCafePoint;
	}
	UpdatePcCafePointControls();
	return;
}

function Nt_EV_AdenaInvenCount(string param)
{
	local int invenCnt;
	local INT64 adenaCnt, aCoinCnt, giranCoinCnt;
	local bool needUpdateLCoinShopBtn;

	ParseInt(param, "InvenCount", invenCnt);
	if((_bottomBarInfo.invenCnt != invenCnt))
	{
		_bottomBarInfo.invenCnt = invenCnt;
		UpdateInventoryControls();
		if(getInstanceUIData().GetIsClassicServer())
		{
			UpdateAdenaControls();
		}
	}
	adenaCnt = GetAdena();
	if((_bottomBarInfo.adenaCnt != adenaCnt))
	{
		_bottomBarInfo.adenaCnt = adenaCnt;
		UpdateAdenaControls();
	}
	if(getInstanceUIData().GetIsClassicServer())
	{
		giranCoinCnt = GetInventoryItemCount(GetItemID(92314));
		if((_bottomBarInfo.giranCoinCnt != giranCoinCnt))
		{
			_bottomBarInfo.giranCoinCnt = giranCoinCnt;
			needUpdateLCoinShopBtn = true;
		}
		if(IsAdenServer())
		{
			aCoinCnt = GetInventoryItemCount(GetItemID(97145));
			if((_bottomBarInfo.aCoinCnt != aCoinCnt))
			{
				_bottomBarInfo.aCoinCnt = aCoinCnt;
				needUpdateLCoinShopBtn = true;
			}
		}
	}
	if((needUpdateLCoinShopBtn == true))
	{
		UpdateLCoinShopControls();
	}
	return;
}

function Nt_EV_SetMaxCount(string param)
{
	local int invenMaxCnt;

	ParseInt(param, "Inventory", invenMaxCnt);
	if((_bottomBarInfo.invenMaxCnt != invenMaxCnt))
	{
		_bottomBarInfo.invenMaxCnt = invenMaxCnt;
		UpdateInventoryControls();
		UpdateAdenaControls();
	}
	return;
}

function Nt_S_EX_MAGICLAMP_INFO()
{
	local UIPacket._S_EX_MAGICLAMP_INFO packet;
	local float validExpPercent, oldExpPercent;
	local int OldValue, NewValue;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_MAGICLAMP_INFO(packet))
	{
		return;
	}
	validExpPercent = (float(packet.nExpPercentage) / 10000.0000000);
	if((((_bottomBarInfo.magicLampPercent == validExpPercent) && (_bottomBarInfo.magicLampBoostPercent == packet.nBoostPercentage)) && (_bottomBarInfo.magicLampBoostCnt == packet.nBoostCount)))
	{
		return;
	}
	oldExpPercent = _bottomBarInfo.magicLampPercent;
	OldValue = int((oldExpPercent / 10.0000000));
	_bottomBarInfo.magicLampPercent = validExpPercent;
	_bottomBarInfo.magicLampBoostPercent = packet.nBoostPercentage;
	_bottomBarInfo.magicLampBoostCnt = packet.nBoostCount;
	NewValue = int((_bottomBarInfo.magicLampPercent / 10.0000000));
	if((((oldExpPercent != 0.0000000) && (NewValue == 0)) && (OldValue == 9)))
	{
		_bottomBarInfo.isMagicLampCompleteEffect = true;
	}
	UpdateMagicLampContols();
	return;
}

function Nt_S_EX_USER_BOOST_STAT()
{
	local UIPacket._S_EX_USER_BOOST_STAT packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_USER_BOOST_STAT(packet))
	{
		return;
	}
	if((packet.Type < 4))
	{
		_bottomBarInfo.expBoostInfos[packet.Type] = packet;
	}
	UpdateExpBoostInfoControls();
	return;
}

function Nt_S_EX_SUBJUGATION_SIDEBAR()
{
	local SubjugationData mySubjugationDatas;
	local UIPacket._S_EX_SUBJUGATION_SIDEBAR packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_SUBJUGATION_SIDEBAR(packet))
	{
		return;
	}
	_bottomBarInfo.suppressId = packet.nID;
	if(!GetCurrentSubjugationData(packet.nID, mySubjugationDatas))
	{
		_bottomBarInfo.isSuppressHotTime = false;
	}
	if((packet.nGachaPoint == 0))
	{
		_bottomBarInfo.isSuppressAlarm = false;
	}
	if((((packet.nGachaPoint != 0) && (packet.nGachaPoint != _bottomBarInfo.suppressKeyCnt)) && (packet.nGachaPoint > _bottomBarInfo.suppressKeyCnt)))
	{
		_bottomBarInfo.isSuppressAlarm = true;
	}
	_bottomBarInfo.isSuppressMaxKey = (packet.nGachaPoint >= mySubjugationDatas.MaxPeriodicGachaPoint);
	_bottomBarInfo.suppressName = mySubjugationDatas.Name;
	_bottomBarInfo.suppressKeyCnt = packet.nGachaPoint;
	_bottomBarInfo.suppressPoint = packet.nPoint;
	_bottomBarInfo.suppressMaxPoint = mySubjugationDatas.MaxSubjugationPoint;
	SetSuppressEvent();
	return;
}

function Nt_S_EX_CRAFT_INFO(UIPacket._S_EX_CRAFT_INFO packet)
{
	if((true == false))
	{
		return;
	}
	if((packet.nPoint == 0))
	{
		_bottomBarInfo.isRandomCraftAlarm = false;
	}
	if((((packet.nPoint != 0) && (packet.nPoint != _bottomBarInfo.randomCraftPoint)) && (packet.nPoint > _bottomBarInfo.randomCraftPoint)))
	{
		_bottomBarInfo.isRandomCraftAlarm = true;
	}
	_bottomBarInfo.randomCraftPoint = packet.nPoint;
	_bottomBarInfo.randomCraftCharge = packet.nCharge;
	UpdateRandomCraftControls();
	return;
}
