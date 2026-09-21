class UIDevTestWnd extends UICommonAPI;

var string m_Windowname;
var WindowHandle Me;
var SliderCtrlHandle TestSliderCtrl;
var ProgressCtrlHandle Progress1;
var ProgressCtrlHandle Progress2;
var ProgressCtrlHandle Progress3;
var StatusBarHandle HPStatusBar;
var StatusBarHandle MPStatusBar;
var StatusRoundHandle HPStatusRound;
var StatusRoundHandle MPStatusRound;
var TextBoxHandle SlideText;
var EditBoxHandle SdEditBox;
var TreeHandle CTreeCtrl;
var float shakeSize;
var float Dir;
var int shakeTimeID;
var int repeatCount;
var int currentCount;
var int posX;
var int posY;
var UIControlGroupButtons groupButtons;
var UIControlGroupButtonAssets UIControlGroupButtonAsset1;
var UIControlNeedItemSelectMultiItems UIControlNeedItemSelectMultiItem;
var UIControlNeedItemSelectMultiItems UIControlNeedItemSelectMultiItemDesc;
var float teamBarOffset;

function OnLoad()
{
	SetClosingOnESC();
	Me = GetWindowHandle("UIDevTestWnd");
	TestSliderCtrl = GetSliderCtrlHandle("UIDevTestWnd.TestSliderCtrl");
	Progress1 = GetProgressCtrlHandle("UIDevTestWnd.Progress1");
	Progress2 = GetProgressCtrlHandle("UIDevTestWnd.Progress2");
	Progress3 = GetProgressCtrlHandle("UIDevTestWnd.Progress3");
	HPStatusBar = GetStatusBarHandle("UIDevTestWnd.HPStatusBar");
	MPStatusBar = GetStatusBarHandle("UIDevTestWnd.MPStatusBar");
	HPStatusRound = GetStatusRoundHandle("UIDevTestWnd.HPStatusRound");
	MPStatusRound = GetStatusRoundHandle("UIDevTestWnd.MPStatusRound");
	SlideText = GetTextBoxHandle("UIDevTestWnd.SlideText");
	SdEditBox = GetEditBoxHandle("UIDevTestWnd.SdEditBox");
	CTreeCtrl = GetTreeHandle("UIDevTestWnd.testTreeCtrl");
	GetWindowHandle("UIDevTestWnd.UIControlGroupButtonAsset1").SetScript("UIControlGroupButtonAssets");
	UIControlGroupButtonAsset1 = UIControlGroupButtonAssets(GetWindowHandle("UIDevTestWnd.UIControlGroupButtonAsset1").GetScript());
	UIControlGroupButtonAsset1._SetWindow("UIDevTestWnd.UIControlGroupButtonAsset1");
	UIControlGroupButtonAsset1._SetStartInfo("", "", "", true);
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setButtonText(0, "전체");  // EN?: ALL
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setButtonText(1, "2번");  // EN?: Twice
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setButtonText(2, "3번");  // EN?: 3 times
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setButtonText(3, "4번");  // EN?: 4 times
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setShowButtonNum(4);
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setAutoWidth(700, 2);
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setConnectIconTexture(0, GetTextureHandle("UIDevTestWnd.Texture2"), 0, 0, "center", "L2UI_NewTex.StyleWnd.StyleWndSmallNameDecoBtn_Normal", "L2UI_NewTex.StyleWnd.StyleWndSmallNameDecoBtn_Normal_Selected", "L2UI_NewTex.StyleWnd.StyleWndSmallNameDecoBtn_Over", "L2UI_NewTex.StyleWnd.StyleWndSmallNameDecoBtn_Normal", "icon.etc_i.etc_jewel_gold_i00");
	UIControlGroupButtonAsset1._GetGroupButtonsInstance().DelegateOnOutButton = delegateOutBtn;
	UIControlGroupButtonAsset1._GetGroupButtonsInstance().DelegateOnOverButton = delegateOverBtn;
	UIControlGroupButtonAsset1._setDelayTime(500);
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._reservedString = "test1";
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setButtonTexture(0, "L2UI_ct1.Button.Auction_Button_DF", "L2UI_ct1.Button.Auction_Button_DF", "L2UI_ct1.Button.Auction_Button_over");
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setButtonTexture(3, "L2UI_ct1.Button.Auction_Button_DF", "L2UI_ct1.Button.Auction_Button_DF", "L2UI_ct1.Button.Auction_Button_over");
	UIControlGroupButtonAsset1._GetGroupButtonsInstance().DelegateOnClickButton = DelegateOnClickButton;
	UIControlNeedItemSelectMultiItem = UIControlNeedItemSelectMultiItems(GetWindowHandle("UIDevTestWnd.UIControlNeedItemSelectMultiItem").GetScript());
	UIControlNeedItemSelectMultiItemDesc = UIControlNeedItemSelectMultiItems(GetWindowHandle("UIDevTestWnd.UIControlNeedItemSelectMultiItemDesc").GetScript());
	return;
}

