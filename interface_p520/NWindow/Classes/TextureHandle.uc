class TextureHandle extends WindowHandle;

native final function SetTexture(string a_TextureName);

native final function SetUV(int a_U, int a_V);

native final function SetTextureSize(int a_UL, int a_VL);

native final function SetTextureCtrlType(UIEventManager.ETextureCtrlType Type);

native final function SetTextureWithClanCrest(int clanID);

native final function SetTextureWithObject(Texture objTexture);

native final function string GetTextureName();

native final function SetAutoRotateType(UIEventManager.ETextureAutoRotateType Type);

native final function SetRotatingDirection(int Dir);

native final function Color GetColor(int a_U, int a_V);

native final function SetColorModify(Color a_ColorModify);
