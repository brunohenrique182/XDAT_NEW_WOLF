class UIControlSliderWithValue extends UICommonAPI;

var SliderCtrlHandle mainSlider;
var TextBoxHandle TitleTextBox;
var EditBoxHandle valueEditBox;
var int _minValue;
var int _maxValue;
var int _value;
//var delegate<DelegateOnValueChanged> __DelegateOnValueChanged__Delegate;

delegate DelegateOnValueChanged(UIControlSliderWithValue Owner)
{
	return;
}

function Init(WindowHandle Owner)
{
	local string ownerFullPath;

	ownerFullPath = Owner.m_WindowNameWithFullPath;
	mainSlider = GetSliderCtrlHandle((ownerFullPath $ ".mainSlider"));
	TitleTextBox = GetTextBoxHandle((ownerFullPath $ ".titleTextBox"));
	valueEditBox = GetEditBoxHandle((ownerFullPath $ ".valueEditBox"));
	_SetValueText(_GetValue());
	return;
}

event OnModifyCurrentTickSliderCtrl(string strID, int CurrentValue)
{
	local int validValue;

	if((strID == "mainSlider"))
	{
		validValue = (CurrentValue + _minValue);
		_value = validValue;
		_SetValueText(validValue);
		DelegateOnValueChanged(self);
	}
	return;
}

event OnCompleteEditBox(string strID)
{
	local int Value;

	if((strID == "valueEditBox"))
	{
		Value = int(valueEditBox.GetString());
		_SetValue(Value);
	}
	return;
}

function _SetTitle(string Title)
{
	TitleTextBox.SetText(Title);
	return;
}

function string _GetTitle()
{
	return TitleTextBox.GetText();
}

function _SetValue(int Value)
{
	local int sliderCurrentTick;

	_value = Value;
	sliderCurrentTick = (Value - _minValue);
	mainSlider.SetCurrentTick(sliderCurrentTick);
	return;
}

function _SetValueTextEditable(bool isEditable)
{
	valueEditBox.SetEditable(isEditable);
	return;
}

function _SetValueText(int Value)
{
	valueEditBox.SetString(string(Value));
	return;
}

function int _GetValue()
{
	return _value;
}

function _SetMinMaxValue(int MinValue, int MaxValue)
{
	_minValue = MinValue;
	_maxValue = MaxValue;
	mainSlider.SetTotalTickCount(((MaxValue - MinValue) + 1));
	return;
}

function int _GetMinValue()
{
	return _minValue;
}

function int _GetMaxValue()
{
	return _maxValue;
}
