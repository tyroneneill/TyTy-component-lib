//------------------------------------------------------------------------------
//
//Copyright (c) 2011 the original author or authors. All Rights Reserved.   
//  
//NOTICE: You are permitted you to use, modify, and distribute this file   
//in accordance with the terms of the license agreement accompanying it.  
// 
//Author: Tyrone Neill  
//
//------------------------------------------------------------------------------

package com.tyroneneill.components.spinners
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import spark.primitives.Graphic;

	/**
	 * Snake Circle
	 *
	 * 	- Originally inspired by a piece of work from Erik Holander
	 *    which seems to have dissapeared off the web.
	 *
	 *  - The goal here is to be simple and performant.
	 *
	 *  - You spin me right round
	 *
	 * @author tyroneneill
	 *
	 */
	public class SnakeCircle extends Sprite
	{

		//------------------------------------------------------------------------------
		//
		//   Public Properties 
		//
		//------------------------------------------------------------------------------

		//--------------------------------------
		// clockwise 
		//--------------------------------------

		private var _clockwise:Boolean = true;

		public function get clockwise():Boolean
		{
			return _clockwise;
		}

		public function set clockwise(value:Boolean):void
		{
			if (_clockwise == value)
				return;

			_clockwise = value;
			drawSnake();
		}

		//--------------------------------------
		// fillColor 
		//--------------------------------------

		private var _fillColor:uint = 0xFF7575;

		public function get fillColor():uint
		{
			return _fillColor;
		}

		public function set fillColor(value:uint):void
		{
			if (_fillColor == value)
				return;

			_fillColor = value;
			drawSnake();
		}

		//--------------------------------------
		// lineWidth 
		//--------------------------------------

		private var _lineWidth:Number = 6;

		public function get lineWidth():Number
		{
			return _lineWidth;
		}

		public function set lineWidth(value:Number):void
		{
			if (_lineWidth == value)
				return;

			_lineWidth = value;
			drawSnake();
		}

		//--------------------------------------
		// radius 
		//--------------------------------------

		private var _radius:Number = 30;

		public function get radius():Number
		{
			return _radius;
		}

		public function set radius(value:Number):void
		{
			if (_radius == value)
				return;

			_radius = value;
			drawSnake();
		}

		/**
		 *  Rotation Speed
		 *  @public
		 */
		public var speed:uint = 14;

		//------------------------------------------------------------------------------
		//
		//   Protected Properties 
		//
		//------------------------------------------------------------------------------

		protected var spinDelay:Number;

		protected var spinTimer:Timer;

		//------------------------------------------------------------------------------
		//
		//   Private Properties 
		//
		//------------------------------------------------------------------------------

		private var holder:Shape = new Shape();

		private var running:Boolean;

		//------------------------------------------------------------------------------
		//
		//   Constructor 
		//
		//------------------------------------------------------------------------------

		public function SnakeCircle(parent:DisplayObjectContainer):void
		{
			parent && parent.addChild(this);
			this.addChild(holder);

			drawSnake();
		}


		//------------------------------------------------------------------------------
		//
		//   Public Functions 
		//
		//------------------------------------------------------------------------------

		public function start():void
		{
			if (running)
				return;

			this.addEventListener(Event.ENTER_FRAME, updateSnake);
			running = true;
		}

		public function stop():void
		{
			if (!running)
				return;

			running = false;

			this.removeEventListener(Event.ENTER_FRAME, updateSnake);
			running = false;
		}

		//------------------------------------------------------------------------------
		//
		//   Protected Functions 
		//
		//------------------------------------------------------------------------------

		protected function drawSnake():void
		{
			const tg:Graphics = holder.graphics;
			tg.clear();

			const numCircles:Number = (radius - (lineWidth * 2)) * 10;
			const radians:Number = (360 / numCircles) * Math.PI / 180;
			const radiusPlusCircle:Number = (lineWidth + radius);
			const alphaChange:Number = (1 / numCircles);

			for (var i:int = 0; i < numCircles; i++)
			{
				drawCircle(
					(radiusPlusCircle + Math.sin(radians * i) * radius), 
					(radiusPlusCircle + Math.cos(radians * i) * radius), 
					(i * alphaChange));
			}
			positionSnake();
		}

		//------------------------------------------------------------------------------
		//
		//   Private Functions 
		//
		//------------------------------------------------------------------------------

		private function drawCircle(xPos:Number, yPos:Number, alpha:Number):void
		{
			const drawAlpha:Number = clockwise 
				? (1 - (alpha)) 
				: alpha;

			const tg:Graphics = holder.graphics;
			tg.beginFill(fillColor, drawAlpha);
			tg.drawCircle(xPos, yPos, lineWidth);
			tg.endFill();
		}

		private function positionSnake():void
		{
			const halfWidth:Number = holder.width / 2;
			const halfHeight:Number = holder.height / 2;

			holder.x = -halfWidth;
			holder.y = -halfHeight;
		}

		private function updateSnake(e:Event):void
		{
			clockwise 
				? (this.rotation += speed) 
				: (this.rotation -= speed);
		}
	}
}
