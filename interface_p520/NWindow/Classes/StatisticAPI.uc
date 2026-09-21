class StatisticAPI extends UIDataManager;

native static function string GetTitleNameOfStatistic(int Id);

native static function string GetContentInfo(int Id);

native static function string GetTableOfContent();

native static function RequestHotLinkStatistics(int Id);

native static function RequestWorldStatistics(int Id);

native static function RequestUserStatistics();
