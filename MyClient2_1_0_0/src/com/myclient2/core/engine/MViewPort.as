/**
 * copyright © 2010 王明凡,MyClient2引擎著作权受到法律和国际公约保护
 * 使用MyClient2引擎之前必须签订"MyClient2产品-授权协议"，以及遵守"MyClient2产品-授权协议"才能使用
 * */
package com.myclient2.core.engine
{	
	/**
	 * 地图观察口,通过设置设置观察口的x,y指定地图在容器中的显示位置
	 * @author 王明凡
	 */
	public class MViewPort
	{
		private var _x:Number;
		
		private var _y:Number;
				
		/**
		 * 构造函数
		 * @param x
		 * @param y
		 */
		public function MViewPort(x:Number = 0,y:Number = 0)
		{
			_x=x;
			_y=y;
		}
		/**
		 * 设置观察口的x位置
		 * @param x
		 */
		public function set x(x:Number):void
		{
			_x=x;
		}
		/**
		 * 返回观察口的x位置
		 * @return 
		 */
		public function get x():Number
		{
			return _x;
		}
		/**
		 * 设置观察口的y位置
		 * @param y
		 */
		public function set y(y:Number):void
		{
			_y=y;
		}
		/**
		 * 返回观察口的y位置
		 * @return 
		 */
		public function get y():Number
		{
			return _y;
		}		
	}
}