class CardDrawEventWnd extends L2UIGFxScriptNoneContainer;

var string gameTryCount;
var InventoryWnd inventoryWndScript;

function OnRegisterEvent()
{
	RegisterGFxEvent(10240);
	RegisterGFxEvent(10250);
	RegisterGFxEvent(10260);
	RegisterGFxEvent(10270);
	RegisterGFxEvent(10280);
	return;
}

function OnCallUCFunction(string Id, string param)
{
	switch(Id)
	{
		case "getItemCount":
			gameTryCount = string(inventoryWndScript.getItemCountByClassID(int(param)));
			break;
		default:
			break;
	}
	return;
}

function OnShow()
{
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("ItemUpgrade"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ItemUpgrade");
	}
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("ElementalSpiritWnd"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ElementalSpiritWnd");
	}
	super.OnShow();
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	AddState("GAMINGSTATE");
	inventoryWndScript = InventoryWnd(GetScript("inventoryWnd"));
	return;
}

function OnFlashLoaded()
{
	RegisterDelegateHandler(EDHandler_CardUpdownGame);
	RegisterDelegateHandler(EDHandler_GameData);
	return;
}