function delegateOutBtn(string parentWndName, string strName, int Index, bool bSelect)
{
	Debug("----delegateOutBtn----");
	Debug(("parentWndName" @ parentWndName));
	Debug(("strName" @ strName));
	Debug(("index" @ string(Index)));
	Debug(("bSelect" @ string(bSelect)));
	return;
}

function delegateOverBtn(string parentWndName, string strName, int Index, bool bSelect)
{
	Debug("----delegateOverBtn----");
	Debug(("parentWndName" @ parentWndName));
	Debug(("strName" @ strName));
	Debug(("index" @ string(Index)));
	Debug(("bSelect" @ string(bSelect)));
	return;
}

function DelegateOnClickButton(string parentWndName, string strName, int Index)
{
	Debug(("strName" @ parentWndName));
	Debug(("strName" @ strName));
	Debug(("index" @ string(Index)));
	if((Index == 3))
	{
		ShowContextMenu(620, 470);
	}
	else if((Index == 1))
	{
		if(UIControlNeedItemSelectMultiItemDesc._isOpenPopup())
		{
			UIControlNeedItemSelectMultiItemDesc._OpenPopup(false);
		}
		else
		{
			UIControlNeedItemSelectMultiItemDesc._OpenPopup(true);
			UIControlNeedItemSelectMultiItemDesc._ShakeMultiItemsPopup();
		}
	}
	return;
}

function ShowContextMenu(int X, int Y)
{
	local UIControlContextMenu ContextMenu;

	ContextMenu = Class'Interface.UIControlContextMenu'.static.GetInstance();
	ContextMenu.Clear();
	ContextMenu.List_ListCtrl.ClearTooltip();
	ContextMenu.MenuNew(GetSystemString(1446), 1, GTColor().Yellow);
	ContextMenu.MenuAddIcon("L2UI_EPIC.ClanWnd.ClanWnd_Icon_penalty");
	ContextMenu.MenuNew(GetSystemString(3507), 2, GTColor().VIOLET02);
	ContextMenu.MenuAddIcon("L2UI_EPIC.ClanWnd.ClanWnd_Icon_Benefit");
	ContextMenu.MenuNew("테스트3", 3, GTColor().Red2);  // EN?: test3
	ContextMenu.MenuNew("테스트4", 3, GTColor().Blue);  // EN?: test4
	ContextMenu.DelegateOnClickContextMenu = HandleOnClickContextMenu;
	ContextMenu.DelegateOnHide = HandleOnHideContextMenu;
	ContextMenu.Show((X - 5), (Y - 5), string(self));
	return;
}

function HandleOnClickContextMenu(int Index)
{
	Debug(("index " $ string(Index)));
	return;
}

function HandleOnHideContextMenu()
{
	Debug("OnHideContextMenu");
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(15);
	return;
}

