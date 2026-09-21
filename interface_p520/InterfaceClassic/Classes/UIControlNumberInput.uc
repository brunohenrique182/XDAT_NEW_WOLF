class UIControlNumberInput extends UICommonAPI;

const DIALOG_ASK_PRICE = 10111;
const MAXITEMNUM = 99999;
const MAXITEMNUMSELL = 9999999999;

var string m_Windowname;
var WindowHandle Me;
var EditBoxHandle ItemCount_EditBox;
var ButtonHandle Reset_Btn;
var ButtonHandle Buy_Btn;
var ButtonHandle MultiSell_Up_Button;
var ButtonHandle MultiSell_Down_Button;
var ButtonHandle MultiSell_Input_Button;
var ButtonHandle MultiSell_Max_Button;
var INT64 _minCountCanBuy;
var bool is_force_disable;
var bool is_Editor_disable;
var bool bUseCalculator;
var INT64 plusbasicunit;
//var delegate<DelegateGetCountCanBuy> __DelegateGetCountCanBuy__Delegate;
//var delegate<DelegateGetBtnTooltip> __DelegateGetBtnTooltip__Delegate;
//var delegate<DelegateESCKey> __DelegateESCKey__Delegate;
//var delegate<DelegateOnClickBuy> __DelegateOnClickBuy__Delegate;
//var delegate<delegateOnItemCountEdited> __delegateOnItemCountEdited__Delegate;
//var delegate<DelegateOnCancel> __DelegateOnCancel__Delegate;
//var delegate<DelegateOnClickInput> __DelegateOnClickInput__Delegate;
//var delegate<DelegateOnOverInput> __DelegateOnOverInput__Delegate;

delegate INT64 DelegateGetCountCanBuy()
{

}

delegate CustomTooltip DelegateGetBtnTooltip()
{

}

delegate DelegateESCKey()
{
	return;
}

delegate DelegateOnClickBuy()
{
	return;
}

delegate delegateOnItemCountEdited(INT64 changedNum)
{
	return;
}

delegate DelegateOnCancel()
{
	return;
}

delegate DelegateOnClickInput()
{
	return;
}

delegate DelegateOnOverInput()
{
	return;
}

static function UIControlNumberInput InitScript(WindowHandle wnd)
{
	local UIControlNumberInput scr;

	wnd.SetScript("UIControlNumberInput");
	scr = UIControlNumberInput(wnd.GetScript());
	scr.InitWnd(wnd);
	return scr;
}

function InitWnd(WindowHandle wnd)
{
	m_hOwnerWnd = wnd;
	Init(m_hOwnerWnd.m_WindowNameWithFullPath);
	return;
}

function Init(string WindowName)
{
	m_Windowname = WindowName;
	Me = GetWindowHandle(m_Windowname);
	ItemCount_EditBox = GetEditBoxHandle((m_Windowname $ ".ItemCount_EditBox"));
	Reset_Btn = GetButtonHandle((m_Windowname $ ".Reset_Btn"));
	Buy_Btn = GetButtonHandle((m_Windowname $ ".Buy_Btn"));
	MultiSell_Up_Button = GetButtonHandle((m_Windowname $ ".MultiSell_Up_Button"));
	MultiSell_Down_Button = GetButtonHandle((m_Windowname $ ".MultiSell_Down_Button"));
	MultiSell_Max_Button = GetButtonHandle((m_Windowname $ ".MultiSell_Max_Button"));
	MultiSell_Input_Button = GetButtonHandle((m_Windowname $ ".MultiSell_Input_Button"));
	if((MultiSell_Input_Button.m_pTargetWnd != none))
	{
		MultiSell_Input_Button.HideWindow();
	}
	is_force_disable = false;
	_minCountCanBuy = INT64(1);
	plusbasicunit = INT64(1);
	return;
}

event OnChangeEditBox(string strID)
{
	switch(strID)
	{
		case "ItemCount_EditBox":
			CheckZero();
			SetCount(INT64(ItemCount_EditBox.GetString()));
			break;
		default:
			break;
	}
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "MultiSell_Input_Button":
			OnPriceEditBtnHandler();
			break;
		case "MultiSell_Up_Button":
			OnMultiSell_Up_ButtonClick();
			break;
		case "MultiSell_Down_Button":
			OnMultiSell_Down_ButtonClick();
			break;
		case "Reset_Btn":
			SetCount(_minCountCanBuy);
			break;
		case "Buy_Btn":
			DelegateOnClickBuy();
			break;
		case "MultiSell_Max_Button":
			SetCount(6056184808285929474);
			break;
		case "Cancel_Btn":
			DelegateOnCancel();
			break;
		default:
			break;
	}
	return;
}

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	local string mainKey;

	mainKey = Class'NWindow.InputAPI'.static.GetKeyString(nKey);
	if(("ESCAPE" == mainKey))
	{
		DelegateESCKey();
	}
	return false;
}

function CheckZero()
{
	local string EditBoxString;

	EditBoxString = ItemCount_EditBox.GetString();
	if(((Left(EditBoxString, 1) == "0") && (Len(EditBoxString) > 1)))
	{
		ItemCount_EditBox.SetString(Right(EditBoxString, (Len(EditBoxString) - 1)));
	}
	return;
}

