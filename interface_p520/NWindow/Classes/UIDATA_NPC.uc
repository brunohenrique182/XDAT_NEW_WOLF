class UIDATA_NPC extends UIDataManager;

native static function int GetFirstID();

native static function int GetNextID();

native static function bool IsValidData(int Id);

native static function string GetNPCName(int Id);

native static function string GetNPCNickName(int Id);

native static function bool GetNpcProperty(int Id, out array<int> arrProperty);

native static function int GetSummonSort(int Id);

native static function int GetSummonMaxCount(int Id);

native static function int GetSummonGrade(int Id);

native static function string GetNPCIconName(int Id);

native static function int GetMentoringNPCId();

native static function string GetNPCMesh(int Id);

native static function bool GetNPCTextureList(int Id, out array<string> TexList);

native static function string GetNPCClass(int Id);
