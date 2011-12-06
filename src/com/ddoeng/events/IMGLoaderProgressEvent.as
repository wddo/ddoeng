package com.ddoeng.events
{
	import flash.events.ProgressEvent;

	public class IMGLoaderProgressEvent extends ProgressEvent
	{
		public static const IMAGELOAD_PROGRESS:String = "imageloadProgress";
		
		public var percent:Number;	//다운로드된 퍼센트 변수
		
		public function IMGLoaderProgressEvent($type:String, $percent:Number, $bubbles:Boolean=false, $cancelable:Boolean=false)
		{
			super($type, $bubbles, $cancelable);

			this.percent = $percent;
		}
	}
}