function SetCount(INT64 Num)
{
	if((DelegateGetCountCanBuy() < Num))
	{
		DelegateOnOverInput();
	}
	Num = Min64(DelegateGetCountCanBuy(), Num);
	if((Num != INT64(ItemCount_EditBox.GetString())))
	{
		ItemCount_EditBox.SetString(string(Num));
	}
	delegateOnItemCountEdited(Num);
	SetControlerBtns();
	SetBuyBtnTooltip();
	return;
}

function INT64 GetCount()
{
	return INT64(ItemCount_EditBox.GetString());
}

function OnPriceEditBtnHandler()
{
	DelegateOnClickInput();
	return;
}

function OnMultiSell_Up_ButtonClick()
{
	SetCount((INT64(ItemCount_EditBox.GetString()) + plusbasicunit));
	return;
}

function OnMultiSell_Down_ButtonClick()
{
	SetCount((INT64(ItemCount_EditBox.GetString()) - plusbasicunit));
	return;
}

function SetBuyBtnTooltip()
{
	if((Buy_Btn.m_pTargetWnd != none))
	{
		Buy_Btn.SetTooltipCustomType(DelegateGetBtnTooltip());
	}
	return;
}

function SetControlerBtns()
{
	local INT64 Count, canBuyCount;

	if((is_force_disable == true))
	{
		if((MultiSell_Input_Button.m_pTargetWnd != none))
		{
			MultiSell_Input_Button.DisableWindow();
		}
		if((MultiSell_Max_Button.m_pTargetWnd != none))
		{
			MultiSell_Max_Button.DisableWindow();
		}
		MultiSell_Up_Button.DisableWindow();
		MultiSell_Down_Button.DisableWindow();
		ItemCount_EditBox.DisableWindow();
		return;
	}
	canBuyCount = DelegateGetCountCanBuy();
	Count = INT64(ItemCount_EditBox.GetString());
	if((Reset_Btn.m_pTargetWnd != none))
	{
		if(((Count != _minCountCanBuy) && (canBuyCount >= _minCountCanBuy)))
		{
			Reset_Btn.EnableWindow();
		}
		else
		{
			Reset_Btn.DisableWindow();
		}
	}
	if((MultiSell_Max_Button.m_pTargetWnd != none))
	{
		if(((Count < canBuyCount) && (canBuyCount >= _minCountCanBuy)))
		{
			MultiSell_Max_Button.EnableWindow();
		}
		else
		{
			MultiSell_Max_Button.DisableWindow();
		}
	}
	if((canBuyCount <= _minCountCanBuy))
	{
		ItemCount_EditBox.DisableWindow();
	}
	else if(!is_Editor_disable)
	{
		ItemCount_EditBox.EnableWindow();
	}
	if((MultiSell_Input_Button.m_pTargetWnd != none))
	{
		if((canBuyCount <= _minCountCanBuy))
		{
			MultiSell_Input_Button.DisableWindow();
		}
		else
		{
			MultiSell_Input_Button.EnableWindow();
		}
	}
	if((canBuyCount <= Count))
	{
		MultiSell_Up_Button.DisableWindow();
	}
	else
	{
		MultiSell_Up_Button.EnableWindow();
	}
	if((Count <= _minCountCanBuy))
	{
		MultiSell_Down_Button.DisableWindow();
	}
	else
	{
		MultiSell_Down_Button.EnableWindow();
	}
	if((Buy_Btn.m_pTargetWnd != none))
	{
		if((Count >= _minCountCanBuy))
		{
			Buy_Btn.EnableWindow();
		}
		else
		{
			Buy_Btn.DisableWindow();
		}
	}
	return;
}

function _SetPlusBasicUnit(INT64 Unit)
{
	plusbasicunit = Unit;
	return;
}

function _SetForceDisable(bool isForceDisable)
{
	is_force_disable = isForceDisable;
	SetControlerBtns();
	return;
}

function bool _GetForceDisable()
{
	return is_force_disable;
}

function _SetEditBoxDisable(bool IsDisable)
{
	local INT64 canBuyCount;

	is_Editor_disable = IsDisable;
	canBuyCount = DelegateGetCountCanBuy();
	if((((canBuyCount <= _minCountCanBuy) || is_force_disable) || is_Editor_disable))
	{
		ItemCount_EditBox.DisableWindow();
	}
	else
	{
		ItemCount_EditBox.EnableWindow();
	}
	return;
}

function bool _GetEditBoxDisable()
{
	return is_Editor_disable;
}

function _SetEditBoxFontColor(Color Color)
{
	ItemCount_EditBox.SetFontColor(Color);
	return;
}

function _SetUseCaculator(bool bUse)
{
	bUseCalculator = bUse;
	if((MultiSell_Input_Button.m_pTargetWnd == none))
	{
		return;
	}
	if(bUseCalculator)
	{
		MultiSell_Input_Button.ShowWindow();
	}
	else
	{
		MultiSell_Input_Button.HideWindow();
	}
	return;
}

function _SetMinCountCanBuy(INT64 minCOunt)
{
	_minCountCanBuy = minCOunt;
	return;
}
