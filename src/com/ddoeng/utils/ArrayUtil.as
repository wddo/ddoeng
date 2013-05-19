package com.ddoeng.utils
{
	
	/**
	 *
	 * 배열 주무르기 클래스
	 * 
	 * @author : Jo Yun Ki (naver ID - ddoeng)
	 * @version : 1.0
	 * @since : Nov 17, 2010
	 * 
	 */
	
	public class ArrayUtil
	{
		public function ArrayUtil()
		{
			
		}
		
		private function random($item1:Object, $item2:Object):int
		{
			/*
			정렬 순서에서 A가 B 앞에 오면 -1입니다.
			A와 B가 같으면 0입니다.
			정렬 순서에서 A가 B 뒤에 오면 1입니다.
			
			위사항을 임의로 정해서 반환
			*/
			var num:int = Math.round(Math.random()* 3) - 1; //-1, 0, 1
			return num;
		}
		
		/**
		 * 랜덤배열 섞기
		 * @param arr	::: 랜덤하게 섞을 배열
		 */		
		public function setRandomSort($arr:Array):void
		{
			$arr.sort(this.random);
		}
		
		/**
		 * 값 잘라내기
		 * @param arr	::: 작업할 배열 
		 * @param index	:::	잘라낼 인덱스
		 * @return 		::: 잘라낸 값
		 */		
		public function setCut($arr:Array, $idx:int):Object{
			return $arr.splice($idx, 1)[0];
		}
		
		/**
		 * 값 삽입하기
		 * @param arr	:::	작업할 배열
		 * @param index	::: 삽입할 위치 인덱스
		 * @param val	::: 삽입할 값
		 * 
		 */	
		public function setInsert($arr:Array, $idx:int, $val:Object):void{
			$arr.splice($idx, 0, $val);
		}
		
		/**
		 * 배열 좌로 이동
		 * @param arr	::: 좌로 이동할 배열
		 */	
		public function setLeftPush($arr:Array):void {
			$arr.push($arr.shift());
		}
		
		/**
		 * 배열 우로 이동
		 * @param arr	::: 우로 이동할 배열
		 */	
		public function setRightPush($arr:Array):void {
			$arr.unshift($arr.pop());
		}
	}
}