class LogInLoading extends GFxUIScript;

const FLASH_XPOS = 0;
const FLASH_YPOS = 0;

var array<GFxValue> args;
var GFxValue invokeResult;
var int CurrEventID;
var L2Util util;

function OnRegisterEvent()
{
	RegisterEvent(5660);
	RegisterEvent(5661);
	RegisterEvent(5670);
	RegisterEvent(5671);
	RegisterEvent(3410);
	return;
}

function OnLoad()
{
	RegisterState("LogInLoading", "LOGINWAITSTATE");
	RegisterState("LogInLoading", "TelephoneAuthState");
	SetAnchor("", ANCHORPOINT_BottomRight, ANCHORPOINT_TopLeft, 0, 0);
	SetContainer("ContainerHUD");
	SetAlwaysOnTop(true);
	CurrEventID = 0;
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

function OnFocus(bool bFlag, bool bTransparency)
{
	return;
}

function OnCallUCFunction(string logicID, string param)
{
	local string cardNum;

	if((logicID == "0"))
	{
		ParseString(param, "cardNum", cardNum);
		if((CurrEventID == 5671))
		{
			RequestGoogleOtpLogin(cardNum);
		}
		else
		{
			RequestSecurityCardLogin(param);
		}
	}
	else if((logicID == "1"))
	{
		if((CurrEventID == 5671))
		{
			RequestExit();
		}
		else
		{
			RequestCardKeyLoginCancel();
		}
	}
	else if((logicID == "2"))
	{
		StopLogin();
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	if(isChinaVer())
	{
		return;
	}
	if((Event_ID == 5660))
	{
		if((IsShowWindow() == false))
		{
			ShowWindow();
			SendLoading(param);
		}
	}
	else if((Event_ID == 5661))
	{
		if((IsShowWindow() == false))
		{
			ShowWindow();
			SendTelephoneWait(param);
		}
	}
	if((Event_ID == 5670))
	{
		if((IsShowWindow() == false))
		{
			ShowWindow();
			SendSecurityCard(param);
		}
	}
	if((Event_ID == 5671))
	{
		CurrEventID = Event_ID;
		ShowWindow();
		SendSecurityCard(param);
	}
	if((Event_ID == 3410))
	{
		CallGFxFunction("LogInLoading", "StateChange", ("state=" $ param));
		HideWindow();
	}
	return;
}

function SendLoading(string param)
{
	local string Msg;

	ParseString(param, "WaitMsg", Msg);
	CallGFxFunction("LogInLoading", "SendLoading", ("eventID=0 msg=" $ Msg));
	return;
}

function SendTelephoneWait(string param)
{
	local string Msg;

	ParseString(param, "WaitMsg", Msg);
	CallGFxFunction("LogInLoading", "SendTelephoneWait", ("eventID=5 msg=" $ Msg));
	return;
}

function SendSecurityCard(string param)
{
	local string Msg;

	ParseString(param, "msg", Msg);
	CallGFxFunction("LogInLoading", "SendSecurityCard", ("eventID=10 msg=" $ Msg));
	return;
}

function bool isChinaVer()
{
	return (4 == int(GetLanguage()));
}

function bool isOldChinaVer()
{
	return ((4 == int(GetLanguage())) && !IsAdenServer());
}
