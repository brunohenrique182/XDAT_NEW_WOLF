class AdenaDistributionWnd extends L2UIGFxScript;

const DIALOG_ADENADISTRIBUTTE = 200001;

var ItemWindowHandle InventoryItem;
var string m_Windowname;

function OnRegisterEvent()
{
	RegisterGFxEvent(180);
	RegisterGFxEvent(40);
	RegisterGFxEvent(9570);
	RegisterGFxEvent(9690);
	RegisterGFxEvent(9700);
	RegisterGFxEvent(9710);
	RegisterGFxEvent(4918);
	RegisterGFxEvent(1380);
	RegisterGFxEvent(4915);
	RegisterGFxEvent(4919);
	RegisterGFxEvent(1170);
	RegisterGFxEvent(1140);
	RegisterGFxEvent(1160);
	RegisterGFxEvent(1370);
	RegisterGFxEvent(1360);
	RegisterEvent(1710);
	RegisterEvent(1720);
	return;
}

function OnLoad()
{
	m_Windowname = getCurrentWindowName(string(self));
	RegisterState(m_Windowname, "GamingState");
	SetContainerWindow("SkinnedWindow", 0);
	InventoryItem = GetItemWindowHandle("InventoryWnd.InventoryItem");
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
			HandleDialogCancel();
			break;
		default:
			break;
	}
	return;
}

function OnCallUCFunction(string functionName, string param)
{
	local int Index;
	local ItemInfo Info;

	switch(functionName)
	{
		case "openDialogNumpad":
			openDialogNumpad(INT64(param));
			break;
		case "getAdenaServerID":
			Info.Id.ClassID = 57;
			Index = InventoryItem.FindItem(Info.Id);
			if(InventoryItem.GetItem(Index, Info))
			{
				CallGFxFunction(m_Windowname, "AdenaServerID", string(Info.Id.ServerID));
			}
			break;
		case "RequestCommandChannelInfo":
			Class'NWindow.CommandChannelAPI'.static.RequestCommandChannelInfo();
			break;
		default:
			break;
	}
	return;
}

function openDialogNumpad(INT64 Adena)
{
	Class'InterfaceClassic.UICommonAPI'.static.DialogSetID(200001);
	Class'InterfaceClassic.UICommonAPI'.static.DialogSetEditType("number");
	Class'InterfaceClassic.UICommonAPI'.static.DialogSetParamInt64(Adena);
	Class'InterfaceClassic.UICommonAPI'.static.DialogSetDefaultOK();
	Class'InterfaceClassic.UICommonAPI'.static.DialogShowWithTarget(DialogModalType_Modalless, DialogType_NumberPad, GetSystemString(3138), m_Windowname);
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
	Id = Class'InterfaceClassic.UICommonAPI'.static.DialogGetID();
	if((Id == 200001))
	{
		inputNum = INT64(Class'InterfaceClassic.UICommonAPI'.static.DialogGetString());
		CallGFxFunction(m_Windowname, "HandleDialogOK", string(inputNum));
	}
	return;
}
