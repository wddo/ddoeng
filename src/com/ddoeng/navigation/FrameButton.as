package com.ddoeng.navigation
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 *
	 * @author : Cho Yun Gi (ddoeng@naver.com)
	 * @version : 1.0
	 * @since : Nov 17, 2010
	 * 
	 * 1. 클래스 설명
	 * 		프레임이 존재하는 메뉴
	 *  
	 * 2. 메소드
	 * - 리스너
	 * 		onBtn()				:::	마우스 이벤트
	 * 		onEnter()			:::	메뉴에 대한 엔터프레임
	 * - 내부메소드
	 * 		addEvent()			::: 이벤트를 담당
	 * 		setLayout()			::: 레이아웃 담당
	 * 		pf()				::: 프레임전진
	 * 		bf()				::: 프레임후진
	 * - 외부메소드
	 * 		onDefualt()			::: 활성화를 비활성화로
	 * 		get clip()			::: 라이브러리 clip 반환
	 * 		setget selected()	::: 선택여부
	 * 		setget id()			::: 아이디
	 * - 확장메소드
	 *		
	 */
	
	public class FrameButton extends MovieClip
	{
		private var asset:MovieClip;	//타임라인이 존재하는 버튼소스
		private var sel:FrameButton;	//선택되있는 버튼인지 체크
		private var num:int;			//id값
		
		/**
		 * 기본적으로 오버.아웃.다운 및 페이지기억 적용되어 있으며 외부에서 다시 오버.아웃.다운을 적용시켜 확장한다.
		 * @param $source     ::: 버튼소스가 될 무비클립
		 * 
		 */		
		public function FrameButton($source:MovieClip)
		{			
			asset = $source;
			
			asset.stop();
			asset.buttonMode    = true;
			asset.mouseChildren = false;
			
			addEvent();
			setLayout();
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//리스너/////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function onBtn(e:MouseEvent):void
		{
			switch(e.type){
				case MouseEvent.MOUSE_OVER:
					if(sel != this) pf();
					break;
				case MouseEvent.MOUSE_OUT:
					if(sel != this) bf();
					break;
				case MouseEvent.MOUSE_DOWN:
					pf();
					break;
				default:
					break;
			}
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
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//내부메소드//////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function addEvent():void
		{
			asset.addEventListener(MouseEvent.MOUSE_OVER, onBtn);
			asset.addEventListener(MouseEvent.MOUSE_OUT, onBtn);
			asset.addEventListener(MouseEvent.MOUSE_DOWN, onBtn);
		}
		
		private function setLayout():void
		{
			addChild(asset);
		}
		
		private function pf():void
		{
			asset.state = "next";
			if(!asset.hasEventListener(Event.ENTER_FRAME)){
				asset.addEventListener(Event.ENTER_FRAME, onEnter);
			}
		}
		
		private function bf():void
		{
			asset.state = "prev";
			if(!asset.hasEventListener(Event.ENTER_FRAME)){
				asset.addEventListener(Event.ENTER_FRAME, onEnter);
			}
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//외부메소드//////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * 활성화를 비활성화로
		 */	
		public function onDefualt():void
		{
			bf();
		}
		
		/**
		 * 라이브러리 clip 반환
		 */	
		public function get clip():DisplayObjectContainer
		{
			return asset;
		}

		/**
		 * 선택상태로 지정,반환
		 */		
		public function set selected($obj:FrameButton):void
		{
			sel = $obj;
		}
		public function get selected():FrameButton
		{
			return sel;
		}

		/**
		 * 아이디값 지정,반환
		 */		
		public function set id($n:int):void
		{
			num = $n;
		}
		public function get id():int
		{
			return num;
		}
	}
}