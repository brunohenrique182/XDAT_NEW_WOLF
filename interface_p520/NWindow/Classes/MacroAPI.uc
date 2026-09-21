class MacroAPI extends UIEventManager;

enum EMacroErrorType
{
	MERR_NONE,                      // 0
	MERR_INVALID,                   // 1
	MERR_LIMIT_WORLDCHAT            // 2
};

native static function RequestMacroList();

native static function RequestUseMacro(UIEventManager.ItemID cID);

native static function RequestDeleteMacro(UIEventManager.ItemID cID);

native static function bool RequestMakeMacro(UIEventManager.ItemID cID, string Name, string IconName, int IconNum, int IconSkillId, string Description, array<string> CommandList);
