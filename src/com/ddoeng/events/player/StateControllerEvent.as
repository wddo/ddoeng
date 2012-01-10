package com.ddoeng.events.player
{
	import flash.events.Event;
	
	public class StateControllerEvent extends Event
	{
		public static const STATE_PLAYING:String = "statePlaying";
		public static const PLAY_CLICK:String = "playClick";
		public static const PAUSE_CLICK:String = "pauseClick";
		public static const STOP_CLICK:String = "stopClick";
		
		public var playTimed:Object;
		public var playTime:Object;
		
		public function StateControllerEvent($type:String, $playTimed:Object = null, $playTime:Object = null, $bubbles:Boolean=false, $cancelable:Boolean=false)
		{
			super($type, $bubbles, $cancelable);
			
			this.playTimed = $playTimed;
			this.playTime = $playTime;
		}
	}
}