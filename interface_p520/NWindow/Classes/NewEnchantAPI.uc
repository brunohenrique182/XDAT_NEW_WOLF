class NewEnchantAPI extends UIEventManager;

native static function RequestPushOne(UIEventManager.ItemID a_sTargetID);

native static function RequestPushTwo(UIEventManager.ItemID a_sTargetID);

native static function RequestRemoveOne(UIEventManager.ItemID a_sTargetID);

native static function RequestRemoveTwo(UIEventManager.ItemID a_sTargetID);

native static function RequestTryEnchant();

native static function RequestClose();

native static function RequestEnchantRetryPutItems(int OneSlotItemServerID, int TwoSlotItemServerID);

native static function int GetMaterialItemForEnchantFromInven(int OneSlotItemClassID, int OneSlotItemEnchant, int TwoSlotItemClassID, int TwoSlotItemEnchant, out INT64 Commission, out array<UIEventManager.ItemInfo> MaterialItems, optional int FilterID);

native static function int GetMaterialItemForEnchantFromEquip(int OneSlotItemClassID, int OneSlotItemEnchant, int TwoSlotItemClassID, int TwoSlotItemEnchant, out INT64 Commission, out array<UIEventManager.ItemInfo> MaterialItems, optional int FilterID);

native static function bool GetResultItemForEnchant(int OneSlotItemClassID, int OneSlotItemEnchant, int TwoSlotItemClassID, int TwoSlotItemEnchant, out int ResultItemClassID, out int ResultItemEnchant, out int ResultItemNum, out int ResultItemDisplay, out int FailResultItemClassID, out int FailResultItemEnchant, out int FailResultItemNum, out int FailResultItemDisplay);

native static function int GetEnchantCandidateMaterialList(int ItemClassID, out array<int> CandidateMaterials);

native static function bool GetCombinationItemData(int OneSlotItemClassID, int OneSlotItemEnchant, int TwoSlotItemClassID, int TwoSlotItemEnchant, out UIEventManager.CombinationItemUIData o_data);

native static function UIEventManager.ECombinationResultEffectType GetResultEffectType(int OneSlotItemClassID, int OneSlotItemEnchant, int TwoSlotItemClassID, int TwoSlotItemEnchant);

native static function UIEventManager.ECombinationResultBlessType GetResultBlessType(int OneSlotItemClassID, int OneSlotItemEnchant, int TwoSlotItemClassID, int TwoSlotItemEnchant);
