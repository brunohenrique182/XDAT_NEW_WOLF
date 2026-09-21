class RestoreLostPropertyWnd extends UICommonAPI
	dependson(UIPacket);

const Dialog_Retore = 11000111;
const MAX_ITEM_COUNT = 30;

var string m_Windowname;
var WindowHandle Me;
var WindowHandle RestoreLostPropertyDisableWnd;
var TextureHandle RestoreLostPropertyDisable_Tex;
var TextBoxHandle RestoreLostPropertyDisable_Txt;
var TextureHandle RestoreLostPropertyListBG_texture;
var WindowHandle AdenaRichCtrlWnd;
var TextureHandle ListCtrlDeco_texture;
var RichListCtrlHandle List_ListCtrl;
var TextureHandle RestoreLostPropertyDescBg_Tex;
var TextBoxHandle RestoreLostPropertyBtnName_Txt;
var TextBoxHandle RestoreLostPropertyBtn02Name_Txt;
var ButtonHandle RestoreLostProperty_Btn;
var TextureHandle RestoreLostPropertyTabBg01_Tex;
var TextureHandle RestoreLostPropertyTabBg02_Tex;
var TextureHandle RestoreLostPropertyBg_Tex;
var WindowHandle Confirm_Wnd;
var WindowHandle ConfirmNeedItemDialogWnd;
var UIControlNeedItemDialog needItemDialogScript;

function OnRegisterEvent()
{
	RegisterEvent((100000 + 928));
	RegisterEvent(11530);
	RegisterEvent(11531);
	RegisterEvent(11532);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	Load();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("RestoreLostPropertyWnd");
	Confirm_Wnd = GetWindowHandle("RestoreLostPropertyWnd.Confirm_Wnd");
	RestoreLostPropertyDisableWnd = GetWindowHandle("RestoreLostPropertyWnd.RestoreLostPropertyDisableWnd");
	RestoreLostPropertyDisable_Tex = GetTextureHandle("RestoreLostPropertyWnd.RestoreLostPropertyDisableWnd.RestoreLostPropertyDisable_Tex");
	RestoreLostPropertyDisable_Txt = GetTextBoxHandle("RestoreLostPropertyWnd.RestoreLostPropertyDisableWnd.RestoreLostPropertyDisable_Txt");
	RestoreLostPropertyListBG_texture = GetTextureHandle("RestoreLostPropertyWnd.RestoreLostPropertyListBG_texture");
	AdenaRichCtrlWnd = GetWindowHandle("RestoreLostPropertyWnd.AdenaRichCtrlWnd");
	ListCtrlDeco_texture = GetTextureHandle("RestoreLostPropertyWnd.AdenaRichCtrlWnd.ListCtrlDeco_texture");
	List_ListCtrl = GetRichListCtrlHandle("RestoreLostPropertyWnd.AdenaRichCtrlWnd.List_ListCtrl");
	RestoreLostPropertyDescBg_Tex = GetTextureHandle("RestoreLostPropertyWnd.RestoreLostPropertyDescBg_Tex");
	RestoreLostPropertyBtnName_Txt = GetTextBoxHandle("RestoreLostPropertyWnd.RestoreLostPropertyBtnName_Txt");
	RestoreLostPropertyBtn02Name_Txt = GetTextBoxHandle("RestoreLostPropertyWnd.RestoreLostPropertyBtn02Name_Txt");
	if(((int(GetLanguage()) == 9) || (int(GetLanguage()) == 8)))
	{
		RestoreLostPropertyBtnName_Txt.SetFontIDByName("hs9");
		RestoreLostPropertyBtn02Name_Txt.SetFontIDByName("hs9");
	}
	RestoreLostProperty_Btn = GetButtonHandle("RestoreLostPropertyWnd.RestoreLostProperty_Btn");
	RestoreLostPropertyTabBg01_Tex = GetTextureHandle("RestoreLostPropertyWnd.RestoreLostPropertyTabBg01_Tex");
	RestoreLostPropertyTabBg02_Tex = GetTextureHandle("RestoreLostPropertyWnd.RestoreLostPropertyTabBg02_Tex");
	RestoreLostPropertyBg_Tex = GetTextureHandle("RestoreLostPropertyWnd.RestoreLostPropertyBg_Tex");
	List_ListCtrl.SetSelectedSelTooltip(false);
	List_ListCtrl.SetAppearTooltipAtMouseX(true);
	return;
}

function Load()
{
	SetScript_UIControlNeedItemDialog();
	return;
}

