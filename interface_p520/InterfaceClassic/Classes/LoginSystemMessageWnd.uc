class LoginSystemMessageWnd extends GFxUIScript;

var array<string> stateArr;
var array<int> titleSystemInt;

function OnRegisterEvent()
{
	RegisterEvent(3410);
	RegisterEvent(581);
	RegisterEvent(9740);
	return;
}

function OnLoad()
{
	local int i;

	SetAnchor("", ANCHORPOINT_BottomRight, ANCHORPOINT_TopLeft, 0, 0);
	stateArr[0] = "EULAMSGSTATE";
	stateArr[1] = "SERVERLISTSTATE";
	stateArr[2] = "CHARACTERSELECTSTATE";
	if(LogInMenu(GetScript("LoginMenu")).useMiniLogo)
	{
		titleSystemInt[0] = 0;
		titleSystemInt[1] = 0;
	}
	else
	{
		titleSystemInt[0] = 2686;
		titleSystemInt[1] = 2693;
	}
	titleSystemInt[2] = 157;
	i = 0;
	while((i < stateArr.Length))
	{
		RegisterState("loginSystemMessageWnd", stateArr[i]);
		i++;
	}
	SetHavingFocus(false);
	SetHUD();
	SetContainer("ContainerHUD");
	SetDefaultShow(true);
	SetAlwaysFullAlpha(true);
	SetMsgPassThrough(true);
	return;
}

function HandleShowMessage(string systemMessage)
{
	dispatchEventToFlash_String(3, systemMessage);
	return;
}

function OnEvent(int Event_ID, string a_Param)
{
	local string Msg;

	switch(Event_ID)
	{
		case 3410:
			HandleStateChange(a_Param);
			break;
		case 581:
			ParseString(a_Param, "Message", Msg);
			HandleShowMessage(Msg);
			break;
		case 9740:
			handleShowDeleteFail(a_Param);
			break;
		default:
			break;
	}
	return;
}

function handleShowDeleteFail(string a_Param)
{
	local int Type, msgInt;
	local string systemMessage;

	ParseInt(a_Param, "type", Type);
	switch(Type)
	{
		case 0:
			return;
			break;
		case 1:
			msgInt = 306;
			break;
		case 2:
			msgInt = 541;
			break;
		case 3:
			msgInt = 540;
			break;
		case 4:
			msgInt = 3091;
			break;
		case 5:
			msgInt = 3529;
			break;
		case 6:
			msgInt = 3716;
			break;
		case 8:
			msgInt = 4198;
			break;
		default:
			break;
	}
	systemMessage = GetSystemMessage(msgInt);
	dispatchEventToFlash_String(3, systemMessage);
	return;
}

function HandleStateChange(string a_Param)
{
	local int stateNum;

	stateNum = chkState(a_Param);
	if((stateNum != -1))
	{
		dispatchEventToFlash_Int(1, titleSystemInt[stateNum]);
	}
	else
	{
		dispatchEventToFlash_Int(2, -1);
	}
	return;
}

function int chkState(string State)
{
	local int i;

	i = 0;
	while((i < stateArr.Length))
	{
		if((State == stateArr[i]))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function handleShowKindOfAccount(string a_Param)
{
	local int premiumLevel, kindOfAccount[20];

	kindOfAccount[0] = 5097;
	kindOfAccount[1] = 5098;
	ParseInt(a_Param, "premiumLevel", premiumLevel);
	dispatchEventToFlash_Int(4, kindOfAccount[premiumLevel]);
	return;
}

function dispatchEventToFlash_String(int Event_ID, string argString)
{
	CallGFxFunction("LoginSystemMessageWnd", "logSystemMsgFunc", ((("eventID=" $ string(Event_ID)) @ "string=") $ argString));
	return;
}

function dispatchEventToFlash_Int(int Event_ID, int argInt)
{
	CallGFxFunction("LoginSystemMessageWnd", "logSystemMsgFunc", ((("eventID=" $ string(Event_ID)) @ "num=") $ string(argInt)));
	return;
}
