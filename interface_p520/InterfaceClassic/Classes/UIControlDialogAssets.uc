class UIControlDialogAssets extends UICommonAPI;

const HBuyItemWnd = 50;
const HInputWnd = 40;

enum ASSET_HEADER_TYPE
{
	HEADERDECO,                     // 0
	SIMPLEHEADER                    // 1
};

var string m_Windowname;
var WindowHandle Me;
var int nDialogID;
var string m_WindowNameText;
var WindowHandle textWnd;
var TextBoxHandle DescriptionTextBox;
var HtmlHandle DescriptionHtmlCtrl;
var string m_WindowNameSelect;
var WindowHandle selectWnd;
var UIControlNeedItemList selectItemScript;
var RichListCtrlHandle selectItemRichListCtrl;
var HtmlHandle SelectItemTitle_HtmlCtrl;
var string m_WindowNameBuy;
var WindowHandle buyWnd;
var UIControlNeedItemList buyItemScript;
var RichListCtrlHandle BuyItemRichListCtrl;
var string m_WindowNameNeedItem;
var WindowHandle needItemWnd;
var TextBoxHandle NeedItemTitle_Text;
var UIControlNeedItemList needItemScript;
var RichListCtrlHandle NeedItemRichListCtrl;
var TextureHandle NeedItemHelpTex;
var string m_WindowNameNeedInput;
var WindowHandle inputItemWnd;
var UIControlNumberInput inputItemScript;
var string m_WindowNameBuyWndItemWindow;
var WindowHandle BuyWndItemWindow;
var ItemWindowHandle ItemsItemWindow;
var WindowHandle disableWnd;
var ButtonHandle OKButton;
var ButtonHandle CancleButton;
var TextureHandle m_BgTexture;
var TextureHandle Exclamation_Tex;
var TextureHandle ShortcutIcon_Enter;
var TextureHandle ShortcutIcon_ESC;
var bool _initSelectItem;
var bool _initBuyItem;
var bool _initNeedItem;
var bool _initInputColtroled;
var bool bDisableShortcut;
var bool bNotUseNeedItemCount;
var INT64 maxNum;
var bool bUseHtml;
var ASSET_HEADER_TYPE currentHeaderType;
//var delegate<DelegateOnClickBuy> __DelegateOnClickBuy__Delegate;
//var delegate<DelegateOnCancel> __DelegateOnCancel__Delegate;
//var delegate<delegateOnItemCountEdited> __delegateOnItemCountEdited__Delegate;

function _SetHeaderType(ASSET_HEADER_TYPE headerTYpe)
{
	switch(headerTYpe)
	{
		case HEADERDECO:
			GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SimpleHeader")).HideWindow();
			GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HeaderDecoWnd")).ShowWindow();
			break;
		case SIMPLEHEADER:
			GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SimpleHeader")).ShowWindow();
			GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HeaderDecoWnd")).HideWindow();
			break;
		default:
			break;
	}
	currentHeaderType = headerTYpe;
	return;
}

delegate DelegateOnClickBuy()
{
	return;
}

delegate DelegateOnCancel()
{
	return;
}

delegate delegateOnItemCountEdited(INT64 changedNum)
{
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "OkButton":
			DelegateOnClickBuy();
			break;
		case "CancleButton":
			DelegateOnCancel();
			break;
		default:
			break;
	}
	return;
}

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	if((int(nKey) == 27))
	{
		if((bDisableShortcut == true))
		{
			return m_hOwnerWnd.GetParentWindowHandle().GetScript().OnKeyUp(a_WindowHandle, nKey);
		}
		DelegateOnCancel();
		return true;
	}
	return false;
}

event bool OnKeyDown(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	if((int(nKey) == 13))
	{
		if((bDisableShortcut == true))
		{
			return m_hOwnerWnd.GetParentWindowHandle().GetScript().OnKeyDown(a_WindowHandle, nKey);
		}
		if((GetButtonHandle((m_Windowname $ ".OkButton")).IsEnableWindow() == false))
		{
			return true;
		}
		DelegateOnClickBuy();
		return true;
	}
	return false;
}

