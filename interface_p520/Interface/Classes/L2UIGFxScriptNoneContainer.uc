class L2UIGFxScriptNoneContainer extends GFxUIScript;

function AddState(string Str)
{
	RegisterState(getCurrentWindowName(string(self)), Str);
	SetStateChangeNotification();
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 3411:
			HandleNotifyBeforeStateChanged(a_Param);
			break;
		default:
			break;
	}
	return;
}

function OnFocus(bool bFlag, bool bTransparency)
{
	local array<GFxValue> args;
	local GFxValue invokeResult;

	Debug(("onFocus !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" @ string(bFlag)));
	AllocGFxValues(args, 2);
	args[0].SetBool(bFlag);
	args[1].SetBool(bTransparency);
	AllocGFxValue(invokeResult);
	Invoke("onFocusContainer", args, invokeResult);
	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);
	return;
}

function OnHide()
{
	InvokeToFlash("onHide");
	return;
}

function OnShow()
{
	Debug((getCurrentWindowName(string(self)) @ "onShow"));
	InvokeToFlash("onShow");
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

function OnReceivedCloseUI()
{
	InvokeToFlash("onPressESC");
	return;
}

function OnDefaultPosition()
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

static function UIData getInstanceUIData()
{
	return UIData(GetScript("UIData"));
}

static function string getCurrentWindowName(string targetString)
{
	local array<string> ArrayStr;

	Split(targetString, ".", ArrayStr);
	return ArrayStr[1];
}

static function int Split(string strInput, string delim, out array<string> arrToken)
{
	local int arrSize;

	while((InStr(strInput, delim) > 0))
	{
		arrToken.Insert(arrToken.Length, 1);
		arrToken[(arrToken.Length - 1)] = Left(strInput, InStr(strInput, delim));
		strInput = Mid(strInput, (InStr(strInput, delim) + 1));
		arrSize = (arrSize + 1);
	}
	arrToken.Insert(arrToken.Length, 1);
	arrToken[(arrToken.Length - 1)] = strInput;
	arrSize = (arrSize + 1);
	return arrSize;
}
