class RecipeAPI extends UIEventManager;

native static function RequestRecipeShopMakeInfo(int nServerID, int nRecipeID);

native static function RequestRecipeShopSellList(int nServerID);

native static function RequestRecipeShopMakeDo(int merchantId, int RecipeID, INT64 Adena, optional int OfferingCount, optional array<UIEventManager.OfferingItemList> OfferItemList);

native static function RequestRecipeItemMakeSelf(int RecipeID, optional int OfferingCount, optional array<UIEventManager.OfferingItemList> OfferItemList);

native static function RequestRecipeItemMakeInfo(UIEventManager.ItemID sID);

native static function RequestRecipeBookOpen(int Type);

native static function RequestRecipeItemDelete(UIEventManager.ItemID sID);

native static function RequestRecipeShopManageQuit();

native static function RequestRecipeShopMessageSet(string strMsg);

native static function RequestRecipeShopListSet(string param);
