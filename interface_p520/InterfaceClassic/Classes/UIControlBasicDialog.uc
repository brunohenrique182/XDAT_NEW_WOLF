class UIControlBasicDialog extends UICommonAPI;

var string m_Windowname;
var WindowHandle Me;
var ButtonHandle OKButton;
var ButtonHandle CancleButton;
var HtmlHandle DescriptionHtmlCtrl;
var TextBoxHandle DescriptionTextBox;
var WindowHandle DisableWindow;
var L2Util util;
var int nDialogKey;
var INT64 m_reservedInt64;
var INT64 m_reservedInt64_1;
var INT64 m_reservedInt64_2;
var INT64 m_reservedInt64_3;
var INT64 m_reservedInt64_4;
var int m_reservedInt;
var int m_reservedInt2;
var int m_reservedInt3;
var ItemID m_reservedItemID;
var ItemInfo m_reservedItemInfo;
var string m_reservedString;
//var delegate<DelegateOnClickCancleButton> __DelegateOnClickCancleButton__Delegate;
//var delegate<DelegateOnClickOkButton> __DelegateOnClickOkButton__Delegate;

delegate DelegateOnClickCancleButton(optional int nDialogKey)
{
	return;
}

delegate DelegateOnClickOkButton(optional int nDialogKey)
{
	return;
}

function SetWindow(string WindowName, optional string DisableWindowName)
{
	util = L2Util(GetScript("L2Util"));
	m_Windowname = WindowName;
	if((DisableWindowName != ""))
	{
		DisableWindow = GetWindowHandle(DisableWindowName);
	}
	Me = GetWindowHandle(m_Windowname);
	OKButton = GetButtonHandle((m_Windowname $ ".OkButton"));
	CancleButton = GetButtonHandle((m_Windowname $ ".CancleButton"));
	DescriptionTextBox = GetTextBoxHandle((m_Windowname $ ".DescriptionTextBox"));
	DescriptionHtmlCtrl = GetHtmlHandle((m_Windowname $ ".DescriptionHtmlCtrl"));
	return;
}

function setDialogKey(int pDialogKey)
{
	nDialogKey = pDialogKey;
	return;
}

function int getDialogKey()
{
	return nDialogKey;
}

function setInit(string Desc, optional int nDialogKey, optional int nOkButtonSystemString, optional int nCancelButtonSystemString, optional bool bUseHtml, optional Color TextColor)
{
	setDialogKey(nDialogKey);
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
	Debug(("bUsehtml" @ string(bUseHtml)));
	if(bUseHtml)
	{
		DescriptionTextBox.HideWindow();
		DescriptionHtmlCtrl.ShowWindow();
		DescriptionHtmlCtrl.LoadHtmlFromString(htmlSetHtmlStart(Desc));
		Debug(("html:" @ htmlSetHtmlStart(Desc)));
	}
	else
	{
		DescriptionTextBox.ShowWindow();
		DescriptionTextBox.SetText(Desc);
		DescriptionHtmlCtrl.HideWindow();
	}
	return;
}

function Show()
{
	if(!isNullWindow(DisableWindow))
	{
		DisableWindow.ShowWindow();
	}
	Me.ShowWindow();
	Me.SetFocus();
	return;
}

function Hide()
{
	if(!isNullWindow(DisableWindow))
	{
		DisableWindow.HideWindow();
	}
	Me.HideWindow();
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "OkButton":
			OnClickOKButton();
			break;
		case "CancleButton":
			OnClickCancleButton();
			break;
		default:
			break;
	}
	return;
}

function OnClickOKButton()
{
	DelegateOnClickOkButton(nDialogKey);
	return;
}

function OnClickCancleButton()
{
	Me.HideWindow();
	DelegateOnClickCancleButton(nDialogKey);
	return;
}

function SetReservedInt64(INT64 param)
{
	m_reservedInt64 = param;
	return;
}

function SetReservedInt64_1(INT64 param)
{
	m_reservedInt64_1 = param;
	return;
}

function SetReservedInt64_2(INT64 param)
{
	m_reservedInt64_2 = param;
	return;
}

function SetReservedInt64_3(INT64 param)
{
	m_reservedInt64_3 = param;
	return;
}

function SetReservedInt64_4(INT64 param)
{
	m_reservedInt64_4 = param;
	return;
}

function SetReservedInt(int Value)
{
	m_reservedInt = Value;
	return;
}

function SetReservedInt2(int Value)
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

function int GetReservedInt()
{
	return m_reservedInt;
}

function int GetReservedInt2()
{
	return m_reservedInt2;
}

function int GetReservedInt3()
{
	return m_reservedInt3;
}

function INT64 GetReservedInt64()
{
	return m_reservedInt64;
}

function INT64 GetReservedInt64_1()
{
	return m_reservedInt64_1;
}

function INT64 GetReservedInt64_2()
{
	return m_reservedInt64_2;
}

function INT64 GetReservedInt64_3()
{
	return m_reservedInt64_3;
}

function INT64 GetReservedInt64_4()
{
	return m_reservedInt64_4;
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
