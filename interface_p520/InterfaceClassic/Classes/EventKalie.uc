class EventKalie extends GFxUIScript;

const FLASH_XPOS = -190;
const FLASH_YPOS = 0;

var int currentScreenWidth;
var int currentScreenHeight;
var bool saveShow;

function setScreenResolution()
{
	local array<GFxValue> args;
	local GFxValue invokeResult;

	GetCurrentResolution(currentScreenWidth, currentScreenHeight);
	AllocGFxValues(args, 2);
	AllocGFxValue(invokeResult);
	args[0].SetInt(currentScreenWidth);
	args[1].SetInt(currentScreenHeight);
	Invoke("setCurrentResolution", args, invokeResult);
	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);
	return;
}

function OnEvent(int Event_ID, string param)
{
	local array<GFxValue> args;
	local GFxValue invokeResult;

	if((Event_ID == 3410))
	{
		if((param == "GAMINGSTATE"))
		{
			if((saveShow == true))
			{
				SetShowWindow();
			}
		}
		else if((param == "CHARACTERSELECTSTATE"))
		{
		}
	}
	else if((Event_ID == 40))
	{
		if(saveShow)
		{
			AllocGFxValues(args, 2);
			AllocGFxValue(invokeResult);
			args[0].SetInt(9435);
			CreateObject(args[1]);
			Invoke("onEvent", args, invokeResult);
			DeallocGFxValue(invokeResult);
			DeallocGFxValues(args);
			saveShow = false;
		}
	}
	return;
}

function SetShowWindow()
{
	if((IsShowWindow() == false))
	{
		ShowWindow();
	}
	return;
}

event OnMouseOut(WindowHandle W)
{
	dispatchEventToFlash_String(0, "");
	return;
}

event OnMouseOver(WindowHandle W)
{
	dispatchEventToFlash_String(1, "");
	return;
}

function dispatchEventToFlash_String(int Event_ID, string argString)
{
	local array<GFxValue> args;
	local GFxValue invokeResult;

	AllocGFxValues(args, 2);
	AllocGFxValue(invokeResult);
	args[0].SetInt(Event_ID);
	CreateObject(args[1]);
	args[1].SetMemberString("string", argString);
	Invoke("onEvent", args, invokeResult);
	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);
	return;
}
