class Login extends GFxUIScript;

const FLASH_XPOS = 0;
const FLASH_YPOS = 0;

var array<GFxValue> args;
var GFxValue invokeResult;
var string logInID;
var L2Util util;

function OnRegisterEvent()
{
	RegisterEvent(5630);
	RegisterEvent(5640);
	RegisterEvent(5650);
	RegisterEvent(5700);
	return;
}

function OnLoad()
{
	RegisterState("LogIn", "LoginState");
	SetContainer("ContainerHUD");
	SetHUD();
	SetAlwaysOnTop(true);
	logInID = "";
	HasTextField(false);
	SetAnchor("", ANCHORPOINT_BottomRight, ANCHORPOINT_TopLeft, 0, 0);
	return;
}

function OnShow()
{
	return;
}

function OnFlashLoaded()
{
	return;
}

function OnHide()
{
	return;
}

function OnCallUCFunction(string funcName, string param)
{
	local string Id, Pass;
	local int ncopt;
	local string delString;
	local int i;
	local string URL;

	switch(funcName)
	{
		case "setLogin":
			ParseString(param, "ID", Id);
			SaveLastLoginID(Id);
			ParseString(param, "pass", Pass);
			ParseInt(param, "ncopt", ncopt);
			RequestLogin(Id, Pass, ncopt);
			delString = "";
			i = 0;
			while((i < Len(param)))
			{
				delString = (delString $ "*");
				i++;
			}
			param = delString;
			delString = "";
			i = 0;
			while((i < Len(Pass)))
			{
				delString = (delString $ "*");
				i++;
			}
			Pass = delString;
			delString = "";
			i = 0;
			while((i < Len(Id)))
			{
				delString = (delString $ "*");
				i++;
			}
			Id = delString;
			delString = "";
			i = 0;
			while((i < Len(string(ncopt))))
			{
				delString = (delString $ "0");
				i++;
			}
			ncopt = int(delString);
			param = "";
			Id = "";
			Pass = "";
			ncopt = -1;
			break;
		case "out":
			RefuseLogin();
			break;
		case "openURL":
			URL = GetSystemString(5192);
			OpenGivenURL(URL);
			break;
		default:
			break;
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	local string ErrorMsg;

	if((Event_ID == 5630))
	{
		if((IsShowWindow() == false))
		{
			ShowWindow();
			FlashInit();
			SendErrorMsg("");
		}
	}
	else if((Event_ID == 5650))
	{
		SendLogInSuccess();
	}
	else if((Event_ID == 5640))
	{
		ParseString(param, "ErrorMsg", ErrorMsg);
		SendErrorMsg(ErrorMsg);
	}
	return;
}

function FlashInit()
{
	local string param;

	param = makeVar2Str("logInID", GetLastLoginID());
	param = (param @ makeVar2Str("isOTP", string(IsUseOTP())));
	param = (param @ makeVar2Str("optMsg", GetSystemMessage(5068)));
	param = (param @ makeVar2Str("isUseEMailAccount", string(IsUseEMailAccount())));
	CallGFxFunction("LogIn", "flashInit", param);
	return;
}

function string makeVar2Str(string varName, string vars)
{
	return ((varName $ "=") $ vars);
}

function SendLogInSuccess()
{
	HideWindow();
	CallGFxFunction("LogIn", "loginSuccess", "");
	return;
}

function SendErrorMsg(string ErrorMsg)
{
	CallGFxFunction("LogIn", "ErrorMsg", ErrorMsg);
	return;
}

event OnMouseOver(WindowHandle W)
{
	return;
}

event OnMouseOut(WindowHandle W)
{
	ForceToMoveMousePos(0.0000000, 0.0000000);
	return;
}
