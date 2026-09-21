class UIDATA_CLAN extends UIDataManager;

native static function string GetName(int Id);

native static function string GetAllianceName(int Id);

native static function bool GetCrestTexture(int Id, out Texture texCrest);

native static function bool GetEmblemTexture(int Id, out Texture emblemTexture);

native static function bool GetAllianceCrestTexture(int Id, out Texture texCrest);

native static function bool GetNameValue(int Id, out int namevalue);

native static function RequestClanInfo();

native static function RequestClanSkillList();

native static function RequestSubClanSkillList(int subClanIndex);

native static function int GetSkillLevel(int SkillID);

native static function int GetSubClanSkillLevel(int SkillID, int subClanIndex);

native static function RequestUnionInfo();

native static function RequestOpenUnionWnd();
