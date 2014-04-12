package com.ddoeng.events.component
{
	import flash.events.Event;

	public class ScrollEvent extends Event
	{
		public static const MOVE_SCROLL:String = "moveScroll";
		
		public var pos:Number;
		public var playTime:Object;
		
		public function ScrollEvent($type:String, $pos:Number, $bubbles:Boolean=false, $cancelable:Boolean=false)
		{
			super($type, $bubbles, $cancelable);
			
			this.pos = $pos;
		}
	}
}