function OnShow()
{
	Debug(("시간 " @ getInstanceL2Util().TimeNumberToString(90)));  // EN?: Time
	Debug(("시간 " @ getInstanceL2Util().TimeNumberToString(10)));  // EN?: Time
	Debug(("시간 " @ getInstanceL2Util().TimeNumberToString(1)));  // EN?: Time
	Debug(("시간 " @ getInstanceL2Util().TimeNumberToString2(3606)));  // EN?: Time
	Debug(("시간 " @ getInstanceL2Util().TimeNumberToString2(606)));  // EN?: Time
	Debug(("시간 " @ getInstanceL2Util().TimeNumberToString2(6)));  // EN?: Time
	Progress1.SetProgressTime(TestSliderCtrl.GetTotalTickCount());
	Progress2.SetProgressTime(TestSliderCtrl.GetTotalTickCount());
	Progress3.SetProgressTime(TestSliderCtrl.GetTotalTickCount());
	SlideText.SetText(((string(TestSliderCtrl.GetCurrentTick()) $ "/") $ string((TestSliderCtrl.GetTotalTickCount() - 1))));
	SdEditBox.SetFocus();
	SdEditBox.SetString(string(TestSliderCtrl.GetCurrentTick()));
	SdEditBox.AllSelect();
	TestSliderCtrl.SetCurrentTick(int(SdEditBox.GetString()));
	setTree();
	groupButtons = new Class'Interface.UIControlGroupButtons';
	groupButtons._SetStartInfo("L2UI_ct1.RankingWnd.RankingWnd_SubTabButton", "L2UI_ct1.RankingWnd.RankingWnd_SubTabButton_Down", "l2ui_ct1.RankingWnd.RankingWnd_SubTabButton_Over", true);
	groupButtons._addButtonController(GetButtonHandle("UIDevTestWnd.selectButton1"), "오우44444444411111", 100);  // EN?: OU44444444411111
	groupButtons._addButtonController(GetButtonHandle("UIDevTestWnd.selectButton2"));
	groupButtons._addButtonController(GetButtonHandle("UIDevTestWnd.selectButton3"));
	groupButtons._addButtonController(GetButtonHandle("UIDevTestWnd.selectButton4"));
	groupButtons._addButtonController(GetButtonHandle("UIDevTestWnd.selectButton5"));
	groupButtons._addButtonController(GetButtonHandle("UIDevTestWnd.selectButton6"));
	groupButtons._addButtonController(GetButtonHandle("UIDevTestWnd.selectButton7"), "", 700);
	groupButtons._setButtonValue(4, 400);
	groupButtons.DelegateOnClickButton = groupButtonOnClickButton;
	groupButtons._setButtonText(2, "3번째다1234");  // EN?: 3rd 1234
	groupButtons._setButtonText(3, "4번째다12");  // EN?: 4th d12
	groupButtons._setButtonTextByName("selectButton7", "7번");  // EN?: Number 7
	groupButtons._setShowButtonNum();
	groupButtons._setAutoWidth(500, 10);
	groupButtons._setButtonTextColor(GTColor().Yellow, GTColor().Gray);
	groupButtons._setTopOrder(2);
	UIControlNeedItemSelectMultiItem = Class'Interface.UIControlNeedItemSelectMultiItems'.static._InitScript(GetWindowHandle("UIDevTestWnd.UIControlNeedItemSelectMultiItem"));
	UIControlNeedItemSelectMultiItem._ConnectPopup(GetWindowHandle("UIDevTestWnd.UIControlNeedItemSelectMultiItemPopup"));
	UIControlNeedItemSelectMultiItem._StartSelectItems(5);
	UIControlNeedItemSelectMultiItem._AddSelectItemClassID(1, INT64(1));
	UIControlNeedItemSelectMultiItem._AddSelectItemClassID(2, INT64(4));
	UIControlNeedItemSelectMultiItem._AddSelectItemClassID(3, INT64(53333));
	UIControlNeedItemSelectMultiItem._AddSelectItemClassID(57, INT64(1111333300));
	UIControlNeedItemSelectMultiItem._AddSelectItemClassID(91663, INT64(111131));
	UIControlNeedItemSelectMultiItem._AddSelectItemClassID(48472, INT64(1133333));
	UIControlNeedItemSelectMultiItem._AddNeedItemInfo(GetItemInfoByClassID(14559), INT64(1000), INT64(100));
	UIControlNeedItemSelectMultiItem._AddSelectItemClassID(4, INT64(2));
	UIControlNeedItemSelectMultiItem._EndSelectItems();
	UIControlNeedItemSelectMultiItem._SetNoticeTextChange("수수료를 선택하시길..");  // EN?: Choose a fee..
	UIControlNeedItemSelectMultiItem.DelegateSelectedItemOnClick = delegateItemSelectOnClick;
	Debug(("GetCanBuy" @ string(UIControlNeedItemSelectMultiItem._GetCanBuy())));
	UIControlNeedItemSelectMultiItemDesc = Class'Interface.UIControlNeedItemSelectMultiItems'.static._InitScript(GetWindowHandle("UIDevTestWnd.UIControlNeedItemSelectMultiItemDesc"));
	UIControlNeedItemSelectMultiItemDesc._ConnectPopup(GetWindowHandle("UIDevTestWnd.UIControlNeedItemSelectMultiItemPopupWithDesc"), true, 150);
	UIControlNeedItemSelectMultiItemDesc._StartSelectItems(5, 250, true, "재료 선택");  // EN?: Select material
	UIControlNeedItemSelectMultiItemDesc._AddSelectItemClassID(1, INT64(1), "확률 99%");  // EN?: Chance 99%
	UIControlNeedItemSelectMultiItemDesc._AddSelectItemClassID(2, INT64(4), "확률 19%", , "19");  // EN?: Chance 19%
	UIControlNeedItemSelectMultiItemDesc._AddSelectItemClassID(3, INT64(53333), "확률 55%", GTColor().Yellow, "55");  // EN?: Chance 55%
	UIControlNeedItemSelectMultiItemDesc._AddSelectItemClassID(57, INT64(32421400), "확률 0.1%", GTColor().Yellow, "0.1");  // EN?: Chance 0.1%
	UIControlNeedItemSelectMultiItemDesc._AddSelectItemClassID(91663, INT64(11111), "확률 0.555%");  // EN?: Chance 0.555%
	UIControlNeedItemSelectMultiItemDesc._AddSelectItemClassID(48472, INT64(11333111), "확률 0.22225%");  // EN?: Chance 0.22225%
	UIControlNeedItemSelectMultiItemDesc._AddNeedItemInfo(GetItemInfoByClassID(14559), INT64(1000), INT64(100), "확률 5%");  // EN?: <SK.ST>Chance</>: 5%
	UIControlNeedItemSelectMultiItemDesc._AddSelectItemClassID(4, INT64(2), "확률 100%");  // EN?: 100% Chance
	UIControlNeedItemSelectMultiItemDesc._EndSelectItems();
	UIControlNeedItemSelectMultiItemDesc._SetNoticeTextChange("수수료를 선택해라 abcdefghicejdslkjfsdfljkadlkjsfjklasjklfsasdffafsklj");  // EN?: Select a fee abcdefghicejdslkjfsdfljkadlkjsfjklasjklfsasdffafsklj
	UIControlNeedItemSelectMultiItemDesc.DelegateSelectedItemOnClick = delegateItemSelectOnClick;
	GetMeEffectViewportWnd("CenterLightEffectViewportWnd").SpawnEffect("LineageEffect2.ui_soul_crystal");
	return;
}

