package com.ddoeng.navigation
{	
	import com.ddoeng.text.TextFieldSet;
	import com.ddoeng.utils.Common;
	import com.ddoeng.utils.Frame;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 *
	 * @author : Cho Yun Gi (ddoeng@naver.com)
	 * @version : 1.0
	 * @since : Nov 17, 2010
	 * 
	 * 1. 클래스 설명
	 *		메뉴 아이템 생성
	 * 
	 * 2. 메소드
	 * - 리스너
	 * 
	 * - 내부메소드
	 * 
	 * - 외부메소드
	 * 		create()					::: 텍스트 필드를 받아 Menu로 적용
	 * 		on()						::: 버튼 온
	 * 		off()						::: 버튼 오프
	 * 		getTextField()				:::	텍스트필드 반환
	 *		getTextMovieClip()			::: 텍스트필드를 감싸고 있는 무비클립 반환
	 * 		getBackgoundMovieClip()		:::	백그라운드 반환
	 * - 확장메소드
	 *		
	 */
	
	public class Menu extends MovieClip
	{
		private var fid:TextField = new TextField();	//텍스트필드를 담을 변수
		private var txt:MovieClip = new MovieClip();	//텍스트필드가 붙은 무비클립
		private var bg:MovieClip = new MovieClip(); 	//버튼 백그라운드 선택영역
		private var frame:Frame = new Frame();			//프레임 클래스
		
		/**
		 * vbar menu:MenuClip = new MenuClip();
		 * menu.create( new TextFieldSet( new TextFormatSet("MyriadSemiBold", 20, 0xff0000), new FONTLoader("MyriadSemiBold"), "Menu") );
		 * - 인스턴트
		 * 		txt	: 텍스트필드를 감싸고 있는 무비클립
		 * 		bg	: 백그라운드 무비클립
		 */		
		public function Menu(){
			stop();
			
			txt = this.getChildByName("txt") as MovieClip;
			bg = this.getChildByName("bg") as MovieClip;
			
			Common.targetClear(txt);
			
			buttonMode = true;
			mouseChildren = false;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//외부메소드//////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * 텍스트 필드를 받아 Menu로 적용
		 * @param $fid	:::	Menu로 적용시킬 텍스트필드
		 */		
		public function create($fid:TextFieldSet):void
		{
			fid = $fid;
			
			txt.addChild($fid);

			bg.width = txt.width + (txt.x * 2);
		}
		
		/**
		 * 버튼 온 
		 */
		public function on():void
		{
			frame.pf(this);
		}
		
		/**
		 * 버튼 오프
		 */		
		public function off():void
		{
			frame.bf(this);
		}
		
		/**
		 * @return	::: 텍스트필드 반환
		 */		
		public function getTextField():TextField {
			return fid;
		}
		
		/**
		 * @return	::: 텍스트필드를 감싸고 있는 무비클립 반환
		 */		
		public function getTextMovieClip():MovieClip{
			return txt;
		}
		
		/**
		 * @return	::: 백그라운드 반환
		 */		
		public function getBackgoundMovieClip():MovieClip {
			return bg;
		}
		
	}
	
}