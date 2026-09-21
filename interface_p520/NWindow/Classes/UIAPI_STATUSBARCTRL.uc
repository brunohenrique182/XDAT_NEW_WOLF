class UIAPI_STATUSBARCTRL extends UIAPI_WINDOW;

native static function SetPoint(string ControlName, int CurrentValue, int MaxValue);

native static function SetPointPercent(string ControlName, INT64 CurrentValue, INT64 MinValue, INT64 MaxValue);

native static function SetPointExpPercentRate(string ControlName, float CurrentPercentRate);

native static function SetRegenInfo(string ControlName, int Duration, int ticks, float Amount);
