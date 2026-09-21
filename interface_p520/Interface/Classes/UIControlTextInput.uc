class UIControlTextInput extends UICommonAPI;

var EditBoxHandle inputTextBox;
var TextBoxHandle defaultTextBox;
var TextureHandle enableTex;
var TextureHandle disableTex;
var TextureHandle edtiableTex;
var ButtonHandle clearBtn;
var int _max;
var string _defaultString;
var string _string;
var bool _bDisable;
var bool _bEdtiable;
var WindowHandle costStringWindow;
var TextBoxHandle costStringTextBox;
var WindowHandle exStringTextBoxWindow;
var TextBoxHandle exStringTextBox;
var bool bFocused;
var bool buseNumericColor;
var bool bUseCostString;
var string extraString;
var bool bUseDefaultStringWithFocus;
var string editType;
var L2UITimerObject timerObject;
var bool bSimulateBackspaced;
var INT64 underUnit;
var INT64 limitNum;
var bool bUseLimitNum;
var bool bCheckOnChangeEdit;
//var delegate<DelegateOnChangeEdited> __DelegateOnChangeEdited__Delegate;
//var delegate<DelegateOnCompleteEditBox> __DelegateOnCompleteEditBox__Delegate;
//var delegate<DelegateOnClear> __DelegateOnClear__Delegate;
//var delegate<DelegateOnKeyUP> __DelegateOnKeyUP__Delegate;
//var delegate<DelegateESCKey> __DelegateESCKey__Delegate;

delegate DelegateOnChangeEdited(string Text)
{
	return;
}

delegate DelegateOnCompleteEditBox(string Text)
{
	return;
}

delegate DelegateOnClear()
{
	return;
}

delegate DelegateOnKeyUP(Interactions.EInputKey nKey)
{
	return;
}

delegate DelegateESCKey()
{
	return;
}

static function UIControlTextInput InitScript(WindowHandle wnd)
{
	local UIControlTextInput scr;

	wnd.SetScript("UIControlTextInput");
	scr = UIControlTextInput(wnd.GetScript());
	scr.InitWnd(wnd);
	return scr;
}

function InitWnd(WindowHandle wnd)
{
	m_hOwnerWnd = wnd;
	inputTextBox = GetEditBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".inputTextBox"));
	inputTextBox.SetEnableKeepingSelection(true);
	defaultTextBox = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".defaultTextBox"));
	enableTex = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".enableTex"));
	disableTex = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".disableTex"));
	edtiableTex = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".edtiableTex"));
	clearBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".clearBtn"));
	costStringWindow = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".costStringWindow"));
	costStringTextBox = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".costStringWindow.costStringTextBox"));
	exStringTextBoxWindow = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".exStringTextBoxWindow"));
	exStringTextBox = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".exStringTextBoxWindow.exStringTextBox"));
	_HideCostStringWindow();
	_bEdtiable = false;
	SetDisable(false);
	m_hOwnerWnd.ShowWindow();
	timerObject = Class'Interface.L2UITimer'.static.Inst()._MakeTimerObject(100, -1);
	timerObject._DelegateOnTime = OnTimerTester;
	InitClearBtnSize();
	SetInputTextBoxWidthWithClearBtn();
	return;
}

function SetInputTextBoxWidthWithClearBtn()
{
	local Rect rectWnd;

	rectWnd = clearBtn.GetRect();
	inputTextBox.SetWindowSizeRel(1.0000000, 1.0000000, (-rectWnd.nWidth + 1), 0);
	return;
}

function InitClearBtnSize()
{
	local Rect rectWnd;

	rectWnd = m_hOwnerWnd.GetRect();
	clearBtn.SetWindowSizeRel(0.0000000, 1.0000000, rectWnd.nHeight, 0);
	return;
}

function OnTimerTester(int Time)
{
	if(m_hOwnerWnd.GetTopFrameWnd().IsShowWindow())
	{
		Debug((("OnTimerTester" @ m_hOwnerWnd.GetTopFrameWnd().GetWindowName()) @ string(inputTextBox.IsFocused())));
	}
	return;
}