event OnSetFocus(WindowHandle a_WindowHandle, bool bFocused)
{
	if((bDisableShortcut == true))
	{
		return;
	}
	if(bFocused)
	{
		ShortcutIcon_Enter.ShowWindow();
		ShortcutIcon_ESC.ShowWindow();
	}
	else
	{
		ShortcutIcon_Enter.HideWindow();
		ShortcutIcon_ESC.HideWindow();
	}
	m_hOwnerWnd.GetParentWindowHandle().GetScript().OnSetFocus(a_WindowHandle, bFocused);
	return;
}

function bool _ChkFocus(bool bFocused)
{
	if((bFocused == false))
	{
		return false;
	}
	if((m_hOwnerWnd.IsShowWindow() == false))
	{
		return false;
	}
	m_hOwnerWnd.SetFocus();
	return true;
}

event OnLoad()
{
	ShortcutIcon_Enter = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ShortcutIcon_Enter"));
	ShortcutIcon_Enter.HideWindow();
	ShortcutIcon_ESC = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ShortcutIcon_ESC"));
	ShortcutIcon_ESC.HideWindow();
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SimpleHeader")).HideWindow();
	return;
}

event OnHide()
{
	if((disableWnd.m_pTargetWnd != none))
	{
		disableWnd.HideWindow();
	}
	return;
}

event OnClickListCtrlRecord(string ListCtrlID)
{
	local INT64 ItemAmount;
	local int Index, ClassID, ItemNum;

	if((ListCtrlID != "SelectItemRichListCtrl"))
	{
		return;
	}
	Index = selectItemRichListCtrl.GetSelectedIndex();
	selectItemScript.GetItemClassID(Index, ClassID);
	selectItemScript.GetItemNeedAmount(Index, ItemAmount);
	_SetUseSelectItemWindow(false);
	SetUseNeedItem(true);
	StartNeedItemList(1);
	needItemScript.AddNeedItemClassID(ClassID, ItemAmount);
	needItemScript.SetBuyNum(INT64(1));
	SetWindowHeight();
	return;
}

event OnDBClickListCtrlRecord(string ListCtrlID)
{
	OnClickListCtrlRecord(ListCtrlID);
	return;
}

static function UIControlDialogAssets InitScript(WindowHandle wnd)
{
	local UIControlDialogAssets scr;

	wnd.SetScript("UIControlDialogAssets");
	scr = UIControlDialogAssets(wnd.GetScript());
	scr.InitWnd(wnd);
	return scr;
}

function InitWnd(WindowHandle wnd)
{
	m_hOwnerWnd = wnd;
	SetWindow(m_hOwnerWnd.m_WindowNameWithFullPath);
	UICommonAPI(wnd.GetTopFrameWnd().GetScript())._AddUIControlDialog(self);
	return;
}

