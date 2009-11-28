package com.lia.core {
	import flash.utils.Dictionary;

	/**
	 * @author blocmedia
	 */
	public class Controller {
		private static var dictionary : Dictionary = new Dictionary(true);

		public static function add(key : Object, controller : Object) : void {
			dictionary[key] = controller;
		}

		public static function retrieve(key : Object) : Object {
			return dictionary[key];
		}
	}
}
