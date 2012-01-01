package com.ddoeng.text
{
	import flash.text.TextFormat;
	
	/**
	 *
	 * 텍스트 포맷 셋 클래스
	 * 
	 * @author : Jo Yun Ki (naver ID - ddoeng)
	 * @version : 1.0
	 * @since : Nov 17, 2010
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