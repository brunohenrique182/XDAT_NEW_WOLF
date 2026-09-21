class L2UIPacketBase extends Object;

native static function bool EncodeBool(out array<byte> o_Stream, byte a_Value);

native static function bool EncodeByte(out array<byte> o_Stream, byte a_Value);

native static function bool EncodeChar(out array<byte> o_Stream, int a_Value);

native static function bool EncodeWChar_t(out array<byte> o_Stream, string a_Value, optional int a_ArraySize);

native static function bool EncodeShort(out array<byte> o_Stream, int a_Value);

native static function bool EncodeUInt16(out array<byte> o_Stream, int a_Value);

native static function bool EncodeInt(out array<byte> o_Stream, int a_Value);

native static function bool EncodeUInt32(out array<byte> o_Stream, INT64 a_Value);

native static function bool EncodeInt64(out array<byte> o_Stream, INT64 a_Value);

native static function bool EncodeFloat(out array<byte> o_Stream, float a_Value);

native static function bool EncodeDouble(out array<byte> o_Stream, INT64 a_Value);

native static function bool EncodeString(out array<byte> o_Stream, string a_Value, optional bool bIsMorpheus);

native static function bool EncodeWString(out array<byte> o_Stream, string a_Value, optional bool bIsMorpheus);

native static function bool SetShort(out array<byte> o_Stream, int a_Index, int a_Value);

native static function bool DecodeBool(out byte a_Value);

native static function bool DecodeByte(out byte a_Value);

native static function bool DecodeChar(out int a_Value);

native static function bool DecodeWChar_t(out string a_Value, optional int a_ArraySize);

native static function bool DecodeShort(out int a_Value);

native static function bool DecodeUInt16(out int a_Value);

native static function bool DecodeInt(out int a_Value);

native static function bool DecodeUInt32(out INT64 a_Value);

native static function bool DecodeInt64(out INT64 a_Value);

native static function bool DecodeFloat(out float a_Value);

native static function bool DecodeDouble(out INT64 a_Value);

native static function bool DecodeString(out string a_Value, optional bool bIsMorpheus);

native static function bool DecodeWString(out string a_Value, optional bool bIsMorpheus);

native static function int GetCurDecodePos();

native static function RequestUIPacket(int a_UIProtocol, optional array<byte> a_stream);
