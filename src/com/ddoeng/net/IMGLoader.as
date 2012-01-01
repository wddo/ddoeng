package com.ddoeng.net
{
	import com.ddoeng.events.IMGLoaderEvent;
	import com.ddoeng.events.IMGLoaderProgressEvent;
	import com.ddoeng.utils.Calculation;
	import com.ddoeng.utils.Common;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	[Event (name="imageloadProgress", type="com.ddoeng.events.IMGLoaderProgressEvent")]
	[Event (name="imageloadComplete", type="com.ddoeng.events.IMGLoaderEvent")]

	/**
	 *
	 * 이미지 로더
	 * 
	 * @author : Jo Yun Ki (naver ID - ddoeng)
	 * @version : 1.0
	 * @since : Nov 17, 2010
	 * 
	 */
	
	public class IMGLoader extends EventDispatcher
	{
		private var _loader:Loader;					//로더
		private var _url:Array;						//이미지 파일경로 배열
		private var _target:Array;					//이미지를 로드할 컨테이너
		private var _loaderArr:Array;				//로더 배열
		
		private var _isAdd:Boolean;					//로드와 동시에 붙여넣을것인가 유무
		private var _clear:Boolean;					//컨테이너를 비울것인가 유무
		
		private var _maxNum:int = 0;				//다중로드시 총갯수
		private var _count:int = 0;					//다용도 카운터
		
		private var _width:Number = 0;				//넓이
		private var _height:Number = 0;				//높이
		private var _smooth:Boolean = false;		//스무스를 할지 유무
		
		private var _loaderContext:LoaderContext;	//로더컨텍스트
		private var _percent:Number;				//로드중 퍼센트
		
		/**
		 * 
		 * @param $add        ::: addChild할것인지
		 * @param $clear      ::: target을 모두 비우고 addChild 할것인지
		 * @param $maxnum     ::: 한번에 몇개를 로드할것인가, 기본값이면 배열길이 참조
		 * 
		 */		
		public function IMGLoader($add:Boolean, $clear:Boolean, $maxnum:int=0)
		{
			_isAdd = $add;
			_clear = $clear;
			_maxNum = $maxnum;
			
			//현제도메인에 로드
			_loaderContext = new LoaderContext();
			_loaderContext.applicationDomain = ApplicationDomain.currentDomain;
		}

		private function onProgress(e:ProgressEvent):void
		{
			_percent = Math.floor((e.bytesLoaded / e.bytesTotal) * 100);
			var evt:IMGLoaderProgressEvent = new IMGLoaderProgressEvent(IMGLoaderProgressEvent.IMAGELOAD_PROGRESS, _percent);
			this.dispatchEvent( evt );
		}
		
		private function onComplete(e:Event):void
		{	
			var loader:DynamicLoader = e.currentTarget.loader as DynamicLoader;
			var id:int;
			
			//타겟이 여러개이면
			if(_target.length > 1){
				id = loader.getId();
			}else{//타겟이 하나이면
				id = 0;
			}
			
			//이미지 리사이징
			if(_width != 0 && _height != 0){
				var bitmap:Bitmap = e.currentTarget.content;
				
				var cal:Calculation = new Calculation();
				var xs:Number = cal.getLinearFunction(0, bitmap.width, 0, 1, _width);
				var ys:Number = cal.getLinearFunction(0, bitmap.height, 0, 1, _height);
				
				var matrix:Matrix = new Matrix();
				matrix.scale(xs, ys);
				
				bitmap.smoothing = _smooth;
				bitmap.transform.matrix = matrix;
			}
			
			//타겟 모두비움
			if(_clear){
				Common.setTargetClear(_target[id]);		
			}
			
			//로더add
			if(_isAdd){
				_target[id].addChild(loader);
			}
			
			_count++;
			
			var evt:IMGLoaderEvent = new IMGLoaderEvent(IMGLoaderEvent.IMAGELOAD_COMPLETE, _target, loader);
			
			if(_maxNum == _count){
				evt = new IMGLoaderEvent(IMGLoaderEvent.IMAGELOAD_COMPLETE, _target, loader,  true);
			}
			
			this.dispatchEvent( evt );
		}
		
		private function ioError(e:IOErrorEvent):void
		{
			trace(e.text);
		}

		/**
		 * 로드 시작
		 * @param $target	::: 이미지를 포함시킬 배열
		 * @param $url		::: 이미지 경로
		 * @param $width	::: 이미지 넓이 (넓이나 높이 하나라도 0 이면 리사이징 적용안됨)
		 * @param $height	::: 이미지 높이
		 * @param $smooth	::: 부드럽게
		 */		
		public function load($target:Array, $url:Array, $width:Number=0, $height:Number=0, $smooth:Boolean=false):void
		{
			try{
				_target = $target;
				_url = $url;
	
				_width = $width;
				_height = $height;
				_smooth = $smooth;
				
				_loaderArr = new Array();
				
				//아무것도 안들어오면 자동을 들어온 url 갯수를 참조
				if(_maxNum == 0){
					_maxNum = _url.length;
				}
				
				for(var i:int = 0; i < _maxNum; i++){
					var loader:DynamicLoader = new DynamicLoader();
					loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
					loader.load(new URLRequest(_url[i]), _loaderContext);
					loader.setId(i);
					
					_loaderArr.push(loader);
				}
			}catch(e:Error){
				trace(e.message + "::: loader가 dispose()에 의해 삭제되었을 수 있습니다.");
			}
		}
		
		/**
		 * 로더배열에 있는 로더 삭제
		 * @param index		::: 로더배열 인덱스
		 * 
		 */		
		public function del(index:int):void
		{
			var loader:DynamicLoader = _loaderArr[index] as DynamicLoader;

			if(loader != null){
				if(loader.content == null && loader.contentLoaderInfo.bytesLoaded > 0)loader.close();//로드가 완료되지 않은 상황이면 닫기
				if(loader.content != null)loader.unload();
				if(loader.contentLoaderInfo.hasEventListener(ProgressEvent.PROGRESS))loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
				if(loader.contentLoaderInfo.hasEventListener(Event.COMPLETE))loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
				if(loader.contentLoaderInfo.hasEventListener(IOErrorEvent.IO_ERROR))loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
				
				loader = null;
			}
		}
		
		/**
		 * 로더 배열 반환
		 * @return 		::: 로더배열
		 * 
		 */		
		public function getLoaderArr():Array
		{
			return _loaderArr
		}
	}
}