function SetWindow(string WindowName)
{
	m_Windowname = WindowName;
	Me = GetWindowHandle(m_Windowname);
	m_WindowNameText = (WindowName $ ".TextWnd");
	DescriptionTextBox = GetTextBoxHandle((m_WindowNameText $ ".DescriptionTextBox"));
	DescriptionHtmlCtrl = GetHtmlHandle((m_WindowNameText $ ".DescriptionHtmlCtrl"));
	textWnd = GetWindowHandle(m_WindowNameText);
	textWnd.ShowWindow();
	m_WindowNameSelect = (WindowName $ ".SelectItemWnd");
	selectItemRichListCtrl = GetRichListCtrlHandle((m_WindowNameSelect $ ".SelectItemRichListCtrl"));
	selectWnd = GetWindowHandle(m_WindowNameSelect);
	selectWnd.HideWindow();
	SelectItemTitle_HtmlCtrl = GetHtmlHandle((m_WindowNameSelect $ ".SelectItemTitle_HtmlCtrl"));
	m_WindowNameBuy = (WindowName $ ".BuyWnd");
	BuyItemRichListCtrl = GetRichListCtrlHandle((m_WindowNameBuy $ ".BuyItemRichListCtrl"));
	buyWnd = GetWindowHandle(m_WindowNameBuy);
	m_WindowNameNeedItem = (WindowName $ ".NeedItemWnd");
	NeedItemRichListCtrl = GetRichListCtrlHandle((m_WindowNameNeedItem $ ".NeedItemRichListCtrl"));
	needItemWnd = GetWindowHandle(m_WindowNameNeedItem);
	NeedItemTitle_Text = GetTextBoxHandle((m_WindowNameNeedItem $ ".NeedItemTitle_text"));
	NeedItemHelpTex = GetTextureHandle((m_WindowNameNeedItem $ ".NeedItemHelpTex"));
	m_WindowNameNeedInput = (WindowName $ ".inputItemWnd");
	inputItemWnd = GetWindowHandle(m_WindowNameNeedInput);
	m_WindowNameBuyWndItemWindow = (WindowName $ ".BuyWndItemWindow");
	BuyWndItemWindow = GetWindowHandle(m_WindowNameBuyWndItemWindow);
	ItemsItemWindow = GetItemWindowHandle((m_WindowNameBuyWndItemWindow $ ".ItemsItemWindow"));
	OKButton = GetButtonHandle((m_Windowname $ ".OkButton"));
	CancleButton = GetButtonHandle((m_Windowname $ ".CancleButton"));
	m_BgTexture = GetTextureHandle((m_WindowNameText $ ".bgTexture_Tex"));
	Exclamation_Tex = GetTextureHandle((m_Windowname $ ".Exclamation_Tex"));
	HideDesriptionBGDeco();
	SetUseBuyItem(false);
	SetUseNeedItem(false);
	SetUseNumberInput(false);
	_SetUseItemWindow(false);
	return;
}

function SetNeedItemTitle_text(string titleText)
{
	NeedItemTitle_Text.SetText(titleText);
	SetSelectTitle_Html();
	return;
}

function SetSelectTitle_Html()
{
	local string titleText, htmlStr, Desc;
	local int nWidth, nHeight;

	titleText = NeedItemTitle_Text.GetText();
	Desc = MakeFullSystemMsg(GetSystemMessage(14658), titleText);
	SelectItemTitle_HtmlCtrl.GetWindowSize(nWidth, nHeight);
	htmlStr = HtmlAddTableTD(Desc, "center", "center", nWidth, 0, "", true);
	HtmlSetTableTR(htmlStr);
	htmlSetTable(htmlStr, 0, nWidth, 0, "", 0, 0);
	SelectItemTitle_HtmlCtrl.LoadHtmlFromString(htmlSetHtmlStart(htmlStr));
	return;
}

function SetNeedItemTitle_TextColor(Color tColor)
{
	NeedItemTitle_Text.SetTextColor(tColor);
	return;
}

function InitSelectItem()
{
	if(_initSelectItem)
	{
		return;
	}
	_initSelectItem = true;
	selectWnd.SetScript("UIControlNeedItemList");
	selectItemScript = UIControlNeedItemList(GetWindowHandle(m_WindowNameSelect).GetScript());
	selectItemScript.SetRichListControler(selectItemRichListCtrl);
	selectItemScript.SetColumnCount(1);
	selectItemScript._SetSelectable(true);
	selectItemScript.SetBuyNum(INT64(1));
	return;
}

function InitBuyItem()
{
	if(_initBuyItem)
	{
		return;
	}
	_initBuyItem = true;
	buyWnd.SetScript("UIControlNeedItemList");
	buyItemScript = UIControlNeedItemList(GetWindowHandle(m_WindowNameBuy).GetScript());
	buyItemScript.SetRichListControler(BuyItemRichListCtrl);
	buyItemScript.SetColumnCount(1);
	buyItemScript.SetHideMyNum(true);
	buyItemScript.StartNeedItemList(1);
	return;
}

