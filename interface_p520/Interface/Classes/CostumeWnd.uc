class CostumeWnd extends L2UIGFxScriptNoneContainer;

function OnRegisterEvent()
{
	RegisterGFxEvent(20250);
	RegisterGFxEvent(20251);
	RegisterGFxEvent(20252);
	RegisterGFxEvent(20253);
	RegisterGFxEvent(20254);
	RegisterGFxEvent(20255);
	RegisterGFxEvent(20256);
	RegisterGFxEvent(20257);
	RegisterGFxEvent(20258);
	RegisterGFxEvent(9570);
	RegisterGFxEvent(40);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	AddState("GAMINGSTATE");
	SetAnchor("", ANCHORPOINT_CenterCenter, ANCHORPOINT_CenterCenter, 0, 0);
	return;
}

function OnShow()
{
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("CardDrawEventWnd"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("CardDrawEventWnd");
	}
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("ItemUpgrade"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ItemUpgrade");
	}
	super.OnShow();
	L2Util(GetScript("L2Util")).ItemRelationWindowHide(getCurrentWindowName(string(self)));
	return;
}

function OnFlashLoaded()
{
	RegisterDelegateHandler(EDHandler_Costume);
	RegisterDelegateHandler(EDHandler_Container);
	RegisterDelegateHandler(EDHandler_Default);
	RegisterDelegateHandler(EDHandler_GameData);
	RegisterDelegateHandler(EDHandler_Option);
	RegisterDelegateHandler(EDHandler_UseSkill);
	return;
}

function OnCallUCFunction(string functionName, string param)
{
	return;
}
