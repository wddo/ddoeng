package com.ddoeng.navigation
{
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	
	/**
	 *
	 * 메인메뉴 커스터 마이징 클래스
	 *
	 * @author : Jo Yun Ki (naver ID - ddoeng)
	 * @version : 1.0
	 * @since : Jan 2, 2012
	 *
	 */
	public dynamic class MainMenu extends MenuBase
	{
		public function MainMenu($clip:MovieClip)
		{
			super($clip);
		}
		
		override public function setOn():void
		{
			var txtfid:TextField = getTextField();
			TweenMax.to(txtfid, 0.4, {tint:0x000000});
		}
		
		override public function setOff():void
		{
			var txtfid:TextField = getTextField();
			TweenMax.to(txtfid, 0.4, {removeTint:true});
		}
	}
}