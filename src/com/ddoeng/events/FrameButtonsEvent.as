package com.ddoeng.events
{
	import flash.events.MouseEvent;

	public class FrameButtonsEvent extends MouseEvent
	{
		public static var BUTTONSET_DOWN:String = "buttonsetDown";
		public var id:int;	//아이디 변수
		
		public function FrameButtonsEvent($type:String, $id:int, $bubbles:Boolean=false, $cancelable:Boolean=false)
		{
			super($type, $bubbles, $cancelable);
			
			this.id = $id;
		}
		
	}
}