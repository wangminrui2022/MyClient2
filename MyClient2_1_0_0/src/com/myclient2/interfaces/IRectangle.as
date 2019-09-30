/**
 * copyright © 2010 王明凡,MyClient2引擎著作权受到法律和国际公约保护
 * 使用MyClient2引擎之前必须签订"MyClient2产品-授权协议"，以及遵守"MyClient2产品-授权协议"才能使用
 * */
package com.myclient2.interfaces
{
	import flash.geom.Rectangle;
	
	/**
	 * IRectangle接口按其位置（由它左上角的点 (x, y) 确定）以及宽度和高度定义的区域
	 * @author 王明凡
	 */	
	public interface IRectangle
	{
		/**
		 * 返回当前(x,y,width,height)的矩形区域
		 * @return 
		 */		
		function getRectangle():Rectangle; 
	}
}