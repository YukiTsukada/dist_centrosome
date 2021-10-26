showMessage("Select Open Folder");
openDir = getDirectory("Choose a Directory");
list = getFileList(openDir);
showMessage("Select Save Folder");
saveDir = getDirectory("Choose a Directory");
for (i=0; i<list.length;i++){
	open(openDir+list[i]);
	getDimensions(width, height, channels, slices, frames);
	close();
	
	for (l = 1; l <= slices; l++) {
 	    open(openDir+list[i]);
    	    n = getTitle();
    	    run("Orthogonal Views");
    	    Stack.setFrame(l);
	    
    	    for (j = 0; j < width; j++) {
    	    	selectWindow(n);
		Stack.setOrthoViews(j, 0, 1);
		selectWindow("YZ "+ j);
		run("Duplicate..."," ");	
    		}	
    	    Stack.stopOrthoViews;
    	    selectWindow(n);
    	    close();
    	    run("Images to Stack", "name=Stack title=[] use");
    	    run("Z Project...", "projection=[Max Intensity] all");
    	    saveAs("Tiff", saveDir+i+"latX"+l);
    	    close();
    	    close();
	};

	for (m = 1; m <= slices; m++) {
    	    open(openDir+list[i]);
    	    n = getTitle();
    	    run("Orthogonal Views");
    	    Stack.setFrame(m);
	    
    	    for (k = 0; k < width; k++) {
    		selectWindow(n);
		Stack.setOrthoViews(0, k, 1);
		selectWindow("XZ "+ k);
		run("Duplicate..."," ");	
    	    }	
    	    Stack.stopOrthoViews;
    	    selectWindow(n);
    	    close();
    	    run("Images to Stack", "name=Stack title=[] use");
       	    run("Z Project...", "projection=[Max Intensity] all");
    	    saveAs("Tiff", saveDir+i+"latY"+m);
    	    close();
    	    close();
	};
};