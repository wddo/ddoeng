package com.ddoeng.events.net
{
	import flash.events.ProgressEvent;

	public class SWFLoaderProgressEvent extends ProgressEvent
	{
		public static const LOADSWF_PROGRESS:String = "loadswfProgress";
		
		public var percent:Number;	//다운로드된 퍼센트 변수
		
		public function SWFLoaderProgressEvent($type:String, $percent:Number, $bubbles:Boolean=false, $cancelable:Boolean=false)
		{
			super($type, $bubbles, $cancelable);

			this.percent = $percent;
		}
		
	}
}