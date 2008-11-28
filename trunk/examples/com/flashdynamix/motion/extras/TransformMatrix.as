package com.flashdynamix.motion.extras {
	import flash.display.DisplayObject;	import flash.geom.Matrix;	import flash.utils.Proxy;	import flash.utils.flash_proxy;	
	/**
	 * @author FlashDynamix
	 */
	public class TransformMatrix extends Proxy {
		public var item : DisplayObject;
		public var from : Matrix;
		public var to : Matrix;
		public var current : Matrix;
		private var _position : Number = 0;

		public function TransformMatrix(item : DisplayObject, to : Matrix, from : Matrix = null) {
			this.item = item;
			this.from = from;
			this.to = to;
			
			if(from != null) {
				this.from = from;
			} else {
				this.from = item.transform.matrix.clone();
			}
			
			if(to != null) {
				this.to = to;
			}else {
				this.to = new Matrix();
			}
			
			current = item.transform.matrix.clone();
		}

		public function set position(num : Number) : void {
			_position = num;
			var q : Number = 1 - position;
			
			current.a = from.a * q + to.a * position;
			current.b = from.b * q + to.b * position;
			current.c = from.c * q + to.c * position;
			current.d = from.d * q + to.d * position;
			current.tx = from.tx * q + to.tx * position;
			current.ty = from.ty * q + to.ty * position;
			
			item.transform.matrix = current;
		}

		public function get position() : Number {
			return _position;
		}

		override flash_proxy function setProperty(name : *, value : *) : void {
			current[name] = value;
			item.transform.matrix = current;
		}

		override flash_proxy function getProperty(name : *) : * {
			return current[name];
		}
	}
}