function bool CheckZero()
{
	local string EditBoxString;

	if((editType != "number"))
	{
		return false;
	}
	EditBoxString = GetString();
	if(((Left(EditBoxString, 1) == "0") && (Len(EditBoxString) > 1)))
	{
		inputTextBox.SetString(Right(EditBoxString, (Len(EditBoxString) - 1)));
		return true;
	}
	return false;
}

event OnChangeEditBox(string strID)
{
	Debug(("빈값이 되도 OnChangeEditBox 가 되는가?" @ inputTextBox.GetString()));  // EN?: If it becomes empty, does it become OnChangeEditBox?
	if((strID != "inputTextBox"))
	{
		return;
	}
	if(bCheckOnChangeEdit)
	{
		bCheckOnChangeEdit = false;
		return;
	}
	if((ChkUnderUnit() == true))
	{
		return;
	}
	if((CheckZero() == true))
	{
		return;
	}
	if((ChkLimitNum() == true))
	{
		return;
	}
	DelegateOnChangeEdited(GetString());
	SetNumericColor();
	SetCostString();
	ChkCostString();
	CheckDefaultString();
	return;
}

event OnCompleteEditBox(string strID)
{
	DelegateOnCompleteEditBox(GetString());
	return;
}

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	switch(nKey)
	{
		case IK_Escape:
			DelegateESCKey();
			if((GetString() != _string))
			{
				SetString(_string);
			}
			inputTextBox.ReleaseFocus();
			DelegateOnKeyUP(nKey);
			return true;
		default:
			DelegateOnKeyUP(nKey);
			return false;
	}
}

event OnClickButton(string strID)
{
	if(!IsEdtiable())
	{
		return;
	}
	Clear();
	inputTextBox.SetFocus();
	DelegateOnClear();
	return;
}

event OnSetFocus(WindowHandle a_WindowHandle, bool focused)
{
	if(focused)
	{
		ChkCostString();
		m_hOwnerWnd.GetTopFrameWnd().BringToFront();
	}
	else
	{
		_HideCostStringWindow();
	}
	if((a_WindowHandle == inputTextBox))
	{
		bFocused = focused;
	}
	m_hOwnerWnd.GetParentWindowHandle().GetScript().OnSetFocus(a_WindowHandle, focused);
	CheckDefaultString();
	return;
}

function int _GetCursorPosition()
{
	return inputTextBox.GetCursorPosition();
}

function _SetCursorPosition(int pos)
{
	inputTextBox.SetCursorPosition(pos);
	return;
}

function _AddStringAtPosition(int pos, string Str)
{
	inputTextBox.AddStringAtPosition(pos, Str);
	return;
}

function _SetUnderUnit(INT64 _underUnit)
{
	underUnit = _underUnit;
	return;
}

function _SetUseDefaultStringWithFocus(bool bUse)
{
	bUseDefaultStringWithFocus = bUse;
	CheckDefaultString();
	return;
}

function _SetExtraString(string Str)
{
	local int gX, gY;

	extraString = Str;
	if((Str == ""))
	{
		Local2Global(m_hOwnerWnd, 0, -25, gX, gY);
		exStringTextBoxWindow.HideWindow();
	}
	else
	{
		Local2Global(m_hOwnerWnd, 0, -50, gX, gY);
		exStringTextBox.SetText(Str);
		exStringTextBoxWindow.ShowWindow();
	}
	costStringWindow.MoveTo(gX, gY);
	return;
}

function string _GetExtraString()
{
	return extraString;
}

function _SetExtraStringColor(Color C)
{
	exStringTextBoxWindow.SetFontColor(C);
	return;
}

function string GetString()
{
	return inputTextBox.GetString();
}

function SimulateBackspace()
{
	_string = Left(_string, (Len(_string) - 1));
	bSimulateBackspaced = true;
	inputTextBox.SimulateBackspace();
	return;
}

