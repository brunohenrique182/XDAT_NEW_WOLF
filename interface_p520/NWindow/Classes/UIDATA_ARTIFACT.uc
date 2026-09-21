class UIDATA_ARTIFACT extends UIDataManager;

native static function int GetArtifactMinEnchantMaterial(int Enchant);

native static function bool GetArtifactMaterialGroupList(int ArtifactGroupID, out array<int> MaterialIDs);

native static function bool GetArtifactEnchantCondition(int ArtifactID, int Enchant, out int GroupID, out int MaterialCount, out int ResultProb);

native static function GetAllArtifactData(out array<UIEventManager.ArtifactUIData> ArtifactData);

native static function bool FindArtifactData(int ArtifactItemID, out UIEventManager.ArtifactUIData Data);
