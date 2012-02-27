package com.ddoeng.control
{
	import com.ddoeng.utils.Calculation;
	import com.ddoeng.utils.Common;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 *
	 * 비트맵을 컨트롤하는 클래스
	 * 
	 * @author : Jo Yun Ki (naver ID - ddoeng)
	 * @version : 1.0
	 * @since : Nov 17, 2010
	 * 
	 */

	public class BitmapControl
	{
		private var _bitmap:Bitmap;					//비트맵
		private var _bitmapData:BitmapData;			//비트맵 데이터
		private var _bitmapDataCopy:BitmapData;		//비트맵 데이터
		private var _speed:int;					//속도
		
		private var _sw:Boolean = true; 			//속도를 50% 로 만드는 스위치 변수
		
		public function BitmapControl()
		{
		}
		
		private function onEnter(e:Event):void
		{
			var speed:int = _speed;
			
			if(_sw){
				_bitmapData.scroll(speed,0);
				
				if(speed < 0){
					_bitmapData.copyPixels(_bitmapDataCopy, new Rectangle(0, 0, Math.abs(speed), _bitmapDataCopy.height), new Point(_bitmapDataCopy.width+speed, 0));
				}else{
					_bitmapData.copyPixels(_bitmapDataCopy, new Rectangle(_bitmapDataCopy.width-speed, 0, Math.abs(speed), _bitmapDataCopy.height), new Point(0, 0));
				}
				
				_bitmapDataCopy.draw(_bitmap);
			}
			
			_sw = !_sw;
		}
		
		/**
		 * 이미지를 좌우로 속도에 맞혀 무한 슬라이드 합니다. 1, -1, 2, -2..
		 * @param $source 		::: 슬라이드할 소스
		 * @param $speed  		::: 슬라이드 속도
		 * @param $smooth		::: 부드럽게
		 * @param $transparent	::: 투명도
		 */
		public function setSlide($source:DisplayObjectContainer, $speed:int, $smooth:Boolean = true, $transparent:Boolean = true):void
		{
			var source:DisplayObjectContainer = $source;
			_speed = $speed;
			
			_bitmapData = new BitmapData(source.width, source.height, $transparent, 0x00FFFFFF);
			_bitmapData.draw(source);

			_bitmapDataCopy = _bitmapData.clone();
			
			Common.targetClear(source);
			
			_bitmap = new Bitmap(_bitmapData);
			_bitmap.smoothing = $smooth;
			source.addChild(_bitmap);
			
			_bitmap.addEventListener(Event.ENTER_FRAME, onEnter);
		}
		
		/**
		 * 비트맵 이미지를 리사이징 한다.
		 * @param $bitmap ::: 리사이징할 비트맵
		 * @param $width  ::: 원하는 너비
		 * @param $height ::: 원하는 높이
		 * @param $smooth ::: 부드럽게
		 * @return 		  ::: 비트맵 반환
		 */
		public static function reSize($bitmap:Bitmap, $width:Number, $height:Number, $smooth:Boolean = true):Bitmap{
			var bitmap:Bitmap = new Bitmap($bitmap.bitmapData, PixelSnapping.AUTO, $smooth);
			
			var cal:Calculation = new Calculation();
			var xs:Number = cal.getLinearFunction(0, bitmap.width, 0, 1, $width);
			var ys:Number = cal.getLinearFunction(0, bitmap.height, 0, 1, $height);
			
			var matrix:Matrix = new Matrix();
			matrix.scale(xs, ys);
			
			bitmap.transform.matrix = matrix;
			
			return bitmap;
		}
		
		/**
		 * 무비클립 비트맵화하여 반환 
		 * @param $source		::: 변환할 디스플레이
		 * @param $smooth 		::: 부드럽게
		 * @param $transparent	::: 투명도
		 * @return 				:::	비트맵 반환
		 */		
		public static function BitmapPop($source:DisplayObjectContainer, $smooth:Boolean = true, $transparent:Boolean = true):Bitmap
		{
			var source:DisplayObjectContainer = $source;
			
			var bitmapData:BitmapData = new BitmapData(source.width, source.height, $transparent, 0x00FFFFFF);
			bitmapData.draw(source);
			
			var bitmap:Bitmap = new Bitmap(bitmapData, PixelSnapping.AUTO, $smooth);
			
			return bitmap;
		}
		
		
		/**
		 * 움직이는 화면을 비우고 정지샷으로 저장 
		 * @param $source		:::	스크린샷 찍을 디스플레이
		 * @param $smooth 		::: 부드럽게
		 * @param $transparent	::: 투명도
		 */		
		public static function BitmapPush($source:DisplayObjectContainer, $smooth:Boolean = true, $transparent:Boolean = true):void
		{
			var source:DisplayObjectContainer = $source;
			var bitmap:Bitmap = BitmapPop(source, $smooth, $transparent);
			Common.targetClear(source);
			source.addChild(bitmap);
		}
	}
}