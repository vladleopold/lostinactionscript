package com.lia.events {
	import flash.events.Event;

	/**
	 * @author FlashDynamix
	 */
	public class ImageFileReferenceEvent extends Event {

		public static const CANCEL : String = "photo_file_reference_cancel";
		public static const COMPLETE : String = "photo_file_reference_complete";

		public function ImageFileReferenceEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}

		override public function clone() : Event {
			return new ImageFileReferenceEvent(type, bubbles, cancelable);
		}

		override public function toString() : String {
			return "ImageFileReferenceEvent {type:" + type + ", currentTarget:" + currentTarget + "}";
		}
	}
}
