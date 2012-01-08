package com.ddoeng.navigation
{
	import com.ddoeng.events.navigation.FrameButtonsEvent;
	import com.ddoeng.net.FONTLoader;
	import com.ddoeng.text.TextFieldSet;
	import com.ddoeng.text.TextFormatSet;
	import com.ddoeng.utils.Common;
	
	import flash.accessibility.AccessibilityProperties;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.controls.Button;

	[ Event (name="buttonsetDown", type="com.ddoeng.events.navigation.FrameButtonsEvent") ]
	
	/**
	 *
	 * 프레임메뉴로 이루어진 무비클립을 페이지기억버튼셋 묶음 생성
	 * 
	 * @author : Jo Yun Ki (naver ID - ddoeng)
	 * @version : 1.0
	 * @since : Nov 17, 2010
	 * 
	 */
	
	public class FrameButtonSet extends Sprite
	{
		private var ClipClass:Class;
		private var _txtArr:Array;
		private var _direct:String;
		private var _txtfid:TextFieldSet;
		
		private var _selectedFrameButton:FrameButton;
		private var _btnArr:Array = [];
		
		/**
		 *	var clip:FrameButtonClip = new FrameButtonClip();
		 *	var frameButtonSet:FrameButtonSet = new FrameButtonSet(clip, ["버튼1", "버튼2", "버튼3", "버튼4", "버튼5"], txtFidSet, FrameButtonAlign.VERTICAL);
		 *	addChild(frameButtonSet);
		 * 	frameButtonSet.addEventListener(FrameButtonsEvent.BUTTONSET_DOWN, onClick);
		 * 
		 * @param $className	::: clip클래스 생성자
		 * @param $txt        	::: 각각 버튼의 레이블명이나 버튼에 맞는 갯수의 배열
		 * @param $txtfid		::: 텍스트 필드 셋
		 * @param $direct   	::: 방향은 가로로 할것인가 세로로 할것인가
		 */
		public function FrameButtonSet($className:Object, $txt:Array = null, $txtfid:TextFieldSet = null, $direct:String = "horizontal")
		{
			super();
			
			ClipClass  = getDefinitionByName(getQualifiedClassName($className)) as Class;
			_txtArr    	= $txt;
			_txtfid		= $txtfid;
			_direct	 	= $direct;
			
			//스테이지에 붙는 시점을 체크하지 않으면 런타임에 레프트메뉴 생성시 frame을 토대로
			//이동한 프레임에 객체들을 참조하지 못한다.
			if(stage) init(null);
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			initUI();
		}
		
		private function initUI():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initUI);
			
			var btn:FrameButton;
			
			for(var i:int=0; i<_txtArr.length; i++){
				btn = new FrameButton(new ClipClass());
				addChild(btn);
				
				btn.setId(i);
				btn.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
				
				var clip:MovieClip = btn.getClip() as MovieClip;
				var txt:MovieClip;
				
				if(clip.getChildByName("txt") != null){
					txt = clip.getChildByName("txt") as MovieClip;
					
					if(_txtArr == null || _txtfid == null){
						if(txt.currentFrame > 1)txt.gotoAndStop(i+1);
					}else{
						Common.setTargetClear(txt);
						
						var fid:TextFieldSet = new TextFieldSet(_txtfid.getTextFormat(), _txtfid.isEmbed(), _txtArr[i], _txtfid.scaleX, _txtfid.autoSize, _txtfid.selectable);
						if(_txtfid.isEmbed())fid.setRuntimeEmbed(_txtfid.getFontLoader());
						txt.addChild(fid);
						
						fid.x = _txtfid.x;
						fid.y = _txtfid.y;
						fid.name = "txt";
					}
				}

				//정렬
				if(_direct == FrameButtonAlign.HORIZONTAL)btn.x = btn.width * i;
				if(_direct == FrameButtonAlign.VERTICAL)btn.y = btn.height * i;

				_btnArr.push(btn);
			}
		}
		
		private function onDown(e:MouseEvent):void
		{
			//같은것을 클릭한것이 아니면
			if(_selectedFrameButton != e.currentTarget as FrameButton){
				if(_selectedFrameButton != null)_selectedFrameButton.setBf();
				
				//저장
				_selectedFrameButton = e.currentTarget as FrameButton;

				var idx:int = _selectedFrameButton.getId();
				this.dispatchEvent(new FrameButtonsEvent(FrameButtonsEvent.BUTTONSET_DOWN, _selectedFrameButton, idx));
			}
			
			//현제 프레임버튼들에 selected 속성을 모두 변경한다.
			var frameButton:FrameButton;
			for(var i:int = 0; i<_btnArr.length; i++){
				frameButton = _btnArr[i] as FrameButton;
				frameButton.setSelected(_selectedFrameButton);
			}
		}
		
		/**
		 * 외부에서 클릭할 수 있게 도와주는 메소드
		 * @param $idx		::: 인덱스넘버
		 */		
		public function setDown($idx:int):void{
			var frameButton:FrameButton = _btnArr[$idx] as FrameButton;
			
			frameButton.getClip().dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
			frameButton.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
		}
		
		/**
		 * 외부에서 버튼Clip을 참조하게 해주는 메소드
		 * @param $idx		::: 반환받을 버튼ClipClass의 인덱스
		 * @return			::: 버튼ClipClass 반환
		 */		
		public function getClip($idx:int):MovieClip
		{
			return getChildAt($idx) as MovieClip;
		}
	}
}