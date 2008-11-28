package com.flashdynamix.motion.paths {
	import flash.geom.Point;	

	/**
	 * @author FlashDynamix
	 * This allows for items to floow motions along bezier curves
	 */
	public class Bezier {

		public var item : Object;
		public var pts : Array;
		public var rotate : Boolean;
		public var through : Boolean;
		public var movingPts : Boolean;

		private var curve : Array;
		private var _scalar : Number = 0;

		public function Bezier(item : Object, through : Boolean = false, rotate : Boolean = false, movingPts : Boolean = false, ...pts : Array) {
			this.item = item;
			this.pts = pts;
			this.through = through;
			this.rotate = rotate;
			this.movingPts = movingPts;
			
			update();
		}

		public function index(idx : int) : Point {
			return pts[idx];
		}

		public function push(pt : Point) : void {
			pts.push(pt);
			update();
		}

		public function addAt(idx : int, pt : Point) : void {
			pts.splice(idx, 0, pt);
			update();
		}

		public function remove(pt : Point) : void {
			var index : int = pts.indexOf(pt);
			if(index != -1) removeAt(index, 1);
		}

		public function removeAt(idx : int, len : int = 1) : void {
			pts.splice(idx, len);
			update();
		}

		public function get length() : int {
			return pts.length;
		}

		public function set scalar(num : Number) : void {
			_scalar = num;
			
			if(movingPts) update();
			
			var max : int = curve.length - 3;
			var steps : int = (curve.length - 1) / 2;
			var idx : Number = num * steps;
			var inc : Number = idx - int(idx);
			var start : int = int(idx) * 2;
			if(start > max) {
				inc = 1;
				start = max;
			}
			
			var sPt : Point = curve[start];
			var cPt : Point = curve[start + 1];
			var ePt : Point = curve[start + 2];
		
			var pt : Point = new Point(quadratic(inc, sPt.x, cPt.x, ePt.x), quadratic(inc, sPt.y, cPt.y, ePt.y));
			item.x = pt.x;
			item.y = pt.y;
		
			if(rotate && item.hasOwnProperty("rotation")) item.rotation = angle(inc, sPt, cPt, ePt);
		}

		public function get scalar() : Number {
			return _scalar;
		}

		public function update() : void {
			if(pts.length <= 2) return;
			
			if(through) {
				var pt : Point = pts[int(0)];
				var cPt : Point;
			
				curve = [];
				curve.push(pt);
				
				cPt = index(2).subtract(pt);
				cPt.x /= 4;
				cPt.y /= 4;
				cPt = index(1).subtract(cPt);
				
				pt = index(1);
				
				curve.push(cPt);
				curve.push(pt);
				
				var len : int = pts.length - 1;
				for(var i : int = 1;i < len; i++) {
					cPt = index(i).add(index(i).subtract(cPt));
					pt = index(i + 1);
					
					curve.push(cPt);
					curve.push(pt);
				}
			} else {
				curve = pts;
			}
		}

		private function angle(t : Number, pt1 : Point, pt2 : Point, pt3 : Point) : Number {
			return (Math.atan2(derivative(t, pt1.y, pt2.y, pt3.y), derivative(t, pt1.x, pt2.x, pt3.x)));
		}

		private function quadratic(t : Number,a : Number,b : Number,c : Number) : Number {
			return a + t * (2 * (1 - t) * (b - a) + t * (c - a));
		}

		private function derivative(t : Number, a : Number, b : Number, c : Number) : Number {
			return 2 * a * (t - 1) + 2 * b * (1 - 2 * t) + 2 * c * t;
		}
	}
}
