class PositionManagerKillLogCenter extends PositionManagerWndBase;

function Init()
{
	isGfx = true;
	return;
}

function ResetPosition()
{
	L2UIGFxScript(GetScript(_targetWndname)).SetAnchor("", ANCHORPOINT_TopRight, ANCHORPOINT_TopRight, -60, 261);
	return;
}

defaultproperties
{
	OffsetX=6
	OffsetY=52
	targetW=365
	targetH=196
}
