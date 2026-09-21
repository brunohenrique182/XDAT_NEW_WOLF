class DialogBox extends UICommonAPI;

const INPUT_DEFAULT_MAXLENGTH = 64;
const DEFAULTWIDTHWITHOPTS = 438;
const DefaultWidth = 368;
const DEFAULTHEIGHT = 124;
const GABINPUT = 30;
const GABPROGRESS = 10;
const GABSIZEY = 93;
const NUMPADW = 160;
const NUMPADH = 160;
const OPTIONBTNH = 207;

var int input_numberpad_maxLength;
var WindowHandle m_dialogHandle;
var WindowHandle m_dialogBody;
var WindowHandle m_WeightPad;
var WindowHandle m_WorldExchangePad;
var WindowHandle m_NumberPad;
var ButtonHandle m_okHandle;
var ButtonHandle m_cancelHandle;
var ButtonHandle m_centerHandle;
var TextureHandle m_ShortcutIcon_OK;
var TextureHandle m_ShortcutIcon_Cancel;
var TextureHandle m_ShortcutIcon_Center;
var UIControlTextInput uicontrolTextInputScr;
var TextBoxHandle m_textHandle;
var TextureHandle m_exclamationImage;
var HtmlHandle m_HtmlViewer;
var ProgressCtrlHandle m_hDialogBoxDialogProgress;
var TextureHandle m_BGTex;
var ButtonHandle m_shadowTexture;
var ButtonHandle m_Questionmark_Tex;
var WindowHandle m_HeaderDecoWnd;
var WindowHandle m_DialogBtns;
var UIScript.DialogDefaultAction m_defaultAction;
var UIScript.DialogEnterAction m_enterAction;
var UIScript.EDialogType m_type;
var WindowHandle m_TargetWindowHandle;
var string m_strTargetScript;
var string m_strEditMessage;
var int m_id;
var INT64 m_paramInt;
var int m_reservedInt;
var INT64 m_reservedInt2;
var int m_reservedInt3;
var ItemID m_reservedItemID;
var ItemInfo m_reservedItemInfo;
var string m_reservedString;
var int m_editMaxLength;
var int m_editMaxLength_prev;
var int buttonWidth_prev;
var int buttonHeight_prev;
var INT64 NumberPad_Value;
var bool m_bGlobalIME;
var Rect defaultBodyRect;
var int tryCancelDialogID;
var int saveCancelDialogID;
var INT64 inputLimit;
//var delegate<DelegateOnOK> __DelegateOnOK__Delegate;
//var delegate<DelegateOnCancel> __DelegateOnCancel__Delegate;
//var delegate<DelegateOnHide> __DelegateOnHide__Delegate;

delegate DelegateOnOK()
{
	return;
}

delegate DelegateOnCancel()
{
	return;
}

delegate DelegateOnHide()
{
	return;
}

static function DialogBox Inst()
{
	return DialogBox(GetScript("DialogBox"));
}

function Initialize()
{
	m_strTargetScript = "";
	SetEditType("normal");
	m_paramInt = INT64(0);
	m_reservedInt = 0;
	m_reservedInt2 = INT64(0);
	m_editMaxLength = -1;
	SetDefaultAction(EDefaultNone);
	inputLimit = INT64(-1);
	uicontrolTextInputScr._SetLimitNum(INT64(-1));
	return;
}

function InitUIControlTextInput()
{
	uicontrolTextInputScr = Class'InterfaceClassic.UIControlTextInput'.static.InitScript(GetWindowHandle("DialogBox.DialogBody.DialogEditBox"));
	uicontrolTextInputScr.SetEdtiable(true);
	uicontrolTextInputScr.SetDefaultString("");
	uicontrolTextInputScr.DelegateESCKey = DelegateESCKey;
	uicontrolTextInputScr.DelegateOnCompleteEditBox = DelegateOnCompleteEditBox;
	return;
}