function bool IsShowCandidateBox()
{
	return inputTextBox.IsShowCandidateBox();
}

function SetString(string Str, optional bool bFormatString, optional bool isCheckOnChangeEdit)
{
	_string = Str;
	bCheckOnChangeEdit = isCheckOnChangeEdit;
	if(bFormatString)
	{
		inputTextBox.SetFormatString(Str);
	}
	else
	{
		inputTextBox.SetString(Str);
	}
	CheckDefaultString();
	return;
}

function DeleteClipBoard()
{
	inputTextBox.DeleteClipBoard();
	return;
}

function AddString(string Str, optional bool bFormatString)
{
	SetString((inputTextBox.GetString() $ Str));
	return;
}

function AddEmojiIcon(int nEmojiIconIndex)
{
	inputTextBox.AddEmojiIcon(nEmojiIconIndex);
	_string = inputTextBox.GetString();
	CheckDefaultString();
	return;
}

function Clear()
{
	SetString("");
	costStringTextBox.SetText("");
	_HideCostStringWindow();
	return;
}

function SetHighLight(bool isHighLight)
{
	inputTextBox.SetHighLight(isHighLight);
	return;
}

function AllSelect()
{
	if(IsEdtiable())
	{
		inputTextBox.AllSelect();
		inputTextBox.SetFocus();
	}
	return;
}

function Focus()
{
	m_hOwnerWnd.SetFocus();
	if(IsEdtiable())
	{
		inputTextBox.SetFocus();
	}
	return;
}

function bool IsEmpty()
{
	return inputTextBox.IsEmpty();
}

function SetDefaultString(string Str)
{
	defaultTextBox.SetText(Str);
	_defaultString = Str;
	CheckDefaultString();
	return;
}

function SetMaxLength(int Max)
{
	inputTextBox.SetMaxLength(Max);
	return;
}

function SetDisable(bool bDisable)
{
	_bDisable = bDisable;
	if(bDisable)
	{
		disableTex.ShowWindow();
		enableTex.HideWindow();
		inputTextBox.ReleaseFocus();
		inputTextBox.DisableWindow();
		clearBtn.DisableWindow();
	}
	else
	{
		disableTex.HideWindow();
		SetEdtiable(_bEdtiable);
	}
	return;
}

function SetEdtiable(bool bEdtiable)
{
	_bEdtiable = bEdtiable;
	if(_bDisable)
	{
		return;
	}
	if(bEdtiable)
	{
		inputTextBox.EnableWindow();
		enableTex.ShowWindow();
		edtiableTex.HideWindow();
		clearBtn.EnableWindow();
	}
	else
	{
		enableTex.HideWindow();
		edtiableTex.ShowWindow();
		inputTextBox.ReleaseFocus();
		inputTextBox.DisableWindow();
		clearBtn.DisableWindow();
	}
	return;
}

function bool IsEdtiable()
{
	return (_bEdtiable && !_bDisable);
}

function _HideCostStringWindow()
{
	costStringWindow.HideWindow();
	return;
}

function _ShowCostStringWindow()
{
	costStringWindow.ShowWindow();
	return;
}

function bool _IsShowWIndow()
{
	return m_hOwnerWnd.IsShowWindow();
}

function _Hide()
{
	m_hOwnerWnd.HideWindow();
	return;
}

function _Show()
{
	m_hOwnerWnd.ShowWindow();
	return;
}

function bool _IsFocused()
{
	return bFocused;
}

function _ClearHistory()
{
	inputTextBox.ClearHistory();
	return;
}

function _AddItemToAutoCompleteHistory(string Str)
{
	inputTextBox.AddItemToAutoCompleteHistory(Str);
	return;
}

function _UseClearBtn(bool bUse)
{
	if(bUse)
	{
		clearBtn.ShowWindow();
		SetInputTextBoxWidthWithClearBtn();
	}
	else
	{
		clearBtn.HideWindow();
		inputTextBox.SetWindowSizeRel(1.0000000, 1.0000000, 0, 0);
	}
	return;
}

