class InputAPI extends UIEventManager;

native static function bool IsShiftPressed();

native static function bool IsCtrlPressed();

native static function bool IsAltPressed();

native static function string GetKeyString(Interactions.EInputKey Key);

native static function Interactions.EInputKey GetInputKey(string keyString);
