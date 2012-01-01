package com.ddoeng.utils
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 *
	 * 프레임 조절 클래스	
	 * 
	 * @author : Jo Yun Ki (naver ID - ddoeng)
	 * @version : 1.0
	 * @since : Nov 17, 2010
	 * 
	 */
	
	public class Frame
	{
		private var _cal:Calculation = new Calculation();
		
		public function Frame()
		{
			
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
			}else if(mc.state == "prev2"){
				if(1 != mc.currentFrame){
					mc.prevFrame();
					mc.prevFrame();
				}else{
					mc.removeEventListener(e.type, onEnter); 
				}
			}
		}
		
		/**
		 * 프레임 전진
		 * @param $mc	::: 프레임이동할 무비클립
		 */		
		public function setPf($mc:MovieClip):void
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
		public function setBf($mc:MovieClip):void
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
		public function setBf2($mc:MovieClip):void
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
		public function setDel($mc:MovieClip):void
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
		public function setMotion($source:MovieClip, $state:String, $completeFrame:int):void
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
					frame = Math.floor(_cal.getLinearFunction(1, $completeFrame, total, $completeFrame, current));
					if($completeFrame >= frame)frame = $completeFrame + 1; //completeFrame stop error catch
					mc.gotoAndPlay( (frame < 2)?2:frame );
				}
			}else{
				//out area
				if($state == "over"){
					frame = Math.floor(_cal.getLinearFunction(total, $completeFrame, 1, $completeFrame, current));
					mc.gotoAndPlay( (frame < 2)?2:frame );
				}
				if($completeFrame >= current)current = $completeFrame + 1; //completeFrame stop error catch
				if($state == "out")mc.gotoAndPlay( current );
			}
		}
	}
}