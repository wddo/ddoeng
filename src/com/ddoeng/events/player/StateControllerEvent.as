package com.ddoeng.events.player
{
	import flash.events.Event;
	
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