event OnLoad()
{
	SetInputNumberpadMaxLenght(15);
	m_dialogHandle = GetWindowHandle("DialogBox");
	m_dialogBody = GetWindowHandle("DialogBox.DialogBody");
	m_okHandle = GetButtonHandle("DialogBox.DialogBtns.OKButton");
	m_cancelHandle = GetButtonHandle("DialogBox.DialogBtns.CancelButton");
	m_centerHandle = GetButtonHandle("DialogBox.DialogBtns.CenterOKButton");
	m_WeightPad = GetWindowHandle("DialogBox.WeightPad");
	m_HeaderDecoWnd = GetWindowHandle("DialogBox.HeaderDecoWnd");
	m_DialogBtns = GetWindowHandle("DialogBox.DialogBtns");
	m_BGTex = GetTextureHandle("DialogBox.BGTex");
	m_shadowTexture = GetButtonHandle("DialogBox.shadowTexture");
	m_Questionmark_Tex = GetButtonHandle("DialogBox.HeaderDecoWnd.Questionmark_Tex");
	m_ShortcutIcon_OK = GetTextureHandle("DialogBox.DialogBtns.ShortcutIcon_Enter");
	m_ShortcutIcon_Cancel = GetTextureHandle("DialogBox.DialogBtns.ShortcutIcon_ESC");
	m_ShortcutIcon_Center = GetTextureHandle("DialogBox.DialogBtns.ShortcutIcon_EnterCenter");
	m_NumberPad = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".NumberPad"));
	m_WorldExchangePad = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".WorldExchangePad"));
	m_exclamationImage = GetTextureHandle("DialogBox.DialogBody.ExclamationImage");
	m_HtmlViewer = GetHtmlHandle("DialogBox.DialogBody.HtmlViewer");
	m_hDialogBoxDialogProgress = GetProgressCtrlHandle("DialogBox.DialogProgress");
	Initialize();
	_SetButtonName(1337, 1342);
	SetMessage("Message uninitialized");
	tryCancelDialogID = -1;
	if((buttonWidth_prev != 0))
	{
		m_okHandle.SetWindowSize(buttonWidth_prev, buttonHeight_prev);
		m_centerHandle.SetWindowSize(buttonWidth_prev, buttonHeight_prev);
		m_cancelHandle.SetWindowSize(buttonWidth_prev, buttonHeight_prev);
	}
	GetButtonHandle("DialogBox.WeightPad.optBtn0").SetNameText(MakeFullSystemMsg(GetSystemMessage(3408), "50%"));
	GetButtonHandle("DialogBox.WeightPad.optBtn1").SetNameText(MakeFullSystemMsg(GetSystemMessage(3408), "66.6%"));
	GetButtonHandle("DialogBox.WeightPad.optBtn2").SetNameText(MakeFullSystemMsg(GetSystemMessage(3408), "80%"));
	InitUIControlTextInput();
	return;
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "OKButton":
		case "CenterOKButton":
			HandleOK();
			break;
		case "CancelButton":
			HandleCancel();
			break;
		case "num0":
		case "num1":
		case "num2":
		case "num3":
		case "num4":
		case "num5":
		case "num6":
		case "num7":
		case "num8":
		case "num9":
		case "numAll":
		case "numBS":
		case "numC":
			HandleNumberClick(strID);
			break;
		case "optBtn0":
		case "optBtn1":
		case "optBtn2":
		case "optBtn3":
		case "optBtn4":
			HandleUserOptionBtn(strID);
			break;
		default:
			break;
	}
	return;
}

event OnHide()
{
	if((int(m_type) == 7))
	{
		m_hDialogBoxDialogProgress.Stop();
	}
	SetEditType("normal");
	SetEditMessage("");
	if((m_editMaxLength != -1))
	{
		m_editMaxLength = -1;
		uicontrolTextInputScr.SetMaxLength(m_editMaxLength_prev);
	}
	uicontrolTextInputScr.Clear();
	_SetButtonName(1337, 1342);
	SetInputNumberpadMaxLenght(15);
	DelegateOnHide();
	m_paramInt = INT64(0);
	return;
}

event OnEnterState(name a_CurrentStateName)
{
	if((tryCancelDialogID > -1))
	{
		HideDialog();
	}
	return;
}

event OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	if((uicontrolTextInputScr._IsShowWIndow() == false))
	{
		return;
	}
	if(((a_WindowHandle != none) && (uicontrolTextInputScr._IsFocused() == false)))
	{
		uicontrolTextInputScr.inputTextBox.SetFocus();
	}
	return;
}

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	switch(nKey)
	{
		case IK_Escape:
			if((int(m_type) == 7))
			{
				return false;
			}
			if(m_ShortcutIcon_Cancel.IsShowWindow())
			{
				HandleCancel();
				return true;
			}
		default:
			return false;
	}
}

event bool OnKeyDown(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	Debug("OnKeyDown");
	switch(nKey)
	{
		case IK_Enter:
			if((int(m_type) == 7))
			{
				return false;
			}
			if(!ChkIDEnterKey())
			{
				if((m_ShortcutIcon_OK.IsShowWindow() || m_ShortcutIcon_Center.IsShowWindow()))
				{
					HandleOK();
					return true;
				}
			}
		default:
			return false;
	}
}

event OnProgressTimeUp(string strID)
{
	if((strID == "DialogProgress"))
	{
		DoDefaultAction();
	}
	return;
}

event OnSetFocus(WindowHandle focusedWnd, bool bFocused)
{
	if((bFocused == true))
	{
		ShowShortCutIcons();
		SetDepthSort(bFocused);
	}
	else
	{
		m_ShortcutIcon_OK.HideWindow();
		m_ShortcutIcon_Cancel.HideWindow();
		m_ShortcutIcon_Center.HideWindow();
	}
	return;
}

function SetDialogCancelD(int targetCancelDialogID)
{
	saveCancelDialogID = targetCancelDialogID;
	return;
}

function _DialogShowHtml(UIScript.EDialogModalType modalType, UIScript.EDialogType Style, string Message, WindowHandle targetWnd)
{
	ChkHandleCancel();
	m_TargetWindowHandle = targetWnd;
	m_strTargetScript = targetWnd.m_WindowNameWithFullPath;
	ShowDialog(modalType, Style, Message, true);
	return;
}

function _DialogShowHtmlWithTarget(UIScript.EDialogModalType modalType, UIScript.EDialogType Style, string Message, string TargetName)
{
	ChkHandleCancel();
	m_TargetWindowHandle = none;
	m_strTargetScript = TargetName;
	ShowDialog(modalType, Style, Message, true);
	return;
}

function _DialogShow(UIScript.EDialogModalType modalType, UIScript.EDialogType Style, string Message, WindowHandle targetWnd)
{
	ChkHandleCancel();
	m_TargetWindowHandle = targetWnd;
	m_strTargetScript = targetWnd.m_WindowNameWithFullPath;
	ShowDialog(modalType, Style, Message);
	return;
}

