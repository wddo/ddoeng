package com.ddoeng.display
{
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	
	/**
	 *
	 * @author : Cho Yun Gi (ddoeng@naver.com)
	 * @version : 1.0
	 * @since : Mar 16, 2011
	 * 
	 * 1. 클래스 설명
	 *		글로벌 클래스
	 * 2. 메소드
	 * - 리스너
	 * 
	 * - 내부메소드
	 * 		applyFilter()		::: ColorMatrixFilter 필터 적용
	 * - 외부메소드
	 * 		setColor()			::: 칼라로 전환
	 * 		setMono()			:::	흑백으로 전환
	 * 		setContrast()		::: 콘트라스트 적용
	 * - 확장메소드
	 *		
	 */
	
	public class ColorControl
	{
		public function ColorControl()
		{
		}
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//내부메소드//////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
	
		private function applyFilter($child:DisplayObject, $matrix:Array):void
		{
			var filter:ColorMatrixFilter = new ColorMatrixFilter($matrix);
			var filters:Array = new Array();
			filters.push(filter);
			$child.filters = filters;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//외부메소드//////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * 칼라로 전환 
		 * @param $child	::: 적용할 디스플레이
		 */		
		public function setColor($child:DisplayObject):void
		{
			var matrix:Array = new Array();
			
			matrix = matrix.concat([1, 0, 0, 0, 0]); // red
			matrix = matrix.concat([0, 1, 0, 0, 0]); // green
			matrix = matrix.concat([0, 0, 1, 0, 0]); // blue
			matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha
			
			applyFilter($child, matrix);
		}
		
		/**
		 * 흑백으로 전환
		 * @param $child	::: 적용할 디스플레이
		 */		
		public function setMono($child:DisplayObject):void
		{
			var matrix:Array = new Array();
			
			matrix = matrix.concat([0.3, 0.59, 0.11, 0, 0]); // red
			matrix = matrix.concat([0.3, 0.59, 0.11, 0, 0]); // green
			matrix = matrix.concat([0.3, 0.59, 0.11, 0, 0]); // blue
			matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha
			
			applyFilter($child, matrix);
		}
		
		/**
		 * 콘트라스트 적용
		 * @param $child	::: 적용할 디스플레이
		 * @param $value	::: 값 0 ~ 1
		 * @param $speed	::: 변환되는 속도(기본 0.01)
		 * 
		 */		
		public function setContrast($child:DisplayObject, $value:Number = 1, $speed:Number = 0.01):void
		{
			TweenMax.to($child, $speed, {colorMatrixFilter:{contrast:(($value*100) * 0.05)+1, saturation:0}});
		}
	}
}