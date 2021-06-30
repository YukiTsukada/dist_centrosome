showMessage("Select Open Folder");
openDir = getDirectory("Choose a Directory");
showMessage("Select Save Folder");
saveDir = getDirectory("Choose a Directory");

list = getFileList(openDir);

for (i=0; i<list.length;i++){
	operation();
};


function operation(){
	open(openDir+list[i]);
	n = getTitle();
	run("Reduce Dimensionality...", "slices frames");
	run("Smooth", "stack");
	Stack.getDimensions(width, height, channels, slices, frames);
	for(j=1;j<=frames;j++){
		for(i=1;i<=slices;i++){
			Stack.setPosition(1,i, j);
			run("Find Maxima...", "prominence=30 strict exclude output=[Point Selection]");
			run("Measure");
		}	
	}

//saveAs("Results", "saveDir");
newname = n;
rename(newname);
saveAs("Results", saveDir+newname+".csv");
run("Close All");
}

	