package com.flashdynamix.motion {
	import com.flashdynamix.motion.extras.ObjectPool;		

	/**
	 * @author FlashDynamix
	 */
	public class TweensyTimeline {
		private static const emptyArray : Array = [];

		public static const YOYO : String = "yoyo";
		public static const REPEAT : String = "repeat";
		public static const LOOP : String = "loop";
		public static const NONE : String = null;

		public static var defaultTween : Function = easeOut;
		private static var pool : ObjectPool;

		public var list : Array;
		public var ease : Function;
		public var delayStart : Number = 0;
		public var delayEnd : Number = 0;
		public var repeatable : String;
		public var repeats : int = -1;
		public var repeatEase : Array;

		public var onComplete : Function;
		public var onCompleteParams : Array;
		public var onRepeat : Function;
		public var onRepeatParams : Array;

		private var iTime : Number = 0;
		private var pTime : Number = 0;
		private var cTime : Number = 0;
		private var _paused : Boolean = false;
		private var repeatCount : int = 0;
		private var inited : Boolean = false;
		private var args : Array;
		private var _duration : Number;
		private var disposed : Boolean = false;

		public function TweensyTimeline() {
			if(pool == null) pool = new ObjectPool(TweensyProperty);
			
			args = emptyArray.concat();
			list = emptyArray.concat();
			
			this.duration = duration;
			this.delayStart = delayStart;
			this.ease = (ease == null) ? defaultTween : ease;
			
			this.onComplete = onComplete;
			this.onCompleteParams = onCompleteParams;
		}

		public function to(instance : Object, target : Object, multiple : Boolean = true) : void {
			
			if(multiple && instance is Array) {
				var i : int, len : int = items.length;
				for(i = 0;i < len; i++) to(items[i], target);
			} else {
				var prop : String,  tp : TweensyProperty;
				
				for(prop in target) {
					tp = TweensyProperty(pool.checkOut());
					tp.instance = instance;
					tp.name = prop;
					tp.target = target[prop];
					
					add(tp);
				}
			}
		}

		public function from(instance : Object, target : Object, multiple : Boolean = true) : void {
			if(multiple && instance is Array) {
				var i : int, len : int = items.length;
				for(i = 0;i < len; i++) from(items[i], target);
			} else {
				var prop : String, value : Number, tp : TweensyProperty;
				for( prop in target) {
					value = target[prop];
					target[prop] = instance[prop];
					instance[prop] = value;
					
					tp = pool.checkOut();
					
					tp.instance = instance;
					tp.name = prop;
					tp.target = target[prop];
					
					add(tp);
				}
			}
		}

		public function fromTo(instance : Object, from : Object, to : Object, multiple : Boolean = true) : void {
			if(multiple && instance is Array) {
				var i : int, len : int = items.length;
				for(i = 0;i < len; i++) fromTo(items[i], from, to);
			} else {
				var prop : String, tp : TweensyProperty;
				for(prop in from) {
					instance[prop] = from[prop];
					
					tp = pool.checkOut();
					
					tp.instance = instance;
					tp.name = prop;
					tp.target = from[prop];
					
					add(tp);
				}
			}
		}

		public function start(time : Number) : void {
			cTime = iTime = time;
		}

		public function add(tp : TweensyProperty) : void {
			list[list.length] = tp;
		}

		public function item(idx : int) : TweensyProperty {
			return list[idx];
		}

		public function remove(instance : *, ...props : Array) : int {
			var items : Array = (instance is Array) ? instance : (instance == null) ? emptyArray.concat() : [instance];
			var tp : TweensyProperty, i : int, len : int = list.length;
			
			for(i = len - 1;i >= 0; i--) {
				tp = item(i);
				if((items.indexOf(tp.instance) != -1 || items.length == 0) && props.indexOf(tp.name) != -1) list.splice(i, 1);
			}
			
			return list.length;
		}

		public function update(num : Number) : Boolean {
			cTime = num;
			
			if(paused) return false;
			
			var played : Number = time - delayStart, done : Boolean = false;
			
			if(played > 0) {
				
				done = played >= (_duration + delayEnd);
				var tp : TweensyProperty, i : int, len : int = list.length, tweening : Boolean = played < _duration;
				if(tweening) args[0] = played;
				
				for(i = 0;i < len; i++) {
					tp = list[i];
					
					if(!inited) {
						tp.initial = tp.instance[tp.name];
						tp.change = tp.target - tp.initial;
					}
					
					if(tweening) {
						args[1] = tp.initial; 
						args[2] = tp.change;
						tp.instance[tp.name] = ease.apply(null, args);
					} else {
						tp.instance[tp.name] = tp.target;
					}
				}
				
				inited = true;
				
				if(done) {
					
					if(canRepeat) {
						switch(repeatable) {
							case TweensyTimeline.YOYO :
								yoyo();
								break;
							case TweensyTimeline.REPEAT :
								repeat();
								break;
							case TweensyTimeline.LOOP :
								loop();
								break;
						}
						
						if(onRepeat != null) onRepeat.apply(null, onRepeatParams);
					} else {
						if(onComplete != null) onComplete.apply(null, onCompleteParams);
					}
					
					done = finished;
					if(done) {
						for(i = 0;i < len; i++) pool.checkIn(item(i));
						clean();
					}
				}
			}
			
			return done;
		}

		public function pause() : void {
			if(paused) return;
			
			pTime = cTime;
			_paused = true; 
		}

		public function resume() : void {
			if(!paused) return;
			
			_paused = false;
			iTime += (cTime - pTime);
			pTime = 0;
		}

		public function loop() : void {
			var tp : TweensyProperty, i : int, len : int = list.length;
			for(i = 0;i < len; i++) {
				tp = item(i);
				tp.target = tp.initial;
			}
			
			var oldStart : Number = delayStart;
			delayStart = delayEnd;
			delayEnd = oldStart;
			
			doRepeat();
		}

		public function yoyo() : void {
			var tp : TweensyProperty, i : int, len : int = list.length;
			for(i = 0;i < len; i++) {
				tp = item(i);
				tp.target = tp.initial;
			}
			
			doRepeat();
		}

		public function repeat() : void {
			var tp : TweensyProperty, i : int, len : int = list.length;
			for(i = 0;i < len; i++) {
				tp = item(i);
				tp.instance[tp.name] = tp.initial;
			}
			
			doRepeat();
		}

		public function intersects(item : TweensyTimeline) : Boolean {
			return (item.iTime >= iTime && item.iTime <= iTime + totalDuration);
		}

		public function get length() : int {
			return list.length;
		}

		public function get items() : Array {
			var tp : TweensyProperty, i : int, len : int = list.length, idx : int = 0, data : Array = emptyArray.concat();
			
			for(i = 0;i < len; i++) {
				tp = item(i);
				if(data.indexOf(tp.instance) == -1) {
					data[idx] = tp.instance;
					idx++;
				}
			}
			
			return (data);
		}

		public function get props() : Array {
			var tp : TweensyProperty, i : int, len : int = list.length, idx : int = 0, data : Array = emptyArray.concat();
			
			for(i = 0;i < len; i++) {
				tp = item(i);
				if(data.indexOf(tp.name) == -1) {
					data[idx] = tp.name;
					idx++;
				}
			}
			
			return (data);
		}

		public function get time() : Number {
			return (cTime - iTime);
		}

		public function get canRepeat() : Boolean {
			return (repeatable != NONE && (repeats == -1 || repeatCount < repeats));
		}

		/*
		 * Sets the property tween to a position from 0 to 1
		 */
		public function set position(idx : Number) : void {
			iTime = cTime - (idx * totalDuration);
			update(cTime);
		}

		/*
		 * Gets the property tween position from 0 to 1
		 */
		public function get position() : Number {
			return (time / totalDuration);
		}

		/*
		 * Check to see if the tween is playing
		 */
		public function get playing() : Boolean {
			return ((time >= delayStart) && !finished && !paused);
		}

		/*
		 * Check to see if the tween has finished playing
		 */
		public function get finished() : Boolean {
			return (time >= totalDuration);
		}

		public function get totalDuration() : Number {
			return (delayStart + _duration + delayEnd);
		}

		public function set duration(num : Number) : void {
			args[3] = num;
			_duration = num;
		}

		public function get duration() : Number {
			return _duration;
		}

		public function set easeParams(value : Array) : void {
			args = args.slice(0, 4).concat(value);
		}

		public function get paused() : Boolean {
			return (_paused);
		}

		public function get isEmpty() : Boolean {
			return (list.length == 0);
		}

		private function doRepeat() : void {
			iTime = cTime;
			inited = false;
			repeatCount++;
			if(repeatEase != null) ease = repeatEase[repeatCount % repeatEase.length];
		}

		private function clean() : void {
			list = emptyArray.concat();
			args = emptyArray.concat();
			
			iTime = 0;
			pTime = 0;
			cTime = 0;
			
			_paused = false;
			repeatCount = 0;
			inited = false;
		}

		private static function easeOut(t : Number, b : Number, c : Number, d : Number) : Number {
			return c * ((t = t / d - 1) * t * t * t * t + 1) + b;
		}

		public function dispose() : void {
			if(disposed) return;
			
			disposed = true;
			
			var i : int, len : int = list.length;
			for( i = 0;i < len; i++) item(i).dispose();
			
			list = null;
			ease = null;
			onComplete = null;
			onCompleteParams = null;
		}

		public function toString() : String {
			return "TweensyTimeline {items:" + list.length + "}";
		}
	}
}

internal class TweensyProperty extends Object {

	public var name : String;
	public var instance : Object;
	public var initial : Number;
	public var change : Number;
	private var _target : Number;

	public function set target(num : *) : void {
		if(num is String) {
			var values : Array = String(num).split(",");

			if(values.length == 1) {
				_target = instance[name] + parseFloat(num);
			} else {
				var start : Number = parseFloat(values[int(0)]), end : Number = parseFloat(values[int(1)]);
				_target = instance[name] + start + (Math.random() * (end - start));
			}
		} else {
			_target = num;
		}
			
		change = _target - initial;
	}

	public function get target() : Number {
		return _target;
	}

	public function dispose() : void {
		instance = null;
	}
}
