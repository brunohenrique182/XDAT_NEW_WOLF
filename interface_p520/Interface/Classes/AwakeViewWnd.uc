class AwakeViewWnd extends L2UIGFxScript;

var string m_Windowname;

function OnRegisterEvent()
{
	RegisterGFxEvent(5480);
	return;
}

function OnLoad()
{
	m_Windowname = getCurrentWindowName(string(self));
	RegisterState(m_Windowname, "GamingState");
	SetContainerWindow("SkinnedWindow", 2491);
	AddState("GAMINGSTATE");
	return;
}

function OnCallUCFunction(string funcName, string param)
{
	if((funcName == "1"))
	{
		RequestChangeToAwakenedClass(1);
	}
	else
	{
		RequestChangeToAwakenedClass(0);
	}
	return;
}
