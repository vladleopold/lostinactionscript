﻿package com.flashdynamix.motion.easing {	public class CustomEasing {		public static function precalced(t : Number,b : Number,c : Number,d : Number, ...pl : Array) : Number {			return b + c * pl[Math.round(t / d * pl.length)];		}		public static function curve(t : Number,b : Number,c : Number,d : Number, ...pl : Array) : Number {			var r : Number = 200 * t / d;			var i : Number = -1;			var e : Object;						while (pl[++i].Mx <= r) e = pl[i];						var Px : Number = e.Px;			var Py : Number = e.Py;			var Nx : Number = e.Nx;			var Ny : Number = e.Ny;			var Mx : Number = e.Mx;			var My : Number = e.My;						var s : Number = (Px == 0) ? -(Mx - r) / Nx : (-Nx + Math.sqrt(Nx * Nx - 4 * Px * (Mx - r))) / (2 * Px);						return (b - c * ((My + Ny * s + Py * s * s) / 200));		}	}}