class ComboBoxHandle extends WindowHandle;

native final function AddString(string Str);

native final function AddStringWithGap(string Str, optional int gap_mode);

native final function SYS_AddString(int Index);

native final function AddStringWithReserved(string Str, int Reserved);

native final function SYS_AddStringWithReserved(int Index, int Reserved);

native final function string GetString(int Num);

native final function string GetSelectedString();

native final function int GetReserved(int Num);

native final function int GetSelectedNum();

native final function SetSelectedNum(int Num);

native final function Clear();

native final function int GetNumOfItems();

native final function int AddStringWithColor(string Str, Color Col);

native final function array<string> GetFileExtInfo(int Num);

native final function AddStringWithFileExt(string Str, array<string> strArray);

native final function AddStringWithIcon(string Str, string Icontex);

native final function AddStringWithIconWithGap(string Str, string Icontex, optional int gap_mode);

native final function AddStringWithIconWithStr(string Str, string Icontex, string additionalstr);

native final function AddStringWithIconWithGapWithStr(string Str, string Icontex, int gap_mode, string additionalstr);

native final function string GetAdditionalString(int Num);
