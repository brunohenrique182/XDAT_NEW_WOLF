class AutomaticPlay extends UICommonAPI;

// Compatibility stub retained only so legacy p520 callers still compile.
// The Auto Hunt / Auto Target feature is intentionally removed from the client UI.

function OnRegisterEvent()
{
	return;
}

function OnLoad()
{
	m_hOwnerWnd.HideWindow();
	return;
}

function bool getActivateAll()
{
	return false;
}

function bool getUseAutoTarget()
{
	return false;
}

function requestAutoPlay(bool bUseAutoTarget, optional int nHPPotionPercent, optional int nHPPetPotionPercent)
{
	// Auto Hunt removed: never send an enable request from this legacy script.
	return;
}

function requestAutoPlayForAutoPotion(int nHPPotionPercent)
{
	// Preserve the live Auto Potion path through AutoUseItemWnd while forcing
	// automatic targeting off.
	AutoUseItemWnd(GetScript("AutoUseItemWnd")).requestAutoPlayForAutoPotion(nHPPotionPercent);
	return;
}

function requestAutoPlayForAutoPotionPet(int nHPPetPotionPercent)
{
	// Legacy pet-auto-potion path intentionally does not re-enable Auto Hunt.
	return;
}

function requestAutoPlayForAutoPotionWithPet(int nHPPotionPercent, int nHPPetPotionPercent)
{
	AutoUseItemWnd(GetScript("AutoUseItemWnd")).requestAutoPlayForAutoPotion(nHPPotionPercent);
	return;
}

function setShortcutTooltip(string tooltipStr)
{
	return;
}

function showHideForYeti(bool bShow)
{
	return;
}