function delegateItemSelectOnClick(int SelectedIndex, int selectedClassID, INT64 selectedAmount)
{
	Debug(("selectedIndex" @ string(SelectedIndex)));
	Debug(("선택된 아이템 " @ string(selectedClassID)));  // EN?: Selected items
	Debug(("선택된 selectedAmount " @ string(selectedAmount)));  // EN?: selectedAmount
	if((selectedClassID == 14559))
	{
		Debug(("선택된 clasSID " @ string(UIControlNeedItemSelectMultiItem._GetMyClassID())));  // EN?: clasSID selected
		UIControlNeedItemSelectMultiItem._ModifyCurrentAmountMe(INT64(10000));
	}
	Debug(("UIControlNeedItemSelectMultiItemDesc _GetMySzReserved" @ UIControlNeedItemSelectMultiItemDesc._GetMySzReserved()));
	Debug(("myClassID:" @ string(UIControlNeedItemSelectMultiItem._GetMyClassID())));
	Debug(("_GetMyAmount:" @ string(UIControlNeedItemSelectMultiItem._GetMyAmount())));
	Debug(("_GetSelectedIndexPopup:" @ string(UIControlNeedItemSelectMultiItem._GetSelectedIndexPopup())));
	return;
}

function groupButtonOnClickButton(string parentWndName, string buttonName, int currentTabIndex)
{
	if((groupButtons._getButtonValueByName(buttonName) != -1))
	{
		Debug((((("groupButtonOnClickButton" @ parentWndName) @ buttonName) @ string(currentTabIndex)) @ string(groupButtons._getButtonValueByName(buttonName))));
	}
	return;
}

