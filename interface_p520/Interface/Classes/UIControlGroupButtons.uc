class UIControlGroupButtons extends UICommonAPI;

var array<ButtonHandle> buttonGroup;
var array<TextureHandle> iconTextureGroup;
var string ForeTexture;
var string backTexture;
var string highlightTexture;
var int currentTabIndex;
var bool bUseLongButtonTextTooltip;
var bool bUseOverlapClickPrevention;
var bool bSelectUnSelectColor;
var Color selectColor;
var Color unSelectColor;
var ButtonHandle currentSelectedButtonHandle;
var UIMapStringObject mapBtnTexObj;
var UIMapStringObject mapIconTexObj;
var string _reservedString;
var int _reservedInt;
var INT64 _reservedInt64;
//var delegate<DelegateOnClickButton> __DelegateOnClickButton__Delegate;
//var delegate<DelegateOnOverButton> __DelegateOnOverButton__Delegate;
//var delegate<DelegateOnOutButton> __DelegateOnOutButton__Delegate;

delegate DelegateOnClickButton(string parentWindowName, string strName, int currentTabIndex)
{
	return;
}

delegate DelegateOnOverButton(string parentWindowName, string strName, int currentTabIndex, bool bSelect)
{
	return;
}

delegate DelegateOnOutButton(string parentWindowName, string strName, int currentTabIndex, bool bSelect)
{
	return;
}

function _SetStartInfo(string pForeTexture, string pBackTexture, string pHighlightTexture, optional bool pBUseLongButtonTextTooltip)
{
	ForeTexture = pForeTexture;
	backTexture = pBackTexture;
	highlightTexture = pHighlightTexture;
	bUseLongButtonTextTooltip = pBUseLongButtonTextTooltip;
	mapBtnTexObj = new Class'Interface.UIMapStringObject';
	mapIconTexObj = new Class'Interface.UIMapStringObject';
	_clearAll();
	return;
}

function _setUseOverlapClickPrevention(bool bFlag)
{
	bUseOverlapClickPrevention = bFlag;
	return;
}

function bool _getUseOverlapClickPrevention()
{
	return bUseOverlapClickPrevention;
}

function _addButtonController(ButtonHandle btn, optional string buttonText, optional int buttonValue)
{
	if((buttonText != ""))
	{
		btn.SetNameText(buttonText);
		if(bUseLongButtonTextTooltip)
		{
			btn.SetTooltipText(buttonText);
		}
	}
	else if(bUseLongButtonTextTooltip)
	{
		btn.SetTooltipText(btn.GetButtonName());
	}
	setCheckLongButtonTextTooltip(btn);
	btn.SetButtonValue(buttonValue);
	buttonGroup[buttonGroup.Length] = btn;
	iconTextureGroup[iconTextureGroup.Length] = none;
	_setButtonTextureByName(btn.GetWindowName(), ForeTexture, backTexture, highlightTexture);
	return;
}

function setCheckLongButtonTextTooltip(ButtonHandle btn)
{
	local Rect R;
	local int W, h;

	if(!bUseLongButtonTextTooltip)
	{
		return;
	}
	R = btn.GetRect();
	GetTextSizeDefault(btn.GetTooltipText(), W, h);
	if((R.nWidth < (W + 4)))
	{
		btn.SetNameText(makeShortStringByPixel(btn.GetTooltipText(), (R.nWidth - 16), "..."));
		btn.SetTooltipType("text");
		btn.SetTooltipCustomType(MakeTooltipSimpleText(btn.GetTooltipText()));
	}
	else
	{
		btn.SetNameText(btn.GetTooltipText());
		btn.SetTooltipType("");
	}
	return;
}

function _clearAll()
{
	local ButtonHandle tempButtonHandle;

	currentTabIndex = -1;
	buttonGroup.Length = 0;
	iconTextureGroup.Length = 0;
	bUseLongButtonTextTooltip = false;
	bUseOverlapClickPrevention = false;
	currentSelectedButtonHandle = tempButtonHandle;
	_reservedString = "";
	_reservedInt = 0;
	_reservedInt64 = INT64(0);
	mapBtnTexObj.RemoveAll();
	mapIconTexObj.RemoveAll();
	return;
}

function _setButtonTexture(int buttonIndex, string pForeTexture, string pBackTexture, string pHighlightTexture)
{
	local string strParam;

	buttonGroup[buttonIndex].SetTexture(pForeTexture, pBackTexture, pHighlightTexture);
	ParamAdd(strParam, "ForeTexture", pForeTexture);
	ParamAdd(strParam, "BackTexture", pBackTexture);
	ParamAdd(strParam, "HighlightTexture", pHighlightTexture);
	mapBtnTexObj.Add(string(buttonIndex), strParam);
	return;
}