function _DialogShowWithTarget(UIScript.EDialogModalType modalType, UIScript.EDialogType Style, string Message, string TargetName)
{
	ChkHandleCancel();
	m_TargetWindowHandle = none;
	m_strTargetScript = TargetName;
	ShowDialog(modalType, Style, Message);
	return;
}

function bool HasPreviousCancelProcess()
{
	return (tryCancelDialogID > -1);
}

function bool CheckCancelDialogID(int taregetDialogID)
{
	return ((tryCancelDialogID > -1) && (tryCancelDialogID == taregetDialogID));
}

function CenterToOwner(optional int OffsetX, optional int OffsetY)
{
	local Rect rectWnd;
	local int dialogW, dialogH;

	if((m_TargetWindowHandle.m_pTargetWnd == none))
	{
		return;
	}
	rectWnd = m_TargetWindowHandle.GetRect();
	m_dialogHandle.GetWindowSize(dialogW, dialogH);
	m_dialogHandle.ClearAnchor();
	m_dialogHandle.MoveTo(((rectWnd.nX + ((rectWnd.nWidth - dialogW) / 2)) + OffsetX), ((rectWnd.nY + ((rectWnd.nHeight - dialogH) / 2)) + OffsetY));
	return;
}

function _DialogMoveToCursor()
{
	local Rect rectWnd;
	local int X, Y, targetX, targetY;

	m_dialogHandle.ClearAnchor();
	GetClientCursorPos(X, Y);
	rectWnd = m_dialogHandle.GetRect();
	targetX = (X - (rectWnd.nWidth / 2));
	targetY = (Y - (rectWnd.nHeight / 2));
	m_dialogHandle.MoveTo(targetX, targetY);
	ChkToScreenInside();
	return;
}

function ChkToScreenInside()
{
	local Rect rectWnd;
	local int W, h, targetX, targetY;

	rectWnd = m_dialogHandle.GetRect();
	targetX = rectWnd.nX;
	targetY = rectWnd.nY;
	if((rectWnd.nX < 0))
	{
		targetX = 0;
	}
	if((rectWnd.nY < 10))
	{
		targetY = 10;
	}
	GetCurrentResolution(W, h);
	if(((rectWnd.nX + rectWnd.nWidth) > W))
	{
		targetX = (W - rectWnd.nWidth);
	}
	if(((rectWnd.nY + rectWnd.nHeight) > h))
	{
		targetY = (h - rectWnd.nHeight);
	}
	m_dialogHandle.MoveTo(targetX, targetY);
	return;
}

function MoveToOwner()
{
	AnchorToOwner();
	m_dialogHandle.ClearAnchor();
	ChkToScreenInside();
	return;
}

function AnchorToOwner(optional int OffsetX, optional int OffsetY)
{
	if((m_TargetWindowHandle.m_pTargetWnd == none))
	{
		return;
	}
	m_dialogHandle.SetAnchor(m_TargetWindowHandle.GetTopFrameWnd().GetWindowName(), "CenterCenter", "CenterCenter", OffsetX, OffsetY);
	return;
}

function AnchorToTarget(string targetPath, optional int OffsetX, optional int OffsetY)
{
	m_dialogHandle.SetAnchor(targetPath, "CenterCenter", "CenterCenter", OffsetX, OffsetY);
	return;
}

function bool _ChkFocus(WindowHandle m_Wnd, bool bFocused)
{
	if((bFocused == false))
	{
		return false;
	}
	if((m_dialogHandle.IsShowWindow() == false))
	{
		return false;
	}
	if((IsOwnerWindow(m_Wnd) == false))
	{
		return false;
	}
	m_dialogHandle.SetFocus();
	return true;
}

function bool _IsOwnerWindow(WindowHandle wnd)
{
	return IsOwnerWindow(wnd);
}

function bool IsOwnerWindow(WindowHandle wnd)
{
	return (m_TargetWindowHandle.GetTopFrameWnd() == wnd.GetTopFrameWnd());
}

function HideDialog()
{
	if((tryCancelDialogID > -1))
	{
		HandleCancel();
	}
	SetInputNumberpadMaxLenght(15);
	m_dialogHandle.HideWindow();
	Initialize();
	SetIconTexture("");
	m_exclamationImage.ShowWindow();
	return;
}

function SetDefaultAction(UIScript.DialogDefaultAction DefaultAction)
{
	m_defaultAction = DefaultAction;
	return;
}

function SetEnterAction(UIScript.DialogEnterAction enterAction)
{
	m_enterAction = enterAction;
	return;
}

function WindowHandle _GetTargetWnd()
{
	return m_TargetWindowHandle;
}

function string _GetTargetName()
{
	return m_TargetWindowHandle.GetWindowName();
}

function string GetTarget()
{
	return m_strTargetScript;
}

function string GetEditMessage()
{
	return m_strEditMessage;
}

function SetEditMessage(string strMsg)
{
	uicontrolTextInputScr.SetString(strMsg);
	return;
}

function int GetID()
{
	return m_id;
}

function setId(int Id)
{
	m_id = Id;
	return;
}

function SetEditType(string strType)
{
	uicontrolTextInputScr._SetEditType(strType);
	return;
}

function setParamInt64(INT64 param)
{
	m_paramInt = param;
	return;
}

function SetReservedInt(int Value)
{
	m_reservedInt = Value;
	return;
}

function SetReservedInt2(INT64 Value)
{
	m_reservedInt2 = Value;
	return;
}

