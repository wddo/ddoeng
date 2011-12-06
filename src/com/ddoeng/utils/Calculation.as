package com.ddoeng.utils
{
	/**
	 *
	 * @author : Cho Yun Gi (ddoeng@naver.com)
	 * @version : 1.0
	 * @since : Nov 17, 2010
	 * 
	 * 1. 클래스 설명
	 *		어려운 계산식 모음 클래스
	 * 2. 메소드
	 * - 리스너
	 * 
	 * - 내부메소드
	 * 
	 * - 외부메소드
	 * 		linearFunction()	::: 1차함수
	 * 		randomNumber()		::: 랜덤한수
	 * - 확장메소드
	 *		
	 */
	
	public class Calculation
	{
		public function Calculation()
		{
			
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//외부메소드//////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * 1차함수
		 * @param $a ::: 값1의 최소값
		 * @param $b ::: 값1의 최대값
		 * @param $c ::: 값2의 최소값
		 * @param $d ::: 값2의 최대값
		 * @param $x ::: 값1의 현재값
		 * @return  ::: 값2의 현재값 
		 */
		public function linearFunction($a:Number, $b:Number, $c:Number, $d:Number, $x:Number):Number
		{
			return ($d - $c) / ($b - $a) * ($x - $a) + $c
		}
		
		/**
		 * 랜덤한수
		 * @param $min	::: 최소값
		 * @param $max	::: 최대값
		 * @return 		::: 최소~최대값 사이의 정수
		 * 
		 */		
		public function randomNumber( $min:int = 0, $max:int = 10 ):int
		{
			return Math.round( Math.random() * ( $max - $min ) + $min );
		}
	}
}