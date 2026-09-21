class HennaListWndLive extends UICommonAPI;

const FEE_OFFSET_Y_EQUIP = -23;
const FEE_OFFSET_Y_UNEQUIP = -21;
const HENNA_EQUIP = 1;
const HENNA_UNEQUIP = 2;

struct AddHennaStruct
{
	var string Name;
	var string Description;
	var string IconName;
	var int HennaID;
	var int ClassID;
	var INT64 NumberOfItem;
	var INT64 Fee;
	var int needCount;
	var int CancelCount;
};

var string m_Windowname;
var WindowHandle Me;
var ButtonHandle btnHenna;
var RichListCtrlHandle ListCtrl;
var int m_iState;
var int m_iRootNameLength;
var bool m_bDrawBg;
var L2Util util;

function OnRegisterEvent()
{
	RegisterEvent(1640);
	RegisterEvent(1650);
	RegisterEvent(1670);
	RegisterEvent(1680);
	RegisterEvent(1671);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	m_bDrawBg = true;
	Me = GetWindowHandle(m_Windowname);
	btnHenna = GetButtonHandle((m_Windowname $ ".btnHenna"));
	ListCtrl = GetRichListCtrlHandle((m_Windowname $ ".HennaListLc"));
	ListCtrl.SetUseHorizontalScrollBar(true);
	util = L2Util(GetScript("L2Util"));
	ListCtrl.SetSelectedSelTooltip(false);
	ListCtrl.SetAppearTooltipAtMouseX(true);
	return;
}

function Clear()
{
	ListCtrl.DeleteAllItem();
	btnHenna.DisableWindow();
	return;
}

function OnEvent(int Event_ID, string param)
{
	local INT64 iAdena;

	if(getInstanceUIData().GetIsClassicServer())
	{
		return;
	}
	switch(Event_ID)
	{
		case 1640:
			m_iState = 1;
			Clear();
			ParseINT64(param, "Adena", iAdena);
			ShowHennaListWnd(iAdena);
			break;
		case 1650:
		case 1680:
			AddHennaListItem(param);
			break;
		case 1670:
			m_iState = 2;
			Clear();
			ParseINT64(param, "Adena", iAdena);
			ShowHennaListWnd(iAdena);
			break;
		case 1671:
			OnReceivedCloseUI();
			break;
		default:
			break;
	}
	return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
	if((ListCtrlID == "HennaListLc"))
	{
		RequestSelectedHennaItemInfo();
	}
	return;
}

function OnClickListCtrlRecord(string strID)
{
	local int idx;
	local RichListCtrlRowData rowData;

	if((strID == "HennaListLc"))
	{
		idx = ListCtrl.GetSelectedIndex();
		if((idx <= -1))
		{
			btnHenna.DisableWindow();
			return;
		}
		ListCtrl.GetRec(idx, rowData);
		btnHenna.EnableWindow();
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "btnHenna":
			RequestSelectedHennaItemInfo();
			break;
		default:
			break;
	}
	return;
}

function OnShow()
{
	GetWindowHandle("HennaInfoWndLive").HideWindow();
	return;
}

function RequestSelectedHennaItemInfo()
{
	local int idx;
	local RichListCtrlRowData rowData;

	idx = ListCtrl.GetSelectedIndex();
	if((idx <= -1))
	{
		return;
	}
	ListCtrl.GetRec(idx, rowData);
	if((m_iState == 1))
	{
		HennaInfoWndLive(GetScript("HennaInfoWndLive")).needCount = rowData.nReserved2;
		RequestHennaItemInfo(int(rowData.nReserved1));
	}
	else if((m_iState == 2))
	{
		RequestHennaUnEquipInfo(int(rowData.nReserved1));
	}
	return;
}

function ShowHennaListWnd(INT64 iAdena)
{
	if((m_iState == 1))
	{
		setWindowTitleByString(GetSystemString(651));
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".txtList"), GetSystemString(659));
		btnHenna.SetButtonName(651);
	}
	else if((m_iState == 2))
	{
		setWindowTitleByString(GetSystemString(652));
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".txtList"), GetSystemString(660));
		btnHenna.SetButtonName(652);
	}
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".txtAdena"), MakeCostString(string(iAdena)));
	Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString((m_Windowname $ ".txtAdena"), ConvertNumToText(string(iAdena)));
	Me.ShowWindow();
	Me.SetFocus();
	return;
}