function SetReservedInt3(int Value)
{
	m_reservedInt3 = Value;
	return;
}

function SetReservedItemID(ItemID Id)
{
	m_reservedItemID = Id;
	return;
}

function SetReservedItemInfo(ItemInfo Info)
{
	m_reservedItemInfo = Info;
	return;
}

function SetReservedString(string Str)
{
	m_reservedString = Str;
	return;
}

function string GetReservedString()
{
	return m_reservedString;
}

function INT64 GetReservedParamInt64()
{
	return m_paramInt;
}

function int GetReservedInt()
{
	return m_reservedInt;
}

function INT64 GetReservedInt2()
{
	return m_reservedInt2;
}

function int GetReservedInt3()
{
	return m_reservedInt3;
}

function ItemID GetReservedItemID()
{
	return m_reservedItemID;
}

function GetReservedItemInfo(out ItemInfo Info)
{
	Info = m_reservedItemInfo;
	return;
}

function SetEditBoxMaxLength(int MaxLength)
{
	if((MaxLength >= 0))
	{
		m_editMaxLength = MaxLength;
	}
	return;
}

function SetIconTexture(string texturePath)
{
	if((texturePath == ""))
	{
		m_exclamationImage.SetTexture("L2UI_ct1.Icon.ICON_DF_Exclamation");
		m_exclamationImage.ClearTooltip();
	}
	else
	{
		m_exclamationImage.SetTexture(texturePath);
	}
	return;
}

function SetIconCustomToolTip(CustomTooltip toolTipInfo)
{
	m_exclamationImage.SetTooltipType("text");
	m_exclamationImage.SetTooltipCustomType(toolTipInfo);
	return;
}

function HideAll()
{
	m_ShortcutIcon_OK.HideWindow();
	m_ShortcutIcon_Cancel.HideWindow();
	m_ShortcutIcon_Center.HideWindow();
	uicontrolTextInputScr._Hide();
	m_okHandle.HideWindow();
	m_cancelHandle.HideWindow();
	m_centerHandle.HideWindow();
	m_WeightPad.HideWindow();
	m_WorldExchangePad.HideWindow();
	m_NumberPad.HideWindow();
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("DialogBox.DialogProgress");
	SetIconTexture("");
	return;
}

function bool IsProgressBarWorking()
{
	return (tryCancelDialogID > -1);
}

function SetMessage(string strMessage, optional bool bUseHtml)
{
	SetDialogBodySize();
	if(bUseHtml)
	{
		m_HtmlViewer.ShowWindow();
		LoadHtmlTable(strMessage);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("DialogBox.DialogBody.DialogText", "");
		SetHtmlCtrlHeight();
	}
	else
	{
		m_HtmlViewer.HideWindow();
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("DialogBox.DialogBody.DialogText", strMessage);
		SetTextBoxHeight(strMessage);
	}
	return;
}

function LoadHtmlTable(string strMessage)
{
	local string htmlStr;
	local int nWidth, nHeight;

	m_dialogBody.GetWindowSize(nWidth, nHeight);
	htmlStr = HtmlAddTableTD(strMessage, "center", "center", (nWidth - 30), 0, "", true);
	HtmlSetTableTR(htmlStr);
	htmlSetTable(htmlStr, 0, (nWidth - 30), 0, "", 0, 0);
	m_HtmlViewer.LoadHtmlFromString(htmlSetHtmlStart(htmlStr));
	return;
}

function _SetButtonName(int indexOK, optional int indexCancel)
{
	m_okHandle.SetButtonName(indexOK);
	m_centerHandle.SetButtonName(indexOK);
	if((indexCancel != 0))
	{
		m_cancelHandle.SetButtonName(indexCancel);
	}
	return;
}

function SetButtonWidthSize(int indexOK, optional int indexCancel)
{
	m_okHandle.GetWindowSize(buttonWidth_prev, buttonHeight_prev);
	m_okHandle.SetWindowSize(indexOK, buttonHeight_prev);
	m_centerHandle.SetWindowSize(indexOK, buttonHeight_prev);
	if((indexCancel != 0))
	{
		m_cancelHandle.SetWindowSize(indexCancel, buttonHeight_prev);
	}
	return;
}

function _AllSelect()
{
	uicontrolTextInputScr.AllSelect();
	return;
}

function HandleOK()
{
	if(uicontrolTextInputScr._IsShowWIndow())
	{
		m_strEditMessage = uicontrolTextInputScr.GetString();
	}
	else
	{
		m_strEditMessage = "";
	}
	tryCancelDialogID = -1;
	m_dialogHandle.HideWindow();
	ExecuteEvent(1710, m_strTargetScript);
	DelegateOnOK();
	return;
}

function HandleCancel()
{
	m_dialogHandle.HideWindow();
	ExecuteEvent(1720);
	tryCancelDialogID = -1;
	DelegateOnCancel();
	return;
}

function SetInputNumberpadMaxLenght(int Len)
{
	input_numberpad_maxLength = Len;
	return;
}

function _inputLimit(INT64 limit)
{
	inputLimit = limit;
	uicontrolTextInputScr._SetLimitNum(limit);
	return;
}

function DelegateESCKey()
{
	HandleCancel();
	return;
}

function DelegateOnCompleteEditBox(string Text)
{
	HandleOK();
	return;
}

