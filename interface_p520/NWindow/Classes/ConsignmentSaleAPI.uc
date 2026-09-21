class ConsignmentSaleAPI extends Object;

native static function RequestCommissionInfo(int ServerID);

native static function RequestCommissionRegistrableItemList();

native static function RequestCommissionSellingPremiumItemList();

native static function RequestCommissionRegister(int ServerID, string ItemName, INT64 PricePerUnit, INT64 Amount, int Period, int premiumItemID);

native static function RequestCommissionCancel();

native static function RequestCommissionDelete(INT64 CommissionDBId, int ItemType, int PeriodType);

native static function RequestCommissionList(int depth, int DepthType, int NameCalss, int Grade, string SearchString);

native static function RequestCommissionBuyInfo(INT64 CommissionDBId, int ItemType);

native static function RequestCommissionBuyItem(INT64 CommissionDBId, int ItemType);

native static function RequestCommissionRegisteredItem();

native static function int GetCommissionSellerID();
