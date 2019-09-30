package com.maptype.vo
{
	import flash.geom.Point;

	
	/**
	 * 自定义Point类,用于序列化
	 * @author 王明凡
	 */
	[RemoteClass]
	public class PointVO extends Object
	{
		private var _x:int;
		
		private var _y:int;
		
		public function PointVO(x:Number=0, y:Number=0)
		{
			this._x=x;
			this._y=y;
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
	}
}