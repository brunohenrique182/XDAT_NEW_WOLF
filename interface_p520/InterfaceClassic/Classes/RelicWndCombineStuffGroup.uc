class RelicWndCombineStuffGroup extends UICommonAPI;

var WindowHandle Me;
var TextureHandle effectOnBgTex;
var TextureHandle slotOnBgTex;
var TextureHandle resultSlotTex;
var TextureHandle slotOnDecoTex;
var TextBoxHandle indexTextBox;
var array<TextureHandle> stuffTextures;
var UIConstants.ERelicGrade _grade;
var array<int> _stuffList;
var int _index;

function Init(WindowHandle ownerWnd, int Index)
{
	local string ownerFullPath;
	local int i;

	_index = Index;
	Me = ownerWnd;
	ownerFullPath = ownerWnd.m_WindowNameWithFullPath;
	effectOnBgTex = GetTextureHandle((ownerFullPath $ ".CombineListLightBg_tex"));
	slotOnBgTex = GetTextureHandle((ownerFullPath $ ".CombineSlotOn_tex"));
	slotOnDecoTex = GetTextureHandle((ownerFullPath $ ".CombineListDeco_tex"));
	resultSlotTex = GetTextureHandle((ownerFullPath $ ".RelicCardCover_tex"));
	indexTextBox = GetTextBoxHandle((ownerFullPath $ ".RelicCombineOrder_txt"));
	indexTextBox.SetText(string((Index + 1)));
	stuffTextures.Length = 0;
	i = 0;
	while((i < 4))
	{
		stuffTextures[i] = GetTextureHandle(((ownerFullPath $ ".RelicItem") $ string(i)));
		i++;
	}
	return;
}

function SetInfo(UIConstants.ERelicGrade Grade, array<int> stuffList)
{
	local int i;
	local ItemInfo relicItemInfo;
	local RelicsMainUIData relicUIData;

	_grade = Grade;
	_stuffList = stuffList;
	i = 0;
	while((i < stuffTextures.Length))
	{
		if((i < stuffList.Length))
		{
			GetRelicsMainData(stuffList[i], relicUIData);
			relicItemInfo = GetItemInfoByClassID(relicUIData.ItemID);
			stuffTextures[i].SetTexture(relicItemInfo.IconName);
			i++;
			continue;
		}
		stuffTextures[i].SetTexture("");
		i++;
	}
	if((stuffTextures.Length == stuffList.Length))
	{
		resultSlotTex.SetTexture(GetResultSlotTextureName(Grade));
		resultSlotTex.ShowWindow();
		effectOnBgTex.ShowWindow();
		slotOnBgTex.ShowWindow();
		slotOnDecoTex.ShowWindow();
	}
	else
	{
		resultSlotTex.HideWindow();
		effectOnBgTex.HideWindow();
		slotOnBgTex.HideWindow();
		slotOnDecoTex.HideWindow();
	}
	return;
}

function string GetResultSlotTextureName(UIConstants.ERelicGrade Grade)
{
	switch(Grade)
	{
		case RG_N:
			return "L2UI_NewTex.RelicWnd.DollCombine_DN";
		case RG_D:
			return "L2UI_NewTex.RelicWnd.DollCombine_CD";
		case RG_C:
			return "L2UI_NewTex.RelicWnd.DollCombine_BC";
		case RG_B:
			return "L2UI_NewTex.RelicWnd.DollCombine_AB";
		case RG_A:
			return "L2UI_NewTex.RelicWnd.DollCombine_SA";
		case RG_S:
			return "L2UI_NewTex.RelicWnd.DollCombine_RS";
		default:
			return "";
	}
}
