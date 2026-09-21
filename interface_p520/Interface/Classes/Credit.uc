class Credit extends L2UIGFxScript;

const FLASH_WIDTH = 800;
const FLASH_HEIGHT = 600;

var int currentScreenWidth;
var int currentScreenHeight;

function OnRegisterEvent()
{
	RegisterGFxEventForLoaded(2900);
	RegisterGFxEvent(5710);
	RegisterEvent(3410);
	return;
}

function OnLoad()
{
	RegisterState("Credit", "CreditState");
	SetDefaultShow(true);
	return;
}

function OnShow()
{
	return;
}

function OnFlashLoaded()
{
	SetAnchor("", ANCHORPOINT_TopLeft, ANCHORPOINT_TopLeft, 0, 0);
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 3410))
	{
		switch(param)
		{
			case "CREDITSTATE":
				SetTimer(101, 100);
				break;
			default:
				break;
		}
	}
	return;
}

function OnTimer(int TimeID)
{
	if((TimeID == 101))
	{
		SetFocus("Credit");
		KillTimer(101);
		Debug("OnTimer : Set Focus Credit");
	}
	return;
}

function OnCallUCFunction(string functionName, string param)
{
	return;
}

function OnCallUCLogic(int logicID, string param)
{
	if((logicID == 1))
	{
		if((param == "exit"))
		{
			EndCredit();
		}
	}
	return;
}
