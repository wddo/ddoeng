package com.ddoeng.net
{
	import com.ddoeng.events.XMLLoaderEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 *
	 * @author : Cho Yun Gi (ddoeng@naver.com)
	 * @version : 1.0
	 * @since : Nov 17, 2010
	 * 
	 * 1. 클래스 설명
	 *		XML 로더
	 * 2. 메소드
	 * - 리스너
	 * 		onComplete()	::: 로드완료시
	 * 		ioError()		::: io오류시
	 * - 내부메소드
	 * 
	 * - 외부메소드
	 * 		load()			:::	로드 시작
	 * - 확장메소드
	 *		
	 */
	
	[ Event ( name="loadxmlComplete", type="com.ddoeng.events.XMLLoaderEvent") ]
	public class XMLLoader extends EventDispatcher
	{
		private var _urlLoader:URLLoader;	//URL로더
		private var _url:String;			//xml파일경로
		
		public function XMLLoader()
		{
			_urlLoader = new URLLoader();
			_urlLoader.addEventListener(Event.COMPLETE, onComplete);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioError);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//리스너/////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function onComplete(e:Event):void
		{
			var xml:XML = new XML( _urlLoader.data );
			var evt:XMLLoaderEvent = new XMLLoaderEvent(XMLLoaderEvent.LOADXML_COMPLETE, xml, _url);
			this.dispatchEvent( evt );
		}
		
		private function ioError(e:IOErrorEvent):void
		{
			trace(e.text);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//외부메소드//////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * 로드 시작
		 * @param $url	::: 로드할 url
		 */
		public function load($url:String):void
		{
			_urlLoader.load( new URLRequest( $url ) );
			_url = $url;
		}	
	}
}