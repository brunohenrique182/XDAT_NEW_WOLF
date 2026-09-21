class CollectionSystemProgressComponent extends UICommonAPI;

var WindowHandle Me;
var string m_Windowname;
var L2Util util;
var ButtonHandle Rhombus_BTN;
var TextBoxHandle CompletedNum_txt;
var TextBoxHandle TotalNum_txt;
var StatusRoundHandle Rhombus_gauge;
//var delegate<DelegateOnButtonClick> __DelegateOnButtonClick__Delegate;

delegate DelegateOnButtonClick()
{
	return;
}

function Initialize()
{
	util = L2Util(GetScript("L2Util"));
	CompletedNum_txt = GetTextBoxHandle((m_Windowname $ ".CompletedNum_txt"));
	TotalNum_txt = GetTextBoxHandle((m_Windowname $ ".TotalNum_txt"));
	Class'NWindow.UIAPI_WINDOW'.static.SetAnchor((m_Windowname $ ".TotalNum_txt"), (m_Windowname $ ".CompletedNum_txt"), "BottomRight", "BottomLeft", 2, 0);
	Rhombus_BTN = GetButtonHandle((m_Windowname $ ".Rhombus_BTN"));
	Rhombus_gauge = GetStatusRoundHandle((m_Windowname $ ".Rhombus_gauge"));
	return;
}

function Init(string WindowName)
{
	m_Windowname = WindowName;
	Me = GetWindowHandle(m_Windowname);
	Initialize();
	SetPoint(100, 100);
	return;
}

function SetPoint(int Min, int Max)
{
	Rhombus_gauge.SetPoint(INT64(Min), INT64(Max));
	CompletedNum_txt.SetText(string(Min));
	TotalNum_txt.SetText(("/" $ string(Max)));
	Rhombus_BTN.SetNameText((string(int(((float(Min) / float(Max)) * 100.0000000))) $ "%"));
	return;
}

function SetEnable()
{
	Rhombus_BTN.EnableWindow();
	return;
}

function SetDisable()
{
	Rhombus_BTN.DisableWindow();
	return;
}

event OnClickButton(string btnName)
{
	switch(btnName)
	{
		case "Rhombus_BTN":
			DelegateOnButtonClick();
			break;
		default:
			break;
	}
	return;
}
