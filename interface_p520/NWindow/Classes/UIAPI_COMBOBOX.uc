class UIAPI_COMBOBOX extends UIAPI_WINDOW;

native static function AddString(string ControlName, string Str);

native static function SYS_AddString(string ControlName, int Index);

native static function AddStringWithReserved(string ControlName, string Str, int Reserved);

native static function SYS_AddStringWithReserved(string ControlName, int Index, int Reserved);

native static function string GetString(string ControlName, int Num);

native static function int GetReserved(string ControlName, int Num);

native static function int GetSelectedNum(string ControlName);

native static function SetSelectedNum(string ControlName, int Num);

native static function Clear(string ControlName);

native static function int GetNumOfItems(string ControlName);

native static function int AddStringWithColor(string ControlName, string Str, Color Col);
