class UIAPI_EDITBOX extends UIAPI_WINDOW;

native static function string GetString(string ControlName);

native static function SetString(string ControlName, string Str);

native static function AddString(string ControlName, string Str);

native static function SimulateBackspace(string ControlName);

native static function Clear(string ControlName);

native static function SetEditType(string CotrolName, string Type);

native static function SetHighLight(string CotrolName, bool bHighlight);

native static function AllSelect(string ControlName);

native static function SetAlign(string ControlName, UIEventManager.ETextAlign Align);

native static function SetLockCommandCharacter(string ControlName, bool bLock);
