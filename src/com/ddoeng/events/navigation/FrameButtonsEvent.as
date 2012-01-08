package com.ddoeng.events.navigation
{
	import com.ddoeng.navigation.FrameButton;
	
	import flash.events.MouseEvent;

	public class FrameButtonsEvent extends MouseEvent
	{
		public static var BUTTONSET_DOWN:String = "buttonsetDown";
		public var frameButton:FrameButton;
		public var id:int;	//아이디 변수
		
		public function FrameButtonsEvent($type:String, $frameButton:FrameButton, $id:int, $bubbles:Boolean=false, $cancelable:Boolean=false)
		{
			super($type, $bubbles, $cancelable);
			
			this.frameButton = $frameButton;
			this.id = $id;
		}
		
	}
}