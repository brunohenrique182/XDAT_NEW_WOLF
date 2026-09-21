class QuestAPI extends Object;

native static function RequestQuestList();

native static function RequestDestroyQuest(int QuestID);

native static function SetQuestTargetInfo(bool QuestOn, bool ShowTargetInRadar, bool ShowArrow, string TargetName, Vector TargetPos, int QuestID, int QuestLevel);
