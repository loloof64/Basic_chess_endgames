[Setup]
AppName=BasicChessEndgames
AppVersion=4.0.74
DefaultDirName={commonpf}\BasicChessEndgames
DefaultGroupName=BasicChessEndgames
OutputDir=..\build\windows\installer
OutputBaseFilename=BasicChessEndgames
SetupIconFile="runner\resources\app_icon.ico"

[Files]
Source: "..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs
Source: "runner\resources\app_icon.ico"; DestDir: "{app}"

[Icons]
Name: "{group}\BasicChessEndgames"; Filename: "{app}\BasicChessEndgames.exe"; IconFilename: "{app}\app_icon.ico"
Name: "{commondesktop}\BasicChessEndgames"; Filename: "{app}\BasicChessEndgames.exe"; IconFilename: "{app}\app_icon.ico"