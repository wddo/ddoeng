package com.ddoeng.events.component
{
	import flash.events.Event;

	public class ScrollEvent extends Event
	{
		public static const START_SCROLL:String = "startScroll";
		public static const MOVE_SCROLL:String = "moveScroll";
		public static const STOP_SCROLL:String = "stopScroll";
		
		public var pos:Number;
		public var playTime:Object;
		
		public function ScrollEvent($type:String, $pos:Number, $bubbles:Boolean=false, $cancelable:Boolean=false)
		{
			super($type, $bubbles, $cancelable);
			
			this.pos = $pos;
		}
	}
}