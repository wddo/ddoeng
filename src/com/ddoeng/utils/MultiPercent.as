package com.ddoeng.utils
{
	/**
	 *
	 * 여러 로딩퍼센트를 모아서 합산하여 0~100%로 반환하는 클래스	
	 * 
	 * @author : Jo Yun Ki (naver ID - ddoeng)
	 * @version : 1.0
	 * @since : Nov 17, 2010
	 * 
	 */
	
	public class MultiPercent
	{
		private var _percent:Number = 0; //로딩 퍼센트 
		private var _totalCount:int = 0; //총 로딩개수
		
		public function MultiPercent($totalcount:int)
		{	
			this._totalCount = $totalcount;
		}
		
		/**
		 * Progress가 동시에 일어나면 사용할수 없음
		 * 모은 퍼센트 반환 0~100%으로 반환
		 * Progress리스너 안에서 mp.calculation(e.percent, count); 으로 사용하고
		 * Complete리스너에서 mp.percent == 100 으로 체크 false면 count++
		 * 
		 * @param $percent ::: 0~100% 퍼센트
		 * @param $counter ::: 0부터시작.. 총 로딩개수에서 현제로딩 카운터
		 */		
		public function setCalculation($percent:Number, $counter:int):void
		{
			if(_totalCount >= $counter){
				var n:Number = Math.round($counter * (100 / _totalCount));
				_percent =  Math.round($percent * ((100 / _totalCount) * 0.01)) + n;
			}
		}
			
		/**
		 * 100%완료되었는지  체크할수 있는 퍼센트 반환
		 */		
		public function getPercent():Number
		{
			return _percent;
		}

		/**
		 * 총 로딩 갯수 반환
		 */		
		public function getTotalCounter():int
		{
			return _totalCount;
		}
	}
}