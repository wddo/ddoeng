package com.ddoeng.net
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import com.ddoeng.events.net.XMLLoaderEvent;
	import com.ddoeng.events.net.XMLLoaderProgressEvent;
	
	[Event (name="loadxmlComplete", type="com.ddoeng.events.net.XMLLoaderEvent")]
	
	/**
	 *
	 * XML 로더	
	 * 
	 * @author : Jo Yun Ki (naver ID - ddoeng)
	 * @version : 1.0
	 * @since : Nov 17, 2010
	 * 
	 */
	
	public class XMLLoader extends EventDispatcher
	{
		private var _loader:URLLoader;	//URL로더
		private var _url:String;		//xml파일경로
		private var _percent:Number;	//로드중 퍼센트
		
		public function XMLLoader()
		{
			_loader = new URLLoader();
			_loader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			_loader.addEventListener(Event.COMPLETE, onComplete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, ioError);
		}
		
		//로드 진행중
		protected function onProgress(e:ProgressEvent):void
		{
			_percent = Math.floor((e.bytesLoaded / e.bytesTotal) * 100);
			var evt:XMLLoaderProgressEvent = new XMLLoaderProgressEvent(XMLLoaderProgressEvent.LOADXML_PROGRESS, _percent);
			this.dispatchEvent( evt );
		}
		
		//로드 완료
		private function onComplete(e:Event):void
		{
			var xml:XML = new XML( _loader.data );
			var evt:XMLLoaderEvent = new XMLLoaderEvent(XMLLoaderEvent.LOADXML_COMPLETE, xml, _url);
			this.dispatchEvent( evt );
		}
		
		private function ioError(e:IOErrorEvent):void
		{
			trace(e.text);
		}
		
		/**
		 * 로드 시작
		 * @param $url	::: 로드할 url
		 */
		public function load($url:String):void
		{
			try{
				_loader.load( new URLRequest( $url ) );
				_url = $url;
			}catch(e:Error){
				trace(e.message + "::: loader가 dispose()에 의해 삭제되었을 수 있습니다.");
			}
		}

		/**
		 * 파괴 
		 */		
		public function dispose():void
		{
			if(_loader != null){
				if(_loader.hasEventListener(ProgressEvent.PROGRESS))_loader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
				if(_loader.hasEventListener(Event.COMPLETE))_loader.removeEventListener(Event.COMPLETE, onComplete);
				if(_loader.hasEventListener(IOErrorEvent.IO_ERROR))_loader.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
				
				_loader = null;
			}
		}
	}
}