class UIDATA_RECIPE extends UIDataManager;

native static function UIEventManager.ItemID GetRecipeItemID(int Id);

native static function string GetRecipeIconName(int Id);

native static function int GetRecipeProductID(int Id);

native static function int GetRecipeProductNum(int Id);

native static function int GetRecipeCrystalType(int Id);

native static function int GetRecipeMpConsume(int Id);

native static function int GetRecipeLevel(int Id);

native static function string GetRecipeDescription(int Id);

native static function int GetRecipeSuccessRate(int Id);

native static function int GetRecipeIsMultipleProduct(int Id);

native static function string GetRecipeMaterialItem(int Id);

native static function bool IsOfferingItem(UIEventManager.ItemID Id, optional bool IsShop);
