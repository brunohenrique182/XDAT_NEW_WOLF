class RadarMapCtrlHandle extends WindowHandle;

native final function AddObject(int Id, string Type, string Name, int locX, int locY, int locZ);

native final function DeleteObject(int ObjectID);

native final function UpdateObject(int Id, int worldX, int worldY, int worldZ);

native final function RequestObjectAround(int ObjectType, int DistanceLimitXY, int DistanceLimitZ);

native final function SetMagnification(float newMag);

native final function SetEnableRotation(bool bEnable);

native final function SetMapInvisible(bool bInvisible);

native final function SwitchSingleMeshMode(bool bUse);
