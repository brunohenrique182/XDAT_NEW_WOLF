class UIDATA_ITEM extends UIDataManager;

native static function UIEventManager.ItemID GetFirstID();

native static function UIEventManager.ItemID GetNextID();

native static function UIEventManager.ItemID FindNextID(string strItemName, int ItemType, int ItemCrystalType);

native static function int GetDataCount();

native static function string GetItemName(UIEventManager.ItemID Id);

native static function string GetItemAdditionalName(UIEventManager.ItemID Id);

native static function string GetItemTextureName(UIEventManager.ItemID Id);

native static function string GetItemDescription(UIEventManager.ItemID Id);

native static function int GetItemWeight(UIEventManager.ItemID Id);

native static function int GetItemDataType(UIEventManager.ItemID Id);

native static function int GetItemCrystalType(UIEventManager.ItemID Id);

native static function bool GetItemInfo(UIEventManager.ItemID Id, out UIEventManager.ItemInfo Info);

native static function bool GetItemInfoString(int ItemClassID, out string Info);

native static function bool IsCrystallizable(UIEventManager.ItemID Id);

native static function bool IsMagicWeapon(UIEventManager.ItemID Id);

native static function string GetRefineryItemName(string strItemName, int RefineryOp1, int RefineryOp2);

native static function int GetSetItemNum(UIEventManager.ItemID Id, int setIdId);

native static function bool IsExistSetItem(UIEventManager.ItemID Id, int setId, int Index);

native static function int GetSetItemFirstID(UIEventManager.ItemID Id, int setId, int Index);

native static function bool GetSetItemID(UIEventManager.ItemID Id, int setId, int Index, out array<UIEventManager.ItemID> arrID);

native static function int GetItemSetEnchantEffectNum(UIEventManager.ItemID Id);

native static function int GetSetItemEnchantConditionalValue(UIEventManager.ItemID Id, int Index);

native static function string GetSetItemEnchantEffectDescription(UIEventManager.ItemID Id, int Index);

native static function string GetEtcItemTextureName(UIEventManager.ItemID Id);

native static function int GetSetItemPeaceEffectNum(UIEventManager.ItemID Id, int setId);

native static function string GetSetItemPeaceEffectDescription(UIEventManager.ItemID Id, int setId, int EffectIndex);

native static function int GetItemNameClass(UIEventManager.ItemID Id);

native static function UIEventManager.EItemInventoryType GetInventoryType(int ClassID);

native static function GetTextureName(UIEventManager.ItemID Id, int MeshType, out array<string> TexNameList);

native static function GetMeshName(UIEventManager.ItemID Id, int MeshType, out array<string> MeshNameList);

native static function GetExTextureName(UIEventManager.ItemID Id, int MeshType, out array<string> ExTexNameList);

native static function GetExMeshName(UIEventManager.ItemID Id, int MeshType, out array<string> ExMeshNameList);

native static function UIEventManager.EAutomaticUseItemType GetAutomaticUseItemType(int ItemClassID);

native static function bool GetEnchantedItemSkillDesc(int a_ClassID, int a_Enchanted, out array<string> o_Descriptions, out int o_FontLevel);

native static function GetBlessOptionData(int ItemClassID, out UIEventManager.BlessOptionUIData o_data);

native static function UIEventManager.EBlessRepeatType GetBlessRepeatType(int ItemClassID);

native static function string GetBlessedItemName(string strItemName);

native static function bool GetEnchantBlessScrollData(int ItemClassID, out UIEventManager.EnchantBlessScrollUIData o_data);

native static function string GetDBDeleteDateString(INT64 nDBDeleteDate);

native static function string GetDBDeleteRemainTimeString(INT64 nDBDeleteDate);

native static function GetEnchantValidateValue(int a_ItemClassID, int a_Enchanted, out UIEventManager.EnchantValidateUIData o_data);

native static function bool GetEnchantScrollSetData(int a_ScrollItemClassID, int a_TargetItemClassID, out UIEventManager.EnchantScrollSetUIData o_data);

native static function byte GetChallengePointGroupID(int a_ItemClassID);

native static function GetEnchantChallengePointSettingData(out UIEventManager.EnchantChallengePointSettingUIData o_data);

native static function bool GetEnchantChallengePointData(byte a_PointGroupID, out UIEventManager.EnchantChallengePointUIData o_data);

native static function bool IsDefaultActionPeel(int a_ItemClassID);

native static function GetStringMatchingItemList(string a_str, string a_delim, UIEventManager.EStringMatchingItemFilter a_filter, bool a_bAscend, out array<int> o_ItemList);

native static function bool IsDualInventorySlot(INT64 a_SlotBitType);

native static function bool IsUpgradableItem(UIEventManager.ItemID a_ItemId, int a_Type, int a_filter);

native static function GetCharacterStyleDataAll(int a_Category, out array<UIEventManager.CharacterStyleUIData> o_DataList);

native static function bool GetCharacterStyleData(int a_Category, int a_StyleID, out UIEventManager.CharacterStyleUIData o_data);