function InitNeedItem()
{
	if(_initNeedItem)
	{
		return;
	}
	_initNeedItem = true;
	needItemScript = Class'InterfaceClassic.UIControlNeedItemList'.static.InitScript(GetWindowHandle(m_WindowNameNeedItem));
	needItemScript.DelegateOnUpdateItem = OnChangeNeedItem;
	return;
}

function InitInputControl()
{
	if(_initInputColtroled)
	{
		return;
	}
	_initInputColtroled = true;
	inputItemScript = Class'InterfaceClassic.UIControlNumberInput'.static.InitScript(inputItemWnd);
	inputItemScript.DelegateGetCountCanBuy = MaxNumCanBuy;
	inputItemScript.DelegateOnClickBuy = OnClickBuy;
	inputItemScript.delegateOnItemCountEdited = OnItemCountChanged;
	inputItemScript.Buy_Btn = GetButtonHandle((m_Windowname $ ".OkButton"));
	return;
}

function _SetFocus()
{
	m_hOwnerWnd.SetFocus();
	return;
}

function SetUseBuyItem(bool bUse)
{
	if(bUse)
	{
		buyWnd.ShowWindow();
		InitBuyItem();
	}
	else
	{
		buyWnd.HideWindow();
	}
	return;
}

function SetUseNeedItem(bool bUse)
{
	if(bUse)
	{
		needItemWnd.ShowWindow();
		InitNeedItem();
	}
	else
	{
		GetButtonHandle((m_Windowname $ ".OkButton")).EnableWindow();
		needItemWnd.HideWindow();
		NeedItemHelpTex.HideWindow();
	}
	return;
}

function ShowNeedItemHelpTexture(bool isShow)
{
	if(isShow)
	{
		NeedItemHelpTex.ShowWindow();
	}
	else
	{
		NeedItemHelpTex.HideWindow();
	}
	return;
}

function SetNeedItemHelpTooltip(CustomTooltip toolTipInfo)
{
	NeedItemHelpTex.SetTooltipCustomType(toolTipInfo);
	return;
}

function SetUseNumberInput(bool bUse)
{
	if(bUse)
	{
		inputItemWnd.ShowWindow();
		InitInputControl();
	}
	else
	{
		inputItemWnd.HideWindow();
	}
	return;
}

function _SetUseItemWindow(bool bUse)
{
	if(bUse)
	{
		BuyWndItemWindow.ShowWindow();
	}
	else
	{
		BuyWndItemWindow.HideWindow();
	}
	return;
}

function SetDisableWindow(WindowHandle win)
{
	disableWnd = win;
	disableWnd.HideWindow();
	return;
}

function SetDialogDescHtml(string Desc, optional int nOkButtonSystemString, optional int nCancelButtonSystemString, optional Color TextColor)
{
	SetDesc(Desc, nOkButtonSystemString, nCancelButtonSystemString, true, TextColor);
	return;
}

function SetDialogDesc(string Desc, optional int nOkButtonSystemString, optional int nCancelButtonSystemString, optional Color TextColor, optional int HeightOffset)
{
	SetDesc(Desc, nOkButtonSystemString, nCancelButtonSystemString, false, TextColor, HeightOffset);
	return;
}

function SetDesc(string Desc, optional int nOkButtonSystemString, optional int nCancelButtonSystemString, optional bool isUsehtml, optional Color TextColor, optional int HeightOffset)
{
	if(((((int(TextColor.R) == 0) && (int(TextColor.G) == 0)) && (int(TextColor.B) == 0)) && (int(TextColor.A) == 0)))
	{
	}
	else
	{
		DescriptionTextBox.SetTextColor(TextColor);
	}
	if((nOkButtonSystemString > 0))
	{
		OKButton.SetButtonName(nOkButtonSystemString);
	}
	if((nCancelButtonSystemString > 0))
	{
		CancleButton.SetButtonName(nCancelButtonSystemString);
	}
	bUseHtml = isUsehtml;
	if(bUseHtml)
	{
		DescriptionTextBox.HideWindow();
		DescriptionHtmlCtrl.ShowWindow();
		LoadHtmlTable(Desc);
	}
	else
	{
		SetTextBoxHeight(Desc);
		DescriptionTextBox.ShowWindow();
		DescriptionTextBox.SetText(Desc);
		SetTextBoxHeight(Desc, HeightOffset);
		DescriptionHtmlCtrl.HideWindow();
	}
	return;
}

