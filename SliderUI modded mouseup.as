﻿package {
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;	

	//
	// 	This SliderUI has been modified to only return its value on MouseUp, NOT every 10 ms like the original does!
	//
	
	public class SliderUI 
	{
//- PRIVATE & PROTECTED VARIABLES -------------------------------------------------------------------------

		private var _stage:Stage;
		private var _track:Sprite;
		private var _slider:Sprite;
		private var _percent:Number;
		private var _lowVal:Number;
		private var _highVal:Number;
		private var _startVal:Number;
		private var _currentVal:Number;
		private var _range:Number;
		private var _axis:String;
		private var _changeProp:String;
		
//- PUBLIC & INTERNAL VARIABLES ---------------------------------------------------------------------------
		
		
		
//- CONSTRUCTOR	-------------------------------------------------------------------------------------------
	
		/**
		 * Creates an instance of the SliderUI with the given parameters.  If the $startVal parameter is set to something
		 * higher than the $highVal or lower than the $lowVal parameter, the $startVal parameter is reset to one of those two values.
		 * 
		 * @param $stage The stage that the track and slider are sitting on
		 * @param $axis The axis that the slider will be used on
		 * @param $track The track to be used for the slider
		 * @param $slider The object that will function as the slider
		 * @param $lowVal A number representing the low value of the slider
		 * @param $highVal A number representing the high value of the slider
		 * @param $startVal A number representing the value the slider should start at (default: 0)
		 * 
		 * @return void
		 */
		public function SliderUI($stage:Stage, $axis:String, $track:Sprite, $slider:Sprite, $lowVal:Number, $highVal:Number, $startVal:Number = 0):void
		{
			this._stage = $stage;
			this._axis = $axis;
			this._track = $track;
			this._slider = $slider;
			this._lowVal = $lowVal;
			this._highVal = $highVal;
			this._startVal = $startVal;
			
			this._changeProp = (this._axis == "x") ? "width" : "height";
			this._range = (Math.abs(this._lowVal) + this._highVal);
			this._slider.buttonMode = true;
			
			if (this._startVal < this._lowVal) this._startVal = this._lowVal;
			if (this._startVal > this._highVal) this._startVal = this._highVal;
			
			if (this._startVal < 0)
			{
				this._percent = (Math.abs(this._lowVal + Math.abs(this._startVal)) / this._range);
			}
			else
			{
				this._percent = (Math.abs(this._lowVal - this._startVal) / this._range);
			}
			
			this._currentVal = (this._lowVal + (this._range * this._percent));
			
			if (this._axis == "x")
			{
				this._slider[this._axis] = (this._track[this._axis] + (this._percent * this._track[this._changeProp]));
			}
			else
			{
				this._slider[this._axis] = (this._track[this._axis] - (this._percent * this._track[this._changeProp]));
			}
			
			
			this.initEvents();
		}
		
//- PRIVATE & PROTECTED METHODS ---------------------------------------------------------------------------
		
		/**
		 * Initializes the slider and timer events.
		 */
		private function initEvents():void
		{
			this._slider.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			this._slider.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
		}
		
//- PUBLIC & INTERNAL METHODS -----------------------------------------------------------------------------
	
		/**
		 * Enables the controls of the SliderUI.
		 * 
		 * @return void
		 */
		public function enable():void
		{
			this.initEvents();
		}
		
		/**
		 * Disables the controls of the SliderUI.
		 * 
		 * @return void
		 */
		public function disable():void
		{
			this._slider.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			this._slider.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
		}
		
		/**
		 * Cleans up the SliderUI for garbage collection.
		 * 
		 * @return void
		 */
		public function destroy():void
		{
			this.disable();
		}
	
//- EVENT HANDLERS ----------------------------------------------------------------------------------------
	
		/**
		 * Starts the dragging of the slider and starts the timer to dispatch percentage.
		 */
		private function handleMouseDown($evt:MouseEvent):void
		{
			if (this._axis == "x")
			{
				this._slider.startDrag(false, new Rectangle(this._track.x, this._slider.y, this._track.width, 0));
			}
			else
			{
				this._slider.startDrag(false, new Rectangle(this._slider.x, this._track.y, 0, -this._track.height));
			}
			
			this._stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
		}
		
		/**
		 * Stops the slider dragging and timer.
		 */
		private function handleMouseUp($evt:MouseEvent):void
		{
			this._slider.stopDrag();
		
			this._stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			
			this._percent = Math.abs((this._slider[this._axis] - this._track[this._axis]) / this._track[this._changeProp]);
			this._currentVal = (this._lowVal + (this._range * this._percent));
			
			Trngls.trngls.generateNew($evt);
		}
		

//- GETTERS & SETTERS -------------------------------------------------------------------------------------
	
		/**
		 * Returns the percentage of the slider's position on the track, between 0 and 1.
		 * 
		 * @return Number
		 */
		public function get percent():Number
		{
		    return this._percent;
		}
		
		/**
		 * Returns the current value of the slider's position on the track.
		 * 
		 * @return Number
		 */
		public function get currentValue():Number
		{
		    return this._currentVal;
		}
	
//- HELPERS -----------------------------------------------------------------------------------------------
	
		public function toString():String
		{
			return getQualifiedClassName(this);
		}
	
//- END CLASS ---------------------------------------------------------------------------------------------
	}
}