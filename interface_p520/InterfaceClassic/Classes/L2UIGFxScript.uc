class L2UIGFxScript extends GFxUIScript;

const WINDOWTYPE_NONE = "none";
const WINDOWTYPE_DECO_NORMAL = "SkinnedWindow";
const WINDOWTYPE_SUB_WINDOW_TL = "SubWindow_TL";
const WINDOWTYPE_SIMPLE_DRAG = "SimpleDragWindow";
const WINDOWTYPE_NOBG = "SimpleNoBg";
const WINDOWTYPE_NOBG_NODRAG = "SimpleNoBgNoDrag";

var string _windowType;
var string _windowState;
var int _windowTitleID;
var int _stateCount;
var bool _isNotUseESC;
var string containerName;
var WindowHandle m_Container;

function SetContainerHUD(string wndType, int wndTitleID)
{
	containerName = "ContainerHUD";
	SetMyContainer(wndType, wndTitleID);
	_isNotUseESC = true;
	return;
}

function SetContainerWindow(string wndType, int wndTitleID)
{
	containerName = "ContainerWindow";
	SetMyContainer(wndType, wndTitleID);
	_isNotUseESC = false;
	return;
}

function SetMyContainer(string wndType, int wndTitleID)
{
	m_Container = GetWindowHandle(containerName);
	SetContainer(containerName);
	_windowType = wndType;
	_windowTitleID = wndTitleID;
	_stateCount = 0;
	return;
}

function OnFocus(bool bFlag, bool bTransparency)
{
	if(bFlag)
	{
		if((containerName != ""))
		{
			Class'NWindow.UIAPI_WINDOW'.static.SetFocus(containerName);
		}
	}
	return;
}

function AddState(string Str)
{
	RegisterState(getCurrentWindowName(string(self)), Str);
	ParamAdd(_windowState, ("State" $ string(_stateCount)), Str);
	_stateCount++;
	return;
}

function NotUseESC()
{
	_isNotUseESC = false;
	return;
}

static function L2Util getInstanceL2Util()
{
	local L2Util Script;

	Script = L2Util(GetScript("L2Util"));
	return Script;
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

function int EV_PacketID(int nServerPacketID)
{
	return (100000 + nServerPacketID);
}

function bool DialogIsMineWithTarget(string TargetName)
{
	return Class'InterfaceClassic.UICommonAPI'.static.DialogIsMineWithTarget(TargetName);
}
