class TownMapWnd extends UIScript;

function OnRegisterEvent()
{
	RegisterEvent(1770);
	return;
}

function OnLoad()
{
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 1770:
			HandleShowTownMap(a_Param);
			break;
		default:
			break;
	}
	return;
}

function HandleShowTownMap(string a_Param)
{
	local string strTownMapName;
	local int UserPosX, UserPosY;

	if(ParseString(a_Param, "TownMapName", strTownMapName))
	{
		Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("TownMapWnd.TownMapTex", strTownMapName);
		Class'NWindow.UIAPI_TEXTURECTRL'.static.SetUV("TownMapWnd.TownMapTex", 0, 0);
	}
	if((ParseInt(a_Param, "UserPosX", UserPosX) && ParseInt(a_Param, "UserPosY", UserPosY)))
	{
		Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("TownMapWnd.UserTex", "TownMapWnd.TownMapTex", "TopLeft", "TopLeft", UserPosX, UserPosY);
	}
	Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("TownMapWnd");
	return;
}
