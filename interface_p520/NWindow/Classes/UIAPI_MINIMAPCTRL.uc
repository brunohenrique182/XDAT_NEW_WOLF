class UIAPI_MINIMAPCTRL extends UIAPI_WINDOW;

native static function AdjustMapView(string a_ControlID, Vector Loc, optional bool a_ZoomToTownMap, optional bool a_UseGridLocation);

native static function AddTarget(string a_ControlID, Vector a_Loc);

native static function DeleteTarget(string a_ControlID, Vector a_Loc);

native static function DeleteAllTarget(string a_ControlID);

native static function SetShowQuest(string a_ControlID, bool a_ShowQuest);

native static function SetDailyQuest(string a_ControlID, bool a_ShowRange, int a_DailyQuestIndex);

native static function SetSSQStatus(string a_ControlID, int a_SSQStatus);

native static function DrawGridIcon(string a_ControlID, string a_IconName, Vector a_Loc, bool a_Refresh, int a_IconWidth, int a_IconHeight, optional int a_XOffset, optional int a_YOffset, optional string ToolTipString);

native static function RequestReduceBtn(string a_ControlID);

native static function bool IsOverlapped(string a_ControlID, int FirstX, int FirstY, int SecondX, int SecondY);

native static function DeleteAllCursedWeaponIcon(string a_ControlID);

native static function ShowCertainLayer(string a_ControlID, int LayerNumber);

native static function ResetMinimapData(string a_ControlID);
