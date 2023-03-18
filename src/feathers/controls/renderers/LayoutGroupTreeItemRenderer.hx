/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.renderers;

import feathers.controls.LayoutGroup;
import feathers.controls.Tree;
import feathers.core.FeathersControl;
import feathers.skins.IStyleProvider;
import starling.display.DisplayObject;
import starling.events.Event;

/**
 * Based on <code>LayoutGroup</code>, this component is meant as a base
 * class for creating a custom item renderer for a <code>Tree</code>
 * component.
 *
 * <p>Sub-components may be created and added inside <code>initialize()</code>.
 * This is a good place to add event listeners and to set the layout.</p>
 *
 * <p>The <code>data</code> property may be parsed inside <code>commitData()</code>.
 * Use this function to change properties in your sub-components.</p>
 *
 * <p>Sub-components may be positioned manually, but a layout may be
 * provided as well. An <code>AnchorLayout</code> is recommended for fluid
 * layouts that can automatically adjust positions when the list resizes.
 * Create <code>AnchorLayoutData</code> objects to define the constraints.</p>
 *
 * @see feathers.controls.Tree
 *
 * @productversion Feathers 1.2.0
 */
class LayoutGroupTreeItemRenderer extends LayoutGroup implements ITreeItemRenderer
{
	/**
	 * The default <code>IStyleProvider</code> for all <code>LayoutGroupTreeItemRenderer</code>
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
	
	/**
	 * @private
	 */
	override function get_defaultStyleProvider():IStyleProvider 
	{
		return LayoutGroupTreeItemRenderer.globalStyleProvider;
	}
	
	/**
	 * @inheritDoc
	 */
	public var location(get, set):Array<Int>;
	private var _location:Array<Int>;
	private function get_location():Array<Int> { return this._location; }
	private function set_location(value:Array<Int>):Array<Int>
	{
		return this._location = value;
	}
	
	/**
	 * @inheritDoc
	 */
	public var layoutIndex(get, set):Int;
	private var _layoutIndex:Int = -1;
	private function get_layoutIndex():Int { return this._layoutIndex; }
	private function set_layoutIndex(value:Int):Int
	{
		return this._layoutIndex = value;
	}
	
	/**
	 * @inheritDoc
	 */
	public var owner(get, set):Tree;
	private var _owner:Tree;
	private function get_owner():Tree { return this._owner; }
	private function set_owner(value:Tree):Tree
	{
		if (this._owner == value)
		{
			return value;
		}
		this._owner = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._owner;
	}
	
	/**
	 * @inheritDoc
	 */
	public var data(get, set):Dynamic;
	private var _data:Dynamic;
	private function get_data():Dynamic { return this._data; }
	private function set_data(value:Dynamic):Dynamic
	{
		if (this._data == value)
		{
			return value;
		}
		this._data = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		//LayoutGroup doesn't know about INVALIDATION_FLAG_DATA, so we need
		//set set another flag that it understands.
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
		return this._data;
	}
	
