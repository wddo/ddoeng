package com.ddoeng.net
{
	import com.ddoeng.events.FONTLoaderEvent;
	import com.ddoeng.events.FONTLoaderProgressEvent;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.Font;
		
	/**
	 *
	 * @author : Cho Yun Gi (ddoeng@naver.com)
	 * @version : 1.0
	 * @since : Nov 17, 2010
	 * 
	 * 1. 클래스 설명
	 *		폰트로더
	 * 
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
	 * 		get name()			::: 폰트명 반환
	 * - 확장메소드
	 *		
	 */
	[ Event (name="fontloadProgress", type="com.ddoeng.events.FONTLoaderProgressEvent")]
	[ Event (name="fontloadComplete", type="com.ddoeng.events.FONTLoaderEvent")]
	public class FONTLoader extends EventDispatcher
	{
		private var _loader:Loader;		//로더
		private var _fontName:String;	//폰트명
		private var _className:String;	//클래스명
		private var _percent:Number;	//로드 퍼센트

		public function FONTLoader()
		{			
			_loader = new Loader();
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//리스너/////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function onProgress(e:ProgressEvent):void
		{
			_percent = Math.floor((e.bytesLoaded / e.bytesTotal) * 100);
			var evt:FONTLoaderProgressEvent = new FONTLoaderProgressEvent(FONTLoaderProgressEvent.FONTLOAD_PROGRESS, _percent);
			this.dispatchEvent( evt );
		}
		
		private function onComplete(e:Event):void
		{
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			e.currentTarget.removeEventListener(Event.COMPLETE, onComplete);
			
			Font.registerFont((e.target.applicationDomain.getDefinition(_className) as Class));
			
			//완료되었다고 이벤트 발생 (embed 되어있지 않은 텍스트필드들에게 embed 하라고 명령 내릴수있다.)
			var evt:FONTLoaderEvent = new FONTLoaderEvent(FONTLoaderEvent.FONTLOAD_COMPLETE);
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
		 * 폰트명의 공백, '-', '_'을 삭제한 이름이 swf 파일이름으로 하여야한다.
		 * swf파일명과 안에 폰트 클래스명이 같아야한다.
		 * 폰트명:Yoon YGO 550_TT  =>  파일명:YoonYGO550TT.swf => 폰트 클래스명: YoonYGO550TT
		 * @param fontFileName  ::: 폰트swf파일명
		 * @param assetPath 	::: 폰트swf가 들어있는 경로
		 */
		public function load($fontFileName:String = null, $assetPath:String = "assets/"):void
		{
			try{
				//인자가 넘어오고 로드중이 아니라면 로드 하라
				if($fontFileName != null && 0 == _loader.contentLoaderInfo.bytesLoaded){
					_fontName = $fontFileName;
					_className = _fontName;
					_percent = 0;
					
					//로드하려는 폰트가 등록이 되었는지 체크
					if(!ApplicationDomain.currentDomain.hasDefinition(_className)){
						//현제도메인에 로드
						var loaderContext:LoaderContext = new LoaderContext();
						loaderContext.applicationDomain = ApplicationDomain.currentDomain;
						
						_loader.load(new URLRequest($assetPath + _className + ".swf"), loaderContext);
						_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
						_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
						_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
					}
				}
			}catch(e:Error){
				trace(e.message + "::: loader가 del()에 의해 삭제되었을 수 있습니다.");
			}
		}
		
		/**
		 * 로더 삭제
		 */
		public function del():void
		{
			if(_loader != null){
				if(_loader.content == null)_loader.close(); //로드가 완료되지 않은 상황이면 닫기
				if(_loader.content != null)_loader.unload();
				if(_loader.contentLoaderInfo.hasEventListener(ProgressEvent.PROGRESS))_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
				if(_loader.contentLoaderInfo.hasEventListener(Event.COMPLETE))_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
				if(_loader.contentLoaderInfo.hasEventListener(IOErrorEvent.IO_ERROR))_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
				
				_loader = null;
			}
		}
		
		/**
		 * 폰트명 반환
		 */
		public function get name():String
		{
			return _fontName;
		}
	}
}