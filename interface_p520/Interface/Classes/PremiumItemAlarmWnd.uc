class PremiumItemAlarmWnd extends UICommonAPI;

var WindowHandle Me;
var TextureHandle CTextureCtrl1038;
var TextBoxHandle CTextBox1039;
var ButtonHandle btnOk;

function OnLoad()
{
	Initialize();
	Load();
	return;
}

function Initialize()
{
	if((1 == 0))
	{
		Me = GetHandle("PremiumItemAlarmWnd");
		CTextureCtrl1038 = TextureHandle(GetHandle("CFrameWnd461.CTextureCtrl1038"));
		CTextBox1039 = TextBoxHandle(GetHandle("CFrameWnd461.CTextBox1039"));
		btnOk = ButtonHandle(GetHandle("CFrameWnd461.CButton1414"));
	}
	else
	{
		Me = GetWindowHandle("PremiumItemAlarmWnd");
		CTextureCtrl1038 = GetTextureHandle("CFrameWnd461.CTextureCtrl1038");
		CTextBox1039 = GetTextBoxHandle("CFrameWnd461.CTextBox1039");
		btnOk = GetButtonHandle("CFrameWnd461.CButton1414");
	}
	return;
}

function Load()
{
	return;
}

function OnEvent(int Event_ID, string param)
{
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "btnOK":
			Me.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function OnExitState(name a_CurrentStateName)
{
	Me.HideWindow();
	return;
}
