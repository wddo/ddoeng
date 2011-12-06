package com.ddoeng.events
{
	import flash.display.MovieClip;
	import flash.events.Event;

	public class SWFLoaderEvent extends Event
	{
		public static const LOADSWF_COMPLETE:String = "loadswfComplete";
		
		public var timeline:MovieClip;	//타임라인
		public var url:String;			//swf파일 경로
		
		public function SWFLoaderEvent($type:String, $target:Object, $url:String, $bubbles:Boolean=false, $cancelable:Boolean=false)
		{
			super($type, $bubbles, $cancelable);
			
			this.timeline = $target.content as MovieClip;
			this.url = $url;
		}
		
	}
}