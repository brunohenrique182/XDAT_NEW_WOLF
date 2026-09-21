class EditBoxHandle extends WindowHandle;

native final function string GetString();

native final function SetString(string Str);

native final function AddString(string Str);

native final function SimulateBackspace();

native final function Clear();

native final function SetEditType(string Type);

native final function SetHighLight(bool bHighlight);

native final function SetMaxLength(int MaxLength);

native final function int GetMaxLength();

native final function SetEnableTextLink(bool bEnable);

native final function ClearHistory();

native final function AllSelect();

native final function bool AddNameToAdditionalSearchList(string Name, UIEventManager.ESearchListType listType);

native final function bool FillAdditionalSearchList(out array<string> stringArr, UIEventManager.ESearchListType listType);

native final function bool ClearAdditionalSearchList(UIEventManager.ESearchListType listType);

native final function bool DeleteNameFromAdditionalSearchList(string Name, UIEventManager.ESearchListType listType);

native final function bool AddItemToAutoCompleteHistory(string Name);

native final function SetDownList(bool bDownList);

native final function bool IsShowCandidateBox();

native final function bool DeleteClipBoard();

native final function SetFocusedBackTexture(string Texture1, string Texture2, string Texture3);

native final function SetUnFocusedBackTexture(string Texture1, string Texture2, string Texture3);

native final function bool IsEmpty();

native final function bool AddEmojiIcon(int IconID);

native final function bool SetFormatString(string formatString);

native final function string GetFormatString();

native final function SetAlign(UIEventManager.ETextAlign Align);

native final function SetVAlign(UIEventManager.ETextVAlign VAlign);

native final function SetAsChatEditBox();

native final function SetIME();

native final function SetEnableKeepingSelection(bool bEnable);

native final function SetSelectionTextureColor(Color textureColor);

native final function SetSelectionTextColor(Color TextColor);

native final function SetEnableBackgroundSelectionTexture(bool bEnable);

native final function int GetCursorPosition();

native final function SetCursorPosition(int pos);

native final function AddStringAtPosition(int pos, string Str);

native final function SetLockCommandCharacter(bool bLock);
