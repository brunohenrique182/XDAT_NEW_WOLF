class BarHandle extends WindowHandle;

native final function SetValue(int a_MaxValue, int a_CurValue);

native final function GetValue(out int a_MaxValue, out int a_CurValue);

native final function Clear();

native final function SetTexture(int TextureIdx, string TexName);
