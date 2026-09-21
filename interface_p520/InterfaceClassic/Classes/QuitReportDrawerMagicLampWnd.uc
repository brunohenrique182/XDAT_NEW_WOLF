class QuitReportDrawerMagicLampWnd extends UICommonAPI;

var WindowHandle Me;
var RichListCtrlHandle RichListCtrl;
var ButtonHandle CloseBtn;
var QuitReportWnd QuitReportWndScript;

function Initialize()
{
	local string ownerFullPath;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	RichListCtrl = GetRichListCtrlHandle((ownerFullPath $ ".Magiclamp_ListCtrl"));
	CloseBtn = GetButtonHandle((ownerFullPath $ ".CloseBtn"));
	QuitReportWndScript = QuitReportWnd(GetScript("QuitReportWnd"));
	RichListCtrl.SetTooltipType("");
	RichListCtrl.SetSelectedSelTooltip(false);
	RichListCtrl.SetSelectable(false);
	return;
}

function UpdateMagicLampList()
{
	local RichListCtrlRowData rowData, oldRowData;
	local int Grade, recordCnt;
	local bool needModify;
	local L2Util util;
	local QuitReportWnd.MagicLampGetInfo getInfo;
	local QuitReportWnd.MagicLampExpInfo expInfo;
	local string expStr;
	local Color expStrColor;

	util = L2Util(GetScript("L2Util"));
	getInfo = Class'InterfaceClassic.QuitReportWnd'.static.Inst().GetMagicLampGetInfo();
	rowData.cellDataList.Length = 2;
	recordCnt = RichListCtrl.GetRecordCount();
	Grade = 0;
	while((Grade < 4))
	{
		expInfo = getInfo.expInfos[Grade];
		if((Grade < recordCnt))
		{
			RichListCtrl.GetRec(Grade, oldRowData);
			if(((oldRowData.nReserved1 == expInfo.Exp) && (oldRowData.nReserved2 == expInfo.Count)))
			{
				Grade++;
				continue;
			}
			else
			{
				needModify = true;
			}
		}
		rowData.cellDataList[0].drawitems.Length = 0;
		rowData.cellDataList[1].drawitems.Length = 0;
		rowData.nReserved1 = expInfo.Exp;
		rowData.nReserved2 = expInfo.Count;
		if((expInfo.Exp == INT64(0)))
		{
			expStr = string(expInfo.Exp);
		}
		else
		{
			expStr = ConvertNumToTextNoAdena(string(expInfo.Exp));
		}
		expStrColor = GetExpNumericColor(string(expInfo.Exp));
		AddRichListCtrlItem(rowData.cellDataList[0].drawitems, GetMagicLampItemInfo(Grade), 32, 32, 10);
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, GetMagicLampGradeName(Grade), util.ColorGold, false, 6, 2);
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, ("x" $ MakeCostString(string(expInfo.Count))), util.White, true, 48, 2);
		AddRichListCtrlString(rowData.cellDataList[1].drawitems, expStr, expStrColor, false, 10);
		if((needModify == true))
		{
			needModify = false;
			RichListCtrl.ModifyRecord(Grade, rowData);
			Grade++;
			continue;
		}
		RichListCtrl.InsertRecord(rowData);
		Grade++;
	}
	return;
}

function ClearListControls()
{
	RichListCtrl.DeleteAllItem();
	return;
}

function ItemInfo GetMagicLampItemInfo(int Grade)
{
	local string Icon, panel;
	local ItemInfo Info;

	switch(Grade)
	{
		case 0:
			Icon = "icon.r99_soul_stone_i00";
			panel = "icon.panel_star_r3";
			break;
		case 1:
			Icon = "icon.r99_soul_stone_i05";
			panel = "icon.panel_star_r2";
			break;
		case 2:
			Icon = "icon.r99_soul_stone_i02";
			panel = "icon.panel_star_r1";
			break;
		case 3:
			Icon = "icon.r99_soul_stone_i04";
			panel = "icon.panel_2";
			break;
		default:
			break;
	}
	Info.IconName = Icon;
	Info.IconPanel = panel;
	return Info;
}

function string GetMagicLampGradeName(int Grade)
{
	switch(Grade)
	{
		case 0:
			return GetSystemString(14471);
		case 1:
			return GetSystemString(14472);
		case 2:
			return GetSystemString(14473);
		case 3:
			return GetSystemString(14474);
		default:
			return "";
	}
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

function OnShow()
{
	UpdateMagicLampList();
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "CloseBtn":
			OnCloseBtnClick();
			break;
		default:
			break;
	}
	return;
}

function OnCloseBtnClick()
{
	QuitReportWndScript.SetDrawerMagicLampButtonState(true);
	Me.HideWindow();
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}
