class RelicWndInfo extends UICommonAPI;

var WindowHandle Me;
var CharacterViewportWindowHandle viewportWnd;
var TextBoxHandle nameTextBox;
var TextBoxHandle levelTextBox;
var TextBoxHandle countTextBox;
var TextBoxHandle noHaveTextBox;
var TextBoxHandle canEnchantTextBox;
var TextBoxHandle itemScoreTextBox;
var HtmlHandle statDesctHtml;
var TextureHandle relicSkillIconTex;
var TextureHandle decoNameTex;
var TextureHandle decoFrameTex;
var TextureHandle itemScoreTex;
var TextureHandle itemScoreDividerTex;
var AnimTextureHandle activeAnimTex;
var WindowHandle activeInfoWnd;
var RelicWnd.RelicInfo _relicInfo;

static function RelicWndInfo Inst()
{
	return RelicWndInfo(GetScript("RelicWndInfo"));
}

function Initialize()
{
	InitControls();
	return;
}

function InitControls()
{
	local string ownerFullPath;
	local WindowHandle nameWndContainer, statWndContainer;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	viewportWnd = GetCharacterViewportWindowHandle((ownerFullPath $ ".ObjectViewport"));
	nameWndContainer = GetWindowHandle((ownerFullPath $ ".RelicNameWnd"));
	statWndContainer = GetWindowHandle((ownerFullPath $ ".RelicSlotWnd"));
	nameTextBox = GetTextBoxHandle((nameWndContainer.m_WindowNameWithFullPath $ ".RelicTopName_txt"));
	levelTextBox = GetTextBoxHandle((nameWndContainer.m_WindowNameWithFullPath $ ".RelicFigure_txt"));
	countTextBox = GetTextBoxHandle((nameWndContainer.m_WindowNameWithFullPath $ ".RelicCount_txt"));
	activeInfoWnd = GetWindowHandle((ownerFullPath $ ".RelicActiveWnd"));
	activeAnimTex = GetAnimTextureHandle((activeInfoWnd.m_WindowNameWithFullPath $ ".RelicOnEffect_ani"));
	relicSkillIconTex = GetTextureHandle((statWndContainer.m_WindowNameWithFullPath $ ".RelicItem_tex"));
	statDesctHtml = GetHtmlHandle((statWndContainer.m_WindowNameWithFullPath $ ".RelicDetailInfo_txt"));
	canEnchantTextBox = GetTextBoxHandle((statWndContainer.m_WindowNameWithFullPath $ ".DollUpgradeInfo_txt"));
	noHaveTextBox = GetTextBoxHandle((ownerFullPath $ ".UnacquiredRelic_txt"));
	decoFrameTex = GetTextureHandle((ownerFullPath $ ".DollFrameDeco_tex"));
	decoNameTex = GetTextureHandle((ownerFullPath $ ".DollNameDeco_tex"));
	viewportWnd.SetUISound(false);
	itemScoreDividerTex = GetTextureHandle((statWndContainer.m_WindowNameWithFullPath $ ".RelicInfoDivider01"));
	itemScoreTex = GetTextureHandle((statWndContainer.m_WindowNameWithFullPath $ ".ItemScore_tex"));
	itemScoreTextBox = GetTextBoxHandle((statWndContainer.m_WindowNameWithFullPath $ ".ItemScore_txt"));
	if((IsShowItemScore() == false))
	{
		ShowItemScoreControls(false);
	}
	return;
}

function SetViewportSpawnNPC()
{
	return;
}

function SetInfo(RelicWnd.RelicInfo Info)
{
	local ItemInfo relicItemInfo;
	local SkillDefaultInfo SkillDefaultInfo;
	local SkillInfo relicSkillInfo;
	local string levelStr;
	local bool needNpcUpdate;
	local L2Util util;

	util = getInstanceL2Util();
	if(((_relicInfo.Data.NpcID != Info.Data.NpcID) || (_relicInfo.Data.Grade != Info.Data.Grade)))
	{
		needNpcUpdate = true;
	}
	_relicInfo = Info;
	if((Info.Level > 0))
	{
		levelStr = ("+" $ string(Info.Level));
	}
	else
	{
		levelTextBox.SetWindowSize(0, levelTextBox.GetRect().nHeight);
	}
	levelTextBox.SetText(levelStr);
	relicItemInfo = GetItemInfoByClassID(Info.Data.ItemID);
	nameTextBox.SetText(util.GetDollNameWithGrade(relicItemInfo.Name, ERelicGrade(Info.Data.Grade)));
	nameTextBox.SetTextColor(getInstanceL2Util().GetRelicTextColor(ERelicGrade(Info.Data.Grade)));
	countTextBox.SetText(("x" $ MakeCostString(string(Info.Count))));
	if(needNpcUpdate)
	{
		viewportWnd.SetNPCInfo((Info.Data.NpcID - 1000000));
		viewportWnd.SetSpawnDuration(0.1000000);
		viewportWnd.SpawnNPC();
		viewportWnd.PlayAnimation(0);
		viewportWnd.UpdateDollAutoCameraDist();
		viewportWnd.SetCharacterOffsetY(GetValidViewportOffsetY(Info.Data.NpcID));
		viewportWnd.ChangeNPCState(GetNpcState(ERelicGrade(Info.Data.Grade), Info.Level));
		Debug(((("RelicWndInfo Viewport NpcID :" @ string((Info.Data.NpcID - 1000000))) @ ", State :") @ string(GetNpcState(ERelicGrade(Info.Data.Grade), Info.Level))));
	}
	if((Info.Level < Info.Data.Skills.Length))
	{
		SkillDefaultInfo = Info.Data.Skills[Info.Level];
		if(GetSkillInfo(SkillDefaultInfo.SkillID, SkillDefaultInfo.SkillLevel, 0, relicSkillInfo))
		{
			relicSkillIconTex.SetTexture(relicSkillInfo.TexName);
			statDesctHtml.LoadHtmlFromString(Class'InterfaceClassic.RelicWnd'.static.Inst().GetHtmlSkillStr(SkillDefaultInfo));
			if(IsShowItemScore())
			{
				if((SkillDefaultInfo.ItemScore > 0))
				{
					ShowItemScoreControls(true);
					itemScoreTextBox.SetText(string(SkillDefaultInfo.ItemScore));
				}
				else
				{
					ShowItemScoreControls(false);
				}
			}
		}
	}
	if((Info.Data.Skills.Length > 1))
	{
		if((Info.Data.Skills.Length == (Info.Level + 1)))
		{
			canEnchantTextBox.SetText(GetSystemString(14565));
			canEnchantTextBox.SetTextColor(util.ColorLightBrown);
		}
		else
		{
			canEnchantTextBox.SetText(GetSystemMessage(14000));
			canEnchantTextBox.SetTextColor(util.Yellow);
		}
	}
	else
	{
		canEnchantTextBox.SetText(GetSystemString(3896));
		canEnchantTextBox.SetTextColor(util.Gray);
	}
	UpdateActiveState();
	UpdateFrameDeco();
	return;
}

