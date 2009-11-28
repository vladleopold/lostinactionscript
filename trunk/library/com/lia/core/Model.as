package com.lia.core {
	import flash.utils.Dictionary;

	/**
	 * @author blocmedia
	 */
	public class Model {
		private static var dictionary : Dictionary = new Dictionary(true);

		public static function add(key : Object, model : Object) : void {
			dictionary[key] = model;
		}

		public static function retrieve(key : Object) : Object {
			return dictionary[key];
		}
	}
}
