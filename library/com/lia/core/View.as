package com.lia.core {
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;

	/**
	 * @author blocmedia
	 */
	public class View {
		private static var dictionary : Dictionary = new Dictionary(true);

		public static function add(key : Object, displayObject : DisplayObject) : void {
			dictionary[key] = displayObject;
		}

		public static function remove(key : Object) : void {
			delete dictionary[key];
		}

		public static function retrieve(key : Object) : DisplayObject {
			return dictionary[key];
		}
	}
}