function setTree()
{
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 15:
			break;
		default:
			break;
	}
	return;
}

function OnMouseOver(WindowHandle wnd)
{
	groupButtons._OverButtonHandle(wnd);
	return;
}

function OnMouseOut(WindowHandle wnd)
{
	groupButtons._OutButtonHandle(wnd);
	return;
}

event OnLButtonDown(WindowHandle winHandle, int X, int Y)
{
	groupButtons._DownButtonHandle(winHandle);
	return;
}

function OnClickButton(string a_ButtonID)
{
	groupButtons._selectButton(a_ButtonID);
	switch(a_ButtonID)
	{
		case "test1Btn":
			groupButtons._setShowButtonNum(7);
			groupButtons._setdisconnectIconTextureAll();
			groupButtons._setAutoWidth(300, 2);
			groupButtons._setButtonHeight(25);
			groupButtons._setEnableAll();
			break;
		case "test2Btn":
			groupButtons._setShowButtonNum(2);
			groupButtons._setdisconnectIconTextureAll();
			groupButtons._setButtonText(0, "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
			groupButtons._setButtonText(1, "bbbbbbbbbb");
			groupButtons._setButtonHeight(50);
			groupButtons._setAutoWidth(500, 10);
			groupButtons._SetDisable(1);
			break;
		case "test3Btn":
			groupButtons._setShowButtonNum(4);
			groupButtons._setdisconnectIconTextureAll();
			groupButtons._setButtonText(0, "아아아아아아아아아아아아아아");  // EN?: AAAAHHHHHHHHHHHHH
			groupButtons._setButtonText(1, "이이이이이이이이이이이");  // EN?: Eeeeeeeeeeeeeeee
			groupButtons._setButtonText(2, "우우우우우우");  // EN?: Oooooh, oooooh.
			groupButtons._setButtonText(3, "에에에에에");  // EN?: Eeeeeeeeee
			groupButtons._setButtonHeight(25);
			groupButtons._setAutoWidth(500, 4);
			groupButtons._setEnableAll();
			break;
		case "test4Btn":
			groupButtons._setShowButtonNum(7);
			groupButtons._setdisconnectIconTextureAll();
			groupButtons._setButtonText(0, "1번");  // EN?: No.1
			groupButtons._setButtonText(1, "2번");  // EN?: Twice
			groupButtons._setButtonText(2, "3번");  // EN?: 3 times
			groupButtons._setButtonText(3, "4번");  // EN?: 4 times
			groupButtons._setButtonText(4, "5번");  // EN?: Number 5
			groupButtons._setButtonText(5, "6번");  // EN?: Number 6
			groupButtons._setButtonText(6, "7번");  // EN?: Number 7
			groupButtons._setMultilineButton(400, 80, 20, 10, 5);
			groupButtons._setConnectIconTexture(0, GetTextureHandle("UIDevTestWnd.Texture32"), 0, 0, "center", "L2UI_NewTex.StyleWnd.StyleWndSmallNameDecoBtn_Normal", "L2UI_NewTex.StyleWnd.StyleWndSmallNameDecoBtn_Normal_Selected", "L2UI_NewTex.StyleWnd.StyleWndSmallNameDecoBtn_Over", "L2UI_ct1.RankingWnd.RankingWnd_SubTabButton_Down", "L2UI_NewTex.StyleWnd.StyleWndSmallNameDecoBtn_Normal");
			groupButtons._setEnableAll();
			break;
		default:
			break;
	}
	return;
}

function SwitchTexture()
{
	local INT64 MaxValue, CurValue;
	local string t_hp, t_mp;
	local Color c_hp, c_mp;
	local StatusBaseHandle Handle;

	Handle = HPStatusBar.GetSelfScript();
	c_hp = HPStatusBar.GetGaugeColor(24);
	c_mp = MPStatusBar.GetGaugeColor(24);
	HPStatusBar.SetGaugeColor(24, c_mp);
	MPStatusBar.SetGaugeColor(24, c_hp);
	c_hp = HPStatusRound.GetGaugeColor(1);
	c_mp = MPStatusRound.GetGaugeColor(1);
	HPStatusRound.SetGaugeColor(1, c_mp);
	MPStatusRound.SetGaugeColor(1, c_hp);
	t_hp = HPStatusRound.GetGaugeTexture(5);
	t_mp = MPStatusRound.GetGaugeTexture(5);
	HPStatusRound.SetGaugeTexture(5, t_mp);
	MPStatusRound.SetGaugeTexture(5, t_hp);
	HPStatusRound.GetPoint(CurValue, MaxValue);
	return;
}

function BFO()
{
	local ButtonHandle ButtonHandle1;

	ButtonHandle1 = GetButtonHandle("UIDevTestWnd.test1Btn");
	ButtonHandle1.SetFocus();
	ButtonHandle1.BringToFrontOf("test2Btn");
	Class'NWindow.UIAPI_WINDOW'.static.BringToFrontOf("UIDevTestWnd.test2Btn", "test1Btn");
	return;
}

function OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick)
{
	local int ivalue;

	switch(strID)
	{
		case "TestSliderCtrl":
			ivalue = TestSliderCtrl.GetCurrentTick();
			SlideText.SetText(((string(ivalue) $ "/") $ string((TestSliderCtrl.GetTotalTickCount() - 1))));
			Progress1.SetPos(ivalue);
			Progress2.SetPos(ivalue);
			Progress3.SetPos(ivalue);
			HPStatusBar.SetPoint(INT64(ivalue), INT64((TestSliderCtrl.GetTotalTickCount() - 1)));
			MPStatusBar.SetPoint(INT64(ivalue), INT64((TestSliderCtrl.GetTotalTickCount() - 1)));
			HPStatusRound.SetPoint(INT64(ivalue), INT64((TestSliderCtrl.GetTotalTickCount() - 1)));
			MPStatusRound.SetPoint(INT64(ivalue), INT64((TestSliderCtrl.GetTotalTickCount() - 1)));
			circleMove(ivalue, 20.0000000);
			break;
		default:
			break;
	}
	return;
}

