class TeleportWndMap extends UICommonAPI;

const MAP_2D_WIDTH = 164;
const MAP_3D_WIDTH = 32768;
const ADEN_BOUNDARY_LEFT_MAP_OFFSET = 5;
const ADEN_BOUNDARY_TOP_MAP_OFFSET = 8;
const GRACIA_BOUNDARY_LEFT_MAP_OFFSET = -10;
const GRACIA_BOUNDARY_TOP_MAP_OFFSET = -8;
const TELEPORT_MAP_SCALE = 0.166;
const MAP_ICON_OFFSET_X = 12;
const MAP_ICON_OFFSET_Y = 23;
const TIMER_ID_PLAYER_POSITION = 1;
const TIMER_PLAYER_POSITION = 1000;
const MAX_TOWN_NUM = 30;
const MAX_DOMINION_NUM = 50;
const TAG_ICON_WIDTH = 35;

var float adenBoundryLeftLocX;
var float adenBoundryTopLocY;
var float graciaBoundryLeftLocX;
var float graciaBoundryTopLocY;
var float worldMapScale;
var int currentTooltipTeleportID;
var WindowHandle Me;
var WindowHandle mapTooltip;
var TextureHandle mapTex;
var TextureHandle mapTooltipCostTex;
var TextureHandle mapTooltipTagTex;
var AnimTextureHandle playerPosAnimTex;
var AnimTextureHandle townIconAnimTex;
var AnimTextureHandle townAreaAnimTex;
var AnimTextureHandle dominionIconAnimTex;
var AnimTextureHandle dominionAreaAnimTex;
var TextBoxHandle currentZoneTextBox;
var TextBoxHandle mapTooltipNameTextBox;
var TextBoxHandle mapTooltipCostTextBox;
var array<ButtonHandle> townMapIcons;
var array<ButtonHandle> dominionMapIcons;

static function TeleportWndMap Inst()
{
	return TeleportWndMap(GetScript("TeleportWnd.TeleportWndMap"));
}

function Initialize()
{
	adenBoundryLeftLocX = float((-5 * 32768));
	adenBoundryTopLocY = float((-8 * 32768));
	graciaBoundryLeftLocX = (-10.0000000 * 32768.0000000);
	graciaBoundryTopLocY = (-8.0000000 * 32768.0000000);
	worldMapScale = (164.0000000 / 32768.0000000);
	InitControls();
	return;
}

function InitControls()
{
	local string ownerFullPath;
	local int i;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	mapTooltip = GetWindowHandle((ownerFullPath $ ".Map_ToolTip"));
	mapTooltipNameTextBox = GetTextBoxHandle((mapTooltip.m_WindowNameWithFullPath $ ".Tooltip_txt"));
	mapTooltipCostTextBox = GetTextBoxHandle((mapTooltip.m_WindowNameWithFullPath $ ".adena_txt"));
	mapTooltipCostTex = GetTextureHandle((mapTooltip.m_WindowNameWithFullPath $ ".adena_tex"));
	mapTooltipTagTex = GetTextureHandle((mapTooltip.m_WindowNameWithFullPath $ ".MapTag_tex"));
	playerPosAnimTex = GetAnimTextureHandle((ownerFullPath $ ".Icon_MyPosition_Ani"));
	townIconAnimTex = GetAnimTextureHandle((ownerFullPath $ ".Map_TownIcon_Ani"));
	dominionIconAnimTex = GetAnimTextureHandle((ownerFullPath $ ".HuntingIcon_Ani"));
	townAreaAnimTex = GetAnimTextureHandle((ownerFullPath $ ".Icon_TownZone_Ani"));
	dominionAreaAnimTex = GetAnimTextureHandle((ownerFullPath $ ".Icon_HuntuingZone_Ani"));
	currentZoneTextBox = GetTextBoxHandle((ownerFullPath $ ".MyLocation_txt"));
	if(getInstanceUIData().GetIsClassicServer())
	{
		GetTextureHandle((ownerFullPath $ ".ServerMapLoad_Classic_tex")).ShowWindow();
		GetTextureHandle((ownerFullPath $ ".ServerMapLoad_Live_tex")).HideWindow();
	}
	else
	{
		GetTextureHandle((ownerFullPath $ ".ServerMapLoad_Classic_tex")).HideWindow();
		GetTextureHandle((ownerFullPath $ ".ServerMapLoad_Live_tex")).ShowWindow();
	}
	townMapIcons.Length = 0;
	dominionMapIcons.Length = 0;
	i = 0;
	while((i < 30))
	{
		AddMapIconControl(townMapIcons, "Icon_TownZone_", i, Me);
		i++;
	}
	i = 0;
	while((i < 50))
	{
		AddMapIconControl(dominionMapIcons, "Icon_HuntuingZone_", i, Me);
		i++;
	}
	mapTooltip.HideWindow();
	return;
}