	/**
	 * @inheritDoc
	 */
	public var isSelected(get, set):Bool;
	private var _isSelected:Bool;
	private function get_isSelected():Bool { return this._isSelected; }
	private function set_isSelected(value:Bool):Bool
	{
		if (this._isSelected == value)
		{
			return value;
		}
		this._isSelected = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SELECTED);
		//the state flag is needed for updating the background
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STATE);
		this.dispatchEventWith(Event.CHANGE);
		return this._isSelected;
	}
	
	/**
	 * @inheritDoc
	 */
	public var isBranch(get, set):Bool;
	private var _isBranch:Bool;
	private function get_isBranch():Bool { return this._isBranch; }
	private function set_isBranch(value:Bool):Bool
	{
		if (this._isBranch == value)
		{
			return value;
		}
		this._isBranch = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._isBranch;
	}
	
	/**
	 * @inheritDoc
	 */
	public var isOpen(get, set):Bool;
	private var _isOpen:Bool;
	private function get_isOpen():Bool { return this._isOpen; }
	private function set_isOpen(value:Bool):Bool
	{
		if (this._isOpen == value)
		{
			return value;
		}
		this._isOpen = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return this._isOpen;
	}
	
	/**
	 * @inheritDoc
	 */
	public var factoryID(get, set):String;
	private var _factoryID:String;
	private function get_factoryID():String { return this._factoryID; }
	private function set_factoryID(value:String):String
	{
		return this._factoryID = value;
	}
	
	/**
	 * @private
	 */
	public var backgroundSelectedSkin(get, set):DisplayObject;
	private var _backgroundSelectedSkin:DisplayObject;
	private function get_backgroundSelectedSkin():DisplayObject { return this._backgroundSelectedSkin; }
	private function set_backgroundSelectedSkin(value:DisplayObject):DisplayObject
	{
		if (this.processStyleRestriction("backgroundSelectedSkin"))
		{
			if (value != null)
			{
				value.dispose();
			}
			return value;
		}
		if (this._backgroundSelectedSkin == value)
		{
			return value;
		}
		if (this._backgroundSelectedSkin != null &&
			this.currentBackgroundSkin == this._backgroundSelectedSkin)
		{
			this.removeCurrentBackgroundSkin(this._backgroundSelectedSkin);
			this.currentBackgroundSkin = null;
		}
		this._backgroundSelectedSkin = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SKIN);
		return this._backgroundSelectedSkin;
	}
	
	/**
	 * @private
	 */
	override public function dispose():Void
	{
		this.owner = null;
		super.dispose();
	}
	
	/**
	 * @private
	 */
	override function draw():Void
	{
		//children are allowed to change during draw() in a subclass up
		//until it calls super.draw().
		this._ignoreChildChangesButSetFlags = false;
		
		var dataInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_DATA);
		var scrollInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_SCROLL);
		var sizeInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_SIZE);
		var layoutInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_LAYOUT);
		
		if (dataInvalid)
		{
			this.commitData();
		}
		
		if (scrollInvalid || sizeInvalid || layoutInvalid)
		{
			this._ignoreChildChanges = true;
			this.preLayout();
			this._ignoreChildChanges = false;
		}
		
		super.draw();
		
		if (scrollInvalid || sizeInvalid || layoutInvalid)
		{
			this._ignoreChildChanges = true;
			this.postLayout();
			this._ignoreChildChanges = false;
		}
	}
	
	/**
	 * Makes final changes to the layout before it updates the item
	 * renderer's children. If your layout requires changing the
	 * <code>layoutData</code> property on the item renderer's
	 * sub-components, override the <code>preLayout()</code> function to
	 * make those changes.
	 *
	 * <p>In subclasses, if you create properties that affect the layout,
	 * invalidate using <code>INVALIDATION_FLAG_LAYOUT</code> to trigger a
	 * call to the <code>preLayout()</code> function when the component
	 * validates.</p>
	 *
	 * <p>The final width and height of the item renderer are not yet known
	 * when this function is called. It is meant mainly for adjusting values
	 * used by fluid layouts, such as constraints or percentages. If you
	 * need io access the final width and height of the item renderer,
	 * override the <code>postLayout()</code> function instead.</p>
	 *
	 * @see #postLayout()
	 */
	private function preLayout():Void
	{
		
	}

	/**
	 * Called after the layout updates the item renderer's children. If any
	 * children are excluded from the layout, you can update them in the
	 * <code>postLayout()</code> function if you need to use the final width
	 * and height in any calculations.
	 *
	 * <p>In subclasses, if you create properties that affect the layout,
	 * invalidate using <code>INVALIDATION_FLAG_LAYOUT</code> to trigger a
	 * call to the <code>postLayout()</code> function when the component
	 * validates.</p>
	 *
	 * <p>To make changes to the layout before it updates the item
	 * renderer's children, override the <code>preLayout()</code> function
	 * instead.</p>
	 *
	 * @see #preLayout()
	 */
	private function postLayout():Void
	{
		
	}

	/**
	 * Updates the renderer to display the item's data. Override this
	 * function to pass data to sub-components and react to data changes.
	 *
	 * <p>Don't forget to handle the case where the data is <code>null</code>.</p>
	 */
	private function commitData():Void
	{
		
	}
	
	/**
	 * @private
	 */
	override function getCurrentBackgroundSkin():DisplayObject
	{
		if (!this._isEnabled && this._backgroundDisabledSkin != null)
		{
			return this._backgroundDisabledSkin;
		}
		if (this._isSelected && this._backgroundSelectedSkin != null)
		{
			return this._backgroundSelectedSkin;
		}
		return this._backgroundSkin;
	}
	
}