function string _GetEditType()
{
	return editType;
}

function _SetEditType(string Type)
{
	editType = Type;
	inputTextBox.SetEditType(Type);
	return;
}

function _ClearTooltip()
{
	inputTextBox.ClearTooltip();
	return;
}

function _SetFontColor(Color C)
{
	inputTextBox.SetFontColor(C);
	return;
}

function _SetAlign(UIEventManager.ETextAlign Align)
{
	inputTextBox.SetAlign(Align);
	return;
}

function _UseNumericColor(bool bUse)
{
	if((bUse == false))
	{
		_SetFontColor(GetNumericColor(MakeCostString("1")));
	}
	buseNumericColor = bUse;
	return;
}

function _UseCostString(bool bUse)
{
	bUseCostString = bUse;
	return;
}

function _SetDefaultFontColor(Color C)
{
	defaultTextBox.SetFontColor(C);
	return;
}

function _SetDefaultAlign(UIEventManager.ETextAlign Align)
{
	defaultTextBox.SetAlign(Align);
	return;
}

function _SetLimitNum(INT64 Num)
{
	limitNum = Num;
	bUseLimitNum = (limitNum != INT64(-1));
	return;
}

function bool ChkUnderUnit()
{
	local bool bReduceKeyUsed;
	local string strInput;
	local INT64 const64;

	if((underUnit == INT64(0)))
	{
		return false;
	}
	bReduceKeyUsed = ((IsKeyDown(IK_Delete) || IsKeyDown(IK_Backspace)) || bSimulateBackspaced);
	strInput = inputTextBox.GetString();
	bSimulateBackspaced = false;
	if((Len(strInput) > 0))
	{
		const64 = INT64(strInput);
		if((const64 >= underUnit))
		{
			if((((const64 / underUnit) * underUnit) != const64))
			{
				inputTextBox.SetString(string(((const64 / underUnit) * underUnit)));
				return true;
			}
		}
		else if(((const64 > INT64(0)) && (bReduceKeyUsed == false)))
		{
			inputTextBox.SetString(string((const64 * underUnit)));
			inputTextBox.SetCursorPosition(1);
			return true;
		}
		else
		{
			Clear();
			return true;
		}
	}
	return false;
}

function ChkCostString()
{
	if(bUseCostString)
	{
		if((((costStringTextBox.GetText() == GetString()) || (GetString() == "0")) || (GetString() == "")))
		{
			_HideCostStringWindow();
		}
		else
		{
			_ShowCostStringWindow();
		}
	}
	return;
}

function bool ChkLimitNum()
{
	local int cursorPosition;

	if((bUseLimitNum == false))
	{
		return false;
	}
	if((INT64(GetString()) > limitNum))
	{
		cursorPosition = inputTextBox.GetCursorPosition();
		inputTextBox.SetString(string(limitNum));
		if((underUnit > INT64(0)))
		{
			cursorPosition = Min(cursorPosition, ((Len(string(limitNum)) - Len(string(underUnit))) + 1));
			inputTextBox.SetCursorPosition(cursorPosition);
		}
		return true;
	}
	return false;
}

function SetCostString()
{
	if((bUseCostString == false))
	{
		return;
	}
	if((GetString() != ""))
	{
		costStringTextBox.SetText(ConvertNumToTextNoAdena(GetString()));
	}
	else
	{
		costStringTextBox.SetText("");
	}
	return;
}

function SetNumericColor()
{
	local Color FontColor;

	if(!buseNumericColor)
	{
		return;
	}
	FontColor = GetNumericColor(GetString());
	inputTextBox.SetFontColor(FontColor);
	return;
}

function CheckDefaultString()
{
	if(((bFocused == true) && (bUseDefaultStringWithFocus == false)))
	{
		defaultTextBox.HideWindow();
	}
	else if((IsEmpty() == true))
	{
		defaultTextBox.ShowWindow();
	}
	else
	{
		defaultTextBox.HideWindow();
	}
	return;
}
