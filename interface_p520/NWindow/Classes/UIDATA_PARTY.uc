class UIDATA_PARTY extends UIDataManager;

native static function string GetMemberName(int Id);

native static function string MovePartyMember(int SrcPos, int TarPos);

native static function string GetMemberVirtualName(int Id);

native static function int GetMemberTacticalSign(int Id);