function UpdateActiveState()
{
	if(_relicInfo.IsActive)
	{
		activeInfoWnd.ShowWindow();
		noHaveTextBox.HideWindow();
	}
	else
	{
		activeInfoWnd.HideWindow();
		noHaveTextBox.ShowWindow();
		if((_relicInfo.isEnabled == true))
		{
			noHaveTextBox.SetText(GetSystemString(14687));
		}
		else
		{
			noHaveTextBox.SetText(GetSystemString(14582));
		}
	}
	return;
}

function UpdateFrameDeco()
{
	local UIConstants.ERelicGrade Grade;
	local string frameTexName, nameTexName;

	Grade = ERelicGrade(_relicInfo.Data.Grade);
	if((int(Grade) == 7))
	{
		frameTexName = "L2UI_NewTex.RelicWnd.DollNpcDeco_R";
		nameTexName = "L2UI_NewTex.RelicWnd.DollNameDeco_R";
	}
	else if((int(Grade) == 6))
	{
		frameTexName = "L2UI_NewTex.RelicWnd.DollNpcDeco_S";
		nameTexName = "L2UI_NewTex.RelicWnd.DollNameDeco_S";
	}
	else if((int(Grade) == 5))
	{
		frameTexName = "L2UI_NewTex.RelicWnd.DollNpcDeco_A";
	}
	if((frameTexName == ""))
	{
		decoFrameTex.HideWindow();
	}
	else
	{
		decoFrameTex.SetTexture(frameTexName);
		decoFrameTex.ShowWindow();
	}
	if((nameTexName == ""))
	{
		decoNameTex.HideWindow();
	}
	else
	{
		decoNameTex.SetTexture(nameTexName);
		decoNameTex.ShowWindow();
	}
	return;
}

function int GetNpcState(UIConstants.ERelicGrade Grade, int Level)
{
	local int npcState;

	if((Level > 0))
	{
		npcState = (4 + Level);
	}
	else if((int(Grade) == 5))
	{
		npcState = 2;
	}
	else if((int(Grade) == 6))
	{
		npcState = 3;
	}
	else if((int(Grade) == 7))
	{
		npcState = 4;
	}
	else
	{
		npcState = 1;
	}
	return npcState;
}

function PlayActiveAnimTex()
{
	UpdateActiveState();
	activeAnimTex.Stop();
	activeAnimTex.Play();
	return;
}

function ResetInfo()
{
	local RelicWnd.RelicInfo defaultInfo;

	_relicInfo = defaultInfo;
	return;
}

function ResetSpawnEffect()
{
	return;
}

function ShowItemScoreControls(bool isShow)
{
	if(isShow)
	{
		statDesctHtml.SetWindowSize(347, 101);
		itemScoreDividerTex.ShowWindow();
		itemScoreTex.ShowWindow();
		itemScoreTextBox.ShowWindow();
	}
	else
	{
		statDesctHtml.SetWindowSize(347, 129);
		itemScoreDividerTex.HideWindow();
		itemScoreTex.HideWindow();
		itemScoreTextBox.HideWindow();
	}
	return;
}

function string GetGradeEffectPath(UIConstants.ERelicGrade Grade)
{
	switch(Grade)
	{
		case RG_C:
			return "LineageEffect2.ui_relic_deco_blue";
		case RG_B:
			return "LineageEffect2.ui_relic_deco_red";
		case RG_A:
			return "LineageEffect2.ui_relic_deco_purple";
		default:
			return "";
	}
}

function int GetValidViewportOffsetY(int dollNpcId)
{
	local int OffsetY;

	if((dollNpcId == 1019786))
	{
		OffsetY = 100;
	}
	return OffsetY;
}

event OnClickButton(string Name)
{
	local string dollName;

	switch(Name)
	{
		case "MagnifyingBtn":
			dollName = getInstanceL2Util().GetDollNameWithGrade(GetItemInfoByClassID(_relicInfo.Data.ItemID).Name, ERelicGrade(_relicInfo.Data.Grade));
			Class'InterfaceClassic.RelicWnd'.static.Inst().relicCollectionScript.SetRelicShortcutState(dollName);
			Class'InterfaceClassic.RelicWnd'.static.Inst().SetTabGroupButtonSelected(COLLECTION);
			break;
		default:
			break;
	}
	return;
}

event OnLoad()
{
	Initialize();
	return;
}
