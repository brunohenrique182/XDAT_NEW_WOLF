class EffectViewportWndHandle extends WindowHandle;

native function SetScale(float fScale);

native function SetOffset(Vector VOffset);

native function SetCameraDistance(float fDist);

native function SetCameraPitch(int nPitch);

native function SetCameraYaw(int nYaw);

native function SpawnEffect(string EffectName);

native final function SetUISound(bool IsUISound);
