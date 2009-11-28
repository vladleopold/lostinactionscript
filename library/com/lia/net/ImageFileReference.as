package com.lia.net {
	import com.lia.events.ImageFileReferenceEvent;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.FileFilter;
	import flash.net.FileReference;

	/**
	 * @author FlashDynamix
	 */
	public class ImageFileReference extends EventDispatcher {
		
		public var mimeTypes : Array;
		
		private var fileRef : FileReference;
		private var fileLoader : Loader;
		private var fileBitmap : Bitmap;

		public var bitmapData : BitmapData;

		public function ImageFileReference() {
			super();
			
			fileRef = new FileReference();
			fileLoader = new Loader();
			mimeTypes = [new FileFilter("Images", "*.jpg;*.gif;*.png;*.bmp;*.tif")];
			
			fileRef.addEventListener(Event.SELECT, onFileSelectComplete);			fileRef.addEventListener(Event.CANCEL, onFileSelectCancel);			fileRef.addEventListener(Event.COMPLETE, onFileLoadComplete);
			
			fileLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onFileReady);
		}

		public function browse() : void {
			fileRef.browse(mimeTypes);
		}

		private function onFileSelectCancel(event : Event) : void {
			dispatchEvent(new ImageFileReferenceEvent(ImageFileReferenceEvent.CANCEL));
		}

		private function onFileSelectComplete(event : Event) : void {
			fileRef.load();
		}

		private function onFileLoadComplete(event : Event) : void {
			fileLoader.loadBytes(fileRef.data);
		}

		private function onFileReady(event : Event) : void {
			fileBitmap = fileLoader.content as Bitmap;
			bitmapData = fileBitmap.bitmapData;

			dispatchEvent(new ImageFileReferenceEvent(ImageFileReferenceEvent.COMPLETE));
		}

		public function destroy() : void {
			fileRef.removeEventListener(Event.SELECT, onFileSelectComplete);
			fileRef.removeEventListener(Event.CANCEL, onFileSelectCancel);
			fileRef.removeEventListener(Event.COMPLETE, onFileLoadComplete);
			
			fileLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onFileReady);
			
			fileRef = null;
			fileLoader = null;
			mimeTypes = null;
		}
	}
}
