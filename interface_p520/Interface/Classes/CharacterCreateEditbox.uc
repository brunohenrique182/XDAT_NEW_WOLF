class CharacterCreateEditbox extends UICommonAPI;

function OnRegisterEvent()
{
	RegisterEvent(3410);
	return;
}

function OnLoad()
{
	RegisterState("CharacterCreateEditbox", "CHARACTERCREATESTATE");
	if(isChinaVer())
	{
		GetEditBoxHandle("CharacterCreateEditbox.CharacterNameEditbox").SetFocusedBackTexture("L2UI_CT1.EmptyBtn", "L2UI_CT1.EmptyBtn", "L2UI_CT1.EmptyBtn");
		GetEditBoxHandle("CharacterCreateEditbox.CharacterNameEditbox").SetUnFocusedBackTexture("L2UI_CT1.EmptyBtn", "L2UI_CT1.EmptyBtn", "L2UI_CT1.EmptyBtn");
	}
	else
	{
		GetWindowHandle("CharacterCreateEditbox").HideWindow();
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 3410))
	{
		if(isChinaVer())
		{
			if((param == "CHARACTERCREATESTATE"))
			{
				GetWindowHandle("CharacterCreateEditbox").ShowWindow();
			}
			else
			{
				GetWindowHandle("CharacterCreateEditbox").HideWindow();
			}
		}
	}
	return;
}

function OnShow()
{
	if(isChinaVer())
	{
		GetEditBoxHandle("CharacterCreateEditbox.CharacterNameEditbox").SetString("");
		setFocusTarget();
	}
	else
	{
		GetWindowHandle("CharacterCreateEditbox").HideWindow();
	}
	return;
}

function bool isChinaVer()
{
	local UIEventManager.ELanguageType Language;

	Language = GetLanguage();
	return ((int(Language) == 4) || (int(Language) == 1));
}

function setFocusTarget()
{
	if(isChinaVer())
	{
		if(!GetEditBoxHandle("CharacterCreateEditbox.CharacterNameEditbox").IsFocused())
		{
			GetEditBoxHandle("CharacterCreateEditbox.CharacterNameEditbox").SetFocus();
		}
	}
	return;
}

function string getCharacterNameTextFieldValue()
{
	return GetEditBoxHandle("CharacterCreateEditbox.CharacterNameEditbox").GetString();
}
