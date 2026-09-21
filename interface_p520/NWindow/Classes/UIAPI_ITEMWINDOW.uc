class UIAPI_ITEMWINDOW extends UIAPI_WINDOW;

native static function int GetSelectedNum(string ControlName);

native static function int GetItemNum(string ControlName);

native static function ClearSelect(string ControlName);

native static function AddItem(string ControlName, UIEventManager.ItemInfo Info);

native static function SetItem(string ControlName, int Index, UIEventManager.ItemInfo Info);

native static function DeleteItem(string ControlName, int Index);

native static function bool GetSelectedItem(string ControlName, out UIEventManager.ItemInfo Info);

native static function bool GetItem(string ControlName, int Index, out UIEventManager.ItemInfo Info);

native static function Clear(string ControlName);

native static function int FindItem(string ControlName, UIEventManager.ItemID Id);

native static function int FindItemByClassID(string ControlName, int ClassID);

native static function SetFaded(string ControlName, bool bOn);

native static function ShowScrollBar(string ControlName, bool bShow);

native static function SetToggleEffect(string ControlName, int Index, bool bToggle);

native static function SetIconIndex(string ControlName, int Index, int IconIndex);
