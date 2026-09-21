class MinimapCtrlHandle extends WindowHandle;

native final function AdjustMapView(Vector Loc, optional bool a_ZoomToTownMap, optional bool a_UseGridLocation);

native final function AddTarget(Vector a_Loc);

native final function DeleteTarget(Vector a_Loc);

native final function DeleteAllTarget();

native final function SetShowQuest(bool a_ShowQuest);

native final function SetSSQStatus(int a_SSQStatus);

native final function DrawGridIcon(string a_IconName, Vector a_Loc, bool a_Refresh, int a_IconWidth, int a_IconHeight, optional int a_XOffset, optional int a_YOffset, optional string ToolTipString);

native final function RequestReduceBtn();

native final function bool IsOverlapped(int FirstX, int FirstY, int SecondX, int SecondY);

native final function DeleteAllCursedWeaponIcon();

native final function AddRegionInfo(string RegionInfo);

native final function UpdateRegionInfo(int idx, string RegionInfo);

native final function EraseAllRegionInfo();

native final function EraseRegionInfo(int Index);

native final function SetContinent(int Continent);

native final function int GetContinent(Vector worldLoc);

native final function int GetPlayerContinent();

native final function RegisterQuestIcon(int QuestID, int worldX, int worldY, int worldZ, string typeName);

native final function EraseQuestIcon(int QuestID);

native static function SetDrawTeleportPath(bool bDraw);

native static function SetDirIconDest(UIEventManager.EMinimapTargetIcon Index, Vector DestLoc, string ToolTip);

native static function DisableDirIcon(UIEventManager.EMinimapTargetIcon Index);

native final function AddRegionInfoCtrl(UIEventManager.MinimapRegionInfo RegionInfo);

native final function UpdateRegionInfoCtrl(UIEventManager.MinimapRegionInfo RegionInfo);

native final function EraseRegionInfoCtrl(UIEventManager.EMinimapRegionType eType, int nIndex);

native final function EraseRegionInfoByType(UIEventManager.EMinimapRegionType eType);

native final function SetShowRegionInfoByType(UIEventManager.EMinimapRegionType eType, bool bShow);
