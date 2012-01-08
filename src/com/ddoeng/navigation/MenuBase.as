package com.ddoeng.navigation
{	
	import com.ddoeng.events.net.FONTLoaderEvent;
	import com.ddoeng.text.TextFieldSet;
	import com.ddoeng.utils.Common;
	import com.ddoeng.utils.Frame;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 *
	 * GNB & LNB 에 사용되는 메뉴의 베이스 클래스
	 *  - 기본 인스턴트명은 "bg", "txt" 이다.
	 *  - clip에 "txt" 무비클립이 위치가 어디에 있던지 0,0 으로 셋팅 됩니다.
	 * 	- bg영역을 고정시키고 싶으면 clip에 투명한 sp 무비클립을 넣어 놓으면 됩니다.
	 * 
	 * @author : Jo Yun Ki (naver ID - ddoeng)
	 * @version : 1.0
	 * @since : Nov 17, 2010
	 * 
	 */
	
	public dynamic class MenuBase extends MovieClip
	{
		private var _clip:MovieClip;					//그래픽요소
		private var _fid:TextFieldSet;					//텍스트필드를 담을 변수
		private var _txt:MovieClip;						//텍스트필드가 붙은 무비클립
		private var _bg:MovieClip; 						//버튼 백그라운드 선택영역
		
		private var _idx:int;							//아이디
		private var _offsetX:int;						//버튼간 좌우 간격
		private var _offsetY:int;						//버튼 상하 간격
		
		private var _frame:Frame = new Frame();			//프레임 클래스
		
		/**
		 * @param $clip		::: 버튼화 하기 위한 clip
		 */		
		public function MenuBase($clip:MovieClip){
			_clip = $clip as MovieClip;
			addChild(_clip);
			
			//bg가 없을때 사용할 rect
			var rect:MovieClip = new MovieClip();
			rect.graphics.beginFill(0x00FFFF);
			rect.graphics.drawRect(0, 0, 10, 10);
			rect.graphics.endFill();
			
			_txt = (_clip.getChildByName("txt") == null)?new MovieClip():_clip.getChildByName("txt") as MovieClip;	
			_txt.x = _offsetX;
			_txt.y = _offsetY;
						
			_bg = (_clip.getChildByName("bg") == null)?rect:_clip.getChildByName("bg") as MovieClip;
			_bg.alpha = 0;
			
			if(_clip.getChildByName("bg") == null)_clip.addChild(_bg);
			if(_clip.getChildByName("txt") == null)_clip.addChild(_txt);
			
			Common.targetClear(_txt);
			
			this.buttonMode = true;
			this.mouseChildren = false;
		}
		
		/**
		 * 텍스트 필드를 받아 Menu로 적용
		 * @param $fid	:::	Menu로 적용시킬 텍스트필드
		 */		
		public function setCreate($fid:TextFieldSet, $offsetX:int, $offsetY:int):void
		{
			_fid = $fid;
			_txt.addChild($fid);
			
			_offsetX = $offsetX;
			_offsetY = $offsetY;
			
			initTextField();
			initBackground();
			
			//Embed후 BG 다시 초기화
			if(!_fid.isFontLoad()){
				_fid.addEventListener(FONTLoaderEvent.FONTLOAD_COMPLETE, comp);
				function comp(e:FONTLoaderEvent):void{
					initBackground();
				}
			}
		}
		
		/**
		 * TEXT 초기화 
		 */		
		private function initTextField():void
		{
			//offset 값을 토대로 반을 나눠 배치 한다.
			//즉, 전체를 놓고 볼때 맨 좌우측이 offset 반값이 되고 중간중간이 정확히 offset 값이 된다. 
			_txt.x = _offsetX / 2;
			_txt.y = _offsetY / 2;
		}
		
		/**
		 * BG 초기화 
		 */		
		private function initBackground():void
		{
			_bg.width = Math.floor(_txt.width) + _offsetX;
			_bg.height = Math.floor(_txt.height) + _offsetY;
		}
		
		/**
		 * 버튼 온 
		 */
		public function setOn():void
		{

		}
		
		/**
		 * 버튼 오프
		 */		
		public function setOff():void
		{

		}
		
		/**
		 * @return	::: 텍스트필드 반환
		 */		
		public function getTextField():TextField
		{
			return _fid;
		}
		
		/**
		 * @return	::: 텍스트필드를 감싸고 있는 무비클립 반환
		 */		
		public function getTextMovieClip():MovieClip
		{
			return _txt;
		}
		
		/**
		 * @return	::: 백그라운드 반환
		 */		
		public function getBackgoundMovieClip():MovieClip
		{
			return _bg;
		}
		
		/**
		 * @return	::: 그래픽요소 반환 
		 */		
		public function getClip():MovieClip
		{
			return _clip;
		}
	}
	
}