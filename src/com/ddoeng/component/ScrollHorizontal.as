package com.ddoeng.component
{
	import com.ddoeng.events.component.ScrollEvent;
	import com.ddoeng.events.net.SWFLoaderEvent;
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
	
	[Event (name="moveScroll", type="com.ddoeng.events.component.ScrollEvent")]
	/**
	 *
	 * 세로 스크롤 클래스
	 * 
	 * @author : Jo Yun Ki (naver ID - ddoeng)
	 * @version : 1.0
	 * @since : Dec 27, 2010
	 * 
	 */
	
	public class ScrollHorizontal extends Sprite
	{
		private var content:Sprite;							//컨텐츠
		private var contentSource:MovieClip;				//컨텐츠소스
		private var contentMask:Sprite;						//컨텐츠마스크
		private var scroll:Sprite;							//스크롤셋
		private var scrollBg:Sprite;						//스크롤바 배경라인
		private var scrollBar:Sprite;						//스크롤바
		private var mStage:Stage;							//스테이지

		private var gradientHeight:Number = 0; 				//마스크의 그라데이션 높이
		private var contHeight:int = 200; 					//컨텐츠가 실제로 보여질 높이
		private var contentTargetY:int = 0; 				//목표위치값 저장
		private var whellSpeed:int = 10; 					//휠 속도
		private var mSpeed:Number = .16;					//가속공식 속도
		private var touchContentY:Number = 0;				//최초 터치시 컨텐츠 위치값 저장
		private var touchMouseDefaultY:Number = 0;			//최초 터치시 마우스 위치값 저장
		private var barDefaultHeight:Number = 0;			//바 기본 높이
		private var contSourceHeight:Number = 0;			//컨텐츠 높이(컨텐츠 내부 모션에 따라 .height가 변경되면 스크롤이 움직이기때문에 초기에 셋팅)
		
		private var isBarResize:Boolean = false;			//스클롤바 리사이징 유무
		private var mType:int = 0;							//컨트롤 타입
		
		private var scrollState:String = "drag";			//스크롤하는 장치
		private var cal:Calculation = new Calculation();	//1차원함수계산
		
		private var mContentMargin:int = 0;					//컨텐츠 마진

		/**
		 * 	var scrollHorizontal:ScrollHorizontal = new ScrollHorizontal();
		 *	scrollHorizontal.init(content_mc, scroll_mc, "bg_mc", "bar_mc");
		 *	scrollHorizontal.gradient = 0;
		 *	scrollHorizontal.barResize = false;
		 *	scrollHorizontal.contentHeight = 200;
		 *  scrollHorizontal.contentMargin = 0;
		 *	scrollHorizontal.type = 0;
		 *	scrollHorizontal.load("assets/cont.swf"); //scrollHorizontal.add(DisplayObject);
		 */		
		public function ScrollHorizontal()
		{

		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////// 스크롤

		private function onDown(e:MouseEvent):void
		{
			scrollState = "drag";

			scrollBar.startDrag(false, new Rectangle(scrollBar.x, 0, 0, scrollBg.height - scrollBar.height));
			if(mStage == null)mStage = content.stage;
			mStage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			mStage.addEventListener(MouseEvent.MOUSE_UP, stageUp);
		}
		
		private function onMove(e:MouseEvent):void
		{
			//컨텐츠 높이이며 그라데이션에 가려질 높이도 생각해서 더함
			var contentHeight:Number = contSourceHeight + (gradientHeight * 2) + mContentMargin;
			//목표위치값
			contentTargetY = cal.getLinearFunction(0, (scrollBg.height - scrollBar.height), 0, (contentMask.height - contentHeight), scrollBar.y);
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////// 터치
		private function onContentDown(e:MouseEvent):void
		{
			scrollState = "touch";
			if(mStage == null)mStage = content.stage;
			
			touchContentY = contentSource.y;
			touchMouseDefaultY = mStage.mouseY;
			content.addEventListener(MouseEvent.MOUSE_MOVE, onContentMove);
			mStage.addEventListener(MouseEvent.MOUSE_UP, stageUp);
		}
		
		private function onContentMove(e:MouseEvent):void
		{
			if(mStage == null)mStage = content.stage;
			var cha:Number = touchMouseDefaultY - mStage.mouseY;
			
			contentTargetY = touchContentY - cha;
		}

		//////////////////////////////////////////////////////////////////////////////////////////////////// 휠
		private function onMouseWheel(e:MouseEvent):void
		{
			scrollState = "wheel";
			
			//컨텐츠 높이이며 그라데이션에 가려질 높이도 생각해서 더함
			var contentHeight:Number = contSourceHeight + (gradientHeight * 2) + mContentMargin;
			//목표위치값
			if(contentTargetY <= 0 && contentTargetY >= contentMask.height - contentHeight){
				contentTargetY += (e.delta / 3) * whellSpeed;
			}
		}
		
		//release outside 와 release대체
		private function stageUp(e:MouseEvent):void
		{
			scrollBar.stopDrag();
			if(mStage == null)mStage = content.stage;
			mStage.removeEventListener(MouseEvent.MOUSE_UP, stageUp);
			mStage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			content.removeEventListener(MouseEvent.MOUSE_MOVE, onContentMove);
		}
		
		private function onEnter(e:Event):void
		{
			//매번 마스크를 씌워줌으로써 안에서 움직임을 수시로 마스크 씌워줍니다.
			//이것을 빼면 안에 모션이 있을시에 그라마스크 경계가 깨져버립니다. 
			contentSource.mask = contentMask; //마스킹
			
			try{
				//컨텐츠 높이이며 그라데이션에 가려질 높이도 생각해서 더함
				var contentHeight:Number = contSourceHeight + (gradientHeight * 2) + mContentMargin;
				
				//한계점 제한
				//if(scrollState != "touch"){
					if(contentTargetY > 0){
						contentTargetY = 0;
					}else if(contentTargetY < contentMask.height - contentHeight){
						contentTargetY = contentMask.height - contentHeight;
					}
				//}
				
				//컨텐츠 부드러운 모션
				contentSource.y += (contentTargetY - contentSource.y) * mSpeed;
				
				//drag를 제외한 스크롤바 동기화
				if(scrollState != "drag"){
					scrollBar.y = cal.getLinearFunction(0, (contentMask.height - contentHeight), 0, (scrollBg.height - scrollBar.height), contentSource.y)
				}
				
				//이동 이벤트 발생
				this.dispatchEvent(new ScrollEvent(ScrollEvent.MOVE_SCROLL, contentTargetY));
				
			}catch(e:Error){ 
				removeEventListener(Event.ENTER_FRAME, onEnter);
			}
		}
		
		//컨텐츠 로드 완료
		private function onComplete(e:SWFLoaderEvent):void
		{
			setInit();
		}
		
		//레이아웃
		private function setLayout():void
		{
			//값 초기화
			contentSource.y = 0;
			scrollBg.y = 0;
			scrollBar.y = 0;
			contentTargetY = 0;
			contSourceHeight = contentSource.height;
			if(content.contains(contentMask))content.removeChild(contentMask);
			
			contentMask = gradientMaskCreate(); //마스크생성
			content.addChild(contentMask);
			//contentMask.alpha = 0.5;
			
			contentSource.cacheAsBitmap = (gradientHeight !== 0);
			contentMask.cacheAsBitmap = (gradientHeight !== 0);
			contentSource.mask = contentMask; //마스킹
			
			var contentHeight:Number = contSourceHeight + (gradientHeight * 2) + mContentMargin;
			barDefaultHeight = scrollBar.height;
			var barHeight:Number = scrollBg.height - Math.abs(contentMask.height - contentHeight);
			
			//스크롤바 사이즈를 리사이징 할것인가?
			if(isBarResize){
				if(barHeight > barDefaultHeight){
					scrollBar.height = barHeight;
				}else{
					scrollBar.height = barDefaultHeight;
				}
			}
			
			//컨텐츠 양에 따라 휠속도 조절
			whellSpeed = contentHeight * .1;
		}
		
		//이벤트
		private function addEvent():void
		{
			if (contSourceHeight > contentMask.height){
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
			var width:Number = contentSource.width;
			var height:Number = contHeight;

			//그라데이션 생성
			var graSp:Sprite = gradientCreate(width, height, gradientHeight);
			graSp.y = -gradientHeight;
			
			return graSp;
		}
		
		//상단 하단 페이드아웃 되는 그라데이션
		private function gradientCreate(width:int, height:int, fadeSize:int):Sprite
		{
			var graRatios:Number = cal.getLinearFunction(0, height, 0, 255, fadeSize);
			
			var fillType:String = GradientType.LINEAR;
			var colors:Array = [0xFF0000, 0xFF0000, 0xFF0000, 0xFF0000];
			var alphas:Array = [0, 1, 1, 0];
			var ratios:Array = [0, graRatios, 255-graRatios, 255];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(width, height, (Math.PI/180)*90);
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
			scrollBar.height = barDefaultHeight;
			Common.targetClear(contentSource);
			contentSource.addChild($dis);
			content.addChild(contentSource);
			onComplete(null);
		}
		
		/**
		 * 타깃이동
		 * @param $n	::: 컨텐츠 y값
		 */		
		public function setTargetY($value:Number, isJump:Boolean = false):void
		{
			if (isJump) contentSource.y = $value;
			scrollState = "wheel";
			contentTargetY = $value;
		}
		
		/**
		 * 컨텐츠소스 반환
		 */	
		public function getContentSource():MovieClip
		{
			return contentSource;
		}
		
		/**
		 * 그라데이션 높이 
		 */		
		public function set gradient($value:int):void
		{
			gradientHeight = $value;
		}
		
		public function get gradient():int
		{
			return gradientHeight;
		}
		
		/**
		 * 컨텐츠 높이 
		 */		
		public function set contentHeight($value:int):void
		{
			contHeight = $value;
		}
		
		public function get contentHeight():int
		{
			return contHeight;
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
		 * 컨텐츠의 크기를 외부에서 조정
		 */		
		public function get contentMargin():int
		{
			return mContentMargin;
		}
		
		public function set contentMargin(value:int):void
		{
			mContentMargin = value;
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
	}
}