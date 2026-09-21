class RankingHistoryWnd extends L2UIGFxScript;

function OnRegisterEvent()
{
	RegisterGFxEvent(11261);
	return;
}

function OnLoad()
{
	AddState("GAMINGSTATE");
	SetContainerWindow("SkinnedWindow", 3598);
	return;
}
