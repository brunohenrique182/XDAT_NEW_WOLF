class UIDATA_PAWNVIEWER extends UIDataManager;

native static function GetClassNameList(out array<string> ClassNameList, out int SelectedIndex);

native static function SpawnCharacter(string FullClassName);

native static function DuplicateCharacter();

native static function ChangeMyPC();

native static function GetExceptionalFaceList(out array<int> FaceList);

native static function GetExceptionallHairList(out array<int> HairList);

native static function GetExceptionalHairColorList(out array<int> HairColorList);

native static function ApplyFace(int FaceIndex);

native static function ApplyHair(int HairIndex);

native static function ApplyHairColor(int HairColorIndex);

native static function GetFaceInfo(out string MeshName, out string TexName);

native static function GetAHairInfo(out string MeshName, out string TexName);

native static function GetBHairInfo(out string MeshName, out string TexName, out string SubExTexName);

native static function AdjustHairAccOffset(float OffsetX, float OffsetY, float OffsetZ, float Pitch, float Yaw, float Roll);

native static function GetHairAccOffset(out float OffsetX, out float OffsetY, out float OffsetZ, out float Pitch, out float Yaw, out float Roll);

native static function EquipPCItem(UIEventManager.ItemID Id);

native static function ApplyItemRefinery(int ItemClassID, int RefineyOption1, int RefineryOption2, int RefineryOption3);

native static function ApplyItemEnchanted(int ItemClassID, int EnchantedValue);

native static function GetPCAnimationList(out array<string> AnimList);

native static function PlayPCAnim(string AnimName, float AnimSpeed);

native static function PlayPCComboAnim(string Anim1, string Anim2, string Anim3, float HitTime, float LoopIdx);

native static function GetAnimFrame(int Index, out float frame, out float Duration, out float Dues);

native static function string GetSimulMeshName();

native static function int GetVertexNumber();

native static function AddAnchorVertex();

native static function RemoveAnchorVertex();

native static function int GetCollisionNumber();

native static function GetCollisionType(out array<string> ColTypes);

native static function GetCollisionInfo(int ColIdx, out string ColType, out int BoneA, out int BoneB, out float Radius, out byte SphereA, out byte SphereB);

native static function AddCollision(string ColType, int BoneA, int BoneB, float Radius, bool SphereA, bool SphereB);

native static function RemoveCollision(int ColIdx);

native static function UpdateCollision(int ColIdx, string ColType, int BoneA, int BoneB, float Radius, bool SphereA, bool SphereB);

native static function string GetSimulAnimName();

native static function int GetAnimForceNumber();

native static function GetAnimForceInfo(int AnimIdx, out float Weight, out float frame, out float Stiff, out byte TerrainCol, out byte UseForce, out Vector Force);

native static function AddAnimForce(float Weight, float frame, float Stiff, bool TerrainCollision, bool UserForce, Vector Force);

native static function RemoveAnimForce(int AnimIdx);

native static function UpdateAnimForce(int AnimIdx, float Weight, float frame, float Stiff, bool TerrainCollision, bool UserForce, Vector Force);

native static function string GetChestMesh();

native static function Vector GetMantleOffset();

native static function SetMantleOffset(Vector offset);

native static function LoadSimulMesh();

native static function ResetSimulMesh();

native static function SaveSimulMesh();

native static function SetPawnNum(int SimulPawnNum);

native static function SetSkillUseRatio(float SkillUseRatio);

native static function SetSkillCancelRatio(float SkillCancelRatio);

native static function SetSkillDeleteRatio(float PawnDelRatio);

native static function SetArrowRatio(float ArrowRatio);

native static function StartSimulPawn();

native static function ExecuteSkill(int SkillID, int SkillLevel, int SkillSubLevel, optional bool multiTarget);

native static function AddSkillByName(string Name);

native static function AddSkillByID(int Id);

native static function AddSkillByVisualEffect(string visualEffect);

native static function AddSkillByType(int Type);

native static function LoadAllSkills();

native static function SpawnDummyPawn(int Num);

native static function ClearDummyPawn();

native static function SetSimpleEmitter(bool Use);

native static function SetGroundSkillCursor(bool Use);

native static function ExecuteEmitterProfiling();

native static function StopEmitterProfiling();

native static function UpdateEmitterProfiling();

native static function bool IsProfilingEmitter();

native static function GetSkillLevelListByID(int SkillID, array<int> skillLevelList, array<int> skillSubLevelList);

native static function ApplyLeftAttachBoneName(string bonename);

native static function ApplyLeftRotation(int Pitch, int Yaw, int Roll);

native static function ApplyLeftOffset(float X, float Y, float Z);

native static function ApplyLeftSheathingHide(bool bHide);

native static function ApplyRightAttachBoneName(string bonename);

native static function ApplyRightRotation(int Pitch, int Yaw, int Roll);

native static function ApplyRightOffset(float X, float Y, float Z);

native static function ApplyRightSheathingHide(bool bHide);

native static function SpawnNPC(int NpcClassID, out float GoundSpeed, out float AnimRate, out float CollisionRadius, out float CollisionHeight, out float DrawScale, out int PawnState);

native static function ApplyPawnSetting(float GroundSpeed, float AnimRate, float CollisionRadius, float CollisionHeight, float DrawScale, int PawnState);

native static function SpawnActorAtMyLocation(int NpcClassID);

native static function GetNPCAnimationList(out array<string> AnimList);

native static function PlayNPCAnim(string sAnimName, float AnimRate);

native static function EquipNPCItem(UIEventManager.ItemID Id);

native static function GetBoneNameList(out array<string> BoneNameList);

native static function ShowSelectedBone(string SelectedBoneName);
