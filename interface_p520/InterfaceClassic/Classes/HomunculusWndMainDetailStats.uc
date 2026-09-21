class HomunculusWndMainDetailStats extends UICommonAPI;

var WindowHandle Me;
var string m_Windowname;
var L2Util util;
var HomunculusWnd HomunculusWndScript;
var RichListCtrlHandle List_ListCtrl0;
var RichListCtrlHandle List_ListCtrl1;
var ButtonHandle btn0;
var ButtonHandle btn1;
var HomunculusWndMainDetailStatsEnchant homunculusWndMainDetailStatsEnchantScript;
var HomunculusWndEnchantCommunionChart homunculusWndEnchantCommunionChartScript;
var HomunculusWndEnchantCommunionInfo homunculusWndEnchantCommunionInfoScript;

function Initialize()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	List_ListCtrl0 = GetRichListCtrlHandle((m_Windowname $ ".List_ListCtrl0"));
	List_ListCtrl1 = GetRichListCtrlHandle((m_Windowname $ ".List_ListCtrl1"));
	util = L2Util(GetScript("L2Util"));
	HomunculusWndScript = HomunculusWnd(GetScript("HomunculusWnd"));
	List_ListCtrl0.SetSelectable(false);
	List_ListCtrl0.SetUseStripeBackTexture(false);
	List_ListCtrl0.ShowScrollBar(false);
	List_ListCtrl0.SetAppearTooltipAtMouseX(true);
	List_ListCtrl0.SetSelectedSelTooltip(false);
	List_ListCtrl1.SetSelectable(false);
	List_ListCtrl1.SetUseStripeBackTexture(false);
	List_ListCtrl1.ShowScrollBar(false);
	List_ListCtrl1.SetAppearTooltipAtMouseX(true);
	List_ListCtrl1.SetSelectedSelTooltip(false);
	btn0 = GetButtonHandle((m_Windowname $ ".btn0"));
	btn1 = GetButtonHandle((m_Windowname $ ".btn1"));
	btn0.DisableWindow();
	btn1.DisableWindow();
	homunculusWndMainDetailStatsEnchantScript = HomunculusWndMainDetailStatsEnchant(GetScript("HomunculusWnd.HomunculusWndMainDetailStatsEnchant"));
	homunculusWndEnchantCommunionChartScript = HomunculusWndEnchantCommunionChart(GetScript("HomunculusWnd.HomunculusWndEnchantCommunionChart"));
	homunculusWndEnchantCommunionInfoScript = HomunculusWndEnchantCommunionInfo(GetScript("HomunculusWnd.HomunculusWndEnchantCommunionInfo"));
	GetButtonHandle((m_Windowname $ ".HomunHelp_btn")).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13400)));
	GetButtonHandle((m_Windowname $ ".EnchantHelp_btn")).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13401)));
	return;
}

function OnLoad()
{
	Initialize();
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "btn0":
			HomunculusWndScript.SetState(EnchantHomunculus);
			homunculusWndMainDetailStatsEnchantScript.SetChangeHomunculusData();
			break;
		case "btn1":
			HomunculusWndScript.SetState(Communion);
			homunculusWndEnchantCommunionChartScript.SetChangeHomunculusData();
			homunculusWndEnchantCommunionInfoScript.SetChangeHomunculusData();
			break;
			break;
		default:
			break;
	}
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

function ClearAll()
{
	List_ListCtrl0.DeleteAllItem();
	List_ListCtrl1.DeleteAllItem();
	btn0.DisableWindow();
	btn1.DisableWindow();
	return;
}

function SetChangeHomunculusData()
{
	SetHomunculusAbility();
	SetHomunculusCommunion();
	return;
}

function SetHomunculusAbility()
{
	List_ListCtrl0.DeleteAllItem();
	List_ListCtrl0.InsertRecord(makeRecord(GetSystemString(90), MakeCostString(string(GetCurrHomunculusData().Hp)), false));
	List_ListCtrl0.InsertRecord(makeRecord(GetSystemString(55), MakeCostString(string(GetCurrHomunculusData().Attack)), false));
	List_ListCtrl0.InsertRecord(makeRecord(GetSystemString(54), MakeCostString(string(GetCurrHomunculusData().Defence)), false));
	List_ListCtrl0.InsertRecord(makeRecord(GetSystemString(113), MakeCostString(string(GetCurrHomunculusData().Critical)), false));
	btn0.EnableWindow();
	return;
}

function SetHomunculusCommunion()
{
	local int i;
	local array<string> descs;
	local string Desc;
	local ItemID Id;

	List_ListCtrl1.DeleteAllItem();
	Id.ClassID = GetCurrHomunculusData().SkillID[0];
	Desc = Class'NWindow.UIDATA_SKILL'.static.GetDescription(Id, GetCurrHomunculusData().SkillLevel[0], 0);
	Split(Desc, "^", descs);
	List_ListCtrl1.InsertRecord(makeRecord(descs[0], descs[1], true));
	i = 1;
	while((i < 6))
	{
		if((GetCurrHomunculusData().SkillLevel[i] > 0))
		{
			Id.ClassID = GetCurrHomunculusData().SkillID[i];
			Desc = Class'NWindow.UIDATA_SKILL'.static.GetDescription(Id, GetCurrHomunculusData().SkillLevel[i], 0);
			if((Desc != ""))
			{
				descs.Length = 0;
				Split(Desc, "^", descs);
				List_ListCtrl1.InsertRecord(makeRecord(descs[0], descs[1], false));
			}
		}
		i++;
	}
	btn1.EnableWindow();
	return;
}

function RichListCtrlRowData makeRecord(string Name, string numString, bool isBase)
{
	local RichListCtrlRowData Record;
	local Color tmpTextColor;

	Record.cellDataList.Length = 2;
	Record.szReserved = "툴팁 정보들";  // EN?: Tooltip Information
	if(isBase)
	{
		tmpTextColor = GetColor(170, 153, 119, 255);
	}
	else
	{
		tmpTextColor = util.BrightWhite;
	}
	AddEllipsisString(Record.cellDataList[0].drawitems, Name, 193, tmpTextColor, false, true);
	AddEllipsisString(Record.cellDataList[1].drawitems, numString, 81, tmpTextColor, false, true, 20);
	return Record;
}

function HomunculusAPI.HomunculusData GetCurrHomunculusData()
{
	return HomunculusWndMainList(GetScript("HomunculusWnd.HomunculusWndMainList")).GetCurrHomunculusData();
}
