/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;

import feathers.controls.supportClasses.BaseScreenNavigator;
import feathers.events.FeathersEventType;
import feathers.skins.IStyleProvider;
import feathers.utils.type.Property;
import haxe.Constraints.Function;
import haxe.ds.Map;
import openfl.errors.TypeError;
import starling.display.DisplayObject;
import starling.events.Event;

/**
 * A "view stack"-like container that supports navigation between screens
 * (any display object) through events.
 *
 * <p>The following example creates a screen navigator, adds a screen and
 * displays it:</p>
 *
 * <listing version="3.0">
 * var navigator:ScreenNavigator = new ScreenNavigator();
 * navigator.addScreen( "mainMenu", new ScreenNavigatorItem( MainMenuScreen ) );
 * this.addChild( navigator );
 * navigator.showScreen( "mainMenu" );</listing>
 *
 * @see ../../../help/screen-navigator.html How to use the Feathers ScreenNavigator component
 * @see ../../../help/transitions.html Transitions for Feathers screen navigators
 * @see feathers.controls.ScreenNavigatorItem
 *
 * @productversion Feathers 1.0.0
 */
class ScreenNavigator extends BaseScreenNavigator 
{
	/**
	 * The default <code>IStyleProvider</code> for all <code>ScreenNavigator</code>
	 * components.
	 *
	 * @default null
	 * @see feathers.core.FeathersControl#styleProvider
	 */
	public static var globalStyleProvider:IStyleProvider;
	
	/**
	 * Constructor.
	 */
	public function new() 
	{
		super();
		
	}
	
	override public function dispose():Void 
	{
		for (map in _screenEvents)
		{
			map.clear();
		}
		_screenEvents.clear();
		
		super.dispose();
	}
	
	/**
	 * @private
	 */
	override function get_defaultStyleProvider():IStyleProvider 
	{
		return ScreenNavigator.globalStyleProvider;
	}
	
	/**
	 * @private
	 */
	public var transition(get, set):Function;
	private var _transition:Function;
	private function get_transition():Function { return this._transition; }
	private function set_transition(value:Function):Function
	{
		if (this.processStyleRestriction("transition"))
		{
			return value;
		}
		return this._transition = value;
	}
	
	/**
	 * @private
	 */
	private var _screenEvents:Map<String, Map<String, Dynamic->Void>> = new Map();
	
	/**
	 * Registers a new screen with a string identifier that can be used
	 * to reference the screen in other calls, like <code>removeScreen()</code>
	 * or <code>showScreen()</code>.
	 *
	 * @see #removeScreen()
	 */
	public function addScreen(id:String, item:ScreenNavigatorItem):Void
	{
		this.addScreenInternal(id, item);
	}
	
	/**
	 * Removes an existing screen using the identifier assigned to it in the
	 * call to <code>addScreen()</code>.
	 *
	 * @see #removeAllScreens()
	 * @see #addScreen()
	 */
	public function removeScreen(id:String):ScreenNavigatorItem
	{
		return cast this.removeScreenInternal(id);
	}
	
	/**
	 * Returns the <code>ScreenNavigatorItem</code> instance with the
	 * specified identifier.
	 */
	public function getScreen(id:String):ScreenNavigatorItem
	{
		return cast this._screens[id];
	}
	
	/**
	 * Displays a screen and returns a reference to it. If a previous
	 * transition is running, the new screen will be queued, and no
	 * reference will be returned.
	 *
	 * <p>An optional transition may be specified. If <code>null</code> the
	 * <code>transition</code> property will be used instead.</p>
	 *
	 * @see #style:transition
	 */
	public function showScreen(id:String, transition:Function = null):DisplayObject
	{
		if (this._activeScreenID == id)
		{
			return this._activeScreen;
		}
		if (transition == null)
		{
			transition = this._transition;
		}
		return this.showScreenInternal(id, transition);
	}
	