function AddMapIconControl(out array<ButtonHandle> componentList, string componentName, int Index, WindowHandle Owner)
{
	local ButtonHandle targetButtonHandle;

	targetButtonHandle = GetButtonHandle((((Owner.m_WindowNameWithFullPath $ ".") $ componentName) $ string(Index)));
	componentList[componentList.Length] = targetButtonHandle;
	return;
}

function ShowMapIconTooltip(int TeleportID)
{
	local ButtonHandle targetIconBtn;
	local TeleportWnd.TeleportInfo TeleportInfo;
	local Rect tooltipRect;
	local bool isFoundIconBtn, isDominionIcon;
	local int i, textWidth, textHeight, costSize;
	local string CostText;

	if((currentTooltipTeleportID == TeleportID))
	{
		return;
	}
	i = 0;
	while((i < townMapIcons.Length))
	{
		targetIconBtn = townMapIcons[i];
		if((targetIconBtn.IsShowWindow() && (targetIconBtn.GetButtonValue() == TeleportID)))
		{
			isFoundIconBtn = true;
			break;
		}
		i++;
	}
	if((isFoundIconBtn == false))
	{
		i = 0;
		while((i < dominionMapIcons.Length))
		{
			targetIconBtn = dominionMapIcons[i];
			if((targetIconBtn.IsShowWindow() && (targetIconBtn.GetButtonValue() == TeleportID)))
			{
				isFoundIconBtn = true;
				isDominionIcon = true;
				break;
			}
			i++;
		}
	}
	if((isFoundIconBtn == false))
	{
		HideMapIconTooltip();
		return;
	}
	TeleportInfo = Class'InterfaceClassic.TeleportWnd'.static.Inst().GetTeleportInfo(TeleportID, true);
	tooltipRect = mapTooltip.GetRect();
	CostText = MakeCostStringINT64(Class'InterfaceClassic.TeleportWnd'.static.Inst().GetTeleportCost(TeleportInfo.Price[0].Amount, TeleportInfo.UsableLevel, TeleportInfo.UsableTransferDegree));
	GetTextSizeDefault(TeleportInfo.Name, textWidth, textHeight);
	GetTextSizeDefault(CostText, costSize, textHeight);
	mapTooltipNameTextBox.SetText(TeleportInfo.Name);
	mapTooltipCostTextBox.SetText(CostText);
	(costSize += 40);
	mapTooltipNameTextBox.SetWindowSize(textWidth, textHeight);
	if((int(TeleportInfo.showTagType) == 0))
	{
		mapTooltipTagTex.HideWindow();
		mapTooltipNameTextBox.MoveC(7, 7);
	}
	else
	{
		mapTooltipTagTex.SetTexture(GetTagTextureName(TeleportInfo.showTagType));
		mapTooltipTagTex.ShowWindow();
		mapTooltipNameTextBox.MoveC(46, 7);
		(textWidth += (35 + 4));
	}
	if((TeleportInfo.Price[0].Id == 57))
	{
		mapTooltipCostTex.SetTexture("L2UI_CT1.Icon.Icon_DF_Common_Adena");
	}
	else
	{
		mapTooltipCostTex.SetTexture("L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Icon_Lcoin");
	}
	mapTooltip.SetWindowSize(Max((textWidth + 16), costSize), 50);
	mapTooltip.MoveTo((targetIconBtn.GetRect().nX + 13), (targetIconBtn.GetRect().nY - 35));
	if(isDominionIcon)
	{
		dominionIconAnimTex.MoveTo((targetIconBtn.GetRect().nX - 2), (targetIconBtn.GetRect().nY - 2));
		dominionIconAnimTex.ShowWindow();
	}
	currentTooltipTeleportID = TeleportID;
	mapTooltip.ShowWindow();
	return;
}

function HideMapIconTooltip()
{
	currentTooltipTeleportID = -1;
	dominionIconAnimTex.HideWindow();
	mapTooltip.HideWindow();
	return;
}

