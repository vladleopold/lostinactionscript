package com.flashdynamix.motion.paths {	import flash.display.DisplayObject;		/**	 * @author shanem	 */	public class Direction {		public var item : DisplayObject;		private var sx : Number;		private var sy : Number;		private var _angle : Number;		private var _distance : Number;		private var _position : Number = 0;		private var cr : Number;		private var sr : Number;		private var degreeRad : Number = Math.PI / 180;		public function Direction(item : DisplayObject, angle : *, distance : *, startDistance : * = 0) : void {			this.item = item;						_angle = translate(angle) * degreeRad;			_distance = translate(distance);						cr = Math.cos(_angle);			sr = Math.sin(_angle);						var sd : Number = translate(startDistance);			item.x += cr * sd;			item.x += sr * sd;						sx = item.x;			sy = item.y;		}		public function set position(num : Number) : void {			_position = num;			update();		}		public function get position() : Number {			return _position;		}		public function set angle(rads : Number) : void {			_angle = rads;			cr = Math.cos(_angle);			sr = Math.sin(_angle);			update();		}		public function get angle() : Number {			return _angle;		}		public function set distance(num : Number) : void {			_distance = num;			update();		}		public function get distance() : Number {			return _distance;		}		private function translate(num : *) : Number {						if(num is String) {				var values : Array = String(num).split(",");				if(values.length == 1) {					return parseFloat(num);				} else {					var start : Number = parseFloat(values[0]), end : Number = parseFloat(values[1]);					return start + (Math.random() * (end - start));				}			} else {				return num;			}		}		private function update() : void {			var dist : Number = (distance * position);			item.x = sx + (cr * dist);			item.y = sy + (sr * dist);		}	}}