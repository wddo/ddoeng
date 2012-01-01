package com.ddoeng.utils
{
	import com.ddoeng.utils.SystemUtil;
	
	import flash.display.Stage;
	import flash.system.Capabilities;
	import flash.system.Security;
	
	/**
	 * 
	 * 위치값에 대한 유틸 클래스	
	 * 
	 * @author : Jo Yun Ki (naver ID - ddoeng)
	 * @version : 1.0
	 * @since : Mar 7, 2011
	 * 
	 */
	
	public class LocationUtil
	{
		/**
		 * 인자가 참조하는 스테이지 찾기
		 * @param $scope	:::	시작하는 타겟
		 * @return 			::: 스테이지
		 * 
		 */		
		public static function getStageSearch($scope:Object):Stage
		{
			var obj:Object = $scope;
			
			while(obj.parent != null){
				obj = obj.parent;
			}
			
			return Stage(obj);
		}
		
		/**
		 * 도큐멘트클래스 인가
		 * @param $scope	::: 호출하는 클래스 자신	
		 * @return 			::: 블린
		 */		
		public static function isDocumentClass($scope:Object):Boolean
		{
			return ($scope.parent != null && $scope.parent.toString() == "[object Stage]")
		}
		
		/**
		 * 로컬과 웹에 다른 파일 경로를 지정
		 * @param $localPath	::: 로컬 파일 경로
		 * @param $serverPath	::: 웹 파일 경로
		 * @param $domain		::: 도메인
		 * @return 				::: 대응하는 경로
		 */		
		public static function setFilePath($localPath:String, $serverPath:String):String
		{
			var filePath:String;
			
			//html 붙어있을때
			if(SystemUtil.isBrowser()){
				if(SystemUtil.isWeb()){ 				//웹상이면
					filePath = $serverPath;
				}else{									//로컬이면
					filePath = $localPath;
				}
				
			//단독 로컬 실행 이면
			}else if(SystemUtil.isLocal()){
				filePath = $localPath;
			}
			
			return filePath;
		}					
	}
}