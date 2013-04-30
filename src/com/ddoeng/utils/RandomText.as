package com.ddoeng.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	/**
	 * 
	 * 랜덤한 텍스트를 반환하여 텍스트 완성
	 * 
	 * @author : Jo Yun Ki (naver ID - ddoeng)
	 * @version : 1.0
	 * @since : Nov 17, 2010
	 *
	 */
	
	public class RandomText extends EventDispatcher
	{
		private var _fid:TextField;
		private var _str:String;
		
		private var _tempTextArr:Array = [];
		private var _tempNumberArr:Array = [];
		private var _textLength:int;
		private var _checkLength:int = 0;
		private var _startNum:int = 0;
		private var _changeTime:int;
		private var _minCodeNumber:int;
		private var _maxCodeNumber:int;
		private var _completeStr:String = "";
		private var _type:int;
		private var _code:Number;

		private var timer:Timer;
		
		/**
		 * 	_type = 1 문자가 하나하나 완성됨 (맞는 글짜 찾을때 까지), _type = 2 전체문자크기대로 랜덤하게 찍어놓고 시간되면 순서대로 일치시킴
		 * 	_type = 3 전체문자크기대로 랜덤하게 찍어놓고 시간되면 랜덤하게 일치시킴, _type = 4 문자가 하나하나 완성됨 (max에 차면 자동완성)
		 *  _type = 5 전체문자크기대로 랜덤하게 찍어놓고 글자당 시간되면 순서대로 일치시킴
		 * 
		 * @param $fid		:::	적용할 텍스트필드
		 * @param $str		:::	완성된 문자열
		 * @param $min		:::	최소 문자코드 넘버
		 * @param $max		:::	최고 문자코드 넘버
		 * @param $speed	:::	속도
		 * @param $delay	:::	딜레이
		 * @param $type		::: 타입 1~5
		 */		
		public function RandomText()
		{
		}
		
		public function setText($fid:TextField, $str:String, $min:int = 33, $max:int = 122, $speed:int = 30, $delay:int = 0, $type:int = 1):void {
			_fid 			= $fid;
			_str 			= $str;
			_minCodeNumber 	= $min;
			_maxCodeNumber 	= $max;
			_changeTime 	= $speed;
			_type 			= $type;
			_code 			= _minCodeNumber;
			
			_fid.text = "";
			//_fid.restrict = "A-Z 0-9";
			//_fid.autoSize = TextFieldAutoSize.LEFT;
			
			_textLength = _str.length;
			
			for(var i:int = 0 ; i<_textLength; ++i){
				_tempTextArr.push(String.fromCharCode(Math.floor(Math.random() * (_maxCodeNumber-_minCodeNumber+1)) + _minCodeNumber ));
				_tempNumberArr.push(i);
			}
			
			//trace("_tempTextArr : "+_tempTextArr); //임시 텍스트
			//trace("_tempNumberArr : "+_tempNumberArr); //텍스트 순서
			
			timer = new Timer($delay, 1);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		public function dispose():void
		{
			if (_fid !== null) _fid.removeEventListener(Event.ENTER_FRAME, onEnter);
			
			if (timer !== null) {
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, onTimer);
				timer = null;
			}
		}
		
		private function complete():void
		{
			var evt:Event = new Event("randomTextComple");
			this.dispatchEvent(evt);
		}
		
		private function onTimer(e:TimerEvent):void
		{
			_fid.addEventListener(Event.ENTER_FRAME, onEnter);
		}
		
		private function onEnter(e:Event):void
		{
			if(_type == 1){
				loop1();
			}else if(_type == 2){
				loop2();
			}else if(_type == 3){
				_tempNumberArr = randomArray(_tempNumberArr); //순서랜덤
				loop2();
			}else if(_type == 4){
				loop4();
			}else if(_type == 5){
				loop5();
			}else{
				
			}
		}

		private function loop1():void
		{
			if(_startNum == _changeTime){
				//trace("시간되었다.");
				_startNum = 0;
				//시간되면 강제 삽입
				_tempTextArr[_completeStr.length] = _str.charAt(_completeStr.length);
			}else{
				_startNum++;
			}
		
			if(_tempTextArr[_completeStr.length] != _str.charAt(_completeStr.length)){
				_tempTextArr[_completeStr.length] = String.fromCharCode(Math.floor(Math.random() * (_maxCodeNumber-_minCodeNumber+1)) + _minCodeNumber );
				//랜덤하게 문자를 넣는다
			}else{ // 문자가 같아지면
				//trace("문자가 일치하였다.");
				//해당 문자를 배열에 넣는다
				if(_completeStr.length < _str.length - 1){	
					_completeStr += _tempTextArr[_completeStr.length];
					_startNum = 0;
				}else{
					dispose();
					complete();
				}
			}
			
			_fid.text = _completeStr + _tempTextArr[_completeStr.length];
		}
		
		private function loop2():void
		{			
			for(var i:Number = 0 ; i<_textLength ; ++i){
				if(_tempTextArr[i] != _str.charAt(i)){
					_tempTextArr[i] = String.fromCharCode(Math.floor(Math.random() * (_maxCodeNumber-_minCodeNumber+1)) + _minCodeNumber );
					//랜덤하게 문자를 넣는다
				}else{ // 문자가 같아지면
					_tempTextArr[i] = _str.charAt(i);
					//해당 문자를 배열에 넣는다
				}
			}
			
			if(_startNum == _changeTime){ //1 2 3 4 ~..  10 이되면..
				_tempTextArr[ _tempNumberArr[ _checkLength ] ] = _str.charAt( _tempNumberArr[ _checkLength ] );
				//_tempNumberArr 를 참조한 이유는 랜덤하게 완성되기위함 (현제는 순서대로);
				_checkLength++; // changeTime만큼 딜레이 후 +1
				if(_checkLength == _textLength){
					dispose();
					complete();
				}
			}else{
				_startNum++;
			}
			
			_fid.text = _tempTextArr.join("");
		}
		
		private function loop4():void
		{
			if(_code == _maxCodeNumber){
				//마지막 코드까지가면 강제 삽입
				_tempTextArr[_completeStr.length] = _str.charAt(_completeStr.length);
			}
			
			if(_startNum == _changeTime){
				//trace("시간되었다.");
				_startNum = 0;
				//시간되면 강제 삽입
				_tempTextArr[_completeStr.length] = _str.charAt(_completeStr.length);
			}else{
				_startNum++;
			}
		
			if(_tempTextArr[_completeStr.length] != _str.charAt(_completeStr.length)){
				_tempTextArr[_completeStr.length] = String.fromCharCode(_code);
				_code++;
				//랜덤하게 문자를 넣는다
			}else{ // 문자가 같아지면
				//trace("문자가 일치하였다.");
				//해당 문자를 배열에 넣는다
				if(_completeStr.length < _str.length - 1){	
					_completeStr += _tempTextArr[_completeStr.length];
					_code = _minCodeNumber;
					_startNum = 0;
				}else{
					dispose();
					complete();
				}
			}
			
			_fid.text = _completeStr + _tempTextArr[_completeStr.length];
		}
		
		private function loop5():void
		{
			if(_code == _maxCodeNumber){
				//마지막 코드까지가면 강제 삽입
				_tempTextArr[_completeStr.length] = _str.charAt(_completeStr.length);
			}
			
			if(_startNum == _changeTime){
				//trace("시간되었다.");
				_startNum = 0;
				//시간되면 강제 삽입
				_tempTextArr[_completeStr.length] = _str.charAt(_completeStr.length);
			}else{
				_startNum++;
			}
			
			if(_tempTextArr[_completeStr.length] != _str.charAt(_completeStr.length)){
				_tempTextArr[_completeStr.length] = String.fromCharCode(_code);
				_code++;
				//랜덤하게 문자를 넣는다
			}else{ // 문자가 같아지면
				//trace("문자가 일치하였다.");
				//해당 문자를 배열에 넣는다
				if(_completeStr.length < _str.length - 1){	
					_completeStr += _tempTextArr[_completeStr.length];
					_code = _minCodeNumber;
					_startNum = 0;
				}else{
					dispose();
					complete();
				}
			}
			
			for(var i:Number = 0 ; i<_textLength ; ++i){
				if(_tempTextArr[i] != _str.charAt(i)){
					_tempTextArr[i] = String.fromCharCode(Math.floor(Math.random() * (_maxCodeNumber-_minCodeNumber+1)) + _minCodeNumber );
					//랜덤하게 문자를 넣는다
				}else{ // 문자가 같아지면
					_tempTextArr[i] = _str.charAt(i);
					//해당 문자를 배열에 넣는다
				}
			}
			
			_fid.text = _tempTextArr.join("");
		}
		
		private function randomArray(array:Array):Array{
			var return_array:Array = new Array();
			var lengthNum:Number = array.length;
			for(var i:Number = 0 ; i<lengthNum ; ++i){
				var index:Number = Math.floor( Math.random() * array.length );
				
				return_array.push( array[index] ); //번호추출해 새로운곳에 넣고
				array.splice(index,1); //추출한번호 삭제
			}
			return return_array;
		}
	}
}