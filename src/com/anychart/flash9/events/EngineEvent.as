package com.anychart.flash9.events {
	
	import flash.events.Event;

	public final class EngineEvent extends Event {
		
		public static const ANYCHART_CREATE:String = "anychartCreate";
		public static const ANYCHART_DRAW:String = "anychartDraw";
		public static const ANYCHART_RENDER:String = "anychartRender";
		
		public function EngineEvent(type:String) {
			super(type);
		}
		
		override public function clone():Event {
			var e:Event = new EngineEvent(this.type);
			return e;
		}
	}
}