class FactionWnd extends L2UIGFxScript;

const TYPE_FACTION_START_NPC = 2;

function OnRegisterEvent()
{
	RegisterGFxEvent(10080);
	RegisterGFxEvent(10170);
	return;
}

function OnLoad()
{
	AddState("GAMINGSTATE");
	SetContainerWindow("SkinnedWindow", 3443);
	return;
}

function OnHide()
{
	return;
}

function OnShow()
{
	return;
}

function MinimapRegionInfo makeRegionInfo(string ToolTipString, Vector pLoc)
{
	local MinimapRegionInfo regionInfoForMapIcon;
	local MinimapRegionIconData IconData;
	local string toolTipParam;

	toolTipParam = "";
	ParamAdd(toolTipParam, "tooltipString", ToolTipString);
	ParamAdd(toolTipParam, "Type", string(9));
	regionInfoForMapIcon.strTooltip = toolTipParam;
	regionInfoForMapIcon.eType = MRT_Etc;
	regionInfoForMapIcon.nIndex = 2;
	IconData.nWidth = 32;
	IconData.nHeight = 32;
	IconData.nWorldLocX = int(pLoc.X);
	IconData.nWorldLocY = int(pLoc.Y);
	IconData.nWorldLocZ = int(pLoc.Z);
	IconData.nIconOffsetX = -3;
	IconData.nIconOffsetY = -20;
	IconData.strIconNormal = "L2UI_CT1.Minimap.Minimap_DF_Icon_Pin_Campaign_Over";
	IconData.strIconOver = "L2UI_CT1.Minimap.Minimap_DF_Icon_Pin_Campaign";
	IconData.strIconPushed = "L2UI_CT1.Minimap.Minimap_DF_Icon_Pin_Campaign_Over";
	regionInfoForMapIcon.IconData = IconData;
	return regionInfoForMapIcon;
}
