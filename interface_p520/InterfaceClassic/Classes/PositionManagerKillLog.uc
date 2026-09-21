class PositionManagerKillLog extends PositionManagerWndBase;

function Init()
{
	DelegateOnSave = OnSave;
	return;
}

function OnSave()
{
	KillLog(GetScript("KillLog"))._SendToGfxScreenMessageKillLogCenterFadeOut();
	return;
}

function ResetPosition()
{
	KillLog(GetScript("KillLog"))._SendToGfxScreenMessageKillLogCenterFadeIn();
	GetWindowHandle(_targetWndname).SetAnchor("", "TopCenter", "TopCenter", 20, 120);
	return;
}

function TestFunc()
{
	getInstanceL2Util().showGfxScreenMessage("메시지 페이드 인~~");  // EN?: Message Fade In ~ ~
	ExecuteEvent(16, "");
	return;
}

defaultproperties
{
	OffsetX=-172
	OffsetY=-1
}
