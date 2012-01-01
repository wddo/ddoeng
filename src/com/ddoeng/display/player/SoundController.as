package com.ddoeng.display.player
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.net.NetStream;
	
	
	/**
	 *
	 * @author : Jo Yun Ki (naver ID - ddoeng)
	 * @version : 1.0
	 * @since : Mar 3, 2011
	 * 
	 * 1. 클래스 설명
	 *		사운드 컨트롤 클래스
	 * 2. 메소드
	 * - 리스너
	 * 		barDown()				::: 바 클릭
	 * 		stageUp()				::: 사운드 release outside 와 release대체
	 * 		muteDown()				::: 음소거 온오프
	 * 		loop()
	 * - 내부메소드
	 * 		init()					::: 초기화
	 * - 외부메소드
	 * 		SoundController()		::: 사운트 컨트롤러 초기화 
	 * 		dispose()				::: 파괴
	 * 		setget netStream()		::: 넷스트림 전달
	 * - 확장메소드
	 *		
	 */
	
	public class SoundController extends Sprite
	{
		private var _clip:Sprite;					// 그래픽요소
		private var _bar:MovieClip;					// 바
		private var _bg:MovieClip;					// 슬라이드
		private var _mute:MovieClip;				// 음소거 버튼
		
		private var _mask:Sprite;					//슬라이드 마스크
		
		private var _length:int;					//상태 MAX 길이
		private var _btnXpos:Number;				//음소거 해제시 반환할 바 위치
		private var _currentVolume:Number = 1;		//볼륨값
		private var _trans:SoundTransform;			//사운드 조절 객체
		
		private var _netSteam:NetStream;			//넷스트림
				
		/**
		 * 사운트 컨트롤러 초기화 
		 * @param $clip			::: 그래픽요소
		 * @param $barName		::: 바이름
		 * @param $bgName		::: 슬라이드 이름
		 * @param $muteName		::: 음소거 버튼 이름
		 * 
		 */		
		public function SoundController($clip:Sprite, $barName:String, $bgName:String, $muteName:String = "")
		{
			init($clip, $barName, $bgName, $muteName);
		}
		
		//초기화
		private function init($clip:Sprite, $barName:String, $bgName:String, $muteName:String = ""):void
		{
			_clip = $clip;
			_bar = _clip.getChildByName($barName) as MovieClip;
			_bg = _clip.getChildByName($bgName) as MovieClip;
			if($muteName != "")_mute = _clip.getChildByName($muteName) as MovieClip;
			
			_mask = new Sprite();
			_clip.addChild(_mask);
			_mask.graphics.beginFill(0xff0000);
			_mask.graphics.drawRect(0, 0, _bg.width, _bg.height);
			_mask.graphics.endFill();
			_mask.x = _bg.x;
			_mask.y = _bg.y;
			_bg.mask = _mask;
			
			_length = _bg.width - ((_bar.getChildByName("bg_mc") == null)?_bar.width:_bar.getChildByName("bg_mc").width);
			_bar.x = _bg.x + _length;
			
			_bar.buttonMode = true;
			_bar.mouseChildren = false;
			_bar.addEventListener(MouseEvent.MOUSE_DOWN, barDown);
			
			if($muteName != ""){
				_mute.buttonMode = true;
				_mute.mouseChildren = false;
				_mute.addEventListener(MouseEvent.MOUSE_DOWN, muteDown);
			}
			
			_trans = new SoundTransform(_currentVolume);
			
			addEventListener(Event.REMOVED_FROM_STAGE, dispose);
		}
		
		//바 클릭
		private function barDown(e:MouseEvent):void
		{
			_bar.startDrag(false, new Rectangle(_bg.x, _bg.y, _length, 0));
			
			_clip.stage.addEventListener(MouseEvent.MOUSE_UP, stageUp);
			
			//마스크 엔터프레임
			_mask.addEventListener(Event.ENTER_FRAME, loop);
		}
		
		//사운드 release outside 와 release대체
		private function stageUp(e:MouseEvent):void
		{
			_bar.stopDrag();
			
			_clip.stage.removeEventListener(MouseEvent.MOUSE_UP, stageUp);
			
			//마스크 엔터프레임 삭제
			_mask.removeEventListener(Event.ENTER_FRAME, loop);
		}
				
		//음소거 온오프
		private function muteDown(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;;
			if(mc.currentFrame == 1){
				_trans.volume = 0;
				_netSteam.soundTransform = _trans;
				
				_btnXpos = _bar.x;
				_bar.x = _mask.x;
				_mask.width = 0;
				
				_mute.gotoAndStop(2);
			}else{
				_trans.volume = _currentVolume;
				_netSteam.soundTransform = _trans;
				_bar.x = _btnXpos;
				_mask.width = _btnXpos - _mask.x;
				
				_mute.gotoAndStop(1);
			}
		}		
		
		//엔터프레임
		private function loop(e:Event):void
		{
			_mask.width = _bar.x - _mask.x;
			
			if(_mute.currentFrame == 1){
				_currentVolume = Math.floor( (_mask.width / _length) * 100 ) * 0.01;
				_trans.volume = _currentVolume;
				
				_netSteam.soundTransform = _trans;
			}
		}
		
		/**
		 * 파괴 
		 */		
		public function dispose(e:Event = null):void
		{
			if(hasEventListener(Event.REMOVED_FROM_STAGE)){
				removeEventListener(Event.REMOVED_FROM_STAGE, dispose);
				
				if(_bar.hasEventListener(MouseEvent.MOUSE_DOWN))_bar.removeEventListener(MouseEvent.MOUSE_DOWN, barDown);
				if(_mute.hasEventListener(MouseEvent.MOUSE_DOWN))_mute.removeEventListener(MouseEvent.MOUSE_DOWN, muteDown);
				if(_clip.stage.hasEventListener(MouseEvent.MOUSE_UP))_clip.stage.removeEventListener(MouseEvent.MOUSE_UP, stageUp);
				if(_mask.hasEventListener(Event.ENTER_FRAME))_mask.removeEventListener(Event.ENTER_FRAME, loop);
			}
		}
		
		public function set stream(value:NetStream):void
		{
			_netSteam = value;
		}
	}
}