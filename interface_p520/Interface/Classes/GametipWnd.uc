class GametipWnd extends UIScript;

var array<GameTipData> TipData;
var int CountRecord;
var UserInfo userinfofortip;
var string CurrentTip;
var string CurrentTipImgTexture;
var int numb;

function OnRegisterEvent()
{
	RegisterEvent(8000);
	RegisterEvent(1900);
	return;
}

function OnLoad()
{
	LoadGameTipData();
	return;
}

function OnEventWithStr(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 1900:
			LoadGameTipData();
			break;
		default:
			break;
	}
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 8000:
			LoadGameTipData();
			break;
		default:
			break;
	}
	return;
}

function LoadGameTipData()
{
	local int i;
	local bool gamedataloaded;
	local GameTipData TipData1;

	CountRecord = Class'NWindow.UIDATA_GAMETIP'.static.GetDataCount();
	i = 0;
	while((i < CountRecord))
	{
		gamedataloaded = Class'NWindow.UIDATA_GAMETIP'.static.GetDataByIndex(i, TipData1);
		TipData[i] = TipData1;
		++i;
	}
	return;
}

function OnShow()
{
	local int RandomVal, PrioritySelect, UserLevelData;
	local bool userinfoloaded;
	local array<GameTipData> SelectedCondition;
	local int i, j, UserLevel, UserArrange, NumberSelect;
	local GameTipData tempTipData;
	local LoadingWnd loadingWndScript;

	j = 0;
	userinfoloaded = GetPlayerInfo(userinfofortip);
	if((userinfoloaded == false))
	{
	}
	UserLevelData = userinfofortip.nLevel;
	if(((UserLevelData >= 1) && (UserLevelData <= 20)))
	{
		UserLevel = 1;
	}
	else if(((UserLevelData >= 21) && (UserLevelData <= 40)))
	{
		UserLevel = 20;
	}
	else if(((UserLevelData >= 41) && (UserLevelData <= 60)))
	{
		UserLevel = 40;
	}
	else if(((UserLevelData >= 61) && (UserLevelData <= 74)))
	{
		UserLevel = 60;
	}
	else if(((UserLevelData >= 75) && (UserLevelData <= 84)))
	{
		UserLevel = 80;
	}
	else
	{
		UserLevel = 90;
	}
	if(((UserLevelData <= 40) && (UserLevelData > 0)))
	{
		UserArrange = 101;
	}
	else if(((UserLevelData < 85) && (UserLevelData >= 41)))
	{
		UserArrange = 102;
	}
	else
	{
		UserArrange = 103;
	}
	RandomVal = (Rand(99) + 1);
	if(((RandomVal >= 1) && (RandomVal <= 70)))
	{
		PrioritySelect = 1;
	}
	else if(((RandomVal >= 71) && (RandomVal <= 85)))
	{
		PrioritySelect = 2;
	}
	else if(((RandomVal >= 86) && (RandomVal <= 95)))
	{
		PrioritySelect = 3;
	}
	else if(((RandomVal >= 96) && (RandomVal <= 100)))
	{
		PrioritySelect = 4;
	}
	i = 0;
	while((i < TipData.Length))
	{
		if((TipData[i].TipMsg != ""))
		{
			if(((TipData[i].Priority == PrioritySelect) && (TipData[i].Validity == true)))
			{
				if((((TipData[i].TargetLevel == UserLevel) || (TipData[i].TargetLevel == 0)) || (TipData[i].TargetLevel == UserArrange)))
				{
					SelectedCondition[j] = tempTipData;
					SelectedCondition[j].TipMsg = TipData[i].TipMsg;
					SelectedCondition[j].TipImg = TipData[i].TipImg;
					++j;
				}
			}
		}
		++i;
	}
	NumberSelect = Rand(SelectedCondition.Length);
	if((SelectedCondition.Length == 0))
	{
		CurrentTip = "";
		CurrentTipImgTexture = "";
	}
	else
	{
		CurrentTip = SelectedCondition[NumberSelect].TipMsg;
		CurrentTipImgTexture = SelectedCondition[NumberSelect].TipImg;
		loadingWndScript = LoadingWnd(GetScript("LoadingWnd"));
		loadingWndScript.setBackgroundTextureStr(CurrentTipImgTexture);
	}
	if(((SelectedCondition.Length > 0) && (GetOptionBool("ScreenInfo", "ShowGameTipMsg") == true)))
	{
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("GametipWnd.GameTipText1", GetSystemString(1455));
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("GametipWnd.GameTipText", CurrentTip);
	}
	else
	{
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("GametipWnd.GameTipText1", "");
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("GametipWnd.GameTipText", "");
	}
	return;
}
