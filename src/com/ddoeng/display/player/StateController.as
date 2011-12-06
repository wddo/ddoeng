package com.ddoeng.display.player
{
	import com.ddoeng.events.player.StateControllerEvent;
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	
	/**
	 *
	 * @author : Cho Yun Gi (ddoeng@naver.com)
	 * @version : 1.0
	 * @since : Mar 3, 2011
	 * 
	 * 1. 클래스 설명
	 *		상태표시 컨트롤 클래스
	 * 2. 메소드
	 * - 리스너
	 * 		playDown()				::: 재생&일시정지 버튼
	 * 		stopDown()				::: 정지버튼
	 * 		hitbarDown()			::: 진행바 클릭
	 * 		barDown()				::: 바 클릭
	 * 		stageUp()				::: release outside 와 release대체
	 * 		stageMove()				::: 바 클릭후 이동시
	 * 		timer()					::: FLV 파일이 재생될 때 플레이어 제어하기
	 * - 내부메소드
	 * 		init()					::: 초기화
	 * 		addZero()				::: 한자리 숫자에 앞에 0 붙이기
	 * - 외부메소드
	 * 		StateController()		:::	상태표시 컨트롤러 초기화 
	 * 		dispose()				::: 파괴
	 * 		play()					::: FLV 파일 재생
	 * 		pause()					::: FLV 파일 일시정지
	 * 		stop()					::: FLV 파일 정지
	 * 		setget meta()			::: 메타데이터 전달
	 * 		setget netSteam()		::: 넷스트림 전달
	 * - 확장메소드
	 *		
	 */
	[Event (name="statePlaying", type="com.ddoeng.events.player.StateControllerEvent")]
	public class StateController extends Sprite
	{
		private var _clip:Sprite;					//그래픽요소
		private var _play:MovieClip;				//플레이버튼, 일시정지버튼
		private var _stop:MovieClip;				//정지버튼
		private var _bar:MovieClip;					//바
		private var _bg:MovieClip;					//진행바
		
		private var _mask:Sprite;					//슬라이드 진행률 마스크
		
		private var _length:int;					//상태 MAX 길이
		
		private var _meta:Object = new Object;		//메타데이터
		private var _stream:NetStream;				//넷스트림
		private var _fpsTimer:Timer;				//엔터프레임 대신 사용하는 타이머
		private var _videoURL:String;				//비디오 URL
		
		/**
		 * 상태표시 컨트롤러 초기화 
		 * @param $clip			::: 그래픽요소
		 * @param $playName		::: 재생버튼 이름
		 * @param $stopName		::: 정지버튼 이름
		 * @param $barName		::: 바 이름
		 * @param $bgName		::: 진행바 이름
		 */		
		public function StateController($clip:Sprite, $playName:String, $stopName:String, $barName:String, $bgName:String)
		{
			init($clip, $playName, $stopName, $barName, $bgName);
		}
		
		//초기화
		private function init($clip:Sprite, $playName:String, $stopName:String, $barName:String, $bgName:String):void{
			_clip = $clip;
			_play = _clip.getChildByName($playName) as MovieClip;
			_stop = _clip.getChildByName($stopName) as MovieClip;
			_bar = _clip.getChildByName($barName) as MovieClip;
			_bg = _clip.getChildByName($bgName) as MovieClip;
			
			var hitBar:Sprite = new Sprite();
			_clip.addChildAt(hitBar, _clip.getChildIndex(_bg) + 1);
			hitBar.graphics.beginFill(0xff0000);
			hitBar.graphics.drawRect(0, 0, _bg.width, _bg.height);
			hitBar.graphics.endFill();
			hitBar.x = _bg.x;
			hitBar.y = _bg.y;
			hitBar.alpha = 0;
			
			_mask = new Sprite();
			_clip.addChild(_mask);
			_mask.graphics.beginFill(0xff0000);
			_mask.graphics.drawRect(0, 0, _bg.width, _bg.height);
			_mask.graphics.endFill();
			_mask.x = _bg.x;
			_mask.y = _bg.y;
			_mask.width = 0;
			_bg.mask = _mask;
			
			_length = _bg.width - ((_bar.getChildByName("bg_mc") == null)?_bar.width:_bar.getChildByName("bg_mc").width);
			
			hitBar.buttonMode = true;
			hitBar.mouseChildren = false;
			hitBar.addEventListener(MouseEvent.MOUSE_DOWN, hitbarDown);
			
			_play.buttonMode = true;
			_play.mouseChildren = false;
			_play.addEventListener(MouseEvent.MOUSE_DOWN, playDown);
			
			_stop.buttonMode = true;
			_stop.mouseChildren = false;
			_stop.addEventListener(MouseEvent.MOUSE_DOWN, stopDown);
			
			_bar.buttonMode = true;
			_bar.mouseChildren = false;
			_bar.addEventListener(MouseEvent.MOUSE_DOWN, barDown);
			
			_fpsTimer = new Timer(30);
			_fpsTimer.addEventListener(TimerEvent.TIMER, timer);

			_clip.addChild(_bar);
			addEventListener(Event.REMOVED_FROM_STAGE, dispose);
		}
		
		//재생&일시정지 버튼
		private function playDown(e:MouseEvent):void
		{
			if(_play.currentFrame == 1){
				pause();
			}else{
				play();
			}
		}
		
		//정지버튼
		private function stopDown(e:MouseEvent):void
		{
			stop();
		}
		
		//진행바 클릭
		private function hitbarDown(e:MouseEvent):void
		{
			_bar.x = e.localX + _bg.x;;
			_mask.width = e.localX;
			_stream.seek(_meta.duration * _mask.width / _length);
			_bar.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
		}
		
		//바 클릭
		private function barDown(e:MouseEvent):void
		{	
			_fpsTimer.stop();
			_stream.pause();
			
			_bar.startDrag(false, new Rectangle(_bg.x, _bg.y, _length, 0));
			if(_bar.getChildByName("bg_mc") != null)_bar.hitArea = _bar.getChildByName("bg_mc") as Sprite;
			
			_clip.stage.addEventListener(MouseEvent.MOUSE_UP, stageUp);
			_clip.stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMove);
		}
		
		//release outside 와 release대체
		private function stageUp(e:MouseEvent):void
		{
			if(_play.currentFrame == 1)play();
			
			_stream.seek(_meta.duration * _mask.width / _length);
			
			_bar.stopDrag();
			
			_clip.stage.removeEventListener(MouseEvent.MOUSE_UP, stageUp);
			_clip.stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMove);
		}
		
		//바 클릭후 이동시
		private function stageMove(e:MouseEvent):void
		{
			_mask.width = _bar.x - _bg.x;
			_stream.seek(_meta.duration * _mask.width / _length);
		}
					
		// FLV 파일이 재생될 때 플레이어 제어하기
		private function timer(e:TimerEvent):void{
			//trace(e);
			// 재생 슬라이드 바 제어
			/*
			var h: int = ( t / 60 ) / 60;
			var m: int = ( t / 60 ) % 60;
			var s: int = t % 60;
			*/
			
			var currentPct:Number = _stream.time / _meta.duration;
			var barXpos:Number = Math.floor(_length * currentPct) + _bg.x;
			
			if(!isNaN(barXpos))_bar.x += (barXpos - _bar.x) * 0.3;
			_mask.width += ((barXpos - _bg.x) - _mask.width) * 0.3;
			
			// 총 재생 시간 출력
			var totalHours:Number = Math.floor((_meta.duration/60) / 60);
			var totalMinutes:Number = Math.floor((_meta.duration/60) % 60);
			var totalSeconds:Number = Math.floor(_meta.duration%60);
			// 현재 재생 시간 출력
			var hours:Number = Math.floor((_stream.time/60) / 60);
			var minutes:Number = Math.floor((_stream.time/60) % 60);
			var seconds:Number = Math.floor(_stream.time%60);
			
			var playTimed:Object = {h:force2Digits(hours), m:force2Digits(minutes), s:force2Digits(seconds)};
			var playTime:Object = {h:force2Digits(totalHours), m:force2Digits(totalMinutes), s:force2Digits(totalSeconds)};
			
			_stream.dispatchEvent(new StateControllerEvent(StateControllerEvent.STATE_PLAYING, playTimed, playTime));
		}

		//한자리 숫자에 앞에 0 붙이기
		private function force2Digits(value:Number):String {
			return (value < 10) ? "0" + String(value) : String(value);
		}

		/**
		 * FLV 파일 재생
		 */
		public function play():void
		{
			//플레이버튼 ㅁ 로
			_play.gotoAndStop(1);
			
			//타임 시작
			if(!_fpsTimer.running){
				_fpsTimer.start();
			}else{
				_fpsTimer.reset();
			}
			
			_stream.resume();
		}
		
		/**
		 * FLV 파일 일시정지
		 */
		public function pause():void
		{
			//플레이버튼 > 로
			_play.gotoAndStop(2);
			
			//타임 삭제
			_fpsTimer.stop();
			
			_stream.pause();
		}
		
		/**
		 * FLV 파일 정지
		 */
		public function stop():void
		{
			//타임정지
			_fpsTimer.stop();

			_stream.seek(0);
			_stream.pause();
			
			//플레이버튼 > 로
			_play.gotoAndStop(2);
			
			//진행바 초기화
			_bar.x = _bg.x;
			_mask.width = 0;
		}

		/**
		 * 파괴 
		 */		
		public function dispose(e:Event = null):void
		{
			if(hasEventListener(Event.REMOVED_FROM_STAGE)){
				removeEventListener(Event.REMOVED_FROM_STAGE, dispose);
				
				if(_play.hasEventListener(MouseEvent.MOUSE_DOWN))_play.removeEventListener(MouseEvent.MOUSE_DOWN, playDown);
				if(_stop.hasEventListener(MouseEvent.MOUSE_DOWN))_stop.removeEventListener(MouseEvent.MOUSE_DOWN, stopDown);
				if(_bar.hasEventListener(MouseEvent.MOUSE_DOWN))_bar.removeEventListener(MouseEvent.MOUSE_DOWN, barDown);
				if(_clip.stage.hasEventListener(MouseEvent.MOUSE_UP))_clip.stage.removeEventListener(MouseEvent.MOUSE_UP, stageUp);
				if(_clip.stage.hasEventListener(MouseEvent.MOUSE_MOVE))_clip.stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMove);
				if(_fpsTimer.hasEventListener(TimerEvent.TIMER))_fpsTimer.removeEventListener(TimerEvent.TIMER, timer);
				_fpsTimer = null;
			}
		}
		
		public function set meta(value:Object):void
		{
			_meta = value;
		}
		
		public function set stream(value:NetStream):void
		{
			_stream = value;
		}

		public function get fpsTimer():Timer
		{
			return _fpsTimer;
		}

		////////////////////////////////////////////////////////////////////////////////////////////////////
		//확장메소드//////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////
	}
}