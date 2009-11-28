package com.lia.core {
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author blocmedia
	 */
	public class Broadcaster {
		private static var dispatcher : EventDispatcher = new EventDispatcher();

		public static function addEventListener(type : String, listener : Function, useWeakReference : Boolean = true) : void {
			dispatcher.addEventListener(type, listener, false, 0, useWeakReference);
		}

		public static function removeEventListener(type : String, listener : Function) : void {
			dispatcher.removeEventListener(type, listener);
		}

		public static function dispatchEvent(event : Event) : void {
			dispatcher.dispatchEvent(event);
		}
	}
}
