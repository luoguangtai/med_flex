package com.anychart.flash9.events {
	import flash.events.Event;
	
	public class ValueChangeEvent extends Event {
		
		public static const VALUE_CHANGE:String = "valueChange";
		
		private var _params:Object;
		public function get params():Object { return this._params; }
		
		public function ValueChangeEvent(type:String, params:Object) {
			this._params = params;
			super(type);
		}
		
		override public function clone():Event {
			var e:Event = new ValueChangeEvent(super.type, this._params);
			return e;
		}

	}
}