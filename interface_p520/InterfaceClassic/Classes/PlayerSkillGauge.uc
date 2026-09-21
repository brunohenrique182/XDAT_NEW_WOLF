class PlayerSkillGauge extends L2UIGFxScript;

const FLASH_XPOS = 0;
const FLASH_YPOS = -250;

function OnRegisterEvent()
{
	RegisterGFxEvent(5330);
	RegisterGFxEvent(5340);
	RegisterGFxEvent(3410);
	return;
}

function OnLoad()
{
	local int addShortcutExpandLocY;

	SetContainerHUD("none", 0);
	AddState("GAMINGSTATE");
	AddState("ARENAPICKSTATE");
	AddState("ARENAGAMINGSTATE");
	AddState("ARENABATTLESTATE");
	addShortcutExpandLocY = -60;
	SetAnchor("", ANCHORPOINT_BottomCenter, ANCHORPOINT_BottomCenter, 0, (-250 + addShortcutExpandLocY));
	SetDefaultShow(true);
	SetHavingFocus(false);
	return;
}
