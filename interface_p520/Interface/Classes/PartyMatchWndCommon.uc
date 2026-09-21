class PartyMatchWndCommon extends UICommonAPI;

const UNION_MAKEROOM_NEW = 1;
const UNION_MAKEROOM_EDIT = 2;

function string GetAmbiguousLevelString(int a_Level, bool a_HasSpace)
{
	local string AmbiguousLevelString;

	if((10 > a_Level))
	{
		if(a_HasSpace)
		{
			AmbiguousLevelString = "1 ~ 9";
		}
		else
		{
			AmbiguousLevelString = "1~9";
		}
	}
	else if((100 > a_Level))
	{
		if(a_HasSpace)
		{
			AmbiguousLevelString = ((string(((a_Level / 10) * 10)) $ " ~ ") $ string((((a_Level / 10) * 10) + 9)));
		}
		else
		{
			AmbiguousLevelString = ((string(((a_Level / 10) * 10)) $ "~") $ string((((a_Level / 10) * 10) + 9)));
		}
	}
	else if((1000 > a_Level))
	{
		if(a_HasSpace)
		{
			AmbiguousLevelString = ((string(((a_Level / 10) * 10)) $ " ~ ") $ string((((a_Level / 10) * 10) + 9)));
		}
		else
		{
			AmbiguousLevelString = ((string(((a_Level / 10) * 10)) $ "~") $ string((((a_Level / 10) * 10) + 9)));
		}
	}
	return AmbiguousLevelString;
}
