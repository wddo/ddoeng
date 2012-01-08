package com.ddoeng.events.net
{
	import flash.events.ProgressEvent;

	public class FONTLoaderProgressEvent extends ProgressEvent
	{
		public static const FONTLOAD_PROGRESS:String = "fontloadProgress";
		
		public var percent:Number;	//다운로드된 퍼센트 변수
		
		public function FONTLoaderProgressEvent($type:String, $percent:Number, $bubbles:Boolean=false, $cancelable:Boolean=false)
		{
			super($type, $bubbles, $cancelable);
			
			this.percent = $percent;
		}
	}
}