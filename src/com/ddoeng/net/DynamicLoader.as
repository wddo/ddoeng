package com.ddoeng.net
{	
	import flash.display.Loader;

	/**
	 *
	 * IMGLoader 에서 사용하는 로더
	 * 
	 * @author : Jo Yun Ki (naver ID - ddoeng)
	 * @version : 1.0
	 * @since : Nov 17, 2010
	 * 	
	 */
	
	public class DynamicLoader extends Loader
	{
		private var _id:int;	//아이디
		
		public function DynamicLoader()
		{
			super();
		}

		/**
		 * 아이디 지정,반환
		 */		
		public function setId(n:int):void
		{
			_id = n;
		}
		
		public function getId():int
		{
			return _id;	
		}
	}
}