class ArmyTrainingCenterBottomWnd extends GFxUIScript;

const DIALOG_ASK_TRAINING_OUT = 66666;

function OnRegisterEvent()
{
	RegisterEvent(1710);
	RegisterEvent(1720);
	RegisterEvent(3410);
	return;
}

function OnLoad()
{
	RegisterState("ArmyTrainingCenterBottomWnd", "TRAININGROOMSTATE");
	SetContainer("ContainerWindow");
	SetDefaultShow(true);
	SetAnchor("", ANCHORPOINT_BottomRight, ANCHORPOINT_TopLeft, 0, 0);
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 1710))
	{
		HandleDialogOK();
	}
	else if((Event_ID == 1720))
	{
	}
	else if((Event_ID == 3410))
	{
		if((param == "TRAININGROOMSTATE"))
		{
			ShowWindow();
		}
		else
		{
			HideWindow();
		}
	}
	return;
}

function HandleDialogOK()
{
	local int Id;
	local DialogBox Script;
	local ArmyTrainingCenterWnd armyScript;

	Script = DialogBox(GetScript("DialogBox"));
	armyScript = ArmyTrainingCenterWnd(GetScript("ArmyTrainingCenterWnd"));
	Id = Script.GetID();
	if(Class'Interface.UICommonAPI'.static.DialogIsMineWithTarget("ArmyTrainingCenterWnd"))
	{
		if((Id == 66666))
		{
			CallGFxFunction("ArmyTrainingCenterBottomWnd", "TrainingRoomOut", "");
			armyScript.ClearTimer(10012);
			armyScript.ClearTimer(10013);
		}
	}
	return;
}

function OnCallUCFunction(string functionName, string param)
{
	local DialogBox Script;

	Script = DialogBox(GetScript("DialogBox"));
	switch(functionName)
	{
		case "ShowDialogTrainingOut":
			Script.setId(66666);
			Script._DialogShowWithTarget(DialogModalType_Modal, DialogType_OKCancel, GetSystemString(5155), "ArmyTrainingCenterBottomWnd");
			break;
		case "GameQuit":
			ExecuteEvent(3340);
			break;
		case "GameRestart":
			ExecuteEvent(3350);
			break;
		default:
			break;
	}
	return;
}
