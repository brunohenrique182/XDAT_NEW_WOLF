class InfoFightWndClassic extends UICommonAPI
	dependson(UIPacket);

const STAT_NUM_MAX = 300;
const CATEGORY_ROW_MAX = 11;

struct DetailStatInfo
{
	var L2CharacterAbilityUIData UIData;
	var int Value;
};

struct DetailStatCategory
{
	var string categoryName;
	var array<DetailStatInfo> stats;
};

var WindowHandle Me;
var RichListCtrlHandle Category_ListCtrl;
var RichListCtrlHandle FightInfo_ListCtrl;
var TextBoxHandle InfoFightIMGTitle_txt;
var array<DetailStatCategory> _categoryInfos;
var array<UIPacket._PkUserViewInfoParameter> _packetParams;
var int _selectedCategory;
var bool initBool;

function Initialize()
{
	InitControls();
	initBool = false;
	return;
}

function InitControls()
{
	local string ownerFullPath;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	Category_ListCtrl = GetRichListCtrlHandle((ownerFullPath $ ".Category_ListCtrl"));
	FightInfo_ListCtrl = GetRichListCtrlHandle((ownerFullPath $ ".FightInfo_ListCtrl"));
	InfoFightIMGTitle_txt = GetTextBoxHandle((ownerFullPath $ ".InfoFightIMGTitle_txt"));
	Category_ListCtrl.SetUseStripeBackTexture(false);
	FightInfo_ListCtrl.SetSelectable(false);
	FightInfo_ListCtrl.SetSelectedSelTooltip(false);
	FightInfo_ListCtrl.SetAppearTooltipAtMouseX(true);
	return;
}

function InitData()
{
	local int i;
	local array<L2CharacterAbilityUIData> abilityUIData;
	local L2CharacterAbilityUIData tempUIData;

	GetCharacterAbilityData(abilityUIData);
	_categoryInfos.Length = 0;
	i = 0;
	while((i < abilityUIData.Length))
	{
		tempUIData = abilityUIData[i];
		InsertCategoryInfo(_categoryInfos, tempUIData);
		i++;
	}
	Category_ListCtrl.AdjustShowRow(abilityUIData.Length);
	Category_ListCtrl.SetWindowSize(173, (53 * abilityUIData.Length));
	InitCategoryListBackTexture(abilityUIData.Length);
	return;
}

function InitCategoryListBackTexture(int ListCnt)
{
	local int i;
	local TextureHandle backTexture;

	i = 0;
	while((i < 11))
	{
		backTexture = GetTextureHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CategoryBgTex_") $ string(i)));
		if((i < ListCnt))
		{
			backTexture.ShowWindow();
			i++;
			continue;
		}
		backTexture.HideWindow();
		i++;
	}
	return;
}

function UpdateStatInfos()
{
	local int i, j;
	local DetailStatCategory categoryInfo;
	local DetailStatInfo statInfo;

	i = 0;
	while((i < _categoryInfos.Length))
	{
		categoryInfo = _categoryInfos[i];
		j = 0;
		while((j < categoryInfo.stats.Length))
		{
			statInfo = categoryInfo.stats[j];
			statInfo.Value = GetPacketStatValue(statInfo.UIData.ServerType);
			categoryInfo.stats[j] = statInfo;
			j++;
		}
		_categoryInfos[i] = categoryInfo;
		i++;
	}
	return;
}

function int GetPacketStatValue(int Index)
{
	if((_packetParams.Length > Index))
	{
		return _packetParams[Index].Value;
	}
	return 0;
}

function InsertCategoryInfo(out array<DetailStatCategory> categoryInfos, L2CharacterAbilityUIData UIData)
{
	local int i;
	local DetailStatCategory tempCategoryInfo;
	local DetailStatInfo tempStatInfo;

	i = 0;
	while((i < categoryInfos.Length))
	{
		tempCategoryInfo = categoryInfos[i];
		if((tempCategoryInfo.categoryName == UIData.Category))
		{
			tempStatInfo.UIData = UIData;
			tempCategoryInfo.stats.Length = (tempCategoryInfo.stats.Length + 1);
			tempCategoryInfo.stats[(tempCategoryInfo.stats.Length - 1)] = tempStatInfo;
			categoryInfos[i] = tempCategoryInfo;
			return;
		}
		i++;
	}
	tempCategoryInfo.categoryName = UIData.Category;
	tempCategoryInfo.stats.Length = 0;
	tempStatInfo.UIData = UIData;
	tempCategoryInfo.stats[0] = tempStatInfo;
	categoryInfos.Length = (categoryInfos.Length + 1);
	categoryInfos[(categoryInfos.Length - 1)] = tempCategoryInfo;
	return;
}

function InitCategoryListControls()
{
	local int i;
	local RichListCtrlRowData rowData;
	local DetailStatCategory categoryInfo;

	rowData.cellDataList.Length = 1;
	Category_ListCtrl.DeleteAllItem();
	i = 0;
	while((i < _categoryInfos.Length))
	{
		categoryInfo = _categoryInfos[i];
		rowData.cellDataList[0].drawitems.Length = 0;
		rowData.cellDataList[0].szData = categoryInfo.categoryName;
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, categoryInfo.categoryName, getInstanceL2Util().White, false, 5);
		Category_ListCtrl.InsertRecord(rowData);
		i++;
	}
	if((Category_ListCtrl.GetRecordCount() > 0))
	{
		Category_ListCtrl.SetSelectedIndex(0, true);
	}
	return;
}

