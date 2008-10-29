package com.flashdynamix.motion {
	import com.flashdynamix.events.TweensyEvent;

	/**
	 * @author FlashDynamix
	 */
	public class TweensySequence {
		private static const emptyArray : Array = [];

		public var tween : Tweensy;
		public var items : Array;
		public var onComplete : Function;
		public var onCompleteParams : Array;
		public var repeatable : String;
		public var repeats : int = -1;

		private var repeatCount : int = 0;
		private var disposed : Boolean = false;

		public function TweensySequence() {
			items = emptyArray.concat();
			
			tween = new Tweensy();
			tween.addEventListener(TweensyEvent.COMPLETE, done);
		}

		public function push(instance : Object, target : Object, duration : Number = 0.5, ease : Function = null, delayStart : Number = 0, onComplete : Function = null, onCompleteParams : Array = null) : void {
			var tl : TweensyTimeline = TweensyTimeline(Tweensy.pool.checkOut());
			tl.duration = duration;
			tl.ease = ease;
			tl.delayStart = delayStart;
			tl.onComplete = onComplete;
			tl.onCompleteParams = onCompleteParams;
			
			tl.to(instance, target);
			
			if(last != null) tl.delayStart += last.totalDuration;
			
			items[items.length] = tl;
		}

		public function unshift(instance : Object, target : Object, duration : Number = 0.5, ease : Function = null, delayStart : Number = 0, onComplete : Function = null, onCompleteParams : Array = null) : void {
			var tl : TweensyTimeline, i : int, len : int = items.length;
			
			tl = TweensyTimeline(Tweensy.pool.checkOut());
			tl.duration = duration;
			tl.ease = ease;
			tl.delayStart = delayStart;
			tl.onComplete = onComplete;
			tl.onCompleteParams = onCompleteParams;
			
			tl.to(instance, target);
			
			for(i = 0;i < len;i++) item(i).delayStart += tl.totalDuration;
			
			items.unshift(tl);
		}

		public function addAt(idx : int, instance : Object, target : Object, duration : Number = 0.5, ease : Function = null, delayStart : Number = 0, onComplete : Function = null, onCompleteParams : Array = null) : void {
			var tl : TweensyTimeline, i : int, len : int = items.length;
			
			tl = TweensyTimeline(Tweensy.pool.checkOut());
			tl.duration = duration;
			tl.ease = ease;
			tl.delayStart = delayStart;
			tl.onComplete = onComplete;
			tl.onCompleteParams = onCompleteParams;
			
			tl.to(instance, target);
			
			for(i = idx;i < len;i++) item(i).delayStart += tl.totalDuration;
			
			if(item(idx - 1) != null) tl.delayStart += item(idx - 1).totalDuration;
			
			items.splice(idx, 0, tl);
		}

		public function removeAt(idx : int) : void {
			items.splice(idx, 1);
		}

		public function item(idx : int) : TweensyTimeline {
			return items[idx];
		}

		public function start() : void {
			stop();
			
			var i : int, len : int = items.length;
			for(i = 0;i < len; i++) tween.add(item(i));
		}

		public function stop() : void {
			tween.stopAll();
		}

		public function pause() : void {
			tween.pause();
		}

		public function resume() : void {
			tween.resume();
		}

		private function done(e : TweensyEvent) : void {
			if(canRepeat) {
				
				var i : int, len : int = items.length;
				switch(repeatable) {
					case TweensyTimeline.YOYO : 
						var delays : Array = emptyArray.concat(), tl : TweensyTimeline;
						
						for(i = 0;i < len; i++) delays.unshift(item(i).delayStart);
						
						for(i = 0;i < len; i++) {
							tl = item(i);
							tl.delayStart = delays[i];
							tl.yoyo();
						}
						
						items.reverse();
						break;
					case TweensyTimeline.REPEAT : 
						for(i = len - 1;i >= 0; i--) item(i).repeat();
						break;
				}
				
				repeatCount++;
				start();
			} else {
				if(onComplete != null) onComplete.apply(this, onCompleteParams);
			}
		}

		public function get paused() : Boolean {
			return tween.paused;
		}

		private function get canRepeat() : Boolean {
			return (repeatable != TweensyTimeline.NONE && (repeatCount < repeats || repeats == -1));
		}

		private function get last() : TweensyTimeline {
			return item(items.length - 1);
		}

		public function dispose() : void {
			if(disposed) return;
			
			disposed = true;
			
			tween.dispose();
			
			tween = null;
			items = null;
			onComplete = null;
			onCompleteParams = null;
		}
	}
}
