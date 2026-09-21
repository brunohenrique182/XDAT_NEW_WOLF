class UIDATA_USER extends UIDataManager;

native static function string GetUserName(int ServerID);

native static function bool GetClanType(int Id, out int Type);

native static function bool GetPrologueGrowType(int Id, out int nPrologue);

native static function bool IsPrologueGrowType(int nClassID);

native static function bool IsDethroneEnemy(int ServerID);

native static function bool IsDethroneComrade(int ServerID);
