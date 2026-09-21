class ArenaCharacterInfoWnd extends L2UIGFxScriptNoneContainer;

function OnRegisterEvent()
{
	RegisterEvent(3410);
	RegisterGFxEvent(8340);
	RegisterGFxEvent(8350);
	RegisterGFxEvent(8360);
	RegisterGFxEvent(8370);
	return;
}

function OnLoad()
{
	AddState("ARENAGAMINGSTATE");
	AddState("ARENABATTLESTATE");
	SetClosingOnESC();
	return;
}

function OnEvent(int Event_ID, string param)
{
	return;
}

function OnFlashLoaded()
{
	RegisterDelegateHandler(EDHandler_Arena);
	return;
}