function ShowDialog(UIScript.EDialogModalType modalType, UIScript.EDialogType Style, string Message, optional bool bUseHtml)
{
	local UIEventManager.ELanguageType Language;
	local bool isModal;

	inputLimit = INT64(-1);
	uicontrolTextInputScr._SetLimitNum(INT64(-1));
	DelegateOnOK = None;
	DelegateOnCancel = None;
	if(IsHardCodingSystemMessage(Message))
	{
		bUseHtml = true;
	}
	if((saveCancelDialogID > -1))
	{
		tryCancelDialogID = saveCancelDialogID;
		saveCancelDialogID = -1;
	}
	m_dialogHandle.HideWindow();
	isModal = (int(modalType) == 0);
	m_dialogHandle.SetModal(isModal);
	Class'NWindow.UIAPI_WINDOW'.static.SetAlwaysOnTop(m_hOwnerWnd.m_WindowNameWithFullPath, isModal);
	m_dialogHandle.ShowWindow();
	DelegateOnHide = None;
	SetWindowStyle(Style);
	if(uicontrolTextInputScr._IsShowWIndow())
	{
		uicontrolTextInputScr.SetString("");
		uicontrolTextInputScr.inputTextBox.SetFocus();
		if((m_editMaxLength != -1))
		{
			m_editMaxLength_prev = uicontrolTextInputScr.inputTextBox.GetMaxLength();
			uicontrolTextInputScr.SetMaxLength(m_editMaxLength);
		}
		else
		{
			uicontrolTextInputScr.SetMaxLength(64);
		}
	}
	SetMessage(Message, bUseHtml);
	m_bGlobalIME = false;
	Language = GetLanguage();
	if(((int(Language) == 2) || (int(Language) == 3)))
	{
		m_bGlobalIME = true;
	}
	if(isModal)
	{
		MoveToOwner();
	}
	else
	{
		AnchorToOwner();
	}
	ShowShortCutIcons();
	SetWindowHeight(bUseHtml);
	m_dialogHandle.SetFocus();
	return;
}

function ShowShortCutIcons()
{
	if((int(m_type) == 7))
	{
		return;
	}
	if(m_okHandle.IsShowWindow())
	{
		m_ShortcutIcon_OK.ShowWindow();
	}
	if(m_cancelHandle.IsShowWindow())
	{
		m_ShortcutIcon_Cancel.ShowWindow();
	}
	if(m_centerHandle.IsShowWindow())
	{
		m_ShortcutIcon_Center.ShowWindow();
	}
	return;
}

function SetDepthSort(bool bFocused)
{
	if((bFocused == false))
	{
		return;
	}
	if((m_TargetWindowHandle.m_pTargetWnd == none))
	{
		return;
	}
	m_TargetWindowHandle.BringToFront();
	m_hOwnerWnd.BringToFront();
	return;
}

function bool IsHardCodingSystemMessage(string Message)
{
	local array<string> ArrayStr;
	local string targetString;
	local int i;

	Split(targetString, ",", ArrayStr);
	i = 0;
	while((i < ArrayStr.Length))
	{
		if((GetSystemMessage(int(ArrayStr[i])) == Message))
		{
			return true;
		}
		i++;
	}
	return false;
}

