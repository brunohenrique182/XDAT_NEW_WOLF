class HennaSkillListWndLive extends UICommonAPI;

var WindowHandle Me;
var RichListCtrlHandle HennaSkillListListLc;
var int currentCategory;
var int currentTop;

function OnRegisterEvent()
{
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("HennaSkillListWndLive");
	HennaSkillListListLc = GetRichListCtrlHandle("HennaSkillListWndLive.HennaSkillListListLc");
	HennaSkillListListLc.SetSelectedSelTooltip(false);
	HennaSkillListListLc.SetAppearTooltipAtMouseX(true);
	HennaSkillListListLc.SetUseStripeBackTexture(false);
	return;
}

function OnShow()
{
	return;
}

function refresh(int nCategory, int ntop, int nCurrentLevel)
{
	local int i;
	local array<SkillDefaultInfo> oSkills, oHiddenSkills;

	Class'NWindow.UIDATA_HENNA'.static.GetDyeEffectSkillList(byte(nCategory), byte(ntop), oSkills, oHiddenSkills);
	HennaSkillListListLc.DeleteAllItem();
	i = 0;
	while((i < oSkills.Length))
	{
		AddList((i + 1), oSkills[i].SkillID, oSkills[i].SkillLevel, oHiddenSkills[i].SkillID, oHiddenSkills[i].SkillLevel, nCurrentLevel);
		i++;
	}
	currentCategory = nCategory;
	currentTop = ntop;
	if((nCurrentLevel != 0))
	{
		HennaSkillListListLc.SetStartRow((nCurrentLevel - 1));
	}
	return;
}

function AddList(int nLevel, int nSkillID, int nSkillLevel, int hiddenSkillID, int hiddenSkillLevel, int nCurrentLevel)
{
	local RichListCtrlRowData rowData;
	local SkillInfo a_SkillInfo, a_hiddenSkillInfo;

	rowData.cellDataList.Length = 3;
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, string(nLevel), GTColor().White, false, 0, 3);
	GetSkillInfo(nSkillID, nSkillLevel, 0, a_SkillInfo);
	if((hiddenSkillID > 0))
	{
		GetSkillInfo(hiddenSkillID, hiddenSkillLevel, 0, a_hiddenSkillInfo);
	}
	AddRichListCtrlSkillBySkillInfo(rowData.cellDataList[1].drawitems, a_SkillInfo, 32, 32, 5, 0);
	AddEllipsisString(rowData.cellDataList[1].drawitems, a_SkillInfo.SkillName, 164, GTColor().White, false, true, 10, 10);
	if((hiddenSkillID > 0))
	{
		AddRichListCtrlSkillBySkillInfo(rowData.cellDataList[2].drawitems, a_hiddenSkillInfo, 32, 32, 14, 0);
	}
	if((nCurrentLevel == nLevel))
	{
		rowData.sOverlayTex = "L2UI_NewTex.SkyTowerWnd.ListSelect";
		rowData.OverlayTexU = 704;
		rowData.OverlayTexV = 52;
	}
	HennaSkillListListLc.InsertRecord(rowData);
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}
