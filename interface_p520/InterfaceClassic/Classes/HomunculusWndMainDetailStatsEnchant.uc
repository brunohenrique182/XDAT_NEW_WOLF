class HomunculusWndMainDetailStatsEnchant extends UICommonAPI
	dependson(UIPacket);

const TIMERID_DISABLE = 1;
const TIMER_DISABLETIME = 5000;

var WindowHandle Me;
var string m_Windowname;
var L2Util util;
var HomunculusWnd HomunculusWndScript;
var HomunculusWndEnchantCommunionChart homunculusWndEnchantCommunionChartScript;
var HomunculusWndEnchantCommunionChartItem homunculusWndEnchantCommunionChartItemScript;
var RichListCtrlHandle List_ListCtrl0;
var TextBoxHandle text1;
var TextBoxHandle text2;
var StatusBarHandle statusBar0;
var StatusBarHandle statusBar1;
var StatusBarHandle statusbar2;
var ButtonHandle btn0;
var ButtonHandle btn1;
var ButtonHandle btn2;
var ButtonHandle btnHelp;
var HomunculusAPI.HomunEnchantData EnchantData;

function ClearAll()
{
	btn0.DisableWindow();
	btn1.DisableWindow();
	btn2.DisableWindow();
	List_ListCtrl0.DeleteAllItem();
	statusBar0.SetPoint(INT64(0), INT64(100));
	statusBar1.SetPoint(INT64(0), INT64(100));
	statusbar2.SetPoint(INT64(0), INT64(100));
	return;
}

function SetTooltip()
{
	local CustomTooltip t;

	util.setCustomTooltip(t);
	util.ToopTipMinWidth(300);
	util.ToopTipInsertText(GetSystemMessage(13215));
	btn0.SetTooltipCustomType(util.getCustomToolTip());
	return;
}

function SetTooltipOnSelect()
{
	local CustomTooltip t;
	local HomunculusAPI.HomunculusNpcLevelData npcMaxLevelData;
	local HomunculusAPI.HomunculusData emptyHomunculusData, currHomunculusData;

	if(!HomunculusWndScript.ChkSerVer())
	{
		return;
	}
	currHomunculusData = GetCurrHomunculusData();
	if((currHomunculusData == emptyHomunculusData))
	{
		return;
	}
	util.setCustomTooltip(t);
	util.ToopTipMinWidth(200);
	npcMaxLevelData = HomunculusWndScript.API_GetMaxHomunculusNpcLevelData(GetCurrHomunculusData().Id);
	util.ToopTipInsertText(GetSystemString(13391), true, true);
	util.TooltipInsertItemBlank(5);
	util.TooltipInsertItemLine();
	util.ToopTipInsertText((GetSystemString(90) @ MakeCostString(string(npcMaxLevelData.MaxHP))), true, true);
	util.ToopTipInsertText((GetSystemString(55) @ MakeCostString(string(npcMaxLevelData.MaxAtk))), true, true);
	util.ToopTipInsertText((GetSystemString(54) @ MakeCostString(string(npcMaxLevelData.MaxDef))), true, true);
	util.ToopTipInsertText((GetSystemString(113) @ MakeCostString(string(npcMaxLevelData.MaxCri))), true, true);
	btnHelp.SetTooltipCustomType(util.getCustomToolTip());
	return;
}

function Initialize()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	util = L2Util(GetScript("L2Util"));
	HomunculusWndScript = HomunculusWnd(GetScript("HomunculusWnd"));
	List_ListCtrl0 = GetRichListCtrlHandle((m_Windowname $ ".List_ListCtrl0"));
	text1 = GetTextBoxHandle((m_Windowname $ ".text1"));
	text2 = GetTextBoxHandle((m_Windowname $ ".text2"));
	statusBar0 = GetStatusBarHandle((m_Windowname $ ".statusbar0"));
	statusBar1 = GetStatusBarHandle((m_Windowname $ ".statusbar1"));
	statusbar2 = GetStatusBarHandle((m_Windowname $ ".statusbar2"));
	btn0 = GetButtonHandle((m_Windowname $ ".btn0"));
	btn1 = GetButtonHandle((m_Windowname $ ".btn1"));
	btn2 = GetButtonHandle((m_Windowname $ ".btn2"));
	btnHelp = GetButtonHandle((m_Windowname $ ".btnHelp"));
	List_ListCtrl0.SetSelectable(false);
	List_ListCtrl0.SetUseStripeBackTexture(false);
	List_ListCtrl0.ShowScrollBar(false);
	List_ListCtrl0.SetAppearTooltipAtMouseX(true);
	List_ListCtrl0.SetSelectedSelTooltip(false);
	btn1.DisableWindow();
	btn2.DisableWindow();
	if((GetGameStateName() != "GAMINGSTATE"))
	{
		return;
	}
	if(HomunculusWndScript.ChkSerVer())
	{
		EnchantData = HomunculusWndScript.API_GetHomunEnchantData();
	}
	return;
}

