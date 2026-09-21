class ProgressBox extends UICommonAPI;

var WindowHandle Me;
var ButtonHandle btnCancle;
var ButtonHandle btnOk;
var TextBoxHandle txtProgress;
var ItemWindowHandle EnchantAttributeSlot;
var ItemWindowHandle EnchantItemSlot;
var bool m_bInUse;
var string m_strTargetScript;
var string m_strEditMessage;
var string _message;
var string _target;
var int _time;
var ItemInfo _infoAttribute;
var ItemInfo _item;
var ProgressCtrlHandle m_hProgressBoxprogressCtrl;

function OnRegisterEvent()
{
	RegisterEvent(580);
	return;
}

function OnLoad()
{
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	Initialize();
	Load();
	return;
}

function Initialize()
{
	m_strTargetScript = "";
	m_bInUse = false;
	if((1 == 0))
	{
		Me = GetHandle("ProgressBox");
		btnCancle = ButtonHandle(GetHandle("ProgressBox.btnCancle"));
		btnOk = ButtonHandle(GetHandle("ProgressBox.btnOK"));
		txtProgress = TextBoxHandle(GetHandle("ProgressBox.txtProgress"));
		EnchantAttributeSlot = ItemWindowHandle(GetHandle("ProgressBox.EnchantAttributeSlot"));
		EnchantItemSlot = ItemWindowHandle(GetHandle("ProgressBox.EnchantItemSlot"));
	}
	else
	{
		Me = GetWindowHandle("ProgressBox");
		btnCancle = GetButtonHandle("ProgressBox.btnCancle");
		btnOk = GetButtonHandle("ProgressBox.btnOK");
		txtProgress = GetTextBoxHandle("ProgressBox.txtProgress");
		EnchantAttributeSlot = GetItemWindowHandle("ProgressBox.EnchantAttributeSlot");
		EnchantItemSlot = GetItemWindowHandle("ProgressBox.EnchantItemSlot");
		m_hProgressBoxprogressCtrl = GetProgressCtrlHandle("ProgressBox.progressCtrl");
	}
	return;
}

function Load()
{
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "btnCancle":
			OnbtnCancleClick();
			break;
		case "btnOK":
			OnBtnOkClick();
			break;
		default:
			break;
	}
	return;
}

function OnBtnOkClick()
{
	m_hProgressBoxprogressCtrl.Start();
	m_bInUse = true;
	return;
}

function OnbtnCancleClick()
{
	local AttributeEnchantWnd scriptAttributeEnchant;

	if((m_strTargetScript == "AttributeEnchantWnd"))
	{
		m_hProgressBoxprogressCtrl.Reset();
		Me.HideWindow();
		m_bInUse = false;
		ShowWindow("AttributeEnchantWnd");
	}
	scriptAttributeEnchant = AttributeEnchantWnd(GetScript("AttributeEnchantWnd"));
	scriptAttributeEnchant.DisableCurrentWindow(false);
	return;
}

function ShowDialog(string Message, string Target, int Time, ItemInfo infoAttribute, ItemInfo item)
{
	if(m_bInUse)
	{
		return;
	}
	if((Time == 0))
	{
		return;
	}
	_message = Message;
	_target = Target;
	_time = Time;
	_infoAttribute = infoAttribute;
	_item = item;
	EnchantAttributeSlot.Clear();
	EnchantItemSlot.Clear();
	EnchantAttributeSlot.SetItem(0, _infoAttribute);
	EnchantAttributeSlot.AddItem(_infoAttribute);
	EnchantItemSlot.SetItem(0, _item);
	EnchantItemSlot.AddItem(_item);
	m_hProgressBoxprogressCtrl.SetProgressTime(_time);
	m_hProgressBoxprogressCtrl.Reset();
	Me.ShowWindow();
	Me.SetFocus();
	SetMessage(_message);
	m_strTargetScript = Target;
	return;
}

function OnProgressTimeUp(string strID)
{
	local AttributeEnchantWnd scriptAttributeEnchant;

	if((strID == "progressCtrl"))
	{
		if((m_strTargetScript == "AttributeEnchantWnd"))
		{
			scriptAttributeEnchant = AttributeEnchantWnd(GetScript("AttributeEnchantWnd"));
			scriptAttributeEnchant.DisableCurrentWindow(false);
			Me.HideWindow();
			Initialize();
			scriptAttributeEnchant.OnOKClick();
		}
	}
	return;
}

function SetMessage(string strMessage)
{
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("ProgressBox.txtProgress", strMessage);
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	local int SystemMsgIndex;
	local string ParamString1, ParamString2;

	if((a_EventID == 580))
	{
		ParseInt(a_Param, "Index", SystemMsgIndex);
		ParseString(a_Param, "Param1", ParamString1);
		ParseString(a_Param, "Param2", ParamString2);
		if(((SystemMsgIndex > 61) && (SystemMsgIndex < 66)))
		{
			DialogShow(DialogModalType_Modalless, DialogType_Notice, MakeFullSystemMsg(GetSystemMessage(SystemMsgIndex), ParamString1, ParamString2));
		}
	}
	return;
}
