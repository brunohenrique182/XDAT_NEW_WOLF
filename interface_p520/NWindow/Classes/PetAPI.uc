class PetAPI extends UIEventManager;

struct PetEquipInfo
{
	var int ItemID;
	var byte EnchantStep;
	var byte SoulshotCount;
	var byte SpiritshotCount;
	var float pDefense;
	var float mDefense;
	var float pAttack;
	var float mAttack;
	var float pAttackSpeed;
	var float pHitRate;
	var float pCriRate;
	var float ShieldDefense;
	var float ShieldDefenseRate;
	var float pAvoid;
};

native static function RequestPetInventoryItemList();

native static function RequestPetUseItem(UIEventManager.ItemID sID);

native static function RequestGiveItemToPet(UIEventManager.ItemID sID, INT64 Num);

native static function RequestGetItemFromPet(UIEventManager.ItemID sID, INT64 Num, bool IsEquipItem);

native static function bool GetPetEvolveCondition(int PetID, int EvolveStep, out array<UIEventManager.EvolveCondition> arrReqConditions, out array<UIEventManager.RequestItem> arrReqItems);

native static function bool GetPetEvolveLookInfo(int EvolveLookID, out UIEventManager.PetLookInfo LookInfo);

native static function bool GetPetEvolveNameInfo(int EvolveNameID, out UIEventManager.PetNameInfo NameInfo);

native static function int GetPetNameIDBySkill(int a_SkillID, int a_SkillLevel);

native static function GetPetAcquireSkillList(int PetID, int PetLevel, int EvolveStep, out array<UIEventManager.PetAcquireSkillInfo> arrAcquireSkill);

native static function bool GetPetAcquireSkillInfo(int PetID, int SkillID, int SkillLevel, out UIEventManager.PetAcquireSkillInfo o_SkillInfo);

native static function bool GetPetExtractInfo(int PetID, int PetLevel, out UIEventManager.PetExtractInfo ExtractInfo);

native static function bool GetPetRaceEmblemData(int a_PetID, out UIEventManager.L2PetRaceEmblemUIData o_PetEmblemData);

native static function GetPetRaceEmblemDataAll(out array<UIEventManager.L2PetRaceEmblemUIData> o_ArrPetEmblemData);

native static function int GetPetType(int a_PetID);

native static function int GetPetTradeLevel(int a_PetID);

native static function int GetEquipSlotCompleteBonusSkillID(int a_PetID);

native static function bool GetPetEquipInfo(int a_ItemId, byte a_EnchantStep, out PetEquipInfo o_PetEquipInfo);
