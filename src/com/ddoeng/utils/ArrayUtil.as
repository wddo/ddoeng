package com.ddoeng.utils
{
	
	/**
	 *
	 * @author : Cho Yun Gi (ddoeng@naver.com)
	 * @version : 1.0
	 * @since : Nov 17, 2010
	 * 
	 * 1. 클래스 설명
	 *		배열 주무르기 클래스
	 * 2. 메소드
	 * - 리스너
	 * 
	 * - 내부메소드
	 * 		random()		:::	목적상2개의 인수를 받음
	 * - 외부메소드
	 * 		randomSort()	:::	랜덤배열 섞기
	 * 		cut()			::: 값 잘라내기
	 * 		insert()		:::	값 삽입하기
	 * 		leftPush()		:::	배열좌로 이동
	 * 		rightPush()		::: 배열우로 이동
	 * - 확장메소드
	 *		
	 */
	
	public class ArrayUtil
	{
		public function ArrayUtil()
		{
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//내부메소드//////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function random(item1:Object, item2:Object):int
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
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//외부메소드//////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * 랜덤배열 섞기
		 * @param arr	::: 랜덤하게 섞을 배열
		 */		
		public function randomSort(arr:Array):void
		{
			arr.sort(this.random);
		}
		
		/**
		 * 값 잘라내기
		 * @param arr	::: 작업할 배열 
		 * @param index	:::	잘라낼 인덱스
		 * @return 		::: 잘라낸 값
		 */		
		public function cut(arr:Array, index:int):Object{
			return arr.splice(index, 1);
		}
		
		/**
		 * 값 삽입하기
		 * @param arr	:::	작업할 배열
		 * @param index	::: 삽입할 위치 인덱스
		 * @param val	::: 삽입할 값
		 * 
		 */	
		public function insert(arr:Array, index:int, val:Object):void{
			arr.splice(index, 0, val);
		}
		
		/**
		 * 배열 좌로 이동
		 * @param arr	::: 좌로 이동할 배열
		 */	
		public function leftPush(arr:Array):void {
			arr.push(arr.shift());
		}
		
		/**
		 * 배열 우로 이동
		 * @param arr	::: 우로 이동할 배열
		 */	
		public function rightPush(arr:Array):void {
			arr.unshift(arr.pop());
		}
	}
}