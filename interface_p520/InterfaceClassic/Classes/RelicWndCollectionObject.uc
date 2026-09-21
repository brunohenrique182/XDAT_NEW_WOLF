class RelicWndCollectionObject extends UICommonAPI
	dependson(UIPacket);

const RELIC_COLLECTION_MAX_SLOT = 10;

var WindowHandle Me;
var TextureHandle checkTex;
var TextureHandle uncheckTex;
var TextureHandle reddotTex;
var TextureHandle completeBGTex;
var TextureHandle itemScoreTex;
var TextBoxHandle TitleTextBox;
var TextBoxHandle statTextBox;
var TextBoxHandle itemScoreTextBox;
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
	itemScoreTex = GetTextureHandle((ownerFullPath $ ".ItemScore_tex"));
	itemScoreTextBox = GetTextBoxHandle((ownerFullPath $ ".ItemScore_txt"));
	_slotWndList.Length = 0;
	i = 0;
	while((i < 10))
	{
		_slotWndList[i] = GetWindowHandle(((ownerFullPath $ ".CollectionRelicSlotWnd") $ string(i)));
		i++;
	}
	if((IsShowItemScore() == false))
	{
		itemScoreTex.HideWindow();
		itemScoreTextBox.HideWindow();
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
	statTextBox.SetText(Class'InterfaceClassic.RelicWnd'.static.Inst().GetCollectionStatStr(Info.Data.Options));
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
	if(IsShowItemScore())
	{
		if((Info.Data.ItemScore > 0))
		{
			itemScoreTextBox.SetText(string(Info.Data.ItemScore));
			itemScoreTex.ShowWindow();
			itemScoreTextBox.ShowWindow();
		}
		else
		{
			itemScoreTex.HideWindow();
			itemScoreTextBox.HideWindow();
		}
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
	local TextureHandle relicTex, gradeBGTex, searchItemTex;
	local TextBoxHandle levelTextBox;
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
	relicTex.SetTooltipCustomType(GetRelicCustomTooltip(relicItemInfo.Name, ERelicGrade(relicUIData.Grade), needRelicInfo.RelicsLevel));
	searchItemTex.HideWindow();
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
	}
	else
	{
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
			return "L2UI_NewTex.RelicWnd.DollGradeSlot_N";
		case RG_D:
			return "L2UI_NewTex.RelicWnd.DollGradeSlot_D";
		case RG_C:
			return "L2UI_NewTex.RelicWnd.DollGradeSlot_C";
		case RG_B:
			return "L2UI_NewTex.RelicWnd.DollGradeSlot_B";
		case RG_A:
			return "L2UI_NewTex.RelicWnd.DollGradeSlot_A";
		case RG_S:
			return "L2UI_NewTex.RelicWnd.DollGradeSlot_S";
		case RG_R:
			return "L2UI_NewTex.RelicWnd.DollGradeSlot_R";
		default:
			return "";
	}
}

function CustomTooltip GetRelicCustomTooltip(string Name, UIConstants.ERelicGrade Grade, int Level)
{
	local array<DrawItemInfo> drawListArr;
	local string gradeTexName;
	local int OffsetX;

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
	drawListArr[drawListArr.Length] = addDrawItemText(getInstanceL2Util().GetDollNameWithGrade(Name, Grade), getInstanceL2Util().GetRelicTextColor(Grade), "", false, true, OffsetX);
	return MakeTooltipMultiTextByArray(drawListArr);
}
