/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion;
import feathers.motion.effectClasses.IEffectContext;
import feathers.motion.effectClasses.TweenEffectContext;
import feathers.utils.type.Property;
import haxe.Constraints.Function;
import openfl.errors.ArgumentError;
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;

/**
 * Creates animated transitions for screen navigators that slides two
 * display objects in the same direction (replacing one with the other) like
 * a classic slide carousel. Animates the <code>x</code> and <code>y</code>
 * properties of the display objects. The display objects may slide up,
 * right, down, or left.
 *
 * @see ../../../help/transitions.html#slide Transitions for Feathers screen navigators: Slide
 *
 * @productversion Feathers 2.1.0
 */
class Slide 
{
	/**
	 * @private
	 */
	private static inline var SCREEN_REQUIRED_ERROR:String = "Cannot transition if both old screen and new screen are null.";
	
	/**
	 * Creates a transition function for a screen navigator that slides the
	 * new screen to the left from off-stage, pushing the old screen in the
	 * same direction.
	 *
	 * @see ../../../help/transitions.html#slide Transitions for Feathers screen navigators: Slide
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createSlideLeftTransition(duration:Float = 0.5, ease:Dynamic = Transitions.EASE_OUT, tweenProperties:Dynamic = null):Function
	{
		return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function, managed:Bool = false):IEffectContext
		{
			if (oldScreen == null && newScreen == null)
			{
				throw new ArgumentError(SCREEN_REQUIRED_ERROR);
			}
			var tween:SlideTween;
			if (newScreen != null)
			{
				if (oldScreen != null)
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
				}
				newScreen.x = newScreen.width;
				newScreen.y = 0;
				tween = new SlideTween(newScreen, oldScreen, -newScreen.width, 0, duration, ease, onComplete, tweenProperties);
			}
			else //we only have the old screen
			{
				oldScreen.x = 0;
				oldScreen.y = 0;
				tween = new SlideTween(oldScreen, null, -oldScreen.width, 0, duration, ease, onComplete, tweenProperties);
			}
			if (managed)
			{
				return new TweenEffectContext(null, tween);
			}
			Starling.currentJuggler.add(tween);
			return null;
		};
	}
	
	/**
	 * Creates a transition function for a screen navigator that that slides
	 * the new screen to the right from off-stage, pushing the old screen in
	 * the same direction.
	 *
	 * @see ../../../help/transitions.html#slide Transitions for Feathers screen navigators: Slide
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createSlideRightTransition(duration:Float = 0.5, ease:Dynamic = Transitions.EASE_OUT, tweenProperties:Dynamic = null):Function
	{
		return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function, managed:Bool = false):IEffectContext
		{
			if (oldScreen == null && newScreen == null)
			{
				throw new ArgumentError(SCREEN_REQUIRED_ERROR);
			}
			var tween:SlideTween;
			if (newScreen != null)
			{
				if (oldScreen != null)
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
				}
				newScreen.x = -newScreen.width;
				newScreen.y = 0;
				tween = new SlideTween(newScreen, oldScreen, newScreen.width, 0, duration, ease, onComplete, tweenProperties);
			}
			else //we only have the old screen
			{
				oldScreen.x = 0;
				oldScreen.y = 0;
				tween = new SlideTween(oldScreen, null, oldScreen.width, 0, duration, ease, onComplete, tweenProperties);
			}
			if (managed)
			{
				return new TweenEffectContext(null, tween);
			}
			Starling.currentJuggler.add(tween);
			return null;
		};
	}
	
	/**
	 * Creates a transition function for a screen navigator that that slides
	 * the new screen up from off-stage, pushing the old screen in the same
	 * direction.
	 *
	 * @see ../../../help/transitions.html#slide Transitions for Feathers screen navigators: Slide
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createSlideUpTransition(duration:Float = 0.5, ease:Dynamic = Transitions.EASE_OUT, tweenProperties:Dynamic = null):Function
	{
		return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function, managed:Bool = false):IEffectContext
		{
			if (oldScreen == null && newScreen == null)
			{
				throw new ArgumentError(SCREEN_REQUIRED_ERROR);
			}
			var tween:SlideTween;
			if (newScreen != null)
			{
				if (oldScreen == null)
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
				}
				newScreen.x = 0;
				newScreen.y = newScreen.height;
				tween = new SlideTween(newScreen, oldScreen, 0, -newScreen.height, duration, ease, onComplete, tweenProperties);
			}
			else //we only have the old screen
			{
				oldScreen.x = 0;
				oldScreen.y = 0;
				tween = new SlideTween(oldScreen, null, 0, -oldScreen.height, duration, ease, onComplete, tweenProperties);
			}
			if (managed)
			{
				return new TweenEffectContext(null, tween);
			}
			Starling.currentJuggler.add(tween);
			return null;
		};
	}
	
	/**
	 * Creates a transition function for a screen navigator that that slides
	 * the new screen down from off-stage, pushing the old screen in the
	 * same direction.
	 *
	 * @see ../../../help/transitions.html#slide Transitions for Feathers screen navigators: Slide
	 * @see feathers.controls.StackScreenNavigator#pushTransition
	 * @see feathers.controls.StackScreenNavigator#popTransition
	 * @see feathers.controls.ScreenNavigator#transition
	 */
	public static function createSlideDownTransition(duration:Float = 0.5, ease:Dynamic = Transitions.EASE_OUT, tweenProperties:Dynamic = null):Function
	{
		return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function, managed:Bool = false):IEffectContext
		{
			if (oldScreen == null && newScreen == null)
			{
				throw new ArgumentError(SCREEN_REQUIRED_ERROR);
			}
			var tween:SlideTween;
			if (newScreen != null)
			{
				if (oldScreen != null)
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
				}
				newScreen.x = 0;
				newScreen.y = -newScreen.height;
				tween = new SlideTween(newScreen, oldScreen, 0, newScreen.height, duration, ease, onComplete, tweenProperties);
			}
			else //we only have the old screen
			{
				oldScreen.x = 0;
				oldScreen.y = 0;
				tween = new SlideTween(oldScreen, null, 0, oldScreen.height, duration, ease, onComplete, tweenProperties);
			}
			if (managed)
			{
				return new TweenEffectContext(null, tween);
			}
			Starling.currentJuggler.add(tween);
			return null;
		};
	}
}