function _setButtonTextureByName(string buttonHandleName, string pForeTexture, string pBackTexture, string pHighlightTexture)
{
	local string strParam;
	local int i;

	i = 0;
	while((i < buttonGroup.Length))
	{
		if((buttonGroup[i].GetWindowName() == buttonHandleName))
		{
			buttonGroup[i].SetTexture(pForeTexture, pBackTexture, pHighlightTexture);
			ParamAdd(strParam, "ForeTexture", pForeTexture);
			ParamAdd(strParam, "BackTexture", pBackTexture);
			ParamAdd(strParam, "HighlightTexture", pHighlightTexture);
			mapBtnTexObj.Add(string(i), strParam);
			break;
		}
		i++;
	}
	return;
}

function _setButtonText(int buttonIndex, string buttonText)
{
	buttonGroup[buttonIndex].SetNameText(buttonText);
	buttonGroup[buttonIndex].SetTooltipText(buttonText);
	setCheckLongButtonTextTooltip(buttonGroup[buttonIndex]);
	return;
}

function _setButtonTextColor(Color selectColorP, Color unSelectColorP)
{
	local int i;

	bSelectUnSelectColor = true;
	selectColor = selectColorP;
	unSelectColor = unSelectColorP;
	i = 0;
	while((i < buttonGroup.Length))
	{
		buttonGroup[i].SetDefaultTextEnableColor(unSelectColorP);
		i++;
	}
	return;
}

function _setButtonTextColorClear()
{
	bSelectUnSelectColor = false;
	return;
}

function _setButtonTextByName(string buttonHandleName, string buttonText)
{
	local int i;

	i = 0;
	while((i < buttonGroup.Length))
	{
		if((buttonGroup[i].GetWindowName() == buttonHandleName))
		{
			buttonGroup[i].SetNameText(buttonText);
			buttonGroup[i].SetTooltipText(buttonText);
			setCheckLongButtonTextTooltip(buttonGroup[i]);
			break;
		}
		i++;
	}
	return;
}

function _setButtonTextDefaultColor(int buttonIndex, Color enableColor, Color disableColor)
{
	if((buttonIndex < buttonGroup.Length))
	{
		buttonGroup[buttonIndex].SetDefaultTextEnableColor(enableColor);
		buttonGroup[buttonIndex].SetDefaultTextDisableColor(disableColor);
	}
	return;
}

function _setButtonTooltip(int buttonIndex, string tooltipText)
{
	if((buttonIndex < buttonGroup.Length))
	{
		buttonGroup[buttonIndex].SetTooltipType("Text");
		buttonGroup[buttonIndex].SetTooltipCustomType(MakeTooltipSimpleText(tooltipText));
	}
	return;
}

function _HideAllButtons()
{
	local int i;

	i = 0;
	while((i < buttonGroup.Length))
	{
		buttonGroup[i].HideWindow();
		i++;
	}
	i = 0;
	while((i < iconTextureGroup.Length))
	{
		if((iconTextureGroup[i] != none))
		{
			iconTextureGroup[i].HideWindow();
		}
		i++;
	}
	return;
}

function _setShowButtonNum(optional int showButtonNum)
{
	local int i;

	if((showButtonNum <= 0))
	{
		return;
	}
	_HideAllButtons();
	i = 0;
	while((i < showButtonNum))
	{
		buttonGroup[i].ShowWindow();
		if((iconTextureGroup[i] != none))
		{
			iconTextureGroup[i].ShowWindow();
		}
		i++;
	}
	return;
}

function _OverButton(string buttonHandleName)
{
	local int i;
	local string strIconParam, pIconOverTexture;

	if((buttonHandleName == ""))
	{
		return;
	}
	if((_getSelectButtonName() == buttonHandleName))
	{
		DelegateOnOverButton(buttonGroup[_getSelectButtonIndex()].GetParentWindowName(), buttonHandleName, _getSelectButtonIndex(), true);
	}
	else
	{
		i = 0;
		while((i < buttonGroup.Length))
		{
			if((buttonGroup[i].GetWindowName() == buttonHandleName))
			{
				if(mapIconTexObj.HasKey(string(i)))
				{
					strIconParam = "";
					strIconParam = mapIconTexObj.Find(string(i));
					ParseString(strIconParam, "over", pIconOverTexture);
					if((iconTextureGroup[i] != none))
					{
						iconTextureGroup[i].SetTexture(pIconOverTexture);
					}
				}
				DelegateOnOverButton(buttonGroup[i].GetParentWindowName(), buttonHandleName, i, false);
			}
			i++;
		}
	}
	return;
}

