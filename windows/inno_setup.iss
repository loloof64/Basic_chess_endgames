[Setup]
AppName=BasicChessEndgames
AppVersion=4.0.68
DefaultDirName={pf}\BasicChessEndgames
DefaultGroupName=BasicChessEndgames
OutputDir=..\build\windows\installer
OutputBaseFilename=BasicChessEndgames
SetupIconFile="runner\icon.ico"

[Files]
Source: "..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs
Source: "runner\resources\icon.ico"; DestDir: "{app}"

[Icons]
Name: "{group}\BasicChessEndgames"; Filename: "{app}\BasicChessEndgames.exe"; IconFilename: "{app}\icon.ico"
Name: "{commondesktop}\BasicChessEndgames"; Filename: "{app}\BasicChessEndgames.exe"; IconFilename: "{app}\icon.ico"