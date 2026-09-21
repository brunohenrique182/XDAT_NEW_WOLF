class DepthOfField extends UICommonAPI;

function OnRegisterEvent()
{
	RegisterEvent(3410);
	RegisterEvent(50000);
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

function HandleStateChanged(string a_NewState)
{
	switch(a_NewState)
	{
		case "LOGINSTATE":
		case "LOGINWAITSTATE":
		case "EULAMSGSTATE":
		case "CHINAWARNMSGSTATE":
		case "SERVERLISTSTATE":
		case "REPLAYSELECTSTATE":
		case "CARDKEYLOGINSTATE":
			Class'NWindow.GraphicAPI'.static.DoFResume();
			Class'NWindow.GraphicAPI'.static.DoFSetFocusDistance(300.0000000);
			Class'NWindow.GraphicAPI'.static.DoFSetStartDistance(300.0000000);
			Class'NWindow.GraphicAPI'.static.DoFSetEndDistance(9000.0000000);
			break;
		case "CHARACTERSELECTSTATE":
			Class'NWindow.GraphicAPI'.static.DoFResume();
			Class'NWindow.GraphicAPI'.static.DoFSetFocusDistance(300.0000000);
			Class'NWindow.GraphicAPI'.static.DoFSetStartDistance(300.0000000);
			Class'NWindow.GraphicAPI'.static.DoFSetEndDistance(5000.0000000);
			break;
		case "LOADINGSTATE":
			Class'NWindow.GraphicAPI'.static.DoFPause();
			break;
		case "GAMINGSTATE":
			Class'NWindow.GraphicAPI'.static.DoFResume();
			Class'NWindow.GraphicAPI'.static.DoFSetFocusPlayer();
			Class'NWindow.GraphicAPI'.static.DoFSetStartDistance(300.0000000);
			Class'NWindow.GraphicAPI'.static.DoFSetEndDistance(9000.0000000);
			break;
		default:
			Class'NWindow.GraphicAPI'.static.DoFResume();
			Class'NWindow.GraphicAPI'.static.DoFSetFocusDistance(300.0000000);
			Class'NWindow.GraphicAPI'.static.DoFSetStartDistance(300.0000000);
			Class'NWindow.GraphicAPI'.static.DoFSetEndDistance(2000.0000000);
	}
	return;
}

function HandleCharacterSelectionChanged(string a_Param)
{
	local int charIndex;

	if(ParseInt(a_Param, "CharIndex", charIndex))
	{
		if((GetUIState() == "CHARACTERCREATESTATE"))
		{
			Class'NWindow.GraphicAPI'.static.DoFResume();
			Class'NWindow.GraphicAPI'.static.DoFSetFocusActor(GetCharacterSelectionActor(charIndex));
			Class'NWindow.GraphicAPI'.static.DoFSetStartDistance(300.0000000);
			Class'NWindow.GraphicAPI'.static.DoFSetEndDistance(3000.0000000);
		}
	}
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 3410:
			HandleStateChanged(a_Param);
			break;
		case 50000:
			HandleCharacterSelectionChanged(a_Param);
			break;
		default:
			break;
	}
	return;
}