function OnShow()
{
	setWindowTitleByString((((((GetSystemString(13517) $ " (") $ string(List_ListCtrl.GetRecordCount())) $ "/") $ string(30)) $ ")"));
	if(IsPlayerOnWorldRaidServer())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
		Me.HideWindow();
		return;
	}
	else
	{
		RestoreLostPropertyDisableWnd.HideWindow();
		hideAllDialog();
		API_C_EX_PENALTY_ITEM_LIST();
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_PacketID(928):
			ParsePacket_S_EX_PENALTY_ITEM_RESTORE();
			break;
		case 11530:
			Debug(("EV_PenaltyItemListBegin" @ param));
			List_ListCtrl.DeleteAllItem();
			break;
		case 11531:
			Debug(("EV_PenaltyItemInfo" @ param));
			Parse_PENALTY_ITEM_LIST(param);
			break;
		case 11532:
			Debug(("EV_PenaltyItemListEnd" @ param));
			setWindowTitleByString((((((GetSystemString(13517) $ " (") $ string(List_ListCtrl.GetRecordCount())) $ "/") $ string(30)) $ ")"));
			break;
		default:
			break;
	}
	return;
}

function Parse_PENALTY_ITEM_LIST(string param)
{
	local ItemInfo Info;
	local L2UITime l2Time;
	local string timeStr;
	local int nDropDate, nItemDBID;
	local INT64 nRestoreCost, nRestoreLCoinCost;

	ParamToItemInfo(param, Info);
	Info.bDisabled = 0;
	ParseInt(param, "DropDate", nDropDate);
	ParseInt(param, "ItemDBID", nItemDBID);
	ParseINT64(param, "RestoreCost", nRestoreCost);
	ParseINT64(param, "RestoreLCoin", nRestoreLCoinCost);
	GetTimeStruct(nDropDate, l2Time);
	timeStr = ((((((((string(l2Time.nYear) $ "-") $ getInstanceL2Util().makeZeroString(2, INT64(l2Time.nMonth))) $ "-") $ getInstanceL2Util().makeZeroString(2, INT64(l2Time.nDay))) $ " ") $ getInstanceL2Util().makeZeroString(2, INT64(l2Time.nHour))) $ ":") $ getInstanceL2Util().makeZeroString(2, INT64(l2Time.nMin)));
	List_ListCtrl.InsertRecord(MakeListRecord(Info, Info.Id.ClassID, nRestoreCost, nRestoreLCoinCost, nItemDBID, timeStr));
	return;
}

function ParsePacket_S_EX_PENALTY_ITEM_RESTORE()
{
	local UIPacket._S_EX_PENALTY_ITEM_RESTORE packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_PENALTY_ITEM_RESTORE(packet))
	{
		return;
	}
	Debug((" -->  Decode_S_EX_PENALTY_ITEM_RESTORE : " @ string(packet.nResult)));
	API_C_EX_PENALTY_ITEM_LIST();
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "RestoreLostProperty_Btn":
			OnRestoreLostProperty_BtnClick(1);
			break;
		case "RestoreLostProperty02_Btn":
			OnRestoreLostProperty_BtnClick(0);
			break;
		default:
			break;
	}
	return;
}

function OnRestoreLostProperty_BtnClick(int nIsAdena)
{
	if((List_ListCtrl.GetSelectedIndex() > -1))
	{
		tryDialog(11000111, nIsAdena);
	}
	else
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(326));
	}
	return;
}

function RichListCtrlRowData MakeListRecord(ItemInfo Info, int needItemClassID, INT64 needItemAmount, INT64 needItemLcoinAmount, int DBId, string dataString)
{
	local RichListCtrlRowData Record;
	local int nW, nH;

	ItemInfoToParam(Info, Record.szReserved);
	Record.cellDataList.Length = 2;
	Record.nReserved1 = INT64(DBId);
	Record.nReserved2 = needItemAmount;
	Record.nReserved3 = needItemLcoinAmount;
	GetTextSizeDefault(GetItemNameAll(Info), nW, nH);
	AddRichListCtrlItem(Record.cellDataList[0].drawitems, Info, 32, 32, 4);
	AddRichListCtrlString(Record.cellDataList[0].drawitems, GetItemNameAll(Info), getInstanceL2Util().BrightWhite, false, 6, 0);
	addRichListCtrlTexture(Record.cellDataList[0].drawitems, "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Icon_Lcoin", 18, 18, -nW, (nH + 5));
	AddRichListCtrlString(Record.cellDataList[0].drawitems, MakeCostStringINT64(needItemLcoinAmount), getInstanceL2Util().BrightWhite, false, 4, 0);
	GetTextSizeDefault(MakeCostStringINT64(needItemLcoinAmount), nW, nH);
	addRichListCtrlTexture(Record.cellDataList[0].drawitems, "L2UI_ct1.Icon.Icon_DF_Common_Adena", 18, 13, (-nW + 70), 0);
	AddRichListCtrlString(Record.cellDataList[0].drawitems, MakeCostStringINT64(needItemAmount), getInstanceL2Util().BrightWhite, false, 4, 0);
	AddRichListCtrlString(Record.cellDataList[1].drawitems, dataString, getInstanceL2Util().BrightWhite, false, 0, 0);
	return Record;
}