function SetTextBoxHeight(string Desc, optional int HeightOffset)
{
	local int Height;

	Height = Class'InterfaceClassic.L2Util'.static.Inst()._GetTextBoxHeight(DescriptionTextBox, Desc);
	if((HeightOffset > 0))
	{
		Height = (Height + HeightOffset);
	}
	textWnd.SetWindowSizeRel(1.0000000, 0.0000000, -30, Height);
	return;
}

function LoadHtmlTable(string Desc)
{
	local string htmlStr;
	local int nWidth, nHeight;

	DescriptionHtmlCtrl.GetWindowSize(nWidth, nHeight);
	htmlStr = HtmlAddTableTD(Desc, "center", "center", nWidth, 0, "", true);
	HtmlSetTableTR(htmlStr);
	htmlSetTable(htmlStr, 0, nWidth, 0, "", 0, 0);
	DescriptionHtmlCtrl.LoadHtmlFromString(htmlSetHtmlStart(htmlStr));
	return;
}

function _SetUseSelectItemWindow(bool bUse)
{
	if(bUse)
	{
		InitSelectItem();
		selectWnd.ShowWindow();
		DescriptionTextBox.SetAlpha(0);
		DescriptionHtmlCtrl.SetAlpha(0);
		textWnd.SetWindowSizeRel(1.0000000, 0.0000000, -30, 0);
		GetButtonHandle((m_Windowname $ ".OkButton")).HideWindow();
		GetButtonHandle((m_Windowname $ ".CancleButton")).SetAnchor((m_Windowname $ ".inputItemWnd"), "BottomCenter", "TopCenter", 0, 20);
		ShortcutIcon_ESC.SetAnchor((m_Windowname $ ".inputItemWnd"), "BottomCenter", "TopLeft", 26, 16);
		ShortcutIcon_Enter.SetAlpha(0);
		SetSelectTitle_Html();
	}
	else
	{
		selectWnd.HideWindow();
		if(bUseHtml)
		{
			DescriptionHtmlCtrl.SetAlpha(255);
		}
		else
		{
			DescriptionTextBox.SetAlpha(255);
		}
		ShortcutIcon_Enter.SetAlpha(255);
		GetButtonHandle((m_Windowname $ ".CancleButton")).SetAnchor((m_Windowname $ ".inputItemWnd"), "BottomCenter", "TopLeft", 5, 20);
		ShortcutIcon_ESC.SetAnchor((m_Windowname $ ".inputItemWnd"), "BottomCenter", "TopLeft", 86, 16);
		GetButtonHandle((m_Windowname $ ".OkButton")).ShowWindow();
	}
	return;
}

function _AddSelectItemClassID(int ClassID, INT64 Num)
{
	selectItemScript.AddNeedItemClassID(ClassID, Num);
	return;
}

function _StartSelectItemList(int rowNum)
{
	selectItemScript.StartNeedItemList(rowNum);
	return;
}

function array<int> _GetNeedItemClassIDs()
{
	return needItemScript._GetNeedItemClassIDs();
}

function array<INT64> _GetNeedAmounts()
{
	return needItemScript._GetNeedAmounts();
}

function SetItemNum(int Num)
{
	Num = Max(1, Num);
	if((buyItemScript != none))
	{
		buyItemScript.SetBuyNum(INT64(Num));
	}
	if((needItemScript != none))
	{
		if(bNotUseNeedItemCount)
		{
			needItemScript.SetBuyNum(INT64(1));
		}
		else
		{
			needItemScript.SetBuyNum(INT64(Num));
		}
	}
	if((inputItemScript != none))
	{
		inputItemScript.SetCount(INT64(1));
	}
	return;
}

