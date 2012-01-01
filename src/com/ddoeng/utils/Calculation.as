package com.ddoeng.utils
{
	/**
	 *
	 * @author : Cho Yun Gi (ddoeng@naver.com)
	 * @version : 1.0
	 * @since : Nov 17, 2010
	 * 
	 * 어려운 계산식 모음 클래스	
	 */
	
	public class Calculation
	{
		public function Calculation()
		{
			
		}
		
		/**
		 * 1차함수
		 * @param $a ::: 값1의 최소값
		 * @param $b ::: 값1의 최대값
		 * @param $c ::: 값2의 최소값
		 * @param $d ::: 값2의 최대값
		 * @param $x ::: 값1의 현재값
		 * @return  ::: 값2의 현재값 
		 */
		public function getLinearFunction($a:Number, $b:Number, $c:Number, $d:Number, $x:Number):Number
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
		public function getRandomNumber($min:int = 0, $max:int = 10):int
		{
			return Math.round( Math.random() * ( $max - $min ) + $min );
		}
	}
}