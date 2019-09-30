package com.maptype.vo
{
	/**
	 * 自定义Rectangle类,用于序列化
	 * @author 王明凡
	 */
	[RemoteClass]
	public class RectangleVO extends Object
	{
		private var _x:int;
		
		private var _y:int;
		
		private var _width:int;
		
		private var _height:int;
				
		public function RectangleVO(x:Number=0, y:Number=0, width:Number=0, height:Number=0)
		{
			_x=x;
			_y=y;
			_width=width;
			_height=height;
		}
		/**
		 * 设置x参数
		 * @param x
		 */
		public function set x(x:Number):void
		{	
			_x=x;
		}
		/**
		 * 获得x参数
		 * @return 
		 */
		public function get x():Number
		{	
			return _x;
		}	
		/**
		 * 设置y参数
		 * @param y
		 */
		public function set y(y:Number):void
		{	
			_y=y;
		}
		/**
		 * 获得y参数
		 * @return 
		 */
		public function get y():Number
		{	
			return _y;
		}
		/**
		 * 设置width参数
		 * @param width
		 */
		public function set width(width:Number):void
		{	
			_width=width;
		}
		/**
		 * 获得width参数
		 * @return 
		 */
		public function get width():Number
		{	
			return _width;
		}	
		/**
		 * 设置height参数
		 * @param height
		 */
		public function set height(height:Number):void
		{
			_height=height;
		}
		/**
		 * 获得height参数
		 * @return 
		 */
		public function get height():Number
		{
			return _height;
		}								
	}
}