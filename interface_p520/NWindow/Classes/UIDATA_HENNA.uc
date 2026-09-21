class UIDATA_HENNA extends UIDataManager;

native static function bool GetItemCheck(int a_ID);

native static function string GetItemNameS(int a_ID);

native static function string GetDescriptionS(int a_ID);

native static function string GetIconTexS(int a_ID);

native static function string GetAddtionNameS(int a_ID);

native static function bool GetItemName(int a_ID, out string a_ItemName);

native static function bool GetDescription(int a_ID, out string a_Description);

native static function bool GetIconTex(int a_ID, out string a_IconTex);

native static function int GetMaxDyeChargeAmount();

native static function bool GetHennaDyeItemLevel(int a_HennaID, out int o_DyeItemLevel);

native static function bool GetHennaDyeItemClassID(int a_HennaID, out int o_ItemClassID);

native static function bool GetDyePotentialData(int a_DyePotentialID, out UIEventManager.DyePotentialUIData o_data);

native static function GetDyePotentialDataList(int a_DyeSlotID, out array<UIEventManager.DyePotentialUIData> o_DataArray);

native static function GetDyePotentialExpDataList(out array<UIEventManager.DyePotentialExpUIData> o_DataArray);

native static function bool GetDyePotentialFeeData(int a_EnchantFeeStep, out UIEventManager.DyePotentialFeeUIData o_data);

native static function bool GetDyeCombinationData(int a_SlotOneItemClassID, out UIEventManager.DyeCombinationUIData o_data);

native static function string GetHennaEmblemTex(int a_HennaID);

native static function bool GetDyePotentialFeeDataBySlot(int a_DyeSlotID, int a_DyePotentialLevel, int a_EnchantFeeStep, out UIEventManager.DyePotentialFeeUIData o_data);

native static function bool GetDyePotentialSlotFeeUIData(int a_DyeSlotID, int a_DyePotentialLevel, out UIEventManager.DyePotentialSlotFeeUIData o_data);

native static function bool GetDyeCombinationDataList(int a_SlotOneItemClassID, out array<UIEventManager.DyeCombinationUIData> o_DataArray);

native static function bool GetDyeEffectUIData(byte a_Category, byte a_SlotID, byte a_DyeLevel, out UIEventManager.DyeEffectUIData o_data);

native static function bool GetDyeEffectSkillList(byte a_Category, byte a_SlotID, out array<UIEventManager.SkillDefaultInfo> o_Skills, out array<UIEventManager.SkillDefaultInfo> o_HiddenSkills);

native static function int GetMaxTryDyeEnchant();
