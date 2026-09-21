class UIDATA_QUEST extends UIDataManager;

native static function int GetFirstID();

native static function int GetNextID();

native static function bool IsValidData(int Id);

native static function bool IsMinimapOnly(int Id, int Level);

native static function string GetQuestName(int nQuestID, optional int nQuestLevel);

native static function string GetQuestJournalName(int Id, int Level);

native static function string GetQuestJournalNameLine(string Name);

native static function string GetQuestJournalNameSplit(string Name, int Completed);

native static function string GetQuestDescription(int Id, int Level);

native static function string GetQuestItem(int Id, int Level);

native static function Vector GetTargetLoc(int Id, int Level);

native static function string GetTargetName(int Id, int Level);

native static function Vector GetStartNPCLoc(int Id, int Level);

native static function int GetStartNPCID(int Id, int Level);

native static function string GetRequirement(int Id, int Level);

native static function string GetIntro(int Id, int Level);

native static function int GetMinLevel(int Id, int Level);

native static function int GetMaxLevel(int Id, int Level);

native static function int GetQuestType(int Id, int Level);

native static function int GetClearedQuest(int Id, int Level);

native static function int GetQuestZone(int Id, int Level);

native static function string GetQuestZoneName(int Id, int Level);

native static function bool IsShowableJournalQuest(int Id, int Level);

native static function bool IsShowableItemNumQuest(int Id, int Level);

native static function int GetQuestIscategory(int Id, int Level);

native static function bool GetQuestReward(int Id, int Level, out array<int> RewardIDList, out array<INT64> rewardNumList);

native static function int GetMarkType(int Id, int Level);

native static function int GetQuestCategoryID(int Id, int Level);

native static function int GetQuestPriority(int Id, int Level);

native static function bool IsClassLimitContains(int QuestID, int ClassID);

native static function bool IsClearedQuest(int Id);

native static function bool IsDoingQuest(int Id);

native static function UIEventManager.EQuestStatus GetQuestStatus(int Id);

native static function bool IsAcceptableQuest(int Id);

native static function int GetNFirstID();

native static function int GetNNextID();