function _SetNeedItemCountAlawaysOne()
{
	bNotUseNeedItemCount = true;
	needItemScript.SetBuyNum(INT64(1));
	return;
}

function _SetNeedItemCount()
{
	bNotUseNeedItemCount = false;
	needItemScript.SetBuyNum(inputItemScript.GetCount());
	return;
}

function StartNeedItemList(int rowNum)
{
	needItemScript.StartNeedItemList(rowNum);
	return;
}

function AddNeedItemClassID(int ClassID, INT64 Num)
{
	needItemScript.AddNeedItemClassID(ClassID, Num);
	return;
}

function AddNeedPoint(string Name, string TextureName, INT64 needAmount, INT64 currentAmount)
{
	needItemScript.AddNeedPoint(Name, TextureName, needAmount, currentAmount);
	return;
}

function _AddItemWindowClassID(int ClassID, INT64 Num)
{
	local ItemInfo iInfo;

	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(ClassID), iInfo);
	iInfo.bShowCount = IsStackableItem(iInfo.ConsumeType);
	if((Num > INT64(1)))
	{
		iInfo.bShowCount = true;
	}
	ItemsItemWindow.AddItem(iInfo);
	return;
}

function SetBuyItemClassID(int ClassID, int Num)
{
	buyItemScript.AddNeedItemClassID(ClassID, INT64(Num));
	return;
}

function SetBuyItemInfo(ItemInfo iInfo, INT64 needAmount, INT64 currAmount)
{
	buyItemScript.AddNeeItemInfo(iInfo, needAmount, currAmount);
	return;
}

function _SetStartBuyItemList(int Num)
{
	buyItemScript.StartNeedItemList(Num);
	return;
}

function ShowDesriptionBGDeco()
{
	m_BgTexture.ShowWindow();
	return;
}

function HideDesriptionBGDeco()
{
	m_BgTexture.HideWindow();
	return;
}

function _ShowDescriptonIcon()
{
	Exclamation_Tex.ShowWindow();
	return;
}

function _HideDescriptonIcon()
{
	Exclamation_Tex.HideWindow();
	return;
}

function SetDescriptonIconTexture(string TextureName)
{
	Exclamation_Tex.SetTexture(TextureName);
	return;
}

function bool IsShowDecoBG()
{
	return m_BgTexture.IsShowWindow();
}

function _SetDisableShortcut(bool bUse)
{
	bDisableShortcut = bUse;
	return;
}

function SetDialogID(int nDialogID_NUM)
{
	nDialogID = nDialogID_NUM;
	return;
}

function int GetDialogID()
{
	return nDialogID;
}

function Show()
{
	if((disableWnd.m_pTargetWnd != none))
	{
		disableWnd.ShowWindow();
		disableWnd.SetFocus();
	}
	Me.ShowWindow();
	Me.SetFocus();
	SetWindowHeight();
	return;
}

function Hide()
{
	if((buyItemScript != none))
	{
		buyItemScript.CleariObjects();
	}
	if((needItemScript != none))
	{
		needItemScript.CleariObjects();
	}
	Me.HideWindow();
	if((disableWnd.m_pTargetWnd != none))
	{
		disableWnd.HideWindow();
	}
	return;
}

function _SetItemInputMax(INT64 Max)
{
	maxNum = Max;
	return;
}

function _DelItemInputmax()
{
	maxNum = INT64(-1);
	return;
}

function INT64 MaxNumCanBuy()
{
	if((maxNum > INT64(0)))
	{
		return maxNum;
	}
	if(!needItemWnd.IsShowWindow())
	{
		return INT64(99999);
	}
	return needItemScript.GetMaxNumCanBuy();
}

function OnClickBuy()
{
	DelegateOnClickBuy();
	return;
}

