package com.flashdynamix.motion {
	import flash.display.Sprite;
	import flash.events.*;
	import flash.utils.*;

	import com.flashdynamix.events.TweensyEvent;
	import com.flashdynamix.motion.TweensyTimeline;
	import com.flashdynamix.motion.extras.ObjectPool;	

	/**
	 * @author Shane McCartney
	 */
	public class Tweensy extends EventDispatcher {
		private static const version : Number = 0.1;
		
		private static const emptyArray : Array = [];
		private static var instanceMap : Dictionary = new Dictionary(false);
		private static var frame : Sprite = new Sprite();
		
		public static var pool : ObjectPool = new ObjectPool(TweensyTimeline);

		public static const TIME : String = "time";
		public static const FRAME : String = "frame";

		public var lazyMode : Boolean;
		public var secsPerFrame : Number = 1 / 30;
		public var refreshType : String;

		private var list : Array;
		private var garbageLimit : int = 500;
		private var time : Number;
		private var trash : Array;
		private var trashed : int = 0;
		private var length : int = 0;
		private var canDispatch : Boolean = false;
		private var _paused : Boolean;
		private var disposed : Boolean = false;

		/*
		 * @lazyMode Wether the tween manager will automatically remove confilcting tweens
		 * @type this can be either TIME or FRAME by default it's TIME. TIME will ensure that your animations finish in
		 * the time you specify. FRAME allows you to set the seconds to update per frame by default it's set to 30 FPS which equals
		 * in SPF 0.033333333.
		 */
		public function Tweensy(lazyMode : Boolean = false, type : String = "time") {
			this.lazyMode = lazyMode;
			time = getTimer() * 0.001;
			
			list = emptyArray.concat();
			trash = emptyArray.concat();
			
			refreshType = type;
		}

		/*
		 * Adds a to based tween to the properties defined in the target Object.
		 * @instance The instance Object to be tweened or multiple instances if using the type Array i.e. [item1, item2]
		 * @target An Object containing the properties you would like to tween to i.e. {x:50, y:25}
		 * or this can be relative i.e. {x:'50', y:'-25'} or can be a random position i.e. {x:'-50, 50', y:'-25, 25'}
		 * @duration The time in secs you would like the tween to run
		 * @ease The ease type you would like to use
		 * @delayStart The delay you would like to use at the beginning of the ween
		 * @onComplete The onComplete event handler you would like to fire once the tween is complete
		 * @onCompleteParams The params applied to the onComplete handler
		 * @multiple Allows for tweening indexes of an Array by setting this to false
		 */
		public function to(instance : Object, target : Object, duration : Number = 0.5, ease : Function = null, delayStart : Number = 0, onComplete : Function = null, onCompleteParams : Array = null, multiple : Boolean = true) : TweensyTimeline {
			var tl : TweensyTimeline = pool.checkOut();
			tl.duration = duration;
			if(ease != null) tl.ease = ease;
			tl.delayStart = delayStart;
			tl.onComplete = onComplete;
			tl.onCompleteParams = onCompleteParams;
				
			if(multiple && instance is Array) {
				var len : int = instance.length, i : int; 
				
				for( i = 0;i < len; i++) tl.to(instance[i], target);
			} else {
				tl.to(instance, target);
			}
			
			return add(tl);
		}

		/*
		 * Adds a from based tween to the properties defined in the target Object.
		 * @instance The instance Object to be tweened or multiple instances if using the type Array i.e. [item1, item2]
		 * @target An Object containing the properties you would like to tween to i.e. {x:50, y:25}
		 * or this can be relative i.e. {x:'50', y:'-25'} or can be a random position i.e. {x:'-50, 50', y:'-25, 25'}
		 * @duration The time in secs you would like the tween to run
		 * @ease The ease type you would like to use
		 * @delayStart The delay you would like to use at the beginning of the ween
		 * @onComplete The onComplete event handler you would like to fire once the tween is complete
		 * @onCompleteParams The params applied to the onComplete handler
		 * @multiple Allows for tweening indexes of an Array by setting this to false
		 */
		public function from(instance : Object, target : Object, duration : Number = 0.5, ease : Function = null, delayStart : Number = 0, onComplete : Function = null, onCompleteParams : Array = null, multiple : Boolean = true) : TweensyTimeline {
			var tl : TweensyTimeline = pool.checkOut();
			tl.duration = duration;
			tl.ease = ease;
			tl.delayStart = delayStart;
			tl.onComplete = onComplete;
			tl.onCompleteParams = onCompleteParams;
			
			if(multiple && instance is Array) {
				var len : int = instance.length, i : int; 
				
				for(i = 0;i < len; i++) tl.from(instance[i], target);
			} else {
				tl.from(instance, target);
			}
			
			return add(tl);
		}

		/*
		 * Adds a fromTo based tween to the properties defined in the target Object.
		 * @instance The instance Object to be tweened or multiple instances if using the type Array i.e. [item1, item2]
		 * @target An Object containing the properties you would like to tween to i.e. {x:50, y:25}
		 * or this can be relative i.e. {x:'50', y:'-25'} or can be a random position i.e. {x:'-50, 50', y:'-25, 25'}
		 * @duration The time in secs you would like the tween to run
		 * @ease The ease type you would like to use
		 * @delayStart The delay you would like to use at the beginning of the ween
		 * @onComplete The onComplete event handler you would like to fire once the tween is complete
		 * @onCompleteParams The params applied to the onComplete handler
		 * @multiple Allows for tweening indexes of an Array by setting this to false
		 */
		public function fromTo(instance : Object, from : Object, to : Object, duration : Number = 0.5, ease : Function = null, delayStart : Number = 0, onComplete : Function = null, onCompleteParams : Array = null, multiple : Boolean = true) : TweensyTimeline {
			var tl : TweensyTimeline = pool.checkOut();
			tl.duration = duration;
			tl.ease = ease;
			tl.delayStart = delayStart;
			tl.onComplete = onComplete;
			tl.onCompleteParams = onCompleteParams;
			
			if(multiple && instance is Array) {
				var len : int = instance.length, i : int; 
				
				for(i = 0;i < len; i++) tl.fromTo(instance[i], from, to);
			} else {
				tl.fromTo(instance, from, to);
			}
			
			return add(tl);
		}

		/*
		 * Adds a timeline to the Tween manager
		 */
		public function add(item : TweensyTimeline) : TweensyTimeline {
			if(isEmpty) startUpdate();
			
			item.start(time);
			
			if(lazyMode) {
				var args : Array = item.items;
				args.concat(item.props);
				
				stop.apply(null, args);
			}
			
			list[list.length] = item;
			length++;
			
			return item;
		}

		/*
		 * Allows for removing a tween from the manager by an instance and for the defined props 
		 */
		public function stop(instance : *, ...props : Array) : int {
			var tl : TweensyTimeline, len : int = instance.length, i : int, args : Array = props;
	
			args.unshift(instance);
			
			for(i = 0;i < len; i++) {
				tl = item(i);
				if(tl != null) tl.remove.apply(null, args);
			}
			
			return length;
		}

		/*
		 * Removes all tweens from the tween manager
		 */
		public function stopAll() : void {
			stopUpdate();
			
			list = emptyArray.concat();
			trash = emptyArray.concat();
			
			length = 0;
			trashed = 0;
		}

		public function pause() : void {
			var tl : TweensyTimeline, len : int = list.length, i : int;
			
			for(i = 0;i < len; i++) {
				tl = item(i);
				if(tl != null) tl.pause();
			}
		}

		public function resume() : void {
			var tl : TweensyTimeline, len : int = list.length, i : int;
			
			for(i = 0;i < len; i++) {
				tl = item(i);
				if(tl != null) tl.resume();
			}
		}

		public function get paused() : Boolean {
			return _paused;
		}

		/*
		 * Returns wether the manager contains tweens
		 */
		public function get isEmpty() : Boolean {
			return (length == 0);
		}

		/*
		 * Allows for a static reference to the tween manager by multiton keys
		 */
		public static function getInstance(multitonKey : * = null) : Tweensy {
			if(instanceMap[multitonKey] == null) instanceMap[multitonKey] = new Tweensy();
			return instanceMap[multitonKey];
		}

		public static function removeInstance(multitonKey : *) : void {
			delete instanceMap[multitonKey];
		}

		public static function gc() : void {
			pool.dispose();
			instanceMap = null;
			frame = null;
		}

		private function item(idx : int) : TweensyTimeline {
			return list[idx];
		}

		private function startUpdate() : void {
			time = getTimer() * 0.001;
			
			addEvent(frame, Event.ENTER_FRAME, update);
		}

		private function stopUpdate() : void {
			removeEvent(frame, Event.ENTER_FRAME, update);
		}

		private function addTrash(idx : int) : void {
			pool.checkIn(list[idx]);
			
			list[idx] = null;
			trashed++;

			if(--length == 0) stopUpdate();
		}

		private function emptyTrash() : void {
			trash.sort(Array.NUMERIC);
			
			var len : int = trash.length, startIdx : int = trash[len - 1], endIdx : int = startIdx, currentIdx : int, i : int;
			
			for(i = len - 2;i >= 0; i--) {
				currentIdx = trash[i];
				
				if((startIdx - currentIdx) > 1 || i == 0) {
					list.splice(startIdx, endIdx - startIdx + 1);
					endIdx = currentIdx;
				}
				
				startIdx = currentIdx;
			}
			
			trashed = 0;
			trash = emptyArray.concat();
		}

		private function update(e : Event) : void {
			var tl : TweensyTimeline, len : int = list.length, i : int;
			
			if(refreshType == FRAME) {
				time += secsPerFrame;
			} else {
				time = getTimer() * 0.001;
			}
			
			dispatchEventType(TweensyEvent.BEFORE_CHANGE);
			
			for(i = 0;i < len; i++) {
				tl = list[i];
				if(tl != null && tl.update(time)) addTrash(i);
			}
			
			if(trashed >= garbageLimit) emptyTrash();

			dispatchEventType(TweensyEvent.AFTER_CHANGE);
			if(isEmpty) dispatchEventType(TweensyEvent.COMPLETE);
		}

		private function dispatchEventType(type : String) : void {
			if(canDispatch) dispatchEvent(new TweensyEvent(type));
		}

		override public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = true) : void {
			canDispatch = true;
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		override public function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void {
			super.removeEventListener(type, listener, useCapture);
			canDispatch = hasEventListeners(TweensyEvent.AFTER_CHANGE, TweensyEvent.BEFORE_CHANGE, TweensyEvent.COMPLETE);
		}

		private function hasEventListeners(...items : Array) : Boolean {
			var has : Boolean = false, len : int = items.length, i : int;
			
			for(i = 0;i < len; i++) if(hasEventListener(items[i])) has = true;
			
			return has;
		}

		protected function addEvent(item : EventDispatcher, type : String, liststener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = true) : void {
			item.addEventListener(type, liststener, useCapture, priority, useWeakReference);
		}

		protected function removeEvent(item : EventDispatcher, type : String, listener : Function, useCapture : Boolean = false) : void {
			item.removeEventListener(type, listener, useCapture);
		}

		public function dispose() : void {
			if(disposed) return;
			
			disposed = true;
			
			stopUpdate();
			
			var tl : TweensyTimeline, len : int = list.length, i : int;
			
			for(i = 0;i < len; i++) {
				tl = item(i);
				if(tl != null) tl.dispose();
			}
			
			list = null;
			trash = null;
			length = 0;
			trashed = 0;
		}

		override public function toString() : String {
			return "Tweensy " + version + " {items:" + length + "}";
		}
	}
}