function SetWindowStyle(UIScript.EDialogType Style)
{
	HideAll();
	m_type = Style;
	uicontrolTextInputScr._SetUnderUnit(INT64(0));
	switch(Style)
	{
		case DialogType_OKCancel:
			m_okHandle.ShowWindow();
			m_cancelHandle.ShowWindow();
			SetQuestIconTexture("L2UI_NewTex.Windows.Asset_Questionmark");
			break;
		case DialogType_OK:
			m_centerHandle.ShowWindow();
			SetQuestIconTexture("L2UI_NewTex.Windows.Asset_Exclamation");
			break;
		case DialogType_OKCancelInput:
			uicontrolTextInputScr._Show();
			uicontrolTextInputScr._UseCostString(false);
			m_okHandle.ShowWindow();
			m_cancelHandle.ShowWindow();
			SetQuestIconTexture("L2UI_NewTex.Windows.Asset_Questionmark");
			break;
		case DialogType_OKInput:
			uicontrolTextInputScr._Show();
			uicontrolTextInputScr._UseCostString(false);
			m_centerHandle.ShowWindow();
			SetQuestIconTexture("L2UI_NewTex.Windows.Asset_Exclamation");
			break;
		case DialogType_Warning:
			m_okHandle.ShowWindow();
			m_cancelHandle.ShowWindow();
			SetQuestIconTexture("L2UI_NewTex.Windows.Asset_Questionmark");
			break;
		case DialogType_Notice:
			m_centerHandle.ShowWindow();
			SetQuestIconTexture("L2UI_NewTex.Windows.Asset_Exclamation");
			break;
		case DialogType_NumberPad:
			uicontrolTextInputScr._Show();
			uicontrolTextInputScr._UseCostString(true);
			uicontrolTextInputScr._UseNumericColor(true);
			m_okHandle.ShowWindow();
			m_cancelHandle.ShowWindow();
			m_NumberPad.ShowWindow();
			SetEditType("number");
			SetQuestIconTexture("L2UI_NewTex.Windows.Asset_Questionmark");
			break;
		case DialogType_Progress:
			m_okHandle.ShowWindow();
			m_cancelHandle.ShowWindow();
			ShowWindow("DialogBox.DialogProgress");
			if((m_paramInt == INT64(0)))
			{
			}
			else
			{
				m_hDialogBoxDialogProgress.SetProgressTime(int(m_paramInt));
				m_hDialogBoxDialogProgress.Reset();
				m_hDialogBoxDialogProgress.Start();
			}
			SetQuestIconTexture("L2UI_NewTex.Windows.Asset_Questionmark");
			break;
		case DialogType_NumberPad2:
			m_WeightPad.ShowWindow();
			uicontrolTextInputScr._Show();
			uicontrolTextInputScr._UseCostString(true);
			uicontrolTextInputScr._UseNumericColor(true);
			m_okHandle.ShowWindow();
			m_cancelHandle.ShowWindow();
			m_NumberPad.ShowWindow();
			SetEditType("number");
			SetDialogWeightBtns();
			SetQuestIconTexture("L2UI_NewTex.Windows.Asset_Questionmark");
			break;
		case DialogType_NumberPadAdena:
			m_okHandle.ShowWindow();
			m_WorldExchangePad.ShowWindow();
			uicontrolTextInputScr._Show();
			uicontrolTextInputScr._UseCostString(true);
			uicontrolTextInputScr._UseNumericColor(true);
			uicontrolTextInputScr._SetUnderUnit(Class'InterfaceClassic.WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT);
			uicontrolTextInputScr._SetLimitNum(Class'InterfaceClassic.WorldExchangeBuyWnd'.static.Inst().ADENA_MAX);
			m_cancelHandle.ShowWindow();
			m_NumberPad.ShowWindow();
			SetEditType("number");
			SetDialogWeightBtns();
			SetOptionForAdena();
			SetQuestIconTexture("L2UI_NewTex.Windows.Asset_Questionmark");
			break;
		default:
			break;
	}
	if((int(Style) == 7))
	{
		m_dialogHandle.SetAnchor("", "BottomCenter", "BottomCenter", 0, 0);
	}
	else
	{
		m_dialogHandle.SetAnchor("", "CenterCenter", "CenterCenter", 0, 0);
	}
	return;
}

function SetOptionForAdena()
{
	if(getInstanceUIData().GetIsLiveServer())
	{
		return;
	}
	if((Class'InterfaceClassic.WorldExchangeBuyWnd'.static.Inst()._IsNewServer() == true))
	{
		GetButtonHandle("DialogBox.WorldExchangePad.optBtn0").SetNameText(("+" $ GetSystemString(7235)));
	}
	else
	{
		GetButtonHandle("DialogBox.WorldExchangePad.optBtn0").SetNameText(GetSystemString(14194));
	}
	return;
}

function HandleNumberClick(string strID)
{
	local int i;
	local string sumStr, sumStrWithoutComma;
	local int cursorPos;

	switch(strID)
	{
		case "num0":
			if((uicontrolTextInputScr.GetString() != ""))
			{
				uicontrolTextInputScr.DeleteClipBoard();
				cursorPos = uicontrolTextInputScr._GetCursorPosition();
				uicontrolTextInputScr._AddStringAtPosition(cursorPos, "0");
			}
			break;
		case "num1":
			uicontrolTextInputScr.DeleteClipBoard();
			cursorPos = uicontrolTextInputScr._GetCursorPosition();
			uicontrolTextInputScr._AddStringAtPosition(cursorPos, "1");
			break;
		case "num2":
			uicontrolTextInputScr.DeleteClipBoard();
			cursorPos = uicontrolTextInputScr._GetCursorPosition();
			uicontrolTextInputScr._AddStringAtPosition(cursorPos, "2");
			break;
		case "num3":
			uicontrolTextInputScr.DeleteClipBoard();
			cursorPos = uicontrolTextInputScr._GetCursorPosition();
			uicontrolTextInputScr._AddStringAtPosition(cursorPos, "3");
			break;
		case "num4":
			uicontrolTextInputScr.DeleteClipBoard();
			cursorPos = uicontrolTextInputScr._GetCursorPosition();
			uicontrolTextInputScr._AddStringAtPosition(cursorPos, "4");
			break;
		case "num5":
			uicontrolTextInputScr.DeleteClipBoard();
			cursorPos = uicontrolTextInputScr._GetCursorPosition();
			uicontrolTextInputScr._AddStringAtPosition(cursorPos, "5");
			break;
		case "num6":
			uicontrolTextInputScr.DeleteClipBoard();
			cursorPos = uicontrolTextInputScr._GetCursorPosition();
			uicontrolTextInputScr._AddStringAtPosition(cursorPos, "6");
			break;
		case "num7":
			uicontrolTextInputScr.DeleteClipBoard();
			cursorPos = uicontrolTextInputScr._GetCursorPosition();
			uicontrolTextInputScr._AddStringAtPosition(cursorPos, "7");
			break;
		case "num8":
			uicontrolTextInputScr.DeleteClipBoard();
			cursorPos = uicontrolTextInputScr._GetCursorPosition();
			uicontrolTextInputScr._AddStringAtPosition(cursorPos, "8");
			break;
		case "num9":
			uicontrolTextInputScr.DeleteClipBoard();
			cursorPos = uicontrolTextInputScr._GetCursorPosition();
			uicontrolTextInputScr._AddStringAtPosition(cursorPos, "9");
			break;
		case "numAll":
			if((m_paramInt >= INT64(0)))
			{
				if(((inputLimit > INT64(-1)) && (inputLimit < m_paramInt)))
				{
					uicontrolTextInputScr.SetString(string(inputLimit));
				}
				else
				{
					uicontrolTextInputScr.SetString(string(m_paramInt));
				}
				sumStr = "";
				i = 0;
				while((i < m_editMaxLength))
				{
					if((((float(i) % 4.0000000) == 3.0000000) && (i != 0)))
					{
						sumStr = ("," $ sumStr);
						i++;
						continue;
					}
					sumStr = ("9" $ sumStr);
					sumStrWithoutComma = ("9" $ sumStrWithoutComma);
					i++;
				}
				if((sumStr != ""))
				{
					if((INT64(int(sumStrWithoutComma)) < m_paramInt))
					{
						uicontrolTextInputScr.SetString(sumStrWithoutComma);
					}
				}
			}
			break;
		case "numBS":
			uicontrolTextInputScr.SimulateBackspace();
			break;
		case "numC":
			uicontrolTextInputScr.Clear();
			break;
		default:
			break;
	}
	return;
}

function DoDefaultAction()
{
	switch(m_defaultAction)
	{
		case EDefaultOK:
			HandleOK();
			break;
		case EDefaultCancel:
			HandleCancel();
			break;
		case EDefaultNone:
			HandleCancel();
			break;
		default:
			break;
	}
	SetDefaultAction(EDefaultNone);
	return;
}

function DoEnterAction()
{
	switch(m_enterAction)
	{
		case EEnterOK:
			HandleOK();
			break;
		case EEnterCancel:
			HandleCancel();
			break;
		case EEnterDoNothing:
			break;
		case EEnterNone:
			DoDefaultAction();
			break;
		default:
			break;
	}
	return;
}

function SetDialogWeightBtns()
{
	if((GetCanNumByLimitWeight(50.0000000) > 0))
	{
		GetButtonHandle("DialogBox.WeightPad.optBtn0").EnableWindow();
	}
	else
	{
		GetButtonHandle("DialogBox.WeightPad.optBtn0").DisableWindow();
	}
	if((GetCanNumByLimitWeight(66.5899963) > 0))
	{
		GetButtonHandle("DialogBox.WeightPad.optBtn1").EnableWindow();
	}
	else
	{
		GetButtonHandle("DialogBox.WeightPad.optBtn1").DisableWindow();
	}
	if((GetCanNumByLimitWeight(80.0000000) > 0))
	{
		GetButtonHandle("DialogBox.WeightPad.optBtn2").EnableWindow();
	}
	else
	{
		GetButtonHandle("DialogBox.WeightPad.optBtn2").DisableWindow();
	}
	return;
}

function float GetCanCarryWeight(float limitPercent)
{
	local UserInfo uInfo;
	local float limitWeight;

	if(!GetPlayerInfo(uInfo))
	{
		return -1.0000000;
	}
	limitWeight = ((float(uInfo.nCarryWeight) * limitPercent) / 100.0000000);
	return ((limitWeight - float(uInfo.nCarringWeight)) - float(m_reservedInt));
}

function int GetCanNumByLimitWeight(float limitPercent)
{
	local float canCarryWeight, canNumbyLimit;

	canCarryWeight = GetCanCarryWeight(limitPercent);
	canNumbyLimit = (canCarryWeight / float(m_reservedItemInfo.Weight));
	if((canNumbyLimit > float(int(canNumbyLimit))))
	{
		return int((canCarryWeight / float(m_reservedItemInfo.Weight)));
	}
	return int(((canCarryWeight / float(m_reservedItemInfo.Weight)) - 1.0000000));
}

function HandleUserOptionBtn(string btnName)
{
	local int Option;

	Option = int(Right(btnName, 1));
	switch(m_type)
	{
		case DialogType_NumberPadAdena:
			HandleUserOptionAdena(Option);
			break;
		case DialogType_NumberPad2:
			HandleUserOptionWeight(Option);
			break;
		default:
			break;
	}
	return;
}

function HandleUserOptionWeight(int Option)
{
	local int canNumbyLimit;

	switch(Option)
	{
		case 0:
			canNumbyLimit = GetCanNumByLimitWeight(50.0000000);
			break;
		case 1:
			canNumbyLimit = GetCanNumByLimitWeight(66.5899963);
			break;
		case 2:
			canNumbyLimit = GetCanNumByLimitWeight(80.0000000);
			break;
		default:
			break;
	}
	uicontrolTextInputScr.SetString(string(canNumbyLimit));
	return;
}

function HandleUserOptionAdena(int Option)
{
	local INT64 Num;
	local int numLen;

	Num = INT64(uicontrolTextInputScr.GetString());
	switch(Option)
	{
		case 0:
			Num = INT64(1);
			break;
		case 1:
			Num = INT64(5);
			break;
		case 2:
			Num = INT64(10);
			break;
		case 3:
			Num = INT64(50);
			break;
		case 4:
			Num = INT64(100);
			break;
		default:
			break;
	}
	if(((Option != 0) && Class'InterfaceClassic.WorldExchangeBuyWnd'.static.Inst()._IsNewServer()))
	{
		Num = (Num * INT64(10));
	}
	Num = (Num * Class'InterfaceClassic.WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT);
	numLen = Len(string(Num));
	Num = (INT64(uicontrolTextInputScr.GetString()) + Num);
	uicontrolTextInputScr.SetString(string(Num));
	uicontrolTextInputScr._SetCursorPosition(((Len(string(Num)) - numLen) + 1));
	return;
}

function ChkHandleCancel()
{
	if((tryCancelDialogID > -1))
	{
		HandleCancel();
	}
	return;
}

function bool ChkIDEnterKey()
{
	local bool isshowcand;

	if(m_bGlobalIME)
	{
		if(uicontrolTextInputScr._IsShowWIndow())
		{
			isshowcand = uicontrolTextInputScr.IsShowCandidateBox();
			return isshowcand;
		}
	}
	return false;
}

function SetQuestIconTexture(string TextureName)
{
	m_Questionmark_Tex.SetTexture(TextureName, TextureName, TextureName);
	return;
}

function string GetWorldExchangeAdenaZeroString()
{
	if(getInstanceUIData().GetIsLiveServer())
	{
		return "00000000";
	}
	else if((Class'InterfaceClassic.WorldExchangeBuyWnd'.static.Inst()._IsNewServer() == true))
	{
		return "000000";
	}
	return "0000000";
}

function SetHtmlCtrlHeight()
{
	local int nHeight;

	nHeight = m_HtmlViewer.GetFrameMaxHeight();
	m_HtmlViewer.SetWindowSizeRel(1.0000000, 0.0000000, -30, nHeight);
	return;
}

function SetTextBoxHeight(string Desc)
{
	local int Height;
	local TextBoxHandle dialogText;
	local int locX, locY;

	dialogText = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DialogBody.DialogText"));
	Height = Class'InterfaceClassic.L2Util'.static.Inst()._GetTextBoxHeight(dialogText, Desc);
	dialogText.SetWindowSizeRel(1.0000000, 0.0000000, -30, Height);
	GetLocalPosition(dialogText, locX, locY);
	return;
}

function SetDialogBodySize()
{
	switch(m_type)
	{
		case DialogType_OKCancel:
		case DialogType_OK:
		case DialogType_Warning:
		case DialogType_Notice:
			m_dialogBody.SetWindowSizeRel(0.0000000, 1.0000000, 368, 0);
			m_HeaderDecoWnd.SetWindowSize(368, 16);
			m_DialogBtns.SetWindowSizeRel(0.0000000, 1.0000000, 368, 50);
			break;
		case DialogType_OKCancelInput:
		case DialogType_OKInput:
			m_dialogBody.SetWindowSizeRel(0.0000000, 1.0000000, 368, 0);
			m_HeaderDecoWnd.SetWindowSize(368, 16);
			m_DialogBtns.SetWindowSizeRel(0.0000000, 1.0000000, 368, 50);
			break;
		case DialogType_Progress:
			m_dialogBody.SetWindowSizeRel(0.0000000, 1.0000000, 368, 0);
			m_HeaderDecoWnd.SetWindowSize(368, 16);
			m_DialogBtns.SetWindowSizeRel(0.0000000, 1.0000000, 368, 50);
			break;
		case DialogType_NumberPad:
			m_dialogBody.SetWindowSizeRel(0.0000000, 1.0000000, 368, 0);
			m_HeaderDecoWnd.SetWindowSize(368, 16);
			m_DialogBtns.SetWindowSizeRel(0.0000000, 1.0000000, 368, 50);
			break;
		case DialogType_NumberPad2:
		case DialogType_NumberPadAdena:
			m_dialogBody.SetWindowSizeRel(0.0000000, 1.0000000, 438, 0);
			m_HeaderDecoWnd.SetWindowSize(438, 16);
			m_DialogBtns.SetWindowSizeRel(0.0000000, 1.0000000, 438, 50);
			break;
		default:
			break;
	}
	return;
}

function SetWindowHeight(optional bool bUseHtml)
{
	local Rect rectWnd;
	local TextBoxHandle dialogText;

	dialogText = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DialogBody.DialogText"));
	if(bUseHtml)
	{
		rectWnd = m_HtmlViewer.GetRect();
	}
	else
	{
		rectWnd = dialogText.GetRect();
	}
	switch(m_type)
	{
		case DialogType_OKCancel:
		case DialogType_OK:
		case DialogType_Warning:
		case DialogType_Notice:
			m_dialogHandle.SetWindowSize(368, (rectWnd.nHeight + 93));
			m_BGTex.SetWindowSize(368, (rectWnd.nHeight + 93));
			m_shadowTexture.SetWindowSize(368, (rectWnd.nHeight + 93));
			break;
		case DialogType_OKCancelInput:
		case DialogType_OKInput:
			m_dialogHandle.SetWindowSize(368, 160);
			m_BGTex.SetWindowSize(368, 160);
			m_shadowTexture.SetWindowSize(368, 160);
			break;
		case DialogType_Progress:
			m_dialogHandle.SetWindowSize(368, ((rectWnd.nHeight + 93) + 10));
			m_BGTex.SetWindowSize(368, ((rectWnd.nHeight + 93) + 10));
			m_shadowTexture.SetWindowSize(368, ((rectWnd.nHeight + 93) + 10));
			break;
		case DialogType_NumberPad:
			m_dialogHandle.SetWindowSize((368 + 160), 160);
			m_BGTex.SetWindowSize(368, 160);
			m_shadowTexture.SetWindowSize(368, 160);
			break;
		case DialogType_NumberPad2:
		case DialogType_NumberPadAdena:
			m_dialogHandle.SetWindowSize((438 + 160), 207);
			m_BGTex.SetWindowSize(438, 207);
			m_shadowTexture.SetWindowSize(438, 207);
			break;
		default:
			break;
	}
	return;
}
