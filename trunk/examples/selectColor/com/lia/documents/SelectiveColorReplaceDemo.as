package com.lia.documents {
	import fl.controls.Button;

	import com.lia.controllers.ReplaceColorOptionsController;
	import com.lia.core.Broadcaster;
	import com.lia.core.Controller;
	import com.lia.core.Model;
	import com.lia.data.RenderingData;
	import com.lia.display.*;
	import com.lia.events.ApplicationEvent;
	import com.lia.events.ImageFileReferenceEvent;
	import com.lia.net.ImageFileReference;
	import com.lia.utils.CustomMouseCursor;
	import com.lia.utils.ResultBitmapRenderer;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author Shane McCartney
	 */
	public class SelectiveColorReplaceDemo extends Sprite {

		public var browsePhotoButton : Button;
		public var highlightReplaceColorOptions : ReplaceColorOptionsInterface;		public var shadowReplaceColorOptions : ReplaceColorOptionsInterface;
		public var photoOptionsInterface : PhotoOptionsInterface;
		public var resultOptionsInterface : ResultOptionsInterface;
		public var photoViewContainer : PhotoViewContainer;
		public var resultViewContainer : ResultViewContainer;

		private var fileReference : ImageFileReference;
		private var resultBitmapRender : ResultBitmapRenderer;

		public function SelectiveColorReplaceDemo() {
			fileReference = new ImageFileReference();
			resultBitmapRender = new ResultBitmapRenderer();
			var renderingData : RenderingData = new RenderingData();
			
			CustomMouseCursor.init(stage);
			Model.add(RenderingData, renderingData);
			Controller.add(ReplaceColorOptionsController, new ReplaceColorOptionsController(highlightReplaceColorOptions, shadowReplaceColorOptions));
			
			highlightReplaceColorOptions.dataProvider = renderingData.highlightSampleReplaceColor;			shadowReplaceColorOptions.dataProvider = renderingData.shadowSampleReplaceColor;
			photoOptionsInterface.dataProvider = renderingData.brightnessContrastData;
			resultOptionsInterface.dataProvider = renderingData.resultEffectData;
			
			fileReference.addEventListener(ImageFileReferenceEvent.COMPLETE, onImageFileLoadComplete);
			browsePhotoButton.addEventListener(MouseEvent.MOUSE_DOWN, onBrowseMouseDown);
			Broadcaster.addEventListener(ApplicationEvent.ON_OPTION_CHANGE, onPhotoChange);
			Broadcaster.addEventListener(ApplicationEvent.ON_RENDERED, onPhotoRendered);
			
			highlightReplaceColorOptions.select();
		}

		private function onPhotoChange(event : ApplicationEvent) : void {
			var renderingData : RenderingData = Model.retrieve(RenderingData) as RenderingData;
			
			resultBitmapRender.apply(renderingData);
			
			Broadcaster.dispatchEvent(new ApplicationEvent(ApplicationEvent.ON_RENDERED));
		}

		private function onPhotoRendered(event : ApplicationEvent) : void {
		}

		private function onImageFileLoadComplete(event : ImageFileReferenceEvent) : void {
			var renderingData : RenderingData = Model.retrieve(RenderingData) as RenderingData;
			
			renderingData.originalBitmapData = fileReference.bitmapData;
			
			Broadcaster.dispatchEvent(new ApplicationEvent(ApplicationEvent.ON_OPTION_CHANGE));
		}

		private function onBrowseMouseDown(event : MouseEvent) : void {
			fileReference.browse();
		}
	}
}
