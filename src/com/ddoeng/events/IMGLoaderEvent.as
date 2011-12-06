package com.ddoeng.events
{
	import com.ddoeng.net.DynamicLoader;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	public class IMGLoaderEvent extends Event
	{
		public static const IMAGELOAD_COMPLETE:String = "imageloadComplete";

		public var loader:DynamicLoader;	//다이나믹로더
		public var mtarget:Array;			//이미지를 로드할 타겟
		public var isAll:Boolean;			//다중 로드시 모두 로드했는지 유무를 알려줄 변수

		public function IMGLoaderEvent(type:String, target:Array, loader:DynamicLoader, all:Boolean = false, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.loader = loader;
			this.mtarget = target;
			this.isAll = all;
		}
		
	}
}