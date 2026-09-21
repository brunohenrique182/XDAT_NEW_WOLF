class HeroBookAPI extends UIEventManager;

native static function GetHeroBookData(byte a_Category, int a_Level, out UIEventManager.HeroBookData o_LevelData);

native static function int GetAllHeroBookListData(byte a_Category, out array<UIEventManager.HeroBookListData> o_ListDatas);

native static function int GetHeroBookItemListFromInven(byte a_Category, out array<UIEventManager.ItemInfo> o_Items);
