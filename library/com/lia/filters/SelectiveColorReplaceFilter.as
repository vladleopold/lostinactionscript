package com.lia.filters {
	import flash.display.*;
	import flash.filters.ShaderFilter;

	/**
	 * @author FlashDynamix
	 */
	public class SelectiveColorReplaceFilter extends ShaderFilter {

		public static const RESULT : int = 1;
		public static const ALPHA_CHANNEL : int = 2;
		public static const OVERLAY : int = 3;

		[Embed("/../shaders/SelectiveColorReplace.pbj", mimeType="application/octet-stream")]
		private var SelectiveColorPBJ : Class;

		private var _src : ShaderInput;

		private var _sampleRgb : ShaderParameter;
		private var _replaceRgb : ShaderParameter;
		private var _fuziness : ShaderParameter;
		private var _contrast : ShaderParameter;
		private var _brightness : ShaderParameter;
		private var _mode : ShaderParameter;

		public function SelectiveColorReplaceFilter() {
			super(new Shader(new SelectiveColorPBJ()));
			
			var shaderData : ShaderData = shader.data;
			
			_src = shaderData.src;
			
			_sampleRgb = shaderData.sampleRgb;
			_replaceRgb = shaderData.replaceRgb;
			
			_fuziness = shaderData.fuziness;			_contrast = shaderData.contrast;			_brightness = shaderData.brightness;			_mode = shaderData.mode;
		}

		public function set source(bitmapData : BitmapData) : void {
			_src.input = bitmapData;
		}

		public function set sampleRgb(color3 : Array) : void {
			_sampleRgb.value = color3;
		}

		public function set replaceRgb(color3 : Array) : void {
			_replaceRgb.value = color3;
		}

		public function set fuziness(amount : Number) : void {
			_fuziness.value = [amount];
		}

		public function set contrast(amount : Number) : void {
			_contrast.value = [amount];
		}

		public function set brightness(amount : Number) : void {
			_brightness.value = [amount];
		}

		public function set mode(type : int) : void {
			_mode.value = [type];
		}

		public function destroy() : void {
		}
	}
}
