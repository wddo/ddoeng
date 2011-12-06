package com.ddoeng.utils
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 *
	 * @author : Cho Yun Gi (ddoeng@naver.com)
	 * @version : 1.0
	 * @since : Nov 17, 2010
	 * 
	 * 1. 클래스 설명
	 *		프레임 조절 클래스
	 * 2. 메소드
	 * - 리스너
	 * 		onEnter()	::: 상태에 따른 nextFrame, prevFrame 을 실행하는 엔터프레임
	 * - 내부메소드
	 * 
	 * - 외부메소드
	 * 		pf()		::: 프레임 전진
	 * 		bf()		::: 프레임 후진 
	 * 		bf2()		::: 빠른 프레임 후진 
	 * 		del()		::: 엔터프레임 강제종료
	 * 		motion()	::: 버튼 오버와 아웃을 전체프레임에 중간을 기점으로 자동 설정하여 모션
	 * - 확장메소드
	 *		
	 */
	
	public class Frame extends EventDispatcher
	{
		private var cal:Calculation = new Calculation();
		
		public function Frame()
		{
			
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//리스너/////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
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
			}else if(mc.state == "prev2"){
				if(1 != mc.currentFrame){
					mc.prevFrame();
					mc.prevFrame();
				}else{
					mc.removeEventListener(e.type, onEnter); 
				}
			}
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//외부메소드//////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * 프레임 전진
		 * @param $mc	::: 프레임이동할 무비클립
		 */		
		public function pf($mc:MovieClip):void
		{
			var mc:MovieClip = $mc;
			
			mc.state = "next";
			if(!mc.hasEventListener(Event.ENTER_FRAME)){
				mc.addEventListener(Event.ENTER_FRAME, onEnter);
			}
		}
		
		/**
		 * 프레임 후진 
		 * @param $mc	::: 프레임이동할 무비클립
		 */		
		public function bf($mc:MovieClip):void
		{
			var mc:MovieClip = $mc;
			
			mc.state = "prev";
			if(!mc.hasEventListener(Event.ENTER_FRAME)){
				mc.addEventListener(Event.ENTER_FRAME, onEnter);
			}
		}

		/**
		 * 빠른 프레임 후진 
		 * @param $mc	::: 프레임이동할 무비클립
		 */	
		public function bf2($mc:MovieClip):void
		{
			var mc:MovieClip = $mc;
			
			mc.state = "prev2";
			if(!mc.hasEventListener(Event.ENTER_FRAME)){
				mc.addEventListener(Event.ENTER_FRAME, onEnter);
			}
		}
		
		/**
		 * 엔터프레임 강제종료
		 * @param $mc 	::: 엔터프레임 종료하고자 하는 무비클립 
		 */		
		public function del($mc:MovieClip):void
		{
			var mc:MovieClip = $mc;
			
			if(mc.hasEventListener(Event.ENTER_FRAME)){
				mc.removeEventListener(Event.ENTER_FRAME, onEnter);
			}
		}
		
		/**
		 * 버튼 오버와 아웃을 전체프레임에 중간을 기점으로 자동 설정하여 모션  
		 * @param $source			::: 모션적용할 무비클립
		 * @param $state			::: 상태 ( over & out )
		 * @param $completeFrame	::: 완료되었을때의 프레임 넘버
		 */		
		public function motion($source:MovieClip, $state:String, $completeFrame:int):void
		{
			var mc:MovieClip = $source;
			var current:int = mc.currentFrame;
			var total:int = mc.totalFrames;
			var frame:int = 0;
			
			if(current <= $completeFrame){
				//over area
				//if($state == "over")mc.gotoAndPlay( current ); //2011-04-07 예외처리
				if($state == "over"){
					if(current == $completeFrame)mc.gotoAndStop( $completeFrame );	
					else mc.gotoAndPlay( current );
						
				}
				if($state == "out"){
					frame = Math.floor(cal.linearFunction(1, $completeFrame, total, $completeFrame, current));
					if($completeFrame >= frame)frame = $completeFrame + 1; //completeFrame stop error catch
					mc.gotoAndPlay( (frame < 2)?2:frame );
				}
			}else{
				//out area
				if($state == "over"){
					frame = Math.floor(cal.linearFunction(total, $completeFrame, 1, $completeFrame, current));
					mc.gotoAndPlay( (frame < 2)?2:frame );
				}
				if($completeFrame >= current)current = $completeFrame + 1; //completeFrame stop error catch
				if($state == "out")mc.gotoAndPlay( current );
			}
		}
	}
}