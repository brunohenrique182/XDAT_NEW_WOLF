class AutomaticPlay extends UICommonAPI;

// Compatibility stub only.
// Auto Hunt / Auto Target UI and behavior are removed from Wolf p520.
// The class remains so any legacy indirect GetScript("AutomaticPlay") reference
// resolves safely instead of breaking InterfaceClassic.u initialization.

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
	return;
}

function requestAutoPlayForAutoPotion(int nHPPotionPercent)
{
	AutoUseItemWnd(GetScript("AutoUseItemWnd")).requestAutoPlayForAutoPotion(nHPPotionPercent);
	return;
}

function requestAutoPlayForAutoPotionPet(int nHPPetPotionPercent)
{
	AutoUseItemWnd(GetScript("AutoUseItemWnd")).requestAutoPlayForAutoPotionPet(nHPPetPotionPercent);
	return;
}

function requestAutoPlayForAutoPotionWithPet(int nHPPotionPercent, int nHPPetPotionPercent)
{
	AutoUseItemWnd(GetScript("AutoUseItemWnd")).requestAutoPlayForAutoPotionWithPet(nHPPotionPercent, nHPPetPotionPercent);
	return;
}

function showHideForYeti(bool bShow)
{
	return;
}
