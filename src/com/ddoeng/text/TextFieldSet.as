package com.ddoeng.text
{
	import com.ddoeng.events.FONTLoaderEvent;
	import com.ddoeng.net.FONTLoader;
	import com.ddoeng.utils.TextUtil;
	
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 *
	 * 텍스트 필드 셋 클래스
	 * 
	 * @author : Jo Yun Ki (naver ID - ddoeng)
	 * @version : 1.0
	 * @since : Nov 17, 2010
	 * 
	 */
	
	public class TextFieldSet extends TextField
	{
		private var _textUtil:TextUtil = new TextUtil();	//문자열 변경
		private var _fontName:String = "";				//폰트이름
		
		/**
		 * 텍스트 필드 셋
		 * @param $txtformat		:::	텍스트포맷
		 * @param $embed			::: 이엠베드 유무
		 * @param $txt				::: 텍스트
		 * @param $scalex			::: 가로 스케일
		 * @param $autosize			::: 자동사이즈 늘림
		 * @param $selectable		::: 선택될지 유무
		 */		
		public function TextFieldSet($txtformat:TextFormat, $embed:Boolean = false, $txt:String = "default", $scalex:Number = 1, $autosize:String = "none", $selectable:Boolean = false)
		{
			this.selectable 		= $selectable;
			this.text 				= $txt;
			this.defaultTextFormat 	= $txtformat;
			this.scaleX 			= $scalex;
			this.autoSize 			= $autosize;
			this.name				= "fid";
			
			this.setTextFormat($txtformat);
			
			_fontName = $txtformat.font;
			
			_fontName = _textUtil.setReplace(_fontName, " ", "");
			_fontName = _textUtil.setReplace(_fontName, "-", "");
			_fontName = _textUtil.setReplace(_fontName, "_", "");
			
			if($embed){
				//이미 폰트가 로드되어있다면
				if(ApplicationDomain.currentDomain.hasDefinition(_fontName)){
					onEmbed();
				}
			}
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//내부메소드//////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function onEmbed(e:FONTLoaderEvent = null):void
		{
			this.embedFonts = true;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//외부메소드//////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * 폰트로드가 완료되면 해당 필드를 이엠베드 필요시 fontloader를 인자값으로 받는다.
		 * @param $fontloader	:::	런타임 이엠베드 적용할 폰트로더
		 */
		public function setRuntimeEmbed($fontloader:FONTLoader):void
		{
			if(!ApplicationDomain.currentDomain.hasDefinition(_fontName)){
				$fontloader.addEventListener(FONTLoaderEvent.FONTLOAD_COMPLETE, onEmbed);
			}
		}
	}
}