function float UpdateTeamAdvantage(int RedTeamScore, int BlueTeamScore)
{
	local int TotalScore;
	local float TeamAdvantage;

	TotalScore = (RedTeamScore + BlueTeamScore);
	if((TotalScore > 0))
	{
		TeamAdvantage = (float((RedTeamScore - BlueTeamScore)) / float(TotalScore));
	}
	else
	{
		TeamAdvantage = 0.0000000;
	}
	Debug(("TeamAdvantage" @ string(TeamAdvantage)));
	return TeamAdvantage;
}

function circleMove(int tickNum, float Radius)
{
	local float X, Y, Angle;

	Angle = ((360.0000000 / 1000.0000000) * float(tickNum));
	X = (Radius * Sin(((3.1400001 * Angle) / 180.0000000)));
	Y = (-Radius * Cos(((3.1400001 * Angle) / 180.0000000)));
	X = ((((35.0000000 + X) + float(GetMeStatusRound("MPStatusRound").GetRect().nX)) - float((GetMeStatusRound("MPStatusRound").GetRect().nWidth / 2))) + float((GetMeStatusRound("Texture20").GetRect().nWidth / 2)));
	Y = ((((35.0000000 + Y) + float(GetMeStatusRound("MPStatusRound").GetRect().nY)) - float((GetMeStatusRound("MPStatusRound").GetRect().nHeight / 2))) + float((GetMeStatusRound("Texture20").GetRect().nHeight / 2)));
	GetMeTexture("Texture20").MoveTo(int(X), int(Y));
	return;
}

