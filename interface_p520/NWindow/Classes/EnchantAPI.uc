class EnchantAPI extends UIEventManager;

native static function RequestEnchantItem(UIEventManager.ItemID a_sTargetID, bool a_UseLateAnnounce);

native static function RequestEnchantItemAttribute(UIEventManager.ItemID sID, INT64 Num);

native static function RequestRemoveAttribute(UIEventManager.ItemID sID, int Type);

native static function RequestExTryToPutEnchantTargetItem(UIEventManager.ItemID a_sTargetID);

native static function RequestExTryToPutEnchantSupportItem(UIEventManager.ItemID a_sTargetID, UIEventManager.ItemID a_sSupportID);

native static function RequestExAddEnchantScrollItem(UIEventManager.ItemID a_sTargetID, UIEventManager.ItemID a_sScrollID);

native static function RequestExRemoveEnchantSupportItem();

native static function RequestExCancelEnchantItem();

native static function RequestLockedItem(int TargetItemID);

native static function RequestLockedItemCancel();

native static function RequestUnlockedItem(int TargetItemID);

native static function RequestUnlockedItemCancel();