function _OverButtonHandle(WindowHandle ButtonHandle)
{
	local int i;
	local string strIconParam, pIconOverTexture;

	if((ButtonHandle == none))
	{
		return;
	}
	if((currentSelectedButtonHandle == ButtonHandle))
	{
		DelegateOnOverButton(ButtonHandle.GetParentWindowName(), ButtonHandle.GetWindowName(), _getSelectButtonIndex(), true);
	}
	else
	{
		i = 0;
		while((i < buttonGroup.Length))
		{
			if((buttonGroup[i] == ButtonHandle))
			{
				if(mapIconTexObj.HasKey(string(i)))
				{
					strIconParam = "";
					strIconParam = mapIconTexObj.Find(string(i));
					ParseString(strIconParam, "over", pIconOverTexture);
					if((iconTextureGroup[i] != none))
					{
						iconTextureGroup[i].SetTexture(pIconOverTexture);
					}
				}
				DelegateOnOverButton(ButtonHandle.GetParentWindowName(), ButtonHandle.GetWindowName(), i, false);
			}
			i++;
		}
	}
	return;
}

function _OutButton(string buttonHandleName)
{
	local int i;
	local string strIconParam, pIconNormalTexture, pIconNormalSelectTexture;

	if((buttonHandleName == ""))
	{
		return;
	}
	if((_getSelectButtonName() == buttonHandleName))
	{
		i = 0;
		while((i < buttonGroup.Length))
		{
			if((buttonGroup[i].GetWindowName() == buttonHandleName))
			{
				if(mapIconTexObj.HasKey(string(i)))
				{
					strIconParam = "";
					strIconParam = mapIconTexObj.Find(string(i));
					ParseString(strIconParam, "normalSelect", pIconNormalSelectTexture);
					if((iconTextureGroup[i] != none))
					{
						iconTextureGroup[i].SetTexture(pIconNormalSelectTexture);
					}
				}
				DelegateOnOutButton(buttonGroup[i].GetParentWindowName(), buttonHandleName, i, true);
			}
			i++;
		}
	}
	else
	{
		i = 0;
		while((i < buttonGroup.Length))
		{
			if((buttonGroup[i].GetWindowName() == buttonHandleName))
			{
				if(mapIconTexObj.HasKey(string(i)))
				{
					strIconParam = "";
					strIconParam = mapIconTexObj.Find(string(i));
					ParseString(strIconParam, "normal", pIconNormalTexture);
					if((iconTextureGroup[i] != none))
					{
						iconTextureGroup[i].SetTexture(pIconNormalTexture);
					}
				}
				DelegateOnOutButton(buttonGroup[i].GetParentWindowName(), buttonHandleName, i, false);
			}
			i++;
		}
	}
	return;
}

function _OutButtonHandle(WindowHandle ButtonHandle)
{
	local int i;
	local string strIconParam, pIconNormalSelectTexture, pIconNormalTexture;

	if((ButtonHandle == none))
	{
		return;
	}
	if((currentSelectedButtonHandle == ButtonHandle))
	{
		i = 0;
		while((i < buttonGroup.Length))
		{
			if((buttonGroup[i] == ButtonHandle))
			{
				if(mapIconTexObj.HasKey(string(i)))
				{
					strIconParam = "";
					strIconParam = mapIconTexObj.Find(string(i));
					ParseString(strIconParam, "normalSelect", pIconNormalSelectTexture);
					if((iconTextureGroup[i] != none))
					{
						iconTextureGroup[i].SetTexture(pIconNormalSelectTexture);
					}
				}
				DelegateOnOutButton(buttonGroup[i].GetParentWindowName(), ButtonHandle.GetWindowName(), i, true);
			}
			i++;
		}
	}
	else
	{
		i = 0;
		while((i < buttonGroup.Length))
		{
			if((buttonGroup[i] == ButtonHandle))
			{
				if(mapIconTexObj.HasKey(string(i)))
				{
					strIconParam = "";
					strIconParam = mapIconTexObj.Find(string(i));
					ParseString(strIconParam, "normal", pIconNormalTexture);
					if((iconTextureGroup[i] != none))
					{
						iconTextureGroup[i].SetTexture(pIconNormalTexture);
					}
				}
				DelegateOnOutButton(buttonGroup[i].GetParentWindowName(), ButtonHandle.GetWindowName(), i, false);
			}
			i++;
		}
	}
	return;
}

