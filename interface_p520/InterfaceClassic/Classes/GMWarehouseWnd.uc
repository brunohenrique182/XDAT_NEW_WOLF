class GMWarehouseWnd extends WarehouseWnd;

var bool bShow;

function OnRegisterEvent()
{
	RegisterEvent(2360);
	RegisterEvent(2370);
	return;
}

function OnLoad()
{
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	InitHandle();
	bShow = false;
	return;
}

function OnShow()
{
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("GMWarehouseWnd.OKButton");
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("GMWarehouseWnd.CancelButton");
	return;
}

function ShowWarehouse(string a_Param)
{
	if((a_Param == ""))
	{
		return;
	}
	if(bShow)
	{
		Clear();
		m_hOwnerWnd.HideWindow();
		bShow = false;
	}
	else
	{
		Class'NWindow.GMAPI'.static.RequestGMCommand(GMCOMMAND_WarehouseInfo, a_Param);
		bShow = true;
	}
	return;
}

function OnClickButton(string strID)
{
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 2360:
			HandleGMObservingWarehouseItemListStart(a_Param);
			break;
		case 2370:
			HandleGMObservingWarehouseItemList(a_Param);
			break;
		default:
			break;
	}
	return;
}

function HandleGMObservingWarehouseItemListStart(string a_Param)
{
	HandleOpenWindow(a_Param);
	return;
}

function HandleGMObservingWarehouseItemList(string a_Param)
{
	HandleAddItem(a_Param);
	return;
}

function MoveItemTopToBottom(int Index, bool bAllItem)
{
	return;
}

function MoveItemBottomToTop(int Index, bool bAllItem)
{
	return;
}

defaultproperties
{
	m_Windowname="GMWarehouseWnd"
}
