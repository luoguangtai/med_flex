package com.anychart.flash9 {
	
	import com.anychart.flash9.events.AnyChartPointEvent;
	import com.anychart.flash9.events.EngineEvent;
	import com.anychart.flash9.events.ValueChangeEvent;
	import com.anychart.flash9.zoom.DataZoomSettings;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	
	import hc.util.Util;
	
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.core.FlexSprite;
	import mx.core.UIComponent;
	


	[Event(name="anychartCreate", type="com.anychart.flash9.events.EngineEvent")]
	[Event(name="anychartRender", type="com.anychart.flash9.events.EngineEvent")]
	[Event(name="anychartDraw", type="com.anychart.flash9.events.EngineEvent")]
	[Event(name="dashboardViewRender", type="com.anychart.flash9.events.DashboardEvent")]
	[Event(name="dashboardViewDraw", type="com.anychart.flash9.events.DashboardEvent")]
	[Event(name="pointClick", type="com.anychart.flash9.events.AnyChartPointEvent")]
	[Event(name="pointMouseOver", type="com.anychart.flash9.events.AnyChartPointEvent")]
	[Event(name="pointMouseOut", type="com.anychart.flash9.events.AnyChartPointEvent")]
	[Event(name="pointMouseDown", type="com.anychart.flash9.events.AnyChartPointEvent")]
	[Event(name="pointMouseUp", type="com.anychart.flash9.events.AnyChartPointEvent")]
	[Event(name="pointSelect", type="com.anychart.flash9.events.AnyChartPointEvent")]
	[Event(name="pointDeselect", type="com.anychart.flash9.events.AnyChartPointEvent")]
	[Event(name="valueChange", type="com.anychart.flash9.events.ValueChangeEvent")]
	public class AnyChart extends UIComponent {
		//Sprite
		private static const F_XML_FILE:String = "xmlFile";
		private static const F_INIT_MESSAGE:String = "messageOnInitialize";
		private static const F_LOADING_XML_MESSAGE:String = "messageOnLoadingXML";
		private static const F_LOADING_RESOURCES_MESSAGE:String = "messageOnLoadingResources";
		private static const F_NO_DATA_MESSAGE:String = "messageNoData";
		private static const F_WAITING_FOR_DATA_MESSAGE:String = "messageOnWaitingForData";
		private static const F_LOADING_TEMPLATES_MESSAGE:String = "messageOnLoadingTemplates";
		
		private static const M_SET_XML:String = "setXMLData";
		private static const M_SET_XML_FILE:String = "setXMLFile";
		private static const M_UPDATE_POINT_DATA:String = "updatePointData";
		private static const M_SET_FIXED_SIZE:String = "setFixedSize";
		private static const M_RESIZE:String = "resize";
		private static const M_INIT_ENGINE:String = "initEngine";
		private static const M_CREATE_ENGINE:String = "createEngine";
		private static const M_SET_XML_FILE_CACHE_ENABLED:String = "setXMLFileCacheEnabled";
		
		//=======================================================
		//			ANYCHART.SWF LOADING						
		//=======================================================

		public static var enginePath:String = 'flex/com/anychart/swf/AnyChart.swf';
		
		//-- binary engine loading
		private static var _engineBinary:ByteArray;
		
		private static var _isLoading:Boolean = false;
		
		public static function loadEngine(path:String = null):void {
			try{
				if (_isLoading || _isCreatingProcess) 
					return;
				if (path != null)
					enginePath = path;
								
				var loader:URLLoader = new URLLoader();
				loader.dataFormat = URLLoaderDataFormat.BINARY;
				
				loader.addEventListener(Event.COMPLETE, engineLoadHandler);
				_isLoading = true;
				loader.load(new URLRequest(enginePath));
			}catch(err:Error){
				Util.debug(err.message)
			}
		}
		
		private static function engineLoadHandler(e:Event):void {
			_engineBinary = ByteArray(URLLoader(e.target).data);
			_isLoading = false;
			createNextInstance();
		}
		
		private static var _creatingTargets:Array = new Array();
		private static var _isCreatingProcess:Boolean = false;
		
		private static function createNextInstance():void {
			if (!_isLoading && _creatingTargets.length > 0 && !_isCreatingProcess)
			loadEngineInstance(AnyChart(_creatingTargets.pop()));
		}
		
		private static function createEngineInstance(target:AnyChart):void {
			if (_engineBinary == null && !_isLoading)
				loadEngine();

			_creatingTargets.push(target);
			createNextInstance();
		}
		
		private static var currentContainer:AnyChart;
		
		private static function loadEngineInstance(container:AnyChart):void {
			currentContainer = container;
			var loader:Loader = new Loader();
			_isCreatingProcess = true;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,binaryLoadHandler);
			loader.loadBytes(_engineBinary);
		}
		
		private static function binaryLoadHandler(event:Event):void {
			currentContainer.onEngineLoad(LoaderInfo(event.target).loader);
			_isCreatingProcess = false;
			createNextInstance();
		}

		//=======================================================
		//			Interface for AnyChart.swf						
		//=======================================================
		
		private var engineDomain:ApplicationDomain;
		private var chart:DisplayObject;
		private var isChartCreated:Boolean;
		
		public function AnyChart(){
			super();
			_width = 550;
			_height = 400;
			this.isChartCreated = false;
			createEngineInstance(this);
		}
		
		//-----------------------------
		// chart size
		//-----------------------------
		
		private var _width:Number;
		private var _height:Number;
		
		public function set chartWidth(value:Number):void {
			this._width = value;
			this.updateChartSize();
		}
		public function get chartWidth():Number { return this._width; }
		
		public function set chartHeight(value:Number):void {
			this._height = value;
			this.updateChartSize();
		}
		public function get chartHeight():Number { return this._height; }
		
		private function updateChartSize():void {
			if (!this.chart) return;
			this.chart[M_SET_FIXED_SIZE](this._width, this._height);
			if (this.isChartCreated)
				this.chart[M_RESIZE](this._width, this._height);
		}
		
		//-----------------------------
		// chart creation
		//-----------------------------
		
		private function onEngineLoad(loader:Loader):void {
			var content:DisplayObject = loader.contentLoaderInfo.content;
			this.chart = this.addChild(content);
			this.initEvents();
			this.updateChartSize();
			this.chart[M_INIT_ENGINE]();
			if (this._messageOnInitialize != null) this.messageOnInitialize = this._messageOnInitialize;
			if (this._messageOnLoadingXML !=null) this.messageOnLoadingXML = this._messageOnLoadingXML;
			if (this._messageOnLoadingTemplates !=null) this.messageOnLoadingTemplates = this._messageOnLoadingTemplates;
			if (this._messageOnWaitingForData !=null) this.messageOnWaitingForData = this._messageOnWaitingForData;
			if (this._messageNoData !=null) this.messageNoData = this._messageNoData;
			if (this._messageOnLoadingResources !=null) this.messageOnLoadingResources = this._messageOnLoadingResources;
			if (this._enableCache)
				this.enableXMLCache();
			else
				this.disableXMLCache();
			if (xmlPath != null) this.chart[F_XML_FILE] = xmlPath;
			this.chart[M_CREATE_ENGINE](this, null);
			this.isChartCreated = true;
		}
		
		//-----------------------------
		// events
		//-----------------------------
		
		private function initEvents():void {
			this.chart.addEventListener(EngineEvent.ANYCHART_CREATE, this.redirectEngineEvent);
			this.chart.addEventListener(EngineEvent.ANYCHART_DRAW, this.redirectEngineEvent);
			this.chart.addEventListener(EngineEvent.ANYCHART_RENDER, this.redirectEngineEvent);
			
			this.chart.addEventListener(ValueChangeEvent.VALUE_CHANGE, this.redirectValueChangeEvent);
			
			this.chart.addEventListener(AnyChartPointEvent.CLICK, this.redirectPointEvent);
			this.chart.addEventListener(AnyChartPointEvent.DESELECT, this.redirectPointEvent);
			this.chart.addEventListener(AnyChartPointEvent.MOUSE_DOWN, this.redirectPointEvent);
			this.chart.addEventListener(AnyChartPointEvent.MOUSE_OUT, this.redirectPointEvent);
			this.chart.addEventListener(AnyChartPointEvent.MOUSE_OVER, this.redirectPointEvent);
			this.chart.addEventListener(AnyChartPointEvent.MOUSE_UP, this.redirectPointEvent);
			this.chart.addEventListener(AnyChartPointEvent.SELECT, this.redirectPointEvent);
		}
		
		private function redirectPointEvent(e:Event):void {
			e.stopImmediatePropagation();
			e.stopPropagation();
			this.dispatchEvent(new AnyChartPointEvent(e.type, e["point"]));
		}
		
		private function redirectValueChangeEvent(e:Event):void {
			e.stopImmediatePropagation();
			e.stopPropagation();
			this.dispatchEvent(new ValueChangeEvent(e.type, e["params"]));
		}
		
		private function redirectEngineEvent(e:Event):void {
			e.stopImmediatePropagation();
			e.stopPropagation();
			this.dispatchEvent(new EngineEvent(e.type));
		}
		
		//-----------------------------
		// Properties
		//-----------------------------
		
		private var _messageOnInitialize:String = null;
		public function set messageOnInitialize(value:String):void {
			if (this.chart) this.chart[F_INIT_MESSAGE] = value;
			else			this._messageOnInitialize = value; 
		}
		public function get messageOnInitialize():String { return this.chart ? this.chart[F_INIT_MESSAGE] : this._messageOnInitialize; }
		
		private var _messageOnLoadingXML:String=null;
		public function set messageOnLoadingXML(value:String):void {
			if (this.chart) this.chart[F_LOADING_XML_MESSAGE] = value;
			else 			this._messageOnLoadingXML = value
		}
		public function get messageOnLoadingXML():String { return this.chart ? this.chart[F_LOADING_XML_MESSAGE] : this._messageOnLoadingXML; }
		
		private var _messageOnLoadingResources:String = null;
		public function set messageOnLoadingResources(value:String):void {
			if (this.chart) this.chart[F_LOADING_RESOURCES_MESSAGE] = value;
			else 			this._messageOnLoadingResources = value;
		}
		public function get messageOnLoadingResources():String { return this.chart ? this.chart[F_LOADING_RESOURCES_MESSAGE] : this._messageOnLoadingResources; }
		
		private var _messageNoData: String = null;
		public function set messageNoData(value:String):void {
			if (this.chart) this.chart[F_NO_DATA_MESSAGE] = value;
			else			this._messageNoData = value;
		}
		public function get messageNoData():String { return this.chart ? this.chart[F_NO_DATA_MESSAGE] : this._messageNoData; }
		
		private var _messageOnWaitingForData:String = null;
		public function set messageOnWaitingForData(value:String):void {
			if (this.chart) this.chart[F_WAITING_FOR_DATA_MESSAGE] = value;
			else 			this._messageOnWaitingForData = value;
		}
		public function get messageOnWaitingForData():String { return this.chart ? this.chart[F_WAITING_FOR_DATA_MESSAGE] : this._messageOnWaitingForData; }
		
		private var _messageOnLoadingTemplates:String = null;
		public function set messageOnLoadingTemplates(value:String):void {
			if (this.chart) this.chart[F_LOADING_TEMPLATES_MESSAGE] = value;
			else 			this._messageOnLoadingTemplates = value;
		}
		public function get messageOnLoadingTemplates():String { return this.chart ? this.chart[F_LOADING_TEMPLATES_MESSAGE] : this._messageOnLoadingTemplates; }
		
		//-----------------------------
		// Methods
		//-----------------------------
		
		public function setXMLData(rawData:XML, replaces:Array=null):void { if (this.chart)	this.chart[M_SET_XML](rawData.toXMLString(),replaces); }
		
		public function setXMLString(rawData:String):void { if (this.chart)	this.chart[M_SET_XML](rawData,null); }
		
		private var xmlPath:String;
		public function setXMLFile(path:String, replaces:Array=null):void {
			if (this.chart)	this.chart[M_SET_XML_FILE](path,replaces);
			else xmlPath = path;
		}
		
		public function updatePointData(groupName:String, pointName:String, data:Object):void {
			if (this.chart)	this.chart[M_UPDATE_POINT_DATA](groupName,pointName,data);
		}
		
		public function updatePointerData(gaugeName:String, pointerName:String, pointerValue:Number):void {
			if (this.chart)	this.chart[M_UPDATE_POINT_DATA](gaugeName, pointerName, {value: pointerValue});
		}
		
		public function updatePointerColor(gaugeName:String, pointerName:String, pointerColor:String):void {
			if (this.chart) this.chart[M_UPDATE_POINT_DATA](gaugeName, pointerName, {color: pointerColor});
		}
		
		private var _enableCache:Boolean = true;
		
		public function disableXMLCache():void {
			if (this.chart) this.chart[M_SET_XML_FILE_CACHE_ENABLED](false);
			else			this._enableCache = false;
		}
		
		public function enableXMLCache():void {
			if (this.chart) this.chart[M_SET_XML_FILE_CACHE_ENABLED](true);
			else			this._enableCache = true;
		}
		
		
		public function serialize():Object {
			if (this.chart) return  this.chart["serialize"]();
			else return null;
		}
		
		public function scrollXTo(xValue:Number):void {	if (this.chart)	this.chart["scrollXTo"](xValue); }
		public function scrollYTo(yValue:Number):void { if (this.chart)	this.chart["scrollYTo"](yValue); }
		public function scrollTo(xValue:Number,yValue:Number):void { if (this.chart)	this.chart["scrollTo"](xValue,yValue); }
		public function setXZoom(settings:DataZoomSettings):void { if (this.chart)	this.chart["setXZoom"](settings); }
		public function setYZoom(settings:DataZoomSettings):void { if (this.chart)	this.chart["setYZoom"](settings); }
		public function setZoom(xZoomSettings:DataZoomSettings, yZoomSettings:DataZoomSettings):void { if (this.chart)	this.chart["setZoom"](xZoomSettings,yZoomSettings); }
		public function getXScrollInfo():Object { 
			return (this.chart) ? this.convertInfo(this.chart["getXScrollInfo"]()) : null; 
		}
		
		public function getYScrollInfo():Object { 
			return (this.chart) ? this.convertInfo(this.chart["getYScrollInfo"]()) : null; 
		}
		
		private function convertInfo(info:Object):ScrollInfo {
			if (info == null) return null;
			var res:ScrollInfo = new ScrollInfo();
			res._start = info.start;
			res._range = info.range;
			return res;
		}

		public function addSeries(...seriesData):void {
			if (this.chart) {
				var seriesCnt:uint = seriesData.length;
				var stringSeries:Array = [];
				
				for (var i:uint = 0;i<seriesCnt;i++) {
					stringSeries.push(seriesData[i].toXMLString());
				}
				this.chart["addSeries"](stringSeries);
			}
		}
		
		public function removeSeries(seriesID:String):void{
			if (this.chart) this.chart["removeSeries"](seriesID);
		}
		
		public function updateSeries(seriesId:String, seriesData:XML):void {
			if (this.chart) this.chart["updateSeries"](seriesId,seriesData.toXMLString());
		}
		
		public function addSeriesAt(index:uint,seriesData:XML):void {
			if (this.chart) this.chart["addSeriesAt"](index,seriesData.toXMLString());
		}
		
		public function  showSeries(seriesId:String, isVisible:Boolean):void {
			if (this.chart) this.chart["showSeries"](seriesId,isVisible);
		}
		
		public function addPoint(seriesId:String,pointsData:XML):void {
			if (this.chart){
				this.chart["addPoint"](seriesId,pointsData.toXMLString());
			}
		}
		
		public function removePoint(seriesId:String, pointId:String):void {
			if (this.chart) this.chart["removePoint"](seriesId,pointId);
		}
		
		public function addPointAt(seriesId:String, index:uint, pointData:XML):void {
			if (this.chart)	this.chart["addPointAt"](seriesId,index,pointData.toXMLString());
		}
		
		public function updatePoint(seriesId:String, pointId:String, pointData:XML):void {
			if (this.chart)	this.chart["updatePoint"](seriesId,pointId,pointData.toXMLString());
		}		
		
		public function refresh():void {
			if (this.chart) this.chart["refresh"]();
		}
		
		public function clearChartData():void {
			if (this.chart) this.chart["clearChartData"]();
		}
		
		public function highlightSeries(seriesId:String, highlighted:Boolean):void {
			if (this.chart) this.chart["highlightSeries"](seriesId,highlighted);
		}
		
		public function highlightPoint(seriesId:String, pointId:String, highlighted:Boolean):void {
			 if (this.chart) this.chart["highlightPoint"](seriesId,pointId,highlighted);
		}
		
		public function highlightCategory(categoryName:String, highlighted:Boolean):void {
			if (this.chart) this.chart["highlightCategory"](categoryName,highlighted);
		}		
		
		public function selectPoint(seriesId:String, pointId:String, selected:Boolean):void {
			if (this.chart) this.chart["selectPoint"](seriesId,pointId,selected);
		}      
	}
}