function OnRegisterEvent()
{
	RegisterEvent((100000 + 866));
	return;
}

function OnLoad()
{
	Initialize();
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case (100000 + 866):
			Handle_S_EX_HOMUNCULUS_ENCHANT_EXP_RESULT();
			break;
		default:
			break;
	}
	return;
}

function OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case 1:
			SetBtnEnable0();
			Me.KillTimer(1);
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "btn0":
			HandlePlusButton(Name);
			break;
		case "btnMain0":
			HomunculusWndScript.SetState(Main);
			homunculusWndEnchantCommunionChartScript.SetChangeHomunculusData();
			break;
		default:
			break;
	}
	return;
}

function HandlePlusButton(string Name)
{
	btn0.DisableWindow();
	Me.SetTimer(1, 5000);
	HomunculusWndScript.API_C_EX_HOMUNCULUS_ENCHANT_EXP(GetCurrHomunculusData().idx);
	return;
}

function Show()
{
	Me.ShowWindow();
	Me.SetFocus();
	return;
}

function Hide()
{
	Me.HideWindow();
	return;
}

function SetChangeHomunculusData()
{
	local HomunculusAPI.HomunculusNpcLevelData npcLevelData;
	local int prevExp, currExp;

	npcLevelData = HomunculusWndScript.API_GetHomunculusNpcLevelData(GetCurrHomunculusData().Id, GetCurrHomunculusData().Level);
	if((GetCurrHomunculusData().Level == 1))
	{
		prevExp = 0;
	}
	else
	{
		prevExp = HomunculusWndScript.API_GetHomunculusNpcLevelData(GetCurrHomunculusData().Id, (GetCurrHomunculusData().Level - 1)).MaxExp;
	}
	currExp = (npcLevelData.MaxExp - prevExp);
	statusBar0.SetPointExpPercentRate((float((GetCurrHomunculusData().Exp - prevExp)) / float(currExp)));
	List_ListCtrl0.DeleteAllItem();
	List_ListCtrl0.InsertRecord(makeRecord(GetSystemString(90), MakeCostString(string(GetCurrHomunculusData().Hp))));
	List_ListCtrl0.InsertRecord(makeRecord(GetSystemString(55), MakeCostString(string(GetCurrHomunculusData().Attack))));
	List_ListCtrl0.InsertRecord(makeRecord(GetSystemString(54), MakeCostString(string(GetCurrHomunculusData().Defence))));
	List_ListCtrl0.InsertRecord(makeRecord(GetSystemString(113), MakeCostString(string(GetCurrHomunculusData().Critical))));
	btn0.DisableWindow();
	SetBtnEnable0();
	SetTooltip();
	SetTooltipOnSelect();
	return;
}

function Handle_S_EX_HOMUNCULUS_ENCHANT_EXP_RESULT()
{
	local UIPacket._S_EX_HOMUNCULUS_ENCHANT_EXP_RESULT packet;
	local string Msg;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_HOMUNCULUS_ENCHANT_EXP_RESULT(packet))
	{
		return;
	}
	if((packet.Type == 0))
	{
		AddSystemMessage(packet.nID);
		return;
	}
	Msg = MakeFullSystemMsg(GetSystemMessage(13218), MakeCostString(string(EnchantData.EnchantExpPoint)));
	util.showGfxScreenMessage(Msg);
	AddSystemMessageString(Msg);
	HomunculusWndScript.API_C_EX_SHOW_HOMUNCULUS_INFO(1);
	Me.KillTimer(1);
	SetBtnEnable0();
	return;
}

function SetBtnEnable0()
{
	local int MaxLevel, neePoint;

	MaxLevel = 6;
	neePoint = 1;
	if((GetCurrHomunculusData().Level < MaxLevel))
	{
		if((HomunculusWndScript.currentEnchantPoint >= neePoint))
		{
			btn0.EnableWindow();
		}
	}
	return;
}

function RichListCtrlRowData makeRecord(string Name, string numString)
{
	local RichListCtrlRowData Record;
	local Color tmpTextColor;

	Record.cellDataList.Length = 2;
	Record.szReserved = "툴팁 정보들";  // EN?: Tooltip Information
	tmpTextColor = GetColor(170, 153, 119, 255);
	AddRichListCtrlString(Record.cellDataList[0].drawitems, Name, tmpTextColor, false);
	AddRichListCtrlString(Record.cellDataList[1].drawitems, numString, tmpTextColor, false, 20);
	return Record;
}

function HomunculusAPI.HomunculusData GetCurrHomunculusData()
{
	return HomunculusWndMainList(GetScript("HomunculusWnd.HomunculusWndMainList")).GetCurrHomunculusData();
}
