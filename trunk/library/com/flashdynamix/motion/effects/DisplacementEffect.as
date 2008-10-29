﻿package com.flashdynamix.motion.effects {	import flash.display.*;	import flash.filters.*;	import flash.geom.*;	import com.flashdynamix.motion.effects.IEffect;		/**	 * @author shanem	 */	public class DisplacementEffect extends FilterEffect implements IEffect {		public var mapBmd : BitmapData;		public var mapPoint : Point;		function DisplacementEffect(mapBmd : BitmapData, scaleX : Number = 3, scaleY : Number = 3, componentX : uint = 1, componentY : uint = 1, mode : String = "clamp", mapPoint : Point = null, color : uint = 0, alpha : uint = 0) {			this.mapBmd = mapBmd;			this.mapPoint = (mapPoint == null) ? new Point() : mapPoint;						super(new DisplacementMapFilter(mapBmd, mapPoint, componentX, componentY, scaleX, scaleY, mode, color, alpha));		}		override public function render(bmd : BitmapData) : void {			DisplacementMapFilter(filter).mapPoint = mapPoint;			super.render(bmd);		}	}}