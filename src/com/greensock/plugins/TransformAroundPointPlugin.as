package com.greensock.plugins 
{
    import com.greensock.*;
    import com.greensock.core.*;
    import flash.display.*;
    import flash.geom.*;
    
    public class TransformAroundPointPlugin extends com.greensock.plugins.TweenPlugin
    {
        public function TransformAroundPointPlugin()
        {
            super();
            this.propName = "transformAroundPoint";
            this.overwriteProps = [];
            this.priority = -1;
            return;
        }

        public override function onInitTween(arg1:Object, arg2:*, arg3:com.greensock.TweenLite):Boolean
        {
            var loc1:*;
            loc1 = null;
            var loc2:*;
            loc2 = null;
            var loc3:*;
            loc3 = null;
            var loc4:*;
            loc4 = null;
            var loc5:*;
            loc5 = NaN;
            var loc6:*;
            loc6 = NaN;
            if (!(arg2.point as flash.geom.Point))
            {
                return false;
            }
            this._target = arg1 as flash.display.DisplayObject;
            this._point = arg2.point.clone();
            this._local = this._target.globalToLocal(this._target.parent.localToGlobal(this._point));
            var loc7:*;
            loc7 = 0;
            var loc8:*;
            loc8 = arg2;
            for (loc1 in loc8)
            {
                if (loc1 == "point")
                {
                    continue;
                }
                if (loc1 == "shortRotation")
                {
                    this._shortRotation = new com.greensock.plugins.ShortRotationPlugin();
                    this._shortRotation.onInitTween(this._target, arg2[loc1], arg3);
                    addTween(this._shortRotation, "changeFactor", 0, 1, "shortRotation");
                    var loc9:*;
                    loc9 = 0;
                    var loc10:*;
                    loc10 = arg2[loc1];
                    for (loc3 in loc10)
                    {
                        this.overwriteProps[this.overwriteProps.length] = loc3;
                    }
                    continue;
                }
                if (loc1 == "x" || loc1 == "y")
                {
                    addTween(this._point, loc1, this._point[loc1], arg2[loc1], loc1);
                    this.overwriteProps[this.overwriteProps.length] = loc1;
                    continue;
                }
                if (loc1 == "scale")
                {
                    addTween(this._target, "scaleX", this._target.scaleX, arg2.scale, "scaleX");
                    addTween(this._target, "scaleY", this._target.scaleY, arg2.scale, "scaleY");
                    this.overwriteProps[this.overwriteProps.length] = "scaleX";
                    this.overwriteProps[this.overwriteProps.length] = "scaleY";
                    continue;
                }
                addTween(this._target, loc1, this._target[loc1], arg2[loc1], loc1);
                this.overwriteProps[this.overwriteProps.length] = loc1;
            }
            if (arg3 != null)
            {
                loc4 = arg3.vars.isTV != true ? arg3.vars : arg3.vars.exposedVars;
                if (!loc4)
                {
                    loc4;
                }
                if (loc4)
                {
                    if (loc4)
                    {
                        loc5 = typeof loc4.x != "number" ? this._target.x + Number(loc4.x) : loc4.x;
                    }
                    if (loc4)
                    {
                        loc6 = typeof loc4.y != "number" ? this._target.y + Number(loc4.y) : loc4.y;
                    }
                    arg3.killVars({"x":true, "y":true});
                    this.changeFactor = 1;
                    if (!isNaN(loc5))
                    {
                        addTween(this._point, "x", this._point.x, this._point.x + loc5 - this._target.x, "x");
                        this.overwriteProps[this.overwriteProps.length] = "x";
                    }
                    if (!isNaN(loc6))
                    {
                        addTween(this._point, "y", this._point.y, this._point.y + loc6 - this._target.y, "y");
                        this.overwriteProps[this.overwriteProps.length] = "y";
                    }
                    this.changeFactor = 0;
                }
            }
            return true;
        }

        public override function killProps(arg1:Object):void
        {
            if (this._shortRotation != null)
            {
                this._shortRotation.killProps(arg1);
                if (this._shortRotation.overwriteProps.length == 0)
                {
                    arg1.shortRotation = true;
                }
            }
            super.killProps(arg1);
            return;
        }

        public override function set changeFactor(arg1:Number):void
        {
            var loc1:*;
            loc1 = null;
            var loc2:*;
            loc2 = null;
            var loc3:*;
            loc3 = 0;
            var loc4:*;
            loc4 = NaN;
            var loc5:*;
            loc5 = 0;
            var loc6:*;
            loc6 = NaN;
            var loc7:*;
            loc7 = NaN;
            var loc8:*;
            loc8 = 0;
            var loc9:*;
            loc9 = 0;
            if (this._target.parent)
            {
                loc3 = _tweens.length;
                if (this.round)
                {
                    while (loc3--) 
                    {
                        loc2 = _tweens[loc3];
                        loc5 = (loc4 = loc2.start + loc2.change * arg1) < 0 ? -1 : 1;
                        loc2.target[loc2.property] = loc4 % 1 * loc5 > 0.5 ? int(loc4) + loc5 : int(loc4);
                    }
                    loc1 = this._target.parent.globalToLocal(this._target.localToGlobal(this._local));
                    loc6 = this._target.x + this._point.x - loc1.x;
                    loc7 = this._target.y + this._point.y - loc1.y;
                    loc8 = loc6 < 0 ? -1 : 1;
                    loc9 = loc7 < 0 ? -1 : 1;
                    this._target.x = loc6 % 1 * loc8 > 0.5 ? int(loc6) + loc8 : int(loc6);
                    this._target.y = loc7 % 1 * loc9 > 0.5 ? int(loc7) + loc9 : int(loc7);
                }
                else 
                {
                    while (loc3--) 
                    {
                        loc2 = _tweens[loc3];
                        loc2.target[loc2.property] = loc2.start + loc2.change * arg1;
                    }
                    loc1 = this._target.parent.globalToLocal(this._target.localToGlobal(this._local));
                    this._target.x = this._target.x + this._point.x - loc1.x;
                    this._target.y = this._target.y + this._point.y - loc1.y;
                }
                _changeFactor = arg1;
            }
            return;
        }

        public static const API:Number=1;

        protected var _target:flash.display.DisplayObject;

        protected var _local:flash.geom.Point;

        protected var _point:flash.geom.Point;

        protected var _shortRotation:com.greensock.plugins.ShortRotationPlugin;
    }
}
