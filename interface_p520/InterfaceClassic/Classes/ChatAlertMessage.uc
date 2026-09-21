class ChatAlertMessage extends GFxUIScript;

const FLASH_XPOS = 0;
const FLASH_YPOS = -137;

function OnRegisterEvent()
{
	RegisterGFxEvent(540);
	return;
}

function OnLoad()
{
	RegisterState("ChatAlertMessage", "GamingState");
	SetAnchor("", ANCHORPOINT_BottomRight, ANCHORPOINT_BottomRight, 0, -137);
	SetAlwaysFullAlpha(true);
	SetHavingFocus(false);
	SetMsgPassThrough(true);
	return;
}