function UpdateUIControls()
{
	local int i, recordCnt, deleteIndex;
	local array<DetailStatInfo> statInfos;
	local DetailStatInfo statInfo;
	local RichListCtrlRowData rowData;
	local DetailStatCategory categoryInfo;
	local string valueStr;

	if((Me.IsShowWindow() == false))
	{
		return;
	}
	if((_categoryInfos.Length < _selectedCategory))
	{
		return;
	}
	UpdateStatInfos();
	categoryInfo = _categoryInfos[_selectedCategory];
	statInfos = categoryInfo.stats;
	InfoFightIMGTitle_txt.SetText(categoryInfo.categoryName);
	rowData.cellDataList.Length = 2;
	recordCnt = FightInfo_ListCtrl.GetRecordCount();
	i = 0;
	while((i < Max(statInfos.Length, recordCnt)))
	{
		if((i < statInfos.Length))
		{
			statInfo = statInfos[i];
			rowData.cellDataList[0].drawitems.Length = 0;
			rowData.cellDataList[1].drawitems.Length = 0;
			rowData.nReserved1 = INT64(i);
			rowData.szReserved = statInfo.UIData.TooltipDesc;
			if(statInfo.UIData.IsPercent)
			{
				if((statInfo.Value == 0))
				{
					valueStr = (string(statInfo.Value) $ "%");
				}
				else if((statInfo.Value == -1))
				{
					valueStr = GetSystemString(13663);
				}
				else
				{
					valueStr = getInstanceL2Util().cutFloat3((float(statInfo.Value) / 100.0000000));
				}
			}
			else
			{
				valueStr = string(statInfo.Value);
			}
			rowData.cellDataList[1].szData = valueStr;
			AddEllipsisString(rowData.cellDataList[0].drawitems, statInfo.UIData.Detail, 303, getInstanceL2Util().White, false, true, 3);
			AddRichListCtrlString(rowData.cellDataList[1].drawitems, valueStr, GTColor().Frangipani, false);
			if((i < recordCnt))
			{
				FightInfo_ListCtrl.ModifyRecord(i, rowData);
			}
			else
			{
				FightInfo_ListCtrl.InsertRecord(rowData);
			}
			i++;
			continue;
		}
		FightInfo_ListCtrl.DeleteRecord(((recordCnt - deleteIndex) - 1));
		deleteIndex++;
		i++;
	}
	return;
}

function S_EX_USER_VIEW_INFO_PARAMETER()
{
	local int i;
	local UIPacket._S_EX_USER_VIEW_INFO_PARAMETER packet;
	local UIPacket._PkUserViewInfoParameter userStat;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_USER_VIEW_INFO_PARAMETER(packet))
	{
		return;
	}
	i = 0;
	while((i < packet.Parameters.Length))
	{
		userStat = packet.Parameters[i];
		if((userStat.Type < 300))
		{
			_packetParams[userStat.Type] = userStat;
			i++;
			continue;
		}
		Debug((("!!!!! S_EX_USER_VIEW_INFO_PARAMETER UserViewInfoParameter" @ string(300)) $ "을 넘어가므로 확인 필요"));  // EN?: Exceeds, needs to be confirmed
		i++;
	}
	UpdateUIControls();
	return;
}

function RichListCtrlRowData MakeCategoryRecord(int i, string Value)
{
	local RichListCtrlRowData Record;

	Record.nReserved1 = INT64(i);
	Record.cellDataList.Length = 1;
	Record.cellDataList[0].szData = Value;
	AddRichListCtrlString(Record.cellDataList[0].drawitems, Record.cellDataList[0].szData, getInstanceL2Util().White, false, 5);
	return Record;
}

event OnClickListCtrlRecord(string ListCtrlID)
{
	switch(ListCtrlID)
	{
		case "Category_ListCtrl":
			_selectedCategory = Category_ListCtrl.GetSelectedIndex();
			FightInfo_ListCtrl.SetSelectedIndex(0, true);
			FightInfo_ListCtrl.SetSelectedIndex(-1, false);
			UpdateUIControls();
			break;
		default:
			break;
	}
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(40);
	RegisterEvent((100000 + 941));
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 40:
			initBool = false;
			FightInfo_ListCtrl.DeleteAllItem();
			Category_ListCtrl.DeleteAllItem();
			_selectedCategory = 0;
			_packetParams.Length = 0;
			_categoryInfos.Length = 0;
			break;
		case (100000 + 941):
			if((initBool == false))
			{
				initBool = true;
				InitData();
				InitCategoryListControls();
			}
			S_EX_USER_VIEW_INFO_PARAMETER();
			break;
		default:
			break;
	}
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	Me.EnableWindow();
	return;
}

event OnShow()
{
	local WindowHandle parentWnd;

	UpdateUIControls();
	parentWnd = GetWindowHandle("DetailStatusWndClassic");
	getInstanceL2Util().windowMoveToSide(parentWnd, Me, 6, 0);
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	Me.HideWindow();
	return;
}
