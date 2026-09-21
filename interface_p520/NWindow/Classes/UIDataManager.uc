class UIDataManager extends UIEventManager;

native final static function int GetClassnameSysstringIndexByClassIndex(int Index);

native final static function GetEnableClassIndexList(int MyIndex, out array<int> EnableClassIndexList);

native final static function int GetClassTypeMaxCount();

native final static function int GetSysStringMaxCount();

native final static function int GetSystemMsgMaxCount();

native final static function int GetMaxServerCount();

native final static function bool GetServerInfo(int ServerWorldID, out UIEventManager.ServerInfoUIData ServerInfo);

native final static function GetServerList(out array<UIEventManager.ServerInfoUIData> ServerList);

native final static function int GetRootClassID(int LeafClassID);

native final static function GetOlympiadGroupServerList(out array<UIEventManager.ServerInfoUIData> ServerList);

native final static function bool GetAbilityItem(int Type, int Row, int Column, out UIEventManager.AbilityItemUIData abilityItemData);

native final static function bool GetDethroneShopDataList(out array<UIEventManager.DethroneShopUIData> ShopDataList);

native final static function bool GetFireAbilityData(UIEventManager.EFireAbilityType FAType, out UIEventManager.FireAbilityUIData Data);

native final static function bool GetFireAbilityComboEffectData(out array<UIEventManager.FireAbilityComboEffectUIData> DataList);

native final static function GetServerWarData(out int o_MinPoint, out array<UIEventManager.L2ItemAmount> o_RewardItem, out array<int> o_RankingRewardProb);

native final static function GetExOptionData(int a_ID, byte a_Level, out UIEventManager.ExOptionData o_ExOptionData);

native final static function GetEquipAddOptionData(int a_ID, out array<UIEventManager.EquipAddOptionData> o_OptionArray);

native final static function GetCardSelectData(int a_BossID, out UIEventManager.CardSelectData o_CardSelectData);

native final static function GetNormalStageData(int a_Index, out UIEventManager.CardSelectNormalStage o_NormalStage);

native final static function GetSpecialStageData(int a_Index, out UIEventManager.CardSelectSpecialStage o_SpecialStage);

native final static function GetPopupEventData(int a_EventID, out UIEventManager.PopupEventData o_data);

native final static function GetTranscendStageData(int a_Index, out UIEventManager.CardSelectTranscendStage o_TranscendStage);
