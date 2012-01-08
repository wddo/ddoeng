package com.ddoeng.display
{
	import com.ddoeng.display.player.SoundController;
	import com.ddoeng.display.player.StateController;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	[Event (name="onNetStatus", type="com.ddoeng.events.FLVPlayerEvent")]
	
	/**
	 * 
	 * FLV플레이어 클래스
	 * 
	 * @author : Jo Yun Ki (naver ID - ddoeng)
	 * @version : 1.0
	 * @since : Mar 1, 2011
	 * 	
	 */
	
	public class FLVPlayer extends Sprite
	{
		private var _connection:NetConnection;			//커넥션
		private var _stream:NetStream;					//넷스트림
		private var _video:Video;						//비디오
		private var _meta:Object;			 			//비디오 길이
		
		private var _videoURL:String;					//파일경로
		
		private var _stateControl:StateController;		//상태표시컨트롤
		private var _soundControl:SoundController;		//사운드컨트롤
		
		/**
		 * var stateControl:StateController = new StateController(_clip.control_mc, "play_mc", "stop_mc", "bar_mc", "bg_mc");
		 * var soundControl:SoundController = new SoundController(_clip.control_mc.sound_mc, "bar_mc", "bg_mc", "mute_mc");
		 * var url:String = "fileName.flv";
		 * flvPlayer = new FLVPlayer(_clip.video, url, stateControl, soundControl);
		 *  
		 * flvPlayer.stream.addEventListener(StateControllerEvent.STATE_PLAYING, playing);
		 * flvPlayer.stream.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
		 */
		public function FLVPlayer($video:Video, $url:String = null, $stateControl:StateController = null, $soundControl:SoundController = null)
		{
			_video = $video;
			_videoURL = $url;
			_stateControl = $stateControl;
			_soundControl = $soundControl;
			
			init();
		}
		
		//초기화
		private function init():void
		{
			_connection = new NetConnection();
			_connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			_connection.connect(null); //서버 연결을 연다
			
			addEventListener(Event.REMOVED_FROM_STAGE, dispose);
		}
		
		//상태 이벤트
		private function netStatusHandler(e:NetStatusEvent):void {
			switch (e.info.code) {
				case "NetConnection.Connect.Success":							//연결이 완료되면 자동으로 재생 (최초재생시에만)
					connectStream();											//연결이 완료되면 stream 생성 초기화
					_stream.play(_videoURL); 									//재생
					if(_stateControl != null)_stateControl.getFpsTimer().start();	//enterframe 대신 사용하는 timer 실행
					break;
				case "NetStream.Play.StreamNotFound":
					trace("Stream not found: " + _videoURL);
					break;
			}
		}
		
		private function connectStream():void {
			_stream = new NetStream(_connection);
			_stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			
			var client:Object = new Object();
			client.onMetaData = onMetaDataHandler;
			client.onCuePoint = onCuePointHandler;
			
			_stream.client = client;
			
			_video.attachNetStream(_stream); // 비디오보이기와 파일제어연결 객체 연결
			
			if(_stateControl != null)_stateControl.setStream(_stream);
			if(_soundControl != null)_soundControl.setStream(_stream);
		}
		
		private function onMetaDataHandler(info:Object):void
		{
			trace("metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
			if(_stateControl != null)_stateControl.setMeta(info);
			_meta = info;
		}
		
		private function onCuePointHandler(info:Object):void
		{
			trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
		}

		/**
		 * 비디오 로드 
		 * @param $path		::: 파일경로
		 */		
		public function load($url:String):void
		{	
			if(_stateControl != null)_stateControl.stop();
			
			_stream.close();			//스트림 닫기
			_videoURL = $url;
			_stream.play(_videoURL); 	//재생
			
			if(_stateControl != null)_stateControl.play();
		}
		
		/**
		 * 파괴 
		 */		
		public function dispose(e:Event = null):void
		{
			if(hasEventListener(Event.REMOVED_FROM_STAGE)){
				removeEventListener(Event.REMOVED_FROM_STAGE, dispose);
				
				_video.clear();
				_stream.close();
				if(_stream.hasEventListener(NetStatusEvent.NET_STATUS))_stream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				_stream = null;
				_connection.close();
				_connection = null;
			}
		}

		public function getStream():NetStream
		{
			return _stream;
		}

		public function getMeta():Object
		{
			return _meta;
		}

	}
}