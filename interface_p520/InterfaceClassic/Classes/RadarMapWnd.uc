class RadarMapWnd extends L2UIGFxScript;

function OnRegisterEvent()
{
	RegisterGFxEvent(40);
	RegisterGFxEvent(110);
	RegisterGFxEvent(2420);
	RegisterEvent(2420);
	RegisterGFxEvent(1780);
	RegisterGFxEvent(150);
	RegisterGFxEvent(160);
	RegisterGFxEvent(6130);
	RegisterGFxEvent(990);
	RegisterGFxEvent(1140);
	RegisterGFxEvent(1160);
	RegisterGFxEvent(1170);
	RegisterGFxEvent(1170);
	RegisterGFxEvent(1150);
	RegisterGFxEvent(6120);
	RegisterGFxEvent(1840);
	RegisterGFxEvent(40);
	RegisterGFxEvent(8600);
	RegisterGFxEvent(8610);
	RegisterGFxEvent(1890);
	return;
}

event OnLoad()
{
	SetSaveWnd(true, true);
	SetContainerHUD("none", 0);
	AddState("GAMINGSTATE");
	SetDefaultShow(true);
	return;
}

event OnCallUCFunction(string functionName, string param)
{
	switch(functionName)
	{
		case "TeleportBookmarkBtn":
			if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("TeleportBookMarkWnd"))
			{
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow("TeleportBookMarkWnd");
			}
			else
			{
				DoAction(Class'InterfaceClassic.UICommonAPI'.static.GetItemID(64));
			}
			break;
		case "onClickArrowIcon":
			onClickArrowIcon();
			break;
		default:
			break;
	}
	return;
}

event OnEvent(int eID, string param)
{
	switch(eID)
	{
		case 2420:
			HandleEV_BeginShowZoneTitleWnd();
			break;
		default:
			break;
	}
	return;
}

function HandleEV_BeginShowZoneTitleWnd()
{
	Class'InterfaceClassic.MinimizeManager'.static.Inst()._SetToolTIp("RadarMapWnd", API_GetCurrentZoneName());
	return;
}

function onClickArrowIcon()
{
	local Vector QuestLocation;

	if(GetQuestLocation(QuestLocation))
	{
		ChaseMiniPosition(QuestLocation);
		if(!Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("MiniMapGfxWnd"))
		{
			Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("MiniMapGfxWnd");
		}
	}
	return;
}

function ChaseMiniPosition(Vector Loc, optional MinimapRegionIconData IconData)
{
	local int OffsetX, OffsetY;

	OffsetX = ((IconData.nWidth / 2) + IconData.nIconOffsetX);
	OffsetY = ((IconData.nHeight / 2) + IconData.nIconOffsetY);
	getInstanceL2Util().ShowHighLightMapIcon(Loc, OffsetX, OffsetY);
	return;
}

function string API_GetCurrentZoneName()
{
	return GetCurrentZoneName();
}