	/**
	 * Removes the current screen, leaving the <code>ScreenNavigator</code>
	 * empty.
	 *
	 * <p>An optional transition may be specified. If <code>null</code> the
	 * <code>transition</code> property will be used instead.</p>
	 *
	 * @see #style:transition
	 */
	public function clearScreen(transition:Function = null):Void
	{
		if (transition == null)
		{
			transition = this._transition;
		}
		this.clearScreenInternal(transition);
		this.dispatchEventWith(FeathersEventType.CLEAR);
	}
	
	/**
	 * @private
	 */
	override private function prepareActiveScreen():Void
	{
		var item:ScreenNavigatorItem = cast this._screens[this._activeScreenID];
		var events:Map<String, Dynamic> = item.events;
		var savedScreenEvents:Map<String, Dynamic->Void> = new Map();
		
		var signal:Dynamic;
		var eventAction:Dynamic;
		var eventListener:Dynamic;
		if (events != null)
		{
			for (eventName in events.keys())
			{
				signal = Property.read(this._activeScreen, eventName);
				eventAction = events[eventName];
				if (Reflect.isFunction(eventAction))
				{
					if (signal != null)
					{
						signal.add(eventAction);
					}
					else
					{
						this._activeScreen.addEventListener(eventName, cast eventAction);
					}
				}
				else if (Std.isOfType(eventAction, String))
				{
					if (signal != null)
					{
						eventListener = this.createShowScreenSignalListener(cast eventAction, signal);
						signal.add(eventListener);
					}
					else
					{
						eventListener = this.createShowScreenEventListener(cast eventAction);
						this._activeScreen.addEventListener(eventName, eventListener);
					}
					savedScreenEvents[eventName] = eventListener;
				}
				else
				{
					throw new TypeError("Unknown event action defined for screen: " + Std.string(eventAction));
				}
			}
		}
		this._screenEvents[this._activeScreenID] = savedScreenEvents;
	}
	
	/**
	 * @private
	 */
	override function cleanupActiveScreen():Void
	{
		var item:ScreenNavigatorItem = cast this._screens[this._activeScreenID];
		var events:Map<String, Dynamic> = item.events;
		var savedScreenEvents:Map<String, Dynamic->Void> = this._screenEvents[this._activeScreenID];
		
		var signal:Dynamic;
		var eventAction:Dynamic;
		var eventListener:Dynamic->Void;
		if (events != null)
		{
			for (eventName in events.keys())
			{
				signal = Property.read(this._activeScreen, eventName);
				eventAction = events[eventName];
				if (Reflect.isFunction(eventAction))
				{
					if (signal != null)
					{
						signal.remove(eventAction);
					}
					else
					{
						this._activeScreen.removeEventListener(eventName, cast eventAction);
					}
				}
				else if (Std.isOfType(eventAction, String))
				{
					eventListener = savedScreenEvents[eventName];
					if (signal != null)
					{
						signal.remove(eventListener);
					}
					else
					{
						this._activeScreen.removeEventListener(eventName, eventListener);
					}
				}
			}
		}
		savedScreenEvents.clear();
		this._screenEvents.remove(this._activeScreenID);
	}
	
	/**
	 * @private
	 */
	private function createShowScreenEventListener(screenID:String):Dynamic->Void
	{
		var self:ScreenNavigator = this;
		var eventListener:Dynamic->Void = function(event:Event):Void
		{
			self.showScreen(screenID);
		};
		
		return eventListener;
	}
	
	/**
	 * @private
	 */
	private function createShowScreenSignalListener(screenID:String, signal:Dynamic):Dynamic->Void
	{
		var self:ScreenNavigator = this;
		var signalListener:Dynamic->Void;
		if (signal.valueClasses.length == 1)
		{
			//shortcut to avoid the allocation of the rest array
			signalListener = function(arg0:Dynamic):Void
			{
				self.showScreen(screenID);
			};
		}
		else
		{
			signalListener = function(...rest:Array<Dynamic>):Void
			{
				self.showScreen(screenID);
			};
		}
		
		return signalListener;
	}
	
}