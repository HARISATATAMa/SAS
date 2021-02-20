
function ReadFile( fso, fileName){
	var textFile = fso.OpenTextFile(fileName, 1, false);
	var text = "";
	if (!textFile.AtEndOfStream){
		text = textFile.ReadAll();
	};
	textFile.Close();
	return text;
}

var fso = WScript.CreateObject("Scripting.FileSystemObject");

var VersionPostfix = ReadFile(fso, "VersionPostfix.inc");
VersionPostfix = VersionPostfix.replace(' -= Debug =-', "");
var fileVersionPostfix = fso.OpenTextFile("VersionPostfix.inc", 2, false);
fileVersionPostfix.write(VersionPostfix);
fileVersionPostfix.Close();

var dpr = ReadFile(fso, "SASPlanet.dpr");
dpr = dpr.replace('  EurekaLog,\r\n', "");
var dprFile = fso.OpenTextFile("SASPlanet.dpr", 2, false);
dprFile.write(dpr);