class AlchemyMixCubeWnd extends L2UIGFxScript;

const DIALOG_ALCHEMYMIXCUBEWND = 10000;

var string m_Windowname;

function OnRegisterEvent()
{
	RegisterGFxEvent(9870);
	RegisterGFxEvent(9875);
	RegisterGFxEvent(9910);
	RegisterGFxEvent(9920);
	RegisterGFxEvent(9880);
	RegisterEvent(1710);
	RegisterEvent(1720);
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 1710:
			HandleDialogOK();
			break;
		case 1720:
			HandleDialogCancel();
			break;
		default:
			break;
	}
	return;
}

function OnCallUCFunction(string functionName, string param)
{
	local DialogBox dScript;

	switch(functionName)
	{
		case "openDialogNumpad":
			openDialogNumpad(INT64(param));
			break;
		case "cloasDialogNumPad":
			dScript = DialogBox(GetScript("DialogBox"));
			if(DialogIsMineWithTarget(m_Windowname))
			{
				dScript.HideDialog();
			}
			break;
		default:
			break;
	}
	return;
}

function openDialogNumpad(INT64 Adena)
{
	Class'Interface.UICommonAPI'.static.DialogSetID(10000);
	Class'Interface.UICommonAPI'.static.DialogSetEditType("number");
	Class'Interface.UICommonAPI'.static.DialogSetParamInt64(Adena);
	Class'Interface.UICommonAPI'.static.DialogSetDefaultOK();
	Class'Interface.UICommonAPI'.static.DialogShowWithTarget(DialogModalType_Modalless, DialogType_NumberPad, GetSystemMessage(4262), m_Windowname);
	return;
}

function HandleDialogCancel()
{
	return;
}

function HandleDialogOK()
{
	local INT64 inputNum;
	local int Id;

	if(!DialogIsMineWithTarget(m_Windowname))
	{
		return;
	}
	Id = Class'Interface.UICommonAPI'.static.DialogGetID();
	if((Id == 10000))
	{
		inputNum = INT64(Class'Interface.UICommonAPI'.static.DialogGetString());
		CallGFxFunction(m_Windowname, "HandleDialogOK", string(inputNum));
	}
	return;
}

function OnLoad()
{
	m_Windowname = getCurrentWindowName(string(self));
	RegisterState(m_Windowname, "GamingState");
	SetContainerWindow("SkinnedWindow", 3302);
	AddState("GAMINGSTATE");
	return;
}

function OnShow()
{
	local L2Util util;

	util = L2Util(GetScript("L2Util"));
	util.ItemRelationWindowHide(m_Windowname, "InventoryWnd");
	return;
}
