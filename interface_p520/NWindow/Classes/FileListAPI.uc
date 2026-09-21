class FileListAPI extends UIEventManager;

native static function array<UIEventManager.FileNameInfo> GetFileInfoList(string filePath, array<string> arrFileExt);

native static function array<UIEventManager.DriveInfo> GetDriveInfoList();

native static function bool ShowFlash(string filePath);
