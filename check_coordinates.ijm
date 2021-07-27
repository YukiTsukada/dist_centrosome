diam = 5;
Fold = 3;

showMessage("Select Open Folder");
openDir = getDirectory("Choose a Directory");
showMessage("Select Save Folder");
saveDir = getDirectory("Choose a Directory");

list = getFileList(openDir);

for (i=0; i<list.length;i++){
    operation();
    display();


};


function display(){
	open(openDir+list[i]);
	n = getTitle();
	Stack.getDimensions(width, height, channels, slices, frames);
	wid = width*Fold;
	hei = height*Fold;
	run("Size...", "width=wid height=hei time=frames constrain average interpolation=Bilinear");
	
	//    for Left projection
	run("Reslice [/]...", "output=2.000 start=Left rotate avoid");
	left_w = getTitle();	
	run("Z Project...", "projection=[Max Intensity] all");
	Stack.setPosition(1,1,1);
	run("Enhance Contrast", "saturated=0.35");
	Stack.setPosition(2,1,1);
	run("Enhance Contrast", "saturated=0.35");
	left_p = getTitle();
	Stack.getDimensions(width, height, channels, slices, frames);
	widF = width*Fold;
	run("Size...", "width=widF height=hei time=frames average interpolation=Bilinear");

	//    for top projection
	selectWindow(n);
	run("Reslice [/]...", "output=2.000 start=Top avoid");
	top_w = getTitle();
	run("Z Project...", "projection=[Max Intensity] all");
	Stack.setPosition(1,1,1);
	run("Enhance Contrast", "saturated=0.35");
	Stack.setPosition(2,1,1);
	run("Enhance Contrast", "saturated=0.35");
	top_p = getTitle();
	Stack.getDimensions(width, height, channels, slices, frames);
	heiF = height*Fold;
	run("Size...", "width=width height=heiF time=frames average interpolation=Bilinear");

	//    for hight projection
	selectWindow(n);
	run("Z Project...", "projection=[Max Intensity] all");
	Stack.setPosition(1,1,1);
	run("Enhance Contrast", "saturated=0.35");
	Stack.setPosition(2,1,1);
	run("Enhance Contrast", "saturated=0.35");
	n_p = getTitle();

	selectWindow(n);
	close();
	selectWindow(left_w);
	close();
	selectWindow(top_w);
	close();

	selectWindow(n_p);
	Stack.getDimensions(width, height, channels, slices, frames);
	
	setColor(255,255,255);
	NN = nResults;
	for(j=1;j<=NN-1;j++){
		if(getResult("Slice",j) != 0){
			selectWindow(n_p);
			Frame_n = getResult("Frame",j);
			Stack.setPosition(1,1,Frame_n);
			X_coordi = getResult("XM",j);
			Y_coordi = getResult("YM",j);
			X_coordiF = X_coordi*Fold;
			Y_coordiF = Y_coordi*Fold;
			drawOval(X_coordiF, Y_coordiF, diam, diam);
			drawString(j, X_coordiF+10, Y_coordiF);
			
			selectWindow(left_p);
			Stack.setPosition(1,1,Frame_n);
			S_coordi = getResult("Slice",j);
			S_coordiF = S_coordi*Fold;
			drawOval(S_coordiF, Y_coordiF, diam, diam);
			drawString(j, S_coordiF+10, Y_coordiF);
			
			selectWindow(top_p);
			Stack.setPosition(1,1,Frame_n);
			drawOval(X_coordiF, S_coordiF, diam, diam);
			drawString(j, X_coordiF+10, S_coordiF);
		}
	}

}


function operation(){
	open(openDir+list[i]);
	n = getTitle();
	run("Reduce Dimensionality...", "slices frames");
	run("Smooth", "stack");
	Stack.getDimensions(width, height, channels, slices, frames);
	for(j=1;j<=frames;j++){
		for(i=1;i<=slices;i++){
			Stack.setPosition(1,i, j);
			run("Find Maxima...", "prominence=50 strict exclude output=[Point Selection]");
			run("Measure");
		}	
	}
	
    //saveAs("Results", "saveDir");
	newname = n;
	rename(newname);
	saveAs("Results", saveDir+newname+".csv");
	run("Close All");	
}
	