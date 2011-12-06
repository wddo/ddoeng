package com.ddoeng.net
{	
	import flash.display.Loader;

	/**
	 *
	 * @author : Cho Yun Gi
	 * @version : 1.0
	 * @since : Nov 17, 2010
	 * 
	 * 1. 클래스 설명
	 *		IMGLoader 에서 사용하는 로더
	 * 2. 메소드
	 * - 리스너
	 * 
	 * - 내부메소드
	 * 
	 * - 외부메소드
	 * 		setget id		:::	아이디 지정,반환
	 * - 확장메소드
	 * 
	 */
	
	public class DynamicLoader extends Loader
	{
		private var _id:int;	//아이디
		
		public function DynamicLoader()
		{
			super();
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//외부메소드//////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * 아이디 지정,반환
		 */		
		public function set id(n:int):void
		{
			_id = n;
		}
		
		public function get id():int
		{
			return _id;	
		}
	}
}