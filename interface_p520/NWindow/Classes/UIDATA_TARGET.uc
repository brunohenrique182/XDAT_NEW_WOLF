class UIDATA_TARGET extends UIDataManager;

native static function int GetTargetID();

native static function int GetTargetUserRank();

native static function INT64 GetTargetMaxHP();

native static function INT64 GetTargetHP();

native static function int GetTargetMaxMP();

native static function int GetTargetMP();

native static function string GetTargetName();

native static function Color GetTargetNameColor(int Level);

native static function int GetTargetPledgeID();

native static function int GetTargetClassID();

native static function bool IsServerObject();

native static function bool IsNpc();

native static function bool IsPet();

native static function bool IsCanBeAttacked();

native static function bool IsHPShowableNPC();

native static function bool IsVehicle();

native static function Actor GetTargetActor();
