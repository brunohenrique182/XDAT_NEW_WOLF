class GFxValue extends Object;

// var pValue;   // PtrProperty has no source form

native final function bool SetMemberFloat(string Name, float Value);

native final function bool SetMemberInt(string Name, int Value);

native final function bool SetMemberString(string Name, string Value);

native final function bool SetMemberValue(string Name, out GFxValue Value);

native final function bool SetMemberBool(string Name, bool Value);

native final function SetFloat(float Value);

native final function SetInt(int Value);

native final function SetBool(bool Value);

native final function bool SetElement(int Index, out GFxValue Value);

native final function string GetString();

native final function bool GetBool();

native final function int GetInt();

native final function float GetFloat();
