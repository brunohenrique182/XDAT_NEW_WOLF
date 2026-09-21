class RelicWndInfo extends UICommonAPI;

var WindowHandle Me;
var CharacterViewportWindowHandle viewportWnd;
var EffectViewportWndHandle effectViewportWnd;
var TextBoxHandle nameTextBox;
var TextBoxHandle levelTextBox;
var TextBoxHandle countTextBox;
var TextBoxHandle noHaveTextBox;
var HtmlHandle statDesctHtml;
var TextureHandle gradeTex;
var TextureHandle relicSkillIconTex;
var AnimTextureHandle activeAnimTex;
var WindowHandle activeInfoWnd;
var ButtonHandle activeBtn;
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
	effectViewportWnd = GetEffectViewportWndHandle((ownerFullPath $ ".RelicGradeEffectViewport"));
	nameWndContainer = GetWindowHandle((ownerFullPath $ ".RelicNameWnd"));
	statWndContainer = GetWindowHandle((ownerFullPath $ ".RelicSlotWnd"));
	nameTextBox = GetTextBoxHandle((nameWndContainer.m_WindowNameWithFullPath $ ".RelicTopName_txt"));
	levelTextBox = GetTextBoxHandle((nameWndContainer.m_WindowNameWithFullPath $ ".RelicFigure_txt"));
	countTextBox = GetTextBoxHandle((nameWndContainer.m_WindowNameWithFullPath $ ".RelicCount_txt"));
	gradeTex = GetTextureHandle((nameWndContainer.m_WindowNameWithFullPath $ ".GradeIcon_tex"));
	activeInfoWnd = GetWindowHandle((ownerFullPath $ ".RelicActiveWnd"));
	activeAnimTex = GetAnimTextureHandle((activeInfoWnd.m_WindowNameWithFullPath $ ".RelicOnEffect_ani"));
	relicSkillIconTex = GetTextureHandle((statWndContainer.m_WindowNameWithFullPath $ ".RelicItem_tex"));
	statDesctHtml = GetHtmlHandle((statWndContainer.m_WindowNameWithFullPath $ ".RelicDetailInfo_txt"));
	noHaveTextBox = GetTextBoxHandle((ownerFullPath $ ".UnacquiredRelic_txt"));
	activeBtn = GetButtonHandle((ownerFullPath $ ".RelicOn_btn"));
	viewportWnd.SetAutoCameraDistByWeapon(true);
	return;
}

function SetViewportSpawnNPC()
{
	viewportWnd.SetNPCInfo(19864);
	viewportWnd.SpawnNPC();
	return;
}

function SetInfo(RelicWnd.RelicInfo Info)
{
	local ItemInfo relicItemInfo;
	local SkillDefaultInfo SkillDefaultInfo;
	local SkillInfo relicSkillInfo;
	local string levelStr;
	local bool needEffectUpdate;

	if((_relicInfo.Data.Grade != Info.Data.Grade))
	{
		needEffectUpdate = true;
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
	nameTextBox.SetText(relicItemInfo.Name);
	nameTextBox.SetTextColor(getInstanceL2Util().GetRelicTextColor(ERelicGrade(Info.Data.Grade)));
	gradeTex.SetTexture(GetGradeTextureName(ERelicGrade(Info.Data.Grade)));
	countTextBox.SetText(("x" $ MakeCostString(string(Info.Count))));
	if((Info.Level < Info.Data.Enchants.Length))
	{
		viewportWnd.SetWeapon(Info.Data.ItemID, Info.Data.Enchants[Info.Level]);
	}
	if(needEffectUpdate)
	{
		effectViewportWnd.SpawnEffect(GetGradeEffectPath(ERelicGrade(Info.Data.Grade)));
	}
	if((Info.Level < Info.Data.Skills.Length))
	{
		SkillDefaultInfo = Info.Data.Skills[Info.Level];
		if(GetSkillInfo(SkillDefaultInfo.SkillID, SkillDefaultInfo.SkillLevel, 0, relicSkillInfo))
		{
			relicSkillIconTex.SetTexture(relicSkillInfo.TexName);
			statDesctHtml.LoadHtmlFromString(Class'Interface.RelicWnd'.static.Inst().GetHtmlSkillStr(SkillDefaultInfo));
		}
	}
	UpdateActiveState();
	return;
}

function UpdateActiveState()
{
	local int activeRelicId;
	local bool IsActive;

	activeRelicId = Class'Interface.RelicWnd'.static.Inst().GetActiveRelicId();
	if((_relicInfo.relicId == activeRelicId))
	{
		IsActive = true;
	}
	if(IsActive)
	{
		activeInfoWnd.ShowWindow();
	}
	else
	{
		activeInfoWnd.HideWindow();
	}
	if(((_relicInfo.isEnabled == false) || IsActive))
	{
		activeBtn.SetEnable(false);
	}
	else
	{
		activeBtn.SetEnable(true);
	}
	if((_relicInfo.isEnabled == true))
	{
		noHaveTextBox.HideWindow();
	}
	else
	{
		noHaveTextBox.ShowWindow();
	}
	return;
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
	effectViewportWnd.SpawnEffect("");
	return;
}

function string GetGradeTextureName(UIConstants.ERelicGrade Grade)
{
	switch(Grade)
	{
		case RG_N:
			return "";
		case RG_D:
			return "L2UI_NewTex.RelicWnd.GradeIcon_D";
		case RG_C:
			return "L2UI_NewTex.RelicWnd.GradeIcon_C";
		case RG_B:
			return "L2UI_NewTex.RelicWnd.GradeIcon_B";
		case RG_A:
			return "L2UI_NewTex.RelicWnd.GradeIcon_A";
		default:
			return "";
	}
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

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "RelicOn_btn":
			Class'Interface.RelicWnd'.static.Inst().Rq_C_EX_RELICS_ACTIVE(_relicInfo.relicId);
			break;
		case "MagnifyingBtn":
			Class'Interface.RelicWnd'.static.Inst().relicCollectionScript.SetRelicShortcutState(GetItemInfoByClassID(_relicInfo.Data.ItemID).Name);
			Class'Interface.RelicWnd'.static.Inst().SetTabGroupButtonSelected(COLLECTION);
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
