package com.ddoeng.text
{
	import flash.text.TextFormat;
	
	/**
	 *
	 * @author : Cho Yun Gi
	 * @version : 1.0
	 * @since : Nov 17, 2010
	 * 
	 * 1. 클래스 설명
	 *		텍스트 포맷 셋 클래스
	 * 2. 메소드
	 * - 리스너
	 * 
	 * - 내부메소드
	 * 		
	 * - 외부메소드
	 * 		
	 * - 확장메소드
	 * 
	 */
	
	public class TextFormatSet extends TextFormat
	{
		/**
		 * 텍스트 포맷 셋
		 * @param $fontname			::: 폰트명
		 * @param $fontsize			::: 사이즈
		 * @param $fontcolor		::: 색상
		 * @param $fontspacing		:::	자간
		 * @param $fontalign		::: 정렬방식
		 * @param $fontbold			::: 볼드유무
		 */		
		public function TextFormatSet($fontname:String, $fontsize:Number = 9, $fontcolor:uint=0x000000, $fontspacing:Number = 0, $fontalign:String = "left", $fontbold:Boolean = false)
		{
			this.font 			= $fontname;
			this.color 			= $fontcolor;
			this.size 			= $fontsize;
			this.letterSpacing 	= $fontspacing;
			this.align 			= $fontalign;
			this.bold 			= $fontbold;
		}
	}
}