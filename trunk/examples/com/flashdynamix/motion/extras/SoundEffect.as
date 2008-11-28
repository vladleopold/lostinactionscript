package com.flashdynamix.motion.extras {	import flash.utils.*;		import flash.media.*;	
	/**	 * @author FlashDynamix	 * Allows for altering a SoundTransform properties to effect a SoundChannel	 */	public class SoundEffect extends Proxy {
		public var item : SoundChannel;		public var trans : SoundTransform;
		/*		 * @item The instance of the SoundChannel to tween it's volume or panning		 */		public function SoundEffect(item : SoundChannel) {			this.item = item;			trans = item.soundTransform;		}
		override flash_proxy function setProperty(name : *, value : *) : void {			trans[name] = value;			item.soundTransform = trans;		}
		override flash_proxy function getProperty(name : *) : * {			return trans[name];		}	}}