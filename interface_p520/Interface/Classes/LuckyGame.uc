class LuckyGame extends GFxUIScript;

const DIALOG_LUCKYGAME = 200001;
const DIALOG_RESULTFAIL = 200002;

var string m_Windowname;

function OnRegisterEvent()
{
	RegisterGFxEvent(10022);
	RegisterGFxEvent(10023);
	RegisterEvent(1710);
	RegisterEvent(1720);
	RegisterGFxEvent(20143);
	RegisterGFxEvent(20144);
	RegisterGFxEvent(20145);
	RegisterGFxEvent(9050);
	return;
}

function OnLoad()
{
	m_Windowname = "LuckyGame";
	RegisterState(m_Windowname, "GamingState");
	SetContainer("ContainerWindow");
	SetAnchor("", ANCHORPOINT_CenterCenter, ANCHORPOINT_CenterCenter, 0, 0);
	SetHavingFocus(false);
	return;
}

function OnFlashLoaded()
{
	return;
}

function OnShow()
{
	local L2Util util;

	util = L2Util(GetScript("L2Util"));
	util.ItemRelationWindowHide(m_Windowname);
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
			break;
		default:
			break;
	}
	return;
}

function closeDialogNumpad()
{
	local DialogBox dScript;

	dScript = DialogBox(GetScript("DialogBox"));
	if(Class'Interface.UICommonAPI'.static.DialogIsMineWithTarget(m_Windowname))
	{
		dScript.HideDialog();
	}
	return;
}

function OnCallUCFunction(string functionName, string param)
{
	switch(functionName)
	{
		case "closeDialogNumpad":
			closeDialogNumpad();
			break;
		case "openDialogNumpad":
			openDialogNumpad(INT64(param));
			break;
		case "showDialogMessage":
			Class'Interface.UICommonAPI'.static.DialogSetID(200002);
			Class'Interface.UICommonAPI'.static.DialogShowWithTarget(DialogModalType_Modalless, DialogType_OK, param, m_Windowname);
			break;
		default:
			break;
	}
	return;
}

function openDialogNumpad(INT64 Adena)
{
	Class'Interface.UICommonAPI'.static.DialogSetID(200001);
	Class'Interface.UICommonAPI'.static.DialogSetEditType("number");
	Class'Interface.UICommonAPI'.static.DialogSetParamInt64(Adena);
	Class'Interface.UICommonAPI'.static.DialogSetDefaultOK();
	Class'Interface.UICommonAPI'.static.DialogShowWithTarget(DialogModalType_Modalless, DialogType_NumberPad, GetSystemString(5174), m_Windowname);
	return;
}

function HandleDialogOK()
{
	local INT64 inputNum;
	local int Id;
	local string strParam;

	if(!Class'Interface.UICommonAPI'.static.DialogIsMineWithTarget(m_Windowname))
	{
		return;
	}
	Id = Class'Interface.UICommonAPI'.static.DialogGetID();
	switch(Id)
	{
		case 200001:
			inputNum = INT64(Class'Interface.UICommonAPI'.static.DialogGetString());
			ParamAdd(strParam, "Type", "DIALOG_LUCKYGAME");
			ParamAdd(strParam, "inputNum", string(inputNum));
			CallGFxFunction(m_Windowname, "HandleDialogOK", strParam);
			break;
		case 200002:
			ParamAdd(strParam, "Type", "DIALOG_RESULTFAIL");
			CallGFxFunction(m_Windowname, "HandleDialogOK", strParam);
			break;
		default:
			break;
	}
	return;
}
