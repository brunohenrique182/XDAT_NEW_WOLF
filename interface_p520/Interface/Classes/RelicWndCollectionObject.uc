class RelicWndCollectionObject extends UICommonAPI
	dependson(UIPacket);

const RELIC_COLLECTION_MAX_SLOT = 10;

var WindowHandle Me;
var TextureHandle checkTex;
var TextureHandle uncheckTex;
var TextureHandle reddotTex;
var TextureHandle completeBGTex;
var TextBoxHandle TitleTextBox;
var TextBoxHandle statTextBox;
var array<WindowHandle> _slotWndList;

function Init(WindowHandle ownerWnd)
{
	local string ownerFullPath;
	local int i;

	Me = ownerWnd;
	ownerFullPath = ownerWnd.m_WindowNameWithFullPath;
	TitleTextBox = GetTextBoxHandle((ownerFullPath $ ".CollectionTitle_txt"));
	statTextBox = GetTextBoxHandle((ownerFullPath $ ".CollectionEffect_txt"));
	checkTex = GetTextureHandle((ownerFullPath $ ".CheckComplete_tex"));
	uncheckTex = GetTextureHandle((ownerFullPath $ ".CheckEmpty_tex"));
	reddotTex = GetTextureHandle((ownerFullPath $ ".Registration_tex"));
	completeBGTex = GetTextureHandle((ownerFullPath $ ".CollectionCompleteBg_tex"));
	_slotWndList.Length = 0;
	i = 0;
	while((i < 10))
	{
		_slotWndList[i] = GetWindowHandle(((ownerFullPath $ ".CollectionRelicSlotWnd") $ string(i)));
		i++;
	}
	return;
}

function SetInfo(RelicWnd.RelicCollectionInfo Info, string searchStr)
{
	local int i;
	local WindowHandle slotWnd;

	if(Info.isComplete)
	{
		checkTex.ShowWindow();
		uncheckTex.HideWindow();
		completeBGTex.ShowWindow();
	}
	else
	{
		checkTex.HideWindow();
		uncheckTex.ShowWindow();
		completeBGTex.HideWindow();
	}
	if(Info.IsNew)
	{
		reddotTex.ShowWindow();
	}
	else
	{
		reddotTex.HideWindow();
	}
	TitleTextBox.SetText(Info.Data.CollectionName);
	statTextBox.SetText(Class'Interface.RelicWnd'.static.Inst().GetCollectionStatStr(Info.Data.Options));
	i = 0;
	while((i < _slotWndList.Length))
	{
		slotWnd = _slotWndList[i];
		if((i < Info.Data.NeedRelics.Length))
		{
			SetRelicSlot(slotWnd, Info.Data.NeedRelics[i], Info.isComplete, Info.relicsList, searchStr);
			slotWnd.ShowWindow();
			i++;
			continue;
		}
		slotWnd.HideWindow();
		i++;
	}
	Me.ShowWindow();
	return;
}

function ResetInfo()
{
	Me.HideWindow();
	return;
}

