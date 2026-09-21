class UIControlNumberInputSteper extends UIConstants;

var ButtonHandle plus1Button;
var ButtonHandle plus5Button;
var ButtonHandle plus10Button;
var ButtonHandle UpButton;
var ButtonHandle DownButton;
var EditBoxHandle ItemCount_EditBox;
var int maxEditNum;
var int minEditNum;
var int plus1ButtonValue;
var int plus5ButtonValue;
var int plus10ButtonValue;
var bool _bDisable;
//var delegate<DelegateOnButtonClick> __DelegateOnButtonClick__Delegate;
//var delegate<DelegateOnChangeEditBox> __DelegateOnChangeEditBox__Delegate;
//var delegate<DelegateESCKey> __DelegateESCKey__Delegate;
//var delegate<DelegateOnSetFocus> __DelegateOnSetFocus__Delegate;

delegate DelegateOnButtonClick(string strBtn, int addValue)
{
	return;
}

delegate DelegateOnChangeEditBox(UIControlNumberInputSteper mySelf)
{
	return;
}

delegate DelegateESCKey()
{
	return;
}

delegate DelegateOnSetFocus(bool bFocused)
{
	return;
}

static function UIControlNumberInputSteper InitScript(WindowHandle wnd)
{
	local UIControlNumberInputSteper scr;

	wnd.SetScript("UIControlNumberInputSteper");
	scr = UIControlNumberInputSteper(wnd.GetScript());
	scr.InitWnd(wnd);
	return scr;
}

function InitWnd(WindowHandle wnd)
{
	m_hOwnerWnd = wnd;
	Init();
	return;
}

function Init()
{
	plus1Button = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".plus1Button"));
	plus5Button = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".plus5Button"));
	plus10Button = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".plus10Button"));
	UpButton = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".upButton"));
	DownButton = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".downButton"));
	ItemCount_EditBox = GetEditBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemCount_EditBox"));
	ItemCount_EditBox.DisableWindow();
	_setAddButtons(1, 5, 10);
	return;
}

event OnClickButton(string strBtn)
{
	local int addValue;

	switch(strBtn)
	{
		case "plus1Button":
			calculationEdit(plus1ButtonValue);
			addValue = plus1ButtonValue;
			break;
		case "plus5Button":
			calculationEdit(plus5ButtonValue);
			addValue = plus5ButtonValue;
			break;
		case "plus10Button":
			calculationEdit(plus10ButtonValue);
			addValue = plus10ButtonValue;
			break;
		case "downButton":
			calculationEdit(-1);
			addValue = -1;
			break;
		case "upButton":
			calculationEdit(1);
			addValue = 1;
			break;
		default:
			break;
	}
	DelegateOnButtonClick(strBtn, addValue);
	return;
}

function calculationEdit(int addNum)
{
	local int sum;

	sum = Min(maxEditNum, Max(minEditNum, (int(ItemCount_EditBox.GetString()) + addNum)));
	ItemCount_EditBox.SetString(string(sum));
	checkMinMax();
	return;
}

event OnCompleteEditBox(string strID)
{
	checkMinMax();
	return;
}

event OnSetFocus(WindowHandle a_WindowHandle, bool IsFocused)
{
	m_hOwnerWnd.GetParentWindowHandle().GetScript().OnSetFocus(a_WindowHandle, IsFocused);
	return;
}

event OnChangeEditBox(string strID)
{
	DelegateOnChangeEditBox(self);
	checkButtonState();
	return;
}

function checkMinMax()
{
	local int editNum;

	editNum = int(ItemCount_EditBox.GetString());
	if((maxEditNum < editNum))
	{
		ItemCount_EditBox.SetString(string(maxEditNum));
	}
	else if(((minEditNum > editNum) || (ItemCount_EditBox.GetString() == "")))
	{
		ItemCount_EditBox.SetString(string(minEditNum));
	}
	if((Len(ItemCount_EditBox.GetString()) > 1))
	{
		if((Left(ItemCount_EditBox.GetString(), 1) == "0"))
		{
			ItemCount_EditBox.SetString(string(editNum));
		}
	}
	return;
}

