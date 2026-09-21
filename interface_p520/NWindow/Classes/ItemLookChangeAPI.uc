class ItemLookChangeAPI extends UIEventManager;

native static function RequestItemLookChange(UIEventManager.ItemID a_sTargetID);

native static function RequestExTryToPut_Shape_Shifting_TargetItem(UIEventManager.ItemID a_sTargetID);

native static function RequestExTryToPut_Shape_Shifting_EnchantSupportItem(UIEventManager.ItemID a_sTargetID, UIEventManager.ItemID a_sSupportID);

native static function RequestExCancelItemLookChange();
