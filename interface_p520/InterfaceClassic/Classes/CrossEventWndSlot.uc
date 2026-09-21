class CrossEventWndSlot extends UICommonAPI;

const SEASON_TEX_PATH_STAMP = "L2UI_NewTex.CrossEventWnd.CompletStampSeason_";
const SEASON_TEX_PATH_CROSS = "L2UI_NewTex.CrossEventWnd.CrossStampSeason_";
const SEASON_TEX_PATH_STAMP_ANIM = "L2UI_NewTex.CrossEventWnd.CompletStampEffectSeason";

var CrossEventWnd.CrossEventSlotInfo _info;
var WindowHandle Me;
var TextureHandle completeTex;
var TextureHandle stampTex;
var TextureHandle stampCrossTex;
var TextBoxHandle countTextBox;
var AnimTextureHandle stampAnimTex;
var ItemWindowHandle ItemWnd;

function Init(WindowHandle ownerWnd)
{
	local string ownerFullPath;

	Me = ownerWnd;
	ownerFullPath = ownerWnd.m_WindowNameWithFullPath;
	completeTex = GetTextureHandle((ownerFullPath $ ".CrossCompleteBox"));
	stampTex = GetTextureHandle((ownerFullPath $ ".CompleteStamp"));
	stampCrossTex = GetTextureHandle((ownerFullPath $ ".CrossStamp"));
	stampAnimTex = GetAnimTextureHandle((ownerFullPath $ ".CrossCompleteEffect"));
	ItemWnd = GetItemWindowHandle((ownerFullPath $ ".CrossItemSlot"));
	countTextBox = GetTextBoxHandle((ownerFullPath $ ".CrossItemSlot_Txt"));
	return;
}

function SetInfo(CrossEventWnd.CrossEventSlotInfo Info, int season)
{
	local ItemInfo RewardItemInfo;
	local string itemNumStr;

	_info = Info;
	UpdateSeasonSkinTexture(season);
	itemNumStr = ("x" $ MakeCostString(string(Info.RewardItemInfo.nAmount)));
	RewardItemInfo = GetItemInfoByClassID(Info.RewardItemInfo.nItemClassID);
	RewardItemInfo.ItemNum = Info.RewardItemInfo.nAmount;
	RewardItemInfo.bShowCount = false;
	countTextBox.SetText(itemNumStr);
	stampAnimTex.HideWindow();
	if(!ItemWnd.SetItem(0, RewardItemInfo))
	{
		ItemWnd.AddItem(RewardItemInfo);
	}
	if(Info.checked)
	{
		completeTex.ShowWindow();
		stampTex.ShowWindow();
	}
	else
	{
		completeTex.HideWindow();
		stampTex.HideWindow();
	}
	if(Info.crossed)
	{
		stampCrossTex.ShowWindow();
		completeTex.SetTexture("L2UI_NewTex.CrossEventWnd.CrossCompleteBox_yellow");
	}
	else
	{
		stampCrossTex.HideWindow();
		completeTex.SetTexture("L2UI_NewTex.CrossEventWnd.CrossCompleteBox_blue");
	}
	return;
}

function UpdateSeasonSkinTexture(int season)
{
	stampTex.SetTexture(("L2UI_NewTex.CrossEventWnd.CompletStampSeason_" $ string(season)));
	stampCrossTex.SetTexture(("L2UI_NewTex.CrossEventWnd.CrossStampSeason_" $ string(season)));
	stampAnimTex.SetTexture((("L2UI_NewTex.CrossEventWnd.CompletStampEffectSeason" $ string(season)) $ "_Ani0000"));
	return;
}

function PlayStampEffect()
{
	stampAnimTex.Stop();
	stampAnimTex.ShowWindow();
	stampAnimTex.Play();
	PlaySound("InterfaceSound.stamp_red");
	return;
}

function ResetInfo()
{
	return;
}