function SetRelicSlot(WindowHandle slotWnd, RelicsCollectionNeed needRelicInfo, bool isComplete, array<UIPacket._CollectionRelicsInfo> relicsList, string searchStr)
{
	local TextureHandle relicTex, gradeBGTex, searchItemTex, reddotTex;
	local TextBoxHandle levelTextBox;
	local ButtonHandle shortcutBtn;
	local ItemInfo relicItemInfo;
	local RelicsMainUIData relicUIData;
	local UIPacket._CollectionRelicsInfo collectedRelic;
	local string relicName;
	local bool isCollected;
	local int i;

	searchItemTex = GetTextureHandle((slotWnd.m_WindowNameWithFullPath $ ".SearchItem_tex"));
	relicTex = GetTextureHandle((slotWnd.m_WindowNameWithFullPath $ ".RelicItem_tex"));
	gradeBGTex = GetTextureHandle((slotWnd.m_WindowNameWithFullPath $ ".CollectionGradeSlot_tex"));
	levelTextBox = GetTextBoxHandle((slotWnd.m_WindowNameWithFullPath $ ".RelicUpgradeNum_txt"));
	shortcutBtn = GetButtonHandle((slotWnd.m_WindowNameWithFullPath $ ".RelicItem_btn"));
	reddotTex = GetTextureHandle((slotWnd.m_WindowNameWithFullPath $ ".RedDot_tex"));
	GetRelicsMainData(needRelicInfo.RelicsID, relicUIData);
	relicItemInfo = GetItemInfoByClassID(relicUIData.ItemID);
	gradeBGTex.SetTexture(GetSlotGradeTextureName(ERelicGrade(relicUIData.Grade)));
	relicTex.SetTexture(relicItemInfo.IconName);
	if((needRelicInfo.RelicsLevel > 0))
	{
		levelTextBox.SetText(("+" $ string(needRelicInfo.RelicsLevel)));
	}
	else
	{
		levelTextBox.SetText("");
	}
	if(isComplete)
	{
		isCollected = true;
	}
	else
	{
		i = 0;
		while((i < relicsList.Length))
		{
			collectedRelic = relicsList[i];
			if(((collectedRelic.nRelicsID == needRelicInfo.RelicsID) && (collectedRelic.nLevel == needRelicInfo.RelicsLevel)))
			{
				isCollected = true;
				break;
			}
			i++;
		}
	}
	shortcutBtn.SetTooltipCustomType(GetRelicCustomTooltip(relicItemInfo.Name, ERelicGrade(relicUIData.Grade), needRelicInfo.RelicsLevel));
	searchItemTex.HideWindow();
	reddotTex.HideWindow();
	if((searchStr != ""))
	{
		relicName = getInstanceL2Util().GetDollNameWithGrade(relicItemInfo.Name, ERelicGrade(relicUIData.Grade));
		if(StringMatching(relicName, searchStr, " "))
		{
			searchItemTex.ShowWindow();
		}
	}
	if(isCollected)
	{
		gradeBGTex.SetAlpha(255);
		relicTex.SetAlpha(255);
		shortcutBtn.SetEnable(false);
	}
	else
	{
		if(Class'Interface.RelicWnd'.static.Inst().IsRelicEnabled(needRelicInfo.RelicsID))
		{
			shortcutBtn.SetTooltipCustomType(GetRelicCustomTooltip(relicItemInfo.Name, ERelicGrade(relicUIData.Grade), needRelicInfo.RelicsLevel, true));
			shortcutBtn.SetEnable(true);
			reddotTex.ShowWindow();
		}
		else
		{
			shortcutBtn.SetEnable(false);
		}
		gradeBGTex.SetAlpha(100);
		relicTex.SetAlpha(100);
	}
	return;
}

function string GetSlotGradeTextureName(UIConstants.ERelicGrade Grade)
{
	switch(Grade)
	{
		case RG_N:
			return "L2UI_NewTex.RelicWnd.CollectionGradeSlot_N";
		case RG_D:
			return "L2UI_NewTex.RelicWnd.CollectionGradeSlot_D";
		case RG_C:
			return "L2UI_NewTex.RelicWnd.CollectionGradeSlot_C";
		case RG_B:
			return "L2UI_NewTex.RelicWnd.CollectionGradeSlot_B";
		case RG_A:
			return "L2UI_NewTex.RelicWnd.CollectionGradeSlot_A";
		default:
			return "";
	}
}

function CustomTooltip GetRelicCustomTooltip(string Name, UIConstants.ERelicGrade Grade, int Level, optional bool bShortcut)
{
	local array<DrawItemInfo> drawListArr;
	local string gradeTexName;
	local int OffsetX;

	gradeTexName = Class'Interface.RelicWnd'.static.Inst().relicInfoScript.GetGradeTextureName(Grade);
	if((gradeTexName != ""))
	{
		drawListArr[drawListArr.Length] = addDrawItemTextureCustom(gradeTexName, false, false, 0, 0, 13, 13, 24, 24);
	}
	if((Level > 0))
	{
		drawListArr[drawListArr.Length] = addDrawItemText(("+" $ string(Level)), getInstanceL2Util().Yellow, "", false, true, 2);
	}
	if(((gradeTexName != "") || (Level > 0)))
	{
		OffsetX = 4;
	}
	drawListArr[drawListArr.Length] = addDrawItemText(Name, getInstanceL2Util().GetRelicTextColor(Grade), "", false, true, OffsetX);
	if(bShortcut)
	{
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(50);
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14859), getInstanceL2Util().White, "", true, true);
	}
	return MakeTooltipMultiTextByArray(drawListArr);
}
