package com.ddoeng.net
{
	import com.ddoeng.events.SWFLoaderEvent;
	import com.ddoeng.events.SWFLoaderProgressEvent;
	import com.ddoeng.utils.Common;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	/**
	 *
	 * @author : Cho Yun Gi (ddoeng@naver.com)
	 * @version : 1.0
	 * @since : Nov 17, 2010
	 * 
	 * 1. 클래스 설명
	 *		SWF로더
	 * 2. 메소드
	 * - 리스너
	 * 		onProgress()		::: 로딩중
	 * 		onComplete()		::: 로드완료
	 * 		ioError()			:::	io오류
	 * - 내부메소드
	 * 
	 * - 외부메소드
	 * 		load()				::: 로드
	 * 		del()				::: 삭제
	 * 		setget x()			::: X 좌표 지정,반환
	 * 		setget y()			::: Y 좌표 지정,반환
	 * - 확장메소드
	 *		
	 */
	
	[ Event (name="loadswfProgress", type="com.ddoeng.events.SWFLoaderProgressEvent")]
	[ Event (name="loadswfComplete", type="com.ddoeng.events.SWFLoaderEvent")]
	public class SWFLoader extends EventDispatcher
	{
		private var _loader:Loader;						//로더
		private var _url:String;						//로드할 swf 경로
		private var _target:DisplayObjectContainer;		//로드해서 붙여놓을 컨테이너
		private var _clear:Boolean;						//컨테이너속 비울지 유무
		private var _loaderContext:LoaderContext;		//로더컨텍스트
		private var _percent:Number;					//로드중 퍼센트
		
		public function SWFLoader()
		{
			//현제도메인에 로드
			_loaderContext = new LoaderContext();
			_loaderContext.applicationDomain = ApplicationDomain.currentDomain;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//리스너/////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		//로드 진행중
		private function onProgress(e:ProgressEvent):void
		{
			_percent = Math.floor((e.bytesLoaded / e.bytesTotal) * 100);
			var evt:SWFLoaderProgressEvent = new SWFLoaderProgressEvent(SWFLoaderProgressEvent.LOADSWF_PROGRESS, _percent);
			this.dispatchEvent( evt );
		}
		
		//로드 완료
		private function onComplete(e:Event):void
		{
			//타겟 모두비움
			if(_clear){
				Common.setTargetClear(_target);
			}
			
			//로더add
			_target.addChild(_loader);
			
			var evt:SWFLoaderEvent = new SWFLoaderEvent(SWFLoaderEvent.LOADSWF_COMPLETE, e.target, _url);
			this.dispatchEvent( evt );
			
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
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
		 * @param $target	::: swf담을 타겟
		 * @param $url		::: swf 경로
		 * @param $clear	::: 타겟을 비울지 여부
		 */
		public function load($target:DisplayObjectContainer, $url:String, $clear:Boolean=false):void
		{
			_target = $target;
			_url = $url;
			_clear = $clear;
			_percent = 0;
			
			//중복로딩을 막음
			//del();
			
			//로더생성
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			_loader.load(new URLRequest(_url), _loaderContext);
		}
		
		/**
		 * 로더 삭제
		 */
		public function del():void
		{
			if(_loader != null){
				if(_loader.content == null && _loader.contentLoaderInfo.bytesLoaded > 0)_loader.close();//로드가 완료되지 않은 상황이면 닫기
				if(_loader.content != null)_loader.unload();
				if(_loader.contentLoaderInfo.hasEventListener(ProgressEvent.PROGRESS))_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
				if(_loader.contentLoaderInfo.hasEventListener(Event.COMPLETE))_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
				if(_loader.contentLoaderInfo.hasEventListener(IOErrorEvent.IO_ERROR))_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
				
				_loader = null;
			}
		}
		
		/**
		 * X 좌표 지정,반환
		 */		
		public function set x(n:Number):void
		{
			_loader.x = n;
		}
		public function get x():Number
		{
			return _loader.x;
		}
		
		/**
		 * Y 좌표 지정,반환
		 */		
		public function set y(n:Number):void
		{
			_loader.y = n;
		}
		public function get y():Number
		{
			return _loader.y;
		}
	}
}