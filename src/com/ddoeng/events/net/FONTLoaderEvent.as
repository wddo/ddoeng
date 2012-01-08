package com.ddoeng.events.net
{
	import flash.events.Event;

	public class FONTLoaderEvent extends Event
	{
		public static const FONTLOAD_COMPLETE:String = "fontloadComplete";
		
		public function FONTLoaderEvent($type:String, $bubbles:Boolean=false, $cancelable:Boolean=false)
		{
			super($type, $bubbles, $cancelable);
		}
	}
}