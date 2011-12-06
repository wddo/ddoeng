package com.ddoeng.utils
{	
	/**
	 *
	 * @author : Cho Yun Gi (ddoeng@naver.com)
	 * @version : 1.0
	 * @since : Nov 17, 2010
	 * 
	 * 1. 클래스 설명
	 *	
	 * 2. 메소드
	 * - 리스너
	 * 
	 * - 내부메소드
	 * 
	 * - 외부메소드
	 * 		stringToCharacter()		:::	문자열 앞쪽 한글자씩 반환하는 메소드
	 * 		replace()				:::	문자열 전체를 특정 문자를 선택하여 변경
	 * 		trim()					:::	문자열 앞뒤 여백을 제거 할때 유용
	 * 		trimFront()				:::	문자열 앞쪽 여백제거 할때 유용
 	 * 		trimBack()				:::	문자열 뒤쪽 여백제거 할때 유용
	 * - 확장메소드
	 *		
	 */

	public class Replace
	{		
		public function Replace () {	

		}

		////////////////////////////////////////////////////////////////////////////////////////////////////
		//외부메소드//////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * 문자열 앞쪽 한글자씩 반환하는 메소드
		 * @param $str	::: 문자열
		 * @return		:::	맨앞문자반환 	
		 */		
		public function stringToCharacter($str:String):String {
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
			$char = stringToCharacter($char);
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
			$char = stringToCharacter($char);
			if ($str.charAt($str.length - 1) == $char) {
				$str = trimBack($str.substring(0, $str.length - 1), $char);
			}
			return $str;
		}
	}
	
}