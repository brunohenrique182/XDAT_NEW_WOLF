class ContainerWindow extends L2UIGFxScript;

event OnLoad()
{
	SetSaveWnd(true, false);
	SetClosingOnESC();
	RegisterState("ContainerWindow", "GAMINGSTATE");
	RegisterState("ContainerWindow", "TRAININGROOMSTATE");
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
	return;
}

event OnFlashLoaded()
{
	local GFxValue l2SysStringTranslator, Obj;

	RegisterDelegateHandler(EDHandler_AlchemyAPI);
	RegisterDelegateHandler(EDHandler_Event10thAnniversary);
	RegisterDelegateHandler(EDHandler_TrainingRoomWnd);
	RegisterDelegateHandler(EDHandler_LuckyGameWnd);
	RegisterDelegateHandler(EDHandler_EventCardWnd);
	RegisterDelegateHandler(EDHandler_Container);
	RegisterDelegateHandler(EDHandler_ShortcutAPI);
	RegisterDelegateHandler(EDHandler_Option);
	RegisterDelegateHandler(EDHandler_VipSystem);
	RegisterDelegateHandler(EDHandler_InputAPI);
	RegisterDelegateHandler(EDHandler_PledgeRecruit);
	RegisterDelegateHandler(EDHandler_AdenaDistributionWnd);
	RegisterDelegateHandler(EDHandler_OlympiadArenaList);
	RegisterDelegateHandler(EDHandler_Default);
	RegisterDelegateHandler(EDHandler_FactionWnd);
	RegisterDelegateHandler(EDHandler_Arena);
	RegisterDelegateHandler(EDHandler_RadarMap);
	RegisterDelegateHandler(EDHandler_GameData);
	RegisterDelegateHandler(EDHandler_PledgeWnd);
	RegisterDelegateHandler(EDHandler_ElementalSpirit);
	RegisterDelegateHandler(EDHandler_Minimap);
	RegisterDelegateHandler(EDHandler_ClassChange);
	RegisterDelegateHandler(EDHandler_TeleportList);
	RegisterDelegateHandler(EDHandler_HuntingZone);
	AllocGFxValue(l2SysStringTranslator);
	AllocGFxValue(Obj);
	GetFunction(l2SysStringTranslator, EFunc_SysStringTranslator);
	Obj.SetMemberValue("getTranslatedString", l2SysStringTranslator);
	DeallocGFxValue(l2SysStringTranslator);
	DeallocGFxValue(Obj);
	return;
}

event OnEvent(int a_EventID, string a_Param)
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

event OnHide()
{
	InvokeToFlash("onHide");
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
