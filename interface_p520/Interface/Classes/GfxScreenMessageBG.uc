class GfxScreenMessageBG extends L2UIGFxScript;

function OnRegisterEvent()
{
	RegisterGFxEvent(542);
	RegisterGFxEvent(8700);
	RegisterGFxEvent(8701);
	return;
}

function OnLoad()
{
	RegisterState(getCurrentWindowName(string(self)), "ARENAPICKSTATE");
	RegisterState(getCurrentWindowName(string(self)), "ARENAGAMINGSTATE");
	RegisterState(getCurrentWindowName(string(self)), "ARENABATTLESTATE");
	SetDefaultShow(true);
	SetAlwaysFullAlpha(true);
	SetAlwaysOnTop(true);
	SetHUD();
	return;
}

function OnFlashLoaded()
{
	SetAnchor("", ANCHORPOINT_BottomRight, ANCHORPOINT_TopLeft, 0, 0);
	return;
}

function OnEvent(int Id, string param)
{
	local string Label, labelIndex, motionType, useSystemMessage, Delay, locY;

	switch(Id)
	{
		case 12:
			ParseString(param, "label", Label);
			ParseString(param, "labelIndex", labelIndex);
			ParseString(param, "motionType", motionType);
			ParseString(param, "delay", Delay);
			ParseString(param, "locY", locY);
			ParseString(param, "useSystemMessage", useSystemMessage);
			if((useSystemMessage == "1"))
			{
				AddSystemMessage(int(labelIndex));
			}
			else
			{
				showTestGfxScreenMessage(Label, labelIndex, motionType, Delay, locY);
			}
			break;
		default:
			break;
	}
	return;
}

function showTestGfxScreenMessage(string Label, optional string labelIndex, optional string motionType, optional string Delay, optional string locY)
{
	local string strParam;

	strParam = "";
	ParamAdd(strParam, "Msg", "1");
	ParamAdd(strParam, "type", string(3));
	ParamAdd(strParam, "label", Label);
	ParamAdd(strParam, "labelIndex", labelIndex);
	ParamAdd(strParam, "motionType", motionType);
	ParamAdd(strParam, "delay", Delay);
	ParamAdd(strParam, "locY", locY);
	CallGFxFunction("GfxScreenMessageBG", "showMessage", strParam);
	return;
}
