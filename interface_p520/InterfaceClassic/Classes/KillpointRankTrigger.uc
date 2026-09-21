class KillpointRankTrigger extends UIScript;

var WindowHandle Me;
var WindowHandle KillPointRankWnd;

function OnRegisterEvent()
{
	return;
}

function OnLoad()
{
	if((1 == 0))
	{
		Me = GetHandle("KillPointRankTrigger");
		KillPointRankWnd = GetHandle("KillPointRankWnd");
	}
	else
	{
		Me = GetWindowHandle("KillPointRankTrigger");
		KillPointRankWnd = GetWindowHandle("KillPointRankWnd");
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	local int statusInt;

	switch(Event_ID)
	{
		case 3500:
			Me.ShowWindow();
			break;
		case 3470:
			ParseInt(param, "Status", statusInt);
			switch(statusInt)
			{
				case 0:
					Me.ShowWindow();
					break;
				case 2:
					Me.HideWindow();
					break;
				default:
					break;
			}
			break;
		case 3501:
			Me.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string Name)
{
	if((Name == "KillPointRankTrigger"))
	{
		KillPointRankWnd.ShowWindow();
		RequestStartShowCrataeCubeRank();
	}
	return;
}
