﻿var doc = fl.getDocumentDOM();var timeline = doc.getTimeline();var lyrs = timeline.layers;var lyr;var i;var j;var saveDir = fl.browseForFolderURL("Select a folder to save exported SWFs:");if (saveDir) {	fl.outputPanel.clear();		for (i=0; i < lyrs.length; i++) {		lyr = lyrs[i];				if (lyr.layerType == "normal") {						for(j=lyrs.length-1; j>=0; j--){				if(j!=i){					timeline.deleteLayer(j);				}			}						doc.exportSWF(saveDir+"/"+lyr.name+".swf", true);			fl.trace("Exported: " + lyr.name+".swf");			if(doc.canRevert()) doc.revert();						doc = fl.getDocumentDOM();			timeline = doc.getTimeline();			lyrs = timeline.layers;		}	};}