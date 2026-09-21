class ItemUpgrade extends L2UIGFxScriptNoneContainer;

function OnRegisterEvent()
{
	RegisterGFxEvent(10190);
	RegisterGFxEvent(10191);
	RegisterGFxEvent(10192);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	RegisterState("ItemUpgrade", "GamingState");
	RegisterState("ItemUpgrade", "ARENAGAMINGSTATE");
	SetAnchor("", ANCHORPOINT_CenterCenter, ANCHORPOINT_CenterCenter, 0, 0);
	return;
}

function OnShow()
{
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("CardDrawEventWnd");
	super.OnShow();
	L2Util(GetScript("L2Util")).ItemRelationWindowHide(getCurrentWindowName(string(self)));
	return;
}

function OnFlashLoaded()
{
	RegisterDelegateHandler(EDHandler_UpgradeSystemWnd);
	RegisterDelegateHandler(EDHandler_Container);
	RegisterDelegateHandler(EDHandler_Default);
	RegisterDelegateHandler(EDHandler_GameData);
	return;
}

function OnCallUCFunction(string functionName, string param)
{
	switch(functionName)
	{
		case "OpenHelpHTML":
			OnClickHelp();
			break;
		default:
			break;
	}
	return;
}

function OnClickHelp()
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		if(IsAdenServer())
		{
			Class'InterfaceClassic.HelpWnd'.static.ShowHelp(134);
		}
		else
		{
			Class'InterfaceClassic.HelpWnd'.static.ShowHelp(125);
		}
	}
	return;
}
