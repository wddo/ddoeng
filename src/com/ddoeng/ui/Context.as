package com.ddoeng.ui
{
	import flash.display.DisplayObjectContainer;
	import flash.events.ContextMenuEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	/**
	 *
	 * 컨텍스트
	 *
	 * @author : Jo Yun Ki (naver ID - ddoeng)
	 * @version : 1.0
	 * @since : Mar 22, 2012
	 *
	 */
	
	public class Context
	{	
		public function Context()
		{
		
		}

		public static function addContextMenu($scope:DisplayObjectContainer, $label:String, $fun:Function):void {
			var scope:DisplayObjectContainer = $scope;
			var label:String = $label;
			var fun:Function = $fun;

			//context가 없으면 생성을 하고 있다면 원래 있던것을 대입
			var contextMenu:ContextMenu = (scope.contextMenu == null)?new ContextMenu():scope.contextMenu;
			contextMenu.hideBuiltInItems();
			scope.contextMenu = contextMenu;
			
			if(ContextMenu.isSupported || scope.stage != null){
				//리스트 생성
				var item:ContextMenuItem = new ContextMenuItem(label);
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, fun);
				
				//추가
				contextMenu.customItems.push(item);
			}
		}
	}
}