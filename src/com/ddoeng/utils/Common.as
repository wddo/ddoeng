package com.ddoeng.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	
	/**
	 *
	 * 공용으로 쓸만한 메소드 모음 클래스
	 * 
	 * @author : Jo Yun Ki (naver ID - ddoeng)
	 * @version : 1.0
	 * @since : Nov 17, 2010
	 * 	
	 */
	
	public class Common
	{
		public function Common()
		{
			
		}
		
		/**
		 * 타겟 비우기 
		 * @param $source	::: 비울 타겟
		 */		
		public static function targetClear($source:DisplayObjectContainer):void
		{
			try{
				while(true){
					var dis:DisplayObject = $source.getChildAt(0);

					$source.removeChild( dis );
					dis = null;
				}
			}catch(e:Error){
				
			}
		}
		
		/**
		 * 다중 이벤트리스너 (공통의 반응적용시 유용)
		 * @param $objects	::: 이벤트를 걸 오브젝트 배열
		 * @param $type		::: 이벤트 타입
		 * @param $func		::: 이벤트에 따른 함수
		 * 
		 */		
		public static function listeners($objects:Array, $type:String, $func:Function):void {
			var i:int = $objects.length;
			while (i--) {
				$objects[i].addEventListener($type, $func);
			}
		}
		
		/**
		 * 값이 비어있느냐
		 * @param $value	::: 값이 비어있는지 체크할 변수
		 */		
		public static function isEmpty($value:*):Boolean
		{
			var value:String = String($value);
	
			//null(객체), NaN(Number), *(undefined), ""
			return (value != "null" && value != "NaN" && value != "undefined" && value != "")?false:true;
		}
	}
}