function UpdateTownZoneIcons(bool isRecommentTypw)
{
	local array<TeleportWnd.TeleportTownInfo> townInfoList;
	local TeleportWnd.TeleportInfo tempTeleportInfo;
	local int i;
	local Vector iconLoc;
	local ButtonHandle townIconBtn;

	if((isRecommentTypw == false))
	{
		townInfoList = Class'InterfaceClassic.TeleportWnd'.static.Inst().GetTeleportTownList();
	}
	i = 0;
	while((i < townMapIcons.Length))
	{
		townIconBtn = townMapIcons[i];
		if((i < townInfoList.Length))
		{
			tempTeleportInfo = townInfoList[i].townInfo;
			iconLoc = GetMinimapPosFromWorldLoc(townIconBtn, setVector(tempTeleportInfo.locX, tempTeleportInfo.locY, 0));
			townIconBtn.MoveC(int(iconLoc.X), int(iconLoc.Y));
			townIconBtn.SetButtonValue(tempTeleportInfo.Id);
			townIconBtn.ShowWindow();
			i++;
			continue;
		}
		townIconBtn.SetButtonValue(-1);
		townIconBtn.HideWindow();
		i++;
	}
	return;
}

function UpdateDominionZoneIcons()
{
	local TeleportWnd.TeleportTownInfo townInfo;
	local TeleportWnd.TeleportInfo tempTeleportInfo;
	local int i, selectedTownId, selectedRcZoneId, selectedDominionTeleportId;
	local Vector iconLoc;
	local ButtonHandle dominionIconBtn;

	selectedTownId = Class'InterfaceClassic.TeleportWnd'.static.Inst().GetSelectedTownID();
	selectedRcZoneId = Class'InterfaceClassic.TeleportWnd'.static.Inst().GetSelectedRcZoneID();
	selectedDominionTeleportId = Class'InterfaceClassic.TeleportWnd'.static.Inst().GetSelectedDominionTeleportID();
	if((selectedRcZoneId > 0))
	{
		townInfo = Class'InterfaceClassic.TeleportWnd'.static.Inst().GetRcTownInfo(selectedRcZoneId);
		townAreaAnimTex.HideWindow();
		townIconAnimTex.HideWindow();
	}
	else if((selectedTownId > 0))
	{
		townInfo = Class'InterfaceClassic.TeleportWnd'.static.Inst().GetTownInfo(selectedTownId);
		iconLoc = GetMinimapPosFromWorldLoc(townAreaAnimTex, setVector(townInfo.townInfo.locX, townInfo.townInfo.locY, 0));
		townAreaAnimTex.MoveC(int(iconLoc.X), int(iconLoc.Y));
		iconLoc = GetMinimapPosFromWorldLoc(townIconAnimTex, setVector(townInfo.townInfo.locX, townInfo.townInfo.locY, 0));
		townIconAnimTex.MoveC(int(iconLoc.X), int(iconLoc.Y));
		townAreaAnimTex.ShowWindow();
		townIconAnimTex.ShowWindow();
	}
	else
	{
		townAreaAnimTex.HideWindow();
		townIconAnimTex.HideWindow();
	}
	dominionAreaAnimTex.HideWindow();
	i = 0;
	while((i < dominionMapIcons.Length))
	{
		dominionIconBtn = dominionMapIcons[i];
		if(((selectedTownId >= 0) && (i < townInfo.dominions.Length)))
		{
			tempTeleportInfo = townInfo.dominions[i];
			iconLoc = GetMinimapPosFromWorldLoc(dominionIconBtn, setVector(tempTeleportInfo.locX, tempTeleportInfo.locY, 0));
			dominionIconBtn.MoveC(int(iconLoc.X), int(iconLoc.Y));
			dominionIconBtn.SetButtonValue(tempTeleportInfo.Id);
			dominionIconBtn.ShowWindow();
			if(((selectedDominionTeleportId >= 0) && (tempTeleportInfo.Id == selectedDominionTeleportId)))
			{
				iconLoc = GetMinimapPosFromWorldLoc(dominionAreaAnimTex, setVector(tempTeleportInfo.locX, tempTeleportInfo.locY, 0));
				dominionAreaAnimTex.MoveC(int(iconLoc.X), int(iconLoc.Y));
				dominionAreaAnimTex.ShowWindow();
			}
			i++;
			continue;
		}
		dominionIconBtn.SetButtonValue(-1);
		dominionIconBtn.HideWindow();
		i++;
	}
	return;
}

