class RandomCraftAPI extends UIEventManager;

struct ItemAmount
{
	var int ItemClassID;
	var int Amount;
};

native static function byte GetMaxSlotLockCount();

native static function byte GetMaxItemLockCount();

native static function ItemAmount GetItemLockCost(byte lockNum);

native static function array<ItemAmount> GetItemMakingCosts();

native static function array<ItemAmount> GetRestCosts();

native static function byte GetMaxItemPoint();

native static function array<byte> GetSlotsSuccessRate();

native static function array<ItemAmount> GetRewardItems();

native static function UIEventManager.RandomCraftAnnounceGrade GetItemAnnounceGrade(int nItemClassID);

native static function int GetMaxGaugeValue();
