/*	
.__       _____   ____    ______      ______   __  __     
/\ \     /\  __`\/\  _`\ /\__  _\    /\__  _\ /\ \/\ \    
\ \ \    \ \ \/\ \ \,\L\_\/_/\ \/    \/_/\ \/ \ \ `\\ \   
.\ \ \  __\ \ \ \ \/_\__ \  \ \ \       \ \ \  \ \ , ` \  
..\ \ \L\ \\ \ \_\ \/\ \L\ \ \ \ \       \_\ \__\ \ \`\ \ 
...\ \____/ \ \_____\ `\____\ \ \_\      /\_____\\ \_\ \_\
....\/___/   \/_____/\/_____/  \/_/      \/_____/ \/_/\/_/
	                                                          
	                                                          
.______  ____    ______  ______   _____   __  __  ____    ____     ____    ______   ____    ______   
/\  _  \/\  _`\ /\__  _\/\__  _\ /\  __`\/\ \/\ \/\  _`\ /\  _`\  /\  _`\ /\__  _\ /\  _`\ /\__  _\  
\ \ \L\ \ \ \/\_\/_/\ \/\/_/\ \/ \ \ \/\ \ \ `\\ \ \,\L\_\ \ \/\_\\ \ \L\ \/_/\ \/ \ \ \L\ \/_/\ \/  
.\ \  __ \ \ \/_/_ \ \ \   \ \ \  \ \ \ \ \ \ , ` \/_\__ \\ \ \/_/_\ \ ,  /  \ \ \  \ \ ,__/  \ \ \  
..\ \ \/\ \ \ \L\ \ \ \ \   \_\ \__\ \ \_\ \ \ \`\ \/\ \L\ \ \ \L\ \\ \ \\ \  \_\ \__\ \ \/    \ \ \ 
...\ \_\ \_\ \____/  \ \_\  /\_____\\ \_____\ \_\ \_\ `\____\ \____/ \ \_\ \_\/\_____\\ \_\     \ \_\
....\/_/\/_/\/___/    \/_/  \/_____/ \/_____/\/_/\/_/\/_____/\/___/   \/_/\/ /\/_____/ \/_/      \/_/

    
Copyright (c) 2009 Lost In Actionscript - Shane McCartney

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

 */

function runScript(){
	var userFindText = prompt("Library class text to find", "");
	if (userFindText == null) {
		fl.trace("User cancelled script.");
		return;
	}
	
	var userReplaceText = prompt("Text to replace it", "");
	if (userReplaceText == null) {
		fl.trace("User cancelled script.");
		return;
	}
	
	var searchReg = new RegExp(userFindText, "g");
	var docClassReplaceCount = 0;
	var classReplaceCount = 0;
	var baseReplaceCount = 0;
	var item, classText;
	var dom = fl.getDocumentDOM();
	var lib = dom.library;
	
	classText = dom.docClass;
	if (classText != ""){
		dom.docClass = classText.replace(searchReg, userReplaceText);
		
		// if the class text changed, increment report value
		if (classText != dom.docClass){
			docClassReplaceCount++;
		}
	}
	
	var i = lib.items.length;
	while (i--){
		item = lib.items[i];
		
		classText = item.linkageClassName;
		if (classText != ""){
			item.linkageClassName = classText.replace(searchReg, userReplaceText);
			
			if (classText != item.linkageClassName){
				classReplaceCount++;
			}
		}
		
		classText = item.linkageBaseClass;
		if (classText == ""){
			
			switch (item.itemType){
				case "button":
					classText = "flash.display.SimpleButton";
					break;
				case "movie clip":
					classText = "flash.display.MovieClip";
					break;
				case "bitmap":
					classText = "flash.display.BitmapData";
					break;
				case "sound":
					classText = "flash.media.Sound";
					break;
				
				default:
					classText = null;
					break;
			}
		}
		
		if (classText != "" && item.linkageClassName !=""){
			item.linkageBaseClass = classText.replace(searchReg, userReplaceText);
			
			if (classText != item.linkageBaseClass){
				baseReplaceCount++;
			}
		}
	}
	
	alert(docClassReplaceCount +" document classes replaced\n"
		  +classReplaceCount +" library item classes replaced\n"
		  +baseReplaceCount +" library item base classes replaced");
}

try {
	runScript();
}catch(error){
	fl.trace(error);
}