function checkButtonState()
{
	local int buttonValue;

	buttonValue = int(ItemCount_EditBox.GetString());
	if((buttonValue <= minEditNum))
	{
		DownButton.DisableWindow();
	}
	else
	{
		DownButton.EnableWindow();
	}
	if((buttonValue >= maxEditNum))
	{
		UpButton.DisableWindow();
	}
	else
	{
		UpButton.EnableWindow();
	}
	if((plus1ButtonValue > 0))
	{
		if((buttonValue >= maxEditNum))
		{
			if((plus1Button.m_pTargetWnd != none))
			{
				plus1Button.DisableWindow();
			}
		}
		else
		{
			plus1Button.EnableWindow();
		}
	}
	else if((buttonValue <= minEditNum))
	{
		plus1Button.DisableWindow();
	}
	else
	{
		plus1Button.EnableWindow();
	}
	if((plus5ButtonValue > 0))
	{
		if((buttonValue >= maxEditNum))
		{
			plus5Button.DisableWindow();
		}
		else
		{
			plus5Button.EnableWindow();
		}
	}
	else if((buttonValue <= minEditNum))
	{
		plus5Button.DisableWindow();
	}
	else
	{
		plus5Button.EnableWindow();
	}
	if((plus10ButtonValue > 0))
	{
		if((buttonValue >= maxEditNum))
		{
			plus10Button.DisableWindow();
		}
		else
		{
			plus10Button.EnableWindow();
		}
	}
	else if((buttonValue <= minEditNum))
	{
		plus10Button.DisableWindow();
	}
	else
	{
		plus10Button.EnableWindow();
	}
	return;
}

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	local string mainKey;

	mainKey = Class'NWindow.InputAPI'.static.GetKeyString(nKey);
	switch(mainKey)
	{
		case "ESCAPE":
			DelegateESCKey();
			break;
		case "0":
		case "1":
		case "2":
		case "3":
		case "4":
		case "5":
		case "6":
		case "7":
		case "8":
		case "9":
		case "NUMPAD0":
		case "NUMPAD1":
		case "NUMPAD2":
		case "NUMPAD3":
		case "NUMPAD4":
		case "NUMPAD5":
		case "NUMPAD6":
		case "NUMPAD7":
		case "NUMPAD8":
		case "NUMPAD9":
			checkMinMax();
			break;
		default:
			break;
	}
	return false;
}

function _setMaxLength(int nMax)
{
	ItemCount_EditBox.SetMaxLength(nMax);
	return;
}

function _setRangeMinMaxNum(int minNum, int maxNum)
{
	local int Value;

	Value = int(ItemCount_EditBox.GetString());
	minEditNum = minNum;
	maxEditNum = maxNum;
	_setMaxLength(Len(string(maxNum)));
	ItemCount_EditBox.SetString(string(Min(Value, maxNum)));
	checkButtonState();
	return;
}

function _setEditNum(int Num)
{
	ItemCount_EditBox.SetString(string(Num));
	checkMinMax();
	checkButtonState();
	return;
}

function int _getEditNum()
{
	local int Value;

	Value = int(ItemCount_EditBox.GetString());
	return Value;
}

function _setAddButtons(int plus1, int plus5, int plus10)
{
	plus1ButtonValue = plus1;
	plus5ButtonValue = plus5;
	plus10ButtonValue = plus10;
	if((plus1 > 0))
	{
		plus1Button.SetNameText(("+" $ string(plus1)));
	}
	else
	{
		plus1Button.SetNameText(string(plus1));
	}
	if((plus5 > 0))
	{
		plus5Button.SetNameText(("+" $ string(plus5)));
	}
	else
	{
		plus5Button.SetNameText(string(plus5));
	}
	if((plus10 > 0))
	{
		plus10Button.SetNameText(("+" $ string(plus10)));
	}
	else
	{
		plus10Button.SetNameText(string(plus10));
	}
	return;
}

function _SetDisable(bool bDisable)
{
	_bDisable = bDisable;
	if(bDisable)
	{
		plus1Button.DisableWindow();
		plus5Button.DisableWindow();
		plus10Button.DisableWindow();
		UpButton.DisableWindow();
		DownButton.DisableWindow();
		ItemCount_EditBox.ReleaseFocus();
		ItemCount_EditBox.DisableWindow();
	}
	else
	{
		checkButtonState();
		ItemCount_EditBox.EnableWindow();
	}
	return;
}
