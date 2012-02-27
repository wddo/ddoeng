package com.ddoeng.control
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 *
	 * 드로우컨트롤 설명
	 *
	 * @author : Jo Yun Ki (naver ID - ddoeng)
	 * @version : 1.0
	 * @since : Feb 27, 2012
	 *
	 */
	
	public class DrawControl
	{
		private var _source:DisplayObjectContainer;
		private var _x:Number = 0;
		private var _y:Number = 0;
		
		public function DrawControl()
		{
		}
				
		/**
		 * 그래픽요소를 비트맵으로
		 * @param $source	::: 복사할 DisplayObjectContainer
		 * @param $align	::: 무비클립의 정렬정보
		 * @param $smooth	::: 스무스
		 * @return 			::: 생성된 비트맵
		 */	
		public function setDraw($source:DisplayObjectContainer, $smooth:Boolean = true, $transparent:Boolean = true):Bitmap
		{
			_source = $source;
			
			var smooth:Boolean = $smooth;
			var transparent:Boolean = $transparent;
			var matrix:Matrix = new Matrix();			
			
			var dis:DisplayObject;
			var rec:Rectangle;
			
			var cont:Sprite = new Sprite();
			cont.graphics.beginFill(0x000000);
			
			//모든 요소들 영역 설정
			for(var i:int=0; i<_source.numChildren; i++){
				dis = _source.getChildAt(i) as DisplayObject;
				rec = dis.getBounds(_source);
				
				cont.graphics.drawRect( rec.x, rec.y, rec.width, rec.height );
			}
			_source.addChild(cont);
			
			//요소 영역들의 전체 영역 추출
			rec = cont.getBounds(_source);
			_source.removeChild(cont);
			cont = null;
			
			matrix.tx = rec.x * -1;
			matrix.ty = rec.y * -1;
			
			var bitmapData:BitmapData = new BitmapData(rec.width, rec.height, transparent, 0x00FFFFFF);
			bitmapData.draw(_source, matrix);
			
			var bitmap:Bitmap = new Bitmap(bitmapData, PixelSnapping.AUTO, smooth);
			bitmap.name = "clone";
			bitmap.x = matrix.tx * -1;
			bitmap.y = matrix.ty * -1;
			
			visibleOff(); //눈에보이는것 전부 숨김
			
			_source.addChild(bitmap); //복제한 화면 붙이기
			
			return bitmap;
		}
		
		/**
		 * 비트맵을 다시 그래픽요소로
		 * @param $source	::: 변환할 DisplayObjectContainer
		 */		
		public function setClear($source:DisplayObjectContainer):void
		{
			_source = $source;
			
			if(_source.getChildByName("clone") != null){
				_source.removeChild(_source.getChildByName("clone")); //복제한것 삭제
				
				visibleOn();
			}
		}
		
		private function visibleOff():void
		{
			var children:int = _source.numChildren;
			
			for(var i:int = 0; i < children; i++){
				_source.getChildAt(i).visible = false;
			}
		}
		
		private function visibleOn():void
		{
			var children:int = _source.numChildren;
			
			for(var i:int = 0; i < children; i++){
				_source.getChildAt(i).visible = true;
			}
		}
		
		/**
		 * 100x100 기본으로하는 Sprite 반환
		 *  
		 * @param $width	::: 넓이 크기
		 * @param $height	::: 높이 크기
		 * @param $x		:::	X위치
		 * @param $y		::: Y위치
		 * @param $color	::: 색상
		 * @return 
		 * 
		 */		
		public function createRect($width:int = 100, $height:int = 100, $x:int = 0, $y:int = 0, $color:uint = 0x000000):Sprite
		{
			var rect:Sprite = new Sprite();
			rect.graphics.beginFill($color);
			rect.graphics.drawRect($x, $y, $width, $height);
			rect.graphics.endFill();
			
			return rect;
		}
	}
}