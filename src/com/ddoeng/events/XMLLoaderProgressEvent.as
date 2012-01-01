package com.ddoeng.events
{
	import flash.events.ProgressEvent;

	public class XMLLoaderProgressEvent extends ProgressEvent
	{
		public static const LOADXML_PROGRESS:String = "loadxmlProgress";
		
		public var percent:Number;	//다운로드된 퍼센트 변수
		
		public function XMLLoaderProgressEvent($type:String, $percent:Number, $bubbles:Boolean=false, $cancelable:Boolean=false)
		{
			super($type, $bubbles, $cancelable);

			this.percent = $percent;
		}
		
	}
}