function SetScript_UIControlNeedItemDialog()
{
	local string m_name;

	m_name = (m_Windowname $ ".Confirm_Wnd.ConfirmNeedItemDialogWnd");
	ConfirmNeedItemDialogWnd = GetWindowHandle(m_name);
	ConfirmNeedItemDialogWnd.SetScript("UIControlNeedItemDialog");
	needItemDialogScript = UIControlNeedItemDialog(ConfirmNeedItemDialogWnd.GetScript());
	needItemDialogScript.SetWindow(m_name, (m_Windowname $ ".Confirm_Wnd"));
	needItemDialogScript.DelegateOnClickCancleButton = OnClickHideDialog;
	needItemDialogScript.DelegateOnClickOkButton = OnClickOkDialog;
	return;
}

function hideAllDialog()
{
	needItemDialogScript.Hide();
	return;
}

function OnClickHideDialog(optional int nDialogKey)
{
	hideAllDialog();
	return;
}

function OnClickOkDialog(optional int nDialogKey)
{
	hideAllDialog();
	Debug(("optional int nDialogKey" @ string(nDialogKey)));
	if((nDialogKey == 11000111))
	{
		Debug(("복구할 BID " @ string(needItemDialogScript.GetReservedInt())));  // EN?: Bid to recover
		if((needItemDialogScript.GetReservedInt() > 0))
		{
			API_C_EX_PENALTY_ITEM_RESTORE(needItemDialogScript.GetReservedInt(), needItemDialogScript.GetReservedInt2());
		}
	}
	return;
}

function tryDialog(int nDialogKey, int nIsAdena)
{
	local string dialogStr;
	local ItemInfo ItemInfo;
	local RichListCtrlRowData Record;

	Debug(("nDialogKey" @ string(nDialogKey)));
	if((nDialogKey == 11000111))
	{
		List_ListCtrl.GetSelectedRec(Record);
		needItemDialogScript.Show();
		ParamToItemInfo(Record.szReserved, ItemInfo);
		dialogStr = MakeFullSystemMsg(GetSystemMessage(13325), (("\"" $ GetItemNameAll(ItemInfo)) $ "\""));
		needItemDialogScript.setInit(dialogStr, nDialogKey, , , true);
		needItemDialogScript.SetReservedInt(int(Record.nReserved1));
		needItemDialogScript.SetReservedInt2(nIsAdena);
		needItemDialogScript.StartNeedItemList();
		if((nIsAdena == 1))
		{
			needItemDialogScript.AddNeedItem(57, Record.nReserved2);
		}
		else
		{
			needItemDialogScript.AddNeedItem(91663, Record.nReserved3);
		}
		needItemDialogScript.EndNeedItemList();
	}
	return;
}

function API_C_EX_PENALTY_ITEM_LIST(optional int nReserved)
{
	local array<byte> stream;
	local UIPacket._C_EX_PENALTY_ITEM_LIST packet;

	packet.nReserved = nReserved;
	Class'Interface.UIPacket'.static.RequestUIPacket(697, stream);
	Debug(("----> Api Call : C_EX_PENALTY_ITEM_LIST " @ string(nReserved)));
	return;
}

function API_C_EX_PENALTY_ITEM_RESTORE(int nItemDBID, optional int bByAdena)
{
	local array<byte> stream;
	local UIPacket._C_EX_PENALTY_ITEM_RESTORE packet;

	packet.nItemDBID = nItemDBID;
	packet.bByAdena = byte(bByAdena);
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_PENALTY_ITEM_RESTORE(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(698, stream);
	Debug((("----> Api Call : C_EX_PENALTY_ITEM_RESTORE " @ string(nItemDBID)) @ string(bByAdena)));
	return;
}

function OnReceivedCloseUI()
{
	if(ConfirmNeedItemDialogWnd.IsShowWindow())
	{
		hideAllDialog();
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		GetWindowHandle(m_Windowname).HideWindow();
	}
	return;
}

defaultproperties
{
	m_Windowname="RestoreLostPropertyWnd"
}
