class UIDATA_SKILL extends UIDataManager;

native static function UIEventManager.ItemID GetFirstID();

native static function UIEventManager.ItemID GetNextID();

native static function int GetDataCount();

native static function string GetIconName(UIEventManager.ItemID Id, int Level, int SubLevel);

native static function string GetIconPanel(UIEventManager.ItemID Id, int Level, int SubLevel);

native static function string GetIconPanel2(UIEventManager.ItemID Id, int Level, int SubLevel);

native static function string GetName(UIEventManager.ItemID Id, int Level, int SubLevel);

native static function string GetDescription(UIEventManager.ItemID Id, int Level, int SubLevel);

native static function string GetEnchantName(UIEventManager.ItemID Id, int Level, int SubLevel);

native static function int GetEnchantSkillLevel(UIEventManager.ItemID Id, int Level, int SubLevel);

native static function string GetEnchantIcon(UIEventManager.ItemID Id, int Level, int SubLevel);

native static function string GetOperateType(UIEventManager.ItemID Id, int Level, int SubLevel);

native static function int GetIconType(UIEventManager.ItemID Id, int Level, int SubLevel);

native static function int GetGroupType(UIEventManager.ItemID Id, int Level, int SubLevel);

native static function bool IsAlchemySkill(UIEventManager.ItemID Id, int Level);

native static function int GetHpConsume(UIEventManager.ItemID Id, int Level, int SubLevel);

native static function int GetMpConsume(UIEventManager.ItemID Id, int Level, int SubLevel);

native static function int GetLpConsume(UIEventManager.ItemID Id, int Level, int SubLevel);

native static function int GetCastRange(UIEventManager.ItemID Id, int Level, int SubLevel);

native static function int GetUltimateSkillLevel(UIEventManager.ItemID Id, int Level, int SubLevel);

native static function int SkillIsNewOrUp(UIEventManager.ItemID Id);

native static function bool IsAvailableClass(UIEventManager.ItemID Id, int Level, int SubLevel, int Class);

native static function GetCurrentSkillList(out array<UIEventManager.ItemID> IDs);

native static function bool IsToppingSkill(UIEventManager.ItemID Id, int Level, int SubLevel);

native static function bool GetToppingSkillExtraInfo(UIEventManager.ItemID Id, int Level, int SubLevel, out UIEventManager.ToppingSkillExtraInfo Info);

native static function bool GetFirstDefaultToppingSkillExtraInfo(out UIEventManager.ToppingSkillExtraInfo Info);

native static function bool GetNextDefaultToppingSkillExtraInfo(out UIEventManager.ToppingSkillExtraInfo Info);

native static function UIEventManager.EAutomaticUseSkillType GetAutomaticUseSkillType(UIEventManager.ItemID Id);

native static function bool GetMSCondItem(int a_ID, int a_Level, int a_SubLevel, out int o_ItemClassID, out int o_ItemCount);

native static function bool GetMSCondEquipType(int a_ID, int a_Level, int a_SubLevel, out UIEventManager.ESkillConditionEquipType o_EquipType);

native static function bool GetMSCondWeapons(int a_ID, int a_Level, int a_SubLevel, out array<UIEventManager.AttackType> o_ArrWeapons);
