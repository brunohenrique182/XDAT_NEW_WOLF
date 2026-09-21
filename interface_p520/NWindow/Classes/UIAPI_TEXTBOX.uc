class UIAPI_TEXTBOX extends UIAPI_WINDOW;

native static function SetTextColor(string ControlName, Color a_Color);

native static function SetText(string ControlName, string Text);

native static function SetAlign(string ControlName, UIEventManager.ETextAlign Align);

native static function SetInt(string ControlName, int Number);

native static function string GetText(string ControlName);

native static function SetTooltipString(string ControlName, string Text);
