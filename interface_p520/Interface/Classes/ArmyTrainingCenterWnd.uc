class ArmyTrainingCenterWnd extends GFxUIScript;

const TIMER_ID_Sec = 10012;
const TIMER_ID_Min = 10013;
const TIMER_DELAY = 60000;

var int nRemainSecondTime;

function OnRegisterEvent()
{
	RegisterEvent(3410);
	RegisterEvent(10034);
	RegisterGFxEvent(10031);
	RegisterGFxEvent(180);
	return;
}

function OnLoad()
{
	RegisterState("ArmyTrainingCenterWnd", "TRAININGROOMSTATE");
	SetContainer("ContainerWindow");
	SetAnchor("", ANCHORPOINT_CenterCenter, ANCHORPOINT_CenterCenter, 0, 0);
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 3410))
	{
		if((param != "TRAININGROOMSTATE"))
		{
			CallGFxFunction("ArmyTrainingCenterWnd", "StateOut", "");
			HideWindow();
			KillTimer(10012);
			KillTimer(10013);
		}
		else
		{
			CallGFxFunction("ArmyTrainingCenterWnd", "StateIn", "");
		}
	}
	if((Event_ID == 10034))
	{
		ParseInt(param, "MaxTime", nRemainSecondTime);
		if((nRemainSecondTime > 0))
		{
			nRemainSecondTime = int((float(nRemainSecondTime) % 60.0000000));
			if((nRemainSecondTime > 0))
			{
				SetTimer(10012, (nRemainSecondTime * 1000));
			}
			else
			{
				SetTimer(10013, 60000);
			}
		}
	}
	return;
}

function OnTimer(int TimerID)
{
	if(((TimerID == 10012) || (TimerID == 10013)))
	{
		CallGFxFunction("ArmyTrainingCenterWnd", "TimerUpdate", "");
		if((TimerID == 10012))
		{
			KillTimer(10012);
			SetTimer(10013, 60000);
		}
	}
	return;
}

function ClearTimer(int TimerID)
{
	if((TimerID == 10012))
	{
		KillTimer(10012);
	}
	else if((TimerID == 10013))
	{
		KillTimer(10013);
	}
	return;
}

function OnCallUCFunction(string functionName, string param)
{
	switch(functionName)
	{
		case "":
			break;
		default:
			break;
	}
	return;
}
