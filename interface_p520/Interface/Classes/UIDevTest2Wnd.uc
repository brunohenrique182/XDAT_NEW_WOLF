class UIDevTest2Wnd extends UICommonAPI;

var WindowHandle Me;
var WindowHandle NeedItem_RichlistWnd;
var RichListCtrlHandle DevRichListCtrl;
var UIControlNeedItemList NeedItemList;
var UIControlGroupButtonAssets UIControlGroupButtonAsset1;

function OnRegisterEvent()
{
	return;
}

function OnLoad()
{
	Initialize();
	Load();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("UIDevTest2Wnd");
	NeedItem_RichlistWnd = GetWindowHandle("UIDevTest2Wnd.NeedItem_RichlistWnd");
	DevRichListCtrl = GetRichListCtrlHandle("UIDevTest2Wnd.NeedItem_RichlistWnd.DevRichListCtrl");
	return;
}

function Load()
{
	NeedItemList = new Class'Interface.UIControlNeedItemList';
	NeedItemList.SetRichListControler(DevRichListCtrl);
	NeedItemList.DelegateOnUpdateItem = DelegateOnUpdateItem;
	NeedItemList.SetColumnCount(2);
	DevRichListCtrl.SetTooltipType("UIControlNeedItemList");
	GetWindowHandle("UIDevTest2Wnd.UIControlGroupButtonAsset1").SetScript("UIControlGroupButtonAssets");
	UIControlGroupButtonAsset1 = UIControlGroupButtonAssets(GetWindowHandle("UIDevTest2Wnd.UIControlGroupButtonAsset1").GetScript());
	UIControlGroupButtonAsset1._SetWindow("UIDevTest2Wnd.UIControlGroupButtonAsset1");
	UIControlGroupButtonAsset1._SetStartInfo("", "", "", true);
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setButtonText(0, "전체");  // EN?: ALL
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setButtonText(1, "1번");  // EN?: No.1
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setButtonText(2, "2번");  // EN?: Twice
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setButtonText(3, "3번");  // EN?: 3 times
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setButtonText(4, "4번");  // EN?: 4 times
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setButtonText(5, "5번");  // EN?: Number 5
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setButtonText(6, "6번");  // EN?: Number 6
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setButtonText(7, "7번");  // EN?: Number 7
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setButtonText(8, "8번");  // EN?: Number 8
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setButtonText(9, "9번");  // EN?: Number 9
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setButtonText(10, "10번");  // EN?: Number 10
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setButtonText(11, "11번");  // EN?: Number 11
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setButtonText(12, "12번");  // EN?: Number 12
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setShowButtonNum(13);
	UIControlGroupButtonAsset1._GetGroupButtonsInstance().DelegateOnClickButton = DelegateOnClickButton;
	UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setMultilineButtonCenterByAsset(100, 40, 7, 13, 2, 2);
	return;
}

function OnShow()
{
	NeedItemList.CleariObjects();
	NeedItemList.StartNeedItemList(4);
	NeedItemList.AddNeedItemClassID(57, INT64(100));
	NeedItemList.AddNeedItemClassID(57, INT64(1000));
	NeedItemList.AddNeedItemClassID(4, INT64(2));
	NeedItemList.AddNeedItemClassID(1, INT64(1));
	NeedItemList.SetBuyNum(INT64(1));
	return;
}

function DelegateOnClickButton(string parentWndName, string strName, int Index)
{
	Debug(("strName" @ parentWndName));
	Debug(("strName" @ strName));
	Debug(("index" @ string(Index)));
	return;
}

function OnClickButton(string strID)
{
	local Rect rectEmpty;

	Debug(("strID" @ strID));
	switch(strID)
	{
		case "test1":
			NeedItemList.ModifyNeedItemInfoByIndex(1, GetItemInfoByClassID(2), 2, 1);
			NeedItemList.ModifyNeedItemInfoByIndexUseSimpleObject(2, GetItemInfoByClassID(91927), 1000, 1);
			break;
		case "test2":
			UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setShowButtonNum(13);
			UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setMultilineButtonCenterByAsset(100, 40, 7, 13, 2, 2);
			break;
		case "test3":
			UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setShowButtonNum(6);
			UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setMultilineButtonCenterByAsset(100, 40, 7, 6, 2, 2);
			break;
		case "test4":
			UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setShowButtonNum(10);
			UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setMultilineButtonCenterByAsset(100, 40, 5, 10, 4, 2);
			break;
		case "test5":
			rectEmpty.nX = GetWindowHandle("UIDevTest2Wnd.UIControlGroupButtonAsset1").GetRect().nX;
			rectEmpty.nY = GetWindowHandle("UIDevTest2Wnd.UIControlGroupButtonAsset1").GetRect().nY;
			rectEmpty.nWidth = GetWindowHandle("UIDevTest2Wnd.UIControlGroupButtonAsset1").GetRect().nWidth;
			rectEmpty.nHeight = GetWindowHandle("UIDevTest2Wnd.UIControlGroupButtonAsset1").GetRect().nHeight;
			UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setShowButtonNum(3);
			UIControlGroupButtonAsset1._GetGroupButtonsInstance()._setMultilineButtonCenterByRect(rectEmpty, 200, 40, 7, 3, 5, 5);
			break;
		case "test6":
			break;
		case "test7":
			break;
		case "test8":
			break;
		case "test9":
			break;
		case "test10":
			break;
		default:
			break;
	}
	return;
}

function DelegateOnUpdateItem()
{
	if(!Me.IsShowWindow())
	{
		return;
	}
	Debug("DelegateOnUpdateItem");
	return;
}
