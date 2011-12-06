package com.ddoeng.events.player
{
	import flash.events.Event;
	
	/**
	 *
	 * @author : Cho Yun Gi (ddoeng@naver.com)
	 * @version : 1.0
	 * @since : Mar 8, 2011
	 * 
	 * 1. 클래스 설명
	 *		글로벌 클래스
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
	
	public class StateControllerEvent extends Event
	{
		public static const STATE_PLAYING:String = "statePlaying";
		
		public var playTimed:Object;
		public var playTime:Object;
		
		public function StateControllerEvent($type:String, $playTimed:Object, $playTime:Object, $bubbles:Boolean=false, $cancelable:Boolean=false)
		{
			super($type, $bubbles, $cancelable);
			
			this.playTimed = $playTimed;
			this.playTime = $playTime;
		}
	}
}