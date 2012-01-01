package com.ddoeng.utils
{	
	/**
	 *
	 * @author : Cho Yun Gi (ddoeng@naver.com)
	 * @version : 1.0
	 * @since : Nov 17, 2010
	 * 
	 * 텍스트 유틸
	 * 
	 */

	public class TextUtil
	{		
		public function TextUtil () {	

		}

		/**
		 * 문자열 앞쪽 한글자씩 반환하는 메소드
		 * @param $str	::: 문자열
		 * @return		:::	맨앞문자반환 	
		 */		
		private function firstCharacter($str:String):String {
			if ($str.length == 1) {
				return $str;
			}
			return $str.slice(0, 1);
		}
		
		/**
		 * 문자열 전체를 특정 문자를 선택하여 변경
		 * @param $str			::: 문자열
		 * @param $oldSubStr	::: 변경될 문자
		 * @param $newSubStr	::: 변경된 문자
		 * @return 				::: 새로운 문자열
		 * 
		 */
		public function replace($str:String, $oldSubStr:String, $newSubStr:String):String {
			return $str.split($oldSubStr).join($newSubStr);
		}
		
		/**
		 * 문자열 앞뒤 여백을 제거 할때 유용
		 * @param $str		:::	문자열
		 * @param $char		::: 변경할 문자
		 * @return 			::: 새로운 문자열
		 */		
		public function trim($str:String, $char:String):String {
			return trimBack(trimFront($str, $char), $char);
		}
		
		/**
		 * 문자열 앞쪽 여백제거 할때 유용
		 * @param $str		:::	문자열
		 * @param $char		::: 변경할 문자
		 * @return 			::: 새로운 문자열
		 */			
		public function trimFront($str:String, $char:String):String {
			$char = firstCharacter($char);
			if ($str.charAt(0) == $char) {
				$str = trimFront($str.substring(1), $char);
			}
			return $str;
		}
		
		/**
		 * 문자열 뒤쪽 여백제거 할때 유용
		 * @param $str		:::	문자열
		 * @param $char		::: 변경할 문자
		 * @return 			::: 새로운 문자열
		 */	
		public function trimBack($str:String, $char:String):String {
			$char = firstCharacter($char);
			if ($str.charAt($str.length - 1) == $char) {
				$str = trimBack($str.substring(0, $str.length - 1), $char);
			}
			return $str;
		}
	}
	
}