function _DownButton(string buttonHandleName)
{
	local int i;
	local string strIconParam, pIconDownTexture;

	if((buttonHandleName == ""))
	{
		return;
	}
	if(((_getSelectButtonName() == buttonHandleName) && (bUseOverlapClickPrevention == false)))
	{
	}
	else
	{
		i = 0;
		while((i < buttonGroup.Length))
		{
			if((buttonGroup[i].GetWindowName() == buttonHandleName))
			{
				if(mapIconTexObj.HasKey(string(i)))
				{
					strIconParam = "";
					strIconParam = mapIconTexObj.Find(string(i));
					ParseString(strIconParam, "down", pIconDownTexture);
					if((iconTextureGroup[i] != none))
					{
						iconTextureGroup[i].SetTexture(pIconDownTexture);
					}
				}
			}
			i++;
		}
	}
	return;
}

function _DownButtonHandle(WindowHandle ButtonHandle)
{
	local int i;
	local string strIconParam, pIconDownTexture;

	if((ButtonHandle == none))
	{
		return;
	}
	if(((currentSelectedButtonHandle == ButtonHandle) && (bUseOverlapClickPrevention == false)))
	{
	}
	else
	{
		i = 0;
		while((i < buttonGroup.Length))
		{
			if((buttonGroup[i] == ButtonHandle))
			{
				if(mapIconTexObj.HasKey(string(i)))
				{
					strIconParam = "";
					strIconParam = mapIconTexObj.Find(string(i));
					ParseString(strIconParam, "down", pIconDownTexture);
					if((iconTextureGroup[i] != none))
					{
						iconTextureGroup[i].SetTexture(pIconDownTexture);
					}
				}
			}
			i++;
		}
	}
	return;
}

function _selectButton(string buttonHandleName, optional bool doNotRunDelegateOnClick, optional bool bForceSelect)
{
	local int i;
	local string strParam, pForeTexture, pBackTexture, pHighlightTexture, strIconParam, pIconNormalTexture, pIconSelectNormalTexture;

	if(((bUseOverlapClickPrevention == false) && (bForceSelect == false)))
	{
		if((_getSelectButtonName() == buttonHandleName))
		{
			return;
		}
	}
	i = 0;
	while((i < buttonGroup.Length))
	{
		if(mapBtnTexObj.HasKey(string(i)))
		{
			strParam = "";
			strParam = mapBtnTexObj.Find(string(i));
			ParseString(strParam, "ForeTexture", pForeTexture);
			ParseString(strParam, "BackTexture", pBackTexture);
			ParseString(strParam, "HighlightTexture", pHighlightTexture);
		}
		else
		{
			pHighlightTexture = highlightTexture;
			pBackTexture = backTexture;
			pHighlightTexture = highlightTexture;
		}
		if(mapIconTexObj.HasKey(string(i)))
		{
			strIconParam = "";
			strIconParam = mapIconTexObj.Find(string(i));
			ParseString(strIconParam, "normalSelect", pIconSelectNormalTexture);
			ParseString(strIconParam, "normal", pIconNormalTexture);
		}
		if((buttonGroup[i].GetWindowName() == buttonHandleName))
		{
			buttonGroup[i].SetTexture(pBackTexture, pBackTexture, pBackTexture);
			if((iconTextureGroup[i] != none))
			{
				iconTextureGroup[i].SetTexture(pIconSelectNormalTexture);
			}
			currentTabIndex = i;
			currentSelectedButtonHandle = buttonGroup[i];
			if(bSelectUnSelectColor)
			{
				buttonGroup[i].SetDefaultTextEnableColor(selectColor);
			}
			i++;
			continue;
		}
		if(hasButtonGroupButtonName(buttonHandleName))
		{
			buttonGroup[i].SetTexture(pForeTexture, pBackTexture, pHighlightTexture);
			if((iconTextureGroup[i] != none))
			{
				iconTextureGroup[i].SetTexture(pIconNormalTexture);
			}
			if(bSelectUnSelectColor)
			{
				buttonGroup[i].SetDefaultTextEnableColor(unSelectColor);
			}
			i++;
			continue;
		}
		i++;
		continue;
		i++;
	}
	if(((doNotRunDelegateOnClick == false) && hasButtonGroupButtonName(buttonHandleName)))
	{
		DelegateOnClickButton(buttonGroup[currentTabIndex].GetParentWindowName(), buttonHandleName, currentTabIndex);
	}
	return;
}

