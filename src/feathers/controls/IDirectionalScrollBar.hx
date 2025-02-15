/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;

/**
 * A scroll bar that supports both horizontal or vertical orientations. The
 * <code>feathers.controls.Scroller</code> class (and all subclasses) will
 * automatically set the <code>direction</code> property when an
 * <code>IDirectionalScrollBar</code> is returned by its scroll bar
 * factories.
 *
 * @productversion Feathers 2.0.0
 */
interface IDirectionalScrollBar extends IScrollBar
{
	/**
	 * The direction of the scroll bar, either horizontal or vertical.
	 *
	 * @see feathers.layout.Direction#HORIZONTAL
	 * @see feathers.layout.Direction#VERTICAL
	 */
	public var direction(get, set):String;
}