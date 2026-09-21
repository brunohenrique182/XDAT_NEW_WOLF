class AudioAPI extends Object;

native static function PlaySound(string a_SoundName);

native static function PlayMusic(string a_MusicName, float a_FadeInTime);

native static function StopMusic();

native static function PlayVoice(string VoiceName);

native static function PlayNotifySound(string SoundName);

native static function PlayIndexedNotifySound(string a_SoundName, int a_iSoundIndex, bool a_bVoice);
