class ProgressCtrlHandle extends WindowHandle;

native final function SetProgressTime(int Millitime);

native final function SetPos(int Millitime);

native final function Reset();

native final function Stop();

native final function Resume();

native final function Start();

native final function SetBackTex(string Left, string Mid, string Right);

native final function SetBarTex(string Left, string Mid, string Right);
