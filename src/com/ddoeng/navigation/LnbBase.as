package com.ddoeng.navigation
{
	import flash.accessibility.AccessibilityProperties;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/**
	 *
	 * LNB 기본 베이스가 되는 클래스입니다.
	 *  - 좌측 내비게이션에 대한 기본 뼈대이며 상속받아 사용하면 된다.
	 *  - 외부에서 addChild 대신 addInit, addSubInit를 해주면 자동적으로 메뉴에 대한 기본 속성이 적용이 된다.
	 * 	- 메뉴의 간격은 텍스트필드의 사이즈와 오프셋값에 의해 결정된다.
	 *  - 예를들어 _menuOffsetY = 10 이면 메인메뉴 상하 각각 5px 벌려진다.
	 * 	- 외부에서 메뉴이벤트에서 super.onMenu(e)로 호출해주고 다른 효과는 추가 정의해주면 된다.
	 * 
	 * @author : Jo Yun Ki (naver ID - ddoeng)
	 * @version : 1.0
	 * @since : Nov 17, 2010
	 * 
	 */
	
	public class LnbBase extends MovieClip
	{
		private var _time:int = 40;									//마우스가 아웃시 페이지기억까지 도달할때까지의 시간
		private var _timeGo:Boolean = false;						//엔터프레임중 모두 아웃되었을때를 감지하기위한 스위치변수
		private var _setId:Array = [];								//2뎁스 버튼이 오버되었을때 1뎁스를 유지해줄 Interval 아이디
		protected var _active:Number = NaN;							//1뎁스
		protected var _subActive:Number = NaN;						//2뎁스
		protected var _over:Number = _active;						//내부 1뎁스
		protected var _subOver:Number = _subActive;					//내부 2뎁스
		
		//컨테이너
		protected var _menuContainer:MovieClip = new MovieClip();	//메인메뉴를 담을 컨테이너
		protected var _subContainer:MovieClip = new MovieClip();	//서브메뉴을 담을 컨테이너
				
		//이벤트를 가져다 쓴 메뉴들에 대한 배열
		protected var _menuArr:Array = []; 							//메인메뉴
		protected var _subGroupArr:Array = []; 						//서브메뉴모음
		protected var _subMenuArr:Array = []; 						//서브메뉴 2차배열
		private var _subMaskArr:Array = []; 						//서브메뉴 마스크
		
		private var _count:int = 0; 								//메인메뉴 카운트
		private var _subCount:int = 0; 								//서브메뉴 카운트
		protected var _tabCount:int = NaN; 							//텝 카운트
		
		//레이아웃에 관한 변수
		protected var _menuTotalNum:int = NaN;						//메뉴총갯수
		protected var _menuXPos:int = 0;							//메뉴 초기 시작 X위치
		protected var _menuYPos:int = 0;							//메뉴 초기 시작 Y위치
		protected var _menuOffsetX:int = 0;							//메뉴 간 좌우 간격
		protected var _menuOffsetY:int = 0;							//메뉴 간 상하 간격
		protected var _subMenuXPos:int = 0;							//서브메뉴 초기X위치	::: xml에서 조정
		protected var _subMenuYPos:int = 0;							//서브메뉴 초기Y위치
		protected var _subMenuOffsetX:int = 0;						//서브메뉴 간 좌우 간격
		protected var _subMenuOffsetY:int = 0;						//서브메뉴 간 상하 간격
		protected var _subGroupTopMargin:int = 0;					//서브메뉴 묶음과 메뉴의 상단거리
		protected var _subGroupBottomMargin:int = 0;				//서브메뉴 묶음과 메뉴의 하단거리
		
		public function LnbBase()
		{
			super();
			
			if (stage) onStage();
			else addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		private function onStage(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.showDefaultContextMenu = false;
			
			exInit();
			
			addChild(_menuContainer);
			addChild(_subContainer);
		}
		
		private function onRemove(e:Event = null):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			removeEventListener(Event.ENTER_FRAME, onEnter);
			
			exRemove();
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////// 메인 이벤트
		protected function onMenu(e:*):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			
			try{
				
				if(e.type == MouseEvent.MOUSE_OVER || e.type == FocusEvent.FOCUS_IN){
					
					if(!isNaN(_subActive)){ //2뎁스 페이지기억값이 있으면
						_subMenuArr[_active][_subActive].setOff() //페이지기억으로 활성화되있는것 오프
					}
					
					_time = 1;
					_timeGo = false;
					_over = mc.id;
					
					timer();
					entStart();
					
				}else if(e.type == MouseEvent.MOUSE_OUT || e.type == FocusEvent.FOCUS_OUT){
					
					_timeGo = true;
					
				}else if(e.type == MouseEvent.MOUSE_DOWN || (e.type == KeyboardEvent.KEY_DOWN && e.keyCode == 13)){
					
					trace(mc.id);
					
				}
				
			}catch(e:Error){
				trace(e.message);
			}
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////// 서브 이벤트
		protected function onSubMenu(e:*):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			
			try{
				if(e.type == MouseEvent.MOUSE_OVER || e.type == FocusEvent.FOCUS_IN){
					
					if(mc.id != _subActive && !isNaN(_subActive)){ //이미 온 되있는것은 적용안됨
						_subMenuArr[_active][_subActive].setOff() //페이지기억으로 활성화되있는것 오프
					}
					
					_timeGo = false;
					_subOver = mc.id;
					_subMenuArr[_over][_subOver].setOn();
					
					entStart();
					
				}else if(e.type == MouseEvent.MOUSE_OUT || e.type == FocusEvent.FOCUS_OUT){
					
					_timeGo = true;
					_subMenuArr[_over][_subOver].setOff();
					
				}else if(e.type == MouseEvent.MOUSE_DOWN || (e.type == KeyboardEvent.KEY_DOWN && e.keyCode == 13)){
					
					trace(_over, mc.id);
					
				}
			}catch(e:Error){
				trace(e.message);
			}
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////// 타이머
		private function timer():void{
			//trace("{Timer}");
			timeOut(_over);
			_setId[_over] = setInterval(timerFun, 50);
		}
		
		private function timerFun():void{
			//trace("{TimerFun}");
			
			for (var i:int = 0; i < _menuTotalNum; i++) {
				//trace(i , _subOver);
				if (i == _over) { 	//메인메뉴 오버시 동작
					_menuArr[i].setOn();
				}else{ 				//메인메뉴 아웃시 동작
					_menuArr[i].setOff();
				}
				timeOut(i); //반복삭제
			}//end for
		}
		
		private function timeOut(num:Number):void{
			//trace("{clear id:"+ setId[num]+"}");
			clearInterval(_setId[num]);
			_setId[num] = null;
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////// 엔터프레임
		
		private function entStart():void {
			entDel();
			addEventListener(Event.ENTER_FRAME, onEnter);
		}
		
		
		private function onEnter(e:Event):void {
			exEnter();
			btnMove(); //버튼이동
			if (_timeGo) {
				_time++;
				if(_time == 40){
					//현제 오버한것이 페이지기억이 아닐때 버튼사라짐
					if(_over != _active && _over < _menuTotalNum)_menuArr[_over].setOff();
					
					//값을 변경해줌으로써 btnMove적용
					_over = _active;
					_subOver = _subActive;
					
				}
				if(_time >= 60){ //btnMove가 위치를 잡을때 까지 대기하기 위함
					entDel();
					
					if(!isNaN(_active) && _menuArr[_over] != undefined)_menuArr[_over].dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
					if(!isNaN(_active) && _subMenuArr[_over][_subOver] != undefined)_subMenuArr[_over][_subOver].dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));						
					
					exPageMemory();
					
					_time = 1;
					_timeGo = false;
				}
			}
		}
		
		private function entDel():void{
			if (hasEventListener(Event.ENTER_FRAME)){
				removeEventListener(Event.ENTER_FRAME, onEnter);
			}
		}
		
		private function tabCountPlus():int
		{
			if(isNaN(_tabCount)){
				_tabCount = 0;
			}else{
				_tabCount++;
			}
			
			return _tabCount
		}
		
		private function btnMove():void
		{
			var subGroupHeight:int = (!isNaN(_over))?_subGroupArr[_over].height:0; //서브모음 높이.. 페이지기억 없으면 0
			var offset:int = 0;
			
			var mainMenu:MainMenu;
			var subMenuGroup:Sprite;
			var subMenuMask:Sprite;
			var mainMenuNext:MainMenu;
			
			//메인메뉴에 대한 움직임
			for(var i:int = 0; i < _menuTotalNum; i++){
				mainMenu = _menuArr[i];
				subMenuGroup = _subGroupArr[i];
				subMenuMask = _subMaskArr[i];
				mainMenuNext = _menuArr[i+1];
				
				if(i > _over){ //활성화된 메뉴 아래쪽 메뉴들에 대한
					if(subGroupHeight > 0){ //서브메뉴가 한개라도 있으면
						offset = mainMenu.defaultY + subGroupHeight + _subGroupTopMargin + _subGroupBottomMargin;
					}else{
						offset = mainMenu.defaultY;
					}
				}else{ //활성화와 그의 위쪽 메뉴들에 대한
					offset = mainMenu.defaultY;
				}
				
				//메인메뉴에 대한 움직임
				mainMenu.y += (offset - mainMenu.y) * 0.2;
				
				//서브그룹에 대한 움직임
				subMenuGroup.y = Math.floor(mainMenu.y) + mainMenu.getBackgoundMovieClip().height + _subGroupTopMargin;
				
				//마스크에 대한 움직임
				subMenuMask.y = subMenuGroup.y - _subGroupTopMargin; //마스크y 값은 항상 서브그룹y 값을 따라다닌다.
				
				if(mainMenuNext != null){ //아래메뉴와의 거리를 계산하기위해 +1 인 메뉴(아래메뉴)를 찾았을때
					subMenuMask.height = Math.abs(mainMenu.y - mainMenuNext.y) - mainMenu.getBackgoundMovieClip().height;
				}else{ //찾지 못했을때(가장 아래 메뉴에 해당되겟다)
					if(_over == i){ //가장 아래메뉴는 타깃 값이 없기때문에 직접 계산한다.
						//열림
						subMenuMask.height += ((subMenuGroup.height + _subGroupTopMargin + _subGroupBottomMargin) - subMenuMask.height) * 0.2;
					}else{
						//닫힘
						subMenuMask.height += (0 - subMenuMask.height) * 0.2;
					}
				}
			}//end for
		}
		
		/**
		 * 메인메뉴 생성시 addChild 대신 사용함
		 * @param child		::: 메인 Menu 초기화
		 */	
		protected function addInit(child:MainMenu):void
		{
			child.id = _count;
			_menuContainer.addChild(child);
			_menuArr.push(child);
			
			//액세스 가능성 도구//////////////////////////////////////
			var accessProps:AccessibilityProperties = new AccessibilityProperties();
			accessProps.name = child.getTextField().text;
			child.accessibilityProperties = accessProps;
			child.tabIndex = tabCountPlus();
			
			//위치조정/////////////////////////////////////////////
			child.x = _menuXPos;
			child.y = _menuYPos;
			child.defaultY = _menuYPos;
			_menuYPos += child.getTextMovieClip().height + _menuOffsetY;
			
			//서브 그룹 정의 및 초기화/////////////////////////////////
			var group:MovieClip = new MovieClip();
			_subContainer.addChild(group);
			_subGroupArr.push(group);
			
			//서브 그룹에 대한 마스크 /////////////////////////////////
			var mask:Sprite = new Sprite();
			mask.graphics.beginFill(0xff0000);
			mask.graphics.drawRect(0, 0, stage.stageWidth, 1);
			mask.height = 0;
			_subMaskArr.push(mask);
			_subContainer.addChild(mask);
			
			//서브 그룹 마스킹
			group.mask = mask;
			
			//서브아이디 카운트 초기화
			_subCount = 0;
			
			//서브메뉴 2차배열 생성
			_subMenuArr[_count] = [];
			
			_count++;
		}
		
		/**
		 * 서브메뉴 생성시 addChild 대신 사용함
		 * @param child		:::	서브 Menu 초기화
		 */
		protected function addSubInit(child:SubMenu):void
		{
			child.id = _subCount;
			
			//액세스 가능성 도구//////////////////////////////////////
			var accessProps:AccessibilityProperties = new AccessibilityProperties();
			accessProps.name = child.getTextField().text;
			child.accessibilityProperties = accessProps;
			child.tabIndex = tabCountPlus();
			
			//위치조정/////////////////////////////////////////////
			child.x = _subMenuXPos;
			child.y = _subMenuYPos;
			_subMenuYPos += child.getTextMovieClip().height + _subMenuOffsetY;
			
			_subGroupArr[_count-1].addChild(child);
			_subMenuArr[_count-1].push(child);
			
			_subCount++;
		}

		/**
		 * 외부 재정렬
		 */		
		protected function setMenuInitPosition():void
		{
			if(_menuArr.length > 0){
				_menuXPos = _menuArr[0].x;
				_menuYPos = _menuArr[0].y;
				
				for(var i:int=0; i<_menuArr.length; i++){
					var menu:MainMenu = _menuArr[i] as MainMenu;
					menu.x = _menuXPos;
					menu.y = _menuYPos;
					menu.defaultY = _menuYPos;
					
					_menuYPos += menu.getTextMovieClip().height + _menuOffsetY;

					if(_subMenuArr[i][0] != null)_subMenuXPos = _subMenuArr[i][0].x;
					if(_subMenuArr[i][0] != null)_subMenuYPos = _subMenuArr[i][0].y;
					for(var s:int=0; s<_subMenuArr[i].length; s++){
						var submenu:SubMenu = _subMenuArr[i][s] as SubMenu;
						submenu.x = _subMenuXPos;
						submenu.y = _subMenuYPos;
						
						_subMenuYPos += submenu.getTextMovieClip().height + _subMenuOffsetY;
					}
				}
			}
		}
		
		/**
		 * 처음 플래시가 실행될때 실행시켜주는 페이지기억 함수, 기본값은 NaN
		 */	
		protected function pageMemory():void
		{
			if(!isNaN(_active) && !isNaN(_subActive)){
				_timeGo = true;
				entStart();
			}
		}

		/**
		 * 페이지기억을 테스트 할수 있는 함수
		 * @param one		::: 원 뎁스
		 * @param two		::: 투 뎁스
		 */
		protected function pageMemoryTest(one:int, two:int):void
		{
			_active = one;
			_subActive = two;
			_over = _active;
			_subOver = _subActive;
		}
		
		/**
		 * 스테이지가 붙은 후 처음으로 시작되는 함수
		 */		
		public function exInit():void{}
		
		/**
		 * 스테이지가 떨어져 나갈때 발생하는 함수
		 */	
		public function exRemove():void{}
		
		/**
		 * 엔터프레임에서 계속 돌아갈 기능을 추가한다.
		 */		
		public function exEnter():void{}
		
		/**
		 * 마우스가 아웃되었을때 페이지기억항목에서 돌아갈 기능을 추가한다.
		 */	
		public function exPageMemory():void{}
	}
}
