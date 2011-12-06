package com.ddoeng.events
{
	import flash.events.Event;

	public class XMLLoaderEvent extends Event
	{
		public static const LOADXML_COMPLETE:String = "loadxmlComplete";
		
		public var xml:XML;		//xml겍체
		public var url:String;	//xml경로
		
		public function XMLLoaderEvent($type:String, $xml:XML, $url:String, $bubbles:Boolean=false, $cancelable:Boolean=false)
		{
			super($type, $bubbles, $cancelable);
			
			this.xml = $xml;
			this.url = $url;
		}
	}
}