function _selectButtonHandle(ButtonHandle ButtonHandle, optional bool doNotRunDelegateOnClick, optional bool bForceSelect)
{
	local int i;
	local string strParam, pForeTexture, pBackTexture, pHighlightTexture, strIconParam, pIconNormalTexture, pIconSelectNormalTexture;

	if(((bUseOverlapClickPrevention == false) && (bForceSelect == false)))
	{
		if((currentSelectedButtonHandle == ButtonHandle))
		{
			return;
		}
	}
	i = 0;
	while((i < buttonGroup.Length))
	{
		if(mapBtnTexObj.HasKey(string(i)))
		{
			strParam = "";
			strParam = mapBtnTexObj.Find(string(i));
			ParseString(strParam, "ForeTexture", pForeTexture);
			ParseString(strParam, "BackTexture", pBackTexture);
			ParseString(strParam, "HighlightTexture", pHighlightTexture);
		}
		else
		{
			pHighlightTexture = highlightTexture;
			pBackTexture = backTexture;
			pHighlightTexture = highlightTexture;
		}
		if(mapIconTexObj.HasKey(string(i)))
		{
			strIconParam = "";
			strIconParam = mapIconTexObj.Find(string(i));
			ParseString(strIconParam, "normalSelect", pIconSelectNormalTexture);
			ParseString(strIconParam, "normal", pIconNormalTexture);
		}
		if((buttonGroup[i] == ButtonHandle))
		{
			buttonGroup[i].SetTexture(pBackTexture, pBackTexture, pBackTexture);
			if((iconTextureGroup[i] != none))
			{
				iconTextureGroup[i].SetTexture(pIconSelectNormalTexture);
			}
			currentTabIndex = i;
			currentSelectedButtonHandle = ButtonHandle;
			if(bSelectUnSelectColor)
			{
				buttonGroup[i].SetDefaultTextEnableColor(selectColor);
			}
			i++;
			continue;
		}
		if(hasButtonGroupButtonHandle(ButtonHandle))
		{
			buttonGroup[i].SetTexture(pForeTexture, pBackTexture, pHighlightTexture);
			if((iconTextureGroup[i] != none))
			{
				iconTextureGroup[i].SetTexture(pIconNormalTexture);
			}
			if(bSelectUnSelectColor)
			{
				buttonGroup[i].SetDefaultTextEnableColor(unSelectColor);
			}
			i++;
			continue;
		}
		i++;
		continue;
		i++;
	}
	if(((doNotRunDelegateOnClick == false) && hasButtonGroupButtonHandle(ButtonHandle)))
	{
		DelegateOnClickButton(ButtonHandle.GetParentWindowName(), ButtonHandle.GetWindowName(), currentTabIndex);
	}
	return;
}

function bool hasButtonGroupButtonHandle(ButtonHandle ButtonHandle)
{
	local int i;

	i = 0;
	while((i < buttonGroup.Length))
	{
		if((buttonGroup[i] == ButtonHandle))
		{
			return true;
		}
		i++;
	}
	return false;
}

function bool hasButtonGroupButtonName(string buttonHandleName)
{
	local int i;

	i = 0;
	while((i < buttonGroup.Length))
	{
		if((buttonGroup[i].GetWindowName() == buttonHandleName))
		{
			return true;
		}
		i++;
	}
	return false;
}

function _setTopOrder(int tabNum, optional bool doNotRunDelegateOnClick, optional bool bDoNotRunForce)
{
	_selectButtonHandle(buttonGroup[tabNum], doNotRunDelegateOnClick, !bDoNotRunForce);
	currentTabIndex = tabNum;
	return;
}

function _setTopOrderForce(int tabNum, optional bool doNotRunDelegateOnClick)
{
	_selectButtonHandle(buttonGroup[tabNum], doNotRunDelegateOnClick, true);
	currentTabIndex = tabNum;
	return;
}

function _setButtonValue(int i, int Value)
{
	buttonGroup[i].SetButtonValue(Value);
	return;
}

function _setButtonValueByName(string buttonHandleName, int Value)
{
	local int i;

	i = 0;
	while((i < buttonGroup.Length))
	{
		if((buttonGroup[i].GetWindowName() == buttonHandleName))
		{
			buttonGroup[i].SetButtonValue(Value);
			break;
		}
		i++;
	}
	return;
}

