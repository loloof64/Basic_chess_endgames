[Setup]
AppName=BasicChessEndgames
AppVersion=4.0.62
DefaultDirName={pf}\BasicChessEndgames
DefaultGroupName=BasicChessEndgames
OutputDir=../build\windows\installer
OutputBaseFilename=BasicChessEndgames
SetupIconFile="runner\icon.ico"

[Files]
Source: "../build\windows\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs
Source: "../build\windows\runner\icon.ico"; DestDir: "{app}"

[Icons]
Name: "{group}\BasicChessEndgames"; Filename: "{app}\BasicChessEndgames.exe"; IconFilename: "{app}\icon.ico"
Name: "{commondesktop}\BasicChessEndgames"; Filename: "{app}\BasicChessEndgames.exe"; IconFilename: "{app}\icon.ico"