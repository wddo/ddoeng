package com.ddoeng.utils
{
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	
	/**
	 *
	 * 통신에 대한 클래스
	 * 
	 * @author : Jo Yun Ki (naver ID - ddoeng)
	 * @version : 1.0
	 * @since : Mar 7, 2011
	 * 
	 */
	
	public class NetUtil
	{	
		/**
		 * 스크립트나 링크 호출 
		 * @param $url		::: 링크주소
		 * @param $window	::: 타겟
		 */		
		public static function getURL($url:String, $target:String = "_blank"):void
		{
			if($url.indexOf("javascript:") != 0){
				if(SystemUtil.isBrowser()) navigateToURL(new URLRequest($url), $target);
				else trace(" getURL html : " + $url);
			}else{
				if(SystemUtil.isBrowser()) navigateToURL(new URLRequest($url), "_self");
				else trace(" getURL javascript : " + $url);
			}
		}
		
		/**
		 * 자바스크립트 호출 
		 * @param $jsFun	::: 함수명
		 * @param args		::: 메계변수
		 * @return 			::: 반환값
		 */		
		public static function call($jsFun:String, ... args):* {
			var isReturn:*;
			
			if(SystemUtil.isBrowser()){
				if(ExternalInterface.available) isReturn = ExternalInterface.call.apply(null, [$jsFun].concat(args));
			}else{
				trace("["+$jsFun+"] " + args);
			}
			
			return isReturn;
		}
		
		/**
		 * 외부에서 플래시로 호출한것 받기
		 * @param $jsFun	::: 자바스크립트에서 플래시로 호출한 함수명
		 * @param $asFun	::: 실행할 액션스크립트 함수
		 */		
		public static function callBack($jsFun:String, $asFun:Function):void {
			if(ExternalInterface.available) ExternalInterface.addCallback($jsFun, $asFun);
		}
		
		/**
		 * 경고창 호출 
		 * @param $str	:::	경고메세지
		 */		
		public static function alert($str:String):void {
			if(SystemUtil.isBrowser()) ExternalInterface.call( "alert", $str );
			else trace($str);
		}
		
		/**
		 * 경로를 나타내는 것인가 
		 * @param $url	::: 주소
		 * @return 		::: 블린
		 */		
		public static function isURL($url:String):Boolean
		{
			return ($url.indexOf("http://") == 0 || $url.indexOf("javascript:") == 0)
		}
		
		/**
		 * 캐시가 겹치지 않는 경로로 변경
		 * @param $value	::: 경로
		 * @param $isNeed	::: 반드시 실행
		 * @return 			::: 변경된 경로
		 */		
		public static function cache($value:String, $isNeed:Boolean = false):String
		{
			var result:String = "";
			
			if(unescape($value).indexOf("http://") == 0 || $isNeed){
				var myDate:Date = new Date();
				if ($value.indexOf("?") == -1){
					result = $value + "?";
				}else{
					result = $value + "&";
				}
				result = result + "rev=" + myDate.getTime();
			}else{
				result = $value;
			}
			
			result = unescape(result);

			return result;
		}
		
		/**
		 * flashVars 파라미터값 받기 
		 * @param $stage	::: 스테이지
		 * @return 			::: 값을 포함하고 있는 오브젝트
		 */		
		public static function parameters($stage:Object):Object
		{
			var keyStr:String;
			var valueStr:String;
			
			var paramObj:Object = $stage.loaderInfo.parameters;
			var obj:Object = new Object();
			
			for (keyStr in paramObj) {
				valueStr = String(paramObj[keyStr]);
				
				obj[keyStr.toString()] = valueStr;
			}
			
			return obj
		}

		/**
		 * 트레킹 
		 * @param $str	::: 트레킹 url
		 * 
		 */
		public static function tracking($str:String):void
		{
			if(SystemUtil.isWeb()){
				var loader:URLLoader = new URLLoader();
				loader.addEventListener(IOErrorEvent.IO_ERROR, ioError);
				loader.load(new URLRequest($str));
				
				function ioError(e:IOErrorEvent):void{}
				
				loader = null;
			}else{
				trace("[ traking : "+$str+" ]");
			}
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//확장메소드//////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
	}
}