function int _FindButtonIndexByValue(int Value)
{
	local int i;

	i = 0;
	while((i < buttonGroup.Length))
	{
		if((buttonGroup[i].GetButtonValue() == Value))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function int _getButtonValue(int i)
{
	return buttonGroup[i].GetButtonValue();
}

function int _getButtonValueByName(string buttonHandleName)
{
	local int i;

	i = 0;
	while((i < buttonGroup.Length))
	{
		if((buttonGroup[i].GetWindowName() == buttonHandleName))
		{
			return buttonGroup[i].GetButtonValue();
		}
		i++;
	}
	return -1;
}

function int _getSelectedButtonValue()
{
	return _getButtonValue(_getSelectButtonIndex());
}

function ButtonHandle _getButtonHandle(int i)
{
	return buttonGroup[i];
}

function _setTextureLoc(int buttonIndex, TextureHandle Tex, int addX, int addY, optional string alignXStr)
{
	local Rect R;
	local int alignX;

	R = _getButtonHandle(buttonIndex).GetRect();
	if((alignXStr == "right"))
	{
		alignX = (R.nWidth - Tex.GetRect().nWidth);
	}
	else if((alignXStr == "center"))
	{
		alignX = ((R.nWidth / 2) - (Tex.GetRect().nWidth / 2));
	}
	else
	{
		alignX = 0;
	}
	Tex.ClearAnchor();
	Tex.MoveTo(((R.nX + addX) + alignX), (R.nY + addY));
	return;
}

function _setTextureLocByName(string buttonHandleName, TextureHandle Tex, int addX, int addY, optional string alignXStr)
{
	local Rect R;
	local int alignX;

	R = _getButtonHandleByName(buttonHandleName).GetRect();
	if((alignXStr == "right"))
	{
		alignX = (R.nWidth - Tex.GetRect().nWidth);
	}
	else if((alignXStr == "center"))
	{
		alignX = ((R.nWidth / 2) - (Tex.GetRect().nWidth / 2));
	}
	else
	{
		alignX = 0;
	}
	Tex.ClearAnchor();
	Tex.MoveTo(((R.nX + addX) + alignX), (R.nY + addY));
	return;
}

function _setConnectIconTexture(int buttonIndex, TextureHandle Tex, int addX, int addY, optional string alignXStr, optional string normalTextureStr, optional string normalSelectTextureStr, optional string overTextureStr, optional string downTextureStr, optional string disableTextureStr)
{
	local string strParam;

	_setTextureLoc(buttonIndex, Tex, addX, addY, alignXStr);
	ParamAdd(strParam, "normal", normalTextureStr);
	ParamAdd(strParam, "down", downTextureStr);
	ParamAdd(strParam, "over", overTextureStr);
	ParamAdd(strParam, "normalSelect", normalSelectTextureStr);
	ParamAdd(strParam, "disable", disableTextureStr);
	Tex.SetTexture(normalTextureStr);
	Tex.ShowWindow();
	iconTextureGroup[buttonIndex] = Tex;
	mapIconTexObj.Add(string(buttonIndex), strParam);
	return;
}

function _setdisconnectIconTexture(int buttonIndex)
{
	if((iconTextureGroup[buttonIndex] != none))
	{
		iconTextureGroup[buttonIndex].HideWindow();
	}
	iconTextureGroup[buttonIndex] = none;
	return;
}

function _setdisconnectIconTextureAll()
{
	local int i;

	i = 0;
	while((i < iconTextureGroup.Length))
	{
		_setdisconnectIconTexture(i);
		i++;
	}
	return;
}

function ButtonHandle _getButtonHandleByName(string buttonHandleName)
{
	local int i;

	i = 0;
	while((i < buttonGroup.Length))
	{
		if((buttonGroup[i].GetWindowName() == buttonHandleName))
		{
			return buttonGroup[i];
		}
		i++;
	}
	return none;
}

function int _getSelectButtonIndex()
{
	return currentTabIndex;
}

function string _getSelectButtonName()
{
	if((currentTabIndex == -1))
	{
		return "";
	}
	return buttonGroup[currentTabIndex].GetWindowName();
}

function _SetDisable(int tabNum, optional bool bDoNoUseDisableWindow)
{
	local string strIconParam, pDisableTexture;

	if(mapIconTexObj.HasKey(string(tabNum)))
	{
		strIconParam = "";
		strIconParam = mapIconTexObj.Find(string(tabNum));
		ParseString(strIconParam, "disable", pDisableTexture);
		if((iconTextureGroup[tabNum] != none))
		{
			iconTextureGroup[tabNum].SetTexture(pDisableTexture);
		}
	}
	if((bDoNoUseDisableWindow == false))
	{
		buttonGroup[tabNum].DisableWindow();
	}
	return;
}

function _setDisableTextureAll(string texString)
{
	local int i;

	i = 0;
	while((i < buttonGroup.Length))
	{
		buttonGroup[i].SetDisableTexture(texString);
		i++;
	}
	return;
}

function _SetEnable(int tabNum, optional bool bDoNoUseEnableWindow)
{
	local string strIconParam, pnormalSelectTexture, pNormalTexture;

	if(mapIconTexObj.HasKey(string(tabNum)))
	{
		strIconParam = "";
		strIconParam = mapIconTexObj.Find(string(tabNum));
		ParseString(strIconParam, "normal", pNormalTexture);
		ParseString(strIconParam, "normalSelect", pnormalSelectTexture);
		if((_getSelectButtonIndex() == tabNum))
		{
			if((iconTextureGroup[tabNum] != none))
			{
				iconTextureGroup[tabNum].SetTexture(pnormalSelectTexture);
			}
		}
		else if((iconTextureGroup[tabNum] != none))
		{
			iconTextureGroup[tabNum].SetTexture(pNormalTexture);
		}
	}
	if((bDoNoUseEnableWindow == false))
	{
		buttonGroup[tabNum].EnableWindow();
	}
	return;
}

function _setDisableByName(string buttonHandleName)
{
	local int i;
	local string strIconParam, pDisableTexture;

	i = 0;
	while((i < buttonGroup.Length))
	{
		if((buttonGroup[i].GetWindowName() == buttonHandleName))
		{
			if(mapIconTexObj.HasKey(string(i)))
			{
				strIconParam = "";
				strIconParam = mapIconTexObj.Find(string(i));
				ParseString(strIconParam, "disable", pDisableTexture);
				if((iconTextureGroup[i] != none))
				{
					iconTextureGroup[i].SetTexture(pDisableTexture);
				}
			}
			buttonGroup[i].DisableWindow();
			break;
		}
		i++;
	}
	return;
}

function _setEnableByName(string buttonHandleName)
{
	local int i;

	i = 0;
	while((i < buttonGroup.Length))
	{
		if((buttonGroup[i].GetWindowName() == buttonHandleName))
		{
			_SetEnable(i);
			break;
		}
		i++;
	}
	return;
}

function _setDisableAll(optional bool bDoNoUseDisableWindow)
{
	local int i;

	i = 0;
	while((i < buttonGroup.Length))
	{
		_SetDisable(i, bDoNoUseDisableWindow);
		i++;
	}
	return;
}

function _setEnableAll(optional bool bDoNoUseEnableWindow)
{
	local int i;

	i = 0;
	while((i < buttonGroup.Length))
	{
		_SetEnable(i, bDoNoUseEnableWindow);
		i++;
	}
	return;
}

function int _getShowButtonNum()
{
	local int i, Num;

	i = 0;
	while((i < buttonGroup.Length))
	{
		if(buttonGroup[i].IsShowWindow())
		{
			Num++;
		}
		i++;
	}
	return Num;
}

function _setAutoWidth(int nTotalWidth, int nGap)
{
	local int nWidth;

	nWidth = ((nTotalWidth - (nGap * (_getShowButtonNum() - 1))) / _getShowButtonNum());
	autoWidthCalculate(nTotalWidth, nWidth, nGap);
	return;
}

function autoWidthCalculate(int nTotalWidth, int nWidth, int nGap)
{
	local int i, addGap, total;
	local Rect R;

	total = _getShowButtonNum();
	i = 0;
	while((i < total))
	{
		if((i == 0))
		{
			R = buttonGroup[i].GetRect();
			addGap = 0;
		}
		else if((i == (total - 1)))
		{
			addGap = ((nGap * i) + (nWidth * i));
			nWidth = (nTotalWidth - (nWidth * (total - 1)));
		}
		else
		{
			addGap = ((nGap * i) + (nWidth * i));
		}
		buttonGroup[i].SetWindowSize(nWidth, R.nHeight);
		buttonGroup[i].MoveTo((R.nX + addGap), R.nY);
		setCheckLongButtonTextTooltip(buttonGroup[i]);
		i++;
	}
	return;
}

function _fixedWidth(int nWidth, int nGap)
{
	local int i, addGap;
	local Rect R;

	i = 0;
	while((i < _getShowButtonNum()))
	{
		if((i == 0))
		{
			R = buttonGroup[i].GetRect();
			addGap = 0;
		}
		else
		{
			addGap = ((nGap * i) + (nWidth * i));
		}
		buttonGroup[i].SetWindowSize(nWidth, R.nHeight);
		buttonGroup[i].MoveTo((R.nX + addGap), R.nY);
		setCheckLongButtonTextTooltip(buttonGroup[i]);
		i++;
	}
	return;
}

function _setButtonHeight(int nHeight)
{
	local int i;
	local Rect R;

	i = 0;
	while((i < _getShowButtonNum()))
	{
		if((i == 0))
		{
			R = buttonGroup[i].GetRect();
		}
		buttonGroup[i].SetWindowSize(R.nWidth, nHeight);
		i++;
	}
	return;
}

function _setMultilineButton(int nTotalWidth, int nWidth, int nHeight, int wGap, int hGap)
{
	local int i, M, addGap, NLine;
	local Rect R;

	i = 0;
	while((i < _getShowButtonNum()))
	{
		if((i == 0))
		{
			R = buttonGroup[i].GetRect();
			M = 0;
		}
		else
		{
			addGap = ((wGap * M) + (nWidth * M));
		}
		M++;
		buttonGroup[i].SetWindowSize(nWidth, nHeight);
		buttonGroup[i].MoveTo((R.nX + addGap), (R.nY + ((nHeight + hGap) * NLine)));
		setCheckLongButtonTextTooltip(buttonGroup[i]);
		addGap = ((wGap * M) + (nWidth * M));
		if((nTotalWidth <= (addGap + nWidth)))
		{
			NLine++;
			M = 0;
			addGap = 0;
		}
		i++;
	}
	return;
}

function _setMultilineButtonCenterByAsset(int ButtonWidth, int ButtonHeight, int ButtonsPerRow, int ButtonCount, int GapX, int GapY)
{
	local int Rows, Cols, CurrentButton, XOffset, YOffset, TotalButtonHeight, i, j;
	local Rect R;
	local int TotalWidth, TotalHeight, FirstX, FirstY;

	R = buttonGroup[0].GetParentWindowHandle().GetRect();
	FirstX = R.nX;
	FirstY = R.nY;
	TotalWidth = R.nWidth;
	TotalHeight = R.nHeight;
	Rows = (((ButtonCount + ButtonsPerRow) - 1) / ButtonsPerRow);
	TotalButtonHeight = ((Rows * ButtonHeight) + ((Rows - 1) * GapY));
	CurrentButton = 0;
	i = 0;
	while((i < Rows))
	{
		Cols = Min(ButtonsPerRow, (ButtonCount - CurrentButton));
		XOffset = ((TotalWidth - ((Cols * ButtonWidth) + ((Cols - 1) * GapX))) / 2);
		YOffset = (((TotalHeight - TotalButtonHeight) / 2) + (i * (ButtonHeight + GapY)));
		j = 0;
		while((j < Cols))
		{
			buttonGroup[CurrentButton].SetWindowSize(ButtonWidth, ButtonHeight);
			buttonGroup[CurrentButton].MoveTo(((FirstX + XOffset) + (j * (ButtonWidth + GapX))), (FirstY + YOffset));
			setCheckLongButtonTextTooltip(buttonGroup[CurrentButton]);
			CurrentButton++;
			j++;
		}
		i++;
	}
	return;
}

function _setMultilineButtonCenterByRect(Rect R, int ButtonWidth, int ButtonHeight, int ButtonsPerRow, int ButtonCount, int GapX, int GapY)
{
	local int Rows, Cols, CurrentButton, XOffset, YOffset, TotalButtonHeight, i, j, TotalWidth, TotalHeight, FirstX, FirstY;

	FirstX = R.nX;
	FirstY = R.nY;
	TotalWidth = R.nWidth;
	TotalHeight = R.nHeight;
	Debug(("firstX" @ string(FirstX)));
	Debug(("firstY" @ string(FirstY)));
	Rows = (((ButtonCount + ButtonsPerRow) - 1) / ButtonsPerRow);
	TotalButtonHeight = ((Rows * ButtonHeight) + ((Rows - 1) * GapY));
	CurrentButton = 0;
	i = 0;
	while((i < Rows))
	{
		Cols = Min(ButtonsPerRow, (ButtonCount - CurrentButton));
		XOffset = ((TotalWidth - ((Cols * ButtonWidth) + ((Cols - 1) * GapX))) / 2);
		YOffset = (((TotalHeight - TotalButtonHeight) / 2) + (i * (ButtonHeight + GapY)));
		j = 0;
		while((j < Cols))
		{
			buttonGroup[CurrentButton].SetWindowSize(ButtonWidth, ButtonHeight);
			buttonGroup[CurrentButton].MoveTo(((FirstX + XOffset) + (j * (ButtonWidth + GapX))), (FirstY + YOffset));
			setCheckLongButtonTextTooltip(buttonGroup[CurrentButton]);
			CurrentButton++;
			j++;
		}
		i++;
	}
	return;
}
