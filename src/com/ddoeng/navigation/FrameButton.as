package com.ddoeng.navigation
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 *
	 * 프레임이 존재하는 메뉴
	 * 
	 * @author : Jo Yun Ki (naver ID - ddoeng)
	 * @version : 1.0
	 * @since : Nov 17, 2010
	 */
	
	public class FrameButton extends MovieClip
	{
		private var _clip:MovieClip;				//타임라인이 존재하는 버튼소스
		private var _selectedButton:FrameButton;	//선택되있는 버튼인지 체크
		private var _idx:int;						//id값
		
		/**
		 * 기본적으로 오버.아웃.다운 및 페이지기억 적용되어 있으며 외부에서 다시 오버.아웃.다운을 적용시켜 확장한다.
		 * @param $clip     ::: 버튼소스가 될 무비클립
		 * 
		 */		
		public function FrameButton($clip:MovieClip)
		{			
			_clip = $clip;
			
			_clip.stop();
			_clip.buttonMode 	= true;
			_clip.mouseChildren = false;
			
			initUI();
		}
		
		private function initUI():void
		{
			addChild(_clip);
			
			_clip.addEventListener(MouseEvent.MOUSE_OVER, onBtn);
			_clip.addEventListener(MouseEvent.MOUSE_OUT, onBtn);
			_clip.addEventListener(MouseEvent.MOUSE_DOWN, onBtn);
		}
		
		private function onBtn(e:MouseEvent):void
		{
			switch(e.type){
				case MouseEvent.MOUSE_OVER:
					if(_selectedButton != this) pf();
					break;
				case MouseEvent.MOUSE_OUT:
					if(_selectedButton != this) bf();
					break;
				case MouseEvent.MOUSE_DOWN:
					pf();
					break;
				default:
					break;
			}
		}
		
		private function pf():void
		{
			_clip.state = "next";
			
			if(!_clip.hasEventListener(Event.ENTER_FRAME))_clip.addEventListener(Event.ENTER_FRAME, onEnter);
		}
		
		private function bf():void
		{
			_clip.state = "prev";
			
			if(!_clip.hasEventListener(Event.ENTER_FRAME))_clip.addEventListener(Event.ENTER_FRAME, onEnter);
		}
		
		private function onEnter(e:Event):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			
			if(mc.state == "next"){
				if(mc.totalFrames != mc.currentFrame){
					mc.nextFrame();
				}else{
					mc.removeEventListener(e.type, onEnter);  
				}
			}else if(mc.state == "prev"){
				if(1 != mc.currentFrame){
					mc.prevFrame();
				}else{
					mc.removeEventListener(e.type, onEnter); 
				}
			}
		}
		
		/**
		 * 라이브러리 clip 반환
		 */	
		public function getClip():MovieClip
		{
			return _clip;
		}
		
		/**
		 * 선택상태로 지정
		 */		
		public function setSelected($frameButon:FrameButton):void
		{
			_selectedButton = $frameButon;
		}
		
		/**
		 * 선택상태로 반환
		 */
		public function getSelected():FrameButton
		{
			return _selectedButton;
		}

		/**
		 * 활성화로
		 */	
		public function setPf():void
		{
			pf();
		}
		
		/**
		 * 비활성화로
		 */	
		public function setBf():void
		{
			bf();
		}
		
		/**
		 * 아이디값 지정
		 */		
		public function setIdx($idx:int):void
		{
			_idx = $idx;
		}
		
		/**
		 * 아이디값 반환
		 */		
		public function getIdx():int
		{
			return _idx;
		}
	}
}