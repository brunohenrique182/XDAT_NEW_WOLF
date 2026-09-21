class UIDATA_INVENTORY extends UIDataManager;

native static function bool HasItem(int a_ServerID);

native static function bool HasItemByClassID(int a_ClassID);

native static function bool FindItem(int a_ServerID, out UIEventManager.ItemInfo Info);

native static function int FindItemByClassID(int a_ClassID, out array<UIEventManager.ItemInfo> Info);

native static function bool IsEquipItem(int a_ServerID);

native static function bool IsEquipItemByClassID(int a_ClassID);

native static function bool IsPetInventoryItemByClassID(int a_ClassID);

native static function bool IsQuestItem(int a_ServerID);

native static function bool IsQuestItemByClassID(int a_ClassID);

native static function int GetAllItem(out array<UIEventManager.ItemInfo> Info);

native static function int GetAllEquipItem(out array<UIEventManager.ItemInfo> Info, optional bool IsSlotBitType);

native static function int GetAllInvenItem(out array<UIEventManager.ItemInfo> Info);

native static function int GetAllQuestItem(out array<UIEventManager.ItemInfo> Info);

native static function int GetAllArtifactItem(out array<UIEventManager.ItemInfo> Info);

native static function int GetItemByScriptFilter(int FilterID, out array<UIEventManager.ItemInfo> Info);

native static function int GetAllEnchantableInvenItem(int a_ScrollItemClassID, out array<UIEventManager.ItemInfo> o_ItemInfos);

native static function int GetAllDefaultActionPeelItem(out array<UIEventManager.ItemInfo> o_ItemInfos);

native static function bool IsEquippedBreakItem(int a_ServerID);

native static function bool IsEquippedBreakItemByClassID(int a_ClassID);

native static function int GetSpecificItemNumByScriptFilter(int FilterID, int ClassID, int Enchanted, bool IsBlessedItem);

native static function int GetSpecificItemByScriptFilter(int a_FilterID, int a_ClassID, int a_Enchanted, bool a_IsBlessedItem, out array<UIEventManager.ItemInfo> o_ItemInfoList);
