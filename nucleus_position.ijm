showMessage("Select Open Folder");
openDir = getDirectory("Choose a Directory");
list = getFileList(openDir);
showMessage("Select Save Folder");
saveDir = getDirectory("Choose a Directory");

for (i=0; i<list.length;i++){
	open(openDir+list[i]);
	getDimensions(width, height, channels, slices, frames);
	close();
	File.makeDirectory(saveDir+"/xz"+i);	
	for (l = 1; l <= frames; l++) {
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
    	    saveAs("Tiff", saveDir+"/xz"+i+"/latX"+l);
    	    close();
    	    close();
	};
	File.makeDirectory(saveDir+"/yz"+i);	
	for (m = 1; m <= frames; m++) {
    	    open(openDir+list[i]);
    	    n = getTitle();
    	    run("Orthogonal Views");
    	    Stack.setFrame(m);
	    
    	    for (k = 0; k < height; k++) {
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
    	    saveAs("Tiff", saveDir+"/yz"+i+"/latY"+m);
    	    close();
    	    close();
	};
	
	list_xz = getFileList(saveDir+"/xz"+i);
	for(n=0; n<list_xz.length;n++){
		open(saveDir+"/xz"+i+"/"+list_xz[n]);
	}
	run("Images to Stack", "name=Stack title=[] use");
	saveAs("Tiff", saveDir+i+"latX");
	close();
	
	list_yz = getFileList(saveDir+"/yz"+i);
	for(o=0; o<list_yz.length;o++){
		open(saveDir+"/yz"+i+"/"+list_yz[o]);
	}
	run("Images to Stack", "name=Stack title=[] use");
	saveAs("Tiff", saveDir+i+"latY");
	close();
};