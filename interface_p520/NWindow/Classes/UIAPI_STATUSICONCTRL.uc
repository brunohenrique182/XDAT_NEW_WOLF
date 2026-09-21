class UIAPI_STATUSICONCTRL extends UIAPI_WINDOW;

native static function AddRow(string ControlName);

native static function AddCol(string ControlName, int Row, UIEventManager.StatusIconInfo Info);

native static function Clear(string ControlName);