function OnCallUCFunction(string func, string param)
{
	Debug(("-Func" @ func));
	Debug(("-param" @ param));
	switch(func)
	{
		case "tween":
			FuncTween(param);
		default:
			return;
	}
}

function FuncTween(string param)
{
	local int X, Y, Width, Height;
	local string Target;
	local Rect Rect;

	ParseInt(param, "x", X);
	ParseInt(param, "x", Y);
	ParseInt(param, "width", Width);
	ParseInt(param, "height", Height);
	ParseString(param, "target", Target);
	GetWindowHandle(Target).Move(X, Y);
	Debug(("와왕" @ GetWindowHandle(Target).GetWindowName()));  // EN?: Wawang
	if(((Width > 0) || (Height > 0)))
	{
		Rect = GetWindowHandle(Target).GetRect();
		if((Width <= 0))
		{
			Width = Rect.nWidth;
		}
		if((Height <= 0))
		{
			Height = Rect.nHeight;
		}
		GetWindowHandle(Target).SetWindowSize(Width, Height);
	}
	return;
}

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	local string mainKey;

	if(SdEditBox.IsFocused())
	{
		mainKey = Class'NWindow.InputAPI'.static.GetKeyString(nKey);
		if((mainKey == "ENTER"))
		{
			TestSliderCtrl.SetCurrentTick(int(SdEditBox.GetString()));
			if((int(SdEditBox.GetString()) > (TestSliderCtrl.GetTotalTickCount() - 1)))
			{
				SdEditBox.SetString(string((TestSliderCtrl.GetTotalTickCount() - 1)));
			}
		}
	}
	if((GetMeEditBox("blueEditBox").IsFocused() || GetMeEditBox("redEditBox").IsFocused()))
	{
		teamBarOffset = ((UpdateTeamAdvantage(int(GetMeEditBox("blueEditBox").GetString()), int(GetMeEditBox("redEditBox").GetString())) / 2.0000000) * 200.0000000);
		GetMeTexture("LeftBLUE").SetWindowSize(int((float((200 / 2)) + teamBarOffset)), 32);
		GetMeTexture("RightRed").SetWindowSize(int((float((200 / 2)) - teamBarOffset)), 32);
		GetMeTexture("RightRed").MoveC(int((600.0000000 + teamBarOffset)), 540);
		GetMeTexture("CenterLight").MoveC(int((float((600 - 4)) + teamBarOffset)), 540);
		GetMeEffectViewportWnd("CenterLightEffectViewportWnd").MoveC(int((float((600 - 300)) + teamBarOffset)), 240);
		Debug(("teamBarOffset" @ string(teamBarOffset)));
	}
	return false;
}

function OnHide()
{
	return;
}

function StartShake(int nShakeSize, int nRepeatCount, int mSec, int TimeID)
{
	posX = Me.GetRect().nX;
	posY = Me.GetRect().nY;
	Dir = 1.0000000;
	shakeSize = float(nShakeSize);
	repeatCount = nRepeatCount;
	shakeTimeID = TimeID;
	currentCount = 0;
	Me.SetTimer(shakeTimeID, mSec);
	return;
}

function OnTimer(int TimerID)
{
	OnTimerForShake(TimerID);
	return;
}

function OnTimerForShake(int TimerID)
{
	if((TimerID == shakeTimeID))
	{
		if((repeatCount > currentCount))
		{
			Shake();
		}
		else
		{
			Me.KillTimer(shakeTimeID);
			Me.MoveC(posX, posY);
		}
		currentCount++;
	}
	return;
}

function Shake()
{
	local float X, Y, dampening;

	(Dir *= -1.0000000);
	dampening = ((float((repeatCount - currentCount)) / float(repeatCount)) * 10.0000000);
	X = float((posX + appRound(float(Rand(int(((shakeSize * Dir) * (dampening / 10.0000000))))))));
	Y = float((posY + appRound(float(Rand(int(((shakeSize * Dir) * (dampening / 10.0000000))))))));
	Me.MoveC(int(X), int(Y));
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}
