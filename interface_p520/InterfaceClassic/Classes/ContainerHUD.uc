class ContainerHUD extends GFxUIScript;

var string registedState;

event OnLoad()
{
	SetSaveWnd(true, false);
	SetClosingOnESC();
	SetDefaultShow(true);
	SetHUD();
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(3411);
	RegisterGFxEvent(2900);
	RegisterGFxEvent(6200);
	RegisterGFxEvent(1710);
	RegisterGFxEvent(1720);
	RegisterGFxEvent(9570);
	RegisterGFxEvent(9570);
	RegisterEvent(3410);
	return;
}

event OnCallUCFunction(string functionName, string param)
{
	switch(functionName)
	{
		case "focusContainer":
			SetFocus();
			break;
		default:
			break;
	}
	return;
}

event OnFlashLoaded()
{
	local GFxValue l2SysStringTranslator, Obj;

	RegisterDelegateHandler(EDHandler_Container);
	RegisterDelegateHandler(EDHandler_ChatWnd);
	RegisterDelegateHandler(EDHandler_Container);
	RegisterDelegateHandler(EDHandler_ShortcutAPI);
	RegisterDelegateHandler(EDHandler_Option);
	RegisterDelegateHandler(EDHandler_InputAPI);
	RegisterDelegateHandler(EDHandler_RadarMap);
	RegisterDelegateHandler(EDHandler_UseSkill);
	RegisterDelegateHandler(EDHandler_FishWnd);
	RegisterDelegateHandler(EDHandler_Arena);
	AllocGFxValue(l2SysStringTranslator);
	AllocGFxValue(Obj);
	GetFunction(l2SysStringTranslator, EFunc_SysStringTranslator);
	Obj.SetMemberValue("getTranslatedString", l2SysStringTranslator);
	DeallocGFxValue(l2SysStringTranslator);
	DeallocGFxValue(Obj);
	return;
}

event OnFocus(bool bFlag, bool bTransparency)
{
	local array<GFxValue> args;
	local GFxValue invokeResult;

	AllocGFxValues(args, 2);
	args[0].SetBool(bFlag);
	args[1].SetBool(bTransparency);
	AllocGFxValue(invokeResult);
	Invoke("onFocusContainer", args, invokeResult);
	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);
	return;
}

event OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 3411:
			HandleNotifyBeforeStateChanged(a_Param);
			break;
		case 3410:
			if((a_Param == "CHARACTERCREATESTATE"))
			{
				SetAlwaysOnBack(true);
			}
			else if((a_Param == "GAMINGSTATE"))
			{
				SetAlwaysOnBack(true);
			}
			break;
		default:
			break;
	}
	return;
}

event OnReceivedCloseUI()
{
	InvokeToFlash("onPressESC");
	return;
}

event OnDefaultPosition()
{
	InvokeToFlash("onDefaultPosition");
	return;
}

function InvokeToFlash(string invokeID)
{
	local array<GFxValue> args;
	local GFxValue invokeResult;

	AllocGFxValues(args, 1);
	Invoke(invokeID, args, invokeResult);
	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);
	return;
}

function HandleNotifyBeforeStateChanged(string param)
{
	local array<GFxValue> args;
	local GFxValue invokeResult;

	AllocGFxValues(args, 2);
	AllocGFxValue(invokeResult);
	args[0].SetInt(3411);
	CreateObject(args[1]);
	args[1].SetMemberString("state", param);
	Invoke("onEvent", args, invokeResult);
	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);
	return;
}
