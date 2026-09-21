class ClanSubInfoContainerBenefit extends UICommonAPI;

var string m_Windowname;
var WindowHandle Me;
var string JoinWndPath;
var string HuntWndPath;
var RichListCtrlHandle m_ClanBenefitList_ListCtrl;
var ClanWndClassicNew clanWndClassicScr;

function InitDefaultSetting()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	clanWndClassicScr = ClanWndClassicNew(GetScript("ClanWndClassicNew"));
	clanWndClassicScr.clanSubInfoContainerBenefitScr = self;
	Me.SetFocus();
	return;
}

function Initialize()
{
	InitDefaultSetting();
	m_ClanBenefitList_ListCtrl = GetRichListCtrlHandle((m_Windowname $ ".ClanBenefitList_Wnd.ClanBenefitList_ListCtrl"));
	m_ClanBenefitList_ListCtrl.SetAppearTooltipAtMouseX(true);
	m_ClanBenefitList_ListCtrl.SetSelectedSelTooltip(false);
	m_ClanBenefitList_ListCtrl.SetSelectable(false);
	return;
}

event OnLoad()
{
	Initialize();
	return;
}

event OnSetFocus(WindowHandle wndHandle, bool bFocused)
{
	m_hOwnerWnd.GetParentWindowHandle().GetScript().OnSetFocus(wndHandle, bFocused);
	return;
}

function SetRecords()
{
	local int lv;
	local PledgeLevelData Data;

	ClearList();
	while(clanWndClassicScr.API_GetPledgeLevelData(lv, Data))
	{
		m_ClanBenefitList_ListCtrl.InsertRecord(makeRecord(Data));
		lv++;
	}
	m_ClanBenefitList_ListCtrl.SetStartRow(clanWndClassicScr.m_clanLevel);
	return;
}

function RichListCtrlRowData makeRecord(PledgeLevelData Data)
{
	local RichListCtrlRowData Record;
	local ItemInfo iInfo;
	local int i, Len;

	Record.cellDataList.Length = 4;
	AddRichListCtrlString(Record.cellDataList[0].drawitems, string(Data.PledgeLevel), getInstanceL2Util().Yellow, false);
	if((Data.OpenContents.Length > 0))
	{
		Len = Min(Data.OpenContents.Length, 2);
		i = 0;
		while((i < Len))
		{
			AddEllipsisString(Record.cellDataList[1].drawitems, Data.OpenContents[i], 90, GetColor(255, 255, 255, 255), (i > 0));
			i++;
		}
	}
	else
	{
		AddRichListCtrlString(Record.cellDataList[1].drawitems, "-");
	}
	Record.cellDataList[2].szData = string(Data.NumGeneral);
	AddRichListCtrlString(Record.cellDataList[2].drawitems, Record.cellDataList[2].szData, getInstanceL2Util().White, false);
	if((Data.SellingItemList.Length > 0))
	{
		i = 0;
		while((i < Data.SellingItemList.Length))
		{
			Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(Data.SellingItemList[i]), iInfo);
			if((i == 0))
			{
				AddRichListCtrlItem(Record.cellDataList[3].drawitems, iInfo, 32, 32, 50);
				i++;
				continue;
			}
			AddRichListCtrlItem(Record.cellDataList[3].drawitems, iInfo, 32, 32);
			i++;
		}
	}
	if(((Data.PledgeLevel == clanWndClassicScr.m_clanLevel) && (clanWndClassicScr.m_clanID > 0)))
	{
		Record.sOverlayTex = "L2UI_EPIC.ClanWnd.ClanMyRankBg";
		Record.OverlayTexU = 597;
		Record.OverlayTexV = 43;
	}
	return Record;
}

function ClearList()
{
	m_ClanBenefitList_ListCtrl.DeleteAllItem();
	return;
}
