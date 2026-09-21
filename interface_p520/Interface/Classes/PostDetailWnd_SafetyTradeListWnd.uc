class PostDetailWnd_SafetyTradeListWnd extends UICommonAPI;

var WindowHandle Me;
var string m_Windowname;
var RichListCtrlHandle ItemList;
var PostDetailWnd_SafetyTrade PostDetailWnd_SafetyTradeScript;
var WindowHandle Empty_Wnd;

event OnLoad()
{
	InitializeCOD();
	Me.HideWindow();
	return;
}

function InitializeCOD()
{
	Me = GetWindowHandle(m_Windowname);
	ItemList = GetRichListCtrlHandle((m_Windowname $ ".ItemList"));
	PostDetailWnd_SafetyTradeScript = PostDetailWnd_SafetyTrade(GetScript("PostDetailWnd_SafetyTrade"));
	ItemList.SetSelectedSelTooltip(false);
	ItemList.SetAppearTooltipAtMouseX(true);
	ItemList.SetUseStripeBackTexture(false);
	Empty_Wnd = GetWindowHandle((m_Windowname $ ".Empty_Wnd"));
	return;
}

event OnClickButton(string a_ButtonID)
{
	PostDetailWnd_SafetyTradeScript.OnClickButton(a_ButtonID);
	return;
}

function Clear()
{
	ItemList.DeleteAllItem();
	Empty_Wnd.ShowWindow();
	return;
}

function AddItem(string param)
{
	local ItemInfo Info;

	ParamToItemInfo(param, Info);
	ItemList.InsertRecord(makeRecord(Info));
	PostDetailWnd_SafetyTradeScript._AddWeight((Info.Weight * int(Info.ItemNum)));
	Empty_Wnd.HideWindow();
	return;
}

function int GetItemListCount()
{
	return ItemList.GetRecordCount();
}

function RichListCtrlRowData makeRecord(ItemInfo Info)
{
	local RichListCtrlRowData Record;
	local string fullNameString;
	local Color tmpTextColor;
	local string toolTipParam;

	Record.cellDataList.Length = 1;
	fullNameString = GetItemNameAll(Info);
	if((int(byte(Info.EtcItemType)) == 7))
	{
		Info.Id.ServerID = -1;
	}
	ItemInfoToParam(Info, toolTipParam);
	Record.szReserved = toolTipParam;
	Record.cellDataList[0].szData = fullNameString;
	addRichListCtrlTexture(Record.cellDataList[0].drawitems, Info.IconName, 32, 32, 10, 0);
	if((Info.IconPanel != ""))
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, Info.IconPanel, 32, 32, -32, 0);
	}
	tmpTextColor = GetColor(170, 153, 119, 255);
	AddRichListCtrlString(Record.cellDataList[0].drawitems, fullNameString, tmpTextColor, false, 5, 2);
	AddRichListCtrlString(Record.cellDataList[0].drawitems, ("x" $ MakeCostString(string(Info.ItemNum))), tmpTextColor, true, 47, 0);
	return Record;
}

function HandleShow()
{
	Me.ShowWindow();
	return;
}

function HandleHide()
{
	Me.HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="PostDetailWnd_SafetyTradeListWnd"
}
