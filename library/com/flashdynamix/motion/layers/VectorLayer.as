package com.flashdynamix.motion.layers {	import flash.display.BitmapData;	import flash.display.Shape;	import flash.events.*;		import com.flashdynamix.motion.vectors.IVector;		/**	 * @author shanem	 */	public class VectorLayer extends Shape {		private var running : Boolean = false;		public var items : Array = [];
		public function VectorLayer(items : Array = null) {			if(items != null) this.items = items;			start();		}
		public function get bitmapData() : BitmapData {			render();						var bmd : BitmapData = new BitmapData(width, height, true, 0x00FFFFFF);			bmd.draw(this);						return bmd;		}
		public function add(item : IVector) : IVector {			items.push(item);			return item;		}
		public function remove(effect : IVector) : Boolean {			var idx : int = items.indexOf(effect);			if(idx == -1) return false;			items.splice(idx, 1);						return true;		}
		public function start() : void {			if(running) return;						running = true;			addEvent(this, Event.ENTER_FRAME, render);		}
		public function stop() : void {			if(!running) return;						running = false;			removeEvent(this, Event.ENTER_FRAME, render);		}
		public function clone() : VectorLayer {			return new VectorLayer(items.concat());		}
		private function render(e : Event = null) : void {			graphics.clear();			var len : int = items.length;			for(var i : int = 0;i < len; i++) IVector(items[i]).draw(graphics);		}
		protected function addEvent(item : EventDispatcher, type : String, liststener : Function, priority : int = 0, useWeakReference : Boolean = true) : void {			item.addEventListener(type, liststener, false, priority, useWeakReference);		}
		protected function removeEvent(item : EventDispatcher, type : String, listener : Function) : void {			item.removeEventListener(type, listener);		}
		public function dispose() : void {			stop();						items = null;		}	}}