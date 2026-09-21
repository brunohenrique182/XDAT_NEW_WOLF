class ActionAPI extends UIEventManager;

native static function RequestActionList();

native static function RequestPetActionList();

native static function RequestSummonedCommonActionList(int ServerID);

native static function RequestSummonedAllSkillActionList();

native static function GetActionNameBySocialIndex(int socialIndex, string retString);

native static function int GetActionAutomaticUseType(int nActionClassID);

native static function bool GetActionUIData(int nActionID, out UIEventManager.ActionUIData UIData);
