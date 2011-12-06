package com.ddoeng.navigation
{
	import com.ddoeng.events.FrameButtonsEvent;
	import com.ddoeng.net.FONTLoader;
	import com.ddoeng.text.TextFieldSet;
	import com.ddoeng.text.TextFormatSet;
	
	import flash.accessibility.AccessibilityProperties;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 *
	 * @author : Cho Yun Gi (ddoeng@naver.com)
	 * @version : 1.0
	 * @since : Nov 17, 2010
	 * 
	 * 1. 클래스 설명
	 *		프레임메뉴로 이루어진 무비클립을 페이지기억버튼셋 묶음 생성
	 * 
	 * 2. 메소드
	 * - 리스너
	 * 		create()			:::	스테이지가 붙으면 실행
	 * 		onDown()			:::	마우스 이벤트에 대한 리스너
	 * - 내부메소드
	 * 
	 * - 외부메소드
	 * 		setDown(몇번째버튼)	::: 외부에서 클릭할 수 있게 도와주는 메소드
	 * 		getClip(몇번째버튼)	::: 외부에서 버튼Clip을 참조하게 해주는 메소드
	 * - 확장메소드
	 *		
	 */
	
	[ Event (name="buttonsetDown", type="com.ddoeng.events.FrameButtonsEvent") ]
	public class FrameButtons extends Sprite
	{
		private var Clip:Class;
		private var txtArr:Array;
		private var direct:String;
		private var overColor:uint;
		private var outColor:uint;
		
		private var sel:FrameButton;
		private var btnArr:Array;
		/**
		 * var frameBtn:FrameButtons = new FrameButtons(new RightMainMenuClip(), new Array(4), FrameButtonAlign.VERTICAL);
		 * frameBtn.addEventListener(FrameButtonsEvent.BUTTONSET_DOWN, onDown);
		 * private function onDown(e:FrameButtonsEvent):void{
		 *		trace(e.id);
		 * }
		 * 
		 * @param $className  ::: clip클래스 생성자
		 * @param $txt        ::: 각각 버튼의 레이블명은 무엇으로 할것인가
		 * @param $direct     ::: 방향은 가로로 할것인가 세로로 할것인가
		 * @param $line       ::: 라인유무
		 * @param $frame      ::: 텍스트안에 각 속성을 프레임으로 나누었을때 사용할 프레임 넘버
		 */
		public function FrameButtons($className:Object, $txt:Array, $direct:String, $overColor:uint = 0)
		{
			super();
			
			Clip  		= getDefinitionByName(getQualifiedClassName($className)) as Class;
			txtArr    	= $txt;
			direct	 	= $direct;
			overColor  = $overColor;
			
			//스테이지에 붙는 시점을 체크하지 않으면 런타임에 레프트메뉴 생성시 frame을 토대로
			//이동한 프레임에 객체들을 참조하지 못한다. 
			addEventListener(Event.ADDED_TO_STAGE, create);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//리스너/////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function create(e:Event):void
		{
			try{
				removeEventListener(Event.ADDED_TO_STAGE, create);
	
				btnArr = [];
				
				var btn:FrameButton;
				
				for(var i:int=0; i<txtArr.length; i++){
					btn    = new FrameButton(new Clip());
					btn.id = i;
					
					addChild(btn);
					
					btnArr.push(btn);
					
					//텍스트 무비클립 (레이어 최상위)
					var textMc:MovieClip = MovieClip(btn.clip.getChildAt(btn.clip.numChildren - 1));
					textMc.gotoAndStop(i+1);
			
					//아웃시의 색상 저장
					outColor = textMc.transform.colorTransform.color;
					
					//정렬
					if(direct == FrameButtonAlign.HORIZONTAL){
						btn.x = btn.width * i;
					}
					if(direct == FrameButtonAlign.VERTICAL){
						btn.y = btn.height * i;
					}
					
					btn.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
				}
			}catch(e:Error){
				trace(e.getStackTrace());
			}
		}
		
		private function onDown(e:MouseEvent):void
		{
			//같은것을 클릭한것이 아니면
			if(sel != e.currentTarget as FrameButton){
				if(sel != null){
					sel.onDefualt();
				}
				
				//저장
				sel = e.currentTarget as FrameButton;

				this.dispatchEvent(new FrameButtonsEvent(FrameButtonsEvent.BUTTONSET_DOWN, sel.id));
			}
			
			//현제 프레임버튼들에 selected 속성을 모두 변경한다.
			for(var i:int = 0; i<btnArr.length; i++){
				btnArr[i].selected = sel;
			}
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//외부메소드//////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * 외부에서 클릭할 수 있게 도와주는 메소드
		 * @param index		::: 인덱스넘버
		 */		
		public function setDown(index:int):void{
			btnArr[index].clip.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
			btnArr[index].dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
		}
		
		/**
		 * 외부에서 버튼Clip을 참조하게 해주는 메소드
		 * @param index		::: 반환받을 버튼Clip의 인덱스
		 * @return			::: 버튼Clip 반환
		 */		
		public function getClip(index:int):MovieClip
		{
			return getChildAt(index) as MovieClip;
		}
	}
}