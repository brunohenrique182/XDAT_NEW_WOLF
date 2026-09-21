class PetStatInfoWnd extends UICommonAPI;

var WindowHandle Me;
var RichListCtrlHandle combatRichList;
var RichListCtrlHandle soulShotRichList;

static function PetStatInfoWnd Inst()
{
	return PetStatInfoWnd(GetScript("PetStatInfoWnd"));
}

function Initialize()
{
	InitControls();
	return;
}

function InitControls()
{
	local string ownerFullPath;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	combatRichList = GetRichListCtrlHandle((ownerFullPath $ ".Fight_RichListCtrl"));
	soulShotRichList = GetRichListCtrlHandle((ownerFullPath $ ".SoulShotCosume_RichListCtrl"));
	combatRichList.SetSelectable(false);
	soulShotRichList.SetSelectable(false);
	combatRichList.SetUseStripeBackTexture(false);
	soulShotRichList.SetUseStripeBackTexture(false);
	Me = GetWindowHandle(ownerFullPath);
	return;
}

function UpdateUIControls()
{
	local PetInfo Info;

	if((Me.IsShowWindow() == false))
	{
		return;
	}
	if((GetPetInfo(Info) == false))
	{
		return;
	}
	combatRichList.DeleteAllItem();
	soulShotRichList.DeleteAllItem();
	AddRichListRecord(combatRichList, 94, Info.nPhysicalAttack);
	AddRichListRecord(combatRichList, 95, Info.nPhysicalDefense);
	AddRichListRecord(combatRichList, 2360, Info.nHitRate);
	AddRichListRecord(combatRichList, 2361, Info.nPhysicalAvoid);
	AddRichListRecord(combatRichList, 2362, Info.nCriticalRate);
	AddRichListRecord(combatRichList, 111, Info.nPhysicalSkillCastingSpeed);
	AddRichListRecord(combatRichList, 98, Info.nMagicalAttack);
	AddRichListRecord(combatRichList, 99, Info.nMagicDefense);
	AddRichListRecord(combatRichList, 2363, Info.nMagicalHitRate);
	AddRichListRecord(combatRichList, 2364, Info.nMagicalAvoid);
	AddRichListRecord(combatRichList, 2365, Info.nMagicalCritical);
	AddRichListRecord(combatRichList, 112, Info.nMagicCastingSpeed);
	AddRichListRecord(combatRichList, 432, Info.nMovingSpeed);
	AddRichListRecord(soulShotRichList, 14272, Info.nSoulShotCosume);
	AddRichListRecord(soulShotRichList, 14273, Info.nSpiritShotConsume);
	return;
}

function AddRichListRecord(RichListCtrlHandle RichListCtrl, int StringID, int Value)
{
	local L2Util util;
	local RichListCtrlRowData rowData;

	rowData.cellDataList.Length = 2;
	util = getInstanceL2Util();
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, GetSystemString(StringID), util.White, false, 4);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, string(Value), util.Gold, false, 4);
	RichListCtrl.InsertRecord(rowData);
	return;
}

function ShowStatInfo()
{
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(40);
	return;
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case 40:
			break;
		default:
			break;
	}
	return;
}

event OnShow()
{
	UpdateUIControls();
	return;
}

event OnLoad()
{
	Initialize();
	return;
}