function AddHennaStruct ParmaToStruct(string param)
{
	local AddHennaStruct hennaData;

	ParseString(param, "Name", hennaData.Name);
	ParseString(param, "Description", hennaData.Description);
	ParseString(param, "IconName", hennaData.IconName);
	ParseInt(param, "HennaID", hennaData.HennaID);
	ParseInt(param, "ClassID", hennaData.ClassID);
	ParseINT64(param, "NumberOfItem", hennaData.NumberOfItem);
	ParseINT64(param, "Fee", hennaData.Fee);
	if((m_iState == 1))
	{
		ParseInt(param, "NeedCount", hennaData.needCount);
	}
	else if((m_iState == 2))
	{
		ParseInt(param, "CancelCount", hennaData.CancelCount);
	}
	return hennaData;
}

function string GetItemTooltipString(int ClassID)
{
	local string toolTipParam;
	local ItemInfo Info;

	Info = GetItemInfoByClassID(ClassID);
	ItemInfoToParam(Info, toolTipParam);
	return toolTipParam;
}

function AddHennaListItem(string param)
{
	local ItemInfo iInfo;
	local AddHennaStruct hennaData;
	local RichListCtrlRowData rowData;
	local string strAdenaComma;
	local Color itemNumColor;
	local bool canBuy;
	local int gabTextY;
	local string Desc;

	rowData.cellDataList.Length = 2;
	hennaData = ParmaToStruct(param);
	canBuy = (INT64(hennaData.needCount) <= hennaData.NumberOfItem);
	rowData.szReserved = GetItemTooltipString(hennaData.ClassID);
	rowData.nReserved1 = INT64(hennaData.HennaID);
	rowData.nReserved2 = INT64(hennaData.needCount);
	if(canBuy)
	{
		rowData.nReserved3 = INT64(1);
	}
	else
	{
		rowData.nReserved3 = INT64(0);
	}
	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(hennaData.ClassID), iInfo);
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, 0, 0);
	AddRichListCtrlItem(rowData.cellDataList[0].drawitems, iInfo, 32, 32, -34, 2);
	if((m_iState == 2))
	{
		if((int(GetLanguage()) == 1))
		{
			gabTextY = 3;
		}
		else
		{
			gabTextY = 1;
		}
		AddEllipsisString(rowData.cellDataList[0].drawitems, hennaData.Name, 236, util.BrightWhite, false, true, 5, -7);
		Desc = hennaData.Description;
		Class'InterfaceClassic.L2Util'.static.GetEllipsisString(Desc, 200);
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, Desc, util.BrightWhite, true, 45, gabTextY);
	}
	else
	{
		gabTextY = 5;
		AddEllipsisString(rowData.cellDataList[0].drawitems, hennaData.Name, 236, util.BrightWhite, false, true, 5, 0);
	}
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, (GetSystemString(637) @ ":"), GetColor(163, 163, 163, 255), true, 45, gabTextY);
	strAdenaComma = MakeCostStringINT64(hennaData.Fee);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, strAdenaComma, GetNumericColor(strAdenaComma), false, 5, 0);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, GetSystemString(469), util.Yellow, false, 5, 0);
	if(canBuy)
	{
		itemNumColor = GetColor(0, 176, 255, 255);
	}
	else
	{
		itemNumColor = GetColor(255, 0, 0, 255);
	}
	if((m_iState == 2))
	{
		AddRichListCtrlString(rowData.cellDataList[1].drawitems, GetSystemString(3386), util.White, false, 0, 0);
		AddRichListCtrlString(rowData.cellDataList[1].drawitems, string(hennaData.CancelCount), itemNumColor, true, 0, 5);
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[1].drawitems, GetSystemString(2380), util.White, false, 0, 0);
		AddRichListCtrlString(rowData.cellDataList[1].drawitems, ("/" $ string(hennaData.needCount)), util.White, true, 0, 5);
		AddRichListCtrlString(rowData.cellDataList[1].drawitems, string(hennaData.NumberOfItem), itemNumColor, false, 0, 0);
	}
	ListCtrl.InsertRecord(rowData);
	return;
}

function Color GetColor(int R, int G, int B, int A)
{
	local Color tColor;

	tColor.R = byte(R);
	tColor.G = byte(G);
	tColor.B = byte(B);
	tColor.A = byte(A);
	return tColor;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	Me.HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="HennaListWndLive"
}
