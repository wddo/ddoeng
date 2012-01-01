package com.ddoeng.utils
{
	import flash.system.Capabilities;
	import flash.system.Security;
	
	/**
	 * 
	 * 환경에 대한 클래스
	 * 
	 * @author : Jo Yun Ki (naver ID - ddoeng)
	 * @version : 1.0
	 * @since : Mar 7, 2011
	 * 
	 */
	
	public class SystemUtil
	{
		/**
		 * 브라우저에서 실행되는가
		 * @return	::: 블린
		 */		
		public static function isBrowser():Boolean {
			if(Capabilities.playerType == "ActiveX" || Capabilities.playerType == "PlugIn") return true;
			else return false;
		}
		
		/**
		 * 웹에서 실행되는가
		 * @return	::: 블린
		 */	
		public static function isWeb():Boolean {
			return (Security.sandboxType == Security.REMOTE)? true : false;
		}
		
		/**
		 * 로컬에서 실행되는가
		 * @return	::: 블린
		 */	
		public static function isLocal():Boolean {
			if(Capabilities.playerType == "StandAlone" || Capabilities.playerType == "External") return true;
			else return false;
		}
	}
}