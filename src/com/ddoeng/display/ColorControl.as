package com.ddoeng.display
{
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	
	/**
	 *
	 * 글로벌 클래스
	 * 
	 * @author : Jo Yun Ki (naver ID - ddoeng)
	 * @version : 1.0
	 * @since : Mar 16, 2011
	 * 
	 */
	
	public class ColorControl
	{
		public function ColorControl()
		{
		}

		private function applyFilter($child:DisplayObject, $matrix:Array):void
		{
			var filter:ColorMatrixFilter = new ColorMatrixFilter($matrix);
			var filters:Array = new Array();
			filters.push(filter);
			$child.filters = filters;
		}
		
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
		/*
		public function setContrast($child:DisplayObject, $value:Number = 1, $speed:Number = 0.01):void
		{
			TweenMax.to($child, $speed, {colorMatrixFilter:{contrast:(($value*100) * 0.05)+1, saturation:0}});
		}
		*/
	}
}