package com.anychart.flash9.events {
	
	import flash.events.Event;
	
	
	public final class AnyChartPointEvent extends Event {
		
		public static const CLICK:String = "pointClick";
		public static const MOUSE_OVER:String = "pointMouseOver";
		public static const MOUSE_OUT:String = "pointMouseOut";
		public static const MOUSE_DOWN:String = "pointMouseDown";
		public static const MOUSE_UP:String = "pointMouseUp";
		public static const SELECT:String = "pointSelect";
		public static const DESELECT:String = "pointDeselect";
		
		public static function isPointEvent(type:String):Boolean {
			return type == CLICK || type == MOUSE_OVER || type == MOUSE_OUT || type == MOUSE_DOWN || type == MOUSE_UP || type == SELECT || type == DESELECT;
		}
		
		private var point:Object;
		private var pointData:Object;
		
		public function get pointName():String { return point.getTokenValue("%Name"); }
		public function get seriesName():String { return point.getTokenValue("%SeriesName"); }
		public function get x():Number { return Number(point.getTokenValue("%XValue")); }
		public function get y():Number { return Number(point.getTokenValue("%YValue")); }
		public function get high():Number { return Number(point.getTokenValue("%High")); }
		public function get low():Number { return Number(point.getTokenValue("%Low")); }
		public function get open():Number { return Number(point.getTokenValue("%Open")); }
		public function get close():Number { return Number(point.getTokenValue("%Close")); }
		public function get regionName():String { return point.getTokenValue("%REGION_N"); }
		public function get start():Number { return Number(point.getTokenValue("%Start")); }
		public function get end():Number { return Number(point.getTokenValue("%End")); }
		public function get size():Number { return Number(point.getTokenValue("%BubbleSize")); }
		
		public function get pointCustomAttributes():Object { return this.pointData.Attributes; }
		public function get seriesCustomAttributes():Object {
			try {
				if (this.point["series"])
					return this.point["series"].serialize().Attributes;
			}catch (e:Error) {}
			return null;
		}
		
		public function getTokenValue(name:String):String { 
			return point.getTokenValue("%"+name);
		}
		
		public function AnyChartPointEvent(type:String, point:Object) {
			this.point = point;
			this.pointData = point.serialize();
			super(type);
		}
		
		override public function toString():String {
			var res:String = "[AnyChartPointEvent (";
			res += "pontName: "+this.pointName;
			res += ", seriesName: "+this.seriesName;
			res += ", x: "+this.x;
			res += ", y: "+this.y;
			res += ", size: "+this.size;
			res += ", start: "+this.start;
			res += ", end: "+this.end;
			res += ", high: "+this.high;
			res += ", low: "+this.low;
			res += ", open: "+this.open;
			res += ", close: "+this.close;
			res += ")]";
			return res;
		}

	}
}