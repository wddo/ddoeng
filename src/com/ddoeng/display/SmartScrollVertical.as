package com.ddoeng.display
{
	import com.ddoeng.events.SWFLoaderEvent;
	import com.ddoeng.net.SWFLoader;
	import com.ddoeng.utils.Calculation;
	import com.ddoeng.utils.Common;
	
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	
	
	/**
	 *
	 * @author : Cho Yun Gi (ddoeng@naver.com)
	 * @version : 1.0
	 * @since : Dec 27, 2010
	 * 
	 * 1. 클래스 설명
	 *		가로 스크롤 클래스
	 * 2. 메소드
	 * - 리스너
	 * 		onDown()								::: 스크롤바 다운
	 * 		onMove()								::: 스크롤바 다운후 이동
	 * 		onContentDown()							::: 컨텐츠 터치
	 * 		onContentMove()							::: 컨텐츠 터치후 이동
	 * 		onMouseWheel()							::: 마우스 휠
	 * 		stageUp()								::: 스테이지 업(releaseOutside 대처)
	 * 		onEnter()								::: 이동 총괄 컨트롤할 엔터프레임
	 *		onComplete()							:::	컨텐츠 로드 완료
	 * - 내부메소드
	 * 		setLayout()								::: 레이아웃 설정
	 * 		addEvent()								::: 이벤트리스너 설정
	 * 		gradientMaskCreate()					:::	마스크 그라데이션 생성
	 * 		gradientCreate(폭, 높이, 페이드인아웃 크기)	::: 좌우 페이드아웃 되는 그라데이션
	 * - 외부메소드
	 * 		init(컨텐츠, 스크롤, bg인스명, bar인스명)	::: 초기 설정
	 * 		load(로드컨텐츠 경로)						::: 컨텐츠 로드
	 *   	add(추가할 디스플레이 요소)					::: 컨텐츠 삽입
	 * 		setget gradient()						:::	그라데이션 넓이
	 * 		setget contentWidth()					::: 컨텐츠 넓이
	 * 		setget barResize()						:::	스크롤바 리사이즈 유무
	 * 		setget type()							::: 컨트롤 타입 [ 타입: 0(drag,wheel,touch), 1(drag,wheel), 2(touch) ]
	 * 		setget speed()							::: 가속공식 속도 (기본값 0.16)
	 * 		setInit()								::: 외부에서 호출할수 있는 초기화 함수
	 * 		dispose()								::: 파괴
	 * - 확장메소드
	 *		
	 */
	public class SmartScrollVertical extends Sprite
	{
		private var content:Sprite;							//컨텐츠
		private var contentSource:MovieClip;				//컨텐츠소스
		private var contentMask:Sprite;						//컨텐츠마스크
		private var scroll:Sprite;							//스크롤셋
		private var scrollBg:Sprite;						//스크롤바 배경라인
		private var scrollBar:Sprite;						//스크롤바
		private var mStage:Stage;							//스테이지

		private var gradientWidth:int = 0; 					//마스크의 그라데이션 높이
		private var contWidth:int = 200; 					//컨텐츠가 실제로 보여질 높이
		private var contentTargetX:int = 0; 				//목표위치값 저장
		private var barDefaultWidth:int = 0;				//바 기본 넓이
		private var whellSpeed:int = 10; 					//휠 속도
		private var mSpeed:Number = .16;					//가속공식 속도

		private var isBarResize:Boolean = false;			//스클롤바 리사이징 유무
		private var mType:int = 0;							//컨트롤 타입
		
		private var scrollState:String = "drag";			//스크롤하는 장치
		private var cal:Calculation = new Calculation();	//1차원함수계산
		
		private var isTouchDown:Boolean = false;			//터치 유무
		private var unlockCenterX:int = 0;					//터치후 드래그시 소스중앙과 마우스포인트의 차이
		private var touchContentTargetX:int = 0;			//터치 목표위치값 저장
		
		//설명
		//구분//////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////////////////////// 생성자	
		/**
		 * 	var scrollVertical:SmartScrollVertical = new SmartScrollVertical();
		 *	scrollVertical.init(content_mc, scroll_mc, "bg_mc", "bar_mc");
		 *	scrollVertical.gradient = 0;
		 *	scrollVertical.barResize = false;
		 *	scrollVertical.contentWidth = 200;
		 *	scrollVertical.type = 0;
		 *	scrollVertical.load("assets/cont.swf"); //scrollVertical.add(DisplayObject);
		 */
		public function SmartScrollVertical()
		{

		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//리스너/////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		//////////////////////////////////////////////////////////////////////////////////////////////////// 스크롤
		private function onDown(e:MouseEvent):void
		{
			scrollState = "drag";
			
			scrollBar.startDrag(false, new Rectangle(0, scrollBar.y, scrollBg.width - scrollBar.width, 0));
			if(mStage == null)mStage = content.stage;
			mStage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			mStage.addEventListener(MouseEvent.MOUSE_UP, stageUp);
		}
		
		private function onMove(e:MouseEvent):void
		{
			//컨텐츠 높이이며 그라데이션에 가려질 높이도 생각해서 더함
			var contentWidth:Number = contentSource.width + (gradientWidth * 2);
			//목표위치값
			contentTargetX = cal.getLinearFunction(0, (scrollBg.width - scrollBar.width), 0, (contentMask.width - contentWidth), scrollBar.x);
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////// 터치
		
		private function onContentDown(e:MouseEvent):void
		{
			scrollState = "touch";
			isTouchDown = true;
			unlockCenterX = contentSource.x - content.mouseX;
			
			if(mStage == null)mStage = content.stage;
			mStage.addEventListener(MouseEvent.MOUSE_UP, stageUp);
		}

		//////////////////////////////////////////////////////////////////////////////////////////////////// 휠
		private function onMouseWheel(e:MouseEvent):void
		{
			scrollState = "wheel";
			
			//컨텐츠 높이이며 그라데이션에 가려질 높이도 생각해서 더함
			var contentWidth:Number = contentSource.width + (gradientWidth * 2);
			//목표위치값
			if(contentTargetX <= 0 && contentTargetX >= contentMask.width - contentWidth){
				contentTargetX += (e.delta / 3) * whellSpeed;
			}
		}
		
		//release outside 와 release대체
		private function stageUp(e:MouseEvent):void
		{
			isTouchDown = false;
			scrollBar.stopDrag();
			if(mStage == null)mStage = content.stage;
			mStage.removeEventListener(MouseEvent.MOUSE_UP, stageUp);
			mStage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}
		
		private function onEnter(e:Event):void
		{

			//매번 마스크를 씌워줌으로써 안에서 움직임을 수시로 마스크 씌워줍니다.
			//이것을 빼면 안에 모션이 있을시에 그라마스크 경계가 깨져버립니다. 
			contentSource.mask = contentMask; //마스킹
			
			try{
				//컨텐츠 높이이며 그라데이션에 가려질 높이도 생각해서 더함
				var contentWidth:Number = contentSource.width + (gradientWidth * 2);
				
				//컨텐츠 부드러운 모션
				if(scrollState != "touch"){
					//한계점 제한
					if(contentTargetX > 0){
						contentTargetX = 0;
					}else if(contentTargetX < contentMask.width - contentWidth){
						contentTargetX = contentMask.width - contentWidth;
					}
				
					//부드러운이동
					contentSource.x += (contentTargetX - contentSource.x) * mSpeed;
				}else{
					if(isTouchDown){
						//잡았을때만 실행
						touchContentTargetX = content.mouseX - contentSource.x + unlockCenterX;
					}else{
						//한계점 제한.. 넘어가면 부드러운 이동으로 넘어감
						if(contentSource.x > 0){
							touchContentTargetX = 0;
							scrollState = "wheel";
						}else if(contentSource.x < contentMask.width - contentWidth){
							touchContentTargetX = contentMask.width - contentWidth;
							scrollState = "wheel";
						}
					}
					
					//위에서 상태가 wheel이 되면서 이 명령문은 실행하지 않음
					if(scrollState == "touch"){
						touchContentTargetX -= touchContentTargetX * .1; //저항력
						contentSource.x += touchContentTargetX; //무한이동
						
						//동기화
						contentTargetX = contentSource.x;
					}
				}

				//drag를 제외한 스크롤바 위치 동기화, 터치힘에 따른 스크롤바 크기 변경
				if(scrollState != "drag"){
					var sx:Number = cal.getLinearFunction(0, (contentMask.width - contentWidth), 0, (scrollBg.width - scrollBar.width), contentSource.x);

					if(sx < 0){
						scrollBar.width = cal.getLinearFunction(0, contentMask.width, barDefaultWidth, 10, contentSource.x);
						scrollBar.x = 0;
					}else if(sx > scrollBg.width - scrollBar.width){
						scrollBar.width = cal.getLinearFunction(contentMask.width - contentWidth, -contentSource.width, barDefaultWidth, 10, contentSource.x);
						scrollBar.x = scrollBg.width - scrollBar.width;
					}else{
						scrollBar.width = barDefaultWidth;
						scrollBar.x = sx;
					}

				}
			}catch(e:Error){
				trace(e);
				removeEventListener(Event.ENTER_FRAME, onEnter);
			}
		}
		
		//컨텐츠 로드 완료
		private function onComplete(e:SWFLoaderEvent):void
		{
			setInit();
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//내부메소드//////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////

		//레이아웃
		private function setLayout():void
		{
			//값 초기화
			contentSource.x = 0;
			scrollBg.x = 0;
			scrollBar.x = 0;
			contentTargetX = 0;
			if(content.contains(contentMask))content.removeChild(contentMask);
			
			contentMask = gradientMaskCreate(); //마스크생성
			content.addChild(contentMask);
			//contentMask.alpha = 0.5;
			
			contentSource.cacheAsBitmap = true;
			contentMask.cacheAsBitmap = true;
			contentSource.mask = contentMask; //마스킹
			
			var contentWidth:Number = contentSource.width + (gradientWidth * 2);
			barDefaultWidth = scrollBar.width;
			var barWidth:Number = scrollBg.width - Math.abs(contentMask.width - contentWidth);
			
			//스크롤바 사이즈를 리사이징 할것인가?
			if(isBarResize){
				if(barWidth > barDefaultWidth){
					scrollBar.width = barWidth;
				}else{
					scrollBar.width = barDefaultWidth;
				}
			}
			
			//컨텐츠 양에 따라 휠속도 조절
			whellSpeed = contentWidth * .1;
		}
		
		//이벤트
		private function addEvent():void
		{
			if (contentSource.width > contentMask.width){
				scroll.visible = true;
				scrollBar.buttonMode = true;
				content.buttonMode = true;
				scrollBar.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
				content.parent.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
				content.addEventListener(MouseEvent.MOUSE_DOWN, onContentDown);
				
				if(mType == 1){
					content.removeEventListener(MouseEvent.MOUSE_DOWN, onContentDown);
					content.buttonMode = false;
				}else if(mType == 2){
					scrollBar.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
					content.parent.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
					scroll.visible = false;
				}
				
				if(!hasEventListener(Event.ENTER_FRAME))
					addEventListener(Event.ENTER_FRAME, onEnter);
			}else {
				scroll.visible = false;
				scrollBar.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
				content.parent.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
				content.removeEventListener(MouseEvent.MOUSE_DOWN, onContentDown);
				if(hasEventListener(Event.ENTER_FRAME))
					removeEventListener(Event.ENTER_FRAME, onEnter);
			}
		}
		
		//마스크 그라데이션 생성
		private function gradientMaskCreate():Sprite
		{
			var width:Number = contWidth;
			var height:Number = contentSource.height;

			//그라데이션 생성
			var graSp:Sprite = gradientCreate(width, height, gradientWidth);
			graSp.x = -gradientWidth;
			
			return graSp;
		}
		
		//좌우 페이드아웃 되는 그라데이션
		private function gradientCreate(width:int, height:int, fadeSize:int):Sprite
		{
			var graRatios:Number = cal.getLinearFunction(0, width, 0, 255, fadeSize);
			
			var fillType:String = GradientType.LINEAR;
			var colors:Array = [0xFF0000, 0xFF0000, 0xFF0000, 0xFF0000];
			var alphas:Array = [0, 1, 1, 0];
			var ratios:Array = [0, graRatios, 255-graRatios, 255];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(width, height, 0);
			var spreadMethod:String = SpreadMethod.PAD;
			
			var sp:Sprite = new Sprite();
			if(fadeSize != 0){
				sp.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod); 
			}else{
				sp.graphics.beginFill(colors[0]);
			}
			sp.graphics.drawRect(0, 0, width, height);
	
			return sp;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//외부메소드//////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * 초기 설정 [ 타입: 0(drag,wheel,touch), 1(drag,wheel), 2(touch) ]
		 * @param $content	:::	컨텐츠 디스플레이 오브젝트
		 * @param $scroll	::: 스크롤 디스플레이 오브젝트
		 * @param $bgName	::: 스크롤 bg 인스턴트명
		 * @param $barName	::: 스크롤 bar 인스턴트명
		 */		
		public function init($content:Sprite, $scroll:Sprite, $bgName:String, $barName:String):void
		{
			content = $content;
			scroll = $scroll;
			scrollBg = scroll.getChildByName($bgName) as Sprite;
			scrollBar = scroll.getChildByName($barName) as Sprite;
			scroll.visible = false;
			
			contentMask = new Sprite();
			contentSource = new MovieClip();
			
			if(mStage == null)mStage = content.stage;
			
			addEventListener(Event.REMOVED_FROM_STAGE, dispose);
		}
		
		/**
		 * 컨텐츠 로드 
		 * @param src	::: 로드컨텐츠 경로
		 */		
		public function load($src:String):void
		{	
			var swfLoader:SWFLoader = new SWFLoader();
			content.addChild(contentSource);
			
			swfLoader.load(contentSource, $src, true);
			swfLoader.addEventListener(SWFLoaderEvent.LOADSWF_COMPLETE, onComplete);
		}
		
		/**
		 * 컨텐츠 삽입
		 * @param $dis	::: 추가할 디스플레이 요소
		 */		
		public function add($dis:DisplayObject):void
		{
			Common.setTargetClear(contentSource);
			contentSource.addChild($dis);
			content.addChild(contentSource);
			onComplete(null);
		}
		
		/**
		 * 타깃이동
		 * @param $n	::: 컨텐츠 x값
		 */		
		public function setTargetX($value:Number):void
		{
			contentTargetX = $value;
		}
		
		/**
		 * 그라데이션 넓이
		 */		
		public function set gradient($value:int):void
		{
			gradientWidth = $value;
		}
		
		public function get gradient():int
		{
			return gradientWidth;
		}
		
		/**
		 * 컨텐츠 넓이 
		 */		
		public function set contentWidth($value:int):void
		{
			contWidth = $value;
		}
		
		public function get contentWidth():int
		{
			return contWidth;
		}
		
		/**
		 * 스크롤바 리사이즈 유무 
		 */		
		public function set barResize($value:Boolean):void
		{
			isBarResize = $value;
		}
		
		public function get barResize():Boolean
		{
			return isBarResize;
		}
		
		/**
		 * 컨트롤 타입 [ 타입: 0(drag,wheel,touch), 1(drag,wheel), 2(touch) ]
		 */		
		public function set type($value:int):void
		{
			mType = $value;
		}
		
		public function get type():int
		{
			return mType;
		}
		
		/**
		 * 가속공식 속도 (기본값 0.16)
		 */		
		public function set speed($value:Number):void
		{
			mSpeed = $value;
		}
		
		public function get speed():Number
		{
			return mSpeed;
		}
		
		/**
		 * 초기화 
		 */		
		public function setInit():void
		{
			setLayout();
			addEvent();
		}
		
		/**
		 * 파괴 
		 */		
		public function dispose(e:Event = null):void
		{
			if(hasEventListener(Event.REMOVED_FROM_STAGE))
				removeEventListener(Event.REMOVED_FROM_STAGE, dispose);
			
			if(scrollBar.hasEventListener(MouseEvent.MOUSE_DOWN))
				scrollBar.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			
			if(content.parent.hasEventListener(MouseEvent.MOUSE_WHEEL))
				content.parent.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			
			if(content.hasEventListener(MouseEvent.MOUSE_DOWN))
				content.removeEventListener(MouseEvent.MOUSE_DOWN, onContentDown);
			
			if(hasEventListener(Event.ENTER_FRAME))
				removeEventListener(Event.ENTER_FRAME, onEnter);
			
			cal = null;
			scrollBar.buttonMode = false;
			content.buttonMode = false;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		//확장메소드//////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
	}
}