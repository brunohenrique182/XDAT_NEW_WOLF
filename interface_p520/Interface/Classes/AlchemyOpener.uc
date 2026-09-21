class AlchemyOpener extends L2UIGFxScript;

function OnLoad()
{
	RegisterState("AlchemyOpener", "GamingState");
	SetContainerWindow("SkinnedWindow", 3257);
	AddState("GAMINGSTATE");
	SetAnchor("", ANCHORPOINT_CenterCenter, ANCHORPOINT_CenterCenter, 0, 0);
	return;
}