class SlideTween extends Tween
{
	public function new(target:DisplayObject, otherTarget:DisplayObject,
		xOffset:Float, yOffset:Float, duration:Float, ease:Dynamic,
		onCompleteCallback:Function, tweenProperties:Dynamic)
	{
		super(target, duration, ease);
		if (xOffset != 0)
		{
			this._xOffset = xOffset;
			this.animate("x", target.x + xOffset);
		}
		if (yOffset != 0)
		{
			this._yOffset = yOffset;
			this.animate("y", target.y + yOffset);
		}
		if (tweenProperties != null)
		{
			for (propertyName in Reflect.fields(tweenProperties))
			{
				Property.write(this, propertyName, Reflect.field(tweenProperties, propertyName));
			}
		}
		this._navigator = target.parent;
		if (otherTarget != null)
		{
			this._otherTarget = otherTarget;
			this.onUpdate = this.updateOtherTarget;
		}
		this._onCompleteCallback = onCompleteCallback;
		this.onComplete = this.cleanupTween;
	}
	
	private var _navigator:DisplayObject;
	private var _otherTarget:DisplayObject;
	private var _onCompleteCallback:Function;
	private var _xOffset:Float = 0;
	private var _yOffset:Float = 0;
	
	private function updateOtherTarget():Void
	{
		var newScreen:DisplayObject = cast this.target;
		if (this._xOffset < 0)
		{
			this._otherTarget.x = newScreen.x - this._navigator.width;
		}
		else if (this._xOffset > 0)
		{
			this._otherTarget.x = newScreen.x + newScreen.width;
		}
		if (this._yOffset < 0)
		{
			this._otherTarget.y = newScreen.y - this._navigator.height;
		}
		else if (this._yOffset > 0)
		{
			this._otherTarget.y = newScreen.y + newScreen.height;
		}
	}
	
	private function cleanupTween():Void
	{
		var displayTarget:DisplayObject = cast this.target;
		displayTarget.x = 0;
		displayTarget.y = 0;
		if (this._otherTarget != null)
		{
			this._otherTarget.x = 0;
			this._otherTarget.y = 0;
		}
		if (this._onCompleteCallback != null)
		{
			#if neko
			Reflect.callMethod(this._onCompleteCallback, this._onCompleteCallback, []);
			#else
			this._onCompleteCallback();
			#end
		}
	}
}