function OnItemCountChanged(INT64 ItemCount)
{
	delegateOnItemCountEdited(ItemCount);
	ItemCount = MAX64(INT64(1), ItemCount);
	buyItemScript.SetBuyNum(ItemCount);
	if(bNotUseNeedItemCount)
	{
		needItemScript.SetBuyNum(INT64(1));
	}
	else
	{
		needItemScript.SetBuyNum(ItemCount);
	}
	delegateOnItemCountEdited(ItemCount);
	return;
}

function OnChangeNeedItem()
{
	if(inputItemWnd.IsShowWindow())
	{
		inputItemScript.SetControlerBtns();
	}
	else if((MaxNumCanBuy() > INT64(0)))
	{
		if(((inputItemScript != none) && (inputItemScript.GetCount() == INT64(0))))
		{
			inputItemScript.SetCount(INT64(1));
		}
		GetButtonHandle((m_Windowname $ ".OkButton")).EnableWindow();
	}
	else
	{
		GetButtonHandle((m_Windowname $ ".OkButton")).DisableWindow();
	}
	return;
}

function SetDescriptionTextSize()
{
	local int nWidth, nHeight;

	if((selectWnd.IsShowWindow() == true))
	{
		textWnd.SetWindowSizeRel(1.0000000, 0.0000000, -30, 0);
		return;
	}
	if(bUseHtml)
	{
		nHeight = DescriptionHtmlCtrl.GetFrameMaxHeight();
		DescriptionHtmlCtrl.SetWindowSizeRel(1.0000000, 0.0000000, 0, nHeight);
	}
	else
	{
		DescriptionTextBox.GetWindowSize(nWidth, nHeight);
	}
	textWnd.SetWindowSizeRel(1.0000000, 0.0000000, -30, nHeight);
	if((int(currentHeaderType) == 0))
	{
		textWnd.MoveC(15, 30);
	}
	else if((int(currentHeaderType) == 1))
	{
		textWnd.MoveC(15, 22);
	}
	return;
}

function SetItemWindowCol()
{
	local Rect rectWnd;

	rectWnd = BuyWndItemWindow.GetRect();
	ItemsItemWindow.SetCol(((rectWnd.nWidth / 32) + 4));
	return;
}

function SetWindowHeight()
{
	local Rect rectWnd, rectMyWnd;

	rectWnd = textWnd.GetRect();
	SetDescriptionTextSize();
	if((selectWnd.IsShowWindow() == true))
	{
		selectWnd.SetWindowSizeRel(1.0000000, 0.0000000, -30, ((selectItemScript.GetRowNum() * 40) + 33));
	}
	else
	{
		selectWnd.SetWindowSizeRel(1.0000000, 0.0000000, -30, 15);
	}
	if(buyWnd.IsShowWindow())
	{
		buyWnd.SetWindowSizeRel(1.0000000, 0.0000000, -30, 46);
	}
	else
	{
		buyWnd.SetWindowSizeRel(1.0000000, 0.0000000, -30, 0);
	}
	if(BuyWndItemWindow.IsShowWindow())
	{
		BuyWndItemWindow.SetWindowSizeRel(1.0000000, 0.0000000, -30, 15);
		SetItemWindowCol();
	}
	else
	{
		BuyWndItemWindow.SetWindowSizeRel(1.0000000, 0.0000000, -30, 0);
	}
	if(needItemWnd.IsShowWindow())
	{
		needItemWnd.SetWindowSizeRel(1.0000000, 0.0000000, -30, ((needItemScript.GetRowNum() * 40) + 29));
	}
	else
	{
		needItemWnd.SetWindowSizeRel(1.0000000, 0.0000000, -30, 0);
	}
	if(inputItemWnd.IsShowWindow())
	{
		inputItemWnd.SetWindowSizeRel(1.0000000, 0.0000000, -30, 58);
	}
	else
	{
		inputItemWnd.SetWindowSizeRel(1.0000000, 0.0000000, -30, 0);
	}
	rectWnd = OKButton.GetRect();
	rectMyWnd = Me.GetRect();
	Me.SetWindowSize(rectMyWnd.nWidth, (((rectWnd.nY - rectMyWnd.nY) + rectWnd.nHeight) + 13));
	return;
}
