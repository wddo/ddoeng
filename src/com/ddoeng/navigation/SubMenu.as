package com.ddoeng.navigation
{
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	
	/**
	 *
	 * 서브메뉴
	 *
	 * @author : Jo Yun Ki (naver ID - ddoeng)
	 * @version : 1.0
	 * @since : Jan 2, 2012
	 *
	 */
	public dynamic class SubMenu extends MenuBase
	{
		public function SubMenu($clip:MovieClip)
		{
			super($clip);
		}
		
		override public function setOn():void
		{
			var txtfid:TextField = getTextField();
			TweenMax.to(txtfid, 0.4, {tint:0xff0000});
		}
		
		override public function setOff():void
		{
			var txtfid:TextField = getTextField();
			TweenMax.to(txtfid, 0.4, {removeTint:true});
		}
	}
}