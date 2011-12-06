package com.greensock.plugins 
{
    import com.greensock.*;
    import flash.display.*;
    import flash.geom.*;
    
    public class TransformAroundCenterPlugin extends com.greensock.plugins.TransformAroundPointPlugin
    {
        public function TransformAroundCenterPlugin()
        {
            super();
            this.propName = "transformAroundCenter";
            return;
        }

        public override function onInitTween(arg1:Object, arg2:*, arg3:com.greensock.TweenLite):Boolean
        {
            var loc3:*;
            loc3 = null;
            var loc1:*;
            loc1 = false;
            if (arg1.parent == null)
            {
                loc1 = true;
                (loc3 = new flash.display.Sprite()).addChild(arg1 as flash.display.DisplayObject);
            }
            var loc2:*;
            loc2 = arg1.getBounds(arg1.parent);
            arg2.point = new flash.geom.Point(loc2.x + loc2.width * 0.5, loc2.y + loc2.height * 0.5);
            if (loc1)
            {
                arg1.parent.removeChild(arg1);
            }
            return super.onInitTween(arg1, arg2, arg3);
        }

        public static const API:Number=1;
    }
}
