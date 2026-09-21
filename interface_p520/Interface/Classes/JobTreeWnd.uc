class JobTreeWnd extends L2UIGFxScript;

var int targetCurrentSubjobClassID;
var bool isTargetNpc;

event OnRegisterEvent()
{
	RegisterEvent(980);
	return;
}

event OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 980:
			OnTargetUpdate();
			break;
		default:
			break;
	}
	return;
}

event OnLoad()
{
	AddState("GAMINGSTATE");
	SetContainerWindow("SkinnedWindow", 2704);
	return;
}

event OnCallUCFunction(string funcName, string param)
{
	switch(funcName)
	{
		case "ucExecuteCommand":
			ucExecuteCommand(param);
			break;
		default:
			break;
	}
	return;
}

function OnTargetUpdate()
{
	if(!IsShowWindow("JobTreeWnd"))
	{
		return;
	}
	SetTargetCurrentSubjobClassID();
	CallGFxFunction("JobTreeWnd", "changeTargetClassID", "");
	return;
}

function SetTargetCurrentSubjobClassID()
{
	local UserInfo Info;

	if(!GetTargetInfo(Info))
	{
		return;
	}
	isTargetNpc = Info.bNpc;
	if(isTargetNpc)
	{
		targetCurrentSubjobClassID = Info.nClassID;
	}
	else
	{
		targetCurrentSubjobClassID = Info.nSubClass;
	}
	return;
}

function ucExecuteCommand(string param)
{
	if((param == ""))
	{
		return;
	}
	ExecuteCommand(param);
	return;
}
