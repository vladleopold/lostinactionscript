package com.flashdynamix.motion.extras {
	import flash.utils.*;	
	import flash.filters.BitmapFilter;	
	import flash.display.DisplayObject;	

	/**
	 * @author FlashDynamix
	 * Allows for tweening of any property on a BitmapFilter
	 */
	public class Filter extends Proxy {
		public var item : DisplayObject;
		public var filter : BitmapFilter;

		private var idx : int;

		/*
		 * @filter the instance of the BitmapFilter to tween any of it's properties
		 * @items the item which requires the filter to be applied
		 */

		public function Filter(item : DisplayObject, filter : BitmapFilter) {
			this.filter = filter;
			this.item = item;
			
			idx = item.filters.length;
			refresh();
		}

		override flash_proxy function setProperty(name : *, value : *) : void {
			filter[name] = value;
			refresh();
		}

		override flash_proxy function getProperty(name : *) : * {
			return filter[name];
		}

		protected function refresh() : void {
			var filters : Array = item.filters;
			filters[idx] = filter;
			item.filters = filters;
		}

		public function toString() : String {
			return "Filter {item:" + filter + "}";
		}
	}
}
