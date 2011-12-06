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
	 * @author : Cho Yun Gi (ddoeng@naver.com)
	 * @version : 1.0
	 * @since : Nov 17, 2010
	 * 
	 * 1. 클래스 설명
	 *		LNB 기본 베이스가 되는 클래스입니다.
	 * 
	 * 2. 메소드
	 * - 리스너
	 * 		onStage()								::: 스테이지가 로드되면 실행되는 리스너
	 * 		onRemove()								::: 스테이지에서 떨어지면 실행되는 리스너
	 *		onEnter()								::: 실시간으로 상태를 파악할 엔터프레임 리스너
	 * 		onMenu()								::: 메인메뉴 기본 리스너
	 * 		onSubMenu()								::: 서브메뉴 기본 리스너
	 * - 내부메소드
	 * 		timer();								::: 타이머셋팅 메인메뉴 오버시에 발생 하는 타이머
	 * 		timerFun()								::: 타이머내용
	 * 		timeOut()								::: 타이머종료
	 * 		entStart()								::: 엔터프레임 시작. 페이지기억 체크
	 * 		entDel()								::: 엔터프레임 삭제
	 * 		tabCountPlus()							::: 텝인덱스 증가
	 * 		btnMove()								::: 버튼이동
	 * - 외부메소드
	 * 		addInit()								::: 메인메뉴 생성시 addChild 대신 사용함
	 * 		addSubInit()							::: 서브메뉴 생성시 addChild 대신 사용함
	 * 		pageMemory() 							::: 처음 플래시가 실행될때 실행시켜주는 페이지기억 함수, 기본값은 NaN
	 * 		setPageMemoryTest(1뎁스넘버, 2뎁스넘버) 	::: 페이지기억을 테스트 할수 있는 함수
	 * - 확장메소드
	 * 		exInit()								::: 스테이지가 붙은 후 처음으로 시작되는 함수
	 * 		exRemove()								::: 스테이지가 떨어져 나갈때 발생하는 함수
	 * 		exEnter() 								::: 엔터프레임에서 계속 돌아갈 기능을 추가한다.
	 * 		exPageMemory() 							::: 마우스가 아웃되었을때 페이지기억항목에서 돌아갈 기능을 추가한다.
	 * 
	 */
	
	public class LnbBase extends MovieClip
	{
		private var time:int = 39;									//마우스가 아웃시 페이지기억까지 도달할때까지의 시간
		private var timeGo:Boolean = false;							//엔터프레임중 모두 아웃되었을때를 감지하기위한 스위치변수
		private var setId:Array = [];								//2뎁스 버튼이 오버되었을때 1뎁스를 유지해줄 Interval 아이디
		public var active:Number = NaN;								//1뎁스
		public var subActive:Number = NaN;							//2뎁스
		protected var over:Number = active;							//내부 1뎁스
		protected var subOver:Number = subActive;					//내부 2뎁스
		
		//컨테이너
		protected var menuContainer:MovieClip = new MovieClip();	//메인메뉴를 담을 컨테이너
		protected var subContainer:MovieClip = new MovieClip();		//서브메뉴을 담을 컨테이너
				
		//이벤트를 가져다 쓴 메뉴들에 대한 배열
		protected var menuArr:Array = []; 							//메인메뉴
		protected var subGroupArr:Array = []; 						//서브메뉴모음
		protected var subMenuArr:Array = []; 						//서브메뉴 2차배열
		private var subMaskArr:Array = []; 							//서브메뉴 마스크
		
		private var count:int = 0; 									//메인메뉴 카운트
		private var subCount:int = 0; 								//서브메뉴 카운트
		protected var _tabCount:int = NaN; 							//텝 카운트
		
		//레이아웃에 관한 변수
		protected var _menuTotalNum:int = NaN;						//메뉴총갯수
		protected var _menuXPos:int = 0;							//메뉴 초기 시작 X위치
		protected var _menuYPos:int = 0;							//메뉴 초기 시작 Y위치
		protected var _menuOffset:int = 0;							//메뉴 간 간격
		protected var _subMenuXPos:int = 0;							//서브메뉴 초기X위치	::: xml에서 조정
		protected var _subMenuYPos:int = 0;							//서브메뉴 초기Y위치
		protected var _subMenuOffset:int = 0;						//서브메뉴 간 간격
		protected var _subGroupTopMargin:int = 0;					//서브메뉴 묶음과 메뉴의 상단거리
		protected var _subGroupBottomMargin:int = 0;				//서브메뉴 묶음과 메뉴의 하단거리
		
		/**
		 * 좌측 내비게이션에 대한 기본 뼈대이며 상속받아 사용하면 된다.
		 * 외부에서 addChild 대신 addInit, addSubInit를 해주면 자동적으로 메뉴에 대한 기본 속성이 적용이 된다.
		 * 메뉴의 간격은 텍스트필드의 사이즈와 오프셋값에 의해 결정된다.
		 * 외부에서 메뉴이벤트에서 super.onMenu(e)로 호출해주고 다른 효과는 추가 정의해주면 된다.
		 */		
		public function LnbBase()
		{
			super();
			
			if (stage) onStage();
			else addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//리스너/////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function onStage(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.showDefaultContextMenu = false;
			
			exInit();
			
			addChild(menuContainer);
			addChild(subContainer);
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
					
					if(!isNaN(subActive)){ //2뎁스 페이지기억값이 있으면
						subMenuArr[active][subActive].off() //페이지기억으로 활성화되있는것 오프
					}
					
					time = 1;
					timeGo = false;
					over = mc.id;
					
					timer();
					entStart();
					
				}else if(e.type == MouseEvent.MOUSE_OUT || e.type == FocusEvent.FOCUS_OUT){
					
					timeGo = true;
					
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
					
					if(mc.id != subActive && !isNaN(subActive)){ //이미 온 되있는것은 적용안됨
						subMenuArr[active][subActive].off() //페이지기억으로 활성화되있는것 오프
					}
					
					timeGo = false;
					subOver = mc.id;
					subMenuArr[over][subOver].on();
					
					entStart();
					
				}else if(e.type == MouseEvent.MOUSE_OUT || e.type == FocusEvent.FOCUS_OUT){
					
					timeGo = true;
					subMenuArr[over][subOver].off();
					
				}else if(e.type == MouseEvent.MOUSE_DOWN || (e.type == KeyboardEvent.KEY_DOWN && e.keyCode == 13)){
					
					trace(over, mc.id);
					
				}
			}catch(e:Error){
				trace(e.message);
			}
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//내부메소드//////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		//////////////////////////////////////////////////////////////////////////////////////////////////// 타이머
		private function timer():void{
			//trace("{Timer}");
			timeOut(over);
			setId[over] = setInterval(timerFun, 50);
		}
		
		private function timerFun():void{
			//trace("{TimerFun}");
			
			for (var i:int = 0; i < _menuTotalNum; i++) {
				//trace(i , _subOver);
				if (i == over) { 	//메인메뉴 오버시 동작
					menuArr[i].on();
				}else{ 				//메인메뉴 아웃시 동작
					menuArr[i].off();
				}
				timeOut(i); //반복삭제
			}//end for
		}
		
		private function timeOut(num:Number):void{
			//trace("{clear id:"+ setId[num]+"}");
			clearInterval(setId[num]);
			setId[num] = null;
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////// 엔터프레임
		
		private function entStart():void {
			entDel();
			addEventListener(Event.ENTER_FRAME, onEnter);
		}
		
		
		private function onEnter(e:Event):void {
			exEnter();
			btnMove(); //버튼이동
			if (timeGo) {
				time++;
				if(time == 40){
					//현제 오버한것이 페이지기억이 아닐때 버튼사라짐
					if(over != active)menuArr[over].off();
					
					//값을 변경해줌으로써 btnMove적용
					over = active;
					subOver = subActive;
					
				}
				if(time >= 60){ //btnMove가 위치를 잡을때 까지 대기하기 위함
					entDel();
					
					if(!isNaN(active))menuArr[over].dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
					if(!isNaN(active))subMenuArr[over][subOver].dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));						
					
					exPageMemory();
					
					time = 1;
					timeGo = false;
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
			var subGroupHeight:int = (!isNaN(over))?subGroupArr[over].height:0; //서브모음 높이.. 페이지기억 없으면 0
			var offset:int = 0;
			
			//메인메뉴에 대한 움직임
			for(var i:int = 0; i < _menuTotalNum; i++){
				if(i > over){ //활성화된 메뉴 아래쪽 메뉴들에 대한
					if(subGroupHeight > 0){ //서브메뉴가 한개라도 있으면
						offset = menuArr[i].defaultY + subGroupHeight + _subGroupTopMargin + _subGroupBottomMargin;
					}else{
						offset = menuArr[i].defaultY;
					}
				}else{ //활성화와 그의 위쪽 메뉴들에 대한
					offset = menuArr[i].defaultY;
				}
				
				//변하는 객체들의 모션
				menuArr[i].y += (offset - menuArr[i].y) * 0.2;
			}
			
			//서브그룹에 대한 움직임
			for(i = 0; i < _menuTotalNum; i++){
				//해당 메인메뉴 아래 붙인다.
				subGroupArr[i].y = menuArr[i].y + menuArr[i].txt.height + _subGroupTopMargin;
			}
			
			//마스크에 대한 움직임
			for(i = 0; i < _menuTotalNum; i++){
				subMaskArr[i].y = subGroupArr[i].y - _subGroupTopMargin; //마스크y 값은 항상 서브그룹y 값을 따라다닌다.
				
				if(menuArr[i+1] != undefined){ //아래메뉴와의 거리를 계산하기위해 +1 인 메뉴(아래메뉴)를 찾았을때
					subMaskArr[i].height = Math.abs(menuArr[i].y - menuArr[i+1].y) - menuArr[i].txt.height;
				}else{ //찾지 못했을때(가장 아래 메뉴에 해당되겟다)
					if(over == i){ //가장 아래메뉴는 타깃 값이 없기때문에 직접 계산한다.
						//열림
						subMaskArr[i].height += (subGroupArr[i].height - subMaskArr[i].height + _subGroupBottomMargin) * 0.2;
					}else{
						//닫힘
						subMaskArr[i].height += (0 - subMaskArr[i].height) * 0.2;
					}
				}
			}
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//외부메소드//////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * 메인메뉴 생성시 addChild 대신 사용함
		 * @param child		::: 메인 Menu 초기화
		 */	
		protected function addInit(child:MovieClip):void
		{
			child.id = count;
			menuContainer.addChild(child);
			menuArr.push(child);
			
			//액세스 가능성 도구//////////////////////////////////////
			var accessProps:AccessibilityProperties = new AccessibilityProperties();
			accessProps.name = child.txt.getChildByName("fid").text;
			child.accessibilityProperties = accessProps;
			child.tabIndex = tabCountPlus();
			
			//위치조정/////////////////////////////////////////////
			child.x = _menuXPos;
			child.y = _menuYPos;
			child.defaultY = _menuYPos;
			_menuYPos += child.txt.height + _menuOffset;
			child.bg.alpha = 0;
			
			//서브 그룹 정의 및 초기화/////////////////////////////////
			var group:MovieClip = new MovieClip();
			subContainer.addChild(group);
			subGroupArr.push(group);
			
			//서브 그룹에 대한 마스크 /////////////////////////////////
			var mask:Sprite = new Sprite();
			mask.graphics.beginFill(0xff0000);
			mask.graphics.drawRect(0, 0, stage.stageWidth, 1);
			mask.height = 0;
			subMaskArr.push(mask);
			subContainer.addChild(mask);
			
			//서브 그룹 마스킹
			group.mask = mask;
			
			//서브아이디 카운트 초기화
			subCount = 0;
			
			//서브메뉴 2차배열 생성
			subMenuArr[count] = [];
			
			count++;
		}
		
		/**
		 * 서브메뉴 생성시 addChild 대신 사용함
		 * @param child		:::	서브 Menu 초기화
		 */
		protected function addSubInit(child:MovieClip):void
		{
			child.id = subCount;
			
			//액세스 가능성 도구//////////////////////////////////////
			var accessProps:AccessibilityProperties = new AccessibilityProperties();
			accessProps.name = child.txt.getChildByName("fid").text;
			child.accessibilityProperties = accessProps;
			child.tabIndex = tabCountPlus();
			
			//위치조정/////////////////////////////////////////////
			child.x = _subMenuXPos;
			child.y = _subMenuYPos;
			_subMenuYPos += child.txt.height + _subMenuOffset;
			child.bg.alpha = 0;
			
			subGroupArr[count-1].addChild(child);
			subMenuArr[count-1].push(child);
			
			subCount++;
		}

		/**
		 * 처음 플래시가 실행될때 실행시켜주는 페이지기억 함수, 기본값은 NaN
		 */	
		protected function pageMemory():void
		{
			if(!isNaN(active) && !isNaN(subActive)){
				timeGo = true;
				//timer();
				entStart();
			}
		}

		/**
		 * 페이지기억을 테스트 할수 있는 함수
		 * @param one		::: 원 뎁스
		 * @param two		::: 투 뎁스
		 */
		protected function setPageMemoryTest(one:int, two:int):void
		{
			active = one;
			subActive = two;
			over = active;
			subOver = subActive;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//확장메소드//////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
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
