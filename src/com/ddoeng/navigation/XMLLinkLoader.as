package com.ddoeng.navigation
{	
	import com.ddoeng.events.XMLLoaderEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	/**
	 *
	 * @author : Cho Yun Gi (ddoeng@naver.com)
	 * @version : 1.0
	 * @since : Nov 17, 2010
	 * 
	 * 1. 클래스 설명
	 *		네비게이션 전용 XML 로드
	 * 
	 * 2. 메소드
	 * - 리스너
	 * 		onComplete()		::: xml로드 완료시 발생
	 * 		ioError()			:::	xml로드 io오류시 발생
	 * - 내부메소드
	 * 
	 * - 외부메소드
	 *		get home()			:::	홈 링크 반환
	 *		get gnbCount()		:::	메인메뉴 갯수 반환 . 노드들이 Left들과 같이 사용되기 때문에 추가될시 메인메뉴갯수가 같이 늘어나는것을 방지한다. 
	 *		get link()			::: 메인메뉴 링크 반환
	 * 		get utilLink()		::: 유틸 링크 반환
	 * 		get rightLink()		::: 오른쪽 링크 반환
	 * - 확장메소드
	 *		
	 */
	
	[ Event ( name="loadxmlComplete", type="com.ddoeng.events.XMLLoaderEvent") ]
	public class XMLLinkLoader extends EventDispatcher
	{
		private var homeLink:String = "";				//홈링크
		private var count:int = 0;						//다용도 카운터 변수
		private var linkArr:Array = new Array();		//링크 배열
		private var utilLinkArr:Array = new Array();	//유틸링크 배열
		//private var _rightLink:Array = new Array();
		
		private var _url:String;						//xml경로
		private var _urlLoader:URLLoader;				//로더
		
		public function XMLLinkLoader(url:String) 
		{
			_url = url;
			
			_urlLoader = new URLLoader();
			_urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			_urlLoader.addEventListener(Event.COMPLETE, onComplete);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			_urlLoader.load(new URLRequest(url));
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//리스너/////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function onComplete(e:Event):void {
			try {
				var xml:XML = new XML( _urlLoader.data );
				_urlLoader = null;
				
				var count1:int = 0;
				var count2:int = 0;
				var count3:int = 0;
				var utilcount:int = 0;
				//var rightcount:int = 0;
				
				//MainMenu
				var example:XML = new XML(e.target.data);
				homeLink = example.MainMenu.@url;
				count = int(example.MainMenu.@gnbcount);
				
				for each(var element1:XML in example.MainMenu.elements()) {
					
					linkArr.mlength = count1 + 1; //1뎁스 길이반환
					
					linkArr[count1] = { name: element1.@name, url: element1.@url, target: element1.@target, menuxpos: element1.@menuxpos};
					//trace("― linkArr" + count1 + " = " + linkArr[count1].name);
					
					for each(var element2:XML in element1.elements()) {
						
						linkArr[count1].mlength = count2 + 1; //2뎁스 길이반환
						
						linkArr[count1][count2] = { name: element2.@name, url: element2.@url, target: element2.@target };
						//trace(" └― linkArr" + count1 + "_" + count2 + " = " + linkArr[count1][count2].name);
						
						for each(var element3:XML in element2.elements()) {
							
							linkArr[count1][count2].mlength = count3 + 1; //3뎁스 길이반환
							
							linkArr[count1][count2][count3] = { name: element3.@name, url: element3.@url, target: element3.@target };
							//trace("    └― linkArr"+count1+"_"+count2+"_"+count3+" = "+linkArr[count1][count2][count3].name);

							count3++;
						}
						
						count2++;
						count3 = 0;
					}
					
					count1++;
					count2 = 0;
				}
				
				//UtilMenu
				trace("\n");
				for each(var utilelement:XML in example.UtilMenu.elements()) {
					utilLinkArr[utilcount] = { name: utilelement.@name, url: utilelement.@url, target: utilelement.@target };
					//trace("UtilLink_"+utilcount+" = "+utilLinkArr[utilcount].name);
					
					utilcount++;
				}
				
				//RightMenu
				/*
				trace("\n");
				for each(var rightelement:XML in example.RightMenu.elements()) {
					_rightLink[rightcount] = { name: rightelement.@name, url: rightelement.@url, target: rightelement.@target };
					//trace("RightLink_"+rightcount+" = "+_rightLink[rightcount].name);
					
					rightcount++;
				}
				*/
				
				var evt:XMLLoaderEvent = new XMLLoaderEvent(XMLLoaderEvent.LOADXML_COMPLETE, xml, _url);
				this.dispatchEvent( evt );
				
			}catch(e:TypeError) {
				trace("xml load Error\n" +e.message);
			}
		}
		
		private function ioError(e:IOErrorEvent):void
		{
			trace(e.text);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//외부메소드//////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * 홈 링크 반환
		 */		
		public function get home():String {
			return homeLink
		}
		
		/**
		 * 메인메뉴 갯수 반환 . 노드들이 Left들과 같이 사용되기 때문에 추가될시 메인메뉴갯수가 같이 늘어나는것을 방지한다.
		 */	
		public function get gnbCount():int {
			return count
		}

		/**
		 * 메인메뉴 링크 반환
		 */	
		public function get link():Array {
			return linkArr;
		}
		
		/**
		 * 유틸 링크 반환
		 */
		public function get utilLink():Array {
			return utilLinkArr;
		}
		
		/**
		 * 오른쪽 링크 반환
		 */
		/*
		public function get rightLink():Array {
			return _rightLink;
		}
		*/
		
	}
	
}