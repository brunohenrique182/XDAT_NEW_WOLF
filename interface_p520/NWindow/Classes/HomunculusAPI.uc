class HomunculusAPI extends UIEventManager;

struct HomunCreateData
{
	var INT64 CostAdena;
	var int HpCount;
	var int HpVolume;
	var int SpCount;
	var INT64 SpVolume;
	var int VpCount;
	var int VpVolume;
	var int CostTime;
	var array<int> GainEvolutionPoint;
};

struct HomunEnchantData
{
	var int PointMax;
	var int PointNeedExp;
	var int PointResetMax;
	var int BonusMax;
	var int BonusNeedVp;
	var int BonusResetMax;
	var int EnchantExpPoint;
	var int CommunionNeedEnchantPoint;
	var int CommunionNeedSpPoint;
};

struct HomunEnchantResetData
{
	var int ItemID;
	var int NeededNum;
};

struct HomunculusData
{
	var int idx;
	var int Id;
	var int Type;
	var bool Activate;
	var int SkillID[6];
	var int SkillLevel[6];
	var int Level;
	var int Exp;
	var int Hp;
	var int Attack;
	var int Defence;
	var int Critical;
	var bool IsNew;
};

struct HomunculusNpcData
{
	var int Id;
	var int NpcID;
	var string ImgName;
	var int EvolutionCostPoint;
	var array<UIEventManager.L2ItemAmountLarge> EvolutionCostItems;
};

struct HomunculusNpcLevelData
{
	var int Id;
	var int Level;
	var int MaxExp;
	var int MaxHP;
	var int MaxAtk;
	var int MaxDef;
	var int MaxCri;
	var int OptionSkillId[3];
	var int OptionSkillLevel[3];
};

struct HomunListUIInfo
{
	var UIEventManager.RequestItem CostItem;
	var INT64 Fee;
	var int Grade;
	var int Event;
};

native static function bool IsHomunReady();

native static function HomunCreateData GetHomunCreateData();

native static function INT64 GetRemainBirthSeconds();

native static function HomunEnchantData GetHomunEnchantData();

native static function HomunEnchantResetData GetPointResetItem();

native static function HomunEnchantResetData GetBonusResetItem();

native static function array<HomunculusData> GetHomunculusDatas();

native static function HomunculusNpcData GetHomunculusNpcData(int Id);

native static function HomunculusNpcLevelData GetHomunculusNpcLevelData(int Id, int Level);

native static function HomunculusNpcLevelData GetMaxHomunculusNpcLevelData(int Id);

native static function array<HomunListUIInfo> GetHomunculusGatchaList();

native static function array<UIEventManager.RequestItem> GetHomunculusSlotActivateCost(int Slot);
