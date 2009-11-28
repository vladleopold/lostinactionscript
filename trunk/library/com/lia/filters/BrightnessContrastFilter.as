package com.lia.filters {
	import flash.display.*;
	import flash.filters.ShaderFilter;

	/**
	 * @author FlashDynamix
	 */
	public class BrightnessContrastFilter extends ShaderFilter {

		[Embed("/../shaders/BrightnessContrast.pbj", mimeType="application/octet-stream")]
		private var BrightnessContrastPBJ : Class;

		private var _src : ShaderInput;
		private var _contrast : ShaderParameter;
		private var _brightness : ShaderParameter;

		public function BrightnessContrastFilter() {
			super(new Shader(new BrightnessContrastPBJ()));
			
			var shaderData : ShaderData = shader.data;
			
			_src = shaderData.src;
			
			_contrast = shaderData.contrast;			_brightness = shaderData.brightness;
		}

		public function set source(bitmapData : BitmapData) : void {
			_src.input = bitmapData;
		}

		public function set contrast(amount : Number) : void {
			_contrast.value = [amount];
		}

		public function set brightness(amount : Number) : void {
			_brightness.value = [amount];
		}

		public function destroy() : void {
			BrightnessContrastPBJ = null;

			_src = null;
			_contrast = null;
			_brightness = null;
		}
	}
}
