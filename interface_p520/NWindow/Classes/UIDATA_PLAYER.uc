class UIDATA_PLAYER extends UIDataManager;

native static function bool IsHero();

native static function bool IsLegend();

native static function int GetPlayerID();

native static function string GetRecipeShopMsg();

native static function float GetPlayerEXPRate();

native static function UIEventManager.EMoveType GetPlayerMoveType();

native static function UIEventManager.EEnvType GetPlayerEnvironment();

native static function bool HasCrystallizeAbility();

native static function int GetInventoryLimit();

native static function int GetInventoryCount();

native static function int GetMeshType();

native static function bool IsInDethrone();

native static function bool IsInPrison();

native static function SetAbilityPoint(int point);

native static function int GetAddPhysicalDefendValue(INT64 a_SlotBitType);

native static function int GetAddMagicalDefendValue(INT64 a_SlotBitType);

native static function bool IsAutoAttacking();

native static function bool IsServerWarFollower();

native static function bool IsServerWarLeader();
