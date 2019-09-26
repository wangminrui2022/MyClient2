/**
 * copyright © 2010 黑色闪电工作室,www.heiseshandian.com,MyClient2引擎著作权受到法律和国际公约保护
 * 使用MyClient2引擎之前必须签订"MyClient2产品-授权协议"，以及遵守"MyClient2产品-授权协议"才能使用
 * */
package com.myclient2.core
{
	import flash.geom.Rectangle;
	
	import com.myclient2.interfaces.IRectangle;

	/**
	 * MRectangle按其位置（由它左上角的点 (x, y) 确定）以及宽度和高度定义的区域
	 * @author 王明凡
	 */	
	public class MRectangle implements IRectangle
	{
		private var _x:Number;
		private var _y:Number;
		private var _width:Number;
		private var _height:Number;
		
		/**
		 * 构造函数
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 */
		public function MRectangle(x:Number = 0,y:Number = 0,width:Number = 0,height:Number = 0)
		{
			_x=x;
			_y=y;
			_width=width;
			_height=height;
		}
		/**
		 * 返回当前(x,y,width,height)的矩形区域
		 * @return 
		 */	
		public function getRectangle():Rectangle
		{
			return new Rectangle(x,y,width,height);
		}
		/**
		 * 设置矩形区域的x位置
		 * @param x
		 */
		public function set x(x:Number):void
		{
			_x=x;
		}
		/**
		 * 返回矩形区域的x位置
		 * @return 
		 */
		public function get x():Number
		{
			return _x;
		}
		/**
		 * 设置矩形区域的y位置
		 * @param y
		 */
		public function set y(y:Number):void
		{
			_y=y;
		}
		/**
		 * 返回矩形区域的y位置
		 * @return 
		 */
		public function get y():Number
		{
			return _y;
		}
		/**
		 * 设置矩形的宽
		 * @param width
		 */
		public function set width(width:Number):void
		{
			_width=width;
		}
		/**
		 * 返回矩形的宽
		 * @return 
		 */
		public function get width():Number
		{
			return _width;
		}
		/**
		 * 设置矩形的高
		 * @param height
		 */
		public function set height(height:Number):void
		{
			_height=height;
		}
		/**
		 * 返回矩形的高
		 * @return 
		 */
		public function get height():Number
		{
			return _height;
		}						
	}
}