package com.anychart.flash9.zoom {
	public final class DataZoomSettings {
		public static const RANGE_UNIT_YEAR:String = "year";
		public static const RANGE_UNIT_MONTH:String = "month";
		public static const RANGE_UNIT_DAY:String = "day";
		public static const RANGE_UNIT_HOUR:String = "hour";
		public static const RANGE_UNIT_MINUTE:String = "minute";
		public static const RANGE_UNIT_SECOND:String = "second";
		
		public var start:Number = NaN;
		public var end:Number = NaN;
		public var range:Number = NaN;
		public var rangeUnit:String = null;
	}
}