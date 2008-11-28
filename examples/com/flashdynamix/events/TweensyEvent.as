package com.flashdynamix.events {
	import flash.events.Event;

	/**
	 * @author FlashDynamix
	 */
	public class TweensyEvent extends Event {

		public static const BEFORE_CHANGE : String = "tweensy_before_change";
		public static const AFTER_CHANGE : String = "tweensy_after_change";
		public static const COMPLETE : String = "tweensy_complete";
		
		public function TweensyEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}

		override public function clone() : Event {
			return new TweensyEvent(type, bubbles, cancelable);
		}
	}
}
