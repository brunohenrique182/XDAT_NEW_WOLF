class CharacterViewportWindowHandle extends WindowHandle;

native final function StartRotation(bool bRight);

native final function EndRotation();

native final function StartZoom(bool bOut);

native final function EndZoom();

native final function SetCharacterScale(float fCharacterScale);

native final function SetCharacterOffsetX(int nOffSetX);

native final function SetCharacterOffsetY(int nOffSetY);

native final function AutoAdjustCharOffsetY();

native final function SpawnNPC();

native final function SpawnEffect(string EffectName);

native final function SetUISound(bool IsUISound);

native final function SetCharacterOffsetZ(int nOffsetZ);

native final function SetCharacterOffset(Vector vCharacterOffset);

native final function PlayAnimation(int Index);

native final function PlayAttackAnimation(int Index);

native final function AutoAttacking(bool bAttack);

native final function ShowNPC(float Duration);

native final function HideNPC(float Duration);

native final function SetNPCInfo(int Id);

native final function SetDragRotationRate(int nRotationRate);

native final function SetCurrentRotation(int nRotation);

native final function SetCameraDistance(int nDist);

native function SetCameraPitch(int nPitch);

native final function SetSpawnDuration(float fDuration);

native final function SetNPCViewportData(int Id);

native final function ApplyPreviewCostumeItem(int ItemClassID);

native final function SetBackgroundTex(string BackTexName);

native final function SetWeapon(int a_ClassID, int a_Enchanted, optional bool a_ApplyMyClassLookChange);

native final function SetAutoCameraDistByWeapon(bool a_Enable);

native final function ChangeNPCState(int a_NPCState);

native final function UpdateDollAutoCameraDist(optional float a_StandardSize);

native final function SetPetFlag(bool a_Value);

native final function bool CopyPetEquipment(int a_UserID, INT64 a_SlotBitType);

native final function SetHideEquipItem(bool a_HideWeapon, bool a_HideArmor, bool a_HideHairAccessory);

native final function SetAutoUpdateMyInfo(bool a_AutoUpdate);