function UpdateCurrentZoneInfo()
{
	local string zoneName;
	local int zoneID;
	local UserInfo UserInfo;
	local Vector playerMapLoc, validPlayerMapLoc;
	local int locX, locY, locZ;

	zoneName = GetCurrentZoneName();
	zoneID = GetCurrentZoneID();
	GetPlayerInfo(UserInfo);
	locX = int(UserInfo.Loc.X);
	locY = int(UserInfo.Loc.Y);
	locZ = int(UserInfo.Loc.Z);
	validPlayerMapLoc = Class'NWindow.TeleportListAPI'.static.ModifyExceptionLocation(locX, locY, locZ);
	playerMapLoc = GetMinimapPosFromWorldLoc(playerPosAnimTex, setVector(int(validPlayerMapLoc.X), int(validPlayerMapLoc.Y), 0));
	playerPosAnimTex.MoveC(int(playerMapLoc.X), int(playerMapLoc.Y));
	currentZoneTextBox.SetText(zoneName);
	return;
}

function Vector GetMinimapPosFromWorldLoc(WindowHandle targetWnd, Vector worldLoc)
{
	local Vector taregetPosition;

	if((worldLoc.X > adenBoundryLeftLocX))
	{
		taregetPosition.X = (((((worldLoc.X - adenBoundryLeftLocX) * worldMapScale) * 0.1660000) - 8.0000000) + 12.0000000);
		taregetPosition.Y = (((((worldLoc.Y - adenBoundryTopLocY) * worldMapScale) * 0.1660000) - 8.0000000) + 23.0000000);
	}
	else
	{
		taregetPosition.X = ((((worldLoc.X - graciaBoundryLeftLocX) * worldMapScale) * 0.1660000) + 12.0000000);
		taregetPosition.Y = ((((worldLoc.Y - graciaBoundryTopLocY) * worldMapScale) * 0.1660000) + 23.0000000);
	}
	(taregetPosition.X -= (float(targetWnd.GetRect().nWidth) * 0.5000000));
	(taregetPosition.Y -= (float(targetWnd.GetRect().nHeight) * 0.5000000));
	return taregetPosition;
}

function string GetTagTextureName(TeleportWnd.ETeleportListTagType Type)
{
	if((int(Type) == 1))
	{
		return "L2UI_NewTex.TeleportWnd.MapTag_New";
	}
	else if((int(Type) == 2))
	{
		return "L2UI_NewTex.TeleportWnd.MapTag_Event";
	}
	return "";
}

function PlayMapIconAnimation()
{
	playerPosAnimTex.SetLoopCount(999999);
	townIconAnimTex.SetLoopCount(999999);
	townAreaAnimTex.SetLoopCount(999999);
	dominionIconAnimTex.SetLoopCount(999999);
	dominionAreaAnimTex.SetLoopCount(999999);
	playerPosAnimTex.Play();
	townIconAnimTex.Play();
	townAreaAnimTex.Play();
	dominionIconAnimTex.Play();
	dominionAreaAnimTex.Play();
	return;
}

function StopMapIconAnimation()
{
	playerPosAnimTex.Stop();
	townIconAnimTex.Stop();
	townAreaAnimTex.Stop();
	dominionIconAnimTex.Stop();
	dominionAreaAnimTex.Stop();
	return;
}

function StartPlayerPositionTimer()
{
	KillPlayerPositionTimer();
	Me.SetTimer(1, 1000);
	return;
}

function KillPlayerPositionTimer()
{
	Me.KillTimer(1);
	return;
}

event OnLoad()
{
	Initialize();
	return;
}

event OnShow()
{
	HideMapIconTooltip();
	UpdateCurrentZoneInfo();
	return;
}

event OnTimer(int TimerID)
{
	if((TimerID == 1))
	{
		UpdateCurrentZoneInfo();
		if(Class'InterfaceClassic.TeleportWnd'.static.Inst().Me.IsShowWindow())
		{
			StartPlayerPositionTimer();
		}
	}
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "MyLocation_Btn":
			Class'InterfaceClassic.TeleportWnd'.static.Inst().SetCurrentZoneListSelected(true);
			break;
		default:
			break;
	}
	return;
}

event OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	local int buttonValue;

	buttonValue = a_ButtonHandle.GetButtonValue();
	if((buttonValue > 0))
	{
		Class'InterfaceClassic.TeleportWnd'.static.Inst().ShowTeleportDialog(INT64(buttonValue));
	}
	return;
}

event OnMouseOver(WindowHandle WindowHandle)
{
	local int buttonValue;

	if((ButtonHandle(WindowHandle).m_pTargetWnd == none))
	{
		return;
	}
	buttonValue = ButtonHandle(WindowHandle).GetButtonValue();
	if((buttonValue > 0))
	{
		ShowMapIconTooltip(buttonValue);
	}
	return;
}

event OnMouseOut(WindowHandle WindowHandle)
{
	HideMapIconTooltip();
	return;
}
