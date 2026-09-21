class EffectTester extends L2UIGFxScriptNoneContainer;

function OnRegisterEvent()
{
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	AddState("GAMINGSTATE");
	return;
}

function OnEvent(int Id, string param)
{
	ShowWindow("EffectTester");
	return;
}

function OnFlashLoaded()
{
	RegisterDelegateHandler(EDHandler_Container);
	return;
}
