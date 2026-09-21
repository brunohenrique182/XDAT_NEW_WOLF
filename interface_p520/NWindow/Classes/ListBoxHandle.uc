class ListBoxHandle extends WindowHandle;

native final function AddString(string Text);

native final function Clear();

native final function AddStringWithData(string Text, Color Color, int Data);

native final function string GetSelectedString();

native final function int GetSelectedItemData();

native final function SetListBoxScrollPosition(int pos);

native final function SetDrawOffset(int OffsetX, int OffsetY);

native final function SetMaxRow(int maxrow);
